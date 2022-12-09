#INCLUDE 'APWEBSRV.CH'
#INCLUDE 'PROTHEUS.CH'
#include "TBICONN.CH"
#include "RWMAKE.CH"


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CSWS0003  �Autor  �Rodrigo Seiti Mitani� Data �  07/02/07   ���
�������������������������������������������������������������������������͹��
���Desc.     � Consulta dados do agendamento                              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

WSSTRUCT WSATEN        
	WSDATA DTA		AS String
	WSDATA HORA		AS String
	WSDATA LOCAL	AS String
ENDWSSTRUCT


WSSERVICE CSWS0003 DESCRIPTION "Servico de consulta ao atendimento"
	WSDATA ID			AS String     
	WSDATA CNPJ			AS String     
	WSDATA aATENDIMENTO	AS ARRAY OF WSATEN
	WSMETHOD CSW03AR
END WSSERVICE
         
WSMETHOD CSW03AR WSRECEIVE ID, CNPJ WSSEND aATENDIMENTO WSSERVICE CSWS0003
Local aRet, i

aRet := U_CSW03ATE(::ID,::CNPJ)

If Len(aRet) > 0
	::aATENDIMENTO := Array(Len(aRet))
	For i := 1 To Len(aRet)
		::aATENDIMENTO[i]		:= WSClassNew("WSATEN")	
		::aATENDIMENTO[i]:DTA	:= aRet[i,1]
		::aATENDIMENTO[i]:HORA	:= aRet[i,2]
		::aATENDIMENTO[i]:LOCAL	:= aRet[i,3]
	Next
Else
   //	SetSoapFault(aRet[2], aRet[3])
	Return(.F.)
EndIf
Return(.T.)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CSWS02AGE �Autor  �Rodrigo Seiti Mitani� Data �  07/02/07   ���
�������������������������������������������������������������������������͹��
���Desc.     � Consulta os dias disponiveis por AR ADVPL                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function CSW03ATE(_ID, _CNPJ)


Local _XCHAAR:= {}

//	PREPARE ENVIRONMENT EMPRESA '01' FILIAL '01';
//	TABLES "PA0","SA1","PA8","SB1","PA1","PA2","SX2","SX3", "PA9"


If Select("BRT") > 0
	DbSelectArea("BRT")
	DbCloseArea("BRT")
End If

If !Empty(_ID)

BeginSql Alias "BRT"
%noparser%                
Select PA0_DTAGEN, PA0_HRAGEN, PA0_AR From %Table:PA0% PA0 
Where PA0.%NotDel% AND PA0_OS = %Exp:AllTrim(_ID)%
EndSql

Else

BeginSql Alias "BRT"
%noparser%                
Select PA0_DTAGEN, PA0_HRAGEN, PA0_AR From %Table:PA0% PA0 
Where PA0.%NotDel% AND PA0_CLILOC||PA0_LOJLOC In (Select A1_COD||A1_LOJA From %Table:SA1% SA1
Where SA1.%NotDel% AND AND A1_CGC = %Exp:AllTrim(_CNPJ)%)
EndSql

End If 

If !Empty(BRT->PA0_DTAGEN)
	
	DbSelectArea("BRT")
	DbGoTop()
	Do While !Eof()
		AaDd(_XCHAAR,{BRT->PA0_DTAGEN, BRT->PA0_HRAGEN, BRT->PA0_AR})
	DbSkip()
	End Do	
Else
	//Alert("N�o h� agente disponivel para este agendamento")
End If
If Select("BRT") > 0
	DbSelectArea("BRT")
	DbCloseArea("BRT")
End If
//DbCloseAll()

Return(_XCHAAR)

