#Include "Protheus.ch" 


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO2     ºAutor  ³Microsiga           º Data ³  04/17/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function R_Ajut_Client()

Local cAlias := "TMP" 

BeginSQL Alias cAlias

	SELECT A1_FILIAL as Fiar, A1_COD,A1_LOJA, A1_EST, A1_MUN 
	FROM %Table:SA1%
	WHERE
	D_E_L_E_T_ = ' '

EndSQL

TMP->(DBGOTOP())

DbSelectArea("SA1")
DbSetOrder(1)  

DbSelectArea("CC2") 
DbSetOrder(2) //FILIAL+MUN

While TMP->(!EOF())

cFiar := TMP->FIAR
cCod := Alltrim(TMP->A1_COD)
cLoj := Alltrim(TMP->A1_LOJA)
cEst := UPPER(Alltrim(TMP->A1_EST))
cMun := UPPER(Alltrim(TMP->A1_MUN))                

CC2->(DbSeek(cFiar+cMun))

If CC2->CC2_EST = cEst
	cCodMun := CC2->CC2_CODMUN
Else
	TMP->(dbSkip()) 
EndIf

SA1->(DbSeek(cFiar+cCod+cLoj))

If Found()  

RecLock("SA1",.F.)
A1_COD_MUN := cCodMun
MsUnlock("SA1")

EndIF

TMP->(dbSkip())

Enddo

DbCloseArea("SA1")
DbCloseArea("CC2")  

ALERT("Processo Finalizado")

Return()