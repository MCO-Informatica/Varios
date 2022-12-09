#include 'protheus.ch'
#include 'parmtype.ch'

#DEFINE PR_OPDE		1
#DEFINE PR_OPATE	2
#DEFINE PR_EMISDE	3
#DEFINE PR_EMISATE	4
#DEFINE PR_OSAGLUT	5
#DEFINE PR_EMBAGLUT 6
#DEFINE PR_OPERADOR	7

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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �PZCVACD2		�Autor  �Microsiga	     � Data �  17/02/2020 ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina utilizada para gerar ordem de separa��o			  ���
���          �												              ���
�������������������������������������������������������������������������͹��
���Uso       � Ap		                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/ 
User Function PZCVACD2()

	Local aArea		:= GetArea()
	Local aParam	:= {}
	Private nOrigExp as numeric
	
	Pergunte("AIA101",.t.)
	nOrigExp := MV_PAR01

    // Caso seja Pedido de Venda
	If nOrigExp == 1
	   ACDA100Gr()
    Else
		If Perg0002(@aParam)//Parametros para filtro

			//Valida��o dos parametros
			If VldOp(aParam[PR_OPDE],aParam[PR_OPATE],aParam[PR_EMISDE],aParam[PR_EMISATE])
				MsgRun( "Aguarde...",, { || TelaMarkOp(aParam[PR_OPDE], aParam[PR_OPATE],; 
				aParam[PR_EMISDE], aParam[PR_EMISATE],; 
				SubStr(aParam[PR_OSAGLUT],1,1)== "1",;
				SubStr(aParam[PR_EMBAGLUT],1,1)== "1",;
				aParam[PR_OPERADOR];
				) } )
			EndIf	
		EndIf
    EndIf
	RestArea(aArea)	
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �Perg0002	�Autor  �Microsiga		     � Data �  03/03/2020 ���
�������������������������������������������������������������������������͹��
���Desc.     � Parametros											      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Ap		                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Perg0002(aParams)

	Local aParamBox := {}
	Local lRet      := .T.
	Local cLoadArq	:= "pzcvacd2_"+Alltrim(RetCodUsr())+Alltrim(cEmpAnt)
	Local nTamOp	:= TAMSX3("C2_NUM")[1]+TAMSX3("C2_ITEM")[1]+TAMSX3("C2_SEQUEN")[1]
	Local aGerOSAgl	:= {"1-Sim","2-N�o"}  
	Local aGerEmbAg	:= {"1-Sim","2-N�o"}  

	AADD(aParamBox,{1,"OP de"					,Space(nTamOp)		,""	,"","SC2","",50	,.F.})
	AADD(aParamBox,{1,"OP at�"					,Space(nTamOp)		,""	,"","SC2","",50	,.T.})
	AADD(aParamBox,{1,"Emiss�o de"				,CtoD("//")			,"@D","","","",70	,.T.})
	AADD(aParamBox,{1,"Emiss�o at�"				,CtoD("//")			,"@D","","","",70	,.T.})
	AADD(aParamBox,{2,"Gera OS Aglut."			,"1", aGerOSAgl			, 70,".T."			,.T.})
	AADD(aParamBox,{2,"Gera OS Aglut Emb."		,"1", aGerEmbAg			, 70,".T."			,.T.})
	AADD(aParamBox,{1,"Operador"				,Space(TAMSX3("CB7_CODOPE")[1])		,""	,"","CB1","",50	,.T.})

	lRet := ParamBox(aParamBox, "Par�metros", aParams, , /*alButtons*/, .T., /*nlPosx*/, /*nlPosy*/,, cLoadArq, .t., .t.)

Return lRet


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �VldOp			�Autor  �Microsiga	     � Data �  03/03/2020 ���
�������������������������������������������������������������������������͹��
���Desc.     �Valida��o dos parametros									  ���
���          �												              ���
�������������������������������������������������������������������������͹��
���Uso       � Ap		                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
		Aviso("Aten��o","Nenhum registro encontrado, por gentileza, verifique os par�metros informados. ",{"Ok"},2)
	EndIf

	If Select(cArqTmp) > 0
		(cArqTmp)->(DbCloseArea())
	EndIf

	RestArea(aArea)
Return lRet


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �TelaMarkOp	�Autor  �Microsiga	     � Data �  03/03/2020 ���
�������������������������������������������������������������������������͹��
���Desc.     �Tela para selecionar as OP�s para gerar ordem de separa��o  ���
���          �												              ���
�������������������������������������������������������������������������͹��
���Uso       � Ap		                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/ 
Static Function TelaMarkOp(cOpDe, cOpAte, dDtDe, dDtAte, lGerAglut, lGerAglEmb, cOperador)

	Local aArea 		:= GetArea()
	Local oButtConf
	Local oButtSaid                  
	Local aCab			:= {" ","OP","Item", "Sequencia","Dt.Emiss�o","Produto","Descri��o","Armazem","Quantidade","Lote"}
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
	Default lGerAglEmb 	:= .F.
	Default cOperador	:= ""

	aDadosSel := GetDSel(cOpDe, cOpAte, dDtDe, dDtAte) 

	//-----------------------------------------
	// Cria��o de classe para defini��o da propor��o da interface
	//-----------------------------------------
	oSize := FWDefSize():New(.T., , nOr(WS_VISIBLE,WS_POPUP) )
	oSize:AddObject("TOP", 100, 100, .T., .T.)
	oSize:aMargins := {0,0,0,0}
	oSize:Process()

	DEFINE DIALOG oDlg TITLE "Sele��o de OP�s" FROM oSize:aWindSize[1],oSize:aWindSize[2] TO oSize:aWindSize[3],oSize:aWindSize[4]-10 PIXEL STYLE nOr(WS_VISIBLE,WS_POPUP)

	//Cria instancia do fwlayer
	oFWLayer := FWLayer():New()

	//Inicializa componente passa a Dialog criada,o segundo parametro � para
	//cria��o de um botao de fechar utilizado para Dlg sem cabe�alho
	oFWLayer:Init( oDlg, .T. )

	// Efetua a montagem das colunas das telas
	oFWLayer:AddCollumn( "Col01", 100, .T. )


	// Cria windows passando, nome da coluna onde sera criada, nome da window
	// titulo da window, a porcentagem da altura da janela, se esta habilitada para click,
	// se � redimensionada em caso de minimizar outras janelas e a a��o no click do split
	oFWLayer:AddWindow( "Col01", "Win01", "Selec�o da Ordem de Produ��o", 100, .F., .T., ,,)

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

	oLst1:bLDblClick 	:= {|| aDadosSel[oLst1:nAt,MARK] := !aDadosSel[oLst1:nAt,MARK],;//Altera��o da flag
	oLst1:Refresh() }//Atualiza��o do objeto Twbrowse
	oLst1:bHeaderClick 	:= {|| InvMark(@oLst1, @aDadosSel) } 
	oLst1:Refresh()


	//Adiciona as barras dos bot�es                                                                                                                   
	DEFINE BUTTONBAR oBarTree SIZE 10,10 3D BOTTOM OF oWin01

	oButtConf 	:= thButton():New(01,01, "Confirma"		, oBarTree,  {|| lVld := VldSel(aDadosSel),;
	Iif(lVld,lOk := .T., lOk := .F.),; 
	Iif(lVld,oDlg:End(), Nil);
	},35,20,)

	oButtSaid	:= thButton():New(01,01, "Sair"			, oBarTree,  {|| lOk := .F., oDlg:End() },25,20,)

	oButtSaid:Align 	:= CONTROL_ALIGN_RIGHT 
	oButtConf:Align 	:= CONTROL_ALIGN_RIGHT

	ACTIVATE DIALOG oDlg CENTERED


	If lOk .And. (Aviso("Aten��o","Confirma a gera��o das ordens de separa��o ?",{"Sim","N�o"},2) == 1 )

		//Gera as ordens de separa��o
		Processa( {|| ProcOrdSep(aDadosSel, cOperador, lGerAglut, lGerAglEmb) },"","" )

	EndIf

	RestArea(aArea)
Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �GetDSel	�Autor  �Microsiga		     � Data �  12/06/2018 ���
�������������������������������������������������������������������������͹��
���Desc.     � Perguntas para vincular nota fiscal					      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Ap		                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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

		Aadd(aRet, {.F.,;							//Marca��o
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �InvMark �Autor  �Microsiga 	          � Data � 03/03/20   ���
�������������������������������������������������������������������������͹��
���Desc.     �Inverte a marca��o										  ���
���          �												    		  ���
���          �												    		  ���
�������������������������������������������������������������������������͹��
���Uso       �			                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VldSel �Autor  �Microsiga 	          � Data � 03/03/20   ���
�������������������������������������������������������������������������͹��
���Desc.     �Valida itens selecionados									  ���
���          �												    		  ���
���          �												    		  ���
�������������������������������������������������������������������������͹��
���Uso       �			                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
		Aviso("Aten��o","Nenhum item selecionado.",{"Ok"},2)
	EndIf

	RestArea(aArea)
Return lRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �ProcOrdSep	�Autor  �Microsiga	     � Data �  03/03/2020 ���
�������������������������������������������������������������������������͹��
���Desc.     � Processa a gera��o da ordem de separa��o				      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Ap		                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ProcOrdSep(aDadosSel, cOperador, lGerAglut, lGerAglEmb)

	Local aArea		:= GetArea()
	Local nX		:= 0
	Local cOpAglut	:= ""

	Default aDadosSel	:= {} 
	Default cOperador	:= "" 
	Default lGerAglut	:= .F.
	Default lGerAglEmb 	:= .F.

	ProcRegua(Len(aDadosSel))

	For nX := 1 To Len(aDadosSel)
		IncProc("Aguarde...")

		If aDadosSel[nX][MARK]
           

			//Grava o cabe�alho e Itens da Ordem de separa��o (CB7, CB8 e SZT)
			GrvCabItens(aDadosSel[nX][NUM]+aDadosSel[nX][ITEM]+aDadosSel[nX][SEQUENCIA],;//Op 
						cOperador)//Operador
		EndIf

	Next

	//Verifica se gera ordem de produ��o aglutinada
	If lGerAglut
		For nX := 1 To Len(aDadosSel)
			If aDadosSel[nX][MARK]
				cOpAglut += aDadosSel[nX][NUM]+aDadosSel[nX][ITEM]+aDadosSel[nX][SEQUENCIA]+";"
			EndIf
		Next
		
		//Gera ordem de separa��o aglutinada
		GerOrdAglu(cOpAglut, cOperador)
	EndIf

	If lGerAglEmb
		For nX := 1 To Len(aDadosSel)
			If aDadosSel[nX][MARK]
				cOpAglut += aDadosSel[nX][NUM]+aDadosSel[nX][ITEM]+aDadosSel[nX][SEQUENCIA]+";"
			EndIf
		Next
		
		//Gera ordem de separa��o aglutinada
		GerEmbAglu(cOpAglut, cOperador)
	EndIf
    
	_cRemet	:= Trim(GetMV("MV_RELACNT"))
	_cDest  := 'anderson.zanni@meliora.com.br'
	/*\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\*/
	lMsErroAuto := .F.
    lMsHelpAuto := .T.
    // Divide os Empenhos para cada Ordem de Separa��o
	Conout('PZCVACD2 - Inicio da tratativa de refaz Empenhos...')
	For nX := 1 To Len(aDadosSel)
	    If !aDadosSel[nX][MARK]
		   Loop
		EndIf

        Conout('PZCVACD2 - Tratando item '+AllTrim(Str(nX))+'...')
		_cOP := aDadosSel[nX][NUM]+aDadosSel[nX][ITEM]+aDadosSel[nX][SEQUENCIA]

		//Monta o cabe�alho com as informa��es da ordem de produ��o que ter� os empenhos zerados.
   		//O par�metro AUTZERAEMP identifica que ser� realizado o processo de zerar empenhos.
   		aCab := {{"D4_OP",_cOP,NIL},;
         		{"AUTZERAEMP",.T.,Nil},;
         		{"INDEX",2,Nil}}
        aItens := {}
   		//Executa o MATA381 com a opera��o 4, e o indicador para zerar os empenhos.
   		MSExecAuto({|x,y,z| mata381(x,y,z)},aCab,aItens,4)
   		If lMsErroAuto
		   MostraErro()
		Else   
		    Conout('PZCVACD2 - Empenho excluido com sucesso, gerando novos registros')
			DbSelectArea('CB7')
			DbSetOrder(5)
			If DbSeek(xFilial('CB7')+_cOP)
			Do While AllTrim(CB7->CB7_OP) == AllTrim(_cOP) .and. !EoF()
				If !CB7->CB7_TIPSEP $ '1.3.4'
					DbSkip()
					Loop
				EndIf

				DbSelectArea('CB8')
				DbSetOrder(1)
				DbSeek(xFilial('CB8')+CB7->CB7_ORDSEP)
				Do While CB8->CB8_ORDSEP == CB7->CB7_ORDSEP .and. !EoF()
					// Faz nova inclus�o de empenho
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
					Conout('PZCVACD2 - Refazendo Empenhos - Ordem Sep: '+CB7->CB7_ORDSEP)
					If lMsErroAuto
					   MostraErro(GetSrvProfString("Startpath",""),'ErroOS_'+CB7->CB7_ORDSEP+'.log')
            		   cMemo  := MemoRead('ErroOS'+CB7->CB7_ORDSEP+'.log')
            		   _cErro := NoAcento(Left(cMemo,2000))
					   U_ENVMAIL(_cRemet, _cDest, 'Erro de gera��o de Empenho - OS: '+CB7->CB7_ORDSEP+' OP:'+CB7->CB7_OP , _cErro)				
					   //MostraErro()
					   Aviso("Gera��o de OS","Erro na gera��o de empenho para a Ordem de Separa��o. Contate o Administrador!",{"Ok"},3)
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �GrvCB7		�Autor  �Microsiga	     � Data �  03/03/2020 ���
�������������������������������������������������������������������������͹��
���Desc.     � Processa a gera��o da ordem de separa��o				      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Ap		                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GrvCabItens(cOp, cOperador)

	Local aArea			:= GetArea()
	Local cOrdSepInt	:= ""
	Local cOrdSepKg		:= ""
	Local cOrdSepDec	:= ""
	Local cOrdSepEmb    := ""

	Default cOp			:= ""
	Default cOperador	:= ""

	//Gera Inteiro
	If IsTipoSep(cOp, "1")//Verifica se existe inteiro para gerar a ordem de separa��o Inteiro
		cOrdSepInt := GrvCab( cOp,"1","00*08*",cOperador,"INT")
	EndIf

	//Gera Fracionado Kg
	If IsTipoSep(cOp, "2")
		// cOrdSepKg := GrvCab( cOp,"3","00*08*",cOperador,"DEC")
		cOrdSepKg := GrvCab( cOp,"3","00*08*",cOperador,"DEC")
	EndIf

	//Gera Fracionado Decimal
	// If IsTipoSep(cOp, "3")
	// 	cOrdSepDec := GrvCab( cOp,"3","00*08*",cOperador,"DEC")
	// EndIf

	//Gera Embalagem
	If IsTipoSep(cOp, "4")
		cOrdSepEmb := GrvCab( cOp,"4","00*08*",cOperador,"EMB")
	EndIf

	//Grava as ordens de separa��o na tabela de amarra��o SZT
	GrvItens(cOp, cOrdSepInt, cOrdSepKg, cOrdSepDec, cOrdSepEmb)

	RestArea(aArea)
Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �IsInt		�Autor  �Microsiga	     � Data �  	   03/03/2020 ���
�������������������������������������������������������������������������͹��
���Desc.     � Verifica se existe o tipo de separa��o				      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Ap		                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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

			ElseIf Alltrim(cTpSep)== "4"//Embalagem
				// nValAux := Ceiling((cArqTmp)->D4_QTDEORI/(cArqTmp)->B1_QE)
				nValAux := (cArqTmp)->D4_QTDEORI

				If nValAux > 0
					lRet	:= .T.
					Exit
				EndIf

			ElseIf Alltrim(cTpSep)== "5"//Aglut Embalagem
				// nValAux := Ceiling((cArqTmp)->D4_QTDEORI/(cArqTmp)->B1_QE)
				nValAux := (cArqTmp)->D4_QTDEORI

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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �GrvCab		�Autor  �Microsiga	     � Data �  03/03/2020 ���
�������������������������������������������������������������������������͹��
���Desc.     � Processa a gera��o da ordem de separa��o				      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Ap		                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �GrvItens		�Autor  �Microsiga	     � Data �  04/03/2020 ���
�������������������������������������������������������������������������͹��
���Desc.     �Grava os itens na tabela de Ordem de Separa��o CB8 e SZT	  ���
���          �						              						  ���
�������������������������������������������������������������������������͹��
���Uso       � Ap		                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GrvItens(cOp, cOrdSepInt, cOrdSepKg, cOrdSepDec, cOrdSepEmb)

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
	cQuery	+= "  INNER JOIN "+RetSqlName("SDC")+" SDC with (NOLOCK) ON SDC.DC_FILIAL = '"+xFilial("SDC")+"' AND SDC.DC_PRODUTO = SD4.D4_COD AND SDC.DC_LOTECTL = SD4.D4_LOTECTL AND SDC.DC_OP = SD4.D4_OP And SDC.D_E_L_E_T_ = '' and DC_TRT = D4_TRT"+CRLF
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
		cOrdSepDec,;
		cOrdSepEmb;
		)		

		If (cArqTmp)->B1_QE != 0

			If (cArqTmp)->B1_TIPO != 'EM'

				GrvCB8(cOrdSepInt, (cArqTmp)->D4_COD, (cArqTmp)->D4_LOCAL, INT((cArqTmp)->DC_QTDORIG/(cArqTmp)->B1_QE)*(cArqTmp)->B1_QE,; 
				(cArqTmp)->D4_LOTECTL, (cArqTmp)->D4_NUMLOTE, (cArqTmp)->D4_OP,  (cArqTmp)->DC_LOCALIZ)

				//Atualiza a ordem de separa��o Fracionado Kg
				GrvCB8(cOrdSepKg, (cArqTmp)->D4_COD, (cArqTmp)->D4_LOCAL,; 
				(cArqTmp)->DC_QTDORIG-(INT((cArqTmp)->DC_QTDORIG/(cArqTmp)->B1_QE)*(cArqTmp)->B1_QE),;
				(cArqTmp)->D4_LOTECTL, (cArqTmp)->D4_NUMLOTE, (cArqTmp)->D4_OP,  (cArqTmp)->DC_LOCALIZ )

			EndIf

			//Atualiza a ordem de separa��o Fracionado Decimal
			// GrvCB8(cOrdSepDec, (cArqTmp)->D4_COD, (cArqTmp)->D4_LOCAL,; 
			// (cArqTmp)->DC_QTDORIG-(INT((cArqTmp)->DC_QTDORIG/(cArqTmp)->B1_QE)*(cArqTmp)->B1_QE),;
			// (cArqTmp)->D4_LOTECTL, (cArqTmp)->D4_NUMLOTE, (cArqTmp)->D4_OP,  (cArqTmp)->DC_LOCALIZ )

			//Atualiza a ordem de separa��o Embalagem
			If (cArqTmp)->B1_TIPO == 'EM'
				GrvCB8(cOrdSepEmb, (cArqTmp)->D4_COD, (cArqTmp)->D4_LOCAL,;
				(cArqTmp)->DC_QTDORIG,;
				(cArqTmp)->D4_LOTECTL, (cArqTmp)->D4_NUMLOTE, (cArqTmp)->D4_OP,  (cArqTmp)->DC_LOCALIZ )
			EndIf
		EndIf
		(cArqTmp)->(DbSkip())
	EndDo

	If Select(cArqTmp) > 0
		(cArqTmp)->(DbCloseArea())
	EndIf

	RestArea(aArea)
Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �GrvSZT		�Autor  �Microsiga	     � Data �  17/02/2020 ���
�������������������������������������������������������������������������͹��
���Desc.     �Atualiza a ordem de separa��o nas tabela SZT e CB8		  ���
���          �												              ���
�������������������������������������������������������������������������͹��
���Uso       � Ap		                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GrvSZT(cProd, cOp, cArmz, nQtdOri, cLote, cSubLote, nQtdEmb, cEndLocz,;
	cOrdSepInt, cOrdSepKg, cOrdSepDec, cOrdSepEmb)

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
	Default cOrdSepEmb := ""

	DbSelectArea("SZT")
	DbSetOrder(1)

	RecLock("SZT",.T.)
	SZT->ZT_FILIAL  := xFilial("SZT")
	SZT->ZT_ORDSEP  := cOrdSepInt			//Ordem de separa��o inteiro
	SZT->ZT_ORDSEP2 := cOrdSepKg			//Ordem de separa��o fracionado em Kg
	SZT->ZT_ORDSEP3 := ""					//Ordem de Separa��o algutinado
	SZT->ZT_ORDSEP4 := cOrdSepDec			//Ordem de separa��o fracionado Decimal
	SZT->ZT_ORDEMB	:= cOrdSepEmb			//Ordem de Separa��o de Embalagem
	SZT->ZT_ORDEMB2	:= ""					//Ordem de Separa��o aglutinado de Embalagem
	SZT->ZT_ITEM    := Soma1(GetItemSzt(cOp))
	SZT->ZT_PROD    := cProd
	SZT->ZT_LOCAL   := cArmz
	SZT->ZT_LOTECTL := cLote
	SZT->ZT_QTDORI  := nQtdOri
	SZT->ZT_LCALIZ	:= cEndLocz
	SZT->ZT_OBSERV	:= ""

	If nQtdEmb != 0

		If Posicione("SB1",1,xFilial("SB1")+cProd,"B1_TIPO") == 'EM'
			// SZT->ZT_QTDEMB1  := Ceiling(nQtdOri/nQtdEmb) //Embalagem
			SZT->ZT_QTDEMB1  := nQtdOri //Embalagem
		Else
			SZT->ZT_QTDMUL  := Int(nQtdOri/nQtdEmb)*nQtdEmb//Inteiro
			SZT->ZT_QTDDIF  := nQtdOri-(Int(nQtdOri/nQtdEmb)*nQtdEmb) //Fracionado Kg,Dec
			SZT->ZT_QTDB01  := int(nQtdOri-(Int(nQtdOri/nQtdEmb)*nQtdEmb))//Fracionado Kg
			SZT->ZT_QTDB02  := (nQtdOri-(Int(nQtdOri/nQtdEmb)*nQtdEmb)) - int(nQtdOri-(Int(nQtdOri/nQtdEmb)*nQtdEmb))//Fracionado decimal 
		EndIf 
	EndIf

	SZT->ZT_DATA    := MsDate()
	SZT->ZT_HORA    := Time()
	SZT->ZT_USUARIO := cUserName
	SZT->ZT_OP		:= cOp
	SZT->(MsUnLock())

	RestArea(aArea)
Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �GetItemSzt	�Autor  �Microsiga	     � Data �  17/02/2020 ���
�������������������������������������������������������������������������͹��
���Desc.     �Retorna o proximo item da tabela SZT						  ���
���          �												              ���
�������������������������������������������������������������������������͹��
���Uso       � Ap		                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �GrvCB8		�Autor  �Microsiga	     � Data �  17/02/2020 ���
�������������������������������������������������������������������������͹��
���Desc.     �Grava os dados da ordem de separa��o						  ���
���          �												              ���
�������������������������������������������������������������������������͹��
���Uso       � Ap		                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �GetItemCB8	�Autor  �Microsiga	     � Data �  17/02/2020 ���
�������������������������������������������������������������������������͹��
���Desc.     �Retorna o proximo item da tabela CB8						  ���
���          �												              ���
�������������������������������������������������������������������������͹��
���Uso       � Ap		                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �GerOrdAglu	�Autor  �Microsiga	     � Data �  04/03/2020 ���
�������������������������������������������������������������������������͹��
���Desc.     �Gera ordem de separa��o aglutinada						  ���
���          �												              ���
�������������������������������������������������������������������������͹��
���Uso       � Ap		                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
			//Grava o cabe�alho da ordem de separa��o aglutinada
			cOrdSep := GrvCab( "","2","00*08*09",cOperador,"DEC") 
			lCab := .T.
		EndIf

		//Grava��o dos itens da ordem de separa��o aglutinada 
		GrvCB8(cOrdSep,;			//Ordem de separa��o 
		(cArqTmp)->ZT_PROD,;		//Produto 
		(cArqTmp)->ZT_LOCAL,;		//Armazem 
		(cArqTmp)->ZT_QTDDIF,;		//Quantidade
		(cArqTmp)->ZT_LOTECTL,;		//Lote 
		"",;						//Sublote 
		"",(cArqTmp)->ZT_LCALIZ )						//OP

		(cArqTmp)->(DbSkip())
	EndDo

	//Atualiza a tabela SZT com o numero da ordem de separa��o aglutinada;
	If !Empty(cOrdSep)
		AtuAglSZT(cOps, cOrdSep, .f.)
	EndIf

	If Select(cArqTmp) > 0
		(cArqTmp)->(DbCloseArea())
	EndIf

	RestArea(aArea)
Return



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �GerEmbAglu	�Autor  �Microsiga	     � Data �  04/03/2020 ���
�������������������������������������������������������������������������͹��
���Desc.     �Gera ordem de separa��o aglutinada						  ���
���          �												              ���
�������������������������������������������������������������������������͹��
���Uso       � Ap		                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GerEmbAglu(cOps, cOperador)

	Local aArea		:= GetArea()
	Local cQuery	:= ""
	Local cArqTmp	:= GetNextAlias()
	Local lCab		:= .F.
	Local cOrdEmb	:= ""

	Default cOps		:= ""
	Default cOperador	:= ""

	cQuery	:= " SELECT ZT_PROD, ZT_LOCAL, ZT_LCALIZ, ZT_LOTECTL, SUM(ZT_QTDEMB1) ZT_QTDEMB1, "+CRLF 
	cQuery	+= " SUM(ZT_QTDB01) ZT_QTDB01, SUM(ZT_QTDB02) ZT_QTDB02 FROM "+RetSqlName("SZT")+" SZT "+CRLF
	cQuery	+= " WHERE SZT.ZT_FILIAL = '"+xFilial("SZT")+"' "+CRLF
	cQuery	+= " AND SZT.ZT_OP IN"+FormatIn(cOps,";")+" "+CRLF
	cQuery	+= " AND SZT.D_E_L_E_T_ = ' ' "+CRLF
	cQuery	+= " GROUP BY ZT_PROD, ZT_LOCAL, ZT_LCALIZ, ZT_LOTECTL "+CRLF

	DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cArqTmp,.T.,.T.)

	While (cArqTmp)->(!Eof())

		If !lCab
			//Grava o cabe�alho da ordem de separa��o aglutinada
			cOrdEmb := GrvCab( "","5","00*08*09",cOperador,"DEC") 
			lCab := .T.
		EndIf

		//Grava��o dos itens da ordem de separa��o aglutinada 
		GrvCB8(cOrdEmb,;			//Ordem de separa��o 
		(cArqTmp)->ZT_PROD,;		//Produto 
		(cArqTmp)->ZT_LOCAL,;		//Armazem 
		(cArqTmp)->ZT_QTDEMB1,;		//Quantidade
		(cArqTmp)->ZT_LOTECTL,;		//Lote 
		"",;						//Sublote 
		"",(cArqTmp)->ZT_LCALIZ )						//OP

		(cArqTmp)->(DbSkip())
	EndDo

	//Atualiza a tabela SZT com o numero da ordem de separa��o aglutinada;
	If !Empty(cOrdEmb)
		AtuAglSZT(cOps, cOrdEmb, .t.)
	EndIf

	If Select(cArqTmp) > 0
		(cArqTmp)->(DbCloseArea())
	EndIf

	RestArea(aArea)
Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �AtuAglSZT		�Autor  �Microsiga	     � Data �  04/03/2020 ���
�������������������������������������������������������������������������͹��
���Desc.     �Atualiza o codigo do OS aglutinada na tabela SZT			  ���
���          �												              ���
�������������������������������������������������������������������������͹��
���Uso       � Ap		                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function AtuAglSZT(cOps, cOrdSep, lEmb)

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

		If lEmb
			SZT->ZT_ORDEMB2 := cOrdSep
		Else
			SZT->ZT_ORDSEP3 := cOrdSep
		EndIf
		
		SZT->(MsUnLock())
		
		(cArqTmp)->(DbSkip())
	EndDo
	
	If Select(cArqTmp) > 0
		(cArqTmp)->(DbCloseArea())
	EndIf

	RestArea(aArea)
Return
