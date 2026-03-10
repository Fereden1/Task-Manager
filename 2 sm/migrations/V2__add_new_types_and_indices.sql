ALTER TABLE Task_Manager.user_data
    ADD COLUMN IF NOT EXISTS signup_date DATE,
    ADD COLUMN IF NOT EXISTS status VARCHAR(20),
    ADD COLUMN IF NOT EXISTS preferences JSONB,
    ADD COLUMN IF NOT EXISTS devices TEXT[],
    ADD COLUMN IF NOT EXISTS home_location POINT;

ALTER TABLE Task_Manager.task
    ADD COLUMN IF NOT EXISTS due_period DATERANGE,
    ADD COLUMN IF NOT EXISTS tags TEXT[],
    ADD COLUMN IF NOT EXISTS metadata JSONB,
    ADD COLUMN IF NOT EXISTS notes TEXT,
    ADD COLUMN IF NOT EXISTS task_location POINT;

ALTER TABLE Task_Manager.subtask
    ADD COLUMN IF NOT EXISTS assignee_id INT REFERENCES Task_Manager.user_data(id) ON DELETE SET NULL,
    ADD COLUMN IF NOT EXISTS estimate_range INT4RANGE,
    ADD COLUMN IF NOT EXISTS labels TEXT[],
    ADD COLUMN IF NOT EXISTS details TEXT,
    ADD COLUMN IF NOT EXISTS metadata JSONB;

CREATE INDEX IF NOT EXISTS idx_user_username
    ON Task_Manager.user_data(username);

CREATE INDEX IF NOT EXISTS idx_user_email
    ON Task_Manager.user_data(email);

CREATE INDEX IF NOT EXISTS idx_user_signup_date
    ON Task_Manager.user_data(signup_date);

CREATE INDEX IF NOT EXISTS idx_user_status
    ON Task_Manager.user_data(status);

CREATE INDEX IF NOT EXISTS idx_user_preferences
    ON Task_Manager.user_data USING GIN (preferences);

CREATE INDEX IF NOT EXISTS idx_user_devices
    ON Task_Manager.user_data USING GIN (devices);

CREATE INDEX IF NOT EXISTS idx_user_home_location
    ON Task_Manager.user_data USING SPGIST (home_location);

CREATE INDEX IF NOT EXISTS idx_task_date
    ON Task_Manager.task(task_date);

CREATE INDEX IF NOT EXISTS idx_task_category
    ON Task_Manager.task(category_id);

CREATE INDEX IF NOT EXISTS idx_task_priority
    ON Task_Manager.task(priority_id);

CREATE INDEX IF NOT EXISTS idx_task_user
    ON Task_Manager.task(user_id);

CREATE INDEX IF NOT EXISTS idx_task_due_period
    ON Task_Manager.task USING GIST (due_period);

CREATE INDEX IF NOT EXISTS idx_task_tags
    ON Task_Manager.task USING GIN (tags);

CREATE INDEX IF NOT EXISTS idx_task_metadata
    ON Task_Manager.task USING GIN (metadata);

CREATE INDEX IF NOT EXISTS idx_task_notes_fts
    ON Task_Manager.task USING GIN (to_tsvector('simple', coalesce(notes, '')));

CREATE INDEX IF NOT EXISTS idx_task_location
    ON Task_Manager.task USING SPGIST (task_location);

CREATE INDEX IF NOT EXISTS idx_subtask_task
    ON Task_Manager.subtask(task_id);

CREATE INDEX IF NOT EXISTS idx_subtask_assignee
    ON Task_Manager.subtask(assignee_id);

CREATE INDEX IF NOT EXISTS idx_subtask_estimate_range
    ON Task_Manager.subtask USING GIST (estimate_range);

CREATE INDEX IF NOT EXISTS idx_subtask_labels
    ON Task_Manager.subtask USING GIN (labels);

CREATE INDEX IF NOT EXISTS idx_subtask_metadata
    ON Task_Manager.subtask USING GIN (metadata);

CREATE INDEX IF NOT EXISTS idx_subtask_details_fts
    ON Task_Manager.subtask USING GIN (to_tsvector('simple', coalesce(details, '')));