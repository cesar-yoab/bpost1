<img src="http://www.ces-eec.ca/wp-content/uploads/2018/04/ces-logo-wide.png"/>
[![Netlify Status](https://api.netlify.com/api/v1/badges/3a2597ec-c2d3-4cad-a4e6-293c0f054b46/deploy-status)](https://app.netlify.com/sites/cyvg/deploys)
# First Blog Post
This repository contains the code used to create the first [blog post](https://cyvg.netlify.app/posts/p1/).
To use any of the code in this repository you must have 
the following libraries installed

- tidyverse
- labelled
- plyr
- cowplot
- cesR

To download them use the command
```{R}
install.packages(packagename)
```

inside the R console.

## CES Data
To download the data for the investigation we used the **cesR**, documentation for such package is
available [here](https://hodgettsp.github.io/cesR/). If you would prefer to download the data from the CES website directly it can be found 
[here](http://ces-eec.ca/).

## Files in this repo
1. "post_script.R" contains **only** the code used to download the data, clean it,
generate plots and table of probabilities. 
The .Rmd file contains the actual blog post, that is, both the 
text and code. We recommend you have installed LaTex to properly 
view all equations.

2. "post1.Rmd" contains the original markdown file used to render the blog post
[here](https://cyvg.netlify.app/posts/p1/). It contains both the essay and the code. The
code might differ slightly with what is "post_script.R" since the code runs in separate "chunks". 