#' Generate Metadata Summary with Additional Statistics
#'
#' This function retrieves and saves metadata for all tables in the IRW datasource.
#' Metadata includes table name, row count, column names, number of unique IDs,
#' number of unique items, and sparsity (average attempts per item).
#'
#' @return A data frame with metadata for each table.
#' @export
generate_metadata_summary <- function() {
  ds <- initialize_datasource()
  tables <- ds$list_tables()
  num_tables <- length(tables)

  # Preallocate metadata summary data frame
  metadata_summary <- data.frame(
    table_name = character(num_tables),
    numRows = integer(num_tables),
    num_unique_ids = integer(num_tables),
    num_unique_items = integer(num_tables),
    sparsity = numeric(num_tables),
    columns = vector("list", num_tables),
    stringsAsFactors = FALSE
  )

  # Initialize progress bar
  pb <- txtProgressBar(min = 0, max = num_tables, style = 3)

  for (i in seq_len(num_tables)) {
    table <- tables[[i]]
    table_metadata <- table$properties
    columns <- sapply(table$list_variables(), function(var) var$name)

    # Initialize variables
    num_unique_ids <- NA
    num_unique_items <- NA
    sparsity <- NA

    # Check if 'id' and 'item' columns exist in the table
    if (all(c("id", "item") %in% columns)) {
      # Construct SQL query to select 'id' and 'item' columns
      query_string <- sprintf("SELECT id, item FROM `%s`", table_metadata$name)

      # Execute the query
      query <- redivis::query(query_string)
      df <- tryCatch(
        query$to_tibble(),
        error = function(e) {
          warning(paste("Failed to retrieve data for table:", table_metadata$name, "-", e$message))
          return(NULL)
        }
      )

      # Calculate unique IDs, unique items, and sparsity if data frame is available
      if (!is.null(df) && nrow(df) > 0) {
        num_unique_ids <- length(unique(df$id))
        num_unique_items <- length(unique(df$item))
        if (num_unique_items > 0) {
          sparsity <- nrow(df) / num_unique_items
        }
      }
    }

    # Assign values to the preallocated data frame
    metadata_summary$table_name[i] <- table_metadata$name
    metadata_summary$numRows[i] <- table_metadata$numRows
    metadata_summary$num_unique_ids[i] <- num_unique_ids
    metadata_summary$num_unique_items[i] <- num_unique_items
    metadata_summary$sparsity[i] <- sparsity
    metadata_summary$columns[[i]] <- columns

    # Update progress bar
    setTxtProgressBar(pb, i)
  }

  # Close progress bar
  close(pb)

  save(metadata_summary, file = "data/metadata_summary.RData")
  return(metadata_summary)
}
