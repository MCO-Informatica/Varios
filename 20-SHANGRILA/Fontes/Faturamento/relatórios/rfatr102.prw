#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ RFATR102  ³ Autor ³ FELIPE VALENÇA         ³ Data ³ 31/01/2012 ³±±
±±³          ³          ³       ³                         ³      ³            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Impressao Etiquetas                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³ Etiqueta Codigo de Barras                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³             ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador   ³  Data  ³              Motivo da Alteracao                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RFATR102()

Local aArea		:= GetArea()
Local aAreaSA1	:= SA1->(GetArea())
Local aAreaSC5	:= SC5->(GetArea())
local x

Private cQuery
Private cPerg			:= PadR("RFATR102",Len(SX1->X1_GRUPO))
Private cCliPed		:= ""
Private cLjPed		:= ""
Private cCliente		:= ""
Private cPedido			:= ""
Private lPassou			:= .F.

ValidPerg()

If !pergunte(cPerg,.T.)
	Return
Endif

//cQuery := "SELECT C5_CLIENTE, C5_LOJACLI, C5_NUM FROM SC5010 WHERE D_E_L_E_T_ = ' ' AND C5_CLIENTE = '"+MV_PAR01+"' AND C5_LOJACLI = '"+MV_PAR02+"' AND C5_NUM = '"+MV_PAR03+"' ORDER BY C5_NUM "
//dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "TRB", .F., .T.)

//DBSELECTAREA("TRB")
//DBGOTOP()

//cCliente := UPPER(MV_PAR01) //Posicione("SA1",1,xFilial("SA1")+MV_PAR01+MV_PAR02,"A1_NOME")
cPedido 	:= MV_PAR01
cCliPed 	:= Posicione("SC5",1,xFilial("SC5")+cPedido,"C5_CLIENTE")
cLjPed 		:= Posicione("SC5",1,xFilial("SC5")+cPedido,"C5_LOJACLI")
cCliente	:= Posicione("SA1",1,xFilial("SA1")+cCliPed+cLjPed,"A1_NOME")
cCliente	:= substr(cCliente,1,len(cCliente)-8)

MSCBPRINTER("S500-8","LPT1",,,.f.,) //Setei Impressora Eltron pois OS 214 ou ARGOX ou ALLEGRO nao imprime nada.
MSCBCHKSTATUS(.F.) //status da impressora, se .F. imprime mesmo com problema de impressora, se .T. nao imprime
MSCBBEGIN(val(mv_par02),5)

If Len(Alltrim(cCliente)) > 10
	for x:= Len(Alltrim(cCliente)) to 1 Step -1
		If x <= 10 //> Len(Alltrim(cProduto))
			//	   		If (" " $ Substr(Alltrim(cProduto),x,Len(Alltrim(cProduto))) .and. x <= 20 )
			
			If (" " $ Substr(Alltrim(cCliente),x,1) )	
	
	            /* //bloco original
				//etiqueta1
				MSCBSAY(22,05,Substr(Alltrim(cCliente),1,x),"R","B","24,24")
				MSCBSAY(17,05,Substr(Alltrim(cCliente),x+1,Len(Alltrim(cCliente))),"R","0","28,28")
				MSCBSAY(09,05,"PD: "+cPedido,"R","0","37,37")

				MSCBSAY(50,05,Substr(Alltrim(cCliente),1,x),"R","B","24,24")
				MSCBSAY(45,05,Substr(Alltrim(cCliente),x+1,Len(Alltrim(cCliente))),"R","0","28,28")
				MSCBSAY(37,05,"PD: "+cPedido,"R","0","37,37")

			
			
				//etiqueta2
				MSCBSAY(76,05,Substr(Alltrim(cCliente),1,x),"R","B","27,24")
				MSCBSAY(71,05,Substr(Alltrim(cCliente),x+1,Len(Alltrim(cCliente))),"R","0","28,28")
				MSCBSAY(63,05,"PD: "+cPedido,"R","0","37,37")

				MSCBSAY(102,05,Substr(Alltrim(cCliente),1,x),"R","B","24,24")
				MSCBSAY(97,05,Substr(Alltrim(cCliente),x+1,Len(Alltrim(cCliente))),"R","0","28,28")
				MSCBSAY(89,05,"PD: "+cPedido,"R","0","37,37")
			    */

   				//etiqueta1
				MSCBSAY(20,05,Substr(Alltrim(cCliente),1,x),"R","B","24,24")
				MSCBSAY(15,05,Substr(Alltrim(cCliente),x+1,Len(Alltrim(cCliente))),"R","0","28,28")
				MSCBSAY(07,05,"PD: "+cPedido,"R","0","37,37")

				MSCBSAY(48,05,Substr(Alltrim(cCliente),1,x),"R","B","24,24")
				MSCBSAY(43,05,Substr(Alltrim(cCliente),x+1,Len(Alltrim(cCliente))),"R","0","28,28")
				MSCBSAY(35,05,"PD: "+cPedido,"R","0","37,37")
			
				//etiqueta2
				MSCBSAY(74,05,Substr(Alltrim(cCliente),1,x),"R","B","27,24")
				MSCBSAY(69,05,Substr(Alltrim(cCliente),x+1,Len(Alltrim(cCliente))),"R","0","28,28")
				MSCBSAY(61,05,"PD: "+cPedido,"R","0","37,37")

				MSCBSAY(99,05,Substr(Alltrim(cCliente),1,x),"R","B","24,24")
				MSCBSAY(94,05,Substr(Alltrim(cCliente),x+1,Len(Alltrim(cCliente))),"R","0","28,28")
				MSCBSAY(86,05,"PD: "+cPedido,"R","0","37,37")
				lPassou := .T.
			Endif
		Endif
		
		If lPassou
			Exit
		Endif
	next
Endif

MSCBEND() //Fim da Imagem da Etiqueta
MSCBCLOSEPRINTER()

//DBCLOSEAREA("TRB") 

RestArea(aArea)
RestArea(aAreaSA1)
RestArea(aAreaSC5)

Return

*---------------------------------*
Static Function ValidPerg()
*---------------------------------*

	Local _sAlias := Alias()
	Local aRegs := {}
	Local i,j

	DBSelectArea("SX1") ; DBSetOrder(1)
	cPerg := PADR(cPerg,10)
	
	// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
	//AADD(aRegs,{cperg,"01","Cliente:"		,"","","mv_ch1","C", 30,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""})
	//AADD(aRegs,{cperg,"02","Loja:"			,"","","mv_ch2","C", 2,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cperg,"01","Pedido:"		,"","","mv_ch1","C", 6,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SC5"})
	AADD(aRegs,{cperg,"02","Quantidade:"	,"","","mv_ch1","C", 4,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""})

	For i:=1 to Len(aRegs)
		If !dbSeek(cPerg+aRegs[i,2])

			RecLock("SX1",.T.)
		Else
			RecLock("SX1",.F.)
		EndIf
		
			For j:=1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				EndIf
			Next
			MsUnlock()
			

		//EndIf 
	Next    
	DBSelectArea(_sAlias)
Return
                              