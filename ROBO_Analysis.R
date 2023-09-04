library(dplyr)
library(readr)

# Read the CSV data
robo_data <- read_csv("ROBO2.csv")
robo_data$dates <- as.Date(robo_data$dates)  # Convert to Date format

# Explore the data
cat("Exploratory Analysis:\n")
head(robo_data)  # Display the first few rows
summary(robo_data)  # Summary statistics

# Calculate monthly rolling VaR and CVaR
window_width <- 24  # 24 months
confidence_level <- 0.95

calculate_var_cvar <- function(returns) {
  var <- quantile(returns, (1 - confidence_level) * 100)
  cvar <- mean(returns[returns <= var])
  return(c(var, cvar))
}

rolling_var <- c()
rolling_cvar <- c()

for (i in (window_width + 1):nrow(robo_data)) {
  monthly_returns <- robo_data$today[(i - window_width):(i - 1)]
  var_cvar <- calculate_var_cvar(monthly_returns)
  rolling_var <- c(rolling_var, var_cvar[1])
  rolling_cvar <- c(rolling_cvar, var_cvar[2])
}

# Create NA values for the initial rows
rolling_var <- c(rep(NA, window_width - 1), rolling_var)
rolling_cvar <- c(rep(NA, window_width - 1), rolling_cvar)

# Add RollingVaR and RollingCVaR columns to the dataframe
robo_data$RollingVaR <- rolling_var
robo_data$RollingCVaR <- rolling_cvar

# Print the resulting dataframe with RollingVaR and RollingCVaR
cat("\nDataframe with RollingVaR and RollingCVaR:\n")
head(robo_data)

# Insights on variability and effectiveness of VaR
cat("\nInsights:\n")
variability <- sd(rolling_var, na.rm = TRUE)
cat("Variability of Rolling VaR Estimates:", variability, "\n")
cat("VaR appears to be effective as a measure if the variability is relatively low and consistent.\n") # nolint
