# user interface for acid-base-titration shiny app

ui = navbarPage("AC 3.0: Acid-Base Titrations",
     theme = shinytheme("journal"),
     header = tags$head(
       tags$link(rel = "stylesheet",
                 type = "text/css",
                 href = "style.css") 
     ),
     
     # introduction
     tabPanel("Introduction",
      fluidRow(
        withMathJax(),
        column(width = 6, 
          wellPanel(
            class = "scrollable-well",
            div(
              class = "html-fragment",
              includeHTML("text/introduction.html")
      ))),
        column(width = 6,
          align = "center",
          plotOutput("intro_plot", height = "350px"),
          img(src = "intro_image.gif", height = "250px")
          
          )
      )),  
     
     # first activity
     tabPanel("Strong Acids & Strong Bases",
      fluidRow(
        column(width = 6,
          wellPanel(
            class = "scrollable-well",
            div(
              class = "html-fragment",
              includeHTML("text/activity1.html")
      ))),
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
          plotOutput("activity1_plot", height = "480px")
          )
      )), 
     
     # second activity
     tabPanel("Monoprotic Weak Acids & Weak Bases",
              fluidRow(
                column(width = 6,
                       wellPanel(
                         class = "scrollable-well",
                         div(
                           class = "html-fragment",
                           includeHTML("text/activity2.html")
                       ))),
                column(width = 6,
                       align = "center",
                       splitLayout(
                         #place controls here
                         radioButtons("act2_analyte", "titrand", 
                                      choices = c("weak acid", 
                                                  "weak base"), 
                                      selected = "weak acid", 
                                      inline = FALSE),
                         sliderInput("act2_pk","pKa or pKb",
                                     min = 1, max = 14, value = 5,
                                     step = 0.01, width = "100px", 
                                     ticks = FALSE),
                         sliderInput("act2_concanalyte", 
                                     "log[titrand (M)]", 
                                     min = -3, max = 0, value = -1,
                                     step = 0.01, width = "100px", 
                                     ticks = FALSE),
                         sliderInput("act2_conctitrant", 
                                     "log[titrant (M)]", 
                                     min = -3, max = 0, value = -0.699, 
                                     step = 0.01, width = "100px", 
                                     ticks = FALSE),
                         sliderInput("act2_volanalyte", "mL titrand", 
                                     min = 10, max = 100, value = 50,
                                     step = 1, width = "100px", 
                                     ticks = FALSE),
                       ),
                       splitLayout(
                         sliderInput("act2_voltitrant", 
                                     "volume range (mL)",
                                     min = 0, max = 100, 
                                     value = c(0,50),
                                     step = 1, ticks = FALSE),
                         selectInput("act2_ind", "indicator",
                                     choices = indicator.name, 
                                     selectize = FALSE)
                       ),
                       plotOutput("activity2_plot", height = "480px")
                )
              )), 
     
     # third activity
     tabPanel("Diprotic Weak Acids & Weak Bases",
              fluidRow(
                column(width = 6,
                       wellPanel(
                         class = "scrollable-well",
                         div(
                           class = "html-fragment",
                           includeHTML("text/activity3.html")
                       ))),
                column(width = 6,
                       align = "center",
                       splitLayout(
                         #place controls here
                         radioButtons("act3_analyte", "titrand", 
                                      choices = c("weak acid", 
                                                  "weak base"), 
                                      selected = "weak acid", 
                                      inline = FALSE),
                         sliderInput("act3_pk","pKa or pKb",
                                     min = 1, max = 14, value = c(5,9),
                                     step = 0.01, width = "150px", 
                                     ticks = FALSE),
                         sliderInput("act3_concanalyte", 
                                     "log[titrand (M)]", 
                                     min = -3, max = 0, value = -1,
                                     step = 0.01, width = "100px", 
                                     ticks = FALSE),
                         sliderInput("act3_conctitrant", 
                                     "log[titrant (M)]", 
                                     min = -3, max = 0, value = -0.699, 
                                     step = 0.01, width = "100px", 
                                     ticks = FALSE),
                         sliderInput("act3_volanalyte", "mL titrand", 
                                     min = 10, max = 100, value = 50,
                                     step = 1, width = "100px", 
                                     ticks = FALSE),
                       ),
                       splitLayout(
                         sliderInput("act3_voltitrant", 
                                     "volume range (mL)",
                                     min = 0, max = 100, 
                                     value = c(0,100),
                                     step = 1, ticks = FALSE),
                         selectInput("act3_ind", "indicator",
                                     choices = indicator.name, 
                                     selectize = FALSE)
                       ),
                       plotOutput("activity3_plot", height = "480px")
                )
              )), 
     
     # wrapping up
     tabPanel("Wrapping Up",
      fluidRow(
        column(width = 6,
               wellPanel(
                 class = "scrollable-well",
                 div(
                   class = "html-fragment",
                   includeHTML("text/wrapup.html")
                 ))),
        column(width = 6,
          align = "center",
          plotOutput("wrapup_plot", height = "550")
          )
      ))
     ) 
