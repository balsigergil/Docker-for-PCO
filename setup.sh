#!/bin/bash

aleary_installed() {
    echo -e "[\e[32mOK\e[39m] Starting Qt..."
    /opt/Qt/Tools/QtCreator/bin/qtcreator
    exit
}

install_qt() {
    echo -e "[\e[32mOK\e[39m] Installer started..."
    /tmp/qt_download/qt-unified-linux-x64-online.run --no-size-checking
}

[ -f "/opt/Qt/Tools/QtCreator/bin/qtcreator" ] && aleary_installed || install_qt