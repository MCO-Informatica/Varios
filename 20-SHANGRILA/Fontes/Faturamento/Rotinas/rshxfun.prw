#include "rwmake.ch" 
//#INCLUDE "protheus.ch"
#INCLUDE "ap5mail.ch"   
#Define CRLF CHR(13)+CHR(10)
/*
------------------------------------------------------------------------------
Programa: RSHXFUN
Objetivo: Funcoes Especificas do Cliente 
------------------------------------------------------------------------------
Funcao    : RSHXF01()
Data      : 30.03.07
------------------------------------------------------------------------------
Descricao : Validacao da Regra de Desconto/Valida RD para Produto/Grupo
------------------------------------------------------------------------------
Parametros: ExpC1 - Codigo da Regra
------------------------------------------------------------------------------
Retorno   : Logico (.T./.F.)
------------------------------------------------------------------------------
Obs.: Validacao no campo C5_X_CODRE
------------------------------------------------------------------------------
*/
User Function RSHXF01(xOp)  
Local  lRet      := M->C5_X_CODRE
Local  cUFDestino:= SA1->A1_EST
Local  aArea     := GetArea()
Local  cEstNorte := GETMV("MV_NORTE")   

Local nPosCod := ""
Local nPosOpe := ""
Local cCodOp  := ""

Public cAlqIcms  

dbSelectArea("SZ0")

If cUFDestino == 'SP'
	cAlqIcms := '18'
	cCodReg  := '1'   
	cRegiao  := "No Estado"
Else
	If cUFDestino $ cEstNorte
		cAlqIcms := '7'
		cCodReg  := '2'  
		cRegiao  := "Norte/Nordeste"
	Else
		cAlqIcms := '12'
		cCodReg  := '3'
		cRegiao  := "Demais Estados"
	EndIf
EndIf

If !Empty(M->C5_X_CODRE)
	If xOp == '1' 
	/*	-----------------------------------------------------------------
		Verifica se existe Regra cadastrada para o Grupo/Regiao do produto
		-----------------------------------------------------------------*/
		nPosCod := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRODUTO"})     
		cCodGru := Posicione("SB1",1,xFilial("SB1")+Acols[N,nPosCod],"B1_GRUPO") 
		lRet    := Acols[N,nPosCod]	//Cod. Produto
		
		dbSetOrder(1)
//		SZ0->(MsSeek(xFilial("SZ0")+M->C5_X_CODRE+cCodGru)) 
		SZ0->(MsSeek(xFilial("SZ0")+M->C5_X_CODRE+cCodGru+cCodReg)) 
		
		If SZ0->(!Found())
			ApMsgAlert("Regra de Desconto não Cadastrada para o Grupo: "+ cCodGru ,"Aviso") 
			lRet := ""
		EndIf
	ElseIf xOp == '2' 
	/*	-----------------------------------------------------------------
		Verifica se Tipo de Operacao existe para essa Regra 
		-----------------------------------------------------------------*/
		nPosCod := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRODUTO"})     
		nPosOpe := aScan(aHeader,{|x| AllTrim(x[2])=="C6_OPER"})     

		cCodGru := Posicione("SB1",1,xFilial("SB1")+Acols[N,nPosCod],"B1_GRUPO") 
		cCodOp  := Posicione("SZ0",3,xFilial("SZ0")+M->C5_X_CODRE+cCodGru+cCodReg,"Z0_TIPOPER") 

		cTipoOp := aCols[N,nPosOpe]
		
		If cCodOp != cTipoOp
			ApMsgAlert("Operacao invalida - Regra/Grupo/Reg.: "+M->C5_X_CODRE+"/"+cCodGru+"/"+cRegiao,"Aviso") 
			lRet := ""
		Else
			lRet    := Acols[N,nPosOpe]	
		EndIf
	Else
	/*	-----------------------------------------------------------------
		Verifica se existe Regra cadastrada para a Regiao do Cliente
		-----------------------------------------------------------------*/
		dbSetOrder(2)
		SZ0->(MsSeek(xFilial("SZ0")+M->C5_X_CODRE+cCodReg)) 
		If SZ0->(!Found())
			ApMsgAlert("Regra não Cadastrada para a Regiao: "+ cEstNorte +" - "+cRegiao ,"Aviso") 
			lRet := ""
		EndIf
	EndIf
EndIf	
RestArea(aArea)
Return(lRet)
/*
------------------------------------------------------------------------------
Funcao    : RSHXF02()
Data      : 06.05.07
------------------------------------------------------------------------------
Descricao : TES conforme a regra de Desconto (Primeira linha)
------------------------------------------------------------------------------
Parametros: Nenhum
------------------------------------------------------------------------------
Retorno   : 
------------------------------------------------------------------------------
Obs.:  Gatilho no campo C6_PRODUTO - 002 //GATILHO EXCLUIDO EM 04.09.07 P/UTILIZAR TES INTELIGENTE
------------------------------------------------------------------------------
*/
User Function RSHXF02()
Local cTes := ''
/*
Regras de Faturamento: 
51/30 - TES 503/603 - 1/3 nf
51/50 - TES 502/602 - 1/2 nf
51/00 - TES 501     - C/ nf total
51/100 - TES 602    - SEM nf total
*/
If Alltrim(M->C5_X_CODRE) = '51100'     //S/NF TOTAL    
	cTes := '602'
ElseIf Alltrim(M->C5_X_CODRE) = '5100' //C/NF TOTAL  
	cTes := '501'
ElseIf Alltrim(M->C5_X_CODRE) = '5130'  
	cTes := '501'
ElseIf Alltrim(M->C5_X_CODRE) = '5150'  
	cTes := '501'
EndIf	

Return(cTes)
/*
------------------------------------------------------------------------------
Funcao    : RSHXF03()
Data      : 09.05.07
------------------------------------------------------------------------------
Descricao : Calcula o desconto liquido concedido
------------------------------------------------------------------------------
Parametros: Nenhum
------------------------------------------------------------------------------
Retorno   : % desconto
------------------------------------------------------------------------------
Obs.:  Gatilho no campo C6_DESCONT
------------------------------------------------------------------------------
*/
User Function RSHXF03()
Local cCodReg, cAtivo , cRegiao
Local _aArea    := GetArea()
Local cQuery    := ""
Local cUFDestino:= SA1->A1_EST
Local cEstNorte := GETMV("MV_NORTE")
Local nValMin   := GETMV("MV_XVALMIN")
/*-- Descontos Digitados --*/
Local nDesc1 := 0
Local nDesc2 := 0
Local nDesc3 := 0
Local nDesc4 := 0
Local nDesc5 := 0
Local nDesc6 := 0
/*-- Descontos pela Regra --*/
Local nValD1 := 0
Local nValD2 := 0
Local nValD3 := 0
Local nValD4 := 0
Local nValD5 := 0
Local nValD6 := 0               
Local cGrupo := SB1->B1_GRUPO
Local cDesGr := Alltrim(Posicione("SBM",1,xFilial("SBM")+SB1->B1_GRUPO,"BM_DESC"))
Local cCodreg   := M->C5_X_CODRE 
Local cCondPag  := M->C5_CONDPAG 
Local cTabela   := M->C5_TABELA
Local nPosTotal := aScan(aHeader,{|x| AllTrim(x[2])=="C6_VALOR"})     
Local nPosDesc  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_DESCONT"})     
Local nTotalPed := 0

Private nDescLiq := 0


If Alltrim(Funname()) $ "RGUAX001"
	Return M->C6_DESCONT
EndIf

If cUFDestino == 'SP'
	cRegiao  := '1'   	
Else
	If cUFDestino $ cEstNorte
		cRegiao  := '2'  
	Else
		cRegiao  := '3'
	EndIf
EndIf

cAtivo := Posicione("SZ0",1,xFilial("SZ0")+cCodreg+cGrupo+cRegiao,"Z0_ATIVO") //1-Sim 2-Nao

If !Empty(M->C5_X_CODRE)		// .And. cAtivo != "2"
	/*
	------------------------------------------------
	Recalcula o valor do Pedido pelo Preco de Lista
	------------------------------------------------*/
	nTotalPed := 0
	For _nCnt := 1 To Len(aCols) 
		If acols[_nCnt,Len(aCols[_nCnt])] == .F.	//Verifica se linha esta deletada	
			nTotalPed += aCols[_nCnt,nPosTotal] 
		EndIf
	Next

	If acols[N,Len(aCols[N])] == .F.	//Verifica se linha esta deletada
		If aCols[n,nPosDesc] > 0
			lOk := ApMsgNoYes("Recalcular Desconto ?","Aviso")
			If !lOk	
				nDescLiq := aCols[n,nPosDesc]
				Return(nDescLiq) 
			EndIf
		EndIf
	Else
		Return(ndescLiq)
	EndIf	
    /*
    ----------------------------------------------
    Seleciona a Regra de desconto
    ----------------------------------------------*/
	cQuery := "SELECT SZ0.*, SZ1.* "
	cQuery += "FROM "
	cQuery += RetSqlName("SZ1")+" SZ1, "
	cQuery += RetSqlName("SZ0")+" SZ0 "
	cQuery += "WHERE "
	cQuery += "SZ0.Z0_FILIAL = '"+xFilial("SZ0")+"' AND "
	cQuery += "SZ1.Z1_FILIAL = '"+xFilial("SZ1")+"' AND "
	cQuery += "SZ0.Z0_CODIGO = '" + cCodreg + "' AND "
	cQuery += "SZ0.Z0_GRUPO  = '" + cGrupo + "' AND "
	cQuery += "SZ0.Z0_CODREG = '" + cRegiao + "' AND "
	&&cQuery += "SZ0.Z0_TABELA = '" + cTabela + "' AND "	
	cQuery += "SZ1.Z1_CODIGO = SZ0.Z0_CODIGO AND "
	cQuery += "SZ1.Z1_GRUPO  = SZ0.Z0_GRUPO  AND "
	cQuery += "SZ1.Z1_REGIAO = SZ0.Z0_CODREG AND "
	cQuery += "SZ0.Z0_ATIVO  = '1' AND "
	cQuery += "SZ0.D_E_L_E_T_= ' ' AND "
	cQuery += "SZ1.D_E_L_E_T_= ' ' "
	cQuery += "ORDER BY Z1_CODIGO,Z1_GRUPO,Z1_REGIAO,Z1_ITEM "

	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMP",.F.,.T.)

	dbSelectArea("TMP") 
	TMP->(dbGoTop())                    
	nRegs := 0	//TMP->(RecCount())
	
	While TMP->(!Eof())
		nRegs := 1		
		If nTotalPed > TMP->Z1_VALATE 
			TMP->(dbSkip())
			Loop
		Else    
			If nTotalPed >= nValMin
				nValD1 := TMP->Z1_DESC1      	//Desconto 1
				nValD2 := TMP->Z1_DESC2         //Desconto 2
				nValD3 := TMP->Z1_DESC3			//Desconto 3
				nValD4 := TMP->Z1_DESC4			//Desconto 4
				nValD5 := TMP->Z1_DESC5			//Desconto 5 - DIF ICMS
				nValD6 := TMP->Z1_DESC6			//Desconto 6 - A VISTA
				/*
				------------------------------------------------
				Calculo do Desconto Liquido - Regra
				DescLiq = (1 - (ValLiqN / Total )) * 100
				------------------------------------------------*/
				If cCondPag $ "003/007/027/031"
					aDescC  := {nValD1,nValD2,nValD3,nValD4,nValD5,nValD6} 
				Else
					aDescC  := {nValD1,nValD2,nValD3,nValD4,nValD5} 
				EndIf  
				
				nValLiq := nTotalPed
				For nX := 1 To Len(aDescC)
					If aDescC[nX] != 0
						nValLiq := nValLiq - (nValLiq * (aDescC[nX]/100))
			        EndIf
				Next

				nDescCalc := 0
				If nValLiq != 0
					nDescCalc := (1 - (nValLiq / nTotalPed)) * 100
			 	EndIf        		
				Exit
			Else
				ApMsgAlert("Não há Desconto para Pedido abaixo do Valor Minimo.")
				nDescLiq := 0 
				nDescCalc:= 0
				Exit
			EndIf		
		EndIf
	End
	TMP->(dbCloseArea())
	RestArea(_aArea)

	If nRegs == 0
		ApMsgAlert("Não há Regra de Desconto para o Grupo: "+cGrupo+"-"+cDesGr)
		nDescLiq  := 0
		_xlBlqPed := .T. 		//Pedido será bloqueado por Regra
	
		Return(nDescLiq)
	EndIf
	/*
	---------------------------------------------------------
	Monta a Tela para digitacao dos descontos
	---------------------------------------------------------*/
	@10,10 to 300,410 Dialog oDlg1 Title "Regras de Desconto"
	@05,07 to 120,195

	@15,14 Say cGrupo + " - " + cDesGr
	@30,14 Say "Digite os percentuais de desconto: " size 150,15

	@45,14  Say "Desconto 1     " size 35,10
	@45,50  get nDesc1 PICTURE "@E 99.99"

	@45,104 Say "Desconto 2     " size 35,10
	@45,140 get nDesc2 PICTURE "@E 99.99"

	@60,14  Say "Desconto 3     " size 35,10
	@60,50  get nDesc3 PICTURE "@E 99.99"

	@60,104 Say "Desconto 4     " size 35,10
	@60,140 get nDesc4 PICTURE "@E 99.99"

	@75,14  Say "Desconto 5     " size 35,10			//ICMS
	@75,50  get nDesc5 PICTURE "@E 99.99"

	@75,104 Say "Desconto 6     "  size 35,10        	//A vista
	@75,140 get nDesc6 PICTURE "@E 99.99"
	/*
	-------------------------------------------
	Descontos para o Grupo/Faixa
	-------------------------------------------*/
	@95,14  Say "Valores Possiveis de Desconto (Regra):" size 150,15
	@105,14 Say "D1"+Space(2)+;
				Transform(nValD1,"@E 99.99")+Space(2)+"|D2"+Space(2)+;
				Transform(nValD2,"@E 99.99")+Space(2)+"|D3"+Space(2)+;
    	        Transform(nValD3,"@E 99.99")+Space(2)+"|D4"+Space(2)+;
    	        Transform(nValD4,"@E 99.99")+Space(2)+"|D5"+Space(2)+;
        	    Transform(nValD5,"@E 99.99")+Space(2)+"|D6"+Space(2)+;
        	    Transform(nValD6,"@E 99.99")

	@130,165 bmpbutton type 1  action OkProc()

	Activate dialog oDlg1 centered
	/*
	------------------------------------------------
	Calculo do Desconto Liquido Concedido - Digitado
	DescLiq = (1 - (ValLiqN / Total )) * 100
	------------------------------------------------*/
	If cCondPag $ "003/007/027/031"
		aDesc := {nDesc1,nDesc2,nDesc3,nDesc4,nDesc5,nDesc6}
	Else
		aDesc := {nDesc1,nDesc2,nDesc3,nDesc4,nDesc5}
	EndIf	
	nValLiq := nTotalPed
	For nX := 1 To Len(aDesc)
		If aDesc[nX] != 0
			nValLiq := nValLiq - (nValLiq * (aDesc[nX]/100))
        EndIf
	Next

	nDescLiq := 0
	If nValLiq != 0
		nDescLiq := (1 - (nValLiq / nTotalPed)) * 100
 	EndIf        		
EndIf
Return(nDescLiq)   
/*
------------------------------------------------------------------------------
Funcao    : OkProc()
Data      : 10.05.07
------------------------------------------------------------------------------
Descricao : Calcula o desconto liquido concedido
------------------------------------------------------------------------------
Parametros: Nenhum
------------------------------------------------------------------------------
Retorno   : % desconto
------------------------------------------------------------------------------
Obs.:  Gatilho no campo C6_DESCONT
------------------------------------------------------------------------------
*/
Static Function OkProc()

lOk := ApMsgYesNo("Percentuais Digitados Ok ?","Regra de Desconto","STOP")
          
If !lOk  
	nDescLiq := 0
Else
	Close(oDlg1)
EndIf
Return()
/*
------------------------------------------------------------------------------
Funcao    : RSHXF04()
Data      : 20.05.07
------------------------------------------------------------------------------
Descricao : Validacao da Regra de Desconto
------------------------------------------------------------------------------
Parametros: ExpC1 - Codigo da Regra
------------------------------------------------------------------------------
Retorno   : Codigo Valido
------------------------------------------------------------------------------
Obs.: Gatilho no campo C5_X_CODRE
------------------------------------------------------------------------------
*/
User Function RSHXF04()  
Local _aArea := GetArea()
Local _cCodRegra := M->C5_X_CODRE

dbSelectArea("SZ0")
dbSetOrder(1)
 
If !Empty(M->C5_X_CODRE)

	SZ0->(MsSeek(xFilial("SZ0")+M->C5_X_CODRE))
	If SZ0->(!Found())
		ApMsgAlert("Regra não Cadastrada","Aviso")   
		_cCodRegra := ""
	EndIf
Else
	If M->C5_TIPO == "N"
		ApMsgAlert("Informe a Regra de Desconto","Aviso")   	
	EndIf
EndIf	
RestArea(_aArea)
Return(_cCodRegra)
/*
------------------------------------------------------------------------------
Funcao    : RSHXF05()
Data      : 19.06.07
------------------------------------------------------------------------------
Descricao : Incializa variaveis publicas para validar bloqueio do pedido
------------------------------------------------------------------------------
Retorno   : Nenhum
------------------------------------------------------------------------------
Obs.:  Gatilho no campo C5_CLIENTE
------------------------------------------------------------------------------
*/     
User Function RSHXF05()
Local  cRet        := M->C5_CLIENTE
Public _xlBlqPed   := .F.     	//Pedido será bloqueado
Public _xlBlqVerba := .F. 	   	//Pedido será bloqueado por verba
Public _xlBlqRegra := .F.		//Pedido será bloqueado por Regra Desconto

Return(cRet)
/*
------------------------------------------------------------------------------
Funcao    : RSHXF06()
Data      : 07.08.07
------------------------------------------------------------------------------
Descricao : Verifica se quantidade é menor que quantidade da embalagem
------------------------------------------------------------------------------
Retorno   : Quantidade digitada
------------------------------------------------------------------------------
Obs.:  Gatilho no campo C6_QTDVEN - SEQ:
------------------------------------------------------------------------------*/
User Function RSHXF06()
Local  xMensagem := ""
Local _nPosCod := aScan(aHeader,{|x|Upper(AllTrim(x[2])) == "C6_PRODUTO"})
Local _nPosQtd := aScan(aHeader,{|x|Upper(AllTrim(x[2])) == "C6_QTDVEN" })
Local _cQtdEmb := Posicione("SB5",1,xFilial("SB5")+aCols[N,_nPosCod],"B5_QE1")
Local _nQtdVen := aCols[N,_nPosQtd]
 
If _cQtdEmb > 0
	If _nQtdVen < _cQtdEmb
		ApMsgAlert("O valor informado é MENOR que a quantidade minima ( "+Alltrim(Str(_cQtdEmb))+" ) para a venda desse produto!") 
	Else
		_nResto := _nQtdVen % _cQtdEmb
		If _nResto > 0
			ApMsgAlert("O valor informado não é Multiplo da quantidade minima ( "+Alltrim(Str(_cQtdEmb))+" ) para a venda desse produto!") 
		EndIf
	EndIf
EndIf
Return(_nQtdVen)
/*
------------------------------------------------------------------------------
Funcao    : RSHXF07()
Data      : 06.09.07
------------------------------------------------------------------------------
Descricao : Valida codigo da Operacao com o codigo informado na Regra Desconto
------------------------------------------------------------------------------
Retorno   : CODIGO DA OPERACAO
------------------------------------------------------------------------------
Obs.:  Gatilho no campo C6_OPER - SEQ: 002
------------------------------------------------------------------------------*/
User Function RSHXF07()
Local nPosTOp:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_OPER"})     
Local cCodOp := Posicione("SZ0",1,xFilial("SZ0")+M->C5_X_CODRE,"Z0_TIPOPER") 
Local cTipoOp:= aCols[N,nPosTOp]

If cCodOp != cTipoOp
	ApMsgAlert("Operacao nao cadastrada para essa Regra de Desconto")   
	cTipoOp := ""
EndIf

Return(cTipoOp) 
/*
------------------------------------------------------------------------------
Funcao    : RSHXF08()
Data      : 18.09.07
------------------------------------------------------------------------------
Descricao : Monta e-Mail com PV bloqueado
------------------------------------------------------------------------------
Retorno   : Nenhum
------------------------------------------------------------------------------*/
User Function RSHXF08()  
Local cMensag := ""
//Local CRLF    := Chr(13) + Chr(10)   
Local cNumPed := SC5->C5_NUM
Local cTabela := SC5->C5_TABELA
Local cStatus := If(SC5->C5_BLQ=='1',"BLOQUEADO POR REGRA","BLOQUEADO POR VERBA")       
Local cCondPg := Alltrim(Posicione("SE4",1,xFilial("SE4")+SC5->C5_CONDPAG,"E4_DESCRI"))
Local dDataEm := DTOC(SC5->C5_EMISSAO) + Space(5) + Substr(Time(),1,5)
Local cRegra  := TRANSFORM(SC5->C5_X_CODRE,"@R 99/999")
Local cUser   := SC5->C5_USERINC
Local cFrete  := If(SC5->C5_TPFRETE=='C',"CIF",If(SC5->C5_TPFRETE=='F',"FOB",""))
Local cCodCli := SC5->C5_CLIENTE
Local cLojCli := SC5->C5_LOJACLI
Local cNomeCli:= Alltrim(Posicione("SA1",1,xFilial("SA1")+SC5->(C5_CLIENTE+C5_LOJACLI),"A1_NOME"))
Local cEndCli := Alltrim(Posicione("SA1",1,xFilial("SA1")+SC5->(C5_CLIENTE+C5_LOJACLI),"A1_END"))
Local cBaiCli := Alltrim(Posicione("SA1",1,xFilial("SA1")+SC5->(C5_CLIENTE+C5_LOJACLI),"A1_BAIRRO"))
Local cCidCli := Alltrim(Posicione("SA1",1,xFilial("SA1")+SC5->(C5_CLIENTE+C5_LOJACLI),"A1_MUN"))
Local cEstCli := Alltrim(Posicione("SA1",1,xFilial("SA1")+SC5->(C5_CLIENTE+C5_LOJACLI),"A1_EST"))     
Local cNomVend:= Alltrim(Posicione("SA3",1,xFilial("SA3")+SC5->C5_VEND1,"A3_NOME"))
/*---Itens do Pedido---*/
Local nPosProd  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRODUTO"})
Local nPosUM    := aScan(aHeader,{|x| AllTrim(x[2])=="C6_UM"}) 
Local nPosDescr := aScan(aHeader,{|x| AllTrim(x[2])=="C6_DESCRI"}) 
Local nPosQtdVen:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_QTDVEN"})
Local nPosPrcVen:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRCVEN"})
Local nPosPrcLst:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_X_PRLST"}) 
Local nPosValor := aScan(aHeader,{|x| AllTrim(x[2])=="C6_VALOR"})
Local nPosDesCon:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_DESCONT"}) //Desconto Concedido no Item
Local nPosDesMax:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_X_DESCO"}) //Desconto Maximo permitido pela regra
Local nPosComis1:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_COMIS1"}) 
//Local nPosComis2:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_COMIS2"}) 
Local nPosValDes:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_VALDESC"})
Local nTotalPV := 0, nTotalDC := 0, nTotalDM := 0
/* 
-------------
Mensagem
-------------*/
cMensag  += '<html>' + CRLF
cMensag  += '<body>'
/**/
cMensag  += '<table border="1" width="100%" id="table1" style="border-collapse: collapse">'
cMensag  += '	<tr>' 
cMensag  += '		<td width="135" rowspan="4" style="border-top-color: #C0C0C0; border-top-width: 1px; border-bottom-color: #808080; border-bottom-width: 1px"> '
cMensag  += '		<img border="0" src="http://www.gruposhangrila.com.br/images/__logos/'+ cEmpAnt +'.jpg" width="120" height="40"></td> '
cMensag  += '		<td width="133" align="left" bgcolor="#9999FF" style="border-top-color: #C0C0C0; border-top-width: 1px"> '
cMensag  += '		<div style="background-color: #0066CC"> '
cMensag  += '			<b><font face="Tahoma" size="2" color="#FFFFFF">Pedido de Venda No.</font></b></div> '
cMensag  += '		</td> '
cMensag  += '		<td bgcolor="#9999FF" width="371" style="border-top-color: #C0C0C0; border-top-width: 1px"> '
cMensag  += '		<b><font face="Tahoma" size="2">'+ cNumPed +'</font></b></td> '
cMensag  += '		<td bgcolor="#9999FF" width="130" align="left" style="border-style: solid; border-width: 1px"> '
cMensag  += '		<b><font size="2" face="Tahoma" color="#0000FF">Tabela</font></b></td> '
cMensag  += '		<td bgcolor="#9999FF" style="border-style: solid; border-width: 1px"><b> '
If Alltrim(cTabela) == '1N'
	cMensag  += '		<font face="Tahoma" size="2">'+cTabela+'</font></b></td> '
Else
	cMensag  += '		<font face="Tahoma" size="2" color="#FF0000">'+cTabela+'</font></b></td> '
EndIf
cMensag  += '	</tr> ' + CRLF
cMensag  += '	<tr> '
cMensag  += '		<td width="133" align="left" bgcolor="#9999FF"><b> '
cMensag  += '		<font face="Tahoma" size="2" color="#0000FF">Status</font></b></td> '
cMensag  += '		<td bgcolor="#9999FF" width="371"><b><font face="Tahoma" size="2">'+ cStatus +'</font></b></td> '
cMensag  += '		<td bgcolor="#9999FF" width="130" align="left" style="border-style: solid; border-width: 1px"> '
cMensag  += '		<b><font size="2" face="Tahoma" color="#0000FF">Cond. Pagto</font></b></td> '
cMensag  += '		<td bgcolor="#9999FF" style="border-style: solid; border-width: 1px"><b> '
cMensag  += '		<font face="Tahoma" size="2">'+cCondPg+'</font></b></td> '
cMensag  += '	</tr> ' + CRLF
cMensag  += '	<tr> '
cMensag  += '		<td width="133" align="left" bgcolor="#9999FF"><b> '
cMensag  += '		<font face="Tahoma" size="2" color="#0000FF">Emissão</font></b></td> '
cMensag  += '		<td bgcolor="#9999FF" width="371"><b><font face="Tahoma" size="2"> '+dDataEm+'</font></b></td> '
cMensag  += '		<td bgcolor="#9999FF" width="130" align="left" style="border-style: solid; border-width: 1px"> '
cMensag  += '		<b><font size="2" face="Tahoma" color="#0000FF">Regra Desconto</font></b></td> '
cMensag  += '		<td bgcolor="#9999FF" style="border-style: solid; border-width: 1px"><b> '
cMensag  += '		<font face="Tahoma" size="2">'+cRegra+'</font></b></td> '
cMensag  += '	</tr> ' + CRLF
cMensag  += '	<tr> '
cMensag  += '		<td width="133" align="left" bgcolor="#9999FF" style="border-bottom-color: #808080; border-bottom-width: 1px"> '
cMensag  += '		<b><font face="Tahoma" size="2" color="#0000FF">Responsável</font></b></td> '
cMensag  += '		<td bgcolor="#9999FF" width="371" style="border-bottom-color: #808080; border-bottom-width: 1px"> '
cMensag  += '		<b><font face="Tahoma" size="2">'+cUser+'</font></b></td> '
cMensag  += '		<td bgcolor="#9999FF" width="130" align="left" style="border-style: solid; border-width: 1px"> '
cMensag  += '		<b><font face="Tahoma" size="2" color="#0000FF">Frete</font></b></td> '
cMensag  += '		<td bgcolor="#9999FF" style="border-style: solid; border-width: 1px"><b> '
cMensag  += '		<font face="Tahoma" size="2">'+cFrete+'</font></b></td> '
cMensag  += '	</tr> ' + CRLF
cMensag  += '	<tr>'
cMensag  += '		<td width="133" align="left" bgcolor="#9999FF" style="border-style:solid; border-width:1px; ">'
cMensag  += '		<b><font face="Tahoma" size="2" color="#0000FF">Vendedor</font></b></td>'
cMensag  += '		<td bgcolor="#9999FF" style="border-style:solid; border-width:1px; " colspan="3">'
cMensag  += '		<b><font face="Tahoma" size="2">'+cNomVend+'</font></b></td>'
cMensag  += '	</tr>'+ CRLF
cMensag  += '</table> '
/**/
cMensag  += '<table border="1" width="100%" style="border-collapse: collapse; border-top-width: 0px" id="table2"> '
cMensag  += '	<tr> '
cMensag  += '		<td colspan="6" align="left" bgcolor="#0066CC" style="border-left: 1px solid #C0C0C0; border-right: 1px solid #808080; border-top: 1px solid #C0C0C0; border-bottom-style: solid; border-bottom-width: 1px" height="26"> '
cMensag  += '		<p align="center"><b><font face="Tahoma" color="#FFFFFF" size="2">Cliente</font></b></td> '
cMensag  += '	</tr> ' + CRLF
cMensag  += '	<tr> '    
cMensag  += '		<td width="14%" style="border-left: 1px solid #C0C0C0; border-right-style: solid; border-right-width: 1px; border-top-style: solid; border-top-width: 1px; border-bottom-style: solid; border-bottom-width: 1px" bgcolor="#9999FF"> '
cMensag  += '		<font face="Tahoma" size="2" color="#0000FF">Razão Social</font></td> '
cMensag  += '		<td width="86%" style="border-left-style: solid; border-left-width: 1px; border-right: 1px solid #808080; border-bottom-style: solid; border-bottom-width: 1px" colspan="5" bgcolor="#9999FF"> '
cMensag  += '		<font face="Tahoma" size="2">'+cNomeCli+'</font></td> '
cMensag  += '	</tr> ' + CRLF
cMensag  += '	<tr> '
cMensag  += '		<td width="14%" style="border-left: 1px solid #C0C0C0; border-right-style: solid; border-right-width: 1px; border-top-style: solid; border-top-width: 1px" bgcolor="#9999FF"> '
cMensag  += '		<font size="2" face="Tahoma" color="#0000FF">Endereço</font></td> '
cMensag  += '		<td width="86%" style="border-left-style: solid; border-left-width: 1px; border-right: 1px solid #808080; border-top-style: solid; border-top-width: 1px; border-bottom-style: solid; border-bottom-width: 1px" colspan="5" bgcolor="#9999FF"> '
cMensag  += '		<font face="Tahoma" size="2">'+cEndCli+'</font></td> '
cMensag  += '	</tr> ' + CRLF
cMensag  += '	<tr> '
cMensag  += '		<td width="14%" style="border-left: 1px solid #C0C0C0; border-right-style: solid; border-right-width: 1px; border-top-style: solid; border-top-width: 1px; border-bottom-style: solid; border-bottom-width: 1px" bgcolor="#9999FF"> '
cMensag  += '		<font size="2" face="Tahoma" color="#0000FF">Bairro</font></td> '
cMensag  += '		<td width="20%" style="border-left-style: solid; border-left-width: 1px; border-right: 1px solid #808080; border-top-style: solid; border-top-width: 1px; border-bottom-style: solid; border-bottom-width: 1px" bgcolor="#9999FF"> '
cMensag  += '		<font face="Tahoma" size="2">'+cBaiCli+'</font></td> '
cMensag  += '		<td width="8%" style="border-left-style: solid; border-left-width: 1px; border-right: 1px solid #808080; border-top-style: solid; border-top-width: 1px; border-bottom-style: solid; border-bottom-width: 1px" bgcolor="#9999FF"> '
cMensag  += '		<p align="center"><font size="2" face="Tahoma" color="#0000FF">Cidade</font></td> '
cMensag  += '		<td width="38%" style="border-left-style: solid; border-left-width: 1px; border-right: 1px solid #808080; border-top-style: solid; border-top-width: 1px; border-bottom-style: solid; border-bottom-width: 1px" bgcolor="#9999FF"> '
cMensag  += '		<font face="Tahoma" size="2">'+cCidCli+'</font></td> '
cMensag  += '		<td width="6%" style="border-left-style: solid; border-left-width: 1px; border-right: 1px solid #808080; border-top-style: solid; border-top-width: 1px; border-bottom-style: solid; border-bottom-width: 1px" bgcolor="#9999FF"> '
cMensag  += '		<p align="center"><font size="2" face="Tahoma" color="#0000FF">Estado</font></td> '
cMensag  += '		<td width="12%" style="border-left-style: solid; border-left-width: 1px; border-right: 1px solid #808080; border-top-style: solid; border-top-width: 1px; border-bottom-style: solid; border-bottom-width: 1px" bgcolor="#9999FF"> '
cMensag  += '		<font face="Tahoma" size="2">'+cEstCli+'</font></td> '
cMensag  += '	</tr> ' + CRLF
cMensag  += '	<tr>'
cMensag  += '		<td colspan="6" align="left" bgcolor="#0066CC" style="border-left: 1px solid #C0C0C0; border-right: 1px solid #808080; border-top-style: solid; border-top-width: 1px; border-bottom-style: solid; border-bottom-width: 1px" height="28">'
cMensag  += '		<p align="center"><b><font face="Tahoma" size="2" color="#FFFFFF">Itens '
cMensag  += '		do Pedido de Venda No. 999999</font></b></td>'
cMensag  += '	</tr>' + CRLF
/**/
cMensag  += '<table border="1" width="100%" style="border-collapse: collapse" id="table3">'
cMensag  += '	<tr>'
cMensag  += '		<td width="3%" bgcolor="#9999FF"><b>
cMensag  += '		<font face="Tahoma" size="2" color="#0000FF">item</font></b></td>'
cMensag  += '		<td width="11%" bgcolor="#9999FF">'
cMensag  += '		<p align="center"><b><font face="Tahoma" size="2" color="#0000FF">Código</font></b></td>'
cMensag  += '		<td width="3%" align="center" bgcolor="#9999FF"><b>'
cMensag  += '		<font face="Tahoma" size="2" color="#0000FF">UM</font></b></td>'
cMensag  += '		<td width="23%" bgcolor="#9999FF"><b>'
cMensag  += '		<font face="Tahoma" size="2" color="#0000FF">Descrição</font></b></td>'
cMensag  += '		<td width="8%" bgcolor="#9999FF"><b>'
cMensag  += '		<font face="Tahoma" size="2" color="#0000FF">Quantidade</font></b></td>'
cMensag  += '		<td width="7%" align="center" bgcolor="#9999FF"><b>'
cMensag  += '		<font face="Tahoma" size="2" color="#0000FF">Preço Liq.</font></b></td>'
cMensag  += '		<td width="8%" align="center" bgcolor="#9999FF"><b>
cMensag  += '		<font face="Tahoma" size="2" color="#0000FF">Preço Lista</font></b></td>' 
cMensag  += '		<td width="8%" align="center" bgcolor="#9999FF"><b>'                      
cMensag  += '		<font size="2" face="Tahoma" color="#0000FF">Total R$</font></b></td>'
cMensag  += '		<td width="7%" bgcolor="#9999FF">'
cMensag  += '		<p align="center"><b><font face="Tahoma" size="2" color="#0000FF">% Desc.</font></b></td>'
cMensag  += '		<td width="9%" bgcolor="#9999FF">'
cMensag  += '		<p align="center"><b><font face="Tahoma" size="2" color="#0000FF">Desc.Max.</font></b></td>'
cMensag  += '		<td width="11%" align="center" bgcolor="#9999FF">'
cMensag  += '		<p align="center"><b><font face="Tahoma" size="2" color="#0000FF">% '
cMensag  += '		Com. Vend. 1</font></b></td>'
cMensag  += '	</tr>' + CRLF
/*
---------------------------------------
Impressao dos itens do Pedido de Venda
---------------------------------------*/
cCorLinha := "BR"		//background branco
For _nCnt := 1 To Len(Acols)
	If acols[_nCnt,Len(aCols[_nCnt])] == .F.		//Verifica se linha esta deletada
		If cCorLinha == 'BR'
			cMensag  += '	<tr>'
			cMensag  += '		<td width="3%"><font size="2" face="Tahoma">'+StrZero(_nCnt,2)+'</font></td>'
			cMensag  += '		<td width="11%"><font face="Tahoma" size="2">'+aCols[_nCnt,nPosProd]+'</font></td>'
			cMensag  += '		<td width="3%" align="center"><font face="Tahoma" size="2">'+aCols[_nCnt,nPosUM]+'</font></td>'
			cMensag  += '		<td width="23%"><font face="Tahoma" size="2">'+aCols[_nCnt,nPosDescr]+'</font></td>'
			cMensag  += '		<td width="8%">'
			cMensag  += '		<p align="right"><font face="Tahoma" size="2">'+Transform(aCols[_nCnt,nPosQtdVen],"@E 999,999.999")+'</font></td>'
			cMensag  += '		<td width="7%" align="center"><font face="Tahoma" size="2">'+Transform(aCols[_nCnt,nPosPrcVen],"@E 999.999")+'</font></td>'
			cMensag  += '		<td width="8%" align="center"><font size="2" face="Tahoma">'+Transform(aCols[_nCnt,nPosPrcLst],"@E 999.999")+'</font></td>'
			cMensag  += '		<td width="8%" align="center"><font face="Tahoma" size="2">'+Transform(aCols[_nCnt,nPosValor],"@E 999,999.99")+'</font></td>'
		/*	------------------------------------------
			Identifica o item que bloqueou o PV
			------------------------------------------*/
            If aCols[_nCnt,nPosDesCon] <= aCols[_nCnt,nPosDesMax]     //Muda cor do campo
				cMensag  += '		<td width="7%" align="right"><font face="Tahoma" size="2">'+Transform(aCols[_nCnt,nPosDesCon],"@E 99.99")+'</font></td>'
			Else
				cMensag  += '		<td width="7%" align="right"><font face="Tahoma" size="2" color="#FF0000">'+Transform(aCols[_nCnt,nPosDesCon],"@E 99.99")+'</font></td>'
			EndIf
			cMensag  += '		<td width="9%" align="right"><font face="Tahoma" size="2">'+Transform(aCols[_nCnt,nPosDesMax],"@E 99.99")+'</font></td>'
			cMensag  += '		<td width="11%" align="right"><font face="Tahoma" size="2">'+Transform(aCols[_nCnt,nPosComis1],"@E 99.99")+'</font></td>'
			cMensag  += '	</tr>' + CRLF

			cCorLinha := "AZ"		        
        Else     
			cMensag  += '	<tr>'
			cMensag  += '		<td width="3%" bgcolor="#9999FF"><font size="2" face="Tahoma">'+StrZero(_nCnt,2)+'</font></td>'
			cMensag  += '		<td width="11%" bgcolor="#9999FF"><font face="Tahoma" size="2">'+aCols[_nCnt,nPosProd]+'</font></td>'
			cMensag  += '		<td width="3%" align="center" bgcolor="#9999FF"><font face="Tahoma" size="2">'+aCols[_nCnt,nPosUM]+'</font></td>'
			cMensag  += '		<td width="23%" bgcolor="#9999FF"><font face="Tahoma" size="2">'+aCols[_nCnt,nPosDescr]+'</font></td>'
			cMensag  += '		<td width="8%" bgcolor="#9999FF"><p align="right"><font face="Tahoma" size="2">'+Transform(aCols[_nCnt,nPosQtdVen],"@E 999,999.999")+'</font></td>'
			cMensag  += '		<td width="7%" align="center" bgcolor="#9999FF"><font face="Tahoma" size="2">'+Transform(aCols[_nCnt,nPosPrcVen],"@E 999.999")+'</font></td>' 
			cMensag  += '		<td width="8%" align="center" bgcolor="#9999FF"><font size="2" face="Tahoma">'+Transform(aCols[_nCnt,nPosPrcLst],"@E 999.999")+'</font></td>'
			cMensag  += '		<td width="8%" align="center" bgcolor="#9999FF"><font face="Tahoma" size="2">'+Transform(aCols[_nCnt,nPosValor],"@E 999,999.99")+'</font></td>'
		/*	------------------------------------------
			Identifica o item que bloqueou o PV
			------------------------------------------*/
            If aCols[_nCnt,nPosDesCon] <= aCols[_nCnt,nPosDesMax]     //Muda cor do campo
				cMensag  += '		<td width="7%" align="right" bgcolor="#9999FF"><font face="Tahoma" size="2">'+Transform(aCols[_nCnt,nPosDesCon],"@E 99.99")+'</font></td>'
			Else
				cMensag  += '		<td width="7%" align="right" bgcolor="#9999FF"><font face="Tahoma" size="2" color="#FF0000">'+Transform(aCols[_nCnt,nPosDesCon],"@E 99.99")+'</font></td>'
			EndIf		
			cMensag  += '		<td width="9%" align="right" bgcolor="#9999FF"><font face="Tahoma" size="2">'+Transform(aCols[_nCnt,nPosDesMax],"@E 99.99")+'</font></td>'
			cMensag  += '		<td width="11%" align="right" bgcolor="#9999FF"><font face="Tahoma" size="2">'+Transform(aCols[_nCnt,nPosComis1],"@E 99.99")+'</font></td>'
			cMensag  += '	</tr>' + CRLF

			cCorLinha := "BR"					
        EndIf
		nTotalPV += aCols[_nCnt,nPosValor]
		nTotalDC += aCols[_nCnt,nPosValDes]
		nTotalDM += 0
	EndIf
Next
/**/
cMensag  += '	<tr>'
cMensag  += '		<td colspan="11">&nbsp;</td>'
cMensag  += '	</tr>' + CRLF
cMensag  += '</table> '
/**/
cMensag  += '<table border="1" width="100%" style="border-collapse: collapse; border-left-width: 0px; border-right-width: 0px; border-top-width: 0px" id="table4"> '
cMensag  += '	<tr> '
cMensag  += '		<td width="620" align="right" bgcolor="#9999FF" style="border-right-style: none; border-right-width: medium; border-bottom-style: solid; border-bottom-width: 1px"> '
cMensag  += '		<b><font face="Tahoma" size="2" color="#0000FF">Total do Pedido R$</font></b></td> '
cMensag  += '		<td align="right" bgcolor="#9999FF" style="border-left-style: none; border-left-width: medium; border-bottom-style: solid; border-bottom-width: 1px"> '
cMensag  += '		<b><font face="Tahoma" size="2" color="#0000FF">'+Transform(nTotalPV,"@E 999,999.99")+'</font></b></td> '
cMensag  += '	</tr> ' + CRLF
cMensag  += '	<tr> '
cMensag  += '		<td width="620" align="right" bgcolor="#9999FF" style="border-left: 1px solid #C0C0C0; border-right-style: none; border-right-width: medium; border-bottom-style: solid; border-bottom-width: 1px"> '
cMensag  += '		<b><font face="Tahoma" size="2" color="#0000FF">Desconto Concedido R$</font></b></td> '
cMensag  += '		<td align="right" bgcolor="#9999FF" style="border-left-style: none; border-left-width: medium; border-right: 1px solid #808080; border-bottom-style: solid; border-bottom-width: 1px"> '
cMensag  += '		<b><font face="Tahoma" size="2" color="#0000FF">'+Transform(nTotalDC,"@E 999,999.99")+'</font></b></td> '
cMensag  += '	</tr> ' + CRLF
cMensag  += '</table> '
cMensag += '</body>' + CRLF 
cMensag += '</html>' + CRLF 
/*
-----------------------------
Envia e-Mail
-----------------------------*/
//U_RShXF09(cMensag)

Return
/*
------------------------------------------------------------------------------
Funcao    : RSHXF09()
Data      : 18.09.07
------------------------------------------------------------------------------
Descricao : Envio de E-Mail
------------------------------------------------------------------------------
Retorno   : Nenhum
------------------------------------------------------------------------------*/
User Function RSHXF09(xBody)
Local lResulConn := .T.
Local lResulSend := .T.
Local cError := ""
Local cTitulo  := "Pedido de Venda Bloqueado"
Local cServer  := Trim(GetMV("MV_RELSERV")) // smtp.ig.com.br ou 200.181.100.51
Local cEmail   := Trim(GetMV("MV_RELACNT")) // fulano@ig.com.br
Local cPass    := Trim(GetMV("MV_RELPSW"))  // 123abc

Local cDe      := Space(200)
Local cPara    := Space(200)
Local cCc      := Space(200)
Local cAssunto := Space(200)
Local cAnexo   := Space(200)
Local cMsg     := ""

Local _cUsr  := __cUSERID
Local _aUsr1 := {}
Local _aUsr2 := {}
Local _aUsr3 := {}

Local _eMailUsr  := ""
Local _eMailResp := SuperGetMV("MV_X_EMAIL")

If Empty(cServer) .And. Empty(cEmail) .And. Empty(cPass)
   MsgAlert("Não foi definido os parâmetros do server do Protheus para envio de e-mail",cTitulo)
   Return
Endif
/*
----------------------------
Identifica E_Mail do Usuario
----------------------------*/
PswOrder(1)

If PswSeek(_cUsr)
	_aUsr1 := PswRet(1)
	_aUsr2 := PswRet(2)
	_aUsr3 := PswRet(3)
Endif

_eMailUsr := _aUsr1[1,14]

cDe      := _eMailUsr		//	"microsiga@gruposhangrila.com.br"
cPara    := _eMailResp 		//	"microsiga@gruposhangrila.com.br"
cCC      := "norberto@gruposhangrila.com.br"  //"admin@gruposhangrila.com.br" // _eMailResp		
cAssunto := "Pedido de Venda No. " + SC5->C5_NUM + " - BLOQUEADO"
cAnexo   := ""
cMsg     := xBody
/*
------------------------------
Conexao com Servidor de E-Mail
------------------------------*/

U_SHENVMAIL({},{},'',cAssunto,'',cMsg,cPara,'','',cDe)

CONNECT SMTP SERVER cServer ACCOUNT cDe PASSWORD cPass TIMEOUT 120 RESULT lResulConn       //cEmail

If !lResulConn
   GET MAIL ERROR cError
   MsgAlert("Falha na conexão "+cError)
   Return(.F.)
Endif

// Sintaxe: SEND MAIL FROM cDe TO cPara CC cCc SUBJECT cAssunto BODY cMsg ATTACHMENT cAnexo RESULT lResulSend
// Todos os e-mail terão: De, Para, Assunto e Mensagem, porém precisa analisar se tem: Com Cópia e/ou Anexo

If Empty(cCc) .And. Empty(cAnexo)
	SEND MAIL FROM cDe TO cPara SUBJECT cAssunto BODY cMsg RESULT lResulSend
Else
	If Empty(cCc) .And. !Empty(cAnexo)
		SEND MAIL FROM cDe TO cPara SUBJECT cAssunto BODY cMsg ATTACHMENT cAnexo RESULT lResulSend   
	ElseIf !Empty(cCc) .And. Empty(cAnexo)
		SEND MAIL FROM cDe TO cPara CC cCc SUBJECT cAssunto BODY cMsg RESULT lResulSend   
	Else
		SEND MAIL FROM cDe TO cPara CC cCc SUBJECT cAssunto BODY cMsg ATTACHMENT cAnexo RESULT lResultSend   		   
	Endif
Endif
   
If !lResulSend
   GET MAIL ERROR cError
   MsgAlert("Falha no Envio do e-mail: " + cError)
Endif

DISCONNECT SMTP SERVER

Return(.T.)
/*
------------------------------------------------------------------------------
Funcao    : RSHXF10()
Data      : 04.10.07
------------------------------------------------------------------------------
Descricao : Gatilho no campo C6_PRCVEN 
------------------------------------------------------------------------------
Objetivo  : Quando houver Regra permitir alterar preco unitario acima da tabela
------------------------------------------------------------------------------
*/
User Function RSHXF10()
Local _nPosPrVen:= aScan(aHeader,{|x|Upper(AllTrim(x[2])) == "C6_PRCVEN"}) 
Local _nPosPLst2:= aScan(aHeader,{|x|Upper(AllTrim(x[2])) == "C6_X_PRLST"})
Local _nPrcVen  := aCols[N,_nPosPrVen]


If !"Adriana Ismael Mendes" $ Alltrim(USRFULLNAME(__CUSERID))
	If aCols[N,_nPosPrVen] < aCols[N,_nPosPLst2] .and. !Funname()$"U_RGUAX001"
		ApMsgAlert("Preço de Venda MENOR que preço de Tabela")
	//	_nPrcVen := 0									//	Retirado por Marcos 29/09/08
		_nPrcVen := aCols[N,_nPosPLst2]					//	Alterado por Marcos 29/09/08
		aCols[N,_nPosPrVen] = aCols[N,_nPosPLst2]		//  Acrescentado por Marcos 29/09/08
	EndIf
EndIf

Return(_nPrcVen)                                                       
/*
------------------------------------------------------------------------------
Funcao    : RSHXF11()
Data      : 18.10.07
------------------------------------------------------------------------------
Descricao : Gatilho no campo C6_QTDVEN
------------------------------------------------------------------------------
Objetivo  : Verificar saldo disponivel na colocacao do pedido
------------------------------------------------------------------------------*/
User Function RSHXF11()
Local _nPosPro    := aScan(aHeader,{|x|Upper(AllTrim(x[2])) == "C6_PRODUTO"}) 
Local _nPosQtd    := aScan(aHeader,{|x|Upper(AllTrim(x[2])) == "C6_QTDVEN"}) 
Local _nSaldoDisp := 0
Local _nSaldo     := 0
Local _nReserva   := 0
Local _nQtdPed    := 0
Local _aArea      := GetArea()

dbSelectArea("SB2")
dbSetOrder(1)
/*
-----------------------------------------------
Soma os saldos de todos os almoxarifados
-----------------------------------------------*/
If INCLUI .and. ALTERA
SB2->(MsSeek(xFilial("SB2")+aCols[N,_nPosPro]))

While SB2->(!Eof()).And. SB2->B2_COD == aCols[N,_nPosPro]
	_nSaldo   += SB2->B2_QATU
	_nReserva += SB2->B2_RESERVA
	_nQtdPed  += SB2->B2_QPEDVEN  
	
	SB2->(dbSkip())
End 
_nSaldoDisp := _nSaldo - (_nReserva + _nQtdPed + aCols[N,_nPosQtd])   

If _nSaldoDisp < 0
	ApMsgAlert("Saldo indisponível.Confirmar prazo de entrega")    
	A440Stok(Nil,"A410")
EndIf          
EnDif

RestArea(_aArea)
Return(aCols[N,_nPosQtd])   

/*
Funcao    : RSHXF01()
Data      : 30.03.07
------------------------------------------------------------------------------
Descricao : Validacao da Regra de Desconto/Valida RD para Produto/Grupo
------------------------------------------------------------------------------
Parametros: ExpC1 - Codigo da Regra
------------------------------------------------------------------------------
Retorno   : Logico (.T./.F.)
------------------------------------------------------------------------------
Obs.: Validacao no campo C5_X_CODRE
------------------------------------------------------------------------------

User Function RSHXF01()  
Local  lRet      := M->C5_X_CODRE
Local  cUFDestino:= SA1->A1_EST
Local  aArea     := GetArea()
Local  cEstNorte := GETMV("MV_NORTE")
Public cAlqIcms  

If !Empty(M->C5_X_CODRE)
	dbSelectArea("SZ0")
	dbSetOrder(2)
 
	If cUFDestino == 'SP'
		cAlqIcms := '18'
		cCodReg  := '1'   
		cRegiao  := "No Estado"
	Else
		If cUFDestino $ cEstNorte
			cAlqIcms := '7'
			cCodReg  := '2'  
			cRegiao  := "Norte/Nordeste"
		Else
			cAlqIcms := '12'
			cCodReg  := '3'
			cRegiao  := "Demais Estados"
		EndIf
	EndIf

	SZ0->(MsSeek(xFilial("SZ0")+M->C5_X_CODRE+cCodReg)) 
	If SZ0->(!Found())
		ApMsgAlert("Regra não Cadastrada para a Regiao: "+ cEstNorte +" - "+cRegiao ,"Aviso") 
		lRet := ""
	EndIf
EndIf	
RestArea(aArea)
Return(lRet)
*/
