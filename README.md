# RESSAC is REport of Simulation Semi-Automatically Completed

  This tool was borm from the evidence that most of the numerical experiments reports written for DRAKKAR, are built with an almost similar canvas. Therefore, a clever script  can easily produce a report template (in latex) from CPP keys used at compile time and namelist used at run time.

RESSAC is then an ongoing project for the collaborative development of such a clever script. Initial contributors were Raphael Dussin (who brought the idea) and Albane Lecointre (who implements new scripts).


## Licence
 * This software is now available on GitHub under the CeCILL license (<http://www.cecill.info/licences/Licence_CeCILL_V2-en.html>).
 
## Getting RESSAC

```> git clone https://github.com/molines/RESSAC ```

## Some base lines 
 * Source of information for a run
   - CPP_KEYS 
     * A comment on the choice of the cpp_keys is to be provided in the report
   - namelists
     * key information about the forcing, the parameterization
   - include_file.ksh
     * usefull to get the name of some files not defined in the namelist ( bathy, coordinates, extra damping mask etc...)
   - Journal (?)
     * to look at incidents during the run production, or some changes in the code  
   - monitoring
     * to extract some 2D plot (climatology) and time series. Eventually, get the MONITOR.nc file to redo some time-series plot in a more specific format
   - code
    * It can be reconstructed identically looking at the install_history where the used release of DCM is indicated.
    * This is the ultimate place where to find information not reflected in namelist or CPP_keys
 * Starting a report, one should have at hand all the previous information
   - [ressac_install.ksh](src/ressac_install.ksh) tool prepares a working space with all the required input data ( not that big) and a tree of directory (Namelists, Figures, etc ...) so that latex file knows about it. The ressac_install should also provide a template latex file, with common latex functions (e.g. used in the NEMO_book)
