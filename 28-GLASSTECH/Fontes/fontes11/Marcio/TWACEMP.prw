#INCLUDE "RWMAKE.ch" 
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"


//ROTINA PARA ACERTAR TODOS OS EMPENHOS DE B8 E BF DE TODOS OS PRODUTOS DOS PEDIDOS DE VENDAS COLOCADOS.
//OS DEMAIS SERAO PROCESSADOS NAS ROTINAS COLOCADAS NA LIBERACAO DOS PRODUTOS. ANTES DOS PRODUTOS PASSAREM PELO PROCESSO DE LIBERACAO


User Function TWACEMP()
Dbselectarea("SC9")
xFILIALC9 := xFILIAL("SC9")

Dbseek(xFILIALC9)
xPRODUTO:= ""

While !eof() .and. SC9->C9_FILIAL == xFILIALC9
   If SC9->C9_BLEST == "10" .OR. SC9->C9_BLEST == "02" .OR. xPRODUTO == SC9->C9_PRODUTO+SC9->C9_LOCAL .OR. SC9->C9_GRUPO == "0003"
      Dbskip()
      Loop
   Endif
   
    
    xPRODUTO := SC9->C9_PRODUTO+SC9->C9_LOCAL
    U_TWAJEMP(SC9->C9_PRODUTO,SC9->C9_LOCAL,SC9->C9_PEDIDO,SC9->C9_ITEM,"","","","")
    
    Dbselectarea("SC9")
    Dbskip()
Enddo    

Return()




User Function TWACEMPB2()
Dbselectarea("SB2")
xFILIALB2 := xFILIAL("SB2")

Dbseek(xFILIALB2)
xPRODUTO:= ""

While !eof() .and. SB2->B2_FILIAL == xFILIALB2
   Dbselectarea("SB1")
   DbsetOrder(1)
   Dbseek(xFILIAL("SB1")+SB2->B2_COD)
   Dbselectarea("SB2")   
   
   If  xPRODUTO == SB2->B2_COD+SB2->B2_LOCAL .OR. SB1->B1_GRUPO == "0003" .OR. SB1->B1_LOCALIZ <> "S";
   		.OR. (SB2->B2_LOCAL != "07" .AND. SB2->B2_LOCAL != "08" .AND. SB2->B2_LOCAL != "09")
      Dbskip()
      Loop
   Endif
   
    
    xPRODUTO := SB2->B2_COD+SB2->B2_LOCAL
    U_TWAJEMP(SB2->B2_COD,SB2->B2_LOCAL,"","","","","","")
    
    Dbselectarea("SB2")
    Dbskip()
Enddo    

Return()



