# Helper functions to format numbers

formatNumber <- function(number) {
  if (number < 0.01) {
    return(format(number, nsmall = 3))
  } else if (number < 10) {
    if (identical(10, round(number, digits = 2))) {
      num_digits <- 1
    } else {
      num_digits <- 2
    }
  } else if (number < 100) {
    if (identical(100, round(number, digits = 1))) {
      num_digits <- 0
    } else {
      num_digits <- 1
    }
  } else {
    num_digits <- 0
  }
  return(
    formatC(number, digits = num_digits, big.mark = ",", format = "f")
  )
}

# formatNumber(.0000123456)
# formatNumber(.0123456)
# formatNumber(.099123456)
# formatNumber(.123456)
# formatNumber(1.123456)
# formatNumber(9.9423456)
# formatNumber(9.99423456)
# formatNumber(9.99523456)
# formatNumber(10.00123456)
# formatNumber(99.0000123456)
# formatNumber(99.6000123456)
# formatNumber(99.99000123456)
# formatNumber(100.09000123456)
# formatNumber(1000.0000123456)
# formatNumber(1000.5000123456)

formatPercent <- function(perc, num_digits = 2) {
  if (perc < 0.01) {
    "< 0.01%"
  } else {
    paste0(
      formatC(perc, digits = num_digits, big.mark = ",", format = "f"),
      "%"
    )
  }
}

# formatPercent(.001)
# formatPercent(1)
# formatPercent(90)
# formatPercent(92.12345)

formatDollars <- function(dollar_amount, digits = 2) {
  if (identical(0, dollar_amount)) {
    return("$0.00")
  } else if (dollar_amount < 0.01) {
    return("< $0.01")
  }
  if (dollar_amount < 1) {
    digits <- 2
  }
  dollar_amount <- formatC(dollar_amount,
    digits = digits, big.mark = ",", format = "f"
  )
  return(paste0("$", dollar_amount))
}

# formatDollars(1000)
# formatDollars(1000, digits = 0)
# formatDollars(1000.12345)
# formatDollars(0.1)
# formatDollars(0.1, digits = 0)
# formatDollars(0.01)
# formatDollars(0.001)
# formatDollars(0)

formatRatioDollars <- function(ratio) {
  if (ratio < 0.01) {
    return("< $0.01")
  } else if (ratio < 100) {
    if (identical(100, round(ratio, digits = 2))) {
      num_digits <- 0
    } else {
      num_digits <- 2
    }
    return(formatDollars(ratio, digits = num_digits))
  } else {
    return(formatDollars(ratio, digits = 0))
  }
}

# formatRatioDollars(1000)
# formatRatioDollars(1000.12345)
# formatRatioDollars(999.9999)
# formatRatioDollars(100)
# formatRatioDollars(99.12345)
# formatRatioDollars(99.9912345)
# formatRatioDollars(99.99912345)
# formatRatioDollars(0.1)
# formatRatioDollars(0.01)
# formatRatioDollars(0.001)
# formatRatioDollars(1e-10)
