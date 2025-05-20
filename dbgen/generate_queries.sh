#!/bin/bash

# Create output directory
mkdir -p generated_queries

# Generate each query
for i in {1..22}
do
    echo "Generating query $i..."
    ./qgen -v -c -d -s 1 queries/$i > "generated_queries/query$i.sql"
done

# Combine all queries
cat generated_queries/query*.sql > tpch-stream.sql

echo "All queries have been generated and combined into tpch-stream.sql" 