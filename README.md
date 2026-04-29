# Choco-K29 Database Project

A relational database system designed and implemented in PostgreSQL for a wholesale chocolate distributor. Built as part of the K29: Database Design and Usage course at the National and Kapodistrian University of Athens (2026).

## Overview

Choco-K29 is a wholesale supplier of various chocolate types serving bakeries, confectionery workshops, and chocolate retailers across Greece. This project models their operations including customer management, inventory tracking, and order processing.

## Database Schema

The database consists of 4 relations:

| Table | Description |
|---|---|
| `CUSTOMERS` | Customer records including credit limits and current balance |
| `PRODUCTS` | Chocolate inventory with stock levels, pricing, and reorder logic |
| `ORDERS` | Order headers linking customers to their purchases |
| `ORDER_DETAILS` | Individual order line items with quantities and prices |

### Entity Relationships
CUSTOMERS (1) ──── (N) ORDERS (1) ──── (N) ORDER_DETAILS (N) ──── (1) PRODUCTS

## Features

- Full schema design with primary keys, foreign keys, and integrity constraints
- CHECK constraints enforcing business rules (minimum order 10kg, valid origins, positive prices)
- 20 SQL queries covering aggregations, subqueries, joins, set operations, and date filtering
- Tested against a dataset of 1000 customers, 100 products, 4900 orders, and 14752 order lines

## Queries Implemented

| # | Query |
|---|---|
| Q1 | Customers ranked by outstanding balance |
| Q2 | Products requiring immediate reorder |
| Q3 | Customers who ordered a specific product in a given month |
| Q4 | Orders where quantity exceeds reorder threshold |
| Q5 | Best order by value for a specific product type |
| Q6 | Cities where average customer credit limit exceeds €9,000 |
| Q7 | Min and max order value per product |
| Q8 | Days in June 2025 where total orders exceeded €35,000 |
| Q9 | Product origins and customer counts for January 2024 orders |
| Q10 | Most expensive products to restock |
| Q11 | Date of the largest order ever placed |
| Q12 | Customers with no orders in February 2025 |
| Q13 | Customers who ordered on a specific date |
| Q14 | Product origin with highest total stock value |
| Q15 | Products ever sold below list price |
| Q16 | Orders with no matching customer (referential integrity test) |
| Q17 | Customers who have never placed an order |
| Q18 | Products ordered in April 2024 or at least twice in May 2025 |
| Q19 | Orders from customers in Xanthi |
| Q20 | Maximum credit limit exceeded by any customer |

## Tech Stack

- **Database:** PostgreSQL 18
- **Language:** SQL
- **Platform:** macOS

## Project Structure
├── create_tables.sql    # Schema definition with all constraints
├── insert_data.sql      # Sample dataset insertion
├── queries.sql          # All 20 SQL queries
└── writeup.pdf          # Design decisions and assumptions

## How to Run

```bash
# Create the database
psql -U your_username -c "CREATE DATABASE choco_k29;"

# Create tables
psql -U your_username -d choco_k29 -f create_tables.sql

# Insert sample data
psql -U your_username -d choco_k29 -f insert_data.sql

# Run all queries
psql -U your_username -d choco_k29 -f queries.sql
```

## Key Design Decisions

- Used `NUMERIC` instead of `FLOAT` for all monetary values to avoid floating-point rounding errors
- Stored dates as PostgreSQL `DATE` type to enable `EXTRACT()` functions in queries
- Composite primary key `(order_no, prod_code)` in ORDER_DETAILS resolves the many-to-many relationship between orders and products
- Foreign key on `ORDERS.cust_no` made nullable to support Q16 (orphan order detection)

## Author

**Adam Ahmed** — University of Athens, Department of Informatics & Telecommunications
