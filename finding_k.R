cluster.k <- function(data, k.min, k.max){
  
  ## Checks ###################################################
  
  if (k.min > k.max){
    stop("Range for \"K\" is decresing. It should be increasing")
  }
  
  if (k.min == 1) {
    warning ("k.min = 1 means there is no clustering.")
  }
  
  if (missing(k.min)) {
    k.min <- 2
  }
  
  if (k.max == nrow(data)){
    warning ("k.max equals the number of data points, which means each data point is a cluster")
  }
  
  if (missing(k.max)) {
    k.max <- ceiling(sqrt(nrow(data)/2))
  }
  
  ## Set up the data ##########################################
  
  d.matrix <- data.matrix(data, rownames.force  <-  NA)
  variance.explained <- data.frame(matrix(NA, nrow = k.max - k.min + 1, ncol = 2))
  colnames(variance.explained) <- c("k", "Variance Explained(%)")
  
  ## Run kmeans for a series of k
  
  for(i in k.min: k.max){
    variance.explained[i - k.min + 1, 1] = i
    q <- try(kmeans(d.matrix, i),TRUE)
    
    if (class(q) != "try-error"){
      variance.explained[i - k.min + 1, 2] <- round(q$betweenss/q$totss, 4)*100
    } else{
      variance.explained[i - k.min + 1, 2] <- NA
    }
  }
  
  ## Plot the variance explained #############################
  plot(x = variance.explained[, 1], 
       y = variance.explained[, 2],
       type = "b", 
       ylab = "", 
       xlab = "Number  of  Clusters (k)",
       main = "Variance Explained",
       yaxt = "n")
  axis(2, at=pretty(variance.explained[, 2]), 
       lab=paste0(pretty(variance.explained[, 2]), "%"), las=TRUE)
  
  
  ## Find the best k #########################################
  k <- which.max(variance.explained[, 2]) + (k.min - 1)
  
  ## Output ##################################################
  cat("The value of k that maximizes the variance explained by clustering is", k, "\n")
  result <- list("variance.explained" = variance.explained, "k" = k)
  return(result)
}




