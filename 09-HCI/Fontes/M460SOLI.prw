
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M460SOLI  ºAutor  ³Robson Bueno        º Data ³  03/02/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³   Tratamento p/ calc. de Sub. Tributaria com dados da vendaº±±
±±º          ³   sem alt do grupo de trib do produto (SB1)                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function M460SOLI()
  Local nIcmItemH:= ICMSITEM
  Local nQuantH  := QUANTITEM
  Local nMargemH := MARGEMLUCR
  Local nTotalProdH:=ROUND(BASEICMRET/(1+(MARGEMLUCR/100)),2)
  lOCAL nMargemHc:=0
  Local nAliqIntHc:=0
  Local cCliTRib
  Local cGrExFis:= GetMv("MV_GRTR13")
  // VARIAVEIS PARA RETORNO
  Local nBsIcmsRetH:=BASEICMRET
  Local nIcmsRetH:=0  
  
  If MV_PAR29 == 1
  //If MsgYesNo("Atencao, Deseja Processar Ponto de Entrada para Recalculo do ICMS(ST)?","Verificacao")  
  IF BASEICMRET>0
    IF SC5->C5_TIPO="N"
       // VENDA DE MATERIAIS IMPORTADOS
       IF SC5->C5_TIPOPV="1" .OR. SC5->C5_TIPOPV="2" .OR. SC5->C5_TIPOPV="3"
          // tratamento para diferencial de alicota 
          IF SC5->C5_TIPOCLI="F" .AND. Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_CONTRIB")="1" .AND. Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_EST")<>"SP"
            cCliTrib:=Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_GRPTRIB")
            dbSelectArea("SF7")
		    dbSetOrder(1)
		    MsSeek(xFilial("SF7")+substring(cGrExFis,1,3)+"   "+cCliTrib)
			While ( !Eof() .And. SF7->F7_FILIAL == xFilial("SF7") .And. SF7->F7_GRTRIB == "013   ") 				
			   IF SF7->F7_GRPCLI=cCliTrib
			     nMargemHc:=SF7->F7_MARGEM
			     nAliqIntHc:=SF7->F7_ALIQINT
			     EXIT
			   ENDIF  
			   SF7->(dbSkip())
			ENDDO
			MARGEMLUCR:=nMargemHc
			IF Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_EST") $ GetMv("MV_UFBDST")
			  if cClitrib="SEC"
			    BASEICMRET:=round(((ICMSITEM/0.04))/(1-((nAliqIntHc)/100)),2)
			  ELSE
			    BASEICMRET:=round(((ICMSITEM/0.04)-ICMSITEM)/(1-(nAliqIntHc/100)),2)
			  ENDIF
			ELSE
			  BASEICMRET:=ICMSITEM/0.04
			ENDIF
			//BASEICMRET:=round(nTotalProdH*(1+(MARGEMLUCR/100)),2)
            nBsIcmsRetH:=BASEICMRET
            if cClitrib="SEC"
              nIcmsRetH:=round(BASEICMRET*(1+(nAliqIntHc/100)),2)-nBsIcmsRetH
            else
              nIcmsRetH:=round(BASEICMRET*(1+(nAliqIntHc/100)),2)-BASEICMRET-ICMSITEM
            endif
            RETURN({nBsIcmsRetH,nIcmsRetH})
          ENDIF
          // tratamento para icms solidario para venda interestadual de produto importado 
          IF SC5->C5_TIPOCLI="S".AND.  Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_EST")<>"SP"
            cCliTrib:=Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_GRPTRIB")
            dbSelectArea("SF7")
		    dbSetOrder(1)
		    MsSeek(xFilial("SF7")+substring(cGrExFis,1,3)+"   "+cCliTrib)
			While ( !Eof() .And. SF7->F7_FILIAL == xFilial("SF7") .And. SF7->F7_GRTRIB == "013   ") 				
			   IF SF7->F7_GRPCLI=cCliTrib
			     nMargemHc:=SF7->F7_MARGEM
			     nAliqIntHc:=SF7->F7_ALIQINT
			     EXIT
			   ENDIF  
			   SF7->(dbSkip())
			ENDDO
			IF nMargemHc<>MARGEMLUCR .AND. nMargemHc>0
			   MARGEMLUCR:=nMargemHc
			   BASEICMRET:=round(nTotalProdH*(1+(MARGEMLUCR/100)),2)
               nBsIcmsRetH:=BASEICMRET
               nIcmsRetH:=round(BASEICMRET*(1+(nAliqIntHc/100)),2)-BASEICMRET-ICMSITEM
               RETURN({nBsIcmsRetH,nIcmsRetH})
            ENDIF      
          ENDIF
       ELSE
       // VENDA DE MATERIAIS NACIONAIS
       // tratamento para diferencial de alicota 
          IF SC5->C5_TIPOCLI="F" .AND. Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_CONTRIB")="1" .AND. Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_EST")<>"SP"
            cCliTrib:=Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_GRPTRIB")
            dbSelectArea("SF7")
		    dbSetOrder(1)
		    MsSeek(xFilial("SF7")+"003   "+cCliTrib)
			While ( !Eof() .And. SF7->F7_FILIAL == xFilial("SF7") .And. SF7->F7_GRTRIB == "003   ") 				
			   IF SF7->F7_GRPCLI=cCliTrib
			     nMargemHc:=SF7->F7_MARGEM
			     nAliqIntHc:=SF7->F7_ALIQINT
			     EXIT
			   ENDIF  
			   SF7->(dbSkip())
			ENDDO
			IF nMargemHc<>MARGEMLUCR .AND. nMargemHc>=0
			   MARGEMLUCR:=nMargemHc
			   //BASEICMRET:=round(nTotalProdH*(1+(MARGEMLUCR/100)),2)
               nBsIcmsRetH:=BASEICMRET
               nIcmsRetH:=round(BASEICMRET*(1+(nAliqIntHc/100)),2)-BASEICMRET-ICMSITEM
               RETURN({nBsIcmsRetH,nIcmsRetH})
            ENDIF      
          ENDIF
          // tratamento para icms solidario para venda interestadual de produto importado 
          IF SC5->C5_TIPOCLI="S".AND.  Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_EST")<>"SP"
            cCliTrib:=Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_GRPTRIB")
            dbSelectArea("SF7")
		    dbSetOrder(1)
		    MsSeek(xFilial("SF7")+"003   "+cCliTrib)
			While ( !Eof() .And. SF7->F7_FILIAL == xFilial("SF7") .And. SF7->F7_GRTRIB == "003   ") 				
			   IF SF7->F7_GRPCLI=cCliTrib
			     nMargemHc:=SF7->F7_MARGEM
			     nAliqIntHc:=SF7->F7_ALIQINT
			     EXIT
			   ENDIF  
			   SF7->(dbSkip())
			ENDDO
			IF nMargemHc<>MARGEMLUCR .AND. nMargemHc>0
			   MARGEMLUCR:=nMargemHc
			   BASEICMRET:=round(nTotalProdH*(1+(MARGEMLUCR/100)),2)
               nBsIcmsRetH:=BASEICMRET
               nIcmsRetH:=round(BASEICMRET*(1+(nAliqIntHc/100)),2)-BASEICMRET-ICMSITEM
               RETURN({nBsIcmsRetH,nIcmsRetH})
            ENDIF      
          ENDIF
        ENDIF
      ENDIF 
    ENDIF
    ELSE 
    
    ENDIF
Return()