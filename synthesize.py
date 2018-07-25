import pandas as pd
import numpy as np
from sqlalchemy import create_engine
import pyodbc
import psycopg2
from contextlib import contextmanager
import os

# CONSTANTS
connections = {
    'azure' : {
        'server':'tsi-insights.database.windows.net',
        'port':'1433',
        'database':'insights',
        'username':'insights_admin',
        'password':'97a101e105i#',
        'driver':'{ODBC Driver 13 for SQL Server}',
        'cnxn':pyodbc.connect
    },

    'postgres' : {
        'server':'localhost',
        'port':'5432',
        'database':'insights',
        'username':'postgres',
        'password':'#4BobbyOrr',
        'driver':'postgresql',
        'cnxn': psycopg2
    }

}

sql_queries_dir = os.getcwd()+'\\sql_queries\\'
raw_dir = os.getcwd()+'\\raw_files\\'

def main():
    '''Download data from predefined queries to prepare for initial EDA and tidying for a model'''

    sql_pull(sql_file='google_advertising.sql',
             src_name='Google Ads',
             src_database='azure',
             src_suffix='goog')

    sql_pull(sql_file='bing_advertising.sql',
             src_name='Bing Ads',
             src_database='azure',
             src_suffix='bing')

    sql_pull(sql_file='facebook_advertising.sql',
             src_name='Facebook Ads',
             src_database='azure',
             src_suffix='fb')

    sql_pull(sql_file='incontact_calls.sql',
             src_name='Incontact Calls',
             src_database='azure',
             src_suffix='ic')

    sql_pull(sql_file='hitwise.sql',
             src_name='Hitwise Web Visits',
             src_database='postgresql',
             src_suffix='hit')

    sql_pull(sql_file='ga_webdata.sql',
             src_name='Google Analytics',
             src_database='postgresql',
             src_suffix='ga')

    sql_pull(sql_file='brand_tracker.sql',
             src_name='Brand Tracker',
             src_database='postgresql',
             src_suffix='bt')
    return None

    sql_pull(sql_file='ggl_queries.sql',
             src_name='Google Queries',
             src_database='azure',
             src_suffix='gglq')
    return None

def sql_pull(*,sql_file,src_name,src_database,src_suffix):
    query = read_file(sql_queries_dir+sql_file)
    print('Downloading ' + src_name + ' Data...',end='\t')

    # get data from databases
    with database_connection(src_database) as cnxn:
        df = pd.read_sql(query,cnxn)

    #update columns to be friendly with other data sources
    df.columns = [src_suffix + '_' + x.replace(' ','').lower() for x in df.columns]

    #to csv
    df.to_csv(raw_dir + src_name.replace(' ','_').lower() + '.csv',index=False)
    print('Done!')
    return None

def read_file(file_path):
    with open(file_path,'r') as file:
        contents = file.read()
    return contents

def db_config(filename='databases.ini', section=None):
    from configparser import ConfigParser
    parser = ConfigParser()
    parser.read(filename)

    # get section, default to postgresql
    db = {}
    if parser.has_section(section):
        params = parser.items(section)
        for param in params:
            db[param[0]] = param[1]
    else:
        raise Exception('Section {0} not found in the {1} file'.format(section, filename))
    return db

@contextmanager
def database_connection(db):
    #cnxn_str = 'DRIVER={driver};SERVER={server};PORT={port};DATABASE={database};UID={username};PWD={password}'.format(**db)
    cnxn_params = db_config(section=db)
    if db == 'postgresql':
        cnxn_object = psycopg2.connect
    elif db == 'azure':
        cnxn_object = pyodbc.connect
    else:
        print('Database Not Found')
        return -1

    try:
        cnxn = cnxn_object(**cnxn_params)
        yield cnxn
    finally:
        cnxn.close()

if __name__ == '__main__':
    main()
