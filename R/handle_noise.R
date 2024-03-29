#' Handling noise in the clustering results
#'
#' This function finds noise from the clustering results and label it with
#' `-1`.
#'
#' For more details about the clustering algorithm and the arguments
#' `minPts` and `minTime`, please check the documentation
#' of [hotspot_cluster()].
#' This function performs the **step 4** of the clustering algorithm. It uses a
#' given threshold (minimum number of points and minimum length of time) to
#' find noise and label it with `-1`.
#'
#' @param global_membership Integer. A vector of membership labels.
#' @param timeID Integer. A vector of time indexes.
#' @param minPts Numeric (>0). Minimum number of hot spots in a cluster.
#' @param minTime Numeric (>=0). Minimum length of time of a cluster.
#'                               Unit is time index.
#' @return Integer. A vector of membership labels.
#' @examples
#'
#' # Define membership labels and timeID for 10 observations
#' global_membership <- c(1,1,1,2,2,2,2,2,2,3,3,3,3,3,3)
#' timeID <- c(1,2,3,2,3,3,4,5,6,3,3,3,3,3,3)
#'
#' # Handle noise with different values of minPts and minTime
#' handle_noise(global_membership, timeID, 4, 0)
#' handle_noise(global_membership, timeID, 4, 1)
#' handle_noise(global_membership, timeID, 3, 3)
#'
#' @export
handle_noise <- function(global_membership, timeID, minPts, minTime) {

  cli::cli_div(theme = list(span.vrb = list(color = "yellow",
                                            `font-weight` = "bold"),
                            span.unit = list(color = "magenta"),
                            .val = list(digits = 3),
                            span.side = list(color = "grey")))
  cli::cli_h3("{.field minPts} = {.val {minPts}} {.unit hot spot{?s}} | {.field minTime} = {.val {minTime}} {.unit time index{?es}}")

  # pass CMD CHECK variables
  n <- timelen <- NULL
  `%>%` <- dplyr::`%>%`

  # count every membership
  membership_count <- data.frame(id = 1:length(global_membership),
                                 timeID,
                                 global_membership) %>%
    dplyr::group_by(global_membership) %>%
    dplyr::summarise(n = dplyr::n(), timelen = max(timeID) - min(timeID))


  # filter noise
  noise_clusters <- dplyr::filter(membership_count,
                                  n < minPts | timelen < minTime)
  noise_clusters <- noise_clusters[['global_membership']]
  indexes <- global_membership %in% noise_clusters
  global_membership[indexes] <- -1

  if (all_noise_bool(global_membership)) {
    cli::cli_alert_warning("All observations are noise!!!")
  } else {
    global_membership[!indexes] <-
      adjust_membership(global_membership[!indexes], 0)
  }

  cli::cli_alert_success("{.vrb Handle} {.field noise}")
  cli::cli_alert_info("{.val {max(c(global_membership, 0))}} cluster{?s} {.side left}")
  cli::cli_alert_info("noise {.side proportion} : {.val {mean(global_membership == -1)*100}} %")
  cli::cli_end()

  return(global_membership)
}

