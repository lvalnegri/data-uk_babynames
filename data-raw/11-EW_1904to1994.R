###################################################################################
# UK Baby Names - Historic years every ten years 1904 to 1994, ranking top 100 names #
###################################################################################

Rfuns::load_pkgs('data.table')
fn <- './data-raw/ori/ENG-WLS/historic.xls' 

download.file(
    'https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/birthsdeathsandmarriages/livebirths/datasets/babynamesenglandandwalestop100babynameshistoricaldata/19041994/historicname_tcm77-254032.xls',
    fn   
)

y <- rbindlist(list(
            readxl::read_xls(fn, 'Boys', skip = 3) |> data.table(sex = 'M'),
            readxl::read_xls(fn, 'Girls', skip = 3) |> data.table(sex = 'F')
     )) |> 
        melt(id.vars = c('RANK', 'sex'), na.rm = TRUE, variable.factor = FALSE) |> 
        setnames(c('ranking', 'sex', 'year', 'name')) |> 
        setcolorder(c('year', 'sex', 'name', 'ranking')) |> 
        subset(!is.na(ranking)) |> 
        transform(year = as.integer(year), ranking = as.integer(ranking))
save_dts_pkg(y, 'ew_hist', file.path(datauk_path, 'babynames'), dbn = 'uk_babynames')

rm(list = ls())
gc()
