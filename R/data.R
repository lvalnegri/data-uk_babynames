#' @importFrom data.table data.table
NULL

#' babynames
#'
#' 
#' 
#' @format A data.table with the following columns:
#' \describe{
#'   \item{\code{ country }}{ Country of Residence: 
#'                            - `E`ngland and Wales,
#'                            - `S`cotland,
#'                            - `N`orthern Ireland.
#'   }
#'   \item{\code{ year }}{ Year:
#'                         - England: 1904, 1914, ..., 1994, 1996, 1997, ..., 2020.
#'                         - Scotland:  .
#'                         - Northern Ireland: .
#'   }
#'   \item{\code{ sex }}{ Sex: `F`emale, `M`ale.}
#'   \item{\code{ name }}{ BabyName }
#'   \item{\code{ count }}{ Number of babies (not available for 
#'                          England and Wales for the years: 1904, 1914, ..., 1994)
#'   }
#'   \item{\code{ prop }}{ Proportion of babies born within specified country, sex and year
#'                         (when `count` is available)
#'   }
#'   \item{\code{ ranking }}{ Rank with *minimum* ties within specified country, sex and year }
#' }
#' 
#'  For more information see:
#'  - [ONS for England and Wales](https://www.ons.gov.uk/peoplepopulationandcommunity/birthsdeathsandmarriages/livebirths/bulletins/babynamesenglandandwales/latest)
#'  - [ONS for Scotland]()
#'  - [ONS for Northern Ireland]()
#'
'babynames'

