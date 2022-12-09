#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"   
/**
* Rotina		:	MT110TEL
* Autor			:	Pedro Augusto
* Data			:	31/08/2015
* Descricao		:	Rotina Adicionar novos campos personalizados na solicitacao de Compras 
* Uso           :   RENOVA ENERGIA
*/
User function MT110TEL()      
Local oNewDialog := PARAMIXB[1]
Local aPosGet    := PARAMIXB[2]
Local nOpcx      := PARAMIXB[3]
Local _oAprovSC 
Local nPosQtd    := Ascan(aHeader,{|x| Alltrim(x[2]) == "C1_QUANT"})
Local nPosVal    := Ascan(aHeader,{|x| Alltrim(x[2]) == "C1_VLESTIM"})

Public _oTotalSC                   
Public _cAprovSC  := Space(6) 
Public _nTotalSC  := 0                  

If nOpcx == 3 //.or. nOpcx == 4 // inclui ou copia
	_cAprovSC  := Space(6) 
	_nTotalSC  := 0
Else
	_cAprovSC  := SC1->C1_XAPROV  
	 CUNIDREQ  := SC1->C1_UNIDREQ
	_nTotalSC  := SC1->C1_XTOTSC
EndIf
                                 
@ 43,aPosGet[2,1]+100 SAY OemToAnsi("Gestor U.Req") of oNewDialog PIXEL	

@ 43,aPosGet[2,2]+80 MSGET _oAprovSC VAR _cAprovSC F3 CpoRetF3("Y3_XAPROSC") ;
				  Picture PesqPict("SY3","Y3_XAPROSC")	;
                  Valid CheckSX3('Y3_XAPROSC',_cAprovSC)  ;
				  when (nOpcx == 3 .or. nOpcx == 4 .or. nOpcx == 6) ;
				  Of oNewDialog PIXEL SIZE 050,006 HASBUTTON

@ 44,aPosGet[2,3]+150 SAY OemToAnsi("Total SC") of oNewDialog PIXEL	

@ 43,aPosGet[2,4]+85 MSGET _oTotalSC VAR _nTotalSC ;
				  Picture PesqPict("SC1","C1_XTOTSC")	;   
				  Valid CheckSX3('C1_XTOTSC',_nTotalSC)  ;
				  when .f. ;//(nOpcx == 3 .or. nOpcx == 4 .or. nOpcx == 6) ;
				  Of oNewDialog PIXEL SIZE 050,006 HASBUTTON  


_nToSc := 0
_nTotalSC := 0
For _nToSc := 1 to len(aCols)
	If	! aCols[ _nToSc,(Len(aHeader)+1) ] // Se for deletado
		_nTotalSC += aCols[_nToSc,nPosQtd] * aCols[_nToSc,nPosVal]
	EndIf
Next _nToSc  

_oAprovSC:Refresh()      
_oTotalSC:Refresh()

RETURN                                                                 
