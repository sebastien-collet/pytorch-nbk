FROM nvidia/cuda:9.2-cudnn7-devel-ubuntu16.04
ARG PYTHON_VERSION=3.6
RUN apt-get update && apt-get install -y --no-install-recommends \
         build-essential \
         cmake \
         git \
         curl \
         vim \
         ca-certificates \
         libjpeg-dev \
         libpng-dev &&\
     rm -rf /var/lib/apt/lists/*


RUN curl -o ~/miniconda.sh -O  https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh  && \
     chmod +x ~/miniconda.sh && \
     ~/miniconda.sh -b -p /opt/conda && \
     rm ~/miniconda.sh && \
     /opt/conda/bin/conda install -y python=$PYTHON_VERSION numpy pyyaml scipy ipython mkl mkl-include cython typing && \
     /opt/conda/bin/conda install -y -c pytorch magma-cuda90 && \
     /opt/conda/bin/conda clean -ya
ENV PATH /opt/conda/bin:$PATH
# This must be done before pip so that requirements.txt is available

RUN pip install numpy torchvision_nightly
RUN pip install torch_nightly -f https://download.pytorch.org/whl/nightly/cu92/torch_nightly.html


#RUN git clone https://github.com/pytorch/vision.git && cd vision && pip install -v .
RUN pip install jupyterlab

WORKDIR /workspace
RUN chmod -R a+w /workspace

CMD jupyter-lab --ip=0.0.0.0 --port=8888 --allow-root

