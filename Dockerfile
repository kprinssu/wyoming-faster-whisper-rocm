FROM rocm/pytorch:rocm6.3.2_ubuntu22.04_py3.10_pytorch_release_2.3.0

RUN apt-get update && apt-get -y install nano ffmpeg libomp-dev && pip install -U pip && pip install wyoming==1.6.0 faster-whisper==1.0.3 tokenizers==0.13.*

COPY src /src

WORKDIR /src
RUN git clone https://github.com/kprinssu/CTranslate2-rocm.git --recurse-submodules
RUN ./build.sh

ENTRYPOINT ["/src/run.sh"]
