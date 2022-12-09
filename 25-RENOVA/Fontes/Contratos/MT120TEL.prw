#INCLUDE "PROTHEUS.CH"

User Function MT120TEL()

Local _aAreaSC7   := SC7->(GetArea())
Local _oDlg       := PARAMIXB[1]
Local _aPosGet    := PARAMIXB[2]
Local _aObj       := PARAMIXB[3]
Local _nOpcx      := PARAMIXB[4]
Local _nReg       := PARAMIXB[5]
Public _cObsPA    := Space(250)
If _nOpcx <> 3
	SC7->(dbGoTo(_nReg))
EndIf

Public _cObsPA    := IIf(_nOpcx == 3,CriaVar("C7_XOBSPA"),SC7->C7_XOBSPA)

@ 60,_aPosGet[2,5]-12 SAY "Obs p/ PA" of _oDlg PIXEL SIZE 500,006
 
@ 61,_aPosGet[2,6]-25 MsGet _cObsPA WHEN _nOpcx == 3 .Or. _nOpcx == 4 SIZE 100,006 OF _oDlg PIXEL
                                      
RestArea(_aAreaSC7)

Return