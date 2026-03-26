# Helper function to build the web app's table HTML code

tablePerSampleCost <- function(equip_cost, consum_cost, staff_time, staff_cost, other_cost, total_cost) {
  html_cols <- "
    <thead>
      <tr>
        <th scope='col' class='text-left'>Source</th>
        <th scope='col' class='text-right'>Cost per sample</th>
      </tr>
    </thead>
  "
  html_row1 <- paste0(
    "<tr>",
      "<th scope = 'row' class='text-left'>Equipment</th>",
      "<td class='text-right'>", equip_cost, "</td>",
    "</tr>"
  )
  html_row2 <- paste0(
    "<tr>",
      "<th scope = 'row' class='text-left'>Consumables</th>",
      "<td class='text-right'>", consum_cost, "</td>",
    "</tr>"
  )
  html_row3 <- paste0(
    "<tr>",
      "<th scope = 'row' class='text-left'>Staff</th>",
      "<td class='text-right'>", staff_cost, "</td>",
    "</tr>"
  )
  html_row4 <- paste0(
    "<tr>",
      "<th scope = 'row' class='text-left'>Other</th>",
      "<td class='text-right'>", other_cost, "</td>",
    "</tr>"
  )
  html_total <- paste0(
    "<tr style=border-top-style:solid>",
      "<th scope = 'row' class='text-left'>Total per sample</th>",
      "<td class='text-right'>", total_cost, "</td>",
    "</tr>"
  )
  html_staff_time <- paste0(
    "<tr><td colspan='3'>",
      "Hands-on staff time per sample: ", staff_time, " hours",
    "</td></tr>"
  )
  div(class = "table-responsive",
    HTML(
      paste0(
        "<table id='per_sample_cost_table' class = 'table table-bordered table-condensed table-elastic table-striped'>",
          "<caption>",
            "Per sample cost breakdown",
          "</caption>",
          html_cols,
          "<tbody>",
            html_row1, html_row2, html_row3, html_row4,
          "</tbody>",
          "<tfoot>",
            html_total,
            html_staff_time,
          "</tfoot>",
        "</table>"
      )
    )
  )
}

# tablePerSampleCost("$21.60", "$44.00", "0.75", "$49.18", "$2.00", "$116.78")
