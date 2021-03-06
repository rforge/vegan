`adonis` <-
    function(formula, data, permutations=5, method="bray", strata=NULL,
             contr.unordered="contr.sum", contr.ordered="contr.poly",
             ...)
{
    ## formula is model formula such as Y ~ A + B*C where Y is a data
    ## frame or a matrix, and A, B, and C may be factors or continuous
    ## variables.  data is the data frame from which A, B, and C would
    ## be drawn.
    lhs <- formula[[2]]
    lhs <- eval(lhs, data, parent.frame()) # to force evaluation 
    formula[[2]] <- NULL                # to remove the lhs
    rhs.frame <- model.frame(formula, data, drop.unused.levels = TRUE) # to get the data frame of rhs
    op.c <- options()$contrasts
    options( contrasts=c(contr.unordered, contr.ordered) )
    rhs <- model.matrix(formula, rhs.frame) # and finally the model.matrix
    options(contrasts=op.c)
    grps <- attr(rhs, "assign")
    qrhs <- qr(rhs)
    ## Take care of aliased variables and pivoting in rhs
    rhs <- rhs[, qrhs$pivot, drop=FALSE]
    rhs <- rhs[, 1:qrhs$rank, drop=FALSE]
    grps <- grps[qrhs$pivot][1:qrhs$rank]
    u.grps <- unique(grps)
    nterms <- length(u.grps) - 1
    H.s <- lapply(2:length(u.grps),
                  function(j) {Xj <- rhs[, grps %in% u.grps[1:j] ]
                               qrX <- qr(Xj, tol=1e-7)
                               Q <- qr.Q(qrX)
                               tcrossprod(Q[,1:qrX$rank])
                           })
    if (inherits(lhs, "dist"))
        dmat <- as.matrix(lhs^2)
    else
        dmat <- as.matrix(vegdist(lhs, method=method, ...))^2
    n <- nrow(dmat)
    I <- diag(n)
    ones <- matrix(1,nrow=n)
    A <- -(dmat)/2
    G <- -.5 * dmat %*% (I - ones%*%t(ones)/n)
    SS.Exp.comb <- sapply(H.s, function(hat) sum( diag(G %*% hat) ) )
    SS.Exp.each <- c(SS.Exp.comb - c(0,SS.Exp.comb[-nterms]) )
    H.snterm <- H.s[[nterms]]
    if (length(H.s) > 1)
        for (i in length(H.s):2)
            H.s[[i]] <- H.s[[i]] - H.s[[i-1]]
    SS.Res <- sum(diag( ( G %*% (I-H.snterm))))
    df.Exp <- sapply(u.grps[-1], function(i) sum(grps==i) )
    df.Res <- n - qrhs$rank
    beta <-  qr.coef(qrhs, as.matrix(lhs) )
    colnames(beta) <- colnames(lhs)
    F.Mod <- (SS.Exp.each/df.Exp) / (SS.Res/df.Res)

    f.test <- function(H, G, I, df.Exp, df.Res, H.snterm){
        (sum( diag(G %*% H) )/df.Exp) /
            ( sum(diag( G %*% (I-H.snterm) ))/df.Res) }
    
    SS.perms <- function(H, G, I){
        c(SS.Exp.p = sum( diag(G%*%H) ),
          S.Res.p=sum(diag( G %*% (I-H) )) ) }
    
    ## Permutations
    if (missing(strata)) 
        strata <- NULL
    G.p <- lapply(1:permutations, function(x) {
        permutes <- permuted.index(n, strata = strata)
        G[permutes, permutes]
    } )
    
    ## SS.s <- sapply(G.p, function(Gs) { SS.perms(H, Gs, I) } )
    f.perms <- sapply(1:nterms, function(i) {
        sapply(1:permutations, function(j) {
            f.test(H.s[[i]], G.p[[j]], I, df.Exp[i], df.Res, H.snterm)
        } )
    })
    SumsOfSqs = c(SS.Exp.each, SS.Res, sum(SS.Exp.each) + SS.Res)
    tab <- data.frame(Df = c(df.Exp, df.Res, n-1),
                      SumsOfSqs = SumsOfSqs,
                      MeanSqs = c(SS.Exp.each/df.Exp, SS.Res/df.Res, NA),
                      F.Model = c(F.Mod, NA,NA),
                      R2 = SumsOfSqs/SumsOfSqs[length(SumsOfSqs)],
                      P = c(rowSums(t(f.perms) > F.Mod)/permutations, NA, NA))
    rownames(tab) <- c(attr(attr(rhs.frame, "terms"), "term.labels")[u.grps],
                       "Residuals", "Total")
    colnames(tab)[ncol(tab)] <- "Pr(>F)"
    out <- list(aov.tab = tab, call = match.call(), 
                coefficients = beta,  f.perms = f.perms, design.matrix = rhs)
    class(out) <- "adonis"
    out
}
