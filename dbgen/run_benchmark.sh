#!/bin/bash

# Create results directory
mkdir -p benchmark_results

# Function to clean and run a query
run_query() {
    query_num=$1
    echo "Running Query $query_num..."
    
    # Clean the query file and substitute parameters
    sed '/^:x/d; /^:o/d; /^\$ID\$/d; s/:1/90/g; s/:2/15/g; s/:3/24/g; s/:4/25/g; s/:5/19/g; s/:6/35/g; s/:7/20/g; s/:8/10/g; s/:9/5/g; s/:n/-1/g' "queries/$query_num.sql" > "benchmark_results/query${query_num}_clean.sql"
    
    # Run the query with timing and save both the result and the execution plan
    psql -d tpch -c "\timing on" -c "EXPLAIN ANALYZE $(cat benchmark_results/query${query_num}_clean.sql)" > "benchmark_results/query${query_num}_result.txt" 2>&1
    
    # Extract execution time
    execution_time=$(grep "Execution time:" "benchmark_results/query${query_num}_result.txt" | awk '{print $3}')
    echo "Query $query_num completed in $execution_time ms"
}

# Run all 22 TPC-H queries
for i in {1..22}
do
    run_query $i
done

# Generate summary report
echo "Generating summary report..."
echo "Query Number,Execution Time (ms)" > benchmark_results/summary.csv
for i in {1..22}
do
    execution_time=$(grep "Execution time:" "benchmark_results/query${i}_result.txt" | awk '{print $3}')
    echo "$i,$execution_time" >> benchmark_results/summary.csv
done

echo "Benchmark completed. Results are in the 'benchmark_results' directory." 