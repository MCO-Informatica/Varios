#include "Protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±
±³Fun‡…o    ³ Limpname ³ Autor ³Rafael Alencar   ³ Data ³ ³±
±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±
±³Descri‡…o ³        ³±
±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±
±³Uso       ³ Renova Energia                                       ³±
±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


User Function Limpname()
Local lRet     := .T.
Local cReadVar := ReadVar()
Local cVar     := ""
Local nLoop    := Nil

If ! Empty(cReadVar)
	cVar := &(cReadVar)
	For nLoop := 1 to Len(cVar)
		If Substr(cVar, nLoop, 1) $ "ÃÁÂÀÇÉÊÈÍÎÌÓÕÔÒÚÛÙãáâàçéêèíîìóõôòúûù.'~-/\,´`ºª!@#$%¨&*()+=§¹²³£¢¬"
			lRet := .F.
			Exit
		Endif
	Next
	If ! lRet
		Aviso("A T E N Ç Ã O", "Não é permitido inseir caracteres especiais!!!",{"OK"})
	Endif
Endif

Return (lRet)