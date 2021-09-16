-- based on tasks/ext/db/clickhouse

-- --------------------------------------------- ADMIN LOG
CREATE TABLE IF NOT EXISTS task_log_admin_event
(
    method      String,
    memberId    Uint32,
    campaignId  Int32,
    service     String,
    entity      String,
    entityId    Uint32,
    entityTitle String,
    request     String,
    response    String,
    eventTime   DateTime,
    headers     String,
    ipAddress   String
) ENGINE = Kafka('kafka:9092', 'task_log_admin_topic', 'tasks_group', 'JSONEachRow');

CREATE TABLE IF NOT EXISTS task_log_admin
(
    Method      String,
    MemberId    Uint32,
    CampaignId  Uint32,
    Service     String,
    Entity      String,
    EntityId    uint32,
    EntityTitle String,
    Request     String,
    Response    String,
    EvenTime    DateTime,
    Headers     String,
    IpAddress   String
) ENGINE = MergeTree()
      PARTITION BY toMonday(EventTime)
      ORDER BY (EventTime, Method)
      SETTINGS index_granularity=8192;

CREATE MATERIALIZED VIEW IF NOT EXISTS task_log_admin_consumer TO task_log_admin AS
SELECT method AS Method,
        memberId AS MemberId,
        campaignId AS CampaignId,
        service AS Service,
        entity AS Entity,
        entityId AS EntityId,
        entityTitle AS EntityTitle,
        request AS Request,
        response AS Response,
        eventTime AS EventTime,
        headers AS Headers,
        ipAddress AS IpAddress
FROM task_log_admin_event;

-- --------------------------------------------- GAME LOG
CREATE TABLE IF NOT EXISTS task_log_game_event
(
    method String,
    transactionId String,
    playerId Uint64,
    campaignId Uint32,
    service String,
    request String,
    response String,
    eventTime DateTime,
    headers String,
    ipAddress String
) ENGINE = Kafka('kafka:9092', 'task_log_game_topic', 'tasks_group', 'JSONEachRow');

CREATE TABLE IF NOT EXISTS task_log_game
(
    Method        String,
    TransactionId String,
    PlayerId      uint64,
    CampaignId    uint32,
    Service       String,
    Request       String,
    Response      String,
    EventTime     DateTime,
    Headers       String,
    IpAddress     String
) ENGINE = MergeTree()
      PARTITION BY toMonday(EventTime)
      ORDER BY (EventTime, Method)
      SETTINGS index_granularity=8192;

CREATE MATERIALIZED VIEW IF NOT EXISTS task_log_game_consumer TO task_log_game AS
SELECT method AS Method,
       transactionId AS TransactionId,
       playerId AS PlayerId,
       campaignId AS CampaignId,
       service AS Service,
       request AS Request,
       response AS Response,
       eventTime AS Time,
       headers AS Headers,
       ipAddress AS IpAddress
FROM task_log_game_event;

-- --------------------------------------------- GAME LOG TASK
CREATE TABLE IF NOT EXISTS task_log_game_task_event
(
    eventTime DateTime,
    transactionId String,
    campaignId Uint32,
    playerId Uint64,
    username String,
    taskId Uint32,
    taskTitle String
) ENGINE = Kafka('kafka:9092', 'task_log_game_task_topic', 'tasks_group', 'JSONEachRow');

CREATE TABLE IF NOT EXISTS task_log_game_task
(
        EventTime DateTime,
        TransactionId String,
        CampaignId Uint32,
        PlayerId Uint64,
        Username String,
        TaskId Uint32,
        TaskTitle String
) ENGINE = MergeTree()
      PARTITION BY toMonday(EventTime)
      ORDER BY (EventTime, Method)
      SETTINGS index_granularity=8192;

CREATE MATERIALIZED VIEW IF NOT EXISTS task_log_game_task_consumer TO task_log_game_task AS
SELECT eventTime AS EventTime,
        transactionId AS TransactionId,
        campaignId AS CampaignId,
        playerId AS PlayerId,
        username AS Username,
        taskId AS TaskId,
        taskTitle AS TaskTitle
FROM task_log_game_task_event;

-- --------------------------------------------- GAME LOG LISTBOX
CREATE TABLE IF NOT EXISTS task_log_game_list_box_event
(
        eventTime         String,
        transactionId     String,
        campaignId        Uint32,
        playerId          Uint64,
        username          String,
        listBoxId         Uint32,
        listBoxTitle      String,
        listBoxTaskId     Uint32,
        entity            String,
        entityId          Uint32,
        entityTitle       String,
        listBoxProgressId Uint32
) ENGINE = Kafka('kafka:9092', 'task_log_game_list_box_topic', 'tasks_group', 'JSONEachRow');

CREATE TABLE IF NOT EXISTS task_log_game_list_box
(
    EventTime         String,
    TransactionId     String,
    CampaignId        Uint32,
    PlayerId          Uint64,
    Username          String,
    ListBoxId         Uint32,
    ListBoxTitle      String,
    ListBoxTaskId     Uint32,
    Entity            String,
    EntityId          Uint32,
    EntityTitle       String,
    ListBoxProgressId Uint32
) ENGINE = MergeTree()
      PARTITION BY toMonday(EventTime)
      ORDER BY (EventTime, PlayerId)
      SETTINGS index_granularity=8192;

CREATE MATERIALIZED VIEW IF NOT EXISTS task_log_game_list_box_consumer TO task_log_game_list_box AS
SELECT eventTime AS EventTime,
transactionId AS TransactionId,
campaignId AS CampaignId,
playerId AS PlayerId,
username AS Username,
listBoxId AS ListBoxId,
listBoxTitle AS ListBoxTitle,
listBoxTaskId AS ListBoxTaskId,
entity AS Entity,
entityId AS EntityId,
entityTitle AS EntityTitle,
listBoxProgressId AS ListBoxProgressId
FROM task_log_game_list_box_event;

-- --------------------------------------------- GAME LOG Season Box
CREATE TABLE IF NOT EXISTS task_log_game_season_box_event
(
    eventTime         String,
    transactionId     String,
    campaignId        Uint32,
    playerId          Uint64,
    username          String,
    seasonBoxId         Uint32,
    seasonBoxTitle      String,
    seasonBoxTaskId     Uint32,
    entity            String,
    entityId          Uint32,
    entityTitle       String,
    seasonBoxProgressId Uint32
) ENGINE = Kafka('kafka:9092', 'task_log_game_season_box_topic', 'tasks_group', 'JSONEachRow');

CREATE TABLE IF NOT EXISTS task_log_game_season_box
(
    EventTime         String,
    TransactionId     String,
    CampaignId        Uint32,
    PlayerId          Uint64,
    Username          String,
    SeasonBoxId         Uint32,
    SeasonBoxTitle      String,
    SeasonBoxTaskId     Uint32,
    Entity            String,
    EntityId          Uint32,
    EntityTitle       String,
    SeasonBoxProgressId Uint32
) ENGINE = MergeTree()
      PARTITION BY toMonday(EventTime)
      ORDER BY (EventTime, PlayerId)
      SETTINGS index_granularity=8192;

CREATE MATERIALIZED VIEW IF NOT EXISTS task_log_game_season_box_consumer TO task_log_game_season_box AS
SELECT eventTime AS EventTime,
       transactionId AS TransactionId,
       campaignId AS CampaignId,
       playerId AS PlayerId,
       username AS Username,
       seasonBoxId AS SeasonBoxId,
       seasonBoxTitle AS SeasonBoxTitle,
       seasonBoxTaskId AS SeasonBoxTaskId,
       entity AS Entity,
       entityId AS EntityId,
       entityTitle AS EntityTitle,
       seasonBoxProgressId AS SeasonBoxProgressId
FROM task_log_game_season_box_event;

-- --------------------------------------------- GAME LOG Daily Box
CREATE TABLE IF NOT EXISTS task_log_game_daily_box_event
(
    eventTime         String,
    transactionId     String,
    campaignId        Uint32,
    playerId          Uint64,
    username          String,
    dailyBoxId         Uint32,
    dailyBoxTitle      String,
    dailyBoxTaskId     Uint32,
    entity            String,
    entityId          Uint32,
    entityTitle       String,
    dailyBoxProgressId Uint32
) ENGINE = Kafka('kafka:9092', 'task_log_game_daily_box_topic', 'tasks_group', 'JSONEachRow');

CREATE TABLE IF NOT EXISTS task_log_game_daily_box
(
    EventTime         String,
    TransactionId     String,
    CampaignId        Uint32,
    PlayerId          Uint64,
    Username          String,
    DailyBoxId         Uint32,
    DailyBoxTitle      String,
    DailyBoxTaskId     Uint32,
    Entity            String,
    EntityId          Uint32,
    EntityTitle       String,
    DailyBoxProgressId Uint32
) ENGINE = MergeTree()
      PARTITION BY toMonday(EventTime)
      ORDER BY (EventTime, PlayerId)
      SETTINGS index_granularity=8192;

CREATE MATERIALIZED VIEW IF NOT EXISTS task_log_game_daily_box_consumer TO task_log_game_daily_box AS
SELECT eventTime AS EventTime,
       transactionId AS TransactionId,
       campaignId AS CampaignId,
       playerId AS PlayerId,
       username AS Username,
       dailyBoxId AS DailyBoxId,
       dailyBoxTitle AS DailyBoxTitle,
       dailyBoxTaskId AS DailyBoxTaskId,
       entity AS Entity,
       entityId AS EntityId,
       entityTitle AS EntityTitle,
       dailyBoxProgressId AS DailyBoxProgressId
FROM task_log_game_daily_box_event;