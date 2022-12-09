#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "TBICONN.CH"

User Function CSFSVDTB(aParam)

Local cEmp := ''
Local cFil := ''

cEmp := IIF( aParam == NIL,'01', aParam[1])
cFil := IIF( aParam == NIL,'02', aParam[2])

RpcSetType( 3 )
PREPARE ENVIRONMENT EMPRESA cEmp FILIAL cFil

		CSFSJOB1()

RESET ENVIRONMENT

Return		

Static Function CSFSJOB1()


cQryPA0 := " SELECT PA0_OS, PA0_SITUAC, PA0_DTVBOL, PA0_EMAIL, PA0_AVISO "
cQryPA0 += " FROM "+RetSqlName("PA0")
cQryPA0 += " WHERE D_E_L_E_T_ = '' "
cQryPA0 += " AND PA0_SITUAC = 'B'"
cQryPA0 += " AND PA0_STATUS = 'C'"
cQryPA0 += " AND PA0_DTVBOL <> ''"
cQryPA0 += " AND '"+dtos(dDataBase)+"' > PA0_DTVBOL" 

cQryPA0 = changequery(cQryPA0)

If Select("TRB") > 0
	DbSelectArea("TRB")
	DbCloseArea("TRB")
End If 

dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQryPA0),"TRB",.F.,.T.)

dbSelectArea("TRB")
TRB->(dbGoTop())

While !Eof()

	if TRB->PA0_AVISO == 'N' .or. TRB->PA0_AVISO == ''

		if (U_CSMailC(TRB->PA0_OS))
		
		BEGIN TRANSACTION
		RecLock("PA0",.F.)
			PA0->PA0_AVISO := "S"
			PA0->PA0_STATUS := "A"
		MsUnlock()
		END TRANSACTION
		
		Endif
	
	Endif	
	
	dbSkip()  				  

End 	

Return