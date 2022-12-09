#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
//---------------------------------------------------------------------
// Rotina | F050MDVC  | Autor | Rafael Beghini      | Data | 04.08.2016
//---------------------------------------------------------------------
// Descr. | PE - Cálculo da data de vencimento de impostos
//---------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------
User Function F050MDVC
	Local dDtVenc  := ParamIXB[1] // Pega o Vencimento Atual do Imposto
	Local cImposto := ParamIXB[2]
	Local dVencRea := ParamIXB[5]
	
	If ( AllTrim(Upper(cImposto)) == 'IRRF' .And. SA2->A2_XDIAIR == "1" )
		
		dDtVenc := MsSomaMes(dVencRea,1,.T.)
		dDtVenc := CtoD('20/'+StrZero(Month(dDtVenc),2)+'/'+Str(Year(dDtVenc),4))
		
		// Tratamento da Data para Não Cair aos Sabados, Domingos e Feriados
		// Antecipando o Vencimento
		If Dow(dDtVenc) = 1
			dDtVenc := dDtVenc-2
			dDtVenc := DataValida(dDtVenc)
		ElseIf Dow(dDtVenc) == 7
			dDtVenc := dDtVenc-1
			dDtVenc := DataValida(dDtVenc)
		Endif
	Endif
Return dDtVenc