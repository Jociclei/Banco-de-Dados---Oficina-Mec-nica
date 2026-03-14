-- ============================================================
-- PROJETO: Banco de Dados - Oficina Mecânica
-- Descrição: Esquema lógico e scripts SQL para gerenciamento
--            de ordens de serviço em uma oficina mecânica.
-- ============================================================

-- ============================================================
-- PARTE 1: CRIAÇÃO DO ESQUEMA (DDL)
-- ============================================================

DROP DATABASE IF EXISTS oficina_mecanica;
CREATE DATABASE oficina_mecanica CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE oficina_mecanica;

-- --------------------------
-- CLIENTES
-- --------------------------
CREATE TABLE Cliente (
    id_cliente    INT          NOT NULL AUTO_INCREMENT,
    nome          VARCHAR(100) NOT NULL,
    cpf           CHAR(11)     NOT NULL UNIQUE,
    telefone      VARCHAR(15),
    email         VARCHAR(100),
    endereco      VARCHAR(200),
    data_cadastro DATE         NOT NULL DEFAULT (CURRENT_DATE),
    PRIMARY KEY (id_cliente)
);

-- --------------------------
-- VEÍCULOS
-- --------------------------
CREATE TABLE Veiculo (
    id_veiculo  INT         NOT NULL AUTO_INCREMENT,
    id_cliente  INT         NOT NULL,
    placa       VARCHAR(8)  NOT NULL UNIQUE,
    marca       VARCHAR(50) NOT NULL,
    modelo      VARCHAR(50) NOT NULL,
    ano         YEAR        NOT NULL,
    cor         VARCHAR(30),
    kilometragem INT,
    PRIMARY KEY (id_veiculo),
    CONSTRAINT fk_veiculo_cliente FOREIGN KEY (id_cliente)
        REFERENCES Cliente(id_cliente) ON DELETE RESTRICT
);

-- --------------------------
-- MECÂNICOS
-- --------------------------
CREATE TABLE Mecanico (
    id_mecanico INT          NOT NULL AUTO_INCREMENT,
    nome        VARCHAR(100) NOT NULL,
    cpf         CHAR(11)     NOT NULL UNIQUE,
    especialidade VARCHAR(80),
    salario     DECIMAL(10,2),
    data_admissao DATE       NOT NULL DEFAULT (CURRENT_DATE),
    PRIMARY KEY (id_mecanico)
);

-- --------------------------
-- EQUIPES
-- --------------------------
CREATE TABLE Equipe (
    id_equipe   INT         NOT NULL AUTO_INCREMENT,
    nome_equipe VARCHAR(60) NOT NULL,
    PRIMARY KEY (id_equipe)
);

-- --------------------------
-- COMPOSIÇÃO DAS EQUIPES (N:M Mecânico x Equipe)
-- --------------------------
CREATE TABLE Equipe_Mecanico (
    id_equipe   INT NOT NULL,
    id_mecanico INT NOT NULL,
    PRIMARY KEY (id_equipe, id_mecanico),
    CONSTRAINT fk_em_equipe   FOREIGN KEY (id_equipe)   REFERENCES Equipe(id_equipe),
    CONSTRAINT fk_em_mecanico FOREIGN KEY (id_mecanico) REFERENCES Mecanico(id_mecanico)
);

-- --------------------------
-- SERVIÇOS (tabela de referência de mão-de-obra)
-- --------------------------
CREATE TABLE Servico (
    id_servico  INT           NOT NULL AUTO_INCREMENT,
    descricao   VARCHAR(150)  NOT NULL,
    valor_mao_obra DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (id_servico)
);

-- --------------------------
-- PEÇAS
-- --------------------------
CREATE TABLE Peca (
    id_peca     INT           NOT NULL AUTO_INCREMENT,
    nome        VARCHAR(100)  NOT NULL,
    descricao   VARCHAR(200),
    preco       DECIMAL(10,2) NOT NULL,
    estoque     INT           NOT NULL DEFAULT 0,
    PRIMARY KEY (id_peca)
);

-- --------------------------
-- ORDENS DE SERVIÇO
-- --------------------------
CREATE TABLE Ordem_Servico (
    id_os         INT          NOT NULL AUTO_INCREMENT,
    id_veiculo    INT          NOT NULL,
    id_equipe     INT          NOT NULL,
    data_emissao  DATE         NOT NULL DEFAULT (CURRENT_DATE),
    data_conclusao DATE,
    status        ENUM('Aguardando','Em andamento','Concluída','Cancelada') NOT NULL DEFAULT 'Aguardando',
    descricao_problema TEXT,
    PRIMARY KEY (id_os),
    CONSTRAINT fk_os_veiculo FOREIGN KEY (id_veiculo) REFERENCES Veiculo(id_veiculo),
    CONSTRAINT fk_os_equipe  FOREIGN KEY (id_equipe)  REFERENCES Equipe(id_equipe)
);

-- --------------------------
-- SERVIÇOS DA OS (N:M OS x Serviço)
-- --------------------------
CREATE TABLE OS_Servico (
    id_os       INT NOT NULL,
    id_servico  INT NOT NULL,
    quantidade  INT NOT NULL DEFAULT 1,
    PRIMARY KEY (id_os, id_servico),
    CONSTRAINT fk_oss_os      FOREIGN KEY (id_os)      REFERENCES Ordem_Servico(id_os),
    CONSTRAINT fk_oss_servico FOREIGN KEY (id_servico) REFERENCES Servico(id_servico)
);

-- --------------------------
-- PEÇAS DA OS (N:M OS x Peça)
-- --------------------------
CREATE TABLE OS_Peca (
    id_os       INT            NOT NULL,
    id_peca     INT            NOT NULL,
    quantidade  INT            NOT NULL DEFAULT 1,
    preco_unit  DECIMAL(10,2)  NOT NULL,   -- preço no momento da OS
    PRIMARY KEY (id_os, id_peca),
    CONSTRAINT fk_osp_os   FOREIGN KEY (id_os)   REFERENCES Ordem_Servico(id_os),
    CONSTRAINT fk_osp_peca FOREIGN KEY (id_peca) REFERENCES Peca(id_peca)
);


-- ============================================================
-- PARTE 2: CARGA DE DADOS (DML)
-- ============================================================

-- Clientes
INSERT INTO Cliente (nome, cpf, telefone, email, endereco) VALUES
('Ana Paula Ferreira',  '11122233344', '(11)91111-1111', 'ana@email.com',    'Rua das Flores, 10, São Paulo'),
('Bruno Costa',         '22233344455', '(11)92222-2222', 'bruno@email.com',  'Av. Brasil, 200, São Paulo'),
('Carla Mendes',        '33344455566', '(21)93333-3333', 'carla@email.com',  'Rua da Saudade, 55, Rio de Janeiro'),
('Daniel Souza',        '44455566677', '(31)94444-4444', 'daniel@email.com', 'Av. Central, 800, Belo Horizonte'),
('Eliane Torres',       '55566677788', '(11)95555-5555', 'eliane@email.com', 'Rua Nova, 30, São Paulo'),
('Felipe Ramos',        '66677788899', '(11)96666-6666', 'felipe@email.com', 'Rua do Sol, 77, São Paulo'),
('Gabriela Lima',       '77788899900', '(21)97777-7777', 'gabi@email.com',   'Estrada Real, 100, Rio de Janeiro'),
('Henrique Alves',      '88899900011', '(41)98888-8888', 'henrique@email.com','Rua das Palmeiras, 40, Curitiba');

-- Veículos
INSERT INTO Veiculo (id_cliente, placa, marca, modelo, ano, cor, kilometragem) VALUES
(1, 'ABC1D23', 'Toyota',     'Corolla',   2020, 'Prata',  45000),
(1, 'DEF2E34', 'Honda',      'Civic',     2019, 'Preto',  62000),
(2, 'GHI3F45', 'Volkswagen', 'Gol',       2018, 'Branco', 80000),
(3, 'JKL4G56', 'Ford',       'Ka',        2021, 'Azul',   22000),
(4, 'MNO5H67', 'Chevrolet',  'Onix',      2022, 'Vermelho', 15000),
(5, 'PQR6I78', 'Renault',    'Sandero',   2017, 'Cinza',  95000),
(6, 'STU7J89', 'Hyundai',    'HB20',      2020, 'Branco', 38000),
(7, 'VWX8K90', 'Fiat',       'Argo',      2019, 'Prata',  55000),
(8, 'YZA9L01', 'Nissan',     'Versa',     2021, 'Preto',  28000),
(3, 'BCD0M12', 'Toyota',     'Hilux',     2016, 'Branco', 120000);

-- Mecânicos
INSERT INTO Mecanico (nome, cpf, especialidade, salario, data_admissao) VALUES
('João Mecânico Silva',   '10011011011', 'Motor',           3500.00, '2018-03-01'),
('Pedro Pinheiro',        '20022022022', 'Freios e Suspensão', 3200.00, '2019-06-15'),
('Marcos Eletricista',    '30033033033', 'Elétrica',        3800.00, '2017-01-10'),
('Ricardo Funileiro',     '40044044044', 'Funilaria',       2900.00, '2020-08-20'),
('Sandro Borracheiro',    '50055055055', 'Pneus e Rodas',   2600.00, '2021-02-28'),
('Tatiane Costa',         '60066066066', 'Motor',           3600.00, '2019-11-05'),
('Ulisses Marques',       '70077077077', 'Transmissão',     3400.00, '2018-07-12'),
('Vera Santos',           '80088088088', 'Elétrica',        3700.00, '2016-04-03');

-- Equipes
INSERT INTO Equipe (nome_equipe) VALUES
('Equipe Alpha'),
('Equipe Beta'),
('Equipe Gama');

-- Composição das equipes
INSERT INTO Equipe_Mecanico (id_equipe, id_mecanico) VALUES
(1, 1), (1, 2), (1, 5),
(2, 3), (2, 4),
(3, 6), (3, 7), (3, 8);

-- Serviços
INSERT INTO Servico (descricao, valor_mao_obra) VALUES
('Troca de óleo e filtro',         120.00),
('Revisão de freios',              250.00),
('Alinhamento e balanceamento',    180.00),
('Troca de correia dentada',       400.00),
('Diagnóstico elétrico',           200.00),
('Troca de amortecedores',         350.00),
('Troca de velas e cabos',         150.00),
('Limpeza de bico injetor',        220.00),
('Revisão completa (30.000 km)',   600.00),
('Reparo de funilaria',            800.00),
('Troca de pneus (jogo)',          500.00),
('Reparo no câmbio',               700.00);

-- Peças
INSERT INTO Peca (nome, descricao, preco, estoque) VALUES
('Filtro de óleo',          'Filtro para troca de óleo',              35.00, 50),
('Óleo motor 5W30 (1L)',    'Óleo sintético para motor',              32.00, 100),
('Pastilha de freio diant.','Par de pastilhas dianteiras',            120.00, 30),
('Disco de freio',          'Disco ventilado dianteiro',              180.00, 20),
('Amortecedor dianteiro',   'Amortecedor telescópico',                280.00, 15),
('Correia dentada',         'Correia para distribuição',              95.00, 25),
('Vela de ignição',         'Vela iridium',                           45.00, 80),
('Cabo de vela (jogo)',     'Jogo de cabos de vela',                  90.00, 20),
('Filtro de ar',            'Filtro de ar do motor',                  40.00, 60),
('Filtro de combustível',   'Filtro para sistema de injeção',         55.00, 40),
('Pneu 195/65 R15',         'Pneu radial aro 15',                    320.00, 32),
('Fluido de freio DOT4',    'Fluido para sistema de freios',          30.00, 45);

-- Ordens de Serviço
INSERT INTO Ordem_Servico (id_veiculo, id_equipe, data_emissao, data_conclusao, status, descricao_problema) VALUES
(1,  1, '2024-01-10', '2024-01-10', 'Concluída',   'Revisão periódica 45.000 km'),
(3,  1, '2024-01-15', '2024-01-16', 'Concluída',   'Freios com barulho ao frear'),
(5,  2, '2024-02-01', '2024-02-03', 'Concluída',   'Revisão completa 15.000 km'),
(6,  3, '2024-02-10', '2024-02-12', 'Concluída',   'Suspensão com barulho e vibração'),
(7,  1, '2024-03-05', '2024-03-05', 'Concluída',   'Troca de óleo de rotina'),
(2,  2, '2024-03-20', '2024-03-22', 'Concluída',   'Problema na elétrica - não liga'),
(4,  3, '2024-04-02', '2024-04-04', 'Concluída',   'Correia dentada a substituir'),
(8,  1, '2024-04-15', '2024-04-16', 'Concluída',   'Troca de pneus e alinhamento'),
(9,  2, '2024-05-01', '2024-05-03', 'Concluída',   'Revisão completa e limpeza de bicos'),
(10, 3, '2024-05-10', '2024-05-15', 'Concluída',   'Funilaria - amassado lateral'),
(1,  1, '2024-06-01', NULL,         'Em andamento','Revisão completa 50.000 km'),
(3,  2, '2024-06-05', NULL,         'Aguardando',  'Barulho no câmbio ao engrenar'),
(5,  1, '2024-06-10', NULL,         'Em andamento','Troca de amortecedores'),
(7,  3, '2024-06-12', NULL,         'Aguardando',  'Diagnóstico elétrico - luz de injeção acesa');

-- Serviços das OS
INSERT INTO OS_Servico (id_os, id_servico, quantidade) VALUES
(1,  1, 1), (1,  9, 1),
(2,  2, 1),
(3,  9, 1),
(4,  3, 1), (4,  6, 2),
(5,  1, 1),
(6,  5, 1), (6,  7, 1),
(7,  4, 1),
(8, 11, 1), (8,  3, 1),
(9,  8, 1), (9,  9, 1),
(10, 10, 1),
(11, 9, 1),
(12, 12, 1),
(13, 6, 2),
(14, 5, 1);

-- Peças das OS
INSERT INTO OS_Peca (id_os, id_peca, quantidade, preco_unit) VALUES
(1,  1, 1, 35.00),  (1,  2, 4, 32.00),  (1,  9, 1, 40.00),
(2,  3, 1, 120.00), (2,  4, 1, 180.00), (2, 12, 1, 30.00),
(3,  1, 1, 35.00),  (3,  2, 4, 32.00),  (3,  9, 1, 40.00), (3, 10, 1, 55.00),
(4,  5, 2, 280.00),
(5,  1, 1, 35.00),  (5,  2, 4, 32.00),
(6,  7, 4, 45.00),  (6,  8, 1, 90.00),
(7,  6, 1, 95.00),
(8, 11, 4, 320.00),
(9,  1, 1, 35.00),  (9,  2, 4, 32.00),  (9, 10, 1, 55.00),
(11, 1, 1, 35.00),  (11, 2, 5, 32.00),  (11, 9, 1, 40.00), (11,10, 1, 55.00),
(13, 5, 2, 280.00);


-- ============================================================
-- PARTE 3: QUERIES SQL
-- ============================================================

-- -------------------------------------------------------
-- Q1. SELEÇÃO SIMPLES
-- Pergunta: Quais são todos os clientes cadastrados?
-- -------------------------------------------------------
SELECT id_cliente, nome, cpf, telefone, email
FROM Cliente
ORDER BY nome;


-- -------------------------------------------------------
-- Q2. FILTRO COM WHERE
-- Pergunta: Quais OS estão com status "Em andamento" ou "Aguardando"?
-- -------------------------------------------------------
SELECT id_os, id_veiculo, status, data_emissao, descricao_problema
FROM Ordem_Servico
WHERE status IN ('Em andamento', 'Aguardando')
ORDER BY data_emissao;


-- -------------------------------------------------------
-- Q3. ATRIBUTO DERIVADO
-- Pergunta: Qual o valor total de peças de cada OS
--           (quantidade × preço unitário)?
-- -------------------------------------------------------
SELECT
    op.id_os,
    SUM(op.quantidade * op.preco_unit)                   AS total_pecas,
    SUM(op.quantidade * op.preco_unit) * 0.10            AS margem_10pct
FROM OS_Peca op
GROUP BY op.id_os
ORDER BY total_pecas DESC;


-- -------------------------------------------------------
-- Q4. ATRIBUTO DERIVADO + FILTRO
-- Pergunta: Quais veículos têm mais de 5 anos de fabricação
--           (considerando 2024 como ano base)?
-- -------------------------------------------------------
SELECT
    id_veiculo,
    marca,
    modelo,
    ano,
    (2024 - ano)            AS idade_anos,
    kilometragem,
    ROUND(kilometragem / (2024 - ano), 0) AS km_medio_por_ano
FROM Veiculo
WHERE (2024 - ano) > 5
ORDER BY idade_anos DESC;


-- -------------------------------------------------------
-- Q5. ORDER BY
-- Pergunta: Liste os mecânicos em ordem decrescente de salário,
--           mostrando faixa salarial.
-- -------------------------------------------------------
SELECT
    id_mecanico,
    nome,
    especialidade,
    salario,
    CASE
        WHEN salario >= 3700 THEN 'Senior'
        WHEN salario >= 3200 THEN 'Pleno'
        ELSE 'Junior'
    END AS faixa_salarial
FROM Mecanico
ORDER BY salario DESC;


-- -------------------------------------------------------
-- Q6. HAVING
-- Pergunta: Quais clientes possuem mais de 1 veículo cadastrado?
-- -------------------------------------------------------
SELECT
    c.id_cliente,
    c.nome,
    COUNT(v.id_veiculo) AS qtd_veiculos
FROM Cliente c
JOIN Veiculo v ON c.id_cliente = v.id_cliente
GROUP BY c.id_cliente, c.nome
HAVING COUNT(v.id_veiculo) > 1
ORDER BY qtd_veiculos DESC;


-- -------------------------------------------------------
-- Q7. HAVING em serviços
-- Pergunta: Quais serviços foram solicitados em 2 ou mais OS?
-- -------------------------------------------------------
SELECT
    s.id_servico,
    s.descricao,
    s.valor_mao_obra,
    COUNT(oss.id_os) AS vezes_solicitado
FROM Servico s
JOIN OS_Servico oss ON s.id_servico = oss.id_servico
GROUP BY s.id_servico, s.descricao, s.valor_mao_obra
HAVING COUNT(oss.id_os) >= 2
ORDER BY vezes_solicitado DESC;


-- -------------------------------------------------------
-- Q8. JOIN SIMPLES
-- Pergunta: Qual o histórico de OS de cada veículo
--           com dados do cliente?
-- -------------------------------------------------------
SELECT
    os.id_os,
    c.nome                         AS cliente,
    CONCAT(v.marca,' ',v.modelo)   AS veiculo,
    v.placa,
    v.ano,
    os.data_emissao,
    os.data_conclusao,
    os.status,
    os.descricao_problema
FROM Ordem_Servico os
JOIN Veiculo       v  ON os.id_veiculo  = v.id_veiculo
JOIN Cliente       c  ON v.id_cliente   = c.id_cliente
ORDER BY os.data_emissao DESC;


-- -------------------------------------------------------
-- Q9. JOIN COMPLEXO + ATRIBUTO DERIVADO
-- Pergunta: Qual o valor total (mão-de-obra + peças) de cada OS
--           concluída, junto com os dados do cliente e veículo?
-- -------------------------------------------------------
SELECT
    os.id_os,
    c.nome                          AS cliente,
    CONCAT(v.marca,' ',v.modelo)    AS veiculo,
    v.placa,
    os.data_emissao,
    os.data_conclusao,
    DATEDIFF(os.data_conclusao, os.data_emissao) AS dias_em_servico,
    COALESCE(SUM(DISTINCT oss.quantidade * s.valor_mao_obra), 0) AS total_mao_obra,
    COALESCE(SUM(DISTINCT op.quantidade  * op.preco_unit),   0) AS total_pecas,
    COALESCE(SUM(DISTINCT oss.quantidade * s.valor_mao_obra), 0)
    + COALESCE(SUM(DISTINCT op.quantidade * op.preco_unit),  0) AS valor_total
FROM Ordem_Servico os
JOIN Veiculo       v   ON os.id_veiculo = v.id_veiculo
JOIN Cliente       c   ON v.id_cliente  = c.id_cliente
LEFT JOIN OS_Servico oss ON os.id_os    = oss.id_os
LEFT JOIN Servico    s   ON oss.id_servico = s.id_servico
LEFT JOIN OS_Peca    op  ON os.id_os    = op.id_os
WHERE os.status = 'Concluída'
GROUP BY os.id_os, c.nome, v.marca, v.modelo, v.placa,
         os.data_emissao, os.data_conclusao
ORDER BY valor_total DESC;


-- -------------------------------------------------------
-- Q10. JOIN + HAVING — Ranking de clientes por gasto total
-- Pergunta: Quais clientes gastaram mais de R$500 no total em OS?
-- -------------------------------------------------------
SELECT
    c.id_cliente,
    c.nome                                              AS cliente,
    c.email,
    COUNT(DISTINCT os.id_os)                            AS total_os,
    ROUND(SUM(oss.quantidade * s.valor_mao_obra)
        + SUM(op.quantidade  * op.preco_unit), 2)       AS gasto_total
FROM Cliente       c
JOIN Veiculo       v   ON c.id_cliente  = v.id_cliente
JOIN Ordem_Servico os  ON v.id_veiculo  = os.id_veiculo
JOIN OS_Servico    oss ON os.id_os      = oss.id_os
JOIN Servico       s   ON oss.id_servico = s.id_servico
JOIN OS_Peca       op  ON os.id_os      = op.id_os AND oss.id_os = op.id_os
WHERE os.status = 'Concluída'
GROUP BY c.id_cliente, c.nome, c.email
HAVING gasto_total > 500
ORDER BY gasto_total DESC;


-- -------------------------------------------------------
-- Q11. JOIN + ORDER BY — Mecânicos por equipe
-- Pergunta: Qual a composição de cada equipe e o custo
--           de mão-de-obra por equipe?
-- -------------------------------------------------------
SELECT
    e.nome_equipe,
    m.nome          AS mecanico,
    m.especialidade,
    m.salario,
    SUM(m.salario) OVER (PARTITION BY e.id_equipe) AS custo_equipe
FROM Equipe         e
JOIN Equipe_Mecanico em ON e.id_equipe   = em.id_equipe
JOIN Mecanico        m  ON em.id_mecanico = m.id_mecanico
ORDER BY e.nome_equipe, m.salario DESC;


-- -------------------------------------------------------
-- Q12. Subquery + JOIN
-- Pergunta: Quais peças foram utilizadas em mais de 2 OS
--           e ainda têm estoque baixo (< 30 unidades)?
-- -------------------------------------------------------
SELECT
    p.id_peca,
    p.nome,
    p.preco,
    p.estoque,
    uso.qtd_os
FROM Peca p
JOIN (
    SELECT id_peca, COUNT(DISTINCT id_os) AS qtd_os
    FROM OS_Peca
    GROUP BY id_peca
    HAVING COUNT(DISTINCT id_os) > 1
) uso ON p.id_peca = uso.id_peca
WHERE p.estoque < 30
ORDER BY uso.qtd_os DESC, p.estoque ASC;


-- -------------------------------------------------------
-- Q13. Produtividade por equipe
-- Pergunta: Qual equipe concluiu mais OS e em menor tempo médio?
-- -------------------------------------------------------
SELECT
    eq.nome_equipe,
    COUNT(os.id_os)                                         AS total_os_concluidas,
    ROUND(AVG(DATEDIFF(os.data_conclusao, os.data_emissao)), 1) AS media_dias_atendimento
FROM Equipe         eq
JOIN Ordem_Servico  os ON eq.id_equipe = os.id_equipe
WHERE os.status = 'Concluída'
GROUP BY eq.id_equipe, eq.nome_equipe
HAVING COUNT(os.id_os) >= 1
ORDER BY total_os_concluidas DESC, media_dias_atendimento ASC;
