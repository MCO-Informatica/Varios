#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO2     º Autor ³ AP6 IDE            º Data ³  07/12/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Codigo gerado pelo AP6 IDE.                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function SZ1ATEN



Private cCadastro := "Atendimento de Ocorrencias / Chamados"

Private aRotina := { 	{"Pesquisar","AxPesqui",0,1} ,;
             			{"Visualizar","AxVisual",0,2} ,;
             			{"Incluir","AxInclui",0,3} ,;
             			{"Alterar","U_SZ1ALT",0,4} ,;
             			{"Excluir","AxDeleta",0,5} ,;
             			{"Imprimir","U_DHATER01",0,6} }

Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock
Private cString := "SZ1"
Private aCores	:= {}
Private aMemos:={{"Z1_CODOBS","Z1_OBS"}}


dbSelectArea("SZ1")
dbSetOrder(1)          

Aadd(aCores,{ "Z1_CONCLUI == '1' " , 'BR_VERDE'     })
Aadd(aCores,{ "Z1_CONCLUI == '2' " , 'BR_AZUL'		})
Aadd(aCores,{ "Z1_CONCLUI == '3' " , 'BR_VERMELHO'  })
                                                       
//dbSelectArea(cString)
mBrowse (6,1,22,75,cString,,,,,,aCores)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Z1VALSTATUS ºAutor  ³Microsiga           º Data ³  12/13/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function Z1VALSTATUS()
Local lRet    := .F.
Local aUsuario:= {}
Local aGrupos := AllGroups()
Local nI	  := 0
Local nX      := 0

PswOrder(1)
PswSeek(__cUserId)
aUsuario:= PswRet()[1]

If (M->Z1_CONCLUI == '1')
	If Empty(M->Z1_DHAPROV) .And. Empty(M->Z1_DATACON) 
		lRet:= .T.
	Else
		MsgInfo("Alteração não permitida!","Aviso")
	Endif
ElseIf (M->Z1_CONCLUI == '2')
	If Empty(M->Z1_DATACON)
		For nI:= 1 To Len(aUsuario[10])
			For nX:=1 To Len(aGrupos)
				If (Alltrim(aUsuario[10,nI]) == Alltrim(aGrupos[nX,1,1])) .And. ("APROVADORES" $ AllTrim(Upper(aGrupos[nX,1,2])))
					lRet:= .T.
					M->Z1_DHAPROV:= AllTrim(Upper(SubStr(cUsuario,7,15)))
					M->Z1_DHDAPRO:= dDatabase
					Exit
				EndIf	
			Next nx
		Next nI
	Else
		MsgInfo("Alteração não permitida!","Aviso")
	Endif
ElseIf (M->Z1_CONCLUI == '3')
	If !Empty(M->Z1_DHAPROV)
		lRet:= .T.  
		M->Z1_DATACON:= dDatabase
	Else
		MsgInfo("Chamado ainda não aprovado, alteração não permitida!","ATENÇÃO")
	EndIf	
EndIf

If !lRet
	Aviso("Aviso","Ação não permitida.",{"OK"})
Endif
	
Return(lRet)



User Function SZ1ALT()
	Local nReg    := ( cString )->( Recno() )

	Private aHeader := {}
	Private aCols	:= {}
	Private n		:= 0

		
	If (cString)->( Z1_CONCLUI) <> "3"
				AxAltera(cString,nReg,3,, /*aCpos*/)
	Else
		FWAlertError("Este Atendimento já foi concluído e não poderá ser alterado!" + Chr(13)+Chr(10)+;
			"Caso que precise alterar, contacte o administrador do sistema!","ATENÇÃO")
		//MsgAlert("Este Atendimento já foi concluído e não poderá ser alterado!" + Chr(13)+Chr(10)+;
				//"Caso que precise alterar, contacte o administrador do sistema!","ATENÇÃO")
	EndIf	
Return
