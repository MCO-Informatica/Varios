#include 'protheus.ch'
#include 'parmtype.ch'

user function MTA120G1()
		
		Local aMatriz2 		:= {}
		Local aMatriz		:= {}
		Local nI 			:= 0
		Local nI2 			:= 0
		Local nI3 			:= 0
		Local cItemConta 	:= ""
		Local cMensagem2 	:= ""
		Local cMensagem 	:= ""
		Private nTotal		:= 0
		Private _lRet		:= .T.
		
		Private cA120Num   := paramixb[1] // Número do pedido
		Private l120Inclui := paramixb[2] // Flag de Inclusão
		Private l120Altera := paramixb[3] // Flag de alteração
		Private l120Deleta := paramixb[4] // Flag de Exclusão
		
		dbSelectArea("CTD")
		CTD->( dbSetOrder(1) )
			
		for nI=1 to Len( aCOLS )
			AAdd( aMatriz,  ALLTRIM(aCols[nI][3]),nI )
			if ascan(aMatriz2,aMatriz[nI]) = 0 
				aadd(aMatriz2,aMatriz[nI]) 
			endif     
		next      
		
		for nI=1 to len(aMatriz2) 
			//alert(aMatriz2[nI]+"aaa")
			cMensagem += aMatriz[nI] + chr(13) + chr(10)
		next  
		
		//alert (cMensagem)
	if l120Inclui	
		
	for nI3 = 1 to Len(aMatriz2)
		nTotal := 0
		cItemICM := alltrim(aMatriz2[nI3])
		
		// Soma de valores do Item Conta
		for nI2=1 to Len( aCOLS )
			if ALLTRIM(aCols[nI2][3]) == cItemICM //.AND. ! ALLTRIM(aCols[nI2][2]) $ ("ADMINISTRACAO'/PROPOSTA/QUALIDADE/ATIVO/ENGENHARIA/ZZZZZZZZZZZZZ/XXXXXX/ENGENHARIA/ESTOQUE/OPERACOES")
				
				nValCof			:= 0.076
				nValPIS 		:= 0.0165 
				
				nTotal += (aCols[nI2][10])-aCols[nI2][39]-aCols[nI2][68] -(aCols[nI2][10]*nValCof)-(aCols[nI2][10]*nValPIS)
				//nTotal += (aCols[nI2][10]-aCols[nI2][38])-aCols[nI2][39]-aCols[nI2][68] -((aCols[nI2][10]-aCols[nI2][38])*nValCof)-((aCols[nI2][10]-aCols[nI2][38])*nValPIS)
				//nTotalSIPI-nValICM-nValISS-(nTotalSIPI*(nValCof/100))-(nTotalSIPI*(nValPIS/100))
			endif
		next
		
		if ! ALLTRIM(cItemICM) $ ("ADMINISTRACAO'/PROPOSTA/QUALIDADE/ATIVO/ENGENHARIA/ZZZZZZZZZZZZZ/XXXXXX/ENGENHARIA/ESTOQUE/OPERACOES") .or. empty(cItemICM)
			if CTD->( dbSeek( xFilial("CTD")+cItemICM) )
			
				 nTotACPR := CTD->CTD_XACPR + nTotal + CTD->CTD_XVBAD
				 nTotCUPR := CTD->CTD_XCUPRR
				 
				 if nTotACPR > nTotCUPR
				 	
				 	msginfo("Ordem de Compra supera verba do Contrato " + cItemICM + ". Solicite verba adicional a Diretoria. " + chr(13) + chr(10) + "Operação será cancelada. ")
				 	l120Inclui := .F.
				 	//BREAK
				 	//RollBackSX8()
					//Return .F.
	
				 endif
				
			endif
		endif
		
	
	next
	
	endif
	//alert( cValtoChar(nTotal) )	
		
return (nil)



