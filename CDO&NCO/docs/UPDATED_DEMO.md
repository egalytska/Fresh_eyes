# Methods and local execution

Use [README.md](../README.md) to install the environment, download the inputs and
open a notebook. All commands run relative to the fresh results folder printed
by the notebook's Data cell. Repeat from that cell to create a new run.

The short annual notebook contains 46 executable cells: 20 CDO/NCO processing
commands, 20 result queries, and six support/display cells. It exposes the actual
comparison-script source and identifies its three plotted inputs:

| Input | Variable |
|---|---|
| `python/arctic_annual.nc` | `tas_anom` |
| `cdo/annual_anomaly.nc` | `tas` |
| `nco/annual_anomaly.nc` | `tas` |

The reference is independently calculated from the two original files using
monthly climatology and monthly anomalies. It is not a saved ESMValTool product.
The short comparison also validates annual temperatures, the reference mean,
subtraction, year labels, baseline residual and relevant output metadata.

All three notebooks use the fixed teaching interval 1979–2024. Inputs must
contain complete, ordered months, matching model/member/grid/calendar metadata,
and finite temperature values. The input checker rejects incompatible files.
The scenario file extends to 2100, but that does not extend the teaching lesson.

## Averaging choices

- Arctic latitude centres: 65–90°N; all longitudes; equal grid-point weights.
- Each annual mean averages twelve monthly samples equally.
- The reference covers 1981–2010.
- In the complete workflow only, the mean anomaly map uses month-duration
  weighting across 1979–2024.

For complete years and fixed spatial weights, the annual mean of monthly
anomalies equals annual temperature minus the mean of the thirty reference-year
temperatures. This shortcut must be reconsidered for missing months, varying
masks or changed weights. `fldmean,weights=false` intentionally reproduces the
shared equal-gridpoint definition rather than the default area weighting.

## Notebook and terminal syntax

The notebook registers the names `cdo`, `ncks`, `ncra` and the other NCO tools
with IPython. They execute their visible command strings directly without shell
expansion. Run the Data cell before these commands. Use the same command text
in a terminal, as in [SEMINAR_COMMANDS.md](SEMINAR_COMMANDS.md).

`-b F64` and `double(tas)` retain precision. `-C` limits queries to the requested
variables. In `ncra --mro -C -v tas,time -d time,,,12,12`, `--mro` produces multiple
output records: start a group every twelve records and average twelve records
per group. The inputs start in January and contain complete years.

CDO's `Filling up stream2 ... by copying the first timestep` message means the
single reference value is reused for each annual record; it is expected.
`ncatted` changes descriptions and links in metadata, not the numeric anomaly.

## Verification scope

The source annual lesson and full workflows were previously executed on real
ACCESS-CM2 inputs. Source annual comparison differences were about 6.4e-14°C
(CDO) and 2.6e-13°C (NCO), with 46 annual values. These are numerical agreement
checks against the independent Python calculation, not an ESMValTool execution.
The published companion annual lesson is pinned by the Binder link in README.

The included checker runs actual notebook cells in IPython without a kernel
socket. It reports that limitation in its JSON receipt. Synthetic mode is an
explicit test option only: set `WORKSHOP_MODE=synthetic` when intentionally
checking software, never as a substitute for the real-data lesson.
