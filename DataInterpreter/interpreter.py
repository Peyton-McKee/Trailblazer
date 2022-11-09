import pandas as pd

df_json = pd.read_json('userLocations.json')  
df_json.to_excel('userLocations.xlsx', index=False)

df_json = pd.read_json('userRoutes.json')
df_json.to_excel('userRoutes.xlsx', index=False)

df_json = pd.read_json('trailReports.json')
df_json.to_excel('trailReports.xlsx', index=False)

