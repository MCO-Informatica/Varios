#Include "RwMake.Ch"
#Include "Protheus.Ch"
#Include "TopConn.Ch"
/*
================================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+------------------------+------------------------------+------------------+||
||| Programa: CfmPendencia | Autor: Celso Ferrone Martins | Data: 16/12/2014 |||
||+-----------+------------+------------------------------+------------------+||
||| Descricao |                                                              |||
||+-----------+--------------------------------------------------------------+||
||| Alteracao |                                                              |||
||+-----------+--------------------------------------------------------------+||
||| Uso       |                                                              |||
||+-----------+--------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
================================================================================
*/

User Function CfmPendencia(_lGrava,_cMsgInfo1,lVisu)

Local aAreaSa1  := SA1->(GetArea())
Local aAreaSa4  := SA4->(GetArea())
Local aAreaSb1  := SB1->(GetArea())
Local aAreaSb5  := SB5->(GetArea())

//----> VARIAVEIS LOGICAS
Local _lRet      	:= .T.
Local _lVlMinD		:= .F.
Local _lDifMoeda 	:= .F.
Local _lAleMsg   	:= .F.
Local _lEmbRecup	:= .F.
local _lPrcRevis	:= SUPERGETMV("MV_XPRCREVI",.F.,.T.	 )	// TABELA DE PRECO EM REVISAO

//----> VARIAVEIS NUMERICAS
Local _nPesoLiq    	:= 0
Local _nPesoBru    	:= 0
Local _nQtdPolFed	:= 0
Local _nQtdExercito	:= 0
Local _nCapaAmos	:= SUPERGETMV("MV_XCAPAMO" ,.F.,0.250)	// QUANTIDADE MAXIMA AMOSTRAS
Local _nValMinDupl	:= SUPERGETMV("MV_XVALDUP" ,.F.,600  )	// VALOR MINIMO DUPLICATA
Local _nQtdMaxDupl	:= SUPERGETMV("MV_XMAXDUP" ,.F.,5    )	// QUANTIDADE MAXIMA DUPLICATAS
local _nQtdVers		:= SUPERGETMV("MV_XQTDVERS",.F.,1000 )	// QUANTIDADE MINIMA VERSOLVE
local _nQtdTbRec	:= SUPERGETMV("MV_XQTDTBRE",.F.,4	 )	// QUANTIDADE MINIMA RECUPERADO
local _nQtdDiasEnt	:= SUPERGETMV("MV_XQTDDIAS",.F.,10	 )	// QUANTIDADE DIAS ENTREGA PARA NAO BLOQUEAR PEDIDO
Local _nQtdMaxVis	:= 0

//----> VARIAVES CARACTERES
Local   _cEol      	:= Chr(13)+Chr(10)
Local   _cMsgFim	:= "BLOQUEIO REGRAS COMERCIAIS - " + M->UA_NUMSC5
Local   _cMsgInfo2 	:= ""
Local   _nQtdDupl 	:= 1
Public  _cCodMot 	:= ""
Public  _nTotAtend	:= 0

Default _lGrava   	:= .F.
Default _cMsgInfo1 	:= ""    


	DbSelectARea("SA1") ; DbSetOrder(1) // Clientes
	DbSelectARea("SA4") ; DbSetOrder(1) // Transportadora
	DbSelectARea("SB1") ; DbSetOrder(1) // Produtos
	DbSelectARea("SBM") ; DbSetOrder(1) // Grupo
	DbSelectArea("SB5") ; DbSetOrder(1) // Complemento de Protudo
	DbSelectArea("Z17") ; DbSetOrder(2) // Alves
	
	SA1->(DbSeek(xFilial("SA1")+M->(UA_CLIENTE+UA_LOJA)))
	SA4->(DbSeek(xFilial("SA4")+M->UA_TRANSP))
	SC5->(DbSeek(xFilial("SC5")+M->UA_NUMSC5))
	
	If !EMPTY(SA4->A4_VQ_REST)
		Alert("A Transportadora " + SA4->A4_NOME + " - Possui as seguintes restrições: " + _cEol + _cEol + SA4->A4_VQ_REST)
	EndIf
	
	//----> LIMPA OS MOTIVOS DE BLOQUEIO PARA REGRAVA-LOS
	If SC5->(DbSeek(xFilial("SC5")+M->UA_NUMSC5))
		RecLock("SC5",.F.)
		SC5->C5_VQ_MOT	:=	""
		MsUnLock()
	EndIf
	
	If !M->UA_VQ_AMOS$"S"
		//----> INICIO ITEM 4.4.D - POLITICA COMERCIAL - CLIENTE NOVO
		If Empty(SA1->A1_ULTCOM)
			
			If At("CLIENTE NOVO - Ficha cadastral", _cMsgInfo1)=0
				_cMsgInfo1 += "CLIENTE NOVO - Fich,a cadastral" +_cEol
				_cMsgInfo1 += "  - é necessário solicitar Serasa/Sintegra e atualização da ficha cadastral junto ao Departamento Financeiro com até 48 horas de antecedência à entrega da mercadoria, e o prazo de faturamento será de 24 horas da aprovação do cadastro."+_cEol+_cEol
				_cMsgInfo2 += _cMsgInfo1
				_cMsgInfo1 := ""
				_lAleMsg := .T.
				_cCodMot += "44D|"
				
				If SC5->(DbSeek(xFilial("SC5")+M->UA_NUMSC5))
					If At("44D|", SC5->C5_VQ_MOT)=0
						RecLock("SC5",.F.)
						SC5->C5_VQ_MOT	:=	ALLTRIM(SC5->C5_VQ_MOT)+"44D|"		//VALIDACAO EFETUADA NO DOCUMENTO
						MsUnLock()
					EndIf
				EndIf
			EndIf
		EndIf
		//----> FIM ITEM 4.4.D - POLITICA COMERCIAL - CLIENTE NOVO
		
		
		//----> INICIO ITEM 4.4.B - POLITICA COMERCIAL - CLIENTE INATIVO
		If !Empty(SA1->A1_ULTCOM)
			If ((dDataBase-SA1->A1_ULTCOM)/30)>3
				If At("CLIENTE INATIVO - Última compra em "+Dtoc(SA1->A1_ULTCOM), _cMsgInfo1)=0
					_cMsgInfo1 += "CLIENTE INATIVO - Última compra em "+Dtoc(SA1->A1_ULTCOM)+_cEol
					_cMsgInfo1 += "  - é necessário solicitar Serasa/Sintegra e atualização da ficha cadastral junto ao Departamento Financeiro com até 48 horas de antecedência à entrega da mercadoria, e o prazo de faturamento será de 24 horas da aprovação do cadastro."+_cEol+_cEol
					_cMsgInfo2 += _cMsgInfo1
					_cMsgInfo1 := ""
					_lAleMsg   := .T.
					_cCodMot += "44B|"
					
					If SC5->(DbSeek(xFilial("SC5")+M->UA_NUMSC5))
						If At("44B|", SC5->C5_VQ_MOT)=0
							RecLock("SC5",.F.)
							SC5->C5_VQ_MOT	:=	ALLTRIM(SC5->C5_VQ_MOT)+"44B|"	//VALIDACAO EFETUADA NO DOCUMENTO
							MsUnLock()
						EndIf
					EndIf
				EndIf
			EndIf
		EndIf
		//----> FIM ITEM 4.4.B - POLITICA COMERCIAL - CLIENTE INATIVO
		
		
		//----> INICIO ITEM 4.1.K.3 - POLITICA COMERCIAL - FRETE/REDESPACHO
		If ((M->UA_VQ_FRET = "V" .And. M->UA_VQ_FVER = "D") .Or. (M->UA_VQ_FRET = "C" .And. M->UA_VQ_FCLI="D" ))
			If !U_MunPad({SA4->A4_EST,SA4->A4_COD_MUN})
				If At("REDESPACHO - Transportadora da casa não atende a cidade da Transportadora de Redespacho.", _cMsgInfo1)=0
					_cMsgInfo1 +="REDESPACHO - Transportadora da casa não atende a cidade da Transportadora de Redespacho."+_cEol+_cEol
					_cMsgInfo2 += _cMsgInfo1
					_cMsgInfo1 := ""
					_lAleMsg   := .T.
					_cCodMot += "41K3|"
					
					If SC5->(DbSeek(xFilial("SC5")+M->UA_NUMSC5))
						If At("41K3|", SC5->C5_VQ_MOT)=0
							RecLock("SC5",.F.)
							SC5->C5_VQ_MOT	:=	ALLTRIM(SC5->C5_VQ_MOT)+"41K3|"	//VALIDACAO EFETUADA NO DOCUMENTO
							MsUnLock()
						EndIf
					EndIf
				EndIf
			EndIf
		EndIf
		//----> FIM ITEM 4.1.K.3 - POLITICA COMERCIAL - FRETE/REDESPACHO
		
		
		//----> REGRA DESATIVADA CONFORME SOLICITACAO ANDREIA DUBOVISKY - 14/08/2020 - RICARDO SOUZA
		//----> INICIO ITEM 9.9.F - POLITICA COMERCIAL - VALOR FRETE REAL A MENOR 
		/*
		If M->UA_VQ_FVAL < M->UA_VQ_FVRE
			If At("VALOR FRETE REAL MENOR QUE O VALOR DO FRETE", _cMsgInfo1)=0
				_cMsgInfo1 +="VALOR FRETE REAL MENOR QUE O VALOR DO FRETE"+_cEol+_cEol
				_cMsgInfo2 += _cMsgInfo1
				_cMsgInfo1 := ""
				_lAleMsg   := .T.
				_cCodMot += "99F|"
				
				If SC5->(DbSeek(xFilial("SC5")+M->UA_NUMSC5))
					If At("99F|", SC5->C5_VQ_MOT)=0
						RecLock("SC5",.F.)
						SC5->C5_VQ_MOT	:=	ALLTRIM(SC5->C5_VQ_MOT)+"99F|"	//VALIDACAO EFETUADA NO DOCUMENTO
						MsUnLock()
					EndIf
				EndIf
			EndIf
		EndIf
		*/
		//----> FIM ITEM 9.9.F - POLITICA COMERCIAL - VALOR FRETE REAL A MENOR 

		//----> INICIO ITEM 4.1.K.1 - POLITICA COMERCIAL - MODALIDADE FRETE
		If M->UA_VQ_FVER = "N" .And. M->UA_VQ_FRET = "V" .And. SA4->A4_VQ_VERQ <> "S"
			If At("MODALIDADE FRETE - Transportadora nao é habilitada para essa modalidade de frete.", _cMsgInfo1)=0
				_cMsgInfo1 += "MODALIDADE FRETE - Transportadora nao é habilitada para essa modalidade de frete."+_cEol+_cEol
				_cMsgInfo2 += _cMsgInfo1
				_cMsgInfo1 := ""
				_lAleMsg   := .T.
				_cCodMot += "41K1|"
				
				If SC5->(DbSeek(xFilial("SC5")+M->UA_NUMSC5))
					If At("41K1|", SC5->C5_VQ_MOT)=0
						RecLock("SC5",.F.)
						SC5->C5_VQ_MOT	:=	ALLTRIM(SC5->C5_VQ_MOT)+"41K1|"	// VALIDACAO EFETUADA NO DOCUMENTO
						MsUnLock()
					EndIf
				EndIf
			EndIf
		EndIf
		//----> FIM ITEM 4.1.K.1 - POLITICA COMERCIAL - MODALIDADE FRETE
		
		
		//----> INICIO ITEM 4.1.K.2 - POLITICA COMERCIAL - CIDADE NAO ATENDIDA                   	
		If M->UA_VQ_FVER = "N" .And. M->UA_VQ_FRET = "V" .And. SA4->A4_VQ_VERQ = "S"
			If !Empty(SA1->A1_CODMUNE) .And. !Empty(SA1->A1_ESTE)
				Z17->(DbSeek( xFilial("Z17")+SA4->A4_COD+SA1->(A1_ESTE+A1_CODMUNE) ))
			Else
				Z17->(DbSeek( xFilial("Z17")+SA4->A4_COD+SA1->(A1_EST+A1_COD_MUN) ))
			EndIf
			
			If Z17->(Eof())
				If At("CIDADE NAO ATENDIDA - Transportadora da casa não atende a cidade da entrega.", _cMsgInfo1)=0
					_cMsgInfo1 += "CIDADE NAO ATENDIDA - Transportadora da casa não atende a cidade da entrega."+_cEol+_cEol
					_cMsgInfo2 += _cMsgInfo1
					_cMsgInfo1 := ""
					_lAleMsg   := .T.
					_cCodMot += "41K2|"
					
					If SC5->(DbSeek(xFilial("SC5")+M->UA_NUMSC5))
						If At("41K2|", SC5->C5_VQ_MOT)=0
							RecLock("SC5",.F.)
							SC5->C5_VQ_MOT	:=	ALLTRIM(SC5->C5_VQ_MOT)+"41K2|"	// VALIDACAO EFETUADA NO DOCUMENTO
							MsUnLock()
						EndIf
					EndIf
				EndIf
			EndIf
		EndIf
		//----> FIM ITEM 4.1.K.2 - POLITICA COMERCIAL - CIDADE NAO ATENDIDA
		
		
		//----> INICIO ITEM 4.1.F - POLITICA COMERCIAL - PAGAMENTO ANTECIPADO
		If Posicione("SE4", 1, xFilial("SE4")+M->UA_CONDPG, "E4_CODIGO" ) $ "001/190/469/509/522/532/576/578/621/623/636/685/728/759" .And. At("PAGAMENTO ANTECIPADO - O vendedor deverá solicitar a emissão do ", _cMsgInfo1)=0
			_cMsgInfo1 += "PAGAMENTO ANTECIPADO - O vendedor deverá solicitar a emissão do "+_cEol
			_cMsgInfo1 += "SINTEGRA do cliente para certificar que está habilitado junto da Secretaria da Fazenda Estadual."+_cEol
			_cMsgInfo1 += "Esclarecer ao cliente que o pagamento deve ser essencialmente em TED OU TRANSFERENCIA DO MESMO BANCO,"+_cEol
			_cMsgInfo1 += "não permitindo o recebimento de valores na retirada do produto."+_cEol+_cEol
			_cMsgInfo2 += _cMsgInfo1
			_cMsgInfo1 := ""
			_lAleMsg   := .T.
			_cCodMot += "41F|"
			
			If SC5->(DbSeek(xFilial("SC5")+M->UA_NUMSC5))
				If At("41F|", SC5->C5_VQ_MOT)=0
					RecLock("SC5",.F.)
					SC5->C5_VQ_MOT	:=	ALLTRIM(SC5->C5_VQ_MOT)+"41F|"	//VALIDACAO EFETUADA NO DOCUMENTO
					MsUnLock()
				EndIf
			EndIf
		EndIf
		//----> FIM ITEM 4.1.F - POLITICA COMERCIAL - PAGAMENTO ANTECIPADO
		
		//----> REGRA DESATIVADA CONFORME SOLICITACAO ANDREIA DUBOVISKY - 14/08/2020 - RICARDO SOUZA
		//----> INICIO ITEM 4.1.F - POLITICA COMERCIAL - DEBITO/CREDITO VENDEDOR
		/*
		If U_DCVendNeg(M->UA_VEND) .And. At("DEBITO/CREDITO - Vendedor com saldo negativo.", _cMsgInfo1)=0
			_cMsgInfo1 += "DEBITO/CREDITO - Vendedor com saldo negativo."+_cEol
			_cMsgInfo1 += "  - é necessário solicitar Aprovação do Gestor."+_cEol+_cEol
			_cMsgInfo2 += _cMsgInfo1
			_cMsgInfo1 := ""
			_lAleMsg   := .T.
			_cCodMot += "41U|"
			
			If SC5->(DbSeek(xFilial("SC5")+M->UA_NUMSC5))
				If At("41U|", SC5->C5_VQ_MOT)=0
					RecLock("SC5",.F.)
					SC5->C5_VQ_MOT	:=	ALLTRIM(SC5->C5_VQ_MOT)+"41U|"	//VALIDACAO EFETUADA NO DOCUMENTO
					MsUnLock()
				EndIf
			EndIf
		EndIf
		*/
		//----> FIM ITEM 4.1.F - POLITICA COMERCIAL - DEBITO/CREDITO VENDEDOR
		
		
		//----> INICIO ITEM 9.9.C - EXTRA POLITICA COMERCIAL - TABELA DE PRECO EM REVISAO
		If _lPrcRevis
			If At("TABELA DE PRECO - os preços estão em revisão pela Gestão Comercial. O pedido deverá ter os preços recalculados após o término da revisão. ", _cMsgInfo1)=0
				_cMsgInfo1 += "TABELA DE PRECO - os preços estão em revisão pela Gestão Comercial. O pedido deverá ter os preços recalculados após o término da revisão. "+_cEol+_cEol
				_cMsgInfo2 += _cMsgInfo1
				_cMsgInfo1 := ""
				_lAleMsg := .T.
				_cCodMot += "99C|"
				
				If SC5->(DbSeek(xFilial("SC5")+M->UA_NUMSC5))
					If At("99C|", SC5->C5_VQ_MOT)=0
						RecLock("SC5",.F.)
						SC5->C5_VQ_MOT	:=	ALLTRIM(SC5->C5_VQ_MOT)+"99C|"	// VALIDACAO EFETUADA NO DOCUMENTO
						MsUnLock()
					EndIf
				EndIf
			EndIf
		EndIf
		//----> FIM ITEM 9.9.C - EXTRA POLITICA COMERCIAL - TABELA DE PRECO EM REVISAO
	EndIF
	
	//----> VARRE TODOS OS ITENS DO ATENDIMENTO (TABELA SUB)
	For _nX := 1 to Len(aCols)
		
		If !GdDeleted(_nX,aHeader,aCols)
			
			SB1->(DbSeek( xFilial("SB1")+aCols[_nX][aScan(aHeader,{|x| Alltrim(x[2])=="UB_PRODUTO"})] ))
			
			_nQtdMin := SB1->B1_VQ_QMEC		// QUANTIDADE DE VENDA MINIMA
			
			
			//----> GRAVA OS PESOS LIQUIDO E BRUTO NO CABECALHO DO ATENDIMENTO (TABELA SUA)
			If _lGrava
				If aCols[_nX][aScan(aHeader,{|x| AllTrim(x[2])=="UB_UM"})] == "KG"
					_nPesoLiq += aCols[_nX][aScan(aHeader,{|x| Alltrim(x[2])=="UB_QUANT"})]
				ElseIf aCols[_nX][aScan(aHeader,{|x| Alltrim(x[2])=="UB_SEGUM"})] == "KG"
					_nPesoLiq += aCols[_nX][aScan(aHeader,{|x| Alltrim(x[2])=="UB_QUANT2"})]
				EndIf
				
				If SB1->(DbSeek(xFilial("SB1")+aCols[_nX][aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_EM"})]))
					If SB1->B1_PESO > 0
						_nPesoBru += (aCols[_nX][aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_QTDE"})] / aCols[_nX][aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_CAPA"})]) * SB1->B1_PESO
					EndIf
				EndIf
			EndIf
			
			
			//----> NAO PERMITE PRODUTOS COM QUANTIDADE ZERADAS
			If aCols[_nX][aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_QTDE"})] == 0 .And. _lRet
				MsgAlert("Não é permitido produto com quantidade zero!")
				_lRet := .F.
			EndIf
			
			
			//----> INICIO ITEM 9.9.A - EXTRA POLITICA COMERCIAL - TES QUE NAO GERA FINANCEIRO
			If !M->UA_VQ_AMOS$"S" .And. !AllTrim(Posicione("SF4",1,xFilial("SF4")+aCols[_nX][aScan(aHeader,{|x| Alltrim(x[2])=="UB_TES"})],"F4_DUPLIC")) == "S"
				If At("TES "+aCols[_nX][aScan(aHeader,{|x| Alltrim(x[2])=="UB_TES"})]+" não gera financeiro. ", _cMsgInfo1)=0
					_cMsgInfo1 += "TES "+aCols[_nX][aScan(aHeader,{|x| Alltrim(x[2])=="UB_TES"})]+" não gera financeiro. "+_cEol+_cEol
					_cMsgInfo2 += _cMsgInfo1
					_cMsgInfo1 := ""
					_lAleMsg := .T.
					_cCodMot += "99A|"
					
					If SC5->(DbSeek(xFilial("SC5")+M->UA_NUMSC5))
						If At("99A|", SC5->C5_VQ_MOT)=0
							RecLock("SC5",.F.)
							SC5->C5_VQ_MOT	:=	ALLTRIM(SC5->C5_VQ_MOT)+"99A|"	// VALIDACAO EFETUADA NO DOCUMENTO
							MsUnLock()
						EndIf
					EndIf
				EndIf
			EndIf
			//----> FIM ITEM 9.9.A - EXTRA POLITICA COMERCIAL - TES QUE NAO GERA FINANCEIRO
			
			
			//----> INICIO ITEM 9.9.B - EXTRA POLITICA COMERCIAL - DATA DE ENTREGA PARA O MES SEGUINTE
			If !M->UA_VQ_AMOS$"S" .And. Month(aCols[_nX][aScan(aHeader,{|x| Alltrim(x[2])=="UB_DTENTRE"})]) > Month(dDataBase)
				If At(aCols[_nX][aScan(aHeader,{|x| Alltrim(x[2])=="UB_PRODUTO"})]+" DATA ENTREGA - a data de entrega para o próximo mês ou superior deve ter os preços recalculados. ", _cMsgInfo1)=0
					_cMsgInfo1 += aCols[_nX][aScan(aHeader,{|x| Alltrim(x[2])=="UB_PRODUTO"})]+" DATA ENTREGA - a data de entrega para o próximo mês ou superior deve ter os preços recalculados. "+_cEol+_cEol
					_cMsgInfo2 += _cMsgInfo1
					_cMsgInfo1 := ""
					_lAleMsg := .T.
					_cCodMot += "99B|"
					
					If SC5->(DbSeek(xFilial("SC5")+M->UA_NUMSC5))
						If At("99B|", SC5->C5_VQ_MOT)=0
							RecLock("SC5",.F.)
							SC5->C5_VQ_MOT	:=	ALLTRIM(SC5->C5_VQ_MOT)+"99B|"	// VALIDACAO EFETUADA NO DOCUMENTO
							MsUnLock()
						EndIf
					EndIf
				EndIf
			EndIf
			//----> FIM ITEM 9.9.B - EXTRA POLITICA COMERCIAL - DATA DE ENTREGA PARA O MES SEGUINTE
			
		
			//----> INICIO ITEM 9.9.D - EXTRA POLITICA COMERCIAL - DATA DE ENTREGA SUPERIOR A 10 DIAS
			If !M->UA_VQ_AMOS$"S" .And. (aCols[_nX][aScan(aHeader,{|x| Alltrim(x[2])=="UB_DTENTRE"})]) > (dDataBase+_nQtdDiasEnt)
				If At(aCols[_nX][aScan(aHeader,{|x| Alltrim(x[2])=="UB_PRODUTO"})]+" RESERVA ESTOQUE - a data de entrega é superior a "+Str(_nQtdDiasEnt)+" dias. Não será reservado estoque.", _cMsgInfo1)=0
					_cMsgInfo1 += aCols[_nX][aScan(aHeader,{|x| Alltrim(x[2])=="UB_PRODUTO"})]+" RESERVA ESTOQUE - a data de entrega é superior a "+Str(_nQtdDiasEnt)+" dias. Não será reservado estoque."+_cEol+_cEol
					_cMsgInfo2 += _cMsgInfo1
					_cMsgInfo1 := ""
					_lAleMsg := .T.
					_cCodMot += "99D|"
					
					If SC5->(DbSeek(xFilial("SC5")+M->UA_NUMSC5))
						If At("99D|", SC5->C5_VQ_MOT)=0
							RecLock("SC5",.F.)
							SC5->C5_VQ_MOT	:=	ALLTRIM(SC5->C5_VQ_MOT)+"99D|"	// VALIDACAO EFETUADA NO DOCUMENTO
							MsUnLock()
						EndIf
					EndIf
				EndIf
			EndIf
			//----> FIM ITEM 9.9.D - EXTRA POLITICA COMERCIAL - DATA DE ENTREGA SUPERIOR A 10 DIAS
			
			
			//----> INICIO ITEM 4.4.H - POLITICA COMERCIAL - AMOSTRAS
			If 	M->UA_VQ_AMOS$"S" .And. aCols[_nX][aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_QTDE"})] > _nCapaAmos
				If At(" AMOSTRA - A quantidade máxima permitida para amostras é "+Str(_nCapaAmos)+" gramas.", _cMsgInfo1)=0
					_cMsgInfo1 += " AMOSTRA - A quantidade máxima permitida para amostras é "+Str(_nCapaAmos)+" gramas."+_cEol+_cEol
					_cMsgInfo2 += _cMsgInfo1
					_cMsgInfo1 := ""
					_lAleMsg := .T.
					_lRet 	 := .F.
					_lVlMinD := .T.
					_cCodMot += "44H|"
					
					If SC5->(DbSeek(xFilial("SC5")+M->UA_NUMSC5))
						If At("44H|", SC5->C5_VQ_MOT)=0
							RecLock("SC5",.F.)
							SC5->C5_VQ_MOT	:=	ALLTRIM(SC5->C5_VQ_MOT)+"44H|"	// VALIDACAO EFETUADA NO DOCUMENTO
							MsUnLock()
						EndIf
					EndIf
				EndIf
				
				Exit	// SE TRATANDO DE AMOSTRA É DESNECESSARIO VERIFICAR AS DEMAIS VALIDACOES
				
			EndIf
			//----> FIM ITEM 4.4.H - POLITICA COMERCIAL - AMOSTRAS
			
			
			//----> INICIO ITEM 4.1.P - POLITICA COMERCIAL - VISITA AO CLIENTE
			dbSelectArea("Z20")
			dbSetOrder(1)
			//----> SE FOR CLIENTE ESPECIAL NAO HÁ NECESSIDADE DE VISITA
			//----> REGRA IMPLEMENTADA CONFORME SOLICITACAO ANDREIA DUBOVISKY - 14/08/2020 - RICARDO SOUZA
			//----> 
			If !dbSeek(xFilial("Z20")+M->UA_CLIENTE+M->UA_LOJA,.F.)
				SB1->(DbSeek( xFilial("SB1")+aCols[_nX][aScan(aHeader,{|x| Alltrim(x[2])=="UB_PRODUTO"})] ))
				If !M->UA_VQ_AMOS$"S" .And. !U_VISITA(aCols[n][aScan(aHeader,{|x| Alltrim(x[2])=="UB_PRODUTO"})], aCols[n][aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_QTDE"})], aCols[n][aScan(aHeader,{|x| AllTrim(x[2])=="UB_VQ_UM"})], @_nQtdMaxVis )
					If At("VISITA - Necessário visitar as instalações do cliente. Última visita em ", _cMsgInfo1)=0
						_cMsgInfo1 += "VISITA - Necessário visitar as instalações do cliente. Última visita em "+Dtoc(SA1->A1_VQ_VISI)+_cEol
						_cMsgInfo2 += _cMsgInfo1
						_cMsgInfo1 := ""
						_lAleMsg   := .T.
						_cCodMot += "41P|"
						
						If SC5->(DbSeek(xFilial("SC5")+M->UA_NUMSC5))
							If At("41P|", SC5->C5_VQ_MOT)=0
								RecLock("SC5",.F.)
								SC5->C5_VQ_MOT	:=	ALLTRIM(SC5->C5_VQ_MOT)+"41P|"	//VALIDACAO EFETUADA NO DOCUMENTO
								MsUnLock()
							EndIf
						EndIf
					EndIf
					If At(aCols[n][aScan(aHeader,{|x| Alltrim(x[2])=="UB_PRODUTO"})], _cMsgInfo1)=0
						_cMsgInfo1 += "  - a quantidade máxima permitida para venda, SEM VISITA do produto "+aCols[n][aScan(aHeader,{|x| Alltrim(x[2])=="UB_PRODUTO"})]+" é "+AllTrim(Str(_nQtdMaxVis,12,2))+aCols[n][aScan(aHeader,{|x| AllTrim(x[2])=="UB_VQ_UM"})]+_cEol+_cEol
						_cMsgInfo2 += _cMsgInfo1
						_cMsgInfo1 := ""
						_lAleMsg   := .T.
					EndIf
				EndIf
			EndIf 
			//----> FIM ITEM 4.1.P - POLITICA COMERCIAL - VISITA AO CLIENTE
			
			
			//----> INICIO ITEM 4.1.E - POLITICA COMERCIAL - PRECO MINIMO
			SB1->(DbSeek( xFilial("SB1")+aCols[_nX][aScan(aHeader,{|x| Alltrim(x[2])=="UB_PRODUTO"})] ))
			If !M->UA_VQ_AMOS$"S" .And. !SubStr(SB1->B1_VQ_EM, 3, 3) >= '100' .And. !SubStr(SB1->B1_VQ_EM, 3, 3)<='401' .And. aCols[_nX][aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_VRUN"})] < aCols[_nX][aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_PR_D"})]
				
				// RETIRADO EM 12/07/2017 - RICARDO If !M->UA_VQ_AMOS$"S" .And. aCols[_nX][aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_VRUN"})] < aCols[_nX][aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_VAL"})]
				If At(Alltrim(aCols[_nX][aScan(aHeader,{|x| Alltrim(x[2])=="UB_PRODUTO"})])+" está com o preço venda abaixo do preço mínimo.", _cMsgInfo1)=0
					_cMsgInfo1 += Alltrim(aCols[_nX][aScan(aHeader,{|x| Alltrim(x[2])=="UB_PRODUTO"})])+" está com o preço venda abaixo do preço mínimo."+_cEol
					_cMsgInfo1 += " - Preço tabela "+Transform(aCols[_nX][aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_PR_D"})],"@E 999,999,999.99")+"  Preco digitado "+Transform(aCols[_nX][aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_VRUN"})],"@E 999,999,999.99")+_cEol+_cEol
					_cMsgInfo2 += _cMsgInfo1
					_cMsgInfo1 := ""
					_lAleMsg   := .T.
					_cCodMot += "41E|"
					
					If SC5->(DbSeek(xFilial("SC5")+M->UA_NUMSC5))
						If At("41E|", SC5->C5_VQ_MOT)=0
							RecLock("SC5",.F.)
							SC5->C5_VQ_MOT	:=	ALLTRIM(SC5->C5_VQ_MOT) + "41E|"	//VALIDACAO EFETUADA NO DOCUMENTO
							MsUnLock()
						EndIf
					EndIf
				EndIf
			EndIf
			//----> FIM ITEM 4.1.E - POLITICA COMERCIAL - PRECO MINIMO
			
			
			//----> INICIO ITEM 4.1.Q - POLITICA COMERCIAL - PRODUTO DE VENDA ESPECIAL NECESSITA DE LIBERACAO DO GESTOR COMERCIAL
			SB1->(DbSeek( xFilial("SB1")+aCols[_nX][aScan(aHeader,{|x| Alltrim(x[2])=="UB_PRODUTO"})] ))
			If !M->UA_VQ_AMOS$"S" .and. SB1->B1_VQ_VESP$"1" .And. At(AllTrim(SB1->B1_COD)+" é produto de VENDA ESPECIAL. Necessita de liberação do gestor comercial.", _cMsgInfo1)=0
				_cMsgInfo1 += AllTrim(SB1->B1_COD)+" é produto de VENDA ESPECIAL. Necessita de liberação do gestor comercial.
				_cMsgInfo2 += _cMsgInfo1
				_cMsgInfo1 := ""
				_lAleMsg   := .T.
				_cCodMot += "41Q|"
				
				If SC5->(DbSeek(xFilial("SC5")+M->UA_NUMSC5))
					If At("41Q|", SC5->C5_VQ_MOT)=0
						RecLock("SC5",.F.)
						SC5->C5_VQ_MOT	:=	ALLTRIM(SC5->C5_VQ_MOT)  + "41Q|"
						MsUnLock()
					EndIf
				EndIf
			EndIf
			//----> FIM ITEM 4.1.Q - POLITICA COMERCIAL - PRODUTO DE VENDA ESPECIAL NECESSITA DE LIBERACAO DO GESTOR COMERCIAL
			
			
			//----> INICIO ITEM 4.4.I - POLITICA COMERCIAL - VERSOLVE
			SB1->(DbSeek( xFilial("SB1")+aCols[_nX][aScan(aHeader,{|x| Alltrim(x[2])=="UB_PRODUTO"})] ))
			DbSelectArea ("SBM")
			DbSetOrder(1)
			IF SBM->(DbSeek(xFilial("SBM")+SB1->B1_GRUPO))
				If !M->UA_VQ_AMOS$"S" .and. SBM->BM_VQ_CATP$"S"
					
					If At(Alltrim(aCols[_nX][aScan(aHeader,{|x| Alltrim(x[2])=="UB_PRODUTO"})])+" é produto VERSOLVE. Avisar setor operacional com antecedência de 48 horas.", _cMsgInfo1)=0
						_cMsgInfo1 += Alltrim(aCols[_nX][aScan(aHeader,{|x| Alltrim(x[2])=="UB_PRODUTO"})])+" é produto VERSOLVE. Avisar setor operacional com antecedência de 48 horas."+_cEol+_cEol
						_cMsgInfo2 += _cMsgInfo1
						_cMsgInfo1 := ""
						_lAleMsg := .T.
						_cCodMot += "44I1|"
						
						If SC5->(DbSeek(xFilial("SC5")+M->UA_NUMSC5))
							If At("44I1|", SC5->C5_VQ_MOT)=0
								RecLock("SC5",.F.)
								SC5->C5_VQ_MOT	:=	ALLTRIM(SC5->C5_VQ_MOT) + "44I1|"	//VALIDACAO EFETUADA EM DOCUMENTO
								MsUnLock()
							EndIf
						EndIf
					EndIf
					If aCols[_nX][aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_QTDE"})] < _nQtdVers
						If At(Alltrim(aCols[_nX][aScan(aHeader,{|x| Alltrim(x[2])=="UB_PRODUTO"})])+" é produto VERSOLVE. A quantidade mínima de venda é "+Str(_nQtdVers)+" litros.", _cMsgInfo1)=0
							_cMsgInfo1 += Alltrim(aCols[_nX][aScan(aHeader,{|x| Alltrim(x[2])=="UB_PRODUTO"})])+" é produto VERSOLVE. A quantidade mínima de venda é "+Str(_nQtdVers)+" litros."+_cEol+_cEol
							_cMsgInfo2 += _cMsgInfo1
							_cMsgInfo1 := ""
							_lAleMsg   := .T.
							_cCodMot += "44I2|"
							
							If SC5->(DbSeek(xFilial("SC5")+M->UA_NUMSC5))
								If At("44I2|", SC5->C5_VQ_MOT)=0
									RecLock("SC5",.F.)
									SC5->C5_VQ_MOT	:=	ALLTRIM(SC5->C5_VQ_MOT) + "44I2|"	//VALIDACAO EFETUADA EM DOCUMENTO
									MsUnLock()
								EndIf
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf
			//----> FIM ITEM 4.4.I - POLITICA COMERCIAL - VERSOLVE
			
			
			//----> INICIO ITEM 4.1.D - POLITICA COMERCIAL - BOMBONAS
			SB1->(DbSeek( xFilial("SB1")+aCols[_nX][aScan(aHeader,{|x| Alltrim(x[2])=="UB_PRODUTO"})] ))
			If SubStr(SB1->B1_VQ_EM, 3, 3) >= '401' .And. SubStr(SB1->B1_VQ_EM, 3, 3)<='401' .And. SB1->B1_VQ_BOMB$"N"
				
				If !M->UA_VQ_AMOS$"S" .And. aCols[_nX][aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_VRUN"})] < aCols[_nX][aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_PR_A"})]
					//If !M->UA_VQ_AMOS$"S" .and. aCols[_nX][aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_TABE"})]<>"A"
					If At(Alltrim(aCols[_nX][aScan(aHeader,{|x| Alltrim(x[2])=="UB_PRODUTO"})])+" é BOMBONA 50 LT. Só é permitido a venda na tabela de preço A.", _cMsgInfo1)=0
						_cMsgInfo1 += Alltrim(aCols[_nX][aScan(aHeader,{|x| Alltrim(x[2])=="UB_PRODUTO"})])+" é BOMBONA 50 LT. Só é permitido a venda na tabela de preço A."+_cEol+_cEol
						_cMsgInfo2 += _cMsgInfo1
						_cMsgInfo1 := ""
						_lAleMsg   := .T.
						_cCodMot += "41D|"
						
						If SC5->(DbSeek(xFilial("SC5")+M->UA_NUMSC5))
							If At("41D|", SC5->C5_VQ_MOT)=0
								RecLock("SC5",.F.)
								SC5->C5_VQ_MOT	:=	ALLTRIM(SC5->C5_VQ_MOT)+"41D|"	//VALIDACAO EFETUADA NO DOCUMENTO
								MsUnLock()
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf
			
			
			
			//----> FIM ITEM 4.1.D - POLITICA COMERCIAL - BOMBONAS
			
			//----> INICIO ITEM 4.1.C / 4.1.O - POLITICA COMERCIAL - TAMBORES NOVOS E RECUPERADOS
			SB1->(DbSeek( xFilial("SB1")+aCols[_nX][aScan(aHeader,{|x| Alltrim(x[2])=="UB_PRODUTO"})] ))
			If	SubStr(SB1->B1_VQ_EM, 3, 3) >= '100' .And. SubStr(SB1->B1_VQ_EM, 3, 3)<='399'
				
				_lEmbRecup	:=	.F.
				
				dbSelectArea("SG1")
				dbSetorder(1)
				If dbSeek(xFilial("SG1")+aCols[_nX][aScan(aHeader,{|x| Alltrim(x[2])=="UB_PRODUTO"})],.F.)
					While Eof() == .f. .And. SG1->G1_COD == aCols[_nX][aScan(aHeader,{|x| Alltrim(x[2])=="UB_PRODUTO"})]
						
						//----> EMBALAGEM RECUPERADA
						If Alltrim(SG1->G1_COMP) $ "03101"
							_lEmbRecup	:=	.T.
							Exit
						EndIf
						
						dbSelectArea("SG1")
						dbSkip()
					EndDo
					
				EndIf
				
				If (aCols[_nX][aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_QTDE"})] / aCols[_nX][aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_CAPA"})]) = 1 .And. !_lEmbRecup .And. GetAcolsND() < 2		// APENAS 1 TAMBOR NAO RECUPERADO, OU SEJA, TAMBOR NOVO
					
					If !M->UA_VQ_AMOS$"S" .and. aCols[_nX][aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_VRUN"})] < aCols[_nX][aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_PR_C"})] .And. aCols[_nX][aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_VRUN"})] < (If(aCols[_nX][aScan(aHeader, {|x| AllTrim(x[2])=="UB_VQ_MOED"})]="2", 1, Posicione("SM2", 1, Dtos(dDataBase), "M2_MOEDA2" )) * SB1->B1_VQ_PRMI )
						//If !M->UA_VQ_AMOS$"S" .and. aCols[_nX][aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_TABE"})]>"C" .and. aCols[_nX][aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_VRUN"})] < (If(aCols[_nX][aScan(aHeader, {|x| AllTrim(x[2])=="UB_VQ_MOED"})]="2", 1, Posicione("SM2", 1, Dtos(dDataBase), "M2_MOEDA2" )) * SB1->B1_VQ_PRMI )
						If At(Alltrim(aCols[_nX][aScan(aHeader,{|x| Alltrim(x[2])=="UB_PRODUTO"})])+" é TAMBOR. O preço de venda está abaixo do preço mínimo da política comercial.", _cMsgInfo1)=0
							_cMsgInfo1 += Alltrim(aCols[_nX][aScan(aHeader,{|x| Alltrim(x[2])=="UB_PRODUTO"})])+" é TAMBOR. O preço de venda está abaixo do preço mínimo da política comercial."+_cEol+_cEol
							_cMsgInfo2 += _cMsgInfo1
							_cMsgInfo1 := ""
							_lAleMsg   := .T.
							_cCodMot += "41C1|"
							
							If SC5->(DbSeek(xFilial("SC5")+M->UA_NUMSC5))
								If At("41C1|", SC5->C5_VQ_MOT)=0
									RecLock("SC5",.F.)
									SC5->C5_VQ_MOT	:=	ALLTRIM(SC5->C5_VQ_MOT)+"41C1|"	//VALIDACAO EFETUADA NO DOCUMENTO
									MsUnLock()
								EndIf
							EndIf
						EndIf
					EndIf
				EndIf
				
				If _lEmbRecup	// TAMBOR RECUPERADO
					
					If !M->UA_VQ_AMOS$"S" .and. aCols[_nX][aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_VRUN"})] >= aCols[_nX][aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_PR_C"})] .Or. aCols[_nX][aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_VRUN"})] < aCols[_nX][aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_PR_D"})]
						
						//If !M->UA_VQ_AMOS$"S" .and. aCols[_nX][aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_TABE"})]<>"D"
						If At(Alltrim(aCols[_nX][aScan(aHeader,{|x| Alltrim(x[2])=="UB_PRODUTO"})])+" é TAMBOR RECUPERADO. Só é permitido a venda na tabela de preço D.", _cMsgInfo1)=0
							_cMsgInfo1 += Alltrim(aCols[_nX][aScan(aHeader,{|x| Alltrim(x[2])=="UB_PRODUTO"})])+" é TAMBOR RECUPERADO. Só é permitido a venda na tabela de preço D."+_cEol+_cEol
							_cMsgInfo2 += _cMsgInfo1
							_cMsgInfo1 := ""
							_lAleMsg   := .T.
							_cCodMot += "41O1|"
							
							If SC5->(DbSeek(xFilial("SC5")+M->UA_NUMSC5))
								If At("41O1|", SC5->C5_VQ_MOT)=0
									RecLock("SC5",.F.)
									SC5->C5_VQ_MOT	:=	ALLTRIM(SC5->C5_VQ_MOT)+"41O1|"		//VALIDACAO EFETUADA EM DOCUMENTO
									MsUnLock()
								EndIf
							EndIf
						EndIf
					EndIf
					
					
					If !M->UA_VQ_AMOS$"S" .and. (aCols[_nX][aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_QTDE"})] / aCols[_nX][aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_CAPA"})]) < _nQtdTbRec	// TAMBOR RECUPERADO - QUANTIDADE MINIMA PARA VENDA
						If At(Alltrim(aCols[_nX][aScan(aHeader,{|x| Alltrim(x[2])=="UB_PRODUTO"})])+" é TAMBOR RECUPERADO. A quantidade mínima de venda são "+Str(_nQtdTbRec)+" tambores.", _cMsgInfo1)=0
							_cMsgInfo1 += Alltrim(aCols[_nX][aScan(aHeader,{|x| Alltrim(x[2])=="UB_PRODUTO"})])+" é TAMBOR RECUPERADO. A quantidade mínima de venda são "+Str(_nQtdTbRec)+" tambores."+_cEol+_cEol
							_cMsgInfo2 += _cMsgInfo1
							_cMsgInfo1 := ""
							_lAleMsg   := .T.
							_cCodMot += "41O2|"
							
							If SC5->(DbSeek(xFilial("SC5")+M->UA_NUMSC5))
								If At("41O2|", SC5->C5_VQ_MOT)=0
									RecLock("SC5",.F.)
									SC5->C5_VQ_MOT	:=	ALLTRIM(SC5->C5_VQ_MOT)+"41O2|"		//VALIDACAO EFETUADA EM DOCUMENTO
									MsUnLock()
								EndIf
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf
			
			//----> FIM ITEM 4.1.C / 4.1.O - POLITICA COMERCIAL - TAMBORES NOVOS E RECUPERADOS
			
			
			//----> INICIO ITEM 4.4.J - POLITICA COMERCIAL - LICENCAS POLICIA FEDERAL/EXERCITO
			SB1->(DbSeek(xFilial("SB1")+aCols[_nX][aScan(aHeader,{|x| Alltrim(x[2])=="UB_PRODUTO"})]))
			SB5->(DbSeek(xFilial("SB5")+aCols[_nX][aScan(aHeader,{|x| Alltrim(x[2])=="UB_PRODUTO"})]))
			
			If SB5->B5_PRODPF == "S"
				_nQtdPolFed += aCols[_nX][aScan(aHeader,{|x| Alltrim(x[2])=="UB_QUANT"})]
				If !M->UA_VQ_AMOS$"S" .and. aCols[_nX][aScan(aHeader,{|x| Alltrim(x[2])=="UB_QUANT"})] > SB5->B5_VQ_QTPF
					If Empty(SA1->A1_VQ_LIPF) .And. At(aCols[_nX][aScan(aHeader,{|x| Alltrim(x[2])=="UB_PRODUTO"})]+" - Cliente não possui LICENÇA POLÍCIA FEDERAL.", _cMsgInfo1)=0
						_cMsgInfo1 += Alltrim(aCols[_nX][aScan(aHeader,{|x| Alltrim(x[2])=="UB_PRODUTO"})])+" - Cliente não possui LICENÇA POLÍCIA FEDERAL."+_cEol+_cEol
						_cMsgInfo2 += _cMsgInfo1
						_cMsgInfo1 := ""
						_lAleMsg   := .T.
						_lRet	   := .F.
						_cCodMot += "44J1|"
						
						If SC5->(DbSeek(xFilial("SC5")+M->UA_NUMSC5))
							If At("44J1|", SC5->C5_VQ_MOT)=0
								RecLock("SC5",.F.)
								SC5->C5_VQ_MOT	:=	ALLTRIM(SC5->C5_VQ_MOT)+"44J1|"		//VALIDACAO EFETUADA EM DOCUMENTO
								MsUnLock()
							EndIf
						EndIf
					ElseIf SA1->A1_VQ_DLPF < Date() .And. At(aCols[_nX][aScan(aHeader,{|x| Alltrim(x[2])=="UB_PRODUTO"})]+" - Cliente com LICENÇA POLÍCIA FEDERAL VENCIDA.", _cMsgInfo1)=0
						_cMsgInfo1 += Alltrim(aCols[_nX][aScan(aHeader,{|x| Alltrim(x[2])=="UB_PRODUTO"})])+" - Cliente com LICENÇA POLÍCIA FEDERAL VENCIDA."+_cEol+_cEol
						_cMsgInfo2 += _cMsgInfo1
						_cMsgInfo1 := ""
						_lAleMsg   := .T.
						_lRet	   := .F.
						_cCodMot += "44J2|"
						
						If SC5->(DbSeek(xFilial("SC5")+M->UA_NUMSC5))
							If At("44J2|", SC5->C5_VQ_MOT)=0
								RecLock("SC5",.F.)
								SC5->C5_VQ_MOT	:=	ALLTRIM(SC5->C5_VQ_MOT)+"44J2|"		//VALIDACAO EFETUADA EM DOCUMENTO
								MsUnLock()
							EndIf
						EndIf
					EndIf
					If Empty(SA4->A4_VQ_LIPF) .And. At(aCols[_nX][aScan(aHeader,{|x| Alltrim(x[2])=="UB_PRODUTO"})]+" - Transportadora não possui LICENÇA POLÍCIA FEDERAL.", _cMsgInfo1)=0
						_cMsgInfo1 += Alltrim(aCols[_nX][aScan(aHeader,{|x| Alltrim(x[2])=="UB_PRODUTO"})])+" - Transportadora não possui LICENÇA POLÍCIA FEDERAL."+_cEol+_cEol
						_cMsgInfo2 += _cMsgInfo1
						_cMsgInfo1 := ""
						_lAleMsg   := .T.
						_lRet	   := .F.
						_cCodMot += "44J3|"
						
						If SC5->(DbSeek(xFilial("SC5")+M->UA_NUMSC5))
							If At("44J3|", SC5->C5_VQ_MOT)=0
								RecLock("SC5",.F.)
								SC5->C5_VQ_MOT	:=	ALLTRIM(SC5->C5_VQ_MOT)+"44J3|"		//VALIDACAO EFETUADA EM DOCUMENTO
								MsUnLock()
							EndIf
						EndIf
					ElseIf SA4->A4_VQ_DLPF < Date() .And. At(aCols[_nX][aScan(aHeader,{|x| Alltrim(x[2])=="UB_PRODUTO"})]+" - Transportadora com LICENÇA POLÍCIA FEDERAL VENCIDA.", _cMsgInfo1)=0
						_cMsgInfo1 += Alltrim(aCols[_nX][aScan(aHeader,{|x| Alltrim(x[2])=="UB_PRODUTO"})])+" - Transportadora com LICENÇA POLÍCIA FEDERAL VENCIDA."+_cEol+_cEol
						_cMsgInfo2 += _cMsgInfo1
						_cMsgInfo1 := ""
						_lAleMsg   := .T.
						_lRet	   := .F.
						_cCodMot += "44J4|"
						
						If SC5->(DbSeek(xFilial("SC5")+M->UA_NUMSC5))
							If At("44J4|", SC5->C5_VQ_MOT)=0
								RecLock("SC5",.F.)
								SC5->C5_VQ_MOT	:=	ALLTRIM(SC5->C5_VQ_MOT)+"44J4|"		//VALIDACAO EFETUADA EM DOCUMENTO
								MsUnLock()
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf
			
			
			If SB5->B5_PRODEX == "S"
				_nQtdExercito += aCols[_nX][aScan(aHeader,{|x| Alltrim(x[2])=="UB_QUANT"})]
				If !M->UA_VQ_AMOS$"S" .and. aCols[_nX][aScan(aHeader,{|x| Alltrim(x[2])=="UB_QUANT"})] > SB5->B5_VQ_QTEX
					If Empty(SA1->A1_VQ_LIEX) .And. At(aCols[_nX][aScan(aHeader,{|x| Alltrim(x[2])=="UB_PRODUTO"})]+" - Cliente não possui LICENÇA EXÉRCITO.", _cMsgInfo1)=0
						_cMsgInfo1 += Alltrim(aCols[_nX][aScan(aHeader,{|x| Alltrim(x[2])=="UB_PRODUTO"})])+" - Cliente não possui LICENÇA EXÉRCITO."+_cEol+_cEol
						_cMsgInfo2 += _cMsgInfo1
						_cMsgInfo1 := ""
						_lAleMsg   := .T.
						_lRet	   := .F.
						_cCodMot += "44J5|"
						
						If SC5->(DbSeek(xFilial("SC5")+M->UA_NUMSC5))
							If At("44J5|", SC5->C5_VQ_MOT)=0
								RecLock("SC5",.F.)
								SC5->C5_VQ_MOT	:=	ALLTRIM(SC5->C5_VQ_MOT)+"44J5|"		//VALIDACAO EFETUADA EM DOCUMENTO
								MsUnLock()
							EndIf
						EndIf
						
					ElseIf SA1->A1_VQ_DLEX < Date() .And. At(aCols[_nX][aScan(aHeader,{|x| Alltrim(x[2])=="UB_PRODUTO"})]+" - Cliente com LICENÇA EXÉRCITO VENCIDA.", _cMsgInfo1)=0
						_cMsgInfo1 += Alltrim(aCols[_nX][aScan(aHeader,{|x| Alltrim(x[2])=="UB_PRODUTO"})])+" - Cliente com LICENÇA EXÉRCITO VENCIDA."+_cEol+_cEol
						_cMsgInfo2 += _cMsgInfo1
						_cMsgInfo1 := ""
						_lAleMsg   := .T.
						_lRet	   := .F.
						_cCodMot += "44J6|"
						
						If SC5->(DbSeek(xFilial("SC5")+M->UA_NUMSC5))
							If At("44J6|", SC5->C5_VQ_MOT)=0               	
								RecLock("SC5",.F.)
								SC5->C5_VQ_MOT	:=	ALLTRIM(SC5->C5_VQ_MOT)+"44J6|"		//VALIDACAO EFETUADA EM DOCUMENTO
								MsUnLock()
							EndIf
						EndIf
					EndIf
					
					If Empty(SA4->A4_VQ_LIEX) .And. At(aCols[_nX][aScan(aHeader,{|x| Alltrim(x[2])=="UB_PRODUTO"})]+" - Transportadora não possui LICENÇA EXÉRCITO.", _cMsgInfo1)=0
						_cMsgInfo1 += Alltrim(aCols[_nX][aScan(aHeader,{|x| Alltrim(x[2])=="UB_PRODUTO"})])+" - Transportadora não possui LICENÇA EXÉRCITO."+_cEol+_cEol
						_cMsgInfo2 += _cMsgInfo1
						_cMsgInfo1 := ""
						_lAleMsg   := .T.
						_lRet	   := .F.
						_cCodMot += "44J7|"
						
						If SC5->(DbSeek(xFilial("SC5")+M->UA_NUMSC5))
							If At("44J7|", SC5->C5_VQ_MOT)=0
								RecLock("SC5",.F.)
								SC5->C5_VQ_MOT	:=	ALLTRIM(SC5->C5_VQ_MOT)+"44J7|"		//VALIDACAO EFETUADA EM DOCUMENTO
								MsUnLock()
							EndIf
						EndIf
					ElseIf SA4->A4_VQ_DLPF < Date() .And. At(aCols[_nX][aScan(aHeader,{|x| Alltrim(x[2])=="UB_PRODUTO"})]+" - Transportadora com LICENÇA EXÉRCITO VENCIDA.", _cMsgInfo1)=0
						_cMsgInfo1 += Alltrim(aCols[_nX][aScan(aHeader,{|x| Alltrim(x[2])=="UB_PRODUTO"})])+" - Transportadora com LICENÇA EXÉRCITO VENCIDA."+_cEol+_cEol
						_cMsgInfo2 += _cMsgInfo1
						_cMsgInfo1 := ""
						_lAleMsg   := .T.
						_lRet	   := .F.
						_cCodMot += "44J8|"
						
						If SC5->(DbSeek(xFilial("SC5")+M->UA_NUMSC5))
							If At("44J8|", SC5->C5_VQ_MOT)=0
								RecLock("SC5",.F.)
								SC5->C5_VQ_MOT	:=	ALLTRIM(SC5->C5_VQ_MOT)+"44J8|"		//VALIDACAO EFETUADA EM DOCUMENTO
								MsUnLock()
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf
			//----> FIM ITEM 4.4.J - POLITICA COMERCIAL - LICENCAS POLICIA FEDERAL/EXERCITO
			
			//----> INICIO ITEM 9.9.E - EXTRA POLITICA COMERCIAL - PRECO DE VENDA MENOR QUE TABELA D
			If !M->UA_VQ_AMOS$"S" .and. aCols[_nX][aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_VRUN"})] < aCols[_nX][aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_PR_D"})] .And. !_lEmbRecup
				If At(Alltrim(aCols[_nX][aScan(aHeader,{|x| Alltrim(x[2])=="UB_PRODUTO"})])+". Só é permitido preço de venda acima da tabela D.", _cMsgInfo1)=0
					_cMsgInfo1 += Alltrim(aCols[_nX][aScan(aHeader,{|x| Alltrim(x[2])=="UB_PRODUTO"})])+". Só é permitido preço de venda acima da tabela D."+_cEol+_cEol
					_cMsgInfo2 += _cMsgInfo1
					_cMsgInfo1 := ""
					_lAleMsg   := .T.
					_cCodMot += "99E|"
					
					If SC5->(DbSeek(xFilial("SC5")+M->UA_NUMSC5))
						If At("99E|", SC5->C5_VQ_MOT)=0
							RecLock("SC5",.F.)
							SC5->C5_VQ_MOT	:=	ALLTRIM(SC5->C5_VQ_MOT)+"99E|"		//VALIDACAO EFETUADA EM DOCUMENTO
							MsUnLock()
						EndIf
					EndIf
				EndIf
			EndIf
			//----> FIM ITEM 9.9.E - EXTRA POLITICA COMERCIAL - PRECO DE VENDA MENOR QUE TABELA D
			
		EndIf
	Next _nX
	
	
	//----> INICIO ITEM 4.1.Z.2 - POLITICA COMERCIAL - PESO ABAIXO DE 100 KG - TABELA A - FRETE FOB
	If _nPesoLiq < _nQtdMin
		For _nX := 1 to Len(aCols) // Varre todas as linhas do aCols.
			If !GdDeleted(_nX,aHeader,aCols)
				If !M->UA_VQ_AMOS$"S" .and. aCols[_nX][aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_TABE"})]<>"A"
					If At("TABELA DE PRECO - Só é permitido a venda na tabela de preço A para essa quantidade.", _cMsgInfo1)=0
						_cMsgInfo1 += "TABELA DE PRECO - Só é permitido a venda na tabela de preço A para essa quantidade."+_cEol+_cEol
						_cMsgInfo2 += _cMsgInfo1
						_cMsgInfo1 := ""
						_lAleMsg   := .T.
						_cCodMot += "41Z2|"
						
						If SC5->(DbSeek(xFilial("SC5")+M->UA_NUMSC5))
							If At("41Z2|", SC5->C5_VQ_MOT)=0
								RecLock("SC5",.F.)
								SC5->C5_VQ_MOT	:=	ALLTRIM(SC5->C5_VQ_MOT)+"41Z2|"	//VALIDACAO EFETUADA NO DOCUMENTO
								MsUnLock()
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf
		Next nX
	EndIf
	//----> FIM ITEM 4.1.Z.2 - POLITICA COMERCIAL - PESO ABAIXO DE 100 KG - TABELA A - FRETE FOB
	
	
	//----> INICIO ITEM 4.1.I - POLITICA COMERCIAL - MOEDAS DIFERENTES
	_lMoeda := .F.
	If M->UA_OPER == "1"
		For _nX := 1 to Len(aCols) // Varre todas as linhas do aCols.
			If !GdDeleted(_nX,aHeader,aCols)
				If !_lMoeda
					M->UA_MOEDA := Val(aCols[_nX][aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_MOED"})])
					_lMoeda := .T.
				Else
					If M->UA_MOEDA != Val(aCols[_nX][aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_MOED"})])
						_lDifMoeda := .T.
						Exit
					EndIf
				EndIf
			EndIf
		Next nX
		
		If _lDifMoeda
			If At("MOEDA - Preços com moedas diferentes não permitido no mesmo atendimento.",_cMsgInfo1)=0
				_cMsgInfo1 += "MOEDA - Preços com moedas diferentes não permitido no mesmo atendimento."+_cEol+_cEol
				_cMsgInfo2 += _cMsgInfo1
				_cMsgInfo1 := ""
				_lRet      := .F.
				_lAleMsg   := .T.
				_cCodMot += "41I|"
				
				If SC5->(DbSeek(xFilial("SC5")+M->UA_NUMSC5))
					If At("41I|", SC5->C5_VQ_MOT)=0
						RecLock("SC5",.F.)
						SC5->C5_VQ_MOT	:=	ALLTRIM(SC5->C5_VQ_MOT)+"41I|"	//VALIDACAO EFETUADA NO DOCUMENTO
						MsUnLock()
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf
	//----> FIM ITEM 4.1.I - POLITICA COMERCIAL - MOEDAS DIFERENTES
	
	
	//----> INICIO ITEM 4.1.A - POLITICA COMERCIAL - DUPLICATA MINIMA
	If INCLUI .Or. ALTERA
		
		_aVencto := Condicao(1000,M->UA_CONDPG,,dDataBase)
		
		_nQtdDupl:= Len(_aVencto)
		
		_nTotal:=0
		
		For _nDupl:=1 To Len(aCols)
			_nTotal+= aCols[_nDupl][aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_QTDE"})]*aCols[_nDupl][aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_VRUN"})]
			
			//----> VERIFICA SE NAO EXISTE PEDIDO DE VENDA E SOMA O ATENDIMENTO (USADO NA ROTINA DE CREDITO U_VERQUICRED.PRW)
			If Empty(M->UA_NUMSC5)
				_nTotAtend+= Iif(M->UA_MOEDA=2,aCols[_nDupl][aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_QTDE"})]*aCols[_nDupl][aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_VRUN"})]*M->UA_VQ_TXDO,aCols[_nDupl][aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_QTDE"})]*aCols[_nDupl][aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_VRUN"})])
			EndIf
		Next
		
		_lVlMinD := If((_nTotal/_nQtdDupl)<(_nValMinDupl/If(M->UA_MOEDA=2, Posicione("SM2", 1, Dtos(dDataBase), "M2_MOEDA2"), 1)),.f.,.t.)
		
		
		If !M->UA_VQ_AMOS$"S" .and. !_lVlMinD
			
			If !M->UA_CONDPG$"001" 	// PAGAMENTO A VISTA
				
				IF At("DUPLICATA - Valor mínimo da parcela deve ser R$ ", _cMsgInfo1)=0
					_cMsgInfo1 += "DUPLICATA - Valor mínimo da parcela deve ser R$ "+AllTrim(Str(_nValMinDupl,12,2))+_cEol+_cEol
					_cMsgInfo2 += _cMsgInfo1
					_cMsgInfo1 := ""
					_lAleMsg   := .T.
					_cCodMot := "41A|"
					
					If SC5->(DbSeek(xFilial("SC5")+M->UA_NUMSC5))
						If At("41A|", SC5->C5_VQ_MOT)=0
							RecLock("SC5",.F.)
							SC5->C5_VQ_MOT	:=	ALLTRIM(SC5->C5_VQ_MOT)+"41A|"	//VALIDACAO EFETUADA NO DOCUMENTO
							MsUnLock()
						EndIf
					EndIf
				EndIf
			Else
				If M->UA_VQ_FRET <> 'C' .Or. M->UA_VQ_FCLI <> 'R'
					IF At("A VISTA - PARA PAGAMENTOS A VISTA COM VALOR", _cMsgInfo1)=0
						_cMsgInfo1 += "A VISTA - PARA PAGAMENTOS A VISTA COM VALOR INFERIOR AO MINIMO DE  "+AllTrim(Str(_nValMinDupl,12,2)) + ", A MODALIDADE DE FRETE DEVE SER CLIENTE - RETIRA (FOB) " +_cEol+_cEol
						_cMsgInfo2 += _cMsgInfo1
						_cMsgInfo1 := ""
						_lAleMsg   := .T.
						_cCodMot := "41A2|"
						
						If SC5->(DbSeek(xFilial("SC5")+M->UA_NUMSC5))
							If At("41A2|", SC5->C5_VQ_MOT)=0
								RecLock("SC5",.F.)
								SC5->C5_VQ_MOT	:=	ALLTRIM(SC5->C5_VQ_MOT)+"41A2|"	//VALIDACAO EFETUADA NO DOCUMENTO
								MsUnLock()
							EndIf
						EndIf
						
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf
	//----> FIM ITEM 4.1.A - POLITICA COMERCIAL - DUPLICATA MINIMA
	
	
	//----> INICIO ITEM 4.1.B - POLITICA COMERCIAL - PARCELAMENTO MAXIMO
	If !M->UA_VQ_AMOS$"S" .and. _nQtdDupl > _nQtdMaxDupl .And. At("DUPLICATA - Parcelamento máximo deve ser ", _cMsgInfo1)=0
		_cMsgInfo1 += "DUPLICATA - Parcelamento máximo deve ser "+AllTrim(Str(_nQtdMaxDupl))+" parcelas."+_cEol+_cEol
		_cMsgInfo2 += _cMsgInfo1
		_cMsgInfo1 := ""
		_cCodMot   := "41B|"
		_lAleMsg   := .T.
		
		If SC5->(DbSeek(xFilial("SC5")+M->UA_NUMSC5))
			If At("41B|", SC5->C5_VQ_MOT)=0
				RecLock("SC5",.F.)
				SC5->C5_VQ_MOT	:= ALLTRIM(SC5->C5_VQ_MOT)+"41B|"	//VALIDACAO EFETUADA NO DOCUMENTO
				MsUnLock()
			EndIf
		EndIf
	EndIf
	//----> FIM ITEM 4.1.B - POLITICA COMERCIAL - PARCELAMENTO MAXIMO
	
	//----> INICIO ITEM 4.1 - POLITICA COMERCIAL - PESO MINIMO 100 KG
	If !M->UA_VQ_AMOS$"S" .and. M->UA_PESOL < _nQtdMin
		IF !M->UA_TPFRETE $ "F"
			If At("FRETE NÃO PERMITIDO - Para entregar a mercadoria, o peso mínimo é "+Str(_nQtdMin)+" quilos.", _cMsgInfo1)=0
				_cMsgInfo1 += "FRETE NÃO PERMITIDO - Para entregar a mercadoria, o peso mínimo é "+Str(_nQtdMin)+" quilos."+_cEol+_cEol
				_cMsgInfo2 += _cMsgInfo1
				_cMsgInfo1 := ""
				_lAleMsg := .T.
				_cCodMot += "41Z1|"
				
				If SC5->(DbSeek(xFilial("SC5")+M->UA_NUMSC5))
					If At("41Z1|", SC5->C5_VQ_MOT)=0
						RecLock("SC5",.F.)
						SC5->C5_VQ_MOT	:=	ALLTRIM(SC5->C5_VQ_MOT)+"41Z1|"	//VALIDACAO EFETUADA EM DOCUMENTO
						MsUnLock()
					EndIf
				EndIf
			EndIf
		EndIf
	EndIF
	//----> FIM ITEM 4.1 - POLITICA COMERCIAL - PESO MINIMO 100 KG
	
	
	
	//----> ATUALIZA PESO LIQUIDO E BRUTO NO ATENDIMENTO (TABELA SUA)
	If _lGrava
		M->UA_PESOL := _nPesoLiq
		M->UA_PESOB := _nPesoLiq + _nPesoBru
	EndIf
	
	
	//----> VERIFICA REGRAS FINANCEIRAS
	If !M->UA_VQ_AMOS$"S"
		//----> REGRA DESATIVADA CONFORME SOLICITACAO ANDREIA DUBOVISKY - 14/08/2020 - RICARDO SOUZA
		//U_VERQUICRED(M->UA_CLIENTE,M->UA_LOJA,M->UA_NUMSC5)
		//----> REGRA DESATIVADA CONFORME SOLICITACAO ANDREIA DUBOVISKY - 14/08/2020 - RICARDO SOUZA
	EndIf
	
	//----> MOSTRA AS MENSAGENS DE BLOQUEIO
	If _lAleMsg
		
		_cMsgFim += _cEol+_cEol+_cMsgInfo2
	
		Define Font oFont Name "Mono AS" Size 0, 15
		
		If !Empty(Alltrim(_cMsgFim))
			Define MsDialog oDlg Title "Atenção" From 3, 0 to 440, 417 Pixel
				@ 5, 5 Get oMemo Var _cMsgFim Memo Size 200, 195 Of oDlg Pixel
				oMemo:bRClicked := { || AllwaysTrue() }
				oMemo:oFont     := oFont
				Define SButton From 205, 175 Type  1 Action oDlg:End() Enable Of oDlg Pixel // Apaga
			Activate MsDialog oDlg Center
		EndIf	
	
		//If !Empty(Alltrim(_cMsgFim))
		//	MsgAlert(_cMsgFim,"Atencao!!!")
		//EndIf
	
	EndIf
	
	SA1->(RestArea(aAreaSa1))
	SA4->(RestArea(aAreaSa4))
	SB1->(RestArea(aAreaSb1))
	SB5->(RestArea(aAreaSb5))
	
Return(_lRet)



User Function VISITA(_cProduto, _nQuant, _cUm, _nQtdMaxVis)

Local _lRet		:= .t.
Local _aAreaSb1  := SB1->(GetArea())

SB1->(DbSeek( xFilial("SB1")+_cProduto))

_nQtdMaxVis := SB1->B1_VQ_QTSV	// QUANTIDADE MAXIMA SEM VISITA


//----> VERIFICA SE A QUANTIDADE MAXIMA SEM VISITA MAIOR QUE ZERO
If SB1->B1_VQ_QTSV <> 0
	
	//----> SE A UNIDADE DE MEDIDA FOR DIFERENTE FAZ A CONVERSAO
	If _cUm <> SB1->B1_UM
		If SB1->B1_TIPCONV="D" .And. SB1->B1_CONV <> 0
			_nQtdMaxVis := _nQtdMaxVis/SB1->B1_CONV
		ElseIf SB1->B1_TIPCONV="M" .And. SB1->B1_CONV <> 0
			_nQtdMaxVis := _nQtdMaxVis*SB1->B1_CONV
		EndIf
	EndIf
	
	//----> VERIFICA SE NAO HOUVE VISITA OU SE HOUVE A MAIS DE TRES MESES
	If (Empty(SA1->A1_VQ_VISI) .Or. ((dDataBase-SA1->A1_VQ_VISI)/30)>3) .And. _nQuant > _nQtdMaxVis
		_lRet:=.f.
	EndIf
	
EndIf

SB1->(RestArea(_aAreaSb1))

Return _lRet


/************************/
User Function MunPad(_P1)
/************************/

/*
_P1[1] = Estado
_P1[2] = Cod Municipio
*/
Local _lRet:=.t.
Local aCidPad	:=	{}
Aadd( aCidPad,{'SP','03901','ARUJA'} )
Aadd( aCidPad,{'SP','05708','BARUERI'} )
Aadd( aCidPad,{'SP','06607','BIRITIBA-MIRIM'} )
Aadd( aCidPad,{'SP','09007','CAIEIRAS'} )
Aadd( aCidPad,{'SP','09205','CAJAMAR'} )
Aadd( aCidPad,{'SP','10609','CARAPICUIBA'} )
Aadd( aCidPad,{'SP','13009','COTIA'} )
Aadd( aCidPad,{'SP','13801','DIADEMA'} )
Aadd( aCidPad,{'SP','15004','EMBU'} )
Aadd( aCidPad,{'SP','15103','EMBU-GUACU'} )
Aadd( aCidPad,{'SP','15707','FERRAZ DE VASCONCELOS'} )
Aadd( aCidPad,{'SP','16309','FRANCISCO MORATO'} )
Aadd( aCidPad,{'SP','16408','FRANCO DA ROCHA'} )
Aadd( aCidPad,{'SP','18305','GUARAREMA'} )
Aadd( aCidPad,{'SP','18800','GUARULHOS'} )
Aadd( aCidPad,{'SP','22208','ITAPECERICA DA SERRA'} )
Aadd( aCidPad,{'SP','22505','ITAPEVI'} )
Aadd( aCidPad,{'SP','23107','ITAQUAQUECETUBA'} )
Aadd( aCidPad,{'SP','25003','JANDIRA'} )
Aadd( aCidPad,{'SP','26209','JUQUITIBA'} )
Aadd( aCidPad,{'SP','28502','MAIRIPORA'} )
Aadd( aCidPad,{'SP','29401','MAUA'} )
Aadd( aCidPad,{'SP','30607','MOGI DAS CRUZES'} )
Aadd( aCidPad,{'SP','34401','OSASCO'} )
Aadd( aCidPad,{'SP','39103','PIRAPORA DO BOM JESUS'} )
Aadd( aCidPad,{'SP','39806','POA'} )
Aadd( aCidPad,{'SP','43303','RIBEIRAO PIRES'} )
Aadd( aCidPad,{'SP','44103','RIO GRANDE DA SERRA'} )
Aadd( aCidPad,{'SP','45001','SALESOPOLIS'} )
Aadd( aCidPad,{'SP','46801','SANTA ISABEL'} )
Aadd( aCidPad,{'SP','47304','SANTANA DE PARNAIBA'} )
Aadd( aCidPad,{'SP','47809','SANTO ANDRE'} )
Aadd( aCidPad,{'SP','48708','SAO BERNARDO DO CAMPO'} )
Aadd( aCidPad,{'SP','48807','SAO CAETANO DO SUL'} )
Aadd( aCidPad,{'SP','49953','SAO LOURENCO DA SERRA'} )
Aadd( aCidPad,{'SP','50308','SAO PAULO'} )
Aadd( aCidPad,{'SP','52502','SUZANO'} )
Aadd( aCidPad,{'SP','52809','TABOAO DA SERRA'} )
Aadd( aCidPad,{'SP','56453','VARGEM GRANDE PAULISTA'} )
_lRet:=(aScan(aCidPad, {|z|z[1]=_P1[1] .And. z[2]=_P1[2]})<>0)

Return _lRet

/*******************************/
User Function DCVendNeg(_P, _P2)
/*******************************/
Local lRet:=.f.
Local cQryZ5:=""
Local cQryZ4:=""
Local nTotNeg:=0
Local nPMoeda:=aScan( aHeader, {|Z|AllTrim(Z[2])=="UB_VQ_MOED"} )
Local nVlDif:=0

For nL:=1 To Len(aCols)
	nVlDif+=(((aCols[nL][aScan(aHeader,{|Z| Alltrim(Z[2])=="UB_VQ_QTDE"})] * (aCols[nL][aScan( aHeader, {|Z|AllTrim(Z[2])=="UB_VQ_VRUN"} )]-aCols[nL][aScan(aHeader, {|Z| AllTrim(Z[2])=="UB_VQ_VAL" })]))) * If(aCols[nL][aScan( aHeader, {|Z|AllTrim(Z[2])=="UB_VQ_MOED"} )]="2", Posicione("SM2", 1, Dtos(dDataBase), "M2_MOEDA2"), 1))
Next

If nVlDif<0
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
	lRet:=((nTotNeg+nVlDif)<0)
	VendZ5->(DbCloseArea())
	
EndIf

Return lRet           
                 
//Função para retornar a quantidade de linhas não deletadas no ACols //GetAcolsND : Get Acols Não Deletado
Static Function GetAcolsND()
Local _nQtde := 0                                                                               

For nX := 1 To Len(aCols)
	If aCols[nX][Len(aCols[nX])] == .F.
		 _nQtde := _nQtde + 1
	EndIf	
Next nX
                
Return _nQtde
