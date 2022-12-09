#include "protheus.ch"

/* Executar carga de locais que executarão processos Mercos */
User function mercos98(cFilRet)

	Local aLocal := {}
	Local cSql := ""

	Local cJobEmp := '01'
	Local cJobFil := '0101'
	Local cJobMod := 'FAT'
	Local lJob := ( Select( "SX6" ) == 0 )

	Default cFilRet := ""

	if lJob
		RpcSetType( 3 )
		RpcSetEnv( cJobEmp, cJobFil, , , cJobMod )
	endif

	cSql := "SELECT * FROM "+RetSQLName("SX5")+" X5 WHERE X5_TABELA = 'ZK' AND X5.D_E_L_E_T_ = ' ' "
	if !empty(cFilRet)
		cSql += "AND X5_FILIAL = '"+cFilRet+"' "
	endif
	cSql += "ORDER BY X5_FILIAL,X5_CHAVE "
	dbUseArea(.t.,"TOPCONN",TcGenQry(,,cSql),"trb",.f.,.t.)
	while !trb->(eof())
		aadd(aLocal, { trb->x5_filial,substr(trb->x5_chave,1,4), alltrim(trb->x5_descri) } )
		trb->(dbskip())
	end
	trb->(dbclosearea())

	if lJob
		RpcClearEnv()
	endif

	/*
	aadd(aLocal, {'0101','01A1'} )
	aadd(aLocal, {'0102','02A1'} )
	aadd(aLocal, {'0103','03A1'} )
	aadd(aLocal, {'0107','07A1'} )
	aadd(aLocal, {'0109','09A1'} )
	aadd(aLocal, {'0110','10A1'} )
	aadd(aLocal, {'0111','11A1'} )
	aadd(aLocal, {'0113','13A1'} )
	aadd(aLocal, {'0114','14A1'} )
	aadd(aLocal, {'0115','15A1'} )
	aadd(aLocal, {'0119','19A1'} )
	aadd(aLocal, {'0120','20A1'} )
	*/

Return aLocal
