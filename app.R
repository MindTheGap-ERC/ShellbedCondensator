# Copyright 2023 Niklas Hohmann and Emilia Jarochowska
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
# http://www.apache.org/licenses/LICENSE-2.0

library(shiny)
source("src/condensator_plot.R")
source("src/condensator.R")


ui <- navbarPage(
  title = tags$b("The Shellbed Condensator"),
  id = "condensation_app",
  windowTitle = "Shellbed Condensator",
  #### FP: Front Page ####
  tabPanel(
    title = "Introduction",
    value = "introduction",
    fluidRow(
      #### FP: Left Panel (Text) ####
      column(
        8,
        actionButton(
          inputId = "go_to_app",
          label = tags$b("Click to Skip Introduction"),
          width = "30%"
        ),

        #### FP: Left Panel/Main Text ####
        tags$h4("Motivation"),
        tags$p("Fossil concentrations are landmarks that are easily recognizable in the rock face (Figs. 1, 3). They can indicate important biological and ecological events, such as mass mortality, or record times of high productivity.
                                 However, non-biological processes such as gradual sorting by currents or violent accumulation by storms also generate fossil concentrations. Thus, a profound understanding of the depositional environment is required to reconstruct the original biological processes from its sedimentary record.
                                 "),
        tags$h4("The Question"),
        tags$p(HTML("By varying both sedimentation rate and fossil input, Prof. Susan Kidwell (University of Chicago) showed in a seminal article in <i>Science</i> <a href=https://doi.org/10.1038/318457a0 target=\"_blank\"> (Kidwell 1985) </a> that patterns of fossil abundance in a geological section can be produced in different ways.
                                 Fossil concentrations such as bone or shell beds can form as a result of high input of organism remains into the sediment or as the result of reduced sediment input, as the latter reduces the volume of sediment placed between individual fossils and generates a sedimentary condensation.
                                 This raises a fundamental question when examining fossil accumulations: Are fossils enriched because their supply, or input, increased, or because the supply of the surrounding sediment declined?
                                 ")),
        tags$h4("The App"),
        tags$p(HTML("Shellbed Condensator is designed to visualize and study the effects of sedimentary condensation, dilution, and erosion on the formation of fossil concentrations. It allows an interactive reconstruction of the simulations by <a href=https://doi.org/10.1038/318457a0 target=\"_blank\"> Kidwell (1985) </a> in real-time and can be used for teaching and self-study. To animate the effects of changing parameters click the play buttons below the sliders.
                                 As an exercise, you can try to reconstruct one of the scenarios in Fig. 2 by changing sedimentation rate and shell input.")),
        tags$p("The app is set to determine the condensation of shells as a standard example of fossils. This can be changed in the settings. We recommend using it in full screen."),
        actionButton(
          inputId = "go_to_app_2",
          label = tags$b("Get Started"),
          width = "30%"
        ),
        hr(),
        tags$h4("Further Reading"),
        tags$p(HTML("The study of how the physical and sedimentological processes govern the preservation or obliteration of past biodiversity is known as stratigraphic paleobiology.
                          The textbook by <a href=https://press.uchicago.edu/ucp/books/book/chicago/S/bo12541329.html target=\"_blank\"> Patzkowsky and Holland (2012) </a> offers an introduction to this discipline.
                          If you would like to apply the DAIME model underlyig the app to your own data, you can find an example with <a href=https://osf.io/a6vwr/ target=\"_blank\" >annotated R code</a> in the article by <a href=https://doi.org/10.1029/2020PA003979 target=\"_blank\" > Jarochowska et al. (2020) </a>.
                          The formation of fossil concentrations in this app has been simplified to illustrate the main concepts, but in reality there are further factors affecting their formation, including bioturbation and burial (e.g. <a href=https://doi.org/10.1017/pab.2015.30 target=\"_blank\"> Tomašových
                          et al., 2016) </a>, as well as cementation and dissolution (e.g.<a href=https://doi.org/10.2110/palo.2008.p08-033r target=\"_blank\" > Tomasovych &  Schlögl, 2008) </a>.")),
        tags$h4("A Quick Explanation of the Underlying Model"),
        tags$p(HTML("The app is based on the DAIME model by Hohmann (<a href=https://doi.org/10.13140/RG.2.2.23372.51841 target=\"_blank\">2018</a>, <a href=https://doi.org/10.2110/palo.2020.038 target=\"_blank\" > 2021</a>), which is available as a package for the R Software <a href=https://cran.r-project.org/web/packages/DAIME/index.html target=\"_blank\" > (Hohmann 2020)</a>.
                                 In a first step, the app uses the sedimentation rate to determine how much sediment was deposited up until any point in time.
                                 Removing intervals with net erosion from this sediment accumulation history yields the age-depth model. It consists of intervals that are either (1) eroded and do not preserve any information or (2) have a positive sediment accumulation rate.
                                 For the latter, the age-depth model provides a 1-1 correspondence between time of deposition and stratigraphic height.
                                 Based on this correspondence, the fossil input is transformed from time into stratigraphic height using a coordinate transformation determined by the age model.
                                 It preserves input in the sense that in the absence of hiatuses, any fossils placed into the sediment during a time interval I<sub>time</sub> can be found in the part of the section that was deposited during I<sub>time</sub>.
                                 Combining this information yields (1) the distribution of hiatuses and (2) condensation or dilution of fossil input in the section as a function of the sedimentation and fossil input rates through time.
                                 The app does not incorporate time averaging, mixing, or changes in preservation potential.")),
        #### FP: Left Panel/Creators ####
        fluidRow(
          div(style = "margin-left: 1em; margin-bottom: -0.5em", tags$h4(" Creators")),
          column(
            width = 6,
            tags$h5(tags$b("Niklas Hohmann")),
            fluidRow(
              column(
                width = 5,
                img(
                  src = "people/niklas_hohmann.jpg",
                  alt = "Picture of Niklas Hohmann",
                  align = "left",
                  width = "100%"
                )
              ),
              column(
                width = 7,
                div(style = "margin-left: -4em", tags$ul(
                  "PhD candidate", br(),
                  "Utrecht University, The Netherlands", br(),
                  "Email: N.Hohmann (at) uu.nl", br(),
                  HTML("Twitter: <a href=https://twitter.com/HohmannNiklas target=\"_blank\" > @HohmannNiklas </a>"), br(),
                  HTML("Mastodon: <a href=https://ecoevo.social/@Niklas_Hohmann target=\"_blank\" > @Niklas_Hohmann@ecoevo.social </a>"), br(),
                  HTML("<a href=https://scholar.google.com/citations?hl=de&user=2CB_ktEAAAAJ target=\"_blank\" > Google Scholar profile </a>"), br(),
                  HTML("Profile on the <a rel='author' href=https://www.uu.nl/staff/NHohmann target=\"_blank\" > university webpage </a>"), br(),
                  HTML("<a href=https://github.com/NiklasHohmann target=\"_blank\" > GitHub page </a>")
                )),
              )
            )
          ),
          column(
            width = 6,
            tags$h5(tags$b("Dr. Emilia Jarochowska")),
            fluidRow(
              column(
                width = 5,
                img(
                  src = "people/emilia_jarochowska.jpg",
                  alt = "Picture of Emilia Jarochowska",
                  align = "left",
                  width = "100%"
                )
              ),
              column(
                width = 7,
                div(style = "margin-left: -4em", tags$ul(
                  "Utrecht University, The Netherlands", br(),
                  "Email: e.b.jarochowska (at) uu.nl", br(),
                  HTML("Mastodon: <a href=https://circumstances.run/@Emiliagnathus target=\"_blank\" > @Emiliagnathus@circumstances.run </a>"), br(),
                  HTML("<a href=https://scholar.google.de/citations?user=Zrldp2MAAAAJ&hl=en target=\"_blank\" > Google Scholar profile </a>"), br(),
                  HTML("Profile on the <a rel='author' href=https://www.uu.nl/staff/EBJarochowska target=\"_blank\" > university webpage </a>")
                )),
              )
            )
          )
        ),
        #### FP: Left Panel/References and Funding ####
        tags$h4("How to Cite"),
        tags$p("To cite this app, please use the following references:"),
        tags$ul(
          tags$li(HTML("Hohmann, N., & Jarochowska, E. (2023). Shellbed Condensator (v1.0.0). <i>Zenodo</i>. <a href='https://doi.org/10.5281/zenodo.7739986'> doi.org/10.5281/zenodo.7739986 </a> ")),
          tags$li(HTML("Hohmann, N. (2021). Incorporating Information on Varying Sedimentation Rates into Paleontological Analyses. <i> PALAIOS </i>, 36. <a href=https://doi.org/10.2110/palo.2020.038 target=\"_blank\" > doi.org/10.2110/palo.2020.038 </a>. ")),
          tags$li(HTML("Hohmann, N. (2020). R package \"DAIME\". <i>Comprehensive R Archive Network (CRAN)</i>. URL <a href=https://cran.r-project.org/web/packages/DAIME/index.html target=\"_blank\" > cran.r-project.org/web/packages/DAIME </a>, <a href=http://doi.org/10.5281/zenodo.3702552 target=\"_blank\" > doi.org/10.5281/zenodo.3702552 </a>"))
        ),
        tags$h4("Code Availability"),
        tags$p(HTML("The code for this app is available under <a href=https://github.com/MindTheGap-ERC/ShellbedCondensator target=\"_blank\" > github.com/MindTheGap-ERC/ShellbedCondensator </a> ")),
        tags$h4("License"),
        tags$p(HTML('<a rel="license" href="http://creativecommons.org/licenses/by/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by/4.0/">Creative Commons Attribution 4.0 International License</a>. The code used is licensed under a <a rel="license" href="http://www.apache.org/licenses/LICENSE-2.0"> Apache 2.0 License</a>.')),
        tags$h4("Funding"),
        tags$p("Online access to the Shellbed Condensator is made possible by the IDUB programme of the University of Warsaw (Grant BOB-IDUB-622-18/2022).
Co-funded by the European Union (ERC, MindTheGap, StG project no 101041077). Views and opinions expressed are however those of the author(s) only and do not necessarily reflect those of the European Union or the European Research Council. Neither the European Union nor the granting authority can be held responsible for them."),
        div(style = "margin-top: 2em", tags$h4("References")),
        tags$ul(
          tags$li(HTML("Hohmann, N. (2018). Quantifying the effects of changing deposition rates and hiatii on the stratigraphic distribution of fossils. <i> Bachelor Thesis </i>, Friedrich-Alexander-Universität Erlangen-Nürnberg. <a href=https://doi.org/10.13140/RG.2.2.23372.51841 target=\"_blank\"> doi.org/10.13140/RG.2.2.23372.51841</a>")),
          tags$li(HTML("Hohmann, N. (2020). R package \"DAIME\". <i>Comprehensive R Archive Network (CRAN)</i>. URL <a href=https://cran.r-project.org/web/packages/DAIME/index.html target=\"_blank\" > cran.r-project.org/web/packages/DAIME </a>, <a href=http://doi.org/10.5281/zenodo.3702552 target=\"_blank\" > doi.org/10.5281/zenodo.3702552 </a>")),
          tags$li(HTML("Hohmann, N. (2021). Incorporating information on varying sedimentation rates into paleontological analyses. <i> PALAIOS </i>, 36: 53-67. <a href=https://doi.org/10.2110/palo.2020.038 target=\"_blank\" > doi.org/10.2110/palo.2020.038 </a>.")),
          tags$li(HTML("Jarochowska, E., Nohl, T., Grohganz, M., Hohmann, N., Vandenbroucke, T. R. A., & Munnecke, A. (2020). Reconstructing depositional rates and their effect on paleoenvironmental proxies: The case of the Lau Carbon Isotope Excursion in Gotland, Sweden. <i>Paleoceanography and Paleoclimatology</i>, 35: e2020PA003979. <a href=https://doi.org/10.1029/2020PA003979 target=\"_blank\" > doi.org/10.1029/2020PA003979 </a> ")),
          tags$li(HTML("Jarochowska, E., Nohl, T., Grohganz, M., Hohmann, N., Vandenbroucke, T. R. A., & Munnecke, A. (2020). Data for Reconstructing depositional rates and their effect on paleoenvironmental proxies: The case of the Lau Carbon Isotope Excursion in Gotland, Sweden. <a href=https://doi.org/10.17605/OSF.IO/A6VWR  target=\"_blank\" > 10.17605/OSF.IO/A6VWR  </a> ")), 
          tags$li(HTML("Kidwell, S. M. (1985). Palaeobiological and sedimentological implications of fossil concentrations. <i>Nature</i>, 318, 457–460. <a href=https://doi.org/10.1038/318457a0 target=\"_blank\" > doi.org/10.1038/318457a0 </a>")),
          tags$li(HTML("Patzkowsky, M. E., & Holland, S. M. (2012). <i>Stratigraphic paleobiology: understanding the distribution of fossil taxa in time and space</i>. University of Chicago Press. <a href=https://press.uchicago.edu/ucp/books/book/chicago/S/bo12541329.html target=\"_blank\" > ISBN: 9780226649382 </a>")),
          tags$li(HTML("Tomašových, A., & Schlögl, J. (2008). Analyzing variations in cephalopod abundances in shell concentrations: the combined effects of production and density-dependent cementation rates. <i>Palaios</i>, 23, 648–666. <a href=
https://doi.org/10.2110/palo.2008.p08-033r target=\"_blank\" > doi.org/10.2110/palo.2008.p08-033r </a>")),
          tags$li(HTML("Tomašových, A., Kidwell, S. M., & Barber, R. F. (2016). Inferring skeletal production from time-averaged assemblages: skeletal loss pulls the timing of production pulses towards the modern period. <i>Paleobiology</i>, 42, 54–76. <a href=
https://doi.org/10.1017/pab.2015.30 target=\"_blank\" > doi.org/10.1017/pab.2015.30 </a>
"))
        )
      ),
      #### FP: Right Panel (figures) ####
      column(
        width = 4,
        tags$figure(
          img(
            src = "geology/shellbed_portugal.jpg",
            alt = "A shellbed",
            width = "100%"
          ),
          tags$figcaption("Fig. 1: A shell bed from the Miocene Lagos-Portimão Formation close to Lagos, southern Portugal.")
        ),
        hr(),
        tags$figure(
          img(
            src = "geology/shellbed_formation.jpg",
            alt = "A shellbed",
            width = "100%"
          ),
          tags$figcaption(HTML("Fig. 2: Hypothetical scenarios of shell accumulation in times of low or negative sedimentation rates. Modified after <a href=https://doi.org/10.1038/318457a0 target=\"_blank\" > Kidwell (1985)</a>."))
        ),
        hr(),
        tags$figure(
          img(
            src = "geology/crinoids_gotland.jpg",
            alt = "A shellbed",
            width = "100%"
          ),
          tags$figcaption("Fig 3: An accumulation of crinoids stems in the Silurian of Gotland, Sweden.")
        )
      )
    ),
    #### FP: Bottom/Logos ####
    hr(),
    fluidRow(
      column(
        width = 3,
        img(
          src = "logos/UW_logo.svg",
          alt = "Logo of UW",
          width = "30%",
          align = "left"
        )
      ),
      column(
        width = 3,
        img(
          src = "logos/IDUB_logo.jpeg",
          alt = "Logo of IDUB",
          width = "30%",
          align = "left"
        )
      ),
      column(
        width = 3,
        img(
          src = "logos/mind_the_gap_logo.png",
          alt = "Logo of MindTheGap",
          width = "70%",
          align = "left"
        )
      ),
      column(
        width = 3,
        img(
          src = "logos/UU_logo.jpg",
          width = "70%",
          alt = "Logo of UU",
          align = "left"
        )
      )
    ),
    hr()
  ),
  #### AI: App Interface ####
  tabPanel(
    title = "Visualizing Sedimentary Condensation and Erosion",
    value = "app",
    tags$h2("Visualizing Sedimentary Condensation and Erosion"),
    fluidRow(
      #### AI: Left Panel ####
      column(
        width = 3,
        wellPanel(
          #### AI: Left Panel/Input Sliders ####
          tags$h3(textOutput("input_rate_name")),
          checkboxInput(
            inputId = "show_input_points",
            label = "Show Points",
            value = TRUE
          ),
          fluidRow(
            column(
              width = 4,
              tags$b("Time I1"),
              tags$p("0", style = "padding: 30%;")
            ),
            column(
              width = 8,
              sliderInput(
                inputId = "y_pat_1",
                label = "Value I1",
                value = 0,
                min = 0,
                max = 1,
                step = 0.05,
                animate = TRUE
              )
            )
          ),
          fluidRow(
            column(
              width = 4,
              numericInput(
                inputId = "x_pat_2",
                label = "Time I2",
                value = 0.25,
                min = 0,
                max = 1
              )
            ),
            column(
              8,
              sliderInput(
                inputId = "y_pat_2",
                label = "Value I2",
                value = 0.25,
                min = 0,
                max = 1,
                step = 0.05,
                animate = TRUE
              )
            )
          ),
          fluidRow(
            column(
              width = 4,
              numericInput(
                inputId = "x_pat_3",
                label = "Time I3",
                value = 0.5,
                min = 0,
                max = 1
              )
            ),
            column(
              width = 8,
              sliderInput(
                inputId = "y_pat_3",
                label = "Value I3",
                value = 0.5,
                min = 0,
                max = 1,
                step = 0.05,
                animate = TRUE
              )
            )
          ),
          fluidRow(
            column(
              width = 4,
              numericInput(
                inputId = "x_pat_4",
                label = "Time I4",
                value = 0.75,
                min = 0,
                max = 1
              )
            ),
            column(
              width = 8,
              sliderInput(
                inputId = "y_pat_4",
                label = "Value I4",
                value = 0.75,
                min = 0,
                max = 1,
                step = 0.05,
                animate = TRUE
              )
            )
          ),
          fluidRow(
            column(
              width = 4,
              tags$b("Time I5"),
              tags$p(textOutput("end_of_observation_name_2", container = div))
            ),
            column(
              width = 8,
              sliderInput(
                inputId = "y_pat_5",
                label = "Value I5",
                value = 1,
                min = 0,
                max = 1,
                step = 0.05,
                animate = TRUE
              )
            )
          ),
          numericInput(
            inputId = "input_volume",
            label = "Shell Volume [# per m]",
            value = 0.0,
            min = 0,
            step = 0.01 * 0.01,
            max = 0.1
          ),
          #### AI: Left Panel/Model Options ####
          wellPanel(
            tags$h3("Model Options"),
            textInput(
              inputId = "sed_content_name",
              label = "What is Placed in the Sediment?",
              value = "Shell"
            ),
            textInput(
              inputId = "sed_content_unit",
              label = "What are Its Units?",
              value = "#"
            ),
            textInput(
              inputId = "T_unit",
              label = "Time Unit",
              value = "Myr"
            ),
            textInput(
              inputId = "L_unit",
              label = "Length Unit",
              value = "m"
            ),
            numericInput(
              inputId = "duration",
              label = "Timespan of Observation",
              value = 1,
              step = 0.001,
              min = 0.001
            ),
            actionButton(
              inputId = "update_model_options",
              label = "Apply Changes"
            )
          )
        )
      ),
      #### AI: Middle Panel ####
      column(
        width = 6,
        tags$h3("Change with Time"),
        plotOutput("time_plot"),
        tags$h3("Stratigraphic Column"),
        plotOutput("height_plot"),
        tags$h3("Age-Depth Model"),
        plotOutput("age_model")
      ),
      #### AI: Right Panel ####
      column(
        width = 3,
        wellPanel(
          #### AI: Right Panel/Sedimentation Sliders ####
          tags$h3(textOutput("sedimentation_rate_name")),
          checkboxInput(
            inputId = "show_sed_points",
            label = "Show Points",
            value = TRUE,
            width = NULL
          ),
          fluidRow(
            column(
              width = 4,
              tags$b("Time S1"),
              tags$p("0", style = "padding: 20%;")
            ),
            column(
              width = 8,
              sliderInput(
                inputId = "y_sed_1",
                label = "Value S1",
                value = 1,
                min = -1,
                max = 1,
                step = 0.05,
                animate = TRUE
              )
            )
          ),
          fluidRow(
            column(
              width = 4,
              numericInput(
                inputId = "x_sed_2",
                label = "Time S2",
                value = 0.25,
                min = 0,
                max = 1
              )
            ),
            column(
              width = 8,
              sliderInput(
                inputId = "y_sed_2",
                label = "Value S2",
                value = 0.75,
                min = -1,
                max = 1,
                step = 0.05,
                animate = TRUE
              )
            )
          ),
          fluidRow(
            column(
              width = 4,
              numericInput(
                inputId = "x_sed_3",
                label = "Time S3",
                value = 0.5,
                min = 0,
                max = 1
              )
            ),
            column(
              width = 8,
              sliderInput(
                inputId = "y_sed_3",
                label = "Value S3",
                value = 0.5,
                min = -1,
                max = 1,
                step = 0.05,
                animate = TRUE
              )
            )
          ),
          fluidRow(
            column(
              width = 4,
              numericInput(
                inputId = "x_sed_4",
                label = "Time S4",
                value = 0.75,
                min = 0,
                max = 1
              )
            ),
            column(
              width = 8,
              sliderInput(
                inputId = "y_sed_4",
                label = "Value S4",
                value = 0.25,
                min = -1,
                max = 1,
                step = 0.05,
                animate = TRUE
              )
            )
          ),
          fluidRow(
            column(
              width = 4,
              tags$b("Time S5"),
              tags$p(textOutput(
                outputId = "end_of_observation_name", container = div
              ))
            ),
            column(
              width = 8,
              sliderInput(
                inputId = "y_sed_5",
                label = "Value S5",
                value = 0,
                min = -1,
                max = 1,
                step = 0.05,
                animate = TRUE
              )
            )
          ),
          selectInput(
            inputId = "condensation_display_mode",
            label = "Display Sedimentary Condensation as",
            choices = rev(c(
              "Sediment accumulation [L/T]" = "height",
              "Condensation [T/L]" = "condensation",
              "Do not Display" = "section without sed info"
            )),
            selected = "section without sed info"
          ),
          #### AI: Right Panel/Slider Options ####
          wellPanel(
            tags$h3("Slider Options"),
            numericInput(
              inputId = "max_slider_val_sed",
              label = "Maximum Slider Value for Sedimentation Rate [m per Myr]",
              value = 1,
              min = 0,
              step = 0.1
            ),
            numericInput(
              inputId = "max_slider_val_pat",
              label = "Maximum Slider Value for Shell Input [# per Myr]",
              value = 1,
              min = 0,
              step = 0.1
            ),
            actionButton(
              inputId = "update_slider_options",
              label = "Apply Changes"
            )
          )
        )
      )
    ),
    #### AI: Bottom/Logos ####
    hr(),
    fluidRow(
      column(
        width = 3,
        img(
          src = "logos/UW_logo.svg",
          alt = "Logo of UW",
          width = "30%",
          align = "left"
        )
      ),
      column(
        width = 3,
        img(
          src = "logos/IDUB_logo.jpeg",
          alt = "Logo of IDUB",
          width = "30%",
          align = "left"
        )
      ),
      column(
        width = 3,
        img(
          src = "logos/mind_the_gap_logo.png",
          alt = "Logo of MindTheGap",
          width = "70%",
          align = "left"
        )
      ),
      column(
        width = 3,
        img(
          src = "logos/UU_logo.jpg",
          width = "70%",
          alt = "Logo of UU",
          align = "left"
        )
      )
    ),
    hr()
  )
)
#### S: Server ####
server <- function(input, output, session) {
  #### S: Reactive Variables, observeEvent, observe etc... ####
  observeEvent(input$go_to_app, {
    updateTabsetPanel(session,
      inputId = "condensation_app",
      selected = "app"
    )
  })
  observeEvent(input$go_to_app_2, {
    updateTabsetPanel(session,
      inputId = "condensation_app",
      selected = "app"
    )
  })

  time_unit <- eventReactive(input$update_model_options,
    {
      input$T_unit
    },
    ignoreInit = FALSE,
    ignoreNULL = FALSE
  )

  height_unit <- eventReactive(input$update_model_options,
    {
      input$L_unit
    },
    ignoreInit = FALSE,
    ignoreNULL = FALSE
  )

  duration <- eventReactive(input$update_model_options,
    {
      max(10^-9, req(input$duration))
    },
    ignoreInit = FALSE,
    ignoreNULL = FALSE
  )
  sed_content_unit <- eventReactive(input$update_model_options,
    {
      input$sed_content_unit
    },
    ignoreInit = FALSE,
    ignoreNULL = FALSE
  )
  sed_content_name <- eventReactive(input$update_model_options,
    {
      input$sed_content_name
    },
    ignoreInit = FALSE,
    ignoreNULL = FALSE
  )

  observeEvent(input$update_model_options,
    {
      updateTextInput(
        session = session,
        inputId = "max_slider_val_sed",
        label = paste("Maximum Slider Value for Sedimentation Rate [",
          height_unit(),
          " per ",
          time_unit(),
          "]",
          sep = ""
        )
      )
      updateNumericInput(
        session = session,
        inputId = "duration",
        label = paste("Timespan of Observation [",
          time_unit(),
          "]",
          sep = ""
        )
      )
      updateTextInput(
        session = session,
        inputId = "max_slider_val_pat",
        label = paste("Maximum Slider Value for ",
          input$sed_content_name,
          " Input [",
          input$sed_content_unit,
          " per ",
          time_unit(),
          "]",
          sep = ""
        )
      )
      updateNumericInput(
        session = session,
        inputId = "input_volume",
        label = paste(sed_content_name(),
          " Volume [",
          height_unit(),
          " per ",
          sed_content_unit(),
          "]",
          sep = ""
        )
      )
      updateNumericInput(
        session = session,
        inputId = "x_sed_2",
        step = duration() / 100,
        max = duration()
      )
      updateNumericInput(
        session = session,
        inputId = "x_sed_3",
        step = duration() / 100,
        max = duration()
      )
      updateNumericInput(
        session = session,
        inputId = "x_sed_4",
        step = duration() / 100,
        max = duration()
      )
      updateNumericInput(
        session = session,
        inputId = "x_pat_2",
        step = duration() / 100,
        max = duration()
      )
      updateNumericInput(
        session = session,
        inputId = "x_pat_3",
        step = duration() / 100,
        max = duration()
      )
      updateNumericInput(
        session = session,
        inputId = "x_pat_4",
        step = duration() / 100,
        max = duration()
      )
    },
    ignoreInit = FALSE,
    ignoreNULL = FALSE
  )

  max_slider_val_sed <- eventReactive(input$update_slider_options, {
    req(input$max_slider_val_sed)
  })
  max_slider_val_pat <- eventReactive(input$update_slider_options, {
    req(input$max_slider_val_pat)
  })

  observeEvent(input$update_slider_options,
    {
      updateSliderInput(
        session = session,
        inputId = "y_sed_1",
        min = -max_slider_val_sed(),
        max = max_slider_val_sed(),
        step = max_slider_val_sed() / 40
      )
      updateSliderInput(
        session = session,
        inputId = "y_sed_2",
        min = -max_slider_val_sed(),
        max = max_slider_val_sed(),
        step = max_slider_val_sed() / 40
      )
      updateSliderInput(
        session = session,
        inputId = "y_sed_3",
        min = -max_slider_val_sed(),
        max = max_slider_val_sed(),
        step = max_slider_val_sed() / 40
      )
      updateSliderInput(
        session = session,
        inputId = "y_sed_4",
        min = -max_slider_val_sed(),
        max = max_slider_val_sed(),
        step = max_slider_val_sed() / 40
      )
      updateSliderInput(
        session = session,
        inputId = "y_sed_5",
        min = -max_slider_val_sed(),
        max = max_slider_val_sed(),
        step = max_slider_val_sed() / 40
      )
      updateSliderInput(
        session = session,
        inputId = "y_pat_1",
        max = max_slider_val_pat(),
        step = max_slider_val_pat() / 20
      )
      updateSliderInput(
        session = session,
        inputId = "y_pat_2",
        max = max_slider_val_pat(),
        step = max_slider_val_pat() / 20
      )
      updateSliderInput(
        session = session,
        inputId = "y_pat_3",
        max = max_slider_val_pat(),
        step = max_slider_val_pat() / 20
      )
      updateSliderInput(
        session = session,
        inputId = "y_pat_4",
        max = max_slider_val_pat(),
        step = max_slider_val_pat() / 20
      )
      updateSliderInput(
        session = session,
        inputId = "y_pat_5",
        max = max_slider_val_pat(),
        step = max_slider_val_pat() / 20
      )
      updateSliderInput(
        session = session,
        inputId = "y_pat_6",
        max = max_slider_val_pat(),
        step = max_slider_val_pat() / 20
      )
      updateNumericInput(
        session = session,
        inputId = "input_volume",
        max = max_slider_val_sed() * 0.1,
        step = max_slider_val_sed() * 0.1 * 0.01
      )
    },
    ignoreInit = FALSE,
    ignoreNULL = FALSE
  )

  #### S: Calculations in DAIME model ####
  xdep <- reactive({
    c(0, req(input$x_sed_2), req(input$x_sed_3), req(input$x_sed_4), duration())
  })
  xpat <- reactive({
    c(0, req(input$x_pat_2), req(input$x_pat_3), req(input$x_pat_4), duration())
  })
  ydep <- reactive({
    c(input$y_sed_1, input$y_sed_2, input$y_sed_3, input$y_sed_4, input$y_sed_5)
  })
  ypat <- reactive({
    c(input$y_pat_1, input$y_pat_2, input$y_pat_3, input$y_pat_4, input$y_pat_5)
  })
  condensator_results <- reactive({
    condensator(
      xdep = xdep(),
      ydep = ydep(),
      xpat = xpat(),
      ypat = ypat(),
      duration = duration(),
      input_volume = req(input$input_volume),
      suppress_errors = TRUE,
      plot_options = list(
        col_options = c(
          pattern_col = "red",
          sed_col = "blue",
          sed_col_eroded = rgb(
            red = col2rgb("blue")[1, 1],
            green = col2rgb("blue")[2, 1],
            blue = col2rgb("blue")[3, 1],
            maxColorValue = 255,
            alpha = 124
          ),
          erosion_col = grey(0.7),
          sed_col_minus_input = "black",
          baseline_col = "black"
        ),
        line_options = c(
          pattern_lwd = 3,
          sed_lwd = 5,
          sed_lwd_minus_input = 3,
          sed_lwd_eroded = 1.5,
          hiatus_lwd = 5,
          baseline_lwd = 1
        ),
        name_options = c(
          L_unit = height_unit(),
          L_name = "Stratigraphic Height",
          T_unit = time_unit(),
          T_name = "Time",
          sed_rate_name = "Sedimentation Rate",
          sed_rate_name_strat = "Formation Velocity of Section",
          sed_content_name = sed_content_name(),
          sed_content_unit = sed_content_unit(),
          sed_content_name_addition_time = "Input",
          sed_content_name_addition_strat = "Content",
          condensation_name = "Time Content of Section",
          erosion_label_time = "Will Be Eroded",
          erosion_label_age_model = "Erosion",
          erosion_label_strat = "Hiatus",
          erosion_label_everything_eroded = "No Section Formed"
        ),
        par_options = c(
          no_of_ticks = 5,
          axis_label_distance = 1.55,
          tick_label_distance = 0.6,
          label_expansion = 1.3
        ),
        points_plot = list(
          plot_sed_points = input$show_sed_points,
          x_sed_points = xdep(),
          y_sed_points = ydep(),
          sed_points_pch = 24,
          sed_points_expansion = 1.2,
          sed_points_col = "black",
          sed_points_bg = "black",
          sed_points_labels = c("S1", "S2", "S3", "S4", "S5"),
          sed_points_labels_col = "black",
          sed_points_labels_pos = c(4, 4, 4, 4, 2),
          sed_points_labels_expansion = 1,
          plot_pat_points = input$show_input_points,
          x_pat_points = xpat(),
          y_pat_points = ypat(),
          pat_points_pch = 24,
          pat_points_expansion = 1.2,
          pat_points_col = "black",
          pat_points_bg = "black",
          pat_points_labels = c("I1", "I2", "I3", "I4", "I5"),
          pat_points_labels_col = "black",
          pat_points_labels_pos = c(4, 4, 2, 4, 2),
          pat_points_labels_expansion = 1
        )
      )
    )
  })

  #### S: Render Plots ####
  output$time_plot <- renderPlot({
    par(
      mar = c(3, 3, 0, 3),
      cex = 1.2
    )
    condensator_plot(condensator_results(),
      keyword = "time"
    )
  })

  output$age_model <- renderPlot({
    par(mar = c(3, 3, 0, 3))
    condensator_plot(condensator_results(),
      keyword = "age model"
    )
  })

  output$height_plot <- renderPlot({
    par(mar = c(3, 3, 0, 3))
    condensator_plot(condensator_results(),
      keyword = input$condensation_display_mode
    )
  })

  #### S: Render Text Blocks ####
  output$input_rate_name <- renderText({
    paste(sed_content_name(),
      " Input [",
      sed_content_unit(),
      " per ",
      time_unit(),
      "]",
      sep = ""
    )
  })

  output$sedimentation_rate_name <- renderText({
    paste("Sedimentation Rate [",
      height_unit(),
      " per ",
      time_unit(),
      "]",
      sep = ""
    )
  })

  output$end_of_observation_name <- renderText({
    as.character(duration())
  })

  output$end_of_observation_name_2 <- renderText({
    as.character(duration())
  })
}

shinyApp(ui = ui, server = server)
