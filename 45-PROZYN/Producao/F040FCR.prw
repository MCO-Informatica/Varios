#Include "PROTHEUS.CH"    

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    F040FCR          ºAutor  ³DenisVarellaº Data ³  05/03/2018   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada para criar SE3 em títulos AB-	          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER FUNCTION F040FCR()

   If SE1->E1_TIPO == 'AB-'         
      If trim(SE1->E1_VEND1) != ''   
         cBaiEmi := 'E'                                                      
         If POSICIONE('SA3',1,xFilial('SA3')+SE1->E1_VEND1,"A3_ALBAIXA") == 100
         cBaiEmi := 'B'
         EndIf
      dbSelectArea("SE3")
      RecLock("SE3",.T.)     
         E3_FILIAL := SE1->E1_FILIAL
         E3_VEND := SE1->E1_VEND1
         E3_NUM := SE1->E1_NUM
         E3_EMISSAO := SE1->E1_EMIS1
         E3_CODCLI := SE1->E1_CLIENTE
         E3_LOJA := SE1->E1_LOJA
         E3_PORC := POSICIONE('SA3',1,xFilial('SA3')+SE1->E1_VEND1,"A3_COMIS")
         E3_COMIS := (SE1->E1_VALOR / 100 * POSICIONE('SA3',1,xFilial('SA3')+SE1->E1_VEND1,"A3_COMIS")) * -1
         E3_PREFIXO := SE1->E1_PREFIXO
         E3_PARCELA := SE1->E1_PARCELA
         E3_VENCTO := SE1->E1_VENCTO
         E3_TIPO := SE1->E1_TIPO   
         E3_PEDIDO := POSICIONE('SE1',1,xFilial('SE1')+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+'NF ',"E1_PEDIDO")
         E3_SERIE := POSICIONE('SE1',1,xFilial('SE1')+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+'NF ',"E1_SERIE")
         E3_MOEDA := PadL( POSICIONE('SE1',1,xFilial('SE1')+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+'NF ',"E1_MOEDA"), 2, "0" )
         E3_BASE := POSICIONE('SE1',1,xFilial('SE1')+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+'AB-',"E1_VALOR")
         E3_BASEBRU := SE3->E3_BASE
         E3_BAIEMI := cBaiEmi
      MSUnlock() 
      EndIf      
      
      If trim(SE1->E1_VEND2) != ''  
         cBaiEmi := 'E'
         If POSICIONE('SA3',1,xFilial('SA3')+SE1->E1_VEND2,"A3_ALBAIXA") == 100
         cBaiEmi := 'B'
         EndIf
      dbSelectArea("SE3")
      RecLock("SE3",.T.)     
      E3_FILIAL := SE1->E1_FILIAL
      E3_VEND := SE1->E1_VEND2
      E3_NUM := SE1->E1_NUM
      E3_EMISSAO := SE1->E1_EMIS1
      E3_CODCLI := SE1->E1_CLIENTE
      E3_LOJA := SE1->E1_LOJA
      E3_PORC := POSICIONE('SA3',1,xFilial('SA3')+SE1->E1_VEND2,"A3_COMIS")
      E3_COMIS := (SE1->E1_VALOR / 100 * POSICIONE('SA3',1,xFilial('SA3')+SE1->E1_VEND2,"A3_COMIS")) * -1
      E3_PREFIXO := SE1->E1_PREFIXO
      E3_PARCELA := SE1->E1_PARCELA
      E3_VENCTO := SE1->E1_VENCTO
      E3_TIPO := SE1->E1_TIPO 
      E3_SERIE := POSICIONE('SE1',1,xFilial('SE1')+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+'NF ',"E1_SERIE")
      E3_PEDIDO := POSICIONE('SE1',1,xFilial('SE1')+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+'NF ',"E1_PEDIDO")
      E3_MOEDA := PadL( POSICIONE('SE1',1,xFilial('SE1')+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+'NF ',"E1_MOEDA"), 2, "0" )
      E3_BASE := POSICIONE('SE1',1,xFilial('SE1')+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+'AB-',"E1_VALOR")
      E3_BASEBRU := SE3->E3_BASE
      E3_BAIEMI := cBaiEmi
      MSUnlock() 
      EndIf
      
      If trim(SE1->E1_VEND3) != ''  
         cBaiEmi := 'E'
         If POSICIONE('SA3',1,xFilial('SA3')+SE1->E1_VEND3,"A3_ALBAIXA") == 100
         cBaiEmi := 'B'
         EndIf
      dbSelectArea("SE3")
      RecLock("SE3",.T.)     
      E3_FILIAL := SE1->E1_FILIAL
      E3_VEND := SE1->E1_VEND3
      E3_NUM := SE1->E1_NUM
      E3_EMISSAO := SE1->E1_EMIS1
      E3_CODCLI := SE1->E1_CLIENTE
      E3_LOJA := SE1->E1_LOJA
      E3_PORC := POSICIONE('SA3',1,xFilial('SA3')+SE1->E1_VEND3,"A3_COMIS")
      E3_COMIS := (SE1->E1_VALOR / 100 * POSICIONE('SA3',1,xFilial('SA3')+SE1->E1_VEND3,"A3_COMIS")) * -1
      E3_PREFIXO := SE1->E1_PREFIXO
      E3_PARCELA := SE1->E1_PARCELA
      E3_VENCTO := SE1->E1_VENCTO
      E3_TIPO := SE1->E1_TIPO
      E3_SERIE := POSICIONE('SE1',1,xFilial('SE1')+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+'NF ',"E1_SERIE")
      E3_PEDIDO := POSICIONE('SE1',1,xFilial('SE1')+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+'NF ',"E1_PEDIDO")
      E3_MOEDA := PadL( POSICIONE('SE1',1,xFilial('SE1')+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+'NF ',"E1_MOEDA"), 2, "0" )
      E3_BASE := POSICIONE('SE1',1,xFilial('SE1')+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+'AB-',"E1_VALOR")
      E3_BASEBRU := SE3->E3_BASE
      E3_BAIEMI := cBaiEmi
      MSUnlock() 
      EndIf
      
      If trim(SE1->E1_VEND4) != ''  
         cBaiEmi := 'E'
         If POSICIONE('SA3',1,xFilial('SA3')+SE1->E1_VEND4,"A3_ALBAIXA") == 100
         cBaiEmi := 'B'
         EndIf
      dbSelectArea("SE3")
      RecLock("SE3",.T.)     
      E3_FILIAL := SE1->E1_FILIAL
      E3_VEND := SE1->E1_VEND4
      E3_NUM := SE1->E1_NUM
      E3_EMISSAO := SE1->E1_EMIS1
      E3_CODCLI := SE1->E1_CLIENTE
      E3_LOJA := SE1->E1_LOJA
      E3_PORC := POSICIONE('SA3',1,xFilial('SA3')+SE1->E1_VEND4,"A3_COMIS")
      E3_COMIS := (SE1->E1_VALOR / 100 * POSICIONE('SA3',1,xFilial('SA3')+SE1->E1_VEND4,"A3_COMIS")) * -1
      E3_PREFIXO := SE1->E1_PREFIXO
      E3_PARCELA := SE1->E1_PARCELA
      E3_VENCTO := SE1->E1_VENCTO
      E3_TIPO := SE1->E1_TIPO
      E3_SERIE := POSICIONE('SE1',1,xFilial('SE1')+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+'NF ',"E1_SERIE")
      E3_PEDIDO := POSICIONE('SE1',1,xFilial('SE1')+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+'NF ',"E1_PEDIDO")
      E3_MOEDA := PadL( POSICIONE('SE1',1,xFilial('SE1')+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+'NF ',"E1_MOEDA"), 2, "0" )
      E3_BASE := POSICIONE('SE1',1,xFilial('SE1')+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+'AB-',"E1_VALOR")
      E3_BASEBRU := SE3->E3_BASE
      E3_BAIEMI := cBaiEmi
      MSUnlock() 
      EndIf
      
      If trim(SE1->E1_VEND5) != ''  
         cBaiEmi := 'E'
         If POSICIONE('SA3',1,xFilial('SA3')+SE1->E1_VEND5,"A3_ALBAIXA") == 100
         cBaiEmi := 'B'
         EndIf
      dbSelectArea("SE3")
      RecLock("SE3",.T.)     
      E3_FILIAL := SE1->E1_FILIAL
      E3_VEND := SE1->E1_VEND5
      E3_NUM := SE1->E1_NUM
      E3_EMISSAO := SE1->E1_EMIS1
      E3_CODCLI := SE1->E1_CLIENTE
      E3_LOJA := SE1->E1_LOJA
      E3_PORC := POSICIONE('SA3',1,xFilial('SA3')+SE1->E1_VEND5,"A3_COMIS")
      E3_COMIS := (SE1->E1_VALOR / 100 * POSICIONE('SA3',1,xFilial('SA3')+SE1->E1_VEND5,"A3_COMIS")) * -1
      E3_PREFIXO := SE1->E1_PREFIXO
      E3_PARCELA := SE1->E1_PARCELA
      E3_VENCTO := SE1->E1_VENCTO
      E3_TIPO := SE1->E1_TIPO
      E3_SERIE := POSICIONE('SE1',1,xFilial('SE1')+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+'NF ',"E1_SERIE")
      E3_PEDIDO := POSICIONE('SE1',1,xFilial('SE1')+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+'NF ',"E1_PEDIDO")
      E3_MOEDA := PadL( POSICIONE('SE1',1,xFilial('SE1')+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+'NF ',"E1_MOEDA"), 2, "0" )
      E3_BASE := POSICIONE('SE1',1,xFilial('SE1')+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+'AB-',"E1_VALOR")
      E3_BASEBRU := SE3->E3_BASE
      E3_BAIEMI := cBaiEmi
      MSUnlock() 
      EndIf
      
   EndIf

RETURN
