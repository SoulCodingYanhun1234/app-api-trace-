-- 防伪码级防窜开关：默认开启，保持既有防窜行为。
ALTER TABLE `anti_fake_codes`
  ADD COLUMN `anti_channeling_enabled` BOOLEAN NOT NULL DEFAULT TRUE COMMENT '是否启用防窜校验' AFTER `risk_level`;
