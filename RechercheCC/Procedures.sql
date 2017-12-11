create or replace procedure LoginUser(log in varchar2, ident out integer) as
i number;
logi varchar2(20);
pwd varchar2(20);
BEGIN
  i := 1;
  logi := substr(log, i, instr(log,'-',i)-i);
  i :=instr(log,'-',i)+1;
  pwd := substr(log, i, instr(log,'-',i)-i);
  select id into ident from utilisateur where login = logi and password = pwd;
END;

-- RechercheFilm
create or replace procedure RechercheFilm(artiste in Actors_name, realisateur in Realisators_t, d in VARCHAR2, t in VARCHAR2, i out sys_refcursor) as
ActId ACTORS_ID;
ReaId ACTORS_ID;
BEGIN
  select id bulk collect into ActId
  from movie_actor natural join artist
  where  movie_actor.actor = artist.id and artist.name in (select * from table(artiste));
  
  select id bulk collect into ReaId
  from movie_director natural join director
  where director.id = movie_director.director and director.name in (SELECT * from table(realisateur));
  
  open i for select * from movie
  where (d is null or (t = '=' and extract(YEAR from release_date) = extract(YEAR from to_date(d, 'YYYY')))
                   or (t = '>' and extract(YEAR from release_date) > extract(YEAR from to_date(d, 'YYYY')))
                   or (t = '<' and extract(YEAR from release_date) < extract(YEAR from to_date(d, 'YYYY'))))
        and (artiste is null or id in (select distinct movie 
           from movie_actor mov1
           where not exists (select COLUMN_VALUE
           from table(ActId) where not exists
           (select * from movie_actor mov2
            where mov1.movie = mov2.movie AND (mov2.actor = COLUMN_VALUE)))))
        and (realisateur is not null or id in (select distinct movie
                  from movie_director mov1
                  where not exists (select COLUMN_VALUE
                  from table(realisateur) where not exists
                  (select *
                  from movie_director mov2
                  where mov1.movie = mov2.movie AND (mov2.director = COLUMN_VALUE)))));
END;

--RechercheID
create or replace procedure RechercheID(ident in integer, i out sys_refcursor) as
BEGIN
  open i for select * from movie where id = ident; 
END;

--RechercheNom
create or replace procedure RechercheNom(nom in varchar2, i out sys_refcursor) as
BEGIN
  open i for select * from movie where title = nom;
END;

--ReadVote
create or replace PROCEDURE READVOTE (IDUSER IN NUMBER, IDFILM IN NUMBER, P OUT NUMBER) AS 
BEGIN
  select po into p from vote where us = iduser and movie = idfilm;
  
  Exception
  when no_data_found then  p := 0;--renvoyer null
END READVOTE;

--RechercheDateA
create or replace PROCEDURE RechercheDateA (d IN NUMBER, i out sys_refcursor ) AS 
BEGIN
  open i for select * from movie
  where (extract(YEAR from release_date) < extract(YEAR from to_date(d, 'YYYY')));
  
  Exception
  when no_data_found then  i := NULL;--renvoyer null
END RechercheDateA;

--RechercheDateB
create or replace PROCEDURE RechercheDateB (d IN NUMBER, i out sys_refcursor ) AS 
BEGIN
  open i for select * from movie
  where (extract(YEAR from release_date) = extract(YEAR from to_date(d, 'YYYY')));
  
  Exception
  when no_data_found then  i := NULL;--renvoyer null
END RechercheDateB;

--RechercheDateE
create or replace PROCEDURE RechercheDateE (d IN NUMBER, i out sys_refcursor ) AS 
BEGIN
  open i for select * from movie
  where (extract(YEAR from release_date) > extract(YEAR from to_date(d, 'YYYY')));
  
  Exception
  when no_data_found then  i := NULL;--renvoyer null
END RechercheDateE;

--ReadNumber
create or replace PROCEDURE READNUMBER (IDFILM IN NUMBER, P OUT NUMBER) AS 
BEGIN
  select count(po) into p from vote where movie = idfilm;
  
  Exception
  when no_data_found then  p := 0;--renvoyer null
END READNUMBER;

--ProcVote
create or replace PROCEDURE PROCVOTE (P IN NUMBER, IDUSER IN NUMBER, IDFILM IN NUMBER ) AS 
i number;
BEGIN
  select us into i from vote where us = iduser and movie = idfilm;
  
  update vote set po = p where us = iduser and movie = idfilm;
  update movie set vote_average = (select avg(po) from vote where us = iduser and movie = idfilm group by movie) where id = idfilm;
  
  Exception
    when NO_DATA_FOUND then insert into vote(us, movie, po) values (iduser, idfilm, p);
END PROCVOTE;

--ReadCommentaire
create or replace PROCEDURE READCOMMENTAIRE (IDUSER IN NUMBER, IDFILM IN NUMBER, STRING OUT VARCHAR2 ) AS 
BEGIN
  select com into string from commentaire where us = iduser and idfilm = movie;
  
  Exception
  when no_data_found then string := '';
END READCOMMENTAIRE;

--ProcCommentaire
create or replace PROCEDURE PROCCOMMENTAIRE (C IN VARCHAR2, IDUSER IN NUMBER, IDFILM IN NUMBER) AS 
i number;
BEGIN
  select us into i from commentaire where us = iduser and movie = idfilm;
  
  update commentaire set com = c where us = iduser and movie = idfilm;
  commit;
  
  Exception
  when no_data_found then insert into commentaire(us, movie, com) values (iduser, idfilm, c);
    
END PROCCOMMENTAIRE;

--CreaCB avec table vote et commmentaire
drop table vote;
drop table commentaire;
DROP TABLE MOVIE_GENRE CASCADE CONSTRAINTS;
DROP TABLE MOVIE_DIRECTOR CASCADE CONSTRAINTS;
DROP TABLE MOVIE_ARTIST CASCADE CONSTRAINTS;
DROP TABLE GENRE CASCADE CONSTRAINTS;
DROP TABLE ARTIST CASCADE CONSTRAINTS;
DROP TABLE MOVIE CASCADE CONSTRAINTS;
DROP TABLE STATUT CASCADE CONSTRAINTS;
DROP TABLE CERTIFICATION CASCADE CONSTRAINTS;
DROP TABLE DIRECTOR CASCADE CONSTRAINTS;
DROP TABLE LOG;
DROP TABLE Utilisateur;

CREATE TABLE ARTIST
(
  id              NUMBER(9) CONSTRAINT CP_ARTIST PRIMARY KEY,
  name            VARCHAR2(50 CHAR) NOT NULL
);

CREATE TABLE STATUT
(
  id              NUMBER(6) CONSTRAINT CP_STATUT PRIMARY KEY,
  stat            VARCHAR2(8 CHAR)
);

CREATE TABLE CERTIFICATION
(
  id              NUMBER(6) CONSTRAINT CP_CERTIFICATION PRIMARY KEY,
  certif          VARCHAR2(5 CHAR)
);

CREATE TABLE MOVIE
(
  id              NUMBER(6) CONSTRAINT CP_MOVIE PRIMARY KEY,
  title           VARCHAR2(59 CHAR) NOT NULL,
  statut          VARCHAR2(15 CHAR),
  overview        VARCHAR2(174 CHAR),
  release_date    DATE,
  vote_average    NUMBER(2),
  certification varchar2(5 char),
  runtime         NUMBER(3),
  budget          NUMBER(8),
  poster_path     BLOB
);

CREATE TABLE GENRE
(
  id              NUMBER(6) CONSTRAINT CP_GENRE PRIMARY KEY,
  nomGenre        VARCHAR2(16 CHAR) NOT NULL
);

CREATE TABLE DIRECTOR
(
  id              NUMBER(9) CONSTRAINT CP_DIRECTOR PRIMARY KEY,
  name            VARCHAR2(49 CHAR) NOT NULL
);

CREATE TABLE MOVIE_ARTIST
(
  movie           NUMBER(6),
  artist          NUMBER(9),
  CONSTRAINT FKMAM FOREIGN KEY (movie) REFERENCES movie(id),
  CONSTRAINT FKMAA FOREIGN KEY (artist) REFERENCES artist(id)
);

CREATE TABLE MOVIE_GENRE
(
  movie           NUMBER(6), 
  genre           NUMBER(6), 
  CONSTRAINT FKMGM FOREIGN KEY (movie) REFERENCES movie(id),
  CONSTRAINT FKMGG FOREIGN KEY (genre) REFERENCES genre(id)
);

CREATE TABLE MOVIE_DIRECTOR
(
  movie           NUMBER(6), 
  director        NUMBER(9),
  CONSTRAINT FKMDM FOREIGN KEY (movie) REFERENCES movie(id),
  CONSTRAINT FKMDD FOREIGN KEY (director) REFERENCES director(id)
);

CREATE TABLE LOG
(
  err             VARCHAR2(200),
  daterr          DATE
);

create table Utilisateur(
  Id integer,
  Login varchar2(20 char),
  Password varchar2(20 char),
  
  constraint Id$Utilisateur$PrimaryKey primary key (Id),
  constraint Login$Check check (Login is not null),
  constraint Password$Check check (Password is not null)
);

create table vote(
  us number,
  movie number,
  po number,
  
  CONSTRAINT User$Vote FOREIGN KEY (us) REFERENCES utilisateur(id),
  CONSTRAINT Movie$Vote FOREIGN KEY (movie) REFERENCES movie(id)
);

create table commentaire(
  us number,
  movie number,
  com varchar2(500),
  
  CONSTRAINT User$Commentaire FOREIGN KEY (us) REFERENCES utilisateur(id),
  CONSTRAINT Movie$Commentaire FOREIGN KEY (movie) REFERENCES movie(id)
);

/*
DELETE FROM MOVIE_GENRE;
DELETE FROM MOVIE_DIRECTOR;
DELETE FROM MOVIE_ARTIST;
DELETE FROM GENRE;
DELETE FROM ARTIST;
DELETE FROM MOVIE;
DELETE FROM STATUT;
DELETE FROM CERTIFICATION;
DELETE FROM DIRECTOR;
DELETE FROM LOG;