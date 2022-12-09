#Include "Protheus.Ch"
#Include "TopConn.Ch"

//#Define Usado Chr(0)+Chr(0)+Chr(1)

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+--------------------+--------------------------------+------------------+||
||| Programa: CfmPesq  | Autor: Celso Ferrone Martins   | Data: 26/03/2015 |||
||+-----------+--------+--------------------------------+------------------+||
||| Descricao | Historico de Clientes                                      |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/
User Function CfmPesq(cUaCliente,cUaLoja)

Local aAreaSa1 := SA1->(GetArea())
Default cUaCliente := ""
Default cUaLoja    := ""


DbSelectArea("SA1") ; DbSetOrder(1)

If !SA1->(DbSeek(xFilial("SA1")+cUaCliente+cUaLoja))
	MsgAlert("Cliente nao encontrado, verifique o cliente!!!","Atencao !!!")
	SA1->(RestArea(aAreaSa1))
	Return()
EndIf

CfmTelaCli(cUaCliente,cUaLoja)

SA1->(RestArea(aAreaSa1))

Return()

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+----------------------+------------------------------+------------------+||
||| Programa: CfmTelaCli | Autor: Celso Ferrone Martins | Data: 26/03/2015 |||
||+-----------+----------+------------------------------+------------------+||
||| Descricao |  Historico de Clientes                                     |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/
Static Function CfmTelaCli(cUaCliente,cUaLoja)

Local aSize, aObjects, aInfo

Local bOk      := {|| oDlg:End()}
Local bCancel  := {|| oDlg:End()}
Local cTitle   := "Historico de Clientes"
Local oGetdb
Local nBoxSize := 0
Local aButtons := {{"IMPRESSAO",{|| Imprime() },               "Imprimir"} }

Private cEof := Chr(13) + Chr(10)

Private oDlg
Private aPosObj

Private oGetDados
Private aHeader := {}
Private aCols   := {}


// Filtro

Private oGCodCli
Private cGCodCli := cUaCliente//CriaVar("A1_COD", .F.)
Private oGLojCli
Private cGLojCli := cUaLoja//CriaVar("A1_LOJA", .F.)
Private oGNomCli
Private cGNomCli := Posicione("SA1",1,xFilial("SA1")+cUaCliente+cUaLoja,"A1_NOME")

Private oPesqu
Private cPesqu
Private aPesqu := { "Produtos Vendidos","Atendimentos","Atendimentos/Itens","Pedidos","Notas Fiscais","Financeiro" }

Private oBFiltro
Private lEdit     := .F.
Private lEditPesq := .T.
Private lEditVend := .F.
Private lEditComp := .F.

// Totais

Private oLTot1
Private nLTot1 := 0

Private oLTot2
Private nLTot2 := 0

Private oLTot3
Private nLTot3 := 0

Private oLTot4
Private nLTot4 := 0

Private oQtdReg
Private nQtdReg := 0

Private nColAnt := 0
Private cOrdAnt := "C"

/*
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � ExpA1 := MsAdvSize( [ ExpL1 ], [ ExpL2 ], [ ExpN1 ] )      ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpL1 -> Enchoicebar .T. ou .F.                            ���
���          � ExpL2 -> Retorna janela padrao siga                        ���
���          � ExpN1 -> Tamanho minimo ( altura )                         ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � ExpA1 -> Dimensoes da janela / area de trabalho            ���
���          �     1 -> Linha inicial area trabalho                       ���
���          �     2 -> Coluna inicial area trabalho                      ���
���          �     3 -> Linha final area trabalho                         ���
���          �     4 -> Coluna final area trabalho                        ���
���          �     5 -> Coluna final dialog                               ���
���          �     6 -> Linha final dialog                                ���
���          �     7 -> Linha inicial dialog                              ���
�������������������������������������������������������������������������Ĵ��
���Uso       � GENERICO                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

aSize    := MsAdvSize()
/*
If aSize[3] < 495  // for�o tamanho da tela para 1024 x 768
	aSize[3] := 495
	aSize[4] := 283
	aSize[5] := 990
	aSize[6] := 597
	aSize[7] := 17
EndIf
*/

aSize[3] -= 200
aSize[4] -= 100
aSize[5] -= 400
aSize[6] -= 200

aObjects := {	{ 100, 040, .T., .F. },;
				{ 100, 100, .T., .T. },;
				{ 100, 022, .T., .F. }}

aInfo    := { 	aSize[1],;
				aSize[2],;
				aSize[3],;
				aSize[4],;
				3,;
				3 }


/*
��������������������������������������������������������������������������ٱ�
���Sintaxe   � ExpA1 := MsObjSize( ExpA2, ExpA3, [ ExpL1 ], [ ExpL2 ] )   ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpA2 -> Area de trabalho                                  ���
���          � ExpA3 -> Definicoes de objetos                             ���
���          �    1 - Tamanho X    / 2 - Tamanho Y  / 3 - Dimensiona X    ���
���          �    4 - Dimensiona Y / 5 - Retorna dimensoes X e Y ao inves ���
���          �       de linha / coluna final                              ���
���          � ExpL1 -> Mantem a proporcao dos objetos                    ���
���          � ExpL2 -> Indica calculo de objetos horizontais             ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � ExpA1 -> Array com as posicoes de cada objeto              ���
���          �     1 -> Linha inicial                                     ���
���          �     2 -> Coluna inicial                                    ���
���          �     3 -> Linha final                                       ���
���          �     4 -> Coluna final Ou:                                  ���
���          �     Caso seja passado o elemento 5 de cada definicao de    ���
���          �     objetos como .t. o retorno sera:                       ���
���          �     3 -> Tamanho da dimensao X                             ���
���          �     4 -> Tamanho da dimensao Y                             ���
�������������������������������������������������������������������������Ĵ��
���Uso       � GENERICO                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/

aPosObj  := MsObjSize(aInfo, aObjects)

Define MsDialog oDlg Title cTitle From aSize[7], 0 To aSize[6], aSize[5] Of oMainWnd Pixel


@ aPosObj[1][1], aPosObj[1][2] To aPosObj[1][3], aPosObj[1][4] Prompt "Filtro" Of oDlg Pixel

@ aPosObj[1][1]+10, aPosObj[1][2]+004 Say "Pesquisa" Of oDlg Pixel
@ aPosObj[1][1]+08, aPosObj[1][2]+032 ComboBox oPesqu Var cPesqu Items aPesqu Size 70, 50 Valid /*BtnFiltro()*/  Of oDlg Pixel //When lEditPesq
@ aPosObj[1][1]+08, aPosObj[1][2]+130 Button oBFiltro Prompt "Filtrar" Size 42, 11 Action BtnFiltro() Of oDlg Pixel

@ aPosObj[1][1]+25, aPosObj[1][2]+004 Say "Cliente" Of oDlg Pixel
@ aPosObj[1][1]+23, aPosObj[1][2]+032 MSGet oGCodCli Var cGCodCli Valid Iif(Vazio() .or. ExistCpo("SA1", cGCodCli, 1), (cGNomCli := GetAdvFVal("SA1","A1_NOME",XFILIAL("SA1")+cGCodCli,1,""),.T.),.F.) Size 30, 09 F3 "SA1" When lEditVend Of oDlg Pixel
@ aPosObj[1][1]+23, aPosObj[1][2]+067 MSGet oGLojCli Var cGLojCli Size 008, 09 When lEditVend Of oDlg Pixel
@ aPosObj[1][1]+23, aPosObj[1][2]+084 MSGet oGNomCli Var cGNomCli Size 120, 09 When .F. Of oDlg Pixel


oGetDados := MsNewGetDados():New(aPosObj[2][1], aPosObj[2][2]+3, aPosObj[2][3]-3, aPosObj[2][4]-3, GD_INSERT+GD_DELETE+GD_UPDATE,,,,  ,, 99,,,, oDlg, aHeader, aCols)

oGetDados:lInsert := .F.
oGetDados:lDelete := .F.
oGetDados:lUpdate := .F.

nBoxSize := (aPosObj[3][4]-aPosObj[3][2])/11

Activate MsDialog oDlg On Init (EnchoiceBar(oDlg, bOk, bCancel,, aButtons), ButWhen(@oDlg)) Centered


Return(Nil)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �BtnFiltro �Autor  �Microsiga           � Data �  03/04/15   ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcal Botao Filtrar                                       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function BtnFiltro

Local _nI

If Empty(cPesqu)
	MsgAlert("Selecione um tipo de pesquisa","Atencao!!!")
	Return()
EndIf

Do Case
	
	Case lEditPesq
		
		lEdit     := .F.
//		lEditPesq := .F.
		lEditComp := .F.
		lEditVend := .F.

//		oBFiltro:cTitle := "Limpar"
		
		MsAguarde({|| FilAnual() }, "Aguarde", "Gerando Historicos ...", .F.)
		
		oGetDados := MsNewGetDados():New(aPosObj[2][1], aPosObj[2][2]+3, aPosObj[2][3]-3, aPosObj[2][4]-3, GD_INSERT+GD_DELETE+GD_UPDATE,,,,  ,, 99,,,, oDlg, aHeader, aCols)
		oGetDados:lInsert := .F.
		oGetDados:lDelete := .F.
		oGetDados:lUpdate := .F.
		oGetDados:lActive := .F.
		oGetDados:oBrowse:bHeaderClick := {|obj,col| fOrdTemp(obj,col)}
		
		oGetDados:Refresh()
		oGetDados:oBrowse:Refresh()
	Otherwise
		
//		oBFiltro:cTitle := "Filtrar"
//		lEditPesq := .T.
		
		oGetDados:aCols := {}
				
EndCase

Return(.T.)

/*
=============================================================================
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+---------------------+------------------------------+------------------+||
||| Programa: fOrdTemp  | Autor: Celso Ferrone Martins | Data: 17/04/2014 |||
||+-----------+---------+------------------------------+------------------+||
||| Descricao | Organiza MsSelect. Altera o indice de selecao             |||
||+-----------+-----------------------------------------------------------+||
||| Alteracao |                                                           |||
||+-----------+-----------------------------------------------------------+||
||| Uso       |                                                           |||
||+-----------+-----------------------------------------------------------+||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
=============================================================================
*/
Static Function fOrdTemp(obj, col)

Local aTmpCols  := {}
Local aTmpTotal := {}

If nColAnt != col
	nColAnt := col
	cOrdAnt := "C"
Else
	If cOrdAnt == "C"
		cOrdAnt := "D"
	Else
		cOrdAnt := "C"
	EndIf
EndIf

nPosTos := Len(oGetDados:ACOLS)

For nX := 1 To nPosTos -1
	aadd(aTmpCols,aClone(oGetDados:ACOLS[nX]))
Next nX

aAdd(aTmpTotal,aClone(oGetDados:ACOLS[nPosTos]))

oGetDados:ACOLS := aClone(aTmpCols)

If cOrdAnt == "C"
	oGetDados:ACOLS := aSort(oGetDados:ACOLS,,,{|x,y| x[col] < y[col]})
Else
	oGetDados:ACOLS := aSort(oGetDados:ACOLS,,,{|x,y| x[col] > y[col]})
EndIf

aAdd(oGetDados:ACOLS,aClone(aTmpTotal[1]))

oGetDados:oBrowse:Refresh(.T.)

Return()

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VQCONVEN  �Autor  �Microsiga           � Data �  03/04/15   ���
�������������������������������������������������������������������������͹��
���Desc.     � Realiza Filtro na base de dados conf. parametros           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function FilAnual()

Local cSQL := cSQLP := cSQLD := ""
Local nOpcRank
Local _nI := _nAux := 0
Local _aMeses    := {}
Local _dGDatDe
Local _dGetdtAte
Local nLenAnt
Local aEstru
Local cCod
Local nOpcPerc

Local _cCod    := ""
Local _cDesc   := ""
Local _cPicCod := ""
Local _cPicDes := ""
Local _nTGrp   := 0
Local _cQryCod := ""
Local _cQryDes := ""

Private	_cQryCod := "  "
Private	_cQryDes := "  "


aHeader := {}
aCpo    := {}
//aPesqu := { "Atendimentos","Pedidos","Notas Fiscais","Financeiro","Produtos Vendidos"}

If cPesqu == "Atendimentos/Itens"   

	Aadd(aCpo,"UA_NUM"    ) //01 
	Aadd(aCpo,"UA_STATUS" )
	Aadd(aCpo,"UA_EMISSAO") //03 
	Aadd(aCpo,"UB_PRODUTO" )//04  
	Aadd(aCpo,"B1_DESC" )	//05  	  
	Aadd(aCpo,"UB_VQ_QTDE" ) 	//06   	  
	Aadd(aCpo,"UB_VQ_VRUN") //11       	
	Aadd(aCpo,"UB_VQ_TABE") //08
	Aadd(aCpo,"UB_VQ_MOED") //09
	Aadd(aCpo,"E4_DESCRI" ) //02   
	Aadd(aCpo,"A4_NOME"   ) //13   
	Aadd(aCpo,"UA_VQ_FRET") //14 
	Aadd(aCpo,"UA_VQ_FCLI") //15 
	Aadd(aCpo,"UA_VQ_FVER") //16 
	Aadd(aCpo,"UA_VQ_FVAL")
	//Aadd(aCpo,"UA_VEND"   ) //04 
	Aadd(aCpo,"A3_NOME"   ) //05   
	

	
	CfmaHeader(aCpo,@aHeader)
	
	cQuery := ""
	cQuery += " SELECT                                      " + cEof
	For nX := 1 To Len(aHeader)
		If nX != 1
			cQuery += " , "
		EndIf
		cQuery += aHeader[nX][2]+ cEof
	Next nX
	cQuery += " FROM "+RetSqlName("SUA")+" SUA              " + cEof
	cQuery += "    INNER JOIN "+RetSqlName("SUB")+" SUB ON  " + cEof
	cQuery += "       SUB.D_E_L_E_T_ <> '*'                 " + cEof
	cQuery += "       AND UB_FILIAL = '"+xFilial("SUB")+"'  " + cEof
	cQuery += "       AND UB_NUM    = UA_NUM                " + cEof  
	cQuery += "    INNER JOIN "+RetSqlName("SB1")+" SB1 ON  " + cEof
	cQuery += "       SB1.D_E_L_E_T_ <> '*'  				" + cEof
	cQuery += "       AND B1_FILIAL = '"+xFilial("SB1")+"'  " + cEof
	cQuery += "       AND UB_PRODUTO = B1_COD				" + cEof
	cQuery += "    INNER JOIN "+RetSqlName("SA3")+" SA3 ON  " + cEof
	cQuery += "       SA3.D_E_L_E_T_ <> '*'                 " + cEof
	cQuery += "       AND A3_FILIAL = '"+xFilial("SA3")+"'  " + cEof
	cQuery += "       AND A3_COD    = UA_VEND               " + cEof
	cQuery += "    INNER JOIN "+RetSQLName("SE4")+" SE4 ON  " + cEof
	cQuery += "       SE4.D_E_L_E_T_ <> '*'                 " + cEof
	cQuery += "       AND E4_FILIAL = '"+xFilial("SE4")+"'  " + cEof
	cQuery += "       AND E4_CODIGO  = UA_CONDPG            " + cEof
	cQuery += "    INNER JOIN "+RetSQLName("SA4")+" SA4 ON  " + cEof
	cQuery += "       SA4.D_E_L_E_T_ <> '*'                 " + cEof
	cQuery += "       AND A4_FILIAL = '"+xFilial("SA4")+"'  " + cEof
	cQuery += "       AND A4_COD    = UA_TRANSP             " + cEof
	cQuery += " WHERE                                       " + cEof
	cQuery += "   SUA.D_E_L_E_T_ <> '*'                     " + cEof
	cQuery += "   AND SUA.UA_FILIAL  = '"+xFilial("SUA")+"' " + cEof
	cQuery += "   AND SUA.UA_CLIENTE = '"+cGCodCli+"'       " + cEof
	cQuery += "   AND SUA.UA_LOJA    = '"+cGLojCli+"'       " + cEof
EndIf

If cPesqu == "Atendimentos"

	Aadd(aCpo,"UA_NUM"    ) // 01
	Aadd(aCpo,"UA_CONDPG" ) // 02
	Aadd(aCpo,"E4_DESCRI" ) // 03  
	Aadd(aCpo,"UA_EMISSAO") // 04
	Aadd(aCpo,"UA_VEND"   ) // 05
	Aadd(aCpo,"A3_NOME"   ) // 06  
	Aadd(aCpo,"UA_TRANSP" ) // 07
	Aadd(aCpo,"A4_NOME"   ) // 08  
	Aadd(aCpo,"UA_VQ_FRET") // 09
	Aadd(aCpo,"UA_VQ_FCLI") // 10
	Aadd(aCpo,"UA_VQ_FVER") // 11
	Aadd(aCpo,"UA_VQ_FVAL") // 12
	Aadd(aCpo,"UA_VALMERC") // 13
	Aadd(aCpo,"UA_VLRLIQ" ) // 14
	Aadd(aCpo,"UA_MOEDA"  ) // 15
	Aadd(aCpo,"UA_STATUS" ) // 16

	CfmaHeader(aCpo,@aHeader)
	
	cQuery := ""
	cQuery += " SELECT                                      " + cEof
	For nX := 1 To Len(aHeader)
		If nX != 1
			cQuery += " , "
		EndIf
		cQuery += aHeader[nX][2]+ cEof
	Next nX
	cQuery += " FROM "+RetSqlName("SUA")+" SUA              " + cEof
	cQuery += "    INNER JOIN "+RetSqlName("SA3")+" SA3 ON  " + cEof
	cQuery += "       SA3.D_E_L_E_T_ <> '*'                 " + cEof
	cQuery += "       AND A3_FILIAL = '"+xFilial("SA3")+"'  " + cEof
	cQuery += "       AND A3_COD    = UA_VEND               " + cEof
	cQuery += "    INNER JOIN "+RetSQLName("SE4")+" SE4 ON  " + cEof
	cQuery += "       SE4.D_E_L_E_T_ <> '*'                 " + cEof
	cQuery += "       AND E4_FILIAL = '"+xFilial("SE4")+"'  " + cEof
	cQuery += "       AND E4_CODIGO  = UA_CONDPG            " + cEof
	cQuery += "    INNER JOIN "+RetSQLName("SA4")+" SA4 ON  " + cEof
	cQuery += "       SA4.D_E_L_E_T_ <> '*'                 " + cEof
	cQuery += "       AND A4_FILIAL = '"+xFilial("SA4")+"'  " + cEof
	cQuery += "       AND A4_COD    = UA_TRANSP             " + cEof
	cQuery += " WHERE                                       " + cEof
	cQuery += "   SUA.D_E_L_E_T_ <> '*'                     " + cEof
	cQuery += "   AND SUA.UA_FILIAL  = '"+xFilial("SUA")+"' " + cEof
	cQuery += "   AND SUA.UA_CLIENTE = '"+cGCodCli+"'       " + cEof
	cQuery += "   AND SUA.UA_LOJA    = '"+cGLojCli+"'       " + cEof

ElseIf cPesqu == "Pedidos"

	Aadd(aCpo,"C5_NUM"    ) // 01
	Aadd(aCpo,"C5_CONDPAG") // 02
	Aadd(aCpo,"E4_DESCRI" ) // 03  
	Aadd(aCpo,"C5_EMISSAO") // 04
	Aadd(aCpo,"C5_VEND1"  ) // 05
	Aadd(aCpo,"A3_NOME"   ) // 06   
	Aadd(aCpo,"C5_TRANSP" ) // 07
	Aadd(aCpo,"A4_NOME"   ) // 08   
	Aadd(aCpo,"C5_VQ_FRET") // 09
	Aadd(aCpo,"C5_VQ_FCLI") // 10
	Aadd(aCpo,"C5_VQ_FVER") // 11
	Aadd(aCpo,"C5_VQ_FVAL") // 12
	Aadd(aCpo,"C6_VALOR"  ) // 13
	Aadd(aCpo,"C5_MOEDA"  ) // 14
	Aadd(aCpo,"C5_NOTA"   ) // 15
	Aadd(aCpo,"C5_SERIE"  ) // 16

	CfmaHeader(aCpo,@aHeader)

	cQuery := ""
	cQuery += " SELECT                                      " + cEof
	For nX := 1 To Len(aHeader)
		If nX != 1
			cQuery += " , "
		EndIf
		If AllTrim(aHeader[nX][2]) == "C6_VALOR"
			cQuery += "Sum("+aHeader[nX][2]+") "+aHeader[nX][2] + cEof
		Else
			cQuery += aHeader[nX][2]+ cEof
		EndIf
	Next nX
	cQuery += " FROM "+RetSqlName("SC5")+" SC5              " + cEof
	cQuery += "    INNER JOIN "+RetSqlName("SC6")+" SC6 ON  " + cEof
	cQuery += "       SC6.D_E_L_E_T_ <> '*'                 " + cEof
	cQuery += "       AND C6_FILIAL = C5_FILIAL             " + cEof
	cQuery += "       AND C6_NUM    = C5_NUM                " + cEof
	cQuery += "    INNER JOIN "+RetSqlName("SA3")+" SA3 ON  " + cEof
	cQuery += "       SA3.D_E_L_E_T_ <> '*'                 " + cEof
	cQuery += "       AND A3_FILIAL = '"+xFilial("SA3")+"'  " + cEof
	cQuery += "       AND A3_COD    = C5_VEND1              " + cEof
	cQuery += "    INNER JOIN "+RetSQLName("SE4")+" SE4 ON  " + cEof
	cQuery += "       SE4.D_E_L_E_T_ <> '*'                 " + cEof
	cQuery += "       AND E4_FILIAL = '"+xFilial("SE4")+"'  " + cEof
	cQuery += "       AND E4_CODIGO  = C5_CONDPAG           " + cEof
	cQuery += "    INNER JOIN "+RetSQLName("SA4")+" SA4 ON  " + cEof
	cQuery += "       SA4.D_E_L_E_T_ <> '*'                 " + cEof
	cQuery += "       AND A4_FILIAL = '"+xFilial("SA4")+"'  " + cEof
	cQuery += "       AND A4_COD    = C5_TRANSP             " + cEof
	cQuery += " WHERE                                       " + cEof
	cQuery += "   SC5.D_E_L_E_T_ <> '*'                     " + cEof
	cQuery += "   AND SC5.C5_FILIAL  = '"+xFilial("SC5")+"' " + cEof
	cQuery += "   AND SC5.C5_CLIENTE = '"+cGCodCli+"'       " + cEof
	cQuery += "   AND SC5.C5_LOJACLI = '"+cGLojCli+"'       " + cEof
	cQuery += " GROUP BY                                    " + cEof
	For nX := 1 To Len(aHeader)
		If AllTrim(aHeader[nX][2]) != "C6_VALOR"
			If nX != 1
				cQuery += " , "
			EndIf
			cQuery += aHeader[nX][2]+ cEof
		EndIf
	Next nX

ElseIf cPesqu == "Notas Fiscais"


	Aadd(aCpo,"F2_DOC"    ) // 01
	Aadd(aCpo,"F2_SERIE"  ) // 02
	Aadd(aCpo,"F2_EMISSAO") // 03
	Aadd(aCpo,"E4_DESCRI" ) // 04  
	Aadd(aCpo,"F2_VEND1"  ) // 05
	Aadd(aCpo,"A3_NOME"   ) // 06  
	Aadd(aCpo,"F2_TRANSP" ) // 07
	Aadd(aCpo,"A4_NOME"   ) // 08  
	Aadd(aCpo,"F2_VQ_FRET") // 09
	Aadd(aCpo,"F2_VQ_FCLI") // 10
	Aadd(aCpo,"F2_VQ_FVER") // 11
	Aadd(aCpo,"F2_VQ_FVAL") // 12
	Aadd(aCpo,"F2_VALBRUT") // 13
	Aadd(aCpo,"F2_MOEDA"  ) // 14
	Aadd(aCpo,"F2_ESPECI1") // 15
	Aadd(aCpo,"F2_VOLUME1") // 16

	CfmaHeader(aCpo,@aHeader)
	
	cQuery := ""
	cQuery += " SELECT                                      " + cEof
	For nX := 1 To Len(aHeader)
		If nX != 1
			cQuery += " , "
		EndIf
		cQuery += aHeader[nX][2]+ cEof
	Next nX
	cQuery += " FROM "+RetSqlName("SF2")+" SF2              " + cEof
	cQuery += "    INNER JOIN "+RetSqlName("SA3")+" SA3 ON  " + cEof
	cQuery += "       SA3.D_E_L_E_T_ <> '*'                 " + cEof
	cQuery += "       AND A3_FILIAL = '"+xFilial("SA3")+"'  " + cEof
	cQuery += "       AND A3_COD    = F2_VEND1              " + cEof
	cQuery += "    INNER JOIN "+RetSQLName("SE4")+" SE4 ON  " + cEof
	cQuery += "       SE4.D_E_L_E_T_ <> '*'                 " + cEof
	cQuery += "       AND E4_FILIAL = '"+xFilial("SE4")+"'  " + cEof
	cQuery += "       AND E4_CODIGO  = F2_COND              " + cEof
	cQuery += "    INNER JOIN "+RetSQLName("SA4")+" SA4 ON  " + cEof
	cQuery += "       SA4.D_E_L_E_T_ <> '*'                 " + cEof
	cQuery += "       AND A4_FILIAL = '"+xFilial("SA4")+"'  " + cEof
	cQuery += "       AND A4_COD    = F2_TRANSP             " + cEof
	cQuery += " WHERE                                       " + cEof
	cQuery += "   SF2.D_E_L_E_T_ <> '*'                     " + cEof
	cQuery += "   AND SF2.F2_FILIAL  = '"+xFilial("SF2")+"' " + cEof
	cQuery += "   AND SF2.F2_CLIENTE = '"+cGCodCli+"'       " + cEof
	cQuery += "   AND SF2.F2_LOJA    = '"+cGLojCli+"'       " + cEof

ElseIf cPesqu == "Financeiro"  

	Aadd(aCpo,"E1_NUM"    ) // 01
	Aadd(aCpo,"E1_PREFIXO") // 02  
	Aadd(aCpo,"E1_PARCELA") // 03
	Aadd(aCpo,"E1_EMISSAO") // 04
	Aadd(aCpo,"E1_VENCREA") // 05
	Aadd(aCpo,"E1_BAIXA"  ) // 06
	Aadd(aCpo,"E1_VALOR"  ) // 07
	Aadd(aCpo,"E1_SALDO"  ) // 08
	Aadd(aCpo,"E1_ACRESC" ) // 09
	Aadd(aCpo,"E1_DESCON1") // 10
	Aadd(aCpo,"E1_NOMCLI")  // 11  
	Aadd(aCpo,"E1_VEND1"  ) // 12  
	Aadd(aCpo,"E1_TIPO"   ) // 13
	Aadd(aCpo,"E1_PORTADO") // 14
	Aadd(aCpo,"E1_NUMBCO" ) // 15
	Aadd(aCpo,"E1_HIST"   ) // 16

//	Aadd(aCpo,"A3_NOME"   ) //     
//	Aadd(aCpo,"E1_VQ_TPCO") //   

	CfmaHeader(aCpo,@aHeader)
	
	cQuery := ""
	cQuery += " SELECT                                      " + cEof
	For nX := 1 To Len(aHeader)
		If nX != 1
			cQuery += " , "
		EndIf
		cQuery += aHeader[nX][2]+ cEof
	Next nX
	cQuery += " FROM "+RetSqlName("SE1")+" SE1              " + cEof
	cQuery += "    INNER JOIN "+RetSqlName("SA3")+" SA3 ON  " + cEof
	cQuery += "       SA3.D_E_L_E_T_ <> '*'                 " + cEof
	cQuery += "       AND A3_FILIAL = '"+xFilial("SA3")+"'  " + cEof
	cQuery += "       AND A3_COD    = E1_VEND1              " + cEof
	cQuery += " WHERE                                       " + cEof
	cQuery += "   SE1.D_E_L_E_T_ <> '*'                     " + cEof
	cQuery += "   AND SE1.E1_FILIAL  = '"+xFilial("SE1")+"' " + cEof
	cQuery += "   AND SE1.E1_CLIENTE = '"+cGCodCli+"'       " + cEof
	cQuery += "   AND SE1.E1_LOJA    = '"+cGLojCli+"'       " + cEof

ElseIf cPesqu == "Produtos Vendidos"

	Aadd(aCpo,"D2_DOC"    ) // 01
	Aadd(aCpo,"D2_SERIE"  ) // 02
	Aadd(aCpo,"D2_EMISSAO") // 03
	Aadd(aCpo,"D2_PEDIDO" ) // 04
	Aadd(aCpo,"D2_COD"    ) // 05
	Aadd(aCpo,"B1_DESC"   ) // 06
	Aadd(aCpo,"B1_VQ_EMDE") // 07
	Aadd(aCpo,"D2_VQ_QTDE") // 08
	Aadd(aCpo,"D2_VQ_UM"  ) // 09
	Aadd(aCpo,"D2_VQ_UNIT") // 10
	Aadd(aCpo,"D2_TOTAL"  ) // 11
	Aadd(aCpo,"D2_VQ_TABE") // 12
	Aadd(aCpo,"E4_DESCRI")  // 13
	Aadd(aCpo,"D2_TES")     // 14
	Aadd(aCpo,"F2_VQ_FCLI") // 15  
	Aadd(aCpo,"F2_VQ_FVER") // 16  

	CfmaHeader(aCpo,@aHeader)
	
	cQuery := ""
	cQuery += " SELECT                                      " + cEof
	For nX := 1 To Len(aHeader)
		If nX != 1
			cQuery += " , "
		EndIf
		cQuery += aHeader[nX][2]+ cEof
	Next nX
	cQuery += " FROM "+RetSqlName("SD2")+" SD2              " + cEof

	cQuery += "    INNER JOIN "+RetSqlName("SB1")+" SB1 ON  " + cEof
	cQuery += "       SB1.D_E_L_E_T_ <> '*'                 " + cEof
	cQuery += "       AND B1_FILIAL  = '"+xFilial("SB1")+"' " + cEof
	cQuery += "       AND B1_COD = D2_COD                   " + cEof
	cQuery += "    INNER JOIN "+RetSqlName("SF2")+" SF2 ON  " + cEof
	cQuery += "       SF2.D_E_L_E_T_ <> '*'                 " + cEof
	cQuery += "       AND F2_FILIAL  = '"+xFilial("SF2")+"' " + cEof
	cQuery += "       AND F2_DOC     = D2_DOC               " + cEof
	cQuery += "       AND F2_SERIE   = D2_SERIE             " + cEof
	cQuery += "    INNER JOIN "+RetSQLName("SE4")+" SE4 ON  " + cEof
	cQuery += "       SE4.D_E_L_E_T_ <> '*'                 " + cEof
	cQuery += "       AND E4_FILIAL = '"+xFilial("SE4")+"'  " + cEof
	cQuery += "       AND E4_CODIGO  = F2_COND              " + cEof
//	cQuery += "    INNER JOIN "+RetSqlName("SF4")+" SF4 ON  " + cEof
//	cQuery += "       SF4.D_E_L_E_T_ <> '*'                 " + cEof
//	cQuery += "       AND F4_FILIAL  = '"+xFilial("SF4")+"' " + cEof
//	cQuery += "       AND F4_CODIGO = D2_TES                " + cEof
//	cQuery += "       AND F4_ESTOQUE = 'S'                  " + cEof
	cQuery += " WHERE                                       " + cEof
	cQuery += "   SD2.D_E_L_E_T_ <> '*'                     " + cEof
	cQuery += "   AND SD2.D2_FILIAL  = '"+xFilial("SD2")+"' " + cEof
	cQuery += "   AND SD2.D2_CLIENTE = '"+cGCodCli+"'       " + cEof
	cQuery += "   AND SD2.D2_LOJA    = '"+cGLojCli+"'       " + cEof
  
EndIf

/*
If "Administrador"$cUserName .And. !EECVIEW(@cQuery)
	Return()
EndIf
*/

cQuery := ChangeQuery(cQuery)

TcQuery cQuery New ALias "TABTMP"

For nX := 1 To Len(aHeader)
	If aHeader[nX][8] == "D"
		TcSetField("TABTMP",aHeader[nX][2],"D",08,0)
	EndIf
Next nX


// aCols
aCols := {}
Dbselectarea("TABTMP")
While TABTMP->(!Eof())
	
	aAdd( aCols, { ;
	&("TABTMP->"+aCpo[01]),;
	&("TABTMP->"+aCpo[02]),;
	&("TABTMP->"+aCpo[03]),;
	&("TABTMP->"+aCpo[04]),;
	&("TABTMP->"+aCpo[05]),;
	&("TABTMP->"+aCpo[06]),;
	&("TABTMP->"+aCpo[07]),;
	&("TABTMP->"+aCpo[08]),;
	&("TABTMP->"+aCpo[09]),;
	&("TABTMP->"+aCpo[10]),;
	&("TABTMP->"+aCpo[11]),;
	&("TABTMP->"+aCpo[12]),;
	&("TABTMP->"+aCpo[13]),;
	&("TABTMP->"+aCpo[14]),;
	&("TABTMP->"+aCpo[15]),;
	&("TABTMP->"+aCpo[16]),;
	.F. } )

	TABTMP->(DbSkip())
EndDo


TABTMP->(dbCloseArea())


Return(Nil)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VQCONVEN  �Autor  �Microsiga           � Data �  03/04/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Imprime()

//��������������������������������������������������������������Ŀ
//� Define Variaveis                                             �
//����������������������������������������������������������������
LOCAL cDesc1   := "Relatorio de Vendas"

PRIVATE nomeprog := "VQCONVEN"
PRIVATE titulo   := "Relatorio de Vendas" 
Private aFiltros := {}

CfmVenTRep( Titulo , cDesc1 , nomeprog , aFiltros )

Return .T.


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VQCONVEN  �Autor  �Microsiga           � Data �  03/04/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �  Desabilita / Habilita botao da barra                      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

static function ButWhen(_oObj)

Local _nPosImp

If ( _nPosImp := AScan(_oObj:aControls, { |x| x:cTitle == "Imprimir" } ) ) > 0
	_oObj:aControls[_nPosImp]:lActive := !lEdit
	_oObj:aControls[_nPosImp]:bWhen   := { || !lEdit }
EndIf

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CfmVenTRep�Autor  �Microsiga           � Data �  03/04/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �  Imprime relatorio TReport com base na Acols               ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function CfmVenTRep( cTitulo , cDescri , cReport , aFilt , aHeaderx , aColsx )

Local   oReport
Local   oSection1
Default cDescri   := ""
Default cReport   := "Relatorio de Vendas"
Default cTitulo   := "Relatorio de Vendas"
Default aFilt     := {}
Private aFilter   := aFilt


If ValType( aHeaderx ) = "A"
	Private aHeader := aHeaderx
EndIf
If ValType( aColsx ) = "A"
	Private aCols := aColsx
EndIf

//�������������������������������������������Ŀ
//�Se nao passou os parametros para fun��o e  �
//�nao existe 'aHeader' ou 'aCols' declarados.�
//���������������������������������������������
If Type( "aHeader" ) = "U"
	Private aHeader := {}
EndIf
If Type( "aCols" ) = "U"
	Private aCols := {}
EndIf

Begin Sequence

//���������������������
//� Cria objeto TReport�
//���������������������
oReport  := TReport():New( cReport, cTitulo ,, { |oReport| ReportPrint( oReport ) } , cDescri )

oReport:SetLandscape()

//������������������������
//�Cria se��o do Relat�rio�
//������������������������
oSection1 := TRSection():New( oReport, "Parametros do Relatorio"  )
oSection2 := TRSection():New( oReport, "Campos do Relatorio"  )

SX3->( DbSetOrder( 2 ) )

//�����������������������������������������������������Ŀ
//� Define c�lulas que ser�o carregadas na impress�o�
//�������������������������������������������������������
For i := 1 To Len( aHeader )
	If !Empty( aHeader[ i ][ 1 ] )
		TRCell():New( oSection2                     ,;
		aHeader[ i ][ 2 ]              ,;
		/* cAlias */                   ,;
		aHeader[ i ][ 1 ] /*Titulo*/   ,;
		aHeader[ i ][ 3 ] /*Picture*/  ,;
		aHeader[ i ][ 4 ] /*Tamanho*/  ,;
		/*lPixel*/   ,;
		/*CodeBlock*/                   ;
		)
	EndIf
Next


TRCell():New( oSection1 , "PARAMETROS" ,, "Parametros do Relatorio" , "" , 200 )

//���������������������������������������Ŀ
//�Define o cabecalho da secao como padrao�
//�����������������������������������������
oSection1:SetHeaderPage()

//�������������������������������������0�
//�Define em 'Arquivo' a sa�da default.�
//�������������������������������������0�
oReport:nDevice := 1

oReport:PrintDialog()


End Sequence

Return( cReport )

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ReportPrint  �Autor  �Microsiga        � Data �  03/04/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �  Funcao auxiliar para impressao do relatorio               ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


Static Function ReportPrint( oReport )

Local oSection1 := oReport:Section( 1 )
Local oSection2 := oReport:Section( 2 )
Local i
Local j
Local cFilter   := ""
Local lExcel    := oReport:nDevice = 4
Local xValue
Local nPos

oReport:SetMeter( Len( aCols ) )
//��������������������������������������������������������������Ŀ
//�Se o destino nao for para uma planilha, imprime se��o de parametros.�
//����������������������������������������������������������������
If !lExcel
	For i := 1 To Len( aFilter )
		If Empty( aFilter[ i ][ 2 ] )
			Loop
		EndIf
		If !Empty( cFilter )
			cFilter += " <> "
		EndIf
		cFilter += aFilter[ i ][ 1 ] + ":" + aFilter[ i ][ 2 ]
	Next
	If !Empty( cFilter )
		oSection1:Init()
		oSection1:Cell( "PARAMETROS" ):SetValue( cFilter )
		oSection1:PrintLine()
		oSection1:Finish()
	EndIf
EndIf

//��������������������������������������������������������������������������Ŀ
//�Desabilita o cabe�alho da se��o de parametros, para imprimir somente na�
//�primeira pagina.                                        �
//����������������������������������������������������������������������������
oSection1:SetHeaderSection( .F. )

//��������������������������������������������
//�Inicializa impressao da se��o do relatorio.�
//��������������������������������������������
oSection2:Init()
For i := 1 To Len( aCols )
	If oReport:Cancel()
		Exit
	EndIf
	oReport:IncMeter()
	For j := 1 To Len( oSection2:aCell )
		xValue := GdFieldGet( oSection2:aCell[ j ]:cName , i )
		If !Empty( oSection2:aCell[ j ]:aCBox ) .And. !Empty( xValue )
			If ( nPos := Ascan( oSection2:aCell[ j ]:aCBox , { | x | x[ 1 ] == xValue } ) ) > 0
				oSection2:aCell[ j ]:nSize := Len( oSection2:aCell[ j ]:aCBox[ nPos ][ 2 ] )
				oSection2:Cell( oSection2:aCell[ j ]:cName ):SetValue( oSection2:aCell[ j ]:aCBox[ nPos ][ 2 ] )
			EndIf
		Else
			oSection2:Cell( oSection2:aCell[ j ]:cName ):SetValue( xValue )
			
		EndIf
	Next
	oSection2:PrintLine()
	
	//�����������������������������������������������������������������Ŀ
	//�Quando imprimir em planilha, mostrar o cabe�alho somente uma vez.�
	//�������������������������������������������������������������������
	If lExcel .And. i = 1
		oSection2:SetHeaderSection( .F. )
	EndIf
Next
oSection2:Finish()

Return

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+----------------------+------------------------------+------------------+||
||| Programa: CfmaHeader | Autor: Celso Ferrone Martins | Data: 27/03/2015 |||
||+-----------+----------+------------------------------+------------------+||
||| Descricao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/
Static Function CfmaHeader(_aCpo,_aHeader)

aAreaSx3 := SX3->(GetArea())
DbSelectArea("SX3") ; DbSetOrder(2)
For nX := 1 To Len(_aCpo)
	If SX3->(DbSeek(_aCpo[nX]))
		Aadd(_aHeader,{SX3->X3_TITULO,SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,"",SX3->X3_USADO,SX3->X3_TIPO,,""})
	EndIf
Next nX
SX3->(RestArea(aAreaSx3))
Return()