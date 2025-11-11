
# SELECT

Количество задач у каждого пользователя
```
SELECT username, (SELECT COUNT(*) FROM task t WHERE t.user_id = u.id) AS tasks_count
FROM user_data u;
```
<img width="283" height="142" alt="1 1" src="https://github.com/user-attachments/assets/cfa63e89-6d0d-45b9-a34f-7cddb42c35b3" />

Показать задачи и число комментариев к каждой
```
SELECT title, (SELECT COUNT(*) FROM comment c WHERE c.task_id = t.id) AS comments
FROM task t;
```
<img width="326" height="294" alt="ывавапвап" src="https://github.com/user-attachments/assets/beddc11f-9509-491e-ae2c-ad90a42a7b02" />

Название категории каждой задачи
```
SELECT title, (SELECT c.title FROM category c WHERE c.id = t.category_id) AS category_title
FROM task t;
```
<img width="397" height="296" alt="1 3" src="https://github.com/user-attachments/assets/1d170513-1054-4476-b4d5-2793ba6b57b8" />

# FROM

Среднее количество задач на пользователя
```
SELECT AVG(cnt)
FROM (SELECT COUNT(*) AS cnt FROM task GROUP BY user_id) s;
```
<img width="180" height="64" alt="Screenshot_5" src="https://github.com/user-attachments/assets/aa7db362-8da6-425b-be79-926d9efa3453" />

Категории и число задач в них
```
SELECT c.title, stats.task_total
FROM category c
JOIN (SELECT category_id, COUNT(*) AS task_total FROM task GROUP BY category_id) stats
ON stats.category_id = c.id;
```
<img width="287" height="141" alt="2 2" src="https://github.com/user-attachments/assets/3297149b-e96e-4be6-9860-9419867db30a" />


Пользователи с ID меньше 3
```
SELECT *
FROM (SELECT username FROM user_data WHERE id < 3) u;
```
<img width="189" height="90" alt="ЫВАЫВАЫ" src="https://github.com/user-attachments/assets/c8aa1460-6894-423a-b074-32c8d93e95bf" />

# WHERE

Вывести комментарии к выполненным задачам
```
SELECT *
FROM comment
WHERE task_id IN (SELECT id FROM task WHERE completed = TRUE);
```
<img width="630" height="68" alt="ЫВАЫАВЫАЫВАЫАЫВАЫВАЫВА" src="https://github.com/user-attachments/assets/d0a5881b-6d51-4ac5-b2a5-ceee150ed38a" />

Комментарии к задачам, у которых есть вложения
```
SELECT * FROM comment
WHERE task_id IN (SELECT task_id FROM attachment);
```
<img width="632" height="162" alt="Screenshot_7" src="https://github.com/user-attachments/assets/7734b416-92a8-4805-823c-0ab3b30eb352" />

Задачи пользователей, у которых больше 1 завершённой задачи
```
SELECT * FROM task
WHERE user_id IN (
  SELECT user_id FROM task WHERE completed = TRUE GROUP BY user_id HAVING COUNT(*) > 1
);
```
<img width="716" height="113" alt="Screenshot_8" src="https://github.com/user-attachments/assets/315d6c05-fc3f-4287-af1f-e4672ca31880" />

# HAVING

Пользователи с более чем 2 задачами
```
SELECT user_id, COUNT(*) AS total_tasks
FROM task
GROUP BY user_id
HAVING COUNT(*) > 2;
```
<img width="202" height="92" alt="Screenshot_9" src="https://github.com/user-attachments/assets/9dce6318-7008-4c0f-a225-ea04a98c6043" />

Категории, где есть хотя бы одна завершённая задача
```
SELECT category_id, COUNT(*) AS done_tasks
FROM task
WHERE completed = TRUE
GROUP BY category_id
HAVING COUNT(*) >= 1;
```
<img width="230" height="143" alt="Screenshot_10" src="https://github.com/user-attachments/assets/72248c3f-c53d-4ffe-a5b2-f912ad18c331" />

Приоритеты, у которых задач больше одной
```
SELECT priority_id, COUNT(*) AS total
FROM task
GROUP BY priority_id
HAVING COUNT(*) > 1;
```
<img width="189" height="123" alt="Screenshot_11" src="https://github.com/user-attachments/assets/cda64687-1a34-4c94-bd61-0a93b79114ac" />

# ALL

Задачи с самой поздней датой
```
SELECT * FROM task
WHERE task_date >= ALL (SELECT task_date FROM task);
```
<img width="717" height="75" alt="Screenshot_12" src="https://github.com/user-attachments/assets/6fde94c9-32a8-4602-9049-a5fab954d1e7" />

Задачи с датой позже всех задач пользователя 1
```
SELECT title, task_date
FROM task
WHERE task_date > ALL (
    SELECT task_date 
    FROM task 
    WHERE user_id = 1 AND task_date IS NOT NULL
);
```
<img width="291" height="143" alt="gfdhfghfgfg" src="https://github.com/user-attachments/assets/ac724a68-5891-4abd-beb6-10d38c2f038f" />

Категории с ID больше всех ID приоритетов
```
SELECT title
FROM category
WHERE id > ALL (SELECT id FROM priority);
```
<img width="206" height="68" alt="Screenshot_13" src="https://github.com/user-attachments/assets/4a172491-47c6-4c30-8a3d-f706d571bc12" />

# IN

задачи, у которых есть комментарии
```
SELECT *
FROM task
WHERE id IN (SELECT task_id FROM comment);
```
<img width="729" height="193" alt="Screenshot_15" src="https://github.com/user-attachments/assets/d58ad76e-2846-47de-9876-8ea5b2a45315" />

Пользователи, оставившие комментарии
```
SELECT *
FROM user_data
WHERE id IN (SELECT user_id FROM comment);
```
<img width="593" height="168" alt="Screenshot_16" src="https://github.com/user-attachments/assets/718bf2c4-4051-4656-9521-e2df2c052b5c" />


Комментарии к невыполненным задачам
```
SELECT content, created_at
FROM comment
WHERE task_id IN (SELECT id FROM task WHERE completed = FALSE);
```
<img width="436" height="127" alt="Screenshot_15fgf" src="https://github.com/user-attachments/assets/2836b116-5f0f-4ae3-89ed-bdff8fc7ecb7" />

# ANY

задачи, позже хотя бы одной выполненной
```
SELECT *
FROM task
WHERE task_date > ANY (SELECT task_date FROM task WHERE completed = TRUE);
```
<img width="732" height="160" alt="Screenshot_17" src="https://github.com/user-attachments/assets/197a3794-d8c4-402d-beea-299f4c64e094" />

Задачи, относящиеся к любым существующим категориям
```
SELECT id, title 
FROM task 
WHERE category_id = ANY (SELECT id FROM category);
```
<img width="331" height="199" alt="Screenshot_18" src="https://github.com/user-attachments/assets/e1e875fe-be46-4192-8347-bb93fb31011b" />

Задачи, которые имеют любые теги
```
SELECT DISTINCT t.id, t.title 
FROM task t 
WHERE t.id = ANY (SELECT task_id FROM task_tag);
```
<img width="307" height="195" alt="Screenshot_19" src="https://github.com/user-attachments/assets/94810ce4-b217-4ed6-9b6c-34f9d57ec990" />

# EXIST

вывести пользователей, у которых есть хотя бы одна задача
```
SELECT *
FROM user_data u
WHERE EXISTS (SELECT 1 FROM task t WHERE t.user_id = u.id);
```
<img width="587" height="173" alt="Screenshot_20" src="https://github.com/user-attachments/assets/659897b4-a203-426b-9711-b4dd47fff6d3" />

найти задачи, у которых есть подзадачи
```
SELECT *
FROM task t
WHERE EXISTS (SELECT 1 FROM subtask s WHERE s.task_id = t.id);
```
<img width="736" height="147" alt="Screenshot_22" src="https://github.com/user-attachments/assets/8e685bf2-f752-48a9-ba61-e5f2347b8f35" />

показать категории, содержащие задачи
```
SELECT *
FROM category c
WHERE EXISTS (SELECT 1 FROM task t WHERE t.category_id = c.id);
```
<img width="294" height="145" alt="Screenshot_23" src="https://github.com/user-attachments/assets/ad92ab38-404d-415a-b3f5-d70f3017c598" />

# Сравнение по нескольким столбцам

найти задачи с теми же категорией и приоритетом, что у выполненных
```
SELECT *
FROM task
WHERE (category_id, priority_id) IN (
    SELECT category_id, priority_id FROM task WHERE completed = TRUE
);
```
<img width="729" height="120" alt="Screenshot_24" src="https://github.com/user-attachments/assets/1c8343c9-ff08-416a-9808-7f3f16fdbe21" />

Комментарии, совпадающие по задаче и пользователю с другими длинными комментариями
```
SELECT *
FROM comment
WHERE (task_id, user_id) IN (
    SELECT task_id, user_id FROM comment WHERE LENGTH(content) > 5
);
```
<img width="666" height="198" alt="Screenshot_25" src="https://github.com/user-attachments/assets/e92da4f8-83e5-488d-bdb2-353bc117f2b1" />

подзадачи, совпадающие по названию и статусу с другими
```
SELECT *
FROM subtask
WHERE (title, completed) IN (
    SELECT title, completed FROM subtask WHERE completed = TRUE
);
```
<img width="445" height="144" alt="Screenshot_26" src="https://github.com/user-attachments/assets/39a19044-a840-48d5-a8dd-ad54daf44699" />

# Коррелированные подзапросы

Для каждой задачи показываем количество её комментариев
```
SELECT 
    t.id,
    t.title,
    (SELECT COUNT(*) 
     FROM comment c 
     WHERE c.task_id = t.id) as comment_count
FROM task t;
```
<img width="434" height="189" alt="Screenshot_27" src="https://github.com/user-attachments/assets/02026f58-e127-4ff8-b7ba-0a6c7dd41da1" />

Задачи, у которых есть хотя бы одна подзадача
```
SELECT t.id, t.title
FROM task t
WHERE EXISTS (
    SELECT 1 
    FROM subtask s 
    WHERE s.task_id = t.id
);
```
<img width="314" height="146" alt="Screenshot_28" src="https://github.com/user-attachments/assets/d29ec95a-0429-4cff-9ce2-cda5d48874ba" />

Для каждого пользователя считаем количество задач
```
SELECT 
    u.id,
    u.username,
    (SELECT COUNT(*) 
     FROM task t 
     WHERE t.user_id = u.id) as task_count
FROM user_data u;
```
<img width="373" height="161" alt="Screenshot_29" src="https://github.com/user-attachments/assets/19d534f0-2df1-47f2-9653-9f878e981a36" />

Показываем, есть ли у задачи теги
```
SELECT 
    t.id,
    t.title,
    (SELECT CASE 
        WHEN EXISTS (SELECT 1 FROM task_tag tt WHERE tt.task_id = t.id) 
        THEN 'Есть теги' 
        ELSE 'Нет тегов' 
     END) as tag_status
FROM task t;
```
<img width="406" height="190" alt="Screenshot_30" src="https://github.com/user-attachments/assets/2d7469d9-df49-44aa-a1cb-f210d6b2b1f8" />

Задачи и их приоритет (цвет)
```
SELECT 
    title,
    (SELECT color FROM priority WHERE id = t.priority_id) as priority_color
FROM task t;
```

<img width="365" height="196" alt="Screenshot_31" src="https://github.com/user-attachments/assets/9815a5f0-be7e-4dec-adca-edb14414b94c" />

