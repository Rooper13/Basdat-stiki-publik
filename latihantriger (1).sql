-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Sep 22, 2022 at 04:58 PM
-- Server version: 10.4.24-MariaDB
-- PHP Version: 8.1.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `latihantriger`
--

-- --------------------------------------------------------

--
-- Table structure for table `barang`
--

CREATE TABLE `barang` (
  `kd_barang` char(5) NOT NULL,
  `Nama_barang` varchar(15) NOT NULL,
  `Harga_barang` int(11) NOT NULL,
  `Stok` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `barang`
--

INSERT INTO `barang` (`kd_barang`, `Nama_barang`, `Harga_barang`, `Stok`) VALUES
('1', 'Penghapus', 1000, 13),
('2', 'Bolpoin', 2000, 10),
('3', 'Pensil', 1500, 40),
('4', 'Buku', 3000, 30),
('5', 'Rautan', 1200, 28);

-- --------------------------------------------------------

--
-- Table structure for table `ditail_batal`
--

CREATE TABLE `ditail_batal` (
  `kd_batal` char(5) NOT NULL,
  `kd_barang` char(5) NOT NULL,
  `jumlah_barang` int(11) NOT NULL,
  `alasan` varchar(30) NOT NULL,
  `total_harga` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `ditail_batal`
--

INSERT INTO `ditail_batal` (`kd_batal`, `kd_barang`, `jumlah_barang`, `alasan`, `total_harga`) VALUES
('1', '4', 1, 'Rusak', 0),
('6', '3', 2, 'gpp', 0),
('6', '3', 2, 'gpp', 0),
('6', '3', 2, 'gpp', 0),
('2', '1', 2, 'rusak', 0),
('4', '2', 3, 'rusak', 0),
('6', '1', 5, 'rusak', 0);

--
-- Triggers `ditail_batal`
--
DELIMITER $$
CREATE TRIGGER `triggersoal3` AFTER INSERT ON `ditail_batal` FOR EACH ROW UPDATE pembatalan
SET jumlah_barang = jumlah_barang + new.jumlah_barang
WHERE pembatalan.kd_batal = new.kd_batal
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `triggersoal4` AFTER INSERT ON `ditail_batal` FOR EACH ROW UPDATE barang
set stok = stok + new.jumlah_barang
WHERE barang.kd_barang = new.kd_barang
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `triggersoal5` AFTER INSERT ON `ditail_batal` FOR EACH ROW UPDATE detail_jual
set jumlah_barang = jumlah_barang - new.jumlah_barang
WHERE kd_barang = new.Kd_barang
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `triggersoal6` AFTER INSERT ON `ditail_batal` FOR EACH ROW UPDATE pembatalan, barang
SET Total_harga = Total_harga + (barang.Harga_barang = new.jumlah_barang)
WHERE barang.kd_barang = new.kd_barang AND kd_batal = new.kd_batal
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `ditail_jual`
--

CREATE TABLE `ditail_jual` (
  `kd_jual` char(5) NOT NULL,
  `kd_barang` char(5) NOT NULL,
  `jumlah_barang` int(11) NOT NULL,
  `harga_barang` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `ditail_jual`
--

INSERT INTO `ditail_jual` (`kd_jual`, `kd_barang`, `jumlah_barang`, `harga_barang`) VALUES
('2', '1', 1, 0),
('4', '5', 2, 0),
('4', '1', 1, 0),
('5', '5', 2, 0),
('5', '1', 2, 0);

--
-- Triggers `ditail_jual`
--
DELIMITER $$
CREATE TRIGGER `triggersoal1` AFTER INSERT ON `ditail_jual` FOR EACH ROW UPDATE penjualan
set jumlah_barang = jumlah_barang + new.jumlah_barang
WHERE penjualan.kd_jual = new.kd_jual
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `triggersoal2` AFTER INSERT ON `ditail_jual` FOR EACH ROW UPDATE barang
SET Stok = Stok - new.jumlah_barang
WHERE barang.kd_barang = new.kd_barang
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `triggersoal7` AFTER INSERT ON `ditail_jual` FOR EACH ROW UPDATE penjualan, barang
SET Total_harga = Total_harga + (barang.Harga_barang = new.jumlah_barang)
WHERE barang.kd_barang = bew.kd_barang AND kd_jual = new.kd_jual
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `pelanggan`
--

CREATE TABLE `pelanggan` (
  `kd_pelanggan` char(5) NOT NULL,
  `Nama_pelanggan` varchar(15) NOT NULL,
  `Alamat_pel` varchar(15) NOT NULL,
  `Jum_trans_pel` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `pelanggan`
--

INSERT INTO `pelanggan` (`kd_pelanggan`, `Nama_pelanggan`, `Alamat_pel`, `Jum_trans_pel`) VALUES
('1', 'Agus', 'Jalan Soedirman', 2),
('2', 'Rozni', 'Jalan Teratai', 1),
('3', 'Bagas', 'Jalan Semeru', 0),
('4', 'Bima', 'Jalan Gajahmada', 0),
('5', 'Putri', 'Jalan Kawi', 1);

-- --------------------------------------------------------

--
-- Table structure for table `pembatalan`
--

CREATE TABLE `pembatalan` (
  `kd_batal` char(5) NOT NULL,
  `kd_jual` char(5) NOT NULL,
  `kd_pet` char(5) NOT NULL,
  `Jum_bar` int(11) NOT NULL,
  `Total_harga` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `pembatalan`
--

INSERT INTO `pembatalan` (`kd_batal`, `kd_jual`, `kd_pet`, `Jum_bar`, `Total_harga`) VALUES
('1', '3', '1', 1, 0),
('2', '7', '1', 1, 0),
('3', '7', '1', 1, 0),
('4', '8', '1', 0, 0),
('6', '8', '1', 3, 0);

--
-- Triggers `pembatalan`
--
DELIMITER $$
CREATE TRIGGER `triggersoal8` AFTER INSERT ON `pembatalan` FOR EACH ROW UPDATE penjualan
SET jum_bar = jum_bar - new.jum_bar
WHERE kd_jual = new.kd_jual
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `penjualan`
--

CREATE TABLE `penjualan` (
  `kd_jual` char(5) NOT NULL,
  `kd_petugas` char(5) NOT NULL,
  `kd_pelanggan` char(5) NOT NULL,
  `status` varchar(20) NOT NULL,
  `Jum_barang` int(11) NOT NULL,
  `Total_harga` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `penjualan`
--

INSERT INTO `penjualan` (`kd_jual`, `kd_petugas`, `kd_pelanggan`, `status`, `Jum_barang`, `Total_harga`) VALUES
('1', '2', '4', '0', 35, 0),
('10', '1', '1', 'A', 3, 0),
('11', '2', '1', 'A', 10, 0),
('12', '1', '5', 'A', 3, 0),
('2', '1', '5', '0', 1, 0),
('3', '2', '5', '0', 3, 0),
('4', '3', '5', '0', 2, 0),
('5', '4', '1', '0', 2, 0),
('6', '3', '2', '0', 1, 0),
('7', '3', '2', '0', 1, 0),
('8', '1', '1', '0', 3, 0),
('9', '1', '1', 'a', 11, 0);

--
-- Triggers `penjualan`
--
DELIMITER $$
CREATE TRIGGER `triggersoal10` AFTER INSERT ON `penjualan` FOR EACH ROW UPDATE pelanggan
SET jumlah_trans_pelanggan = jumlah_trans_pelanggan + 1
WHERE pelanggan.kd_pelanggan = new.kd_pelanggan
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `triggersoal9` AFTER INSERT ON `penjualan` FOR EACH ROW UPDATE petugas
SET jumlah_trans_petugas = jumlah_trans_pertugas + 1
WHERE petugas.kd_petugas = new.kd_petugas
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `petugas`
--

CREATE TABLE `petugas` (
  `kd_petugas` char(5) NOT NULL,
  `Nama_pet` varchar(15) NOT NULL,
  `Alamat` varchar(15) NOT NULL,
  `Trans_Pet` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `petugas`
--

INSERT INTO `petugas` (`kd_petugas`, `Nama_pet`, `Alamat`, `Trans_Pet`) VALUES
('1', 'Andi', 'Jalan Kawi', 3),
('2', 'Anisa', 'Jalan Kenanga', 1),
('3', 'Dendi', 'Jalan Cantika', 3),
('4', 'Dini', 'Jalan Bimasakti', 0),
('5', 'Cecep', 'Jalan Semeru', 0);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `barang`
--
ALTER TABLE `barang`
  ADD PRIMARY KEY (`kd_barang`);

--
-- Indexes for table `ditail_batal`
--
ALTER TABLE `ditail_batal`
  ADD KEY `kd_barang` (`kd_barang`),
  ADD KEY `kd_batal` (`kd_batal`);

--
-- Indexes for table `ditail_jual`
--
ALTER TABLE `ditail_jual`
  ADD KEY `kd_barang` (`kd_barang`),
  ADD KEY `kd_jual` (`kd_jual`);

--
-- Indexes for table `pelanggan`
--
ALTER TABLE `pelanggan`
  ADD PRIMARY KEY (`kd_pelanggan`);

--
-- Indexes for table `pembatalan`
--
ALTER TABLE `pembatalan`
  ADD PRIMARY KEY (`kd_batal`),
  ADD KEY `kd_jual` (`kd_jual`),
  ADD KEY `kd_pet` (`kd_pet`);

--
-- Indexes for table `penjualan`
--
ALTER TABLE `penjualan`
  ADD PRIMARY KEY (`kd_jual`),
  ADD KEY `kd_pelanggan` (`kd_pelanggan`),
  ADD KEY `kd_petugas` (`kd_petugas`);

--
-- Indexes for table `petugas`
--
ALTER TABLE `petugas`
  ADD PRIMARY KEY (`kd_petugas`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `ditail_batal`
--
ALTER TABLE `ditail_batal`
  ADD CONSTRAINT `ditail_batal_ibfk_1` FOREIGN KEY (`kd_barang`) REFERENCES `barang` (`kd_barang`),
  ADD CONSTRAINT `ditail_batal_ibfk_2` FOREIGN KEY (`kd_batal`) REFERENCES `pembatalan` (`kd_batal`);

--
-- Constraints for table `ditail_jual`
--
ALTER TABLE `ditail_jual`
  ADD CONSTRAINT `ditail_jual_ibfk_1` FOREIGN KEY (`kd_barang`) REFERENCES `barang` (`kd_barang`),
  ADD CONSTRAINT `ditail_jual_ibfk_2` FOREIGN KEY (`kd_jual`) REFERENCES `penjualan` (`kd_jual`);

--
-- Constraints for table `pembatalan`
--
ALTER TABLE `pembatalan`
  ADD CONSTRAINT `pembatalan_ibfk_1` FOREIGN KEY (`kd_jual`) REFERENCES `penjualan` (`kd_jual`),
  ADD CONSTRAINT `pembatalan_ibfk_2` FOREIGN KEY (`kd_pet`) REFERENCES `petugas` (`kd_petugas`);

--
-- Constraints for table `penjualan`
--
ALTER TABLE `penjualan`
  ADD CONSTRAINT `penjualan_ibfk_1` FOREIGN KEY (`kd_pelanggan`) REFERENCES `pelanggan` (`kd_pelanggan`),
  ADD CONSTRAINT `penjualan_ibfk_2` FOREIGN KEY (`kd_petugas`) REFERENCES `petugas` (`kd_petugas`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
