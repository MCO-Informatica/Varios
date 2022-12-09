#include "protheus.ch"
#Include "Font.ch"
#include "rptdef.ch"
#include "FWPrintSetup.ch"

User Function gtr001(cOpcRel)

	//Local cTitulo	:= "Impressão do Orçamento de Vendas"
	//Local oFont06
	//Local oDlg
	Local cPegunta := "Confirma Impressão do "

	Default cOpcRel := "2"

	if scj->cj_status == "B"
		cPegunta += "Pedido ?"
	else
		cPegunta += "Orçamento ?"
	endif

	If MsgYesNO(cPegunta,"Impressão")
		//Processa({|| Orcamento(cOpcRel) },"Imprimindo...")
		MsAguarde({|| Orcamento(cOpcRel)}, "Aguarde...", "Processando impressão...")
	endif

/*
	DEFINE FONT oFont6 NAME "Courier New" BOLD

	DEFINE MSDIALOG oDlg FROM 264,182 TO 400,613 TITLE cTitulo OF oDlg PIXEL

	@ 004,010 TO 050,157 LABEL "" OF oDlg PIXEL
	@ 015,017 SAY "Esta rotina tem por objetivo imprimir:" OF oDlg PIXEL Size 150,010 FONT oFont06 COLOR CLR_HBLUE
	@ 030,017 SAY "Orçamento de Vendas" 				   OF oDlg PIXEL Size 150,010 FONT oFont06 COLOR CLR_HBLUE

	@ 06,167 BUTTON "Pre&view" 		SIZE 036,012 ACTION Imprimir(cOpcRel) 	OF oDlg PIXEL
	@ 28,167 BUTTON "Sai&r"    		SIZE 036,012 ACTION oDlg:End()  OF oDlg PIXEL

	ACTIVATE MSDIALOG oDlg CENTERED
*/
Return


Static Function Imprimir(cOpcRel)

	MsAguarde({|| Orcamento(cOpcRel)}, "Aguarde...", "Processando impressão...")
	Ms_Flush()

Return


Static Function Orcamento(cOpcRel)

	Local cPasta	:= "c:\temp\"
	Local cFilename	:= 'Orc'+dtos(date())+replace(time(),':','')
	Local lAdjustToLegacy	:= .t.
	Local lDisableSetup	:= .t.
	Local nDevice	:= IMP_PDF  //IMP_SPOOL
	//Local nResol	:= 95

	Local oPrn

	Local cNum := ""
	Local nTotOrc := 0
	Local nSubTot := 0
	Local nTotIPI := 0
	Local nTotSol := 0
	Local nPesoItem := 0
	Local nPesoVenda := 0
	Local nPesoTot := 0
	Local nPeso := 0
	Local nPag := 1
	Local nLin := 1650
	//Local cDia := SubStr(DtoS(dDataBase),7,2)
	//Local cMes := SubStr(DtoS(dDataBase),5,2)
	//Local cAno := SubStr(DtoS(dDataBase),1,4)
	//Local cMesExt := MesExtenso(Month(dDataBase))
	//Local cDataImpressao := cDia+" de "+cMesExt+" de "+cAno
	//Local cPercICMS := GetMv("MV_ESTICM")
	//Local nPosICM := 0
	Local nPercICMS := 0
	Local nPercIPI  := 0
	Local nPercPIS	:= 0
	Local nPercCOF  := 0

	Local nFator := 0
	Local cStatus := ""
	Local nqtdP := 0
	Local nqtdF := 0
	Local nM2L := 0
	Local nVRL := 0
	Local nM2T := 0
	Local nVRT := 0
	Local nM2  := 0
	Local nVR  := 0
	Local nvlrM2 := 0
	Local nVD := 0
	Local nVB := 0

	Local nBasICM := 0
	Local nVlrICM := 0
	Local nVlrPIS := 0
	Local nVlrCOF := 0
	Local nVlrIPI := 0
	Local nVlrSol := 0
	Local nVlrTot := 0
	Local nTvrICM := 0

	Local cDescri := ""
	Local cTpprod := ""
	Local cAplic  := ""

	Local oFont08	:= TFont():New("Arial",08,08,,.F.,,,,.T.,.F.)
	Local oFont08N	:= TFont():New("Arial",08,08,,.T.,,,,.T.,.F.)
	Local oFont10  	:= TFont():New("Arial",10,10,,.F.,,,,.T.,.F.)
	Local oFont10N 	:= TFont():New("Arial",10,10,,.T.,,,,.T.,.F.)
	//Local oFont12  	:= TFont():New("Arial",12,12,,.F.,,,,.T.,.F.)
	//Local oFont12N 	:= TFont():New("Arial",12,12,,.T.,,,,.T.,.F.)
	//Local oFont14	:= TFont():New("Arial",14,14,,.F.,,,,.T.,.F.)
	Local oFont14N 	:= TFont():New("Arial",14,14,,.T.,,,,.T.,.F.)
	Local oFont15	:= TFont():New("Arial",15,15,,.F.,,,,.T.,.F.)
	//Local oFont16N 	:= TFont():New("Arial",16,16,,.T.,,,,.T.,.F.)
	Local oFont20N 	:= TFont():New("Arial",20,20,,.T.,,,,.T.,.F.)

	oPrn:=FWMSPrinter():New(cFilename, nDevice, lAdjustToLegacy, , lDisableSetup)
	//oPrn:SetResolution(nResol)
	//oPrn:SetLandscape()   //paisagem
	oPrn:SetPortrait()  //retrato
	//oPrn:SetPaperSize(DMPAPER_A4)
	oPrn:SetPaperSize(DMPAPER_A4)
	//oPrn:SetMargin(0,0,0,0) // nEsquerda, nSuperior, nDireita, nInferior
	//oPrn:Setup()
	oPrn:cPathPDF := alltrim(cPasta) // Caso seja utilizada impressÃ£o em IMP_PDF

	sc6->(dbSetOrder(5))
	sck->(dbSetOrder(1))
	sck->(dbSeek(xFilial()+scj->cj_num))
	if scj->cj_status == "B"
		sc6->( dbseek(xfilial()+sck->ck_cliente+sck->ck_loja+sck->ck_produto) )
		while !sc6->(eof()) .and. sc6->c6_filial == sck->ck_filial .and. sc6->c6_cli == sck->ck_cliente .and. ;
				sc6->c6_loja == sck->ck_loja .and. sc6->c6_produto == sck->ck_produto
			if sck->ck_num+sck->ck_item == sc6->c6_numorc
				cNum := sc6->c6_num
				exit
			endif
			sc6->(dbskip())
		end
	else
		cNum := scj->cj_num
	endif

	sa1->(dbSetOrder(1))
	sa1->(dbSeek(xFilial()+SCJ->CJ_CLIENTE+SCJ->CJ_LOJA))

	sa4->(dbSetOrder(1))
	sa4->(dbSeek(xFilial()+SCJ->CJ_ZZTRANS))

	sa3->(dbSetOrder(1))
	sa3->(dbSeek(xFilial()+SCJ->CJ_ZZVEN))

	da0->(dbSetOrder(1))
	da0->(dbSeek(xFilial()+SCJ->CJ_TABELA))

	sf4->(dbSetOrder(1))
	sf4->(dbSeek(xFilial()+sck->ck_tes))

	se4->(dbSetOrder(1))
	se4->(dbSeek(xFilial()+SCJ->CJ_CONDPAG))

	if scj->cj_xnivel == "2" //.and. scj->cj_xtpfatu == "1"
		nFator := 2
	else
		nFator := 1
	endif

	if scj->cj_status == "A"
		cStatus := "Orçamento"
	elseif scj->cj_status == "B"
		cStatus := "Pedido"
	elseif scj->cj_status == "C"
		cStatus := "Orçamento Cancelado"
	elseif scj->cj_status == "D"
		cStatus := "Não Orçado"
	endif

	oPrn:StartPage()
	/*
	cBitMap := "P:Logo1.Bmp"
	oPrn:SayBitmap(1200,1200,cBitMap,2400,1700)	// Imprime logo da Empresa: comprimento X altura
	*/
	if cOpcRel == "2"
		oPrn:Say(0200,0900,"**** "+cStatus+" ****",oFont20N,,CLR_HBLUE)
		oPrn:Say(0200,2000,OemToAnsi(cNum),oFont08)
	else
		oPrn:Box(0005,0050,0480,2300)
		oPrn:Say(0050,0100,Upper(sm0->m0_nomecom)		,oFont14N)
		oPrn:Say(0050,1070,cStatus+" "+OemToAnsi(cNum),oFont14N)
		oPrn:Say(0050,1950,"Página: "+alltrim(str(nPag)),oFont14N)

		oPrn:Say(0100,0100,sm0->m0_tel					,oFont14N)
		oPrn:Say(0100,1070,"Emissão: "+Dtoc(SCJ->CJ_EMISSAO),oFont14N)

		oPrn:Say(0150,0100,"Cliente:",oFont10N)
		oPrn:Say(0150,0280,OemToAnsi(alltrim(sa1->a1_nome)+" ("+sa1->a1_cod+"-"+sa1->a1_loja+")"),oFont10)

		oPrn:Say(0150,1400,"Tel.:"	,oFont10N)
		oPrn:Say(0150,1530,OemToAnsi("("+sa1->a1_ddd+") "+sa1->a1_tel),oFont10)

		cEndereco := alltrim(sa1->a1_end)+" - "+alltrim(sa1->a1_bairro)+" - "+alltrim(sa1->a1_mun)+" - "+sa1->a1_est+" - CEP: "+Transform(sa1->a1_cep, "@R 99999-999")
		oPrn:Say(0200,0100,"Endereco:",oFont10N)
		oPrn:Say(0200,0280,OemToAnsi(upper(cEndereco)),oFont10)

		oPrn:Say(0250,0100,"CGC/CPF:",oFont10N)
		oPrn:Say(0250,0280,Transform(Alltrim(SA1->A1_CGC),"@R 99.999.999/9999-99"),oFont10)

		oPrn:Say(0250,1070,"Inscricao Estadual:",oFont10N)
		oPrn:Say(0250,1350,Alltrim(SA1->A1_INSCR),oFont10)

		oPrn:Say(0300,0100,"Transp:",oFont10N)
		oPrn:Say(0300,0280,OemToAnsi(ALLTRIM(SA4->A4_NOME)+" ("+SA4->A4_COD+")"),oFont10)
		oPrn:Say(0300,1100,OemToAnsi(alltrim(SA4->A4_BAIRRO)+"  Tel.:"+SA4->A4_TEL),oFont10)

		oPrn:Say(0350,0100,"Vendedor:"	,oFont10N)
		oPrn:Say(0350,0280,OemToAnsi(SA3->A3_NREDUZ)+" ("+SA3->A3_COD+")",oFont10)

		oPrn:Say(0350,1070,"Tabela:" ,oFont10N)
		oPrn:Say(0350,1170,OemToAnsi(DA0->DA0_CODTAB),oFont10)
		oPrn:Say(0350,1220,OemToAnsi(DA0->DA0_DESCRI),oFont10)

		oPrn:Say(0400,0100,"Natureza:"	,oFont10N)
		oPrn:Say(0400,0280,SF4->F4_FINALID,oFont10)

		oPrn:Say(0450,0100,"Frete:" ,oFont10N)
		oPrn:Say(0450,0280,OemToAnsi(scj->cj_xnivel+" Destinatário (FOB)"),oFont10)

	endif

	oPrn:Box(0530,0050,0580,2300)
	oPrn:Say(0560,0060,"IT"		  	,oFont10N)
	oPrn:Say(0560,0100,"Codigo"  	,oFont10N)
	oPrn:Say(0560,0310,"Descricao"	,oFont10N)
	oPrn:Say(0560,0740,"O.C./Obs"	,oFont10N)
	oPrn:Say(0550,1140,"Quantidade" ,oFont08)
	oPrn:Say(0570,1080,"Pedida"		,oFont08N)
	oPrn:Say(0570,1160,"Faturada"	,oFont08N)
	oPrn:Say(0570,1255,"Pendente"	,oFont08N)
	oPrn:Say(0560,1385,"Pr.Unitario",oFont10N)
	oPrn:Say(0560,1580,"Pr. Total" 	,oFont10N)
	if cOpcRel == "1"
		oPrn:Say(0560,1760,"%Ipi"   	,oFont10N)
		oPrn:Say(0560,1945,"%Icms"    	,oFont10N)
		oPrn:Say(0560,2180,"Vlr Icms"	,oFont10N)
	endif

	nLin := 0630
	nSubTot := 	nTotIPI := 	nTotSol:= nTotOrc := nPesoItem := nPesoVenda := nPesoTot := nTvrICM := 0
	nM2 := nVR := nM2L := nVRL := nM2T := nVRT := 0
	sb1->(dbSetOrder(1))
	sb5->(dbSetOrder(1))

	sck->(dbSeek(xFilial()+scj->cj_num))
	While sck->(!Eof()) .and. scj->cj_filial == sck->ck_filial .and. scj->cj_num == sck->ck_num

		sb1->(dbseek(xfilial()+sck->ck_produto))
		if sb5->(dbseek(xfilial()+sck->ck_produto))
			cDescri := alltrim(sb5->b5_ceme)
			sx5->(DbSetOrder(1))
			if sx5->(dbseek(xfilial()+"ZY"+sb5->b5_xaplic))
				cAplic  := alltrim(sx5->x5_descri)
			endif
			cTpprod := sb5->b5_xtpprod
			nvlrM2  := sb5->b5_xm2com
			nPeso	:= sb5->b5_xpeso
		else
			cDescri := alltrim(sck->ck_descri)
			cAplic  := ""
			cTpprod := ""
			nvlrM2  := 0
			nPeso	:= 0
		endif
		sf4->(dbseek(xfilial()+sck->ck_tes))

		nPesoItem  := nPeso
		nPesoVenda := sck->ck_qtdven*nPesoItem
		nTotIPI    += iif(cOpcRel == "1" .and. scj->cj_xnivel == "2" .and. scj->cj_xtpfatu == "2",0,sck->ck_xvlripi)
		nTotSol    += iif(cOpcRel == "1" .and. scj->cj_xnivel == "2" .and. scj->cj_xtpfatu == "2",0,sck->ck_xicmsol)
		nPesoTot   += nPesoVenda
		nSubTot    += iif(cOpcRel == "2" .or. scj->cj_xnivel == "2" .and. scj->cj_xtpfatu == "2",round(sck->ck_valor*nFator,2)+sck->ck_xvlripi+sck->ck_xicmsol,sck->ck_valor)
		nTotOrc    += iif(cOpcRel == "2" .or. scj->cj_xnivel == "2" .and. scj->cj_xtpfatu == "2",round(sck->ck_valor*nFator,2)+sck->ck_xvlripi+sck->ck_xicmsol,sck->ck_xvlrtot)
		nVD		   += sck->ck_valor

		nqtdP := 0
		nqtdF := 0
		if scj->cj_status == "B"
			sc6->( dbseek(xfilial()+sck->ck_cliente+sck->ck_loja+sck->ck_produto) )
			while !sc6->(eof()) .and. sc6->c6_filial == sck->ck_filial .and. sc6->c6_cli == sck->ck_cliente .and. ;
					sc6->c6_loja == sck->ck_loja .and. sc6->c6_produto == sck->ck_produto
				if sck->ck_num+sck->ck_item == sc6->c6_numorc
					nqtdP := sc6->c6_qtdven - sc6->c6_qtdent
					nqtdF := sc6->c6_qtdent
					exit
				endif
				sc6->(dbskip())
			end
		endif

		u_gtf005(sck->ck_produto,@nPercICMS,@nPercIPI,@nPercPIS,@nPercCOF)

		if !empty(sa1->a1_suframa) .or. sa1->a1_cod == '002613' //IRIZAR
			u_gtf001(sa1->a1_cod,sa1->a1_loja,sa1->a1_tipo,sck->ck_produto,scj->cj_condpag,sck->ck_tes,sck->ck_qtdven,sck->ck_prunit,sck->ck_qtdven*sck->ck_prunit,sck->ck_valdesc,@nBasICM,@nVlrICM,@nVlrPIS,@nVlrCOF,@nVlrIPI,@nVlrSol,@nVlrTot)
			nPercPIS := round((nVlrPIS/nBasICM)*100,2)
			nPercCOF := round((nVlrCOF/nBasICM)*100,2)
		endif

		if scj->cj_xnivel == "6"
			nPercICMS := nPercPIS := nPercCOF := 0
		endif

		if scj->cj_xnivel == "2"
			//nVR := ( sck->ck_valor * ((100-sck->ck_xdescV)/100) ) + ( sck->ck_valor - (sck->ck_valor * (nPercPIS/100)) - (sck->ck_valor * (nPercCOF/100)) - (sck->ck_valor * (nVlrICM / iif(nBasICM==0,1,nBasICM)) )) * ((100 - sck->ck_xdescG)/100)
			nVR := sck->ck_valor * ((100-sck->ck_xdescV)/100) * ((100 - sck->ck_xdescG)/100) * ((200 - (nPercPIS+nPercCOF+nPercICMS))/100)
		else
			//nVR := ( sck->ck_valor - (sck->ck_valor * (nPercPIS/100)) - (sck->ck_valor * (nPerccof/100)) - (sck->ck_valor * (nVlrICM / iif(nBasICM==0,1,nBasICM)) )) * ((100 - sck->ck_descont)/100)
			nVR := sck->ck_valor * ((100-sck->ck_xdescV)/100) * ((100 - sck->ck_xdescG)/100) * ((100 - (nPercPIS+nPercCOF+nPercICMS))/100)
		endif

		if cTpprod == "L"
			nM2L += (sck->ck_qtdven * nvlrM2)
			nVRL += nVR
		elseif cTpprod == "T"
			nM2T += (sck->ck_qtdven * nvlrM2)
			nVRT += nVR
		endif

		u_gtf001(sa1->a1_cod,sa1->a1_loja,sa1->a1_tipo,sck->ck_produto,scj->cj_condpag,sck->ck_tes,sck->ck_qtdven,sck->ck_prunit,sck->ck_qtdven*sck->ck_prunit,sck->ck_valdesc,@nBasICM,@nVlrICM,@nVlrPIS,@nVlrCOF,@nVlrIPI,@nVlrSol,@nVlrTot)

		nPercICMS 	:= iif(nVlrICM==0,0,nPercICMS)
		nPercIPI	:= iif(nVlrIPI==0,0,nPercIPI)
		nPercPIS    := iif(nVlrPIS==0,0,nPercPIS)
		nPercCOF    := iif(nVlrCOF==0,0,nPercCOF)

		if cOpcRel == "1" .and. scj->cj_xnivel == "2" .and. scj->cj_xtpfatu == "2"
			nVlrICM := 0
			nPercICMS := nPercIpi := nPercPIS := nPercCOF := 0
		endif

		oPrn:Say(nLin,0060,OemToAnsi(sck->ck_item)					, oFont10)
		oPrn:Say(nLin,0100,OemToAnsi(sck->ck_produto)				, oFont10)
		oPrn:Say(nLin,0310,OemToAnsi(substr(cDescri,1,40))			, oFont10)
		oPrn:Say(nLin,0740,OemToAnsi(substr(cAplic,1,20))			, oFont10)
		oPrn:Say(nLin,1060,Transform(sck->ck_qtdven	,"@E 9,999.99")	, oFont10)
		oPrn:Say(nLin,1160,Transform(nqtdF			,"@E 9,999.99")	, oFont10)
		oPrn:Say(nLin,1260,Transform(nqtdP			,"@E 9,999.99")	, oFont10)
		oPrn:Say(nLin,1400,Transform(iif(cOpcRel == "2" .or. scj->cj_xnivel != "2",(round(sck->ck_valor*nFator,2)+sck->ck_xvlripi+sck->ck_xicmsol)/sck->ck_qtdven,sck->ck_valor/sck->ck_qtdven),"@E 9,999,999.99"), oFont10)
		oPrn:Say(nLin,1570,Transform(iif(cOpcRel == "2" .or. scj->cj_xnivel == "2" .and. scj->cj_xtpfatu == "2",round(sck->ck_valor*nFator,2)+sck->ck_xvlripi+sck->ck_xicmsol,sck->ck_valor),"@E 9,999,999.99") , oFont10)
		if cOpcRel == "1"
			oPrn:Say(nLin,1750,Transform(nPercIpi		,"@E 999.99")		, oFont10)
			oPrn:Say(nLin,1940,Transform(nPercICMS		,"@E 999.99")		, oFont10)
			oPrn:Say(nLin,2170,Transform(nVlrICM		,"@E 9,999,999.99")	, oFont10)
		endif

		if len(cDescri) > 40
			nLin += 25
			oPrn:Say(nLin,0310,OemToAnsi(substr(cDescri,41,40))		, oFont10)
		endif

		if len(cAplic) > 20
			if len(cDescri) <= 40
				nLin += 25
			endif
			oPrn:Say(nLin,0740,OemToAnsi(substr(cAplic,21,20))		, oFont10)
		endif

		nLin += 50

		sck->(DbSkip())
	End

	nLin += 50

	oPrn:Box(nLin,0050,nLin+300,1500)
	oPrn:Box(nLin,1520,nLin+300,2300)

	nLin += 50

	oPrn:Say(nLin,0080,"Cond.Pag:  "+alltrim(SE4->E4_DESCRI)+"("+SCJ->CJ_CONDPAG+")" ,oFont10N)

	oPrn:Say(nLin,1600,"Frete"                                     ,oFont10N)
	oPrn:Say(nLin,2000,Transform(SCJ->CJ_FRETE,"@E 9,999,999.99")  ,oFont10)

	nLin += 50
	oPrn:Say(nLin,1600,"Sub-Total"           	            	   ,oFont10N)
	oPrn:Say(nLin,2000,Transform(nSubTot,"@E 9,999,999.99")        ,oFont10)

	/*
	nLin += 50
	oPrn:Say(nLin,1600,"Base do ICMS"         	            	   ,oFont10N)
	nPercIcm:=0
	IF SA1->A1_EST$("SP,RS") .AND. sf4->f4_icm == "S"
		oPrn:Say(nLin,2000+50,OemToAnsi("18 %"),oFont10 )
		nPercIcm:=(nTotOrc/100)*18
	ENDIF
	IF SA1->A1_EST$("MG,RJ") .AND. sf4->f4_icm =="S"
		oPrn:Say(nLin,2000+50,OemToAnsi("12 %"),oFont10 )
		nPercIcm:=(nTotOrc/100)*12
	ENDIF
	IF SA1->A1_EST$("AC,AL,AM,AP,BA,CE,DF,ES,GO,MA,MS,MT,PA,PB,PE,PI,PR,RN,RO,RR,SC,SE,TO") .AND. sf4->f4_icm == "S"
		oPrn:Say(nLin,2000+50,OemToAnsi("17 %"),oFont10 )
		nPercIcm:=(nTotOrc/100)*17
	ENDIF
	nLin += 50
	oPrn:Say(nLin,1600,"ICMS"            	                	,oFont10N)
	oPrn:Say(nLin,2000,Transform(nPercIcm,"@E 9,999,999.99"),oFont10)
	*/

	nLin += 50
	oPrn:Say(nLin,0080,"M2 L:"     	            	,oFont10N)
	oPrn:Say(nLin,0250,Transform(nM2L,"@E 9999,999.999"),oFont10)

	nVRL := nVRL/iif(nM2L==0,1,nM2L)
	oPrn:Say(nLin,0420,"VR:"     	            	,oFont10N)
	oPrn:Say(nLin,0570,Transform(nVRL,"@E 9,999,999.99"),oFont10)

	if cOpcRel == "2" .and. scj->cj_xnivel == "2"
		oPrn:Say(nLin,0740,"VD:"     	            	,oFont10N)
		oPrn:Say(nLin,0890,Transform(nVD,"@E 9,999,999.99"),oFont10)
	endif

	if cOpcRel == "1"
		oPrn:Say(nLin,1600,"IPI"               	            	,oFont10N)
		oPrn:Say(nLin,2000,Transform(nTotIPI,"@E 9,999,999.99"),oFont10)
	else
		oPrn:Say(nLin,1600,"Total Pedido"         	           	   ,oFont10N)
		oPrn:Say(nLin,2000,Transform(nTotOrc,"@E 9,999,999.99")    ,oFont10)
	endif

	nLin += 50
	oPrn:Say(nLin,0080,"M2 T:"     	            	,oFont10N)
	oPrn:Say(nLin,0250,Transform(nM2T,"@E 9999,999.999"),oFont10)

	nVRT := nVRT/iif(nM2T==0,1,nM2T)
	oPrn:Say(nLin,0420,"VR:"     	            	,oFont10N)
	oPrn:Say(nLin,0570,Transform(nVRT,"@E 9,999,999.99"),oFont10)

	if cOpcRel == "2" .and. scj->cj_xnivel == "2"
		nVB := nTotOrc - nVD
		oPrn:Say(nLin,0740,"VB:"     	            	,oFont10N)
		oPrn:Say(nLin,0890,Transform(nVB,"@E 9,999,999.99"),oFont10)
	endif

	if cOpcRel == "1"
		oPrn:Say(nLin,1600,"ICMS SOL"                    	,oFont10N)
		oPrn:Say(nLin,2000,Transform(nTotSol,"@E 9,999,999.99"),oFont10)
	endif

	nLin += 50
	oPrn:Say(nLin,0080,"Peso Liquido"      	            	,oFont10N)
	oPrn:Say(nLin,0320,Transform(nPesoTot,"@E 999,999.9999"),oFont10)

	if cOpcRel == "1"
		oPrn:Say(nLin,1600,"Total Pedido"         	           	   ,oFont10N)
		if scj->cj_xnivel == "2" .and. scj->cj_xtpfatu == "2"
			oPrn:Say(nLin,2000,Transform(0,"@E 9,999,999.99")    ,oFont10)
		else
			oPrn:Say(nLin,2000,Transform(nTotOrc,"@E 9,999,999.99")    ,oFont10)
		endif
	endif

	nLin += 100
	oPrn:Say(nLin,0080,"Preços Sujeitos a Reajuste sem Prévio Aviso",oFont10N)

	nLin += 100
	oPrn:Say(nLin,0450,"Consulte os novos produtos, temos lançamentos",oFont20N,,CLR_HBLUE)

	oPrn:Say(oprn:nVertRes()-300,0050,"Observação",oFont15,,)
	oPrn:Say(oprn:nVertRes()-250,0050,substr(scj->cj_zzobs,1,98),oFont15,,)
	oPrn:Say(oprn:nVertRes()-200,0050,ltrim(substr(scj->cj_zzobs,99,98)),oFont15,,)

	oPrn:EndPage()
	oPrn:Preview()

	FreeObj(oPrn)

Return
