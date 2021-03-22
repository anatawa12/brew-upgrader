
get_version() {
    curl -sL 'https://www.mimikaki.net/download/appcast.xml' \
        | xmllint --xpath "string(/rss/channel/item[1]/enclosure/@*[local-name()='shortVersionString'])" - \
        | sed -E 's/(.*)\((.*)\)/\1,\2/'
}

fetch_file() {
    before_comma="${1%%,*}"
    curl "https://www.mimikaki.net/download/mi$before_comma.dmg"
}
