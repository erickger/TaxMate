import pandas as pd
import json
import pyodbc
import numpy as np
from functools import reduce

df1 = pd.read_csv('D:\GovHack 2018\ABSData.csv')
df2 = pd.read_csv('D:\GovHack 2018\ABSSEIFA.csv')
df3 = pd.read_csv('D:\GovHack 2018\ATOData.csv')
df4 = pd.read_csv('D:\GovHack 2018\TaxHelpCenter.csv')
df5 = pd.read_csv('D:\GovHack 2018\FamiliesAndIncome.csv')
df6 = pd.read_csv('D:\GovHack 2018\PopulationProjection.csv')

f = open('D:\GovHack 2018\SuburbsSAgeojson.txt', 'r')
content = f.read()
python_obj = json.loads(content)
subInfo = []
index = 0
for suburb in python_obj['features']:
    subInfo.append({})
    subInfo[index]['Postcode'] = suburb['properties']['POSTCODE']
    subInfo[index]['Name'] = suburb['properties']['SUBURB']    
    sum_lat = 0
    sum_long = 0
    num_points = 0
    for location in suburb['geometry']['coordinates'][0][0]:
        sum_lat = sum_lat + location[1]
        sum_long = sum_long + location[0]
        num_points = num_points + 1
    subInfo[index]['Latitud'] = sum_lat/num_points
    subInfo[index]['Longitud'] = sum_long/num_points
    index = index + 1
df7 = pd.DataFrame(subInfo)

df1.drop(['id'], axis = 1, inplace = True)
df3.drop(['id'], axis = 1, inplace = True)
df2 = df2.rename(columns={'Postal Area (POA) Code':'Postcode'})
df4 = df4.rename(columns={'Post Code':'Postcode'})
df5['Postcode'] = pd.to_numeric(df5['Postcode'])
dfs = [df1, df2, df3, df4, df5, df6, df7]
dfm = reduce(lambda left,right: pd.merge(left,right,on='Postcode'), dfs)
np.random.randint(0,high=15,size=len(dfm))
dfm = dfm.assign(target=pd.Series(np.random.randint(0,high=12,size=len(dfm))).values)

dfm.to_csv('D:\GovHack 2018\locHelpCenter.csv', index=False)
