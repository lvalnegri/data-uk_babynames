####################################################
# UK Baby Names - Create MySQL database and tables #
####################################################

library(Rfuns)

dbn <- 'uk_babynames'

dd_create_db(dbn)

# TABLE totals
x = "
    country CHAR(1) NOT NULL COMMENT 'Country of Residence of the mother: `E`ngland and Wales, `S`cotland, `N`orthern Ireland.',
    year SMALLINT(4) UNSIGNED NOT NULL COMMENT 'England and Wales: from 1997 to 2020, Scotland: from 1996 to 2020, Northern Ireland: from 1996 to 2020.',
    sex CHAR(1) NOT NULL COMMENT '`F` female, `M` male',
    count MEDIUMINT(6) UNSIGNED NULL DEFAULT NULL,
    PRIMARY KEY (`country`, `year`, `sex`)
"
dd_create_dbtable('totals', dbn, x)

# TABLE babynames
x = "
    country CHAR(1) NOT NULL COMMENT 'Country of Residence of the mother: `E`ngland and Wales, `S`cotland, `N`orthern Ireland.',
    year SMALLINT(4) UNSIGNED NOT NULL COMMENT 'England and Wales: from 1996 to 2020, Scotland: from 1996 to 2020, Northern Ireland: from 1996 to 2020.',
    sex CHAR(1) NOT NULL COMMENT '`F` female, `M` male',
    name VARCHAR(20) NOT NULL COMMENT '',
    count MEDIUMINT(5) UNSIGNED NULL DEFAULT NULL COMMENT '',
    prop DECIMAL(6, 5) UNSIGNED NULL DEFAULT NULL COMMENT '',
    ranking SMALLINT(5) UNSIGNED NOT NULL COMMENT '',
    PRIMARY KEY (`country`, `year`, `sex`, `name`),
    KEY `ranking` (`ranking`)
"
dd_create_dbtable('babynames', dbn, x)

# TABLE ew_hist
x = "
    year SMALLINT(4) UNSIGNED NOT NULL COMMENT '',
    sex CHAR(1) NOT NULL COMMENT '`F` female, `M` male',
    name VARCHAR(12) NOT NULL COMMENT '',
    ranking TINYINT(3) UNSIGNED NOT NULL COMMENT '',
    UNIQUE KEY (`year`, `sex`, `name`),
    KEY `ranking` (`ranking`)
"
dd_create_dbtable('ew_hist', dbn, x)

# TABLE ew_months
x = "
    year SMALLINT(4) UNSIGNED NOT NULL COMMENT '',
    month CHAR(3) NOT NULL COMMENT '',
    sex CHAR(1) NOT NULL COMMENT '`F` female, `M` male',
    name VARCHAR(20) NULL DEFAULT NULL COMMENT 'When <NULL> means it is the Month Total',
    count MEDIUMINT(5) UNSIGNED NULL DEFAULT NULL COMMENT '',
    prop DECIMAL(6, 5) UNSIGNED NULL DEFAULT NULL COMMENT 'When <1> means it is the Month Total',
    ranking TINYINT(2) UNSIGNED NOT NULL COMMENT 'When <0> means it is the Month Total',
    UNIQUE KEY (`year`, `month`, `sex`, `name`),
    KEY `ranking` (`ranking`)
"
dd_create_dbtable('ew_months', dbn, x)

# TABLE ew_regions
x = "
    year SMALLINT(4) UNSIGNED NOT NULL COMMENT '',
    region CHAR(25) NOT NULL COMMENT 'Even if technically a Country, Wales is included for completeness',
    sex CHAR(1) NOT NULL COMMENT '`F` female, `M` male',
    name VARCHAR(20) NULL DEFAULT NULL COMMENT 'When <NULL> means it is the Region Total',
    count MEDIUMINT(5) UNSIGNED NULL DEFAULT NULL COMMENT '',
    prop DECIMAL(6, 5) UNSIGNED NULL DEFAULT NULL COMMENT 'When <1> means it is the Region Total',
    ranking TINYINT(2) UNSIGNED NOT NULL COMMENT 'When <0> means it is the Region Total',
    UNIQUE KEY (`year`, `region`, `sex`, `name`),
    KEY `ranking` (`ranking`)
"
dd_create_dbtable('ew_regions', dbn, x)

# TABLE ew_countries
x = "
    year SMALLINT(4) UNSIGNED NOT NULL COMMENT '',
    country CHAR(9) NOT NULL COMMENT '',
    sex CHAR(1) NOT NULL COMMENT '`F` female, `M` male',
    name VARCHAR(20) NULL DEFAULT NULL COMMENT '',
    count MEDIUMINT(5) UNSIGNED NULL DEFAULT NULL COMMENT '',
    prop DECIMAL(6, 5) UNSIGNED NULL DEFAULT NULL COMMENT '',
    ranking TINYINT(2) UNSIGNED NOT NULL COMMENT '',
    rank_other SMALLINT(4) UNSIGNED NOT NULL COMMENT '',
    UNIQUE KEY (`year`, `country`, `sex`, `name`),
    KEY `ranking` (`ranking`),
    KEY `rank_other` (`rank_other`)
"
dd_create_dbtable('ew_countries', dbn, x)

# TABLE ew_lads
x = "
    year SMALLINT(4) UNSIGNED NOT NULL COMMENT `2018-2020',
    LAD CHAR(9) NOT NULL COMMENT 'ONS code for the English Local Authority Districts',
    LADn VARCHAR(25) NOT NULL COMMENT '',
    sex CHAR(1) NOT NULL COMMENT '`F` female, `M` male',
    name VARCHAR(20) NOT NULL COMMENT '',
    UNIQUE KEY (`year`, `LAD`, `sex`)
"
dd_create_dbtable('ew_lads', dbn, x)

# TABLE ew_ages
x = "
    year SMALLINT(4) UNSIGNED NOT NULL COMMENT '',
    age CHAR(25) NOT NULL COMMENT '',
    sex CHAR(1) NOT NULL COMMENT '`F` female, `M` male',
    name VARCHAR(20) NOT NULL COMMENT '',
    ranking SMALLINT(3) UNSIGNED NOT NULL COMMENT '',
    UNIQUE KEY (`year`, `age`, `sex`, `name`),
    KEY `ranking` (`ranking`)
"
dd_create_dbtable('ew_ages', dbn, x)

rm(list = ls())
gc()
