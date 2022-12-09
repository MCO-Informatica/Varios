#include "rwmake.ch"
#include "protheus.ch"

User Function RPCPG01()

_nTemPad := SG2->G2_TEMPAD
                              

//---->VALIDA ALTERACAO DO TEMPO PADRAO
//---->SOMENTE USUARIO COM NIVEL 9 PODE ALTERAR
If cNivel < 9 .and. ALTERA
	Alert("Usu�rio sem permiss�o para alterar o Tempo Padr�o.","Sem Permiss�o","Stop")
Else
	_nTemPad := M->G2_TEMPAD
EndIf

Return(_nTemPad)