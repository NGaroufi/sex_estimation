#### LIBRARIES ####
library(readr, quietly = T)
library(e1071, quietly = T)

#### SEX ESTIMATION FUNCTION ####
sex_estimation <- function()
                    { data <- read.csv(file.choose(new=FALSE))
                      data <- data[,-c(4:5, 7, 12, 15, 20, 23, 28, 31,
                                       36, 39, 44, 47)]
                      data <- cbind(data[, 1:12], data[,11]*4*pi/data[,12]^2, 
                                    data[,13:24],
                                    data[,23]*4*pi/data[,24]^2, data[,26:28],
                                    data[,28]/data[,27],
                                    data[,29:34])
                      colnames(data) <- c(names(data[1:12]), "ArPerIndex.35.", 
                                          names(data[14:25]), "ArPerIndex.65.",
                                          names(data[27:29]), "Imax.Imin.65.", 
                                          names(data[31:36]))
                      print(data$sample)
                      classifier <- readRDS("SVM_model.rds")
                      y_pred = predict(classifier, newdata = data[-1],
                                       probability = TRUE)
                      res <- as.data.frame(cbind(data$sample, y_pred, 
                                                 attr(y_pred, "probabilities")))
                      res$y_pred <- factor(res$y_pred, levels = c(1,2), 
                                        labels = c("Male", "Female"))
                      colnames(res) <- c("Sample ID", "Sex Prediction", 
                                        "Prob. for Female",
                                        "Prob. for Male")
                      res$`Prob. for Female`<-round(as.numeric(res$`Prob. for Female`),3)
                      res$`Prob. for Male` <- round(as.numeric(res$`Prob. for Male`),3)
                      write.csv(res, "Sex Estimation Results.csv")
                      }


### To load the function in your R environment, run (on your console or 
### by uncommenting the line below - delete the # symbol - )

#source("sex_estimation.R")

### To use the function, run (on your console or 
### by uncommenting the line below - delete the # symbol - )

#sex_estimation()