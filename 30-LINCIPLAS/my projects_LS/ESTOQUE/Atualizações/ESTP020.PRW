#INCLUDE "RWMAKE.CH"
#INCLUDE "COLORS.CH"  
#INCLUDE "TBICONN.CH"  
#INCLUDE "TOPCONN.CH" 


User Function ESTP020()

Private _nCont	:= 0

cQry := " SELECT D2_FILIAL, D2_COD, MOVIMENTACAO - VENDA AS 'DIF' FROM T121211 ORDER BY D2_FILIAL "
TcQuery cQry NEW ALIAS "TMP"

_cFil := cFilAnt

DbSelectArea("TMP")
While TMP->( !Eof() )
                                                    
	If TMP->DIF > 0
		Estorna( TMP->D2_FILIAL, TMP->D2_COD, TMP->DIF )     		
	EndIf	
	
	TMP->( DbSkip() )

EndDo

MsgStop(Str(_nCont))

cFilAnt := _cFil

TMP->( DbCloseArea() )

If _nCont > 0
	MsgInfo("Processamento efetuado com sucesso!")
Else
	MsgStop("Nao existem registros para processamento!")
EndIf

Return

Static Function Estorna( _cFili, _cCod, _nDif  )

Local aArea		:= GetArea()		
Local _aVetSD3	:= {}
Private lMsErroAuto	:= .F.

cFilAnt := _cFili

cQryP := " SELECT D3_TM, D3_COD, D3_UM, D3_QUANT, D3_OP, D3_LOCAL, D3_DOC, D3_EMISSAO, D3_PARCTOT "
cQryP += " FROM "+RetSqlName("SD3")+" SD3(NOLOCK) "
cQryP += " WHERE "
cQryP += " D3_FILIAL = '"+_cFili+"' AND D3_COD = '"+_cCod+"' AND D3_CF = 'PR0' AND D3_ESTORNO <> 'S' AND SD3.D_E_L_E_T_ = '' "
cQryP += " ORDER BY D3_QUANT "
TcQuery cQryP NEW ALIAS "TMPR"

_nSaldo := _nDif

DbSelectArea("TMPR")
While TMPR->( !Eof() ) 

	If _nSaldo > 0

		If _nSaldo >= TMPR->D3_QUANT
			_nQtd := TMPR->D3_QUANT			
		Else	
			_nQtd := _nSaldo
		EndIf	
		
		_nSaldo -= _nQtd
		
		_aVetSD3 :={{"D3_TM",TMPR->D3_TM	,NIL},;
		{"D3_COD"		,	TMPR->D3_COD	,NIL},;			
		{"D3_UM"		,	TMPR->D3_UM		,NIL},;
		{"D3_QUANT"		,	_nQtd			,NIL},;
		{"D3_OP"		,	TMPR->D3_OP		,NIL},;		
		{"D3_LOCAL"		,	TMPR->D3_LOCAL	,NIL},;
		{"D3_DOC"		,	TMPR->D3_DOC	,NIL},;
		{"D3_EMISSAO"	,	TMPR->D3_EMISSAO,NIL},;
		{"D3_PARCTOT"	,	"T"				,NIL}}	
	
		MSExecAuto({|x,y| MATA250(x,y)},_aVetSD3,5)	
	
		If lMsErroAuto
			MostraErro()
		Else
			_nCont++
		EndIf
		
	EndIf	
	    
	TMPR->( DbSkip() )
		
EndDo	

TMPR->( DbCloseArea() )

RestArea( aArea )

Return