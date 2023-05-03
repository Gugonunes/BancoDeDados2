create table Cliente(
	cpf varchar(11) not null primary key,
	nome varchar(30) not null,
	telefone1 varchar(13) not null,
	telefone2 varchar(13),
	telefone3 varchar(13)
);

create table Funcionario(
	cpf varchar(11) not null primary key,
	nome varchar(30) not null,
	funcao varchar(30) not null
);

create table Carro(
	codigo_carro varchar(17) not null primary key,
	modelo varchar(30) not null,
	cor varchar(15) not null,
	ano varchar(4) not null
);

create table Financiamento(
	cod_financiamento SERIAL not null primary key,
	descricao varchar(300),
	qtd_parcelas int not null,
	valor_parcela decimal(5,2) not null,
	tipo_financiamento varchar(30),
	ativo boolean not null
);

create table ContratoFinanciamento(
    cod_contrato SERIAL not null primary key,
    cpf_cliente varchar(11) not null,
    cod_financiamento int not null,
    FOREIGN KEY (cpf_cliente) REFERENCES Cliente(cpf),
    FOREIGN KEY (cod_financiamento) REFERENCES Financiamento(cod_financiamento)
);

create table Venda(
    cod_contrato SERIAL not null primary key,
    data1 TIMESTAMP not null,
    data2 TIMESTAMP,
    data3 TIMESTAMP,
    valor_venda decimal(8,2) not null,
    valor_parcela decimal(5,2),
    cpf_cliente varchar(11) not null,
    cod_carro varchar(17) not null,
    cod_funcionario varchar(11) not null,
    FOREIGN KEY (cpf_cliente) REFERENCES Cliente(cpf),
    FOREIGN KEY (cod_carro) REFERENCES Carro(codigo_carro),
    FOREIGN KEY (cod_funcionario) REFERENCES Funcionario(cpf)
);

-- Inserindo alguns dados
insert into Cliente values('12345678901', 'Joao', '12345678901', '12345678901', '12345678901');
insert into Cliente values('12345678902', 'Maria', '12345678902', '12345678902', '12345678902');
insert into Cliente values('12345678903', 'Jose', '12345678903', '12345678903', '12345678903');

insert into Funcionario values('12345678901', 'Joao', 'Vendedor');
insert into Funcionario values('12345678902', 'Maria', 'Vendedor');
insert into Funcionario values('12345678903', 'Jose', 'Vendedor');

insert into Carro values('12345678901234567', 'Fusca', 'Azul', '1970');
insert into Carro values('12345678901234568', 'Fusca', 'Azul', '1970');
insert into Carro values('12345678901234569', 'Fusca', 'Azul', '1970');

insert into Financiamento values(1, 'Financiamento 1', 12, 100.00, 'Financiamento', true);
insert into Financiamento values(2, 'Financiamento 2', 12, 200.00, 'Financiamento', true);
insert into Financiamento values(3, 'Financiamento 3', 12, 300.00, 'Financiamento', true);

insert into ContratoFinanciamento values(1, '12345678901', 1);
insert into ContratoFinanciamento values(2, '12345678902', 2);
insert into ContratoFinanciamento values(3, '12345678903', 3);

insert into Venda values(1, '2019-01-01 00:00:00', '2019-01-01 00:00:00', '2019-01-01 00:00:00', 10000.00, 100.00, '12345678901', '12345678901234567', '12345678901');
insert into Venda values(2, '2019-01-01 00:00:00', '2019-01-01 00:00:00', '2019-01-01 00:00:00', 10000.00, 150.00, '12345678902', '12345678901234568', '12345678902');
insert into Venda values(3, '2019-01-01 00:00:00', '2019-01-01 00:00:00', '2019-01-01 00:00:00', 10000.00, 180.00, '12345678903', '12345678901234569', '12345678903');


SELECT * FROM CARRO;
SELECT * FROM CLIENTE;
SELECT * FROM FUNCIONARIO;
SELECT * FROM FINANCIAMENTO;
SELECT * FROM CONTRATOFINANCIAMENTO;
SELECT * FROM VENDA;