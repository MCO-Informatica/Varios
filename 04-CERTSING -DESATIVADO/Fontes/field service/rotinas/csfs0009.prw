#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CSFS0009  ºAutor  ³ Rodrigo Seiti      º Data ³  25/06/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Cadastro de AR															  º±±
±±º          ³     												          			  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico da Certisign			                          	  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CSFS0009()

Local aRotina := {	{"Inc. Periodo","U_CS09IPER", 0 , 3},;
{"Del. Periodo","U_CS09DPER", 0 , 4}} //"Automatico"

AxCadastro("PAA","Calendario de Alocação AR X Tecnico","U_CS09DEL()","U_CS09TOK()",aRotina)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CS09IPER  ºAutor  ³ Rodrigo Seiti      º Data ³  25/06/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina de inclusao de periodos no cadastro de amarração    º±±
±±º          ³ Tecnico X AR										          		  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico da Certisign			                          	  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CS09IPER()
Static  cPergi    := "CS09IP"


PutSx1(cPergi,"01","Data De?				","","","mv_ch1","D",08,00,00,"G","","   ","","","mv_par01","","","","","","","","","","","","","","","","",{'Data inicial do periodo'})
PutSx1(cPergi,"02","Data Ate?			","","","mv_ch2","D",08,00,00,"G","","   ","","","mv_par02","","","","","","","","","","","","","","","","",{'Data Final do periodo'})
PutSx1(cPergi,"03","Codigo da AR?		","","","mv_ch3","C",06,00,00,"G","","PA9","","","mv_par03","","","","","","","","","","","","","","","","",{'Codigo da AR'})
PutSx1(cPergi,"04","Codigo do Tecnico? 	","","","mv_ch4","C",06,00,00,"G","","AA1","","","mv_par04","","","","","","","","","","","","","","","","",{'Codigo do tecnico'})
PutSx1(cPergi,"05","Hora inicio?			","","","mv_ch5","C",05,00,00,"G","","   ","","","mv_par05","","","","","","","","","","","","","","","","",{'Hora de incio dos trabalhos do tecnico na AR'})
PutSx1(cPergi,"06","Hora fim?			","","","mv_ch6","C",05,00,00,"G","","   ","","","mv_par06","","","","","","","","","","","","","","","","",{'Hora de termino dos trabalhos do tecnico na AR'})
PutSx1(cPergi,"07","Hora Almoço?			","","","mv_ch7","C",05,00,00,"G","","   ","","","mv_par07","","","","","","","","","","","","","","","","",{'Hora de saida para almoço'})
PutSx1(cPergi,"08","Hora Retorno?		","","","mv_ch8","C",05,00,00,"G","","   ","","","mv_par08","","","","","","","","","","","","","","","","",{'Hora de retorno do almoço'})
PutSx1(cPergi,"09","Tipo de Atendimento?	","","","mv_ch9","C",01,00,00,"C","","   ","","","mv_par09","Interno","","","","Externo","","","","","","","","","","","",{'Tipo do atendimento realizado pelo tecnico'})
Pergunte(cPergi,.T.)


Processa({||RunProci()},"Aguarde...","Gravando Amarração...")

Return



//DataValida(M->E1_VENCTO,.T.)
Static Function RunProci()

Private _xData := MV_PAR01
Private lReturn := .T.
Private RetDia:= " "
Private _cSemana := U_DtFunc(MV_PAR03)
Private _cFeriado:= "01/01*21/04*01/05*/07/09*12/10*02/11*15/11*25/12"


If U_CS09TOK(MV_PAR04,1)
	
	Do While MV_PAR02 >= _xData
		
		If Str(Dow(_xData),1) $ _cSemana .and. !(SubString(DToC(_xData),1,5) $ _cFeriado)
			
			If MV_PAR02 >= _xData
				
				If U_ValidDt(MV_PAR04,_XData,MV_PAR05, MV_PAR06)
					RecLock("PAA",.T.)
					PAA->PAA_FILIAL	:= xFilial("PAA")
					PAA->PAA_CODAR	:= MV_PAR03
					PAA->PAA_CODTEC	:= MV_PAR04
					PAA->PAA_HRINI	:= MV_PAR05
					PAA->PAA_HRFIM	:= MV_PAR06
					PAA->PAA_HRALIN	:= MV_PAR07
					PAA->PAA_HRALFI	:= MV_PAR08
					PAA->PAA_TIPO	:= Iif(MV_PAR09 == 1, "I","E")
					PAA->PAA_DATA	:= _xData
					MsUnlock()
				Else
					
					lReturn := .F.
					RetDia:= RetDia + " - " + DToC(_xData)
					
					
				End If
			End If
		End If
		_xData := _xData + 1
		
	End Do
	
	If lReturn
		Alert("Processo concluido com sucesso")
	Else
		Alert("Os dias abaixo não foram incluidos pois existe uma amarração ja cadastrada:"+RetDia)
	End If
Else
	Alert("Tecnico indisponivel, informar outro tecnico")
End If

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CS09DPER  ºAutor  ³ Rodrigo Seiti      º Data ³  25/06/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina de exclusao de periodos no cadastro de amarração    º±±
±±º          ³ Tecnico X AR										          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico da Certisign			                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CS09DPER()

Static  cPergd    := "CS09DP"


PutSx1(cPergd,"01","Data De?				","","","mv_ch1","D",08,00,00,"G","","   ","","","mv_par01","","","","","","","","","","","","","","","","",{'Data inicial do periodo'})
PutSx1(cPergd,"02","Data Ate?			","","","mv_ch2","D",08,00,00,"G","","   ","","","mv_par02","","","","","","","","","","","","","","","","",{'Data Final do periodo'})
PutSx1(cPergd,"03","Codigo da AR?		","","","mv_ch3","C",06,00,00,"G","","PA9","","","mv_par03","","","","","","","","","","","","","","","","",{'Codigo da AR'})
PutSx1(cPergd,"04","Codigo do Tecnico? 	","","","mv_ch4","C",06,00,00,"G","","AA1","","","mv_par04","","","","","","","","","","","","","","","","",{'Codigo do tecnico'})
Pergunte(cPergd,.T.)


Processa({||RunProcd()},"Aguarde...","Excluindo Amarração...")

Return


Static Function RunProcd()

Private _lData := MV_PAR01

_lData := MV_PAR01
Do While MV_PAR02 >= _lData
	
	DbSelectArea("PAA")
	DbSetOrder(3)
	DbSeek(xFilial("PAA")+MV_PAR03+MV_PAR04+DToS(_lData))
	If Found()
		If U_CS09DEL(PAA->PAA_CODTEC,DToS(PAA->PAA_DATA),1)
			RecLock("PAA",.F.)
			DbDelete()
			MsUnlock()
		End If
	End If
	_lData := _lData + 1
	
End Do
Alert("Processo concluido com sucesso")
Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CS09Del   ºAutor  ³ Rodrigo Seiti      º Data ³  25/06/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina que valida a exclusao de amarraçao                  º±±
±±º          ³ Tecnico X AR										          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico da Certisign			                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CS09DEL(_TEC,_XDAT,_XOPC)
Local aArea    := GetArea()
Local lRetorno := .T.

If Select("TRB") > 0
	DbSelectArea("TRB")
	DbCloseArea("TRB")
End If


BeginSql Alias "TRB"
%noparser%
Select Top 1 * From %TABLE:PA2% PA2 Where PA2_CODTEC = %Exp:Iif(_XOPC == 1,_TEC,PAA->PAA_CODTEC)% AND PA2_DTINI = %Exp:Iif(_XOPC == 1,_XDAT,PAA->PAA_DATA)%
AND PA2.%NotDel%
EndSql

If !Empty(TRB->PA2_CODTEC)
	lRetorno := .F.
	If _XOPC <> 1
		Alert("Este dia não pode ser excluido, existe um agendamento para este dia")
	End If
End If


RestArea(aArea)
Return(lRetorno)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CS09Del   ºAutor  ³ Rodrigo Seiti      º Data ³  25/06/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina que valida a exclusao de amarraçao                  º±±
±±º          ³ Tecnico X AR										          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico da Certisign			                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CS09TOK(_TEC,_XOPC)
Local aArea    := GetArea()
Local lRetorno := .T.

DbSelectArea("AA1")
DbSetOrder(1)
DbGoTop()
DbSeek(xFilial("AA1")+Iif(_XOPC == 1, MV_PAR04, PAA->PAA_CODTEC))
If AA1->AA1_ALOCA == "2"
	
	lRetorno := .F.
	If _XOPC <> 1
		Alert("Tecnico indisponivel, informar outro tecnico")
	End If
	
End If

If INCLUI .and. lRetorno .and. _XOPC <> 1
	_cCodTec	:= PAA_CODTEC
	_cINICIO	:= Val(Substring(PAA_HRINI,1,2))+(Val(Substring(PAA_HRINI,4,2))/60)
	_cFIM		:= Val(Substring(PAA_HRFIM,1,2))+(Val(Substring(PAA_HRFIM,4,2))/60)
	_dData		:= PAA_DATA
	_nAtu			:= 0
	_nINIDI		:= 0
	_nFIMDI	:= (23)+(59/60)
	
	If Select("TRB") > 0
		DbSelectArea("TRB")
		DbCloseArea("TRB")
	End If

BeginSql Alias "TRB"
%noparser%
Select ((Cast(Substring(PAA_HRINI,1,2)   As Numeric))+((Cast(Substring(PAA_HRINI,4,2)  As Numeric))/60)) As HRINIAR,
((Cast(Substring(PAA_HRFIM,1,2)   As Numeric))+((Cast(Substring(PAA_HRFIM,4,2)  As Numeric))/60)) As HRFIMAR,* From %TABLE:PAA% PAA Where PAA_CODTEC = %Exp:_cCodTec% AND PAA_DATA = %Exp:DToS(_dData)%
AND PAA.%NotDel%
EndSql

	If !Empty(TRB->PAA_CODTEC)
		lRetorno := .F.
		DbSelectArea("TRB")
		DbGoTop()
		_nAtu			:= TRB->HRINIAR
		_nINIDI		:= 0
		_lFlag			:= .T.
		
		Do While _nFIMDI > _nAtu

			If 	_nAtu	 ==  (23)+(40/60)
				_nAtu	 :=  25
				_lFlag := .F.
			End If
			
			If _nINIDI < _cINICIO .and. _nINIDI < _cFIM .and. _nAtu < _cINICIO .and. _nAtu < _cFIM
				
				lRetorno := .T.
				
			End If
			If !Eof() .AND. _lFlag

				_nINIDI		:= TRB->HRFIMAR
				
				DbSelectArea("TRB")
				DbSkip()
				
				_nAtu			:= TRB->HRINIAR
			
			ElseIf _lFlag
				_nINIDI		:= TRB->HRFIMAR
				_nAtu			:= (23)+(40/60)
				
			End If
			
		End Do
		
	End If
	If !lRetorno
		Alert("O dia informado não pode ser incluidos pois existe uma amarração ja cadastrada")
	End If
End If

If ALTERA .and. lRetorno 
	_cCodTec	:= PAA_CODTEC
	_cINICIO	:= Val(Substring(PAA_HRINI,1,2))+(Val(Substring(PAA_HRINI,4,2))/60)
	_cFIM		:= Val(Substring(PAA_HRFIM,1,2))+(Val(Substring(PAA_HRFIM,4,2))/60)
	_dData		:= PAA_DATA
	_cALMOCO	:= Val(Substring(PAA_HRALIN,1,2))+(Val(Substring(PAA_HRALIN,4,2))/60)
	_cRETORNO	:= Val(Substring(PAA_HRALFI,1,2))+(Val(Substring(PAA_HRALFI,4,2))/60)
	
	If Select("TRB") > 0
		DbSelectArea("TRB")
		DbCloseArea("TRB")
	End If

BeginSql Alias "TRB"
%noparser%
Select ((Cast(Substring(PA2_HRINI,1,2)   As Numeric))+((Cast(Substring(PA2_HRINI,4,2)  As Numeric))/60)) As HRINIAT,
((Cast(Substring(PA2_HRFIM,1,2)   As Numeric))+((Cast(Substring(PA2_HRFIM,4,2)  As Numeric))/60)) As HRFIMAT, * 
From %TABLE:PA2% PA2 Where PA2_CODTEC = %Exp:_cCodTec% and PA2_DTINI = %Exp:DToS(_dData)%
AND PA2.%NotDel%
EndSql

	If !Empty(TRB->PA2_CODTEC)
		lRetorno := .T.
		DbSelectArea("TRB")
		DbGoTop()
		Do While !Eof("TRB")
		//Valida Horario de inicio
		If lRetorno .and. (_cINICIO <= TRB->HRINIAT .or. _cINICIO <= TRB->HRFIMAT)
			lRetorno := .F.
		End IF

		//Valida Horario de Final
		If lRetorno .and. (_cFIM >= TRB->HRINIAT .or. _cFIM >= TRB->HRFIMAT)
			lRetorno := .F.
		End IF
		
		//Valida Horario de Almoco
		If lRetorno .and. (_cALMOCO <= TRB->HRINIAT .or. _cALMOCO <= TRB->HRFIMAT)
			lRetorno := .F.
		End IF

		//Valida Horario de Final
		If lRetorno .and. (_cRETORNO >= TRB->HRINIAT .or. _cRETORNO >= TRB->HRFIMAT)
			lRetorno := .F.
		End IF

		DbSelectArea("TRB")
		DbSkip()
		End Do
	End If
	If !lRetorno
		Alert("O horario não pode ser alterado, pois existe agendamento para este horario")
	End If

End If
RestArea(aArea)
Return(lRetorno)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CS09Del   ºAutor  ³ Rodrigo Seiti      º Data ³  25/06/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina que valida a exclusao de amarraçao                  º±±
±±º          ³ Tecnico X AR										          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico da Certisign			                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function DtFunc(_cAR)
Local aArea    := GetArea()
Local cRetorno := " "


If Select("TRB") > 0
	DbSelectArea("TRB")
	DbCloseArea("TRB")
End If


BeginSql Alias "TRB"
%noparser%
Select PA9_CODAR, PA9_DOMING, PA9_SEGUND, PA9_TERCA, PA9_QUARTA, PA9_QUINTA, PA9_SEXTA, PA9_SABADO From %TABLE:PA9% PA9
Where PA9_CODAR = %Exp:_cAR% and PA9.%NotDel%
EndSql

If !Empty(TRB->PA9_CODAR)
	If TRB->PA9_DOMING == 'S'
		cRetorno := cRetorno + "*1"
	End If
	If TRB->PA9_SEGUND == 'S'
		cRetorno := cRetorno + "*2"
	End If
	If TRB->PA9_TERCA == 'S'
		cRetorno := cRetorno + "*3"
	End If
	If TRB->PA9_QUARTA == 'S'
		cRetorno := cRetorno + "*4"
	End If
	If TRB->PA9_QUINTA == 'S'
		cRetorno := cRetorno + "*5"
	End If
	If TRB->PA9_SEXTA == 'S'
		cRetorno := cRetorno + "*6"
	End If
	If TRB->PA9_SABADO == 'S'
		cRetorno := cRetorno + "*7"
	End If
End If

RestArea(aArea)
Return(cRetorno)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CS09Del   ºAutor  ³ Rodrigo Seiti      º Data ³  25/06/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina que valida a exclusao de amarraçao                  º±±
±±º          ³ Tecnico X AR										          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico da Certisign			                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ValidDt(_XCodTe,_pData,_XHRINI, _XHRFIM)
Local aArea    := GetArea()
Local lRetorno := .T.

_cCodTec	:= _XCodTe
_cINICIO	:= Val(Substring(_XHRINI,1,2))+(Val(Substring(_XHRINI,4,2))/60)
_cFIM		:= Val(Substring(_XHRFIM,1,2))+(Val(Substring(_XHRFIM,4,2))/60)
_dData		:= _pData
_nAtu			:= 0
_nINIDI		:= 0
_nFIMDI	:= (23)+(59/60)

If Select("TRB") > 0
	DbSelectArea("TRB")
	DbCloseArea("TRB")
End If

BeginSql Alias "TRB"
%noparser%
Select ((Cast(Substring(PAA_HRINI,1,2)   As Numeric))+((Cast(Substring(PAA_HRINI,4,2)  As Numeric))/60)) As HRINIAR,
((Cast(Substring(PAA_HRFIM,1,2)   As Numeric))+((Cast(Substring(PAA_HRFIM,4,2)  As Numeric))/60)) As HRFIMAR,* From %TABLE:PAA% PAA Where PAA_CODTEC = %Exp:_cCodTec% AND PAA_DATA = %Exp:DToS(_dData)%
AND PAA.%NotDel%
EndSql

If !Empty(TRB->PAA_CODTEC)
	lRetorno := .F.
	DbSelectArea("TRB")
	DbGoTop()
	_nAtu			:= TRB->HRINIAR
	_nINIDI		:= 0
	_lFlag			:= .T.
	
	Do While _nFIMDI > _nAtu

		If 	_nAtu	 ==  (23)+(40/60)
			_nAtu	 :=  25
			_lFlag := .F.
		End If
		
		If _nINIDI < _cINICIO .and. _nINIDI < _cFIM .and. _nAtu < _cINICIO .and. _nAtu < _cFIM
			
			lRetorno := .T.
			
		End If
		If !Eof() .AND. _lFlag

			_nINIDI		:= TRB->HRFIMAR
			
			DbSelectArea("TRB")
			DbSkip()
			
			_nAtu			:= TRB->HRINIAR
			
		ElseIf _lFlag
			_nINIDI		:= TRB->HRFIMAR
			_nAtu			:= (23)+(40/60)
			
		End If
		
	End Do
	
End If
If !lRetorno
	Alert("O dia informado não pode ser incluidos pois existe uma amarração ja cadastrada")
End If
RestArea(aArea)
Return(lRetorno)
