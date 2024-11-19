-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Apr 19, 2024 at 07:14 PM
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
-- Database: `flyingticketproject`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `admin_add` (IN `p_fname` VARCHAR(255), IN `p_lname` VARCHAR(255), IN `p_username` VARCHAR(255), IN `p_email` VARCHAR(255), IN `p_password` VARCHAR(255), IN `p_role` VARCHAR(255), IN `p_dp` VARCHAR(255), OUT `p_success` INT)   BEGIN
    DECLARE success_count INT;
    DECLARE hashed_password VARCHAR(255); -- Variable to store hashed password
    
    -- Hash the incoming password
    SET hashed_password = PASSWORD(p_password); -- Assuming you're using MySQL's PASSWORD function
    
    -- Attempt to insert the record
    INSERT INTO admin (fname, lname, username, email, password, role, dp)
    VALUES (p_fname, p_lname, p_username, p_email, hashed_password, p_role, p_dp);
    
    -- Check if the insert was successful
    SELECT COUNT(*) INTO success_count FROM admin WHERE username = p_username;
    
    IF success_count = 1 THEN
        SET p_success = 1; -- Success
    ELSE
        SET p_success = 0; -- Failure
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `admin_login` (IN `p_email` VARCHAR(255), IN `p_password` VARCHAR(255), OUT `p_success` BOOLEAN, OUT `p_id` INT, OUT `p_fname` VARCHAR(255), OUT `p_lname` VARCHAR(255), OUT `p_username` VARCHAR(255), OUT `p_role` VARCHAR(255), OUT `p_dp` VARCHAR(255))   BEGIN
    DECLARE user_count INT;
    DECLARE hashed_password VARCHAR(255); -- Variable to store hashed password
    
    -- Hash the incoming password
    SET hashed_password = PASSWORD(p_password); -- Assuming you're using MySQL's PASSWORD function
    
    -- Check if user exists with provided email and hashed password
    SELECT COUNT(*) INTO user_count
    FROM admin
    WHERE email = p_email AND password = hashed_password;
    
    IF user_count = 1 THEN
        -- User exists, fetch user details
        SELECT id, fname, lname, username, role, dp
        INTO p_id, p_fname, p_lname, p_username, p_role, p_dp
        FROM admin
        WHERE email = p_email;
        
        SET p_success = TRUE;
    ELSE
        -- User doesn't exist or incorrect credentials
        SET p_success = FALSE;
        SET p_id = NULL;
        SET p_fname = NULL;
        SET p_lname = NULL;
        SET p_username = NULL;
        SET p_role = NULL;
        SET p_dp = NULL;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `admin_update` (IN `p_fname` VARCHAR(255), IN `p_lname` VARCHAR(255), IN `p_username` VARCHAR(255), IN `p_email` VARCHAR(255), IN `p_password` VARCHAR(255), IN `p_dp` VARCHAR(255), IN `p_id` INT, OUT `p_success` INT)   BEGIN
    DECLARE success_count INT;
    DECLARE hashed_password VARCHAR(255); -- Variable to store hashed password
    
    -- Hash the incoming password
    SET hashed_password = PASSWORD(p_password); -- Assuming you're using MySQL's PASSWORD function
    
    -- Attempt to update the record if exists, otherwise insert
    
        UPDATE admin
        SET fname = p_fname,
            lname = p_lname,
            username = p_username,
            email = p_email,
            password = hashed_password,
            dp = p_dp
        WHERE id = p_id;
    
    
    -- Check if the insert/update was successful
    SELECT COUNT(*) INTO success_count FROM admin WHERE id = p_id;
    
    IF success_count = 1 THEN
        SET p_success = 1; -- Success
    ELSE
        SET p_success = 0; -- Failure
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ticket_transaction` (IN `limit_val` INT)   BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE counter INT DEFAULT 0;
    DECLARE last_passenger_id, last_user_id, last_flight_id INT;
    DECLARE flight_price DECIMAL(10, 2);
    
    -- Declare cursor for selecting rows from passenger_profile
    DECLARE cur CURSOR FOR
        SELECT passenger_id, user_id, flight_id
        FROM passenger_profile
        ORDER BY passenger_id DESC
        LIMIT limit_val;
        
    -- Declare continue handler for cursor
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    -- Open the cursor
    OPEN cur;
    
    -- Start loop
    my_loop: LOOP
        -- Fetch data from cursor
        FETCH cur INTO last_passenger_id, last_user_id, last_flight_id;
        
        -- Exit loop if no more rows or counter reaches limit_val
        IF done OR counter >= limit_val THEN
            LEAVE my_loop;
        END IF;
        
        -- Get the price of the flight
        SELECT Price INTO flight_price
        FROM flight
        WHERE flight_id = last_flight_id;
        
        -- Insert into ticket table
        INSERT INTO ticket (passenger_id, user_id, flight_id, seat_no, cost, class)
        VALUES (last_passenger_id, last_user_id, last_flight_id, '21Z', flight_price, 'E');
        
        -- Increment counter
        SET counter = counter + 1;
    END LOOP;

    -- Close cursor
    CLOSE cur;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ticket_transactionn` (IN `limit_value` INT)   BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE passenger_id_val, user_id_val, flight_id_val INT;
    DECLARE price_val DECIMAL(10,2);

    -- Cursor declaration to fetch rows from passenger_profile table
    DECLARE cur CURSOR FOR 
        SELECT passenger_id, user_id, flight_id 
        FROM passenger_profile 
        ORDER BY passenger_id DESC 
        LIMIT limit_value;
        
    -- Declare continue handler to exit loop when no more rows are found
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    -- Open the cursor
    OPEN cur;

    -- Loop through the cursor result set
    read_loop: LOOP
        -- Fetch the next row into variables
        FETCH cur INTO passenger_id_val, user_id_val, flight_id_val;

        -- Exit loop if no more rows to fetch
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Get the price from the flight table based on the flight_id
        SELECT Price INTO price_val FROM flight WHERE flight_id = flight_id_val;

        -- Insert into payment table
        INSERT INTO payment (user_id, flight_id, amount) 
        VALUES (user_id_val, flight_id_val, price_val);

        -- Insert into ticket table
        INSERT INTO ticket (passenger_id, user_id, flight_id, cost, class) 
        VALUES (passenger_id_val, user_id_val, flight_id_val, price_val, 'Economy');
    END LOOP;

    -- Close the cursor
    CLOSE cur;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `user_login` (IN `p_email` VARCHAR(255), IN `p_password` VARCHAR(255), OUT `p_success` BOOLEAN, OUT `p_id` INT, OUT `p_fname` VARCHAR(255), OUT `p_lname` VARCHAR(255), OUT `p_username` VARCHAR(255), OUT `p_role` VARCHAR(255), OUT `p_dp` VARCHAR(255))   BEGIN
    DECLARE user_count INT;
    DECLARE hashed_password VARCHAR(255); -- Variable to store hashed password
    
    -- Hash the incoming password
    SET hashed_password = PASSWORD(p_password); -- Assuming you're using MySQL's PASSWORD function
    
    -- Check if user exists with provided email and hashed password
    SELECT COUNT(*) INTO user_count
    FROM users
    WHERE email = p_email AND password = hashed_password;
    
    IF user_count = 1 THEN
        -- User exists, fetch user details
        SELECT id, fname, lname, username, role, dp
        INTO p_id, p_fname, p_lname, p_username, p_role, p_dp
        FROM users
        WHERE email = p_email;
        
        SET p_success = TRUE;
    ELSE
        -- User doesn't exist or incorrect credentials
        SET p_success = FALSE;
        SET p_id = NULL;
        SET p_fname = NULL;
        SET p_lname = NULL;
        SET p_username = NULL;
        SET p_role = NULL;
        SET p_dp = NULL;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `user_reg` (IN `p_fname` VARCHAR(255), IN `p_lname` VARCHAR(255), IN `p_username` VARCHAR(255), IN `p_email` VARCHAR(255), IN `p_password` VARCHAR(255), OUT `p_success` INT)   BEGIN
    DECLARE success_count INT;
    DECLARE hashed_password VARCHAR(255); -- Variable to store hashed password
    
    -- Hash the incoming password
    SET hashed_password = PASSWORD(p_password); -- Assuming you're using MySQL's PASSWORD function
    
    -- Attempt to insert the record
    INSERT INTO users (fname, lname, username, email, password, role, dp)
    VALUES (p_fname, p_lname, p_username, p_email, hashed_password, "user", "user4-128x128.jpg");
    
    -- Check if the insert was successful
    SELECT COUNT(*) INTO success_count FROM users WHERE username = p_username;
    
    IF success_count = 1 THEN
        SET p_success = 1; -- Success
    ELSE
        SET p_success = 0; -- Failure
    END IF;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `admin`
--

CREATE TABLE `admin` (
  `id` int(11) NOT NULL,
  `fname` varchar(255) NOT NULL,
  `lname` varchar(255) NOT NULL,
  `username` varchar(20) NOT NULL,
  `email` varchar(50) NOT NULL,
  `password` varchar(100) NOT NULL,
  `role` varchar(255) NOT NULL,
  `dp` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `admin`
--

INSERT INTO `admin` (`id`, `fname`, `lname`, `username`, `email`, `password`, `role`, `dp`) VALUES
(1, 'Isuru', 'Bandara', 'isuru', 'isurubandara318@gmail.com', '*23AE809DDACAF96AF0FD78ED04B6A265E05AA257', 'admin', 'user1-128x128.jpg'),
(2, 'idunil', 'bandara', 'idunil', 'idunil@gmail.com', '*23AE809DDACAF96AF0FD78ED04B6A265E05AA257', 'user', 'user8-128x128.jpg');

-- --------------------------------------------------------

--
-- Table structure for table `airline`
--

CREATE TABLE `airline` (
  `airline_id` int(11) NOT NULL,
  `name` varchar(20) NOT NULL,
  `seats` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `airline`
--

INSERT INTO `airline` (`airline_id`, `name`, `seats`) VALUES
(1, 'Core Airways', 165),
(2, 'Echo Airline', 220),
(3, 'Spark Airways', 125),
(4, 'Peak Airways', 210),
(5, 'Homelander Airways', 185),
(9, 'Blue Airlines', 200),
(10, 'GoldStar Airways', 205),
(11, 'Novar Airways', 158),
(12, 'Aero Airways', 210),
(13, 'Nep Airways', 215),
(14, 'Delta Airlines', 135),
(15, 'Kamal Line', 69),
(17, 'Loku Line', 100);

-- --------------------------------------------------------

--
-- Table structure for table `cities`
--

CREATE TABLE `cities` (
  `city` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `cities`
--

INSERT INTO `cities` (`city`) VALUES
('Chicago'),
('Olisphis'),
('Shiburn'),
('Weling'),
('Chiby'),
('Odonhull'),
('Hegan'),
('Oriaridge'),
('Flerough'),
('Yleigh'),
('Oyladnard'),
('Trerdence'),
('Zhotrora'),
('Otiginia'),
('Plueyby'),
('Vrexledo'),
('Ariosey'),
('Glenmoor'),
('Sunnydale'),
('Springfield'),
('Riverside'),
('Meadowview'),
('Fairhaven'),
('Hillcrest'),
('Woodland'),
('Oakwood'),
('Mapleton');

-- --------------------------------------------------------

--
-- Table structure for table `feedback`
--

CREATE TABLE `feedback` (
  `feed_id` int(11) NOT NULL,
  `email` varchar(50) NOT NULL,
  `q1` varchar(250) NOT NULL,
  `q2` varchar(20) NOT NULL,
  `q3` varchar(250) NOT NULL,
  `rate` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `flight`
--

CREATE TABLE `flight` (
  `flight_id` int(11) NOT NULL,
  `admin_id` int(11) NOT NULL,
  `departure` datetime NOT NULL,
  `arrival` datetime NOT NULL,
  `source` varchar(20) NOT NULL,
  `Destination` varchar(20) NOT NULL,
  `airline` varchar(20) NOT NULL,
  `Seats` varchar(110) NOT NULL,
  `duration` varchar(20) NOT NULL,
  `Price` decimal(10,2) NOT NULL,
  `status` varchar(6) DEFAULT NULL,
  `issue` varchar(50) DEFAULT NULL,
  `last_seat` varchar(5) DEFAULT '',
  `bus_seats` int(11) DEFAULT 20,
  `last_bus_seat` varchar(5) DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `flight`
--

INSERT INTO `flight` (`flight_id`, `admin_id`, `departure`, `arrival`, `source`, `Destination`, `airline`, `Seats`, `duration`, `Price`, `status`, `issue`, `last_seat`, `bus_seats`, `last_bus_seat`) VALUES
(1, 1, '2024-04-01 10:03:00', '2024-04-02 11:01:00', 'Chicago', 'San', 'Core Airways', '63', '1', 175.00, '', '', '21B', 20, ''),
(2, 1, '2024-04-02 11:15:00', '2024-04-02 11:59:00', 'Shiburn', 'Olisphis', 'Core Airways', '61', '1', 185.00, 'arr', '', '21D', 20, ''),
(3, 1, '2024-04-03 12:13:00', '2024-04-03 12:57:00', 'Weling', 'Olisphis', 'Spark Airways', '123', '2', 205.00, 'arr', '', '21B', 20, ''),
(8, 1, '2024-04-05 00:55:00', '2024-04-05 05:00:00', 'Oyladnard', 'Odonhull', 'Homelander Airways', '183', '7', 615.00, 'arr', '', '21B', 20, ''),
(20, 1, '2024-04-12 23:58:00', '2024-04-13 00:01:00', 'Zhotrora', 'Trerdence', 'Aero Airways', '208', '1', 185.00, 'dep', '', '21B', 20, ''),
(33, 1, '2024-03-24 01:34:00', '2024-03-24 05:34:00', 'Chicago', 'Chiby', 'Novar Airways', '158', '3', 89.90, '', '', '', 20, ''),
(34, 1, '2024-03-26 09:58:00', '2024-03-26 10:59:00', 'Chicago', 'Chiby', 'Kamal Line', '69', '4', 67.90, '', '', '', 20, ''),
(35, 1, '2024-03-25 14:20:00', '2024-03-25 17:23:00', 'Hegan', 'Ariosey', 'Loku Line', '100', '3', 56.80, '', '', '', 20, ''),
(36, 1, '2024-04-15 14:12:00', '2024-04-15 20:18:00', 'Vrexledo', 'Hegan', 'Loku Line', '100', '3', 55.00, '', '', '', 20, ''),
(37, 1, '2024-04-15 16:36:00', '2024-04-15 17:37:00', 'Sunnydale', 'Oakwood', 'Loku Line', '100', '1', 61.00, '', '', '', 20, '');

--
-- Triggers `flight`
--
DELIMITER $$
CREATE TRIGGER `check_departure_arrival_dates` BEFORE INSERT ON `flight` FOR EACH ROW BEGIN
    IF NEW.departure >= NEW.arrival THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Departure date must be before arrival date';
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `flight_change_log` AFTER INSERT ON `flight` FOR EACH ROW BEGIN
    INSERT INTO flight_change_history (flight_id, action, changed_by, changed_at)
    VALUES (NEW.flight_id, 'INSERT', USER(), NOW());
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `flight_change_history`
--

CREATE TABLE `flight_change_history` (
  `change_id` int(11) NOT NULL,
  `flight_id` int(11) NOT NULL,
  `action` varchar(10) NOT NULL,
  `changed_by` varchar(255) NOT NULL,
  `changed_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `flight_change_history`
--

INSERT INTO `flight_change_history` (`change_id`, `flight_id`, `action`, `changed_by`, `changed_at`) VALUES
(1, 37, 'INSERT', 'root@localhost', '2024-04-15 11:06:54');

-- --------------------------------------------------------

--
-- Table structure for table `passenger_profile`
--

CREATE TABLE `passenger_profile` (
  `passenger_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `flight_id` int(11) NOT NULL,
  `mobile` varchar(110) NOT NULL,
  `dob` date NOT NULL,
  `f_name` varchar(20) DEFAULT NULL,
  `m_name` varchar(20) DEFAULT NULL,
  `l_name` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `passenger_profile`
--

INSERT INTO `passenger_profile` (`passenger_id`, `user_id`, `flight_id`, `mobile`, `dob`, `f_name`, `m_name`, `l_name`) VALUES
(1, 1, 1, '0766008527', '1995-01-01', 'Isuru', 'M', 'Bandara'),
(2, 1, 3, '0766008527', '1995-02-13', 'Isuru', 'l', 'bandara'),
(3, 3, 2, '2147483647', '1994-06-21', 'Andre', 'J', 'Atkins'),
(4, 4, 2, '2147483647', '1995-05-16', 'James', 'K', 'Harbuck'),
(5, 2, 8, '7854444411', '1995-02-13', 'Henry', 'l', 'Stuart'),
(6, 2, 20, '7412585555', '1995-02-13', 'Henry', 'l', 'Stuart'),
(64, 1, 34, '4', '2024-04-15', 'Isuru', NULL, 'Bandara'),
(65, 1, 34, '4', '2024-04-15', 'Isuru', NULL, 'Bandara'),
(66, 1, 34, '4', '2024-04-15', 'Isuru', NULL, 'Bandara'),
(67, 1, 34, '4', '2024-04-15', 'Isuru', NULL, 'Bandara'),
(68, 1, 34, '34444', '2024-04-15', 'Isuru', NULL, 'Bandara'),
(69, 1, 34, '36666', '2024-04-15', 'Idunil', NULL, 'Bandara'),
(70, 1, 34, '377777', '2024-04-15', 'Samare', NULL, 'Bandara'),
(71, 9, 37, '0766008527', '2024-04-15', 'Isuri', NULL, 'Samaranayake'),
(72, 9, 37, '0757142414', '2024-04-15', 'Isuru', NULL, 'Bandara');

-- --------------------------------------------------------

--
-- Table structure for table `payment`
--

CREATE TABLE `payment` (
  `card_no` varchar(16) NOT NULL,
  `user_id` int(11) NOT NULL,
  `flight_id` int(11) NOT NULL,
  `expire_date` varchar(5) DEFAULT NULL,
  `amount` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `payment`
--

INSERT INTO `payment` (`card_no`, `user_id`, `flight_id`, `expire_date`, `amount`) VALUES
('', 1, 34, NULL, 68),
('1111222211112222', 1, 34, '11/11', 111),
('1221122112211221', 9, 37, '11/11', 111),
('1234123412341234', 1, 34, '11/11', 111),
('2323232312121212', 1, 34, '12/21', 111),
('3333111133332222', 1, 34, '11/11', 111);

-- --------------------------------------------------------

--
-- Table structure for table `pwdreset`
--

CREATE TABLE `pwdreset` (
  `pwd_reset_id` int(11) NOT NULL,
  `pwd_reset_email` varchar(50) NOT NULL,
  `pwd_reset_selector` varchar(80) NOT NULL,
  `pwd_reset_token` varchar(120) NOT NULL,
  `pwd_reset_expires` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `ticket`
--

CREATE TABLE `ticket` (
  `ticket_id` int(11) NOT NULL,
  `passenger_id` int(11) NOT NULL,
  `flight_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `seat_no` varchar(10) NOT NULL,
  `cost` decimal(10,2) NOT NULL,
  `class` varchar(3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `ticket`
--

INSERT INTO `ticket` (`ticket_id`, `passenger_id`, `flight_id`, `user_id`, `seat_no`, `cost`, `class`) VALUES
(4, 3, 2, 3, '21A', 185.00, 'E'),
(8, 5, 8, 2, '21A', 1230.00, 'E'),
(10, 6, 20, 2, '21A', 370.00, 'E'),
(29, 6, 20, 2, '21Z', 185.00, 'E'),
(30, 5, 8, 2, '21Z', 615.00, 'E'),
(44, 70, 34, 1, '21Z', 67.90, 'E'),
(45, 69, 34, 1, '21Z', 67.90, 'E'),
(46, 68, 34, 1, '21Z', 67.90, 'E'),
(47, 72, 37, 9, '21Z', 61.00, 'E'),
(48, 71, 37, 9, '21Z', 61.00, 'E');

-- --------------------------------------------------------

--
-- Table structure for table `ticket_change_history`
--

CREATE TABLE `ticket_change_history` (
  `change_id` int(11) NOT NULL,
  `ticket_id` int(11) NOT NULL,
  `action` varchar(10) NOT NULL,
  `changed_by` varchar(255) NOT NULL,
  `changed_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `fname` varchar(255) NOT NULL,
  `lname` varchar(255) NOT NULL,
  `username` varchar(20) NOT NULL,
  `email` varchar(50) NOT NULL,
  `password` varchar(100) NOT NULL,
  `role` varchar(255) NOT NULL,
  `dp` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `fname`, `lname`, `username`, `email`, `password`, `role`, `dp`) VALUES
(1, 'Isuru', 'Bandara', 'isuru', 'isurubandara318@gmail.com', '*23AE809DDACAF96AF0FD78ED04B6A265E05AA257', 'user', 'user1-128x128.jpg'),
(2, 'Amndu', 'Sangeeth', 'henry', 'henry@mail.com', '*23AE809DDACAF96AF0FD78ED04B6A265E05AA257', '', ''),
(3, '', '', 'andre', 'andre@mail.com', '*23AE809DDACAF96AF0FD78ED04B6A265E05AA257', '', ''),
(4, '', '', 'james', 'james@mail.com', '*23AE809DDACAF96AF0FD78ED04B6A265E05AA257', '', ''),
(5, 'Idunil', 'Bandara', 'idu', 'idunil@gmail.com', '*23AE809DDACAF96AF0FD78ED04B6A265E05AA257', 'user', 'user4-128x128.jpg'),
(9, 'Isuri', 'Samaranayake', 'isuri', 'isuri@gmail.com', '*23AE809DDACAF96AF0FD78ED04B6A265E05AA257', 'user', 'user4-128x128.jpg');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admin`
--
ALTER TABLE `admin`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `airline`
--
ALTER TABLE `airline`
  ADD PRIMARY KEY (`airline_id`);

--
-- Indexes for table `feedback`
--
ALTER TABLE `feedback`
  ADD PRIMARY KEY (`feed_id`);

--
-- Indexes for table `flight`
--
ALTER TABLE `flight`
  ADD PRIMARY KEY (`flight_id`),
  ADD KEY `admin_id` (`admin_id`);

--
-- Indexes for table `flight_change_history`
--
ALTER TABLE `flight_change_history`
  ADD PRIMARY KEY (`change_id`);

--
-- Indexes for table `passenger_profile`
--
ALTER TABLE `passenger_profile`
  ADD PRIMARY KEY (`passenger_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `flight_id` (`flight_id`);

--
-- Indexes for table `payment`
--
ALTER TABLE `payment`
  ADD PRIMARY KEY (`card_no`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `flight_id` (`flight_id`);

--
-- Indexes for table `pwdreset`
--
ALTER TABLE `pwdreset`
  ADD PRIMARY KEY (`pwd_reset_id`);

--
-- Indexes for table `ticket`
--
ALTER TABLE `ticket`
  ADD PRIMARY KEY (`ticket_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `flight_id` (`flight_id`),
  ADD KEY `passenger_id` (`passenger_id`);

--
-- Indexes for table `ticket_change_history`
--
ALTER TABLE `ticket_change_history`
  ADD PRIMARY KEY (`change_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admin`
--
ALTER TABLE `admin`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `airline`
--
ALTER TABLE `airline`
  MODIFY `airline_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `feedback`
--
ALTER TABLE `feedback`
  MODIFY `feed_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `flight`
--
ALTER TABLE `flight`
  MODIFY `flight_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=38;

--
-- AUTO_INCREMENT for table `flight_change_history`
--
ALTER TABLE `flight_change_history`
  MODIFY `change_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `passenger_profile`
--
ALTER TABLE `passenger_profile`
  MODIFY `passenger_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=73;

--
-- AUTO_INCREMENT for table `pwdreset`
--
ALTER TABLE `pwdreset`
  MODIFY `pwd_reset_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `ticket`
--
ALTER TABLE `ticket`
  MODIFY `ticket_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=49;

--
-- AUTO_INCREMENT for table `ticket_change_history`
--
ALTER TABLE `ticket_change_history`
  MODIFY `change_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `flight`
--
ALTER TABLE `flight`
  ADD CONSTRAINT `flight_ibfk_1` FOREIGN KEY (`admin_id`) REFERENCES `admin` (`id`);

--
-- Constraints for table `passenger_profile`
--
ALTER TABLE `passenger_profile`
  ADD CONSTRAINT `passenger_profile_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `passenger_profile_ibfk_2` FOREIGN KEY (`flight_id`) REFERENCES `flight` (`flight_id`);

--
-- Constraints for table `payment`
--
ALTER TABLE `payment`
  ADD CONSTRAINT `payment_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `payment_ibfk_2` FOREIGN KEY (`flight_id`) REFERENCES `flight` (`flight_id`);

--
-- Constraints for table `ticket`
--
ALTER TABLE `ticket`
  ADD CONSTRAINT `ticket_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `ticket_ibfk_2` FOREIGN KEY (`flight_id`) REFERENCES `flight` (`flight_id`),
  ADD CONSTRAINT `ticket_ibfk_3` FOREIGN KEY (`passenger_id`) REFERENCES `passenger_profile` (`passenger_id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
