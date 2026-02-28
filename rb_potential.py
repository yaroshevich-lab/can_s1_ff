"""Ryckaert-Bellemans (RB) dihedral potential utilities.

The RB potential is defined as:

    V(phi) = sum_{n=0}^5 C_n * cos(phi)**n

This module provides a function to compute the energy and optionally
its derivative with respect to the dihedral angle phi.
"""
from __future__ import annotations

import math
import numpy as np
from typing import Iterable, Sequence, Tuple, Union


def ryckaert_bellemans(phi: Sequence, C: Sequence[float]) -> Sequence[float]:
    """Compute the Ryckaert-Bellemans dihedral potential according to GROMACS documentation.

    Args:
        phi: array of dihedral angles in degrees.
        C: array of sequences of 6 coefficients (C0..C5)

    Returns:
        Returns energy (float) in kJ * mol^-1.
    """    
    phi = np.asarray(phi)
    C = np.asarray(C)

    if C.shape[-1] != 6:
        raise ValueError("C must be a sequence of 6 coefficients (C0..C5)")
    
    psi = phi - 180
    cos_phi = np.cos(np.deg2rad(psi))

    V = C[0] + C[1] * cos_phi + C[2] * cos_phi**2 + C[3] * cos_phi**3 + C[4] * cos_phi**4 + C[5] * cos_phi**5

    return V