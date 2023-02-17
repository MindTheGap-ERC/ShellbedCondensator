# ShellbedCondensator
Shiny app visualizing the effects of sedimentary condensation

Authors:
Niklas Hohmann (n.hohmann@uu.nl), Emilia Jarochowska
License: MIT, see file "LICENSE" for details

## Requirements
R version >=3.0.2
R package "shiny"

## Offline Usage
Before usage, make sure the shiny package is installed and loaded by running the following lines in R
''' R
if (!require("shiny")) install.package("shiny")
require("shiny")
'''
Then set your working directory to DIR where the file app.R is located:
'''
setwd(DIR)
'''
Now you can start the app using the command
''' R
runApp()
'''

## Online Usage
The app can be used online [here](https://stratigraphicpaleobiology.shinyapps.io/shellbed_condensator/). Online usage does not require an installation of R.
