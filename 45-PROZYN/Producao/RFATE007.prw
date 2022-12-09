#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RFATE007    º Autor ³ Adriano Leonardo  º Data ³  03/11/16 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Função responsável por atualizar os percentuais de comissãoº±±
±±º          ³ em todos os itens do pedido de venda, acionada através     º±±
±±º          ³ de gatilhos em campos que possam impactar nas comissões    º±±
±±º          ³ como: cliente, loja, condição de pagamento e vendedores.   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Específico para a empresa Prozyn             			  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function RFATE007()

Local _aSavArea 	:= GetArea()
Local _nCont		:= 1
Local _lRefresh		:= .F.
Local _nComis1		:= 0
Local _nComis2		:= 0
Local _nComis3		:= 0
Local _nComis4		:= 0
Local _nComis5		:= 0
Local _cRotina		:= "RFATE007"
Local _nPosCom1		:= aScan(aHeader,{|x|Alltrim(x[2]) == "C6_COMIS1"})
Local _nPosCom2		:= aScan(aHeader,{|x|Alltrim(x[2]) == "C6_COMIS2"})
Local _nPosCom3		:= aScan(aHeader,{|x|Alltrim(x[2]) == "C6_COMIS3"})
Local _nPosCom4		:= aScan(aHeader,{|x|Alltrim(x[2]) == "C6_COMIS4"})
Local _nPosCom5		:= aScan(aHeader,{|x|Alltrim(x[2]) == "C6_COMIS5"})
Local _lEnviarEmail	:= .F.   
Local _cPedido      := M->C5_NUM
Local _cAnexo       := ""

//Verifico a existência da rotina responsável por retornar o percentual de comissão de cada vendedor
If ExistBlock("RFATE006")
	_nComis1 := U_RFATE006(M->C5_VEND1,M->C5_CONDPAG)
	_nComis2 := U_RFATE006(M->C5_VEND2,M->C5_CONDPAG)
	_nComis3 := U_RFATE006(M->C5_VEND3,M->C5_CONDPAG)
	_nComis4 := U_RFATE006(M->C5_VEND4,M->C5_CONDPAG)
	_nComis5 := U_RFATE006(M->C5_VEND5,M->C5_CONDPAG)
EndIf


//Atualizo os percentuais nos itens do pedido
For _nCont := 1 To Len(aCols)

	//Avalio a necessidade de refresh da tela
	If !_lRefresh .And. FunName()=="MATA410"
		If !aCols[_nCont,Len(aCols[_nCont])] .And. aCols[_nCont,aScan(aHeader,{|x|Alltrim(x[2]) == "C6_QTDVEN"})]>0
			_lRefresh := .T.
		EndIf
	EndIf
	
	aCols[_nCont,_nPosCom1] := _nComis1 
	aCols[_nCont,_nPosCom2] := _nComis2
	aCols[_nCont,_nPosCom3] := _nComis3
	aCols[_nCont,_nPosCom4] := _nComis4
	aCols[_nCont,_nPosCom5] := _nComis5
	
	If !Empty(aCols[_nCont,aScan(aHeader,{|x|Alltrim(x[2]) == "C6_DTANEXT"})])
		_lEnviarEmail	:= .T.
	Endif	
Next

// Verificar a Data de Análise dos Itens do Pedido para envio de E-mails para o CQ e PCP - por CR - Valdimari Martins 20/02/2017
if _lEnviarEmail
    
	//Criar e-mail para o PCP
	cAccount	:=  GetMv("MV_RELACNT")
	cPassword	:=  GetMv("MV_RELPSW")
	cServer		:=  GetMv("MV_RELSERV")
	cCC			:= ''
	cFrom		:= "protheus@prozyn.com.br" //Rtrim(_cMailCli)
	//cTo_PCP		:= "carla.victor@prozyn.com.br;giancarlo.canavesi@prozyn.com.br"
	//cTo_CQ		:= "aline.dantas@prozyn.com.br;gabriela.sousa@prozyn.com.br;renata.sancassani@prozyn.com.br"
	cTo_PCP		:= U_MyNewSX6("CV_EMAIPCP", 1	,"C","Envio de e-mail para PCP verificar análise externa dos itens do pedido", "", "", .F. )
	cTo_CQ		:= U_MyNewSX6("CV_EMAILCQ", 1	,"C","Envio de e-mail para CQ verificar análise externa dos itens do pedido", "", "", .F. )
	cBCC		:= ''
	cSubject	:= "Pedido: "+ _cPedido+" a Produzir."
	_cBody		:= "<P>Prezado(a) Colaborador,</P>"
	_cBody		+= "<BR>"
	_cBody		+= "<P>Segue abaixo os Itens do pedido " + _cPedido + " a ser produzido:</P>"
	_cBody		+= "<BR>"
	For _nCont := 1 To Len(aCols)
		If !Empty(aCols[_nCont,aScan(aHeader,{|x|Alltrim(x[2]) == "C6_DTANEXT"})])
		    _cProd      := aCols[_nCont,aScan(aHeader,{|x|Alltrim(x[2]) == "C6_PRODUTO"})]
			_cBody		+= "<P>Produto: " + _cProd + " - " + Posicione("SB1",1,xFilial("SB1") + _cProd,"B1_DESCINT") + "</P>"
			_cBody		+= "<P>Quantidade: " + transform(aCols[_nCont,aScan(aHeader,{|x|Alltrim(x[2]) == "C6_QTDVEN"})],"@E 999,999.9999") + "</P>"
			_cBody		+= "<P>Data de Produção: " + dtoc(aCols[_nCont,aScan(aHeader,{|x|Alltrim(x[2]) == "C6_DTPROD"})]) + "</P>"
			_cBody		+= "<P>Data de Entrega: " + dtoc(M->C5_FECENT)+" com análise externa</P>"
			_cBody		+= "<BR>"                                                                                			
		Endif	
	Next 
	// Disparar o e-mail para o PCP
	U_RCFGM001("Confirmação do Pedido!",_cBody,cTO_PCP,_cAnexo)		

	//Criar e-mail para o CQ
	cSubject	:= "Pedido: "+ _cPedido+" para Análise Externa."
	_cBody		:= "<P>Prezado(a) Colaborador,</P>"
	_cBody		+= "<BR>"
	_cBody		+= "<P>Segue abaixo os Itens do pedido " + _cPedido + " que deverá ser realizada análise externa:</P>"
	_cBody		+= "<BR>"
	For _nCont := 1 To Len(aCols)
		If !Empty(aCols[_nCont,aScan(aHeader,{|x|Alltrim(x[2]) == "C6_DTANEXT"})])            
		    _cProd      := aCols[_nCont,aScan(aHeader,{|x|Alltrim(x[2]) == "C6_PRODUTO"})]
			_cBody		+= "<P>Produto: " + _cProd + " - " + Posicione("SB1",1,xFilial("SB1") + _cProd,"B1_DESCINT") +"</P>"
			_cBody		+= "<P>Quantidade: " + transform(aCols[_nCont,aScan(aHeader,{|x|Alltrim(x[2]) == "C6_QTDVEN"})],"@E 999,999.9999") + "</P>"
			_cBody		+= "<P>Análise a ser Realizada: " + Posicione("SA7",1,xFilial("SA7")+ M->C5_CLIENTE + M->C5_LOJACLI + _cProd,"A7_ANALEXT") + "</P>"
			_cBody		+= "<P>Data da Análise: " + dtoc(aCols[_nCont,aScan(aHeader,{|x|Alltrim(x[2]) == "C6_DTANEXT"})]) + "</P>"
			_cBody		+= "<P>Data de Produção: " + dtoc(aCols[_nCont,aScan(aHeader,{|x|Alltrim(x[2]) == "C6_DTPROD"})]) + "</P>"
			_cBody		+= "<P>Data de Entrega: " + dtoc(M->C5_FECENT) + "</P>"
			_cBody		+= "<BR>"                                                                                			
		Endif	
	Next 
	// Disparar o e-mail para o CQ
	U_RCFGM001("Confirmação do Pedido!",_cBody,cTO_CQ,_cAnexo)		
		
Endif

If _lRefresh
	//Forço o refresh na tela, para visualização dos novos percentuais de comissão
	GETDREFRESH()
	SetFocus(oGetDad:oBrowse:hWnd) // Atualizacao por linha
	oGetDad:Refresh()
	A410LinOk(oGetDad)
EndIf

RestArea(_aSavArea)

Return(.T.) //Retorno sempre verdadeiro, por conta de chamada da rotina através do campo de condição de diversos gatilhos