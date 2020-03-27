#!/bin/bash

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root"
    exit 1
fi

# Upgrade from gcc 5 to gcc 7
gcc_upgrade() {
    add-apt-repository -y ppa:ubuntu-toolchain-r/test
    apt update
    apt install -y gcc-7 g++-7
    rm /usr/bin/g++
    rm /usr/bin/gcc
    ln -s /usr/bin/g++-7 /usr/bin/g++
    ln -s /usr/bin/gcc-7 /usr/bin/gcc
}

install_gtest() {
    apt install -y cmake cmake-qt-gui
    apt install -y libgtest-dev
    cd /usr/src/gtest
    cmake CMakeLists.txt
    make -j4
    ln -fs /usr/src/gtest/libgtest.a /usr/local/lib/libgtest.a
}

# Remove qtcreator and Qt libraries
qt_upgrade() {
    echo -e "\e[94m[INFO]\e[39m Purging old Qt libraries and utilites"
    apt purge -y qtcreator* qtbase5-* qt4-* qtcore4-* qtchooser

    QT_URL=http://download.qt.io/official_releases/online_installers/qt-unified-linux-x64-online.run
    QT_DOWNLOAD_DIR=/tmp/qt_download
    QT_INSTALL_DIR=/opt/Qt

    echo -e "\e[94m[INFO]\e[39m Downloading Qt online installer. Please wait..."
    wget $QT_URL -P $QT_DOWNLOAD_DIR

    echo -e "\e[94m[INFO]\e[39m Launching installer. Please follow the instructions we provided you !"
    chmod +x $QT_DOWNLOAD_DIR/*.run
    $QT_DOWNLOAD_DIR/*.run
}

# Add Qt binaries to path and keep it persistent
qt_path_update() {
    echo "PATH=\$PATH:$QT_INSTALL_DIR/5.12.7/gcc_64/bin/" > /etc/profile.d/qt_path_update.sh
    echo "PATH=\$PATH:$QT_INSTALL_DIR/Tools/QtCreator/bin/" >> /etc/profile.d/qt_path_update.sh
    source /etc/profile
}

# Update desktop entry
desktop_entry_update() {
    qtcreator_entry=/usr/share/applications/qtcreator.desktop

    rm -f $qtcreator_entry
    ln -s $QT_INSTALL_DIR/Tools/QtCreator/share/applications/org.qt-project.qtcreator.desktop \
        $qtcreator_entry
}

install_pcosynchro() {
    PCOSYNCHRO_CLONE_DIR=/usr/src/pcosynchro
    rm -f $PCOSYNCHRO_CLONE_DIR
    git clone https://gitlab.com/reds-public/pco-synchro.git $PCOSYNCHRO_CLONE_DIR
    cd $PCOSYNCHRO_CLONE_DIR/lib/pcosynchro/
    qmake
    make -j4
    make install
    #cp *.a /usr/local/lib/
    #ln -s $PCOSYNCHRO_CLONE_DIR/src /usr/local/include/pcosynchro
}

echo -e "\e[94m[INFO]\e[39m Upgrading GCC to version 5"
gcc_upgrade

echo -e "\e[94m[INFO]\e[39m Installing Google Test"
install_gtest

echo -e "\e[94m[INFO]\e[39m Upgrading qtcreator and Qt libraries to version 5.12"
qt_upgrade

echo -e "\e[94m[INFO]\e[39m Adding Qt binaires into PATH"
qt_path_update

echo -e "\e[94m[INFO]\e[39m Updating desktop entry"
desktop_entry_update

echo -e "\e[94m[INFO]\e[39m Compiling and installing pco-synchro library necessary for the labs and exercices"
install_pcosynchro

echo -e "\e[94m[INFO] \e[92mSuccess"
