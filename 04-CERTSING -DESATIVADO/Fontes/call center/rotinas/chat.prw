#Include "Totvs.ch"

Static cCodUsLog	:= IIF(TYPE("__cUserID") = "U",SPACE(6),__cUserID)

/*/{Protheus.doc} CHAT

Funcao personalizada para controle de conversas via chat entre operador servicedesk e
cliente

@author Totvs SM - David
@since 12/08/2011
@version P11

/*/

User Function CHAT()
	Local oChat 	:= nil

	oChat := ctsdkchat():New()
	oChat:Init()
	oChat:Activate()

Return

User Function CHATDISP(_lJob)

	Local cJobEmp	:= GETJOBPROFSTRING ( "JOBEMP" , "01" )   //Empresa que será usada para abertura do atendimento
	Local cJobFil 	:= GETJOBPROFSTRING ( "JOBFIL" , "02" )   //Filial que será usada para abertura do atendimento
	Local oChat

	Default _lJob 	:= .T.


	If _lJob
		RpcSetType(2)
		RpcSetEnv(cJobEmp,cJobFil)
	EndIf

	oChat:= CtSdkChat():New()
	oChat:Init()
	oChat:Informadisponibilidade()
	FreeObj(oChat)
	DelClassIntF()

	StartJob("U_CTSDK23J",GetEnvServer(),.f.,{cJobEmp,cJobFil})

Return