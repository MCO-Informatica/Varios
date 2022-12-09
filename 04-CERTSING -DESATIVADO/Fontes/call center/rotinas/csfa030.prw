//------------------------------------------------------------------
// Rotina | CSFA030 | Autor | Robson Luiz - Rleg | Data | 28/09/2012
//------------------------------------------------------------------
// Descr. | Rotina especifíca para chamar as funcionalidade do Call
//        | Center (TeleMarketing), o objetivo é permitir somente o 
//        | uso por operadores/consultor c/ perfil de televendas 
//        | utilizar a rotina c/ pesquisa, visualização e alteração.
//------------------------------------------------------------------
// Uso    | Certisign
//------------------------------------------------------------------
#Include "Protheus.ch"
User Function CSFA030()

	Local aCores1    := {	{"(EMPTY(SUC->UC_CODCANC) .AND. VAL(SUC->UC_STATUS) == 2)" , "BR_VERMELHO" },;// Pendente
	   						{"(EMPTY(SUC->UC_CODCANC) .AND. VAL(SUC->UC_STATUS) == 3)" , "BR_VERDE"    },;   // Encerrado
	   						{"(EMPTY(SUC->UC_CODCANC) .AND. VAL(SUC->UC_STATUS) == 1)" , "BR_AZUL"     },;   // Planejada
	   						{"(!EMPTY(SUC->UC_CODCANC))","BR_PRETO"		}} 								         // Cancelado	
	
	Local lTk271Cor		:= FindFunction("U_TK271COR")	// P.E. Para substituir as cores utilizadas na mbrowse
	Local aRetCor		:= {}							// Array de retorno do ponto de entrada U_TK271COR
	Local bBlockCor		:= Nil							// Codeblock para atualizar o array de cores correto no P.E. U_TK271COR
	Local aRotAdic		:= {}							// Retorno do P.E. TK271ROTM
	Local lTk271RotM	:= FindFunction("U_TK271ROTM")  // P.E. para carregar ROTINAS PERSONALIZADAS para o Menu.
	Local lRet			:= .F.							// Retorno da funcao	
	Local lTk271Fil		:= FindFunction("U_TK271FIL")	// Ponto de entrada para filtrar o Browse
	Local cFiltra		:= " "							// Filtro de retorno do ponto de entrada
	Local aIndex		:= {}							// Array com o indices utilizados
	Local cTipoAte		:= AllTrim(TkGetTipoAte())		// Codigo do tipo de atendimento prestado
	Local cTipoBkp := ""
	Private cCadastro 	:= "® Atendimento Tmk Tlv"
	Private aRotina   	:= {}
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Protege rotina para que seja usada apenas no SIGATMK ou SIGACRM³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !AmIIn(13,73)			// 13 = SIGATMK, 73 = SIGACRM
		Return(lRet)
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Inclui uma legenda para identificar chamados compartilhados³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If SUC->(FieldPos("UC_CHAORIG")) > 0
		aSize(aCores1,Len(aCores1)+1)
		aIns(aCores1,1)
		aCores1[1] := {"!EMPTY(SUC->UC_CHAORIG)" , "BR_CINZA" } // Compartilhamento
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Combinações de entradas no atendimento call center,³
	//³ e suas respectivas permissões de entrada.         ³
	//³1. MDI                                             ³
	//³1.1 Mesma máquina                                  ³
	//³1.1.1 Mesmo usuário no mesmo processo: SIM         ³
	//³1.1.2 Mesmo usuário em processos diferente: SIM    ³
	//³1.2 Máquinas diferentes                            ³
	//³1.2.1 Mesmo usuário em processos diferentes: SIM   ³
	//³2. SDI                                             ³
	//³2.1 Mesma máquina                                  ³
	//³2.1.1 Mesmo usuário no mesmo processo: SIM         ³
	//³2.1.2 Mesmo usuário em processos diferentes: SIM   ³
	//³2.2 Máquinas diferentes                            ³
	//³2.2.1 Mesmo usuário em processos diferentes: NÃO   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !SetMdiChild()
		If !ExcProcess( "TMK" + __cUserId )
			If ExcProcess( "TMK" + __cUserId + GetClientIP() )
				//FA030Desliga()
				Help("  ",1,"TMKPROMDI")
				Return(lRet)
			EndIf
		Else
			ExcProcess( "TMK" + __cUserId + GetClientIP() )
		Endif	
	Endif	

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Faz o tratamento para garantir a exclusividade na rotina de atualizacao do SK1³
	//³somente se o operador tiver acessando TODAS as rotinas ou somente TELECOBRANCA³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ( cTipoAte == "3" ) .OR. ( cTipoAte == "4" )  		// Telecobranca ou Ambos
		ExcProcess("TMKSK1")
	Endif	

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Se o USUARIO nao estiver cadastrado em OPERADORES e nao tiver	³
	//³um Posto de Venda associado nao entra na rotina					³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !TMKOPERADOR()
		Help("  ",1,"OPERADOR")
		Return(lRet)
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Limpa o array com os precos da ultima tabela de preco usada - ³
	//³Caso haja atualizacao da tabela de preco por outro Remote     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MaReleTabPrc()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Ponto de entrada - Adiciona rotinas ao aRotina               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lTk271RotM
		aRotAdic := U_TK271ROTM()
		If ValType(aRotAdic) <> "A"
			aRotAdic := {}
		Endif
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Ponto de entrada para permitir a alteracao das cores de³
	//³identificacao de linhas na mbrowse de acordo com o tipo³
	//³de atendimento executado (1 a 3). Tipos 4 e 5 nao apre-³
	//³sentam cores e legendas, dispensando a execucao do P.E.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If (lTk271Cor) .AND. (cTipoAte <= "3")
		aRetCor := U_TK271COR(cTipoAte)
		If (ValType(aRetCor) == "A") .AND. (Len(aRetCor) > 0)
			bBlockCor := &("{|aVet| aCores" + cTipoAte + " := aClone(aVet)}")
			Eval(bBlockCor,aRetCor)
		Endif
	Endif	

	//{ "Incluir"    ,"U_FA30Incluir"       ,0,3 },;

	aRotina := {{ "Pesquisar" ,"AxPesqui" ,0,1 },;
	{ "Visualizar" ,"TK271CallCenter"     ,0,2 },;
	{ "Incluir"    ,"TK271CallCenter"     ,0,3 },;
	{ "Alterar"    ,"TK271CallCenter"     ,0,4 },;
	{ "Legenda"    ,"TK271Legenda"        ,0,2 }}
	

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Adiciona rotinas recebidas pelo Ponto de Entrada ao aRotina  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lTk271RotM
		// O limite de MENUS do usuario tem que ser menor que 3 porque o limite do Protheus sao 10
		If ValType(aRotAdic) == "A" .AND. ( Len(aRotAdic) < 3 ) 
			AEval(aRotAdic,{|x| AAdd(aRotina,x)})
		Endif
	Endif

	//---------------------------------------------------
	// Armazenar o tipo de atendimento atual do operador.
	//---------------------------------------------------
	cTipoBkp := TkGetTipoAte()
	
	//-------------------------------------
	// Abre somente a tela de Telemarketing
	//-------------------------------------
	TkGetTipoAte("1") 	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Ponto de entrada para filtrar a MBrowse ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lTk271Fil
		TK271MFil("SUC", @cFiltra, @aIndex )
	Endif

	MBrowse(,,,,"SUC",,,,,,aCores1)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Finaliza o uso da funcao FilBrowse e retorna os indices padroes.       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty( cFiltra ) .AND. Len( aIndex ) > 0
		EndFilBrw( "SUC", aIndex )
	Endif

	//------------------------------------
	// Restaura as informacoes anteriores.
	//------------------------------------
	TkGetTipoAte(cTipoBkp)
Return(.T.)

//--------------------------------------------------------------------
// Rotina | FA30Incluir | Autor | Robson Luiz - Rleg | Data | 28/09/12
//--------------------------------------------------------------------
// Descr. | Rotina para contemplar o número de elementos no vetor 
//        | aRotina, assim a funcionalidade de alterar funcionará
//        | corretamente.
//------------------------------------------------------------------
// Uso    | Certisign
//------------------------------------------------------------------
User Function FA30Incluir()
	Aviso(cCadastro,"Somente é possível incluir por meio da agenda do operador.",{"Voltar"},1,"TeleMarketing - Incluir")
Return