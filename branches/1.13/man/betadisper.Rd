\name{betadisper}
\alias{betadisper}
\alias{scores.betadisper}
\alias{anova.betadisper}
\alias{plot.betadisper}
\alias{boxplot.betadisper}
\alias{print.betadisper}
\alias{TukeyHSD.betadisper}

\title{Multivariate homogeneity of groups dispersions (variances)}
\description{
  Implements Marti Anderson's PERMDISP2 procedure for the analysis of
  multivariate homogeneity of group dispersions (variances).
  \code{betadisper} is a multivariate analogue of Levene's test for
  homogeneity of variances. Non-euclidean distances between objects and
  group centroids are handled by reducing the original distances to
  principal coordinates. This procedure has latterly been used as a
  means of assessing beta diversity. There are \code{anova},
  \code{scores}, \code{plot} and \code{boxplot} methods.

  \code{TukeyHSD.betadisper} creates a set of confidence intervals on
  the differences between the mean distance-to-centroid of the levels of
  the grouping factor with the specified family-wise probability of
  coverage.  The intervals are based on the Studentized range statistic,
  Tukey's 'Honest Significant Difference' method.
}
\usage{
betadisper(d, group, type = c("centroid", "median"))

\method{anova}{betadisper}(object, \dots)

\method{scores}{betadisper}(x, display = c("sites", "centroids"),
       choices = c(1,2), \dots)

\method{plot}{betadisper}(x, axes = c(1,2), cex = 0.7, hull = TRUE,
     ylab, xlab, main, sub, \dots)

\method{boxplot}{betadisper}(x, ylab = "Distance to centroid", ...)

\method{TukeyHSD}{betadisper}(x, which = "group", ordered = FALSE,
         conf.level = 0.95, \ldots)
}

\arguments{
  \item{d}{a distance structure such as that returned by 
    \code{\link[stats]{dist}}, \code{\link{betadiver}} or 
    \code{\link{vegdist}}.}
  \item{group}{vector describing the group structure, usually a factor
    or an object that can be coerced to a factor using
    \code{\link[base]{as.factor}}.}
  \item{type}{the type of analysis to perform. Only \code{type =
      "centroid"} is currently supported.}
  \item{display}{character; partial match to access scores for
    \code{"sites"} or \code{"species"}.}
  \item{object, x}{an object of class \code{"betadisper"}, the result of a
    call to \code{betadisper}.}
  \item{choices, axes}{the principal coordinate axes wanted.}
  \item{hull}{logical; should the convex hull for each group be plotted?}
  \item{cex, ylab, xlab, main, sub}{graphical parameters. For details,
    see \code{\link{plot.default}}.}
  \item{which}{A character vector listing terms in the fitted model for
    which the intervals should be calculated. Defaults to the grouping
    factor.}
  \item{ordered}{Logical; see \code{\link{TukeyHSD}}.}
  \item{conf.level}{A numeric value between zero and one giving the
    family-wise confidence level to use.}
  \item{\dots}{arguments, including graphical parameters (for
    \code{plot.betadisper} and \code{boxplot.betadisper}), passed to
    other methods.}
}
\details{
  One measure of multivariate dispersion (variance) for a group of
  samples is to calculate the average distance of group members to the
  group centroid or spatial median in multivariate space. To test if the
  dispersions (variances) of one or more groups are different, the
  distances of group members to the group centroid are subject to
  ANOVA. This is a multivariate analogue of Levene's test for
  homogeneity of variances if the distances between group members and
  group centroids is the Euclidean distance.

  However, better measures of distance than the Euclidean distance are
  available for ecological data. These can be accommodated by reducing
  the distances produced using any dissimilarity coefficient to
  principal coordinates, which embeds them within a Euclidean space. The
  analysis then proceeds by calculating the Euclidean distances between
  group members and the group centroid on the basis of the principal
  coordinate axes rather than the original distances.
  
  Non-metric dissimilarity coefficients can produce principal coordinate
  axes that have negative Eigenvalues. These correspond to the
  imaginary, non-metric part of the distance between objects. If
  negative Eigenvalues are produced, we must correct for these imaginary
  distances.

  The distance to its centroid of a point is \deqn{z_{ij}^c =
  \sqrt{\Delta^2(u_{ij}^+, c_i^+) - \Delta^2(u_{ij}^-, c_i^-)},}{z[ij]^c
  = sqrt(Delta^2(u[ij]^+, c[i]^+) - Delta^2(u[ij]^-, c[i]^-)),} where
  \eqn{\Delta^2}{Delta^2} is the squared Euclidean distance between
  \eqn{u_{ij}}{u[ij]}, the principal coordinate for the \eqn{j^{th}}{jth}
  point in the \eqn{i^{th}}{ith} group, and \eqn{c_i}{c[i]}, the
  coordinate of the centroid for the \eqn{i^{th}}{ith} group. The
  super-scripted \eqn{+} and \eqn{-} indicate the real and imaginary
  parts respectively. This is equation (3) in Anderson (2006). If the
  imaginary part is greater in magnitude than the real part, then we
  would be taking the square root of a negative value, resulting in
  NaN. From \pkg{vegan} 1.12-12 \code{betadisper} takes the absolute
  value of the real distance minus the imaginary distance, before
  computing the square root. This is in line with the behaviour of Marti
  Anderson's PERMDISP2 programme. 
  
  To test if one or more groups is more variable than the others, ANOVA
  of the distances to group centroids can be performed and parametric
  theory used to interpret the significance of F. An alternative is to
  use a permutation test. \code{\link{permutest.betadisper}} permutes model
  residuals to generate a permutation distribution of F under the Null
  hypothesis of no difference in dispersion between groups.

  Pairwise comprisons of group mean dispersions can also be performed
  using \code{\link{permutest.betadisper}}. An alternative to the classical
  comparison of group dispersions, is to calculate Tukey's Honest
  Significant Differences between groups, via
  \code{TukeyHSD.betadisper}. This is a simple wrapper to
  \code{\link{TukeyHSD.aov}}. The user is directed to read the help file
  for \code{\link{TukeyHSD}} before using this function. In particular,
  note the statement about using the function with 
  unbalanced designs.

  The results of the analysis can be visualised using the \code{plot}
  and \code{boxplot} methods.

  One additional use of these functions is in assessing beta diversity
  (Anderson \emph{et al} 2006). Function \code{\link{betadiver}}
  provides some popular dissimilarity measures for this purpose.
}
\value{
  The \code{anova} method returns an object of class \code{"anova"}
  inheriting from class \code{"data.frame"}.

  The \code{scores} method returns a list with one or both of the
  components \code{"sites"} and \code{"centroids"}.
  
  The \code{plot} function invisibly returns an object of class
  \code{"ordiplot"}, a plotting structure which can be used by
  \code{\link{identify.ordiplot}} (to identify the points) or other
  functions in the \code{\link{ordiplot}} family. 

  The \code{boxplot} function invisibly returns a list whose components
  are documented in \code{\link[graphics]{boxplot}}.

  \code{TukeyHSD.betadisper} returns a list. See \code{\link{TukeyHSD}}
  for further details.

  \code{betadisper} returns a list of class \code{"betadisper"} with the
  following components:

  \item{eig}{numeric; the eigenvalues of the principal coordinates
    analysis.}
  \item{vectors}{matrix; the eigenvectors of the principal coordinates
    analysis.}
  \item{distances}{numeric; the Euclidean distances in principal
    coordinate space between the samples and their respective group
    centroid.}
  \item{group}{factor; vector describing the group structure}
  \item{centroids}{matrix; the locations of the group centroids on the
    principal coordinates.}
  \item{call}{the matched function call.}
}
\references{
  Anderson, M.J. (2006) Distance-based tests for homogeneity of
  multivariate dispersions. \emph{Biometrics} \strong{62(1)}, 245--253.

  Anderson, M.J., Ellingsen, K.E. & McArdle, B.H. (2006) Multivariate
  dispersion as a measure of beta diversity. \emph{Ecology Letters}
  \strong{9(6)}, 683--693.
}
\author{Gavin L. Simpson}
\seealso{\code{\link{permutest.betadisper}}, \code{\link[stats]{anova.lm}},
  \code{\link{scores}}, \code{\link[graphics]{boxplot}},
  \code{\link{TukeyHSD}}. Further measure of beta diversity
  can be found in \code{\link{betadiver}}.}
\examples{
data(varespec)

## Bray-Curtis distances between samples
dis <- vegdist(varespec)

## First 16 sites grazed, remaining 8 sites ungrazed
groups <- factor(c(rep(1,16), rep(2,8)), labels = c("grazed","ungrazed"))

## Calculate multivariate dispersions
mod <- betadisper(dis, groups)
mod

## Perform test
anova(mod)

## Permutation test for F
permutest(mod, pairwise = TRUE)

## Tukey's Honest Significant Differences
(mod.HSD <- TukeyHSD(mod))
plot(mod.HSD)

## Plot the groups and distances to centroids on the
## first two PCoA axes
plot(mod)

## Draw a boxplot of the distances to centroid for each group
boxplot(mod)
}
\keyword{methods}
\keyword{multivariate}
\keyword{hplot}
