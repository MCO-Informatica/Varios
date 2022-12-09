#include 'protheus.ch'

User function abrirAmb(cEmp,cFil,cMod)
	Local lRet := .f.
	Local lAmb := (select("SX6")==0)

	Default cMod := "FAT"

	if !lAmb
		RpcClearEnv()
	endif
	RpcSetType(3)
	lRet := RpcSetEnv(cEmp,cFil,,,cMod)

return lRet
