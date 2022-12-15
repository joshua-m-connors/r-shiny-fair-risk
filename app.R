library(shiny)
library(shinyWidgets)
library(bslib)

light <- bs_theme(bg = "WhiteSmoke", fg = "black", primary = "#00563f")
dark <- bs_theme(bg = "black", fg = "white", primary = "#00563f")

# Define UI ----
ui <- fluidPage(
  
  theme = dark,
  
  div(
    class = "custom-control custom-switch", 
    tags$input(
      id = "dark_mode", type = "checkbox", class = "custom-control-input",
      onclick = HTML("Shiny.setInputValue('dark_mode', document.getElementById('dark_mode').value);")
    ),
    tags$label(
      "Light/Dark Mode", `for` = "dark_mode", class = "custom-control-label"
    )
  ),
  
  titlePanel("Factor Analysis for Information Risk (FAIR) Analysis"),
  
  fluidRow(
    column(4,
           textInput("text", h3("Risk Analysis Title"),  width = '100%',
                     value = "Title..."))
  ),
  
  fluidRow(
    column(4,
           textInput("text", h3("Risk Analyst Name"),  width = '100%',
                     value = "Name..."))
  ),
  
  fluidRow(
    column(4,
           textAreaInput("text", h3("Risk Analysis Participants"), width = '100%',
                         value = "Names/Titles..."))
  ),
  
  fluidRow(
    column(4,
           dateInput("date", 
                     h3("Date of Risk Analysis"),
                     value = Sys.Date()))
  ),
  
  checkboxGroupInput("threatcheckGroup", label = h4("Threat Type(s) In Scope"), 
                     choices = list("External Deliberate" = 1, "External Not Deliberate" = 2, "Internal Deliberate" = 3, "Internal Not Deliberate" = 4, "Natural" = 5)),
  
  checkboxGroupInput("vulncheckGroup", label = h4("Vulnerability Type(s) In Scope"), 
                     choices = list("People" = 1, "Process" = 2, "Technology" = 3, "Partners" = 4)),
  
  checkboxGroupInput("losscheckGroup", label = h4("Impact/Loss Type(s) In Scope"), 
                     choices = list("Confidentiality" = 1, "Integrity" = 2, "Availability" = 3, "Privacy" = 4)),
  
  fluidRow(
    column(4,
           textAreaInput("text", h3("Risk Analysis Description"), width = '100%',
                         value = "Description..."))
  ),
  
  conditionalPanel(
    condition = "input.lkh_radio == 1",
  
    fluidRow(
      radioButtons("future_radio", h4("- Assess Future Risk"),
                   choices = list("No" = 1,
                                  "Yes" = 2),selected = 1, width = '100%')
    )
  ),
  
  fluidRow(
    
    h5("Note: Estimates below should be made with 90% confidence. This means roughly the bottom and top 5% of possible cases can be ignored."),
    
  ),
  
  fluidRow(
    h2("Likelihood/Frequency")
  ),
  
  fluidRow(
    radioButtons("lkh_radio", h4("- Likelihood Methods"),
                 choices = list("Threat Event Frequency and Vulnerability" = 1,
                                "Direct Likelihood - No Inherent or Future Risk Calculations Performed" = 2),selected = 1, width = '100%')
  ),
  conditionalPanel(
    condition = "input.lkh_radio == 1",
    
    fluidRow(
      h3("Threat Event Frequency")
    ),
    
    fluidRow(  
      h5("- The annual frequency that Threats are encountered, whether successful or not.")
    ),
    
    fluidRow(
      column(4,
             textAreaInput("text", h4("Threat Description"), width = '100%',
                           value = "Threat..."))
    ),
    
    fluidRow(
      
      column(4,
             formatNumericInput(
               inputId = "tef_min_num",
               label = "Threat Event Frequency - Minimum",
               value = 1,
               format = "dotDecimalCharCommaSeparator",
               width = "100%",
               align = "right"
             ),
      ),
      column(4,
             formatNumericInput(
               inputId = "tef_max_num",
               label = "Threat Event Frequency - Maximum",
               value = 10,
               format = "dotDecimalCharCommaSeparator",
               width = "100%",
               align = "right"
             ),
      ),
      
    ), 
    
    fluidRow(
      h3("Vulnerability")
    ),
    
    fluidRow(
      column(4,
             textAreaInput("text", h4("Vulnerability Description"), width = '100%',
                           value = "Vulnerability..."))
    ),
    
    fluidRow(
      radioButtons("vuln_radio", h4("- Vulnerability Methods"),
                   choices = list("Threat Capability and Control Strength" = 1,
                                  "Direct Vulnerability Percentage" = 2),selected = 1)
    ),
    conditionalPanel(
      condition = "input.vuln_radio == 1",
      
      fluidRow(  
        h5("- Threat Capability - the percentile range of ability and resources the typical Threat is likely to possess.")
      ),
      
      fluidRow(  
        h5("- Current Control Strength - the current percentile range of resistence strength the organization's controls have to Threats.")
      ),

      conditionalPanel(
        condition = "input.future_radio == 2",
        
        fluidRow(  
            h5("- Future Control Strength - the percentile range of resistence strength the organization's controls will have to Threats after additional controls are implemented.")
          )
      ),
      
      fluidRow(
        chooseSliderSkin("Flat", color = "#00563f"),
        column(4, 
               sliderInput("tcap_slider", h4("- Threat Capability (%)"), width = '100%',
                           min = 1, max = 99, value = c(10, 50)),
               sliderInput("cs_slider", h4("- Current Control Strength (%)"), width = '100%',
                           min = 1, max = 99, value = c(25, 75)),
               conditionalPanel(
                 condition = "input.future_radio == 2",
                  sliderInput("f_cs_slider", h4("- Future Control Strength (%)"), width = '100%',
                           min = 1, max = 99, value = c(35, 85))
                 ),
        ),
      ),
      
      conditionalPanel(
        condition = "input.future_radio == 2",
          fluidRow(
            column(4,
                   textAreaInput("text", h4("Future Controls Description"), width = '100%',
                                 value = "Future Controls..."))
          ),
      ),
      
      fluidRow(
        h4("- Current Vulnerability Percentage")
      ),
      
      fluidRow(
        verbatimTextOutput("r_vuln")
      ),
      
      conditionalPanel(
        condition = "input.future_radio == 2",
          fluidRow(
            h4("- Future Vulnerability Percentage")
          ),
      
          fluidRow(
            verbatimTextOutput("f_r_vuln")
          )
      ),
      
    ),
    
    conditionalPanel(
      condition = "input.vuln_radio == 2",
      
      fluidRow(  
        h5("- Current Vulnerability - the current percentage of attempts when a Threat will be successful.")
      ),
      conditionalPanel(
        condition = "input.future_radio == 2",
          fluidRow(  
            h5("- Future Vulnerability - the percentage of attempts when a Threat will be successful after additional controls are implemented.")
          )
      ),
      
      column(4,
             sliderInput("vuln_slider", h4("- Current Vulnerability (%)"), width = '100%',
                         min = 1, max = 99, value = c(10)),
             conditionalPanel(
               condition = "input.future_radio == 2",
                  sliderInput("f_vuln_slider", h4("- Future Vulnerability (%)"), width = '100%',
                         min = 1, max = 99, value = c(10))
             )
      )
    ),
  ),
  
  conditionalPanel(
    condition = "input.lkh_radio == 2",
    
    fluidRow(  
      h5("- Likelihood - the percentage of event when the Impact will be realized.")
    ),
    
    fluidRow(
      column(4,
             textAreaInput("text", h4("Likelihood Description"), width = '100%',
                           value = "Likelihood..."))
    ),
    
    fluidRow(
      
      column(4,
             formatNumericInput(
               inputId = "lkh_min_num",
               label = "Likelihood - Minimum",
               value = 1,
               format = "dotDecimalCharCommaSeparator",
               width = "100%",
               align = "right"
             ),
      ),
      column(4,
             formatNumericInput(
               inputId = "lkh_max_num",
               label = "Likelihood - Maximum",
               value = 10,
               format = "dotDecimalCharCommaSeparator",
               width = "100%",
               align = "right"
             ),
      ),
    ),
  ),
  
  fluidRow(
    h2("Impact/Magnitude")
  ),
  
  fluidRow(
    h3("Primary Impact")
  ),
  
  fluidRow(  
    h5("- Those Impacts incurred with every partially or wholly successful event.")
  ),
  
  fluidRow(  
    h5("- Impacts may include: (1) Response/Replacement, (2) Lost Productivity, (3) Competative Advantage, (4) Reputational Damage, and (5) Legal/Regulatory.")
  ),
  
  fluidRow(
    column(4,
           textAreaInput("text", h4("Primary Impact Description"), width = '100%',
                         value = "Impact..."))
  ),
  
  fluidRow(
    
    column(4,
           currencyInput("pi_min_num", "Current Primary Impact - Minimum ($)", value = 1000, format = "dollar", width = "100%", align = "right"),
    ),
    column(4,
           currencyInput("pi_max_num", "Current Primary Impact - Maximum ($)", value = 10000, format = "dollar", width = "100%", align = "right")
    )
  ), 
  
  conditionalPanel(
    condition = "input.future_radio == 2",
  
      fluidRow(
        
        column(4,
               currencyInput("f_pi_min_num", "Future Primary Impact - Minimum ($)", value = 1000, format = "dollar", width = "100%", align = "right"),
        ),
        column(4,
               currencyInput("f_pi_max_num", "Future Primary Impact - Maximum ($)", value = 10000, format = "dollar", width = "100%", align = "right")
        )
      )
  ),
  
  fluidRow(
    h3("Secondary Impact")
  ),
  
  fluidRow(  
    h5("- Those Impacts (Secondary Impact) incurred only a certain percentage (Secondary Impact Likelihood) of the time.")
  ),
  
  fluidRow(  
    h5("- Impacts may include: (1) Response/Replacement, (2) Lost Productivity, (3) Competitive Advantage, (4) Reputational Damage, and (5) Legal/Regulatory.")
  ),
  
  fluidRow(
    radioButtons("sl_radio", h4("- Secondary Loss Methods"),
                 choices = list("Overall Secondary Loss" = 1,
                                "Secondary Loss by Category" = 2),selected = 1)
  ),
  
  fluidRow(
    column(4,
           textAreaInput("text", h4("Secondary Impact Description"), width = '100%',
                         value = "Impact..."))
  ),
  
  conditionalPanel(
    condition = "input.sl_radio == 1",
    
    fluidRow(
      
      column(4, 
             sliderInput("oa_sl_slider", h4("- Current Secondary Loss Likelihood (%)"), width = '100%',
                         min = 1, max = 100, value = c(1, 5))
      )
    ),
    
    fluidRow(
      
      column(4,
             currencyInput("oa_si_min_num", "Current Secondary Loss Impact - Minimum ($)", value = 5000, format = "dollar", width = "100%", align = "right"),
      ),
      column(4,
             currencyInput("oa_si_max_num", "Current Secondary Loss Impact - Maximum ($)", value = 50000, format = "dollar", width = "100%", align = "right")
      ),
      
    ),
   
    conditionalPanel(
      condition = "input.future_radio == 2",
    
        fluidRow(
          
          column(4, 
                 sliderInput("f_oa_sl_slider", h4("- Future Secondary Loss Likelihood (%)"), width = '100%',
                             min = 1, max = 100, value = c(1, 5))
          )
        ),
        
        fluidRow(
          
          column(4,
                 currencyInput("f_oa_si_min_num", "Future Secondary Loss Impact - Minimum ($)", value = 5000, format = "dollar", width = "100%", align = "right"),
          ),
          column(4,
                 currencyInput("f_oa_si_max_num", "Future Secondary Loss Impact - Maximum ($)", value = 50000, format = "dollar", width = "100%", align = "right")
          )
        )
    ),
     
  ),
  
  conditionalPanel(
    condition = "input.sl_radio == 2",
    
    fluidRow(  
      h4("- Response/Replacement")
    ),
    
    fluidRow(
      
      column(4, 
             sliderInput("rr_sl_slider", h6("Current Response/Replacement Likelihood (%)"), width = '100%',
                         min = 1, max = 100, value = c(1, 5))
      )
    ),
    
    fluidRow(
      
      column(4,
             currencyInput("rr_si_min_num", "Current Response/Replacement Impact - Minimum ($)", value = 1000, format = "dollar", width = "100%", align = "right"),
      ),
      column(4,
             currencyInput("rr_si_max_num", "Current Response/Replacement Impact - Maximum ($)", value = 2000, format = "dollar", width = "100%", align = "right")
      ),
      
    ),
    
    conditionalPanel(
      condition = "input.future_radio == 2",
    
        fluidRow(
          
          column(4, 
                 sliderInput("f_rr_sl_slider", h6("Future Response/Replacement Likelihood (%)"), width = '100%',
                             min = 1, max = 100, value = c(1, 5))
          )
        ),
        
        fluidRow(
          
          column(4,
                 currencyInput("f_rr_si_min_num", "Future Response/Replacement Impact - Minimum ($)", value = 1000, format = "dollar", width = "100%", align = "right"),
          ),
          column(4,
                 currencyInput("f_rr_si_max_num", "Future Response/Replacement Impact - Maximum ($)", value = 2000, format = "dollar", width = "100%", align = "right")
          ),
          
        )
    ),
    
    
    fluidRow(  
      h4("- Lost Productivity")
    ),
    
    fluidRow(
      
      column(4, 
             sliderInput("lp_sl_slider", h6("Current Lost Productivity Likelihood (%)"), width = '100%',
                         min = 1, max = 100, value = c(1, 5))
      )
    ),
    
    fluidRow(
      
      column(4,
             currencyInput("lp_si_min_num", "Current Lost Productivity Impact - Minimum ($)", value = 1000, format = "dollar", width = "100%", align = "right"),
      ),
      column(4,
             currencyInput("lp_si_max_num", "Current Lost Productivity - Maximum ($)", value = 2000, format = "dollar", width = "100%", align = "right")
      ),
      
    ),
    
    conditionalPanel(
      condition = "input.future_radio == 2",
      
        fluidRow(
          
          column(4, 
                 sliderInput("f_lp_sl_slider", h6("Future Lost Productivity Likelihood (%)"), width = '100%',
                             min = 1, max = 100, value = c(1, 5))
          )
        ),
        
        fluidRow(
          
          column(4,
                 currencyInput("f_lp_si_min_num", "Future Lost Productivity Impact - Minimum ($)", value = 1000, format = "dollar", width = "100%", align = "right"),
          ),
          column(4,
                 currencyInput("f_lp_si_max_num", "Future Lost Productivity - Maximum ($)", value = 2000, format = "dollar", width = "100%", align = "right")
          ),
          
        )
    ),
    
    fluidRow(  
      h4("- Competitive Advantage")
    ),
    
    column(4, 
           sliderInput("ca_sl_slider", h6("Current Competitive Advantage Likelihood (%)"), width = '100%',
                       min = 1, max = 100, value = c(1, 5))
    ),
    
    fluidRow(
      
      column(4,
             currencyInput("ca_si_min_num", "Current Competitive Advantage Impact - Minimum ($)", value = 1000, format = "dollar", width = "100%", align = "right"),
      ),
      column(4,
             currencyInput("ca_si_max_num", "Current Competitive Advantage Impact - Maximum ($)", value = 2000, format = "dollar", width = "100%", align = "right")
      ),
    ),
    
    conditionalPanel(
      condition = "input.future_radio == 2",
      
        column(4, 
               sliderInput("f_ca_sl_slider", h6("Future Competitive Advantage Likelihood (%)"), width = '100%',
                           min = 1, max = 100, value = c(1, 5))
        ),
        
        fluidRow(
          
          column(4,
                 currencyInput("f_ca_si_min_num", "Future Competitive Advantage Impact - Minimum ($)", value = 1000, format = "dollar", width = "100%", align = "right"),
          ),
          column(4,
                 currencyInput("f_ca_si_max_num", "Future Competitive Advantage Impact - Maximum ($)", value = 2000, format = "dollar", width = "100%", align = "right")
          ),
        )
    ),
    
    fluidRow(  
      h4("- Reputational Advantage")
    ),
    
    column(4, 
           sliderInput("rd_sl_slider", h6("Current Reputational Damage Likelihood (%)"), width = '100%',
                       min = 1, max = 100, value = c(1, 5))
    ),
    
    fluidRow(
      
      column(4,
             currencyInput("rd_si_min_num", "Current Reputational Damage Impact - Minimum ($)", value = 1000, format = "dollar", width = "100%", align = "right"),
      ),
      column(4,
             currencyInput("rd_si_max_num", "Current Reputational Damage - Maximum ($)", value = 2000, format = "dollar", width = "100%", align = "right")
      ),
    ),
    
    conditionalPanel(
      condition = "input.future_radio == 2",
      
        column(4, 
               sliderInput("f_rd_sl_slider", h6("Future Reputational Damage Likelihood (%)"), width = '100%',
                           min = 1, max = 100, value = c(1, 5))
        ),
        
        fluidRow(
          
          column(4,
                 currencyInput("f_rd_si_min_num", "Future Reputational Damage Impact - Minimum ($)", value = 1000, format = "dollar", width = "100%", align = "right"),
          ),
          column(4,
                 currencyInput("f_rd_si_max_num", "Future Reputational Damage - Maximum ($)", value = 2000, format = "dollar", width = "100%", align = "right")
          ),
        )
    ),
    
    fluidRow(  
      h4("- Legal/Regulatory")
    ),
    
    column(4, 
           sliderInput("lr_sl_slider", h6("Current Legal/Regulatory Likelihood (%)"), width = '100%',
                       min = 1, max = 100, value = c(1, 5))
    ),
    
    fluidRow(
      
      column(4,
             currencyInput("lr_si_min_num", "Current Legal/Regulatory Impact - Minimum ($)", value = 1000, format = "dollar", width = "100%", align = "right"),
      ),
      column(4,
             currencyInput("lr_si_max_num", "Current Legal/Regulatory - Maximum ($)", value = 2000, format = "dollar", width = "100%", align = "right")
      ),
    ),
  
  conditionalPanel(
    condition = "input.future_radio == 2",
    
      column(4, 
             sliderInput("f_lr_sl_slider", h6("Future Legal/Regulatory Likelihood (%)"), width = '100%',
                         min = 1, max = 100, value = c(1, 5))
      ),
      
      fluidRow(
        
        column(4,
               currencyInput("f_lr_si_min_num", "Future Legal/Regulatory Impact - Minimum ($)", value = 1000, format = "dollar", width = "100%", align = "right"),
        ),
        column(4,
               currencyInput("f_lr_si_max_num", "Future Legal/Regulatory - Maximum ($)", value = 2000, format = "dollar", width = "100%", align = "right")
        ),
      )
  ),
),
  
  conditionalPanel(
    condition = "input.lkh_radio == 1",
    
    fluidRow(
      h1("Inherent Risk")
    ),
    
    fluidRow(
      h2("Inherent Likelihood Summary")
    ),
    
    fluidRow(
      
      h2(" "),
      verbatimTextOutput("in_lkh_sum")
      
    ),
    
    fluidRow(
      
      sliderInput("in_lkh_bins", h3("# of bins"), width = '50%',
                  min = 1, max = 50, value = c(25)),
      plotOutput('in_lkh_hist')
      
    ),
    
    fluidRow(
      
      h2("Inherent Impact Summary")
      
    ),
    
    fluidRow(
      
      h2(" "),
      verbatimTextOutput("in_ipt_sum")
      
    ),
    
    fluidRow(
      
      sliderInput("in_ipt_bins", h3("# of bins"), width = '50%',
                  min = 1, max = 50, value = c(25)),
      plotOutput('in_ipt_hist')
      
    ),
    
    fluidRow(
      
      h2("Inherent Risk Summary")
      
    ),  
    
    fluidRow(
      
      h4("Inherent Annual Loss Expectancy (1 year)")
      
    ),
    
    fluidRow(
      
      verbatimTextOutput("in_ale_sum"),
      verbatimTextOutput("in_ale_10"),
      verbatimTextOutput("in_ale_mode"),
      verbatimTextOutput("in_ale_90"),
      verbatimTextOutput("in_ale_99")
      
    ),  
    
    fluidRow(
      
      h4("Inherent Annual Loss Expectancy (10 years)")
      
    ),
    
    fluidRow(
      
      verbatimTextOutput("in_ale_ten_sum"),
      verbatimTextOutput("in_ale_ten_10"),
      verbatimTextOutput("in_ale_ten_90"),
      verbatimTextOutput("in_ale_ten_99")
      
    ),  
    
    fluidRow(
      
      sliderInput("in_ale_bins", h4("# of bins"), width = '50%',
                  min = 1, max = 50, value = c(25)),
      plotOutput('in_ale_hist')
      
    ),
  ),
  
  fluidRow(
    h1("Current Residual Risk")
  ),
  
  fluidRow(
    
    h2("Current Residual Likelihood Summary")
    
  ),
  
  fluidRow(
    
    h2(" "),
    verbatimTextOutput("lkh_sum")
    
  ),
  
  fluidRow(
    
    sliderInput("lkh_bins", h4("# of bins"), width = '50%',
                min = 1, max = 50, value = c(25)),
    plotOutput('lkh_hist')
    
  ),
  
  fluidRow(
    
    h2("Current Residual Impact Summary")
    
  ),
  
  fluidRow(
    
    h2(" "),
    verbatimTextOutput("ipt_sum")
    
  ),
  
  fluidRow(
    
    sliderInput("ipt_bins", h4("# of bins"), width = '50%',
                min = 1, max = 50, value = c(25)),
    plotOutput('ipt_hist')
    
  ),
  
  fluidRow(
    
    h2("Current Residual Risk Summary")
    
  ),
  
  fluidRow(
    
    h4("Current Residual Annual Loss Expectancy (1 year)")
    
  ),
  
  fluidRow(
    
    verbatimTextOutput("rale_sum"),
    verbatimTextOutput("rale_10"),
    verbatimTextOutput("rale_mode"),
    verbatimTextOutput("rale_90"),
    verbatimTextOutput("rale_99")
    
  ),
  
  fluidRow(
    
    h4("Current Residual Annual Loss Expectancy (10 years)")
    
  ),
  
  fluidRow(
    
    h2(" "),
    verbatimTextOutput("rale_ten_sum"),
    verbatimTextOutput("rale_ten_10"),
    verbatimTextOutput("rale_ten_90"),
    verbatimTextOutput("rale_ten_99")
    
  ),
  
  fluidRow(
    
    sliderInput("rale_bins", h4("# of bins"), width = '50%',
                min = 1, max = 50, value = c(25)),
    plotOutput('rale_hist_1'),
    plotOutput('rale_hist_2')
    
  ),
  
  conditionalPanel(
    condition = "input.lkh_radio == 1",
    
    conditionalPanel(
      condition = "input.future_radio == 2",
    
        fluidRow(
          h1("Future Residual Risk")
        ),
        
        fluidRow(
          
          h2("Future Residual Likelihood Summary")
          
        ),
        
        fluidRow(
          
          h2(" "),
          verbatimTextOutput("f_lkh_sum")
          
        ),
        
        fluidRow(
          
          sliderInput("f_lkh_bins", h4("# of bins"), width = '50%',
                      min = 1, max = 50, value = c(25)),
          plotOutput('f_lkh_hist')
          
        ),
        
        fluidRow(
          
          h2("Future Residual Impact Summary")
          
        ),
        
        fluidRow(
          
          h2(" "),
          verbatimTextOutput("f_ipt_sum")
          
        ),
        
        fluidRow(
          
          sliderInput("f_ipt_bins", h4("# of bins"), width = '50%',
                      min = 1, max = 50, value = c(25)),
          plotOutput('f_ipt_hist')
          
        ),
        
        fluidRow(
          
          h2("Future Residual Risk Summary")
          
        ),
        
        fluidRow(
          
          h4("Future Residual Annual Loss Expectancy (1 year)")
          
        ),
        
        fluidRow(
          
          verbatimTextOutput("f_rale_sum"),
          verbatimTextOutput("f_rale_10"),
          verbatimTextOutput("f_rale_mode"),
          verbatimTextOutput("f_rale_90"),
          verbatimTextOutput("f_rale_99")
          
        ),
        
        fluidRow(
          
          h4("Future Residual Annual Loss Expectancy (10 years)")
          
        ),
        
        fluidRow(
          
          h2(" "),
          verbatimTextOutput("f_rale_ten_sum"),
          verbatimTextOutput("f_rale_ten_10"),
          verbatimTextOutput("f_rale_ten_90"),
          verbatimTextOutput("f_rale_ten_99")
          
        ),
        
        fluidRow(
          
          sliderInput("f_rale_bins", h4("# of bins"), width = '50%',
                      min = 1, max = 50, value = c(25)),
          plotOutput('f_rale_hist_1'),
          plotOutput('f_rale_hist_2')
          
        ),
    ),
  ),
  
)
# Define server logic -----
server <- function(input, output, session) {
  
  library(ggplot2)
  library(scales)
  library(poilog)
  ##### Input Variables #############################################################################
  # Threat Event Frequency (Min, Max) 90% Confidence
  tef_min <- reactive({
    cbind(input$tef_min_num)
  })
  tef_max <- reactive({
    cbind(input$tef_max_num)
  })
  # Threat Capability (Min, Max) 90% Confidence
  # Percentage in decimal format
  tcap_min_stage <- reactive({
    cbind(input$tcap_slider[1])
  })
  tcap_min <- reactive({
    tcap_min_stage() / 100
  })
  tcap_max_stage <- reactive({
    cbind(input$tcap_slider[2])
  })
  tcap_max <- reactive({
    tcap_max_stage() / 100
  })
  # Control Strength (Min, Max) 90% Confidence
  # Percentage in decimal format
  cs_min_stage <- reactive({
    cbind(input$cs_slider[1])
  })
  cs_min <- reactive({
    cs_min_stage() / 100
  })
  cs_max_stage <- reactive({
    cbind(input$cs_slider[2])
  })
  cs_max <- reactive({
    cs_max_stage() / 100
  })
  # Future Control Strength (Min, Max) 90% Confidence
  # Percentage in decimal format
  f_cs_min_stage <- reactive({
    cbind(input$f_cs_slider[1])
  })
  f_cs_min <- reactive({
    f_cs_min_stage() / 100
  })
  f_cs_max_stage <- reactive({
    cbind(input$f_cs_slider[2])
  })
  f_cs_max <- reactive({
    f_cs_max_stage() / 100
  })
  future_option <- reactive({
    cbind(input$future_radio)
  })
  # Direct Vulnerability percentage
  vuln_option <- reactive({
    cbind(input$vuln_radio)
  })
  vuln_percent_stage <- reactive({
    cbind(input$vuln_slider)
  })
  vuln_percent <- reactive({
    vuln_percent_stage() / 100
  })
  # Direct Vulnerability percentage
  f_vuln_percent_stage <- reactive({
    cbind(input$f_vuln_slider)
  })
  f_vuln_percent <- reactive({
    f_vuln_percent_stage() / 100
  })
  # Likelihood (Min, Max) 90% Confidence
  # Percentage in decimal format
  lkh_option <- reactive({
    cbind(input$lkh_radio)
  })
  lkh_min <- reactive({
    cbind(input$lkh_min_num)
  })
  lkh_max <- reactive({
    cbind(input$lkh_max_num)
  })
  # Current Primary Impact (Min, Max) 90% Confidence
  pi_min <- reactive({
    cbind(input$pi_min_num)
  })
  pi_max <- reactive({
    cbind(input$pi_max_num)
  })
  # Future Primary Impact (Min, Max) 90% Confidence
  f_pi_min <- reactive({
    cbind(input$f_pi_min_num)
  })
  f_pi_max <- reactive({
    cbind(input$f_pi_max_num)
  })
  # Secondary Loss Option
  sl_option <- reactive({
    cbind(input$sl_radio)
  })
  # Overall Current Secondary Impact Likelihood (Min, Max) 90% Confidence
  # Percentage in decimal format
  oa_sl_min_stage <- reactive({
    cbind(input$oa_sl_slider[1])
  })
  oa_sl_min <- reactive({
    oa_sl_min_stage() / 100
  })
  oa_sl_max_stage <- reactive({
    cbind(input$oa_sl_slider[2])
  })
  oa_sl_max <- reactive({
    oa_sl_max_stage() / 100
  })
  # Overall Current Secondary Impact (Min, Max) 90% Confidence
  oa_si_min <- reactive({
    cbind(input$oa_si_min_num)
  })
  oa_si_max <- reactive({
    cbind(input$oa_si_max_num)
  })
  # Overall Future Secondary Impact Likelihood (Min, Max) 90% Confidence
  # Percentage in decimal format
  f_oa_sl_min_stage <- reactive({
    cbind(input$f_oa_sl_slider[1])
  })
  f_oa_sl_min <- reactive({
    f_oa_sl_min_stage() / 100
  })
  f_oa_sl_max_stage <- reactive({
    cbind(input$f_oa_sl_slider[2])
  })
  f_oa_sl_max <- reactive({
    f_oa_sl_max_stage() / 100
  })
  # Overall Future Secondary Impact (Min, Max) 90% Confidence
  f_oa_si_min <- reactive({
    cbind(input$f_oa_si_min_num)
  })
  f_oa_si_max <- reactive({
    cbind(input$f_oa_si_max_num)
  })
  # Current Respond/Replace Secondary Impact Likelihood (Min, Max) 90% Confidence
  # Percentage in decimal format
  rr_sl_min_stage <- reactive({
    cbind(input$rr_sl_slider[1])
  })
  rr_sl_min <- reactive({
    rr_sl_min_stage() / 100
  })
  rr_sl_max_stage <- reactive({
    cbind(input$rr_sl_slider[2])
  })
  rr_sl_max <- reactive({
    rr_sl_max_stage() / 100
  })
  # Current Respond/Replace Secondary Impact (Min, Max) 90% Confidence
  rr_si_min <- reactive({
    cbind(input$rr_si_min_num)
  })
  rr_si_max <- reactive({
    cbind(input$rr_si_max_num)
  })
  # Future Respond/Replace Secondary Impact Likelihood (Min, Max) 90% Confidence
  # Percentage in decimal format
  f_rr_sl_min_stage <- reactive({
    cbind(input$f_rr_sl_slider[1])
  })
  f_rr_sl_min <- reactive({
    f_rr_sl_min_stage() / 100
  })
  f_rr_sl_max_stage <- reactive({
    cbind(input$f_rr_sl_slider[2])
  })
  f_rr_sl_max <- reactive({
    f_rr_sl_max_stage() / 100
  })
  # Future Respond/Replace Secondary Impact (Min, Max) 90% Confidence
  f_rr_si_min <- reactive({
    cbind(input$f_rr_si_min_num)
  })
  f_rr_si_max <- reactive({
    cbind(input$f_rr_si_max_num)
  })
  # Current Lost Productivity Secondary Impact Likelihood (Min, Max) 90% Confidence
  # Percentage in decimal format
  lp_sl_min_stage <- reactive({
    cbind(input$lp_sl_slider[1])
  })
  lp_sl_min <- reactive({
    lp_sl_min_stage() / 100
  })
  lp_sl_max_stage <- reactive({
    cbind(input$lp_sl_slider[2])
  })
  lp_sl_max <- reactive({
    lp_sl_max_stage() / 100
  })
  # Current Lost Productivity Secondary Impact (Min, Max) 90% Confidence
  lp_si_min <- reactive({
    cbind(input$lp_si_min_num)
  })
  lp_si_max <- reactive({
    cbind(input$lp_si_max_num)
  })
  # Future Lost Productivity Secondary Impact Likelihood (Min, Max) 90% Confidence
  # Percentage in decimal format
  f_lp_sl_min_stage <- reactive({
    cbind(input$f_lp_sl_slider[1])
  })
  f_lp_sl_min <- reactive({
    f_lp_sl_min_stage() / 100
  })
  f_lp_sl_max_stage <- reactive({
    cbind(input$f_lp_sl_slider[2])
  })
  f_lp_sl_max <- reactive({
    f_lp_sl_max_stage() / 100
  })
  # Future Lost Productivity Secondary Impact (Min, Max) 90% Confidence
  f_lp_si_min <- reactive({
    cbind(input$f_lp_si_min_num)
  })
  f_lp_si_max <- reactive({
    cbind(input$f_lp_si_max_num)
  })
  # Current Competitive Advantage Secondary Impact Likelihood (Min, Max) 90% Confidence
  # Percentage in decimal format
  ca_sl_min_stage <- reactive({
    cbind(input$ca_sl_slider[1])
  })
  ca_sl_min <- reactive({
    ca_sl_min_stage() / 100
  })
  ca_sl_max_stage <- reactive({
    cbind(input$ca_sl_slider[2])
  })
  ca_sl_max <- reactive({
    ca_sl_max_stage() / 100
  })
  # Current Competitive Advantage Secondary Impact (Min, Max) 90% Confidence
  ca_si_min <- reactive({
    cbind(input$ca_si_min_num)
  })
  ca_si_max <- reactive({
    cbind(input$ca_si_max_num)
  })
  # Future Competitive Advantage Secondary Impact Likelihood (Min, Max) 90% Confidence
  # Percentage in decimal format
  f_ca_sl_min_stage <- reactive({
    cbind(input$f_ca_sl_slider[1])
  })
  f_ca_sl_min <- reactive({
    f_ca_sl_min_stage() / 100
  })
  f_ca_sl_max_stage <- reactive({
    cbind(input$f_ca_sl_slider[2])
  })
  f_ca_sl_max <- reactive({
    f_ca_sl_max_stage() / 100
  })
  # Future Competitive Advantage Secondary Impact (Min, Max) 90% Confidence
  f_ca_si_min <- reactive({
    cbind(input$f_ca_si_min_num)
  })
  f_ca_si_max <- reactive({
    cbind(input$f_ca_si_max_num)
  })
  # Current Reputational Damage Secondary Impact Likelihood (Min, Max) 90% Confidence
  # Percentage in decimal format
  rd_sl_min_stage <- reactive({
    cbind(input$rd_sl_slider[1])
  })
  rd_sl_min <- reactive({
    rd_sl_min_stage() / 100
  })
  rd_sl_max_stage <- reactive({
    cbind(input$rd_sl_slider[2])
  })
  rd_sl_max <- reactive({
    rd_sl_max_stage() / 100
  })
  # Current Reputational Damage Secondary Impact (Min, Max) 90% Confidence
  rd_si_min <- reactive({
    cbind(input$rd_si_min_num)
  })
  rd_si_max <- reactive({
    cbind(input$rd_si_max_num)
  })
  # Future Reputational Damage Secondary Impact Likelihood (Min, Max) 90% Confidence
  # Percentage in decimal format
  f_rd_sl_min_stage <- reactive({
    cbind(input$f_rd_sl_slider[1])
  })
  f_rd_sl_min <- reactive({
    f_rd_sl_min_stage() / 100
  })
  f_rd_sl_max_stage <- reactive({
    cbind(input$f_rd_sl_slider[2])
  })
  f_rd_sl_max <- reactive({
    f_rd_sl_max_stage() / 100
  })
  # Future Reputational Damage Secondary Impact (Min, Max) 90% Confidence
  f_rd_si_min <- reactive({
    cbind(input$f_rd_si_min_num)
  })
  f_rd_si_max <- reactive({
    cbind(input$f_rd_si_max_num)
  })
  # Current Legal/Regulatory Secondary Impact Likelihood (Min, Max) 90% Confidence
  # Percentage in decimal format
  lr_sl_min_stage <- reactive({
    cbind(input$lr_sl_slider[1])
  })
  lr_sl_min <- reactive({
    lr_sl_min_stage() / 100
  })
  lr_sl_max_stage <- reactive({
    cbind(input$lr_sl_slider[2])
  })
  lr_sl_max <- reactive({
    lr_sl_max_stage() / 100
  })
  # Current Legal/Regulatory Secondary Impact (Min, Max) 90% Confidence
  lr_si_min <- reactive({
    cbind(input$lr_si_min_num)
  })
  lr_si_max <- reactive({
    cbind(input$lr_si_max_num)
  })
  # Future Legal/Regulatory Secondary Impact Likelihood (Min, Max) 90% Confidence
  # Percentage in decimal format
  f_lr_sl_min_stage <- reactive({
    cbind(input$f_lr_sl_slider[1])
  })
  f_lr_sl_min <- reactive({
    f_lr_sl_min_stage() / 100
  })
  f_lr_sl_max_stage <- reactive({
    cbind(input$f_lr_sl_slider[2])
  })
  f_lr_sl_max <- reactive({
    f_lr_sl_max_stage() / 100
  })
  # Future Legal/Regulatory Secondary Impact (Min, Max) 90% Confidence
  f_lr_si_min <- reactive({
    cbind(input$f_lr_si_min_num)
  })
  f_lr_si_max <- reactive({
    cbind(input$f_lr_si_max_num)
  })
  # How Many Simulations?
  n <- 10000
  ###################################################################################################
  ##### Input Mean and Standard Deviation  Calculations #############################################
  # Threat Event Frequency
  tef_mean <- reactive({
    if (lkh_option()==1) {
      (log(tef_max())+log(tef_min()))/2
    }
  })
  tef_sd <- reactive({
    if (lkh_option()==1) {
      (log(tef_max())-log(tef_min()))/3.29
    }
  })
  # Threat Capability
  tcap_mean <- reactive({
    if (lkh_option()==1 & vuln_option()==1) {
      (log(tcap_max())+log(tcap_min()))/2
    }
  })
  tcap_sd <- reactive({
    if (lkh_option()==1 & vuln_option()==1) {
      (log(tcap_max())-log(tcap_min()))/3.29
    }
  })
  # Resistance Strength
  cs_mean <- reactive({
    if (lkh_option()==1 & vuln_option()==1) {
      (log(cs_max())+log(cs_min()))/2
    }
  })
  cs_sd <- reactive({
    if (lkh_option()==1 & vuln_option()==1) {
      (log(cs_max())-log(cs_min()))/3.29
    }
  })
  # Future Resistance Strength
  f_cs_mean <- reactive({
    if (lkh_option()==1 & future_option()==2 & vuln_option()==1) {
    (log(f_cs_max())+log(f_cs_min()))/2
    }
  })
  f_cs_sd <- reactive({
    if (lkh_option()==1 & future_option()==2 & vuln_option()==1) {
      (log(f_cs_max())-log(f_cs_min()))/3.29
    }
  })
  # Likelihood
  lkh_mean <- reactive({
    if (lkh_option()==2) {
      (log(lkh_max())+log(lkh_min()))/2
    }
  })
  lkh_sd <- reactive({
    if (lkh_option()==2) {
      (log(lkh_max())-log(lkh_min()))/3.29
    }
  })
  # Current Primary Single Event Impact
  pi_mean <- reactive({
    (log(pi_max())+log(pi_min()))/2
  })
  pi_sd <- reactive({
    (log(pi_max())-log(pi_min()))/3.29
  })
  # Future Primary Single Event Impact
  f_pi_mean <- reactive({
    if (lkh_option()==1 & future_option()==2) {
      (log(f_pi_max())+log(f_pi_min()))/2
    }
  })
  f_pi_sd <- reactive({
    if (lkh_option()==1 & future_option()==2) {
      (log(f_pi_max())-log(f_pi_min()))/3.29
    }
  })
  # Overall Current Secondary Impact Likelihood
  oa_sl_mean <- reactive({
    (log(oa_sl_max())+log(oa_sl_min()))/2
  })
  oa_sl_sd <- reactive({
    (log(oa_sl_max())-log(oa_sl_min()))/3.29
  })
  # Overall Current Secondary Single Event Impact
  oa_si_mean <- reactive({
    (log(oa_si_max())+log(oa_si_min()))/2
  })
  oa_si_sd <- reactive({
    (log(oa_si_max())-log(oa_si_min()))/3.29
  })
  # Overall Future Secondary Impact Likelihood
  f_oa_sl_mean <- reactive({
    if (lkh_option()==1 & future_option()==2 & sl_option()==1) {
      (log(f_oa_sl_max())+log(f_oa_sl_min()))/2
    }
  })
  f_oa_sl_sd <- reactive({
    if (lkh_option()==1 & future_option()==2 & sl_option()==1) {
      (log(f_oa_sl_max())-log(f_oa_sl_min()))/3.29
    }
  })
  # Overall Future Secondary Single Event Impact
  f_oa_si_mean <- reactive({
    if (lkh_option()==1 & future_option()==2 & sl_option()==1) {
      (log(f_oa_si_max())+log(f_oa_si_min()))/2
    }
  })
  f_oa_si_sd <- reactive({
    if (lkh_option()==1 & future_option()==2 & sl_option()==1) {
      (log(f_oa_si_max())-log(f_oa_si_min()))/3.29
    }
  })
  # Current Respond/Replace Secondary Impact Likelihood
  rr_sl_mean <- reactive({
    if (sl_option()==2) {
      (log(rr_sl_max())+log(rr_sl_min()))/2
    }
  })
  rr_sl_sd <- reactive({
    if (sl_option()==2) {
      (log(rr_sl_max())-log(rr_sl_min()))/3.29
    }
  })
  # Current Respond/Replace Secondary Single Event Impact
  rr_si_mean <- reactive({
    if (sl_option()==2) {
      (log(rr_si_max())+log(rr_si_min()))/2
    }
  })
  rr_si_sd <- reactive({
    if (sl_option()==2) {
      (log(rr_si_max())-log(rr_si_min()))/3.29
    }
  })
  # Future Respond/Replace Secondary Impact Likelihood
  f_rr_sl_mean <- reactive({
    if (lkh_option()==1 & future_option()==2 & sl_option()==2) {
    (log(f_rr_sl_max())+log(f_rr_sl_min()))/2
    }
  })
  f_rr_sl_sd <- reactive({
    if (lkh_option()==1 & future_option()==2 & sl_option()==2) {
      (log(f_rr_sl_max())-log(f_rr_sl_min()))/3.29
    }
  })
  # Future Respond/Replace Secondary Single Event Impact
  f_rr_si_mean <- reactive({
    if (lkh_option()==1 & future_option()==2 & sl_option()==2) {
      (log(f_rr_si_max())+log(f_rr_si_min()))/2
    }
  })
  f_rr_si_sd <- reactive({
    if (lkh_option()==1 & future_option()==2 & sl_option()==2) {
      (log(f_rr_si_max())-log(f_rr_si_min()))/3.29
    }
  })
  # Current Lost Productivity Secondary Impact Likelihood
  lp_sl_mean <- reactive({
    if (sl_option()==2) {
      (log(lp_sl_max())+log(lp_sl_min()))/2
    }
  })
  lp_sl_sd <- reactive({
    if (sl_option()==2) {
      (log(lp_sl_max())-log(lp_sl_min()))/3.29
    }
  })
  # Current Lost Productivity Secondary Single Event Impact
  lp_si_mean <- reactive({
    if (sl_option()==2) {
      (log(lp_si_max())+log(lp_si_min()))/2
    }
  })
  lp_si_sd <- reactive({
    if (sl_option()==2) {
      (log(lp_si_max())-log(lp_si_min()))/3.29
    }
  })
  # Future Lost Productivity Secondary Impact Likelihood
  f_lp_sl_mean <- reactive({
    if (lkh_option()==1 & future_option()==2 & sl_option()==2) {
      (log(f_lp_sl_max())+log(f_lp_sl_min()))/2
    }
  })
  f_lp_sl_sd <- reactive({
    if (lkh_option()==1 & future_option()==2 & sl_option()==2) {
      (log(f_lp_sl_max())-log(f_lp_sl_min()))/3.29
    }
  })
  # Future Lost Productivity Secondary Single Event Impact
  f_lp_si_mean <- reactive({
    if (lkh_option()==1 & future_option()==2 & sl_option()==2) {
      (log(f_lp_si_max())+log(f_lp_si_min()))/2
    }
  })
  f_lp_si_sd <- reactive({
    if (lkh_option()==1 & future_option()==2 & sl_option()==2) {
      (log(f_lp_si_max())-log(f_lp_si_min()))/3.29
    }
  })
  # Current Competitive Advantage Secondary Impact Likelihood
  ca_sl_mean <- reactive({
    if (sl_option()==2) {
      (log(ca_sl_max())+log(ca_sl_min()))/2
    }
  })
  ca_sl_sd <- reactive({
    if (sl_option()==2) {
      (log(ca_sl_max())-log(ca_sl_min()))/3.29
    }
  })
  # Current Competitive Advantage Secondary Single Event Impact
  ca_si_mean <- reactive({
    if (sl_option()==2) {
      (log(ca_si_max())+log(ca_si_min()))/2
    }
  })
  ca_si_sd <- reactive({
    if (sl_option()==2) {
      (log(ca_si_max())-log(ca_si_min()))/3.29
    }
  })
  # Future Competitive Advantage Secondary Impact Likelihood
  f_ca_sl_mean <- reactive({
    if (lkh_option()==1 & future_option()==2 & sl_option()==2) {
      (log(f_ca_sl_max())+log(f_ca_sl_min()))/2
    }
  })
  f_ca_sl_sd <- reactive({
    if (lkh_option()==1 & future_option()==2 & sl_option()==2) {
      (log(f_ca_sl_max())-log(f_ca_sl_min()))/3.29
    }
  })
  # Future Competitive Advantage Secondary Single Event Impact
  f_ca_si_mean <- reactive({
    if (lkh_option()==1 & future_option()==2 & sl_option()==2) {
      (log(f_ca_si_max())+log(f_ca_si_min()))/2
    }
  })
  f_ca_si_sd <- reactive({
    if (lkh_option()==1 & future_option()==2 & sl_option()==2) {
      (log(f_ca_si_max())-log(f_ca_si_min()))/3.29
    }
  })
  # Current Reputational Damage Secondary Impact Likelihood
  rd_sl_mean <- reactive({
    if (sl_option()==2) {
      (log(rd_sl_max())+log(rd_sl_min()))/2
    }
  })
  rd_sl_sd <- reactive({
    if (sl_option()==2) {
      (log(rd_sl_max())-log(rd_sl_min()))/3.29
    }
  })
  # Current Reputational Damage Secondary Single Event Impact
  rd_si_mean <- reactive({
    if (sl_option()==2) {
      (log(rd_si_max())+log(rd_si_min()))/2
    }
  })
  rd_si_sd <- reactive({
    if (sl_option()==2) {
      (log(rd_si_max())-log(rd_si_min()))/3.29
    }
  })
  # Future Reputational Damage Secondary Impact Likelihood
  f_rd_sl_mean <- reactive({
    if (lkh_option()==1 & future_option()==2 & sl_option()==2) {
      (log(f_rd_sl_max())+log(f_rd_sl_min()))/2
    }
  })
  f_rd_sl_sd <- reactive({
    if (lkh_option()==1 & future_option()==2 & sl_option()==2) {
      (log(f_rd_sl_max())-log(f_rd_sl_min()))/3.29
    }
  })
  # Future Reputational Damage Secondary Single Event Impact
  f_rd_si_mean <- reactive({
    if (lkh_option()==1 & future_option()==2 & sl_option()==2) {
      (log(f_rd_si_max())+log(f_rd_si_min()))/2
    }
  })
  f_rd_si_sd <- reactive({
    if (lkh_option()==1 & future_option()==2 & sl_option()==2) {
      (log(f_rd_si_max())-log(f_rd_si_min()))/3.29
    }
  })
  # Current Legal/Regulatory Secondary Impact Likelihood
  lr_sl_mean <- reactive({
    if (sl_option()==2) {
      (log(lr_sl_max())+log(lr_sl_min()))/2
    }
  })
  lr_sl_sd <- reactive({
    if (sl_option()==2) {
      (log(lr_sl_max())-log(lr_sl_min()))/3.29
    }
  })
  # Current Legal/Regulatory Secondary Single Event Impact
  lr_si_mean <- reactive({
    if (sl_option()==2) {
      (log(lr_si_max())+log(lr_si_min()))/2
    }
  })
  lr_si_sd <- reactive({
    if (sl_option()==2) {
      (log(lr_si_max())-log(lr_si_min()))/3.29
    }
  })
  # Future Legal/Regulatory Secondary Impact Likelihood
  f_lr_sl_mean <- reactive({
    if (lkh_option()==1 & future_option()==2 & sl_option()==2) {
      (log(f_lr_sl_max())+log(f_lr_sl_min()))/2
    }
  })
  f_lr_sl_sd <- reactive({
    if (lkh_option()==1 & future_option()==2 & sl_option()==2) {
      (log(f_lr_sl_max())-log(f_lr_sl_min()))/3.29
    }
  })
  # Future Legal/Regulatory Secondary Single Event Impact
  f_lr_si_mean <- reactive({
    if (lkh_option()==1 & future_option()==2 & sl_option()==2) {
      (log(f_lr_si_max())+log(f_lr_si_min()))/2
    }
  })
  f_lr_si_sd <- reactive({
    if (lkh_option()==1 & future_option()==2 & sl_option()==2) {
      (log(f_lr_si_max())-log(f_lr_si_min()))/3.29
    }
  })
  ###################################################################################################
  ##### FAIR Analysis Calculations ##################################################################
  # Generate a random seed
  rand <- floor(runif(1, min=1000, max=999999))
  #print(rand)
  set.seed(rand)
  # Calculate the Current Residual Threat Event Frequency (TEF)
  tef <- reactive({
    if (lkh_option()==1) {
      rpoilog(n,tef_mean(),tef_sd())
    }
  })
  # Calculate the Current Residual Threat Capability (TCap)
  tcap <- reactive({
    if (lkh_option()==1 & vuln_option()==1) {
      rlnorm(n,tcap_mean(),tcap_sd())
    }
  })
  # Calculate the Current Residual Control Strength (CS)
  cs <- reactive({
    if (lkh_option()==1 & vuln_option()==1) {
      rlnorm(n,cs_mean(),cs_sd())
    }
  })
  # Calculate the Future Residual Control Strength (CS)
  f_cs <- reactive({
    if (lkh_option()==1 & future_option()==2 & vuln_option()==1) {
      rlnorm(n,f_cs_mean(),f_cs_sd())
    }
  })
  # Calculate the Current Likelihood (CS)
  lkh_temp2 <- reactive({
    if (lkh_option()==2) {
      rpoilog(n,lkh_mean(),lkh_sd())
    }
  })
  # Calculate the Current Residual Vulnerability (Vuln)
  vuln_temp4 <- reactive({
    if (lkh_option()==1 & vuln_option()==1) {
      tcap() - cs()
    }
  })
  vuln_temp3 <- reactive({
    if (lkh_option()==1 & vuln_option()==1) {
      pmax(vuln_temp4(),0)
    }
  })
  vuln_temp2 <- reactive({
    if (lkh_option()==1 & vuln_option()==1) {
      pmin(vuln_temp3(),1)
    }
  })
  vuln_temp1 <- reactive({
    if (lkh_option()==1 & vuln_option()==1) {
      (sum(vuln_temp2() > 0))/n
    }
  })
  vuln <- reactive({
    if (lkh_option()==1 & vuln_option()==1) {
      vuln_temp1()
    } else {
      vuln_percent()
    }
  })
  # Calculate the Future Residual Vulnerability (Vuln)
  f_vuln_temp4 <- reactive({
    if (lkh_option()==1 & future_option()==2 & vuln_option()==1) {
      tcap() - f_cs()
    }
  })
  f_vuln_temp3 <- reactive({
    if (lkh_option()==1 & future_option()==2 & vuln_option()==1) {
      pmax(f_vuln_temp4(),0)
    }
  })
  f_vuln_temp2 <- reactive({
    if (lkh_option()==1 & future_option()==2 & vuln_option()==1) {
      pmin(f_vuln_temp3(),1)
    }
  })
  f_vuln_temp1 <- reactive({
    if (lkh_option()==1 & future_option()==2 & vuln_option()==1) {
      (sum(f_vuln_temp2() > 0))/n
    }
  })
  f_vuln <- reactive({
    if (lkh_option()==1 & future_option()==2 & vuln_option()==1) {
      f_vuln_temp1()
    } else {
      f_vuln_percent()
    }
  })
  ## Assumes the Inherent Vulnerability level is 90%
  in_vuln <- 0.95
  # Calculate the Current Residual Primary Likelihood (LKH)
  lkh_temp1 <- reactive({
    if (lkh_option()==1) {
      tef() * as.vector(vuln())
    }
  })
  lkh <- reactive({
    if (lkh_option()==1) {
      round(lkh_temp1(), digits = 2)
    } else {
      round(lkh_temp2(), digits = 2)
    }
  })
  # Calculate the Future Residual Primary Likelihood (LKH)
  f_lkh <- reactive({
    round(tef() * as.vector(f_vuln()), digits = 2)
  })
  ## Assumes that the Threat Event Frequency increases 20% in the absense of controls
  in_tef <- reactive({
    tef() * 1.1
  })
  in_lkh <- reactive({
    round(in_tef() * in_vuln, digits = 2)
  })
  ### Calculate the Inherent and Residual Primary and Secondary Impacts
  ### The Residual Primary Impact is the loss that will result with every occurrence
  pi <- reactive({
    rlnorm(n,pi_mean(),pi_sd())
  })
  ### Assumes that the Primary Impact increases 20% in the absence of controls
  in_pi <- reactive({
    pi() * 1.2
  })
  ### Future Primary Residual Impact
  f_pi <- reactive({
    rlnorm(n,f_pi_mean(),f_pi_sd())
  })
  ### Current Secondary Residual Risk Calculations
  ### The Overall Residual Secondary Impact Likelihood is the probability that the Secondary Impact will occur
  oa_sl <- reactive({
    if (sl_option()==1) {
      rpoilog(n,oa_sl_mean(),oa_sl_sd())
    }
  })
  ### The Overall Residual Secondary Impact is the loss that will only result with some percentage of occurrences
  oa_si <- reactive({
    if (sl_option()==1) {
      rlnorm(n,oa_si_mean(),oa_si_sd())
    }
  })  
  ### The Respond/Replace Residual Secondary Impact Likelihood is the probability that the Secondary Impact will occur
  rr_sl <- reactive({
    if (sl_option()==2) {
      rpoilog(n,rr_sl_mean(),rr_sl_sd())
    }
  })
  ### The Respond/Replace Residual Secondary Impact is the loss that will only result with some percentage of occurrences
  rr_si <- reactive({
    if (sl_option()==2) {
      rlnorm(n,rr_si_mean(),rr_si_sd())
    }
  })
  ### The Lost Productivity Residual Secondary Impact Likelihood is the probability that the Secondary Impact will occur
  lp_sl <- reactive({
    if (sl_option()==2) {
      rpoilog(n,lp_sl_mean(),lp_sl_sd())
    }
  })
  ### The Lost Productivity Residual Secondary Impact is the loss that will only result with some percentage of occurrences
  lp_si <- reactive({
    if (sl_option()==2) {
      rlnorm(n,lp_si_mean(),lp_si_sd())
    }
  })
  ### The Competitive Advantage Residual Secondary Impact Likelihood is the probability that the Secondary Impact will occur
  ca_sl <- reactive({
    if (sl_option()==2) {
      rpoilog(n,ca_sl_mean(),ca_sl_sd())
    }
  })
  ### The Competitive Advantage Residual Secondary Impact is the loss that will only result with some percentage of occurrences
  ca_si <- reactive({
    if (sl_option()==2) {
      rlnorm(n,ca_si_mean(),ca_si_sd())
    }
  })
  ### The Reputational Damage Residual Secondary Impact Likelihood is the probability that the Secondary Impact will occur
  rd_sl <- reactive({
    if (sl_option()==2) {
      rpoilog(n,rd_sl_mean(),rd_sl_sd())
    }
  })
  ### The Reputational Damage Residual Secondary Impact is the loss that will only result with some percentage of occurrences
  rd_si <- reactive({
    if (sl_option()==2) {
      rlnorm(n,rd_si_mean(),rd_si_sd())
    }
  })
  ### The Legal/Regulatory Residual Secondary Impact Likelihood is the probability that the Secondary Impact will occur
  lr_sl <- reactive({
    if (sl_option()==2) {
      rpoilog(n,lr_sl_mean(),lr_sl_sd())
    }
  })
  ### The Legal/Regulatory Residual Secondary Impact is the loss that will only result with some percentage of occurrences
  lr_si <- reactive({
    if (sl_option()==2) {
      rlnorm(n,lr_si_mean(),lr_si_sd())
    }
  })
  # Current Residual Secondary Impact
  si <- reactive({
    if (sl_option()==1) {
      oa_si()
    } else {
      rr_si() + lp_si() + ca_si() + rd_si() + lr_si()
    }
  })
  ### Future Secondary Residual Risk Calculations
  ### The Overall Residual Secondary Impact Likelihood is the probability that the Secondary Impact will occur
  f_oa_sl <- reactive({
    if (lkh_option()==1 & future_option()==2 & sl_option()==1) {
      rpoilog(n,f_oa_sl_mean(),f_oa_sl_sd())
    }
  })
  ### The Overall Residual Secondary Impact is the loss that will only result with some percentage of occurrences
  f_oa_si <- reactive({
    if (lkh_option()==1 & future_option()==2 & sl_option()==1) {
      rlnorm(n,f_oa_si_mean(),f_oa_si_sd())
    }
  })  
  ### The Respond/Replace Residual Secondary Impact Likelihood is the probability that the Secondary Impact will occur
  f_rr_sl <- reactive({
    if (lkh_option()==1 & future_option()==2 & sl_option()==2) {
      rpoilog(n,f_rr_sl_mean(),f_rr_sl_sd())
    }
  })
  ### The Respond/Replace Residual Secondary Impact is the loss that will only result with some percentage of occurrences
  f_rr_si <- reactive({
    if (lkh_option()==1 & future_option()==2 & sl_option()==2) {
      rlnorm(n,f_rr_si_mean(),f_rr_si_sd())
    }
  })
  ### The Lost Productivity Residual Secondary Impact Likelihood is the probability that the Secondary Impact will occur
  f_lp_sl <- reactive({
    if (lkh_option()==1 & future_option()==2 & sl_option()==2) {
      rpoilog(n,f_lp_sl_mean(),f_lp_sl_sd())
    }
  })
  ### The Lost Productivity Residual Secondary Impact is the loss that will only result with some percentage of occurrences
  f_lp_si <- reactive({
    if (lkh_option()==1 & future_option()==2 & sl_option()==2) {
      rlnorm(n,f_lp_si_mean(),f_lp_si_sd())
    }
  })
  ### The Competitive Advantage Residual Secondary Impact Likelihood is the probability that the Secondary Impact will occur
  f_ca_sl <- reactive({
    if (lkh_option()==1 & future_option()==2 & sl_option()==2) {
      rpoilog(n,f_ca_sl_mean(),f_ca_sl_sd())
    }
  })
  ### The Competitive Advantage Residual Secondary Impact is the loss that will only result with some percentage of occurrences
  f_ca_si <- reactive({
    if (lkh_option()==1 & future_option()==2 & sl_option()==2) {
      rlnorm(n,f_ca_si_mean(),f_ca_si_sd())
    }
  })
  ### The Reputational Damage Residual Secondary Impact Likelihood is the probability that the Secondary Impact will occur
  f_rd_sl <- reactive({
    if (lkh_option()==1 & future_option()==2 & sl_option()==2) {
      rpoilog(n,f_rd_sl_mean(),f_rd_sl_sd())
    }
  })
  ### The Reputational Damage Residual Secondary Impact is the loss that will only result with some percentage of occurrences
  f_rd_si <- reactive({
    if (lkh_option()==1 & future_option()==2 & sl_option()==2) {
      rlnorm(n,f_rd_si_mean(),f_rd_si_sd())
    }
  })
  ### The Legal/Regulatory Residual Secondary Impact Likelihood is the probability that the Secondary Impact will occur
  f_lr_sl <- reactive({
    if (lkh_option()==1 & future_option()==2 & sl_option()==2) {
      rpoilog(n,f_lr_sl_mean(),f_lr_sl_sd())
    }
  })
  ### The Legal/Regulatory Residual Secondary Impact is the loss that will only result with some percentage of occurrences
  f_lr_si <- reactive({
    if (lkh_option()==1 & future_option()==2 & sl_option()==2) {
      rlnorm(n,f_lr_si_mean(),f_lr_si_sd())
    }
  })
  # Future Residual Secondary Impact
  f_si <- reactive({
    if (sl_option()==1) {
      f_oa_si()
    } else {
      f_rr_si() + f_lp_si() + f_ca_si() + f_rd_si() + f_lr_si()
    }
  })
  ### Inherent Secondary Impact
  in_si <- reactive({
    si() * 1.2
  })
  # Inherent Impact
  in_ipt <- reactive({
    round(in_pi() + in_si())
  })
  # Current Residual Secondary Impact per Event
  sie <- reactive({
    if (sl_option()==1) {
      oa_si() * oa_sl()
    } else {
      (rr_sl() * rr_si()) + (lp_sl() * lp_si()) + (ca_sl() * ca_si()) + (rd_sl() * rd_si()) + (lr_sl() * lr_si())
    }
  })
  # Future Residual Secondary Impact per Event
  f_sie <- reactive({
    if (sl_option()==1) {
      f_oa_si() * f_oa_sl()
    } else {
      (f_rr_sl() * f_rr_si()) + (f_lp_sl() * f_lp_si()) + (f_ca_sl() * f_ca_si()) + (f_rd_sl() * f_rd_si()) + (f_lr_sl() * f_lr_si())
    }
  })
  # Current Residual Impact
  ipt <- reactive({
    round(pi() + sie())
  })
  # Future Residual Impact
  f_ipt <- reactive({
    round(f_pi() + f_sie())
  })
  # Current Residual Annual Loss Expectancy = lkh * ipt
  rale <- reactive({
    round(lkh() * ipt())
  })
  # Future Residual Annual Loss Expectancy = lkh * ipt
  f_rale <- reactive({
    round(f_lkh() * f_ipt())
  })
  # Current Residual Annual Loss Expectancy over 10 years
  rale_ten <- reactive({
    rale() * 10
  })
  # Future Residual Annual Loss Expectancy over 10 years
  f_rale_ten <- reactive({
    f_rale() * 10
  })
  ## Inherent Annual Loss Expectancy - Assumes the single loss expectancy increases 20% in the absense of controls
  in_ale <- reactive({
    round(in_lkh() * in_ipt())
  })
  ## Inherent Annual Loss Expectancy over 10 years
  in_ale_ten <- reactive({
    in_ale() * 10
  })
  # Mode identification function
  getmode <- function(v) {
    uniqv <- unique(v)
    uniqv[which.max(tabulate(match(v, uniqv)))]
  }
  # Residual Annual Loss Expectancy Percentile Calculations
  output$rale_10 <- renderPrint({
    print("Tenth Percentile")
    dollar(c(quantile(rale(), maxDecimals = 4, c(0.1))))
  })
  # Residual Annual Loss Expectancy Most Likely (Mode)
  output$rale_mode <- renderPrint({
    print("Most Likely")
    dollar(c(getmode(rale())))
  })
  output$rale_90 <- renderPrint({
    print("Ninetieth Percentile")  
    dollar(c(quantile(rale(), maxDecimals = 4, c(0.9))))
  })
  output$rale_99 <- renderPrint({
    print("Ninety-Ninth Percentile")  
    dollar(c(quantile(rale(), maxDecimals = 4, c(0.99))))
  })
  # Residual Annual Loss Expectancy over 10 year Percentile Calculations
  output$rale_ten_10 <- renderPrint({
    print("Tenth Percentile")
    dollar(c(quantile(rale_ten(), maxDecimals = 4, c(0.1))))
  })
  output$rale_ten_90 <- renderPrint({
    print("Ninetieth Percentile")  
    dollar(c(quantile(rale_ten(), maxDecimals = 4, c(0.9))))
  })
  output$rale_ten_99 <- renderPrint({
    print("Ninety-Ninth Percentile")  
    dollar(c(quantile(rale_ten(), maxDecimals = 4, c(0.99))))
  })
  # Future Residual Annual Loss Expectancy Percentile Calculations
  output$f_rale_10 <- renderPrint({
    print("Tenth Percentile")
    dollar(c(quantile(f_rale(), maxDecimals = 4, c(0.1))))
  })
  # Future Residual Annual Loss Expectancy Most Likely (Mode)
  output$f_rale_mode <- renderPrint({
    print("Most Likely")
    dollar(c(getmode(f_rale())))
  })
  output$f_rale_90 <- renderPrint({
    print("Ninetieth Percentile")  
    dollar(c(quantile(f_rale(), maxDecimals = 4, c(0.9))))
  })
  output$f_rale_99 <- renderPrint({
    print("Ninety-Ninth Percentile")  
    dollar(c(quantile(f_rale(), maxDecimals = 4, c(0.99))))
  })
  # Future Residual Annual Loss Expectancy over 10 year Percentile Calculations
  output$f_rale_ten_10 <- renderPrint({
    print("Tenth Percentile")
    dollar(c(quantile(f_rale_ten(), maxDecimals = 4, c(0.1))))
  })
  output$f_rale_ten_90 <- renderPrint({
    print("Ninetieth Percentile")  
    dollar(c(quantile(f_rale_ten(), maxDecimals = 4, c(0.9))))
  })
  output$f_rale_ten_99 <- renderPrint({
    print("Ninety-Ninth Percentile")  
    dollar(c(quantile(f_rale_ten(), maxDecimals = 4, c(0.99))))
  })
  # Inherent Annual Loss Expectancy Percentile Calculations
  output$in_ale_10 <- renderPrint({
    print("Tenth Percentile")
    dollar(c(quantile(in_ale(), maxDecimals = 4, c(0.1))))
  })
  # Inherent Annual Loss Expectancy Most Likely (Mode)
  output$in_ale_mode <- renderPrint({
    print("Most Likely")
    dollar(c(getmode(in_ale())))
  })
  output$in_ale_90 <- renderPrint({
    print("Ninetieth Percentile")
    dollar(c(quantile(in_ale(), maxDecimals = 4, c(0.9))))
  })
  output$in_ale_99 <- renderPrint({
    print("Ninety-Ninth Percentile")
    dollar(c(quantile(in_ale(), maxDecimals = 4, c(0.99))))
  })
  # Inherent Annual Loss Expectancy over 10 years Percentile Calculations
  output$in_ale_ten_10 <- renderPrint({
    print("Tenth Percentile")
    dollar(c(quantile(in_ale_ten(), maxDecimals = 4, c(0.1))))
  })
  output$in_ale_ten_90 <- renderPrint({
    print("Ninetieth Percentile")
    dollar(c(quantile(in_ale_ten(), maxDecimals = 4, c(0.9))))
  })
  output$in_ale_ten_99 <- renderPrint({
    print("Ninety-Ninth Percentile")
    dollar(c(quantile(in_ale_ten(), maxDecimals = 4, c(0.99))))
  })
  # Current Vulnerability
  output$r_vuln <- renderPrint({
    print(percent(vuln()))
  })
  # Future Vulnerability
  output$f_r_vuln <- renderPrint({
    print(percent(f_vuln()))
  })
  
  # Inherent Risk Renders
  
  output$in_lkh_sum <- renderPrint({
    
    summary(in_lkh())
  })
  
  ilb <- reactive({
    cbind(input$in_lkh_bins)
  })
  
  output$in_lkh_hist <- renderPlot({
    req(in_lkh())
    par(xpd=TRUE)
    hist(in_lkh(), col = "#00563f", breaks = ilb(), labels = TRUE)
  })
  
  output$in_ipt_sum <- renderPrint({
    
    dollar(c(summary(in_ipt())))
  })
  
  iib <- reactive({
    cbind(input$in_ipt_bins)
  })
  
  output$in_ipt_hist <- renderPlot({
    req(in_ipt())
    par(xpd=TRUE)
    hist(in_ipt(), col = "#00563f", breaks = iib(), labels = TRUE)
  })
  # Inherent Annual Loss Expectancy Summary
  output$in_ale_sum <- renderPrint({
    
    dollar(c(summary(in_ale())))
  })
  
  # Inherent Annual Loss Expectancy over 10 years Summary
  output$in_ale_ten_sum <- renderPrint({
    
    dollar(c(summary(in_ale_ten())))
  })
  
  iab <- reactive({
    cbind(input$in_ale_bins)
  })
  
  output$in_ale_hist <- renderPlot({
    req(in_ale())
    par(xpd=TRUE)
    hist(log(in_ale()), col = "#00563f",  breaks = iab(), labels = TRUE)
  })
  
  # Current Residual Risk Renders
  
  output$lkh_sum <- renderPrint({
    
    summary(lkh())
  })
  
  lb <- reactive({
    cbind(input$lkh_bins)
  })
  
  output$lkh_hist <- renderPlot({
    req(lkh())
    par(xpd=TRUE)
    hist(lkh(), col = "#00563f",  breaks = lb(), labels = TRUE)
  })
  
  output$ipt_sum <- renderPrint({
    
    dollar(c(summary(ipt())))
  })
  
  ib <- reactive({
    cbind(input$ipt_bins)
  })
  
  output$ipt_hist <- renderPlot({
    req(ipt())
    par(xpd=TRUE)
    hist(ipt(), col = "#00563f",  breaks = ib(), labels = TRUE)
  })
  # Current Residual Annual Loss Expectancy Summary
  output$rale_sum <- renderPrint({
    
    dollar(c(summary(rale())))
  })
  
  # Current Residual Annual Loss Expectancy over 10 years Summary
  output$rale_ten_sum <- renderPrint({
    
    dollar(c(summary(rale_ten())))
  })
  
  rab <- reactive({
    cbind(input$rale_bins)
  })
  
  output$rale_hist_1 <- renderPlot({
    req(rale())
    par(xpd=TRUE)
    hist(log(rale()), col = "#00563f",  breaks = rab(), labels = TRUE)
  })
  
  output$rale_hist_2 <- renderPlot({
    req(rale())
    par(xpd=TRUE)
    rh <- hist(rale(), plot=FALSE)
    rh$density = rh$counts/sum(rh$counts)*100
    plot(rh, freq=FALSE, col = "#00563f", labels = TRUE)
  })
  
  # Future Residual Risk Renders
  
  output$f_lkh_sum <- renderPrint({
    
    summary(f_lkh())
  })
  
  f_lb <- reactive({
    cbind(input$f_lkh_bins)
  })
  
  output$f_lkh_hist <- renderPlot({
    req(f_lkh())
    par(xpd=TRUE)
    hist(f_lkh(), col = "#00563f",  breaks = f_lb(), labels = TRUE)
  })
  
  output$f_ipt_sum <- renderPrint({
    
    dollar(c(summary(f_ipt())))
  })
  
  f_ib <- reactive({
    cbind(input$f_ipt_bins)
  })
  
  output$f_ipt_hist <- renderPlot({
    req(f_ipt())
    par(xpd=TRUE)
    hist(f_ipt(), col = "#00563f",  breaks = f_ib(), labels = TRUE)
  })
  # Future Residual Annual Loss Expectancy Summary
  output$f_rale_sum <- renderPrint({
    
    dollar(c(summary(f_rale())))
  })
  
  # Future Residual Annual Loss Expectancy over 10 years Summary
  output$f_rale_ten_sum <- renderPrint({
    
    dollar(c(summary(f_rale_ten())))
  })
  
  f_rab <- reactive({
    cbind(input$f_rale_bins)
  })
  
  output$f_rale_hist_1 <- renderPlot({
    req(f_rale())
    par(xpd=TRUE)
    hist(log(f_rale()), col = "#00563f",  breaks = f_rab(), labels = TRUE)
  })
  
  output$f_rale_hist_2 <- renderPlot({
    req(f_rale())
    par(xpd=TRUE)
    f_rh <- hist(f_rale(), plot=FALSE)
    f_rh$density = f_rh$counts/sum(f_rh$counts)*100
    plot(f_rh, freq=FALSE, col = "#00563f", labels = TRUE)
  })
  
  # Change Theme
  
  observe({
    session$setCurrentTheme(
      if (isTRUE(input$dark_mode)) light else dark
    )
  }) 
}

# Run the app ----
shinyApp(ui = ui, server = server)