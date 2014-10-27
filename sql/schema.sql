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

CREATE TABLE leagues
(
  id SERIAL NOT NULL UNIQUE,
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
