\name{eigenvals}
\Rdversion{1.1}
\alias{eigenvals}
\alias{eigenvals.default}
\alias{eigenvals.prcomp}
\alias{eigenvals.princomp}
\alias{eigenvals.cca}
\alias{eigenvals.wcmdscale}
\alias{print.eigenvals}
\alias{summary.eigenvals}

\title{
  Extract Eigenvalues from an Ordination Object
}
\description{
  Function extracts eigenvalues from an object that has them. Many
  multivariate methods return such objects. 
}
\usage{
eigenvals(x, ...)
\method{eigenvals}{cca}(x, constrained = FALSE, ...)
\method{summary}{eigenvals}(object, ...)
}

\arguments{
  \item{x}{
    An object from which to extract eigenvalues.
}
  \item{object}{
    An \code{eigenvals} result object.
}
   \item{constrained}{
    Return only constrained eigenvalues.
}
   \item{\dots}{
    Other arguments to the functions (usually ignored)
}
}

\details{
  This is a generic function that has methods for \code{\link{cca}},
  \code{\link{wcmdscale}}, \code{\link{prcomp}} and
  \code{\link{princomp}} result objects. The default method also
  extracts eigenvalues if the result looks like being from
  \code{\link{eigen}} or \code{\link{svd}}.  Functions
  \code{\link{prcomp}} and \code{\link{princomp}} contain square roots
  of eigenvalues that all called standard deviations, but
  \code{eigenvals} function returns their squares.  Function
  \code{\link{svd}} contains singular values, but function
  \code{eigenvals} returns their squares. For constrained ordination
  methods \code{\link{cca}}, \code{\link{rda}} and
  \code{\link{capscale}} the function returns the both constrained and
  unconstrained eigenvalues concatenated in one vector, but the partial
  component will be ignored. However, with argument 
  \code{constrained = TRUE} only constrained eigenvalues are returned. 

  The \code{summary} of \code{eigenvals} result returns eigenvalues,
  proportion explained and cumulative proportion explained.
}

\value{
  An object of class \code{"eigenvals"} which is a vector of eigenvalues.
}

\author{
 Jari Oksanen.
}

\seealso{
 \code{\link{eigen}}, \code{\link{svd}}, \code{\link{prcomp}},
 \code{\link{princomp}}, \code{\link{cca}}, \code{\link{rda}},
 \code{\link{capscale}}, \code{\link{wcmdscale}},
 \code{\link{cca.object}}. 
}
\examples{
data(varespec)
data(varechem)
mod <- cca(varespec ~ Al + P + K, varechem)
ev <- eigenvals(mod)
ev
summary(ev)
}
\keyword{ multivariate }

