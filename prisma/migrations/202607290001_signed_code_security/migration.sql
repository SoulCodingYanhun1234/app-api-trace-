-- Signed codes are case-sensitive. Keep Unicode compatibility for legacy
-- prefixes while preventing the default case-insensitive collation from
-- accepting a case-mutated signature as the same database value.
ALTER TABLE `anti_fake_codes`
  MODIFY `code` VARCHAR(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  MODIFY `code_hash` VARCHAR(64) CHARACTER SET ascii COLLATE ascii_bin NULL;

-- Existing codes remain available only when the explicit legacy policy is
-- enabled. Backfill the exact SHA-256 index so lookups no longer depend on the
-- plaintext column collation.
UPDATE `anti_fake_codes`
SET `code_hash` = LOWER(SHA2(BINARY `code`, 256))
WHERE `code_hash` IS NULL OR `code_hash` = '';
