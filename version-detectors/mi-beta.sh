
get_version() {
    curl -sL 'https://www.mimikaki.net/download/appcast_beta.xml' \
        | xmllint --xpath "string(/rss/channel/item[1]/enclosure/@*[local-name()='shortVersionString'])" - \
        | sed -E 's/(.*)\((.*)\)/\1/'
}

fetch_file() {
    curl "https://www.mimikaki.net/download/mi$1.dmg"
}
