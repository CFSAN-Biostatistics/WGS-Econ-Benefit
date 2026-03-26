server <- function(input, output, session) {

  # Javascript for improved accessibility --------------------------------------

  shinyjs::runjs("setHighLevelIds(100);")
  shinyjs::runjs("aFocus(100);")
  shinyjs::runjs("setTabLinkIDs(100);")
  
  observeEvent(c(input$tabset), {
    shinyjs::runjs("divTabpaneFocus(100);")
    shinyjs::runjs("aFocus(100);")
  })

  observeEvent(input$date, {
    shinyjs::runjs("adjustDatepicker(100)");
  })

  # Navigation wizard buttons --------------------------------------------------

  observeEvent(input$home_next, {
    updateTabsetPanel(inputId = "tabset", selected = "info")
    shinyjs::runjs("setFocus('info-link');")
  })

  observeEvent(input$info_previous, {
    updateTabsetPanel(inputId = "tabset", selected = "home")
    shinyjs::runjs("setFocus('home-link');")
  })
  observeEvent(input$info_next, {
    updateTabsetPanel(inputId = "tabset", selected = "equipment")
    shinyjs::runjs("setFocus('equipment-link');")
  })

  observeEvent(input$equipment_previous, {
    updateTabsetPanel(inputId = "tabset", selected = "info")
    shinyjs::runjs("setFocus('info-link');")
  })
  observeEvent(input$equipment_next, {
    updateTabsetPanel(inputId = "tabset", selected = "consumables")
    shinyjs::runjs("setFocus('consumables-link');")
  })

  observeEvent(input$consumables_previous, {
    updateTabsetPanel(inputId = "tabset", selected = "equipment")
    shinyjs::runjs("setFocus('equipment-link');")
  })
  observeEvent(input$consumables_next, {
    updateTabsetPanel(inputId = "tabset", selected = "staff")
    shinyjs::runjs("setFocus('staff-link');")
  })

  observeEvent(input$staff_previous, {
    updateTabsetPanel(inputId = "tabset", selected = "consumables")
    shinyjs::runjs("setFocus('consumables-link');")
  })
  observeEvent(input$staff_next, {
    updateTabsetPanel(inputId = "tabset", selected = "other")
    shinyjs::runjs("setFocus('other-link');")
  })

  observeEvent(input$other_previous, {
    updateTabsetPanel(inputId = "tabset", selected = "staff")
    shinyjs::runjs("setFocus('staff-link');")
  })
  observeEvent(input$other_next, {
    updateTabsetPanel(inputId = "tabset", selected = "results")
    shinyjs::runjs("setFocus('results-link');")
  })

  observeEvent(input$results_previous, {
    updateTabsetPanel(inputId = "tabset", selected = "other")
    shinyjs::runjs("setFocus('other-link');")
  })

  # Help text show and hide ----------------------------------------------------

  observeEvent(input$equip_capital_explain_button, {
    toggleExplain("equip_capital_explain", session)
  })
  observeEvent(input$staff_explain_button, {
    toggleExplain("staff_explain", session, default_hidden = FALSE)
  })

  # Checks on user inputs ------------------------------------------------------
  iv <- shinyvalidate::InputValidator$new()

  iv$add_rule("lab_name", sv_required())
  iv$add_rule("date", sv_required())
  iv$add_rule("pathogen", function(value) {
    if (is.null(value)) {
      "Required"
    }
  })
  iv$add_rule("num_isolates", sv_required())
  iv$add_rule("num_isolates", sv_integer())
  iv$add_rule("num_isolates", function(value) {
    if (value < 1) {
      "Must be a positive value."
    }
  })

  iv$add_rule("equip_capital", sv_required())
  iv$add_rule("equip_capital", function(value) {
    if (value < 0) {
      "Must be a nonnegative value."
    }
  })
  iv$add_rule("equip_maint", sv_required())
  iv$add_rule("equip_maint", function(value) {
    if (value < 0) {
      "Must be a nonnegative value."
    }
  })
  iv$add_rule("equip_use_rate", sv_required())
  iv$add_rule("equip_use_rate", function(value) {
    if (value <= 0 || value > 100) {
      "Must be a positive value no greater than 100."
    }
  })

  iv$add_rule("consumables_cost", sv_required())
  iv$add_rule("consumables_cost", function(value) {
    if (value < 0) {
      "Must be a nonnegative value."
    }
  })
  iv$add_rule("failure_rate", sv_required())
  iv$add_rule("failure_rate", function(value) {
    if (value < 0 || value >= 100) {
      "Must be a nonnegative value less than 100."
    }
  })

  iv$add_rule("tech_time", sv_required())
  iv$add_rule("tech_time", function(value) {
    if (value < 0) {
      "Must be a nonnegative value."
    }
  })
  iv$add_rule("prof_time", sv_required())
  iv$add_rule("prof_time", function(value) {
    if (value < 0) {
      "Must be a nonnegative value."
    }
  })
  iv$add_rule("overhead_pct", sv_required())
  iv$add_rule("overhead_pct", function(value) {
    if (value < 0) {
      "Must be a nonnegative value."
    }
  })

  iv$add_rule("other_costs", sv_required())
  iv$add_rule("other_costs", function(value) {
    if (value < 0) {
      "Must be a nonnegative value."
    }
  })
  
  iv$enable()

  # Calculations ---------------------------------------------------------------

  pathogen_html <- reactive({
    if (length(input$pathogen) == 0) {
      return("Pathogen not selected")
    }
    pathogen <- input$pathogen
    if (pathogen == "Salmonella spp. (nontyphoidal)") {
      "<i>Salmonella</i> spp. (nontyphoidal)"
    } else if (pathogen == "Listeria monocytogenes") {
      "<i>Listeria monocytogenes</i>"
    } else if (pathogen == "E. coli (STEC O157)") {
      "<i>E. coli</i> (STEC O157)"
    } else {
      "Problem with pathogen name"
    }
  })

  output$chosen_pathogen <- renderUI({
    pathogen <- pathogen_html()
    if (pathogen == "Pathogen not selected") {
      span(HTML("Pathogen not selected"))
    } else {
      span(HTML(paste("Pathogen selected:", pathogen_html())))
    }
  })

  equip_per_sample <- reactive({
    equipment_cost <- (input$equip_capital + input$equip_maint) * (input$equip_use_rate / 100)
    equipment_cost / input$num_isolates
  })
  equip_per_sample_f <- reactive(formatDollars(equip_per_sample()))
  
  consumables_per_sample <- reactive({
    (input$consumables_cost / input$num_isolates) * (1 + input$failure_rate / 100)
  })
  consumables_per_sample_f <- reactive(formatDollars(consumables_per_sample()))
  
  staff_costs <- reactive({
    base_cost_tech <- (input$tech_time / 60) * glob_technician_pay
    base_cost_prof <- (input$prof_time / 60) * glob_professional_pay
    base_cost <- base_cost_tech + base_cost_prof
    base_cost * (1 + input$overhead_pct / 100)
  })
  staff_costs_f <- reactive(formatDollars(staff_costs()))
  
  total_staff_time <- reactive({
    (input$tech_time + input$prof_time) / 60
  })
  total_staff_time_f <- reactive(formatNumber(total_staff_time()))
  
  other_per_sample <- reactive({
    input$other_costs / input$num_isolates
  })
  other_per_sample_f <- reactive(formatDollars(other_per_sample()))
  
  total_cost_per_sample <- reactive({
    equip_per_sample() + consumables_per_sample() + staff_costs() + other_per_sample()
  })
  total_cost_per_sample_f <- reactive(formatDollars(total_cost_per_sample()))
  
  annual_cost <- reactive({
    input$num_isolates * total_cost_per_sample()
  })
  annual_cost_f <- reactive(formatDollars(annual_cost()))
  
  cases_prevented <- reactive({
    path_data <- glob_pathogen_data[[input$pathogen]]
    (path_data$cases_prevented_per_1000 / 1000) * input$num_isolates
  })
  cases_prevented_f <- reactive(formatNumber(cases_prevented()))
  
  illness_cost_avoided <- reactive({
    path_data <- glob_pathogen_data[[input$pathogen]]
    cases_prevented() * path_data$cost_per_case
  })
  illness_cost_avoided_f <- reactive(formatDollars(illness_cost_avoided(), digits = 0))

  b2c_ratio <- reactive({
    illness_cost_avoided() / annual_cost()
  })
  b2c_ratio_num <- reactive(formatNumber(b2c_ratio()))
  b2c_ratio_dol <- reactive(formatDollars(b2c_ratio()))

  savings_per_dollar <- reactive({
    illness_cost_avoided() / annual_cost()
  })
  savings_per_dollar_f <- reactive(formatDollars(savings_per_dollar()))

  # Display results ------------------------------------------------------------

  is_valid <- reactive({
    iv$is_valid() && annual_cost() >= 1
  })

  observeEvent(is_valid(), {
    toggleAlert("div.output-box", is_valid())
    if (is_valid()) {
      shinyjs::enable("download_word")
    } else {
      shinyjs::disable("download_word")
    }
  })

  message_invalid <- reactive({
    if (!is.na(annual_cost()) && annual_cost() < 1) {
      span("Invalid (annual cost < $1)")
    } else {
      span("Invalid input")
    }
  })

  output$b2c_ratio <- renderUI({
    if (is_valid()) {
      paste(b2c_ratio_num(), "to 1")
    } else {
      message_invalid()
    }
  })

  output$c2b_statement <- renderUI({
    req(is_valid())
    pathogen <- HTML(pathogen_html())
    HTML(
      "<p>",
      "Every $1 spent by this lab on whole-genome sequencing for",
      # "<b>", input$pathogen, "</b>",
      "<b>", pathogen, "</b>",
      "during the past year saved",
      "<b>", b2c_ratio_dol(), "</b>",
      "in health care costs due to avoided illnesses.",
      "</p>"
    )
  })

  output$benefits_statement <- renderUI({
    req(is_valid())
    pathogen <- HTML(pathogen_html())
    HTML(
      "<p>",
      "During the last year, samples sequenced by this lab directly prevented",
      "<b>", cases_prevented_f(), "</b>", "cases of infection by",
      # "<b>", paste0(input$pathogen, ","), "</b>", "thus avoiding",
      "<b>", paste0(pathogen, ","), "</b>", "thus avoiding",
      "<b>", illness_cost_avoided_f(), "</b>", "in health-care costs.",
      "</p>"
    )
  })

  output$annual_wgs_cost <- renderUI({
    if (is_valid()) {
      annual_cost_f()
    } else {
      message_invalid()
    }
  })

  output$per_sample_cost <- renderUI({
    req(is_valid())
    tablePerSampleCost(
      equip_per_sample_f(), consumables_per_sample_f(),
      total_staff_time_f(), staff_costs_f(),
      other_per_sample_f(), total_cost_per_sample_f()
    )
  })

  output$download_word <- downloadHandler(
    filename = function() {
      paste0(
        "WGS-Cost-Benefit-Report-", format(Sys.time(), "%Y%m%d-%H%M%S"),
        ".docx"
      )
    },
    contentType = "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
    content = function(file) {   
      # Freeze parameters at click-time
      if (input$pathogen == "Salmonella spp. (nontyphoidal)") {
        pathogen <- "*Salmonella* spp. (nontyphoidal)"
      } else if (input$pathogen == "Listeria monocytogenes") {
        pathogen <- "*Listeria monocytogenes*"
      } else if (input$pathogen == "E. coli (STEC O157)") {
        pathogen <- "*E. coli* (STEC O157)"
      } else {
        pathogen <- "Problem with pathogen name"
      }
      params <- list(
        lab_name = input$lab_name,
        report_date = as.character(input$date),
        sequencer = input$sequencer,
        # pathogen = input$pathogen,
        pathogen = pathogen,
        num_isolates = input$num_isolates,
        equip_capital_f = formatDollars(input$equip_capital),
        equip_maint_f = formatDollars(input$equip_maint),
        equip_use_rate_f = formatPercent(input$equip_use_rate),
        consumables_cost_f = formatDollars(input$consumables_cost),
        failure_rate_f = formatPercent(input$failure_rate),
        tech_time_f = formatNumber(input$tech_time),
        prof_time_f = formatNumber(input$prof_time),
        overhead_pct_f = formatPercent(input$overhead_pct),
        other_costs_f = formatDollars(input$other_costs),
        glob_technician_pay_f = formatDollars(glob_technician_pay),
        glob_professional_pay_f = formatDollars(glob_professional_pay),
        equip_per_sample_f = equip_per_sample_f(),
        consumables_per_sample_f = consumables_per_sample_f(),
        staff_costs_f = staff_costs_f(),
        total_staff_time_f = total_staff_time_f(),
        other_per_sample_f = other_per_sample_f(),
        total_cost_per_sample_f = total_cost_per_sample_f(),
        annual_cost_f = annual_cost_f(),
        cases_prevented_f = cases_prevented_f(),
        illness_cost_avoided_f = illness_cost_avoided_f(),
        savings_per_dollar_f = savings_per_dollar_f()
      )
      # Render the report straight to the temp file path Shiny provides
      rmarkdown::render(
        input       = "wgs-report-word.Rmd",
        output_file = basename(file),                 # filename only
        output_dir  = dirname(file),                  # Shiny's temp dir
        params      = params,
        envir       = new.env(parent = globalenv()),
        quiet       = TRUE
      )
    }
  )

}
