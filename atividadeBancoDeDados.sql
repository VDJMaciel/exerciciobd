drop database if exists atividadebd;
create database if not exists atividadebd;
use atividadebd;
-- ---------------------------------------------------------
-- DDL: 1- Criação das tabelas com suas chaves primarias

create table departamento (
	cod_departamento int,
	descricao varchar(30),
    constraint pkdepartamento primary key (cod_departamento)
) engine = innodb;

create table funcionario (
	cod_funcionario int auto_increment, 
    nome varchar(30),
    constraint pkfuncionario primary key (cod_funcionario),
    -- será foreign key:
    cod_departamento int
)engine = innodb;

create table tipoEquipamento (
	cod_tipo_equipamento int auto_increment,
    descricao varchar(30),
    constraint pktipoequipamento primary key (cod_tipo_equipamento)
)engine = innodb;

create table equipamento (
	etiqueta char(15),
    marca varchar(20),
    descricao varchar(30),
    dataAquisicao Date,
    constraint pkequipamento primary key (etiqueta),
    -- será foreign key:
    cod_tipo_equipamento int,
    cod_departamento int
)engine = innodb;

create table avaria (
	cod_avaria int auto_increment,
    descricao varchar(30),
    data_avaria Date,
    constraint pkavaria primary key (cod_avaria),
    -- será foreign key:
    etiqueta char(15),
    cod_funcionario int
)engine = innodb;

create table intervencao (
	cod_intervencao int auto_increment,
    descricao varchar(30),
    data_intervencao Date,
    constraint pkintervencao primary key (cod_intervencao),
    -- será foreign key:
    cod_avaria int,
    cod_funcionario int
)engine = innodb;

-- ------------------------------------------------------------
-- DDL: 2- Adicionando as constraints que definem as foreign keys:

alter table funcionario 
	add constraint fk_funcionario_departamento
	foreign key (cod_departamento) 
    references departamento (cod_departamento)
    on delete restrict;
    
alter table equipamento
	add constraint fk_equipamento_tipo_equipamento
    foreign key (cod_tipo_equipamento)
    references tipoEquipamento (cod_tipo_equipamento);
    
alter table equipamento
	add constraint fk_equipamento_departamento
    foreign key (cod_departamento)
    references departamento (cod_departamento);
    
alter table avaria
	add constraint fk_avaria_equipamento
    foreign key (etiqueta)
    references equipamento (etiqueta);
    
alter table avaria
	add constraint fk_avaria_funcionario
    foreign key (cod_funcionario)
    references funcionario (cod_funcionario);
    
alter table intervencao
	add constraint fk_intervencao_avaria
    foreign key (cod_avaria)
    references avaria (cod_avaria);
    
alter table intervencao
	add constraint fk_intervencao_funcionario
    foreign key (cod_funcionario)
    references funcionario (cod_funcionario);
    
-- DDL: 3- Alterar Funcionario para que nome seja Not Null

alter table funcionario
	modify column nome varchar(30) not null;
    
-- DDL: 4- Apagar e adicionar a constraint foreign key de avaria

alter table avaria
	drop foreign key fk_avaria_equipamento;
    
alter table avaria
	drop foreign key fk_avaria_funcionario;
    
alter table avaria
	add constraint fk_avaria_equipamento
    foreign key (etiqueta)
    references equipamento (etiqueta);
    
alter table avaria
	add constraint fk_avaria_funcionario
    foreign key (cod_funcionario)
    references funcionario (cod_funcionario);
    
-- DDL: 5 e 6- Criar um domínio DOMSEXO que pode receber (F, f, M, m), e uma coluna em 
-- funcionario com um atributo sexo que possui esse dominio.

-- o MySQL não suporta criação de domínios, portanto o mais próximo disso que dá pra fazer é:

alter table funcionario
	add column sexo enum ('F', 'M'); -- não há diferença entre 'F' e 'f'

-- DDL: 7 - Tentar apagar a tabela departamento com a opção restrict para ver que dá erro

 insert into departamento (cod_departamento, descricao) value (101, "Contabilidade");
 insert into funcionario (nome, cod_departamento) value ("jorge", 101);
 delete from departamento where cod_departamento = 101; -- DÁ ERRO!
 delete from funcionario where cod_funcionario = 1;
 delete from departamento where cod_departamento = 101; -- DÁ CERTO!

-- ----------------- DML --------------------
-- DML: 8- Inserir dados em todas as tabelas

insert into departamento 
	(cod_departamento, descricao)
	values
    (101, "Contabilidade"),
    (102, "Comercial"),
    (103, "Recursos Humanos"),
    (104, "Informática"),
    (105, "Gerência");
    
insert into funcionario
	(nome, cod_departamento, sexo)
    values
    ("Cláudia Pinto", 101, 'f'),
    ("Paulo Mendes", 101, 'M'),
    ("Ricardo Freitas", 102, 'm'),
    ("Catarina Rios", 105,'F'),
    ("Ana Souza", 103, 'f'),
    ("Fernanda Freire", 103, 'f');    
    
insert into tipoEquipamento 
	(descricao)
    values
    ("Computador"),
    ("Impressora"),
    ("Fax"),
    ("Monitor"),
    ("Fotocopiadora");
    
insert into equipamento
	(etiqueta, marca, descricao, dataAquisicao, cod_tipo_equipamento, cod_departamento)
    values
    ("PC001CTB", "HP", "Computador DualCore 200GB", '2011-02-03', 1, 101),
    ("PC002CTB", "HP", "Computador DualCore 200GB", '2011-02-03', 1, 101),
    ("PC001INF", "HP", "Computador DualCore 500GB", '2011-02-03', 1, 104),
    ("PC002INF", "HP", "Computador DualCore 500GB", '2011-02-03', 1, 104),
    ("IMP001INF", "HP", "Impressora HP Laserjet", '2011-02-03', 2, 104);
    
insert into avaria
	(descricao, data_avaria, etiqueta, cod_funcionario)
    values
    ("O computador não liga", '2011-02-03', "PC001CTB", 2),
    ("Trocar o tonner", '2011-02-03', "IMP001INF", 3),
    ("Não imprime nada colorido", '2011-02-03', "IMP001INF", 4),
    ("Computador com vírus", '2011-02-03', "PC002INF", 3),
    ("Monitor piscando", '2011-02-03', "PC001CTB", 5);
    
insert into intervencao
	(descricao, data_intervencao, cod_avaria, cod_funcionario)
    values
    ("Trocada a placa mãe", '2011-02-05', 1, 1),
    ("Trocado o tonner", '2011-02-05', 2, 3),
    ("Trocado o tonner", '2011-02-05', 3, 4),
    ("Feito o factory reset", '2011-02-05', 4, 3),
    ("Trocado o cabo de vídeo", '2011-02-05', 5, 5);
    
-- DML: 9- Criar cópias das tabelas utilizando create com select

create table departamentocopia select * from departamento;
create table funcionariocopia select * from funcionario;
create table tipoequipamentocopia select * from tipoequipamento;
create table equipamentocopia select * from equipamento;
create table avariacopia select * from avaria;
create table intervencaocopia select * from intervencao;

-- DML: 10- Deletar todos os funcionários

 delete from intervencao;
 delete from avaria;
 delete from funcionario;

-- DML: 11- Deletar equipamentos "informática"

 delete from equipamento where cod_departamento = 104;

-- DML: 12- Atualizar equipamentos para "samsung"

update equipamento
	set marca = "samsung";

-- DML: 13- todos ricardos -> departamento 101

update funcionario
	set cod_departamento = 101
    where nome like "Ricardo";

-- DML: 14- todos ricardos -> departamento informática

update funcionario
	set cod_departamento = 104
    where nome like "Ricardo";

-- DML: 15- selecionar todos os funcionários

select * from funcionario;

-- DML: 16- selecionar funcionários do departamento comercial

select * from funcionario where cod_departamento = 102;

-- DML: 17- selecionar equipamentos da categoria computador

select * from equipamento where cod_tipo_equipamento = 1;

-- DML: 18- selecionar o nome de todos os funcionarios responsáveis pelo cadastro das avarias

select funcionario.nome, avaria.cod_avaria 
from funcionario right join avaria
on funcionario.cod_funcionario = avaria.cod_funcionario;
    
-- PARTE 2 DA ATIVIDADE
-- ---------------------------------------------------------------------------------------------------------
-- 1: Quantidade de funcionários por departamento, exibindo o nome do departamento e, ao lado, a quantidade

select departamento.descricao as departamento, count(*) as quantidade
from departamento join funcionario
where funcionario.cod_departamento = departamento.cod_departamento
group by departamento.cod_departamento;

-- 2: Adicionar salario à funcionario

alter table funcionario
add column salario float;

-- 3: Mostrar o maior salario, o menor, a soma e a média salarial

select max(salario) as maior, min(salario) as menor, sum(salario) as soma, avg(salario) as media
from funcionario;

-- 4: Adicionar quatro avarias

insert into avaria
	(descricao, data_avaria, etiqueta, cod_funcionario)
    values
    ("O computador está com virus", '2011-02-03', "PC001CTB", 2),
    ("Impressora fazendo ruído", '2011-02-03', "IMP001INF", 3),
    ("Papel atolado", '2011-02-03', "IMP001INF", 4),
    ("Computador desligando sozinho", '2011-02-03', "PC002INF", 3);
    
-- 5: Funcionarios e quantidade de avarias

select funcionario.nome, count(avaria.cod_avaria) as "quantidade de avarias"
from funcionario left join avaria
on funcionario.cod_funcionario = avaria.cod_funcionario
group by funcionario.nome;

-- 6: Mostre as intervenções, seguidas dos nomes dos funcionarios, descrição e data das avarias

select intervencao.cod_intervencao as "Intervenção", 
		funcionario.nome as "Funcionário responsável", 
		intervencao.descricao as "Descrição da Intervenção", 
		avaria.data_avaria as "Data da avaria" 
from intervencao left join funcionario
on intervencao.cod_funcionario = funcionario.cod_funcionario
left join avaria
on intervencao.cod_avaria = avaria.cod_avaria;

-- 7: Isolar o ano de uma data

select extract(year from equipamento.dataAquisicao) from equipamento;

-- 8: Usar agrupamento para:
-- 8.1: Mostrar quantidade de equipamentos adquiridos por ano

select extract(year from equipamento.dataAquisicao) as "Ano", 
		count(*) as "Equipamentos Adquiridos"
from equipamento
group by ano;

-- 8.2: Mostrar quantidade de equipamentos para cada descrição do equipamento

select equipamento.descricao, count(*) as "Quantidade"
from equipamento
group by equipamento.descricao; 

-- 8.3: 


-- 9: Selecionar nome dos funcionarios que recebem o maior salario
select funcionario.nome
from funcionario
where funcionario.salario = (select max(funcionario.salario) from funcionario);

-- 10: Selecionar com o in as avarias nos equipamentos do tipo computador
select * from avaria;

select * from avaria
where "PC" in avaria.etiqueta




    









