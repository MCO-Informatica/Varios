#INCLUDE "RWMAKE.ch" 
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
User Function TWAJEMP(yPRODUTO,yLOCAL,yPEDIDO,yITEM,yNUMSERI,yLOTECTL,yNUMLOTE,yLOCALIZ)

zCONT:= .T.
zPRODUTO := yPRODUTO
zLOCAL   := yLOCAL
zPEDIDO  := yPEDIDO
zITEM    := yITEM
zNUMSERI := yNUMSERI
zLOTECTL := yLOTECTL
zNUMLOTE := yNUMLOTE
zLOCALIZ := yLOCALIZ
xNOVOLOTE := ""

xOLDAREA :=GetArea()

zQuery := ""
zQuery += "SELECT 
	lQuery    :=.T.
	zQuery := "SELECT DC_PRODUTO,DC_LOCAL,DC_LOCALIZ, DC_NUMLOTE, DC_LOTECTL,DC_NUMSERI, SUM(DC_QUANT) EMPENHO FROM "  + RetSqlName("SDC") + " SDC, " + RetSqlName("SC9") + " SC9"  
	zQuery += " WHERE SDC.DC_PRODUTO = '" + zPRODUTO + "' AND SDC.DC_LOCAL = '" + zLOCAL + "' AND "
	If !Empty(zLOTECTL)
		zQuery += " SDC.DC_LOTECTL = '" + zLOTECTL + "' AND " 
	EndIf                        
	If !Empty(zLOCALIZ)
       zQuery += " SDC.DC_LOCALIZ = '" + zLOCALIZ + "' AND "
    Endif   
	If !Empty(zNUMLOTE)
		zQuery += " SDC.DC_NUMLOTE = '" + zNUMLOTE + "' AND "
	EndIf

	zQuery += " SDC.DC_ORIGEM = 'SC6' AND SDC.DC_FILIAL = '" + xFilial("SDC") + "' AND SDC.D_E_L_E_T_ <> '*' AND "
	zQuery += " SDC.DC_FILIAL+SDC.DC_PEDIDO+SDC.DC_ITEM+SDC.DC_PRODUTO+SDC.DC_LOCAL+SDC.DC_SEQ = SC9.C9_FILIAL+SC9.C9_PEDIDO+SC9.C9_ITEM+SC9.C9_PRODUTO+SC9.C9_LOCAL+SC9.C9_SEQUEN AND "
	zQuery += " SC9.D_E_L_E_T_ <> '*' AND SC9.C9_ORDSEP <> '      ' AND SC9.C9_BLEST <> '10' "
    zQuery += " GROUP BY DC_PRODUTO,DC_LOCAL,DC_LOCALIZ, DC_NUMLOTE, DC_LOTECTL,DC_NUMSERI"	
	zQuery += " ORDER BY DC_PRODUTO,DC_LOCAL,DC_LOCALIZ, DC_NUMLOTE, DC_LOTECTL,DC_NUMSERI"

	
	zQuery := ChangeQuery( zQuery )
	TCQUERY zQuery NEW ALIAS "SDCEMP"
	dbSelectArea("SDCEMP")
	zQuery := "SDCEMP"
 	
 	Dbselectarea("SBF")
	DbsetOrder(2)
	If DBseek(xFILIAL("SBF")+zPRODUTO+zLOCAL)
	   While !eof() .and. xFILIAL("SBF")+zPRODUTO+zLOCAL == SBF->BF_FILIAL+SBF->BF_PRODUTO+SBF->BF_LOCAL
	      If SBF->BF_EMPENHO > 0   
	            
             Dbselectarea("SBF")
	         RecLock("SBF",.F.)
    	  	     SBF->BF_EMPENHO := 0 //   If(SBF->BF_EMPENHO >= SC9->C9_QTDLIB, SBF->BF_EMPENHO - SC9->C9_QTDLIB,0)
	         MsUnlock()
          Endif
          
		  Dbselectarea("SB8")
		  DbsetOrder(2)
		  If Dbseek(xFILIAL("SB8")+ SBF->BF_NUMLOTE+SBF->BF_LOTECTL+ SBF->BF_PRODUTO+SBF->BF_LOCAL) .AND. SB8->B8_EMPENHO > 0 
	   			Reclock("SB8",.F.)
	     			SB8->B8_EMPENHO := 0     //If(SB8->B8_EMPENHO >= SC9->C9_QTDLIB, SB8->B8_EMPENHO- SC9->C9_QTDLIB,0)
	 	  		MsUnlock()
      	  Endif
   	      dbSelectArea("SBF")
   	      Dbskip()
	   Enddo
	Endif	

    Dbselectarea("SDCEMP")
    Dbgotop()
    While !eof()
 		Dbselectarea("SBF")
		DbsetOrder(1)
		If DBseek(xFILIAL("SBF")+SDCEMP->DC_LOCAL+SDCEMP->DC_LOCALIZ+SDCEMP->DC_PRODUTO+SDCEMP->DC_NUMSERI+SDCEMP->DC_LOTECTL+SDCEMP->DC_NUMLOTE)

           While !eof() .and. xFILIAL("SBF")+SDCEMP->DC_LOCAL+SDCEMP->DC_LOCALIZ+SDCEMP->DC_PRODUTO+SDCEMP->DC_NUMSERI+SDCEMP->DC_LOTECTL+SDCEMP->DC_NUMLOTE == SBF->BF_FILIAL+SBF->BF_LOCAL + ;
	         SBF->BF_LOCALIZ+SBF->BF_PRODUTO + SBF->BF_NUMSERI+SBF->BF_LOTECTL+SBF->BF_NUMLOTE
	         

	         RecLock("SBF",.F.)
    	  	     SBF->BF_EMPENHO := SDCEMP->EMPENHO //   If(SBF->BF_EMPENHO >= SC9->C9_QTDLIB, SBF->BF_EMPENHO - SC9->C9_QTDLIB,0)
	         MsUnlock()

		     Dbselectarea("SB8")
			 DbsetOrder(2)
			 If Dbseek(xFILIAL("SB8")+ SBF->BF_NUMLOTE+SBF->BF_LOTECTL+ SBF->BF_PRODUTO+SBF->BF_LOCAL)
	   			Reclock("SB8",.F.)
	     			SB8->B8_EMPENHO := SB8->B8_EMPENHO + SDCEMP->EMPENHO     //If(SB8->B8_EMPENHO >= SC9->C9_QTDLIB, SB8->B8_EMPENHO- SC9->C9_QTDLIB,0)
	 	  		MsUnlock()
      		 Endif
      	  
      		 Dbselectarea("SBF")
      		 Dbskip()
      	   Enddo	 
        Endif
	    Dbselectarea("SDCEMP")
   	    Dbskip()
	Enddo
	
	SDCEMP->(Dbclosearea())

RestArea(xOLDAREA)
Return()





/*


If !Empty(zLOCALIZ)
 	Dbselectarea("SBF")
	DbsetOrder(1)
	If DBseek(xFILIAL("SBF")+zLOCAL+zLOCALIZ+zPRODUTO+zNUMSERI+zLOTECTL+zNUMLOTE)
	   While !eof() .and. xFILIAL("SBF")+zLOCAL+zLOCALIZ+zPRODUTO+zNUMSERI+zLOTECTL+zNUMLOTE == SBF->BF_FILIAL+SBF->BF_LOCAL + ;
	         SBF->BF_LOCALIZ+SBF->BF_PRODUTO + SBF->BF_NUMSERI+SBF->BF_LOTECTL+SBF->BF_NUMLOTE
	         
	         Dbselectarea("SDCEMP")
	         If Dbseek(SBF->BF_PRODUTO+SBF->BF_LOCAL+SBF->BF_LOCALIZ+SBF->BF_NUMLOTE+SBF->BF_LOTECTL+SBF->BF_NUMSERI)
	            xEMPENHO := SDCEMP->EMPENHO
	         Else
	            xEMPENHO := 0
	         Endif      
	            
             Dbselectarea("SBF")
	         RecLock("SBF",.F.)
    	  	     SBF->BF_EMPENHO := XEMPENHO //   If(SBF->BF_EMPENHO >= SC9->C9_QTDLIB, SBF->BF_EMPENHO - SC9->C9_QTDLIB,0)
	         MsUnlock()

		     Dbselectarea("SB8")
			 DbsetOrder(2)
			 If Dbseek(xFILIAL("SB8")+ SBF->BF_NUMLOTE+SBF->BF_LOTECTL+ SBF->BF_PRODUTO+SBF->BF_LOCAL)
	   			Reclock("SB8",.F.)
	     			SB8->B8_EMPENHO := XEMPENHO     //If(SB8->B8_EMPENHO >= SC9->C9_QTDLIB, SB8->B8_EMPENHO- SC9->C9_QTDLIB,0)
	 	  		MsUnlock()
      		 Endif
   	    	dbSelectArea("SBF")
   	    	Dbskip()
	   Enddo
	Endif	
Else 
 	Dbselectarea("SBF")
	DbsetOrder(2)
	If DBseek(xFILIAL("SBF")+zPRODUTO+zLOCAL)
	   While !eof() .and. xFILIAL("SBF")+zPRODUTO+zLOCAL == SBF->BF_FILIAL+SBF->BF_PRODUTO+SBF->BF_LOCAL
	         
	         Dbselectarea("SDCEMP")
	         If Dbseek(SBF->BF_PRODUTO+SBF->BF_LOCAL+SBF->BF_LOCALIZ+SBF->BF_NUMLOTE+SBF->BF_LOTECTL+SBF->BF_NUMSERI)
	            xEMPENHO := SDCEMP->EMPENHO
	         Else
	            xEMPENHO := 0
	         Endif      
	            
             Dbselectarea("SBF")
	         RecLock("SBF",.F.)
    	  	     SBF->BF_EMPENHO := XEMPENHO //   If(SBF->BF_EMPENHO >= SC9->C9_QTDLIB, SBF->BF_EMPENHO - SC9->C9_QTDLIB,0)
	         MsUnlock()

		     Dbselectarea("SB8")
			 DbsetOrder(2)
			 If Dbseek(xFILIAL("SB8")+ SBF->BF_NUMLOTE+SBF->BF_LOTECTL+ SBF->BF_PRODUTO+SBF->BF_LOCAL)
	   			Reclock("SB8",.F.)
	     			SB8->B8_EMPENHO := XEMPENHO     //If(SB8->B8_EMPENHO >= SC9->C9_QTDLIB, SB8->B8_EMPENHO- SC9->C9_QTDLIB,0)
	 	  		MsUnlock()
      		 Endif
   	    	dbSelectArea("SBF")
   	    	Dbskip()
	   Enddo
	Endif	
Endif
    
*/
