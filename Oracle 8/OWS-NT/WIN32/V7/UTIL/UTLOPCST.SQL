rem 
rem $Header: utlopcst.sql,v 1.2 1993/07/07 12:55:37 lwillis Exp $ 
rem 
Rem  Copyright (c) 1992 by Oracle Corporation 
Rem    NAME
Rem      utlopcst.sql - optimizer create export tables for simulator
Rem    DESCRIPTION
Rem    Create tables to hold statistics for export and subsequent
Rem    use by optimizer.
Rem    Must be run before utlopget.sql
Rem    RETURNS
Rem 
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem    MODIFIED   (MM/DD/YY)
Rem     lwillis    07/07/93 -  merge changes from branch 1.1.312.1
Rem     lwillis    07/07/93 -  Creation

CREATE TABLE sim_tab_stats (
    block_count         NUMBER,         -- Number of blocks
    avg_row_length      NUMBER,         -- Average row length
    row_count           NUMBER,         -- Number of rows
    table_name          VARCHAR2(31),   -- Table name
    user_name           VARCHAR2(31),   -- User name
    PRIMARY KEY         (table_name, user_name)
);

CREATE TABLE sim_col_stats (
    high_value          RAW(32),        -- Highest column value
    low_value           RAW(32),        -- Lowest column value
    distinct_count      NUMBER,         -- Number of distinct values
    density             NUMBER,         -- Density
    column_name         VARCHAR2(31),   -- Column name
    table_name          VARCHAR2(31),   -- Table name
    user_name           VARCHAR2(31),   -- User name
    PRIMARY KEY         (column_name, table_name, user_name),
    FOREIGN KEY         (table_name, user_name)
                        REFERENCES sim_tab_stats (table_name, user_name)
);

CREATE TABLE sim_index_stats ( 
    depth               NUMBER,         -- Number of levels in btree
    distinct_count      NUMBER,         -- Number of distinct keys
    leaf_block_count    NUMBER,         -- Number of leaf blocks
    avg_leaf_count      NUMBER,         -- Average num of leaf blocks / key
    avg_data_count      NUMBER,         -- Average num of data blocks / key
    is_unique           NUMBER,         -- 0 not unique, 1 unique
    cluster_factor      NUMBER,         -- Clustering factor
    index_name          VARCHAR2(31),   -- Index name
    table_name          VARCHAR2(31),   -- Table name
    user_name           VARCHAR2(31),   -- User name
    PRIMARY KEY         (index_name, table_name, user_name),
    FOREIGN KEY         (table_name, user_name)
                        REFERENCES sim_tab_stats (table_name, user_name)
);       
