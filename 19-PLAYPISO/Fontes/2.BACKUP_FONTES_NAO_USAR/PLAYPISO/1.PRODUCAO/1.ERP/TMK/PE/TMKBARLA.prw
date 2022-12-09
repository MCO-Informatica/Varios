/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TMKBARLA  ºAutor  ³Fernando B.Muta     º Data ³  30/08/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Este programa tem como objetivo incluir botoes no           º±±
±±º          ³CallCenter personalizados                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ESPECIFICO LISONDA                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function TMKBARLA() 

//IniBarla()
_aOpcoes  := {}
AADD(_aOpcoes,{"S4WB007N",{||U_TMKA010()},OEMTOANSI("Orçamentos do Cliente")})
Return(_aOpcoes)                               


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ TMKA010  ºAutor  ³Bruno Daniel Borges º Data ³  09/10/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao para listar as ultimas versoes de cada projeto do    º±±
±±º          ³cliente informado                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Lisonda                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function TMKA010()
Local oDlgPrj	:= Nil    
Local oListPrj	:= Nil       
Local aAreaBKP	:= GetArea()
Local aCoorden	:= MsAdvSize(.T.)
Local aPrjs		:= {}       
Local nPosPrj	:= 0
Local cOpcao	:= ""                         

If Empty(M->UA_CLIENTE) .And. Empty(M->UA_LOJA)
	MsgAlert("Atenção, para consultar os orçamentos/projetos informe primeiro o cliente.")
	Return(Nil)
EndIf

//Busca as ultimas versoes dos projetos do cliente 
dbselectArea("AF8")
AF8->(dbSetOrder(2))
AF8->(dbSeek(xFilial("AF8")+M->UA_CLIENTE+M->UA_LOJA))
While AF8->(!Eof()) .And. AF8->AF8_FILIAL + AF8->AF8_CLIENT + AF8->AF8_LOJA == xFilial("AF8")+M->UA_CLIENTE+M->UA_LOJA
	nPosPrj := AScan(aPrjs,{|x| x[1] == AF8->AF8_PROJET })
	If nPosPrj > 0 .And. aPrjs[nPosPrj][2] < AF8->AF8_REVISA
		aPrjs[nPosPrj][2] := AF8->AF8_REVISA
		aPrjs[nPosPrj][3] := AF8->AF8_X_ATEN
		aPrjs[nPosPrj][4] := AF8->AF8_FASE
		aPrjs[nPosPrj][5] := AllTrim(Posicione("AEA",1,xFilial("AEA")+AllTrim(AF8->AF8_FASE),"AEA->AEA_DESCRI"))
	Else
		Aadd(aPrjs,{	AF8->AF8_PROJET,;
						AF8->AF8_REVISA,;
						AF8->AF8_X_ATEN,;
						AF8->AF8_FASE,;
						AllTrim(Posicione("AEA",1,xFilial("AEA")+AllTrim(AF8->AF8_FASE),"AEA->AEA_DESCRI")),;
						AllTrim(Posicione("AEA",1,xFilial("AEA")+AllTrim(AF8->AF8_FASE),"AEA->AEA_CORBRW")),;
						AF8->(RecNo()) })	
	EndIf
     
	AF8->(dbSkip())
EndDo                                                       

If Len(aPrjs) <= 0
	MsgAlert("Nenhum orçamento/projeto foi localizado para esse cliente.")
	RestArea(aAreaBKP) //
	Return(Nil)
EndIf

//Tela com os projetos do cliente (ultima versao de cada um)
oDlgPrj := TDialog():New(aCoorden[7],000,aCoorden[6]/1.5,aCoorden[5]/1.2,OemToAnsi("Orçamentos do Cliente"),,,,,,,,oMainWnd,.T.)
	@ 001,001 ListBox oListPrj VAR cOpcao Fields Header "","Projeto/Orçamento","Revisão","Atendimento","Fase Atual","Descrição" Size oDlgPrj:nWidth/2-5,oDlgPrj:nHeight/2-40 PIXEL OF oDlgPrj
		oListPrj:SetArray(aPrjs)
		oListPrj:bLine := {||{	Ret_BitMap(aPrjs[oListPrj:nAt][6]),;
								aPrjs[oListPrj:nAt][1],;
								aPrjs[oListPrj:nAt][2],;
								aPrjs[oListPrj:nAt][3],;
								aPrjs[oListPrj:nAt][4],;
								aPrjs[oListPrj:nAt][5] }}  
									
	TButton():New(oDlgPrj:nHeight/2-27,001,OemToAnsi("&Visualizar"					),oDlgPrj,{|| Acao_Projeto(1,aPrjs,oListPrj:nAt) },030,011,,,,.T.,,,,{|| })   									
	TButton():New(oDlgPrj:nHeight/2-27,035,OemToAnsi("&Revisar"					),oDlgPrj,{|| Acao_Projeto(2,aPrjs,oListPrj:nAt) },030,011,,,,.T.,,,,{|| })   									
	TButton():New(oDlgPrj:nHeight/2-27,070,OemToAnsi("&Reenviar Email ao Setor"	),oDlgPrj,{|| Acao_Projeto(3,aPrjs,oListPrj:nAt) },065,011,,,,.T.,,,,{|| })
	TButton():New(oDlgPrj:nHeight/2-27,140,OemToAnsi("&Fechar"						),oDlgPrj,{|| oDlgPrj:End() },030,011,,,,.T.,,,,{|| })   									
oDlgPrj:Activate(,,,.T.) 

RestArea(aAreaBKP)

Return(Nil)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TMK2PMS   ºAutor  ³Fernando B.Muta     º Data ³  30/08/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Este Programa tem como Objetivo exibir a tela de            º±±
±±º          ³inclusao de Orcamento                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Lisonda                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
/*
User Function TMK2PMS()
Local _aArea := GetArea() 
Private nDlgPln
DbSelectArea("SUA")
DbSetOrder(1)
If DbSeek(xFilial("SUA")+M->UA_NUM)
	AxInclui("AF8",0,3,,,,"Pms200Ok()")
	Pergunte("PMA200",.F.)
	nDlgPln := mv_par01
	DbSelectArea("AF8")
	DbSetOrder(1)
	
	PMS200DLG("AF8",AF8->(Recno()),3)
Else
    MsgInfo("Favor confirmar o atendimento para inclusão do orçamento.")
EndIf	
RestArea(_aArea)
Return


Static Function IniBarla()
DbSelectArea("SX3")
DbSetOrder(2)
If !DbSeek("AF8_X_ATEN")
     MSGINFO("Criar o campo AF8_X_ATEN Caracter 8 para gravar o código do atendimento - Só Visualiza")
EndIf

If DbSeek("AF8_CLIENT")
	RecLock("SX3",.F.)
	SX3->X3_RELACAO := "IIF(FunName()=='PMSA200',Space(8),M->UA_CLIENTE)"
	SX3->X3_WHEN    := "FunName()=='PMSA200'"
	MsUnlock()
EndIf

If DbSeek("AF8_LOJA")
	RecLock("SX3",.F.)
	SX3->X3_RELACAO := "IIF(FunName()=='PMSA200',Space(2),M->UA_LOJA)"
	SX3->X3_WHEN    := "FunName()=='PMSA200'"
	MsUnlock()
EndIf

If DbSeek("AF8_X_ATEN")
	RecLock("SX3",.F.)
	SX3->X3_RELACAO := "IIF(FunName()=='PMSA200',Space(6),M->UA_NUM)"	
	MsUnlock()
EndIf

Return
*/
                               

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Ret_BitMapºAutor  ³Bruno Daniel Borges º Data ³  11/10/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao para retorno da legenda do listbox conforme cadastro º±±
±±º          ³de etapas do projeto                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Lisonda                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Ret_BitMap(cCor)
Local oRetorno := Nil

If cCor == "1"
	oRetorno := LoadBitmap( GetResources(), "BR_VERMELHO" )
ElseIf cCor == "2"
	oRetorno := LoadBitmap( GetResources(), "BR_VERDE" )
ElseIf cCor == "3"
	oRetorno := LoadBitmap( GetResources(), "BR_AZUL" )
ElseIf cCor == "4"
	oRetorno := LoadBitmap( GetResources(), "BR_LARANJA" )
ElseIf cCor == "5"
	oRetorno := LoadBitmap( GetResources(), "BR_CINZA" )
ElseIf cCor == "6"
	oRetorno := LoadBitmap( GetResources(), "BR_MARROM" )
ElseIf cCor == "7"
	oRetorno := LoadBitmap( GetResources(), "BR_PINK" ) 
ElseIf cCor == "8"
	oRetorno := LoadBitmap( GetResources(), "BR_AMARELO" ) 
ElseIf cCor == "9"
	oRetorno := LoadBitmap( GetResources(), "BR_PRETO" ) 
ElseIf cCor == "A"
	oRetorno := LoadBitmap( GetResources(), "BR_BRANCO" ) 
EndIf

Return(oRetorno)              
           

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Acao_ProjetoºAutor  ³Bruno Daniel Borges º Data ³  11/10/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Executa a acao dos botoes da tela de consulta de projetos via º±±
±±º          ³TMK                                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Lisonda                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Acao_Projeto(nBotao,aLista,nLinha)  
Local cMenEmail	:= ""

If nBotao == 1 //Visualizar Projeto
	PRIVATE aMemos  := {{"AF8_CODMEM","AF8_OBS"}}
	PRIVATE aCores  := PmsAF8Color()
	PRIVATE nDlgPln := 1 //Formata por default visualizar via TREE

	dbSelectArea("AF8")	
	AF8->(dbSetOrder(1))
	AF8->(dbGoTo(aLista[nLinha][7]))
	PMS200Alt("AF8",AF8->(RecNo()),2)

ElseIf nBotao == 2 //Revisao do Projeto
	PRIVATE aMemos  := {{"AF8_CODMEM","AF8_OBS"}}
	PRIVATE aCores  := PmsAF8Color()
	PRIVATE nDlgPln := 1 //Formata por default visualizar via TREE
	Private lCallPrj := .T.

	dbSelectArea("AF8")	
	AF8->(dbSetOrder(1))
	AF8->(dbGoTo(aLista[nLinha][7]))  
	PMSA210(3)  

ElseIf nBotao == 3 //Reenvio de email ao setor da etapa atual  
	dbSelectArea("AF8")	
	AF8->(dbSetOrder(1))
	AF8->(dbGoTo(aLista[nLinha][7]))  

	dbSelectArea("AEA")
	AEA->(dbSetOrder(1))

	If AEA->(dbSeek(xFilial("AEA")+aLista[nLinha][4])) .And. !Empty(AEA->AEA_X_MAIL)

		cMenEmail  := "Orçamento Número: " + AF8->AF8_PROJET + Chr(13)+Chr(10)
		cMenEmail  += "Número da Obra: " + AF8->AF8_CODOBR + Chr(13)+Chr(10)
		cMenEmail  += "Fase: " + AEA->AEA_DESCRI + Chr(13)+Chr(10)
		cMenEmail  += "Usuario: " + cUserName + Chr(13)+Chr(10)
		
		U_GeraMail(AEA->AEA_X_MAIL,"[Reenvio] - Aviso de Orçamento",cMenEmail, {}, .F.,"")
	Else                                                                        
		MsgAlert("Atenção, a etapa " + aLista[nLinha][4] + " - " + AllTrim(AEA->AEA_DESCRI) + ", do projeto/orçamento " + AllTrim(aLista[nLinha][1]) + " não esta com e-mail cadastrado.")
	EndIf
	
EndIf

Return(Nil)