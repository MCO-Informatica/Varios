#INCLUDE "PROTHEUS.CH"
#INCLUDE "APVT100.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ ACDHCI04 ³ Autor ³ Luiz Enrique          ³ Data ³ 08/07/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ SEPARACAO ESPECIFICA - COM LIBERACOES AUTOMATICAS          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ HCI		                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/ 
User Function ACDHCI04()  

Local lfimAle		:= .F.
Local ckey09  		:= VTDescKey(09)
Local bkey09  		:= VTSetKey(09)

Private cCodOpe     :=	CBRetOpe()
Private lMSErroAuto := 	.F.
Private lMSHelpAuto := 	.t.
Private lForcaQtd   := 	.T.			//GetMV("MV_CBFCQTD",,"2") =="1"
Private cDivItemPv  := 	Alltrim(GetMV("MV_DIVERPV"))
Private cPictQtdExp := 	PesqPict("SC6","C6_QTDVEN")
Private cArmazem    := 	Space(2) 
Private cpedido		:=	Space(6)
Private cOpcSep 

				//SEPARACAO A PARTIR DA SC6 E SC9 - NAO UTILIZANDO ORDEM DE SEPARACAO
				
If Empty(cCodOpe)
	VTAlert("Operador nao cadastrado","Aviso",.T.,3000,3) 
	Return 
EndIf 

While .T. //Laco para Separacoes dos Pedidos

	VTClear()
	If VtModelo()=="RF"
		@ 0,0 VtSay "Separacao" 
	EndIf 

	cPedido := Space(6)
	@ If(VTModelo()=="RF",2,0),0 VTSay 'Informe o Pedido'
	@ If(VTModelo()=="RF",3,1),0 VTSay 'de venda: ' VTGet cPedido PICT "@!"  F3 "CBL"  Valid VldGet(cPedido)
	VTRead 
	If VTLastKey() == 27
 		Exit
	EndIf 

	SC5->(DBSetOrder(1)) //FILIAL+PEDIDO
	If !SC5->(DbSeek(xFilial("SC5")+cPedido))
		VtAlert("Pedido Invalido.","Atencao",.t.)
		VtClearBuffer() 
		loop
	Endif
	
	VTSetKey(09,{|| Informa()},"Informacoes")
	VTSetKey(24,{|| Estorna()},"Estorna")
   
	IF SC5->C5_STASEP == "2" // Ja Separado 
 		VTAlert("Processo de separacao finalizado","Aviso",.t.,3000,3) 
		If VTYesNo("Deseja estornar a separacao ?","Atencao",.T.) 
			Estorna()
			vtsetkey(09,bkey09,cKey09)
		Endif
		Loop 
	Endif
	
	VTCLear()
	If Vtmodelo()=="RF"
		@ 0,0 VTSAY "Tipo da Separacao"
		@ 1,0 VTSay 'Selecione:'
		cOpcSep:=VTaChoice(3,0,6,VTMaxCol(),{"Por Ordem do Pedido","Aleatoria","Estorno"})
	ElseIf VtModelo()=="MT44"
		@ 0,0 VTSAY "Tipo da Separacao"
		@ 1,0 VTSay 'Selecione:'
		cOpcSep:=VTaChoice(0,20,1,39,{"Por Ordem do Pedido","Aleatoria","Estorno"})
	ElseIf VtModelo()=="MT16"
		@ 0,0 VTSAY "Tipo de Separacao"
		cOpcSep:=VTaChoice(1,0,1,19,{"Ordem do Pedido","Aleatorio"})
	EndIf
	
	If VTLastkey() == 27
		Loop
	Endif

	//|*|*|*|*|*|*|*|ESTORNO|*|*|*|*|*|*|*|*| 
	If cOpcSep == 3
		Estorna()
		Loop
	Endif
	
	//Marca o Inicio da Separacao 	
	If SC5->C5_STASEP == "0" .or. Empty(SC5->C5_STASEP)
		RecLock("SC5",.f.)
		SC5->C5_STASEP := "1"  // Em separacao
		SC5->(MsUnlock())
	EndIf	
	
	//|*|*|*|*|*|*|*|SEPARACAO ALEATORIA|*|*|*|*|*|*|*|*|  
	If cOpcSep == 2 		
		EtiProduto() //Solicita Dados 
		Loop	
	Endif 
			
	//|*|*|*|*|*|*|SEPARACAO DIRECIONADA|*|*|*|*|*|*|*|*
	SC6->(DBSetOrder(1)) //FILIAL+PEDIDO
	SC6->(DbSeek(xFilial("SC6")+cPedido))	
	While SC6->(! Eof() .and. C6_FILIAL+C6_NUM ==xFilial("SC6")+cPedido)
		If SC6->C6_QTDVEN == SC6->C6_QTDEMP // ja separado
			SC6->(DbSkip())
			Loop
   		EndIf
   		If (SC6->C6_QTDVEN-SC6->C6_QTDENT)+SC6->C6_QTDEMP == 0	// Produto ja Faturado
			SC6->(DbSkip())
			Loop
   		EndIf  		
   		VtClear() 				   			
		If !EtiProduto() //Solicita Dados
			//Acionou ESC
			Exit
		Endif	
		SC6->(DbSkip())	
	EndDo
	
	If SC6->(Eof()) //Nao saiu por ESC	
		FimProcesso(cPedido,.t.)
	Endif 
	
Enddo 

vtsetkey(09,bkey09,cKey09)

Return 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ FimProcesso³ Autor ³ ACD                 ³ Data ³ 03/02/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Finalisa o processo de separacao                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAACD                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function FimProcesso(cPedido,lmsg)

Local cStatus 	
Local lfim

lfim:=VerseFim(cPedido) //Verifica se existem itens ainda a separar
	
If lfim
	VTAlert("Processo de separacao finalizado","Aviso",.t.,3000)
	cStatus:="2"
Else
	If lmsg
		VTAlert("Separacao do Pedido " + cPedido + " nao Encerrada! ","Atencao",.T.,3000)
	Endif
	cStatus:="1" 
EndIf

If SC5->C5_STASEP <> cStatus
	SC5->(Reclock('SC5',.F.))
	SC5->C5_STASEP	 := cStatus		
	SC5->(MsUnlock())
Endif

Return lfim

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ VerseFim   ³ Autor ³ ACD                 ³ Data ³ 14/012/07³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Verifica se for o Fim da Separacao                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ HCI		                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function VerseFim(cPedido)

Local lfim		:= .T.

SC6->(DBSetOrder(1)) //FILIAL+PEDIDO
SC6->(DbSeek(xFilial("SC6")+cPedido))

While SC6->(! Eof() .and. C6_FILIAL+C6_NUM ==xFilial("SC6")+cPedido)	  	
	If SC6->C6_QTDVEN == SC6->C6_QTDEMP // ja separado
		SC6->(DbSkip())
		Loop
   	EndIf
   	If (SC6->C6_QTDVEN-SC6->C6_QTDENT)+SC6->C6_QTDEMP == 0	// Produto ja Faturado
		SC6->(DbSkip())
		Loop
   	EndIf 	
	lfim	:= .F.
	Exit   	
Enddo 
	
Return lfim

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ SldSeparar ³ Autor ³ Luiz Enrique        ³ Data ³ 07/12/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Retorna Array contendo a Qtd a separar e o label unidade	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ HCI	                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function SldSeparar ()

Local nQtdSep := SC6->C6_QTDVEN - SC6->C6_QTDEMP
Local cUnidade

If GetNewPar("MV_OSEP2UN","0") $ "0 " // verifica se separa utilizando a 1 unidade de media	
	cUnidade:= If(nQtdSep==1,"item ","itens ") 
Else                                          
	nQtdCX:= If(Empty(SB1->B1_QE),1,SB1->B1_QE)	
	If nQtdSep/nQtdCX < 1
		cUnidade:= If(nQtdSep==1,"item ","itens ") 
	Else
		nQtdSep := nQtdSep/nQTdCx
		cUnidade:= If(nQtdSep==1,"volume ","volumes ") 
	EndIf
EndIf

Return {nQtdSep,cUnidade}

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ EtiProduto ³ Autor ³ Luiz Enrique        ³ Data ³ 09/11/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Leitura da etiqueta                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ HCI	                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function EtiProduto()

Local 	cEtiProd 	:= Space(15)
Local 	nQtde		:= 0
Local	cBkpQtd		:= 0
Local	cMsgSair	:= ""

While .t.
       
	VtClearBuffer()
	If VtModelo()=="RF"	
		If cOpcSep == 2 //Aleatorio      
			VtClear()		
			@ 0,0 VTSay "Pedido: " + Alltrim(SC5->C5_NUM )
			@ 2,0 VTSay "Separacao Aleatoria"
		Else // Separacao por Ordem do Pedido
			nQtde		:= Tela() //Sugere Quantidade a separar
			cBkpQtd		:= nQtde	
			If Empty(nQtde)
		   		Exit
	 		EndIf
		Endif		
		@ 5,0 VTSay "Qtde " VtGet nQtde pict cPictQtdExp valid nQtde > 0 when (lForcaQtd .or. VtLastkey()==5)
		@ 6,0 VTSay "Leia o produto" 
		@ 7,0 VTGet cEtiProd pict "@!" VALID VTLastkey() == 5 .or. VldProduto(cEtiProd,nQtde)
		
	Else // para microterminal 44 e 16 teclas
		VtClear()
		@ 0,0 VTSay "Qtde " 	VtGet nQtde pict cPictQtdExp valid nQtde > 0 when (lForcaQtd .or. VtLastkey()==5) 
		@ 1,0 VTSay "Produto" 	VTGet cEtiProd pict "@!" VALID VTLastkey() == 5 .or. VldProduto(cEtiProd,nQtde)
	EndIf
	
	VTRead		
	If VTLastkey() == 27		
		If cOpcSep == 1 //Por Ordem do Pedido	
			cMsgSair	:= Strzero(cBkpQtd,6) + " Item(s) a separar. Sair ?"
			cAviso		:= "Prod:" + Alltrim(SC6->C6_PRODUTO)			
		Else
			cMsgSair	:= "'Deseja Sair ?" 
	   		cAviso		:= "SEPARACAO"
		Endif 		
		If VTYesNo(cMsgSair,cAviso,.T.)
			FimProcesso(cPedido,.t.)
			Return .f. 
		Endif		 		
	Endif
	
	If cOpcSep == 2 //Aleatorio 
		IF FimProcesso(cPedido,.f.)	
	       Exit
		Endif
	EndIf
	
Enddo  

Return .t.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ Tela       ³ Autor ³ ACD                 ³ Data ³ 27/01/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Somente monta a tela do respectivo produto a separar       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAACD                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function Tela()

Local aTam		:=TamSx3("C6_QTDVEN")
Local aInfo   	:={}
Local aSldQtd	:= {} 
Local cUnidade
Local nQtdSep 	:= 0

Static ccodant:=""

VtClear()
// posiconando o produto
SB1->(DbSetOrder(1))
If ! SB1->(DbSeek(xFilial("SB1")+SC6->C6_PRODUTO))
	VtAlert("Inconsistencia de Base, produto "+SC6->C6_PRODUTO+" nao encontrado") 
	Return 0
EndIf  

//Obtem Quantidade a Separar
aSldQtd	:=	SldSeparar ()
nQtdSep	:= 	aSldQtd [1]
cUnidade:= 	aSldQtd [2]

If VtModelo()=="RF" .And. cOpcSep == 1
	@ 0,0 VTSay Padr("Separe "+Alltrim(Str(nQtdSep,aTam[1],aTam[2]))+" "+cUnidade,20) 
	@ 1,0 VTSay SC6->C6_PRODUTO
	@ 2,0 VTSay Left(SB1->B1_DESC,20)
	
	If Rastro(SC6->C6_PRODUTO,"L")
		@ 3,0 VTSay "Lote: " + SC6->C6_LOTECTL
	ElseIf Rastro(SC6->C6_PRODUTO,"S")
		@ 3,0 VTSay SC6->C6_LOTECTL+"-"+SC6->C6_NUMLOTE
	EndIf
	
Elseif cOpcSep == 1
	aAdd(aInfo,{"",""})
	aAdd(aInfo,{"Produto",SC6->C6_PRODUTO}) 
	aAdd(aInfo,{"Descricao",SB1->B1_DESC}) 
	aAdd(aInfo,{"Qtde",Alltrim(Str(nQtdSep,aTam[1],aTam[2]))+" "+cUnidade}) 	
	If Rastro(SC6->C6_PRODUTO,"L")
		aAdd(aInfo,{"Lote",SC6->C6_LOTECTL}) 
	ElseIf Rastro(SC6->C6_PRODUTO,"S")
		aAdd(aInfo,{"Lote",SC6->C6_LOTECTL}) 
		aAdd(aInfo,{"Sub-Lote",SC6->C6_NUMLOTE})
	EndIf	
	If cCodAnt <> 	SC6->(C6_PRODUTO+C6_LOCAL+C6_LOCALIZ+C6_LOTECTL+C6_NUMLOTE+C6_NUMSERI)
		cCodAnt := 	SC6->(C6_PRODUTO+C6_LOCAL+C6_LOCALIZ+C6_LOTECTL+C6_NUMLOTE+C6_NUMSERI)
		VTaBrowse(0,0,VTMaxRow(),VtMaxCol(),{"Separe",""},aInfo,{10,VtMaxCol()},,," ") 
	EndIf	
EndIf

Return nQtdSep

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³VldProduto³ Autor ³ Luiz Enrique          ³ Data ³ 13/11/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Validacao da etiqueta de produto 				          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ HCI		                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function VldProduto(cEtiProd,nQtde)

Local cLote     := Space(10)
Local cLotefor	:= Space(18)
Local cProdut	:= Space(43) //Produto(15), Lote(10), Lote Fornecedor
Local cEtiqueta
Local aEtiqueta := {}
Local aSaldos	:= {}
Local cMsg      := ""
Local nSaldo    := 0
Local lErrQTD   := .F.
Local lTrans    := .F. 
Local aArmzs	:= {}
Local aSave

DEFAULT cEtiProd:= Space(48)
DEFAULT nQtde   := 1

If Empty(cEtiProd)
	Return .f.
EndIf 

aSave := VTSAVE()
 
Begin Sequence
	
	cEtiqueta:= cEtiProd
		
	If !CBLoad128(@cEtiqueta)
		cMsg:=""
		Break
	EndIf
		
	If !CbRetTipo(cEtiqueta) $ "EAN8OU13-EAN14-EAN128"
		cMsg := "Etiqueta invalida"  
		Break
	EndIf
	
	//Ponto de Entrada CBRETEAN ativo - Retorno: {cEti,0,cLote,0,0,cLoteFor}
	//Foi mantido mesmo quando as informacoes na etiqueta foi dividida em outros codigos de Barras
	aEtiqueta := CBRetEtiEan(cEtiqueta)
	
	If len(aEtiqueta) == 0
		cMsg := "Etiqueta invalida"  
		Break
	EndIf 
	
	cProduto	:=	aEtiqueta[1]
	//cLote  		:= 	aEtiqueta[3]
	//cLotefor	:= 	aEtiqueta[6]
	
	If cOpcSep == 1 //Por Ordem do Pedido
		//Verifica Produto	
		If SC6->C6_PRODUTO <> cProduto
			cMsg := "Produto difere da Ordem do Pedido." 
			Break
		EndIf
	Else
		//Verifica se Produto faz parte do Pedido
		SC6->(DbSetOrder(2))//filial+produto+pedido
		If !SC6->(DbSeek(xFilial("SC6")+cProduto+cpedido))
			cMsg := "Produto nao faz parte do Pedido." 
			Break 
		ElseIf SC6->C6_QTDVEN == SC6->C6_QTDEMP // ja separado 
			cMsg := "Produto ja Separado." 
			Break
		ElseIf (SC6->C6_QTDVEN-SC6->C6_QTDENT)+SC6->C6_QTDEMP == 0	// Produto ja Faturado 
			cMsg := "Produto ja Faturado." 
			Break
		Endif	
	Endif
	
	If Rastro(cProduto)
		//Solicita Lote 
		VtClear()
		If VtModelo()=="RF"	
			@ 0,0 VTSay "Declaracao do Lote"
			@ 2,0 VTSay "Produto:"
			@ 3,0 VTSay cProduto
			@ 5,0 VTSay "Leia o Lote" 
			@ 6,0 VTGet clote pict "@!" VALID  VldLote(clote)
		Else
			VtClear()
			@ 0,0 VTSay "Leia o Lote " 
			@ 1,0 VTSay "Produto" 	VTGet clote pict "@!" VALID  VldLote(clote)
		EndIf
		
		VTRead		
		If VTLastkey() == 27
			VtRestore(,,,,aSave)
			Return .F.
		Endif
	Else
		cMsg := "Produto nâo controla Rastro."			             
		lErrQTD := .t.
		Break
		//clote:=""
	Endif
			
	//Validação da Quantidade informada para Separacao 
   	If !VldQtdSld (@nQtde,cProduto,cArmazem,cLote)
   		lErrQTD := .t.
   		cMsg := "" 
		Break
	Endif
			
	If SuperGetMv("MV_ESTNEG") =="N" 	
		If Localiza(SC6->C6_PRODUTO)
			nSaldo := SaldoSBF(cArmazem,/*cEndereco*/,SC6->C6_PRODUTO,/*cNumSer*/,cLote,/*cSLote*/)
		Else
			SB2->(DbSetOrder(1))
			SB2->(DbSeek(xFilial("SB2")+SC6->C6_PRODUTO+cArmazem))
			nSaldo := SaldoSB2()
		EndIf		
		If aEtiqueta[2]*nQtde > nSaldo
			cMsg := "SBF Saldo insuficiente."			             
			lErrQTD := .t.
			Break
		EndIf		
	EndIf
	
	
//|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|	
//Gera SC9 liberando o Produto e Quantidade Separada - Realiza Transferencia se Necessario
//|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|
	
	//Posiciona SB8 correspondente
	If Rastro(cProduto)
		SB8->(DbSetOrder(3))//filial+produto+local+lotectl+numlote
		SB8->(DbSeek(xFilial("SB8")+cProduto+cArmazem+cLote))
	EndIf
		
	Begin Transaction
	
   		//Verifica se necessita fazer Transferencia	   		
		If SC6->C6_LOCAL <> cArmazem 
			If !ROTTRANS(cProduto,SC6->C6_LOCAL,cLote,nQtde)	//Executa a Transferenica de Armazem
				cMsg:=""
				Break
			Endif
		Endif
		 	 
		aSaldos := {}
		aSaldos := {{ cLote,"","","",nQtde,ConvUm(cProduto,0,2,nQtde),Ctod(""),"","","",SC6->C6_LOCAL,0}}
		
		VtMsg("Liberando Item...")
   		MaLibDoFat	(SC6->(Recno()),nQtde,.T.,.T.,.T.,.T.,.T.,.T.,NIL,NIL,aSaldos,NIL,NIL,NIL)
		MaLiberOk	({SC6->C6_NUM},.F.)	
							
	End Transaction	
			
Recover

	If ! Empty(cMsg)
		VtAlert(cMsg,"Aviso",.t.,3000,4)
	EndIf
	
	VtRestore(,,,,aSave)
	VtClearBuffer()
	VtClearGet("cEtiProd")
	VtGetSetFocus("cEtiProd")
	
	If  lForcaQtd .and. lErrQTD
		VtGetSetFocus("nQtde")
	EndIf
	
	DisarmTransaction() 
	
	Return .f.
	
End Sequence

Return .t.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ VldLote  ³ Autor ³ Luiz Enrique          ³ Data ³ 07/12/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Valida o Lote podendo sugerir o Armazem		              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ HCI		                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function VldLote(clote)

	If !Empty(SC6->C6_LOTECTL) .And. SC6->C6_LOTECTL <> cLote
		VtAlert("Lote Difere do declarado no pedido: " + Alltrim(SC6->C6_LOTECTL ),"Aviso",.t.,3000,4)
		Return .F.
	Endif
	
	//Obtem Armazens referentes ao Lote especificado na Etiqueta
	SB8->(DbSetOrder(5))//filial+produto+lotectl+numlote
	SB8->(DbSeek(xFilial("SB8")+cProduto+cLote))
	aArmzs:={} 
	While SB8->(! Eof() .and. B8_FILIAL+B8_PRODUTO+B8_LOTECTL == xFilial("SB8")+cProduto+cLote)
		If Ascan(aArmzs,{|x| x == SB8->B8_LOCAL}) == 0 
			Aadd(aArmzs,SB8->B8_LOCAL)
		Endif
		SB8->(DbSkip())
	EndDo 
	
	If Len(aArmzs) > 01 // Solicita o Armazem 
		
		aSave := VTSAVE()
		VtClear()		
			
		If VtModelo()=="RF"
			@ 0,0 VTSay "Declaracao do Local "
			@ 2,0 VTSay "Lote: " + Alltrim(cLote)
			@ 3,0 VTSay "Armazem:  " VTGet cArmazem pict "@!" valid VldArm (cArmazem,aArmzs,cLote)
   		Else
			@ 0,0 VTSay "Informe o Armazem:  " VTGet cArmazem pict "@!" valid VldArm (cArmazem,aArmzs,cLote) 
		EndIf
		 	
		VTRead 
		If VTLastKey() == 27 
			VtAlert("Armazem nao declarado!","Aviso",.t.,3000,4)
			VtRestore(,,,,aSave)
	 		Return .F.
		EndIf
			
		VtRestore(,,,,aSave)
		
	Elseif Len(aArmzs) == 01
		cArmazem:= aArmzs[1]
	Else
		cArmazem:= 0
		VTAlert("Lote Inexistente!","Aviso",.T.,3000,3)
		Return .F.
	Endif 

Return .T. 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ VldArm ³ Autor ³ Luiz Enrique          ³ Data ³ 07/12/07   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Valida o Armazem								              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ HCI		                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/ 
Static Function VldArm (Armz,aArmzs,clote) 

If Ascan(aArmzs,{|x| x == cArmazem}) == 0
	VTAlert("Armazem invalido para o Lote " + cLote,"Aviso",.t.,3000) 
	VtClearBuffer()
	Return .F.
Endif 

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ VldQtdSld³ Autor ³ Luiz Enrique          ³ Data ³ 07/12/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Valida Quantiade Digitada com Saldo Disponivel             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ HCI		                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/ 
Static Function VldQtdSld (nQtde,cProduto,cLocal,cLoteCTL) 

Local nSldSb8	:= 0
		//	SaldoLote(cProduto,cLocal,cLoteCTL,cNumLote	,lBaixaEmp	,lConsVenc	,lConsClas	,dDataRef)
nSldSb8	:=	SaldoLote(cProduto,cLocal,cLoteCTL,			,.F.		,.F.		,.T.		,ddatabase)

If nSldSb8== 0
	VTAlert("Lote sem Saldo","Aviso",.T.,3000,3)
	Return .F.
Elseif nQtde > (SC6->C6_QTDVEN - SC6->C6_QTDEMP)
	VTAlert("Quantidade maior que necessario","Aviso",.T.,3000,3) 
	Return .F.
Elseif nSldSb8 < nQtde
	If !VtYesNo("Saldo do Lote: " + Strzero(nSldSb8,6)+ ". Aceita esta quantidade ?","Atencao",.t.)  
		Return .F. 
	Else
	   	nQtde:=nSldSb8
	EndIf			
Endif

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ Informa    ³ Autor ³ ACD                 ³ Data ³ 31/01/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Mostra produtos que ja foram lidos                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ SIGAACD                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function Informa() 

Local aCab,aSize,aSave := VTSAVE()
Local aTemp:={}
Local nTam
Local aSC6	:= SC6->(GetArea('SC6'))

VTClear()

aCab  := {"Produto","Local","Separado","A Separar","Lote"} 

nTam := len(aCab[4])
If nTam < len(Transform(0,cPictQtdExp))
	nTam := len(Transform(0,cPictQtdExp))
EndIf

aSize := {15,5,nTam,nTam,10}

SC6->(DBSetOrder(1)) //FILIAL+PEDIDO
SC6->(DbSeek(xFilial("SC6")+cPedido))

While SC6->(! Eof() .And. C6_FILIAL+C6_NUM ==xFilial("SC6")+cPedido)
	aadd(aTemp,{SC6->C6_PRODUTO,SC6->C6_LOCAL,;
				Transform(SC6->C6_QTDEMP,cPictQtdExp),;
				Transform((SC6->C6_QTDVEN-SC6->C6_QTDEMP),cPictQtdExp),;
				SC6->C6_LOTECTL})	  		
	SC6->(DbSkip())	
EndDo
 
VTaBrowse(,,,VtMaxCol(),aCab,aTemp,aSize)
VtRestore(,,,,aSave)

SC6->(RestArea(aSC6))

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ Estorna  ³ Autor ³ Luiz Enrique          ³ Data ³ 12/12/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Permite realizar Estorno total ou PArcial dos Itens        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ HCI	                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function Estorna()

Local aCab,aSize,aSave := VTSAVE()
Local nQtde		:= 0
Local nNovaQtd	:= 0
Local nPos
Local lFat		:= .T.
Local aTemp		:={}
Local aSaldos	:={}

aCab  := {"Produto","Local","Lote","Separado","Item","Sequencia"} 
aSize := {15,5,10,10,4,4}

SC6->(DBSetOrder(1)) //FILIAL+PEDIDO
SC9->(DBSetOrder(1)) //FILIAL+PEDIDO 

If !SC9->(DbSeek(xFilial("SC9")+cPedido))
	VTAlert("Não existem Itens a Estornar","IMPOSSIVEL ESTORNAR",.T.,3000,3)
	Return .F.
Endif

While SC9->(! Eof() .And. C9_FILIAL+C9_PEDIDO ==xFilial("SC9")+cPedido)
	If Empty(SC9->C9_NFISCAL)
		aadd(aTemp,{SC9->C9_PRODUTO,SC9->C9_LOCAL,SC9->C9_LOTECTL,Transform(SC9->C9_QTDLIB,cPictQtdExp),;
					SC9->C9_ITEM,SC9->C9_SEQUEN})
		lFat:= .F. 
	Endif				  		
	SC9->(DbSkip())	
EndDo

If lFat //Todos os Itens estao Faturados
	VTAlert("Todos os Itens ja Faturados","IMPOSSIVEL ESTORNAR",.T.,3000,3)
	Return .F.
Endif

While .t.
    
	VtClear()
	nPos := VTaBrowse(,,,VtMaxCol(),aCab,aTemp,aSize,nPos)
	VtClear()
	
	If VTLastkey() == 27
		Return
	Endif
	      
	VtClearBuffer()
	nQtde:=Val(aTemp[npos,4])
	If VtModelo()=="RF"	
		@ 1,0 VtSay ("Estorno de: " + cPedido)
		@ 2,0 VtSay "Produto: "		+ Alltrim(aTemp[npos,1])
		@ 3,0 VtSay "Separado: " 	+ Alltrim(aTemp[npos,4])				
		@ 5,0 VTSay "Qtde " VtGet nQtde pict cPictQtdExp valid nQtde > 0 
	Else // para microterminal 44 e 16 teclas
		VtClear()
		@ 0,0 VtSay "Produto: " + aTemp[npos,1]
		@ 1,0 VTSay "Qtde " 	VtGet nQtde pict cPictQtdExp valid nQtde > 0 		
	EndIf
	
	VTRead		
	If VTLastkey() == 27		
		If VTYesNo("Deseja Sair ?","ESTORNO",.T.)
			Return .F.
		Else
			Loop
		Endif		 		
	Endif
	
	//Valida Quantidade
	If nQtde > Val(aTemp[npos,4]) 
		VTAlert("Quantidade maior que a separada.","IMPOSSIVEL ESTORNAR",.T.,3000,3)
		Loop 
	Endif
	
	If !VTYesNo("Confirma o Estorno ?","ESTORNO",.T.)
		Loop
	Endif
	
	Begin Transaction
	
		//Posiciona no Item SC9 a Estornar 
		SC9->(DbSeek(xFilial("SC9")+cPedido+aTemp[npos,5]+aTemp[npos,6])) 
		    	    
	    VtMsg("Estornando Item...")
	     
	    //Estorna a Quantidade Total, independente da Quantidade digitada eliminando o Item do SC9
   		A460Estorna	(.T.,.T.)	//(lMata410,lAtuEmp,nVlrCred) 
   		 		
   		//Atualiza Array com os itens a Estornar
   		If 	Val(aTemp[npos,4])== nQtde //Estornou toda Quantidade do Item
   			Adel	(aTemp,npos)
			Asize	(aTemp,Len(aTemp)-1)
		Else	//Estornou Parcial
			//Gera novo SC9 (Liberado) somente do Quantidade restante		    
			aTemp[npos,4]:= Alltrim( Str(Val(aTemp[npos,4])-nQtde))
			nNovaQtd:= Val(aTemp[npos,4])			
			VtMsg("Reliberando Item...")
			//Posicona em SC6
			SC6->(DbSeek(xFilial("SC6")+cPedido+aTemp[npos,5]+aTemp[npos,1]))
			aSaldos := {}
			aSaldos := {{ Alltrim(aTemp[npos,3]),"","","",nNovaQtd,ConvUm(Alltrim(aTemp[npos,1]),0,2,nNovaQtd),Ctod(""),"","","",SC6->C6_LOCAL,0}}
	   		MaLibDoFat	(SC6->(Recno()),nNovaQtd,.T.,.T.,.T.,.T.,.T.,.T.,NIL,NIL,aSaldos,NIL,NIL,NIL)
			MaLiberOk	({SC6->C6_NUM},.F.)				
		Endif 
		
		SC5->(Reclock('SC5',.F.))
		SC5->C5_STASEP	 := "1" //Retorna para: "Em Andamento"		
		SC5->(MsUnlock())
   		
  	End Transaction
	
Enddo  

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³RotTrans	³ Autor ³ Luiz Enrique          ³ Data ³ 13/11/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Executa Transferencia utilizando Rotina Automantica MATA261³±± 
±±³          ³ caso o Armazem ou Lote do Produto separado seja(m)  		  ³±± 
±±³          ³ diferente(s) do declarado no Pedido de Vendas.			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ HCI	                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/  
Static Function RotTrans (cProdut,cArmDes,cLote,nQuant)

	//SB8 DEVE ESTAR POSICIONADO
    
	Local cArmOri	:=	SB8->B8_LOCAL
	Local dValid 	:= 	SB8->B8_DTVALID
	Local aTransf	:={}
	Local cDoc		:= ""
		
	lMsErroAuto 	:= .F.
	lMsHelpAuto 	:= .T.
			
	SB1->(dbSeek(xFilial("SB1")+cProduto))
	dValid := dDatabase+SB1->B1_PRVALID   
			
	aTransf:=Array(2)
	aTransf[1] := {cDoc,dDataBase}
	aTransf[2] := {	SB1->B1_COD		,;
					SB1->B1_DESC	,;
					SB1->B1_UM		,;
					cArmOri			,;
					Space(15)		,;
					SB1->B1_COD		,;
					SB1->B1_DESC	,;
					SB1->B1_UM		,;
					cArmDes			,;
					Space(15)		,;
					""				,; 	
					cLote			,;
					""				,;	
					dValid			,;
					criavar("D3_POTENCI"),;
					nQuant			,;
					criavar("D3_QTSEGUM"),;
					criavar("D3_ESTORNO"),;
					criavar("D3_NUMSEQ"),;
					""				,;	
					dValid}
					
	VtMsg("Transf.: " + Alltrim(cArmOri) + " -> " + Alltrim(cArmDes))
		
	CBLog("02",{SB1->B1_COD,nQuant,cLote,/*sublote*/,cArmOri,,cArmDes})
	
	MSExecAuto({|x| MATA261(x)},aTransf) 
	
	If lMsErroAuto
		MostraErro()
		VTALERT("Falha na transferencia","ARMAZENS",.T.,3000,3) 
		Return .f.
	EndIf
				
Return .t.  


//Verifica se variavel esta em branco, caso esteja chama consulta F3 da mesma
Static Function VldGet(cVar)
If Empty(cVar)
	VtKeyBoard(chr(23))
	Return .F.
EndIf

Return .T.  
