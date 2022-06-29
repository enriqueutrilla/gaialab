#!/bin/bash

. /.datalab/init.sh

wait_interface & # emit state change to API when the interface is ready

#Create user home directory as a symlink to the user persistent area volume (pending correction related to SEPPPCR-191).
ln -s /media/home /home/$USER
ln -s /media/notebooks /home/$USER/notebooks

echo "Contents of /media"
ls -l /media
chmod go+rwx /media/home
echo "After changing permissions on /media"
ls -l /media

debug "Before changing permissions on /media/home/.local"
ls -l /media/home
mkdir -p /media/home/.local
chmod -R go+rwx /media/home/.local
debug "After changing permissions on /media/home/.local"
ls -l /media/home


cd $HOME

export JUPYTER_CONFIG_DIR=$HOME/.jupyterlab-$DATALAB_ID

debug "Start the Jupyterlab server"

api_emit_running
if gosu $UID:$UID bash -c "HOME=/home/$USER jupyter lab --ip=0.0.0.0 --port=$IF_main_port \
  --NotebookApp.base_url=\"/datalabs/$IF_main_id\" \
  --NotebookApp.token='' --NotebookApp.password='' \
  --NotebookApp.allow_origin='*'"
then
  api_emit_finished
else
  api_emit_error
fi

rm -rf $JUPYTER_CONFIG_DIR

api_emit_if_done
