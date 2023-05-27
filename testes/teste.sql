-- selecionar todas as pessoas da tabela pessoa

SELECT * FROM pessoa;

-- criar tabela escola

CREATE TABLE escola (
    id_escola SERIAL PRIMARY KEY,
    nome_escola VARCHAR(255) NOT NULL,
    endereco VARCHAR(255) NOT NULL,
    telefone VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL
);

-- insira valoes na tabela escola

INSERT INTO escola (nome_escola, endereco, telefone, email)
VALUES ('Escola Estadual', 'Rua 1', '123456789', 'teste@gmail.com');

-- selecionar todas as escolas da tabela escola

SELECT * FROM escola;

-- crie um INDEX para selecionar todas as pessoas da tabela pessoa

CREATE INDEX idx_pessoa_nome ON pessoa (nome);

create index on pessoa (nome);


-- insira 5 valores na tabela pessoa (cpf, idade e nome)

INSERT INTO pessoa (cpf, idade, nome)
VALUES('1', 20, 'Joao'),
('2', 30, 'Maria'),
('3', 40, 'José'),
('4', 50, 'Ana'),
('5', 60, 'Pedro');

-- use o expain para analizar como o comando sql é executado

EXPLAIN ANALYSE SELECT * FROM pessoa WHERE nome = 'Joao';

-- Crie uma tabela chamada projeto, que possui id, nome e capital, que esta relacionada a outras duas tabelas chamadas desenvolvedor e linguagem de programacao, utilizando chave estrangeira

CREATE TABLE projeto (
    id_projeto SERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    capital VARCHAR(255) NOT NULL,
    id_desenvolvedor INT NOT NULL,
    id_linguagem INT NOT NULL,
    FOREIGN KEY (id_desenvolvedor) REFERENCES desenvolvedor(id_desenvolvedor),
    FOREIGN KEY (id_linguagem) REFERENCES linguagem(id_linguagem)
);

--popule a tabela projeto com 5 valores

INSERT INTO projeto (nome, capital, id_desenvolvedor, id_linguagem)
VALUES ('Projeto 1', '1000', 1, 1),
('Projeto 2', '2000', 2, 2),
('Projeto 3', '3000', 3, 3),
('Projeto 4', '4000', 4, 4),
('Projeto 5', '5000', 5, 5);