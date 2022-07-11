###################################################################
# UK Baby Names - England and Wales TOP 100 by Mother's Age Class #
###################################################################

Rfuns::load_pkgs('data.table', 'readxl')
load_all()

yt <- data.table()
y <- rbindlist(lapply(
            2018:2020,
            \(yr){
                message('\nProcessing year ', yr)
                for(sx in c('B', 'G')){
                    message(' - Processing ', ifelse(sx == 'B', 'Boys', 'Girls'))
                    fn <- paste0('./data-raw/ori/ENG-WLS/', sx, yr, '.xls')
                    y <- read_xls(fn, grep('Table 8', excel_sheets(fn), value = TRUE))
                    cl <- seq(1, 7, 2)
                    yt <- rbindlist(list( 
                                yt, 
                                data.table( 
                                    yr, 
                                    ifelse(sx == 'B', 'M', 'F'), 
                                    rbindlist(lapply( 
                                        cl, 
                                        \(x) y[8:137, x:(x+1)]
                                    ), use.names = FALSE) 
                                ) 
                    ))
                }
                yt[, age := rep(age.lst, each = 130, times = 2)]
            }
)) |> 
    setnames(c('year', 'sex', 'ranking', 'name', 'age')) |> 
    setcolorder(c('year', 'age', 'sex', 'ranking'))
y[, ranking := as.integer(ranking)]
save_dts_pkg(y, 'ew_ages', file.path(datauk_path, 'babynames'), dbn = "uk_babynames")

rm(list = ls())
gc()
