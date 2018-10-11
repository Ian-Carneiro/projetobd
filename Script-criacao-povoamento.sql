CREATE TABLE Pessoa (
CPF CHARACTER(11),
nome VARCHAR(100) NOT NULL,
telefone VARCHAR(15) NOT NULL,
PRIMARY KEY (CPF)
);

CREATE TABLE Cliente (
CPF CHARACTER(11),
endereco VARCHAR(100) NOT NULL,
PRIMARY KEY (CPF),
FOREIGN KEY (CPF) REFERENCES Pessoa (CPF)
);

CREATE TABLE Setor (
nome VARCHAR(50) NOT NULL,
codigo INT,
PRIMARY KEY (codigo),
CHECK (codigo>0)
);

CREATE TABLE Funcionario(
matricula CHARACTER(6),
CPF CHARACTER(11) UNIQUE,
dataAdmissao DATE NOT NULL,
salario REAL NOT NULL,
codSetor INT NOT NULL,
PRIMARY KEY (matricula),
FOREIGN KEY (CPF) REFERENCES Pessoa(CPF),
FOREIGN KEY (codSetor) REFERENCES Setor(codigo),
CHECK(salario>0)
);

CREATE TABLE GerenciaSetor(
gerente CHARACTER(6),
codSetor INT,
dataInicio DATE NOT NULL,
dataFim DATE,
PRIMARY KEY (gerente, codSetor),
FOREIGN KEY (gerente) REFERENCES Funcionario (matricula),
FOREIGN KEY (codSetor) REFERENCES Setor (codigo)
);

CREATE TABLE Venda (
codVenda INT,
data DATE NOT NULL,
formaPagamento VARCHAR(8) NOT NULL,
valor REAL NOT NULL,
matFuncionario CHARACTER(6),
PRIMARY KEY(codVenda),
FOREIGN KEY (matFuncionario) REFERENCES Funcionario (matricula),
CHECK (codVenda>0),
CHECK (valor>0)
);

CREATE TABLE ClienteVenda (
codVenda INT,
cpfCliente CHARACTER(11),
numCheque VARCHAR(10),
FOREIGN KEY (codVenda) REFERENCES Venda (codVenda),
FOREIGN KEY (cpfCliente) REFERENCES Pessoa (CPF),
PRIMARY KEY (numCheque) 
);

CREATE TABLE Compra (
codigo INT,
valor REAL NOT NULL,
data DATE NOT NULL,
matFuncionario CHARACTER(6),
CHECK (valor>0),
PRIMARY KEY (codigo),
FOREIGN KEY (matFuncionario) REFERENCES Funcionario(matricula)
); 

CREATE TABLE Cartão (
numero VARCHAR(16),
bandeira VARCHAR(20) NOT NULL,
parcelas INT NOT NULL,
titular VARCHAR(100) NOT NULL,
CHECK (parcelas>0),
PRIMARY KEY (numero)
);

CREATE TABLE VendaCartao (
numeroCartao VARCHAR(16),
codVenda INT,
PRIMARY KEY (numeroCartao, codVenda),
FOREIGN KEY (numeroCartao) REFERENCES Cartão(numero),
FOREIGN KEY (codVenda) REFERENCES Venda(codVenda)
);

CREATE TABLE Fornecedor(
CNPJ CHARACTER(18),
nome VARCHAR(100) NOT NULL,
numEndereco INT NOT NULL,
rua VARCHAR(60) NOT NULL,
cidade VARCHAR(35) NOT NULL,
bairro VARCHAR(60) NOT NULL,
CONSTRAINT pk_fornecedor PRIMARY KEY (CNPJ)
);

CREATE TABLE TelefoneFornecedor(
CNPJ CHARACTER(18),
telefone VARCHAR(15),
CONSTRAINT pk_telefoneFornecedor PRIMARY KEY (CNPJ,telefone),
CONSTRAINT fk_cnpjForncedor FOREIGN KEY (CNPJ) REFERENCES Fornecedor(CNPJ)
);

CREATE TABLE CompraFornecedor(
CNPJ CHARACTER(18),
codCompra INT,
CONSTRAINT pk_compraForncedor PRIMARY KEY (CNPJ, codCompra),
CONSTRAINT fk_compraFornecedorForFornecedor FOREIGN KEY (CNPJ) REFERENCES Fornecedor(CNPJ),
CONSTRAINT fk_compraFornecedorForCompra FOREIGN KEY (codCompra) REFERENCES Compra(codigo)
);

CREATE TABLE Produto(
codBarras VARCHAR(13),
valorUnid REAL NOT NULL,
descricao VARCHAR(80) NOT NULL,
CONSTRAINT pk_produto PRIMARY KEY (codBarras)
);

CREATE TABLE FornecedorProduto(
CNPJ CHARACTER(18),
codBarrasProduto VARCHAR(13),
CONSTRAINT pk_fornecedorProduto PRIMARY KEY (CNPJ, codBarrasProduto),
CONSTRAINT fk_fornecedorProdutoForFornecedor FOREIGN KEY (CNPJ) REFERENCES Fornecedor(CNPJ),
CONSTRAINT fk_fornecedorProdutoForProduto FOREIGN KEY (codBarrasProduto) REFERENCES Produto(codBarras)
);

CREATE TABLE CompraProduto(
codCompra INT,
codBarrasProduto VARCHAR(13),
CONSTRAINT pk_compraProduto PRIMARY KEY (codCompra, codBarrasProduto),
CONSTRAINT fk_compraProdutoForCompra FOREIGN KEY (codCompra) REFERENCES Compra(codigo),
CONSTRAINT fk_compraProdutoForProduto FOREIGN KEY (codBarrasProduto) REFERENCES Produto(codBarras)
);

CREATE TABLE VendaProduto(
codVenda INT,
codBarrasProduto VARCHAR(13),
quantidade INT NOT NULL,
CONSTRAINT pk_vendaProduto PRIMARY KEY (codVenda, codBarrasProduto),
CONSTRAINT fk_vendaProdutoForVenda FOREIGN KEY (codVenda) REFERENCES Venda(codVenda),
CONSTRAINT fk_vendaProdutoForProduto FOREIGN KEY (codBarrasProduto) REFERENCES Produto(codBarras),
CONSTRAINT quantidadePositiva CHECK (quantidade > 0)
);

CREATE TABLE Estoque(
idLote INT,
produtosLote INT NOT NULL,
dataFornecimento DATE NOT NULL,
dataValidade DATE NOT NULL,
quantidadeLotes INT NOT NULL,
codBarrasProduto VARCHAR(13),
CONSTRAINT pk_estoque PRIMARY KEY (idLote),
CONSTRAINT fk_estoqueForProduto FOREIGN KEY (codBarrasProduto) REFERENCES Produto(codBarras),
CONSTRAINT quantMinimaProdutosLote CHECK(produtosLote > 0),
CONSTRAINT quantMinimaLotes CHECK(quantidadeLotes >= 0)
);

--Povoamento da tabela Pessoa
INSERT INTO Pessoa VALUES('80143817000', 'Alice', '83998350911');
INSERT INTO Pessoa VALUES('57126386060', 'Sophia', '83987021883');
INSERT INTO Pessoa VALUES('69305311032', 'Helena', '83996339656');
INSERT INTO Pessoa VALUES('56059472060', 'Valentina', '83984411400');
INSERT INTO Pessoa VALUES('58486545064', 'Miguel', '83988650159');
INSERT INTO Pessoa VALUES('43942001055', 'Arthur', '83985734990');
INSERT INTO Pessoa VALUES('10427597072', 'Bernardo', '83985459432');
INSERT INTO Pessoa VALUES('99415616059', 'Heitor', '83992971315');
INSERT INTO Pessoa VALUES('43995365000', 'Júlia', '83986753859');
INSERT INTO Pessoa VALUES('94480025057', 'Pedro', '83995609748');
INSERT INTO Pessoa VALUES('12143817000', 'João', '83999511952');

--Povoamento da tabela Cliente
INSERT INTO Cliente VALUES('80143817000', 'RUA ZÉ DAS COUVES, 132');
INSERT INTO Cliente VALUES('94480025057', 'RUA ZÉ DAS COUVES, 321');
INSERT INTO Cliente VALUES('57126386060', 'RUA ZÉ DAS COUVES, 221');
INSERT INTO Cliente VALUES('43995365000', 'RUA PROFESSOR ALENCAR, 789');
INSERT INTO Cliente VALUES('99415616059', 'RUA PROFESSOR ALENCAR, 453');
INSERT INTO Cliente VALUES('69305311032', 'RUA PROFESSOR ALENCAR, 467');

--Povoamento da tabela Setor
INSERT INTO Setor VALUES ('atendimento', 1);
INSERT INTO Setor VALUES ('financeiro', 2);
INSERT INTO Setor VALUES ('gerência', 3);
INSERT INTO Setor VALUES ('almoxarifado', 4);
INSERT INTO Setor VALUES ('marketing', 5);

--Povoamento da tabela Funcionario
INSERT INTO Funcionario VALUES('1111-1', '56059472060', '2017-01-03', 1000.00, 1);
INSERT INTO Funcionario VALUES('1111-2', '58486545064', '2018-05-05', 1500.00, 1);
INSERT INTO Funcionario VALUES('1111-3', '43942001055', '2014-05-05', 4043.00, 3);
INSERT INTO Funcionario VALUES('1111-4', '10427597072', '2015-04-23', 3050.00, 5);
INSERT INTO Funcionario VALUES('1111-5', '80143817000', '2013-03-29', 3050.00, 2);
INSERT INTO Funcionario VALUES('1111-6', '12143817000', '2015-03-29', 2000.00, 4);

--Povoamento da tabela GerenciaSetor
INSERT INTO GerenciaSetor VALUES('1111-1', 1, '2017-02-03', '2018-04-05');
INSERT INTO GerenciaSetor VALUES('1111-2', 1, '2018-06-29', null);
INSERT INTO GerenciaSetor VALUES('1111-3', 3, '2014-06-05', null);
INSERT INTO GerenciaSetor VALUES('1111-4', 5, '2015-05-23', null);
INSERT INTO GerenciaSetor VALUES('1111-5', 2, '2013-03-29', null);
INSERT INTO GerenciaSetor VALUES('1111-6', 4, '2015-03-29', null);

--Povoamento da tabela Venda
INSERT INTO Venda VALUES(1, '2018-09-7', 'cartão', 197.91, '1111-2'); 
INSERT INTO Venda VALUES(2, '2018-09-7', 'cheque', 393.3, '1111-2'); 
INSERT INTO Venda VALUES(3, '2018-09-7', 'cartão', 26.95, '1111-1'); 
INSERT INTO Venda VALUES(4, '2018-09-7', 'dinheiro', 41.4, '1111-1'); 
INSERT INTO Venda VALUES(5, '2018-09-7', 'cheque', 107.8, '1111-1'); 
INSERT INTO Venda VALUES(6, '2018-09-7', 'cartão', 29.4, '1111-2'); 
INSERT INTO Venda VALUES(7, '2018-09-10', 'cartão', 48.93, '1111-2'); 
INSERT INTO Venda VALUES(8, '2018-09-10', 'cheque', 285.87, '1111-2'); 
INSERT INTO Venda VALUES(9, '2018-09-10', 'cartão', 6.99, '1111-1'); 
INSERT INTO Venda VALUES(10, '2018-09-10', 'cheque', 175.00, '1111-1'); 
INSERT INTO Venda VALUES(11, '2018-09-10', 'cheque', 529.2, '1111-1');

--Povoamento da tabela ClienteVenda
INSERT INTO ClienteVenda VALUES(5, '80143817000', '000545');
INSERT INTO ClienteVenda VALUES(2, '94480025057', '003251');
INSERT INTO ClienteVenda VALUES(8, '43995365000', '055388');
INSERT INTO ClienteVenda VALUES(10, '99415616059', '012756');
INSERT INTO ClienteVenda VALUES(11, '69305311032', '000989');

--Povoamento da tabela Compra
INSERT INTO Compra VALUES(5, 5022.00, '2018-09-06', '1111-6');
INSERT INTO Compra VALUES(4, 3050.00, '2018-09-05', '1111-6');
INSERT INTO Compra VALUES(3, 6770.00, '2018-09-04', '1111-6');
INSERT INTO Compra VALUES(2, 7500.00, '2018-09-03', '1111-6');
INSERT INTO Compra VALUES(1, 3312.00, '2018-09-02', '1111-6');	

--Povoamento da tabela Cartão
INSERT INTO Cartão VALUES('5278415299452338', 'MasterCard', 3, 'FELIPE NOAH RIBEIRO');
INSERT INTO Cartão VALUES('5176533150137062', 'MasterCard', 4, 'YURI C E MORAES');
INSERT INTO Cartão VALUES('5101417723962281', 'MasterCard', 3, 'MIGUEL LEANDRO L MENDES');
INSERT INTO Cartão VALUES('4485078431133976', 'Visa', 2, 'LUCIA L M RODRIGUES');
INSERT INTO Cartão VALUES('4539161021923976', 'Visa', 5, 'ISABELA ELIANE T CARVALHO');

--Povoamento da tabela VendaCartao
INSERT INTO VendaCartao VALUES('5278415299452338', 1);
INSERT INTO VendaCartao VALUES('5176533150137062', 3);
INSERT INTO VendaCartao VALUES('5101417723962281', 6);
INSERT INTO VendaCartao VALUES('4485078431133976', 7);
INSERT INTO VendaCartao VALUES('4539161021923976', 9);

--Povoamento da tabela Fornecedor
INSERT INTO Fornecedor VALUES('14.218.835/0001-27', 'Johnson & Johnson Comercio E Distribuicao Ltda.', '233', 'Nova Brunswick', ' Nova Jersey', ' Nova Jersey');
INSERT INTO Fornecedor VALUES('13.481.309/0192-13', 'RN COMÉRCIO S.A.','132','Praçã central', 'Mossoró','Praçã central RN');
INSERT INTO Fornecedor VALUES('11.242.434/0231-34', 'M Dias Branco Indústria e Comércio de Alimentos', '242','Av. Padre Cicero', 'Juazeiro do Norte', 'Centro');
INSERT INTO Fornecedor VALUES('23.142.552/0023-12', 'Econômico Supermercado','193','R. Abel Sobreira', 'Juazeiro do Norte', 'Santa Tereza');
INSERT INTO Fornecedor VALUES('24.513.234/0153-23', 'Dw Acessórios','374','Padre Nestor Sampaio', 'Juazeiro do Norte', 'Lagoa Seca');


--Povoamento da tabela TelefoneFornecedor
INSERT INTO TelefoneFornecedor VALUES('14.218.835/0001-27', '(88)3242-6352');
INSERT INTO TelefoneFornecedor VALUES('14.218.835/0001-27', '(88)2425-1242');
INSERT INTO TelefoneFornecedor VALUES('13.481.309/0192-13', '(88)7969-2374');
INSERT INTO TelefoneFornecedor VALUES('11.242.434/0231-34', '(88)5274-2583');
INSERT INTO TelefoneFornecedor VALUES('24.513.234/0153-23', '(88)2343-7390');
INSERT INTO TelefoneFornecedor VALUES('24.513.234/0153-23','(88)2673-7557');

--Povoamento da tabela CompraFornecedor
INSERT INTO CompraFornecedor VALUES('14.218.835/0001-27', '4');
INSERT INTO CompraFornecedor VALUES('13.481.309/0192-13', '5');
INSERT INTO CompraFornecedor VALUES('11.242.434/0231-34', '2');
INSERT INTO CompraFornecedor VALUES('23.142.552/0023-12', '3');
INSERT INTO CompraFornecedor VALUES('24.513.234/0153-23', '1');

--Povoamento da tabela Produto
INSERT INTO Produto VALUES('0242-1342', 6.99, 'SHAMPOO Infaltil - Johnson & Johnson');
INSERT INTO Produto VALUES('0284-2365', 4.90, 'SABÃO DE COCO - RN');
INSERT INTO Produto VALUES('0364-3740', 6.90, 'ARROZ INTEGRAL - M Dias Comércio');
INSERT INTO Produto VALUES('3470-4743', 5.39, 'MACARRÃO - Econômico Supermercado');
INSERT INTO Produto VALUES('0374-3874', 21.99, 'BATOM MATE SOUL KISS - Dw Acessórios');
INSERT INTO Produto VALUES('3729-4629', 25.00, 'BIFE - Friboi');

--Povoamento da tabela FornecedorProduto
INSERT INTO FornecedorProduto VALUES('14.218.835/0001-27', '0242-1342');
INSERT INTO FornecedorProduto VALUES('13.481.309/0192-13', '0284-2365');
INSERT INTO FornecedorProduto VALUES('11.242.434/0231-34', '0364-3740');
INSERT INTO FornecedorProduto VALUES('23.142.552/0023-12', '3470-4743');
INSERT INTO FornecedorProduto VALUES('24.513.234/0153-23', '0374-3874');

--Povoamento da tabela CompraProduto
INSERT INTO CompraProduto VALUES (5,'0284-2365');
INSERT INTO CompraProduto VALUES (4,'0242-1342');
INSERT INTO CompraProduto VALUES (3,'3470-4743');
INSERT INTO CompraProduto VALUES (2,'0364-3740');
INSERT INTO CompraProduto VALUES (1,'0374-3874');

--Povoamento da tabela VendaProduto
INSERT INTO VendaProduto VALUES (1,'0374-3874',9);
INSERT INTO VendaProduto VALUES (2,'0364-3740',57);
INSERT INTO VendaProduto VALUES (3,'3470-4743',5);
INSERT INTO VendaProduto VALUES (4,'0364-3740',6);
INSERT INTO VendaProduto VALUES (5,'3470-4743',20);
INSERT INTO VendaProduto VALUES (6,'0284-2365',6);
INSERT INTO VendaProduto VALUES (7,'0242-1342',7);
INSERT INTO VendaProduto VALUES (8,'0374-3874',13);
INSERT INTO VendaProduto VALUES (9,'0242-1342',1);
INSERT INTO VendaProduto VALUES (10,'3729-4629',7);
INSERT INTO VendaProduto VALUES (11,'0284-2365',108);

--Povoamento da tabela Estoque
INSERT INTO Estoque VALUES (1, 30, '2018-01-1', '2020-9-4', 3, '0242-1342');
INSERT INTO Estoque VALUES (2, 15, '2018-3-4', '2021-4-2', 4, '0284-2365');
INSERT INTO Estoque VALUES (3, 60, '2017-11-11', '2019-12-12', 2, '0364-3740');
INSERT INTO Estoque VALUES (4, 25, '2018-5-6', '2020-1-2', 5, '3470-4743');
INSERT INTO Estoque VALUES (5, 50, '2018-2-23', '2021-2-5', 2, '0374-3874');
INSERT INTO Estoque VALUES (6, 4, '2017-5-28', '2029-6-3', 4, '3729-4629');
INSERT INTO Estoque VALUES (7, 4, '2017-1-21', '2031-5-7', 6, '3729-4629');