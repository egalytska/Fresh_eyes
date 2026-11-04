"""
Plot temperature anomalies and Arctic warming stripes.

All data preprocessing is performed by the ESMValTool recipe.
This diagnostic only reads the preprocessed cubes and creates
the requested plots.
"""

import logging
from pathlib import Path

import iris
import matplotlib as mpl
import matplotlib.pyplot as plt
import numpy as np
import cartopy.crs as ccrs

from esmvaltool.diag_scripts.shared import (
    group_metadata,
    run_diagnostic,
)
from esmvaltool.diag_scripts.shared._base import (
    get_plot_filename,
)


logger = logging.getLogger(Path(__file__).stem)


# ============================================================
# PLOT MAP
# ============================================================

def plot_anomaly_map(cube, cfg):
    """Plot the time-mean temperature anomaly map."""

    logger.info("Creating temperature anomaly map")

    print("\nTemperature anomaly map")
    print(f"  units = {cube.units}")
    print(f"  shape = {cube.shape}")
    print(f"  min   = {np.nanmin(cube.data)}")
    print(f"  max   = {np.nanmax(cube.data)}")

    data = np.squeeze(cube.data)

    lon = cube.coord("longitude").points
    lat = cube.coord("latitude").points

    fig, ax = plt.subplots(
        figsize=(10, 5),
        subplot_kw={
            "projection": ccrs.Robinson()
        },
    )
    norm = mpl.colors.Normalize(vmin=-1, vmax=1)
    mesh = ax.pcolormesh(
        lon,
        lat,
        data,
        vmin=-0.8,
        vmax=0.8,
        transform=ccrs.PlateCarree(),
        cmap="coolwarm",
        shading="auto",
    )

    ax.coastlines(
        linewidth=0.7
    )

    ax.set_global()

    ax.set_title(
        "Near-Surface Air Temperature Anomalies, 1979-2024",
        fontsize=13,
    )

    cbar = fig.colorbar(
        mesh,
        ax=ax,
        orientation="horizontal",
        shrink=0.7,
        pad=0.05,
    )

    cbar.set_label(
        "Temperature anomaly (°C)"
    )

    output_file = get_plot_filename(
        "tas_anomaly_map",
        cfg,
    )

    fig.savefig(
        output_file,
        bbox_inches="tight",
        dpi=300,
    )

    plt.close(fig)

    logger.info(
        "Saved temperature anomaly map to %s",
        output_file,
    )


# ============================================================
# PLOT ARCTIC MONTHLY TIME SERIES
# ============================================================

def plot_arctic_timeseries(cube, cfg):
    """Plot the Arctic monthly temperature anomaly time series."""

    logger.info("Creating Arctic temperature time series")

    print("\nArctic monthly time series")
    print(f"  units = {cube.units}")
    print(f"  shape = {cube.shape}")
    print(f"  min   = {np.nanmin(cube.data)}")
    print(f"  max   = {np.nanmax(cube.data)}")

    temperature = np.asarray(
        cube.data,
        dtype=float,
    ).squeeze()

    time_coord = cube.coord("time")

    dates = time_coord.units.num2date(
        time_coord.points,
        only_use_cftime_datetimes=False,
        only_use_python_datetimes=True,
    )

    print(f"  first date = {dates[0]}")
    print(f"  last date  = {dates[-1]}")

    fig, ax = plt.subplots(
        figsize=(12, 5)
    )

    ax.plot(
        dates,
        temperature,
        linewidth=1.5,
    )

    ax.axhline(
        0,
        linewidth=0.8,
    )

    ax.set_xlabel(
        "Year"
    )

    ax.set_ylabel(
        "Temperature anomaly (°C)"
    )

    ax.set_title(
        "Temperature anomalies 1979-2024, 65-90°N"
    )

    ax.grid(
        True,
        alpha=0.3,
    )

    fig.tight_layout()

    output_file = get_plot_filename(
        "tas_arctic_timeseries",
        cfg,
    )

    fig.savefig(
        output_file,
        bbox_inches="tight",
        dpi=300,
    )

    plt.close(fig)

    logger.info(
        "Saved Arctic time series to %s",
        output_file,
    )


# ============================================================
# PLOT WARMING STRIPES
# ============================================================

def plot_warming_stripes(cube, cfg):
    """Plot Arctic warming stripes."""

    logger.info("Creating Arctic warming stripes")

    print("\nArctic warming stripes")
    print(f"  units = {cube.units}")
    print(f"  shape = {cube.shape}")
    print(f"  min   = {np.nanmin(cube.data)}")
    print(f"  max   = {np.nanmax(cube.data)}")

    # Annual means are already calculated by the recipe.
    temperature = np.asarray(
        cube.data,
        dtype=float,
    ).squeeze()

    print(
        f"  number of annual values = "
        f"{len(temperature)}"
    )

    # --------------------------------------------------------
    # Create 2D array for stripes
    # --------------------------------------------------------

    x = np.arange(
        len(temperature)
    )

    y = np.array(
        [0, 1]
    )

    temperature_2d = np.vstack(
        [
            temperature,
            temperature,
        ]
    )

    # --------------------------------------------------------
    # Symmetric colour scale
    # --------------------------------------------------------

    limit = np.nanmax(
        np.abs(temperature)
    )

    norm = mpl.colors.Normalize(
        vmin=-limit,
        vmax=limit,
    )

    # --------------------------------------------------------
    # Plot
    # --------------------------------------------------------

    fig, ax = plt.subplots(
        figsize=(10, 4)
    )

    ax.pcolormesh(
        x,
        y,
        temperature_2d,
        cmap=cfg.get(
            "colormap",
            "bwr",
        ),
        norm=norm,
        shading="auto",
    )

    ax.set_axis_off()

    ax.set_title(
        "Arctic warming stripes 1979-2024, 65-90°N",
        fontsize=13,
    )

    output_file = get_plot_filename(
        "tas_arctic_warming_stripes",
        cfg,
    )

    fig.savefig(
        output_file,
        bbox_inches="tight",
        dpi=300,
    )

    plt.close(fig)

    logger.info(
        "Saved Arctic warming stripes to %s",
        output_file,
    )




# ============================================================
# MAIN
# ============================================================

def main(cfg):
    """Run diagnostic."""

    # --------------------------------------------------------
    # Get metadata provided by ESMValTool
    # --------------------------------------------------------

    input_data = cfg["input_data"].values()

    # Use the same ESMValTool pattern as in the
    input_data = group_metadata(
        input_data,
        "variable_group",
    )

    print("\nVariables received from ESMValTool:")
    for variable_group, datasets in input_data.items():
        print(
            f"  {variable_group}: "
            f"{len(datasets)} file(s)"
        )

    # --------------------------------------------------------
    # Load preprocessed map
    # --------------------------------------------------------

    tas_map = iris.load_cube(
        input_data["tas_map"][0]["filename"]
    )

    # --------------------------------------------------------
    # Load preprocessed Arctic monthly time series
    # --------------------------------------------------------

    tas_arctic = iris.load_cube(
        input_data["tas_arctic"][0]["filename"]
    )

    # --------------------------------------------------------
    # Load preprocessed Arctic annual means
    # --------------------------------------------------------

    tas_arctic_annual = iris.load_cube(
        input_data["tas_arctic_annual"][0]["filename"]
    )

    # --------------------------------------------------------
    # Create plots
    # --------------------------------------------------------

    plot_anomaly_map(
        tas_map,
        cfg,
    )

    plot_arctic_timeseries(
        tas_arctic,
        cfg,
    )

    plot_warming_stripes(
        tas_arctic_annual,
        cfg,
    )

    logger.info("Diagnostic finished successfully.")


# ============================================================
# RUN DIAGNOSTIC
# ============================================================

if __name__ == "__main__":

    with run_diagnostic() as config:
        main(config)