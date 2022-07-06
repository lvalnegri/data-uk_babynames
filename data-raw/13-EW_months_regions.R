#########################################
# UK Baby Names - Download yearly files #
#########################################

Rfuns::load_pkgs('data.table', 'readxl')

# REGIONS
yt <- data.table()
y1 <- rbindlist(lapply(
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
                                    sx, 
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
y1[ranking == 'Total', ranking := 0]
y1[, `:=`( count = as.integer(count), ranking = as.integer(ranking) )]
y1[is.na(name), prop := count]
setnafill(y1, 'nocb', cols = 'prop')
y1[, prop := count / prop]
save_dts_pkg(y1, 'ew_regions', file.path(datauk_path, 'babynames'), dbn = "uk_babynames")

# MONTHS
yt <- data.table()
y2 <- rbindlist(lapply(
            2008, # 1997:2016,
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
                                    sx, 
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
y2[ranking == 'Total', ranking := 0]
y2[, `:=`( count = as.integer(count), ranking = as.integer(ranking) )]
y2[is.na(name), prop := count]
setnafill(y2, 'nocb', cols = 'prop')
y2[, prop := count / prop]
save_dts_pkg(y2, 'ew_months', file.path(datauk_path, 'babynames'), dbn = "uk_babynames")
