#' Convert multipolygon simple feature from sf format
#'
#' Works for multipolygon simple features (see package `sf`) only.
#' @param data data set
#' @param ... one or more columns to extract (one is tested, you're on your own with multiple)
#' @export
#' @examples
#' library(sf)
#' nc <- st_read(system.file("shape/nc.shp", package="sf"))
#' gnc <- unnest_sf(nc, geometry)
#' gnc %>% ggplot(aes(x = long, y = lat, group = group)) + geom_polygon()
unnest_sf <- function(data, ...) {
  dots <- lazyeval::lazy_dots(...)
  if (length(dots) == 0) {
    list_cols <- names(data)[vapply(data, is.list, logical(1))]
    list_col_names <- lapply(list_cols, as.name)
    dots <- lazyeval::as.lazy_dots(list_col_names, env = parent.frame())
  }
  unnest_sf_(data, dots)
}

#' Convert multipolygon simple feature from sf format
#'
#' Works for multipolygon simple features (see package `sf`) only.
#' @param data data set
#' @param unnest_cols one or more columns to extract (one is tested, you're on your own with multiple)
#' @export
unnest_sf_ <- function (data, unnest_cols) {
  id <- NULL # just to initialize

  nested <- dplyr::transmute_(data, .dots = unnest_cols)
  nested_i <- nested[[1]]
  nested_df <- lapply(1:length(nested_i), function(i) {
    x <- nested_i[[i]]
    if (is.list(x[[1]])) x <- x[[1]] # list and indexing switched
    res <- lapply(x, function(x) {
      res_df <- as.data.frame(x)[,(1:2)]
      names(res_df) <- c("long", "lat")
      res_df$order <- 1:nrow(res_df)
      tibble::as_tibble(res_df)
      })
    res_df <- tibble::as_tibble(data.frame(res = I(res), id=i,
                                           piece = 1:length(res)))
    res_df$group = with(res_df, paste(id, piece, sep="-"))

    class(res_df$res) <- NULL # gets class 'AsIs'
    res_df <- unnest(res_df, res) %>% nest(-id)
    data.frame(data[i,], res_df) %>% unnest(data)
  })
  nested_df %>% purrr::map_df(.f = function(x) x)
}
