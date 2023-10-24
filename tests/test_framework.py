# content of test_sysexit.py
import pytest


def foo():
    raise SystemExit(1)


def test_testframework():
    with pytest.raises(SystemExit):
        foo()