#Include 'Protheus.ch'
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT953TIT�Autor  �Eugenio Arcanjo  � Data �  30/04/2015   ���
�������������������������������������������������������������������������͹��
���Desc.     � PE caso haja necessidade de se parametrizar a grava��o     ���
���          � dos titulos (SE2) na apura��o do ICMS .  				   ���
�������������������������������������������������������������������������͹��
���Uso       � RENOVA                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
Local nVlrTitulo  := nValGuiaSF6    // Gileno - Ajuste para gerar o valor do t�tulo correto, conforme GNRE.
Local cNumero	  := ""
Local aTitulo	  := {}      
Local aGNRE       := {}
Local aRecTit     := {}                     
Local aTitCDH     := {}
Local lConfTit	  := .F.
Local lInfComp    := .F.
Local nRecTit     := 0
//�����������������������������Ŀ
//�Grava o titulo do ICMS Normal�
//�������������������������������
nRecTit := Len(aRecTit)
lConfTit:= .F.
GravaTit(lTitulo,nVlrTitulo,cImposto,cImp,cLcPadTit,dDtIni,dDtFim,dDtVenc,nMoedTit,lGuiaRec,nMes,nAno, nValGuiaSf6,0,"MATA953",lContab,@cNumero,@aGNRE,,,,,,,,@aRecTit,@lConfTit)

If nRecTit <> Len(aRecTit)	
	aRecTit[Len(aRecTit)][02] := "Apura��o do ICMS - ICMS Normal"		
	dbSelectArea("SE2")	
	MsGoto(aRecTit[Len(aRecTit)][01])	
	//��������������������������������������������������������������������������������������������������������������Ŀ	
	//�Array com os dados dos titulos gerados, para grava��o no CDH                                                  �	
	//�deve estar no seguinte formato: {E2_PREFIXO,E2_NUM,E2_PARCELA,E2_TIPO,E2_FORNECE,E2_LOJA,"IC" ou "ST","Descr"}�	
	//����������������������������������������������������������������������������������������������������������������	
	//AADD(aTitCDH,{SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_TIPO,SE2->E2_FORNECE,SE2->E2_LOJA,"IC","Apura��o do ICMS - ICMS Normal"})
	SE2->E2_XPERAP := dDtVenc 
	SE2->E2_E_APUR := ddatabase     
	        
	// Gileno - Ajuste para salvar o t�tulo liberado, inclus�o posterior a 16/10/2019
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

	AADD(aTitCDH,{SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_TIPO,SE2->E2_FORNECE,SE2->E2_LOJA,"IC","Apura��o do ICMS - ICMS Normal"})
Endif
If lTitulo .And. nVlrTitulo>0 .And. lConfTit	
	AADD(aTitulo,{"TIT",cNumero+" "+Dtoc(dDtVenc)+" "+cOrgArrec,nVlrTitulo})
Endif
Return( {cNumero,aGNRE,aGNREST,aTitulo,lInfComp,cNumero,aTitCDH }) 
