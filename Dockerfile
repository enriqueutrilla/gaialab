FROM registry.esa.int:5020/sepp/jl_base:v9.1915
ENV DEBIAN_FRONTEND noninteractive
COPY ./requirements.txt /tmp/

RUN apt-get update \
  && apt-get install --no-install-recommends -y \
  gcc g++ make \
  build-essential --no-install-recommends apt-utils \
  zip unzip curl git man wget make emacs vim \
  libffi-dev libzbar-dev libzbar0 \
  nodejs yarn\
  software-properties-common coreutils \
  python-xvfbwrapper python3-pytest-xvfb python3-xvfbwrapper xvfb \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

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
  && python -m pip --no-cache-dir install \
  jupyterlab==3.2.8 \
  jupyter_client==7.1.1 \
  terminado==0.12.1 \
  jupyterlab-git==0.34.2 \
  jupyterlab_theme_solarized_dark==2.0.1 \
  qtconsole==5.2.2 \
  IPython==8.0.0 \
  ipywidgets==7.6.5 \
  jupyter_core==4.9.1 \
  jupyter_server==1.13.3 \
  nbclient==0.5.10 \
  nbconvert==6.4.0 \
  nbformat==5.1.3 \
  notebook==6.4.7 \
  traitlets==5.1.1 \
  matplotlib==3.5.1 \
  pandas==1.4.0 \
  ipykernel==6.7.0 \
  ipyleaflet==0.15.0 \
  qtpy==2.0.0 \
  ipywidgets==7.6.5 \
  lxml==4.7.1 \
  flask-cors==3.0.10 \
  beautifulsoup4==4.10.0 \
  configparser==5.2.0 \
  ipyevents==2.0.1 \
  astroquery==0.4.5 \
  astropy==5.0.1 \
  && jupyter labextension install @jupyter-widgets/jupyterlab-manager --no-build \
  && jupyter labextension install jupyter-matplotlib --no-build \
  && jupyter labextension install jupyter-leaflet --no-build \
  && jupyter lab build --minimize=False \
  && python -m pip --no-cache-dir install pyesasky==1.9.2 \
  && jupyter labextension install pyesasky --no-build \
  && jupyter lab build --minimize=False \
  && jupyter nbextension install --py pyesasky --sys-prefix \
  && jupyter nbextension enable --py pyesasky --sys-prefix \
  && jupyter lab build --minimize=False \
  && ln -s /opt/miniconda/etc/profile.d/conda.sh /etc/profile.d/conda.sh \
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
