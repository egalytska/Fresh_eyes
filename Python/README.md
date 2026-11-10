# Fresh Eyes on CMIP Data Workshop 2026
This repository contains notebooks for the Fresh Eyes on CMIP Workshop on the CMIP6 dataset. 

# Getting Started
The notebooks cover:

- accessing the cmip6 dataset from different data sources.
- processing cmip6 data for producing climate stripes.

# Testing the code
You can run the code in these notebooks on your own machine without downloading any of the requirements using binder. Note - the code will be much slower on binder than on your own machine. 
[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/abhnil/Fresh_Eyes_on_CMIP_Data_Workshop/HEAD)



# Requirements
Clone this repository into your local directory.
```
git clone https://github.com/abhnil/Fresh_Eyes_on_CMIP_Data_Workshop.git
cd Fresh_Eyes_on_CMIP_Data_Workshop
```
Install and activate the virtual environment **cmip6env** to run the notebooks using Python 3.
```
python3 -m venv cmip6env
source cmip6env/bin/activate
```
Install the requirements.txt file 
```
python3 -m pip install --upgrade pip
pip install -r requirements.txt
```

# Running Notebooks
```
cd notebooks
jupyter lab <notebook>
```





