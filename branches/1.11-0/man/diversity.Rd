\encoding{UTF-8}
\name{diversity}
\alias{diversity}
\alias{rarefy}
\alias{fisher.alpha}
\alias{specnumber}

\title{ Ecological Diversity Indices and Rarefaction Species Richness }

\description{ Shannon, Simpson, and Fisher diversity indices
and rarefied species richness for community ecologists.  }

\usage{
diversity(x, index = "shannon", MARGIN = 1, base = exp(1))

rarefy(x, sample, se = FALSE, MARGIN = 1)

fisher.alpha(x, MARGIN = 1, se = FALSE, ...)

specnumber(x, MARGIN = 1)
}

\arguments{
  \item{x}{Community data, a matrix-like object.}
  \item{index}{Diversity index, one of \code{"shannon"},
    \code{"simpson"} or \code{"invsimpson"}.}
  \item{MARGIN}{Margin for which the index is computed. }
  \item{base}{ The logarithm \code{base} used in \code{shannon}.}
  \item{sample}{Subsample size for rarefying community.}
  \item{se}{Estimate standard errors.}
  \item{...}{Parameters passed to \code{\link{nlm}}}
}
\details{
  Shannon or Shannon--Weaver (or Shannon--Wiener) index is defined as
  \eqn{H' = -\sum_i p_i \log_{b} p_i}{H = -sum p_i log(b) p_i}, where
  \eqn{p_i} is the proportional abundance of species \eqn{i} and \eqn{b}
  is the base of the logarithm.  It is most popular to use natural
  logarithms, but some argue for base \eqn{b = 2} (which makes sense,
  but no real difference).

  Both variants of Simpson's index are based on \eqn{D = \sum p_i^2}{D =
    sum p_i^2}. Choice \code{simpson} returns \eqn{1-D} and
  \code{invsimpson} returns \eqn{1/D}.
 
  Function \code{rarefy} gives the expected species richness in random
  subsamples of size \code{sample} from the community. The size of
  \code{sample} should be smaller than total community size, but the
  function will  silently work for larger \code{sample} as well and
  return non-rarefied species richness (and standard error = 0).
  Rarefaction can be performed only with genuine counts of individuals.
  The function \code{rarefy} is based on Hurlbert's (1971) formulation,
  and the standard errors on Heck et al. (1975).  

  \code{fisher.alpha} estimates the \eqn{\alpha} parameter of
  Fisher's logarithmic series (see \code{\link{fisherfit}}). 
  The estimation is possible only for genuine
  counts of individuals. The function can optionally return standard
  errors of \eqn{\alpha}.  These should be regarded only as rough
  indicators of the accuracy: the confidence limits of \eqn{\alpha} are
  strongly non-symmetric and the standard errors cannot be used in
  Normal inference.
  
  Function \code{specnumber} finds the number of species. With
  \code{MARGIN = 2}, it finds frequencies of species. The function is
  extremely simple, and shortcuts are easy in plain \R.
  
  Better stories can be told about Simpson's index than about
  Shannon's index, and still grander narratives about
  rarefaction (Hurlbert 1971).  However, these indices are all very
  closely related (Hill 1973), and there is no reason to despise one
  more than others (but if you are a graduate student, don't drag me in,
  but obey your Professor's orders). In particular, the exponent of the
  Shannon index is linearly related to inverse Simpson (Hill 1973)
  although the former may be more sensitive to rare species. Moreover,
  inverse Simpson is asymptotically equal to rarefied species richness
  in sample of two individuals, and Fisher's \eqn{\alpha} is very
  similar to inverse Simpson.
}

\value{
  A vector of diversity indices or rarefied species richness values. With
  option \code{se = TRUE}, function \code{rarefy} returns a 2-row matrix
  with rarefied richness (\code{S}) and its standard error
  (\code{se}).
  With option \code{se = TRUE}, function \code{fisher.alpha} returns a
  data frame with items for \eqn{\alpha} (\code{alpha}), its approximate
  standard errors (\code{se}), residual degrees of freedom
  (\code{df.residual}), and the \code{code} returned by
  \code{\link{nlm}} on the success of estimation. 
}

\references{
  Fisher, R.A., Corbet, A.S. & Williams, C.B. (1943). The relation
  between the number of species and the number of individuals in a
  random sample of animal population. \emph{Journal of Animal Ecology}
  \strong{12}, 42--58.

  Heck, K.L., van Belle, G. & Simberloff, D. (1975). Explicit
  calculation of the rarefaction diversity measurement and the
  determination of sufficient sample size. \emph{Ecology} \strong{56},
  1459--1461.  
  
  Hurlbert, S.H. (1971). The nonconcept of species diversity: a critique
  and alternative parameters. \emph{Ecology} \strong{52}, 577--586.
 
}

\seealso{Function \code{renyi} for generalized \enc{Rényi}{Renyi}
  diversity and Hill numbers.}

\author{ Jari Oksanen  and  Bob O'Hara \email{bob.ohara@helsinki.fi}
    (\code{fisher.alpha}).}

\examples{
data(BCI)
H <- diversity(BCI)
simp <- diversity(BCI, "simpson")
invsimp <- diversity(BCI, "inv")
r.2 <- rarefy(BCI, 2)
alpha <- fisher.alpha(BCI)
pairs(cbind(H, simp, invsimp, r.2, alpha), pch="+", col="blue")
## Species richness (S) and Pielou's evenness (J):
S <- specnumber(BCI) ## rowSums(BCI > 0) does the same...
J <- H/log(S)

}
\keyword{ univar }


