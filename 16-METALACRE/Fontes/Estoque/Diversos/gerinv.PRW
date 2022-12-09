#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"                                                                                                         
#INCLUDE "COLORS.CH"     
#INCLUDE "RWMAKE.CH"
#include "TbiConn.ch"
#include "TbiCode.ch"   
//--------------------------------------------------------------
/*/{Protheus.doc} HISTCLI
Description

@param xParam Parameter Description
@return xRet Return Description
@author  -
@since 06/11/2012
/*/
//--------------------------------------------------------------
User Function Ger_INV()  

PutSx1("GER_INV","01","Produto de"			,"TES Entrada"			,"TES Entrada"			,"mv_ch1","C",30,0,0,"G","","SB1","","mv_par01","","","","","","","","","","","","","","","","",{},{},{})
PutSx1("GER_INV","02","Produto Ate"			,"TES Entrada"			,"TES Entrada"			,"mv_ch2","C",30,0,0,"G","","SB1","","mv_par02","","","","","","","","","","","","","","","","",{},{},{})
PutSx1("GER_INV","03","Armazem"			,"Amarra NF Origem"		,"Amarra NF Origem"		,"mv_ch3","C",02,0,0,"G","","","","","mv_par03","","","","","","","","","","","","","","","","",{},{},{})

If !Pergunte("GER_INV",.T.)
	Return .f.
Endif



CQRY := "SELECT * FROM " + RetSqlName("SB8")+" B8 WHERE B8_FILIAL = '" + xFilial("SB8") + "' AND D_E_L_E_T_ = '' AND B8_PRODUTO BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' AND B8_SALDO > 0 AND B8_LOCAL = '" + MV_PAR03 + "' "

DbUseArea( .t.		, "TOPCONN"		, TcGenQry(,, cQry), 'TMP2' )

TCSetField("TMP2","B8_DTVALID","D")                                                               


dbSelectArea('TMP2')
dbGoTop()
While TMP2->(!Eof())
	SB1->(dbSetOrder(1), dbSeek(xFilial("SB1")+TMP2->B8_PRODUTO))
	If !SB7->(dbSetOrder(2), dbSeek(xFilial("SB7")+TMP2->B8_NUMLOTE+TMP2->B8_LOTECTL+TMP2->B8_PRODUTO+TMP2->B8_LOCAL))
		If RecLock("SB7",.t.)
	        SB7->B7_FILIAL	:= xFilial("SB7")
	        SB7->B7_COD		:= TMP2->B8_PRODUTO
	        SB7->B7_LOCAL	:= TMP2->B8_LOCAL
	        SB7->B7_TIPO	:= SB1->B1_TIPO
	        SB7->B7_DOC		:= DtoS(dDataBase)
	        SB7->B7_QUANT	:= 0.00 //TMP2->B8_SALDO
	        SB7->B7_DATA	:= dDataBase
	        SB7->B7_NUMDOC	:= TMP2->B8_DOC
	        SB7->B7_LOTECTL	:= TMP2->B8_LOTECTL
	        SB7->B7_NUMLOTE := TMP2->B8_NUMLOTE    
	        SB7->B7_DTVALID	:= TMP2->B8_DTVALID
	        MsUnLock()
	 	Endif
 	Endif
 	
 	TMP2->(dbSkip(1))
Enddo
TMP2->(dbCloseArea())
Return 
 