BEGIN;

CREATE TABLE quiz_question (
    id              SERIAL PRIMARY KEY,
    question        TEXT,
    active          INTEGER,
    order_by        INTEGER
);

CREATE TABLE quiz_option (
    id              SERIAL PRIMARY KEY,
    question_id     INTEGER REFERENCES quiz_question(id),
    option          TEXT,
    correct         BOOLEAN,
    order_by        INTEGER
);

CREATE TABLE quiz_answer (
    id              SERIAL PRIMARY KEY,
    question_id     INTEGER REFERENCES quiz_question(id),
    option_id       INTEGER REFERENCES quiz_option(id),
    team            TEXT,
    order_by        INTEGER
);

CREATE TABLE quiz_team (
    id              SERIAL PRIMARY KEY,
    team            TEXT
);

COMMIT;

BEGIN;

    INSERT INTO quiz_question (id, question) VALUES(1, 'Are we rocking the DB?');

    INSERT INTO quiz_option (question_id,option) VALUES(1, 'Yes');
    INSERT INTO quiz_option (question_id,option) VALUES(1, 'No');

    INSERT INTO quiz_question (id, question) VALUES(2, 'We are rocking?');

    INSERT INTO quiz_option (question_id,option) VALUES(2, 'Hell yeah');
    INSERT INTO quiz_option (question_id,option) VALUES(2, 'Hopelessly');
COMMIT;
