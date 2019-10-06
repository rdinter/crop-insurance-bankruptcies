# Crop Insurance and Bankruptcies

This repository is meant as a way to collaborate on at least one project involving crop insurance participation and its effects on farm bankruptcies (Chapter 12).

- [FIPS Issues](0-data/FIPS-issues)


## Organization:

The main theme behind this repository is to have easy access to data-sources for multiple projects. The `project` is the identifier for various ideas, research interests, modeling exercises, etc. which can be seen in the above description.

* [0-data/](0-data/)
    * `0-data_source.R` - script to download data and create `.csv` and `.rds` files in an easy to read and uniform format.
    * data_source/ - most of this will be ignored via `.gitignore`.
        * raw/
            * All downloaded files from the `0-data_source.R` script.
            * Some data cannot be downloaded and must be hosted elsewhere. They will also be in this folder for local use.
        * `various_names.csv`
        * `various_names.rds`
    * `0-functions.R` - relevant functions for this sub-directory.
    * `.gitignore` - any large files will not be loaded to GitHub.
* [0-research-articles/](0-research-articles/)
    * project/
        * Various research articles related to projects that helps with literature review
* [1-tidy/](1-tidy/)
    * `1-project_tidy.R` - script to gather particular data
    * project/
        * Properly formatted and gathered data for further analysis.
* [2-eda/](2-eda/)
    * project/ - comes from the source of projects above
        * `2-project_eda.R` - summary statistics, histograms, plots, maps, etc.
        * Various plots, figures, tables, and maps saved. Not all are valuable or finished.
* [3-basic/](3-basic/)
    * project/
        * `3-project_basic_XXX.R` - basically OLS type of analysis to see what the data are doing.
        * Saved results, although some of these may never be of use for the final product.
* [4-advanced/](4-advanced/)
    * project/
        * `4-project_advanced_XXX.R` - a more complex, and hopefully complete, way of modeling the data for the particular project.
        * Various ideas for solving the problem of interest.
* [5-results/](5-results/)
    * project/
        * `5-project_results.R` - the output to be used for said project.
        * Finished results.
* [6-edits/](6-edits/)
    * project/
        * Various files which go back and forth for the editing process. This is fairly unorganized due to the nature of tracking changes outside of git.