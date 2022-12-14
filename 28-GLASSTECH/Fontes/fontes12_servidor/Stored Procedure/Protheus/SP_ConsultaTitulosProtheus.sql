USE [RHR17_UNIFICACAO]

GO

/****** Object:  StoredProcedure [dbo].[ConsultaTitulosProtheus]    Script Date: 19/08/2019 11:36:26 ******/
SET ANSI_NULLS ON

GO

SET QUOTED_IDENTIFIER ON

GO

IF OBJECT_ID('ConsultaTitulosProtheus') > 0
BEGIN
	DROP PROC dbo.ConsultaTitulosProtheus
END

GO

CREATE procedure [dbo].[ConsultaTitulosProtheus]
	@ID_TITULO int
as
begin

--declare @ID_TITULO int = 127
declare @BAIXAPARCIAL int = -1
declare @BAIXA int = 0;
declare @SALDOGESTOQ numeric(12,3) = 0.00;
declare @SALDOPROTHEUS numeric(12,3) = 0.00;
declare @ID_VENCTITULO int = 0;
declare @MENSAGEM varchar(200) = '';

select @BAIXAPARCIAL = ID_BAIXA_PARCIAL  from TESTE.dbo.BAIXA_PARCIAL where
      EXISTS (select * from TESTE.dbo.VENCTITULO as B
where B.ID_TITULO = @ID_TITULO AND B.ID_VENCTITULO = BAIXA_PARCIAL.ID_VENCTITULO)
     
select @BAIXA = s.R_E_C_N_O_ from RHR17_UNIFICACAO.dbo.SE5010 s where 
  cast(s.E5_IDMOVI as int) = @BAIXAPARCIAL and 
  s.E5_MOTBX = 'DEB' and 
  s.E5_ARQCNAB <> '' and
  s.D_E_L_E_T_ <> '*'
  
SELECT @BAIXA

if (@BAIXA > 0 ) SELECT @MENSAGEM = 'O titulo foi pago via Sispag entre em contato com departamento de TI para mais detalhes!'

If @MENSAGEM = ''
   Begin

	 -- Cursor para percorrer os nomes dos objetos 
	 DECLARE parcelas_p CURSOR SCROLL FOR SELECT ID_VENCTITULO FROM TESTE.dbo.VENCTITULO WHERE ID_TITULO = @ID_TITULO
     -- Abrindo Cursor para leitura
	 OPEN parcelas_p

	 -- Lendo a próxima linha
	 FETCH NEXT FROM parcelas_p INTO @ID_VENCTITULO

	 -- Percorrendo linhas do cursor (enquanto houverem)
	 WHILE @@FETCH_STATUS = 0
		BEGIN

		  --SELECT @ID_TITULO = @schemaName + '.' + @procName
		  select  @SALDOPROTHEUS = (@SALDOPROTHEUS + (SE2.E2_VALOR - SE2.E2_SALDO)) from RHR17_UNIFICACAO.dbo.SE2010 AS SE2 where cast(SE2.E2_IDMOV as int) = @ID_VENCTITULO AND SE2.D_E_L_E_T_ <> '*' 
		  -- Lendo a próxima linha
		  FETCH NEXT FROM parcelas_p INTO @ID_VENCTITULO
		END;


	 if @SALDOPROTHEUS > 0 

	    SELECT @MENSAGEM = 'O Titulo ja possui Lançamentos no Proteus impossivel continuar!'

	 else

	    Begin
	 
           FETCH FIRST FROM parcelas_p INTO @ID_VENCTITULO

	       WHILE @@FETCH_STATUS = 0
		     BEGIN

        	    --SELECT @ID_TITULO = @schemaName + '.' + @procName
		        select  @SALDOPROTHEUS = (@SALDOPROTHEUS + (SE2.E2_VALOR - SE2.E2_SALDO)) from SE2010 AS SE2 where cast(SE2.E2_IDMOV as int) = @ID_VENCTITULO AND SE2.D_E_L_E_T_ <> '*' 
			    -- Lendo a próxima linha
			    FETCH NEXT FROM parcelas_p INTO @ID_VENCTITULO

		        UPDATE SE2010 SET D_E_L_E_T_ = '*', R_E_C_D_E_L_ = R_E_C_N_O_ WHERE CAST( E2_IDMOV AS INT ) = @ID_VENCTITULO

		    End;

		End;
    	-- Fechando Cursor para leitura

	    CLOSE parcelas_p

	    -- Desalocando o cursor
	    DEALLOCATE parcelas_p 

    End;

SELECT @MENSAGEM AS MENSAGEM  

end
