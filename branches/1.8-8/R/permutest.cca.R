"permutest.cca" <-
    function (x, permutations = 100, model = c("direct", "reduced", 
                                     "full"), first = FALSE, strata, ...) 
{
    model <- match.arg(model)
    isCCA <- !inherits(x, "rda")
    isPartial <- !is.null(x$pCCA)
    if (first) {
        Chi.z <- x$CCA$eig[1]
        q <- 1
    }
    else {
        Chi.z <- x$CCA$tot.chi
        names(Chi.z) <- "Model"
        q <- x$CCA$rank
    }
    Chi.xz <- x$CA$tot.chi
    names(Chi.xz) <- "Residual"
    r <- x$CA$rank
    if (model == "full") 
        Chi.tot <- Chi.xz
    else Chi.tot <- Chi.z + Chi.xz
    if (!isCCA) 
        Chi.tot <- Chi.tot * (nrow(x$CCA$Xbar) - 1)
    F.0 <- (Chi.z/q)/(Chi.xz/r)
    F.perm <- numeric(permutations)
    num <- numeric(permutations)
    den <- numeric(permutations)
    Q <- x$CCA$QR
    if (isCCA) {
        w <- weights(x, "sites")
        X <- qr.X(Q)
        X <- sweep(X, 1, sqrt(w), "/")
    }
    if (isPartial) {
        Y.Z <- x$pCCA$Fit
        QZ <- x$pCCA$QR
        if (isCCA) {
            Z <- qr.X(QZ)
            Z <- sweep(Z, 1, sqrt(w), "/")
        }
    }
    if (model == "reduced" || model == "direct") 
        E <- x$CCA$Xbar
    else E <- x$CA$Xbar
    if (isPartial && model == "direct") 
        E <- E + Y.Z
    N <- nrow(E)
    if (!exists(".Random.seed", envir = .GlobalEnv, inherits = FALSE)) 
        runif(1)
    seed <- get(".Random.seed", envir = .GlobalEnv, inherits = FALSE)
    for (i in 1:permutations) {
        take <- permuted.index(N, strata)
        Y <- E[take, ]
        if (isPartial) {
            if (isCCA) {
                wm <- colSums(sweep(Z, 1, w[take], "*"))
                XZ <- sweep(Z, 2, wm, "-")
                XZ <- sweep(XZ, 1, sqrt(w[take]), "*")
                QZ <- qr(XZ)
            }
            Y <- qr.resid(QZ, Y)
        }
        if (isCCA) {
            wm <- colSums(sweep(X, 1, w[take], "*"))
            XY <- sweep(X, 2, wm, "-")
            XY <- sweep(XY, 1, sqrt(w[take]), "*")
            Q <- qr(XY)
        }
        tmp <- qr.fitted(Q, Y)
        if (first) 
            cca.ev <- svd(tmp, nv = 0, nu = 0)$d[1]^2
        else cca.ev <- sum(tmp * tmp)
        if (isPartial || first) {
            tmp <- qr.resid(Q, Y)
            ca.ev <- sum(tmp * tmp)
        }
        else ca.ev <- Chi.tot - cca.ev
        num[i] <- cca.ev
        den[i] <- ca.ev
        F.perm[i] <- (cca.ev/q)/(ca.ev/r)
    }
    sol <- list(call = x$call, model = model, F.0 = F.0, F.perm = F.perm, 
                chi = c(Chi.z, Chi.xz), num = num, den = den, df = c(q, 
                                                              r), nperm = permutations, method = x$method, Random.seed = seed)
    if (!missing(strata)) {
        sol$strata <- deparse(substitute(strata))
        sol$stratum.values <- strata
    }
    class(sol) <- "permutest.cca"
    sol
}
