# IJC437 – Introduction to Data Science  
## Analysis of UK Rail Delay Compensation Claims

## Introduction
This project analyses delay compensation data from the UK rail network to explore patterns of service disruption and assess whether the volume of claims is associated with the efficiency of claim processing by train operating companies.

## Research Questions
- **RQ1:** What patterns and variability exist in delay compensation claims across train operating companies and reporting periods?
- **RQ2:** Is there a statistically significant relationship between claim volume and claim processing efficiency?
- **RQ3:** To what extent can claim volume be used to predict claim processing efficiency?

## Key Findings
- Delay compensation claim volumes vary widely across operators and time periods.
- There is no statistically significant relationship between claim volume and processing efficiency.
- Linear regression shows that claim volume has very limited predictive power for processing efficiency.

## R Code
The full R script used for data preprocessing, exploratory analysis, statistical testing, and modelling is available here:

- Code/Analysis.R

## Dataset
The dataset used in this analysis is publicly available from the UK Office of Rail and Road and has been preprocessed for analysis:

- Data/4410-delay-compensation-claims

## How to Run the Code
1. Download `analysis.R` and `Delay_TrainClaim.xlsx`.
2. Open RStudio.
3. Set the working directory to the folder containing the files.
4. Install required packages (if not already installed):
   ```r
   install.packages(c("tidyverse", "readxl", "ggplot2"))
