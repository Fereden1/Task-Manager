CREATE EXTENSION IF NOT EXISTS pageinspect;

## часть 1
показывает версию строки, кто её создал (xmin), кто удалил/обновил (xmax) и физическое положение (ctid).

```sql
SELECT id, title, xmin, xmax, ctid
FROM task_manager.category
ORDER BY id;
```

<img width="317" height="151" alt="Screenshot_15" src="https://github.com/user-attachments/assets/2a2bbd9b-43ba-418a-aef0-4503a12223cd" />

показывает кортежи на странице таблицы и расшифровку флагов t_infomask.

```sql
SELECT
    lp,
    t_xmin AS xmin,
    t_xmax AS xmax,
    t_ctid AS ctid,
    t_infomask,
    t_infomask2,
    raw_flags,
    combined_flags
FROM heap_page_items(get_raw_page('task_manager.category', 0)) h
CROSS JOIN LATERAL heap_tuple_infomask_flags(h.t_infomask, h.t_infomask2) f
ORDER BY lp;
```
<img width="1232" height="152" alt="Screenshot_16" src="https://github.com/user-attachments/assets/e23e5aa7-139d-4628-a6f5-4307879c9ab0" />

## часть 2

t_infomask - битовая маска состояния строки. В ней хранятся признаки видимости, блокировок и статуса изменений.

## часть 3

Транзакция A
```sql
BEGIN;

UPDATE task_manager.category
SET title = 'study_mvcc'
WHERE id = 1;

SELECT id, title, xmin, xmax, ctid
FROM task_manager.category
WHERE id = 1;
```
<img width="336" height="87" alt="Screenshot_17" src="https://github.com/user-attachments/assets/cccec0ea-59e0-4508-8881-ed8ef07877a2" />


Транзакция B
```sql
SELECT
    lp,
    t_xmin AS xmin,
    t_xmax AS xmax,
    t_ctid AS ctid,
    t_infomask,
    t_infomask2,
    raw_flags,
    combined_flags
FROM heap_page_items(get_raw_page('task_manager.category', 0)) h
CROSS JOIN LATERAL heap_tuple_infomask_flags(h.t_infomask, h.t_infomask2) f
ORDER BY lp;
```

<img width="1235" height="205" alt="Screenshot_18" src="https://github.com/user-attachments/assets/79ba1f8b-8645-4cf9-b7c8-1e7909d58d4f" />


