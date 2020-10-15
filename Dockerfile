FROM thyrlian/android-sdk:latest

# Install NDK
RUN yes | sdkmanager ndk-bundle

ENV ANDROID_SDK=$ANDROID_SDK_ROOT
ENV ANDROID_NDK=$ANDROID_SDK_ROOT/ndk-bundle

# Install dependencies
# - to build cmake (wget, git, ssl, build stuff)
# - to use aqt (python3, python3-pip)
# - ninja to use it to build with android ndk (seems recommended by google)
RUN apt update && apt -y install software-properties-common wget build-essential autoconf git fuse libssl-dev openssl python3 python3-pip ninja-build

# Build cool cmake version
ARG CMAKE=3.18.4
RUN wget -c -nv https://github.com/Kitware/CMake/releases/download/v${CMAKE}/cmake-${CMAKE}.tar.gz && \
    tar zxvf cmake-${CMAKE}.tar.gz   && \
    rm -rf cmake-${CMAKE}.tar.gz     && \
    cd cmake-${CMAKE}                && \
    ./configure                      && \
    make $(nproc)                    && \
    make install                     && \
    cd ..                            && \
    rm -rf cmake-${CMAKE}

# Download & Install Qt
ARG QT_VERSION=5.15.1
ARG QT_MODULES='qtcharts qtdatavis3d qtvirtualkeyboard qtwebengine qtquick3d'
ARG QT_HOST=linux
ARG QT_TARGET=android
ARG QT_ARCH=

RUN pip3 install aqtinstall && \
    aqt install --outputdir /opt/qt ${QT_VERSION} ${QT_HOST} ${QT_TARGET} ${QT_ARCH} -m ${QT_MODULES}

ENV PATH /opt/qt/${QT_VERSION}/android/bin:$PATH
ENV QT_PLUGIN_PATH /opt/qt/${QT_VERSION}/android/plugins/
ENV QML_IMPORT_PATH /opt/qt/${QT_VERSION}/android/qml/
ENV QML2_IMPORT_PATH /opt/qt/${QT_VERSION}/android/qml/
ENV Qt5_DIR /opt/qt/${QT_VERSION}/android/
ENV Qt5_Dir /opt/qt/${QT_VERSION}/android/
ENV Qt6_DIR /opt/qt/${QT_VERSION}/android/

# Remove style i'm not interested in
RUN rm -rf ${Qt5_DIR}/qml/QtQuick/Controls.2/designer  && \
    rm -rf ${Qt5_DIR}/qml/QtQuick/Controls.2/Fusion    && \
    rm -rf ${Qt5_DIR}/qml/QtQuick/Controls.2/Imagine   && \
    rm -rf ${Qt5_DIR}/qml/QtQuick/Controls.2/Universal

ARG ANDROID_API_LEVEL=30
ARG ANDROID_NDK_LEVEL=30.0.2

RUN sdkmanager "platforms;android-${ANDROID_API_LEVEL}" "build-tools;${ANDROID_NDK_LEVEL}"

WORKDIR /src