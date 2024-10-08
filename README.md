# sex_estimation
An R function for estimating sex of unknown individuals utilizing cross-sectional geometric properties of 3D ulna bone models.

The present function allows the user to utilize a set of diaphysea cross-sectional geometric measurements of ulna bones, which have been previously extracted from 3D bone models using the [*csg-toolkit* GNU Octave package](https://github.com/pr0m1th3as/long-bone-diaphyseal-CSG-Toolkit/tree/v1.0.1). The only requirement for the `sex_estimation` function is the CSV file that's computed from the *csg-toolkit* containing all the measurements for every individual of the desired sample. In order to use the function, the user must first download this repository from GitHub. Then, the downloaded folder must be unzipped and the CSV data file must be copied inside the sex_estimation folder. All necessary libraries are installed and loaded directly by the function.

After having all the necessary files inside the same directory, and setting it as the working directory in the R environment, the user must open the `sex_estimation.R` file in an R environment (such as R Studio, which is suggested). Instructions as to the use of the function are as follows:

First, the user needs to load the function in the R workspace. This is achieved with the command:
```
source("sex_estimation.R")
```

A message showing the successful installation of the necessary packages will show on the R console upon loading the function. Additionally, once the function is properly loaded, it can be called from the R console as:
```
sex_estimation(side)
```
The `side` argument corresponds to either "pooled", "right", or "left", depending on which model the user wants to load. The "pooled" argument will load the model trained in a sample with both left and right bones, while the "right" and "left" models were trained on the two anatomical sides separately.

This will open a window of the working directory, where the user can choose the CSV file containing the measurements. After selecting **Open**, the names of the individuals from the sample will be displayed in the console, while the output will be printed in a CSV file titled `Sex Estimation Results.csv`. The output file will be a Nx5 matrix - the first column is the index of the ulna bone model, the second column is the file name of the model as saved in the `CSG data.csv` input file, and the third volume is the estimated sex of that individual. The probability of belonging to a female or a male individual for each ulna model is displayed in the fourth and fifth columns.

A testing dataset named `CSGtestdata.csv` is provided as a use case.
