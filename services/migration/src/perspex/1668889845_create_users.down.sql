-- migrate:down transaction:false

DROP INDEX CONCURRENTLY IF EXISTS users_email_uindex;

DROP INDEX CONCURRENTLY IF EXISTS users_id_uindex;

DROP TABLE IF EXISTS "users";
