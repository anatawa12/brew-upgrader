
get_version() {
    curl -sL 'https://www.metaseq.net/en/download.html' \
        | grep -E 'href=".*Metasequoia-(.*)-Installer.dmg' \
        | head -1 \
        | sed -E 's/.*href=".*Metasequoia-(.*)-Installer.dmg".*/\1/'
}

fetch_file() {
    curl "https://www.metaseq.net/metaseq/Metasequoia-$1-Installer.dmg"
}
