#INCLUDE "topconn.ch"
#include "protheus.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � RQUA001  � Autor � Yale Amorim Sousa  � Data � 28/02/2010  ���
�������������������������������������������������������������������������͹��
���Descricao � RELATORIO DE INDICADORES                                   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � LMD - DEPARTAMENTO DE QUALIDADE                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function RQUA001
	Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
	Local cDesc2         := "de acordo com os parametros informados pelo usuario."
	Local cDesc3         := ""
	Local cPict          := ""
	Local titulo         := "Relatorio de Indicadores PRODIR"
	Local Cabec1         := ""
	Local Cabec2         := ""
	Local imprime        := .T.
	Local aOrd           := {}

	//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "RQUA001" , __cUserID )

	Private cPerg        := "RQUA001"
	Private lEnd         := .F.
	Private lAbortPrint  := .F.
	Private CbTxt        := ""
	Private limite       := 80
	Private tamanho      := "P" // "P"
	Private nomeprog     := "RQUA001" // Coloque aqui o nome do programa para impressao no cabecalho
	Private nTipo        := 18
	Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
	Private nLastKey     := 0
	Private cbcont       := 00
	Private CONTFL       := 01
	Private m_pag        := 01
	Private wnrel        := "RQUA001" // Coloque aqui o nome do arquivo usado para impressao em disco
	Private aIndicadores := {}

	//���������������������������
	//�Ajusta grupo de perguntas�
	//���������������������������

	ValidPerg( cPerg )
	Pergunte(cPerg,.f.)

	//���������������������������������������������������������������������Ŀ
	//� Monta a interface padrao com o usuario...                           �
	//�����������������������������������������������������������������������
	wnrel := SetPrint("SC5",NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

	If nLastKey == 27
		Return
	Endif

	SetDefault(aReturn,"SC5")

	If nLastKey == 27
		Return
	Endif

	nTipo := If(aReturn[4]==1,15,18)

	//���������������������������������������������������������������������Ŀ
	//� Processamento. Geracao de Query com os dados a imprimir             �
	//�����������������������������������������������������������������������
	Processa({|| RunQuery() },Titulo)

	If Len( aIndicadores ) == 0
		MsgAlert( "N�o h� dados a serem impresso. Verifique os par�metros de impress�o." )
		return
	EndIf

	RptStatus({|| RunReport( Titulo ) },Titulo )

Return Nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RunQuery1 �Autor  � Yale Amorim Sousa  � Data � 16/03/2010  ���
�������������������������������������������������������������������������͹��
���Desc.     � Processa a Query das Informacoes                           ���
���          �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function RunQuery()

	AAdd( aIndicadores, QtdTransport() )
	AAdd( aIndicadores, TranspCIF() )
	AAdd( aIndicadores, TranspFOB() )
	AAdd( aIndicadores, QtdEmbarques() )
	AAdd( aIndicadores, EmbarqCIF() )
	AAdd( aIndicadores, EmbarqFOB() )

return

Static Function QtdTransport()
	Local aInd := {}
	Local cQuery := "select count(*) as QTD from (select C5_TRANSP, C5_TPFRETE, count(1) from " + RetSQLName("SC5") + " sc5"
	cQuery += " JOIN " + RetSQLName("SF2") + " sf2 on F2_DOC = C5_NOTA and sf2.D_E_L_E_T_ = ' ' and C5_TPFRETE in ('C','F')"
	cQuery += " where F2_EMISSAO BETWEEN '" + DtoS(mv_par01) + "' and '" + DtoS(mv_par02) + "' and "
	cQuery += " sc5.D_E_L_E_T_ = ' ' and"
	cQuery += " F2_TRANSP <> ' '"
	cQuery += " group by C5_TRANSP, C5_TPFRETE)"

	If Select( "TRB1" ) > 0
		TRB1->( dbCloseArea() )
	EndIf

	TCQUERY cQuery ALIAS "TRB1" NEW

	AAdd( aInd, "Quantidade de transportadoras" )
	AAdd( aInd, Transform( TRB1->QTD, "99999" ) )
	AAdd( aInd, TRB1->QTD )

	dbSelectArea("TRB1")
	dbCloseArea()
return aInd

Static Function TranspCIF()
	Local aInd := {}
	Local cQuery := "select count(*) as QTD from (select C5_TRANSP, C5_TPFRETE, count(1) from " + RetSQLName("SC5") + " sc5"
	cQuery += " JOIN " + RetSQLName("SF2") + " sf2 on F2_DOC = C5_NOTA and sf2.D_E_L_E_T_ = ' ' and C5_TPFRETE = 'C'"
	cQuery += " where F2_EMISSAO BETWEEN '" + DtoS(mv_par01) + "' and '" + DtoS(mv_par02) + "' and "
	cQuery += " sc5.D_E_L_E_T_ = ' ' and"
	cQuery += " F2_TRANSP <> ' '"
	cQuery += " group by C5_TRANSP, C5_TPFRETE)"

	If Select( "TRB1" ) > 0
		TRB1->( dbCloseArea() )
	EndIf

	TCQUERY cQuery ALIAS "TRB1" NEW

	AAdd( aInd, "Quantidade de transportadoras NF tipo CIF" )
	AAdd( aInd, Transform( TRB1->QTD, "99999" ) + " (" + Transform( (TRB1->QTD * 100) / aIndicadores[1,3], "999.9" ) + "%)" )
	AAdd( aInd, TRB1->QTD )

	dbSelectArea("TRB1")
	dbCloseArea()
return aInd

Static Function TranspFOB()
	Local aInd := {}
	Local cQuery := "select count(*) as QTD from (select C5_TRANSP, C5_TPFRETE, count(1) from " + RetSQLName("SC5") + " sc5"
	cQuery += " JOIN " + RetSQLName("SF2") + " sf2 on F2_DOC = C5_NOTA and sf2.D_E_L_E_T_ = ' ' and C5_TPFRETE = 'F'"
	cQuery += " where F2_EMISSAO BETWEEN '" + DtoS(mv_par01) + "' and '" + DtoS(mv_par02) + "' and "
	cQuery += " sc5.D_E_L_E_T_ = ' ' and"
	cQuery += " F2_TRANSP <> ' '"
	cQuery += " group by C5_TRANSP, C5_TPFRETE)"

	If Select( "TRB1" ) > 0
		TRB1->( dbCloseArea() )
	EndIf

	TCQUERY cQuery ALIAS "TRB1" NEW

	AAdd( aInd, "Quantidade de transportadoras NF tipo FOB" )
	AAdd( aInd, Transform( TRB1->QTD, "99999" ) + " (" + Transform( (TRB1->QTD * 100) / aIndicadores[1,3], "999.9" ) + "%)" )
	AAdd( aInd, TRB1->QTD )

	dbSelectArea("TRB1")
	dbCloseArea()
return aInd

Static Function QtdEmbarques()
	Local aInd := {}
	Local cQuery := "select count(*) as QTD from (select F2_DOC, C5_TPFRETE, count(1) from " + RetSQLName("SF2") + " sf2"
	cQuery += " JOIN " + RetSQLName("SC5") + " sc5 on F2_DOC = C5_NOTA and sc5.D_E_L_E_T_ = ' ' and C5_TPFRETE in ('C','F')"
	cQuery += " where F2_EMISSAO BETWEEN '" + DtoS(mv_par01) + "' and '" + DtoS(mv_par02) + "' and "
	cQuery += " sf2.D_E_L_E_T_ = ' ' and"
	cQuery += " F2_TRANSP <> ' '"
	cQuery += " group by F2_DOC, C5_TPFRETE)"

	If Select( "TRB1" ) > 0
		TRB1->( dbCloseArea() )
	EndIf

	TCQUERY cQuery ALIAS "TRB1" NEW

	AAdd( aInd, "Quantidade de Embarques" )
	AAdd( aInd, Transform( TRB1->QTD, "99999" ) )
	AAdd( aInd, TRB1->QTD )

	dbSelectArea("TRB1")
	dbCloseArea()
return aInd

Static Function EmbarqCIF()
	Local aInd := {}
	Local cQuery := "select count(*) as QTD from (select F2_DOC, C5_TPFRETE, count(1) from " + RetSQLName("SF2") + " sf2"
	cQuery += " JOIN " + RetSQLName("SC5") + " sc5 on F2_DOC = C5_NOTA and sc5.D_E_L_E_T_ = ' ' and C5_TPFRETE = 'C'"
	cQuery += " where F2_EMISSAO BETWEEN '" + DtoS(mv_par01) + "' and '" + DtoS(mv_par02) + "' and "
	cQuery += " sf2.D_E_L_E_T_ = ' ' and"
	cQuery += " F2_TRANSP <> ' '"
	cQuery += " group by F2_DOC, C5_TPFRETE)"

	If Select( "TRB1" ) > 0
		TRB1->( dbCloseArea() )
	EndIf

	TCQUERY cQuery ALIAS "TRB1" NEW

	AAdd( aInd, "Quantidade de Embarques NF tipo CIF" )
	AAdd( aInd, Transform( TRB1->QTD, "99999" ) + " (" + Transform( (TRB1->QTD * 100) / aIndicadores[4,3], "999.9" ) + "%)" )
	AAdd( aInd, TRB1->QTD )

	dbSelectArea("TRB1")
	dbCloseArea()
return aInd

Static Function EmbarqFOB()
	Local aInd := {}
	Local cQuery := "select count(*) as QTD from (select F2_DOC, C5_TPFRETE, count(1) from " + RetSQLName("SF2") + " sf2"
	cQuery += " JOIN " + RetSQLName("SC5") + " sc5 on F2_DOC = C5_NOTA and sc5.D_E_L_E_T_ = ' ' and C5_TPFRETE = 'F'"
	cQuery += " where F2_EMISSAO BETWEEN '" + DtoS(mv_par01) + "' and '" + DtoS(mv_par02) + "' and "
	cQuery += " sf2.D_E_L_E_T_ = ' ' and"
	cQuery += " F2_TRANSP <> ' '"
	cQuery += " group by F2_DOC, C5_TPFRETE)"

	If Select( "TRB1" ) > 0
		TRB1->( dbCloseArea() )
	EndIf

	TCQUERY cQuery ALIAS "TRB1" NEW

	AAdd( aInd, "Quantidade de Embarques NF tipo FOB" )
	AAdd( aInd, Transform( TRB1->QTD, "99999" ) + " (" + Transform( (TRB1->QTD * 100) / aIndicadores[4,3], "999.9" ) + "%)" )
	AAdd( aInd, TRB1->QTD )

	dbSelectArea("TRB1")
	dbCloseArea()
return aInd

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �RunReport� Autor � Yale Amorim Sousa � Data � 07/05/09   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function RunReport(Titulo)
	Local nC			:= 0
	Local nLin      	:= 80
	Local lImpCabec 	:= .t.
	Local dData			:= CToD("/")
	Local cQuery 		:= ""		                                                 
	Local cCabec1		:= "Indicadores                                                       Valor"
	Local cCabec2		:= ""

	For nC := 1 to Len( aIndicadores )

		If ( nLin > 55 )
			Cabec(Titulo,cCabec1,cCabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		EndIf

		@nLin++,0 PSAY Left( aIndicadores[nC,1] + Replicate( ".", 60 ), 60 ) + ": " + aIndicadores[nC,2]
	Next

	SET DEVICE TO SCREEN

	//���������������������������������������������������������������������Ŀ
	//� Se impressao em disco, chama o gerenciador de impressao...          �
	//�����������������������������������������������������������������������

	If aReturn[5]==1
		dbCommitAll()
		SET PRINTER TO
		OurSpool(wnrel)
	Endif

	MS_FLUSH()

Return Nil