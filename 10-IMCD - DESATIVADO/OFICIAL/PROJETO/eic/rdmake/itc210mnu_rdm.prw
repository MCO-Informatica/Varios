#include "protheus.ch"

//------------------------------------------------------------------------------------
User Function ITC210MNU

	Local aRot := {}

	aAdd(aRot, { "Copiar", "u_ITC210C", 0 , 2})

Return aRot

//------------------------------------------------------------------------------------
User Function ITC210C

	Local oDlg
	Local lOk := .F.
	Local cCodNew := Space(Len(SWF->WF_TAB))

	Local bOk := {|| lOk := .T., oDlg:End() }
	Local bCancel := {|| oDlg:End() }

	Local aRegWF := {}
	Local aRegWI := {}
	Local aAux   := {}
	Local i

	Begin Sequence

		DEFINE MSDIALOG oDlg TITLE "Copiar Tabela" FROM 9,10 TO 16,58 OF oMainWnd 
		@ 1,1 SAY "Codigo" OF oDlg
		@ 1,5 GET cCodNew PICTURE AvSx3("WF_TAB",6) VALID VldCodNew(cCodNew) SIZE 080,8 OF oDlg      
		TButton():New(2000, 002, "xx",oDlg,{||AllwaysTrue()}, 40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
		ACTIVATE MSDIALOG oDlg ON INIT (EnchoiceBar(oDlg,bOk,bCancel)) CENTERED

		IF !lOk
			Break
		Endif

		CopyTo("SWF",@aRegWF)

		SWI->(dbSetOrder(1))
		SWI->(dbSeek(xFilial()+SWF->WF_TAB))

		While SWI->(!Eof() .And. WI_FILIAL == xFilial("SWI") .And. WI_TAB == SWF->WF_TAB)
			aAux := {}
			CopyTo("SWI",@aAux)
			aAdd(aRegWI,aAux)  
			SWI->(dbSkip())
		Enddo

		Begin Transaction
			SWF->(RecLock("SWF",.T.))
			PasteFrom("SWF",aRegWF)  
			SWF->WF_TAB := cCodNew
			SWF->(MsUnlock())

			For i:=1 To Len(aRegWI)
				SWI->(RecLock("SWI",.T.))
				PasteFrom("SWI",aRegWI[i])  
				SWI->WI_TAB := cCodNew
				SWI->(MsUnlock())
			Next i
		End Transaction

	End Sequence

Return NIL

//------------------------------------------------------------------------------------
Static Function CopyTo(cAlias, aArray)

	Local lRet   := .T.
	Local i      := 1

	Begin Sequence     
		For i:=1 To (cAlias)->(FCount())
			(cAlias)->( aAdd(aArray,{FieldName(i),FieldGet(i)}) )
		Next i

	End Sequence

Return lRet

//------------------------------------------------------------------------------------
Static Function PasteFrom(cAlias, aArray)

	Local lRet   := .T.
	Local i      := 1

	Begin Sequence     
		For i:=1 To (cAlias)->(FCount())
			(cAlias)->(FieldPut(i,aArray[i,2]))
		Next i

	End Sequence

Return lRet                              


//------------------------------------------------------------------------------------
Static Function VldCodNew(cCodNew)

	Local lRet   := .f.
	Local aArea  := SWF->(GetArea())

	Begin Sequence     
		IF !NaoVazio(cCodNew)
			Break
		Endif

		SWF->(dbSetOrder(1))

		IF SWF->(dbSeek(xFilial("SWF")+cCodNew))
			MsgInfo("Código já gravado. Favor digitar um código válido.")
			Break
		Endif

		lRet := .T.

	End Sequence

	SWF->(RestArea(aArea))

Return lRet                              

