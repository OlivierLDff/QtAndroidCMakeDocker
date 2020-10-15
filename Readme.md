# 🐳 Qt Android docker

Ready to use environment to compile application using Qt/CMake and deploy apk.

* Qt 5.15.1
* CMake 3.18.4
* GCC 9
* Android SDK
* Android NDK
* Gradle

## How to use

This image is made to build cmake qt project for android, but it can also build qmake based.

### ⌨️ Interative bash

You can run an interactive bash to build whatever you need. Execute this command from you source folder, to map it to `/src` folder in the container.

```bash
# This folder will be mounted in the container as /src
cd /path/to/my/project

# Generate tag
export QT_VERSION=5.15.1
export ANDROID_API_LEVEL=30
export ANDROID_NDK_LEVEL=28.0.3
export DOCKER_TAG=qt${QT_VERSION}-api${ANDROID_API_LEVEL}-ndk${ANDROID_NDK_LEVEL}

# Start bash in the container
docker run -it --rm -v $(pwd):/src/ reivilo1234/qt-android-cmake:${DOCKER_TAG} bash
# Then regular cmake workflow
mkdir -p build && cd build
cmake \
-G "Ninja" \
-DCMAKE_TOOLCHAIN_FILE=$ANDROID_NDK/build/cmake/android.toolchain.cmake \
-DANDROID_ABI=armeabi-v7a \
-DANDROID_NATIVE_API_LEVEL=24 \
-DANDROID_TOOLCHAIN=clang \
-DANDROID_STL=c++_shared \
-DCMAKE_FIND_ROOT_PATH_MODE_PACKAGE=BOTH \
-DCMAKE_BUILD_TYPE=Release \
..

cmake --build . -j
# Build target will be available in /path/to/my/project/build/<target>-armeabi-v7a\build\outputs\apk\release or debug
# depending if you sign the apk or not.
```

### 🚀 Run only commands inside container

```bash
# Everything need to be executed in the same folder as CMakeLists.txt
# This folder will be mounted in the container as /src
cd /path/to/my/project

# Customize here your build folder name
export BUILD_DIR=build
export QT_VERSION=5.15.1
export ANDROID_API_LEVEL=30
export ANDROID_NDK_LEVEL=28.0.3
export DOCKER_TAG=qt${QT_VERSION}-api${ANDROID_API_LEVEL}-ndk${ANDROID_NDK_LEVEL}
# Create alias to run a command in the container
alias docker-run='docker run --rm -v $(pwd):/src/ reivilo1234/${DOCKER_TAG}'

# Create build directory in host
mkdir -p $BUILD_DIR
# Execute cmake in container
docker-run cmake -B ./$BUILD_DIR/ -S . -DANDROID_ABI=armeabi-v7a -DCMAKE_BUILD_TYPE=Release -DANDROID_NATIVE_API_LEVEL=30
# Execute make in container
docker-run make -C $BUILD_DIR -j
```

## 🔨 How to build Docker Image

Run in the same directory as the `Dockerfile`

**qt5.15.1-api30-ndk28.0.3**

> Recommended for Qt 5.15.1.


```bash
export QT_VERSION=5.15.1
export ANDROID_API_LEVEL=30
export ANDROID_NDK_LEVEL=28.0.3
export DOCKER_TAG=qt${QT_VERSION}-api${ANDROID_API_LEVEL}-ndk${ANDROID_NDK_LEVEL}
docker build --tag qt-android-cmake:$DOCKER_TAG \
--build-arg QT_VERSION=${QT_VERSION} \
--build-arg ANDROID_API_LEVEL=${ANDROID_API_LEVEL} \
--build-arg ANDROID_NDK_LEVEL=${ANDROID_NDK_LEVEL} \
 .
docker tag qt-android-cmake:$DOCKER_TAG reivilo1234/qt-android-cmake:$DOCKER_TAG
docker push reivilo1234/qt-android-cmake:$DOCKER_TAG
```

**qt5.15.1-api30-ndk30.0.2**


```bash
export QT_VERSION=5.15.1
export ANDROID_API_LEVEL=30
export ANDROID_NDK_LEVEL=30.0.2
export DOCKER_TAG=qt${QT_VERSION}-api${ANDROID_API_LEVEL}-ndk${ANDROID_NDK_LEVEL}
docker build --tag qt-android-cmake:$DOCKER_TAG \
--build-arg QT_VERSION=${QT_VERSION} \
--build-arg ANDROID_API_LEVEL=${ANDROID_API_LEVEL} \
--build-arg ANDROID_NDK_LEVEL=${ANDROID_NDK_LEVEL} \
 .
docker tag qt-android-cmake:$DOCKER_TAG reivilo1234/qt-android-cmake:$DOCKER_TAG
docker push reivilo1234/qt-android-cmake:$DOCKER_TAG
```

**qt5.15.1-api23-ndk28.0.3**


```bash
export QT_VERSION=5.15.1
export ANDROID_API_LEVEL=23
export ANDROID_NDK_LEVEL=28.0.3
export DOCKER_TAG=qt${QT_VERSION}-api${ANDROID_API_LEVEL}-ndk${ANDROID_NDK_LEVEL}
docker build --tag qt-android-cmake:$DOCKER_TAG \
--build-arg QT_VERSION=${QT_VERSION} \
--build-arg ANDROID_API_LEVEL=${ANDROID_API_LEVEL} \
--build-arg ANDROID_NDK_LEVEL=${ANDROID_NDK_LEVEL} \
 .
docker tag qt-android-cmake:$DOCKER_TAG reivilo1234/qt-android-cmake:$DOCKER_TAG
docker push reivilo1234/qt-android-cmake:$DOCKER_TAG
```
