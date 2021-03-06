#' @title Summary of Mann-Whitney-Test as HTML table
#' @name sjt.mwu
#'
#' @description Shows the results of a Mann-Whitney-U-test as HTML table. The results
#'                from the Mann-Whitney-test are obtained by the \code{\link[sjstats]{mwu}}
#'                function from the \pkg{sjstats}-package.
#'
#' @param x Results of a Mann-Whitney-U test, provided by \code{\link[sjstats]{mwu}}. See 'Examples'.
#'
#' @inheritParams sjt.frq
#' @inheritParams sjt.df
#'
#' @return Invisibly returns a \code{\link{list}} with
#'          \itemize{
#'            \item the data frame with the description information (\code{data}),
#'            \item the web page style sheet (\code{page.style}),
#'            \item the web page content (\code{page.content}),
#'            \item the complete html-output (\code{output.complete}) and
#'            \item the html-table with inline-css for use with knitr (\code{knitr})
#'            }
#'            for further use.
#'
#' @note See 'Notes' in \code{\link{sjt.frq}}.
#'
#' @details See 'Details' in \code{\link{sjt.frq}}.
#'
#' @examples
#' \dontrun{
#' library(sjstats)
#' data(efc)
#' sjt.mwu(mwu(efc$e17age, efc$e42dep))}

#' @export
sjt.mwu <- function(x,
                    title = NULL,
                    altr.row.col = TRUE,
                    CSS = NULL,
                    encoding = NULL,
                    file = NULL,
                    use.viewer = TRUE,
                    no.output = FALSE,
                    remove.spaces = TRUE) {
  # --------------------------------------------------------
  # check correct class
  # --------------------------------------------------------
  if (!inherits(x, "mwu")) {
    stop("`x` must be of class `mwu`, as returned by the `mwu()`-function of the sjstats-package.", call. = F)
  }
  # --------------------------------------------------------
  # check p-value-style option
  # --------------------------------------------------------
  opt <- getOption("p_zero")
  if (is.null(opt) || opt == FALSE) {
    p_zero <- ""
  } else {
    p_zero <- "0"
  }
  # --------------------------------------------------------
  # fix p- ans r-values
  # --------------------------------------------------------
  x$tab.df$p <- sub("0", p_zero, x$tab.df$p, fixed = T)
  x$tab.df$Effect.Size <- sub("0", p_zero, x$tab.df$Effect.Size, fixed = T)
  # --------------------------------------------------------
  # print table and return results
  # --------------------------------------------------------
  html <- sjt.df(x$tab.df,
                 title = title,
                 describe = F,
                 show.rownames = F,
                 altr.row.col = altr.row.col,
                 CSS = CSS,
                 no.output = T,
                 encoding = encoding,
                 hide.progress = T,
                 remove.spaces = remove.spaces)
  # -------------------------------------
  # check if html-content should be printed
  # -------------------------------------
  #out.html.table(no.output, file, html$knitr, html$output.complete, use.viewer)
  structure(
    class = c("sjTable", "sjtmwu"),
    list(
      page.style = html$page.style,
      #page.content.list = page.content.list,
      page.content = html$page.content,
      output.complete = html$output.complete,
      knitr = html$knitr,
      header = html$header,
      file = file,
      show = !no.output,
      use.viewer = use.viewer,
      df = x$tab.df
    )
  )

}
