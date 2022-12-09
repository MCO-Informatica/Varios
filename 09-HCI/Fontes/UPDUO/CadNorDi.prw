#Include "Totvs.ch"
#Include "Protheus.ch"
#Include "RwMake.ch"

User Function CadNorDi()

  Local cCadastro := 'Cadastro de Norma Dimencional'
  Local cAlias    := "SZP"
  Local cFunExc := "U_H001_EXC()"
  Local cFunAlt := "U_H001_ALT()"

  dbSelectArea('SZP')
  dbSetOrder(1)

  AxCadastro(cAlias, cCadastro, cFunExc, cFunAlt)

Return Nil

//*********************
User Function H001_EXC()

Local lRet := MsgBox("Tem certeza que deseja excluir a Norma selecionada?", "Confirma��o", "YESNO")

Return lRet

//*********************
User Function H001_ALT()

Local lRet := .T.
Local cMsg := ""

If INCLUI
	  if dbSeek(xFilial("SZP")+M->ZP_NORMA)
       cMsg := "Aten��o: Norma j� cadastrada!"
       MessageBox(cMsg, "Cadastro j� existente", 16)
       lRet := .F.
    else
       cMsg := "Confirma a inclus�o da Norma?"
       lRet := MsgBox(cMsg, "Confirma��o", "YESNO")
    endif
Else
	lRet := .T.
EndIf

Return lRet
