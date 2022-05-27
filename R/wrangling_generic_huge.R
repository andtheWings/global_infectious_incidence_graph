wrangle_ric_to_edges <- function(ric_obj) {
    
    df1 <-
        ric_obj$refit |> 
        as_tbl_graph() |> 
        activate(edges) |> 
        as_tibble()
    
    df2 <-
        ric_obj$opt.cov |> 
        cov2cor() |> 
        corpcor::cor2pcor() |> 
        as_tbl_graph() |> 
        activate(edges) |> 
        as_tibble() |> 
        semi_join(
            df1,
            by = c("from", "to")
        )
    
    return(df1)
    
}