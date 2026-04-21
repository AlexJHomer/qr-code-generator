library(shiny)
library(shinyjs)
library(qrcode)


ui <- fluidPage(
    useShinyjs(),
    titlePanel("QR code generator"),
    sidebarLayout(
        sidebarPanel(
            textInput("url",
                        "URL (or other text):",
                        placeholder = "http://example.com"),
            fileInput("logo",
                        "Upload logo...",
                        accept=c(".png", ".svg", ".jpg", ".jpeg")),
            actionButton("reset", "Reset file upload")
        ),
        mainPanel(
           plotOutput("qrcode")
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

    output$qrcode <- renderPlot({
        if (is.null(file_path())) {
          plot(qr_code(input$url))
        } else {
          input$url |>
            qr_code(ecl = "H") |>
            add_logo(logo = file_path(), ecl = "L") |>
            plot()
        }
    })
}

shinyApp(ui = ui, server = server)
