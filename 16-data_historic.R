#############################################
# UK Baby Names - Historic totals all names #
#############################################

dmpkg.funs::load_pkgs(dmp = FALSE, 'data.table')

tmpf <- tempfile()
download.file(
    'https://www.ons.gov.uk/file?uri=%2fpeoplepopulationandcommunity%2fbirthsdeathsandmarriages%2flivebirths%2fdatasets%2fbabynamesinenglandandwalesfrom1996%2f1996tocurrent/babynames1996to2020.xls',
    tmpf    
)

y <- rbindlist(lapply(
        c('Boys', 'Girls'),
        \(x){
            message('Processing ', x)
            y <- as.data.table(readxl::read_xls(tmpf, x, skip = 3, na = ':'))
            cols <- names(y)[!grepl('\\.{3}', names(y))]
            y <- y[, !grep('Rank', y[1]), with = FALSE][-1]
            setnames(y, c('name', cols))
            y <- y[!(is.na(name) | nchar(name) > 20)]
            y <- melt(y, id.vars = 'name', na.rm = TRUE, variable.factor = FALSE, value.factor = FALSE)
            data.table(sex = substr(x, 1, 1), y)
        }
))
unlink(tmpf)
setnames(y, c('sex', 'name', 'year', 'count'))
y[, `:=`( year = as.integer(year), count = as.integer(count) )]
y[grepl(':$', name), name := gsub(':', '', name)]
y <- y[, .(count = sum(count)), .(sex, name, year)]
