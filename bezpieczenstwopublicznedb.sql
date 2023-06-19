-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Czas generowania: 10 Cze 2023, 16:24
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
  `zgloszenie_id` int(10) NOT NULL,
  `opis_sprawcy` text CHARACTER SET utf32 COLLATE utf32_polish_ci DEFAULT NULL,
  `opis_zdarzenia` longtext CHARACTER SET utf32 COLLATE utf32_polish_ci NOT NULL,
  `liczba_sprawcow` int(3) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Zrzut danych tabeli `cechyzdarzenia`
--

INSERT INTO `cechyzdarzenia` (`zgloszenie_id`, `opis_sprawcy`, `opis_zdarzenia`, `liczba_sprawcow`) VALUES
(1, 'Przystojny brunet o niebieskich oczach. Wysoki około 180 cm. Dosyć szczupły. Blizna na policzku. Ubrany na czarno.', 'Wszystko działo się gdy wracałam ze szkoły. Mężczyzna podbiegł i wyrwał mi torebkę po czym zaczął uciekać i zniknął na rogu ulic Czarnowiejska i Piastowska.', 1);

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
  `email` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Zrzut danych tabeli `użytkownicy`
--

INSERT INTO `użytkownicy` (`user_id`, `login`, `hasło`, `rola`, `email`) VALUES
(1, 'lol', 'lol123', 'cywil', 'lol@poczta.pl');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `zgłoszenia`
--

CREATE TABLE `zgłoszenia` (
  `zgloszenie_id` int(10) NOT NULL,
  `user_id` smallint(6) DEFAULT NULL,
  `tytuł` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_polish_ci NOT NULL,
  `godzina_zgloszenia` time NOT NULL,
  `data_zgloszenia` date NOT NULL,
  `status` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_polish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Zrzut danych tabeli `zgłoszenia`
--

INSERT INTO `zgłoszenia` (`zgloszenie_id`, `user_id`, `tytuł`, `godzina_zgloszenia`, `data_zgloszenia`, `status`) VALUES
(1, 1, 'kradzież', '17:33:30', '2023-06-01', 'przyjęte');

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
  ADD KEY `user_id` (`user_id`);

--
-- AUTO_INCREMENT dla zrzuconych tabel
--

--
-- AUTO_INCREMENT dla tabeli `sprawcy`
--
ALTER TABLE `sprawcy`
  MODIFY `sprawca_id` int(10) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT dla tabeli `zgłoszenia`
--
ALTER TABLE `zgłoszenia`
  MODIFY `zgloszenie_id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Ograniczenia dla zrzutów tabel
--

--
-- Ograniczenia dla tabeli `cechyzdarzenia`
--
ALTER TABLE `cechyzdarzenia`
  ADD CONSTRAINT `cechyzdarzenia_ibfk_1` FOREIGN KEY (`zgloszenie_id`) REFERENCES `zgłoszenia` (`zgloszenie_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ograniczenia dla tabeli `sprawcy`
--
ALTER TABLE `sprawcy`
  ADD CONSTRAINT `sprawcy_ibfk_1` FOREIGN KEY (`zgloszenie_id`) REFERENCES `zgłoszenia` (`zgloszenie_id`);

--
-- Ograniczenia dla tabeli `zgłoszenia`
--
ALTER TABLE `zgłoszenia`
  ADD CONSTRAINT `zgłoszenia_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `użytkownicy` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
