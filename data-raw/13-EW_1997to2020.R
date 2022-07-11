################################################################
# UK Baby Names - Historic years 1997 to 2020 counts all names #
################################################################

Rfuns::load_pkgs('data.table')
fn <- './data-raw/ori/ENG-WLS/1997to2020.xls' 

download.file(
    'https://www.ons.gov.uk/file?uri=%2fpeoplepopulationandcommunity%2fbirthsdeathsandmarriages%2flivebirths%2fdatasets%2fbabynamesinenglandandwalesfrom1996%2f1996tocurrent/babynames1996to2020.xls',
    fn   
)
y <- rbindlist(lapply(
        c('Boys', 'Girls'),
        \(x){
            message('Processing ', x)
            y <-readxl::read_xls(fn, x, skip = 3, na = ':') |> as.data.table()
            cols <- names(y)[!grepl('\\.{3}', names(y))]
            y <- y[, !grep('Rank', y[1]), with = FALSE][-1]
            setnames(y, c('name', cols))
            y <- y[!(is.na(name) | nchar(name) > 20)]
            y <- melt(y, id.vars = 'name', na.rm = TRUE, variable.factor = FALSE, value.factor = FALSE)
            data.table(sex = ifelse(substr(x, 1, 1) == 'B', 'M', 'F'), y)
        }
))
setnames(y, c('sex', 'name', 'year', 'count'))
y[, `:=`( year = as.integer(year), count = as.integer(count) )]
y <- y[year > 1996]
y[grepl(':$', name), name := gsub(':', '', name)]
y <- y[, .(count = sum(count)), .(sex, name, year)]
setcolorder(y, 'year')
setorderv(y, c('year', 'sex', 'name'))
y[, ranking := frankv(-count, ties.method = 'min'), .(year, sex)]

yt <- fst::read_fst(file.path(datauk_path, 'babynames', 'totals'), as.data.table = TRUE)
y <- yt[country == 'E', .(sex, year, prop = count)][y, on = c('sex', 'year')][, prop := count / prop]
setcolorder(y, c('year', 'sex', 'name', 'count'))
setorderv(y, c('year', 'sex', 'ranking'))

fst::write_fst(y, file.path(datauk_path, 'babynames', 'ew_babynames'))

rm(list = ls())
gc()
