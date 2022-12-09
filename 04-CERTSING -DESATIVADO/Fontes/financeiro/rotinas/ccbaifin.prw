#include "protheus.ch"
/*/{Protheus.doc} CCBAIFIN

@decription Rotina que executa a baixa dos títulos de cartão identificados no arquivo de retorno da operadora.

@Param cCart   	, caracter 	, - Numero do Cartao, em compras e-commerce ï¿½ uma string de zeros.
@Param cAutC   	, caracter 	, - Codigo de Autenticacao do banco. Pode se repetir.
@Param cVlrP   	, caracter 	, - Valor de compra, se parcelado, valor da parcela.
@Param cParc   	, caracter 	, - Nï¿½mero da parcela atual, ser for venda a vista ï¿½ zero.
@Param cDtCpr  	, caracter 	, - Data da compra.
@Param nSaldo  	, numérico 	, - Saldo a se dar baixa.
@Param cDtBx   	, caracter 	, - Data prevista de pagamento.
@Param cTipReg 	, caracter 	, - "B" baixa por pagamento, "C" baixa por cancelamento.
@Param nHandle 	, numérico 	, - Handle do arquivo do banco.
@Param nHandlog	, numérico 	, - Handle do arquivo de log.
@Param cRv     	, caracter 	, - Resumo de venda utilizado na operação
@Param nRecAtu 	, numérico 	, - Linha do Arquivo
@Param cSomLog 	, caracter 	, - Resposta do usuï¿½rio indicando se ï¿½ somente para gerar log.
@Param cArquivo	, caracter 	, - Nome do arquivo.
@Param cPV     	, caracter 	, - Numero do estabelecimento de venda.
@Param cTID    	, caracter 	, - ID das transacoes de e-commerce.
@Param cTipLin 	, caracter 	, -
@Param cConta  	, caracter 	, - Conta utilizada na transação
@Param cDoc  	, caracter 	, - Numero de documento da transação.
@Param cPedSite	, caracter 	, - Pedido Site
@Param cBandeira, caracter 	, - Numero de documento da transação.
@Param aProc   	, array 	, - Utilizado para gravar o Log
@Param nRecnoPBS, numérico 	, - Recno da tabela PBS(Conciliação resumo de venda)

@author Totvs SM - David
@since 10/09/2011
@version P11

@Obs Alterado por Giovanni A Rodrigues em 28/11/14 para tratamento novo ponto de faturamento.

/*/

User Function CCBAIFIN(cID,aParam)                
                      
Local cSql 		:= ""
Local cMsgLog	:= ""
Local nSaldoTit := 0
Local lRetF		:= .T.
Local aParcela	:= {{"00","  "},{"01","A "},{"02","B "},{"03","C "},{"04","D "},{"05","E "},{"06","F "},{"07","G "},{"08","H "},{"09","I "},{"10","J "},{"11","K "},{"12","L "},{"13","M "},{"14","N "},{"15","O "},{"16","P "},{"17","Q "},{"18","R "},{"19","S "},{"20","T "},{"21","U "},{"22","V "},{"23","X "},{"24","W "},{"25","Y "},{"26","Z "}}
Local cParSql	:= " "
Local nPosPar	:= 0
Local cTipcar	:= ""
Local cNaturez	:= GetMv( 'MV_XNATVST', .F. ) //GetNewPar("MV_XNATVST","1=FT010013,2=FT010014,3=FT010012,4=FT010017")
Local cTpNat	:= ""
Local aNaturez	:= {}
Local cCondPag	:= GetNewPar("MV_XCPSITE", "0=000,1=001,2=2X ,3=3XA,4=4XA,5=5XA,6=6XA")
Local aCondPag	:= {}
Local nTime		:= 0
Local cLockName	:= ""
Local nWait		:= 0

Local cCart		:= aParam[1]
Local cAutC		:= aParam[2]
Local cVlrP		:= aParam[3]
Local cParc		:= aParam[4]
Local cDtCpr	:= aParam[5]
Local nSaldo	:= aParam[6]
Local cDtBx		:= aParam[7]
Local cTipReg	:= aParam[8]
Local nHandle	:= aParam[9]
Local cArqLog	:= aParam[10]
Local cRv		:= aParam[11]
Local nRecAtu	:= aParam[12]
Local cSomLog	:= aParam[13]
Local cArquivo	:= aParam[14]
Local cPV		:= aParam[15]
Local cTID		:= aParam[16]
Local cTipLin	:= aParam[17]
Local cConta	:= aParam[18]
Local cDoc		:= aParam[19]
Local cPedSite	:= aParam[20]
Local cBandeira	:= aParam[21]
Local aProc		:= aParam[22]
Local nRecnoPBS	:= IiF( Len(aParam) > 22, aParam[23], 0 )
Local nI		:= 0

Private lMsErroAuto := .F.
Private lMsHelpAuto := .F.

Default cTID      := ""
Default cTipLin   := ""
Default cConta	   := ""
Default cPedSite  := ""
Default cBandeira := ""
Default aProc     := {""}

cDtCpr:=DtoS(StoD(cDtCpr)-30)

aCondPag		:= StrTokArr(cCondPag,",")
aNaturez		:= StrTokArr(cNaturez,",")

//Verifica, pelo numero do estabelecimento, se foi uma venda E-COMMERCE ou P.O.S
If cPV $ '1026746911,1001889042,1035241916,1060102959,009907513,9918029984'
	cTipcar	:= "E-COMMERCE"
ElseIf cPV $ '014293595,9916732639'
	cTipcar	:= "P.O.S."
EndIf

//Tratamento para os cartoes antigos, que nao sao processados pelo CTSA012
If cConta == ""
	If Left(cCart,1) == '3'
		cConta := "AMEX"
	ElseIf Left(cCart,1) $ '0,4'
		cConta := "VISA"
	ElseIf Left(cCart,1) == '5,6' .or. empty(cCart)
		cConta := "REDECARD"
	EndIf
EndIf

If Alltrim(cConta) == "AMEX"
	cTpNat := "3"
ElseIf Alltrim(cConta) == "VISA"
	cTpNat := "1"
ElseIf Alltrim(cConta) == "REDECARD"
	cTpNat := "2"
ElseIf Alltrim(cConta) == "CIELO"
	If cBandeira == 'VISA'
		cTpNat := '1'
	Elseif cBandeira == 'MASTERCARD'
		cTpNat := '2'
	Elseif cBandeira == 'ELO'
		cTpNat := '2'
	Elseif cBandeira == 'DINERS'
		cTpNat := '2'
	Elseif cBandeira == 'AMEX'
		cTpNat := '3'
   	Elseif cBandeira == 'HIPERCARD'
		cTpNat := '2'
   	Endif
ElseIf Alltrim(cConta) == 'REDE'
	If cBandeira == '3'
		cTpNat := '1'
	ElseIF cBandeira $ '1|2|E'
		cTpNat := '2' 
	Else
		cTpNat := '3'
	EndIF
Endif

If Empty( cBandeira )
	cBandeira := cConta
Endif

//Formata o código de autenticação
If Left(cCart,1) <> '3' .and. !Empty(cAutC) .and. Len(Alltrim(cAutC))< 6  // para AMEX  é sempre tamanho 3
	cAutC := Replicate("0",6-Len(Alltrim(cAutC)))+cAutC
EndIf

//A parcela atual a ser buscada no SE1, se for invalida gera erro.
nPosPar	:= Ascan(aParcela, {|x| x[1] == StrZero(Val(cParc),2)})
If nPosPar > 0
	cParSql := aParcela[nPosPar,2]
Else
	cMsgLog := cArquivo+";"+AllTrim(StrZERO(nRecAtu,6))+";Parcela Informada no Arquivo Invalida "
	cMsgLog += iif(cTipReg == "B",";Baixar",";ChargeBack")
	cMsgLog += ";"+iif(!empty(cCart),AllTrim(cCart),"")
	cMsgLog += ";"+iif(!empty(cAutC),Alltrim(cAutC),"")
	cMsgLog += ";"+iif(!empty(cRv),Alltrim(cRv),"")
	cMsgLog += ";"+iif(!empty(cParc),AllTrim(cParSql),"")
	cMsgLog += ";"+iif(nSaldo > 0,Transform(nSaldo,"@E 999,999.99"),"")
	cMsgLog += ";"+iif(!empty(cDtBx),DtoC(StoD(cDtBx)),"")
	cMsgLog += ";"+iif(!empty(cDtCpr),DtoC(StoD(cDtCpr)),"")
	cMsgLog += ";"+iif(!empty(cPv),cPv,"")
	cMsgLog += ";"+iif(!empty(cDoc),AllTrim(cDoc),"")
	cMsgLog += ";"
	cMsgLog += ";"
	cMsgLog += ";"
	cMsgLog += ";"
	cMsgLog += ";"+iif(!empty(cTID),cTID,"")
	cMsgLog += ";"+iif(!empty(cPedSite),cPedSite,"")
	cMsgLog += ";LOG"
	cMsgLog += CRLF
	
	c740GrvLog(cArqLog,ProcLine(),cMsgLog)
	
	U_GTPutOUT(cID,"J",cPedSite,{"CCBAIFIN",cMsgLog},cPedSite)
	Return(.F.)
EndIf

lAchouPedido:=.F.
//Identificar o pedido de venda com base nos dados do cartão
//SQL  encontrar o pedido de venda
If !Empty(cPedSite)
	cSql := " SELECT "
	cSql += " 	C5.R_E_C_N_O_ RECC5 "
	cSql += " FROM "
	cSql += " 	"+RetSqlName("SC5")+" C5  "
	cSql += " WHERE "
	cSql += " 	C5.C5_FILIAL = '"+xFilial("SC5")+"' AND "
	//	cSql += " 	C5.C5_EMISSAO >= '"+cDtCpr+"' AND "  //      Retirado pr Giovanni.20151105. Não se faz necessário porque as altorizações podem ocorrer depois que o pedido entrou no erp
	cSql +=	" C5.C5_XNPSITE = '"+Alltrim(cPedSite)+"' AND "
	cSql += " 	D_E_L_E_T_ = ' ' "
	//--------------------------->ORDER BY C5_FILIAL, C5_XNPSITE
	
	If select("TMPC5") > 0
		TMPC5->(DbCloseArea())
	EndIf
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),"TMPC5",.F.,.T.)
	IF !TMPC5->(Eof())
		lAchouPedido:=.T.
	Endif
	
	aProc[ 1 ] := aProc[ 1 ] + ';' + cPedSite + ';' + Iif(lAchouPedido,SC5->C5_NUM,'NAOPEDPROTHEUS')
Else
	aProc[ 1 ] := aProc[ 1 ] + ';' + 'NAOPEDSITE' + ';' + 'NAOPEDPROTHEUS'
EndIf

If !lAchouPedido .and.!Empty(cTID)
	cSql := " SELECT "
	cSql += " 	C5.R_E_C_N_O_ RECC5 "
	cSql += " FROM "
	cSql += " 	"+RetSqlName("SC5")+" C5  "
	cSql += " WHERE "
	cSql += " 	C5.C5_FILIAL = '"+xFilial("SC5")+"' AND "
	//	cSql += " 	C5.C5_EMISSAO >= '"+cDtCpr+"' AND "
	cSql +=	" C5.C5_XDOCUME = '"+Alltrim(cTID)+"' AND "  //Procura o TID como número de documento
	cSql += " 	D_E_L_E_T_ = ' ' "
	
	If select("TMPC5") > 0
		TMPC5->(DbCloseArea())
	EndIf
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),"TMPC5",.F.,.T.)
	IF !TMPC5->(Eof())
		lAchouPedido:=.T.
	Endif
	aProc[ 1 ] := aProc[ 1 ] + ';' + cTid + ';' + Iif(lAchouPedido,SC5->C5_NUM,'NAOPEDPROTHEUS')
Else
	aProc[ 1 ] := aProc[ 1 ] + ';' + 'NAOTID' + ';' + 'NAOPEDPROTHEUS'
EndIf

If !lAchouPedido .and.!Empty(cTID)
	cSql := " SELECT "
	cSql += " 	C5.R_E_C_N_O_ RECC5 "
	cSql += " FROM "
	cSql += " 	"+RetSqlName("SC5")+" C5  "
	cSql += " WHERE "
	cSql += " 	C5.C5_FILIAL = '"+xFilial("SC5")+"' AND "
	//	cSql += " 	C5.C5_EMISSAO >= '"+cDtCpr+"' AND "
	cSql +=	" C5.C5_XTIDCC = '"+Alltrim(cTID)+"' AND "  //Procura o TID Criar indice
	cSql += " 	D_E_L_E_T_ = ' ' "
	
	If select("TMPC5") > 0
		TMPC5->(DbCloseArea())
	EndIf
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),"TMPC5",.F.,.T.)
	IF !TMPC5->(Eof())
		lAchouPedido:=.T.
	Endif
	aProc[ 1 ] := aProc[ 1 ] + ';' + cTid + ';' + Iif(lAchouPedido,SC5->C5_NUM,'NAOPEDPROTHEUS')
Else
	aProc[ 1 ] := aProc[ 1 ] + ';' + 'NAOTID' + ';' + 'NAOPEDPROTHEUS'
EndIf

If !lAchouPedido .and. !Empty(cAutC) .AND. !Empty(cDoc) // Se existe número de documento e Autenticação, então utiliza esta informação para encontrar o pedido
	cSql := " SELECT "
	cSql += " 	C5.R_E_C_N_O_ RECC5 "
	cSql += " FROM "
	cSql += " 	"+RetSqlName("SC5")+" C5  "
	cSql += " WHERE "
	cSql += " 	C5.C5_FILIAL = '"+xFilial("SC5")+"' AND "
	//	cSql += " 	C5.C5_EMISSAO >= '"+cDtCpr+"' AND "
	cSql += " 	SUBSTR(C5.C5_XCODAUT,1,6) = '"+Alltrim(cAutC)+"' AND "
	if !alltrim(cconta)=="AMEX"
		cSql += "   SUBSTR(C5.C5_XDOCUME,LENGTH(TRIM(C5.C5_XDOCUME))-5,6) = '"+Alltrim(cDoc )+"' AND "
	else
		cSql += "   TRIM(C5.C5_XDOCUME) = '"+Alltrim(cDoc )+"' AND "
	EndiF
	cSql += " 	D_E_L_E_T_ = ' ' "
	
	If select("TMPC5") > 0
		TMPC5->(DbCloseArea())
	EndIf
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),"TMPC5",.F.,.T.)
	IF !TMPC5->(Eof())
		lAchouPedido:=.T.
	Endif
	
	aProc[ 1 ] := aProc[ 1 ] + ';' + cAutC + ';' + cDoc + ';' + Iif(lAchouPedido,SC5->C5_NUM,'NAOPEDPROTHEUS')
Else
	aProc[ 1 ] := aProc[ 1 ] + ';' + 'NAOCODAUTENT' + ';' + 'NAODOCUMENTO' + ';' + 'NAOPEDPROTHEUS'
Endif

If !lAchouPedido .and. !Empty(cAutC)   //Em ultimo caso procura pelo número do cartão de crédito e código de autorização
	cSql := " SELECT "
	cSql += " 	C5.R_E_C_N_O_ RECC5 "
	cSql += " FROM "
	cSql += " 	"+RetSqlName("SC5")+" C5  "
	cSql += " WHERE "
	cSql += " 	C5.C5_FILIAL = '"+xFilial("SC5")+"' AND "
	//	cSql += " 	C5.C5_EMISSAO >= '"+cDtCpr+"' AND "
	cSql += " 	SUBSTR(C5.C5_XCODAUT,1,6) = '"+Alltrim(cAutC)+"' AND "
	cSql += " 	C5.C5_XCARTAO = '"+SubStr(AllTrim(cCart),1,6)+"******"+SubStr(AllTrim(cCart),13,4)+"' AND "
	cSql += " 	D_E_L_E_T_ = ' ' "
	
	If select("TMPC5") > 0
		TMPC5->(DbCloseArea())
	EndIf
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),"TMPC5",.F.,.T.)
	IF !TMPC5->(Eof())
		lAchouPedido:=.T.
	Else
		cSql := " SELECT C5.R_E_C_N_O_ RECC5 "
		cSql += " FROM "+RetSqlName("SC5")+" C5  "
		cSql += " WHERE C5.C5_FILIAL = '"+xFilial("SC5")+"' "
		cSql += " 	    AND SUBSTR(C5.C5_XCODAUT,1,6) = '"+Alltrim(cAutC)+"' "
		cSql += " 	    AND C5.C5_XCARTAO = '"+SubStr(AllTrim(cCart),1,4)+"********"+SubStr(AllTrim(cCart),13,4)+"' "
		cSql += " 	    AND D_E_L_E_T_ = ' ' "
		If select("TMPC5") > 0
			TMPC5->(DbCloseArea())
		EndIf
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),"TMPC5",.F.,.T.)
		IF !TMPC5->(Eof())
			lAchouPedido:=.T.
		Endif
	Endif
	aProc[1]:=aProc[1]+';'+cAutC+';'+SubStr(AllTrim(cCart),1,6)+"******"+SubStr(AllTrim(cCart),13,4)+';'+Iif(lAchouPedido,SC5->C5_NUM,'NAOPEDPROTHEUS')
Else
	aProc[1]:=aProc[1]+';'+'NAOCODAUTENT'+';'+IIf(Empty(cCart),'NAOCARTAO',SubStr(AllTrim(cCart),1,6)+"******"+SubStr(AllTrim(cCart),13,4))+';'+'NAOPEDPROTHEUS'
Endif

If !lAchouPedido .and. !Empty(cCart) .And. !Empty(cDoc) //Em ultimo caso procura pelo número do cartão de crédito e código de autorização
	cSql := " SELECT "
	cSql += " 	C5.R_E_C_N_O_ RECC5 "
	cSql += " FROM "
	cSql += " 	"+RetSqlName("SC5")+" C5  "
	cSql += " WHERE "
	cSql += " 	C5.C5_FILIAL = '"+xFilial("SC5")+"' AND "
	//	cSql += " 	C5.C5_EMISSAO >= '"+cDtCpr+"' AND "
	if !alltrim(cconta)=="AMEX"
		cSql += "   SUBSTR(C5.C5_XDOCUME,LENGTH(TRIM(C5.C5_XDOCUME))-5,6) = '"+Alltrim(cDoc )+"' AND "
	else
		cSql += "   TRIM(C5.C5_XDOCUME) = '"+Alltrim(cDoc )+"' AND "
	Endif
	cSql += " 	C5.C5_XCARTAO = '"+SubStr(AllTrim(cCart),1,6)+"******"+SubStr(AllTrim(cCart),13,4)+"' AND "
	cSql += " 	D_E_L_E_T_ = ' ' "
	
	If select("TMPC5") > 0
		TMPC5->(DbCloseArea())
	EndIf
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),"TMPC5",.F.,.T.)
	IF !TMPC5->(Eof())
		lAchouPedido:=.T.
	Else
		cSql := " SELECT C5.R_E_C_N_O_ RECC5 "
		cSql += " FROM "+RetSqlName("SC5")+" C5  "
		cSql += " WHERE C5.C5_FILIAL = '"+xFilial("SC5")+"' "
		If !alltrim(cconta)=="AMEX"
			cSql += "    AND SUBSTR(C5.C5_XDOCUME,LENGTH(TRIM(C5.C5_XDOCUME))-5,6) = '"+Alltrim(cDoc )+"' "
		Else
			cSql += "    AND TRIM(C5.C5_XDOCUME) = '"+Alltrim(cDoc )+"' "
		Endif
		cSql += " 	    AND C5.C5_XCARTAO = '"+SubStr(AllTrim(cCart),1,4)+"********"+SubStr(AllTrim(cCart),13,4)+"' "
		cSql += " 	    AND D_E_L_E_T_ = ' ' "
		If Select("TMPC5") > 0
			TMPC5->(DbCloseArea())
		EndIf
		
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),"TMPC5",.F.,.T.)
		IF !TMPC5->(Eof())
			lAchouPedido:=.T.
		Endif
	Endif
	aProc[1]:=aProc[1]+';'+cDoc+';'+SubStr(AllTrim(cCart),1,6)+"******"+SubStr(AllTrim(cCart),13,4)+';'+Iif(lAchouPedido,SC5->C5_NUM,'NAOPEDPROTHEUS')
Else
	aProc[1]:=aProc[1]+';'+'NAODOCUMENTO'+';'+IIf(Empty(cCart),'NAOCARTAO',SubStr(AllTrim(cCart),1,6)+"******"+SubStr(AllTrim(cCart),13,4))+';'+'NAOPEDPROTHEUS'
Endif

//30.01.2018 - Alteração RBeghini para compras AMEX
If !lAchouPedido .and. !Empty(cCart) .And. !Empty(cAutC) .And. Alltrim(cconta) == "AMEX"
	cSql := " SELECT "
	cSql += " 	C5.R_E_C_N_O_ RECC5 "
	cSql += " FROM "
	cSql += " 	"+RetSqlName("SC5")+" C5  "
	cSql += " WHERE "
	cSql += " 	C5.C5_FILIAL = '"+xFilial("SC5")+"' AND "
	cSql += " 	SUBSTR(C5.C5_XCODAUT,1,6) = '" + Alltrim(cAutC) + "' AND "
	cSql += " 	C5.C5_XCARTAO = '" + SubStr(AllTrim(cCart),1,6) + "*****" + SubStr(AllTrim(cCart),12,4) + "' AND "
	cSql += " 	D_E_L_E_T_ = ' ' "
	
	If select("TMPC5") > 0
		TMPC5->(DbCloseArea())
	EndIf
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),"TMPC5",.F.,.T.)
	IF !TMPC5->(Eof())
		lAchouPedido:=.T.
	Endif
	
	aProc[ 1 ] := aProc[ 1 ] + ';' + cAutC + ';' + cCart + ';' + Iif(lAchouPedido,SC5->C5_NUM,'NAOPEDPROTHEUS')
Else
	aProc[ 1 ] := aProc[ 1 ] + ';' + 'NAOCODAUTENT' + ';' + 'NAOCARTAO' + ';' + 'NAOPEDPROTHEUS'
EndIF

If lAchouPedido
	SC5->(DBGOTO(TMPC5->RECC5))
	
	//-- Tratamento para utilizar chave exclusiva.
	nTime := Seconds()
	cLockName := ProcName() + cID + SC5->C5_NUM
	
	Sleep( Randomize( 1, 499 ) )
	
	While !LockByName(cLockName)

		nWait := Seconds() - nTime
		
		//Tratamento para meia-noite
		If nWait < 0
			nWait += 86400
		Endif
	
		If nWait > 180
			// Passou de 40 segundos tentando ? Desiste ! (4 tentativas)
			U_GTPutOUT(cID,"J",cDoc,{"CCBAIFIN","Falha ao realizar Lock para uso exclusivo do registro.",aProc[1]},cDoc)
			Return( .F. )
		Endif
	
		// Espera um pouco ( 10 segundos ) para tentar novamente
		Sleep( Randomize( 5000, 6000 ) )

	EndDo
	
	aProc[ 1 ] := aProc[ 1 ] + ';' + SC5->C5_CLIENTE + ';' + SC5->C5_LOJACLI + ';' + ;
	SA1->( GetAdvFVal( 'SA1', 'A1_NOME', xFilial( 'SA1' ) + SC5->( C5_CLIENTE + C5_LOJACLI ), 1 ) ) + ';' + SC5->C5_NOTA + ';' + SC5->C5_SERIE
	
	If SC5->C5_TIPMOV == '1' .OR. !alltrim(SC5->C5_XNATURE) $ ("FT010012","FT010013","FT010014","FT010017")
		If ValType(aCondPag)=="A" .and. Len(aCondPag) > 0 .and. !Empty(SC5->C5_XNPARCE)
			nPosPg := ascan(aCondPag,{|x| SubStr(alltrim(x),1,1) == Alltrim(Str(Val(SC5->C5_XNPARCE))) })
			If nPosPg > 0
				nPosAt := At("=",aCondPag[nPosPg])
				If nPosAt > 0
					cCondPag := SubStr( aCondPag[nPosPg],nPosAt+1,Len(aCondPag[nPosPg]) )
				Else
					cCondPag := Right(aCondPag[nPosPg],3)
				EndIf
			Else
				cCondPag := "000"
			EndIf
		Else
			cCondPag := "000"
		EndIf
		
		If ValType(aNaturez)=="A" .and. Len(aNaturez) > 0
			nPosNt := ascan(aNaturez,{|x| SubStr(alltrim(x),1,2) == Alltrim(Strzero(Val(cTpNat),2)) })
			If nPosNt > 0
				cNaturez := Right(alltrim(aNaturez[nPosNt]),8)
			Else
				cNaturez := "FT010010"
			EndIf
		Else
			cNaturez := "FT010010"
		EndIf
		
		SC5->( RecLock( "SC5", .F. ) )
		
		SC5->C5_TIPMOV	:= "2"
		SC5->C5_XNATURE := cNaturez
		
		If Empty( SC5->C5_NOTA )
			SC5->C5_CONDPAG := cCondPag
		Endif
		cObs := SC5->C5_XOBS
		SC5->C5_XOBS := cObs + CRLF + "Alteração de forma de pagamento devido identificação de pagamento via Cartão"
		
		If cConta == 'CIELO' .AND. cBandeira <> ''
			SC5->C5_XBANDEI := cBandeira
		Endif
		
		IF cConta == 'REDE' .And. nRecnoPBS > 0
			DbSelectArea('PBU')
			PBU->( dbSetOrder(1) )
			PBU->( dbSeek( xFilial('PBU') + cBandeira ) )
			SC5->C5_XBANDEI := PBU->PBU_DESC
			SC5->C5_XRVCC	:= cRv
			PBS->( dbGoto( nRecnoPBS ) )
			PBS->( RecLock('PBS',.F.) )
				PBS->PBS_RECSC5	:= SC5->( Recno() )
			PBS->( MsUnlock() )
		EndIF

		SC5->C5_XCARTAO := cCart
		SC5->C5_XNUMCAR := cCart
		SC5->C5_XCODAUT := cAutC
		SC5->C5_XTIDCC  := cTID
		SC5->C5_XDOCUME := cDoc

		SC5->(MsUnLock())
		
	Endif
	
	IF cTipReg == "B" // Baixa/ Recebimento normal/Compensação
		//Gerar NCC e Movimento Bancário Pelo total recebido e amarrar ao pedido. (somente para tipo de baixa igual a B)
		aLog := fTrataNcc(cTipReg,SC5->C5_NUM, cParSql,nSaldo, cDtBx,cConta,cParc,cArquivo,nRecAtu,cSomLog, cDoc,cAutC,cTID,cDtCpr,aProc,cBandeira,nRecnoPBS,cPV,cRv)
		
		If Len(aLog)>0
			//Não faz tratamento
			cMsgLog := cArquivo+";"+AllTrim(StrZero(nRecAtu,6))+";Registro referente Baixa/compensação normal"
			cMsgLog += ";Baixa/compensação"
			cMsgLog += ";"+iif(!empty(cCart),AllTrim(cCart),"")
			cMsgLog += ";"+iif(!empty(cAutC),Alltrim(cAutC),"")
			cMsgLog += ";"+iif(!empty(cRv),Alltrim(cRv),"")
			cMsgLog += ";"+iif(!empty(cParc),AllTrim(cParc)+"/"+SC5->C5_XPARCEL,"")
			cMsgLog += ";"+iif(nSaldo > 0,Transform(nSaldo,"@E 999,999.99"),"")
			cMsgLog += ";"+iif(!empty(cDtBx),DtoC(StoD(cDtBx)),"")
			cMsgLog += ";"+iif(!empty(cDtCpr),DtoC(StoD(cDtCpr)),"")
			cMsgLog += ";"+iif(!empty(cPv),cPv,"")
			cMsgLog += ";"+iif(!empty(cDoc),AllTrim(cDoc),"")
			cMsgLog += ";"+Transform(SC5->C5_TOTPED,"@E 999,999.99")
			cMsgLog += ";"+DtoC(SC5->C5_EMISSAO)
			cMsgLog += "; ORIGEMPV ;"+SC5->C5_XORIGPV
			cMsgLog += ";"+SC5->C5_CHVBPAG
			cMsgLog += ";"+iif(!empty(cTID),cTID,"")
			cMsgLog += ";"+iif(!empty(cPedSite),cPedSite,"")
			cMsgLog += ";"
			
			For nI := 1 To Len( aLog )
				cMsgLog +="LOG "+ Alltrim(STR(nI))+" "+  aLog[ nI, 2] +" "
			Next
			cMsgLog += CRLF
			c740GrvLog(cArqLog,ProcLine(),cMsgLog)

			U_GTPutOUT(cID,"J",cPedSite,{"CCBAIFIN",{.F.,"M00002",cMsgLog}},cPedSite)
			
			For nI := 1 To Len( aLog )
				If .NOT. aLog[ nI, 1 ]
					FWrite( nHdl470, cMsgLog + CRLF )
				Endif
			Next nI
		Endif
	ElseIf cTipReg == "C" // Baixa por Charge Back
		
		//Baixa NCC Por Charge Back
		aLog := fTrataNcc(cTipReg,SC5->C5_NUM, cParSql,nSaldo, cDtBx,cConta,cParc,cArquivo,nRecAtu,cSomLog, cDoc,cAutC,cTID,cDtCpr,aProc,cBandeira,nRecnoPBS,cPV,cRv)
		
		If Len(aLog)>0
			cMsgLog := cArquivo+";"+AllTrim(StrZero(nRecAtu,6))+";Registro referente a ChargeBack "
			cMsgLog += ";ChargeBack ou Estorno"
			cMsgLog += ";"+iif(!empty(cCart),AllTrim(cCart),"")
			cMsgLog += ";"+iif(!empty(cAutC),Alltrim(cAutC),"")
			cMsgLog += ";"+iif(!empty(cRv),Alltrim(cRv),"")
			cMsgLog += ";"+iif(!empty(cParc),AllTrim(cParc)+"/"+SC5->C5_XPARCEL,"")
			cMsgLog += ";"+iif(nSaldo > 0,Transform(nSaldo,"@E 999,999.99"),"")
			cMsgLog += ";"+iif(!empty(cDtBx),DtoC(StoD(cDtBx)),"")
			cMsgLog += ";"+iif(!empty(cDtCpr),DtoC(StoD(cDtCpr)),"")
			cMsgLog += ";"+iif(!empty(cPv),cPv,"")
			cMsgLog += ";"+iif(!empty(cDoc),AllTrim(cDoc),"")
			cMsgLog += ";"+Transform(SC5->C5_TOTPED,"@E 999,999.99")
			cMsgLog += ";"+DtoC(SC5->C5_EMISSAO)
			cMsgLog += "; ORIGEMPV ;"+SC5->C5_XORIGPV
			cMsgLog += ";"+SC5->C5_CHVBPAG
			cMsgLog += ";"+iif(!empty(cTID),cTID,"")
			cMsgLog += ";"+iif(!empty(cPedSite),cPedSite,"")
			cMsgLog += ";LOG"
			cMsgLog += CRLF
			c740GrvLog(cArqLog,ProcLine(),cMsgLog)
			
			U_GTPutOUT(cID,"J",cPedSite,{"CCBAIFIN",cMsgLog},cPedSite)
			
			For nI := 1 To Len( aLog )
				cMsgLog +="LOG "+ Alltrim(STR(nI))+" "+  aLog[ nI, 2] +" "
			Next
			cMsgLog += CRLF
			c740GrvLog(cArqLog,ProcLine(),cMsgLog)
			
			U_GTPutOUT(cID,"J",cPedSite,{"CCBAIFIN",cMsgLog},cPedSite)
			
			For nI := 1 To Len( aLog )
				If .NOT. aLog[ nI, 1 ]
					FWrite( nHdl470, cMsgLog + CRLF )
				Endif
			Next nI
			
			Return(.F.)
		EndIF		
	Else
		//Não faz tratamento
		cMsgLog := cArquivo+";"+AllTrim(StrZero(nRecAtu,6))+";Não exite tratamento para este tipo de registro "
		cMsgLog += "; Tipo de registro não identificado "
		cMsgLog += ";"+iif(!empty(cCart),AllTrim(cCart),"")
		cMsgLog += ";"+iif(!empty(cAutC),Alltrim(cAutC),"")
		cMsgLog += ";"+iif(!empty(cRv),Alltrim(cRv),"")
		cMsgLog += ";"+iif(!empty(cParc),AllTrim(cParc)+"/"+SC5->C5_XPARCEL,"")
		cMsgLog += ";"+iif(nSaldo > 0,Transform(nSaldo,"@E 999,999.99"),"")
		cMsgLog += ";"+iif(!empty(cDtBx),DtoC(StoD(cDtBx)),"")
		cMsgLog += ";"+iif(!empty(cDtCpr),DtoC(StoD(cDtCpr)),"")
		cMsgLog += ";"+iif(!empty(cPv),cPv,"")
		cMsgLog += ";"+iif(!empty(cDoc),AllTrim(cDoc),"")
		cMsgLog += ";"+Transform(SC5->C5_TOTPED,"@E 999,999.99")
		cMsgLog += ";"+DtoC(SC5->C5_EMISSAO)
		cMsgLog += "; ORIGEMPV ;"+SC5->C5_XORIGPV
		cMsgLog += ";"+SE1->E1_PEDGAR
		cMsgLog += ";"+iif(!empty(cTID),cTID,"")
		cMsgLog += ";"+iif(!empty(cPedSite),cPedSite,"")
		cMsgLog += ";LOG"
		cMsgLog += CRLF
		c740GrvLog(cArqLog,ProcLine(),cMsgLog)
		U_GTPutOUT(cID,"J",cPedSite,{"CCBAIFIN",cMsgLog},cPedSite)
		Return(.F.)
	Endif
	
	//-- Desfaz Lock para utilização de registro exclusivo.
	UnLockByName(cLockName)
	
Else

	aProc[ 1 ] := aProc[ 1 ] + ';' + 'PEDIDO_NAO_LOCALIZADO' + ';' + 'XX' + ';' + 'XXXXXXXXXX' + ';' + 'XXXXXX' + ';' + 'XXX'
	
	//Pedido não encontrado
	cMsgLog := "#"+cArquivo+";"+AllTrim(StrZero(nRecAtu,6))+";Pedido não encontrado"
	cMsgLog += "; Pedido não encontrado "
	cMsgLog += ";"+iif(!empty(cCart),AllTrim(cCart),"")
	cMsgLog += ";"+iif(!empty(cAutC),Alltrim(cAutC),"")
	cMsgLog += ";"+iif(!empty(cRv),Alltrim(cRv),"")
	cMsgLog += ";"+iif(!empty(cParc),AllTrim(cParc)+"/"+SC5->C5_XPARCEL,"")
	cMsgLog += ";"+iif(nSaldo > 0,Transform(nSaldo,"@E 999,999.99"),"")
	cMsgLog += ";"+iif(!empty(cDtBx),DtoC(StoD(cDtBx)),"")
	cMsgLog += ";"+iif(!empty(cDtCpr),DtoC(StoD(cDtCpr)),"")
	cMsgLog += ";"+iif(!empty(cPv),cPv,"")
	cMsgLog += ";"+iif(!empty(cDoc),AllTrim(cDoc),"")
	cMsgLog += ";"+Transform(0,"@E 999,999.99")
	cMsgLog += ";" "
	cMsgLog += "; ORIGEMPV ;"
	cMsgLog += ";"
	cMsgLog += ";"+iif(!empty(cTID),cTID,"")
	cMsgLog += ";"+iif(!empty(cPedSite),cPedSite,"")
	cMsgLog += ";LOG"
	cMsgLog += CRLF
	c740GrvLog(cArqLog,ProcLine(),cMsgLog)
	U_GTPutOUT(cID,"J",cPedSite,{"CCBAIFIN",cMsgLog},cPedSite)
	Return(.F.)
EndIf
Return (.t.)

/*/{Protheus.doc} CCBAIFIN

Rotina para tratamento de NCC e PR dos titulos referente ao Cartão de Crédito

/*/

Static Function fTrataNcc(cTipReg,cPedido,cParSql,nSaldo,cDtBx,cConta,cParc,cArquivo,nRecAtu,cSomLog, cDoc,cAutC,cTID,cDtCpr,aProc,cBandeira,nRecnoPBS,cPV,cRv)
Local lRet 		  := .T.
Local aRet		  := {}
Local aBaixa      := {}
Local aFaVlAtuCR  := {}
Local aDadosBaixa := {}
Local aLog        := {}
Local cHistory    := ''
Local aParam      := {}
Local aAnalysis   := {}
Local cNaturez		:= GetNewPar("MV_XNATCLI", "FT010010")
Local nOpcRotina	:= 0
Local aSE1			:= {}
Local dDataCredito	:= Stod(cDtBx)
Local cBco			:= ""
Local cAge			:= ""
Local cCta			:= ""
Local aBanco		:= {}
Local cPrefRP		:= GetNewPar("MV_XPREFRP", "RCP")
Local lFIE			:= .F.
Local lSE5			:= .F.
Local cHistSE5		:= ""
Local nValorE1		:= 0
Local aSe1NF	  	:= {}
Local aSe1PR	  	:= {}
Local aSe1NCC	  	:= {}
Local aSe1BxNccCha:= {}
Local aRecNF  	  	:= {}
Local aAliasAnt   := {}
Local cSeq		  	:= '01'
Local dDataCompra :=Stod(cDtCpr)
Local cMSG	:= ''
Local cRET	:= ''
Local cPedLog	:= ''
Local cDocSE5	:= ''           
Local nI		:= 0

Private cTrbSql   	:=''
// [1]-Contabiliza on-line.
// [2]-Agluitna lançamentos contábeis.
// [3]-Digita lançamento contábeis.
// [4]-Juros para comissão.
// [5]-Desconto para comissão.
// [6]-Calcula comissão para NCC .
aParam := {.F.,.F.,.F.,.F.,.F.,.F.}

//Posiciona no pedido de venda
SC5->( DbSetOrder(1) )		// C5_FILIAL+C5_NUM
SC5->( MsSeek( xFilial("SC5") + cPedido ) )

IF cTipReg=='C'
	
	RecLock("SC5",.F.)
	SC5->C5_ARQVTEX:='CHARGEBACK'
	//ELIMINAR RESÍDUO
	SC5->C5_LIBEROK := "S"
	SC5->C5_NOTA    := Replicate("X",Len(SC5->C5_NOTA))
	SC5->C5_SERIE   := Replicate("X",Len(SC5->C5_SERIE))
	SC5->(MsUnlock())
	
	aProc[ 1 ] := aProc[ 1 ] + 'TIPO = C - CHARGEBACK/ELIMINADO PC POR RESIDUO/GERADO SLV/'
Endif

SC6->( DbSetOrder(1) )		// C5_FILIAL+C5_NUM
SC6->( MsSeek( xFilial("SC6") + cPedido ) )

While .NOT. SC6->(EOF()) .AND.  xFilial("SC6") == SC6->C6_FILIAL .AND. SC6->C6_NUM == cPedido
	IF SC6->C6_XOPER $ "51/52"
		cPrefRP:='RCO'
		IF cTipReg=='C'
			//ELIMINAR RESÍDUO
			SC6->( RecLock( 'SC6', .F. ) )
			SC6->C6_BLQ := 'R'
			SC6->C6_XDTCANC := DdataBase
			SC6->C6_XHRCANC := Time()
			SC6->( MsUnLock() )
		Endif
	ENDIF
	SC6->(DbSkip())
End

If cTipReg=='C'
	//Atuliza controle de ChargeBack por Parcela
	aAliasAnt:= GetArea()
	DbSelectArea("SLV")
	DbSetOrder(1)
	
	//Tratar tamanho do cparc
	If .NOT. DbSeek( xFilial("SLV") + 'RCP' + PadR(SC5->C5_NUM,Len(SLV->LV_NUMERO),' ') + cParSql + 'CHA' + SC5->C5_CLIENTE + SC5->C5_LOJACLI + cSeq )
		SLV->( RECLOCK("SLV",.T.) )
		SLV->LV_FILIAL 	:= xFilial("SLV")
		SLV->LV_DATATEF	:= Dtoc(dDataCompra)
		SLV->LV_DOCTEF		:= cDoc
		SLV->LV_AUTORIZ	:= cAutC
		SLV->LV_INSTITU	:= IIf(cBandeira=='VISA','VISA',Iif(cBandeira $ 'MASTERCARD|ELO|DINERS','REDECARD',cConta))
		SLV->LV_DOCCANC	:= cDoc
		SLV->LV_DATCANC	:= Dtoc(dDataCredito)
		SLV->LV_NSUTEF		:= cTID
		SLV->LV_PREFIXO	:= 'RCP'
		SLV->LV_VALOR		:= nSaldo
		SLV->LV_DATA		:= dDataBase
		SLV->LV_NUMERO		:= SC5->C5_NUM
		SLV->LV_PARCELA	:= cParSql
		SLV->LV_TIPO		:= 'CHA'
		SLV->LV_SEQ			:= cSeq
		SLV->LV_FILORIG	:= xFilial("SLV")
		SLV->LV_CLIENTE	:= SC5->C5_CLIENTE
		SLV->LV_LOJA		:= SC5->C5_LOJACLI
		SLV->(MsUnlock())
	Endif
	RestArea(aAliasAnt)

	//-- Nova intrução para o HUB cancelar o pedido (Rafael Beghini 13.09.2018)
	cMSG := "Processado retorno cartão - ChargeBack em ["+DtoC(Date())+"-"+Time()+"]"
	cRET := SC5->C5_XNPSITE + ';' + SC5->C5_NUM + ';A;CHARGEBACK;' + cMSG
	cPedLog := IIF(!Empty(SC5->C5_CHVBPAG),SC5->C5_CHVBPAG,SC5->C5_XNPSITE)
	
	U_VNDA331( {'01','02',cRET} )
	U_GTPutOUT(SC5->C5_XNPSITE,"X",cPedLog,{"CCBAIFIN",{.F.,"M00002",cMSG}},SC5->C5_XNPSITE)
Endif

If cTipReg == "B" //Gera a NCC para processo de compensação das NFs e/ou substituição das PR's

	aProc[ 1 ] := aProc[ 1 ] + 'TIPO = B - GERA COMPRESAÇÃO COM MOVIMENTO TIPO CHA'

	//gera ncc
	cNaturez := SC5->C5_XNATURE
	nOpcRotina 		:= 3
	aSE1			:= {	cPrefRP,;
	SC5->C5_NUM,;
	"NCC",;
	SC5->C5_XNATURE,;
	SC5->C5_CLIENTE,;
	SC5->C5_LOJACLI,;
	dDataCredito,;
	SC5->C5_NUM,;
	SC5->C5_XNPSITE,;
	SC5->C5_XNPSITE,;
	SC5->C5_TIPMOV,;
	SC5->C5_CHVBPAG,;
	SC5->C5_NUM,;
	cParSql,;
	dDataCredito,;
	'',;
	nRecnoPBS}
	
	lFIE			:= .F.
	lSE5			:= .T.
	
	IF cConta == 'REDE'
		DbSelectArea('PBU')
		PBU->( dbSetOrder(1) )
		PBU->( dbSeek( xFilial('PBU') + cBandeira ) )
		cBco := PBU->PBU_BANCO
		cAge := PBU->PBU_AGENCI
		cCta := PBU->PBU_CONTA
		cDocSE5	:= 'PV: ' + cPV + ', Resumo: ' + cRv
	Else
		cBco := PadR("000",TamSx3("E8_BANCO")[1])
		cAge := PadR("00000",TamSx3("E8_AGENCIA")[1])
		cCta := PadR(IIf(cBandeira=='VISA','VISA',Iif(cBandeira $ 'MASTERCARD|ELO|DINERS','REDECARD',cConta)),TamSx3("E8_CONTA")[1])
	EndIF
	
	aBanco		:= {cBco,cAge,cCta}
	cHistSE5	:= "Ped Site "+Alltrim(SC5->C5_XNPSITE)+" Ped Orig "+IIF(!EMPTY(SC5->C5_CHVBPAG),ALLTRIM(SC5->C5_CHVBPAG),Alltrim(SC5->C5_XPEDORI))
	nValorE1	:= nSaldo
	
	SE1->( dbSetOrder( 2 ) )
	If cSomLog == "0"
		
		If !SE1->( dbSeek( xFilial( 'SE1' ) + aSE1[5] + aSE1[6] + aSE1[1] + PadR(aSE1[2],TAMSX3('E1_NUM')[1]) + aSE1[14] + aSE1[3] ))
			lRet := U_CSFA500( nOpcRotina, nil, nValorE1 ,aSE1, lFIE, lSE5, dDataCredito, aBanco, cHistSE5, cDocSE5 )
			SE5->(MSUNLOCK())
			SE1->(MSUNLOCK())
			SA1->(MSUNLOCK())
		Endif
		
		If !SE1->( dbSeek( xFilial( 'SE1' ) + aSE1[5] + aSE1[6] + aSE1[1] + PadR(aSE1[2],TAMSX3('E1_NUM')[1]) + aSE1[14] + aSE1[3] ))
			lRet := .F.
		Endif
	Else
		lRet := .T.
	Endif
	
	If lRet
		aRet := {.t.,"Geração de NCC para Pedido ERP"+cPedido+" Pedido Site "+SC5->C5_XNPSITE+" realizado com sucesso"}
	Else
		aRet := {.F.,"Não foi gerada NCC para Pedido ERP "+cPedido+" Pedido Site "+SC5->C5_XNPSITE}
	EndIf
		
	//Trata todas as pendências do Pedido
	//Força primeiro o tratamento do PR
	//Identifica as parcelas DE PR em aberto para Subsituição
	//O PR será substituído pela NCC
	nContr := 0
	cSql := "SELECT R_E_C_N_O_ RECE1, E1_SALDO "
	cSql += " FROM "+RetSqlName("SE1")
	cSql += " WHERE E1_FILIAL = '"+xFilial("SE1")+"' AND "
	cSql += " E1_PEDIDO = '"+cPedido+"' AND E1_TIPO='PR' AND"
	if !empty(cParSql)
		cSql += " E1_PARCELA = '"+cParSql+"' AND "
	else
		nContr := nValorE1
	endif
	cSql += " E1_SALDO > 0 AND "
	cSql += " D_E_L_E_T_ = ' ' "
	
	cTrbSql := GetNextAlias()
	PLSQuery( cSql, cTrbSql )
	nDifPR := 0
	While !(cTrbSql)->(Eof())
		nDifPR += (cTrbSql)->e1_saldo
		if nContr == 0 .or. nDifPR <= (nContr+0.02)
			AAdd( aSe1PR, (cTrbSql)->RECE1 )
		endif
		(cTrbSql)->(DbSkip())
	EndDo
	
	(cTrbSql)->(DbCloseArea())
	
	If len(aSe1PR)>0//Baixa provisório correspondente  a parcela
		For nI:=1 to len(aSe1PR)
			
			SE1->( dbGoTo( aSe1PR[nI] ) )
			
			IF cConta == 'REDE'
				DbSelectArea('PBU')
				PBU->( dbSetOrder(1) )
				PBU->( dbSeek( xFilial('PBU') + cBandeira ) )
				cBco := PBU->PBU_BANCO
				cAge := PBU->PBU_AGENCI
				cCta := PBU->PBU_CONTA
			Else
				cBco := PadR("000",TamSx3("E8_BANCO")[1])
				cAge := PadR("00000",TamSx3("E8_AGENCIA")[1])
				cCta := PadR(IIf(cBandeira=='VISA','VISA',Iif(cBandeira $ 'MASTERCARD|ELO|DINERS','REDECARD',cConta)),TamSx3("E8_CONTA")[1])
			EndIF

			nSalE1	:= SE1->E1_SALDO
			
			aBaixa := { "SUB", nSalE1, cBco,cAge,cCta, dDataCredito, dDataCredito }
			
			aFaVlAtuCR := FaVlAtuCr("SE1",dDataCredito)
			
			aSE1Dados := {}
			
			AAdd( aSE1Dados, { aSe1PR[nI], "Bx "+PadR(IIf(cBandeira=='VISA','VISA',Iif(cBandeira $ 'MASTERCARD|ELO|DINERS','REDECARD',cConta)),TamSx3("E8_CONTA")[1])+" PSite.: "+SC5->C5_XNPSITE, AClone( aFaVlAtuCR ) } )
			
			If cSomLog == "0"
				aRet := U_CSFA530( 1, {aSe1PR[nI]}, aBaixa, /*aNCC_RA*/, /*aLiquidacao*/, aParam, /*bBlock*/, /*aEstorno*/, aSE1Dados, /*aNewSE1*/ )
				SE5->(MSUNLOCK())
				SE1->(MSUNLOCK())
				SA1->(MSUNLOCK())
			Else
				aRet := {.T., "Baixa de PR realizada com sucesso para Pedido ERP "+cPedido+" Pedido Site "+SC5->C5_XNPSITE}
			EndIf
			//Grava o Log
			If Len( aRet )>0
				AAdd( aLog, aClone( aRet ) )
				aRet := {}
			Endif
		Next
	Endif
EndIf

//Identifica existencia de NFs para compensação
cSql := "SELECT E1_TIPO, R_E_C_N_O_ RECE1 "
cSql += " FROM "+RetSqlName("SE1")
cSql += " WHERE E1_FILIAL = '"+xFilial("SE1")+"' AND "
cSql += " E1_PEDIDO = '"+cPedido+"' AND E1_TIPO ='NF ' AND "
cSql += " E1_SALDO > 0 AND "
cSql += " D_E_L_E_T_ = ' ' "

cTrbSql:=GetNextAlias()
PLSQuery( cSql, cTrbSql )

While !(cTrbSql)->(Eof())
	AAdd( aSe1NF,{cPedido, (cTrbSql)->RECE1} )
	(cTrbSql)->(DbSkip())
EndDo

(cTrbSql)->(DbCloseArea())

If len(aSe1NF)>0
	//User funtion do M460fin
	//aparan[1] Array com Pedido e Recnos do SE1
	//aparan[2] Valida database para movimentação financeira, Se .T. Será considerada a maior data de emissao para movimentação entre (NF e NCC), (NF e PR) e (NCC e PR)
	U_VldRecPg( aSe1Nf,.T. )
Endif

//Depois de tratadas pendências trata Baixa de NCC por ChergeBack
If cTipReg == "C"
	aSe1NF	  :={}
	aSe1PR	  :={}
	aSe1NCC	  :={}
	
	//Identifica existencia de NFs. Se existir NF com Saldo então não pode baixar a NCC por CHA
	cSql := "SELECT E1_TIPO, R_E_C_N_O_ RECE1 "
	cSql += " FROM "+RetSqlName("SE1")
	cSql += " WHERE E1_FILIAL = '"+xFilial("SE1")+"' AND "
	cSql += " E1_PEDIDO = '"+cPedido+"' AND E1_TIPO = 'NF ' AND "
	cSql += " E1_SALDO > 0 AND "
	cSql += " D_E_L_E_T_ = ' ' "
	
	cTrbSql:=GetNextAlias()
	PLSQuery( cSql, cTrbSql )
	
	While !(cTrbSql)->(Eof())
		AAdd( aSe1NF,{cPedido, (cTrbSql)->RECE1} )
		(cTrbSql)->(DbSkip())
	End
	
	(cTrbSql)->(DbCloseArea())
	
	//Identifica existencia de PR. Se existir PR com Saldo então não pode baixar a NCC por CHA
	cSql := "SELECT E1_TIPO, R_E_C_N_O_ RECE1 "
	cSql += " FROM "+RetSqlName("SE1")
	cSql += " WHERE E1_FILIAL = '"+xFilial("SE1")+"' AND "
	cSql += " E1_PEDIDO = '"+cPedido+"' AND E1_TIPO ='PR ' AND "
	cSql += " E1_SALDO > 0 AND "
	cSql += " D_E_L_E_T_ = ' ' "
	
	cTrbSql:=GetNextAlias()
	PLSQuery( cSql, cTrbSql )
	
	While !(cTrbSql)->(Eof())
		AAdd( aSe1PR,{cPedido, (cTrbSql)->RECE1} )
		(cTrbSql)->(DbSkip())
	EndDo
	
	(cTrbSql)->(DbCloseArea())
	
	If len(aSe1NF)==0 .and. len(aSe1PR)==0
		//Identifica as NCC com Saldo para Baixa por Charge
		cSql := "SELECT R_E_C_N_O_ RECE1 "
		cSql += " FROM "+RetSqlName("SE1")
		cSql += " WHERE E1_FILIAL = '"+xFilial("SE1")+"' AND "
		cSql += " E1_PEDIDO = '"+cPedido+"' AND E1_TIPO='NCC' AND E1_PREFIXO='" +cPrefRP+"'"
		//	cSql += " E1_PARCELA = '"+cParSql+"' AND " //CHARGEBACK VEM PELO MONTANTE
		cSql += " AND E1_SALDO > 0 AND "
		cSql += " D_E_L_E_T_ = ' ' "
		
		cTrbSql := GetNextAlias()
		PLSQuery( cSql, cTrbSql )
		
		While !(cTrbSql)->(Eof())
			AAdd( aSe1BxNccCha, (cTrbSql)->RECE1 )
			(cTrbSql)->(DbSkip())
		End
		
		(cTrbSql)->(DbCloseArea())
		
		If len(aSe1BxNccCha)>0//Baixa NCC por ChargeBack correspondente  a parcela
			For nI:=1 to len(aSe1BxNccCha)
				SE1->( dbGoTo( aSe1BxNccCha[nI] ) )
				
				IF cConta == 'REDE'
					DbSelectArea('PBU')
					PBU->( dbSetOrder(1) )
					PBU->( dbSeek( xFilial('PBU') + cBandeira ) )
					cBco := PBU->PBU_BANCO
					cAge := PBU->PBU_AGENCI
					cCta := PBU->PBU_CONTA
				Else
					cBco := PadR("000",TamSx3("E8_BANCO")[1])
					cAge := PadR("00000",TamSx3("E8_AGENCIA")[1])
					cCta := PadR(IIf(cBandeira=='VISA','VISA',Iif(cBandeira $ 'MASTERCARD|ELO|DINERS','REDECARD',cConta)),TamSx3("E8_CONTA")[1])
				EndIF
				
				nSalE1	:= SE1->E1_SALDO
				
				//aBaixa := { "CHA", nSalE1, cBco,cAge,cCta, dDataCredito, dDataCredito }
				aBaixa := { "CHA", nSalE1, cBco,cAge,cCta, dDataBase, dDataBase }
				
				//aFaVlAtuCR := FaVlAtuCr("SE1",dDataCredito)
				aFaVlAtuCR := FaVlAtuCr("SE1",dDataBase)
				
				aSE1Dados := {}
				
				AAdd( aSE1Dados, { aSe1BxNccCha[nI], "ChargeBack "+PadR(IIf(cBandeira=='VISA','VISA',Iif(cBandeira $ 'MASTERCARD|ELO|DINERS','REDECARD',cConta)),TamSx3("E8_CONTA")[1])+" PSite.: "+SC5->C5_XNPSITE, AClone( aFaVlAtuCR ) } )
				
				If cSomLog == "0"
					aRet := U_CSFA530( 1, {aSe1BxNccCha[nI]}, aBaixa, /*aNCC_RA*/, /*aLiquidacao*/, aParam, /*bBlock*/, /*aEstorno*/, aSE1Dados, /*aNewSE1*/ )
					SE5->(MSUNLOCK())
					SE1->(MSUNLOCK())
					SA1->(MSUNLOCK())
				Else
					aRet := {.T., "Baixa de NCC por ChargeBack realizada com sucesso para Pedido ERP "+cPedido+" Pedido Site "+SC5->C5_XNPSITE}
				EndIf
				//Grava o Log
				If Len( aRet )>0
					AAdd( aLog, aClone( aRet ) )
					aRet := {}
				Endif
			Next
		Endif
	Endif
Endif
Return(aLog)

/*/{Protheus.doc} c740OpenLog
//Função para gravar o arquivo de Log, usando laço
//para garantir a abertura do arquivo.
@author yuri.volpe
@since 01/06/2018
@version 1.0
@return nBytes - Número de bytes gravaso
@param cArqLog, characters, descricao
@param cLin, characters, descricao
@param cMsg, characters, descricao
@type function
/*/
Static Function c740GrvLog(cArqLog,cLin,cMsg)

Local nHdlLog	:= -1
Local nCntLog 	:= 0
Local nBytes	:= 0

IF ValType( cLin ) <> 'C'
	cLin := '0'
EndIF
While nHdlLog == -1
	nHdlLog := FOpen(cArqLog)
	Sleep(5000)
	If ++nCntLog >= 10
		conout("[CSFA740] Erro de Gravação no Arquivo de LOG - Linha: " + cLin)
		conout(cMsg)
		Exit
	EndIf
EndDo

If nHdlLog > -1
	nBytes := FWrite(nHdlLog,cMsg)
EndIf

Return nBytes
