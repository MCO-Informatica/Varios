#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"

//Teste Relatório Personalizado de cotações

User Function DBRCOTV(cMod)      

Local cOper   := ""  
Local cNumOrc := ""                 
Private cPerg:= Padr("COTVEND",10)  

If(ISINCALLSTACK("TMKA271")) 
	cOper := SUA->UA_OPER
	cNumOrc := SUA->UA_NUM	
	If(MsgYesNo("Deseja Gerar um Orçamento Personalizado para o Nº " + cNumOrc +"?","Orçamento Personalizado Verquímica"))
		//If(cOper == "2")      //Somente Orçamento
			DBRELCOTV(cNumOrc)                   
		//Else
		//	Alert("Não é possível gerar um orçamento personalizado para atendimentos que já viraram pedidos ou já foram faturados","Atenção")
		//EndIf
	Else
		vqpergunta()                                                                          
	EndIf
Else              
    vqpergunta()
EndIf

Return()   

Static Function vqpergunta()
	ajustasx1(cPerg)
	If(Pergunte(cPerg,.T.))
		While(!validaPrm())      
			Pergunte(cPerg,.T.)
		EndDo    
	 	DBRELCOTV(MV_PAR01)
	EndIf
Return


Static Function DBRELCOTV(cNumPed)              
Local aStr1	:= {}
Local aStr2	:= {}
Local aStr3	:= {}
Local aStr4	:= {}
Local aStr5	:= {}

Local lNcmProd := .F.
Local lNcm	   := .F.

Local _cLote	:= ""
Local _cDtEmis	:= ""
Local _cDtVali	:= ""    

Private cPath	:= GetSrvProfString("StartPath", "")   
Private cLogoD 	:= GetSrvProfString("Startpath","") + "logo.bmp"


Private oPrint:=FwMSPrinter():New('report.pdf',6,.T.,,.T.)

oPrint:SetResolution(72)
oPrint:SetPortrait()
oPrint:SetPaperSize(9)
oPrint:SetMargin(0,0,0,0)
oPrint:cPathPDF:= "c:\temp\" 
                                                                 
Private oFont10n := TFont():New("Arial",,10,,.F.,,,,,.F.,.F.)
Private oFont11n := TFont():New("Arial",,11,,.F.,,,,,.F.,.F.)
Private oFnt11nn := TFont():New("Arial",,11,,.T.,,,,,.F.,.F.)	
Private oFont16n := TFont():New("Arial",,16,,.F.,,,,,.F.,.F.)
Private oFnt16nn := TFont():New("Arial",,16,,.T.,,,,,.F.,.F.)
Private oFont22n := TFont():New("Arial",,22,,.F.,,,,,.F.,.F.)
Private oFont26n := TFont():New("Arial",,26,,.F.,,,,,.F.,.F.)

Private nLinha1 := 200
Private nLinha2 := 925
Private nLinha3 := 0   
Private nMaxLin := 2800 
Private nPagina := 1

Private cCodOrc := cNumPed
Private nTotCotD := 0 //Total Cotação Dólar
Private nTotCotR := 0 //Total Cotação Real
Private nDolHoje := 0  
Private nAliqIpi := 0 //Aliquota IPI

DbSelectArea("SUA"); DbSetOrder(1)
oPrint:StartPage()                                          

If SUA->(DbSeek(xFilial("SUA")+cCodOrc))    
	DbSelectArea("SA1"); DbSetOrder(1)
	If SA1->(DbSeek(xFilial("SA1")+SUA->(UA_CLIENTE+UA_LOJA)))
	    cEndEnt := ""
	    If !Empty(SA1->A1_ENDENT)
	    	cEndEnt := AllTrim(SA1->A1_ENDENT) + ", " + AllTrim(SA1->A1_CEPE) + ", " + AllTrim(SA1->A1_BAIRROE) + ", " + AllTrim(SA1->A1_MUNE) + " - " + AllTrim(SA1->A1_ESTE)
	    Else
	    	cEndEnt := AllTrim(SA1->A1_END) + ", " + AllTrim(SA1->A1_CEP) + ", " + AllTrim(SA1->A1_BAIRRO) + ", " + AllTrim(SA1->A1_MUN) + " - " + AllTrim(SA1->A1_EST)
	    EndIf
		cContato := ""
		If Empty(SUA->UA_CODCONT)
		 	cContato := "COMPRADOR"
		Else
			DbSelectArea("SU5"); DbSetOrder(1)
			If SU5->(DbSeek(xFilial("SU5")+SUA->UA_CODCONT))
				cContato := SU5->U5_CONTAT
			EndIf
		EndIf
		
		oPrint:Say(nLinha1+100,100,"COTAÇÃO: " + cCodOrc, oFnt16nn)
		oPrint:sayBitmap(nLinha1-100,1500,cLogoD, 520,305)          
		                 
		oPrint:Line(nLinha1+250, 100,nLinha1+250, oPrint:nHorzRes()-100 )
		
		oPrint:Say(nLinha1+300,100,"Guarulhos,"+ CVALTOCHAR(Day(Date())) + " de " + MesExtenso(Month(Date())) +" de " + CVALTOCHAR(Year(Date())), oFont11n)                           
		oPrint:Say(nLinha1+350,100,"À", oFont11n)                           
		oPrint:Say(nLinha1+400,100,SA1->A1_NOME + IIF(Empty(SA1->A1_CGC), ", CPF: " + SA1->A1_PFISICA, ", CNPJ: " + SA1->A1_CGC), oFont11n)                           
		oPrint:Say(nLinha1+450,100,"A/C: " + cContato , oFont11n)                           
		oPrint:Say(nLinha1+500,100,"Conforme solicitação, enviamos nossa cotação para o fornecimento do(s) produto(s) abaixo:", oFont11n)  		
		                                                                        
		/**CABEÇALHO DA TABELA DE ORÇAMENTO USANDO BOX**/
		oPrint:Box(nLinha1+575,100,nLinha1+750,oPrint:nHorzRes()-100) 			
		oPrint:Box(nLinha1+575,100,nLinha1+750,oPrint:nHorzRes()-210) 	                         
		oPrint:Box(nLinha1+575,100,nLinha1+750,oPrint:nHorzRes()-410) 	
		oPrint:Box(nLinha1+575,100,nLinha1+750,oPrint:nHorzRes()-610)
		oPrint:Box(nLinha1+575,100,nLinha1+750,oPrint:nHorzRes()-1010)
		oPrint:Box(nLinha1+575,100,nLinha1+750,oPrint:nHorzRes()-1310)
		oPrint:Box(nLinha1+575,100,nLinha1+750,oPrint:nHorzRes()-1710)  
			 	
		oPrint:Say(nLinha1+650,350,"Produto", oFnt11nn)                         	 
		oPrint:Say(nLinha1+650,800,"Embalagem", oFnt11nn)                                           
		oPrint:Say(nLinha1+650,1100,"Qtde Total", oFnt11nn)
	
		oPrint:Say(nLinha1+600,1400,"Preço Unitario", oFnt11nn)                                           
		oPrint:Say(nLinha1+650,1400,"com Impostos", oFnt11nn)                                           
		oPrint:Say(nLinha1+700,1400,"Sem IPI", oFnt11nn)  
		
		oPrint:Say(nLinha1+650,1800,"Unidade", oFnt11nn)                                        
		oPrint:Say(nLinha1+700,1800,"Medida", oFnt11nn)                                        
		
		oPrint:Say(nLinha1+650,2050,"ICMS", oFnt11nn)                                                               
		oPrint:Say(nLinha1+650,2200,"IPI", oFnt11nn)     		                                                    
	                                                    
		
		DbSelectArea("SUB"); DbSetOrder(1)
		If SUB->(DbSeek(xFilial("SUB")+SUA->UA_NUM))
			While !SUB->(Eof()) .And. SUB->(UB_FILIAL+UB_NUM) == xFilial("SUB")+SUA->UA_NUM   
				DbSelectArea("SB1"); DbSetOrder(1) 
				IF nLinha2 >= nMaxLin
					oPrint:EndPage()    
					oPrint:StartPage()
					nLinha2 := 200
					nPagina++
				EndIF                      
				oPrint:Box(nLinha2,100,nLinha2+100,oPrint:nHorzRes()-100)
				oPrint:Box(nLinha2,100,nLinha2+100,oPrint:nHorzRes()-210)
				oPrint:Box(nLinha2,100,nLinha2+100,oPrint:nHorzRes()-410)
				oPrint:Box(nLinha2,100,nLinha2+100,oPrint:nHorzRes()-610)
				oPrint:Box(nLinha2,100,nLinha2+100,oPrint:nHorzRes()-1010)
				oPrint:Box(nLinha2,100,nLinha2+100,oPrint:nHorzRes()-1310)
				oPrint:Box(nLinha2,100,nLinha2+100,oPrint:nHorzRes()-1710)
				If SB1->(DbSeek(xFilial("SB1")+SUB->UB_PRODUTO))
					DbSelectArea("SF4"); DbSetOrder(1)
					If SF4->(DbSeek(xFilial("SF4")+SUB->UB_TES))
					    If (SF4->F4_IPI == "S")     // Verifica se a TES calcula IPI   
						    nAliqIpi := SB1->B1_IPI // Aliquota IPI,0
						Else  
							nAliqIpi := 0
					    EndIF
					EndIf     
					
					cMatPrim := SB1->B1_VQ_MP
					cVqEmbal := SB1->B1_VQ_EM   
					If (SB1->B1_TIPO == "MP")
						oPrint:Say(nLinha2+50,150,SB1->B1_DESC, oFont11n)        					
					Else
						If SB1->(DbSeek(xFilial("SB1")+cMatPrim))
							oPrint:Say(nLinha2+50,150,SB1->B1_DESC, oFont11n)        					
						EndIf
					EndIf
                            
    				If(!Empty(cVqEmbal))
						If SB1->(DbSeek(xFilial("SB1")+cVqEmbal))
							aPriNmEm := StrTokArr(SB1->B1_DESC, " ")
							oPrint:Say(nLinha2+50,800,aPriNmEm[1], oFont11n)        
						EndIf
            		Else
    					oPrint:Say(nLinha2+50,800,"GRANEL", oFont11n)                 
    				EndIf
						        
				EndIf                
				              
				If SM2->(DbSeek(DtoS(Date())))   
					nDolHoje := SM2->M2_MOEDA2
				EndIf                        
				
				If(SUB->UB_VQ_MOED = "1")       
					nValIpi  := (SUB->UB_VQ_VRUN * SUB->UB_VQ_QTDE) * (nAliqIpi/100)
					nTotCotD += Round((((SUB->UB_VQ_VRUN * SUB->UB_VQ_QTDE) + nValIpi) / nDolHoje),2) 	
					nTotCotR += Round((SUB->UB_VQ_VRUN * SUB->UB_VQ_QTDE)+nValIpi,2)
				Else                                                           
					nValIpi  := (SUB->UB_VQ_VRUN * SUB->UB_VQ_QTDE) * (nAliqIpi/100)
				   	nTotCotR += Round((((SUB->UB_VQ_VRUN * SUB->UB_VQ_QTDE) + nValIpi) * nDolHoje),2)
					nTotCotD += Round((SUB->UB_VQ_VRUN * SUB->UB_VQ_QTDE)+nValIpi,2)
				EndIf                

				oPrint:Say(nLinha2+50,1100,TRANSFORM(SUB->UB_VQ_QTDE,"@E 999,999,999.99"), oFont11n)        
				oPrint:Say(nLinha2+50,1400,IIF(SUB->UB_VQ_MOED="1","R$ ","US$") + TRANSFORM(SUB->UB_VQ_VRUN,"@E 999,999,999.99"), oFont11n)     
				oPrint:Say(nLinha2+50,1850,IIF(SUB->UB_VQ_UM="L","LT","KG"), oFont11n)  
				oPrint:Say(nLinha2+50,2050,CVALTOCHAR(SUB->UB_VQ_PICM) + "%", oFont11n)        
				oPrint:Say(nLinha2+50,2235,CVALTOCHAR(nAliqIpi) + "%", oFont11n) 	
				nLinha2 += 100                                                           
				SUB->(DbSkip())
			EndDo		
			
			nLinha3 := nLinha2 + 50
			
			IF nLinha3 >= nMaxLin
				oPrint:EndPage()    
				oPrint:StartPage()
				nLinha3 := 200
				nPagina++
			EndIF   
			
			oPrint:Box(nLinha3+50,100,nLinha3+150,oPrint:nHorzRes()-100)
			oPrint:Box(nLinha3+50,100,nLinha3+150,oPrint:nHorzRes()-420)
			oPrint:Box(nLinha3+50,100,nLinha3+150,oPrint:nHorzRes()-820)
			oPrint:Box(nLinha3+50,100,nLinha3+150,oPrint:nHorzRes()-1220)
			oPrint:Box(nLinha3+50,100,nLinha3+150,oPrint:nHorzRes()-1720)
			oPrint:Say(nLinha3+100,200,"Prazo de Pagamento", oFnt11nn)                           
			oPrint:Say(nLinha3+100,700,"Condição de Frete", oFnt11nn)                                           
			oPrint:Say(nLinha3+100,1200,"Prazo de Entrega", oFnt11nn)                                           
	 		oPrint:Say(nLinha3+100,1600,"Total Cotação (R$)", oFnt11nn)                                           
			oPrint:Say(nLinha3+100,2000,"Total Cotação (US$)", oFnt11nn)                                           
			                                                                    
   			oPrint:Box(nLinha3+150,100,nLinha3+250,oPrint:nHorzRes()-100)
   			oPrint:Box(nLinha3+150,100,nLinha3+250,oPrint:nHorzRes()-420)
   			oPrint:Box(nLinha3+150,100,nLinha3+250,oPrint:nHorzRes()-820)
  			oPrint:Box(nLinha3+150,100,nLinha3+250,oPrint:nHorzRes()-1220)
  			oPrint:Box(nLinha3+150,100,nLinha3+250,oPrint:nHorzRes()-1720)
   			   			   			   			
			DbSelectArea("SE4"); DbSetOrder(1)

			If SE4->(DbSeek(xFilial("SE4")+SUA->UA_CONDPG))
				oPrint:Say(nLinha3+200,200,SE4->E4_DESCRI, oFont11n)                           
			Else
				oPrint:Say(nLinha3+200,200,"****", oFont11n)                           			
			EndIf                        
			            
			cTpFrete := IIF(SUA->UA_TPFRETE="C"," CIF **** "," FOB **** ")
			oPrint:Say(nLinha3+200,700,cTpFrete, oFont11n)                                           
			oPrint:Say(nLinha3+200,1200,"48 HORAS (GRANDE SP)**", oFont11n)   
			oPrint:Say(nLinha3+200,1600,TRANSFORM(nTotCotR, "@E 9,999,999,999.99"), oFont11n)   
	  		oPrint:Say(nLinha3+200,2000,TRANSFORM(nTotCotD, "@E 9,999,999,999.99"), oFont11n)  
	  		
			nLinha4 := nLinha3+350

			aFrases := FrasesPersonalizadas()
		
			oPrint:Say(nLinha4,100,"ENDEREÇO ENTREGA: " + cEndEnt,oFont11n)
			IF !EMPTY(SUA->UA_CODOBS)
				cObs := Msmm(SUA->UA_CODOBS,,,,3,,,,,,)
				If !Empty(AllTrim(cObs))
					nLinha4 := nLinha4 + 100
					oPrint:Say(nLinha4,100,"OBSERVAÇÕES DO ORÇAMENTO: " + cObs,oFont11n)
				EndIf
			EndIf
			nLinha4 := nLinha4 + 100
			For nX := 1 To Len(aFrases) 
				IF nLinha4 >= nMaxLin
					oPrint:EndPage()    
					oPrint:StartPage()
					nLinha4 := 200
					nPagina++
				EndIf       
			oPrint:Say(nLinha4,100,aFrases[nX],oFont11n)
			nLinha4 := nLinha4 + 50
			Next nX

		nLinha5 := nLinha4 + 50
		IF nLinha5 >= nMaxLin
			oPrint:EndPage()    
			oPrint:StartPage()
			nLinha5 := 200
			nPagina++
		EndIf
		
		
		oPrint:Say(nLinha5, 100, "Aguardamos uma posição de v.sas. e colocamo-nos a sua disposição.", oFont11n)
		DbSelectArea("SA3"); DbSetOrder(1)
			If SA3->(DbSeek(xFilial("SA3")+SUA->UA_VEND))
				oPrint:Say(nLinha5+100,475,SA3->A3_NOME, oFont11n)     
				oPrint:Say(nLinha5+150,475,SA3->A3_EMAIL, oFont11n)   
				oPrint:Say(nLinha5+200,475,"TEL.: " +SA3->A3_TEL, oFont11n)
			
				oPrint:Say(nLinha5+150,1425,"Visite nosso web site", oFont11n)    
		   		oPrint:Say(nLinha5+200,1425,"www.verquimica.com.br", oFont11n)     
			EndIf
		
		     
		EndIf
		
		oPrint:EndPage()
	EndIf
EndIf

  
Processa({||oPrint:Preview()},"Orçamento","Gerando orçamento em PDF", .F.)


FreeObj(oPrint)
oPrint := Nil
				
Return()                        

static function ajustaSx1(cPerg)
	//Aqui utilizo a função putSx1, ela cria a pergunta na tabela de perguntas
	putSx1(cPerg, "01", "Código Orçamento ?"	  		, "", "", "mv_ch1", "C",6,0,0,"G","", "", "", "", "mv_par01")
return              

static function validaPrm()
	lRet := .T.
	cMsgErro := "" 
	
	If(Empty(MV_PAR01))
		cMsgErro += "Preencha o código do orçamento" + cEoF
		lRet :=  .F.
	EndIf                                  
	
return lRet

Static Function FrasesPersonalizadas()
Local aRet := {}
	Aadd(aRet, "* Validade da Cotação : Sujeito a nossa confirmação no ato do fechamento do pedido.")
	Aadd(aRet, "* Tempo excedido para carga e descarga – o cliente tem prazo de 1 hora para carga seca e 3 horas para carga granel a contar do")
	Aadd(aRet, " momento de apresentação do veículo na portaria. Excedendo este prazo será cobrada a estadia do veículo conforme tabela de preços da transportadora contratada.")
	Aadd(aRet, "* As entregas fracionadas seguem o fluxo logístico do veículo respeitando os horários previamente estabelecidos pelo cliente, não sendo possível ") 
	Aadd(aRet, " entrega com horário marcado, para esta modalidade ou entregas urgentes deve ser considerado a negociação e contratação de frete fechado onde ") 
	Aadd(aRet, " o veículo será enviado exclusivamente com a carga solicitada.")
	Aadd(aRet, "* Referente a descarga de produtos a granel ou IBC’s é de responsabilidade do cliente definir o local e avaliação do estado da ")
	Aadd(aRet, "embalagem destino. Não nos responsabilizamos por qualquer contaminação do produto após a descarga em embalagens do cliente.")
	Aadd(aRet, "* A avaliação do produto quanto a quantidade e qualidade além do estado da embalagem, devem ser realizados no momento do recebimento") 
	Aadd(aRet, " e qualquer irregularidade apontada de imediato.")
	Aadd(aRet, "* Para acordo de especificação caso o cliente não tenha homologado especificação própria, fica definido como parâmetro de aceitação")
	Aadd(aRet, " a especificação Verquimica.")
	Aadd(aRet, "* Avarias da transportadora em vendas FOB são de responsabilidade do cliente, a transportadora ao receber a carga verifica e") 
	Aadd(aRet, " assina um termo de recebimento que a embalagem estava em perfeitas condições.")
	Aadd(aRet, "* É de responsabilidade do cliente a confirmação de todos os dados do orçamento e as condições acima mencionadas e o aceite do pedido")
	Aadd(aRet, " deve ser formalizado via e-mail para o departamento comercial. ")
	Aadd(aRet, "* É de responsabilidade do cliente verificar se a quantidade solicitada será comportada para armazenamento em seu estoque,") 
	Aadd(aRet, " evitando devoluções (totais ou parciais).")
	Aadd(aRet, "* Pedidos programados sujeitos a reajuste conforme produtor.")
	Aadd(aRet, "* Devoluções somente serão aceitas quando acordado com nosso departamento comercial e formalizado via e-mail.")
	Aadd(aRet, " Quando o motivo da devolução for causado por falha do cliente, serão cobrados os custos do frete de ida e volta do produto.")
	Aadd(aRet, "* A transportadora ou veículo próprio deverá atender todas as legislações em vigor (Decreto 96044/88 E Resolução ANTT5232/16")
	Aadd(aRet, "quanto ao TRANSPORTE DE PRODUTOS PERIGOSOS.")
	DbSelectArea("SA4"); DbSetOrder(1)
	If SA4->(DbSeek(xFilial("SA4")+SUA->UA_TRANSP))
   		Aadd(aRet, "* " + cTpFrete + " - " + SA4->A4_NOME)     
	Else
		Aadd(aRet, "* " + cTpFrete + " - ")     
	EndIf 
	Aadd(aRet, "**48 Horas para dentro da Grande SP após confirmação do pedido, demais regiões verificar com o vendedor.")
	Aadd(aRet, "* Prezados Clientes, a política da Verquimica não permite o reajuste de vencimentos após a emissão da nota fiscal,")
	Aadd(aRet, "Pedimos confirmar o vencimento das duplicatas no fechamento do pedido.")
	
Return aRet