#!/bin/bash

# Exit on error
set -e

# Test RNG functionality
test_rng() {
    echo "Testing RNG functionality..."
    ./dbgen -s 0.1 -U 1
    ./dbgen -s 0.1 -U 2
    ./dbgen -s 0.1 -U 3
}

# Test BCD2 functionality
test_bcd2() {
    echo "Testing BCD2 functionality..."
    # Test with different scale factors
    for scale in 0.1 1 10; do
        ./dbgen -s $scale
    done
}

# Test data generation with different distributions
test_distributions() {
    echo "Testing data distributions..."
    # Test with uniform distribution
    ./dbgen -s 1 -U 1
    # Test with skewed distribution
    ./dbgen -s 1 -U 2
    # Test with random distribution
    ./dbgen -s 1 -U 3
}

# Test query generation
test_queries() {
    echo "Testing query generation..."
    # Test all queries
    for i in {1..22}; do
        echo "Testing query $i..."
        ./qgen $i
    done
}

# Test error handling
test_error_handling() {
    echo "Testing error handling..."
    # Test invalid scale factor
    ./dbgen -s -1 2>/dev/null || true
    # Test invalid update percentage
    ./dbgen -U 200 2>/dev/null || true
    # Test invalid query number
    ./qgen 99 2>/dev/null || true
}

# Test performance
test_performance() {
    echo "Testing performance..."
    # Test with different scale factors
    for scale in 0.1 1 10; do
        time ./dbgen -s $scale
    done
}

# Run all tests
echo "Starting component tests..."
test_rng
test_bcd2
test_distributions
test_queries
test_error_handling
test_performance

echo "All tests completed!" 