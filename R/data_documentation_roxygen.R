#' Metadata Summary for IRW Tables with Additional Statistics
#'
#' A dataset containing metadata for each table in the IRW datasource.
#' This dataset provides an overview of table characteristics, including the table name,
#' number of rows, unique ID count, unique item count, sparsity, and column names.
#'
#' @format A data frame with columns:
#' \describe{
#'   \item{table_name}{Name of the table (character)}
#'   \item{numRows}{Number of rows in the table (integer)}
#'   \item{num_unique_ids}{Number of unique IDs in the table (integer)}
#'   \item{num_unique_items}{Number of unique items in the table (integer)}
#'   \item{sparsity}{Average number of attempts per item (numeric)}
#'   \item{columns}{List of column names within the table (list of character vectors)}
#' }
#' @usage data(metadata_summary)
#' @examples
#' \dontrun{
#'   # Load and view metadata summary
#'   data(metadata_summary)
#'   head(metadata_summary)
#' }
"metadata_summary"
