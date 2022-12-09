#include "PROTHEUS.CH"

Class UserControl
	
	Data nNivel
	
	Method New() Constructor
	Method GetUser(nIndex)
	Method GetUserPermission(nNivel)
	Method GetLevel()
	Method GetUserCode()
	Method GetUserName()
	Method GetUserEmail()
	Method GetUserGroup()
	Method GetSuperCode()
	Method GetSuperName()
	Method GetSuperEmail()

End Class


Method New() Class UserControl
	Self:nNivel := cNivel
Return( Self )

Method GetLevel() Class UserControl
	Return (cNivel)

//Retorna informa��es do usuario
Method GetUser(nIndex) Class UserControl
	
	Local aUser   := {}
	Local cCodigo := ""
	
	// Informa��es do Usuario
	PswOrder(2)
	aUser := PswRet(1)
	
	If nIndex == 0
		Return aUser[1][1]     // C�digo do usuario
	ElseIf nIndex == 1
		Return aUser[1][4]     // Nome do usuario	
	ElseIf nIndex == 2
		Return aUser[1][14]    // Email
	ElseIf nIndex == 3
		Return	aUser[1][10][1] // Grupo Que o usuario Pertence
	EndIf
	
	// Informa��es do Superior
	cCodigo := Right(aUser[1][11],6)
	PswSeek(cCodigo,.T.)
	aUser := PswRet(1) 
	PswOrder(1)
	
	If nIndex == 4
		Return aUser[1][1]      // codigo do Superior
	ElseIf nIndex == 5 
		Return aUser[1][4]      // nome do Superior
	ElseIf nIndex == 6
		Return aUser[1][14]     // Email do Superior
	Else
		Return ""				   // N�o Localizado
	EndIf
	
Return ""

//Retorna se usuario tem acesso pelo nivel passado
Method GetUserPermission(nNivel) Class UserControl
	If ( Self:nNivel >= nNivel )
		Return .T.	
	EndIf
Return .F.

//Retorna o codigo do usu�rio
Method GetUserCode() Class UserControl
	Return( Self:GetUser(0) )

//Retorna o nome do usu�rio
Method GetUserName() Class UserControl
	Return( Self:GetUser(1) )

//Retorna o email do usu�rio	
Method GetUserEmail() Class UserControl
	Return( Self:GetUser(2) )

//Retorna o grupo do usu�rio
Method GetUserGroup() Class UserControl
	Return( Self:GetUser(3) )

//Retorna o c�digo do superior do usu�rio	
Method GetSuperCode() Class UserControl
	Return( Self:GetUser(4) )

//Retorna o nome do superior do usu�rio	
Method GetSuperName() Class UserControl
	Return( Self:GetUser(5) )

//Retorna o email do superior do usu�rio
Method GetSuperEmail() Class UserControl
	Return( Self:GetUser(6) )