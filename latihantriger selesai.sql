-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Sep 25, 2022 at 06:23 PM
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
-- Database: `latihantriger2`
--

-- --------------------------------------------------------

--
-- Table structure for table `barang`
--

CREATE TABLE `barang` (
  `kode_barang` char(5) NOT NULL,
  `nama_barang` varchar(15) NOT NULL,
  `harga_barang` int(11) NOT NULL,
  `stok` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `barang`
--

INSERT INTO `barang` (`kode_barang`, `nama_barang`, `harga_barang`, `stok`) VALUES
('1', 'Penghapus', 1000, 15),
('2', 'Bolpoin', 2000, 6),
('3', 'Pensil', 1500, 40),
('4', 'Buku', 3000, 30),
('5', 'Rautan', 1200, 28);

-- --------------------------------------------------------

--
-- Table structure for table `detail_batal`
--

CREATE TABLE `detail_batal` (
  `kode_batal` char(5) NOT NULL,
  `kode_barang` char(5) NOT NULL,
  `jumlah_barang` int(11) NOT NULL,
  `alasan` varchar(30) NOT NULL,
  `harga_barang` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `detail_batal`
--

INSERT INTO `detail_batal` (`kode_batal`, `kode_barang`, `jumlah_barang`, `alasan`, `harga_barang`) VALUES
('1', '4', 1, 'rusak', 0),
('6', '3', 2, 'gpp', 0),
('6', '3', 2, 'gpp', 0),
('6', '3', 2, 'gpp', 0),
('2', '1', 2, 'rusak', 0),
('4', '2', 3, 'rusak', 0),
('6', '1', 5, 'rusak', 0),
('4', '1', 4, 'rusak', 0),
('6', '2', 4, 'rusak', 0),
('3', '1', 1, 'rusak', 0),
('6', '1', 1, 'rusak', 0);

--
-- Triggers `detail_batal`
--
DELIMITER $$
CREATE TRIGGER `triggersoal3` AFTER INSERT ON `detail_batal` FOR EACH ROW UPDATE pembatalan
SET jumlah_barang = jumlah_barang + new.jumlah_barang
WHERE pembatalan.kode_batal = new.kode_batal
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `triggersoal4` AFTER INSERT ON `detail_batal` FOR EACH ROW UPDATE barang
set stok = stok + new.jumlah_barang
WHERE barang.kode_barang = new.kode_barang
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `triggersoal5` AFTER INSERT ON `detail_batal` FOR EACH ROW UPDATE detail_jual
SET jumlah_barang = jumlah_barang - new.jumlah_barang
WHERE kode_barang = new.kode_barang
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `triggersoal6` AFTER INSERT ON `detail_batal` FOR EACH ROW UPDATE pembatalan,barang
SET total_harga = total_harga + (barang.harga_barang = new.jumlah_barang)
WHERE barang.kode_barang = new.kode_barang and kode_batal = new.kode_batal
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `detail_jual`
--

CREATE TABLE `detail_jual` (
  `kode_jual` char(5) NOT NULL,
  `kode_barang` char(5) NOT NULL,
  `jumlah_barang` int(11) NOT NULL,
  `harga_barang` int(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `detail_jual`
--

INSERT INTO `detail_jual` (`kode_jual`, `kode_barang`, `jumlah_barang`, `harga_barang`) VALUES
('2', '1', -1, 0),
('4', '5', 2, 0),
('4', '1', -1, 0),
('5', '5', 2, 0),
('5', '1', 0, 0),
('9', '1', 3, 1000),
('9', '2', 2, 0),
('9', '2', 2, 0),
('2', '2', 4, 0);

--
-- Triggers `detail_jual`
--
DELIMITER $$
CREATE TRIGGER `triggersoal1` AFTER INSERT ON `detail_jual` FOR EACH ROW UPDATE penjualan
SET jumlah_barang = jumlah_barang + new.jumlah_barang
WHERE penjualan.kode_jual = new.kode_jual
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `triggersoal2` AFTER INSERT ON `detail_jual` FOR EACH ROW UPDATE barang
SET stok = stok - new.jumlah_barang
WHERE barang.kode_barang = new.kode_barang
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `triggersoal7` AFTER INSERT ON `detail_jual` FOR EACH ROW UPDATE penjualan, barang
SET total_harga = total_harga + (barang.harga_barang = new.jumlah_barang)
WHERE barang.kode_barang = new.kode_barang AND kode_jual = new.kode_jual
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `pelanggan`
--

CREATE TABLE `pelanggan` (
  `kode_pelanggan` char(5) NOT NULL,
  `nama_pelanggan` varchar(15) NOT NULL,
  `alamat_pelanggan` varchar(15) NOT NULL,
  `jumlah_trans_pelanggan` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `pelanggan`
--

INSERT INTO `pelanggan` (`kode_pelanggan`, `nama_pelanggan`, `alamat_pelanggan`, `jumlah_trans_pelanggan`) VALUES
('1', 'Agus', 'Jalan Soedirman', 2),
('2', 'Roni', 'Jalan Teratai', 1),
('3', 'Bagas', 'Jalan Semeru', 1),
('4', 'Bima', 'Jalan Gajahmada', 1),
('5', 'Putri', 'Jalan Kawi', 1);

-- --------------------------------------------------------

--
-- Table structure for table `pembatalan`
--

CREATE TABLE `pembatalan` (
  `kode_batal` char(5) NOT NULL,
  `kode_jual` char(5) NOT NULL,
  `kode_petugas` char(5) NOT NULL,
  `jumlah_barang` int(11) NOT NULL,
  `total_harga` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `pembatalan`
--

INSERT INTO `pembatalan` (`kode_batal`, `kode_jual`, `kode_petugas`, `jumlah_barang`, `total_harga`) VALUES
('1', '3', '1', 1, 0),
('2', '7', '1', 1, 0),
('3', '7', '1', 2, 0),
('4', '8', '1', 4, 0),
('5', '1', '1', 4, 0),
('6', '8', '1', 8, 0);

--
-- Triggers `pembatalan`
--
DELIMITER $$
CREATE TRIGGER `triggersoal8` AFTER INSERT ON `pembatalan` FOR EACH ROW UPDATE penjualan
SET jumlah_barang = jumlah_barang - new.jumlah_barang
WHERE kode_jual = new.kode_jual
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `penjualan`
--

CREATE TABLE `penjualan` (
  `kode_jual` char(5) NOT NULL,
  `kode_petugas` char(5) NOT NULL,
  `kode_pelanggan` char(5) NOT NULL,
  `status` varchar(20) NOT NULL,
  `jumlah_barang` int(11) NOT NULL,
  `total_harga` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `penjualan`
--

INSERT INTO `penjualan` (`kode_jual`, `kode_petugas`, `kode_pelanggan`, `status`, `jumlah_barang`, `total_harga`) VALUES
('1', '2', '4', '0', 31, 0),
('10', '1', '1', 'A', 3, 0),
('11', '2', '1', 'A', 10, 0),
('12', '1', '5', 'A', 3, 0),
('13', '5', '2', '0', 4, 0),
('14', '3', '3', '0', 4, 0),
('2', '1', '5', '0', 6, 0),
('3', '2', '5', '0', 3, 0),
('4', '3', '3', '0', 5, 0),
('5', '4', '1', '0', 6, 0),
('6', '3', '2', '0', 1, 0),
('7', '3', '2', '0', 1, 0),
('8', '3', '2', '0', 3, 0),
('9', '1', '1', 'A', 20, 0);

--
-- Triggers `penjualan`
--
DELIMITER $$
CREATE TRIGGER `triggersoal10` AFTER INSERT ON `penjualan` FOR EACH ROW UPDATE pelanggan
SET jumlah_trans_pelanggan = jumlah_trans_pelanggan + 1
WHERE pelanggan.kode_pelanggan = new.kode_pelanggan
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `triggersoal9` AFTER INSERT ON `penjualan` FOR EACH ROW UPDATE petugas
SET jumlah_trans = jumlah_trans + 1
WHERE petugas.kode_petugas = new.kode_petugas
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `petugas`
--

CREATE TABLE `petugas` (
  `kode_petugas` char(5) NOT NULL,
  `nama_petugas` varchar(15) NOT NULL,
  `alamat_petugas` varchar(11) NOT NULL,
  `jumlah_trans` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `petugas`
--

INSERT INTO `petugas` (`kode_petugas`, `nama_petugas`, `alamat_petugas`, `jumlah_trans`) VALUES
('1', 'Andi', 'jalan kawi', 3),
('2', 'Anisa', 'jalan kenan', 1),
('3', 'Dendi', 'jalan canti', 4),
('4', 'Dini', 'jalan bimas', 1),
('5', 'Cecep', 'jalan semer', 1);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `barang`
--
ALTER TABLE `barang`
  ADD PRIMARY KEY (`kode_barang`);

--
-- Indexes for table `detail_batal`
--
ALTER TABLE `detail_batal`
  ADD KEY `kode_batal` (`kode_batal`,`kode_barang`),
  ADD KEY `kode_barang` (`kode_barang`);

--
-- Indexes for table `detail_jual`
--
ALTER TABLE `detail_jual`
  ADD KEY `kode_jual` (`kode_jual`,`kode_barang`),
  ADD KEY `kode_barang` (`kode_barang`);

--
-- Indexes for table `pelanggan`
--
ALTER TABLE `pelanggan`
  ADD PRIMARY KEY (`kode_pelanggan`);

--
-- Indexes for table `pembatalan`
--
ALTER TABLE `pembatalan`
  ADD PRIMARY KEY (`kode_batal`),
  ADD KEY `kode_jual` (`kode_jual`,`kode_petugas`),
  ADD KEY `kode_petugas` (`kode_petugas`);

--
-- Indexes for table `penjualan`
--
ALTER TABLE `penjualan`
  ADD PRIMARY KEY (`kode_jual`),
  ADD KEY `kode_petugas` (`kode_petugas`,`kode_pelanggan`),
  ADD KEY `kode_pelanggan` (`kode_pelanggan`);

--
-- Indexes for table `petugas`
--
ALTER TABLE `petugas`
  ADD PRIMARY KEY (`kode_petugas`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `detail_batal`
--
ALTER TABLE `detail_batal`
  ADD CONSTRAINT `detail_batal_ibfk_1` FOREIGN KEY (`kode_batal`) REFERENCES `pembatalan` (`kode_batal`),
  ADD CONSTRAINT `detail_batal_ibfk_2` FOREIGN KEY (`kode_barang`) REFERENCES `barang` (`kode_barang`);

--
-- Constraints for table `detail_jual`
--
ALTER TABLE `detail_jual`
  ADD CONSTRAINT `detail_jual_ibfk_1` FOREIGN KEY (`kode_barang`) REFERENCES `barang` (`kode_barang`),
  ADD CONSTRAINT `detail_jual_ibfk_2` FOREIGN KEY (`kode_jual`) REFERENCES `penjualan` (`kode_jual`);

--
-- Constraints for table `pembatalan`
--
ALTER TABLE `pembatalan`
  ADD CONSTRAINT `pembatalan_ibfk_1` FOREIGN KEY (`kode_petugas`) REFERENCES `petugas` (`kode_petugas`),
  ADD CONSTRAINT `pembatalan_ibfk_2` FOREIGN KEY (`kode_jual`) REFERENCES `penjualan` (`kode_jual`);

--
-- Constraints for table `penjualan`
--
ALTER TABLE `penjualan`
  ADD CONSTRAINT `penjualan_ibfk_1` FOREIGN KEY (`kode_pelanggan`) REFERENCES `pelanggan` (`kode_pelanggan`),
  ADD CONSTRAINT `penjualan_ibfk_2` FOREIGN KEY (`kode_petugas`) REFERENCES `petugas` (`kode_petugas`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
