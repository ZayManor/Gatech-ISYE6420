from typing import Tuple
from itertools import product

import numpy as np
import pandas as pd
from tqdm import tqdm

SAVE_ENUM_RESULTS = False


def run_full_enumeration():
    # calculate probs
    combo_map = {}
    for combo in list(product([True, False], repeat=6)):
        p = _get_total_prob(combo)
        combo_map[combo] = p

    # collect results into pd.Dataframe
    data = [(*combo, p) for combo, p in combo_map.items()]
    cols = [f'N{i + 1}' for i in range(6)]
    cols.append('prob')
    df = pd.DataFrame(data, columns=cols)

    # save results
    if SAVE_ENUM_RESULTS:
        df.to_csv('enumeration.csv', index=False)

    # sanity check
    assert np.isclose(df['prob'].sum(), 1.)

    # Part A
    n6 = df[df['N6'] == True]['prob'].sum()
    print(f'P(N6) is {n6}')

    # Part B
    n6_not_n4 = df[(df['N6'] == True) & (df['N4'] == False)]['prob'].sum()
    print(f'P(N6|not N4) is {n6_not_n4}')

    # Part C
    n5_not_n6 = df[(df['N6'] == False) & (df['N2'] == True)]['prob'].sum()
    print(f'P(N2|not N6) is {n5_not_n6}')


def _get_cond_prob(a, b):
    if a and b:
        return 0.9
    if a and not b:
        return 0.1
    if not a and b:
        return 0.05
    if not a and not b:
        return 0.95


def _get_total_prob(combo):
    x1 = 0.9 if combo[0] else 0.1
    x2 = _get_cond_prob(combo[0], combo[1])
    x3 = _get_cond_prob(combo[0], combo[2])

    x4 = _get_cond_prob(combo[2], combo[3])
    x5 = _get_cond_prob(combo[1], combo[4])

    x6 = _get_cond_prob(combo[3] or combo[4], combo[5])

    return x1 * x2 * x3 * x4 * x5 * x6


def run_simulation(n, observe_var, conditions=None):
    obs_ind = int(observe_var[1]) - 1

    cond_map = None
    if conditions:
        cond_map = {int(k[1]) - 1: v for k, v in conditions.items()}

    k = 0
    n_iters = 0
    n_total = 0

    pbar = tqdm(total=n)
    while n_iters < n:
        combo = _simulate_system()
        n_total += 1

        if cond_map is None or _condition_match(combo, cond_map):
            k += combo[obs_ind]
            n_iters += 1
            pbar.update(1)
    pbar.close()

    return k / n_total


def _condition_match(combo, cond_map):
    for i, v in cond_map.items():
        if combo[i] != v:
            return False

    return True


def _simulate_system() -> Tuple[bool, bool, bool, bool, bool, bool]:
    # random open
    x0 = True

    x1 = _simulate_neuron(x0)
    x2 = _simulate_neuron(x1)
    x5 = _simulate_neuron(x2)
    x3 = _simulate_neuron(x1)
    x4 = _simulate_neuron(x3)
    x6 = _simulate_neuron(x5 or x4)

    return x1, x2, x3, x4, x5, x6


def _simulate_neuron(x: bool) -> bool:
    if x:
        return _roll() < 0.9
    else:
        return _roll() < 0.05


def _roll() -> np.float:
    return np.random.rand(1)[0]
