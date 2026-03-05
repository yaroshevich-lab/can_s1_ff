#!/bin/bash

# Define directories
SCAN_DIR="scan_remapped/"
MM_SCAN_DIR="MM_scan"

# Create MM_scan/runs directory if it doesn't exist
mkdir -p $MM_SCAN_DIR

# Loop through each file in the structures directory
for PDB_FILE in "$SCAN_DIR"/*.pdb; do
    # Get full filename (without .pdb extension) in full path
    BASENAME="$(basename "$PDB_FILE" .pdb)"
    
    # Remove everything up to and including first slash to get just filename part
    STRUCTURE_NAME="$(basename "$BASENAME" .pdb)"
    mkdir -p "${MM_SCAN_DIR}/runs/${STRUCTURE_NAME}"
    # Run gmx editconf to convert PDB to GRO
    gmx editconf -f $PDB_FILE -o "${MM_SCAN_DIR}/runs/${STRUCTURE_NAME}/${STRUCTURE_NAME}.gro" -c -d 1.5 -bt cubic

    # Generate .tpr file using gmx grompp
    gmx grompp -f "${MM_SCAN_DIR}/singlepoint.mdp" -c "${MM_SCAN_DIR}/runs/${STRUCTURE_NAME}/${STRUCTURE_NAME}.gro" -p "${MM_SCAN_DIR}/45D.top" -o "${MM_SCAN_DIR}/runs/${STRUCTURE_NAME}/${STRUCTURE_NAME}.tpr"

    # Run simulation using gmx mdrun
    gmx mdrun -v -deffnm "${MM_SCAN_DIR}/runs/${STRUCTURE_NAME}/${STRUCTURE_NAME}" -ntmpi 1 -ntomp 10 -pin on
done

