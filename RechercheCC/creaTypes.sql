create or replace type actor_t as object (name varchar2(20 char), role varchar2(114 char));

create or replace TYPE ACTORS_T AS TABLE OF actor_t;

create or replace TYPE DIRECTORS_T AS TABLE OF varchar2(19);

CREATE TYPE VOTE_RQS as object (average NUMBER(2,1), sum_vote Number);

create or replace TYPE ACTORS_NAME AS TABLE OF varchar2(20);

create or replace TYPE ACTORS_ID AS TABLE OF NUMBER;

create or replace type genre_t as object (id integer, name varchar2(16));

create or replace type genres_t as table of genre_t;

create or replace TYPE REALISATORS_T AS TABLE OF varchar2(19);

create or replace TYPE VOTE_RQS as object (average NUMBER(2,1), sum_vote Number);