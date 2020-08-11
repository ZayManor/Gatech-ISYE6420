import numpy as np
from scipy.stats import gamma, norm
from scipy.optimize import root_scalar
from tqdm import tqdm
import matplotlib.pyplot as plt
import seaborn as sns


def analyze_frogs():
    # sampling
    mu1, tau1, mu2, tau2 = _sampler()
    diff = mu1 - mu2

    plt.hist(diff, bins=30)
    plt.axvline(x=0.0, color='r', linestyle='dashed', linewidth=2)
    plt.show()

    print(f'Bayes estimator (mean) for Mu1-Mu2 is {np.mean(diff)}')
    print(f'Quantile 2.5% for Mu1-Mu2 is {np.quantile(diff, 0.025)}')
    print(f'Quantile 97.5% for Mu1-Mu2 is {np.quantile(diff, 0.975)}')


def _sampler():
    k = 11000
    burn_k = 1000

    mu_ = 0.0
    tau_ = 1.0

    taus1 = [tau_]
    mus1 = [mu_]

    taus2 = [tau_]
    mus2 = [mu_]

    for _ in tqdm(range(k - 1)):
        mus1.append(_sample_mu(taus1[-1], 1))
        taus1.append(_sample_tau(mus1[-1], 1))

        mus2.append(_sample_mu(taus2[-1], 2))
        taus2.append(_sample_tau(mus2[-1], 2))

    ms1 = np.array(mus1[burn_k:])
    ts1 = np.array(taus1[burn_k:])

    ms2 = np.array(mus2[burn_k:])
    ts2 = np.array(taus2[burn_k:])

    return ms1, ts1, ms2, ts2


def _sample_mu(tau_n, i):
    if i == 1:
        mean = (0.6 + 27.95 * tau_n) / (1 + 43 * tau_n)
        precision = 1 + 43 * tau_n
        return norm.rvs(loc=mean, scale=1 / np.sqrt(precision), size=1)[0]
    else:
        mean = (0.6 + 6.48 * tau_n) / (1 + 12 * tau_n)
        precision = 1 + 12 * tau_n
        return norm.rvs(loc=mean, scale=1 / np.sqrt(precision), size=1)[0]


def _sample_tau(mu_n, i):
    if i == 1:
        alpha = 41.5
        s = np.power(0.65 - mu_n, 2)
        beta = 0.5 + 0.5 * (1.3608 + 43 * s)

        return gamma.rvs(a=alpha, scale=1 / beta, size=1)[0]
    else:
        alpha = 26
        s = np.power(0.54 - mu_n, 2)
        beta = 0.5 + 0.5 * (0.2156 + 12 * s)
        return gamma.rvs(a=alpha, scale=1 / beta, size=1)[0]
