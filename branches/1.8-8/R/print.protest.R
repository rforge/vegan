"print.protest" <-
  function(x, digits = max(3, getOption("digits") - 3), ...)
{
  cat("\nCall:\n")
  cat(deparse(x$call), "\n\n")
  cat("Correlation in a symmetric Procrustes rotation:  ")
  cat(formatC(x$t0, digits = digits), "\n")
  cat("Significance:  ")
  cat(format.pval(x$signif, eps = 1/x$permutations),"\n")
  cat("Based on", x$permutations, "permutations")
  if (!is.null(x$strata)) 
    cat(", stratified within", x$strata)
  cat(".\n\n")
  invisible(x)
}
