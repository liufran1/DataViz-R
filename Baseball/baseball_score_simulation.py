import numpy as np
import pandas as pd
import seaborn as sns

# Generate independent geometric
h = np.random.geometric(p=0.35, size=10000)-1
a = np.random.geometric(p=0.35, size=10000)-1

boxscore = zip(a,h)

# Format from h/a to win/loss
boxscore_clean = []

for i,j in boxscore:
    if i > j:
        boxscore_clean.append((i,j))
    elif j > i:
        boxscore_clean.append((j,i))

df = pd.DataFrame(boxscore_clean)
df.columns = ['win','loss']

# Get log counts
df['count']=1
df = df.groupby(['win','loss'], as_index=False).agg({'count':'sum'})
df['count_log'] = df['count'].apply(lambda x: np.log(x))
boxscore_array = df.pivot(index='loss', columns='win', values='count_log').to_numpy()


# Plot
ax = sns.heatmap(boxscore_array)

# To do - use real data, calculate MLE parameters