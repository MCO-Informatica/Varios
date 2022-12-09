#INCLUDE 'RWMAKE.CH'
#INCLUDE 'PROTHEUS.CH'

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³ RPCPE003 ³ Autor ³ Adriano Leonardo    ³ Data ³ 19/07/2016 ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina responsável por permitir apontar o saldo de um lote º±±
±±ºDesc.     ³ específico e gerar automaticamente ordens de produção para º±±
±±ºDesc.     ³ consumo desse saldo.                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Específico para a empresa Prozyn               			  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function RPCPE003()

Local _aSavArea := GetArea()
Private _cRotina:= "RPCPE003"
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
Private lblSldDisp 	
Private lblTit12
Private _nSldDisp	:= 0
Private _nGetQtd	:= 0
Public	_aEmp650	:= {}

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
	
	oDlg:lEscClose := .F.
	
	//Labels
	@ 009, 013 SAY lblPeriodo 				PROMPT "Produto:" 										SIZE _aSize[1]+025, 007 OF oDlg 						COLORS 0, 16777215 PIXEL
	@ 008, 051 MSGET oGetProd 	VAR _cProduto 														SIZE 070, 010 OF oDlg F3 "SB8OP" VALID SelecaoLote() 	COLORS 0, 16777215 PIXEL
	@ 009, 134 SAY lblLocal 				PROMPT "Armazém:" 								  		SIZE _aSize[1]+037, 007 OF oDlg 						COLORS 0, 16777215 PIXEL
	@ 008, 172 MSGET oGetLocal 	VAR _cLocal 														SIZE 020, 010 OF oDlg VALID SelecaoLote() 				COLORS 0, 16777215 PIXEL
	@ 009, 202 SAY lblLoteCtl 				PROMPT "Lote:" 						  					SIZE _aSize[1]+054, 007 OF oDlg PICTURE PesqPict("SD3","D3_LOTECTL") COLORS 0, 16777215 PIXEL
	@ 008, 230 MSGET oGetLote 	VAR _cLoteCtl 														SIZE 050, 010 OF oDlg VALID SelecaoLote() 				COLORS 0, 16777215 PIXEL
	@ 009, 300 SAY lblDescr	 				PROMPT _cDescr 											SIZE _aSize[1]+125, 007 OF oDlg 						COLORS 0, 16777215 PIXEL
	@ 009, 420 SAY lblTitVld 				PROMPT "Validade:" 										SIZE _aSize[1]+050, 007 OF oDlg 						COLORS 0, 16777215 PIXEL
	@ 009, 450 SAY lblValid 				PROMPT DTOC(_dDtValid)									SIZE _aSize[1]+030, 007 OF oDlg 						COLORS 0, 16777215 PIXEL
	@ _aSize[6]-326, 013 SAY lblTitSld 		PROMPT "Saldo Disponível: " 							SIZE _aSize[1]+050, 007 OF oDlg 						COLORS 0, 16777215 PIXEL
	@ _aSize[6]-326, 058 SAY lblSldDisp 	PROMPT Transform(_nSldDisp,PesqPict("SG1","G1_QUANT"))	SIZE _aSize[1]+035, 007 OF oDlg 						COLORS 0, 16777215 PIXEL
	@ _aSize[6]-318, 013 SAY lblTit12 		PROMPT "Para alterar a quantidade, tecle F12 " 			SIZE _aSize[1]+500, 007 OF oDlg 						COLORS 0, 16777215 PIXEL
	
	//MarkBrowse
	//Monto estrutura para tabela temporária que será utilizada no markbrowse
	AADD(_aCpos,{"TM_OK"  		,"C",_nTamMark					,0						 	})
	AADD(_aCpos,{"TM_COD" 		,"C",TamSx3("G1_COD"	)[01]	,TamSx3("G1_COD"	)[02]	})
	AADD(_aCpos,{"TM_TIPO"	 	,"C",TamSx3("B1_TIPO"	)[01]	,TamSx3("B1_TIPO"	)[02]	})
	AADD(_aCpos,{"TM_DESC" 		,"C",TamSx3("B1_DESC"	)[01]	,TamSx3("B1_DESC"	)[02]	})
	AADD(_aCpos,{"TM_QB"		,"N",TamSx3("B1_QB"		)[01]	,TamSx3("B1_QB"		)[02]	})
	AADD(_aCpos,{"TM_QBBKP"		,"N",TamSx3("B1_QB"		)[01]	,TamSx3("B1_QB"		)[02]	})
	AADD(_aCpos,{"TM_QUANT"		,"N",TamSx3("G1_QUANT"	)[01]	,TamSx3("G1_QUANT"	)[02]	})
	AADD(_aCpos,{"TM_QTDBKP"	,"N",TamSx3("G1_QUANT"	)[01]	,TamSx3("G1_QUANT"	)[02]	})
	AADD(_aCpos,{"TM_ATIVIDA"	,"N",TamSx3("G1_ATIVIDA")[01]	,TamSx3("G1_ATIVIDA")[02]	})
	AADD(_aCpos,{"TM_UNATIV"	,"C",TamSx3("G1_UNATIV"	)[01]	,TamSx3("G1_UNATIV"	)[02]	})
	AADD(_aCpos,{"TM_ALIAS"		,"C",3							,0							})
	AADD(_aCpos,{"TM_RECNO"		,"N",14							,0							})
	AADD(_aCpos,{"TM_LOCPAD"	,"C",TamSx3("B1_LOCPAD"	)[01]	,TamSx3("B1_LOCPAD"	)[02]	})
	
	_cInd1 := CriaTrab(_aCpos,.T.)
	
	//Crio tabela temporária para uso com markbrowse
	dbUseArea(.T.,,_cInd1,_cTabTmp,.T.,.F.)
	IndRegua(_cTabTmp,_cInd1,"TM_COD",,,"Criando índice temporário...")
	
	//Campos que serão apresentados no markbrowse
	AADD(_aCampos,{"TM_OK"  		,"" ,Space(_nTamMark)		,"" })
	AADD(_aCampos,{"TM_COD" 		,"" ,"Produto"   			,"" })
	AADD(_aCampos,{"TM_TIPO"		,"" ,"Tipo"					,"" })
	AADD(_aCampos,{"TM_DESC"		,"" ,"Descrição"   			,"" })
	AADD(_aCampos,{"TM_QB"			,"" ,"Qtd. Base"   			,"" })
	AADD(_aCampos,{"TM_QUANT"		,"" ,"Qtd. do Componente"   ,"" })
	AADD(_aCampos,{"TM_ATIVIDA"		,"" ,"Atividade"   			,"" })
	AADD(_aCampos,{"TM_UNATIV"		,"" ,"UN. Atividade"   		,"" })
	AADD(_aCampos,{"TM_ALIAS"		,"" ,"Alias"				,"" })
	AADD(_aCampos,{"TM_RECNO"		,"" ,"Recno"				,"" })
	
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
	
	//Query para retornar os saldos por lote x atividade
	_cQry	:= "SELECT '' [OK], SB12.B1_LOCPAD, (SB8.B8_SALDO-SB8.B8_EMPENHO) AS [B8_SLDDISP], ISNULL(SZ1.Z1_ATIVIDA,0) [Z1_ATIVIDA], ISNULL(SZ1.Z1_UNIDADE,'') [Z1_UNIDADE], SG1.R_E_C_N_O_ [G1_RECNO], " + _cEnter
	_cQry	+= "SG1.G1_COD, SB12.B1_TIPO, SB12.B1_DESC, SB12.B1_QB, SG1.G1_COMP, SB1.B1_TIPO, SG1.G1_ATIVIDA, SG1.G1_UNATIV, " + _cEnter
	_cQry	+= "CASE WHEN SB1.B1_ATIVMIN=0 THEN SG1.G1_QUANT ELSE (SG1.G1_ATIVIDA/ISNULL(SZ1.Z1_ATIVIDA,1))*SB1.B1_QB END AS [G1_QUANT] " + _cEnter
	_cQry	+= "FROM " + RetSqlName("SB8") + " SB8 WITH (NOLOCK) " + _cEnter
	_cQry	+= "INNER JOIN " + RetSqlName("SB1") + " SB1 WITH (NOLOCK) " + _cEnter
	_cQry	+= "ON SB8.D_E_L_E_T_='' " + _cEnter
	_cQry	+= "AND SB8.B8_FILIAL='" + xFilial("SB8") + "' " + _cEnter
	_cQry	+= "AND SB8.B8_PRODUTO='" + _cProduto + "' " + _cEnter
	_cQry	+= "AND SB8.B8_LOCAL='" + _cLocal + "' " + _cEnter
	_cQry	+= "AND SB8.B8_LOTECTL='" + _cLoteCtl + "' " + _cEnter
	_cQry	+= "AND (SB8.B8_SALDO-SB8.B8_EMPENH2)>0 " + _cEnter
	_cQry	+= "AND SB8.B8_PRODUTO=SB1.B1_COD " + _cEnter
	_cQry	+= "AND SB1.D_E_L_E_T_='' " + _cEnter
	_cQry	+= "AND SB1.B1_FILIAL='" + xFilial("SB1") + "' " + _cEnter
	_cQry	+= "LEFT JOIN " + RetSqlName("SZ1") + " SZ1 WITH (NOLOCK) " + _cEnter
	_cQry	+= "ON SZ1.D_E_L_E_T_='' " + _cEnter
	_cQry	+= "AND SZ1.Z1_FILIAL='" + xFilial("SZ1") + "' " + _cEnter
	_cQry	+= "AND SZ1.Z1_PRODUTO=SB8.B8_PRODUTO " + _cEnter
	_cQry	+= "AND SZ1.Z1_LOCAL=SB8.B8_LOCAL " + _cEnter
	_cQry	+= "AND SZ1.Z1_LOTECTL=SB8.B8_LOTECTL " + _cEnter
	_cQry	+= "AND SZ1.Z1_NUMLOTE=SB8.B8_NUMLOTE " + _cEnter
	_cQry	+= "INNER JOIN " + RetSqlName("SG1") + " SG1 WITH (NOLOCK) " + _cEnter
	_cQry	+= "ON SG1.D_E_L_E_T_='' " + _cEnter
	_cQry	+= "AND SG1.G1_FILIAL='" + xFilial("SB1") + "' " + _cEnter
	_cQry	+= "AND SB8.B8_PRODUTO=SG1.G1_COMP " + _cEnter
	_cQry	+= "AND SG1.G1_ATIVIDA<=SZ1.Z1_ATIVIDA " + _cEnter
	_cQry	+= "INNER JOIN " + RetSqlName("SB1") + " SB12 WITH (NOLOCK) " + _cEnter
	_cQry	+= "ON SB12.D_E_L_E_T_='' " + _cEnter
	_cQry	+= "AND SB12.B1_FILIAL='" + xFilial("SB1") + "' " + _cEnter
	_cQry	+= "AND SB12.B1_COD=SG1.G1_COD " + _cEnter
	_cQry	+= "AND SB1.B1_REVATU>=SG1.G1_REVINI " + _cEnter
	_cQry	+= "AND SB1.B1_REVATU<=SG1.G1_REVFIM " + _cEnter
	_cQry	+= "AND (CASE WHEN SB1.B1_ATIVMIN=0 THEN SG1.G1_QUANT ELSE (SG1.G1_ATIVIDA/ISNULL(SZ1.Z1_ATIVIDA,1))*SB1.B1_QB END) BETWEEN 0 AND (SB8.B8_SALDO-SB8.B8_EMPENH2) " + _cEnter
	_cQry	+= "AND SB12.B1_MSBLQL<>'1' " + _cEnter
	_cQry	+= "AND SB1.B1_MSBLQL<>'1' "
	
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
				TM_TIPO		:= (_cQTmp)->(B1_TIPO	)
				TM_DESC		:= (_cQTmp)->(B1_DESC	)
				TM_QB		:= (_cQTmp)->(B1_QB		)
				TM_QBBKP	:= (_cQTmp)->(B1_QB		)
				TM_QUANT	:= (_cQTmp)->(G1_QUANT  )
				TM_ATIVIDA	:= (_cQTmp)->(G1_ATIVIDA)
				TM_UNATIV	:= (_cQTmp)->(G1_UNATIV	)				
				TM_ALIAS	:= "SG1"
				TM_RECNO	:= (_cQTmp)->(G1_RECNO	)
				TM_LOCPAD	:= (_cQTmp)->(B1_LOCPAD )
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
			_nSldDisp += (_cTabTmp)->(TM_QUANT) //Atualizo o saldo disponível para seleção
			lblSldDisp:SetText(Transform(_nSldDisp,PesqPict("SG1","G1_QUANT")))
		(_cTabTmp)->(MsUnLock())
	Else	
		If _nSldDisp -(_cTabTmp)->(TM_QUANT) >= 0
			RecLock(_cTabTmp,.F.)			
				(_cTabTmp)->(TM_OK)		:= cMark
				_nSldDisp -= (_cTabTmp)->(TM_QUANT) //Atualizo o saldo disponível para seleção
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
Private lMsErroAuto := .F.
Private	lProj711 := .F.
Private LMATA712 := .F.
Private	LPCPA107 := .F.
Private L650AUTO := .T.
Private LZRHEADER:= .F.
Private LCONSTERC:= .F.
Private LCONSNPT := .F.
Private AOPC1	 := {}
Private AOPC7	 := {}
Private ADATAOPC1:= {}
Private ADATAOPC7:= {}
Private AALTSALDO:= {}
PRIVATE aRotProd := aClone(aMata650)

dbSelectArea(_cTabTmp)
(_cTabTmp)->(dbGoTop())

While (_cTabTmp)->(!EOF())

	If !Empty((_cTabTmp)->(TM_OK))
	
		aMATA650	:= {}       //-Array com os campos
		_aEmp650	:= {}					
		lMsErroAuto := .F.
	
		aMata650  	:= {{'C2_FILIAL'   ,xFilial("SC2")					,NIL},;
		                {'C2_PRODUTO'  ,(_cTabTmp)->TM_COD				,NIL},;
		                {'C2_LOCAL'    ,(_cTabTmp)->TM_LOCPAD			,NIL},;
		                {'C2_NUM'      ,GETNUMSC2()                     ,NIL},;
		                {'C2_ITEM'     ,"01"							,NIL},;
		                {'C2_SEQUEN'   ,"001"							,NIL},;
		                {'C2_QUANT'    ,(_cTabTmp)->TM_QB				,NIL},;
		                {'C2_DATPRI'   ,dDataBase						,NIL},;
		                {'C2_DATPRF'   ,dDataBase						,NIL},;
		                {'C2_SALA'     ,"000"							,NIL},;		                
		                {'C2_OBS' 	   ,"OP AUTOMÁTICA ("+_cRotina+")"	,NIL}}
		
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
			L650AUTO := .T.
			LZRHEADER:= .F.
			LCONSTERC:= .F.
			LCONSNPT := .F.
			AOPC1	 := {}
			AOPC7	 := {}
			ADATAOPC1:= {}
			ADATAOPC7:= {}
			AALTSALDO:= {}
			aRotProd := aClone(aMata650)
			
			//Adiciono empenho que deverá ser "forçado" na rotina EMP650 para esse item
			AAdd(_aEmp650,{SC2->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD),_cProduto,_cLocal,_cLoteCtl,(_cTabTmp)->TM_QUANT,_dDtValid})
			
			MontEstru(SC2->C2_PRODUTO,SC2->C2_QUANT,SC2->C2_DATPRI,,,SC2->C2_PRIOR,,RetFldProd(SC2->C2_PRODUTO,"B1_OPC"),,SC2->C2_TPOP,,,)
		EndIf
	EndIf
	
	dbSelectArea(_cTabTmp)
	dbSkip()
EndDo

Fechar()

Return(!lMsErroAuto)

Static Function AtuQtd()
Local oGetv1
Local oGroupv1
Local oSayv1
Local oSButtonv1

//Inibe a tecla de atalho para prevenir duplicidade da abertura da janela
SetKey(VK_F12,{|| })

_nGetQtd  := (_cTabTmp)->TM_QB

If !Empty((_cTabTmp)->TM_OK)
	MsgAlert("Antes de alterar a quantidade, primeiro desmarque o item!",_cRotina+"_002")
	
	SetKey(VK_F12,{|| })
	SetKey(VK_F12,{|| AtuQtd()})
	
	Return(_nGetQtd)
EndIf

Static oDlgv

  DEFINE MSDIALOG oDlgv TITLE "Quantidade Base" FROM 000, 000 TO 130, 260  COLORS 0, 16777215 PIXEL STYLE DS_MODALFRAME
	
    @ 007, 003 GROUP oGroupv1 TO 058, 130 PROMPT " Informe a quantidade base a ser considerada " OF oDlgv COLOR  0, 16777215 PIXEL
    @ 021, 005   SAY   oSayv1 PROMPT "Quantidade:"	SIZE 037, 007 OF oDlgv COLORS 0, 16777215 PIXEL
    @ 019, 045 MSGET   oGetv1    VAR _nGetQtd     	SIZE 070, 010 OF oDlgv PICTURE PesqPict("SG1","G1_QUANT") VALID NAOVAZIO() .And. ValidQtd() COLORS 0, 16777215 PIXEL
	
    DEFINE SBUTTON oSButtonv1 FROM 039, 048 TYPE 01 OF oDlgv ENABLE ACTION FecharObj()
    DEFINE SBUTTON oSButtonv2 FROM 039, 048 TYPE 01 OF oDlgv ENABLE ACTION FecharObj()
	
  ACTIVATE MSDIALOG oDlgv CENTERED
  
Return(_nGetQtd)

Static Function ValidQtd()

Local _lRet		:= .T.

RecLock(_cTabTmp,.F.)
	(_cTabTmp)->TM_QB		:= _nGetQtd
	(_cTabTmp)->TM_QUANT	:= (_nGetQtd * (_cTabTmp)->TM_QTDBKP)/(_cTabTmp)->TM_QBBKP
(_cTabTmp)->(MsUnlock())

Return(_lRet)

Static Function FecharObj()

Close(oDlgv)

//Restaura a tecla de atalho para prevenir duplicidade da abertura da janela
SetKey(VK_F12,{|| })
SetKey(VK_F12,{|| AtuQtd()})

Return()