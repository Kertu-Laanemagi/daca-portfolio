import pandas as pd
from dotenv import load_dotenv
import os
from supabase import create_client

load_dotenv()

# print(pd.__version__)
#print(os.getenv('SUPABASE_URL'))

supabase = create_client(os.getenv('SUPABASE_URL'), os.getenv('SUPABASE_KEY'))

# universaalne kood, mis laeb kõiki tabeleid, mida on vaja laadida. 
def get_data(table_name):
    data = []
    page_size = 1000
    page = 0
    while True:
        response = supabase.table(table_name).select('*').range(page * page_size, (page + 1) * page_size - 1).execute()
        data.extend(response.data)
        if len(response.data) < page_size:
            break
        page += 1
    return pd.DataFrame(data)


#print(supabase.table('sales').select('*').execute()) kontrollib, kas sain ühenduse ja andmed kätte.

sales_df = get_data('sales')
#sales_df = pd.DataFrame(response.data)

#print(sales_df.head())
#(sales_df.shape)

customer_df = get_data('customers')

df = pd.merge(sales_df, customer_df, on='customer_id', how='left')

#print(df.head())
#print(df.shape)

# Annab TOP 5 tooted retail_price järgi
#products_df = get_data('products')
#top_products = products_df.groupby('product_name')['retail_price'].sum().nlargest(5)
#print(top_products)


#top_customer = sales_df.groupby('customer_id')['total_price'].sum().idxmax()
#print("Top Customer:", top_customer)

# välja kommenteeritud df kirjeldavad käsud - pole vaja koguaeg jooksutada koodis
#print("\n=== DESCRIBE ===")
#print(df.describe())
#print("\n=== DTYPES ===")
#print(df.dtypes)

# Iseseisev töö
# 1B
# 1. Mitu unikaalset klienti on andmestikus?
#print("Unikaalseid kliente:", df['customer_id'].nunique())
# Unikaalseid kliente 2551

# 2. Millistes asukohtades on meie kauplused?
#print("Asukohad:", df['store_location'].unique())
# Tallinn, Tartu, Pärnu ja online

# 3. Mitu tellimust on igast asukohast?
#print("Tellimused asukoha järgi:\n", df['store_location'].value_counts())
# Tallinn  - 23801, Tartu - 1797, Pärnu - 1058

# 4. Mis on kogu käive?
#print("Kogukäive:", df['total_price'].sum())
# Kogukäive 2,9 mln 

# 2.1 Boolean index 
# Lihtne filter
#tallinna_tellimused = df[df['store_location'] == 'Tallinn']
#print(tallinna_tellimused)

# Mitu tingimust (AND = &, OR = |)
#suured_tallinn = df[(df['total_price'] > 100) & (df['store_location'] == 'Tallinn')]
#print(suured_tallinn)

# NOT (tilde ~)
#mitte_tallinn = df[~(df['store_location'] == 'Tallinn')]
#print(mitte_tallinn)

# 2.A ülesanne
# 1. Filtreerimine (WHERE)
#print("=== Tallinna tellimused ===")
#tallinn = df[df['store_location'] == 'Tallinn']
#print(f"Kokku: {len(tallinn)} tellimust, käive: {tallinn['total_price'].sum():.2f} EUR")

# 2. Grupeerimie (GROUP BY)
#print("\n=== Käive linniti ===")
#city_revenue = df.groupby('store_location')['total_price'].agg(['sum', 'mean', 'count'])
#city_revenue.columns = ['kogukäive', 'keskmine', 'tellimusi']
#print(city_revenue.sort_values('kogukäive', ascending=False))

# 3. Uue veeru loomine (CASE WHEN)
#df['order_size'] = df['total_price'].apply(
#    lambda x: 'Suur (100+)' if x >= 100 else 'Väike (<100)'
#)
#print("\n=== Tellimused suuruse järgi ===")
#print(df['order_size'].value_counts()) 

 
#2.B Kliendi ostukäitumise analüüs
#customer_summary = df.groupby('customer_id')['total_price'].agg(
#    kogukulutus='sum',
#    keskmine='mean',
#    tellimusi='count'
#).reset_index()

#customer_summary = customer_summary.sort_values('kogukulutus', ascending=False)

#customer_summary['vip_status'] = customer_summary['kogukulutus'].apply(
#    lambda x: 'VIP' if x > 200 else 'Tavaline'
#)

#print(customer_summary)


#3B Kuukäive trend ja VIP jaotus
df['sale_date'] = pd.to_datetime(df['sale_date'])
monthly = df.groupby(df['sale_date'].dt.to_period('M'))['total_price'].sum().reset_index()
monthly['sale_date'] = monthly['sale_date'].astype(str)

import plotly.express as px

fig = px.line(
    monthly,
    x='sale_date',
    y='total_price',
    title='UrbanStyle: Kuukäive trend 2024',
    labels={'sale_date': 'Kuu', 'total_price': 'Käive (EUR)'},
    markers=True
)
fig.show()

vip_counts = customer_summary['vip_status'].value_counts().reset_index()
fig = px.pie(
    vip_counts,
    values='count',
    names='vip_status',
    title='UrbanStyle: Kliendid VIP-staatuse järgi'
)
fig.show()import pandas as pd
from dotenv import load_dotenv
import os
from supabase import create_client

load_dotenv()

# print(pd.__version__)
#print(os.getenv('SUPABASE_URL'))

supabase = create_client(os.getenv('SUPABASE_URL'), os.getenv('SUPABASE_KEY'))

# universaalne kood, mis laeb kõiki tabeleid, mida on vaja laadida. 
def get_data(table_name):
    data = []
    page_size = 1000
    page = 0
    while True:
        response = supabase.table(table_name).select('*').range(page * page_size, (page + 1) * page_size - 1).execute()
        data.extend(response.data)
        if len(response.data) < page_size:
            break
        page += 1
    return pd.DataFrame(data)


#print(supabase.table('sales').select('*').execute()) kontrollib, kas sain ühenduse ja andmed kätte.

sales_df = get_data('sales')
#sales_df = pd.DataFrame(response.data)

#print(sales_df.head())
#(sales_df.shape)

customer_df = get_data('customers')

df = pd.merge(sales_df, customer_df, on='customer_id', how='left')

#print(df.head())
#print(df.shape)

# Annab TOP 5 tooted retail_price järgi
#products_df = get_data('products')
#top_products = products_df.groupby('product_name')['retail_price'].sum().nlargest(5)
#print(top_products)


#top_customer = sales_df.groupby('customer_id')['total_price'].sum().idxmax()
#print("Top Customer:", top_customer)

# välja kommenteeritud df kirjeldavad käsud - pole vaja koguaeg jooksutada koodis
#print("\n=== DESCRIBE ===")
#print(df.describe())
#print("\n=== DTYPES ===")
#print(df.dtypes)

# Iseseisev töö
# 1B
# 1. Mitu unikaalset klienti on andmestikus?
#print("Unikaalseid kliente:", df['customer_id'].nunique())
# Unikaalseid kliente 2551

# 2. Millistes asukohtades on meie kauplused?
#print("Asukohad:", df['store_location'].unique())
# Tallinn, Tartu, Pärnu ja online

# 3. Mitu tellimust on igast asukohast?
#print("Tellimused asukoha järgi:\n", df['store_location'].value_counts())
# Tallinn  - 23801, Tartu - 1797, Pärnu - 1058

# 4. Mis on kogu käive?
#print("Kogukäive:", df['total_price'].sum())
# Kogukäive 2,9 mln 

# 2.1 Boolean index 
# Lihtne filter
#tallinna_tellimused = df[df['store_location'] == 'Tallinn']
#print(tallinna_tellimused)

# Mitu tingimust (AND = &, OR = |)
#suured_tallinn = df[(df['total_price'] > 100) & (df['store_location'] == 'Tallinn')]
#print(suured_tallinn)

# NOT (tilde ~)
#mitte_tallinn = df[~(df['store_location'] == 'Tallinn')]
#print(mitte_tallinn)

# 2.A ülesanne
# 1. Filtreerimine (WHERE)
#print("=== Tallinna tellimused ===")
#tallinn = df[df['store_location'] == 'Tallinn']
#print(f"Kokku: {len(tallinn)} tellimust, käive: {tallinn['total_price'].sum():.2f} EUR")

# 2. Grupeerimie (GROUP BY)
#print("\n=== Käive linniti ===")
#city_revenue = df.groupby('store_location')['total_price'].agg(['sum', 'mean', 'count'])
#city_revenue.columns = ['kogukäive', 'keskmine', 'tellimusi']
#print(city_revenue.sort_values('kogukäive', ascending=False))

# 3. Uue veeru loomine (CASE WHEN)
#df['order_size'] = df['total_price'].apply(
#    lambda x: 'Suur (100+)' if x >= 100 else 'Väike (<100)'
#)
#print("\n=== Tellimused suuruse järgi ===")
#print(df['order_size'].value_counts()) 

 
#2.B Kliendi ostukäitumise analüüs
#customer_summary = df.groupby('customer_id')['total_price'].agg(
#    kogukulutus='sum',
#    keskmine='mean',
#    tellimusi='count'
#).reset_index()

#customer_summary = customer_summary.sort_values('kogukulutus', ascending=False)

#customer_summary['vip_status'] = customer_summary['kogukulutus'].apply(
#    lambda x: 'VIP' if x > 200 else 'Tavaline'
#)

#print(customer_summary)


#3B Kuukäive trend ja VIP jaotus
df['sale_date'] = pd.to_datetime(df['sale_date'])
monthly = df.groupby(df['sale_date'].dt.to_period('M'))['total_price'].sum().reset_index()
monthly['sale_date'] = monthly['sale_date'].astype(str)

import plotly.express as px

fig = px.line(
    monthly,
    x='sale_date',
    y='total_price',
    title='UrbanStyle: Kuukäive trend 2024',
    labels={'sale_date': 'Kuu', 'total_price': 'Käive (EUR)'},
    markers=True
)
fig.show()

vip_counts = customer_summary['vip_status'].value_counts().reset_index()
fig = px.pie(
    vip_counts,
    values='count',
    names='vip_status',
    title='UrbanStyle: Kliendid VIP-staatuse järgi'
)
fig.show()

