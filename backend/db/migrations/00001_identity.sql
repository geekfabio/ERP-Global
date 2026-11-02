-- +goose Up
CREATE TABLE institutions (
 id VARCHAR(26) PRIMARY KEY,
 name TEXT NOT NULL,
 is_active BOOLEAN NOT NULL DEFAULT TRUE,
 created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
 updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
 deleted_at TIMESTAMPTZ
);

CREATE TABLE users (
 id VARCHAR(26) PRIMARY KEY,
 institution_id VARCHAR(26) NOT NULL REFERENCES institutions(id),
 email TEXT NOT NULL,
 password_hash TEXT NOT NULL,
 is_active BOOLEAN NOT NULL DEFAULT TRUE,
 must_change_password BOOLEAN NOT NULL DEFAULT TRUE,
 created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
 updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
 deleted_at TIMESTAMPTZ
);
CREATE UNIQUE INDEX users_institution_email_unique ON users (institution_id, lower(email)) WHERE deleted_at IS NULL;

CREATE TABLE roles (
 id VARCHAR(26) PRIMARY KEY,
 institution_id VARCHAR(26) NOT NULL REFERENCES institutions(id),
 code TEXT NOT NULL,
 name TEXT NOT NULL,
 UNIQUE(institution_id, code),
 UNIQUE(id, institution_id)
);
CREATE TABLE permissions (
 code TEXT PRIMARY KEY,
 description TEXT NOT NULL
);
CREATE TABLE role_permissions (
 role_id VARCHAR(26) NOT NULL REFERENCES roles(id) ON DELETE CASCADE,
 permission_code TEXT NOT NULL REFERENCES permissions(code),
 PRIMARY KEY(role_id, permission_code)
);
CREATE TABLE user_roles (
 user_id VARCHAR(26) NOT NULL REFERENCES users(id) ON DELETE CASCADE,
 role_id VARCHAR(26) NOT NULL REFERENCES roles(id) ON DELETE CASCADE,
 PRIMARY KEY(user_id, role_id)
);

-- +goose Down
DROP TABLE user_roles;
DROP TABLE role_permissions;
DROP TABLE permissions;
DROP TABLE roles;
DROP TABLE users;
DROP TABLE institutions;
