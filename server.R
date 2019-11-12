library(shiny)
options(shiny.maxRequestSize = 10*1024^2)
library(stringi)
library(reticulate)
py_install("spleeter", forge = TRUE)
spleeter = import("spleeter.separator", delay_load = FALSE)

function(input, output)
{
  observeEvent(input$audio1,
    {
      path =
      if (is.null(input$audio1))
      {
        output$preview_audio = renderUI(
          {
            tagList(tags$h4("No audio file provided."), tags$hr())
          }
        )
      } else
      {
          filepath = paste0('File_',input$audio1$name)
          file.copy(from = input$audio1$datapath, to = paste("www", filepath, sep = '/'))
          output$preview_audio = renderUI(
            {
              tagList(
                tags$audio(src = filepath, type = "audio", controls = NA),
                tags$hr()
              )
            }
          )
      }
    }
  )
  
  inputaudiofile = eventReactive(input$audio1, {file.path(paste0('www/File_', input$audio1$name))})
  
  # stemN = eventReactive(input$stems, {input$stems})
  codec = eventReactive(input$codec, {input$codec})
  bitrate = eventReactive(input$bitrate, {input$bitrate})
  stemstring = eventReactive(input$stems,
    {
      switch (input$stems,
      "2" = "spleeter:2stems",
      "4" = "spleeter:4stems",
      "5" = "spleeter:5stems")
    })
  
  
  observeEvent(input$spleet,
  {
    sep = spleeter$Separator(stemstring())
    destination = paste("results/result", stri_rand_strings(1, 10), sep = "_")
    sep$separate_to_file(audio_descriptor = inputaudiofile(), destination = paste("www", destination, sep = "/"),
                                                            codec = codec(), bitrate = bitrate(), synchronous = TRUE)
    
    files = list.files(path = paste("www", destination, sep = "/"), pattern = "^(vocals|bass|accompaniment|bass|drums|other|piano)\\.(wav|mp3)$",
                       full.names = TRUE, recursive = FALSE)
    www_dest = paste0("www/", substr(files, 20, 29), "_", substr(files, 31, nchar(files)))
    file.copy(from = files, to = www_dest)
    output$results = renderUI(
      {
        filename = substr(www_dest, 5, nchar(www_dest))
        outpaths = list()
        for(i in 1:length(filename))
        {
          outpaths[[i]] = tags$audio(src = filename[i], type = "audio", controls = NA)
        }
        tagList(outpaths)
        # tagList(lapply(substr(www_dest, 5, nchar(www_dest)), tags$audio, type = "audio", controls = NA))
    #     
    #     # for(stems in files)
    #     # {
    #     #     tagList(
    #     #     tags$audio(src = stems, type = "audio", controls = NA),
    #     #     tags$br()
    #     #   )
    #     # }
    #   }
    # )
    # output$resultlen = length(files)
  })
})
}
  
