import numpy as np
import seaborn as sns

from neurons import run_simulation, run_full_enumeration
from bearings import inspect_bearings
from frogs import analyze_frogs


def solve_q1():
    print('Problem 1.')

    print(f'\nRunning full enumeration.')
    run_full_enumeration()

    print(f'\nRunning simulation.')
    n = 100000
    p = run_simulation(n, 'N6')
    print(f'P(N6) is {p}')
    p = run_simulation(n, 'N6', {'N4': False})
    print(f'P(N6|not N4) is {p}')
    p = run_simulation(n, 'N2', {'N6': False})
    print(f'P(N2|not N6) is {p}')


def solve_q2():
    print('\nProblem 2.')
    inspect_bearings()


def solve_q3():
    print('\nProblem 3.')
    analyze_frogs()


# ------------------ runner ------------------


if __name__ == '__main__':
    np.random.seed(42)
    sns.set()

    solve_q1()
    solve_q2()
    solve_q3()
