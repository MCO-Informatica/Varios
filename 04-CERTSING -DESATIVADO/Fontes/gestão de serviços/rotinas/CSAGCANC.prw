#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "TBICONN.CH"

User Function CSFSVDTA(aParam)

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


If PA0->PA0_STATUS == '1'
	
	DbSelectArea("PA0")
	DbSetOrder(1)
	DbSeek(xFilial("PA0")+cOs)
			
	If PA0->(Found())
	
		BEGIN TRANSACTION
		
			RecLock("PA0",.F.)
			PA0->PA0_STATUS := "F"
			MsUnlock()
	
		END TRANSACTION
	
	Else
				
		lRet := .F.
				
		Return lRet
				
	Endif
							
	DbSelectArea("ADE")
	DbSetOrder(1)
	DbSeek(xFilial("ADE")+PA0->PA0_PROTOC)
	
	cCodigo := ADE->ADE_CODIGO
			
	If ADE->(Found())
		
		BEGIN TRANSACTION                         
	
			RecLock("ADE",.F.)	
			ADE->ADE_STATUS := "3"				
			MsUnlock()
	
		END TRANSACTION
			
		cOcor	:= "006451"
		cAcao	:= "000406"
			
		dbSelectArea("ADF")
		dbSetOrder(1)
		dbSeek(xFilial("ADF")+cCodigo)
			
		ADF->(DbGoBottom())
			
		cItem := ADF->ADF_ITEM++			
			
		BEGIN TRANSACTION                         
	
			RecLock("ADF",.T.)
			ADF->ADF_CODIGO		:= cCodigo
			ADF->ADF_ITEM 		:= cItem
			ADF->ADF_CODSU9 	:= cOcor
			ADF->ADF_CODSUQ		:= cAcao
			ADF->ADF_CODSU7		:= "000001"
			ADF->ADF_CODSU0		:= "9G"
			ADF->ADF_DATA		:= dDataBase
			ADF->ADF_HORA		:= Time()	
			ADF->ADF_HORAF		:= Time()
			ADF->ADF_OS			:= cOs	
			MsUnlock()
	
		END TRANSACTION
			
		ConOut("Ordem de Serviço Cancelada! Codigo=" + cCodigo)		

		lRet := .T.
		
	Else
				
		lRet := .F.
				
		Return lRet
				
	Endif
		
	DbSelectArea("PAW")
	DbSetOrder(4)
	DbSeek(xFilial("PAW")+cOs)
	
	If PAW->(Found())
	
		BEGIN TRANSACTION
	
			RecLock("PAW",.F.)
			DbDelete()
			MsUnlock()
	
		END TRANSACTION
	
	Else
				
		lRet := .F.
			
		Return lRet
				
	Endif
		
	DbSelectArea("PA2")
	DbSetOrder(2)
	DbSeek(xFilial("PA2")+cOs)
	
	If PA2->(Found())
		
		While PA2->(!EOF())
	
			RecLock("PA2",.F.)
			DbDelete()
			MsUnlock()
				
			PA2->(dbSkip())
				
		End
				
	Endif
			
Aviso( "Solicitação de Atendimento", "OS Cancelada com sucesso", {"Ok"} )

lRet:= .T.
		
Else
		
	MsgAlert("Não é possivel cancelar a OS, pois a mesma não se encontra pendente")
		
	lRet := .F.
			
Endif	

Return