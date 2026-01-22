# ===============================
# IJC437 – Introduction to Data Science
# UK Rail Delay Compensation Analysis
# ===============================


# -------------------------------
# 1. Load libraries
# -------------------------------
library(readxl)
library(dplyr)
library(tidyr)
library(janitor)
library(ggplot2)
library(caret)
library(broom)
library(scales)


# -------------------------------
# 2. Load Excel data
# (Skip title row)
# -------------------------------
annual <- read_excel(
  "Delay_TrainClaim.xlsx",
  sheet = "Annual_Data",
  skip = 1
)

periodic <- read_excel(
  "Delay_TrainClaim.xlsx",
  sheet = "Periodic_Data",
  skip = 1
)


# -------------------------------
# 3. Clean column names 
# Rows with not imortant values like [z]:Are converted to NA
# -------------------------------
annual   <- clean_names(annual)
periodic <- clean_names(periodic)

annual <- annual %>%
  mutate(across(
    -c(time_period, delay_compensation),
    ~ suppressWarnings(as.numeric(.x))
  ))

periodic <- periodic %>%
  mutate(across(
    -c(time_period, delay_compensation),
    ~ suppressWarnings(as.numeric(.x))
  ))




# -------------------------------
# 4. Prepare ANNUAL claims data
# -------------------------------
claims_annual <- annual %>%
  filter(delay_compensation == "Volume of claims received within period") %>%
  pivot_longer(
    cols = where(is.numeric),
    names_to = "operator",
    values_to = "claims"
  ) %>%
  drop_na()


# -------------------------------
# 5. Prepare ANNUAL efficiency data
# -------------------------------
efficiency_annual <- annual %>%
  filter(delay_compensation == "Percentage closed within 20 working days") %>%
  pivot_longer(
    cols = where(is.numeric),
    names_to = "operator",
    values_to = "efficiency"
  ) %>%
  drop_na()


# -------------------------------
# 6. Merge datasets
# -------------------------------
analysis_data <- left_join(
  claims_annual,
  efficiency_annual,
  by = c("time_period", "operator")
) %>%
  filter(operator != "great_britain")


# -------------------------------
# 7. Exploratory Data Analysis
# -------------------------------
summary(analysis_data)

ggplot(analysis_data, aes(x = claims)) +
  geom_histogram(bins = 30, fill = "#56B4E9") +
  scale_x_continuous(labels = comma) +
  labs(
    title = "Distribution of Delay Compensation Claims",
    x = "Number of Claims",
    y = "Frequency"
  )


# -------------------------------
# 8. Correlation analysis
# -------------------------------
cor_test <- cor.test(
  analysis_data$claims,
  analysis_data$efficiency,
  method = "pearson"
)

print(cor_test)


# -------------------------------
# 9. Train–test split
# -------------------------------
set.seed(123)

index <- createDataPartition(
  analysis_data$efficiency,
  p = 0.7,
  list = FALSE
)

train_data <- analysis_data[index, ]
test_data  <- analysis_data[-index, ]


# -------------------------------
# 10. Regression model
# -------------------------------
model <- lm(efficiency ~ claims, data = train_data)

summary(model)


# -------------------------------
# 11. Predictions
# -------------------------------
predictions <- predict(model, newdata = test_data)


# -------------------------------
# 12. Model evaluation
# -------------------------------
rmse_value <- RMSE(predictions, test_data$efficiency)

print(rmse_value)


# -------------------------------
# 13. Periodic data analysis
# -------------------------------
claims_periodic <- periodic %>%
  filter(delay_compensation == "Volume of claims received within period") %>%
  pivot_longer(
    cols = where(is.numeric),
    names_to = "operator",
    values_to = "claims"
  ) %>%
  drop_na()

ggplot(claims_periodic, aes(x = operator, y = claims)) +
  geom_boxplot(fill = "#E69F00", alpha = 0.7) +
  coord_flip() +
  scale_y_continuous(labels = comma) +
  labs(
    title = "Variability of Periodic Delay Compensation Claims",
    x = "Train Operator",
    y = "Claims per Reporting Period"
  )
