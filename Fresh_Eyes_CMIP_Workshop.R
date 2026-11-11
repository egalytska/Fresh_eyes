# Fresh Eyes on CMIP Data Workshop 2026: climate stripes from CMIP6 data
# Period: 1979-2024

# =============================================================================
# HANDS-ON R: A SHORT INTRODUCTION (read this first if you are new to R)
# =============================================================================
#
# 1. WHAT IS R?
# -------------
# R is a free, open-source programming language built for statistics, data
# analysis and graphics. It is widely used in climate science, ecology,
# hydrology and epidemiology. You type commands (or run a script like this
# one), and R calculates, reads files, draws maps and saves figures.
#
# Two things are often confused:
#   - R        : the language and the engine that runs your code.
#   - RStudio  : a free program that makes R easier to use (editor, console,
#                plots, help in one window). You install R first, then RStudio.
#
# 2. THE R ENVIRONMENT (what you see in RStudio)
# ----------------------------------------------
#   Source (top left)       : where you write and edit scripts such as this
#                             file. Run the current line with Ctrl+Enter
#                             (Cmd+Enter on macOS). Run everything with
#                             "Source" (Ctrl+Shift+S).
#   Console (bottom left)   : where R executes commands and prints messages
#                             and errors. You can also type commands here.
#   Environment (top right) : the objects (variables, data) currently in R's
#                             memory. "Session > Restart R" clears them.
#   Files/Plots/Packages/Help (bottom right):
#                             browse files, see figures, manage packages and
#                             read documentation. In the console, ?function_name
#                             opens help, e.g. ?mean
#
# Key ideas you will meet in this script:
#   - Working directory : the folder R reads from and saves to by default.
#                         Check it with getwd(). Change it with setwd("path")
#                         or in RStudio: Session > Set Working Directory.
#                         This script saves its PNG figures and the folder
#                         "cmip6_data" in the working directory.
#   - Packages          : add-on toolkits (here httr, jsonlite, ncdf4, maps).
#                         Install ONCE with install.packages("name"), then load
#                         in every session with library(name).
#   - Objects           : you store results with the arrow  <-
#                         e.g.  x <- 5   or   tas <- tas - 273.15
#   - Comments          : any text after # is ignored by R (like this text).
#
# Try these in the console:
#   1 + 1
#   x <- c(10, 20, 30)      # c() combines values into a vector
#   mean(x)
#   x[1]                    # R counts from 1, not 0
#   getwd()
#
# 3. HOW R DIFFERS FROM PYTHON
# ----------------------------
# Both are free, popular and can do the same jobs. A few practical differences:
#
#   Purpose     R: designed for statistics and data analysis.
#               Python: general-purpose (web, automation, AI, science).
#   Assignment  R: x <- 5 (also x = 5).        Python: x = 5
#   Indexing    R: starts at 1, x[1] is the first element, and ranges include
#                  both ends (1:5 gives 1 2 3 4 5).
#               Python: starts at 0, and slices exclude the end (0:5 gives 0-4).
#   Code blocks R: curly braces { }.           Python: indentation.
#   Data tables R: data.frame is built in.     Python: needs pandas.
#   Vectors     R: operations work on whole vectors by default (x * 2).
#               Python: needs NumPy for this.
#   Packages    R: CRAN (install.packages).    Python: PyPI (pip install).
#   Calls       R: package::function(), e.g. ncdf4::nc_open(...)
#               Python: module.function(), e.g. xr.open_dataset(...)
#   Plots       R: base graphics, ggplot2.     Python: matplotlib, seaborn.
#   Climate     R: ncdf4, terra, stars.        Python: xarray, xclim (very
#   data                                        convenient for NetCDF).
#
#
# 4. INSTALLING R (and RStudio)
# -----------------------------
# Always install R first, then RStudio (called Posit RStudio Desktop).
#   R       : https://cran.r-project.org
#   RStudio : https://posit.co/download/rstudio-desktop/
# Tip: in an institution with restricted computers, ask IT to install both.
#
# --- Windows -----------------------------------------------------------------
#   1. Go to https://cran.r-project.org, click "Download R for Windows", then
#      "base", then download the installer (.exe).
#   2. Run the installer and accept the defaults.
#   3. Download and run the RStudio Desktop installer for Windows.
#   4. Open RStudio (not the plain "R" app) and use the Console to test.
#   Note: you only need "Rtools" if a package must be compiled from source.
#   The packages in this script normally install as ready-made binaries.
#
# --- macOS -------------------------------------------------------------------
#   1. Go to https://cran.r-project.org, click "Download R for macOS", and pick
#      the .pkg that matches your Mac: "arm64" for Apple silicon (M1/M2/M3/...)
#      or the Intel (x86_64) one. Check with  > About This Mac.
#   2. Open the .pkg and follow the installer.
#   3. Download and open the RStudio Desktop .dmg and drag RStudio into
#      Applications.
#   Alternative with Homebrew:   brew install --cask r
#   If R asks for command line tools when installing packages, run in the
#   Terminal:   xcode-select --install
#
# --- Linux -------------------------------------------------------------------
#   Ubuntu / Debian:
#       sudo apt update
#       sudo apt install r-base r-base-dev
#   Fedora / RHEL:       sudo dnf install R
#   Arch:                sudo pacman -S r
#   Distribution versions can be older. For the latest R on Ubuntu/Debian, see
#   the "Download R for Linux" page on https://cran.r-project.org for the CRAN
#   repository instructions.
#   Packages are often compiled on Linux, so install the system libraries
#   first (Ubuntu/Debian names):
#       sudo apt install libnetcdf-dev libcurl4-openssl-dev libssl-dev
#   Then install RStudio Desktop from the Posit page (.deb or .rpm), or work
#   in the terminal by typing  R  to start a console.
#

# 5. RUNNING THIS WORKSHOP SCRIPT
# -------------------------------
#   1. Save this file in a folder you can find, e.g. "CMIP_workshop".
#   2. In RStudio: File > Open File..., then set the working directory with
#      Session > Set Working Directory > To Source File Location.
#   3. Run section 0 (packages) first, then go section by section with
#      Ctrl+Enter, reading the messages in the Console.
#   4. The first run downloads a NetCDF file of about 200 MB. You need an
#      internet connection and free disk space. Later runs reuse it.
#   5. Figures are saved as PNG files in your working directory.
#
# Common problems:
#   "there is no package called 'xxx'"  -> install it (see section 0 below).
#   "could not find function 'xxx'"     -> run the library(...) lines first.
#   "cannot open file ..."              -> check getwd() and the file path.
#   Windows paths: use / or \\ in R paths, e.g. "C:/Users/me/data", not \
#
# =============================================================================
#  The workshop script starts from here.
# =============================================================================

# 0. Packages 
#install.packages(c("httr", "jsonlite", "ncdf4", "maps"))   # run once
library(httr)
library(jsonlite)
library(ncdf4)
library(maps)

# 1. Settings 
# If you already have the NetCDF file(s) on your computer, list them here (in
# time order, e.g. the historical file and then the scenario file) and the
# script skips the search/download:
#   LOCAL_FILES <- c("tas_Amon_ACCESS-CM2_historical_r1i1p1f1_gn_185001-201412.nc",
#                    "tas_Amon_ACCESS-CM2_ssp585_r1i1p1f1_gn_201501-210012.nc")
LOCAL_FILES <- NULL

ESGF_NODES <- c(
  "https://esgf-node.llnl.gov/esg-search/search",
  "https://esgf-data.dkrz.de/esg-search/search",
  "https://esgf-node.ipsl.upsl.fr/esg-search/search",
  "https://esgf.ceda.ac.uk/esg-search/search"
)

query <- list(
  project        = "CMIP6",
  table_id       = "Amon",
  institution_id = "CSIRO-ARCCSS",
  source_id      = "ACCESS-CM2",
  variable_id    = "tas",
  variant_label  = "r1i1p1f1"
)

# CMIP6 historical simulations end in 2014. To reach 2024 the script also
# downloads a scenario run (2015 onwards) and joins it to the historical one.
HIST_EXPERIMENT <- "historical"
SCENARIO        <- "ssp585"     # e.g. "ssp126", "ssp245", "ssp370", "ssp585"
HIST_END        <- 2014

REF_START  <- 1981   # reference period for the climatology (Fig. 1a of
REF_END    <- 2010   # https://www.nature.com/articles/s43247-022-00498-3)
START_YEAR <- 1979   # period to analyse
END_YEAR   <- 2024
stopifnot(REF_START >= START_YEAR, REF_END <= END_YEAR, REF_START < REF_END)

# Colour limits of the map (degC), symmetric around 0: -0.8 to 0.8
# NULL = automatic limits sized to the data; or give your own values, e.g. c(-1, 1).
#
MAP_LIMITS <- c(-0.8, 0.8)

LAT_MIN <- 65        # Arctic region, 65-90 N
LAT_MAX <- 90

AREA_WEIGHTED <- TRUE

# FALSE = download the whole file (~200 MB) from the ESGF server, save it in
#         DATA_DIR and read it locally (default; works on Windows/macOS/Linux,
#         and the file is reused on later runs)
# TRUE  = read only the needed slice remotely via OPeNDAP (needs an ncdf4
#         build with OPeNDAP support, usually Linux/macOS)
USE_OPENDAP <- FALSE
DATA_DIR    <- "cmip6_data"

# 2. Search ESGF for the file (only used if LOCAL_FILES is NULL) 
search_esgf <- function(query, nodes = ESGF_NODES) {
  params <- c(query, list(type = "File", latest = "true", distrib = "false",
                          limit = 200, format = "application/solr+json"))
  docs <- list()
  for (node in nodes) {
    message("Searching ", node, " ...")
    resp <- tryCatch(GET(node, query = params, timeout(60)),
                     error = function(e) NULL)
    if (is.null(resp) || status_code(resp) != 200) next
    js <- tryCatch(fromJSON(content(resp, as = "text", encoding = "UTF-8"),
                            simplifyVector = FALSE), error = function(e) NULL)
    d <- js$response$docs
    if (length(d) > 0) {
      message("  found ", length(d), " record(s)")
      docs <- c(docs, d)
    }
  }
  if (length(docs) == 0)
    stop("No files found on any ESGF node. Download the file manually and set ",
         "LOCAL_FILES at the top of the script.")
  parse_file_docs(docs)
}

# Prefer download servers that are usually reliable (NCI hosts ACCESS-CM2)
rank_urls <- function(u) {
  u <- unique(u[!is.na(u) & nzchar(u)])
  pref <- grepl("nci\\.org\\.au|dkrz|llnl|ceda|ipsl", u)
  u[order(!pref)]
}

# One row per file name; all replica URLs (from every node/data node) are kept
parse_file_docs <- function(docs) {
  res <- list()
  for (d in docs) {
    urls <- unlist(d$url)
    get  <- function(service)
      sub("\\|.*$", "", urls[grepl(paste0("\\|", service, "$"), urls)])
    fn <- d$title[[1]]
    res[[fn]]$http    <- c(res[[fn]]$http, get("HTTPServer"))
    res[[fn]]$opendap <- c(res[[fn]]$opendap, sub("\\.html$", "", get("OPENDAP")))
  }
  out <- data.frame(filename = names(res), stringsAsFactors = FALSE)
  out$http    <- unname(lapply(res, function(r) rank_urls(r$http)))
  out$opendap <- unname(lapply(res, function(r) rank_urls(r$opendap)))
  out
}

# All files of a search that overlap the years y_from..y_to, in time order
choose_files <- function(files, y_from, y_to) {
  m <- regmatches(files$filename,
                  regexec("_(\\d{4})\\d{2}-(\\d{4})\\d{2}\\.nc$", files$filename))
  y0 <- as.integer(vapply(m, function(x) if (length(x)) x[2] else NA_character_, ""))
  y1 <- as.integer(vapply(m, function(x) if (length(x)) x[3] else NA_character_, ""))
  ok <- which(y0 <= y_to & y1 >= y_from)
  if (length(ok) == 0)
    stop("No file on ESGF covers ", y_from, "-", y_to)
  files[ok[order(y0[ok])], ]
}

# 3. Time handling 
decode_time <- function(nc) {
  tvals <- ncvar_get(nc, "time")
  units <- ncatt_get(nc, "time", "units")$value
  cal   <- ncatt_get(nc, "time", "calendar")
  cal   <- if (isTRUE(cal$hasatt)) tolower(cal$value) else "standard"

  origin <- as.Date(sub(".*since\\s+(\\d{4}-\\d{1,2}-\\d{1,2}).*", "\\1", units))
  if (!grepl("^days", units)) stop("Unexpected time units: ", units)

  if (cal %in% c("standard", "gregorian", "proleptic_gregorian")) {
    d <- origin + floor(tvals)
    return(data.frame(year  = as.integer(format(d, "%Y")),
                      month = as.integer(format(d, "%m"))))
  }
  ylen   <- if (cal == "360_day") 360 else 365
  o_year <- as.integer(format(origin, "%Y"))
  years  <- o_year + floor(tvals / ylen)
  doy    <- tvals %% ylen
  mlen   <- if (ylen == 360) rep(30, 12) else c(31,28,31,30,31,30,31,31,30,31,30,31)
  month  <- findInterval(doy, c(0, cumsum(mlen)[-12]))
  data.frame(year = as.integer(years), month = as.integer(month))
}

# 4. Get the file(s): download from ESGF (or use local files) 
# A real NetCDF file starts with "CDF" (classic) or "\x89HDF" (NetCDF-4)
is_netcdf <- function(path) {
  if (!file.exists(path) || file.size(path) < 1e5) return(FALSE)
  h <- readBin(path, "raw", 4)
  identical(h[1:3], charToRaw("CDF")) || identical(h[2:4], charToRaw("HDF"))
}

get_file <- function(f) {
  opendap <- f$opendap[[1]]
  if (USE_OPENDAP && length(opendap) > 0) return(opendap[1])

  dir.create(DATA_DIR, showWarnings = FALSE)
  nc_path <- file.path(DATA_DIR, f$filename)
  if (file.exists(nc_path) && is_netcdf(nc_path)) {
    message("Using already downloaded file: ", nc_path)
    return(nc_path)
  }

  urls <- f$http[[1]]
  tmp  <- paste0(nc_path, ".part")
  for (u in urls) {
    message("Downloading ", f$filename, "\n  from ", u,
            "\n  (this can take a few minutes) ...")
    # try with normal certificate checking first, then without (some ESGF
    # data nodes have outdated certificates; the file itself is validated below)
    for (verify in c(TRUE, FALSE)) {
      ok <- "error"
      tryCatch({
        resp <- GET(u, write_disk(tmp, overwrite = TRUE), timeout(3600),
                    config(followlocation = TRUE, ssl_verifypeer = verify))
        if (status_code(resp) != 200) message("  HTTP status ", status_code(resp))
        ok <- if (status_code(resp) == 200 && is_netcdf(tmp)) "ok" else "bad"
      }, error = function(e) message("  failed: ", conditionMessage(e)))
      if (ok != "error") break   # only retry without SSL check after a connection error
    }
    ok <- identical(ok, "ok")
    if (ok) {
      file.rename(tmp, nc_path)
      return(nc_path)
    }
    message("  this server did not work, trying the next replica ...")
    unlink(tmp)
  }
  stop("Download failed from all ", length(urls), " server(s) for ", f$filename,
       ".\nTry again later, or download it manually from e.g.\n  ", urls[1],
       "\nand set LOCAL_FILES at the top of the script.")
}

if (!is.null(LOCAL_FILES)) {
  nc_paths <- LOCAL_FILES
} else {
  nc_paths <- character(0)
  # historical part (up to 2014)
  if (START_YEAR <= HIST_END) {
    files <- search_esgf(c(query, list(experiment_id = HIST_EXPERIMENT)))
    sel   <- choose_files(files, START_YEAR, min(END_YEAR, HIST_END))
    for (i in seq_len(nrow(sel))) {
      message("Using file: ", sel$filename[i])
      nc_paths <- c(nc_paths, get_file(sel[i, ]))
    }
  }
  # scenario part (2015 onwards)
  if (END_YEAR > HIST_END) {
    files <- search_esgf(c(query, list(experiment_id = SCENARIO)))
    sel   <- choose_files(files, max(START_YEAR, HIST_END + 1), END_YEAR)
    for (i in seq_len(nrow(sel))) {
      message("Using file: ", sel$filename[i])
      nc_paths <- c(nc_paths, get_file(sel[i, ]))
    }
  }
}

# 5. Read START_YEAR-END_YEAR and compute anomalies 
# Only the needed years are read from each file (much smaller than the full
# 1850-2100 record). The reference period (REF_START-REF_END) lies inside this slice.
tas_list <- list(); year <- integer(0); month <- integer(0)
lon <- lat <- NULL
for (nc_path in nc_paths) {
  nc <- tryCatch(nc_open(nc_path), error = function(e) {
    stop("Could not open ", nc_path, "\n  ", conditionMessage(e),
         "\n  If this is an OPeNDAP URL, try USE_OPENDAP <- FALSE.")
  })
  tm  <- decode_time(nc)
  idx <- which(tm$year >= START_YEAR & tm$year <= END_YEAR)
  if (length(idx) == 0) { nc_close(nc); next }
  stopifnot(all(diff(idx) == 1))

  lon_i <- ncvar_get(nc, "lon"); lat_i <- ncvar_get(nc, "lat")
  if (is.null(lon)) { lon <- lon_i; lat <- lat_i }
  stopifnot(length(lon_i) == length(lon), length(lat_i) == length(lat),
            max(abs(lat_i - lat)) < 1e-6)

  tas_list[[length(tas_list) + 1]] <-
    ncvar_get(nc, "tas", start = c(1, 1, min(idx)),
              count = c(-1, -1, length(idx)))               # [lon, lat, time]
  year  <- c(year,  tm$year[idx])
  month <- c(month, tm$month[idx])
  nc_close(nc)
}
stopifnot(length(tas_list) > 0)
tas <- array(unlist(tas_list), dim = c(length(lon), length(lat), length(year)))
rm(tas_list)
stopifnot(!anyDuplicated(year * 100 + month))   # no overlap between files

tas <- tas - 273.15                                         # Kelvin -> degC

# Monthly climatology over the reference period: array [lon, lat, 12]
tas_clim <- array(NA_real_, dim = c(dim(tas)[1:2], 12))
for (m in 1:12) {
  sel <- which(year >= REF_START & year <= REF_END & month == m)
  tas_clim[, , m] <- apply(tas[, , sel, drop = FALSE], c(1, 2), mean)
}

# Monthly anomalies relative to REF_START-REF_END: tas(t) - climatology(month(t))
tas_anom <- tas
for (i in seq_along(year)) tas_anom[, , i] <- tas[, , i] - tas_clim[, , month[i]]
rm(tas)

# 6. Map of the time-mean anomaly (Robinson projection) 
# Robinson projection (standard lookup table, linear interpolation)
robinson <- function(lon, lat) {
  tl <- seq(0, 90, by = 5)
  X  <- c(1.0000, 0.9986, 0.9954, 0.9900, 0.9822, 0.9730, 0.9600, 0.9427,
          0.9216, 0.8962, 0.8679, 0.8350, 0.7986, 0.7597, 0.7186, 0.6732,
          0.6213, 0.5722, 0.5322)
  Y  <- c(0.0000, 0.0620, 0.1240, 0.1860, 0.2480, 0.3100, 0.3720, 0.4340,
          0.4958, 0.5571, 0.6176, 0.6769, 0.7346, 0.7903, 0.8435, 0.8936,
          0.9394, 0.9761, 1.0000)
  a  <- abs(lat)
  list(x = 0.8487 * approx(tl, X, a)$y * lon * pi / 180,
       y = sign(lat) * 1.3523 * approx(tl, Y, a)$y)
}

# NaN-safe colour lookup (like vmin/vmax + cmap in matplotlib)
coolwarm <- colorRampPalette(c("#3B4CC0", "#6788EE", "#9ABBFF", "#C9D7F0",
                               "#EDD1C2", "#F7A889", "#E26952", "#B40426"))(256)

# Tick labels with a true minus sign (U+2212) as in matplotlib; falls back to
# a plain hyphen if R is not in a UTF-8 session or the device is a pdf file
minus_labels <- function(at) {
  lab <- as.character(round(at, 10))
  if (isTRUE(l10n_info()[["UTF-8"]]) && !(names(dev.cur()) %in% c("pdf", "postscript")))
    lab <- sub("^-", "\u2212", lab)
  lab
}

plot_robinson_map <- function(z, lon, lat, vmin, vmax, pal, title, cbar_label) {
  # shift longitudes from 0..360 to -180..180 and sort
  lon180 <- ((lon + 180) %% 360) - 180
  o      <- order(lon180)
  lon180 <- lon180[o]; z <- z[o, , drop = FALSE]

  # cell edges (midpoints between centres, clipped at the poles/dateline)
  edges <- function(v, lo, hi) {
    mid <- (v[-1] + v[-length(v)]) / 2
    c(max(lo, v[1] - (mid[1] - v[1])), mid,
      min(hi, v[length(v)] + (v[length(v)] - mid[length(mid)])))
  }
  lonE <- edges(lon180, -180, 180)
  latE <- edges(lat, -90, 90)

  nx <- length(lon180); ny <- length(lat)
  ii <- rep(seq_len(nx), times = ny)          # column (lon) index of each cell
  jj <- rep(seq_len(ny), each = nx)           # row (lat) index of each cell
  x0 <- lonE[ii]; x1 <- lonE[ii + 1]
  y0 <- latE[jj]; y1 <- latE[jj + 1]

  # 4 corners per cell, NA-separated so one polygon() call draws everything
  px <- as.vector(rbind(x0, x1, x1, x0, NA))
  py <- as.vector(rbind(y0, y0, y1, y1, NA))
  p  <- robinson(px, py)

  zc  <- pmin(pmax(as.vector(z), vmin), vmax)
  col <- pal[pmin(256, pmax(1, 1 + floor((zc - vmin) / (vmax - vmin) * 256)))]

  op <- par(mar = c(1, 1, 3, 1)); on.exit(par(op))
  plot(NA, xlim = c(-2.7, 2.7), ylim = c(-2.05, 1.5), asp = 1,
       axes = FALSE, xlab = "", ylab = "", main = title,
       font.main = 1, cex.main = 1.2)
  polygon(p$x, p$y, col = col, border = col, lwd = 0.3)   # border = fill: no white seams

  # coastlines
  cl <- map("world", interior = FALSE, plot = FALSE)   # coastlines only
  pc <- robinson(cl$x, cl$y)
  lines(pc$x, pc$y, lwd = 0.6)

  # globe outline
  b <- c(seq(-90, 90, length.out = 100), seq(90, -90, length.out = 100))
  s <- c(rep(-180, 100), rep(180, 100))
  ob <- robinson(s, b)
  polygon(ob$x, ob$y, border = "black", lwd = 1)

  # horizontal colour bar below the map, ticks every 0.2 as in the Python figure
  xs <- seq(-2.3, 2.3, length.out = 257)
  rect(xs[-257], -1.65, xs[-1], -1.47, col = pal, border = NA)
  rect(-2.3, -1.65, 2.3, -1.47, border = "black")
  tk <- if (vmax - vmin <= 2) seq(vmin, vmax, by = 0.2) else pretty(c(vmin, vmax), n = 8)
  tk <- tk[tk >= vmin - 1e-9 & tk <= vmax + 1e-9]
  tx <- -2.3 + (tk - vmin) / (vmax - vmin) * 4.6
  segments(tx, -1.65, tx, -1.70)
  text(tx, -1.80, labels = minus_labels(tk), cex = 0.8)
  text(0, -1.96, cbar_label, cex = 0.9)
}

anom_mean <- apply(tas_anom, c(1, 2), mean)         # mean over time
if (is.null(MAP_LIMITS)) {
  lim <- ceiling(quantile(abs(anom_mean), 0.99, na.rm = TRUE) * 10) / 10
  MAP_LIMITS <- c(-lim, lim)
}
message("Map colour limits: ", MAP_LIMITS[1], " to ", MAP_LIMITS[2], " degC")
map_title <- sprintf("Near-Surface Air Temperature Anomalies, %d-%d", START_YEAR, END_YEAR)
plot_robinson_map(anom_mean, lon, lat, vmin = MAP_LIMITS[1], vmax = MAP_LIMITS[2], pal = coolwarm,
                  title = map_title,
                  cbar_label = "Temperature anomaly (\u00B0C)")

# 7. Arctic (65-90 N) mean and line plot 
arc <- which(lat >= LAT_MIN & lat <= LAT_MAX)
if (AREA_WEIGHTED) {
  w <- cos(lat[arc] * pi / 180); w <- w / sum(w)
  arctic <- vapply(seq_along(year), function(i)
    sum(colMeans(tas_anom[, arc, i, drop = FALSE][, , 1]) * w), numeric(1))
} else {
  arctic <- vapply(seq_along(year), function(i)
    mean(tas_anom[, arc, i]), numeric(1))
}

# time axis for plotting (decimal year, mid-month)
t_dec <- year + (month - 0.5) / 12

plot_arctic_line <- function() {
  line_col <- "#1F77B4"                                  # blue
  # axis ranges with 5% margins and tick spacing as in the Python figure
  xr   <- range(t_dec); yr <- range(arctic)
  xlim <- xr + c(-1, 1) * 0.05 * diff(xr)
  ylim <- yr + c(-1, 1) * 0.05 * diff(yr)
  xt   <- seq(ceiling(START_YEAR / 5) * 5, floor(END_YEAR / 5) * 5 + 5, by = 5)  # every 5 years
  xt   <- xt[xt >= xlim[1] & xt <= xlim[2]]
  yt   <- pretty(ylim, n = 6)                    # round ticks (every 2 degC for this range)
  yt   <- yt[yt >= ylim[1] & yt <= ylim[2]]

  op <- par(mar = c(4.5, 5, 3, 1)); on.exit(par(op))
  plot(NA, xlim = xlim, ylim = ylim, xaxs = "i", yaxs = "i", axes = FALSE,
       xlab = "Year", ylab = "Temperature anomaly (\u00B0C)",
       main = sprintf("Temperature anomalies %d-%d, %d-%d\u00B0N",
                      START_YEAR, END_YEAR, LAT_MIN, LAT_MAX),
       font.main = 1, cex.main = 1.2)
  abline(v = xt, h = yt, col = "grey90", lwd = 0.8)      # light grid
  abline(h = 0, col = line_col, lwd = 0.8)               # zero line
  lines(t_dec, arctic, col = line_col, lwd = 1.5)
  axis(1, at = xt)
  axis(2, at = yt, labels = minus_labels(yt), las = 1)
  box()
}
plot_arctic_line()

png("arctic_anomaly_timeseries.png", width = 12, height = 5, units = "in", res = 200)
plot_arctic_line()
dev.off()

# 8. Climate stripes 
# Annual means (groupby('time.year').mean())
yearly <- tapply(arctic, year, mean)
annual <- data.frame(year = as.integer(names(yearly)), anomaly_C = as.numeric(yearly))
print(annual)

# 'bwr' colormap, symmetric limits around 0 (vmin = -limit, vmax = +limit)
make_stripes <- function(values, main = NULL) {
  pal    <- colorRampPalette(c("blue", "white", "red"))(256)
  limit  <- max(abs(values), na.rm = TRUE)
  breaks <- seq(-limit, limit, length.out = 257)
  n      <- length(values)
  op <- par(mar = c(0.8, 0.8, 3, 0.8), xaxs = "i", yaxs = "i"); on.exit(par(op))
  image(x = seq(0.5, n + 0.5), y = c(0, 1), z = matrix(values, ncol = 1),
        col = pal, breaks = breaks, axes = FALSE, xlab = "", ylab = "")
  title(main = main, font.main = 1, cex.main = 1.2)
}

stripes_title <- sprintf("Arctic warming stripes %d-%d, %d-%d\u00B0N",
                         START_YEAR, END_YEAR, LAT_MIN, LAT_MAX)
make_stripes(annual$anomaly_C, main = stripes_title)

# Save PNGs (stripes at 10 x 4 inches like the notebook, plus the map)
png("climate_stripes_arctic.png", width = 10, height = 4, units = "in", res = 200)
make_stripes(annual$anomaly_C, main = stripes_title)
dev.off()

png("anomaly_map.png", width = 10, height = 6, units = "in", res = 200)
plot_robinson_map(anom_mean, lon, lat, vmin = MAP_LIMITS[1], vmax = MAP_LIMITS[2], pal = coolwarm,
                  title = map_title,
                  cbar_label = "Temperature anomaly (\u00B0C)")
dev.off()

message("Saved anomaly_map.png, arctic_anomaly_timeseries.png and climate_stripes_arctic.png in ", getwd())

