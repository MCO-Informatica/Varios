#Include 'Protheus.ch'
#include "TOTVS.CH"
#include "topconn.ch"

/*/{Protheus.doc} MTAPREVISTA
(long_description)
@author Fernando
@since 14/08/2015
@version 1.0
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/User Function MTAPREVISTA()
	Local 	aArea     	:= GetArea()
	Local 	aAreaSC2  	:= SC2->(GetArea())
	Local cQuery := "" 
	Local cPrefProd := SubStr(C2_PRODUTO,1,3)
	Local aDados := {}
	Local 	oFont 		:= TFont():New('Arial',,-12,.T.,,,,,,.F.,.F.)
	Private nSaldo	:= nSaldAtual := C2_QUANT
	Private aDadosBkp := {}
	
	cQuery := " SELECT	C2_NUM, C2_ITEM, C2_SEQUEN,C2_PRODUTO, C2_TPOP, C2_QUANT"
	cQuery += " FROM "+RetSqlName("SC2")
	cQuery += " WHERE	C2_TPOP = 'P' AND D_E_L_E_T_ <> '*' AND C2_PRODUTO LIKE	'" + alltrim(cPrefProd) + "%'"
	cQuery += " ORDER BY	C2_PRODUTO"

	cquery :=Changequery(cquery)
	If Select("TRB")<>0
		dbSelectArea("TRB")
		dbCloseArea()
	EndIf

	TCQUERY cQuery  NEW ALIAS "TRB"

	cArq1 := CriaTrab(NIL,.F.)
	Copy To &cArq1 VIA "TOPCONN"  
	dbSelectArea("TRB")
	TRB->(DbGoTop())
	While TRB->(!eof())
		aadd(aDados, {TRB->C2_NUM,TRB->C2_ITEM ,TRB->C2_SEQUEN ,TRB->C2_PRODUTO,TRB->C2_QUANT, 0 })
		TRB->(DbSkip())
	EndDo
	
	DEFINE DIALOG oDlg TITLE "Exemplo MsBrGetDBase" FROM 180,180 TO 550,700 PIXEL             
		                                
		oBrowse := MsBrGetDBase():New( 0, 0, 260, 170,,,, oDlg,,,,,,,,,,,, .F., "", .T.,, .F.,,, )    
		
		oBrowse:SetArray(aDados)                           
		
		oBrowse:AddColumn(TCColumn():New("Numero OP",{ || aDados[oBrowse:nAt,1] };         
		,,,,"LEFT",,.F.,.F.,,,,.F.,))     
		
		oBrowse:AddColumn(TCColumn():New("Item OP",{ || aDados[oBrowse:nAt,2] };         
		,,,,"LEFT",,.F.,.F.,,,,.F.,))     
		
		oBrowse:AddColumn(TCColumn():New("Sequen. OP",{ || aDados[oBrowse:nAt,3] };         
		,,,,"LEFT",,.F.,.F.,,,,.F.,))     
		
		oBrowse:AddColumn(TCColumn():New("Produto",{ || aDados[oBrowse:nAt,4] };         
		,,,,"LEFT",,.F.,.F.,,,,.F.,))     
		
		oBrowse:AddColumn(TCColumn():New("Saldo",{ || aDados[oBrowse:nAt,5] };         
		,,,,"LEFT",,.F.,.F.,,,,.F.,))     
		
		oBrowse:AddColumn(TCColumn():New("Valor",{ || aDados[oBrowse:nAt,6] };         
		,,,,"LEFT",,.F.,.F.,,,,.F.,))
		oBrowse:Refresh()            
		
		// Cria Botões com métodos básicos    
		
		TButton():New( 172, 002, "OK"     	, oDlg,{|| AltPrevista(aDados),oBrowse:setFocus()},40,010,,,.F.,.T.,.F.,,.F.,,,.F. )    
		TButton():New( 172, 052, "Cancela" , oDlg,{|| oDlg:end(),oBrowse:setFocus()},40,010,,,.F.,.T.,.F.,,.F.,,,.F. )    
	
		TSay():New( 172, 152,{||"SALDO:"}	,oDlg,,oFont,,,,.T.,CLR_BLUE,CLR_WHITE,200,50)
		oSay1 := TSay():New( 172, 182,{||nSaldo}		,oDlg,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,200,50)	
		oBrowse:bCustomEditCol := {||  AltValor() }
	
	ACTIVATE DIALOG oDlg CENTERED 
RestArea(aAreaSC2)
RestArea(aArea)
Return


//***************************************************************************************|
//***************************************************************************************|
//Função que altera o valor das OP's Prevista                                         	  |
//***************************************************************************************|
Static Function AltValor()
		 

Local 	oFont 		:= TFont():New('Arial',,-12,,.T.,,,,,.F.,.F.)
Private cNewVal 	:= Space(10)
Private oDlg1

DEFINE DIALOG oDlg1 TITLE "Altera Valor" FROM 180,180 TO 350,700 PIXEL
		
	TSay():New(28,10,{||"Novo Valor"}		,oDlg1,,oFont,,,,.T.,CLR_BLUE,CLR_WHITE,200,50) 
    @ 35,10   MsGet cNewVal  SIZE  55,11 	  VALID ValGet(cNewVal)	OF oDlg1 PIXEL 
   	  
	oTButton1 	:= TButton():New( 35, 100, "OK"		,oDlg1,{|| GrvNewVal(oDlg1)},40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
	oTButton2 	:= TButton():New( 35, 170, "Cancela",oDlg1,{||oDlg1:end()},40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
	
	
ACTIVATE DIALOG oDlg1 CENTERED

Return
Static Function ValGet(cNewVal)
//If OBROWSE:AARRAY[oBrowse:nAt][6] < Val(cNewVal)

//Else	
	
//EndIf	

Return .T.

Static Function GrvNewVal()
	If nSaldo	>= Val(cNewVal)		
		OBROWSE:AARRAY[oBrowse:nAt][6]	:= Val(cNewVal)
		nSaldo -=  Val(cNewVal)
	Else
		MsgInfo("O Saldo é menor que o valor de compensação da OP " + OBROWSE:AARRAY[oBrowse:nAt][1] + "!" )
	EndIf		
	oBrowse:refresh()
	oDlg1:end()
	oDlg:Refresh()
	oSay1:Refresh()
Return


Static Function AltPrevista(aDados	)


For n:=1 To Len(aDados)
	DbSelectArea("SC2")
	DbSetOrder(1)
	If aDados[n,6] > 0
		If nSaldAtual >= aDados[n,6]
			If DbSeek(xFilial("SC2")+aDados[n,1]+aDados[n,2]+aDados[n,3])	
				If	SC2->C2_QUANT >= aDados[n,6]
					RecLock("SC2", .F.)
						SC2->C2_QUANT -= aDados[n,6]
					SC2->(MsUnLock())
				EndIf
			EndIf	
		Else
			//MsgInfo("A Ordem de Produção Prevista")
		EndIf		
	EndIf
Next
oDlg:end()
Return 