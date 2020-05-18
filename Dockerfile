FROM ubuntu:bionic

LABEL maintainer="gil.balsiger@heig-vd.ch"

ENV QT_URL=http://download.qt.io/official_releases/online_installers/qt-unified-linux-x64-online.run
ENV QT_DOWNLOAD_DIR=/tmp/qt_download
ENV QT_INSTALL_DIR=/home/user/Qt

ARG USER_ID
ARG GROUP_ID

# Installation de dépendances
RUN apt-get update -yqq && \
    apt-get install -yqq build-essential gcc gdb git vim wget unzip \
    cmake libgtest-dev libqt5gui5 libqt5multimedia5 libpulse-mainloop-glib0 x11-apps libgl-dev xterm mesa-utils

# Installation de Google Test
RUN cd /usr/src/gtest && \
    cmake CMakeLists.txt && \
    make -j4 && \
    ln -sf /usr/src/gtest/libgtest.a /usr/local/lib/libgtest.a

COPY ./pcosyncro/libpcosyncro-precompiled.tar.gz ./libpcosyncro-precompiled.tar.gz

# Installation de PcoSyncro
RUN mkdir -p libpcosyncro && \
    tar -C libpcosyncro -zxf libpcosyncro-precompiled.tar.gz && \
    chmod -R 777 libpcosyncro && \
    mkdir -p /usr/local/include/pcosynchro && \
    mv libpcosyncro/*.h /usr/local/include/pcosynchro && \
    mv libpcosyncro/*.a /usr/local/lib && \
    rm -rf libpcosyncro libpcosyncro-precompiled.tar.gz

# Chargement le l'installateur de Qt 
RUN wget -q $QT_URL -P $QT_DOWNLOAD_DIR && \
    chmod +x $QT_DOWNLOAD_DIR/*.run

# Installation de la police JetBrains Mono (https://www.jetbrains.com/lp/mono/)
RUN wget -q https://download.jetbrains.com/fonts/JetBrainsMono-1.0.3.zip && \
    unzip JetBrainsMono-1.0.3.zip && \
    cp JetBrainsMono-1.0.3/ttf/*.ttf /usr/share/fonts && \
    fc-cache -f -v && \
    rm -rf JetBrainsMono-1.0.3 JetBrainsMono-1.0.3.zip

RUN groupadd -f -g ${GROUP_ID} user
RUN useradd -m -u ${USER_ID} -g ${GROUP_ID} user

RUN mkdir -p /home/user/Qt ; mkdir -p /home/user/.config/QtProject ; mkdir -p /home/user/projects
RUN chown -R user:user /home/user

USER user

WORKDIR /home/user

VOLUME [ "/home/user/Qt" ]
VOLUME [ "/home/user/.config/QtProject" ]
VOLUME [ "/home/user/projects" ]
VOLUME [ "/home/user/pcosyncro" ]

COPY ./entrypoint.sh ./entrypoint.sh

CMD [ "./entrypoint.sh" ]
