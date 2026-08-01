-- Product shelf-life is required by the product creation workflow.
-- This migration is intentionally idempotent for databases that were manually patched.
SET @schema_name = DATABASE();
SET @has_products_shelf_life = (
  SELECT COUNT(1)
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = @schema_name
    AND TABLE_NAME = 'products'
    AND COLUMN_NAME = 'shelf_life'
);
SET @add_products_shelf_life_sql = IF(
  @has_products_shelf_life = 0,
  'ALTER TABLE `products` ADD COLUMN `shelf_life` VARCHAR(64) NULL AFTER `manufacturer`',
  'SELECT 1'
);
PREPARE add_products_shelf_life_stmt FROM @add_products_shelf_life_sql;
EXECUTE add_products_shelf_life_stmt;
DEALLOCATE PREPARE add_products_shelf_life_stmt;
