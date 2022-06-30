#!/bin/bash

. /.datalab/init.sh

wait_interface & # emit state change to API when the interface is ready

#Create user home directory as a symlink to the user persistent area volume (pending correction related to SEPPPCR-191).
ln -s /media/home /home/$USER
ln -s /media/tutorials /home/$USER/tutorials

# Alow writing in the "tutorials" folder. Files stored in this folder will be lost if the notebook is restarted, 
# but this allows execution of the tutorials themselves
chmod go+rwx /media/tutorials

# Workaround to be removed, there were issues if the user was not properly identified
chmod go+rwx /media/home

cd $HOME

export JUPYTER_CONFIG_DIR=$HOME/.jupyterlab-$DATALAB_ID

debug "Start the Jupyterlab server"

api_emit_running
if gosu $UID:$UID bash -c "HOME=/home/$USER jupyter lab --ip=0.0.0.0 --port=$IF_main_port \
  --NotebookApp.base_url=\"/datalabs/$IF_main_id\" \
  --NotebookApp.token='' --NotebookApp.password='' \
  --NotebookApp.allow_origin='*' \
  --LabApp.default_url='/lab/tree/tutorials/README.ipynb "
then
  api_emit_finished
else
  api_emit_error
fi

rm -rf $JUPYTER_CONFIG_DIR

api_emit_if_done
