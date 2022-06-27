# JupyterLab Notebook demo datalab

This repository provides an example for the creation of an ESA Datalabs JupyterLab datalab based on a repository with Jupyter notebooks (from an external git repository). This assumes there is no Dockerfile. 
**TBC**: Expert users can include their own Dockerfile (e.g. to include specific jupyter extensions). **Restrictions to be defined**

## Repository structure

A typical simple repository example is:

- `notebook_01.ipynb` --> jupyter notebook: simple GPU notebook.
- `notebook_02.ipynb` --> jupyter notebook: simple notebook to explore data products (FITS).
- `fits_info.py` --> user provided custom python module (imported in the `notebook_02.ipynb`)
- `data/` --> folder that could contain some data included in the datalab image (data can also be mounted on /media/data/ at container runtime)
- `requirements.txt` --> required python modules to be installed
- `datalab-meta.yml` --> pre-filled metadata key:value pairs (used to create the datalab)

The content of the repository is copied into `/media/notebooks/datalab_xxxx/` (see below)

## Python dependencies

As shown above it is possible to include a `requirements.txt` (pip install) file that contains a list of python packages that will be installed.

The `requirements.txt` file should list all Python libraries that your notebooks depend on, and they will be installed using:

    pip install -r requirements.txt


## Metadata file
The structure of a metadata yml file is as follows:

    # Mandatory fields:
    title: Name of your datalab
    alternateName: Shorter name or acronym for your datalab
    abstract: A short description of your Datalab
    distribution.license: Licencse applicable to your datalab, e.g. MIT, Apache 2.0, GPL.

    # Recommended fields:
    description: A longer more detailed description of your datalab
    creator.name: name of the creator of the datalab (can be someone else)
    instrument: name of instrument (e.g. SPICAV)
    mission: name of mission (e.g. JWST)
    thumbnailUrl: link (URL) to a SVG icon used to display your datalab in the catalogue
    version: version of your datalab (different from the internal version assigned in ESA Datalabs)

    # Optional fields:
    contactPoint:
      email: your-email@your-institute
      organisation-name: your-institute
    keywords:
      - keyword1 (preferably use keywords from the Unified Astronomy Thesaurus (https://astrothesaurus.org/)
      - keyword2
    citation: Reference to your paper
    funder: Funding acknowledgemetn
    doi.notation: DOI of your datalab (either existing one or assigned by ESA)


## Dockerfile

The Docker image created by the "Create datalab" functionality is based on the pre-approved base image for jupyter labs `sepp/jupyterlab_base:latest`

A minmial `Dockerfile` would look like this (see example `Dockerfile.example`):

    FROM sepp/jupyterlab_base:latest ## use one of the pre-approved base images
    ENV DEBIAN_FRONTEND noninteractive  ## --> is this required?
    COPY ./requirements.txt /tmp/
    RUN apt-get update \
      && apt-get install -y python3-pip python3-dev \
      && pip3 install --upgrade pip \
      && pip3 install jupyterlab==2.2.9  ## --> required version?? should this be included in requirements.txt
      && pip3 install -r /tmp/requirements.txt
    COPY ./ /media/notebooks/  ## --> Copy by default the entire repository to this folder? 
    RUN rm /media/notebooks/lab-meta.yml ## --> need to remove some files??  

## Creating and testing your datalab

To create a new Jupyter Notebook based datalab from this above prepared repository the user shall follow these steps:



## Validating and publishing your datalab

Once you're happy with your datalab (see previous section) you're ready to have your datalab validated and published in the the ESA Datalabs datalabs catalogue. Follow these steps:

