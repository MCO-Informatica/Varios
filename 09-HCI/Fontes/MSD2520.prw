
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MSD2520   ºAutor  ³ROBSON BUENO        º Data ³  30/11/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ EXCLUSAO DO DOC SAIDA                                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MSD2520()
Local cNota
Local cRegistro
Local lOkOp:=.T.
// TRATA CONTROLE DE PROCESSO
IF SUBSTRING(SD2->D2_PEDIDO,1,1)="B"
  // Verifica controle de processo antes de excluir
     DBSELECTAREA("AB7")
     dbSetOrder(1)
     MsSeek(xfilial("AB7")+"1"+SUBSTRING(SD2->D2_PEDIDO,2,5)+"01")
     dbselectarea("PC2")
     dbSetOrder(6)
     MsSeek(xfilial("PC2")+AB7->AB7_PV+AB7->AB7_ITPV+"NF/BN:"+SD2->D2_DOC+" - "+SD2->D2_ITEM)
     IF SUBSTRING(PC2->PC2_INF,1,17)="NF/BN:"+SD2->D2_DOC+" - "+SD2->D2_ITEM
       // Primeiramente Verifica se tem processo posterior registrado
       IF U_HCIPDPR(PC2->PC2_NUM,PC2->PC2_ITEM,PC2->PC2_CTR)=.T.  // PEDIDO - ITEM - CONTROLE
         U_HCIEXPR(PC2->PC2_NUM,PC2->PC2_ITEM,PC2->PC2_CTR) 
       ELSE
         lOkOP:=.F.
       ENDIF  
     ENDIF
ENDIF  
IF SUBSTRING(SD2->D2_PEDIDO,1,1)="D"
  // Verifica controle de processo antes de excluir
     dbselectarea("PC2")
     dbSetOrder(6)
     MsSeek(xfilial("PC2")+SD2->D2_PEDIDO+SD2->D2_ITEMPV+"NF/DV:"+SD2->D2_DOC+" - "+SD2->D2_ITEM)
     IF SUBSTRING(PC2->PC2_INF,1,17)="NF/DV:"+SD2->D2_DOC+" - "+SD2->D2_ITEM
       // Primeiramente Verifica se tem processo posterior registrado
       IF U_HCIPDPR(PC2->PC2_NUM,PC2->PC2_ITEM,PC2->PC2_CTR)=.T.  // PEDIDO - ITEM - CONTROLE
         U_HCIEXPR(PC2->PC2_NUM,PC2->PC2_ITEM,PC2->PC2_CTR) 
       ELSE
         lOkOP:=.F.
       ENDIF  
     ENDIF
ENDIF  
IF SUBSTRING(SD2->D2_PEDIDO,1,1)!="D" .AND. SUBSTRING(SD2->D2_PEDIDO,1,1)!="B"
  // Verifica controle de processo antes de excluir
     dbselectarea("PC2")
     dbSetOrder(6)
     MsSeek(xfilial("PC2")+SD2->D2_PEDIDO+SD2->D2_ITEMPV+"NF/FT:"+SD2->D2_DOC+" - "+SD2->D2_ITEM)
     IF SUBSTRING(PC2->PC2_INF,1,17)="NF/FT:"+SD2->D2_DOC+" - "+SD2->D2_ITEM
       // Primeiramente Verifica se tem processo posterior registrado
       IF U_HCIPDPR(PC2->PC2_NUM,PC2->PC2_ITEM,PC2->PC2_CTR)=.T.  // PEDIDO - ITEM - CONTROLE
         U_HCIEXPR(PC2->PC2_NUM,PC2->PC2_ITEM,PC2->PC2_CTR) 
       ELSE
         lOkOP:=.F.
       ENDIF  
     ENDIF
ENDIF  


// FIM DE TRATAMENTO  
  
  
  
Return()
	