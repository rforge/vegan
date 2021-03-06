\name{vegan-internal}
\alias{ordiGetData}
\alias{ordiParseFormula}
\alias{ordiNAexclude}
\alias{ordiNApredict}
\alias{permuted.index}
\alias{centroids.cca}
\alias{ordiTerminfo}
\alias{pasteCall}
\alias{ordiArrowMul}
\alias{ordiArgAbsorber}
\alias{veganCovEllipse}
\title{Internal vegan functions}

\description{
  Internal vegan functions that are not intended to be called directly,
  but only within other functions.
}
\usage{
ordiGetData(call, env)
ordiParseFormula(formula, data, xlev = NULL, envdepth = 2, 
   na.action = na.fail, subset = NULL)
ordiTerminfo(d, data)
ordiNAexclude(x, excluded)
ordiNApredict(omit, x)
ordiArrowMul(x, at = c(0,0), fill = 0.75)
ordiArgAbsorber(..., shrink, origin, scaling, triangular,
                display, choices, const, FUN)
centroids.cca(x, mf, wt)
permuted.index(n, strata)
pasteCall(call, prefix = "Call:")
veganCovEllipse(cov, center = c(0, 0), scale = 1, npoints = 100)
}

\details{
  The description here is only intended for \pkg{vegan} developers:
  these functions are not intended for users, but they only should be
  used within functions
  
  \code{ordiGetData} finds the model frame of constraints and
  conditions in constrained ordination in the defined
  \code{env}ironment.  \code{ordiParseFormula} returns a list of three
  matrices (dependent variables, and \code{\link{model.matrix}} of
  constraints and conditions, possibly \code{NULL}) needed in
  constrained ordination. Argument \code{xlev} is passed to
  \code{\link{model.frame}} and argument \code{envdepth} specifies the
  depth at which the community data (dependent data) are evaluated;
  default \code{envdepth = 2} evaluates that in the environment of the
  parent of the calling function, and \code{envdepth = 1} within the
  calling function (see
  \code{\link{eval.parent}}). \code{ordiTermInfo} finds the term
  information for constrained ordination as described in
  \code{\link{cca.object}}. \code{ordiNAexclude} implements
  \code{na.action = na.exclude} for constrained ordination finding WA
  scores of CCA components and site scores of unconstrained component
  from \code{excluded} rows of observations. Function
  \code{ordiNApredict} puts pads the result object with these or with
  WA scores similarly as \code{\link{napredict}}.

  \code{ordiArgAbsorber} absorbs arguments of \code{\link{scores}}
  function of \pkg{vegan} so that these do not cause superfluous
  warnings in graphical function \code{FUN}. If you implement
  \code{scores} functions with new arguments, you should update
  \code{ordiArgAbsorber}. 

  \code{centroids.cca} finds the weighted centroids of variables.

  \code{permuted.index} creates permuted index of length \code{n}
  possibly stratified within \code{strata}. This is the basic \pkg{vegan}
  permutation function that should be replaced with more powerful
  \code{permuted.index2} in the future releases of \pkg{vegan}, and all
  new functions should use \code{\link{permuted.index2}}.

  \code{pasteCall} prints the function call so that it is nicely wrapped
  in \code{\link[utils]{Sweave}} output.

  \code{veganCovEllipse} finds the coordinates for drawing a
  covariance ellipse.
}

\keyword{internal }
