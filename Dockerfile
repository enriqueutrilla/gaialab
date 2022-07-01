FROM registry.esa.int:5020/sepp/jl_base:v9.1915
ENV DEBIAN_FRONTEND noninteractive
COPY ./requirements.txt /tmp/

RUN curl -fsSL -o Miniconda3-latest-Linux-x86_64.sh https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
  && bash Miniconda3-latest-Linux-x86_64.sh -b -p /opt/miniconda \
  && rm -rf Miniconda3-latest-Linux-x86_64.sh

ENV PATH /opt/miniconda/bin:$PATH
RUN echo "Updating python to 3.8" \
  && echo "/opt" \
  && ls -la /opt \
  && echo "/opt/miniconda" \
  && ls -la /opt/miniconda \
  && echo "/opt/miniconda/bin" \
  && ls -la /opt/miniconda/bin \ 
  && conda init \
  && conda config --append channels conda-forge \
  && conda install -c anaconda python=3.8 \
  && conda update --all \
#  && apt-get remove python3.6 -y \
#  && apt-get install python3.8=3.8.0-3ubuntu1~18.04.2 -y \
#  && apt-get remove python3-pip -y \
#  && update-alternatives --remove python3 /usr/bin/python3 \
#  && update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.8 10 \
#  && apt-get install python3-pip=9.0.1-2.3~ubuntu1.18.04.5 -y \
  && echo "Path: $PATH" \
#  && python3.8 -m pip install --no-cache-dir --upgrade pip==9.0.3 \
  && echo "Installing python dependencies" \
#  && pip3 install --no-cache-dir --upgrade -root /usr/local/lib/python3.8/dist-packages numpy==1.23.0 \
  && pip3 install --no-cache-dir --upgrade -r /tmp/requirements.txt \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

COPY *.ipynb /media/tutorials/
COPY *.png /media/tutorials/images/

COPY run.sh /opt/
RUN chmod +x /opt/run.sh

CMD   ["/sbin/tini", "--", "/opt/run.sh"]
