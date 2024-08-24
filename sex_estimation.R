## Copyright (C) 2023 Nefeli Garoufi <nefeligar@biol.uoa.gr>
##
## This program is free software; you can redistribute it and/or modify it under
## the terms of the GNU General Public License as published by the Free Software
## Foundation; either version 3 of the License, or (at your option) any later
## version.
##
## This program is distributed in the hope that it will be useful, but WITHOUT
## ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
## FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
## details.
##
## You should have received a copy of the GNU General Public License along with
## this program; if not, see <http://www.gnu.org/licenses/>.

#### Installing the necessary packages and loading the respective libraries ####
install.packages("readr", quiet = TRUE)
install.packages("e1071", quiet = TRUE)
suppressMessages(suppressWarnings(library(readr)))
suppressMessages(suppressWarnings(library(e1071)))

#### SEX ESTIMATION FUNCTION ####
sex_estimation <- function(side)
                    { data <- read.csv(file.choose(new=FALSE)) #choose the proper csv file
                      data <- data[,-c(4:5, 7, 12, 15, 20, 23, 28, 31,
                                       36, 39, 44, 47)] #keep only the used variables
                      data <- cbind(data[, 1:12], data[,11]*4*pi/data[,12]^2, 
                                    data[,13:24],
                                    data[,23]*4*pi/data[,24]^2, data[,25:28],
                                    data[,28]/data[,27],
                                    data[,29:34]) #calculate the new necessary ones
                      colnames(data) <- c(names(data[1:12]), "ArPerIndex.35.", 
                                          names(data[14:25]), "ArPerIndex.65.",
                                          names(data[27:30]), "Imax.Imin.65.", 
                                          names(data[32:37]))
                      print(data$sample) #prints the names of the IDs of the sample
                      if (side == "pooled") #load the pooled model
                        {
                        data <- data[,-27]
                        classifier <- readRDS("SVM_pooled_model.rds")
                        print("You are working with the pooled sample model.")
                        } else if (side == "left") #load the left side model
                        {classifier <- readRDS("SVM_left_model.rds")
                        print("You are working with the left sample model.")
                        } else if (side == "right") #load the right side model
                        {classifier <- readRDS("SVM_right_model.rds")
                        print("You are working with the right sample model.")}
                      y_pred = predict(classifier, newdata = data[-1],
                                            probability = TRUE) #store the predicted values
                      res <- as.data.frame(cbind(data$sample, y_pred, 
                                                 attr(y_pred, "probabilities"))) #save the sample IDs, the predictions, 
                                                                                 #and probabilities in a dataframe
                      res$y_pred <- factor(res$y_pred, levels = c(1,2), 
                                        labels = c("Male", "Female")) #label the predicted values
                      colnames(res) <- c("Sample ID", "Sex Prediction", 
                                        "Prob. for Female",
                                        "Prob. for Male")
                      res$`Prob. for Female`<-round(as.numeric(res$`Prob. for Female`),3)
                      res$`Prob. for Male` <- round(as.numeric(res$`Prob. for Male`),3)
                      write.csv(res, "Sex Estimation Results.csv") #save the results as a csv file
}
