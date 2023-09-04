# Load necessary libraries
library(quantmod)

# Read the ROBO2 data from CSV
robo_data <- read.csv("ROBO2.csv")
# Convert the date column to a proper date format
robo_data$Date <- as.Date(robo_data$Date)

# Explore the data
summary(robo_data)
head(robo_data)

# Define the rolling window width
window_width <- 24  # 24 months

# Function to calculate VaR and CVaR
calculate_var <- function(returns, alpha) {
  var_value <- quantile(returns, 1 - alpha)
  cvar_value <- mean(returns[returns <= var_value])
  list(VaR = var_value, CVaR = cvar_value)
}

# Calculate rolling VaR and CVaR estimates
rolling_var <- NULL
rolling_cvar <- NULL

for (i in window_width:length(robo_data$Returns)) {
  window_returns <- robo_data$Returns[(i - window_width + 1):i]
  var_cvar_values <- calculate_var(window_returns, alpha = 0.05)  
  rolling_var <- c(rolling_var, var_cvar_values$VaR)
  rolling_cvar <- c(rolling_cvar, var_cvar_values$CVaR)
}

# Add rolling VaR and CVaR to the original data
robo_data$RollingVaR <- c(rep(NA, window_width - 1), rolling_var)
robo_data$RollingCVaR <- c(rep(NA, window_width - 1), rolling_cvar)

# Print the results for the last few rows
tail(robo_data)

# Analysis of variability
# You can analyze the variability of the rolling VaR and CVaR estimates here.
# Compare the estimates over time and assess their stability and effectiveness as predictive measures.
# You can plot graphs or calculate statistics to support your analysis.

# Summary insights
cat("Based on the analysis of variability, it appears that...")
