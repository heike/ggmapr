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

![](README_files/figure-markdown_strict/unnamed-chunk-5-1.png) This map
is available as data object `inset`.

Sampling from a uniform distribution
====================================

This is what 3200 uniformly sampled locations across the US look like:
![](README_files/figure-markdown_strict/unnamed-chunk-6-1.png)

This is what the geographic distribution looks like when we sample 64
locations randomly from each state:
![](README_files/figure-markdown_strict/unnamed-chunk-7-1.png)

The map below is based state-wide population estimates published by the
US Census Bureau for 2015. Each dot respresents about 100,000 residents
in each state:
![](README_files/figure-markdown_strict/unnamed-chunk-8-1.png)
