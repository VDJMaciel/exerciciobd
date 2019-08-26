create database if not exists atividadebd;
use atividadebd;
-- ---------------------------------------------------------
-- DDL: 1- Criação das tabelas com suas chaves primarias

create table departamento (
	cod_departamento int primary key,
	descricao varchar(30)
);

create table funcionario (
	cod_funcionario int primary key auto_increment,
    nome varchar(30),
    -- será foreign key:
    cod_departamento int
);

create table tipoEquipamento (
	cod_tipo_equipamento int primary key auto_increment,
    descricao varchar(30)
);

create table equipamento (
	etiqueta char(8) primary key,
    marca varchar(20),
    descricao varchar(30),
    dataAquisicao Date,
    -- será foreign key:
    cod_tipo_equipamento int,
    cod_departamento int
);

create table avaria (
	cod_avaria int primary key auto_increment,
    descricao varchar(30),
    data_avaria Date,
    -- será foreign key:
    etiqueta int,
    cod_funcionario int
);

create table intervencao (
	cod_intervencao int primary key auto_increment,
    descricao varchar(30),
    data_intervencao Date,
    -- será foreign key:
    cod_avaria int,
    cod_funcionario int
);

-- ------------------------------------------------------------
-- DDL: 2- Adicionando as constraints que definem as foreign keys:

alter table funcionario 
	add constraint fk_cod_departamento 
	foreign key (cod_departamento) 
    references departamento (cod_departamento);
    
alter table equipamento
	add constraint fk_cod_tipo_equipamento
    foreign key (cod_tipo_equipamento)
    references tipoEquipamento (cod_tipo_equipamento);

alter table equipamento
    add constraint fk_cod_departamento
    foreign key (cod_departamento)
    references departamento (cod_departamento);
    
alter table avaria
	add constraint fk_etiqueta
    foreign key (etiqueta)
    references equipamento (etiqueta);
    
alter table avaria
	add constraint fk_cod_funcionario
    foreign key (cod_funcionario)
    references funcionario (cod_funcionario);
    
alter table intervencao
	add constraint fk_cod_avaria
    foreign key (cod_avaria)
    references avaria (cod_avaria);
    
alter table intervencao
	add constraint fk_cod_funcionario
    foreign key (cod_funcionario)
    references funcionario (cod_funcionario);
    
-- DDL: 3- Alterar Funcionario para que nome seja Not Null

alter table funcionario
	modify column nome varchar(30) not null;
    
-- DDL: 4- Apagar e adicionar a constraint foreign key de avaria

alter table avaria
	drop foreign key fk_etiqueta;
    
alter table avaria
	drop foreign key fk_cod_funcionario;

alter table avaria
	add constraint fk_etiqueta
    foreign key (etiqueta)
    references equipamento (etiqueta);
    
alter table avaria
	add constraint fk_cod_funcionario
    foreign key (cod_funcionario)
    references funcionario (cod_funcionario);
    
-- DDL: 5 e 6- Criar um domínio DOMSEXO que pode receber (F, f, M, m), e uma coluna em 
-- funcionario com um atributo sexo que possui esse dominio.

-- o MySQL não suporta criação de domínios, portanto o mais próximo disso que dá pra fazer é:

alter table funcionario
	add column sexo enum ('F', 'M'); -- não há diferença entre 'F' e 'f'

-- DDL: 7 - Apagar a tabela departamento com a opção restrict

