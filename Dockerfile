########################################################################################
#                               BUILDER IMAGE                                          #
########################################################################################
FROM public.ecr.aws/ubuntu/ubuntu:20.04 AS builder
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends cmake build-essential autoconf libtool pkg-config g++ gcc git ca-certificates wget unzip ffmpeg \
	libx265-dev libavutil-dev libavcodec-dev libavformat-dev libswscale-dev libavresample-dev \
	&& rm -rf /var/lib/apt/lists/*

#Install gRPC
WORKDIR /
RUN wget https://github.com/opencv/opencv/archive/refs/tags/4.5.5.zip && unzip 4.5.5.zip

WORKDIR /build

RUN cmake -D CMAKE_BUILD_TYPE=Release \
	-D CMAKE_INSTALL_PREFIX=/usr \
	-D BUILD_SHARED_LIBS=OFF \
	-D OPENCV_GENERATE_PKGCONFIG=ON \
	-D BUILD_TESTS=OFF \
	-D BUILD_EXAMPLES=OFF \
	-D BUILD_opencv_apps=OFF \
	-D WITH_FFMPEG=ON \
	/opencv-4.5.5
RUN make -j20
RUN DESTDIR=/install make install

WORKDIR /artifacts
ENTRYPOINT tar -czvf opencv-4.5.5.tar.gz -C /install .

