FROM registry.esa.int:5020/sepp/jl_base:v9.1915
ENV DEBIAN_FRONTEND noninteractive
COPY ./requirements.txt /tmp/
RUN apt-get update \
  && pip3 install --no-cache-dir -r /tmp/requirements.txt \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

COPY *.ipynb /media/tutorials/.
COPY *.png /media/tutorials/images/.

COPY run.sh /opt/
RUN chmod +x /opt/run.sh

CMD   ["/sbin/tini", "--", "/opt/run.sh"]
