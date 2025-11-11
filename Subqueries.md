#SELECT

Количество задач у каждого пользователя
```
SELECT username, 
       (SELECT COUNT(*) FROM task t WHERE t.user_id = u.id) AS task_count
FROM user_data u;
```


Количество комментариев у каждой задачи
```
SELECT title, 
       (SELECT COUNT(*) FROM comment c WHERE c.task_id = t.id) AS comment_count
FROM task t;
```

Название категории каждой задачи
```
SELECT title, 
       (SELECT c.title FROM category c WHERE c.id = t.category_id) AS category_title
FROM task t;
```
