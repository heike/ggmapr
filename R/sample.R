#' Find a uniform sample of points for one region of a map
#'
#' place uniform point sample into the region `region` of a map
#' @export
#' @examples
#' data(inset01)
#' df <- inset01 %>% filter(DIVISION == "9") %>% map_unif(1000)
#' df <- inset01 %>% filter(NAME == "Iowa") %>% map_unif(10)
#' df <- inset01 %>% map_unif(5000)
#' inset01 %>% ggplot(aes(x = long, y = lat)) +
#'   geom_path(aes(group = group)) +
#'   geom_point(data = df, colour = "red")
#'
#' data(crimes)
#' population <- crimes %>% filter(Year == max(Year))
#' popmap <- left_join(inset, population[,c("Abb", "Population")], by=c("STUSPS"="Abb"))
#' poplist <- popmap %>% tidyr::nest(-NAME)
#' poplist$sample <- poplist$data %>% purrr::map(.f = function(d) d %>% map_unif(50))
#' poplist$sample <- poplist$data %>% purrr::map(.f = function(d) d %>% map_unif(round(d$Population[1]/50000)))
#' df <- poplist %>% select(-data) %>% tidyr::unnest()
#' inset %>% ggplot(aes(x = long, y = lat)) +
#'   geom_path(aes(group = group), size = 0.25) +
#'   geom_point(data = df, colour = "red", size = .5) +
#'   ggthemes::theme_map()
map_unif <- function(map, n) {
  rx <- range(map$long, na.rm=TRUE)
  ry <- range(map$lat, na.rm = TRUE)
  tryx <- runif(3*n, min = rx[1], max = rx[2])
  tryy <- runif(3*n, min = ry[1], max = ry[2])
  res <- map %>% tidyr::nest(-group)
  res$sample <- res$data %>% purrr::map(.f = function(d) {
    ins = sp::point.in.polygon(tryx, tryy, d$long, d$lat)
    data.frame(long = tryx[ins==1], lat = tryy[ins == 1])
  })
  dsample <- res %>% select(-data) %>% tidyr::unnest()

  if (nrow(dsample) < n) dsample <- rbind(dsample, map_unif(map, n-nrow(dsample)))

  dsample %>% sample_n(n)
}

