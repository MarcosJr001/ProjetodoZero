-- Criação do Banco de Dados
CREATE DATABASE OficinaDB;
USE OficinaDB;

-- Criação das Tabelas
CREATE TABLE Clientes (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    telefone VARCHAR(20),
    email VARCHAR(100),
    endereco VARCHAR(255)
);

CREATE TABLE Veiculos (
    id_veiculo INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT,
    marca VARCHAR(50),
    modelo VARCHAR(50),
    ano INT,
    placa VARCHAR(10) UNIQUE,
    FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente)
);

CREATE TABLE Servicos (
    id_servico INT AUTO_INCREMENT PRIMARY KEY,
    descricao VARCHAR(255) NOT NULL,
    preco DECIMAL(10,2) NOT NULL
);

CREATE TABLE OrdensServico (
    id_ordem INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT,
    id_veiculo INT,
    data_abertura DATE NOT NULL,
    data_conclusao DATE,
    status ENUM('Aberta', 'Em andamento', 'Concluída', 'Cancelada') NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente),
    FOREIGN KEY (id_veiculo) REFERENCES Veiculos(id_veiculo)
);

CREATE TABLE ItensOrdemServico (
    id_item INT AUTO_INCREMENT PRIMARY KEY,
    id_ordem INT,
    id_servico INT,
    quantidade INT NOT NULL,
    preco_unitario DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_ordem) REFERENCES OrdensServico(id_ordem),
    FOREIGN KEY (id_servico) REFERENCES Servicos(id_servico)
);

-- Inserção de Dados
INSERT INTO Clientes (nome, telefone, email, endereco) VALUES
('João Silva', '11999999999', 'joao@email.com', 'Rua A, 123'),
('Maria Souza', '11888888888', 'maria@email.com', 'Rua B, 456');

INSERT INTO Veiculos (id_cliente, marca, modelo, ano, placa) VALUES
(1, 'Toyota', 'Corolla', 2020, 'ABC-1234'),
(2, 'Honda', 'Civic', 2019, 'DEF-5678');

INSERT INTO Servicos (descricao, preco) VALUES
('Troca de óleo', 150.00),
('Alinhamento', 100.00),
('Balanceamento', 80.00);

INSERT INTO OrdensServico (id_cliente, id_veiculo, data_abertura, status) VALUES
(1, 1, '2024-02-10', 'Aberta'),
(2, 2, '2024-02-09', 'Concluída');

INSERT INTO ItensOrdemServico (id_ordem, id_servico, quantidade, preco_unitario) VALUES
(1, 1, 1, 150.00),
(1, 2, 1, 100.00),
(2, 3, 1, 80.00);

-- Consultas SQL
-- 1. Selecionar todos os clientes
SELECT * FROM Clientes;

-- 2. Filtrar veículos de um cliente específico
SELECT * FROM Veiculos WHERE id_cliente = 1;

-- 3. Listar ordens de serviço abertas
SELECT * FROM OrdensServico WHERE status = 'Aberta';

-- 4. Calcular o valor total de cada ordem de serviço
SELECT id_ordem, SUM(quantidade * preco_unitario) AS total
FROM ItensOrdemServico
GROUP BY id_ordem;

-- 5. Listar serviços mais caros que R$100
SELECT * FROM Servicos WHERE preco > 100;

-- 6. Ordenar clientes pelo nome
SELECT * FROM Clientes ORDER BY nome;

-- 7. Selecionar ordens de serviço com valor total superior a R$ 200
SELECT id_ordem, SUM(quantidade * preco_unitario) AS total
FROM ItensOrdemServico
GROUP BY id_ordem
HAVING total > 200;

-- 8. Juntar informações de ordens de serviço com clientes e veículos
SELECT os.id_ordem, c.nome, v.modelo, os.data_abertura, os.status
FROM OrdensServico os
JOIN Clientes c ON os.id_cliente = c.id_cliente
JOIN Veiculos v ON os.id_veiculo = v.id_veiculo;
