//Bibliotecas
#Include "Protheus.ch"
#Include "TopConn.ch"
#include "rwmake.ch"
//Constantes
#Define STR_PULA    Chr(13)+Chr(10) // auxilia formatacao do sql para caso de uso do memowrite

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CTMK001   ºAutor  ³Leandro Nishihata  º Data ³  21/12/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³' tela cadastro ZZU - CADASTRO DE PARCEIROS X CONTATO 	  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ cs                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER FUNCTION CTMK001()

Local cAlias := "ZZU"
Local cExprFilTop  := "" 
Local aParamBox			:= {}
Local aRet := {}
   
PRIVATE cCadastro := "Cadastro de Fornecedores"
PRIVATE aRotina     := { }

// retirado a pedido de ana caroline.

//aAdd(aParamBox,{1,"Codigo           :",Space(200),"","mv_par02:=POSICIONE('SU5',1,XFILIAL('SU5')+mv_par01,'U5_CONTAT')+Space(200)","","",90,.f.}) // Tipo caractere
//aAdd(aParamBox,{1,"Agente           :",Space(200),"","mv_par01:=(u_VTMK001B('4'))","","",90,.f.}) // Tipo caractere

AADD(aRotina, { "Pesquisar" , "AxPesqui", 0, 1 })
AADD(aRotina, { "Visualizar", "AxVisual", 0, 2 })
AADD(aRotina, { "Incluir"   , "AxInclui", 0, 3 })
AADD(aRotina, { "Alterar"   , "AxAltera", 0, 4 })
AADD(aRotina, { "Excluir"   , "AxDeleta", 0, 5 })

dbSelectArea(cAlias)

dbSetOrder(1)

//	If ParamBox(aParamBox,"Nome agente",@aRet)
//		if !empty(aret[1])
//			cExprFilTop := "ZZU_CODAGE ='"+ aret[1]+"'"
//		endif
		mBrowse(6, 1, 22, 75, cAlias,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,cExprFilTop)
//	Endif
 
RETURN NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RCTMK001   ºAutor  ³Leandro Nishihata  º Data ³  21/12/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³' relatorio - CADASTRO DE PARCEIROS X CONTATO 	  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ cs                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User function RCTMK001()
	//criacao da barra de progresso
	processa({|| relatorio()} ,"Gerando relatório")
	
	return
	//impressao do relatorio
	Static function relatorio()
	Local aArea     := GetArea()
	Local cQuery        := ""
	Local oFWMsExcel
	Local oExcel
	Local cArquivo  := GetTempPath()+'zTstExc1.xml'
	Private cPerg := "RCTMK001"
	
	ValidPerg()
	Pergunte(cPerg, .T. )
	ProcRegua(0)
	
	//Selecionando dados

	cQuery := " SELECT "                                                			+ STR_PULA
	cQuery += " case WHEN UPPER(Z3_DESENT) LIKE '%CERTISIGN%' THEN '2' "			+ STR_PULA
	cQuery += " Else '1' end TIPO, "								        		+ STR_PULA
	cQuery += "    ZZU_CODIGO, "   	                                   				+ STR_PULA
	cQuery += "    ZZU_CODAR, "                                       				+ STR_PULA
	cQuery += "    ZZU_CODPA, "                                       				+ STR_PULA
	cQuery += "    ZZU_CODAGE, "                                       				+ STR_PULA
	cQuery += "    ZZU_CODSUP, "                                       				+ STR_PULA
	cQuery += "    ZZU_CODBKP, "                                       				+ STR_PULA
	cQuery += "    ZZU_FERRAM "                                       				+ STR_PULA
	cQuery += " FROM " + RetSqlName("ZZU") + " ZZU, " 								+ STR_PULA
	cQuery += " 	 " + RetSqlName("SZ3") + " SZ3 " 								+ STR_PULA
	cQuery += " WHERE "                                       						+ STR_PULA
	cQuery += "        ZZU_CODAR  BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "       + STR_PULA
	cQuery += "    AND ZZU_CODPA  BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "       + STR_PULA
	cQuery += "    AND ZZU_CODAGE BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "       + STR_PULA
	cQuery += "    AND ZZU_CODSUP BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"' "       + STR_PULA
	cQuery += "    AND ZZU.D_E_L_E_T_ = ' ' "                           			+ STR_PULA
	cQuery += "    AND SZ3.D_E_L_E_T_ = ' ' "                           			+ STR_PULA
	cQuery += "    AND ZZU_FILIAL   = '" + xFilial("ZZU") + "' "  					+ STR_PULA
	cQuery += "    AND ZZU_FILIAL   = '" + xFilial("SZ3") + "' "  					+ STR_PULA
	cQuery += "	   AND ZZU_CODAR = Z3_CODENT" 							 			+ STR_PULA
	cQuery += " ORDER BY "                                              			+ STR_PULA
	cQuery += "     TIPO, ZZU_CODAR, ZZU_CODPA "                              		+ STR_PULA
	
	TCQuery cQuery New Alias "QRYPRO" 	

	//Criando o objeto que irá gerar o conteúdo do Excel
	oFWMsExcel := FWMSExcel():New()

	//Aba 01 - Parceiros

	oFWMsExcel:AddworkSheet("PARCEIROS")
	//Criando a Tabela
	oFWMsExcel:SetTitleSizeFont(30)
	oFWMsExcel:AddTable("PARCEIROS","RELAÇÃO DE PARCEIROS")
	oFWMsExcel:AddColumn("PARCEIROS","RELAÇÃO DE PARCEIROS","AR",1)
	oFWMsExcel:AddColumn("PARCEIROS","RELAÇÃO DE PARCEIROS","Supervisor",1)
	oFWMsExcel:AddColumn("PARCEIROS","RELAÇÃO DE PARCEIROS","E-mail Supervisão",1)
	oFWMsExcel:AddColumn("PARCEIROS","RELAÇÃO DE PARCEIROS","Backup",1)
	oFWMsExcel:AddColumn("PARCEIROS","RELAÇÃO DE PARCEIROS","e-mail Backup",1)
	oFWMsExcel:AddColumn("PARCEIROS","RELAÇÃO DE PARCEIROS","Ponto de atendimento - P.A",1)
	oFWMsExcel:AddColumn("PARCEIROS","RELAÇÃO DE PARCEIROS","Agente",1)
	oFWMsExcel:AddColumn("PARCEIROS","RELAÇÃO DE PARCEIROS","E-mail Agente",1)
	oFWMsExcel:AddColumn("PARCEIROS","RELAÇÃO DE PARCEIROS","Ferramenta",1)

	//Criando as Linhas... Enquanto não for fim da query
	While !(QRYPRO->(EoF())) .AND. QRYPRO->TIPO = "1"
	IncProc()
	
		oFWMsExcel:AddRow("PARCEIROS","RELAÇÃO DE PARCEIROS",{;
		POSICIONE("SZ3",1,XFILIAL("SZ3")+QRYPRO->ZZU_CODAR ,"Z3_DESENT"),;
		POSICIONE("SU5",1,XFILIAL("SU5")+QRYPRO->ZZU_CODSUP,"U5_CONTAT"),;
		POSICIONE("SU5",1,XFILIAL("SU5")+QRYPRO->ZZU_CODSUP,"U5_EMAIL"),;
		POSICIONE("SU5",1,XFILIAL("SU5")+QRYPRO->ZZU_CODBKP,"U5_CONTAT"),;
		POSICIONE("SU5",1,XFILIAL("SU5")+QRYPRO->ZZU_CODBKP,"U5_EMAIL"),;
		POSICIONE("SZ3",1,XFILIAL("SZ3")+QRYPRO->ZZU_CODPA ,"Z3_DESENT"),;
		POSICIONE("SU5",1,XFILIAL("SU5")+QRYPRO->ZZU_CODAGE,"U5_CONTAT"),;
		POSICIONE("SU5",1,XFILIAL("SU5")+QRYPRO->ZZU_CODAGE,"U5_EMAIL"),;
		X3Combo("ZZU_FERRAM",QRYPRO->ZZU_FERRAM) ;
		})
		
		//Pulando Registro
		QRYPRO->(DbSkip())
	EndDo

	oFWMsExcel:AddworkSheet("CERTISIGN")
	//Criando a Tabela
	oFWMsExcel:SetTitleSizeFont(30)
	oFWMsExcel:SetTitleBgColor("#D0CFCA")
	oFWMsExcel:AddTable("CERTISIGN","CERTISIGN")
	oFWMsExcel:AddColumn("CERTISIGN","CERTISIGN","AR",1)
	oFWMsExcel:AddColumn("CERTISIGN","CERTISIGN","Supervisor",1)
	oFWMsExcel:AddColumn("CERTISIGN","CERTISIGN","E-mail Supervisão",1)
	oFWMsExcel:AddColumn("CERTISIGN","CERTISIGN","Backup",1)
	oFWMsExcel:AddColumn("CERTISIGN","CERTISIGN","e-mail Backup",1)
	oFWMsExcel:AddColumn("CERTISIGN","CERTISIGN","Ponto de atendimento - P.A",1)
	oFWMsExcel:AddColumn("CERTISIGN","CERTISIGN","Agente",1)
	oFWMsExcel:AddColumn("CERTISIGN","CERTISIGN","E-mail Agente",1)
	oFWMsExcel:AddColumn("CERTISIGN","CERTISIGN","Ferramenta",1)

	While !(QRYPRO->(EoF())) .AND. QRYPRO->TIPO = "2"
	IncProc()
	
	 	oFWMsExcel:AddRow("CERTISIGN","CERTISIGN",{;
		POSICIONE("SZ3",1,XFILIAL("SZ3")+QRYPRO->ZZU_CODAR ,"Z3_DESENT"),;
		POSICIONE("SU5",1,XFILIAL("SU5")+QRYPRO->ZZU_CODSUP,"U5_CONTAT"),;
		POSICIONE("SU5",1,XFILIAL("SU5")+QRYPRO->ZZU_CODSUP,"U5_EMAIL"),;
		POSICIONE("SU5",1,XFILIAL("SU5")+QRYPRO->ZZU_CODBKP,"U5_CONTAT"),;
		POSICIONE("SU5",1,XFILIAL("SU5")+QRYPRO->ZZU_CODBKP,"U5_EMAIL"),;
		POSICIONE("SZ3",1,XFILIAL("SZ3")+QRYPRO->ZZU_CODPA ,"Z3_DESENT"),;
		POSICIONE("SU5",1,XFILIAL("SU5")+QRYPRO->ZZU_CODAGE,"U5_CONTAT"),;
		POSICIONE("SU5",1,XFILIAL("SU5")+QRYPRO->ZZU_CODAGE,"U5_EMAIL"),;
		X3Combo("ZZU_FERRAM",QRYPRO->ZZU_FERRAM) ;
		})
		//Pulando Registro
		QRYPRO->(DbSkip())
	EndDo

	//Ativando o arquivo e gerando o xml
	oFWMsExcel:Activate()
	oFWMsExcel:GetXMLFile(cArquivo)

	//Abrindo o excel e abrindo o arquivo xml
	oExcel := MsExcel():New()           //Abre uma nova conexão com Excel
	oExcel:WorkBooks:Open(cArquivo)     //Abre uma planilha
	oExcel:SetVisible(.T.)              //Visualiza a planilha
	oExcel:Destroy()                    //Encerra o processo do gerenciador de tarefas

	QRYPRO->(DbCloseArea())
	RestArea(aArea)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VCTMK001   ºAutor  ³Leandro Nishihata  º Data ³  21/12/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³' consulta  para os campos  ZZU_PA e ZZU_AR				  º±±
±±º		TIPO = 1 - PA													  º±±
±±º			 = 2 - AR													  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ cs                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER FUNCTION VTMK001A(TIPO)

	Local cSQL     := ''
	Local cTRB     := ''
	Local cCODENT  := ''
	Local cEntida  := ''
	Local cNomeEnt := ''
	Local cOrdem   := ''
	Local cRet     := ''
	Local cdescret := ''
	Local cSeek    := Space(60)
	Local nOrd     := 2
	Local nOpc     := 0
	Local aDados   := {}
	Local aOrdem   := {}
	Local oDlg
	Local oLbx
	Local oOrdem
	Local oSeek
	Local oPesq
	Local oPnlTop
	Local oPnlAll
	Local oPnlBot
	Local ONOMRK
	Local oMrk
	Local campo

	IF tipo = "1"
		campo := ALLTRIM(M->ZZU_PA)
		tipent:= '4'
	else
		campo := ALLTRIM(M->ZZU_AR)
		tipent:= '3'
	endif
	IF EMPTY(campo)
		Return( .T. )
	Endif

	Private cCadastro := 'Contatos - Corporativo'

	AAdd( aOrdem, 'Matricula' )

	//-- Montagem da query.
	cSQL += " select     "												+ STR_PULA
	cSQL += " Z3_CODGAR, " 												+ STR_PULA
	cSQL += " Z3_CODENT, " 												+ STR_PULA
	cSQL += " Z3_DESENT, "												+ STR_PULA
	cSQL += " Z3_DESAR,  "												+ STR_PULA
	cSQL += " Z3_RAZSOC	 " 		  										+ STR_PULA
	cSQL += " FROM   " + RetSqlName("SZ3") + " " 						+ STR_PULA
	cSQL += " WHERE "													+ STR_PULA
	cSQL += " 	  Z3_FILIAL  = '" + xFilial("SZ3") + "' "  				+ STR_PULA
	cSQL += " AND D_E_L_E_T_ = ' ' "									+ STR_PULA
	cSQL += " AND Z3_TIPENT  = '"+tipent+"' "							+ STR_PULA
	cSQL += " AND Z3_ATIVO  = 'S' "										+ STR_PULA
//	cSQL += " AND Z3_REDE <> ' '  "										+ STR_PULA
	cSQL += " AND (    UPPER(Z3_DESAR)  LIKE '%"+campo+"%'" 			+ STR_PULA
	cSQL += " 		OR UPPER(Z3_DESENT) LIKE '%"+campo+"%'" 			+ STR_PULA
	cSQL += " 		OR UPPER(Z3_RAZSOC)  LIKE '%"+campo+"%' ) "			+ STR_PULA
	//MemoWrite("C:\Protheus\tmp\PESQSZ3.SQL",cSQL)

	cTRB := GetNextAlias()
	cSQL := ChangeQuery( cSQL )
	dbUseArea( .T., 'TOPCONN', TCGENQRY( , , cSQL ), cTRB, .F., .T. )

	If (cTRB)->( !Eof() )
		While (cTRB)->( !Eof() )
			(cTRB)->( AAdd( aDados, { (cTRB)->Z3_CODGAR,(cTRB)->Z3_CODENT, (cTRB)->Z3_DESENT,(cTRB)->Z3_DESAR, (cTRB)->Z3_RAZSOC  } ) )
			(cTRB)->( dbSkip() )
		End
	Else
		MsgInfo('Atenção, ' + CRLF + 'pesquisa não retornou resultados, por favor, tentar outra expressão ','Atenção')
		RETURN( .F. )
	EndIf
	(cTRB)->(dbCloseArea())

	//-- Montagem da tela que sera apresentado para o usuario no momento da acao da tecla F3.
	DEFINE MSDIALOG oDlg TITLE cCadastro FROM 0,0 TO 308,770 OF oDlg PIXEL STYLE DS_MODALFRAME STATUS

	oDlg:lEscClose := .F.

	oPnlTop       := TPanel():New( 0, 0, '', oDlg, Nil, .F.,,,, 0, 14, .F., .T. )
	oPnlTop:Align := CONTROL_ALIGN_TOP

	@ 1,001 COMBOBOX oOrdem VAR cOrdem ITEMS aOrdem SIZE 80,36 ON CHANGE (nOrd:=oOrdem:nAt) PIXEL OF oPnlTop
	@ 1,082 MSGET    oSeek  VAR cSeek          SIZE 160,9 PIXEL OF oPnlTop
	//@ 1,247 BUTTON   oPesq  PROMPT 'Pesquisar' SIZE 50,11 PIXEL OF oPnlTop ACTION (GST01Psq(nOrd,cSeek,@oLbx))

	oPnlAll := TPanel():New( 0, 0, '', oDlg, Nil, .F.,,,, 0, 14, .F., .T. )
	oPnlAll:Align := CONTROL_ALIGN_ALLCLIENT

	oPnlBot := TPanel():New( 0, 0, '', oDlg, Nil, .F.,,,, 0, 14, .F., .T. )
	oPnlBot:Align := CONTROL_ALIGN_BOTTOM

	oLbx := TwBrowse():New( 0, 0, 1000, 1020,, {'Codigo GAR','Cod Entidade', 'Entidade', 'AR','Razão social'},, oPnlAll,,,,,,,,,,,, .F.,, .T.,, .F. )
	oLbx:Align := CONTROL_ALIGN_ALLCLIENT
	oLbx:SetArray( aDados )
	oLbx:bLine := {|| { aDados[oLbx:nAt,1], aDados[oLbx:nAt,2], aDados[oLbx:nAt,3],aDados[oLbx:nAt,4],aDados[oLbx:nAt,5], '' } }

	oLbx:bLDblClick := {|| Iif(BUSCASZ3(oLbx,@nOpc,@cRet,@cdescret,oLbx:nAt),oDlg:End(),Nil) }

	@ 1,001 BUTTON oConfirm PROMPT 'OK'   SIZE 40,11 PIXEL OF oPnlBot ACTION Iif( BUSCASZ3(oLbx,@nOpc,@cRet,@cdescret,oLbx:nAt), oDlg:End(), Nil )
	@ 1,044 BUTTON oCancel  PROMPT 'Sair' SIZE 40,11 PIXEL OF oPnlBot ACTION ( oDlg:End() )

	ACTIVATE MSDIALOG oDlg CENTER

	If nOpc == 1
		IF tipo = "1"
			M->ZZU_PA    := cdescret
			M->ZZU_CODPA := cRet
		else
			M->ZZU_AR    := cdescret
			M->ZZU_CODAR := cRet
		endif
	EndIf
	Return( .T. )

RETURN

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³BUSCASZ3   ³ Autor ³Leandro Nishata        ³ Data ³ 28/12/2016 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³  acao botao ok, retorna dados selecionados  (VTMK001A)           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Obs.      ³                                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function BUSCASZ3( oLbx, nOpc, cRet,cdescret, nLin )

	Local lRet := .T.
	cRet := AllTrim( oLbx:aArray[nLin,2] )
	cdescret := AllTrim( oLbx:aArray[nLin,3] )
	nOpc := Iif( lRet, 1, 0 )

Return( lRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VCTMK001   ºAutor  ³Leandro Nishihata  º Data ³  21/12/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³' consulta  para os campos  ZZU_PA e ZZU_AR				  º±±
±±º		TIPO = 1 - PA													  º±±
±±º			 = 2 - AR													  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ cs                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function VTMK001B(TIPO)
Local ret
ret:= processa({|| RetSU5(TIPO)} ,"Efetuando busca")

return mv_par01
static FUNCTION RetSU5(TIPO)

	Local cSQL     := ''
	Local cTRB     := ''
	Local cCODENT  := ''
	Local cEntida  := ''
	Local cNomeEnt := ''
	Local cOrdem   := ''
	Local cRet     := ''
	Local cdescret := ''
	Local cmailcret:= ''
	Local cSeek    := Space(60)
	Local nOrd     := 2
	Local nOpc     := 0
	Local aDados   := {}
	Local aOrdem   := {}
	Local oDlg
	Local oLbx
	Local oOrdem
	Local oSeek
	Local oPesq
	Local oPnlTop
	Local oPnlAll
	Local oPnlBot
	Local ONOMRK
	Local oMrk
	Local campo
	Local codigo := ""
	
	ProcRegua(0)
	IncProc()
	IF tipo = "1"
		campo  := upper(ALLTRIM(M->ZZU_AGENTE))

	ElseIF TIPO = "2"
		campo  := upper(ALLTRIM(M->ZZU_SUPERV))
		
	Elseif TIPO = "3"
		campo  := upper(ALLTRIM(M->ZZU_BKPSUP))

	ELSE
		campo  := upper(ALLTRIM(MV_PAR02))
		codigo := MV_PAR01
		
	endif
	IF EMPTY(campo)
		Return( .T. )
	elseif LEN(campo) <=4
		msgalert("Por favor, efetuar a busca com mais de 4 caracteres !!!")
		Return( .F. )
	Endif
	IF !empty(campo) 
		Private cCadastro := 'Contatos - Corporativo'
	
		AAdd( aOrdem, 'Matricula' )
		IncProc()
		//-- Montagem da query.
	
		cSQL += " SELECT	    	 "								+ STR_PULA
		cSQL += " 	U5_FILIAL, "									+ STR_PULA
		cSQL += " 	U5_CODCONT, "									+ STR_PULA
		cSQL += " 	U5_CONTAT,"										+ STR_PULA
		cSQL += " 	U5_STATUS,"										+ STR_PULA
		cSQL += " 	U5_EMAIL "										+ STR_PULA
		cSQL += " FROM " + RetSqlName("SU5") + " " 					+ STR_PULA
		cSQL += " WHERE " 											+ STR_PULA
		cSQL += " 	  U5_FILIAL  = '" + xFilial("SU5") + "' "  		+ STR_PULA 
		cSQL += " AND U5_CPF <> ' '    " 							+ STR_PULA
		cSQL += " AND UPPER(TRIM(U5_CONTAT)) LIKE  '"+campo+"%' "	+ STR_PULA
        cSQL += " AND INSTR(TRIM(U5_CONTAT),' ') <> 0" 				+ STR_PULA  					
		cSQL += " AND TRIM(U5_CONTAT) <> ' '" 						+ STR_PULA  							
		cSQL += " AND U5_FUNCAO IN('000004','000057','000058','000012')"	+ STR_PULA  
		cSQL += " AND U5_STATUS IN (' ', '2')" 						+ STR_PULA  							
		cSQL += " AND D_E_L_E_T_ = ' '" 							+ STR_PULA 
		cSQL += " AND U5_ATIVO = '1'" 								+ STR_PULA
		
		cTRB := GetNextAlias()
		cSQL := ChangeQuery( cSQL )
		dbUseArea( .T., 'TOPCONN', TCGENQRY( , , cSQL ), cTRB, .F., .T. )
	
		If (cTRB)->( !Eof() )
			While (cTRB)->( !Eof() )
				(cTRB)->( AAdd( aDados, { (cTRB)->U5_CODCONT, (cTRB)->U5_CONTAT,(cTRB)->U5_EMAIL  } ) )
				(cTRB)->( dbSkip() )
				IncProc()
			End
		Else
			MsgInfo('Atenção, ' + CRLF + 'pesquisa não retornou resultados, por favor, tentar outra expressão ','alerta')
			IF tipo = "1"
				M->ZZU_AGENTE := SPACE(TAMSX3("ZZU_AGENTE")[1]) 
				M->ZZU_AGMAIL := SPACE(TAMSX3("ZZU_AGMAIL")[1]) 
				M->ZZU_CODAGE := SPACE(TAMSX3("ZZU_CODAGE")[1])
				M->ZZU_TELSUP := SPACE(TAMSX3("ZZU_CODAGE")[1]) 
	
			elseIF  tipo = "2"
				M->ZZU_SUPERV := SPACE(TAMSX3("ZZU_AGENTE")[1]) 
				M->ZZU_SUMAIL := SPACE(TAMSX3("ZZU_SUMAIL")[1]) 
				M->ZZU_CODSUP := SPACE(TAMSX3("ZZU_CODSUP")[1]) 
				M->ZZU_CODSUP := SPACE(TAMSX3("ZZU_CODSUP")[1])
				
			elseIF tipo = "3"
				M->ZZU_BKPSUP := SPACE(TAMSX3("ZZU_AGENTE")[1]) 
				M->ZZU_BKMAIL := SPACE(TAMSX3("ZZU_BKMAIL")[1]) 
				M->ZZU_CODBKP := SPACE(TAMSX3("ZZU_CODBKP")[1])
				M->ZZU_TELSUP := SPACE(TAMSX3("ZZU_CODBKP")[1])
			ELSE 
			 	mv_par01 := SPACE(TAMSX3("ZZU_AGENTE")[1])
			 	 
			endif
			(cTRB)->(dbCloseArea())
			Return( .T. )
		EndIf
		(cTRB)->(dbCloseArea())

//	
		DEFINE MSDIALOG oDlg TITLE cCadastro FROM 0,0 TO 308,770 OF oDlg PIXEL STYLE DS_MODALFRAME STATUS
	
		oDlg:lEscClose := .F.
	
		oPnlTop       := TPanel():New( 0, 0, '', oDlg, Nil, .F.,,,, 0, 14, .F., .T. )
		oPnlTop:Align := CONTROL_ALIGN_TOP
	
		@ 1,001 COMBOBOX oOrdem VAR cOrdem ITEMS aOrdem SIZE 80,36 ON CHANGE (nOrd:=oOrdem:nAt) PIXEL OF oPnlTop
		@ 1,082 MSGET    oSeek  VAR cSeek          SIZE 160,9 PIXEL OF oPnlTop
		//@ 1,247 BUTTON   oPesq  PROMPT 'Pesquisar' SIZE 50,11 PIXEL OF oPnlTop ACTION (GST01Psq(nOrd,cSeek,@oLbx))
	
		oPnlAll := TPanel():New( 0, 0, '', oDlg, Nil, .F.,,,, 0, 14, .F., .T. )
		oPnlAll:Align := CONTROL_ALIGN_ALLCLIENT
	
		oPnlBot := TPanel():New( 0, 0, '', oDlg, Nil, .F.,,,, 0, 14, .F., .T. )
		oPnlBot:Align := CONTROL_ALIGN_BOTTOM
		oLbx := TwBrowse():New( 0, 0, 1000, 1020,, {'Cod Contato', 'Contato', 'E-Mail'},, oPnlAll,,,,,,,,,,,, .F.,, .T.,, .F. )
		oLbx:Align := CONTROL_ALIGN_ALLCLIENT
		oLbx:SetArray( aDados )
		oLbx:bLine := {|| { aDados[oLbx:nAt,1], aDados[oLbx:nAt,2], aDados[oLbx:nAt,3], '' } }
	
		oLbx:bLDblClick := {|| Iif(BUSCASU5(oLbx,@nOpc,@cRet,@cdescret,@cmailcret,oLbx:nAt),oDlg:End(),Nil) }
	
		@ 1,001 BUTTON oConfirm PROMPT 'OK'   SIZE 40,11 PIXEL OF oPnlBot ACTION Iif( BUSCASU5(oLbx,@nOpc,@cRet,@cdescret,@cmailcret,oLbx:nAt), oDlg:End(), Nil )
		@ 1,044 BUTTON oCancel  PROMPT 'Sair' SIZE 40,11 PIXEL OF oPnlBot ACTION ( nOpc:=2,oDlg:End() )
	
		ACTIVATE MSDIALOG oDlg CENTER
	
		If nOpc == 1
			IF tipo = "1"
				M->ZZU_AGENTE := cdescret
				M->ZZU_AGMAIL := cmailcret
				M->ZZU_CODAGE := cRet
				M->ZZU_TELAGE := TMK001BUSCATEL(cRet)
	                                                     
			elseIF  tipo = "2"
				M->ZZU_SUPERV := cdescret
				M->ZZU_SUMAIL := cmailcret
				M->ZZU_CODSUP := cRet
				M->ZZU_TELSUP := TMK001BUSCATEL(cRet)

			elseIF  tipo = "3"
				M->ZZU_BKPSUP := cdescret
				M->ZZU_BKMAIL := cmailcret
				M->ZZU_CODBKP := cRet
				M->ZZU_TELSUP := TMK001BUSCATEL(cRet)
		ELSE
				mv_par01 := cRet
				mv_par02 := cdescret
			endif
		ELSE
			IF tipo = "1"
				M->ZZU_AGENTE := SPACE(TAMSX3("ZZU_AGENTE")[1]) 
			elseIF  tipo = "2"
				M->ZZU_SUPERV := SPACE(TAMSX3("ZZU_SUPERV")[1])
			elseIF  tipo = "3"
				M->ZZU_BKPSUP := SPACE(TAMSX3("ZZU_BKPSUP")[1])
			ELSE 
				mv_par01 := SPACE(TAMSX3("ZZU_AGENTE")[1])
			endif
		EndIf
	ENDIF
Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³BUSCASU5   ³ Autor ³Leandro Nishata        ³ Data ³ 28/12/2016 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³  acao botao ok, retorna dados selecionados  (RetSU5)           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Obs.      ³                                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function BUSCASU5( oLbx, nOpc, cRet,cdescret,cmailcret, nLin )

	Local lRet := .T.

	cRet := AllTrim( oLbx:aArray[nLin,1] )
	cdescret := AllTrim( oLbx:aArray[nLin,2] )
	cmailcret := AllTrim( oLbx:aArray[nLin,3] )
	nOpc := Iif( lRet, 1, 0 )

Return( lRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ValidPerg   ³ Autor ³Leandro Nishata        ³ Data ³ 28/12/2016 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³                                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Obs.      ³                                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±\±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ValidPerg()
	Local J  := 0
	Local ny := 0
	dbSelectArea("SX1")
    dbSetOrder(1)

   // Guarda o alias do arquivo, chave e ponteiro
   aAreaAnt := GetArea()
   aAreaSX1 := SX1->(GetArea())

   aReg := {}
   cPerg := padr(cPerg,10)

   // Adiciona as perguntas no dicionário.
   aAdd(aReg,{cPerg,      "01",       "Código AR de  		",  "MV_CH1",     "C",       06,           0,            0,           "G",      "",         "MV_PAR02", "",            "",         "",         "",         "",         "",         "",                   "",         "",         "",         "",         "",         "",         "",         "SZ3_03"  })
   aAdd(aReg,{cPerg,      "02",       "Código AR até 		",  "MV_CH2",     "C",       06,           0,            0,           "G",      "",         "MV_PAR02", "",            "",         "",         "",         "",         "",         "",                   "",         "",         "",         "",         "",         "",         "",         "SZ3_03"  })
   aAdd(aReg,{cPerg,      "03",       "Código PA de   		",  "MV_CH3",     "C",       06,           0,            0,           "G",      "",         "MV_PAR03", "",            "",         "",         "",         "",         "",         "",                   "",         "",         "",         "",         "",         "",         "",         "SZ3_04"  })
   aAdd(aReg,{cPerg,      "04",       "Código PA até  		",  "MV_CH4",     "C",       06,           0,            0,           "G",      "",         "MV_PAR04", "",            "",         "",         "",         "",         "",         "",                   "",         "",         "",         "",         "",         "",         "",         "SZ3_04"  })
   aAdd(aReg,{cPerg,      "05",       "Código agente de  	",  "MV_CH5",     "C",       06,           0,            0,           "G",      "",         "MV_PAR05", "",            "",         "",         "",         "",         "",         "",                   "",         "",         "",         "",         "",         "",         "",         "SU5004"  })   
   aAdd(aReg,{cPerg,      "06",       "Código agente até  	",  "MV_CH6",     "C",       06,           0,            0,           "G",      "",         "MV_PAR06", "",            "",         "",         "",         "",         "",         "",                   "",         "",         "",         "",         "",         "",         "",         "SU5004"  })
   aAdd(aReg,{cPerg,      "07",       "Código supervisor de ",  "MV_CH7",     "C",       06,           0,            0,           "G",      "",         "MV_PAR07", "",            "",         "",         "",         "",         "",         "",                   "",         "",         "",         "",         "",         "",         "",         "SU5004"  })
   aAdd(aReg,{cPerg,      "08",       "Código supervisor até",  "MV_CH8",     "C",       06,           0,            0,           "G",      "",         "MV_PAR08", "",            "",         "",         "",         "",         "",         "",                   "",         "",         "",         "",         "",         "",         "",         "SU5004"  })
   
   aAdd(aReg,{"X1_GRUPO", "X1_ORDEM", "X1_PERGUNT",            "X1_VARIAVL", "X1_TIPO", "X1_TAMANHO", "X1_DECIMAL", "X1_PRESEL", "X1_GSC", "X1_VALID", "X1_VAR01", "X1_DEF01",    "X1_CNT01", "X1_VAR02", "X1_DEF02", "X1_CNT02", "X1_VAR03", "X1_DEF03",           "X1_CNT03", "X1_VAR04", "X1_DEF04", "X1_CNT04", "X1_VAR05", "X1_DEF05", "X1_CNT05", "X1_F3"})
   dbSelectArea("SX1")
   dbSetOrder(1)           
   For ny:=1 to len(aReg)-1
	     If !dbSeek(aReg[ny,1]+aReg[ny,2])
		       RecLock("SX1",.T.)
   		    For j:=1 to Len(aReg[ny])
	   		      FieldPut(FieldPos(aReg[Len(aReg)][j]),aReg[ny,j]) // Valorização do campo com o conteúdo do array.
       		Next j
	       	MsUnlock()
   	  EndIf
   Next ny

   // Restaura índices.
   RestArea(aAreaSX1)
   RestArea(aAreaAnt)
Return NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³UPDZZU   ºAutor  ³Leandro Nishihata  º Data ³  21/12/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³' CRIA TABELA ZZU										 	  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ cs                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function UPDZZU()
	Local cModulo := 'FAT'
	Local bPrepar := {|| U_CRIAZZU() }
	Local nVersao := 1.0
	 Private aSX2 := {}
	 Private aSX3 := {}
	 Private aSIX := {}
	
	NGCriaUpd(cModulo,bPrepar,nVersao)
	
Return
user function CRIAZZU()

	//Local aSXB := {}	
	
	
	AAdd(aSX2,{'ZZU',;                             //Alias
	           '',;                                //Path
	           'PARCEIROS X CONTATO',; //Nome
	           'PARCEIROS X CONTATO',; //Nome esp.
	           'PARCEIROS X CONTATO',; //Nome inglês
	           'C',;                               //Modo
	           '',;                                //Único
	           '',;                                //Modo unidade.
	           'C'})	                           //Modo empresa.	
	
AAdd(aSX3,{"ZZU","01","ZZU_FILIAL","C", 2,0,"Filial"      ,"Sucursal"    ,"Branch"      ,"Filial do Sistema"        ,"Sucursal"                 ,"Branch of the System"     ,"@!",""              ,"€€€€€€€€€€€€€€€",""                             ,"",1,"þÀ","","","U","N","A","R","" ,"",""           ,""         ,""           ,"","","","033","","" ,"","","" ,"N","N","",""})
AAdd(aSX3,{"ZZU","02","ZZU_CODIGO","C", 8,0,"CODIGO","CODIGO","CODIGO","CODIGO DO REGISTRO","CODIGO DO REGISTRO","CODIGO DO REGISTRO","@!",""													 ,"€€€€€€€€€€€€€€ ","GETSXENUM('ZZU','ZZU_CODIGO')","",0,"þÀ","","","U","N","V","R","" ,"",""           ,""         ,""           ,"","","","","","","","" ,"" ,"N","N","",""})
AAdd(aSX3,{"ZZU","03","ZZU_CODAR","C", 6,0,"cod. AR","cod. AR","cod. AR","codigo AR","codigo AR","codigo AR","@!","","€€€€€€€€€€€€€€ ","","",0,"þÀ","","","U","S","V","R","","","","","","","","","","","","","","","N","N","",""})
AAdd(aSX3,{"ZZU","04","ZZU_AR","C", 200,0,"AR","AR","AR","Autoridade de Registro","Autoridade de Registro","Autoridade de Registro","@!","u_VTMK001A('2')","€€€€€€€€€€€€€€ ","IF(!INCLUI,POSICIONE('SZ3',1,XFILIAL('SZ3')+ZZU->ZZU_CODAR,'Z3_DESENT'),'')","",0,"þÀ","","","U","S","A","V","","","","","","","","POSICIONE('SZ3',1,XFILIAL('SZ3')+ZZU->ZZU_CODAR,'Z3_DESENT')","","","","","","N","N","N","","","",""})
AAdd(aSX3,{"ZZU","05","ZZU_FERRAM","C", 2,0,"FERRAMENTA","FERRAMENTA","FERRAMENTA","FERRAMENTA","FERRAMENTA","FERRAMENTA","","","€€€€€€€€€€€€€€ ","","",0,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","N","N","N","","","",""})
AAdd(aSX3,{"ZZU","06","ZZU_CODPA","C", 6,0,"Cod. PA","Cod. PA","Cod. PA","codigo PA","codigo PA","codigo PA","","","€€€€€€€€€€€€€€ ","","",0,"þÀ","","","U","S","V","R","","","","","","","","","","","","","","N","N","N","","","",""})
AAdd(aSX3,{"ZZU","07","ZZU_PA","C", 200,0,"PA","PA","PA","POSTO DE ATENDIMENTO","POSTO DE ATENDIMENTO","POSTO DE ATENDIMENTO","@!","u_VTMK001A('1')","€€€€€€€€€€€€€€ ","IF(!INCLUI,POSICIONE('SZ3',1,XFILIAL('SZ3')+ZZU->ZZU_CODPA,'Z3_DESENT'),'')","",0,"þÀ","","","U","S","A","V","","","","","","","","POSICIONE('SZ3',1,XFILIAL('SZ3')+ZZU->ZZU_CODPA,'Z3_DESENT')","","","","","","N","N","N","","","",""})
AAdd(aSX3,{"ZZU","08","ZZU_CODAGE","C", 6,0,"cod. agente","cod. agente","cod. agente","codigo do agente","codigo do agente","codigo do agente","","","€€€€€€€€€€€€€€ ","","SU5004",0,"þÀ","","","U","S","V","R","","","","","","","","","","","","","","N","N","N","","","",""})
AAdd(aSX3,{"ZZU","09","ZZU_AGENTE","C", 100,0,"AGENTE","AGENTE","AGENTE","AGENTE","AGENTE","AGENTE","@!","u_VTMK001B('1')","€€€€€€€€€€€€€€ ","IF(!INCLUI,POSICIONE('SU5',1,XFILIAL('SU5')+ZZU->ZZU_CODAGE,'U5_CONTAT'),'')","",0,"þÀ","","","U","S","A","V","","","","","","","","POSICIONE('SU5',1,XFILIAL('SU5')+ZZU->ZZU_CODAGE,'U5_CONTAT')","","","","","","N","N","N","","","",""})
AAdd(aSX3,{"ZZU","10","ZZU_AGMAIL","C", 200,0,"EMAIL AGENTE","EMAIL AGENTE","EMAIL AGENTE","EMAIL AGENTE","EMAIL AGENTE","EMAIL AGENTE","@!","","€€€€€€€€€€€€€€ ","IF(!INCLUI,POSICIONE('SU5',1,XFILIAL('SU5')+ZZU->ZZU_CODAGE,'U5_EMAIL'),'')","",0,"þÀ","","","U","S","V","V","","","","","","","","POSICIONE('SU5',1,XFILIAL('SU5')+ZZU->ZZU_CODAGE,'U5_EMAIL')","","","","","","N","N","N","","","",""})
AAdd(aSX3,{"ZZU","11","ZZU_CODSUP","C", 6,0,"cod. Superv","cod. Superv","cod. Superv","Codigo do supervisor","Codigo do supervisor","Codigo do supervisor","@!","","€€€€€€€€€€€€€€ ","","SU5004",0,"þÀ","","","U","S","V","R","","","","","","","","","","","","","","N","N","N","","","",""})
AAdd(aSX3,{"ZZU","12","ZZU_SUPERV","C", 100,0,"SUPERVISOR","SUPERVISOR","SUPERVISOR","SUPERVISOR","SUPERVISOR","SUPERVISOR","@!","u_VTMK001B('2')","€€€€€€€€€€€€€€ ","IF(!INCLUI,POSICIONE('SU5',1,XFILIAL('SU5')+ZZU->ZZU_CODSUP,'U5_CONTAT'),'')","",0,"þÀ","","","U","S","A","V","","","","","","","","POSICIONE('SU5',1,XFILIAL('SU5')+ZZU->ZZU_CODSUP,'U5_CONTAT')","","","","","","N","N","N","","","",""})
AAdd(aSX3,{"ZZU","13","ZZU_SUMAIL","C", 200,0,"EMAIL SUPERV","EMAIL SUPERV","EMAIL SUPERV","EMAIL SUPERVISOR","EMAIL SUPERVISOR","EMAIL SUPERVISOR","@!","","€€€€€€€€€€€€€€ ","IF(!INCLUI,POSICIONE('SU5',1,XFILIAL('SU5')+ZZU->ZZU_CODSUP,'U5_EMAIL'),'')","",0,"þÀ","","","U","S","V","V","","","","","","","","POSICIONE('SU5',1,XFILIAL('SU5')+ZZU->ZZU_CODSUP,'U5_EMAIL')","","","","","","N","N","N","","","",""})
AAdd(aSX3,{"ZZU","14","ZZU_CODBKP","C", 6,0,"cod.bkp sup","cod.bkp sup","cod.bkp sup","codigo do bkp do supervis","codigo do bkp do supervis","codigo do bkp do supervis","@!","","€€€€€€€€€€€€€€ ","","SU5004",0,"þÀ","","","U","S","V","R","","","","","","","","","","","","","","N","N","N","","","",""})
AAdd(aSX3,{"ZZU","15","ZZU_BKPSUP","C", 100,0,"BKP Supervis","BKP Supervis","BKP Supervis","BACKUP SUPERVISOR","BACKUP SUPERVISOR","BACKUP SUPERVISOR","@!","u_VTMK001B('3')","€€€€€€€€€€€€€€ ","IF(!INCLUI,POSICIONE('SU5',1,XFILIAL('SU5')+ZZU->ZZU_CODBKP,'U5_CONTAT'),'')","",0,"þÀ","","","U","S","A","V","","","","","","","","POSICIONE('SU5',1,XFILIAL('SU5')+ZZU->ZZU_CODBKP,'U5_CONTAT')","","","","","","N","N","N","","","",""})
AAdd(aSX3,{"ZZU","16","ZZU_BKMAIL","C", 200,0,"Mail BKP sup","Mail BKP sup","Mail BKP sup","EMAIL BACKUP SUPERVISOR","EMAIL BACKUP SUPERVISOR"," EMAIL BACKUP SUPERVISOR","@!","","€€€€€€€€€€€€€€ ","IF(!INCLUI,POSICIONE('SU5',1,XFILIAL('SU5')+ZZU->ZZU_CODSUP,'U5_EMAIL'),'')","",0,"þÀ","","","U","S","V","V","","","","","","","","POSICIONE('SU5',1,XFILIAL('SU5')+ZZU->ZZU_CODSUP,'U5_EMAIL')","","","","","","N","N","N","","","",""})
AAdd(aSX3,{"ZZU","17","ZZU_TELAGE","C", 200,0,"Tel Agente  ","Tel Agente  ","Tel Agente  ","Telefone Agente","Telefone Agente","Telefone Agente","@!",""            ,"€€€€€€€€€€€€€€ ","IF(!INCLUI,POSICIONE('SU5',1,XFILIAL('SU5')+ZZU->ZZU_CODSUP,'U5_EMAIL'),'')","",0,"þÀ","","","U","S","V","V","","","","","","","","POSICIONE('SU5',1,XFILIAL('SU5')+ZZU->ZZU_CODSUP,'U5_EMAIL')","","","","","","N","N","N","","","",""})
AAdd(aSX3,{"ZZU","18","ZZU_TELSUP","C", 200,0,"Tel Superv  ","Tel Superv  ","Tel Superv  ","Telefone Supervisor","Telefone Supervisor","Telefone Supervisor","@!","","€€€€€€€€€€€€€€ ","IF(!INCLUI,POSICIONE('SU5',1,XFILIAL('SU5')+ZZU->ZZU_CODSUP,'U5_EMAIL'),'')","",0,"þÀ","","","U","S","V","V","","","","","","","","POSICIONE('SU5',1,XFILIAL('SU5')+ZZU->ZZU_CODSUP,'U5_EMAIL')","","","","","","N","N","N","","","",""})
AAdd(aSX3,{"ZZU","19","ZZU_TELBKP","C", 200,0,"Tel Bkp SUP ","Tel Bkp SUP ","Tel Bkp SUP ","Tel Bkp SUP ","Tel Bkp SUP ","Tel Bkp SUP ","@!",""                     ,"€€€€€€€€€€€€€€ ","IF(!INCLUI,POSICIONE('SU5',1,XFILIAL('SU5')+ZZU->ZZU_CODSUP,'U5_EMAIL'),'')","",0,"þÀ","","","U","S","V","V","","","","","","","","POSICIONE('SU5',1,XFILIAL('SU5')+ZZU->ZZU_CODSUP,'U5_EMAIL')","","","","","","N","N","N","","","",""})



AAdd(aSIX,{"ZZU","1","ZZU_FILIAL+ZZU_CODIGO","CODIGO","CODIGO","CODIGO","U","S"})
AAdd(aSIX,{"ZZU","2","ZZU_FILIAL+ZZU_CODAR","cod. AR","cod. AR","cod. AR","U","S"})
AAdd(aSIX,{"ZZU","3","ZZU_FILIAL+ZZU_CODAGE","cod. agente","cod. agente","cod. agente","U","S"})
AAdd(aSIX,{"SU5","D","U5_FILIAL+U5_CPF+U5_CONTAT+U5_FUNCAO+U5_STATUS","CPF+Nome+Cargo+Cadastro","CPF+Nombre+Puesto+Archivo","CPF+Nombre+Puesto+Archivo","U","SU51","S"})

AAdd(aSXB,{"SU5004","1","01","DB","CONTATO","CONTATO","CONTATO","SU5",""})
AAdd(aSXB,{"SU5004","2","01","02","Nome","Nombre","Name","",""})
AAdd(aSXB,{"SU5004","4","01","01","Contato","Contacto","Contact","U5_CODCONT",""})
AAdd(aSXB,{"SU5004","4","01","02","Nome","Nombre","Name","U5_CONTAT",""})
AAdd(aSXB,{"SU5004","5","01","","","","","SU5->U5_CODCONT",""})
AAdd(aSXB,{"SU5004","5","02","","","","","SU5->U5_CONTAT",""})
AAdd(aSXB,{"SU5004","5","03","","","","","SU5->U5_EMAIL",""})
AAdd(aSXB,{"SU5004","6","01","","","","","SU5->U5_ATIVO = '1'  .AND. SU5->U5_STATUS = ' '  .AND. SU5->U5_CONTAT <> ' '",""})

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TMK001BUSCATEL   ºAutor  ³Leandro Nishihata  º            º±±
±±º Data ³  08/05/17     												  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³' PREENCHE CAMPO TELEFONE       						 	  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ cs                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER FUNCTION VTMK001C(CAMPO)
Local RET
	RET:= TMK001BUSCATEL(CAMPO)

RETURN RET

STATIC FUNCTION TMK001BUSCATEL(CAMPO)

Local DDD := ""
Local FONE := ""
Local CELULAR := ""
Local FAX := ""
Local FCOM1 := ""
Local FCOM2 := ""
Local RET := ""

IF LEFT(CAMPO,3) = ('ZZU')
	CAMPO := &("zzu->"+CAMPO)
ENDIF


DDD := alltrim(POSICIONE('SU5',1,XFILIAL('SU5')+CAMPO,'U5_DDD'))

if !empty(ddd) 
	DDD := "("+right(ddd,2)+") "
endif
FONE := if(alltrim(su5->U5_FONE) = "" ,"",alltrim(su5->U5_FONE)+" / ")
CELULAR := if(alltrim(su5->U5_CELULAR) = "" ,"",alltrim(su5->U5_CELULAR)+" / ")
FAX := if(alltrim(su5->U5_FAX) = "" ,"",alltrim(su5->U5_FAX)+" / ")
FCOM1 := if(alltrim(su5->U5_FCOM1) = "" ,"",alltrim(su5->U5_FCOM1)+" / ")
FCOM2 := if(alltrim(su5->U5_FCOM2) = "" ,"",alltrim(su5->U5_FCOM2)+" / ")
	

RET := DDD+FONE+CELULAR+FAX+FCOM1+FCOM2
RET := if(!empty(RET),substr(RET,1,len(RET)-2),RET)

RETURN RET
