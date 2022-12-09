#include 'protheus.ch'
#include 'parmtype.ch'
#include "rwmake.ch"
#include "topconn.ch"
#Include 'Protheus.ch'
#include "ap5mail.ch"
#INCLUDE "TOTVS.CH"

user function FA050INC()
	
	Local cItemICM 	:= alltrim(M->E2_XXIC)
	Local nTotal	:= M->E2_VLCRUZ
	Local cNaturez	:= alltrim(M->E2_NATUREZ)
	Local nTotalPR	:= 0
	Local nTotalNF	:= 0
	Local nTotalOU	:= 0
	Local nTotalFP	:= 0
	Local nTotalFP2	:= 0
	Local nTotalEP	:= 0
	Local nTipo		:= Alltrim(M->E2_TIPO)
	Local nTotACPR
	Local nTotCUPR
	Local nCustoTotalPrd := POSICIONE("CTD",1,XFILIAL("CTD")+cItemICM,"CTD_XCUPRR")
	Local nCustoTotalCtr := POSICIONE("CTD",1,XFILIAL("CTD")+cItemICM,"CTD_XCUTOR")
	Local nVerbAdic := POSICIONE("CTD",1,XFILIAL("CTD")+cItemICM,"CTD_XVBAD")
	Local lRet := .T.
	Local cFornece := ""
	Local cFornece2 := Alltrim(M->E2_FORNECE)
	local nXIPI 	:= 0
	local nXII 		:= 0
	local nXCOFINS 	:= 0
	local nXPIS		:= 0
	local nXICMS	:= 0
	local nXSISCO 	:= 0 
	local nXARFMM 	:= 0
	
	//msginfo ( cItemICM ) 

	if ! cItemICM $ "ADMINISTRACAO/PROPOSTA/QUALIDADE/ATIVO/ENGENHARIA/ZZZZZZZZZZZZZ/XXXXXX/ENGENHARIA/ESTOQUE/OPERACOES" //;
		//.OR. ! cItemICM $ "ADMINISTRACAO/PROPOSTA/QUALIDADE/ATIVO/ENGENHARIA/ZZZZZZZZZZZZZ/XXXXXX/ENGENHARIA/ESTOQUE/OPERACOES" .AND. !ALLTRIM(cNaturez) $ "6.21.00/6.22.00";
		//.OR. !ALLTRIM(cNaturez) $ "6.21.00/6.22.00"
	
	
		dbSelectArea("SE2")
		SE2->( dbSetOrder(18) )
		SE2->(dbgotop())
		
		//msginfo ( cNaturez )
		
		While SE2->( ! EOF() )
			
			if ALLTRIM(cNaturez) $ "6.21.00/6.22.00"
				SE2->(dbskip()) 
				loop
			endif
		
			if  alltrim(SE2->E2_XXIC) == M->E2_XXIC .AND. alltrim(SE2->E2_TIPO) == "PR"   
				nTotalPR += SE2->E2_VLCRUZ
			endif
			
			if  alltrim(SE2->E2_XXIC) == M->E2_XXIC .AND. alltrim(SE2->E2_TIPO) == "NF"   
				nTotalNF += SE2->E2_VLCRUZ
			endif
			
			if  alltrim(SE2->E2_XXIC) == M->E2_XXIC .AND. ! alltrim(SE2->E2_TIPO) $ "NF/PR/PA"   
				nTotalOU += SE2->E2_VLCRUZ
			endif
			
			nTotalFP := nTotalPR + nTotalNF  + nTotalOU + nTotal + nVerbAdic
			nTotalFP2 := nCustoTotalCtr - (nTotalPR + nTotalNF  + nTotalOU)
			if nTotalFP > nCustoTotalCtr
				nTotalFP := 0
				nTotalEP := nTotalFP - nCustoTotalCtr
				nTotalFP2 := 0
			endif
			SE2->(dbskip()) 
		EndDo
		
		msginfo ( ;
		"Informações do Contrato " + CRLF  ;
		+ CRLF  ;
		+ "Contrato No.: " + cItemICM + CRLF  ;
		+ CRLF  ;
		+ "Custo de Produção: " + cValToChar(Transform(nCustoTotalPrd, "@E 999,999,999.99" )) + CRLF ;
		+ "Custo de Total: " + cValToChar(Transform(nCustoTotalCtr, "@E 999,999,999.99" )) + CRLF  ;
		+ "Verba Adicional: " + cValToChar(Transform(nVerbAdic, "@E 999,999,999.99" )) + CRLF  ;
		+ CRLF  ;
		+ "NFs: " + cValToChar(Transform(nTotalNF, "@E 999,999,999.99" )) + CRLF  ;
		+ "Outros Documentos: " + cValToChar(Transform(nTotalOU, "@E 999,999,999.99" )) + CRLF  ;
		+ "Provisões: " + cValToChar(Transform(nTotalPR, "@E 999,999,999.99" )) + CRLF  ;
		+ CRLF ;
		+ "Total: " + cValToChar(Transform(nTotalFP, "@E 999,999,999.99" )) + CRLF  ;
		+ CRLF ;
		+ "Falta Provisionar: " + cValToChar(Transform(nTotalFP2, "@E 999,999,999.99" )) + CRLF  ;
		+ "Excedido Provisões: " + cValToChar(Transform(nTotalEP, "@E 999,999,999.99" )) )
		
	endif
	
	
	IF ! ALLTRIM(cNaturez) $ "6.21.00/6.22.00"
		
	  if ! alltrim(cItemICM) $ "ADMINISTRACAO/PROPOSTA/QUALIDADE/ATIVO/ENGENHARIA/ZZZZZZZZZZZZZ/XXXXXX/ENGENHARIA/ESTOQUE/OPERACOES"
		//msginfo(cNaturez)
		IF alltrim(M->E2_RATEIO) <> "S" 
			dbSelectArea("CTD")
			CTD->( dbSetOrder(1) )
				
			if ! cItemICM $ "ADMINISTRACAO/PROPOSTA/QUALIDADE/ATIVO/ENGENHARIA/ZZZZZZZZZZZZZ/XXXXXX/ENGENHARIA/ESTOQUE/OPERACOES" ;
				.OR. ! cItemICM $ "ADMINISTRACAO/PROPOSTA/QUALIDADE/ATIVO/ENGENHARIA/ZZZZZZZZZZZZZ/XXXXXX/ENGENHARIA/ESTOQUE/OPERACOES" .AND. !ALLTRIM(cNaturez) $ "6.21.00/6.22.00";
				.OR. !ALLTRIM(cNaturez) $ "6.21.00/6.22.00" .OR. alltrim(M->E2_RATEIO) <> "S" 
				
				if M->E2_XCTIPI = "2"
					nXIPI 		:=  M->E2_XIPI 
				else
					nXIPI 		:=  0
				endif
				
				if M->E2_XCTII = "2"
					nXII 		:= M->E2_XII 
				else
					nXII 		:=  0
				endif
				
				if M->E2_XCTCOF = "2"
					nXCOFINS 	:=  M->E2_XCOFINS 
				else
					nXCOFINS 	:=  0
				endif
					
				if M->E2_XCTPIS = "2"
					nXPIS 		:=  M->E2_XPIS
				else
					nXPIS 		:= 0
				endif
				
				if M->E2_XCTICMS = "2"
					nXICMS 		:=  M->E2_XICMS
				else
					nXICMS 		:= 0
				endif
				
				if M->E2_XCTSISC = "2"
					nXSISCO 	:=  M->E2_XSISCO
				else
					nXSISCO 	:= 0
				endif
					
				/*	
				nXIPI 		:= iif(SE2->E2_XCTIPI = "2", M->E2_XIPI , 0 )
				nXII 		:= iif(SE2->E2_XCTII = "2", M->E2_XII , 0 )
				nXCOFINS 	:= iif(SE2->E2_XCTCOF = "2", M->E2_XCOFINS , 0 )
				nXPIS 		:= iif(SE2->E2_XCTPIS = "2", M->E2_XPIS , 0 )
				nXICMS 		:= iif(SE2->E2_XCTICMS = "2", M->E2_XICMS , 0 )
				nXSISCO 	:= iif(SE2->E2_XCTSISC = "2", M->E2_XSISCO , 0 )*/
				//nXARFMM 	:= iif(SE2->E2_XCTARFM = "2", SE2->E2_XARFMM , 0 )
			
				if ! nTipo $ "NF/TX/PR/PA/ISS/INS/INV"
					if CTD->( dbSeek( xFilial("CTD")+cItemICM)  )
						
						nTotal	:= M->E2_VLCRUZ	
						nTotACPR := (CTD->CTD_XACPR + nTotal) - (nXIPI + nXII + nXCOFINS + nXPIS + nXICMS + nXSISCO  ) 
						nTotCUPR := CTD->CTD_XCUPRR + nVerbAdic
								 
						if nTotACPR > nTotCUPR .AND. !ALLTRIM(cNaturez) $ "6.21.00/6.22.00" 
							alert("Título supera verba do Contrato. Solicite verba adicional a Diretoria. " + CRLF + ;
									CRLF + "Título não pode ser salva. "; 
									+ CRLF + ;
									cItemICM + CRLF + CRLF +;
									"Verba s/ Tributos " + cValToChar(Transform(nTotCUPR,"@E 999,999,999.99")) + CRLF +;
									"Verba adicional s/ Tributos " + cValToChar(Transform(CTD->CTD_XVBAD,"@E 999,999,999.99")) + CRLF +;
									"Custo Atual s/ Tributos: " + cValToChar(Transform(CTD->CTD_XACPR,"@E 999,999,999.99")) + CRLF +;
									"Valor Título: " + cValToChar(Transform(nTotal - (nXIPI + nXII + nXCOFINS + nXPIS + nXICMS + nXSISCO  ),"@E 999,999,999.99"));
									)
							
							lRet := .F.
						else
							lRet := .T.
								 	
						endif
								
					endif
				endif
			endif
		ENDIF
	  ENDIF
	ENDIF
	
	
	if alltrim(M->E2_RATEIO) <> "S" 
		
		if ! alltrim(M->E2_TIPO) $ "PA/NF/TX/PIS/ISS/IRF/INS/INP/CSS/DDI/CSL/COF/RDV" .AND.  ;
			! cItemICM $ "ADMINISTRACAO/PROPOSTA/QUALIDADE/ATIVO/ENGENHARIA/ZZZZZZZZZZZZZ/XXXXXX/ENGENHARIA/ESTOQUE/OPERACOES" ;
			.OR. ! cItemICM $ "ADMINISTRACAO/PROPOSTA/QUALIDADE/ATIVO/ENGENHARIA/ZZZZZZZZZZZZZ/XXXXXX/ENGENHARIA/ESTOQUE/OPERACOES" .AND. !ALLTRIM(cNaturez) $ "6.21.00/6.22.00";
			.OR. !ALLTRIM(cNaturez) $ "6.21.00/6.22.00"
			dbSelectArea("ZZH")
			ZZH->( dbSetOrder(1) )
			ZZH->(dbgotop())
				
			While ZZH->( ! EOF() ) .OR. alltrim(cFornece2) = alltrim(ZZH->ZZH_FORNEC)
				if alltrim(cFornece2) == alltrim(ZZH->ZZH_FORNEC)
					cFornece := ALLTRIM(ZZH->ZZH_FORNEC)
					//msginfo( "1: " + cFornece2 )
					//msginfo( "2: " + cFornece )
					exit
				endif
				ZZH->(dbskip())
			enddo
		
			if EMPTY(alltrim(M->E2_XNOC)) .AND. empty(cFornece) 
				alert("Informe Número da Ordem de Compra.")
				lRet := .F.
			endif
		endif
	endif
	
	
		
	//msginfo ("teste")
	
return (lRet)