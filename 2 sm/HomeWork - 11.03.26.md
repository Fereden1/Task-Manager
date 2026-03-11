# GIN

## 1) Проверка JSONB по теме оформления
```sql
CREATE INDEX IF NOT EXISTS idx_user_preferences ON Task_Manager.user_data USING GIN (preferences);

EXPLAIN (ANALYZE, BUFFERS)
SELECT id, username
FROM Task_Manager.user_data
WHERE preferences @> '{"theme":"dark"}';
```

<img width="529" height="209" alt="Screenshot_61111111111111111111111111111" src="https://github.com/user-attachments/assets/0e0f6ca8-59f3-4780-ad4e-35bf96b66a11" />
