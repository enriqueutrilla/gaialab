FROM registry.esa.int:5020/sepp/jl_base:v9.1915
ENV DEBIAN_FRONTEND noninteractive
COPY ./requirements.txt /tmp/
RUN apt-get update \
  && pip3 install --no-cache-dir -r /tmp/requirements.txt \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

COPY *.ipynb /media/notebooks/tutorials/
USER $USER
CMD [ "sh", "-c", "jupyter lab --ip 0.0.0.0 --port=$IF_main_port --allow-root --notebook-dir=/media/notebooks/ --NotebookApp.password='' --NotebookApp.token=''"]

#CMD [ "sh", "-c", "jupyter notebook --ip 0.0.0.0 -NotebookApp.base_url=$PATH_PREFIX --NotebookApp.password='' --NotebookApp.token=''" ] ## note the $PATH_PREFIX (check with Louis)
