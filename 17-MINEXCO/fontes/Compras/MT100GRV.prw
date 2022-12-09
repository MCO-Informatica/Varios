#include "totvs.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma          ³ MT100GRV             º Analista    ³ McInfotec                              º  Data  ³     29/11/16    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao         ³ Ponto de entrada na gravacao da nota de entrada                                                        º±±
±±º                  ³ Verifica se foram alterados produtos nos itens da nota e realiza as alteracoes nos pedidos e nas       º±±   
±±º                  ³ solicitacoes de compras                                                                                º±± 
±±º                  ³                                                                                                        º±±  
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso               ³ Exclusivo : McInfotec                                                                                  º±±  
±±º                  ³                                                                                                        º±±  
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function MT100GRV()

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Declaracao de Variaveis                                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Local l_Retorn := .T.
Local l_AltPed := .F.
Local c_FilDoc := cFilAnt
Local c_ForDoc := cA100For
Local c_LojDoc := cLoja
Local a_AreaAt := GetArea()
Local n_Pedido := 0
Local n_AltPed := 0
Local c_IfDPro := ""

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Declaracao de Variaveis - Posicao dos campos                                                                                //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Local n_PsNPxI := aScan(aHeader,{|x| x[2] = "D1_XPEDITE"})
Local n_PsNPed := aScan(aHeader,{|x| x[2] = "D1_PEDIDO"})
Local n_PsCPro := aScan(aHeader,{|x| x[2] = "D1_COD"})
Local n_PsNIte := aScan(aHeader,{|x| x[2] = "D1_ITEMPC"})
Local n_PsCFor := aScan(aHeader,{|x| x[2] = "D1_FORNECE"})
Local n_PsCLoj := aScan(aHeader,{|x| x[2] = "D1_LOJA"})

Private l_AltCot := .F.
Private l_AltSol := .F.
Private c_IfNCot := ""
Private c_IfNSol := ""
Private c_IfNItS := ""

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// So executa para inclusao ou classificacao                                                                                   //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

If Inclui .Or. Altera 

	For n_Pedido := 1 To Len(aCols)
		If !Empty(aCols[n_Pedido,n_PsNPxI])
			l_AltPed := .T. 
			Exit		
		EndIf	
	Next n_Pedido

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Se existir pedido, verifica se houve alteracao no produto e grava no pedido, cotacao e solicitacao                          //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	If l_AltPed
		For n_AltPed := 1 To Len(aCols)
			If !Empty(aCols[n_AltPed,n_PsNPxI])
				If VerAlt(c_FilDoc,aCols[n_AltPed,n_PsNPxI],aCols[n_AltPed,n_PsCPro],c_ForDoc,c_LojDoc)
					aCols[n_AltPed,n_PsNPed] := SubStr(aCols[n_AltPed,n_PsNPxI],1,6)
					aCols[n_AltPed,n_PsNIte] := SubStr(aCols[n_AltPed,n_PsNPxI],7,4) 
					c_IfDPro := Posicione("SB1",1,c_FilDoc+aCols[n_AltPed,n_PsCPro],"B1_DESC")
					DbSelectArea("SC7")
					SC7->(DbSetOrder(1))
					If DbSeek(c_FilDoc+aCols[n_AltPed,n_PsNPxI])
						RecLock("SC7",.F.)
							SC7->C7_PRODUTO := aCols[n_AltPed,n_PsCPro] 
							SC7->C7_DESCRI := c_IfDPro
						MsUnlock()                    
					EndIf
					SC7->(DbCloseArea())
					If l_AltCot
						DbSelectArea("SC8")
						SC8->(DbSetOrder(1))
						If DbSeek(c_FilDoc+c_IfNCot+c_ForDoc+c_LojDoc+aCols[n_AltPed,n_PsNIte])					
							RecLock("SC8",.F.)
								SC8->C8_PRODUTO := aCols[n_AltPed,n_PsCPro]
							MsUnlock()						
						EndIf
				   		SC8->(DbCloseArea())												
					EndIf					
					If l_AltSol
						DbSelectArea("SC1")
						SC1->(DbSetOrder(1))
						If DbSeek(c_FilDoc+c_IfNSol+c_IfNItS)					
							RecLock("SC1",.F.)
								SC1->C1_PRODUTO := aCols[n_AltPed,n_PsCPro]
								SC1->C1_DESCRI := c_IfDPro								
							MsUnlock()						
						EndIf
				   		SC1->(DbCloseArea())												
					EndIf
				EndIf
				RestArea(a_AreaAt)
			EndIf	
		Next n_AltPed	
	EndIf
			
EndIf	

Return(l_Retorn)

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Funcao para verificar se houve alteracao no produto                                                                         //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Static Function VerAlt(c_IfCFil,c_IfNPed,c_IfCPro,c_IfCFor,c_IfCLoj)

Local l_Retorn := .F.
Local a_AreaAt := GetArea()

If Select("A_AUX") > 0
	DbSelectArea("A_AUX")
	A_AUX->(DbCloseArea())
EndIf
		
BeginSql Alias "A_AUX"
	SELECT	CASE WHEN SC7.C7_PRODUTO <> %exp:AllTrim(c_IfCPro)% THEN 'S' ELSE 'N' END AS ALTPED,
			CASE WHEN SC7.C7_NUMSC = ' ' THEN 'N' ELSE 'S' END AS ALTSOL,
			CASE WHEN SC7.C7_NUMCOT = ' ' THEN 'N' ELSE 'S' END AS ALTCOT,			
			SC7.C7_NUMCOT AS IFNCOT,
			SC7.C7_NUMSC AS IFNSOL,
			SC7.C7_ITEMSC AS IFNITS 
	FROM	%Table:SC7% AS SC7
	WHERE	SC7.C7_FILIAL = %exp:AllTrim(c_IfCFil)% AND	
			SC7.C7_NUM+SC7.C7_ITEM = %exp:AllTrim(c_IfNPed)% AND
			SC7.C7_FORNECE = %exp:AllTrim(c_IfCFor)% AND
			SC7.C7_LOJA = %exp:AllTrim(c_IfCLoj)% AND
			SC7.%NotDel%
EndSql

DbSelectArea("A_AUX")
	If A_AUX->ALTPED == "S"
		l_Retorn := .T.
		If A_AUX->ALTCOT == "S"
			l_AltCot := .T.
			c_IfNCot := A_AUX->IFNCOT
		Else
			l_AltSol := .F.
			l_AltCot := .F.
			c_IfNCot := ""		
		EndIf
		If A_AUX->ALTSOL == "S"
			l_AltSol := .T.
			c_IfNSol := A_AUX->IFNSOL
			c_IfNItS := A_AUX->IFNITS
		Else
			l_AltSol := .F.
			c_IfNSol := ""
			c_IfNItS := ""		
		EndIf
	Else
		l_Retorn := .F.	
	EndIf
A_AUX->(DbCloseArea())	

RestArea(a_AreaAt)	

Return(l_Retorn)

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
