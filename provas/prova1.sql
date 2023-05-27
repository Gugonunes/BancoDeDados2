-- Explique o que faz e como o SGBD processa internamente um comando:
-- a) CREATE TABLE
-- Resposta: Cria uma tabela no banco de dados. O SGBD cria um arquivo para armazenar os dados da tabela e um arquivo para armazenar os metadados da tabela.

-- b) COMMIT TRANSACTION
-- Resposta: Confirma uma transação. O SGBD escreve os dados da transação no disco.

-- c) SELECT
-- Resposta: Seleciona dados de uma tabela. O SGBD busca os dados no disco e os retorna para o usuário.

-- 2- Como os comandos da DML podem ser otimizados?
-- Resposta: Através da criação de índices.

-- 3- Mostre dois exemplos de como uma árvore de comandos canônica pode ser otimizada.
-- Resposta: Através da criação de índices e da criação de uma view.

-- 4- Descreva os quatro módulos principais de um SGBD vistos em aula. Qual a função e o resultado de cada um desses módulos?
-- Resposta: O módulo de gerenciamento de transações é responsável por garantir a atomicidade, consistência, isolamento e durabilidade das transações.
-- O módulo de gerenciamento de armazenamento é responsável por gerenciar o armazenamento dos dados no disco.
-- O módulo de gerenciamento de buffer é responsável por gerenciar o armazenamento dos dados na memória.
-- O módulo de gerenciamento de consultas é responsável por otimizar as consultas.

-- Como calcular a alocação de página para os operadores no plano de consulta?
-- Resposta: Através da fórmula: (custo do operador) / (custo total da consulta) * (número de páginas do buffer).

-- Como saber o custo do operador a partir do plano de consulta?



-- Explique os seguintes termos em um SGBD. Mostre usando comandos SQL como podemos utilizalos e indique a vantagem de cada um

-- Trablespace
-- Resposta: Um tablespace é um conjunto de arquivos que armazenam os dados de uma tabela. A vantagem de utilizar tablespaces é que podemos armazenar os dados de uma tabela em vários arquivos, o que permite que o SGBD utilize vários discos para armazenar os dados de uma tabela, o que aumenta a performance.
-- Exemplo de código: CREATE TABLESPACE teste LOCATION '/home/luiz/teste';

-- Grant
-- Reposta: O comando grant permite que um usuário conceda permissões para outro usuário. A vantagem de utilizar o comando grant é que podemos conceder permissões para outros usuários.
-- Exemplo de código: GRANT ALL ON pessoa TO luiz;

-- index scan
-- Resposta: O index scan é um operador que busca os dados de uma tabela através de um índice. A vantagem de utilizar o index scan é que ele é mais rápido que o sequential scan.
-- Exemplo de código: SELECT * FROM pessoa WHERE nome = 'Joao';

-- diferença entre index scan e index-only scan
-- Resposta: O index scan busca os dados de uma tabela através de um índice, enquanto o index-only scan busca os dados de uma tabela através de um índice e retorna os dados para o usuário sem precisar acessar a tabela.
-- exemplo de códio de index scan only:


-- multi-index scan
-- Resposta: O multi-index scan é um operador que busca os dados de uma tabela através de vários índices. A vantagem de utilizar o multi-index scan é que ele é mais rápido que o sequential scan.

-- clustered index scan
-- Resposta: O clustered index scan é um operador que busca os dados de uma tabela através de um índice clusterizado. A vantagem de utilizar o clustered index scan é que ele é mais rápido que o sequential scan.


-- tendo em mãos a arvore de comandos canônica, como podemos calcular a alocação de páginas cada operador considerando um cache de 400 páginas?
-- Resposta: Através da fórmula: (custo do operador) / (custo total da consulta) * (número de páginas do buffer).
-- exemplo:



