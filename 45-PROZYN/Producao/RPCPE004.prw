#INCLUDE 'RWMAKE.CH'
#INCLUDE 'PROTHEUS.CH'

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³ RPCPE004 ³ Autor ³ Adriano Leonardo    ³ Data ³ 26/07/2016 ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina responsável por permitir o reprocessamento de um    º±±
±±ºDesc.     ³ produto, para com a adição de novos componentes, transformar±±
±±ºDesc.     ³ o produto A em B.                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Específico para a empresa Prozyn               			  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function RPCPE004()

Local _aSavArea := GetArea()
Private _cRotina:= "RPCPE004"
Private cPerg	:= _cRotina
Private _aSize  := MsAdvSize()
Private lblPeriodo
Private oGetProd
Private _cProduto	:= Space(TamSX3("B1_COD")[01])
Private lblLocal
Private oGetLocal
Private _cLocal		:= Space(TamSX3("B1_LOCPAD")[01])
Private lblLoteCtl
Private oGetLote
Private _cLoteCtl	:= Space(TamSx3("B8_LOTECTL")[01])
Private lblDescr	
Private _cDescr		:= ""
Private lblValid 	
Private _dDtValid	:= STOD("")
Private lblTitVld	
Private lblTitSld 	
Private lblTitF5
Private lblTitF12
Private lblSldDisp 	
Private _nSldDisp	:= 0
Private _nGetQtd	:= 0
Private _nGetQtdD	:= 0
Private _aCompSG1	:= {}
Private _nMultMin	:= 1
Private oFont1		:= TFont():New("MS Sans Serif",,018,,.T.,,,,,.F.,.F.)
Private oFont2		:= TFont():New("MS Sans Serif",,016,,.T.,,,,,.F.,.F.)
Private _nTamBtn	:= 54
Private _nEspPad	:= 8
Private _nTamMark	:= 2
Private _btnOk
Private _btnCancel
Private aMarcados[2], nMarcado := 0
Private cMark		:= GetMARK(), lInverte := .F., oMark
Private _cTabTmp	:= GetNextAlias()
Private _cEnter		:= CHR(13) + CHR(10)
Public	_aEmp650P	:= {}
Public _lConti004	:= .F.

MsAguarde({|lEnd| Process()},"Aguarde...","Processando estruturas...",.T.)

RestArea(_aSavArea)

Return()

Static Function Process()

	Static oDlg
	Private aIndex		:= {}
	Private _cCenter	:= CHR(13) + CHR(10)
	Private bFiltraBrw 	:= {|| Nil}	
	Private _lRetm		:= .F.
	Private _cInd1		:= CriaTrab(Nil,.F.)
	Private _aCpos		:= {}
	Private _aStruct	:= {}
	Private _aCampos	:= {}
	
	DEFINE MSDIALOG oDlg TITLE "Selecione os produtos que deverão gerar ordem de produção utilizando esse lote" FROM _aSize[1], _aSize[1]  TO _aSize[6], _aSize[5] COLORS 0, 16777215 PIXEL STYLE DS_MODALFRAME
	
	//Inibe a tecla de atalho para prevenir duplicidade da abertura da janela
	SetKey(VK_F12,{|| })
	SetKey(VK_F12,{|| AtuQtd()})
	
	SetKey(VK_F5,{|| })
	SetKey(VK_F5,{|| Comparar()})
	
	oDlg:lEscClose := .F.
	
	//Labels
	@ 009, 013 SAY lblPeriodo 		PROMPT "Produto:" 										SIZE _aSize[1]+025, 007 OF oDlg 				COLORS 0, 16777215 PIXEL
	@ 008, 051 MSGET oGetProd 	VAR _cProduto 												SIZE 070, 010 OF oDlg  F3 "SB8OP" VALID SelecaoLote() 		COLORS 0, 16777215 PIXEL
	@ 009, 134 SAY lblLocal 		PROMPT "Armazém:" 								  		SIZE _aSize[1]+037, 007 OF oDlg 				COLORS 0, 16777215 PIXEL
	@ 008, 172 MSGET oGetLocal 	VAR _cLocal 												SIZE 020, 010 OF oDlg VALID SelecaoLote() 		COLORS 0, 16777215 PIXEL
	@ 009, 202 SAY lblLoteCtl 		PROMPT "Lote:" 						  					SIZE _aSize[1]+054, 007 OF oDlg 				COLORS 0, 16777215 PIXEL
	@ 008, 230 MSGET oGetLote 	VAR _cLoteCtl 												SIZE 050, 010 OF oDlg VALID SelecaoLote() PICTURE PesqPict("SD3","D3_LOTECTL")	COLORS 0, 16777215 PIXEL
	@ 009, 300 SAY lblDescr	 		PROMPT _cDescr 											SIZE _aSize[1]+125, 007 OF oDlg 				COLORS 0, 16777215 PIXEL
	@ 009, 420 SAY lblTitVld 		PROMPT "Validade:" 										SIZE _aSize[1]+050, 007 OF oDlg 				COLORS 0, 16777215 PIXEL	
	@ 009, 450 SAY lblValid 		PROMPT DTOC(_dDtValid)									SIZE _aSize[1]+030, 007 OF oDlg 				COLORS 0, 16777215 PIXEL
	@ _aSize[6]-326, 013 SAY lblTitSld 		PROMPT "Saldo Disponível: " 							SIZE _aSize[1]+050, 007 OF oDlg 				COLORS 0, 16777215 PIXEL
	@ _aSize[6]-326, 058 SAY lblSldDisp 	PROMPT Transform(_nSldDisp,PesqPict("SG1","G1_QUANT"))	SIZE _aSize[1]+035, 007 OF oDlg 				COLORS 0, 16777215 PIXEL
	@ _aSize[6]-318, 013 SAY lblTitF5 		PROMPT "Para visualizar a comparação das estruturas do produto origem x produto destino, selecione o produto destino e tecle F5 " 							SIZE _aSize[1]+500, 007 OF oDlg 				COLORS 0, 16777215 PIXEL
	@ _aSize[6]-310, 013 SAY lblTitF5 		PROMPT "Para alterar a quantidade, tecle F12 " 							SIZE _aSize[1]+500, 007 OF oDlg 				COLORS 0, 16777215 PIXEL	
	
	//MarkBrowse
	//Monto estrutura para tabela temporária que será utilizada no markbrowse
	AADD(_aCpos,{"TM_OK"  		,"C",_nTamMark					,0						 	})
	AADD(_aCpos,{"TM_COD" 		,"C",TamSx3("G1_COD"	)[01]	,TamSx3("G1_COD"	)[02]	})
	AADD(_aCpos,{"TM_TIPO"	 	,"C",TamSx3("B1_TIPO"	)[01]	,TamSx3("B1_TIPO"	)[02]	})
	AADD(_aCpos,{"TM_DESC" 		,"C",TamSx3("B1_DESC"	)[01]	,TamSx3("B1_DESC"	)[02]	})
	AADD(_aCpos,{"TM_QB"		,"N",TamSx3("B1_QB"		)[01]	,TamSx3("B1_QB"		)[02]	})
	AADD(_aCpos,{"TM_QBBKP"		,"N",TamSx3("B1_QB"		)[01]	,TamSx3("B1_QB"		)[02]	})
	AADD(_aCpos,{"TM_QUANT"		,"N",TamSx3("G1_QUANT"	)[01]	,TamSx3("G1_QUANT"	)[02]	})
	AADD(_aCpos,{"TM_LOCPAD"	,"C",TamSx3("B1_LOCPAD"	)[01]	,TamSx3("B1_LOCPAD"	)[02]	})
	
	_cInd1 := CriaTrab(_aCpos,.T.)
	
	//Crio tabela temporária para uso com markbrowse
	dbUseArea(.T.,,_cInd1,_cTabTmp,.T.,.F.)
	IndRegua(_cTabTmp,_cInd1,"TM_COD",,,"Criando índice temporário...")
	
	//Campos que serão apresentados no markbrowse
	AADD(_aCampos,{"TM_OK"  		,"" ,Space(_nTamMark)		,"" })
	AADD(_aCampos,{"TM_COD" 		,"" ,"Produto Destino"   	,"" })
	AADD(_aCampos,{"TM_TIPO"		,"" ,"Tipo"					,"" })
	AADD(_aCampos,{"TM_DESC"		,"" ,"Descrição"   			,"" })
	AADD(_aCampos,{"TM_QB"			,"" ,"Qtd. Base"   			,"" })
	AADD(_aCampos,{"TM_QUANT"		,"" ,"Qtd. do Componente"   ,"" })
	
	//Faço a instancia do markbrowse
	oMark := MsSelect():New(_cTabTmp,"TM_OK",,_aCampos,lInverte,@cMark,{_aSize[1]+028, _aSize[1]+008, _aSize[6]-330, _aSize[3]-_nEspPad})
	
	oMark:oBrowse:lHasMARK		:= .T.
	oMark:oBrowse:lCanAllMARK	:= .T.
	oMark:bAval					:= {|| ChkMarca(oMark,cMark)}
	
	AddColMARK(oMark,"TM_OK")

	//Botões
	@ _aSize[6]-325, _aSize[3]-(_nTamBtn*2)-(_nEspPad*2) 	BUTTON _btnOk 		PROMPT "&Gerar OPs" SIZE _nTamBtn, 012 OF oDlg ACTION Confirmar() 	PIXEL
	@ _aSize[6]-325, _aSize[3]-_nTamBtn-_nEspPad 			BUTTON _btnCancel 	PROMPT "&Fechar" 	SIZE _nTamBtn, 012 OF oDlg ACTION Fechar() 		PIXEL
	
	ACTIVATE MSDIALOG oDlg CENTERED
	
Return()

Static Function SelecaoLote()
	
	_cDescr		:= Posicione("SB1",1,xFilial("SB1")+_cProduto,"B1_DESC")
	_dDtValid 	:= Posicione("SB8",3,xFilial("SB8")+_cProduto+_cLocal+_cLoteCtl,"SB8->B8_DTVALID")
	_nSldDisp	:= Posicione("SB8",3,xFilial("SB8")+_cProduto+_cLocal+_cLoteCtl,"SB8->(B8_SALDO-B8_EMPENHO)")
	
	dbSelectArea(_cTabTmp)
	(_cTabTmp)->(dbGoTop())
	
	While (_cTabTmp)->(!EOF())
		RecLock(_cTabTmp,.F.)
			dbDelete()
		(_cTabTmp)->(MsUnlock())
		
		dbSelectArea(_cTabTmp)
		dbSkip()
	EndDo
	
	_cQtmp := GetNextAlias()
	
	_cQry	:= "SELECT " + _cEnter
	_cQry	+= "'' [OK], " + _cEnter
	_cQry	+= "G1_COD, " + _cEnter
	_cQry	+= "B1_TIPO, " + _cEnter
	_cQry	+= "B1_DESC, " + _cEnter
	_cQry	+= "B1_LOCPAD, " + _cEnter
	_cQry	+= "(SELECT ISNULL(SUM(D2_QUANT),0) FROM " + RetSqlName("SD2") + " SD2 WHERE SD2.D_E_L_E_T_='' AND SD2.D2_FILIAL='01' AND SD2.D2_COD=TEMP.G1_COD AND SD2.D2_TIPO NOT IN ('D','B')) AS [D2_QUANT], " + _cEnter
	_cQry	+= "B1_QB " + _cEnter
	_cQry	+= "FROM	( " + _cEnter
	_cQry	+= "			SELECT TMP. G1_COD FROM " + RetSqlName("SG1") + " SG1 WITH (NOLOCK) " + _cEnter
	_cQry	+= "			INNER JOIN " + RetSqlName("SG1") + " TMP WITH (NOLOCK) " + _cEnter
	_cQry	+= "			ON SG1.G1_COMP=TMP.G1_COMP " + _cEnter
	_cQry	+= "			AND SG1.G1_FIXVAR=TMP.G1_FIXVAR " + _cEnter
	_cQry	+= "			AND SG1.G1_COD='" + _cProduto + "' " + _cEnter
	_cQry	+= "			AND TMP.G1_COD<>SG1.G1_COD " + _cEnter
//	_cQry	+= "			AND (TMP.G1_QUANT>=SG1.G1_QUANT AND SG1.G1_TIPO<>'2' OR (TMP.G1_ATIVIDA=SG1.G1_ATIVIDA AND TMP.G1_UNATIV=SG1.G1_UNATIV AND SG1.G1_TIPO='2')) " + _cEnter
	_cQry	+= "			AND TMP.G1_TIPO=SG1.G1_TIPO " + _cEnter
	_cQry	+= "			AND TMP.G1_UNATIV=SG1.G1_UNATIV " + _cEnter
	_cQry	+= "			AND (SG1.G1_INI <= '" + DtoS(dDataBase) + "' OR SG1.G1_INI='') " + _cEnter
	_cQry	+= "			AND SG1.G1_FIM >='" + DtoS(dDataBase) + "' " + _cEnter
	_cQry	+= "			AND SG1.G1_REVINI >= (SELECT B1_REVATU FROM " + RetSqlName("SB1") + " WHERE B1_COD=SG1.G1_COD AND D_E_L_E_T_='' AND B1_FILIAL='" + xFilial("SB1") + "') " + _cEnter
	_cQry	+= "			AND SG1.G1_REVFIM >=(SELECT B1_REVATU FROM " + RetSqlName("SB1") + " WHERE B1_COD=SG1.G1_COD AND D_E_L_E_T_='' AND B1_FILIAL='" + xFilial("SB1") + "') " + _cEnter
	_cQry	+= "			AND SG1.D_E_L_E_T_='' " + _cEnter
	_cQry	+= "			AND SG1.G1_FILIAL='01' " + _cEnter
	_cQry	+= "			AND SG1.G1_TIPO NOT IN ('1','3') " + _cEnter
	_cQry	+= "			AND TMP.G1_TIPO NOT IN ('1','3') " + _cEnter
	_cQry	+= "			GROUP BY SG1.G1_COD, TMP.G1_COD " + _cEnter
	_cQry	+= "			HAVING COUNT(TMP.G1_COD)>= " + _cEnter
	_cQry	+= "		( " + _cEnter
	_cQry	+= "			SELECT COUNT(*) FROM " + RetSqlName("SG1") + " AUX WITH (NOLOCK) " + _cEnter
	_cQry	+= "			WHERE AUX.D_E_L_E_T_='' " + _cEnter
	_cQry	+= "			AND AUX.G1_FILIAL='01' " + _cEnter
	_cQry	+= "			AND AUX.G1_COD=SG1.G1_COD " + _cEnter
	_cQry	+= "			AND (AUX.G1_INI <= '" + DtoS(dDataBase) + "' OR AUX.G1_INI='') " + _cEnter
	_cQry	+= "			AND AUX.G1_FIM >='" + DtoS(dDataBase) + "' " + _cEnter
	_cQry	+= "			AND AUX.G1_TIPO NOT IN ('1','3') " + _cEnter
	_cQry	+= "			AND AUX.G1_REVINI >=(SELECT B1_REVATU FROM " + RetSqlName("SB1") + " WHERE B1_COD=AUX.G1_COD AND D_E_L_E_T_='' AND B1_FILIAL='" + xFilial("SB1") + "') " + _cEnter
	_cQry	+= "			AND AUX.G1_REVFIM >=(SELECT B1_REVATU FROM " + RetSqlName("SB1") + " WHERE B1_COD=AUX.G1_COD AND D_E_L_E_T_='' AND B1_FILIAL='" + xFilial("SB1") + "') " + _cEnter
	_cQry	+= "		) " + _cEnter
	_cQry	+= ") TEMP " + _cEnter
	_cQry	+= "INNER JOIN " + RetSqlName("SB1") + " SB1 " + _cEnter
	_cQry	+= "ON SB1.B1_COD=TEMP.G1_COD " + _cEnter
	_cQry	+= "AND SB1.D_E_L_E_T_='' " + _cEnter
	_cQry	+= "AND SB1.B1_FILIAL='" + xFilial("SB1") + "' " + _cEnter
	_cQry	+= "AND SB1.B1_MSBLQL<>'1' " + _cEnter
	_cQry	+= "ORDER BY D2_QUANT DESC, TEMP.G1_COD ASC " + _cEnter
	
	If !Empty(_cQry)
		//Crio tabela temporária com títulos passíveis de compensação com o pedido posicionado
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQry),_cQTmp,.F.,.T.)
		
		//Gravo a tabela temporária com base no resultado da query acima
		dbSelectArea(_cQTmp) //Tabela temporária com resultado da query
		dbGoTop()
		While (_cQTmp)->(!EOF())

			dbSelectArea(_cTabTmp)
			RecLock(_cTabTmp,.T.)
				TM_OK		:= (_cQTmp)->(OK		)
				TM_COD		:= (_cQTmp)->(G1_COD	)
				TM_LOCPAD	:= (_cQTmp)->(B1_LOCPAD	)
				TM_TIPO		:= (_cQTmp)->(B1_TIPO	)
				TM_DESC		:= (_cQTmp)->(B1_DESC	)
				TM_QB		:= (_cQTmp)->(B1_QB		)
				TM_QBBKP	:= (_cQTmp)->(B1_QB		)
				TM_QUANT	:= 0
			(_cTabTmp)->(MsUnlock())
			
			dbSelectArea(_cQTmp)
			(_cQTmp)->(dbSkip())
		EndDo
		
		dbSelectArea(_cQTmp)
		(_cQTmp)->(dbCloseArea()) //Fecho a tabela temporária com base no resultado da query
	EndIf
	
	dbSelectArea(_cTabTmp)
	(_cTabTmp)->(dbGoTop())
	
	oMark:oBrowse:Refresh()

Return(.T.)

Static Function Fechar()
	Close(oDlg)
Return()

Static Function ChkMarca(oMark,cMark)
	
	Local _nReg := Recno()
	
	dbSelectArea(_cTabTmp)
	
	If !Empty((_cTabTmp)->(TM_OK))
		
		RecLock(_cTabTmp,.F.)
			(_cTabTmp)->(TM_OK)		:= Space(_nTamMark)
			_nSldDisp += (_cTabTmp)->(TM_QB) //Atualizo o saldo disponível para seleção
			lblSldDisp:SetText(Transform(_nSldDisp,PesqPict("SG1","G1_QUANT")))
		(_cTabTmp)->(MsUnLock())
	Else
		
		AtuQtd()
		
		If _nSldDisp -(_cTabTmp)->(TM_QB) >= 0
			RecLock(_cTabTmp,.F.)
				(_cTabTmp)->(TM_OK)	:= cMark
				_nSldDisp -= (_cTabTmp)->(TM_QB) //Atualizo o saldo disponível para seleção
				lblSldDisp:SetText(Transform(_nSldDisp,PesqPict("SG1","G1_QUANT")))
			(_cTabTmp)->(MsUnLock())
		Else
			MsgAlert("O saldo do lote não é suficiente para atender essa requisição!",_cRotina+"_001")
		EndIf
	EndIf
	
	oMark:oBrowse:Refresh()
Return(.T.)

Static Function Confirmar()
	
Local aMATA650      := {}       //-Array com os campos
Local nOpc          := 3
Local _nCont		:= 1
Private lMsErroAuto := .F.
Private	lProj711 	:= .F.
Private LMATA712 	:= .F.
Private	LPCPA107 	:= .F.
Private L650AUTO 	:= .T.
Private LZRHEADER	:= .F.
Private LCONSTERC	:= .F.
Private LCONSNPT 	:= .F.
Private AOPC1	 	:= {}
Private AOPC7	 	:= {}
Private ADATAOPC1	:= {}
Private ADATAOPC7	:= {}
Private AALTSALDO	:= {}
Private aRotProd 	:= aClone(aMata650)
Private	ARETOROPC	:= {}

dbSelectArea(_cTabTmp)
(_cTabTmp)->(dbGoTop())

While (_cTabTmp)->(!EOF())

	If !Empty((_cTabTmp)->(TM_OK))
	
		aMATA650	:= {}       //-Array com os campos
		_aEmp650P	:= {}					
		lMsErroAuto := .F.
	
		aMata650  	:= {{'C2_FILIAL'   ,xFilial("SC2")													,NIL},;
		                {'C2_PRODUTO'  ,(_cTabTmp)->TM_COD												,NIL},;
		                {'C2_LOCAL'    ,(_cTabTmp)->TM_LOCPAD											,NIL},;
		                {'C2_NUM'      ,GETNUMSC2()                     								,NIL},;
		                {'C2_ITEM'     ,"01"															,NIL},;
		                {'C2_SEQUEN'   ,"001"															,NIL},;
		                {'C2_QUANT'    ,(_cTabTmp)->TM_QUANT											,NIL},;
		                {'C2_DATPRI'   ,dDataBase														,NIL},;
		                {'C2_DATPRF'   ,dDataBase														,NIL},;
		                {'C2_SALA'     ,"000"															,NIL},;
		                {'C2_OBS' 	   ,"OP AUTOMÁTICA (REPROCESSAMENTO " + AllTrim(_cProduto) + ")"	,NIL}}
		
		MsExecAuto({|x,Y| Mata650(x,Y)},aMata650,nOpc)
		
		If lMsErroAuto
		    RollbackSx8()
		    MostraErro()
		Else
			RecLock("SC2",.F.)
				SC2->C2_BATROT	:= "MATA650"
				SC2->C2_BATCH	:= "S"
			SC2->(MsUnlock())
			
			ConfirmSx8()
			
			lProj711 := .F.
			LMATA712 := .F.
			LPCPA107 := .F.
			L650AUTO := .F.
			LZRHEADER:= .F.
			LCONSTERC:= .F.
			LCONSNPT := .F.
			AOPC1	 := {}
			AOPC7	 := {}
			ADATAOPC1:= {}
			ADATAOPC7:= {}
			AALTSALDO:= {}
			aRotProd := aClone(aMata650)
						
			ComparaEstr()
			
			AAdd(_aEmp650P,{SC2->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD),_cProduto,_cLocal,_cLoteCtl,(_cTabTmp)->TM_QB,_dDtValid})
			
			For _nCont := 1 To Len(_aCompSG1)
			
				_cCdComp:= _aCompSG1[_nCont,1]
				_nQtdOri:= _aCompSG1[_nCont,2]
				_nQtdDes:= _aCompSG1[_nCont,3]
				_cTipo	:= _aCompSG1[_nCont,4]
				_cEnzima:= _aCompSG1[_nCont,6]
				_nAtiOri:= _aCompSG1[_nCont,7]
				_nAtiDes:= _aCompSG1[_nCont,8]
				
				If _cTipo == '4' //Ingrediente 
					//((Quantidade Estr. Destino*Quantidade a Produzir)/Quantidade Base Dest) - (Quantidade Estr. Origem * Saldo Utilizado)/Quantidade Base Origem
					_nQtdAux := (_nQtdDes * (_cTabTmp)->TM_QUANT/100)-(_nQtdOri * (_cTabTmp)->TM_QB/100)
					
					If _nQtdAux > 0
						//Adiciono empenho que deverá ser "forçado" na rotina EMP650 para esse item
						//AAdd(_aEmp650P,{(_cEmpTmp)->(OG1_COD), (_cEmpTmp)->(OG1_COMP), (_cEmpTmp)->(OG1_QUANT), (_cEmpTmp)->(OG1_TIPO), (_cEmpTmp)->(OG1_ATIVID), (_cEmpTmp)->(DG1_COD), (_cEmpTmp)->(DG1_COMP), (_cEmpTmp)->(DG1_QUANT), (_cEmpTmp)->(DG1_TIPO), (_cEmpTmp)->(DG1_ATIVID)})						
						AAdd(_aEmp650P,{_cCdComp, _nQtdAux, _cTipo, _nAtiDes})
					ElseIf _nQtdAux < 0
						
					EndIf
				ElseIf _cTipo == '3' .Or. _cTipo == '1'//Embalagem ou diluente
					AAdd(_aEmp650P,{_cCdComp, _nQtdDes, _cTipo, _nAtiDes})
				ElseIf _cTipo == '2' //Enzima
					//(atividade dest * qtd dest) - (atividade ori * qtd ori)
					_nQtdAux := (_nAtiDes * (_cTabTmp)->TM_QUANT)-(_nAtiOri * (_cTabTmp)->TM_QB)
					
					If _nQtdAux > 0
						//Adiciono empenho que deverá ser "forçado" na rotina EMP650 para esse item
						//AAdd(_aEmp650P,{(_cEmpTmp)->(OG1_COD), (_cEmpTmp)->(OG1_COMP), (_cEmpTmp)->(OG1_QUANT), (_cEmpTmp)->(OG1_TIPO), (_cEmpTmp)->(OG1_ATIVID), (_cEmpTmp)->(DG1_COD), (_cEmpTmp)->(DG1_COMP), (_cEmpTmp)->(DG1_QUANT), (_cEmpTmp)->(DG1_TIPO), (_cEmpTmp)->(DG1_ATIVID)})
						AAdd(_aEmp650P,{_cCdComp, 1, _cTipo, _nQtdAux})
					ElseIf _nQtdAux < 0
						
					EndIf
				EndIf
			Next
						
			MontEstru(SC2->C2_PRODUTO,SC2->C2_QUANT,SC2->C2_DATPRI,,,SC2->C2_PRIOR,,RetFldProd(SC2->C2_PRODUTO,"B1_OPC"),,SC2->C2_TPOP,,,)
		EndIf
	EndIf
	
	dbSelectArea(_cTabTmp)
	dbSkip()
EndDo
If !_lConti004
	Fechar()
EndIf

Return(!lMsErroAuto)

Static Function AtuQtd()
Local oGetv1
Local oGroupv1
Local oSayv1
Local oSButtonv1

//Inibe a tecla de atalho para prevenir duplicidade da abertura da janela
SetKey(VK_F12,{|| })

If !Empty((_cTabTmp)->TM_OK)
	MsgAlert("Antes de alterar a quantidade, primeiro desmarque o item!",_cRotina+"_002")

	//Restaura a tecla de atalho para prevenir duplicidade da abertura da janela
	SetKey(VK_F12,{|| })
	SetKey(VK_F12,{|| AtuQtd()})
	
	Return(_nGetQtd)
Else
	ComparaEstr()
	
	_nGetQtd  := 1
	_nGetQtdD := _nMultMin
	
	RecLock(_cTabTmp,.F.)
		(_cTabTmp)->TM_QB		:= _nGetQtd
		(_cTabTmp)->TM_QUANT	:= _nGetQtdD
	(_cTabTmp)->(MsUnlock())

EndIf

Static oDlgv

  DEFINE MSDIALOG oDlgv TITLE "Quantidade Base" FROM 000, 000 TO 230, 260  COLORS 0, 16777215 PIXEL STYLE DS_MODALFRAME
	
    @ 005, 003 GROUP oGroupv1 TO 038, 130 PROMPT " Informe a quantidade base a ser considerada " OF oDlgv COLOR  0, 16777215 PIXEL
    @ 018, 005   SAY   oSayv1 PROMPT "Qtd Base:"	SIZE 037, 007 OF oDlgv COLORS 0, 16777215 PIXEL
    @ 018, 045 MSGET   oGetv1    VAR _nGetQtd     	SIZE 070, 010 OF oDlgv PICTURE PesqPict("SG1","G1_QUANT") VALID NAOVAZIO() .And. ValidQtdB() COLORS 0, 16777215 PIXEL

    @ 047, 003 GROUP oGroupv1 TO 080, 130 PROMPT " Informe a quantidade a ser produzida " OF oDlgv COLOR  0, 16777215 PIXEL
    @ 061, 005   SAY   oSayv1 PROMPT "Qtd Destino:"	SIZE 037, 007 OF oDlgv COLORS 0, 16777215 PIXEL
    @ 061, 045 MSGET   oGetv1    VAR _nGetQtdD     	SIZE 070, 010 OF oDlgv PICTURE PesqPict("SG1","G1_QUANT") VALID NAOVAZIO() .And. ValidQtdD() COLORS 0, 16777215 PIXEL
	
    DEFINE SBUTTON oSButtonv1 FROM 088, 102 TYPE 01 OF oDlgv ENABLE ACTION FecharObj()
	
  ACTIVATE MSDIALOG oDlgv CENTERED
  
Return(_nGetQtd)

Static Function ValidQtdB()

Local _lRet		:= .T.

If AllTrim(ReadVar())=="_NGETQTD"
	_nGetQtdD := _nGetQtd * _nMultMin
EndIf

RecLock(_cTabTmp,.F.)
	(_cTabTmp)->TM_QB	:= _nGetQtd
(_cTabTmp)->(MsUnlock())

Return(_lRet)

Static Function ValidQtdD()

Local _lRet		:= .T.

If AllTrim(ReadVar())=="_NGETQTDD"
	_nGetQtd := _nGetQtdD / _nMultMin
EndIf

RecLock(_cTabTmp,.F.)
	(_cTabTmp)->TM_QUANT	:= _nGetQtdD
(_cTabTmp)->(MsUnlock())

Return(_lRet)

Static Function FecharObj()

Close(oDlgv)

//Inibe a tecla de atalho para prevenir duplicidade da abertura da janela
SetKey(VK_F12,{|| })
SetKey(VK_F12,{|| AtuQtd()})

Return()

Static Function Comparar()

	Private lDif := .F.  
	
	Processa({|| A200PrCom(_cProduto,'   ',dDataBase,'',(_cTabTmp)->TM_COD,'   ',dDataBase,'') })
Return()

Static Function A200PrCom(cCodOrig,cRevOrig,dDtRefOrig,cOpcOrig,cCodDest,cRevDest,dDtRefDest,cOpcDest)

Local aEstruOri:={}
Local aEstruDest:={}
Local aSize    := MsAdvSize(.T.)
Local oDlg,oTree,oTree2,aObjects:={},aInfo:={},aPosObj:={},aButtons:={}
Local cDescOri	:= "",cDescDest := ""
Local l800x600	:= .F.
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta a  tela com o tree da versao base e com o tree da versao³
//³resultado da comparacao.                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aAdd( aObjects, { 100, 100, .T., .T., .F. } )
aAdd( aObjects, { 100, 100, .T., .T., .F. } )
aInfo  := { aSize[1],aSize[2],aSize[3],aSize[4],3,3 }
aPosObj:= MsObjSize( aInfo, aObjects, .T.,.T. )

l800x600 := aSize[5] <= 800

If ExistBlock( "MA200BUT" ) 
	If Valtype( aUsrBut := Execblock( "MA200BUT", .f., .f. ) ) == "A"
		AEval( aUsrBut, { |x| AAdd( aButtons, x ) } ) 
	EndIF 
EndIf 
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta array com os conteudos dos tree                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄnÄÄÄÄÄÄÄÄÄÄÄÙ
SG1->(dbSeek(xFilial("SG1")+cCodOrig))
M200Expl(cCodOrig,cRevOrig,dDtRefOrig,cOpcOrig,1,aEstruOri,0)
SG1->(dbSeek(xFilial("SG1")+cCodDest))
M200Expl(cCodDest,cRevDest,dDtRefDest,cOpcDest,1,aEstruDest,0)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Iguala os arrays de origem e destino da comparacao                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Mt200CpAr(aEstruOri,aEstruDest,cCodOrig,cCodDest)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Descricao do Produto Origem e Destino                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If SB1->(MsSeek(xFilial("SB1")+cCodOrig))
	cDescOri:=SB1->B1_DESC
EndIf

If SB1->(MsSeek(xFilial("SB1")+cCodDest))
	cDescDest:=SB1->B1_DESC
EndIf

DEFINE MSDIALOG oDlg TITLE OemToAnsi("Comparar Estruturas") FROM -20,-50 TO aSize[6]-50,aSize[5]-70 OF oMainWnd PIXEL 
	@ aPosObj[1,1],aPosObj[1,2] TO If(l800x600,070,060),aPosObj[1,4]-7 LABEL OemToAnsi("Produto Original") OF oDlg PIXEL

	@ aPosObj[1,1]+10,028 MSGET cCodOrig   When .F. SIZE 105,09 OF oDlg PIXEL
	@ aPosObj[1,1]+26,158 MSGET cRevOrig   Picture PesqPict("SC2","C2_REVISAO") When .F. SIZE 15,09 OF oDlg PIXEL
	@ aPosObj[1,1]+10,194 MSGET dDtRefOrig Picture PesqPict("SD3","D3_EMISSAO") When .F. SIZE 44,09 OF oDlg PIXEL

	@ aPosObj[1,1]+12,006 SAY OemtoAnsi("Produto")  SIZE 24,7  OF oDlg PIXEL 
	@ aPosObj[1,1]+28,135 SAY OemToAnsi("Revisao")  SIZE 32,13 OF oDlg PIXEL 
	@ aPosObj[1,1]+12,152 SAY OemToAnsi("Data Referencia")  SIZE 50,09 OF oDlg PIXEL 
	
	@ aPosObj[1,1]+26,194 MSGET cOpcOrig   When .F. SIZE 35,09 OF oDlg PIXEL
	@ aPosObj[1,1]+28,182 SAY OemtoAnsi("Opc.")   SIZE 24,7  OF oDlg PIXEL
	@ aPosObj[1,1]+28,006 SAY OemtoAnsi(cDescOri) SIZE 130,6 Color CLR_HRED OF oDlg PIXEL	
	
	@ aPosObj[2,1], aPosObj[2,2]-8 TO If(l800x600,070,060),aPosObj[2,4]-8 LABEL OemToAnsi("Produto Destino") OF oDlg PIXEL

	@ aPosObj[2,1]+10,aPosObj[2,2]+015 MSGET cCodDest   When .F. SIZE 105,9 OF oDlg PIXEL
	@ aPosObj[2,1]+26,aPosObj[2,2]+152 MSGET cRevDest   Picture PesqPict("SC2","C2_REVISAO") When .F.  SIZE 15,09 OF oDlg PIXEL
	@ aPosObj[2,1]+10,aPosObj[2,2]+190 MSGET dDtRefDest Picture PesqPict("SD3","D3_EMISSAO") When .F. SIZE 44,09 OF oDlg PIXEL

	@ aPosObj[2,1]+12,aPosObj[2,2]-006 SAY OemToAnsi("Produto")   SIZE 24,7  OF oDlg PIXEL
	@ aPosObj[2,1]+28,aPosObj[2,2]+130 SAY OemToAnsi("Revisao")   SIZE 32,13 OF oDlg PIXEL
	@ aPosObj[2,1]+12,aPosObj[2,2]+147 SAY OemToAnsi("Data Referencia")   SIZE 50,09 OF oDlg PIXEL

	@ aPosObj[2,1]+26,aPosObj[2,2]+190 MSGET cOpcDest   When .F. SIZE 35,09 OF oDlg PIXEL		
	@ aPosObj[2,1]+28,aPosObj[2,2]+178 SAY OemtoAnsi("Opc.")    SIZE 24,7  OF oDlg PIXEL
	@ aPosObj[2,1]+28,aPosObj[2,2]-006 SAY OemtoAnsi(cDescDest) SIZE 130,6 Color CLR_HRED OF oDlg PIXEL
	
	oTree:= dbTree():New(aPosObj[1,1]+If(l800x600,060,050), aPosObj[1,2],aPosObj[1,3]-10,aPosObj[1,4]-10, oDlg,,,.T.)
	oTree:lShowHint := .F. 
	A200Itens(oTree,aEstruOri,NIL,NIL)
	oTree2:=dbTree():New(aPosObj[2,1]+If(l800x600,060,050), aPosObj[2,2]-10,aPosObj[2,3]-10,aPosObj[2,4]-10, oDlg,,,.T.)
	oTree:lShowHint := .F. 
	A200Itens(oTree2,aEstruDest,NIL,NIL)
	AAdd( aButtons, { "PMSSETADOWN", { || Mt200Nav(1,@oTree,@oTree2,aEstruOri,aEstruDest) },OemToAnsi("Desce")} )
	AAdd( aButtons, { "PMSSETAUP"  , { || Mt200Nav(2,@oTree,@oTree2,aEstruOri,aEstruDest) },OemToAnsi("Sobe")} )
	AAdd( aButtons, { "DBG09"      , { || Mt200Inf() }, "Legenda" } )
ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg, {||oDlg:End()} ,{||oDlg:End()},,aButtons)
Return Nil

STATIC Function M200Expl(cProduto,cRevisao,dDataRef,cOpcionais,nQuantPai,aEstru,nNivelEstr)
LOCAL nReg:=0,nQuantItem:=0,nHistorico:=4 // Produto ok
LOCAL nNivelBase := 999
LOCAL lExistBlock := ExistBlock("M200NIV") 
LOCAL nRet

// Estrutura do array
// [1] Produto PAI
// [2] Componente
// [3] TRT
// [4] Quantidade
// [5] Historico
// [6] Nivel
// [7] Cargo = [6]+[2]+[3]
// [8] Revisao inicial
// [9] Revisao final

dbSelectArea("SB1")
dbSetOrder(1)
dbSelectArea("SG1")
dbSetOrder(1)
While !Eof() .And. G1_FILIAL+G1_COD == xFilial("SG1")+cProduto
	nReg := Recno()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Calcula a qtd dos componentes                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nHistorico := 4
	nQuantItem := ExplEstr(nQuantPai,dDataRef,cOpcionais,cRevisao,@nHistorico)
	dbSelectArea("SG1")
	SB1->(dbSeek(xFilial("SB1")+SG1->G1_COMP))
	If QtdComp(nQuantItem) < QtdComp(0)
		nQuantItem:=If(QtdComp(RetFldProd(SB1->B1_COD,"B1_QB"))>0,RetFldProd(SB1->B1_COD,"B1_QB"),1)
	EndIf
	AADD(aEstru,{SG1->G1_COD,SG1->G1_COMP,SG1->G1_TRT,nQuantItem,nHistorico,nNivelEstr,StrZero(nNivelEstr,5,0)+SG1->G1_COMP+SG1->G1_TRT,SG1->G1_REVINI,SG1->G1_REVFIM})
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se existe sub-estrutura                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SG1")
	If dbSeek(xFilial("SG1")+SG1->G1_COMP)
		nNivelEstr++
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Ponto de entrada para definir o nivel de comparacao                     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lExistBlock 
			nRet := (ExecBlock("M200NIV",.F.,.F.))
			If ( Valtype(nRet) == "N" )
				nNivelBase := nRet
			EndIf
		EndIf		
			
		If nNivelEstr <= nNivelBase
			M200Expl(SG1->G1_COD,SB1->B1_REVATU,dDataRef,cOpcionais,nQuantItem,aEstru,nNivelEstr)
		EndIf
		nNivelEstr--
	EndIf
	dbGoto(nReg)
	dbSkip()
EndDo
Return(.T.)

Static Function Mt200CpAr(aEstruOri,aEstruDest,cCodOrig,cCoddest)
Local nz:=0,nw:=0,nAcho:=0
Local cProcura:="",lFirstLevel:=.F.

// Estrutura do array
// [1] Produto PAI
// [2] Componente
// [3] TRT
// [4] Quantidade
// [5] Historico
// [6] Nivel
// [7] Cargo = [6]+[2]+[3]
// [8] Revisao inicial
// [9] Revisao final

// Compara os elementos em comum do array
// Adiciona no array origem os componentes do array destino diferentes
For nz:=1 To Len(aEstruDest)
	// Verifica se esta no primeiro nivel
	If aEstruDest[nz,6]==0
		lFirstLevel:=.T.
	Else
		lFirstLevel:=.F.
	EndIf
	// Nao procura o produto pai junto
	If lFirstLevel
		cProcura:=aEstruDest[nz,2]+aEstruDest[nz,3]
	// Procura o produto pai junto
	Else
		cProcura:=aEstruDest[nz,1]+aEstruDest[nz,2]+aEstruDest[nz,3]
	EndIf
	// Efetua procura no array origem
	nAcho:=ASCAN(aEstruOri,{|x| x[6] == aEstruDest[nz,6] .And. (If(lFirstLevel,x[2]+x[3],x[1]+x[2]+x[3]) == cProcura)})
	// Caso nao achou soma componentes no array origem com a estrutura do item
	If nAcho == 0
		For nw:=nz to Len(aEstruDest)
			AADD(aEstruOri,{If(lFirstLevel,If(Len(aEstruOri)> 0,aEstruOri[1,1],cCodOrig),aEstruDest[nw,1]),aEstruDest[nw,2],aEstruDest[nw,3],aEstruDest[nw,4],5,aEstruDest[nw,6],aEstruDest[nw,7],aEstruDest[nw,8],aEstruDest[nw,9]})
			// Desliga flag de primeiro nivel
			If lFirstLevel
				lFirstLevel:=.F.
			EndIf
			If nw == Len(aEstruDest) .Or. (aEstruDest[nz,6] == aEstruDest[nw+1,6])
				nz:=nw
				Exit
			EndIf
		Next nw
	EndIf
Next nz

// Adiciona no array destino os componentes do array origem diferentes
For nz:=1 To Len(aEstruOri)
	// Verifica se esta no primeiro nivel
	If aEstruOri[nz,6]==0
		lFirstLevel:=.T.
	Else
		lFirstLevel:=.F.
	EndIf	
	// Nao procura o produto pai junto
	If lFirstLevel
		cProcura:=aEstruOri[nz,2]+aEstruOri[nz,3]
	// Procura o produto pai junto
	Else
		cProcura:=aEstruOri[nz,1]+aEstruOri[nz,2]+aEstruOri[nz,3]
	EndIf
	// Efetua procura no array origem
	nAcho:=ASCAN(aEstruDest,{|x| x[6] == aEstruOri[nz,6] .And. (If(lFirstLevel,x[2]+x[3],x[1]+x[2]+x[3]) == cProcura)})
	// Caso nao achou soma componentes no array origem com a estrutura do item
	If nAcho == 0
		For nw:=nz to Len(aEstruOri)
			AADD(aEstruDest,{If(lFirstLevel,If(Len(aEstruDest)> 0,aEstruDest[1,1],cCodDest),aEstruOri[nw,1]),aEstruOri[nw,2],aEstruOri[nw,3],aEstruOri[nw,4],5,aEstruOri[nw,6],aEstruOri[nw,7],aEstruOri[nw,8],aEstruOri[nw,9]})
			// Desliga flag de primeiro nivel
			If lFirstLevel
				lFirstLevel:=.F.
			EndIf
			If nw == Len(aEstruOri) .Or. (aEstruOri[nz,6] == aEstruOri[nw+1,6])
				nz:=nw
				Exit
			EndIf
		Next nw
	EndIf
Next nz

// Ordena arrays por nivel
ASORT(aEstruOri,,,{|x,y| x[7] < y[7] })
ASORT(aEstruDest,,,{|x,y| x[7] < y[7] })
RETURN(.T.)

Static Function Mt200Nav(nTipo,oTree,oTree2,aEstruOri,aEstruDest)
Local cCargoAtu  :=oTree2:GetCargo()
Local cCargoVazio:=Space(5+Len(SG1->G1_COMP+SG1->G1_TRT))
Local nPos       :=Ascan(aEstruDest,{|x| x[7] == cCargoAtu})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Posiciona o tree na linha de baixo                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nTipo == 1 .And. nPos < Len(aEstruDest)
	oTree:TreeSeek(aEstruOri[nPos+1,7])
	oTree2:TreeSeek(aEstruDest[nPos+1,7])
	oTree:Refresh()
	oTree2:Refresh()
ElseIf nTipo == 2 .And. nPos >= 1
	oTree :TreeSeek(If(nPos-1<=0,cCargoVazio,aEstruOri[nPos-1,7]))
	oTree2:TreeSeek(If(nPos-1<=0,cCargoVazio,aEstruDest[nPos-1,7]))
	oTree:Refresh()
	oTree2:Refresh()
Else
	oTree:TreeSeek(If(nPos>0,aEstruOri[nPos,7],cCargoVazio))
	oTree2:TreeSeek(If(nPos>0,aEstruDest[nPos,7],cCargoVazio))
	oTree:Refresh()
	oTree2:Refresh()
EndIf
Return(.T.)

Static Function Mt200Inf()
Local oDlg,oBmp1,oBmp2,oBmp3,oBmp4,oBmp5
Local oBut1
DEFINE MSDIALOG oDlg TITLE "Legenda" OF oMainWnd PIXEL FROM 0,0 TO 200,550
@ 2,3 TO 080,273 LABEL "Legenda" PIXEL
@ 18,10 BITMAP oBmp1 RESNAME "PMSTASK1" SIZE 16,16 NOBORDER PIXEL
@ 18,20 SAY OemToAnsi("Componente não existe") OF oDlg PIXEL
@ 18,150 BITMAP oBmp2 RESNAME "PMSTASK6" SIZE 16,16 NOBORDER PIXEL
@ 18,160 SAY OemToAnsi("Componente OK") OF oDlg PIXEL
@ 30,10 BITMAP oBmp3 RESNAME "PMSTASK2" SIZE 16,16 NOBORDER PIXEL
@ 30,20 SAY OemToAnsi("Componente fora das revisões") OF oDlg PIXEL
@ 42,10 BITMAP oBmp4 RESNAME "PMSTASK5" SIZE 16,16 NOBORDER PIXEL
@ 42,20 SAY OeAmToAnsi("Componente fora dos grupos opcionais") OF oDlg PIXEL
@ 54,10 BITMAP oBmp5 RESNAME "PMSTASK4" SIZE 16,16 NOBORDER PIXEL
@ 54,20 SAY OemToAnsi("Componente fora das datas de início e fim") OF oDlg PIXEL
DEFINE SBUTTON oBut1 FROM 085,244 TYPE 1  ACTION (oDlg:End())  ENABLE of oDlg
ACTIVATE MSDIALOG oDlg CENTERED
Return(.T.)

Static Function A200Itens(oObjTree,aEstru,cProduto,nz,aDbTree)
Local nAcho:=0
Local aOcorrencia :={}
Local cTexto:=""
Local cCargoVazio:=Space(5+Len(SG1->G1_COMP+SG1->G1_TRT))
Default nz:=1                                   
Default cProduto:=""                            
Default aDbTree := {}

// Ordem de pesquisa por codigo
SB1->(dbSetOrder(1))

// Array com as ocorrencias cadastradas
AADD(aOcorrencia,"PMSTASK4") //"Componente fora das datas inicio / fim"
AADD(aOcorrencia,"PMSTASK5") //"Componente fora dos grupos de opcionais"
AADD(aOcorrencia,"PMSTASK2") //"Componente fora das revisoes"
AADD(aOcorrencia,"PMSTASK6") //"Componente ok"
AADD(aOcorrencia,"PMSTASK1") //"Componente nao existente"

// Monta tree na primeira vez
If Empty(cProduto) .And. Len(aEstru) > 0
	cProduto:=aEstru[1,1]
	oObjTree:BeginUpdate()
	oObjTree:Reset()
	oObjTree:EndUpdate()
	// Coloca titulo no TREE
	SB1->(dbSeek(xFilial("SB1")+aEstru[1,1]))
	oObjTree:AddTree(AllTrim(aEstru[1,1])+" - "+Alltrim(Substr(SB1->B1_DESC,1,30))+Space(60),.T.,,,aOcorrencia[4],aOcorrencia[4],cCargoVazio)
EndIf

While nz <= Len(aEstru)
	// Verifica se componente tem estrutura
	nAcho:=ASCAN(aEstru,{|x| x[1] == aEstru[nz,2]})
	// Monta Texto
	SB1->(dbSeek(xFilial("SB1")+aEstru[nz,2]))
	cTexto:=Alltrim(aEstru[nz,2])+" - "+AllTrim(Substr(SB1->B1_DESC,1,30))+" / Seq.: " + aEstru[nz,3]+" / Rev.:" + aEstru[nz,8]+" - "+aEstru[nz,9] + " / Qtd .: " + AllTrim(Str(aEstru[nz,4] )) + "  " + SB1->B1_UM + " / Ativ.: " + AllTrim(Str(SG1->G1_ATIVIDA)) + AllTrim(SG1->G1_UNATIV)//Space(20)
	If ExistBlock("M200CPTX")	
		cM200CPTX := ExecBlock("M200CPTX",.F.,.F.,{cTexto,aEstru[nz][1],aEstru[nz][2],SB1->B1_DESC,aEstru[nz][3],aEstru[nz][4],aEstru[nz][8],aEstru[nz][9]})
		If ValType(cM200CPTX) == "C"
			cTexto := cM200CPTX
		EndIf
	EndIf
	If nAcho > 0
		If Empty(AsCan(aDbTree,{|x|x[1]==cTexto .And. x[2]==aEstru[nz,1] .And. x[3]==aEstru[nz,5] .And. x[4] == aEstru[nz,7] .And. x[5]==nz}))
			Aadd(aDbTree,{cTexto,aEstru[nz,1],aEstru[nz,5],aEstru[nz,7],nz})			
			// Coloca titulo no TREE
			oObjTree:AddTree(cTexto,.T.,,,aOcorrencia[aEstru[nz,5]],aOcorrencia[aEstru[nz,5]],aEstru[nz,7])
			// Chama funcao recursiva
			A200Itens(oObjTree,aEstru,aEstru[nz,2],nAcho,aDbTree)	
			// Encerra TREE
			oObjTree:EndTree() 
		EndIf
	ElseIf aEstru[nz,1] == cProduto
		// Adiciona item no tree
		If (!lDif .Or. aEstru[nz,5] <> 4) .And. Empty(AsCan(aDbTree,{|x|x[1]==cTexto .And. x[2]==aEstru[nz,1] .And. x[3]== aEstru[nz,5] .And. x[4]==aEstru[nz,7] .And. x[5]==nz}))
			Aadd(aDbTree,{cTexto,aEstru[nz,1],aEstru[nz,5],aEstru[nz,7],nz})
			oObjTree:AddTreeItem(cTexto,aOcorrencia[aEstru[nz,5]],aOcorrencia[aEstru[nz,5]],aEstru[nz,7])
		EndIf
	EndIf
	nz++
End
RETURN(.T.)

Static Function ComparaEstr()

	_cQEmp	:= GetNextAlias()
	
	_cQryEmp := "SELECT " + _cEnter
	_cQryEmp += "DEST.G1_COMP, " + _cEnter
	_cQryEmp += "ORI.G1_QUANT [QTD_ORI], " + _cEnter
	_cQryEmp += "DEST.G1_QUANT [QTD_DEST], " + _cEnter
	_cQryEmp += "DEST.G1_TIPO, " + _cEnter
	_cQryEmp += "ROUND((CASE WHEN ORI.G1_TIPO='4' THEN DEST.G1_QUANT/ORI.G1_QUANT ELSE ORI.G1_ATIVIDA/DEST.G1_ATIVIDA END),2) [MULT_MIN], " + _cEnter
	_cQryEmp += "CASE WHEN DEST.G1_TIPO='2' THEN 'S' ELSE '' END AS [ENZIMA], " + _cEnter
	_cQryEmp += "ORI.G1_ATIVIDA [ATIV_ORI], " + _cEnter
	_cQryEmp += "DEST.G1_ATIVIDA [ATIV_DEST] " + _cEnter
	_cQryEmp += "FROM " + RetSqlName("SG1") + " ORI " + _cEnter
	_cQryEmp += "INNER JOIN " + RetSqlName("SG1") + " DEST " + _cEnter
	_cQryEmp += "ON ORI.D_E_L_E_T_='' " + _cEnter
	_cQryEmp += "AND ORI.G1_FILIAL='" + xFilial("SG1") + "' " + _cEnter
	_cQryEmp += "AND ORI.D_E_L_E_T_='' " + _cEnter
	_cQryEmp += "AND ORI.G1_FILIAL='" + xFilial("SG1") + "' " + _cEnter
	_cQryEmp += "AND ORI.G1_COD='" + _cProduto + "' " + _cEnter
	_cQryEmp += "AND DEST.G1_COD='" + (_cTabTmp)->(TM_COD) + "' " + _cEnter
	_cQryEmp += "AND ORI.G1_COMP=DEST.G1_COMP " + _cEnter
	_cQryEmp += "AND ORI.G1_TIPO NOT IN ('1','3') " + _cEnter
	_cQryEmp += "INNER JOIN " + RetSqlName("SB1") + " SB1 " + _cEnter
	_cQryEmp += "ON SB1.B1_COD=ORI.G1_COMP "
	_cQryEmp += "UNION ALL " + _cEnter
	_cQryEmp += "SELECT G1_COMP, 0 [QTD_ORI], G1_QUANT [QTD_DEST], G1_TIPO, 0 [MULT_MIN], '' [ENZIMA], 0 [ATIV_ORI], 0 [ATIV_DEST] FROM " + RetSqlName("SG1") + " EMB " + _cEnter
	_cQryEmp += "WHERE EMB.D_E_L_E_T_='' " + _cEnter
	_cQryEmp += "AND EMB.G1_FILIAL='" + xFilial("SG1") + "' " + _cEnter
	_cQryEmp += "AND EMB.G1_COD='" + (_cTabTmp)->(TM_COD) + "' " + _cEnter
	_cQryEmp += "AND EMB.G1_TIPO='3' " + _cEnter
	_cQryEmp += "UNION ALL " + _cEnter	
	_cQryEmp += "SELECT G1_COMP, 0 [QTD_ORI], G1_QUANT [QTD_DEST], G1_TIPO, 0 [MULT_MIN], CASE WHEN SG1.G1_TIPO='2' THEN 'S' ELSE '' END [ENZIMA], 0 [ATIV_ORI], SG1.G1_ATIVIDA [ATIV_DEST] FROM " + RetSqlName("SG1") + " SG1 " + _cEnter
	_cQryEmp += "WHERE SG1.D_E_L_E_T_='' " + _cEnter
	_cQryEmp += "AND SG1.G1_FILIAL='" + xFilial("SG1") + "' " + _cEnter
	_cQryEmp += "AND SG1.G1_COD='" + (_cTabTmp)->(TM_COD) + "' " + _cEnter
	_cQryEmp += "AND SG1.G1_COMP NOT IN " + _cEnter
	_cQryEmp += "( " + _cEnter
	_cQryEmp += "		SELECT G1_COMP FROM " + RetSqlName("SG1") + " AUX " + _cEnter
	_cQryEmp += "		WHERE AUX.D_E_L_E_T_='' " + _cEnter
	_cQryEmp += "		AND AUX.G1_FILIAL='" + xFilial("SG1") + "' " + _cEnter
	_cQryEmp += "		AND AUX.G1_COD='" + _cProduto + "' " + _cEnter
	_cQryEmp += ") "
	_cQryEmp += "UNION ALL " + _cEnter	
	_cQryEmp += "SELECT G1_COMP, 0 [QTD_ORI], G1_QUANT [QTD_DEST], G1_TIPO, 0 [MULT_MIN], CASE WHEN SG1.G1_TIPO='2' THEN 'S' ELSE '' END [ENZIMA], 0 [ATIV_ORI], SG1.G1_ATIVIDA [ATIV_DEST] FROM " + RetSqlName("SG1") + " SG1 " + _cEnter
	_cQryEmp += "WHERE SG1.D_E_L_E_T_='' " + _cEnter
	_cQryEmp += "AND SG1.G1_FILIAL='" + xFilial("SG1") + "' " + _cEnter
	_cQryEmp += "AND SG1.G1_COD='" + (_cTabTmp)->(TM_COD) + "' " + _cEnter
	_cQryEmp += "AND SG1.G1_TIPO='1' "
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQryEmp),_cQEmp,.F.,.T.)
	
	dbSelectArea(_cQEmp)
	
	_aCompSG1 := {}
	_nMultMin := 1
	
	While (_cQEmp)->(!EOF())
		
		If (_cQEmp)->MULT_MIN > _nMultMin
			_nMultMin := (_cQEmp)->MULT_MIN
		EndIf
		
		If (_cQEmp)->G1_TIPO == '3' //Embalagem
			_nQtdDes := Ceiling(((_cQEmp)->QTD_DEST/(_cTabTmp)->TM_QBBKP)*(_cTabTmp)->TM_QUANT)
			AAdd(_aCompSG1,{(_cQEmp)->G1_COMP,(_cQEmp)->QTD_ORI, _nQtdDes, (_cQEmp)->G1_TIPO, (_cQEmp)->MULT_MIN, (_cQEmp)->ENZIMA, (_cQEmp)->ATIV_ORI, (_cQEmp)->ATIV_DEST})
		Else
			AAdd(_aCompSG1,{(_cQEmp)->G1_COMP,(_cQEmp)->QTD_ORI, (_cQEmp)->QTD_DEST, (_cQEmp)->G1_TIPO, (_cQEmp)->MULT_MIN, (_cQEmp)->ENZIMA, (_cQEmp)->ATIV_ORI, (_cQEmp)->ATIV_DEST})
		EndIf
		
		dbSelectArea(_cQEmp)
		dbSkip()
	EndDo
	
	dbSelectArea(_cQEmp)
	(_cQEmp)->(dbCloseArea())
		
Return()