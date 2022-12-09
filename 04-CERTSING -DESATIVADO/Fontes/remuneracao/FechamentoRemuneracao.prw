#include 'protheus.ch'
#include 'FechamentoRemuneracao.ch'

/**
* Fun��o de Usu�rio respons�vel por apresentar a tela de FormBatch para o 
* usu�rio, contendo o Log de Processamento, par�metros para execu��o da rotina
* e tela para visualiza��o dos registros dispon�veis na base de dados.
*
* @user_function   	CRPA079
* @param    		null
* @return   		null
* @version  		1.0
* @date     		17/08/2020
*
**/
User Function CRPA079()

	Local aSays 	:= {}
	Local aButtons 	:= {}
	Local aPerg		:= {}
	Local lOk		:= .F.
	Local lExit		:= .F.
	Local aRet		:= {}
	Local oFechamento := Nil
	Local lGeraAuto		:= GetNewPar("MV_XFCHAUTO",.F.)
	Local lVisualGrid	:= GetNewPar("MV_XFCHEDIT",.F.)
	
	/* Perguntas para montagem do Parambox 	*/
	/* Tipo 6: Busca de Arquivo 			*/
	/* Tipo 4: Checkbox com valor l�gico 	*/
	aAdd(aPerg, {6, STR0001, Space(120), "", "", "", 50, .F., }) 
	If lGeraAuto
		aAdd(aPerg, {4, STR0003, .F.,"",90,"",.F.})
	EndIf
	
	/* Mensagem para apresenta��o no FormBatch */
	aAdd(aSays,"          ==== IMPORTA��O DE ARQUIVO CONSOLIDADO DE FECHAMENTO ====")
	aAdd(aSays,"Esta rotina realiza a importa��o dos valores consolidados a serem repassados aos ")
	aAdd(aSays,"parceiros a partir do c�lculo e fechamento realizado na nova ferramenta de c�lculo ")
	aAdd(aSays,"de Remunera��o de Parceiros.")
	aAdd(aSays,"Ao t�rmino do processamento ser� gerado um relat�rio contendo as informa��es  ")
	aAdd(aSays,"referentes aos pedidos e medi��es geradas para os respectivos parceiros.")
	
	/* Inclui o bot�o de Log no FormBatch */
	ProcLogIni(aButtons)
	
	/* Inclui os demais bot�es com fun��es */
	aAdd(aButtons,{5, .T., {|| ParamBox(aPerg, "Par�metros", aRet)}})
	aAdd(aButtons,{11,.T., {|| Iif(lVisualGrid,CRPA079Vis(), U_CRPA031()) }})
	aAdd(aButtons,{1, .T., {|| Iif(Len(aRet) >= 1,(lOk := .T., FechaBatch()), Alert( DecodeUTF8(ALERT0001) ) )}})
	aAdd(aButtons,{2, .T., {|| lExit := .T., lOk := .F., FechaBatch() }})

	/* Permanece no programa at� que o usu�rio cancele */
	While !lExit

		/* Apresenta a FormBatch */
		FormBatch(DecodeUTF8(FORMBATCH_TITULO), aSays, aButtons, , 240)

		/* Checagem de garantia do arquivo e apenas se o usu�rio clicou em Ok */
		If lOk .And. !Empty(aRet[1])

			/* Garantir a exist�ncia do Arquivo */
			If File(aRet[1])

				/* Log FormBatch */
				ProcLogAtu("INICIO")

				/* Instancia a classe FechamentoRemuneracao e chama o m�todo processaArquivo */
				/* com o arquivo informado pelo usu�rio no Parambox */
				oFechamento := FechamentoRemuneracao():New()
				Processa({|| oFechamento:processaArquivo(aRet[1], Iif(Len(aRet) > 1, aRet[2], Nil))}, "Processando arquivo selecionado", "Aguarde", .F.)
				
				/* Log FormBatch */
				ProcLogAtu("FIM")

				/* Mensagem para informar fim do processamento */
				MsgInfo( DecodeUTF8(ALERT0002) )

				/* Reseta a vari�vel para evitar que seja reprocessado ao clicar no bot�o Cancelar. */
				lOk := .F.
			Else
				/* Encerra o processamento caso o arquivo n�o exista */
				MsgStop( DecodeUTF8(ALERT0003) )
				Return .F.
			EndIf
		EndIf

		ProcLogIni()

	EndDo

Return

/**
* Classe FechamentoRemuneracao respons�vel pelo encerramento da Remunera��o de
* Parceiros dentro de um per�odo. Cont�m as funcionalidades espec�ficas para
* importa��o dos registros provenientes do BI; para gera��o da Medi��o do 
* Contrato vinculado ao fornecedor parceiro e para gera��o do Pedido de Compra
* respons�vel pela emiss�o da NF de Entrada para pagar a remunera��o.
*
* @class   FechamentoRemuneracao
* @version  1.0
* @date     11/08/2020
*
**/
Class FechamentoRemuneracao 

	Data oArquivo
	Data nTotalLinhas

	Method new() constructor
	Method processaArquivo(cArquivo) 
	Static Method abreControleVisual()

EndClass

/**
* M�todo construtor vazio.
*
* @method   new
* @param    null
* @return   null
* @version  1.0
* @date     11/08/2020
*
**/
Method new() class FechamentoRemuneracao
Return

/**
* M�todo respons�vel por processar o arquivo e direcionar o processamento
* de acordo com o passo de gera��o do Pedido de Compra. As etapas de 
* processamento s�o:
* 1 - Abertura e instancia��o dos objetos do arquivo consolidado;
* 2 - Grava��o dos registros na tabela ZZ6;
* 3 - Gera��o da Medi��o e/ou Pedido de Compra para o Parceiro;
* 4 - Grava��o dos Logs de Processamento
*
* @method   processaArquivo
* @param    cArquivo 	Nome e caminho completos do arquivo a ser processado
* @param    lGeraPedido	Flag que indica se a Medi��o/Pedido dever� ser gerado ap�s
						a importa��o dos registros para a tabela ZZ6 
* @return   null
* @version  1.0
* @date     11/08/2020
*
**/
Method processaArquivo(cArquivo, lGeraPedido) class FechamentoRemuneracao

	Local Ni 		:= 0
	Local oLog		:= Nil
	Local aLogSaved	:= {"MENSAGEM"	,"Dados importados com sucesso."				,{}}
	Local aLogErroP	:= {"ERRO"		,"N�o foi poss�vel gerar a Medi��o/Pedido."		,{}}
	Local aLogErroS	:= {"ERRO"		,"N�o foi poss�vel salvar os dados do Parceiro.",{}}
	Local aLogGener := {"MENSAGEM"	,"Medi��es/Pedidos gerados com sucesso."		,{}}

	DEFAULT lGeraPedido := .F.
	
	/* Instancia a classe ArquivoConsolidadoRemuneracao que contem as informa��es */
	/* provenientes do BI sobre os valores consolidados de Remunera��o */
	::oArquivo := ArquivoConsolidadoRemuneracao():New(cArquivo)

	/* Recupera o total de Linhas do Arquivo */
	::nTotalLinhas := Len(::oArquivo:aLinhas)
	
	/* Instancio Objeto Log respons�vel por gerar o log de processamento em Excel */
	oLog := Log():New()
	oLog:setHeader(ConsolidadoRemuneracao():toArrayHeader())

	/* Define o n�mero de registros que ser�o processados para r�gua de incremento visual */
	ProcRegua(::nTotalLinhas)
	
	/* Cada objeto do Array � uma inst�ncia de ConsolidadoRemuneracao */
	For Ni := 1 To Len(::oArquivo:aLinhas)
	
		/* Incrementa r�gua */
		IncProc()
	
		/* Persiste o objeto na tabela ZZ6 */
		If ::oArquivo:aLinhas[Ni]:save()
		
			/* Grava mensagem de sucesso de importa��o para log */
			aAdd(aTail(aLogSaved), DecodeUTF8(SUCESSO_IMPORTA) )
		
			/* Verifica se deve gerar as Medi��es/Pedidos */
			If lGeraPedido

				/* Chama o m�todo geraPedido do objeto ConsolidadoRemuneracao */
				::oArquivo:aLinhas[Ni]:geraPedido()

				/* Quando o pedido � gerado corretamente, a propriedade cPedido */
				/* no objeto ConsolidadoRemuneracao ser� preenchida com o n�mero */
				/* do Pedido de Compra no Protheus */
				If !Empty(::oArquivo:aLinhas[Ni]:cPedido)

					/* Grava mensagem de Log de sucesso na gera��o do Pedido */
					aAdd(aTail(aLogGener), DecodeUTF8(SUCESSO_PEDIDO) )
					oLog:addLog(::oArquivo:aLinhas[Ni]:toArray( DecodeUTF8(SUCESSO_PEDIDO) ))

				Else

					/* Grava mensagem de Log com falha na gera��o do Pedido */
					aAdd(aTail(aLogErroP), DecodeUTF8(FALHA_PEDIDO) )

					/* Inclui a linha inteira no objeto oLog para gera��o em Excel */
					oLog:addLog(::oArquivo:aLinhas[Ni]:toArray( DecodeUTF8(FALHA_PEDIDO) ))

				EndIf
			EndIf
			
		Else
			/* Grava mensagem de falha na importa��o do registro */
			aAdd(aTail(aLogErroS), DecodeUTF8(FALHA_IMPORTA) )
			oLog:addLog(::oArquivo:aLinhas[Ni]:toArray( DecodeUTF8(FALHA_IMPORTA) ))
		EndIf
		
	Next
	
	/* Trata Log para Importa��o dos dados com Sucesso */
	gravaLogCtb(aLogSaved)

	/* Trata Log para Gera��o correta de Medi��o/Pedido */
	gravaLogCtb(aLogGener)

	/* Trata Log para Erros de Importa��o de Registros */
	gravaLogCtb(aLogErroS)

	/* Trata Log para Erros na Gera��o da Medi��o/Pedido */
	gravaLogCtb(aLogErroP)

	/* Descarrega o objeto oLog para Excel */
	oLog:dumpToExcel()
	
Return

/**
* Fun��o est�tica respons�vel por apresentar a tela de manuten��o dos registros
* importados para a tabela ZZ6. Esta tela tem como objetivo manutencionar linhas
* que porventura tenham falhado � integra��o ou gera��o de medi��o/pedido, bem
* como fornecer ao usu�rio uma interface amig�vel com as informa��es referentes 
* aos dados dos parceiros. Tamb�m possibilita a impress�o dos registros em formato
* de relat�rio de confer�ncia. 
*
* @function CRPA079Vis
* @param    null
* @return   null
* @version  1.0
* @date     11/08/2020
*
**/
Static Function CRPA079Vis() 

	Local aPerg			:= {}
	Local nMesAnt		:= Month(dDataBase) - 1 //Subtrai o m�s para verificar se o anterior � dezembro
	Local cPeriodo 		:= ""

	Private aRet	:= {}

	/* Tratamento para pegar o per�odo anterior */
	If nMesAnt == 0
		/* Subtrai o ano para Dezembro */
		cPeriodo := cValToChar(Year(dDataBase) - 1) + "12" 
	Else
		/* Demais meses, considera m�s imediatamente anterior */
		cPeriodo := cValToChar(Year(dDatabase)) + StrZero(Month(DDATABASE) - 1, 2) 
	EndIf

	/* Pergunta para Parambox - Per�odo para apresenta��o de dados. */
	/* Por default, vem preenchido o fechamento corrente. */
	aAdd(aPerg, {1, "Per�odo:", cPeriodo, "@!", "", "", "", 50, .T.})

	/* Apresenta o Parambox para confirma��o do per�odo */
	If ParamBox(aPerg, "Informe o per�odo de fechamento", @aRet,,,,,,,,.F.,.F.)

		/* Carrega as informa��es visuais */
		FechamentoRemuneracao():abreControleVisual()
	
	EndIf

Return

/**
* M�todo est�tico respons�vel por carregar a interface visual de apresenta��o
* dos dados de Remunera��o ao usu�rio.
*
* @method   abreControleVisual
* @param    null
* @return   null
* @version  1.0
* @date     11/08/2020
*
**/
Static Method abreControleVisual() Class FechamentoRemuneracao

	Local cTitulo    := 'Fechamento Remunera��o - Registros Consolidados Importados.'
	
	Local aC         := {}
	Local aBtn       := {}
	Local aAcoes     := {}
	Local aTam_Tit   := {}
	Local aNodes	 := {}
	
	Local nI         := 0
	
	Local oDlg
	Local oWin1
	Local oWin2
	Local oFWLayer
	Local oSplitter
	Local oPnl1
	
	/* Blocos de C�digo para execu��o ao clicar nos objetos visuais */
	Local bMarkAll   	:= { || FR079Mark(.T.) }
	Local bClearAll  	:= { || FR079Mark(.F.) }
	Local bMarkAllSaldo := { || FR079Mark(.T.,.T.) }
	Local bGerar		:= { || FR079Gerar() }
		
	Private aEntidades 	:= {}
	Private nColAux  	:= 0
	Private oMrk     	:= LoadBitmap(,'NGCHECKOK.PNG')
	Private oNoMrk   	:= LoadBitmap(,'NGCHECKNO.PNG')
	Private oOK		 	:= LoadBitmap(GetResources(),"br_verde")
	Private oNO		 	:= LoadBitmap(GetResources(),"br_vermelho")
	Private lMarkX   	:= .T.
	Private oLbx1
	Private aHead_Tit  	:= {}

	aNodes := CR079Nodes()

	/* Array com campos que servir�o de base para a estrutura visual */
	aCpoCli := {'','','ZZ6_CODAC','ZZ6_CODENT','ZZ6_DESENT','ZZ6_QTDPED','ZZ6_SALDO','ZZ6_SALDO','ZZ6_DTIMP','ZZ6_ARQUIV'}
	
	/* Define o tamanho fixo das colunas */
	aTam_Tit := {10,10,30,30,100,30,30,40,40,30,100}
	
	/* Defini��o do titulo das colunas. */
	aHead_Tit := { 	' ', ' ',;
				'AC',;
				'Cod. Parc.',; 
				'Desc. Parceiro',; 
				'Qtd. Ped.',;
				'Ped. Compra',;
				'Saldo',;
				'Valor Total',;
				'Dt. Import.',;
				'Arquivo'}
	
	/* Defini��o dos bot�es. */
	AAdd( aAcoes ,{ 'Gerar Medi��o/Pedido'		,'{|| Proc2BarGauge(bGerar,"Gerando Medi��o/Pedido","Aguarde a Gera��o das Medi��es/Pedidos.") }'  } )
	aAdd( aAcoes, { 'Estorna Medi��o/Pedido'	,'{|| U_C079Details(oLbx1:aArray[oLbx1:nAt]) }'})
	AAdd( aAcoes ,{ 'Imprimir Tela'				,'{|| Nil }'} )
	AAdd( aAcoes ,{ 'Sair'            			,'{|| oDlg:End() }' } )
	
	
	//-- Defini��o das a��es da teclas de atalho.
	SetKey( VK_F9   ,&(aAcoes[1,2]) )
	SetKey( VK_F10  ,&(aAcoes[2,2]) )
	SetKey( VK_F11  ,&(aAcoes[3,2]) )
	SetKey( VK_F12  ,&(aAcoes[4,2]) )
	
	//SetKey( VK_F12 ,{|| C059Param() } ) //Apontar para par�metro de Per�odo
	
	// [1] - propriedade do objeto
	// [2] - t�tulo do bot�o
	// [3] - fun��o a ser executada quando acionado o bot�o
	// [4] - texto explicativo da funcionalidade da rotina
	AAdd( aBtn ,{ NIL ,aAcoes[1,1] ,aAcoes[1,2] ,'<F9> Gerar Medi��o/Pedido.'		} )
	AAdd( aBtn ,{ NIL ,aAcoes[2,1] ,aAcoes[2,2] ,'<F10> Estornar.' 		  			} )
	AAdd( aBtn ,{ NIL ,aAcoes[3,1] ,aAcoes[3,2] ,'<F11> Imprimir Tela.'   			} )
	AAdd( aBtn ,{ NIL ,aAcoes[4,1] ,aAcoes[4,2] ,'<F12> Sair da rotina.'   			} )	
		
	aC := FWGetDialogSize( oMainWnd )
	
	/* Cria��o da tela */
	DEFINE DIALOG oDlg TITLE '' OF oMainWnd FROM aC[1],aC[2] TO aC[3], aC[4] PIXEL STYLE nOr(WS_VISIBLE,WS_POPUP)
		
		/* Desabilita fechar a tela com ESC */
		oDlg:lEscClose := .F.

		/* Cria Layer para sobrepor com componentes visuais */
		oFWLayer := FWLayer():New()
		
		oFWLayer:Init( oDlg, .F. )
		
		oFWLayer:AddCollumn( 'Col01', 20, .T. ) //Estrutura de �rvore e menus
		oFWLayer:AddCollumn( 'Col02', 80, .F. ) //MarkBrowse
		
		oFWLayer:SetColSplit( 'Col01', CONTROL_ALIGN_RIGHT,, {|| .T. } )
		
		oFWLayer:AddWindow('Col01','Win01','A��es' ,100,.F.,.F.,/*bAction*/,/*cIDLine*/,/*bGotFocus*/) //Janela esquerda
		oFWLayer:AddWindow('Col02','Win02',cTitulo ,100,.F.,.T.,/*bAction*/,/*cIDLine*/,/*bGotFocus*/) //Janela direita
		
		oWin1 := oFWLayer:GetWinPanel('Col01','Win01')
		oWin2 := oFWLayer:GetWinPanel('Col02','Win02')
		
		/* Cria divis�ria */
		oSplitter := TSplitter():New( 1, 1, oWin2, 1000, 1000, 1 ) 
		oSplitter:Align := CONTROL_ALIGN_ALLCLIENT
		
		/* Cria painel para componentes */
		oPnl1:= TPanel():New(1,1,' Painel 01',oSplitter,,,,,/*CLR_YELLOW*/,60,60)		
		oPnl1:Align := CONTROL_ALIGN_ALLCLIENT
		
		oPnl2:= TPanel():New(1,1,' Painel 02',oWin1,,,,,/*CLR_YELLOW*/,60,100)		
		oPnl2:Align := CONTROL_ALIGN_BOTTOM			

		oPnl3:= TPanel():New(1,1,' Painel 03',oWin1,,,,,/*CLR_YELLOW*/,60,200)		
		oPnl3:Align := CONTROL_ALIGN_TOP		
				
		/* Componente de �rvore para sele��o das Entidades do Sistema */
		oTree := DBTree():New(1,1,200,125,oPnl3,,, .T., .F., , )
		oTree:Align := CONTROL_ALIGN_TOP
		oTree:lShowHint := .F.
		oTree:bLClicked := {|| MsgRun("Executando consulta dos dados. Por gentileza, aguarde.","Fechamento C�lculo",{||CR079Array(oTree)}) }
		
		/* Define os ramos da �rvore de componentes */
		oTree:PTSendTree(aNodes)

		/* Cria os bot�es no painel inferior da tela */		
		For nI := 1 To Len(aBtn)
			aBtn[nI,1] := TButton():New(1,1,aBtn[nI,2],oPnl2,&(aBtn[nI,3]),50,11,,,.F.,.T.,.F.,aBtn[nI,4],.F.,,,.F.)
			aBtn[nI,1]:Align := CONTROL_ALIGN_TOP
		Next nI
			
	   /* Cria o Browse com as linhas da tabela ZZ6 */
	   oLbx1              := TwBrowse():New(1,1,1000,1000,,aHead_Tit,,oPnl1,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	   oLbx1:aColSizes    := aTam_Tit
	   oLbx1:Align        := CONTROL_ALIGN_ALLCLIENT
	   oLbx1:bLDblClick   := {|| FR079MrkTit() }
	   oLbx1:bHeaderClick := {|oBrw, nCol| FR079HdrClc(nCol) }
	
	   /* Chama fun��o para montar o array com os dados da tabela ZZ6 */
	   MsgRun("Executando consulta dos dados. Por gentileza, aguarde.","Fechamento C�lculo",{||CR079Array(oTree)})
	   oLbx1:Refresh()
	   oLbx1:SetFocus()
	   
	ACTIVATE DIALOG oDlg CENTERED

Return

/**
* Fun��o est�tica que alimenta o Browse de visualiza��o dos registros da tabela
* SZ6. O Objeto recebido por par�metro tem como fun��o carregar o item selecionado
* para possibilitar o filtro b�sico por tipo de entidade do Sistema.
*
* @function CR079Array
* @param    oTree	Objeto TTree com a estrutura de �rvores
* @return   array Array com a estrutura [1] Campo SC7, [2] Valor SC7
* @version  1.0
* @date     11/08/2020
*
**/
Static Function CR079Array(oTree)

	Local cQuery   := ""
	Local cTmp     := GetNextAlias()
	
	/* Evita errorlog na primeira execu��o */
	DEFAULT oTree := Nil
	
	/* Limpa o Array */
	aEntidades := {}
	
	/* Query para capturar as linhas da ZZ6, por�m tamb�m somariza as linhas que
	   porventura existam na tabela PC5, referente a pedidos gerados para os parceiros */
	cQuery := "SELECT ZZ6_CODAC," 
	cQuery += "       ZZ6_CODENT," 
	cQuery += "       ZZ6_DESENT, "
	cQuery += "       ZZ6_QTDPED, "
	cQuery += "       ZZ6_SALDO, "
	cQuery += "       Round(ZZ6_COMTOT + ZZ6_VALFED + ZZ6_VALCAM + ZZ6_VALVIS + ZZ6_VALPOS) AS ZZ6_TOTAL," 
	cQuery += "       ZZ6_DTIMP, "
	cQuery += "		  ZZ6_ARQUIV,"
	cQuery += "		  (SELECT COUNT(*) "
	cQuery += "			FROM 	PC5010 "
	cQuery += "			WHERE 	PC5_FILIAL = ' ' "
	cQuery += "			AND 	PC5_PERIOD = ZZ6_PERIOD "
	cQuery += "			AND 	PC5_CODENT = ZZ6_CODENT "
	cQuery += "			AND 	PC5010.D_E_L_E_T_ = ' ') AS PEDIDOS,"
	cQuery += "       ZZ6.R_E_C_N_O_ RECNOZZ6 "
	cQuery += "FROM " + RetSqlName("ZZ6") + " ZZ6 "
	cQuery += "		  INNER JOIN " + RetSqlName("SZ3") + " SZ3 "
	cQuery += "				  ON Z3_FILIAL = ' ' "
	cQuery += "					 AND Z3_CODENT = ZZ6_CODENT "
	cQuery += "WHERE  ZZ6_FILIAL = '" + xFilial("ZZ6") + "'"
	cQuery += "       AND ZZ6_PERIOD = '" + aRet[1] + "'"
	cQuery += "       AND ZZ6.D_E_L_E_T_ = ' ' "
	cQuery += "		  AND SZ3.D_E_L_E_T_ = ' ' "

	/* Filtro por tipo de entidade, conforme selecionado na tela */
	If oTree != Nil
		Do Case 
			Case AllTrim(oTree:CurrentNodeId) == "ALL" .Or. Empty(AllTrim(oTree:CurrentNodeId))
				cQuery += ""
			Case AllTrim(oTree:CurrentNodeId) == "CCR"
				cQuery += "		  AND Z3_TIPENT = '9'"
			Case AllTrim(oTree:CurrentNodeId) == "ACS"
				cQuery += "		  AND Z3_TIPENT = ANY('2','5')"
			Case AllTrim(oTree:CurrentNodeId) == "PCO"
				cQuery += "		  AND Z3_TIPENT = '7'"
			Case AllTrim(oTree:CurrentNodeId) == "CAN"
				cQuery += "		  AND Z3_TIPENT = '1'"
			Case AllTrim(oTree:CurrentNodeId) == "FECO"
				cQuery += "		  AND ZZ6_CODAC LIKE 'FECO%'
			Case AllTrim(oTree:CurrentNodeId) == "FACE"
				cQuery += "		  AND ZZ6_CODAC = 'FACES'"
			Case AllTrim(oTree:CurrentNodeId) == "FENC"			
				cQuery += "		  AND ZZ6_CODAC = 'FENCR'"
			Case AllTrim(oTree:CurrentNodeId) == "SINR"			
				cQuery += "		  AND ZZ6_CODAC = 'SINRJ'"
			Case AllTrim(oTree:CurrentNodeId) ==  "SINT"					
				cQuery += "		  AND ZZ6_CODAC = 'SINITU'"
			Otherwise
				cQuery += "		  AND ZZ6_CODAC = '" + AllTrim(oTree:CurrentNodeId) + "' "
		EndCase
	EndIf

	cQuery += "	ORDER BY ZZ6_CODAC, ZZ6_DESENT, ZZ6_PERIOD"

	
	//-- Filtro retornado pela classe FWFiltewr.
	/*If !Empty(cFiltro)
		//+--------------------------------------------------------+
		//| Tratamento com o campo CC3_DESC pois existem registros |
		//| utilizando caracteres maiusculo e minisculo.           |
		//+--------------------------------------------------------+
		If "CC3_DESC" $ cFiltro
			cFiltro := StrTran(cFiltro,'CC3_DESC', 'UPPER(CC3_DESC)')
			cQuery  += " AND " + cFiltro
		Else
			cQuery  += " AND " + cFiltro
		EndIf
	EndIf*/
		
	/* Fecha inst�ncias anteriores da tabela tempor�ria */
	If Select(cTmp) > 0
		(cTmp)->(DbCloseArea())				
	EndIf
	
	/* Convers�o e Execu��o da query. */
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cTmp,.F.,.T.)
		
	/* Posiciona o retorno no topo */
	(cTmp)->(dbGoTop())
	While (cTmp)->( !Eof() )
	
		/* Carrega os dados no array para exibi��o */
		aAdd(aEntidades, { ((cTmp)->ZZ6_SALDO > 0),;  //Auxiliar para controlar luz verde ou vermelha
						 .F.,;
						 (cTmp)->ZZ6_CODAC,;										
						 (cTmp)->ZZ6_CODENT,;										
						 (cTmp)->ZZ6_DESENT,;										
						 Transform((cTmp)->ZZ6_QTDPED, "@E 999,999,999"),;
						 Transform((cTmp)->PEDIDOS, "@E 999,999,999"),;
						 Transform((cTmp)->ZZ6_SALDO , "@E 999,999,999.99"),;
						 Transform((cTmp)->ZZ6_TOTAL , "@E 999,999,999.99"),;
						 DTOC(STOD((cTmp)->ZZ6_DTIMP)),;
						 (cTmp)->ZZ6_ARQUIV,;
						 (cTmp)->RECNOZZ6})

		(cTmp)->( DbSkip() )
	EndDo
	
	/* Garante a linha vazia, caso n�o haja retorno */
	If Len(aEntidades) == 0
		AAdd( aEntidades, {.F., .F., "", "", "", 0, 0, 0, 0, CTOD("//"), ""} )
	EndIf
		
	/* Vincula o array ao ListBox e Define o bloco de c�digo para atualiza��o das linhas */ 
   	oLbx1:SetArray( aEntidades )
	oLbx1:bLine := { ||	{ 		Iif( aEntidades[ oLbx1:nAt, 01 ], oOK, oNO),;
								Iif( aEntidades[ oLbx1:nAt, 02 ], oMrk, oNoMrk ),;
								aEntidades[ oLbx1:nAt, 03 ],;
								aEntidades[ oLbx1:nAt, 04 ],;
								aEntidades[ oLbx1:nAt, 05 ],;
								aEntidades[ oLbx1:nAt, 06 ],;
								aEntidades[ oLbx1:nAt, 07 ],;
								aEntidades[ oLbx1:nAt, 08 ],;
								aEntidades[ oLbx1:nAt, 09 ],;
								aEntidades[ oLbx1:nAt, 10 ],;
								aEntidades[ oLbx1:nAt, 11 ],;
						} }

	/* Reseta o flag de marca��o dos registros */						
	//FC059Mark(.F.) 

Return

/**
* Fun��o de usu�rio adaptada da tela de libera��o de pedidos bloqueados por estoque/valor
* para apresentar detalhes referentes aos valores importados para o parceiro e para
* possibilitar a manuten��o das Medi��es e Pedidos de Compra gerados para os Parceiros.
*
* @method   C079Details
* @param    aLinha	Informa��es da linha posicionada na ListBox
* @return   null
* @version  1.0
* @date     11/08/2020
*
**/
User Function C079Details(aLinha)

	Local aHeader 		:= {" ","Dt Pedido","Pedido","Medicao","Contrato","S�rie","Nota Fiscal","Valor"}
	Local aCols 		:= {}
	Local oFontRed 		:= TFont():New(,,,,.T.,,,,,,)
	Local cNF			:= ""
	Local cSerie		:= ""
	Local nPosCodEnt 	:= aScan(oLbx1:aHeaders, {|x| AllTrim(x) == "Cod. Parc."})
	Local nPosDesEnt 	:= aScan(oLbx1:aHeaders, {|x| AllTrim(x) == "Desc. Parceiro"})
	Local nPosSaldo	 	:= aScan(oLbx1:aHeaders, {|x| AllTrim(x) == "Saldo"})

	Local cSaldo 		:= aLinha[nPosSaldo]
	Local cCodEnt 		:= aLinha[nPosCodEnt]
	Local cDesEnt 		:= aLinha[nPosDesEnt]

	/*Local nComisTot 	:= 0
	Local nComisSw		:= 0
	Local nComisHw		:= 0

	Local nCampTot		:= 0
	Local nCampSW		:= 0
	Local nCampHW		:= 0

	Local nFedTot		:= 0
	Local nFedSW		:= 0
	Local nFedHW		:= 0

	Local nARTot		:= 0
	Local nARSW			:= 0
	Local nARHW			:= 0

	Local nValFat		:= 0
	Local nVisita		:= 0
	Local nPosto 		:= 0
	Local nTotal		:= 0*/

	/* Posiciona nas tabelas de dados */
	dbSelectArea("ZZ6")
	ZZ6->(dbSetOrder(1)) //ZZ6_FILIAL + ZZ6_PERIOD + ZZ6_CODENT
	ZZ6->(dbSeek(xFilial("ZZ6") + aRet[1] + cCodEnt))
	
	dbSelectArea("PC5")
	PC5->(dbSetOrder(1)) //PC5_FILIAL + PC5_PERIOD + PC5_CODENT
	PC5->(dbSeek(xFilial("PC5") + aRet[1] + cCodEnt))

	dbSelectArea("SD1")
	SD1->(dbOrderNickname("PEDIDO")) //D1_FILIAL + D1_NUMPED

	If PC5->(EoF())
		aAdd(aCols,{"", CTOD("//"), "", "", "", "", "", Transform(0, "@E 999,999,999.99")})
	EndIf
	
	/* Carrega os pedidos existentes para a Entidade no per�odo */
	While PC5->(!EoF()) .And. PC5->PC5_FILIAL + PC5->PC5_PERIOD + PC5->PC5_CODENT == xFilial("PC5") + aRet[1] + cCodEnt

		/* Se houver, carrega o n�mero da NF */
		cNF := ""
		If SD1->(dbSeek(xFilial("SD1") + PC5->PC5_PEDIDO))
			cNF := SD1->D1_DOC
			cSerie := SD1->D1_SERIE
		EndIf

		/* Alimenta o aCols da ListBox */
		aAdd(aCols,{"", PC5->PC5_DTPED, PC5->PC5_PEDIDO, PC5->PC5_NUMMED, PC5->PC5_CONTRA, cSerie, cNF, Transform(PC5->PC5_VALOR, "@E 999,999,999.99")})

		PC5->(dbSkip())
	EndDo

	DEFINE MSDIALOG oDlg FROM  125,3 TO 430,608 TITLE "Rela��o de Pedidos e Detalhamento" PIXEL

	@ 003, 004  TO 065, 299 LABEL "" OF oDlg  PIXEL //Caixa Topo
	//@ 130, 004  TO 150, 155 LABEL "" OF oDlg  PIXEL //Caixa 1 Rodap�
	//@ 130, 160  TO 150, 240 LABEL "" OF oDlg  PIXEL //Caixa 2 Rodap�
	/*@ 016, 006  TO 053, 072 LABEL "" OF oDlg  PIXEL //Caixa Comiss�o
	@ 016, 077  TO 053, 145 LABEL "" OF oDlg  PIXEL //Caixa Campanha
	@ 016, 149  TO 053, 220 LABEL "" OF oDlg  PIXEL //Caixa Federa��o
	@ 016, 224  TO 053, 295 LABEL "" OF oDlg  PIXEL //Caixa AR*/

	//-- Bot�es OK e Cancelar
	DEFINE SBUTTON FROM 134, 242 TYPE 1 ACTION (nOpca := 1,oDlg:End()) ENABLE OF oDlg
	DEFINE SBUTTON FROM 134, 272 TYPE 2 ACTION oDlg:End() ENABLE OF oDlg

	//-- Bot�es Rodap� Caixa 1
/*	@ 135, 010 BUTTON "Medi��o"   	 SIZE 34,11 FONT oDlg:oFont ACTION (Alert("Medi��o"))           OF oDlg PIXEL
	@ 135, 045 BUTTON "Conhecimento" SIZE 34,11 FONT oDlg:oFont ACTION (Alert("Conhecimento") ) OF oDlg PIXEL
	@ 135, 080 BUTTON "Pedido"   	 SIZE 34,11 FONT oDlg:oFont ACTION (Alert("Pedido") ) OF oDlg PIXEL
	@ 135, 115 BUTTON "Nota Fiscal"  SIZE 34,11 FONT oDlg:oFont ACTION ( Alert("Nota Fiscal") )  OF oDlg PIXEL*/

	//-- Bot�es Rodap� Caixa 2
//	@ 135, 165 BUTTON "Estorna"   	 SIZE 34,11 FONT oDlg:oFont ACTION (nOpca := 4,oDlg:End() ) OF oDlg PIXEL
	@ 135, 200 BUTTON "Estorna"   SIZE 34,11 FONT oDlg:oFont ACTION (nOpca := 3,oDlg:End() ) OF oDlg PIXEL

	//-- Campos do cabe�alho
	@ 006, 008 SAY "C�digo:"      	 SIZE 23, 7 FONT oFontRed OF oDlg PIXEL 
	@ 006, 030 SAY cCodEnt 	         SIZE 26, 7 OF oDlg PIXEL
	@ 006, 055 SAY "Descri��o:"      SIZE 35, 7 FONT oFontRed OF oDlg PIXEL
	@ 006, 085 SAY AllTrim(cDesEnt)  SIZE 140, 7 OF oDlg PIXEL
	@ 006, 230 SAY "Saldo:"      	 SIZE 27, 7 FONT oFontRed OF oDlg PIXEL
	@ 006, 250 SAY "R$ " + cSaldo SIZE 83, 7 FONT oFontRed COLOR CLR_RED OF oDlg PIXEL 

	//-- Caixa Comiss�o
/*	@ 019, 008 SAY "Comiss�o:"      SIZE 64, 7 OF oDlg PIXEL 
	@ 018, 035 MSGET nComisTot      PICTURE "@E 999,999.99" SIZE 35, 7 OF oDlg PIXEL READONLY
	@ 030, 008 SAY "Comis.SW:"      SIZE 64, 7 OF oDlg PIXEL 
	@ 029, 035 MSGET nComisSw       PICTURE "@E 999,999.99" SIZE 35, 7 OF oDlg PIXEL READONLY	
	@ 041, 008 SAY "Comis.HW:"      SIZE 64, 7 OF oDlg PIXEL 
	@ 040, 035 MSGET nComisHw       PICTURE "@E 999,999.99" SIZE 35, 7 OF oDlg PIXEL READONLY

	//-- Caixa Campanha
	@ 019, 079 SAY "Campanha:"      SIZE 64, 7 OF oDlg PIXEL 
	@ 018, 108 MSGET nCampTot       PICTURE "@E 999,999.99" SIZE 35, 7 OF oDlg PIXEL READONLY
	@ 030, 079 SAY "Camp.SW:"       SIZE 64, 7 OF oDlg PIXEL  
	@ 029, 108 MSGET nCampSW        PICTURE "@E 999,999.99" SIZE 35, 7 OF oDlg PIXEL READONLY	
	@ 041, 079 SAY "Camp.HW:"       SIZE 64, 7 OF oDlg PIXEL  
	@ 040, 108 MSGET nCampHW        PICTURE "@E 999,999.99" SIZE 35, 7 OF oDlg PIXEL READONLY	

	//-- Caixa Federa��o
	@ 019, 152 SAY "Federa��o:"     SIZE 64, 7 OF oDlg PIXEL   
	@ 018, 183 MSGET nFedTot        PICTURE "@E 999,999.99" SIZE 35, 7 OF oDlg PIXEL READONLY
	@ 030, 152 SAY "Fed.SW:"        SIZE 64, 7 OF oDlg PIXEL   
	@ 029, 183 MSGET nFedSW         PICTURE "@E 999,999.99" SIZE 35, 7 OF oDlg PIXEL READONLY	
	@ 041, 152 SAY "Fed.HW:"        SIZE 64, 7 OF oDlg PIXEL   
	@ 040, 183 MSGET nFedHW         PICTURE "@E 999,999.99" SIZE 35, 7 OF oDlg PIXEL READONLY

	//-- Caixa AR
	@ 019, 227 SAY "Valor AR:"      SIZE 64, 7 OF oDlg PIXEL
	@ 018, 258 MSGET nARTot         PICTURE "@E 999,999.99" SIZE 35, 7 OF oDlg PIXEL READONLY
	@ 030, 227 SAY "Val AR SW:"     SIZE 64, 7 OF oDlg PIXEL
	@ 029, 258 MSGET nARSW          PICTURE "@E 999,999.99" SIZE 35, 7 OF oDlg PIXEL READONLY	
	@ 041, 227 SAY "Val AR HW:"     SIZE 64, 7 OF oDlg PIXEL
	@ 040, 258 MSGET nARHW          PICTURE "@E 999,999.99" SIZE 35, 7 OF oDlg PIXEL READONLY

	//-- Valores avulsos
	@ 055, 007 SAY "Vlr.Fat.:"      SIZE 23, 7 OF oDlg PIXEL
	@ 053.5, 026 MSGET nValFat      PICTURE "@E 999,999,999.99" SIZE 45, 7 OF oDlg PIXEL READONLY
	@ 055, 079 SAY "Val Posto:"     SIZE 64, 7 OF oDlg PIXEL
	@ 053.5, 108 MSGET nPosto       PICTURE "@E 999,999.99" SIZE 35, 7 OF oDlg PIXEL READONLY	
	@ 055, 152 SAY "Visita Ext:"    SIZE 64, 7 OF oDlg PIXEL
	@ 053.5, 183 MSGET nVisita      PICTURE "@E 999,999.99" SIZE 35, 7 OF oDlg PIXEL READONLY
	@ 055, 225 SAY "Total Geral:"   SIZE 64, 7 FONT oFontRed OF oDlg PIXEL
	@ 053.5, 258 MSGET nTotal       PICTURE "@E 999,999.99" SIZE 35, 7 OF oDlg PIXEL READONLY			*/

	//-- Montagem da ListBox
	oLbx := RDListBox(5, .5, 295, 55, aCols, aHeader,{5,30,30,30,55,20,55,50})

	ACTIVATE MSDIALOG oDlg

	If nOpc == 3
		CR079Estorna(oLbx:aCols[oLbx:nat])
	EndIf

Return

Static Function CR079Nodes()

	Local aArray := {}
	Local cQuery
	Local cAliasTmp := GetNextAlias()
	Local cCargo	:= ""
	
	cQuery :=  "SELECT Z3_CODENT,Z3_DESENT FROM "+RetSqlName("SZ3") + " WHERE Z3_TIPENT = '2' AND D_E_L_E_T_ = ' ' AND Z3_ATIVO != 'N' ORDER BY Z3_CODENT"

	If Select(cAliasTmp) > 0
		(cAliasTmp)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTmp,.F.,.T.)

	aAdd(aArray, {"00","ALL","","Todos","PMSEDT1","PMSEDT2"})
	aAdd(aArray, {"01","CCR","","CCR","PMSEDT3","PMSEDT3"})
	aAdd(aArray, {"01","ACS","","AC","PMSEDT2","PMSEDT3"})

	While (cAliasTmp)->(!EoF())

		If AllTrim((cAliasTmp)->Z3_CODENT) $ "BB|BV|CER|CNC|NAOREM|TDARED|FECOAL/FECOAM/FECOBA/FECOCE/FECODF/FECOMA/FECOMG/FECOMS/FECOMT/FECOPA/FECOPB/FECOPE/FECOPR/FECORJ/FECORN/FECORO/FECORS/FECOSC/FECOSE/FECOTO"
			(cAliasTmp)->(dbSkip())
			Loop
		EndIf

		cCargo := CR079DePara((cAliasTmp)->Z3_CODENT)

		aAdd(aArray, {"02",cCargo,"",Substr((cAliasTmp)->Z3_DESENT,1,70),"PMSEDT3","PMSEDT3"})
		
		(cAliasTmp)->(dbSkip())
	EndDo

	(cAliasTmp)->(dbCloseArea())

	aAdd(aArray, {"01","PCO","","Parceiros","PMSEDT3","PMSEDT3"})
	aAdd(aArray, {"01","CAN","","Canais","PMSEDT3","PMSEDT3"})

	/*oTree:AddItem("Todos    ", "ALL", "PMSEDT2",,,,)
	oTree:AddItem("CCR"		 , "CCR", "PMSEDT3",,,,2)
	oTree:AddTree("AC"		 , "ACS", "PMSEDT3",,,,2)
	oTree:AddItem("Parceiros", "PCO", "PMSEDT3",,,,2)	
	oTree:AddItem("Canais"	 , "CAN", "PMSEDT3",,,,2)	*/

Return aArray

Static Function CR079DePara(cCargo)

	Local cRet := ""

	Do Case
		Case cCargo $ "FECOMALL/FECOAL/FECOAM/FECOBA/FECOCE/FECODF/FECOMA/FECOMG/FECOMS/FECOMT/FECOPA/FECOPB/FECOPE/FECOPR/FECORJ/FECORN/FECORO/FECORS/FECOSC/FECOSE/FECOTO"
			cRet := "FECO"
		Case cCargo == "FACES"
			cRet := "FACE"
		Case cCargo == "FENCR"
			cRet := "FENC"			
		Case cCargo == "SINRJ"
			cRet := "SINR"			
		Case cCargo == "SINITU"
			cRet := "SINT"			
		Otherwise
			cRet := cCargo
	EndCase
	
Return cRet
/*
Static Function CP079Filtro()

	Alert("Filtro registros.")

Return
*/
/*Static Function CP079Busca()

Local oDlg, oCbx, cOrd, oBigGet
Local nSavReg, cAlias, ni, nj
Local cCpofil, dCampo
Local nOrd    := 1
Local lSeek   := .F.
Local aLista  := {}
Local bSav12  := SetKey(VK_F12)
Local cCampo  := Space(60)

Local lDetail := .F.
Local lUseDetail := .T.
Local aAllLista
Local oDetail
Local aMyOrd	:= {}
Local aScroll	:= {}
Local lSeeAll   := GetBrwSeeMode()
Local aPesqVar  := {}
Local cVar
Local bBloco
Local cMsg := ""
Local oPPreview
Local oList
Local aList    := {}
Local lMenuDef := ( ProcName(1) == "MBRBLIND" ) .Or. RunInMenuDef()
Local lPreview := .F.
Local nRet     := 0

Private aOrd     := {}*/

/*/
aLista
[1] := F3
[2] := tipo
[3] := tamanho
[4] := decimais
[5] := titulo
/*/

/*SetKey(VK_F12,{|| NIL})

nSavReg := oLbx:nLine

AxPesqOrd(cAlias,@aMyOrd,@lUseDetail,lSeeAll)

aAdd(aOrd, {"C�d. Parceiro + Desc. Parceiro"})
aAdd(aOrd, {"Desc. Parceiro"})

DEFINE MSDIALOG oDlg FROM 00,00 TO 100,490 PIXEL TITLE "Busca" 

@05,05 COMBOBOX oCBX VAR cOrd ITEMS aOrd SIZE 206,36 PIXEL OF oDlg FONT oDlg:oFont

@22,05 MSGET oBigGet VAR cCampo SIZE 206,10 PIXEL

If ( lUseDetail )
	@22,05 MSPANEL oPPreview SIZE 205,84 OF oDlg
	oPPreview:Hide()
	DEFINE SBUTTON oDetail FROM 35,215 TYPE 5 OF oDlg ENABLE ONSTOP "STR0032" ACTION (lDetail := PesqDetail(lDetail,@oDlg,@aScroll,@oBigGet,nOrd,oPPreview),;
																					If(lMenuDef,(lPreview:= .F.,oPPreview:Hide()),)) //"Detalhes"

	For ni := 1 To Len(aAllLista)
		Aadd(aScroll,NIL)
		@22,05 SCROLLBOX aScroll[ni] VERTICAL SIZE 84,205 BORDER
		aScroll[ni]:Hide()

		For nj := 1 To Len(aAllLista[ni])
			cVar := "aPesqVar["+StrZero(ni,2)+"]["+StrZero(nj,2)+"]"
			bBloco  := &("{ | u | If( PCount() == 0, "+cVar+","+cVar+" := u)}")
			PesqInit(aAllLista[ni],aScroll[ni],nj,bBloco,cVar)
		Next
	Next
	
	oCbx:bChange := {|| PesqChange(@nOrd,oCbx:nAt,@aLista,cAlias,@aAllLista,@aScroll,@lDetail,@oDetail,@oDlg,@oBigGet) }
	aLista := Aclone(aAllLista[nOrd])
Else
	oCbx:bChange := {|| nOrd := oCbx:nAt}
EndIf

ACTIVATE MSDIALOG oDlg CENTERED

Return*/

Static Function FR079Mark(lMark,lNoSaldo)

	Local nI   := 0
	Local nSum := 0
	
	DEFAULT lNoSaldo := .F. //Apenas t�tulos sem saldo residual
	
	nSum := Len( aEntidades )
	ProcRegua( nSum )
	
	If !lNoSaldo
		//-- Varre o aTitulos para atualizar o Mark.
		For nI := 1 To Len( aEntidades )
			IncProc()
			If lMark
				aEntidades[ nI, BRW_CHECK ] := .T.	//-- Marca
			Else
				aEntidades[ nI, BRW_CHECK ] := .F.	//-- Desmarca
			EndIf
		Next nI
	Else
			//-- Varre o aTitulos para atualizar o Mark.
		For nI := 1 To Len( aEntidades )
			IncProc()
			If lMark .And. aEntidades[Ni][BRW_SEMAFORO]
				aEntidades[ nI, BRW_CHECK ] := .T.	//-- Marca
			Else
				aEntidades[ nI, BRW_CHECK ] := .F.	//-- Desmarca
			EndIf
		Next nI
	
	EndIf 
	
	oLbx1:Refresh()

Return

Static Function FR079HdrClc(nCol)
	
	Local bMarkAll   := { || FR079Mark(.T.,.T.) }
	Local bClearAll  := { || FR079Mark(.F.) }
	
	If nCol == 2
		If lMarkX
			Processa(bMarkAll,"","",.F.)
			lMarkX := .F.
		Else
			Processa(bClearAll,"","",.F.)
			lMarkX := .T.
		EndIf
	Else
		//-- Define quais colunas poder�o ser ordenadas.
		If nCol == BRW_AC .Or. nCol == BRW_CODPARCEIRO .Or. nCol == BRW_DESCPARCEIRO .Or.;
			 nCol == BRW_SALDO .Or. nCol == BRW_DTIMPORT 

			If nCol == nColAux
				//-- Ordem Descendente.
				ASort(aEntidades,,, { | x,y | x[nCol] < y[nCol] } )
				oLbx1:Refresh()
				nColAux := 0
			Else
				//-- Ordem Acendente.
				ASort(aEntidades,,, { | x,y | x[nCol] > y[nCol] } )
				oLbx1:Refresh()
				nColAux := nCol
			EndIf
		EndIf
	EndIf
Return

Static Function FR079Gerar()

	Local cCodPar	:= ""
	Local cDescPar	:= ""
	Local cPeriodo	:= aRet[1]
	Local nValPed 	:= 0
	Local nValor	:= 0
	Local Ni 		:= 0
	Local oDlg2		:= Nil
	Local oConsolid := Nil
	Local lCancela	:= .F.
	Local aLogErroP	:= {"ERRO"		,"[Execu��o Manual] N�o foi poss�vel gerar a Medi��o/Pedido."	,{}}
	Local aLogGener := {"MENSAGEM"	,"[Execu��o Manual] Medi��es/Pedidos gerados com sucesso."		,{}}

	For Ni := 1 To Len(oLbx1:aArray)
		If oLbx1:aArray[Ni][BRW_CHECK]

			nValPed 	:= Val(StrTran(StrTran(oLbx1:aArray[Ni][BRW_SALDO],".",""),",","."))
			nValor 		:= nValPed
			cCodPar		:= oLbx1:aArray[Ni][BRW_CODPARCEIRO]
			cDescPar 	:= oLbx1:aArray[Ni][BRW_DESCPARCEIRO]

			If nValPed <= 0
				MsgStop("N�o � poss�vel gerar Medi��es ou Pedidos para entidades com saldos zerados.")
				Return
			EndIf

			oConsolid := ConsolidadoRemuneracao():fromSZ6(cPeriodo, cCodPar)

			If !Empty(oConsolid:cCodigoEntidade)
			
				oDlg2 := MSDialog():New(001,001,135,310,'VALOR DO PEDIDO',,,,,CLR_BLACK,CLR_WHITE,,,.T.)
			
				@ 35,010 SAY "Parceiro: " + oConsolid:cDescEntidade  + " - " + oConsolid:cCodigoEntidade OF oDlg2 PIXEL

				@ 46.5,031 SAY "Valor: " OF oDlg2 PIXEL
				@ 45,061 MSGET nValor   SIZE 50,5 OF oDlg2 PIXEL PICTURE "@E 999,999,999,999.99"

			
				// Ativa di�logo centralizado
				ACTIVATE MSDIALOG oDlg2 CENTERED ON INIT	EnchoiceBar(oDlg2,{|| oDlg2:End()},{|| lCancela := .T., oDlg2:End()}) 
		
				If !lCancela
					If nValPed >= nValor
						oConsolid:nValorTotal := nValor
						//Alert("Vai gerar o pedido no valor de " + cValToChar(oConsolid:nValorTotal) + " para " + oConsolid:cDescEntidade)
						If !oConsolid:geraPedido()
							aAdd(aTail(aLogErroP), DecodeUTF8(FALHA_PEDIDO) )
						Else
							aAdd(aTail(aLogGener), DecodeUTF8(MAN_SUCESSO_PEDIDO) )
							oLbx1:aArray[Ni][BRW_SALDO] := Transform(nValPed - nValor, "@E 999,999,999.99")
						EndIf
						oLbx1:aArray[Ni][BRW_CHECK] := .F.
					Else
						MsgInfo("O valor n�o pode ser superior")
					EndIf
				EndIf
			EndIf

		EndIf
	Next

	/* Trata Log para Erros na Gera��o da Medi��o/Pedido */
	gravaLogCtb(aLogErroP)

	/* Trata Log para Gera��o correta de Medi��o/Pedido */
	gravaLogCtb(aLogGener)

	MsgInfo("O processamento foi conclu�do. Verifique o log para o status do processamento.")

Return

Static Function FR079MrkTit()
	
	Local lMark := aEntidades[ oLbx1:nAt, 2 ]
	
	//-- Realiza a marca��o apenas se tiver registro na tela.
	If lMark
		aEntidades[ oLbx1:nAt, 2 ] := .F.	//-- Desmarca
	Else
		aEntidades[ oLbx1:nAt, 2 ] := .T.	//-- Marca
	EndIf

	oLbx1:Refresh()
	
Return

Static Function CR079Estorna(aLinha)

	/*Local cPedido 	:= aLinha[3]
	Local cMedicao 	:= aLinha[4]
	Local cNota		:= aLinha[7]
	Local cSerie	:= aLinha[6]

	If !Empty(cNota)
		MsgStop("O pedido n�o pode ser estornado, pois est� vinculado � Nota Fiscal: " + cNota)
		Return
	EndIf

	//Implementar Objeto MedicaoRemuneracao para carregar os dados da CND e CNE e possibilitar o estorno

	//Deletar registros de pedido de compra SC7/SCr?*/

Return


Static Function gravaLogCtb(aLog)

	Local Ni 	:= 0
	Local cLog 	:= ""

	If Len(aLog) == 0
		Return .F.
	EndIf

	/* Trata Log para Gera��o correta de Medi��o/Pedido */
	For Ni := 1 To Len(aLog[3])
		cLog += aLog[3][Ni] + CRLF
	Next
	If !Empty(cLog)
		ProcLogAtu(aLog[1],aLog[2],cLog)
	EndIf

Return .T.
