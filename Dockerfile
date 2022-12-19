########################################################################################
#                               BUILDER IMAGE                                          #
########################################################################################
FROM public.ecr.aws/ubuntu/ubuntu:20.04 AS builder
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends cmake build-essential autoconf libtool pkg-config g++ gcc git ca-certificates wget unzip \
	&& rm -rf /var/lib/apt/lists/*

ARG OPENCV_VERSION=4.6.0
ENV OPENCV_VERSION=$OPENCV_VERSION

#Install gRPC
WORKDIR /
RUN wget https://github.com/opencv/opencv/archive/refs/tags/${OPENCV_VERSION}.zip && unzip ${OPENCV_VERSION}.zip

WORKDIR /build
RUN cmake -DCMAKE_BUILD_TYPE=Release \
        -DBUILD_PROTOBUF=OFF \
        -DWITH_PROTOBUF=OFF \
	-DCMAKE_INSTALL_PREFIX=/usr \
	-DBUILD_SHARED_LIBS=OFF \
	-DOPENCV_GENERATE_PKGCONFIG=ON \
	-DBUILD_TESTS=OFF \
	-DBUILD_EXAMPLES=OFF \
	-DBUILD_opencv_apps=OFF \
	/opencv-${OPENCV_VERSION}
RUN make -j20
RUN DESTDIR=/install make install

WORKDIR /artifacts
ENTRYPOINT tar -czvf opencv-${OPENCV_VERSION}.tar.gz -C /install .

