ALTER TABLE `anti_fake_codes`
  ADD COLUMN `expires_at` DATE NULL COMMENT '防伪码过期日期，可为空表示长期有效';

CREATE INDEX `anti_fake_codes_expires_at_idx` ON `anti_fake_codes` (`expires_at`);
