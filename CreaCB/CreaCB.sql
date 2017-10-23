drop table artist;
drop table certification;
drop table status;
drop table genre;
drop table movie;
drop table movie_director;
drop table movie_genre;
drop table movie_actor;

create table artist (
  id   number(7,0),
  name varchar2(19),
  constraint artist$pk primary key (id),
  constraint artist$name$nn check (name is not null)
);

create table certification (
  id          number,
  name        varchar2,
  description varchar2,
  constraint cert$pk primary key (id),
  constraint cert$name$nn check (name is not null),
  constraint cert$name$un unique (name)
);

create table status (
  id          number(1,0),
  name        varchar2,
  constraint status$pk primary key (id),
  constraint status$name$nn check (name is not null),
  constraint status$name$un unique (name)
);

create table genre (
  id   number(5,0),
  name varchar2(11),
  constraint genre$pk primary key (id),
  constraint genre$name$nn check (name is not null),
  constraint genre$name$un unique (name)  
);

create table movie (
  id            number(6,0),
  title         varchar2(43),
  status        number(1,0),
  release_date  date,
  vote_average  number(2,2),
  vote_count    number(5,0),
  certification number(2,0),
  runtime       number(5,0),
  poster        blob,
  constraint movie$pk primary key (id),
  constraint movie$title$nn check (title is not null)
  constraint movie$runtime$pg check (runtime>0)
);

create table movie_director (
  movie    number(6,0),
  director number(7,0),
  constraint m_d$pk primary key (movie, director)
);

create table movie_genre (
  genre number(5,0),
  movie number(6,0),
  constraint m_g$pk primary key (genre, movie)
  ) ;

create table movie_actor
  (
  movie  number(6,0),
  actor number(7,0),
  constraint m_a$pk primary key (movie, actor)
);