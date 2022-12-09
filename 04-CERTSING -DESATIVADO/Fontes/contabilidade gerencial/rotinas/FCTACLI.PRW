#include "PROTHEUS.CH"

User Function fCtaCli(cLpOri)
Local cC6_XOPER := ''
Local cConta:=''

//Trata conta de clientes no faturamento


IF cLpOri=='610' .OR. cLpOri=='620' .or. cLpOri=='630' //Faturamento e Cancelamento de vendas
	
	SD2->( DbSetOrder(3) )		// D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
	SD2->( !MsSeek( xFilial("SD2")+SF2->(F2_DOC+F2_SERIE) ) )
	SC5->( DbSetOrder(1) )		// C5_FILIAL+C5_NUM
	SC5->( MsSeek( xFilial("SC5")+SD2->D2_PEDIDO ) )
	
	cC6_XOPER := SC6->(GetAdvFval("SC6","C6_XOPER",(xFilial("SC6")+SD2->D2_PEDIDO+SD2->D2_ITEMPV),1,""))

	IF cC6_XOPER $ "61/62/01"
		cConta:="210201003"
	Elseif SC5->C5_XORIGPV=="5" .AND. SC5->C5_VEND1 == "CC0001" .AND. SC5->C5_CONDPAG == '000' //VALIDAÇÃO PRESENCIAL.
		cConta := "210201004"
	ElseIf SC5->C5_TIPMOV == "2" .OR. SC5->C5_TIPMOV2 == "2" //.AND. !Empty(AllTrim(SC5->C5_XBANDEI))
		cConta := "110302005" //adm Financeiras nao abre por adm. 
	ElseIf SF2->F2_VEND1<>'VA0001' .AND. SC5->C5_VEND1 <> "CC0001"//corporativo
	 	cConta:='110301004'
	Else  //Cliente Varejo e Validação Presencial
	   cConta:='110301001'
    	Endif    

Endif
                                       
IF cLpOri=='520' .OR. cLpOri=='521' .OR. cLpOri=='527' //Baixa e cancelamento de baixas de títulos a Receber
	SC5->( DbSetOrder(1) )		// C5_FILIAL+C5_NUM
	IF SC5->( MsSeek( xFilial("SC5")+SE1->E1_PEDIDO ) )
		IF SE1->E1_PREFIXO=='RCP' .AND. DTOS(SC5->C5_EMISSAO)>='20150101' .AND. SE5->E5_MOTBX=='CHA' //Tratamento para ChargeBack
		        cConta:="210201003" //Obrigações
		ElseiF SC5->C5_TIPMOV == "2" .OR. SC5->C5_TIPMOV2 == "2" 
			cConta := '110302005' //adm Financeiras nao abre por adm. 
		elseIF ( SC5->C5_VEND1<>'VA0001' .AND. SC5->C5_VEND1<>'CC0001' )
	 		cConta:='110301004'  //corporativo
		ELSE
		   cConta:='110301001' //Cliente Varejo E Validação Presencial
		Endif
	ELSEIF SE1->E1_VEND1<>'VA0001' //Diferente de varejo
	 	If SE1->E1_VEND1=='CC0001' //Validação presencial.
	 		cConta:='110301001'
	 	Else
	 		cConta:='110301004'
	 	Endif
    ELSE
	  	cConta:='110301001'
	ENDIF 
Endif
    
IF cLpOri=='500' .or.  cLpOri=='505' //inclusão e exclusão de títulos. 
	IF SE1->E1_TIPO=='PR '  //Autorizações da operadadora de cartão de crédito 
		cConta:='110302005' //Cartão e cédito
	ElseIf SE1->E1_PREFIXO == 'COR'
		cConta :='110301004' //Cliente corporativo
	Else
	 	cConta:='110301001' //Cliente 
	 Endif    
Endif

IF cLpOri=='594'        //COMPENSAÇÃO ENTRE CARTEIRAS   
		IF SE1->E1_VEND1<>'VA0001' //Diferente de varejo 
			 	If SE1->E1_VEND1=='CC0001' //Validação presencial
					cConta:='110301001'
				Else
					cConta:='110301004'
				Endif
		ELSE
			cConta:='110301001'
		Endif
Endif

IF cLpOri=='640' //DEVOLUÇÕES DE VENDA

	SF2->( DbSetOrder(1) )		// D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
	SF2->( !MsSeek( xFilial("SF2")+SD1->(D1_NFORI+D1_SERIORI) ) )
	If SF2->F2_VEND1<>'VA0001' //Diferente de varejo
			If SF2->F2_VEND1 == 'CC0001' //Validacão presencial
				cConta:='110301001'
			Else
				cConta:='110301004'
			Endif
	else  //Utiliza conta que está cadastrado no cliente
	   cConta:='110301001'
	 Endif    
Endif


Return cConta

