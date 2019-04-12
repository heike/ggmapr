

#' ggplot2 stat for creating a sample of jittered points in a polygon
#'
#' @export
#' @examples
#' data(division)
#' data(crimes)
#' library(dplyr)
#' crime.map <- left_join(division, crimes, by=c("NAME"="State"))
#' ggplot(data = crime.map, aes(x = long, y = lat)) +
#'   geom_polygon(aes(group = group), fill="grey90", colour="white", size = 0.5) +
#'   stat_polygon_jitter(aes(long = long, lat = lat, group = STATEFP,
#'                           mapgroup = group, n = Population/200000)) +
#'   ggthemes::theme_map()
#'
#'
StatPolygon_jitter <- ggproto("StatPolygon_jitter", Stat,
  required_aes = c("long", "lat","n", "group", "mapgroup"),

  setup_data = function(data, params) {
    data$mapgroup <- factor(data$mapgroup)

    data
  },
  compute_group = function(data, scales) {
 #   browser()
    res <- rename(data, Group = group, group = mapgroup)
    sample <- map_unif(res, round(mean(data$n, na.rm=TRUE),0))
    rename(sample, mapgroup = group, x = long, y = lat)
  }

)

#' ggplot2 stat for creating a sample of jittered points in a polygon
#'
#' @inheritParams ggplot2::stat_identity
#' @param na.rm binary, remove missing values? Defaults to FALSE
#' @section Computed variables:
#' \describe{
#' \item{x}{location of bottom left corner}
#' \item{y}{location of bottom right corner}
#' }
#' @export
stat_polygon_jitter <- function(mapping = NULL, data = NULL, geom = "point",
                       position = "identity", na.rm = FALSE, show.legend = NA,
                       inherit.aes = TRUE, ...) {
  ggplot2::layer(
    stat = StatPolygon_jitter, data = data, mapping = mapping, geom = geom,
    position = position, show.legend = show.legend, inherit.aes = inherit.aes,
    params = list(na.rm = na.rm, ...)
  )
}


#' Find a uniform sample of points for one region of a map
#'
#' place uniform point sample into the region `region` of a map.
#' This function is used in  `stat_polygon_jitter`.
#' @param map data frame with long, lat and group variable
#' @param n number of locations to sample
#' @importFrom dplyr select sample_n
#' @importFrom sp point.in.polygon
#' @importFrom purrr map
#' @importFrom tidyr nest unnest
#' @export
#' @examples
#' library(dplyr)
#' library(ggplot2)
#' data(inset)
#' df <- inset %>% filter(DIVISION == "9") %>% map_unif(1000)
#' df <- inset %>% filter(NAME == "Iowa") %>% map_unif(10)
#' df <- inset %>% map_unif(5000)
#' inset %>% ggplot(aes(x = long, y = lat)) +
#'   geom_path(aes(group = group)) +
#'   geom_point(data = df, colour = "red", size = 0.5)
#'
#' data(crimes)
#' population <- crimes %>% filter(Year == max(Year))
#' population$Abb <- as.character(population$Abb)
#' population <- population %>% mutate(
#'   Abb = replace(Abb, Abb=="D.C.", "DC")
#' )
#' popmap <- left_join(inset, population[,c("Abb", "Population")],
#'                     by=c("STUSPS"="Abb"))
#' poplist <- popmap %>% tidyr::nest(-NAME)
#' poplist$sample <- poplist$data %>%
#'   purrr::map(.f = function(d) d %>% map_unif(50))
#' poplist$sample <- poplist$data %>%
#'   purrr::map(.f = function(d) d %>% map_unif(round(d$Population[1]/50000)))
#' df <- poplist %>% select(-data) %>% tidyr::unnest()
#' inset %>% ggplot(aes(x = long, y = lat)) +
#'   geom_path(aes(group = group), size = 0.25) +
#'   geom_point(data = df, colour = "red", size = .5) +
#'   ggthemes::theme_map()
map_unif <- function(map, n) {
  data <- group <- NULL

  rx <- range(map$long, na.rm=TRUE)
  ry <- range(map$lat, na.rm = TRUE)
#  browser()
  tryx <- stats::runif(3*n, min = rx[1], max = rx[2])
  tryy <- stats::runif(3*n, min = ry[1], max = ry[2])
  res <- map %>% tidyr::nest(-group)
  res$sample <- res$data %>% purrr::map(.f = function(d) {
    ins = sp::point.in.polygon(tryx, tryy, d$long, d$lat)
    data.frame(long = tryx[ins==1], lat = tryy[ins == 1])
  })
  dsample <- res %>% select(-data) %>% tidyr::unnest()

  if (nrow(dsample) < n) dsample <- rbind(dsample, map_unif(map, n-nrow(dsample)))

  dsample %>% sample_n(n)
}
