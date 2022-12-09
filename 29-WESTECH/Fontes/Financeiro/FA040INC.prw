#include 'protheus.ch'
#include 'parmtype.ch'

user function FA040INC()
	Local cItemICM 	:= M->E1_XXIC
	Local nTotal	:= M->E1_VLCRUZ
	Local nTotalPR	:= 0
	Local nTotalNF	:= 0
	Local nTotalOU	:= 0
	Local nTotalFP	:= 0
	Local nTotalFP2	:= 0
	Local nTotalEP	:= 0
	Local nTipo		:= Alltrim(M->E1_TIPO)
	Local nTotACPR
	Local nTotCUPR
	Local nVendidoCI := POSICIONE("CTD",1,XFILIAL("CTD")+cItemICM,"CTD_XVDCIR")
	Local nVendidoSI := POSICIONE("CTD",1,XFILIAL("CTD")+cItemICM,"CTD_XVDSIR")

	Local lRet := .T.

	if ! ALLTRIM(cItemICM) $ ("ADMINISTRACAO/PROPOSTA/QUALIDADE/ATIVO/ENGENHARIA/ZZZZZZZZZZZZZ/XXXXXX/ENGENHARIA/ESTOQUE/OPERACOES") 
		dbSelectArea("SE1")
		SE1->( dbSetOrder(29) )
		SE1->(dbgotop())
		
		While SE1->( ! EOF() )
			if  alltrim(SE1->E1_XXIC) == M->E1_XXIC .AND. alltrim(SE1->E1_TIPO) == "PR"   
				nTotalPR += SE1->E1_VLCRUZ
			endif
			
			if  alltrim(SE1->E1_XXIC) == M->E1_XXIC .AND. alltrim(SE1->E1_TIPO) == "NF"   
				nTotalNF += SE1->E1_VLCRUZ
			endif
				
			nTotalFP := nTotalPR + nTotalNF  + nTotal 
			nTotalFP2 := nVendidoCI - (nTotalPR + nTotalNF)
			if nTotalFP > nVendidoCI
				nTotalFP := 0
				nTotalEP := nTotalFP - nVendidoCI
				nTotalFP2 := 0
			endif
			SE1->(dbskip()) 
		EndDo
		
		msginfo ( ;
		"Informações do Contrato " + CRLF  ;
		+ CRLF  ;
		+ "Contrato No.: " + cItemICM + CRLF  ;
		+ CRLF  ;
		+ "Vendido c/ Tributos: " + cValToChar(Transform(nVendidoCI, "@E 999,999,999.99" )) + CRLF ;
		+ "Vendido s/ Tributos: " + cValToChar(Transform(nVendidoSI, "@E 999,999,999.99" )) + CRLF  ;
		+ CRLF  ;
		+ "NFs: " + cValToChar(Transform(nTotalNF, "@E 999,999,999.99" )) + CRLF  ;
		+ "Provisões: " + cValToChar(Transform(nTotalPR, "@E 999,999,999.99" )) + CRLF  ;
		+ CRLF ;
		+ "Total: " + cValToChar(Transform(nTotalFP, "@E 999,999,999.99" )) + CRLF  ;
		+ CRLF ;
		+ "Falta Provisionar: " + cValToChar(Transform(nTotalFP2, "@E 999,999,999.99" )) + CRLF  ;
		+ "Excedido Provisões: " + cValToChar(Transform(nTotalEP, "@E 999,999,999.99" )) )
		
	endif
	
return (lRet)