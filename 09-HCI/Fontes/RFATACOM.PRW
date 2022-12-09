
#INCLUDE "Protheus.ch" 
#INCLUDE "Rwmake.CH"
#INCLUDE "TopConn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออออออัออออออออออัออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออปฑฑ
ฑฑบ Programa    ณRFATACOM  ณ RECALCULO DE COMISSOES GERADAS PELO SISTEMA DE FATURAMENTO   บฑฑ
ฑฑบ             ณ          ณ                                                              บฑฑ
ฑฑฬอออออออออออออุออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Solicitante ณ 20.04.07 ณ Robson                                                       บฑฑ
ฑฑฬอออออออออออออุออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Autor       ณ 20.04.07 ณ Robson Bueno                                                 บฑฑ
ฑฑฬอออออออออออออุออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Produ็ใo    ณ ??.??.?? ณ Ignorado                                                     บฑฑ
ฑฑฬอออออออออออออุออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Parโmetros  ณ Nil                                                                     บฑฑ
ฑฑฬอออออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Retorno     ณ Nil                                                                     บฑฑ
ฑฑฬอออออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Observa็๕es ณ                                                                         บฑฑ
ฑฑบ             ณ                                                                         บฑฑ
ฑฑบ             ณ                                                                         บฑฑ
ฑฑบ             ณ                                                                         บฑฑ
ฑฑบ             ณ                                                                         บฑฑ
ฑฑฬอออออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Altera็๕es  ณ ??.??.?? - Nome - Descri็ใo                                             บฑฑ
ฑฑศอออออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RFATACOM()


Local aAreaAtu	:= GetArea()												// Salva a area atual
Local lRet		:= .T.
LOCAL cDesComp :=Space(255)
LOCAL dInicio  :=ctod("  /  /  ")
LOCAL dFim     :=ctod("  /  /  ")
Local oDlgL
Local cTitulo :="Reprocessamento de Comissoes"
@ 000,000 To 180,400 Dialog Odlg1 Title OemToAnsi("Rotina P/ Recalculo de Comissoes")
@ 003,008 To 85,200 Title OemToAnsi("Digite o Periodo de Recalculo?")

@ 015,015 Say OemToAnsi("Inicio:") OF Odlgl PIXEL
@ 015,045 msget dInicio  SIZE 60,10 OF OdlgL PIXEL
@ 035,015 Say OemToAnsi("Fim:") OF Odlgl PIXEL
@ 035,045 msget dFim  SIZE 60,10 OF OdlgL PIXEL
@ 055,030 BMPBUTTON TYPE 1 ACTION 	Processa({|| OkProc(odlg1,dInicio,dFim)},cTitulo,"Atualizando dados, aguarde...")
@ 055,060 BMPBUTTON TYPE 2 ACTION Finaliza(odlg1)

Activate Dialog Odlg1 CENTER
 
   
Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณOkProc    บAutor  ณRobson Bueno        บ Data ณ 18/04/2007  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณProcessamento no banco de dados da acao solicitada e confir บฑฑ
ฑฑบ          ณmada                                                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณHCI                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function OkProc(odlg1,dInicio,dFim)
Local aArea     := GetArea()
Local nRegistros := 0
Local cQry
lOCAL cQry2admin	
LOCAL nValbruto:=0
Local nValIcm:=0
Local nValIpi:=0
Local nValPis:=0
Local nValCof:=0
Local nValCom:=0
Local nBaseCom:=0
Local nBaseItem:=0
lOCAL nPercom:=0
lOCAL cPedido
Local cVendedor
Local cPrefixo:=""
If MsgYesNo("Esta rotina reprocessa todas as comissoes geradas automaticamente pelo sistema de faturamento. A acao implicara na exclusao das comissoes atuais. Deseja realmente processar esta rotina?")
   	    //deletando dados atuais das comissoes no periodo estipulado
   	    dbSelectArea("SE3")
		dbSetOrder(6)
	    IF MsSeek(xFilial("SE3")+DTOS(dinicio))
	      ProcRegua(RecCount())
	      While !Eof() .And. xFilial("SE3") == SE3->E3_FILIAL .And.  SE3->E3_EMISSAO<=dFim
			IF SUBSTR(SE3->E3_VEND,1,1)="C" .OR. (SE3->E3_PREFIXO<>"1  " .AND. SE3->E3_PREFIXO<>"011" .AND. SE3->E3_PREFIXO<>"511" .AND. SE3->E3_PREFIXO<>"501" .AND. SE3->E3_PREFIXO<>"503" .AND. SE3->E3_PREFIXO<>"01 " .AND. SE3->E3_PREFIXO<>"02 " .AND. SE3->E3_PREFIXO<>"021" .AND. SE3->E3_PREFIXO<>"031" .AND. SE3->E3_PREFIXO<>"041" )
			ELSE
			  cPrefixo:=SE3->E3_PREFIXO
			  IncProc("EXCLUINDO NF "+ SE3->E3_NUM + " SERIE " +SE3->E3_SERIE + "REPR" + SE3->E3_VEND)
			  RecLock("SE3")
			  dbDelete()
			  dbSelectArea("SE3")
			  ENDIF
			dbSkip()
	      EndDo
  	    	// pesquisando notas dentro do periodo de apuracao com inner join em clientes trazendo vendedores 
  	      cQry	:= " SELECT SF2.F2_DOC,SF2.F2_SERIE,SF2.F2_EMISSAO,SF2.F2_CLIENTE,SF2.F2_LOJA,SF2.F2_VALBRUT,SF2.F2_DUPL,SF2.F2_PREFIXO,SF2.F2_ESPECIE,SF2.F2_VEND1,SF2.F2_VEND5,"
		  cQry	+= " (SELECT SA1.A1_VEND FROM "+RetSqlName("SA1")+" SA1"
		  cQry	+= "		WHERE SA1.A1_FILIAL = '"+xFilial("SA1")+"' "
		  cQry	+= "		AND SA1.A1_COD = SF2.F2_CLIENTE"
		  cQry	+= "		AND SA1.A1_LOJA = SF2.F2_LOJA"
		  cQry	+= "		AND SA1.D_E_L_E_T_ <> '*')" 
		  cQry	+= " FROM "+RetSqlName("SF2")+" SF2"
		  cQry	+= " WHERE SF2.F2_FILIAL = '"+xFilial("SF2")+"'"
		  cQry	+= " AND SF2.F2_TIPO NOT IN('B','D')" 
		  cQry	+= " AND SF2.F2_EMISSAO >= '"+dtos(dInicio)+"'"	
		  cQry	+= " AND SF2.F2_EMISSAO <= '"+DTOS(dFim)+"'"
	   	  cQry	+= " AND SF2.F2_DUPL <> '      '"
		  cQry	+= " AND SF2.D_E_L_E_T_ <> '*'"
		  If Select("TMPSF2") > 0
			dbSelectArea("TMPSF2")
			dbCloseArea()
		  EndIf
		  TCQUERY cQry NEW ALIAS "TMPSF2"
		  dbSelectArea("TMPSF2")
		  dbGoTop()
		  ProcRegua(RecCount())
		  While !Eof()
     	    nPercom:=0
     	    dbSelectArea("SA1")
		    dbSetOrder(1)
	        If MsSeek(xFilial("SA1")+TMPSF2->F2_CLIENTE+TMPSF2->F2_LOJA)
		       npercom:=SA1->A1_COMIS
		    ENDIF
     	    dbSelectArea("SA3")
		    dbSetOrder(1)
	        If MsSeek(xFilial("SA3")+TMPSF2->A1_VEND)
		       npercom:=SA3->A3_COMIS
     	    ENDIF
     	    
     	    IncProc("NOTA "+TMPSF2->F2_DOC+ " V_NF- " +TMPSF2->F2_VEND1+ " V_CL- "+TMPSF2->A1_VEND)
     	 	cQry2	:= " SELECT SD2.D2_DOC,SD2.D2_SERIE,SD2.D2_ITEM,SD2.D2_COD,SD2.D2_QUANT,SD2.D2_TES,SD2.D2_VALBRUT,SD2.D2_TOTAL,SD2.D2_VALIPI,SD2.D2_VALICM,SD2.D2_VALIMP5,SD2.D2_VALIMP6,SD2.D2_PEDIDO,SD2.D2_COMIS1,"
			cQry2	+= "(SELECT SB1.B1_COMIS FROM "+RetSqlName("SB1")+" SB1"
			cQry2   += "		WHERE SB1.B1_FILIAL = '"+xFilial("SB1")+"' "
			cQry2	+= "		AND SB1.B1_COD = SD2.D2_COD"
			cQry2	+= "		AND SB1.D_E_L_E_T_ <> '*')"
			cQry2	+= " FROM "+RetSqlName("SD2")+" SD2"
			cQry2	+= " WHERE SD2.D2_FILIAL = '"+xFilial("SD2")+"'"
			cQry2	+= " AND SD2.D2_DOC = '"+TMPSF2->F2_DOC+"'"	
			cQry2	+= " AND SD2.D2_SERIE = '"+TMPSF2->F2_SERIE+"'"
			cQry2	+= " AND SD2.D_E_L_E_T_ <> '*' ORDER BY SD2.D2_ITEM"
            If Select("TMPSD2") > 0
			  dbSelectArea("TMPSD2")
			  dbCloseArea()
		    EndIf
            TCQUERY cQry2 NEW ALIAS "TMPSD2"
		    dbSelectArea("TMPSD2")
		    dbGoTop()
            ProcRegua(RecCount())
	        nValbruto:=0 
	        nValIcm:=0
	        nValIpi:=0
	        nValPis:=0
	        nValCof:=0
	        nValCom:=0
	        nBaseCom:=0
	     	cPedido:=TMPSD2->D2_PEDIDO 
	     	cVendedor:=TMPSF2->A1_VEND
	     	dbSelectArea("SC5")
	     	dbsetORDER(1)
	     	If MsSeek(xFilial("SC5")+cPedido)
	     	  if SC5->C5_CONTATO<>'               ' 
	     	    cVendedor:=SC5->C5_VEND1
	     	  ENDIF 
	     	  dbSelectArea("SA3")
		   	  dbSetOrder(1)
	          If MsSeek(xFilial("SA3")+cVendedor)
		        npercom:=SA3->A3_COMIS
     	      ENDIF 
	     	ENDIF
	     	dbSelectArea("TMPSD2")
	     	While !Eof()
     	       IncProc("NOTA "+TMPSF2->F2_DOC+ " ITEM" +TMPSD2->D2_ITEM+ ".")
     	       // recalculo da comissao com base na regra de negocio
     	       // VERIFICA SE TEM DUPLICATA NO ITEM DA NF
     	       dbSelectArea("SC5")
	       	   dbsetORDER(1)
	     	   If MsSeek(xFilial("SC5")+cPedido)
	     		  if SC5->C5_CONTATO<>'               ' 
	     	 	   cVendedor:=SC5->C5_VEND1
	     	 	 ENDIF 
	     	     dbSelectArea("SA3")
		   	     dbSetOrder(1)
	             If MsSeek(xFilial("SA3")+cVendedor)
		           npercom:=SA3->A3_COMIS
     	         ENDIF 
	     	   ENDIF
	     	   dbSelectArea("TMPSD2")
     	       IF Posicione("SF4",1,xFilial("SF4")+TMPSD2->D2_TES,"F4_DUPLIC")="S"
     	         nValbruto+=TMPSD2->D2_VALBRUT 
	             nValIcm  +=TMPSD2->D2_VALICM 
	             nValIpi  +=TMPSD2->D2_VALIPI 
	             nValPis  +=TMPSD2->D2_VALIMP5 
	             nValCof  +=TMPSD2->D2_VALIMP6 
	             nBaseCom +=TMPSD2->D2_TOTAL-TMPSD2->D2_VALICM-TMPSD2->D2_VALIMP5-TMPSD2->D2_VALIMP6 
	             nBaseItem:=TMPSD2->D2_TOTAL-TMPSD2->D2_VALICM-TMPSD2->D2_VALIMP5-TMPSD2->D2_VALIMP6
	             If nPerCom=0
	               nPercom:=TMPSD2->B1_COMIS
	             ENDIF
	             nValCom  +=nBaseItem*(nPercom/100)
     	       ELSE
     	       ENDIF
	           // GRAVANDO % COMISSAO ATUAL NA SD2
	           dbSelectArea("SD2")
	           dbSetOrder(10)
	           If MsSeek(xFilial("SD2")+TMPSD2->D2_DOC+TMPSD2->D2_SERIE+TMPSD2->D2_ITEM)
	             RecLock("SD2",.F.)
	             SD2->D2_COMIS1=nPerCom
	             MsUnLock() 	      
	           ENDIF
	           dbSelectArea("TMPSD2")
	           dbSkip()
            EndDo
     	    // GRAVACAO DA NF NO >>>>SE3<<<<< 
     	    dbSelectArea("SE3")
	        dbSetOrder(1)
		    If MsSeek(xFilial("SE3")+cPrefixo+TMPSF2->F2_DOC+"   "+TMPSF2->A1_VEND)
     	    ELSE
     	      IncProc("GRAVANDO COMISSAO REF: NF "+TMPSF2->F2_DOC)
     	      RecLock("SE3",.T.)
     	      SE3->E3_FILIAL :=xFilial("SE3")
     	      SE3->E3_VEND   :=cVendedor
     	      SE3->E3_NUM    :=TMPSF2->F2_DOC
     	      SE3->E3_EMISSAO:=CTOD(SUBSTR(TMPSF2->F2_EMISSAO,7,2)+"/"+SUBSTR(TMPSF2->F2_EMISSAO,5,2)+"/"+SUBSTR(TMPSF2->F2_EMISSAO,1,4))
     	      SE3->E3_SERIE  :=TMPSF2->F2_SERIE
     	      SE3->E3_CODCLI :=TMPSF2->F2_CLIENTE
              SE3->E3_LOJA   :=TMPSF2->F2_LOJA 
              IF nBaseCom<=0
                SE3->E3_BASE   :=nBaseCom
                SE3->E3_COMIS  :=0.01
                SE3->E3_PORC   :=0.01
                SE3->E3_HIST   :="Base da Comissao abaixo do Minimo"
              else
                SE3->E3_BASE   :=nBaseCom
                SE3->E3_COMIS  :=nValcom
                SE3->E3_PORC   :=(nValcom/nBaseCom)*100 
              endif  
              SE3->E3_PREFIXO:=TMPSF2->F2_PREFIXO
              SE3->E3_TIPO   :=TMPSF2->F2_ESPECIE
              SE3->E3_BAIEMI :="E"
              SE3->E3_PEDIDO :=cPedido
              SE3->E3_ORIGEM :="F"
              SE3->E3_VENCTO :=CTOD("05/"+SUBSTR(TMPSF2->F2_EMISSAO,5,2)+"/"+SUBSTR(TMPSF2->F2_EMISSAO,1,4))+30
              MsUnLock() 	      
     	    ENDIF
     	    dbSelectArea("TMPSF2")
     	    dbSkip()
          EndDo
        ELSE
          Msginfo("Nao foi encontrada a Data Inicial Informada", "Inconsistencia")
        ENDIF
Endif
If MsgYesNo("Deseja Processar Tambem as devolucoes de compras?")
 //deletando dados atuais das comissoes no periodo estipulado
   	    dbSelectArea("SE3")
		dbSetOrder(6)
		If MsSeek(xFilial("SE3")+DTOS(dinicio))
		  ProcRegua(RecCount())
		  While !Eof() .And. xFilial("SE3") == SE3->E3_FILIAL .And. dFim >= SE3->E3_EMISSAO
			IF SUBSTR(SE3->E3_VEND,1,1)="C" .OR. SE3->E3_PREFIXO<>"DEV"
			ELSE
			  IncProc("EXCLUINDO NF "+ SE3->E3_NUM + " SERIE " +SE3->E3_SERIE + "REPR" + SE3->E3_VEND)
			  RecLock("SE3")
			  dbDelete()
			  dbSelectArea("SE3")
			  ENDIF
			dbSkip()
		  EndDo
		EndIf
   	       		
   		// pesquisando notas dentro do periodo de apuracao com inner join em clientes trazendo vendedores 
  		cQry	:= " SELECT SF1.F1_DOC,SF1.F1_SERIE,SF1.F1_EMISSAO,SF1.F1_DTDIGIT,SF1.F1_FORNECE,SF1.F1_LOJA,SF1.F1_VALBRUT,SF1.F1_DUPL,SF1.F1_PREFIXO,SF1.F1_ESPECIE,"
		cQry	+= " (SELECT SA1.A1_VEND FROM "+RetSqlName("SA1")+" SA1"
		cQry	+= "		WHERE SA1.A1_FILIAL = '"+xFilial("SA1")+"' "
		cQry	+= "		AND SA1.A1_COD = SF1.F1_FORNECE"
		cQry	+= "		AND SA1.A1_LOJA = SF1.F1_LOJA"
		cQry	+= "		AND SA1.D_E_L_E_T_ <> '*')" 
		cQry	+= " FROM "+RetSqlName("SF1")+" SF1"
		cQry	+= " WHERE SF1.F1_FILIAL = '"+xFilial("SF1")+"'"
		cQry	+= " AND SF1.F1_TIPO='D'" 
		cQry	+= " AND SF1.F1_DTDIGIT >= '"+dtos(dInicio)+"'"	
		cQry	+= " AND SF1.F1_DTDIGIT <= '"+DTOS(dFim)+"'"
		cQry	+= " AND SF1.D_E_L_E_T_ <> '*'"
		If Select("TMPSF1") > 0
			dbSelectArea("TMPSF1")
			dbCloseArea()
		EndIf
		TCQUERY cQry NEW ALIAS "TMPSF1"
		dbSelectArea("TMPSF1")
		dbGoTop()
		ProcRegua(RecCount())
		While !Eof()
     	    nPercom:=0
     	    dbSelectArea("SA1")
		    dbSetOrder(1)
	        If MsSeek(xFilial("SA1")+TMPSF1->F1_FORNECE+TMPSF1->F1_LOJA)
		       npercom:=SA1->A1_COMIS
     	    ENDIF
     	    dbSelectArea("SA3")
		    dbSetOrder(1)
	        If MsSeek(xFilial("SA3")+TMPSF1->A1_VEND)
		       npercom:=SA3->A3_COMIS
     	    ENDIF
     	    IncProc("NOTA "+TMPSF1->F1_DOC+ " V_NF- " +TMPSF1->A1_VEND)
     	 	cQry2	:= " SELECT SD1.D1_DOC,SD1.D1_SERIE,SD1.D1_ITEM,SD1.D1_COD,SD1.D1_QUANT,SD1.D1_TOTAL,SD1.D1_VALIPI,SD1.D1_VALICM,SD1.D1_VALIMP5,SD1.D1_VALIMP6,SD1.D1_NFORI,"
			cQry2	+= "(SELECT SB1.B1_COMIS FROM "+RetSqlName("SB1")+" SB1"
			cQry2   += "		WHERE SB1.B1_FILIAL = '"+xFilial("SB1")+"'"
			cQry2	+= "		AND SB1.B1_COD = SD1.D1_COD"
			cQry2	+= "		AND SB1.D_E_L_E_T_ <> '*')"
			cQry2	+= " FROM "+RetSqlName("SD1")+" SD1"
			cQry2	+= " WHERE SD1.D1_FILIAL = '"+xFilial("SD1")+"'"
			cQry2	+= " AND SD1.D1_DOC = '"+TMPSF1->F1_DOC+"'"	
			cQry2	+= " AND SD1.D1_SERIE = '"+TMPSF1->F1_SERIE+"'"
            cQry2	+= " AND SD1.D1_FORNECE = '"+TMPSF1->F1_FORNECE+"'"			
            cQry2	+= " AND SD1.D1_LOJA = '"+TMPSF1->F1_LOJA+"'"	
			cQry2	+= " AND SD1.D_E_L_E_T_ <> '*' ORDER BY SD1.D1_ITEM"
            If Select("TMPSD1") > 0
			  dbSelectArea("TMPSD1")
			  dbCloseArea()
		    EndIf
            TCQUERY cQry2 NEW ALIAS "TMPSD1"
		    dbSelectArea("TMPSD1")
		    dbGoTop()
            ProcRegua(RecCount())
	        nValbruto:=0 
	        nValIcm:=0
	        nValIpi:=0
	        nValPis:=0
	        nValCof:=0
	        nValCom:=0
	        nBaseCom:=0
	     	cPedido:=TMPSD1->D1_NFORI
	     	While !Eof()
     	       IncProc("NOTA "+TMPSF1->F1_DOC+ " ITEM" +TMPSD1->D1_ITEM+ ".")
     	       // recalculo da comissao com base na regra de negocio
     	       nValbruto+=TMPSD1->D1_TOTAL
	           nValIcm  +=TMPSD1->D1_VALICM 
	           nValIpi  +=TMPSD1->D1_VALIPI 
	           nValPis  +=TMPSD1->D1_VALIMP5 
	           nValCof  +=TMPSD1->D1_VALIMP6 
	           nBaseCom +=TMPSD1->D1_TOTAL-TMPSD1->D1_VALICM-TMPSD1->D1_VALIPI-TMPSD1->D1_VALIMP5-TMPSD1->D1_VALIMP6 
	           nBaseItem:=TMPSD1->D1_TOTAL-TMPSD1->D1_VALICM-TMPSD1->D1_VALIPI-TMPSD1->D1_VALIMP5-TMPSD1->D1_VALIMP6
	           If nPerCom=0
	             nPercom:=TMPSD1->B1_COMIS
	           ENDIF
	           if nPercom:=0 
	             npercom:=3.00 
	           endif
	           nValCom  +=nBaseItem*(nPercom/100)
	           dbSkip()
            EndDo
     	    // GRAVACAO DA NF NO >>>>SE3<<<<< 
     	    dbSelectArea("SE3")
	        dbSetOrder(1)
		    If MsSeek(xFilial("SE3")+"DEV"+TMPSF1->F1_DOC+"   "+TMPSF1->A1_VEND)
     	    ELSE
     	      
     	        IncProc("GRAVANDO COMISSAO REF: NF "+TMPSF1->F1_DOC)
     	     
     	      RecLock("SE3",.T.)
     	      SE3->E3_FILIAL :=xFilial("SE3")
     	      SE3->E3_VEND   :=TMPSF1->A1_VEND
     	      SE3->E3_NUM    :=TMPSF1->F1_DOC
     	      SE3->E3_EMISSAO:=CTOD(SUBSTR(TMPSF1->F1_DTDIGIT,7,2)+"/"+SUBSTR(TMPSF1->F1_DTDIGIT,5,2)+"/"+SUBSTR(TMPSF1->F1_DTDIGIT,1,4))
     	      SE3->E3_SERIE  :=TMPSF1->F1_SERIE
     	      SE3->E3_CODCLI :=TMPSF1->F1_FORNECE
              SE3->E3_LOJA   :=TMPSF1->F1_LOJA 
              SE3->E3_PORC   :=(nValcom/nBaseCom)*100 
              SE3->E3_BASE   :=nBaseCom*-1
              SE3->E3_COMIS  :=nValcom*-1                             
              SE3->E3_PREFIXO:="DEV"
              SE3->E3_TIPO   :=TMPSF1->F1_ESPECIE
              SE3->E3_BAIEMI :="E"
              SE3->E3_PEDIDO :=cPedido
              SE3->E3_ORIGEM :="F"
              SE3->E3_VENCTO :=CTOD("05/"+SUBSTR(TMPSF1->F1_DTDIGIT,5,2)+"/"+SUBSTR(TMPSF1->F1_DTDIGIT,1,4))+30
              MsUnLock() 	      
     	    ENDIF
     	    dbSelectArea("TMPSF1")
     	    dbSkip()
        EndDo


endif
If MsgYesNo("Esta rotina reprocessa todas as comissoes geradas a compradores. A acao implicara na exclusao das comissoes atuais. Deseja realmente processar esta rotina?")
   	    //deletando dados atuais das comissoes no periodo estipulado
   	    dbSelectArea("SE3")
		dbSetOrder(4)
		If MsSeek(xFilial("SE3")+DTOS(dinicio))
		  ProcRegua(RecCount())
		  While !Eof() .And. xFilial("SE3") == SE3->E3_FILIAL .And.  SE3->E3_EMISSAO<=dFim
			IF SE3->E3_PREFIXO<>"011"
			ELSE
			  if SUBSTR(SE3->E3_VEND,1,1)="C"
			    IncProc("EXCLUINDO NF "+ SE3->E3_NUM + " SERIE " +SE3->E3_SERIE + "REPR" + SE3->E3_VEND)
			    RecLock("SE3")
			    dbDelete()
			    dbSelectArea("SE3")
			  endif
			ENDIF
			dbSkip()
		  EndDo
		EndIf
   	    
   	    
   	    // falta acertar a parte de recalculo de compradores
   	    
   	    
   	    
   	    
   	    
   	    
   	       		
   		// pesquisando notas dentro do periodo de apuracao com inner join em clientes trazendo vendedores 
  		cQry	:= " SELECT SF2.F2_DOC,SF2.F2_SERIE,SF2.F2_EMISSAO,SF2.F2_CLIENTE,SF2.F2_LOJA,SF2.F2_VALBRUT,SF2.F2_DUPL,SF2.F2_PREFIXO,SF2.F2_ESPECIE,SF2.F2_VEND1,SF2.F2_VEND5,"
		cQry	+= " (SELECT SA1.A1_VEND FROM "+RetSqlName("SA1")+" SA1"
		cQry	+= "		WHERE SA1.A1_FILIAL = '"+xFilial("SA1")+"' "
		cQry	+= "		AND SA1.A1_COD = SF2.F2_CLIENTE"
		cQry	+= "		AND SA1.A1_LOJA = SF2.F2_LOJA"
		cQry	+= "		AND SA1.D_E_L_E_T_ <> '*')" 
		cQry	+= " FROM "+RetSqlName("SF2")+" SF2"
		cQry	+= " WHERE SF2.F2_FILIAL = '"+xFilial("SF2")+"'"
		cQry	+= " AND SF2.F2_TIPO NOT IN('B','D')" 
		cQry	+= " AND SF2.F2_EMISSAO >= '"+dtos(dInicio)+"'"	
		cQry	+= " AND SF2.F2_EMISSAO <= '"+DTOS(dFim)+"'"
	   	cQry	+= " AND SF2.F2_DUPL <> '      '"
		cQry	+= " AND SF2.D_E_L_E_T_ <> '*'"
		If Select("TMPSF2") > 0
			dbSelectArea("TMPSF2")
			dbCloseArea()
		EndIf
		TCQUERY cQry NEW ALIAS "TMPSF2"
		dbSelectArea("TMPSF2")
		dbGoTop()
		ProcRegua(RecCount())
		While !Eof()
     	    nPercom:=0
     	    dbSelectArea("SA1")
		    dbSetOrder(1)
	        If MsSeek(xFilial("SA1")+TMPSF2->F2_CLIENTE+TMPSF2->F2_LOJA)
		       npercom:=SA1->A1_COMIS
     	    ENDIF
     	    dbSelectArea("SA3")
		    dbSetOrder(1)
	        If MsSeek(xFilial("SA3")+TMPSF2->A1_VEND)
		       npercom:=SA3->A3_COMIS
     	    ENDIF
     	    
     	    IncProc("NOTA "+TMPSF2->F2_DOC+ " V_NF- " +TMPSF2->F2_VEND1+ " V_CL- "+TMPSF2->A1_VEND)
     	 	cQry2	:= " SELECT SD2.D2_DOC,SD2.D2_SERIE,SD2.D2_ITEM,SD2.D2_COD,SD2.D2_QUANT,SD2.D2_VALBRUT,SD2.D2_VALIPI,SD2.D2_VALICM,SD2.D2_VALIMP5,SD2.D2_VALIMP6,SD2.D2_PEDIDO,SD2.D2_COMIS1,"
			cQry2	+= "(SELECT SB1.B1_COMIS FROM "+RetSqlName("SB1")+" SB1"
			cQry2   += "		WHERE SB1.B1_FILIAL = '"+xFilial("SB1")+"' "
			cQry2	+= "		AND SB1.B1_COD = SD2.D2_COD"
			cQry2	+= "		AND SB1.D_E_L_E_T_ <> '*')"
			cQry2	+= " FROM "+RetSqlName("SD2")+" SD2"
			cQry2	+= " WHERE SD2.D2_FILIAL = '"+xFilial("SD2")+"'"
			cQry2	+= " AND SD2.D2_DOC = '"+TMPSF2->F2_DOC+"'"	
			cQry2	+= " AND SD2.D2_SERIE = '"+TMPSF2->F2_SERIE+"'"
			cQry2	+= " AND SD2.D_E_L_E_T_ <> '*' ORDER BY SD2.D2_ITEM"
            If Select("TMPSD2") > 0
			  dbSelectArea("TMPSD2")
			  dbCloseArea()
		    EndIf
            TCQUERY cQry2 NEW ALIAS "TMPSD2"
		    dbSelectArea("TMPSD2")
		    dbGoTop()
            ProcRegua(RecCount())
	        nValbruto:=0 
	        nValIcm:=0
	        nValIpi:=0
	        nValPis:=0
	        nValCof:=0
	        nValCom:=0
	        nBaseCom:=0
	     	cPedido:=TMPSD2->D2_PEDIDO 
	     	cVendedor:=TMPSF2->A1_VEND
	     	dbSelectArea("SC5")
	     	dbsetORDER(1)
	     	If MsSeek(xFilial("SC5")+cPedido)
	     	  if SC5->C5_CONTATO<>'               ' 
	     	    cVendedor:=SC5->C5_VEND1
	     	  ENDIF  
	     	ENDIF
	     	dbSelectArea("TMPSD2")
	     	While !Eof()
     	       IncProc("NOTA "+TMPSF2->F2_DOC+ " ITEM" +TMPSD2->D2_ITEM+ ".")
     	       // recalculo da comissao com base na regra de negocio
     	       nValbruto+=TMPSD2->D2_VALBRUT 
	           nValIcm  +=TMPSD2->D2_VALICM 
	           nValIpi  +=TMPSD2->D2_VALIPI 
	           nValPis  +=TMPSD2->D2_VALIMP5 
	           nValCof  +=TMPSD2->D2_VALIMP6 
	           nBaseCom +=TMPSD2->D2_VALBRUT-TMPSD2->D2_VALICM-TMPSD2->D2_VALIPI-TMPSD2->D2_VALIMP5-TMPSD2->D2_VALIMP6 
	           nBaseItem:=TMPSD2->D2_VALBRUT-TMPSD2->D2_VALICM-TMPSD2->D2_VALIPI-TMPSD2->D2_VALIMP5-TMPSD2->D2_VALIMP6
	           If nPerCom=0
	             nPercom:=TMPSD2->B1_COMIS
	           ENDIF
	           nValCom  +=nBaseItem*(nPercom/100)
	           // GRAVANDO % COMISSAO ATUAL NA SD2
	           dbSelectArea("SD2")
	           dbSetOrder(10)
	           If MsSeek(xFilial("SD2")+TMPSD2->D2_DOC+TMPSD2->D2_SERIE+TMPSD2->D2_ITEM)
	             RecLock("SD2",.F.)
	             SD2->D2_COMIS1=nPerCom
	             MsUnLock() 	      
	           ENDIF
	           dbSelectArea("TMPSD2")
	           dbSkip()
            EndDo
     	    // GRAVACAO DA NF NO >>>>SE3<<<<< 
     	    dbSelectArea("SE3")
	        dbSetOrder(1)
		    If MsSeek(xFilial("SE3")+"011"+TMPSF2->F2_DOC+"   "+TMPSF2->A1_VEND)
     	    ELSE
     	      IncProc("GRAVANDO COMISSAO REF: NF "+TMPSF2->F2_DOC)
     	      RecLock("SE3",.T.)
     	      SE3->E3_FILIAL :=xFilial("SE3")
     	      SE3->E3_VEND   :=cVendedor
     	      SE3->E3_NUM    :=TMPSF2->F2_DOC
     	      SE3->E3_EMISSAO:=CTOD(SUBSTR(TMPSF2->F2_EMISSAO,7,2)+"/"+SUBSTR(TMPSF2->F2_EMISSAO,5,2)+"/"+SUBSTR(TMPSF2->F2_EMISSAO,1,4))
     	      SE3->E3_SERIE  :=TMPSF2->F2_SERIE
     	      SE3->E3_CODCLI :=TMPSF2->F2_CLIENTE
              SE3->E3_LOJA   :=TMPSF2->F2_LOJA 
              IF nBaseCom<=0
                SE3->E3_BASE   :=nBaseCom
                SE3->E3_COMIS  :=0
                SE3->E3_PORC   :=0
                SE3->E3_HIST   :="Base da Comissao abaixo do Minimo"
              else
                SE3->E3_BASE   :=nBaseCom
                SE3->E3_COMIS  :=nValcom
                SE3->E3_PORC   :=(nValcom/nBaseCom)*100 
              endif  
              SE3->E3_PREFIXO:=TMPSF2->F2_PREFIXO
              SE3->E3_TIPO   :=TMPSF2->F2_ESPECIE
              SE3->E3_BAIEMI :="E"
              SE3->E3_PEDIDO :=cPedido
              SE3->E3_ORIGEM :="F"
              SE3->E3_VENCTO :=CTOD("05/"+SUBSTR(TMPSF2->F2_EMISSAO,5,2)+"/"+SUBSTR(TMPSF2->F2_EMISSAO,1,4))+30
              MsUnLock() 	      
     	    ENDIF
     	    dbSelectArea("TMPSF2")
     	    dbSkip()
        EndDo
endif
Close(Odlg1)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFinaliza  บAutor  ณRobson Bueno        บ Data ณ 18/04/2007  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFinalizacao do Objeto                                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณHCI                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Finaliza(Odlg1)

Close(Odlg1)

Return
                 


