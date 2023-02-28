# ShellbedCondensator

Shiny app to visualize the effects of changing sedimentation rates on formation of shell accumulations.

## Authors

__Niklas Hohmann__ (Maintainer)  
Utrecht University  
email: n.hohmann@uu.nl  
Web page: [uu.nl/staff/NHohmann](uu.nl/staff/NHohmann)  
Orcid: [0000-0003-1559-1838](https://orcid.org/0000-0003-1559-1838)

__Emilia Jarochowska__, Utrecht University  

## License

MIT, see LICENSE.md file for details

## Requirements

R version 3.0.2 or higher  
R package "shiny"

## Offline Usage

Before usage, make sure the shiny package is installed (and install if necessary) by running the following lines in R

``` R
if (!require("shiny")) {
    install.package("shiny")
}
```

Then set your working directory to "DIR" where the file app.R is located:

``` R
setwd("DIR")
```

Now you can start the app using the command

``` R
shiny::runApp()
```

## Online Usage

The app can be used online at [stratigraphicpaleobiology.shinyapps.io/shellbed_condensator](https://stratigraphicpaleobiology.shinyapps.io/shellbed_condensator/). Online usage does not require an installation of R.

## Repository structure

- _LICENSE.md_ : MIT license text
- _README.md_ : Readme file
- _app.R_ : R code to start app
- _src_ : Folder for code
  - _condensator.R_ : Generates model outputs from user input
  - _condensator_plot.R_ : Generates plots from model outputs
- _www_ : Folder with pictures used in the app  
  - _people_ : Folder with pictures of authors
  - _logos_ : Folder with logos  
  - _geology_ : Folder with pictures of shell accumulations and stratigraphic columns
