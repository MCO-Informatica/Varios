#include 'protheus.ch'
#include 'parmtype.ch'

user function MT100LOK()
	
		Local aMatriz2 		:= {}
		Local aMatriz		:= {}
		Local nI 			:= 0
		Local nI2 			:= 0
		Local nI3 			:= 0
		Local cItemConta 	:= ""
		Local cMensagem2 	:= ""
		Local cMensagem 	:= ""
		Local cCTRVB		:= ""
		
		Local ccNum			:= alltrim(CNFISCAL)
		Local ccSerie		:= alltrim(CSERIE)
		Local ccFornece		:= alltrim(CA100FOR)
		Local ccLoja		:= alltrim(CLOJA)
		
		Local nTotalOCA		:= 0
		Local nTotalOCP		:= 0
		Local cNumPed		:= "''"

		Private nTotal		:= 0
		Private lRet		:= .T.
		
	
		//msginfo (ccNum)
		//msginfo (ccSerie)
		//msginfo (ccFornece)
		//msginfo (ccFornece)

		//Private l120Deleta := paramixb[4] // Flag de Exclusão
		/*
		dbSelectArea("CTD")
		CTD->( dbSetOrder(1) )
		
		for nI=1 to Len( aCOLS )
			AAdd( aMatriz,  ALLTRIM(aCols[nI][20]),nI )
			if ascan(aMatriz2,aMatriz[nI]) = 0 
				aadd(aMatriz2,aMatriz[nI]) 
			endif
			ccNum 	:= ALLTRIM(aCols[nI][26])
			cNumPed	:= ALLTRIM(aCols[nI][29])
			  
		next      
	
		//if M->D1_RATEIO == "2"
			//msginfo ( cNumPed )
			
			for nI=1 to len(aMatriz2) 
				//alert(aMatriz2[nI])
				cMensagem += aMatriz[nI] + chr(13) + chr(10)
			next  
				
			for nI3 = 1 to Len(aMatriz2)
				nTotal := 0
				cItemICM := alltrim(aMatriz2[nI3])
				
				// Soma de valores do Item Conta
				for nI2=1 to Len( aCOLS )
					if ALLTRIM(aCols[nI2][20]) == cItemICM .OR. !Empty(cItemICM)
						nTotal += aCols[nI2][11]
						
					endif
				next
				
				//msginfo (cValToChar(nTotal)) 
				
				SD1->( dbSetOrder(1) )
				
				If SD1->( dbSeek(xFilial("SD1")+ccNum+ccSerie+ccFornece+ccLoja) ) == .F. //.OR. Empty(cNum)
							
					if Empty(cNumPed)
						//msginfo ( cNumPed + "aaa" )
						if ! ALLTRIM(cItemICM) $ ("ADMINISTRACAO'/PROPOSTA/QUALIDADE/ATIVO/ENGENHARIA/ZZZZZZZZZZZZZ/XXXXXX/ENGENHARIA/ESTOQUE/OPERACOES") .OR. !Empty(cItemICM)
							
							if CTD->( dbSeek( xFilial("CTD")+cItemICM) )
							
								 nTotACPR := CTD->CTD_XACPR + nTotal 
								 nTotCUPR := CTD->CTD_XCUPRR + CTD->CTD_XVBAD
								 
								 if nTotACPR > nTotCUPR
								 	
								 	alert("Documento supera verba do Contrato. Solicite verba adicional a Diretoria........ " + CRLF + ;
								 	CRLF + "NF não pode ser salva. "; 
								 	+ CRLF + ;
								 	cItemICM + CRLF + CRLF +;
								 	"Verba s/ Tributos " + cValToChar(Transform(nTotCUPR,"@E 999,999,999.99")) + CRLF +;
								 	"Verba adicional s/ Tributos " + cValToChar(Transform(CTD->CTD_XVBAD,"@E 999,999,999.99")) + CRLF +;
								 	"Custo Atual s/ Tributos: " + cValToChar(Transform(CTD->CTD_XACPR,"@E 999,999,999.99")) + CRLF +;
								 	"Total Itens s/ Tributos vinculados ao Contrato: " + cValToChar(Transform(nTotal,"@E 999,999,999.99"));
								 	)
								 	lRet		:= .F.
			
								 endif
								
							endif
							
						endif
						
					endif
							
				else
					// Total Pedido ja gravado
					If SD1->( dbSeek(xFilial("SD1")+ccNum+ccSerie+ccFornece+ccLoja) )
				
						While SD1->( ! EOF() ) 
					        if SD1->D1_DOC == cXNum .AND. SD1->D1_SERIE == ccSerie .AND. SD1->D1_FORNECE == ccFornece .AND. SD1->D1_LOJA == ccLoja
					        	nTotalOCA	+= SD1->D1_TOTAL
					        endif
					       	SD1->( dbSkip() )
					    EndDo
					
					endif
					
					if Empty(cNumPed)
					
						if nTotal > nTotalOCA
							//**
							if ! ALLTRIM(cItemICM) $ ("ADMINISTRACAO'/PROPOSTA/QUALIDADE/ATIVO/ENGENHARIA/ZZZZZZZZZZZZZ/XXXXXX/ENGENHARIA/ESTOQUE/OPERACOES") .OR. !Empty(cItemICM)
								
								if CTD->( dbSeek( xFilial("CTD")+cItemICM) )
								
									 nTotACPR := CTD->CTD_XACPR + nTotal 
									 nTotCUPR := CTD->CTD_XCUPRR + CTD->CTD_XVBAD
									 
									 if nTotACPR > nTotCUPR
									 	
									 	alert("Alteração do Documento supera verba do Contrato. Solicite verba adicional a Diretoria......... " + CRLF + ;
									 	CRLF + "NF não pode ser salva. "; 
									 	+ CRLF + ;
									 	cItemICM + CRLF + CRLF +;
									 	"Verba s/ Tributos " + cValToChar(Transform(nTotCUPR,"@E 999,999,999.99")) + CRLF +;
									 	"Verba adicional s/ Tributos " + cValToChar(Transform(CTD->CTD_XVBAD,"@E 999,999,999.99")) + CRLF +;
									 	"Custo Atual s/ Tributos: " + cValToChar(Transform(CTD->CTD_XACPR,"@E 999,999,999.99")) + CRLF +;
									 	"Total Itens s/ Tributos vinculados ao Contrato: " + cValToChar(Transform(nTotal,"@E 999,999,999.99"));
									 	)
									 	lRet		:= .F.
				
									 endif
									
								endif
								
							endif
							
						endif
						
					endif
				
				endif
			
			next
		//endif
		//alert( cValtoChar(nTotal) )	
		*/
return lRet