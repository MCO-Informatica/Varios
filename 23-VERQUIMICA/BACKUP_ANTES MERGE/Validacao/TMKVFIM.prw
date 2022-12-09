#Include "Protheus.Ch"

/*
===================================================================================
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+--------------------+--------------------------------+-----------------------+||
||| Programa: TMKVFIM  | Autor: Celso Ferrone Martins   | Data: 06/08/2014 	  |||
||+-----------+--------+--------------------------------+-----------------------+||
||| Descricao | PE Apos a gravacao so Pedido de Vendas - SC5 / SC6         	  |||
||+-----------+-----------------------------------------------------------------+||
||| Alterado Por:| Danilo Alves Del Busso 				|Data: 30/07/2015 		  |||  
||| Descriação:	 | Alterado valor SC5->C5_BLQ := "2" para SC5->C5_BLQ := "1"  |||
||+-----------+-----------------------------------------------------------------+||
||| Uso       |                                                            	  |||
||+-----------+-----------------------------------------------------------------+||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
===================================================================================
*/

User Function TMKVFIM(cSuaNum,cSc5Num)

Local aAreaSC5 := SC5->(GetArea())
Local aAreaSC6 := SC6->(GetArea())
Local aAreaSUA := SUA->(GetArea())
Local aAreaSUB := SUB->(GetArea())
Local aAreaSB1 := SB1->(GetArea())
Local cEspecie := ""
Local dDtEntVq := cTod("")
Local _lBlq	   := .F. 
Local _lTabA    :=.T. //Cassio Lima 18/10/2016 validar se os itens do orcamento nao sao tabela A
Local _nTotal  :=0   //Cassio Lima 18/10/2016 total do pedido 
Local _aCmpDup :={}  //Cassio Lima 18/10/2016  Array contendo os campos necessarios para validar as duplicadas     
Local _cMotivo :="" //Cassio Lima 18/10/2016   CODIGO DO MOTIVO DO BLOQUEIO
Local _lBloq    := .F.  //Cassio Lima 18/10/2016 Variavel para controlar o bloqueio    
Local _cBlq    :="" // Cassio Lima 18/10/2016     para controlar o tipo do bloqueio 1 = regra 2 credito      
Local _aItem   :={}//Cassio Lima 18/10/2016 gravar itens no array            
Local nValMin:=SUPERGETMV("MV_XVALDUP",.F.,600)  
Local nQtdMin:=SUPERGETMV("MV_XQTDMIN",.F.,100)  
Local cEol     := CHR(13)+CHR(10)
Local lVerS:=.f.
Local nQtMax	:= 0
AjustaSx6()

DbSelectArea("SC5") ; DbSetOrder(1)	// Pedido De Vendas - Itens
DbSelectArea("SC6") ; DbSetOrder(1)	// Pedido De Vendas - Itens
DbSelectArea("SUA") ; DbSetOrder(1)	// CallCenter - Cabecalho
DbSelectArea("SUB") ; DbSetOrder(1)	// CallCenter - Itens

If SUA->(DbSeek(xFilial("SUA")+cSuaNum))
	If SUA->UA_OPER == "1"
		SUB->(DbSeek(xFilial("SUB")+cSuaNum))
		lTemEmRe:=.f.
		While !SUB->(Eof()) .And. SUB->(UB_FILIAL+UB_NUM) == xFilial("SUB")+cSuaNum
			Sb1->(DbSeek( xFilial("SB1")+Sub->Ub_Produto )) //MHS
			If SC6->(DbSeek(xFilial("SC6")+SUB->(UB_NUMPV + UB_ITEMPV)))
				SB1->(DbSeek(xFilial("SB1")+SUB->UB_VQ_EM))
				lVerS:=If(Sb1->B1_Vq_VerS="S", .t., lVerS)
				nPosEsp := At(" ",SB1->B1_DESC)
				If Empty(cEspecie)
					cEspecie := AllTrim(SubStr(SB1->B1_DESC,1,nPosEsp-1))
				Else
					If AllTrim(cEspecie) != AllTrim(SubStr(SB1->B1_DESC,1,nPosEsp-1))
						cEspecie := "DIVERSOS"
					EndIf
				EndIf
				If Empty(dDtEntVq)
					dDtEntVq := SC6->C6_ENTREG
				Else
					If dDtEntVq > SC6->C6_ENTREG
						dDtEntVq := SC6->C6_ENTREG
					EndIf
				EndIf
				RecLock("SC6",.F.)
				SC6->C6_VQ_CAPA := SUB->UB_VQ_CAPA // Capacidade
				SC6->C6_VQ_DENS := SUB->UB_VQ_DENS // Densidade
				SC6->C6_VQ_TABE := SUB->UB_VQ_TABE // Tabela
				SC6->C6_VQ_UM   := SUB->UB_VQ_UM   // Volume
				SC6->C6_VQ_MOED := SUB->UB_VQ_MOED // Moeda
				SC6->C6_VQ_QTDE := SUB->UB_VQ_QTDE // Qtde. Orcam.
				SC6->C6_VQ_UNIT := SUB->UB_VQ_VRUN // Vlr.Unit Orc
				SC6->C6_VQ_TOTA := SUB->UB_VQ_VLRI // Total Orcam.
				SC6->C6_VQ_VAL  := SUB->UB_VQ_VAL  // Preco Verq.
				SC6->C6_VQ_MARK := SUB->UB_VQ_MARK // MarkUp
				SC6->C6_VQ_MP   := SUB->UB_VQ_MP   // Mat. Prima
				SC6->C6_VQ_EM   := SUB->UB_VQ_EM   // Embalagem
				SC6->C6_VQ_TEMT := SUB->UB_VQ_TEMT // Tab.Prc
				SC6->C6_VQ_TAX2 := SUB->UB_VQ_TAX2 // Taxa Utilizada na M2
				SC6->C6_VQ_VOLU := SUB->UB_VQ_VOLU // VOLUME
				SC6->C6_COMIS1  := GetMv("VQ_COMIST"+SUB->UB_VQ_TABE)  
				SC6->C6_VQCPCLI := SUB->UB_VQCPCLI		//Danilo Busso 17/08/2016 -- codigo do produto do cliente que vai na DANFE
				SC6->C6_VQ_PICM := SUB->UB_VQ_PICM
				SC6->C6_VQ_PPIS := SUB->UB_VQ_PPIS
				SC6->C6_VQ_PCOF := SUB->UB_VQ_PCOF  
				_nTotal+=SUB->UB_VQ_VLRI     
				AADD(_aItem,{SUB->UB_ITEMPV,SC6->C6_PRODUTO,SC6->C6_UM,SC6->C6_QTDVEN,;
					SC6->C6_PRCVEN,SC6->C6_VALOR,Alltrim(SUB->UB_VQ_TABE),SUB->UB_VQ_EM,SUA->UA_TPFRETE})
				IF !Alltrim(SUB->UB_VQ_TABE) $ "A"  //SUB->UB_VQ_VRUN >=SUB->UB_VQ_PR_A  
			   		_lTabA    :=.F. //Cassio Lima 18/10/2016 validar se os itens do orcamento nao sao tabela A

 				EndIF       
 			
				SC6->(MsUnLock())

			EndIf
			//
			//Tratativa para não bloquear pedidos que não geram duplicata - Nelson Junior | ARMI | 13/01/2015
			//
			If AllTrim(Posicione("SF4",1,xFilial("SF4")+SC6->C6_TES,"F4_DUPLIC")) == "N"
				_lBlq := .T.
			   _cBlq  :="1" //Alterado para 1 por Danilo Alves Del Busso - 30/07/2015    
			   _cMotivo+="00|" //  não bloquear pedidos que não geram duplicata - Nelson Junior      

			EndIf
			//

			If !u_MHSVlVis(Sub->Ub_Produto, Sub->Ub_Quant, Sub->Ub_VQ_Um, @nQtMax ) // MHS
				_lBlq := .T.
				_cBlq  :="1" 
				If At("90|", _cMotivo)=0 
					_cMotivo+="90|" // Produto com quantidade de venda controlada, cliente sem visita as instalações limitado ao max permitido.

				EndIf

			EndIf


			If Sua->Ua_VQ_FVer = "N" .And. Sua->Ua_VQ_Fret = "V" .And. Sa4->A4_VQ_VerQ <> "S"
				_lBlq := .T.
				_cBlq  :="1" 
				If At("87|", _cMotivo)=0 
					_cMotivo+="87|" // "Tipo de Frete Inválido ! Cidade da entrega nao antedida pela transportadora da casa!"

				Endif

			EndIf

			If Sua->Ua_VQ_FVer = "N" .And. Sua->Ua_VQ_Fret = "V" .And. Sa4->A4_VQ_VerQ = "S"
				If !Empty(Sa1->A1_CodMunE) .And. !Empty(Sa1->A1_EstE)
					Z17->(DbSeek( xFilial("Z17")+Sa4->A4_Cod+Sa1->(A1_EstE+A1_CodMunE) ))
	
				Else
					Z17->(DbSeek( xFilial("Z17")+Sa4->A4_Cod+Sa1->(A1_Est+A1_Cod_Mun) ))
	
				EndIf
	
				If Z17->(Eof())
					_lBlq := .T.
					_cBlq  :="1" 
					If At("88|", _cMotivo)=0 
						_cMotivo+="88|" // "Tipo de Frete Inválido ! Cidade da entrega nao antedida pela transportadora da casa!"

					Endif

				EndIf
	
			EndIf

			If U_EmbRecup(Sub->Ub_Produto) // MHS
				lTemEmRe:=.t.

			EndIf

			If Sb1->B1_Vq_VEsp="1" // MHS
				_lBlq := .T.
				_cBlq  :="1" 
				If At("VE|", _cMotivo)=0
					_cMotivo+="VE|" // Venda Especial conforme regras de negocio Linhs 17 N.

				EndIf

			EndIf

			If Sub->Ub_VQ_VRUN<Sub->Ub_VQ_Pr_D
				_lBlq := .T.
				_cBlq  :="1" 
				If At("VD|", _cMotivo)=0
					_cMotivo+="VD|" // Valor Menor que Tabela D

				EndIf

			EndIf

			SUB->(DbSkip())

		EndDo

		If SC5->(DbSeek(xFilial("SC5")+SUA->UA_NUMSC5))
			_lDevCom := If(AllTrim(SC5->C5_TIPO) == "D", .T., .F.)
			RecLock("SC5",.F.)
				SC5->C5_ESPECI1 := cEspecie
				SC5->C5_VOLUME1 := SUA->UA_VQ_QEMB
				SC5->C5_PESOL   := SUA->UA_PESOL
				SC5->C5_PBRUTO  := SUA->UA_PESOB
				SC5->C5_VQ_FRET := SUA->UA_VQ_FRET
				SC5->C5_VQ_FCLI := SUA->UA_VQ_FCLI
				SC5->C5_VQ_FVER := SUA->UA_VQ_FVER
				SC5->C5_VQ_FVAL := SUA->UA_VQ_FVAL
				SC5->C5_VQ_TPCO := SUA->UA_VQ_TPCO
				SC5->C5_MENNOTA := SUA->UA_MENNOTA
				SC5->C5_MENNOT1 := SUA->UA_MENNOT1
				SC5->C5_MENNOT2 := SUA->UA_MENNOT2
				SC5->C5_MENNOT3 := SUA->UA_MENNOT3
				SC5->C5_MENPAD  := SUA->UA_MENPAD
			
// Validar cadastro do cliente, com relação a Atividade comercial com VerQuimica - MHS 
				If Empty(Sa1->A1_UltCom)
					_cBlq  :="1" //Alterado para 1 por Danilo Alves Del Busso - 30/07/2015
					If At("ZZ|", _cMotivo)=0 
						_cMotivo+="ZZ|" //00|Cliente Novo" // Valor minimo por duplicatas nao atende aos requisitos da regra comercial

					EndIf

					_lBlq:=.T.

		        ElseIf ((dDataBase-Sa1->A1_UltCom)/30)>3 // MHS - 11/11/16
					_cBlq  :="1" //Alterado para 1 por Danilo Alves Del Busso - 30/07/2015
					If At("Z1|", _cMotivo)=0 
						_cMotivo+="Z1|" //Data Ultima Compra" // Valor minimo por duplicatas nao atende aos requisitos da regra comercial

					EndIf

					_lBlq:=.T.

		        EndIf

// validar Valor Minimo por duplicata - MHS
				nRecSL4:=Sl4->(RecNo())
				lVlMinD:=.t.
 				Sl4->(DbSeek(xFilial("SL4")+Sua->Ua_Num+"SIGATMK"))
				While !Sl4->(Eof()) .And. Sl4->(L4_Num+L4_Origem)=Sua->Ua_Num+"SIGATMK" .And. Sl4->L4_Filial=xFilial("SL4")
					If Sl4->L4_Valor<(nValMin*If(Sub->Ub_VQ_Moed="2", Posicione("SM2", 1, Dtos(dDataBase), "M2_MOEDA2"), 1))
						lVlMinD:=.f.

					EndIf

					Sl4->(DbSkip())

				EndDo

				Sl4->(DbGoTo(nRecSL4))
				IF !lVlMinD     //(_nTotal / nValMin )<=1   // Se for menor que 600 valida
					AADD(_aCmpDup,{SUA->UA_CONDPG,_lTabA,SUA->UA_VQ_FRETE,SUA->UA_VQ_FCLI,SC5->C5_EMISSAO,_nTotal}) //Cassio Lima 18/10/2016 DADOS PARA VALIDAR O PEDIDO POR DUPLICATAS
					IF !VldDupli(_aCmpDup)  //Cassio Lima 18/10/2016 validar valor minimo por duplicatas
						_cBlq  :="1" //Alterado para 1 por Danilo Alves Del Busso - 30/07/2015
						If At("01|", _cMotivo)=0 
							_cMotivo+="01|" //Vlr Min. por Dupl" // Valor minimo por duplicatas nao atende aos requisitos da regra comercial

						EndIf

						_lBlq:=.T.

					Else // Se as condicoes  A Vista, cliente retira estiverem corretas valida preco
						For nI:= 1 to len(_aItem)
							IF _aItem[nI][4]<= nQtdMin //Valida quantidade minima por item
								if  !VldPrc(_aItem[nI][5],_aItem[nI][7])  //Validar Prc Minimo  3 dolares ou Superior Cassio Lima 19/10/2016
									_lBloq:=.T.
									If At("02|", _cMotivo)=0 
										_cMotivo+="02|" //Preco Minimo" //Preco minimo nao permitido

									EndIf

								Else // Validar bombonas
									_aRetBom:=U_VldBomb(_aItem[nI][2],_aItem[nI][7],_aItem[nI][4],nQtdMin,_aItem[nI][9])
									IF !_aRetBom[1]
										_cBlq  :="1" //Alterado para 1 por Danilo Alves Del Busso - 30/07/2015
										_cMotivo+=_aRetBom[2]

									EndIF

									_aRetTambor:=U_VldTambor(_aItem[nI][2],_aItem[nI][7],_aItem[nI][4],nQtdMin,_aItem[nI][9], nI)
									IF !_aRetTambor[1]
										_cBlq  :="1" //Alterado para 1 por Danilo Alves Del Busso - 30/07/2015
										_cMotivo+=_aRetTambor[2]

									EndIF

								EndIF

							Else // Se a quantidade for maior que a minima validar tabela de preco
								IF !_aItem[nI][7] $ "A|B|C"    // So pode vender acima da tabela D
									_lBloq:=.T.
									_cMotivo+="03|" //Preco Abaixo Tabela" // Produto com valor minimo por duplicata e Preco abaixo das tabelas permitidas

								Else // Validar bombonas
									_aRetBom:=U_VldBomb(_aItem[nI][2],_aItem[nI][7],_aItem[nI][4],nQtdMin,_aItem[nI][9])
									IF !_aRetBom[1]
										_cBlq  :="1" //Alterado para 1 por Danilo Alves Del Busso - 30/07/2015
										_cMotivo+=_aRetBom[2]

									EndIF

									_aRetTambor:=U_VldTambor(_aItem[nI][2],_aItem[nI][7],_aItem[nI][4],nQtdMin,_aItem[nI][9], nI)
									IF !_aRetTambor[1]
										_cBlq  :="1" //Alterado para 1 por Danilo Alves Del Busso - 30/07/2015
										_cMotivo+=_aRetTambor[2]

									EndIF

								EndIF

							EndIF

						Next nI

					EndIF

				Else // Valores por duplicatas maiores que 600,00
					For nI:= 1 to len(_aItem)
						IF _aItem[nI][4]<= nQtdMin //Valida quantidade minima por item
							if  !VldPrc(_aItem[nI][5],_aItem[nI][7])  //Validar Prc Minimo  3 dolares ou Superior Cassio Lima 19/10/2016
								_lBloq:=.T.
								_cMotivo+="02|" //Preco Minimo" //Preco minimo nao permitido

							Else // Validar bombonas
								_aRetBom:=U_VldBomb(_aItem[nI][8],_aItem[nI][7],_aItem[nI][4],nQtdMin,_aItem[nI][9])
								IF !_aRetBom[1]
									_cBlq  :="1" //Alterado para 1 por Danilo Alves Del Busso - 30/07/2015
									_cMotivo+=_aRetBom[2]

								EndIF

								_aRetTambor:=U_VldTambor(_aItem[nI][2],_aItem[nI][7],_aItem[nI][4],nQtdMin,_aItem[nI][9], nI)
								IF !_aRetTambor[1]
									_cBlq  :="1" //Alterado para 1 por Danilo Alves Del Busso - 30/07/2015
									_cMotivo+=_aRetTambor[2]

								EndIF

							EndIF

						Else // Se a quantidade for maior que a minima validar tabela de preco
							IF !_aItem[nI][7] $ "A|B|C"    // So pode vender acima da tabela D
								_lBloq:=.T.
								_cMotivo+="03|" //Preco Abaixo Tabela" // Produto com valor minimo por duplicata e Preco abaixo das tabelas permitidas

							Else // Validar bombonas
								_aRetBom:=U_VldBomb(_aItem[nI][8],_aItem[nI][7],_aItem[nI][4],nQtdMin,_aItem[nI][9])
								IF !_aRetBom[1]
									_cBlq  :="1" //Alterado para 1 por Danilo Alves Del Busso - 30/07/2015
									_cMotivo+=_aRetBom[2]

								EndIF

								_aRetTambor:=U_VldTambor(_aItem[nI][2],_aItem[nI][7],_aItem[nI][4],nQtdMin,_aItem[nI][9], nI)
								IF !_aRetTambor[1]
									_cBlq  :="1" //Alterado para 1 por Danilo Alves Del Busso - 30/07/2015
									_cMotivo+=_aRetTambor[2]

								EndIF

							EndIF

						EndIF

					Next nI

				EndIF	

				If (_lBlq .And. !_lDevCom) .Or. (_lBloq    .And. !_lDevCom )
			 		SC5->C5_BLQ   := _cBlq    //Conteudo do tipo do bloqueio Cassio Lima - 19/10/2016     
			 		SC5->C5_VQ_MOT:=_cMotivo  // Motivo(s) do Bloqueio    

			 	Else
			 		SC5->C5_BLQ   :=""    //Conteudo do tipo do bloqueio Cassio Lima - 19/10/2016     
			 		SC5->C5_VQ_MOT:=""  // Motivo(s) do Bloqueio    

				EndIf

				If lVerS
					Sc5->C5_Blq:="1"
					Sc5->C5_Vq_Mot:=AllTrim(Sc5->C5_Vq_Mot)+"99|" // - Pedido Contendo Versolve
				
				EndIf
		  
				If Sua->Ua_Vq_Amos="S"
					Sc5->C5_Blq:="1"
					Sc5->C5_Vq_Mot:=AllTrim(Sc5->C5_Vq_Mot)+"98|" // - Pedido de Amostra
				
				EndIf
		  
				If U_DCVendNeg(Sua->Ua_Vend)
					Sc5->C5_Blq:="1"
					Sc5->C5_Vq_Mot:=AllTrim(Sc5->C5_Vq_Mot)+"97|" // - Debito/Credito Vendedor Negativo

				EndIf

				If Posicione("SE4", 1, xFilial("SE4")+Sua->Ua_CondPg, "E4_CTRADT" )="1"
					Sc5->C5_Blq:="1" 
					If At("96|", Sc5->C5_Vq_Mot)=0
						Sc5->C5_Vq_Mot:=AllTrim(Sc5->C5_Vq_Mot)+"96|" // - Pagamento antecipado, solicitar emissao do sintegra

					EndIf

				EndIf

				If lTemEmRe
					Sc5->C5_Blq:="1"
					Sc5->C5_Vq_Mot:=AllTrim(Sc5->C5_Vq_Mot)+"95|" // - PRODUTO COM EMBALAGEM RECUPERADA !

				EndIf
	
				If Sua->Ua_Vend $ GetMv("MV_VQ_BLVEN")
					Sc5->C5_Blq:="1"
					Sc5->C5_Vq_Mot:=AllTrim(Sc5->C5_Vq_Mot)+"VB|" // - Vendedor Bloquado (todos os pediso deverão ser bloqueados !

				EndIf

				SC5->C5_VQ_USL1 := ""
				SC5->C5_VQ_DTL1 := ctod("  /  /  ")
				SC5->C5_VQ_HRL1 := ""		
				SC5->C5_VQ_USL2 := ""
				SC5->C5_VQ_DTL2 := ctod("  /  /  ")
				SC5->C5_VQ_HRL2 := ""
				SC5->C5_ENTREG  := dDtEntVq

			SC5->(MsUnLock())

		EndIf

	EndIf

EndIf

SC5->(RestArea(aAreaSC5))
SC6->(RestArea(aAreaSC6))
SUA->(RestArea(aAreaSUA))
SUB->(RestArea(aAreaSUB))
SB1->(RestArea(aAreaSB1))

Return Nil


/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+---------------------+-------------------------------+------------------+||
||| Programa: AjustaSx6 | Autor: Celso Ferrone Martins  | Data: 30/07/2014 |||
||+-----------+---------+-------------------------------+------------------+||
||| Descricao | Ajuste de Parametros SX6                                   |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/

Static Function AjustaSx6()

Local aSx6Var := {}

Aadd(aSx6Var,{"VQ_COMISTA","N","Comissao vendedor tabela A","","TMKVFIM.PRW","0.75"})
Aadd(aSx6Var,{"VQ_COMISTB","N","Comissao vendedor tabela B","","TMKVFIM.PRW","0.50"})
Aadd(aSx6Var,{"VQ_COMISTC","N","Comissao vendedor tabela C","","TMKVFIM.PRW","0.35"})
Aadd(aSx6Var,{"VQ_COMISTD","N","Comissao vendedor tabela D","","TMKVFIM.PRW","0.20"})
Aadd(aSx6Var,{"VQ_COMISTE","N","Comissao vendedor tabela E","","TMKVFIM.PRW","0.00"})

DbSelectArea("SX6") ; DbSetOrder(1)

For nX := 1 to Len(aSx6Var)
	If !SX6->(DbSeek(Space(2) + aSx6Var[nX][1]))
		If !SX6->(DbSeek( cFilAnt + aSx6Var[nX][1]))
			RecLock("SX6",.T.)
			SX6->X6_FIL     := cFilAnt
			SX6->X6_VAR     := aSx6Var[nX][1]
			SX6->X6_TIPO    := aSx6Var[nX][2]
			SX6->X6_DESCRIC := aSx6Var[nX][3]
			SX6->X6_DSCSPA  := aSx6Var[nX][3]
			SX6->X6_DSCENG  := aSx6Var[nX][3]
			SX6->X6_DESC1   := aSx6Var[nX][4]
			SX6->X6_DSCSPA1 := aSx6Var[nX][4]
			SX6->X6_DSCENG1 := aSx6Var[nX][4]
			SX6->X6_DESC2   := aSx6Var[nX][5]
			SX6->X6_DSCSPA2 := aSx6Var[nX][5]
			SX6->X6_DSCENG2 := aSx6Var[nX][5]
			SX6->X6_CONTEUD := aSx6Var[nX][6]
			SX6->X6_PROPRI  := "U"
			SX6->X6_PYME    := "N"
			MsUnlock()
		EndIf
	EndIf
Next

Return()
/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+---------------------+-------------------------------+------------------+||
||| Programa: VldDupli | Autor: Cassio Menabue Lima       | Data: 18/10/2016|||
||+-----------+---------+-------------------------------+------------------+||
||| Descricao |Validar se os valores por duplicadas sao superiores a 600,00|||   
|||           |      						                               |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/              

Static Function VldDupli(_aCampos)  

/*
  [1]=>Condicao Pgto
  [2]=>TABELA PRECO A?
  [3]=>RESP. RETIRADA
  [4]=>TIPO RETIRADA 
  [5]=>DATA EMISSAO  
  [6]=>TOTAL PEDIDO
*/
Local lRet:=.F. // .F. quantidade nao permitida, .T. quantidade permitida
Local aParc := Condicao(_aCampos[1][6],_aCampos[1][1],,_aCampos[1][5])  
Local nValMin:=SUPERGETMV("MV_XVALDUP",.F.,600)  
IF Alltrim(_aCampos[1][1])=="001" .And. _aCampos[1][2]  .And. _aCampos[1][3]=="C" .And.   _aCampos[1][4] ="R" 
	lRet:=.T.

EndIF

Return lRet
/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+---------------------+-------------------------------+------------------+||
||| Programa: VldPrc      | Autor: Cassio Menabue Lima   | Data: 18/10/2016|||
||+-----------+---------+-------------------------------+------------------+||
||| Descricao |Validar se os preco unitario e maior que 3 dolares          |||   
|||           | e a tabela de preco e maior ou igual a D				   |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/              

Static Function VldPrc(_nPreco,_cTab)  

Local lRet:=.F. // .F. quantidade nao permitida, .T. quantidade permitida
IF _nPreco >= Sb1->B1_VQ_PRMI .And. _cTab $ "A|B|C|D"
	lRet:=.T.

EndIF

Return lRet 

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+---------------------+-------------------------------+------------------+||
||| Programa: VldQtd      | Autor: Cassio Menabue Lima   | Data: 18/10/2016|||
||+-----------+---------+-------------------------------+------------------+||
||| Descricao |Validar a Quantide minima por tonel                         |||   
|||           |                                             			   |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/              

Static Function VldQtd(_nQtd,_cTab)  

Local lRet:=.F. // .F. quantidade nao permitida, .T. quantidade permitida

IF _nQtd <= nQtdMin .And. _cTab $ "A|B|C|D"
	lRet:=.T.
EndIF

Return lRet   

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+---------------------+-------------------------------+------------------+||
||| Programa: VldBomb      | Autor: Cassio Menabue Lima   | Data: 18/10/2016|||
||+-----------+---------+-------------------------------+------------------+||
||| Descricao |Validar se o produto é bombonas                             |||   
|||           |                                             			   |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/              

User Function VldBomb(_cProd,_cTab,_nQtd,nQtdMin,cFrete)  
Local aRet:={.F.,""} // .F. quantidade nao permitida, .T. quantidade permitida  
Local cGrupoPA:=""    
Local cProdEMB :=""
Local nRecSb1:=Sb1->(RecNo())
Local nOrdSb1:=Sb1->(IndexOrd())
Local nRecSbm:=Sbm->(RecNo())
Local nOrdSbm:=Sbm->(IndexOrd())
Local cArea:=Alias()
Local nOrder:=IndexOrd()
Local nRecNo:=RecNo()
Local nXX:=1
DbSelectArea ("SB1");SB1->(DbGoTop())  ;DbSetOrder(1)
IF SB1->(DbSeek(xFilial("SB1")+_cProd))  
 cGrupoPA:=SB1->B1_GRUPO
 cProdEMB:=SB1->B1_VQ_EM
 DbSelectArea ("SBM");SBM->(DbGoTop())  ;DbSetOrder(1)
	IF SBM->(DbSeek(xFilial("SBM")+cGrupoPA))  
     DbSelectArea ("SB1");SB1->(DbGoTop())  ;DbSetOrder(1)
	 SB1->(DbSeek(xFilial("SB1")+cProdEMB))  
//		IF  "BOMBONA" $ SB1->B1_DESC 
		If SubStr(Sb1->B1_COD, 3, 3) >= '400' .And. SubStr(Sb1->B1_Cod, 3, 3)<='499' 
			IF SBM->BM_VQ_CATP == "1"      // 1 = ACIDOS ACETICOS ETC
//				IF  !_cTab $ "A|B|C|D"      // Se for bombona E acido E a tabela for diferente de  D a A
				IF  Sub->Ub_VQ_VrUn<Sub->Ub_VQ_Pr_D   // Se for bombona E acido E a tabela for diferente de  D a A
					aRet[2]:="07|" //  Produto bombona acidos E  Tabela de preco fora das permitidas

				Else
					IF  _nQtd < nQtdMin
						IF cFrete $ "F"
							aRet[1]:=.T.

						Else
							aRet[2]:="08|" //  Produto bombona  acidos e  tipo frete tem que ser FOB

						EndIF  

					Else // quantidade minima nao ultrapassada pedido liberado
						aRet[1]:=.T.

					EndIF

				EndIF

			Else //Se nao for os acidos validar tabela preco
				IF  _cTab $ "A"
					IF  _nQtd < nQtdMin
						IF cFrete $ "F"
							aRet[1]:=.T.

						Else
							aRet[2]:="06|" //  Produto bombona  nao incluido nos acidos e  tipo frete tem que ser FOB

						EndIF 

					 Else // quantidade minima nao ultrapassada pedido liberado
					 	aRet[1]:=.T.

					EndIF

				Else
					aRet[2]:="05|" //  Produto bombona  nao incluido nos acidos e tabela de preco nao permitida

				EndIF

			EndIF

		EndIf

	EndIF

EndIF 

Sb1->(DbSetOrder(nOrdSb1))
Sb1->(DbGoTo(nRecSb1))

Sbm->(DbSetOrder(nOrdSbm))
Sbm->(DbGoTo(nRecSbm))

DbSelectArea(cArea)     
DbSetOrder(nOrder)
DbGoTo(nRecNo)

Return aRet                                                                            

/***********************************************************/
User Function VldTambor(_cProd,_cTab,_nQtd,nQtdMin,cFrete, nL)  
/***********************************************************/
Local aRet:={.F.,""} // .F. quantidade nao permitida, .T. quantidade permitida  
Local cGrupoPA:=""    
Local cProdEMB :=""
Local nRecSb1:=Sb1->(RecNo())
Local nOrdSb1:=Sb1->(IndexOrd())
Local nRecSbm:=Sbm->(RecNo())
Local nOrdSbm:=Sbm->(IndexOrd())
Local cArea:=Alias()
Local nOrder:=IndexOrd()
Local nRecNo:=RecNo()
Local nXX:=1
Local nVlMin:=0
// B1_VQ_ECAP = CAPACIDADE DA EMBALAGEM EM LITROS
DbSelectArea ("SB1");SB1->(DbGoTop())  ;DbSetOrder(1)
IF SB1->(DbSeek(xFilial("SB1")+_cProd))  
	nVlMin:=Sb1->B1_VQ_PrMi
	cGrupoPA:=SB1->B1_GRUPO
	cProdEMB:=SB1->B1_VQ_EM
	DbSelectArea ("SBM");SBM->(DbGoTop())  ;DbSetOrder(1)
	IF SBM->(DbSeek(xFilial("SBM")+cGrupoPA))  
		DbSelectArea ("SB1");SB1->(DbGoTop())  ;DbSetOrder(1)
		SB1->(DbSeek(xFilial("SB1")+cProdEMB))  
//		IF  "TAMBOR" $ SB1->B1_DESC         
		IF SubStr( Sb1->B1_COD, 3, 3 )>='100' .And.  SubStr( Sb1->B1_COD, 3, 3 )<='399' 
			If ProcName(1)="U_CFMPENDENCIA"
				If m->Ua_Vq_QEmb=1
					If aCols[nL][aScan(aHeader, {|Z| AllTrim(Z[2])=="UB_VQ_VRUN"})]<aCols[nL][aScan(aHeader, {|Z| AllTrim(Z[2])=="UB_VQ_PR_C"})] .And. ;
					aCols[nL][aScan(aHeader, {|Z| AllTrim(Z[2])=="UB_VQ_PR_D"})]<;
					(If(aCols[nL][aScan(aHeader, {|Z| AllTrim(Z[2])=="UB_VQ_MOED"})]="2", 1, Posicione("SM2", 1, Dtos(dDataBase), "M2_MOEDA2" ))*nVlMin)
//					Sub->Ub_VQ_VrUn<Sub->Ub_VQ_Pr_C .And. Sub->Ub_VQ_Pr_D < (If(Sub->Ub_VQ_Moed="2", 1, Posicione("SM2", 1, Dtos(dDataBase), "M2_MOEDA2" ))*nVlMin)
						aRet[1]:=.f.
						aRet[2]:="70|" //  Produto Tambor Qtd 1 Tabela de preco fora das permitidas
	
					Else
						aRet[1]:=.t.
	
					EndIf
	
	            Else
					aRet[1]:=.t.
	
				EndIf

			Else // U_TMKVFIM
				If Sua->Ua_Vq_QEmb=1
					If Sub->Ub_VQ_VrUn<Sub->Ub_VQ_Pr_C .And. Sub->Ub_VQ_Pr_D < (If(Sub->Ub_VQ_Moed="2", 1, Posicione("SM2", 1, Dtos(dDataBase), "M2_MOEDA2" ))*nVlMin)
						aRet[1]:=.f.
						aRet[2]:="70|" //  Produto Tambor Qtd 1 Tabela de preco fora das permitidas
	
					Else
						aRet[1]:=.t.
	
					EndIf
	
	            Else
					aRet[1]:=.t.
	
				EndIf

            EndIf

        Else
			aRet[1]:=.t.

		EndIf

	EndIF

EndIF 

Sb1->(DbSetOrder(nOrdSb1))
Sb1->(DbGoTo(nRecSb1))

Sbm->(DbSetOrder(nOrdSbm))
Sbm->(DbGoTo(nRecSbm))
If !Empty(cArea)
	DbSelectArea(cArea)     
	DbSetOrder(nOrder)
	DbGoTo(nRecNo)

EndIf

Return aRet                                                                            
    
/*
					IF  _nQtd < nQtdMin
						IF cFrete $ "F"
							aRet[1]:=.T.
						Else
							aRet[2]:="08|" //  Produto bombona  acidos e  tipo frete tem que ser FOB
						EndIF  
					Else // quantidade minima nao ultrapassada pedido liberado
						aRet[1]:=.T.
					EndIF
				EndIF



			Else //Se nao for os acidos validar tabela preco
				IF  _cTab $ "A"
					IF  _nQtd < nQtdMin
						IF cFrete $ "F"
							aRet[1]:=.T.
						Else
							aRet[2]:="06|" //  Produto bombona  nao incluido nos acidos e  tipo frete tem que ser FOB
						EndIF 
					 Else // quantidade minima nao ultrapassada pedido liberado
					 	aRet[1]:=.T.
					EndIF
				Else
					aRet[2]:="05|" //  Produto bombona  nao incluido nos acidos e tabela de preco nao permitida
				EndIF
			EndIF
		EndIf

*/

/*******************************/
User Function DCVendNeg(_P, _P2)
/*******************************/
Local lRet:=.f.
Local cQryZ5:=""
Local cQryZ4:=""
Local nTotNeg:=0
Local nPMoeda:=aScan( aHeader, {|Z|AllTrim(Z[2])=="UB_VQ_MOED"} )
//Local nPMoeda:=aScan( aHeader, {|Z|AllTrim(Z[2])=="UB_VQ_TABE"} )
//Local nPMoeda:=aScan( aHeader, {|Z|AllTrim(Z[2])=="UB_VQ_TABE"} )
Local nVlDif:=0
cQryZ5+="SELECT Z05_DATA, Z05_VALOR * CASE WHEN Z05_TIPODC='D' THEN -1 ELSE 1 END AS VALOR FROM "+RetSqlName("Z05")+" WHERE  "+CHR(13)+CHR(10)
cQryZ5+="	D_E_L_E_T_=' '  "+CHR(13)+CHR(10)
cQryZ5+="	AND Z05_VENDED='"+_P+"'  "+CHR(13)+CHR(10)
cQryZ5+="ORDER BY  "+CHR(13)+CHR(10)
cQryZ5+="	Z05_DATA DESC "+CHR(13)+CHR(10)
DbUseArea( .t., "TOPCONN", TcGenQry(,,cQryZ5), "VendZ5" )
TcSetField("VendZ5", "Z05_DATA", "D", 08, 0)
TcSetField("VendZ5", "VALOR", "N", 15, 2)
VendZ5->(DbGoTop())
nTotNeg+=If(VendZ5->(Eof()), 0, VendZ5->Valor)
dDataMaior:=If(VendZ5->(Eof()), CtoD("01/01/1980"), VendZ5->Z05_Data)

cQryZ4+="	SELECT  "+CHR(13)+CHR(10)
cQryZ4+="		Z04_EMISSA "+CHR(13)+CHR(10)
cQryZ4+="		, ( CASE WHEN Z04_TIPODC='D' THEN Z04_VALOR*-1 ELSE Z04_VALOR END ) AS VALOR "+CHR(13)+CHR(10)
cQryZ4+="	FROM  "+CHR(13)+CHR(10)
cQryZ4+="		"+RetSqlName("Z04")+"  "+CHR(13)+CHR(10)
cQryZ4+="	WHERE  "+CHR(13)+CHR(10)
cQryZ4+="		D_E_L_E_T_=' '  "+CHR(13)+CHR(10)
cQryZ4+="		AND Z04_VENDED='"+_P+"'  "+CHR(13)+CHR(10)
cQryZ4+="		AND Z04_EMISSA>'"+Dtos(dDataMaior)+"' "+CHR(13)+CHR(10)
DbUseArea( .t., "TOPCONN", TcGenQry(,,cQryZ4), "VendZ4" )
TcSetField("VendZ4", "VALOR", "N", 15, 2)
While !VendZ4->(Eof())
	nTotNeg+=VendZ4->Valor
	VendZ4->(DbSkip())

EndDo

VendZ4->(DbCloseArea())

If ProcName(1)="U_CFMPENDENCIA"
	For nL:=1 To Len(aCols)
		nVlDif+=((aCols[nL][aScan( aHeader, {|Z|AllTrim(Z[2])=="UB_VQ_VRUN"} )]-aCols[nL][aScan(aHeader, {|Z| AllTrim(Z[2])=="UB_VQ_PR_"+aCols[nL][aScan( aHeader, {|Z|AllTrim(Z[2])=="UB_VQ_TABE"} )]})])*If(aCols[nL][aScan( aHeader, {|Z|AllTrim(Z[2])=="UB_VQ_MOED"} )]="2", Posicione("SM2", 1, Dtos(dDataBase), "M2_MOEDA2"), 1))

	Next

Else // U_TMKVFIM
	DbUseArea(.t., "TOPCONN", TcGenQry(,, "SELECT SUM((UB_VQ_VRUN-(CASE UB_VQ_TABE WHEN 'A' THEN UB_VQ_PR_A WHEN 'B' THEN UB_VQ_PR_B WHEN 'C' THEN UB_VQ_PR_C WHEN 'D' THEN UB_VQ_PR_D WHEN 'E' THEN UB_VQ_PR_E ELSE 0 END )*CASE WHEN UB_VQ_MOED='2' THEN "+Str(Posicione("SM2", 1, Dtos(dDataBase), "M2_MOEDA2"))+" ELSE 1 END) ) AS TOTAB FROM "+RetSqlName("SUB")+" WHERE D_E_L_E_T_<>'*' AND UB_NUM='"+Sua->Ua_Num+"' " ), "TOTAT" )
	nVlDif+=TotAt->ToTab
	TotAt->(DbCloseArea())

EndIf

lRet:=((nTotNeg+nVlDif)<0)
VendZ5->(DbCloseArea())
Return lRet

/*************************/
User Function EmbRecup(_P)
/*************************/
Local lRet:=.f.
Local cQryER:=""

cQryER+="SELECT  "+CHR(13)+CHR(10)
cQryER+="	'S' AS TEMEMRE  "+CHR(13)+CHR(10)
cQryER+="FROM  "+CHR(13)+CHR(10)
cQryER+="	"+RetSqlName("SG1")+" G1 INNER JOIN "+CHR(13)+CHR(10)
cQryER+="	"+RetSqlName("SB1")+" B1 ON B1.B1_FILIAL=G1.G1_FILIAL AND B1.B1_COD=G1.G1_COMP AND B1.B1_VQ_EMRE='1' "+CHR(13)+CHR(10)
cQryER+="WHERE  "+CHR(13)+CHR(10)
cQryER+="	G1.D_E_L_E_T_=' ' "+CHR(13)+CHR(10)
cQryER+="	AND G1_COD='"+_P+"'  "+CHR(13)+CHR(10)
cQryER+="	AND B1.B1_TIPO='EM' "+CHR(13)+CHR(10)
DbUseArea( .t., "TOPCONN", TcGenQry(,,cQryER), "EMBRECUP" )
lRet:=(EmbRecup->TemEmRe='S')
EmbRecup->(DbCloseArea())

Return lRet

/*
		If Empty(Sa1->A1_UltCom)
			   _cBlq  :="1" //Alterado para 1 por Danilo Alves Del Busso - 30/07/2015    
			   _cMotivo+="00|" //  não bloquear pedidos que não geram duplicata - Nelson Junior      
			lTemMsg := .f.
			cMsgInfo+="CLIENTE NOVO !!! NAO EFETUOU COMPRAS AINDA!"+cEol
			cMsgInfo += "  - é necessário solicitar Serasa/Sintegra e atualização da ficha cadastral junto ao Departamento Financeiro com até 48 horas de antecedência à entrega da mercadoria, e o prazo de faturamento será de 24 horas da aprovação do cadastro."+cEol+cEol
			lAleMsg := .T.

        ElseIf ((dDataBase-Sa1->A1_UltCom)/30)>3 // MHS - 11/11/16
			   _cBlq  :="1" //Alterado para 1 por Danilo Alves Del Busso - 30/07/2015    
			   _cMotivo+="00|" //  não bloquear pedidos que não geram duplicata - Nelson Junior      
			lTemMsg   := .F.
			cMsgInfo += "CLIENTE INATIVO -> ULTIMA COMPRA:"+Dtoc(Sa1->A1_UltCom)+cEol
			cMsgInfo += "  - é necessário solicitar Serasa/Sintegra e atualização da ficha cadastral junto ao Departamento Financeiro com até 48 horas de antecedência à entrega da mercadoria, e o prazo de faturamento será de 24 horas da aprovação do cadastro."+cEol+cEol
			lAleMsg := .T.

        EndIf
SELECT Z04_VENDED, SUM( CASE WHEN Z04_TIPODC='D' THEN Z04_VALOR*-1 ELSE Z04_VALOR END ) FROM Z04010 WHERE Z04_VENDED='V00037' GROUP BY Z04_FILIAL,Z04_VENDED

*/

/***********************/
User Function MHSTabela()
/***********************/
Local nPosPrcA := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_PR_A"}) // PREÇO TABELA A Cassio Lima 18/10/2016 MCINFOTEC
Local nPosPrcB := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_PR_B"}) // PREÇO TABELA B Cassio Lima 18/10/2016 MCINFOTEC
Local nPosPrcC := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_PR_C"}) // PREÇO TABELA C Cassio Lima 18/10/2016 MCINFOTEC
Local nPosPrcD := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_PR_D"}) // PREÇO TABELA D Cassio Lima 18/10/2016 MCINFOTEC
Local nPosPrcE := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_PR_E"}) // PREÇO TABELA E Cassio Lima 18/10/2016 MCINFOTEC
Local nPosProd := aScan(aHeader,{|x| Alltrim(x[2])=="UB_PRODUTO"}) // PREÇO TABELA E Cassio Lima 18/10/2016 MCINFOTEC
Local nPosMoed:=aScan(aHeader, {|Z|AllTrim(Z[2])=="UB_VQ_MOED"})
Local nPosProd:=aScan(aHeader, {|Z|AllTrim(Z[2])=="UB_PRODUTO"})
Local nXX

If !(Len(aCols)>0 .And. !Empty(aCols[n][nPosProd]))
	Return
	
EndIf

For nXX:=1 To Len(aCols)
	aTbPrc:=CalcTab(aCols[nXX][nPosProd],nXX)
	aCols[nXX][nPosprcA]:=aTbPrc[1] ///If(aCols[nXX][nPosMoed]="2", Posicione("SM2", 1, Dtos(dDataBase), "M2_MOEDA2"), 1)
	aCols[nXX][nPosprcB]:=aTbPrc[2] ///If(aCols[nXX][nPosMoed]="2", Posicione("SM2", 1, Dtos(dDataBase), "M2_MOEDA2"), 1)
	aCols[nXX][nPosprcC]:=aTbPrc[3] ///If(aCols[nXX][nPosMoed]="2", Posicione("SM2", 1, Dtos(dDataBase), "M2_MOEDA2"), 1)
	aCols[nXX][nPosprcD]:=aTbPrc[4] ///If(aCols[nXX][nPosMoed]="2", Posicione("SM2", 1, Dtos(dDataBase), "M2_MOEDA2"), 1)
	aCols[nXX][nPosprcE]:=aTbPrc[5] ///If(aCols[nXX][nPosMoed]="2", Posicione("SM2", 1, Dtos(dDataBase), "M2_MOEDA2"), 1)
	
Next

oGetTLV:Refresh()
Return
