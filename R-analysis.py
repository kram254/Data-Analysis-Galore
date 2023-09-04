import pandas as pd
import numpy as np
import scipy.stats as stats

# Read the CSV data
robo_data = pd.read_csv("ROBO2.csv")
robo_data['dates'] = pd.to_datetime(robo_data['dates'])  # Convert to datetime format

# Explore the data
print("Exploratory Analysis:")
print(robo_data.head())  # Display the first few rows
print(robo_data.describe())  # Summary statistics

# Calculate monthly rolling VaR and CVaR
window_width = 24  # 24 months
confidence_level = 0.95

def calculate_var_cvar(returns):
    var = np.percentile(returns, (1 - confidence_level) * 100)
    cvar = np.mean(returns[returns <= var])
    return var, cvar

rolling_var = []
rolling_cvar = []

for i in range(window_width, len(robo_data)):
    monthly_returns = robo_data['today'].values[i - window_width: i]
    var, cvar = calculate_var_cvar(monthly_returns)
    rolling_var.append(var)
    rolling_cvar.append(cvar)

# Create NaN values for the initial rows
rolling_var = [np.nan] * (window_width - 1) + rolling_var
rolling_cvar = [np.nan] * (window_width - 1) + rolling_cvar

# Add RollingVaR and RollingCVaR columns to the dataframe
robo_data['RollingVaR'] = rolling_var
robo_data['RollingCVaR'] = rolling_cvar

# Print the resulting dataframe with RollingVaR and RollingCVaR
print("\nDataframe with RollingVaR and RollingCVaR:")
print(robo_data)

# Insights on variability and effectiveness of VaR
print("\nInsights:")
variability = np.std(rolling_var)
print("Variability of Rolling VaR Estimates:", variability)
print("VaR appears to be effective as a measure if the variability is relatively low and consistent.")
