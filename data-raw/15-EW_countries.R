########################################################
# UK Baby Names - England and Wales TOP 100 by Country #
########################################################

Rfuns::load_pkgs('data.table', 'readxl')

yt <- data.table()
y <- rbindlist(lapply(
            1997:1998,
            \(yr){
                message('\nProcessing year ', yr)
                for(sx in c('B', 'G')){
                    message(' - Processing ', ifelse(sx == 'B', 'Boys', 'Girls'))
                    fn <- paste0('./data-raw/ori/ENG-WLS/', sx, yr, '.xls')
                    for(sh in c('Table 2', 'Table 3')){
                        y <- read_xls(fn, grep(sh, excel_sheets(fn), value = TRUE))
                        cl <- c(2, 8)
                        yt <- rbindlist(list( 
                                    yt, 
                                    data.table( 
                                        yr,
                                        ifelse(sx == 'B', 'M', 'F'), 
                                        rbindlist(lapply( cl, \(x) y[8:57, c(x:(x+2), x+4)] ), use.names = FALSE )
                                    ) 
                        ))
                    }
                }
                yt[, country := rep(c('E', 'W'), each = 100, times = 2)]
            }
)) |> setnames(c('year', 'sex', 'ranking', 'name', 'count', 'rank_other', 'country'))
y[, `:=`( count = as.integer(count), ranking = as.integer(ranking), rank_other = as.integer(rank_other) )]

yt <- fst::read_fst(file.path(datauk_path, 'babynames', 'e+w_totals'), as.data.table = TRUE)
y <- yt[, .(country, sex, year, prop = count)][y, on = c('country', 'sex', 'year')][, prop := count / prop]
setcolorder(y, c('year', 'country', 'sex', 'name', 'count'))
setorderv(y, c('year', 'country', 'sex', 'ranking'))

save_dts_pkg(y, 'ew_countries', file.path(datauk_path, 'babynames'), dbn = "uk_babynames")

rm(list = ls())
gc()
