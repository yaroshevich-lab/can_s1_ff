# Fitting QM Dihedral Energy
The aim is to fit the QM dihedral scan energy into Ryckaert–Bellemans potential 
The definition can be found at [Gromacs Docs RB link](https://manual.gromacs.org/current/reference-manual/functions/bonded-interactions.html#proper-dihedrals-ryckaert-bellemans-function)

## Project Overview

You’ll find here:
- A **pure Python implementation** to quickly calculate energy at arbitrary torsion angles.
- A **Jupyter notebook** implementing a real use-case workflow: data loading, experimental torsion extraction, parameter optimization, and verification via visualization.

## Files

- `S1a.txt`: scan energies
- `scan_structures`: structure files corresponding to the scan energies in `S1a.txt`
- `rb_potential.py`:  Python implementation of the Ryckaert–Bellemans potential.
- `Optimize_dihedral.ipynb`: Jupyter notebook demonstrating end-to-end computation with real data, parameter fitting using SciPy, and visualizations.
- Required dependencies: `numpy`, `scipy`, `mdtraj`, `pandas`, `matplotlib`

## What Was Done?

### 1. Data Acquisition
- **Input:** `S1a.txt` contains experimental computed/torsion scan data with columns: angle, energy (kcal/mol), auxiliary fields.
- The energy is converted to kJ/mol for consistency.

### 2. Problem Context: C-terminal Domain
Goal is to parameterize the rotational dihedral for a specific ring in the *C-terminal domain* .  

### 3. Data Preparation

- **Conversion of Structures:**  
  Original PDB files  show unexpected encoding (EUC-JP). The notebook converts all files to UTF-8
- **Torsion Extraction:**  
  For each structure, select the specific torsion indices (for mdtraj 17, 22, 23, 25) and extract the real angle (averaging if multiple conformers):

### 4. Parameter Optimization
- **RB Model:**  
  The RB function calculates energies from given angles and coefficient vectors.
- **Optimizer:**  
  SciPy `least_squares` fits parameters against measured energies:

### 5. Validation and Visualization
- **Resulting Coefficients:**  
  Optimization yields
  `C = [6.99609, -11.33165, -10.30992, 3.49595, 17.63221, 5.91840]`  

- **Plots:**  
  - Plot experimental points and fitted curve for visual verification.