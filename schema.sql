-- Database: PostgreSQL
-- Schema for Global Supply Chain Management System

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    role VARCHAR(50) NOT NULL, -- (COORDINATOR, CUSTOMS_AGENT, WAREHOUSE_MANAGER, VENDOR_REP, ADMIN)
    status VARCHAR(20) DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE vendors (
    id SERIAL PRIMARY KEY,
    vendor_code VARCHAR(50) UNIQUE NOT NULL,
    company_name VARCHAR(150) NOT NULL,
    contact_person VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(50),
    country VARCHAR(100),
    rating DECIMAL(3,2) DEFAULT 0.0,
    status VARCHAR(20) DEFAULT 'ACTIVE', -- (ACTIVE, SUSPENDED)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE customers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    email VARCHAR(100),
    phone VARCHAR(50),
    address TEXT,
    country VARCHAR(100)
);

CREATE TABLE warehouses (
    id SERIAL PRIMARY KEY,
    warehouse_code VARCHAR(50) UNIQUE NOT NULL,
    name VARCHAR(150) NOT NULL,
    location TEXT,
    country VARCHAR(100),
    capacity INTEGER,
    current_utilization INTEGER DEFAULT 0
);

CREATE TABLE inventory_items (
    id SERIAL PRIMARY KEY,
    sku VARCHAR(50) UNIQUE NOT NULL,
    name VARCHAR(150) NOT NULL,
    category VARCHAR(100),
    unit_price DECIMAL(10,2),
    weight DECIMAL(10,2),
    warehouse_id INTEGER REFERENCES warehouses(id),
    reorder_level INTEGER DEFAULT 10
);

CREATE TABLE inventory_stock (
    id SERIAL PRIMARY KEY,
    item_id INTEGER REFERENCES inventory_items(id),
    warehouse_id INTEGER REFERENCES warehouses(id),
    quantity_available INTEGER DEFAULT 0,
    quantity_reserved INTEGER DEFAULT 0,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE shipments (
    id SERIAL PRIMARY KEY,
    shipment_code VARCHAR(50) UNIQUE NOT NULL,
    vendor_id INTEGER REFERENCES vendors(id),
    customer_id INTEGER REFERENCES customers(id),
    origin_warehouse_id INTEGER REFERENCES warehouses(id),
    destination TEXT,
    status VARCHAR(50), -- (PENDING, IN_TRANSIT, CUSTOMS, DELIVERED, DELAYED)
    carrier_name VARCHAR(100),
    estimated_delivery TIMESTAMP,
    actual_delivery TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE shipment_items (
    id SERIAL PRIMARY KEY,
    shipment_id INTEGER REFERENCES shipments(id),
    item_id INTEGER REFERENCES inventory_items(id),
    quantity INTEGER NOT NULL
);

CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    order_code VARCHAR(50) UNIQUE NOT NULL,
    customer_id INTEGER REFERENCES customers(id),
    vendor_id INTEGER REFERENCES vendors(id),
    status VARCHAR(50), -- (CREATED, CONFIRMED, PROCESSING, SHIPPED, COMPLETED, CANCELLED)
    total_amount DECIMAL(12,2) DEFAULT 0.0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE order_items (
    id SERIAL PRIMARY KEY,
    order_id INTEGER REFERENCES orders(id),
    item_id INTEGER REFERENCES inventory_items(id),
    quantity INTEGER NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL
);

CREATE TABLE customs_documents (
    id SERIAL PRIMARY KEY,
    shipment_id INTEGER REFERENCES shipments(id),
    document_type VARCHAR(100),
    document_number VARCHAR(100) UNIQUE,
    country VARCHAR(100),
    status VARCHAR(50), -- (PENDING, APPROVED, REJECTED)
    submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    approved_at TIMESTAMP
);

CREATE TABLE vendor_performance (
    id SERIAL PRIMARY KEY,
    vendor_id INTEGER REFERENCES vendors(id),
    evaluation_date DATE NOT NULL,
    on_time_delivery_rate DECIMAL(5,2),
    quality_score DECIMAL(5,2),
    response_time_hours DECIMAL(6,2),
    overall_rating DECIMAL(3,2)
);

CREATE TABLE audit_log (
    id SERIAL PRIMARY KEY,
    entity_name VARCHAR(100),
    entity_id INTEGER,
    action VARCHAR(50),
    performed_by INTEGER REFERENCES users(id),
    performed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    details TEXT
);

CREATE TABLE inventory_alerts (
    id SERIAL PRIMARY KEY,
    item_id INTEGER REFERENCES inventory_items(id),
    warehouse_id INTEGER REFERENCES warehouses(id),
    alert_type VARCHAR(50), -- (LOW_STOCK, OUT_OF_STOCK)
    triggered_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    resolved BOOLEAN DEFAULT FALSE
);

CREATE TABLE route_optimization_log (
    id SERIAL PRIMARY KEY,
    shipment_id INTEGER REFERENCES shipments(id),
    old_route TEXT,
    optimized_route TEXT,
    distance_saved_km DECIMAL(10,2),
    calculated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE exception_log (
    id SERIAL PRIMARY KEY,
    exception_type VARCHAR(200),
    source_component VARCHAR(200),
    message TEXT,
    stack_trace TEXT,
    occurred_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    resolved_status VARCHAR(50)
);

CREATE TABLE transaction_audit (
    id SERIAL PRIMARY KEY,
    transaction_type VARCHAR(100),
    entity_reference VARCHAR(200),
    status VARCHAR(50), -- (COMMITTED, ROLLED_BACK)
    attribute_used VARCHAR(50), -- (REQUIRED, REQUIRES_NEW, etc)
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
