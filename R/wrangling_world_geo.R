wrangle_world_geo <- function(world_geo_raw_file_csv) {
    
    df1 <-
        read_csv(world_geo_raw_file_csv) |> 
        add_row(longitude = 121.000000, latitude = 23.500000, COUNTRY = "Taiwan", ISO = "TW") |> 
        janitor::clean_names()
    
    return(df1)
    
}