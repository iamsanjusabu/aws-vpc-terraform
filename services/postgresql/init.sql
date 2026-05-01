CREATE EXTENSION IF NOT EXISTS citext;

CREATE TABLE user_table (
    id       BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    username CITEXT NOT NULL,
    email    CITEXT NOT NULL,
    CONSTRAINT unique_name UNIQUE(username, email)
);

INSERT INTO user_table(username, email) VALUES('sanjusabu', 'sanjusabu@icloud.com') ON CONFLICT (username, email) DO NOTHING;