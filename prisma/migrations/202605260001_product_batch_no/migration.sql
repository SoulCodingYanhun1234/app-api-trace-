-- 产品管理新增生产批号，用于防伪码生成时自动继承产品批号。
ALTER TABLE `products`
  ADD COLUMN `batch_no` VARCHAR(64) NULL AFTER `product_name`,
  ADD INDEX `products_batch_no_idx` (`batch_no`);
