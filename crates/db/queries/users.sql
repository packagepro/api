--: User()
--: UserProfile()
--: UserCredentials()

--! get_user: User
SELECT username, is_super_user
FROM users
WHERE users.username = :username;

--! get_user_profile: UserProfile
SELECT username, email, is_super_user
FROM users
WHERE users.username = :username;

--! get_user_credentials: UserCredentials
SELECT username, password_hash
FROM users
WHERE users.username = :username;

--! find_users: User
SELECT username, is_super_user
FROM users
WHERE levenshtein_less_equal(username, :search, 2) <= 2
   OR username ILIKE CONCAT(:search, '%');

--! create_user
INSERT INTO users (username, email, password_hash)
VALUES (:username, :email, :password_hash);

--! update_user
UPDATE users
SET username = :username,
    email    = :email
WHERE users.username = :old_username;

--! update_user_password
UPDATE users
SET password_hash = :password_hash
WHERE users.username = :username;