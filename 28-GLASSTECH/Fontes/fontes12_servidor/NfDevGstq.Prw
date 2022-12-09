
Static cBDGSTQ	:= Iif(At("_TST", Upper(GetEnvServer())) > 0, "TESTE"			, "TPCP"		)
Static cBDPROT	:= GetMv("MV_TWINENV")
Static cBVGstq	:= Iif(At("_TST", Upper(GetEnvServer())) > 0, "BVTESTE"			, "BV"			)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ NfDevGstq º Autor ³ Sérgio Santana       º Data ³20/11/2012º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Importacao Base de Dados              º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºALTERACAO ³                                                            º±± 
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ThermoGlass                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

//-- Ponto de Entrada para incluir botão na Pré-Nota de Entrada
//U_CtaPgGstq( '  ', '20140900', 'B' )
//U_CtaMvGstq( '20140901', '201410231' )
//U_CtaAdGstq( '20140901', '20141031' )
//U_NFSDAGSTQ('20140901','20141031')
//U_NfCL8Gstq('20140901','20141031')
//U_CtaRcGstq( '  ', '20140901', '20141031' , 'B' )
//U_CtaRcGstq( 'BV', '20140901', '20141031' , 'B' )
//U_NfDevGstq('20151101','20151123')

#INCLUDE "PROTHEUS.CH"
#include "RWMAKE.ch"
#include "Colors.ch"
#include "Font.ch"
#Include "HBUTTON.CH"
#include "Topconn.ch"

User Function NfDevGstq( _cDtIni, _cDtFim )

DEFAULT _cDtIni := DtoS( dDataBase - 1 )
DEFAULT _cDtFim := DtoS( dDataBase - 1 )

PRIVATE lPcNfe   := GETMV( "MV_PCNFE" )
PRIVATE _cFilSA1 := xFilial( 'SA1' )
PRIVATE _cFilSA2 := xFilial( 'SA2' )
PRIVATE _cFilSA5 := xFilial( 'SA5' )
PRIVATE _cFilSA7 := xFilial( 'SA7' )
PRIVATE _cFilSB1 := xFilial( 'SB1' )
PRIVATE _cFilSC7 := xFilial( 'SC7' )                     
PRIVATE _cFilSF1 := xFilial( 'SF1' )
PRIVATE _cFilSF2 := xFilial( 'SF2' )
PRIVATE _cFilSF4 := xFilial( 'SF4' )
PRIVATE _cFilSF6 := xFilial( 'SF6' )
PRIVATE _cFilCDC := xFilial( 'CDC' )

Static aTipo      := { 'N','B','D' }

SB1->( dbSetOrder( 1 ) )
SA1->( dbSetOrder( 1 ) )

cProt := ' '
cAut  := ' '

PutMV("MV_PCNFE",.F.)

_qSda := 'WITH Saidas '
_qSda += '('
_qSda += ' CNPJCLI,'
_qSda += ' cCgc,'
_qSda += ' F2_NOME,'
_qSda += ' F2_FILIAL,'
_qSda += ' F2_DOC,'
_qSda += ' F2_SERIE,'
_qSda += ' F2_CLIENTE,'
_qSda += ' F2_TES,'
_qSda += ' F2_DUPL,'
_qSda += ' F2_FINANC,'
_qSda += ' F2_VEND1,'
_qSda += ' F2_EMISSAO,'
_qSda += ' F2_ORC,'
_qSda += ' F2_ID,'
_qSda += ' F2_BASEICM,'
_qSda += ' F2_VALICM,'
_qSda += ' F2_VALIPI,'
_qSda += ' F2_BASIMP5,'
_qSda += ' F2_VALIMP5,'
_qSda += ' F2_BASIMP6,'
_qSda += ' F2_VALIMP6,'
_qSda += ' F2_VALPIS,'
_qSda += ' F2_VALCOFI,'
_qSda += ' F2_TIPIMP,'
_qSda += ' F2_BRICMS,'
_qSda += ' F2_ICMSRET,'
_qSda += ' F2_VALMERC,'
_qSda += ' F2_VALBRUT,'
_qSda += ' F2_DESCZFR'
_qSda += ')
_qSda += 'AS '
_qSda += '( '
_qSda += ' SELECT'
_qSda += "  REPLACE(REPLACE(REPLACE(CLI.CPFCGC,'.',''),'/',''),'-','') CNPJCLI,"
_qSda += "  REPLACE(REPLACE(REPLACE(EMP.CGC,'.',''),'/',''),'-','') cCgc,"
_qSda += '  CLI.NOME F2_NOME,'
_qSda += '  NOTA.ID_EMPRESA  AS F2_FILIAL,'
_qSda += '  NOTA.NRO_NF      AS F2_DOC,'
_qSda += '  NOTA.SERIE       AS F2_SERIE,'
_qSda += '  NOTA.ID_CLIENTE  AS F2_CLIENTE,'
_qSda += '  CFO.TES          AS F2_TES,'
_qSda += "  ISNULL( NOTA.ID_TITULO, CASE NOTA.GERA_RECEITA WHEN 'S' THEN 1 ELSE 0 END) AS F2_DUPL,"
_qSda += '  NOTA.GERA_RECEITA AS F2_FINANC,'
_qSda += '  NOTA.ID_VENDEDOR AS F2_VEND1,'
_qSda += '  CONVERT( CHAR(8),ISNULL(NOTA.DATA_CANCEL,NOTA.EMISSAO), 112) AS F2_EMISSAO,'
_qSda += '  NOTA.CLASSE     AS F2_ORC,'
_qSda += '  NOTA.ID_NOTA    AS F2_ID,'
_qSda += '  NOTA.BseIcms    AS F2_BASEICM,'
_qSda += '  NOTA.VlrIcms    AS F2_VALICM,'
_qSda += '  NOTA.VlrIpi     AS F2_VALIPI,'
_qSda += '  CASE NOTA.VlrCofins WHEN 0 THEN 0 ELSE NOTA.VLR_TOT_PROD END AS F2_BASIMP5,'
_qSda += '  NOTA.VlrCofins  AS F2_VALIMP5,'
_qSda += '  CASE NOTA.VlrCofins WHEN 0 THEN 0 ELSE NOTA.VLR_TOT_PROD END AS F2_BASIMP6,'
_qSda += '  NOTA.VlrPis         AS F2_VALIMP6,'
_qSda += '  NOTA.ValorRetPis    AS F2_VALPIS,'
_qSda += '  NOTA.ValorRetCofins AS F2_VALCOFI,'
_qSda += "  '1' AS F2_TIPIMP,"
_qSda += '  NOTA.BseSubTrib   AS F2_BRICMS, '
_qSda += '  NOTA.VlrSubTrib   AS F2_ICMSRET,'
_qSda += '  NOTA.VLR_TOT_PROD AS F2_VALMERC,'
_qSda += '  NOTA.VLR_TOT_NOTA AS F2_VALBRUT,'
_qSda += '  NOTA.ICM_LIVRE_COMERCIO AS F2_DESCZFR'
_qSda += ' FROM ['+cBDGSTQ+'].[dbo].[NOTA] NOTA'
_qSda += ' LEFT OUTER JOIN ['+cBDGSTQ+'].[dbo].[CFO] CFO ON CFO.ID_CFO = NOTA.ID_CFO'
_qSda += ' LEFT OUTER JOIN ['+cBDGSTQ+'].[dbo].[VENDEDOR] VDOR ON VDOR.ID_VENDEDOR = NOTA.ID_VENDEDOR'
_qSda += ' LEFT OUTER JOIN ['+cBDGSTQ+'].[dbo].[CLIENTE] CLI ON CLI.ID_CLIENTE = NOTA.ID_CLIENTE'
_qSda += ' LEFT OUTER JOIN ['+cBDGSTQ+'].[dbo].[EMPRESA] EMP ON EMP.ID_EMPRESA = NOTA.ID_EMPRESA'
_qSda += " WHERE ((NOTA.POS = 'G') AND (NOTA.E_S = 'E') and (CONVERT( char(8), EMISSAO, 112) BETWEEN '" + _cDtIni + "' AND '" + _cDtFim + "')) OR "
_qSda += " ((NOTA.POS = 'C') AND (NOTA.E_S = 'S') and (CONVERT( char(8), DATA_CANCEL, 112) BETWEEN '" + _cDtIni + "' AND '" + _cDtFim + "')) "
_qSda += ') '
_qSda += 'SELECT Saidas.* FROM Saidas '
_qSda += "LEFT OUTER JOIN ["+cBDGSTQ+"].[dbo].[EMPRESA] EMP ON REPLACE(REPLACE(REPLACE(EMP.CGC,'.',''),'/',''),'-','') = Saidas.CNPJCLI "
_qSda += "where (EMP.CGC Is Null) AND F2_DUPL <> 0"

dbUseArea( .T.,"TOPCONN",TcGenQry(,,_qSda),"CAB",.T.,.T.)

MV_PAR01 := 1

While ! ( CAB->( Eof() ) )
	
	_nFrete := 0
	_nDesp  := 0		

	cTipo := "D"
    cCod := StrZero( CAB->F2_CLIENTE, 6 )

    If ! SA1->( dbSeek( _cFilSA1 + cCod + '01', .F. ) )

       _qCli := "SELECT ID_CLIENTE, NOME, FANTASIA, ENDERECO, COMPL_END, REPLACE(REPLACE(CEP,'.',''),'-','') CEP, BAIRRO, ATIV.SUBST_TRIB SUBTRIB, "
       _qCli += "RGINSC, INTERNET eMail, REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(TELEFONE,'.',''),' ',''),')',''),'(',''),'/',''),'-','') TELEFONE, CONTATO, CONVERT(CHAR(8),CADASTRO,112) CADASTRO, CONVERT( CHAR(8), ULT_COMPRA,112) ULT_COMPRA, CLIENTE.SUFRAMA,"
       _qCli += "REPLACE(REPLACE(REPLACE(CPFCGC,'.',''),'/',''),'-','') CPFCGC, CIDADE.DESCRICAO, UF, COD_UF, MUNICIPIO , PAIS, REPLACE(ISNULL(PLANO.CODIGO,'112010001'),'.','') CONTA"
       _qCli += ' FROM ['+cBDGSTQ+'].[dbo].[CLIENTE] '
       _qCli += 'LEFT OUTER JOIN ['+cBDGSTQ+'].[dbo].[CIDADE] ON CIDADE.ID_CIDADE = CLIENTE.ID_CIDADE '
       _qCli += 'LEFT OUTER JOIN ['+cBDGSTQ+'].[dbo].[OPERACIONAL] OP ON OP.ID_OPERACIONAL = CLIENTE.ID_OPERACIONAL '
       _qCli += 'LEFT OUTER JOIN ['+cBDGSTQ+'].[dbo].[ATIVIDADE] ATIV ON ATIV.ID_ATIVIDADE = CLIENTE.ID_ATIVIDADE '
       _qCli += 'LEFT OUTER JOIN ['+cBDGSTQ+'].[dbo].[PLANO] ON PLANO.ID_PLANO = OP.ID_PLANO_CR '
       _qCli += "WHERE (CLIENTE.ID_CLIENTE = " + LTRIM(STR(CAB->F2_CLIENTE,6)) + ")"

       dbUseArea( .T.,"TOPCONN",TcGenQry(,,_qCli),"CLI",.T.,.T.)

       RecLock( 'SA1', .T. )

       SA1->A1_LOJA    := '01'
       SA1->A1_COD     := StrZero( CLI->ID_CLIENTE, 6 )
       SA1->A1_NOME    := CLI->NOME
       SA1->A1_NREDUZ  := CLI->FANTASIA
       SA1->A1_INSCR   := UPPER(CLI->RGINSC)
       SA1->A1_CGC     := CLI->CPFCGC
       SA1->A1_CEP     := CLI->CEP
       SA1->A1_MUN     := CLI->DESCRICAO
       SA1->A1_COD_MUN := CLI->MUNICIPIO
       SA1->A1_PAIS    := SUBSTR( CLI->PAIS,1,3 )
       SA1->A1_CODPAIS := '0' + SUBSTR( CLI->PAIS,1, 4 )	
       SA1->A1_TEL     := CLI->TELEFONE
       SA1->A1_END     := CLI->ENDERECO
       SA1->A1_EST     := CLI->UF
       SA1->A1_BAIRRO  := CLI->BAIRRO
       SA1->A1_PESSOA  := if( Len(RTRIM(CLI->CPFCGC)) <> 14, 'F', 'J' )
       SA1->A1_TIPO    := iif( CLI->SUBTRIB <> 'S', 'R', 'S' )
       SA1->A1_PRICOM  := STOD( CLI->CADASTRO ) 
       SA1->A1_ULTCOM  := STOD( CAB->F2_EMISSAO )
       SA1->A1_CONTA   := CLI->CONTA
       
       SA1->( dbUnLock() )
       
       CLI->( dbCloseArea() )

    End

    If  CAB->cCgc = '48254858000109' 
        _cFilSF2 := '0101'
    ElseIf CAB->cCgc = '48254858000290'
         _cFilSF2 := '0102' 
    ElseIf CAB->cCgc = '48254858000451'
         _cFilSF2 := '0103' 
    ElseIf CAB->cCgc = '03061254000108'
         _cFilSF2 := '0201'
    ElseIf CAB->cCgc = '03061254000299'
         _cFilSF2 := '0202'
    ElseIf CAB->cCgc = '67313247000139'
         _cFilSF2 := '0301' 
    ElseIf CAB->cCgc = '04051564000104'
         _cFilSF2 := '0401'
    ElseIf CAB->cCgc = '09158959000124'
         _cFilSF2 := '0501'
    ElseIf CAB->cCgc = '04657999000105'
         _cFilSF2 := '0601'
    ElseIf CAB->cCgc = '25074100000193'
         _cFilSF2 :='0801'
    ElseIf CAB->cCgc = '03061254000370'
         _cFilSF2 :='0215'

    ElseIf CAB->cCgc = '11175943000171' // FFM
    
        If ! ( alltrim(CAB->F2_SERIE) $ '2;4' )

           _cFilSF2 := '0701'

        Else

		   CAB->( dbSkip() )
		   Loop

        End
         
    Else

          _cFilSF2 := '9001'

    End
    
    _cFilSD2 := _cFilSF2
    
	// -- Nota Fiscal já existe na base ?

	If SF1->( dbSeek( _cFilSF2 + StrZero( CAB->F2_DOC, 9 ) + Padr(CAB->F2_SERIE,3)+ SA1->A1_COD + SA1->A1_LOJA ) )

       /*If MV_PAR01 = 1

          MsgInfo('Nota Fiscal no. '+;
                  StrZero( CAB->F2_DOC, 9 )+;
                  '/'               +;
                  Padr(CAB->F2_SERIE,3)+;
                  Chr( 13 )         +;
                  'Fornecedor '      +;
                  SA1->A1_COD + '/'      +;
                  SA1->A1_LOJA + ' - '   +;
                  rTrim( SA1->A1_NREDUZ )+;
                  Chr( 13 ) +;
                  'Encontra-se lançada no sistema. Importação interrompida';
                 )

       Else

		  MsgInfo('Nota Fiscal no. ' + ;
			      StrZero( CAB->F2_DOC, 9 ) +;
			      '/' +;
			      Padr(CAB->F2_SERIE,3) +;
			      Chr( 13 )+;
			      'Cliente '+;
			      SA2->A2_COD+"/"+;
			      SA2->A2_LOJA+' - '+;
			      rTrim( SA2->A2_NREDUZ ) +;
			      Chr( 13 )+;
			      'Encontra-se lançada no sistema. Importação interrompida';
			     )

       End*/

       PutMV( "MV_PCNFE", lPcNfe )
       CAB->( dbSkip() )
       Loop
       Return( NIL )

	End

    _cEst := if( MV_PAR01=2, SA1->A1_EST, SA1->A1_EST )
	cData := CAB->F2_EMISSAO
	dData := Stod( cData )

    IncNFCE( _cFilSF2, 'SPED' )    
 
    SF4->( dbSeek( _cFilSF4 + CAB->F2_TES, .F. ) )

    _cItem := '0000'

    _qIte := 'SELECT CATALOGO D2_COD, DESCRICAO D2_DESCR, CLASSIFICACAO D2_POSIPI, (ORIGEM + CST_ICMS) D2_CLASFIS,'
    _qIte += 'UN D2_UM, QTD D2_QUANT, vlr_unt D2_PRCVEN, ICM D2_PICM, IPI D2_IPI, BSE_ICMS D2_BASEICM, VLR_ICMS D2_VALICM, VLR_IPI D2_VALIPI,'
    _qIte += 'ALIQ_COFINS D2_ALQIMP5, VLR_COFINS D2_VALIMP5, ALIQ_PIS D2_ALQIMP6, VLR_PIS D2_VALIMP6, FCI D2_FCICOD,'
    _qIte += 'Desconto D2_DESCZFM, AliqRetCofins D2_ALQCOF, ValorRetCofins D2_VALCOF, AliqRetPis D2_ALQPIS, ValorRetPis D2_VALPIS, '
    _qIte += 'CST_IPI D2_CSTIPI, CST_PIS D2_CSTPIS, CST_COFINS D2_CSTCOF, BseSubTrib D2_BRICMS, VlrSubTrib D2_ICMSRET, AliqSubTrib D2_ALIQSOL,'
    _qIte += 'AliqIVA D2_MARGEM, MotDesIcms D2_MOTDES, Desconto D2_DESCZFR '
    _qIte += 'FROM ['+cBDGSTQ+'].[dbo].[ITEM_NOTA] WHERE (ID_NOTA = ' + LTRIM(STR(CAB->F2_ID, 8)) + ')' // = 361477

    dbUseArea( .T.,"TOPCONN",TcGenQry(,,_qIte),"ITE",.T.,.T.)


    IncNFDS( _cFilSF2 )
    
    If (CAB->F2_ORC = 2 .Or.;
       CAB->F2_ORC = 8)

       IncNFCE( '9001', 'ORC' )
       ITE->( dbGoTop() )
       IncNFDS( '9001' )

    End
    
    ITE->( dbCloseArea() )
    CAB->( dbSkip() )
	
End

PutMV("MV_PCNFE",lPcNfe)
CAB->( dbCloseArea() )

Return( NIL )

Static Function IncNFCE( _cFilial, _cTipo )

    RecLock( 'SF1', .T. )

    SF1->F1_FILIAL  := _cFilial
    SF1->F1_DOC     := StrZero( CAB->F2_DOC, 9 )
    SF1->F1_SERIE   := Padr( CAB->F2_SERIE, 3 )
    SF1->F1_PREFIXO := Padr( CAB->F2_SERIE, 3 )
    SF1->F1_FORNECE := SA1->A1_COD
    SF1->F1_LOJA    := SA1->A1_LOJA
    SF1->F1_COND    := ''
    SF1->F1_FORMUL  := 'S'
    SF1->F1_EMISSAO := dData
    SF1->F1_DTDIGIT := dData
    SF1->F1_RECBMTO := dData
    SF1->F1_EST     := SA1->A1_EST
    SF1->F1_ESTPRES := SA1->A1_EST
    SF1->F1_IDSED   := 'N'
//    SF1->F1_TIPOCLI := SA1->A1_TIPO
    SF1->F1_VALBRUT := CAB->F2_VALMERC
    SF1->F1_VALMERC := CAB->F2_VALMERC
//    SF1->F1_VALFAT  := CAB->F2_VALMERC

    If (_cFilial <> '9001') .And.;
       (CAB->F2_ORC < 3)

       SF1->F1_VALBRUT := CAB->F2_VALBRUT    
       SF1->F1_ICMS    := CAB->F2_DESCZFR
       SF1->F1_ICMSRET := CAB->F2_ICMSRET
       SF1->F1_BRICMS  := CAB->F2_BRICMS
       SF1->F1_VALIMP5 := CAB->F2_VALIMP5
       SF1->F1_BASIMP5 := iif( SF1->F1_VALIMP5 <> 0, SF1->F1_VALMERC, 0)
       SF1->F1_VALIMP6 := CAB->F2_VALIMP6
       SF1->F1_BASIMP6 := iif( SF1->F1_VALIMP6 <> 0, SF1->F1_VALMERC, 0)
       SF1->F1_VALCOFI := CAB->F2_VALCOFI
       SF1->F1_BASCOFI := iif( SF1->F1_VALCOFI <> 0, SF1->F1_VALMERC, 0)
       SF1->F1_VALPIS  := CAB->F2_VALPIS
       SF1->F1_BASPIS  := iif( SF1->F1_VALPIS <> 0, SF1->F1_VALMERC, 0)
       SF1->F1_VALICM  := CAB->F2_VALICM
       SF1->F1_BASEICM := CAB->F2_BASEICM
       SF1->F1_VALIPI  := CAB->F2_VALIPI
       SF1->F1_BASEIPI := iif( SF1->F1_VALIPI <> 0, CAB->F2_VALMERC, 0)

    End

    SF1->F1_ESPECIE := _cTipo
    SF1->F1_CHVNFE  := cProt
    SF1->F1_CODNFE  := cAut
    SF1->F1_DAUTNFE := dData 
    SF1->F1_TIPO    := 'D'
    SF1->F1_RECISS  := '2'
//    SF1->F1_RECFAUT := '1'
    SF1->F1_MOEDA   := 1
    SF1->F1_FIMP    := 'S'

    SF1->( dbUnLock() )

    RecLock( 'SF3', .T. )
	SF3->F3_FILIAL  := _cFilial
	SF3->F3_NFISCAL := SF1->F1_DOC		
	SF3->F3_SERIE   := SF1->F1_SERIE
	SF3->F3_EMISSAO := SF1->F1_EMISSAO
	SF3->F3_ENTRADA := SF1->F1_EMISSAO
	SF3->F3_CLIEFOR := SF1->F1_FORNECE
	SF3->F3_LOJA    := SF1->F1_LOJA
	SF3->F3_ESPECIE := SF1->F1_ESPECIE
	SF3->F3_TIPO    := SF1->F1_TIPO
	SF3->F3_ESTADO  := SF1->F1_EST
    SF3->F3_VALCONT := CAB->F2_VALBRUT
    SF3->F3_BASERET := CAB->F2_BRICMS
    SF3->F3_ICMSRET := CAB->F2_ICMSRET
    SF3->F3_ICMSCOM := CAB->F2_ICMSRET
    SF3->F3_DESCZFR := CAB->F2_DESCZFR
    SF3->F3_BASEICM := CAB->F2_BASEICM
    SF3->F3_VALICM  := CAB->F2_VALICM
    SF3->F3_BASEIPI := iif( SF1->F1_VALIPI <> 0, SF1->F1_VALMERC, 0 )
    SF3->F3_VALIPI  := CAB->F2_VALIPI
    SF3->F3_RECISS  := '2'
    SF3->F3_IDENTFT := '000001'
    SF3->F3_CHVNFE  := cProt
    SF3->F3_CODNFE  := cAut
    SF3->F3_CODRSEF := '100'
    
Return( NIL )    

Static Function IncNFDS( _cFilial )

_pICMS := 0

While ! ( ITE->( Eof() ) )

   cProduto := PadR( ITE->D2_COD, 30 )
   _pICMS   := ITE->D2_PICM

   If ! ( SB1->( dbSeek( _cFilSB1 + ITE->D2_COD, .F. ) )  )

      RecLock( 'SB1', .T. )
   
      SB1->B1_COD  := ITE->D2_COD
      SB1->B1_DESC := ITE->D2_DESCR
      SB1->B1_TIPO := 'PA'
      SB1->B1_UM   := ITE->D2_UM
      SB1->B1_LOCPAD := '01'
      SB1->B1_POSIPI := ITE->D2_POSIPI
      SB1->B1_ORIGEM := Substr( ITE->D2_CLASFIS, 1, 1 )
      SB1->B1_GARANT := '2'
      SB1->( dbUnLock() )

   End

   RecLock( 'SD1', .T. )
   SD1->D1_FILIAL  := _cFilial
   SD1->D1_DOC     := SF1->F1_DOC		
   SD1->D1_SERIE   := SF1->F1_SERIE
   SD1->D1_EMISSAO := SF1->F1_EMISSAO
   SD1->D1_DTDIGIT := SF1->F1_EMISSAO
   SD1->D1_FORNECE := SF1->F1_FORNECE
   SD1->D1_LOJA    := SF1->F1_LOJA
//   SD1->D1_ESPECIE := SF1->F1_ESPECIE
   SD1->D1_NUMSEQ  := ProxNum()
   SD1->D1_TES     := SF4->F4_CODIGO
   SD1->D1_CF      := SF4->F4_CF
   SD1->D1_TIPO    := 'D'
   SD1->D1_TP      := 'PA'
   SD1->D1_LOCAL   := '01'
//   SD1->D1_EST     :=  SF1->F1_EST
   _cItem := Soma1( _cItem )
   SD1->D1_ITEM    := _cItem
   SD1->D1_COD     := ITE->D2_COD
   SD1->D1_DESCR   := ITE->D2_DESCR
   SD1->D1_UM      := ITE->D2_UM
   SD1->D1_QUANT   := ITE->D2_QUANT
   SD1->D1_VUNIT   := ITE->D2_PRCVEN
   SD1->D1_TOTAL   := Round( ITE->D2_QUANT * ITE->D2_PRCVEN, 2)
   SD1->D1_CUSTO   := SD1->D1_TOTAL - ITE->D2_VALICM - ITE->D2_VALIMP5 - ITE->D2_VALIMP6 - ITE->D2_DESCZFM

   If _cFilial <> '9001' .And.;
       (CAB->F2_ORC < 3)

      SD1->D1_ICMSRET := ITE->D2_ICMSRET
      SD1->D1_BRICMS  := ITE->D2_BRICMS
      SD1->D1_MARGEM  := ITE->D2_MARGEM
      SD1->D1_ALIQSOL := ITE->D2_ALIQSOL
      SD1->D1_DESCICM := ITE->D2_DESCZFR
      SD1->D1_FCICOD  := ITE->D2_FCICOD
      SD1->D1_CSTCOF  := ITE->D2_CSTCOF
      SD1->D1_ALQIMP5 := ITE->D2_ALQIMP5
      SD1->D1_BASIMP5 := If( ITE->D2_VALIMP5 <> 0, SD1->D1_TOTAL, 0 )
      SD1->D1_VALIMP5 := ITE->D2_VALIMP5
      SD1->D1_CSTPIS  := ITE->D2_CSTPIS
      SD1->D1_ALQIMP6 := ITE->D2_ALQIMP6
      SD1->D1_BASIMP6 := If( ITE->D2_VALIMP6 <> 0, SD1->D1_TOTAL, 0 )
      SD1->D1_VALIMP6 := ITE->D2_VALIMP6

      If (ITE->D2_VALCOF <> 0)
         SD1->D1_BASECOF := SD1->D1_TOTAL
         SD1->D1_VALCOF  := ITE->D2_VALCOF
         SD1->D1_ALQCOF  := ITE->D2_ALQCOF
      End

      If (ITE->D2_VALPIS <> 0)
         SD1->D1_BASEPIS := SD1->D1_TOTAL
         SD1->D1_VALPIS  := ITE->D2_VALPIS
         SD1->D1_ALQPIS  := ITE->D2_ALQPIS
      End

      SD1->D1_PICM    := ITE->D2_PICM
      SD1->D1_BASEICM := ITE->D2_BASEICM
      SD1->D1_VALICM  := ITE->D2_VALICM
      SD1->D1_BASEIPI := If( ITE->D2_VALIPI <> 0, SD1->D1_TOTAL, 0 )
      SD1->D1_IPI     := ITE->D2_IPI
      SD1->D1_VALIPI  := ITE->D2_VALIPI

   End

//   SD1->D1_VALBRUT := SD1->D1_TOTAL + iif( _cFilial <> '9001', SD1->D1_VALIPI + SD1->D1_ICMSRET, 0 )
   SD1->D1_CLASFIS := ITE->D2_CLASFIS
//   SD1->D1_SITRIB  := ITE->D2_CLASFIS
   SD1->D1_CSTIPI  := ITE->D2_CSTIPI 
   SD1->D1_RATEIO  := '2'
   SD1->D1_STSERV  := '1'
   SD1->D1_CONBAR  := '0'
        
   SD1->( dbUnLock() )

   If (SD1->D1_ICMSRET <> 0) .And.;
      (_cFilial <> '9001')

      RecLock( 'CD2', .T. )
      CD2->CD2_FILIAL   := _cFilial
      CD2->CD2_TPMOV   := 'E'
      CD2->CD2_ITEM     := SD1->D1_ITEM
      CD2->CD2_CODPRO   := SD1->D1_COD
      CD2->CD2_DOC      := SF1->F1_DOC
      CD2->CD2_SERIE    := SF1->F1_SERIE
      CD2->CD2_CODCLI   := SF1->F1_FORNECE
      CD2->CD2_LOJCLI   := SF1->F1_LOJA
      CD2->CD2_IMP      := 'SOL'
      CD2->CD2_ORIGEM   := Substr( SD1->D1_CLASFIS, 1, 1)
      CD2->CD2_CST      := Substr( SD1->D1_CLASFIS, 2, 2)
      CD2->CD2_MVA      := SD1->D1_MARGEM
      CD2->CD2_BC       := SD1->D1_BRICMS
      CD2->CD2_ALIQ     := SD1->D1_ALIQSOL
      CD2->CD2_VLTRIB   := SD1->D1_ICMSRET
      CD2->CD2_QTRIB    := SD1->D1_QUANT
      CD2->CD2_DESCZF   := SD1->D1_DESCICM
      CD2->( dbUnLock() )

    End

    If (SD1->D1_DESCICM <> 0) .And.;
       (_cFilial <> '9001') 

       RecLock( 'CD2', .T. )
       CD2->CD2_FILIAL   := _cFilial
       CD2->CD2_TPMOV    := 'E'
       CD2->CD2_ITEM     := SD1->D1_ITEM
       CD2->CD2_CODPRO   := SD1->D1_COD
       CD2->CD2_DOC      := SF1->F1_DOC
       CD2->CD2_SERIE    := SF1->F1_SERIE
       CD2->CD2_CODCLI   := SF1->F1_FORNECE
       CD2->CD2_LOJCLI   := SF1->F1_LOJA
       CD2->CD2_IMP      := 'ZFM'
       CD2->CD2_ORIGEM   := Substr( SD1->D1_CLASFIS, 1, 1)
       CD2->CD2_CST      := Substr( SD1->D1_CLASFIS, 2, 2)
       CD2->CD2_MVA      := 0
       CD2->CD2_BC       := 0
       CD2->CD2_ALIQ     := 0
       CD2->CD2_VLTRIB   := 0
       CD2->CD2_QTRIB    := SD1->D1_QUANT
       CD2->CD2_DESCZF   := SD1->D1_DESCICM
       CD2->( dbUnLock() )

     End
    
     If (SD1->D1_VALICM <> 0) .And.;
        (_cFilial <> '9001') 

        RecLock( 'CD2', .T. )
        CD2->CD2_FILIAL   := _cFilial
        CD2->CD2_TPMOV    := 'E'
        CD2->CD2_ITEM     := SD1->D1_ITEM
        CD2->CD2_CODPRO   := SD1->D1_COD
        CD2->CD2_DOC      := SF1->F1_DOC
        CD2->CD2_SERIE    := SF1->F1_SERIE
        CD2->CD2_CODCLI   := SF1->F1_FORNECE
        CD2->CD2_LOJCLI   := SF1->F1_LOJA
        CD2->CD2_IMP      := 'ICM'
        CD2->CD2_ORIGEM   := Substr( SD1->D1_CLASFIS, 1, 1)
        CD2->CD2_CST      := Substr( SD1->D1_CLASFIS, 2, 2)
        CD2->CD2_BC       := SD1->D1_BASEICM
        CD2->CD2_ALIQ     := SD1->D1_PICM
        CD2->CD2_VLTRIB   := SD1->D1_VALICM
        CD2->CD2_QTRIB    := SD1->D1_QUANT
        CD2->( dbUnLock() )

     End

     If (SD1->D1_VALIPI <> 0) .And.;
        (_cFilial <> '9001') 

        RecLock( 'CD2', .T. )
        CD2->CD2_FILIAL   := _cFilial
        CD2->CD2_TPMOV    := 'E'
        CD2->CD2_ITEM     := SD1->D1_ITEM
        CD2->CD2_CODPRO   := SD1->D1_COD
        CD2->CD2_DOC      := SF1->F1_DOC
        CD2->CD2_SERIE    := SF1->F1_SERIE
        CD2->CD2_CODCLI   := SF1->F1_FORNECE
        CD2->CD2_LOJCLI   := SF1->F1_LOJA
        CD2->CD2_IMP      := 'IPI'
        CD2->CD2_ORIGEM   := Substr( SD1->D1_CLASFIS, 1, 1)
        CD2->CD2_CST      := SD1->D1_CSTIPI
        CD2->CD2_BC       := SD1->D1_BASEIPI
        CD2->CD2_ALIQ     := SD1->D1_IPI
        CD2->CD2_VLTRIB   := SD1->D1_VALIPI
        CD2->CD2_QTRIB    := SD1->D1_QUANT
        CD2->( dbUnLock() )

     End

     If (SD1->D1_VALIMP5 <> 0) .And.;
        (_cFilial <> '9001') 

        RecLock( 'CD2', .T. )
        CD2->CD2_FILIAL   := _cFilial
        CD2->CD2_TPMOV    := 'E'
        CD2->CD2_ITEM     := SD1->D1_ITEM
        CD2->CD2_CODPRO   := SD1->D1_COD
        CD2->CD2_DOC      := SF1->F1_DOC
        CD2->CD2_SERIE    := SF1->F1_SERIE
        CD2->CD2_CODCLI   := SF1->F1_FORNECE
        CD2->CD2_LOJCLI   := SF1->F1_LOJA
        CD2->CD2_IMP      := 'CF2'
        CD2->CD2_ORIGEM   := Substr( SD1->D1_CLASFIS, 1, 1)
        CD2->CD2_CST      := SD1->D1_CSTCOF
        CD2->CD2_BC       := SD1->D1_BASIMP5
        CD2->CD2_ALIQ     := SD1->D1_ALQIMP5
        CD2->CD2_VLTRIB   := SD1->D1_VALIMP5
        CD2->CD2_QTRIB    := SD1->D1_QUANT
        CD2->( dbUnLock() )

     End

     If (SD1->D1_VALIMP6 <> 0) .And.;
        (_cFilial <> '9001') 

        RecLock( 'CD2', .T. )
        CD2->CD2_FILIAL   := _cFilial
        CD2->CD2_TPMOV    := 'E'
        CD2->CD2_ITEM     := SD1->D1_ITEM
        CD2->CD2_CODPRO   := SD1->D1_COD
        CD2->CD2_DOC      := SF1->F1_DOC
        CD2->CD2_SERIE    := SF1->F1_SERIE
        CD2->CD2_CODCLI   := SF1->F1_FORNECE
        CD2->CD2_LOJCLI   := SF1->F1_LOJA
        CD2->CD2_IMP      := 'PS2'
        CD2->CD2_ORIGEM   := Substr( SD1->D1_CLASFIS, 1, 1)
        CD2->CD2_CST      := SD1->D1_CSTPIS
        CD2->CD2_BC       := SD1->D1_BASIMP6
        CD2->CD2_ALIQ     := SD1->D1_ALQIMP6
        CD2->CD2_VLTRIB   := SD1->D1_VALIMP6
        CD2->CD2_QTRIB    := SD1->D1_QUANT
        CD2->( dbUnLock() )

     End

     If (SD1->D1_VALPIS <> 0) .And.;
        (_cFilial <> '9001') 

        RecLock( 'CD2', .T. )
        CD2->CD2_FILIAL   := _cFilial
        CD2->CD2_TPMOV    := 'E'
        CD2->CD2_ITEM     := SD1->D1_ITEM
        CD2->CD2_CODPRO   := SD1->D1_COD
        CD2->CD2_DOC      := SF1->F1_DOC
        CD2->CD2_SERIE    := SF1->F1_SERIE
        CD2->CD2_CODCLI   := SF1->F1_FORNECE
        CD2->CD2_LOJCLI   := SF1->F1_LOJA
        CD2->CD2_IMP      := 'PIS'
        CD2->CD2_ORIGEM   := Substr( SD1->D1_CLASFIS, 1, 1)
        CD2->CD2_CST      := SD1->D1_CSTPIS
        CD2->CD2_BC       := SD1->D1_BASEPIS
        CD2->CD2_ALIQ     := SD1->D1_ALQPIS
        CD2->CD2_VLTRIB   := SD1->D1_VALPIS
        CD2->CD2_QTRIB    := SD1->D1_QUANT
        CD2->( dbUnLock() )

     End

     If (SD1->D1_VALCOF <> 0) .And.;
        (_cFilial <> '9001') 

        RecLock( 'CD2', .T. )
        CD2->CD2_FILIAL   := _cFilial
        CD2->CD2_TPMOV    := 'E'
        CD2->CD2_ITEM     := SD1->D1_ITEM
        CD2->CD2_CODPRO   := SD1->D1_COD
        CD2->CD2_DOC      := SF1->F1_DOC
        CD2->CD2_SERIE    := SF1->F1_SERIE
        CD2->CD2_CODCLI   := SF1->F1_FORNECE
        CD2->CD2_LOJCLI   := SF1->F1_LOJA
        CD2->CD2_IMP      := 'COF'
        CD2->CD2_ORIGEM   := Substr( SD1->D1_CLASFIS, 1, 1)
        CD2->CD2_CST      := SD1->D1_CSTCOF
        CD2->CD2_BC       := SD1->D1_BASECOF
        CD2->CD2_ALIQ     := SD1->D1_ALQCOF
        CD2->CD2_VLTRIB   := SD1->D1_VALCOF
        CD2->CD2_QTRIB    := SD1->D1_QUANT
        CD2->( dbUnLock() )

     End

     If (_cFilial <> '9001') 

	    RecLock( 'SFT', .T. )

	    SFT->FT_FILIAL  := _cFilial
        SFT->FT_NFISCAL := SF1->F1_DOC		
 	    SFT->FT_SERIE   := SF1->F1_SERIE
	    SFT->FT_EMISSAO := SF1->F1_EMISSAO
	    SFT->FT_ENTRADA := SF1->F1_EMISSAO
	    SFT->FT_CLIEFOR := SF1->F1_FORNECE
	    SFT->FT_LOJA    := SF1->F1_LOJA
	    SFT->FT_ESPECIE := SF1->F1_ESPECIE
	    SFT->FT_CFOP    := SF4->F4_CF
	    SFT->FT_TIPO    := 'D'
	    SFT->FT_ESTADO  := SF1->F1_EST
	    SFT->FT_TIPOMOV := 'E'
	    SFT->FT_ITEM    := SD1->D1_ITEM
        SFT->FT_PRODUTO := cProduto
        SFT->FT_DESCZFR := SD1->D1_DESCICM
        SFT->FT_QUANT   := SD1->D1_QUANT
     
        SFT->FT_TOTAL   := SD1->D1_TOTAL - SFT->FT_DESCZFR

        If SFT->FT_DESCZFR <> 0

           SFT->FT_PRCUNIT := (SFT->FT_TOTAL - SFT->FT_DESCZFR) / SFT->FT_QUANT

        Else

           SFT->FT_PRCUNIT := SD1->D1_VUNIT

        End

        SFT->FT_VALCONT := (SD1->D1_TOTAL + SD1->D1_IPI + SD1->D1_ICMSRET) - SFT->FT_DESCZFR
        SFT->FT_ICMSRET := SD1->D1_ICMSRET
        SFT->FT_ICMSCOM := SD1->D1_ICMSRET
        SFT->FT_CREDST  := iif( SD1->D1_ICMSRET <> 0, '0', ' ')
        SFT->FT_BASERET := SD1->D1_BRICMS
        SFT->FT_MARGEM  := SD1->D1_MARGEM
        SFT->FT_ALIQSOL := SD1->D1_ALIQSOL
//        SFT->FT_FCICOD  := SD1->D1_FCICOD
        SFT->FT_CSTCOF  := SD1->D1_CSTCOF
        SFT->FT_ALIQCOF := SD1->D1_ALQIMP5
        SFT->FT_BASECOF := SD1->D1_BASIMP5
        SFT->FT_VALCOF  := SD1->D1_VALIMP5
        SFT->FT_CSTPIS  := SD1->D1_CSTPIS
        SFT->FT_ALIQPIS := SD1->D1_ALQIMP6
        SFT->FT_BASEPIS := SD1->D1_BASIMP6
        SFT->FT_VALPIS  := SD1->D1_VALIMP6

        If (SF1->F1_VALCOFI <> 0)
           SFT->FT_BRETCOF := SFT->FT_TOTAL
           SFT->FT_VRETCOF  := round( SFT->FT_TOTAL * 0.005, 2 )
           SFT->FT_ARETCOF  := 0.5
        End

        If (SF1->F1_VALCOFI <> 0)
           SFT->FT_BRETPIS := SFT->FT_TOTAL
           SFT->FT_VRETPIS  := round( SFT->FT_TOTAL * 0.001, 2 )
           SFT->FT_ARETPIS  := 0.1
        End

        If SFT->FT_BASEICM = 0

           If Substr( SFT->FT_CFOP, 2, 1 ) <> '9'

              SFT->FT_ISENICM := SFT->FT_VALCONT

           Else

              SFT->FT_OUTRICM := SFT->FT_VALCONT

           End

        End

        If SFT->FT_BASEIPI = 0

           If Substr( SFT->FT_CFOP, 2, 1 ) <> '9'

              SFT->FT_ISENIPI := SFT->FT_VALCONT

           Else

              SFT->FT_OUTRIPI := SFT->FT_VALCONT
                                                                       
           End

        End

        SFT->FT_CLASFIS := SD1->D1_CLASFIS
        SFT->FT_CTIPI   := SD1->D1_CSTIPI
        SFT->FT_POSIPI  := SB1->B1_POSIPI
        SFT->FT_ESTOQUE := 'N'
        SFT->FT_ALIQICM := ITE->D2_PICM
        SFT->FT_BASEICM := ITE->D2_BASEICM
        SFT->FT_VALICM  := ITE->D2_VALICM
        SFT->FT_BASEIPI := SD1->D1_BASEIPI
        SFT->FT_ALIQIPI := ITE->D2_IPI
        SFT->FT_VALIPI  := ITE->D2_VALIPI
        SFT->FT_RECISS  := '2'
        SFT->FT_DESPIPI := iif( SFT->FT_OUTRIPI <> 0, 'N', 'S' )
        SFT->FT_MOTICMS := ITE->D2_MOTDES
        SFT->FT_AGREG   := 'S'
        SFT->FT_IDENTF3 := '000001'
        SFT->FT_CHVNFE  := cProt
        SFT->FT_CODNFE  := cAut
        SFT->( dbUnLock() )

     End    
  
     ITE->( dbSkip() )
		
End

SF3->F3_CFO     := SFT->FT_CFOP
SF3->F3_ALIQICM := _pICMS

If SF3->F3_BASEICM = 0

  If Substr( SF3->F3_CFO, 2, 1 ) <> '9'

     SF3->F3_ISENICM := SF3->F3_VALCONT

  Else

     SF3->F3_OUTRICM := SF3->F3_VALCONT

  End

End

If SF3->F3_BASEIPI = 0

   If Substr( SF3->F3_CFO, 2, 1 ) <> '9'

      SF3->F3_ISENIPI := SF3->F3_VALCONT

   Else

      SF3->F3_OUTRIPI := SF3->F3_VALCONT

   End

End

SF3->( dbUnLock() )

If (SF1->F1_ICMSRET <> 0) .And.;
   (_cFilial <> '9001')

   RecLock( 'SF6', .T. )

   SF6->F6_FILIAL   := _cFilial
   SF6->F6_NUMERO   := SF1->F1_DOC
   SF6->F6_DOC      := SF1->F1_DOC
   SF6->F6_SERIE    := SF1->F1_SERIE
   SF6->F6_EST      := SF1->F1_EST
   SF6->F6_CLIFOR   := SF1->F1_FORNECE
   SF6->F6_LOJA     := SF1->F1_LOJA
   SF6->F6_TIPODOC  := SF1->F1_TIPO
   SF6->F6_OPERNF   := '1'
   SF6->F6_TIPOIMP  := '3'
   SF6->F6_PROCESS  := '2'
   SF6->F6_DTARREC  := SF1->F1_EMISSAO
   SF6->F6_DTVENC   := (SF1->F1_EMISSAO + 7)
   SF6->F6_MESREF   := Month( SF1->F1_EMISSAO )
   SF6->F6_ANOREF   := Year( SF1->F1_EMISSAO )
   SF6->F6_CODREC   := '100099'
   SF6->F6_VALOR    := SF1->F1_ICMSRET

   SF6->( dbUnLock() )

   If CDC->( dbSeek( _cFilCDC + 'E' + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA + SF1->F1_EST ) )

      RecLock( 'CDC', .F. )

   Else

      RecLock( 'CDC', .T. )
   
   End

   CDC->CDC_FILIAL := _cFilial
   CDC->CDC_TPMOV  := 'E'
   CDC->CDC_DOC    := SF1->F1_DOC
   CDC->CDC_SERIE  := SF1->F1_SERIE
   CDC->CDC_CLIFOR := SF1->F1_FORNECE
   CDC->CDC_LOJA   := SF1->F1_LOJA
   CDC->CDC_GUIA   := SF1->F1_DOC
   CDC->CDC_UF     := SF1->F1_EST
   CDC->CDC_IFCOMP := '000001'

   CDC->( dbUnLock() )

End
    
Return( NIL )

