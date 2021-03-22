
get_version() {
    curl -sL https://api.github.com/repos/AdoptOpenJDK/openjdk8-binaries/releases/latest \
            | jq -r .tag_name \
            | sed -E 's/jdk8u([0-9]+)-b([0-9]+).*/8,\1:b\2/'
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
