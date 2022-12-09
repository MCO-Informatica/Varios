#Include "Totvs.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma: |CRPR180   ºAutor  ³Renato Ruy Bernardo º Data ³  15/02/2017 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatorio de Regras de Remuneracao.						  º±±
±±º          ³ 			                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Certisign                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CRPR180()

Local aPergs 	:= {}
Local cCodRec 	:= space(08)
Local lRet

Private aPedidos 	:= {}
Private aRet 		:= {}
Private cPedIn	:= ""
Private cPerg       := "CRP160"

//ValidPerg()
//pergunte(cPerg,.T.)  
//aAdd( aPergs ,{1 ,"Periodo " 	 	,Space(6)	,""	  ,""   ,"","" ,50,.F.})
aAdd( aPergs ,{11,"Pedidos"			,""			,'.T.','.T.',.F.})
aAdd( aPergs ,{6 ,"Gravar arquivo" 	,Space(70)	,""	  ,"","",50,.F.,"Arquivos .CSV |*.CSV"})
aAdd( aPergs ,{2 ,"Imprime"			,"Todos"	,{"Todos", "Apenas Regras"}, 50,'.T.',.T.})

If !ParamBox(aPergs ,"Parametros ",aRet)
	Alert("O relatório foi cancelado!")
	Return
EndIf

//Retira virgula caso esteja no final
aRet[1] := Iif(Substr(aRet[1] ,len(aRet[1] ),1)==",",Substr(aRet[1] ,1,len(aRet[1])-1),aRet[1])

//Cria um array para não estourar a quantidade de pedidos
aPedidos := StrToArray(aRet[1],chr(13)+chr(10))

//Renato Ruy - 27/04/2017
//Utilizara o Array para se posicionar.
//If Len(aPedidos) > 1000
//	Alert("A pesquisa por pedido apenas pode ser realizada ate 1000 pedidos!")
//	Return
//EndIf

//Formata os dados para serem utilizados na consulta.
//cPedIn := "% Z5_PEDGAR IN "+FormatIn( StrTran(aRet[2],chr(13)+chr(10),","), "," )+" AND %"

Processa( {|| U_CRPR180A() }, "Selecionando registros...")

Return

//Renato Ruy - 15/02/2017
//Arquivo central para gravacao de todos os pedidos informados ou atraves da rotina de envio.
User Function CRPR180A

Local cLin 	:= ""
Local nI	:= 0

Private cEOL    := "CHR(13)+CHR(10)"
Private cArq    := ""
Private nHdl    := 0

If Empty(cEOL)
	cEOL := CHR(13)+CHR(10)
Else
	cEOL := Trim(cEOL)
	cEOL := &cEOL
Endif

//Efetua criação do arquivo.
cArq    := AllTrim(aRet[2])
nHdl    := fCreate(cArq)

If nHdl == -1
	Alert("Não foi possível criar o arquivo no caminho informado!")
	Return	
Endif

//Cria Cabeçalho no arquivo
//Adiciono o cabeçalho para o relatório.
If nHdl != -1
	cLin := "Pedido Gar;"
	cLin += "Período;"
	cLin += "Posto;"
	cLin += "Descricao Posto;"
	cLin += "Produto;"
	cLin += "Codigo Voucher;"
	cLin += "Tipo Voucher;"
	cLin += "Valor SW;"
	cLin += "Valor HW;"
	cLin += "Projeto;"
	cLin += "Observacao"	
	cLin := cLin + cEOL
	
	//Efetuo gravação de dados do relatório em arquivo.
	fWrite(nHdl,cLin)
EndIf

//Rotina de Processamento
CRPR180Z()

//Fecha o arquivo criado
fClose(nHdl)

//Abre o excel com os dados
oExcelApp := MsExcel():New()
oExcelApp:WorkBooks:Open(aRet[2])
oExcelApp:SetVisible(.T.)

Return   

//Renato Ruy - 15/02/2017
//Levantamento de informacoes e gravacao de informacoes de problemas ou regra especifica.
Static Function CRPR180Z()

Local aRegra := {}
Local cLin   := ""
Local nLinha := 0
Local cWhere := ""
Local cWhere2:= ""
Local cCampos:= ""
Local cObs   := ""
Local nI	 := 0

//Posiciona na Ordem 1 - Filial + PedGar
SZ5->(DbSetOrder(1))

//Posiciona na Ordem 4 - Filial + Codigo Posto Gar
SZ3->(DbSetOrder(4)) 

ProcRegua(Len(aPedidos))

For nI := 1 To Len(aPedidos)
   	
   	IncProc( "Analisando regra do pedido: " +  aPedidos[nI])
	ProcessMessage() 
   	
   	lFoundZ3 := .F.
   	
   	//Se não encontrou o pedido pula
   	If !SZ5->(DbSeek(xFilial("SZ5")+aPedidos[nI]))
   		
   		cLin += aPedidos[nI] + ";"
		cLin += ";"
		cLin += ";"
		cLin += ";"
		cLin += ";"	
		cLin += ";"	
		cLin += ";"
		cLin += ";"	
		cLin += ";"
		cLin += ";"			
		cLin += "Pedido não encontrado na base do Protheus"	
		cLin += cEOL
   	
   		Loop   	
   	Endif
   	     
   	//Se não encontrou o posto pula
   	If !SZ3->(DbSeek(xFilial("SZ3")+SZ5->Z5_CODPOS))
   		lFoundZ3 := .F.
   	EndIf

   	//Verifica se as regras do produto estao corretas.
	aRegra := CRPR180Y(SZ5->Z5_PRODGAR,SZ5->Z5_VALORSW+SZ5->Z5_VALORHW)
	cObs := aRegra[2]
	
	//Verifica os pedidos que estão zerados
	If SZ5->Z5_VALORSW+SZ5->Z5_VALORHW == 0
		aRegra := CRPR180V(SZ5->Z5_PEDGAR,SZ5->Z5_CODVOU,SZ5->Z5_DESGRU)
		cObs := Iif(!Empty(cObs),cObs+" / "+aRegra[2],aRegra[2])
	EndIf
	
	//Verifica regras da entidade e do pedido.
	aRegra := CRPR180X(SZ3->Z3_CODENT,SZ3->Z3_CODCCR,SZ3->Z3_CODAC,SZ5->Z5_CODAC,SZ5->Z5_DESGRU,SZ5->Z5_PRODGAR)
	cObs   := Iif(!Empty(cObs),cObs+" / "+aRegra[2],aRegra[2])
	
	If nHdl != -1 .And. (aRet[3] == "Todos" .Or. !Empty(cObs)) 
		cLin += SZ5->Z5_PEDGAR + ";"
		cLin += Substr(Iif(Empty(SZ5->Z5_PEDGANT),DtoS(SZ5->Z5_DATVER),DtoS(SZ5->Z5_DATEMIS)),1,6) + ";"
		If lFoundZ3
			cLin += SZ3->Z3_CODENT + ";"
			cLin += SZ3->Z3_DESENT + ";"
		Else
			cLin += "--" + ";"
			cLin += "--" + ";"
		EndIf
		cLin += SZ5->Z5_PRODGAR+ ";"	
		cLin += SZ5->Z5_CODVOU + ";"	
		cLin += Iif(!Empty(SZ5->Z5_TIPVOU),Posicione("SZH",1,xFilial("SZH")+SZ5->Z5_TIPVOU,"ZH_DESCRI")," ") + ";"
		cLin += Transform(SZ5->Z5_VALORSW,"@E 999,999,999.99")+ ";"	
		cLin += Transform(SZ5->Z5_VALORHW,"@E 999,999,999.99")+ ";"
		cLin += SZ5->Z5_DESGRU + ";"			
		cLin += Iif(!Empty(cObs),cObs,"Pedido Remunerado!") + ";"	
		cLin += cEOL
		
		nLinha += 1
		
		//Efetuo gravação de dados do relatório em arquivo.
		If nLinha >= 100
			fWrite(nHdl,cLin)
			cLin   := ""
			nLinha := 0
		Endif
		
	EndIf
	
Next

If !Empty(cLin)
	//Efetuo gravação de dados do relatório em arquivo.
	fWrite(nHdl,cLin)
Endif
	
Return

//Renato Ruy - 15/02/17
//Funcao para validar produtos pagos ou nao pagos.
//Pedidos que não foram preenchidos corretamento.ç
Static Function CRPR180Y(cProduto,nValor)

Local lPosicao := .F.
Local cCategor := ""
Local aRegra   := {.T.,""}

PA8->(DbSetOrder(1))
lPosicao := PA8->(DbSeek(xFilial("PA8")+PadR(AllTrim(cProduto),32," ") ))

cCategor := Iif(lPosicao,PA8->PA8_CATPRO,"")

If SubStr(cProduto,1,3) $ "PRD/SPB/CSI" .And. (Empty(cCategor) .Or. !lPosicao)
	aRegra[1] := .F.
Elseif SubStr(cProduto,1,4) $ "CERT/IMES" .And. (Empty(cCategor) .Or. !lPosicao)
	aRegra[1] := .F.
Elseif SubStr(cProduto,1,5) == "CLASS" .And. (Empty(cCategor) .Or. !lPosicao)
	aRegra[1] := .F. 
Elseif  "BB" $ cProduto .And. (Empty(cCategor) .Or. !lPosicao)
	aRegra[1] := .F.
Elseif AllTrim(cProduto) $ "OABA3PFSCHV2/OABA3PFSCRNHV2" .And. (nValor == 77.5 .Or. nValor == 85 .Or. nValor == 72 .Or. nValor == 95)
	aRegra[2] := "O Valor do produto e zerado pela regra da OAB" 
Elseif AllTrim(cProduto) $  'SRFA3PFSCFUNCHV2/SRFA3PFSLFUNCHV2'
	aRegra[2] := "O produto é do tipo funcionário, não é comissionado"
Elseif "BV" $ cProduto
	aRegra[2] := "BV somente calcula AC"
Elseif Empty(PA8->PA8_CATPRO)
	aRegra[2] := "A categoria do produto não está preenchida"
Elseif SubStr(cProduto,1,4) == "IFEN"
	aRegra[2] := "Produto IFEN não é comprado no Checkout, o usuario deve informar o valor manualmente."
EndIf

If !aRegra[1]
	aRegra[2] := "Produto não é calculado na remuneração"
Endif

Return(aRegra)

//Renato Ruy -16/02/17
//Funcao para buscar motivo para o pedido estar sem valor
Static Function CRPR180V(xPedGar,xCodVou,xDesgru)

Local aRegra   := {.T.,""}
Local cPedGar  := xPedGar
Local cCodVou  := xCodVou
Local cPedSite := ""
Local cVouAnt  := ""
Local nValor   := 0
Local lPosicao := .F.

//Tratamento especifico para pedido zerado para o grupo PSAR
If "PSAR" $ xDesgru
	aRegra[2] := "O valor deve ser informado pelo PSAR"
Endif

//Tratamento para pedidos vinculados a voucher
If !Empty(cCodVou)
	
	SZF->(DbSetOrder(2))
	If SZF->(DbSeek(xFilial("SZF")+cCodVou))
	    
		//Vouchers que não são pagos
		If SZF->ZF_TIPOVOU$"1/3/6/7/8/G"
			aRegra[2] := "O tipo do voucher não é remunerado."
		//Voucher que o usuário devera informar o valor	
		Elseif SZF->ZF_TIPOVOU$"4/5/C/D/E"
			aRegra[2] := "O valor deve ser informado pelo PSAR"
		//Voucher que tem origem em pedido ou através de outro voucher.
		Elseif SZF->ZF_TIPOVOU$"2/A/B"
		
			cPedGar  := Iif(Val(SZF->ZF_PEDIDO)>0,AllTrim(Str(Val(SZF->ZF_PEDIDO)))," ")
			cPedSite := Iif(Val(SZF->ZF_PEDSITE)>0,AllTrim(Str(Val(SZF->ZF_PEDSITE)))," ")
			cVouAnt  := SZF->ZF_CODORIG 
			
			While (!Empty(cPedGar) .Or. !Empty(cPedSite) .Or. !Empty(cVouAnt)) .And. nValor == 0
				
				If !Empty(cPedGar)
					//Indice - Filial + Pedido Gar
					SZG->(DbSetOrder(1))
					lPosicao := SZG->(DbSeek(xFilial("SZG")+cPedGar))
                    
					If lPosicao
						//Indice - Filial + Voucher
						SZF->(DbSetOrder(2))
						lPosicao := SZF->(DbSeek(xFilial("SZF")+SZG->ZG_NUMVOUC))
					Endif
				Endif
					
				if !Empty(cPedSite) .And. !lPosicao
					//Indice - Filial + Pedido Site 
					SZG->(DbSetOrder(3))
					lPosicao := SZG->(DbSeek(xFilial("SZG")+cPedSite))	
					
					If lPosicao
						//Indice - Filial + Voucher
						SZF->(DbSetOrder(2))
						lPosicao := SZF->(DbSeek(xFilial("SZF")+SZG->ZG_NUMVOUC))
					Endif			
				Endif
				
				if !Empty(cVouAnt) .And. !lPosicao
					//Indice - Filial + Voucher
					SZF->(DbSetOrder(2))
					lPosicao := SZF->(DbSeek(xFilial("SZF")+cVouAnt))
				Endif
				
				If !lPosicao
					
					If !Empty(cPedGar)
						//Indice - Filial + Pedido Gar
						SC5->(DbSetOrder(5))
						If SC5->(DbSeek(xFilial("SC5")+cPedGar))
							nValor := SC5->C5_TOTPED
							aRegra[2]:= "O voucher tem valor no Pedido Gar anterior, deve ser importado e recalculado"
						Else
							lPosicao := .F.
						Endif
					Endif 
					
					if !Empty(cPedSite) .And. !lPosicao
						//Indice - Filial + Pedido Site
						SC5->(DbSetOrder(8))
						If SC5->(DbSeek(xFilial("SC5")+cPedSite))
							nValor := SC5->C5_TOTPED
							aRegra[2]:= "O voucher tem valor no Pedido Site anterior, deve ser importado e recalculado"
						Endif
					Endif
						
				EndIf
				
				If !lPosicao .And. nValor == 0
					cPedGar  := " "
					cPedSite := " "
					cVouAnt  := " "
					//Na estrutura algum pedido ou voucher não foi gerado corretamente.
					//A-Garatia ou 2=Substituicao de Pedido Gar - Tem um Pedido Gar ou Site no sistema
					//B-Substituicao de Voucher - Foi gerado um novo voucher, pois o voucher anterior nao consumido estava incorreto
					aRegra[2]:= "O sistema não conseguiu localizar o pedido ou voucher anterior da estrutura"
				Elseif nValor == 0 
					cPedGar  := Iif(Val(SZF->ZF_PEDIDO)>0,AllTrim(Str(Val(SZF->ZF_PEDIDO)))," ")
					cPedSite := Iif(Val(SZF->ZF_PEDSITE)>0,AllTrim(Str(Val(SZF->ZF_PEDSITE)))," ")
					cVouAnt  := SZF->ZF_CODORIG
					nValor	 := SZF->ZF_VALORSW + SZF->ZF_VALORHW
					If nValor > 0
						aRegra[2]:= "O voucher tem valor na estrutura, deve ser importado novamente e recalculado"
					Endif 
					
					//Se o voucher de origem nao e remunerado, informa o usuario.
					If SZF->ZF_TIPOVOU$"1/3/6/7/8/G"
						cPedGar  := " "
						cPedSite := " "
						cVouAnt  := " "
						aRegra[2] := "O tipo do voucher de origem não é remunerado."
					Endif
	
				Endif
				
				lPosicao := .F.		
			Enddo
						
		EndIf
	    
		
		
	Else
		aRegra[2] := "Não foi possivel localizar o voucher vinculado ao pedido"
	EndIf
	
Else
	//Indice - Filial + Pedido Gar
	SC5->(DbSetOrder(5))
	If SC5->(DbSeek(xFilial("SC5")+cPedGar))
		nValor := SC5->C5_TOTPED
		aRegra[2]:= "O pedido consta no sistema, deve ser importado e recalculado"
	Else
		
		If Select("TMPVOU") > 0
			DbSelectArea("TMPVOU")
			TMPVOU->(DbCloseArea())
		EndIf
		
		//Caso nao encontre o pedido no sistema, procura possiveis problemas na GTIN
		Beginsql Alias "TMPVOU"
		
			%NoParser%

			SELECT Max(GT_XNPSITE) PEDSITE
			FROM GTIN
			WHERE GT_ID = %Exp:cPedGar%
		
		Endsql
		
		If Empty(TMPVOU->PEDSITE)
			aRegra[2]:= "O pedido não foi comprado pelo checkout"
		Else
			//Indice - Filial + Pedido Site
			SC5->(DbSetOrder(8))
			lPosicao := SC5->(DbSeek(xFilial("SC5")+TMPVOU->PEDSITE))
			
			If !lPosicao
				//Indice - Filial + Pedido Site 
				SZG->(DbSetOrder(3))
				lPosicao := SZG->(DbSeek(xFilial("SZG")+TMPVOU->PEDSITE))					
			Endif
			
			If lPosicao
				aRegra[2]:= "O pedido consta no sistema, deve ser importado e recalculado"
			Else
				aRegra[2]:= "O pedido foi efetuado pelo checkout, porém não consta no sistema"
			Endif 
			
			
		EndIf
	Endif
EndIf


Return(aRegra)

//Renato Ruy - 17/02/2017
//Regras da entidade
//Posto tem percentual preenchido, CCR ou Projeto não remunerado.
Static Function CRPR180X(cCodEnt,cCodCCR,cAcProt,cAcGar,cProjeto,cProduto)

	Local aRegra := {.T.,""}
	Local cCatPro:= Posicione("PA8",1,xFilial("PA8")+PadR(AllTrim(cProduto),32," "),"PA8_CATPRO")
	
	//-> David.Santos - 01/03/2019 - OTRS: 2019022810003791 
	If !SZ3->(Found())
		aRegra[2] := "Posto não encontrado"
		Return( aRegra )
	EndIf

	If AllTrim(cAcGar) == "NAOREM"
		aRegra[2] := "AC Não Remunerado, não calcula o pedido para remuneração"
	Elseif "TESTE" $ UPPER(cProjeto)
		aRegra[2] := "Pedido do projeto teste não é remunerado"
	Elseif "PROJETO TOPOS" $ UPPER(cProjeto)
		aRegra[2] := "Pedido do projeto da Topos não é remunerado e vincula ao Posto Topos"
	Elseif cCodCCR == "072855" .And. "PSAR SECOVI" $ UPPER(cProjeto)
		aRegra[2] := "Pedido do projeto da PSAR SECOVI não é remunerado"
	Endif

	If Empty(cCodEnt)
		aRegra[2] := Iif(Empty(aRegra[2]),"",Regra[2]+"/")+"O posto vinculado não está cadastrado"
	Elseif Empty(cCodCCR)
		//Indice - Filial + Entidade + Categoria Produto
		SZ4->(DbSetOrder(1))
		If !SZ4->(DbSeek(xFilial("SZ4")+cCodEnt + cCatPro))
			aRegra[2] := Iif(Empty(aRegra[2]),"",aRegra[2]+"/")+"A Entidade não tem CCR e a categoria do produto vinculado não é remunerado"
		Elseif SZ4->Z4_PORSOFT+SZ4->Z4_PORHARD == 0
			aRegra[2] := Iif(Empty(aRegra[2]),"",aRegra[2]+"/")+"O parceiro não tem percentual cadastrado para o produto!"
		Endif 
	Else
		//Indice - Filial + Entidade + Categoria Produto
		SZ4->(DbSetOrder(1))
		If !SZ4->(DbSeek(xFilial("SZ4")+cCodCCR + cCatPro))
			aRegra[2] := Iif(Empty(aRegra[2]),"",aRegra[2]+"/")+"O CCR vinculado a entidade não remunera a categoria do produto"
		Elseif SZ4->Z4_PORSOFT+SZ4->Z4_PORHARD == 0
			aRegra[2] := Iif(Empty(aRegra[2]),"",aRegra[2]+"/")+"O parceiro não tem percentual cadastrado para o produto!"
		Endif
	Endif

	If "REG" $ cProduto .And. !("SERVEREG" $ SZ5->Z5_PRODGAR)
		cAcProt := Padr("BR",6," ")
	ElseIf "NOT" $ cProduto
		cAcProt := Padr("NOT",6," ")
	ElseIf "SINRJ" $ cProduto
		cAcProt := Padr("SINRJ",6," ")
	ElseIf  "SIN" $ cProduto
		cAcProt := Padr("SIN",6," ")
	EndIf 

	If "IFEN" $ cProduto
		aRegra[2] := Iif(Empty(aRegra[2]),"",aRegra[2]+"/")+"Somente o Canal CA0009 sera atribuido para receber do instituto fenacon"
	EndIf

	If Empty(cAcProt)
		aRegra[2] := Iif(Empty(aRegra[2]),"",aRegra[2]+"/")+"O posto não tem AC vinculada"
	Else
		//Indice - Filial + Entidade + Categoria Produto
		SZ4->(DbSetOrder(1))
		If !SZ4->(DbSeek(xFilial("SZ4")+cAcProt + cCatPro))
			aRegra[2] := Iif(Empty(aRegra[2]),"",aRegra[2]+"/")+"A AC não remunera o produto desta categoria"
		Elseif SZ4->Z4_PORSOFT+SZ4->Z4_PORHARD == 0
			aRegra[2] := Iif(Empty(aRegra[2]),"",aRegra[2]+"/")+"A AC não tem percentual cadastrado para o produto!"
		Endif
	Endif

Return( aRegra )