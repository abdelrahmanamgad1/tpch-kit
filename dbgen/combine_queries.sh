#!/bin/bash

# Create output file
echo "-- TPC-H Queries" > tpch-stream.sql
echo "-- Generated on $(date)" >> tpch-stream.sql
echo "" >> tpch-stream.sql

# Combine all queries
for i in {1..22}
do
    echo "-- Query $i" >> tpch-stream.sql
    echo "--" >> tpch-stream.sql
    cat "queries/$i.sql" >> tpch-stream.sql
    echo "" >> tpch-stream.sql
    echo "" >> tpch-stream.sql
done

echo "Queries have been combined into tpch-stream.sql" 