-- 防伪码单码防窜开关：默认开启，关闭后该码扫码不再触发防窜评估。
ALTER TABLE `anti_fake_codes` ADD COLUMN `anti_channeling` BOOLEAN NOT NULL DEFAULT TRUE;
