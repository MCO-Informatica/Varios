#Include "Protheus.ch"
#Include "rwmake.ch"

User Function LS_GetEmpr(_cFilial)
Local _cCodigo := '  '

If _cFilial >= '01' .AND. _cFilial <= '99'
                _cCodigo := '000001'
ElseIf _cFilial >= 'A0' .AND. _cFilial <= 'AZ' .or. _cFilial == 'BH' 
                _cCodigo := '000004'
ElseIf (_cFilial >= 'C0' .AND. _cFilial <= 'EZ') .or. _cFilial == 'GH'
                _cCodigo := '000003'
ElseIf _cFilial >= 'G0' .AND. _cFilial <= 'GZ'
                _cCodigo := '000002'
ElseIf _cFilial >= 'R0' .AND. _cFilial <= 'RZ'
                _cCodigo := '000005'
ElseIf _cFilial >= 'T0' .AND. _cFilial <= 'TZ'
                _cCodigo := '000006'
ElseIf _cFilial >= 'V0' .AND. _cFilial <= 'VZ'
                _cCodigo := '000008'

Else
                MsgBox('Filial não pertence a nenhuma empresa','ATENÇÃO!!!','ALERT')           
EndIf                                           

Return(_cCodigo)

