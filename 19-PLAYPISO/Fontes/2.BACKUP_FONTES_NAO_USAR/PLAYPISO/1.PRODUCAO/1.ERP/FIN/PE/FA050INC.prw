#Include "RWMAKE.CH"

/* 
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ FA050INC ³ Autor ³ Mauro Nagata          ³ Data ³ 12/05/2011 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ PE inclusao do titulo a pagar (consistencia)                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Lisonda www.actualtrend.com.br                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                                                    
           
User Function FA050INC()
Local lRet := .T.
        
If Alltrim(M->E2_XCC) = "3000"
   If Empty(AllTrim(M->E2_XMNTOBR))
      MsgBox("Este título foi lançado como da obra 3000 [Manutenção de Obra]. Preencha o campo Manut.Obra","Manutenção de Obra","ALERT")
      lRet := .F.
   EndIf    
ElseIf !Empty(M->E2_XMNTOBR).And.M->E2_XCC != "3000"
       MsgBox("Neste título o campo Manutenção de Obra está preenhido, mas a Obra está diferente de 3000","Manutenção de Obra","ALERT")
       lRet := .F.         
EndIf      
  
If AllTrim(M->E2_XMNTOBR) <> ""
	DbSelectArea("CTT")
	DbsetOrder(1)
	If DbSeek(xFilial("CTT")+M->E2_XMNTOBR)
		If CTT->CTT_MSBLQL = "2"
			MsgAlert("O campo Manut.Obra aceita somente obras bloqueadas.")
			lRet := .F.
		EndIf	  
 	else
 		MsgAlert("Obra do campo Manut.Obra não existe.")  
 		lRet := .F.
 	EndIf	  
EndIf	          
	          
Return lRet