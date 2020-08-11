import numpy as np
from scipy.stats import binom
import matplotlib.pyplot as plt


def solve_q1():
    # ------- Part A -------
    print('\nSolving Q1.A.')

    # single component
    t = 3
    p = _prob_alive_at_t(t)
    print(f'Prob of a single component to stay alive at t={t} is {p}.')

    # system (option A)
    print('Solving via pmf.')
    n = 8
    k = 4
    cum_prob = .0
    for i in range(k, n + 1):
        cum_prob += binom.pmf(i, n, p)
    print(f'Prob of a system to stay alive at t={t} is {cum_prob}.')

    # system (option B)
    print('Solving via cdf.')
    cum_prob = 1. - binom.cdf(k - 1, n, p)
    print(f'Prob of a system to stay alive at t={t} is {cum_prob}.')

    # ------- Part B -------
    print('\nSolving Q1.B.')

    p5 = binom.pmf(5, n, p)
    p5_h0 = p5 / cum_prob
    print(f'Prob k=5 and alive at t={t} is {p5_h0}.')


def solve_q2():
    print('\nSolving Q2.')
    f_x = lambda x: np.power(x, 3) / 16. + 0.5
    xs = np.linspace(-2, 2, 50)
    ys = [f_x(x) for x in xs]

    plt.plot(xs, ys)
    plt.grid(True)
    plt.show()


def solve_q4():
    print('\nSolving Q4.B.')

    a = 0.05
    m = 0.54876

    l = m / np.power(1 - a / 2, 1 / 34)
    print(f'L-bound is {l}.')

    u = m / np.power(a / 2, 1 / 34)
    print(f'U-bound is {u}.')


def _prob_alive_at_t(t):
    return np.exp(-0.1 * np.power(t, 1.5))


# ------------------ runner ------------------


if __name__ == '__main__':
    solve_q1()
    solve_q2()
    solve_q4()
