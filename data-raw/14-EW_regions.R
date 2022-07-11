######################################################
# UK Baby Names - England and Wales TOP 10 by Region #
######################################################

Rfuns::load_pkgs('data.table', 'readxl')
load_all()

yt <- data.table()
y <- rbindlist(lapply(
            1997:2020,
            \(yr){
                message('\nProcessing year ', yr)
                for(sx in c('B', 'G')){
                    message(' - Processing ', ifelse(sx == 'B', 'Boys', 'Girls'))
                    fn <- paste0('./data-raw/ori/ENG-WLS/', sx, yr, '.xls')
                    y <- read_xls(fn, grep('Table 4', excel_sheets(fn), value = TRUE))
                    cl <- seq(2, 18, 4)
                    rw <- c(7, 23)
                    yt <- rbindlist(list( 
                                yt, 
                                data.table( 
                                    yr,
                                    ifelse(sx == 'B', 'M', 'F'), 
                                    rbindlist(lapply( 
                                        rw, 
                                        \(z) rbindlist(lapply( 
                                                cl, 
                                                \(x) y[c(z:(z + 9), z + 11), x:(x+2)]
                                        ), use.names = FALSE )
                                    )) 
                                ) 
                    ))
                }
                yt[, region := rep(rgn.lst, each = 11, times = 2)]
            }
)) |> 
    setnames(c('year', 'sex', 'ranking', 'name', 'count', 'region')) |> 
    setcolorder(c('year', 'region', 'sex', 'name', 'count', 'ranking'))
y[ranking == 'Total', ranking := 0]
y[, `:=`( count = as.integer(count), ranking = as.integer(ranking) )]
y[is.na(name), prop := count]
setnafill(y, 'nocb', cols = 'prop')
y[, prop := count / prop]
save_dts_pkg(y, 'ew_regions', file.path(datauk_path, 'babynames'), dbn = "uk_babynames")

yw <- y[region == 'Wales' & ranking == 0, .(country = 'W', year, sex, count)]
ye <- fst::read_fst(file.path(datauk_path, 'babynames', 'ew_totals'), as.data.table = TRUE)
ye <- yw[, .(year, sex, wc = count)][ye, on = c('year', 'sex')][, `:=`( country = 'E', count = count - wc)][, wc := NULL]

fst::write_fst(rbindlist(list(yw, ye), use.names = TRUE), file.path(datauk_path, 'babynames', 'e+w_totals'))

rm(list = ls())
gc()
