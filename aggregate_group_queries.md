## COUNT()
Подсчитать количество задач у каждого пользователя
```
SELECT user_id, COUNT(*) AS total_tasks
FROM task
GROUP BY user_id;
```

<img width="205" height="148" alt="111" src="https://github.com/user-attachments/assets/1e6e7980-d445-4f61-bca8-3be21562f35d" />


