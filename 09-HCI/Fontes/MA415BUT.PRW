#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MA415BUT  ºAutor  ³Rafael Marim        º Data ³  02/15/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada para adicionar um botao na enchoice da    º±±
±±º          ³ tela de orcamento                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP8    HCI                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function MA415BUT()
Local   aUsuBut:= {}
	IF cPaisLoc == "BRA"
		Aadd(aUsuBut, {"PARAMETROS",{|| u_AtuaOrc()}, OemToAnsi("Importar") })
		Aadd(aUsuBut, {"PARAMETROS",{|| u_TelaPV()},  OemToAnsi("Rateio") })
    	AADD(aUsuBut, {"PARAMETROS",{|| u_AtPreco()}, OemToAnsi("Atribui") })
    	aAdd(aUsuBut, {PmsBExcel()[1],{|| DlgToExcel({{"CABECALHO","Cabecalho do Orçamento",{RetTitle("CJ_NUM"),RetTitle("CJ_CLIENTE"),RetTitle("CJ_LOJA"),RetTitle("CJ_XNREDUZ"),RetTitle("CJ_EMISSAO")},{M->CJ_NUM,M->CJ_CLIENTE,M->CJ_LOJA,M->CJ_XNREDUZ,M->CJ_EMISSAO}},{"GETDADOS","Itens do Orçamento",aHeader,macolsck(aHeader)}})},PmsBExcel()[2],PmsBExcel()[3]})
		//    aAdd(aBut110 ,{PmsBExcel()[1],{|| DlgToExcel({{"CABECALHO","                      ",{RetTitle("C1_NUM") ,RetTitle("C1_SOLICIT"),RetTitle("C1_EMISSAO"),RetTitle("C1_FILENT")                    },{cA110Num,cSolic ,dA110Data,cFilEnt                   }},{"GETDADOS","",aHeader,aCols}})},PmsBExcel()[2],PmsBExcel()[3]})
	ELSE		
		**RegToMemory( "SC5", .F., .F. )
		AAdd(aUsuBut  ,{ "CONTAINR", {|| U_ORCHCIbr() }, OemToAnsi('Importa Itens (F7)') , OemToAnsi('Importa Itens HCI (F7) ') } )       
		SetKey( VK_F7, {|| U_ORCHCIbr()} )  
	EndIF	
Return(aUsuBut)





Static Function macolsck(aHeader)

Local Acols:={}
Local nCntFor:=0
Local cArqQry := "TMP1"
aAreaTMP1 := TMP1->( GetArea() )
dbSelectArea("TMP1")
TMP1->(dbGoTop())
While TMP1->(!Eof())    
	AADD(aCols,Array(Len(aHeader)))
	For nCntFor:=1 To Len(aHeader)
		If (aHeader[nCntFor,10] <>  "V")
			aCOLS[Len(aCols)][nCntFor] := FieldGet(FieldPos(aHeader[nCntFor,2]))
		Else
			aCOLS[Len(aCols)][nCntFor] := CriaVar(aHeader[nCntFor,2])
		EndIf
	Next nCntFor
	dbSelectArea(cArqQry)
	dbSkip()
EndDo
return (aCols)