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

install_pcosynchro() {
    PCOSYNCHRO_CLONE_DIR=/home/user/lib
    rm -rf $PCOSYNCHRO_CLONE_DIR
    git clone https://gitlab.com/reds-public/pco-synchro.git $PCOSYNCHRO_CLONE_DIR
    cd $PCOSYNCHRO_CLONE_DIR/lib/pcosynchro/
    /home/user/Qt/5.12.7/gcc_64/bin/qmake
    make -j4
    cd $PCOSYNCHRO_CLONE_DIR
    mkdir archive
    cp src/*.h archive
    cp lib/pcosynchro/*.a archive
    cd archive
    tar -czvf /home/user/pcosyncro/libpcosyncro-precompiled.tar.gz *
    #cp *.a /usr/local/lib/
    #ln -s $PCOSYNCHRO_CLONE_DIR/src /usr/local/include/pcosynchro
}

if [[ $1 -eq "update" ]]; then
    install_pcosynchro
else
    [ -f "${QT_INSTALL_DIR}/Tools/QtCreator/bin/qtcreator" ] && start_qt || install_qt
fi