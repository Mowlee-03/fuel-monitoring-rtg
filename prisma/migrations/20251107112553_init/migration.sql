-- CreateTable
CREATE TABLE `Users` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `username` VARCHAR(191) NOT NULL,
    `password` VARCHAR(191) NOT NULL,
    `phone_number` VARCHAR(191) NOT NULL,
    `fullname` VARCHAR(191) NULL,
    `role` ENUM('SUPER_ADMIN', 'USER') NOT NULL DEFAULT 'USER',
    `is_active` BOOLEAN NOT NULL DEFAULT true,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    UNIQUE INDEX `Users_username_key`(`username`),
    UNIQUE INDEX `Users_phone_number_key`(`phone_number`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Organizations` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(191) NOT NULL,
    `org_type` ENUM('GOVERNMENT', 'PRIVATE') NOT NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `UserOrganizations` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `user_id` INTEGER NOT NULL,
    `organization_id` INTEGER NOT NULL,
    `role` ENUM('ADMIN', 'USER') NOT NULL DEFAULT 'USER',
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    INDEX `UserOrganizations_user_id_idx`(`user_id`),
    INDEX `UserOrganizations_organization_id_idx`(`organization_id`),
    UNIQUE INDEX `UserOrganizations_user_id_organization_id_key`(`user_id`, `organization_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `FuelBunks` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(191) NOT NULL,
    `address` VARCHAR(191) NOT NULL,
    `is_active` BOOLEAN NOT NULL DEFAULT true,
    `bunk_type` ENUM('GOVERNMENT', 'PRIVATE') NOT NULL,
    `organization_id` INTEGER NOT NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    INDEX `FuelBunks_organization_id_idx`(`organization_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `FuelPrices` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `fuel_type` ENUM('PETROL', 'DIESEL') NOT NULL,
    `price_per_litre` DECIMAL(10, 2) NOT NULL,
    `date` DATETIME(3) NOT NULL,
    `bunk_id` INTEGER NOT NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    INDEX `FuelPrices_bunk_id_idx`(`bunk_id`),
    INDEX `FuelPrices_date_idx`(`date`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `VehicleCategories` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(191) NOT NULL,
    `unit_of_measure` ENUM('KM', 'HOURS') NOT NULL,
    `target_efficiency` DECIMAL(10, 2) NOT NULL,
    `organization_id` INTEGER NOT NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Vehicles` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `vehicle_number` VARCHAR(191) NOT NULL,
    `last_reading` DECIMAL(65, 30) NULL,
    `last_logged_dt` DATETIME(3) NULL,
    `last_fuel_filled_date` DATETIME(3) NULL,
    `organization_id` INTEGER NOT NULL,
    `category_id` INTEGER NOT NULL,
    `driver_id` INTEGER NULL,
    `enable_gps` BOOLEAN NOT NULL DEFAULT false,
    `is_active` BOOLEAN NOT NULL DEFAULT true,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    UNIQUE INDEX `Vehicles_vehicle_number_key`(`vehicle_number`),
    INDEX `Vehicles_organization_id_idx`(`organization_id`),
    INDEX `Vehicles_category_id_idx`(`category_id`),
    INDEX `Vehicles_driver_id_idx`(`driver_id`),
    UNIQUE INDEX `Vehicles_organization_id_vehicle_number_key`(`organization_id`, `vehicle_number`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `GpsSettings` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `vehicle_id` INTEGER NOT NULL,
    `gps_provider_id` INTEGER NOT NULL,
    `formate` JSON NULL,

    UNIQUE INDEX `GpsSettings_vehicle_id_key`(`vehicle_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `GpsProviders` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(191) NOT NULL,
    `default_formate` JSON NULL,

    UNIQUE INDEX `GpsProviders_name_key`(`name`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Drivers` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(191) NOT NULL,
    `contact_number` VARCHAR(191) NOT NULL,
    `organization_id` INTEGER NOT NULL,
    `is_active` BOOLEAN NOT NULL DEFAULT true,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    INDEX `Drivers_organization_id_idx`(`organization_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `LatestTriplogs` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `entry_date` DATETIME(3) NOT NULL,
    `organization_id` INTEGER NULL,
    `organization_name` VARCHAR(191) NOT NULL,
    `vehicle_id` INTEGER NULL,
    `vehicle_number` VARCHAR(191) NOT NULL,
    `category_id` INTEGER NULL,
    `category_name` VARCHAR(191) NOT NULL,
    `measure_unit` ENUM('KM', 'HOURS') NOT NULL,
    `driver_id` INTEGER NULL,
    `driver_name` VARCHAR(191) NOT NULL,
    `bunk_id` INTEGER NULL,
    `fuel_bunk_name` VARCHAR(191) NOT NULL,
    `start_reading` DECIMAL(10, 2) NOT NULL,
    `end_reading` DECIMAL(10, 2) NOT NULL,
    `reading_difference` DECIMAL(10, 2) NOT NULL,
    `gps_readings` DECIMAL(10, 2) NULL,
    `previous_excess_fuel` DECIMAL(10, 2) NULL,
    `fuel_filled` DECIMAL(10, 2) NOT NULL,
    `fuel_filled_date` DATETIME(3) NOT NULL,
    `fuel_type` ENUM('PETROL', 'DIESEL') NOT NULL,
    `total_fuel_cost` DECIMAL(10, 2) NOT NULL,
    `trip_count` INTEGER NOT NULL,
    `remarks` TEXT NOT NULL,
    `images` JSON NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    INDEX `LatestTriplogs_vehicle_id_idx`(`vehicle_id`),
    INDEX `LatestTriplogs_organization_id_idx`(`organization_id`),
    INDEX `LatestTriplogs_category_id_idx`(`category_id`),
    INDEX `LatestTriplogs_bunk_id_idx`(`bunk_id`),
    INDEX `LatestTriplogs_driver_id_idx`(`driver_id`),
    INDEX `LatestTriplogs_entry_date_idx`(`entry_date`),
    INDEX `LatestTriplogs_fuel_filled_date_idx`(`fuel_filled_date`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `MainTriplogs` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `entry_date` DATETIME(3) NOT NULL,
    `organization_id` INTEGER NULL,
    `organization_name` VARCHAR(191) NOT NULL,
    `vehicle_id` INTEGER NULL,
    `vehicle_number` VARCHAR(191) NOT NULL,
    `category_id` INTEGER NULL,
    `category_name` VARCHAR(191) NOT NULL,
    `measure_unit` ENUM('KM', 'HOURS') NOT NULL,
    `driver_id` INTEGER NULL,
    `driver_name` VARCHAR(191) NOT NULL,
    `bunk_id` INTEGER NULL,
    `fuel_bunk_name` VARCHAR(191) NOT NULL,
    `start_reading` DECIMAL(65, 30) NOT NULL,
    `end_reading` DECIMAL(65, 30) NOT NULL,
    `reading_difference` DECIMAL(65, 30) NOT NULL,
    `gps_readings` DECIMAL(65, 30) NULL,
    `previous_excess_fuel` DECIMAL(65, 30) NULL,
    `fuel_filled` DECIMAL(65, 30) NOT NULL,
    `fuel_filled_date` DATETIME(3) NOT NULL,
    `fuel_type` ENUM('PETROL', 'DIESEL') NOT NULL,
    `total_fuel_cost` DECIMAL(65, 30) NOT NULL,
    `trip_count` INTEGER NOT NULL,
    `remarks` TEXT NOT NULL,
    `images` JSON NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    INDEX `MainTriplogs_vehicle_id_idx`(`vehicle_id`),
    INDEX `MainTriplogs_organization_id_idx`(`organization_id`),
    INDEX `MainTriplogs_category_id_idx`(`category_id`),
    INDEX `MainTriplogs_bunk_id_idx`(`bunk_id`),
    INDEX `MainTriplogs_driver_id_idx`(`driver_id`),
    INDEX `MainTriplogs_entry_date_idx`(`entry_date`),
    INDEX `MainTriplogs_fuel_filled_date_idx`(`fuel_filled_date`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `UserOrganizations` ADD CONSTRAINT `UserOrganizations_user_id_fkey` FOREIGN KEY (`user_id`) REFERENCES `Users`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `UserOrganizations` ADD CONSTRAINT `UserOrganizations_organization_id_fkey` FOREIGN KEY (`organization_id`) REFERENCES `Organizations`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `FuelBunks` ADD CONSTRAINT `FuelBunks_organization_id_fkey` FOREIGN KEY (`organization_id`) REFERENCES `Organizations`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `FuelPrices` ADD CONSTRAINT `FuelPrices_bunk_id_fkey` FOREIGN KEY (`bunk_id`) REFERENCES `FuelBunks`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `VehicleCategories` ADD CONSTRAINT `VehicleCategories_organization_id_fkey` FOREIGN KEY (`organization_id`) REFERENCES `Organizations`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Vehicles` ADD CONSTRAINT `Vehicles_organization_id_fkey` FOREIGN KEY (`organization_id`) REFERENCES `Organizations`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Vehicles` ADD CONSTRAINT `Vehicles_category_id_fkey` FOREIGN KEY (`category_id`) REFERENCES `VehicleCategories`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Vehicles` ADD CONSTRAINT `Vehicles_driver_id_fkey` FOREIGN KEY (`driver_id`) REFERENCES `Drivers`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `GpsSettings` ADD CONSTRAINT `GpsSettings_vehicle_id_fkey` FOREIGN KEY (`vehicle_id`) REFERENCES `Vehicles`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `GpsSettings` ADD CONSTRAINT `GpsSettings_gps_provider_id_fkey` FOREIGN KEY (`gps_provider_id`) REFERENCES `GpsProviders`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Drivers` ADD CONSTRAINT `Drivers_organization_id_fkey` FOREIGN KEY (`organization_id`) REFERENCES `Organizations`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `LatestTriplogs` ADD CONSTRAINT `LatestTriplogs_vehicle_id_fkey` FOREIGN KEY (`vehicle_id`) REFERENCES `Vehicles`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `LatestTriplogs` ADD CONSTRAINT `LatestTriplogs_organization_id_fkey` FOREIGN KEY (`organization_id`) REFERENCES `Organizations`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `LatestTriplogs` ADD CONSTRAINT `LatestTriplogs_category_id_fkey` FOREIGN KEY (`category_id`) REFERENCES `VehicleCategories`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `LatestTriplogs` ADD CONSTRAINT `LatestTriplogs_driver_id_fkey` FOREIGN KEY (`driver_id`) REFERENCES `Drivers`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `LatestTriplogs` ADD CONSTRAINT `LatestTriplogs_bunk_id_fkey` FOREIGN KEY (`bunk_id`) REFERENCES `FuelBunks`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `MainTriplogs` ADD CONSTRAINT `MainTriplogs_vehicle_id_fkey` FOREIGN KEY (`vehicle_id`) REFERENCES `Vehicles`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `MainTriplogs` ADD CONSTRAINT `MainTriplogs_organization_id_fkey` FOREIGN KEY (`organization_id`) REFERENCES `Organizations`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `MainTriplogs` ADD CONSTRAINT `MainTriplogs_category_id_fkey` FOREIGN KEY (`category_id`) REFERENCES `VehicleCategories`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `MainTriplogs` ADD CONSTRAINT `MainTriplogs_driver_id_fkey` FOREIGN KEY (`driver_id`) REFERENCES `Drivers`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `MainTriplogs` ADD CONSTRAINT `MainTriplogs_bunk_id_fkey` FOREIGN KEY (`bunk_id`) REFERENCES `FuelBunks`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;
