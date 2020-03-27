FROM ubuntu:bionic

LABEL maintainer="gil.balsiger@heig-vd.ch"

ENV QT_URL=http://download.qt.io/official_releases/online_installers/qt-unified-linux-x64-online.run
ENV QT_DOWNLOAD_DIR=/tmp/qt_download
ENV QT_INSTALL_DIR=/opt/Qt

ARG USER_ID
ARG GROUP_ID

RUN apt-get update -yqq && \
    apt-get install -yqq build-essential gcc git vim wget cmake libgtest-dev libqt5gui5 x11-apps

# Installation de Google Test
RUN cd /usr/src/gtest && \
    cmake CMakeLists.txt && \
    make -j4 && \
    ln -sf /usr/src/gtest/libgtest.a /usr/local/lib/libgtest.a

# Installation de Qt
RUN wget -q $QT_URL -P $QT_DOWNLOAD_DIR && \
    chmod +x $QT_DOWNLOAD_DIR/*.run

ADD setup.sh /usr/local/bin/setup
#COPY qt-5.12.7.tar.gz qt-5.12.7.tar.gz
#RUN tar -C /opt -zxf qt-5.12.7.tar.gz

VOLUME [ "/opt/Qt" ]

# RUN groupadd -f -g ${GROUP_ID} user
# RUN useradd -m -u ${USER_ID} -g ${GROUP_ID} user

# RUN chown -R ${USER_ID}:${GROUP_ID} /opt/qt

# USER user

# WORKDIR /home/user

CMD [ "/usr/local/bin/setup" ]