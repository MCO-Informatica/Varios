#INCLUDE 'RWMAKE.CH'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT415EFT  ºAutor  ³Rodrigo Okamoto     º Data ³  29/03/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Efetuar validação na efetivação do orçamento               º±±
±±º          ³ MTA416BX - Automático                                      º±±
±±º          ³ MT415EFT - Manual                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT415EFT

Local aArea416 	:= getarea()
Local cCliente	:= M->CJ_CLIENTE
Local cLoja		:= M->CJ_LOJA
Local cNumOrc	:= M->CJ_NUM
Local cUF	:= getadvfval("SA1","A1_EST",xFILIAL("SA1")+cCliente+cLoja,1,"")
lFil02	:= .F.
//considerando que num orcamento SPIDER contem apenas produtos SPIDER e nao Linciplas
If alltrim(cUF) == "RJ"
	DbSelectArea("SCK")
	DbSetOrder(1)
	DbSeek(xFilial("SCK")+cNumOrc)
	While SCK->(!eof()) .and. cNumOrc == SCK->CK_NUM
		If (SUBSTR(SCK->CK_PRODUTO,1,4) >= "S010" .AND. SUBSTR(SCK->CK_PRODUTO,1,4) <= "S060") .OR. SUBSTR(SCK->CK_PRODUTO,1,5) == "SPI35"
			lFil02	:= .T.
		EndIf	
		If lFil02
			reclock("SCK",.F.)
			TMP1->CK_FILVEN	:= "02"
			TMP1->CK_FILENT	:= "02"		
			MSUNLOCK()
		EndIf
		SCK->(DbSkip())		
	END
EndIf
If lFil02
	alert("Faturamento será pela filial 02!")
EndIf

RestArea(aArea416)

Return
