#include "ap5mail.ch"
#INCLUDE 'FONT.CH'
#include "sigawin.ch"
#INCLUDE "rwmake.CH"
#INCLUDE "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLASP002   บAutor  ณFabio Jadao Caires  บ Data ณ  05/16/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Esta rotina tem por objetivo tratar a leitura de codigo de บฑฑ
ฑฑบ          ณ barras dos produtos gerando uma etiqueta de embalagem para บฑฑ
ฑฑบ          ณ quando da entrega nas filiais ou franquias, haja a possibi-บฑฑ
ฑฑบ          ณ lidade de executar a leitura das etiquetas e realizar a    บฑฑ
ฑฑบ          ณ entrada dos produtos referentes a embalagem.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Laselva Bookstore                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LS_ROMA()
///////////////////////

Local nI 			:= 0
Local nCnt 			:= 0
Local cIndPA6 		:= " "
Local aCaixa 		:= {}
Local nSoma 		:= 0
Local cFilter		:= " "
Local bFilFilter 	:= {}
Local aIndexPA6		:= {}
Local cAlias 		:= " "
Local aCposBrw 		:= {}
Private aCposPA6 	:= {}
Private aRotina  	:= {}
Private lRefresh 	:= .T.
Private cQuery 		:= " "
Private aCores 		:= {}
Private cCadastro 	:= "Romaneios"
Private cPerg  		:= "LASE02"
Private cNmFilial 	:= " "
_cServerIni 		:= GetAdv97()
_cSecao  			:= "TCP"
_cChave  			:= "Port"
_nPadrao 			:= 0
_cPorta  			:= NToC(GetPvProfileInt(_cSecao, _cChave, _nPadrao, _cServerIni), 10)

_cNota 				:= ""
_cSerie 			:= ""

If !Pergunte(cPerg,.T.)
	Return
Endif

DbSelectArea("PA6")
DbSetOrder(1)

cQuery := "SELECT  "
cQuery += "PA6.PA6_FILIAL, "
cQuery += "PA6.PA6_STATUS, "
cQuery += "PA6.PA6_DESCST, "
cQuery += "PA6.PA6_NUMROM, "
cQuery += "PA6.PA6_LOJA, "
cQuery += "PA6.PA6_DTROM, "
cQuery += "PA6.PA6_CARGA, "
cQuery += "PA6.PA6_NFE, "
cQuery += "PA6.PA6_NFS, "
cQuery += "PA6.PA6_VOL, "
cQuery += "PA6.PA6_FILORI, "
cQuery += "PA6.PA6_FILDES, "
cQuery += "PA6.PA6_USER, "
cQuery += "PA6.PA6_SERIE, "
cQuery += "F2_EMISSAO PA6_DATNFS, "
//cQuery += "PA6_DATNFE, "
cQuery += "F1_DTDIGIT PA6_DATNFE, "
cQuery += "A1_NREDUZ PA6_DESTIN "

cQuery += " FROM " + RetSqlName("PA6") + " PA6 (NOLOCK)"

cQuery += " LEFT JOIN " + RetSqlName("SA1") + " SA1 (NOLOCK)"
cQuery += " 									ON A1_COD < '000009'"
cQuery += " 									AND A1_LOJA = PA6_FILDES"
cQuery += " 									AND SA1.D_E_L_E_T_ = '' "
cQuery += " 									AND A1_MSBLQL <> '1'"

cQuery += " LEFT JOIN " + RetSqlName("SF2") + " SF2 (NOLOCK)"
cQuery += " 									ON F2_FILIAL = PA6_FILORI"
cQuery += " 									AND F2_DOC = PA6_NFS"
cQuery += " 									AND F2_SERIE = PA6_SERIE"
cQuery += " 									AND SF2.D_E_L_E_T_ = '' "

cQuery += " LEFT JOIN " + RetSqlName("SF1") + " SF1 (NOLOCK)"
cQuery += " 									ON F1_FILIAL = F2_LOJA"
cQuery += " 									AND F1_DOC = F2_DOC"
cQuery += " 									AND F1_SERIE = F2_SERIE"
cQuery += " 									AND F1_FORNECE = F2_CLIENTE"
cQuery += " 									AND F1_LOJA = F2_FILIAL"
cQuery += " 									AND F1_EMISSAO = F2_EMISSAO"
cQuery += " 									AND SF1.D_E_L_E_T_ = '' "

cQuery += "WHERE PA6.PA6_FILIAL = '"+xFilial("PA6")+"' AND "

If !Empty(mv_par01) .OR. !Empty(mv_par02)
	
	If !Empty(mv_par01)
		cQuery += "PA6.PA6_DTROM >= '" + DTOS(mv_par01) + "' AND "
	EndIf
	
	If !Empty(mv_par02)
		cQuery += "PA6.PA6_DTROM <= '" + DTOS(mv_par02) + "' AND "
	EndIf
	
EndIf

If !Empty(mv_par03)
	cQuery += "PA6.PA6_STATUS = '" + mv_par03 + "' AND "
EndIf

cQuery += "(PA6.PA6_FILORI = '" + cFilAnt + "' OR PA6.PA6_FILDES = '" + cFilAnt + "' )AND "
cQuery += " PA6.D_E_L_E_T_ = '' "

cQuery += "ORDER BY PA6.PA6_NUMROM"

dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"PA6TMP", .T., .T.)
TcSetField('PA6TMP','PA6_DATNFS','D',0)
TcSetField('PA6TMP','PA6_DATNFE','D',0)

dbSelectArea("SX3")
DbSetOrder(1)
aAreaSX3 := GetArea()
If dbSeek("PA6")
	While !Eof() .And. X3_ARQUIVO == "PA6"
		If Trim(X3_CAMPO) $ cQuery
			AAdd(aCposPA6,{Trim(X3_CAMPO), X3_TIPO, X3_TAMANHO, X3_DECIMAL})
			If X3_BROWSE == "S"
				AAdd(aCposBrw,{X3TITULO(X3_CAMPO), &("{|| "+aCposPA6[Len(aCposPA6),1]+"}"), X3_TIPO, X3_TAMANHO, X3_DECIMAL, RTrim(X3_PICTURE) })
			EndIf
		EndIf
		SX3->(dbSkip())
	EndDo
	AAdd(aCposPA6,{"R_E_C_N_O_","N",14,0})
Else
	Alert("Tabela PA6 nใo cadastrada")
	Return
EndIf
RestArea(aAreaSX3)

For nI := 1 to Len(aCposPA6)
	If aCposPA6[nI,2] <> "C"
		TCSetField("PA6TMP", aCposPA6[nI,1], aCposPA6[nI,2], aCposPA6[nI,3], aCposPA6[nI,4])
	Endif
Next

cArqTrab := CriaTrab( aCposPA6, .T. )
dbUseArea( .T., "DBFCDX", cArqTrab, "TRB", .T. ,.F. )

IndRegua( "TRB", cArqTrab, "PA6_NUMROM" )

cAlias := "TRB"
dbSelectArea('TRB')
dbSetOrder(1)

MsAguarde( {|lEnd| GrvTrb(@lEnd)}, "Aguarde...","Processando", .T. )

aAdd( aRotina, {"Pesquisa"  	, "u_LS_Pesquisa(.T.)"	,0,2,0,.f.} )
aAdd( aRotina, {"Separacao"  	, "u_LS_Separa(.T.)"	,0,2} ) //Saida
aAdd( aRotina, {"Expedicao"  	, "u_ls_Expede"   		,0,3} )
aAdd( aRotina, {"Recebimento"	, "u_ls_Separa(.F.)"	,0,4} ) //Entrada
aAdd( aRotina, {"Encerramento"	, "U_ls_Encerra"  		,0,3} )
aAdd( aRotina, {"Monitor"		, "u_ls_Monitor" 		,0,6} )
aAdd( aRotina, {"NF Entrada" 	, "U__VisNFS(2)" 		,0,2} )
aAdd( aRotina, {"NF Saํda"   	, "U__VisNFS(1)" 		,0,2} )
aAdd( aRotina, {"Ped Venda"  	, "U__VisNFS(3)" 		,0,2} )
aAdd( aRotina, {"Legenda"		, "U_ls_PA6Leg"  		,0,7} ) //3} }

aAdd(aCores, { "(TRB->PA6_STATUS == '01')", "BR_VERMELHO" 	}) //Ainda nao separado
aAdd(aCores, { "(TRB->PA6_STATUS == '02')", "BR_BRANCO"   	}) //Separacao Ok
aAdd(aCores, { "(TRB->PA6_STATUS == '03')", "BR_AMARELO"  	}) //Separacao divergente
aAdd(aCores, { "(TRB->PA6_STATUS == '04')", "BR_AZUL"     	}) //Expedicao Ok
aAdd(aCores, { "(TRB->PA6_STATUS == '05')", "BR_VERDE"		}) //Recebimento Ok
aAdd(aCores, { "(TRB->PA6_STATUS == '06')", "BR_PRETO" 		}) //Encerrado

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณFiltro da MBrowseณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

mBrowse(  ,  ,  ,  ,'TRB',aCposBrw,,,,,aCores)

DbCloseArea()

dbSelectArea("PA6TMP")
DbCloseArea()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGrvTrb    บAutor  ณDeosdete P. Silva   บ Data ณ  04/04/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Alimentar arquivo temporario com os dados da Query         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ LASP001                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function GrvTrb(lEnd)
////////////////////////////
Local nCnt  := 0
Local nI    := 0
Local nSoma := 0



PA6TMP->(dbGoTop())
ProcRegua(nCnt)

While !PA6TMP->(Eof())
	MsProcTxt("Processando movimentos: " + DToC(PA6TMP->PA6_DTROM))
	ProcessMessage()
	
	If lEnd
		MsgInfo(cCancela,"Processo cancelado")
		Exit
	Endif
	
	RecLock('TRB', .T.,.F.)
	
	For nI := 1 To Len(aCposPA6) - 1
		&('TRB' + "->" + aCposPA6[nI,1]) := &("PA6TMP->" + aCposPA6[nI,1])
		If nI == 3 // Descricao do status
			Do Case
				
				Case &("PA6TMP->" +  aCposPA6[nI-1,1]) == "01"
					&('TRB' + "->" + aCposPA6[nI,1]) := "Ainda nao separado"
					
				Case &("PA6TMP->" +  aCposPA6[nI-1,1]) == "02"
					&('TRB' + "->" + aCposPA6[nI,1]) := "Separacao Ok"
					
				Case &("PA6TMP->" +  aCposPA6[nI-1,1]) == "03"
					&('TRB' + "->" + aCposPA6[nI,1]) := "Separacao divergente"
					
				Case &("PA6TMP->" +  aCposPA6[nI-1,1]) == "04"
					&('TRB' + "->" + aCposPA6[nI,1]) := "Expedicao Ok"
					
				Case &("PA6TMP->" +  aCposPA6[nI-1,1]) == "05"
					&('TRB' + "->" + aCposPA6[nI,1]) := "Recebimento Ok"
					
				Otherwise
					&('TRB' + "->" + aCposPA6[nI,1]) := "Encerrado"
					
			EndCase
		EndIf
	Next
	
	TRB->R_E_C_N_O_ := nCnt
	
	MsUnLock()
	
	PA6TMP->(dbSkip())
	nCnt++
End

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ Separa   บAutor  ณ Fabio Jadao Caires บ Data ณ  18/06/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina de separacao dos itens do romaneio                  บฑฑ
ฑฑบ          |                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ LASEA003                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function ls_Separa(lSaida)
///////////////////////////////

u_LS_Pesquisa(.f.)

Private cGetProd := Space( Len( SB1->B1_CODBAR) )
Private oGetProd

Private nQtd	 := Space(5)

Private oDlg
Private VISUAL := .F.
Private INCLUI := .F.
Private ALTERA := .F.
Private DELETA := .F.

Private aListBox1 := {}
Private oListBox1

Private aValid		:= {}

Private oOk     	:= LoadBitmap( GetResources(), "BR_VERDE" 	)	//Qtd Ok
Private oCont		:= LoadBitmap( GetResources(), "BR_AZUL" 	)	//Contagem em curso
Private oDiverg		:= LoadBitmap( GetResources(), "BR_VERMELHO" )	//Qtd Divergente
Private oUltra		:= LoadBitmap( GetResources(), "BR_LARANJA" 	)	//Qtd Ultrapassada
Private oFora		:= LoadBitmap( GetResources(), "BR_PRETO" 	)	//Item fora do romaneio


If lSaida
	cTitulo := "Carga do Romaneio - Saida de Produtos"
Else
	cTitulo := "Carga do Romaneio - Entrada de Produtos"
	
	If _cPorta <> '7990' .and. alltrim(TRB->PA6_SERIE) == '8' .and. TRB->PA6_FILORI  <> 'BH' .and. TRB->PA6_FILORI  <>'RC'
		//Verifica status da NF-e enviada e aprovada
		_cQuery := "SELECT STATUS STATUSNFE, ID_ENT, NFE_ID"
		_cQuery += _cEnter + "FROM SPED050"
		_cQuery += _cEnter + "WHERE ID_ENT = dbo.FN_GETIDSPED('" + TRB->PA6_FILORI + "')"
		_cQuery += _cEnter + "AND NFE_ID = '" + TRB->PA6_SERIE + TRB->PA6_NFS + "'"
		_cQuery += _cEnter + "AND D_E_L_E_T_ = ''"
		
		dbUseArea( .T., "TOPCONN", TcGenQry(,,_cQuery),"SEFAZ", .T., .T.)
		_cStatus := SEFAZ->STATUSNFE
		DbCloseArea()
		
		If _cStatus = 0
			MsgBox('NF-e ainda nใo transmitida para a SEFAZ. Verifique com a Loja de origem!','ATENวรO!!!','ALERT')
			Return()
		ElseIf _cStatus <> 6
			MsgBox('NF-e nใo aprovada pela SEFAZ. Verifique com a Loja de origem se a nota jแ foi transmitida e aprovada na SEFAZ','ATENวรO!!!','ALERT')
			Return()
		EndIf
	EndIf
EndIf

Set Key VK_F11 to u_ls_Estorna()

If TRB->(EOF())
	Alert("Arquivo Vazio")
	Return
EndIf

If !lSaida .And. TRB->PA6_FILDES != cFilAnt
	Alert("Este romaneio s๓ poderแ ser recebido na filial de destino.")
	Return
EndIf

If lSaida .And. TRB->PA6_FILORI != cFilAnt
	Alert("Este romaneio s๓ poderแ ser separado na filial de origem.")
	Return
EndIf

If TRB->PA6_STATUS == "01" .And. !lSaida//Ainda nao separado
	Alert("Este romaneio ainda nao foi separado." + _cEnter + "Antes de receb๊-lo, o romaneio deve ser separado e expedido.")
	Return
EndIf

If !lSaida
	_cQuery := "UPDATE PA7"
	_cQuery += _cEnter + " SET PA7_QUANT = D2_QUANT"
	
	_cQuery += _cEnter + " FROM " + RetSqlName('PA7') + " PA7 (NOLOCK),"
	
	_cQuery += _cEnter + " (SELECT D2_DOC, D2_COD, D2_FILIAL, D2_LOJA, D2_PEDIDO, SUM(D2_QUANT) D2_QUANT"
	
	_cQuery += _cEnter + " FROM " + RetSqlName('PA6') + " PA6 (NOLOCK)"
	
	_cQuery += _cEnter + " INNER JOIN " + RetSqlName('SD2') + " SD2 (NOLOCK)"
	_cQuery += _cEnter + " ON D2_FILIAL = PA6_FILORI"
	_cQuery += _cEnter + " AND D2_DOC = PA6_NFS"
	_cQuery += _cEnter + " AND D2_SERIE = PA6_SERIE"
	_cQuery += _cEnter + " AND SD2.D_E_L_E_T_ = ''"
	
	_cQuery += _cEnter + " WHERE PA6_NUMROM = '" + TRB->PA6_NUMROM + "'"
	_cQuery += _cEnter + " AND PA6_STATUS = '04'"
	_cQuery += _cEnter + " AND PA6.D_E_L_E_T_ = ''"
	
	_cQuery += _cEnter + " GROUP BY D2_DOC, D2_COD, D2_FILIAL, D2_LOJA, D2_PEDIDO) A"
	
	_cQuery += _cEnter + " WHERE PA7_NUMROM = '" + TRB->PA6_NUMROM + "'"
	_cQuery += _cEnter + " AND PA7_CODPRO = D2_COD"
	_cQuery += _cEnter + " AND PA7.D_E_L_E_T_ = ''"
	
	TcSqlExec(_cQuery)
	
EndIf

If TRB->PA6_STATUS == "02" .And. lSaida //Separacao Ok
	If lSaida
		
		If !MsgYesNo("Este romaneio ja esta com a separa็ใo Ok. Deseja refazer a separa็ใo?")
			Return(.T.)
		EndIf
	Else
		Alert("Este romaneio ja foi devidamente separado mas ainda nao foi expedido." + _cEnter + "Antes de receb๊-lo, o romaneio deve ser expedido.")
		Return
	EndIf
EndIf

If TRB->PA6_STATUS == "03" .And. !lSaida //Separacao divergente
	Alert("Este romaneio nao foi devidamente separado. Corrija a separacao mas ainda nao foi expedido." + _cEnter + "Antes de receb๊-lo, o romaneio deve ser expedido.")
	Return
EndIf


If TRB->PA6_STATUS == "04" .And. lSaida //Em expedicao
	Alert("Este romaneio jแ estแ em Expedi็ใo e nใo pode mais ser separado." + _cEnter + "Contate a filial de origem deste romaneio.")
	Return(.T.)
EndIf

If TRB->PA6_STATUS == "05" //Recebido Ok
	Alert("Este romaneio jแ foi devidamente recebido." + _cEnter + "Contate a filial de origem deste romaneio.")
	Return(.T.)
EndIf

If TRB->PA6_STATUS == "06" //Encerrado
	Alert("Este romaneio jแ foi encerrado e nใo pode mais ser separado."+ _cEnter +	"Contate a filial de origem deste romaneio.")
	Return(.T.)
EndIf

_cAviso  := ''
_cUltimo := ''
_oFont1  := TFont():New ("Arial Black", 8, 18)
_lToque  := .t.

oDlg:=MsDialog():New(0,0,500,800,cTitulo,,,,,CLR_BLACK,CLR_WHITE,,,.T.)
@ (009),(006) Say "Filial :" 						Size (018),(008) COLOR CLR_BLACK 	PIXEL OF oDlg
@ (009),(036) Say Alltrim(TRB->PA6_LOJA) 			Size (084),(008) COLOR CLR_BLACK 	PIXEL OF oDlg
@ (020),(006) Say "Romaneio : " 					Size (028),(008) COLOR CLR_BLACK 	PIXEL OF oDlg
@ (020),(036) Say Alltrim(TRB->PA6_NUMROM)			Size (029),(008) COLOR CLR_BLACK 	PIXEL OF oDlg
@ (030),(006) Say "Carga: " 						Size (019),(008) COLOR CLR_BLACK 	PIXEL OF oDlg
@ (030),(036) Say Alltrim(TRB->PA6_CARGA)			Size (066),(008) COLOR CLR_BLACK 	PIXEL OF oDlg

@ (003),(100) Get _oAviso  var _cAviso   MEMO		Size (280),(050) COLOR CLR_RED 		PIXEL OF oDlg when .f.
_oAviso:oFont := _oFont1

@ (055),(006) Say "Codigo do Produto:" 				Size (051),(008) COLOR CLR_BLACK 	PIXEL OF oDlg
@ (055),(100) Get oGetProd Var cGetProd          	Size (115),(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlg  Valid ( LS03REFRES() .or. Empty( cGetProd ) ) when _lToque
@ (055),(075) Get oGetQtd  Var nQtd  				Size (020),(009) COLOR CLR_BLACK Picture "@E 99999" PIXEL OF oDlg  Valid VlnQtd() when _lToque
@ (230),(006) Say "[F11] Estorno"					Size (051),(008) COLOR CLR_BLACK PIXEL OF oDlg

@ (230),(050) Button "Tocar" 	    				Size (037),(012) 					PIXEL OF oDlg ACTION(FTocar())
@ (230),(220) Button "Ok" 							Size (037),(012) 					PIXEL OF oDlg ACTION(GrvRom(lSaida))
@ (230),(270) Button "Cancelar" 					Size (037),(012) 					PIXEL OF oDlg ACTION(oDlg:End())

fListBox1(lSaida)

oDlg:Activate(,,,.T.)

Set Key VK_F11 to

Return(.T.)


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function VlnQtd()
////////////////////////

_lRet := (( Val(nQtd) > 0) .and. !empty(cGetProd)) .or. empty(cGetProd)

If val(nQtd) < 0
	MsgBox('Quantidade nใo pode ser negativa!','ATENวรO!!!','ALERT')
	nQtd  := space(5)
	_lRet := .f.
	oGetQtd:Refresh()
EndIf

If _lRet
	_lToque := .t.
	oGetProd:SetFocus()
	oGetProd:Refresh()
EndIf

Return(_lRet)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function FTocar()
////////////////////////
_cAviso := ''
_lToque := .t.
_oAviso:Refresh()
oGetQtd:Refresh()
oGetProd:SetFocus()
oGetProd:Refresh()

Return()
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ Estorna  บAutor  ณ Fabio Jadao Caires บ Data ณ  18/06/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina de estorno das quantidades da separacao.            บฑฑ
ฑฑบ          |                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ LASEA003                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function ls_Estorna()
//////////////////////////

Local nPosCont := 0
//u_LS_Pesquisa(.f.)

nPosCont 	:= oListBox1:nAt

If nPosCont <= 0
	Alert("Posicione sobre o produto para o estorno!")
	cGetProd := Space( Len( SB1->B1_CODBAR) )
	oGetProd:Refresh()
	Return
EndIf

If aListBox1[nPosCont,5] > 0
	aListBox1[nPosCont,5] := aListBox1[nPosCont,5] - 1
	
	If aListBox1[nPosCont,5] == aListBox1[nPosCont,6]
		aListBox1[nPosCont,1] := oOk
	EndIf
	
	If aListBox1[nPosCont,5] < aListBox1[nPosCont,6]
		aListBox1[nPosCont,1] := oCont
	EndIf
	
	If aListBox1[nPosCont,5] > aListBox1[nPosCont,6]
		aListBox1[nPosCont,1] := oDiverg
	EndIf
	
Else
	Alert("Quantidade nใo pode ser negativa!")
EndIf


oListBox1:Refresh()

cGetProd := Space( Len( SB1->B1_CODBAR) )
oGetProd:Refresh()
oGetProd:SetFocus()

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ Expede   บAutor  ณ Fabio Jadao Caires บ Data ณ  18/06/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina de expedicao dos itens do romaneio                  บฑฑ
ฑฑบ          |                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ LASEA003                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function ls_Expede()
/////////////////////////

u_LS_Pesquisa(.f.)
//SC5->(DbSeek(right(TRB->PA6_NUMROM,2) + left(TRB->PA6_NUMROM,6),.f.))  /
dbSelectArea("SC5")
dbSetOrder(1)
dbSeek(right(TRB->PA6_NUMROM,2) + left(TRB->PA6_NUMROM,6))

_cQuery := "SELECT SUM(C9_QTDLIB) QTDLIB, "
_cQuery += _cEnter + " (SELECT SUM(PA7_QUANT) PA7_QUANT"
_cQuery += _cEnter + " FROM " + RetSqlName('PA7') + " PA7 (NOLOCK)"
_cQuery += _cEnter + " WHERE PA7_NUMROM = '" + TRB->PA6_NUMROM + "'"
_cQuery += _cEnter + " AND PA7.D_E_L_E_T_ = '') QTDROM, "

_cQuery += _cEnter + " (SELECT SUM(C6_QTDVEN) C6_QTDVEN"
_cQuery += _cEnter + " FROM " + RetSqlName('SC6') + " SC6 (NOLOCK)"
_cQuery += _cEnter + " WHERE C6_NUM = '" + SC5->C5_NUM + "'"
_cQuery += _cEnter + " AND C6_FILIAL = '" + SC5->C5_FILIAL + "'"
_cQuery += _cEnter + " AND SC6.D_E_L_E_T_ = '') QTDPED"

_cQuery += _cEnter + " FROM " + RetSqlName('SC9') + " SC9 (NOLOCK)"

_cQuery += _cEnter + " WHERE C9_FILIAL = '" + SC5->C5_FILIAL + "'"
_cQuery += _cEnter + " AND C9_PEDIDO = '" + SC5->C5_NUM + "'"
_cQuery += _cEnter + " AND SC9.D_E_L_E_T_ = ''"

If Select("LIB") > 0
	DbSelectArea("LIB")
	DbCloseArea()
EndIf

DbUseArea( .T., "TOPCONN", TcGenQry(,,_cQuery),"LIB", .T., .T.)
_lOkNF := (QTDPED == QTDROM .and. QTDLIB == QTDROM)
DbCloseArea()

If !_lOkNF
	MsgBox('Diverg๊ncias nas quantidades liberadas X romaneio. Estorne a libera็ใo do pedido e libere novamente.','ATENวรO!!!','ALERT')
	Return()
EndIf

Private cGetVol  	:= CRIAVAR("PA8_CODCOL")
Private oGetVol
Private oGetQtd1
Private nGetQtd1 	:= SC5->C5_VOLUME1
Private nGetPesoB 	:= SC5->C5_PBRUTO
Private nGetPesoL 	:= SC5->C5_PESOL
Private	cGetTrans 	:= SC5->C5_TRANSP
Private cGetNTran 	:= Posicione('SA4',1,xFilial('SA4') + cGetTrans,'A4_NOME')

Private oDlg3
Private VISUAL := .F.
Private INCLUI := .F.
Private ALTERA := .F.
Private DELETA := .F.

Private aListBox2 := {}
Private oListBox2

Private aVolumes	:= {}

Private oVolOk  := LoadBitmap( GetResources(), "BR_VERDE" 	)	//Qtd Ok
Private oVolDiv	:= LoadBitmap( GetResources(), "BR_VERMELHO" )	//Qtd Divergente

If TRB->(EOF())
	Alert("Arquivo Vazio")
	Return
EndIf

If TRB->PA6_FILORI <> cFilAnt
	If TRB->PA6_STATUS == "01"
		Alert("Este romaneio deve ser separado na filial "+TRB->PA6_FILORI)
		Return(.T.)
	ElseIf TRB->PA6_STATUS == "02"
		Alert("Este romaneio deve ser expedido na filial "+TRB->PA6_FILORI)
		Return(.T.)
	EndIf
EndIf

If TRB->PA6_STATUS == "01"
	Alert("Favor realizar a separa็ใo do romaneio!")
	Return(.T.)
EndIf

If TRB->PA6_STATUS == "03"  //Separacao divergente
	Alert("Ainda existem diverg๊ncias na separa็ใo deste romaneio. Favor refazer a separa็ใo ou " + _cEnter + "solicite a aprova็ใo da separa็ใo deste romaneio.")
	Return(.T.)
EndIf

If TRB->PA6_STATUS == "04" //Expedicao Ok
	Alert("Este romaneio ja foi separado e expedido.")
	Return(.T.)
EndIf

If TRB->PA6_STATUS == "05" //Recebimento Ok
	Alert("Este romaneio jแ foi expedido e recebido na filial de destino." + _cEnter + "Contate a filial de destino deste romaneio.")
	Return(.T.)
EndIf

If TRB->PA6_STATUS == "06" //Encerrado
	Alert("Este romaneio jแ foi encerrado." + _cEnter + "Nenhuma a็ใo sobre este romaneio ้ permitida.")
	Return(.T.)
EndIf

If !xGetVol()
	Alert("Nenhum volume encontrado para a expedicao.")
	Return
EndIf
_lOk := .t.
If xFilial('SC5') <> 'C0'
	_lOk := .f.
	DEFINE MSDIALOG oDlg3 TITLE "Carga do Romaneio - Controle de Volumes" FROM C(178),C(181) TO C(600),C(662) PIXEL
	
	@ C(005),C(006) Say "Filial :" 					Size C(018),C(008) COLOR CLR_BLACK PIXEL OF oDlg3
	@ C(005),C(025) Say Alltrim(TRB->PA6_LOJA) 		Size C(084),C(008) COLOR CLR_BLACK PIXEL OF oDlg3
	@ C(015),C(006) Say "Romaneio : " 				Size C(028),C(008) COLOR CLR_BLACK PIXEL OF oDlg3
	@ C(015),C(036) Say Alltrim(TRB->PA6_NUMROM)	Size C(029),C(008) COLOR CLR_BLACK PIXEL OF oDlg3
	@ C(015),C(074) Say "Carga: " 					Size C(019),C(008) COLOR CLR_BLACK PIXEL OF oDlg3
	@ C(015),C(094) Say Alltrim(TRB->PA6_CARGA)		Size C(066),C(008) COLOR CLR_BLACK PIXEL OF oDlg3
	
	@ C(025),C(006) Say "Volume:"            		Size C(051),C(008) COLOR CLR_BLACK PIXEL OF oDlg3
	@ C(025),C(040) MsGet oGetVol Var cGetVol  		Size C(040),C(009) COLOR CLR_BLACK PIXEL OF oDlg3 Picture "@!" Valid ( Empty(cGetVol) .OR. VOLREFRES() )
	
	@ C(025),C(100) Say "Qtd Volumes:"         		Size C(051),C(008) COLOR CLR_BLACK PIXEL OF oDlg3
	@ C(025),C(150) MsGet oGetQtd1 Var nGetQtd1		Size C(040),C(009) COLOR CLR_BLACK PIXEL OF oDlg3 PICTURE '999'
	
	@ C(040),C(006) Say "Peso Lํquido:"      		Size C(051),C(008) COLOR CLR_BLACK PIXEL OF oDlg3
	@ C(040),C(040) MsGet oGetPL  Var nGetPesoB		Size C(040),C(009) COLOR CLR_BLACK PIXEL OF oDlg3 PICTURE '@E 999,999.99
	
	@ C(040),C(100) Say "Peso Bruto:"          		Size C(051),C(008) COLOR CLR_BLACK PIXEL OF oDlg3
	@ C(040),C(150) MsGet oGetPB   Var nGetPesoL	Size C(040),C(009) COLOR CLR_BLACK PIXEL OF oDlg3 PICTURE '@E 999,999.99
	
	@ C(055),C(006) Say "Transportadora:"      		Size C(051),C(008) COLOR CLR_BLACK PIXEL OF oDlg3
	@ C(055),C(040) MsGet oGetTra Var cGetTrans		Size C(040),C(009) COLOR CLR_BLACK PIXEL OF oDlg3 F3 'SA4' Valid TrnpRefres()
	@ C(055),C(100) MsGet oGetTrb Var cGetNTran		Size C(100),C(009) COLOR CLR_BLACK PIXEL OF oDlg3 when .f.
	
	fListBox2()
	
	@ C(190),C(151) Button "Ok" 		Size C(037),C(012) PIXEL OF oDlg3 ACTION(_lOk := .t., oDlg3:End())
	@ C(190),C(195) Button "Cancelar" 	Size C(037),C(012) PIXEL OF oDlg3 ACTION(_lOk := .f., oDlg3:End())
	
	ACTIVATE MSDIALOG oDlg3 CENTERED Valid ( !_lOk .or. VldDlg3() )
EndIf

If _lOk
	GeraNF()
EndIf

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ Monitor  บAutor  ณ Fabio Jadao Caires บ Data ณ  18/06/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina de monitoramento dos romaneios.                     บฑฑ
ฑฑบ          |                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ LASEA003                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function ls_Monitor()
//////////////////////////

Local aButtons	:= {}

Local cFilOri	:= ""
Local cFilDes	:= ""

u_LS_Pesquisa(.f.)

Private oDlg5				// Dialog Principal

Private VISUAL := .F.
Private INCLUI := .F.
Private ALTERA := .F.
Private DELETA := .F.
Private NumNFE				//Dialog Principal



Private aListBox5 := {}
Private oListBox5

Private oOk5   		:= LoadBitmap( GetResources(), "BR_VERDE" 	)	//Qtd Ok
Private oCont5   	:= LoadBitmap( GetResources(), "BR_AMARELO" 	)	//Qtd em contagem
Private oDiv5		:= LoadBitmap( GetResources(), "BR_VERMELHO" )	//Qtd Divergente

If TRB->(EOF())
	Alert("Arquivo Vazio")
	Return
EndIf

dbSelectArea("SM0")
SM0->(dbSetOrder(1))
If SM0->( dbSeek(cEmpAnt + Trim(TRB->PA6_FILORI)) )
	cFilOri := Trim(SM0->M0_CODFIL)+" - "+Trim(SM0->M0_FILIAL)
EndIf

cFilDes := TRB->PA6_FILDES+" - "+ GetAdvFVal("SM0","M0_FILIAL",cEmpAnt + TRB->PA6_FILDES,1)


DEFINE MSDIALOG oDlg5 TITLE "Romaneios - Monitor" FROM C(178),C(181) TO C(665),C(967) PIXEL

@ C(004),C(003) TO C(080),C(392) LABEL "" PIXEL OF oDlg5

@ C(013),C(008) Say "Romaneio : " 									Size C(031),C(008) COLOR CLR_BLACK PIXEL OF oDlg5
@ C(013),C(039) Say Alltrim(TRB->PA6_NUMROM)						Size C(050),C(008) COLOR CLR_BLACK PIXEL OF oDlg5
@ C(013),C(101) Say "Carga : " 										Size C(021),C(008) COLOR CLR_BLACK PIXEL OF oDlg5
@ C(013),C(124) Say Alltrim(TRB->PA6_CARGA)						Size C(040),C(008) COLOR CLR_BLACK PIXEL OF oDlg5
@ C(013),C(215) Say "Nota Fiscal de saํda        :" 				Size C(070),C(008) COLOR CLR_BLACK PIXEL OF oDlg5
@ C(013),C(284) Say Alltrim(TRB->PA6_NFS)							Size C(050),C(008) COLOR CLR_BLACK PIXEL OF oDlg5

@ C(023),C(008) Say "Loja  :" 										Size C(019),C(008) COLOR CLR_BLACK PIXEL OF oDlg5
@ C(023),C(027) Say Alltrim(TRB->PA6_LOJA)				  			Size C(063),C(008) COLOR CLR_BLACK PIXEL OF oDlg5
@ C(023),C(101) Say "Nro. Volumes :" 								Size C(037),C(008) COLOR CLR_BLACK PIXEL OF oDlg5
@ C(023),C(140) Say StrZero(TRB->PA6_VOL,3)	 						Size C(024),C(008) COLOR CLR_BLACK PIXEL OF oDlg5
@ C(023),C(215) Say "Nota Fiscal de entrada     :" 					Size C(070),C(008) COLOR CLR_BLACK PIXEL OF oDlg5
@ C(023),C(284) Say TRB->PA6_NFE 									Size C(050),C(008) COLOR CLR_BLACK PIXEL OF oDlg5

@ C(033),C(008) Say "Data : " 										Size C(019),C(008) COLOR CLR_BLACK PIXEL OF oDlg5
@ C(033),C(027) Say DTOC(TRB->PA6_DTROM)	 						Size C(041),C(008) COLOR CLR_BLACK PIXEL OF oDlg5
@ C(033),C(101) Say "Status do romaneio : " 						Size C(051),C(008) COLOR CLR_BLACK PIXEL OF oDlg5
@ C(033),C(153) Say Alltrim(TRB->PA6_DESCST) 			  			Size C(057),C(008) COLOR CLR_BLACK PIXEL OF oDlg5
@ C(033),C(215) Say "ฺltima a็ใo realizada por :" 		  			Size C(070),C(008) COLOR CLR_BLACK PIXEL OF oDlg5
@ C(033),C(284) Say Alltrim(TRB->PA6_USER)	 		 				Size C(080),C(008) COLOR CLR_BLACK PIXEL OF oDlg5

@ C(053),C(008) Say "Filial de Origem :" 							Size C(042),C(008) COLOR CLR_BLACK PIXEL OF oDlg5
@ C(053),C(053) Say cFilOri			 								Size C(130),C(008) COLOR CLR_BLACK PIXEL OF oDlg5

@ C(063),C(008) Say "Filial de Destino :" 				   			Size C(042),C(008) COLOR CLR_BLACK PIXEL OF oDlg5
@ C(063),C(053) Say cFilDes				 							Size C(130),C(008) COLOR CLR_BLACK PIXEL OF oDlg5

fListBox5()

ACTIVATE MSDIALOG oDlg5 CENTERED  ON INIT EnchoiceBar(oDlg5, {||oDlg5:End()},{||oDlg5:End()},,aButtons)

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณPrograma   ณfListBox1() ณ Autor ณ Fabio Jadao Caires       ณ Data ณ18/06/2007ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescricao  ณ Montagem da ListBox                                          ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fListBox1(lSaida)
/////////////////////////////////


Local lOk			:= .F.
Local cCodBar   	:= ''
Local aArea     	:= GetArea()
Local aAreaSB1  	:= SB1->( GetArea() )

Private oBrowse, oDlgMain, oBtnItens
Private oMarca

Private nItens 		:= 0
Private nTotCheque	:= 0
Private nTotBorder	:= 0
Private nTotValor	:= 0.00
Private lInverte	:= .F.

Private oLbx
Private aLotes 		:= {}
Private aItens 		:= {}
Private aItensCor	:= {}
Private oLegenda

// Se for para recebimento mostrar a quantidade PA7_QUANT e nao mostrar mais a quantidade PA7_QTDORI. Criar PA7_QTDREC e apontar nesta quantida e comprarar.
If PA7->( DbSeek( xFilial("PA7")+TRB->PA6_NUMROM ) )
	While !PA7->(EOF()) .AND. PA7->PA7_NUMROM == TRB->PA6_NUMROM
		
		SB1->( DbSetOrder(1) )
		If SB1->( DbSeek( xFilial('SB1') + PA7->PA7_CODPRO ) )
			cCodBar := SB1->B1_CODBAR
		EndIf
		
		If lSaida
			Do Case
				Case PA7->PA7_QUANT == 0  //< PA7->PA7_QTDORI //Qtd contada < Qtd Romaneio ou nao contado ( Qtd Contada = 0 )
					aAdd(aListBox1,{oCont, PA7->PA7_CODPRO, cCodBar, PA7->PA7_DESCPR, PA7->PA7_QUANT, PA7->PA7_QTDORI})
				Case PA7->PA7_QUANT == PA7->PA7_QTDORI //Qtd contada = qtd romaneio
					aAdd(aListBox1,{oOk, PA7->PA7_CODPRO, cCodBar, PA7->PA7_DESCPR, PA7->PA7_QUANT, PA7->PA7_QTDORI})
				Otherwise //Qtd contada > qtd romaneio
					aAdd(aListBox1,{oDiverg, PA7->PA7_CODPRO, cCodBar, PA7->PA7_DESCPR, PA7->PA7_QUANT, PA7->PA7_QTDORI})
			EndCase
		Else
			Do Case
				Case PA7->PA7_QTDREC == 0 //< PA7->PA7_QUANT //Qtd contada < Qtd Romaneio ou nao contado ( Qtd Contada = 0 )
					aAdd(aListBox1,{oCont, PA7->PA7_CODPRO, cCodBar, PA7->PA7_DESCPR, PA7->PA7_QTDREC, PA7->PA7_QUANT})
				Case PA7->PA7_QTDREC == PA7->PA7_QUANT //Qtd contada = qtd romaneio
					aAdd(aListBox1,{oOk, PA7->PA7_CODPRO, cCodBar, PA7->PA7_DESCPR, PA7->PA7_QTDREC, PA7->PA7_QUANT})
				Otherwise //Qtd contada > qtd romaneio
					aAdd(aListBox1,{oDiverg, PA7->PA7_CODPRO, cCodBar, PA7->PA7_DESCPR, PA7->PA7_QTDREC, PA7->PA7_QUANT})
			EndCase
		EndIf
		PA7->(DbSkip())
	EndDo
EndIf

@ (070),(004) LISTBOX oListBox1 FIELDS HEADER "","Codigo", "Cod. Barras", "Descricao", "Qtd contada"  SIZE (400),(150) Of oDlg Pixel	ColSizes 50,50,50,50

oListBox1:SetArray(aListBox1)

oListBox1:bLine 		:= {|| {	aListBox1[oListBox1:nAT,01],;
aListBox1[oListBox1:nAT,02],;
aListBox1[oListBox1:nAT,03],;
aListBox1[oListBox1:nAT,04],;
aListBox1[oListBox1:nAT,05],;
aListBox1[oListBox1:nAT,06] }}

RestArea( aArea )
RestArea( aAreaSB1 )
Return Nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณPrograma   ณfListBox2() ณ Autor ณ Fabio Jadao Caires    ณ Data ณ18/06/2007ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescricao  ณ Montagem da ListBox                                          ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fListBox2()
///////////////////////////


Local lOk			:= .F.
Local nX			:= 0

Private oBrowse, oDlgMain, oBtnItens
Private oMarca

Private nItens 		:= 0
Private nTotCheque	:= 0
Private nTotBorder	:= 0
Private nTotValor	:= 0.00
Private lInverte	:= .F.

Private oLbx
Private aLotes 		:= {}
Private aItens 		:= {}
Private aItensCor	:= {}
Private oLegenda

For nX := 1 to Len(aVolumes)
	Aadd(aListBox2,{ oVolDiv, aVolumes[nX,1], Space(Len(PA8->PA8_STATUS)) })
Next nX

If PA8->( DbSeek( xFilial("PA8")+TRB->PA6_NUMROM ) )
	While !PA8->(EOF()) .AND. PA8->PA8_NUMROM == TRB->PA6_NUMROM
		
		nX := aScan(aListBox2 ,{|x| x[2] == PA8->PA8_CODCOL })
		
		If nX > 0
			If PA8->PA8_CODST == "02"
				aListBox2[nX,1] := oVolOk
				aListBox2[nX,3] := "Volume Ok"
			Else
				aListBox2[nX,1] := oVolDiv
				aListBox2[nX,3] := " "
			EndIf
		EndIf
		
		PA8->(DbSkip())
		
	EndDo
EndIf

@ C(070),C(004) LISTBOX oListBox2 FIELDS HEADER "","Volume", "Status" SIZE C(200),C(070) Of oDlg3 Pixel	ColSizes 50,50,50

oListBox2:SetArray(aListBox2)

oListBox2:bLine 		:= {|| {	aListBox2[oListBox2:nAT,01],;
aListBox2[oListBox2:nAT,02],;
aListBox2[oListBox2:nAT,03]}}

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณPrograma   ณfListBox5() ณ Autor ณ Fabio Jadao Caires    ณ Data ณ26/06/2007ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescricao  ณ Montagem da ListBox do monitor                               ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fListBox5()
///////////////////////////

Local nDiffSaida := 0
Local nDiffEntrada := 0

PA7->( DbSetOrder(1) )
PA7->( DbSeek( xFilial("PA7")+TRB->PA6_NUMROM ) )

While !PA7->( EOF() ) .AND. PA7->PA7_NUMROM == TRB->PA6_NUMROM
	
	nDiffSaida   := PA7->PA7_QTDORIG - PA7->PA7_QUANT
	nDiffEntrada := PA7->PA7_QTDORIG - PA7->PA7_QUANT
	
	
	If nDiffSaida == 0 .Or. nDiffEntrada == 0
		Aadd( aListBox5,{oOk5,PA7->PA7_CODPRO,PA7->PA7_DESCPR,PA7->PA7_QTDORIG,PA7->PA7_QUANT,PA7->PA7_QTDREC,nDiffSaida, nDiffEntrada} )
	EndIf
	
	If nDiffSaida > 0 .Or. nDiffEntrada > 0
		Aadd( aListBox5,{oDiv5,PA7->PA7_CODPRO,PA7->PA7_DESCPR,PA7->PA7_QTDORIG,PA7->PA7_QUANT,PA7->PA7_QTDREC,nDiffSaida, nDiffEntrada} )
	EndIf
	
	If nDiffSaida < 0 .Or. nDiffEntrada < 0
		Aadd( aListBox5,{oCont5,PA7->PA7_CODPRO,PA7->PA7_DESCPR,PA7->PA7_QTDORIG,PA7->PA7_QUANT,PA7->PA7_QTDREC,nDiffSaida, nDiffEntrada} )
	EndIf
	
	PA7->(DbSkip())
	
EndDo

@ C(084),C(003) ListBox oListBox5 Fields ;
HEADER " ","Codigo","Descricao","Qtd original","Qtd Saida","Qtd Entrada", "Dif Saida","Dif Entrada"  Size C(389),C(157) Of oDlg5 Pixel;
ColSizes 50,50,50,50,50,50,50,50

oListBox5:SetArray(aListBox5)

oListBox5:bLine 		:= {|| {;
aListBox5[oListBox5:nAT,01],;
aListBox5[oListBox5:nAT,02],;
aListBox5[oListBox5:nAT,03],;
aListBox5[oListBox5:nAT,04],;
aListBox5[oListBox5:nAT,05],;
aListBox5[oListBox5:nAT,06],;
aListBox5[oListBox5:nAT,07],;
aListBox5[oListBox5:nAT,08]}}

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGeraNF    บAutor  ณ Fabio Jadao Caires บ Data ณ  18/06/2007 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณConfirmacao da gravacao do volume do romaneio e geracao da  บฑฑ
ฑฑบ          ณnota fiscal                                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Laselva                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function GeraNF()
////////////////////////

Local nI			:= 0
Local lDiverg   	:= .F.
Local lAchouPa6		:= .F.

cLockBy := 'GeraNF_' + GetMv('FS_LASSER ') + '_' + cEmpAnt + '_' + SM0->M0_CGC
_cSerie := padr(GetMv("FS_LASSER"),3,' ')
_lCont  := .f.
Do While !_lCont
	
	If !LockByName(cLockBy,.t.,.t.,.t.,.t.)
		If !(__cUserId $ GetMV('LA_PODER'))
			_lCont := .f.
			DbSelectArea('SX5')
			DbSeek(cFilAnt + '01' + _cSerie,.f.)
			If RecLock('SX5',.F.)
				_lCont := .t.
				MsUnLock()
			EndIf
			If !_lCont
				_cTexto := 'Outro usuแrio utilizando a rotina de gera็ใo de notas fiscais!!!' + _cEnter + _cEnter
				_cTexto += 'Tentar novamente?'
				If !MsgBox(_cTexto , 'Romaneios - Gera็ใo de Notas Fiscais','YESNO' )
					Return()
				EndIf
			Else
				MsgBox('Antes de prosseguir, certifique-se que nใo hแ nenhum outro usuแrio utilizando esta rotina para esta loja/filial (CNPJ).','ATENวรO!!!','ALERT')
			EndIf
			
		EndIf
	Else
		_lCont := .t.
	EndIf
EndDo

For nI := 1 to Len(aListBox2)
	If aListBox2[nI,1] <> oVolOk
		lDiverg := .T.
		Exit
	EndIf
Next nI

nI := 0

If lDiverg
	MsgAlert("Existem ainda volumes a serem confirmados. O processo nใo pode prosseguir " + _cEnter + "sem que o(s) volume(s) estante(s) seja(m) identificado(s).")
	
	cGetVol := CRIAVAR("PA8_CODCOL")
	oGetVol:Refresh()
	oGetVol:SetFocus()
	
	UnLockByName( cLockBy,.t.,.t.,.t.,.t.)
	Return
EndIf

// Chamada da funcao de geracao da NF devera ser neste PONTO !!!

MsAguarde({|| 	_cNota := GravaNFS()},"Aguarde...","Gerando Nota Fiscal de Saida",.T.)

For nI := 1 to Len(aListBox2)
	PA8->(DbSeek( xFilial("PA8")+TRB->PA6_NUMROM+aListBox2[nI,2] ))
	RecLock("PA8",.F.)
	If aListBox2[nI,1] == oVolOk
		PA8->PA8_CODST		:= "02" //Ok
		PA8->PA8_STATUS	:= "Expedi็ใo Ok"
	EndIf
	MsUnlock()
Next nI

_cSerie := iif(empty(_cSerie),left(GetMv('FS_LASSER') + '   ',3) , _cSerie)

DbSelectArea('SF2')
DbSetOrder(1)
If !DbSeek(right(TRB->PA6_NUMROM,2) + _cNota + _cSerie,.f.)
	MsgBox('Nota fiscal nใo foi gerada. Verifique!','ATENวรO!!!','ALERT')
Else
	DbSelectArea('SC5')
	DbOrderNickName('C5_NOTA')
	If !SC5->(DbSeek(right(TRB->PA6_NUMROM,2) + _cNota + _cSerie ,.f.))
		SC5->(DbSetOrder(1))
		If SC5->(DbSeek(right(TRB->PA6_NUMROM,2) + left(TRB->PA6_NUMROM,6) ,.f.))
			RecLock('SC5',.f.)
			SC5->C5_NOTA  := _cNota
			SC5->C5_SERIE := _cSerie
			MsUnLock()
		EndIf
	ElseIf SC5->C5_NUM + SC5->C5_FILIAL <> TRB->PA6_NUMROM
		MsgBox('Nota fiscal (' + _cNota + '/' + _cSerie + ') gravada no romaneio (' + SC5->C5_NUM + SC5->C5_FILIAL + '). Verifique!','ATENวรO!!!','ALERT')
	EndIf
	
	_cQuery := "UPDATE " + RetSqlName('SB2')
	_cQuery += _cEnter + " SET B2_QPEDVEN = B2_QPEDVEN - D2_QUANT"
	_cQuery += _cEnter + " FROM " + RetSqlName('SD2') + " SD2 (NOLOCK)
	_cQuery += _cEnter + " WHERE SD2.D_E_L_E_T_ = ''"
	_cQuery += _cEnter + " AND D2_DOC = '" + _cNota + "'"
	_cQuery += _cEnter + " AND D2_SERIE = '" + _cSerie + "'"
	_cQuery += _cEnter + " AND D2_FILIAL = '" + SF2->F2_FILIAL + "'"
	_cQuery += _cEnter + " AND D2_COD = B2_COD"
	_cQuery += _cEnter + " AND " + RetSqlName('SB2') + ".D_E_L_E_T_ = ''"
	_cQuery += _cEnter + " AND B2_FILIAL = D2_FILIAL"
	TcSqlExec(_cQuery)
	
	RecLock("TRB",.F.)
	TRB->PA6_STATUS := "04"
	TRB->PA6_DESCST := "Expedicao Ok"
	TRB->PA6_NFS    := _cNota
	TRB->PA6_SERIE	:= _cSerie
	MsUnlock()
	
	PA6->(DbSetOrder(1))
	If PA6->(DbSeek( xFilial("PA6")+TRB->PA6_NUMROM ))
		RecLock("PA6",.F.)
		PA6->PA6_STATUS := "04"	//Expedicao Ok
		PA6->PA6_USER 	:= cUserName
		PA6->PA6_NFS    := _cNota
		PA6->PA6_SERIE	:= _cSerie
		Msunlock()
	EndIf
	
EndIf

UnLockByName( cLockBy,.t.,.t.,.t.,.t. )
Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGrvRom    บAutor  ณ Fabio Jadao Caires บ Data ณ  18/06/2007 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณConfirmacao da gravacao do romaneio e ajusta os status do   บฑฑ
ฑฑบ          ณromaneio                                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Laselva                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function GrvRom(lSaida)
//////////////////////////////

Local nI		:= 0
Local lDiverg	:= .F.


For nI := 1 to Len(aListBox1)
	If aListBox1[nI,1] <> oOk
		lDiverg := .T.
		Exit
	EndIf
Next nI

nI := 0

If lDiverg
	If !MSgYesNo("Foram encontradas diverg๊ncias entre os itens/quantidades do romaneio e separa็ใo." + _cEnter + "Deseja gravar esta separa็ใo e ajustแ-la mais tarde?")
		Return
	EndIf
EndIf

Begin Transaction
PA7->(DbSetOrder(1))
For nI := 1 to Len(aListBox1)
	If PA7->(DbSeek( xFilial("PA7")+TRB->PA6_NUMROM+aListBox1[nI,2] ) )
		RecLock("PA7",.F.)
	Else
		RecLock("PA7",.T.)
	EndIf
	
	PA7->PA7_FILIAL	:= xFilial("PA7")
	PA7->PA7_NUMROM	:= TRB->PA6_NUMROM
	PA7->PA7_CODPRO	:= aListBox1[nI,2]
	PA7->PA7_DESCPR := aListBox1[nI,4]
	If lSaida
		PA7->PA7_QUANT	:= aListBox1[nI,5]
	Else
		PA7->PA7_QTDREC := aListBox1[nI,5]
	EndIf
	
	MsUnlock()
Next nI
//If lSaida
/*	For nI := 1 to Len(aListBox1)
If SB2->(DbSeek(TRB->PA6_FILDES + aListBox1[nI,2])) // ATUALIZA NO DESTINO
RecLock("SB2",.F.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณTatiane d
e Oliveira 05/02/16            ณ
//ณTrocou o campo b2_salpedi por B2_XTRANSIณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

//			SB2->B2_SALPEDI := SB2->B2_SALPEDI + aListBox1[nI,5] - aListBox1[nI,6] // TRANSITO PARA A LOJA
SB2->B2_XTRANSI := iif (SB2->B2_XTRANSI<0,0,SB2->B2_XTRANSI) + aListBox1[nI,5] - aListBox1[nI,6] // TRANSITO PARA A LOJA
MsUnlock()
EndIf
Next nI
//EndIf
*/
End Transaction

If (!lDiverg) .And. lSaida
	u_LS_InfVol()
EndIf

Reclock("TRB",.F.)

If lSaida
	If lDiverg
		TRB->PA6_STATUS := "03"	//Separacao divergente
		TRB->PA6_DESCST := "Separacao divergente"
	Else
		TRB->PA6_STATUS := "02"	//Separacao Ok
		TRB->PA6_DESCST := "Separacao Ok"
		TRB->PA6_CARGA	 := Alltrim(TRB->PA6_NUMROM)+StrZero(TRB->PA6_VOL,3)
		
		// Libera pedido de venda
		LibPV()
	EndIf
	
Else //Recebimento
	If !lDiverg
		TRB->PA6_STATUS := "05"	//Separacao divergente
		TRB->PA6_DESCST := "Recebimento Ok"
	EndIf
EndIf


MsUnlock()
//Gravou TRB (temporaria) agora grava PA6 definitiva
PA6->(DbSetOrder(1))
If PA6->(DbSeek( xFilial("PA6")+TRB->PA6_NUMROM ))
	
	RecLock("PA6",.F.)
	If lSaida
		If lDiverg
			PA6->PA6_STATUS := "03"	//Separacao divergente
		Else
			PA6->PA6_STATUS := "02"	//Separacao Ok
			PA6->PA6_CARGA	 := Alltrim(PA6->PA6_NUMROM)+StrZero(PA6->PA6_VOL,3)
		EndIf
		PA6->PA6_USER   := cUserName
		PA6->PA6_TOQUED := date()
		PA6->PA6_TOQUEU := cUserName
		PA6->PA6_TOQUEH := left(time(),2) + substr(time(),4,2)
		
	Else //Recebimento
		
		If !lDiverg
			PA6->PA6_STATUS := "05"	//
			PA6->PA6_DESCST := "Recebimento Ok"
			PA6->PA6_USER   := cUserName
			//Gera Pre- Nota
		Else
			Alert("Nใo foi possivel receber. Existe diferen็a e o usuario nใo ้ autorizado")
		EndIf
		
	EndIf
	
	
	
	Msunlock()
	
EndIf




//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณTatiane de Oliveira vai acrescentar o fonte abaixoณ
//ณpara atualizar o status dos itens do romaneio     ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู


PA7->(DbSetOrder(1))
If PA7->(DbSeek( xFilial("PA7")+TRB->PA6_NUMROM ))
	
	RecLock("PA7",.F.)
	If lSaida
		If lDiverg
			PA7->PA7_STATUS := "03"	//Separacao divergente
		Else
			PA7->PA7_STATUS := "02"	//Separacao Ok
		EndIf
	Else //Recebimento
		
		If !lDiverg
			PA7->PA7_STATUS := "05"	//
		EndIf
		
	EndIf
	
	
	
	Msunlock()
	
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณFIM DO COMPLEMENTO DA TATIANEณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู



oDlg:End()

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLibPV     บAutor  ณ Fabio Jadao Caires บ Data ณ  18/06/2007 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina de liberacao dos itens dos pedidos de venda por cada บฑฑ
ฑฑบ          ณromaneio no momento da separacao                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Laselva                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function LibPV()
///////////////////////

Local nX		:= 0
Local cPedido	:= Left(TRB->PA6_NUMROM,Len(TRB->PA6_NUMROM)-2)

SC6->( DbSetOrder(2) ) //C6_FILIAL + C6_PRODUTO + C6_NUM + C6_ITEM
SC9->( DbSetOrder(1) ) //C9_FILIAL+C9_PEDIDO+C9_ITEM+C9_SEQUEN+C9_PRODUTO

For nX := 1 to Len(aListBox1)
	
	If aListBox1[nX,1] == oOk
		
		If SC6->( DbSeek( xFilial("SC6")+aListBox1[nX,2]+cPedido ),.f. )
			
			Reclock("SC6",.F.)
			SC6->C6_OP 		:= "02"
			SC6->C6_QTDEMP := SC6->C6_QTDVEN
			Msunlock()
			
			If SC9->( DbSeek( xFilial("SC9") + cPedido + SC6->C6_ITEM + "01" + SC6->C6_PRODUTO,.f. ) )
				Reclock("SC9",.F.)
			Else
				Reclock("SC9",.T.)
			EndIf
			_nQuant := SC9->C9_QTDLIB
			
			SC9->C9_FILIAL 		:= xFilial("SC9")
			SC9->C9_PEDIDO		:= SC6->C6_NUM
			SC9->C9_ITEM		:= SC6->C6_ITEM
			SC9->C9_CLIENTE		:= SC6->C6_CLI
			SC9->C9_LOJA		:= SC6->C6_LOJA
			SC9->C9_PRODUTO		:= SC6->C6_PRODUTO
			SC9->C9_QTDLIB		:= SC6->C6_QTDVEN
			SC9->C9_DATALIB		:= dDatabase
			SC9->C9_SEQUEN		:= "01"
			SC9->C9_PRCVEN		:= SC6->C6_PRCVEN
			SC9->C9_LOCAL		:= SC6->C6_LOCAL
			SC9->C9_TPCARGA		:= "2"
			Msunlock()
			
			DbSelectArea("SB2")
			If DbSeek(xFilial("SB2") + SC9->C9_PRODUTO + SC9->C9_LOCAL,.f.) // ATUALIZA NA ORIGEM
				//	If DbSeek(SC9->C9_LOJA + SC9->C9_PRODUTO + SC9->C9_LOCAL,.f.) // ATUALIZA NO DESTINO
				RecLock("SB2",.F.)
				
				
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณTatiane de Oliveira 11/02/2016                        ณ
				//ณTrocou o campo b2_reserva por B2_XRESERV              ณ
				//ณ o valor de pedido nใo faturado para a filial destino ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				
								SB2->B2_RESERVA := SB2->B2_RESERVA - _nQuant + SC9->C9_QTDLIB // RESERVA
				//SB2->B2_XRESERV := SB2->B2_XRESERV - SC9->C9_QTDLIB // RESERVA DESTINO
				MsUnLock()
			EndIf
			
			//			If DbSeek(xFilial("SB2") + SC9->C9_PRODUTO + SC9->C9_LOCAL,.f.) // ATUALIZA NA ORIGEM
			If DbSeek(SC9->C9_LOJA + SC9->C9_PRODUTO + SC9->C9_LOCAL,.f.) // ATUALIZA NO DESTINO
				RecLock("SB2",.F.)
				
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณTatiane de Oliveira 05/02/16            ณ
				//ณTrocou o campo b2_salpedi por B2_XTRANSIณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				
				//				SB2->B2_SALPEDI := SB2->B2_SALPEDI - _nQuant + SC9->C9_QTDLIB // TRANSITO
				if SB2->B2_XTRANSI < 0
					SB2->B2_XTRANSI:=0
				ELSE
					SB2->B2_XTRANSI:=SB2->B2_XTRANSI
				endif
				SB2->B2_XTRANSI := SB2->B2_XTRANSI - _nQuant + SC9->C9_QTDLIB // TRANSITO
				MsUnLock()
			EndIf
			
			
		EndIf
		
	EndIf
	
Next nX

SC5->( DbSetOrder(1) )
If SC5->( DbSeek( xFilial("SC5")+cPedido) )
	
	RecLock("SC5",.F.)
	SC5->C5_LIBEROK := "S"
	Msunlock()
	
EndIf


Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxGetItem  บAutor  ณ Fabio Jadao Caires บ Data ณ  18/06/2007 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCria um vetor auxiliar com os produtos e quantidades para   บฑฑ
ฑฑบ          ณvalidar se a quantidade contada esta coerente com o romaneioบฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Laselva                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function xGetItem()
//////////////////////////

Local lRet := .T.

DbSelectArea("PA7")
PA7->(DbSetOrder(1)) //PA7_FILIAL+PA7_NUMROM+PA7_CODPRO
If PA7->(DbSeek( xFilial("PA7")+TRB->PA6_NUMROM ) )
	
	While !PA7->(EOF()) .AND. PA7->(PA7_FILIAL+PA7_NUMROM) = TRB->(PA6_FILIAL+PA6_NUMROM)
		
		Aadd( aValid,{PA7->PA7_CODPRO,PA7->PA7_QUANT,PA7->PA7_QTDORI} )
		
		PA7->(DbSkip())
	EndDo
	
Else
	lRet := .F.
EndIf

Return lRet



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxGetVol   บAutor  ณ Fabio Jadao Caires บ Data ณ  18/06/2007 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCria um vetor auxiliar com os volumes do romaneio para      บฑฑ
ฑฑบ          ณvalidar se o volume esta ou nao no romaneio.                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Laselva                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function xGetVol()
/////////////////////////

Local lRet := .T.

DbSelectArea("PA8")
PA8->(DbSetOrder(1)) //PA8_FILIAL+PA8_NUMROM+PA8_CODCOL
If PA8->(DbSeek( xFilial("PA8")+TRB->PA6_NUMROM ) )
	
	While !PA8->(EOF()) .AND. PA8->(PA8_FILIAL+PA8_NUMROM) = TRB->(PA6_FILIAL+PA6_NUMROM)
		
		Aadd( aVolumes,{PA8->PA8_CODCOL} )
		
		PA8->(DbSkip())
	EndDo
	
Else
	lRet := .F.
EndIf

Return lRet



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxGetItem2 บAutor  ณ Fabio Jadao Caires บ Data ณ  18/06/2007 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCria um vetor auxiliar com os volumes do romaneio para      บฑฑ
ฑฑบ          ณvalidar se o volume esta ou nao no romaneio.                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Laselva                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function xGetItm2()
//////////////////////////

Local lRet := .T.

DbSelectArea("PA8")
PA8->(DbSetOrder(1)) //PA8_FILIAL+PA8_NUMROM+PA8_CODCOL
If PA8->(DbSeek( xFilial("PA8")+TRB->PA6_NUMROM ) )
	
	While !PA8->(EOF()) .AND. PA8->(PA8_FILIAL+PA8_NUMROM) = TRB->(PA6_FILIAL+PA6_NUMROM)
		
		Aadd( aVolumes,{PA8->PA8_CODCOL} )
		
		PA8->(DbSkip())
	EndDo
	
Else
	lRet := .F.
EndIf

Return lRet




/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLS03REFRESบAutor  ณ Fabio Jadao Caires บ Data ณ  18/06/2007 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Atualiza o ListBox da MainWindow                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Laselva                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function LS03Refres()
////////////////////////////

Local nPos     	:= 0
Local lRet     	:= .T.
Local aArea    	:= GetArea()
Local aAreaSB1 	:= SB1->( GetArea() )
_cAviso 		:= ''
_oAviso:Refresh()
_lToque 		:= .t.

If lRet .and. !empty(cGetProd)
	//--Consiste o Produto informado - Prioriza o Codigo de Barras:
	SB1->( DbSetOrder(5) ) //--B1_FILIAL+B1_CODBAR
	If !SB1->( DbSeek( xFilial('SB1') + PadR( cGetProd, Len( SB1->B1_CODBAR ) ) ) )
		SB1->( DbSetOrder(1) ) //--B1_FILIAL+B1_COD
		If !SB1->( DbSeek( xFilial('SB1') + left( cGetProd, Len( SB1->B1_COD ) ) ) )
			u_ls_beep(3)
			_cAviso := "Produto " +Alltrim(cGetProd) + " nใo cadastrado. " + _cEnter + _cUltimo
			_lToque := .f.
			lRet    := .f.
		EndIf
	EndIf
	
	If lRet
		//--Verifica a expressao digitada X Codigo de barras
		nPos := AScan( aListBox1, {|x| PadR( x[3], Len(SB1->B1_CODBAR) ) == PadR( cGetProd, Len(SB1->B1_CODBAR) )} )
		If nPos == 0
			//--Verifica a expressao digitada X Codigo do Produto
			nPos := AScan( aListBox1, {|x| PadR( x[2], Len(SB1->B1_COD) ) == PadR( cGetProd, Len(SB1->B1_COD) )} )
			If nPos == 0
				u_ls_beep(4)
				_cAviso := "O produto " +Alltrim(cGetProd) + ' ' + alltrim(SB1->B1_DESC) + " nใo faz parte do romaneio. " + _cUltimo
				_lToque := .f.
				lRet    := .f.
			ElseIf aListBox1[nPos,5] + iif(empty(nQtd),1,val(nQtd)) > aListBox1[nPos,6]
				u_ls_beep(5)
				_cAviso := "Quantidade tocada maior que romaneio. Produto " +Alltrim(cGetProd) + ' ' + alltrim(SB1->B1_DESC) + _cEnter + _cUltimo
				_lToque := .f.
				lRet    := .f.
			Else
				u_ls_beep(6)
				_cAviso  := 'OK - ' + Alltrim(cGetProd) + ' - ' + alltrim(SB1->B1_DESC)
				_cUltimo := 'ฺltimo toque: ' + Alltrim(cGetProd) + ' - ' + alltrim(SB1->B1_DESC) + ' (' + alltrim(str(aListBox1[nPos,5] + iif(empty(nQtd),1,val(nQtd)))) + ')'
			EndIf
		ElseIf aListBox1[nPos,5]  + iif(empty(nQtd),1,val(nQtd)) > aListBox1[nPos,6]
			u_ls_beep(5)
			_cAviso := "Quantidade tocada maior que romaneio. Produto " +Alltrim(cGetProd) + ' ' + alltrim(SB1->B1_DESC) + _cEnter + _cUltimo
			_lToque := .f.
			lRet    := .f.
		Else
			u_ls_beep(6)
			_cAviso  := 'OK - ' + Alltrim(cGetProd) + ' - ' + alltrim(SB1->B1_DESC)
			_cUltimo := 'ฺltimo toque: ' + Alltrim(cGetProd) + ' - ' + alltrim(SB1->B1_DESC) + ' (' + alltrim(str(aListBox1[nPos,5] + iif(empty(nQtd),1,val(nQtd)))) + ')'
		EndIf
		
		If lRet .and. nPos > 0
			nQtdProd := aListBox1[nPos,5]
			
			If !Empty(nQtd)
				nQtdProd := Val(nQtd)
			Else
				nQtdProd++
			EndIf
			
			aListBox1[nPos,5] := nQtdProd
			
			If aListBox1[nPos,5] < aListBox1[nPos,6]
				aListBox1[nPos,1] := oDiverg
			EndIf
			
			If aListBox1[nPos,5] == aListBox1[nPos,6]
				aListBox1[nPos,1] := oOk
			EndIf
			
			If aListBox1[nPos,5] > aListBox1[nPos,6]
				aListBox1[nPos,1] := oDiverg
			EndIf
		EndIf
	EndIf
	
	cGetProd  := Space( Len( SB1->B1_CODBAR) )
	nQtd      := Space(5)
	
	//--Atualiza os objetos da tela
	_oAviso:Refresh()
	oGetProd:SetFocus()
	If !lRet
		oListBox1:SetFocus()
	EndIf
	oListBox1:Refresh()
EndIf

//--Restaura o ambiente
RestArea( aArea )
RestArea( aAreaSB1 )
Return( lRet )


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVOLREFRES บAutor  ณ Fabio Jadao Caires บ Data ณ  18/06/2007 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Atualiza o ListBox da MainWindow                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Laselva                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function VolRefres()
///////////////////////////

Local nPosVol 	:= 0 				// Posicao do vetor de contagem

nPosVol := aScan(aListBox2,{|x| x[2] == cGetVol })

If Empty(cGetVol)
	Alert("Informe o Volume!")
	cGetVol := CRIAVAR("PA8_CODCOL")
	oGetVol:SetFocus()
	Return .F.
EndIf

If nPosVol == 0
	Alert("O volume "+Alltrim(cGetVol)+" nใo pertence ao romaneio "+Alltrim(TRB->PA6_NUMROM)+" !!!")
	cGetVol :=CRIAVAR("PA8_CODCOL")
	oGetVol:SetFocus()
	Return .F.
EndIf

If nPosVol > 0
	aListBox2[nPosVol,1] := oVolOk
	aListBox2[nPosVol,3] := "Volume Ok"
EndIf

oListBox2:Refresh()

cGetVol := CRIAVAR("PA8_CODCOL")
oGetVol:Refresh()
oGetVol:SetFocus()

Return .T.

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function TrnpRefres()
////////////////////////////

//Local nPosVol    := 0

_lRet := (SA4->(DbSeek(xFilial('SA4') + cGetTrans,.f.)))

If Empty(cGetTrans)
	Alert("Favor informar o transporte!")
	Return .F.
EndIf
/*
If nPosVol == 0
Alert("Favor informar o transporte!")
Return .F.
EndIf
*/
If !_lRet
	cGetTrans := '      '
	cGetNTran := 'TRANSPORTADORA INVมLIDA'
	oGetTrb:SetFocus()
Else
	cGetNTran := SA4->A4_NOME
EndIf

oGetTrb:Refresh()
oGetTra:Refresh()

Return(_lRet)


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function VldDlg3()
///////////////////////////

If Empty(nGetQtd1)
	Alert("Informe a quantidade do Volume 1!")
	oGetQtd1:SetFocus()
	Return .F.
EndIf

SC5->(DbSetOrder(1))
If SC5->(DbSeek(right(TRB->PA6_NUMROM,2) + left(TRB->PA6_NUMROM,6),.f.))
	_aAlias := GetArea()
	RecLock('SC5',.f.)
	SC5->C5_VOLUME1 := nGetQtd1
	SC5->C5_ESPECI1 := iif(nGetQtd1 > 1,'VOLUMES','VOLUME')
	SC5->C5_PESOL   := nGetPesoL
	SC5->C5_PBRUTO  := nGetPesoB
	SC5->C5_TRANSP  := cGetTrans
	MsUnLock()
	RestArea(_aAlias)
EndIf

Return .T.

/*/
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuno    ณPA6Leg    ณAutor  ณ Fabio Jadao Caires    ณ Data ณ15.06.2007 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ          ณDemonstra a legenda das cores da mbrowse                     ณฑฑ
ฑฑณ          ณ                                                             ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณNenhum                                                       ณฑฑ
ฑฑณ          ณ                                                             ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณRetorno   ณNenhum                                                       ณฑฑ
ฑฑณ          ณ                                                             ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescrio ณEsta rotina monta uma dialog com a descricao das cores da    ณฑฑ
ฑฑณ          ณMbrowse.                                                     ณฑฑ
ฑฑณ          ณ                                                             ณฑฑ
ฑฑณ          ณ                                                             ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณUso       ณ Laselva Bookstore                                           ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function ls_PA6Leg()
/////////////////////////

Local aCores := {}

aAdd(aCores, { "BR_VERMELHO" 	,	"Ainda nao separado"		}) //Ainda nao separado
aAdd(aCores, { "BR_BRANCO"   	,	"Separacao Ok"				}) //Separacao Ok
aAdd(aCores, { "BR_AMARELO"  	,	"Separacao divergente"	}) //Separacao divergente
aAdd(aCores, { "BR_AZUL"     	,	"Expedicao Ok"				}) //Expedicao Ok
aAdd(aCores, { "BR_VERDE"		,	"Recebimento Ok"			}) //Recebimento Ok
aAdd(aCores, { "BR_PRETO" 		,	"Encerrado"					}) //Recebimento Divergente


BrwLegenda("Romaneios","Legendas",aCores)

Return(.T.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณPrograma   ณ   C()   ณ Autores ณ Norbert/Ernani/Mansano ณ Data ณ10/05/2005ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescricao  ณ Funcao responsavel por manter o Layout independente da       ณฑฑ
ฑฑณ           ณ resolucao horizontal do Monitor do Usuario.                  ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function C(nTam)
///////////////////////

Local nHRes	:=	oMainWnd:nClientWidth	// Resolucao horizontal do monitor

If nHRes == 640	// Resolucao 640x480 (soh o Ocean e o Classic aceitam 640)
	nTam *= 0.8
ElseIf (nHRes == 798).Or.(nHRes == 800)	// Resolucao 800x600
	nTam *= 1
Else	// Resolucao 1024x768 e acima
	nTam *= 1.28
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณTratamento para tema "Flat"ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If "MP8" $ oApp:cVersion
	If (Alltrim(GetTheme()) == "FLAT") .Or. SetMdiChild()
		nTam *= 0.90
	EndIf
EndIf

Return Int(nTam)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ GravaNFS บAutor  ณ Fabio Jadao Caires บ Data ณ  29/06/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Gravacao da nota fiscal de venda a partir dos registros do บฑฑ
ฑฑบ          | SC9 - Itens liberados dos pedidos de venda.                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Laselva Bookstore                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function GravaNFS()
//////////////////////////

Local aAreaAnt	 	:= GetArea()
Local aAreaSC5	 	:= SC5->( GetArea() )
Local aAreaSC6	 	:= SC6->( GetArea() )
Local aAreaSC9	 	:= SC9->( GetArea() )
Local aAreaSE4	 	:= SE4->( GetArea() )
Local aAreaSB1	 	:= SB1->( GetArea() )
Local aAreaSB2	 	:= SB2->( GetArea() )
Local aAreaSF4	 	:= SF4->( GetArea() )

Local aPvlNfs	 	:= {}
//Local _cSeek      := ''
Local _nPrcVen    := 0
Local _nRegDAK   	:= 0
Local lMostraCtb 	:= .F.
Local lAglutCtb  	:= .F.
Local lCtbOnLine 	:= .F.
Local lCtbCusto  	:= .F.
Local lReajuste  	:= .F.
Local lAtuSA7    	:= .F.
Local lECF       	:= .F.
Local nCalAcrs   	:= 1
Local nArredPrcLis 	:= 1
Local cRot       	:= ProcName()
Local cPedido := Left(TRB->PA6_NUMROM,Len(TRB->PA6_NUMROM)-2)

// PREPARANDO A NOTA FISCAL
MV_PAR01 := 2           // Mostra Lan.Contab ?  Sim/Nao
MV_PAR02 := 2           // Aglut. Lanamentos ?  Sim/Nao
MV_PAR03 := 2           // Lan.Contab.On-Line?  Sim/Nao
MV_PAR04 := 2           // Contb.Custo On-Line?  Sim/Nao
MV_PAR05 := 1           // Reaj. na mesma N.F.?  Sim/Nao
MV_PAR06 := 0           // Taxa deflacao ICMS ?  Numerico
MV_PAR07 := 3           // Metodo calc.acr.fin?  Taxa defl/Dif.lista/% Acrs.ped
MV_PAR08 := 3           // Arred.prc unit vist?  Sempre/Nunca/Consumid.final
MV_PAR09 := Space( 04 ) // Agreg. liberac. de ?  Caracter
MV_PAR10 := Space( 04 ) // Agreg. liberac. ate?  Caracter
MV_PAR11 := 2           // Aglut.Ped. Iguais  ?  Sim/Nao
MV_PAR12 := 0           // Valor Minimo p/fatu?
MV_PAR13 := Space( 06 ) // Transportadora de  ?
MV_PAR14 := 'ZZZZZZ'    // Transportadora ate ?
MV_PAR15 := 2           // Atualiza Cli.X Prod?  Sim/Nao
MV_PAR16 := 1           // Emitir             ?  Nota/Cupom Fiscal

lMostraCtb  := MV_PAR01 == 1
lAglutCtb   := MV_PAR02 == 1
lCtbOnLine  := MV_PAR03 == 1
lCtbCusto   := MV_PAR04 == 1
lReajuste   := MV_PAR05 == 1

LAtuSA7lECF := .F.
lFaturado   := .F.

// Verifica se o pedido ja foi faturado
IF lFaturado
	Aviso( cRot, 'Pedido ja faturado anteriormente !!!', {'&Abandonar'} )
	Return( .F. )
Endif

// Gera nota.
SC5->( dbSetOrder( 1 ) ) //C5_FILIAL + C5_NUM
If SC5->( MsSeek( xFilial( 'SC5' ) + cPedido, .F. ) )
	
	SC6->( DbSetOrder(1) ) //C6_FILIAL + C6_NUM + C6_ITEM + C6_PRODUTO
	
	SC9->( DbSetOrder(1) ) //C9_FILIAL + C9_PEDIDO + C9_ITEM + C9_SEQUEN + C9_PRODUTO
	
	If SC9->( DbSeek( xFilial("SC9")+cPedido ) )
		
		Do While !SC9->(EOF()) .AND. SC9->C9_PEDIDO == cPedido .and. SC9->C9_FILIAL == xFilial('SC9')
			
			If SC6->( DbSeek( xFilial("SC6") + SC9->C9_PEDIDO + SC9->C9_ITEM + SC9->C9_PRODUTO ) )
				
				SE4->( dbSetOrder( 1 ) )
				SE4->( MsSeek( xFilial( 'SE4' ) + SC5->C5_CONDPAG, .F. ) )
				
				// Posiciona no produto
				SB1->( dbSetOrder( 1 ) )
				SB1->( MsSeek( xFilial( 'SB1' ) + SC6->C6_PRODUTO, .F. ) )
				
				// Posiciona no saldo em estoque
				SB2->( dbSetOrder( 1 ) )
				SB2->( MsSeek( xFilial( 'SB2' ) + SC6->C6_PRODUTO + SC6->C6_LOCAL, .F. ) )
				
				// Posiciona no TES
				cTes := SC6->C6_TES
				SF4->( dbSetOrder( 1 ) )
				SF4->( MsSeek( xFilial( 'SF4' ) + cTes, .F. ) )
				
				// Converte o valor unitario em Reais quando pedido em outra moeda
				_nPrcVen := SC9->C9_PRCVEN
				If ( SC5->C5_MOEDA <> 1 )
					dbSelectArea( 'SM2' )
					dbSetOrder( 1 )
					If dbSeek( DTOS( dDataBase ) )
						_nPrcVen := SC9->C9_PRCVEN * SM2->M2_MOEDA2
					Else
						_nPrcVen := xMoeda( _nPrcVen, SC5->C5_MOEDA, 1, dDataBase )
					EndIf
					
				EndIf
				
				// Monta array para gerar a nota fiscal
				Aadd( aPvlNfs, { SC9->C9_PEDIDO, ;
				SC9->C9_ITEM, ;
				SC9->C9_SEQUEN, ;
				SC9->C9_QTDLIB, ;
				_nPrcVen, ;
				SC9->C9_PRODUTO, ;
				.F., ;
				SC9->( RecNo() ), ;
				SC5->( RecNo() ), ;
				SC6->( RecNo() ), ;
				SE4->( RecNo() ), ;
				SB1->( RecNo() ), ;
				SB2->( RecNo() ), ;
				SF4->( RecNo() ), ;
				SC6->C6_LOCAL, ;
				_nRegDAK, ;
				SC9->C9_QTDLIB2} )
				
			Else
				
				MsgBox('Pedido de vendas nใo liberado','ATENวรO!!!','ALERT')
				aPvlNfs := {}
				Exit
				
			EndIf
			
			SC6->( DbSetOrder(1) ) //C6_FILIAL + C6_NUM + C6_ITEM + C6_PRODUTO
			If SC6->( DbSeek( xFilial("SC6") + SC9->C9_PEDIDO + SC9->C9_ITEM + SC9->C9_PRODUTO ) )
				While !SC6->( EOF() ) .AND. SC6->C6_NUM == SC9->C9_PEDIDO  .and. SC6->C6_ITEM ==SC9->C9_ITEM  .AND. SC6->C6_PRODUTO==SC9->C9_PRODUTO
					_cQuery := "UPDATE " + RetSqlName('SB2')
					
					//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
					//ณTatiane de Oliveira 05/02/16            ณ
					//ณTrocou o campo b2_salpedi por B2_XTRANSIณ
					//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
					
					
					_cQuery += _cEnter + " SET B2_XTRANSI =B2_XTRANSI +  "+CVALTOCHAR(SC6->C6_QTDVEN)+ ", "
					_cQuery += _cEnter + " B2_XRESERV =B2_XRESERV  - 	"+CVALTOCHAR(SC6->C6_QTDVEN)+ "  "
					_cQuery += _cEnter + " FROM " + RetSqlName('SC6') + " SC6 (NOLOCK)"
					
					_cQuery += _cEnter + " INNER JOIN " + RetSqlName('SF4') + " SF4 (NOLOCK)"
					_cQuery += _cEnter + " ON SF4.D_E_L_E_T_ 			= ''"
					_cQuery += _cEnter + " AND F4_CODIGO 				= '"+SC6->C6_TES+"'"
					_cQuery += _cEnter + " AND F4_ESTOQUE 				= 'S'"
					
					_cQuery += _cEnter + " WHERE SC6.D_E_L_E_T_ 		= ''"
					_cQuery += _cEnter + " AND C6_FILIAL 				= '" + SC5->C5_FILIAL + "'"
					_cQuery += _cEnter + " AND C6_NUM 					= '" + SC5->C5_NUM + "'"
					_cQuery += _cEnter + " AND C6_CLI 					< '000009'"
					_cQuery += _cEnter + " AND SB2010.D_E_L_E_T_ 		= ''"
					_cQuery += _cEnter + " AND B2_FILIAL 				= '"+SC6->C6_LOJA+"'"
					_cQuery += _cEnter + " AND B2_COD 					= '"+SC6->C6_PRODUTO+"'"
					_cQuery += _cEnter + " AND B2_LOCAL 				='"+SC6->C6_LOCAL+"'"
					nValSQL := TcSqlExec(_cQuery)
					
					if nValSQL < 0
						alert("Erro na execu็ใo do SQL - M410STTS - terceira")
					endif
					SC6->( DbSkip() )
				EndDo
			ENDIF
			
			
			SC9->( DbSkip() )
			
		EndDo
		
	Else
		
		MsgBox('Pedido de vendas nใo liberado','ATENวรO!!!','ALERT')
		
	EndIf
	
Else
	
	MsgBox('Pedido de vendas nใo encontrado','ATENวรO!!!','ALERT')
	
EndIf

If !Empty( aPvlNfs )
	
	LimpaMoeda()
	
	//////////////////////////////////////////////////////////////////////
	/////	ponto de entrada para verifica็ใo da numera็ใo da nota fiscal
	//////////////////////////////////////////////////////////////////////
	// ATUALIZA A TABELA DE NOTAS FISCAIS PARA CNPJs QUE TEM MAIS DE UMA FILIAL
	
	DbSelectArea('SM0')
	_cCnpj := SM0->M0_CGC
	Set Filter to  SM0->M0_CGC == _cCnpj .and. SM0->M0_CODIGO == cEmpAnt
	_cFiliais := ''
	_cQueryF  := ''
	DbGotop()
	Do While _cCnpj == SM0->M0_CGC .AND. !eof()
		_cQueryF += _cEnter + "SELECT RIGHT(RTRIM('000000000' + CONVERT(CHAR,CONVERT(INT,RIGHT(RTRIM(MAX(NFE_ID)),9))+1)),9) NOTA"
		_cQueryF += _cEnter + "FROM SPED050 (NOLOCK)"
		_cQueryF += _cEnter + "WHERE ID_ENT = dbo.FN_GETIDSPED" +" ('" + SM0->M0_CODFIL + "')"
		_cQueryF += _cEnter + "AND LEFT(NFE_ID,1) = '" + GetMv('FS_LASSER') +"'"
		_cQueryF += _cEnter + "AND D_E_L_E_T_ = ''"
		_cQueryF += _cEnter + "AND LEN(RTRIM(NFE_ID))>9"
		_cQueryF += _cEnter + "AND DATE_NFE > '201303'"
		If SM0->M0_CODFIL == 'GE'
			_cQueryF += _cEnter + " AND NFE_ID < '8  000045000' "
		EndIf
		_cQueryF += _cEnter + "UNION"
		_cFiliais += SM0->M0_CODFIL + ','
		DbSkip()
	EndDo
	Set Filter To
	DbSeek(cEmpAnt+cFilAnt)
	
	_cFiliais := FormatIn(left(_cFiliais,len(_cFiliais)-1),',')
	
	_cQuery2 := _cEnter + "SELECT ISNULL(MAX(NOTA),'') NOTA"
	_cQuery2 += _cEnter + "FROM"
	_cQuery2 += _cEnter + "("
	_cQuery2 += _cQueryF
	_cQuery2 += _cEnter + "SELECT RIGHT(RTRIM('000000000' + CONVERT(CHAR,CONVERT(INT,RIGHT(RTRIM(MAX(F2_DOC)),9))+1)),9) NOTA"
	_cQuery2 += _cEnter + "FROM SF2010"
	_cQuery2 += _cEnter + "WHERE F2_FILIAL IN " + _cfiliais
	_cQuery2 += _cEnter + "AND F2_SERIE = '" + GetMv('FS_LASSER') + "'"
	_cQuery2 += _cEnter + "AND F2_EMISSAO > '201303'"
	If SM0->M0_CODFIL == 'GE'
		_cQuery2 += _cEnter + " AND F2_DOC < '000045000'"
	EndIf
	_cQuery2 += _cEnter + "AND F2_PDV = ''"
	_cQuery2 += _cEnter + "AND D_E_L_E_T_ = ''"
	_cQuery2 += _cEnter + ") A"
	
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,_cQuery2),"_NF", .T., .T.)
	_cNota := _NF->NOTA
	DbCloseArea()
	_cNota := iif(empty(_cNota),'000000001',_cNota)
	
	_cQuery := "UPDATE " + RetSqlName('SX5')
	_cQuery += _cEnter   + "SET X5_DESCRI = '" + _cNota + "', X5_DESCSPA ='" + _cNota + "', X5_DESCENG ='" + _cNota + "'"
	_cQuery += _cEnter   + "WHERE X5_TABELA = '01'"
	_cQuery += _cEnter   + "AND X5_CHAVE = '" + GetMv('FS_LASSER') + "'"
	_cQuery += _cEnter   + "AND D_E_L_E_T_ = ''"
	_cQuery += _cEnter   + "AND X5_FILIAL IN " + _cFiliais
	
	TcSqlExec(_cQuery)
	
	_aAlias := GetArea()
	
	_cSerie     := left(alltrim(_cSerie) + '    ',3)
	_cNumNFX5F := alltrim(Posicione('SX5',1,cFilAnt + '01' + _cSerie,'X5_DESCRI'))
	DbSelectArea('SX5')
	_xFilial := strtran(strtran(strtran(strtran(_cFiliais,"'",""),"(",""),")",""),",","")
	For _nI := 1 to len(_xFilial) step 2
		If DbSeek(substr(_xFilial,_nI,2) + '01' + _cSerie,.f.)
			Do While !RecLock('SX5',.f.)
			EndDo
		EndIf
	Next
	cNumero := _cNumNFX5F
	
	_cFiltro   := "F1_FILIAL == '" + cFilAnt + "' .and. F1_SERIE == '" + _cSerie + "' .and. F1_FORMUL == 'S'"
	DbSelectArea('SF1')
	IndRegua("SF1",CriaTrab(,.f.),SF1->(IndexKey(1)),,,"Selecionando Registros...")
	Do While SF1->(DbSeek(xFilial('SF1') + padr(_cNumNFX5F,9,' ') + _cSerie,.f.))
		_cNumNFX5F := Soma1(_cNumNFX5F)
	EndDo
	RetIndex()
	
	SF2->(DbSetOrder(1))
	Do While SF2->(DbSeek(xFilial('SF2') + padr(_cNumNFX5F,9,' ') + _cSerie,.f.))
		_cNumNFX5F := Soma1(_cNumNFX5F)
	EndDo
	
	DbSelectArea('SX5')
	_xFilial := strtran(strtran(strtran(strtran(_cFiliais,"'",""),"(",""),")",""),",","")
	For _nI := 1 to len(_xFilial) step 2
		If DbSeek(substr(_xFilial,_nI,2) + '01' + _cSerie,.f.)
			MsUnLock()
		EndIf
	Next
	For _nI := 1 to len(_xFilial) step 2
		If DbSeek(substr(_xFilial,_nI,2) + '01' + _cSerie,.f.)
			RecLock('SX5',.f.)
			SX5->X5_DESCRI  := _cNumNFX5F
			SX5->X5_DESCSPA := _cNumNFX5F
			SX5->X5_DESCENG := _cNumNFX5F
			MsUnLock()
		EndIf
	Next
	
	RestArea(_aAlias)
	//////////////////////////////////////////////////////////////////////
	_cNota := MaPvlNfs(aPvlNfs,;
	_cSerie,;
	lMostraCtb,;
	lAglutCtb,;
	lCtbOnLine,;
	lCtbCusto,;
	lReajuste,;
	nCalAcrs,;
	nArredPrcLis,;
	lAtuSA7,;
	lECF,;
	'',;
	,;
	NIL )
	
	_cNota := PadR(_cNota,9,' ')
	
	//IIF( TRAB->UA5_VLRDES >0, NIL, { || CompleNFS() } ) )
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณDestrava o controle de numeracao                                        ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	//			SX5->( MsRUnLock() )
	//	EndIf
	
EndIf
//Atualiza a tabela


// Retorna as areas originais
RestArea( aAreaSF4 )
RestArea( aAreaSB2 )
RestArea( aAreaSB1 )
RestArea( aAreaSE4 )
RestArea( aAreaSC9 )
RestArea( aAreaSC6 )
RestArea( aAreaSC5 )
RestArea( aAreaAnt )




Return( _cNota )



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ Encerra  บAutor  ณ Deosdete P. Silva  บ Data ณ  05/07/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Encerramento da distribui็ใo, classificando a pre-nota e   บฑฑ
ฑฑบ          | integrando estoque e financeiro                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Laselva Bookstore                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function ls_Encerra()
//////////////////////////

Local cFornecedor := ""
Local cLoja       := ""
Local aAreaSC6    := SC6->( GetArea() )
Local _ITEMori	  :=""
u_LS_Pesquisa(.f.)

Private aCab        :=  {}
Private aItens      :=  {}
Private aLinha      := 	{}
Private lMsErroAuto := .F.

If TRB->(EOF())
	Alert("Arquivo Vazio")
	Return
EndIf

If TRB->PA6_FILDES != cFilAnt
	Alert("O encerramento pode ser feito apenas na filial de destino")
	Return
EndIf

_cCNPJOrigem := SM0->M0_CGC
_cEstOrigem  := SM0->M0_ESTENT

SM0->(dbSetOrder(1))
SM0->( dbSeek(cEmpAnt + TRB->PA6_FILORI))

//cFornecedor := GetAdvFVal("SA2","A2_COD",xFilial("SA2")+SM0->M0_CGC,3)

_cQuery := "SELECT A2_COD"
_cQuery += " FROM " + RetSqlName('SA2') + " (NOLOCK)"
_cQuery += " WHERE A2_COD < '000009'"
_cQuery += " AND A2_CGC = '"  + SM0->M0_CGC + "'"
_cQuery += " AND A2_MSBLQL = '2'"
DbUseArea( .T., "TOPCONN", TcGenQry(,,_cQuery),"CNPJ", .T., .T.)
cFornecedor := CNPJ->A2_COD
DbCloseArea()

cLoja		:= SM0->M0_CODFIL
cFornec     := SM0->M0_CGC
cEstado 	:= SM0->M0_ESTENT

If Empty(cFornecedor) .or. Empty(cLoja)
	Alert("A filial " + SM0->M0_FILIAL+ " nใo esta cadastrada como fornecedor")
	Return
EndIf

//Verifica status atual
If TRB->PA6_STATUS == "05"  //Recebido
	If SF1->(DbSeek(xFilial('SF1') + TRB->PA6_NFS + TRB->PA6_SERIE + cFornecedor + cLoja,.F.))
		RecLock('TRB',.f.)
		TRB->PA6_NFE    := TRB->PA6_NFS
		TRB->PA6_STATUS := '06'
		TRB->PA6_DESCST := 'ENCERRADO'
		MsUnLock()
		
		PA6->(DbSetOrder(1))
		If PA6->(DbSeek( xFilial("PA6")+TRB->PA6_NUMROM ))
			RecLock("PA6",.F.)
			PA6->PA6_STATUS := "06"	//Encerrado
			PA6->PA6_NFE    := TRB->PA6_NFS
			Msunlock()
		EndIf
		
		PA7->(DbSetOrder(1))
		If PA7->(DbSeek( xFilial("PA7")+TRB->PA6_NUMROM ))
			RecLock("PA7",.F.)
			PA7->PA7_STATUS := "06"	//Encerrado
			Msunlock()
		EndIf
		
		Alert("Romaneio encerrado. Nota fiscal de entrada gerada ")
		Return(.t.)
	EndIf
	
ElseIf TRB->PA6_STATUS == "06"  //Encerrado
	
	If SF1->(DbSeek(xFilial('SF1') + TRB->PA6_NFS + TRB->PA6_SERIE + cFornecedor + cLoja,.F.))
		RecLock('TRB',.f.)
		TRB->PA6_NFE    := TRB->PA6_NFS
		TRB->PA6_STATUS := '06'
		TRB->PA6_DESCST := 'Encerrado'
		MsUnLock()
		
		PA6->(DbSetOrder(1))
		If PA6->(DbSeek( xFilial("PA6")+TRB->PA6_NUMROM ))
			RecLock("PA6",.F.)
			PA6->PA6_STATUS := "06"	//Encerrado
			PA6->PA6_NFE    := TRB->PA6_NFS
			Msunlock()
		EndIf
		
		PA7->(DbSetOrder(1))
		If PA7->(DbSeek( xFilial("PA7")+TRB->PA6_NUMROM ))
			RecLock("PA7",.F.)
			PA7->PA7_STATUS := "06"	//Encerrado
			Msunlock()
		EndIf
		
		
		Alert("Romaneio encerrado. Nota fiscal de entrada gerada ")
	Else
		Alert("Este romaneio jแ foi encerrado.")
	EndIf
	Return(.T.)
EndIf

If TRB->PA6_STATUS <> "05"  //Recebimento Ok
	Alert("Este romaneio ainda nใo foi recebido. Nใo pode ser encerrado.")
	Return(.T.)
EndIf

SF2->(DbSetOrder(1))
SF2->(DbGoTop())
If !SF2->(DbSeek(TRB->PA6_FILORI + TRB->PA6_NFS + TRB->PA6_SERIE))
	Alert("Nota fiscal " + TRB->PA6_NFS + " nใo encontrada na filial " + TRB->PA6_FILORI)
	Return
EndIf

// *******************************************

If AllTrim(SM0->M0_CODFIL) $ "01/55"
	cTipoEmp := "M"
ElseIf Substr(SM0->M0_CGC,1,8) $ GetMv("MV_LSVCNPJ").or. left(SM0->M0_CGC,8) == left(cFornec,8)
	cTipoEmp := "F"
Else
	cTipoEmp := "C"
EndIf

//SM0->( dbSeek(cEmpAnt + cFilAnt))

// *******************************************

_cPedCom := ''

If cFilAnt $ '01/55' .and. cLoja == 'C0'
	_cPedCom := Posicione('SC5',1,TRB->PA6_FILORI + left(TRB->PA6_NUMROM,6),'C5_COTACAO')
EndIf

aAdd(aCab,{"F1_TIPO",			SF2->F2_TIPO		 		, 	Nil		})
aAdd(aCab,{"F1_FORMUL",      	"N" 						, 	Nil		})
aAdd(aCab,{"F1_DOC",         	strzero(val(SF2->F2_DOC),9)	, 	Nil		})
aAdd(aCab,{"F1_SERIE",      	SF2->F2_SERIE				, 	Nil		})
aAdd(aCab,{"F1_EMISSAO",     	SF2->F2_EMISSAO				, 	Nil		})
aAdd(aCab,{"F1_FORNECE",     	cFornecedor					, 	Nil		})
aAdd(aCab,{"F1_LOJA",        	cLoja						, 	Nil		})
aAdd(aCab,{"F1_ESPECIE",     	SF2->F2_ESPECIE				, 	Nil		})
aAdd(aCab,{"F1_COND",			"001"						, 	Nil		})
aAdd(aCab,{"F1_CHVNFE",	SF2->F2_CHVNFE		, Nil })
//aAdd(aCab,{"F1_DESCONT",		SF2->F2_DESCONT				, 	Nil		})
//Localizar item da NF
//Indice 3 -D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
SD2->(DbSetOrder(3))
If !SD2->(DbSeek(TRB->PA6_FILORI+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA))
	Alert("Nota fiscal " + F2_DOC + " nใo tem item ")
	Return
EndIf
_lNaoTemTes := .f.
_cNaoTemTes := ''

_aBloq := {}
Do While !SD2->(Eof()) .And. (SD2->D2_FILIAL   	== TRB->PA6_FILORI;
	.And. SD2->D2_DOC   	== SF2->F2_DOC;
	.And. SD2->D2_SERIE     == SF2->F2_SERIE;
	.And. SD2->D2_CLIENTE   == SF2->F2_CLIENTE;
	.And. SD2->D2_LOJA      == SF2->F2_LOJA)
	
	nRecno := SD2->( Recno() )
	If Posicione('SB1',1,xFilial('SB1') + SD2->D2_COD,'B1_MSBLQL') == '1'
		aAdd(_aBloq,SB1->B1_COD)
		RecLock('SB1',.f.)
		SB1->B1_MSBLQL := '2'
		MsUnLock()
		DbSelectArea('SD2')
	EndIf
	
	// *********************************************************************   //1000302
	If left(cFornec,8) $ GetMv("MV_LSVCNPJ") .or. left(SM0->M0_CGC,8) == left(cFornec,8)
		_cTes := Posicione('SBZ',1,xFilial('SBZ') + SD2->D2_COD,'BZ_TE')
	ElseIf left(cFornec,8) $ GetMv("MV_CNPJLSV") .AND. cTipoEmp == "M"
		_cTes := Posicione('SBZ',1,xFilial('SBZ') + SD2->D2_COD,'BZ_TEC')
	Else
		_cTes := Posicione('SBZ',1,xFilial('SBZ') + SD2->D2_COD,'BZ_TE_FORN')
	EndIf
	
	If empty(_cTes)
		If left(cFornec,8) $ GetMv("MV_LSVCNPJ") .or. left(SM0->M0_CGC,8) == left(cFornec,8)
			_cTes := Posicione('SZQ',1,xFilial('SZQ') + SB1->B1_GRUPO+cTipoEmp,'ZQ_TE')
		ElseIf left(cFornec,8) $ GetMv("MV_CNPJLSV") .AND. cTipoEmp == "M"
			_cTes := Posicione('SZQ',1,xFilial('SZQ') + SB1->B1_GRUPO+cTipoEmp,'ZQ_TEC')
		Else
			_cTes := Posicione('SZQ',1,xFilial('SZQ') + SB1->B1_GRUPO+cTipoEmp,'ZQ_FORN')
		EndIf
	EndIf
	// *************************************************************************
	
	//	If xFilial('SF1') $ '01/55' .or. _lNaoTemTes
	aAdd(aLinha,{"D1_ITEM",		strzero(len(aItens)+1,4), 	Nil	})
	//	else
	//		aAdd(aLinha,{"D1_ITEM",		SD2->D2_ITEM, 	Nil	})
	//	endif
	
	aAdd(aLinha,{"D1_COD", 		SD2->D2_COD, 	Nil	})
	aAdd(aLinha,{"D1_UM", 		SD2->D2_UM, 	Nil	})
	
	
	aAdd(aLinha,{"D1_QUANT",	SD2->D2_QUANT, 	Nil	})
	
	//If SD2->D2_DESCON + SD2->D2_DESC > 0 .and. SD2->D2_PRUNIT == SD2->D2_PRCVEN
	_nPrUnit := ROUND((SD2->D2_DESCON + SD2->D2_TOTAL) / SD2->D2_QUANT,2)
	_nDescont := round(SD2->D2_DESCON * 100 / (SD2->D2_DESCON + SD2->D2_TOTAL),2)
	aAdd(aLinha,{"D1_VUNIT",	_nPrUnit,	Nil	})
	aAdd(aLinha,{"D1_TOTAL",	SD2->D2_QUANT * _nPrUnit, 	Nil	})
	aAdd(aLinha,{"D1_DESC",		round(SD2->D2_DESCON * 100 / (SD2->D2_DESCON + SD2->D2_TOTAL),0), 	Nil	})
	aAdd(aLinha,{"D1_VALDESC",	SD2->D2_DESCON,	Nil	})
	/*
	Else
	aAdd(aLinha,{"D1_VUNIT",	SD2->D2_PRUNIT,	Nil	})
	aAdd(aLinha,{"D1_TOTAL",	SD2->D2_QUANT * SD2->D2_PRUNIT, 	Nil	})
	aAdd(aLinha,{"D1_DESC",		SD2->D2_DESC, 	Nil	})
	EndIf
	*/
	If empty(_cTes)
		_lNaoTemTes := .t.
		_cNaoTemTes +=  'Item: ' + strzero(len(aItens)+1,4) + '  Produto: ' + SD2->D2_COD + _cEnter
	EndIf
	
	
	If !(xFilial('SF1') $ '01/55')
		aAdd(aLinha,{"D1_TES",   	_cTes		,  	Nil	})
	EndIf
	
	
	aAdd(aLinha,{"D1_LOCAL",	SD2->D2_LOCAL	, 	Nil	})
	aAdd(aLinha,{"D1_PESO",		SD2->D2_PESO	, 	Nil	})
	aAdd(aLinha,{"D1_TP",		SD2->D2_TP		, 	Nil	})
	aAdd(aLinha,{"D1_TIPO_NF",	" "				,	Nil	})
	
	
	If !empty(SD2->D2_NFORI)
		
		DbSelectArea("SA1")
		SA1->( DbSetOrder(10) )  						// SA1->( DbSetOrder(9) ) - ALTERADO EM 26/05/15 - ILIDIO
		SA1->( DbSeek(SM0->M0_CGC+SM0->M0_CODFIL) )
		
		aAdd(aLinha,{"D1_NFORI",	SD2->D2_NFORI,	 			Nil	})
		aAdd(aLinha,{"D1_SERIORI",	SD2->D2_SERIORI, 			Nil	})
		_ITEMori:=SD2->D2_ITEMORI
		_cIdentB6 := Posicione("SD2",3,SF2->F2_LOJA+SD2->D2_NFORI+SD2->D2_SERIORI+SA1->A1_COD+SA1->A1_LOJA+SD2->D2_COD+RIGHT(_ITEMori,2),"D2_IDENTB6")
		
		If !empty(_cIdentB6)
			aAdd(aLinha,{"D1_IDENTB6",	_cIdentB6, Nil	})
			aAdd(aLinha,{"D1_ITEMORI",	RIGHT(_ITEMori,2), 			Nil	})
		else
			_cIdentB6 := Posicione("SD2",3,SF2->F2_LOJA+SD2->D2_NFORI+SD2->D2_SERIORI+SA1->A1_COD+SA1->A1_LOJA+SD2->D2_COD+_ITEMori,"D2_IDENTB6")
			If !empty(_cIdentB6)
				aAdd(aLinha,{"D1_IDENTB6",	_cIdentB6, Nil	}) 
				aAdd(aLinha,{"D1_ITEMORI",	_ITEMori, 			Nil	})
			ELSE   
			if SF2->F2_TIPO=='D'
			aAdd(aLinha,{"D1_ITEMORI",	RIGHT(_ITEMori,2), 			Nil	}) 
			else
			
			aAdd(aLinha,{"D1_ITEMORI",	_ITEMori, 			Nil	})
			endif
			endif
		EndIf
		
		
		
		If !empty(_cPedCom)
			_nLenItem := len(alltrim(Posicione('SC7',1,xFilial('SC7')+_cPedCom,'C7_ITEM')))
			
			// Bloco para verificar qual a numera็ใo correta para lan็amento do DOC.ENTRADA para classifica็ใo
			// Tratamento necessแrio para quando PV tiver mais que 99 itens
			// Thiago Queiroz - 27/11/13
			_nItemPV 		:= "0099" //SD2->D2_ITEMPV
			_nItemPvCont	:= 0 //99
			_nItemPC		:= VAL(Posicione('SC7',4,xFilial('SC7')+SD2->D2_COD+_cPedCom,'C7_ITEM'))
			
			dbSelectArea("SC7")
			dbSetOrder(4)
			dbSeek(xFilial("SC7")+SD2->D2_COD+_cPedCom)
			WHILE SC7->C7_NUM == _cPedCom .AND. SC7->C7_PRODUTO == SD2->D2_COD
				_nPosArray		:= aScan(aItens ,{|x| x[14][2] == SC7->C7_ITEM })
				
				IF LEN(aItens) == 0
					_nItemPC := val(SC7->C7_ITEM)
				ELSE
					IF _nPosArray == 0 .AND. SD2->D2_QUANT == SC7->C7_QUANT
						_nItemPC := val(SC7->C7_ITEM)
						Exit
					ENDIF
				ENDIF
				dbSelectArea("SC7")
				dbSkip()
			ENDDO
			
			IF ( SD2->D2_ITEMPV > "0099" ) .OR. ( _nItemPC > 99 )
				WHILE _nItemPvCont != _nItemPC //( _nItemPV != SD2->D2_ITEMPV ) .AND. ( _nItemPvCont != _nItemPC )
					_nItemPV 		:= SOMA1(_nItemPV)
					_nItemPvCont	:= _nItemPvCont	+ 1
				ENDDO
			ENDIF
			// Fim do bloco de tratamento
			
			aAdd(aLinha,{"D1_PEDIDO",	_cPedCom									,	Nil	})
			// Se o PV tiver mais que 99 itens, utiliza o _nItemPvCont, caso contrario utiliza o SD2->D2_ITEMPV
			//		IF _nItemPvCont <= 99
			//			aAdd(aLinha,{"D1_ITEMPC",	strzero(val(SD2->D2_ITEMPV),_nLenItem)	, 	Nil	})
			//		ELSE
			aAdd(aLinha,{"D1_ITEMPC",	strzero(_nItemPvCont,_nLenItem)			, 	Nil	})
			//		ENDIF
		EndIf
		
		
		SD2->( DbGoTo(nRecno) )
		
	EndIf
	
	SD2->(DbSkip())
	aAdd( aItens, aLinha )
	aLinha := {}
EndDo

_cPerg     := cPerg
_cCadastro := cCadastro
_aRotina   := aClone(aRotina)
_aCores    := aClone(aCores)

If _lNaoTemTes
	MsgBox('Itens com TES indefinidas (serแ gerada uma pr้-nota):' + _cEnter + _cEnter + _cNaoTemTes,'ATENวรO!!!','ALERT')
EndIf
If xFilial('SF1') $ '01/55' .or. _lNaoTemTes
	MsAguarde({|| MSExecAuto({|x,y,z|Mata140(x,y,z)},aCab,aItens,3)},"Aguarde...","Gerando pr้-nota de entrada",.T.)
	_cQuery := "UPDATE SD1"
	_cQuery += _cEnter + " SET 	D1_VUNIT = D2_PRUNIT, D1_TOTAL = D1_QUANT * D2_PRUNIT, D1_DESC = round(D2_DESCON * 100 / (D2_DESCON + D2_TOTAL),0), D1_VALDESC = D2_DESCON"
	_cQuery += _cEnter + " FROM " + RetSqlName('SD1') + " SD1 (NOLOCK)"
	
	_cQuery += _cEnter + " INNER JOIN " + RetSqlName('SD2') + " SD2 (NOLOCK)"
	_cQuery += _cEnter + " ON D2_FILIAL = D1_LOJA"
	_cQuery += _cEnter + " AND D2_LOJA = D1_FILIAL"
	_cQuery += _cEnter + " AND D2_COD = D1_COD"
	_cQuery += _cEnter + " AND D2_QUANT = D1_QUANT"
	_cQuery += _cEnter + " AND D2_DOC = '" + SF2->F2_DOC + "'"
	_cQuery += _cEnter + " AND D2_SERIE = '" + SF2->F2_SERIE + "'"
	_cQuery += _cEnter + " AND SD2.D_E_L_E_T_ = ''"
	
	_cQuery += _cEnter + " WHERE D1_FILIAL = '" + xFilial('SD1') + "'"
	_cQuery += _cEnter + " AND D1_DOC = '" + SF2->F2_DOC + "'"
	_cQuery += _cEnter + " AND D1_SERIE = '" + SF2->F2_SERIE + "'"
	_cQuery += _cEnter + " AND D1_LOJA = '" + SF2->F2_FILIAL + "'"
	_cQuery += _cEnter + " AND SD1.D_E_L_E_T_ = ''"
	MsAguarde({|| TcSqlExec(_cQuery)},'Ajustando Nota Fiscal')
	
Else
	MsAguarde({|| MSExecAuto({|x,y,z|Mata103(x,y,z)},aCab,aItens,3)},"Aguarde...","Gerando nota de entrada",.T.)
EndIf

If lMsErroAuto
	MostraErro()
EndIf


If .F. //!empty(_cPedCom)
	_cQuery := "UPDATE SD1"
	_cQuery += _cEnter + " SET D1_PEDIDO = C7_NUM, D1_ITEMPC = C7_ITEM"
	_cQuery += _cEnter + " FROM " + RetSqlName('SD1') + " SD1 (NOLOCK)"
	
	_cQuery += _cEnter + " INNER JOIN " + RetSqlName('SC7') + " SC7 (NOLOCK)"
	_cQuery += _cEnter + " ON C7_FILIAL = D1_FILIAL"
	_cQuery += _cEnter + " AND C7_LOJA = D1_LOJA"
	_cQuery += _cEnter + " AND C7_PRODUTO = D1_COD"
	_cQuery += _cEnter + " AND C7_QUANT = D1_QUANT"
	_cQuery += _cEnter + " AND C7_QUJE + C7_QTDACLA = 0"
	_cQuery += _cEnter + " AND C7_NUM = '" + _cPedCom + "'"
	_cQuery += _cEnter + " AND SC7.D_E_L_E_T_ = ''"
	
	_cQuery += _cEnter + " WHERE D1_FILIAL = '" + xFilial('SD1') + "'"
	_cQuery += _cEnter + " AND D1_DOC = '" + SF2->F2_DOC + "'"
	_cQuery += _cEnter + " AND D1_SERIE = '" + SF2->F2_SERIE + "'"
	_cQuery += _cEnter + " AND SD1.D_E_L_E_T_ = ''"
	MsAguarde({|| TcSqlExec(_cQuery)},'Ajustando Nota Fiscal')
	
	_cQuery := "UPDATE SC7"
	If xFilial('SF1') $ '01/55'
		_cQuery += _cEnter + " SET C7_QTDACLA = D1_QUANT, C7_NFISCAL = D1_DOC + D1_SERIE, C7_ITEMNF = D1_ITEM"
	Else
		_cQuery += _cEnter + " SET C7_QUJE = D1_QUANT, C7_NFISCAL = D1_DOC + D1_SERIE, C7_ITEMNF = D1_ITEM, C7_ENCER = 'E'"
	EndIf
	_cQuery += _cEnter + " FROM " + RetSqlName('SD1') + " SD1 (NOLOCK)"
	
	_cQuery += _cEnter + " INNER JOIN " + RetSqlName('SC7') + " SC7 (NOLOCK)"
	_cQuery += _cEnter + " ON C7_FILIAL = D1_FILIAL"
	_cQuery += _cEnter + " AND C7_LOJA = D1_LOJA"
	_cQuery += _cEnter + " AND C7_PRODUTO = D1_COD"
	_cQuery += _cEnter + " AND C7_QUANT = D1_QUANT"
	_cQuery += _cEnter + " AND C7_QUJE = 0"
	_cQuery += _cEnter + " AND C7_NUM = '" + _cPedCom + "'"
	_cQuery += _cEnter + " AND SC7.D_E_L_E_T_ = ''"
	
	_cQuery += _cEnter + " WHERE D1_FILIAL = '" + xFilial('SD1') + "'"
	_cQuery += _cEnter + " AND D1_DOC = '" + SF2->F2_DOC + "'"
	_cQuery += _cEnter + " AND D1_SERIE = '" + SF2->F2_SERIE + "'"
	_cQuery += _cEnter + " AND SD1.D_E_L_E_T_ = ''"
	MsAguarde({|| TcSqlExec(_cQuery)},'Ajustando Pedido de Compras')
	
EndIf


DbSelectArea('SB1')
For _nI := 1 to len(_aBloq)
	If DbSeek(xFilial('SB1') + _aBloq[_nI],.f.)
		RecLock('SB1',.f.)
		SB1->B1_MSBLQL := '1'
		MsUnLock()
	EndIf
Next

aRotina   := aClone(_aRotina)
aCores    := aClone(_aCores)
cCadastro := _cCadastro
cPerg     := _cPerg
Pergunte(cPerg,.f.)

PA6->(DbSetOrder(1))
If PA6->(DbSeek( xFilial("PA6")+TRB->PA6_NUMROM )) .and. !lMsErroAuto
	
	Reclock("TRB",.F.)
	TRB->PA6_STATUS := "06"	//Encerrado
	TRB->PA6_NFE    := 	TRB->PA6_NFS
	MsUnlock()
	
	RecLock("PA6",.F.)
	PA6->PA6_STATUS := "06"	//Encerrado
	PA6->PA6_NFE    := 	TRB->PA6_NFS
	Msunlock()
	
	
	
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณTATIANE DE OLIVEIRA VAI COMPLEMENTAR O FONTEณ
	//ณABAIXO PARA TROCAR O STATUS DOS ITENS DO    ณ
	//ณROMANEIO                                    ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	PA7->(DbSetOrder(1))
	If PA7->(DbSeek( xFilial("PA7")+TRB->PA6_NUMROM )) .and. !lMsErroAuto
		
		RecLock("PA7",.F.)
		PA7->PA7_STATUS := "06"	//Encerrado
		Msunlock()
		
	ENDIF
	
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณFIM DO COMPLEMENTOณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	
	DbSelectArea('TRB')
	DbgoTop()
	
	If xFilial('SF1') $ '01/55' .or. _lNaoTemTes
		MsgBox('Romaneio encerrado com sucesso.' + _cEnter + 'Classificar a Nota Fiscal de entrada','ATENวรO!!!','INFO')
	Else
		MsgBox('Romaneio encerrado e nota fiscal de entrada gerada com sucesso.' + _cEnter + 'Jแ estแ classificada','ATENวรO!!!','INFO')
	EndIf
	
	Return(.t.)
	
Else
	
	MostraErro()
	DbSelectArea('TRB')
	Return
	
Endif


//1018281317414 - 1814320118147
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LS_Pesquisa(_lCodBar)
//////////////////////////////////

Private _cRom := Space(iif(_lCodBar,8,13))
Private _lOk  := .f.
Private _oDlgPsq

DEFINE MSDIALOG _oDlgPsq TITLE "Pesquisa" FROM 0,0 TO 200,300 PIXEL
@ 08,20 SAY iif(_lCodBar,"Romaneio",'C๓digo de barras')	PIXEL OF _oDlgPsq
If _lCodBar
	@ 06,50 MSGET oRom VAR _cRom PICTURE "@!"	PIXEL OF _oDlgPsq
	@ 30,20 BUTTON "Ok"  		SIZE 31,10 ACTION (_lOk := .t.,_oDlgPsq:End())	PIXEL OF _oDlgPsq
Else
	@ 06,70 MSGET oRom VAR _cRom PICTURE "@!"	PIXEL OF _oDlgPsq VALID empty(_cRom) .or. (_lCodBar .or. VLCODBAR())
EndIf
@ 30,70 BUTTON "Cancela"	SIZE 30,10 ACTION (_lOk := .f.,_oDlgPsq:End())	PIXEL OF _oDlgPsq
ACTIVATE MSDIALOG _oDlgPsq CENTERED

If _lOk
	If !empty(_cRom)
		DbSelectArea("TRB")
		TRB->( DbsetOrder(1) )
		If TRB->( !DbSeek(_cRom,.F.) )
			MsgStop("Romaneio nใo encontrado!")
		EndIf
	EndIf
EndIf
SysRefresh()

Return(Nil)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function VLCODBAR()
/////////////////////////
Local _lRet := .t.

_nDv     := 0
_cCodBar := Embaralha(_cRom,0)
_cDv1    := right(_cCodBar,1)
_cCodBar := left(_cCodBar,12)

For _nI := 1 to 12
	_nDv += val(substr(_cCodBar,_nI,1))
Next
Do While _nDv > 10
	_cDv := strzero(_nDv,3)
	_nDv := 0
	For _nI := 1 to 3
		_nDv += val(substr(_cDv,_nI,1))
	Next
EndDo
If _cDv1 == iif(_nDv == 10,'0',str(_nDv,1))
	_lOk := .t.
	_oDlgPsq:End()
	_cRom := left(_cCodBar,8)
Else
	_lRet := .f.
	_lOk  := .f.
	_cRom := space(13)
	MsgBox('C๓digo de barras invแlido','ATENวรO!!!','ALERT')
EndIf

Return(_lRet)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function _VisNFS(_xPar)
///////////////////////
u_LS_Pesquisa(.f.)
_cFilAnt := cFilAnt
If _xPar == 1   // nota fiscal de saida
	
	If empty(TRB->PA6_NFS)
		MsgStop('Nota fiscal de entrada ainda nใo foi gerada','ATENวรO!!!')
		Return()
	EndIf
	
	cFilAnt   := right(TRB->PA6_NUMROM,2)
	_cCliente := Posicione('SC6',1, cFilAnt + left(TRB->PA6_NUMROM,6),'C6_CLI') + SC6->C6_LOJA
	DbSelectArea('SF2')
	DbSetOrder(1)
	If !DbSeek(cFilAnt + TRB->PA6_NFS + TRB->PA6_SERIE + _cCliente, .F.)
		MsgStop('Nota Fiscal nใo localizada. Contate o administrador do sistema','ATENวรO!!!')
		DbSelectArea('PA6')
		cFilAnt  := _cFilAnt
		Return()
	EndIf
	
	NAUTOADT := 0
	MC090Visual()
	
ElseIf _xPar == 2	// nota fiscal de entrada
	
	If empty(TRB->PA6_NFE)
		MsgAlert('Nota fiscal de entrada ainda nใo foi gerada','ATENวรO!!!')
		Return()
	EndIf
	
	cFilAnt   := TRB->PA6_FILDES
	
	_cQuery := "SELECT A1_COD"
	_cQuery += _cEnter + "FROM " + RetSqlName('SA1') + " SA1 (NOLOCK)"
	_cQuery += _cEnter + "WHERE A1_LOJA = '" + TRB->PA6_FILORI + "'"
	_cQuery += _cEnter + "AND A1_COD < '000009'"
	_cQuery += _cEnter + "AND A1_MSBLQL = '2'"
	_cQuery += _cEnter + "AND SA1.D_E_L_E_T_ = ''"
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,_cQuery),"FORNECE", .T., .T.)
	_cFornece := FORNECE->A1_COD
	DbCloseArea()
	
	cLoja		:= right(TRB->PA6_NUMROM,2)
	
	DbSelectArea('SF1')
	DbSetOrder(1)
	If !DbSeek(cFilAnt + TRB->PA6_NFE + TRB->PA6_SERIE + _cFornece + cLoja, .F.)
		MsgAlert('Nota Fiscal nใo localizada. Contate o administrador do sistema','ATENวรO!!!')
		DbSelectArea('TRB')
		cFilAnt  := _cFilAnt
		Return()
	EndIf
	
	A103NFiscal('TRB',,2)
	
Else	//	pedido de vendas
	
	cFilAnt  := right(PA6->PA6_NUMROM,2)
	NAUTOADT := 0
	DbSelectArea('SC5')
	DbSeek(right(PA6->PA6_NUMROM,2) + left(PA6->PA6_NUMROM,6),.f.)
	A410Visual(alias(),recno(),2)
	
EndIf

cFilAnt  := _cFilAnt
DbSelectArea('TRB')

Return()
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณINFVOL    บAutor  ณ Fabio Jadao Caires บ Data ณ  20/06/2007 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Exibe tela para a informacao da quantidade de volumes      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Laselva                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function ls_InfVol()

Private nGetNrVol	 := "  "
Private oGetNrVol

Private oDlg2				// Dialog Principal

Private VISUAL := .F.
Private INCLUI := .F.
Private ALTERA := .F.
Private DELETA := .F.

If TRB->PA6_STATUS <> '02' .And. !IsInCallStack("p_GrvRom")
	Aviso("Aten็ใo","A etiqueta s๓ pode ser impressa com o pedido separado.",{"OK"})
	Return
EndIf

DEFINE MSDIALOG oDlg2 TITLE "Impressใo de etiquetas" FROM C(178),C(181) TO C(392),C(510) PIXEL

@ C(013),C(006) Say "Filial : " 					Size C(015),C(008) COLOR CLR_BLACK PIXEL OF oDlg2
@ C(013),C(023) Say Alltrim(TRB->PA6_LOJA) 	Size C(057),C(008) COLOR CLR_BLACK PIXEL OF oDlg2
@ C(025),C(006) Say "Romaneio :" 				Size C(027),C(008) COLOR CLR_BLACK PIXEL OF oDlg2
@ C(026),C(035) Say Alltrim(TRB->PA6_NUMROM)	Size C(033),C(008) COLOR CLR_BLACK PIXEL OF oDlg2
@ C(026),C(090) Say "Carga : " 					Size C(020),C(008) COLOR CLR_BLACK PIXEL OF oDlg2
@ C(026),C(112) Say Alltrim(TRB->PA6_CARGA)	Size C(043),C(008) COLOR CLR_BLACK PIXEL OF oDlg2

@ C(056),C(006) Say "Qtd. Volumes" 				Size C(042),C(008) COLOR CLR_BLACK PIXEL OF oDlg2
@ C(056),C(053) MsGet oGetNrVol Var nGetNrVol Size C(104),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlg2 Valid Val(nGetNrVol) > 0

@ C(086),C(119) Button "Ok" Size C(037),C(012) PIXEL OF oDlg2 ACTION ( U_LS_GrvVol(),oDlg2:End() )


ACTIVATE MSDIALOG oDlg2 CENTERED

Return(.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGrvVol    บAutor  ณ Fabio Jadao Caires บ Data ณ  18/06/2007 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณConfirmacao da gravacao dos volumes do romaneio para confe- บฑฑ
ฑฑบ          ณrencia da expedicao e no recebimento.                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Laselva                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function LS_GrvVol()

Local nI 		:= 0
Local cCodVol	:= Space(16)
Local aEtiq		:= {}

DbSelectArea("PA8")
DbSetOrder(1) // PA8_FILIAL+PA8_NUMROM+PA8_CODCOL

nGetNrVol := Val(nGetNrVol)
Begin Transaction
//Procura se ja existem volumes gravados para este romaneio
If PA8->( DbSeek(xFilial("PA8") + TRB->PA6_NUMROM ) )
	If !MsgYesNo("Jแ existe(m) "+Str( Val(RIGHT(PA8->PA8_CODCOL,3)) )+" volume(s) para este romaneio." + _cEnter + "Deseja apagar as etiquetas antigas e gerar novas?")
		DisarmTransaction()
		Return
	Else
		While !PA8->(EOF()) .AND. PA8->PA8_NUMROM == TRB->PA6_NUMROM
			RecLock("PA8",.F.)
			DbDelete()
			MsUnlock()
			PA8->(DbSkip())
		EndDo
	EndIf
EndIf

For nI := 1 to nGetNrVol
	
	cCodVol 	:= Alltrim(TRB->PA6_NUMROM) + StrZero(nI,3) + StrZero(nGetNrVol,3)
	If PA8->( DbSeek(xFilial("PA8") + TRB->PA6_NUMROM + cCodVol) )
		Reclock("PA8", .F.)
	Else
		Reclock("PA8", .T.)
	EndIf
	PA8->PA8_FILIAL	:= xFilial("PA8")
	PA8->PA8_NUMROM	:= TRB->PA6_NUMROM
	PA8->PA8_CODCOL	:= cCodVol
	
	PA8->PA8_CODST		:= "01" //Volume nao verificado
	PA8->PA8_STATUS	:= Space(25)
	
	MsUnlock()
	
	// Codigo a ser impresso no c๓digo de barras
	AAdd(aEtiq,{TRB->PA6_LOJA,TRB->PA6_NUMROM,TRB->PA6_DTROM,TRB->PA6_CARGA,TRB->PA6_FILORI,TRB->PA6_FILDES,cCodVol})
	
Next nI

// Atualiza a qtd de volumes da TRB (tabela temporaria)
Reclock("TRB",.F.)
TRB->PA6_VOL := nGetNrVol
Msunlock()

// e tambem na tabela PA6 original
PA6->(DbSetOrder(1))
If PA6->(DbSeek( xFilial("PA6")+TRB->PA6_NUMROM ))
	
	RecLock("PA6",.F.)
	PA6->PA6_VOL := nGetNrVol
	PA6->PA6_USER := cUserName
	Msunlock()
	
EndIf

End Transaction

Return
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ***************************************************************************************************************** //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LerData(x,y)

Local cData

If y == 6
	cData := Substr(xBuffer,x,2)+"/"+Substr(xBuffer,x+2,2)+"/"+Substr(xBuffer,x+4,2)
Elseif y == 8
	cData := Substr(xBuffer,x,2)+"/"+Substr(xBuffer,x+2,2)+"/"+Substr(xBuffer,x+4,4)
Endif

dDataBase := CtoD(cData,"ddmmyy")

Return " "
