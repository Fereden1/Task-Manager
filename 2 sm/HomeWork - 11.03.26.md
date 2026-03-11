# GIN

## 1) Проверка JSONB по теме оформления
```sql
CREATE INDEX IF NOT EXISTS idx_user_preferences ON Task_Manager.user_data USING GIN (preferences);

EXPLAIN (ANALYZE, BUFFERS)
SELECT id, username
FROM Task_Manager.user_data
WHERE preferences @> '{"theme":"dark"}';
```

<img width="944" height="206" alt="1111111111111111111111111" src="https://github.com/user-attachments/assets/ed549f95-31e0-4efc-8291-990af3872501" />

## 2) поиск пользователей с mobile
```sql
CREATE INDEX IF NOT EXISTS idx_user_devices ON Task_Manager.user_data USING GIN (devices);

EXPLAIN (ANALYZE, BUFFERS)
SELECT id, username
FROM Task_Manager.user_data
WHERE devices @> ARRAY['mobile'];
```

<img width="1100" height="257" alt="5432423" src="https://github.com/user-attachments/assets/775db0e3-7870-4ac2-98a2-c290006733a4" />

## 3) поиск задач с тегом urgent
```sql
CREATE INDEX IF NOT EXISTS idx_task_tags ON Task_Manager.task USING GIN (tags);

EXPLAIN (ANALYZE, BUFFERS)
SELECT id, title
FROM Task_Manager.task
WHERE tags @> ARRAY['urgent'];
```

<img width="1061" height="258" alt="3242342342342" src="https://github.com/user-attachments/assets/029db39c-a19a-4424-bd06-9ce977cb7bf0" />

## 4) поиск по source = web
```sql
CREATE INDEX IF NOT EXISTS idx_task_metadata ON Task_Manager.task USING GIN (metadata);

EXPLAIN (ANALYZE, BUFFERS)
SELECT id, title
FROM Task_Manager.task
WHERE metadata @> '{"source":"web"}';
```

<img width="1109" height="256" alt="345345345345435345345" src="https://github.com/user-attachments/assets/fe1621be-31d0-4fdc-9bc0-8605760bec5d" />

## 5) поиск blocked = true
```sql
CREATE INDEX IF NOT EXISTS idx_subtask_metadata ON Task_Manager.subtask USING GIN (metadata);

EXPLAIN (ANALYZE, BUFFERS)
SELECT id, title
FROM Task_Manager.subtask
WHERE metadata @> '{"blocked": true}';
```

<img width="1095" height="253" alt="24423234234423234234234" src="https://github.com/user-attachments/assets/6e712f1b-ecdb-4f7f-9265-c940611622af" />

#GIST

## 1) пересечение диапазонов дат
```sql
CREATE INDEX IF NOT EXISTS idx_task_due_period ON Task_Manager.task USING GiST (due_period);

EXPLAIN (ANALYZE, BUFFERS)
SELECT id, title, due_period
FROM Task_Manager.task
WHERE due_period && daterange(CURRENT_DATE, CURRENT_DATE + 14, '[]');
```

<img width="892" height="200" alt="Screenshot_6345344343" src="https://github.com/user-attachments/assets/85575b95-ac9f-4c6a-b4f6-8cffdc66f5c6" />

## 2) содержит конкретную дату
```sql
CREATE INDEX IF NOT EXISTS idx_task_due_period ON Task_Manager.task USING GiST (due_period);

EXPLAIN (ANALYZE, BUFFERS)
SELECT id, title, due_period
FROM Task_Manager.task
WHERE due_period @> CURRENT_DATE;
```

<img width="1131" height="256" alt="567657678678867" src="https://github.com/user-attachments/assets/36f480b7-581b-49a2-9139-56929bd8e7e1" />

## 3) содержит другой диапазон
```sql
CREATE INDEX IF NOT EXISTS idx_task_due_period ON Task_Manager.task USING GiST (due_period);

EXPLAIN (ANALYZE, BUFFERS)
SELECT id, title, due_period
FROM Task_Manager.task
WHERE due_period @> daterange(CURRENT_DATE + 1, CURRENT_DATE + 7, '[]');
```

<img width="903" height="209" alt="567867886767878867" src="https://github.com/user-attachments/assets/dce51fb1-c4ea-4ffd-91bb-4f709669d648" />

## 4) пересечение диапазона оценок
```sql
CREATE INDEX IF NOT EXISTS idx_subtask_estimate_range ON Task_Manager.subtask USING GiST (estimate_range);

EXPLAIN (ANALYZE, BUFFERS)
SELECT id, title, estimate_range
FROM Task_Manager.subtask
WHERE estimate_range && int4range(5, 15, '[]');
```

<img width="895" height="190" alt="Screenshot_6" src="https://github.com/user-attachments/assets/e22a6fff-4637-4d0b-bde0-4782b77b8b65" />

## 5) диапазон содержит число
```sql
CREATE INDEX IF NOT EXISTS idx_subtask_estimate_range ON Task_Manager.subtask USING GiST (estimate_range);

EXPLAIN (ANALYZE, BUFFERS)
SELECT id, title, estimate_range
FROM Task_Manager.subtask
WHERE estimate_range @> 10;
```

<img width="913" height="155" alt="Screenshot_7" src="https://github.com/user-attachments/assets/8616e517-f7e1-4e01-a7a0-356a584e04ac" />

#JOIN

## 1) Nested Loop Ищем конкретного пользователя по u.id = 1000. БД сначала находит одну строку в user_data по первичному ключу, затем по индексу idx_task_user ищет все связанные задачи в таблице task.
```sql
EXPLAIN (ANALYZE, BUFFERS)
SELECT t.id, t.title, u.username
FROM Task_Manager.user_data u
JOIN Task_Manager.task t ON t.user_id = u.id
WHERE u.id = 1000;
```
<img width="1062" height="352" alt="Screenshot_10" src="https://github.com/user-attachments/assets/ada17fac-242f-4acc-b3c3-ce121c3dcc58" />

## 2) Nested Loop Ищем конкретную задачу по t.id = 5000. БД сначала находит одну строку в task по первичному ключу, затем по индексу idx_subtask_task ищет связанные подзадачи в subtask.
```sql
EXPLAIN (ANALYZE, BUFFERS)
SELECT t.id, t.title, s.id AS subtask_id, s.title AS subtask_title
FROM Task_Manager.task t
JOIN Task_Manager.subtask s ON s.task_id = t.id
WHERE t.id = 5000;
```

<img width="1074" height="290" alt="Screenshot_11" src="https://github.com/user-attachments/assets/a4e918e1-7ee4-4ea8-9810-419f6edbcc5c" />

## 3) Nested Loop Ищем конкретного пользователя по u.id = 2000. БД сначала находит одну строку в user_data по первичному ключу, затем по индексу idx_subtask_assignee ищет все подзадачи, назначенные этому пользователю.
```sql
EXPLAIN (ANALYZE, BUFFERS)
SELECT u.id, u.username, s.id AS subtask_id, s.title
FROM Task_Manager.user_data u
JOIN Task_Manager.subtask s ON s.assignee_id = u.id
WHERE u.id = 2000;
```

<img width="1088" height="366" alt="Screenshot_12" src="https://github.com/user-attachments/assets/df07852b-c4e4-4c60-81c3-92fb67a131d2" />

## 4) Nested Loop Ищем конкретного пользователя по u.id = 3000. БД сначала находит одну строку в user_data, затем по индексу idx_task_user получает задачи этого пользователя, после чего по индексу idx_subtask_task находит подзадачи каждой найденной задачи.
```sql
EXPLAIN (ANALYZE, BUFFERS)
SELECT u.username, t.id AS task_id, t.title AS task_title, s.id AS subtask_id, s.title AS subtask_title
FROM Task_Manager.user_data u
JOIN Task_Manager.task t ON t.user_id = u.id
JOIN Task_Manager.subtask s ON s.task_id = t.id
WHERE u.id = 3000;
```

<img width="1123" height="448" alt="Screenshot_13" src="https://github.com/user-attachments/assets/d4eb1f88-4dce-435e-92b0-9e934c8e3692" />

## 5) Nested Loop Ищем конкретную подзадачу по s.id = 7000. БД сначала находит одну строку в subtask по первичному ключу, затем находит связанную задачу по task_id, а после этого - исполнителя по assignee_id.

```sql
EXPLAIN (ANALYZE, BUFFERS)
SELECT s.id, s.title AS subtask_title, t.title AS task_title, u.username AS assignee_username
FROM Task_Manager.subtask s
JOIN Task_Manager.task t ON t.id = s.task_id
LEFT JOIN Task_Manager.user_data u ON u.id = s.assignee_id
WHERE s.id = 7000;
```

<img width="1081" height="363" alt="Screenshot_14" src="https://github.com/user-attachments/assets/6a7e5b25-f9bb-4eb3-8b0e-f34efe9bf1cb" />

MVCC 1)


