FROM ubuntu:16.04

MAINTAINER Brian Low <brian.low22@gmail.com>

RUN apt-get update && apt-get install -y \
        build-essential \
        curl \
        g++ \
        git \
        libfreetype6-dev \
        libpng12-dev \
        libzmq3-dev \
        openjdk-8-jdk \
        pkg-config \
        python-dev \
        python-numpy \
        python-pip \
        software-properties-common \
        swig \
        unzip \
        zip \
        zlib1g-dev \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN update-ca-certificates -f

# Set up Bazel.

# Running bazel inside a `docker build` command causes trouble, cf:
#   https://github.com/bazelbuild/bazel/issues/134
# The easiest solution is to set up a bazelrc file forcing --batch.
RUN echo "startup --batch" >>/root/.bazelrc
# Similarly, we need to workaround sandboxing issues:
#   https://github.com/bazelbuild/bazel/issues/418
RUN echo "build --spawn_strategy=standalone --genrule_strategy=standalone" \
    >>/root/.bazelrc
ENV BAZELRC /root/.bazelrc


# Install the most recent bazel release.
WORKDIR /

RUN mkdir /bazel
RUN cd /bazel
RUN curl -fSsL -O https://github.com/bazelbuild/bazel/releases/download/0.2.2/bazel-0.2.2-installer-linux-x86_64.sh
RUN chmod +x bazel-*.sh
RUN ./bazel-0.2.2-installer-linux-x86_64.sh
RUN cd /
RUN rm -f /bazel/bazel-0.2.2-installer-linux-x86_64.sh

# Syntaxnet dependencies

RUN pip install -U protobuf==3.0.0b2
RUN pip install asciitree

# Download and build Syntaxnet

RUN git clone --recursive https://github.com/tensorflow/models.git /root/models
RUN cd /root/models/syntaxnet/tensorflow && echo | ./configure
RUN cd /root/models/syntaxnet && bazel test syntaxnet/... util/utf8/...

# Download custom conll build script
RUN cd /root/models/syntaxnet/ && curl -O https://raw.githubusercontent.com/rpbeltran/syntaxnet-docker/master/build_conll.sh

WORKDIR /root/models/syntaxnet/

CMD /root/models/syntaxnet/build_conll.sh

