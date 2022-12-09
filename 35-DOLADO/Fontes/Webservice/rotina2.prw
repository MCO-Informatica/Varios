#include 'Protheus.ch'
User Function rotina2()

	local jPedido
	Local lAchou := .f.
    local ni := 0
    local acol := {}

	RpcSetType( 3 )
	RpcSetEnv( '01', '0101', , , 'FAT' )

	sz1->(DbSetOrder(1))
	sz1->(dbgotop())
	while sz1->(!eof())

		if EMPTY(sz1->z1_pedshpf) .and. ALLTRIM(sz1->z1_rotina) == "MATA410"
			jPedido := jsonObject():new()
			jPedido:fromJson( sz1->z1_bodymsg )

			lAchou := .f.

			aCol := jPedido:GetNames()
			for nI := 1 to len(aCol)
				if acol[nI] == "C5_XPEDSHP"
					lAchou := .t.
				endif
			next
			if lAchou
				sz1->(RecLock( 'SZ1', .f. ))
				sz1->z1_pedshpf := jPedido:C5_XPEDSHP
				sz1->( MsUnlock() )
			else
				msginfo("Campo C5_XPEDSHP não existe no Json. Verifique o uuid "+SZ1->Z1_UUID)
    		endif
		endif

		sz1->(dbskip())
	end

	RpcClearEnv()

Return
