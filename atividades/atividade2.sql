CREATE TABLE Aluno(
  Nome VARCHAR(50) NOT NULL,
  RA DECIMAL(8) NOT NULL,
  DataNasc DATE NOT NULL,
  Idade DECIMAL(3),
  NomeMae VARCHAR(50) NOT NULL,
  Cidade VARCHAR(30),
  Estado CHAR(2),
  Curso VARCHAR(50),
  periodo integer
);

CREATE TABLE Discip(
  Sigla CHAR(7) NOT NULL,
  Nome VARCHAR(25) NOT NULL,
  SiglaPreReq CHAR(7),
  NNCred DECIMAL(2) NOT NULL,
  Monitor DECIMAL(8),
  Depto CHAR(8)
);

CREATE TABLE Matricula(
  RA DECIMAL(8) NOT NULL,
  Sigla CHAR(7) NOT NULL,
  Ano CHAR(4) NOT NULL,
  Semestre CHAR(1) NOT NULL,
  CodTurma DECIMAL(4) NOT NULL,
  NotaP1 NUMERIC(3,1),
  NotaP2 NUMERIC(3,1),
  NotaTrab NUMERIC(3,1),
  NotaFIM NUMERIC(3,1),
  Frequencia DECIMAL(3)
);


-- Exercício 1: populando as tabelas

create or replace function numero(digitos integer) returns integer as
$$
begin
	return trunc(random()*power(10,  digitos));
end;
$$ language plpgsql;

-- Data aleatoria
create or replace function data() returns date as
$$
begin
	return date(timestamp '1980-01-01 00:00:00' +
			random() * (timestamp '2017-01-30 00:00:00' -
			timestamp '1990-01-01 00:00:00'));
end;
$$ language plpgsql;

-- Texto aleatorio
Create or replace function texto(tamanho integer) returns text as
$$
declare
	chars text[] := '{a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z}';
	result text := '';
	i integer := 0;
begin
	if tamanho < 0 then
		raise exception 'Tamanho dado nao pode ser menor que zero';
	end if;

	for i in 1..tamanho loop
		result := result || chars[1+random()*(array_length(chars, 1)-1)];
	end loop;

	return result;
end;
$$ language plpgsql;


SET datestyle TO "YMD";

do $$
begin
	for i in 1..2000 loop
		insert into Aluno(Nome, RA, DataNasc, Idade, NomeMae, Cidade, Estado, Curso, periodo) values (texto(30), i, data(), numero(2), texto(30), texto(10), texto(2), texto(30), numero(1));
	end loop;
end;
$$ language plpgsql;

do $$
begin
	for i in 1..2000 loop
		insert into Discip(Sigla, Nome, SiglaPreReq, NNCred, Monitor, Depto) values (texto(7), texto(20), texto(7), numero(2), numero(2) + 1, texto(8));
	end loop;
end;
$$ language plpgsql;

do $$
declare
	sgl text = '';
	result text = '';
begin
	for i in 1..2000 loop
		insert into Matricula(RA, Sigla, Ano, Semestre, CodTurma, NotaP1, NotaP2, NotaTrab, NotaFIM, Frequencia) values (i, texto(7), '2023', '1', numero(2), 0, 0, 0, 0, numero(2));
	end loop;
end;
$$ language plpgsql;

select * from Aluno;
select * from Discip;
select * from Matricula;

-- Exercício 2: 
CREATE UNIQUE INDEX IdxAlunoNNI ON Aluno (Nome, NomeMae, Idade);

-- 1- Escreva uma consulta que utilize esse índice.
analyze Aluno;
explain select Aluno, Nome, NomeMae from Aluno where Nome = 'xrkzjvsttspajzdfdisfewdhncvqvj' and NomeMae = 'umgklbkymwpixnrvhwgrcidrgegyoe' and idade = 21;

-- 2- Mostre um exemplo onde o índice não é usado mesmo utilizando algum campo indexado na clausula where, e explique por quê
explain select Aluno, Nome, NomeMae from Aluno where UPPER(Nome) = 'xrkzjvsttspajzdfdisfewdhncvqvj'
-- O índice não é usado pois ele foi feito sem considerar o UPPER, logo o índice não funciona com o UPPER

-- Exercício 3:  Crie índices e mostre exemplos de consultas (resultados e explain) que usam os seguintes tipos de acessos:
-- a) Sequential Scan
CREATE INDEX IdxAlunoCidade ON Aluno (Cidade);
analyze;
explain analyze select * from Aluno where cidade = 'zoxjmeqvmh';

-- b) bitmap scan
CREATE EXTENSION btree_gin;
CREATE INDEX IdxAlunoNome ON Aluno USING gin (idade);
analyze;
explain select * from Aluno where idade = 21;

-- c) index scan
CREATE INDEX IdxAlunoNome ON Aluno (Nome);
analyze;
explain select * from Aluno where Nome = 'xrkzjvsttspajzdfdisfewdhncvqvj';

-- d) index only scan
CREATE INDEX IdxAlunoNome ON Aluno (Nome);
analyze;
explain select Nome from Aluno where Nome = 'xrkzjvsttspajzdfdisfewdhncvqvj';

-- e) multi-index scan
CREATE INDEX IdxMatriculaRa ON Matricula (RA);
analyze;
explain select A.nome, M.RA from Aluno as A, Matricula as M where M.RA = 1;

-- Exercício 4: Faça consultas com junções entre as tabelas e mostre o desempenho criando-se índices para cada chave estrangeira

CREATE INDEX IdxRaDisciplina ON Discip (Monitor);

Analyze;

explain select A.nome, D.nome from Aluno as A, Discip as D where A.RA = D.Monitor;

-- Exercício 5: Utilize um índice bitmap para período e mostre-o em uso nas consultas

-- a) Criando o indíce
CREATE INDEX IdxAlunoPeriodo ON Aluno using BTREE(periodo);

Analyze;
-- b) Consulta
explain select * from Aluno where periodo = 1;

-- Exercício 6: Compare na prática o custo de executar uma consulta com e sem índice clusterizado na tabela aluno.
-- Ou seja, faça uma consulta sobre algum dado indexado, clusterize a tabela naquele índice e refaça a consulta.
-- Mostre os comandos e os resultados do explain analyze.

-- a) Consulta sem cluster
DROP INDEX IdxAlunoPeriodo;
explain analyze select * from Aluno where periodo = 1;

-- b) Clusterizando
CREATE INDEX IdxAlunoPeriodo ON Aluno (periodo);

CLUSTER Aluno USING IdxAlunoPeriodo;

-- c) Consulta com cluster
explain analyze select * from Aluno where periodo = 1;

-- Exercício 7: Acrescente um campo adicional na tabela de Aluno, chamado de informacoesExtras,
-- do tipo JSON. Insira dados diferentes telefônicos e de times de futebol que o aluno torce para cada aluno neste JSON.
-- Crie índices para o JSON e mostre consultas que o utilizam (explain analyze).
-- Exemplo: retorne os alunos que torcem para o Internacional.

ALTER TABLE Aluno ADD COLUMN informacoesExtras jsonb;

Create or replace function time_futebol() returns text as
$$
declare
	times text[][] := '{{Grêmio}, {Internacional}, {Chapecoense}, {Flamengo}, {São Paulo}, {Corinthians}}';
	result text := '';
begin
	result := times[1 + random() * (array_length(times, 1) - 1)];

	return result;
end;
$$ language plpgsql;

do $$
begin
	for i in 2001..4000 loop
		insert into Aluno(Nome, RA, DataNasc, Idade, NomeMae, Cidade, Estado, Curso, periodo, informacoesExtras) 
		values (
			texto(30),
      i,
      data(),
      numero(2),
      texto(30),
      texto(10),
      texto(2),
      texto(30),
      numero(1),
      ('{
        "telefone1" : ' || numero(5) || ',
        "telefone2" : "' || numero(5) || '",
        "timeFutebol" : ' || time_futebol() || '
      }')::json
		);
	end loop;
end;
$$ language plpgsql;

CREATE INDEX IdxTimeFutebol ON Aluno USING btree ((informacoesExtras->>'timeFutebol'));
Analyse;

EXPLAIN ANALYZE select informacoesExtras->>'timeFutebol' from Aluno
where informacoesExtras->>'timeFutebol' = 'Flamengo';

EXPLAIN ANALYZE select informacoesExtras->>'timeFutebol' from Aluno
where informacoesExtras->>'timeFutebol' = 'Corinthians';
