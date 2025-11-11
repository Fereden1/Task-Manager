# SELECT

Количество задач у каждого пользователя
```
SELECT username, 
       (SELECT COUNT(*) FROM task t WHERE t.user_id = u.id) AS task_count
FROM user_data u;
```
<img width="283" height="142" alt="1 1" src="https://github.com/user-attachments/assets/cfa63e89-6d0d-45b9-a34f-7cddb42c35b3" />

Количество комментариев у каждой задачи
```
SELECT title, 
       (SELECT COUNT(*) FROM comment c WHERE c.task_id = t.id) AS comment_count
FROM task t;
```
<img width="361" height="293" alt="1 2" src="https://github.com/user-attachments/assets/58b69281-5b59-4679-abe8-f3e354fcf0b5" />



Название категории каждой задачи
```
SELECT title, 
       (SELECT c.title FROM category c WHERE c.id = t.category_id) AS category_title
FROM task t;
```
<img width="397" height="296" alt="1 3" src="https://github.com/user-attachments/assets/1d170513-1054-4476-b4d5-2793ba6b57b8" />
