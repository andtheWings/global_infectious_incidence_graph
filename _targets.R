library(targets)

source("R/wrangling_gbd.R")
source("R/wrangling_gbd_w_world_geo.R")
source("R/wrangling_generic_huge.R")
source("R/wrangling_world_geo.R")

tar_option_set(
    packages = c(
        "dplyr", "readr", "tidyr",
        "huge", "tidygraph"
    )
)

list(
    # GBD
    tar_target(
        gbd_raw_file,
        "data/IHME-GBD_2019_DATA-25cc5417-1.csv",
        format = "file"
    ),
    tar_target(
        gbd_raw,
        read_csv(gbd_raw_file)
    ),
    tar_target(
        gbd_pre_huge_glasso,
        wrangle_gbd_pre_huge_glasso(gbd_raw)
    ),
    tar_target(
        gbd_huge_glasso,
        huge(gbd_pre_huge_glasso, method = "glasso", cov.output=TRUE)
    ),
    tar_target(
        gbd_huge_glasso_ric,
        huge.select(gbd_huge_glasso, criterion = "ric")
    ),
    # World Geo
    tar_target(
        world_geo_raw_file,
        "data/countries.csv",
        format = "file"
    ),
    tar_target(
        world_geo,
        wrangle_world_geo(world_geo_raw_file)
    ),
    # GBD and World Geo
    tar_target(
        gbd_graph,
        assemble_gbd_graph(gbd_pre_huge_glasso, gbd_huge_glasso_ric)
    )
)
