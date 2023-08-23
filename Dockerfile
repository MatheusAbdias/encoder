FROM  alpine:3.18.0 as builder

ARG BENTO4_VERSION=v1.6.0-640

RUN apk update && apk add --no-cache \
  ca-certificates=20230506-r0 \
  bash=5.2.15-r5 \
  python3=3.11.4-r0 \
  make=4.4.1-r1 \
  cmake=3.26.5-r0 \
  gcc=12.2.1_git20220924-r10  \
  g++=12.2.1_git20220924-r10 \
  git=2.40.1-r0

WORKDIR /tmp/bento4
RUN git clone https://github.com/axiomatic-systems/Bento4 /tmp/bento4 \ 
  && git checkout $BENTO4_VERSION

RUN rm -rf /tmp/bento4/cmakebuild \
  && mkdir -p /tmp/bento4/cmakebuild/x86_64-unknown-linux 

WORKDIR /tmp/bento4/cmakebuild/x86_64-unknown-linux
RUN cmake -DCMAKE_BUILD_TYPE=Release ../.. && make


WORKDIR /tmp/bento4
RUN python3 Scripts/SdkPackager.py x86_64-unknown-linux . cmake \ 
  && mkdir /opt/bento4 \
  && mv /tmp/bento4/SDK/Bento4-SDK-*.x86_64-unknown-linux/* /opt/bento4



FROM golang:1.21.0-alpine3.18
ARG BENTO4_VERSION

ENV PATH=/opt/bento4/bin:${PATH}

RUN apk --no-cache add ca-certificates=20230506-r0 \
  bash=5.2.15-r5 \
  python3=3.11.4-r0 \
  libstdc++=12.2.1_git20220924-r10 \
  && rm -rf /var/cache/apk/*

COPY --from=builder /opt/bento4 /opt/bento4

WORKDIR /go/src

ENTRYPOINT [ "tail", "-f", "/dev/null" ]