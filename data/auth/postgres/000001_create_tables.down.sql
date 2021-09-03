DROP TABLE IF EXISTS player_email;
DROP TABLE IF EXISTS player_phone;
DROP TABLE IF EXISTS player_common;

DROP INDEX IF EXISTS idx_player_shards_id;
DROP TABLE IF EXISTS player_shards;

DROP TABLE IF EXISTS player_external;
DROP TABLE IF EXISTS players;

DROP FUNCTION IF EXISTS next_id;
DROP SEQUENCE IF EXISTS players_id_seq;

DROP INDEX IF EXISTS idx_verifications_campaign_id_id;
DROP TABLE IF EXISTS verifications;

DROP INDEX IF EXISTS idx_fields_campaign_id_key;
DROP TABLE IF EXISTS fields;

DROP INDEX IF EXISTS idx_salts_campaign_id;
DROP TABLE IF EXISTS salts;

DROP TABLE IF EXISTS campaign_settings;
