#include "rwmake.ch"
#include "protheus.ch"

User Function RPCPG02()

_cMotivo := M->H6_MOTIVO
                              

//---->VALIDA ALTERACAO DO TEMPO PADRAO
//---->SOMENTE USUARIO COM NIVEL 9 PODE ALTERAR
If cNivel < 9 .and. M->H6_MOTIVO$"FC/FP/MP/MC/SG/TG/TS"
	Alert("Usuário sem permissão para lançar este motivo.","Sem Permissão","Stop")
	_cMotivo := ""
Else
	_cMotivo := M->H6_MOTIVO
EndIf

Return(_cMotivo)