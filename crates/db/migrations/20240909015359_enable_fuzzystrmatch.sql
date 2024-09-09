-- migrate:up
CREATE EXTENSION IF NOT EXISTS fuzzystrmatch;

-- migrate:down
DROP EXTENSION IF EXISTS fuzzystrmatch;
