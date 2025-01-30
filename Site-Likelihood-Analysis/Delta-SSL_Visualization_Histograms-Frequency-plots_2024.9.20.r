#
# Plotting historygrams or frequency plots of Delta SSLs 
# Date: 2024/9/7
#
rm(list=ls())

# setwd
# setwd("/home/administrator/ExtraSSD2/Justin/Analyses_JMB/SSL_plots/SSL_IQTREE_NucConcat/")

# load libraries
library(tidyverse)
library(rlist)
library(karyoploteR)
library(qqman)
library(dplyr)
library(purrr)

# # get mito and Z SSLs
# mito.ssl <- list.files(pattern = "\\.mitoTree.sitelh", full.names = TRUE)
# Z.ssl <- list.files(pattern = "\\.ZTree.sitelh", full.names = TRUE)

# # load in nuclear SSLs. Make sure the files are in the same order in both lists 
# gen.pos <- list.files(pattern = "partitions\\.txt$", full.names = TRUE)
# ssl <- list.files(pattern = "\\.nucTree.sitelh", full.names = TRUE)
# chromlist = c('scaffold-ma1',
#               'scaffold-ma2',
#               'scaffold-ma3',
#               'scaffold-ma4',
#               'scaffold-ma5',
#               'scaffold-ma6',
#               'scaffold-ma7',
#               'scaffold-mi1',
#               'scaffold-mi10',
#               'scaffold-mi2',
#               'scaffold-mi3',
#               'scaffold-mi4',
#               'scaffold-mi5',
#               'scaffold-mi6',
#               'scaffold-mi7',
#               'scaffold-mi8',
#               'scaffold-mi9',
#               'scaffold-Z')


# templist = list()

# # read in all of the partition files (obtained from catsequences)
# for(i in 1:length(gen.pos))
# {
#     gen.pos.file = gen.pos[i]
#     print(i)
#     data = read.delim(gen.pos.file, header = FALSE) %>%
#     mutate(V1 = gsub(".*_", "", V1)) %>% #.* in regex is any number (.) or any character (*)
#     mutate(V1 = gsub(".fasta", "", V1)) %>%
#     rowwise() %>% # must use this because dplyr works in a vector way, but strsplit outputs a list. So we do this row by row and take the proper element of the list each time.
#     mutate(start = strsplit(V1, "-")[[1]][1]) %>% #split on the "-" and will give two elements, one before and one after the dash. Here we are naming 1,1 as start and 1,2 as end (next line).
#     mutate(end = strsplit(V1, "-")[[1]][2]) %>%
#     as.data.frame()
    
#     temp <- readLines(ssl[i])
#     numbers <- as.numeric(strsplit(temp[2], "\\s+")[[1]])
#     nuc.numbers <- numbers[-1] # delete the first 'number' as it is NA due to the .sitelh format
#     temp <- readLines(mito.ssl[i])
#     numbers <- as.numeric(strsplit(temp[2], "\\s+")[[1]])
#     mito.numbers <- numbers[-1] # delete the first 'number' as it is NA due to the .sitelh format
#     temp <- readLines(Z.ssl[i])
#     numbers <- as.numeric(strsplit(temp[2], "\\s+")[[1]])
#     Z.numbers <- numbers[-1] # delete the first 'number' as it is NA due to the .sitelh format
    
#     templistpos = list()
#     for(j in 1:nrow(data))
#     {
#       print(paste0(j,'/',nrow(data)))
#       pos = seq(data$start[j], data$end[j], 1)
#       templistpos = list.append(templistpos, pos)
#     }
#     pos.vec =unlist(templistpos)
    
#     temp_df = data.frame(Chrom = chromlist[i],
#                          pos = pos.vec,
#                          nuc.ssl = nuc.numbers,
#                          mito.ssl = mito.numbers,
#                          Z.ssl = Z.numbers)
#     templist = list.append(templist,temp_df)
# }

# final_df = do.call(rbind.data.frame, templist)

# # write.csv(final_df, "SSL_all-chrom.csv")
# dim(final_df)


# # Read the .txt file
# data <- readLines()

# # Extract numbers from the second line
# numbers <- as.numeric(strsplit(data[2], "\\s+")[[1]])

# # Print the vector
# print(numbers)

###################################################
#
# Checking where the top 1% quantile of SSLs are
#
##################################################

# setwd
setwd("/home/administrator/ExtraSSD2/Justin/Analyses_JMB/SSL_plots/")

# this function is faster than read.csv but will make a new first column out of the row names, so we will select it out.
final_df = readr::read_csv("./SSL_all-chrom.csv") %>%
    as.data.frame() %>% 
    select(-1)
head(final_df)

# Make a column for the delta (change) SSL betwen nuclear and mito SSLs
# A difference between two logs is a ratio, so we need to transform after since we are not trying to get a ratio. 
delta.ssl <- as.data.frame(final_df) %>%
    mutate(Delta.NucMito = nuc.ssl-mito.ssl) %>%
    mutate(Delta.NucZ = nuc.ssl-Z.ssl)

head(delta.ssl)

# can get the sum of the Delta SSLs
test.no.out <- delta.ssl %>%
  filter(Delta.NucZ < quantile(Delta.NucZ, 0.99) & Delta.NucZ > quantile(Delta.NucZ, 0.01))

sum <- delta.ssl %>%
  filter(Chrom == "scaffold-Z") %>%
  summarise(sum_Delta_NucZ = sum(Delta.NucZ, na.rm = TRUE))
print(sum)

# let's get sum of delta.ssl for NucMito values for bins of our values (e.g., -1 to 1, -2 to 2, ... -16 to 16)
head(delta.ssl)
range(delta.ssl$Delta.NucMito)
# [1] -13.5237  15.4987

# Define the range values (-1 to 1, -2 to 2, ..., -16 to 16)
bin_ranges <- seq(1, 16)
bin_ranges

# Initialize an empty dataframe to store results
results.nm <- data.frame(bin_range = numeric(), sum_Delta_NucMito = numeric())

# Loop over the bin ranges and calculate the sum for each
for (bin in bin_ranges) {
  # Define the lower and upper bounds for the bin
  lower_bound <- -bin
  upper_bound <- bin
  
  # Filter the Delta.NucMito values within the current bin
  sum_in_bin <- sum(delta.ssl$Delta.NucMito[delta.ssl$Delta.NucMito >= lower_bound & delta.ssl$Delta.NucMito <= upper_bound])
  
  # Append the result to the dataframe
  results.nm <- rbind(results.nm, data.frame(bin_range = paste(lower_bound, "to", upper_bound), sum_Delta_NucMito = sum_in_bin))
}

# Print the results
print(results.nm)
#   bin_range sum_Delta_NucMito
#1    -1 to 1        -23593.460
#2    -2 to 2         -9173.562
#3    -3 to 3        -10981.057
#4    -4 to 4        -26114.115
#5    -5 to 5        110221.995
#6    -6 to 6        268766.247
#7    -7 to 7        390280.653
#8    -8 to 8        421755.777
#9    -9 to 9        422588.654
#10 -10 to 10        422771.931
#11 -11 to 11        423116.184
#12 -12 to 12        423288.994
#13 -13 to 13        423498.967
#14 -14 to 14        423645.346
#15 -15 to 15        423702.884
#16 -16 to 16        423718.383

# Ensure the bin_range column in the results dataframe is a factor and ordered correctly
results.nm$bin_range <- factor(results.nm$bin_range, levels = c("-1 to 1", "-2 to 2", "-3 to 3", "-4 to 4", 
                                                          "-5 to 5", "-6 to 6", "-7 to 7", "-8 to 8", 
                                                          "-9 to 9", "-10 to 10", "-11 to 11", "-12 to 12", 
                                                          "-13 to 13", "-14 to 14", "-15 to 15", "-16 to 16"))

# make a bar plot of sum_Delta_NucMito for each bin range in numeric order
# pdf("Sum-DeltaSSL-NucMito_all-bin-ranges.pdf")
ggplot(results.nm, aes(x = bin_range, y = sum_Delta_NucMito)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  theme_minimal() +
  xlab("Bin Range (DeltaSSL -X to X)") +
  ylab("Sum of DeltaSSL (Nuc vs. Mito Tree)") +
  ggtitle("Sum of Delta SSL Across Delta SSL Ranges (Nuc. vs. Mito)") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) # Rotate x-axis labels for readability
# dev.off()

# can do the absolute value version too
results.nm.abs <- results.nm 
results.nm.abs$sum_Delta_NucMito <- abs(results.nm$sum_Delta_NucMito)

# pdf("Sum-DeltaSSL-NucMito_all-bin-ranges_absolute-value.pdf")
ggplot(results.nm.abs, aes(x = bin_range, y = sum_Delta_NucMito)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  theme_minimal() +
  xlab("Bin Range (DeltaSSL -X to X)") +
  ylab("Absolute Value of Sum of DeltaSSL (Nuc vs. Mito Tree)") +
  ggtitle("Absolute Value of Sum of Delta SSL Across Delta SSL Ranges (Nuc. vs. Mito)") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) # Rotate x-axis labels for readability
# dev.off()


# do the same for NucZ
range(delta.ssl$Delta.NucZ)
#[1] -13.8908  13.8477

# Define the range values (-1 to 1, -2 to 2, ..., -16 to 16)
bin_ranges <- seq(1, 14)
bin_ranges

# Initialize an empty dataframe to store results
results.z <- data.frame(bin_range = numeric(), sum_Delta_NucZ = numeric())

# Loop over the bin ranges and calculate the sum for each
for (bin in bin_ranges) {
  # Define the lower and upper bounds for the bin
  lower_bound <- -bin
  upper_bound <- bin
  
  # Filter the Delta.NucZ values within the current bin
  sum_in_bin <- sum(delta.ssl$Delta.NucZ[delta.ssl$Delta.NucZ >= lower_bound & delta.ssl$Delta.NucZ <= upper_bound])
  
  # Append the result to the dataframe
  results.z <- rbind(results.z, data.frame(bin_range = paste(lower_bound, "to", upper_bound), sum_Delta_NucZ = sum_in_bin))
}

# Print the results
print(results.z)
#   bin_range sum_Delta_NucZ
#1    -1 to 1      -3098.548
#2    -2 to 2      -2756.455
#3    -3 to 3      -3915.925
#4    -4 to 4     -22332.263
#5    -5 to 5      47121.293
#6    -6 to 6      98931.395
#7    -7 to 7     151101.259
#8    -8 to 8     171718.037
#9    -9 to 9     171420.742
#10 -10 to 10     171126.574
#11 -11 to 11     170919.564
#12 -12 to 12     170781.733
#13 -13 to 13     170545.217
#14 -14 to 14     170504.551

# make a bar plot of sum_Delta_NucMito for each bin range in numeric order
results.z$bin_range <- factor(results.z$bin_range, levels = c("-1 to 1", "-2 to 2", "-3 to 3", "-4 to 4", 
                                                          "-5 to 5", "-6 to 6", "-7 to 7", "-8 to 8", 
                                                          "-9 to 9", "-10 to 10", "-11 to 11", "-12 to 12", 
                                                          "-13 to 13", "-14 to 14"))

# Bar plot of sum_Delta_NucZ for each bin range, now ordered correctly
# pdf("Sum-DeltaSSL-NucZ_all-bin-ranges.pdf")
ggplot(results.z, aes(x = bin_range, y = sum_Delta_NucZ)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  theme_minimal() +
  xlab("Bin Range (-X to X)") +
  ylab("Sum of DeltaSSL (Nuc vs. Z Tree)") +
  ggtitle("Sum of Delta SSL Across Delta SSL Ranges (Nuc. vs. Z)") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) # Rotate x-axis labels for readability
# dev.off()


# can do the absolute value version too
results.z.abs <- results.z 
results.z.abs$sum_Delta_NucZ <- abs(results.z$sum_Delta_NucZ)

# pdf("Sum-DeltaSSL-NucZ_all-bin-ranges_absolute-value.pdf")
ggplot(results.z.abs, aes(x = bin_range, y = sum_Delta_NucZ)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  theme_minimal() +
  xlab("Bin Range (DeltaSSL -X to X)") +
  ylab("Absolute Value of Sum of DeltaSSL (Nuc vs. Z Tree)") +
  ggtitle("Absolute Value of Sum of Delta SSL Across Delta SSL Ranges (Nuc. vs. Z)") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) # Rotate x-axis labels for readability
# dev.off()

#================== let's look at the sum of Delta SSLs across the genome

### NucMito 

# Quantiles
lower_quantile <- quantile(delta.ssl$Delta.NucMito, 0.01)
upper_quantile <- quantile(delta.ssl$Delta.NucMito, 0.99)

# Filter for bottom 1% (values greater than 1st percentile), top 1%, and top & bottom 1%
delta.ssl.NucMito.X1BQ <- delta.ssl %>% filter(Delta.NucMito > lower_quantile)  # Bottom 1% as per original
delta.ssl.NucMito.XT1Q <- delta.ssl %>% filter(Delta.NucMito < upper_quantile)  # Top 1% as per original
delta.ssl.NucMito.XTB1Q <- delta.ssl %>% filter(Delta.NucMito > lower_quantile & Delta.NucMito < upper_quantile)  # Both top & bottom 1%

# Create a summary table for genome-wide sums
summary_table.all.NucMito <- data.frame(
  Filter = c("No filtering", "Without Bottom 1%", "Without Top 1%", "Without Top and Bottom 1%"),
  Sum_Delta_NucMito = c(
    sum(delta.ssl$Delta.NucMito),                    # No filtering
    sum(delta.ssl.NucMito.X1BQ$Delta.NucMito),       # Without Bottom 1%
    sum(delta.ssl.NucMito.XT1Q$Delta.NucMito),       # Without Top 1%
    sum(delta.ssl.NucMito.XTB1Q$Delta.NucMito)       # Without Top and Bottom 1%
  )
)

# Print summary table
print(summary_table.all.NucMito)
#                     Filter Sum_Delta_NucMito
#1              No filtering         423718.38
#2         Without Bottom 1%         942665.62
#3            Without Top 1%        -443041.92
#4 Without Top and Bottom 1%          75905.32

### NucZ

# Quantiles
lower_quantile <- quantile(delta.ssl$Delta.NucZ, 0.01)
upper_quantile <- quantile(delta.ssl$Delta.NucZ, 0.99)

# Filter for bottom 1% (values greater than 1st percentile), top 1%, and top & bottom 1%
delta.ssl.NucZ.X1BQ <- delta.ssl %>% filter(Delta.NucZ > lower_quantile)  # Bottom 1% Zer original
delta.ssl.NucZ.XT1Q <- delta.ssl %>% filter(Delta.NucZ< upper_quantile)  # Top 1% as per original
delta.ssl.NucZ.XTB1Q <- delta.ssl %>% filter(Delta.NucZ > lower_quantile & Delta.NucZ < upper_quantile)  # Both top & bottom 1.%

# Create a summary table for genome-wide sums
summary_table.all.NucZ <- data.frame(
  Filter = c("No filtering", "Without Bottom 1%", "Without Top 1%", "Without Top and Bottom 1%"),
  Sum_Delta_NucZ = c(
    sum(delta.ssl$Delta.NucZ),                    # No filtering
    sum(delta.ssl.NucZ.X1BQ$Delta.NucZ),       # Without Bottom 1%
    sum(delta.ssl.NucZ.XT1Q$Delta.NucZ),       # Without Top 1%
    sum(delta.ssl.NucZ.XTB1Q$Delta.NucZ)       # Without Top and Bottom 1%
  )
)

# Print summary table
print(summary_table.all.NucZ)
#                     Filter Sum_Delta_NucZ
#1              No filtering      170504.55
#2         Without Bottom 1%      661640.00
#3            Without Top 1%     -462714.59
#4 Without Top and Bottom 1%       28420.85

#================== let's look at the sum of Delta SSLs for individual chromosomes

### NucMito

library(dplyr)

# Initialize an empty list to store results
summary_list <- list()

# Get unique chromosome values
chromosomes <- unique(delta.ssl$Chrom)

# Loop through each chromosome
for (chrom in chromosomes) {
  # Filter for the current chromosome
  chrom_data <- delta.ssl %>% filter(Chrom == chrom)
  
  # Quantiles for the current chromosome
  lower_quantile <- quantile(chrom_data$Delta.NucMito, 0.01)
  upper_quantile <- quantile(chrom_data$Delta.NucMito, 0.99)
  
  # Filter for bottom 1%, top 1%, and both top & bottom 1%
  chrom_X1BQ <- chrom_data %>% filter(Delta.NucMito > lower_quantile)
  chrom_XT1Q <- chrom_data %>% filter(Delta.NucMito < upper_quantile)
  chrom_XTB1Q <- chrom_data %>% filter(Delta.NucMito > lower_quantile & Delta.NucMito < upper_quantile)
  
  # Create summary for the current chromosome
  summary_table <- data.frame(
    Filter = c("No filtering", "Without Bottom 1%", "Without Top 1%", "Without Top and Bottom 1%"),
    Sum_Delta_NucMito = c(
      sum(chrom_data$Delta.NucMito),                     # No filtering
      sum(chrom_X1BQ$Delta.NucMito),                      # Bottom 1%
      sum(chrom_XT1Q$Delta.NucMito),                      # Top 1%
      sum(chrom_XTB1Q$Delta.NucMito)                      # Top and Bottom 1%
    )
  )
  
  # Add chromosome name to summary table
  summary_table$Chrom <- chrom
  
  # Append to the list
  summary_list[[chrom]] <- summary_table
}

# Combine all summary tables into one dataframe
summary_table_chroms_NucMito <- do.call(rbind, summary_list)
write.csv(summary_table_chroms_NucMito, file = "Sum-DeltaSSL_NucMito_chrom-filtering.csv", row.names = FALSE)

# Print summary table
print(summary_table_chroms_NucMito)
#                                   Filter Sum_Delta_NucMito         Chrom
#scaffold-ma1.1               No filtering       126673.6512  scaffold-ma1
#scaffold-ma1.2          Without Bottom 1%       276498.5250  scaffold-ma1
#scaffold-ma1.3             Without Top 1%      -126948.4110  scaffold-ma1
#scaffold-ma1.4  Without Top and Bottom 1%        22876.4628  scaffold-ma1
#scaffold-ma2.1               No filtering        88175.2905  scaffold-ma2
#scaffold-ma2.2          Without Bottom 1%       198477.9555  scaffold-ma2
#scaffold-ma2.3             Without Top 1%       -94532.1208  scaffold-ma2
#scaffold-ma2.4  Without Top and Bottom 1%        15770.5441  scaffold-ma2
#scaffold-ma3.1               No filtering        67476.7803  scaffold-ma3
#scaffold-ma3.2          Without Bottom 1%       151770.0833  scaffold-ma3
#scaffold-ma3.3             Without Top 1%       -72564.0175  scaffold-ma3
#scaffold-ma3.4  Without Top and Bottom 1%        11729.2855  scaffold-ma3
#scaffold-ma4.1               No filtering        27802.8584  scaffold-ma4
#scaffold-ma4.2          Without Bottom 1%        55032.6808  scaffold-ma4
#scaffold-ma4.3             Without Top 1%       -22448.2310  scaffold-ma4
#scaffold-ma4.4  Without Top and Bottom 1%         4781.5913  scaffold-ma4
#scaffold-ma5.1               No filtering        25488.4852  scaffold-ma5
#scaffold-ma5.2          Without Bottom 1%        56183.9055  scaffold-ma5
#scaffold-ma5.3             Without Top 1%       -26357.7805  scaffold-ma5
#scaffold-ma5.4  Without Top and Bottom 1%         4337.6398  scaffold-ma5
#scaffold-ma6.1               No filtering        10219.5624  scaffold-ma6
#scaffold-ma6.2          Without Bottom 1%        25710.5369  scaffold-ma6
#scaffold-ma6.3             Without Top 1%       -13830.3317  scaffold-ma6
#scaffold-ma6.4  Without Top and Bottom 1%         1660.6428  scaffold-ma6
#scaffold-ma7.1               No filtering        11648.0465  scaffold-ma7
#scaffold-ma7.2          Without Bottom 1%        25878.3124  scaffold-ma7
#scaffold-ma7.3             Without Top 1%       -12183.5994  scaffold-ma7
#scaffold-ma7.4  Without Top and Bottom 1%         2046.6665  scaffold-ma7
#scaffold-mi1.1               No filtering        11530.2201  scaffold-mi1
#scaffold-mi1.2          Without Bottom 1%        25542.4380  scaffold-mi1
#scaffold-mi1.3             Without Top 1%       -11865.7744  scaffold-mi1
#scaffold-mi1.4  Without Top and Bottom 1%         2146.4434  scaffold-mi1
#scaffold-mi10.1              No filtering         1763.2866 scaffold-mi10
#scaffold-mi10.2         Without Bottom 1%         5002.9417 scaffold-mi10
#scaffold-mi10.3            Without Top 1%        -2891.7359 scaffold-mi10
#scaffold-mi10.4 Without Top and Bottom 1%          347.9193 scaffold-mi10
#scaffold-mi2.1               No filtering         5558.6500  scaffold-mi2
#scaffold-mi2.2          Without Bottom 1%        11551.5587  scaffold-mi2
#scaffold-mi2.3             Without Top 1%        -4930.3052  scaffold-mi2
#scaffold-mi2.4  Without Top and Bottom 1%         1062.6035  scaffold-mi2
#scaffold-mi3.1               No filtering        10265.8359  scaffold-mi3
#scaffold-mi3.2          Without Bottom 1%        21197.4102  scaffold-mi3
#scaffold-mi3.3             Without Top 1%        -8897.3052  scaffold-mi3
#scaffold-mi3.4  Without Top and Bottom 1%         2034.2691  scaffold-mi3
#scaffold-mi4.1               No filtering         6635.9961  scaffold-mi4
#scaffold-mi4.2          Without Bottom 1%        15821.3371  scaffold-mi4
#scaffold-mi4.3             Without Top 1%        -7826.8429  scaffold-mi4
#scaffold-mi4.4  Without Top and Bottom 1%         1358.4981  scaffold-mi4
#scaffold-mi5.1               No filtering         4409.7359  scaffold-mi5
#scaffold-mi5.2          Without Bottom 1%         8795.9498  scaffold-mi5
#scaffold-mi5.3             Without Top 1%        -3472.8358  scaffold-mi5
#scaffold-mi5.4  Without Top and Bottom 1%          913.3781  scaffold-mi5
#scaffold-mi6.1               No filtering         8105.1627  scaffold-mi6
#scaffold-mi6.2          Without Bottom 1%        18046.0730  scaffold-mi6
#scaffold-mi6.3             Without Top 1%        -8326.5063  scaffold-mi6
#scaffold-mi6.4  Without Top and Bottom 1%         1614.4041  scaffold-mi6
#scaffold-mi7.1               No filtering         5620.7104  scaffold-mi7
#scaffold-mi7.2          Without Bottom 1%        15249.8871  scaffold-mi7
#scaffold-mi7.3             Without Top 1%        -8594.0710  scaffold-mi7
#scaffold-mi7.4  Without Top and Bottom 1%         1035.1056  scaffold-mi7
#scaffold-mi8.1               No filtering         8260.7245  scaffold-mi8
#scaffold-mi8.2          Without Bottom 1%        22373.2704  scaffold-mi8
#scaffold-mi8.3             Without Top 1%       -12511.1560  scaffold-mi8
#scaffold-mi8.4  Without Top and Bottom 1%         1601.3899  scaffold-mi8
#scaffold-mi9.1               No filtering          711.0927  scaffold-mi9
#scaffold-mi9.2          Without Bottom 1%         1728.5236  scaffold-mi9
#scaffold-mi9.3             Without Top 1%         -862.4299  scaffold-mi9
#scaffold-mi9.4  Without Top and Bottom 1%          155.0010  scaffold-mi9
#scaffold-Z.1                 No filtering         3372.2934    scaffold-Z
#scaffold-Z.2            Without Bottom 1%         7754.7620    scaffold-Z
#scaffold-Z.3               Without Top 1%        -3778.1560    scaffold-Z
#scaffold-Z.4    Without Top and Bottom 1%          604.3126    scaffold-Z

### NucZ

library(dplyr)

# Initialize an empty list to store results
summary_list <- list()

# Get unique chromosome values
chromosomes <- unique(delta.ssl$Chrom)

# Loop through each chromosome
for (chrom in chromosomes) {
  # Filter for the current chromosome
  chrom_data <- delta.ssl %>% filter(Chrom == chrom)
  
  # Quantiles for the current chromosome
  lower_quantile <- quantile(chrom_data$Delta.NucZ, 0.01)
  upper_quantile <- quantile(chrom_data$Delta.NucZ, 0.99)
  
  # Filter for bottom 1%, top 1%, and both top & bottom 1%
  chrom_X1BQ <- chrom_data %>% filter(Delta.NucZ > lower_quantile)
  chrom_XT1Q <- chrom_data %>% filter(Delta.NucZ < upper_quantile)
  chrom_XTB1Q <- chrom_data %>% filter(Delta.NucZ > lower_quantile & Delta.NucZ < upper_quantile)
  
  # Create summary for the current chromosome
  summary_table <- data.frame(
    Filter = c("No filtering", "Without Bottom 1%", "Without Top 1%", "Without Top and Bottom 1%"),
    Sum_Delta_NucZ = c(
      sum(chrom_data$Delta.NucZ),                     # No filtering
      sum(chrom_X1BQ$Delta.NucZ),                      # Bottom 1%
      sum(chrom_XT1Q$Delta.NucZ),                      # Top 1%
      sum(chrom_XTB1Q$Delta.NucZ)                      # Top and Bottom 1%
    )
  )
  
  # Add chromosome name to summary table
  summary_table$Chrom <- chrom
  
  # Append to the list
  summary_list[[chrom]] <- summary_table
}

# Combine all summary tables into one dataframe
summary_table_chroms_NucZ <- do.call(rbind, summary_list)

# Print summary table
options(scipen = 999) # changed the scientific notation decimans; change back to 0 for default
write.csv(summary_table_chroms_NucZ, file = "Sum-DeltaSSL_NucZ_chrom-filtering.csv", row.names = FALSE)
print(summary_table_chroms_NucZ) 

#                                   Filter Sum_Delta_NucZ         Chrom
#scaffold-ma1.1               No filtering   48438.302466  scaffold-ma1
#scaffold-ma1.2          Without Bottom 1%  190332.971183  scaffold-ma1
#scaffold-ma1.3             Without Top 1% -133883.570607  scaffold-ma1
#scaffold-ma1.4  Without Top and Bottom 1%    8011.098110  scaffold-ma1
#scaffold-ma2.1               No filtering   32521.423661  scaffold-ma2
#scaffold-ma2.2          Without Bottom 1%  139689.875421  scaffold-ma2
#scaffold-ma2.3             Without Top 1% -101807.046812  scaffold-ma2
#scaffold-ma2.4  Without Top and Bottom 1%    5361.404948  scaffold-ma2
#scaffold-ma3.1               No filtering   29628.209513  scaffold-ma3
#scaffold-ma3.2          Without Bottom 1%  108470.340780  scaffold-ma3
#scaffold-ma3.3             Without Top 1%  -73951.860111  scaffold-ma3
#scaffold-ma3.4  Without Top and Bottom 1%    4890.271156  scaffold-ma3
#scaffold-ma4.1               No filtering   17231.244512  scaffold-ma4
#scaffold-ma4.2          Without Bottom 1%   40801.305076  scaffold-ma4
#scaffold-ma4.3             Without Top 1%  -20799.634536  scaffold-ma4
#scaffold-ma4.4  Without Top and Bottom 1%    2770.426028  scaffold-ma4
#scaffold-ma5.1               No filtering    7774.620144  scaffold-ma5
#scaffold-ma5.2          Without Bottom 1%   36195.467778  scaffold-ma5
#scaffold-ma5.3             Without Top 1%  -27200.817808  scaffold-ma5
#scaffold-ma5.4  Without Top and Bottom 1%    1220.029826  scaffold-ma5
#scaffold-ma6.1               No filtering    3657.670178  scaffold-ma6
#scaffold-ma6.2          Without Bottom 1%   17856.185206  scaffold-ma6
#scaffold-ma6.3             Without Top 1%  -13628.236822  scaffold-ma6
#scaffold-ma6.4  Without Top and Bottom 1%     570.278206  scaffold-ma6
#scaffold-ma7.1               No filtering    4860.795374  scaffold-ma7
#scaffold-ma7.2          Without Bottom 1%   18538.864620  scaffold-ma7
#scaffold-ma7.3             Without Top 1%  -12832.653380  scaffold-ma7
#scaffold-ma7.4  Without Top and Bottom 1%     845.415866  scaffold-ma7
#scaffold-mi1.1               No filtering    6994.385300  scaffold-mi1
#scaffold-mi1.2          Without Bottom 1%   20395.861540  scaffold-mi1
#scaffold-mi1.3             Without Top 1%  -12119.734273  scaffold-mi1
#scaffold-mi1.4  Without Top and Bottom 1%    1281.741967  scaffold-mi1
#scaffold-mi10.1              No filtering     406.098516 scaffold-mi10
#scaffold-mi10.2         Without Bottom 1%    2978.809996 scaffold-mi10
#scaffold-mi10.3            Without Top 1%   -2504.028414 scaffold-mi10
#scaffold-mi10.4 Without Top and Bottom 1%      68.683066 scaffold-mi10
#scaffold-mi2.1               No filtering    1606.468363  scaffold-mi2
#scaffold-mi2.2          Without Bottom 1%    6653.747420  scaffold-mi2
#scaffold-mi2.3             Without Top 1%   -4773.185167  scaffold-mi2
#scaffold-mi2.4  Without Top and Bottom 1%     274.093890  scaffold-mi2
#scaffold-mi3.1               No filtering    6901.636248  scaffold-mi3
#scaffold-mi3.2          Without Bottom 1%   16699.096398  scaffold-mi3
#scaffold-mi3.3             Without Top 1%   -8458.031939  scaffold-mi3
#scaffold-mi3.4  Without Top and Bottom 1%    1339.428211  scaffold-mi3
#scaffold-mi4.1               No filtering    2367.294999  scaffold-mi4
#scaffold-mi4.2          Without Bottom 1%   11274.345255  scaffold-mi4
#scaffold-mi4.3             Without Top 1%   -8492.011038  scaffold-mi4
#scaffold-mi4.4  Without Top and Bottom 1%     415.039218  scaffold-mi4
#scaffold-mi5.1               No filtering    2996.279910  scaffold-mi5
#scaffold-mi5.2          Without Bottom 1%    7371.244410  scaffold-mi5
#scaffold-mi5.3             Without Top 1%   -3798.099870  scaffold-mi5
#scaffold-mi5.4  Without Top and Bottom 1%     576.864630  scaffold-mi5
#scaffold-mi6.1               No filtering    2946.557278  scaffold-mi6
#scaffold-mi6.2          Without Bottom 1%   12518.467196  scaffold-mi6
#scaffold-mi6.3             Without Top 1%   -8993.580485  scaffold-mi6
#scaffold-mi6.4  Without Top and Bottom 1%     578.329433  scaffold-mi6
#scaffold-mi7.1               No filtering     352.992037  scaffold-mi7
#scaffold-mi7.2          Without Bottom 1%   10447.934556  scaffold-mi7
#scaffold-mi7.3             Without Top 1%  -10100.191603  scaffold-mi7
#scaffold-mi7.4  Without Top and Bottom 1%      -5.249084  scaffold-mi7
#scaffold-mi8.1               No filtering    2381.093628  scaffold-mi8
#scaffold-mi8.2          Without Bottom 1%   15198.813814  scaffold-mi8
#scaffold-mi8.3             Without Top 1%  -12383.838312  scaffold-mi8
#scaffold-mi8.4  Without Top and Bottom 1%     433.881874  scaffold-mi8
#scaffold-mi9.1               No filtering     180.317233  scaffold-mi9
#scaffold-mi9.2          Without Bottom 1%    1276.381913  scaffold-mi9
#scaffold-mi9.3             Without Top 1%   -1070.809787  scaffold-mi9
#scaffold-mi9.4  Without Top and Bottom 1%      25.254893  scaffold-mi9
#scaffold-Z.1                 No filtering    -740.838078    scaffold-Z
#scaffold-Z.2            Without Bottom 1%    4844.713917    scaffold-Z
#scaffold-Z.3               Without Top 1%   -5729.653001    scaffold-Z
#scaffold-Z.4    Without Top and Bottom 1%    -144.101006    scaffold-Z

#================== Do the same plots above, but now we will filter just Delta SSLs < -2 and > 2

### NucMito


# get top and bottom 1% in one table
delta.ssl.NucMito.TB1Q <- delta.ssl %>%
  filter(Delta.NucMito > quantile(Delta.NucMito, 0.99) | Delta.NucMito < quantile(Delta.NucMito, 0.01))


# Initialize an empty list to store results
summary_list <- list()

# Get unique chromosome values
chromosomes <- unique(delta.ssl$Chrom)


hist(delta.ssl.NucMito.TB1Q$Delta.NucMito)

# Count how many values are above 2
count_above_2 <- sum(delta.ssl$Delta.NucMito > 2, na.rm = TRUE)

# Count how many values are below -2
count_below_minus_2 <- sum(delta.ssl$Delta.NucMito < -2, na.rm = TRUE)

# Print the results
cat("Count of Delta.NucMito values above 2:", count_above_2, "\n")
#Count of Delta.NucMito values above 2: 138633 

cat("Count of Delta.NucMito values below -2:", count_below_minus_2, "\n")
#Count of Delta.NucMito values below -2: 61543 

# Loop through each chromosome
for (chrom in chromosomes) {
  # Filter for the current chromosome
  chrom_data <- delta.ssl %>% filter(Chrom == chrom)
  
  # Filter out Delta.NucMito values greater than 2 or less than -2
  filtered_chrom_data <- chrom_data %>% filter(!(Delta.NucMito > 2 | Delta.NucMito < -2))
  
  # Create a summary table for the current chromosome
  summary_table <- data.frame(
    Filter = c("No filtering", "Filtered (Delta.NucMito > 2 or < -2)"),
    Sum_Delta_NucMito = c(
      sum(chrom_data$Delta.NucMito, na.rm = TRUE),          # No filtering
      sum(filtered_chrom_data$Delta.NucMito, na.rm = TRUE)   # Filtered
    )
  )
  
  # Add chromosome name to summary table
  summary_table$Chrom <- chrom
  
  # Append to the list
  summary_list[[chrom]] <- summary_table
}

# Combine all summary tables into one dataframe
summary_table_chroms_NucMito <- do.call(rbind, summary_list)

# Print summary table
write.csv(summary_table_chroms_NucMito, file = "Sum-DeltaSSL_NucMito_inside-pos2-neg2-threshold.csv", row.names = FALSE)
print(summary_table_chroms_NucMito)

#                                              Filter Sum_Delta_NucMito         Chrom
#scaffold-ma1.1                          No filtering      126673.65120  scaffold-ma1
#scaffold-ma1.2  Filtered (Delta.NucMito > 2 or < -2)       -3401.48913  scaffold-ma1
#scaffold-ma2.1                          No filtering       88175.29052  scaffold-ma2
#scaffold-ma2.2  Filtered (Delta.NucMito > 2 or < -2)       -1508.22475  scaffold-ma2
#scaffold-ma3.1                          No filtering       67476.78035  scaffold-ma3
#scaffold-ma3.2  Filtered (Delta.NucMito > 2 or < -2)       -1482.27412  scaffold-ma3
#scaffold-ma4.1                          No filtering       27802.85839  scaffold-ma4
#scaffold-ma4.2  Filtered (Delta.NucMito > 2 or < -2)        -317.20101  scaffold-ma4
#scaffold-ma5.1                          No filtering       25488.48517  scaffold-ma5
#scaffold-ma5.2  Filtered (Delta.NucMito > 2 or < -2)        -500.78855  scaffold-ma5
#scaffold-ma6.1                          No filtering       10219.56236  scaffold-ma6
#scaffold-ma6.2  Filtered (Delta.NucMito > 2 or < -2)        -169.05036  scaffold-ma6
#scaffold-ma7.1                          No filtering       11648.04650  scaffold-ma7
#scaffold-ma7.2  Filtered (Delta.NucMito > 2 or < -2)        -353.87776  scaffold-ma7
#scaffold-mi1.1                          No filtering       11530.22014  scaffold-mi1
#scaffold-mi1.2  Filtered (Delta.NucMito > 2 or < -2)         -78.69751  scaffold-mi1
#scaffold-mi10.1                         No filtering        1763.28659 scaffold-mi10
#scaffold-mi10.2 Filtered (Delta.NucMito > 2 or < -2)         -13.58633 scaffold-mi10
#scaffold-mi2.1                          No filtering        5558.64998  scaffold-mi2
#scaffold-mi2.2  Filtered (Delta.NucMito > 2 or < -2)         -94.68259  scaffold-mi2
#scaffold-mi3.1                          No filtering       10265.83587  scaffold-mi3
#scaffold-mi3.2  Filtered (Delta.NucMito > 2 or < -2)        -234.29461  scaffold-mi3
#scaffold-mi4.1                          No filtering        6635.99607  scaffold-mi4
#scaffold-mi4.2  Filtered (Delta.NucMito > 2 or < -2)        -184.68406  scaffold-mi4
#scaffold-mi5.1                          No filtering        4409.73587  scaffold-mi5
#scaffold-mi5.2  Filtered (Delta.NucMito > 2 or < -2)         -46.86862  scaffold-mi5
#scaffold-mi6.1                          No filtering        8105.16267  scaffold-mi6
#scaffold-mi6.2  Filtered (Delta.NucMito > 2 or < -2)        -182.21071  scaffold-mi6
#scaffold-mi7.1                          No filtering        5620.71043  scaffold-mi7
#scaffold-mi7.2  Filtered (Delta.NucMito > 2 or < -2)         -29.50535  scaffold-mi7
#scaffold-mi8.1                          No filtering        8260.72449  scaffold-mi8
#scaffold-mi8.2  Filtered (Delta.NucMito > 2 or < -2)        -258.10053  scaffold-mi8
#scaffold-mi9.1                          No filtering         711.09265  scaffold-mi9
#scaffold-mi9.2  Filtered (Delta.NucMito > 2 or < -2)         -47.00359  scaffold-mi9
#scaffold-Z.1                            No filtering        3372.29338    scaffold-Z
#scaffold-Z.2    Filtered (Delta.NucMito > 2 or < -2)        -271.02251    scaffold-Z

# Really odd that all of the filtered datasets (without values > 2 and < -2) give a negative number, indicating support for the alternative tree.
# Let's check the quantiles 

# Filter the data to include only values between -2 and 2
filtered_data <- delta.ssl %>% filter(Delta.NucMito >= -2 & Delta.NucMito <= 2)

# Calculate quantiles for the filtered data
quantiles <- quantile(filtered_data$Delta.NucMito, probs = c(0, 0.25, 0.5, 0.75, 1))

# Print quantiles
print(quantiles)
#      0%      25%      50%      75%     100% 
#-1.99920  0.00018  0.00025  0.00037  1.99990 

# Calculate percentage of data within the -2 to 2 range
percentage_in_range <- nrow(filtered_data) / nrow(delta.ssl) * 100

# Print percentage
print(paste("Percentage of data within the -2 to 2 range:", round(percentage_in_range, 2), "%"))
#[1] "Percentage of data within the -2 to 2 range: 99.94 %"

# Let's try the above code using the top and bottom 1% instead of threshold values 2 and -2 to see if it matches the other code above
# Note, this code differs from the above code though in that we get the top and bottom 1% for all sites across all chromosomes, whereas above,
# we get the top and bottom 1% for each chromosome individually.

# Initialize an empty list to store results
summary_list <- list()

# Get unique chromosome values
chromosomes <- unique(delta.ssl$Chrom)

# Loop through each chromosome
for (chrom in chromosomes) {
  # Filter for the current chromosome
  chrom_data <- delta.ssl %>% filter(Chrom == chrom)
  
  # Filter out Delta.NucMito values between the 1st and 99th quantiles
  filtered_chrom_data <- chrom_data %>% filter(Delta.NucMito > quantile(Delta.NucMito, 0.01) & Delta.NucMito < quantile(Delta.NucMito, 0.99))
  
  # Create a summary table for the current chromosome
  summary_table <- data.frame(
    Filter = c("No filtering", "Filtered Between Q1 and Q99"),
    Sum_Delta_NucMito = c(
      sum(chrom_data$Delta.NucMito),                        # No filtering
      sum(filtered_chrom_data$Delta.NucMito)                 # Filtered
    )
  )
  
  # Add chromosome name to summary table
  summary_table$Chrom <- chrom
  
  # Append to the list
  summary_list[[chrom]] <- summary_table
}

# Combine all summary tables into one dataframe
summary_table_chroms_NucMito <- do.call(rbind, summary_list)

# Print summary table
write.csv(summary_table_chroms_NucMito, file = "Sum-DeltaSSL_NucMito_genome-wide-filtering.csv", row.names = FALSE)
print(summary_table_chroms_NucMito)
#                                     Filter Sum_Delta_NucMito         Chrom
#scaffold-ma1.1                 No filtering       126673.6512  scaffold-ma1
#scaffold-ma1.2  Filtered Between Q1 and Q99        22876.4628  scaffold-ma1
#scaffold-ma2.1                 No filtering        88175.2905  scaffold-ma2
#scaffold-ma2.2  Filtered Between Q1 and Q99        15770.5441  scaffold-ma2
#scaffold-ma3.1                 No filtering        67476.7803  scaffold-ma3
#scaffold-ma3.2  Filtered Between Q1 and Q99        11729.2855  scaffold-ma3
#scaffold-ma4.1                 No filtering        27802.8584  scaffold-ma4
#scaffold-ma4.2  Filtered Between Q1 and Q99         4781.5913  scaffold-ma4
#scaffold-ma5.1                 No filtering        25488.4852  scaffold-ma5
#scaffold-ma5.2  Filtered Between Q1 and Q99         4337.6398  scaffold-ma5
#scaffold-ma6.1                 No filtering        10219.5624  scaffold-ma6
#scaffold-ma6.2  Filtered Between Q1 and Q99         1660.6428  scaffold-ma6
#scaffold-ma7.1                 No filtering        11648.0465  scaffold-ma7
#scaffold-ma7.2  Filtered Between Q1 and Q99         2046.6665  scaffold-ma7
#scaffold-mi1.1                 No filtering        11530.2201  scaffold-mi1
#scaffold-mi1.2  Filtered Between Q1 and Q99         2146.4434  scaffold-mi1
#scaffold-mi10.1                No filtering         1763.2866 scaffold-mi10
#scaffold-mi10.2 Filtered Between Q1 and Q99          347.9193 scaffold-mi10
#scaffold-mi2.1                 No filtering         5558.6500  scaffold-mi2
#scaffold-mi2.2  Filtered Between Q1 and Q99         1062.6035  scaffold-mi2
#scaffold-mi3.1                 No filtering        10265.8359  scaffold-mi3
#scaffold-mi3.2  Filtered Between Q1 and Q99         2034.2691  scaffold-mi3
#scaffold-mi4.1                 No filtering         6635.9961  scaffold-mi4
#scaffold-mi4.2  Filtered Between Q1 and Q99         1358.4981  scaffold-mi4
#scaffold-mi5.1                 No filtering         4409.7359  scaffold-mi5
#scaffold-mi5.2  Filtered Between Q1 and Q99          913.3781  scaffold-mi5
#scaffold-mi6.1                 No filtering         8105.1627  scaffold-mi6
#scaffold-mi6.2  Filtered Between Q1 and Q99         1614.4041  scaffold-mi6
#scaffold-mi7.1                 No filtering         5620.7104  scaffold-mi7
#scaffold-mi7.2  Filtered Between Q1 and Q99         1035.1056  scaffold-mi7
#scaffold-mi8.1                 No filtering         8260.7245  scaffold-mi8
#scaffold-mi8.2  Filtered Between Q1 and Q99         1601.3899  scaffold-mi8
#scaffold-mi9.1                 No filtering          711.0927  scaffold-mi9
#scaffold-mi9.2  Filtered Between Q1 and Q99          155.0010  scaffold-mi9
#scaffold-Z.1                   No filtering         3372.2934    scaffold-Z
#scaffold-Z.2    Filtered Between Q1 and Q99          604.3126    scaffold-Z

### NucZ

# Initialize an empty list to store results
summary_list <- list()

# Get unique chromosome values
chromosomes <- unique(delta.ssl$Chrom)

# Loop through each chromosome
for (chrom in chromosomes) {
  # Filter for the current chromosome
  chrom_data <- delta.ssl %>% filter(Chrom == chrom)
  
  # Filter out Delta.NucZ values greater than 2 or less than -2
  filtered_chrom_data <- chrom_data %>% filter(!(Delta.NucZ > 2 | Delta.NucZ < -2))
  
  # Create a summary table for the current chromosome
  summary_table <- data.frame(
    Filter = c("No filtering", "Filtered (Delta.NucZ > 2 or < -2)"),
    Sum_Delta_NucZ = c(
      sum(chrom_data$Delta.NucZ, na.rm = TRUE),          # No filtering
      sum(filtered_chrom_data$Delta.NucZ, na.rm = TRUE)   # Filtered
    )
  )
  
  # Add chromosome name to summary table
  summary_table$Chrom <- chrom
  
  # Append to the list
  summary_list[[chrom]] <- summary_table
}

# Combine all summary tables into one dataframe
summary_table_chroms_NucZ <- do.call(rbind, summary_list)

# Print summary table
write.csv(summary_table_chroms_NucZ, file = "Sum-DeltaSSL_NucZ_inside-pos2-neg2-threshold.csv", row.names = FALSE)
print(summary_table_chroms_NucZ)
#                                           Filter Sum_Delta_NucZ         Chrom
#scaffold-ma1.1                       No filtering   48438.302466  scaffold-ma1
#scaffold-ma1.2  Filtered (Delta.NucZ > 2 or < -2)    -755.937724  scaffold-ma1
#scaffold-ma2.1                       No filtering   32521.423661  scaffold-ma2
#scaffold-ma2.2  Filtered (Delta.NucZ > 2 or < -2)    -240.734899  scaffold-ma2
#scaffold-ma3.1                       No filtering   29628.209513  scaffold-ma3
#scaffold-ma3.2  Filtered (Delta.NucZ > 2 or < -2)    -630.515847  scaffold-ma3
#scaffold-ma4.1                       No filtering   17231.244512  scaffold-ma4
#scaffold-ma4.2  Filtered (Delta.NucZ > 2 or < -2)     -50.501928  scaffold-ma4
#scaffold-ma5.1                       No filtering    7774.620144  scaffold-ma5
#scaffold-ma5.2  Filtered (Delta.NucZ > 2 or < -2)    -155.874976  scaffold-ma5
#scaffold-ma6.1                       No filtering    3657.670178  scaffold-ma6
#scaffold-ma6.2  Filtered (Delta.NucZ > 2 or < -2)     -71.008622  scaffold-ma6
#scaffold-ma7.1                       No filtering    4860.795374  scaffold-ma7
#scaffold-ma7.2  Filtered (Delta.NucZ > 2 or < -2)    -178.267956  scaffold-ma7
#scaffold-mi1.1                       No filtering    6994.385300  scaffold-mi1
#scaffold-mi1.2  Filtered (Delta.NucZ > 2 or < -2)    -136.287950  scaffold-mi1
#scaffold-mi10.1                      No filtering     406.098516 scaffold-mi10
#scaffold-mi10.2 Filtered (Delta.NucZ > 2 or < -2)     -45.939154 scaffold-mi10
#scaffold-mi2.1                       No filtering    1606.468363  scaffold-mi2
#scaffold-mi2.2  Filtered (Delta.NucZ > 2 or < -2)      -0.757577  scaffold-mi2
#scaffold-mi3.1                       No filtering    6901.636248  scaffold-mi3
#scaffold-mi3.2  Filtered (Delta.NucZ > 2 or < -2)    -301.380852  scaffold-mi3
#scaffold-mi4.1                       No filtering    2367.294999  scaffold-mi4
#scaffold-mi4.2  Filtered (Delta.NucZ > 2 or < -2)     -52.281631  scaffold-mi4
#scaffold-mi5.1                       No filtering    2996.279910  scaffold-mi5
#scaffold-mi5.2  Filtered (Delta.NucZ > 2 or < -2)      -9.873380  scaffold-mi5
#scaffold-mi6.1                       No filtering    2946.557278  scaffold-mi6
#scaffold-mi6.2  Filtered (Delta.NucZ > 2 or < -2)     -73.796082  scaffold-mi6
#scaffold-mi7.1                       No filtering     352.992037  scaffold-mi7
#scaffold-mi7.2  Filtered (Delta.NucZ > 2 or < -2)       2.956347  scaffold-mi7
#scaffold-mi8.1                       No filtering    2381.093628  scaffold-mi8
#scaffold-mi8.2  Filtered (Delta.NucZ > 2 or < -2)    -110.660252  scaffold-mi8
#scaffold-mi9.1                       No filtering     180.317233  scaffold-mi9
#scaffold-mi9.2  Filtered (Delta.NucZ > 2 or < -2)       4.028713  scaffold-mi9
#scaffold-Z.1                         No filtering    -740.838078    scaffold-Z
#scaffold-Z.2    Filtered (Delta.NucZ > 2 or < -2)      50.379022    scaffold-Z

# Really odd that many of the filtered datasets (without values > 2 and < -2) give a negative number, indicating support for the alternative tree.
# Let's check the quantiles 

# Filter the data to include only values between -2 and 2
filtered_data <- delta.ssl %>% filter(Delta.NucZ >= -2 & Delta.NucZ <= 2)

# Calculate quantiles for the filtered data
quantiles <- quantile(filtered_data$Delta.NucZ, probs = c(0, 0.25, 0.5, 0.75, 1))

# Print quantiles
print(quantiles)
#      0%      25%      50%      75%     100% 
#-2.00000  0.00003  0.00009  0.00015  1.99990 

# Calculate percentage of data within the -2 to 2 range
percentage_in_range <- nrow(filtered_data) / nrow(delta.ssl) * 100

# Print percentage
print(paste("Percentage of data within the -2 to 2 range:", round(percentage_in_range, 2), "%"))
#[1] "Percentage of data within the -2 to 2 range: 99.95 %"

# Let's try the above code using the top and bottom 1% instead of threshold values 2 and -2 to see if it matches the other code above.
# Note, this code differs from the above code though in that we get the top and bottom 1% for all sites across all chromosomes, whereas above,
# we get the top and bottom 1% for each chromosome individually.

# Initialize an empty list to store results
summary_list <- list()

# Get unique chromosome values
chromosomes <- unique(delta.ssl$Chrom)

# Loop through each chromosome
for (chrom in chromosomes) {
  # Filter for the current chromosome
  chrom_data <- delta.ssl %>% filter(Chrom == chrom)
  
  # Filter out Delta.NucZ values between the 1st and 99th quantiles
  filtered_chrom_data <- chrom_data %>% filter(Delta.NucZ > quantile(Delta.NucZ, 0.01) & Delta.NucZ < quantile(Delta.NucZ, 0.99))
  
  # Create a summary table for the current chromosome
  summary_table <- data.frame(
    Filter = c("No filtering", "Filtered Between Q1 and Q99"),
    Sum_Delta_NucZ = c(
      sum(chrom_data$Delta.NucZ),                        # No filtering
      sum(filtered_chrom_data$Delta.NucZ)                 # Filtered
    )
  )
  
  # Add chromosome name to summary table
  summary_table$Chrom <- chrom
  
  # Append to the list
  summary_list[[chrom]] <- summary_table
}

# Combine all summary tables into one dataframe
summary_table_chroms_NucZ <- do.call(rbind, summary_list)

# Print summary table
write.csv(summary_table_chroms_NucZ, file = "Sum-DeltaSSL_NucZ_genome-wide-filtering.csv", row.names = FALSE)
print(summary_table_chroms_NucZ)
#                                     Filter Sum_Delta_NucZ         Chrom
#scaffold-ma1.1                 No filtering   48438.302466  scaffold-ma1
#scaffold-ma1.2  Filtered Between Q1 and Q99    8011.098110  scaffold-ma1
#scaffold-ma2.1                 No filtering   32521.423661  scaffold-ma2
#scaffold-ma2.2  Filtered Between Q1 and Q99    5361.404948  scaffold-ma2
#scaffold-ma3.1                 No filtering   29628.209513  scaffold-ma3
#scaffold-ma3.2  Filtered Between Q1 and Q99    4890.271156  scaffold-ma3
#scaffold-ma4.1                 No filtering   17231.244512  scaffold-ma4
#scaffold-ma4.2  Filtered Between Q1 and Q99    2770.426028  scaffold-ma4
#scaffold-ma5.1                 No filtering    7774.620144  scaffold-ma5
#scaffold-ma5.2  Filtered Between Q1 and Q99    1220.029826  scaffold-ma5
#scaffold-ma6.1                 No filtering    3657.670178  scaffold-ma6
#scaffold-ma6.2  Filtered Between Q1 and Q99     570.278206  scaffold-ma6
#scaffold-ma7.1                 No filtering    4860.795374  scaffold-ma7
#scaffold-ma7.2  Filtered Between Q1 and Q99     845.415866  scaffold-ma7
#scaffold-mi1.1                 No filtering    6994.385300  scaffold-mi1
#scaffold-mi1.2  Filtered Between Q1 and Q99    1281.741967  scaffold-mi1
#scaffold-mi10.1                No filtering     406.098516 scaffold-mi10
#scaffold-mi10.2 Filtered Between Q1 and Q99      68.683066 scaffold-mi10
#scaffold-mi2.1                 No filtering    1606.468363  scaffold-mi2
#scaffold-mi2.2  Filtered Between Q1 and Q99     274.093890  scaffold-mi2
#scaffold-mi3.1                 No filtering    6901.636248  scaffold-mi3
#scaffold-mi3.2  Filtered Between Q1 and Q99    1339.428211  scaffold-mi3
#scaffold-mi4.1                 No filtering    2367.294999  scaffold-mi4
#scaffold-mi4.2  Filtered Between Q1 and Q99     415.039218  scaffold-mi4
#scaffold-mi5.1                 No filtering    2996.279910  scaffold-mi5
#scaffold-mi5.2  Filtered Between Q1 and Q99     576.864630  scaffold-mi5
#scaffold-mi6.1                 No filtering    2946.557278  scaffold-mi6
#scaffold-mi6.2  Filtered Between Q1 and Q99     578.329433  scaffold-mi6
#scaffold-mi7.1                 No filtering     352.992037  scaffold-mi7
#scaffold-mi7.2  Filtered Between Q1 and Q99      -5.249084  scaffold-mi7
#scaffold-mi8.1                 No filtering    2381.093628  scaffold-mi8
#scaffold-mi8.2  Filtered Between Q1 and Q99     433.881874  scaffold-mi8
#scaffold-mi9.1                 No filtering     180.317233  scaffold-mi9
#scaffold-mi9.2  Filtered Between Q1 and Q99      25.254893  scaffold-mi9
#scaffold-Z.1                   No filtering    -740.838078    scaffold-Z
#scaffold-Z.2    Filtered Between Q1 and Q99    -144.101006    scaffold-Z


#================== Ridge plot for densities of Delta SSLs

# make a ridge plot for densities of Delta SSLs
library(ggridges)

# pdf("Density-plots_all-chrom_DeltaSSL_NucMito.pdf")
ggplot(delta.ssl, aes(x = Delta.NucMito, y = Chrom)) +
    geom_density_ridges()
# dev.off()

# SSLs be crazy. Cannot plot these reasonable like this, so let's take the top 1%
# make a new dataframe for each set of Delta SSLs

# top 1% quantile of the NucMito Delta SSLs (note: Delta.NucZ column now is pointless)
delta.ssl.NucMito.T1Q <- delta.ssl %>%
  filter(Delta.NucMito > quantile(Delta.NucMito, 0.99))

# top 1% quantile of the NucZ Delta SSLs (note: Delta.NucMito column now is pointless)
delta.ssl.NucZ.T1Q <- delta.ssl %>%
  filter(Delta.NucZ > quantile(Delta.NucZ, 0.99))

# bottom 1% quantile of the NucMito Delta SSLs (note: Delta.NucZ column now is pointless)
delta.ssl.NucMito.B1Q <- delta.ssl %>%
  filter(Delta.NucMito < quantile(Delta.NucMito, 0.01))

# bottom 1% quantile of the NucZ Delta SSLs (note: Delta.NucMito column now is pointless)
delta.ssl.NucZ.B1Q <- delta.ssl %>%
  filter(Delta.NucZ < quantile(Delta.NucZ, 0.01))

# can also get top and bottom 1% in one table
delta.ssl.NucMito.TB1Q <- delta.ssl %>%
  filter(Delta.NucMito > quantile(Delta.NucMito, 0.99) | Delta.NucMito < quantile(Delta.NucMito, 0.01))

delta.ssl.NucZ.TB1Q <- delta.ssl %>%
  filter(Delta.NucZ > quantile(Delta.NucZ, 0.99) | Delta.NucZ < quantile(Delta.NucZ, 0.01))

# check
head(delta.ssl.NucMito.T1Q)
head(delta.ssl.NucZ.T1Q)


# get the top 1% of the top 1% of the outliers of the top and bottom 1%
outliers <- delta.ssl.NucMito.TB1Q %>%
  filter(Delta.NucMito > quantile(Delta.NucMito, 0.99) | Delta.NucMito < quantile(Delta.NucMito, 0.01))

# let's get all delta SSLs below -2 and above 2 
outliers.nm.mis <- subset(delta.ssl.NucMito.TB1Q, Delta.NucMito < -2 | Delta.NucMito > 2)

outliers.z.mis <- subset(delta.ssl.NucZ.TB1Q, Delta.NucZ < -2 | Delta.NucZ > 2)

library(ggridges)

head(delta.ssl.NucMito.TB1Q)


# plot NucMito Delta SSLs with the top 1% outliers 
# pdf("Density-plots_all-chrom_top-bottom-1-percent-DeltaSSL_NucMito_top-bottom-1-percent-outlier-points.pdf")
ggplot(delta.ssl.NucMito.TB1Q, aes(x = Delta.NucMito, y = Chrom)) +
  geom_density_ridges() +
  geom_point(data = outliers, aes(x = Delta.NucMito, y = Chrom), 
             color = "red", size = 2, shape = 16) +  # Customize point color, size, shape
  theme_minimal()
# dev.off()

head(outliers.nm.mis)

# plot NucMito Delta SSLs with all outliers that are < -2 and >2
# pdf("Density-plots_all-chrom_outliers--2+2-threshold.pdf")
ggplot(delta.ssl.NucMito.TB1Q, aes(x = Delta.NucMito, y = Chrom)) +
  geom_density_ridges() +
  geom_point(data = outliers.nm.mis, aes(x = Delta.NucMito, y = Chrom), 
             color = "red", size = 2, shape = 16) +  # Customize point color, size, shape
  theme_minimal()
# dev.off()

# let's color by value
# Remove the Delta.NucZ column from outliers.nm.mis
outliers.nm.mis <- outliers.nm.mis[, !names(outliers.nm.mis) %in% "Delta.NucZ"]

# Define a function to assign colors based on Delta.NucMito values
assign_color <- function(value) {
  if (value < -2) {
    return("red")
  } else if (value > 2) {
    return("blue")
  } else {
    return("grey")
  }
}

# Apply the function to create a new Color column
outliers.nm.mis$Color <- sapply(outliers.nm.mis$Delta.NucMito, assign_color)

# Plot the density plot with color-coded points using a gradient color scale
# pdf("Density-plots_all-chrom_outliers--2+2-threshold_color-gradient.pdf")
ggplot(delta.ssl.NucMito.TB1Q, aes(x = Delta.NucMito, y = Chrom)) +
  geom_density_ridges() +
  geom_point(data = outliers.nm.mis, aes(x = Delta.NucMito, y = Chrom, color = Delta.NucMito), 
             size = 2, shape = 16) +  # Customize point size, shape
  scale_color_gradient2(low = "red", mid = "grey", high = "blue", 
                        midpoint = 0, limits = c(min(outliers.nm.mis$Delta.NucMito), max(outliers.nm.mis$Delta.NucMito))) +
  theme_minimal()
# dev.off()

# we won't plot it, but here is the same code to create a dataframe with color gradient for NucZ
# let's color by value

# Remove the Delta.NucMito column from outliers.z.mis
outliers.z.mis <- outliers.z.mis[, !names(outliers.z.mis) %in% "Delta.NucMito"]

# Define a function to assign colors based on Delta.NucZ values
assign_color <- function(value) {
  if (value < -2) {
    return("red")
  } else if (value > 2) {
    return("blue")
  } else {
    return("grey")
  }
}

# Apply the function to create a new Color column
outliers.z.mis$Color <- sapply(outliers.z.mis$Delta.NucZ, assign_color)

# Okay. Now let's tre tp see WHERE these points are on the chromosomes. Would be interesting if more extreme Delta SSLs cluster in certain parts.

# first we can try to just plot where all of our points come from
# pdf("Distribution-all-deltaSSLs.pdf")
ggplot(delta.ssl, aes(x = pos, y = Chrom)) +
  geom_density_ridges()
# dev.off()

# plot with outliers (both top and bottom 1%)
# pdf("Distribution-all-deltaSSLs_color-gradient-outliers.pdf")
ggplot(delta.ssl, aes(x = pos, y = Chrom)) +
  geom_density_ridges() +
  geom_point(data = outliers.nm.mis, aes(x = pos, y = Chrom, color = Delta.NucMito), size = 0.2) +  # Color based on Delta.NucMito
  scale_color_gradient2(low = "red", mid = "grey", high = "blue", 
                        midpoint = 0, limits = c(min(outliers.nm.mis$Delta.NucMito), max(outliers.nm.mis$Delta.NucMito))) +
  theme_minimal()
# dev.off()

# the above plot is okay but it is a bit hard to see.
# let's make a filter
# Filter outliers for random 1000 points for each chromosome
outliers.new <- delta.ssl %>%
  filter((Delta.NucMito > 2 | Delta.NucMito < -2) &
         (Delta.NucZ > 2 | Delta.NucZ < -2))

head(outliers.new)

filtered_outliers <- outliers.new %>%
  group_by(Chrom) %>%
  slice_sample(n = 1000, replace = FALSE) %>%
  ungroup()

# pdf("Distribution-all-deltaSSLs_color-gradient-outliers_random1000.pdf")
ggplot(delta.ssl, aes(x = pos, y = Chrom)) +
  geom_density_ridges() +
  geom_point(data = filtered_outliers, aes(x = pos, y = Chrom, color = Delta.NucMito), size = 0.2) +  # Color based on Delta.NucMito
  scale_color_gradient2(low = "red", mid = "grey", high = "blue", 
                        midpoint = 0, limits = c(min(filtered_outliers$Delta.NucMito), max(filtered_outliers$Delta.NucMito))) +
  theme_minimal()
# dev.off()

# Filter outliers.new for Delta.NucMito > X and < -Y
outliers.new.filtered <- outliers.new[outliers.new$Delta.NucMito > 7 | outliers.new$Delta.NucMito < -7, ]

# Plot to see where outliers are on chromosomes
# pdf("NucMito_DeltaSSLs_7-to-neg7.pdf")
ggplot(delta.ssl, aes(x = pos, y = Chrom)) +
  geom_density_ridges() +
  geom_point(data = outliers.new.filtered, aes(x = pos, y = Chrom, color = Delta.NucMito), size = 0.5) +  # Color based on Delta.NucMito
  scale_color_gradient2(low = "red", mid = "grey", high = "blue", 
                        midpoint = 0, limits = c(min(outliers.new.filtered$Delta.NucMito), max(outliers.new.filtered$Delta.NucMito))) +
  theme_minimal()
# dev.off()

# can try with the NucZ
# Filter outliers.new for Delta.NucMito > X and < -Y
outliers.new.filtered <- outliers.new[outliers.new$Delta.NucZ > 7 | outliers.new$Delta.NucZ < -7, ]

# Plot to see where outliers are on chromosomes
# pdf("NucZ_DeltaSSLs_7-to-neg7.pdf")
ggplot(delta.ssl, aes(x = pos, y = Chrom)) +
  geom_density_ridges() +
  geom_point(data = outliers.new.filtered, aes(x = pos, y = Chrom, color = Delta.NucZ), size = 0.5) +  # Color based on Delta.NucMito
  scale_color_gradient2(low = "red", mid = "grey", high = "blue", 
                        midpoint = 0, limits = c(min(outliers.new.filtered$Delta.NucZ), max(outliers.new.filtered$Delta.NucZ))) +
  theme_minimal()
# dev.off()

# let's see if there is overlap of extreme Delta SSL sites overlapping with genes or mito-nuc genes

# bring in a bed file of gene names (obtained from a gtf and using bedtools gtf2bed)
genes <- read.delim("./converted.gene.names.bed", header = FALSE)
colnames(genes) <- c("chrom", "start", "end", "gene")
head(genes)

# bring in mito-nuc genes
oxphos <- read.delim("./OxPhos.genes.only.full.ordered.bed", header = FALSE)
oxphos <- oxphos %>%
    select(V1, V2, V3, V7)
colnames(oxphos) <- c("Chrom", "start", "end", "gene")
head(oxphos)

# Function to check if 'pos' in outliers.new is between start and end for each row in oxphos
matched_outliers <- map_dfr(1:nrow(oxphos), function(i) {
  oxphos_row <- oxphos[i, ]  # Get each row of oxphos
  
  # Filter outliers.new where Chrom matches and pos is between start and end
  outliers.new %>%
    filter(Chrom == oxphos_row$Chrom, 
           pos >= oxphos_row$start, 
           pos <= oxphos_row$end) %>%
    mutate(gene = oxphos_row$gene)  # Add the gene name to matched rows
})

# View the resulting dataframe
matched_outliers

#          Chrom       pos   nuc.ssl  mito.ssl     Z.ssl Delta.NucMito Delta.NucZ     gene
#1  scaffold-ma1 102082872 -14.21480 -10.92900 -16.37670      -3.28580    2.16190   TCIRG1
#2  scaffold-ma1 102095969 -24.15380 -19.23560 -18.86360      -4.91820   -5.29020   TCIRG1
#3  scaffold-ma1 102096557 -17.58280 -11.50190 -11.13330      -6.08090   -6.44950   TCIRG1
#4  scaffold-ma1 102097309 -26.51830 -21.52780 -21.14240      -4.99050   -5.37590   TCIRG1
#5  scaffold-ma1 102097310 -14.84010  -9.99250  -9.62867      -4.84760   -5.21143   TCIRG1
#6  scaffold-ma1 102097744 -15.06420 -10.05410  -9.68642      -5.01010   -5.37778   TCIRG1
#7  scaffold-ma1 102097807 -14.94710 -10.00000  -9.63543      -4.94710   -5.31167   TCIRG1
#8  scaffold-ma1 181085140 -25.58970 -20.91360 -20.41570      -4.67610   -5.17400 ATP6V1C2
#9  scaffold-mi1   9752726 -24.42230 -30.86500 -31.63300       6.44270    7.21070 ATP6V1B2
#10 scaffold-mi1   9752734 -34.03980 -40.05000 -39.98640       6.01020    5.94660 ATP6V1B2
#11 scaffold-mi1   9752744 -39.36980 -49.44870 -45.02090      10.07890    5.65110 ATP6V1B2
#12 scaffold-mi1   9752791 -26.28890 -32.44080 -32.25840       6.15190    5.96950 ATP6V1B2
#13 scaffold-mi1   9752792 -21.43630 -26.22200 -26.19850       4.78570    4.76220 ATP6V1B2
#14 scaffold-mi1   9754036 -17.51460 -11.43390 -11.01800      -6.08070   -6.49660 ATP6V1B2
#15 scaffold-mi1   9754897 -21.86140 -27.90820 -27.45340       6.04680    5.59200 ATP6V1B2
#16 scaffold-mi1   9756782 -18.98620 -14.44880 -14.03710      -4.53740   -4.94910 ATP6V1B2
#17 scaffold-mi1   9756796 -30.19450 -24.49990 -24.08670      -5.69460   -6.10780 ATP6V1B2
#18 scaffold-mi1   9761398 -40.47630 -34.54940 -34.13430      -5.92690   -6.34200 ATP6V1B2
#19 scaffold-mi1   9770066 -21.21070 -16.97780 -16.78140      -4.23290   -4.42930 ATP6V1B2
#20 scaffold-mi1   9770870  -9.33300 -13.80160 -14.01520       4.46860    4.68220 ATP6V1B2
#21 scaffold-mi1   9771334 -26.70370 -31.14260 -31.09890       4.43890    4.39520 ATP6V1B2
#22 scaffold-mi1   9771947  -9.30196 -13.92920 -14.22530       4.62724    4.92334 ATP6V1B2
#23 scaffold-mi1   9773255 -21.05540 -25.46160 -26.03090       4.40620    4.97550 ATP6V1B2
#24 scaffold-ma2  87801454 -26.74260 -21.92100 -21.67180      -4.82160   -5.07080    COX10
#25 scaffold-ma2  87900200 -19.50390 -16.44360 -15.67160      -3.06030   -3.83230    COX10
#26 scaffold-ma2  94611112 -26.08380 -21.63340 -21.27040      -4.45040   -4.81340   ATP5PD
#27 scaffold-ma2  94611428 -19.56140 -16.04250 -15.67240      -3.51890   -3.88900   ATP5PD
#28 scaffold-ma2  94611647 -14.75750  -9.95033  -9.57807      -4.80717   -5.17943   ATP5PD
#29 scaffold-ma2  94613385 -26.47760 -19.73160 -19.90460      -6.74600   -6.57300   ATP5PD
#30 scaffold-ma2 113736721  -9.75716 -14.50240 -14.95140       4.74524    5.19424    COX11
#31 scaffold-ma3  31741586  -9.99011 -14.77960 -15.39580       4.78949    5.40569  ATP6V1H
#32 scaffold-ma3  31747525  -9.98287 -14.67510 -14.99080       4.69223    5.00793  ATP6V1H
#33 scaffold-ma3  31749689 -10.04430 -14.73660 -15.05230       4.69230    5.00800  ATP6V1H
#34 scaffold-ma3  31749702 -19.08710 -25.04730 -25.54450       5.96020    6.45740  ATP6V1H
#35 scaffold-ma3 134896901 -25.47510 -19.23360 -18.48820      -6.24150   -6.98690  ATP6V0B
#36 scaffold-ma3 134896957 -20.33530 -16.28870 -15.32150      -4.04660   -5.01380  ATP6V0B
#37 scaffold-ma3 134897056 -25.39470 -19.43190 -18.73380      -5.96280   -6.66090  ATP6V0B
#38 scaffold-ma3 134897058 -20.88870 -16.07280 -15.53510      -4.81590   -5.35360  ATP6V0B
#39 scaffold-ma3 134897323 -19.94770 -16.57320 -15.68370      -3.37450   -4.26400  ATP6V0B
#40 scaffold-ma3 134897535 -31.72000 -26.41360 -25.82110      -5.30640   -5.89890  ATP6V0B
#41 scaffold-ma4  62158535 -31.81980 -25.38000 -24.98730      -6.43980   -6.83250   ATP5PO
#42 scaffold-ma4  62158742 -18.33040 -11.81050 -11.42350      -6.51990   -6.90690   ATP5PO
#43 scaffold-ma4  62158798 -24.72930 -20.98320 -20.59110      -3.74610   -4.13820   ATP5PO
#44 scaffold-ma5  12201321 -17.54200 -22.24910 -22.06180       4.70710    4.51980     PPA1
#45 scaffold-ma5  12201951 -26.91910 -33.28790 -33.53380       6.36880    6.61470     PPA1
#46 scaffold-ma5  12202423 -10.04510 -14.94860 -15.19140       4.90350    5.14630     PPA1
#47 scaffold-ma5  12203940 -16.07640 -21.03720 -20.94390       4.96080    4.86750     PPA1
#48 scaffold-ma5  12205948 -15.07180 -19.81400 -20.01220       4.74220    4.94040     PPA1
#49 scaffold-ma5  12206870 -34.07370 -40.42400 -41.31160       6.35030    7.23790     PPA1
#50 scaffold-ma5  12212114 -15.59740 -20.38760 -20.74630       4.79020    5.14890     PPA1
#51 scaffold-ma5  12214213 -21.81780 -26.71290 -26.77930       4.89510    4.96150     PPA1
#52 scaffold-ma5  12214251 -22.30270 -27.31160 -27.06490       5.00890    4.76220     PPA1
#53 scaffold-ma5  12214267 -15.55570 -20.27650 -20.46870       4.72080    4.91300     PPA1
#54 scaffold-ma5  12214270 -10.03780 -14.76270 -14.94620       4.72490    4.90840     PPA1
#55 scaffold-ma5  12214929 -19.02060 -25.23900 -24.90930       6.21840    5.88870     PPA1
#56 scaffold-ma5  49697740 -18.00380 -11.61960 -11.23630      -6.38420   -6.76750    COX15
#57 scaffold-ma5  49698684 -18.31890 -11.57850 -11.21040      -6.74040   -7.10850    COX15
#58 scaffold-ma6  57151417 -10.31430 -15.05630 -15.41660       4.74200    5.10230 ATP6V0A4
#59 scaffold-ma6  57153108 -16.64860 -21.24740 -21.52700       4.59880    4.87840 ATP6V0A4
#60 scaffold-ma7  14601799 -20.46680 -15.78920 -15.42670      -4.67760   -5.04010     PPA2
#61 scaffold-ma7  14603463 -25.40080 -18.55750 -18.32340      -6.84330   -7.07740     PPA2
#62 scaffold-ma7  14604505 -20.53390 -15.65880 -15.65240      -4.87510   -4.88150     PPA2
#63 scaffold-ma7  14604621 -21.03830 -15.81170 -15.95550      -5.22660   -5.08280     PPA2
#64 scaffold-ma7  14605175 -20.86480 -15.68380 -15.64210      -5.18100   -5.22270     PPA2
#65 scaffold-mi8    943147 -18.41890 -24.15020 -23.95560       5.73130    5.53670 ATP6V0D1
#66 scaffold-mi8    943205 -15.42140 -19.68200 -19.60660       4.26060    4.18520 ATP6V0D1
#67 scaffold-mi8    943447 -15.03640 -19.16250 -19.77290       4.12610    4.73650 ATP6V0D1
#68 scaffold-mi8    943494 -21.23700 -25.26820 -25.17870       4.03120    3.94170 ATP6V0D1
#69 scaffold-mi8    944084 -19.50870 -25.68900 -25.54960       6.18030    6.04090 ATP6V0D1
#70 scaffold-mi8    944122 -21.51370 -25.75840 -26.15530       4.24470    4.64160 ATP6V0D1
#71 scaffold-mi8    944600 -25.20310 -31.22550 -30.96420       6.02240    5.76110 ATP6V0D1
#72 scaffold-mi8    953439 -14.95240 -19.21770 -19.59420       4.26530    4.64180 ATP6V0D1
#73 scaffold-mi8    954019 -33.13330 -38.88240 -38.68880       5.74910    5.55550 ATP6V0D1
#74 scaffold-mi8   8661451 -35.99710 -31.52730 -31.50720      -4.46980   -4.48990 ATP6V0A2
#75 scaffold-mi8   8661744 -48.72610 -41.61730 -41.69710      -7.10880   -7.02900 ATP6V0A2
#76 scaffold-mi8   8661954 -31.11200 -26.17770 -26.23480      -4.93430   -4.87720 ATP6V0A2
#77 scaffold-mi8   8661973 -31.22120 -26.39180 -26.45190      -4.82940   -4.76930 ATP6V0A2
#78 scaffold-mi8   8662980 -36.19270 -32.77270 -32.76430      -3.42000   -3.42840 ATP6V0A2

# Let's do it again but instead of using Detla SSL values > 2 and < -2 , we will just take the top and bottom 1%
head(delta.ssl.NucMito.TB1Q)

# Function to check if 'pos' in outliers.new is between start and end for each row in oxphos
matched_outliers.TB1Q <- map_dfr(1:nrow(oxphos), function(i) {
  oxphos_row <- oxphos[i, ]  # Get each row of oxphos
  
  # Filter outliers.new where Chrom matches and pos is between start and end
  delta.ssl.NucMito.TB1Q %>%
    filter(Chrom == oxphos_row$Chrom, 
           pos >= oxphos_row$start, 
           pos <= oxphos_row$end) %>%
    mutate(gene = oxphos_row$gene)  # Add the gene name to matched rows
})

# View the resulting dataframe
matched_outliers.TB1Q
write.csv(matched_outliers.TB1Q, "DeltaSSLs_TB1Q_in-OxPhos-genes.csv")

##############################
#
# Histograms
#
##############################

# histogram of distribution of where the top 1% delta SSLs on a log10 y axis. Maybe not standard but only way to look at this for now
pdf("Histogram-ma3-NucMito-DeltaSSL_log10Y.pdf")
ggplot(delta.ssl %>% filter(Chrom == "scaffold-ma3"), aes(x = Delta.NucMito)) +
  geom_histogram() +
  scale_y_log10() + 
  labs(y = "log10(count)") +
  ggtitle("Histogram of NucMito Delta SSLs of ma3")
dev.off()


# same plot without log10 the Y axis
pdf("Histogram-ma3-NucMito-DeltaSSL.pdf")
ggplot(delta.ssl.NucMito.TB1Q %>% filter(Chrom == "scaffold-ma3"), aes(x = Delta.NucMito)) +
  geom_histogram() +
  ggtitle("Histogram of NucMito Delta SSLs of ma3")
dev.off()
