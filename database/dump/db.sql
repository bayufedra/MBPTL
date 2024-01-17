# drop database bookstore;
# drop database administrator;
# create databases

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


-- Create a database (if not exists)
CREATE DATABASE IF NOT EXISTS `administrator`;

USE administrator;
CREATE TABLE `users` (
  `id` int(30) NOT NULL AUTO_INCREMENT,
  `username` varchar(32) NOT NULL,
  `password` varchar(32) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

INSERT INTO `users` (`id`, `username`, `password`) VALUES
  (1, 'admin', 'b9f385c68320e27d5a4ea0618eef4a94');

ALTER TABLE `users` ADD UNIQUE KEY `username` (`username`);



-- Create a database (if not exists)
CREATE DATABASE IF NOT EXISTS `bookstore`;

USE bookstore;
CREATE TABLE IF NOT EXISTS books (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    author VARCHAR(255) NOT NULL,
    image VARCHAR(255) DEFAULT NULL,
    description TEXT DEFAULT NULL
);

INSERT INTO books (title, author, image, description) VALUES 
  ('Howl''s Moving Castle', 'Diana Wynne Jones', 'howls_moving_castle.jpg', 'Howl''s Moving Castle is a captivating fantasy novel written by Diana Wynne Jones. It serves as the inspiration for the renowned Studio Ghibli animated film directed by Hayao Miyazaki. The story follows the adventures of Sophie, a young woman cursed by a witch and transformed into an elderly lady. She seeks refuge in the magical moving castle owned by the eccentric wizard Howl. As Sophie and Howl navigate a world filled with enchantment and turmoil, they discover the power of love, friendship, and self-acceptance.'),
  ('Spirited Away', 'Hayao Miyazaki', 'spirited_away.jpg', 'Spirited Away is the novel adaptation of the Studio Ghibli masterpiece, written by the acclaimed filmmaker Hayao Miyazaki. Dive into the enchanting tale of Chihiro, a young girl who finds herself trapped in a mysterious and magical world. As she navigates through challenges and encounters fascinating characters, Chihiro embarks on a transformative journey of self-discovery and courage. The novel delves deeper into the rich narrative and themes that have made Spirited Away a timeless classic.'),
  ('My Neighbor Totoro', 'Hayao Miyazaki', 'my_neighbor_totoro.jpg', 'My Neighbor Totoro, based on the beloved Studio Ghibli film, is a heartwarming children''s book written by Hayao Miyazaki. Join the delightful adventures of two sisters, Satsuke and Mei, as they move to the countryside and befriend the lovable forest spirit Totoro. This enchanting tale captures the magic of childhood and the wonders of the natural world. The novel provides a closer look at the endearing characters and the whimsical world of Totoro.'),
  ('Princess Mononoke', 'Hayao Miyazaki', 'princess_mononoke.jpg', 'Princess Mononoke, written by Hayao Miyazaki, is the novel adaptation of the Studio Ghibli film exploring the struggle between industrialization and nature. Set in a mystical world filled with forest spirits and ancient gods, the story follows the journey of Ashitaka, a young warrior who becomes embroiled in a conflict between the forces of nature and humanity. The novel offers a deeper exploration of the characters and the complex themes that define Princess Mononoke.'),
  ('Kiki''s Delivery Service', 'Eiko Kadono', 'kikis_delivery_service.jpg', 'Kiki''s Delivery Service, based on the novel by Eiko Kadono, is a heartwarming tale of a young witch and her adventures in a new town. Join Kiki as she discovers her unique abilities and opens a delivery service. The novel, adapted from the Studio Ghibli film, provides additional insights into Kiki''s coming-of-age journey, friendships, and the magic that exists within everyday life.'),
  ('The Secret World of Arrietty', 'Mary Norton', 'the_secret_world_of_arrietty.jpg', 'The Secret World of Arrietty is a novel based on "The Borrowers" by Mary Norton. The story follows Arrietty, a tiny person who lives under the floorboards and "borrows" from the human beans. As Arrietty befriends a human boy named Sho, they embark on a heartwarming adventure that bridges the gap between their two worlds. The novel provides a detailed exploration of Arrietty''s miniature world and the challenges she faces.'),
  ('Castle in the Sky', 'Hayao Miyazaki', 'castle_in_the_sky.jpg', 'Castle in the Sky is the novel adaptation of the Studio Ghibli film that follows the adventures of Pazu and Sheeta as they search for the floating island of Laputa. Filled with airships, ancient technology, and a quest for discovery, the story captures the essence of wonder and excitement. The novel offers additional perspectives on the characters'' backgrounds and the magical world they inhabit.'),
  ('Whisper of the Heart', 'Aoi Hiiragi', 'whisper_of_the_heart.jpg', 'Whisper of the Heart, written by Aoi Hiiragi, is a novel adaptation of the Studio Ghibli film about a young girl named Shizuku who discovers her passion for writing. As Shizuku explores her dreams and aspirations, she encounters new friendships and embarks on a journey of self-discovery. The novel delves into the intricacies of Shizuku''s creative process and the inspiration she finds in the everyday world around her.');
