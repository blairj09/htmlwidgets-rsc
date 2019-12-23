# Create a single plotly widget and a crosstalk enabled widget

# Packages ----
library(plotly)
library(crosstalk)

# Plotly widget ----
x <- 2:12 
y <- 2:12
df <- data.frame(x = x, y = y) 

simple_plot <- plot_ly(df, x = ~x, y = ~y)

# Save ----
htmlwidgets::saveWidget(partial_bundle(simple_plot), "plotly-widget.html", selfcontained = FALSE, libdir = "lib")
htmlwidgets::saveWidget(partial_bundle(simple_plot), "plotly-self-contained-widget.html", selfcontained = TRUE)

# Crosstalk widget ----
# Reference: https://github.com/ramnathv/htmlwidgets/issues/266

shared_mtcars <- SharedData$new(mtcars)

p1 <- plot_ly(data = shared_mtcars, x = ~wt, y = ~mpg)
p2 <- plot_ly(data = shared_mtcars, x = ~hp, y = ~qsec)

combined <- bscols(widths = c(3, NA, NA),
                   list(
                     filter_checkbox("cyl", "Cylinders", shared_mtcars, ~cyl, inline = TRUE),
                     filter_slider("hp", "Horsepower", shared_mtcars, ~hp, width = "100%"),
                     filter_select("auto", "Automatic", shared_mtcars, ~ifelse(am == 0, "Yes", "No"))
                   ),
                   p1,
                   p2
)

# Save ----
htmltools::save_html(combined, "crosstalk-widget.html", libdir = "lib")
