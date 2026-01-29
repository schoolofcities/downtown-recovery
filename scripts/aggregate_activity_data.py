"""
Script to aggregate activity-level data by city and day.
Creates a new CSV with both activity-level data and aggregated totals.
"""

import pandas as pd
from pathlib import Path

# Paths
INPUT_FILE = Path(__file__).parent.parent / "static" / "trend_sep_to_dec_23_24_25_activity.csv"
OUTPUT_FILE = Path(__file__).parent.parent / "static" / "trend_sep_to_dec_23_24_25_with_agg.csv"

def main():
    # Read the activity-level CSV
    print(f"Reading {INPUT_FILE}...")
    df = pd.read_csv(INPUT_FILE)
    
    print(f"Loaded {len(df)} rows")
    print(f"Columns: {df.columns.tolist()}")
    print(f"Unique activities: {df['ACTIVITY'].unique().tolist() if 'ACTIVITY' in df.columns else 'N/A'}")
    
    # Aggregate by city and date (sum across all activities)
    agg_df = df.groupby(['city', 'date']).agg({
        'normalized_distinct_clean': 'sum',
        'normalized_stops_clean': 'sum' if 'normalized_stops_clean' in df.columns else 'first'
    }).reset_index()
    
    # Rename aggregated columns
    agg_df = agg_df.rename(columns={
        'normalized_distinct_clean': 'agg_normalized_distinct_clean',
        'normalized_stops_clean': 'agg_normalized_stops_clean'
    })
    
    # Merge aggregated values back to original data
    df_with_agg = df.merge(agg_df, on=['city', 'date'], how='left')
    
    print(f"\nOutput will have {len(df_with_agg)} rows")
    print(f"Output columns: {df_with_agg.columns.tolist()}")
    
    # Also create a separate aggregated-only file for overall view
    AGG_ONLY_FILE = Path(__file__).parent.parent / "static" / "trend_sep_to_dec_23_24_25_aggregated.csv"
    agg_df_renamed = agg_df.rename(columns={
        'agg_normalized_distinct_clean': 'normalized_distinct_clean',
        'agg_normalized_stops_clean': 'normalized_stops_clean'
    })
    agg_df_renamed.to_csv(AGG_ONLY_FILE, index=False)
    print(f"\nSaved aggregated-only data to {AGG_ONLY_FILE}")
    print(f"Aggregated file has {len(agg_df_renamed)} rows")
    
    # Save the merged file
    df_with_agg.to_csv(OUTPUT_FILE, index=False)
    print(f"Saved merged data to {OUTPUT_FILE}")
    
    # Preview
    print("\n=== Sample of aggregated data ===")
    sample_city = df['city'].iloc[0]
    sample = agg_df_renamed[agg_df_renamed['city'] == sample_city].head(5)
    print(sample.to_string(index=False))

if __name__ == "__main__":
    main()
