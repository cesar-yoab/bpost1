# All the code contained in this script is what was used to create the first blog post
# as such this file only contains the code, see the .Rmd file for both the 
# code and the text.

# Libraries used for this project
library(cesR)
library(labelled)
library(tidyverse)
library(plyr)
library(cowplot)

#### DOWLOAD AND CLEAN DATA #####
# call 2019 CES online survey
get_ces("ces2019_web")

# convert values to factor type
ces2019_web <- to_factor(ces2019_web)


# Remap variables and create a new column
ces_raw <- ces2019_web %>% select("cps19_votechoice", "cps19_education")
original_labels <- unique(ces_raw$cps19_votechoice)
new_labels<- c("Green Party", "Don't Know / Prefer no ans.", "Liberal", "Conservative",
               "NA", "ndp",  "Another", "Bloc Qbc", "People's Party")
ces_raw$votechoice <- mapvalues(ces_raw$cps19_votechoice, 
                                from=original_labels, to=new_labels)

# We set "Don't know/Prefer not" to NA to benefit from the is.na() function
# when creating plots
ces_raw$votechoice[ces_raw$votechoice == "Don't Know / Prefer no ans."] <- NA
ces_raw <- ces_raw[complete.cases(ces_raw),]

ces_raw <- ces_raw[ces_raw$cps19_education != "Don't know/ Prefer not to answer", ]
N <- length(ces_raw$votechoice)

# University Education
u_education <- c("Some university", "Bachelor's degree", "Master's degree", "Professional degree or doctorate")
uni_eductaion <- ces_raw[ces_raw$cps19_education == u_education, ] # select wanted columns

# Create data frame with percentage of votes
uni_percents <- as.data.frame(table(uni_eductaion$votechoice) / length(uni_eductaion$votechoice))

# Rename columns
names(uni_percents)[1] <- "party"
names(uni_percents)[2] <- "percentage"

# Remove unwanted rows and set percentage in the range [0, 100]
uni_percents <- uni_percents[-c(8), ]
uni_percents$percentage <- uni_percents$percentage * 100


# Non-University eductaion
nu_education <- c("Some technical, community college, CEGEP, College Classique",
                     "Some elementary school", "Some secondary/ high school",
                     "Completed technical, community college, CEGEP, College Classique",
                     "Completed elementary school", "No schooling")
non_uni_education <- ces_raw[ces_raw$cps19_education == nu_education, ] # select wanted columns

# Create data frame with percentage of votes
non_uni_percents <- as.data.frame(table(non_uni_education$votechoice)/length(non_uni_education$votechoice))

# Rename columns
names(non_uni_percents)[1] <- "party"
names(non_uni_percents)[2] <- "percentage"

# Remove unwanted rows and set percentages in range [0, 100]
non_uni_percents <- non_uni_percents[-c(8), ]
non_uni_percents$percentage <- non_uni_percents$percentage * 100


##### PLOT GENERATION #####
# Generate plots and final plot for presentation
hed_plot <- ggplot(uni_percents, aes(x=party, y=percentage)) + # Plot for university education
  geom_bar(stat="identity", fill = I("springgreen3"), alpha=I(.9)) + 
  theme_linedraw() + 
  labs(title = "University Vote choices (n=3166)", x = "Vote Choice", y = "Percentage (%)") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1), 
        text = element_text(size=16)) + ylim(0, 45)


led_plot <- ggplot(non_uni_percents, aes(x=party, y=percentage)) + # Plot for non-university
  geom_bar(stat="identity", fill = I("firebrick3"), alpha=I(.9)) + 
  theme_linedraw() + 
  labs(title = "Non-University Vote choices (n=1659)", x = "Vote Choice", y = "Percentage (%)") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1), 
        text = element_text(size=16)) + ylim(0, 45)

plot_grid(hed_plot, led_plot) # Set both plots in a grid to use as a single figure.


##### NAIVE BAYES #####
# Probability p(c) for party c
pi_hat <- table(ces_raw$votechoice) / N

# # party "c" and "education" / # party "c" in dataset
theta_uni <- table(uni_eductaion$votechoice) / table(ces_raw$votechoice)
theta_non_uni <- table(non_uni_education$votechoice) / table(ces_raw$votechoice)

# Probabilities given university education
puni <- pi_hat * theta_uni
# Probabilities given non-university education
pnuni <- pi_hat * theta_non_uni

# Set results in a matrix and round values for presentation
results <- cbind(puni, pnuni)
results <- results[1:7,]
results <- round(results, digits = 4)

# On the Rmd file we used the following command
# knitr::kable(round(results, digits = 4), col.names = c("University", "Non-University"), 
#             align = "ccc", caption="Proportional values to $p(c|x)$")


##### CLEAN UP #####
rm(list = ls())