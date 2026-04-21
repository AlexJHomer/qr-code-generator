library(shiny)
library(shinyjs)
library(qrcode)
library(colourpicker)

ui <- fluidPage(
    useShinyjs(),
    titlePanel("QR code generator"),
    sidebarLayout(
        sidebarPanel(
            textInput("url",
                        "URL (or other text):",
                        placeholder = "http://example.com"),
            colourInput("fg_colour",
                        "Foreground colour",
                        value = "black"),
            colourInput("bg_colour",
                        "Background colour",
                        value = "white",
                        allowTransparent = TRUE),
            fileInput("logo",
                        "Upload logo...",
                        accept=c(".png", ".svg", ".jpg", ".jpeg")),
            actionButton("reset", "Reset logo upload")

        ),
        mainPanel(
           plotOutput("qrcode"),
           div(style = "text-align: center;",
               downloadButton("save_file", "Download QR code (png)")
           )
        )
    )
)

server <- function(input, output) {
  runjs("$('#url').attr('maxlength',1000)")
    file_path <- reactiveVal()

    observe({
      file_path(input$logo$datapath)
    })

    observe({
      file_path(NULL)
      reset("logo")
    }) |>
      bindEvent(input$reset, ignoreInit = FALSE)

    chosen_code <- reactive({
      if (is.null(file_path())) {
        qr_code(input$url)
      } else {
        input$url |>
          qr_code(ecl = "H") |>
          add_logo(logo = file_path(), ecl = "L")
      }
    })

    output$qrcode <- renderPlot(
      plot(chosen_code(), col = c(input$bg_colour, input$fg_colour))
    )

    output$save_file <- downloadHandler(
      filename = "qr_code.png",
      content = function(file) {
        png(file, width = 2000, height = 2000, bg = "#00000000")
        plot(chosen_code(), col = c(input$bg_colour, input$fg_colour))
        dev.off()
      }
    )
}

shinyApp(ui = ui, server = server)
