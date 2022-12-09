#Include 'Protheus.ch'
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMT953TITบAutor  ณEugenio Arcanjo  บ Data ณ  30/04/2015   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ PE caso haja necessidade de se parametrizar a grava็ใo     บฑฑ
ฑฑบ          ณ dos titulos (SE2) na apura็ใo do ICMS .  				   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ RENOVA                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function MT953TIT()
Local lTitulo     := PARAMIXB[1]
Local cImposto    := PARAMIXB[2]
Local cImp        := PARAMIXB[3]
Local cLcPadTit   := PARAMIXB[4]
Local dDtIni      := PARAMIXB[5]
Local dDtFim      := PARAMIXB[6]
Local dDtVenc     := PARAMIXB[7]
Local nMoedTit    := PARAMIXB[8]
Local lGuiaRec    := PARAMIXB[9]
Local nMes        := PARAMIXB[10]
Local nAno        := PARAMIXB[11]
Local lContab     := PARAMIXB[12]
Local aGNREST     := PARAMIXB[13]
Local cMVSIGNRE   := PARAMIXB[14]
Local cProced     := PARAMIXB[15]
Local cOrgArrec   := PARAMIXB[16]
Local nValGuiaSF6 := PARAMIXB[17]
Local nVlrTitulo  := nValGuiaSF6    // Gileno - Ajuste para gerar o valor do tํtulo correto, conforme GNRE.
Local cNumero	  := ""
Local aTitulo	  := {}      
Local aGNRE       := {}
Local aRecTit     := {}                     
Local aTitCDH     := {}
Local lConfTit	  := .F.
Local lInfComp    := .F.
Local nRecTit     := 0
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณGrava o titulo do ICMS Normalณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
nRecTit := Len(aRecTit)
lConfTit:= .F.
GravaTit(lTitulo,nVlrTitulo,cImposto,cImp,cLcPadTit,dDtIni,dDtFim,dDtVenc,nMoedTit,lGuiaRec,nMes,nAno, nValGuiaSf6,0,"MATA953",lContab,@cNumero,@aGNRE,,,,,,,,@aRecTit,@lConfTit)

If nRecTit <> Len(aRecTit)	
	aRecTit[Len(aRecTit)][02] := "Apura็ใo do ICMS - ICMS Normal"		
	dbSelectArea("SE2")	
	MsGoto(aRecTit[Len(aRecTit)][01])	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ	
	//ณArray com os dados dos titulos gerados, para grava็ใo no CDH                                                  ณ	
	//ณdeve estar no seguinte formato: {E2_PREFIXO,E2_NUM,E2_PARCELA,E2_TIPO,E2_FORNECE,E2_LOJA,"IC" ou "ST","Descr"}ณ	
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู	
	//AADD(aTitCDH,{SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_TIPO,SE2->E2_FORNECE,SE2->E2_LOJA,"IC","Apura็ใo do ICMS - ICMS Normal"})
	SE2->E2_XPERAP := dDtVenc 
	SE2->E2_E_APUR := ddatabase     
	        
	// Gileno - Ajuste para salvar o tํtulo liberado, inclusใo posterior a 16/10/2019
	If SE2->E2_EMISSAO > CtoD("16/10/2019")
		SE2->E2_APROVA  := "000001"  
    	SE2->E2_DATALIB :=  DATE()
    	SE2->E2_STATLIB := "03" 
    	SE2->E2_USUALIB := "INC POSTERIOR REC JUDIC  "
    	SE2->E2_CODAPRO := "000000" 
       	SE2->E2_XRJ     := "N"    
    EndIf

	IF SM0->M0_ESTENT == 'SP'
		SE2->E2_CODREC :=  '0462'
	ELSEIF SM0->M0_ESTENT == 'BA'	
		SE2->E2_CODREC :=  '0759'
	ELSE
		SE2->E2_CODREC :=  ''
	ENDIF				 	
	SE2->E2_XCNPJC := SM0->M0_CGC
//	SE2->E2_XCONTR" ,	_cNome				        , NIL } )

	AADD(aTitCDH,{SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_TIPO,SE2->E2_FORNECE,SE2->E2_LOJA,"IC","Apura็ใo do ICMS - ICMS Normal"})
Endif
If lTitulo .And. nVlrTitulo>0 .And. lConfTit	
	AADD(aTitulo,{"TIT",cNumero+" "+Dtoc(dDtVenc)+" "+cOrgArrec,nVlrTitulo})
Endif
Return( {cNumero,aGNRE,aGNREST,aTitulo,lInfComp,cNumero,aTitCDH }) 
