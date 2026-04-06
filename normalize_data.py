import pandas as pd
import numpy as np
import datetime

# Load data
trips = pd.read_csv('archive/ca_us_stops_tripid_trips.csv')
norm = pd.read_csv('archive/daily_can_total_papa.csv')

# Filter out Canadian metros
can_provs = ['BC', 'AB', 'SK', 'MB', 'ON', 'QC', 'NB', 'NS', 'PE', 'NL', 'YT', 'NT', 'NU']
is_can = trips['METRO'].apply(lambda x: any(f", {p}" in str(x) for p in can_provs))
us_trips = trips[~is_can].copy()

# Group by METRO and DATE and sum UNIQUESTOPS
us_trips['UNIQUESTOPS'] = pd.to_numeric(us_trips['UNIQUESTOPS'], errors='coerce').fillna(0)
agg_trips = us_trips.groupby(['METRO', 'DATE'])['UNIQUESTOPS'].sum().reset_str() #.reset_index()

# Merge with norm data
norm['SNAPSHOT_EVENT_DATE'] = norm['SNAPSHOT_EVENT_DATE'].astype(str)
agg_trips['DATE'] = agg_trips['DATE'].astype(str)

merged = pd.merge(agg_trips, norm[['SNAPSHOT_EVENT_DATE', 'UNIQUE_CANADIAN_DEVICES']], 
                  left_on='DATE', right_on='SNAPSHOT_EVENT_DATE', how='inner')

# Normalize
merged['normalized'] = merged['UNIQUESTOPS'] / merged['UNIQUE_CANADIAN_DEVICES']

# We only need the date in the dateNum format, since parseDate expects YYYYMMDD string from number
# Let's filter date range in python as well? The frontend:
# const startDate = new Date("2024-03-13");
# const endDate = new Date("2026-03-13");

# The frontend outputs: metro, dateNum, stops, normalized
# We want to remove stops and just output normalized
final_df = merged[['METRO', 'DATE', 'normalized']]
final_df.to_csv('static/us_normalized_trips.csv', index=False)