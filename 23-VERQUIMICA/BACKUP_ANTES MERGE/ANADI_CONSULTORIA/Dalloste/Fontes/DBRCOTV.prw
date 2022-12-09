#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"

//Teste Relat�rio Personalizado de cota��es

User Function DBRCOTV(cMod)      

	Local cOper   := SUA->UA_OPER // 1 - Faturamento 2 - Cota��o
	Local cNumOrc := SUA->UA_NUM	
	Local cNumPed := SUA->UA_NUMSC5
	Local nOpc    := 0

	Local cTexto  := "Selecione a op��o que deseja abaixo - Cota��o:" + cNumOrc + " - Pedido:" + cNumPed + "              
	Private cPerg:= Padr("COTVEND",10)  

	If(ISINCALLSTACK("TMKA271")) 

		nOpc := Aviso("Impress�o Cota��o/Pedido", cTexto,{"Pedido","Or�amento","Fechar"}, 2)

		If nOpc = 2 
			If !Empty(cNumOrc)  
				DBRELCOTV(cNumOrc,cNumPed,nOpc)
			Else
				Alert("N�o foi poss�vel imprimir essa cota��o/or�amento")  
			Endif     

		Elseif nOpc = 1
			If !Empty(cNumPed)
				DBRELCOTV(cNumOrc,cNumPed,nOpc) 
			Else
				Alert("N�o � possivel imprimir o Pedido de Vendas")
			Endif
		Endif   
	EndIf	

	/*

	If(MsgYesNo("Deseja Gerar um Or�amento Personalizado para o N� " + cNumOrc +"?","Or�amento Personalizado Verqu�mica"))
	If(cOper == "2")      //Somente Or�amento
	DBRELCOTV(cNumOrc)                   
	Else
	Alert("N�o � poss�vel gerar um or�amento personalizado para atendimentos que j� viraram pedidos ou j� foram faturados","Aten��o")
	EndIf
	Else
	vqpergunta()                                                                          
	EndIf
	Else              
	vqpergunta()
	EndIf
	*/


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


Static Function DBRELCOTV(cNumOrc,cNumPV,nOpc)              

	Local aStr1	:= {}
	Local aStr2	:= {}
	Local aStr3	:= {}
	Local aStr4	:= {}
	Local aStr5	:= {}

	Local lNcmProd := .F.
	Local lNcm	   := .F.
	Local lReal    := .T.
	Local _cLote   := ""
	Local _cDtEmis := ""
	Local _cDtVali := ""    
	Private lPv      := .F.
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

	Private cCodOrc := cNumOrc
	Private nTotCotD := 0 //Total Cota��o D�lar
	Private nTotCotR := 0 //Total Cota��o Real
	Private nDolHoje := 0  
	Private nAliqIpi := 0 //Aliquota IPI

	DbSelectArea("SUA")
	DbSetOrder(1)

	oPrint:StartPage()                                          

	If nOpc = 1  // Valida��o para determinar se � Pedido de Vendas ou Or�amento
		lPv := .T.
	Endif 



	If SUA->(DbSeek(xFilial("SUA")+cCodOrc))    
		DbSelectArea("SA1")
		DbSetOrder(1)
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

			If !lPv
				oPrint:Say(nLinha1+100,100,"COTA��O: " + cCodOrc, oFnt16nn)
			Else
				oPrint:Say(nLinha1+100,100,"PEDIDO: "  + cNumPV, oFnt16nn)
			Endif  

			oPrint:sayBitmap(nLinha1-100,1500,cLogoD, 520,305)          

			oPrint:Line(nLinha1+250, 100,nLinha1+250, oPrint:nHorzRes()-100 )

			oPrint:Say(nLinha1+300,100,"Guarulhos, "+ CVALTOCHAR(Day(Date())) + " de " + MesExtenso(Month(Date())) +" de " + CVALTOCHAR(Year(Date())), oFont11n)                           
			oPrint:Say(nLinha1+350,100,"�", oFont11n)                           
			oPrint:Say(nLinha1+400,100,Alltrim(SA1->A1_NOME) + IIF(Empty(SA1->A1_CGC), " -  CPF: " + SA1->A1_PFISICA, " - CNPJ: " + Transform(SA1->A1_CGC,"@R 99.999.999/9999-99")), oFont11n)                           
			oPrint:Say(nLinha1+450,100,"A/C: " + cContato , oFont11n)                           

			If !lPv
				oPrint:Say(nLinha1+500,100,"Conforme solicita��o, enviamos nossa cota��o para o fornecimento do(s) produto(s) abaixo:", oFont11n)  
			Else
				oPrint:Say(nLinha1+500,100,"Conforme negocia��o, enviamos a confirma��o do seu pedido de compras para fornecimento do(s) produto(s) abaixo:", oFont11n)
			Endif  		

			/**CABE�ALHO DA TABELA DE OR�AMENTO USANDO BOX**/
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

			oPrint:Say(nLinha1+600,1400,"Pre�o Unitario", oFnt11nn)                                           
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

						If !Empty(SUB->UB_VQ_VSUF) .AND. !lPv // Se FOR SUFRAMA, 
							nTotCotD += Round((((SUB->UB_VQ_VSUF * SUB->UB_VQ_QTDE) )/nDolHoje),2) 	
							nTotCotR += Round((SUB->UB_VQ_VSUF* SUB->UB_VQ_QTDE),2)
						Else	
							nValIpi  := (SUB->UB_VQ_VRUN * SUB->UB_VQ_QTDE) * (nAliqIpi/100)
							nTotCotD += Round((((SUB->UB_VQ_VRUN * SUB->UB_VQ_QTDE) + nValIpi) / nDolHoje),2) 	
							nTotCotR += Round((SUB->UB_VQ_VRUN * SUB->UB_VQ_QTDE)+nValIpi,2)
						Endif

					Else                                                           

						If !Empty(SUB->UB_VQ_VSUF) .AND. !lPv // Se FOR SUFRAMA, 
							nTotCotR += Round((((SUB->UB_VQ_VSUF * SUB->UB_VQ_QTDE))* nDolHoje),2) 	
							nTotCotD += Round((SUB->UB_VQ_VSUF* SUB->UB_VQ_QTDE),2)
						Else
							nValIpi  := (SUB->UB_VQ_VRUN * SUB->UB_VQ_QTDE) * (nAliqIpi/100)
							nTotCotR += Round((((SUB->UB_VQ_VRUN * SUB->UB_VQ_QTDE) + nValIpi) * nDolHoje),2)
							nTotCotD += Round((SUB->UB_VQ_VRUN * SUB->UB_VQ_QTDE)+nValIpi,2)
						Endif
						lReal := .F.
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
				oPrint:Say(nLinha3+100,700,"Condi��o de Frete", oFnt11nn)                                           
				oPrint:Say(nLinha3+100,1200,"Prazo de Entrega", oFnt11nn)                                           

				If !lPv
					oPrint:Say(nLinha3+100,1600,"Total Cota��o (R$)", oFnt11nn)                                           
					oPrint:Say(nLinha3+100,2000,"Total Cota��o (US$)", oFnt11nn)                                           
				Else
					oPrint:Say(nLinha3+100,1600,"Total Pedido (R$)", oFnt11nn)                                           
					oPrint:Say(nLinha3+100,2000,"Total Pedido (US$)", oFnt11nn) 
				Endif
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


				If !lPv
					oPrint:Say(nLinha3+200,1600,TRANSFORM(nTotCotR, "@E 9,999,999,999.99"), oFont11n)   
					oPrint:Say(nLinha3+200,2000,TRANSFORM(nTotCotD, "@E 9,999,999,999.99"), oFont11n)  
				Else 
					If lReal // REAL
						oPrint:Say(nLinha3+200,1600,TRANSFORM(nTotCotR, "@E 9,999,999,999.99"), oFont11n)
					Else
						oPrint:Say(nLinha3+200,2000,TRANSFORM(nTotCotD, "@E 9,999,999,999.99"), oFont11n)
					Endif  
				Endif 

				nLinha4 := nLinha3+350

				aFrases := FrasesPersonalizadas()

				oPrint:Say(nLinha4,100,"ENDERE�O ENTREGA: " + cEndEnt,oFont11n)

				IF !EMPTY(SUA->UA_CODOBS)
					cObs := Msmm(SUA->UA_CODOBS,,,,3,,,,,,)
					If !Empty(AllTrim(cObs))
						nLinha4 := nLinha4 + 100
						If !lPv
							oPrint:Say(nLinha4,100,"OBSERVA��ES DO OR�AMENTO: " + cObs,oFont11n)
						Else
							oPrint:Say(nLinha4,100,"OBSERVA��ES DO PEDIDO: " + cObs,oFont11n)
						Endif    
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

				If !lPv
					oPrint:Say(nLinha5, 100, "Aguardamos uma posi��o de v.sas. e colocamo-nos a sua disposi��o.", oFont11n)
				Else
					oPrint:Say(nLinha5, 100, "Agradecemos pelo pedido e colocamo-nos a sua disposi��o.", oFont11n)
				Endif  
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


	Processa({||oPrint:Preview()},"Or�amento","Gerando or�amento em PDF", .F.)


	FreeObj(oPrint)
	oPrint := Nil

Return()                        

static function ajustaSx1(cPerg)
	//Aqui utilizo a fun��o putSx1, ela cria a pergunta na tabela de perguntas
	putSx1(cPerg, "01", "C�digo Or�amento ?"	  		, "", "", "mv_ch1", "C",6,0,0,"G","", "", "", "", "mv_par01")
return              

static function validaPrm()
	lRet := .T.
	cMsgErro := "" 

	If(Empty(MV_PAR01))
		cMsgErro += "Preencha o c�digo do or�amento" + cEoF
		lRet :=  .F.
	EndIf                                  

return lRet

Static Function FrasesPersonalizadas()

	Local aRet := {}
	If !lPv
		Aadd(aRet, "* Validade da Cota��o : Sujeito a nossa confirma��o no ato do fechamento do pedido.")
	Else
		Aadd(aRet, "* Esta � a confirma��o do seu pedido de compras e qualquer d�vida e/ou diverg�ncia, por favor formalizar.")
		Aadd(aRet, "* Caso n�o recebamos qualquer notifica��o, consideraremos o pedido em quest�o confirmado.")
	Endif  

	Aadd(aRet, "* Tempo excedido para carga e descarga � o cliente tem prazo de 1 hora para carga seca e 3 horas para carga granel a contar do")
	Aadd(aRet, " momento de apresenta��o do ve�culo na portaria. Excedendo este prazo ser� cobrada a estadia do ve�culo conforme tabela de pre�os da transportadora contratada.")
	Aadd(aRet, "* As entregas fracionadas seguem o fluxo log�stico do ve�culo respeitando os hor�rios previamente estabelecidos pelo cliente, n�o sendo poss�vel ") 
	Aadd(aRet, " entrega com hor�rio marcado, para esta modalidade ou entregas urgentes deve ser considerado a negocia��o e contrata��o de frete fechado onde ") 
	Aadd(aRet, " o ve�culo ser� enviado exclusivamente com a carga solicitada.")
	Aadd(aRet, "* Referente a descarga de produtos a granel ou IBC�s � de responsabilidade do cliente definir o local e avalia��o do estado da ")
	Aadd(aRet, "embalagem destino. N�o nos responsabilizamos por qualquer contamina��o do produto ap�s a descarga em embalagens do cliente.")
	Aadd(aRet, "* A avalia��o do produto quanto a quantidade e qualidade al�m do estado da embalagem, devem ser realizados no momento do recebimento") 
	Aadd(aRet, " e qualquer irregularidade apontada de imediato.")
	Aadd(aRet, "* Para acordo de especifica��o caso o cliente n�o tenha homologado especifica��o pr�pria, fica definido como par�metro de aceita��o")
	Aadd(aRet, " a especifica��o Verquimica.")
	Aadd(aRet, "* Avarias da transportadora em vendas FOB s�o de responsabilidade do cliente, a transportadora ao receber a carga verifica e") 
	Aadd(aRet, " assina um termo de recebimento que a embalagem estava em perfeitas condi��es.")
	If !lPv
		Aadd(aRet, "* � de responsabilidade do cliente a confirma��o de todos os dados do or�amento e as condi��es acima mencionadas e o aceite do pedido")
		Aadd(aRet, " deve ser formalizado via e-mail para o departamento comercial. ")
	Endif
	Aadd(aRet, "* � de responsabilidade do cliente verificar se a quantidade solicitada ser� comportada para armazenamento em seu estoque,") 
	Aadd(aRet, " evitando devolu��es (totais ou parciais).")
	Aadd(aRet, "* Pedidos programados sujeitos a reajuste conforme produtor.")
	Aadd(aRet, "* Devolu��es somente ser�o aceitas quando acordado com nosso departamento comercial e formalizado via e-mail.")
	Aadd(aRet, " Quando o motivo da devolu��o for causado por falha do cliente, ser�o cobrados os custos do frete de ida e volta do produto.")
	Aadd(aRet, "* A transportadora ou ve�culo pr�prio dever� atender todas as legisla��es em vigor (Decreto 96044/88 E Resolu��o ANTT5232/16")
	Aadd(aRet, "quanto ao TRANSPORTE DE PRODUTOS PERIGOSOS.")

	DbSelectArea("SA4")
	DbSetOrder(1)
	If SA4->(DbSeek(xFilial("SA4")+SUA->UA_TRANSP))
		Aadd(aRet, "* " + cTpFrete + " - " + SA4->A4_NOME)     
	Else
		Aadd(aRet, "* " + cTpFrete + " - ")     
	EndIf 
	Aadd(aRet, "**48 Horas para dentro da Grande SP ap�s confirma��o do pedido, demais regi�es verificar com o vendedor.")
	Aadd(aRet, "* Prezados Clientes, a pol�tica da Verquimica n�o permite o reajuste de vencimentos ap�s a emiss�o da nota fiscal,")
	Aadd(aRet, "Pedimos confirmar o vencimento das duplicatas no fechamento do pedido.")

Return aRet