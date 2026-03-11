# GIN

## 1) Проверка JSONB по теме оформления
```sql
CREATE INDEX IF NOT EXISTS idx_user_preferences ON Task_Manager.user_data USING GIN (preferences);

EXPLAIN (ANALYZE, BUFFERS)
SELECT id, username
FROM Task_Manager.user_data
WHERE preferences @> '{"theme":"dark"}';
```

