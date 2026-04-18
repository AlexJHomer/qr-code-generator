library(shiny)
library(qrcode)

ui <- fluidPage(

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

    output$qrcode <- renderPlot({
        plot(qr_code(input$url))
    })
}

shinyApp(ui = ui, server = server)
