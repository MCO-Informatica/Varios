USE [RHR17_UNIFICACAO]
GO
/****** Object:  StoredProcedure [dbo].[UpdFlxCxa]    Script Date: 19/08/2019 13:36:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

IF OBJECT_ID('UpdFlxCxa') > 0
BEGIN
	DROP PROC dbo.UpdFlxCxa
END

GO

CREATE PROCEDURE [dbo].[UpdFlxCxa]
	-- Add the parameters for the stored procedure here
	@cDta Char(8)
	
AS
BEGIN
	SET NOCOUNT ON;

DECLARE @iRec Int;
DECLARE @cDtIni Char(8);
DECLARE @cDtFim Char(8);
DECLARE @cExec VarChar(512);

SELECT @cDtIni = '20151101'
SELECT @cDtFim = @cDta

If Object_Id (N'tempdb.dbo.##TempNat', N'U') is not null drop table ##TempNat;

/*
  []----------------------------------------------------------------------------------------------------------------------------------------------[]
  
                                                                  Contas a Receber/Pagar na Baixa
  
  []----------------------------------------------------------------------------------------------------------------------------------------------[]
*/
SELECT

case E5_FILORIG
      when '0101' then 'THM'
      when '0102' then 'THF'
 	  when '0201' then 'TWM' 
	  when '0202' then 'TWF '
	  when '0301' then 'GTECH'
	  when '0401' then 'PRIMI'
	  when '0501' then 'REPEL'
	  when '0601' then 'JIMAQ'
	  when '0701' then 'FFM'   
 	  when '0215' then 'TWP'   
	  when '9001' then 'VR Provisões'   
	  else 'Sem Classif'
end Filial,

SUBSTRING( E5_DATA, 1, 4 ) Ano,
SUBSTRING( E5_DATA, 5, 2 ) Mes,
SUBSTRING( E5_DATA, 7, 2 ) Dia,
CASE WHEN EV_NATUREZ IS NULL THEN E5_NATUREZ ELSE EV_NATUREZ END Natureza, 
CASE WHEN EV_NATUREZ IS NULL THEN ISNULL(SED.ED_DESCRIC, 'Cadastrar') ELSE ISNULL(MNAT.ED_DESCRIC, 'Cadastrar') END [Descrição], 
CASE WHEN EV_NATUREZ IS NULL THEN ISNULL(SED.ED_OBS    , 'Cadastrar') ELSE ISNULL(MNAT.ED_OBS, 'Cadastrar') END  [Grupo], 
E5_RECPAG Rec_Pag, 
SUM(
  CASE E5_RECPAG 
  WHEN 'P'
     THEN E5_VALOR * 
        CASE WHEN ISNULL( SEVF.Laminado, 0 ) = 0 AND ISNULL( SEVF.Temperado, 0 ) = 0 THEN
           CASE E5_FILORIG
              when '0101' then -0
              when '0102' then -1
 	          when '0201' then -1
	          when '0202' then -1
	          when '0401' then -0.9
	          when '0501' then -0.5
	          when '0601' then -1
	          when '0701' then -0.9
	          when '0215' then -1
	          when '9001' then -1
	          else -1
            END
        ELSE 
           SEVF.Laminado * -1 
        END
   ELSE E5_VALOR *
      CASE 
         CASE WHEN EV_NATUREZ IS NULL THEN E5_NATUREZ ELSE EV_NATUREZ END 
         WHEN '10102' THEN 0
         ELSE 1
      END
   END *
   CASE WHEN EV_PERC IS NULL THEN 1 ELSE EV_PERC END ) Laminado, 

   SUM(
    CASE E5_RECPAG 
    WHEN 'P' 
     THEN E5_VALOR * 
     CASE WHEN ISNULL( SEVF.Laminado, 0 ) = 0 AND ISNULL( SEVF.Temperado, 0 ) = 0 THEN
        CASE E5_FILORIG
           when '0101' then -1
           when '0102' then -0
 	       when '0201' then -0
	       when '0202' then -0
	       when '0401' then -0.1
	       when '0501' then -0.5
	       when '0601' then -0
	       when '0701' then -0.1
           when '0215' then -0
	       when '9001' then 0
	       else -0
        END 
     ELSE 
        SEVF.Temperado * -1 
     END
   ELSE E5_VALOR *
      CASE 
         CASE WHEN EV_NATUREZ IS NULL THEN E5_NATUREZ ELSE EV_NATUREZ END 
         WHEN '10102' THEN 1
         ELSE 0
      END
   END *
   CASE WHEN EV_PERC IS NULL THEN 1 ELSE EV_PERC END ) Temperado, 
 RTRIM(E5_BENEF) + ' ' + CASE E5_NUMERO WHEN '' THEN E5_DOCUMEN ELSE E5_PREFIXO + ' ' + E5_NUMERO + E5_PARCELA END + ' ' + (CASE ISNULL( SE2.E2_FORNECE, '') WHEN '' THEN '' ELSE ' Emissão [' + SUBSTRING(SE2.E2_EMISSAO,7,2)+'/'+SUBSTRING(SE2.E2_EMISSAO,5,2)+'/'+SUBSTRING(SE2.E2_EMISSAO,1,4) + '] Vencto [' + + SUBSTRING(SE2.E2_VENCREA,7,2)+'/'+SUBSTRING(SE2.E2_VENCREA,5,2)+'/'+SUBSTRING(SE2.E2_VENCREA,1,4)+']' END) Documento,
--CASE E5_NUMERO WHEN '' THEN E5_DOCUMEN ELSE E5_PREFIXO + ' ' + E5_NUMERO + E5_PARCELA END Documento,
E5_CLIFOR [Código],
E5_BENEF [Beneficiário],
cast(E5_HISTOR as varchar(254)) [Histórico],
cast(0 as float) Valor,
cast( '' as varchar(50)) [Consolidado Analitico],
cast( '' as varchar(50)) [Consolidado Sintetico],
CAST(E5_DATA AS DATE ) [Data Compensação],
E5_TIPO [Tipo],
E5_NUMERO [Número do Documento],
E5_PARCELA [Parcela],
CAST( ISNULL(SE2.E2_EMISSAO, '19800101') AS DATE) [Data Emissão],
CAST( ISNULL(SE2.E2_VENCREA, '19800101') AS DATE) [Data Vencimento],
ISNULL(SE2.E2_VALLIQ,0) [Valor Original],
E5_AGENCIA [Agência],
E5_CONTA [Conta Corrente],
E5_MOTBX [Tipo Baixa],
E5_NUMCHEQ,
E5_BANCO,

/*	Data Compensação: data da compensação no extrato bancário (data da baixa no sistema);
	Tipo Documento: Nota fiscal, Cheque, Ordem Compra (antecipação), etc...
	Número Documento: número do documento;
	Número Parcela: número da parcela;
	Código Favorecido: código do cadastro do favorecido;
	Razão Social (Nome Fantasia): razão social ou nome fantasia do favorecido;
	Data Emissão: data de emissão do documento;
	Data Vencimento: data do vencimento do documento;
	Valor original: valor original do documento;
	Valor total: valor total pago/recebido;
	Empresa: Thermoglass ou outra empresa do grupo;
	Banco: nome do banco no qual foi creditado/debitado o valor;
	Conta corrente: número da conta corrente na qual foi creditado/debitado valor;
	Histórico (Observação): campo de observação ou detalhamento do pagamento/recebimento realizado;*/
row_number() over(order by E5_CLIFOR) idRec

INTO ##TempNat

FROM SE5010 SE5
LEFT OUTER JOIN SED010 SED ON SE5.E5_NATUREZ = SED.ED_CODIGO AND SED.D_E_L_E_T_ = ''

LEFT OUTER JOIN SEV010 SEV ON 
SEV.EV_FILIAL = SE5.E5_FILORIG AND 
SEV.EV_RECPAG = SE5.E5_RECPAG AND 
SEV.EV_PREFIXO = SE5.E5_PREFIXO AND
SEV.EV_NUM = SE5.E5_NUMERO AND 
SEV.EV_PARCELA = SE5.E5_PARCELA AND 
SEV.EV_CLIFOR = SE5.E5_CLIFOR AND 
SEV.EV_LOJA = SE5.E5_LOJA AND 
SEV.D_E_L_E_T_ = ''

LEFT OUTER JOIN SEVFOL SEVF ON 
SEVF.EV_FILIAL = SE5.E5_FILIAL COLLATE Latin1_General_100_BIN AND 
SEVF.EV_RECPAG = SE5.E5_RECPAG AND 
SEVF.EV_PREFIXO = SE5.E5_PREFIXO COLLATE Latin1_General_100_BIN AND
SEVF.EV_NUM = SE5.E5_NUMERO COLLATE Latin1_General_100_BIN  AND 
SEVF.EV_PARCELA = SE5.E5_PARCELA COLLATE Latin1_General_100_BIN AND 
SEVF.EV_CLIFOR = SE5.E5_CLIFOR COLLATE Latin1_General_100_BIN AND 
SEVF.EV_LOJA = SE5.E5_LOJA COLLATE Latin1_General_100_BIN AND 
SEVF.D_E_L_E_T_ = ''

LEFT OUTER JOIN SED010 MNAT ON SEV.EV_NATUREZ = MNAT.ED_CODIGO AND SED.D_E_L_E_T_ = ''
LEFT OUTER JOIN SE2010 SE2  ON 
SE2.E2_FILIAL = SE5.E5_FILORIG AND 
SE2.E2_PREFIXO = SE5.E5_PREFIXO AND
SE2.E2_NUM = SE5.E5_NUMERO AND 
SE2.E2_PARCELA = SE5.E5_PARCELA AND 
SE2.E2_FORNECE = SE5.E5_CLIFOR AND 
SE2.E2_LOJA = SE5.E5_LOJA AND 
SE2.D_E_L_E_T_ = ''

WHERE 
E5_DATA BETWEEN @cDtIni AND @cDtFim AND 
SE5.D_E_L_E_T_ = '' AND 
(SE5.E5_MOTBX = 'NOR' OR SE5.E5_MOTBX = 'CHQ' OR SE5.E5_MOTBX = 'MNL' OR SE5.E5_MOTBX = 'DEB') AND
E5_TIPODOC NOT IN ('DC','D2','JR','J2','TL','MT','M2','CM','C2','TR','TE') 

GROUP BY 
case E5_FILORIG
      when '0101' then 'THM'
      when '0102' then 'THF'
 	  when '0201' then 'TWM' 
	  when '0202' then 'TWF '
	  when '0301' then 'GTECH'
	  when '0401' then 'PRIMI'
	  when '0501' then 'REPEL'
	  when '0601' then 'JIMAQ'
	  when '0701' then 'FFM'   
      when '0215' then 'TWP'
	  when '9001' then 'VR Provisões'   
	  else 'Sem Classif'
end,
SUBSTRING( E5_DATA, 1, 4 ),
SUBSTRING( E5_DATA, 5, 2 ),
SUBSTRING( E5_DATA, 7, 2 ),
CASE WHEN EV_NATUREZ IS NULL THEN E5_NATUREZ ELSE EV_NATUREZ END, 
CASE WHEN EV_NATUREZ IS NULL THEN ISNULL(SED.ED_DESCRIC, 'Cadastrar') ELSE ISNULL(MNAT.ED_DESCRIC, 'Cadastrar') END, 
CASE WHEN EV_NATUREZ IS NULL THEN ISNULL(SED.ED_OBS    , 'Cadastrar') ELSE ISNULL(MNAT.ED_OBS, 'Cadastrar') END,
E5_RECPAG,
 RTRIM(E5_BENEF) + ' ' + CASE E5_NUMERO WHEN '' THEN E5_DOCUMEN ELSE E5_PREFIXO + ' ' + E5_NUMERO + E5_PARCELA END + ' ' + (CASE ISNULL( SE2.E2_FORNECE, '') WHEN '' THEN '' ELSE ' Emissão [' + SUBSTRING(SE2.E2_EMISSAO,7,2)+'/'+SUBSTRING(SE2.E2_EMISSAO,5,2)+'/'+SUBSTRING(SE2.E2_EMISSAO,1,4) + '] Vencto [' + + SUBSTRING(SE2.E2_VENCREA,7,2)+'/'+SUBSTRING(SE2.E2_VENCREA,5,2)+'/'+SUBSTRING(SE2.E2_VENCREA,1,4)+']' END),
--CASE E5_NUMERO WHEN '' THEN E5_DOCUMEN ELSE E5_PREFIXO + ' ' + E5_NUMERO + E5_PARCELA END ,
E5_CLIFOR,
E5_BENEF,
E5_HISTOR,
CAST(E5_DATA AS DATE ),
E5_TIPO,
E5_NUMERO,
E5_PARCELA,
CAST( ISNULL(SE2.E2_EMISSAO, '19800101') AS DATE),
CAST( ISNULL(SE2.E2_VENCREA, '19800101') AS DATE),
ISNULL(SE2.E2_VALLIQ,0),
E5_AGENCIA,
E5_CONTA,
E5_MOTBX,
E5_NUMCHEQ,
E5_BANCO

SELECT @iRec = MAX( idRec ) FROM ##TempNat

INSERT INTO ##TempNat

SELECT 

case D2_FILIAL
      when '0101' then 'THM'
      when '0102' then 'THF'
 	  when '0201' then 'TWM' 
	  when '0202' then 'TWF '
	  when '0301' then 'GTECH'
	  when '0401' then 'PRIMI'
	  when '0501' then 'REPEL'
	  when '0601' then 'JIMAQ'
	  when '0701' then 'FFM'   
	  when '0215' then 'TWP'   
	  when '9001' then 'VR Provisões'   
	  else 'Sem Classif'
end 
Filial,
SUBSTRING( D2_EMISSAO, 1, 4 ) Ano,
SUBSTRING( D2_EMISSAO, 5, 2 ) Mes,
SUBSTRING( D2_EMISSAO, 7, 2 ) Dia,
ED_CODIGO Natureza, 
ED_DESCRIC [Descrição], 
ISNULL(SED.ED_OBS    , 'Cadastrar') [Grupo], 
'F' Rec_Pag, 
SUM((D2_VALBRUT - ( D2_VALCOF + D2_VALPIS + CASE WHEN D2_EMISSAO > '20160331' THEN 0 ELSE D2_DESCZFR END)) * CASE WHEN ED_CODIGO <> '10102' THEN 1 ELSE 0 END) Laminado, 
SUM((D2_VALBRUT - ( D2_VALCOF + D2_VALPIS + CASE WHEN D2_EMISSAO > '20160331' THEN 0 ELSE D2_DESCZFR END)) * CASE ED_CODIGO WHEN '10102' THEN 1 ELSE 0 END) Temperado, 
D2_SERIE + ' ' + D2_DOC Documento,
D2_CLIENTE [Código],
A1_NREDUZ [Beneficiário],
'VENDA' [Histórico],
0 Valor,
cast( '' as varchar(50)) [Consolidado Analitico],
cast( '' as varchar(50)) [Consolidado Sintetico],

CAST(D2_EMISSAO AS DATE ) [Data Compensação],
'NF' [Tipo],
D2_DOC [Número do Documento],
D2_SERIE [Parcela],
CAST( D2_EMISSAO AS DATE) [Data Emissão],
CAST( D2_EMISSAO AS DATE) [Data Vencimento],
D2_TOTAL [Valor Original],
'' [Agência],
'' [Conta Corrente],
'' [Tipo Baixa],
'',
'',
(row_number() over(order by D2_CLIENTE) + @iRec) idRec 

FROM SD2010 SD2
LEFT OUTER JOIN SB1010 SB1 ON (SB1.B1_COD = SD2.D2_COD) AND (SB1.D_E_L_E_T_ = '')
LEFT OUTER JOIN SA1010 SA1 ON (SA1.A1_COD = SD2.D2_CLIENTE) AND (SA1.D_E_L_E_T_ = '')
LEFT OUTER JOIN SED010 SED ON (SED.ED_CODIGO = CASE SB1.B1_TIPOPRD 
												  WHEN 'T' THEN '10102' 
												  WHEN 'L' THEN '10101' 
												  WHEN 'K' THEN '10109' 
												  WHEN 'P' THEN '10110' 
												  WHEN 'V' THEN '10102' 
												  ELSE '10105' END) AND (SED.D_E_L_E_T_ = '')
--LEFT OUTER JOIN TESTE.dbo.NOTA ON CAST( NRO_NF AS INT) = CAST( D2_DOC AS INT) AND CONVERT( CHAR(8), EMISSAO, 112) = D2_EMISSAO AND D2_SERIE = NOTA.SERIE COLLATE SQL_Latin1_General_CP1_CI_AS AND CAST( D2_CLIENTE AS INT) = NOTA.ID_CLIENTE
WHERE 
(SD2.D2_EMISSAO BETWEEN @cDtIni AND @cDtFim) AND 
(SD2.D2_TIPO = 'N') AND
(SD2.D_E_L_E_T_ = '')
--(SD2.D2_DOC NOT IN ('000108124','000108642','000108811','000109067')) 
--(NOTA.POS <> 'D')

GROUP BY 
case D2_FILIAL
      when '0101' then 'THM'
      when '0102' then 'THF'
 	  when '0201' then 'TWM' 
	  when '0202' then 'TWF '
	  when '0301' then 'GTECH'
	  when '0401' then 'PRIMI'
	  when '0501' then 'REPEL'
	  when '0601' then 'JIMAQ'
	  when '0701' then 'FFM'   
	  when '0215' then 'TWP'
	  when '9001' then 'VR Provisões'   
	  else 'Sem Classif'
end, 
ED_CODIGO, 
SUBSTRING( D2_EMISSAO, 1, 4 ),
SUBSTRING( D2_EMISSAO, 5, 2 ),
SUBSTRING( D2_EMISSAO, 7, 2 ),
ED_DESCRIC, 
ED_OBS,
D2_SERIE + ' ' + D2_DOC,
D2_CLIENTE,
A1_NREDUZ,

CAST(D2_EMISSAO AS DATE ),
--'NF' [Tipo],
D2_DOC,
D2_SERIE,
CAST( D2_EMISSAO AS DATE),
CAST( D2_EMISSAO AS DATE),
D2_TOTAL
--'' [Agência],
--'' [Conta Corrente],
--'' [Tipo],

/*
  []----------------------------------------------------------------------------------------------------------------------------------------------[]
  
                                                                  Contas a Pagar Emissao
  
  []----------------------------------------------------------------------------------------------------------------------------------------------[]
*/

SELECT @iRec = MAX( idRec ) FROM ##TempNat

INSERT INTO ##TempNat

SELECT

case E2_FILORIG
      when '0101' then 'THM'
      when '0102' then 'THF'
 	  when '0201' then 'TWM' 
	  when '0202' then 'TWF '
	  when '0301' then 'GTECH'
	  when '0401' then 'PRIMI'
	  when '0501' then 'REPEL'
	  when '0601' then 'JIMAQ'
	  when '0701' then 'FFM'   
 	  when '0215' then 'TWP'   
	  when '9001' then 'VR Provisões'   
	  else 'Sem Classif'
end Filial,

SUBSTRING( E2_EMISSAO, 1, 4 ) Ano,
SUBSTRING( E2_EMISSAO, 5, 2 ) Mes,
SUBSTRING( E2_EMISSAO, 7, 2 ) Dia,
CASE WHEN EV_NATUREZ IS NULL THEN E2_NATUREZ ELSE EV_NATUREZ END Natureza, 
CASE WHEN EV_NATUREZ IS NULL THEN ISNULL(SED.ED_DESCRIC, 'Cadastrar') ELSE ISNULL(MNAT.ED_DESCRIC, 'Cadastrar') END [Descrição], 
CASE WHEN EV_NATUREZ IS NULL THEN ISNULL(SED.ED_OBS    , 'Cadastrar') ELSE ISNULL(MNAT.ED_OBS, 'Cadastrar') END [Grupo], 
'B' Rec_Pag, 
SUM(
  CASE 'P'
  WHEN 'P'
     THEN E2_VALOR * 
        CASE WHEN ISNULL( SEVF.Laminado, 0 ) = 0 AND ISNULL( SEVF.Temperado, 0 ) = 0 THEN
           CASE E2_FILORIG
              when '0101' then -0
              when '0102' then -1
 	          when '0201' then -1
	          when '0202' then -1
	          when '0401' then -0.9
	          when '0501' then -0.5
	          when '0601' then -1
	          when '0701' then -0.9
	          when '0215' then -1
	          when '9001' then -1
	          else -1
            END
        ELSE 
           SEVF.Laminado * -1 
        END
   ELSE E2_VALOR *
      CASE 
         CASE WHEN EV_NATUREZ IS NULL THEN E2_NATUREZ ELSE EV_NATUREZ END 
         WHEN '10102' THEN 0
         ELSE 1
      END
   END *
   CASE WHEN EV_PERC IS NULL THEN 1 ELSE EV_PERC END ) Laminado, 

   SUM(
    CASE 'P'
    WHEN 'P' 
     THEN E2_VALOR * 
     CASE WHEN ISNULL( SEVF.Laminado, 0 ) = 0 AND ISNULL( SEVF.Temperado, 0 ) = 0 THEN
        CASE E2_FILORIG
           when '0101' then -1
           when '0102' then -0
 	       when '0201' then -0
	       when '0202' then -0
	       when '0401' then -0.1
	       when '0501' then -0.5
	       when '0601' then -0
	       when '0701' then -0.1
           when '0215' then -0
	       when '9001' then 0
	       else -0
        END 
     ELSE 
        SEVF.Temperado * -1 
     END
   ELSE E2_VALOR *
      CASE 
         CASE WHEN EV_NATUREZ IS NULL THEN E2_NATUREZ ELSE EV_NATUREZ END 
         WHEN '10102' THEN 1
         ELSE 0
      END
   END *
   CASE WHEN EV_PERC IS NULL THEN 1 ELSE EV_PERC END ) Temperado, 

CASE E2_NUM WHEN '' THEN E2_NUM ELSE E2_PREFIXO + ' ' + E2_NUM + E2_PARCELA END Documento,
E2_FORNECE [Código],
E2_NOMFOR [Beneficiário],
E2_HIST [Histórico],
0 Valor,
cast( '' as varchar(50)) [Consolidado Analitico],
cast( '' as varchar(50)) [Consolidado Sintetico],

CAST(E2_EMISSAO AS DATE ) [Data Compensação],
E2_TIPO [Tipo],
E2_NUM [Número do Documento],
E2_PARCELA [Parcela],
CAST( SE2.E2_EMISSAO AS DATE) [Data Emissão],
CAST( SE2.E2_VENCREA AS DATE) [Data Vencimento],
SE2.E2_VALLIQ [Valor Original],
'' [Agência],
'' [Conta Corrente],
'' [Tipo Baixa],
'',
'',
(row_number() over(order by E2_FORNECE) + @iRec) idRec 

FROM SE2010 SE2
LEFT OUTER JOIN SED010 SED ON SE2.E2_NATUREZ = SED.ED_CODIGO AND SED.D_E_L_E_T_ = ''

LEFT OUTER JOIN SEV010 SEV ON 
SEV.EV_FILIAL = SE2.E2_FILIAL AND 
SEV.EV_RECPAG = 'P' AND 
SEV.EV_PREFIXO = SE2.E2_PREFIXO AND
SEV.EV_NUM = SE2.E2_NUM AND 
SEV.EV_PARCELA = SE2.E2_PARCELA AND 
SEV.EV_CLIFOR = SE2.E2_FORNECE AND 
SEV.EV_LOJA = SE2.E2_LOJA AND 
SEV.D_E_L_E_T_ = ''

LEFT OUTER JOIN SEVFOL SEVF ON 
SEVF.EV_FILIAL = SE2.E2_FILIAL COLLATE Latin1_General_100_BIN AND 
SEVF.EV_RECPAG = 'P' AND 
SEVF.EV_PREFIXO = SE2.E2_PREFIXO COLLATE Latin1_General_100_BIN AND
SEVF.EV_NUM = SE2.E2_NUM COLLATE Latin1_General_100_BIN AND 
SEVF.EV_PARCELA = SE2.E2_PARCELA COLLATE Latin1_General_100_BIN AND 
SEVF.EV_CLIFOR = SE2.E2_FORNECE COLLATE Latin1_General_100_BIN AND 
SEVF.EV_LOJA = SE2.E2_LOJA COLLATE Latin1_General_100_BIN AND 
SEVF.D_E_L_E_T_ = ''

LEFT OUTER JOIN SED010 MNAT ON SEV.EV_NATUREZ = MNAT.ED_CODIGO AND SED.D_E_L_E_T_ = ''

WHERE 
E2_EMISSAO BETWEEN '20150100' AND @cDtFim AND 
SE2.D_E_L_E_T_ = ''

GROUP BY 
case E2_FILORIG
      when '0101' then 'THM'
      when '0102' then 'THF'
 	  when '0201' then 'TWM' 
	  when '0202' then 'TWF '
	  when '0301' then 'GTECH'
	  when '0401' then 'PRIMI'
	  when '0501' then 'REPEL'
	  when '0601' then 'JIMAQ'
	  when '0701' then 'FFM'   
      when '0215' then 'TWP'
	  when '9001' then 'VR Provisões'   
	  else 'Sem Classif'
end,
SUBSTRING( E2_EMISSAO, 1, 4 ),
SUBSTRING( E2_EMISSAO, 5, 2 ),
SUBSTRING( E2_EMISSAO, 7, 2 ),
CASE WHEN EV_NATUREZ IS NULL THEN E2_NATUREZ ELSE EV_NATUREZ END, 
CASE WHEN EV_NATUREZ IS NULL THEN ISNULL(SED.ED_DESCRIC, 'Cadastrar') ELSE ISNULL(MNAT.ED_DESCRIC, 'Cadastrar') END, 
CASE WHEN EV_NATUREZ IS NULL THEN ISNULL(SED.ED_OBS    , 'Cadastrar') ELSE ISNULL(MNAT.ED_OBS, 'Cadastrar') END,
CASE E2_NUM WHEN '' THEN E2_NUM ELSE E2_PREFIXO + ' ' + E2_NUM + E2_PARCELA END ,
E2_FORNECE,
E2_NOMFOR,
E2_HIST,

CAST(E2_EMISSAO AS DATE ),
E2_TIPO,
E2_NUM,
E2_PARCELA,
CAST( SE2.E2_EMISSAO AS DATE),
CAST( SE2.E2_VENCREA AS DATE),
SE2.E2_VALLIQ

/*
  []-------------------------------------------------------------------------------------------------------------------------------------------[]


                                          Devolução de vendas ( nota fiscal de entrada formulário próprio )


  []-------------------------------------------------------------------------------------------------------------------------------------------[]
*/

SELECT @iRec = MAX( idRec ) FROM ##TempNat

INSERT INTO ##TempNat

SELECT 

case D1_FILIAL
      when '0101' then 'THM'
      when '0102' then 'THF'
 	  when '0201' then 'TWM' 
	  when '0202' then 'TWF '
	  when '0301' then 'GTECH'
	  when '0401' then 'PRIMI'
	  when '0501' then 'REPEL'
	  when '0601' then 'JIMAQ'
	  when '0701' then 'FFM'   
	  when '0215' then 'TWP'   
	  when '9001' then 'VR Provisões'   
	  else 'Sem Classif'
end 
Filial,
SUBSTRING( D1_EMISSAO, 1, 4 ) Ano,
SUBSTRING( D1_EMISSAO, 5, 2 ) Mes,
SUBSTRING( D1_EMISSAO, 7, 2 ) Dia,
ED_CODIGO Natureza, 
ED_DESCRIC [Descrição], 
'Devolução/Cancelamento Vendas' /*ISNULL(SED.ED_OBS    , 'Cadastrar')*/ [Grupo], 
'F' Rec_Pag, 
SUM((D1_TOTAL + D1_VALIPI + D1_ICMSRET - (D1_VALPIS + D1_VALCOF + D1_DESCICM)) * CASE WHEN ED_CODIGO <> '10102' THEN -1 ELSE 0 END) Laminado, 
SUM((D1_TOTAL + D1_VALIPI + D1_ICMSRET - (D1_VALPIS + D1_VALCOF + D1_DESCICM)) * CASE ED_CODIGO WHEN '10102' THEN -1 ELSE 0 END) Temperado, 
D1_SERIE + ' ' + D1_DOC Documento,
D1_FORNECE [Código],
A1_NREDUZ [Beneficiário],
'DEVOLUCAO' [Histórico],
0 Valor,
cast( '' as varchar(50)) [Consolidado Analitico],
cast( '' as varchar(50)) [Consolidado Sintetico],


CAST(D1_EMISSAO AS DATE ) [Data Compensação],
D1_TIPO [Tipo],
D1_DOC [Número do Documento],
'' [Parcela],
CAST( D1_EMISSAO AS DATE) [Data Emissão],
CAST( D1_EMISSAO AS DATE) [Data Vencimento],
D1_TOTAL [Valor Original],
'' [Agência],
'' [Conta Corrente],
'' [Tipo Baixa],
'',
'',
(row_number() over(order by D1_FORNECE) + @iRec) idRec 

FROM SD1010 SD1
LEFT OUTER JOIN SB1010 SB1 ON (SB1.B1_COD = SD1.D1_COD) AND (SB1.D_E_L_E_T_ = '')
LEFT OUTER JOIN SA1010 SA1 ON (SA1.A1_COD = SD1.D1_FORNECE) AND (SA1.D_E_L_E_T_ = '')
LEFT OUTER JOIN SED010 SED ON (SED.ED_CODIGO = CASE SB1.B1_TIPOPRD 
												  WHEN 'T' THEN '10102' 
												  WHEN 'L' THEN '10101' 
												  WHEN 'K' THEN '10109' 
												  WHEN 'P' THEN '10110' 
												  WHEN 'V' THEN '10102' 
												  ELSE '10105' END) AND (SED.D_E_L_E_T_ = '')
WHERE 
(SD1.D1_EMISSAO BETWEEN '20150801' AND @cDtFim) AND 
(SD1.D1_TIPO = 'D') AND
(SD1.D_E_L_E_T_ = '')

GROUP BY 
case D1_FILIAL
      when '0101' then 'THM'
      when '0102' then 'THF'
 	  when '0201' then 'TWM' 
	  when '0202' then 'TWF '
	  when '0301' then 'GTECH'
	  when '0401' then 'PRIMI'
	  when '0501' then 'REPEL'
	  when '0601' then 'JIMAQ'
	  when '0701' then 'FFM'   
	  when '0215' then 'TWP'
	  when '9001' then 'VR Provisões'   
	  else 'Sem Classif'
end, 
ED_CODIGO, 
SUBSTRING( D1_EMISSAO, 1, 4 ),
SUBSTRING( D1_EMISSAO, 5, 2 ),
SUBSTRING( D1_EMISSAO, 7, 2 ),
ED_DESCRIC, 
ED_OBS,
D1_SERIE + ' ' + D1_DOC,
D1_FORNECE,
A1_NREDUZ,
CAST(D1_EMISSAO AS DATE ),
D1_TIPO,
D1_DOC,
CAST( D1_EMISSAO AS DATE),
CAST( D1_EMISSAO AS DATE),
D1_TOTAL

UPDATE ##TempNat
SET Valor = ( Temperado + Laminado )

UPDATE ##TempNat
SET Rec_Pag = 'E'
FROM
(
select LTRIM(RTRIM(SERIE)) + '   '+ REPLICATE( '0', 9 - LEN( RTRIM(NRO_NF) )) + RTRIM(NRO_NF) NRO_NF FROM TESTE.dbo.NOTA WHERE POS = 'D' AND CONVERT( CHAR(8), EMISSAO, 112) BETWEEN '20140101' AND '20150731'
) Exclusao
where LTRIM(NRO_NF) = rTRIM(Documento) COLLATE Latin1_General_100_BIN AND Rec_Pag = 'F'


UPDATE ##TempNat
SET Rec_Pag = 'C'
FROM
(
select LTRIM(RTRIM(SERIE)) + '   '+ REPLICATE( '0', 9 - LEN( RTRIM(NRO_NF) )) + RTRIM(NRO_NF) NRO_NF FROM TESTE.dbo.NOTA WHERE POS = 'C' AND CONVERT( CHAR(8), EMISSAO, 112) BETWEEN @cDtIni AND '20151031'  --@cDtFim
) Exclusao
where LTRIM(NRO_NF) = rTRIM(Documento) COLLATE Latin1_General_100_BIN AND Rec_Pag = 'F'

UPDATE ##TempNat
SET  Temperado = Valor * 0.107863, Laminado = Valor * 0.892137
WHERE Ano = 2016 AND Mes = 1 AND Natureza = '20101'

UPDATE ##TempNat
SET  Temperado = Valor * 0.105776, Laminado = Valor * 0.894224
WHERE Ano = 2016 AND Mes = 2 AND Dia < 13  AND Natureza = '20101'

UPDATE ##TempNat
SET  Temperado = Valor * 0.12, Laminado = Valor * 0.88
WHERE Ano+Mes+Dia > '20160213' AND (Natureza = '20101')

UPDATE ##TempNat
SET  Temperado = Valor * 0.12, Laminado = Valor * 0.88
WHERE Ano+Mes+Dia > '20160100' AND (Natureza = '20302' OR Natureza =  '20301')

UPDATE ##TempNat
SET  Temperado = Valor * 0.2, Laminado = Valor * 0.8
WHERE Ano+Mes+Dia > '20160100' AND 
(
   Natureza =  '20907'
OR Natureza =  '20908'
OR Natureza =  '20909'
OR Natureza =  '20913'
OR Natureza =  '20906'
OR Natureza =  '20912'
OR Natureza =  '20603'
OR Natureza =  '20606'
OR Natureza =  '20605'
)

UPDATE ##TempNat
SET  Temperado = Valor * 0.3, Laminado = Valor * 0.7
WHERE Ano+Mes+Dia > '20160100' AND 
(
   Natureza =  '21202'
OR Natureza =  '20901'
OR Natureza =  '20425'
OR Natureza =  '20806'
OR Natureza =  '20807'
OR Natureza =  '99999'
OR Natureza =  '20701'
)

UPDATE ##TempNat
SET  Temperado = Valor * 0.15, Laminado = Valor * 0.85
WHERE Ano+Mes+Dia > '20160100' AND ( Natureza =  '20207')

UPDATE ##TempNat
SET  Temperado = Valor * 0, Laminado = Valor * 1
WHERE Ano+Mes+Dia > '20160100' AND ( Natureza =  '20205' OR Natureza =  '20206')

-- cofins, pis, csll
UPDATE ##TempNat
SET  Temperado = Valor * 0.2065848, Laminado = Valor * 0.7934152
WHERE Ano+Mes+Dia > '20160100' AND ( Natureza =  '20504' OR Natureza =  '20505' OR Natureza =  '20515')

-- ipi
UPDATE ##TempNat
SET  Temperado = Valor * 0.2467724, Laminado = Valor * 0.7532276
WHERE Ano+Mes+Dia > '20160100' AND ( Natureza =  '20501')

-- icms
UPDATE ##TempNat
SET  Temperado = Valor * 0.285267, Laminado = Valor * 0.714733
WHERE Ano+Mes+Dia > '20160100' AND ( Natureza =  '20502')

-- subst tribuitária
UPDATE ##TempNat
SET  Temperado = Valor * 0.09214545, Laminado = Valor * 0.90785455
WHERE Ano+Mes+Dia > '20160100' AND ( Natureza =  '20506')

/*
select
 sum( case B1_TIPOPRD when 'T' then D2_VALICM else 0 end) VlrTempIcm,
 sum( case B1_TIPOPRD when 'T' then 0 else D2_VALICM end) VlrLamIcm,

 sum( case B1_TIPOPRD when 'T' then D2_VALIPI else 0 end) VlrTempIpi,
 sum( case B1_TIPOPRD when 'T' then 0 else D2_VALIPI end) VlrLamIpi,

 sum( case B1_TIPOPRD when 'T' then D2_VALIMP5 else 0 end) VlrTempPIS,
 sum( case B1_TIPOPRD when 'T' then 0 else D2_VALIMP5 end) VlrLamPIS,
 
 sum( case B1_TIPOPRD when 'T' then D2_VALIMP6 else 0 end) VlrTempCOF,
 sum( case B1_TIPOPRD when 'T' then 0 else D2_VALIMP6 end) VlrLamCOF,

 sum( case B1_TIPOPRD when 'T' then D2_ICMSRET else 0 end) VlrTempSUB,
 sum( case B1_TIPOPRD when 'T' then 0 else D2_ICMSRET end) VlrLamSUB,

 SUBSTRING(D2_EMISSAO,1,6) Periodo
 from SD2010 SD2 with( nolock ) 
 left outer join SB1010 SB1 with( nolock ) on SB1.D_E_L_E_T_ <> '*' AND D2_COD = B1_COD 
 where SD2.D_E_L_E_T_ <> '*' AND D2_EMISSAO > '20160100' 
group by SUBSTRING(D2_EMISSAO,1,6)

select * from	SD2010 WHERE D2_EMISSAO > '20160100'
*/

/*UPDATE ##TempNat
SET Rec_Pag = 'D'
WHERE Natureza = '10104' OR Natureza = '10103'
*/
UPDATE ##TempNat
SET 
Rec_Pag = 'F',
Laminado = Laminado * -1
WHERE (Natureza = '10198') Or (Natureza = '10199')

UPDATE ##TempNat
set Natureza = '21401',
Descrição = 'CAIXA PEQUENO',
Grupo = '5. Outras Despesas Operacionais'
from (
select A2_NATUREZ, ##TempNat.* from ##TempNat
left outer join SA2010 ON A2_COD = Código
 where Descrição = 'Sem Classificacao' and Rec_Pag = 'P' AND Filial <> 'JIMAQ' AND Ano = 2015
) caixapeq
where caixapeq.idRec = ##TempNat.idRec

update ##TempNat 
set Grupo = '5. Financeiro'
 where Descrição = 'JUROS ATIVOS' and Valor < 0 and Rec_Pag = 'P'

update  ##TempNat 
  set Rec_Pag = 'P',
Grupo = '5. Outras Despesas Operacionais'
  where (Laminado + Temperado) in (-70.15,-73.66) and Rec_Pag = 'D' 

update ##TempNat
set [Consolidado Analitico] = [Despesa Conciliado], [Consolidado Sintetico] = [Grupo Conciliado]
from Consolidado Consol
where Consol.[Código] = [Natureza]


exec  msdb.dbo.sp_start_job 'Reprocessamento Fluxo de Caixa' 

If Object_Id (N'TESTE.dbo.TempNat', N'U') is not null truncate table TESTE.dbo.TempNat;
insert into TESTE.dbo.TempNat select * from ##TempNat where convert( char(8),[Data Compensação],112) = @cDtFim 

--SELECT @cExec = 'select * into TESTE.dbo.TempNat' + @cDtFim + 'from ##TempNat where convert( char(8),[Data Compensação],112) = @cDtFim'
--exec @cExec

end
/*
SELECT DISTINCT Filial FROM ##TempNat WHERE 
(Descrição = '13 SALARIO' OR
Descrição = 'ACORDOS TRABALHISTAS/CUSTAS' OR
Descrição = 'CONTRIBUICAO SINDICAL (FUNCIONARIOS)' OR
Descrição = 'DARF CONTRIBUICOES (CODIGO 2991)' OR
Descrição = 'FARMACIA' OR
Descrição = 'FÉRIAS E ABONO DE FÉRIAS' OR
Descrição = 'FGTS (RESCISOES)' OR
Descrição = 'FGTS A RECOLHER' OR
Descrição = 'INSS REF. PROCESSO TRABALHISTA' OR
Descrição = 'MENSALIDE SINDICAL - FUNCIONARIOS' OR
Descrição = 'PENSAO ALIMENTICIA  (13 SALARIO)' OR
Descrição = 'PENSAO ALIMENTICIA  (SALARIO)' OR
Descrição = 'RESCISOES' OR
Descrição = 'SALARIOS A PAGAR')


SELECT RA_FILIAL, Periodo ,SUM(RA_PTEMP) Temperado, SUM(RA_PLAM) Laminado 
FROM RH_ESOCIAL.dbo.SRA010,
(
SELECT DISTINCT Ano+Mes Periodo FROM ##TempNat WHERE 
(Descrição = '13 SALARIO' OR
Descrição = 'ACORDOS TRABALHISTAS/CUSTAS' OR
Descrição = 'CONTRIBUICAO SINDICAL (FUNCIONARIOS)' OR
Descrição = 'DARF CONTRIBUICOES (CODIGO 2991)' OR
Descrição = 'FARMACIA' OR
Descrição = 'FÉRIAS E ABONO DE FÉRIAS' OR
Descrição = 'FGTS (RESCISOES)' OR
Descrição = 'FGTS A RECOLHER' OR
Descrição = 'INSS REF. PROCESSO TRABALHISTA' OR
Descrição = 'MENSALIDE SINDICAL - FUNCIONARIOS' OR
Descrição = 'PENSAO ALIMENTICIA  (13 SALARIO)' OR
Descrição = 'PENSAO ALIMENTICIA  (SALARIO)' OR
Descrição = 'RESCISOES' OR
Descrição = 'SALARIOS A PAGAR')) PerFha

WHERE D_E_L_E_T_ = '' AND (SUBSTRING(RA_DEMISSA,1,6) <= Periodo collate Latin1_General_100_BIN OR RA_DEMISSA = '') AND 
SUBSTRING(RA_ADMISSA,1,6) <= Periodo collate Latin1_General_100_BIN
group by RA_FILIAL, Periodo
order by RA_FILIAL, Periodo



case E5_FILORIG
      when '0101' then 'THM'
      when '0102' then 'THF'
 	  when '0201' then 'TWM' 
	  when '0202' then 'TWF '
	  when '0301' then 'GTECH'
	  when '0401' then 'PRIMI'
	  when '0501' then 'REPEL'
	  when '0601' then 'JIMAQ'
	  when '0701' then 'FFM'   
 	  when '0215' then 'TWP'   
	  when '9001' then 'VR Provisões'   
	  else 'Sem Classif'
end Filial,



JIMAQ
PRIMI
REPEL
THF
THM
TWF 
TWM
TWP*/

/*

SELECT ED_CODIGO, ED_DESCRIC, 80, 20 FROM SED010 WHERE ED_CODIGO IN
('20907',
'20908',
'20909',
'20913',
'20906',
'20912',
'20603',
'20606',
'20605')

SELECT ED_CODIGO, ED_DESCRIC, 20, 80 FROM SED010 WHERE ED_CODIGO IN
(
'21202',
'20901',
'20425',
'20806',
'20807',
'99999',
'20701'
)

SELECT ED_CODIGO, ED_DESCRIC, 30, 70 FROM SED010 WHERE ED_CODIGO IN
(
'21202',
'20901',
'20425',
'20806',
'20807',
'99999',
'20701'
)

SELECT ED_CODIGO, ED_DESCRIC, 60, 40 FROM SED010 WHERE ED_CODIGO IN
('20207')

SELECT ED_CODIGO, ED_DESCRIC, 0, 1 FROM SED010 WHERE ED_CODIGO IN
('20205','20206')

SELECT ED_CODIGO, ED_DESCRIC, 20.65848, 79.34152 FROM SED010 WHERE ED_CODIGO IN
('20504','20505','20515')

SELECT ED_CODIGO, ED_DESCRIC, 24.67424, 75.32276 FROM SED010 WHERE ED_CODIGO IN ('20501')

-- icms
SELECT ED_CODIGO, ED_DESCRIC, 28.5267, 71.4733 FROM SED010 WHERE ED_CODIGO IN ('20502')

-- subst tribuitária
SELECT ED_CODIGO, ED_DESCRIC, 9.214545, 90.785455 FROM SED010 WHERE ED_CODIGO IN ('20506')


select * FROM SED010 WHERE ED_DESCRIC LIKE '%FRETE%'*/
--EXEC UpdFlxCxa '20161108'
--select * from ##TempNat where Rec_Pag = 'P' and [Data Emissão] is null
