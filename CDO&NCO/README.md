# CDO and NCO: climate-data processing

**Yiwen Li · Fresh Eyes on CMIP**

Start with the same ACCESS-CM2 historical and SSP5-8.5 monthly temperature files,
calculate Arctic temperature anomalies with CDO and NCO, and compare with an
independent Python reference. Run one visible command, then inspect its result.

## Start here

| Material | Use |
|---|---|
| [Short annual notebook](notebooks/05_annual_stripes_short_demo.ipynb) | Recommended seminar lesson: 11 CDO and 9 NCO processing commands |
| [Terminal demonstration](docs/SEMINAR_COMMANDS.md) | The same commands and result queries for local use |
| [CDO + NCO hands-on](docs/HANDS_ON_MIXED_ANNUAL.md) | Installation guidance and a seven-command combined workflow |
| [Complete workflow](notebooks/00_yl_20_minute_binder_demo.ipynb) | Monthly climatology, anomalies, map and Arctic series |
| [Extended practice](notebooks/04_monthly_anomaly_hands_on.ipynb) | Complete workflow plus region and weighting exercises |

**[Launch the short lesson on Binder](https://mybinder.org/v2/gh/YiwenLiEven/Fresh-Eyes-CDO-NCO-Workshop/db8212ef0e4e5483b0c47d392a8191a149e7fdc7?urlpath=lab/tree/notebooks/05_annual_stripes_short_demo.ipynb)**

The Binder link uses the versioned, configured companion repository. It opens
the same annual lesson. This `CDO&NCO` folder is a self-contained local code
contribution; a Binder launch from the parent repository does not automatically
use this folder's environment. The seven-command mixed exercise is included here
as a separate terminal guide.

## Run locally

With [Miniforge](https://conda-forge.org/download/) or another conda installation,
open a terminal at the `Fresh_eyes` repository root, then run:

```bash
cd 'CDO&NCO'
conda env create -f environment.yml
conda activate fresh-eyes
python scripts/fetch_updated_data.py
jupyter lab notebooks/05_annual_stripes_short_demo.ipynb
```

On Windows, use Ubuntu through WSL for these CDO/NCO commands. Quote the folder
name in a shell because `&` has a special meaning. Raw input files total about
225 MB and are downloaded separately; their URLs and checksums are recorded in
[data/manifest.json](data/manifest.json). The downloader verifies both files and
never replaces missing real data with synthetic data.

In Jupyter, run the Data cell first, then use **Shift+Enter** in order, including
collapsed support cells. Each run creates a fresh output folder. CDO/NCO commands
are written directly, without `!`, shell variables or processing-script wrappers.
Python support registers these command names in the notebook and calculates a
separate reference. The final comparison explicitly shows its three input files
and the complete [Python plotting script](scripts/compare_short_annual.py).

## Scientific definition

| Choice | Value |
|---|---|
| Data | ACCESS-CM2, monthly `tas`, `r1i1p1f1`, grid `gn` |
| Analysis | January 1979–December 2024: 552 months, 46 complete years |
| Arctic | Latitude centres 65–90°N, all longitudes |
| Spatial weights | Equal weight per selected grid point |
| Annual weights | Equal weight for the twelve monthly samples |
| Reference | 1981–2010 |
| Final quantity | Annual Arctic temperature anomaly in °C |

The short lesson averages annual temperatures before subtracting their reference.
For complete years and fixed weights, this equals the annual mean of monthly
anomalies. It does not produce the complete workflow's monthly fields or
month-duration-weighted anomaly map. See [methods and validation](docs/UPDATED_DEMO.md).

## Checks

The packaged notebooks were re-executed with real ACCESS-CM2 data from a path
containing `&`: **46/46**, **117/117** and **132/132** code cells passed, along
with **10/10** unit tests. [VERIFICATION.json](VERIFICATION.json) records the
source hashes, comparisons and execution scope.

```bash
python -m unittest discover -s tests -v
```

The included tests check input contracts and safe download retries without network
access. The notebook checker can also execute the actual visible cells:

```bash
python scripts/check_updated_notebook_cells.py notebooks/05_annual_stripes_short_demo.ipynb --receipt outputs/annual_check.json
```

This is an in-process IPython check, not a live Binder/Jupyter browser test. Data
must already be downloaded. The independent Python reference does not claim to
be a comparison against saved ESMValTool output files.

## Sources and licence

- [Abhnil's original Python workshop](https://github.com/abhnil/Fresh_Eyes_on_CMIP_Data_Workshop)
- [Evgenia Galytska's shared ESMValTool recipe](https://github.com/egalytska/Fresh_eyes/blob/040b9c7962355b1f8fa1312b7af867b458102b85/ESMValTool/recipe_temperature_anomalies.yml)
- [Companion CDO/NCO workshop](https://github.com/YiwenLiEven/Fresh-Eyes-CDO-NCO-Workshop)

CDO/NCO adaptation and teaching material by Yiwen Li. The existing
[MIT licence](LICENSE) is retained for this contribution. Data are obtained from
the original links; that software licence does not relicense the model data.
