mapr
====

This R package is helping with working with maps by making insets,
pull-outs or zooms:

![](README_files/figure-markdown_strict/unnamed-chunk-2-1.png)

Map of **all** US states and state equivalents as defined by the 2016
Tiger shapefiles provided by the US Census Bureau:

    data(states)
    states %>% 
      ggplot(aes(x = long, y = lat)) + geom_path(aes(group = group)) +
      ggthemes::theme_map()

![](README_files/figure-markdown_strict/unnamed-chunk-3-1.png)

The function `scale_shift` allows to scale and shift parts of the map:

    states %>%
      scale_shift("NAME", "Hawaii", shift = c(52.5, 5.5)) %>%
      scale_shift("NAME", "Alaska", scale=0.3, shift=c(39,-32.5)) %>%
      filter(lat > 20) %>%
     ggplot(aes(long, lat)) + geom_path(aes(group=group)) +
      ggthemes::theme_map() 

![](README_files/figure-markdown_strict/unnamed-chunk-5-1.png)

This map is available as data object `inset`.

Sampling from a uniform distribution
====================================

Below are maps of the US overlaid by about 3200 points each. The points
are placed uniformly within the geographic region. The number of points
in each region is based on different strategies. From left to right we
have: (top-left) a sample of locations selected uniformly across the US,
(top-right) each state contains a set of 63 uniformly selected
locations, (bottom-left) each dot represents about 100k residents in
each state.

![](README_files/figure-markdown_strict/unnamed-chunk-6-1.png)

Thanksgiving traditions
=======================

In 2015 FiveThirtyEight commissioned a survey asking people across the
US a number of Thanksgiving related questions, such as side dishes,
flavor of the pie, desserts and after dinner activities. They reported
on the main difference in an article published on Nov 20 2015, available
at
[](http://fivethirtyeight.com/features/heres-what-your-part-of-america-eats-on-thanksgiving/).
The main finding was shown in a choropleth chart highlighting the
**disproportionally most common side dish** in each region.

The dataset with responses of more than 1000 participants is available
at:
[](https://github.com/fivethirtyeight/data/blob/master/thanksgiving-2015/thanksgiving-2015-poll-data.csv)

The FiveThirtyEight chart is fun, but it doesn't show the whole picture.
What else can we find out from the data about Thanksgiving traditions?

    thanks %>% 
      filter(`How.is.the.main.dish.typically.cooked.` %in% c("Baked", "Roasted", "Fried"),
             !is.na(Division)) %>%
      ggplot(aes(x = Division, fill = `How.is.the.main.dish.typically.cooked.`)) + geom_bar(position='fill') +
        scale_fill_manual("How is the main dish\ntypically cooked", 
                          values = c("forestgreen", "orange", "steelblue")) +
      coord_flip()

![](README_files/figure-markdown_strict/unnamed-chunk-8-1.png)

This translates to a FiveThirtyEight style chart of disproportionally
most common way of preparing the main dish:

    ## Warning in left_join_impl(x, y, by$x, by$y, suffix$x, suffix$y): joining
    ## factor and character vector, coercing into character vector

![](README_files/figure-markdown_strict/unnamed-chunk-9-1.png)

Let's just use the raw data and put those on the map:

![](README_files/figure-markdown_strict/unnamed-chunk-10-1.png)
