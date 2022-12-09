#Include "RWMAKE.CH"      
#Include "TOPCONN.CH"
#Include "Protheus.Ch"
#include "TbiConn.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  TK271BOK  º Autor ³ Luiz Alberto    º Data ³ 10/06/2014  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Antes de Gravar o Orcamento, Valida Valores dos Itens  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ 													          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/            
User Function TK271BOK(_nOpc)
Local aAreaSUA	:= SUA->(GetArea())
Local aAreaSUB 	:= SUB->(GetArea())
Local _nPosTotal:= aScan(aHeader,{|x| AllTrim(x[2])=="UB_VLRITEM"})
Local _nPosUnit := aScan(aHeader,{|x| AllTrim(x[2])=="UB_VRUNIT"})
Local _nPosProd := aScan(aHeader,{|x| AllTrim(x[2])=="UB_PRODUTO"})
Local _nPosDesc := aScan(aHeader,{|x| AllTrim(x[2])=="UB_DESC"})
Local _nPosVlDes:= aScan(aHeader,{|x| AllTrim(x[2])=="UB_VALDESC"})
Local _nPosQtdVe:= aScan(aHeader,{|x| AllTrim(x[2])=="UB_QUANT"})
Local _nPosOpcio:= aScan(aHeader,{|x| AllTrim(x[2])=="UB_OPC"})
Local _nPosTES  := aScan(aHeader,{|x| AllTrim(x[2])=="UB_TES"})
Local _nPosCFOP := aScan(aHeader,{|x| AllTrim(x[2])=="UB_CF"})
Local _nPosItem := aScan(aHeader,{|x| AllTrim(x[2])=="UB_ITEM"})
Local _nPosInic := aScan(aHeader,{|x| AllTrim(x[2])=="UB_XINIC"})
Local _nPosFim  := aScan(aHeader,{|x| AllTrim(x[2])=="UB_XFIM"})
Local _nPosPers := aScan(aHeader,{|x| AllTrim(x[2])=="UB_XLACRE"})
Local _nPosEmba := aScan(aHeader,{|x| AllTrim(x[2])=="UB_XEMBALA"})
Local _nPosPdCli:= aScan(aHeader,{|x| AllTrim(x[2])=="UB_PEDCLI"})
Local _nPosItCli:= aScan(aHeader,{|x| AllTrim(x[2])=="UB_ITEMCLI"})   
Local _nPosItEnt:= aScan(aHeader,{|x| AllTrim(x[2])=="UB_DTENTRE"})   
Local nPosDel	:= Len(aHeader)+1
Local _nPosNumOp:= aScan(aHeader,{|x| AllTrim(x[2])=="UB_NUMOP"})
Local _N        := N //Guarda posicao atual da GetDados
Local _lRet 		:= .T.
Local cOper		:= M->UA_OPER
Local cNumSc5   := M->UA_NUMSC5
Local lEmailSup :=  SuperGetMV("MV_MTLEPM", ,.t.)	// Envia Email de Aviso de Valores Menores que o Preco de Tabela aos Supervisores e Gerentes
Private aProdDiv := {}

If _nOpc == 2 // Visualização de Orçamento
	Return _lRet
Endif

// Se For a Tela de Atendimento Telemarketing então não é orçamento retorna verdadeiro
If Empty(_nPosUnit)
	nPosAssunto:= aScan(aHeader,{|x| AllTrim(x[2])=="UD_ASSUNTO"})
	nPosProduto:= aScan(aHeader,{|x| AllTrim(x[2])=="UD_PRODUTO"})
	nPosOcorren:= aScan(aHeader,{|x| AllTrim(x[2])=="UD_OCORREN"})
	nPosSolucao:= aScan(aHeader,{|x| AllTrim(x[2])=="UD_SOLUCAO"})
	nPosOperado:= aScan(aHeader,{|x| AllTrim(x[2])=="UD_OPERADO"})
	nPosStatus := aScan(aHeader,{|x| AllTrim(x[2])=="UD_STATUS"})
	nPosObserva:= aScan(aHeader,{|x| AllTrim(x[2])=="UD_OBS"})

	aMonta := {}

	// Tratamento WORKFLOW de Chamados        
	If nPosAssunto > 0 	// Se For Uma Inclusao
		For nItem := 1 To Len(aCols)
			If !(aCols[nItem,Len(aHeader)+1]) // Checa se a Linha está Deletada
				AAdd(aMonta,{aCols[nItem,nPosAssunto],;
								aCols[nItem,nPosProduto],;
								aCols[nItem,nPosOcorren],;
								aCols[nItem,nPosSolucao],;
								aCols[nItem,nPosOperado],;
								aCols[nItem,nPosStatus],;
								aCols[nItem,nPosObserva]})
			Endif
	  	Next
	  	aSort(aMonta,,, { |x,y| y[5] > x[5]} )      // Ordena as Linhas do Atendimento Por Operador, Para Agrupar o Envio do Email
	  	
	  	// Inicia Envio de Email do WorkFlow
	  	
	  	cCabecalho := '<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">'
	  	cCabecalho += '    <html>'
	  	cCabecalho += '    <head>'
	  	cCabecalho += '      <meta'
	  	cCabecalho += '     content="text/html; charset=ISO-8859-1"'
	  	cCabecalho += '     http-equiv="content-type">'
	  	cCabecalho += '      <title>WorkFlow Metalacre</title>'
	  	cCabecalho += '    </head>'
	  	cCabecalho += '    <body>'
	  	cCabecalho += '    <table'
	  	cCabecalho += '     style="text-align: left; width: 100%; font-family: Helvetica,Arial,sans-serif;"'
	  	cCabecalho += '     border="1" cellpadding="2" cellspacing="2">'
	  	cCabecalho += '      <tbody>'
	  	cCabecalho += '        <tr style="font-weight: bold;"'
	  	cCabecalho += '     align="center">'
	  	cCabecalho += '          <td'
	  	cCabecalho += '     style="background-color: rgb(255, 255, 255);" colspan="7"'
	  	cCabecalho += '     rowspan="1"><big><big><img'
	  	cCabecalho += '     style="width: 300px; height: 88px;" alt=""'
	  	cCabecalho += '     src="http://www.metalacre.com.br/wp-content/uploads/2015/03/logotipometalacrepeq1.jpg"><br>'
	  	cCabecalho += '          </big></big></td>'
	  	cCabecalho += '        </tr>'
	  	cCabecalho += '        <tr style="font-weight: bold;"'
	  	cCabecalho += '     align="center">'
	  	cCabecalho += '          <td'
	  	cCabecalho += '     style="background-color: rgb(255, 255, 204);" colspan="7"'
	  	cCabecalho += '     rowspan="1"><big><big>WorkFlow'
	  	cCabecalho += '    - Atendimentos</big></big></td>'
	  	cCabecalho += '    </tr>'
	  	cCabecalho += '    <tr>'
	  	cCabecalho += '      <td><small>Atendimento:</small></td>'
	  	cCabecalho += '      <td><small>Data:</small></td>'
	  	cCabecalho += '      <td><small>Operador:</small></td>'
	  	cCabecalho += '      <td colspan="4" rowspan="1"><small>Responsavel:</small></td>'
	  	cCabecalho += '    </tr>'
	  	cCabecalho += '    <tr>'
	  	cCabecalho += '      <td><small>Ligacao:</small></td>'
	  	cCabecalho += '      <td><small>Status:</small></td>'
	  	cCabecalho += '      <td><small>Midia:</small></td>'
	  	cCabecalho += '      <td><small>Comunicacao:</small></td>'
	  	cCabecalho += '      <td colspan="3" rowspan="1"><small>Retorno:</small></td>'
	  	cCabecalho += '    </tr>'
	  	cCabecalho += '    <tr>'
	  	cCabecalho += '      <td><small>Cliente:</small></td>'
	  	cCabecalho += '      <td><small>Contato:</small></td>'
	  	cCabecalho += '      <td><small>Fone:</small></td>'
	  	cCabecalho += '      <td><small>Email:</small></td>'
	  	cCabecalho += '      <td colspan="3" rowspan="1"><small>Cidade/UF:</small></td>'
	  	cCabecalho += '    </tr>'
	  	cCabecalho += '    <tr>'
	  	cCabecalho += '      <td colspan="7" rowspan="1"><small>Observacao:</small></td>'
	  	cCabecalho += '    </tr>'
	  	cCabecalho += '    <tr style="font-weight: bold;"'
	  	cCabecalho += ' align="center">'
	  	cCabecalho += '      <td        '
	  	cCabecalho += ' style="background-color: rgb(255, 255, 204);" colspan="7"'
	  	cCabecalho += ' rowspan="1"><big>Detalhes '
	  	cCabecalho += 'do Atendimento</big></td>'
	  	cCabecalho += '    </tr>'
	  	cCabecalho += '        <tr>'
	  	cCabecalho += '          <td'
	  	cCabecalho += '     style="background-color: rgb(204, 204, 204); font-weight: bold;">Assunto</td>'
	  	cCabecalho += '          <td'
	  	cCabecalho += '     style="background-color: rgb(204, 204, 204); font-weight: bold;">Produto</td>'
	  	cCabecalho += '          <td'
	  	cCabecalho += '     style="background-color: rgb(204, 204, 204); font-weight: bold;">Descricao</td>'
	  	cCabecalho += '          <td'
	  	cCabecalho += '     style="background-color: rgb(204, 204, 204); font-weight: bold;">Ocorrencia</td>'
	  	cCabecalho += '          <td'
	  	cCabecalho += '     style="background-color: rgb(204, 204, 204); font-weight: bold;">Acao</td>'
	  	cCabecalho += '          <td'
	  	cCabecalho += '     style="background-color: rgb(204, 204, 204); font-weight: bold;">Status</td>'
	  	cCabecalho += '          <td'
	  	cCabecalho += '     style="background-color: rgb(204, 204, 204); font-weight: bold;">Observacoes</td>'
	  	cCabecalho += '        </tr>'

		cRodape	:=	'    <tr>'
		cRodape	+=	'      <td'
		cRodape	+=	'       style="background-color: rgb(255, 255, 204);" colspan="7"'
		cRodape	+=	'        rowspan="1"><small><small>Data Envio: Hora Envio:</small></small></td>'
		cRodape	+=	'           </tr>'
		cRodape	+=	'         </tbody>'
		cRodape	+=	'       </table>'
		cRodape	+=	'       <br'
		cRodape	+=	'        style="font-family: Helvetica,Arial,sans-serif;">'
		cRodape	+=	'       </body>'
		cRodape	+=	'       </html>'
	  	
		For nWrk1 := 1 To Len(aMonta)
		  	cItens		:= ''
			cOperado 	:= aMonta[nWrk1,5]
			xCabecalho	:= cCabecalho
			xRodape		:= cRodape
			For nWrk := 1 To Len(aMonta)
				If cOperado == aMonta[nWrk,5]
		  			cItens	+=	'   <tr>'
		  			cItens	+=	'      <td>'+aMonta[nWrk,1]+' '+Capital(Tabela('T1',aMonta[nWrk,1]))+'</td>'
		  			cItens	+=	'      <td>'+aMonta[nWrk,2]+'</td>'
		  			cItens	+=	'      <td>'+Capital(Posicione("SB1",1,xFilial("SB1")+aMonta[nWrk,2],'B1_DESC'))+'</td>'
		  			cItens	+=	'      <td>'+aMonta[nWrk,3]+' '+Capital(Posicione("SU9",1,xFilial("SU9")+aMonta[nWrk,1]+aMonta[nWrk,3],'U9_DESC'))+'</td>'
		  			cItens	+=	'      <td>'+aMonta[nWrk,4]+' '+Capital(Posicione("SUQ",1,xFilial("SUQ")+aMonta[nWrk,4],'UQ_DESC'))+'</td>'
		  			cItens	+=	'      <td>'+Iif(aMonta[nWrk,6]=='1','Pendente','Encerrado') +'</td>'
		  			cItens	+=	'      <td>'+Capital(aMonta[nWrk,7])+'</td>'
		  			cItens	+=	'    </tr>'
		  		Endif
		  	Next

  			cNomRespo := UsrFullName(cOperado)
  			cEmaRespo := UsrRetMail(cOperado)
	  			
  			xCabecalho := StrTran(xCabecalho,'Atendimento:','Atendimento: <span style="font-weight: bold;">'+M->UC_CODIGO)+'</span>'
  			xCabecalho := StrTran(xCabecalho,'Data:','Data: <span style="font-weight: bold;">'+DtoC(dDataBase))+'</span>'
  			xCabecalho := StrTran(xCabecalho,'Operador:','Operador: <span style="font-weight: bold;">'+__cUserId + '-'+Capital(UsrFullName(__cUserId)))+'</span>'
  			xCabecalho := StrTran(xCabecalho,'Ligacao:','Ligacao: <span style="font-weight: bold;">'+Iif(M->UC_OPERACA=='1','Receptivo','Ativo'))+'</span>'
  			xCabecalho := StrTran(xCabecalho,'Status:','Status: <span style="font-weight: bold;">'+Iif(M->UC_STATUS=='1','Planejada',Iif(M->UC_STATUS=='2','Pendente','Encerrada')))+'</span>'
  			xCabecalho := StrTran(xCabecalho,'Midia:','Midia: <span style="font-weight: bold;">'+M->UC_MIDIA+' '+Capital(Posicione("SUH",1,xFilial("SUH")+M->UC_MIDIA,"UH_DESC")))+'</span>'
  			xCabecalho := StrTran(xCabecalho,'Comunicacao:','Comunicacao: <span style="font-weight: bold;">'+M->UC_TIPO+' '+Capital(Posicione("SUL",1,xFilial("SUL")+M->UC_TIPO,"UL_DESC")))+'</span>'
  			xCabecalho := StrTran(xCabecalho,'Retorno:','Retorno: <span style="font-weight: bold;">'+DtoC(M->UC_PENDENT)+' '+M->UC_HRPEND)+'</span>'
  			cNome := ''
  			If M->UC_ENTIDAD == 'SA1'
	  			xCabecalho := StrTran(xCabecalho,'Cliente:','Cliente: <span style="font-weight: bold;">'+M->UC_CHAVE+' '+Capital(Posicione("SA1",1,xFilial("SA1")+M->UC_CHAVE,"A1_NOME")))+'</span>'
	  			cNome := SA1->A1_NOME
	  		ElseIf M->UC_ENTIDAD == 'SUS'
	  			xCabecalho := StrTran(xCabecalho,'Cliente:','Prospect: <span style="font-weight: bold;">'+M->UC_CHAVE+' '+Capital(Posicione("SUS",1,xFilial("SUS")+M->UC_CHAVE,"US_NOME")))+'</span>'
	  			cNome := SUS->US_NOME
	  		Endif
  			xCabecalho := StrTran(xCabecalho,'Contato:','Contato: <span style="font-weight: bold;">'+Capital(Posicione("SU5",1,xFilial("SU5")+M->UC_CODCONT,"U5_CONTAT")))+'</span>'
  			xCabecalho := StrTran(xCabecalho,'Fone:','Fone: <span style="font-weight: bold;">'+SU5->U5_DDD+' '+SU5->U5_CELULAR)+'</span>'
  			xCabecalho := StrTran(xCabecalho,'Email:','Email: <span style="font-weight: bold;">'+SU5->U5_EMAIL)+'</span>'
  			xCabecalho := StrTran(xCabecalho,'Cidade/UF:','Cidade/UF: <span style="font-weight: bold;">'+SU5->U5_MUN + '/' + SU5->U5_EST)+'</span>'
  			xCabecalho := StrTran(xCabecalho,'Responsavel:','Responsavel: <span style="font-weight: bold;">'+cNomRespo)+'</span>'
  			xCabecalho := StrTran(xCabecalho,'Observacao:','Observacao: <span style="font-weight: bold;">'+Capital(M->UC_OBS))+'</span>'
  			xRodape := StrTran(xRodape,'Data Envio:','Data Envio: <span style="font-weight: bold;">'+DtoC(dDataBase))+'</span>'
  			xRodape := StrTran(xRodape,'Hora Envio:','Hora Envio: <span style="font-weight: bold;">'+Time())+'</span>'
  			
  			EnvWrk(cNomRespo,cEmaRespo,'Atendimento No. ' + M->UC_CODIGO + ' - ' + Capital(cNome),xCabecalho+cItens+xRodape)

  			cItens := ''
		Next
	Endif	
	RestArea(aAreaSUA)
	RestArea(aAreaSUB)
	Return .t.
Endif                                                          

// Vendas MetalSeal ou MPM

If M->UA_CLIENTE+M->UA_LOJA $ GetNewPar("MV_MTLCVN",'00132001*01140401') .And. (Empty(M->UA_CLIMTS) .Or. Empty(M->UA_LOJMTS))
	MsgStop("Atenção Para Vendas MetalSeal ou MPM, o Campo Cliente e Loja MTS Deve Ser Preenchido Obrigatoriamente !")
	RestArea(aAreaSUA)
	RestArea(aAreaSUB)
	Return .F.
Endif

// Valida o Vendedor Antes de Salvar o Orçamento.

If M->UA_CLIPROS == '1'
	If !Empty(M->UA_CLIMTS) .And. !Empty(M->UA_LOJMTS)	// MPM ou SABESP tenho que pegar o cliente do campo customizado
		SA1->(dbSetOrder(1), dbSeek(xFilial("SA1")+M->UA_CLIMTS+M->UA_LOJMTS))
	Else
		SA1->(dbSetOrder(1), dbSeek(xFilial("SA1")+M->UA_CLIENTE+M->UA_LOJA))
	Endif
	
	If M->UA_VEND <> SA1->A1_VEND
		MsgStop("Divergência no Vendedor do Orçamento, Vendedor Atual " + M->UA_VEND + " Vendedor Que Será Corrigido: "+SA1->A1_VEND)
		M->UA_VEND	:=	SA1->A1_VEND
	Endif
	SA1->(dbSetOrder(1), dbSeek(xFilial("SA1")+M->UA_CLIENTE+M->UA_LOJA))
Else                         
	If M->UA_VEND <> SUS->US_VEND
		MsgStop("Divergência no Vendedor do Orçamento, Vendedor Atual " + M->UA_VEND + " Vendedor Que Será Corrigido: "+SUS->US_VEND)
		M->UA_VEND	:=	SUS->US_VEND
	Endif
Endif

lEmail := .f.
For nI := 1 to Len(aCols)
	nQuant	:= aCols[nI][_nPosQtdVe]    
	cProduto:= aCols[nI][_nPosProd]    
	cItem   := aCols[nI][_nPosItem]    
	nPrcVen	:= aCols[nI][_nPosUnit]    
	cOpcion := aCols[nI][_nPosOpcio]
	cTes	:= aCols[nI][_nPosTES]
	cCFOP	:= aCols[nI][_nPosCFOP]
	cLacre	:= aCols[nI][_nPosPers]
	nLacreIni	:= aCols[nI][_nPosInic]
	nLacreFim	:= aCols[nI][_nPosFim]
	cNumOp	:= aCols[nI][_nPosNumOp]
	cEmbala	:= aCols[nI][_nPosEmba]
	cPedCli := aCols[nI][_nPosPdCli]
	cIteCli := aCols[nI][_nPosItCli]
	dDtEntr := aCols[nI][_nPosItEnt]

	n := nI
	If !aCols[nI][nPosDel]	// Se Não Estiver Deletado
		If cEmpAnt == '01'	// Apenas Metalacre
			
			If cOper	== 	'1'	
				If Empty(cEmbala)
					Alert("Atenção Para a Geração de Pedidos é Necessário o Preenchimento do Código da Embalagem !")
					Return .f.
				Endif         
				If Empty(cPedCli)
					Alert("Atenção Para a Geração de Pedidos é Necessário o Preenchimento do Pedido do Cliente no Item " + Str(nI,3) + " !")
					Return .f.
				Endif         
				If Empty(cIteCli)
					Alert("Atenção Para a Geração de Pedidos é Necessário o Preenchimento do Item Pedido do Cliente no Item " + Str(nI,3) + " !")
					Return .f.
				Endif         
				If _nOpc == 3 .And. cEmpAnt == '01'	// Inclusao Valida Carga Fabrica
		    		lRet := U_VldCarga(cProduto,nQuant,dDtEntr,cItem,.t.)
		    		If !lRet
						Alert("Atenção o Item " + cItem + " Irã Estourar o Saldo na Entrega Programada, Verifique !")
						Return .f.
					Endif 
				Endif
			Endif
			
			// Se a Tes Não Gerar Duplicata então Ignora Informação da Tabela
		
			If SF4->(dbSetOrder(1), dbSeek(xFilial("SF4")+cTES))
				If SF4->F4_DUPLIC <> 'S'
					Loop
				Endif
			Endif
	
			If !Empty(nLacreIni) .And. !Empty(nLacreFim)
				If !AvaliaLacre('', cItem, cProduto, nQuant, cLacre, M->UA_NUM, cItem, nLacreIni, nLacreFim) // FUNCAO QUE Avalia o Calculo de NUMERACAO DOS LACRES 
					Alert("Atenção o Item " + cItem + " Irá Gerar Numeração Invalida em Lacres, Verifique !")
					_lRet := .f.
					Exit
				Endif
			Endif
			
			nPrcRet := U_RFATG01(2,.f.,.f.,.t.) // Igual a 1 Retorna Quantidade, Igual a 2 Retorna Valor Unitario, Posicionar
			
			If !Empty(nPrcVen) .And. nPrcVen < nPrcRet .And. lEmailSup // Se Valor Unitario For Menor que o Valor Calculado Então Irá Enviar Email aos Supervisores e Gerentes
				AAdd(aProdDiv,{cProduto,;
								Posicione("SB1",1,xFilial("SB1")+cProduto,'B1_DESC'),;
								nPrcRet,;
								nPrcVen,;
								nQuant,;
								cOpcion})
				lEmail := .t.
			Endif 
		
  			If M->UA_CLIPROS=='1'
  				If AllTrim(GetMV("MV_ESTADO")) <> AllTrim(SA1->A1_EST)
  					If SA1->A1_EST=='EX' .And. Left(cCFOP,1)<>'7'
						Alert("Atenção o Item " + cItem + " Esta com CFOP Exterior Errado, Redigite o Tipo de Saida (TES), Verifique !")
						_lRet := .f.
						Exit
					ElseIf Left(cCFOP,1)<>'6' .And. SA1->A1_EST<>'EX'
						Alert("Atenção o Item " + cItem + " Esta com CFOP Fora do Estado Errado, Redigite o Tipo de Saida (TES), Verifique !")
						_lRet := .f.
						Exit
					Endif  						
  				ElseIf AllTrim(GetMV("MV_ESTADO")) == AllTrim(SA1->A1_EST)
  					If Left(cCFOP,1)<>'5'
						Alert("Atenção o Item " + cItem + " Esta com CFOP Dentro do Estado Errado, Redigite o Tipo de Saida (TES), Verifique !")
						_lRet := .f.
						Exit
					Endif  						
  				Endif
  			ElseIf M->UA_CLIPROS=='2'
  				If AllTrim(GetMV("MV_ESTADO")) <> AllTrim(SUS->US_EST)
  					If SUS->US_EST=='EX' .And. Left(cCFOP,1)<>'7'
						Alert("Atenção o Item " + cItem + " Esta com CFOP Exterior Errado, Redigite o Tipo de Saida (TES), Verifique !")
						_lRet := .f.
						Exit
					ElseIf Left(cCFOP,1)<>'6' .And. SUS->US_EST<>'EX'
						Alert("Atenção o Item " + cItem + " Esta com CFOP Fora do Estado Errado, Redigite o Tipo de Saida (TES), Verifique !")
						_lRet := .f.
						Exit
					Endif  						
  				ElseIf AllTrim(GetMV("MV_ESTADO")) == AllTrim(SUS->US_EST)
  					If Left(cCFOP,1)<>'5'
						Alert("Atenção o Item " + cItem + " Esta com CFOP Dentro do Estado Errado, Redigite o Tipo de Saida (TES), Verifique !")
						_lRet := .f.
						Exit
					Endif  						
  				Endif
	  		Endif

		
		Endif
	ElseIf aCols[nI][nPosDel] .And. cOper == '1' .And. !Empty(cNumSc5)	// Se For Uma Exclusao do Item e Já Existir Pedido de Venda e Lacre
		If !Empty(cNumOp)
			Alert("Atenção Você Não poderá Excluir Um Item Que Possua OP Gerada !")
			Return .f.
		Endif         
	
		dbSelectArea("Z00")
		Z00->(dbSetOrder(1))
		If Z00->(dbSeek(xFilial("Z00")+cLacre))
			cQuery := "SELECT Z01_PV "
			cQuery += "FROM "+RetSqlName("Z01")+" Z01 "
			cQuery += "WHERE Z01.Z01_FILIAL='"+xFilial("Z01")+"' AND "
			cQuery += "Z01.Z01_COD = '"+cLacre+"'  AND "
			cQuery += "Z01.Z01_INIC > " + AllTrim(Str(nLacreFim)) + " AND "
			cQuery += "Z01.D_E_L_E_T_<>'*' "
			cQuery := ChangeQuery( cQuery )
			dbUseArea( .T., "TOPCONN", TcGenQry( , , cQuery ), 'TMP' )
			lOk := .t.                   
			IF !TMP->(EOF())
				lOk := .f.
			ENDIF								
			TMP->(dbCloseArea())
										
			If !lOk
				cMESYESNO := 'Pedido No. ' + cNumSc5 + ' Item: ' + cItem+'/'+cProduto
				cMESYESNO += ' Lacre: ' + cLacre +' Numeração Não Será Retornada Devido Existir Numerações Superiores ' 
				cMESYESNO += ' Deseja Continuar? "
				IF !MSGYESNO(CMESYESNO)
					Return .f.
				ENDIF 
			Endif
		ENDIF									
    Endif
Next		
n := _N
If !_lRet      
	_lMsg := .f.
	MsgInfo("Ocorreram Divergências no Calculo dos Lacres",;
		"Gravação Bloqueada!")
EndIf

// Envio de Email de Aviso aos Supervisores sobre valores abaixo da tabela de Preços
If lEmail                                                                           
	EnvMail()
Endif

RestArea(aAreaSUA)
RestArea(aAreaSUB)

Return _lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ PassLib º Autor ³ Luiz Alberto V Alvesº Data ³  19/02/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina para Liberacao de Senha de Supervisor				  º±±
±±º          ³ 																º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ESPECIFICO Metalacre                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function PassLib()
Local oGet1
Local cGet1 := Space(20)
Local oSay1
Static oDlg

  DEFINE MSDIALOG oDlg TITLE "Liberação" FROM 000, 000  TO 050, 400 COLORS 0, 16777215 PIXEL

    @ 006, 068 MSGET oGet1 VAR cGet1 Valid !Empty(cGet1) SIZE 056, 010 OF oDlg COLORS 0, 16777215 PIXEL PASSWORD
    @ 007, 006 SAY oSay1 PROMPT "Digite a Senha:" SIZE 051, 011 OF oDlg COLORS 0, 16777215 PIXEL
    DEFINE SBUTTON oSButton1 FROM 006, 149 TYPE 01 OF oDlg ENABLE ACTION oDlg:End()
    
  ACTIVATE MSDIALOG oDlg CENTERED

Return cGet1   


User Function VldLacre(cPerso,nInicio,nFim,cItem,cNumSua)
Local aArea := GetArea()

cQry:= " SELECT *"
cQry+= " FROM "+RETSQLNAME("Z01")+" Z01"
cQry+= " WHERE Z01_COD = '"+cPerso+"' "
cQry+= " AND Z01.D_E_L_E_T_='' "
cQry+= " AND Z01.Z01_NUMAT <> '" + cNumSua + "' "
cQry+= " AND (" + AllTrim(Str(nInicio)) + " BETWEEN Z01_INIC AND Z01_FIM OR "
cQry+= " 	  " + AllTrim(Str(nFim))    + " BETWEEN Z01_INIC AND Z01_FIM)   "

If Select("TRF") > 0
	TRF->(dbCloseArea())
EndIf
TCQUERY cQry New Alias "TRF"    

Count To nRecTot

If !Empty(nRecTot)                               
	Alert("Atenção Item " + cItem + " Com Lacre Inicial e Final Já Utilizado na Personalização " + cPerso + " Verifique !!! ")
	TRF->(dbCloseArea())
	RestArea(aArea)
	Return .f.     
Endif
TRF->(dbCloseArea())
RestArea(aArea)
Return .t.     



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CalcLacre º Autor ³Mateus Hengle       º Data ³ 21/10/2013  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Funcao que Calcula o Lacre Inicial e Final				  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ 													          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function AvaliaLacre(cNumX, cItem, cProd, nQtde, cLacre, cNumAT, cItemAT, nLacreIni, nLacreFim)
Local aArea := GetArea()
Local nNumLacre := 0
DEFAULT nLacreIni := 0
DEFAULT nLacreFim := 0

IF !EMPTY(cLacre) .And. Empty(nLacreIni) // SE O CAMPO LACRE ESTIVER VAZIO ELE NAO CALCULA A NUMERACAO
	If !Z00->(dbSetOrder(1), dbSeek(xFilial("Z00")+cLacre))
		RestArea(aArea)
		Return .f.
	Endif         
	
	If !Empty(Z00->Z00_LIMITE) .And. (Z00->Z00_LACRE + nQtde) > Z00->Z00_LIMITE
		MsgStop("Atenção a Personalização " + cLacre + " Ira Superar o Limite de " + TransForm(Z00->Z00_LIMITE,'9,999,999,999') + ", Impossível Sua Utilização !")
		RestArea(aArea)
		Return .F.
	Endif

	If Z00->Z00_MSBLQL == '1'
		MsgStop("Atenção Personalização Bloqueada Para Uso, Verifique !",'Bloqueio')
		Return .f.
	Endif

	nNumLacre 	:= Z00->Z00_LACRE	// Numeração Atual do Lacre
	nLacreIni	:= nNumLacre
	nLacreFim	:= (nNumLacre + nQtde) - 1

	If (!Empty(nLacreIni) .And. !Empty(nLacreFim)) .And. !U_VldLacre(cLacre,nLacreIni,nLacreFim,cItem,cNumAT)
		RestArea(aArea)
		Return .f.
	Endif
	
	IF Z00->Z00_PDINME == 'S'
		IF LEN(ALLTRIM(STR(nLacreFim))) > 6  .OR. nLacreFim > 999999
			MSGALERT("A numeração do lacre do item " + cProd + " atingiu o numero de caracteres configurado na tabela de personalização.")
			MSGALERT("Favor incluir uma NOVA personalização para o cliente " + ALLTRIM(SUA->UA_CLIENTE)  + ", LOJA " + SUA->UA_LOJA + ".") 
			RestArea(aArea)
			Return .f.
		ENDIF	
   	ELSE
		IF LEN(ALLTRIM(STR(nLacreFim ))) > Z00->Z00_TMLACRE
			MSGALERT("A numeração do lacre do item " + cProd + " atingiu o numero de caracteres configurado na tabela de personalização.")
			MSGALERT("Favor verificar a personalização " + cLacre + " e aumente o numero do campo Tamanho do lacre.")
			RestArea(aArea)
			Return .f.
		ENDIF
	ENDIF
ENDIF
RestArea(aArea)
Return .t.

Static Function EnvMail()
Local cAccount	:= RTrim(SuperGetMV("MV_RELACNT"))
Local cFrom		:= RTrim(SuperGetMV("MV_RELFROM"))
Local cPara		:= SuperGetMV('MV_XDIVPRE', .F., 'marcelo.carlis@metalacre.com.br') 
Local cAssunto	:= Iif(!Empty(M->UA_NUMSC5),'Divergência Preços no Pedido de Vendas - No. ' + M->UA_NUMSC5,'Divergência Preços no Orçamento de Vendas - No. '+M->UA_NUM)
Local cPassword	:= Rtrim(SuperGetMv("MV_RELAPSW"))
Local cServer   	:= Rtrim(SuperGetMv("MV_RELSERV"))
Local aAnexos		:= {}
Local cEmailTo := cPara						// E-mail de destino
Local cEmailBcc:= ""							// E-mail de copia
Local lResult  := .F.							// Se a conexao com o SMPT esta ok
Local cError   := ""							// String de erro
Local lRelauth := SuperGetMv("MV_RELAUTH")		// Parametro que indica se existe autenticacao no e-mail
Local lRet	   := .F.							// Se tem autorizacao para o envio de e-mail
Local cConta   := GetMV("MV_RELACNT") //ALLTRIM(cAccount)				// Conta de acesso 
Local cSenhaTK := GetMV("MV_RELPSW") //ALLTRIM(cPassword)	        // Senha de acesso
	
	_cAnexo	:= ''

	mCorpo	:= '<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">'
	mCorpo	+= '<html>'
	mCorpo	+= '<head>'
	mCorpo	+= '  <meta'
	mCorpo	+= ' content="text/html; charset=ISO-8859-1"'
	mCorpo	+= ' http-equiv="content-type">'
	mCorpo	+= '  <title>emailexpedicaometalacre</title>'
	mCorpo	+= '</head>'
	mCorpo	+= '<body>'
	mCorpo	+= '<table style="text-align: left; width: 100%;"'
	mCorpo	+= ' border="1" cellpadding="2" cellspacing="2">'
	mCorpo	+= '  <tbody>'
	mCorpo	+= '    <tr>'
	mCorpo	+= '      <td'
	mCorpo	+= ' style="text-align: center; background-color: rgb(192, 192, 192); font-weight: bold;"><big><big>Metalacre</big></big></td>'
	mCorpo	+= '      <td'
	mCorpo	+= ' style="text-align: center; background-color: rgb(192, 192, 192); width: 146px;"'
	mCorpo	+= ' colspan="3" rowspan="1"><big><big>Diverg&ecirc;ncias'
	mCorpo	+= ' de Pre&ccedil;os em Or&ccedil;amento/Pedido Vendas:</big></big></td>'
	mCorpo	+= '      <td colspan="2" rowspan="1"'
	mCorpo	+= ' style="background-color: rgb(192, 192, 192);">Data:'
	mCorpo	+= DtoC(dDataBase)+'<br>'
	mCorpo	+= 'Hora: ' + Left(Time(),5) + '</td>'
	mCorpo	+= '    </tr>'
	mCorpo	+= '    <tr>'
	mCorpo	+= '      <td style="text-align: right;">Or&ccedil;amento'
	mCorpo	+= ' No.:</td>'
	mCorpo	+= '      <td colspan="2" rowspan="1"'
	mCorpo	+= ' style="width: 605px;">' + M->UA_NUM + '</td>'
	mCorpo	+= '      <td'
	mCorpo	+= ' style="text-align: right; width: 146px;">Pedido de'
	mCorpo	+= ' Venda:</td>'
	mCorpo	+= '      <td colspan="2" rowspan="1">' + M->UA_NUMSC5 + '</td>'
	mCorpo	+= '    </tr>'
	mCorpo	+= '    <tr>'
	mCorpo	+= '      <td style="text-align: right;">Cliente:</td>'
	mCorpo	+= '      <td style="width: 146px;"'
	If M->UA_CLIPROS == '1'
		If M->UA_CLIENTE+M->UA_LOJA $ GetNewPar("MV_MTLCVN",'00132001*01140401') .And. !Empty(M->UA_CLIMTS)
			SA1->(dbSetOrder(1), dbSeek(xFilial("SA1")+M->UA_CLIMTS+M->UA_LOJMTS))

			mCorpo	+= ' colspan="5" rowspan="1">' + SA1->A1_COD+'/'+SA1->A1_LOJA + ' - ' + AllTrim(SA1->A1_NOME)
			mCorpo	+= ' - '
	
			SA1->(dbSetOrder(1), dbSeek(xFilial("SA1")+M->UA_CLIENTE+M->UA_LOJA))
			mCorpo	+= '(' + Capital(AllTrim(SA1->A1_NOME)) + ') </td>'
		Else
			SA1->(dbSetOrder(1), dbSeek(xFilial("SA1")+M->UA_CLIENTE+M->UA_LOJA))
			mCorpo	+= ' colspan="5" rowspan="1">' + SA1->A1_COD+'/'+SA1->A1_LOJA + ' - ' + SA1->A1_NOME + '</td>'
    	Endif
	ElseIf M->UA_CLIPROS == '2'
		SUS->(dbSetOrder(1), dbSeek(xFilial("SUS")+M->UA_CLIENTE+M->UA_LOJA))
		mCorpo	+= ' colspan="5" rowspan="1">' + SUS->US_COD+'/'+SUS->US_LOJA + ' - ' + SUS->US_NOME + '</td>'
	Endif

	mCorpo	+= '    </tr>'
	mCorpo	+= '    <tr>'
	mCorpo	+= '      <td style="text-align: right;">Vendedor(a):</td>'
	
	SA3->(dbSetOrder(1), dbSeek(xFilial("SA3")+M->UA_VEND))

	mCorpo	+= '      <td rowspan="1" colspan="5">' + SA3->A3_COD + ' - ' + SA3->A3_NOME '
	mCorpo	+= '</td>'
	mCorpo	+= '    </tr>'
	mCorpo	+= '    <tr align="center">'
	mCorpo	+= '      <td'
	mCorpo	+= ' style="background-color: rgb(153, 153, 153); width: 146px;"'
	mCorpo	+= ' colspan="6" rowspan="1">PRODUTOS</td>'
	mCorpo	+= '    </tr>'
	mCorpo	+= '    <tr>'
	mCorpo	+= '      <td'
	mCorpo	+= ' style="text-align: left; background-color: rgb(255, 204, 153);">C&oacute;digo</td>'
	mCorpo	+= '      <td'
	mCorpo	+= ' style="background-color: rgb(255, 204, 153); width: 605px;">Descri&ccedil;&atilde;o</td>'
	mCorpo	+= '      <td'
	mCorpo	+= ' style="background-color: rgb(255, 204, 153); text-align: center;">Tamanho<br> '
	mCorpo	+= 'Opcional</td>'
	mCorpo	+= '      <td'
	mCorpo	+= ' style="text-align: center; width: 146px; background-color: rgb(255, 204, 153);">Quantidade</td>'
	mCorpo	+= '      <td'
	mCorpo	+= ' style="background-color: rgb(255, 204, 153);">Valor <br>'
	mCorpo	+= 'Tabela Pre&ccedil;os</td>'
	mCorpo	+= '      <td'
	mCorpo	+= ' style="background-color: rgb(255, 204, 153);">Valor<br>'
	mCorpo	+= 'Venda</td>'
	mCorpo	+= '    </tr>'
	For nPrd := 1 To Len(aProdDiv)
		mCorpo	+= '    <tr>'
		mCorpo	+= '      <td style="text-align: right;">'+aProdDiv[nPrd,1]+'</td>'
		mCorpo	+= '      <td style="width: 605px;">'+aProdDiv[nPrd,2]+'</td>     '
		mCorpo	+= '      <td>'+aProdDiv[nPrd,6]+'</td>                            '
		mCorpo	+= '      <td style="text-align: right;">'+TransForm(aProdDiv[nPrd,5],"@E 99,999,999.999")+'</td>'
		mCorpo	+= '      <td style="text-align: right;">'+TransForm(aProdDiv[nPrd,3],"@E 99,999,999.99")+'</td>'
		mCorpo	+= '      <td style="text-align: right;">'+TransForm(aProdDiv[nPrd,4],"@E 99,999,999.99")+'</td>'
		mCorpo	+= '    </tr>'
	Next                                                 

	mCorpo	+= '    <tr>'
	mCorpo	+= '      <td colspan="6" rowspan="1"'
	mCorpo	+= ' style="text-align: right; width: 146px;"></td>'
	mCorpo	+= '    </tr>'
	mCorpo	+= '  </tbody>'
	mCorpo	+= '</table>'
	mCorpo	+= '<br>'
	mCorpo	+= '</body>'
	mCorpo	+= '</html>'

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Envia o mail para a lista selecionada. Envia como BCC para que a pessoa pense³
	//³que somente ela recebeu aquele email, tornando o email mais personalizado.   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	CONNECT SMTP SERVER cServer ACCOUNT cConta PASSWORD cSenhaTK RESULT lResult
	
	// Se a conexao com o SMPT esta ok
	If lResult
	
		// Se existe autenticacao para envio valida pela funcao MAILAUTH
		If lRelauth
			lRet := Mailauth(cConta,cSenhaTK)	
		Else
			lRet := .T.	
	    Endif    
		
		If lRet
			SEND MAIL FROM cFrom ;
			TO      	cEmailTo;
			SUBJECT 	cAssunto;
			BODY    	mCorpo;
			RESULT lResult
	
			If !lResult
				//Erro no envio do email
				GET MAIL ERROR cError
					Help(" ",1,'Erro no Envio do Email',,cError+ " " + cEmailTo,4,5)	//Atenção
			Else
				FErase(_cAnexo)
			Endif
	
		Else
			GET MAIL ERROR cError
			Help(" ",1,'Autenticação',,cError,4,5)  //"Autenticacao"
			MsgStop('Erro de Autenticação','Verifique a conta e a senha para envio') 		 //"Erro de autenticação","Verifique a conta e a senha para envio"
		Endif
			
		DISCONNECT SMTP SERVER
		
	Else
		//Erro na conexao com o SMTP Server
		GET MAIL ERROR cError
		Help(" ",1,'Erro no Envio do Email',,cError,4,5)      //Atencao
	Endif
Return .t.


// Envio de Email do WorkFlow Atendimentos

Static Function EnvWrk(cNomRespo,cEmaRespo,cAssunto,mCorpo)
Local cAccount	:= RTrim(SuperGetMV("MV_RELACNT"))
Local cFrom		:= RTrim(SuperGetMV("MV_RELFROM"))
Local cPara		:= cEmaRespo
Local cPassword	:= Rtrim(SuperGetMv("MV_RELAPSW"))
Local cServer   	:= Rtrim(SuperGetMv("MV_RELSERV"))
Local lResult  := .F.							// Se a conexao com o SMPT esta ok
Local cError   := ""							// String de erro
Local lRelauth := SuperGetMv("MV_RELAUTH")		// Parametro que indica se existe autenticacao no e-mail
Local lRet	   := .F.							// Se tem autorizacao para o envio de e-mail
Local cConta   := GetMV("MV_RELACNT") //ALLTRIM(cAccount)				// Conta de acesso 
Local cSenhaTK := GetMV("MV_RELPSW") //ALLTRIM(cPassword)	        // Senha de acesso
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Envia o mail para a lista selecionada. Envia como BCC para que a pessoa pense³
	//³que somente ela recebeu aquele email, tornando o email mais personalizado.   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	CONNECT SMTP SERVER cServer ACCOUNT cConta PASSWORD cSenhaTK RESULT lResult
	
	// Se a conexao com o SMPT esta ok
	If lResult
	
		// Se existe autenticacao para envio valida pela funcao MAILAUTH
		If lRelauth
			lRet := Mailauth(cConta,cSenhaTK)	
		Else
			lRet := .T.	
	    Endif    
		
		If lRet
			SEND MAIL FROM cFrom ;
			TO      	cPara;
			SUBJECT 	cAssunto;
			BODY    	mCorpo;
			RESULT lResult
	
			If !lResult
				//Erro no envio do email
				GET MAIL ERROR cError
					Help(" ",1,'Erro no Envio do Email',,cError+ " " + cPara,4,5)	//Atenção
			Endif
	
		Else
			GET MAIL ERROR cError
			Help(" ",1,'Autenticação',,cError,4,5)  //"Autenticacao"
			MsgStop('Erro de Autenticação','Verifique a conta e a senha para envio') 		 //"Erro de autenticação","Verifique a conta e a senha para envio"
		Endif
			
		DISCONNECT SMTP SERVER
		
	Else
		//Erro na conexao com o SMTP Server
		GET MAIL ERROR cError
		Help(" ",1,'Erro no Envio do Email',,cError,4,5)      //Atencao
	Endif
Return .t.