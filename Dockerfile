FROM rocm/pytorch:rocm6.4.1_ubuntu22.04_py3.10_pytorch_release_2.3.0

RUN apt-get update \
  && apt-get -y install nano ffmpeg libomp-dev \
  && apt-get clean && rm -rf /var/lib/apt/lists/*

COPY src /src

WORKDIR /src
RUN git clone https://github.com/kprinssu/CTranslate2-rocm.git --recurse-submodules \
  && ./build.sh \
  && rm -rf CTranslate2-rocm


ENTRYPOINT ["/src/run.sh"]
