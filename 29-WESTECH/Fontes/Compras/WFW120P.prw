#INCLUDE "Protheus.ch"                              
#INCLUDE "TopConn.ch"

User Function WFW120P()

Local aAreaSC7     := SC7->( GetArea() )

Local cPedido   := SC7->C7_NUM
Local cRev   	:= SC7->C7_XXREV + 1 
Local nXTOTSI 	:= 0
Local nTPIC		:= "1" // tipo 1 = contratos / tipo 2 administracao
Local nPICM 	:= 0
Local nValCof2	:= 0
Local nValPIS2 		:= 0 

//Private l120Inclui := paramixb[2] // Flag de Inclus�o
//Private l120Altera := paramixb[3] // Flag de altera��o

dbSelectArea("SC7")
SC7->( dbGoTop() )
SC7->(dbSetOrder(1) ) // D2_FILIAL + C7_NUM 



	If SC7->( dbSeek(xFilial("SC7")+cPedido) )
		If MsgYesNo("Aplicar PIS / Cofins no Pedido de Compra?")

			While SC7->( ! EOF() ) .AND. SC7->C7_NUM == cPedido  
		        cFornece	:= Alltrim(SC7->C7_FORNECE)
		        cItemCTA	:= Alltrim(SC7->C7_ITEMCTA)
		        cProduto	:= Alltrim(SC7->C7_PRODUTO)
		        cProdTP		:= Alltrim(Posicione("SB1",1,xFilial("SB1")+cProduto,"SB1->B1_TIPO"))
		        cTPJ		:= Alltrim(Posicione("SA2",1,xFilial("SA2")+cFornece,"SA2->A2_TPJ"))
		        nTotal 		:= SC7->C7_TOTAL
		        nTotalSIPI	:= SC7->C7_TOTAL
				nValIPI 	:= SC7->C7_VALIPI
				nValICM		:= SC7->C7_VALICM
				nValISS 	:= SC7->C7_VALISS
				cXNotas		:= SC7->C7_XNOTAS
				
		    	RecLock("SC7",.F.)
		    		if cTPJ = "3" .OR. cProdTP == "MC" .OR. cItemCTA == "ADMINISTRACAO" .OR. cItemCTA == "PROPOSTA" .OR. cItemCTA == "ATIVO" .OR. cItemCTA == "QUALIDADE" .OR. cItemCTA == "ENGENHARIA"
		    			nValCof			:= 0
						nValPIS 		:= 0 
						SC7->C7_XPCOF	:= 0
				 		SC7->C7_XPPIS  	:= 0
				 		nPICM			:= SC7->C7_PICM
				 	else
					 	
						nValCof			:= 7.6
						nValPIS 		:= 1.65 
						nValCof2		:= 0.076
						nValPIS2 		:= 0.0165 
						SC7->C7_XPCOF	:= 7.6
						SC7->C7_XPPIS  	:= 1.65
					
				 		nPICM			:= SC7->C7_PICM
				 	endif


				 	SC7->C7_XNUM		:= SC7->C7_NUM		           
					SC7->C7_XTOTSI 	:= nTotal*(1-((SC7->C7_PICM/100)+(nValPIS/100)+(nValCof/100))) //nTotalSIPI-nValICM-((nTotalSIPI*(nValCof/100))-(nTotalSIPI*(nValPIS/100)))
					
					nTotsi := nTotal*(1-((nPICM/100)+(nValPIS/100)+(nValCof/100)))
			
				
					nXTOTSI := SC7->C7_XTOTSI
					if  cItemCTA $ ("ADMINISTRACAO'/PROPOSTA/QUALIDADE/ATIVO/ENGENHARIA/ZZZZZZZZZZZZZ/XXXXXX/ENGENHARIA/OPERACOES")
						nTPIC := "2"
					else
						nTPIC := "1"
					
					endif
					
					SC7->C7_XNOTAS := cXNotas
				
		        MsUnlock()  
		 
		       	SC7->( dbSkip() )
		    EndDo

		else

			While SC7->( ! EOF() ) .AND. SC7->C7_NUM == cPedido  
		        cFornece	:= Alltrim(SC7->C7_FORNECE)
		        cItemCTA	:= Alltrim(SC7->C7_ITEMCTA)
		        cProduto	:= Alltrim(SC7->C7_PRODUTO)
		        cProdTP		:= Alltrim(Posicione("SB1",1,xFilial("SB1")+cProduto,"SB1->B1_TIPO"))
		        cTPJ		:= Alltrim(Posicione("SA2",1,xFilial("SA2")+cFornece,"SA2->A2_TPJ"))
		        nTotal 		:= SC7->C7_TOTAL
		        nTotalSIPI	:= SC7->C7_TOTAL
				nValIPI 	:= SC7->C7_VALIPI
				nValICM		:= SC7->C7_VALICM
				nValISS 	:= SC7->C7_VALISS
				cXNotas		:= SC7->C7_XNOTAS
				
		    	RecLock("SC7",.F.)
		    		if cTPJ = "3" .OR. cProdTP == "MC" .OR. cItemCTA == "ADMINISTRACAO" .OR. cItemCTA == "PROPOSTA" .OR. cItemCTA == "ATIVO" .OR. cItemCTA == "QUALIDADE" .OR. cItemCTA == "ENGENHARIA"
		    			nValCof			:= 0
						nValPIS 		:= 0 
						SC7->C7_XPCOF	:= 0
				 		SC7->C7_XPPIS  	:= 0
				 		nPICM			:= SC7->C7_PICM
				 	else
					 	
						nValCof			:= 0
						nValPIS 		:= 0 
						nValCof2		:= 0
						nValPIS2 		:= 0 
						SC7->C7_XPCOF	:= 0
						SC7->C7_XPPIS  	:= 0
					
				 		nPICM			:= SC7->C7_PICM
				 	endif


				 	SC7->C7_XNUM		:= SC7->C7_NUM		           
					SC7->C7_XTOTSI 	:= nTotal*(1-((SC7->C7_PICM/100)+(nValPIS/100)+(nValCof/100))) //nTotalSIPI-nValICM-((nTotalSIPI*(nValCof/100))-(nTotalSIPI*(nValPIS/100)))
					
					nTotsi := nTotal*(1-((nPICM/100)+(nValPIS/100)+(nValCof/100)))
			
				
					nXTOTSI := SC7->C7_XTOTSI
					if  cItemCTA $ ("ADMINISTRACAO'/PROPOSTA/QUALIDADE/ATIVO/ENGENHARIA/ZZZZZZZZZZZZZ/XXXXXX/ENGENHARIA/OPERACOES")
						nTPIC := "2"
					else
						nTPIC := "1"
					
					endif
					
					SC7->C7_XNOTAS := cXNotas
				
		        MsUnlock()  
		 
		       	SC7->( dbSkip() )
		    EndDo

		endif

	EndIf
	
	/*
	SC7->( dbGoTop() )	            
	
	If !SC7->( dbSeek(xFilial("SC7")+cPedido) )
	
	      While SC7->( ! EOF() ) .AND. SC7->C7_NUM  == cPedido
	           msginfo("wfw120f")     
	           RecLock("SC7",.F.)
			   		if empty(alltrim(SC7->C7_XCTRVB)) 
						if nTPIC = "2"
							SC7->C7_XCTRVB := "3"
							SC7->C7_XAPRN1 := ""
							SC7->C7_XAPRN2 := ""
						elseif nXTOTSI < 5000 .AND. nTPIC = "1"
							SC7->C7_XCTRVB := "2"
							SC7->C7_XAPRN1 := ""
							SC7->C7_XAPRN2 := ""
						elseif nXTOTSI >= 5000 .AND. nTPIC = "1"
							SC7->C7_XCTRVB := "1"
							SC7->C7_XAPRN1 := ""
							SC7->C7_XAPRN2 := ""
						endif
					endif
	           MsUnlock()  
	           
	           //msginfo( )
	 
	           SC7->( dbSkip() )
	      EndDo
	
	EndIf    
	*/

If MsgYesNo("Atualizar Controle de Revisao?")//Se a condi��o for satisfat�ria verdadeiro
	
	SC7->( dbGoTop() )	            
	
	If SC7->( dbSeek(xFilial("SC7")+cPedido) )
	
	      While SC7->( ! EOF() ) .AND. SC7->C7_NUM  == cPedido
	                
	           RecLock("SC7",.F.)            
	                 SC7->C7_XXREV := cRev
	                 SC7->C7_XXDTREV := Date()
	           MsUnlock()  
	 
	           SC7->( dbSkip() )
	      EndDo
	
	EndIf     
	
Endif

RestArea(aAreaSC7)

u_zEvMail()


Return ( NIL )

