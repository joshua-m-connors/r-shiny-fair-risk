library(shiny)
library(shinyWidgets)
library(bslib)

source('ui.R', local = TRUE)
source('server.R')

light <- bs_theme(bg = "WhiteSmoke", fg = "black", primary = "#00563f")
dark <- bs_theme(bg = "black", fg = "white", primary = "#00563f")

# Run the app ----
shinyApp(ui = ui, server = server)