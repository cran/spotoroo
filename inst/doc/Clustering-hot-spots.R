## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup--------------------------------------------------------------------
library(spotoroo)

## -----------------------------------------------------------------------------
str(hotspots)

## -----------------------------------------------------------------------------
library(ggplot2)

if (requireNamespace("sf", quietly = TRUE)) {
    plot_vic_map() +
    geom_point(data = hotspots, aes(lon, lat), col = "red")
}

## ----echo = FALSE-------------------------------------------------------------
tab <- data.frame(Arguments = c("`hotspots`", "`lon`", "`lat`", "`obsTime`"),
                  Description = c("the object that contains the dataset",
                                  "the name of the longitude column",
                                  "the name of the latitude column",
                                  "the name of the observed time column"))
knitr::kable(tab)

## ----echo = FALSE-------------------------------------------------------------
tab <- data.frame(Arguments = c("`activeTime`", "`adjDist`", "`minPts`", "`minTime`"),
                  Description = c("the time tolerance",
                                  "the distance tolerance",
                                  "the minimum number of hot spots",
                                  "the minimum length of time"))
knitr::kable(tab)

## ----echo = FALSE-------------------------------------------------------------
tab <- data.frame(Arguments = c("`ignitionCenter`"),
                  Description = c("method of the calculation of the ignition points"))
knitr::kable(tab)

## ----echo = FALSE-------------------------------------------------------------
tab <- data.frame(Arguments = c("`timeUnit`", "`timeStep`"),
                  Description = c("the unit of time", "the number of time unit one time index contains"))
knitr::kable(tab)

## -----------------------------------------------------------------------------
result <- hotspot_cluster(hotspots = hotspots,
                          lon = "lon",
                          lat = "lat",
                          obsTime = "obsTime",
                          activeTime = 24,
                          adjDist = 3000,
                          minPts = 4,
                          minTime = 3,
                          ignitionCenter = "mean",
                          timeUnit = "h",
                          timeStep = 1)

## -----------------------------------------------------------------------------
result

## -----------------------------------------------------------------------------
head(result$hotspots, 2)

head(result$ignition, 2)

## ----eval = FALSE-------------------------------------------------------------
#  # Merge the `hotspots` and `ignition` dataset
#  merged_result <- extract_fire(result, cluster = "all", noise = TRUE)

## ----eval = FALSE-------------------------------------------------------------
#  # Merge the `hotspots` and `ignition` dataset
#  # Select cluster 2 and 3 and filter out noise
#  cluster_2_and_3 <- extract_fire(result, cluster = c(2, 3), noise = FALSE)

## ----echo = FALSE-------------------------------------------------------------
tab <- expand.grid(activeTime = seq(6, 48, 6),
                   adjDist = seq(500, 4000, 500))



tab$noise_prop <- c(0.320560748, 0.282242991, 0.235514019, 0.133644860,
                    0.129906542, 0.129906542, 0.126168224, 0.118691589,
                    0.320560748, 0.282242991, 0.235514019, 0.133644860,
                    0.129906542, 0.129906542, 0.126168224, 0.118691589,
                    0.320560748, 0.282242991, 0.235514019, 0.133644860,
                    0.129906542, 0.129906542, 0.126168224, 0.118691589,
                    0.154205607, 0.134579439, 0.109345794, 0.026168224,
                    0.026168224, 0.026168224, 0.026168224, 0.021495327,
                    0.086915888, 0.075700935, 0.055140187, 0.011214953,
                    0.011214953, 0.011214953, 0.011214953, 0.011214953,
                    0.081308411, 0.070093458, 0.049532710, 0.009345794,
                    0.009345794, 0.009345794, 0.009345794, 0.009345794,
                    0.081308411, 0.070093458, 0.049532710, 0.009345794,
                    0.009345794, 0.009345794, 0.009345794, 0.009345794,
                    0.079439252, 0.061682243, 0.049532710, 0.009345794,
                    0.009345794, 0.009345794, 0.009345794, 0.009345794)

## -----------------------------------------------------------------------------
ggplot(tab) +
  geom_line(aes(adjDist, noise_prop, color = as.factor(activeTime))) +
  ylab("Noise Propotion") +
  labs(col = "activeTime") +
  theme_minimal() +
  scale_x_continuous(breaks = seq(500, 4000, 500))

## -----------------------------------------------------------------------------
ggplot(tab) +
  geom_line(aes(activeTime, noise_prop, color = as.factor(adjDist))) +
  ylab("Noise Propotion") +
  labs(col = "adjDist") +
  theme_minimal() +
  scale_x_continuous(breaks = seq(6, 48, 6))

## -----------------------------------------------------------------------------
summary_spotoroo(result)

## ----eval = FALSE-------------------------------------------------------------
#  summary_spotoroo(result, cluster = c(1, 3, 4))

## ----eval = FALSE-------------------------------------------------------------
#  summary(result)
#  summary(result, cluster = c(1, 3, 4))

## -----------------------------------------------------------------------------
plot_spotoroo(result, type = "def")

## -----------------------------------------------------------------------------
plot_spotoroo(result, type = "timeline")

## -----------------------------------------------------------------------------
plot_spotoroo(result, type = "mov", step = 6)

## -----------------------------------------------------------------------------
if (requireNamespace("sf", quietly = TRUE)) {
  plot_spotoroo(result, bg = plot_vic_map())
}

## -----------------------------------------------------------------------------
if (requireNamespace("sf", quietly = TRUE)) {
  plot_spotoroo(result, type = "mov", bg = plot_vic_map(), step = 6)
}

## ----eval = FALSE-------------------------------------------------------------
#  plot(result)
#  plot(result, type = "timeline")
#  plot(result, type = "mov")
#  plot(result, bg = plot_vic_map())
#  plot(result, type = "mov", bg = plot_vic_map())

