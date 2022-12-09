User Function PDVMOEDA()
/* Fonte excluido - Funcoes substituidas pelo fonte M410LIOK.PRW
Local cQuery := ''  
Local cAliasTRB := GetNextAlias()  
Local aAreaC5 := GetArea() 

//If EMPTY(M->C5_TABELA)         
If EMPTY(M->C5_TABELA) .AND. (M->C5_TIPO) $" C I P"
//If EMPTY(M->C5_TABELA) .AND. M->C5_TIPO == "N" //Validar somente para pedido de venda normal - Deo 07/05/18
	Alert('Atenção! Cliente não atrelado a uma tabela de preço. Por favor faça o preenchimento em seu cadastro.')
	M->C5_MOEDA := 0 
	GetDRefresh()
Return 0

Else

If Select("TMP") > 0
	cAliasTRB->(DBCLOSEAREA())
EndIf

	cQuery := " SELECT top 1 "
	cQuery += " DA1_MOEDA FROM " + RetSqlName('DA1') + " DA1 "
	cQuery += " WHERE DA1_CODTAB = '"+M->C5_TABELA+"' AND DA1_DATVIG <= " + DTOS(dDatabase) + " AND DA1_CODPRO = '"+ M->C6_PRODUTO +"' AND DA1.D_E_L_E_T_ = '' ORDER BY DA1_DATVIG ASC "
	
cQuery := ChangeQuery( cQuery ) 
	   
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTRB,.T.,.T.)
dbSelectArea(cAliasTRB)

(cAliasTRB)->(DbGotOP())   

	M->C5_MOEDA := (cAliasTRB)->DA1_MOEDA
	GetDRefresh()

Return (cAliasTRB)->DA1_MOEDA

EndIf 
*/               
Return