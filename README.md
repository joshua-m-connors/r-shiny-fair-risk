# r-shiny-fair-risk
Shiny application that can estimate risk using factor analysis of information risk (FAIR) risk analysis methods as defined by The Open Group (https://www.opengroup.org/).

 - Open FAIR Risk Taxonomy (O-RT) - https://publications.opengroup.org/editors-picks/open-fair/c20b
 - Open FAIR Risk Analysis (O-RA) - https://publications.opengroup.org/editors-picks/open-fair/c20a

Leverages lognormal distributions for likelihood calculations and poisson lognormal distribution for impact calculations (based on findings of the Cyentia IRIS 2022 report (https://www.cyentia.com/iris/#iris-2022)). It was also influenced by the book _How to Measure Anything in Cybersecurity Risk_ (https://www.howtomeasureanything.com/cybersecurity/) by Douglas Hubbard.

Distributions are used to calculate the various ranges of possible outcomes and are then combined to determine a final distribution of loss events.

The model can provide three sets of results:
  - Inherent (before controls) Loss Event Frequency (LEF)/Likelihood, Loss Magnitude (Loss)/Impact and Risk (1 and 10 year)
  - Current Residual (with existing controls) LEF/Likelihood, Loss/Impact and Risk (1 and 10 year)
  - Future Residual (after additional controls) LEF/Likelihood, Loss/Impact and Risk (1 and 10 year)

Within the application you can select to determine the LEF/likelihood range directly or indirectly, via threat event frequency (TEF), threat capability (TCAP), and resistance (control) strength (RS).
  - You may also determine Likelihood using TEF and vulnerability (VULN), without the use of TCAP and RS.

The inherent risk results are not provided when evaluating Likelihood directly due to inherent risk being a product of:
  - Increasing the TEF by 20% (assumes increased threat activity in the absences of controls)
  - Setting the VULN percentage to 95% (assumes there are some controls (5%) that are outside of the control of the organization)

These values were set somewhat arbitrarily, but the 95% VULN percentage is equivalent to a TCAP of 1% - 99% and a RS of 1% - 1%.

To use the Shiny applications you will need:
  - Rstudio - https://www.rstudio.com
  - R - https://cran.rstudio.com/

Open the app.R file in RStudio and click the Run App button in the top right corner of the code editing pane.

The application is written to be reactive, therefore results will update dynamically as other values are changed.

A demo version of the application can be viewed at SinyApps.io: https://jconnors.shinyapps.io/r-shiny-fair-risk-github/
- Note: this is posted under the free tier so excessive (>10 hours per month) use will result in the application becoming inaccessible.

Shiny Application Screen:

![image](https://user-images.githubusercontent.com/79239127/129280878-405b9b71-3613-4940-ab23-e64cd6e26f3e.png)

Example Results:

![image](https://user-images.githubusercontent.com/79239127/129367704-1c4d4c6e-df8e-4923-8851-cec023059f9c.png)

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
