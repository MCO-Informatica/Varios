#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO2     ºAutor  ³Microsiga           º Data ³  09/20/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function SobeDic()

If !MsgYesNo("Confirma Upload do DD ???")
	Return(.F.)
Endif

MsgRun("Processando upload...","Aguarde..",{||ProcUpLoad()})

MsgStop("Fim...")

Return(.T.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SOBEDIC   ºAutor  ³Microsiga           º Data ³  10/21/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ProcUpLoad()

Local cPath	:= "\data\gestaoti\"
Local cFile	:= ""
Local cEmp	:= "01"
Local cFil	:= "02"

MakeDir(cPath+"bkp\")

RPCSetEnv(cEmp,cFil)

SX2->( DbSetOrder(1) )
SX2->( MsSeek( "U00" ) )
While	SX2->( !Eof() ) .AND.;
		SX2->X2_CHAVE >= "U00" .AND.;
		SX2->X2_CHAVE <= "U99"
	
	cFile := AllTrim(SX2->X2_ARQUIVO)
	DbSelectArea( SX2->X2_CHAVE )
	COPY TO &(cPath+"BKP\"+cFile+".DTC")
	
	SX2->( DbSkip() )
End

__CopyFile("\system\six"+cEmp+"0.dtc","\system\six"+cEmp+"0_bkp.dtc")
SIX->( DbCloseArea() )
USE "\system\six"+cEmp+"0.dtc" INDEX "\system\six"+cEmp+"0.cdx" ALIAS SIX EXCLUSIVE
DELETE FOR SIX->INDICE >= "U00" .AND. SIX->INDICE <= "U99"
PACK
APPEND FROM &(cPath+"SIX.DTC")
SIX->( DbCloseArea() )
DbSelectArea("SIX")

USE &(cPath+"SX2.DTC") ALIAS TMP
While TMP->( !Eof() )
	SX2->( DbSetOrder(1) )
	If SX2->( MsSeek( TMP->X2_CHAVE ) )
		TMP->( RecLock("TMP",.F.) )
		TMP->X2_ARQUIVO := SX2->X2_ARQUIVO
		TMP->( MsUnlock() )
	Else
		TMP->( RecLock("TMP",.F.) )
		TMP->X2_ARQUIVO := TMP->X2_CHAVE+cEmp+"0"
		TMP->( MsUnlock() )
	Endif
	TMP->( DbSkip() )
End
TMP->( DbCloseArea() )

__CopyFile("\system\sx2"+cEmp+"0.dtc","\system\sx2"+cEmp+"0_bkp.dtc")
SX2->( DbCloseArea() )
USE "\system\sx2"+cEmp+"0.dtc" INDEX "\system\sx2"+cEmp+"0.cdx" ALIAS SX2 EXCLUSIVE
DELETE FOR SX2->X2_CHAVE >= "U00" .AND. SX2->X2_CHAVE <= "U99"
PACK
APPEND FROM &(cPath+"SX2.DTC")
SX2->( DbCloseArea() )
USE "\system\sx2"+cEmp+"0.dtc" INDEX "\system\sx2"+cEmp+"0.cdx" ALIAS SX2 SHARED
DbSelectArea("SX2")

__CopyFile("\system\sx3"+cEmp+"0.dtc","\system\sx3"+cEmp+"0_bkp.dtc")
SX3->( DbCloseArea() )
USE "\system\sx3"+cEmp+"0.dtc" INDEX "\system\sx3"+cEmp+"0.cdx" ALIAS SX3 EXCLUSIVE
DELETE FOR SX3->X3_ARQUIVO >= "U00" .AND. SX3->X3_ARQUIVO <= "U99"
PACK
APPEND FROM &(cPath+"SX3.DTC")
SX3->( DbCloseArea() )
DbSelectArea("SX3")

__CopyFile("\system\sx7"+cEmp+"0.dtc","\system\sx7"+cEmp+"0_bkp.dtc")
SX7->( DbCloseArea() )
USE "\system\sx7"+cEmp+"0.dtc" INDEX "\system\sx7"+cEmp+"0.cdx" ALIAS SX7 EXCLUSIVE
DELETE FOR SubStr(SX7->X7_CAMPO,1,3) >= "U00" .AND. SubStr(SX7->X7_CAMPO,1,3) <= "U99" .AND. SubStr(SX7->X7_CAMPO,3,1) <> "_"
PACK
APPEND FROM &(cPath+"SX7.DTC")
SX7->( DbCloseArea() )
DbSelectArea("SX7")

__CopyFile("\system\sx9"+cEmp+"0.dtc","\system\sx9"+cEmp+"0_bkp.dtc")
SX9->( DbCloseArea() )
USE "\system\sx9"+cEmp+"0.dtc" INDEX "\system\sx9"+cEmp+"0.cdx" ALIAS SX9 EXCLUSIVE
DELETE FOR SX9->X9_DOM >= "U00" .AND. SX9->X9_DOM <= "U99"
PACK
APPEND FROM &(cPath+"SX9.DTC")
SX9->( DbCloseArea() )
DbSelectArea("SX9")

__CopyFile("\system\sxa"+cEmp+"0.dtc","\system\sxa"+cEmp+"0_bkp.dtc")
SXA->( DbCloseArea() )
USE "\system\sxa"+cEmp+"0.dtc" INDEX "\system\sxa"+cEmp+"0.cdx" ALIAS SXA EXCLUSIVE
DELETE FOR SubStr(SXA->XA_ALIAS,1,3) >= "U00" .AND. SubStr(SXA->XA_ALIAS,1,3) <= "U99"
PACK
APPEND FROM &(cPath+"SXA.DTC")
SXA->( DbCloseArea() )
DbSelectArea("SXA")

__CopyFile("\system\sxb"+cEmp+"0.dtc","\system\sxb"+cEmp+"0_bkp.dtc")
SXB->( DbCloseArea() )
USE "\system\sxb"+cEmp+"0.dtc" INDEX "\system\sxb"+cEmp+"0.cdx" ALIAS SXB EXCLUSIVE
DELETE FOR SubStr(SXB->XB_ALIAS,1,3) >= "U00" .AND. SubStr(SXB->XB_ALIAS,1,3) <= "U99"
PACK
APPEND FROM &(cPath+"SXB.DTC")
SXB->( DbCloseArea() )
DbSelectArea("SXA")

USE "\system\sx2"+cEmp+"0.dtc" INDEX "\system\sx2"+cEmp+"0.cdx" ALIAS SX2 SHARED
DbSelectArea("SX2")
SX2->( DbSetOrder(1) )
SX2->( MsSeek( "U00" ) )
While	SX2->( !Eof() ) .AND.;
		SX2->X2_CHAVE >= "U00" .AND.;
		SX2->X2_CHAVE <= "U99"
	
	cFile := AllTrim(SX2->X2_ARQUIVO)
	(SX2->X2_CHAVE)->(DbCloseArea())
	TcSqlExec("DROP TABLE "+cFile)
	DbSelectArea( "SIX" )
	DbSelectArea( "SX2" )
	DbSelectArea( "SX3" )
	DbSelectArea( SX2->X2_CHAVE )
	APPEND FROM &(cPath+"BKP\"+cFile+".DTC")
	(SX2->X2_CHAVE)->(DbCloseArea())
	
	SX2->( DbSkip() )
End

Return(.T.)
