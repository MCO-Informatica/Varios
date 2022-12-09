#include "rwmake.ch"
#include "protheus.ch"

User Function RPCPG01()

_nTemPad := SG2->G2_TEMPAD
                              

//---->VALIDA ALTERACAO DO TEMPO PADRAO
//---->SOMENTE USUARIO COM NIVEL 9 PODE ALTERAR
If cNivel < 9 .and. ALTERA
	Alert("Usuário sem permissão para alterar o Tempo Padrão.","Sem Permissão","Stop")
Else
	_nTemPad := M->G2_TEMPAD
EndIf

Return(_nTemPad)