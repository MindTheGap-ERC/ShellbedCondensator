# The Shellbed Condensator

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.7740309.svg)](https://doi.org/10.5281/zenodo.7740309)

Shiny app to visualize the effects of changing sedimentation rates on formation of fossil accumulations.

## Authors

__Niklas Hohmann__  (Maintainer)
Utrecht University  
email: n.h.hohmann [at] uu.nl  
Web page: [uu.nl/staff/NHohmann](https://www.uu.nl/staff/NHHohmann)  
ORCID: [0000-0003-1559-1838](https://orcid.org/0000-0003-1559-1838)

__Emilia Jarochowska__  
Utrecht University  
email: e.b.jarochowska [at] uu.nl  
Web page: [www.uu.nl/staff/EBJarochowska](https://www.uu.nl/staff/EBJarochowska)  
ORCID: [0000-0001-8937-9405](https://orcid.org/0000-0001-8937-9405)

## Requirements

R (version >= 3.0.2), RStudio IDE.  

## Online Usage

The app can be used online at [stratigraphicpaleobiology.shinyapps.io/shellbed_condensator](https://stratigraphicpaleobiology.shinyapps.io/shellbed_condensator/). Online usage does not require an installation of R.

## Offline Usage

Open the file _ShellbedCondensator.Rproj_ in the RStudio IDE. This will open the RProject, and install the `renv` package (if not already installed). Then run

```R
renv::restore()
```

in the console to install all dependencies required for the app. To run the app, use

```R
shiny::runApp()
```

## Repository structure

- _LICENSE.md_ : Apache 2.0 license text
- _README.md_ : Readme file
- _CITATION.cff_ : Citation info
- _app.R_ : R code to start app. Contains app architecture
- _renv.lock_ : lockfile for `renv` package
- _zenodo.json_ : Zenodo metadata
- _renv_ : folder for `renv` package
- _src_ : Folder for code
  - _condensator.R_ : Generates model outputs from user input
  - _condensator_plot.R_ : Generates plots from model outputs
- _www_ : Folder with pictures used in the app  
  - _people_ : Folder with pictures of authors
  - _logos_ : Folder with logos  
  - _geology_ : Folder with pictures of shell accumulations and stratigraphic columns

## License

Apache 2.0, see LICENSE file for details

## Citation

To cite the app, please use

- Hohmann, N., & Jarochowska, E. (2023). Shellbed Condensator (v1.0.0). Zenodo. [DOI: 10.5281/zenodo.7739986](https://doi.org/10.5281/zenodo.7739986)

## References

The model underlying the app is described in

- Hohmann, N.: Incorporating Information on Varying Sedimentation Rates in Paleontological Analyses. PALAIOS, 2021. [doi: 10.2110/palo.2020.038](https://doi.org/10.2110/palo.2020.038)

The app uses the shiny package:

- Chang W, Cheng J, Allaire J, Sievert C, Schloerke B, Xie Y, Allen J, McPherson J, Dipert A, Borges B
  (2022). _shiny: Web Application Framework for R_. R package version 1.7.3,
  <https://CRAN.R-project.org/package=shiny>.

## Funding information

Online access to the App is made possible by the IDUB programme of the University of Warsaw (Grant BOB-IDUB-622-18/2022).  
Co-funded by the European Union (ERC, MindTheGap, StG project no 101041077). Views and opinions expressed are however those of the author(s) only and do not necessarily reflect those of the European Union or the European Research Council. Neither the European Union nor the granting authority can be held responsible for them.
![European Union and European Research Council logos](https://erc.europa.eu/sites/default/files/2023-06/LOGO_ERC-FLAG_FP.png)
