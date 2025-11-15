#!/bin/bash
set -euo pipefail

: "${MEDIAWIKI_HOME:=/var/www/html}"
: "${MEDIAWIKI_CONFIG_PATH:=/config/LocalSettings.php}"
: "${MEDIAWIKI_CUSTOM_COMMAND:=}"

copy_config() {
    if [[ -f "$MEDIAWIKI_CONFIG_PATH" ]]; then
        cp "$MEDIAWIKI_CONFIG_PATH" "$MEDIAWIKI_HOME/LocalSettings.php"
        chown www-data:www-data "$MEDIAWIKI_HOME/LocalSettings.php"
    fi
}

main() {
    copy_config

    if [[ -n "$MEDIAWIKI_CUSTOM_COMMAND" ]]; then
        exec bash -c "$MEDIAWIKI_CUSTOM_COMMAND"
    fi

    if [[ $# -gt 0 ]]; then
        exec "$@"
    fi

    exec apache2-foreground
}

main "$@"
