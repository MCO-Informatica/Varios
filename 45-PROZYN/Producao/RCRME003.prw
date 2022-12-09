#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RCRME003  ºAutor Derik Santos          º Data ³  19/08/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função responsavel por verificar se o cadastro de          º±±
±±º          ³ oportunidade esta completo para o proximo estagio          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Protheus 12 - Prozyn                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RCRME003()

Local _cCodOp  := M->AD1_PROSPE
Local _cJaCli  := Posicione("SUS",1,xFilial("SUS")+_cCodOP+"01","US_CLISN")
Local _cCodCli := Posicione("SUS",1,xFilial("SUS")+_cCodOP+"01","US_CODCLI")
Local _cNome   := Posicione("SUS",1,xFilial("SUS")+_cCodOP+"01","US_NREDUZ")
Local _cOport  := Posicione("SUS",1,xFilial("SUS")+_cCodOP+"01","US_OPORTUN")
Local _cUsdano := Posicione("SUS",1,xFilial("SUS")+_cCodOP+"01","US_USDANO")
Local _cStatus := Posicione("SUS",1,xFilial("SUS")+_cCodOP+"01","US_COMENT")
Local _cBarre  := Posicione("SUS",1,xFilial("SUS")+_cCodOP+"01","US_BARRE")
Local _cAcoes  := Posicione("SUS",1,xFilial("SUS")+_cCodOP+"01","US_ACOES")
Local _cPorte  := Posicione("SUS",1,xFilial("SUS")+_cCodOP+"01","US_PORTE")
Local _cProd   := Posicione("SUS",1,xFilial("SUS")+_cCodOP+"01","US_PRODPZ")
Local _cMun    := Posicione("SUS",1,xFilial("SUS")+_cCodOP+"01","US_COD_MUN")
Local _cEst	   := Posicione("SUS",1,xFilial("SUS")+_cCodOP+"01","US_EST")
Local _cMens   := "Favor informar o(s) campo(s) "
Local lRet     := .T.

If _cJaCli == "N" .OR. Empty(_cCodCli)
	If Empty(_cNome) .OR. Empty(_cOport) .OR. Empty(_cUsdano) .OR. Empty(_cStatus) .OR. Empty(_cBarre) .OR. ;
	   Empty(_cAcoes) .OR. Empty(_cPorte) .OR. Empty(_cProd) .OR. Empty(_cMun) .OR. Empty(_cEst)
	
		If Empty(_cNome)
			_cMens += "Nome, "
		EndIf	
		If Empty(_cOport)
			_cMens += "Oportunidade, "
		EndIf	                      
		If Empty(_cUsdano)
			_cMens += "USD/ANO, "
		EndIf		             
		If Empty(_cStatus)
			_cMens += "Status, "
		EndIf		            
		If Empty(_cBarre)
			_cMens += "Barreiras, "
		EndIf	                  
		If Empty(_cAcoes)
			_cMens += "Ações, "
		EndIf	            
		If Empty(_cPorte)
			_cMens += "Porte, "
		EndIf	            
		If Empty(_cProd)
			_cMens += "Produtos Produzidos, "
		EndIf	                          
		If Empty(_cMun)
			_cMens += "Municipio, "
		EndIf	                
		If Empty(_cEst)
			_cMens += "Estado, "
		EndIf	
		_cMens += "para incluir um novo projeto para está oportunidade;" 
		Alert(_cMens)
		lRet := .F.
	Else
		lRet := .T.
	Endif
Else
	lRet := .T.
EndIf

Return lRet