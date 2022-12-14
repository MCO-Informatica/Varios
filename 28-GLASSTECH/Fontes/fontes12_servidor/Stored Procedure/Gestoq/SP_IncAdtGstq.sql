USE [TESTE]
GO

IF OBJECT_ID('IncAdtGstq') > 0
BEGIN
	DROP PROC dbo.IncAdtGstq
END

GO

CREATE PROCEDURE [dbo].[IncAdtGstq] ( @idConta int, @idCliente int, @dMovto char(10), @nValor float, @cHst varchar(60), @cLogin varchar(20), @cDocto varchar(20), @cDecCrd Char(1), @cFilial char(4), @cTpBx char(1), @IdAdtoOrig int, @IdVctTit int, @cOrigBD char(1), @idMovto int output, @idAdto int output, @cHstPre varchar(100) output )
AS

    /*
       paramentro @cTpBx indica 'A' inclui adiantamento e movimentação bancaria e 'C' compensação somente inclusão do adiantamento
    
    */
    
    declare @cNroNF varchar(9);
    declare @idBaixa int;
    declare @nClasse int;
    select @cNroNF = substring( @cDocto, 1, 9 );
    select @idMovto = null;
    
    select @nClasse = Classe from PRE_NOTA where NRO_NF = cast( @cNroNF as int) and YEAR( EMISSAO ) > 2016
    select @nClasse = isnull( @nClasse, 0 ) -- Verifica nivel da pre nota igual a 8 título deve ser gravado no BV

    BEGIN TRANSACTION 

    If @cOrigBD = 'B' /*(@cFilial = '9001') Or ( @nClasse = 8 )*/
    
       BEGIN
          
          EXEC [192.168.0.7].[BVTESTE].[dbo].[IncAdtGstq] @idConta, @idCliente, @dMovto, @nValor, @cHst, @cLogin, @cDocto, @cDecCrd, @cFilial, @cTpBx, @IdAdtoOrig, @IdVctTit, @idMovto output, @idAdto output;
          
          If @cTpBx = 'A'
          
             SELECT @cHstPre = (SELECT CASE ISNULL( NF.NRO_NF, 0 ) WHEN 0 THEN 'Recebimento antecipado Pré-Nota ' + CAST( PNT.NRO_NF as varchar(9) ) ELSE 'Compensar Nota Fiscal ' + CAST( NF.NRO_NF as varchar(9) ) END 
                                FROM [TESTE].[dbo].[PRE_NOTA] PNT 
                                LEFT OUTER JOIN [TESTE].[dbo].PRE_NOTA_NF PNF ON PNT.ID_NOTA = PNF.ID_PRE_NOTA 
                                LEFT OUTER JOIN [TESTE].[dbo].NOTA NF ON NF.ID_NOTA = PNF.ID_NOTA 
                                WHERE PNT.NRO_NF = CAST( @cNroNF as int )
                               )
          Else

             SELECT @cHstPre = '';
               
       END;

	ELSE
	   
	   BEGIN

		  If @cTpBx = 'A'

		     BEGIN

   	            SELECT @idMovto = ( SELECT MAX(ID_MOV_CONTA)+1 FROM MOV_CONTA )
				  
				INSERT INTO [TESTE].[dbo].[MOV_CONTA]
							  ([ID_MOV_CONTA]
							  ,[VALOR]
							  ,[ID_TP_MOV_CONTA]
							  ,[DATA]
							  ,[DOC]
							  ,[REFERENCIA]
							  ,[ID_CONTA]
							  ,[DB_CR]
							  ,[LOGIN_IN]
							  ,[LOGIN_OUT]
							  ,[docx]
							  ,[ID_TRANSF_BANCARIA])
				SELECT
							  @idMovto
							  , @nValor
							  , 61
							  , @dMovto
							  , ltrim(@cDocto) + CAST( @idMovto as varchar(10))
							  , @cHst
							  , @idConta
							  , @cDecCrd
							  , @cLogin
							  , NULL
							  , NULL
							  , NULL
			END;

		  SELECT @idAdto = ( SELECT MAX( ID_ADIANTAMENTO ) + 1 FROM ADIANTAMENTO )

		  INSERT INTO [TESTE].[dbo].[ADIANTAMENTO]
					   ([ID_ADIANTAMENTO]
					   ,[ID_CONTA]
					   ,[ID_CLIENTE]
					   ,[DATA]
					   ,[VALOR]
					   ,[SALDO]
					   ,[REFERENCIA]
					   ,[DEB_CRED]
					   ,[LOGIN]
					   ,[ID_MOV_CONTA]
					   ,[ID_CHEQUE]
					   ,[IsAdiantamentoFornecedor]
					   ,[CADASTRO]
					   ,[ID_OPERACIONAL])
		  SELECT
					   @idAdto
					   , @idConta
					   , @idCliente
					   , @dMovto
					   , @nValor
					   , case @cTpBx when 'A' then @nValor else 0 end
					   , @cHst
					   , @cDecCrd
					   , @cLogin
					   , @idMovto
					   , null
					   , 0
					   , GETDATE()
					   , 0

          If @cTpBx = 'A'

             SELECT @cHstPre = (SELECT CASE ISNULL( NF.NRO_NF, 0 ) WHEN 0 THEN 'Recebimento antecipado Pré-Nota ' + CAST( PNT.NRO_NF as varchar(9) ) ELSE 'Compensar Nota Fiscal ' + CAST( NF.NRO_NF as varchar(9) ) END
                                FROM [TESTE].[dbo].[PRE_NOTA] PNT 
                                LEFT OUTER JOIN [TESTE].[dbo].PRE_NOTA_NF PNF ON PNT.ID_NOTA = PNF.ID_PRE_NOTA
                                LEFT OUTER JOIN [TESTE].[dbo].NOTA NF ON NF.ID_NOTA = PNF.ID_NOTA
                                WHERE PNT.NRO_NF = CAST( @cNroNF as int)
                               )
          Else

			 update ADIANTAMENTO set SALDO = (SALDO - @nValor) where ID_ADIANTAMENTO = @IdAdtoOrig

		     select @idBaixa = MAX(ID_BAIXA_PARCIAL) + 1 from TESTE.dbo.BAIXA_PARCIAL;

   			 insert into [TESTE].[dbo].[BAIXA_PARCIAL] 
			   ([ID_BAIXA_PARCIAL]
				,[ID_VENCTITULO]
				,[ID_CONTA]
				,[DATA]
				,[ID_CHEQUE]
				,[OBS]
				,[OUTRAS_DESP]
				,[JUROS]
				,[ID_BAIXADOC]
				,[ID_ADIANTAMENTO]
				,[VALOR_X]
				,[VALOR]
				,[CADASTRO]
				,[LOGIN]
				,[ID_ADIANTAMENTO_COMPENSACAO]
				,[ArqCnab]
				) 

			 SELECT
				@idBaixa  ID_BAIXA_PARCIAL
				,@idVctTit ID_VENCTITULO
				,@idConta ID_CONTA
				,CAST( @dMovto AS datetime) DATA
				,null ID_CHEQUE
				,substring( @cHst, 1, 35 ) OBS
				,0 OUTRAS_DESP
				,0 JUROS
				,NULL ID_BAIXADOC
				,@idAdto ID_ADIANTAMENTO
				,0.00 VALOR_X
				,cast( @nValor as decimal( 10,2)) VALOR
				,getdate() CADASTRO
				,@cLogin LOGIN
				,@IdAdtoOrig ID_ADIANTAMENTO_COMPENSACAO
				,'FINA330'
			 FROM [TESTE].[dbo].[VENCTITULO] VCT
			 WHERE VCT.ID_VENCTITULO = @idVctTit;

             SELECT @cHstPre = '', @idMovto = @idBaixa;

	    END;

	COMMIT;