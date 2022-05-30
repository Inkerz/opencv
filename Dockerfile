########################################################################################
#                               BUILDER IMAGE                                          #
########################################################################################
FROM public.ecr.aws/ubuntu/ubuntu:20.04 AS builder
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends cmake build-essential autoconf libtool pkg-config g++ gcc git ca-certificates wget unzip \
	&& rm -rf /var/lib/apt/lists/*

#Install gRPC
WORKDIR /
RUN wget https://github.com/opencv/opencv/archive/refs/tags/4.5.5.zip && unzip 4.5.5.zip

WORKDIR /build
RUN cmake -DCMAKE_BUILD_TYPE=Release \
	-DCMAKE_INSTALL_PREFIX=/usr \
	-DBUILD_SHARED_LIBS=OFF \
	-DOPENCV_GENERATE_PKGCONFIG=ON \
	-DBUILD_TESTS=OFF \
	-DBUILD_EXAMPLES=OFF \
	-DBUILD_opencv_apps=OFF \
	/opencv-4.5.5
RUN make -j20
RUN DESTDIR=/install make install

WORKDIR /artifacts
ENTRYPOINT tar -czvf opencv-4.5.5.tar.gz -C /install .

