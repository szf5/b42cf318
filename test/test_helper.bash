fixtures() {
  FIXTURE_ROOT="$BATS_TEST_DIRNAME/fixtures"
  RELATIVE_FIXTURE_ROOT="$(bats_trim_filename "$FIXTURE_ROOT")"
}

setup() {
  export TMP="$BATS_TEST_DIRNAME/tmp"
  for d in $(seq 0 20); do
    _date=$(date -d "$d days ago" "+%F")
    _dir="${TMP}/${_date}"
    test -d "${_dir}" || mkdir --verbose --parents "${_dir}"
    for h in $(seq -w 0 23); do
      # cd "$FIXTURE_ROOT"
      for src_file in "$FIXTURE_ROOT"/102?byte.dat; do
        dest_file="${_dir}/${h}-$(basename ${src_file})"
        test -e "${dest_file}" || cp --verbose "${src_file}" "${dest_file}"
        touch -m -d "$(date -d "${_date} ${h}:00:00")" "${dest_file}"
      done
    done
  done
}

filter_control_sequences() {
  "$@" | sed $'s,\x1b\\[[0-9;]*[a-zA-Z],,g'
}

# teardown() {
#   [ -d "$TMP" ] && rm -f "$TMP"/*
# }
