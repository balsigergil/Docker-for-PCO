#!/bin/bash

start_qt() {
    echo -e "[\e[32mOK\e[39m] Starting Qt..."
    ${QT_INSTALL_DIR}/Tools/QtCreator/bin/qtcreator
    exit
}

install_qt() {
    echo -e "[\e[32mOK\e[39m] Starting installer..."
    /tmp/qt_download/qt-unified-linux-x64-online.run --no-size-checking
    start_qt
}

[ -f "${QT_INSTALL_DIR}/Tools/QtCreator/bin/qtcreator" ] && start_qt || install_qt