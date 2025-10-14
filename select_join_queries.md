## SELECT
```SELECT * FROM user_data;
SELECT * FROM task;```

## select нескольких столбцов
```SELECT username, email FROM user_data;
SELECT title, completed, task_date FROM task;```

## select с присвоением новых имен столбцам
```SELECT username AS имя_пользователя, email AS почта FROM user_data;
SELECT title AS название_задачи, task_date AS дата FROM task;```

## select с созданием вычисляемого столбца
```SELECT title, task_date, task_date + INTERVAL '7 days' AS deadline_plus_week
FROM task;

SELECT username, LENGTH(password) AS password_length 
FROM user_data;```

## select с логической функцией (CASE)
```SELECT title, completed,
       CASE 
           WHEN completed THEN 'Выполнена'
           ELSE 'Не выполнена'
       END AS статус
FROM task;

SELECT title, color,
       CASE 
           WHEN color = 'red' THEN 'Высокий приоритет'
           WHEN color = 'yellow' THEN 'Средний приоритет'
           ELSE 'Низкий приоритет'
       END AS уровень_приоритета
FROM priority;```

## select с условием
```SELECT * FROM task WHERE completed = FALSE;
SELECT username, email FROM user_data WHERE email LIKE '%@gmail.com';```

## select с OR, AND, BETWEEN, IN
```SELECT * FROM task 
WHERE completed = FALSE 
  AND (task_date BETWEEN '2025-01-01' AND '2025-12-31');

SELECT * FROM priority 
   WHERE title IN ('Высокий', 'Средний', 'Низкий') 
   OR color IN ('red', 'yellow', 'green');```

## select с order by
```SELECT title, task_date FROM task ORDER BY task_date DESC;
SELECT username, email FROM user_data ORDER BY username;```

## select с like
```SELECT username FROM user_data WHERE username LIKE 'a%';
SELECT title FROM task WHERE title LIKE '%отчет%' OR title LIKE '%документ%';```

## select уникальных элементов
```SELECT DISTINCT category_id FROM task;
SELECT DISTINCT color FROM priority;```

## select с ограничением на возвращаемые строчки
```SELECT * FROM task LIMIT 10;
SELECT username, email FROM user_data ORDER BY id DESC LIMIT 5;```

## select c inner join
```SELECT t.title, c.title AS category, p.title AS priority
FROM task t
INNER JOIN category c ON t.category_id = c.id
INNER JOIN priority p ON t.priority_id = p.id;

SELECT c.content, u.username
FROM comment c
INNER JOIN user_data u ON c.user_id = u.id;```

## select c left, right join
```SELECT t.title, c.title AS category
FROM task t
LEFT JOIN category c ON t.category_id = c.id;

SELECT u.username, p.full_name
FROM user_data u
LEFT JOIN user_profile p ON u.id = p.user_id;

SELECT c.title AS category, t.title AS task
FROM task t
RIGHT JOIN category c ON t.category_id = c.id;

SELECT p.title AS priority, t.title AS task
FROM task t
RIGHT JOIN priority p ON t.priority_id = p.id;```

## select c full outer join
```SELECT u.username, p.full_name
FROM user_data u
FULL OUTER JOIN user_profile p ON u.id = p.user_id;

SELECT c.title AS category, t.title AS task
FROM task t
FULL OUTER JOIN category c ON t.category_id = c.id;```

## select c cross join
```SELECT u.username, p.title AS priority
FROM user_data u
CROSS JOIN priority p;

SELECT c.title AS category, tg.title AS tag
FROM category c
CROSS JOIN tag tg;```

## select c inner join из нескольких таблиц
```SELECT t.title AS task, u.username, c.title AS category, p.title AS priority
FROM task t
INNER JOIN user_data u ON t.user_id = u.id
INNER JOIN category c ON t.category_id = c.id
INNER JOIN priority p ON t.priority_id = p.id;

SELECT c.content, u.username, t.title AS task_title
FROM comment c
INNER JOIN user_data u ON c.user_id = u.id
INNER JOIN task t ON c.task_id = t.id;```
