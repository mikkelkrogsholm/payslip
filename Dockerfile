FROM rocker/tidyverse:3.5.0

# Install needed dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
  libpoppler-cpp-dev

# Install needed R packages
RUN R -e  "install.packages(c('pdftools'), repos = 'https://cran.rstudio.com')"
