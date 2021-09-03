-- Create "players" table with partitions
CREATE SEQUENCE IF NOT EXISTS players_id_seq START WITH 1;

CREATE OR REPLACE FUNCTION next_id(OUT result bigint) AS
$$
DECLARE
    epoch      bigint := 1577836800000;
    shard_id   int    := 1;
    seq_id     bigint;
    now_millis bigint;
BEGIN
    SELECT nextval('players_id_seq') % 1024 INTO seq_id;
    SELECT FLOOR(EXTRACT(EPOCH FROM clock_timestamp()) * 1000) INTO now_millis;
    result := (now_millis - epoch) << 23;
    result := result | (shard_id << 10);
    result := result | (seq_id);
END;
$$ LANGUAGE PLPGSQL;

CREATE TABLE IF NOT EXISTS players
(
    id                 bigint       NOT NULL DEFAULT next_id(),
    campaign_id        bigint       NOT NULL,
    email              varchar(255) NOT NULL DEFAULT '',
    email_canonical    varchar(255) NOT NULL DEFAULT '',
    phone              varchar(15)  NOT NULL DEFAULT '',
    utm                jsonb        NOT NULL DEFAULT '{}'::jsonb,
    profile            jsonb        NOT NULL DEFAULT '{}'::jsonb,
    blocked            boolean      NOT NULL DEFAULT false,
    confirmed_phone    boolean      NOT NULL DEFAULT false,
    confirmed_email    boolean      NOT NULL DEFAULT false,
    subscribe_hezzl    boolean      NOT NULL DEFAULT true,
    subscribe_campaign boolean      NOT NULL DEFAULT true,
    dev_mode           boolean      NOT NULL DEFAULT false,
    created_at         timestamp    NOT NULL DEFAULT current_timestamp,
    updated_at         timestamp    NOT NULL DEFAULT current_timestamp,
    primary key (id)
);

CREATE TABLE IF NOT EXISTS players_external
(
    player_id     bigint       NOT NULL,
    campaign_id   int          NOT NULL,
    verification_id int NOT NULL,
    external_id   varchar(255) NOT NULL,
    external_name varchar(255) NOT NULL,
    primary key (player_id, campaign_id, verification_id)
);

CREATE TABLE IF NOT EXISTS player_shards
(
    id            bigint       not null,
    campaign_id   int          not null,
    login         varchar(255) not null,
    type          int          not null,
    password_hash varchar(255),
    shard         int          not null,
    blocked       bool         not null default false,
    created_at    timestamp    not null default current_timestamp,
    primary key (campaign_id, login, type)
) PARTITION BY LIST (type);

CREATE TABLE IF NOT EXISTS player_email PARTITION OF player_shards FOR VALUES IN (0);
CREATE TABLE IF NOT EXISTS player_phone PARTITION OF player_shards FOR VALUES IN (1);
CREATE TABLE IF NOT EXISTS player_common PARTITION OF player_shards DEFAULT;

CREATE INDEX IF NOT EXISTS idx_player_shards_id ON player_shards (id);
-- End "players" table definitions

--- Form config ---
CREATE TABLE IF NOT EXISTS campaign_settings (
    campaign_id int not null,
    status int not null default 0,
    login_type int not null default 0,
    allow_types jsonb not null default '[]'::jsonb,
    allow_password bool not null default false,
    invite_enabled bool not null default false,
    captcha_enabled bool not null default false,
    captcha_site_key varchar(255),
    captcha_secret_key varchar(255),
    require_verifications jsonb not null default '[]'::jsonb,
    primary key (campaign_id)
);

CREATE TABLE IF NOT EXISTS salts
(
    id          serial       not null,
    created_at  TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
    updated_at  TIMESTAMP    NULL,
    deleted_at  TIMESTAMP    NULL,
    campaign_id int          not null,
    title       varchar(255) not null,
    salt        varchar(255) not null,
    primary key (id)
);
CREATE INDEX IF NOT EXISTS idx_salts_campaign_id ON salts (campaign_id);

CREATE TABLE IF NOT EXISTS fields
(
    id          serial       not null,
    created_at  TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
    updated_at  TIMESTAMP    NULL,
    deleted_at  TIMESTAMP    NULL,
    key         varchar(255) not null,
    campaign_id int          not null,
    title       varchar(255) not null,
    type        int          not null,
    priority    int          not null,
    require     bool         not null default false,
    name        jsonb        not null default '{}'::jsonb,
    placeholder jsonb        not null default '{}'::jsonb,
    primary key (id)
);

CREATE INDEX IF NOT EXISTS idx_fields_campaign_id_key ON fields (campaign_id, key);

CREATE TABLE IF NOT EXISTS verifications
(
    id            serial       not null,
    created_at    TIMESTAMP             DEFAULT CURRENT_TIMESTAMP,
    updated_at    TIMESTAMP    NULL,
    deleted_at    TIMESTAMP    NULL,
    campaign_id   int          not null,
    title         varchar(255) not null,
    name          jsonb        not null default '[]'::jsonb,
    type          int          not null,
    api_url       varchar(255),
    api_key       varchar(255),
    api_key_name  varchar(255),
    fields        jsonb        not null default '[]'::jsonb,
    headers       jsonb        not null default '[]'::jsonb,
    external_name varchar(255) not null,
    primary key (id)
);

CREATE INDEX IF NOT EXISTS idx_verifications_campaign_id_id ON verifications (campaign_id, id);
--- End Form config ---