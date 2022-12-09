#INCLUDE 'APWEBSRV.CH'
#INCLUDE 'PROTHEUS.CH'
#include "TBICONN.CH"
#include "RWMAKE.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CSWS0001  �Autor  �Rodrigo Seiti Mitani� Data �  07/02/07   ���
�������������������������������������������������������������������������͹��
���Desc.     � WebService para consulta a agenda dos tecnicos             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico da CertiSign                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

WSSTRUCT WSDISPO
	WSDATA CODAGEN	AS String
	WSDATA NOMEAGEN	AS String
ENDWSSTRUCT


WSSERVICE CSWS0001 DESCRIPTION "Servico de consulta de agenda de tecnicos disponiveis"
	WSDATA DTA		AS String
	WSDATA Horario	AS String
	WSDATA AR		AS String
	WSDATA aDISPO	AS ARRAY OF WSDISPO
	WSMETHOD AGENDA 
END WSSERVICE
         
WSMETHOD AGENDA WSRECEIVE DTA, Horario, AR WSSEND aDISPO WSSERVICE CSWS0001
Local aRet, i

aRet := U_CSW01AGE(::DTA, ::Horario, ::AR)
If Len(aRet) > 0
	::aDISPO := Array(Len(aRet))
	For i := 1 To Len(aRet)
		::aDISPO[i]             := WSClassNew("WSDISPO")	
		::aDISPO[i]:CODAGEN     := aRet[i,01]
		::aDISPO[i]:NOMEAGEN    := aRet[i,02]
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
���Programa  �CSW01AGE  �Autor  �Rodrigo Seiti Mitani� Data �  07/02/07   ���
�������������������������������������������������������������������������͹��
���Desc.     � Consulta agenda do tecnicoem ADVPL                         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function CSW01AGE(_PRDT, _PRHR, _AR)
Local _TEC:= {}
                                         
/*
If Select("BRT") > 0
	DbSelectArea("BRT")
	DbCloseArea("BRT")
End If
                           
_HRSEL := Val(Substring(_PRHR,1,2))+(Val(Substring(_PRHR,4,2))/60)


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
and PAA_DATA = %Exp:AllTrim(_PRDT)%
and PAA_CODAR = %Exp:AllTrim(_AR)%
and PA9_CODAR = PAA_CODAR
Order By PAA_CODTEC, PAA_DATA,  HRINIAT
EndSql


DbSelectArea("BRT")

DbGoTop()

If !Empty(BRT->PAA_CODAR)
	
	Do While !Eof("BRT")
		_TMPATE 	:= BRT->HRINIAR
		_TMPFIM 	:= BRT->HRFIMAR
		_TMPINIAL	:= BRT->HRINIAL
		_TMPFIMAL	:= BRT->HRFIMAL
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
			
			
			
			If _XHRFIM < _XINIAT .and. _XHRFIM < _XFIMAT .and. _XHRINI < _XINIAT .and. _XHRINI < _XFIMAT
				
				//If		_XHRFIM < _TMPINIAL .and. _XHRFIM < _TMPINIAL .and. _XHRINI < _TMPFIMAL .and. _XHRINI < _TMPFIMAL
				If		_XHRFIM < _TMPINIAL .and. _XHRFIM < _TMPFIMAL  .and. _XHRINI <  _TMPINIAL .and. _XHRINI < _TMPFIMAL					
					If _TMPATE  == _HRSEL

							AaDd(_TEC,{BRT->PAA_CODTEC,GetAdvFVal("AA1","AA1_NOMTEC",xFilial("AA1")+BRT->PAA_CODTEC,1,"" )})

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
	
	//_XDIA := Asort(_XDIA,,, { |x,y| x[1]+x[2]  < y[1]+y[2] } )
End If
If Select("BRT") > 0
	DbSelectArea("BRT")
	DbCloseArea("BRT")
End If
//DbCloseAll()
Return(_TEC)
//Return(_XDIA)

//_DTSTR := DToS(_PRDT)

//	PREPARE ENVIRONMENT EMPRESA '01' FILIAL '01';
//	TABLES "PA2","PAA"
*/


If Select("BRT") > 0
	DbSelectArea("BRT")
	DbCloseArea("BRT")
End If


BeginSql Alias "BRT"
%noparser%
Select AA1_CODTEC,AA1_NOMTEC From %Table:AA1% AA1 Where AA1.%NotDel% and AA1_CODTEC
Not In(Select PA2_CODTEC From %Table:PA2% PA2 Where PA2.%NotDel% and
(%Exp:AllTrim(_PRDT)% <= PA2_DTFIM And %Exp:AllTrim(_PRHR)||'1'% <= PA2_HRFIM And %Exp:AllTrim(_PRDT)%
 >= PA2_DTINI And %Exp:AllTrim(_PRHR)+'1'% >= PA2_HRINI ))
 and AA1_CODTEC||%Exp:AllTrim(_PRDT)% In (Select PAA_CODTEC||PAA_DATA From %Table:PAA% PAA Where PAA.%NotDel% and PAA_CODAR = %Exp:AllTrim(_AR)%)

EndSql

If !Empty(BRT->AA1_NOMTEC)
	
	DbSelectArea("BRT")
	DbGoTop()
	Do While !Eof()
		AaDd(_TEC,{BRT->AA1_CODTEC,BRT->AA1_NOMTEC})
	DbSkip()
	End Do	
Else
//AaDd(_TEC,{"",""})
End If
If Select("BRT") > 0
	DbSelectArea("BRT")
	DbCloseArea("BRT")
End If

//DbCloseAll()

Return(_TEC)

