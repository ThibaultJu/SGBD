DROP TABLE MOVIE_GENRE CASCADE CONSTRAINTS;
DROP TABLE MOVIE_DIRECTOR CASCADE CONSTRAINTS;
DROP TABLE MOVIE_ACTOR CASCADE CONSTRAINTS;
DROP TABLE GENRE CASCADE CONSTRAINTS;
DROP TABLE ARTIST CASCADE CONSTRAINTS;
DROP TABLE MOVIE CASCADE CONSTRAINTS;
DROP TABLE STATUS CASCADE CONSTRAINTS;
DROP TABLE CERTIFICATION CASCADE CONSTRAINTS;
DROP TABLE DIRECTOR CASCADE CONSTRAINTS;
DROP TABLE LOG;

create table artist (
  id   number(7,0),
  name varchar2(20),
  constraint artist$pk primary key (id),
  constraint artist$name$nn check (name is not null)
);

create table certification (
  id          number(6,0),
  name        varchar2(5),
  constraint cert$pk primary key (id),
  constraint cert$name$nn check (name is not null)
);
create table director 
(
  id   number(7,0),
  name varchar2(19),
  constraint director$pk primary key (id),
  constraint director$name$nn check (name is not null)
);
create table status (
  id          number(6,0),
  name        varchar2(15),
  constraint status$pk primary key (id),
  constraint status$name$nn check (name is not null)
);

create table genre (
  id   number(5,0),
  name varchar2(16),
  constraint genre$pk primary key (id),
  constraint genre$name$nn check (name is not null),
  constraint genre$name$un unique (name)  
);

create table movie (
  id            number(6,0),
  title         varchar2(43),
  status        VARCHAR2(15 CHAR),
  release_date  date,
  vote_average  number(2,1),
  vote_count    number(5,0),
  certification VARCHAR2(5),
  runtime       number(5,0),
  poster        blob,
  constraint movie$pk primary key (id),
  constraint movie$title$nn check (title is not null),
  constraint movie$runtime$pg check (runtime>=0),
  constraint movie$vote_average$zeroadix check (vote_average>=0 AND vote_average<=10)
);

create table movie_director (
  movie    number(6,0),
  director number(7,0),
  constraint m_d$pk primary key (movie, director),
  constraint m_d$fk foreign key (director) references director(id),
  constraint m_d$fk2 foreign key (movie) references movie(id)
);

create table movie_genre (
  genre number(5,0),
  movie number(6,0),
  constraint m_g$pk primary key (genre, movie),
  constraint m_g$fk foreign key (genre) references genre(id),
  constraint m_g$fk2 foreign key (movie) references movie(id)
  ) ;

create table movie_actor
  (
  movie  number(6,0),
  actor number(7,0),
  constraint m_a$pk primary key (movie, actor),
  constraint m_a$fk foreign key (actor) references artist(id),
  constraint m_a$fk2 foreign key (movie) references movie(id)
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