#INCLUDE "RWMAKE.CH"
#include 'topconn.ch'    

User Function ChkDup(cDesc,cCli,cLoj,nPos,nOpcBrw,cCodigo)
Local aArea := GetArea()

	cQry:=" SELECT	Z00_DESC "
	cQry+=" FROM "+RetSqlName("Z00")+" Z00 "
	cQry+=" WHERE Z00.D_E_L_E_T_<>'*' "
	cQry+=" AND RTRIM(LTRIM(Z00.Z00_DESC))+RTRIM(LTRIM(Z00.Z00_ABREV)) = '" + AllTrim(cDesc) + "' "
	If nOpcBrw==4	// Alteracao
		cQry+=" AND Z00.Z00_COD <> '" + cCodigo + "' "
	Endif
	
	DbUseArea( .T.,"TOPCONN",TcGenQry(,,cQry),"TRB",.T.,.T.)
	
	TRB->(DbGoTop())
	If TRB->(EOF())	
		lRet := .t.
	Else 
//		MsgStop("Aten��o Existe Personaliza��o j� Com Esta Descri��o no Cadastro !","Personaliza��o")
		lRet := .f.
	Endif   
	TRB->(dbCloseArea())

RestArea(aArea)
Return lRet