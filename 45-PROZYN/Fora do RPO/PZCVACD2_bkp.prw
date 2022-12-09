#include 'protheus.ch'
#include 'parmtype.ch'

#DEFINE PR_OPDE		1
#DEFINE PR_OPATE	2
#DEFINE PR_EMISDE	3
#DEFINE PR_EMISATE	4
#DEFINE PR_OSAGLUT	5
#DEFINE PR_OPERADOR	6

#DEFINE MARK		1
#DEFINE NUM 		2
#DEFINE ITEM		3
#DEFINE SEQUENCIA	4
#DEFINE EMISSAO		5
#DEFINE PRODUTO		6
#DEFINE DESC 		7
#DEFINE ARMAZEM		8
#DEFINE QUANT		9
#DEFINE LOTECTL		10

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³PZCVACD2		ºAutor  ³Microsiga	     º Data ³  17/02/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina utilizada para gerar ordem de separação			  º±±
±±º          ³												              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Ap		                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/ 
User Function PZCVACD2()

	Local aArea		:= GetArea()
	Local aParam	:= {}
	
	If Perg0002(@aParam)//Parametros para filtro

		//Validação dos parametros
		If VldOp(aParam[PR_OPDE],aParam[PR_OPATE],aParam[PR_EMISDE],aParam[PR_EMISATE])
			MsgRun( "Aguarde...",, { || TelaMarkOp(aParam[PR_OPDE], aParam[PR_OPATE],; 
			aParam[PR_EMISDE], aParam[PR_EMISATE],; 
			SubStr(aParam[PR_OSAGLUT],1,1)== "1",; 
			aParam[PR_OPERADOR];
			) } )
		EndIf	
	EndIf

	RestArea(aArea)	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³Perg0002	ºAutor  ³Microsiga		     º Data ³  03/03/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Parametros											      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Ap		                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Perg0002(aParams)

	Local aParamBox := {}
	Local lRet      := .T.
	Local cLoadArq	:= "pzcvacd2_"+Alltrim(RetCodUsr())+Alltrim(cEmpAnt)
	Local nTamOp	:= TAMSX3("C2_NUM")[1]+TAMSX3("C2_ITEM")[1]+TAMSX3("C2_SEQUEN")[1]
	Local aGerOSAgl	:= {"1-Sim","2-Não"}  

	AADD(aParamBox,{1,"OP de"					,Space(nTamOp)		,""	,"","SC2","",50	,.F.})
	AADD(aParamBox,{1,"OP até"					,Space(nTamOp)		,""	,"","SC2","",50	,.T.})
	AADD(aParamBox,{1,"Emissão de"				,CtoD("//")			,"@D","","","",70	,.T.})
	AADD(aParamBox,{1,"Emissão até"				,CtoD("//")			,"@D","","","",70	,.T.})
	AADD(aParamBox,{2,"Gera OS Aglut."			,"1", aGerOSAgl			, 70,".T."			,.T.})
	AADD(aParamBox,{1,"Operador"				,Space(TAMSX3("CB7_CODOPE")[1])		,""	,"","CB1","",50	,.T.})

	lRet := ParamBox(aParamBox, "Parâmetros", aParams, , /*alButtons*/, .T., /*nlPosx*/, /*nlPosy*/,, cLoadArq, .t., .t.)

Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³VldOp			ºAutor  ³Microsiga	     º Data ³  03/03/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Validação dos parametros									  º±±
±±º          ³												              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Ap		                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/ 
Static Function VldOp(cOpDe, cOpAte, dDtDe, dDtAte)

	Local aArea		:= GetArea()
	Local cQuery	:= ""
	Local cArqTmp	:= GetNextAlias()
	Local lRet		:= .F.

	Default cOpDe	:= "" 
	Default cOpAte	:= "" 
	Default dDtDe	:= CTOD('') 
	Default dDtAte	:= CTOD('')

	cQuery	:= " SELECT COUNT(*) CONTADOR FROM "+RetSqlName("SC2")+" SC2 "+CRLF
	cQuery	+= " WHERE SC2.C2_FILIAL = '"+xFilial("SC2")+"' "+CRLF 
	cQuery	+= " AND (SC2.C2_NUM+SC2.C2_ITEM+SC2.C2_SEQUEN) BETWEEN '"+cOpDe+"' AND '"+cOpAte+"' "+CRLF
	cQuery	+= " AND SC2.C2_EMISSAO BETWEEN '"+DTOS(dDtDe)+"' AND '"+DTOS(dDtAte)+"' "+CRLF
	cQuery	+= " AND SC2.D_E_L_E_T_ = ' ' "+CRLF
	cQuery	+= " AND NOT EXISTS(SELECT 'X' FROM "+RetSqlName("CB7")+" CB7 "+CRLF
	cQuery	+= " 				WHERE CB7.CB7_FILIAL = '"+xFilial("CB7")+"' "+CRLF
	cQuery	+= " 				AND CB7.CB7_OP = (SC2.C2_NUM+SC2.C2_ITEM+SC2.C2_SEQUEN) "+CRLF
	cQuery	+= " 				AND CB7.D_E_L_E_T_ = ' ' "+CRLF
	cQuery	+= " 				) "+CRLF

	DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cArqTmp,.T.,.T.)

	If (cArqTmp)->(!Eof()) .And. (cArqTmp)->CONTADOR > 0
		lRet := .T.
	Else
		lRet := .F.
		Aviso("Atenção","Nenhum registro encontrado, por gentileza, verifique os parâmetros informados. ",{"Ok"},2)
	EndIf

	If Select(cArqTmp) > 0
		(cArqTmp)->(DbCloseArea())
	EndIf

	RestArea(aArea)
Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³TelaMarkOp	ºAutor  ³Microsiga	     º Data ³  03/03/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Tela para selecionar as OP´s para gerar ordem de separação  º±±
±±º          ³												              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Ap		                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/ 
Static Function TelaMarkOp(cOpDe, cOpAte, dDtDe, dDtAte, lGerAglut, cOperador)

	Local aArea 		:= GetArea()
	Local oButtConf
	Local oButtSaid                  
	Local aCab			:= {" ","OP","Item", "Sequencia","Dt.Emissão","Produto","Descrição","Armazem","Quantidade","Lote"}
	Local oOk			:= LoadBitMap( GetResources(), "LBTIK" )
	Local oNo			:= LoadBitMap( GetResources(), "LBNO" )
	Local oSize			:= Nil
	Local oDlg			:= Nil 
	Local oFWLayer		:= Nil
	Local oWin01		:= Nil
	Local oLst1			:= Nil
	Local oBarTree		:= Nil
	Local lOk			:= .F.
	Local aDadosSel		:= {}
	Local lVld			:= .F.  

	Default cOpDe		:= "" 
	Default cOpAte		:= "" 
	Default dDtDe		:= CTOD('') 
	Default dDtAte		:= CTOD('') 
	Default lGerAglut	:= .F.
	Default cOperador	:= ""

	aDadosSel := GetDSel(cOpDe, cOpAte, dDtDe, dDtAte) 

	//-----------------------------------------
	// Criação de classe para definição da proporção da interface
	//-----------------------------------------
	oSize := FWDefSize():New(.T., , nOr(WS_VISIBLE,WS_POPUP) )
	oSize:AddObject("TOP", 100, 100, .T., .T.)
	oSize:aMargins := {0,0,0,0}
	oSize:Process()

	DEFINE DIALOG oDlg TITLE "Seleção de OP´s" FROM oSize:aWindSize[1],oSize:aWindSize[2] TO oSize:aWindSize[3],oSize:aWindSize[4]-10 PIXEL STYLE nOr(WS_VISIBLE,WS_POPUP)

	//Cria instancia do fwlayer
	oFWLayer := FWLayer():New()

	//Inicializa componente passa a Dialog criada,o segundo parametro é para
	//criação de um botao de fechar utilizado para Dlg sem cabeçalho
	oFWLayer:Init( oDlg, .T. )

	// Efetua a montagem das colunas das telas
	oFWLayer:AddCollumn( "Col01", 100, .T. )


	// Cria windows passando, nome da coluna onde sera criada, nome da window
	// titulo da window, a porcentagem da altura da janela, se esta habilitada para click,
	// se é redimensionada em caso de minimizar outras janelas e a ação no click do split
	oFWLayer:AddWindow( "Col01", "Win01", "Selecão da Ordem de Produção", 100, .F., .T., ,,)

	oWin01 := oFWLayer:getWinPanel('Col01','Win01')


	//Markbrowse das notas de saida
	oLst1 := TWBrowse():New( 005, 005, __DlgWidth(oWin01)-5,__Dlgheight(oWin01)-20,,aCab,,oWin01,,,,,,,,,,,,.F.,,.T.,,.F.,,, ) 
	oLst1:aColSizes := {10,30,50,50,50,50,50,50}
	oLst1:SetArray( aDadosSel ) 

	oLst1:bLine:={ || {	If(aDadosSel[oLst1:nAt][MARK],oOk,oNo ),;//Flag
	aDadosSel[oLst1:nAt][NUM],;
	aDadosSel[oLst1:nAt][ITEM],;
	aDadosSel[oLst1:nAt][SEQUENCIA],;					
	aDadosSel[oLst1:nAt][EMISSAO],;	
	aDadosSel[oLst1:nAt][PRODUTO],;
	aDadosSel[oLst1:nAt][DESC],;
	aDadosSel[oLst1:nAt][ARMAZEM],;
	aDadosSel[oLst1:nAt][QUANT],;
	aDadosSel[oLst1:nAt][LOTECTL];
	} } 

	oLst1:bLDblClick 	:= {|| aDadosSel[oLst1:nAt,MARK] := !aDadosSel[oLst1:nAt,MARK],;//Alteração da flag
	oLst1:Refresh() }//Atualização do objeto Twbrowse
	oLst1:bHeaderClick 	:= {|| InvMark(@oLst1, @aDadosSel) } 
	oLst1:Refresh()


	//Adiciona as barras dos botões                                                                                                                   
	DEFINE BUTTONBAR oBarTree SIZE 10,10 3D BOTTOM OF oWin01

	oButtConf 	:= thButton():New(01,01, "Confirma"		, oBarTree,  {|| lVld := VldSel(aDadosSel),;
	Iif(lVld,lOk := .T., lOk := .F.),; 
	Iif(lVld,oDlg:End(), Nil);
	},35,20,)

	oButtSaid	:= thButton():New(01,01, "Sair"			, oBarTree,  {|| lOk := .F., oDlg:End() },25,20,)

	oButtSaid:Align 	:= CONTROL_ALIGN_RIGHT 
	oButtConf:Align 	:= CONTROL_ALIGN_RIGHT

	ACTIVATE DIALOG oDlg CENTERED


	If lOk .And. (Aviso("Atenção","Confirma a geração das ordens de separação ?",{"Sim","Não"},2) == 1 )

		//Gera as ordens de separação
		Processa( {|| ProcOrdSep(aDadosSel, cOperador, lGerAglut) },"","" )

	EndIf

	RestArea(aArea)
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³GetDSel	ºAutor  ³Microsiga		     º Data ³  12/06/2018 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Perguntas para vincular nota fiscal					      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Ap		                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GetDSel(cOpDe, cOpAte, dDtDe, dDtAte)

	Local aArea 	:= GetArea()
	Local cQuery    := ""
	Local cArqTmp	:= GetNextAlias()
	Local aRet		:= {}

	Default cOpDe	:= "" 
	Default cOpAte	:= "" 
	Default dDtDe	:= CTOD('') 
	Default dDtAte	:= CTOD('')

	cQuery    := " SELECT C2_NUM, C2_ITEM, C2_SEQUEN, C2_EMISSAO, C2_PRODUTO, B1_DESC, C2_LOCAL, 
	cQuery    += " C2_QUANT, C2_LOTECTL FROM "+RetSqlName("SC2")+" SC2 "+CRLF

	cQuery    += " INNER JOIN "+RetSqlName("SB1")+" SB1 "+CRLF
	cQuery    += " ON SB1.B1_FILIAL = '"+xFilial("SB1")+"' "+CRLF
	cQuery    += " AND SB1.B1_COD = SC2.C2_PRODUTO "+CRLF
	cQuery    += " AND SB1.D_E_L_E_T_ = ' ' "+CRLF

	cQuery    += " WHERE SC2.C2_FILIAL = '"+xFilial("SC2")+"' "+CRLF 
	cQuery    += " AND (SC2.C2_NUM+SC2.C2_ITEM+SC2.C2_SEQUEN) BETWEEN '"+cOpDe+"' AND '"+cOpAte+"' "+CRLF
	cQuery    += " AND SC2.C2_EMISSAO BETWEEN '"+DTOS(dDtDe)+"' AND '"+DTOS(dDtAte)+"' "+CRLF
	cQuery    += " AND SC2.D_E_L_E_T_ = ' ' "+CRLF
	cQuery    += " AND NOT EXISTS(SELECT 'X' FROM "+RetSqlName("CB7")+" CB7 "+CRLF
	cQuery    += " 				WHERE CB7.CB7_FILIAL = '"+xFilial("CB7")+"' "+CRLF
	cQuery    += " 				AND CB7.CB7_OP = (SC2.C2_NUM+SC2.C2_ITEM+SC2.C2_SEQUEN) "+CRLF
	cQuery    += " 				AND CB7.D_E_L_E_T_ = ' ' "+CRLF
	cQuery    += " 				) "+CRLF
	cQuery    += " ORDER BY C2_NUM "+CRLF

	dbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cArqTmp,.T.,.T.)

	While (cArqTmp)->(!Eof())

		Aadd(aRet, {.F.,;							//Marcação
		(cArqTmp)->C2_NUM,;			
		(cArqTmp)->C2_ITEM,;			
		(cArqTmp)->C2_SEQUEN,;			
		STOD((cArqTmp)->C2_EMISSAO),;	
		(cArqTmp)->C2_PRODUTO,;
		(cArqTmp)->B1_DESC, ;
		(cArqTmp)->C2_LOCAL, ;				
		Transform((cArqTmp)->C2_QUANT,X3Picture("C2_QUANT")), ;
		(cArqTmp)->C2_LOTECTL ;
		})

		(cArqTmp)->(DbSkip())
	EndDo


	If Len(aRet) == 0
		Aadd(aRet, {.F.,"","","",CTOD(''),"","","",0,""})
	EndIf

	If Select(cArqTmp) > 0
		(cArqTmp)->(DbCloseArea())
	EndIf                 

	RestArea(aArea)
Return aRet



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³InvMark ºAutor  ³Microsiga 	          º Data ³ 03/03/20   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Inverte a marcação										  º±±
±±º          ³												    		  º±±
±±º          ³												    		  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³			                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function InvMark(oLst, aDadosSel)
	Local aArea := GetArea()
	Local nX	:= 0

	Default oLst 	:= Nil
	Default aDadosSel  := {}                       

	For nX := 1 To Len(aDadosSel)
		If aDadosSel[nX, MARK]
			aDadosSel[nX, MARK] := .F.
		Else
			aDadosSel[nX, MARK] := .T.     
		EndIf  	
	Next

	oLst:Refresh()

	RestArea(aArea)
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VldSel ºAutor  ³Microsiga 	          º Data ³ 03/03/20   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Valida itens selecionados									  º±±
±±º          ³												    		  º±±
±±º          ³												    		  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³			                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function VldSel(aDadosSel)

	Local aArea	:= GetArea()
	Local lRet	:= .F.
	Local nX	:= 0

	For nX := 1 To Len(aDadosSel)
		If aDadosSel[nX][MARK]
			lRet := .T.
			Exit
		EndIf
	Next

	If !lRet
		Aviso("Atenção","Nenhum item selecionado.",{"Ok"},2)
	EndIf

	RestArea(aArea)
Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ProcOrdSep	ºAutor  ³Microsiga	     º Data ³  03/03/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Processa a geração da ordem de separação				      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Ap		                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ProcOrdSep(aDadosSel, cOperador, lGerAglut)

	Local aArea		:= GetArea()
	Local nX		:= 0
	Local cOpAglut	:= ""

	Default aDadosSel	:= {} 
	Default cOperador	:= "" 
	Default lGerAglut	:= .F.

	ProcRegua(Len(aDadosSel))

	For nX := 1 To Len(aDadosSel)
		IncProc("Aguarde...")

		If aDadosSel[nX][MARK]
           

			//Grava o cabeçalho e Itens da Ordem de separação (CB7, CB8 e SZT)
			GrvCabItens(aDadosSel[nX][NUM]+aDadosSel[nX][ITEM]+aDadosSel[nX][SEQUENCIA],;//Op 
						cOperador)//Operador
		EndIf

	Next

	//Gerifica se gera ordem de produção aglutinada
	If lGerAglut
		For nX := 1 To Len(aDadosSel)
			If aDadosSel[nX][MARK]
				cOpAglut += aDadosSel[nX][NUM]+aDadosSel[nX][ITEM]+aDadosSel[nX][SEQUENCIA]+";"
			EndIf
		Next
		
		//Gera ordem de separação aglutinada
		GerOrdAglu(cOpAglut, cOperador)
	EndIf
    
	/*\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\*/
	lMsErroAuto := .F.
    lMsHelpAuto := .T.
    // Divide os Empenhos para cada Ordem de Separação
	For nX := 1 To Len(aDadosSel)
	    If !aDadosSel[nX][MARK]
		   Loop
		EndIf

		_cOP := aDadosSel[nX][NUM]+aDadosSel[nX][ITEM]+aDadosSel[nX][SEQUENCIA]

		//Monta o cabeçalho com as informações da ordem de produção que terá os empenhos zerados.
   		//O parâmetro AUTZERAEMP identifica que será realizado o processo de zerar empenhos.
   		aCab := {{"D4_OP",_cOP,NIL},;
         		{"AUTZERAEMP",.T.,Nil},;
         		{"INDEX",2,Nil}}
        aItens := {}
   		//Executa o MATA381 com a operação 4, e o indicador para zerar os empenhos.
   		MSExecAuto({|x,y,z| mata381(x,y,z)},aCab,aItens,4)
   		If lMsErroAuto
		   MostraErro()
		Else   
		    //Aviso('Empenhos','Empenho excluido com sucesso, gerando novos registros',{'OK'})
			DbSelectArea('CB7')
			DbSetOrder(5)
			If DbSeek(xFilial('CB7')+_cOP)
			Do While AllTrim(CB7->CB7_OP) == AllTrim(_cOP) .and. !EoF()
				If !CB7->CB7_TIPSEP $ '1.3'
					DbSkip()
					Loop
				EndIf

				DbSelectArea('CB8')
				DbSeek(xFilial('CB8')+CB7->CB7_ORDSEP)
				Do While CB8->CB8_ORDSEP == CB7->CB7_ORDSEP .and. !EoF()
					// Faz nova inclusão de empenho
					//                                                        /*\/\/\/\/\/\/\/\/\*/
					aVetor := {}
					aEmpen := {}
					nOpc   := 3 //Inclusao
					lMsErroAuto := .F.
					
					_cQryD4 := 'Select Max(D4_TRT) As D4_TRT From '+RetSqlName('SD4')+" Where D4_OP ='"+CB8->CB8_OP+"' And D4_COD = '"+CB8->CB8_PROD+"' And D_E_L_E_T_ = ''"
					DbUseArea( .T. , "TOPCONN" , TcGenQry(,,_cQryD4) , '_SD4',.T.,.T.)
					If EMpty(_SD4->D4_TRT)
					   _cSeq := '000'
					Else 
					   _cSeq := _SD4->D4_TRT 
					EndIf

					_cSeq := Soma1(_cSeq)
					_SD4->(DbClosearea())
					aVetor:={   {"D4_COD"     , CB8->CB8_PROD	, Nil},; //COM O TAMANHO EXATO DO CAMPO
								{"D4_LOCAL"   , CB8->CB8_LOCAL  , Nil},;
								{"D4_OP"      , CB8->CB8_OP  	, Nil},;
								{"D4_SEQ"     , ''           , Nil},;
								{"D4_DATA"    , dDatabase       , Nil},;
								{"D4_QTDEORI" , CB8->CB8_QTDORI , Nil},;
								{"D4_QUANT"   , CB8->CB8_QTDORI , Nil},;
								{"D4_LOTECTL" , CB8->CB8_LOTECT , Nil},;
								{"D4_XORDSEP" , CB7->CB7_ORDSEP , Nil},;
								{"D4_TRT"     ,_cSeq            , Nil},;
								{"D4_QTSEGUM" ,0                , Nil}}
					AADD(aEmpen,{ CB8->CB8_QTDORI                 ,;     // SD4->D4_QUANT
								  CB8->CB8_LCALIZ,;        // DC_LOCALIZ
									""                 ,;      // DC_NUMSERI
									0                  ,;      // D4_QTSEGUM
									.F.}) 
					MSExecAuto({|x,y,z| mata380(x,y,z)},aVetor,nOpc,aEmpen) 
					If lMsErroAuto					
					   MostraErro()
					EndIf

					DbSelectArea('CB8')
					DbSkip()
				EndDo             
                 
				// Refaz quantidades empenhadas de MOD
				_cUpd := "Update "+RetSqlName('SD4')+" Set D4_QUANT = D4_QTDEORI Where D4_FILIAL = '"+xFilial('SD4')+"' And D4_COD like 'MOD%' And D4_OP = '"+CB7->CB7_OP+"' And D_E_L_E_T_ = ''"
				TcSqlExec(_cUpd)

				// Limpa dados com Empenho Zerados
				_cUpd := "Update "+RetSqlName('SD4')+" Set D_E_L_E_T_ = '*', R_E_C_D_E_L_ = R_E_C_N_O_ Where D4_FILIAL = '"+xFilial('SD4')+"' And D4_QUANT = 0 And D4_OP = '"+CB7->CB7_OP+"' And D_E_L_E_T_ = ''"
				TcSqlExec(_cUpd)

				DbSelectArea('CB7')
				DbSkip()
			EndDo  
			EndIf

			CB7->(DbSetOrder(1))
		EndIf	
	Next
	/*\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\*/
	

	RestArea(aArea)
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³GrvCB7		ºAutor  ³Microsiga	     º Data ³  03/03/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Processa a geração da ordem de separação				      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Ap		                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GrvCabItens(cOp, cOperador)

	Local aArea			:= GetArea()
	Local cOrdSepInt	:= ""
	Local cOrdSepKg		:= ""
	Local cOrdSepDec	:= ""

	Default cOp			:= ""
	Default cOperador	:= ""

	//Gera Inteiro
	If IsTipoSep(cOp, "1")//Verifica se existe inteiro para gerar a ordem de separação Inteiro
		cOrdSepInt := GrvCab( cOp,"1","00*08*",cOperador,"INT")
	EndIf

	//Gera Fracionado Kg
	If IsTipoSep(cOp, "2")
		// cOrdSepKg := GrvCab( cOp,"3","00*08*",cOperador,"DEC")
		cOrdSepKg := GrvCab( cOp,"2","00*08*",cOperador,"DEC")
	EndIf

	//Gera Fracionado Decimal
	If IsTipoSep(cOp, "3")
		cOrdSepDec := GrvCab( cOp,"3","00*08*",cOperador,"DEC")
	EndIf

	//Grava as ordens de separação na tabela de amarração SZT
	GrvItens(cOp, cOrdSepInt, cOrdSepKg, cOrdSepDec)

	RestArea(aArea)
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³IsInt		ºAutor  ³Microsiga	     º Data ³  	   03/03/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verifica se existe o tipo de separação				      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Ap		                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function IsTipoSep(cOp, cTpSep)

	Local aArea		:= GetArea()
	Local cQuery	:= ""
	Local cArqTmp	:= GetNextAlias()
	Local lRet		:= .F.
	Local nValAux	:= 0

	Default cOp		:= ""
	Default cTpSep	:= ""

	cQuery	:= " SELECT B1_COD, B1_DESC, B1_QE, D4_QTDEORI, D4_LOTECTL FROM "+RetSqlName("SD4")+" SD4 "+CRLF

	cQuery	+= " INNER JOIN "+RetSqlName("SB1")+" SB1 "+CRLF
	cQuery	+= " ON SB1.B1_FILIAL = '"+xFilial("SB1")+"' "+CRLF
	cQuery	+= " AND SB1.B1_COD = SD4.D4_COD "+CRLF
	//cQuery	+= " AND SB1.B1_TIPO NOT IN('EM','MO') "+CRLF
	cQuery	+= " AND SB1.B1_TIPO NOT IN('MO') "+CRLF
	cQuery	+= " AND SB1.D_E_L_E_T_ = ' ' "+CRLF

	cQuery	+= " WHERE SD4.D4_FILIAL = '"+xFilial("SD4")+"' "+CRLF
	cQuery	+= " AND SD4.D4_OP = '"+cOp+"' "+CRLF
	cQuery	+= " AND SD4.D_E_L_E_T_ = ' ' "+CRLF

	dbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cArqTmp,.T.,.T.)

	While (cArqTmp)->(!Eof())
		nValAux := 0

		If (cArqTmp)->B1_QE != 0 

			If Alltrim(cTpSep)== "1"//Inteiro
				nValAux := INT((cArqTmp)->D4_QTDEORI/(cArqTmp)->B1_QE)*(cArqTmp)->B1_QE

				If nValAux > 0
					lRet	:= .T.
					Exit
				EndIf
			ElseIf Alltrim(cTpSep)== "2"//Fracionado KG
				nValAux := INT((cArqTmp)->D4_QTDEORI%(cArqTmp)->B1_QE)

				If nValAux > 0
					lRet	:= .T.
					Exit
				EndIf

			ElseIf Alltrim(cTpSep)== "3"//Fracionado Decimal
				nValAux := ((cArqTmp)->D4_QTDEORI%(cArqTmp)->B1_QE)//-INT((cArqTmp)->D4_QTDEORI%(cArqTmp)->B1_QE)

				If nValAux > 0
					lRet	:= .T.
					Exit
				EndIf

			EndIf

		EndIf

		(cArqTmp)->(DbSkip())
	EndDo

	If Select(cArqTmp) > 0
		(cArqTmp)->(DbCloseArea())
	EndIf

	RestArea(aArea)
Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³GrvCab		ºAutor  ³Microsiga	     º Data ³  03/03/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Processa a geração da ordem de separação				      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Ap		                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GrvCab(cOp, cTpSep, cTipExp, cOperador, cIntDec)

	Local aArea		:= GetArea()
	Local cOrdSep	:= ""

	Default cOp			:= "" 
	Default cTpSep		:= "" 
	Default cTipExp		:= ""
	Default cOperador	:= ""
	Default cIntDec		:= ""

	DbSelectArea("CB7")
	DbSetOrder(1)

	cOrdSep   := GetSX8Num( "CB7", "CB7_ORDSEP" )
	ConfirmSX8()

	CB7->(DbSetOrder(1))

	CB7->(RecLock( "CB7", .T. ))
	CB7->CB7_FILIAL := xFilial( "CB7" )
	CB7->CB7_ORDSEP := cOrdSep
	CB7->CB7_OP     := cOp
	CB7->CB7_LOCAL  := ""
	CB7->CB7_DTEMIS := dDataBase
	CB7->CB7_HREMIS := Time()
	CB7->CB7_STATUS := "0"   // gravar STATUS de nao iniciada somente depois do processo
	CB7->CB7_CODOPE := cOperador
	CB7->CB7_PRIORI := "1"
	CB7->CB7_ORIGEM := "3"
	CB7->CB7_TIPEXP := cTipExp
	CB7->CB7_TIPSEP := cTpSep
	CB7->CB7_INTDEC := cIntDec

	CB7->(MsUnLock())

	RestArea(aArea)
Return cOrdSep

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³GrvItens		ºAutor  ³Microsiga	     º Data ³  04/03/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Grava os itens na tabela de Ordem de Separação CB8 e SZT	  º±±
±±º          ³						              						  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Ap		                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GrvItens(cOp, cOrdSepInt, cOrdSepKg, cOrdSepDec)

	Local aArea		:= GetArea()
	Local cArqTmp	:= GetNextAlias()
	Local cQuery	:= ""

	Default cOp			:= "" 
	Default cOrdSepInt	:= "" 
	Default cOrdSepKg	:= "" 
	Default cOrdSepDec	:= "" 

/*
	cQuery	:= " SELECT D4_COD, D4_OP, D4_LOCAL, D4_QTDEORI, D4_QUANT, D4_LOTECTL, D4_NUMLOTE, "+CRLF
	cQuery	+= " B1_DESC, B1_QE, B1_TIPO " +CRLF
	cQuery	+= " FROM "+RetSqlName("SD4")+" SD4 with (NOLOCK) "+CRLF

	cQuery	+= " INNER JOIN "+RetSqlName("SB1")+" SB1 with (NOLOCK) "+CRLF
	cQuery	+= " ON SB1.B1_FILIAL = '"+xFilial("SB1")+"' "+CRLF 
	cQuery	+= " AND SB1.B1_COD = SD4.D4_COD "+CRLF
	cQuery	+= " AND SB1.B1_TIPO NOT IN('EM','MO') "+CRLF
	cQuery	+= " AND SB1.D_E_L_E_T_ = ' ' "+CRLF

	cQuery	+= " WHERE SD4.D4_FILIAL = '"+xFilial("SD4")+"' "+CRLF
	cQuery	+= " AND SD4.D4_OP = '"+cOp+"' "+CRLF
	cQuery	+= " AND SD4.D_E_L_E_T_ = ' ' "+CRLF
	cQuery	+= " AND NOT EXISTS(SELECT 'X' FROM "+RetSqlName("SZT")+" SZT with (NOLOCK) "+CRLF
	cQuery	+= " 				WHERE SZT.ZT_FILIAL = SD4.D4_FILIAL "+CRLF
	cQuery	+= " 				AND SZT.ZT_OP = SD4.D4_OP "+CRLF
	cQuery	+= " 				AND SZT.ZT_PROD = SD4.D4_COD "+CRLF
	cQuery	+= " 				AND SZT.ZT_LOTECTL = SD4.D4_LOTECTL "+CRLF
	cQuery	+= " 				AND SZT.D_E_L_E_T_ = ' ' "+CRLF
	cQuery	+= " 				) "+CRLF
*/

	cQuery	:= " SELECT D4_COD, D4_OP, D4_LOCAL, D4_QTDEORI, D4_QUANT, D4_LOTECTL, D4_NUMLOTE, DC_LOCALIZ, DC_QTDORIG, DC_QUANT"+CRLF
	cQuery	+= "  B1_DESC, B1_QE, B1_TIPO "+CRLF
	cQuery	+= "  FROM "+RetSqlName("SD4")+" SD4 with (NOLOCK)"+CRLF
	//cQuery	+= "  INNER JOIN "+RetSqlName("SB1")+" SB1 with (NOLOCK) ON SB1.B1_FILIAL = '"+xFilial("SB1")+"' AND SB1.B1_COD = SD4.D4_COD  AND SB1.B1_TIPO NOT IN('EM','MO')  AND SB1.D_E_L_E_T_ = ' ' "+CRLF
	cQuery	+= "  INNER JOIN "+RetSqlName("SB1")+" SB1 with (NOLOCK) ON SB1.B1_FILIAL = '"+xFilial("SB1")+"' AND SB1.B1_COD = SD4.D4_COD  AND SB1.B1_TIPO NOT IN('MO')  AND SB1.D_E_L_E_T_ = ' ' "+CRLF
	cQuery	+= "  INNER JOIN "+RetSqlName("SDC")+" SDC with (NOLOCK) ON SDC.DC_FILIAL = '"+xFilial("SDC")+"' AND SDC.DC_PRODUTO = SD4.D4_COD AND SDC.DC_LOTECTL = SD4.D4_LOTECTL AND SDC.DC_OP = '"+cOp+"' And SDC.D_E_L_E_T_ = ''"+CRLF
	cQuery	+= " 	WHERE SD4.D4_FILIAL = '"+xFilial("SD4")+"' "+CRLF
	cQuery	+= " 		AND SD4.D4_OP = '"+cOp+"' "+CRLF
	cQuery	+= " 		AND SD4.D_E_L_E_T_ = ' ' AND NOT EXISTS(SELECT 'X' FROM "+RetSqlName("SZT")+" SZT with (NOLOCK) "+CRLF
	cQuery	+= "  				WHERE SZT.ZT_FILIAL = SD4.D4_FILIAL "+CRLF
	cQuery	+= "  				AND SZT.ZT_OP = SD4.D4_OP "+CRLF
	cQuery	+= "  				AND SZT.ZT_PROD = SD4.D4_COD "+CRLF
	cQuery	+= "  				AND SZT.ZT_LOTECTL = SD4.D4_LOTECTL "+CRLF
	cQuery	+= "  				AND SZT.D_E_L_E_T_ = ' ' )"+CRLF
	cQuery	+= " 	Order By D4_COD, D4_LOCAL, DC_LOCALIZ"+CRLF
    //Memowrite('querySZT.txt', cQuery)
	dbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cArqTmp,.T.,.T.)

	While (cArqTmp)->(!Eof())

		//Grava os dados na tabela SZT
		GrvSZT((cArqTmp)->D4_COD,; 
		(cArqTmp)->D4_OP,; 
		(cArqTmp)->D4_LOCAL,; 
		(cArqTmp)->DC_QTDORIG,; 
		(cArqTmp)->D4_LOTECTL,; 
		(cArqTmp)->D4_NUMLOTE,; 
		(cArqTmp)->B1_QE,; 
		(cArqTmp)->DC_LOCALIZ,;
		cOrdSepInt,; 
		cOrdSepKg,; 
		cOrdSepDec;
		)		

		If (cArqTmp)->B1_QE != 0
			GrvCB8(cOrdSepInt, (cArqTmp)->D4_COD, (cArqTmp)->D4_LOCAL, INT((cArqTmp)->DC_QTDORIG/(cArqTmp)->B1_QE)*(cArqTmp)->B1_QE,; 
			(cArqTmp)->D4_LOTECTL, (cArqTmp)->D4_NUMLOTE, (cArqTmp)->D4_OP,  (cArqTmp)->DC_LOCALIZ)

			//Atualiza a ordem de separação Fracionado Kg
			GrvCB8(cOrdSepKg, (cArqTmp)->D4_COD, (cArqTmp)->D4_LOCAL,; 
			(cArqTmp)->DC_QTDORIG-(INT((cArqTmp)->DC_QTDORIG/(cArqTmp)->B1_QE)*(cArqTmp)->B1_QE),;
			(cArqTmp)->D4_LOTECTL, (cArqTmp)->D4_NUMLOTE, (cArqTmp)->D4_OP,  (cArqTmp)->DC_LOCALIZ )

			//Atualiza a ordem de separação Fracionado Decimal
			// GrvCB8(cOrdSepDec, (cArqTmp)->D4_COD, (cArqTmp)->D4_LOCAL,; 
			// (cArqTmp)->DC_QTDORIG-((cArqTmp)->DC_QTDORIG/(cArqTmp)->B1_QE*(cArqTmp)->B1_QE),; 
			// (cArqTmp)->D4_LOTECTL, (cArqTmp)->D4_NUMLOTE, (cArqTmp)->D4_OP,  (cArqTmp)->DC_LOCALIZ )
			GrvCB8(cOrdSepDec, (cArqTmp)->D4_COD, (cArqTmp)->D4_LOCAL,; 
			(cArqTmp)->DC_QTDORIG,;
			(cArqTmp)->D4_LOTECTL, (cArqTmp)->D4_NUMLOTE, (cArqTmp)->D4_OP,  (cArqTmp)->DC_LOCALIZ )
		EndIf
		(cArqTmp)->(DbSkip())
	EndDo

	If Select(cArqTmp) > 0
		(cArqTmp)->(DbCloseArea())
	EndIf

	RestArea(aArea)
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³GrvSZT		ºAutor  ³Microsiga	     º Data ³  17/02/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Atualiza a ordem de separação nas tabela SZT e CB8		  º±±
±±º          ³												              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Ap		                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GrvSZT(cProd, cOp, cArmz, nQtdOri, cLote, cSubLote, nQtdEmb, cEndLocz,;
	cOrdSepInt, cOrdSepKg, cOrdSepDec)

	Local aArea		:= GetArea()

	Default cProd		:= "" 
	Default cOp			:= "" 
	Default cArmz		:= "" 
	Default nQtdOri		:= 0 
	Default cLote		:= "" 
	Default cSubLote	:= "" 
	Default nQtdEmb		:= 0 
	Default cEndLocz	:= ""
	Default cOrdSepInt	:= ""
	Default cOrdSepKg	:= ""
	Default cOrdSepDec	:= ""

	DbSelectArea("SZT")
	DbSetOrder(1)

	RecLock("SZT",.T.)
	SZT->ZT_FILIAL  := xFilial("SZT")
	SZT->ZT_ORDSEP  := cOrdSepInt			//Ordem de separação inteiro
	SZT->ZT_ORDSEP2 := cOrdSepKg			//Ordem de separação fracionado em Kg
	SZT->ZT_ORDSEP3 := ""					//Ordem de Separação algutinado
	SZT->ZT_ORDSEP4 := cOrdSepDec			//Ordem de separação fracionado Decimal
	SZT->ZT_ITEM    := Soma1(GetItemSzt(cOp))
	SZT->ZT_PROD    := cProd
	SZT->ZT_LOCAL   := cArmz
	SZT->ZT_LOTECTL := cLote
	SZT->ZT_QTDORI  := nQtdOri
	SZT->ZT_LCALIZ	:= cEndLocz
	SZT->ZT_OBSERV	:= ""

	If nQtdEmb != 0
		SZT->ZT_QTDMUL  := Int(nQtdOri/nQtdEmb)*nQtdEmb//Inteiro
		// SZT->ZT_QTDDIF  := (nQtdOri-nQtdOri/nQtdEmb*nQtdEmb) //Fracionado Kg,Dec
		// SZT->ZT_QTDDIF  := (nQtdOri-nQtdOri/nQtdEmb*nQtdEmb) //Fracionado Kg
		//SZT->ZT_QTDB02  := (nQtdOri-(nQtdOri/nQtdEmb)*nQtdEmb) //- int(nQtdOri-(Int(nQtdOri/nQtdEmb)*nQtdEmb))//Fracionado decimal  	
		
		SZT->ZT_QTDDIF  := nQtdOri-(Int(nQtdOri/nQtdEmb)*nQtdEmb) //Fracionado Kg,Dec
		SZT->ZT_QTDB01  := int(nQtdOri-(Int(nQtdOri/nQtdEmb)*nQtdEmb))//Fracionado Kg
		SZT->ZT_QTDB02  := (nQtdOri-(Int(nQtdOri/nQtdEmb)*nQtdEmb)) - int(nQtdOri-(Int(nQtdOri/nQtdEmb)*nQtdEmb))//Fracionado decimal  
	EndIf

	SZT->ZT_DATA    := MsDate()
	SZT->ZT_HORA    := Time()
	SZT->ZT_USUARIO := cUserName
	SZT->ZT_OP		:= cOp
	SZT->(MsUnLock())

	RestArea(aArea)
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³GetItemSzt	ºAutor  ³Microsiga	     º Data ³  17/02/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Retorna o proximo item da tabela SZT						  º±±
±±º          ³												              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Ap		                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GetItemSzt(cOp)

	Local aArea		:= GetArea()
	Local cQuery	:= ""
	Local cArqTmp	:= GetNextAlias()
	Local cRet		:= ""

	cQuery := " SELECT MAX(ZT_ITEM) ZT_ITEM FROM "+RetSqlName("SZT")+" SZT with (NOLOCK) "+CRLF
	cQuery += " WHERE SZT.ZT_FILIAL = '"+xFilial("SZT")+"' " +CRLF
	cQuery += " AND SZT.ZT_OP = '"+cOp+"' "+CRLF
	cQuery += " AND SZT.D_E_L_E_T_ = ' ' "+CRLF

	DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cArqTmp,.T.,.T.)

	If (cArqTmp)->(!Eof())
		cRet := (cArqTmp)->ZT_ITEM
	EndIf

	If Select(cArqTmp) > 0
		(cArqTmp)->(DbCloseArea())
	EndIf

	RestArea(aArea)
Return cRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³GrvCB8		ºAutor  ³Microsiga	     º Data ³  17/02/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Grava os dados da ordem de separação						  º±±
±±º          ³												              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Ap		                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GrvCB8(cOrdSep, cProd, cArmz, nQtdOri, cLote, cSubLote, cOp, cEndLocz )

	Local aArea	:= GetArea()

	Default cOrdSep		:= "" 
	Default cProd		:= "" 
	Default cArmz		:= "" 
	Default nQtdOri		:= 0 
	Default cLote		:= "" 
	Default cSubLote	:= "" 
	Default cOp			:= ""
	Default cEndLocz	:= ""

	DbSelectArea("CB8")
	DbSetOrder(1)

	If nQtdOri > 0
		RecLock("CB8", .T.)
		CB8->CB8_FILIAL	:= xFilial("CB8")
		CB8->CB8_ORDSEP	:= cOrdSep
		CB8->CB8_ITEM  	:= Soma1(GetItemCB8(cOrdSep))
		CB8->CB8_PROD  	:= cProd
		CB8->CB8_LOCAL 	:= cArmz
		CB8->CB8_QTDORI	:= nQtdOri
		CB8->CB8_SALDOS	:= nQtdOri
		CB8->CB8_LCALIZ	:= cEndLocz
		CB8->CB8_LOTECT	:= cLote
		CB8->CB8_NUMLOT	:= cSubLote
		CB8->CB8_CFLOTE	:= "1"
		CB8->CB8_OP    	:= cOp
		CB8->(MsUnLock())
	EndIf

	RestArea(aArea)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³GetItemCB8	ºAutor  ³Microsiga	     º Data ³  17/02/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Retorna o proximo item da tabela CB8						  º±±
±±º          ³												              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Ap		                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GetItemCB8(cOrdSep)

	Local aArea		:= GetArea()
	Local cQuery	:= ""
	Local cArqTmp	:= GetNextAlias()
	Local cRet		:= ""

	Default cOrdSep	:= ""

	cQuery := " SELECT MAX(CB8_ITEM) CB8_ITEM FROM "+RetSqlName("CB8")+" CB8 with (NOLOCK) "+CRLF
	cQuery += " WHERE CB8.CB8_FILIAL = '"+xFilial("SB8")+"' "+CRLF
	cQuery += " AND CB8.CB8_ORDSEP = '"+cOrdSep+"' " +CRLF
	cQuery += " AND CB8.D_E_L_E_T_ = ' ' "+CRLF

	DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cArqTmp,.T.,.T.)

	If (cArqTmp)->(!Eof())
		cRet := (cArqTmp)->CB8_ITEM
	EndIf

	If Select(cArqTmp) > 0
		(cArqTmp)->(DbCloseArea())
	EndIf

	RestArea(aArea)
Return cRet



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³GerOrdAglu	ºAutor  ³Microsiga	     º Data ³  04/03/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Gera ordem de separação aglutinada						  º±±
±±º          ³												              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Ap		                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GerOrdAglu(cOps, cOperador)

	Local aArea		:= GetArea()
	Local cQuery	:= ""
	Local cArqTmp	:= GetNextAlias()
	Local lCab		:= .F.
	Local cOrdSep	:= ""

	Default cOps		:= ""
	Default cOperador	:= ""

	cQuery	:= " SELECT ZT_PROD, ZT_LOCAL, ZT_LCALIZ, ZT_LOTECTL, SUM(ZT_QTDDIF) ZT_QTDDIF, "+CRLF 
	cQuery	+= " SUM(ZT_QTDB01) ZT_QTDB01, SUM(ZT_QTDB02) ZT_QTDB02 FROM "+RetSqlName("SZT")+" SZT "+CRLF
	cQuery	+= " WHERE SZT.ZT_FILIAL = '"+xFilial("SZT")+"' "+CRLF
	cQuery	+= " AND SZT.ZT_OP IN"+FormatIn(cOps,";")+" "+CRLF
	cQuery	+= " AND SZT.D_E_L_E_T_ = ' ' "+CRLF
	cQuery	+= " GROUP BY ZT_PROD, ZT_LOCAL, ZT_LCALIZ, ZT_LOTECTL "+CRLF

	DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cArqTmp,.T.,.T.)

	While (cArqTmp)->(!Eof())

		If !lCab
			//Grava o cabeçalho da ordem de separação aglutinada
			cOrdSep := GrvCab( "","2","00*08*09",cOperador,"DEC") 
			lCab := .T.
		EndIf

		//Gravação dos itens da ordem de separação aglutinada 
		GrvCB8(cOrdSep,;			//Ordem de separação 
		(cArqTmp)->ZT_PROD,;		//Produto 
		(cArqTmp)->ZT_LOCAL,;		//Armazem 
		(cArqTmp)->ZT_QTDDIF,;		//Quantidade
		(cArqTmp)->ZT_LOTECTL,;		//Lote 
		"",;						//Sublote 
		"",(cArqTmp)->ZT_LCALIZ )						//OP

		(cArqTmp)->(DbSkip())
	EndDo

	//Atualiza a tabela SZT com o numero da ordem de separação aglutinada;
	If !Empty(cOrdSep)
		AtuAglSZT(cOps, cOrdSep)
	EndIf

	If Select(cArqTmp) > 0
		(cArqTmp)->(DbCloseArea())
	EndIf

	RestArea(aArea)
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³AtuAglSZT		ºAutor  ³Microsiga	     º Data ³  04/03/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Atualiza o codigo do OS aglutinada na tabela SZT			  º±±
±±º          ³												              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Ap		                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AtuAglSZT(cOps, cOrdSep)

	Local aArea		:= GetArea()
	Local cQuery	:= ""
	Local cArqTmp	:= GetNextAlias()

	Default cOps	:= "" 
	Default cOrdSep	:= ""

	cQuery	:= " SELECT R_E_C_N_O_ RECSZT FROM "+RetSqlName("SZT")+" SZT "+CRLF
	cQuery	+= " WHERE SZT.ZT_FILIAL = '"+xFilial("SZT")+"' "+CRLF
	cQuery	+= " AND SZT.ZT_OP IN"+FormatIn(cOps,";")+CRLF
	cQuery	+= " AND SZT.D_E_L_E_T_ = ' ' "+CRLF

	DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cArqTmp,.T.,.T.)
	
	DbSelectArea("SZT")
	DbSetOrder(1)
	While (cArqTmp)->(!Eof())
		
		SZT->(DbGoTo((cArqTmp)->RECSZT))
		
		RecLock("SZT",.F.)
		SZT->ZT_ORDSEP3 := cOrdSep
		SZT->(MsUnLock())
		
		(cArqTmp)->(DbSkip())
	EndDo
	
	If Select(cArqTmp) > 0
		(cArqTmp)->(DbCloseArea())
	EndIf

	RestArea(aArea)
Return
