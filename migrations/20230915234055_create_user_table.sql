-- +goose Up
-- +goose StatementBegin
CREATE Type PersonType AS ENUM ("LEGAL", "REAL")
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE TABLE IF NOT EXISTS Persons (
    id UUID DEFAULT uuid_generate_v4() NOT NULL,
    fist_name VARCHAR(32) NOT NULL,
    last_name VARCHAR(32) NOT NULL,
    person_type PersonType NOT NULL DEFAULT PersonType.LEGAL
    fk_account UUID NOT NULL,
    PRIMARY KEY(id)
    CONSTRAINT fk_account
        FOREIGN KEY (fk_account) REFERENCES Accounts(ids)
);

CREATE TABLE IF NOT EXISTS Accounts (
    id BIGSERIAL PRIMARY KEY NOT NULL,
    password BYTEA NOT NULL,
    user_name VARCHAR(64),


);
create TYPE IF NOT EXISTS ResourceType AS ENUM ("IMAGE" "DOCUMENT");
CREATE TABLE IF NOT EXISTS Resources (
    id BIGSERIAL NOT NULL PRIMARY KEY,
    resource_type ResourceType DEFAULT "IMAGE"
    source TEXT NOT NULL,
    alt TEXT,
    description TEXT
)
CREATE TABLE IF NOT EXISTS Profiles (
    id UUID DEFAULT uuid_generate_v4() NOT NULL,
    fk_profile_photo BIGSERIAL NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT fk_profile_photo 
        FOREIGN KEY(fk_profile_photo) REFERENCES Resources(id)
);

CREATE TABLE IF NOT EXISTS JK_Friends (
    id BIGSERIAL PRIMARY KEY NOT NULL,
    fk_user_profile UUID NOT NULL,
    fk_friend_profile UUID NOT NULL,
    CONSTRAINT fk_user_profile 
        FOREIGN KEY(fk_user_profile)
        REFERENCES Profiles(id) 
        ON DELETE NO ACTION,
    CONSTRAINT fk_friend_profile
        FOREIGN KEY(fk_friend_profile)
        REFERENCES Profiles(id)
        ON DELETE NO ACTION
);
CREATE TABLE IF NOT EXISTS Users (
    id UUID DEFAULT uuid_generate_v4(),
    profile Profile NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT fk_profile
        FOREIGN KEY(profile)
        REFERENCES Profiles(id)
        ON CREATE SET DEFAULT
        ON DELETE CASCADE
);
-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
DROP TABLE IF EXISTS Users;
-- +goose StatementEnd
-- +goose StatementBegin
DROP EXTENSION IF EXISTS "uuid-ossp";
-- +goose StatementEnd