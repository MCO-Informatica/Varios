#INCLUDE "Protheus.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "TopConn.ch"

//+--------------------------------------------------------------+
//| Rotina | ImpNfe | Autor | Rafael Beghini | Data | 15/04/2015 |
//+--------------------------------------------------------------+
//| Descr. | Cria link para consulta de NFSe e grava no RPS      |
//|        |                                                     |
//+--------------------------------------------------------------+
//| Uso    | CertiSign - Faturamento/Fiscal                      |
//+--------------------------------------------------------------+
User Function ImpNfe(cNota, cSerie)

	Local cNota   := cNota
	Local cSerie  := cSerie
	Local cSql    := ''
	Local Alias   := ''
	Local cUrl    := ''
	
	cSql := " SELECT R_E_C_N_O_ AS RECNUM "
	cSql += " FROM "+RetSqlName("SF2")+" WHERE F2_FILIAL = '"+xFilial("SF2")+"' "
	cSql += " AND F2_DOC = '"+Alltrim(cNota)+"' AND F2_SERIE = '"+Alltrim(cSerie)+"' " 
	cSql += " AND D_E_L_E_T_ = ' ' "    
	
	TcQuery cSql Alias "QF2" New
	                               
	If QF2->(!EoF())
		SF2->(DbGoTo(QF2->RECNUM))
		If !( Empty(SF2->F2_NFELETR) .Or. Empty(SF2->F2_CODNFE) )
			cUrl := "https://nfe.prefeitura.sp.gov.br/contribuinte/notaprint.aspx?inscricao=36414891&nf="+Alltrim(SF2->F2_NFELETR)+;
					"&verificacao="+Alltrim(SF2->F2_CODNFE)
		EndIf
		
		QF2->(DbCloseArea())
	EndIf
	
Return(cUrl)