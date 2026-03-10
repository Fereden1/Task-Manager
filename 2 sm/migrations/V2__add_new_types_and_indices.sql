ALTER TABLE task_manager.user_data
    ADD COLUMN IF NOT EXISTS signup_date DATE,
    ADD COLUMN IF NOT EXISTS status VARCHAR(20),
    ADD COLUMN IF NOT EXISTS preferences JSONB,
    ADD COLUMN IF NOT EXISTS devices TEXT[],
    ADD COLUMN IF NOT EXISTS home_location POINT;

ALTER TABLE task_manager.task
    ADD COLUMN IF NOT EXISTS due_period DATERANGE,
    ADD COLUMN IF NOT EXISTS tags TEXT[],
    ADD COLUMN IF NOT EXISTS metadata JSONB,
    ADD COLUMN IF NOT EXISTS notes TEXT,
    ADD COLUMN IF NOT EXISTS task_location POINT;

ALTER TABLE task_manager.subtask
    ADD COLUMN IF NOT EXISTS assignee_id INT REFERENCES task_manager.user_data(id) ON DELETE SET NULL,
    ADD COLUMN IF NOT EXISTS estimate_range INT4RANGE,
    ADD COLUMN IF NOT EXISTS labels TEXT[],
    ADD COLUMN IF NOT EXISTS details TEXT,
    ADD COLUMN IF NOT EXISTS metadata JSONB;

CREATE INDEX IF NOT EXISTS idx_task_user
    ON task_manager.task(user_id);

CREATE INDEX IF NOT EXISTS idx_task_category
    ON task_manager.task(category_id);

CREATE INDEX IF NOT EXISTS idx_task_priority
    ON task_manager.task(priority_id);

CREATE INDEX IF NOT EXISTS idx_subtask_task
    ON task_manager.subtask(task_id);

CREATE INDEX IF NOT EXISTS idx_subtask_assignee
    ON task_manager.subtask(assignee_id);

CREATE INDEX IF NOT EXISTS idx_user_preferences
    ON task_manager.user_data USING GIN (preferences);

CREATE INDEX IF NOT EXISTS idx_task_due_period
    ON task_manager.task USING GIST (due_period);

CREATE INDEX IF NOT EXISTS idx_task_notes_fts
    ON task_manager.task USING GIN (to_tsvector('simple', coalesce(notes, '')));

CREATE INDEX IF NOT EXISTS idx_subtask_estimate_range
    ON task_manager.subtask USING GIST (estimate_range);
