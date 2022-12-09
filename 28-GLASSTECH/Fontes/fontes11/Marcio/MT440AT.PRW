#INCLUDE "RWMAKE.ch" 
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

User Function MT440AT()
  If xFILIAL("SC6")<>"0202"
     Return(.T.)
  Endif
  
  Dbselectarea("SC6")
  DbsetOrder(1)
  Dbseek(xFILIAL("SC6")+SC5->C5_NUM)
  While !eof() .and. xFILIAL("SC6")+SC5->C5_NUM == SC6->C6_FILIAL+SC6->C6_NUM
      If SC6->C6_QTDENT < SC6->C6_QTDVEN
	 	 Dbselectarea("SBF")
	     DbsetOrder(2)
	     If DBseek(xFILIAL("SBF")+SC6->C6_PRODUTO+SC6->C6_LOCAL)
			   U_TWAJEMP(SC6->C6_PRODUTO,SC6->C6_LOCAL,SC6->C6_NUM,SC6->C6_ITEM,"","","","")
		 Endif
		 	   
	  Endif
	  Dbselectarea("SC6")
	  Dbskip()
  Enddo
  
  Return(.T.)	  	
			