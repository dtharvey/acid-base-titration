# user interface for acid-base-titration shiny app

# library(shiny)
# library(shinythemes)
# library(titrationCurves)
# library(shape)

# vector of indicator names
# indicator.name = c("bromophenol blue (3.0-4.6)",
#                    "bromocresol green (3.8-5.4)", 
#                    "methyl red (4.2-6.3)",
#                    "bromocresol purple (5.2-6.8)", 
#                    "bromothymol blue (6.0-7.6)", 
#                    "phenol red (6.8-8.4)", 
#                    "cresol red (7.2-8.8)", 
#                    "p-naphtholbenzein (9.0-11.0)", 
#                    "alizarin yellow R (10.1-12.0)")

ui = navbarPage("AC 3.0: Acid-Base Titrations",
     theme = shinytheme("journal"),
     header = tags$head(
       tags$link(rel = "stylesheet",
                 type = "text/css",
                 href = "style.css") 
     ),
     
     tabPanel("Introduction",
      fluidRow(
        withMathJax(),
        column(width = 6, 
          wellPanel(
            includeHTML("text/introduction.html")
      )),
        column(width = 6,
          align = "center",
          img(src = "intro_image.gif", height = "250px"),
          plotOutput("intro_plot", height = "500px")
          )
      )),  
     
     tabPanel("Strong Acids & Strong Bases",
      fluidRow(
        column(width = 6,
          wellPanel(
            includeHTML("text/activity1.html")
      )),
        column(width = 6,
          align = "center",
          splitLayout(
            #place controls here
            radioButtons("act1_analyte", "titrand", 
                         choices = c("strong acid", "strong base"), 
                         inline = FALSE),
            sliderInput("act1_concanalyte", "log[titrand (M)]", 
                        min = -3, max = 0, value = -1,
                        step = 0.01, width = "150px", ticks = FALSE),
            sliderInput("act1_conctitrant", "log[titrant (M)]", 
                        min = -3, max = 0, value = -0.699, 
                        step = 0.01, width = "150px", ticks = FALSE),
            sliderInput("act1_volanalyte", "mL titrand", 
                        min = 10, max = 100, value = 50,
                        step = 1, width = "150px", ticks = FALSE),
          ),
          splitLayout(
          sliderInput("act1_voltitrant", "volume range (mL)",
                      min = 0, max = 100, value = c(0,50),
                      step = 1, ticks = FALSE),
          selectInput("act1_ind", "indicator",
                      choices = indicator.name, selectize = FALSE)
          ),
          plotOutput("activity1_plot", height = "550px")
          )
      )), 
     
     tabPanel("Monoprotic Weak Acids & Weak Bases",
              fluidRow(
                column(width = 6,
                       wellPanel(
                         includeHTML("text/activity2.html")
                       )),
                column(width = 6,
                       align = "center",
                       splitLayout(
                         #place controls here
                         radioButtons("act2_analyte", "titrand", 
                                      choices = c("weak acid", "weak base"), 
                                      selected = "weak acid", 
                                      inline = FALSE),
                         sliderInput("act2_pk","pKa or pKb",
                                     min = 1, max = 14, value = 5,
                                     step = 0.01, width = "100px", 
                                     ticks = FALSE),
                         sliderInput("act2_concanalyte", "log[titrand (M)]", 
                                     min = -3, max = 0, value = -1,
                                     step = 0.01, width = "100px", 
                                     ticks = FALSE),
                         sliderInput("act2_conctitrant", "log[titrant (M)]", 
                                     min = -3, max = 0, value = -0.699, 
                                     step = 0.01, width = "100px", 
                                     ticks = FALSE),
                         sliderInput("act2_volanalyte", "mL titrand", 
                                     min = 10, max = 100, value = 50,
                                     step = 1, width = "100px", 
                                     ticks = FALSE),
                       ),
                       splitLayout(
                         sliderInput("act2_voltitrant", "volume range (mL)",
                                     min = 0, max = 100, value = c(0,50),
                                     step = 1, ticks = FALSE),
                         selectInput("act2_ind", "indicator",
                                     choices = indicator.name, 
                                     selectize = FALSE)
                       ),
                       plotOutput("activity2_plot", height = "550px")
                )
              )), 
     
     tabPanel("Diprotic Weak Acids & Weak Bases",
              fluidRow(
                column(width = 6,
                       wellPanel(
                         includeHTML("text/activity3.html")
                       )),
                column(width = 6,
                       align = "center",
                       splitLayout(
                         #place controls here
                         radioButtons("act3_analyte", "titrand", 
                                      choices = c("weak acid", "weak base"), 
                                      selected = "weak acid", 
                                      inline = FALSE),
                         sliderInput("act3_pk","pKa or pKb",
                                     min = 1, max = 14, value = c(5,9),
                                     step = 0.01, width = "150px", 
                                     ticks = FALSE),
                         sliderInput("act3_concanalyte", "log[titrand (M)]", 
                                     min = -3, max = 0, value = -1,
                                     step = 0.01, width = "100px", 
                                     ticks = FALSE),
                         sliderInput("act3_conctitrant", "log[titrant (M)]", 
                                     min = -3, max = 0, value = -0.699, 
                                     step = 0.01, width = "100px", 
                                     ticks = FALSE),
                         sliderInput("act3_volanalyte", "mL titrand", 
                                     min = 10, max = 100, value = 50,
                                     step = 1, width = "100px", 
                                     ticks = FALSE),
                       ),
                       splitLayout(
                         sliderInput("act3_voltitrant", "volume range (mL)",
                                     min = 0, max = 100, value = c(0,100),
                                     step = 1, ticks = FALSE),
                         selectInput("act3_ind", "indicator",
                                     choices = indicator.name, 
                                     selectize = FALSE)
                       ),
                       plotOutput("activity3_plot", height = "550px")
                )
              )), 
     
     tabPanel("Wrapping Up",
      fluidRow(
        column(width = 6,
               wellPanel(id = "wrapuppanel",
                  style = "overflow-y:scroll; max-height: 750px",
                  includeHTML("text/wrapup.html"))),
        column(width = 6,
          align = "center",
          plotOutput("wrapup_plot", height = "750px")
          )
          
      )) 
     
     ) 
