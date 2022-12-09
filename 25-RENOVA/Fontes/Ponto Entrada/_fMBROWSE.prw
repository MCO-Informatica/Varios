#include "topconn.ch"
#include "protheus.ch"
User Function _fMBROWSE() //u__fMBROWSE()
   Local cArquivo := ""
   Local cQuery := ""
   Local aCPOSTMP := {}
   Private cCadastro := ""
   Private aRotina    := {}
   Private _aArqTmp   := {}
   Private aTitulos   := {}
   Private aIndexQRY   := {}
   Private cPerg       := '_fMBROWSE'
   Private cDelFunc := ".F."
   
 
   cCadastro   := "[_fMBROWSE] - _fMBROWSE"
   
   Pergunte(cPerg,.T.)
    
   _aArqTmp:= {}
   AADD(_aArqTmp,{"B1_COD"    ,   "C",TamSx3("B1_COD")[1]   , 0})
   AADD(_aArqTmp,{"B1_DESC"   ,   "C",TamSx3("B1_DESC")[1]  , 0})
 
  aCPOSTMP := {"B1_COD","B1_DESC"}
  
   	FOR I:=1 TO LEN(aCPOSTMP)
		SX3->(dbSetOrder(2))
		SX3->(MsSeek(aCPOSTMP[I]))
		AADD(aTitulos,{SX3->X3_TITULO,SX3->X3_CAMPO,SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_PICTURE})
	Next
   
    
   cQuery := " SELECT B1_COD,B1_DESC "
   cQuery += " FROM " + RETSQLNAME("SB1") + " SB1 "
   cQuery += " WHERE B1_FILIAL = '"+xFilial("SB1")+"' AND "
   cQuery += " SB1.D_E_L_E_T_ != '*' "
   
   if(!empty(mv_par02))
		cQuery += " AND B1_COD >= '"+mv_par01+"' AND B1_COD <= '"+mv_par02+"' "
   endif
   cQuery += " ORDER BY B1_COD "         
 
 
   cArquivo := CriaTrab(_aArqTmp,.T.)
   dbUseArea(.T.,,cArquivo,"QRY",.F.,.F.)
   
   SQLToTrb(cQuery,_aArqTmp,"QRY")
   
   Index on QRY->B1_COD To &cArquivo  
 
   DbSelectArea("QRY")
   QRY->(dbSetOrder(1))
   QRY->(dbGoTop())
   
   mBrowse( 6, 1,22,75,"QRY",aTitulos,,,,, )
   dbCloseArea("QRY")
   fErase(cArquivo+".*")
Return