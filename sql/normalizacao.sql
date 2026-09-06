-- =====================================================================
-- Trabalho II - Normalizacao de Base de Dados - Sistema de Gestao de Funcionarios
-- Universidade Licungo - Faculdade de Ciencias e Tecnologias
-- Curso de Licenciatura em Informatica
-- Esquema final normalizado (ate 4FN) + dados de exemplo + queries de reconstituicao
-- =====================================================================

-- Sugestao: rode este script num SGBD MySQL/MariaDB ou PostgreSQL (ajuste tipos se necessario)

DROP TABLE IF EXISTS telefone;
DROP TABLE IF EXISTS filho;
DROP TABLE IF EXISTS funcionario;
DROP TABLE IF EXISTS posto_trabalho;
DROP TABLE IF EXISTS funcao;
DROP TABLE IF EXISTS cargo;
DROP TABLE IF EXISTS cidade;

-- =====================================================================
-- 1. TABELAS DE REFERENCIA (removem as dependencias transitivas - 3FN)
-- =====================================================================

CREATE TABLE cidade (
    cod_cidade   VARCHAR(5)   PRIMARY KEY,
    nome_cidade  VARCHAR(60)  NOT NULL,
    provincia    VARCHAR(40)  NOT NULL,
    pais         VARCHAR(40)  NOT NULL
);

CREATE TABLE cargo (
    cod_cargo        VARCHAR(5)   PRIMARY KEY,
    descricao_cargo  VARCHAR(80)  NOT NULL
);

CREATE TABLE funcao (
    cod_funcao        VARCHAR(5)  PRIMARY KEY,
    descricao_funcao  VARCHAR(80) NOT NULL
);

CREATE TABLE posto_trabalho (
    cod_posto    VARCHAR(5)   PRIMARY KEY,
    nome_posto   VARCHAR(80)  NOT NULL,
    cod_cidade   VARCHAR(5)   NOT NULL,
    CONSTRAINT fk_posto_cidade FOREIGN KEY (cod_cidade) REFERENCES cidade(cod_cidade)
);

-- =====================================================================
-- 2. ENTIDADE PRINCIPAL
-- =====================================================================

CREATE TABLE funcionario (
    bi              VARCHAR(20)  PRIMARY KEY,
    nome            VARCHAR(100) NOT NULL,
    data_nasc       DATE         NOT NULL,
    nuit            VARCHAR(15)  NOT NULL UNIQUE,
    email           VARCHAR(100) NOT NULL UNIQUE,
    rua             VARCHAR(100),
    numero_porta    VARCHAR(10),
    bairro          VARCHAR(60),
    cod_cidade      VARCHAR(5)   NOT NULL,
    cod_cargo       VARCHAR(5)   NOT NULL,
    cod_funcao      VARCHAR(5)   NOT NULL,
    cod_posto       VARCHAR(5)   NOT NULL,
    data_admissao   DATE         NOT NULL,
    CONSTRAINT fk_func_cidade FOREIGN KEY (cod_cidade) REFERENCES cidade(cod_cidade),
    CONSTRAINT fk_func_cargo  FOREIGN KEY (cod_cargo)  REFERENCES cargo(cod_cargo),
    CONSTRAINT fk_func_funcao FOREIGN KEY (cod_funcao) REFERENCES funcao(cod_funcao),
    CONSTRAINT fk_func_posto  FOREIGN KEY (cod_posto)  REFERENCES posto_trabalho(cod_posto)
);

-- =====================================================================
-- 3. ENTIDADES FRACAS (removem grupos repetitivos - 1FN - e ficam
--    independentes uma da outra - 4FN, pois filhos e telefones sao
--    factos multivalorados independentes sobre o funcionario)
-- =====================================================================

CREATE TABLE filho (
    id_filho        INT AUTO_INCREMENT PRIMARY KEY,
    bi_funcionario  VARCHAR(20) NOT NULL,
    nome_filho      VARCHAR(100) NOT NULL,
    CONSTRAINT fk_filho_func FOREIGN KEY (bi_funcionario) REFERENCES funcionario(bi)
);

CREATE TABLE telefone (
    id_telefone     INT AUTO_INCREMENT PRIMARY KEY,
    bi_funcionario  VARCHAR(20) NOT NULL,
    numero_telefone VARCHAR(15) NOT NULL,
    CONSTRAINT fk_tel_func FOREIGN KEY (bi_funcionario) REFERENCES funcionario(bi)
);

-- =====================================================================
-- 4. DADOS DE EXEMPLO (extraidos e limpos da tabela original 0FN)
-- =====================================================================

-- Cidades
INSERT INTO cidade (cod_cidade, nome_cidade, provincia, pais) VALUES ('CID01', 'Beira', 'Sofala', 'Moçambique');
INSERT INTO cidade (cod_cidade, nome_cidade, provincia, pais) VALUES ('CID02', 'Chimoio', 'Manica', 'Moçambique');
INSERT INTO cidade (cod_cidade, nome_cidade, provincia, pais) VALUES ('CID03', 'Chókwè', 'Gaza', 'Moçambique');
INSERT INTO cidade (cod_cidade, nome_cidade, provincia, pais) VALUES ('CID04', 'Maputo', 'Maputo Cidade', 'Moçambique');
INSERT INTO cidade (cod_cidade, nome_cidade, provincia, pais) VALUES ('CID05', 'Matola', 'Maputo Província', 'Moçambique');
INSERT INTO cidade (cod_cidade, nome_cidade, provincia, pais) VALUES ('CID06', 'Maxixe', 'Inhambane', 'Moçambique');
INSERT INTO cidade (cod_cidade, nome_cidade, provincia, pais) VALUES ('CID07', 'Nampula', 'Nampula', 'Moçambique');
INSERT INTO cidade (cod_cidade, nome_cidade, provincia, pais) VALUES ('CID08', 'Pemba', 'Cabo Delgado', 'Moçambique');
INSERT INTO cidade (cod_cidade, nome_cidade, provincia, pais) VALUES ('CID09', 'Quelimane', 'Zambézia', 'Moçambique');
INSERT INTO cidade (cod_cidade, nome_cidade, provincia, pais) VALUES ('CID10', 'Tete', 'Tete', 'Moçambique');

-- Cargos
INSERT INTO cargo (cod_cargo, descricao_cargo) VALUES ('C01', 'Técnico de Informática');
INSERT INTO cargo (cod_cargo, descricao_cargo) VALUES ('C02', 'Contabilista');
INSERT INTO cargo (cod_cargo, descricao_cargo) VALUES ('C03', 'Engenheiro Civil');
INSERT INTO cargo (cod_cargo, descricao_cargo) VALUES ('C04', 'Enfermeiro');
INSERT INTO cargo (cod_cargo, descricao_cargo) VALUES ('C05', 'Professor');
INSERT INTO cargo (cod_cargo, descricao_cargo) VALUES ('C06', 'Motorista');
INSERT INTO cargo (cod_cargo, descricao_cargo) VALUES ('C07', 'Gestor de Recursos Humanos');
INSERT INTO cargo (cod_cargo, descricao_cargo) VALUES ('C08', 'Assistente Administrativo');

-- Funcoes
INSERT INTO funcao (cod_funcao, descricao_funcao) VALUES ('F01', 'Tecnologias de Informação');
INSERT INTO funcao (cod_funcao, descricao_funcao) VALUES ('F02', 'Finanças');
INSERT INTO funcao (cod_funcao, descricao_funcao) VALUES ('F03', 'Engenharia');
INSERT INTO funcao (cod_funcao, descricao_funcao) VALUES ('F04', 'Saúde');
INSERT INTO funcao (cod_funcao, descricao_funcao) VALUES ('F05', 'Educação');
INSERT INTO funcao (cod_funcao, descricao_funcao) VALUES ('F06', 'Logística');
INSERT INTO funcao (cod_funcao, descricao_funcao) VALUES ('F07', 'Recursos Humanos');
INSERT INTO funcao (cod_funcao, descricao_funcao) VALUES ('F08', 'Administração');

-- Postos de trabalho
INSERT INTO posto_trabalho (cod_posto, nome_posto, cod_cidade) VALUES ('PT01', 'Delegação Beira', 'CID01');
INSERT INTO posto_trabalho (cod_posto, nome_posto, cod_cidade) VALUES ('PT02', 'Delegação Cabo Delgado', 'CID08');
INSERT INTO posto_trabalho (cod_posto, nome_posto, cod_cidade) VALUES ('PT03', 'Delegação Gaza', 'CID03');
INSERT INTO posto_trabalho (cod_posto, nome_posto, cod_cidade) VALUES ('PT04', 'Delegação Inhambane', 'CID06');
INSERT INTO posto_trabalho (cod_posto, nome_posto, cod_cidade) VALUES ('PT05', 'Delegação Manica', 'CID02');
INSERT INTO posto_trabalho (cod_posto, nome_posto, cod_cidade) VALUES ('PT06', 'Delegação Matola', 'CID05');
INSERT INTO posto_trabalho (cod_posto, nome_posto, cod_cidade) VALUES ('PT07', 'Delegação Nampula', 'CID07');
INSERT INTO posto_trabalho (cod_posto, nome_posto, cod_cidade) VALUES ('PT08', 'Delegação Tete', 'CID10');
INSERT INTO posto_trabalho (cod_posto, nome_posto, cod_cidade) VALUES ('PT09', 'Delegação Zambézia', 'CID09');
INSERT INTO posto_trabalho (cod_posto, nome_posto, cod_cidade) VALUES ('PT10', 'Sede Maputo', 'CID04');

-- Funcionarios
INSERT INTO funcionario (bi, nome, data_nasc, nuit, email, rua, numero_porta, bairro, cod_cidade, cod_cargo, cod_funcao, cod_posto, data_admissao) VALUES ('110100123456A', 'Amélia Fernanda Cossa', '1985-03-12', '100234567', 'amelia.cossa@empresa.co.mz', 'Av. Julius Nyerere', '245', 'Sommerschield', 'CID04', 'C01', 'F01', 'PT10', '2015-02-05');
INSERT INTO funcionario (bi, nome, data_nasc, nuit, email, rua, numero_porta, bairro, cod_cidade, cod_cargo, cod_funcao, cod_posto, data_admissao) VALUES ('110100234567B', 'Bernardo Alfredo Machava', '1979-07-22', '100345678', 'bernardo.machava@empresa.co.mz', 'Rua da Resistência', '8', 'Polana Caniço', 'CID04', 'C02', 'F02', 'PT10', '2010-09-14');
INSERT INTO funcionario (bi, nome, data_nasc, nuit, email, rua, numero_porta, bairro, cod_cidade, cod_cargo, cod_funcao, cod_posto, data_admissao) VALUES ('110200345678C', 'Celina Armando Sitoe', '1990-11-03', '100456789', 'celina.sitoe@empresa.co.mz', 'Av. Samora Machel', '12', 'Fomento', 'CID05', 'C08', 'F08', 'PT06', '2018-06-01');
INSERT INTO funcionario (bi, nome, data_nasc, nuit, email, rua, numero_porta, bairro, cod_cidade, cod_cargo, cod_funcao, cod_posto, data_admissao) VALUES ('110300456789D', 'Domingos Paulo Nhantumbo', '1982-01-30', '100567890', 'domingos.nhantumbo@empresa.co.mz', 'Rua 3', '56', 'Chókwè-Sede', 'CID03', 'C06', 'F06', 'PT03', '2012-03-10');
INSERT INTO funcionario (bi, nome, data_nasc, nuit, email, rua, numero_porta, bairro, cod_cidade, cod_cargo, cod_funcao, cod_posto, data_admissao) VALUES ('110400567890E', 'Eugénia Marta Muchanga', '1988-05-18', '100678901', 'eugenia.muchanga@empresa.co.mz', 'Av. Eduardo Mondlane', '301', 'Maxixe-Sede', 'CID06', 'C04', 'F04', 'PT04', '2016-08-20');
INSERT INTO funcionario (bi, nome, data_nasc, nuit, email, rua, numero_porta, bairro, cod_cidade, cod_cargo, cod_funcao, cod_posto, data_admissao) VALUES ('110500678901F', 'Fernando José Macuácua', '1975-09-25', '100789012', 'fernando.macuacua@empresa.co.mz', 'Av. Poder Popular', '77', 'Macuti', 'CID01', 'C03', 'F03', 'PT01', '2008-01-15');
INSERT INTO funcionario (bi, nome, data_nasc, nuit, email, rua, numero_porta, bairro, cod_cidade, cod_cargo, cod_funcao, cod_posto, data_admissao) VALUES ('110600789012G', 'Graça Isabel Zunguze', '1992-12-07', '100890123', 'graca.zunguze@empresa.co.mz', 'Rua da Frescura', '19', 'Ponta Gêa', 'CID01', 'C05', 'F05', 'PT01', '2019-02-02');
INSERT INTO funcionario (bi, nome, data_nasc, nuit, email, rua, numero_porta, bairro, cod_cidade, cod_cargo, cod_funcao, cod_posto, data_admissao) VALUES ('110700890123H', 'Hélder António Cuamba', '1980-04-14', '100901234', 'helder.cuamba@empresa.co.mz', 'Av. 25 de Setembro', '150', 'Alto Maé', 'CID04', 'C07', 'F07', 'PT10', '2011-11-11');
INSERT INTO funcionario (bi, nome, data_nasc, nuit, email, rua, numero_porta, bairro, cod_cidade, cod_cargo, cod_funcao, cod_posto, data_admissao) VALUES ('110800901234I', 'Ivete Sara Chirindza', '1995-06-29', '101012345', 'ivete.chirindza@empresa.co.mz', 'Rua do Bagamoyo', '5', 'Muhipiti', 'CID07', 'C01', 'F01', 'PT07', '2020-07-03');
INSERT INTO funcionario (bi, nome, data_nasc, nuit, email, rua, numero_porta, bairro, cod_cidade, cod_cargo, cod_funcao, cod_posto, data_admissao) VALUES ('110900012345J', 'João Baptista Nhaca', '1978-08-09', '101123456', 'joao.nhaca@empresa.co.mz', 'Av. Josina Machel', '200', 'Namahera', 'CID07', 'C02', 'F02', 'PT07', '2009-05-25');
INSERT INTO funcionario (bi, nome, data_nasc, nuit, email, rua, numero_porta, bairro, cod_cidade, cod_cargo, cod_funcao, cod_posto, data_admissao) VALUES ('111000123456K', 'Lúcia Ermelinda Bila', '1991-02-16', '101234567', 'lucia.bila@empresa.co.mz', 'Rua da Base', '33', 'Chaimite', 'CID01', 'C08', 'F08', 'PT01', '2017-09-19');
INSERT INTO funcionario (bi, nome, data_nasc, nuit, email, rua, numero_porta, bairro, cod_cidade, cod_cargo, cod_funcao, cod_posto, data_admissao) VALUES ('111100234567L', 'Marcelino Inácio Tembe', '1983-10-21', '101345678', 'marcelino.tembe@empresa.co.mz', 'Av. Kwame Nkrumah', '410', 'Coop', 'CID04', 'C03', 'F03', 'PT10', '2013-04-08');
INSERT INTO funcionario (bi, nome, data_nasc, nuit, email, rua, numero_porta, bairro, cod_cidade, cod_cargo, cod_funcao, cod_posto, data_admissao) VALUES ('111200345678M', 'Noémia Alzira Massingue', '1987-03-04', '101456789', 'noemia.massingue@empresa.co.mz', 'Rua de Chimoio', '67', 'Chingussura', 'CID02', 'C04', 'F04', 'PT05', '2014-12-12');
INSERT INTO funcionario (bi, nome, data_nasc, nuit, email, rua, numero_porta, bairro, cod_cidade, cod_cargo, cod_funcao, cod_posto, data_admissao) VALUES ('111300456789N', 'Osvaldo Simião Ubisse', '1976-07-27', '101567890', 'osvaldo.ubisse@empresa.co.mz', 'Av. 7 de Setembro', '90', 'Matundo', 'CID10', 'C06', 'F06', 'PT08', '2006-10-30');
INSERT INTO funcionario (bi, nome, data_nasc, nuit, email, rua, numero_porta, bairro, cod_cidade, cod_cargo, cod_funcao, cod_posto, data_admissao) VALUES ('111400567890O', 'Paulina Fátima Uache', '1993-01-15', '101678901', 'paulina.uache@empresa.co.mz', 'Rua da Missão', '24', 'Chalaua', 'CID09', 'C05', 'F05', 'PT09', '2021-09-09');
INSERT INTO funcionario (bi, nome, data_nasc, nuit, email, rua, numero_porta, bairro, cod_cidade, cod_cargo, cod_funcao, cod_posto, data_admissao) VALUES ('111500678901P', 'Ricardo Manuel Come', '1981-06-02', '101789012', 'ricardo.come@empresa.co.mz', 'Av. Franqueza', '18', 'Chuwaula', 'CID08', 'C07', 'F07', 'PT02', '2010-07-17');

-- Filhos
INSERT INTO filho (bi_funcionario, nome_filho) VALUES ('110100123456A', 'Cátia Cossa');
INSERT INTO filho (bi_funcionario, nome_filho) VALUES ('110100234567B', 'Nelson Machava');
INSERT INTO filho (bi_funcionario, nome_filho) VALUES ('110100234567B', 'Ivete Machava');
INSERT INTO filho (bi_funcionario, nome_filho) VALUES ('110100234567B', 'Suzana Machava');
INSERT INTO filho (bi_funcionario, nome_filho) VALUES ('110300456789D', 'Paulo Nhantumbo Jr');
INSERT INTO filho (bi_funcionario, nome_filho) VALUES ('110300456789D', 'Alzira Nhantumbo');
INSERT INTO filho (bi_funcionario, nome_filho) VALUES ('110400567890E', 'Marta Muchanga');
INSERT INTO filho (bi_funcionario, nome_filho) VALUES ('110500678901F', 'José Macuácua');
INSERT INTO filho (bi_funcionario, nome_filho) VALUES ('110500678901F', 'Beatriz Macuácua');
INSERT INTO filho (bi_funcionario, nome_filho) VALUES ('110500678901F', 'Adriano Macuácua');
INSERT INTO filho (bi_funcionario, nome_filho) VALUES ('110700890123H', 'António Cuamba Jr');
INSERT INTO filho (bi_funcionario, nome_filho) VALUES ('110700890123H', 'Filomena Cuamba');
INSERT INTO filho (bi_funcionario, nome_filho) VALUES ('110900012345J', 'Baptista Nhaca Jr');
INSERT INTO filho (bi_funcionario, nome_filho) VALUES ('111000123456K', 'Ermelinda Bila');
INSERT INTO filho (bi_funcionario, nome_filho) VALUES ('111100234567L', 'Inácio Tembe Jr');
INSERT INTO filho (bi_funcionario, nome_filho) VALUES ('111100234567L', 'Rosa Tembe');
INSERT INTO filho (bi_funcionario, nome_filho) VALUES ('111300456789N', 'Simião Ubisse Jr');
INSERT INTO filho (bi_funcionario, nome_filho) VALUES ('111300456789N', 'Alcinda Ubisse');
INSERT INTO filho (bi_funcionario, nome_filho) VALUES ('111300456789N', 'Custódio Ubisse');
INSERT INTO filho (bi_funcionario, nome_filho) VALUES ('111500678901P', 'Manuel Come Jr');

-- Telefones
INSERT INTO telefone (bi_funcionario, numero_telefone) VALUES ('110100123456A', '841234567');
INSERT INTO telefone (bi_funcionario, numero_telefone) VALUES ('110100123456A', '821234567');
INSERT INTO telefone (bi_funcionario, numero_telefone) VALUES ('110100234567B', '845678901');
INSERT INTO telefone (bi_funcionario, numero_telefone) VALUES ('110200345678C', '861122334');
INSERT INTO telefone (bi_funcionario, numero_telefone) VALUES ('110300456789D', '847890123');
INSERT INTO telefone (bi_funcionario, numero_telefone) VALUES ('110300456789D', '878901234');
INSERT INTO telefone (bi_funcionario, numero_telefone) VALUES ('110400567890E', '849012345');
INSERT INTO telefone (bi_funcionario, numero_telefone) VALUES ('110500678901F', '823456789');
INSERT INTO telefone (bi_funcionario, numero_telefone) VALUES ('110500678901F', '843456789');
INSERT INTO telefone (bi_funcionario, numero_telefone) VALUES ('110500678901F', '863456789');
INSERT INTO telefone (bi_funcionario, numero_telefone) VALUES ('110600789012G', '844567890');
INSERT INTO telefone (bi_funcionario, numero_telefone) VALUES ('110600789012G', '824567890');
INSERT INTO telefone (bi_funcionario, numero_telefone) VALUES ('110700890123H', '825678901');
INSERT INTO telefone (bi_funcionario, numero_telefone) VALUES ('110800901234I', '846789012');
INSERT INTO telefone (bi_funcionario, numero_telefone) VALUES ('110900012345J', '827890123');
INSERT INTO telefone (bi_funcionario, numero_telefone) VALUES ('110900012345J', '847890124');
INSERT INTO telefone (bi_funcionario, numero_telefone) VALUES ('111000123456K', '848901234');
INSERT INTO telefone (bi_funcionario, numero_telefone) VALUES ('111100234567L', '829012345');
INSERT INTO telefone (bi_funcionario, numero_telefone) VALUES ('111100234567L', '849012346');
INSERT INTO telefone (bi_funcionario, numero_telefone) VALUES ('111100234567L', '869012347');
INSERT INTO telefone (bi_funcionario, numero_telefone) VALUES ('111200345678M', '841122334');
INSERT INTO telefone (bi_funcionario, numero_telefone) VALUES ('111300456789N', '822233445');
INSERT INTO telefone (bi_funcionario, numero_telefone) VALUES ('111300456789N', '842233445');
INSERT INTO telefone (bi_funcionario, numero_telefone) VALUES ('111400567890O', '843344556');
INSERT INTO telefone (bi_funcionario, numero_telefone) VALUES ('111500678901P', '824455667');
INSERT INTO telefone (bi_funcionario, numero_telefone) VALUES ('111500678901P', '844455667');

-- =====================================================================
-- 5. QUERIES DE EXEMPLO - reconstituem a informacao original (0FN)
--    a partir do esquema normalizado, usando JOIN
-- =====================================================================

-- 5.1 Reconstitui a "ficha" completa do funcionario: dados pessoais,
--     morada completa (com cidade/provincia/pais), cargo, funcao e posto
SELECT
    fu.nome,
    fu.data_nasc,
    fu.nuit,
    fu.bi,
    fu.email,
    CONCAT(fu.rua, ', n.', fu.numero_porta, ', ', fu.bairro) AS endereco_completo,
    ci.nome_cidade,
    ci.provincia,
    ci.pais,
    ca.descricao_cargo,
    fn.descricao_funcao,
    pt.nome_posto,
    fu.data_admissao
FROM funcionario fu
JOIN cidade ci          ON fu.cod_cidade = ci.cod_cidade
JOIN cargo  ca          ON fu.cod_cargo  = ca.cod_cargo
JOIN funcao fn          ON fu.cod_funcao = fn.cod_funcao
JOIN posto_trabalho pt  ON fu.cod_posto  = pt.cod_posto
ORDER BY fu.nome;

-- 5.2 Reconstitui a lista de filhos por funcionario (equivalente as
--     colunas repetidas Filho1, Filho2, Filho3 da tabela original)
SELECT
    fu.nome AS funcionario,
    GROUP_CONCAT(fi.nome_filho SEPARATOR ', ') AS filhos
FROM funcionario fu
LEFT JOIN filho fi ON fu.bi = fi.bi_funcionario
GROUP BY fu.bi, fu.nome
ORDER BY fu.nome;

-- 5.3 Reconstitui a lista de telefones por funcionario (equivalente as
--     colunas repetidas Celular1, Celular2, Celular3 da tabela original)
-- e mostra tambem o posto de trabalho e a cidade onde este se localiza
SELECT
    fu.nome AS funcionario,
    pt.nome_posto,
    ci.nome_cidade AS cidade_do_posto,
    GROUP_CONCAT(te.numero_telefone SEPARATOR ', ') AS telefones
FROM funcionario fu
JOIN posto_trabalho pt ON fu.cod_posto = pt.cod_posto
JOIN cidade ci         ON pt.cod_cidade = ci.cod_cidade
LEFT JOIN telefone te  ON fu.bi = te.bi_funcionario
GROUP BY fu.bi, fu.nome, pt.nome_posto, ci.nome_cidade
ORDER BY fu.nome;
