WITH task_count AS (
    SELECT user_id, COUNT(*) AS cnt
    FROM task
    GROUP BY user_id
)
SELECT * FROM task_count;
