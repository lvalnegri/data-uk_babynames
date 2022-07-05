###################################################################################
# UK Baby Names - Historic years every ten years 1904 to 1994, rank top 100 names #
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
        setnames(c('rank', 'sex', 'year', 'name')) |> 
        set(j = 'count', value = NA_integer_) |>  
        setcolorder(c('year', 'sex', 'name', 'count', 'rank')) |> 
        set(j = c('year', 'rank'), value = list(as.integer(y[['year']]), as.integer(y[['rank']]))) |> 
        save_dts_pkg('historic', file.path(datauk_path, 'babynames'), as_rdb = FALSE)

rm(list = ls())
gc()
