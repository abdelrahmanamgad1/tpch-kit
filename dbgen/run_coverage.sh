#!/bin/bash

# Exit on error
set -e

echo "Cleaning previous build..."
make clean

echo "Building with coverage..."
make coverage

echo "Running basic tests..."
# Run basic tests
./dbgen -s 1
./dbgen -s 0.1
./dbgen -s 10

echo "Running component tests..."
# Run component tests
./tests/test_components.sh

echo "Generating coverage data..."
# Generate coverage data with branch coverage
gcov -b *.c

echo "Generating HTML report..."
# Create HTML report using lcov
if command -v lcov &> /dev/null; then
    # Capture coverage data
    lcov --capture --directory . --output-file coverage.info
    
    # Remove system and external files from coverage
    lcov --remove coverage.info '/usr/*' '/opt/*' --output-file coverage.info
    
    # Generate HTML report
    genhtml coverage.info --output-directory coverage_report
    
    echo "Coverage report generated in coverage_report/index.html"
else
    echo "lcov not found. Please install lcov for HTML coverage reports."
    echo "Basic coverage information is available in .gcov files"
fi

echo "Done!" 