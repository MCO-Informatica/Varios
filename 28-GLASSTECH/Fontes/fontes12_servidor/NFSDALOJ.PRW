Static cBDGSTQ	:= Iif(At("_TST", Upper(GetEnvServer())) > 0, "TESTE"			, "TPCP"		)
Static cBDPROT	:= GetMv("MV_TWINENV")
Static cBVGstq	:= Iif(At("_TST", Upper(GetEnvServer())) > 0, "BVTESTE"			, "BV"			)
Static cBDPROTG	:= GetMv("MV_TWINENF")
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออออออหออออออัออออออออออปฑฑ
ฑฑบPrograma  ณ NfSdaLoj  บ Autor ณ S้rgio Santana       บ Data ณ02/07/2015บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯอออออออออออออออออออออออสออออออฯออออออออออนฑฑ
ฑฑบDescricao ณ Importacao Base de Dados Lojinha                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบALTERACAO ณ                                                            บฑฑ 
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ThermoGlass                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

//U_NFSDALOJ('20150701','20150731')

#INCLUDE "PROTHEUS.CH"
#include "RWMAKE.ch"
#include "Colors.ch"
#include "Font.ch"
#Include "HBUTTON.CH"
#include "Topconn.ch"

User Function NfSdaLoj( _cDtIni, _cDtFim )

Local _cDB  := 'MSSQL/'+cBDPROTG
Local _cSrv := '192.168.0.7'
Local _nHnd := 0

DEFAULT _cDtIni := DtoS( dDataBase - 1 )
DEFAULT _cDtFim := DtoS( dDataBase - 1 )

PRIVATE lPcNfe   := GETMV( "MV_PCNFE" )
PRIVATE _cFilSA1 := ' '
PRIVATE _cFilSA2 := ' '
PRIVATE _cFilSA5 := ' '
PRIVATE _cFilSA7 := ' '
PRIVATE _cFilSB1 := ' '
PRIVATE _cFilSB5 := ' '
PRIVATE _cFilSC7 := ' '
PRIVATE _cFilSF1 := ' '
PRIVATE _cFilSF2 := ' '
PRIVATE _cFilSF4 := ' '
PRIVATE _cFilSF6 := ' '

Static aTipo      := { 'N','B','D' }

/*_nHnd := TCLink( _cDb, _cSrv ,7890 )

If _nHnd < 0

    UserException("Erro ( " + Srt( _nHnd, 4 ) + " ) ao conectar com " + _cDb + " em " +  _cSrv )

End
*/
_cFilSA1 := xFilial( 'SA1' )
_cFilSA2 := xFilial( 'SA2' )
_cFilSA5 := xFilial( 'SA5' )
_cFilSA7 := xFilial( 'SA7' )
_cFilSB1 := xFilial( 'SB1' )
_cFilSB5 := xFilial( 'SB5' )
_cFilSC7 := xFilial( 'SC7' )                     
_cFilSF1 := xFilial( 'SF1' )
_cFilSF2 := xFilial( 'SF2' )
_cFilSF4 := xFilial( 'SF4' )
_cFilSF6 := xFilial( 'SF6' )

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
_qSda += '  ISNULL(NOTA.ID_TITULO, 0) AS F2_DUPL,'
_qSda += '  NOTA.GERA_RECEITA AS F2_FINANC,'
_qSda += '  NOTA.ID_VENDEDOR AS F2_VEND1,'
_qSda += '  CONVERT( CHAR(8),NOTA.EMISSAO, 112) AS F2_EMISSAO,'
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
_qSda += " WHERE (NOTA.POS <> 'C') and (CONVERT( char(8), EMISSAO, 112) BETWEEN '" + _cDtIni + "' AND '" + _cDtFim + "') and (NOTA.E_S = 'S') "
_qSda += " and (NOTA.SERIE = '3') and (NOTA.ID_EMPRESA = 12) "
_qSda += ') '
_qSda += 'SELECT Saidas.* FROM Saidas '
_qSda += "LEFT OUTER JOIN ["+cBDGSTQ+"].[dbo].[EMPRESA] EMP ON REPLACE(REPLACE(REPLACE(EMP.CGC,'.',''),'/',''),'-','') = Saidas.CNPJCLI "
_qSda += "where (EMP.CGC Is Null) AND (F2_FINANC = 'S')"

dbUseArea( .T.,"TOPCONN",TcGenQry(,,_qSda),"CAB",.T.,.T.)

MV_PAR01 := 1

While ! ( CAB->( Eof() ) )
	
	_nFrete := 0
	_nDesp  := 0		

	cTipo := "N"
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
    ElseIf CAB->cCgc = '03061254000370'
         _cFilSF2 :='0215'
    ElseIf CAB->cCgc = '25074100000193'
         _cFilSF2 :='0801'
    ElseIf CAB->cCgc = '11175943000171' // FFM
    
        If ! ( CAB->F2_SERIE $ '2;4' )

           _cFilSF2 := '0701'

        Else

		   CAB->( dbSkip() )
		   Loop

        End
         
    Else

          _cFilSF2 := '9001'

    End
    
    _cFilSD2 := _cFilSF2
    
	// -- Nota Fiscal jแ existe na base ?

	If SF2->( dbSeek( _cFilSF2 + StrZero( CAB->F2_DOC, 9 ) + Padr('4',3)+ SA1->A1_COD + SA1->A1_LOJA ) )

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
                  'Encontra-se lan็ada no sistema. Importa็ใo interrompida';
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
			      'Encontra-se lan็ada no sistema. Importa็ใo interrompida';
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

    IncNFCS( _cFilSF2, 'SPED' )    

    _cSel := 'SELECT TOP 1 '
    _cSel += ' ITEM.VLR_UNT VlrUnt,'
    _cSel += ' ITEM.ID_DIMENSIONAL idDim,'
    _cSel += ' ITEM.ID_PRODUTO idPrd,'
    _cSel += ' 1 D2_QUANT,'
    _cSel += ' DIM.PESO_UN Peso,'
    _cSel += ' NOTA.NRO_NF D2_DOC,'
    _cSel += ' ITEM.ID_ITEM_NOTA idItem,'
    _cSel += " CFO.TES idCfo "
    _cSel += ' FROM '+cBDGSTQ+'.dbo.ITEM_NOTA ITEM'
    _cSel += ' JOIN '+cBDGSTQ+'.dbo.DIMENSIONAL DIM  ON (DIM.ID_DIMENSIONAL = ITEM.ID_DIMENSIONAL)'
    _cSel += ' JOIN '+cBDGSTQ+'.dbo.NOTA        NOTA ON (NOTA.ID_NOTA       = ITEM.ID_NOTA)'
    _cSel += ' JOIN '+cBDGSTQ+'.dbo.CLIENTE     CLI  ON (CLI.ID_CLIENTE     = NOTA.ID_CLIENTE)'
    _cSel += ' JOIN '+cBDGSTQ+'.dbo.CIDADE      CID  ON (CID.ID_CIDADE      = CLI.ID_CIDADE)'
    _cSel += " JOIN "+cBDGSTQ+".dbo.CFO         CFO  ON (CFO.ID_CFO         = CASE WHEN CID.UF = 'SP' THEN 230 ELSE 203 END)"
    _cSel += ' WHERE (ITEM.ID_NOTA = ' + ltrim(Str(CAB->F2_ID,10,0)) + ') AND (ITEM.VLR_UNT = (SELECT MIN(VLR_UNT) FROM '+cBDGSTQ+'.dbo.ITEM_NOTA WHERE ID_NOTA = ' + ltrim(Str(CAB->F2_ID,10,0)) + '))'

    dbUseArea( .T.,"TOPCONN",TcGenQry(,,_cSel),"LOJ",.T.,.T.)
 
    SF4->( dbSeek( _cFilSF4 + LOJ->idCfo, .F. ) )

    _cItem := '00'

    _qIte := "SELECT CATALOGO D2_COD, DESCRICAO D2_DESCR, REPLACE( CLASSIFICACAO, '.','') D2_POSIPI, (ORIGEM + CST_ICMS) D2_CLASFIS,"
    _qIte += 'UN D2_UM, 1 D2_QUANT, vlr_unt D2_PRCVEN, ICM D2_PICM, IPI D2_IPI, BSE_ICMS D2_BASEICM, VLR_ICMS D2_VALICM, VLR_IPI D2_VALIPI,'
    _qIte += 'ALIQ_COFINS D2_ALQIMP5, VLR_COFINS D2_VALIMP5, ALIQ_PIS D2_ALQIMP6, VLR_PIS D2_VALIMP6, FCI D2_FCICOD,'
    _qIte += 'Desconto D2_DESCZFM, AliqRetCofins D2_ALQCOF, ValorRetCofins D2_VALCOF, AliqRetPis D2_ALQPIS, ValorRetPis D2_VALPIS, '
    _qIte += 'CST_IPI D2_CSTIPI, CST_PIS D2_CSTPIS, CST_COFINS D2_CSTCOF, BseSubTrib D2_BRICMS, VlrSubTrib D2_ICMSRET, AliqSubTrib D2_ALIQSOL,'
    _qIte += 'AliqIVA D2_MARGEM, MotDesIcms D2_MOTDES, Desconto D2_DESCZFR, M2_REAL D2_QTSEGUM '
    _qIte += 'FROM ['+cBDGSTQ+'].[dbo].[ITEM_NOTA] WHERE (ID_ITEM_NOTA = ' + LTRIM(STR(LOJ->idItem, 8)) + ')' // = 361477

    LOJ->( dbCloseArea() )
    
    dbUseArea( .T.,"TOPCONN",TcGenQry(,,_qIte),"ITE",.T.,.T.)

    IncNFDS( _cFilSF2 )
    
/*    If (CAB->F2_ORC = 2 .Or.;
       CAB->F2_ORC = 8)

       IncNFCS( '9001', 'ORC' )
       ITE->( dbGoTop() )
       IncNFDS( '9001' )

    End
*/    
    ITE->( dbCloseArea() )
    CAB->( dbSkip() )
	
End

PutMV("MV_PCNFE",lPcNfe)
CAB->( dbCloseArea() )
AtuTipoPrd()

Return( NIL )

Static Function IncNFCS( _cFilial, _cTipo )

    RecLock( 'SF2', .T. )

    SF2->F2_FILIAL  := _cFilial
    SF2->F2_DOC     := StrZero( CAB->F2_DOC, 9 )
    SF2->F2_SERIE   := Padr( '4', 3 )
    SF2->F2_PREFIXO := Padr( '4', 3 )
    SF2->F2_CLIENTE := SA1->A1_COD
    SF2->F2_CLIENT  := SA1->A1_COD
    SF2->F2_LOJA    := SA1->A1_LOJA
    SF2->F2_LOJENT  := SA1->A1_LOJA
    SF2->F2_COND    := ''
    SF2->F2_FORMUL  := 'S'
    SF2->F2_EMISSAO := dData
    SF2->F2_EST     := SA1->A1_EST
    SF2->F2_TIPOCLI := SA1->A1_TIPO
    SF2->F2_VALBRUT := CAB->F2_VALMERC
    SF2->F2_VALMERC := CAB->F2_VALMERC
    SF2->F2_VALFAT  := CAB->F2_VALMERC

    If (_cFilial <> '9001') .And.;
       (CAB->F2_ORC < 3)

       SF2->F2_VALBRUT := CAB->F2_VALBRUT    
       SF2->F2_DESCZFR := CAB->F2_DESCZFR
       SF2->F2_ICMSRET := CAB->F2_ICMSRET
       SF2->F2_BRICMS  := CAB->F2_BRICMS
       SF2->F2_VALIMP5 := CAB->F2_VALIMP5
       SF2->F2_BASIMP5 := iif( SF2->F2_VALIMP5 <> 0, SF2->F2_VALMERC, 0)
       SF2->F2_VALIMP6 := CAB->F2_VALIMP6
       SF2->F2_BASIMP6 := iif( SF2->F2_VALIMP6 <> 0, SF2->F2_VALMERC, 0)
       SF2->F2_VALCOFI := CAB->F2_VALCOFI
       SF2->F2_BASCOFI := iif( SF2->F2_VALCOFI <> 0, SF2->F2_VALMERC, 0)
       SF2->F2_VALPIS  := CAB->F2_VALPIS
       SF2->F2_BASPIS  := iif( SF2->F2_VALPIS <> 0, SF2->F2_VALMERC, 0)
       SF2->F2_VALICM  := CAB->F2_VALICM
       SF2->F2_BASEICM := CAB->F2_BASEICM
       SF2->F2_VALIPI  := CAB->F2_VALIPI
       SF2->F2_BASEIPI := iif( SF2->F2_VALIPI <> 0, CAB->F2_VALMERC, 0)

    End

    SF2->F2_ESPECIE := _cTipo
    SF2->F2_CHVNFE  := cProt
    SF2->F2_CODNFE  := cAut
    SF2->F2_DAUTNFE := dData 
    SF2->F2_TIPO    := 'N'
    SF2->F2_RECISS  := '2'
    SF2->F2_RECFAUT := '1'
    SF2->F2_MOEDA   := 1
    SF2->F2_FIMP    := 'S'

    SF2->( dbUnLock() )

    
Return( NIL )    

Static Function IncNFDS( _cFilial )

_pICMS := 0

While ! ( ITE->( Eof() ) )

   cProduto := PadR( ITE->D2_COD, 30 )
   _pICMS   := ITE->D2_PICM

   If ! ( SB1->( dbSeek( _cFilSB1 + ITE->D2_COD, .F. ) )  )

      RecLock( 'SB1', .T. )
   
      SB1->B1_FILIAL  := _cFilSB1
      SB1->B1_COD     := ITE->D2_COD
      SB1->B1_DESC    := ITE->D2_DESCR
      SB1->B1_TIPO    := 'PA'
      SB1->B1_UM      := ITE->D2_UM
      SB1->B1_LOCPAD  := '01'
      SB1->B1_POSIPI  := ITE->D2_POSIPI
      SB1->B1_ORIGEM  := Substr( ITE->D2_CLASFIS, 1, 1 )
      SB1->B1_GARANT  := '2'
//      SB1->B1_PESO    := TMP->PESO_UN
      SB1->( dbUnLock() )
      
/*      RecLock( 'SB5', .T. )
      
      SB5->B5_FILIAL := _cFilSB5
      SB5->B5_COMPR  := TMP->DIM_A
      SB5->B5_ESPESS := TMP->DIM_B
      SB5->B5_LARG   := TMP->ESPESSURA
      SB5->B5_UMDIPI :=      
      SB5->B5_  :=      
      SB5->B5_COMPR  :=      
      SB5->B5_COMPR  :=
      SB5->B5_COMPR  :=
      SB5->B5_COMPR  :=

      SB5->( dbUnLock() )
  */
   End

   RecLock( 'SD2', .T. )
   SD2->D2_FILIAL  := _cFilial
   SD2->D2_DOC     := SF2->F2_DOC		
   SD2->D2_SERIE   := SF2->F2_SERIE
   SD2->D2_EMISSAO := SF2->F2_EMISSAO
   SD2->D2_CLIENTE := SF2->F2_CLIENTE
   SD2->D2_LOJA    := SF2->F2_LOJA
   SD2->D2_ESPECIE := SF2->F2_ESPECIE
   SD2->D2_NUMSEQ  := ProxNum()
   SD2->D2_TES     := SF4->F4_CODIGO
   SD2->D2_CF      := SF4->F4_CF
   SD2->D2_TIPO    := 'N'
   SD2->D2_TP      := 'PA'
   SD2->D2_LOCAL   := '01'
   SD2->D2_EST     :=  SF2->F2_EST
   _cItem := Soma1( _cItem )
   SD2->D2_ITEM    := _cItem
   SD2->D2_COD     := ITE->D2_COD
   SD2->D2_DESCR   := ITE->D2_DESCR
   SD2->D2_UM      := ITE->D2_UM
   SD2->D2_QUANT   := ITE->D2_QUANT
   SD2->D2_PRUNIT  := ITE->D2_PRCVEN
   SD2->D2_PRCVEN  := ITE->D2_PRCVEN
   SD2->D2_QTSEGUM := ITE->D2_QTSEGUM
   SD2->D2_SEGUM   := SB1->B1_SEGUM
   SD2->D2_TOTAL   := Round( ITE->D2_QUANT * ITE->D2_PRCVEN, 2)
   SD2->D2_CUSTO1  := SD2->D2_TOTAL - ITE->D2_VALICM - ITE->D2_VALIMP5 - ITE->D2_VALIMP6 - ITE->D2_DESCZFM

   If _cFilial <> '9001' .And.;
       (CAB->F2_ORC < 3)

      SD2->D2_ICMSRET := ITE->D2_ICMSRET
      SD2->D2_BRICMS  := ITE->D2_BRICMS
      SD2->D2_MARGEM  := ITE->D2_MARGEM
      SD2->D2_ALIQSOL := ITE->D2_ALIQSOL
      SD2->D2_DESCZFR := ITE->D2_DESCZFR
      SD2->D2_FCICOD  := ITE->D2_FCICOD
      SD2->D2_CSTCOF  := ITE->D2_CSTCOF
      SD2->D2_ALQIMP5 := ITE->D2_ALQIMP5
      SD2->D2_BASIMP5 := If( ITE->D2_VALIMP5 <> 0, SD2->D2_TOTAL, 0 )
      SD2->D2_VALIMP5 := ITE->D2_VALIMP5
      SD2->D2_CSTPIS  := ITE->D2_CSTPIS
      SD2->D2_ALQIMP6 := ITE->D2_ALQIMP6
      SD2->D2_BASIMP6 := If( ITE->D2_VALIMP6 <> 0, SD2->D2_TOTAL, 0 )
      SD2->D2_VALIMP6 := ITE->D2_VALIMP6

      If (SF2->F2_VALCOFI <> 0)
         SD2->D2_BASECOF := SD2->D2_TOTAL
         SD2->D2_VALCOF  := ITE->D2_VALCOF
         SD2->D2_ALQCOF  := ITE->D2_ALQCOF
      End

      If (SF2->F2_VALCOFI <> 0)
         SD2->D2_BASEPIS := SD2->D2_TOTAL
         SD2->D2_VALPIS  := ITE->D2_VALPIS
         SD2->D2_ALQPIS  := ITE->D2_ALQPIS
      End

      SD2->D2_PICM    := ITE->D2_PICM
      SD2->D2_BASEICM := If( ITE->D2_VALICM <> 0, SD2->D2_TOTAL, 0 )
      SD2->D2_VALICM  := If( ITE->D2_VALICM <> 0, SD2->D2_TOTAL * (ITE->D2_PICM / 2), 0 )
      SD2->D2_BASEIPI := If( ITE->D2_VALIPI <> 0, SD2->D2_TOTAL, 0 )
      SD2->D2_IPI     := ITE->D2_IPI
      SD2->D2_VALIPI  := If( ITE->D2_VALIPI <> 0, SD2->D2_TOTAL * (ITE->D2_IPI / 2), 0 )

   End

   SD2->D2_VALBRUT := SD2->D2_TOTAL + iif( _cFilial <> '9001', SD2->D2_VALIPI + SD2->D2_ICMSRET, 0 )
   SD2->D2_CLASFIS := ITE->D2_CLASFIS
   SD2->D2_SITTRIB := ITE->D2_CLASFIS
   SD2->D2_CSTIPI  := ITE->D2_CSTIPI 
   SD2->D2_ESTOQUE := 'N'
        
   SD2->( dbUnLock() )

   If (SD2->D2_ICMSRET <> 0) .And.;
      (_cFilial <> '9001')

      RecLock( 'CD2', .T. )
      CD2->CD2_FILIAL   := _cFilial
      CD2->CD2_TPMOV   := 'S'
      CD2->CD2_ITEM     := SD2->D2_ITEM
      CD2->CD2_CODPRO   := SD2->D2_COD
      CD2->CD2_DOC      := SF2->F2_DOC
      CD2->CD2_SERIE    := SF2->F2_SERIE
      CD2->CD2_CODCLI   := SF2->F2_CLIENTE
      CD2->CD2_LOJCLI   := SF2->F2_LOJA
      CD2->CD2_IMP      := 'SOL'
      CD2->CD2_ORIGEM   := Substr( SD2->D2_CLASFIS, 1, 1)
      CD2->CD2_CST      := Substr( SD2->D2_CLASFIS, 2, 2)
      CD2->CD2_MVA      := SD2->D2_MARGEM
      CD2->CD2_BC       := SD2->D2_BRICMS
      CD2->CD2_ALIQ     := SD2->D2_ALIQSOL
      CD2->CD2_VLTRIB   := SD2->D2_ICMSRET
      CD2->CD2_QTRIB    := SD2->D2_QUANT
      CD2->CD2_DESCZF   := SD2->D2_DESCZFR
      CD2->( dbUnLock() )

    End

    If (SD2->D2_DESCZFR <> 0) .And.;
       (_cFilial <> '9001') 

       RecLock( 'CD2', .T. )
       CD2->CD2_FILIAL   := _cFilial
       CD2->CD2_TPMOV    := 'S'
       CD2->CD2_ITEM     := SD2->D2_ITEM
       CD2->CD2_CODPRO   := SD2->D2_COD
       CD2->CD2_DOC      := SF2->F2_DOC
       CD2->CD2_SERIE    := SF2->F2_SERIE
       CD2->CD2_CODCLI   := SF2->F2_CLIENTE
       CD2->CD2_LOJCLI   := SF2->F2_LOJA
       CD2->CD2_IMP      := 'ZFM'
       CD2->CD2_ORIGEM   := Substr( SD2->D2_CLASFIS, 1, 1)
       CD2->CD2_CST      := Substr( SD2->D2_CLASFIS, 2, 2)
       CD2->CD2_MVA      := 0
       CD2->CD2_BC       := 0
       CD2->CD2_ALIQ     := 0
       CD2->CD2_VLTRIB   := 0
       CD2->CD2_QTRIB    := SD2->D2_QUANT
       CD2->CD2_DESCZF   := SD2->D2_DESCZFR
       CD2->( dbUnLock() )

     End
    
     If (SD2->D2_VALICM <> 0) .And.;
        (_cFilial <> '9001') 

        RecLock( 'CD2', .T. )
        CD2->CD2_FILIAL   := _cFilial
        CD2->CD2_TPMOV    := 'S'
        CD2->CD2_ITEM     := SD2->D2_ITEM
        CD2->CD2_CODPRO   := SD2->D2_COD
        CD2->CD2_DOC      := SF2->F2_DOC
        CD2->CD2_SERIE    := SF2->F2_SERIE
        CD2->CD2_CODCLI   := SF2->F2_CLIENTE
        CD2->CD2_LOJCLI   := SF2->F2_LOJA
        CD2->CD2_IMP      := 'ICM'
        CD2->CD2_ORIGEM   := Substr( SD2->D2_CLASFIS, 1, 1)
        CD2->CD2_CST      := Substr( SD2->D2_CLASFIS, 2, 2)
        CD2->CD2_BC       := SD2->D2_BASEICM
        CD2->CD2_ALIQ     := SD2->D2_PICM
        CD2->CD2_VLTRIB   := SD2->D2_VALICM
        CD2->CD2_QTRIB    := SD2->D2_QUANT
        CD2->( dbUnLock() )

     End

     If (SD2->D2_VALIPI <> 0) .And.;
        (_cFilial <> '9001') 

        RecLock( 'CD2', .T. )
        CD2->CD2_FILIAL   := _cFilial
        CD2->CD2_TPMOV    := 'S'
        CD2->CD2_ITEM     := SD2->D2_ITEM
        CD2->CD2_CODPRO   := SD2->D2_COD
        CD2->CD2_DOC      := SF2->F2_DOC
        CD2->CD2_SERIE    := SF2->F2_SERIE
        CD2->CD2_CODCLI   := SF2->F2_CLIENTE
        CD2->CD2_LOJCLI   := SF2->F2_LOJA
        CD2->CD2_IMP      := 'IPI'
        CD2->CD2_ORIGEM   := Substr( SD2->D2_CLASFIS, 1, 1)
        CD2->CD2_CST      := SD2->D2_CSTIPI
        CD2->CD2_BC       := SD2->D2_BASEIPI
        CD2->CD2_ALIQ     := SD2->D2_IPI
        CD2->CD2_VLTRIB   := SD2->D2_VALIPI
        CD2->CD2_QTRIB    := SD2->D2_QUANT
        CD2->( dbUnLock() )

     End

     If (SD2->D2_VALIMP5 <> 0) .And.;
        (_cFilial <> '9001') 

        RecLock( 'CD2', .T. )
        CD2->CD2_FILIAL   := _cFilial
        CD2->CD2_TPMOV    := 'S'
        CD2->CD2_ITEM     := SD2->D2_ITEM
        CD2->CD2_CODPRO   := SD2->D2_COD
        CD2->CD2_DOC      := SF2->F2_DOC
        CD2->CD2_SERIE    := SF2->F2_SERIE
        CD2->CD2_CODCLI   := SF2->F2_CLIENTE
        CD2->CD2_LOJCLI   := SF2->F2_LOJA
        CD2->CD2_IMP      := 'CF2'
        CD2->CD2_ORIGEM   := Substr( SD2->D2_CLASFIS, 1, 1)
        CD2->CD2_CST      := SD2->D2_CSTCOF
        CD2->CD2_BC       := SD2->D2_BASIMP5
        CD2->CD2_ALIQ     := SD2->D2_ALQIMP5
        CD2->CD2_VLTRIB   := SD2->D2_VALIMP5
        CD2->CD2_QTRIB    := SD2->D2_QUANT
        CD2->( dbUnLock() )

     End

     If (SD2->D2_VALIMP6 <> 0) .And.;
        (_cFilial <> '9001') 

        RecLock( 'CD2', .T. )
        CD2->CD2_FILIAL   := _cFilial
        CD2->CD2_TPMOV    := 'S'
        CD2->CD2_ITEM     := SD2->D2_ITEM
        CD2->CD2_CODPRO   := SD2->D2_COD
        CD2->CD2_DOC      := SF2->F2_DOC
        CD2->CD2_SERIE    := SF2->F2_SERIE
        CD2->CD2_CODCLI   := SF2->F2_CLIENTE
        CD2->CD2_LOJCLI   := SF2->F2_LOJA
        CD2->CD2_IMP      := 'PS2'
        CD2->CD2_ORIGEM   := Substr( SD2->D2_CLASFIS, 1, 1)
        CD2->CD2_CST      := SD2->D2_CSTPIS
        CD2->CD2_BC       := SD2->D2_BASIMP6
        CD2->CD2_ALIQ     := SD2->D2_ALQIMP6
        CD2->CD2_VLTRIB   := SD2->D2_VALIMP6
        CD2->CD2_QTRIB    := SD2->D2_QUANT
        CD2->( dbUnLock() )

     End

     If (SD2->D2_VALPIS <> 0) .And.;
        (_cFilial <> '9001') 

        RecLock( 'CD2', .T. )
        CD2->CD2_FILIAL   := _cFilial
        CD2->CD2_TPMOV    := 'S'
        CD2->CD2_ITEM     := SD2->D2_ITEM
        CD2->CD2_CODPRO   := SD2->D2_COD
        CD2->CD2_DOC      := SF2->F2_DOC
        CD2->CD2_SERIE    := SF2->F2_SERIE
        CD2->CD2_CODCLI   := SF2->F2_CLIENTE
        CD2->CD2_LOJCLI   := SF2->F2_LOJA
        CD2->CD2_IMP      := 'PIS'
        CD2->CD2_ORIGEM   := Substr( SD2->D2_CLASFIS, 1, 1)
        CD2->CD2_CST      := SD2->D2_CSTPIS
        CD2->CD2_BC       := SD2->D2_BASEPIS
        CD2->CD2_ALIQ     := SD2->D2_ALQPIS
        CD2->CD2_VLTRIB   := SD2->D2_VALPIS
        CD2->CD2_QTRIB    := SD2->D2_QUANT
        CD2->( dbUnLock() )

     End

     If (SD2->D2_VALCOF <> 0) .And.;
        (_cFilial <> '9001') 

        RecLock( 'CD2', .T. )
        CD2->CD2_FILIAL   := _cFilial
        CD2->CD2_TPMOV    := 'S'
        CD2->CD2_ITEM     := SD2->D2_ITEM
        CD2->CD2_CODPRO   := SD2->D2_COD
        CD2->CD2_DOC      := SF2->F2_DOC
        CD2->CD2_SERIE    := SF2->F2_SERIE
        CD2->CD2_CODCLI   := SF2->F2_CLIENTE
        CD2->CD2_LOJCLI   := SF2->F2_LOJA
        CD2->CD2_IMP      := 'COF'
        CD2->CD2_ORIGEM   := Substr( SD2->D2_CLASFIS, 1, 1)
        CD2->CD2_CST      := SD2->D2_CSTCOF
        CD2->CD2_BC       := SD2->D2_BASECOF
        CD2->CD2_ALIQ     := SD2->D2_ALQCOF
        CD2->CD2_VLTRIB   := SD2->D2_VALCOF
        CD2->CD2_QTRIB    := SD2->D2_QUANT
        CD2->( dbUnLock() )

     End

     If (_cFilial <> '9001') 

	    RecLock( 'SFT', .T. )

	    SFT->FT_FILIAL  := _cFilial
        SFT->FT_NFISCAL := SF2->F2_DOC		
 	    SFT->FT_SERIE   := SF2->F2_SERIE
	    SFT->FT_EMISSAO := SF2->F2_EMISSAO
	    SFT->FT_ENTRADA := SF2->F2_EMISSAO
	    SFT->FT_CLIEFOR := SF2->F2_CLIENTE
	    SFT->FT_LOJA    := SF2->F2_LOJA
	    SFT->FT_CLIENT  := SF2->F2_CLIENTE
	    SFT->FT_LOJENT  := SF2->F2_LOJA
	    SFT->FT_ESPECIE := SF2->F2_ESPECIE
	    SFT->FT_CFOP    := SF4->F4_CF
	    SFT->FT_TIPO    := 'N'
	    SFT->FT_ESTADO  := SF2->F2_EST
	    SFT->FT_TIPOMOV := 'S'
	    SFT->FT_ITEM    := SD2->D2_ITEM
        SFT->FT_PRODUTO := cProduto
        SFT->FT_DESCZFR := SD2->D2_DESCZFR
        SFT->FT_QUANT   := SD2->D2_QUANT
     
        SFT->FT_TOTAL   := SD2->D2_TOTAL - SFT->FT_DESCZFR

        If SFT->FT_DESCZFR <> 0

           SFT->FT_PRCUNIT := (SFT->FT_TOTAL - SFT->FT_DESCZFR) / SFT->FT_QUANT

        Else

           SFT->FT_PRCUNIT := SD2->D2_PRCVEN

        End

        SFT->FT_VALCONT := (SD2->D2_TOTAL + SD2->D2_IPI + SD2->D2_ICMSRET) - SFT->FT_DESCZFR
        SFT->FT_ICMSRET := SD2->D2_ICMSRET
        SFT->FT_ICMSCOM := SD2->D2_ICMSRET
        SFT->FT_CREDST  := iif( SD2->D2_ICMSRET <> 0, '0', ' ')
        SFT->FT_BASERET := SD2->D2_BRICMS
        SFT->FT_MARGEM  := SD2->D2_MARGEM
        SFT->FT_ALIQSOL := SD2->D2_ALIQSOL
//        SFT->FT_FCICOD  := SD2->D2_FCICOD
        SFT->FT_CSTCOF  := SD2->D2_CSTCOF
        SFT->FT_ALIQCOF := SD2->D2_ALQIMP5
        SFT->FT_BASECOF := SD2->D2_BASIMP5
        SFT->FT_VALCOF  := SD2->D2_VALIMP5
        SFT->FT_CSTPIS  := SD2->D2_CSTPIS
        SFT->FT_ALIQPIS := SD2->D2_ALQIMP6
        SFT->FT_BASEPIS := SD2->D2_BASIMP6
        SFT->FT_VALPIS  := SD2->D2_VALIMP6

        If (SF2->F2_VALCOFI <> 0)
           SFT->FT_BRETCOF := SFT->FT_TOTAL
           SFT->FT_VRETCOF  := round( SFT->FT_TOTAL * 0.005, 2 )
           SFT->FT_ARETCOF  := 0.5
        End

        If (SF2->F2_VALCOFI <> 0)
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

        SFT->FT_CLASFIS := SD2->D2_CLASFIS
        SFT->FT_CTIPI   := SD2->D2_CSTIPI
        SFT->FT_POSIPI  := SB1->B1_POSIPI
        SFT->FT_ESTOQUE := 'N'
        SFT->FT_ALIQICM := ITE->D2_PICM
        SFT->FT_BASEICM := ITE->D2_BASEICM
        SFT->FT_VALICM  := ITE->D2_VALICM
        SFT->FT_BASEIPI := SD2->D2_BASEIPI
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

RecLock( 'SF3', .T. )

SF3->F3_FILIAL  := _cFilial
SF3->F3_NFISCAL := SF2->F2_DOC		
SF3->F3_SERIE   := SF2->F2_SERIE
SF3->F3_EMISSAO := SF2->F2_EMISSAO
SF3->F3_ENTRADA := SF2->F2_EMISSAO
SF3->F3_CLIEFOR := SF2->F2_CLIENTE
SF3->F3_LOJA    := SF2->F2_LOJA
SF3->F3_ESPECIE := SF2->F2_ESPECIE
SF3->F3_CLIENT  := SF2->F2_CLIENTE
SF3->F3_LOJENT  := SF2->F2_LOJA
SF3->F3_TIPO    := SF2->F2_TIPO
SF3->F3_ESTADO  := SF2->F2_EST
SF3->F3_VALCONT := SD2->D2_VALBRUT
SF3->F3_ICMSRET := SD2->D2_ICMSRET
SF3->F3_ICMSCOM := SD2->D2_ICMSRET
SF3->F3_DESCZFR := SD2->D2_DESCZFR
SF3->F3_BASEICM := SD2->D2_BASEICM
SF3->F3_VALICM  := SD2->D2_VALICM
SF3->F3_BASEIPI := iif( SD2->D2_VALIPI <> 0, SD2->D2_TOTAL, 0 )
SF3->F3_VALIPI  := SD2->D2_VALIPI
SF3->F3_RECISS  := '2'
SF3->F3_IDENTFT := '000001'
SF3->F3_CHVNFE  := cProt
SF3->F3_CODNFE  := cAut
SF3->F3_CODRSEF := '100'
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
  
RecLock( 'SF2', .F. )

SF2->F2_VALMERC := SD2->D2_TOTAL
SF2->F2_VALFAT  := SD2->D2_TOTAL
SF2->F2_VALBRUT := SD2->D2_VALBRUT    
SF2->F2_DESCZFR := SD2->D2_DESCZFR
SF2->F2_ICMSRET := SD2->D2_ICMSRET
SF2->F2_BRICMS  := SD2->D2_BRICMS
SF2->F2_VALIMP5 := SD2->D2_VALIMP5
SF2->F2_BASIMP5 := iif( SD2->D2_VALIMP5 <> 0, SF2->F2_VALMERC, 0)
SF2->F2_VALIMP6 := SD2->D2_VALIMP6
SF2->F2_BASIMP6 := iif( SD2->D2_VALIMP6 <> 0, SF2->F2_VALMERC, 0)
SF2->F2_VALCOFI := SD2->D2_VALCOF
SF2->F2_BASCOFI := iif( SD2->D2_VALCOF <> 0, SF2->F2_VALMERC, 0)
SF2->F2_VALPIS  := SD2->D2_VALPIS
SF2->F2_BASPIS  := iif( SD2->D2_VALPIS <> 0, SF2->F2_VALMERC, 0)
SF2->F2_VALICM  := SD2->D2_VALICM
SF2->F2_BASEICM := SD2->D2_BASEICM
SF2->F2_VALIPI  := SD2->D2_VALIPI
SF2->F2_BASEIPI := iif( SD2->D2_VALIPI <> 0, SD2->F2_VALMERC, 0)
                   
SF2->( dbUnLock() )

SF3->F3_VALCONT := SD2->D2_VALBRUT
SF3->F3_BASERET := CAB->F2_BRICMS
SF3->F3_ICMSRET := SD2->D2_ICMSRET
SF3->F3_ICMSCOM := SD2->D2_ICMSRET
SF3->F3_DESCZFR := SD2->D2_DESCZFR
SF3->F3_BASEICM := SD2->D2_BASEICM
SF3->F3_VALICM  := SD2->D2_VALICM
SF3->F3_BASEIPI := iif( SD2->D2_VALIPI <> 0, SD2->D2_VALMERC, 0 )
SF3->F3_VALIPI  := SD2->D2_VALIPI

If (SF2->F2_ICMSRET <> 0) .And.;
   (_cFilial <> '9001')

   RecLock( 'SF6', .T. )

   SF6->F6_FILIAL   := _cFilial
   SF6->F6_NUMERO   := SF2->F2_DOC
   SF6->F6_DOC      := SF2->F2_DOC
   SF6->F6_SERIE    := SF2->F2_SERIE
   SF6->F6_EST      := SF2->F2_EST
   SF6->F6_CLIFOR   := SF2->F2_CLIENTE
   SF6->F6_LOJA     := SF2->F2_LOJA
   SF6->F6_TIPODOC  := SF2->F2_TIPO
   SF6->F6_OPERNF   := '2'
   SF6->F6_TIPOIMP  := '3'
   SF6->F6_PROCESS  := '2'
   SF6->F6_DTARREC  := SF2->F2_EMISSAO
   SF6->F6_DTVENC   := (SF2->F2_EMISSAO + 7)
   SF6->F6_MESREF   := Month( SF2->F2_EMISSAO )
   SF6->F6_ANOREF   := Year( SF2->F2_EMISSAO )
   SF6->F6_CODREC   := '100099'
   SF6->F6_VALOR    := SF2->F2_ICMSRET

   SF6->( dbUnLock() )

   RecLock( 'CDC', .T. )

   CDC->CDC_FILIAL := _cFilial
   CDC->CDC_TPMOV  := 'S'
   CDC->CDC_DOC    := SF2->F2_DOC
   CDC->CDC_SERIE  := SF2->F2_SERIE
   CDC->CDC_CLIFOR := SF2->F2_CLIENTE
   CDC->CDC_LOJA   := SF2->F2_LOJA
   CDC->CDC_GUIA   := SF2->F2_DOC
   CDC->CDC_UF     := SF2->F2_EST
   CDC->CDC_IFCOMP := '000001'

   CDC->( dbUnLock() )

End
    
Return( NIL )

Static Function AtuTipoPrd()

_cUpd := 'UPDATE ['+cBDPROT+'].[dbo].[' + RetSqlName( 'SB1' ) + '] '
_cUpd += "SET "
_cUpd += "B1_GRUPO   = ISNULL(GRUPO,''),"
_cUpd += "B1_TIPOPRD = TIPO, "
_cUpd += "B1_CONV    = ISNULL(M2_VENDA,0), "
_cUpd += "B1_TIPCONV = 'M'," 
_cUpd += "B1_SEGUM  = 'MT' "
//_cUpd += "B1_POSIPI = REPLACE(CLASSIFICACAO,'.','') "
_cUpd += "FROM "
_cUpd += "( "
_cUpd += "SELECT PRD.CATALOGO, CASE PRD.TIPO "
_cUpd += " WHEN 'T' THEN 'T'"
_cUpd += " WHEN 'L' THEN 'L'"
_cUpd += " WHEN 'V' THEN 'V'"
_cUpd += " ELSE "
_cUpd += "CASE "
_cUpd += " WHEN PRD.ID_SERIE = 82 THEN 'P' "
_cUpd += " WHEN SUBSTRING( PRD.CATALOGO, 1, 4) = 'KIT-' THEN 'K' "
_cUpd += " ELSE 'O' "
_cUpd += " END "
_cUpd += "END TIPO, "
_cUpd += "PRD.ID_SERIE, "
_cUpd += "SERIE.DESCRICAO, "
_cUpd += "CLASSIFICACAO, "
_cUpd += "REPLICATE( '0', 4  - LEN(CAST( PRD.ID_SERIE AS VARCHAR(3)))) + CAST( PRD.ID_SERIE AS VARCHAR(3)) GRUPO, "
_cUpd += "DIM.M2_VENDA "
_cUpd += "FROM ["+cBDGSTQ+"].[dbo].[PRODUTO] PRD "
_cUpd += "LEFT OUTER JOIN ["+cBDGSTQ+"].[dbo].[SERIE] SERIE ON PRD.ID_SERIE = SERIE.ID_SERIE "
_cUpd += "LEFT OUTER JOIN ["+cBDGSTQ+"].[dbo].[DIMENSIONAL] DIM ON PRD.ID_PRODUTO = DIM.ID_PRODUTO "
_cUpd += "LEFT OUTER JOIN ["+cBDGSTQ+"].[dbo].[CLASS_FISCAL] CLASS ON PRD.ID_CLASS_FISCAL = CLASS.ID_CLASS_FISCAL"
_cUpd += ") TST "
_cUpd += "WHERE B1_COD COLLATE SQL_Latin1_General_CP1_CI_AS = TST.CATALOGO"

_lRet := TCSqlExec( _cUpd )

Return( NIL )