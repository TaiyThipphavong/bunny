-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 09, 2026 at 07:29 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `bunnies_bunn`
--

-- --------------------------------------------------------

--
-- Table structure for table `admins`
--

CREATE TABLE `admins` (
  `id` int(11) NOT NULL,
  `username` varchar(50) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `admins`
--

INSERT INTO `admins` (`id`, `username`, `password`, `created_at`) VALUES
(1, 'Taiy', '$2y$10$XTtiwsfYL38pOBVVCW8sZu6npDeRcRZbX5vfiTucR3PPANrhEcCOS', '2026-04-03 01:12:34');

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE `categories` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`id`, `name`, `description`, `created_at`) VALUES
(1, 'ເສື້ອຢືດ', '', '2026-04-03 01:12:34'),
(2, 'ເຄື່ອງປະດັບ', NULL, '2026-04-03 01:12:34'),
(3, 'ກະເປົ໋າ', NULL, '2026-04-03 01:12:34'),
(4, 'ໂສ້ງຢີນ', '', '2026-04-03 01:12:34'),
(5, 'ເສື້ອເຊີດ', '', '2026-06-15 09:47:19'),
(6, 'ເກີບຜ້າໃບ', '', '2026-06-15 11:27:36');

-- --------------------------------------------------------

--
-- Table structure for table `members`
--

CREATE TABLE `members` (
  `id` int(11) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `shipping_company` varchar(50) DEFAULT NULL,
  `member_number` varchar(100) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `members`
--

INSERT INTO `members` (`id`, `phone`, `name`, `email`, `password`, `shipping_company`, `member_number`, `created_at`, `updated_at`) VALUES
(1, '2057063047', 'Anna', NULL, '$2y$10$kMO7boPihgYMlIGrA4knhO6dixZQaOu/P78ZuJVbzoyEFMvrQEwae', NULL, NULL, '2026-06-08 07:10:46', '2026-06-15 09:57:41'),
(6, '02095457843', 'Taiy', NULL, '$2y$10$uanY2NSEbsJzYwRGpDnRY.hD2H9VqWtqd2MDFcqiz.mbYv9vXwyi.', NULL, NULL, '2026-07-02 16:42:02', '2026-07-02 16:42:02');

-- --------------------------------------------------------

--
-- Table structure for table `member_otps`
--

CREATE TABLE `member_otps` (
  `phone` varchar(20) NOT NULL,
  `otp` varchar(6) NOT NULL,
  `expires_at` datetime NOT NULL,
  `token` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `member_otps`
--

INSERT INTO `member_otps` (`phone`, `otp`, `expires_at`, `token`) VALUES
('20954578', '525718', '2026-06-21 12:42:22', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `id` int(11) NOT NULL,
  `order_number` varchar(50) DEFAULT NULL,
  `customer_name` varchar(200) NOT NULL,
  `customer_phone` varchar(20) DEFAULT NULL,
  `customer_address` text DEFAULT NULL,
  `total_amount` decimal(10,2) DEFAULT NULL,
  `payment_slip` varchar(255) DEFAULT NULL,
  `status` enum('pending','confirmed','shipped','completed','cancelled') DEFAULT 'pending',
  `note` text DEFAULT NULL,
  `member_id` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `items_total` decimal(15,0) DEFAULT 0,
  `shipping_fee` decimal(15,0) DEFAULT 0,
  `shipping_company` varchar(50) DEFAULT NULL,
  `member_number` varchar(100) DEFAULT NULL,
  `payment_method` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`id`, `order_number`, `customer_name`, `customer_phone`, `customer_address`, `total_amount`, `payment_slip`, `status`, `note`, `member_id`, `created_at`, `items_total`, `shipping_fee`, `shipping_company`, `member_number`, `payment_method`) VALUES
(1, 'BUN-20260403-F4B5D5A', 'Taiy', '95457843', 'ອານຸສິດ ນາລ້ອມ. ໄຊທານີ, ນະຄອນຫຼວງ', 69000.00, 'uploads/prod_69cf20f4ae1d9.jpg', 'confirmed', '', 1, '2026-04-03 02:07:48', 0, 0, NULL, NULL, NULL),
(2, 'BUN-20260403-4E9B08C', 'Taiy', '95457843', 'qergwtrhe', 318000.00, 'uploads/prod_69cf604e9720c.jpg', 'pending', '', 1, '2026-04-03 06:38:06', 0, 0, NULL, NULL, NULL),
(3, 'BUN-20260403-622172F', 'Taiy', '95457843', 'rhetrhwrthwrt', 207000.00, 'uploads/prod_69cf666215d9e.jpg', 'pending', '', 1, '2026-04-03 07:04:02', 0, 0, NULL, NULL, NULL),
(4, 'BUN-20260403-3DC2BFB', 'Taiy', '95457843', 'utdlyudlydl', 69000.00, '', 'cancelled', '', 1, '2026-04-03 07:07:41', 0, 0, NULL, NULL, NULL),
(5, 'BUN-20260503-85E3A31', 'Taiy', '95457843', 'ັັັັັັັັັັັັັັັັັaaaaaaaaaaaaaaaa', 69000.00, 'uploads/prod_69f73385dfb71.jpg', 'pending', 'aaaaaaaaaaaaa', 1, '2026-05-03 11:37:41', 0, 0, NULL, NULL, NULL),
(6, 'BUN-20260503-68698C5', 'Taiy', '95457843', 'ດດດດດດດດດດດດດ', 69000.00, 'uploads/prod_69f73468659b3.jpg', 'pending', 'ດດດດດດດດດດດດ', 1, '2026-05-03 11:41:28', 0, 0, NULL, NULL, NULL),
(7, 'BUN-20260503-BFB437D', 'Taiy', '95457843', 'ຳຳຳຳຳຳຳຳຳຳຳຳຳຳຳຳຳຳຳຳ', 178000.00, 'uploads/prod_69f737bfb047e.jpg', 'pending', 'ຳຳຳຳຳຳຳຳຳຳຳຳຳຳ', 1, '2026-05-03 11:55:43', 0, 0, NULL, NULL, NULL),
(8, 'BUN-20260504-6E8810B', 'Taiy', '95457843', 'OKOKOKOKOKOKOK', 224000.00, 'uploads/prod_69f8b56e840f7.jpg', 'pending', '', 1, '2026-05-04 15:04:14', 224000, 0, 'anousith', '', 'transfer'),
(9, 'BUN-20260505-2639326', 'Taiy', '95457843', 'ກກກກກກກກກກກກກກກກກກກກກກກກ', 268000.00, '', 'confirmed', '', 1, '2026-05-05 09:19:34', 268000, 0, 'houngaloun', '', 'cod'),
(10, 'BUN-20260505-19A20D6', 'Bunny', '95457843', 'dddddddddddddddd', 178000.00, 'uploads/prod_69f9ba19a0689.jpg', 'completed', '', 1, '2026-05-05 09:36:25', 178000, 0, 'anousith', '', 'transfer'),
(11, 'BUN-20260507-DD90778', 'ฌฌ', '34355665', 'ฯณณ', 89000.00, 'uploads/prod_69fc12dd87360.jpg', 'pending', 'ณฯ๋ณณ', NULL, '2026-05-07 04:19:41', 89000, 0, 'anousith', '', 'transfer'),
(12, 'BUN-20260507-FC66A9F', 'JJ', '2055710065', 'ຫົສຊຽງ', 270000.00, 'uploads/prod_69fc16fc626b2.jpg', 'pending', '', 3, '2026-05-07 04:37:16', 270000, 0, 'houngaloun', '', 'transfer'),
(13, 'BUN-20260507-59F248D', 'JJ', '2055710065', 'DDDDDDDDDDD', 288000.00, 'uploads/prod_69fc2e59ecca2.jpg', 'pending', '', 3, '2026-05-07 06:16:57', 288000, 0, 'houngaloun', '', 'transfer'),
(14, 'BUN-20260522-4A426A9', 'JJ', '2055710065', 'KKPK', 89000.00, 'uploads/prod_6a0fbe4a30fa6.jpg', 'pending', 'POJOO', 3, '2026-05-22 02:24:10', 89000, 0, 'anousith', '', 'transfer'),
(15, 'BUN-20260608-33825D4', 'Anna', '2057063047', 'aaaaaaaaaaaaaaaaaaaaaaaaaaaa', 407000.00, '', 'cancelled', '', 4, '2026-06-08 07:11:47', 407000, 0, 'anousith', '', 'cod'),
(16, 'BUN-20260608-72994AB', 'Anna', '2057063047', 'aaaaaaaaaaaaaaaa', 334000.00, '', 'completed', '', 4, '2026-06-08 07:21:22', 334000, 0, 'houngaloun', '', 'cod'),
(17, 'BUN-20260608-B82B08C', 'Anna', '2057063047', 'ບ້ານນາສາລາ ເມືອງໄຊທານີ ແຂວງນະຄອນຫຼວງ', 99000.00, 'uploads/prod_6a2688b826365.jpg', 'pending', '', 4, '2026-06-08 09:17:44', 99000, 0, 'anousith', '', 'transfer'),
(18, 'BUN-20260610-D0B3F67', 'Anna', '2057063047', 'ນາລ້ອມ, ໄຊທານີ,ນະຄອນຫຼວງ', 199000.00, '', 'pending', '', 4, '2026-06-10 11:56:00', 199000, 0, 'anousith', '', 'cod'),
(19, 'BUN-20260610-677EDE3', 'Anna', '2057063047', 'ນາລ້ອມ, ໄຊທານີ', 89000.00, 'uploads/prod_6a29546777928.jpg', 'cancelled', '', 4, '2026-06-10 12:11:19', 89000, 0, 'houngaloun', '', 'transfer'),
(20, 'BUN-20260611-F6DF427', 'Anna', '2057063047', 'trurrrrur7u', 533000.00, '', 'confirmed', '', 4, '2026-06-11 07:00:06', 533000, 0, 'anousith', '', 'cod'),
(21, 'BUN-20260611-BD838E5', 'Anna', '2057063047', 'ttt', 418000.00, 'uploads/prod_6a2a65bd7d5b0.jpg', 'pending', 'tttt', 4, '2026-06-11 07:37:33', 418000, 0, 'anousith', '', 'transfer'),
(22, 'BUN-20260615-8C88387', 'Anna', '2057063047', 'sssssssssssssssss', 188000.00, '', 'completed', '', 4, '2026-06-15 08:57:48', 188000, 0, 'houngaloun', '', 'cod'),
(23, 'BUN-20260615-3881F80', 'Anna', '2057063047', 'aaaaaaaaaaaaaaaaaaa', 238000.00, '', 'pending', '', 4, '2026-06-15 09:43:20', 238000, 0, 'houngaloun', '', 'cod'),
(24, 'BUN-20260615-2BADB20', 'Anna', '2057063047', 'SSSSSSSSSSSSSSSSSSSSS', 218000.00, '', 'shipped', '', 4, '2026-06-15 11:29:47', 218000, 0, 'houngaloun', '', 'cod'),
(25, 'BUN-20260615-5E81987', 'Anna', '2057063047', 'XXXXXXXXXXXXXXXXX', 188000.00, '', 'confirmed', '', 4, '2026-06-15 11:43:26', 188000, 0, 'houngaloun', '', 'cod'),
(26, 'BUN-20260621-38CC66A', 'bunny', '2095457843', 'ນາລ້ອມ, ເມືອງໄຊທານີ, ນະຄອນຫຼວງວຽງຈັນ', 437000.00, '', 'pending', '', 5, '2026-06-21 06:01:28', 437000, 0, 'anousith', '', 'cod'),
(27, 'BUN-20260622-F7540AD', 'bunny', '2095457843', 'aaaaaaaaaaaaaa', 574000.00, '', 'confirmed', '', 5, '2026-06-22 04:58:31', 574000, 0, 'anousith', '', 'cod'),
(28, 'BUN-20260702-D91BE91', 'Taiy', '02095457843', 'nalom', 262000.00, '', 'pending', '', 6, '2026-07-02 16:46:17', 262000, 0, 'anousith', '', 'cod'),
(29, 'BUN-20260703-22774E1', 'Taiy', '02095457843', 'ບ້ານ ນາລ້ອມ, ເມືອງ ໄຊທານີ, ແຂວງນະຄອນຫລວງ', 514000.00, 'uploads/prod_6a47242262a7f.jpg', 'pending', '', 6, '2026-07-03 02:53:22', 514000, 0, 'houngaloun', '', 'transfer'),
(30, 'BUN-20260705-AB73437', 'Taiy', '02095457843', 'ນາຜາສຸກ. ໄຊທານິ.ນະຄອນຫລວງ', 1275000.00, '', 'pending', '', 6, '2026-07-05 10:23:39', 1275000, 0, 'anousith', '', 'cod');

-- --------------------------------------------------------

--
-- Table structure for table `order_items`
--

CREATE TABLE `order_items` (
  `id` int(11) NOT NULL,
  `order_id` int(11) DEFAULT NULL,
  `product_id` int(11) DEFAULT NULL,
  `quantity` int(11) DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL,
  `is_preorder` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `order_items`
--

INSERT INTO `order_items` (`id`, `order_id`, `product_id`, `quantity`, `price`, `is_preorder`) VALUES
(1, 1, 1, 1, 69000.00, 0),
(2, 2, 3, 2, 159000.00, 0),
(3, 3, 2, 3, 69000.00, 0),
(4, 4, 2, 1, 69000.00, 0),
(5, 5, 2, 1, 69000.00, 0),
(6, 6, 2, 1, 69000.00, 0),
(7, 7, 6, 2, 89000.00, 0),
(8, 8, 6, 1, 89000.00, 0),
(9, 8, 5, 1, 135000.00, 0),
(10, 9, 4, 1, 199000.00, 0),
(11, 9, 2, 1, 69000.00, 0),
(12, 10, 6, 2, 89000.00, 0),
(13, 11, 6, 1, 89000.00, 0),
(14, 12, 5, 2, 135000.00, 0),
(15, 13, 4, 1, 199000.00, 0),
(16, 13, 6, 1, 89000.00, 0),
(17, 14, 6, 1, 89000.00, 0),
(18, 15, 2, 1, 69000.00, 0),
(19, 15, 12, 1, 119000.00, 0),
(20, 15, 9, 1, 219000.00, 0),
(21, 16, 11, 1, 199000.00, 0),
(22, 16, 5, 1, 135000.00, 0),
(23, 17, 7, 1, 99000.00, 0),
(24, 18, 11, 1, 199000.00, 0),
(25, 19, 6, 1, 89000.00, 0),
(26, 20, 11, 1, 199000.00, 0),
(27, 20, 4, 1, 199000.00, 0),
(28, 20, 5, 1, 135000.00, 0),
(29, 21, 9, 1, 219000.00, 0),
(30, 21, 11, 1, 199000.00, 0),
(31, 22, 2, 1, 69000.00, 0),
(32, 22, 12, 1, 119000.00, 0),
(33, 23, 12, 2, 119000.00, 0),
(34, 24, 12, 1, 119000.00, 0),
(35, 24, 7, 1, 99000.00, 0),
(36, 25, 12, 1, 119000.00, 1),
(37, 25, 2, 1, 69000.00, 0),
(38, 26, 11, 1, 199000.00, 1),
(39, 26, 14, 1, 139000.00, 0),
(40, 26, 7, 1, 99000.00, 0),
(41, 27, 15, 1, 125000.00, 0),
(42, 27, 12, 1, 119000.00, 1),
(43, 27, 19, 2, 165000.00, 0),
(44, 28, 23, 1, 125000.00, 0),
(45, 28, 16, 1, 137000.00, 0),
(46, 29, 24, 1, 295000.00, 0),
(47, 29, 9, 1, 219000.00, 0),
(48, 30, 22, 1, 1275000.00, 1);

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `id` int(11) NOT NULL,
  `category_id` int(11) DEFAULT NULL,
  `name` varchar(200) NOT NULL,
  `description` text DEFAULT NULL,
  `price` decimal(10,2) NOT NULL,
  `stock` int(11) DEFAULT 0,
  `image` varchar(255) DEFAULT NULL,
  `sku` varchar(100) DEFAULT NULL,
  `weight` decimal(5,2) DEFAULT NULL,
  `dimensions` varchar(50) DEFAULT NULL,
  `status` enum('active','inactive') DEFAULT 'active',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `colors` text DEFAULT NULL,
  `cost_price` decimal(12,2) DEFAULT 0.00,
  `pre_order` tinyint(1) DEFAULT 0,
  `sizes` text DEFAULT NULL,
  `sort_order` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`id`, `category_id`, `name`, `description`, `price`, `stock`, `image`, `sku`, `weight`, `dimensions`, `status`, `created_at`, `colors`, `cost_price`, `pre_order`, `sizes`, `sort_order`) VALUES
(1, 1, 'ເສື້ອປາດບ່າ', '', 69000.00, 5, 'uploads/prod_69cf201550f0d.jpeg', 'A01', 0.00, 's m l xl xxl', 'active', '2026-04-03 02:04:07', '[]', 34000.00, 0, '[{\"name\":\"S\",\"stock\":2},{\"name\":\"M\",\"stock\":1},{\"name\":\"L\",\"stock\":1},{\"name\":\"XL\",\"stock\":1},{\"name\":\"XXL\",\"stock\":0}]', NULL),
(2, 1, 'ເສື້ອປາດບ່າ', 'ຖ່າຍຈາກສິນຄ້າຈິງ', 69000.00, 3, 'uploads/prod_69cf23a3dd3a5.jpeg', 'A02', 0.00, 's m l xl xxl', 'active', '2026-04-03 02:19:17', '[]', 36000.00, 0, '[{\"name\":\"S\",\"stock\":null},{\"name\":\"M\",\"stock\":null},{\"name\":\"L\",\"stock\":null},{\"name\":\"XL\",\"stock\":null},{\"name\":\"XXL\",\"stock\":null}]', NULL),
(3, 1, 'ໂສ້ງຂາເຄິ່ງ Jort', '### **ໂສ້ງຂາເຄິ່ງ Jort (Denim Jorts)**\n\n**ລາຍລະອຽດສິນຄ້າ:**\nເພີ່ມຄວາມສະຕຣີທແຟຊັນ (Streetwear) ໃຫ້ກັບການແຕ່ງຕົວດ້ວຍ ໂສ້ງຢີນຂາເຄິ່ງຊົງຫຼົມ ຫຼື ໂສ້ງ Jorts ທີ່ກຳລັງເປັນກະແສນິຍົມໃນຕອນນີ້. ຕົວໂສ້ງເປັນຜ້າຢີນຟອກສີຟ້າອ່ອນ (Light Wash Denim) ໃຫ້ຟີລແບບວິນເທຈ (Vintage) ແລະ ຄາດສິກ. ຊົງຂາກວ້າງ ໃສ່ສະບາຍ ບໍ່ອຶດອັດ ແລະ ສາມາດເຄື່ອນໄຫວໄດ້ຢ່າງຄ່ອງຕົວ.\n\nສາມາດນຳມາແມັດຊ໌ (Match) ກັບເສື້ອຢືດ Oversize, ເສື້ອຄຣັອບ ຫຼື ເສື້ອເຊີດແຂນສັ້ນ ກໍໃຫ້ລຸກທີ່ເບິ່ງເທ້, ຊິວ ແລະ ມີສະໄຕລ໌ທີ່ໂດດເດັ່ນໃນມື້ພັກຜ່ອນ.\n\n**ຄຸນສົມບັດເດັ່ນ:**\n\n* **ດີຊາຍ:** ໂສ້ງຢີນຂາເຄິ່ງ (Jorts) ຊົງຂາກວ້າງ ແບບ unisex ໃສ່ໄດ້ທັງຍິງ ແລະ ຊາຍ\n* **ສີສັນ:** ສີຟ້າຢີນຟອກ (Light Blue Denim) ເຮັດໃຫ້ແມັດຊ໌ກັບເສື້ອໄດ້ງ່າຍ\n* **ຮູບຊົງ:** ຮູບຊົງຫຼົມ (Loose Fit) ເພີ່ມຄວາມສະບາຍໃນການສວມໃສ່\n* **ໂອກາດໃນການນຸ່ງ:** ເໝາະສຳລັບໃສ່ໄປທ່ຽວ, ໄປຄາເຟ່ ຫຼື ກິດຈະກຳ outdoor ໃນວັນສະບາຍໆ\n\n---\n\n### **ຂໍ້ມູນເພີ່ມເຕີມ**\n\n* **ລາຄາ:** ₭ 159,000 ກີບ\n* **ໄຊ້ (Size):** S, M, L, XL, XXL (ໃນຮູບແມ່ນກຳລັງເລືອກໄຊ້ XL ເຊິ່ງສະຖານະເປັນ Sold Out ແຕ່ສາມາດ Pre-Order ໄດ້)\n* **ສະຖານະການຈັດສົ່ງ:** ສິນຄ້າປະເພດ Sold Out ສາມາດສັ່ງ Pre-Order ໄດ້ ໂດຍຈະໄດ້ຮັບສິນຄ້າພາຍໃນ 7-14 ວັນ', 159000.00, 3, 'uploads/prod_69cf23e4a06bc.jpeg', 'A03', 0.00, 's m l xl xxl', 'active', '2026-04-03 02:20:22', '[]', 94000.00, 0, '[{\"name\":\"S\",\"stock\":1},{\"name\":\"M\",\"stock\":1},{\"name\":\"L\",\"stock\":0},{\"name\":\"XL\",\"stock\":0},{\"name\":\"XXL\",\"stock\":1}]', NULL),
(4, 1, 'cool jacket', 'ສໍາລັບເສື້ອແຈັກເກັດ Varsity Jacket ຊົງວິນເທດ (Vintage) ແບບໃນຮູບ, ນີ້ຄືຕົວຢ່າງຄຳອະທິບາຍສິນຄ້າທີ່ເນັ້ນຄວາມເທ້ ແລະ ຄວາມພຣີມ່ຽມ ເພື່ອດຶງດູດລູກຄ້າ:\n🖤 Vintage Varsity Jacket - The Timeless Classic 🖤\nຍົກລະດັບຄວາມເທ້ແບບມີສະໄຕລ໌ໄປກັບເສື້ອແຈັກເກັດຊົງ Varsity ທີ່ປະສົມປະສານຄວາມຄລາສສິກ ແລະ ຄວາມທັນສະໄໝເຂົ້າກັນໄດ້ຢ່າງລົງຕົວ!\n✨ ຈຸດເດັ່ນທີ່ຫ້າມພາດ:\n * Design: ດີໄຊນ໌ຊົງ Oversize ເລັກນ້ອຍ ໃຫ້ລຸກຄ໌ແບບ Street Vintage ທີ່ກຳລັງມາແຮງ.\n * Quality Material: ຕົວເສື້ອເປັນຜ້າຄຸນນະພາບສູງ ຕັດຫຍິບສະຫຼັບກັບແຂນໜັງ (Leather Sleeves) ທີ່ໃຫ້ຄວາມຮູ້ສຶກພຣີມ່ຽມ ແລະ ທົນທານ.\n * Detail: ໂດດເດັ່ນດ້ວຍການປັກໂຕໜັງສື \"Vintage\" ແບບ 3D ທີ່ໜ້າເອິກ, ເພີ່ມມິຕິໃຫ້ກັບການແຕ່ງຕົວ.\n * Comfort: ປາຍແຂນ ແລະ ຄໍເສື້ອເປັນຜ້າຢືດແບບມີລາຍ (Ribbed trim) ຊ່ວຍກັນລົມ ແລະ ໃສ່ສະບາຍຕະຫຼອດມື້.\n * Color: ໂທນສີດຳ-ເທົາ ເຂັ້ມໆ ເທ້ໆ ແມັດຊ໌ (Match) ກັບຊຸດໃດກໍງ່າຍ ບໍ່ວ່າຈະໃສ່ກັບຢີນສ໌ ຫຼື ໂສ້ງຂາສັ້ນ.\n> \"ບໍ່ວ່າຈະໃສ່ໄປຮຽນ, ໄປທ່ຽວ ຫຼື ໃສ່ຂີ່ລົດຫຼິ້ນ ກໍຮັບຮອງວ່າໂດດເດັ່ນກວ່າໃຜ!\"', 199000.00, 2, 'uploads/prod_69d0750b35f65.jpeg', 'A01', 0.80, 's m l xl xxl', 'active', '2026-04-04 02:18:52', '[]', 163000.00, 0, NULL, NULL),
(5, 1, 'ເສື້ອກັກ', '', 135000.00, 1, 'uploads/prod_69d075a6e1e79.jpeg', 'A05', 0.60, 's m l xl xxl', 'active', '2026-04-04 02:21:28', '[]', 87000.00, 0, NULL, NULL),
(6, 3, 'ກະເປົາ', '', 89000.00, 1, 'uploads/prod_69d0910730083.jpeg', 'A06', 0.50, '', 'active', '2026-04-04 04:18:17', '[]', 52000.00, 0, '[]', NULL),
(7, 6, 'ເກີບຜ້າໃບ', 'ສວຍ ໃສ່ແລ້ວໃຫ້ຄວາມຮູ້ສຶກເປັນລູກຄຸນ', 99000.00, 0, 'uploads/prod_6a1ce81b334fc.jpg', 'A09', 0.00, '36 37 38 39 40', 'active', '2026-05-31 03:18:45', '[]', 68000.00, 0, '[{\"name\":\"36\",\"stock\":1},{\"name\":\"37\",\"stock\":0},{\"name\":\"38\",\"stock\":0},{\"name\":\"39\",\"stock\":0},{\"name\":\"40\",\"stock\":1}]', NULL),
(9, 1, 'Jean', '', 219000.00, 0, 'uploads/prod_6a1cf49dbfb5d.jpeg', 'A010', 0.00, 's m l xl ', 'active', '2026-06-01 02:55:43', '[]', 173000.00, 0, '[{\"name\":\"S\",\"stock\":null},{\"name\":\"M\",\"stock\":null},{\"name\":\"L\",\"stock\":null},{\"name\":\"XL\",\"stock\":null}]', NULL),
(11, 1, 'Jean', '', 199000.00, 0, 'uploads/prod_6a25735354aa3.jpeg', 'A012', 0.00, 's m l xl xxl', 'active', '2026-06-07 13:34:31', '[]', 160000.00, 0, '[{\"name\":\"S\",\"stock\":0},{\"name\":\"M\",\"stock\":0},{\"name\":\"L\",\"stock\":1},{\"name\":\"XL\",\"stock\":0},{\"name\":\"XXL\",\"stock\":0}]', NULL),
(12, 1, 'mini dress', '', 119000.00, 0, 'uploads/prod_6a2573efc0513.jpeg', 'A013', 0.00, 's m l xl xxl', 'active', '2026-06-07 13:36:56', '[]', 88000.00, 0, '[{\"name\":\"S\",\"stock\":0},{\"name\":\"M\",\"stock\":0},{\"name\":\"L\",\"stock\":0},{\"name\":\"XL\",\"stock\":0},{\"name\":\"XXL\",\"stock\":0}]', NULL),
(14, 4, 'white jaen', '', 139000.00, 1, 'uploads/prod_6a2fcd664ef79.jpeg', 'A015', 0.00, 'xs s m l xl xxl', 'active', '2026-06-15 10:01:26', '[]', 102000.00, 0, '[{\"name\":\"S\",\"stock\":0},{\"name\":\"XL\",\"stock\":0},{\"name\":\"M\",\"stock\":2},{\"name\":\"L\",\"stock\":1}]', NULL),
(15, 5, 'ເສື້ອ', '### **ເສື້ອເຊີດແຂນສັ້ນ ລາຍທາງ (Pinstripe Slim Shirt)**\n\n**ລາຍລະອຽດສິນຄ້າ:**\nເພີ່ມຄວາມໝັ້ນໃຈໃຫ້ກັບລຸກປະຈຳວັນດ້ວຍ ເສື້ອເຊີດແຂນສັ້ນຄໍປົກ ດີຊາຍທັນສະໄໝ ໂດດເດັ່ນດ້ວຍການແຕ່ງຈີບຍຸ້ມ (Ruched) ຢູ່ບໍລິເວນດ້ານໜ້າ ເພື່ອຊ່ວຍເນັ້ນຊົງ ແລະ ເຮັດໃຫ້ຮູບຮ່າງເບິ່ງເຂົ້າຮູບ (Slim fit) ໄດ້ຢ່າງສວຍງາມ. ຕົວເສື້ອມາພ້ອມກັບລາຍເສັ້ນຊື່ແນວຕັ້ງ (Pinstripe) ສີຂາວ ເທິງພື້ນຜ້າສີຟ້າເຂັ້ມ (Navy Blue) ເຊິ່ງຊ່ວຍພາງຫຸ່ນໃຫ້ເບິ່ງເພີວ ແລະ ສູງຂຶ້ນ.\n\nເນື້ອຜ້າໃສ່ສະບາຍ, ບໍ່ຮ້ອນ, ສາມາດນຳມາແມັດຊ໌ (Match) ເຂົ້າກັບກະໂປງສັ້ນສີດຳຄືໃນແບບ ຫຼື ກາງເກງຂາຍາວ ກໍໃຫ້ລຸກທີ່ເບິ່ງດີ, ສຸພາບ ແລະ ມີສະເໜ່ ບໍ່ວ່າຈະໃສ່ໄປເຮັດວຽກ ຫຼື ໃສ່ທ່ຽວ.\n\n**ຄຸນສົມບັດເດັ່ນ:**\n\n* **ດີຊາຍ:** ຄໍປົກເຊີດ, ແຂນສັ້ນ, ແຕ່ງຈີບຍຸ້ມດ້ານໜ້າເພີ່ມລູກຫຼິ້ນໃຫ້ກັບເສື້ອ\n* **ລວດລາຍ:** ລາຍທາງແນວຕັ້ງສີຂາວ ເທິງພື້ນສີຟ້າເຂັ້ມ\n* **ຮູບຊົງ:** ເຂົ້າຮູບ (Slim Fit) ຊ່ວຍໃຫ້ຮູບຮ່າງເບິ່ງສົມສ່ວນ\n* **ໂອກາດໃນການນຸ່ງ:** ເໝາະສຳລັບໃສ່ໄປເຮັດວຽກ, ໄປຮຽນ ຫຼື ໃສ່ທ່ຽວໃນມື້ສະບາຍໆ\n\n---\n\n### **ຂໍ້ມູນເພີ່ມເຕີມ:**\n\n* **ລາຄາ:** ₭ 125,000 ກີບ\n* **ໄຊ້ (Size):** S, M, L, XL\n* **ຄຳແນະນຳ:** ແນະນຳໃຫ້ຊັກມື ຫຼື ໃສ່ຖົງຊັກຜ້າກ່ອນເອົາລົງເຄື່ອງຊັກ ເພື່ອຮັກສາຊົງຈີບຍຸ້ມດ້ານໜ້າໃຫ້ງາມດົນໆ', 125000.00, 0, 'uploads/prod_6a3781e387716.jpeg', '', 0.00, '', 'active', '2026-06-21 06:17:10', '[]', 89000.00, 0, '[{\"name\":\"S\",\"stock\":1},{\"name\":\"M\",\"stock\":0},{\"name\":\"L\",\"stock\":0},{\"name\":\"XL\",\"stock\":0}]', NULL),
(16, 2, 'ໝວກ', '', 137000.00, 1, 'uploads/prod_6a37c4f042b6e.jpeg', '', 0.00, '', 'active', '2026-06-21 11:03:31', '[\"\\u0e94\\u0eb3\",\"\\u0e99\\u0ec9\\u0eb3\\u0e95\\u0eb2\\u0e99\"]', 90000.00, 0, '[]', NULL),
(17, 4, 'ໂສ້ງຢີນຂາສັ້ນ', '', 135000.00, 3, 'uploads/prod_6a37c7418e239.jpeg', '', 0.00, '', 'active', '2026-06-21 11:13:08', '[]', 102000.00, 0, '[{\"name\":\"S\",\"stock\":1},{\"name\":\"M\",\"stock\":1},{\"name\":\"L\",\"stock\":0},{\"name\":\"XL\",\"stock\":1},{\"name\":\"XXL\",\"stock\":0}]', NULL),
(19, 5, 'ເສຶ້ອ', '', 165000.00, 0, 'uploads/prod_6a37c95f0b932.jpeg', '', 0.00, '', 'active', '2026-06-21 11:23:41', '[\"\\u0e82\\u0eb2\\u0ea7\",\"\\u0e94\\u0eb3\",\"\\u0e99\\u0ec9\\u0eb3\\u0e95\\u0eb2\\u0e99\"]', 107000.00, 0, '[{\"name\":\"S\",\"stock\":2},{\"name\":\"M\",\"stock\":0},{\"name\":\"L\",\"stock\":0},{\"name\":\"XL\",\"stock\":0}]', NULL),
(21, 1, 'ເສື້ອ', '', 385000.00, 0, 'uploads/prod_6a43cbb26b498.jpeg', '', 0.00, '', 'active', '2026-06-30 13:59:33', '[\"\\u0e94\\u0eb3\",\"\\u0e9a\\u0ebb\\u0ea7\",\"\\u0ec0\\u0e97\\u0ebb\\u0eb2\",\"\\u0ec1\\u0e94\\u0e87\\u0e8a\\u0ec9\\u0eb3\"]', 297000.00, 0, '[{\"name\":\"S\",\"stock\":0},{\"name\":\"M\",\"stock\":0},{\"name\":\"L\",\"stock\":0},{\"name\":\"XL\",\"stock\":0},{\"name\":\"XXL\",\"stock\":0}]', NULL),
(22, 6, 'BAOJI', 'BAOJI (ບາໂອຈິ) is the name of MARY JANE. BAOJIxPEANUTS HEART STEP with Snoopy (ສະນູປີ)', 1275000.00, 0, 'uploads/prod_6a4487b91fcc8.jpeg', '', 0.00, '', 'active', '2026-07-01 03:21:40', '[\"\\u0e84\\u0eb5\\u0ea1\",\"\\u0e84\\u0eb5\\u0ea1+\\u0e99\\u0ec9\\u0eb3\\u0e95\\u0eb2\\u0e99\",\"\\u0e95\\u0ec9\\u0eb3\\u0e95\\u0eb2\\u0e99+\\u0e9f\\u0ec9\\u0eb2\"]', 1178000.00, 0, '[{\"name\":\"37\",\"stock\":0},{\"name\":\"38\",\"stock\":0},{\"name\":\"39\",\"stock\":0},{\"name\":\"40\",\"stock\":0},{\"name\":\"41\",\"stock\":0}]', NULL),
(23, 1, 'Baby Tee', 'ເສື້ອ Baby Tee ລາຍຕຸກກະຕາວິນເທດ Y2K, ເສື້ອຢືດຜູ້ຍິງຊົງເຂົ້າຮູບ, ຜ້າຢືດນຸ່ມ, ສະໄຕລ໌ເກົາຫຼີໜ້າຮັກໆ**', 125000.00, 1, 'uploads/prod_6a448a22d8a33.jpeg', '', 0.00, '', 'active', '2026-07-01 03:31:55', '[\"\\u0e82\\u0eb2\\u0ea7\",\"\\u0e84\\u0eb5\\u0ea1\",\"\\u0e94\\u0eb3\",\"\\u0ec1\\u0e94\\u0e87\",\"\\u0ec0\\u0e97\\u0ebb\\u0eb2\",\"\\u0e9a\\u0ebb\\u0ea7\"]', 89000.00, 0, '[{\"name\":\"S\",\"stock\":2},{\"name\":\"M\",\"stock\":0},{\"name\":\"L\",\"stock\":0},{\"name\":\"XL\",\"stock\":0}]', NULL),
(24, 1, 'LONGSLEEVE BOXY', 'LONGSLEEVE BOXY | FADED | ສີດຳ | YIKESALLDAY', 295000.00, 3, 'uploads/prod_6a47205f5eea6.jpeg', '', 0.00, '', 'active', '2026-07-03 02:37:10', '[]', 182000.00, 0, '[{\"name\":\"S\",\"stock\":1},{\"name\":\"M\",\"stock\":1},{\"name\":\"L\",\"stock\":1}]', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `product_images`
--

CREATE TABLE `product_images` (
  `id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `image_path` varchar(500) NOT NULL,
  `sort_order` int(11) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `product_images`
--

INSERT INTO `product_images` (`id`, `product_id`, `image_path`, `sort_order`, `created_at`) VALUES
(78, 7, 'uploads/prod_6a1ce821ef7b1.jpg', 0, '2026-06-15 11:28:37'),
(79, 7, 'uploads/prod_6a1ce82569752.jpg', 1, '2026-06-15 11:28:37'),
(80, 9, 'uploads/prod_6a1cf4a386672.jpeg', 0, '2026-06-15 12:10:10'),
(81, 9, 'uploads/prod_6a1cf4a958357.jpeg', 1, '2026-06-15 12:10:10'),
(82, 9, 'uploads/prod_6a1cf4ad5619b.jpeg', 2, '2026-06-15 12:10:10'),
(86, 14, 'uploads/prod_6a2fcd6bba0df.jpeg', 0, '2026-06-16 11:16:41'),
(87, 14, 'uploads/prod_6a2fcd6fe577a.jpeg', 1, '2026-06-16 11:16:42'),
(88, 14, 'uploads/prod_6a2fcd7492386.jpeg', 2, '2026-06-16 11:16:42'),
(89, 12, 'uploads/prod_6a2573d29aa40.jpeg', 0, '2026-06-16 11:17:13'),
(90, 12, 'uploads/prod_6a2573dc7605e.jpeg', 1, '2026-06-16 11:17:13'),
(91, 12, 'uploads/prod_6a2573e286ba4.jpeg', 2, '2026-06-16 11:17:13'),
(92, 12, 'uploads/prod_6a2573e9655f1.jpeg', 3, '2026-06-16 11:17:13'),
(107, 15, 'uploads/prod_6a3781e3871fb.jpeg', 0, '2026-06-21 06:27:43'),
(108, 15, 'uploads/prod_6a3781e387586.jpeg', 1, '2026-06-21 06:27:43'),
(109, 15, 'uploads/prod_6a3781e3875be.jpeg', 2, '2026-06-21 06:27:43'),
(110, 15, 'uploads/prod_6a3781e38a01f.jpeg', 3, '2026-06-21 06:27:43'),
(114, 3, 'uploads/prod_6a1cecb83c367.jpeg', 0, '2026-06-21 06:33:56'),
(115, 3, 'uploads/prod_6a1cecbbef95e.jpeg', 1, '2026-06-21 06:33:56'),
(116, 3, 'uploads/prod_6a1cecc75bef7.jpeg', 2, '2026-06-21 06:33:56'),
(123, 17, 'uploads/prod_6a37c7418f0a7.jpeg', 0, '2026-06-21 11:13:08'),
(124, 17, 'uploads/prod_6a37c741931d6.jpeg', 1, '2026-06-21 11:13:08'),
(125, 17, 'uploads/prod_6a37c74193649.jpeg', 2, '2026-06-21 11:13:08'),
(126, 17, 'uploads/prod_6a37c741955e0.jpeg', 3, '2026-06-21 11:13:08'),
(133, 16, 'uploads/prod_6a37c4eb56016.jpeg', 0, '2026-06-21 11:13:44'),
(134, 16, 'uploads/prod_6a37c4e396bad.jpeg', 1, '2026-06-21 11:13:44'),
(135, 16, 'uploads/prod_6a37c4fa65767.jpeg', 2, '2026-06-21 11:13:44'),
(136, 16, 'uploads/prod_6a37c4fa62da4.jpeg', 3, '2026-06-21 11:13:44'),
(137, 16, 'uploads/prod_6a37c4fa5adfe.jpeg', 4, '2026-06-21 11:13:44'),
(138, 16, 'uploads/prod_6a37c4fa5f34f.jpeg', 5, '2026-06-21 11:13:44'),
(142, 19, 'uploads/prod_6a37c9667c340.jpeg', 0, '2026-06-21 11:23:41'),
(143, 19, 'uploads/prod_6a37c96cd877b.jpeg', 1, '2026-06-21 11:23:41'),
(147, 21, 'uploads/prod_6a43cbb7c7786.jpeg', 0, '2026-06-30 13:59:33'),
(148, 21, 'uploads/prod_6a43cbbd119f5.jpeg', 1, '2026-06-30 13:59:33'),
(149, 21, 'uploads/prod_6a43cbc1eb253.jpeg', 2, '2026-06-30 13:59:33'),
(150, 22, 'uploads/prod_6a4487bde423e.jpeg', 0, '2026-07-01 03:21:40'),
(151, 22, 'uploads/prod_6a4487c27d252.jpeg', 1, '2026-07-01 03:21:40'),
(160, 23, 'uploads/prod_6a448a0e6d898.jpeg', 0, '2026-07-01 03:45:56'),
(161, 23, 'uploads/prod_6a448a22d64b9.jpeg', 1, '2026-07-01 03:45:56'),
(162, 23, 'uploads/prod_6a448a22d7488.jpeg', 2, '2026-07-01 03:45:56'),
(163, 23, 'uploads/prod_6a448a22d8cc9.jpeg', 3, '2026-07-01 03:45:56'),
(170, 24, 'uploads/prod_6a4720630621d.jpeg', 0, '2026-07-05 10:19:23'),
(171, 24, 'uploads/prod_6a4720666c50e.jpeg', 1, '2026-07-05 10:19:23'),
(172, 24, 'uploads/prod_6a47206969c94.jpeg', 2, '2026-07-05 10:19:23');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admins`
--
ALTER TABLE `admins`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- Indexes for table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `members`
--
ALTER TABLE `members`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `phone` (`phone`);

--
-- Indexes for table `member_otps`
--
ALTER TABLE `member_otps`
  ADD PRIMARY KEY (`phone`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `order_number` (`order_number`);

--
-- Indexes for table `order_items`
--
ALTER TABLE `order_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_id` (`order_id`),
  ADD KEY `product_id` (`product_id`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`id`),
  ADD KEY `category_id` (`category_id`);

--
-- Indexes for table `product_images`
--
ALTER TABLE `product_images`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_product_id` (`product_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admins`
--
ALTER TABLE `admins`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `categories`
--
ALTER TABLE `categories`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `members`
--
ALTER TABLE `members`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- AUTO_INCREMENT for table `order_items`
--
ALTER TABLE `order_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=49;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT for table `product_images`
--
ALTER TABLE `product_images`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=173;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `order_items`
--
ALTER TABLE `order_items`
  ADD CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`),
  ADD CONSTRAINT `order_items_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`);

--
-- Constraints for table `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `products_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
