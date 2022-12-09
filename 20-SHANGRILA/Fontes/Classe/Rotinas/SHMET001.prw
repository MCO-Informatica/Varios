#INCLUDE "protheus.ch"
#INCLUDE "tbiconn.CH"
#INCLUDE "topconn.ch"
#INCLUDE "rwmake.ch"
#INCLUDE 'FWMVCDEF.CH'
#IFNDEF ENTER
	#Define ENTER Chr(13) + Chr(10)
#ENDIF
/*
*Classe :
*Descric:
*Param  :
*Retorno:
*/
User Function SHMET001; Return

Class SHMET001

Data cCodigo as String
Data cTabela as String
Data cCampo  as String

Method New() Constructor
Method SHMETCOD()
                     
EndClass
/*
*Classe :
*Descric:
*Param  :
*Retorno:
*/
Method New() Class SHMET001
::cCodigo := ''
::cTabela := ''
::cCampo  := ''

Return

/*
*Classe :
*Descric:
*Param  :
*Retorno:
*/
Method SHMETCOD(cTabela,cCampo,nZero) Class SHMET001
Local cQuery   := ''              

Default nZero := 6

	cQuery += "	SELECT A." + cCampo + "- 1 COD "+ENTER
	cQuery += "		FROM "+RetSqlName(cTabela)+" A "+ENTER
	cQuery += "		WHERE A.D_E_L_E_T_ = '' AND A." + cCampo + " <> 1 and not exists (" +ENTER
	cQuery += "	SELECT B." + cCampo + ENTER
	cQuery += "		FROM "+RetSqlName(cTabela)+" B "+ENTER
	cQuery += "		WHERE B.D_E_L_E_T_ = '' AND B." + cCampo + " = (A." + cCampo + " - 1) )" +ENTER
	cQuery += "	ORDER BY A." + cCampo + ENTER
	                          
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"qTmp",.T.,.T.)	
	qTmp->(DbGoTop())
	
If !qTmp->(Eof())
	::cCodigo := StrZero(qTmp->COD,nZero)
	qTmp->(DbCloseArea())
Else                     
	qTmp->(DbCloseArea())
	cQuery := "	SELECT MAX(" + cCampo + ") COD "+ENTER
	cQuery += "		FROM "+RetSqlName(cTabela)+" A "+ENTER
	cQuery += "		WHERE A.D_E_L_E_T_ = '' " +ENTER
	                          
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"qTmp",.T.,.T.)	
	
	If !qTmp->(Eof())
		::cCodigo := StrZero(Val(Soma1(qTmp->COD)),nZero)
		qTmp->(DbCloseArea())
	Else
	qTmp->(DbCloseArea())
	::cCodigo := StrZero(Val(GETSXENUM(cTabela,cCampo)),nZero)
	EndIF
EndIf                

Return ::cCodigo


