-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 15, 2024 at 02:53 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `perpustakaan_amikom`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `DaftarPeminjaman` ()   BEGIN
    SELECT * FROM Peminjaman;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DaftarPengguna` ()   BEGIN
    SELECT * FROM Pengguna;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `TambahBuku` (IN `judulBuku` VARCHAR(100), IN `penulisBuku` VARCHAR(100))   BEGIN
    DECLARE jumlahBuku INT;
    SELECT COUNT(*) INTO jumlahBuku FROM Buku WHERE judul = judulBuku AND penulis = penulisBuku;
    IF jumlahBuku = 0 THEN
        INSERT INTO Buku (judul, penulis) VALUES (judulBuku, penulisBuku);
    END IF;
END$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `HitungBuku` () RETURNS INT(11)  BEGIN
    DECLARE total INT;
    SELECT COUNT(*) INTO total FROM Buku;
    RETURN total;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `HitungPeminjamanPengguna` (`idPengguna` INT, `tanggalMulai` DATE) RETURNS INT(11)  BEGIN
    DECLARE jumlahPeminjaman INT;
    SELECT COUNT(*) INTO jumlahPeminjaman FROM Peminjaman WHERE id_pengguna = idPengguna AND tanggal_pinjam >= tanggalMulai;
    RETURN jumlahPeminjaman;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `buku`
--

CREATE TABLE `buku` (
  `id_buku` int(11) NOT NULL,
  `judul` varchar(100) DEFAULT NULL,
  `penulis` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `buku`
--

INSERT INTO `buku` (`id_buku`, `judul`, `penulis`) VALUES
(1, 'Aljabar', 'Wisnu Rendang'),
(2, 'Multimedia', 'Arif Bakwan'),
(3, 'Jaringan Komputer', 'Kevin Mie Gacoan'),
(4, 'Sistem Operasi', 'Adib Hensem'),
(5, 'Kecerdasan Buatan', 'Le Aqua'),
(6, 'Pemrograman Web', 'Kevin Mie Gacoan');

-- --------------------------------------------------------

--
-- Table structure for table `bukuindeks`
--

CREATE TABLE `bukuindeks` (
  `id_buku` int(11) NOT NULL,
  `judul` varchar(100) DEFAULT NULL,
  `penulis` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `kategori`
--

CREATE TABLE `kategori` (
  `id_kategori` int(11) NOT NULL,
  `nama_kategori` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `kategori`
--

INSERT INTO `kategori` (`id_kategori`, `nama_kategori`) VALUES
(1, 'Aljabar'),
(2, 'Multimedia'),
(3, 'Komputer'),
(4, 'Jaringan'),
(5, 'Sistem');

-- --------------------------------------------------------

--
-- Table structure for table `kategoribuku`
--

CREATE TABLE `kategoribuku` (
  `id_buku` int(11) NOT NULL,
  `id_kategori` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `kategoribuku`
--

INSERT INTO `kategoribuku` (`id_buku`, `id_kategori`) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);

-- --------------------------------------------------------

--
-- Table structure for table `logtabel`
--

CREATE TABLE `logtabel` (
  `id_log` int(11) NOT NULL,
  `pesan_log` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `peminjaman`
--

CREATE TABLE `peminjaman` (
  `id_peminjaman` int(11) NOT NULL,
  `id_pengguna` int(11) DEFAULT NULL,
  `id_buku` int(11) DEFAULT NULL,
  `tanggal_pinjam` date DEFAULT NULL,
  `tanggal_kembali` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `peminjaman`
--

INSERT INTO `peminjaman` (`id_peminjaman`, `id_pengguna`, `id_buku`, `tanggal_pinjam`, `tanggal_kembali`) VALUES
(1, 1, 1, '2024-01-01', '2024-01-10'),
(2, 2, 2, '2024-01-05', '2024-01-15'),
(3, 3, 3, '2024-01-07', '2024-01-17'),
(4, 4, 4, '2024-01-10', '2024-01-20'),
(5, 5, 5, '2024-01-15', '2024-01-25');

--
-- Triggers `peminjaman`
--
DELIMITER $$
CREATE TRIGGER `SebelumDeletePeminjaman` BEFORE DELETE ON `peminjaman` FOR EACH ROW BEGIN
    INSERT INTO LogTabel (pesan_log) VALUES ('Sebuah catatan peminjaman akan dihapus');
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `SebelumInsertPeminjaman` BEFORE INSERT ON `peminjaman` FOR EACH ROW BEGIN
    INSERT INTO LogTabel (pesan_log) VALUES ('Sebuah catatan peminjaman akan dimasukkan');
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `SebelumUpdatePeminjaman` BEFORE UPDATE ON `peminjaman` FOR EACH ROW BEGIN
    INSERT INTO LogTabel (pesan_log) VALUES ('Sebuah catatan peminjaman akan diupdate');
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `SetelahDeletePeminjaman` AFTER DELETE ON `peminjaman` FOR EACH ROW BEGIN
    INSERT INTO LogTabel (pesan_log) VALUES ('Sebuah catatan peminjaman telah dihapus');
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `SetelahInsertPeminjaman` AFTER INSERT ON `peminjaman` FOR EACH ROW BEGIN
    INSERT INTO LogTabel (pesan_log) VALUES ('Sebuah catatan peminjaman telah dimasukkan');
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `SetelahUpdatePeminjaman` AFTER UPDATE ON `peminjaman` FOR EACH ROW BEGIN
    INSERT INTO LogTabel (pesan_log) VALUES ('Sebuah catatan peminjaman telah diupdate');
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `pengguna`
--

CREATE TABLE `pengguna` (
  `id_pengguna` int(11) NOT NULL,
  `nama` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `pengguna`
--

INSERT INTO `pengguna` (`id_pengguna`, `nama`, `email`) VALUES
(1, 'Updated Name', 'kevin@students.amikom.ac.id'),
(2, 'Elysia', 'elysia@students.amikom.ac.id'),
(3, 'Marco', 'marco@students.amikom.ac.id'),
(4, 'David', 'david@students.amikom.ac.id'),
(5, 'Eve', 'eve@students.amikom.ac.id'),
(6, 'New User', 'newuser@students.amikom.ac.id');

-- --------------------------------------------------------

--
-- Stand-in structure for view `penggunadetail`
-- (See below for the actual view)
--
CREATE TABLE `penggunadetail` (
`id_pengguna` int(11)
,`nama` varchar(100)
,`email` varchar(100)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `penggunahorizontal`
-- (See below for the actual view)
--
CREATE TABLE `penggunahorizontal` (
`id_pengguna` int(11)
,`nama` varchar(100)
,`email` varchar(100)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `penggunavertical`
-- (See below for the actual view)
--
CREATE TABLE `penggunavertical` (
`id_pengguna` int(11)
,`nama` varchar(100)
);

-- --------------------------------------------------------

--
-- Table structure for table `profilpengguna`
--

CREATE TABLE `profilpengguna` (
  `id_pengguna` int(11) NOT NULL,
  `alamat` varchar(255) DEFAULT NULL,
  `no_telp` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure for view `penggunadetail`
--
DROP TABLE IF EXISTS `penggunadetail`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `penggunadetail`  AS SELECT `penggunahorizontal`.`id_pengguna` AS `id_pengguna`, `penggunahorizontal`.`nama` AS `nama`, `penggunahorizontal`.`email` AS `email` FROM `penggunahorizontal`WITH CASCADED CHECK OPTION  ;

-- --------------------------------------------------------

--
-- Structure for view `penggunahorizontal`
--
DROP TABLE IF EXISTS `penggunahorizontal`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `penggunahorizontal`  AS SELECT `pengguna`.`id_pengguna` AS `id_pengguna`, `pengguna`.`nama` AS `nama`, `pengguna`.`email` AS `email` FROM `pengguna` ;

-- --------------------------------------------------------

--
-- Structure for view `penggunavertical`
--
DROP TABLE IF EXISTS `penggunavertical`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `penggunavertical`  AS SELECT `pengguna`.`id_pengguna` AS `id_pengguna`, `pengguna`.`nama` AS `nama` FROM `pengguna` ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `buku`
--
ALTER TABLE `buku`
  ADD PRIMARY KEY (`id_buku`),
  ADD KEY `idx_judul` (`judul`),
  ADD KEY `idx_penulis` (`penulis`);

--
-- Indexes for table `bukuindeks`
--
ALTER TABLE `bukuindeks`
  ADD PRIMARY KEY (`id_buku`),
  ADD KEY `idx_judul_penulis` (`judul`,`penulis`);

--
-- Indexes for table `kategori`
--
ALTER TABLE `kategori`
  ADD PRIMARY KEY (`id_kategori`);

--
-- Indexes for table `kategoribuku`
--
ALTER TABLE `kategoribuku`
  ADD PRIMARY KEY (`id_buku`,`id_kategori`),
  ADD KEY `id_kategori` (`id_kategori`);

--
-- Indexes for table `logtabel`
--
ALTER TABLE `logtabel`
  ADD PRIMARY KEY (`id_log`);

--
-- Indexes for table `peminjaman`
--
ALTER TABLE `peminjaman`
  ADD PRIMARY KEY (`id_peminjaman`),
  ADD KEY `id_pengguna` (`id_pengguna`),
  ADD KEY `id_buku` (`id_buku`);

--
-- Indexes for table `pengguna`
--
ALTER TABLE `pengguna`
  ADD PRIMARY KEY (`id_pengguna`);

--
-- Indexes for table `profilpengguna`
--
ALTER TABLE `profilpengguna`
  ADD PRIMARY KEY (`id_pengguna`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `buku`
--
ALTER TABLE `buku`
  MODIFY `id_buku` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `bukuindeks`
--
ALTER TABLE `bukuindeks`
  MODIFY `id_buku` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `kategori`
--
ALTER TABLE `kategori`
  MODIFY `id_kategori` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `logtabel`
--
ALTER TABLE `logtabel`
  MODIFY `id_log` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `peminjaman`
--
ALTER TABLE `peminjaman`
  MODIFY `id_peminjaman` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `pengguna`
--
ALTER TABLE `pengguna`
  MODIFY `id_pengguna` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `kategoribuku`
--
ALTER TABLE `kategoribuku`
  ADD CONSTRAINT `kategoribuku_ibfk_1` FOREIGN KEY (`id_buku`) REFERENCES `buku` (`id_buku`),
  ADD CONSTRAINT `kategoribuku_ibfk_2` FOREIGN KEY (`id_kategori`) REFERENCES `kategori` (`id_kategori`);

--
-- Constraints for table `peminjaman`
--
ALTER TABLE `peminjaman`
  ADD CONSTRAINT `peminjaman_ibfk_1` FOREIGN KEY (`id_pengguna`) REFERENCES `pengguna` (`id_pengguna`),
  ADD CONSTRAINT `peminjaman_ibfk_2` FOREIGN KEY (`id_buku`) REFERENCES `buku` (`id_buku`);

--
-- Constraints for table `profilpengguna`
--
ALTER TABLE `profilpengguna`
  ADD CONSTRAINT `profilpengguna_ibfk_1` FOREIGN KEY (`id_pengguna`) REFERENCES `pengguna` (`id_pengguna`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
