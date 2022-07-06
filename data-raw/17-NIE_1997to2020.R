##################################################
# UK Baby Names - Northern Irelnd * 1997 to 2020 #
##################################################

Rfuns::load_pkgs('data.table')
fn <- './data-raw/ori/NIE/1997to2020.xlsx' 

download.file(
    'https://www.nisra.gov.uk/system/files/statistics/Full_Name_List_NI_9721.xlsx',
    fn   
)
y <- rbindlist(lapply(
        c('Table 1', 'Table 2'),
        \(x){
            message('Processing ', x)
            yt <- readxl::read_xlsx(fn, x, skip = 4) |> as.data.table()
            rbindlist(lapply(0:24, \(z) data.table('N', 1997 + z, x, yt[, (z * 3 + 1):(z * 3 + 3)])), use.names = FALSE)
        }
))
setnames(y, c('country', 'year', 'sex', 'name', 'count', 'ranking'))
y <- y[!(is.na(ranking) | ranking == '..')]
y[, `:=`(
    year = as.integer(year),
    sex = ifelse(sex == 'Table 1', 'M', 'F'),
    count = as.integer(count),
    ranking = as.integer(ranking)
)]

fwrite(y, './data-raw/NIE.csv')

rm(list = ls())
gc()
