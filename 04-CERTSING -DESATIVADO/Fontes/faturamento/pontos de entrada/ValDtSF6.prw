#Include 'Protheus.ch'      

//+----------------------------------------------------------------+
//| Rotina | ValDtSF6 | Autor | Rafael Beghini | Data | 06/03/2015 |
//+----------------------------------------------------------------+
//| Descr. | Gatilho do Campo Arrecadação x Vencimento             |
//|        | Soma 03 dias para vencimento.  	                   |
//+----------------------------------------------------------------+
//| Uso    | Financeiro / Fiscal [CertiSign]                       |
//+----------------------------------------------------------------+
User Function ValDtSF6()
      
	Local dData := M->F6_DTARREC
	Local dNew  := ''
	Local nDias := 3
	
	For nCont:=1 to nDias
		dData += 1
		If dow(dData)== 1 //domingo
			dData += 1
		ElseIf dow(dData)== 7 //sabado
			dData += 2
		EndIf
	Next
	
	dNew := DataValida( dData, .T.)

		
Return dNew