-- 发货管理新增发货批次号，用于手动维护每次发货批次并同步物流流向。
ALTER TABLE `shipments`
  ADD COLUMN `batch_no` VARCHAR(64) NULL AFTER `shipment_no`,
  ADD INDEX `shipments_batch_no_idx` (`batch_no`);
