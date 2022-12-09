#include "protheus.ch"

User Function DFATG004()

Local _cRet   := ""
Local _aGrupo := UsrRetGrp(,RetCodUsr())
Local _cGrupo := Iif(__cUserID$"000000,000002","000032",_aGrupo[1])


If _cGrupo$''
	_cGrupo := "000000"
EndIf


//----> inclus�o permite colocar vendedor
If INCLUI

	_cRet := M->A1_VEND

//----> altera��o tem permiss�o restrita para colocar vendedor
ElseIf ALTERA 

	//----> todos os grupos podem alterar
	If !Alltrim(_cGrupo)$"000032"   
		_cRet := M->A1_VEND
	
	//----> grupo vendedores consultores s� pode alterar se o vendedor atual for 106-livre
	ElseIf Alltrim(_cGrupo)$"000032" .And. Alltrim(SA1->A1_VEND)$"106"
		_cRet := M->A1_VEND

	//----> n�o pode alterar vendedor
	Else 
	
		_cRet := SA1->A1_VEND
		MsgAlert("Voc� n�o tem permiss�o para alterar o vendedor do cliente.")
	EndIf	
EndIf

Return(_cRet)
