#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NOVO2     � Autor � AP6 IDE            � Data �  07/12/09   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP6 IDE.                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Z1VALSTATUS �Autor  �Microsiga           � Data �  12/13/09   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
		MsgInfo("Altera��o n�o permitida!","Aviso")
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
		MsgInfo("Altera��o n�o permitida!","Aviso")
	Endif
ElseIf (M->Z1_CONCLUI == '3')
	If !Empty(M->Z1_DHAPROV)
		lRet:= .T.  
		M->Z1_DATACON:= dDatabase
	Else
		MsgInfo("Chamado ainda n�o aprovado, altera��o n�o permitida!","ATEN��O")
	EndIf	
EndIf

If !lRet
	Aviso("Aviso","A��o n�o permitida.",{"OK"})
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
		FWAlertError("Este Atendimento j� foi conclu�do e n�o poder� ser alterado!" + Chr(13)+Chr(10)+;
			"Caso que precise alterar, contacte o administrador do sistema!","ATEN��O")
		//MsgAlert("Este Atendimento j� foi conclu�do e n�o poder� ser alterado!" + Chr(13)+Chr(10)+;
				//"Caso que precise alterar, contacte o administrador do sistema!","ATEN��O")
	EndIf	
Return
