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
