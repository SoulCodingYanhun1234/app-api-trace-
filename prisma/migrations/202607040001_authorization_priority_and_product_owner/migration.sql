-- 产品可归属公司或代理商，并保存位置快照。
ALTER TABLE `products`
  ADD COLUMN `owner_type` VARCHAR(16) NULL AFTER `manufacturer`,
  ADD COLUMN `owner_id` INT NULL AFTER `owner_type`,
  ADD COLUMN `owner_name` VARCHAR(128) NULL AFTER `owner_id`,
  ADD COLUMN `owner_province` VARCHAR(64) NULL AFTER `owner_name`,
  ADD COLUMN `owner_city` VARCHAR(64) NULL AFTER `owner_province`,
  ADD COLUMN `owner_address` VARCHAR(255) NULL AFTER `owner_city`;

CREATE INDEX `products_owner_type_owner_id_idx` ON `products` (`owner_type`, `owner_id`);

-- 三级授权位置快照：3=产品主体，2=装箱位置，1=发货目的代理商。
ALTER TABLE `anti_fake_codes`
  ADD COLUMN `authorization_level` INT NOT NULL DEFAULT 3 AFTER `company_name`,
  ADD COLUMN `authorization_source` VARCHAR(64) NULL AFTER `authorization_level`,
  ADD COLUMN `authorization_address` VARCHAR(255) NULL AFTER `authorization_source`;

ALTER TABLE `boxes`
  ADD COLUMN `packing_address` VARCHAR(255) NULL AFTER `company_name`,
  ADD COLUMN `authorization_level` INT NOT NULL DEFAULT 2 AFTER `packing_address`,
  ADD COLUMN `authorization_source` VARCHAR(64) NULL AFTER `authorization_level`,
  ADD COLUMN `authorization_address` VARCHAR(255) NULL AFTER `authorization_source`;

ALTER TABLE `shipments`
  ADD COLUMN `authorization_level` INT NOT NULL DEFAULT 1 AFTER `distributor`,
  ADD COLUMN `authorization_source` VARCHAR(64) NULL AFTER `authorization_level`,
  ADD COLUMN `authorization_address` VARCHAR(255) NULL AFTER `authorization_source`;

-- 兼容历史产品：先把原公司名称作为产品主体名称，主体ID等待用户编辑时补齐。
UPDATE `products`
SET `owner_type` = COALESCE(`owner_type`, 'company'),
    `owner_name` = COALESCE(`owner_name`, `manufacturer`)
WHERE (`owner_type` IS NULL OR `owner_name` IS NULL)
  AND `manufacturer` IS NOT NULL
  AND `manufacturer` <> '';

-- 历史防伪码按当前绑定状态推断授权级别。
UPDATE `anti_fake_codes`
SET `authorization_level` = CASE WHEN `box_id` IS NOT NULL THEN 2 ELSE 3 END,
    `authorization_source` = CASE WHEN `box_id` IS NOT NULL THEN 'box_location' ELSE 'product_owner' END,
    `authorization_address` = COALESCE(`authorization_address`, `region_group`);

UPDATE `boxes`
SET `authorization_level` = CASE WHEN `status` = 2 THEN 1 ELSE 2 END,
    `authorization_source` = CASE WHEN `status` = 2 THEN 'shipment_destination_agent' ELSE 'box_location' END,
    `authorization_address` = COALESCE(`authorization_address`, `packing_address`, `region_group`);

UPDATE `shipments`
SET `authorization_level` = 1,
    `authorization_source` = 'shipment_destination_agent',
    `authorization_address` = COALESCE(`authorization_address`, `receiver_address`, `region_group`);
