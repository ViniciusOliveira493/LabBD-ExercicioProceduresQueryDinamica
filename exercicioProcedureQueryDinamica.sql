CREATE DATABASE bdProdutos
GO
USE bdProdutos
CREATE TABLE tbProduto(
	codigo				INT				NOT NULL
	, nome				VARCHAR(100)	NOT NULL
	, valor				DECIMAL(7,2)	NOT NULL
	PRIMARY KEY (codigo)
);
CREATE TABLE tbEntrada(
	codigoTransacao		INT				NOT NULL
	, codigoProduto		INT				NOT NULL
	, qtde				INT				NOT NULL
	, valorTotal		DECIMAL(7,2)	NOT NULL
	PRIMARY KEY (codigoTransacao)
	CONSTRAINT fk_entradaProduto FOREIGN KEY (codigoProduto) REFERENCES tbProduto(codigo)
);
CREATE TABLE tbSaida(
	codigoTransacao		INT				NOT NULL
	, codigoProduto		INT				NOT NULL
	, qtde				INT				NOT NULL
	, valorTotal		DECIMAL(7,2)	NOT NULL
	PRIMARY KEY (codigoTransacao)
	CONSTRAINT fk_saidaProduto FOREIGN KEY (codigoProduto) REFERENCES tbProduto(codigo)
);

--===================================================================================================================
CREATE PROCEDURE sp_registrarTransacao(@codigoTransacao	INT, @codigoProduto INT, @qtde INT, @codigo CHAR)
AS
DECLARE @table VARCHAR(10)
DECLARE @valor DECIMAL(7,2)

IF (UPPER(@codigo) = 'E') 
BEGIN
	SET @table = 'tbEntrada'
END
ELSE
BEGIN
	IF (UPPER(@codigo) = 'S')
		BEGIN 
			SET @table = 'tbSaida'
		END		
	ELSE
		BEGIN
			RAISERROR('código inválido',16,1)
		END
END 
SELECT @valor = p.valor 
FROM tbProduto AS p 
WHERE codigo = 1 
DECLARE @query VARCHAR(MAX)
DECLARE @valorTotal DECIMAL(7,2)
SET @valorTotal = @valor * @qtde
SET @query = 'INSERT INTO ' + @table + ' VALUES('+CAST(@codigoTransacao AS VARCHAR(15))+','+CAST(@codigoProduto AS VARCHAR(15))+','+CAST(@qtde AS VARCHAR(15)) + ',' + CAST(@valorTotal AS VARCHAR(15))+')'
exec (@query)

--================================================= INSERT ==========================================================
INSERT INTO tbProduto(codigo,nome,valor)
	VALUES
		(1,'Mouse',30)
		,(2,'Teclado',49.99)
--===================================================================================================================
EXEC sp_registrarTransacao 1,1,60,'a'

--===================================================================================================================
	