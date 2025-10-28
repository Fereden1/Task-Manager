<img width="210" height="79" alt="Screenshot_9" src="https://github.com/user-attachments/assets/df7bc8cc-e356-4e30-a157-21cfde0c1859" />## COUNT()
Подсчитать количество задач у каждого пользователя
```
SELECT user_id, COUNT(*) AS total_tasks
FROM task
GROUP BY user_id;
```
<img width="205" height="148" alt="111" src="https://github.com/user-attachments/assets/1e6e7980-d445-4f61-bca8-3be21562f35d" />

Подсчитать количество комментариев под каждой задачей
```
SELECT task_id, COUNT(*) AS comment_count
FROM comment
GROUP BY task_id;
```
<img width="233" height="167" alt="2222222222" src="https://github.com/user-attachments/assets/cc1c546d-7c00-4421-9b1b-ab7caf384773" />

## SUM()
Сумма завершенных подзадач по каждой задаче
```
SELECT task_id, SUM(CASE WHEN completed THEN 1 ELSE 0 END) AS completed_subtasks
FROM subtask
GROUP BY task_id;
```
<img width="266" height="180" alt="Screenshot_5" src="https://github.com/user-attachments/assets/0246a6f9-98d0-4ca9-accc-133f293f0430" />

Сумма всех задач (завершенных и незавершенных) по категориям
```
SELECT c.title AS category, SUM(1) AS total_tasks
FROM task t
JOIN category c ON t.category_id = c.id
GROUP BY c.title;
```
<img width="289" height="143" alt="Screenshot_8" src="https://github.com/user-attachments/assets/2a4e3ee3-250a-421a-b4b1-408e954b88b8" />

## AVG()
Среднее количество подзадач на задачу
```
SELECT AVG(sub_count) AS avg_subtasks_per_task
FROM (
    SELECT task_id, COUNT(*) AS sub_count
    FROM subtask
    GROUP BY task_id
) AS sub_counts;
```
<img width="210" height="79" alt="Screenshot_9" src="https://github.com/user-attachments/assets/26d4ff2c-01e8-4233-80b3-d588d293e749" />

Среднее количество комментариев на задачу
```
SELECT AVG(comment_count) AS avg_comments_per_task
FROM (
    SELECT task_id, COUNT(*) AS comment_count
    FROM comment
    GROUP BY task_id
) AS comment_stats;
```
<img width="213" height="73" alt="Screenshot_10" src="https://github.com/user-attachments/assets/72888ac0-1562-4783-a3f6-1ce7e10486e2" />

## MIN()
Минимальная дата задачи у каждого пользователя
```
SELECT user_id, MIN(task_date) AS earliest_task
FROM task
GROUP BY user_id;
```
<img width="214" height="142" alt="Screenshot_11" src="https://github.com/user-attachments/assets/bb3d3e11-92ba-41b0-817f-0028c542572b" />

Минимальное количество подзадач среди всех задач
```
SELECT MIN(sub_count) AS min_subtasks
FROM (
    SELECT task_id, COUNT(*) AS sub_count
    FROM subtask
    GROUP BY task_id
) AS sub_counts;
```
<img width="154" height="70" alt="Screenshot_12" src="https://github.com/user-attachments/assets/a245d1b7-e7ed-4303-b3a1-696a2341b690" />

##MAX()
Максимальная дата задачи у каждого пользователя
```
SELECT user_id, MAX(task_date) AS latest_task
FROM task
GROUP BY user_id;
```
<img width="207" height="142" alt="Screenshot_13" src="https://github.com/user-attachments/assets/a34c79c3-c8b5-4188-9895-62c483717d23" />
Максимальное количество комментариев среди всех задач
```
SELECT MAX(comment_count) AS max_comments
FROM (
    SELECT task_id, COUNT(*) AS comment_count
    FROM comment
    GROUP BY task_id
) AS comment_stats;
```
<img width="162" height="73" alt="Screenshot_14" src="https://github.com/user-attachments/assets/67d3ea6e-e2b0-4bb6-94c1-944e46ccead9" />

## STRING_AGG()
Собрать все теги, связанные с каждой задачей, в одну строку
```
SELECT 
    t.id AS task_id, 
    STRING_AGG(tag.title, ', ') AS tags
FROM task t
JOIN task_tag tt ON t.id = tt.task_id
JOIN tag ON tt.tag_id = tag.id
GROUP BY t.id;
```
<img width="408" height="267" alt="Screenshot_16" src="https://github.com/user-attachments/assets/9b164358-39ba-4fbd-9ea6-a272b6c4d611" />

Объединение всех категорий в одну строку
```
SELECT STRING_AGG(title, ', ') AS all_categories FROM category;
```
<img width="276" height="67" alt="Screenshot_17" src="https://github.com/user-attachments/assets/1fc63599-0e35-4a21-aa67-c71ed987e10e" />

## GROUP BY, HAVING

Найти пользователей, у которых больше 3 задач
```
SELECT user_id, COUNT(*) AS total_tasks
FROM task
GROUP BY user_id
HAVING COUNT(*) > 2;
```

<img width="218" height="96" alt="werwerwe" src="https://github.com/user-attachments/assets/ff9ef35a-4528-4f20-a0a7-97c5373b9fa6" />

Найти категории, где хотя бы 2 задачи завершены
```
SELECT c.title AS category, COUNT(*) AS completed_tasks
FROM task t
JOIN category c ON t.category_id = c.id
WHERE t.completed = TRUE
GROUP BY c.title
HAVING COUNT(*) >= 1;
```
<img width="327" height="144" alt="Screenshot_18" src="https://github.com/user-attachments/assets/5f14354b-0004-476f-a653-15f32a9c37fd" />

## GROUPING SETS

Общая статистика задач по категориям и приоритетам
```
SELECT 
    u.username, 
    c.title AS category, 
    COUNT(t.id) AS total_tasks
FROM task t
JOIN user_data u ON t.user_id = u.id
JOIN category c ON t.category_id = c.id
GROUP BY GROUPING SETS (
    (u.username, c.title),
    (u.username),
    ()
);
```
<img width="449" height="404" alt="Screenshot_20" src="https://github.com/user-attachments/assets/ffe8e5ff-60c6-4e85-93da-4d09631d4805" />


Количество задач по пользователю и приоритету
```
SELECT 
    u.username, 
    p.title AS priority, 
    COUNT(t.id)
FROM task t
JOIN user_data u ON u.id = t.user_id
JOIN priority p ON t.priority_id = p.id
GROUP BY GROUPING SETS (
    (u.username, p.title),
    (u.username),
    ()
);

```
<img width="415" height="398" alt="rytrtyrtyr" src="https://github.com/user-attachments/assets/14ccf825-d2af-4b77-bf3b-ffd7e759a3dd" />

## ROLLUP

Количество задач с промежуточными итогами
```
SELECT u.username, COUNT(t.id) AS total_tasks
FROM user_data u
JOIN task t ON t.user_id = u.id
GROUP BY ROLLUP(u.username);
```
<img width="282" height="169" alt="Screenshot_21" src="https://github.com/user-attachments/assets/2d105082-942d-46e4-964a-4050a4b61b43" />

Количество задач по пользователю и категории
```
SELECT u.username, c.title, COUNT(t.id)
FROM task t
JOIN user_data u ON u.id = t.user_id
JOIN category c ON c.id = t.category_id
GROUP BY ROLLUP(u.username, c.title);
```

<img width="411" height="394" alt="rtyrtytr" src="https://github.com/user-attachments/assets/6567a169-3888-49a6-83fe-26fd5da3e639" />

## CUBE

Количество задач по пользователю и приоритету
```
SELECT u.username, p.title AS priority, COUNT(t.id) AS total_tasks
FROM task t
JOIN user_data u ON t.user_id = u.id
JOIN priority p ON t.priority_id = p.id
GROUP BY CUBE(u.username, p.title);
```

<img width="434" height="490" alt="rtyrtytry" src="https://github.com/user-attachments/assets/afec286b-c8e5-4df7-9180-0de892480bdd" />

Количество задач по категории и приоритету
```
SELECT c.title, p.title, COUNT(t.id) AS total_tasks
FROM task t
JOIN category c ON t.category_id = c.id
JOIN priority p ON t.priority_id = p.id
GROUP BY CUBE(c.title, p.title);
```
<img width="439" height="392" alt="rtyry" src="https://github.com/user-attachments/assets/9d57416b-7711-4da5-906a-13486dddf4da" />



