#INCLUDE "PROTHEUS.CH"


USER FUNCTION HISTLP()

Local cHist

IF SF2->F2_TIPO =="D" .OR. SF2->F2_TIPO =="B"
		cHist:=ALLTRIM("NF.: "+SF2->F2_DOC+SA2->A2_NOME)
	Else
		cHist:=ALLTRIM("NF.: "+SF2->F2_DOC+SA1->A1_NOME)
EndIf
     
Return(cHist)



USER FUNCTION HISIPI()

Local cHist

IF SF2->F2_TIPO =="D" .OR. SF2->F2_TIPO =="B"
		cHist:=ALLTRIM("NF.: "+SF2->F2_DOC+SUBSTR(SA2->A2_NOME,1,20)+LTRIM("-IPI"))
	Else
		cHist:=ALLTRIM("NF.: "+SF2->F2_DOC+SUBSTR(SA1->A1_NOME,1,20)+LTRIM("-IPI"))
EndIf	     

Return(cHist)

USER FUNCTION HISPIS()

Local cHist

IF SF2->F2_TIPO =="D" .OR. SF2->F2_TIPO =="B"
		cHist:=ALLTRIM("NF.: "+SF2->F2_DOC+SUBSTR(SA2->A2_NOME,1,20)+LTRIM("-PIS"))
	Else
		cHist:=ALLTRIM("NF.: "+SF2->F2_DOC+SUBSTR(SA1->A1_NOME,1,20)+LTRIM("-PIS"))
EndIf	     

Return(cHist)

USER FUNCTION HISCOF()

Local cHist

IF SF2->F2_TIPO =="D" .OR. SF2->F2_TIPO =="B"
		cHist:=ALLTRIM("NF.: "+SF2->F2_DOC+SUBSTR(SA2->A2_NOME,1,20)+LTRIM("-COFINS"))
	Else
		cHist:=ALLTRIM("NF.: "+SF2->F2_DOC+SUBSTR(SA1->A1_NOME,1,20)+LTRIM("-COFINS"))
EndIf	     

Return(cHist)

USER FUNCTION HISISS()

Local cHist

IF SF2->F2_TIPO =="D" .OR. SF2->F2_TIPO =="B"
		cHist:=ALLTRIM("NF.: "+SF2->F2_DOC+SUBSTR(SA2->A2_NOME,1,20)+LTRIM("-ISS"))
	Else
		cHist:=ALLTRIM("NF.: "+SF2->F2_DOC+SUBSTR(SA1->A1_NOME,1,20)+LTRIM("-ISS"))
EndIf	     

Return(cHist)                                             

USER FUNCTION HISICM()

Local cHist

IF SF2->F2_TIPO =="D" .OR. SF2->F2_TIPO =="B"
		cHist:=ALLTRIM("NF.: "+SF2->F2_DOC+SUBSTR(SA2->A2_NOME,1,20)+LTRIM("-ICMS"))
	Else
		cHist:=ALLTRIM("NF.: "+SF2->F2_DOC+SUBSTR(SA1->A1_NOME,1,20)+LTRIM("-ICMS"))
EndIf	     

Return(cHist)                                              

USER FUNCTION HISCPV()

Local cHist

IF SF2->F2_TIPO =="D" .OR. SF2->F2_TIPO =="B"
		cHist:=ALLTRIM("NF.: "+SF2->F2_DOC+SUBSTR(SA2->A2_NOME,1,20)+LTRIM("-CPV"))
	Else
		cHist:=ALLTRIM("NF.: "+SF2->F2_DOC+SUBSTR(SA1->A1_NOME,1,20)+LTRIM("-CPV"))
EndIf	     

Return(cHist)