import math
import pytest

from rb_potential import ryckaert_bellemans


C_EXAMPLE = (0.5, 1.0, -0.2, 0.0, 0.0, 0.0)


def test_phi_zero():
    V = ryckaert_bellemans(0.0, C_EXAMPLE)
    assert pytest.approx(sum(C_EXAMPLE), rel=1e-12) == V


def test_phi_pi2():
    V = ryckaert_bellemans(math.pi / 2.0, C_EXAMPLE)
    assert pytest.approx(C_EXAMPLE[0], rel=1e-12) == V


def test_derivative_zero():
    _, dV = ryckaert_bellemans(0.0, C_EXAMPLE, derivative=True)
    assert pytest.approx(0.0, abs=1e-12) == dV


def test_derivative_numeric():
    phi = 0.3
    _, dV = ryckaert_bellemans(phi, C_EXAMPLE, derivative=True)
    h = 1e-6
    Vp = ryckaert_bellemans(phi + h, C_EXAMPLE)
    Vm = ryckaert_bellemans(phi - h, C_EXAMPLE)
    num = (Vp - Vm) / (2 * h)
    assert pytest.approx(num, rel=1e-4, abs=1e-8) == dV
