CREATE SCHEMA IF NOT EXISTS Task_Manager;

CREATE TABLE Task_Manager.user_data (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL
);

CREATE TABLE Task_Manager.user_profile (
    user_id INT PRIMARY KEY REFERENCES Task_Manager.user_data(id) ON DELETE CASCADE,
    full_name VARCHAR(100),
    bio TEXT
); 

CREATE TABLE Task_Manager.category (
    id SERIAL PRIMARY KEY,
    title VARCHAR(100) UNIQUE NOT NULL
); 

CREATE TABLE Task_Manager.priority (
    id SERIAL PRIMARY KEY,
    title VARCHAR(50) NOT NULL,
    color VARCHAR(20)
);

CREATE TABLE Task_Manager.task (
    id SERIAL PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    completed BOOLEAN DEFAULT FALSE,
    task_date DATE,
    category_id INT REFERENCES Task_Manager.category(id) ON DELETE SET NULL,
    priority_id INT REFERENCES Task_Manager.priority(id) ON DELETE SET NULL,
    user_id INT REFERENCES Task_Manager.user_data(id) ON DELETE CASCADE
);

CREATE TABLE Task_Manager.subtask (
    id SERIAL PRIMARY KEY,
    task_id INT REFERENCES Task_Manager.task(id) ON DELETE CASCADE,
    title VARCHAR(200) NOT NULL,
    completed BOOLEAN DEFAULT FALSE
);

CREATE TABLE Task_Manager.tag (
    id SERIAL PRIMARY KEY,
    title VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE Task_Manager.task_tag (
    task_id INT REFERENCES Task_Manager.task(id) ON DELETE CASCADE,
    tag_id INT REFERENCES Task_Manager.tag(id) ON DELETE CASCADE,
    PRIMARY KEY (task_id, tag_id)
);

CREATE TABLE Task_Manager.comments (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES Task_Manager.user_data(id) ON DELETE CASCADE,
    text TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Task_Manager.attachment (
    id SERIAL PRIMARY KEY,
    task_id INT REFERENCES Task_Manager.task(id) ON DELETE CASCADE,
    file_path VARCHAR(255) NOT NULL
);