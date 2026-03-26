# Helper functions to modify basic elements

icon2 <- function(name, class = NULL, lib = "font-awesome", aria_hidden = "true", ...) {
  my_icon <- shiny::icon(name,
    class = class, lib = lib, `aria-hidden` = aria_hidden, ...
  )
  my_icon$attribs$role <- "img"
  my_icon
}

actionButtonNext <- function(id, label = "Next", aria_label = "Go to next page.", ...) {
  shiny::actionButton(id, class = "next-button", label = label,
    icon = icon2("arrow-right"), `aria-label` = aria_label, ...
  )
}

actionButtonPrevious <- function(id, label = "Previous", aria_label = "Go to previous page.", ...) {
  shiny::actionButton(id, class = "previous-button", label = label,
    icon = icon2("arrow-left"), `aria-label` = aria_label, ...
  )
}

actionButtonExplain <- function(id, aria_label, default_hidden = TRUE, ...) {
  if (default_hidden) {
    label <- "Show explanation"
    icon_name <- "eye"
  } else {
    label = "Hide explanation"
    icon_name <- "eye-slash"
  }
  shiny::actionButton(id, class = "explain-button", label = label,
    icon = icon2(icon_name), `aria-label` = aria_label, ...
  )
}

helpText2 <- function(..., id = NULL) {
  shiny::helpText(id = id, class = "help-text", HTML(paste(...)))
}

helpTextExplain <- function(id, text) {
  shiny::helpText(id = id, class = "explain-text", HTML(text))
}

textInput2 <- function(inputId, label, value = "", width = NULL, placeholder = NULL, ...) {
  text_input <- textInput(inputId = inputId, label = label, value = value,
    width = width, placeholder = placeholder, ...
  )
  tagAppendAttributes(text_input, class = "text-input")
}

radioButtons2 <- function(inputId, label, choices = NULL, selected = NULL,
  inline = FALSE, width = NULL, choiceNames = NULL, choiceValues = NULL) {
  my_radio <- radioButtons(inputId, label, choices = choices, selected = selected,
    inline = inline, width = width,
    choiceNames = choiceNames, choiceValues = choiceValues
  )
  second_element <- HTML("<i>Salmonella</i> spp. (nontyphoidal)")
  my_radio[[3]][[2]]$children[[1]][[1]]$children[[1]]$children[[2]]$children[[1]] <- second_element
  third_element <- HTML("<i>Listeria monocytogenes</i>")
  my_radio[[3]][[2]]$children[[1]][[2]]$children[[1]]$children[[2]]$children[[1]] <- third_element
  fourth_element <- HTML("<i>E. coli</i> (STEC O157)")
  my_radio[[3]][[2]]$children[[1]][[3]]$children[[1]]$children[[2]]$children[[1]] <- fourth_element
  my_radio
}

numericInput2 <- function(id, label, value, min = NA, max = NA, step = NA) {
  num_input <- numericInput(
    inputId = id, label = label, value = value, min = min, max = max,
    step = step, width = NULL
  )
  tagAppendAttributes(num_input, class = "numeric-input")
}

toggleExplain <- function(id, session, default_hidden = TRUE) {
  id_button <- paste0(id, "_button")
  id_text   <- paste0(id, "_text")
  click_count <- session$input[[id_button]]
  is_odd <- click_count  %% 2 == 1
  if (default_hidden) {
    if (is_odd) {
      label_text <- "Hide explanation"
      icon_eye   <- icon2("eye-slash")
      shinyjs::show(id_text)
    } else {
      label_text <- "Show explanation"
      icon_eye   <- icon2("eye")
      shinyjs::hide(id_text)
    }
  } else {
    if (is_odd) {
      label_text <- "Show explanation"
      icon_eye   <- icon2("eye")
      shinyjs::hide(id_text)
    } else {
      label_text <- "Hide explanation"
      icon_eye   <- icon2("eye-slash")
      shinyjs::show(id_text)
    }
  }
  shiny::updateActionButton(id_button, session = session,
    label = label_text, icon = icon_eye
  )
}

toggleAlert <- function(selector, is_valid) {
  if (is_valid) {
    shinyjs::removeClass(selector = selector, class = "alert-danger")
    shinyjs::addClass(selector = selector, class = "alert-success")
  } else {
    shinyjs::removeClass(selector = selector, class = "alert-success")
    shinyjs::addClass(selector = selector, class = "alert-danger")
  }
}
