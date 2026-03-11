#GIN

##Проверка JSONB по теме оформления
```
SELECT id, username, preferences
FROM Task_Manager.user_data
WHERE preferences @> '{"theme":"dark"}';
```

