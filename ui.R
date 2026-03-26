ui <- fluidPage(id = "div_first",

  shinyjs::useShinyjs(),
  tags$html(lang = "en-US"),
  tags$head(
    #includeCSS("www/style.css"),  #for code development only!!!
    tags$link(rel = "stylesheet", type = "text/css", href = glob_css_query, defer = "defer"),
    #includeScript("www/jscript.js", defer = "defer"),  #for code development only!!!
    tags$script(src = glob_js_query, type = "text/javascript", defer = "defer"),
    tags$meta(name = "description",
      content = gsub("<.*?>", "", paste(glob_intro_p1, glob_intro_p2))
    ),
    tags$meta(name = "viewport", content = "width=device-width, initial-scale=1")
  ),

  HTML("<main>"),
  navbarPage(title = glob_app_title, id = "tabset",

    footer = tags$footer(paste(glob_app_title, glob_app_version)),

    # Home tab -----------------------------------------------------------------

    tabPanel(title = "Home", value = "home", icon = icon2("house"),
      tags$section(id = "home_section",
        h1(class = "app-title", glob_app_title),
        fluidRow(class = "intro-row",
          column(width = 12,
            h2(class = "app-subtitle",
              "Cost-Benefit Calculator for Whole Genome Sequencing"
            ),
            p(glob_intro_p1),
            p(glob_intro_p2),
            p(HTML(
              "<i>This application was developed by the U.S. Food",
              "and Drug Administration (FDA). Data entered are not recorded or",
              "saved by the FDA.</i>"
            )),
            actionButtonNext("home_next", label = "Let's begin!",
              aria_label = "Let's begin!"
            ),
            h3(class = "app-reference",
              "References"
            ),
            tags$ol(
              tags$li(
                "Brown B, Allard M, Bazaco MC, Blankenship J, Minor T (2021).",
                "An economic evaluation of the Whole Genome Sequencing source",
                "tracking program in the U.S..",
                "PLoS ONE 16(10): e0258262.",
                a(.noWS = "after", class = "weblink", target = "_blank",
                  "https://doi.org/10.1371/journal.pone.0258262",
                  href = "https://doi.org/10.1371/journal.pone.0258262",
                  icon2("external-link")
                )
              ),
              tags$li(
                "Hoffmann S, White AE, McQueen RB, Ahn J-W, Gunn-Sandell LB, Scallan Walter EJ.",
                "Economic Burden of Foodborne Illnesses Acquired in the United States.",
                "Foodborne Pathogens and Disease 2025 22:1, 4-14.",
                a(.noWS = "after", class = "weblink", target = "_blank",
                  "https://doi.org/10.1089/fpd.2023.0157",
                  href = "https://doi.org/10.1089/fpd.2023.0157",
                  icon2("external-link")
                )
              ),
              tags$li(
                "U.S. Bureau of Labor Statistics Occupational Outlook Handbook",
                a(.noWS = "after", class = "weblink", target = "_blank",
                  "https://www.bls.gov/ooh",
                  href = "https://www.bls.gov/ooh",
                  icon2("external-link")
                )
              )
            ),
            h3(class = "calculation-parameters",
              "Key calculational parameters used in this app:"
            ),
            tags$ol(type = "A",
              tags$li(
                "Cost per illness (Reference 2):",
                tags$ul(
                  tags$li(HTML(
                    "<i>Salmonella</i> spp. (nontyphoidal): $16,668"
                  )),
                  tags$li(HTML(
                    "<i>Listeria monocytogenes</i>: $2,504,296"
                  )),
                  tags$li(HTML(
                    "<i>E. coli</i> (STEC): $7,238"
                  ))
                )
              ),
              tags$li(
                "Illnesses avoided (Reference 1): 6.09 observed cases avoided",
                "annually for every 1,000 isolates sequenced"
              ),
              tags$li(
                "Underreporting factors: that is, number of actual cases",
                "occurring for each case reported (Reference 1):",
                tags$ul(
                  tags$li(HTML(
                    "<i>Salmonella</i> spp. (nontyphoidal): 29.30"
                  )),
                  tags$li(HTML(
                    "<i>Listeria monocytogenes</i>: 2.31"
                  )),
                  tags$li(HTML(
                    "<i>E. coli</i> (STEC): 26.69"
                  ))
                )
              )
            )
          )
        ),
        div(id = "mail_to",
          "Please",
          a("email HFP Biostatistics apps", class = "email-link",
            href = paste0(
              "mailto:HFP_Biostatistics_apps@fda.hhs.gov?subject=",
              glob_app_title, " bug/suggestion"
            )
          ),
          "with suggestions or bug reports."
        )
      )
    ),

    # General Information tab --------------------------------------------------

    tabPanel(title = "General", value = "info", icon = icon2("clipboard-question"),
      tags$section(id = "info_section",
        h1("General Information", class = "wizard-page"),
        fluidRow(
          column(width = 4,
            wellPanel(class = "input-well",
              `aria-label` = "User selections for General Information",
              h2("Identifying Information", class = "data-input-h2"),
              textInput2("lab_name", label = "Name of Lab:",
                value = ""
              ),
              hr(class = "input-separator"),
              dateInput("date", label = "Date:",
                value = "", format = "yyyy-mm-dd"
              ),
              hr(class = "input-separator"),
              textInput2("sequencer", label = "Make/Model of Sequencer:",
                value = ""
              ),
              helpText2(
                "Identify the sequencer that the subsequent cost data is based on."
              ),
              hr(class = "input-separator"),
              h2("Sample Data", class = "data-input-h2"),
              radioButtons2("pathogen", label = "Pathogen of Interest:",
                selected = character(0), inline = FALSE, width = NULL,
                choiceNames = c(
                  "<i>Salmonella</i> spp. (nontyphoidal)",
                  "<i>Listeria monocytogenes</i>",
                  "<i>E. coli</i> (STEC O157)"
                ),
                choiceValues = names(glob_pathogen_data)
              ),

              helpText2(
                "Select the pathogen of interest for this analysis."
              ),
              hr(class = "input-separator"),
              numericInput2("num_isolates",
                label = "Number of unique isolates sequenced in last 12 months:",
                value = NULL, min = 0, step = 1
              ),
              helpText2(
                "Enter the number of genomically unique isolates sequenced",
                "for the selected pathogen during the last 12 months."
              )
            )
          )
        ),
        actionButtonPrevious("info_previous"),
        actionButtonNext("info_next")
      )
    ),

    # Equipment tab ------------------------------------------------------------

    tabPanel(title = "Equipment", value = "equipment", icon = icon2("microscope"),
      tags$section(id = "equipment_section",
        h1("Equipment Cost Data", class = "wizard-page"),
        fluidRow(
          column(width = 4,
            wellPanel(class = "input-well",
              `aria-label` = "User selections for Equipment Cost Data",
              numericInput2("equip_capital", label = "Annualized equipment capital cost ($ per year):",
                value = NULL, min = 0, step = 1
              ),
              actionButtonExplain("equip_capital_explain_button",
                aria_label = "Show or hide the explanation"
              ),
              shinyjs::hidden(
                helpTextExplain("equip_capital_explain_text",
                  "<p>
                  Use the original purchase costs for sequencers and major laboratory
                  equipment that supports WGS together with estimated lifespans
                  for the equipment (5 years for computers and 10 years for major
                  laboratory equipment) to calculate annualized equipment costs.
                  Example: Sequencer purchased for $100k &sol; 10 years estimated
                  lifespan &equals; $10k per year; computer equipment purchased for $15k &sol; 5
                  years estimated lifespan &equals; $3k per year; total annualized equipment
                  cost &equals; $10k &plus; $3k &equals; $13k per year.
                  </p>
                  <p>
                  Please only include items of equipment costing $500 or more that
                  qualify as capital expenditure relevant for sample preparation
                  and sequencing, such as sequencing machines and durable lab
                  equipment as well as specific software purchasing or licensing
                  fees. Please do not include basic laboratory equipment (for example
                  refrigerators, centrifuges or pipettes), standard office computers
                  or standard office software (for example Word, Excel). If you have no
                  data on the purchase price, please provide an estimate, for example,
                  based on current costs of purchasing a similar piece of equipment.
                  </p>
                  <p>
                  For equipment that was donated or purchased at a significant
                  discount, use best estimate of the market price for the equipment.
                  </p>"
                )
              ),
              hr(class = "input-separator"),
              numericInput2("equip_maint", label = "Annual equipment maintenance cost ($ per year):",
                value = NULL, min = 0, step = 1
              ),
              helpText2(
                "Provide the annual costs for maintenance and calibration of the",
                "sequencers and other major laboratory equipment that supports",
                "WGS (same equipment that was included in the equipment capital",
                "cost calculation). "
              ),
              hr(class = "input-separator"),
              numericInput2("equip_use_rate", label = "Equipment use rate (%):",
                value = NULL, min = 0, max = 100, step = 1
              ),
              helpText2(
                "Enter the percentage of time that sequencers and other major",
                "laboratory equipment are used specifically for sequencing the",
                "selected pathogen."
              ),
              helpTextExplain("equip_use_rate_explain_text",
                "<p>
                Example: A sequencer is in use (on average) for 100 hours
                monthly, of which 65 hours (on average) are for isolates of
                the selected pathogen; in this case the use rate would be 65%.
                </p>"
              )
            )
          )
        ),
        actionButtonPrevious("equipment_previous"),
        actionButtonNext("equipment_next")
      )
    ),

    # Consumables tab ----------------------------------------------------------

    tabPanel(title = "Consumables", value = "consumables", icon = icon2("flask"),
      tags$section(id = "consumables_section",
        h1("Consumables Cost Data", class = "wizard-page"),
        fluidRow(
          column(width = 4,
            wellPanel(class = "input-well",
              `aria-label` = "User selections for Consumables Cost Data",
              numericInput2("consumables_cost", label = "Consumables cost (annual $):",
                value = NULL, min = 0, step = 1
              ),
              helpText2(
                "Enter the annual purchase cost for consumables used in sequencing",
                "the selected pathogen. Consumables include items that are used",
                "up in laboratory processes, such as reagents, petri dishes,",
                "disposable plastics, and other disposable supplies."
              ),
              hr(class = "input-separator"),
              numericInput2("failure_rate", label = "Analytical failure rate (%):",
                value = NULL, min = 0, max = 100, step = 1
              ),
              helpText2(
                "Provide the average failure rate of analytical processes as a",
                "percentage. This refers to the percentage of consumables that are",
                "wasted, for example, due to failed runs, and so on.",
                "If not relevant then enter 0%."
              ),
              helpTextExplain("failure_rate_explain_text",
                "<p>
                Example: A lab finds that on average 2 isolates from each full
                plate of 24 isolates do not get good coverage, thus requiring
                the sequencing to be rerun for those isolates. The analytical
                failure rate would be 2 &sol; 24 &equals; 8.3%.
                </p>"
              )
            )
          )
        ),
        actionButtonPrevious("consumables_previous"),
        actionButtonNext("consumables_next")
      )
    ),

    # Staff tab ----------------------------------------------------------------

    tabPanel(title = "Staff", value = "staff", icon = icon2("person"),
      tags$section(id = "staff_section",
        h1("Staff Time & Cost Data", class = "wizard-page"),
        fluidRow(
          column(width = 4,
            wellPanel(class = "input-well",
              `aria-label` = "User selections for Staff Time & Cost Data",
              actionButtonExplain("staff_explain_button",
                aria_label = "Show or hide the explanation",
                default_hidden = FALSE
              ),
              helpTextExplain("staff_explain_text",
                "<p>
                Provide the estimated typical hands-on time per sample (in minutes)
                spent by staff in each category, including all steps of the analytical
                process from receipt and opening of an incoming sample until interpretation
                and reporting of results. This should be the amount of staff time used
                for an activity, not the duration of the activity. For example, unsupervised
                processes such as incubation periods or sequencing runs should not be
                included in the estimates. Include any time spent on quality control
                as well as maintenance of equipment and time used for failed runs, and so on.
                </p>
                <p>
                If multiple samples are treated at the same time (that is, in batches)
                then divide the applicable staff time by the number of samples per batch.
                For example, if a laboratory technician takes 48 hours to complete all
                steps of the analytical process for a batch of 40 samples, then convert
                the time to minutes (48 hrs &equals; 2,880 minutes) and divide by the number
                of samples per batch (2,880 minutes &sol; 40 samples) to get 72 minutes per
                sample for the laboratory technician staff category.
                </p>"
              ),
              hr(class = "input-separator"),
              numericInput2("tech_time", label = "Technician Staff (person-minutes per sample):",
                value = NULL, min = 0, step = 1
              ),
              helpText2(
                '"Technician Staff/Laboratory Technicians" refers to staff who assist',
                "scientists with tasks such as lab setup, data collection, and",
                "observation, and who have a Bachelor's degree or higher.",
                "An example is the Biological Technician occupation:"
              ),
              a(.noWS = "after", class = "weblink", target = "_blank",
                "https://www.bls.gov/ooh/life-physical-and-social-science/biological-technicians.htm",
                href = "https://www.bls.gov/ooh/life-physical-and-social-science/biological-technicians.htm",
                icon2("external-link")
              ),
              hr(class = "input-separator"),
              numericInput2("prof_time", label = "Professional Staff (person-minutes per sample):",
                value = NULL, min = 0, step = 1
              ),
              helpText2(
                '"Professional Staff/Scientists" refers to staff who lead and independently',
                "carry out research activities, and who have a Master's degree or higher.",
                "An example is the Medical Scientist occupation:"
              ),
              a(.noWS = "after", class = "weblink", target = "_blank",
                "https://www.bls.gov/ooh/life-physical-and-social-science/medical-scientists.htm",
                href = "https://www.bls.gov/ooh/life-physical-and-social-science/medical-scientists.htm",
                icon2("external-link")
              ),
              hr(class = "input-separator"),
              numericInput2("overhead_pct", label = "Overhead/Indirect Costs (percent of pre-tax wages):",
                value = NULL, min = 0, step = 1
              ),
              helpText2(
                "Enter your organization's indirect or overhead costs as a percentage of pre-tax wages.",
                "For example, if overhead costs are 1.5 times the pre-tax wages, then enter 150%. <b>If the",
                "overhead rate for your facility is not known, then enter a default value of 100%.</b>",
                "(Reference: Guidelines for Regulatory Impact Analysis, U.S. Dept. of Health and Human",
                "Services, Office of the Assistant Secretary for Planning and Evaluation, 2016)"
              )
            )
          )
        ),
        actionButtonPrevious("staff_previous"),
        actionButtonNext("staff_next")
      )
    ),

    # Other tab ----------------------------------------------------------------

    tabPanel(title = "Other", value = "other", icon = icon2("question"),
      tags$section(id = "other_section",
        h1("Other Costs", class = "wizard-page"),
        fluidRow(
          column(width = 4,
            wellPanel(class = "input-well",
              `aria-label` = "User selections for Other Costs",
              numericInput2("other_costs", label = "Other costs (annualized $):",
                value = NULL, min = 0, step = 1
              ),
              helpText2(
                "Enter the annual amount of any other costs (such as for subcontracting",
                "or external services) related to sequencing the selected pathogen that",
                "were not included in the equipment, consumables, or staff time & costs above."
              )
            )
          )
        ),
        actionButtonPrevious("other_previous"),
        actionButtonNext("other_next")
      )
    ),

    # Results tab --------------------------------------------------------------

    tabPanel(title = "Results", value = "results", icon = icon2("hand-holding-dollar"),
      tags$section(id = "results_section",
        h1("Cost-Benefit Results", class = "wizard-page"),
        fluidRow(
          column(width = 12,
            div(class = "results-div",
              `aria-label` = "Results of Cost-Benefits analysis",
              uiOutput("chosen_pathogen"),
              div(class = "output-box",
                h2("Benefit-to-Cost Ratio"),
                uiOutput("b2c_ratio")
              ),
              uiOutput("c2b_statement"),
              div(class = "output-box",
                h2("Annual WGS Cost"),
                uiOutput("annual_wgs_cost")
              ),
              uiOutput("benefits_statement"),
              uiOutput("per_sample_cost"),
              downloadButton("download_word", label = "Download Report",
                class = "download-report", `aria-label` = "Download Report",
                icon = icon2("download")
              ),
              helpText2("The Download button is disabled if invalid input is found.")
            )
          )
        ),
        actionButtonPrevious("results_previous")
      )
    )

  ),
  HTML("</main>")
)
