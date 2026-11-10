# Annual Arctic anomalies: one command, one result

Use these same processing commands in a terminal or in the short notebook.
CDO and NCO each start from the original input files and calculate the annual
result independently. The [mixed hands-on](HANDS_ON_MIXED_ANNUAL.md) combines them.

## Set up a new local run

Start in the `CDO&NCO` directory with the environment active and data downloaded
as described in [README.md](../README.md). Use a fresh `demo` folder. For another
run, choose a different folder name so existing outputs are preserved.

```bash
mkdir demo
mkdir demo/data demo/cdo demo/nco
cp data/access_cm2/tas_Amon_ACCESS-CM2_historical_r1i1p1f1_gn_185001-201412.nc demo/data/historical.nc
cp data/access_cm2/tas_Amon_ACCESS-CM2_ssp585_r1i1p1f1_gn_201501-210012.nc demo/data/ssp585.nc
cd demo
```

The final comparison uses an independent Python reference. Generate it from
the same two raw files:

```bash
python ../scripts/run_python_updated.py data/historical.nc data/ssp585.nc python
```

## Inspect the inputs

```bash
cdo sinfo data/historical.nc
cdo sinfo data/ssp585.nc
```

Each route selects 1979–2024, averages latitude centres 65–90°N with equal
grid-point weights and twelve months per year with equal weights, then subtracts
the 1981–2010 mean. Expect 552 months and 46 annual values.

## CDO 01 · Select historical months

```bash
cdo selyear,1979/2014 data/historical.nc cdo/historical.nc
```

Inspect:

```bash
cdo ntime cdo/historical.nc
```

Expected: 432 monthly records.

## CDO 02 · Select future months

```bash
cdo selyear,2015/2024 data/ssp585.nc cdo/ssp585.nc
```

Inspect:

```bash
cdo ntime cdo/ssp585.nc
```

Expected: 120 monthly records.

## CDO 03 · Join the experiments

```bash
cdo -b F64 mergetime cdo/historical.nc cdo/ssp585.nc cdo/merged.nc
```

Inspect:

```bash
cdo ntime cdo/merged.nc
```

Expected: 552 monthly records.

## CDO 04 · Convert Kelvin values to Celsius

```bash
cdo subc,273.15 cdo/merged.nc cdo/celsius_raw.nc
```

Inspect:

```bash
cdo infon -seltimestep,1 cdo/celsius_raw.nc
```

Expected: First month: minimum about -44.975, mean 3.5016, maximum 36.396.

## CDO 05 · Label the converted values

```bash
cdo setunit,degC cdo/celsius_raw.nc cdo/celsius.nc
```

Inspect:

```bash
cdo showunit cdo/celsius.nc
```

Expected: degC.

## CDO 06 · Select the Arctic

```bash
cdo sellonlatbox,0,360,65,90 cdo/celsius.nc cdo/arctic.nc
```

Inspect:

```bash
cdo ngridpoints cdo/arctic.nc
```

Expected: 3840 grid points.

## CDO 07 · Average the Arctic grid points

```bash
cdo fldmean,weights=false cdo/arctic.nc cdo/arctic_monthly.nc
```

Inspect:

```bash
cdo outputtab,date,value -seltimestep,1/3 cdo/arctic_monthly.nc
```

Expected: First three months: -30.789809, -31.273456, -26.560921 degC.

## CDO 08 · Average each complete year

```bash
cdo yearmean cdo/arctic_monthly.nc cdo/annual_temperature.nc
```

Inspect:

```bash
cdo ntime cdo/annual_temperature.nc
```

Expected: 46 annual records.

## CDO 09 · Select the reference years

```bash
cdo selyear,1981/2010 cdo/annual_temperature.nc cdo/baseline.nc
```

Inspect:

```bash
cdo ntime cdo/baseline.nc
```

Expected: 30 reference years.

## CDO 10 · Calculate the reference temperature

```bash
cdo timmean cdo/baseline.nc cdo/reference.nc
```

Inspect:

```bash
cdo output cdo/reference.nc
```

Expected: Reference temperature: approximately -15.9084 degC.

## CDO 11 · Subtract the reference

```bash
cdo sub cdo/annual_temperature.nc cdo/reference.nc cdo/annual_anomaly.nc
```

Inspect:

```bash
cdo outputtab,date,value -seltimestep,1/5 cdo/annual_anomaly.nc
```

Expected: First five anomalies: 0.298596, -0.955143, -0.489441, -0.067479, -0.802696 degC.

## NCO 01 · Select historical months

```bash
ncks -v tas -d time,1979-01-01,2014-12-31 data/historical.nc nco/historical.nc
```

Inspect:

```bash
ncks -m -C -v tas nco/historical.nc
```

Expected: time = UNLIMITED (432 currently).

## NCO 02 · Select SSP5-8.5 months

```bash
ncks -v tas -d time,2015-01-01,2024-12-31 data/ssp585.nc nco/ssp585.nc
```

Inspect:

```bash
ncks -m -C -v tas nco/ssp585.nc
```

Expected: time = UNLIMITED (120 currently).

## NCO 03 · Join historical and SSP5-8.5

```bash
ncrcat nco/historical.nc nco/ssp585.nc nco/merged.nc
```

Inspect:

```bash
ncks -m -C -v tas nco/merged.nc
```

Expected: time = UNLIMITED (552 currently).

## NCO 04 · Convert Kelvin to Celsius

```bash
ncap2 -s 'tas=double(tas)-273.15;tas@units="degC";' nco/merged.nc nco/celsius.nc
```

Inspect:

```bash
ncks -H -C -v tas -d time,0 -d lat,0 -d lon,0 nco/celsius.nc
```

Expected: First month, first grid point: -19.812841796875 degC.

## NCO 05 · Calculate the monthly Arctic temperature

```bash
ncwa -a lat,lon -d lat,65.0,90.0 nco/celsius.nc nco/arctic_monthly.nc
```

Inspect:

```bash
ncks -H -C -v tas -d time,0,11 nco/arctic_monthly.nc
```

Expected: First 12 Arctic monthly values; January approximately -30.789809 degC.

## NCO 06 · Calculate the annual Arctic temperature

```bash
ncra --mro -C -v tas,time -d time,,,12,12 nco/arctic_monthly.nc nco/annual_temperature.nc
```

Inspect:

```bash
ncks -m -C -v tas nco/annual_temperature.nc
```

Expected: time = UNLIMITED (46 currently).

## NCO 07 · Calculate the 1981–2010 reference temperature

```bash
ncwa -a time -d time,1981-01-01,2010-12-31 nco/annual_temperature.nc nco/reference.nc
```

Inspect:

```bash
ncks -H -C -v tas nco/reference.nc
```

Expected: tas = approximately -15.9083841235544 degC.

## NCO 08 · Subtract the reference temperature

```bash
ncdiff nco/annual_temperature.nc nco/reference.nc nco/annual_anomaly.nc
```

Inspect:

```bash
ncks -H -C -v tas -d time,0,4 nco/annual_anomaly.nc
```

Expected: First five anomalies: 0.298596, -0.955143, -0.489441, -0.067479, -0.802696 degC.

## NCO 09 · Label the annual anomaly

```bash
ncatted -a bounds,time,d,, -a coordinates,tas,d,, -a cell_measures,tas,d,, -a standard_name,tas,o,c,air_temperature_anomaly nco/annual_anomaly.nc
```

Inspect:

```bash
ncks -m -C -v tas nco/annual_anomaly.nc
```

Expected: 46 records; units = degC; standard_name = air_temperature_anomaly.

## Compare the three annual series

Read the plotting script to see its three explicit inputs:

```bash
less ../scripts/compare_short_annual.py
```

Press `q` to return to the prompt, then run:

```bash
python ../scripts/compare_short_annual.py .
```

Both routes should print `PASS`. Open `short_comparison.png` in an image viewer.
The script reads `python/arctic_annual.nc`, `cdo/annual_anomaly.nc` and
`nco/annual_anomaly.nc`, plots their annual curves and climate stripes, and writes
`short_validation.json`. It also checks annual temperatures, the reference mean
and year/metadata consistency. Each stripe represents one year.
