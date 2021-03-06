`as.mlm.cca` <-
    function (x) 
{
    w <- weights(x)
    wa <- x$CCA$wa
    wa <- sweep(wa, 1, sqrt(w), "*")
    X <- qr.X(x$CCA$QR)
    colnames(X) <- colnames(X)[x$CCA$QR$pivot]
    lm(wa ~ . - 1, data = as.data.frame(X))
}

