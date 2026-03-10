TRUNCATE Task_Manager.attachment,
         Task_Manager.comments,
         Task_Manager.task_tag,
         Task_Manager.tag,
         Task_Manager.subtask,
         Task_Manager.task,
         Task_Manager.priority,
         Task_Manager.category,
         Task_Manager.user_profile,
         Task_Manager.user_data
RESTART IDENTITY CASCADE;

INSERT INTO Task_Manager.category (id, title) VALUES
    (1, 'study'),
    (2, 'work'),
    (3, 'home'),
    (4, 'health'),
    (5, 'personal')
ON CONFLICT (id) DO NOTHING;

INSERT INTO Task_Manager.priority (id, title, color) VALUES
    (1, 'low', 'green'),
    (2, 'medium', 'yellow'),
    (3, 'high', 'red')
ON CONFLICT (id) DO NOTHING;

INSERT INTO Task_Manager.user_data (
    username, email, password,
    signup_date, status, preferences, devices, home_location
)
SELECT
    'user_' || gs,
    'user_' || gs || '@example.com',
    md5(random()::text),
    CURRENT_DATE - (random() * 1095)::int,
    CASE
        WHEN random() < 0.70 THEN 'active'
        WHEN random() < 0.90 THEN 'inactive'
        ELSE 'premium'
    END,
    jsonb_build_object(
        'theme', CASE WHEN random() < 0.6 THEN 'dark' ELSE 'light' END,
        'notifications', random() < 0.75
    ),
    ARRAY[
        CASE WHEN random() < 0.5 THEN 'web' ELSE 'mobile' END
    ],
    CASE
        WHEN random() < 0.10 THEN NULL
        ELSE point((random() * 180 - 90)::float8, (random() * 360 - 180)::float8)
    END
FROM generate_series(1, 350000) gs;

INSERT INTO Task_Manager.task (
    title, completed, task_date, category_id, priority_id, user_id,
    due_period, tags, metadata, notes, task_location
)
SELECT
    'Task_' || gs,
    random() < 0.25,
    CASE
        WHEN random() < 0.10 THEN NULL
        ELSE CURRENT_DATE - (random() * 365)::int
    END,
    CASE
        WHEN random() < 0.05 THEN NULL
        ELSE floor(random() * 5 + 1)::int
    END,
    CASE
        WHEN random() < 0.60 THEN 2
        WHEN random() < 0.90 THEN 1
        ELSE 3
    END,
    CASE
        WHEN random() < 0.70 THEN floor(random() * 35000 + 1)::int
        ELSE floor(random() * 315000 + 35001)::int
    END,
    CASE
        WHEN random() < 0.12 THEN NULL
        ELSE daterange(
            CURRENT_DATE + (random() * 5)::int,
            CURRENT_DATE + 10 + (random() * 60)::int,
            '[]'
        )
    END,
    ARRAY[
        CASE WHEN random() < 0.5 THEN 'urgent' ELSE 'planned' END
    ],
    jsonb_build_object(
        'source', CASE WHEN random() < 0.5 THEN 'web' ELSE 'mobile' END
    ),
    CASE
        WHEN random() < 0.15 THEN NULL
        ELSE 'Task notes ' || gs || '. ' || repeat('text ', 8)
    END,
    CASE
        WHEN random() < 0.08 THEN NULL
        ELSE point((random() * 180 - 90)::float8, (random() * 360 - 180)::float8)
    END
FROM generate_series(1, 350000) gs;

INSERT INTO Task_Manager.subtask (
    task_id, title, completed, assignee_id,
    estimate_range, labels, details, metadata
)
SELECT
    floor(random() * 350000 + 1)::int,
    'Subtask_' || gs,
    random() < 0.20,
    CASE
        WHEN random() < 0.10 THEN NULL
        WHEN random() < 0.70 THEN floor(random() * 35000 + 1)::int
        ELSE floor(random() * 315000 + 35001)::int
    END,
    int4range((random() * 10)::int, 11 + (random() * 30)::int, '[]'),
    ARRAY[
        CASE WHEN random() < 0.5 THEN 'backend' ELSE 'frontend' END
    ],
    CASE
        WHEN random() < 0.12 THEN NULL
        ELSE 'Subtask details ' || gs || '. ' || repeat('detail ', 6)
    END,
    jsonb_build_object('blocked', random() < 0.2)
FROM generate_series(1, 350000) gs;

SELECT 'user_data' AS table_name, COUNT(*) FROM Task_Manager.user_data
UNION ALL
SELECT 'task', COUNT(*) FROM Task_Manager.task
UNION ALL
SELECT 'subtask', COUNT(*) FROM Task_Manager.subtask
ORDER BY table_name;