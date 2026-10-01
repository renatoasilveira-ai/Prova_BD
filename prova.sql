create table aeronaves (
	id serial primary key,
	modelo varchar(100) not null,
	codigo_cauda varchar(10) unique not null,
	capacidade int not null check (capacidade > 0)
);

create table pilotos (
	id serial primary key,
	nome varchar(150) not null,
	codigo_anac varchar(6) unique not null,
	horas_voo int default 0 check (horas_voo >= 0)
);

create table voos (
	id serial primary key,
	aeronave_id int REFERENCES aeronaves(id),
	piloto_id int REFERENCES pilotos(id),
	numero_voo varchar(50) not null,
	origem varchar(150) not null,
	destino varchar(150) not null,
	data_hora TIMESTAMP default current_timestamp,
	status varchar(50) default 'agendado' CHECK (status in ('agendado', 'em voo', 'concluido', 'cancelado'))
);

create table passageiros (
	id serial primary key,
	nome varchar(150) not null,
	cpf varchar(11) unique not null,
	email varchar(150) unique not null
);

create table passagens (
	id serial primary key,
	voo_id int REFERENCES voos(id),
	passageiro_id int REFERENCES passageiros(id),
	assento varchar(4) not null,
	classe varchar(50) default 'economica' check (classe in ('economica', 'executiva')),
	valor decimal(10,2) CHECK (valor > 0)
);

insert into aeronaves (modelo,codigo_cauda,capacidade) VALUES
('um',0123456789,200),
('dois',1123456789,100),
('tres',2123456789,200),
('quatro',3123456789,100),
('cinco',4123456789,150);

insert into pilotos (nome,codigo_anac,horas_voo) values 
('carlos','123456',10),
('artur','223456',15),
('renato','323456',20),
('gabriel','423456',25),
('antonio','523456',30);

insert into passageiros (nome,cpf,email) values
('benedito','01234567890','benedito@email'),
('anderson','11234567890','anderson@email'),
('jair','21234567890','jair@email'),
('robson','31234567890','robson@email'),
('evair','41234567890','evair@email');

insert into voos (numero_voo,origem,destino,status) VALUES
('10','brasil','italia','agendado'),
('20','italia','brasil','em voo'),
('30','espanha','eua','agendado'),
('40','eua','israel','cancelado'),
('50','russia','ucrania','concluido');

insert into passagens (assento,classe,valor) values
('a14','economica',350.00),
('b14','economica',350.00),
('c14','executiva',900.00),
('d14','economica',500.00),
('e14','executiva',1000.00);


select
	v.numero_voo as voos,
	v.origem,
	v.destino,
	a.modelo as aeronaves,
	pil.nome as pilotos
from voos v 
	join aeronaves a on a.id = v.aeronave_id
	join pilotos pil on pil.id = v.piloto_id
where v.status = 'agendado' or v.status = 'em voo'
group by v.id,a.id,pil.id

select
	p.nome as passageiros,
	v.numero_voo as voos,
	pas.assento as passagens,
	pas.valor
from passagens pas
	join voos v on v.id = pas.voo_id
	join passageiros p on p.id = pas.passageiro_id
where pas.classe = 'executiva'
GROUP by p.nome,v.id,pas.id

CREATE view  vw_painel_aeroporto as
select
	v.numero_voo as voos,
	v.data_hora,
	v.origem,
	v.destino,
	a.modelo as aeronaves,
	a.codigo_cauda,
	pil.nome as pilotos
from voos v 
	join aeronaves a on a.id = v.aeronave_id
	join pilotos pil on pil.id = v.piloto_id
where v.status = 'agendado' or v.status = 'em voo'
group by v.id,a.id,pil.id