#INCLUDE "TBICONN.CH"
#INCLUDE "TBICODE.CH"
#include "ap5mail.ch"
#include "sigawin.ch"
#Include "Protheus.ch"
#Include "rwmake.ch"

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ROTINA SEMANAL (JOB) PARA ATULIZAÇÃO DO CAMPO B1_PE, DE ACORDO COM A CLASSIFICAÇÃO PELO SLOWMOVING
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LS_SLOWMOV(aParam)
/////////////////////////
                                  
Local aparam   := {"01","01"}
                          
IF FindFunction('WFPREPENV')
	WfPrepEnv( aParam[1], aParam[2])
Else
	Prepare Environment Empresa aParam[1] Filial aParam[2]
EndIF                          
//WfPrepEnv( aParam[1], aParam[2])

_cEnter := chr(13) + chr(10)

_cTabTemp := CriaTrab(,.f.)

_cQuery := "SELECT recno , codmaterial B1_COD"
_cQuery += _cEnter + "INTO " + _cTabTemp
_cQuery += _cEnter + "FROM PLUTAO.bils.dbo.slmv"
_cQuery += _cEnter + "ORDER by recno"

TcSqlExec(_cQuery)

_cQuery := "UPDATE SIGA.dbo.SB1010 SET B1_PE=0
_cQuery += _cEnter + "WHERE B1_PE<>0"
TcSqlExec(_cQuery)

_cQuery := "UPDATE A SET B1_PE = recno"
_cQuery += _cEnter + "FROM SIGA.dbo.SB1010 A"
_cQuery += _cEnter + "INNER JOIN " + _cTabTemp + " B on A.B1_COD = CONVERT(VARCHAR(20),B.B1_COD)"
TcSqlExec(_cQuery)

TcSqlExec("DROP TABLE " + _cTabTemp)

_cRel := '\data\slowmoving.csv'

_cQuery := "SELECT convert(char(5),B1_PE) Ranking, ';', B1_COD Código, ';', B1_DESC Descrição"
_cQuery += _cEnter + "FROM " + 	RetSqlName('SB1') + " SB1 (NOLOCK)"
_cQuery += _cEnter + "WHERE B1_PE <> ''"
_cQuery += _cEnter + "AND D_E_L_E_T_ = ''"
_cQuery += _cEnter + "ORDER BY B1_PE"

DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), '_SB1', .F., .T.)

COPY TO &_cRel SDF

DbCloseArea()

_cRecebe  	:= GetMv("LS_SLOMAIL")
_cServer   	:= GETMV("MV_RELSERV")
_cAccount  	:= AllTrim(GETMV("MV_RELACNT"))
_cPassword 	:= AllTrim(GETMV("MV_RELAPSW"))
_cEnvia    	:= _cRecebe     
_cErros     := ''
_lAuth      := GetMv('MV_RELAUTH')

CONNECT SMTP SERVER _cServer ACCOUNT _cAccount PASSWORD _cPassword Result _lConectou

If _lConectou
	
	If GetNewPar("MV_RELAUTH",.F.)
		_lRetAuth := MailAuth(_cAccount,_cPassword)
	Else
		_lRetAuth := .T.
	EndIf
	
	If _lRetAuth                           
	                
		_cAssunto := 'Slowmoving'
		_cCorpo   := 'ANEXA RELAÇÃO DE LIVROS NACIONAIS EM ORDEM DE RANKING' + _cEnter + _cEnter
		_cCorpo   += 'EXECUTADO AS ' + left(time(),5) + ' HORAS DO DIA ' + dtoc(date()) + '.'
		
		//SEND MAIL FROM _cEnvia TO _cRecebe SUBJECT _cAssunto BODY _cCorpo RESULT _lEnviado
 		SEND MAIL FROM _cEnvia TO _cRecebe SUBJECT _cAssunto BODY _cCorpo attachment _cRel RESULT _lEnviado
		fErase(_cRel)
		
	EndIf             
   	DISCONNECT SMTP SERVER
	
Endif        


Reset Environment

Return()
