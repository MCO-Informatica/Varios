#INCLUDE "PROTHEUS.CH"

/*
+=========================================================+
|Programa: COMP005 |Autor: Antonio Carlos |Data: 03/03/10 |
+=========================================================+
|Descricao: Rotina responsavel pela Aprovação/Bloqueio do |
|Pedido de Compra via e-mail.                             |
+=========================================================+
|Uso: Especifico Laselva                                  |
+=========================================================+
*/

User Function COMP005(oProcess)

Local _cEmail
Local _cHtm			:= ""
Local _cRetorn		:= ""
Local _cGrupo		:= Space(6)
Local _cHtm			:= ""
Local _cObs			:= ""
Local _nValPed		:= 0
Local _nSaldo		:= 0
Local _nSaldoI		:= 0
Local _nVlrPed		:= 0
Local _nContr		:= 0
Local nTotal		:= 0
Local _lAprov		:= .T.
Local _lAprova		:= .F.
Local _cEmail
Public _cFilial		:= ""
Public _cNumPed		:= ""
Public _aAprov		:= {}
Public _cRespS		:= Space(6)
Public _cRespSo		:= ""
Public _cUser		:= Space(6)
Public _cComprad	:= ""
Public _cGrpApv		:= Space(6)

ConOut("COMP005 - CNUMEMP: "  )
ConOut("COMP005 - CNUMEMP: " + cNumEmp )
ConOut("COMP005 - SIGAMAT: " + SM0->M0_FILIAL )

_cFilial			:= oProcess:oHtml:RetByName("EMPRESA")
_cNumPed			:= oProcess:oHtml:RetByName("PEDIDO")
_cRetorn			:= oProcess:oHtml:RetByName("RBAPROVA")
_cUser				:= oProcess:oHtml:RetByName("RESPUSR")
_cComprad			:= oProcess:oHtml:RetByName("COMPRADOR")
_cGrpApv			:= Posicione("SAK",2,xFilial("SAK")+_cUser,"AK_COD")
_cObsA				:= Alltrim(oProcess:oHtml:RetByName("S2"))

/*
_cFilial			:= "01"
_cNumPed			:= "588383"
_cRetorn			:= "S"
_cUser				:= "000312"
_cComprad			:= "aguilherme"
_cGrpApv			:= Posicione("SAK",2,xFilial("SAK")+_cUser,"AK_COD")
_cObsA				:= "TESTE"
*/
conout("COMP005 - Retorno: "+_cRetorn)
If Substr(_cRetorn,1,1) == "S"
	
	DbSelectArea("SCR")
	SCR->( DbSetOrder(2) )
	If SCR->( DbSeek( Substr(_cFilial,1,2)+"PC"+_cNumPed+Space(44)+_cUser ) )
		
		_nValPed := SCR->CR_TOTAL
		
		If SCR->CR_NIVEL == "01" .And. SCR->CR_STATUS <> "03"
			
			RecLock("SCR",.F.)
			SCR->CR_DATALIB	:= dDataBase
			SCR->CR_STATUS	:= "03"
			SCR->CR_USERLIB := _cUser
			SCR->CR_VALLIB	:= SCR->CR_TOTAL
			SCR->CR_TIPOLIM := "D"
			SCR->CR_LIBAPRO := SCR->CR_LIBAPRO
			SCR->( MsUnLock() )
			
			DbSelectArea("SCS")
			SCS->( DbSetOrder(1) )
			If SCS->( DbSeek( xFilial("SCS")+_cUser+DToS(dDatabase) ) )
				_nSaldo := SCS->CS_SALDO
				RecLock("SCS",.F.)
				SCS->CS_FILIAL	:= xFilial("SCS")
				SCS->CS_SALDO 	:= _nSaldo - _nValPed
				SCS->( MsUnLock() )
			Else
				_nSaldoI := Posicione("SAK",2,xFilial("SAK")+_cUser,"AK_LIMITE")
				RecLock("SCS",.T.)
				SCS->CS_FILIAL	:= xFilial("SCS")
				SCS->CS_COD		:= _cUser
				SCS->CS_DATA	:= dDatabase
				SCS->CS_MOEDA	:= 1
				SCS->CS_SALDO	:= _nSaldoI - _nValPed
				SCS->CS_APROV	:= _cGrpApv
				SCS->( MsUnLock() )
			EndIf
			
			DbSelectArea("SCR")
			SCR->( DbSetOrder(1) )
			If SCR->( DbSeek( Substr(_cFilial,1,2)+"PC"+_cNumPed+Space(44)+"02" ) )
				
				RecLock("SCR",.F.)
				SCR->CR_STATUS	:= "02"
				SCR->( MsUnLock() )
				
			EndIf
			// -------------------------------------- \/
			U_APV097("02",_cNumPed,.F.)
			// -------------------------------------- /\
			
		ElseIf SCR->CR_NIVEL == "02" .And. SCR->CR_STATUS <> "03"
			
			RecLock("SCR",.F.)
			SCR->CR_DATALIB		:= dDataBase
			SCR->CR_STATUS		:= "03"
			SCR->CR_USERLIB 	:= _cUser
			SCR->CR_VALLIB		:= SCR->CR_TOTAL
			SCR->CR_TIPOLIM 	:= "D"
			SCR->CR_LIBAPRO 	:= SCR->CR_LIBAPRO
			SCR->( MsUnLock() )
			
			DbSelectArea("SCS")
			SCS->( DbSetOrder(1) )
			If SCS->( DbSeek( xFilial("SCS")+_cUser+DToS(dDatabase) ) )
				_nSaldo := SCS->CS_SALDO
				RecLock("SCS",.F.)
				SCS->CS_FILIAL	:= xFilial("SCS")
				SCS->CS_SALDO 	:= _nSaldo - _nValPed
				SCS->( MsUnLock() )
			Else
				_nSaldoI := Posicione("SAK",2,xFilial("SAK")+_cUser,"AK_LIMITE")
				RecLock("SCS",.T.)
				SCS->CS_FILIAL	:= xFilial("SCS")
				SCS->CS_COD		:= _cUser
				SCS->CS_DATA	:= dDatabase
				SCS->CS_MOEDA	:= 1
				SCS->CS_SALDO	:= _nSaldoI - _nValPed
				SCS->CS_APROV	:= _cGrpApv
				SCS->( MsUnLock() )
			EndIf
			
			DbSelectArea("SCR")
			SCR->( DbSetOrder(1) )
			If SCR->( DbSeek( Substr(_cFilial,1,2)+"PC"+_cNumPed+Space(44)+"03" ) )
				
				RecLock("SCR",.F.)
				SCR->CR_STATUS	:= "02"
				SCR->( MsUnLock() )
				
			EndIf
			// -------------------------------------- \/
			U_APV097("03",_cNumPed,.F.)
			// -------------------------------------- /\
			
		ElseIf ( SCR->CR_NIVEL == "03" .And. SCR->CR_STATUS <> "03" )
			
			RecLock("SCR",.F.)
			SCR->CR_DATALIB	:= dDataBase
			SCR->CR_STATUS	:= "03"
			SCR->CR_USERLIB := _cUser
			SCR->CR_VALLIB	:= SCR->CR_TOTAL
			SCR->CR_TIPOLIM := "D"
			SCR->CR_LIBAPRO := SCR->CR_LIBAPRO
			SCR->( MsUnLock() )
			
			DbSelectArea("SCS")
			SCS->( DbSetOrder(1) )
			If SCS->( DbSeek( xFilial("SCS")+_cUser+DToS(dDatabase) ) )
				_nSaldo := SCS->CS_SALDO
				RecLock("SCS",.F.)
				SCS->CS_FILIAL	:= xFilial("SCS")
				SCS->CS_SALDO := _nSaldo - _nValPed
				SCS->( MsUnLock() )
			Else
				_nSaldoI := Posicione("SAK",2,xFilial("SAK")+_cUser,"AK_LIMITE")
				RecLock("SCS",.T.)
				SCS->CS_FILIAL	:= xFilial("SCS")
				SCS->CS_COD		:= _cUser
				SCS->CS_DATA	:= dDatabase
				SCS->CS_MOEDA	:= 1
				SCS->CS_SALDO	:= _nSaldoI - _nValPed
				SCS->CS_APROV	:= _cGrpApv
				SCS->( MsUnLock() )
			EndIf
			
			DbSelectArea("SCR")
			SCR->( DbSetOrder(1) )
			If SCR->( DbSeek( Substr(_cFilial,1,2)+"PC"+_cNumPed+Space(44)+"04" ) )
				
				RecLock("SCR",.F.)
				SCR->CR_STATUS	:= "02"
				SCR->( MsUnLock() )
				
			EndIf
			
			// -------------------------------------- \/
			U_APV097("04",_cNumPed,.F.)
			// -------------------------------------- /\
			
		ElseIf SCR->CR_NIVEL == "04" .And. SCR->CR_STATUS <> "03"
			
			DbSelectArea("SCR")
			SCR->( DbSetOrder(1) )
			SCR->( DbSeek( Substr(_cFilial,1,2)+"PC"+_cNumPed ) )
			
			While SCR->( !Eof() ) .And. Substr(_cFilial,1,2) == SCR->CR_FILIAL .And. Alltrim(SCR->CR_NUM) == _cNumPed
				
				If SCR->CR_STATUS <> "03"
					
					RecLock("SCR",.F.)
					SCR->CR_DATALIB	:= dDataBase
					SCR->CR_STATUS	:= "03"
					SCR->CR_USERLIB := _cUser
					SCR->CR_VALLIB	:= SCR->CR_TOTAL
					SCR->CR_TIPOLIM := "D"
					SCR->CR_LIBAPRO := SCR->CR_LIBAPRO
					SCR->( MsUnLock() )
					
				EndIf
				
				SCR->( DbSkip() )
				
			EndDo
			
			DbSelectArea("SCS")
			SCS->( DbSetOrder(1) )
			If SCS->( DbSeek( xFilial("SCS")+_cUser+DToS(dDatabase) ) )
				_nSaldo := SCS->CS_SALDO
				RecLock("SCS",.F.)
				SCS->CS_FILIAL	:= xFilial("SCS")
				SCS->CS_SALDO 	:= _nSaldo - _nValPed
				SCS->( MsUnLock() )
			Else
				_nSaldoI := Posicione("SAK",2,xFilial("SAK")+_cUser,"AK_LIMITE")
				RecLock("SCS",.T.)
				SCS->CS_FILIAL	:= xFilial("SCS")
				SCS->CS_COD		:= _cUser
				SCS->CS_DATA	:= dDatabase
				SCS->CS_MOEDA	:= 1
				SCS->CS_SALDO	:= _nSaldoI - _nValPed
				SCS->CS_APROV	:= _cGrpApv
				SCS->( MsUnLock() )
			EndIf
			
			DbSelectArea("SCR")
			SCR->( DbSetOrder(1) )
			If SCR->( DbSeek( Substr(_cFilial,1,2)+"PC"+_cNumPed+Space(44)+"05" ) )
				
				RecLock("SCR",.F.)
				SCR->CR_STATUS	:= "03"
				SCR->( MsUnLock() )
				
			EndIf
			
			// Chama função que envia alerta de aprovação do Workflow
			//conout("COMP005 - WFPCA5")
			//U_AWFPC()
			U_APV097("05",_cNumPed,.F.)
			
		ElseIf SCR->CR_NIVEL == "05" .And. SCR->CR_STATUS <> "03"
			
			RecLock("SCR",.F.)
			SCR->CR_DATALIB	:= dDataBase
			SCR->CR_STATUS	:= "03"
			SCR->CR_USERLIB := _cUser
			SCR->CR_VALLIB	:= SCR->CR_TOTAL
			SCR->CR_TIPOLIM := "D"
			SCR->CR_LIBAPRO := SCR->CR_LIBAPRO
			SCR->( MsUnLock() )
			
			DbSelectArea("SCS")
			SCS->( DbSetOrder(1) )
			If SCS->( DbSeek( xFilial("SCS")+_cUser+DToS(dDatabase) ) )
				_nSaldo := SCS->CS_SALDO
				RecLock("SCS",.F.)
				SCS->CS_FILIAL	:= xFilial("SCS")
				SCS->CS_SALDO := _nSaldo - _nValPed
				SCS->( MsUnLock() )
			Else
				_nSaldoI := Posicione("SAK",2,xFilial("SAK")+_cUser,"AK_LIMITE")
				RecLock("SCS",.T.)
				SCS->CS_FILIAL	:= xFilial("SCS")
				SCS->CS_COD		:= _cUser
				SCS->CS_DATA	:= dDatabase
				SCS->CS_MOEDA	:= 1
				SCS->CS_SALDO	:= _nSaldoI - _nValPed
				SCS->CS_APROV	:= _cGrpApv
				SCS->( MsUnLock() )
			EndIf
			
			// Chama função que envia alerta de aprovação do Workflow
			//conout("COMP005 - WFPCA6")
			//U_AWFPC()
			U_APV097("06",_cNumPed,.F.)
			
		EndIf
		
	EndIf
	
Else
	
	// Chama função que envia alerta de reprovação do Workflow
	conout("COMP005 - WFPCR1")
	U_RWFPC()
	
EndIf

Return
