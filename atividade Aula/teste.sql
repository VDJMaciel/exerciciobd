drop database if exists teste;
create database if not exists teste;
use teste;

create table departamento (
	coddepart int,
	nome varchar(40),
    constraint pk primary key(coddepart)
)engine = innodb;

create table curso (
	codcurso int,
    nome varchar(40),
    cargahoraria int,
    constraint pk primary key (codcurso)
)engine = innodb;

create table vinculo (
	codcurso int,
    coddepart int,
    constraint pk primary key (codcurso, coddepart)
)engine = innodb;

create table aluno (
	cpf varchar(13),
    nome varchar(40),
    datanasc Date,
    sexo enum ('f', 'm'),
    constraint pk primary key (cpf)
)engine = innodb;

create table matriculaaluno (
	cpf varchar(13),
    codcurso int,
    matricula int,
    constraint pk primary key (cpf, codcurso, matricula)
)engine = innodb;

create table funcionario (
	matricula int,
    nome varchar(40),
    regimehoras enum ('40', '20', '30', 'DE'),
    coddepart int,
    sexo enum ('f', 'm'),
    constraint pk primary key (matricula)
)engine = innodb;

create table professor (
	matricula int,
    classe varchar(20),
    constraint pk primary key (matricula)
)engine = innodb;

-- ADD FOREIGN KEYS
alter table vinculo
	add constraint fk1
    foreign key (codcurso)
    references curso(codcurso);
    
alter table vinculo
	add constraint fk2
    foreign key (coddepart)
    references departamento (coddepart);
    
alter table matriculaaluno
	add constraint fk3
    foreign key (codcurso)
    references curso (codcurso);

alter table matriculaaluno
	add constraint fk4
    foreign key (cpf)
    references aluno (cpf);
    
alter table funcionario
	add constraint fk5
    foreign key (coddepart)
    references departamento (coddepart);

alter table professor
	add constraint fk6
    foreign key (matricula)
    references funcionario (matricula);
-- -----------------
-- 1
select * from curso;

-- 2
select curso.nome
	from vinculo join curso
    on vinculo.codcurso = curso.codcurso
    join departamento
    on vinculo.coddepart = departamento.coddepart
    where departamento.nome = "Exatas";

-- 2.1
select funcionario.nome from funcionario where funcionario.coddepart = 3;

-- 2.2
select funcionario.nome from funcionario 
	where funcionario.coddepart = 
		(select departamento.coddepart 
		from departamento where departamento.nome = "Exatas");

-- 3
select vinculo.coddepart, count(*) from vinculo group by vinculo.coddepart;

-- 4
select vinculo.coddepart, departamento.nome, count(*) 
	from vinculo left join departamento
    on vinculo.coddepart = departamento.coddepart
    group by vinculo.coddepart 
    order by departamento.nome
;

-- 5
select curso.nome from curso
	where curso.cargahoraria = (select max(curso.cargahoraria) from curso);
    
-- 6
