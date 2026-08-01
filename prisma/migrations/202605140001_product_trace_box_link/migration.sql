-- 产品基础资料补充生产日期、生成地点/生产地点与制造商，用于自动溯源链路沉淀。
ALTER TABLE `products`
  ADD COLUMN `production_date` DATE NULL,
  ADD COLUMN `production_place` VARCHAR(128) NULL,
  ADD COLUMN `manufacturer` VARCHAR(128) NULL,
  ADD INDEX `products_manufacturer_idx` (`manufacturer`);
