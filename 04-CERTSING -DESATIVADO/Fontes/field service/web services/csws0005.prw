#INCLUDE 'APWEBSRV.CH'
#INCLUDE 'PROTHEUS.CH'
#include "TBICONN.CH"
#include "RWMAKE.CH"

WSSERVICE CSWS0005 DESCRIPTION "Servico manutenção de cadastro de AR"

	WSDATA	CODAR		AS String
	WSDATA	NOMEAR	AS String
	WSDATA	TMPVAL	AS String
	WSDATA	TMPINT		AS String
	WSDATA	TPCAD		AS Integer
	WSDATA	RETCAD	AS String
	WSDATA	LOGRA		AS String
	WSDATA	NUMERO	AS String
	WSDATA	COMPLE	AS String
	WSDATA	BAIRRO	AS String
	WSDATA	CIDADE	AS String
	WSDATA	UF				AS String
	WSDATA	CEP			AS String
	WSDATA	FILORI		AS String
	WSDATA	SEGUNDA	AS String
	WSDATA	TERCA		AS String
	WSDATA	QUARTA	AS String
	WSDATA	QUINTA		AS String
	WSDATA	SEXTA		AS String
	WSDATA	SABADO	AS String
	WSDATA	DOMINGO	AS String
	WSMETHOD CADAR

END WSSERVICE
       


WSMETHOD CADAR WSRECEIVE CODAR, NOMEAR, TMPVAL, TMPINT, TPCAD, LOGRA, NUMERO, COMPLE, BAIRRO, CIDADE, UF, CEP, FILORI, SEGUNDA, TERCA, QUARTA, QUINTA, SEXTA, SABADO, DOMINGO WSSEND RETCAD WSSERVICE CSWS0005
Local _xRet := " "
_xRet:= U_CSWS05CAD(::CODAR, ::NOMEAR, ::TMPVAL, ::TMPINT, ::TPCAD, ::LOGRA, ::NUMERO, ::COMPLE, ::BAIRRO, ::CIDADE, ::UF, ::CEP, ::FILORI, ::SEGUNDA, ::TERCA, ::QUARTA, ::QUINTA, ::SEXTA, ::SABADO, ::DOMINGO)
::RETCAD := _xRet 

Return(.T.)


User Function CSWS05CAD(CODIGO, NOME, TEMPVAL, TEMPINT, TIPO, LOG, NUM, COM, BAI, CID, UF, CEP, FIL, SEG,	TER, QUA, QUI, SEX, SAB, DOM)
Local _CT := .F.
Local _RET := "NAO EXECUTOU" 



//PREPARE ENVIRONMENT EMPRESA '01' FILIAL '01';
//TABLES "PA0","SA1","PA8","SB1","PA1","PA2","SX2","SX3", "PA9"




DbSelectArea("PA9")
DbSetOrder(1)
DbGoTop()
DbSeek( xFilial("PA9")+AllTrim(CODIGO))
If Found()
	_CT := .T.
Else
	_CT := .F.
End If


If TIPO == 3
	
	If !_CT
		RecLock("PA9",.T.)
		PA9->PA9_FILIAL	:= xFilial("PA9")
		PA9->PA9_CODAR	:= CODIGO
		PA9->PA9_NOMEAR	:= NOME
		PA9->PA9_TMPATE	:= TEMPVAL
		PA9->PA9_TMPINT	:= TEMPINT
		PA9->PA9_ENDERE	:= LOG
		PA9->PA9_NUMERO	:= NUM
		PA9->PA9_COMPLE	:= COM
		PA9->PA9_BAIRRO	:= BAI
		PA9->PA9_CIDADE	:= CID
		PA9->PA9_UF		:= UF
		PA9->PA9_CEP	:= CEP
		PA9->PA9_FILORI	:= FIL
		PA9->PA9_SEGUND	:= SEG 
		PA9->PA9_TERCA	:= TER 
		PA9->PA9_QUARTA	:= QUA
		PA9->PA9_QUINTA	:= QUI 
		PA9->PA9_SEXTA	:= SEX 
		PA9->PA9_SABADO	:= SAB 
		PA9->PA9_DOMING	:= DOM
		MsUnlock()
		_RET := "OK"		
	End If

ElseIf TIPO == 4

	If _CT
		RecLock("PA9",.F.)
		PA9->PA9_FILIAL	:=  xFilial("PA9")
		PA9->PA9_CODAR	:= CODIGO
		PA9->PA9_NOMEAR	:= NOME
		PA9->PA9_TMPATE	:= TEMPVAL
		PA9->PA9_TMPINT	:= TEMPINT
		PA9->PA9_ENDERE	:= LOG
		PA9->PA9_NUMERO	:= NUM
		PA9->PA9_COMPLE	:= COM
		PA9->PA9_BAIRRO	:= BAI
		PA9->PA9_CIDADE	:= CID
		PA9->PA9_UF		:= UF
		PA9->PA9_CEP	:= CEP
		PA9->PA9_SEGUND	:= SEG 
		PA9->PA9_TERCA	:= TER 
		PA9->PA9_QUARTA	:= QUA
		PA9->PA9_QUINTA	:= QUI 
		PA9->PA9_SEXTA	:= SEX 
		PA9->PA9_SABADO	:= SAB 
		PA9->PA9_DOMING	:= DOM
		PA9->PA9_FILORI	:= FIL
		MsUnlock()
		_RET := "OK"		
	End If

ElseIf TIPO == 5

	If _CT
		RecLock("PA9",.F.)
		DbDelete()
		MsUnlock()
		_RET := "OK"		
	End If

End If
//DbCloseAll()
Return(_RET)

