-- phpMyAdmin SQL Dump
-- version 4.8.3
-- https://www.phpmyadmin.net/
--
-- Host: localhost:8889
-- Generation Time: Dec 16, 2020 at 12:47 AM
-- Server version: 5.7.23
-- PHP Version: 7.2.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

--
-- Database: `twitter3`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `readAllHashtags` ()  NO SQL
SELECT tweet_hashtags.*, tweets.tweet_id, tweets.tweet_user_fk, tweets.tweet_message, hashtags.* 
FROM tweet_hashtags JOIN tweets 
ON tweet_hashtag_tweet_fk = tweets.tweet_id 
JOIN hashtags ON tweet_hashtag_hashtag_fk = hashtag_id$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `readComments` ()  NO SQL
SELECT comments.*, tweets.tweet_id, tweets.tweet_user_fk, tweets.tweet_message, users.user_id, users.user_profile_name 
FROM comments JOIN tweets 
ON tweets.tweet_id = comment_tweet_fk 
JOIN users ON users.user_id = comments.comment_user_fk$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `readTweets` ()  NO SQL
SELECT tweets.*, users.user_name, users.user_image_path, users.user_profile_name 
FROM tweets JOIN users 
WHERE tweets.tweet_user_fk = users.user_id 
ORDER BY tweets.tweet_id DESC 
LIMIT 20$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `readTweetsForLists` ()  NO SQL
SELECT lists.*, list_members.*, users.user_id, users.user_profile_name, tweets.tweet_id, tweets.tweet_user_fk, tweets.tweet_message 
FROM lists JOIN list_members 
ON lists.list_id = list_member_list_fk 
JOIN users ON users.user_id = list_member_user_fk 
JOIN tweets ON tweets.tweet_user_fk = list_member_user_fk 
AND list_id = list_member_list_fk$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `bookmarks`
--

CREATE TABLE `bookmarks` (
  `bookmark_id` bigint(20) UNSIGNED NOT NULL,
  `bookmark_user_fk` bigint(20) UNSIGNED NOT NULL,
  `bookmark_tweet_fk` bigint(20) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Triggers `bookmarks`
--
DELIMITER $$
CREATE TRIGGER `decrease_total_bookmarks` AFTER DELETE ON `bookmarks` FOR EACH ROW UPDATE tweets 
SET tweet_total_bookmarks = tweet_total_bookmarks - 1
WHERE tweet_id = OLD.bookmark_tweet_fk
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `increment_total_bookmarks` AFTER INSERT ON `bookmarks` FOR EACH ROW UPDATE tweets 
SET tweet_total_bookmarks = tweet_total_bookmarks + 1
WHERE tweet_id = NEW.bookmark_tweet_fk
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `chat_rooms`
--

CREATE TABLE `chat_rooms` (
  `chat_room_id` bigint(20) UNSIGNED NOT NULL,
  `chat_room_name` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `chat_rooms`
--

INSERT INTO `chat_rooms` (`chat_room_id`, `chat_room_name`) VALUES
(3, 'chatroom 1');

-- --------------------------------------------------------

--
-- Table structure for table `chat_room_members`
--

CREATE TABLE `chat_room_members` (
  `chat_room_user_fk` bigint(20) UNSIGNED NOT NULL,
  `chat_room_fk` bigint(20) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `comments`
--

CREATE TABLE `comments` (
  `comment_id` bigint(20) UNSIGNED NOT NULL,
  `comment_user_fk` bigint(20) UNSIGNED NOT NULL,
  `comment_tweet_fk` bigint(20) UNSIGNED NOT NULL,
  `comment_message` varchar(140) COLLATE utf8mb4_unicode_ci NOT NULL,
  `comment_created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `comment_active` tinyint(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `comments`
--

INSERT INTO `comments` (`comment_id`, `comment_user_fk`, `comment_tweet_fk`, `comment_message`, `comment_created`, `comment_active`) VALUES
(3, 5, 1, 'hello from michell', '2020-12-11 21:28:55', 1),
(4, 5, 6, 'hello again from m', '2020-12-11 21:29:05', 1),
(5, 5, 1, 'testing comments', '2020-12-14 12:39:50', 1);

--
-- Triggers `comments`
--
DELIMITER $$
CREATE TRIGGER `decrease_total_comments` AFTER DELETE ON `comments` FOR EACH ROW UPDATE tweets
SET tweet_total_comments = tweet_total_comments - 1
WHERE tweet_id = OLD.comment_tweet_fk
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `increment_total_comments` AFTER INSERT ON `comments` FOR EACH ROW UPDATE tweets 
SET tweet_total_comments = tweet_total_comments + 1
WHERE tweet_id = NEW.comment_tweet_fk
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `followers`
--

CREATE TABLE `followers` (
  `user_fk_follower` bigint(20) UNSIGNED NOT NULL,
  `user_fk_followed` bigint(20) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `followers`
--

INSERT INTO `followers` (`user_fk_follower`, `user_fk_followed`) VALUES
(8, 5),
(5, 8);

--
-- Triggers `followers`
--
DELIMITER $$
CREATE TRIGGER `decrease_total_followers` AFTER DELETE ON `followers` FOR EACH ROW UPDATE users
SET user_total_followers = user_total_followers - 1
WHERE user_id = OLD.user_fk_followed
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `increment_total_followers` AFTER INSERT ON `followers` FOR EACH ROW UPDATE users
SET user_total_followers = user_total_followers + 1
WHERE user_id = NEW.user_fk_followed
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `hashtags`
--

CREATE TABLE `hashtags` (
  `hashtag_id` bigint(20) UNSIGNED NOT NULL,
  `hashtag_name` varchar(140) COLLATE utf8mb4_unicode_ci NOT NULL,
  `hashtag_total_used` int(10) UNSIGNED NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `hashtags`
--

INSERT INTO `hashtags` (`hashtag_id`, `hashtag_name`, `hashtag_total_used`) VALUES
(1, '#supernatural', 2),
(2, '#spn', 0);

-- --------------------------------------------------------

--
-- Table structure for table `lists`
--

CREATE TABLE `lists` (
  `list_id` bigint(20) UNSIGNED NOT NULL,
  `list_user_fk` bigint(20) UNSIGNED NOT NULL,
  `list_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `list_total_members` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `list_total_followers` int(10) UNSIGNED NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `lists`
--

INSERT INTO `lists` (`list_id`, `list_user_fk`, `list_name`, `list_total_members`, `list_total_followers`) VALUES
(3, 5, 'Supernatural', 5, 1),
(4, 8, 'Politics', 2, 0);

-- --------------------------------------------------------

--
-- Table structure for table `list_followers`
--

CREATE TABLE `list_followers` (
  `user_fk_list_follower` bigint(20) UNSIGNED NOT NULL,
  `list_fk_followed` bigint(20) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Triggers `list_followers`
--
DELIMITER $$
CREATE TRIGGER `decrease_total_list_followers` AFTER DELETE ON `list_followers` FOR EACH ROW UPDATE lists
SET list_total_followers = list_total_followers - 1
WHERE list_id = OLD.list_fk_followed
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `increment_total_list_followers` AFTER INSERT ON `list_followers` FOR EACH ROW UPDATE lists
SET list_total_followers = list_total_followers + 1
WHERE list_id = NEW.list_fk_followed
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `list_members`
--

CREATE TABLE `list_members` (
  `list_member_user_fk` bigint(20) UNSIGNED NOT NULL,
  `list_member_list_fk` bigint(20) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `list_members`
--

INSERT INTO `list_members` (`list_member_user_fk`, `list_member_list_fk`) VALUES
(10, 3),
(11, 3),
(12, 3),
(13, 3),
(16, 4),
(17, 4);

--
-- Triggers `list_members`
--
DELIMITER $$
CREATE TRIGGER `decrease_total_list_members` AFTER DELETE ON `list_members` FOR EACH ROW UPDATE lists
SET list_total_members = list_total_members - 1
WHERE list_id = OLD.list_member_list_fk
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `increment_total_list_members` AFTER INSERT ON `list_members` FOR EACH ROW UPDATE lists
SET list_total_members = list_total_members + 1
WHERE list_id = NEW.list_member_list_fk
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `messages`
--

CREATE TABLE `messages` (
  `message_id` bigint(20) UNSIGNED NOT NULL,
  `message_text` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `message_user_fk` bigint(20) UNSIGNED NOT NULL,
  `chat_room_fk` bigint(20) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `retweets`
--

CREATE TABLE `retweets` (
  `retweet_id` bigint(20) UNSIGNED NOT NULL,
  `retweet_user_fk` bigint(20) UNSIGNED NOT NULL,
  `retweet_tweet_fk` bigint(20) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Triggers `retweets`
--
DELIMITER $$
CREATE TRIGGER `decrease_total_retweets` AFTER DELETE ON `retweets` FOR EACH ROW UPDATE tweets 
SET tweet_total_retweets = tweet_total_retweets - 1
WHERE tweet_id = OLD.retweet_tweet_fk
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `increment_total_retweets` AFTER INSERT ON `retweets` FOR EACH ROW UPDATE tweets 
SET tweet_total_retweets = tweet_total_retweets + 1
WHERE tweet_id = NEW.retweet_tweet_fk
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `tweets`
--

CREATE TABLE `tweets` (
  `tweet_id` bigint(20) UNSIGNED NOT NULL,
  `tweet_user_fk` bigint(20) UNSIGNED NOT NULL,
  `tweet_message` varchar(140) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tweet_created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `tweet_active` tinyint(1) NOT NULL DEFAULT '1',
  `tweet_image_path` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tweet_total_likes` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `tweet_total_comments` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `tweet_total_retweets` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `tweet_total_bookmarks` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `tweets`
--

INSERT INTO `tweets` (`tweet_id`, `tweet_user_fk`, `tweet_message`, `tweet_created`, `tweet_active`, `tweet_image_path`, `tweet_total_likes`, `tweet_total_comments`, `tweet_total_retweets`, `tweet_total_bookmarks`) VALUES
(1, 5, 'hello from sql again', '2020-12-14 12:39:50', 1, '', 0, 2, 0, 0),
(2, 5, 'Hello again from michell', '2020-12-04 22:02:35', 1, '../images/tinka-profile.png', 0, 0, 0, 0),
(3, 5, 'Hello again from michell without image', '2020-12-04 22:03:49', 1, '', 0, 0, 0, 0),
(5, 5, 'testing', '2020-12-06 18:59:32', 1, '', 0, 0, 0, 0),
(6, 5, '12345456456', '2020-12-11 21:29:05', 1, '', 0, 1, 0, 0),
(9, 5, 'hello again', '2020-12-04 22:46:51', 1, '', 0, 0, 0, 0),
(64, 8, 'Hello from Andreas', '2020-12-11 21:15:08', 1, '', 0, 0, 0, 0),
(66, 8, 'hello testing create', '2020-12-11 21:47:44', 1, '', 0, 0, 0, 0),
(67, 8, 'testing creation again', '2020-12-11 21:49:06', 1, '', 0, 0, 0, 0),
(80, 10, 'Hi from Briana', '2020-12-15 23:49:34', 1, '', 0, 0, 0, 0),
(81, 12, 'Hi from Jensen', '2020-12-14 12:14:11', 1, '', 0, 0, 0, 0),
(82, 16, 'I WON!', '2020-12-14 12:22:20', 1, '', 0, 0, 0, 0),
(83, 17, 'Hi I won\'t admit I lost', '2020-12-14 12:32:00', 1, '', 0, 0, 0, 0),
(84, 8, 'testing creation', '2020-12-16 00:42:18', 1, '', 1, 0, 0, 0);

--
-- Triggers `tweets`
--
DELIMITER $$
CREATE TRIGGER `decrease_total_tweets` AFTER DELETE ON `tweets` FOR EACH ROW UPDATE users
SET user_total_tweets = user_total_tweets - 1
WHERE user_id = OLD.tweet_user_fk
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `increment_total_tweets` AFTER INSERT ON `tweets` FOR EACH ROW UPDATE users 
SET user_total_tweets = user_total_tweets + 1
WHERE user_id = NEW.tweet_user_fk
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `tweet_hashtags`
--

CREATE TABLE `tweet_hashtags` (
  `tweet_hashtag_hashtag_fk` bigint(20) UNSIGNED NOT NULL,
  `tweet_hashtag_tweet_fk` bigint(20) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `tweet_hashtags`
--

INSERT INTO `tweet_hashtags` (`tweet_hashtag_hashtag_fk`, `tweet_hashtag_tweet_fk`) VALUES
(1, 80),
(1, 81);

--
-- Triggers `tweet_hashtags`
--
DELIMITER $$
CREATE TRIGGER `decrease_total_hashtags_used` AFTER DELETE ON `tweet_hashtags` FOR EACH ROW UPDATE hashtags
SET hashtag_total_used = hashtag_total_used - 1
WHERE hashtag_id = OLD.tweet_hashtag_hashtag_fk
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `increment_total_hashtag_used` AFTER INSERT ON `tweet_hashtags` FOR EACH ROW UPDATE hashtags
SET hashtag_total_used = hashtag_total_used + 1
WHERE hashtag_id = NEW.tweet_hashtag_hashtag_fk
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `user_name` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_last_name` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_profile_name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_image_path` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `user_active` tinyint(1) NOT NULL DEFAULT '0',
  `user_verification_code` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_total_tweets` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `user_total_followers` int(10) UNSIGNED NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `user_name`, `user_last_name`, `user_profile_name`, `user_email`, `user_password`, `user_image_path`, `user_created`, `user_active`, `user_verification_code`, `user_total_tweets`, `user_total_followers`) VALUES
(5, 'michell', 'dranig', 'MichellDranig', 'mi@mi.com', '$2y$10$2IfKmX4DvxsltFfpiUl2teQ7K.Ego14XCXncV.Ke70/7kiQinYfCO', 'tinka-profile.png', '2020-12-15 23:42:45', 1, 'c0ea9319-ccdf-4e50-b137-ee270f389a0a', 6, 1),
(8, 'Andreas', 'Hansen', 'AndreasOliver', 'andreas@andreas.com', '$2y$10$9a0U9oNTVEJenbNe0OChMOYZWGFx7CaLsIgLbki0/elmi57Q894uS', 'default-image.png', '2020-12-15 18:57:56', 1, '39ca8fc8-19a7-4535-9381-1b07007fa892', 4, 2),
(10, 'Briana', 'Buckmaster', 'BrianaBuckmaster', 'bri@bri.com', '$2y$10$EqubtBKWRoxcjxQ/dM.FTeGDso9buSl9fcqbk6XTD7w9s4M116Rje', 'default-image.png', '2020-12-14 12:14:11', 1, 'd9af4388-884d-454b-98f6-a24f3e0d50ae', 1, 0),
(11, 'Kim', 'Rhodes', 'KimRhodes', 'kim@kim.com', '$2y$10$rPXoLf4/BVWfUIEo9jcNIeDmqqMscykNkM/Oo8vB5CoFUGqqzKWTO', 'default-image.png', '2020-12-14 10:44:58', 1, '67665e8d-ebf8-4940-990f-08de0f7c8c9a', 0, 0),
(12, 'Jensen', 'Ackles', 'JensenAckles', 'jen@jen.com', '$2y$10$lW3RkBGg.cG20W9qdYeFd.R.7lRctsN5ojDeTJT3yYLLH3.pAnC7C', 'default-image.png', '2020-12-14 12:14:11', 1, '4cb5af81-59a8-4104-bcaa-7667f5000f00', 1, 0),
(13, 'Jared', 'Padalecki', 'JaredPadalecki', 'jar@jar.com', '$2y$10$yFHanx29mtdpeixXmgT8yuc0OxYaQWAu3NbZ7pC.wQkNxUN7tVTjy', 'default-image.png', '2020-12-14 10:45:40', 1, 'a8c54af2-00eb-4001-89e1-7e727a77004f', 0, 0),
(16, 'Joe', 'Biden', 'JoeBiden', 'joe@joe.com', 'fjkewln', 'default-image.png', '2020-12-15 18:57:04', 1, 'jglwrg', 1, 0),
(17, 'Donald', 'Trump', 'DonaldTrump', 'donald@trump.com', 'jfkewlfn', 'default-image.png', '2020-12-15 18:57:07', 1, 'wkdlwqd', 1, 0),
(20, 'Michell', 'Dranig', 'MichellDranig', 'michell@michell.com', '$2y$10$SDYCBaPdYWEVt3tOZJEL7uQvQLkWLUZhtXX/n/67pN7wp5uDwkZ/C', 'default-image.png', '2020-12-16 00:21:37', 1, '1b9b2f0d-9186-4672-bfa2-bdc59510e198', 0, 0);

-- --------------------------------------------------------

--
-- Stand-in structure for view `view_comments_on_tweet`
-- (See below for the actual view)
--
CREATE TABLE `view_comments_on_tweet` (
`tweet_message` varchar(140)
,`comment_tweet_fk` bigint(20) unsigned
,`comment_user_fk` bigint(20) unsigned
,`comment_id` bigint(20) unsigned
,`comment_message` varchar(140)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `view_users_comments`
-- (See below for the actual view)
--
CREATE TABLE `view_users_comments` (
`comment_id` bigint(20) unsigned
,`comment_tweet_fk` bigint(20) unsigned
,`comment_user_fk` bigint(20) unsigned
,`comment_message` varchar(140)
,`tweet_id` bigint(20) unsigned
,`tweet_message` varchar(140)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `view_users_tweets`
-- (See below for the actual view)
--
CREATE TABLE `view_users_tweets` (
`tweet_id` bigint(20) unsigned
,`tweet_message` varchar(140)
,`tweet_user_fk` bigint(20) unsigned
,`user_name` varchar(30)
);

-- --------------------------------------------------------

--
-- Structure for view `view_comments_on_tweet`
--
DROP TABLE IF EXISTS `view_comments_on_tweet`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_comments_on_tweet`  AS  select `tweets`.`tweet_message` AS `tweet_message`,`comments`.`comment_tweet_fk` AS `comment_tweet_fk`,`comments`.`comment_user_fk` AS `comment_user_fk`,`comments`.`comment_id` AS `comment_id`,`comments`.`comment_message` AS `comment_message` from (`tweets` join `comments`) where (`comments`.`comment_tweet_fk` = `tweets`.`tweet_id`) ;

-- --------------------------------------------------------

--
-- Structure for view `view_users_comments`
--
DROP TABLE IF EXISTS `view_users_comments`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_users_comments`  AS  select `comments`.`comment_id` AS `comment_id`,`comments`.`comment_tweet_fk` AS `comment_tweet_fk`,`comments`.`comment_user_fk` AS `comment_user_fk`,`comments`.`comment_message` AS `comment_message`,`tweets`.`tweet_id` AS `tweet_id`,`tweets`.`tweet_message` AS `tweet_message` from (`comments` join `tweets`) where (`comments`.`comment_tweet_fk` = `tweets`.`tweet_id`) ;

-- --------------------------------------------------------

--
-- Structure for view `view_users_tweets`
--
DROP TABLE IF EXISTS `view_users_tweets`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_users_tweets`  AS  select `tweets`.`tweet_id` AS `tweet_id`,`tweets`.`tweet_message` AS `tweet_message`,`tweets`.`tweet_user_fk` AS `tweet_user_fk`,`users`.`user_name` AS `user_name` from (`tweets` join `users`) where (`tweets`.`tweet_user_fk` = `users`.`user_id`) ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `bookmarks`
--
ALTER TABLE `bookmarks`
  ADD PRIMARY KEY (`bookmark_id`),
  ADD UNIQUE KEY `bookmark_id` (`bookmark_id`),
  ADD KEY `delete_user_fk_bookmark` (`bookmark_user_fk`),
  ADD KEY `delete_tweet_fk_bookmark` (`bookmark_tweet_fk`);

--
-- Indexes for table `chat_rooms`
--
ALTER TABLE `chat_rooms`
  ADD PRIMARY KEY (`chat_room_id`),
  ADD UNIQUE KEY `chat_room_id` (`chat_room_id`);

--
-- Indexes for table `chat_room_members`
--
ALTER TABLE `chat_room_members`
  ADD KEY `delete_user_fk_chat_room` (`chat_room_user_fk`),
  ADD KEY `delete_chat_room_fk` (`chat_room_fk`);

--
-- Indexes for table `comments`
--
ALTER TABLE `comments`
  ADD PRIMARY KEY (`comment_id`),
  ADD UNIQUE KEY `comment_id` (`comment_id`),
  ADD KEY `delete_tweet_fk` (`comment_tweet_fk`),
  ADD KEY `delete_user_fk_comments` (`comment_user_fk`);

--
-- Indexes for table `followers`
--
ALTER TABLE `followers`
  ADD PRIMARY KEY (`user_fk_follower`,`user_fk_followed`),
  ADD KEY `delete_user_fk_followed` (`user_fk_followed`);

--
-- Indexes for table `hashtags`
--
ALTER TABLE `hashtags`
  ADD PRIMARY KEY (`hashtag_id`),
  ADD UNIQUE KEY `hashtag_id` (`hashtag_id`),
  ADD KEY `hashtag_name` (`hashtag_name`);

--
-- Indexes for table `lists`
--
ALTER TABLE `lists`
  ADD PRIMARY KEY (`list_id`),
  ADD UNIQUE KEY `list_id` (`list_id`),
  ADD KEY `delete_user_fk_list` (`list_user_fk`),
  ADD KEY `list_name` (`list_name`);

--
-- Indexes for table `list_followers`
--
ALTER TABLE `list_followers`
  ADD PRIMARY KEY (`user_fk_list_follower`,`list_fk_followed`),
  ADD KEY `delete_list_fk_followed` (`list_fk_followed`);

--
-- Indexes for table `list_members`
--
ALTER TABLE `list_members`
  ADD PRIMARY KEY (`list_member_user_fk`,`list_member_list_fk`),
  ADD KEY `delete_list_fk` (`list_member_list_fk`);

--
-- Indexes for table `messages`
--
ALTER TABLE `messages`
  ADD PRIMARY KEY (`message_id`),
  ADD UNIQUE KEY `message_id` (`message_id`),
  ADD KEY `delete_chat_room_fk_message` (`chat_room_fk`),
  ADD KEY `delete_user_fk_messages` (`message_user_fk`);

--
-- Indexes for table `retweets`
--
ALTER TABLE `retweets`
  ADD PRIMARY KEY (`retweet_id`),
  ADD UNIQUE KEY `retweet_id` (`retweet_id`),
  ADD KEY `delete_user_fk_retweet` (`retweet_user_fk`),
  ADD KEY `delete_tweet_fk_retweet` (`retweet_tweet_fk`);

--
-- Indexes for table `tweets`
--
ALTER TABLE `tweets`
  ADD PRIMARY KEY (`tweet_id`),
  ADD UNIQUE KEY `tweet_id` (`tweet_id`),
  ADD KEY `delete_user_fk` (`tweet_user_fk`);

--
-- Indexes for table `tweet_hashtags`
--
ALTER TABLE `tweet_hashtags`
  ADD PRIMARY KEY (`tweet_hashtag_hashtag_fk`,`tweet_hashtag_tweet_fk`),
  ADD KEY `delete_tweet_fk_hashtag` (`tweet_hashtag_tweet_fk`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `user_id` (`user_id`),
  ADD UNIQUE KEY `user_email` (`user_email`),
  ADD KEY `user_name` (`user_name`),
  ADD KEY `user_profile_name` (`user_profile_name`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `bookmarks`
--
ALTER TABLE `bookmarks`
  MODIFY `bookmark_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `chat_rooms`
--
ALTER TABLE `chat_rooms`
  MODIFY `chat_room_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `comments`
--
ALTER TABLE `comments`
  MODIFY `comment_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `hashtags`
--
ALTER TABLE `hashtags`
  MODIFY `hashtag_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `lists`
--
ALTER TABLE `lists`
  MODIFY `list_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `messages`
--
ALTER TABLE `messages`
  MODIFY `message_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `retweets`
--
ALTER TABLE `retweets`
  MODIFY `retweet_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tweets`
--
ALTER TABLE `tweets`
  MODIFY `tweet_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=85;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `bookmarks`
--
ALTER TABLE `bookmarks`
  ADD CONSTRAINT `delete_tweet_fk_bookmark` FOREIGN KEY (`bookmark_tweet_fk`) REFERENCES `tweets` (`tweet_id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  ADD CONSTRAINT `delete_user_fk_bookmark` FOREIGN KEY (`bookmark_user_fk`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE NO ACTION;

--
-- Constraints for table `chat_room_members`
--
ALTER TABLE `chat_room_members`
  ADD CONSTRAINT `delete_chat_room_fk` FOREIGN KEY (`chat_room_fk`) REFERENCES `chat_rooms` (`chat_room_id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  ADD CONSTRAINT `delete_user_fk_chat_room` FOREIGN KEY (`chat_room_user_fk`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE NO ACTION;

--
-- Constraints for table `comments`
--
ALTER TABLE `comments`
  ADD CONSTRAINT `delete_tweet_fk` FOREIGN KEY (`comment_tweet_fk`) REFERENCES `tweets` (`tweet_id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  ADD CONSTRAINT `delete_user_fk_comments` FOREIGN KEY (`comment_user_fk`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE NO ACTION;

--
-- Constraints for table `followers`
--
ALTER TABLE `followers`
  ADD CONSTRAINT `delete_user_fk_followed` FOREIGN KEY (`user_fk_followed`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  ADD CONSTRAINT `delete_user_fk_follower` FOREIGN KEY (`user_fk_follower`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE NO ACTION;

--
-- Constraints for table `lists`
--
ALTER TABLE `lists`
  ADD CONSTRAINT `delete_user_fk_list` FOREIGN KEY (`list_user_fk`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE NO ACTION;

--
-- Constraints for table `list_followers`
--
ALTER TABLE `list_followers`
  ADD CONSTRAINT `delete_list_fk_followed` FOREIGN KEY (`list_fk_followed`) REFERENCES `lists` (`list_id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  ADD CONSTRAINT `delete_user_fk_list_follower` FOREIGN KEY (`user_fk_list_follower`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE NO ACTION;

--
-- Constraints for table `list_members`
--
ALTER TABLE `list_members`
  ADD CONSTRAINT `delete_list_fk` FOREIGN KEY (`list_member_list_fk`) REFERENCES `lists` (`list_id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  ADD CONSTRAINT `delete_user_fk_list_member` FOREIGN KEY (`list_member_user_fk`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE NO ACTION;

--
-- Constraints for table `messages`
--
ALTER TABLE `messages`
  ADD CONSTRAINT `delete_chat_room_fk_message` FOREIGN KEY (`chat_room_fk`) REFERENCES `chat_rooms` (`chat_room_id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  ADD CONSTRAINT `delete_user_fk_messages` FOREIGN KEY (`message_user_fk`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE NO ACTION;

--
-- Constraints for table `retweets`
--
ALTER TABLE `retweets`
  ADD CONSTRAINT `delete_tweet_fk_retweet` FOREIGN KEY (`retweet_tweet_fk`) REFERENCES `tweets` (`tweet_id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  ADD CONSTRAINT `delete_user_fk_retweet` FOREIGN KEY (`retweet_user_fk`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE NO ACTION;

--
-- Constraints for table `tweets`
--
ALTER TABLE `tweets`
  ADD CONSTRAINT `delete_user_fk` FOREIGN KEY (`tweet_user_fk`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE NO ACTION;

--
-- Constraints for table `tweet_hashtags`
--
ALTER TABLE `tweet_hashtags`
  ADD CONSTRAINT `delete_hashtag_fk` FOREIGN KEY (`tweet_hashtag_hashtag_fk`) REFERENCES `hashtags` (`hashtag_id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  ADD CONSTRAINT `delete_tweet_fk_hashtag` FOREIGN KEY (`tweet_hashtag_tweet_fk`) REFERENCES `tweets` (`tweet_id`) ON DELETE CASCADE ON UPDATE NO ACTION;