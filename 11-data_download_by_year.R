#########################################
# UK Baby Names - Download yearly files #
#########################################

dmpkg.funs::load_pkgs(dmp = FALSE, 'data.table', 'rvest')

down_ons <- function(sx){
    y <- read_html(paste0('https://www.ons.gov.uk/peoplepopulationandcommunity/birthsdeathsandmarriages/livebirths/datasets/babynamesenglandandwalesbabynamesstatistics', sx)) |>
            html_elements('.btn--thick') |> 
            html_attr('href') %>% 
            gsub('%2f', '/', .)
    for(x in y) 
        download.file(
            paste0('https://www.ons.gov.uk', x), 
            paste0('./ons/', toupper(substr(sx, 1, 1)), gsub('.*/([0-9]{4})/.*', '\\1', x), '.xls')
        )
}
down_ons('boys')
down_ons('girls')
