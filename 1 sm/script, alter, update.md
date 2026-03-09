
# ДОМАШНЕЕ ЗАДАНИЕ 2


## Создание Таблицы:






```sql
    CREATE TABLE user_data (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL
);

CREATE TABLE user_profile (
    id SERIAL PRIMARY KEY,
    user_id INT UNIQUE REFERENCES user_data(id) ON DELETE CASCADE,
    full_name VARCHAR(100),
    bio TEXT
);

CREATE TABLE category (
    id SERIAL PRIMARY KEY,
    title VARCHAR(100) NOT NULL
);

CREATE TABLE priority (
    id SERIAL PRIMARY KEY,
    title VARCHAR(50) NOT NULL,
    color VARCHAR(20)
);

CREATE TABLE task (
    id SERIAL PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    completed BOOLEAN DEFAULT FALSE,
    task_date DATE,
    category_id INT REFERENCES category(id) ON DELETE SET NULL,
    priority_id INT REFERENCES priority(id) ON DELETE SET NULL,
    user_id INT REFERENCES user_data(id) ON DELETE CASCADE
);

CREATE TABLE subtask (
    id SERIAL PRIMARY KEY,
    task_id INT REFERENCES task(id) ON DELETE CASCADE,
    title VARCHAR(200) NOT NULL,
    completed BOOLEAN DEFAULT FALSE
);

CREATE TABLE tag (
    id SERIAL PRIMARY KEY,
    title VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE task_tag (
    task_id INT REFERENCES task(id) ON DELETE CASCADE,
    tag_id INT REFERENCES tag(id) ON DELETE CASCADE,
    PRIMARY KEY (task_id, tag_id)
);

CREATE TABLE comment (
    id SERIAL PRIMARY KEY,
    task_id INT REFERENCES task(id) ON DELETE CASCADE,
    user_id INT REFERENCES user_data(id) ON DELETE CASCADE,
    content TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE attachment (
    id SERIAL PRIMARY KEY,
    task_id INT REFERENCES task(id) ON DELETE CASCADE,
    file_path VARCHAR(255) NOT NULL
);
```





## Alter запросы:





```sql
1. Добавим поле "status" в таблицу task
ALTER TABLE task 
ADD COLUMN status VARCHAR(20) DEFAULT 'new';

2. Добавим дату создания профиля
ALTER TABLE user_profile 
ADD COLUMN created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;

3. Изменим размер поля username
ALTER TABLE user_data 
ALTER COLUMN username TYPE VARCHAR(100);

4. Добавим поле description для категории
ALTER TABLE category 
ADD COLUMN description TEXT;

5. Установим NOT NULL для title у тегов
ALTER TABLE tag 
ALTER COLUMN title SET NOT NULL;
```

## Insert-запросы:


```sql
INSERT INTO user_data (username, email, password) VALUES
('alice', 'alice@example.com', 'pass1'),
('bob', 'bob@example.com', 'pass2'),
('charlie', 'charlie@example.com', 'pass3');

INSERT INTO user_profile (user_id, full_name, bio) VALUES
(1, 'Alice Johnson', 'Frontend developer'),
(2, 'Bob Smith', 'Backend developer'),
(3, 'Charlie Brown', 'Project manager');

INSERT INTO category (title, description) VALUES
('Work', 'Tasks related to work'),
('Study', 'Tasks related to study'),
('Personal', 'Personal tasks');

INSERT INTO priority (title, color) VALUES
('High', 'Red'),
('Medium', 'Yellow'),
('Low', 'Green');

INSERT INTO task (title, task_date, category_id, priority_id, user_id) VALUES
('Finish project', '2025-10-01', 1, 1, 1),
('Read book', '2025-10-05', 2, 2, 2),
('Go shopping', '2025-09-30', 3, 3, 3);

INSERT INTO subtask (task_id, title) VALUES
(1, 'Write code'),
(1, 'Test app'),
(2, 'Read chapter 1');

INSERT INTO tag (title) VALUES
('urgent'), ('home'), ('work');

INSERT INTO task_tag (task_id, tag_id) VALUES
(1, 1),
(1, 3),
(3, 2);

INSERT INTO comment (task_id, user_id, content) VALUES
(1, 2, 'Don\'t forget the deadline'),
(2, 3, 'Start with chapter 1'),
(3, 1, 'Buy milk and eggs');

INSERT INTO attachment (task_id, file_path) VALUES
(1, '/files/project_spec.pdf'),
(2, '/files/book.pdf'),
(3, '/files/shopping_list.txt');
```





## UPDATE-запросы:



```sql
UPDATE task 
SET status = 'in progress' 
WHERE id = 1;

UPDATE subtask 
SET completed = TRUE 
WHERE id = 1;

UPDATE user_profile 
SET bio = 'Fullstack developer' 
WHERE user_id = 1;

UPDATE task 
SET priority_id = 2 
WHERE id = 3;

UPDATE category 
SET title = 'Work Tasks' 
WHERE id = 1;
```








