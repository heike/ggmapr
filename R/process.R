#' @exportFrom dplyr left_join
#' @exportFrom ggplot2 fortify
#' @exportFrom maptools read
#' @example
#' states <- process_shape("data-raw/tl_2016_us_state/tl_2016_us_state.shp")
#' states <- states %>% mutate(
#' long = replace(long, long > 100, long[long > 100]-360)
#' )
#' save(states, file="data/states.rda")
process_shape <- function(path) {
  stopifnot(file.exists(path))

  dframe <- maptools::readShapePoly(path)
  polys <- ggplot2::fortify(dframe)
  data <- dframe@data
  data$id <- row.names(data)
  dplyr::left_join(polys, data, by="id")
}

#' @export
#' @example
#' states01 <- states01 %>% group_by(group) %>% mutate(bbox = diff(range(long))*diff(range(lat)))
#' states01 <- states01 %>% filter(bbox > 0.15)
#' states01 %>% ggplot(aes(x = long, y = lat)) + geom_path(aes(group = group))
#' inset01 <- scale_shift(states01, "NAME", "Hawaii", shift = c(50, 5))
#' inset01 <- scale_shift(inset01, "NAME", "Alaska", scale=0.3, shift=c(40,-32.5))
#' inset01  %>% ggplot(aes(long, lat)) + geom_path(aes(group=group))
#' inset01 <- inset01  %>%
#'  filter(lat > 20)
#'  inset01 %>%
#'  ggplot(aes(long, lat)) + geom_path(aes(group=group))
#'
#'
#' states01 %>%
#'   scale_shift("DIVISION", "1", shift=c(7.5, 0)) %>%
#'   scale_shift("DIVISION", "2", shift=c(5, 0)) %>%
#'   scale_shift("DIVISION", "3", shift=c(2.5, 0)) %>%
#'   scale_shift("DIVISION", "5", shift=c(5, -1.5)) %>%
#'   scale_shift("DIVISION", "6", shift=c(2.5, -1.5)) %>%
#'   scale_shift("DIVISION", "9", shift=c(-5, 0)) %>%
#'   scale_shift("DIVISION", "8", shift=c(-2.5, 0)) %>%
#'   scale_shift("DIVISION", "7", shift=c(0, -1.5)) %>%
#'   filter(lat > 20) %>%
#'   ggplot(aes(long, lat)) + geom_polygon(aes(group=group, fill=factor(DIVISION)))
#'
#' states01 %>%
#'   scale_shift("REGION", "4", shift=c(-2.5, 0)) %>%
#'   scale_shift("REGION", "1", shift=c(1.25, 0)) %>%
#'   scale_shift("REGION", "3", shift=c(0, -1.25)) %>%
#'   ggplot(aes(long, lat)) + geom_polygon(aes(group=group, fill=factor(REGION)))
scale_shift <- function(map, variable, regions, scale = 1, shift = c(0,0)) {
  map <- data.frame(map)
  map$region__ <- map[,variable]
  submap <- map %>% filter(region__ %in% regions)
  mx <- mean(submap$long)
  my <- mean(submap$lat)

  submap <- submap %>% mutate(
    long = scale*(long - mx) + mx + shift[1],
    lat = scale*(lat - my) + my + shift[2]
  )

  map <- map %>% filter(!(region__ %in% regions))
  rbind(map, submap) %>% select(- region__)
}
