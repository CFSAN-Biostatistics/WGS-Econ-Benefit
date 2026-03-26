################################################################################
#
# Purpose: Examine cost vs. benefit of WGS efforts
#
# Authors and contributors: : John Ihrie, Michael Rinaldi, Timothy Harvey,
#  Ruth Timme, Marc Allard, Travis Minor, Maria Hoffmann, Tina Pfefer, Tony Senh
#
################################################################################

options(shiny.sanitize.errors = FALSE)

# For the R files
library(shiny)
library(shinyjs)
library(shinyvalidate)
library(rmarkdown)   # for render()

# For the Rmd file
library(knitr)
library(magrittr)
library(flextable)

source("R/helpers-element-modifications.R")
source("R/helpers-formatting.R")
source("R/helpers-tables.R")

glob_app_title   <- "WGS Econ Benefit"
glob_app_version <- "v1.1.0"

# Query string to ensure that browser re-downloads CSS & JS if version changes.
# https://stackoverflow.com/a/3467009
# https://stackoverflow.com/a/40943563
# https://stackoverflow.com/questions/3929064/whats-a-querystring-doing-in-this-stylesheets-href
glob_version_number <- sub("v", replacement = "", x = glob_app_version)
glob_css_query <- paste0("style.css?v=", glob_version_number)
glob_js_query  <- paste0("jscript.js?v=", glob_version_number)

# Predefined data --------------------------------------------------------------
glob_pathogen_data <- list(
  "Salmonella spp. (nontyphoidal)" = list(
    cost_per_case = 16668, cases_prevented_per_1000 = 178.4370
  ),
  "Listeria monocytogenes" = list(
    cost_per_case = 2504296, cases_prevented_per_1000 = 14.0679
  ),
  "E. coli (STEC O157)" = list(
    cost_per_case = 7238, cases_prevented_per_1000 = 162.5421
  )
)

# Fixed pay rates --------------------------------------------------------------
glob_technician_pay <- 25.00
glob_professional_pay <- 48.36

# Introduction -----------------------------------------------------------------
glob_intro_p1 <- HTML(
  "<p>",
  "This app allows users to quantify the benefit of their whole genome",
  "sequencing (WGS) work based on user-entered data including the annual number",
  "of WGS isolates sequenced and the costs associated with WGS. Benefits are",
  "calculated on an annual basis and can be shown for any one of three common",
  "foodborne pathogens: <i>Salmonella</i> spp. (nontyphoidal), <i>Listeria monocytogenes</i>,",
  "and <i>E. coli</i> (STEC). Benefits are quantified in terms of avoided illnesses,",
  "the dollar cost of avoided illnesses, and the ratio of benefits to WGS costs.",
  "Here is an example benefit statement (using hypothetical data):",
  "</p>",
  "<p>",
    "<blockquote><i>",
    "During the last year, samples sequenced by this lab directly prevented",
    "<b>7.03</b> cases of infection by <b>Listeria monocytogenes</b> thus",
    "avoiding <b>$17,615,093</b> in health-care costs. Every $1 spent by this",
    "lab on whole genome sequencing for <b>Listeria monocytogenes</b> saved",
    "<b>$302</b> in health-care costs due to avoided illnesses.",
    "</i></blockquote>",
  "</p>"
)

glob_intro_p2 <- HTML(
  "The app requires entry of data for the lab's costs associated with WGS",
  "(equipment, consumables, and staff time) along with the annual number of",
  "isolates sequenced for the pathogen of interest and the percentage of",
  "equipment use for the selected pathogen. Benefits are calculated from",
  "published studies including Brown et al., 2021 (illnesses avoided in",
  "relation to number of WGS isolates sequenced), Hoffmann et al., 2025 (cost",
  "per illness for various pathogens), and the U.S. Bureau of Labor Statistics",
  "Occupational Outlook Handbook (average hourly rates for laboratory staff)."
)
