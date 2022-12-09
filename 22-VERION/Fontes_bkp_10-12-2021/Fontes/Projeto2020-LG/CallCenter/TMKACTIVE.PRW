#include "protheus.ch"
#INCLUDE "TOPCONN.CH"
#include "TOTVS.CH"

//---------------------------------------------------------------------//
//							ADVTEC - YURI PORTO						   //
//---------------------------------------------------------------------//
//			PROGRAMA PARA ATUALIZAÇÃO DE VALORES ENTRE				   //
//						B1_VAL1 PARA B1_VLBASE                         //
//	QUE ABASTECE OS CAMPOS, SB1->B1_VAL1,SB1->B1_VAL2,SB1->B1_VAL      //
//         			  ATUALIZA O PREÇO DE VENDA                        //
//                       CONFORME O TIPO = PC E KT                     //
//---------------------------------------------------------------------//
//							   11/09/2013							   //
//---------------------------------------------------------------------//

user function APRECO()

Private _cCODIGO:= ""
Private _nVALOR := 0
PRIVATE _VAL1
PRIVATE CQUERY
PRIVATE _DOLAR
PRIVATE _EURO

MSGALERT ("INICIANDO ATUALIZAÇÃO")

//----------------------------------------------------------------------------------PEGA COTAÇÃO DA MOEDA E ABASTECE VARIAVEIS
CQUERY1	:=	"SELECT TOP(1)M2_MOEDA2, M2_MOEDA4"
CQUERY1	+=	"	FROM SM2020"
CQUERY1	+=	"	WHERE SM2020.D_E_L_E_T_ = '' "
CQUERY1	+=	"	ORDER BY M2_DATA DESC"
TCQUERY CQUERY1 NEW ALIAS "TTO"
Dbselectarea("TTO")
_DOLAR := TTO->M2_MOEDA2
_EURO  := TTO->M2_MOEDA4
TTO->(DBCLOSEAREA())

DBSELECTAREA("SB1")
DBGOTOP()
DBSETORDER(1)

WHILE !EOF()
	
	_cCODIGO := SB1->B1_COD
	
	//-----------------------------------------------------CASO SEJA KIT
	IF SB1->B1_UM = 'KT'
		
		CQUERY	:=	"SELECT SUM(B1_VAL1) AS _VAL1 "
		CQUERY	+=	"	FROM SG1020, SB1020 "
		CQUERY	+=	"	WHERE G1_COD = '"+_cCODIGO+"' "
		CQUERY	+=	"	AND G1_COMP = B1_COD "
		CQUERY	+=	"	AND SG1020.D_E_L_E_T_ = '' "
		CQUERY	+=	"	AND SB1020.D_E_L_E_T_ = '' "
		
		MEMOWRIT("RFAT02.SQL", CQUERY)
		TCQUERY CQUERY NEW ALIAS "TTX"
		Dbselectarea("TTX")
		_nVALOR := TTX->_VAL1
		TTX->(DBCLOSEAREA())
		
		dbSelectArea("SB1")
		dbSetOrder(1)
		Dbseek(Xfilial("SB1") + _cCODIGO)
		_NVALOR:= SB1->B1_VAL1
		
		//-----------------------------------------------------------------CONVERSÃO MOEDA
		IF SB1->B1_TPMOEDA="D"
			_NValor := _NValor*_DOLAR
		ELSEIF SB1->B1_TPMOEDA="E"
			_NValor := _NValor*_EURO
		ELSE
			_NValor := _NValor
		ENDIF
		RECLOCK("SB1",.F.)
		SB1->B1_VLBASE:= _nVALOR
		MSUNLOCK()
		
		//------------------------------------------------------------------------------------QUALQUER TIPO QUE NÃO SEJA KIT
		
	ELSE
		
		dbSelectArea("SB1")
		dbSetOrder(1)
		Dbseek(Xfilial("SB1") + SB1->B1_COD)
		
		
		//-----------------------------------------------------------------CONVERSÃO MOEDA
		IF SB1->B1_TPMOEDA="D"
			_NValor := _NValor*_DOLAR
		ELSEIF SB1->B1_TPMOEDA="E"
			_NValor := _NValor*_EURO
		ELSE
			_NValor := _NValor
		ENDIF
		
		RECLOCK("SB1",.F.)
		SB1->B1_VLBASE:= _NVALOR
		MSUNLOCK()
		
		
		
	ENDIF
	_nvalor:=0
	dbskip()
END
SB1->(dbclosearea())
MSGALERT("VALORES ATUALIZADOS COM SUCESSO")

Return
