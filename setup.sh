#!/bin/bash

already_installed() {
    echo -e "[\e[32mOK\e[39m] Starting Qt..."
    /home/user/Qt/Tools/QtCreator/bin/qtcreator
    exit
}

install_qt() {
    echo -e "[\e[32mOK\e[39m] Starting installer..."
    /tmp/qt_download/qt-unified-linux-x64-online.run --no-size-checking
}

[ -f "/home/user/Qt/Tools/QtCreator/bin/qtcreator" ] && already_installed || install_qt