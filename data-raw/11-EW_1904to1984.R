###################################################################################
# UK Baby Names - Historic years every ten years 1904 to 1994, ranking top 100 names #
###################################################################################

Rfuns::load_pkgs('data.table')
fn <- './data-raw/ons/historic.xls' 

download.file(
    'https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/birthsdeathsandmarriages/livebirths/datasets/babynamesenglandandwalestop100babynameshistoricaldata/19041994/historicname_tcm77-254032.xls',
    fn   
)

y <- rbindlist(list(
            readxl::read_xls(fn, 'Boys', skip = 3) |> data.table(sex = 'B'),
            readxl::read_xls(fn, 'Girls', skip = 3) |> data.table(sex = 'G')
     )) |> 
        melt(id.vars = c('RANK', 'sex'), na.rm = TRUE, variable.factor = FALSE) |> 
        setnames(c('ranking', 'sex', 'year', 'name')) |> 
        set(j = 'count', value = NA_integer_) |>  
        setcolorder(c('year', 'sex', 'name', 'count', 'ranking')) |> 
        subset(!is.na(ranking)) |> 
        transform(year = as.integer(year), ranking = as.integer(ranking)) |> 
        fwrite('./data-raw/historic.csv')

rm(list = ls())
gc()
