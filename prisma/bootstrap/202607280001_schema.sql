-- Frozen bootstrap generated from 202607280001_schema.prisma.
-- Do not append application changes here; add a normal Prisma migration.
-- Migrations after 202607280001 are intentionally applied by migrate deploy.

-- CreateTable
CREATE TABLE `admins` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `username` VARCHAR(64) NOT NULL,
    `password_hash` VARCHAR(255) NOT NULL,
    `real_name` VARCHAR(64) NOT NULL,
    `email` VARCHAR(128) NULL,
    `phone` VARCHAR(32) NULL,
    `role` INTEGER NOT NULL DEFAULT 2,
    `status` INTEGER NOT NULL DEFAULT 1,
    `permissions` JSON NULL,
    `avatar` VARCHAR(255) NULL,
    `last_login_at` DATETIME(3) NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    UNIQUE INDEX `admins_username_key`(`username`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `roles` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `role_code` VARCHAR(64) NOT NULL,
    `role_name` VARCHAR(80) NOT NULL,
    `description` VARCHAR(255) NULL,
    `status` INTEGER NOT NULL DEFAULT 1,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    UNIQUE INDEX `roles_role_code_key`(`role_code`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `permissions` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `permission_code` VARCHAR(120) NOT NULL,
    `permission_name` VARCHAR(120) NOT NULL,
    `module` VARCHAR(80) NULL,
    `description` VARCHAR(255) NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    UNIQUE INDEX `permissions_permission_code_key`(`permission_code`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `user_roles` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `user_id` INTEGER NOT NULL,
    `role_id` INTEGER NOT NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    UNIQUE INDEX `user_roles_user_id_role_id_key`(`user_id`, `role_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `role_permissions` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `role_id` INTEGER NOT NULL,
    `permission_id` INTEGER NOT NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    UNIQUE INDEX `role_permissions_role_id_permission_id_key`(`role_id`, `permission_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `products` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `product_code` VARCHAR(64) NOT NULL,
    `product_name` VARCHAR(128) NOT NULL,
    `batch_no` VARCHAR(64) NULL,
    `category` VARCHAR(64) NULL,
    `brand` VARCHAR(64) NULL,
    `specification` VARCHAR(128) NULL,
    `unit` VARCHAR(32) NULL,
    `production_date` DATE NULL,
    `production_place` VARCHAR(128) NULL,
    `manufacturer` VARCHAR(128) NULL,
    `shelf_life` VARCHAR(64) NULL,
    `description` VARCHAR(191) NULL,
    `image_url` VARCHAR(255) NULL,
    `extra_fields` JSON NULL,
    `status` INTEGER NOT NULL DEFAULT 1,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    UNIQUE INDEX `products_product_code_key`(`product_code`),
    INDEX `products_status_idx`(`status`),
    INDEX `products_category_idx`(`category`),
    INDEX `products_manufacturer_idx`(`manufacturer`),
    INDEX `products_batch_no_idx`(`batch_no`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `manufacturers` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `manufacturer_code` VARCHAR(64) NULL,
    `manufacturer_name` VARCHAR(128) NOT NULL,
    `company_name` VARCHAR(128) NULL,
    `social_credit_code` VARCHAR(128) NULL,
    `legal_person` VARCHAR(64) NULL,
    `contact_name` VARCHAR(64) NULL,
    `contact_phone` VARCHAR(32) NULL,
    `contact_email` VARCHAR(128) NULL,
    `province` VARCHAR(64) NULL,
    `city` VARCHAR(64) NULL,
    `address` VARCHAR(255) NULL,
    `business_license` VARCHAR(255) NULL,
    `production_license` VARCHAR(128) NULL,
    `quality_report` JSON NULL,
    `status` INTEGER NOT NULL DEFAULT 1,
    `remark` VARCHAR(191) NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    UNIQUE INDEX `manufacturers_manufacturer_code_key`(`manufacturer_code`),
    INDEX `manufacturers_status_idx`(`status`),
    INDEX `manufacturers_manufacturer_name_idx`(`manufacturer_name`),
    INDEX `manufacturers_company_name_idx`(`company_name`),
    INDEX `manufacturers_province_city_idx`(`province`, `city`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `agents` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `agent_code` VARCHAR(64) NULL,
    `agent_name` VARCHAR(128) NULL,
    `contact_name` VARCHAR(64) NULL,
    `contact_phone` VARCHAR(32) NULL,
    `contact_email` VARCHAR(128) NULL,
    `province` VARCHAR(64) NULL,
    `city` VARCHAR(64) NULL,
    `district` VARCHAR(64) NULL,
    `address` VARCHAR(255) NULL,
    `business_license` VARCHAR(128) NULL,
    `level` INTEGER NULL,
    `parent_id` INTEGER NULL,
    `status` INTEGER NOT NULL DEFAULT 1,
    `remark` VARCHAR(191) NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    UNIQUE INDEX `agents_agent_code_key`(`agent_code`),
    INDEX `agents_status_idx`(`status`),
    INDEX `agents_province_city_district_idx`(`province`, `city`, `district`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `product_regions` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `product_id` INTEGER NULL,
    `product_code` VARCHAR(64) NULL,
    `product_name` VARCHAR(128) NULL,
    `brand` VARCHAR(64) NULL,
    `category` VARCHAR(64) NULL,
    `province_code` VARCHAR(16) NULL,
    `city_code` VARCHAR(16) NULL,
    `province_name` VARCHAR(64) NULL,
    `city_name` VARCHAR(64) NULL,
    `region_group` VARCHAR(128) NULL,
    `warehouse` VARCHAR(128) NULL,
    `distributor` VARCHAR(128) NULL,
    `agent_id` INTEGER NULL,
    `authorized_status` VARCHAR(64) NULL DEFAULT '正常授权',
    `code_rule` VARCHAR(128) NULL,
    `codes` JSON NULL,
    `scan_count` INTEGER NOT NULL DEFAULT 0,
    `last_scan_code` VARCHAR(128) NULL,
    `last_scan_at` DATETIME(3) NULL,
    `remark` VARCHAR(191) NULL,
    `status` INTEGER NOT NULL DEFAULT 1,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    INDEX `product_regions_product_id_idx`(`product_id`),
    INDEX `product_regions_product_code_idx`(`product_code`),
    INDEX `product_regions_province_code_city_code_idx`(`province_code`, `city_code`),
    INDEX `product_regions_province_name_city_name_idx`(`province_name`, `city_name`),
    INDEX `product_regions_agent_id_idx`(`agent_id`),
    INDEX `product_regions_status_idx`(`status`),
    UNIQUE INDEX `product_regions_product_code_province_name_city_name_key`(`product_code`, `province_name`, `city_name`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `certificates` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `cert_name` VARCHAR(128) NULL,
    `cert_type` VARCHAR(64) NULL,
    `product_id` INTEGER NULL,
    `issuing_authority` VARCHAR(128) NULL,
    `issue_date` DATE NULL,
    `expiry_date` DATE NULL,
    `cert_image` VARCHAR(255) NULL,
    `cert_file` VARCHAR(255) NULL,
    `status` INTEGER NOT NULL DEFAULT 1,
    `remark` VARCHAR(191) NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    INDEX `certificates_product_id_idx`(`product_id`),
    INDEX `certificates_status_idx`(`status`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `process_records` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `product_id` INTEGER NULL,
    `batch_no` VARCHAR(64) NULL,
    `process_type` VARCHAR(64) NULL,
    `process_name` VARCHAR(128) NULL,
    `process_content` VARCHAR(191) NULL,
    `process_data` JSON NULL,
    `operator` VARCHAR(64) NULL,
    `location` VARCHAR(128) NULL,
    `process_time` DATETIME(3) NULL,
    `status` INTEGER NOT NULL DEFAULT 1,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    INDEX `process_records_product_id_idx`(`product_id`),
    INDEX `process_records_batch_no_idx`(`batch_no`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `anti_fake_codes` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `product_id` INTEGER NULL,
    `code` VARCHAR(128) NOT NULL,
    `code_hash` VARCHAR(64) NULL,
    `prefix` VARCHAR(32) NULL,
    `serial_number` VARCHAR(32) NULL,
    `checksum` VARCHAR(8) NULL,
    `parent_code` VARCHAR(128) NULL,
    `packaging_level` VARCHAR(32) NULL,
    `risk_level` VARCHAR(32) NULL,
    `anti_channeling_enabled` BOOLEAN NOT NULL DEFAULT true,
    `batch_no` VARCHAR(64) NULL,
    `status` INTEGER NOT NULL DEFAULT 0,
    `query_count` INTEGER NOT NULL DEFAULT 0,
    `box_id` INTEGER NULL,
    `box_no` VARCHAR(128) NULL,
    `product_code` VARCHAR(64) NULL,
    `product_name` VARCHAR(128) NULL,
    `category` VARCHAR(64) NULL,
    `brand` VARCHAR(64) NULL,
    `specification` VARCHAR(128) NULL,
    `unit` VARCHAR(32) NULL,
    `production_place` VARCHAR(128) NULL,
    `manufacturer` VARCHAR(128) NULL,
    `province_code` VARCHAR(16) NULL,
    `city_code` VARCHAR(16) NULL,
    `province_name` VARCHAR(64) NULL,
    `city_name` VARCHAR(64) NULL,
    `region_group` VARCHAR(128) NULL,
    `warehouse` VARCHAR(128) NULL,
    `distributor` VARCHAR(128) NULL,
    `agent_id` INTEGER NULL,
    `agent_name` VARCHAR(128) NULL,
    `company_name` VARCHAR(128) NULL,
    `box_bound_at` DATETIME(3) NULL,
    `ownership_at` DATETIME(3) NULL,
    `activated_at` DATETIME(3) NULL,
    `expires_at` DATE NULL,
    `first_query_at` DATETIME(3) NULL,
    `last_query_at` DATETIME(3) NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    UNIQUE INDEX `anti_fake_codes_code_key`(`code`),
    UNIQUE INDEX `anti_fake_codes_code_hash_key`(`code_hash`),
    INDEX `anti_fake_codes_product_id_idx`(`product_id`),
    INDEX `anti_fake_codes_batch_no_idx`(`batch_no`),
    INDEX `anti_fake_codes_status_idx`(`status`),
    INDEX `anti_fake_codes_expires_at_idx`(`expires_at`),
    INDEX `anti_fake_codes_box_id_idx`(`box_id`),
    INDEX `anti_fake_codes_box_no_idx`(`box_no`),
    INDEX `anti_fake_codes_product_code_idx`(`product_code`),
    INDEX `anti_fake_codes_manufacturer_idx`(`manufacturer`),
    INDEX `anti_fake_codes_province_name_city_name_idx`(`province_name`, `city_name`),
    INDEX `anti_fake_codes_agent_id_idx`(`agent_id`),
    INDEX `anti_fake_codes_code_hash_idx`(`code_hash`),
    INDEX `anti_fake_codes_parent_code_idx`(`parent_code`),
    INDEX `anti_fake_codes_packaging_level_idx`(`packaging_level`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `trace_records` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `product_id` INTEGER NULL,
    `trace_no` VARCHAR(128) NULL,
    `anti_fake_code` VARCHAR(128) NULL,
    `batch_no` VARCHAR(64) NULL,
    `production_date` DATE NULL,
    `expiry_date` DATE NULL,
    `production_place` VARCHAR(128) NULL,
    `manufacturer` VARCHAR(128) NULL,
    `trace_chain` JSON NULL,
    `status` INTEGER NOT NULL DEFAULT 1,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    UNIQUE INDEX `trace_records_trace_no_key`(`trace_no`),
    INDEX `trace_records_product_id_idx`(`product_id`),
    INDEX `trace_records_anti_fake_code_idx`(`anti_fake_code`),
    INDEX `trace_records_batch_no_idx`(`batch_no`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `boxes` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `product_id` INTEGER NULL,
    `box_no` VARCHAR(128) NULL,
    `batch_no` VARCHAR(64) NULL,
    `box_capacity` INTEGER NULL,
    `box_spec` VARCHAR(128) NULL,
    `box_type` VARCHAR(64) NULL,
    `product_code` VARCHAR(64) NULL,
    `product_name` VARCHAR(128) NULL,
    `category` VARCHAR(64) NULL,
    `brand` VARCHAR(64) NULL,
    `specification` VARCHAR(128) NULL,
    `unit` VARCHAR(32) NULL,
    `production_place` VARCHAR(128) NULL,
    `manufacturer` VARCHAR(128) NULL,
    `province_code` VARCHAR(16) NULL,
    `city_code` VARCHAR(16) NULL,
    `province_name` VARCHAR(64) NULL,
    `city_name` VARCHAR(64) NULL,
    `region_group` VARCHAR(128) NULL,
    `warehouse` VARCHAR(128) NULL,
    `distributor` VARCHAR(128) NULL,
    `agent_id` INTEGER NULL,
    `agent_name` VARCHAR(128) NULL,
    `company_name` VARCHAR(128) NULL,
    `packing_address` VARCHAR(255) NULL,
    `authorization_address` VARCHAR(255) NULL,
    `authorization_level` VARCHAR(32) NULL,
    `authorization_source` VARCHAR(64) NULL,
    `codes` JSON NULL,
    `status` INTEGER NOT NULL DEFAULT 0,
    `ownership_at` DATETIME(3) NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    UNIQUE INDEX `boxes_box_no_key`(`box_no`),
    INDEX `boxes_product_id_idx`(`product_id`),
    INDEX `boxes_batch_no_idx`(`batch_no`),
    INDEX `boxes_status_idx`(`status`),
    INDEX `boxes_product_code_idx`(`product_code`),
    INDEX `boxes_province_name_city_name_idx`(`province_name`, `city_name`),
    INDEX `boxes_agent_id_idx`(`agent_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `shipments` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `shipment_no` VARCHAR(128) NULL,
    `batch_no` VARCHAR(64) NULL,
    `agent_id` INTEGER NULL,
    `box_ids` JSON NULL,
    `logistics_company` VARCHAR(128) NULL,
    `logistics_no` VARCHAR(128) NULL,
    `sender` VARCHAR(64) NULL,
    `sender_address` VARCHAR(255) NULL,
    `receiver` VARCHAR(64) NULL,
    `receiver_phone` VARCHAR(32) NULL,
    `receiver_address` VARCHAR(255) NULL,
    `province_code` VARCHAR(16) NULL,
    `city_code` VARCHAR(16) NULL,
    `province_name` VARCHAR(64) NULL,
    `city_name` VARCHAR(64) NULL,
    `region_group` VARCHAR(128) NULL,
    `warehouse` VARCHAR(128) NULL,
    `distributor` VARCHAR(128) NULL,
    `authorization_address` VARCHAR(255) NULL,
    `authorization_level` VARCHAR(32) NULL,
    `authorization_source` VARCHAR(64) NULL,
    `status` INTEGER NOT NULL DEFAULT 0,
    `remark` VARCHAR(191) NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    UNIQUE INDEX `shipments_shipment_no_key`(`shipment_no`),
    INDEX `shipments_agent_id_idx`(`agent_id`),
    INDEX `shipments_batch_no_idx`(`batch_no`),
    INDEX `shipments_province_name_city_name_idx`(`province_name`, `city_name`),
    INDEX `shipments_status_idx`(`status`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `returns` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `return_no` VARCHAR(128) NULL,
    `shipment_id` INTEGER NULL,
    `shipment_no` VARCHAR(128) NULL,
    `agent_id` INTEGER NULL,
    `agent_name` VARCHAR(128) NULL,
    `return_codes` JSON NULL,
    `return_reason` VARCHAR(255) NULL,
    `return_type` INTEGER NULL,
    `status` INTEGER NOT NULL DEFAULT 0,
    `remark` VARCHAR(191) NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    UNIQUE INDEX `returns_return_no_key`(`return_no`),
    INDEX `returns_shipment_id_idx`(`shipment_id`),
    INDEX `returns_agent_id_idx`(`agent_id`),
    INDEX `returns_status_idx`(`status`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `query_logs` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `code` VARCHAR(128) NULL,
    `result` INTEGER NULL,
    `channel` VARCHAR(64) NULL,
    `location` VARCHAR(128) NULL,
    `ip` VARCHAR(64) NULL,
    `user_agent` VARCHAR(512) NULL,
    `query_count` INTEGER NOT NULL DEFAULT 0,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    INDEX `query_logs_code_idx`(`code`),
    INDEX `query_logs_result_idx`(`result`),
    INDEX `query_logs_ip_idx`(`ip`),
    INDEX `query_logs_created_at_idx`(`created_at`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `risk_events` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `event_type` VARCHAR(64) NOT NULL,
    `code` VARCHAR(128) NULL,
    `ip` VARCHAR(64) NULL,
    `device_id` VARCHAR(128) NULL,
    `reason` VARCHAR(255) NULL,
    `payload` JSON NULL,
    `status` INTEGER NOT NULL DEFAULT 0,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    INDEX `risk_events_event_type_idx`(`event_type`),
    INDEX `risk_events_code_idx`(`code`),
    INDEX `risk_events_ip_idx`(`ip`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `anti_channeling_rules` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `rule_code` VARCHAR(64) NOT NULL,
    `rule_name` VARCHAR(128) NOT NULL,
    `rule_type` VARCHAR(64) NOT NULL,
    `enabled` BOOLEAN NOT NULL DEFAULT true,
    `severity` INTEGER NOT NULL DEFAULT 2,
    `threshold` INTEGER NULL,
    `window_seconds` INTEGER NULL,
    `config` JSON NULL,
    `notify_channels` JSON NULL,
    `description` VARCHAR(255) NULL,
    `status` INTEGER NOT NULL DEFAULT 1,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    UNIQUE INDEX `anti_channeling_rules_rule_code_key`(`rule_code`),
    INDEX `anti_channeling_rules_rule_type_idx`(`rule_type`),
    INDEX `anti_channeling_rules_enabled_status_idx`(`enabled`, `status`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `anti_channeling_alerts` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `alert_no` VARCHAR(64) NOT NULL,
    `alert_type` VARCHAR(64) NOT NULL,
    `severity` INTEGER NOT NULL DEFAULT 2,
    `title` VARCHAR(255) NULL,
    `code` VARCHAR(128) NULL,
    `box_no` VARCHAR(128) NULL,
    `shipment_no` VARCHAR(128) NULL,
    `product_id` INTEGER NULL,
    `product_code` VARCHAR(64) NULL,
    `product_name` VARCHAR(128) NULL,
    `agent_id` INTEGER NULL,
    `agent_name` VARCHAR(128) NULL,
    `authorized_region` VARCHAR(255) NULL,
    `authorized_province` VARCHAR(64) NULL,
    `authorized_city` VARCHAR(64) NULL,
    `actual_location` VARCHAR(255) NULL,
    `actual_province` VARCHAR(64) NULL,
    `actual_city` VARCHAR(64) NULL,
    `ip` VARCHAR(64) NULL,
    `device_id` VARCHAR(128) NULL,
    `user_agent` VARCHAR(512) NULL,
    `scan_time` DATETIME(3) NULL,
    `first_seen_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `last_seen_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `evidence` JSON NULL,
    `notification_channels` JSON NULL,
    `status` INTEGER NOT NULL DEFAULT 0,
    `handle_result` VARCHAR(255) NULL,
    `handled_by` INTEGER NULL,
    `handled_at` DATETIME(3) NULL,
    `remark` VARCHAR(255) NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    UNIQUE INDEX `anti_channeling_alerts_alert_no_key`(`alert_no`),
    INDEX `anti_channeling_alerts_alert_type_idx`(`alert_type`),
    INDEX `anti_channeling_alerts_severity_idx`(`severity`),
    INDEX `anti_channeling_alerts_status_idx`(`status`),
    INDEX `anti_channeling_alerts_code_idx`(`code`),
    INDEX `anti_channeling_alerts_box_no_idx`(`box_no`),
    INDEX `anti_channeling_alerts_shipment_no_idx`(`shipment_no`),
    INDEX `anti_channeling_alerts_agent_id_idx`(`agent_id`),
    INDEX `anti_channeling_alerts_actual_province_actual_city_idx`(`actual_province`, `actual_city`),
    INDEX `anti_channeling_alerts_created_at_idx`(`created_at`),
    INDEX `anti_channeling_alerts_last_seen_at_idx`(`last_seen_at`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `anti_channeling_notifications` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `alert_id` INTEGER NOT NULL,
    `channel` VARCHAR(32) NOT NULL,
    `receiver` VARCHAR(128) NULL,
    `target` VARCHAR(255) NULL,
    `status` INTEGER NOT NULL DEFAULT 0,
    `payload` JSON NULL,
    `error` VARCHAR(255) NULL,
    `sent_at` DATETIME(3) NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    INDEX `anti_channeling_notifications_alert_id_idx`(`alert_id`),
    INDEX `anti_channeling_notifications_channel_idx`(`channel`),
    INDEX `anti_channeling_notifications_status_idx`(`status`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `system_settings` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `group_key` VARCHAR(80) NOT NULL,
    `setting_key` VARCHAR(120) NOT NULL,
    `setting_value` JSON NULL,
    `value_type` VARCHAR(32) NULL DEFAULT 'json',
    `remark` VARCHAR(255) NULL,
    `updated_by` INTEGER NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    UNIQUE INDEX `system_settings_group_key_setting_key_key`(`group_key`, `setting_key`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `audit_logs` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `admin_id` INTEGER NULL,
    `username` VARCHAR(64) NULL,
    `module` VARCHAR(64) NULL,
    `action` VARCHAR(32) NULL,
    `path` VARCHAR(255) NULL,
    `ip` VARCHAR(64) NULL,
    `user_agent` VARCHAR(512) NULL,
    `status` INTEGER NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    INDEX `audit_logs_admin_id_idx`(`admin_id`),
    INDEX `audit_logs_module_idx`(`module`),
    INDEX `audit_logs_created_at_idx`(`created_at`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `login_logs` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `admin_id` INTEGER NULL,
    `username` VARCHAR(64) NULL,
    `ip` VARCHAR(64) NULL,
    `user_agent` VARCHAR(512) NULL,
    `success` BOOLEAN NOT NULL DEFAULT false,
    `reason` VARCHAR(255) NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    INDEX `login_logs_username_idx`(`username`),
    INDEX `login_logs_created_at_idx`(`created_at`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `files` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `file_name` VARCHAR(255) NOT NULL,
    `original_name` VARCHAR(255) NULL,
    `mime_type` VARCHAR(128) NULL,
    `size_bytes` INTEGER NULL,
    `storage_path` VARCHAR(500) NOT NULL,
    `public_url` VARCHAR(500) NOT NULL,
    `category` VARCHAR(64) NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    INDEX `files_category_idx`(`category`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `production_batches` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `batch_code` VARCHAR(64) NOT NULL,
    `product_id` INTEGER NULL,
    `factory_id` VARCHAR(64) NULL,
    `planned_quantity` INTEGER NULL,
    `actual_quantity` INTEGER NULL,
    `production_date` DATE NULL,
    `expiry_date` DATE NULL,
    `status` VARCHAR(32) NULL DEFAULT 'CREATED',
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    UNIQUE INDEX `production_batches_batch_code_key`(`batch_code`),
    INDEX `production_batches_product_id_idx`(`product_id`),
    INDEX `production_batches_status_idx`(`status`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `production_steps` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `batch_code` VARCHAR(64) NOT NULL,
    `step_type` VARCHAR(64) NOT NULL,
    `step_name` VARCHAR(128) NULL,
    `operator_id` VARCHAR(64) NULL,
    `start_time` DATETIME(3) NULL,
    `end_time` DATETIME(3) NULL,
    `quantity` INTEGER NULL,
    `quality_status` VARCHAR(32) NULL,
    `blockchain_hash` VARCHAR(64) NULL,
    `payload` JSON NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    INDEX `production_steps_batch_code_idx`(`batch_code`),
    INDEX `production_steps_step_type_idx`(`step_type`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `warehouse_in_records` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `code` VARCHAR(128) NOT NULL,
    `batch_code` VARCHAR(64) NULL,
    `warehouse_id` VARCHAR(64) NULL,
    `quantity` INTEGER NOT NULL DEFAULT 1,
    `in_time` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `operator_id` VARCHAR(64) NULL,
    `status` VARCHAR(32) NULL DEFAULT 'IN_STOCK',
    `payload` JSON NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    INDEX `warehouse_in_records_code_idx`(`code`),
    INDEX `warehouse_in_records_batch_code_idx`(`batch_code`),
    INDEX `warehouse_in_records_warehouse_id_idx`(`warehouse_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `packaging_relations` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `parent_code` VARCHAR(128) NOT NULL,
    `child_codes` JSON NOT NULL,
    `packaging_level` VARCHAR(32) NOT NULL,
    `relation_type` VARCHAR(32) NULL DEFAULT 'ONE_TO_MANY',
    `created_by` VARCHAR(64) NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    INDEX `packaging_relations_parent_code_idx`(`parent_code`),
    INDEX `packaging_relations_packaging_level_idx`(`packaging_level`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `market_scans` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `code` VARCHAR(128) NOT NULL,
    `scan_time` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `latitude` DECIMAL(10, 6) NULL,
    `longitude` DECIMAL(10, 6) NULL,
    `scan_location` VARCHAR(255) NULL,
    `scan_address` VARCHAR(255) NULL,
    `scanner_type` VARCHAR(32) NULL,
    `scanner_id` VARCHAR(64) NULL,
    `device_id` VARCHAR(128) NULL,
    `ip_address` VARCHAR(64) NULL,
    `payload` JSON NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    INDEX `market_scans_code_idx`(`code`),
    INDEX `market_scans_scan_time_idx`(`scan_time`),
    INDEX `market_scans_scanner_type_idx`(`scanner_type`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `channel_violations` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `violation_id` VARCHAR(64) NOT NULL,
    `code` VARCHAR(128) NOT NULL,
    `expected_region` VARCHAR(128) NULL,
    `actual_region` VARCHAR(128) NULL,
    `expected_dealer` VARCHAR(128) NULL,
    `actual_dealer` VARCHAR(128) NULL,
    `latitude` DECIMAL(10, 6) NULL,
    `longitude` DECIMAL(10, 6) NULL,
    `scan_time` DATETIME(3) NOT NULL,
    `confidence` DECIMAL(4, 2) NULL,
    `severity` VARCHAR(32) NULL,
    `status` VARCHAR(32) NULL DEFAULT 'PENDING',
    `handling_notes` TEXT NULL,
    `payload` JSON NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    UNIQUE INDEX `channel_violations_violation_id_key`(`violation_id`),
    INDEX `channel_violations_code_idx`(`code`),
    INDEX `channel_violations_status_idx`(`status`),
    INDEX `channel_violations_scan_time_idx`(`scan_time`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `blockchain_proofs` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `business_type` VARCHAR(64) NOT NULL,
    `business_id` VARCHAR(128) NOT NULL,
    `code` VARCHAR(128) NULL,
    `transaction_hash` VARCHAR(128) NULL,
    `block_number` VARCHAR(64) NULL,
    `merkle_root` VARCHAR(128) NULL,
    `proof_data` JSON NULL,
    `stored_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    INDEX `blockchain_proofs_business_type_business_id_idx`(`business_type`, `business_id`),
    INDEX `blockchain_proofs_code_idx`(`code`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
