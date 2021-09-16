-- --------------------------------------------- ADMIN LOG
DROP TABLE IF EXISTS task_log_admin_event;

DROP TABLE IF EXISTS task_log_admin;

DROP VIEW IF EXISTS task_log_admin_consumer;

-- --------------------------------------------- GAME LOG
DROP TABLE IF EXISTS task_log_game_event;

DROP TABLE IF EXISTS task_log_game;

DROP VIEW IF EXISTS task_log_game_consumer;

-- --------------------------------------------- GAME LOG TASK
DROP TABLE IF EXISTS task_log_game_task_event;

DROP TABLE IF EXISTS task_log_game_task;

DROP VIEW IF EXISTS task_log_game_task_consumer;

-- --------------------------------------------- GAME LOG LISTBOX
DROP TABLE IF EXISTS task_log_game_list_box_event;

DROP TABLE IF EXISTS task_log_game_list_box;

DROP VIEW IF EXISTS task_log_game_list_box_consumer;

-- --------------------------------------------- GAME LOG Season Box
DROP TABLE IF EXISTS task_log_game_season_box_event;

DROP TABLE IF EXISTS task_log_game_season_box;

DROP VIEW IF EXISTS task_log_game_season_box_consumer;

-- --------------------------------------------- GAME LOG Daily Box
DROP TABLE IF EXISTS task_log_game_daily_box_event;

DROP TABLE IF EXISTS task_log_game_daily_box;

DROP VIEW IF EXISTS task_log_game_daily_box_consumer;