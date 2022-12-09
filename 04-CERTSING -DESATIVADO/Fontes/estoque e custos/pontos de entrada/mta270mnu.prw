#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MTA270MNU �Autor  �Microsiga           � Data �  12/23/09   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User function MTA270MNU()

Aadd( aRotina, {"Zera Saldo","U_A270Zera", 0, 3, Nil, Nil} )

Return(.T.)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NOVO2     �Autor  �Microsiga           � Data �  12/23/09   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function A270Zera()

Local cPerg		:= "EST270"
Local aSays		:= {}
Local aButtons	:= {}

Aadd( aSays, "GERA INVENT�RIO PARA ZERAR O ESTOQUE." )
Aadd( aSays, "" )
Aadd( aSays, "Esta rotina tem o objetivo de criar movimentos de envent�rio para zerar o estoque." )
Aadd( aSays, "Selecione os par�metros para indicar o tipo de movimento a ser gerado." )
Aadd( aSays, "Ao clicar no OK o sistema ir� gerar a movimenta��o de invent�rio." )

Aadd(aButtons, { 5,.T.,{|| Pergunte(cPerg, .T. ) } } )
Aadd(aButtons, { 1,.T.,{|| Processa( {|| A270Proc(Mv_Par01) }, "Gerando Invent�rio..."), FechaBatch() }} )
Aadd(aButtons, { 2,.T.,{|| FechaBatch() }} )

AjustaSX1(cPerg)
Pergunte(cPerg, .F. )

FormBatch( cCadastro, aSays, aButtons )

Return(.T.)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MTA270MNU �Autor  �Microsiga           � Data �  12/23/09   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function A270Proc()

Local nQtd		:= 0
Local cQuery	:= ""

cQuery	+=	" SELECT B2_COD, B2_LOCAL, B1_TIPO "
cQuery	+=	" FROM   " + RetSQLName("SB2") + " SB2, " + RetSQLName("SB1") + " SB1 "
cQuery	+=	" WHERE  SB2.B2_FILIAL = '" + xFilial("SB2") + "' AND "
cQuery	+=	"        SB2.B2_COD BETWEEN '" + Mv_Par01 + "' AND '" + Mv_Par02 + "' AND "
cQuery	+=	"        SB2.B2_LOCAL BETWEEN '" + Mv_Par09 + "' AND '" + Mv_Par10 + "' AND "
cQuery	+=	"        SB2.D_E_L_E_T_ = ' ' AND "
cQuery	+=	"        SB1.B1_FILIAL = '" + xFilial("SB1") + "' AND "
cQuery	+=	"        SB1.B1_COD = SB2.B2_COD AND "
cQuery	+=	"        SB1.B1_GRUPO BETWEEN '" + Mv_Par03 + "' AND '" + Mv_Par04 + "' AND "
cQuery	+=	"        SB1.B1_TIPO BETWEEN '" + Mv_Par05 + "' AND '" + Mv_Par06 + "' AND "
cQuery	+=	"        SB1.D_E_L_E_T_ = ' ' "
PLSQuery( cQuery, "SB2TMP" )

ProcRegua( SB2TMP->( RecCount() ) )

While SB2TMP->( !Eof() )
	
	IncProc("Total processados " + AllTrim(Str(nQtd++)))
	ProcessMessage()
	
	SB7->( DbSetOrder(1) )		// B7_FILIAL+DTOS(B7_DATA)+B7_COD+B7_LOCAL+B7_LOCALIZ+B7_NUMSERI+B7_LOTECTL+B7_NUMLOTE+B7_CONTAGE
	If SB7->( MsSeek( xFilial("SB7")+DtoS(Mv_Par07)+SB2TMP->B2_COD+SB2TMP->B2_LOCAL ) )
		SB7->( RecLock( "SB7", .F. ) )
	Else
		SB7->( RecLock( "SB7", .T. ) )
		SB7->B7_FILIAL	:= xFilial("SB7")
		SB7->B7_DATA	:= Mv_Par07
		SB7->B7_COD		:= SB2TMP->B2_COD
		SB7->B7_LOCAL	:= SB2TMP->B2_LOCAL
	Endif
	
	SB7->B7_TIPO	:= SB2TMP->B1_TIPO
	SB7->B7_DOC		:= Mv_Par08
	SB7->B7_QUANT	:= 0
	SB7->B7_QTSEGUM	:= 0
	SB7->B7_LOTECTL	:= ""
	SB7->B7_NUMLOTE	:= ""
	SB7->B7_DTVALID	:= Mv_Par07
	SB7->B7_LOCALIZ	:= ""
	SB7->B7_NUMSERI	:= ""
	SB7->B7_TPESTR	:= ""
	SB7->B7_OK		:= ""
	SB7->B7_ESCOLHA	:= ""
	SB7->B7_CONTAGE	:= ""
	SB7->B7_NUMDOC	:= ""
	SB7->B7_SERIE	:= ""
	SB7->B7_FORNECE	:= ""
	SB7->B7_LOJA	:= ""
	SB7->( MsUnLock() )
	
	SB2TMP->( DbSkip() )
End
SB2TMP->( DbCloseArea() )

Return(.T.)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MTA270MNU �Autor  �Microsiga           � Data �  12/23/09   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function AjustaSX1(cPerg)

Local aRegs	:=	{}

Aadd(aRegs,{cPerg,"01","Produto De",			"","","MV_CH1","C",15,0,0,"G","","Mv_Par01","","","","","","","","","","","","","","","","","","","","","","","","","SB1","","","","",""})
Aadd(aRegs,{cPerg,"02","Produto At�",			"","","MV_CH2","C",15,0,0,"G","","Mv_Par02","","","","","","","","","","","","","","","","","","","","","","","","","SB1","","","","",""})
Aadd(aRegs,{cPerg,"03","Grupo de Produtos De ",	"","","MV_CH3","C",04,0,0,"G","","Mv_Par03","","","","","","","","","","","","","","","","","","","","","","","","","SBM","","","","",""})
Aadd(aRegs,{cPerg,"04","Grupo de Produtos At�",	"","","MV_CH4","C",04,0,0,"G","","Mv_Par04","","","","","","","","","","","","","","","","","","","","","","","","","SBM","","","","",""})
Aadd(aRegs,{cPerg,"05","Tipo de Material De",	"","","MV_CH5","C",02,0,0,"G","","Mv_Par05","","","","","","","","","","","","","","","","","","","","","","","","","02","","","","",""})
Aadd(aRegs,{cPerg,"06","Tipo de Material At�",	"","","MV_CH6","C",02,0,0,"G","","Mv_Par06","","","","","","","","","","","","","","","","","","","","","","","","","02","","","","",""})
Aadd(aRegs,{cPerg,"07","Data do Movimento",		"","","MV_CH7","D",08,0,0,"G","","Mv_Par07","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"08","Documento",				"","","MV_CH8","C",09,0,0,"G","","Mv_Par08","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"09","Armazem De",			"","","MV_CH9","C",02,0,0,"G","","Mv_Par09","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"10","Armazem At�",			"","","MV_CHA","C",02,0,0,"G","","Mv_Par10","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

If Len(aRegs) > 0
	PlsVldPerg( aRegs )
Endif

Return(.T.)
