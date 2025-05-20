#!/bin/bash

# Exit on error
set -e

echo "Starting TPC-H data loading process..."

# Check if PostgreSQL is running
if ! pg_isready; then
    echo "Error: PostgreSQL is not running"
    exit 1
fi

# Create database and tables
echo "Creating database and tables..."
psql -c "DROP DATABASE IF EXISTS tpch;"
psql -c "CREATE DATABASE tpch;"
psql -d tpch -f create_tables.sql

# Load data
echo "Loading data into tables..."
psql -d tpch -c "\COPY nation FROM 'nation.tbl' WITH (FORMAT csv, DELIMITER '|');"
psql -d tpch -c "\COPY region FROM 'region.tbl' WITH (FORMAT csv, DELIMITER '|');"
psql -d tpch -c "\COPY part FROM 'part.tbl' WITH (FORMAT csv, DELIMITER '|');"
psql -d tpch -c "\COPY supplier FROM 'supplier.tbl' WITH (FORMAT csv, DELIMITER '|');"
psql -d tpch -c "\COPY partsupp FROM 'partsupp.tbl' WITH (FORMAT csv, DELIMITER '|');"
psql -d tpch -c "\COPY customer FROM 'customer.tbl' WITH (FORMAT csv, DELIMITER '|');"
psql -d tpch -c "\COPY orders FROM 'orders.tbl' WITH (FORMAT csv, DELIMITER '|');"
psql -d tpch -c "\COPY lineitem FROM 'lineitem.tbl' WITH (FORMAT csv, DELIMITER '|');"

# Analyze tables
echo "Analyzing tables..."
psql -d tpch -c "ANALYZE;"

# Verify data was loaded
echo "Verifying data..."
psql -d tpch -c "SELECT COUNT(*) FROM nation;"
psql -d tpch -c "SELECT COUNT(*) FROM region;"
psql -d tpch -c "SELECT COUNT(*) FROM part;"
psql -d tpch -c "SELECT COUNT(*) FROM supplier;"
psql -d tpch -c "SELECT COUNT(*) FROM partsupp;"
psql -d tpch -c "SELECT COUNT(*) FROM customer;"
psql -d tpch -c "SELECT COUNT(*) FROM orders;"
psql -d tpch -c "SELECT COUNT(*) FROM lineitem;"

echo "TPC-H data loading completed successfully!" 