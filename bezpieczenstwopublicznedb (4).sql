-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Czas generowania: 22 Cze 2023, 20:50
-- Wersja serwera: 10.4.27-MariaDB
-- Wersja PHP: 8.2.0

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Baza danych: `bezpieczenstwopublicznedb`
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
  `miejsce_zdarzenia` varchar(100) NOT NULL,
  `godzina_zdarzenia` time NOT NULL,
  `data_zdarzenia` date DEFAULT NULL
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

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `zgłoszenia`
--

CREATE TABLE `zgłoszenia` (
  `tytuł` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_polish_ci NOT NULL,
  `zgloszenie_id` int(10) NOT NULL,
  `user_id` smallint(6) NOT NULL,
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
-- AUTO_INCREMENT dla zrzuconych tabel
--

--
-- AUTO_INCREMENT dla tabeli `sprawcy`
--
ALTER TABLE `sprawcy`
  MODIFY `sprawca_id` int(10) NOT NULL AUTO_INCREMENT;

--
-- Ograniczenia dla zrzutów tabel
--

--
-- Ograniczenia dla tabeli `cechyzdarzenia`
--
ALTER TABLE `cechyzdarzenia`
  ADD CONSTRAINT `fk_zgloszenie` FOREIGN KEY (`zgloszenie_id`) REFERENCES `zgłoszenia` (`zgloszenie_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ograniczenia dla tabeli `sprawcy`
--
ALTER TABLE `sprawcy`
  ADD CONSTRAINT `sprawcy_ibfk_1` FOREIGN KEY (`zgloszenie_id`) REFERENCES `zgłoszenia` (`zgloszenie_id`);

--
-- Ograniczenia dla tabeli `zgłoszenia`
--
ALTER TABLE `zgłoszenia`
  ADD CONSTRAINT `zgłoszenia_ibfk_3` FOREIGN KEY (`user_id`) REFERENCES `użytkownicy` (`user_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
