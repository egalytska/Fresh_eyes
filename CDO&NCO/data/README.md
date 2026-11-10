# Input data

Run `python scripts/fetch_updated_data.py` from the `CDO&NCO` folder. Verified
files are placed under `data/access_cm2/`. [manifest.json](manifest.json) lists
exact source URLs, SHA-256 values and their provenance. The SHA-256 values pin
the workshop inputs; independent publisher checksums were not supplied.

The two original files cover historical 1850–2014 and SSP5-8.5 2015–2100.
The teaching commands select 1979–2024. Raw data are deliberately not duplicated
in this code directory. The SSP5-8.5 source URL is pinned to the organizer's
repository revision so future repository changes do not silently change inputs.
