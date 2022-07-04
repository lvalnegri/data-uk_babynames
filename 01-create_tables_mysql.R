####################################################
# UK Baby Names - Create MySQL database and tables #
####################################################

library(dmpkg.funs)

dbn <- 'uk_babynames'

dd_create_db(dbn)

# 
x = "
    code MEDIUMINT(5) UNSIGNED NOT NULL,
    description VARCHAR(160) NOT NULL,
    section CHAR(1) NOT NULL,
    PRIMARY KEY (code),
    INDEX section (section)
"
dd_create_dbtable('sics', dbn, x)


rm(list = ls())
gc()

