#### Explanatory Variables

Plots the relationship of a selected *downtown* socioeconomic factor and selected recovery metric. This plot takes *all* cities into consideration, but a select few can be highlight for comparison's sake. You can click on any point in the plot to see the exact value of the selected independent and dependent variables, rounded to two decimal points. The points are colored according to region.

#### Select Metric

Recovery Quotient (RQ) Downtown: Compares the activity in downtowns between post-COVID period and pre-COVID period.

Recovery Quotient (RQ) City: Compares the activity in the entire city between post-COVID period and pre-COVID period.

Location Quotient (LQ): Measures the proportion of activity in downtown areas vs. the rest of the city between post-COVID period and pre-COVID period.

#### Select independent variable

These represent socioeconomic factors in the *downtown* areas of each city. 

#### Select dependent variable
The dependent variable is the period, rate of recovery, and omicron resilience. It is renamed to 'dependent variable' in this plot to signify that the change in this value is what we want to learn more about using the independent variables.

Each numbered period averages the chosen metric over the specified window of time. 

Rate of recovery is the ratio of the metric in Period 4 divided by Period 1

Omicron resilience is the ratio of the average weekly metric between January 2022 - February 2022 divided by September 2021 - December 2021

#### City

Highlights cities on the plot. Changing this does not change the trendline or coefficients as the line is fitted to all observations no matter what. This option is solely to make it easier to identify cities of interest. Cities are colored according to their region.

#### Plot

The horizontal axis will be in units of the independent variable; the vertical axis will be in units of the dependent variable. 

#### Line by line explanation of the printout:

The default values will be used here as an example, but changes to metric, independent variable, and dependent variable will result in different numbers, although the interpretation of the output remains the same.

```
Call:
lm(formula = "y~x", data = plot_df)
```

This means that a linear model is being fit to the selected independent and dependent variables for a given metric. 

```
Residuals:
     Min       1Q   Median       3Q      Max 
-0.22071 -0.12082 -0.00304  0.08707  0.45152 
```

The *residuals* of a linear regression measures how far off each prediction is from the true value. Each residual is calculated by subtracting the the predicted value of the dependent variable from the actual value of the dependent variable for each observation. 

```
Coefficients:
             Estimate Std. Error t value Pr(>|t|)    
(Intercept)  0.614312   0.030569  20.096  < 2e-16 ***
x           -0.019193   0.006254  -3.069  0.00322 ** 
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
```

The coefficients represent the value you would have to multiply the independent variable by in order to have the prediction come as close to possible to the true dependent variable, for *all* observations. 

The estimate for the intercept is the predicted value of the dependent variable when only taking into consideration the average of the independent variables for all observations. 

The estimate for x describes the relationship between the change in independent variable and the effect it has on the predicted value of the dependent variable. In this case, the coefficient indicates that for each one unit increase in the independent variable corresponds to a decrease of .019193 in the independent variable. In the specific case of the default example, for each 1% increase in the percent of jobs in information in a city's downtown, the recovery quotient in period 4 decreases by .019193. 

The standard error is a measure of the average amount that the coefficient estimates vary from the actual average of the dependent variable. In the event the model was run over and over, the estimate would vary by the standard error.

The t value is the value of the t-statistic to be used when testing whether the coefficient estimate is different from zero. The assumption of regression is that the coefficient estimates will all be zero  and any relationship between independent variables and dependent variable is strictly due to random chance. A zero coefficient would allow for anything to be the input, because zero multiplied by the input data would always result in zero. 

The p-value is to be used to perform the hypothesis test for which the observed t value will be tested against the null hypothesis- that the true coefficient estimate is zero and any relationship that exists is strictly due to random chance. A very low p-value suggests that it would be rare to see the result of the hypothesis test if the null hypothesis were true. A low p-value does not conclusively determine anything, but it does indicate that whatever is being observed is unlikely under the assumption that no linear relationship exists.

```
Residual standard error: 0.1436 on 60 degrees of freedom
Multiple R-squared:  0.1357,	Adjusted R-squared:  0.1213 
F-statistic: 9.417 on 1 and 60 DF,  p-value: 0.003225
```

These summary statistics describe the model as a whole rather than by each individual coefficient. 

Residual standard error describes the standard error of all residuals. It is the average amount that the true dependent variable deviates from the regression line. In this case, it means that the true downtown RQ4 deviates by .1436 from the regression line. Given that the mean RQ4 for all observations is 0.614312 (the Intercept coefficient), the percentage that any prediction would be off by *at minimum* is 23.38%. The degrees of freedom refers to the number of data points that go into estimating the coefficients, which is the total number of observations subtracted by the number of coefficients to estimate.

The multiple $R^2$ and adjusted $R^2$ are measures of how well the model fits the actual data. It describes the amount of variance in the data that the model can explain. It is a proportion, so the maximum is 1. Closer to 1 means that more variance is explained and a lower number means less of it is explained. The multiple $R^2$ will always increase as more variables are added, so the adjusted $R^2$ is more reliable in getting an accurate picture of how well the model fits the data. 

The F-statistic indicates whether there is a relationship between the independent and dependent variables. The null hypothesis assumes that there is no relationship and the F-statistic is equal to 1. Since the value necessary to reject the null hypothesis depends on the number of data points and number of predictors, the p-value that accompanies the F-statistic can be used in the hypothesis test. The p-value is the probability of the observed F-statistic existing under the null hypothesis-- the lower the p-value is, the more unlikely it is that no relationship exists between the variables. 

#### Table of coefficients

This is a printout of the coefficients for all independent variables fit in their own separate model, should you ever want to compare all of them at once for a given dependent variable and metric. 

#### Limitations:

As with any form of modeling, this does not and will never exactly predict a downtown's activity recovery or conclusively prove any independent variable is the cause for a downtown's activity recovery. The Census response rate is never 100%. The plot and model printout can only be used to state whether or not it is more likely than not that a linear relationship exists between two variables. The p-values, no matter how low, can never truly rule out the null hypothesis in favor of the alternative. 
#### Relevant libraries
dplyr, tidyverse, ggplot2, ggrepel, 
[Back to top](#)
