-- 产品地区绑定实际防伪码，并允许发货单显式选择目的地区。
ALTER TABLE `product_regions`
  ADD COLUMN `codes` JSON NULL AFTER `code_rule`;

ALTER TABLE `shipments`
  ADD COLUMN `province_code` VARCHAR(16) NULL AFTER `receiver_address`,
  ADD COLUMN `city_code` VARCHAR(16) NULL AFTER `province_code`,
  ADD COLUMN `province_name` VARCHAR(64) NULL AFTER `city_code`,
  ADD COLUMN `city_name` VARCHAR(64) NULL AFTER `province_name`,
  ADD COLUMN `region_group` VARCHAR(128) NULL AFTER `city_name`,
  ADD COLUMN `warehouse` VARCHAR(128) NULL AFTER `region_group`,
  ADD COLUMN `distributor` VARCHAR(128) NULL AFTER `warehouse`;

CREATE INDEX `shipments_province_name_city_name_idx` ON `shipments`(`province_name`, `city_name`);
