FROM ubuntu:bionic

LABEL maintainer="gil.balsiger@heig-vd.ch"

ENV QT_URL=http://download.qt.io/official_releases/online_installers/qt-unified-linux-x64-online.run
ENV QT_DOWNLOAD_DIR=/tmp/qt_download
ENV QT_INSTALL_DIR=/home/user/Qt

ARG USER_ID
ARG GROUP_ID

RUN apt-get update -yqq && \
    apt-get install -yqq build-essential gcc git vim wget cmake libgtest-dev libqt5gui5 x11-apps libgl-dev

# Installation de Google Test
RUN cd /usr/src/gtest && \
    cmake CMakeLists.txt && \
    make -j4 && \
    ln -sf /usr/src/gtest/libgtest.a /usr/local/lib/libgtest.a

# Installation de Qt
RUN wget -q $QT_URL -P $QT_DOWNLOAD_DIR && \
    chmod +x $QT_DOWNLOAD_DIR/*.run

COPY setup.sh /usr/local/bin/setup

RUN groupadd -f -g ${GROUP_ID} user
RUN useradd -m -u ${USER_ID} -g ${GROUP_ID} user

RUN mkdir -p /home/user/Qt ; mkdir -p /home/user/.config/QtProject ; mkdir -p /home/user/projects
RUN chown -R user:user /home/user

USER user

WORKDIR /home/user

VOLUME [ "/home/user/Qt" ]
VOLUME [ "/home/user/.config/QtProject" ]
VOLUME [ "/home/user/projects" ]

CMD [ "/usr/local/bin/setup" ]