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
                        placeholder = "http://example.com")
        ),
        mainPanel(
           plotOutput("qrcode")
        )
    )
)

server <- function(input, output) {
  runjs("$('#url').attr('maxlength',1000)")

    output$qrcode <- renderPlot({
        plot(qr_code(input$url))
    })
}

shinyApp(ui = ui, server = server)
