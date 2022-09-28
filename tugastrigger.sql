-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Sep 26, 2022 at 05:45 PM
-- Server version: 10.4.24-MariaDB
-- PHP Version: 7.4.29

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `tugastrigger`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_produk` (IN `kode` INT, IN `jml` INT, IN `id_p` INT)   BEGIN

update penjualan 
set total = total + jml 
where id_penjualan = id_p;

update produk 
set jumlah = jumlah - jml 
where kode_produk = kode;

END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `detail_penjualan`
--

CREATE TABLE `detail_penjualan` (
  `id_detail` int(11) NOT NULL,
  `id_penjualan` int(11) NOT NULL,
  `kode_produk` int(11) NOT NULL,
  `jumlah` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `detail_penjualan`
--

INSERT INTO `detail_penjualan` (`id_detail`, `id_penjualan`, `kode_produk`, `jumlah`) VALUES
(3, 1, 1, 3),
(4, 1, 2, 2);

--
-- Triggers `detail_penjualan`
--
DELIMITER $$
CREATE TRIGGER `soal2deleteproduk` AFTER INSERT ON `detail_penjualan` FOR EACH ROW UPDATE produk
SET
jumlah = jumlah - NEW.jumlah
WHERE kode_produk = NEW.kode_produk
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `soal2updatepenjualan` AFTER INSERT ON `detail_penjualan` FOR EACH ROW UPDATE penjualan

SET

total = total + NEW.jumlah

WHERE id_penjualan = NEW.id_penjualan
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `soal5updatepenjualan` AFTER UPDATE ON `detail_penjualan` FOR EACH ROW UPDATE penjualan
SET
total = total - old.jumlah + new.jumlah
WHERE id_penjualan = old.id_penjualan
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `soal5updateproduk` AFTER UPDATE ON `detail_penjualan` FOR EACH ROW UPDATE produk
SET
jumlah = jumlah - new.jumlah + old.jumlah
WHERE kode_produk = old.kode_produk
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `kasir`
--

CREATE TABLE `kasir` (
  `id_kasir` int(11) NOT NULL,
  `nama` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `kasir`
--

INSERT INTO `kasir` (`id_kasir`, `nama`) VALUES
(1, 'Imanda'),
(2, 'Ababil');

-- --------------------------------------------------------

--
-- Table structure for table `log_harga`
--

CREATE TABLE `log_harga` (
  `id_log` int(11) NOT NULL,
  `kode_produk` int(11) NOT NULL,
  `harga_awal` int(11) NOT NULL,
  `harga_akhir` int(11) NOT NULL,
  `tanggal` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `log_harga`
--

INSERT INTO `log_harga` (`id_log`, `kode_produk`, `harga_awal`, `harga_akhir`, `tanggal`) VALUES
(4, 1, 150000, 150000, '2022-09-26'),
(5, 2, 120000, 120000, '2022-09-26');

-- --------------------------------------------------------

--
-- Table structure for table `merk`
--

CREATE TABLE `merk` (
  `id_merk` int(11) NOT NULL,
  `nama` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `merk`
--

INSERT INTO `merk` (`id_merk`, `nama`) VALUES
(1, 'Asus'),
(2, 'Acer'),
(3, 'Lenovo'),
(4, 'HP');

-- --------------------------------------------------------

--
-- Table structure for table `penjualan`
--

CREATE TABLE `penjualan` (
  `id_penjualan` int(11) NOT NULL,
  `id_kasir` int(11) NOT NULL,
  `tanggal` datetime NOT NULL,
  `total` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `penjualan`
--

INSERT INTO `penjualan` (`id_penjualan`, `id_kasir`, `tanggal`, `total`) VALUES
(1, 1, '2022-09-26 16:27:13', 7),
(2, 2, '2022-09-26 16:27:13', 0);

-- --------------------------------------------------------

--
-- Table structure for table `produk`
--

CREATE TABLE `produk` (
  `kode_produk` int(11) NOT NULL,
  `id_merk` int(11) NOT NULL,
  `nama` varchar(100) NOT NULL,
  `harga` int(11) NOT NULL,
  `jumlah` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `produk`
--

INSERT INTO `produk` (`kode_produk`, `id_merk`, `nama`, `harga`, `jumlah`) VALUES
(1, 1, 'Tuf F15', 150000, 5),
(2, 2, 'Aspire Gold 5', 120000, 6);

--
-- Triggers `produk`
--
DELIMITER $$
CREATE TRIGGER `soal1insertlog` AFTER INSERT ON `produk` FOR EACH ROW INSERT INTO log_harga
SET kode_produk = NEW.kode_produk,
harga_awal = NEW.harga,
harga_akhir = NEW.harga,
tanggal = NOW()
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `soal3deletelog` AFTER DELETE ON `produk` FOR EACH ROW DELETE FROM log_harga
WHERE kode_produk = OLD.kode_produk
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `soal3deletepembelian` AFTER DELETE ON `produk` FOR EACH ROW DELETE FROM pembelian
WHERE kode_produk = OLD.kode_produk
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `soal4updatelog` BEFORE UPDATE ON `produk` FOR EACH ROW UPDATE log_harga

SET 

harga_akhir=new.harga,
tanggal = NOW()

WHERE kode_produk = OLD.kode_produk
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `soal8insertjumlahproduk` BEFORE INSERT ON `produk` FOR EACH ROW if (new.jumlah > 200) then 
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'Barang melebihi batas';
End if
$$
DELIMITER ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `detail_penjualan`
--
ALTER TABLE `detail_penjualan`
  ADD PRIMARY KEY (`id_detail`),
  ADD KEY `id_penjualan` (`id_penjualan`),
  ADD KEY `kode_produk` (`kode_produk`);

--
-- Indexes for table `kasir`
--
ALTER TABLE `kasir`
  ADD PRIMARY KEY (`id_kasir`);

--
-- Indexes for table `log_harga`
--
ALTER TABLE `log_harga`
  ADD PRIMARY KEY (`id_log`),
  ADD KEY `kode_produk` (`kode_produk`);

--
-- Indexes for table `merk`
--
ALTER TABLE `merk`
  ADD PRIMARY KEY (`id_merk`);

--
-- Indexes for table `penjualan`
--
ALTER TABLE `penjualan`
  ADD PRIMARY KEY (`id_penjualan`),
  ADD KEY `id_kasir` (`id_kasir`);

--
-- Indexes for table `produk`
--
ALTER TABLE `produk`
  ADD PRIMARY KEY (`kode_produk`),
  ADD KEY `id_merk` (`id_merk`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `detail_penjualan`
--
ALTER TABLE `detail_penjualan`
  MODIFY `id_detail` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `kasir`
--
ALTER TABLE `kasir`
  MODIFY `id_kasir` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `log_harga`
--
ALTER TABLE `log_harga`
  MODIFY `id_log` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `merk`
--
ALTER TABLE `merk`
  MODIFY `id_merk` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `penjualan`
--
ALTER TABLE `penjualan`
  MODIFY `id_penjualan` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `produk`
--
ALTER TABLE `produk`
  MODIFY `kode_produk` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `detail_penjualan`
--
ALTER TABLE `detail_penjualan`
  ADD CONSTRAINT `detail_penjualan_ibfk_1` FOREIGN KEY (`id_penjualan`) REFERENCES `penjualan` (`id_penjualan`),
  ADD CONSTRAINT `detail_penjualan_ibfk_2` FOREIGN KEY (`kode_produk`) REFERENCES `produk` (`kode_produk`);

--
-- Constraints for table `log_harga`
--
ALTER TABLE `log_harga`
  ADD CONSTRAINT `log_harga_ibfk_1` FOREIGN KEY (`kode_produk`) REFERENCES `produk` (`kode_produk`);

--
-- Constraints for table `penjualan`
--
ALTER TABLE `penjualan`
  ADD CONSTRAINT `penjualan_ibfk_1` FOREIGN KEY (`id_kasir`) REFERENCES `kasir` (`id_kasir`);

--
-- Constraints for table `produk`
--
ALTER TABLE `produk`
  ADD CONSTRAINT `produk_ibfk_1` FOREIGN KEY (`id_merk`) REFERENCES `merk` (`id_merk`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
