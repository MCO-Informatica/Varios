#include "protheus.ch"
#include "TopConn.ch"

User Function ProxID(cAlias,cCampo,cWhere)

	Local cAliasId := GetNextAlias()
	Local cQueryid := ""
	Local cId      := ""
	Local nTam     := TamSx3(cCampo)[1]
	local cNomeBD  := TCGetDB()

	cQueryid := "select max("+cCampo+") ID from "+RetSqlName(cAlias)+" "
	cQueryid += "where d_e_l_e_t_ = ' ' "
	if cNomeBD == "ORACLE"
		cQueryid += "and length(alltrim("+cCampo+")) = "+str(nTam)+" "
	else
		cQueryid += "and len(rtrim(ltrim("+cCampo+"))) = "+str(nTam)+" "
	endif
	if !empty(cWhere)
		cQueryid += "and "+cWhere
	endif
	cQueryid := ChangeQuery(cQueryid)
	dbUseArea( .T., "TOPCONN", TcGenQry(,,cQueryid), cAliasId,.F.,.T. )

	if !(cAliasId)->( Eof() )
		cId := soma1((cAliasId)->ID)
	endif

	(cAliasId)->(dbclosearea())

return cId
