//--------------------------------------------------------------------
// Rotina | CSFA040   | Autor | Robson Luiz - Rleg | Data | 04.10.2012 
//--------------------------------------------------------------------
// Descr. | Rotina acionada pelo ponto de entrada TMKA380B, o objetivo 
//        | é executar uma funcionalidade específica que o operador com 
//        | o tipo de atendimento igual a TeleVendas consiga atuar 
//        | também na operação de TeleMarketing da Agenda do Operador.
//--------------------------------------------------------------------
// Uso    | Cetisign
//--------------------------------------------------------------------
#Include "Protheus.ch"
User Function CSFA040( aItemSel, aCOLS, aHeader, oGetDados, nLiaCOLS )
	Local cTipoBkp := ""
	Local cLista := ""
	Local cCodigo := ""
	Local cCodCont := ""
	Local cEndidade := ""
	Local cChave := ""
	Local cDDI := ""
	Local cDDD := ""
	Local cTEL := ""
	Local nTipoTel := 0
	Local cTipoTel := GetNewPar("MV_TMKTPTE","4") // Tipo do telefone para contato(quando lido via parametro)
	Local cOperador := TkOperador()
	//------------------------------------------------------------------
   // ExpC1: Codigo do contato                                    		
	// ExpC2: Entidade (alias)                               			    
	// ExpC3: Chave primaria da entidade          			             
	// ExpN4: Registro                       	                         
	// ExpN5: Opcao da tela de atendimento.	                            
	// ExpA6: Array com os dados do titulo para atendimento ATIVO DO TLC
	// Tk380CallCenter( cCodCont, cEntidade, cChave, nReg, nOpc, aTlc )
	//------------------------------------------------------------------
	cLista    := aCOLS[ nLiaCOLS, AScan( aHeader, {|p| RTrim( p[ 2 ] ) == "U6_LISTA" } ) ]
	cCodigo   := aCOLS[ nLiaCOLS, AScan( aHeader, {|p| RTrim( p[ 2 ] ) == "U6_CODIGO" } ) ]
	cCodCont  := aCOLS[ nLiaCOLS, AScan( aHeader, {|p| RTrim( p[ 2 ] ) == "U6_CONTATO" } ) ]
	cEnditade := aCOLS[ nLiaCOLS, AScan( aHeader, {|p| RTrim( p[ 2 ] ) == "U6_ENTIDA" } ) ]
	cChave    := aCOLS[ nLiaCOLS, AScan( aHeader, {|p| RTrim( p[ 2 ] ) == "U6_CODENT" } ) ]

	//+---------------------------------------------------------------
	//| Pega os campos que compoem o telefones no cadastro de contatos
	//+---------------------------------------------------------------
	nTipoTel := Val(SU4->U4_TIPOTEL)
	
	//+-----------------------------------------------------------
	//| Certifica que o tipo do telefone esta gravado corretamente
	//+-----------------------------------------------------------
	If nTipoTel == 0
		nTipoTel := Val(cTipoTel)
	EndIf

	cDDD := RTrim( TkDadosContato( cCodCont, 8) )
	cDDI := RTrim( TkDadosContato( cCodCont, 9) )
	cTEL := RTrim( TkDadosContato( cCodCont, nTipoTel) )
	
	//-----------------------------------------------------
	// EXPC1: Codigo do operador.                         
	// EXPC2: Codigo do DDI do telefone a ser chamado.    
	// EXPC3: Codigo do DDD do telefone a ser chamado.    
	// EXPC4: Numero do telefone a ser chamado.           
	// EXPC5: Codigo do contato.                          
	// EXPC6: Codigo da Entidade.(Ex. SA1)                
	// EXPC7: Chave da entidade. (Chave primaria do alias)
	// EXPC8: Codigo da lista de contato.                 
	// EXPC9:Codigo do item da lista de Contato.         
	//-----------------------------------------------------
	If Tk380Discar( cOperador ,cDDI ,cDDD ,cTEL ,cCodCont ,cEnditade ,cChave ,cLista ,cCodigo )
		//---------------------------------------------------
		// Armazenar o tipo de atendimento atual do operador.
		//---------------------------------------------------
		cTipoBkp := TkGetTipoAte()
		
		//-------------------------------------
		// Abre somente a tela de Telemarketing
		//-------------------------------------
		TkGetTipoAte("1") 	
		
		Tk380CallCenter( cCodCont, cEnditade, cChave, SUC->(Recno()), 3, NIL )
		Tk380Lock( {{ cLista, cCodigo, cCodCont }}, "3" )
		
		//------------------------------------
		// Restaura as informacoes anteriores.
		//------------------------------------
		TkGetTipoAte(cTipoBkp)
	Endif
Return

//------------------------------------------------------------------------
// Rotina | Tk380Lock       | Autor | Robson Luiz - Rleg | Data | 04/09/12
//------------------------------------------------------------------------
// Descr. | Atualiza Status dos registros do SU6.
//------------------------------------------------------------------------
// Uso    | Certisign
//------------------------------------------------------------------------
// Origem | Copiado a função do padrão por ser uma Static Function
//------------------------------------------------------------------------
Static Function Tk380Lock(aLckCont,cStatus,lForceU6)
Local aArea 	:= GetArea() 			// Salva alias aberto para restauracao posterior
Local lRet		:= .F.					// Retorno da funcao.
Local nFor		:= 0 					// Contador for.
Local aStatus	:= Tk380Box("U6_STATUS")// Retorna as opcoes do campo.

DEFAULT lForceU6 := .F.
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³cStatus      ³
//³1- Em Aberto ³
//³2 - Em uso   ³
//³3 - Encerrado³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³aLckCont - Array com os contatos para Lock.³
//³aLckCont[x][1] = Lista					  ³
//³aLckCont[x][2] = Codigo Seq. do SU6 		  ³
//³aLckCont[x][3] = Contato					  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

DbSelectArea("SU6")
DbSetOrder(1)//Codigo da Lista + Codigo Sequencial do SU6 

For nFor := 1 To Len(aLckCont)
	If DbSeek( xFilial("SU6") + aLckCont[nFor][1] + aLckCont[nFor][2] )
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³No status 1 o contato pode ser trabalhado normalmente.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If  SU6->U6_STATUS == "1"
			If SimpleLock()
				Replace SU6->U6_STATUS With cStatus 
				MsUnLock()
				DbCommit()
				lRet := .T.
			Endif	

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³No status 2 o contato pode ser trabalhado para 1- Em Aberto ou 3 - Encerrado.³
		//³Porem nunca podera ser locado novamente. 									³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		ElseIf SU6->U6_STATUS == "2"
			If cStatus == "2" // Nao pode selecionar um contato ja locado.
				MsgStop("O contato " + aLckCont[nFor][3] + " ja esta sendo utilizado por outra operação."  ) //"O contato "###" ja esta sendo utilizado por outra operação."
		    Else
		    	If SimpleLock()
					Replace SU6->U6_STATUS With cStatus 
					If cStatus == "3"
						Replace SU6->U6_CODOPER With TkOperador() 
					Endif
					MsUnLock()
					DbCommit()
					lRet := .T.
				Endif	
		    Endif

		ElseIf SU6->U6_STATUS == "3"
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³No status 2 o Registro nao pode ser alterado.								³
			//³Porem ha uma abertura para sua reutilizacao que dependera de um flag enviado ³
			//³para a funcao. Opcao emergencial.											³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

			MsgStop("O contato " + aLckCont[nFor][3] + " ja foi encerrado."  )	 //"O contato "###" ja foi encerrado."
			If lForceU6
				If TmkOk("Deseja alterar seu Status para "+aStatus[Val(cStatus)] +" ? ") //"Deseja alterar seu Status para "
			    	If SimpleLock()
						Replace SU6->U6_STATUS With cStatus 
						MsUnLock()
						DbCommit()
						lRet := .T.
					Endif	
				Endif	
			Endif	
		Endif	
	Endif
Next nFor

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Para o Status 3 - Encerramento.                         ³
//³Encerra a lista de voz se nao existirem itens restantes.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If cStatus == "3"
	Tk380FechaLista(aLckCont)
Endif

RestArea(aArea)
Return(lRet)

//------------------------------------------------------------------------
// Rotina | TK380FechaLista | Autor | Robson Luiz - Rleg | Data | 04/09/12
//------------------------------------------------------------------------
// Descr. | Avalia e encerra SU4.
//------------------------------------------------------------------------
// Uso    | Certisign
//------------------------------------------------------------------------
// Origem | Copiado a função do padrão por ser uma Static Function
//------------------------------------------------------------------------
Static Function Tk380FechaLista(aLckCont)
Local lRet   := .F.   			 // Flag que define se a lista sera encerrada.
Local aArea  := GetArea("SU4")	 // Salva alias para posterior restauracao
Local lFecha := .T.				 // Identifica se a lista deve ser encerrada.


If Len(aLckCont) > 0 .AND.;
	Len(aLckCont[1]) > 0

	DbSelectArea("SU6")
	DbSetOrder(1)
	
	#IfDEF TOP
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Filtra todas as atividades para o operador na database.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cQuery:=	" SELECT *" +;
					" 	FROM " + RetSqlName("SU6") + " SU6 " 				+;
					" 	WHERE	U6_FILIAL = '" + xFilial("SU6") + "' AND "	+; 
					" 			U6_LISTA = '" + aLckCont[1][1]  + "' AND "  +;
					" 			U6_STATUS <> '3' AND " 						+;
					" 			D_E_L_E_T_ <> '*'" 
		cQuery+=	" ORDER BY U6_FILIAL,U6_LISTA,U6_CODIGO"
			
		cQuery := ChangeQuery(cQuery)
		DbSelectArea("SU6")
		DbCloseArea()
		DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "SU6", .F., .T.)
	#ELSE	
		DbSeek(xFilial("SU6")+aLckCont[1][1]) 
	#ENDIF
	
	While ((!Eof()) .AND. (SU6->U6_LISTA == aLckCont[1][1]))
		If	SU6->U6_STATUS <> "3"  // Diferente de nao executado
			lFecha := .F.
		    Exit
		Endif
	
		DbSkip()
	End
	
	#IFDEF TOP
		DbSelectArea("SU6")
		DbCloseArea()
		ChkFile("SU6")
	#ENDIF
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Encerra a Lista de Contatos.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lFecha
		lRet := .T.
		DbSelectArea("SU4")
		DbSetOrder(1)
		If DbSeek(xFilial("SU4") + aLckCont[1][1])
			RecLock("SU4",.F.)
			Replace SU4->U4_STATUS With "2" //Lista Encerrada
			MsUnLock()
			DbCommit()
	
			If !Empty(SU4->U4_OPERAD)
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Atualiza tarefa no SU7 - Operador³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				Tk380TarefaU7(SU4->U4_OPERAD) 	// Subtrai em um o U7_TAREFA que gerencia a quantidade de tarefas do Operador.
			Endif	
		Endif	
	Endif
EndIf

RestArea(aArea)
Return(lRet)

//------------------------------------------------------------------------
// Rotina | Tk380TarefaU7   | Autor | Robson Luiz - Rleg | Data | 04/09/12
//------------------------------------------------------------------------
// Descr. | Grava a tarefa no SU7 para o operador.
//------------------------------------------------------------------------
// Uso    | Certisign
//------------------------------------------------------------------------
// Origem | Copiado a função do padrão por ser uma Static Function
//------------------------------------------------------------------------
Static Function Tk380TarefaU7(cOperador)
	Local lRet   := .F.				// Retorno da funcao
	Local aSArea := GetArea()		// Salva a area
	Local nVal   := 0				// Contador auxliar
	
	DbSelectArea("SU7")
	DbSetOrder(1)
	If DbSeek(xFilial("SU7")+ cOperador)
	    nVal := SU7->U7_TAREFA
	   
	    If nVal > 0 
	 	   nVal--
		Endif
			
		RecLock("SU7",.F.)
		Replace U7_TAREFA  With  nVal
		MsUnlock()
		DbCommit()
		lRet := .T.
	Endif
	
	RestArea(aSArea)
Return (lRet)

//------------------------------------------------------------------------
// Rotina | FA040TudOK     | Autor | Robson Luiz - Rleg | Data | 19/11/12
//------------------------------------------------------------------------
// Descr. | Rotina acionada pelo ponto de entrada TK271BOK, o objetivo é
//        | verificar se determinados campos estão preenchidos conforme
//        | a necessidade do contexto do atendimento.
//------------------------------------------------------------------------
// Uso    | Certisign
//------------------------------------------------------------------------
User Function FA040TudOK( n271Opc )
	Local lRet := .T.
	Local cMsg := ""
	//-------------------------------------------------------------------------------------
	// Se o campos status igual a pendente e data ou hora do reagendamento vazio, criticar.
	//-------------------------------------------------------------------------------------
	If M->UC_STATUS == "2" .And. ( Empty( M->UC_PENDENT ) .Or. Len( AllTrim( M->UC_HRPEND ) )<>5 )
		cMsg := "O atendimento está com o campo 'Status' igual a Pendente, "
		cMsg += "porém sem data no campo 'Retorno' ou sem hora no campo 'Hora', "
		cMsg += "por favor, ajuste estes dados conforme a situação."	
		Aviso("PE-TMKOUT",cMsg,{"Voltar"},2,"Critíca de campo")
		lRet := .F.	
	Endif
Return( lRet )