#include "Protheus.ch"
#include "Topconn.ch"
 
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Consulta Especifica de Marcas - ZZY³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
User Function SB1SA7()
Local aArea := GetArea() 
Local cQuery := ""
Local cRet := ""
Private nPosProd   := aScan(aHeader, {|x| alltrim(x[2]) == "C6_PRODUTO"})
Private cCodigo    := Alltrim(&(ReadVar()))
Private cCliente   := M->C5_CLIENTE 


cQuery := " SELECT B1_COD"
cQuery += " FROM "+RetSQLName("SB1") + " SB1 ,"+RetSQLName("SA7") + " SA7 " 
cQuery += " WHERE B1_COD = A7_PRODUTO AND A7_CLIENTE = '"+cCliente+"'"
cQuery += " AND SB1.D_E_L_E_T_<> '*' AND SA7.D_E_L_E_T_<> '*'"
cQuery += " ORDER BY B1_COD"

DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),"TRAB1", .F., .T.)

Dbselectarea("TRAB1")
dbgotop()
IF TRAB1->(EOF())
	cRet := "@#SB1->(B1_GRUPO) <> '10  ' @#"
ELSE    
	nCont := 1
	dbgotop()	
	While !TRAB1->(EOF())
		IF nCont == 1
			cRet := "@#SB1->(B1_COD) == '"+TRAB1->B1_COD+"' " 
		ELSE
			cRet += " .OR. SB1->(B1_COD) == '"+TRAB1->B1_COD+"' " 
		ENDIF         
		nCont++
		TRAB1->(dbskip())	
		loop
	Enddo             
	IF Empty(cRet)
		cRet := "@#.T.@#"
	ELSE
		cRet += " @#"
	ENDIF		
ENDIF
TRAB1->(dbclosearea())
Ferase(cQuery+OrdBagExt())

Restarea(aArea)
return cRet                  
