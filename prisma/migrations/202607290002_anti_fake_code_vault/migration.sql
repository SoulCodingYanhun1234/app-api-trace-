-- The legacy `code` column remains non-null and unique for upgrade
-- compatibility, but encrypted rows store only AV1.<sha256> in it. The
-- recoverable code is protected by application-level AES-256-GCM.
ALTER TABLE `anti_fake_codes`
  ADD COLUMN `code_ciphertext` VARBINARY(512) NULL,
  ADD COLUMN `code_iv` BINARY(12) NULL,
  ADD COLUMN `code_tag` BINARY(16) NULL,
  ADD COLUMN `code_key_id` VARCHAR(32) CHARACTER SET ascii COLLATE ascii_bin NULL,
  ADD INDEX `anti_fake_codes_code_key_id_idx` (`code_key_id`),
  ADD CONSTRAINT `anti_fake_codes_vault_complete_chk` CHECK (
    (`code_ciphertext` IS NULL AND `code_iv` IS NULL AND `code_tag` IS NULL AND `code_key_id` IS NULL)
    OR
    (`code_ciphertext` IS NOT NULL AND `code_iv` IS NOT NULL AND `code_tag` IS NOT NULL AND `code_key_id` IS NOT NULL)
  );

-- SQL cannot safely encrypt existing values because the vault key must never
-- be passed to MySQL. After this structural migration, run the application
-- backfill script with --apply before disabling plaintext compatibility.
