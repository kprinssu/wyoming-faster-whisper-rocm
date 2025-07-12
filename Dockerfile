FROM rocm/pytorch:rocm6.4.1_ubuntu22.04_py3.10_pytorch_release_2.6.0 AS ctranslate2-build

# Set PYTORCH_ROCM_ARCH to set the target GPU architecture

WORKDIR /build
RUN git clone https://github.com/kprinssu/CTranslate2-rocm.git --recurse-submodules

WORKDIR /build/CTranslate2-rocm
ARG PYTORCH_ROCM_ARCH=""

RUN CLANG_CMAKE_CXX_COMPILER=clang++ CXX=clang++ HIPCXX="$(hipconfig -l)/clang" HIP_PATH="$(hipconfig -R)" \
    cmake -S . -B build -DWITH_MKL=OFF -DWITH_HIP=ON -DCMAKE_HIP_ARCHITECTURES=$PYTORCH_ROCM_ARCH -DBUILD_TESTS=ON -DWITH_CUDNN=ON

RUN cmake --build build -- -j16

RUN cd /build/CTranslate2-rocm/build \
  && cmake --install . --prefix /usr/local \
  && ldconfig

RUN cd /build/CTranslate2-rocm/python \
  && pip install -r install_requirements.txt \
  && python setup.py bdist_wheel

FROM rocm/pytorch:rocm6.4.1_ubuntu22.04_py3.10_pytorch_release_2.6.0
COPY --from=ctranslate2-build /build/CTranslate2-rocm/python/dist /app/ctranslate2-dist/


RUN apt-get update \
  && apt-get install -y --no-install-recommends nano ffmpeg libomp-dev \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

COPY src /app/src
RUN /app/src/build.sh

WORKDIR /app/src
ENTRYPOINT ["run.sh"]
