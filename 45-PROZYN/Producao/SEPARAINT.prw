#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#include "TOTVS.CH"
#include "rwmake.ch"
#Include "RPTDEF.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "FwPrintSetup.CH"


#DEFINE IMP_SPOOL 2
#DEFINE IMP_PDF 6

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SEPARAINT ºAutor  ³Denis Varella       º Data ³  07/10/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Fonte responsável por criar a grid de separação com divisão  ±±
±±º          ³de etiquetas na ordem de produção de INTEIROS               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function SEPARAINT()
	Local cPerg		:= PadR("SEPARAINT",10)
	AjustaSX1(cPerg)
	If Pergunte(cPerg,.T.)
		//If MSCBFSem()
		If Processa( {|| SeparaOP() },"Aguarde" ,"Carregando informações da OS...")
			Reclock('CB7')
			CB7->CB7_STATUS := "0"  // volto o status
			CB7->(MsUnLock())
		EndIf
		/*
		Else
		Alert("Ordem de separação já em andamento...")
		EndIf
		*/
	EndIf
Return

Static Function SeparaOP
	Local oOK := LoadBitmap(GetResources(),'BR_VERDE')
	Local oNO := LoadBitmap(GetResources(),'BR_VERMELHO')
	Private aBrowse := {}
	Private aEtiqs := {}
	Private oBrowse
	Private cCodOpe := CBRetOpe()


	DEFINE DIALOG oDlg TITLE "Ordem de Separação: "+MV_PAR01 FROM 90,90 TO 550,800 PIXEL		// Vetor com elementos do Browse
	DbSelectArea("CB7")
	CB7->(DbSetOrder(1))
	CB7->(DbSeek(xFilial("CB7")+MV_PAR01))

	Reclock('CB7')
	CB7->CB7_STATUS := "1"  // inicio separacao
	CB7->(MsUnLock())


	cQry := " SELECT CB8_ITEM,CB8_PROD,B1_DESC AS PRODUTO,CB8_LOCAL,CB8_SALDOS,CB8_LOTECT,CB8_OP FROM CB8010 CB8 "
	cQry += " INNER JOIN SB1010 B1 ON B1_COD = CB8_PROD AND B1_FILIAL = '"+xFilial("SB1")+"' AND B1.D_E_L_E_T_ = '' "
	cQry += " where CB8_FILIAL = '"+xFilial("CB8")+"' and CB8_ORDSEP = '"+MV_PAR01+"' AND CB8.D_E_L_E_T_ = '' ORDER BY CB8_ITEM "
	If select('SEPITEM') > 0
		('SEPITEM')->(DbCloseArea())
	EndIf
	TcQuery cQry New Alias 'SEPITEM'

	SEPITEM->(DbGoTop())
    /*
	If SEPITEM->(EOF()) .or. EMPTY(CB7->CB7_OP) .OR. CB7->CB7_TIPSEP != '3'
		MsgAlert("Ordem de separação inválida.","Atenção!")
		Return .F.
	EndIf
    */
	While SEPITEM->(!EOF())

		aAdd(aBrowse,{.f.,SEPITEM->CB8_ITEM,SEPITEM->CB8_PROD,SEPITEM->PRODUTO,SEPITEM->CB8_SALDOS,0,SEPITEM->CB8_LOTECT,SEPITEM->CB8_LOCAL})

		SEPITEM->(DbSkip())

	EndDo
	SEPITEM->(DbCloseArea())

	oBrowse := TCBrowse():New( 01 , 01, 356, 191,,;
	{'','Item','Cód. Prod','Produto','Saldo a separar','Separado','Lote','Armazém'},{20,20,25,40,20,20,20,20},;
	oDlg,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )		// Seta vetor para a browse

	oBrowse:SetArray(aBrowse)	    		// Monta a linha a ser exibina no Browse
	oBrowse:bLine := {||{ If(aBrowse[oBrowse:nAt,01],oOK,oNO),;
	aBrowse[oBrowse:nAt,02],;
	aBrowse[oBrowse:nAt,03],;
	aBrowse[oBrowse:nAt,04],;
	aBrowse[oBrowse:nAt,05],;
	aBrowse[oBrowse:nAt,06],;
	aBrowse[oBrowse:nAt,07],;
	aBrowse[oBrowse:nAt,08] } }
	oBrowse:bLDblClick   := {|| AbreProd(aBrowse,oBrowse:nAt,oBrowse) }

	TButton():New( 195, 002, "Cancelar", oDlg,{|| close(oDlg)  }, 40,010,,,.F.,.T.,.F.,,.F.,,,.F. )
	TButton():New( 195, 272, "Visualizar", oDlg,{|| visualizar(oBrowse:nAt) },40,010,,,.F.,.T.,.F.,,.F.,,,.F. )
	TButton():New( 195, 314, "Finalizar", oDlg,{|| finalizar(oDlg,aBrowse)  }, 40,010,,,.F.,.T.,.F.,,.F.,,,.F. )
	oSay1 := TSay():New(196,052,{||'Ordem de Separação: '+trim(mv_par01)},oDlg,,oFont,,,,.T.,CLR_RED,CLR_WHITE,80,10)
	oSay2 := TSay():New(196,154,{||'Ordem de Produção: '+trim(CB7->CB7_OP)},oDlg,,oFont,,,,.T.,CLR_RED,CLR_WHITE,90,10)

	ACTIVATE DIALOG oDlg CENTERED
Return

Static Function visualizar(nAt)
	Local aShow := {}
	Local nTotal := 0
	Local nE	:= 0

	For nE := 1 to len(aEtiqs)
		If aEtiqs[nE,1] == aBrowse[nAt,3]
			aAdd(aShow,aEtiqs[nE])
			nTotal += aEtiqs[nE,3]
		EndIf
	Next nE
	aAdd(aShow,{'','SubTotal',nTotal})
	If len(aShow) == 0
		Alert("Nenhuma etiqueta bipada para este produto.")
		Return
	EndIf

	DEFINE DIALOG oVisu TITLE "Etiquetas do Produto: "+trim(aBrowse[nAt,4]) FROM 0,0 TO 300,300 COLOR CLR_BLACK,CLR_WHITE PIXEL

	oBrowse2 := TCBrowse():New( 01 , 01, 150, 140,,;
	{'Etiqueta','Quantidade'},{50,50},;
	oVisu,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )		// Seta vetor para a browse

	oBrowse2:SetArray(aBrowse)	    		// Monta a linha a ser exibina no Browse
	oBrowse2:bLine := {||{ aShow[oBrowse2:nAt,2],;
	aShow[oBrowse2:nAt,3] } }

	ACTIVATE DIALOG oVisu CENTERED
Return

Static Function finalizar(oDlg,aBrowse)
	local na := 0
	For nA := 1 to len(aBrowse)
		If !aBrowse[nA][1]
			Alert("Todos os produtos precisam ser separados totalmente para finalizar o processo.")
			Return .F.
		EndIf
	Next nA  
	Alert("Finalizado!")
	Close(oDlg)
Return

Static Function AbreProd(aBrowse,nAt,oBrowse)
	Local oDlg2
	Local oBtn1, oBtn2, oGet1, oSay1, oSay2
	Local cGet1 := "Bipe a etiqueta..."
	Local cSay1 := trim(aBrowse[nAt,4])+" | Saldo: "+Transform(aBrowse[nAt,5],"@R 999,999.9999")
	Local cSay2 := "A Separar: "+Transform(aBrowse[nAt,5] - aBrowse[nAt,6],"@R 999,999.9999")
	Local nQtd := 0
	Local cSay3 := Transform(nQtd,"@R 999,999.99")

	If aBrowse[nAt,1]
		Alert("Produto já separado totalmente.")
		Return
	EndIf

	DEFINE DIALOG oDlg2 TITLE "Produto" FROM 0,0 TO 150,300 COLOR CLR_BLACK,CLR_WHITE PIXEL

	//@ 05,05 SAY oSay1 PROMPT cSay1 SIZE 80,12 OF oDlg2 PIXEL
	@ 20,05 MSGET oGet1 VAR cGet1 SIZE 060, 012 OF oDlg2 COLORS 0, 16777215 PIXEL
	oSay1 := TSay():New(20,80,{|| cSay1 },oDlg2,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,60,12)
	@ 55,05 BUTTON oBtn1 PROMPT 'Incluir' ACTION ( InclEtiq(aBrowse,nAt,cGet1,oDlg2,oBrowse) ) SIZE 40, 013 OF oDlg2 PIXEL
	@ 220,05 BUTTON oBtn2 PROMPT 'Cancelar' ACTION ( Close(oDlg2) ) SIZE 40, 013 OF oDlg2 PIXEL
	oSay2 := TSay():New(55,80,{|| cSay2 },oDlg2,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,80,12)
	oSay3 := TSay():New(90,80,{|| cSay3 },oDlg2,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,80,12)

	ACTIVATE DIALOG oDlg2 CENTER
Return

Static Function Balanca(aBrowse,nAt,cEtiq)
	Private  oDlg3
	Private  oBtn1, oBtn2, oBtn3, oGet1, oSay1
	Private  nSaldo := aBrowse[nAt,5] - aBrowse[nAt,6]
	Private  cSay1 := "Saldo: "+Transform(nSaldo,"@R 999,999.9999")
	Private  nGetBalan := 0

	//cPeso := Processa( {|| getBalanca(nSaldo) },"Aguardando..." ,"Aguardando finalização da pesagem...")

	DEFINE DIALOG oDlg3 TITLE "Balança" FROM 0,0 TO 150,300 COLOR CLR_BLACK,CLR_WHITE PIXEL

	@ 20,05 MSGET oGet1 VAR nGetBalan SIZE 060, 012 OF oDlg3 COLORS 0, 16777215 PIXEL PICTURE "@E 999,999.9999" VALID validBalan(nGetBalan,nSaldo)  WHEN .F.
	@ 55,05 BUTTON oBtn1 PROMPT 'Ler Balança' ACTION ( getBalanca(nSaldo) ) SIZE 45, 013 OF oDlg3 PIXEL
	@ 55,60 BUTTON oBtn2 PROMPT 'Incluir' ACTION ( insertEtiq(aBrowse,nAt,cEtiq,nGetBalan,oDlg3) ) SIZE 40, 013 OF oDlg3 PIXEL
	@ 55,110 BUTTON oBtn3 PROMPT 'Cancelar' ACTION ( Close(oDlg3) ) SIZE 40, 013 OF oDlg3 PIXEL
	oSay2 := TSay():New(20,80,{|| cSay1 },oDlg3,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,80,12)

	ACTIVATE DIALOG oDlg3 CENTER
Return

Static Function getBalanca(nSaldo)
	Private nHandle := 0

	conout(MSOpenPort(nHandle,"COM2:9600,N,8,1"))
	//MsClosePort(nHandle)

	//lPort := MSOpenPort(nHandle,"COM2:9600,N,8,1") // paridade NENHUMA
	
	lPort := MSOpenPort(nHandle,"COM1:9600,N,8,1") // paridade NENHUMA
	
	If !lPort
		lPort := MSOpenPort(nHandle,"COM2:9600,N,8,1") // paridade NENHUMA
		
		If !lPort 
			lPort := MSOpenPort(nHandle,"COM3:9600,N,8,1") // paridade NENHUMA
		EndIf
	EndIf
	

	If !lPort
		Alert("Não foi possível se conectar à porta")
		Return
	EndIf



	cPesoAux := space(20)
	nCont := 0

	nPesoL := 0
	//While nPesoL != nSaldo .and. nCont <= 30
	Sleep(200)
	MsRead(nHandle,@cPesoAux)
    conout(cPesoAux)
	aPeso:={}
	nLin2 := mlcount(cPesoAux,20,,.F.)
	cPesoaux2:= memoline(cPesoAux,20,nLin2,,.F.)
	nPesoL := val(StrTran( substr(cPesoaux2,3,10), ",", "." ))
	conout(nPesoL)
	nGetBalan := nPesoL
	MsClosePort(nHandle)
Return


Static Function validBalan(nGetBalan,nSaldo)
	If nGetBalan > nSaldo
		Alert("Valor acima do saldo...")
		nGetBalan := 0
		Return .f.
	EndIf
Return .t.


Static Function insertEtiq(aBrowse,nAt,cEtiq,nGetBalan,oDlg3)
	If nGetBalan > 0
		aBrowse[nAt,1] := .F.
		If QtdComp(aBrowse[nAt,6] + nGetBalan) == QtdComp(aBrowse[nAt,5])
			aBrowse[nAt,6] += nGetBalan
			aBrowse[nAt,1] := .t.
		Else
			aBrowse[nAt,6] += nGetBalan
		EndIf
		aAdd(aEtiqs,{aBrowse[nAt,3],cEtiq,nGetBalan})
		PrintEtiq(aEtiqs)
	EndIf
	Close(oDlg3)
Return

Static Function InclEtiq(aBrowse,nAt,cGet1,oDlg2,oBrowse)
	
	local nEt := 0
	
	// Teste Zanni
	Balanca(aBrowse,nAt,cGet1)


	DbSelectArea("CB0")
	CB0->(DbSetOrder(1))
	If CB0->(DbSeek(xFilial("CB0")+cGet1))
		If CB0->CB0_DTVLD < dDatabase
			Alert("Etiqueta passou da validade!")
			Return
		EndIf
		If CB0->CB0_QTDE <= 0
			Alert("Etiqueta com quantidade zerada!")
			Return
		EndIf
		If !empty(CB0->CB0_OP)
			Alert("Etiqueta já utilizada na OP: "+trim(CB0->CB0_OP))
			Return
		EndIf
		If trim(CB0->CB0_CODPRO) != trim(aBrowse[nAt,3]) .OR. CB0->CB0_LOTE != aBrowse[nAt,7] .OR. CB0->CB0_LOCAL != aBrowse[nAt,8]
			Alert("Etiqueta não pertecente ao produto "+trim(aBrowse[nAt,3])+", lote: "+aBrowse[nAt,7]+", armazém: "+aBrowse[nAt,8] )
			Return
		EndIf
		For nEt := 1 to len(aEtiqs)
			If trim(aEtiqs[nEt,1]) == trim(CB0->CB0_CODETI)
				Alert("Etiqueta já utilizada!")
				Return
			EndIf
		Next nEt
		nQtd := CB0->CB0_QTDE
		oSay3 := TSay():New(90,80,{|| Transform(nQtd,"@R 999,999.9999") },oDlg2,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,80,12)
		aBrowse[nAt,1] := .F.
		If QtdComp(aBrowse[nAt,6] + nQtd) > QtdComp(aBrowse[nAt,5])
			Balanca(aBrowse,nAt,cGet1)
		ElseIf QtdComp(aBrowse[nAt,6] + nQtd) == QtdComp(aBrowse[nAt,5])
			aAdd(aEtiqs,{aBrowse[nAt,3],CB0->CB0_CODETI,nQtd})
			aBrowse[nAt,6] += nQtd
			aBrowse[nAt,1] := .t.
			PrintEtiq(aEtiqs)
		Else
			aAdd(aEtiqs,{aBrowse[nAt,3],CB0->CB0_CODETI,nQtd})
			aBrowse[nAt,6] += nQtd
			PrintEtiq(aEtiqs)
		EndIf
		//	oBrowse:SetArray(aBrowse)
		oBrowse:bWhen:= { || Len(aBrowse) > 0 }
		oBrowse:Refresh()
		oDlg:Refresh()
		Close(oDlg2)
	Else
		Alert("Etiqueta não encontrada!")
		Close(oDlg2)
	EndIf
Return

Static Function AjustaSX1(cPerg)
	Local j
	Local i
	_sAlias := Alias()
	dbSelectArea("SX1")
	dbSetOrder(1)
	cPerg   := PADR(cPerg,10)
	aSx1   :={}

	AADD(	aSx1,{ cPerg,"01","ORDEM DE SEPARAÇÃO:"	,"","","mv_ch1","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","CB7INT",""})

	For i := 1 to Len(aSx1)
		If !dbSeek(cPerg+aSx1[i,2])
			RecLock("SX1",.T.)
			For j := 1 To FCount()
				If j <= Len(aSx1[i])
					FieldPut(j,aSx1[i,j])
				Else
					Exit
				EndIf
			Next
			MsUnlock()
		EndIf
	Next

	dbSelectArea(_sAlias)

Return(cPerg)

Static Function PrintEtiq(aEtiqs)
    /*
	If CB5SetImp(cImp,.T.)
		VTAlert("Imprimindo etiqueta "+cValtoChar(len(aEtiqs)),"Aviso",.T.,2000) //"Imprimindo etiqueta de volume "###"Aviso"

		If ExistBlock('IMG01')
			ExecBlock("IMG01",,,{MV_PAR01,aEtiqs[len(aEtiqs)][2],aEtiqs[len(aEtiqs)][3]})
		EndIf
		MSCBCLOSEPRINTER()
	EndIf
	*/
Return

Static Function MSCBFSem()
	Local nC:= 0
	__nSem := -1
	While __nSem  < 0
		__nSem  := MSFCreate("V165"+cCodOpe+".sem")
		IF  __nSem  < 0
			SLeep(50)
			nC++
			If nC == 3
				Return .F.
			EndIf
		EndIf
	EndDo
Return .T.
