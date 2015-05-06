DROP TABLE question_follows;
DROP TABLE question_likes;
DROP TABLE replies;
DROP TABLE questions;
DROP TABLE users;   -- users dropped last; doesn't reference prev questions

.headers on
.mode column

CREATE TABLE users (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL
);

CREATE TABLE questions (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  title VARCHAR(255) NOT NULL,
  body TEXT NOT NULL,
  user_id INTEGER REFERENCES users(id) NOT NULL   --user id for author
);

--Join table (many to many relationship btwn. users and questions)

CREATE TABLE question_follows (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  question_id INTEGER REFERENCES questions(id) NOT NULL,
  user_id INTEGER REFERENCES users(id) NOT NULL   --user id for follower
);

CREATE TABLE replies(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  question_id INTEGER REFERENCES questions(id) NOT NULL,
  reply_id INTEGER REFERENCES replies(id),  -- self reference to parent reply
  user_id INTEGER REFERENCES users(id) NOT NULL,

  body TEXT NOT NULL
);

CREATE TABLE question_likes(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER REFERENCES users(id) NOT NULL,
  question_id INTEGER REFERENCES questions(id) NOT NULL
);

INSERT INTO
  users (fname, lname)
  VALUES
  ('Caius', 'Loica-Mersa'),
  ('Mark', 'Azemoon'),
  ('Jane', 'Doe'),
  ('Kim', 'Kardashian'),
  ('Ringo', 'Starr'),
  ('Douglas', 'Adams');

INSERT INTO
  questions(title, body, user_id)
  VALUES
  ('Meaning of life', 'What is the answer to the question of life, the universe and everything?', 1),
  ('TAs on the weekend', 'Why don''t we have access to TAs on the weekend?', 2),
  ('Carats in Ruby', 'How many carats are in Ruby 2.1.2?', 4),
  ('Chicken of the Sea', 'Is chicken of the sea TUNA or CHICKEN???', 4);

INSERT INTO
  question_follows(question_id, user_id)
  VALUES
  (1, 1), (1, 3), (1, 5), (2, 1), (2, 4), (3, 2);

INSERT INTO
  replies (question_id, reply_id, user_id, body)
  VALUES
  (2, NULL, 6, 'That''s an excellent point, Mark! We should have them on the weekends.'),
  (1, NULL, 6, '42'),
  (2, 1, 1, 'I concur.');

INSERT INTO
  question_likes (user_id, question_id)
  VALUES
  (1, 2), (1, 3), (6, 1), (4, 3);

-- SELECT *
--   FROM users;
--
-- SELECT *
--   FROM questions;
--
-- SELECT *
--   FROM replies;
--
-- SELECT *
--   FROM question_follows
--   WHERE user_id IN (1, 2);
