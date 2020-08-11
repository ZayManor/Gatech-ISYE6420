import pandas as pd

Y_COL = 'Went Beach'


def solve_q2():
    # load data
    df = pd.read_csv('naive.csv', index_col='Student')

    # calculate prior
    y_pos_prob = df[Y_COL].mean()

    # train
    df_pos = df[df[Y_COL] == 1]
    df_neg = df[df[Y_COL] == 0]

    feature_map = {}
    for col in df:
        if col != Y_COL:
            a = df_pos[col].mean()
            b = df_neg[col].mean()
            feature_map[col] = (a, b)

    # predict
    jane = {
        'Midterm': 1,
        'Finances': 1,
        'Friends Go': 0,
        'Forecast': 0,
        'Gender': 1,
    }
    jane_probs = _predict_with_nb(feature_map, jane, y_pos_prob)
    print(f'Jane: {jane_probs}')

    michael = {
        'Midterm': 0,
        'Finances': 0,
        'Friends Go': 1,
        'Forecast': 1,
        'Gender': 0,
    }
    michael_probs = _predict_with_nb(feature_map, michael, y_pos_prob)
    print(f'Michael: {michael_probs}')

    melissa = {
        'Midterm': 1,
        'Finances': 1,
        'Friends Go': 0,
        'Forecast': 1,
        'Gender': 1,
    }
    melissa_probs = _predict_with_nb(feature_map, melissa, y_pos_prob)
    print(f'Melissa: {melissa_probs}')


def _predict_with_nb(feature_map, person, prior):
    assert len(feature_map) == len(person)

    # combine conditional probabilities of individual features
    y_pos = 1.
    y_neg = 1.
    for col, value in person.items():
        feature_y_pos, feature_y_neg = feature_map[col]

        feature_y_pos_prob = feature_y_pos if value else 1. - feature_y_pos
        feature_y_neg_prob = feature_y_neg if value else 1. - feature_y_neg

        y_pos *= feature_y_pos_prob
        y_neg *= feature_y_neg_prob

    # multiply by prior
    y_pos *= prior
    y_neg *= (1 - prior)

    # normalize
    y_sum = y_pos + y_neg

    return y_pos / y_sum, y_neg / y_sum


if __name__ == '__main__':
    solve_q2()
