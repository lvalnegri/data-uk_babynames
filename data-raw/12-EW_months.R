#####################################################
# UK Baby Names - England and Wales TOP 10 by Month #
#####################################################

Rfuns::load_pkgs('data.table', 'readxl')

yt <- data.table()
y <- rbindlist(lapply(
            1997:2020,
            \(yr){
                message('\nProcessing year ', yr)
                for(sx in c('B', 'G')){
                    message(' - Processing ', ifelse(sx == 'B', 'Boys', 'Girls'))
                    fn <- paste0('./data-raw/ori/ENG-WLS/', sx, yr, '.xls')
                    y <- read_xls(fn, grep('Table 5', excel_sheets(fn), value = TRUE))
                    cl <- seq(2, 14, 4)
                    rw <- c(7, 23, 39)
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
                yt[, month := rep(month.abb, each = 11, times = 2)]
            }
)) |> 
    setnames(c('year', 'sex', 'ranking', 'name', 'count', 'month')) |> 
    setcolorder(c('year', 'month', 'sex', 'name', 'count', 'ranking'))
y[ranking == 'Total', ranking := 0]
y[, `:=`( count = as.integer(count), ranking = as.integer(ranking) )]
y[is.na(name), prop := count]
setnafill(y, 'nocb', cols = 'prop')
y[, prop := count / prop]
save_dts_pkg(y, 'ew_months', file.path(datauk_path, 'babynames'), dbn = 'uk_babynames')

# save_dts_pkg(
#     y[ranking == 0, .(country = 'E', count = sum(count)), .(year, sex)], 
#     'totals', 
#     file.path(datauk_path, 'babynames'), dbn = 'uk_babynames'
# )
fst::write_fst(
        y[ranking == 0, .(count = sum(count)), .(year, sex)], 
        file.path(datauk_path, 'babynames', 'ew_totals')
)

rm(list = ls())
gc()
