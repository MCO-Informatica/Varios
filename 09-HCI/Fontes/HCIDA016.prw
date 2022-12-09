#Include "Protheus.CH"
#Include "TopConn.CH"
#Include "RwMake.CH"     
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "RPTDEF.CH"                                                               
#INCLUDE "Font.ch"
#INCLUDE "DBINFO.CH"
#INCLUDE "TBICONN.CH"

//-------------------------------------------------------------------
/*/{Protheus.doc} HCIA017
Rotina para follow up de processos

@author 	BZechetti | Bruna Zechetti de Oliveira
@since 		22/04/2015
@version 	P12
@obs    	Rotina Especifica HCI
/*/
//-------------------------------------------------------------------
User Function HCIDA016()

	CreateBrw()

Return()

//-------------------------------------------------------------------
/*/{Protheus.doc} CreateBrw
Função para criação e seleção dos dados a sere aprosentados no browse.

@author 	BZechetti | Bruna Zechetti de Oliveira
@since 		22/04/2015
@version 	P11
@obs    	Rotina Especifica HCI
/*/
//-------------------------------------------------------------------
Static Function CreateBrw(lReload) 

	Local cAliasBrw		:= "SZQ"
	Local aFixe			:= {} 
	Local aTemp			:= {}
	Local cQuery		:= ""
	Local cAliasQry		:= GetNextAlias()
	Local _nI			:= 0
	Local _cCampos		:= ""
	Local _cCmpNVis		:= "ZQ_NUMERO|ZQ_CLIENTE|ZQ_NOME|ZQ_DATA|ZQ_D_FOLLO|ZQ_ELABORA|ZQ_PROJETO|ZQ_VLALFR|ZQ_PARECER|ZQ_OBSERV|ZQ_LOJA|ZQ_FILIAL"
	Local _aCmpNVis		:= {"ZQ_D_FOLLO","ZQ_ELABORA","ZQ_NUMERO","ZQ_CLIENTE","ZQ_NOME","ZQ_DATA","ZQ_PROJETO","ZQ_VLALFR","ZQ_PARECER","ZQ_OBSERV","ZQ_LOJA","ZQ_FILIAL"}
	Local _nCont		:= 0
	Local _nI			:= 0
	Local oBrowse
	
	Private cCadastro 	:= "Follow Up de Processos"
	Private aRotina 	:= MenuDef() 
	Private _aCampos	:= {}
	Private _alEncho	:= {}
	pRIVATE aArray		:= {}
	pRIVATE cAliasTRB	:= FGetAlias()
	private cFiltroBrw	:= ""
	Private aTela       := {}
	Private aGets       := {}
	Private _dDCorte	:= AllTrim(SuperGetMv("ES_HC016DC",,"20150101"))

	Private bFiltraBrw   := { || .F. }

	Default	lReload		:= .F.
	
	DbSelectArea("SX3")
	SX3->(DbSetOrder(2)) // Campo
	For _nI := 1 to Len(_aCmpNVis)
		If SX3->(MsSeek(_aCmpNVis[_nI]))
			Aadd(_aCampos,SX3->X3_CAMPO)
		EndIf
		SX3->(DBSKIP())
	Next _nI

	CreateaFixe(cAliasTRB)
	Processa({|| RecordTemp(cAliasQry,cAliasTRB)}, "Aguarde!", "Criando arquivo temporário.")

	If !lReload
		(cAliasTRB)->(DBGoTop())
		mBrowse(			,			,			,			,cAliasTRB	, aArray	,			,			,			,2				,			,			,			,			,{|| TcRefresh(cAliasTRB)}	,.T.				,			,			,cFiltroBrw		,				,					,			,)
		(cAliasTRB)->(DbCloseArea())
		MsErase(cAliasTRB)
		If TCCanOpen(cAliasTRB)
			cQuery := "DROP TABLE " +(cAliasTRB) +CRLF
			IF TcSqlExec(cQuery) < 0
				Aviso("Erro insert", TcSqlError(), {"Ok"})
			EndIf
        EndIf
   EndIf
	
Return Nil

//-------------------------------------------------------------------
/*/{Protheus.doc} FGetAlias
Função para retorno do Alias não usado

@author		Bruna Zechetti de Oliveira
@since 		22/04/2015
@version 	1.0 
@obs		Rotina Especifica HCI
/*/
//-------------------------------------------------------------------
Static Function FGetAlias()

	Local _cAlias	:= GetNextAlias()

	While TCCanOpen(_cAlias)
		_cAlias	:= GetNextAlias()
	EndDo

Return _cAlias


//-------------------------------------------------------------------
/*/{Protheus.doc} MenuDef
Menu Funcional - Follow up de processos

@author		Bruna Zechetti de Oliveira
@since 		22/04/2015
@version 	1.0 
@obs		Rotina Especifica HCI
/*/
//-------------------------------------------------------------------
Static Function MenuDef()

	Local aRotina	:= {}
	
	
	aAdd( aRotina, { "Visualizar"	,"StaticCall(HCIA017,_fMntZQ,1,1)"	,0,2 } )
	aAdd( aRotina, { "Filtrar"		,"StaticCall(HCIA017,_f017Man)"		,0,7 } )
	aAdd( aRotina, { "Incluir"		,"StaticCall(HCIA017,_fMntZQ,4,1)"	,0,3 } )
	aAdd( aRotina, { "Alterar"		,"StaticCall(HCIDA016,_fMntZQ,2,1)"	,0,4 } )
	aAdd( aRotina, { "Excluir"		,"StaticCall(HCIA017,_fMntZQ,3,1)"	,0,5 } )
	

Return aRotina                                                                  

//--------------------------------------------------------------------
/*/{Protheus.doc} CreateaFixe
Cria as colunas do arquivo temporário

@author Bruna Zechetti de Oliveira
@since  22/04/2015
@obs    
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function CreateaFixe(cAliasTRB)

	Local nI		:= 0
	Local aStruct	:= {}
	Local aAreaSX3	:= SX3->(GetArea()) 
	Local _nPos		:= 0
	Local cArqTrb
	
	aAdd(aArray	,{"Status","ZQ_STATUS","C",20,0,"@!"})
	aAdd(aStruct,{"ZQ_STATUS", "C",20,0})		
	aAdd(aArray	,{"Proc.Para?","DTIPO","C",20,0,"@!"})
	aAdd(aStruct,{"DTIPO", "C",20,0})
		
	SX3->(DbsetOrder(2))
	For nI := 1 To Len( _aCampos )
		If SX3->(DbSeek( _aCampos[nI] ))
			aAdd(aArray	,{SX3->X3_TITULO,AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,Iif(AllTrim(SX3->X3_CAMPO)=="ZQ_TIPO",30,SX3->X3_TAMANHO),SX3->X3_DECIMAL,SX3->X3_PICTURE})
			aAdd(aStruct,{AllTrim(_aCampos[nI]), SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		EndIf		
	Next nI
	
	aAdd(aArray	,{"FLAG","FLAG","C",1,0,"@!"})	
	aAdd(aStruct,{"FLAG", "C",1,0})
	
	_nPos	:= aScan(aArray,{|X| AllTrim(X[2]) == "ZQ_VLALFR"})
	If _nPos > 0
		aArray[_nPos,6]	:= "@E 99,999,999,999.99"
	EndIf
	
	If Select(cAliasTRB)>0
	 (cAliasTRB)->(DbCloseArea())
	EndIf   
	
	MsErase(cAliasTRB)
	MsCreate(cAliasTRB, aStruct, 'TOPCONN' )
	DbUseArea( .T., 'TOPCONN', cAliasTRB, cAliasTRB, .T., .F. )

	cInd2 := cAliasTRB+'2'
	cChave := "FLAGZQ_ELABORA+ZQ_NUMERO"
//	IndRegua(cAliasTRB,cAliasTRB,cChave,,)
	INDEX ON FLAG+ZQ_ELABORA+ZQ_NUMERO TAG (cInd2) TO (cAliasTRB)

	RestArea(aAreaSX3)

Return(aArray) 

//--------------------------------------------------------------------
/*/{Protheus.doc} RecordTemp
Grava as informações no arquivo temporario.

@author Bruna Zechetti de Oliveira
@since  22/04/2015
@obs    
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function RecordTemp(cAlias,cAliasTRB) 

	Local _nJ		:= 0
	lOCAL cQuery	:= ""

	cQuery := "INSERT INTO " + cAliasTRB
	cQuery += "			(ZQ_FILIAL  "+CRLF
	cQuery += " 		,ZQ_NUMERO  "+CRLF
	cQuery += " 		,ZQ_CLIENTE "+CRLF
	cQuery += " 		,ZQ_LOJA    "+CRLF
	cQuery += " 		,ZQ_NOME    "+CRLF
	cQuery += " 		,ZQ_DATA    "+CRLF
	cQuery += " 		,ZQ_PROJETO "+CRLF
	cQuery += " 		,ZQ_ELABORA "+CRLF
	cQuery += " 		,ZQ_D_FOLLO "+CRLF
	cQuery += " 		,ZQ_VLALFR  "+CRLF
	cQuery += " 		,ZQ_PARECER  "+CRLF
	cQuery += " 		,ZQ_OBSERV "+CRLF
	cQuery += " 		,FLAG "+CRLF
	cQuery += " 		,DTIPO "+CRLF
	cQuery += " 		,ZQ_STATUS "+CRLF
	cQuery += " 		," + cAliasTRB + ".R_E_C_N_O_ )"+CRLF 
 	cQuery += " 		SELECT DISTINCT ZQ_FILIAL  "+CRLF
	cQuery += " 		,ZQ_NUMERO  "+CRLF
	cQuery += " 		,ZQ_CLIENTE "+CRLF
	cQuery += " 		,ZQ_LOJA    "+CRLF
	cQuery += " 		,ZQ_NOME    "+CRLF
	cQuery += " 		,ZQ_DATA    "+CRLF
	cQuery += " 		,ZQ_PROJETO "+CRLF
	cQuery += " 		,ZQ_ELABORA "+CRLF
	cQuery += " 		,ZQ_D_FOLLO "+CRLF
	cQuery += " 		,ZQ_VLALFR  "+CRLF
	cQuery += " 		,ZQ_PARECER  "+CRLF	
	cQuery += " 		,ZQ_OBSERV "+CRLF
	cQuery += " 		,(CASE WHEN ZQ_D_FOLLO='" + DTOS(DDATABASE) + "'   THEN '1' ELSE '2' END) AS FLAG "+CRLF
	cQuery += " 		,(CASE 	WHEN ZQ_TIPO = '1' THEN 'Compra' "+CRLF
	cQuery += "					WHEN ZQ_TIPO = '2' THEN 'Orcamento' "+CRLF
	cQuery += "					WHEN ZQ_TIPO = '3' THEN 'Projeto' "+CRLF
	cQuery += "					WHEN ZQ_TIPO = '4' THEN 'Cobertura' "+CRLF
	cQuery += "					WHEN ZQ_TIPO = '5' THEN 'Triangulacao' "+CRLF
	cQuery += "					WHEN ZQ_TIPO = '6' THEN 'Internet' "+CRLF
	cQuery += "					WHEN ZQ_TIPO = '7' THEN 'Fora de Escopo' "+CRLF
	cQuery += "					ELSE ZQ_TIPO
	cQuery += "		  	END) AS   DTIPO    "+CRLF
	cQuery += " 		,(CASE 	WHEN ZQ_STATUS = '01' THEN 'Em Elaboracao' "+CRLF
	cQuery += "					WHEN ZQ_STATUS = '02' THEN 'Aguard. Precos' "+CRLF
	cQuery += "					WHEN ZQ_STATUS = '03' THEN 'Enviado' "+CRLF
	cQuery += "					WHEN ZQ_STATUS = '04' THEN 'Follow-up' "+CRLF
	cQuery += "					WHEN ZQ_STATUS = '05' THEN 'Encerrado' "+CRLF
	cQuery += "					ELSE ZQ_STATUS
	cQuery += "		  	END) AS   ZQ_STATUS    "+CRLF
	cQuery += " 		,SZQ.R_E_C_N_O_ "+CRLF
	cQuery += " 		FROM "+RetSqlName("SZQ") +" SZQ "+CRLF
	cQuery += " 		WHERE SZQ.ZQ_FILIAL		= '"+xFilial("SZQ") 	+"'"+CRLF
	cQuery += "			AND SZQ.ZQ_DATA >= '" + _dDCorte + "' "
	cQuery += " 		AND SZQ.ZQ_STATUS IN ('04','01') "+CRLF	//AND SZQ.ZQ_STATUS 		=  '04'"+CRLF
	cQuery += " 		AND SZQ.D_E_L_E_T_ 		=  '" + Space(1) 		+"'"+CRLF
	
	IF TcSqlExec(cQuery) < 0
		Aviso("Erro insert", TcSqlError(), {"Ok"})
	Else
		TcRefresh(cAliasTRB)
	ENDIF

Return (.T.)

//-------------------------------------------------------------------
/*/{Protheus.doc} _f017Man
Manutenção do filtro para o follow up

@author		Bruna Zechetti de Oliveira
@since 		22/04/2015
@version 	1.0 
@obs		Rotina Especifica HCI
/*/
//-------------------------------------------------------------------
Static Function _f017Man()
                          
	Local aAreaBKP	:= GetArea()
	
	Local aCoorden	:= MsAdvSize(.T.)
	Local _lReturn  := .t.
	Local _aButtons	:= {}
	
	Private oDlgMain	:= Nil
	Private oListGrps	:= Nil
	Private _cNumero	:= Space(TAMSX3("ZQ_NUMERO")[1])
	Private _cCliente	:= Space(TAMSX3("ZQ_CLIENTE")[1])
	Private _cLoja		:= Space(TAMSX3("ZQ_LOJA")[1])
	Private _cCGC		:= Space(TAMSX3("ZQ_CNPJ")[1])
	Private _dData		:= CtoD("//")
	Private _cElabora	:= Space(TAMSX3("ZQ_ELABORA")[1])
	Private _aFollow	:= {}
	
	Aadd( _aButtons, {"ALTERA", 	{|| (_fMntZQ(2,2),_fFltTrb(1))}, "Altera...", "Alterar" , {|| .T.}} )
	Aadd( _aButtons, {"EXCLUIR",	{|| (_fMntZQ(3,2),_fFltTrb(1))}, "Excluir...", "Excluir" , {|| .T.}} )

	Aadd(_aFollow,{"",;
	SPACE(20),;
	SPACE(20),;
	SPACE(TAMSX3("ZQ_NUMERO")[1]),;
	SPACE(TAMSX3("ZQ_CLIENTE")[1]+TAMSX3("ZQ_LOJA")[1]+TAMSX3("ZQ_NOME")[1]+5),;
	SPACE(TAMSX3("ZQ_PROJETO")[1]),;
	SPACE(TAMSX3("ZQ_CONTATO")[1]),;
	SPACE(TAMSX3("ZQ_ELABORA")[1]),;
	SPACE(TAMSX3("ZQ_NEGOCIA")[1]),;
	DtoC(CtoD("//")),;
	DtoC(CtoD("//"))})

	oDlgMain := TDialog():New(aCoorden[7],000,aCoorden[6],aCoorden[5],OemToAnsi("Filtro - Follow up"),,,,,,,,oMainWnd,.T.)

		TSay():New(005,001,{|| OemToAnsi("Numero")},oDlgMain,,,,,,.T.,,,30,10)
		@ 005,040 MsGet _cNumero Picture "@!" Size 030,8 When .T. Of oDlgMain Pixel
		
		TSay():New(005,080,{|| OemToAnsi("Cliente")},oDlgMain,,,,,,.T.,,,30,10)
		@ 005,120 MsGet _cCliente Picture "@!" F3 "SA1" Size 030,8 When .T. Of oDlgMain Pixel
		
		TSay():New(005,170,{|| OemToAnsi("Loja")},oDlgMain,,,,,,.T.,,,30,10)
		@ 005,210 MsGet _cLoja Picture "@!" Size 020,8 When .T. Of oDlgMain Pixel
		
		TSay():New(005,250,{|| OemToAnsi("CNPJ")},oDlgMain,,,,,,.T.,,,30,10)
		@ 005,290 MsGet _cCGC Picture PesqPict("SZQ","ZQ_CNPJ") Size 060,8 When .T. Of oDlgMain Pixel
		
		TSay():New(020,001,{|| OemToAnsi("Dt. Follow")},oDlgMain,,,,,,.T.,,,30,10)
		@ 020,040 MsGet _dData  Size 040,8 When .T. Of oDlgMain Pixel
		
		TSay():New(020,080,{|| OemToAnsi("Elaborador")},oDlgMain,,,,,,.T.,,,30,10)
		@ 020,120 MsGet _cElabora Picture "@!" F3 "PA2A"   Size 070,8 When .T. Of oDlgMain Pixel
		
		oBtn1 := TButton():New(025, 585, "&Filtrar",oDlgMain		, {|| (_fFltTrb(1)) }, 50, 10,,, , .t.)
		oBtn2 := TButton():New(010, 585, "&Limpar Filtro",oDlgMain	, {|| (_fFltTrb(2)) }, 50, 10,,, , .t.)
		
		@ 060,001 ListBox oListGrps Var cItemSel Fields Header "","Status","Tipo","Numero","Cliente","Projeto","Contato","Elabrador","Negociador","Prev.Fehamento","Dt. Follow" Size oDlgMain:nClientWidth/2-5,oDlgMain:nClientHeight/2-61 ;
		Pixel ON DBLCLICK (_fMntZQ(1,2)) Of oDlgMain 
		
		oListGrps:SetArray(_aFollow)
		oListGrps:bLine := {||{		AllTrim(_aFollow[oListGrps:nAt][1]),;
		AllTrim(_aFollow[oListGrps:nAt][2]),;
		AllTrim(_aFollow[oListGrps:nAt][3]),;
		AllTrim(_aFollow[oListGrps:nAt][4]),;
		AllTrim(_aFollow[oListGrps:nAt][5]),;
		AllTrim(_aFollow[oListGrps:nAt][6]),;
		AllTrim(_aFollow[oListGrps:nAt][7]),;
		AllTrim(_aFollow[oListGrps:nAt][8]),;
		AllTrim(_aFollow[oListGrps:nAt][9]),;
		AllTrim(_aFollow[oListGrps:nAt][10]),;
		AllTrim(_aFollow[oListGrps:nAt][11])}}
		
	oDlgMain:Activate(,,,.T.,,,{||EnchoiceBar(oDlgMain,{|| oDlgMain:End()},{|| oDlgMain:End()},,_aButtons)},,)

	// Restaura Area Anterior
	RestArea(aAreaBKP)
	TcRefresh(cAliasTRB)
//	_fAtuFlag()

Return(.T.)

Static Function _fAtuFlag()

	cQuery := "UPDATE " +(cAliasTRB) +CRLF
	cQuery += " SET FLAG = '1' "
	cQuery += " WHERE ZQ_D_FOLLO = '" + DTOS(DDATABASE) + "'" 
	cQuery += " AND D_E_L_E_T_ 		=  '" + AllTrim(STR(SZQ->(RECNO()))) 		+"'"+CRLF
	
	IF TcSqlExec(cQuery) < 0
		Aviso("Erro insert", TcSqlError(), {"Ok"})
	Else
		TcRefresh(cAliasTRB)
		cQuery := "UPDATE " +(cAliasTRB) +CRLF
		cQuery += " SET FLAG = '2' "
		cQuery += " WHERE ZQ_D_FOLLO <> '" + DTOS(DDATABASE) + "'" 
		cQuery += " AND D_E_L_E_T_ 		=  '" + AllTrim(STR(SZQ->(RECNO()))) 		+"'"+CRLF
		
		IF TcSqlExec(cQuery) < 0
			Aviso("Erro insert", TcSqlError(), {"Ok"})
		Else
			TcRefresh(cAliasTRB)
		ENDIF
	
	ENDIF

Return()

//-------------------------------------------------------------------
/*/{Protheus.doc} _fMntZQ
Função para manutenção do registro no SZQ.

@author		Bruna Zechetti de Oliveira
@since 		22/04/2015
@version 	1.0 
@obs		Rotina Especifica HCI
/*/
//-------------------------------------------------------------------
Static Function _fMntZQ(_nOpc,_nTab)

	Local _cQuery		:=  ""
	Local _cAliasRec	:= GetNextAlias()
	LOCAL _aCpos  		:= {"ZQ_STATUS","ZQ_D_FOLLO","ZQ_PZRESP","ZQ_RESULT","ZQ_XOBS","ZQ_XHISTOR"}
	
	If _nTab == 2
		_cQuery	:= " SELECT R_E_C_N_O_ AS CRECNO "
		_cQuery += " FROM " + RetSqlName("SZQ")
		_cQuery += " WHERE ZQ_FILIAL = '" + xFilial("SZQ") + "' "
		_cQuery += " AND ZQ_NUMERO = '" + _aFollow[oListGrps:nAt][4] + "' "
		_cQuery += " AND ZQ_CLIENTE = '" + SubStr(_aFollow[oListGrps:nAt][5],2,TamSX3("A1_COD")[1]) + "' "
		_cQuery += " AND ZQ_LOJA = '" + SubStr(_aFollow[oListGrps:nAt][5],TamSX3("A1_COD")[1]+3,TamSX3("A1_LOJA")[1]) + "' "
		_cQuery	+= " AND D_E_L_E_T_ <> '*' "
		TcQuery _cQuery New Alias &(_cAliasRec)
		If (_cAliasRec)->(!EOF())
			SZQ->(dbGoTo((_cAliasRec)->CRECNO))
			Do Case
				Case _nOpc == 1
					AxVisual("SZQ",SZQ->(Recno()),2)
				Case _nOpc == 2
					AxAltera("SZQ",SZQ->(Recno()),4,,_aCpos,,,"u_fTOkZQ()","u_fGrvTrb(2)")
				Case _nOpc == 3
					AxDeleta("SZQ",SZQ->(Recno()),5,"u_fGrvTrb(3)")
				Case _nOpc == 4
					AxINCLUI("SZQ",SZQ->(Recno()),3,,,,,"u_fTOkZQ()","u_fGrvTrb(4)")
			End Case
		EndIf
		(_cAliasRec)->(DBCLOSEAREA())
	ElseIf _nOpc <> 4
		_cQuery	:= " SELECT R_E_C_N_O_ AS CRECNO "
		_cQuery += " FROM " + RetSqlName("SZQ")
		_cQuery += " WHERE ZQ_FILIAL = '" + xFilial("SZQ") + "' "
		_cQuery += " AND ZQ_NUMERO = '" + (cAliasTRB)->ZQ_NUMERO + "' "
		_cQuery += " AND ZQ_CLIENTE = '" + (cAliasTRB)->ZQ_CLIENTE + "' "
		_cQuery += " AND ZQ_LOJA = '" + (cAliasTRB)->ZQ_LOJA + "' "
		_cQuery	+= " AND D_E_L_E_T_ <> '*' "
		TcQuery _cQuery New Alias &(_cAliasRec)
		If (_cAliasRec)->(!EOF())
			SZQ->(dbGoTo((_cAliasRec)->CRECNO))
			Do Case
				Case _nOpc == 1
					AxVisual("SZQ",SZQ->(Recno()),2)
				Case _nOpc == 2
					AxAltera("SZQ",SZQ->(Recno()),4,,_aCpos,,,"u_fTOkZQ()","u_fGrvTrb(2)")
				Case _nOpc == 3
					AxDeleta("SZQ",SZQ->(Recno()),5,"u_fGrvTrb(3)")
				Case _nOpc == 4
					AxINCLUI("SZQ",SZQ->(Recno()),3,,,,,"u_fTOkZQ()","u_fGrvTrb(4)")
			End Case
		EndIf
		(_cAliasRec)->(DBCLOSEAREA())
	EndIf

	If _nOpc == 4
		AxINCLUI("SZQ",SZQ->(Recno()),3,,,,"u_fTOkZQ()",,"u_fGrvTrb(4)")
	EndIf

Return()


//-------------------------------------------------------------------
/*/{Protheus.doc} _fFltTrb
Função para filtro dos registros na tabela SZQ, gravando na GRID.

@author		Bruna Zechetti de Oliveira
@since 		22/04/2015
@version 	1.0 
@obs		Rotina Especifica HCI
/*/
//-------------------------------------------------------------------
Static Function _fFltTrb(_nOpc)

	Local cQuery	:= ""
	Local _cAliasZQ	:= GetNextAlias()
	Local oOk		:= LoadBitmap( GetResources(), "CHECKED" )
	Local oNo		:= LoadBitmap( GetResources(), "UNCHECKED" )
	
	If _nOpc == 2
		_cNumero	:= Space(TAMSX3("ZQ_NUMERO")[1])
		_cCliente	:= Space(TAMSX3("ZQ_CLIENTE")[1])
		_cLoja		:= Space(TAMSX3("ZQ_LOJA")[1])
		_cCGC		:= Space(TAMSX3("ZQ_CNPJ")[1])
		_dData		:= CtoD("//")
		_cElabora	:= Space(TAMSX3("ZQ_ELABORA")[1])

		_aFollow	:= {}		
		
		Aadd(_aFollow,{"",;
		SPACE(20),;
		SPACE(20),;
		SPACE(TAMSX3("ZQ_NUMERO")[1]),;
		SPACE(TAMSX3("ZQ_CLIENTE")[1]+TAMSX3("ZQ_LOJA")[1]+TAMSX3("ZQ_NOME")[1]+5),;
		SPACE(TAMSX3("ZQ_PROJETO")[1]),;
		SPACE(TAMSX3("ZQ_CONTATO")[1]),;
		SPACE(TAMSX3("ZQ_ELABORA")[1]),;
		SPACE(TAMSX3("ZQ_NEGOCIA")[1]),;
		DtoC(CtoD("//")),;
		DtoC(CtoD("//"))})
		
		oListGrps:SetArray(_aFollow)
		oListGrps:bLine := {||{		AllTrim(_aFollow[oListGrps:nAt][1]),;
		AllTrim(_aFollow[oListGrps:nAt][2]),;
		AllTrim(_aFollow[oListGrps:nAt][3]),;
		AllTrim(_aFollow[oListGrps:nAt][4]),;
		AllTrim(_aFollow[oListGrps:nAt][5]),;
		AllTrim(_aFollow[oListGrps:nAt][6]),;
		AllTrim(_aFollow[oListGrps:nAt][7]),;
		AllTrim(_aFollow[oListGrps:nAt][8]),;
		AllTrim(_aFollow[oListGrps:nAt][9]),;
		AllTrim(_aFollow[oListGrps:nAt][10]),;
		AllTrim(_aFollow[oListGrps:nAt][11])}}													
		
		oListGrps:nAt	:= 1
		oListGrps:Refresh()
	Else
		If !Empty(_cNumero) .Or. !Empty(_cCliente) .Or. !Empty(_cLoja) .Or. !Empty(_cCGC) .Or. !Empty(_dData) .Or. !Empty(_cElabora)
		
			cQuery := " SELECT ZQ_STATUS,ZQ_TIPO,ZQ_NUMERO,ZQ_CLIENTE,ZQ_LOJA,ZQ_NOME,ZQ_PROJETO,ZQ_CONTATO,ZQ_ELABORA,ZQ_NEGOCIA,ZQ_PZRESP,ZQ_D_FOLLO "
			cQuery += " FROM " + RetSQLName("SZQ") 
			cQuery += " WHERE ZQ_FILIAL = '" + xFilial("SZQ") + "'" 
//			cQuery += " AND ZQ_STATUS 		=  '04'"+CRLF
			
			If !Empty(_cNumero)
				cQuery += " AND ZQ_NUMERO = '" + _cNumero + "'" 
			EndIf
			
			If !Empty(_cCliente)
				cQuery += " AND ZQ_CLIENTE = '" + _cCliente + "'" 
			EndIf 
			
			If !Empty(_cLoja)
				cQuery += " AND ZQ_LOJA = '" + _cLoja + "'" 
			EndIf 
			
			If !Empty(_cCGC)
				cQuery += " AND ZQ_CNPJ = '" + _cCGC + "'" 
			EndIf 
			
			If !Empty(_dData)
				cQuery += " AND ZQ_D_FOLLO = '" + DtoS(_dData) + "'" 
			EndIf 
			
			If !Empty(_cElabora)
				cQuery += " AND ZQ_ELABORA = '" + _cElabora + "'" 
			EndIf
			
			cQuery += "	AND ZQ_DATA >= '" + _dDCorte + "' "
			cQuery += " AND D_E_L_E_T_ <> '*' "			
			cQuery += " ORDER BY ZQ_D_FOLLO DESC "
			
			cQuery := ChangeQuery(cQuery)
			TCQUERY cQuery NEW ALIAS &(_cAliasZQ)
			
			TCSetField((_cAliasZQ),"ZQ_PZRESP"	,"D",,)
			TCSetField((_cAliasZQ),"ZQ_D_FOLLO"	,"D",,)
			
			_aFollow	:= {}
	
			(_cAliasZQ)->( DbEval({|| Aadd(_aFollow,{	IIF((_cAliasZQ)->ZQ_D_FOLLO==DDATABASE,oOk,oNo),;
														Iif(AlltRim((_cAliasZQ)->ZQ_STATUS)=="01","Em Elaboracao",Iif(AlltRim((_cAliasZQ)->ZQ_STATUS)=="02","Aguard. Precos",Iif(AlltRim((_cAliasZQ)->ZQ_STATUS)=="03","Enviado",Iif(AlltRim((_cAliasZQ)->ZQ_STATUS)=="04","Follow-up",Iif(AlltRim((_cAliasZQ)->ZQ_STATUS)=="05","Encerrado",(_cAliasZQ)->ZQ_STATUS))))),;
														Iif(AllTrim((_cAliasZQ)->ZQ_TIPO)=='1',"Compra",Iif(AllTrim((_cAliasZQ)->ZQ_TIPO)=='2',"Orcamento",Iif(AllTrim((_cAliasZQ)->ZQ_TIPO)=='3',"Projeto",Iif(AllTrim((_cAliasZQ)->ZQ_TIPO)=='4',"Cobertura",Iif(AllTrim((_cAliasZQ)->ZQ_TIPO)=='5',"Triangulacao",Iif(AllTrim((_cAliasZQ)->ZQ_TIPO)=='6',"Internet",Iif(AllTrim((_cAliasZQ)->ZQ_TIPO)=='7',"Fora de Escopo",AllTrim((_cAliasZQ)->ZQ_TIPO))))))))                                           ,;
														(_cAliasZQ)->ZQ_NUMERO,;
														"["+(_cAliasZQ)->ZQ_CLIENTE+"/"+(_cAliasZQ)->ZQ_LOJA+"] - " + AllTrim((_cAliasZQ)->ZQ_NOME) ,;
														(_cAliasZQ)->ZQ_PROJETO,;
														AllTrim((_cAliasZQ)->ZQ_CONTATO),;
														AllTrim((_cAliasZQ)->ZQ_ELABORA),;
														AllTrim((_cAliasZQ)->ZQ_NEGOCIA),;
														DtoC((_cAliasZQ)->ZQ_PZRESP),;
														DtoC((_cAliasZQ)->ZQ_D_FOLLO)}) }))
	
			oListGrps:SetArray(_aFollow)
			oListGrps:bLine := {||{		AllTrim(_aFollow[oListGrps:nAt][1]),;
			AllTrim(_aFollow[oListGrps:nAt][2]),;
			AllTrim(_aFollow[oListGrps:nAt][3]),;
			AllTrim(_aFollow[oListGrps:nAt][4]),;
			AllTrim(_aFollow[oListGrps:nAt][5]),;
			AllTrim(_aFollow[oListGrps:nAt][6]),;
			AllTrim(_aFollow[oListGrps:nAt][7]),;
			AllTrim(_aFollow[oListGrps:nAt][8]),;
			AllTrim(_aFollow[oListGrps:nAt][9]),;
			AllTrim(_aFollow[oListGrps:nAt][10]),;
			AllTrim(_aFollow[oListGrps:nAt][11])}}													
			
			oListGrps:nAt	:= 1
			oListGrps:Refresh()
	
		Else
			Aviso(OEMTOANSI("Atenção"),"Campos para realizar o filtro estão em branco. Favor preenche-los!",{"Ok"},2)	
		EndIf
	EndIf
	
Return()