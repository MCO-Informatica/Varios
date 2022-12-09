#Include "RWMAKE.CH"
#Include "TOPCONN.CH"
#Include "Protheus.Ch"
#include "TbiConn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MTDGPERD   ºAutor  ³ Luiz Alberto     º Data ³  29/09/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PE executado Apontamento de Perda para Trazer o aCols
±±º          ³ preenchido conforme estrutura do produto      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºOBS       ³ Antigo A410EXC                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MTDGPERD()                                                 
Local aArea := GetArea()     
Local cQuery := ''      
Local cNumOp := PARAMIXB[2]

nTam := TamSX3("D4_OP")[1]
cOrdemP := PADR(PARAMIXB[2],nTam)
cProduto:= M->H6_PRODUTO
nQtdeSBC:= M->H6_PERDCUS

/*
cQuery += " SELECT * FROM " + RetSqlName("SD4") + " D4 "
cQuery += " WHERE LEFT(D4_OP,8) = '" + Left(cNumOp,8) + "' AND D4_LOCAL = '01' AND D_E_L_E_T_ = '' "
cQuery += " ORDER BY R_E_C_N_O_ DESC "
                                      
cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"CAD",.T.,.T.)

If CAD->(!Eof())
	aCols := {}
	While CAD->(!Eof())
		AAdd(aCols,Array(Len(aHeader)+1))
		// Preenche acols com o padrão dos campos depois alimenta com conteudo da Query
		For nCntBsc	:= 1 To Len(aHeader)
			If !aHeader[nCntBsc,2] $ "BC_ALI_WT/BC_REC_WT"
				aCols[Len(aCols)][nCntBsc] := CriaVar(aHeader[nCntBsc][2])
			EndIf
		Next nCntBsc		
		aCols[Len(aCols),nPosCod] 		:= CAD->D4_COD
		aCols[Len(aCols),nPosLoc] 		:= CAD->D4_LOCAL
		aCols[Len(aCols),nPosDesc] 		:= Posicione("SB1",1,xFilial("SB1")+AllTrim(CAD->D4_COD),"B1_DESC")
		aCols[Len(aCols),nPosLocDes] 	:= 'SC'
		aCols[Len(aCols),nPosTipo] 		:= 'R'
		aCols[Len(aCols),nPosProDes] 	:= 'SUCATAS'
		aCols[Len(aCols),Len(aHeader)+1] := .F.
		
		CAD->(dbSkip(1))
	Enddo
Endif
CAD->(dbCloseArea())

*/

Nivel1Exp(cOrdemP,cProduto,nQtdeSBC)

RestArea(aArea)
Return Nil
			





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±                                                	
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ A685Mtela  ºAutor Gabriela Kamimoto   º Data ³  07/12/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Monta a tela de Explosão do 1º nível da estrutura          º±±
±±º          ³ na rotina Apotamento de Perda.                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MATA685                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±          
*/
Static Function Nivel1Exp(cOrdemP,cProduto,nQtdeSBC)
Local oDlg         
Local oOp
Local oProduto
Local oQtde       
Local lOk		 := .f.
Local aArrayAux	 := {}
Local nX       := 0
Local nAcuSDC	 := 0
Private	lEmpPrev		:= If(SuperGetMV("MV_QTDPREV")== "S",.T.,.F.)

DEFAULT nQtdeSBC	 := 0 

	DEFINE MSDIALOG oDlg FROM 140,000 TO 280,340 TITLE OemToAnsi("Explosão do 1º nível da estrutura") PIXEL //"Explosão do 1º nível da estrutura"
	@ 0.9,01 SAY OemToAnsi("Ordem de Produção") SIZE 15,10 OF oDlg //"Ordem de Produção"
	@ 2.1,01 SAY OemToAnsi("Produto") SIZE 10,10 OF oDlg //"Produto"
	@ 3.3,01 SAY OemToAnsi("Qtde. Perd") SIZE 5,10  OF oDlg //"Qtde. Perd"
	@ 10,60 MSGET oOp VAR cOrdemP Picture PesqPict("SBC","BC_OP") When .F. Valid (NaoVazio(cOrdemP)) SIZE 100,9 OF oDlg PIXEL
	@ 25,60 MSGET oProduto VAR cProduto Picture PesqPict("SBC","BC_PRODUTO") When .F. Valid (NaoVazio(cProduto)) SIZE 100,9 OF oDlg PIXEL
	@ 40,60 MSGET oQtde VAR nQtdeSBC Picture PesqPict("SC2","C2_QUANT")Valid !(Empty(cOrdemP)) .And. (Positivo(nQtdeSBC)) .And. (NaoVazio(nQtdeSBC))  When .f. SIZE 100,9 OF oDlg PIXEL
	
	DEFINE SBUTTON FROM 55,63 TYPE 1 ACTION (lOK := .T.,oDlg:End()) ENABLE OF oDlg
	DEFINE SBUTTON FROM 55,90 TYPE 2 ACTION (lOk := .F.,oDlg:End()) ENABLE OF oDlg
	ACTIVATE MSDIALOG oDlg CENTERED	                       

//Apos a confirmacao da explosao, calcula e preenche os campos BC_PRODUTO, BC_LOCORIG, BC_QUANT.

If lOk
	SD4->(DbSetOrder(2))
	SD4->(DbSeek(xFilial("SD4")+cOrdemP))
	SDC->(DbSetOrder(2))
	
	// Se a primeira linha esta em branco remove a mesma do acols
	If Empty(aTail(aCols)[GDFieldPos("BC_PRODUTO")])
		aDel(aCols,Len(aCols))
		aSize(aCols,Len(aCols)-1)
	EndIf
	While !SD4->(Eof()) .And. SD4->(D4_FILIAL+D4_OP) == xFilial("SD4")+cOrdemP
		If SD4->D4_QTDEORI < 0
			SD4->(DbSkip())
			Loop
		EndIf	
		If SB1->(dbSetOrder(1), dbSeek(xFilial("SB1")+SD4->D4_COD)) .And. AllTrim(SB1->B1_TIPO) $ 'MO'
			SD4->(DbSkip())
			Loop
		EndIf	                                                                                     
		
//		If (AllTrim(SB1->B1_TIPO) $ 'BN' .And. SB1->B1_LOCPAD == 'SR')
//			SD4->(DbSkip())
//			Loop
//		EndIf	                                                                                     


/*		nSaldo:=0
		If SB8->(dbSetOrder(3), dbSeek(xFilial("SB8")+SD4->D4_COD+SD4->D4_LOCAL+Left(cOrdemP,8)))
			While SB8->(!EOF()) .And. AllTrim(xFilial("SB8")+SD4->D4_COD+SD4->D4_LOCAL+Left(cOrdemP,8))==AllTrim(SB8->(B8_FILIAL+B8_PRODUTO+B8_LOCAL+B8_LOTECTL))
				nSaldo+=SB8SALDO(,,,,,lEmpPrev,,,.T.)
											
				SB8->(dbSkip(1))
			Enddo
		Endif

		If Empty(nSaldo)
			SD4->(DbSkip(1))
			Loop
		EndIf	*/

		nAcuSDC := (SD4->D4_QTDEORI / SC2->C2_QUANT) * nQtdeSBC
		aArrayAux := {}
				
		SDC->(DbSeek(xFilial("SDC")+SD4->D4_COD+SD4->D4_LOCAL+cOrdemP+SD4->(D4_TRT+D4_LOTECTL+D4_NUMLOTE)))
		While !SDC->(Eof()) .And. SDC->(DC_FILIAL+DC_OP+DC_TRT+DC_LOTECTL+DC_NUMLOTE) == xFilial("SDC")+Left(cOrdemP,8)+SD4->(D4_TRT+D4_LOTECTL+D4_NUMLOTE)
			For nX := 1 to Len(aHeader)
				Do case
		 		Case nX == GdFieldPos("BC_PRODUTO")
		 			AAdd(aArrayAux,SDC->DC_PRODUTO)
		 		Case nX == GdFieldPos("BC_LOCORIG")
		 			AAdd(aArrayAux,SDC->DC_LOCAL)
		 		Case nX == GdFieldPos("BC_QUANT")
		 			AAdd(aArrayAux,(SDC->DC_QTDORIG / SC2->C2_QUANT) * nQtdeSBC)
		 		Case nX == GdFieldPos("BC_LOTECTL")
		 			AAdd(aArrayAux,SDC->DC_LOTECTL)
		 		Case nX == GdFieldPos("BC_NUMLOTE")
		 			AAdd(aArrayAux,SDC->DC_NUMLOTE)
		 		Case nX == GdFieldPos("BC_LOCALIZ")
		 			AAdd(aArrayAux,SDC->DC_LOCALIZ)
		 		Case nX == GdFieldPos("BC_NUMSERI")
		 			AAdd(aArrayAux,SDC->DC_NUMSERI)
			 	Case nX == GdFieldPos("BC_DATA")
			 		AAdd(aArrayAux,dDataBase)	
		 		Case nX == (Len(aHeader)-1)
		 			AAdd(aArrayAux,"SBC")
		 		Case nX == (Len(aHeader))
		 			AAdd(aArrayAux,0)	
		 		Otherwise
		 			AAdd(aArrayAux,CriaVar(Alltrim(aHeader[nX,2]),.F.))
		 		EndCase 
			Next nX            
			nAcuSDC -= (SDC->DC_QTDORIG / SC2->C2_QUANT) * nQtdeSBC
			AAdd(aArrayAux,.F.)
	 		AAdd(aCols,aArrayAux)
	 		aArrayAux := {}
	 		SDC->(DbSkip()) 
		End
		
		If nAcuSDC > 0 	
	 		For nX := 1 to Len(aHeader)
		 		Do case
		 		Case nX == GdFieldPos("BC_PRODUTO")
		 			AAdd(aArrayAux,SD4->D4_COD)
		 		Case nX == GdFieldPos("BC_LOCORIG")
		 			AAdd(aArrayAux,SD4->D4_LOCAL)
		 		Case nX == GdFieldPos("BC_QUANT")
		 			AAdd(aArrayAux,nAcuSDC)
		 		Case nX == GdFieldPos("BC_LOTECTL")
			 		AAdd(aArrayAux,SD4->D4_LOTECTL)
			 	Case nX == GdFieldPos("BC_NUMLOTE")
			 		AAdd(aArrayAux,SD4->D4_NUMLOTE)	
			 	Case nX == GdFieldPos("BC_TIPO")
			 		AAdd(aArrayAux,"R")	
			 	Case nX == GdFieldPos("BC_CODDEST")
			 		AAdd(aArrayAux,"SUCATAS")	
			 	Case nX == GdFieldPos("BC_LOCAL")
			 		AAdd(aArrayAux,"SC")	
			 	Case nX == GdFieldPos("BC_DATA")
			 		AAdd(aArrayAux,dDataBase)	
		 		Case nX == (Len(aHeader)-1)
		 			AAdd(aArrayAux,"SBC")
		 		Case nX == (Len(aHeader))
		 			AAdd(aArrayAux,0)	
		 		Otherwise
		 			AAdd(aArrayAux,CriaVar(Alltrim(aHeader[nX,2]),.F.))
		 		EndCase 
		 	Next nX              
		 	AAdd(aArrayAux,.F.)
	 		AAdd(aCols,aArrayAux)
 		EndIf 		
 		
 		//Validacao do gatilho
		If ExistTrigger("BC_QUANT")
			RunTrigger(2,Len(aCols),,"BC_QUANT")
		EndIf
 		SD4->(DbSkip()) 
 	EndDo		                                               
EndIf
Return                                     

User Function MotPerd(nPos)
Local aArea := GetArea()
Local nPosMot := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == 'BC_MOTIVO' })
Local nPosDsc := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == 'BC_DESCRI' })
Local cCodMot := Space(TamSX3("BC_MOTIVO")[1])
Local cDscMot := Space(TamSX3("BC_DESCRI")[1])

If nPosMot > 0
	cCodMot := M->BC_MOTIVO                      
	cDscMot := Tabela('43',cCodMot)
Endif                                   

If !Empty(cCodMot)
	For nIte := nPos+1 To Len(aCols)
		aCols[nIte,nPosMot] := cCodMot
		aCols[nIte,nPosDsc] := cDscMot
	Next
Endif

RestArea(aArea)
SysRefresh()
Return .t.