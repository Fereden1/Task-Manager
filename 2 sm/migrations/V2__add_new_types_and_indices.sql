alter table task_manager.user_data
    add column if not exists signup_date date,
    add column if not exists status varchar(20),
    add column if not exists preferences jsonb,
    add column if not exists devices text[],
    add column if not exists home_location point;

alter table task_manager.task
    add column if not exists due_period daterange,
    add column if not exists tags text[],
    add column if not exists metadata jsonb,
    add column if not exists notes text,
    add column if not exists task_location point;

alter table task_manager.subtask
    add column if not exists assignee_id int references task_manager.user_data(id) on delete set null,
    add column if not exists estimate_range int4range,
    add column if not exists labels text[],
    add column if not exists details text,
    add column if not exists metadata jsonb;

create index if not exists idx_task_user
    on task_manager.task(user_id);

create index if not exists idx_task_category
    on task_manager.task(category_id);

create index if not exists idx_task_priority
    on task_manager.task(priority_id);

create index if not exists idx_subtask_task
    on task_manager.subtask(task_id);

create index if not exists idx_subtask_assignee
    on task_manager.subtask(assignee_id);

create index if not exists idx_user_preferences
    on task_manager.user_data using gin (preferences);

create index if not exists idx_task_due_period
    on task_manager.task using gist (due_period);

create index if not exists idx_task_notes_fts
    on task_manager.task using gin (to_tsvector('simple', coalesce(notes, '')));

create index if not exists idx_subtask_estimate_range
    on task_manager.subtask using gist (estimate_range);
