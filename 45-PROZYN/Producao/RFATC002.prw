#include "topconn.ch"
#include "protheus.ch"
#include "rwmake.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRFATC002  บAutor  ณEduardo M. Antunes  บ Data ณ  10/02/2017 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ    TELA DE HISTORICO PEDIDO FATURAMENTO                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP  pROZYN                                     			  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function RFATC002  

_cAlias		:=	Alias()
_nRecno		:=	Recno()
_nIndex		:=	IndexOrd()


Private _nTotalNF   
Private _nValMerc   
Private _nTotICM    
Private _nTotIPI    
Private _nTotCof    
Private _nTotPis 
Public _lVer := .F.
Public _lVTela := .F.   
Public _lVini  := .T.
Public _lExec  := .F.

Abre()
Atualiz()
Tela(_nTotalNF,_nValMerc)


dbSelectArea(_cAlias)
dbSetOrder(_nIndex)
dbGoTo(_nRecno)


Return

Static Function Tela(_nTotalNF,_nValMerc)



	    		

//DEFINE MSDIALOG oDlg FROM 1,60 TO 200,900 PIXEL TITLE 'Conversใo de valores '
                  
DEFINE MSDIALOG oDlg TITLE "Conversao de Valores " FROM 150,150 TO 550,1150 PIXEL   


//SetKey(VK_F9,{|| })                       
//SetKey(VK_F9,{|| Atualiz()}) 




_lVtela := .T.


	
//oDlg:lEscClose := .F.
	



@10.10,.402 Say "Valor Total da Nota: "+transform(_nTotalNF,"@E 999,999,999.99")

@30.10,.402 Say "Total de Mercadorias: "+transform(_nValMerc,"@E 999,999,999.99")

@160.10,.402 Say "Presione a tecla <ESC> para sair da Tela"
  

DbSelectArea('TRM')  
DbGotop()

oBrowse:=BrGetDDB():New(60,1,500,100,,,,oDlg,,,,,,,,,,,,.F.,"TRM",.T.,,.F.,,,)    

//oBrowse := BrGetDDB():New( 20,1,2800,100,,,,oDlg,,,,,,,,,,,,.F.,'TRM',.T.,,.F.,,, )
oBrowse:AddColumn(TCColumn():New('ITEM',{||TRM->TM_ITEM },,,,'LEFT',,.F.,.F.,,,,.F.,))
oBrowse:AddColumn(TCColumn():New('PRODUTO' ,{||TRM->TM_PRODUTO},,,,'RGHT',,.F.,.F.,,,,.F.,))
oBrowse:AddColumn(TCColumn():New('DESCRI' ,{||TRM->TM_DESCRI},,,,'RGHT',,.F.,.F.,,,,.F.,))
oBrowse:AddColumn(TCColumn():New('UM',{||TRM->TM_UM},,,,'RGHT',,.F.,.F.,,,,.F.,))
oBrowse:AddColumn(TCColumn():New('QTDVEN' ,{||TRM->TM_QTDVEN},"@E 99,999.99999",,,'CENTER',,.F.,.F.,,,,.F.,))
oBrowse:AddColumn(TCColumn():New('PRCVEN' ,{||TRM->TM_PRCVEN},"@E 99,999.99999",,,'CENTER',,.F.,.F.,,,,.F.,)) 
oBrowse:AddColumn(TCColumn():New('VALOR' ,{||TRM->TM_VALOR},"@E 999,999,999.99",,,'CENTER',,.F.,.F.,,,,.F.,))
oBrowse:AddColumn(TCColumn():New('ALIQICM' ,{||TRM->TM_ALIQICM},"@E 99",,,'CENTER',,.F.,.F.,,,,.F.,))
oBrowse:AddColumn(TCColumn():New('ICM' ,{||TRM->TM_VICMS},"@E 99,999,999,999.99",,,'CENTER',,.F.,.F.,,,,.F.,))
oBrowse:AddColumn(TCColumn():New('IPI' ,{||TRM->TM_VIPI},"@E 99,999,999,999.99",,,'CENTER',,.F.,.F.,,,,.F.,))
oBrowse:AddColumn(TCColumn():New('COFINS' ,{||TRM->TM_VCOF},"@E 99,999,999,999.99",,,'CENTER',,.F.,.F.,,,,.F.,))
oBrowse:AddColumn(TCColumn():New('PIS' ,{||TRM->TM_VPIS},"@E 99,999,999,999.99",,,'CENTER',,.F.,.F.,,,,.F.,))

//oBrowse:AddColumn(TCColumn():New("Codigo",{||SA1->A1_COD },"@!",,,"LEFT",,.F.,.F.,,,,,))
ACTIVATE MSDIALOG oDlg CENTERED
TRM->(DbCloseArea())    
_lVer := .F.  
_lVTela := .F. 
_lVini := .F. 
_lExec := .F.
Return NIL          

//SetKey(VK_F9,{|| })
Return 

/*
Static Function  Fecha()

TRM->(DbCloseArea())
_lVer := .F.


Return
*/
                                
Static Function Atualiz()

Local a
Local _l :=  0
Private  oDlg
Private  _cMsgBx := "Rela็ใo de Itens dos Pedidos"
Private _cDesc := ""
Private _cRevi := ""
Private _nQtde := 0
Private _cCalc := 0
Private _cRevE := ""
Private _cVerif := ""
Private _cUnF := ""
Private _cUnP := ""
Private _nQtdPi := 0
Private _cPedido := M->C5_NUM           

Private _cCliente := posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_NOME")
Private _nMoeda := M->C5_MOEDA
Private _nTxref := M->C5_TXREF
Private _nUltpr := 0
Private _nSldEst := 0
Private _aCabec :={}  

Private _nValMod1 := 0
Private _nValMod2 := 0
Private _nValMod3 := 0
Private _nValMod4 := 0
Private _nValor := 0  
Private _nTotal  := 0
Private _nCalcul := 0
Private _nTotMoe := 0
Private _nTotTx := 0 

Private	_nPrvIt := 0
Private _nValorIt := 0
Private nItem := 0         
Private _cVar1 := "Valor Total Itens:  "
Private _nAcmTotN := 0          
Private _nAcmPis := 0 
Private _nAcmCof := 0  
Private _nAlICM  := 0                         

Private _nTotICM  := 0
Private _nTotIPI  := 0
Private _nTotCof  := 0      
Private _nTotPis  := 0   

Private	_cIte 	:= aScan(aHeader,{|x|Alltrim(x[2])=="C6_ITEM"})
Private	_cPro 	:= aScan(aHeader,{|x|Alltrim(x[2])=="C6_PRODUTO"})
Private _cDescr 	:= aScan(aHeader,{|x|Alltrim(x[2])=="C6_DESCRI"}) 
Private _cUM 	:= aScan(aHeader,{|x|Alltrim(x[2])=="C6_UM"})
Private _cTes 	:= aScan(aHeader,{|x|Alltrim(x[2])=="C6_TES"})
Private _nPecVen := aScan(aHeader,{|x|Alltrim(x[2])=="C6_PRCVEN"}) 
Private _nQtdVen := aScan(aHeader,{|x|Alltrim(x[2])=="C6_QTDVEN"}) 
Private _nValorx := aScan(aHeader,{|x|Alltrim(x[2])=="C6_VALOR"}) 
Private _nValDesc := aScan(aHeader,{|x|Alltrim(x[2])=="C6_VALDESC"}) 

If !_lVer 
  
	Abre()                 
  
Endif



IF _nTxref = 0                     
  
        /*
    	cry1 := "Select TOP 1  "
		cry1 += "From "+RetSqlName("SM2")+" SM2 "
		cry1 += "Where SM2.D_E_L_E_T_ <> '*'  AND "
		cry1 += "SM2.M2_DATA <= '" + Dtos(dDataBase) + "' "
		cry1 += "ORDER BY M2_DATA DESC "
		cry1 :=ChangeQuery(cry1)
		dbUseArea(.T., "TOPCONN", TcGenQry(,,cry1),"PXSM2")
		*/
		
		cxry2 := " "
		cxry2 := "Select * "
		cxry2 += "From "+RetSqlName("SM2")+" SM2 "
		cxry2 += "Where SM2.D_E_L_E_T_ <> '*' AND  "
		cxry2 += "SM2.M2_DATA = '" + Dtos(dDataBase) + "' "
		cxry2 += "ORDER BY M2_DATA  "
		cxry2 :=ChangeQuery(cxry2)
		dbUseArea(.T., "TOPCONN", TcGenQry(,,cxry2), "PXSM2")
		
	    DbSelectArea("PXSM2")
	    
	    IF  ! EOF()
	    
	    	
	    	IF _nMoeda = 2 
	    		_nValMod2  := PXSM2->M2_MOEDA2
	    	ELSEIF _nMoeda = 3
	    		_nValMod3  := PXSM2->M2_MOEDA3
	    	ELSEIF  _nMoeda = 4 
	    		_nValMod4  := PXSM2->M2_MOEDA4
	    	Endif     
	    
			//DbSelectArea("PXSM2")
	   		//DbSkip()


		Endif
		PXSM2->(DbCloseArea())

	IF _nMoeda = 2
   		_nTotMoe := _nValMod2
	elseif  _nMoeda = 3
		_nTotMoe := _nValMod3
	ElseIF _nMoeda = 4
		_nTotMoe := _nValMod4
	Endif

Else
	_nTotTx := _nTxref	    
	    
Endif

IF _nTotMoe = 0 .and. _nTotTx = 0  
	Alert ("A o valor da moeda  e a taxa de cambio estใo em branco refente a este item nao esta informado")
Endif	

MaFisIni(M->C5_CLIENTE,M->C5_LOJACLI,,M->C5_TIPO,M->C5_TIPOCLI,MaFisRelImp("MTR700",{"SC5","SC6"}),,,"SB1","RFATC002")
nItem := 0                     
_lExec := .T.

/*
cxry1 := " "      
cxry1 := "Select * "
cxry1 += "From "+RetSqlName("SC6")+" SC6 "
cxry1 += "Where SC6.C6_FILIAL  = '" + xFilial("SC6") + "' AND "
cxry1 += "SC6.C6_NUM  = '" + _cPedido + "' AND "
cxry1 += "SC6.D_E_L_E_T_ <> '*' "
cxry1 += "ORDER BY C6_NUM "
cxry1 :=ChangeQuery(cxry1)                 
dbUseArea(.T., "TOPCONN", TcGenQry(,,cxry1), "pxSC6")

DbselectArea("pxSC6")
*/

_nAcmTotN := 0     
_nPrvIt:= 0      
_nValorIt  := 0


For _l := 1 To Len(aCols)
	
	If !aCols[_l,Len(aHeader)+1] //.or. aCols[_l,nPosQtde] == 0
		
		DbSelectArea("TRM")
	    
	ธ    IF DbSeek(aCols[_l][_cIte]+aCols[_l][_cPro])
	       
	    	RecLock("TRM",.F.)
            DBDelete()
            MsUnlock()
	    
	    Endif
		
        
    Endif


    
Next

//While !EOF()    

For _l := 1 To Len(aCols)
	If !aCols[_l,Len(aHeader)+1] //.or. aCols[_l,nPosQtde] == 0

    	nItem += 1
		
		_nPrvIt    := aCols[_l][_nPecVen] *  _nTotMoe 
		_nValorIt  := aCols[_l][_nQtdVen] *  _nPrvIt 
        
        IF _nTotTx <> 0   
           
        	_nPrvIt:= 0      
        	_nValorIt  := 0
    	   
		   	_nPrvIt    := aCols[_l][_nPecVen] * _nTotTx  
		    _nValorIt  := aCols[_l][_nQtdVen] * _nPrvIt
		
	    Endif                         
	    
		
		MaFisAdd(aCols[_l][_cPro],aCols[_l][_cTes],aCols[_l][_nQtdVen],IIF(_nPrvIt <> 0,_nPrvIt,aCols[_l][_nPecVen]),aCols[_l][_nValDesc],"","",0,0,0,0,0,IIF(_nValorIt <> 0,_nValorIt,aCols[_l][_nValorx])+aCols[_l][_nValDesc],0,0,0)

		_nValcof 	:= IIF(_nValorIt <> 0,_nValorIt,aCols[_l][_nValorx]) * (7.60 / 100)//MaFisRet(nItem,"IT_VALCOF")     // 7,60
		_nValpis    := IIF(_nValorIt <> 0,_nValorIt,aCols[_l][_nValorx]) * (1.65 / 100)//MaFisRet(nItem,"IT_VALPIS")      // 1,65
		_nValIpi 	:= MaFisRet(nItem,"IT_VALIPI")
		_nAlICM     := MaFisRet(nItem,"IT_ALIQICM")
		_nVICM      := MaFisRet(nItem,"IT_VALICM")  
	
		
		
				 
	   //	IT_VALICM
		              
	    
	    DbSelectArea("TRM")
	    
	     IF DbSeek(aCols[_l][_cIte]+aCols[_l][_cPro])
	    
	        RecLock("TRM",.F.)
			TRM->TM_ITEM   := aCols[_l][_cIte]
			TRM->TM_PRODUTO := aCols[_l][_cPro]
			TRM->TM_DESCRI  := aCols[_l][_cDescr]
			TRM->TM_UM   := aCols[_l][_cUM]
			TRM->TM_QTDVEN  := aCols[_l][_nQtdVen]
			TRM->TM_PRCVEN  := IIF(_nPrvIt <> 0,_nPrvIt,aCols[_l][_nPecVen])            
			TRM->TM_VALOR   := IIF(_nValorIt <> 0,_nValorIt,aCols[_l][_nValorx])
			TRM->TM_ALIQICM := 	_nAlICM 
			TRM->TM_VICMS   := _nVICM
			TRM->TM_VIPI    := _nValIpi
			TRM->TM_VCOF    := 	_nValcof
			TRM->TM_VPIS    :=	_nValpis
			MsUnLock()
		
		Else
		
			RecLock("TRM",.T.)
			TRM->TM_ITEM   := aCols[_l][_cIte]
			TRM->TM_PRODUTO := aCols[_l][_cPro]
			TRM->TM_DESCRI  := aCols[_l][_cDescr]
			TRM->TM_UM   := aCols[_l][_cUM]
			TRM->TM_QTDVEN  := aCols[_l][_nQtdVen]
			TRM->TM_PRCVEN  := IIF(_nPrvIt <> 0,_nPrvIt,aCols[_l][_nPecVen])            
			TRM->TM_VALOR   := IIF(_nValorIt <> 0,_nValorIt,aCols[_l][_nValorx])
			TRM->TM_ALIQICM := 	_nAlICM 
			TRM->TM_VICMS   := _nVICM
			TRM->TM_VIPI    := _nValIpi
			TRM->TM_VCOF    := 	_nValcof
			TRM->TM_VPIS    :=	_nValpis
			MsUnLock()
		    
		
		
		
		Endif
		    
		_nAcmTotN :=  _nAcmTotN + IIF(_nValorIt <> 0,_nValorIt,aCols[_l][_nValorx])
	
			        
    
    Endif    


Next    
	
  //	DbselectArea("pxSC6")
  //	DbSkip()
	
	
//Enddo
//pxSC6->(DbCloseArea())
        
_nTotalNF   := MaFisRet(,"NF_TOTAL") 
_nValMerc   := MaFisRet(,"NF_VALMERC") 
_nTotICM    := MaFisRet(,"NF_VALICM")  
_nTotIPI    := MaFisRet(,"NF_VALIPI")
_nTotCof    := MaFisRet(,"NF_VALCOF")        
_nTotPis    := MaFisRet(,"NF_VALPIS") 



//Encerro o MaFis()
MaFisEnd()   





Return

Static Function Abre()


_lVer := .T.
_aStru1 := {} 
AADD(_aStru1,{"TM_ITEM" 	,"C",02,0})
AADD(_aStru1,{"TM_PRODUTO"	,"C",15,0})
AADD(_aStru1,{"TM_DESCRI"   ,"C",60,0})
AADD(_aStru1,{"TM_UM"       ,"C",02,0})
AADD(_aStru1,{"TM_QTDVEN"  	,"N",11,5})
AADD(_aStru1,{"TM_PRCVEN"  	,"N",11,5})
AADD(_aStru1,{"TM_VALOR"  	,"N",12,2})     
AADD(_aStru1,{"TM_ALIQICM" 	,"N",02,0})   //                  
AADD(_aStru1,{"TM_VICMS"  	,"N",14,2})   //@E 99,999,999,999.99                         
AADD(_aStru1,{"TM_VIPI"  	,"N",14,2})   //@E 99,999,999,999.99                         
AADD(_aStru1,{"TM_VCOF"  	,"N",14,2})   //@E 99,999,999,999.99                         
AADD(_aStru1,{"TM_VPIS"  	,"N",14,2})   //@E 99,999,999,999.99                         



_cArq1 := CriaTRAb(_aStru1,.T.)
dbUseArea(.T.,,_cArq1,"TRM",.F.,.F.)
IndRegua("TRM",_cArq1,"TM_ITEM + TM_PRODUTO",,,"Criando Arquivo Temporario")



Return