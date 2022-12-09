#INCLUDE "protheus.ch"

User Function M440STTS() 
	Local aAreaSC5 :=  SC5->(GetArea())
	Local aAreaSC6 :=  SC6->(GetArea())
	Local aAreaSC9 :=  SC9->(GetArea())
	Local lRet     := .T.


_aArSC5 := SC5-> ( GetArea() )
_aArSC6 := SC6-> ( GetArea() )


xPEDIDO := SC9->C9_PEDIDO
Dbselectarea("SC9")
DbsetOrder(1)
Dbseek(xFILIAL("SC9")+xPEDIDO)
While !eof() .and. xFILIAL("SC9")+xPEDIDO == SC9->C9_FILIAL+SC9->C9_PEDIDO
	If EMPTY(SC9->C9_NFISCAL) .AND. EMPTY(SC9->C9_ORDSEP)
	    Dbselectarea("SDC")
    	DbsetOrder(1)
    	If Dbseek(xFILIAL("SDC")+SC9->C9_PRODUTO+SC9->C9_LOCAL+"SC6"+SC9->C9_PEDIDO+SC9->C9_ITEM+SC9->C9_SEQUEN)
	
			U_TWAJEMP(SC9->C9_PRODUTO,SC9->C9_LOCAL,SC9->C9_PEDIDO,SC9->C9_ITEM,SC9->C9_NUMSERI,SC9->C9_LOTECTL,SC9->C9_NUMLOTE,SDC->DC_LOCALIZ)
// yPRODUTO,yLOCAL,yPEDIDO,yITEM,yNUMSERI,yLOTECTL,yNUMLOTE,yLOCALIZ)

        Endif
    Endif
//MONTAR UMA QUERY COM O C9 - PARA PRODUTO  + NF EM BRANCO + NUMERO DA CARGA E GRAVAR NO EMPENHO DO B8 E BF.
    Dbselectarea("SC9")
    Dbskip()
Enddo    
	
	restArea( aAreaSC5 )
	RestArea( aAreaSC6 )
	RestArea( aAreaSC9 )
	Return()
 



