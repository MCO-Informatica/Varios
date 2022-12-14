USE [TESTE]
GO

IF OBJECT_ID('IncFornec') > 0
BEGIN
	DROP PROC dbo.IncFornec
END

GO

CREATE procedure [dbo].[IncFornec] ( @cNome varchar(50), @cIE varchar(20), @cCEP varchar(8), @cMun varchar(40), @cPais varchar(5), @cFone varchar(15), @cNro varchar(10), @cUf varchar(2), @cBairro varchar(20), @cLgr varchar(50), @cCNPJ varchar(20), @idCliente int out) as
begin

	declare @idCidade int;

    select top 1 @idCidade = ID_CIDADE from CIDADE where DESCRICAO = @cMun and UF = @cUf
	
	begin transaction

	IF DB_NAME() = 'TESTE'
    BEGIN
		PRINT 'AMBIENTE DE TESTES'
		select @idCliente = MAX( ID_CLIENTE ) + 1 from [192.168.0.7].BVTESTE.dbo.CLIENTE	
	END
	ELSE
	BEGIN
		select @idCliente = MAX( ID_CLIENTE ) + 1 from [192.168.0.7].BV.dbo.CLIENTE	
	END
--	select @idCliente = MAX( ID_CLIENTE ) + 1 from TESTE.dbo.CLIENTE

	IF DB_NAME() = 'TESTE'
    BEGIN
		PRINT 'AMBIENTE DE TESTES'
		insert TESTE.dbo.CLIENTE(ID_CLIENTE,
								 NOME, 
								 RGINSC, 
								 CEP, 
								 TELEFONE, 
								 NUMERO, 
								 BAIRRO, 
								 ENDERECO,
								 CPFCGC, 
								 REGISTRO, 
								 ID_CIDADE, 
								 ID_ATIVIDADE,
								 POS,
								 ID_TIPO_TRIBUTACAO,
								 ID_CAPTACAO,
								 FANTASIA,
								 INSC_MUNICIPAL,
								 END_COB ,
								 BAIRRO_COB,
								 CID_COB,
								 CEP_COB,
								 OBS,
								 ID_EMPRESA,
								 CONTATO,
								 COMPL_COB,
								 TIPO,
								 CLASSE,
								 FRETE_POR,
								 ID_TABELA,
								 PAIS)
	
		select @idCliente, @cNome , @cIE, @cCEP, @cFone, @cNro, @cBairro, @cLgr , @cCNPJ, 1, @idCidade, 9,'I',0,1,@cNome,'','','','','','',1,'','',0,1,2,0,@cPais+'BRASIL'
	END
	ELSE
    BEGIN
		insert TPCP.dbo.CLIENTE (ID_CLIENTE,
								 NOME, 
								 RGINSC, 
								 CEP, 
								 TELEFONE, 
								 NUMERO, 
								 BAIRRO, 
								 ENDERECO,
								 CPFCGC, 
								 REGISTRO, 
								 ID_CIDADE, 
								 ID_ATIVIDADE,
								 POS,
								 ID_TIPO_TRIBUTACAO,
								 ID_CAPTACAO,
								 FANTASIA,
								 INSC_MUNICIPAL,
								 END_COB ,
								 BAIRRO_COB,
								 CID_COB,
								 CEP_COB,
								 OBS,
								 ID_EMPRESA,
								 CONTATO,
								 COMPL_COB,
								 TIPO,
								 CLASSE,
								 FRETE_POR,
								 ID_TABELA,
								 PAIS)
	
		select @idCliente, @cNome , @cIE, @cCEP, @cFone, @cNro, @cBairro, @cLgr , @cCNPJ, 1, @idCidade, 9,'I',0,1,@cNome,'','','','','','',1,'','',0,1,2,0,@cPais+'BRASIL'
	END


	If @@ERROR <> 0 
	   begin
	      rollback
	      select @idCliente = 0
	   end
	Else
	   begin
	      commit
	   end;

	select @idCliente
	
end;
