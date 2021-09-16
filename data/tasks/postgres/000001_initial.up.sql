-- common destination for all *.sql files (mentioned below) is tasks/ext/db/postgres

-- migration.sql:
CREATE TABLE IF NOT EXISTS tasks (
    id SERIAL PRIMARY KEY,
    public_id VARCHAR(255) DEFAULT '',
    campaign_id INTEGER,
    behaviour INTEGER,
    title VARCHAR(255) DEFAULT '',
    name jsonb DEFAULT '{}',
    picture VARCHAR(255) DEFAULT '',
    description jsonb DEFAULT '{}',
    gallery jsonb DEFAULT '[]',
    action_link VARCHAR(255) DEFAULT '',
    repost_link VARCHAR(255) DEFAULT '', 
    access_social_link jsonb DEFAULT '[]', 
    video_ad_link jsonb DEFAULT '[]',
    message_for_friend jsonb DEFAULT '{}',
    friend_reward_id INTEGER DEFAULT '0',
    key_link VARCHAR(255) DEFAULT '',
    enabled BOOLEAN DEFAULT FALSE,
    removed BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    rate jsonb DEFAULT '{}',
    verify_id INTEGER DEFAULT '0',
    resource_require jsonb DEFAULT '{}', 
    global_resource_id_require jsonb DEFAULT '{}', 
    stars_require jsonb DEFAULT '{}'
);

CREATE TABLE IF NOT EXISTS classes (
    id SERIAL PRIMARY KEY,
    campaign_id INTEGER,
    title VARCHAR(255) DEFAULT '',
    name jsonb DEFAULT '{}',
    color VARCHAR(255) DEFAULT '',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS list_box (
    id SERIAL PRIMARY KEY,
    campaign_id INTEGER NOT NULL,
    title VARCHAR(255) NOT NULL,
    name JSONB NOT NULL DEFAULT '[]',
    store BOOLEAN NOT NULL DEFAULT false,
    resource_id_cost JSONB NOT NULL DEFAULT '[]',
    backlog_storage INTEGER NOT NULL DEFAULT 0,
    priority INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL,
    removed BOOLEAN DEFAULT FALSE,
    enabled BOOLEAN DEFAULT TRUE,
    resource_id_cost INTEGER DEFAULT NULL
);

CREATE TABLE IF NOT EXISTS list_box_tasks (
    id SERIAL PRIMARY KEY,
    campaign_id INTEGER NOT NULL,
    list_box_id INTEGER NOT NULL,
    task_id INTEGER NOT NULL,
    resource_cost INTEGER DEFAULT 0,
    reward_id INTEGER NOT NULL,
    limit_per_player INTEGER NOT NULL,
    life_time_for_complete INTEGER NOT NULL,
    priority INTEGER NOT NULL,
    created_at TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL,
    removed BOOLEAN DEFAULT FALSE,
    enabled BOOLEAN DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS list_box_task_progress (
    id SERIAL PRIMARY KEY,
    list_box_id INTEGER NOT NULL,
    list_task_id INTEGER NOT NULL,
    player_id BIGINT NOT NULL,
    campaign_id INTEGER NOT NULL,
    reward_id INTEGER NOT NULL,
    status SMALLINT NOT NULL,
    created_at TIMESTAMP(0) WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP(0) WITHOUT TIME ZONE,
    expire_at TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL,
    resource_id_cost INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS task_scan_statuses (
    id SERIAL PRIMARY KEY,
    campaign_id INTEGER NOT NULL,
    player_id INTEGER NOT NULL,
    task_id INTEGER NOT NULL,
    correlation_id VARCHAR(255),
    check_data jsonb DEFAULT '{}',
    fn_data jsonb DEFAULT '{}',
    status INTEGER NOT NULL DEFAULT 2,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS daily_boxes (
    id SERIAL PRIMARY KEY,
    campaign_id INTEGER NOT NULL,
    title VARCHAR(255) NOT NULL,
    name jsonb NOT NULL DEFAULT '{}',
    refresh_time INTEGER NOT NULL DEFAULT 0,
    refresh_daily_box BOOLEAN NOT NULL DEFAULT false,
    refresh_cost jsonb NOT NULL DEFAULT '{}',
    randomise jsonb NOT NULL DEFAULT '{}',
    public_id VARCHAR(255),
    enabled BOOLEAN NOT NULL DEFAULT false,
    removed BOOLEAN NOT NULL DEFAULT false,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    priority INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS daily_box_rewards (
    id SERIAL PRIMARY KEY,
    daily_box_id INTEGER NOT NULL,
    campaign_id INTEGER NOT NULL,
    x_score_require INTEGER NOT NULL DEFAULT 0,
    reward_id INTEGER,
    enabled BOOLEAN NOT NULL DEFAULT false,
    removed BOOLEAN NOT NULL DEFAULT false,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    priority INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS daily_box_tasks (
    id SERIAL PRIMARY KEY,
    daily_box_id INTEGER NOT NULL,
    task_id INTEGER NOT NULL,
    campaign_id INTEGER NOT NULL,
    x_score INTEGER NOT NULL DEFAULT 0,
    reward_id INTEGER,
    enabled BOOLEAN NOT NULL DEFAULT false,
    removed BOOLEAN NOT NULL DEFAULT false,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    priority INTEGER NOT NULL DEFAULT 0
);

-- completed_player_tasks.sql:
CREATE TABLE IF NOT EXISTS completed_player_tasks (
    id SERIAL PRIMARY KEY,
    campaign_id INTEGER NOT NULL,
    player_id BIGINT NOT NULL,
    task_id INTEGER NOT NULL,
    boxes jsonb NOT NULL,
    completed_at TIMESTAMP WITH TIME ZONE
);

-- daily_box_task_progress.sql:
CREATE TABLE IF NOT EXISTS daily_box_task_progress (
    id SERIAL PRIMARY KEY,
    player_id INTEGER,
    campaign_id INTEGER,
    daily_box_id INTEGER,
    x_score_balance INTEGER NOT NULL DEFAULT '0',
    daily_box_issued_rewards JSONB NOT NULL DEFAULT '[]',
    daily_box_task_status JSONB NOT NULL DEFAULT '{}',
    expire_at TIMESTAMP WITH TIME ZONE
);

CREATE INDEX IF NOT EXISTS daily_box_task_progress_index ON daily_box_task_progress (player_id, campaign_id, daily_box_id);

-- invite_friends_codes.sql:
CREATE TABLE IF NOT EXISTS invite_friend_codes (
    id SERIAL PRIMARY KEY,
    campaign_id INTEGER NOT NULL,
    task_id INTEGER NOT NULL,
    player_id BIGINT NOT NULL,
    code VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- scan_check.sql:
CREATE TABLE IF NOT EXISTS task_scan_check (
  id SERIAL PRIMARY KEY,
  campaign_id INT,
  task_id INT,
  player_id BIGINT,
  correlation_id VARCHAR(255) NOT NULL,
  check_data jsonb DEFAULT '{}',
  fn_data jsonb NOT NULL,
  fn_data_hash VARCHAR(255) NOT NULL,
  status INT,
  created_at TIMESTAMP(0) WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP(0) WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- season_box.sql:
CREATE TABLE IF NOT EXISTS season_box (
    id SERIAL PRIMARY KEY,
    public_id VARCHAR(255) DEFAULT '',
    campaign_id INTEGER,
    title VARCHAR(255) DEFAULT '',
    name jsonb DEFAULT '{}',
    start_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    end_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    enabled BOOLEAN NOT NULL DEFAULT false,
    removed BOOLEAN NOT NULL DEFAULT false,
    priority INTEGER DEFAULT '0',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS season_box_index_campaign ON season_box(campaign_id, start_date, end_date);

CREATE TABLE IF NOT EXISTS season_box_group (
    id SERIAL PRIMARY KEY,
    campaign_id INTEGER,
    season_box_id INTEGER,
    tasks JSONB NOT NULL DEFAULT '[]',
    reward_id INTEGER DEFAULT '0',
    enabled BOOLEAN NOT NULL DEFAULT false,
    removed BOOLEAN NOT NULL DEFAULT false,
    priority INTEGER DEFAULT '0',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS season_box_group_index ON season_box_group(campaign_id, season_box_id, reward_id);

CREATE TABLE IF NOT EXISTS season_box_group_progress (
    id SERIAL PRIMARY KEY,
    player_id BIGINT,
    campaign_id INTEGER,
    season_box_id INTEGER,
    season_box_group_id INTEGER,
    completed_task JSONB NOT NULL DEFAULT '[]',
    reward_issued BOOLEAN NOT NULL DEFAULT false,
    completed BOOLEAN NOT NULL DEFAULT false,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS season_box_group_progress_index ON
season_box_group_progress(player_id, campaign_id, season_box_id, season_box_group_id);

-- task_class.sql:
CREATE TABLE IF NOT EXISTS task_classes (
    task_id INTEGER UNIQUE NOT NULL,
    class_id INTEGER NOT NULL
);

-- task_code.sql:
CREATE TABLE IF NOT EXISTS task_codes (
    id SERIAL PRIMARY KEY,
    campaign_id INTEGER,
    task_id INTEGER,
    code VARCHAR(255),
    "limit" INTEGER DEFAULT '-1',
    used INTEGER DEFAULT 0,
    expired_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- task_links.sql:
CREATE TABLE IF NOT EXISTS task_links (
    "type" varchar(50) NOT NULL,
    type_id integer NOT NULL,
    type_item_id integer NOT NULL,
    task_id integer NOT NULL
);

CREATE INDEX IF NOT EXISTS task_links_index ON task_links("type", type_id, type_item_id, task_id);
