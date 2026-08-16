-- --------------------------------------------------------
-- schema.sql
-- PostgreSQL 18.4
-- Global Supply Chain Management System (GlobalTrade Logistics Corp.)
-- This replaces the older draft schema.sql (kept as schema.sql.old)
-- which used different table names (inventory_items) and was missing
-- user_id / timer_jobs support. This file now matches the live
-- database and the JPA entities in core/src/main/java/.../entity.
-- --------------------------------------------------------

CREATE TABLE IF NOT EXISTS "users" (
                                       "id" SERIAL NOT NULL,
                                       "username" VARCHAR(50) NOT NULL,
    "password_hash" VARCHAR(255) NOT NULL,
    "email" VARCHAR(150) NULL DEFAULT NULL,
    "full_name" VARCHAR(150) NULL DEFAULT NULL,
    "role" VARCHAR(50) NOT NULL,
    "status" VARCHAR(20) NULL DEFAULT NULL,
    "created_at" TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY ("id"),
    UNIQUE ("username")
    );

CREATE TABLE IF NOT EXISTS "status" (
                                        "id" SERIAL NOT NULL,
                                        "name" VARCHAR(50) NOT NULL,
    "description" VARCHAR(255) NULL DEFAULT NULL,
    PRIMARY KEY ("id")
    );

CREATE TABLE IF NOT EXISTS "vendors" (
                                         "id" SERIAL NOT NULL,
                                         "vendor_code" VARCHAR(50) NOT NULL,
    "company_name" VARCHAR(150) NOT NULL,
    "contact_person" VARCHAR(100) NULL DEFAULT NULL,
    "email" VARCHAR(150) NULL DEFAULT NULL,
    "phone" VARCHAR(30) NULL DEFAULT NULL,
    "country" VARCHAR(100) NULL DEFAULT NULL,
    "rating" NUMERIC(3,2) NULL DEFAULT NULL,
    "status" VARCHAR(20) NULL DEFAULT NULL,
    "created_at" TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    "user_id" BIGINT NULL DEFAULT NULL,
    PRIMARY KEY ("id"),
    UNIQUE ("vendor_code"),
    CONSTRAINT "vendors_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users" ("id")
    );

CREATE TABLE IF NOT EXISTS "customers" (
                                           "id" SERIAL NOT NULL,
                                           "name" VARCHAR(150) NOT NULL,
    "email" VARCHAR(150) NULL DEFAULT NULL,
    "phone" VARCHAR(30) NULL DEFAULT NULL,
    "address" TEXT NULL DEFAULT NULL,
    "country" VARCHAR(100) NULL DEFAULT NULL,
    "user_id" BIGINT NULL DEFAULT NULL,
    PRIMARY KEY ("id"),
    CONSTRAINT "customers_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users" ("id")
    );

CREATE TABLE IF NOT EXISTS "warehouses" (
                                            "id" SERIAL NOT NULL,
                                            "warehouse_code" VARCHAR(50) NOT NULL,
    "name" VARCHAR(150) NOT NULL,
    "location" VARCHAR(200) NULL DEFAULT NULL,
    "country" VARCHAR(100) NULL DEFAULT NULL,
    "capacity" INTEGER NULL DEFAULT NULL,
    "current_utilization" INTEGER NULL DEFAULT NULL,
    "user_id" BIGINT NULL DEFAULT NULL,
    PRIMARY KEY ("id"),
    UNIQUE ("warehouse_code"),
    CONSTRAINT "warehouses_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users" ("id")
    );
CREATE INDEX IF NOT EXISTS "idx_warehouses_user_id" ON "warehouses" ("user_id");

-- NOTE: table is "products" (NOT "inventory_items"). The InventoryItem.java
-- entity maps to this table.
CREATE TABLE IF NOT EXISTS "products" (
                                          "id" SERIAL NOT NULL,
                                          "sku" VARCHAR(50) NOT NULL,
    "name" VARCHAR(150) NOT NULL,
    "category" VARCHAR(100) NULL DEFAULT NULL,
    "weight" NUMERIC(10,2) NULL DEFAULT NULL,
    "reorder_level" INTEGER NULL DEFAULT NULL,
    "vendor_id" BIGINT NULL DEFAULT NULL,
    PRIMARY KEY ("id"),
    UNIQUE ("sku"),
    CONSTRAINT "products_vendor_id_fkey" FOREIGN KEY ("vendor_id") REFERENCES "vendors" ("id")
    );
CREATE INDEX IF NOT EXISTS "idx_products_vendor_id" ON "products" ("vendor_id");

-- NOTE: the product reference column here is "product_id" (NOT "item_id").
-- InventoryStock.java's @JoinColumn must be "product_id".
CREATE TABLE IF NOT EXISTS "inventory_stock" (
                                                 "id" SERIAL NOT NULL,
                                                 "product_id" BIGINT NULL DEFAULT NULL,
                                                 "warehouse_id" BIGINT NULL DEFAULT NULL,
                                                 "last_updated" TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
                                                 "stock_qty" INTEGER NULL DEFAULT NULL,
                                                 "unit_price" NUMERIC(12,2) NULL DEFAULT NULL,
    "status_id" BIGINT NULL DEFAULT NULL,
    PRIMARY KEY ("id"),
    CONSTRAINT "inventory_stock_product_id_fkey" FOREIGN KEY ("product_id") REFERENCES "products" ("id"),
    CONSTRAINT "inventory_stock_status_id_fkey" FOREIGN KEY ("status_id") REFERENCES "status" ("id"),
    CONSTRAINT "inventory_stock_warehouse_id_fkey" FOREIGN KEY ("warehouse_id") REFERENCES "warehouses" ("id")
    );
CREATE INDEX IF NOT EXISTS "idx_inventory_stock_product_id" ON "inventory_stock" ("product_id");
CREATE INDEX IF NOT EXISTS "idx_inventory_stock_warehouse_id" ON "inventory_stock" ("warehouse_id");
CREATE INDEX IF NOT EXISTS "idx_inventory_stock_status_id" ON "inventory_stock" ("status_id");

-- NOTE: this one genuinely IS "item_id" in the live DB - matches InventoryAlert.java as-is.
CREATE TABLE IF NOT EXISTS "inventory_alerts" (
                                                  "id" SERIAL NOT NULL,
                                                  "item_id" BIGINT NULL DEFAULT NULL,
                                                  "warehouse_id" BIGINT NULL DEFAULT NULL,
                                                  "alert_type" VARCHAR(50) NULL DEFAULT NULL,
    "triggered_at" TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    "resolved" BOOLEAN NULL DEFAULT false,
    PRIMARY KEY ("id"),
    CONSTRAINT "inventory_alerts_item_id_fkey" FOREIGN KEY ("item_id") REFERENCES "products" ("id"),
    CONSTRAINT "inventory_alerts_warehouse_id_fkey" FOREIGN KEY ("warehouse_id") REFERENCES "warehouses" ("id")
    );
CREATE INDEX IF NOT EXISTS "idx_inventory_alerts_item_id" ON "inventory_alerts" ("item_id");
CREATE INDEX IF NOT EXISTS "idx_inventory_alerts_warehouse_id" ON "inventory_alerts" ("warehouse_id");
CREATE INDEX IF NOT EXISTS "idx_inventory_alerts_resolved" ON "inventory_alerts" ("resolved");

CREATE TABLE IF NOT EXISTS "orders" (
                                        "id" SERIAL NOT NULL,
                                        "order_code" VARCHAR(100) NOT NULL,
    "customer_id" BIGINT NULL DEFAULT NULL,
    "vendor_id" BIGINT NULL DEFAULT NULL,
    "status" VARCHAR(50) NULL DEFAULT NULL,
    "total_amount" NUMERIC(12,2) NULL DEFAULT NULL,
    "created_at" TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY ("id"),
    UNIQUE ("order_code"),
    CONSTRAINT "orders_customer_id_fkey" FOREIGN KEY ("customer_id") REFERENCES "customers" ("id"),
    CONSTRAINT "orders_vendor_id_fkey" FOREIGN KEY ("vendor_id") REFERENCES "vendors" ("id")
    );
CREATE INDEX IF NOT EXISTS "idx_orders_customer_id" ON "orders" ("customer_id");
CREATE INDEX IF NOT EXISTS "idx_orders_vendor_id" ON "orders" ("vendor_id");

-- NOTE: product reference column is "product_id" (NOT "item_id").
-- OrderItem.java's @JoinColumn must be "product_id".
CREATE TABLE IF NOT EXISTS "order_items" (
                                             "id" SERIAL NOT NULL,
                                             "order_id" BIGINT NULL DEFAULT NULL,
                                             "product_id" BIGINT NULL DEFAULT NULL,
                                             "quantity" INTEGER NULL DEFAULT NULL,
                                             "unit_price" NUMERIC(12,2) NULL DEFAULT NULL,
    PRIMARY KEY ("id"),
    CONSTRAINT "order_items_product_id_fkey" FOREIGN KEY ("product_id") REFERENCES "products" ("id"),
    CONSTRAINT "order_items_order_id_fkey" FOREIGN KEY ("order_id") REFERENCES "orders" ("id")
    );
CREATE INDEX IF NOT EXISTS "idx_order_items_order_id" ON "order_items" ("order_id");
CREATE INDEX IF NOT EXISTS "idx_order_items_product_id" ON "order_items" ("product_id");

CREATE TABLE IF NOT EXISTS "shipments" (
                                           "id" SERIAL NOT NULL,
                                           "shipment_code" VARCHAR(100) NOT NULL,
    "vendor_id" BIGINT NULL DEFAULT NULL,
    "customer_id" BIGINT NULL DEFAULT NULL,
    "origin_warehouse_id" BIGINT NULL DEFAULT NULL,
    "destination" VARCHAR(200) NULL DEFAULT NULL,
    "status" VARCHAR(50) NULL DEFAULT NULL,
    "carrier_name" VARCHAR(100) NULL DEFAULT NULL,
    "estimated_delivery" TIMESTAMP NULL DEFAULT NULL,
    "actual_delivery" TIMESTAMP NULL DEFAULT NULL,
    "created_at" TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY ("id"),
    UNIQUE ("shipment_code"),
    CONSTRAINT "shipments_customer_id_fkey" FOREIGN KEY ("customer_id") REFERENCES "customers" ("id"),
    CONSTRAINT "shipments_origin_warehouse_id_fkey" FOREIGN KEY ("origin_warehouse_id") REFERENCES "warehouses" ("id"),
    CONSTRAINT "shipments_vendor_id_fkey" FOREIGN KEY ("vendor_id") REFERENCES "vendors" ("id")
    );
CREATE INDEX IF NOT EXISTS "idx_shipments_vendor_id" ON "shipments" ("vendor_id");
CREATE INDEX IF NOT EXISTS "idx_shipments_customer_id" ON "shipments" ("customer_id");
CREATE INDEX IF NOT EXISTS "idx_shipments_origin_warehouse_id" ON "shipments" ("origin_warehouse_id");
CREATE INDEX IF NOT EXISTS "idx_shipments_status" ON "shipments" ("status");

-- NOTE: product reference column is "product_id" (NOT "item_id").
-- ShipmentItem.java's @JoinColumn must be "product_id".
CREATE TABLE IF NOT EXISTS "shipment_items" (
                                                "id" SERIAL NOT NULL,
                                                "shipment_id" BIGINT NULL DEFAULT NULL,
                                                "product_id" BIGINT NULL DEFAULT NULL,
                                                "quantity" INTEGER NULL DEFAULT NULL,
                                                PRIMARY KEY ("id"),
    CONSTRAINT "shipment_items_product_id_fkey" FOREIGN KEY ("product_id") REFERENCES "products" ("id"),
    CONSTRAINT "shipment_items_shipment_id_fkey" FOREIGN KEY ("shipment_id") REFERENCES "shipments" ("id")
    );
CREATE INDEX IF NOT EXISTS "idx_shipment_items_shipment_id" ON "shipment_items" ("shipment_id");
CREATE INDEX IF NOT EXISTS "idx_shipment_items_product_id" ON "shipment_items" ("product_id");

CREATE TABLE IF NOT EXISTS "customs_documents" (
                                                   "id" SERIAL NOT NULL,
                                                   "shipment_id" BIGINT NULL DEFAULT NULL,
                                                   "document_type" VARCHAR(100) NULL DEFAULT NULL,
    "document_number" VARCHAR(100) NULL DEFAULT NULL,
    "country" VARCHAR(100) NULL DEFAULT NULL,
    "status" VARCHAR(50) NULL DEFAULT NULL,
    "submitted_at" TIMESTAMP NULL DEFAULT NULL,
    "approved_at" TIMESTAMP NULL DEFAULT NULL,
    PRIMARY KEY ("id"),
    CONSTRAINT "customs_documents_shipment_id_fkey" FOREIGN KEY ("shipment_id") REFERENCES "shipments" ("id")
    );
CREATE INDEX IF NOT EXISTS "idx_customs_documents_shipment_id" ON "customs_documents" ("shipment_id");

CREATE TABLE IF NOT EXISTS "route_optimization_log" (
                                                        "id" SERIAL NOT NULL,
                                                        "shipment_id" BIGINT NULL DEFAULT NULL,
                                                        "old_route" TEXT NULL DEFAULT NULL,
                                                        "optimized_route" TEXT NULL DEFAULT NULL,
                                                        "distance_saved_km" NUMERIC(10,2) NULL DEFAULT NULL,
    "calculated_at" TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY ("id"),
    CONSTRAINT "route_optimization_log_shipment_id_fkey" FOREIGN KEY ("shipment_id") REFERENCES "shipments" ("id")
    );
CREATE INDEX IF NOT EXISTS "idx_route_optimization_log_shipment_id" ON "route_optimization_log" ("shipment_id");

CREATE TABLE IF NOT EXISTS "vendor_performance" (
                                                    "id" SERIAL NOT NULL,
                                                    "vendor_id" BIGINT NULL DEFAULT NULL,
                                                    "evaluation_date" DATE NULL DEFAULT NULL,
                                                    "on_time_delivery_rate" NUMERIC(5,2) NULL DEFAULT NULL,
    "quality_score" NUMERIC(5,2) NULL DEFAULT NULL,
    "response_time_hours" NUMERIC(5,2) NULL DEFAULT NULL,
    "overall_rating" NUMERIC(5,2) NULL DEFAULT NULL,
    PRIMARY KEY ("id"),
    CONSTRAINT "vendor_performance_vendor_id_fkey" FOREIGN KEY ("vendor_id") REFERENCES "vendors" ("id")
    );
CREATE INDEX IF NOT EXISTS "idx_vendor_performance_vendor_id" ON "vendor_performance" ("vendor_id");

CREATE TABLE IF NOT EXISTS "audit_log" (
                                           "id" SERIAL NOT NULL,
                                           "entity_name" VARCHAR(100) NULL DEFAULT NULL,
    "entity_id" BIGINT NULL DEFAULT NULL,
    "action" VARCHAR(100) NULL DEFAULT NULL,
    "performed_by" BIGINT NULL DEFAULT NULL,
    "performed_at" TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    "details" TEXT NULL DEFAULT NULL,
    PRIMARY KEY ("id"),
    CONSTRAINT "audit_log_performed_by_fkey" FOREIGN KEY ("performed_by") REFERENCES "users" ("id")
    );
CREATE INDEX IF NOT EXISTS "idx_audit_log_performed_by" ON "audit_log" ("performed_by");

CREATE TABLE IF NOT EXISTS "exception_log" (
                                               "id" SERIAL NOT NULL,
                                               "exception_type" VARCHAR(150) NULL DEFAULT NULL,
    "source_component" VARCHAR(100) NULL DEFAULT NULL,
    "message" TEXT NULL DEFAULT NULL,
    "stack_trace" TEXT NULL DEFAULT NULL,
    "occurred_at" TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    "resolved_status" VARCHAR(50) NULL DEFAULT NULL,
    PRIMARY KEY ("id")
    );

CREATE TABLE IF NOT EXISTS "transaction_audit" (
                                                   "id" SERIAL NOT NULL,
                                                   "transaction_type" VARCHAR(100) NULL DEFAULT NULL,
    "entity_reference" VARCHAR(150) NULL DEFAULT NULL,
    "status" VARCHAR(50) NULL DEFAULT NULL,
    "attribute_used" VARCHAR(50) NULL DEFAULT NULL,
    "timestamp" TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    "performed_by" BIGINT NULL DEFAULT NULL,
    PRIMARY KEY ("id"),
    CONSTRAINT "transaction_audit_performed_by_fkey" FOREIGN KEY ("performed_by") REFERENCES "users" ("id")
    );
CREATE INDEX IF NOT EXISTS "idx_transaction_audit_performed_by" ON "transaction_audit" ("performed_by");

-- Backs the TimerJob.java entity / EJB Timer Service persistence requirement.
CREATE TABLE IF NOT EXISTS "timer_jobs" (
                                            "id" SERIAL NOT NULL,
                                            "job_name" VARCHAR(150) NOT NULL,
    "job_type" VARCHAR(100) NULL DEFAULT NULL,
    "creation_type" VARCHAR(20) NULL DEFAULT NULL,
    "schedule_expression" VARCHAR(150) NULL DEFAULT NULL,
    "interval_seconds" INTEGER NULL DEFAULT NULL,
    "last_run_at" TIMESTAMP NULL DEFAULT NULL,
    "next_run_at" TIMESTAMP NULL DEFAULT NULL,
    "last_run_status" VARCHAR(50) NULL DEFAULT NULL,
    "is_persistent" BOOLEAN NULL DEFAULT true,
    "status" VARCHAR(50) NULL DEFAULT 'SCHEDULED',
    "created_at" TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY ("id")
    );
