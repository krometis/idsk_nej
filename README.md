# R Shiny IDSK Exemplar
Repository for the Integrated Decision Support Key (IDSK) exemplar developed in R Shiny, as described in the Naval Engineers Journal "FILL IN" by Kelli Esser, Daniel Wolodkin, FILL IN AUTHORS.

## Setup
One-time setup to run the app for the first time:
1. Download and install R and [RStudio](https://posit.co/download/rstudio-desktop/) for free online
2. Open RStudio
3. Install the packages required for the functionality of the app by running the following command in the RStudio console:
```{r}
options(repos = c(CRAN = "http://cran.us.r-project.org"))
install.packages(c("shiny", "shinythemes", "DT", "readxl", "tidyverse", "dplyr", "lubridate", "naniar"))
```

## Running the app
1. Open RStudio if it is not open already
2. Open the `app.R` file
3. Click "Run App" to launch the web application
