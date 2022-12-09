#INCLUDE 'RWMAKE.CH'
#INCLUDE 'PROTHEUS.CH'

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³ RPCPE005 ³ Autor ³ Adriano Leonardo    ³ Data ³ 12/08/2016 ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina de priorização de OPs conforme matriz cruzada.      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Específico para a empresa Prozyn               			  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function RPCPE005()

Local _aSavArea 	:= GetArea()
Local _aSavSZ5		:= SZ5->(GetArea())
Local _aSavSC2		:= SC2->(GetArea())
Local _aSavSB1		:= SB1->(GetArea())
Private _cEnter		:= CHR(13) + CHR(10)

Processa( {||Carregar()}, "Aguarde...", "Preparando ambiente...",.F.)

RestArea(_aSavSB1)
RestArea(_aSavSC2)
RestArea(_aSavSZ5)
RestArea(_aSavArea)

Return()

Static Function Carregar()

Local _cQry			:= ""
Local _cTabTmp 		:= GetNextAlias()
Local _aMatCruz		:= {}
Local _aFamil		:= {}
Local _nCont		:= 1
Local _nFamil 		:= 1
Local _nArranjo		:= 0
Private _aOrdemOP	:= {}
Private _cRotina	:= "RPCPE005"
Private _aSize  	:= MsAdvSize()
Private _nTamBtn	:= 54
Private _nEspPad	:= 8
Private _cTipo		:= "P"
Private cPerg		:= "RPCPE005"
Private _aArray		:= {}
Private aFields 	:= {"C2_PRIOR", "C2_EMPENHO", "C2_PRODUTO", "B1_FAMIL", "C2_NUM", "C2_ITEM", "C2_SEQUEN", "C2_ITEMGRD" ,"B1_DESCINT", "C2_LOTECTL", "C2_QUANT", "C2_EMISSAO", "C2_DATPRI", "C2_DATPRF"}
Private _aAcoesAux	:= Separa(Posicione("SX3",2,"Z5_ACAO","X3_CBOX"),";")
Private _aProdAc	:= Separa(SuperGetMv("MV_PRODXAC",,""),";")
Static oMSNewGe1
Public Altera		:= .T.
Private _cProdutos	:= ""

//Monto cláusula IN dos produtos que são utilizados para higienização dos equipamentos
For _nCont := 1 To Len(_aProdAc)
	If !Empty(AllTrim(Separa(_aProdAc[_nCont],"=")[02]))
		_cProdutos +=  IIF(Empty(_cProdutos),"",",") + "'" + AllTrim(Separa(_aProdAc[_nCont],"=")[02]) + "'"
	EndIf
Next

ValidPerg()

If !Pergunte(cPerg,.T.)
	Return()
EndIf

//Consulto quais as famílias de produtos que deverão ser consideradas para ordenação das OPs
/*
_cQry	:= "SELECT B1_FAMIL, '0' [CLAS] FROM ( "
_cQry	+= "SELECT TOP 1 B1_FAMIL FROM " + RetSqlName("SC2") + " SC2 "
_cQry	+= "INNER JOIN " + RetSqlName("SD3") + " SD3 "
_cQry	+= "ON SC2.D_E_L_E_T_='' "
_cQry	+= "AND SC2.C2_FILIAL='" + xFilial("SC2") + "' "
_cQry	+= "AND SD3.D_E_L_E_T_='' "
_cQry	+= "AND SD3.D3_FILIAL='" + xFilial("SD3")+ "' "
_cQry	+= "AND SC2.C2_NUM+SC2.C2_ITEM+SC2.C2_SEQUEN+SC2.C2_ITEMGRD=SD3.D3_OP "
_cQry	+= "AND SC2.C2_SALA='" + MV_PAR01 + "' "
_cQry	+= "AND SD3.D3_CF LIKE 'PR%' "
_cQry	+= "INNER JOIN " + RetSqlName("SB1") + " SB1 "
_cQry	+= "ON SB1.D_E_L_E_T_='' "
_cQry	+= "AND SB1.B1_FILIAL='" + xFilial("SB1") + "' "
_cQry	+= "AND SB1.B1_COD=SC2.C2_PRODUTO "
_cQry	+= "ORDER BY SD3.D3_NUMSEQ DESC) TEMP "

_cQry	+= " UNION ALL "
*/
_cQry	:= "SELECT DISTINCT B1_FAMIL FROM " + RetSqlName("SC2") + " SC2 " + _cEnter
_cQry	+= "INNER JOIN " + RetSqlName("SB1") + " SB1 " + _cEnter
_cQry	+= "ON SC2.D_E_L_E_T_='' " + _cEnter
_cQry	+= "AND SC2.C2_FILIAL='" + xFilial("SC2") + "' " + _cEnter
_cQry	+= "AND SC2.C2_QUANT>(SC2.C2_QUJE+SC2.C2_PERDA) " + _cEnter
_cQry	+= "AND SC2.C2_SALA='" + MV_PAR01 + "' " + _cEnter
_cQry	+= "AND SB1.D_E_L_E_T_='' " + _cEnter
_cQry	+= "AND SB1.B1_FILIAL='" + xFilial("SB1") + "' " + _cEnter
_cQry	+= "AND SC2.C2_PRODUTO=SB1.B1_COD " + _cEnter

//Filtro as Ops de ação quando a rotina for utilizada na versão de sugestão
If MV_PAR12==2
	_cQry	+= "AND SC2.C2_PRODUTO NOT IN (" + _cProdutos + ") " + _cEnter
EndIf

_cQry	+= "AND SC2.C2_PRODUTO BETWEEN '" + MV_PAR02 + "' AND '" + MV_PAR03 + "' " + _cEnter
_cQry	+= "AND SC2.C2_NUM+SC2.C2_ITEM+SC2.C2_SEQUEN+SC2.C2_ITEMGRD BETWEEN '" + MV_PAR04 + "' AND '" + MV_PAR05 + "' " + _cEnter
_cQry	+= "AND SC2.C2_EMISSAO BETWEEN '" + DTOS(MV_PAR06) + "' AND '" + DTOS(MV_PAR07) + "' " + _cEnter
_cQry	+= "AND SC2.C2_DATPRI BETWEEN '" + DTOS(MV_PAR08) + "' AND '" + DTOS(MV_PAR09) + "' " + _cEnter
_cQry	+= "AND SC2.C2_DATPRF BETWEEN '" + DTOS(MV_PAR10) + "' AND '" + DTOS(MV_PAR11) + "' " + _cEnter

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQry),_cTabTmp,.F.,.T.)

dbSelectArea(_cTabTmp)

While (_cTabTmp)->(!EOF())
	
	AAdd(_aFamil,(_cTabTmp)->B1_FAMIL)
	
	dbSelectArea(_cTabTmp)
	(_cTabTmp)->(dbSkip())
EndDo

dbSelectArea(_cTabTmp)
(_cTabTmp)->(dbCloseArea())

//Somente avalio a melhor sequência na opção de sugestão
If MV_PAR12==2
	_aCombin := U_RPCPE010(_aFamil) //Chamada de rotina para gerar todas as combinações possíveis das OPs, para em seguida avaliar a melhor sequência
Else
	_aCombin := {}
EndIf

dbSelectArea("SZ5")
dbSetOrder(1) //Filial + Família 1 + Família 2

_nEscolha := 0
_nClassif := 9999999999
_nClasAux := 0

ProcRegua(Len(_aCombin))
                  
For _nArranjo := 1 To Len(_aCombin)
	
 	IncProc("Avaliando sequência " + AllTrim(Str(Round(((_nArranjo*100)/Len(_aCombin)),0))) + "% concluído!")
 	
	_nClasAux := 0
	
	For _nFamil := 1 To Len(_aCombin[_nArranjo])-1
		If SZ5->(msSeek(xFilial("SZ5")+_aFamil[_aCombin[_nArranjo][_nFamil+1]]+_aFamil[_aCombin[_nArranjo][_nFamil]]))
			_cAcao := SZ5->Z5_ACAO
			
			If _cAcao=="NA"
				_nClasAux += 0
			ElseIf _cAcao=="AC"
				_nClasAux += 1000
			ElseIf _cAcao=="AG"
				_nClasAux += 1000
			ElseIf _cAcao=="AM"
				_nClasAux += 100000
			ElseIf _cAcao=="CC"
				_nClasAux += 100000
			ElseIf _cAcao=="HC"
				_nClasAux += 10000000
			EndIf
		EndIf
	Next
	
	If _nClassif > _nClasAux .Or. _nEscolha == 0
		_nClassif := _nClasAux
		_nEscolha := _nArranjo
	EndIf
Next

_lCase := .F.

//Monto instrução case para ordenação das OPs de acordo com a matriz cruzada
_cCaseQry := "CASE "

If _nEscolha > 0
	For _nCont := 1 To Len(_aCombin[_nEscolha])
		_lCase 		:= .T.
		_cCaseQry 	+= "WHEN B1_FAMIL='" + _aFamil[_aCombin[_nEscolha][_nCont]] + "' THEN " + AllTrim(Str(_nCont)) + " "
	Next
EndIf

_cCaseQry += "END AS [ORDEM], "

_cTabTmp := GetNextAlias()

_cQry2	:= "SELECT "

If _lCase
	_cQry2	+= _cCaseQry
EndIf

_cQry2	+= "SC2.R_E_C_N_O_ [C2_RECNO], SB1.R_E_C_N_O_ [B1_RECNO], SC2.C2_NUM+SC2.C2_ITEM+SC2.C2_SEQUEN+SC2.C2_ITEMGRD [NUM_OP], C2_EMISSAO, C2_PRODUTO, C2_SALA, CASE WHEN SB1.B1_COD IN (" + _cProdutos + ") THEN 'ACAO' ELSE SB1.B1_FAMIL END [B1_FAMIL] FROM " + RetSqlName("SC2") + " SC2 "
_cQry2	+= "INNER JOIN " + RetSqlName("SB1") + " SB1 "
_cQry2	+= "ON SC2.D_E_L_E_T_='' "
_cQry2	+= "AND SC2.C2_FILIAL='" + xFilial("SC2") + "' "
_cQry2	+= "AND SC2.C2_QUANT>(SC2.C2_QUJE+SC2.C2_PERDA) "
_cQry2	+= "AND SC2.C2_SALA='" + MV_PAR01 + "' "
_cQry2	+= "AND SB1.D_E_L_E_T_='' "
_cQry2	+= "AND SB1.B1_FILIAL='" + xFilial("SB1") + "' "
_cQry2	+= "AND SC2.C2_PRODUTO=SB1.B1_COD "
If MV_PAR12==2
	_cQry	+= "AND SC2.C2_PRODUTO NOT IN (" + _cProdutos + ") "
EndIf
_cQry2	+= "AND SC2.C2_PRODUTO BETWEEN '" + MV_PAR02 + "' AND '" + MV_PAR03 + "' "
_cQry2	+= "AND SC2.C2_NUM+SC2.C2_ITEM+SC2.C2_SEQUEN+SC2.C2_ITEMGRD BETWEEN '" + MV_PAR04 + "' AND '" + MV_PAR05 + "' "
_cQry2	+= "AND SC2.C2_EMISSAO BETWEEN '" + DTOS(MV_PAR06) + "' AND '" + DTOS(MV_PAR07) + "' "
_cQry2	+= "AND SC2.C2_DATPRI BETWEEN '" + DTOS(MV_PAR08) + "' AND '" + DTOS(MV_PAR09) + "' "
_cQry2	+= "AND SC2.C2_DATPRF BETWEEN '" + DTOS(MV_PAR10) + "' AND '" + DTOS(MV_PAR11) + "' "

If MV_PAR12==1
	_cQry2	+= "ORDER BY C2_PRIOR "
ElseIf _lCase
	_cQry2	+= "ORDER BY ORDEM, C2_DATPRF, C2_NUM, C2_PRODUTO, C2_QUANT DESC "
EndIf

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQry2),_cTabTmp,.F.,.T.)

dbSelectArea(_cTabTmp)

_cFamilAnt := ""

While (_cTabTmp)->(!EOF())
		
	AAdd(_aOrdemOP,{(_cTabTmp)->NUM_OP, (_cTabTmp)->B1_FAMIL, (_cTabTmp)->C2_RECNO, (_cTabTmp)->B1_RECNO})
			
	dbSelectArea(_cTabTmp)
	(_cTabTmp)->(dbSkip())
	
EndDo

dbSelectArea(_cTabTmp)
(_cTabTmp)->(dbCloseArea())

If MV_PAR12==1
	_cOpera := " - Visualização"
Else
	_cOpera := " - Alteração"
EndIf

DEFINE MSDIALOG oDlg TITLE "Prioridade de Produção" + _cOpera FROM _aSize[1], _aSize[1]  TO _aSize[6], _aSize[5] COLORS 0, 16777215 PIXEL

	If !fMSNewGe1()
		Return()
	EndIf
	
	// Don't change the Align Order
	//oMSNewGe1:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
    oMSNewGe1:oBrowse:Align := CONTROL_ALIGN_TOP
	
ACTIVATE MSDIALOG oDlg CENTERED

Return()

Static Function fMSNewGe1()

Local nX
Local _nCont
Local aHeaderEx 	:= {}
Local aColsEx		:= {}
Local aFieldFill	:= {}
Local aAlterFields 	:= {"C2_PRIOR","C2_EMPENHO"}

//Caso o usuário tenha escolhido a opção de visualização, nenhum campo será editável
If MV_PAR12==1
	aAlterFields := {}
EndIf

// Define field properties
DbSelectArea("SX3")
SX3->(DbSetOrder(2))
For nX := 1 to Len(aFields)
	If SX3->(DbSeek(aFields[nX]))
	
		Aadd(aHeaderEx, {SX3->X3_TITULO,SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,IIF(aFields[nX]<>"C2_PRIOR",SX3->X3_VALID,".T."),;
                       SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
                       
	EndIf
Next nX

For _nCont := 1 To Len(_aOrdemOP)
    
	If Len(_aOrdemOP[_nCont,1]) <> 2
		
		dbSelectArea("SC2")
		dbGoTo(_aOrdemOP[_nCont,3])
		
		dbSelectArea("SB1")
		dbGoTo(_aOrdemOP[_nCont,4])
		
		aFieldFill := {}
		
		// Define field values
		For nX := 1 to Len(aFields)
			If aFields[nX] == "C2_PRIOR" .And. MV_PAR12 == 2
				Aadd(aFieldFill, StrZero(_nCont*10,TamSX3("C2_PRIOR")[01]))
			ElseIf aFields[nX] == "B1_FAMIL"
				Aadd(aFieldFill, _aOrdemOP[_nCont,2])
			Else
				dbSelectArea("SX3")
				dbSetOrder(2)
				If SX3->(DbSeek(aFields[nX]))
					
					_cAlias := Separa(aFields[nX],"_")[01]
					
					If Len(_cAlias)<3
						_cAlias := "S" + _cAlias
					EndIf
					
					_cAlias += "->""
					
					Aadd(aFieldFill, &(_cAlias+aFields[nX]))
				EndIf
			EndIf
		Next nX
	Else
		
		aFieldFill := {}
		
		For nX := 1 to Len(aFields)
			If aFields[nX] == "C2_PRIOR"
				Aadd(aFieldFill, Soma1(aColsEx[_nCont-1,aScan(aFields,"C2_PRIOR")]))
			ElseIf aFields[nX] == "B1_DESCINT"
				Aadd(aFieldFill, _aOrdemOP[_nCont,1])
			ElseIf aFields[nX] == "B1_FAMIL"
				Aadd(aFieldFill, "ACAO")
			ElseIf aFields[nX] == "C2_NUM"
				Aadd(aFieldFill, "")
			ElseIf aFields[nX] == "C2_ITEM"
				Aadd(aFieldFill, "")
			ElseIf aFields[nX] == "C2_SEQUEN"
				Aadd(aFieldFill, "")
			ElseIf aFields[nX] == "C2_ITEMGR"	
				Aadd(aFieldFill, "")
			Else
				dbSelectArea("SX3")
				dbSetOrder(2)
				If SX3->(DbSeek(aFields[nX]))
					
					_cAlias := CriaVar(aFields[nX])				
					
					Aadd(aFieldFill, _cAlias)
				EndIf
			EndIf
		Next nX
	EndIf
	
	Aadd(aFieldFill, .F.)
	Aadd(aColsEx, aFieldFill)
	
Next

oMSNewGe1 := MsNewGetDados():New( _aSize[1], _aSize[1], _aSize[6]-330, _aSize[5], GD_UPDATE, "AllwaysTrue", "U_RPCPE05B", "", aAlterFields,, Len(aColsEx), "U_RPCPE05A", "", "AllwaysTrue", oDlg, aHeaderEx, aColsEx)
oMSNewGe1:oBrowse:lUseDefaultColors := .F.
oMSNewGe1:oBrowse:SetBlkBackColor({|| GETDCLR(oMSNewGe1:aCols,oMSNewGe1:nAt,oMSNewGe1:aHeader)})

If MV_PAR12==2
	oMSNewGe1:aCols := aCols := Acoes()
	oMSNewGe1:Refresh()
EndIf

//Botões
@ _aSize[6]-325, _aSize[3]-_nTamBtn-_nEspPad 			BUTTON _btnCancel 	PROMPT "&Confirmar" 		SIZE _nTamBtn, 012 OF oDlg ACTION Confirmar() 	PIXEL

If MV_PAR12==1
	@ _aSize[6]-325, _aSize[3]-(_nTamBtn*2)-(_nEspPad*2) 		BUTTON _btnPrint 	PROMPT "&Imprimir" 		SIZE _nTamBtn, 012 OF oDlg ACTION U_RPCPR003(oMSNewGe1:aHeader,oMSNewGe1:aCols,MV_PAR01) 	PIXEL
EndIf

Return(.T.)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ValidPerg   º Autor ³ Adriano Leonardo º Data ³ 07/06/2016 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Função responsável pela inclusão dos parâmetros da rotina. º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Específico para a empresa Prozyn                			  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function ValidPerg()

Local _sAlias	:= GetArea()
Local aRegs		:= {}
Local _x		:= 1
Local _y		:= 1
cPerg			:= PADR(cPerg,10)

AADD(aRegs,{cPerg,"01","Sala de Produção"			,"","","mv_ch1","C",TamSx3("Z6_CODIGO"	)[01],TamSx3("Z6_CODIGO"	)[02],0,"G","","MV_PAR01",""		,"","","","",""			,"","","","","","","","","","","","","","","","","","","SZ6","","","",""})
AADD(aRegs,{cPerg,"02","De produto?"				,"","","mv_ch2","C",TamSx3("B1_COD"		)[01],TamSx3("B1_COD"		)[02],0,"G","","MV_PAR02",""		,"","","","",""			,"","","","","","","","","","","","","","","","","","",""	,"","","",""})
AADD(aRegs,{cPerg,"03","Até produto?"				,"","","mv_ch3","C",TamSx3("B1_COD"		)[01],TamSx3("B1_COD"		)[02],0,"G","","MV_PAR03",""		,"","","","",""			,"","","","","","","","","","","","","","","","","","",""	,"","","",""})
AADD(aRegs,{cPerg,"04","De OP?"						,"","","mv_ch4","C",TamSx3("D3_OP"		)[01],TamSx3("D3_OP"		)[02],0,"G","","MV_PAR04",""		,"","","","",""			,"","","","","","","","","","","","","","","","","","","SC2","","","",""})
AADD(aRegs,{cPerg,"05","Até OP?"					,"","","mv_ch5","C",TamSx3("D3_OP"		)[01],TamSx3("D3_OP"		)[02],0,"G","","MV_PAR05",""		,"","","","",""			,"","","","","","","","","","","","","","","","","","","SC2","","","",""})
AADD(aRegs,{cPerg,"06","De emissão?"				,"","","mv_ch6","D",TamSx3("C2_EMISSAO"	)[01],TamSx3("C2_EMISSAO"	)[02],0,"G","","MV_PAR06",""		,"","","","",""			,"","","","","","","","","","","","","","","","","","",""	,"","","",""})
AADD(aRegs,{cPerg,"07","Até emissão?"	  			,"","","mv_ch7","D",TamSx3("C2_EMISSAO"	)[01],TamSx3("C2_EMISSAO"	)[02],0,"G","","MV_PAR07",""		,"","","","",""			,"","","","","","","","","","","","","","","","","","",""	,"","","",""})
AADD(aRegs,{cPerg,"08","De previsão de início?"		,"","","mv_ch8","D",TamSx3("C2_EMISSAO"	)[01],TamSx3("C2_EMISSAO"	)[02],0,"G","","MV_PAR08",""		,"","","","",""			,"","","","","","","","","","","","","","","","","","",""	,"","","",""})
AADD(aRegs,{cPerg,"09","Até previsão de início?"	,"","","mv_ch9","D",TamSx3("C2_EMISSAO"	)[01],TamSx3("C2_EMISSAO"	)[02],0,"G","","MV_PAR09",""		,"","","","",""			,"","","","","","","","","","","","","","","","","","",""	,"","","",""})
AADD(aRegs,{cPerg,"10","De previsão de entrega?"	,"","","mv_cha","D",TamSx3("C2_EMISSAO"	)[01],TamSx3("C2_EMISSAO"	)[02],0,"G","","MV_PAR10",""		,"","","","",""			,"","","","","","","","","","","","","","","","","","",""	,"","","",""})
AADD(aRegs,{cPerg,"11","Até previsão de entrega?"	,"","","mv_chb","D",TamSx3("C2_EMISSAO"	)[01],TamSx3("C2_EMISSAO"	)[02],0,"G","","MV_PAR11",""		,"","","","",""			,"","","","","","","","","","","","","","","","","","",""	,"","","",""})
AADD(aRegs,{cPerg,"12","Sequencia?"					,"","","mv_chc","C",1						 ,0							 ,0,"C","","MV_PAR12","Atual"	,"","","","","Sugere"	,"","","","","","","","","","","","","","","","","","",""	,"","","",""})

For _x := 1 To Len(aRegs)
	dbSelectArea("SX1")
	SX1->(dbSetOrder(1))
	If !SX1->(MsSeek(cPerg+aRegs[_x,2],.T.,.F.))
		RecLock("SX1",.T.)
		For _y := 1 To FCount()
			If _y <= Len(aRegs[_x])
				FieldPut(_y,aRegs[_x,_y])
			Else
				Exit
			EndIf
		Next
		SX1->(MsUnlock())
	EndIf
Next

RestArea(_sAlias)

Return()

User Function RPCPE05A()

Local _lRet := .T.

If AllTrim(oMSNewGe1:aCols[n,aScan(oMSNewGe1:aHeader,{|x|Alltrim(x[2]) == "B1_FAMIL"})])<> "ACAO"    
	If (Replace(ReadVar(),"M->","")=="C2_PRIOR" .And. IsNumeric(&(ReadVar())))
		aCols[n,aScan(aHeader,{|x|Alltrim(x[2]) == Replace(ReadVar(),"M->","")})] := ReadVar() := StrZero(Val(&(ReadVar())),TamSX3(Replace(ReadVar(),"M->",""))[01])
		oMSNewGe1:aCols := aCols := Acoes()
		oMSNewGe1:Refresh()
	Else
		_lRet := .F.
	EndIf
Else	
	If (Replace(ReadVar(),"M->","")=="C2_EMPENHO") .And. &(ReadVar()) $ ("S/N")
		aCols[n,aScan(aHeader,{|x|Alltrim(x[2]) == Replace(ReadVar(),"M->","")})] := ReadVar() := &(ReadVar())
		oMSNewGe1:Refresh()
	Else
		_lRet := .F.
	EndIf
EndIf

Return(_lRet)

User Function RPCPE05B()

Return(.F.)

Static Function Confirmar()
	
	Local _nCont
	Local _nProd		:= 1
	Private lMsErroAuto := .F.
	
	//Ordeno o array para realizar a validação
	_aColsAux := ASort(oMSNewGe1:aCols,,,{|x,y|x[1]<y[1]})
	
	_cPrior	:= ""
	
	For _nCont := 1 To Len(_aColsAux)
		
		If _cPrior == oMSNewGe1:aCols[_nCont,aScan(oMSNewGe1:aHeader,{|x|Alltrim(x[2]) == "C2_PRIOR"})]
			MsgStop("Atenção, a prioridade " + _cPrior + " foi atribuída a mais de uma produção!",_cRotina+"_001")
			Return(.F.)
		EndIf
		
		_cPrior := oMSNewGe1:aCols[_nCont,aScan(oMSNewGe1:aHeader,{|x|Alltrim(x[2]) == "C2_PRIOR"})]
	Next
	
	If MV_PAR12==2
	
		_cQry3	:= "SELECT "
		_cQry3	+= "SC2.R_E_C_N_O_ [C2_RECNO] "
		_cQry3	+= "FROM " + RetSqlName("SC2") + " SC2 "
		_cQry3	+= "WHERE SC2.D_E_L_E_T_='' "
		_cQry3	+= "AND SC2.C2_FILIAL='" + xFilial("SC2") + "' "
		_cQry3	+= "AND (SC2.C2_QUJE+SC2.C2_PERDA)=0 "
		_cQry3	+= "AND SC2.C2_SALA='" + MV_PAR01 + "' "
		_cQry3	+= "AND SC2.C2_PRODUTO IN (" + _cProdutos + ") "
		_cQry3	+= "AND SC2.C2_NUM+SC2.C2_ITEM+SC2.C2_SEQUEN+SC2.C2_ITEMGRD BETWEEN '" + MV_PAR04 + "' AND '" + MV_PAR05 + "' "
		_cQry3	+= "AND SC2.C2_EMISSAO BETWEEN '" + DTOS(MV_PAR06) + "' AND '" + DTOS(MV_PAR07) + "' "
		_cQry3	+= "AND SC2.C2_DATPRI BETWEEN '" + DTOS(MV_PAR08) + "' AND '" + DTOS(MV_PAR09) + "' "
		_cQry3	+= "AND SC2.C2_DATPRF BETWEEN '" + DTOS(MV_PAR10) + "' AND '" + DTOS(MV_PAR11) + "' "
		
		_cAliasDel := GetNextAlias()
		
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQry3),_cAliasDel,.F.,.T.)
		
		dbSelectArea(_cAliasDel)
		
		While (_cAliasDel)->(!EOF())
			
			dbSelectArea("SC2")
			dbGoTo((_cAliasDel)->C2_RECNO)
			
			lMsErroAuto := .F.
			nOpc		:= 5													
			
			aMata650  	:= {{'C2_FILIAL'   ,SC2->C2_FILIAL	,NIL},;
			                {'C2_PRODUTO'  ,SC2->C2_PRODUTO	,NIL},;
			                {'C2_NUM'      ,SC2->C2_NUM		,NIL},;
			                {'C2_ITEM'     ,SC2->C2_ITEM	,NIL},;
			                {'C2_SEQUEN'   ,SC2->C2_SEQUEN	,NIL},;
			                {'C2_ITEMGRD'  ,SC2->C2_ITEMGRD	,NIL}}
			
			If SC2->(Recno()) == (_cAliasDel)->C2_RECNO
				MsExecAuto({|x,Y| Mata650(x,Y)},aMata650,nOpc)
							
				If lMsErroAuto
				    MsgStop("Falha na exclusão da OP de higienização " + (SC2)->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD) + ", anote os detalhes que serão apresentados a seguir e informe o administrador do sistema!",_cRotina+"_002")
				    MostraErro()
				EndIf
			Else
			    MsgStop("Houve uma falha na exclusão das OPs de higienização emitidas anteriormente, informe o administrador do sistema!",_cRotina+"_003")
			EndIf
			
			dbSelectArea(_cAliasDel)
			(_cAliasDel)->(dbSkip())
		EndDo
		
		For _nCont := 1 To Len(_aColsAux)
			
			_cNum	:= oMSNewGe1:aCols[_nCont,aScan(oMSNewGe1:aHeader,{|x|Alltrim(x[2]) == "C2_NUM"		})]
			_cItem	:= oMSNewGe1:aCols[_nCont,aScan(oMSNewGe1:aHeader,{|x|Alltrim(x[2]) == "C2_ITEM"	})]
			_cSequen:= oMSNewGe1:aCols[_nCont,aScan(oMSNewGe1:aHeader,{|x|Alltrim(x[2]) == "C2_SEQUEN"	})]
			_cItemGr:= oMSNewGe1:aCols[_nCont,aScan(oMSNewGe1:aHeader,{|x|Alltrim(x[2]) == "C2_ITEMGRD"	})]
			
			dbSelectArea("SC2")
			dbSetOrder(1)
			If SC2->(dbSeek(xFilial("SC2")+_cNum+_cItem+_cSequen+_cItemGr))
				RecLock("SC2",.F.)
					SC2->C2_PRIOR := oMSNewGe1:aCols[_nCont,aScan(oMSNewGe1:aHeader,{|x|Alltrim(x[2]) == "C2_PRIOR"})]
				SC2->(MsUnlock())
			ElseIf AllTrim(_aColsAux[_nCont,aScan(oMSNewGe1:aHeader,{|x|Alltrim(x[2])=="B1_FAMIL"})]) == "ACAO"
			
				aMATA650	:= {}       //-Array com os campos
				_aEmp650	:= {}
				nOpc		:= 3
				lMsErroAuto := .F.
				_cProdHig 	:= ""
				
				Pergunte(cPerg,.F.)
				
				For _nProd := 1 To Len(_aProdAc)
					If Separa(_aProdAc[_nProd],"=")[01]==SubStr(_aColsAux[_nCont,aScan(oMSNewGe1:aHeader,{|x|Alltrim(x[2])=="B1_DESCINT"})],1,TamSX3("Z5_ACAO")[01])
						_cProdHig := Separa(_aProdAc[_nProd],"=")[02]
					EndIf
				Next
				
				dbSelectArea("SB1")
				dbSetOrder(1)				
				If SB1->(dbSeek(xFilial("SB1")+_cProdHig))
					
					_cPrior		:= _aColsAux[_nCont,aScan(oMSNewGe1:aHeader,{|x|Alltrim(x[2])=="C2_PRIOR"	})]
					_cEmpen		:= _aColsAux[_nCont,aScan(oMSNewGe1:aHeader,{|x|Alltrim(x[2])=="C2_EMPENHO"	})]
					
					aMata650  	:= {{'C2_FILIAL'   ,xFilial("SC2")					,NIL},;
					                {'C2_PRODUTO'  ,SB1->B1_COD						,NIL},;
					                {'C2_LOCAL'    ,SB1->B1_LOCPAD					,NIL},;
					                {'C2_NUM'      ,GETNUMSC2()                     ,NIL},;
					                {'C2_ITEM'     ,"01"							,NIL},;
					                {'C2_SEQUEN'   ,"001"							,NIL},;
					                {'C2_QUANT'    ,IIF(SB1->B1_QB==0,1,SB1->B1_QB)	,NIL},;
					                {'C2_DATPRI'   ,MV_PAR06						,NIL},;
					                {'C2_DATPRF'   ,dDataBase						,NIL},;
					                {'C2_SALA'     ,MV_PAR01						,NIL},;
					                {'C2_LOTECTL'  ,"LIMPEZA"						,NIL},;
					                {'C2_DTVALID'  ,dDataBase						,NIL},;
					                {'C2_PRIOR'	   ,_cPrior							,NIL},;
					                {'C2_EMPENHO'  ,_cEmpen							,NIL},;
					                {'C2_OBS' 	   ,"OP AUTOMÁTICA ("+_cRotina+")"	,NIL}}
					
					MsExecAuto({|x,Y| Mata650(x,Y)},aMata650,nOpc)
					
					If lMsErroAuto
					    RollbackSx8()
					    MsgStop("Ordem de produção para " + AllTrim(_aColsAux[_nCont,aScan(oMSNewGe1:aHeader,{|x|Alltrim(x[2])=="B1_DESCINT"})]) + " não gerada, anote os detalhes que serão apresentados a seguir e informe o administrador do sistema!",_cRotina+"_004")
					    MostraErro()
					Else
																			
						Pergunte(cPerg,.F.)
						
						RecLock("SC2",.F.)
							SC2->C2_EMISSAO := MV_PAR06
							SC2->C2_DATPRI	:= MV_PAR08
							SC2->C2_DATPRF	:= MV_PAR10
							SC2->C2_BATROT	:= "MATA650"
							
							//Caso a ação não deva gerar empenho, preencho a flag na OP para não processar está OP para cálculo dos empenhos
							IF SC2->C2_EMPENHO == 'N'
								SC2->C2_BATCH	:= "S"
							EndIf
						SC2->(MsUnlock())
						
						ConfirmSx8()
					EndIf
				Else
					MsgStop("Ordem de produção para " + _aColsAux[_nCont,aScan(oMSNewGe1:aHeader,{|x|Alltrim(x[2])=="B1_DESCINT"})] + " não gerada, produto não encontrado!",_cRotina+"_005")
				EndIf
			EndIf
		Next
	EndIf

	Close(oDlg)
	
Return()

Static Function Acoes()

Local _nCont
Local _aColsAux := {}
Local _cFamiAux := ""
Local _nAcoes	:= 1
Local nX		:= 1

For _nCont:= 1 To Len(oMSNewGe1:aCols)
	If AllTrim(oMSNewGe1:aCols[_nCont,aScan(oMSNewGe1:aHeader,{|x|Alltrim(x[2]) == "B1_FAMIL"})])<> "ACAO"
		AAdd(_aColsAux,aClone(oMSNewGe1:aCols[_nCont]))
	EndIf
Next

_aColsAux := ASort(_aColsAux,,,{|x,y|x[1]<y[1]})
_aColsFin := ASort(_aColsAux,,,{|x,y|x[1]<y[1]})

For _nCont := 1 To Len(_aColsAux)
	If _cFamiAux <> AllTrim(_aColsAux[_nCont,aScan(oMSNewGe1:aHeader,{|x|Alltrim(x[2]) == "B1_FAMIL"})]) .And. !Empty(_cFamiAux)
		dbSelectArea("SZ5")
		dbSetOrder(1)
		//If dbSeek(xFilial("SZ5")+_cFamiAux+_aColsAux[_nCont,aScan(oMSNewGe1:aHeader,{|x|Alltrim(x[2]) == "B1_FAMIL"})]) //Alterada consideração da matriz cruzada de linha x coluna para coluna x linha
		If dbSeek(xFilial("SZ5")+_aColsAux[_nCont,aScan(oMSNewGe1:aHeader,{|x|Alltrim(x[2]) == "B1_FAMIL"})]+_cFamiAux)
			If SZ5->Z5_ACAO<>"NA"
				aFieldFill := {}
				
				_cDescAcao := ""
				For _nAcoes := 1 To Len(_aAcoesAux)
					If SubStr(_aAcoesAux[_nAcoes],1,TamSX3("Z5_ACAO")[01])==SZ5->Z5_ACAO
						_cDescAcao := _aAcoesAux[_nAcoes]
						Exit
					EndIf
				Next
				
				// Define field values
				For nX := 1 to Len(aFields)
					If aFields[nX] == "C2_PRIOR"
						Aadd(aFieldFill, Soma1(_aColsAux[_nCont-1,aScan(aFields,"C2_PRIOR")]))
					ElseIf aFields[nX] == "B1_DESCINT"
						Aadd(aFieldFill, _cDescAcao)
					ElseIf aFields[nX] == "B1_FAMIL"
						Aadd(aFieldFill, "ACAO")
					ElseIf aFields[nX] $ ("C2_NUM|C2_ITEM|C2_SEQUEN|C2_ITEMGR")
						Aadd(aFieldFill, "")
					ElseIf aFields[nX] == "C2_EMPENHO"
						Aadd(aFieldFill, "S")
					Else
						dbSelectArea("SX3")
						dbSetOrder(2)
						If SX3->(DbSeek(aFields[nX]))
							
							_cAlias := CriaVar(aFields[nX])
							
							Aadd(aFieldFill, _cAlias)
						EndIf
					EndIf
				Next nX
				
				Aadd(aFieldFill, .F.)
				Aadd(_aColsFin, aFieldFill)
			EndIf
		EndIf
	EndIf
	
	If AllTrim(_aColsAux[_nCont,aScan(oMSNewGe1:aHeader,{|x|Alltrim(x[2]) == "B1_FAMIL"})]) <> "ACAO"
		_cFamiAux := _aColsAux[_nCont,aScan(oMSNewGe1:aHeader,{|x|Alltrim(x[2]) == "B1_FAMIL"})]
	EndIf
Next

_aColsFin := ASort(_aColsFin,,,{|x,y|x[1]<y[1]})

oMSNewGe1:aCols := aClone(_aColsFin)
oMSNewGe1:Refresh()
		
Return(aClone(_aColsFin))

Static Function GETDCLR(aLinha,nLinha,aHeader)

Local nCor1 := CLR_YELLOW	//Amarelo
Local nCor2 := CLR_HBLUE	//Azul claro
Local nCor3 := CLR_WHITE	//Branco

If AllTrim(aLinha[nLinha,aScan(aHeader,{|x|Alltrim(x[2]) == "B1_FAMIL"})]) == "ACAO"
	nRet := nCor1
ElseIf Empty(AllTrim(aLinha[nLinha,aScan(aHeader,{|x|Alltrim(x[2]) == "C2_PRIOR"})]))
	nRet := nCor2
Else
	nRet := nCor3
EndIf

Return(nRet)