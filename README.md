# WGS Econ Benefit web application

## **Introduction**

This is a Shiny app for quantifying the benefit versus cost of whole genome
sequencing (WGS) for three foodborne pathogens: 
*Salmonella* spp. (nontyphoidal), *Listeria monocytogenes*, and *E. coli* (STEC).

---

### **Software needed**

R is needed (version 4.5.1 or higher is recommended).
The following R packages (available on CRAN) are also needed:
*shiny*, *shinyjs*, *shinyvalidate*, *rmarkdown*, *knitr*, *magrittr*, and
*flextable*.

---

### **Running the code**

To run this app, place all the files into your R working directory. At the R
prompt, type: `shiny::runApp()`.
The app uses a wizard-style interface to walk the user through the required
steps.

---

### File md5sums

| File | md5sum |
| ---- | ------ |
| *global.R* | c5c5d6b51954a4be40b6584501a728a2 |
| *server.R* | 7caeb54b3454a0471846c0f3b33aca36 |
| *ui.R* | ee63a561f6a25bde52e661cb71b4812a |
| *wgs-report-word.Rmd* | 453b1cc6dba3984ae70313bbaac03c03 |
| *common/word-styling.docx* | a4411ba6e2b365736c52c7a018aecc0f |
| *R/helpers-element-modifications.R* | 7065b7aaaab617d787c7843b50969d66 |
| *R/helpers-formatting.R* | 5676234efad49e961242ff9ff7a1a2b0 |
| *R/helpers-table.R* | 84d7105b85c49f34d1cf2d886acea334 |
| *www/jscript.js* | 982e7d560bb0a3ec05469e3e1a90e1f0 |
| *www/style.css* | 8cb4163e3c97711e230a40a4209cfa20 |

---

### License

GPL-3

---
