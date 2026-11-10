# Annual Arctic anomalies with CDO and NCO together

This exercise follows the seminar's ACCESS-CM2 example. It produces the same 46 annual anomalies with **seven processing commands**. Run each command, inspect the result, and then continue.

## Installation

Choose one route. The CDO/NCO commands below run in a terminal, with no Python code required.

### macOS with Homebrew

If Homebrew is available:

```bash
brew install cdo nco
```

Homebrew installation instructions: <https://brew.sh/>.

### Ubuntu Linux, including Ubuntu inside Windows WSL

```bash
sudo apt update
sudo apt install cdo nco
```

On Windows 10 version 2004 or later, or Windows 11, first open **PowerShell as administrator** and run:

```powershell
wsl --install
```

Restart if requested. Open Ubuntu, create the Linux username/password, and run the two Ubuntu installation commands there. CDO is not supplied as a native Windows executable by the conda package. Use Ubuntu/WSL for this joint exercise.

### An isolated environment with Miniforge

This route works on macOS, Linux, and **inside Ubuntu/WSL**. Download the installer matching the operating system and processor from <https://conda-forge.org/download/>. After installing Miniforge, open a new terminal:

```bash
conda create -n climate -c conda-forge --override-channels cdo nco
conda activate climate
```

`--override-channels` keeps the environment's packages in conda-forge. This option belongs to installation, not the scientific calculation.

### Check the installation

```bash
cdo -V
ncks --version
```

These commands should print a version. `ncks` is one executable in the NCO collection. NCO has several commands rather than one `nco` program.

## Data and calculation

Work in a directory containing these inputs, using the same short names as the seminar:

| File | Contents |
|---|---|
| `data/historical.nc` | ACCESS-CM2 monthly `tas`, historical, 1850–2014 |
| `data/ssp585.nc` | ACCESS-CM2 monthly `tas`, SSP5-8.5, 2015–2100 |

Both files use member `r1i1p1f1`, grid `gn`, and temperatures in Kelvin.

Use the same downloads supplied for the seminar, or obtain them from the source links below. Create a `data` folder and save or rename the files to the two short names in the table. These are approximately 225 MB in total, so allow download time before the exercise.

- [Historical file](https://nc.uni-bremen.de/index.php/s/jRtQpitqdTD5fEc/download)
- [SSP5-8.5 file](https://raw.githubusercontent.com/egalytska/Fresh_eyes/040b9c7962355b1f8fa1312b7af867b458102b85/tas_Amon_ACCESS-CM2_ssp585_r1i1p1f1_gn_201501-210012.nc)

The original source filenames begin with `tas_Amon_ACCESS-CM2_`. Keep those original downloads, and use copies named `historical.nc` and `ssp585.nc` for the exercise. On another computer, use actual NetCDF files rather than the presenter's local data links.

Create a new output directory once:

```bash
mkdir mixed
```

The scientific choices remain the same as the Binder short lesson:

| Choice | Value |
|---|---|
| Analysis period | January 1979–December 2024, 552 months |
| Region | Latitude centres 65–90°N, all longitudes |
| Spatial average | Equal weight for each selected grid point |
| Annual average | Equal weight for each of the twelve monthly samples |
| Reference period | 1981–2010, 30 annual means |
| Final result | 46 annual Arctic temperature anomalies |

**A temperature difference has the same numerical value in K and °C.** We keep intermediate temperatures in K, subtract the reference, then label the resulting difference as °C. There is no need to subtract 273.15 from both sides of a subtraction.

## 1. Select the years and join both files

```bash
ncrcat -v tas -d time,1979-01-01,2024-12-31 data/historical.nc data/ssp585.nc mixed/merged.nc
```

`ncrcat` selects time records from the two files and joins them. The inputs are written in chronological order. `-v tas` selects the temperature variable and its associated coordinates. `-d time,...` selects the date interval.

Inspect:

```bash
cdo ntime mixed/merged.nc
```

Expected: **552** monthly records.

## 2. Select the Arctic

```bash
cdo -b F64 sellonlatbox,0,360,65,90 mixed/merged.nc mixed/arctic.nc
```

`sellonlatbox` selects longitude and latitude limits. `-b F64` retains double precision in the following calculations, as in the seminar's CDO route.

Inspect:

```bash
cdo ngridpoints mixed/arctic.nc
```

Expected: **3840** grid points, from 20 latitude rows and 192 longitude columns.

## 3. Average the Arctic grid points

```bash
cdo fldmean,weights=false mixed/arctic.nc mixed/arctic_monthly.nc
```

`weights=false` gives every grid point the same weight. This reproduces the seminar definition; it is not an area-weighted average.

Inspect:

```bash
cdo outputtab,date,value -seltimestep,1/3 mixed/arctic_monthly.nc
```

Expected first three values, still in K:

| Month | Arctic temperature |
|---|---:|
| January 1979 | 242.360191 |
| February 1979 | 241.876544 |
| March 1979 | 246.589079 |

## 4. Average each complete year

```bash
cdo yearmean mixed/arctic_monthly.nc mixed/annual_temperature.nc
```

Each year contains twelve monthly samples. `yearmean` averages those samples with equal weight.

Inspect:

```bash
cdo ntime mixed/annual_temperature.nc
```

Expected: **46** annual temperatures.

## 5. Select and average the reference years

```bash
ncra -d time,1981-01-01,2010-12-31 mixed/annual_temperature.nc mixed/reference.nc
```

`ncra` averages the selected records. Here the records are already annual means, so one command selects the 30 reference years and averages them.

Inspect:

```bash
cdo output mixed/reference.nc
```

Expected: approximately **257.242 K**. The full value is 257.241615876445 K, equivalent to −15.908384123555 °C.

## 6. Subtract the reference temperature

```bash
cdo sub mixed/annual_temperature.nc mixed/reference.nc mixed/annual_anomaly.nc
```

The second input has one reference value. CDO uses it for all 46 years. The message about copying the first timestep is normal: the reference value is repeated for the subtraction.

Inspect:

```bash
cdo outputtab,date,value -seltimestep,1/5 mixed/annual_anomaly.nc
```

| Year | Annual anomaly, °C |
|---|---:|
| 1979 | 0.298596 |
| 1980 | −0.955143 |
| 1981 | −0.489441 |
| 1982 | −0.067479 |
| 1983 | −0.802696 |

The values are already temperature differences. The next command updates their description.

## 7. Describe the anomaly in the file

```bash
ncatted -a units,tas,o,c,degC -a standard_name,tas,o,c,air_temperature_anomaly -a cell_measures,tas,d,, mixed/annual_anomaly.nc
```

`ncatted` edits attributes. `-a` uses `attribute,variable,mode,type,value`: `o` overwrites an attribute, `c` means text, and `d` deletes an attribute. This command sets the anomaly unit and standard name, then removes the inherited reference to an unavailable cell-area variable. It does not change the numbers.

Inspect:

```bash
cdo showunit mixed/annual_anomaly.nc
```

Expected: **degC**.

## Compare the final result

The final file is `mixed/annual_anomaly.nc`, variable `tas`. It can be plotted alongside the seminar files:

| Route | File | Variable |
|---|---|---|
| Independent Python reference | `python/arctic_annual.nc` | `tas_anom` |
| CDO | `cdo/annual_anomaly.nc` | `tas` |
| NCO | `nco/annual_anomaly.nc` | `tas` |
| Mixed exercise | `mixed/annual_anomaly.nc` | `tas` |

When the seminar's CDO output is available in the same working directory, inspect the differences directly:

```bash
cdo sub mixed/annual_anomaly.nc cdo/annual_anomaly.nc mixed/difference.nc
```

```bash
cdo output mixed/difference.nc
```

All 46 values should be close to zero. The validated run gives differences of approximately 10⁻¹³ °C, from floating-point rounding. These two verification commands follow the seven processing steps.

The local validation on 10 November 2026 used the real ACCESS-CM2 inputs and CDO 2.5.0 / NCO 5.3.9. All seven commands completed. The final 46 anomalies differed from the independent Python reference by at most **1.02 × 10⁻¹³ °C**. Their 1981–2010 mean was within **2.4 × 10⁻¹⁴ °C** of zero. Small round-off differences across software versions are expected.

This comparison concerns the final annual anomalies. The intermediate annual temperature and reference files in this mixed workflow remain in K. The original seminar files store them in °C. The short exercise does not create monthly anomaly fields or the duration-weighted anomaly map.

## Small-group exercises

1. **Predict before running:** how many records should steps 1, 4, and 5 produce? Explain why the answers are 552, 46, and 1.
2. **Find the savings:** identify which three operations `ncrcat` combines, and which two operations `ncra` combines. Explain why Kelvin-to-Celsius conversion cancels in the anomaly calculation.
3. **Change the region:** use 70°N instead of 65°N in a new output folder. Keep the same dates and weights. Predict whether the values should match the original result; they should not be expected to match because the region changed.
4. **Change the reference:** use 1991–2020. Recompute the reference and subtraction with new output filenames. Explain why all years shift by the same constant, while year-to-year differences stay the same.
5. **Discuss weights:** what would change if `weights=false` were removed? The CDO default uses grid-area weights where available. That is a different scientific definition, so it should not be used when claiming this exact comparison.

Suggested hands-on allocation: 5 minutes installation/checks, 15 minutes the seven steps, 5–10 minutes discussion or one extension. Operating-system installation or downloads may need more time. Binder remains available if a participant's installation is still running.

## Installation and command references

Checked 10 November 2026:

- Homebrew CDO: <https://formulae.brew.sh/formula/cdo>
- Homebrew NCO: <https://formulae.brew.sh/formula/nco>
- Miniforge installers: <https://conda-forge.org/download/>
- CDO conda installation and Windows limitation: <https://code.mpimet.mpg.de/projects/cdo/wiki/Anaconda>
- Microsoft WSL installation: <https://learn.microsoft.com/en-us/windows/wsl/install>
- Ubuntu CDO package: <https://packages.ubuntu.com/noble/cdo>
- Ubuntu NCO package: <https://packages.ubuntu.com/noble/nco>
- NCO installation: <https://nco.sourceforge.net/>
- NCO command manual: <https://nco.sourceforge.net/nco.html>
- CDO manual: <https://code.mpimet.mpg.de/projects/cdo/embedded/cdo.pdf>

Verification receipt: `outputs/mixed_hands_on_final_20261110/validation.json`.
