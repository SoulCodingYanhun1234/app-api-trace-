-- Client-supplied location must remain distinguishable from server-verified evidence.
ALTER TABLE `query_logs`
  ADD COLUMN `location_source` VARCHAR(64) NULL AFTER `location`,
  ADD COLUMN `location_verified` BOOLEAN NOT NULL DEFAULT FALSE AFTER `location_source`,
  ADD INDEX `query_logs_code_location_verified_created_at_idx` (`code`, `location_verified`, `created_at`);
