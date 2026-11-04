
Online seminar on CMIP data analysis tools and tutorials 
============
**Date**: 11 November 2026 12:UTC

**ESMValTool Introduction**

**Presenter**: Evgenia Galytska (egalytska@iup.physik.uni-bremen.de)

Check ESMValTool tutorial webpage https://tutorial.esmvaltool.org/ to practice your skills. 
Need more detailed information? Check the ESMValTool documentation https://docs.esmvaltool.org/.

___
**Before starting keep in mind**: 

+ ESMValTool is distributed using Mamba. It means, to use ESMValTool the users should install Mamba first. How to install Mamba see also explained [here](https://tutorial.esmvaltool.org/02-installation/index.html#:~:text=on%20Linux/MacOSX-,Install%20Mamba,-ESMValTool%20is%20distributed).
+ Once mamba is installed, create a new environment with ESMValTool package in it: 
  ```
  mamba create --name esmvaltool esmvaltool
  ```
+ Activate the environment and display the command line help: 
  ```
  mamba activate esmvaltool
  esmvaltool --help
  ```

### Configure your ESMValTool ###
  **(!)** Check available config files 

        esmvaltool config list


**(!)** The user can download the ````config-user.yml ```` by running: 
     	
           esmvaltool config copy defaults/config-user.yml

Open the **config-user.yml** file. It is downloaded to your ~/.config/esmvaltool/ directory. Check and adapt the following settings: 
    
  +	Root paths to the data from different projects
  +	````output_dir: provide the path where your data should be saved```` 
  +	 ````search_data: quick```` 
  +  ````remove_preproc_dir: true````

  **(?)** Do you use ESMValTool on your local computer? Lets let ESMValTool know where to find the input data. (Even if you do not have any data yet, we will also let ESMValTool to download missing data for us.)

  Lets copy one of the example configuration files and adapt it.

        esmvaltool config copy data-local-esmvaltool.yml

    Again, in your ~/.config/esmvaltool/ directory you will now find this file. In the data-local-esmvaltool.yml file for each project (e.g. native6, OBS6, OBS etc) define rootpath (path with the input data). To access CMIP6 data add, the following lines to this file: 

        CMIP6:
          data:
            local:
              type: esmvalcore.io.local.LocalDataSource
              rootpath: /path/to/your/input_data/
              dirname_template: "{project}/{activity}/{institute}/{dataset}/{exp}/{ensemble}/{mip}/{short_name}/{grid}/{version}"
              filename_template: "{short_name}_{mip}_{dataset}_{exp}_{ensemble}_{grid}*.nc"
            esgf-cache:
              type: esmvalcore.io.local.LocalDataSource
              rootpath: /path/to/your/input_data/
              dirname_template: "{project}/{activity}/{institute}/{dataset}/{exp}/{ensemble}/{mip}/{short_name}/{grid}/{version}"
              filename_template: "{short_name}_{mip}_{dataset}_{exp}_{ensemble}_{grid}*.nc"
    
    

Now, lets make sure ESMValTool will download missing data. Download ````data-local-esmvaltool.yml ```` file. 

       esmvaltool config copy data-local-esmvaltool.yml


  And create a conf.yaml file in ~/.config/intake-esgf. The content of conf.yaml file find [here](https://tutorial.esmvaltool.org/03-configuration/index.html#:~:text=Rootpath%20to%20input%20data)

### Start of the tutorial. ###


1. Create the directory with the name you preffer (e.g. _online_seminar_). We will now work with recipe and diagnostics, please download both files from here: 


   + Recipe (**recipe_temperature_anomalies.yml**, described Sect. 1.1)

   + Diagnostic (**plot_temperature_anomalies.py**, described Sect. 1.2) 


    1.1. Recipe 

    Due to the time limitations there is a recipe **recipe_temperature_anomalies.yml**, modified for the purposes of the online seminar. It recipe can be accessed from: 

    The main componemts of the recipe are:

    + documentation
    + datasets
    + preprocessors (e.g. ````area_statistics````, ````annual_statistics````)
    + diagnostics (variables and preprocessors that are used).

    1.2. Diagnostic file
    
   **plot_temperature_anomalies.py**

    The purpose of the script: 

    + A description/purpose of the script
    + Import statements (import iris etc.).
    + Functions that implement the analysis (e.g. ````def plot_warming_stripes````).
    + A typical Python top-level script i.e. ````if __name__ == '__main__' ````

    **(!)** The function ````run_diagnostic```` is called a context manager provided with ESMValTool and is the main entry point for most Python diagnostics.

2. Run the recipe and review the show the resulting plot:

   ```
   esmvaltool run recipe_temperature_anomalies.yml
   ```
3. Investigate the output in your _online_seminar_ folder. Which subfolders has ESMValTool created? Can you find where the figures are stored? 