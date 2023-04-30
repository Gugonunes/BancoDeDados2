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