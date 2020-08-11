import numpy as np
from scipy.stats import gamma
from scipy.optimize import root_scalar

OBSERVATIONS = [
    1.788, 2.892, 3.300, 4.152, 4.212, 4.560, 4.880,
    5.184, 5.196, 5.412, 5.556, 6.780, 6.864, 6.864,
    6.888, 8.412, 9.312, 9.864, 10.512, 10.584,
    12.792, 12.804, 17.340,
]


def inspect_bearings():
    # observations
    obs = np.array(OBSERVATIONS)
    n = obs.shape[0]
    assert n == 23

    # hyper-params
    r = 4
    a = 3
    b = 5

    # calculation
    alpha = a + n * r
    beta = b + obs.sum()
    print(f'Alpha is {alpha}.')
    print(f'Beta is {beta}.')

    print(f'Bayes estimator is {alpha / beta}.')

    p = 0.05
    lb = root_scalar(
        lambda x: gamma.cdf(x, a=alpha, scale=1 / beta) - p / 2,
        bracket=[0, 1],
        method='brentq'
    )

    ub = root_scalar(
        lambda x: gamma.cdf(x, a=alpha, scale=1 / beta) + p / 2 - 1,
        bracket=[0, 1],
        method='brentq'
    )

    print(f'Lower bound (2.5%) is {lb.root}.')
    print(f'Upper bound (97.5%) is {ub.root}.')

    hp = gamma.cdf(0.5, a=alpha, scale=1 / beta)
    print(f'H0 probability is {hp}.')
