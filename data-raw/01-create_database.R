####################################################
# UK Baby Names - Create MySQL database and tables #
####################################################

library(Rfuns)

dbn <- 'uk_babynames'

dd_create_db(dbn)

# TABLE babynames
x = "
    country CHAR(1) NOT NULL,
    year SMALLINT(5) UNSIGNED NOT NULL,
    sex CHAR(1) NOT NULL,
    name VARCHAR(20) NOT NULL,
    count MEDIUMINT(5) UNSIGNED NULL DEFAULT NULL,
    prop DECIMAL(6, 5) UNSIGNED NULL DEFAULT NULL,
    ranking SMALLINT(5) UNSIGNED NOT NULL,
    PRIMARY KEY (`country`, `year`, `sex`, `name`),
    KEY `ranking` (`ranking`)
"
dd_create_dbtable('babynames', dbn, x)

# TABLE ew_months
x = "
    year SMALLINT(5) UNSIGNED NOT NULL,
    month CHAR(3) NOT NULL,
    sex CHAR(1) NOT NULL,
    name VARCHAR(20) NULL DEFAULT NULL COMMENT 'When <NULL> means it is the Month Total',
    count MEDIUMINT(5) UNSIGNED NULL DEFAULT NULL,
    prop DECIMAL(6, 5) UNSIGNED NULL DEFAULT NULL COMMENT 'When <1> means it is the Month Total',
    ranking TINYINT(2) UNSIGNED NOT NULL COMMENT 'When <0> means it is the Month Total',
    UNIQUE KEY (`year`, `month`, `sex`, `name`),
    KEY `ranking` (`ranking`)
"
dd_create_dbtable('ew_months', dbn, x)

# TABLE ew_regions
x = "
    year SMALLINT(5) UNSIGNED NOT NULL,
    region CHAR(25) NOT NULL COMMENT 'Even if technically a Country, Wales is included for completeness',
    sex CHAR(1) NOT NULL,
    name VARCHAR(20) NULL DEFAULT NULL COMMENT 'When <NULL> means it is the Region Total',
    count MEDIUMINT(5) UNSIGNED NULL DEFAULT NULL,
    prop DECIMAL(6, 5) UNSIGNED NULL DEFAULT NULL COMMENT 'When <1> means it is the Region Total',
    ranking TINYINT(2) UNSIGNED NOT NULL COMMENT 'When <0> means it is the Region Total',
    UNIQUE KEY (`year`, `region`, `sex`, `name`),
    KEY `ranking` (`ranking`)
"
dd_create_dbtable('ew_regions', dbn, x)

# TABLE ew_age
x = "
    year SMALLINT(5) UNSIGNED NOT NULL,
    age CHAR(25) NOT NULL,
    sex CHAR(1) NOT NULL,
    name VARCHAR(20) NULL DEFAULT NULL COMMENT 'When <NULL> means it is the Region Total',
    count MEDIUMINT(5) UNSIGNED NULL DEFAULT NULL,
    prop DECIMAL(6, 5) UNSIGNED NULL DEFAULT NULL COMMENT 'When <1> means it is the Region Total',
    ranking TINYINT(2) UNSIGNED NOT NULL COMMENT 'When <0> means it is the Region Total',
    UNIQUE KEY (`year`, `age`, `sex`, `name`),
    KEY `ranking` (`ranking`)
"
dd_create_dbtable('ew_age', dbn, x)

rm(list = ls())
gc()

