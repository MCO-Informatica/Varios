#Include "RWMAKE.CH"
#Include "TOPCONN.CH"
#Include "Protheus.Ch" 
#INCLUDE "AP5MAIL.CH"     

#DEFINE	FRT_ITEM	001	// 	Item
#DEFINE	FRT_QTDE	002	//	Quantidade
#DEFINE	FRT_UNIT	003	//	Valor Unitario Venda
#DEFINE	FRT_TOTA	004	//	Total Venda
#DEFINE	FRT_PROP	005	//	(%) Proporcao ao Total do Pedido
#DEFINE	FRT_PROV	006	//	Proporcao ao Total do Frete
#DEFINE	FRT_TPRO	007	//	Total Venda - Valor Proporcao Frete
#DEFINE	FRT_QTPR	008	//	Total Proporcao Dividido Pela Quantidade Venda
#DEFINE	FRT_TABE	009	//	Valor Tabela de Preco
#DEFINE	FRT_VALI	010	//	Validado

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M410STTS  º Autor ³FLAVIA AGUIAR       º Data ³ 25/08/2008  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±                                                 	
±±ºDescricao ³ PE APOS A GRAVACAO DOS REGISTROS DO PEDIDO DE VENDA        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CHAMADA DA FUNCAO DE LIBERACAO E VALIDACAO DOS CAMPOS.     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/   

USER FUNCTION M410STTS()     
Local aAreaSC5	:= SC5->(GetArea())
Local aAreaSC6	:= SC6->(GetArea())
Local aAreaSC9	:= SC9->(GetArea())
Local aAreaSA1	:= SA1->(GetArea())
Local lContrato	:= .f.
Local cContrato	:= ''    
  

// Gravacao do Campo Valor Total do Pedido de Vendas
	
MaFisIni(SC5->C5_CLIENTE,;  // 1-Codigo Cliente/Fornecedor
   SC5->C5_LOJACLI,;  // 2-Loja do Cliente/Fornecedor
   "C",;     // 3-C:Cliente , F:Fornecedor
   SC5->C5_TIPO,;   // 4-Tipo da NF
   SC5->C5_TIPOCLI,;         // 5-Tipo do Cliente/Fornecedor
   MaFisRelImp("MTR700",{"SC5","SC6"}),;   // 6-Relacao de Impostos que suportados no arquivo
   ,;     // 7-Tipo de complemento
   ,;     // 8-Permite Incluir Impostos no Rodape .T./.F.
   "SB1",;     // 9-Alias do Cadastro de Produtos - ("SBI" P/ Front Loja)
   "MTR700")    // 10-Nome da rotina que esta utilizando a funcao

   nItem := 0   
   nValIcmSt := 0
   nDesconto := 0
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Faz manualmente porque nao chama a funcao Cabec()                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nNrItem:=0
If SC6->(dbSetOrder(1), dbSeek(xFilial("SC6")+SC5->C5_NUM))
	While SC6->(!Eof()) .And. SC6->C6_FILIAL = xFilial("SC6") .And. SC6->C6_NUM == SC5->C5_NUM
		nNritem+=1
		
		SC6->(dbSkip())
	Enddo         
Endif
   
nVlrTotal := 0.00
nIPI        := 0
nICM        := 0
nValIcm     := 0
nValIpi     := 0
nTotIpi	    := 0
nTotIcms	:= 0
nTotDesp	:= 0
nTotFrete	:= 0
nTotalNF	:= 0
nTotSeguro  := 0
aValIVA     := 0
nTotMerc    := 0
nTotIcmSol  := 0
nTotDesc	:= 0
aPlanFrete  := {}                      

lTemOp := .F.

If SC6->(dbSetOrder(1), dbSeek(xFilial("SC6")+SC5->C5_NUM))
	While SC6->(!Eof()) .And. xFilial("SC6")==SC6->C6_FILIAL .And. SC6->C6_NUM == SC5->C5_NUM
		If !Empty(SC6->C6_CONTRAT)	// Se Estiver Preenchido Trata-se de Pedido de Contrato de Parceria
			lContrato	:= .t.
			cContrato	:= SC6->C6_CONTRAT
		Endif        

		If !Empty(SC6->C6_NUMOP)
			lTemOp := .T.
		Endif
		
		SB1->(dbSetOrder(1), dbSeek(xFilial("SB1")+SC6->C6_PRODUTO))

		nItem ++
		MaFisAdd(SC6->C6_PRODUTO,;   	   // 1-Codigo do Produto ( Obrigatorio )
				SC6->C6_TES,;		       // 2-Codigo do TES ( Opcional )
				SC6->C6_QTDVEN,;		   // 3-Quantidade ( Obrigatorio )
				SC6->C6_PRCVEN,;	       // 4-Preco Unitario ( Obrigatorio )
				nDesconto,;                // 5-Valor do Desconto ( Opcional )
				nil,;		               // 6-Numero da NF Original ( Devolucao/Benef )
				nil,;		               // 7-Serie da NF Original ( Devolucao/Benef )
				nil,;			       	   // 8-RecNo da NF Original no arq SD1/SD2
				SC5->C5_FRETE/nNritem,;	   // 9-Valor do Frete do Item ( Opcional )
				SC5->C5_DESPESA/nNritem,;  // 10-Valor da Despesa do item ( Opcional )
				SC5->C5_SEGURO/nNritem,;   // 11-Valor do Seguro do item ( Opcional )
				0,;						   // 12-Valor do Frete Autonomo ( Opcional )
				SC6->C6_Valor+nDesconto,;  // 13-Valor da Mercadoria ( Obrigatorio )
				0,;						   // 14-Valor da Embalagem ( Opcional )
				0,;		     			   // 15-RecNo do SB1
				0) 	           	           // 16-RecNo do SF4     
	      nIPI        := MaFisRet(nItem,"IT_ALIQIPI")
	      nICM        := MaFisRet(nItem,"IT_ALIQICM")
	      nValIcm     := MaFisRet(nItem,"IT_VALICM")	           
	      nValIpi     := MaFisRet(nItem,"IT_VALIPI")	      
	      nTotIpi	    := MaFisRet(,'NF_VALIPI')
	      nTotIcms	:= MaFisRet(,'NF_VALICM')        
	      nTotDesp	:= MaFisRet(,'NF_DESPESA')
	      nTotFrete	:= MaFisRet(,'NF_FRETE')
	      nTotalNF	:= MaFisRet(,'NF_TOTAL')
	      nTotSeguro  := MaFisRet(,'NF_SEGURO')
	      aValIVA     := MaFisRet(,"NF_VALIMP")
	      nTotMerc    := MaFisRet(,"NF_TOTAL")
	      nTotIcmSol  := MaFisRet(nItem,'NF_VALSOL')
	      
	      AAdd(aPlanFrete,{SC6->C6_ITEM,;
	      					(SC6->C6_QTDVEN - SC6->C6_QTDENT),;
	      					SC6->C6_PRCVEN,;
	      					SC6->C6_VALOR,;
	      					0.00,;
	      					0.00,;
	      					0.00,;
	      					0.00,;
	      					Iif(SC6->(FieldPos("C6_XTAB"))>0,SC6->C6_XTAB,0.00),;
	      					.T.})                      


	      SC6->(DbSkip())  
   	EndDo 
	nVlrTotal := Round(nTotMerc + nTotIpi + nTotSeguro+nTotDesp - nTotDesc,2)
Endif	   
MaFisEnd()//Termino	

If cEmpAnt <> '01'
	RestArea(aAreaSC5)
	RestArea(aAreaSC6)
	RestArea(aAreaSC9)
	RestArea(aAreaSA1)
	Return
Endif


If SC5->(FieldPos("C5_TOTPED")) > 0
	If RecLock("SC5",.f.)
		SC5->C5_TOTPED := nVlrTotal
		SC5->C5_TEMOP  := Iif(lTemOp,'S','')
		SC5->(MsUnlock())
	Endif
Endif


// Calculando e Avaliando valor do frete, se haverá perda ou não, e se irá ou não enviar email de aviso.

lPerda := .F.
If SC5->(FieldPos("C5_CFRETE"))>0 .And. !Empty(SC5->C5_CFRETE) .And. Len(aPlanFrete) > 0
	// Calculando Frete e as Proporcoes
	
	nValFrete := SC5->C5_CFRETE
	
	For nI := 1 To Len(aPlanFrete)
		aPlanFrete[nI,FRT_PROP]	:=	Round((aPlanFrete[nI,FRT_TOTA]/(nVlrTotal))*100,2)
		aPlanFrete[nI,FRT_PROV]	:=	Round((nValFrete * aPlanFrete[nI,FRT_PROP])/100,8)
		aPlanFrete[nI,FRT_TPRO]	:=	Round(aPlanFrete[nI,FRT_TOTA]-aPlanFrete[nI,FRT_PROV],2)
		aPlanFrete[nI,FRT_QTPR]	:=	Round(aPlanFrete[nI,FRT_TPRO]/aPlanFrete[nI,FRT_QTDE],2)
		aPlanFrete[nI,FRT_VALI]	:=	(aPlanFrete[nI,FRT_QTPR] > aPlanFrete[nI,FRT_TABE])
		
		If !aPlanFrete[nI,FRT_VALI]
			lPerda := .T.
		Endif
	Next
Endif

If lPerda //.And. GetEnvServer()$"TESTE"
	MsgStop("Atenção Divergência no Valor do Frete, Email Enviado com Detalhes !")

	cCabecalho := '<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"> '
	cCabecalho += '<html> '
	cCabecalho += '<head> '
	cCabecalho += '  <meta content="text/html; charset=ISO-8859-1" '
	cCabecalho += ' http-equiv="content-type"> '
	cCabecalho += '  <title>WorkFlow Metalacre</title> '
	cCabecalho += '</head> '
	cCabecalho += '<body> '
	cCabecalho += '<table '
	cCabecalho += ' style="font-family: Helvetica,Arial,sans-serif; width: 100%; text-align: left; margin-left: auto; margin-right: 0px;" '
	cCabecalho += ' border="1" cellpadding="2" cellspacing="2"> '
	cCabecalho += '  <tbody> '
	cCabecalho += '    <tr style="font-weight: bold;" align="center"> '
	cCabecalho += '      <td style="background-color: rgb(255, 255, 255);" '
	cCabecalho += ' colspan="10" rowspan="1"><big><big><img '
	cCabecalho += ' style="width: 300px; height: 88px;" alt="" '
	cCabecalho += ' src="http://www.metalacre.com.br/wp-content/uploads/2015/03/logotipometalacrepeq1.jpg"><br> '
	cCabecalho += '      </big></big></td> '
	cCabecalho += '    </tr> '
	cCabecalho += '    <tr style="font-weight: bold;" align="center"> '
	cCabecalho += '      <td style="background-color: rgb(255, 255, 204);" '
	cCabecalho += ' colspan="10" rowspan="1"><big><big>Pedidos com Divergencia no Frete</big></big></td> '
	cCabecalho += '    </tr> '
	cCabecalho += '    <tr> '
	cCabecalho += '      <td '
	cCabecalho += ' style="background-color: rgb(204, 204, 204); font-weight: bold;"><small>Item</small></td> '
	cCabecalho += '      <td '
	cCabecalho += ' style="font-weight: bold; background-color: rgb(192, 192, 192);"><small>Quantidade</small></td> '
	cCabecalho += '      <td '
	cCabecalho += ' style="background-color: rgb(204, 204, 204); font-weight: bold;"><small>Vlr Unitario</small></td> '
	cCabecalho += '      <td '
	cCabecalho += ' style="font-weight: bold; background-color: rgb(204, 204, 204); text-align: center;"><small>Total</small></td> '
	cCabecalho += '      <td '
	cCabecalho += ' style="font-weight: bold; background-color: rgb(204, 204, 204); text-align: center;"><small>(%) Prop. Total Pedido</small></td> '
	cCabecalho += '      <td '
	cCabecalho += ' style="font-weight: bold; background-color: rgb(204, 204, 204); text-align: left;"><small>Vlr Prop. Frete</small></td> '
	cCabecalho += '      <td '
	cCabecalho += ' style="font-weight: bold; background-color: rgb(204, 204, 204); text-align: center;"><small>Total Item Rateio Frete</small></td> '
	cCabecalho += '      <td '
	cCabecalho += ' style="background-color: rgb(204, 204, 204); text-align: center;"><small><span '
	cCabecalho += ' style="font-weight: bold;">(G) Dividido Pela Quantidade</span></small></td> '
	cCabecalho += '      <td '
	cCabecalho += ' style="font-weight: bold; background-color: rgb(204, 204, 204); text-align: center;"><small>Valor Unitario tabela Preços</small></td> '
	cCabecalho += '      <td '
	cCabecalho += ' style="font-weight: bold; background-color: rgb(204, 204, 204); text-align: center;"><small>Divergencia</small></td> '
	cCabecalho += '    </tr>  '
	
	cRodape    := '        <tr> '
	cRodape    += '       <td style="background-color: rgb(255, 255, 204);" '
	cRodape    += '  colspan="10" rowspan="1"><small><small><span '
	cRodape    += '  style="font-weight: bold;">Data Envio:</span> '
	cRodape    += ' Hora Envio:&nbsp;</small></small></td> '
	cRodape    += '     </tr> '
	cRodape    += '   </tbody> '
	cRodape    += ' </table> '
	cRodape    += ' <br style="font-family: Helvetica,Arial,sans-serif;">  '
	cRodape    += ' </body> '
	cRodape    += ' </html> '
	
	cNomRespo := 'Automatico'//UsrFullName(__cUserId)
	cEmaRespo := 'automatico@metalacre.com.br'//UsrRetMail(__cUserId)
	
	xCabecalho	:= cCabecalho
	xRodape     := cRodape
	xItens      := ''
	
	xRodape := StrTran(xRodape,'Data Envio:','Data Envio: <span style="font-weight: bold;">'+DtoC(dDataBase))+'</span>'
	xRodape := StrTran(xRodape,'Hora Envio:','Hora Envio: <span style="font-weight: bold;">'+Time())+'</span>'
	xRodape := StrTran(xRodape,'Operador:','Operador: <span style="font-weight: bold;">'+Capital(cNomRespo))+'</span>'
		
	cEmailFinan := 'lalberto@3lsystems.com.br;mariana.arantes@metalacre.com.br'//GetNewPar("MV_EMAFOP",'mariana.arantes@metalacre.com.br;paulo.junior@metalacre.com.br;lalberto@3lsystems.com.br')
		
	For nI := 1 To Len(aPlanFrete)
		xItens  +=  '        <tr> '
		xItens  +=  '          <td>' + aPlanFrete[nI,FRT_ITEM] + '</td> '
		xItens  +=  '          <td style="text-align: right;">' + TransForm(aPlanFrete[nI,FRT_QTDE],"@E 9,999,999.9") + '</td> '
		xItens  +=  '          <td style="text-align: right;">' + TransForm(aPlanFrete[nI,FRT_UNIT],"@E 9,999,999.999999") + '</td> '
		xItens  +=  '          <td style="text-align: right;">' + TransForm(aPlanFrete[nI,FRT_TOTA],"@E 9,999,999.99") + '</td> '
		xItens  +=  '          <td style="text-align: right;">' + TransForm(aPlanFrete[nI,FRT_PROP],"@E 999.9") + '</td> '
		xItens  +=  '          <td style="text-align: right;">' + TransForm(aPlanFrete[nI,FRT_PROV],"@E 9,999,999.99") + '</td> '
		xItens  +=  '          <td style="text-align: right;">' + TransForm(aPlanFrete[nI,FRT_TPRO],"@E 9,999,999.99") + '</td> '
		xItens  +=  '          <td style="text-align: right;">' + TransForm(aPlanFrete[nI,FRT_QTPR],"@E 9,999,999.999999") + '</td> '
		xItens  +=  '          <td style="text-align: right;">' + TransForm(aPlanFrete[nI,FRT_TABE],"@E 9,999,999.999999") + '</td> '
		xItens  +=  '          <td style="text-align: center;">' + Iif(!aPlanFrete[nI,FRT_VALI],"Sim","Nao") + '</td> '
		xItens  +=  '        </tr> '
	Next

	WrkAviFrete(cNomRespo,cEmailFinan,'Aviso Divergência Frete',xCabecalho+xItens+xRodape)
Endif

IF ALLTRIM(UPPER(FUNNAME())) == 'MATA410'  
	// Tratamento de Vendedores - 3L Systems -- 31-07-2014
	
	cVend1 := SC5->C5_VEND1
	nComi1 := SC5->C5_COMIS1
	cVend2 := SC5->C5_VEND2
	nComi2 := SC5->C5_COMIS2
	cVend3 := SC5->C5_VEND3
	nComi3 := SC5->C5_COMIS3
	cObsCli	:=	SC5->C5_OBSCLI
				
	If SC5->C5_TIPO == 'N' //.And. //!SC5->C5_CLIENTE+SC5->C5_LOJACLI$GetNewPar("MV_MTLCVN",'00132001*01140401')	// Clientes que Não Entram na Condicao
		If SC5->(FieldPos("C5_PEDWEB")) > 0
			If Empty(SC5->C5_PEDWEB)	// Se O Pedido Não For Sealbag
/*				If SA1->(dbSetOrder(1), dbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI)) .And. !Empty(SA1->A1_VEND) .And.;
						 SA1->A1_VEND <> cVend1 // Prioridade Vendedor no Cliente
						 
					cVend1 := SA1->A1_VEND
				Endif */ // rETIRADO MOMENTANEAMENTE PARA VERIFICACAO DE TROCA DE VENDEDOR NOS PEDIDOS
				
				nSa1Rec := SA1->(Recno())
				
				// Se o Cliente For MetalSeal ou MPM Entao Trata Vendedor

				If SC5->C5_CLIENTE+SC5->C5_LOJACLI$GetNewPar("MV_MTLCVN",'00132001*01140401') .And. !Empty(SC5->C5_CLIMTS)
					SA1->(dbSetOrder(1), dbSeek(xFilial("SA1")+SC5->C5_CLIMTS+SC5->C5_LOJMTS))

					cObsCli	:=	ALLTRIM(SA1->A1_OBSERV)

					/*If !Empty(SA1->A1_VEND) .And. SA1->A1_VEND <> cVend1 // Prioridade Vendedor no Cliente
							 
						cVend1 := SA1->A1_VEND
					Endif*/                        
				Endif
				
				SA1->(dbGoTo(nSa1Rec))

				If SA3->(dbSetOrder(1), dbSeek(xFilial("SA3")+cVend1))
					If SA1->A1_COD=='001320'	// MetalSeal
						nComi1 := Iif(!Empty(SA3->A3_XCOMIS2),SA3->A3_XCOMIS2,SA3->A3_COMIS)
					ElseIf SA1->A1_COD=='011404'	// MPM
						nComi1 := Iif(SA3->(FieldPos("A3_XCOMIS3"))>0 .And. !Empty(SA3->A3_XCOMIS3),SA3->A3_XCOMIS3,SA3->A3_COMIS)
					Else 
						nComi1 := SA3->A3_COMIS
					Endif
					//nComi1 := Iif(SA1->A1_COD+SA1->A1_LOJA$GetNewPar("MV_MTLCVN",'00132001*01140401') .And. !Empty(SA3->A3_XCOMIS2),SA3->A3_XCOMIS2,SA3->A3_COMIS)
					cVend2 := SA3->A3_SUPER
					cVend3 := SA3->A3_GEREN
				Endif
				
				If !Empty(cVend2)
					If SA3->(dbSetOrder(1), dbSeek(xFilial("SA3")+cVend2))
						If SA1->A1_COD=='001320'	// MetalSeal
							nComi2 := Iif(!Empty(SA3->A3_XCOMIS2),SA3->A3_XCOMIS2,SA3->A3_COMIS)
						ElseIf SA1->A1_COD=='011404'	// MPM
							nComi2 := Iif(SA3->(FieldPos("A3_XCOMIS3"))>0 .And. !Empty(SA3->A3_XCOMIS3),SA3->A3_XCOMIS3,SA3->A3_COMIS)
						Else 
							nComi2 := SA3->A3_COMIS
						Endif
//						nComi2 := Iif(SA1->A1_COD+SA1->A1_LOJA$GetNewPar("MV_MTLCVN",'00132001*01140401') .And. !Empty(SA3->A3_XCOMIS2),SA3->A3_XCOMIS2,SA3->A3_COMIS)
					Endif
				Endif
				If !Empty(cVend3)
					If SA3->(dbSetOrder(1), dbSeek(xFilial("SA3")+cVend3))
						If SA1->A1_COD=='001320'	// MetalSeal
							nComi3 := Iif(!Empty(SA3->A3_XCOMIS2),SA3->A3_XCOMIS2,SA3->A3_COMIS)
						ElseIf SA1->A1_COD=='011404'	// MPM
							nComi3 := Iif(SA3->(FieldPos("A3_XCOMIS3"))>0 .And. !Empty(SA3->A3_XCOMIS3),SA3->A3_XCOMIS3,SA3->A3_COMIS)
						Else 
							nComi3 := SA3->A3_COMIS
						Endif
//						nComi3 := Iif(SA1->A1_COD+SA1->A1_LOJA$GetNewPar("MV_MTLCVN",'00132001*01140401') .And. !Empty(SA3->A3_XCOMIS2),SA3->A3_XCOMIS2,SA3->A3_COMIS)
					Endif
				Endif                      
				
				If RecLock("SC5",.f.)
					SC5->C5_XOPCCOM :=	Iif(SA1->A1_COD+SA1->A1_LOJA$GetNewPar("MV_MTLCVN",'00132001*01140401'),'S','N')
					SC5->C5_VEND1 := cVend1
					SC5->C5_COMIS1:= nComi1
					SC5->C5_VEND2 := cVend2
					SC5->C5_COMIS2:= nComi2
					SC5->C5_VEND3 := cVend3
					SC5->C5_COMIS3:= nComi3
					SC5->C5_OBSCLI:= cObsCli
					SC5->(MsUnlock())
				Endif
			Else 			// pedido sealbag, limpar supervisor e gerente
				cVend1	:= GetNewPar("MV_MLVEND",'000020')		
				If SA3->(dbSetOrder(1), dbSeek(xFilial("SA3")+cVend1))
					nComi1 := SA3->A3_COMIS
				Endif
				If RecLock("SC5",.f.)
					SC5->C5_VEND1 := cVend1
					SC5->C5_COMIS1:= nComi1
					SC5->C5_VEND2 := ''
					SC5->C5_COMIS2:= 0
					SC5->C5_VEND3 := ''
					SC5->C5_COMIS3:= 0
					SC5->(MsUnlock())
				Endif
			Endif
		Endif
	Endif		

	IF ALTERA 
		RECLOCK("SC5",.F.)
		SC5->C5_TEMOP := ''
		SC5->(MSUNLOCK())
		
		DBSELECTAREA("SC6")
		DBSETORDER(1)
		DBSEEK(XFILIAL("SC6")+SC5->C5_NUM) // 3L SYSTEMS - 07-05-2014 - Luiz Alberto (Seek Necessário para Posicionar no 1o. Item do Pedido)
		DO WHILE !EOF() .AND. SC6->C6_NUM == SC5->C5_NUM .And. SC6->C6_FILIAL == xFilial("SC6")
			RECLOCK("SC6",.F.)
			SC6->C6_LIBERAD := ''
			SC6->C6_ULTACAO := 'Bloqueado Em ' + DtoC(Date()) + ' as ' + Left(Time(),5) 
			SC6->(MSUNLOCK())
			
			SB1->(dbSetOrder(1), dbSeek(xFilial("SB1")+SC6->C6_PRODUTO))
	
			DBSELECTAREA("SC6")
			DBSKIP()	
		ENDDO
    ENDIF
    
	If Type("_lCopy") <> "U"
		 _lCopy := .F.
	Endif
	
	If Type("_lReap") <> "U"
		 _lReap := .F.
	Endif
	
	If Type("_cPedRep") <> "U"
		_cPedRep := .F.
	Endif
	
	If Type("_lStand") <> "U"
		_lStand := .F.
	Endif             
	
	// Se For Uma Inclusao e For Contrato de Parceria Então Irá Gerar Atendimento no Call Center
	
	If INCLUI .And. lContrato .And. 1<> 1
	
		ADA->(dbSetOrder(1), dbSeek(xFilial("ADA")+cContrato))
		ADB->(dbSetOrder(1), dbSeek(xFilial("ADB")+cContrato))
	
		Begin Transaction
		
		DbSelectArea('SUA')
		If RecLock('SUA',.T.)
			SUA->UA_FILIAL 	:= xFilial('SUA')
			SUA->UA_NUM 	:= TkNumero('SUA','UA_NUM')
			SUA->UA_OPERADO := Posicione('SU7',4,xFilial('SU7')+__cUserID,'U7_COD')                                                
			SUA->UA_CLIENTE := SA1->A1_COD
			SUA->UA_LOJA 	:= SA1->A1_LOJA
			SUA->UA_XCLIENT	:= SA1->A1_COD
			SUA->UA_XLOJAEN	:= SA1->A1_LOJA
			SUA->UA_NOMECLI := SA1->A1_NOME
			SUA->UA_TMK 	:= '1'
			SUA->UA_OPER 	:= '1'
			SUA->UA_CLIPROS	:= '1'
			SUA->UA_DTLIM	:= dDataBase
			SUA->UA_ESPECI1	:= SC5->C5_ESPECI1
			SUA->UA_VOLUME1	:= SC5->C5_VOLUME1
			SUA->UA_FECENT	:= dDataBase
			SUA->UA_VEND 	:= SC5->C5_VEND1
			SUA->UA_REGIAO	:= SA1->A1_REGIAO
//			SUA->UA_MENNOTA	:= If(Empty(SA1->A1_SUFRAMA),"","COD. SUFRAMA: "+SA1->(ALLTRIM(A1_SUFRAMA)))                           
			SUA->UA_OBSCLI	:= ALLTRIM(SA1->A1_OBSERV)                                                                             
			SUA->UA_MENPAD	:= SA1->A1_MENSAGE                                                                                     
			SUA->UA_XMENNOT	:= iF(Empty(SA1->A1_SUFRAMA),"","COD. SUFRAMA: "+SA1->(ALLTRIM(A1_SUFRAMA)))                           
			SUA->UA_EMISSAO := dDatabase
			SUA->UA_CONDPG 	:= SC5->C5_CONDPAG
			SUA->UA_STATUS 	:= 'LIB'
			SUA->UA_LIBERA	:= 'S'
			SUA->UA_TIPLIB	:= '1'
			SUA->UA_ENDCOB 	:= SA1->A1_ENDCOB
			SUA->UA_BAIRROC := SA1->A1_BAIRROC
			SUA->UA_CEPC 	:= SA1->A1_CEPC
			SUA->UA_MUNC 	:= SA1->A1_MUNC
			SUA->UA_ESTC 	:= SA1->A1_ESTC
			SUA->UA_ENDENT 	:= SA1->A1_ENDENT
			SUA->UA_BAIRROE := SA1->A1_BAIRROE
			SUA->UA_CEPE 	:= SA1->A1_CEPE
			SUA->UA_MUNE 	:= SA1->A1_MUNE
			SUA->UA_ESTE 	:= SA1->A1_ESTE
			SUA->UA_TRANSP 	:= SA1->A1_TRANSP
			SUA->UA_TPFRETE := SA1->A1_TPFRET
			SUA->UA_PROSPEC := .F.
			SUA->UA_NUMCTR  := ADA->ADA_NUMCTR
			SUA->UA_CTRMTL  := ADA->ADA_XCONTR
			SUA->UA_NUMSC5	:= SC5->C5_NUM
	
			cVend1 := SC5->C5_VEND1
			cVend2 := SC5->C5_VEND2
			cVend3 := SC5->C5_VEND3
			nComi1 := SC5->C5_COMIS1
			nComi2 := SC5->C5_COMIS2
			nComi3 := SC5->C5_COMIS3

			SUA->UA_VEND  := cVend1
			SUA->UA_COMIS := nComi1
			SUA->UA_VEND2 := cVend2
			SUA->UA_COMIS2:= nComi2
			SUA->UA_VEND3 := cVend3
			SUA->UA_COMIS3:= nComi3
			SUA->(MsUnlock())
		Endif
			
		// Gerando Itens
		
		If SC6->(dbSetOrder(1), dbSeek(xFilial("SC6")+SC5->C5_NUM))
			While SC6->(!Eof()) .And. xFilial("SC6")==SC6->C6_FILIAL .And. SC6->C6_NUM == SC5->C5_NUM
				SB1->(DbSeek(xFilial('SB1')+SC6->C6_PRODUTO))
				SF4->(DbSeek(xFilial('SB1')+SC6->C6_TES))
	
				If RecLock('SUB',.T.)
					SUB->UB_FILIAL 		:= xFilial("SUB")
					SUB->UB_ITEM 		:= SC6->C6_ITEM
					SUB->UB_NUM 		:= SUA->UA_NUM
					SUB->UB_PRODUTO		:= SC6->C6_PRODUTO
					SUB->UB_QUANT 		:= SC6->C6_QTDVEN
					SUB->UB_VRUNIT 		:= SC6->C6_PRCVEN
					SUB->UB_VLRITEM		:= Round(SC6->C6_PRCVEN * SC6->C6_QTDVEN,2)
					SUB->UB_UM 			:= SB1->B1_UM
					SUB->UB_DTENTRE		:= SC6->C6_ENTREG
					cTes := SC6->C6_TES

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Define o CFO                                         ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					SF4->(dbSetOrder(1), dbSeek(xFilial("SF4")+cTes))
					aDadosCFO := {}
				 	Aadd(aDadosCfo,{"OPERNF","S"})
				 	Aadd(aDadosCfo,{"TPCLIFOR",SA1->A1_TIPO})
				 	Aadd(aDadosCfo,{"UFDEST"  ,SA1->A1_EST})
				 	Aadd(aDadosCfo,{"INSCR"   ,SA1->A1_INSCR})
						
					cCfop := MaFisCfo(,SF4->F4_CF,aDadosCfo)
					SUB->UB_TES 		:= cTes
					SUB->UB_CF			:= cCfop
					SUB->UB_LOCAL 		:= SC6->C6_LOCAL  
					SUB->UB_PRCTAB 		:= SC6->C6_PRCVEN
					SUB->UB_XLACRE		:= SC6->C6_XLACRE
					SUB->UB_XAPLIC		:= SC6->C6_XAPLC
					SUB->UB_XEMBALA		:= SC6->C6_XEMBALA
					SUB->UB_XVOLITE		:= SC6->C6_XVOLITE
					SUB->UB_XAPLICA		:= SC6->C6_XAPLICA
					SUB->UB_OPC			:= SC6->C6_OPC
					If SC6->(FieldPos("C6_XTAB")) > 0
						SUB->UB_XTAB	:=	SC6->C6_XTAB
					Endif
					
					SUB->UB_XSTAND		:= SC6->C6_XSTAND
					SUB->UB_XINIC		:= SC6->C6_XINIC
					SUB->UB_XFIM		:= SC6->C6_XFIM
					SUB->UB_XPBITEM		:= SC6->C6_XPBITEM
					SUB->UB_XPLITEM		:= SC6->C6_XPLITEM
					SUB->UB_XQTDEMB		:= SC6->C6_XQTDEMB
					SUB->UB_PEDCLI		:= SC6->C6_PEDCLI
					SUB->UB_NUMPV		:= SC6->C6_NUM
					SUB->UB_ITEMPV		:= SC6->C6_ITEM
					SUB->UB_FCICOD		:= SC6->C6_FCICOD
					SUB->UB_ITEMCLI		:= SC6->C6_ITEMCLI
					SUB->(MsUnlock())
				Endif

				SC6->(dbSkip(1))
			Enddo 
		Endif
			
		End Transaction
	Endif
	
	DBSELECTAREA("SC9")
	DBSETORDER(1)
	IF DBSEEK(XFILIAL("SC9") + SC5->C5_NUM)  
		DO WHILE !EOF() .AND. ALLTRIM(SC9->C9_PEDIDO) == alltrim(SC5->C5_NUM) .And. SC9->C9_FILIAL == xFilial("SC9")
			RECLOCK("SC9",.F.)
			SC9->C9_LOTECTL := U_PROCURA(SC5->C5_NUM,"C6_LOTECTL","SC6","C6_NUM","C6_ITEM",SC9->C9_ITEM,"C6_PRODUTO",C9_PRODUTO)
			SC9->(MSUNLOCK()) 
			if !EMPTY(SC9->C9_LOTECTL)
				RECLOCK("SC9",.F.)
				SC9->C9_BLEST := '' 
				SC9->(MSUNLOCK()) 
			ENDIF  
  	 				
			dbselectArea("SC6")
			DBSETORDER(1)
			IF DBSEEK(XFILIAL("SC6") + SC9->C9_PEDIDO + SC9->C9_ITEM  + SC9->C9_PRODUTO)
				RECLOCK("SC6",.F.)
				SC6->C6_LIBERAD := 'S' 
				SC6->C6_ULTACAO := 'Liberado Em ' + DtoC(Date()) + ' as ' + Left(Time(),5) 
				SC6->(MSUNLOCK())
			ENDIF
			         
			DBSELECTAREA("SC9")
			SC9->(DBSKIP())
		ENDDO
	ENDIF

else
	
	DBSELECTAREA("SC9")
	DBSETORDER(1)
	IF DBSEEK(XFILIAL("SC9") + SC5->C5_NUM)  
		DO WHILE !EOF() .AND. ALLTRIM(SC9->C9_PEDIDO) == alltrim(SC5->C5_NUM) .And. SC9->C9_FILIAL == xFilial("SC9")
			RECLOCK("SC9",.F.)
			SC9->C9_LOTECTL := U_PROCURA(SC5->C5_NUM,"C6_LOTECTL","SC6","C6_NUM","C6_ITEM",SC9->C9_ITEM,"C6_PRODUTO",C9_PRODUTO)
			SC9->(MSUNLOCK()) 
			if !EMPTY(SC9->C9_LOTECTL)
				RECLOCK("SC9",.F.)
				SC9->C9_BLEST := '' 
				SC9->(MSUNLOCK()) 
			ENDIF  
	 				
			dbselectArea("SC6")
			DBSETORDER(1)
			IF DBSEEK(XFILIAL("SC6") + SC9->C9_PEDIDO + SC9->C9_ITEM  + SC9->C9_PRODUTO)
				RECLOCK("SC6",.F.)
				SC6->C6_LIBERAD := 'S' 
				SC6->C6_ULTACAO := 'Liberado Em ' + DtoC(Date()) + ' as ' + Left(Time(),5) 
				SC6->(MSUNLOCK())
			ENDIF
			         
			DBSELECTAREA("SC9")
			SC9->(DBSKIP())
		ENDDO
	ENDIF
	
ENDIF

//U_GravaXPV()  // CHAMA A MINHA FUNCAO                
   

RestArea(aAreaSC5)
RestArea(aAreaSC6)
RestArea(aAreaSC9)
RestArea(aAreaSA1)
RETURN() 

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GravaXPV  º Autor ³Mateus Hengle       º Data ³ 25/09/2013  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±                                                 	
±±ºDescricao ³ PE que grava alguns campos customizados nas tabelas        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/ 

/*USER FUNCTION GravaXPV() 

Local cNum    := SC5->C5_NUM
Local cItem   := ""
Local cUserXX := UsrRetMail(RetCodUsr())
Local dDataXX := DATE()
Local cHoraXX := TIME()

c_Qry:= " SELECT ZZX_NUM, ZZX_ITEM, ZZX_PROD"
c_Qry+= " FROM "+RETSQLNAME("ZZX")+" ZZX"
c_Qry+= " WHERE ZZX_NUM = '"+cNum+"' "

		
If Select("TRZ") > 0
	TRZ->(dbCloseArea())
EndIf
	                                   	
TCQUERY c_Qry New Alias "TRZ" 

While TRZ->(!EOF())

    cNumZ   := TRZ->ZZX_NUM
    cItemZ  := TRZ->ZZX_ITEM
    cProdZ  := TRZ->ZZX_PROD
   
    DBSELECTAREA("SC6")
	DBSETORDER(1)
	IF DBSEEK(XFILIAL("SC6") + cNumZ + cItem1 + cProdZ)  
		RecLock("SC6",.F.)
   		SC6->C6_LIBPRO  := 'N'
   		SC6->C6_XSTATUS := 'B'
   		SC6->C6_XMAIL   := cUserXX
   		SC6->C6_XDTREG  := dDataXX
   		SC6->C6_XHROP   := cHoraXX
   		MsUnLock() 
   
   TRZ->(DbSkip())
ENDDO 

Return
*/


Static Function WrkAviFrete(cNomRespo,cEmaRespo,cAssunto,mCorpo)
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
					Conout('Erro no Envio do Email '+cError+ " " + cPara)	//Atenção
			Endif
	
		Else
			GET MAIL ERROR cError
			Conout('Autenticação '+cError)  //"Autenticacao"
		Endif
			
		DISCONNECT SMTP SERVER
		
	Else
		//Erro na conexao com o SMTP Server
		GET MAIL ERROR cError
		Conout('Erro no Envio do Email '+cError)      //Atencao
	Endif
Return .t.


