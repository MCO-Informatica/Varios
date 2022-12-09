#INCLUDE 'APWEBSRV.CH'
#INCLUDE 'PROTHEUS.CH'
#include "TBICONN.CH"
#include "RWMAKE.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CSWS0004  �Autor  �Rodrigo Seiti Mitani� Data �  08/06/07   ���
�������������������������������������������������������������������������͹��
���Desc.     �WebService para manutencao de atendimentos                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico da CertiSign                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


WSSERVICE CSWS0004 DESCRIPTION "Servico manuten��ao e cadastro de Atendimentos"

	WSDATA	CODTEC	AS String
	WSDATA	CNPJ			AS String
	WSDATA	PEDGAR	AS String
	WSDATA	DTA			AS String
	WSDATA	INIATE		AS String
	WSDATA	FIMATE		AS String
	WSDATA	AR				AS String
	WSDATA	TPCAD		AS Integer
	WSDATA	NUMATE	AS String
	WSDATA	FILORI		AS String
	WSDATA	RETCAD	AS String
	WSMETHOD ATEND

END WSSERVICE


WSMETHOD ATEND WSRECEIVE CODTEC, CNPJ, PEDGAR, DTA, INIATE, FIMATE, AR, TPCAD, NUMATE, FILORI  WSSEND RETCAD WSSERVICE CSWS0004

Local _xRet := " "
	_xRet:= U_CSWS04CAD(::CODTEC, ::CNPJ, ::PEDGAR, ::DTA, ::INIATE, ::FIMATE, ::AR, ::TPCAD, ::NUMATE, ::FILORI)
	::RETCAD := _xRet

Return(.T.)



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CSWS04CAD �Autor  �Rodrigo Seiti Mitani� Data �  08/06/07   ���
�������������������������������������������������������������������������͹��
���Desc.     �Executa a consulta de dias e horarios disponiveis para      ���
���          �agendamento                                                 ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico CertiSign                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


User Function CSWS04CAD(FCODTE, FCNPJ, FPEDGA, PDATA, FINIATE, FFIMATE, FAR, FTPCAD, FNUMAT, FIL)
Local _CT := .T.
Local _RET := "NAO EXECUTOU"


 /*
DbSelectArea("PA9")
DbSetOrder(1)           
DbGoTop()
DbSeek(xFilial("PA9")+AR)
//GetAdvFVal("PA9","PA9_ENDERE",xFilial("PA9")+AR,1,"")
If Found()
	_Filial := PA9->PA9_FILORI

End If
*/	
/*

If AllTrim(FIL) == '01'

	PREPARE ENVIRONMENT EMPRESA '01' FILIAL '01';
	TABLES "PA0","SA1","PA8","SB1","PA1","PA2","SX2","SX3", "PA9"

 //DbSelectArea("PA0")

	_NUMATE 		:= GETSXENUM("PA0","PA0_OS")

If AllTrim(FIL) == '02'

	PREPARE ENVIRONMENT EMPRESA '01' FILIAL '02';
	TABLES "PA0","SA1","PA8","SB1","PA1","PA2","SX2","SX3", "PA9"        

	_NUMATE 		:= GETSXENUM("PA0","PA0_OS")


End If
*/



/*
BeginSql Alias "BRT"
%noparser%
Select * From %Table:PA2% PA2 Where PA2_CODTEC = %Exp:CODTEC% 
and PA2.%NotDel% and PA2_DTINI = %Exp:DTA%
and %Exp:Substr(INIATE,1,2)||':'||StrZero((Val(Substr(INIATE,3,2))+1),2)% Between PA2_HRINI and PA2_HRFIM 
or %Exp:Substr(FIMATE,1,2)||':'||StrZero((Val(Substr(FIMATE,3,2))-1),2)% Between PA2_HRINI and PA2_HRFIM) 
EndSql
 */
	_XPASS1 := .F.
	_XPASS2 := .F.
	_XPASS3 := .F.
	_XPASS4 := .F.
	_XPASS5 := .F.


DbSelectArea("SA1")
DbSetOrder(3)
DbGoTop()     
DbSeek(xFilial("SA1")+U_CSFMTSA1(FCNPJ))
If Found()
	_CODCLIE	:= SA1->A1_COD
	_LOJA 	  	:= SA1->A1_LOJA
	_NOME	  	:= SA1->A1_NOME
	
Else
	_numcli := GETSXENUM("SA1","A1_COD")
	DbSelectArea("SA1")
	DbSetOrder(1)
	DbGoTop()
	DbSeek("  "+_numcli)
	RecLock("SA1",.T.)
	SA1->A1_COD 	:= _numcli
	SA1->A1_LOJA	:= "01"
	SA1->A1_CGC 	:= FCNPJ
	SA1->A1_STATVEN := "1"
	MsUnlock()     
	ConfirmSX8()
	_CODCLIE 	:= SA1->A1_COD
	_LOJA 		:= "01"
	_NOME		:= " "

End If

	_NUMATE 		:= GETSXENUM("PA0","PA0_OS")

If FTPCAD == 3

If Select("BRT") > 0
	DbSelectArea("BRT")
	DbCloseArea("BRT")
End If


BeginSql Alias "BRT"
%noparser%
Select AA1_CODTEC,AA1_NOMTEC From %Table:AA1% AA1 Where AA1.%NotDel% and AA1_CODTEC
Not In(Select PA2_CODTEC From %Table:PA2% PA2 Where PA2.%NotDel% and
(%Exp:AllTrim(PDATA)% <= PA2_DTFIM And %Exp:AllTrim(FINIATE)||'1'% <= PA2_HRFIM And %Exp:AllTrim(PDATA)%
 >= PA2_DTINI And %Exp:AllTrim(FINIATE)||'1'% >= PA2_HRINI ))
 and AA1_CODTEC||%Exp:AllTrim(PDATA)% In (Select PAA_CODTEC||PAA_DATA From %Table:PAA% PAA Where PAA.%NotDel% and PAA_CODAR = %Exp:AllTrim(FAR)%)

EndSql

If !Empty(BRT->AA1_NOMTEC)
/*
If Select("LIX") > 0
	DbSelectArea("LIX")
	DbCloseArea("LIX")
End If
 
BeginSql Alias "LIX"
%noparser%
Select Max(PA0_OS) As PA0_OS From %Table:PA0% PA0 Where PA0_FILIAL = %Exp:AllTrim(AllTrim(FIL))% and PA0.%NotDel%'
Order By PA0_OS
EndSql

	_NUMATE := Soma1(LIX->PA0_OS)
*/	
	RecLock("PA0",.T.)
	PA0->PA0_FILIAL	:= xFilial("PA0")
	PA0->PA0_OS		:= _NUMATE
	PA0->PA0_CLILOC	:= _CODCLIE
	PA0->PA0_LOJLOC	:= _LOJA
	PA0->PA0_CLLCNO	:= _NOME
	PA0->PA0_CONDPA	:= "001"
	PA0->PA0_DTAGEN	:= SToD(PDATA)
	PA0->PA0_HRAGEN	:= FINIATE
	PA0->PA0_AR		:= FAR
	PA0->PA0_END	:= GetAdvFVal("PA9","PA9_ENDERE",xFilial("PA9")+FAR,1,"")
	PA0->PA0_CIDADE		:= GetAdvFVal("PA9","PA9_CIDADE",xFilial("PA9")+FAR,1,"")
	PA0->PA0_STATUS:= "A"
	PA0->PA0_SITUAC:= "L"   
	PA0->PA0_FILORI := AllTrim(FIL)
	PA0->PA0_TPSERV := 'I'

	MsUnlock()
	

	RecLock("PA2",.T.)
	PA2->PA2_FILIAL	:= xFilial("PA2")
	PA2->PA2_CODTEC	:= FCODTE
	PA2->PA2_NOMTEC	:= GetAdvFVal("AA1","AA1_NOMTEC",xFilial("AA1")+FCODTE,1,"")
	PA2->PA2_NUMOS	:= _NUMATE
	PA2->PA2_DTINI	:= SToD(PDATA)
	PA2->PA2_HRINI	:= FINIATE
	PA2->PA2_DTFIM	:= SToD(PDATA)
	PA2->PA2_HRFIM	:= FFIMATE
	MsUnlock()



	RecLock("PA1",.T.)
	PA1->PA1_FILIAL	:= xFilial("PA1")
	PA1->PA1_OS		:= _NUMATE
	PA1->PA1_ITEM	:= '0001'
	PA1->PA1_PRODUT	:= "SV010001"
	PA1->PA1_DESCRI	:= GetAdvFVal("SB1","B1_DESC",xFilial("SB1")+"SV010001",1,"")
	PA1->PA1_QUANT	:= 1
	PA1->PA1_PRCUNI	:= 0
	PA1->PA1_VALOR	:= 0
	PA1->PA1_PEDIDO	:= FPEDGA
	PA1->PA1_TES	:= GetAdvFVal("SB1","B1_TS",xFilial("SB1")+"SV010001",1,"")
	PA1->PA1_FATURA	:= "F"
	PA1->PA1_CNPJ	:= FCNPJ
	MsUnlock()
	
	
	ConfirmSX8()

	_RET := _NUMATE
Else
	_RET := "" 	
End If
ElseIf FTPCAD == 4

If Select("BRT") > 0
	DbSelectArea("BRT")
	DbCloseArea("BRT")
End If


BeginSql Alias "BRT"
%noparser%
Select AA1_CODTEC,AA1_NOMTEC From %Table:AA1% AA1 Where AA1.%NotDel% and AA1_CODTEC
Not In(Select PA2_CODTEC From %Table:PA2% PA2 Where PA2.%NotDel% and
(%Exp:AllTrim(PDATA)% <= PA2_DTFIM And %Exp:AllTrim(FINIATE)||'1'% <= PA2_HRFIM And %Exp:AllTrim(PDATA)%
 >= PA2_DTINI And %Exp:AllTrim(FINIATE)||'1'% >= PA2_HRINI ))
 and AA1_CODTEC||%Exp:AllTrim(PDATA)% In (Select PAA_CODTEC||PAA_DATA From %Table:PAA% PAA Where PAA.%NotDel% and PAA_CODAR = %Exp:AllTrim(FAR)%)

EndSql

If !Empty(BRT->AA1_NOMTEC)
	
	DbSelectArea("PA2")
	DbSetOrder(3)
	DbGoTop()
	DbSeek(xFilial("PA2")+FNUMAT)
	If Found()
		RecLock("PA2",.F.)
		PA2->PA2_CODTEC	:= FCODTE
		PA2->PA2_NOMTEC	:= GetAdvFVal("AA1","AA1_NOMTEC",xFilial("AA1")+FCODTE,1,"")
		PA2->PA2_DTINI	:= SToD(PDATA)
		PA2->PA2_HRINI	:= FINIATE
		PA2->PA2_DTFIM	:= SToD(PDATA)
		PA2->PA2_HRFIM	:= FFIMATE
		MsUnlock()
		_XPASS2 := .T.

	End If

	DbSelectArea("PA0")
	DbSetOrder(1)
	DbGoTop()
	DbSeek(xFilial("PA0")+FNUMAT)
	If Found()
		RecLock("PA0",.F.)
		PA0->PA0_CLILOC	:= _CODCLIE
		PA0->PA0_LOJLOC	:= _LOJA
		PA0->PA0_CLLCNO	:= _NOME
		PA0->PA0_DTAGEN	:= SToD(PDATA)
		PA0->PA0_HRAGEN	:= FINIATE
		PA0->PA0_AR		:= FAR
		PA0->PA0_END	:= GetAdvFVal("PA9","PA9_ENDERE",xFilial("PA9")+FAR,1,"")
		PA0->PA0_CIDADE		:= GetAdvFVal("PA9","PA9_CIDADE",xFilial("PA9")+FAR,1,"")
		PA0->PA0_FILORI := AllTrim(FIL)
		MsUnlock()
	_XPASS1 := .T.
	End If


If _XPASS1 .and. _XPASS2
	_RET := FNUMAT
End If
Else
	_RET := "" 	
End If
	                                                                                                                               '
ElseIf FTPCAD == 5
	
	DbSelectArea("PA0")
	DbSetOrder(1)
	DbGoTop()
	DbSeek(xFilial("PA0")+FNUMAT)
	If Found()
		RecLock("PA0",.F.)
		DbDelete()
		MsUnlock()
	_XPASS3 := .T.
	End If

	DbSelectArea("PA1")
	DbSetOrder(1)
	DbGoTop()
	DbSeek(xFilial("PA0")+FNUMAT)
	If Found()
		RecLock("PA1",.F.)
		DbDelete()
		MsUnlock()
	_XPASS4 := .T.

	End If

	DbSelectArea("PA2")
	DbSetOrder(3)
	DbGoTop()
	DbSeek(xFilial("PA0")+FNUMAT)
	If Found()
		RecLock("PA2",.F.)
		DbDelete()
		MsUnlock()
	_XPASS5 := .T.
	
	End If

If _XPASS3 .and. _XPASS4 .and. _XPASS5
	_RET := FNUMAT
End If

	//_RET := "OK"
	
End If


//DbCloseAll()



Return(_RET)

