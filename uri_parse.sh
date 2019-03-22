# Following regex is based on https://tools.ietf.org/html/rfc3986#appendix-B with
# additional sub-expressions to split authority into userinfo, host and port
#
readonly URI_REGEX='^(([^:/?#]+):)?(//((([^:/?#]+)@)?([^:/?#]+)(:([0-9]+))?))?(/([^?#]*))(\?([^#]*))?(#(.*))?'
#                    ↑↑            ↑  ↑↑↑            ↑         ↑ ↑            ↑ ↑        ↑  ↑        ↑ ↑
#                    |2 scheme     |  ||6 userinfo   7 host    | 9 port       | 11 rpath |  13 query | 15 fragment
#                    1 scheme:     |  |5 userinfo@             8 :…           10 path    12 ?…       14 #…
#                                  |  4 authority
#                                  3 //…

parse_scheme () {
    [[ "$@" =~ $URI_REGEX ]] && echo "${BASH_REMATCH[2]}"
}

parse_authority () {
    [[ "$@" =~ $URI_REGEX ]] && echo "${BASH_REMATCH[4]}"
}

parse_user () {
    [[ "$@" =~ $URI_REGEX ]] && echo "${BASH_REMATCH[6]}"
}

parse_host () {
    [[ "$@" =~ $URI_REGEX ]] && echo "${BASH_REMATCH[7]}"
}

parse_port () {
    [[ "$@" =~ $URI_REGEX ]] && echo "${BASH_REMATCH[9]}"
}

parse_path () {
    [[ "$@" =~ $URI_REGEX ]] && echo "${BASH_REMATCH[10]}"
}

parse_rpath () {
    [[ "$@" =~ $URI_REGEX ]] && echo "${BASH_REMATCH[11]}"
}

parse_query () {
    [[ "$@" =~ $URI_REGEX ]] && echo "${BASH_REMATCH[13]}"
}

parse_fragment () {
    [[ "$@" =~ $URI_REGEX ]] && echo "${BASH_REMATCH[15]}"
}