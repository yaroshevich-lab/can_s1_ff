#!/usr/bin/env bash
# File: extract_energy.sh
#
# Usage:
#   chmod +x extract_energy.sh
#   ./extract_energy.sh
#
# After running, the CSV file `all_energy.csv` will be created in the
# current working directory. It will contain two columns:
#   folder,energy

set -euo pipefail

# Path to the base directory containing all run subfolders
BASE_DIR="MM_scan/runs"

# Output CSV file
OUTPUT_CSV="MM_energy.csv"

# Initialise CSV with header
echo "folder,energy" > "$OUTPUT_CSV"

# Iterate over all subdirectories
for run_dir in "$BASE_DIR"/*/; do
    # Ensure it is a directory
    [ -d "$run_dir" ] || continue

    # Get the folder name (e.g., 0, 1, 2, …)
    folder_name=$(basename "$run_dir")

    # Check that the expected .edr file exists
    edr_file="${run_dir}${folder_name}.edr"
    if [ ! -f "$edr_file" ]; then
        echo "WARNING: $edr_file not found – skipping $folder_name"
        continue
    fi

    # Run gmx energy (the output is redirected to /dev/null to keep the
    # script quiet; energy.xvg will be written in the run directory)
    printf "Potential \n\n" | gmx energy -f "$edr_file" -o "${run_dir}energy.xvg" > /dev/null

    # Verify that the energy.xvg file was created
    energy_file="${run_dir}energy.xvg"
    if [ ! -f "$energy_file" ]; then
        echo "ERROR: $energy_file was not created – skipping $folder_name"
        continue
    fi

    # Extract the last energy value (the last line that is not a comment)
    # gmx energy files have header lines starting with '@' or '#'
    energy_value=$(grep -vE '^[#@]' "$energy_file" | tail -n 1 | awk '{print $2}')

    # If energy_value is empty, log a warning
    if [ -z "$energy_value" ]; then
        echo "WARNING: No energy value extracted for $folder_name"
        continue
    fi

    # Append the result to the CSV
    echo "$folder_name,$energy_value" >> "$OUTPUT_CSV"

    echo "✓ Processed $folder_name – energy=$energy_value"
done

{ head -n 1 "$OUTPUT_CSV"; tail -n +2 "$OUTPUT_CSV" | sort -t, -k1,1 -n; } > "${OUTPUT_CSV}.tmp" && mv "${OUTPUT_CSV}.tmp" "$OUTPUT_CSV"

echo "All done – results written to $OUTPUT_CSV"