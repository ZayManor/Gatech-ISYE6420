import numpy as np
from scipy.optimize import minimize_scalar, root_scalar, minimize
from scipy.stats import gamma
from scipy.special import comb


def solve_q1():
    print('Solving Q1.A')
    res = minimize_scalar(lambda x: -h_x(x))
    print(f'MLE is {res.x}.')
    a = 4.5
    b = 4.
    print(f'Bayes estimator is {a / b}.')

    print('Solving Q1.B')
    # cdf(x, a, loc=0, scale=1)
    sol = root_scalar(find_l, bracket=[-10, 10], method='brentq')
    print(f'Lower bound is {sol.root}.')
    sol = root_scalar(find_u, bracket=[-10, 10], method='brentq')
    print(f'Upper bound is {sol.root}.')

    print('Solving Q1.C')

    cons = [
        {
            'type': 'ineq',
            'fun': lambda x: x[1] - x[0]
        },
        {
            'type': 'ineq',
            'fun': lambda x: gcdf(x[1]) - gcdf(x[0]) - 0.95
        },
    ]

    res = minimize(lambda x: x[1] - x[0], np.array([0.0, 3.0]), constraints=cons)
    print(f'HPD interval is {res.x}.')

    print('Solving Q1.D')
    res = minimize_scalar(lambda x: -posterior(x))
    print(f'MAP estimator is {res.x}.')

    print('Solving Q1.E')
    p1 = gcdf(1)
    print(f'p1 is {p1}.')
    print(f'p0 is {1 - p1}.')


def gcdf(x):
    return gamma.cdf(x, a=4.5, scale=1 / 4.)


def find_l(x):
    # Ga(4.5, 4), alpha=0.05
    return gcdf(x) - .05 / 2.


def find_u(x):
    # Ga(4.5, 4), alpha=0.05
    return gcdf(x) - 1 + .05 / 2.


def h_x(x):
    return np.exp(-4 * x) * np.power(x, 4) / 2.


def posterior(x):
    return np.exp(-4 * x) * np.power(x, 3.5)


def solve_q2():
    print('\nSolving Q2.')
    n = 16
    k = 15

    n_comb = comb(n, k)
    print(f'Number of combinations 16-choose-15: {n_comb}.')

    lh = comb(n, k) * np.power(0.5, 16)
    print(f'Likelihood is {lh}.')

    m_x = 32 * ((1 - np.power(0.5, 16)) / 16 + (np.power(0.5, 17) - 1) / 17)
    print(f'm(x) is {m_x}.')

    p0 = 1 / (1 + (0.05 * m_x) / (0.95 * lh))
    print(f'Posterior p0 is {p0}.')
    p1 = 1 - p0
    print(f'Posterior p1 is {p1}.')

    bf01 = lh / m_x
    print(f'BF_01 is {bf01}.')

    bf10 = m_x / lh
    print(f'BF_10 is {bf10}.')

    scale = np.log10(bf10)
    print(f'Scaled BF_10 is {scale}.')


# ------------------ runner ------------------


if __name__ == '__main__':
    solve_q1()
    solve_q2()
