#INCLUDE "Protheus.ch"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "SET.CH"
#Include "FILEIO.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³  WMSFIFO ºAutor  ³ Reinaldo Dias      º Data ³  01/10/2014 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada no momento da execucao do servico de WMS  º±±
±±º          ³ para tratar as restricoes do lote.                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ WMS                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

//User Function WMSQYSEP()
//Local vSaldo := 0
//Return()   

User Function WMSFIFO2()
Local aSldLote := PARAMIXB[1]
Return aSldLote

User Function WMSFIFO()
Local aArea        := GetArea()
Local aAreaSA1     := SA1->(GetArea())
Local aAreaSBE     := SBE->(GetArea())
Local aAreaSB8     := SB8->(GetArea())
Local aAreaDC3     := DC3->(GetArea())
Local aSldPorLote  := PARAMIXB[1]
Local aSomaLote    := {}
Local cLotePicking := ""
Local cAcheiLote   := ""
Local nQtdeDCF     := 0
Local lUsaSld      := .T.
Local lPicking     := .F.
Local lPulmao      := .F.
Local lPickPulmao  := .F.
Local lGrvLog      := SuperGetMV('ES_GRVLOG' , .F., .F.) //Habilita o gravacao do LOG
Local lBloqLot     := SuperGetMV('ES_BLOQLOT', .F., .T.) //Habilita a bloqueio de lote
local nDias        := superGetMv('ES_SLLOGD', .F., 7) // Quantidade de dias para armazenar o log.
Local cArqLog      := "LT"+Alltrim(DCF->DCF_DOCTO)+".LOG"
Local cProduto     := DCF->DCF_CODPRO
Local cLocal       := DCF->DCF_LOCAL
Local nI := 0
local cPathLog     := "\shelflife"
local lShelfNG     := .F.
local cMsgShelf    := ""

if cEmpant <> "02"
	IF !lBloqLot .Or. DCF->DCF_ORIGEM <> "SC9" .Or. DCF->DCF_XRESTR == "N"
		Return Nil
	Endif

	//Dt.Validade Lote + Lote + Prioridade
	ASort(aSldPorLote,,,{|x,y| DtoS(X[7])+x[1]+x[13] < DtoS(y[7])+y[1]+y[13] })
	
	DBSelectArea("SA1")
	DBSetOrder(1) //A1_FILIAL+A1_COD+A1_LOJA
	DBSeek(xFilial("SA1")+DCF->DCF_CLIFOR+DCF->DCF_LOJA)
	
 	IF SA1->A1_FATVALI == 0 .And. SA1->A1_LOTEUNI == "2"
		Return Nil
	Endif
	
	//Identifica se o produto possui estrutura de picking e pulmao no cadastro de sequencia de abastecimento
	DBSelectArea("DC3")
	DBSetOrder(1) //DC3_FILIAL+DC3_CODPRO+DC3_LOCAL+DC3_ORDEM
	DBSeek(xFilial("DC3")+cProduto+cLocal)
	While !Eof() .And. DC3_FILIAL+DC3_CODPRO+DC3_LOCAL == xFilial("DC3")+cProduto+cLocal
		IF !lPulmao .And. DLTipoEnd(DC3->DC3_TPESTR) == 1 //1=Pulmao
			lPulmao := .T.
		Endif
		IF !lPicking .And. DLTipoEnd(DC3->DC3_TPESTR) == 2 //2=Picking
			lPicking := .T.
		Endif
		DBSelectArea("DC3")
		DBSkip()
	Enddo
	
	IF lPulmao .And. lPicking
		lPickPulmao := .T.
	Endif
	
	IF lGrvLog

		//---------------------------------
		//Cria o diretório de shelflife se
		//não existir
		//----------------------------------
		if !file(cPathLog)
			makeDir(cPathLog)
		endif

		//---------------------------------
		//Realiza a limpeza do diretório 
		//considerando a quantidade de dias
		//limite para armazenar o arquivo
		//de log
		//--------------------------------
		oSfUtils := SFUTILS():new()
		oSfUtils:cleanDir(cPathLog,nDias )

		cArqLog := cPathLog +"\"+cArqLog 

		If File(cArqLog)
			hdl := FOpen(cArqLog, 1)
			FSeek(hdl,0,2)
		Else
			hdl := FCreate(cArqLog, 0)
		Endif

		FWrite(hdl,Repl('-',211)+CHR(13)+CHR(10))
		FWrite(hdl,"Usuario: "+cUserName+"   Data: "+Dtoc(Date())+"   Hora: "+Time()+CHR(13)+CHR(10))
		FWrite(hdl,CHR(13)+CHR(10))
		FWrite(hdl,"Produto: "+cProduto+"   Item: "+DCF->DCF_SERIE+"   Local: "+cLocal+"   Lote: "+DCF->DCF_LOTECT+"   Fator Validade: "+Trans(SA1->A1_FATVALI,'@E 999.99 %')+"   Perm. Lote Dif.: "+iif(SA1->A1_LOTEUNI == "2","NÃO","SIM")+"   PickPulmao: "+Trans(lPickPulmao,'')+"   Qtde.Apanhe: "+Trans(DCF->DCF_QUANT,'@E 999,999.999')+CHR(13)+CHR(10))
	
	Endif
	
	//Calcula o saldo total do lote
	For nI:= 1 To Len(aSldPorLote)
		
		cLoteCtl   := PadR(aSldPorLote[nI,1],TamSX3("BF_LOTECTL")[1])
		cNumLote   := PadR(aSldPorLote[nI,2],TamSX3("BF_NUMLOTE")[1])
		cEndereco  := aSldPorLote[nI,03]
		cEstrutura := aSldPorLote[nI,14]
		nSldAtual  := aSldPorLote[nI,5]
		nSldDispo  := aSldPorLote[nI,5]
		lUsaSld    := .T.
		
		//Verifica se o endereco existe no cadastro
		SBE->(DbSetOrder(1)) //BE_FILIAL+BE_LOCAL+BE_LOCALIZ+BE_ESTFIS
		IF !SBE->(DbSeek(xFilial('SBE')+cLocal+cEndereco+cEstrutura))
			nSldDispo := 0
		Endif
		
		//Verifica se o endereco esta bloqueado
		If nSldDispo > 0 .And. SBE->BE_STATUS == '3'
			nSldDispo := 0
		EndIf
		
		//Verifica se foi escolhido um lote especifico
		If nSldDispo > 0 .And. !Empty(DCF->DCF_LOTECT) .And. aSldPorLote[nI,1] <> DCF->DCF_LOTECT
			nSldDispo := 0
		Endif
		
		//Verifica se o saldo esta comprometido em outra OS.
		If nSldDispo > 0
			// cLoc  ,cEnd      ,cProd   ,cLoteCTL,cNumlote,nSaldoSBF,lRadioF,cStatRF,lCache,lAConvo,lUsaEntra,lUsaSaida)
			nSldRF    := ConSldRF(cLocal,cEndereco,cProduto,cLoteCtl,cNumLote,Nil      ,Nil    ,Nil   ,.T.  ,.T.    ,.F.     ,.T.)
			nSldDispo := (nSldAtual + nSldRF)
		Endif
		
		If QtdComp(nSldDispo) <= QtdComp(0)
			lUsaSld := .F.
		EndIf
		
		//Soma a quantidade do lote
		If (nPos := Ascan(aSomaLote,{ |x| x[1] == aSldPorLote[nI,1] })) == 0
			//Lote             ,Data Validade    ,Saldo Ende,UsaSld ,Prioridade        ,Qtde Original
			AAdd(aSomaLote,{aSldPorLote[nI,1],aSldPorLote[nI,7],nSldDispo,lUsaSld,aSldPorLote[nI,13],nSldAtual})
			IF lGrvLog
				IF lPickPulmao .And. DLTipoEnd(aSldPorLote[nI,14]) == 2 //Picking
					cLotePicking += IIF(Empty(cLotePicking),aSldPorLote[nI,1],", "+aSldPorLote[nI,1])
				Endif
			Endif
		Else
			aSomaLote[nPos,3] += nSldDispo
			aSomaLote[nPos,6] += nSldAtual
			aSomaLote[nPos,4] := IIF(aSomaLote[nPos,4],.T.,lUsaSld)
		Endif
		
	Next
	
	//Ordena por o saldo do lote: prioridade + data de validade + lote
	Asort(aSomaLote,,,{|x,y| x[5]+DTOS(x[2])+x[1] < Y[5]+DTOS(y[2])+y[1] })
	
	//Calcula o Shelf Life do Lote
	IF SA1->A1_FATVALI > 0
		
		IF lGrvLog
			FWrite(hdl,CHR(13)+CHR(10))
			FWrite(hdl,"Calculo do Shelf Life"+CHR(13)+CHR(10))
		Endif
		
		DBSelectArea("SB8")
		DBSetOrder(3) //B8_FILIAL+B8_PRODUTO+B8_LOCAL+B8_LOTECTL+B8_NUMLOTE+DTOS(B8_DTVALID)
		For nI:= 1 To Len(aSomaLote)
			DBSeek(xFilial("SB8")+cProduto+cLocal+aSomaLote[nI,1])
			dDataAtual := MsDate()
			nDiaShelf := SB8->B8_DTVALID - SB8->B8_DFABRIC
			nDiasVenc := SB8->B8_DTVALID - dDataAtual
			nPerShelf := Round((nDiasVenc/nDiaShelf)*100,0)
			nPerShelf := 100 - nPerShelf
			IF aSomaLote[nI,4]
				if !(aSomaLote[nI,4] := IIF(nPerShelf >= SA1->A1_FATVALI,.F.,.T.))     //------ > esta indo .f., porque  o npershel = a1_fatvali
					lShelfNg := .T.
				endif
			Endif
			IF lGrvLog
				FWrite(hdl,"Usa Lote: "+Trans(aSomaLote[nI,4],'')+" | Lote: "+aSomaLote[nI,1]+" | Fabr.: "+DTOC(SB8->B8_DFABRIC)+" | Vali: "+DTOC(SB8->B8_DTVALID)+" | Atual: "+DTOC(MsDate())+;
				" | Dia Shelf: "+Trans(nDiaShelf,'@E 999,999')+" | Dia Venc.: "+Trans(nDiasVenc,'@E 999,999')+" | Per Shelf: "+Trans(nPerShelf,'@E 999 %')+;
				" | Sld.Dispo: "+Trans(aSomaLote[nI,3],'@E 999,999.999')+" | Sld.Atual: "+Trans(aSomaLote[nI,6],'@E 999,999.999')+" | Prioridade: "+aSomaLote[nI,5]+CHR(13)+CHR(10))
			Endif

			cMsgShelf += "Usa Lote: "+iif(aSomaLote[nI,4] ,"SIM", "NÃO")+CRLF+;
		                 "Lote: "+aSomaLote[nI,1]+CRLF+;
			             "Data Fabr.: "+DTOC(SB8->B8_DFABRIC)+CRLF+;
			             "Validade: "+DTOC(SB8->B8_DTVALID)+CRLF+;
			             "Data Atual: "+DTOC(MsDate())+CRLF+;
			             "Dias Shelf: "+alltrim(Trans(nDiaShelf,'@E 999,999'))+CRLF+;
			             "Dias Venc.: "+alltrim(Trans(nDiasVenc,'@E 999,999'))+CRLF+;
			             "Per Shelf: "+alltrim(Trans(nPerShelf,'@E 999 %'))+CRLF+;
			             "Sld.Dispo: "+alltrim(trans(SB8->B8_SALDO,'@E 999,999.999'))+CRLF+CRLF	
				
		Next
	Endif
	
	//Lote Unico
	
	IF SA1->A1_LOTEUNI == "2"
		
		//Soma a quantidade de todos os DCF do pedido + produto
		cQuery := " SELECT SUM(DCF_QUANT) AS DCF_TOTAL FROM "+RetSqlName('DCF')
		cQuery += " WHERE DCF_FILIAL='"+xFilial("DCF")+"' AND DCF_SERVIC = '"+DCF->DCF_SERVIC+"' AND DCF_DOCTO='"+DCF->DCF_DOCTO+"'"
		cQuery += " AND DCF_CLIFOR = '"+DCF->DCF_CLIFOR+"' AND DCF_LOJA='"+DCF->DCF_LOJA+"' AND DCF_CODPRO='"+cProduto+"'"
		cQuery += " AND DCF_ORIGEM = 'SC9' AND DCF_STSERV IN ('1','2') AND D_E_L_E_T_=' '"
		cQuery := ChangeQuery(cQuery)
		DbUseArea(.T.,'TOPCONN',TCGENQRY(,,cQuery),"QryDCF",.F.,.T.)
		nQtdeDCF := QryDCF->DCF_TOTAL
		DBSelectArea("QryDCF")
		DBCloseArea()
		
		IF lGrvLog
			FWrite(hdl,CHR(13)+CHR(10))
			FWrite(hdl,"Calculo do Lote Unico  -  Qtde.Total de Apanhe do Pedido: "+Trans(nQtdeDCF,'@E 999,999.999')+CHR(13)+CHR(10))
			For nI:= 1 To Len(aSomaLote)
				FWrite(hdl,"Lote: "+aSomaLote[nI,1]+" | Dt.Validade: "+DTOC(aSomaLote[nI,2])+" | Sld.Dispo: "+Trans(aSomaLote[nI,3],'@E 999,999.999')+" | Sld.Atual: "+Trans(aSomaLote[nI,6],'@E 999,999.999')+" | Prioridade: "+aSomaLote[nI,5]+CHR(13)+CHR(10))
			Next
			IF !Empty(cLotePicking)
				FWrite(hdl,CHR(13)+CHR(10))
				FWrite(hdl,"Lote Selecionado: "+cLotePicking+"   para estrutura de picking e pulmao"+CHR(13)+CHR(10))
			Endif
		Endif
		
		//Buscar o lote que atenda a quantidade solicitada
		For nI:= 1 To Len(aSomaLote)
			IF aSomaLote[nI,4] .And. QtdComp(aSomaLote[nI,3]) >= QtdComp(nQtdeDCF)
				cAcheiLote := aSomaLote[nI,1]
				IF lGrvLog
					IF Empty(cLotePicking)
						FWrite(hdl,CHR(13)+CHR(10))
					Endif
					FWrite(hdl,"Lote Selecionado: "+cAcheiLote+"   Sld.Dispo: "+Trans(aSomaLote[nI,3],'@E 999,999.999')+"   Qtde.Total de Apanhe do Pedido: "+Trans(nQtdeDCF,'@E 999,999.999')+CHR(13)+CHR(10))
				Endif
				Exit
			Endif
		Next
		
		IF lGrvLog .And. Empty(cAcheiLote)
			FWrite(hdl,CHR(13)+CHR(10))
			FWrite(hdl,"Nao foi possivel selecionar lote para essa quantidade de apanhe: "+Trans(nQtdeDCF,'@E 999,999.999')+CHR(13)+CHR(10))
		Endif
		
		//Zera o saldo do lote que nao foi escolhido
		For nI:= 1 To Len(aSldPorLote)
			nSldAtual := aSldPorLote[nI,5]
			IF aSldPorLote[nI,5] > 0 .And. aSldPorLote[nI,1] <> cAcheiLote
				aSldPorLote[nI,5] := IIF(lPickPulmao .And. DLTipoEnd(aSldPorLote[nI,14]) == 2,aSldPorLote[nI,5],0)
			Endif
			IF lGrvLog
				cLoteCtl   := PadR(aSldPorLote[nI,1],TamSX3("BF_LOTECTL")[1])
				cNumLote   := PadR(aSldPorLote[nI,2],TamSX3("BF_NUMLOTE")[1])
				cEndereco  := aSldPorLote[nI,03]
				nSldRF     := ConSldRF(cLocal,cEndereco,cProduto,cLoteCtl,cNumLote,Nil      ,Nil    ,Nil   ,.T.  ,.T.    ,.F.     ,.T.)
				nSldDispo  := (nSldAtual + nSldRF)
				FWrite(hdl,"Usa Lote: "+Trans(IIF(aSldPorLote[nI,5] > 0 .And. nSldDispo > 0,.T.,.F.),'')+" | Endereco: "+aSldPorLote[nI,3]+" | Lote: "+aSldPorLote[nI,1]+;
				" | Sld.Dispo: "+Trans(nSldDispo,'@E 999,999.999')+" | Sld.Atual: "+Trans(nSldAtual,'@E 999,999.999')+" | Estrutura: "+aSldPorLote[nI,14]+;
				IIF(aSldPorLote[nI,5] > 0 .And. nSldDispo > 0," *","")+CHR(13)+CHR(10))
			Endif
		Next
		
	Endif
	
	//Fator de validade do lote
	IF SA1->A1_FATVALI > 0
		IF lGrvLog
			FWrite(hdl,CHR(13)+CHR(10))
			FWrite(hdl,"Enderecos do Shelf Life"+CHR(13)+CHR(10))
			IF !Empty(cLotePicking)
				FWrite(hdl,"Lote Selecionado: "+cLotePicking+"   para estrutura de picking e pulmao"+CHR(13)+CHR(10))
			Endif
		Endif
		//Zera o saldo do lote dos lotes que nao atende o Shelf Life
		For nI:= 1 To Len(aSldPorLote)
			IF aSldPorLote[nI,5] > 0 .And. (nPos := Ascan(aSomaLote,{ |x| x[1] == aSldPorLote[nI,1] })) > 0
				nSldAtual := aSldPorLote[nI,5]
				IF !aSomaLote[nPos,4]
					aSldPorLote[nI,5] := IIF(lPickPulmao .And. DLTipoEnd(aSldPorLote[nI,14]) == 2,aSldPorLote[nI,5],0)
				Endif
				IF lGrvLog
					cLoteCtl   := PadR(aSldPorLote[nI,1],TamSX3("BF_LOTECTL")[1])
					cNumLote   := PadR(aSldPorLote[nI,2],TamSX3("BF_NUMLOTE")[1])
					cEndereco  := aSldPorLote[nI,03]
					nSldRF     := ConSldRF(cLocal,cEndereco,cProduto,cLoteCtl,cNumLote,Nil      ,Nil    ,Nil   ,.T.  ,.T.    ,.F.     ,.T.)
					nSldDispo  := (nSldAtual + nSldRF)
					FWrite(hdl,"Usa Lote: "+Trans(IIF(aSldPorLote[nI,5] > 0 .And. nSldDispo > 0,.T.,.F.),'')+" | Endereco: "+aSldPorLote[nI,3]+" | Lote: "+aSldPorLote[nI,1]+;
					" | Sld.Dispo: "+Trans(nSldDispo,'@E 999,999.999')+" | Sld.Atual: "+Trans(nSldAtual,'@E 999,999.999')+" | Estrutura: "+aSldPorLote[nI,14]+;
					IIF(aSldPorLote[nI,5] > 0 .And. nSldDispo > 0," *","")+CHR(13)+CHR(10))
				Endif
			Endif
		Next
	Endif

	if lShelfNG
		aEval(aSldPorLote, {|aLote|aLote[5] := 0})
		eecview("***LOTE BLOQUEADO SHELF LIFE***"+CRLF+cMsgShelf)
	endif

	IF lGrvLog
		FWrite(hdl,CHR(13)+CHR(10))
		FClose(hdl)
	Endif
	
	RestArea(aAreaSA1)
	RestArea(aAreaSB8)
	RestArea(aAreaSBE)
	RestArea(aAreaDC3)
	RestArea(aArea)
	
	
else
	
	//http://tdn.totvs.com/pages/releaseview.action?pageId=36306993
	
	//-- Ordenar vetor -> Endereço + Lote + Sub-Lote + Prioridade
	ASort(aSldPorLote,,,{|x,y| x[16]+x[13]+x[3]+DtoS(X[7])+x[1]+x[2] < y[16]+y[13]+y[3]+DtoS(y[7])+y[1]+y[2] })
	
	
Endif

Return(aSldPorLote)
