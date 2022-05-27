wrangle_gbd_pre_huge_glasso <- function(gbd_raw_df) {
    
    df1 <-
        gbd_raw_df |> 
        select(
            location,
            cause,
            year,
            val
        ) |> 
        pivot_wider(
            names_from = location,
            values_from = val
        ) |> 
        rename(
            Bolivia = `Bolivia (Plurinational State of)`,
            `Czech Republic` = Czechia,
            `North Korea` = `Democratic People's Republic of Korea`,
            `Congo DRC` = `Democratic Republic of the Congo`,
            Iran = `Iran (Islamic Republic of)`,
            Laos = `Lao People's Democratic Republic`,
            Micronesia = `Micronesia (Federated States of)`,
            `Palestinian Territory` = Palestine,
            `South Korea` = `Republic of Korea`,
            Moldova = `Republic of Moldova`,
            Syria = `Syrian Arab Republic`,
            Taiwan = `Taiwan (Province of China)`,
            Tanzania = `United Republic of Tanzania`,
            `United States` = `United States of America`,
            `US Virgin Islands` = `United States Virgin Islands`,
            Venezuela = `Venezuela (Bolivarian Republic of)`,
            Vietnam = `Viet Nam`
        ) |> 
        select(
            -cause, -year
        ) |> 
        datawizard::standardise() |> 
        as.matrix()
    
    return(df1)
    
}

assemble_gbd_graph <- function(gbd_pre_huge_glasso_mx, gbd_huge_glasso_ric_obj) {
    
    nodes1 <-
        tibble(country = colnames(gbd_pre_huge_glasso_mx)) |> 
        mutate(index_num = row_number())
    
    edges1 <-
        gbd_huge_glasso_ric_obj$refit |> 
        as_tbl_graph() |> 
        activate(edges) |> 
        as_tibble()
    
    edges_2 <-
        gbd_huge_glasso_ric_obj$opt.cov |> 
        cov2cor() |> 
        corpcor::cor2pcor() |> 
        as_tbl_graph() |> 
        activate(edges) |> 
        as_tibble() |> 
        semi_join(
            edges1,
            by = c("from", "to")
        )
    
    graph1 <- 
        tbl_graph(
            , 
            edges_2, 
            directed = FALSE
        )
    
    return(graph1)
    
}