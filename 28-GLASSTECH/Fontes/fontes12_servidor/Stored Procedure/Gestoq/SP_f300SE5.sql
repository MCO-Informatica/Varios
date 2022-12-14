USE [TESTE]
GO

IF OBJECT_ID('f300SE5') > 0
BEGIN
	DROP PROC dbo.f300SE5
END

GO

CREATE Procedure [dbo].[f300SE5]( 
	@idVctTit int, 
	@idBanco int, 
	@cData char(10), 
	@nCheque int, 
	@cHist char(50), 
	@nJuros float, 
	@nValor float, 
	--@nDesconto float,
	@cMvt char(10), 
	@cRecPag Char(1), 
	@cArqCNAB VarChar(50),
	@cOrigBD Varchar(1),
	@idBaixa int Out) As
Begin
	
	declare @idBaixaBV Int;
	select @idBaixaBV = 0;
	select @idBaixa = isnull( @idBaixa, 0 )
	
	If @cOrigBD = 'B'
	   Begin
	      If (@idBaixa = 0) and (@cRecPag = 'R')  SELECT @idBaixaBV = ISNULL(case PAGO when 'S' then 0 else 1 end,0), @nJuros = isnull(@nJuros,0) + ISNULL(JUROS,0) + ISNULL(PREV_JUROS,0) FROM [192.168.0.7].[BVTESTE].[dbo].[VENCTITULO] VCT WHERE ID_VENCTITULO = @idVctTit and VENCIMENTO > '2015-12-31';
          select @idBaixaBV = ISNULL( @idBaixaBV, 0 );

		  If @idBaixaBV <> 0

		   Begin
				
			  --If IsNull(@nDesconto,0) > 0 begin
			--	Update v set v.DESCONTO = IsNull(@nDesconto,0) From [192.168.0.7].[BV].dbo.VENCTITULO as v WHERE v.ID_VENCTITULO = @idVctTit;
			  --end		
				
				
			 Select @idBaixa = MAX(ID_BAIXA_PARCIAL) + 1 From [192.168.0.7].[BVTESTE].dbo.BAIXA_PARCIAL;

			 INSERT INTO [192.168.0.7].[BVTESTE].[dbo].[BAIXA_PARCIAL] 
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
	--			,[CADASTRO]
				,[LOGIN]
				,[ID_ADIANTAMENTO_COMPENSACAO]
				,[ArqCNAB]) 
			
			 SELECT
				@idBaixa  ID_BAIXA_PARCIAL
				,@idVctTit ID_VENCTITULO
				,@idBanco --ID_CONTA
				,CAST( @cData AS datetime) DATA
				,case @nCheque when 0 then null else @nCheque end ID_CHEQUE
				,@cHist OBS
				,0 OUTRAS_DESP
				,cast( @nJuros as decimal(10,2)) JUROS
				,NULL ID_BAIXADOC
				,0 ID_ADIANTAMENTO
				,0.00 VALOR_X
				,cast( @nValor as decimal( 10,2)) VALOR
	--			,CAST( @cMvt as datetime) CADASTRO
				,'Totvs' LOGIN
				,NULL ID_ADIANTAMENTO_COMPENSACAO
				,@cArqCNAB;
				
			INSERT INTO [192.168.0.7].[BVTESTE].[dbo].[BAIXADOC]
			   ([ID_BAIXADOC]
			   ,[DESCRICAO]
			   ,[TIPO]
			   ,[ID_CONTA]
			   ,[DATABAIXA]
			   ,[ID_EMPRESA]
			   ,[ID_CHEQUE])
			VALUES
			   ((select MAX(ID_BAIXADOC) from [192.168.0.7].[BVTESTE].[dbo].[BAIXADOC]) + 1
			   ,case @cRecPag when 'P' then 'SISPAG' else 'SISCOB' end
			   ,0
			   ,@idBanco  --case @idBanco when 100 then 1 else 24 end
			   ,CAST( @cData AS datetime)
			   ,null
			   ,null);

			End
		 
		 Else
		 
			Begin 

			  if (@idBaixaBV = 0) and (@idVctTit > 300000) SELECT @idBaixa = ISNULL(MAX(ID_BAIXA_PARCIAL),0) FROM [192.168.0.7].[BVTESTE].[dbo].[BAIXA_PARCIAL] WHERE ID_VENCTITULO = @idVctTit;
		    
			End;	   
	   
	   End
	Else 
	   Begin
	  	  SELECT @idBaixa = ISNULL(case PAGO when 'S' then 0 else 1 end,0), @nJuros = isnull(@nJuros,0) + ISNULL(JUROS,0) + ISNULL(PREV_JUROS,0) FROM [TESTE].[dbo].[VENCTITULO] VCT WHERE ID_VENCTITULO = @idVctTit;
		  select @idBaixa = ISNULL( @idBaixa, 0 );
	     
		  If @idBaixa <> 0

			   Begin

				 Begin transaction
				 
				 --If IsNull(@nDesconto,0) > 0 begin
				 --	Update v set v.DESCONTO = IsNull(@nDesconto,0) From TPCP.dbo.VENCTITULO as v WHERE v.ID_VENCTITULO = @idVctTit;
				 --end
				 
				 Select @idBaixa = MAX(ID_BAIXA_PARCIAL) + 1 From TESTE.dbo.BAIXA_PARCIAL;

				 INSERT INTO [TESTE].[dbo].[BAIXA_PARCIAL] 
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
					,@idBanco ID_CONTA
					,CAST( @cData AS datetime) DATA
					,case @nCheque when 0 then null else @nCheque end ID_CHEQUE
					,@cHist OBS
					,0 OUTRAS_DESP
					,cast( case @cRecPag when 'P' then case when (@nValor - VCT.SALDO) > 0 then (@nValor - VCT.SALDO) else 0 end else @nJuros end as decimal(10,2)) JUROS
					,NULL ID_BAIXADOC
					,0 ID_ADIANTAMENTO
					,0.00 VALOR_X
					,cast( @nValor as decimal( 10,2)) VALOR
					,CAST( @cMvt as datetime) CADASTRO
					,'Totvs' LOGIN
					,NULL ID_ADIANTAMENTO_COMPENSACAO
					,@cArqCNAB
				 FROM [TESTE].[dbo].[VENCTITULO] VCT
				 WHERE VCT.ID_VENCTITULO = @idVctTit;
					
				INSERT INTO [TESTE].[dbo].[BAIXADOC]
				   ([ID_BAIXADOC]
				   ,[DESCRICAO]
				   ,[TIPO]
				   ,[ID_CONTA]
				   ,[DATABAIXA]
				   ,[ID_EMPRESA]
				   ,[ID_CHEQUE])
				VALUES
				   ((select MAX(ID_BAIXADOC) from [TESTE].[dbo].[BAIXADOC]) + 1
				   ,case @cRecPag when 'P' then 'SISPAG' else 'SISCOB' end
				   ,0
				   ,@idBanco
				   ,CAST( @cData AS datetime)
				   ,null
				   ,null);

				commit
				End
			 
			 Else
			 
				Begin 

				  SELECT @idBaixa = ISNULL(MAX(ID_BAIXA_PARCIAL),0) FROM [TESTE].[dbo].[BAIXA_PARCIAL] WHERE ID_VENCTITULO = @idVctTit;	    
			    
				End;
		End;

     
     Set @idBaixa = isnull( @idBaixa, 0 )

End;
