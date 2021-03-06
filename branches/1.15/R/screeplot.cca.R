`screeplot.cca` <-
    function(x, bstick = FALSE, type = c("barplot", "lines"),
             npcs = min(10, if(is.null(x$CCA)) x$CA$rank else x$CCA$rank),
             ptype = "o", bst.col = "red", bst.lty = "solid",
             xlab = "Component", ylab = "Inertia",
             main = deparse(substitute(x)), ...)
{
    if(is.null(x$CCA))
        eig.vals <- x$CA$eig
    else
        eig.vals <- x$CCA$eig
    ncomps <- length(eig.vals)
    if(npcs > ncomps)
        npcs <- ncomps
    comps <- seq(len=npcs)
    type <- match.arg(type)
    if (bstick && !is.null(x$CCA)) {
        warning("'bstick' unavailable for constrained ordination")
        bstick <- FALSE
    }
    if(bstick) {
        ord.bstick <- bstick(x)
        ylims <- range(eig.vals[comps], ord.bstick[comps])
    } else {
        ylims <- range(eig.vals)
    }
    if(type=="barplot") {
        ## barplot looks weird if 0 not included
        ylims <- range(0, ylims)
        mids <- barplot(eig.vals[comps], names = names(eig.vals[comps]),
                        main = main, ylab = ylab, ylim = ylims, ...)
    } else {
        plot(eig.vals[comps], type = ptype, axes = FALSE, ylim = ylims,
             xlab = xlab, ylab = ylab, main = main, ...)
        axis(2)
        axis(1, at = comps, labels = names(eig.vals[comps]))
        box()
        mids <- comps
    }
    if(bstick) {
        lines(mids, ord.bstick[comps], type = ptype, col = bst.col,
              lty = bst.lty)
    }
    invisible(xy.coords(x = mids, y = eig.vals[comps]))
}
