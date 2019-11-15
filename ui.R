#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# library(reticulate)
# conda_install(packages = "spleeter", pip = TRUE, forge = TRUE)
# py_install("spleeter", forge = TRUE)

ui <- fluidPage(
    titlePanel("SpleetR"),
    sidebarLayout(
        sidebarPanel(
            h3("About this site", align = "center"),
            div("This is a web service to split professionally recorded
              music to multiple channels using the ", span(a("Spleeter ", href = "https://github.com/deezer/spleeter"), style = "color:red"), "Python library."),
            br(), br(), br(),
            div("Created using", align = "center"),
            br(),
            p(img(src = "rstudio.png", height = 75, width = 200), align = "center"),
            br(),
            p(img(src = "spleeter_logo.png", height = 43, width = 200), align = "center")
            
        ),
        mainPanel(
            h1("Introducing Shiny"),
            p("Shiny is a new package from RStudio that makes it ", 
              em("incredibly easy "), 
              "to build interactive web applications with R."),
            br(),
            p("For an introduction and live examples, visit the ",
              a("Shiny homepage.", 
                href = "http://shiny.rstudio.com")),
            br(),
            h2("Features"),
            p("- Build useful web applications with only a few lines of code—no JavaScript required."),
            p("- Shiny applications are automatically 'live' in the same way that ", 
              strong("spreadsheets"),
              " are live. Outputs change instantly as users modify inputs, without requiring a reload of the browser."),
            tags$hr(),
            
            h1("Inputs + Preferences"),
            br(),
            h2("Step 1: Upload audio"),
            fileInput('audio1', 'Select file to upload: '),
            hr(),
            h2("Step 2: Preview audio"),
            uiOutput("preview_audio"),
            h2("Step 3: Choose parameters"),
            fluidRow(
                column(width = 4,
                radioButtons("stems", label = h3("Number of stems"), choiceNames = list(
                                                                    "2 stems (vocals/accompaniment)",
                                                                    "4 stems (vocals/bass/drums/other)",
                                                                    "5 stems (vocals/bass/drums/piano/other)"),
                                                                        choiceValues = list(
                                                                            2, 4, 5
                                                                        ))
                ),
                
                column(width = 4,
                selectInput("codec", label = h3("Output codec"), choices = c(
                                                                                "Wave" = "wav",
                                                                                "MP3" = "mp3"), selected = "mp3")
                ),
                
                column(width = 4,
                        sliderInput("bitrate", label = h3("Bitrate"), min = 128, max = 320, value = 128, animate = TRUE, post = 'kB/s')
                       )
                ),
            hr(),
            actionButton("spleet", strong("Spleet"), align = "center"),
            br(), hr(),
            
            h1("Results"), br(),
            h2(em("Spleeted"), " stems"), br(),

            uiOutput("results")
            
            
        )
        
    )
)

