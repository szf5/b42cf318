#!/usr/bin/env bash

if test "x$1" = 'x-h' -o "x$1" = 'x--help'; then
  echo Usage: "$0" [target_dir=/tmp] [size=10MiB] [day=10]
  exit 0
fi

declare -r out_file=out.tgz
declare -r target_dir="${1:-/tmp}" && shift

# _size=$(( 1023 - 1 )) # 1023 byte
# _size=$(( 1024 - 1 )) # 1024 byte
#_size=$(( (1024 * 1024 * 1024) - 1 )) # 1MiB
_size=$(( (10 * 1024 * 1024 * 1024) - 1)) # 10MiB
declare -i size="${_size}"
test 0 -lt $# && size=$(( $1 - 1 )) && shift

declare -i day="${1:-10}" && shift
test 0 -lt $# && day=$1 && shift
latest_date=$(date +"%F" -d "$day days ago")
day=$(( $day - 1 ))

declare -r list_of_files="$(mktemp)"
find "${target_dir}" -type f -size +${size}c -mtime +${day} | sort -k 11 > "${list_of_files}"
# tar cvfz "${out_file}" --files-from "${list_of_files}"

# 24h x 日数 以前であればここまででOK


# さらに mtime day に含まれるファイルからdayと同じ日付のもののみを抽出する
# xargs を使うと非常に危険な感じになりそうなので回避
declare -ar ldf=( $(find "${target_dir}" -type f -size +${size}c -mtime ${day}) )
for x in "${ldf[@]}"; do
  test "$latest_date" = "$(date +'%F' -r "$x")" && echo $x && echo "$x" >> "${list_of_files}"
done

# 最後に圧縮して終わり
sort "${list_of_files}" | uniq | tar cvfz --file "${out_file}" --files-from -

declare -p list_of_files
declare -p out_file

exit 0
