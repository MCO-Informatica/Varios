#INCLUDE 'APWEBSRV.CH'
#INCLUDE 'PROTHEUS.CH'
#include "TBICONN.CH"
#include "RWMAKE.CH"


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CSWS0002  �Autor  �Rodrigo Seiti Mitani� Data �  07/02/07   ���
�������������������������������������������������������������������������͹��
���Desc.     � Consulta os dias disponiveis por AR                        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

WSSTRUCT WSDISPODIA
WSDATA DIA	AS String
WSDATA HORA	AS String
ENDWSSTRUCT


WSSERVICE CSWS0002 DESCRIPTION "Servico de consulta dias disponiveis por AR"
WSDATA MES			AS String
WSDATA ANO			AS String
WSDATA AR			AS String
WSDATA aDISPODIA	AS ARRAY OF WSDISPODIA
WSMETHOD AGEDIA
END WSSERVICE

WSMETHOD AGEDIA WSRECEIVE MES, ANO, AR WSSEND aDISPODIA WSSERVICE CSWS0002
Local aRet, i

aRet := U_CSW02AGE(::MES, ::ANO, ::AR)
If Len(aRet) > 0
::aDISPODIA := Array(Len(aRet))
For i := 1 To Len(aRet)
::aDISPODIA[i]         := WSClassNew("WSDISPODIA")
::aDISPODIA[i]:DIA     := aRet[i,1]
::aDISPODIA[i]:HORA    := aRet[i,2]

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
���Uso       � AP                                                      	  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function CSW02AGE(_PRMES, _PRANO, _AR)
Local _XDIA:= {}

//PREPARE ENVIRONMENT EMPRESA '01' FILIAL '01'



If Select("BRT") > 0
	DbSelectArea("BRT")
	DbCloseArea("BRT")
End If

/*
BeginSql Alias "BRT"
%noparser%
Select PAA_CODAR, PAA_CODTEC, PAA_DATA,
((Cast(Substr(PAA_HRINI,1,2)   As Number(13,2)))+((Cast(Substr(PAA_HRINI,4,2)  As Number(13,2)))/60)) As HRINIAR,
((Cast(Substr(PAA_HRFIM,1,2)   As Number(13,2)))+((Cast(Substr(PAA_HRFIM,4,2)  As Number(13,2)))/60)) As HRFIMAR,
((Cast(Substr(PAA_HRALIN,1,2)  As Number(13,2)))+((Cast(Substr(PAA_HRALIN,4,2) As Number(13,2)))/60)) As HRINIAL,
((Cast(Substr(PAA_HRALFI,1,2)  As Number(13,2)))+((Cast(Substr(PAA_HRALFI,4,2) As Number(13,2)))/60)) As HRFIMAL,
(((Cast(Substr(PA9_TMPATE,1,2) As Number(13,2)))+((Cast(Substr(PA9_TMPATE,4,2) As Number(13,2)))/60))+
((Cast(Substr(PA9_TMPINT,1,2)  As Number(13,2)))+((Cast(Substr(PA9_TMPINT,4,2) As Number(13,2)))/60))) As TMPATE,
PA2_DTINI,
((Cast(Substr(PA2_HRINI,1,2)   As Number(13,2)))+((Cast(Substr(PA2_HRINI,4,2)  As Number(13,2)))/60)) As HRINIAT,
((Cast(Substr(PA2_HRFIM,1,2)   As Number(13,2)))+((Cast(Substr(PA2_HRFIM,4,2)  As Number(13,2)))/60)) As HRFIMAT
From %Table:PAA% PAA, %Table:PA2% PA2, %Table:PA9% PA9
Where PAA.%NotDel% and PA2.%NotDel% and PA9.%NotDel%
and Substring(PAA_DATA,5,2) = %Exp:AllTrim(_PRMES)%
and Left(PAA_DATA,4) = %Exp:AllTrim(_PRANO)%
and PAA_CODAR = %Exp:AllTrim(_AR)%
and PA2_CODTEC = PAA_CODTEC
and PA2_DTINI = PAA_DATA
and PA9_CODAR = PAA_CODAR
Union
Select PAA_CODAR, PAA_CODTEC, PAA_DATA,
((Cast(Substr(PAA_HRINI,1,2)   As Number(13,2)))+((Cast(Substr(PAA_HRINI,4,2)  As Number(13,2)))/60)) As HRINIAR,
((Cast(Substr(PAA_HRFIM,1,2)   As Number(13,2)))+((Cast(Substr(PAA_HRFIM,4,2)  As Number(13,2)))/60)) As HRFIMAR,
((Cast(Substr(PAA_HRALIN,1,2)  As Number(13,2)))+((Cast(Substr(PAA_HRALIN,4,2) As Number(13,2)))/60)) As HRINIAL,
((Cast(Substr(PAA_HRALFI,1,2)  As Number(13,2)))+((Cast(Substr(PAA_HRALFI,4,2) As Number(13,2)))/60)) As HRFIMAL,
(((Cast(Substr(PA9_TMPATE,1,2) As Number(13,2)))+((Cast(Substr(PA9_TMPATE,4,2) As Number(13,2)))/60))+
((Cast(Substr(PA9_TMPINT,1,2)  As Number(13,2)))+((Cast(Substr(PA9_TMPINT,4,2) As Number(13,2)))/60))) As TMPATE,
PAA_DATA as PA2_DTINI,
0 AS HRINIAT,
0 As HRFIMAT
From %Table:PAA% PAA,  %Table:PA9% PA9
Where PAA.%NotDel% and PA9.%NotDel%
and Substr(PAA_DATA,5,2) = %Exp:AllTrim(_PRMES)%
and Substr(PAA_DATA,1,4) = %Exp:AllTrim(_PRANO)%
and PAA_CODAR = %Exp:AllTrim(_AR)%
and PA9_CODAR = PAA_CODAR
and PAA_CODTEC||PAA_DATA Not In (Select PA2_CODTEC||PA2_DTINI From %Table:PA2% PA2
Where PA2.%NotDel% Group By PA2_CODTEC,PA2_DTINI)
Order By PAA_CODTEC, PAA_DATA,  HRINIAT
EndSql
*/
BeginSql Alias "BRT"
%noparser%
Select PAA_CODAR, PAA_CODTEC, PAA_DATA,
((Cast(Substr(PAA_HRINI,1,2)   As Number(13,2)))+((Cast(Substr(PAA_HRINI,4,2)  As Number(13,2)))/60)) As HRINIAR,
((Cast(Substr(PAA_HRFIM,1,2)   As Number(13,2)))+((Cast(Substr(PAA_HRFIM,4,2)  As Number(13,2)))/60)) As HRFIMAR,
((Cast(Substr(PAA_HRALIN,1,2)  As Number(13,2)))+((Cast(Substr(PAA_HRALIN,4,2) As Number(13,2)))/60)) As HRINIAL,
((Cast(Substr(PAA_HRALFI,1,2)  As Number(13,2)))+((Cast(Substr(PAA_HRALFI,4,2) As Number(13,2)))/60)) As HRFIMAL,
(((Cast(Substr(PA9_TMPATE,1,2) As Number(13,2)))+((Cast(Substr(PA9_TMPATE,4,2) As Number(13,2)))/60))+
((Cast(Substr(PA9_TMPINT,1,2)  As Number(13,2)))+((Cast(Substr(PA9_TMPINT,4,2) As Number(13,2)))/60))) As TMPATE,
PAA_DATA as PA2_DTINI,
0 AS HRINIAT,
0 As HRFIMAT
From %Table:PAA% PAA,  %Table:PA9% PA9
Where PAA.%NotDel% and PA9.%NotDel%
and Substr(PAA_DATA,5,2) = %Exp:AllTrim(_PRMES)%
and Substr(PAA_DATA,1,4) = %Exp:AllTrim(_PRANO)%
and PAA_CODAR = %Exp:AllTrim(_AR)%
and PA9_CODAR = PAA_CODAR
Order By PAA_CODTEC, PAA_DATA,  HRINIAT
EndSql
/*
DbSelectArea("BRT")

DbGoTop()

Do While !Eof()
	nCt:=  nCt +1
	
	DbSkip()
End Do
*/
DbSelectArea("BRT")

DbGoTop()

If !Empty(BRT->PAA_CODAR)
	
	/*	DbSelectArea("BRT")
	
	//	DbGoTop()
	
	xCt:=0
	_FLAGFI := BRT->HRINIAT
	_TMPAL 		:= BRT->HRINIAL
	_TMPFIMAL := BRT->HRFIMAL
	_TMPAT := BRT->HRINIAT
	_XFLAGAL := .T.
	_FLAGDT:= .T.
	_XDATA := BRT->PAA_DATA
	*/
	Do While !Eof("BRT")
		_TMPATE 	:= BRT->HRINIAR
		_TMPFIM 	:= BRT->HRFIMAR
		_TMPINIAL	:= Iif(BRT->HRINIAL == 0,23, BRT->HRINIAL)
		_TMPFIMAL	:= Iif(BRT->HRFIMAL == 0,23, BRT->HRFIMAL)
		_XDATA 		:= BRT->PAA_DATA
		_XHRINI := _TMPATE
		_XHRFIM := _TMPATE + BRT->TMPATE
		
If SToD(BRT->PAA_DATA) >= DDataBase 

If Select("AGT") > 0
	DbSelectArea("AGT")
	DbCloseArea("AGT")
End If

BeginSql Alias "AGT"
%noparser%
Select PAA_CODAR, PAA_CODTEC, PAA_DATA,PA2_DTINI,
((Cast(Substr(PA2_HRINI,1,2)   As Number(13,2)))+((Cast(Substr(PA2_HRINI,4,2)  As Number(13,2)))/60)) As HRINIAT,
((Cast(Substr(PA2_HRFIM,1,2)   As Number(13,2)))+((Cast(Substr(PA2_HRFIM,4,2)  As Number(13,2)))/60)) As HRFIMAT
From %Table:PAA% PAA, %Table:PA2% PA2, %Table:PA9% PA9
Where PAA.%NotDel% and PA2.%NotDel% and PA9.%NotDel%
and PAA_DATA = %Exp:AllTrim(BRT->PAA_DATA)%
and PAA_CODAR = %Exp:AllTrim(BRT->PAA_CODAR)%
and PAA_CODTEC = %Exp:AllTrim(BRT->PAA_CODTEC)%
and PA2_CODTEC = PAA_CODTEC
and PA2_DTINI = PAA_DATA
and PA9_CODAR = PAA_CODAR
Order By HRINIAT
EndSql

  
			DbSelectArea("AGT")
			DbGoTop()

		Do While _XHRFIM <= _TMPFIM
			If Empty(AGT->PAA_CODAR)
				_XINIAT:= 23
				_XFIMAT:= 23
			Else
				_XINIAT:=AGT->HRINIAT
				_XFIMAT:=AGT->HRFIMAT
			End If
			
			
			
			If _XHRFIM <= _XINIAT .and. _XHRFIM <= _XFIMAT .and. _XHRINI <= _XINIAT .and. _XHRINI <= _XFIMAT
				
				//If		_XHRFIM < _TMPINIAL .and. _XHRFIM < _TMPINIAL .and. _XHRINI < _TMPFIMAL .and. _XHRINI < _TMPFIMAL
				If		_XHRFIM <= _TMPINIAL .and. _XHRFIM <= _TMPFIMAL  .and. _XHRINI <=  _TMPINIAL .and. _XHRINI <= _TMPFIMAL					
					_nPos:= 0
			//		_nPos := Ascan(_XDIA, { |x| x[1] == Substr(_XDATA,7,2) .and. AllTrim(x[2]) == AllTrim((StrZero(Int(_TMPATE),2)+":"+AllTrim(StrZero(((_TMPATE-Int(_TMPATE))*60),2))))})
					_nPos := Ascan(_XDIA, {	|x| x[1] == Substr(_XDATA,7,2) .and. AllTrim(x[2]) == Iif(((_TMPATE-Int(_TMPATE))*60)>= 59,AllTrim(StrZero((Int(_TMPATE)+1),2)),AllTrim(StrZero(Int(_TMPATE),2)))+":"+AllTrim(StrZero(Iif(((_TMPATE-Int(_TMPATE))*60)>= 59,00,((_TMPATE-Int(_TMPATE))*60)),2))})
								
					If _nPos == 0
						
						AaDd(_XDIA,{Substr(_XDATA,7,2), Iif(((_TMPATE-Int(_TMPATE))*60)>= 59,AllTrim(StrZero((Int(_TMPATE)+1),2)),AllTrim(StrZero(Int(_TMPATE),2)))+":"+AllTrim(StrZero(Iif(((_TMPATE-Int(_TMPATE))*60)>= 59, 00,((_TMPATE-Int(_TMPATE))*60)),2))})
					//AllTrim((StrZero(Int(_TMPATE),2)+":"+AllTrim(StrZero(((_TMPATE-Int(_TMPATE))*60),2))))})
//					_nPos := Ascan(_XDIA, { |x| x[1] == Substr(_XDATA,7,2) .and. AllTrim(x[2]) == Iif(((_TMPATE-Int(_TMPATE))*60)== 60,AllTrim((StrZero((Int(_TMPATE)+1),2),AllTrim((StrZero(Int(_TMPATE),2))":"+AllTrim(StrZero(Iif(((_TMPATE-Int(_TMPATE))*60)== 60,00,((_TMPATE-Int(_TMPATE))*60)),2))))})

					End If
					_TMPATE :=_TMPATE + BRT->TMPATE
					_XHRINI := _TMPATE
					_XHRFIM := _TMPATE + BRT->TMPATE
  
					Loop
				Else
					If _TMPATE <=  _TMPFIMAL
						_TMPATE 	:=_TMPFIMAL
				 End If
				//	_TMPATE 	:=_TMPFIMAL
					_TMPINIAL	:= 23
					_TMPFIMAL	:= 23
					
				End If
			Else
				DbSelectArea("AGT")
				DbSkip()
				_TMPATE := 	_XFIMAT
			_XHRINI := _TMPATE
			_XHRFIM := _TMPATE + BRT->TMPATE

				Loop

			End If
			_XHRINI := _TMPATE
			_XHRFIM := _TMPATE + BRT->TMPATE

		End Do
		End If
		DbSelectArea("BRT")
		DbSkip()
	End Do
	
	_XDIA := Asort(_XDIA,,, { |x,y| x[1]+x[2]  < y[1]+y[2] } )
End If
If Select("BRT") > 0
	DbSelectArea("BRT")
	DbCloseArea("BRT")
End If
//DbCloseAll()
Return(_XDIA)
