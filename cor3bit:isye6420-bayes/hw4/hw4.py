import numpy as np
from scipy.stats import mode, gamma

import matplotlib.pyplot as plt
import seaborn as sns


def solve_q1():
    # simulate MH procedure

    k = 51000
    burn_k = 1000
    curr_r = 0.0

    samples = []

    for i in range(k):
        # generate p'
        r_ = np.random.uniform(curr_r - 0.1, curr_r + 0.1, 1)[0]
        # r_ = np.random.uniform(-1, 1, 1)[0]

        # calculate ratio
        a = np.minimum(1., posterior(r_) / posterior(curr_r))

        # accept or not
        s = np.random.rand(1)[0]
        curr_r = r_ if s < a else curr_r

        samples.append(curr_r)

    # print(samples[-10:])

    # plotting
    final_samples = samples[burn_k:]
    plt.hist(final_samples, bins=30)
    plt.show()

    plt.plot(final_samples[-1000:])
    plt.show()

    print(np.min(final_samples))
    print(np.max(final_samples))

    print(f'Bayes estimator (mean) is {np.mean(final_samples)}')
    print(f'Bayes estimator (mode) is {mode(final_samples)[0][0]}')


def posterior(r):
    if not -1 <= r <= 1:
        return 1e-7

    a = 1 - r * r
    b = 220.8903 - 165.0494 * r
    c = 1 / (a * a)

    return np.power(c, 100) * np.exp(-b / (2 * a))


def log_lh(r):
    if not -1 <= r <= 1:
        return 1e-7

    a = -100 * np.log(2 * np.pi)
    b = - 200 * np.log(1 - r * r)
    c = - (220.8903 - 165.0494 * r) / (2 * (1 - r * r))
    return a + b + c


def solve_q2():
    k = 51000
    burn_k = 1000

    mu_ = 0.1
    lambda_ = sample_lambda(mu_)

    lambdas = [lambda_]
    mus = [mu_]

    while len(mus) != k and len(lambdas) != k:
        mus.append(sample_mu(lambdas[-1]))
        lambdas.append(sample_lambda(mus[-1]))

    ls = np.array(lambdas[burn_k:])
    plt.hist(ls, bins=30)
    plt.show()

    ms = np.array(mus[burn_k:])
    plt.hist(ms, bins=30)
    plt.show()

    sns.scatterplot(x=ms, y=ls)
    plt.show()

    print(f'Bayes estimator (mean) for Lambda is {np.mean(ls)}')
    print(f'Bayes estimator (mean) for Mu is {np.mean(ms)}')

    print(f'Variance for Lambda is {np.var(ls)}')
    print(f'Variance for Mu is {np.var(ms)}')

    print(f'Quantile 2.5% for Lambda is {np.quantile(ls, 0.025)}')
    print(f'Quantile 97.5% for Lambda is {np.quantile(ls, 0.975)}')
    print(f'Quantile 2.5% for Mu is {np.quantile(ms, 0.025)}')
    print(f'Quantile 97.5% for Mu is {np.quantile(ms, 0.975)}')

    print(f'Bayes estimator for Mu*Lambda is {np.mean(ms * ls)}')


def sample_mu(lambda_n):
    return gamma.rvs(a=21, scale=1 / (512 * lambda_n + 5), size=1)[0]


def sample_lambda(mu_n):
    return gamma.rvs(a=23, scale=1 / (512 * mu_n + 100), size=1)[0]


# ------------------ runner ------------------


if __name__ == '__main__':
    np.random.seed(42)
    sns.set()

    solve_q1()
    solve_q2()
