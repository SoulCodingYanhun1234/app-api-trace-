-- Add district/county support to agent region selection.
ALTER TABLE `agents`
  ADD COLUMN `district` VARCHAR(64) NULL AFTER `city`;

DROP INDEX `agents_province_city_idx` ON `agents`;
CREATE INDEX `agents_province_city_district_idx` ON `agents`(`province`, `city`, `district`);
