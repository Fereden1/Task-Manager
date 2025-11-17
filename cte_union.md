# CTE

## подсчет задач по пользователям
```
WITH task_count AS (
    SELECT user_id, COUNT(*) AS cnt
    FROM task
    GROUP BY user_id
)
SELECT * FROM task_count;
```
<img width="176" height="170" alt="1" src="https://github.com/user-attachments/assets/4a1c51ea-d130-42aa-a7e7-be120bcec0de" />

## задачи с количеством комментариев

```
WITH c AS (
    SELECT task_id, COUNT(*) AS comments_cnt
    FROM comment
    GROUP BY task_id
)
SELECT t.title, c.comments_cnt
FROM task t
JOIN c ON c.task_id = t.id;

```
<img width="333" height="194" alt="2" src="https://github.com/user-attachments/assets/44ce920f-e597-445b-ba60-456bc9239c0e" />

## выбор незавершенных подзадач
```
WITH uncompleted AS (
    SELECT task_id, title FROM subtask WHERE completed = FALSE
)
SELECT * FROM uncompleted;
```
<img width="270" height="118" alt="3" src="https://github.com/user-attachments/assets/8f01c3d7-388b-4150-9fea-8df56c15462a" />

## дата первой задачи пользователя
```
WITH first_task AS (
    SELECT user_id, MIN(task_date) AS first_date
    FROM task
    GROUP BY user_id
)
SELECT * FROM first_task;
```
<img width="192" height="166" alt="4" src="https://github.com/user-attachments/assets/eb052bd2-e807-4b4c-86fb-c62ff6d302d9" />

## Количество подзадач для каждой задачи
```
WITH sub_count AS (
    SELECT task_id, COUNT(*) AS subtask_count
    FROM subtask
    GROUP BY task_id
)
SELECT t.title, sub_count.subtask_count
FROM task t
JOIN sub_count ON t.id = sub_count.task_id;
```
<img width="337" height="138" alt="5" src="https://github.com/user-attachments/assets/aaa32c21-ef73-47e3-b474-b3c978df045f" />

# UNION

## Все имена пользователей и названия тегов
```
SELECT username AS value FROM user_data
UNION
SELECT title FROM tag;
```
<img width="199" height="364" alt="6" src="https://github.com/user-attachments/assets/86e4263c-1277-45e1-85e2-421f9293b298" />

## Все названия задач или категорий
```
SELECT title FROM task
UNION
SELECT title FROM category;
```
<img width="220" height="495" alt="7" src="https://github.com/user-attachments/assets/8d06a1e0-2ca2-4283-87b7-4038cc248896" />

## Все email + все file_path
```
SELECT email FROM user_data
UNION
SELECT file_path FROM attachment;
```
<img width="198" height="386" alt="8" src="https://github.com/user-attachments/assets/42d07545-ea30-4e98-9201-17d9e7b2afd5" />

# INTERSECT

## задачи, у которых есть и комментарии, и вложения
```
SELECT task_id FROM comment
INTERSECT
SELECT task_id FROM attachment;
```
<img width="120" height="199" alt="9" src="https://github.com/user-attachments/assets/bcb1b7a0-c7ba-4603-9385-1442d8862232" />

## пользователи, у которых есть задачи и комментарии
```
SELECT user_id FROM task
INTERSECT
SELECT user_id FROM comment;
```
<img width="116" height="166" alt="10" src="https://github.com/user-attachments/assets/850190bf-c41d-438a-972e-8f041f9d761a" />

## задачи с подзадачами и задачами, которые не выполнены
```
SELECT DISTINCT task_id FROM subtask
INTERSECT
SELECT id FROM task WHERE completed = FALSE;
```
<img width="111" height="120" alt="11" src="https://github.com/user-attachments/assets/bc7e4200-5720-4bdc-af93-4380c696a581" />

# EXCEPT

## Категории без задач
```
SELECT title FROM category
EXCEPT
SELECT c.title FROM task t JOIN category c ON t.category_id = c.id;
```
<img width="199" height="112" alt="12" src="https://github.com/user-attachments/assets/e3496ec0-0b3d-4f49-9f12-dce8fae4b5fb" />

## Теги, не связанные ни с одной задачей
```
SELECT title FROM tag
EXCEPT
SELECT tag.title FROM task_tag tt JOIN tag ON tag.id = tt.tag_id;
```
<img width="197" height="121" alt="13" src="https://github.com/user-attachments/assets/14598e53-5bd7-470c-acea-dbb97ad59db5" />

## Пользователи без комментариев
```
SELECT username FROM user_data
EXCEPT
SELECT username FROM comment c JOIN user_data u ON c.user_id = u.id;
```
<img width="197" height="76" alt="14" src="https://github.com/user-attachments/assets/cc9e0f3a-d5e6-4b98-9fd7-78bca256e3ac" />

# PARTITION BY

## Количество задач пользователя
```
SELECT
    user_id,
    title,
    COUNT(*) OVER (PARTITION BY user_id) AS tasks_per_user
FROM task;
```
<img width="399" height="320" alt="15" src="https://github.com/user-attachments/assets/2f980a65-b247-4de6-92f2-5861676c8d62" />

## Количество комментариев на задачу
```
SELECT
    task_id,
    content,
    COUNT(*) OVER (PARTITION BY task_id) AS comments_on_task
FROM comment;
```
<img width="447" height="321" alt="16" src="https://github.com/user-attachments/assets/d6b81ab5-6923-4c5c-a812-d46f867876e0" />

# PARTITION BY + ORDER BY

## показать последнюю задачу каждого пользователя по дате
```
SELECT
    user_id,
    title,
    task_date,
    ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY task_date DESC) AS rn
FROM task;
```
<img width="431" height="326" alt="17" src="https://github.com/user-attachments/assets/eb58d950-3763-43a1-b14c-08ccb45a1fb1" />

## накопительное количество задач по пользователю
```
SELECT
    user_id,
    title,
    task_date,
    COUNT(*) OVER (
        PARTITION BY user_id
        ORDER BY task_date
    ) AS cumulative_task_count
FROM task;
```
<img width="431" height="326" alt="17" src="https://github.com/user-attachments/assets/a53431c4-7c50-4921-a790-601b04d83a1e" />

# ROWS

## сумма ID текущей и предыдущей задачи
```
SELECT
    id,
    title,
    SUM(id) OVER (
        ORDER BY task_date
        ROWS BETWEEN 1 PRECEDING AND CURRENT ROW
    ) AS sum_prev_task
FROM task;
```
<img width="427" height="320" alt="18" src="https://github.com/user-attachments/assets/f43b43b6-99ce-4a37-811d-823817f241dc" />

## Накопительное количество задач пользователя
```
SELECT 
    user_id,
    id AS task_id,
    task_date,
    COUNT(*) OVER (
        PARTITION BY user_id
        ORDER BY task_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_tasks
FROM task
ORDER BY user_id, task_date;
```
<img width="397" height="309" alt="19" src="https://github.com/user-attachments/assets/53615b77-5e14-4243-b543-bf7d80d372de" />
