
get_version() {
    REQ_PARAMS=architecture=x64
    REQ_PARAMS="$REQ_PARAMS&image_type=jdk"
    REQ_PARAMS="$REQ_PARAMS&jvm_impl=hotspot"
    REQ_PARAMS="$REQ_PARAMS&os=mac"
    REQ_PARAMS="$REQ_PARAMS&page_size=1"
    REQ_PARAMS="$REQ_PARAMS&project=jdk"
    REQ_PARAMS="$REQ_PARAMS&release_type=ga"
    REQ_PARAMS="$REQ_PARAMS&vendor=adoptium"
    REQ_PARAMS="$REQ_PARAMS&version=%5B11,12%29"

    curl -sL "https://api.adoptium.net/v3/info/release_versions?$REQ_PARAMS" -H 'accept: application/json' \
            | jq -r '.versions[0].openjdk_version' \
            | sed -e 's/+/,/'
}

fetch_file() {
    before_comma="${1%%,*}"
    after_comma="${1#*,}"
    after_comma_before_colon="${after_comma%%:*}"
    after_colon="${1#*:}"
    curl -L "https://github.com/AdoptOpenJDK/openjdk8-binaries/releases/download/\
jdk${before_comma}u${after_comma_before_colon}-${after_colon}/\
OpenJDK${before_comma}U-jdk_x64_mac_hotspot_${before_comma}u${after_comma_before_colon}${after_colon}.pkg"
}
