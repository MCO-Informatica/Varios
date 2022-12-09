
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MSD2460   ºAutor  ³ROBSON BUENO        º Data ³  30/11/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MSD2460()
Local cNota
Local cRegistro	
Local _aArea	
// TRATA CUSTO DA VENDA NA SD2 D2_CUSTO1
DbSelectArea("PAA")
dbSetOrder(1)
if MsSeek(xfilial("PAA")+SD2->D2_COD)
  RecLock("SD2",.F.)
  SD2->D2_CUSTO1:=SD2->D2_QUANT*PAA->PAA_UNIT
  MSUNLOCK()
ENDIF
// TRATA CONTROLE DE PROCESSO
IF SUBSTRING(SD2->D2_PEDIDO,1,1)="B"
  DBSELECTAREA("AB7")
  dbSetOrder(1)
  MsSeek(xfilial("AB7")+"1"+SUBSTRING(SD2->D2_PEDIDO,2,5)+"01")
  dbselectarea("PC2")
  dbSetOrder(4)
  MsSeek(xfilial("PC2")+AB7->AB7_PV+AB7->AB7_ITPV+"000009")
  if PC2->PC2_QTDORI-PC2->PC2_QTD>0 .and. PC2->PC2_NUM=AB7->AB7_PV .AND. AB7->AB7_ITPV=PC2->PC2_ITEM .AND. PC2->PC2_SEQ="000009"
       cRegistro:=PC2->PC2_CTR
       // 2 BAIXA O FATURAMENTO OS E POE EM AGUARDANDO RECEBIMENTO
        U_HCICTPR(AB7->AB7_PV,AB7->AB7_ITPV,"000009","000010",SD2->D2_QUANT,"Aguardando Transporte","","","NF/BN:"+SD2->D2_DOC+" - "+SD2->D2_ITEM,cRegistro) 
  endif
ENDIF  
IF SUBSTRING(SD2->D2_PEDIDO,1,1)="D"
  dbselectarea("PC2")
  dbSetOrder(4)
  MsSeek(xfilial("PC2")+SD2->D2_PEDIDO+SD2->D2_ITEMPV+"000022")
  if PC2->PC2_QTDORI-PC2->PC2_QTD>0 .and. PC2->PC2_NUM=SZK->ZK_REF .AND. SD2->D2_ITEMPV=PC2->PC2_ITEM .AND. PC2->PC2_SEQ="000022"
       cRegistro:=PC2->PC2_CTR
       // 2 BAIXA O FATURAMENTO OS E POE EM AGUARDANDO RECEBIMENTO
        U_HCICTPR(SD2->D2_PEDIDO,SD2->D2_ITEMPV,"000022","000023",SD2->D2_QUANT,"Aguardando Transporte","","","NF/DV:"+SD2->D2_DOC+" - "+SD2->D2_ITEM,cRegistro) 
  endif
ENDIF  
IF SUBSTRING(SD2->D2_PEDIDO,1,1)!="D" .AND. SUBSTRING(SD2->D2_PEDIDO,1,1)!="B"
  dbselectarea("PC2")
  dbSetOrder(4)
  MsSeek(xfilial("PC2")+SD2->D2_PEDIDO+SD2->D2_ITEMPV+"000025")
  if PC2->PC2_QTDORI-PC2->PC2_QTD>0 .and. PC2->PC2_NUM=SZK->ZK_REF .AND. SD2->D2_ITEMPV=PC2->PC2_ITEM .AND. PC2->PC2_SEQ="000025"
       cRegistro:=PC2->PC2_CTR
       // 2 BAIXA O FATURAMENTO OS E POE EM AGUARDANDO RECEBIMENTO
        U_HCICTPR(SD2->D2_PEDIDO,SD2->D2_ITEMPV,"000025","000026",SD2->D2_QUANT,"Aguardando Transporte","","","NF/FT:"+SD2->D2_DOC+" - "+SD2->D2_ITEM,cRegistro) 
  endif
ENDIF  


// FIM DE TRATAMENTO  
  
//Alteração referente a D2_CLASFIS - BZO - 21//7/2015
_aArea	:= GetArea()

dbSelectArea("SC6")
SC6->(dbSetOrder(1))
If SC6->(dbSeek(xFilial("SC6") + SD2->D2_PEDIDO + SD2->D2_ITEMPV + SD2->D2_COD)) //C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO
	RecLock("SD2",.F.)
	SD2->D2_CLASFIS	  := SC6->C6_CLASFIS	
	MSUNLOCK()
EndIf

dbSelectArea("SFT") 
SFT->(dbSetOrder(1))//FT_FILIAL+FT_TIPOMOV+FT_SERIE+FT_NFISCAL+FT_CLIEFOR+FT_LOJA+FT_ITEM+FT_PRODUTO  
If SFT->(dbSeek(xFilial("SFT") + "S" + SD2->D2_SERIE + SD2->D2_DOC + SD2->D2_CLIENTE + SD2->D2_LOJA + SD2->D2_ITEM + SD2->D2_COD))
	RecLock("SFT",.F.)
	SFT->FT_CLASFIS	:= SD2->D2_CLASFIS
  SFT->FT_CONTA 	:= Posicione("SB1",1,xFilial("SB1")+SD2->D2_COD,"B1_CONTA")
	SFT->FT_POSIPI 	:= Posicione("SB1",1,xFilial("SB1")+SD2->D2_COD,"B1_POSIPI")
	MSUNLOCK()
EndIf

dbSelectArea("CD2") 
CD2->(dbSetOrder(1))
If CD2->(dbSeek(xFilial("SFT") + "S" + SD2->D2_SERIE + SD2->D2_DOC + SD2->D2_CLIENTE + SD2->D2_LOJA + SD2->D2_ITEM + SD2->D2_COD))//CD2_FILIAL+CD2_TPMOV+CD2_SERIE+CD2_DOC+CD2_CODCLI+CD2_LOJCLI+CD2_ITEM+CD2_CODPRO+CD2_IMP
	While SD2->D2_SERIE == CD2_SERIE .And. SD2->D2_DOC == CD2_DOC .And. SD2->D2_CLIENTE == CD2_CODCLI .And. SD2->D2_LOJA == CD2_LOJCLI .And. SD2->D2_ITEM == CD2_ITEM .And. SD2->D2_COD == CD2_CODPRO .And. CD2_TPMOV == "S" .And. CD2_FILIAL == xFilial("SD2")
		If CD2_IMP $ "ICM|SOL"
			RecLock("CD2",.F.)
			CD2->CD2_ORIGEM	:= SUBSTRING(SD2->D2_CLASFIS,1,1)
			CD2->CD2_CST	:= SUBSTRING(SD2->D2_CLASFIS,2,2)
			MSUNLOCK()
		EndIf
		CD2->(DBSKIP())
	EndDo
EndIF

RestArea(_aArea)
  
Return()
	