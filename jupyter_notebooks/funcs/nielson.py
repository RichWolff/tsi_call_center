import pandas as pd
import numpy as np

pd.options.mode.chained_assignment = None

def select_brand(brand,df):
    assert type(brand)==str, "Brand name must be string"
    assert type(df)==pd.DataFrame, "df must be pandas dataframe"
    assert brand in df['Parent Company'].unique(), "Brand not in nielson parent company list"
    df = df.copy()

    ## PIVOT TABLE THE MELTED DATA TO SHOW MONTH AS ROWS AND ADVERTSIER/MEDIA TYPE AS COLUMNS
    df_piv = df.pivot_table('spend','month',['Parent Company','Media Type'],aggfunc=np.sum).fillna(0)

    ## GET SOV DF
    idx = pd.IndexSlice
    df_piv_sov = []

    for col in df_piv.columns.levels[1]:
        df_piv_sov.append(df_piv.loc[:,idx[:, col]].transform(lambda x:x/df_piv.loc[:,idx[:, col]].sum(axis=1)).fillna(0))

    df_piv_sov = pd.concat(df_piv_sov,axis=1).sort_index(axis=1)

    ## SELECT TSI AND MFRM
    br = df_piv[brand]
    br_sov = df_piv_sov[brand]
    br_sov.columns = [x+' SOV' for x in br_sov.columns]


    ## ADD TOTAL AD SPEND AND TOTAL SOV TO DATA FRAMES
    br['Total Adspend'] = br.sum(axis=1).copy()
    br_sov['Total SOV'] = df_piv[brand].sum(axis=1)/df_piv.sum(axis=1)

    return br, br_sov
