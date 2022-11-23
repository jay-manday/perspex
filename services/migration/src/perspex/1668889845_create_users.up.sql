-- migrate:up transaction:false

CREATE TABLE IF NOT EXISTS users (
  id         BIGINT NOT NULL GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  email      TEXT NOT NULL,
  full_name  TEXT NOT NULL,
  first_name TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE UNIQUE INDEX CONCURRENTLY IF NOT EXISTS users_id_uindex
	ON "users" (id);

CREATE UNIQUE INDEX CONCURRENTLY IF NOT EXISTS users_email_uindex
	ON "users" (email);
