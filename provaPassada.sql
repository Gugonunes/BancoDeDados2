-- Responda verdadeiro ou falso as seguintes afirmaçoes. Justifique as falsas.
-- Quanto mais ındices uma tabela tiver, mais rapidas serao as consultas e inserçoes de dados.
-- Resposta: Falso, pois quanto mais indices uma tabela tiver, mais lenta serao as consultas e inserçoes de dados.

-- O SGBD otimiza um comando SELECT utilizando regras algebricas e analise de custo para determinar o melhor plano de consulta.
-- Resposta: Verdadeiro, pois o SGBD otimiza um comando SELECT utilizando regras algebricas e analise de custo para determinar o melhor plano de consulta.

-- E importante criar ındices para chaves primarias para agilizar as consultas sobre ela.
-- Resposta: Falso, pois e importante criar ındices para chaves estrangeiras para agilizar as consultas sobre ela.

-- Um ındice B-tree e o melhor para indexar todos os tipos de atributos
-- Resposta: Falso, pois um ındice B-tree e o melhor para indexar atributos que possuem valores distintos.

-- Um comando create table é traduzido para uma sequencia de inserts no dicionario de dados e uma alocaçao fısica nos tablespaces
-- Resposta: Verdadeiro, pois o comando create table e traduzido para uma sequencia de inserts no dicionario de dados e uma alocaçao fısica nos tablespaces.

-- Uma transação serializável não pode ver os dados que outra transação esta modificando.
-- Resposta: Falso, pois uma transação serializável pode ver os dados que outra transação esta modificando.

-- Sempre que uma transaçao T1 modifica um dado, nenhuma outra transaçao T2 concorrente tem acesso a ele, mesmo se T1 confirmar.
-- Resposta: Falso, pois sempre que uma transaçao T1 modifica um dado, nenhuma outra transaçao T2 concorrente tem acesso a ele, mesmo se T1 abortar.

-- Um ındice sempre indexa todas as tuplas de uma tabela, nao sendo possıvel indexar somente algumas.
-- Resposta: Falso, pois um ındice pode indexar somente algumas tuplas de uma tabela.

-- Uma pequena empresa deseja controlar os seus projetos e a atribuiçao dos desenvolvedores.
-- Para cada projeto sao cadastradas as linguagens de programaçao utilizadas e os desenvolvedores que participam.

-- Projeto(id proj, nome, capital investido)
-- Desenvolvedor(numero funcional, nome, salario)
-- LinguagemProg(cod ling, nome, versao)
-- Atua(id proj, numero funcional, cod ling, horas)

--  Crie as tabelas em SQL, com as devidas restriçoes pertinentes (PK e FK).

CREATE TABLE Projeto (
  id_proj int PRIMARY KEY NOT NULL,
  nome varchar(50) NOT NULL,
  capital_investido float
);

CREATE TABLE Desenvolvedor (
  numero_funcional int PRIMARY KEY NOT NULL,
  nome varchar(50) NOT NULL,
  salario float
);

CREATE TABLE LinguagemProg (
  cod_ling int PRIMARY KEY NOT NULL,
  nome varchar(50) NOT NULL,
  versao varchar(50)
);

CREATE TABLE Atua (
  id_proj int NOT NULL,
  numero_funcional int NOT NULL,
  cod_ling int NOT NULL,
  horas int,
  PRIMARY KEY (id_proj, numero_funcional, cod_ling),
  FOREIGN KEY (id_proj) REFERENCES Projeto(id_proj),
  FOREIGN KEY (numero_funcional) REFERENCES Desenvolvedor(numero_funcional),
  FOREIGN KEY (cod_ling) REFERENCES LinguagemProg(cod_ling)
);

--  Faca as consultas SQL, crie ındices e mostre os planos de consultas (com e sem ındices).
-- a) Os nomes das linguagens de programaçao envolvidas no projeto “Stark”

-- Use explain para mostrar o plano de consulta sem indices
EXPLAIN SELECT LinguagemProg.nome 
FROM LinguagemProg, Atua, Projeto 
WHERE LinguagemProg.cod_ling = Atua.cod_ling 
AND Atua.id_proj = Projeto.id_proj 
AND Projeto.nome = 'Stark';

-- Use explain para mostrar o plano de consulta com indices para facilitar o select anterior, considerando que chave primaria nao precisa de indice
CREATE INDEX idx_projeto_nome ON Projeto(nome);
CREATE INDEX idx_atua_id_proj ON Atua(id_proj);
CREATE INDEX idx_atua_cod_ling ON Atua(cod_ling);

EXPLAIN SELECT LinguagemProg.nome
FROM LinguagemProg, Atua, Projeto
WHERE LinguagemProg.cod_ling = Atua.cod_ling
AND Atua.id_proj = Projeto.id_proj
AND Projeto.nome = 'Stark';
--Considerar o uso de upper na pesquisa e no indice

-- b) As linguagens de programaçao que o desenvolvedor “João da Neve” utiliza

-- Use explain para mostrar o plano de consulta sem indices
EXPLAIN SELECT LinguagemProg.nome
FROM LinguagemProg, Atua, Desenvolvedor
WHERE LinguagemProg.cod_ling = Atua.cod_ling
AND Atua.numero_funcional = Desenvolvedor.numero_funcional
AND Desenvolvedor.nome = 'João da Neve';

-- Use explain para mostrar o plano de consulta com indices para facilitar o select anterior, considerando que chave primaria nao precisa de indice
CREATE INDEX idx_desenvolvedor_nome ON Desenvolvedor(nome);
CREATE INDEX idx_atua_numero_funcional ON Atua(numero_funcional);
CREATE INDEX idx_atua_cod_ling ON Atua(cod_ling);

EXPLAIN SELECT LinguagemProg.nome
FROM LinguagemProg, Atua, Desenvolvedor
WHERE LinguagemProg.cod_ling = Atua.cod_ling
AND Atua.numero_funcional = Desenvolvedor.numero_funcional
AND Desenvolvedor.nome = 'João da Neve';

-- c) Os projetos que tem capital investido acima de 5000.

-- Use explain para mostrar o plano de consulta sem indices

EXPLAIN SELECT Projeto.nome
FROM Projeto
WHERE Projeto.capital_investido > 5000;

-- Use explain para mostrar o plano de consulta com indices para facilitar o select anterior, considerando que chave primaria nao precisa de indice
CREATE INDEX idx_projeto_capital_investido ON Projeto(capital_investido);

EXPLAIN SELECT Projeto.nome
FROM Projeto
WHERE Projeto.capital_investido > 5000;

-- d) O número de desenvolvedores que programam em C++ cujo salário é acima de R$5.000.

-- Use explain para mostrar o plano de consulta sem indices

EXPLAIN SELECT COUNT(Desenvolvedor.numero_funcional)
FROM Desenvolvedor, Atua, LinguagemProg
WHERE Desenvolvedor.numero_funcional = Atua.numero_funcional
AND Atua.cod_ling = LinguagemProg.cod_ling
AND LinguagemProg.nome = 'C++'
AND Desenvolvedor.salario > 5000;

-- Use explain para mostrar o plano de consulta com indices para facilitar o select anterior, considerando que chave primaria nao precisa de indice
CREATE INDEX idx_desenvolvedor_salario ON Desenvolvedor(salario);
CREATE INDEX idx_atua_numero_funcional ON Atua(numero_funcional);
CREATE INDEX idx_atua_cod_ling ON Atua(cod_ling);
CREATE INDEX idx_linguagemprog_nome ON LinguagemProg(nome);

EXPLAIN SELECT COUNT(Desenvolvedor.numero_funcional)
FROM Desenvolvedor, Atua, LinguagemProg
WHERE Desenvolvedor.numero_funcional = Atua.numero_funcional
AND Atua.cod_ling = LinguagemProg.cod_ling
AND LinguagemProg.nome = 'C++'
AND Desenvolvedor.salario > 5000;
