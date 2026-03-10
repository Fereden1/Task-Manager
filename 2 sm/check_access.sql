SET ROLE readonly;
SELECT COUNT(*) AS readonly_can_read FROM Task_Manager.task;
RESET ROLE;

SET ROLE app;
INSERT INTO Task_Manager.comments (user_id, text) VALUES (1, 'app test comment');
UPDATE Task_Manager.task SET completed = TRUE WHERE id = 1;
RESET ROLE;

SET ROLE admin;
CREATE TABLE IF NOT EXISTS Task_Manager.role_test (
    id SERIAL PRIMARY KEY,
    note TEXT
);
DROP TABLE IF EXISTS Task_Manager.role_test;
RESET ROLE;