FROM registry.esa.int:5020/sepp/jl_base:v9.1915
ENV DEBIAN_FRONTEND noninteractive
COPY ./requirements.txt /tmp/
RUN apt-get update \
  && apt-get install python3.8=3.8.0-3ubuntu1~18.04.2 -y \
  && apt-get remove python3-pip pip -y \
  && update-alternatives --remove python3 /usr/bin/python3 \
  && update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.8 10 \
  && apt-get install pip=9.0.1-2.3~ubuntu1.18.04.4 python3-pip=9.0.1-2.3~ubuntu1.18.04.4 -y \
  && echo "Installing python dependencies" \
  && pip3 install --no-cache-dir -r /tmp/requirements.txt \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

COPY *.ipynb /media/tutorials/
COPY *.png /media/tutorials/images/

COPY run.sh /opt/
RUN chmod +x /opt/run.sh

CMD   ["/sbin/tini", "--", "/opt/run.sh"]
