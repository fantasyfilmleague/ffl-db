CREATE TABLE users
(
  id SERIAL NOT NULL UNIQUE,
  email VARCHAR(100) NOT NULL UNIQUE,
  password VARCHAR(100) NOT NULL,
  is_verified BOOLEAN NOT NULL DEFAULT FALSE,
  is_deleted BOOLEAN NOT NULL DEFAULT FALSE,
  created_at TIMESTAMPTZ NOT NULL,
  updated_at TIMESTAMPTZ,
  PRIMARY KEY (id)
);

CREATE INDEX users_email_idx ON users (email);

CREATE TABLE leagues
(
  id SERIAL NOT NULL UNIQUE,
  founder_id INT NOT NULL REFERENCES users,
  name TEXT NOT NULL,
  is_deleted BOOLEAN NOT NULL DEFAULT FALSE,
  created_at TIMESTAMPTZ NOT NULL,
  updated_at TIMESTAMPTZ,
  PRIMARY KEY (id)
);

CREATE TABLE members
(
  id SERIAL NOT NULL UNIQUE,
  user_id INT NOT NULL REFERENCES users,
  league_id INT NOT NULL REFERENCES leagues,
  is_commissioner BOOLEAN NOT NULL DEFAULT FALSE,
  created_at TIMESTAMPTZ NOT NULL,
  updated_at TIMESTAMPTZ,
  PRIMARY KEY (id)
);

ALTER TABLE members ADD UNIQUE (user_id, league_id);

ALTER TABLE members ADD UNIQUE (league_id, is_commissioner);

CREATE TABLE seasons
(
  id SERIAL NOT NULL UNIQUE,
  league_id INT NOT NULL REFERENCES leagues,
  starts_at TIMESTAMPTZ NOT NULL,
  ends_at TIMESTAMPTZ NOT NULL,
  created_at TIMESTAMPTZ NOT NULL,
  updated_at TIMESTAMPTZ,
  PRIMARY KEY (id)
);

CREATE TABLE teams
(
  id SERIAL NOT NULL UNIQUE,
  member_id INT NOT NULL REFERENCES members,
  season_id INT NOT NULL REFERENCES seasons,
  name TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL,
  updated_at TIMESTAMPTZ,
  PRIMARY KEY (id)
);

ALTER TABLE teams ADD UNIQUE (member_id, season_id);

CREATE TABLE actors
(
  id SERIAL NOT NULL UNIQUE,
  name TEXT NOT NULL UNIQUE,
  created_at TIMESTAMPTZ NOT NULL,
  updated_at TIMESTAMPTZ,
  PRIMARY KEY (id)
);

CREATE INDEX actors_name_idx ON actors (name);

CREATE TABLE films
(
  id SERIAL NOT NULL UNIQUE,
  title TEXT NOT NULL,
  released_at DATE NOT NULL,
  created_at TIMESTAMPTZ NOT NULL,
  updated_at TIMESTAMPTZ,
  PRIMARY KEY (id)
);

ALTER TABLE films ADD UNIQUE (title, released_at);

CREATE INDEX films_title_idx ON films (title);

CREATE INDEX films_release_at_idx ON films (released_at);

CREATE TABLE casts
(
  id SERIAL NOT NULL UNIQUE,
  film_id INT NOT NULL REFERENCES films,
  actor_id INT NOT NULL REFERENCES actors,
  created_at TIMESTAMPTZ NOT NULL,
  updated_at TIMESTAMPTZ,
  PRIMARY KEY (id)
);

ALTER TABLE casts ADD UNIQUE (film_id, actor_id);

CREATE TABLE daily_film_grosses
(
  id SERIAL NOT NULL UNIQUE,
  film_id INT NOT NULL REFERENCES films,
  gross INT NOT NULL,
  date_at DATE NOT NULL,
  created_at TIMESTAMPTZ NOT NULL,
  updated_at TIMESTAMPTZ,
  PRIMARY KEY (id)
);

ALTER TABLE daily_film_grosses ADD UNIQUE (film_id, date_at);

CREATE INDEX daily_film_grosses_gross_idx ON daily_film_grosses (gross);

CREATE INDEX daily_film_grosses_date_at_idx ON daily_film_grosses (date_at);
