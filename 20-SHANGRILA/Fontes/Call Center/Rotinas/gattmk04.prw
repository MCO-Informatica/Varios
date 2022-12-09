#Include "RwMake.Ch"

//========================================================================================================================================================
//Nelson Hammel - 27/07/11 - Valida contato
//========================================================================================================================================================

User Function GATTMK04()  

//Salva WorArea atual
_cAlias := Alias()
_nRecno := Recno()
_nIndex := IndexOrd()

y:=""
           
CQuery := " SELECT  * FROM " + RetSqlName("AC8") + " AC8 "
CQuery += " INNER JOIN " + RetSqlName("SU5") + " SU5 "
CQuery += " ON U5_CODCONT=AC8_CODCON "
CQuery += " WHERE 	AC8_CODENT	='"+Alltrim(M->UA_CLIENTE)+Alltrim(M->UA_LOJA)+"' "
CQuery += " AND SU5.D_E_L_E_T_ = '' "
CQuery += " AND AC8.D_E_L_E_T_ = '' "

cQuery := ChangeQuery(cQuery)
MsAguarde({|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),'TABAC8', .F., .T.)},"Aguarde")

DbSelectArea("TABAC8")
DbGoTop()

If !Eof()
y:=TABAC8->AC8_CODCON
Iif (Alltrim(M->UA_TMK)=="" .And. FUNNAME()<>"TMKA380",Alert("Por favor, disque para "+Alltrim(TABAC8->U5_DDD)+" "+Alltrim(TABAC8->U5_FCOM1)),)
Else
Alert("Não existe contato cadastrado para esse cliente!")
EndIf
DbSelectArea("TABAC8")
DbCloseArea("TABAC8")

DbSelectArea(_cAlias)
DbSetorder(_nIndex)
Dbgoto(_nRecno)	

Return(y)

