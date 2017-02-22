#' Outline of US states and equivalents
#'
#' Data from shapefiles provided by the Census Bureau’s MAF/TIGER geographic database at
#' \url{https://www.census.gov/geo/maps-data/data/cbf/cbf_state.html}. State outlines are based
#' on the 1:20m resolution level. Internal points, divisions and regions are based on TIGER/Line Shapefiles for states and equivalents in the 2016 release.
#' @format both objects are data frames consisting of variables of length ~13k:
#' \itemize{
#'   \item long: geographic longitude
#'   \item lat: geographic latitude
#'   \item order: order of locations
#'   \item piece: positive integer value, one for each separate area/island of a state
#'   \item id: integer value uniquely identifying each state
#'   \item group: character value - composite of id and piece, uniquely identifying each part of each state
#'   \item STATEFP: FIPS state  code
#'   \item STATENS: GNIS state  code
#'   \item AFFGEOID: American FactFinder state code
#'   \item GEOID: GEOID state code
#'   \item STUSPS: US state code
#'   \item NAME: name of state or state equivalent
#'   \item ALAND: land area of the state/state equivalent in square meters
#'   \item AWATER: water area of the state/state equivalent in square meters
#'   \item REGION: integer of US region
#'   \item REGION.NAME: name of US region
#'   \item DIVISION: integer of US division
#'   \item DIVISION.NAME: name of US division
#'   \item INTPTLAT: latitude of interior point
#'   \item INTPTLON: longitude of interior point
#' }
#' @examples
#' states %>% ggplot(aes(x = long, y = lat)) +
#'   geom_path(aes(group = group)) +
#'   geom_point(data = states %>% map_unif(n = 1000), colour = "red", size = 0.25)
#'
#' inset %>% ggplot(aes(x = long, y = lat)) +
#'   geom_path(aes(group = group)) +
#'   geom_point(data = inset %>% map_unif(n = 1000), colour = "red", size = 0.25)
"states"

#' @rdname states
"inset"

#' Outline of US counties
#'
#' Data from shapefiles provided by the Census Bureau’s MAF/TIGER geographic database at
#' \url{https://www.census.gov/geo/maps-data/data/cbf/cbf_state.html}. County outlines are based
#' on the 1:20m resolution level. Divisions and regions are based on TIGER/Line Shapefiles for states and equivalents in the 2016 release.
#' @format both objects are data frames consisting of variables of length ~50k:
#' \itemize{
#'   \item long: geographic longitude
#'   \item lat: geographic latitude
#'   \item order: order of locations
#'   \item hole: logical vector
#'   \item piece: positive integer value, one for each separate area/island of a county
#'   \item id: integer value uniquely identifying each county
#'   \item group: character value - composite of id and piece, uniquely identifying each part of each county
#'   \item STATEFP: FIPS state  code
#'   \item COUNTYFP: FIPS county  code
#'   \item COUNTYNS: GNIS county  code
#'   \item AFFGEOID: American FactFinder county code
#'   \item GEOID: GEOID county code
#'   \item NAME: name of county
#'   \item ALAND: land area of the county in square meters
#'   \item AWATER: water area of the county in square meters
#'   \item STATE: name of the state
#'   \item STUSPS: US state code
#'   \item REGION: integer of US region
#'   \item DIVISION: integer of US division
#' }
#' @examples
#' counties %>% ggplot(aes(x = long, y = lat)) +
#'   geom_path(aes(group = group))
#'
#' counties_inset %>% ggplot(aes(x = long, y = lat)) +
#'   geom_path(aes(group = group))
"counties"

#' @rdname counties
"counties_inset"
