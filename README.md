# R Shiny IDSK Exemplar
Repository for the Integrated Decision Support Key (IDSK) exemplar developed in R Shiny, as described in the Naval Engineers Journal article "Integrated Decision Support Key: Advancing Acquisition Decisions with Data Models and Tools" by Jeremy Werner, Kelli Esser, Craig Arndt, Trisha Radocaj, Awele Anyanhun, Daniel Wolodkin, Geoffrey Kerr, and Laura Freeman.

## Setup
One-time setup to run the app for the first time:
1. Download the app and supporting files, e.g., by running `git clone git@github.com:krometis/idsk_nej.git` from the command line or downloading the zip file (see the green Code button at top right) and unzipping the contents. You should see both the app (`app.R`) and supporting files (`data` directory, `DataClean.R`, etc).
2. Download and install R and [RStudio](https://posit.co/download/rstudio-desktop/) for free online
3. Open RStudio
4. Install the packages required for the functionality of the app by running the following command in the RStudio console:
```{r}
options(repos = c(CRAN = "http://cran.us.r-project.org"))
install.packages(c("shiny", "shinythemes", "DT", "readxl", "tidyverse", "dplyr", "lubridate", "naniar"))
```

## Running the app
1. Open RStudio if it is not open already
2. Open the `app.R` file
3. Click "Run App" to launch the web application
