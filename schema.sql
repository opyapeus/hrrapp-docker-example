create schema master;
create table master.company
(
    id integer primary key,
    name text not null,
    establishment_year smallint not null,
    created_at timestamp not null
);
