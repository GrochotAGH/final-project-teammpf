-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Cze 27, 2023 at 12:42 PM
-- Wersja serwera: 10.4.28-MariaDB
-- Wersja PHP: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `bezpieczenstwopublicznedb`
--

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `cechyzdarzenia`
--

CREATE TABLE `cechyzdarzenia` (
  `opis_sprawcy` text CHARACTER SET utf32 COLLATE utf32_polish_ci DEFAULT NULL,
  `opis_zdarzenia` longtext CHARACTER SET utf32 COLLATE utf32_polish_ci NOT NULL,
  `liczba_sprawcow` int(3) DEFAULT NULL,
  `zgloszenie_id` int(10) NOT NULL,
  `adres` varchar(100) NOT NULL,
  `godzina_zdarzenia` time NOT NULL,
  `data_zdarzenia` date DEFAULT NULL,
  `miasto` varchar(50) DEFAULT NULL,
  `wojewodztwo` varchar(50) DEFAULT NULL,
  `kod_pocztowy` varchar(7) DEFAULT NULL,
  `numer_lokalu` varchar(8) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `sprawcy`
--

CREATE TABLE `sprawcy` (
  `sprawca_id` int(10) NOT NULL,
  `zgloszenie_id` int(10) NOT NULL,
  `imie` varchar(20) CHARACTER SET utf32 COLLATE utf32_polish_ci DEFAULT NULL,
  `nazwisko` varchar(20) CHARACTER SET utf32 COLLATE utf32_polish_ci DEFAULT NULL,
  `data_urodzenia` date DEFAULT NULL,
  `opis` mediumtext CHARACTER SET utf32 COLLATE utf32_polish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `użytkownicy`
--

CREATE TABLE `użytkownicy` (
  `user_id` smallint(6) NOT NULL,
  `login` varchar(50) CHARACTER SET utf8 COLLATE utf8_polish_ci NOT NULL,
  `hasło` varchar(255) NOT NULL,
  `rola` varchar(20) CHARACTER SET utf8 COLLATE utf8_polish_ci NOT NULL,
  `email` varchar(100) NOT NULL,
  `imię` varchar(50) CHARACTER SET utf8 COLLATE utf8_polish_ci NOT NULL,
  `nazwisko` varchar(50) CHARACTER SET utf8 COLLATE utf8_polish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `użytkownicy`
--

INSERT INTO `użytkownicy` (`user_id`, `login`, `hasło`, `rola`, `email`, `imię`, `nazwisko`) VALUES
(25, 'holmings', 'abe31fe1a2113e7e8bf174164515802806d388cf4f394cceace7341a182271ab', 'cywil', 'patrycjax1717@gmail.com', 'Patrycja', 'Ruda'),
(26, 'gabi123', 'abe31fe1a2113e7e8bf174164515802806d388cf4f394cceace7341a182271ab', 'cywil', 'xyzyx2020@gmail.com', 'Gabi', 'Nowak');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `zgłoszenia`
--

CREATE TABLE `zgłoszenia` (
  `tytuł` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_polish_ci NOT NULL,
  `zgloszenie_id` int(10) NOT NULL,
  `user_id` smallint(6) DEFAULT NULL,
  `godzina_zgloszenia` time NOT NULL,
  `data_zgloszenia` date NOT NULL,
  `status` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_polish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Indeksy dla zrzutów tabel
--

--
-- Indeksy dla tabeli `cechyzdarzenia`
--
ALTER TABLE `cechyzdarzenia`
  ADD PRIMARY KEY (`zgloszenie_id`);

--
-- Indeksy dla tabeli `sprawcy`
--
ALTER TABLE `sprawcy`
  ADD PRIMARY KEY (`sprawca_id`),
  ADD KEY `zgloszenie_id` (`zgloszenie_id`);

--
-- Indeksy dla tabeli `użytkownicy`
--
ALTER TABLE `użytkownicy`
  ADD PRIMARY KEY (`user_id`);

--
-- Indeksy dla tabeli `zgłoszenia`
--
ALTER TABLE `zgłoszenia`
  ADD PRIMARY KEY (`zgloszenie_id`),
  ADD KEY `zgłoszenia_ibfk_3` (`user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `sprawcy`
--
ALTER TABLE `sprawcy`
  MODIFY `sprawca_id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `użytkownicy`
--
ALTER TABLE `użytkownicy`
  MODIFY `user_id` smallint(6) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT for table `zgłoszenia`
--
ALTER TABLE `zgłoszenia`
  MODIFY `zgloszenie_id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `cechyzdarzenia`
--
ALTER TABLE `cechyzdarzenia`
  ADD CONSTRAINT `fk_zgloszenie` FOREIGN KEY (`zgloszenie_id`) REFERENCES `zgłoszenia` (`zgloszenie_id`);

--
-- Constraints for table `sprawcy`
--
ALTER TABLE `sprawcy`
  ADD CONSTRAINT `sprawcy_ibfk_1` FOREIGN KEY (`zgloszenie_id`) REFERENCES `zgłoszenia` (`zgloszenie_id`);

--
-- Constraints for table `zgłoszenia`
--
ALTER TABLE `zgłoszenia`
  ADD CONSTRAINT `zgłoszenia_ibfk_3` FOREIGN KEY (`user_id`) REFERENCES `użytkownicy` (`user_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
