\c tpch

-- Load data using COPY command
COPY nation FROM 'nation.tbl' WITH (FORMAT csv, DELIMITER '|');
COPY region FROM 'region.tbl' WITH (FORMAT csv, DELIMITER '|');
COPY part FROM 'part.tbl' WITH (FORMAT csv, DELIMITER '|');
COPY supplier FROM 'supplier.tbl' WITH (FORMAT csv, DELIMITER '|');
COPY partsupp FROM 'partsupp.tbl' WITH (FORMAT csv, DELIMITER '|');
COPY customer FROM 'customer.tbl' WITH (FORMAT csv, DELIMITER '|');
COPY orders FROM 'orders.tbl' WITH (FORMAT csv, DELIMITER '|');
COPY lineitem FROM 'lineitem.tbl' WITH (FORMAT csv, DELIMITER '|');

-- Analyze tables for better query planning
ANALYZE; 