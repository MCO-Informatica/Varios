#INCLUDE "rwmake.ch"
/*
�������������������������������������������������������������������������ͻ��
���Programa  �NOVO2     � Autor � AP6 IDE            � Data �  03/10/05   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP6 IDE.                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
*/
User Function Prcalc1()
Local _aArea :=	GetArea()
Local _CVLN  := 0

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
Private cString := "SUB"
_nqtd := 0
_nprc := 0
_nvlr := 0
_NDSC := 0

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
dbSelectArea("SB1")
dbSetOrder(1)
dbSelectArea("SBM")
dbSetOrder(1)
dbSelectArea("SZ1")
dbSetOrder(1)
dbSelectArea("SC6")
dbSetOrder(1)
dbSelectArea("SA1")
dbSetOrder(1)
dbSelectArea("SM2")
dbSetOrder(1)
dbSelectArea("SC5")
dbSetOrder(1)

_WCLIENTE := M->UA_CLIENTE
_WLOJACLI := M->UA_LOJA
// _WDATA    := M->UA_EMISSAO
_WDATA       := dDataBase
M->UA_XDTALT := dDataBase
_nPosProd    := ascan(aHeader,{|_vAux|alltrim(_vAux[2])=="UB_PRODUTO"})
_nPosEmissao := ascan(aHeader,{|_vAux|alltrim(_vAux[2])=="UB_EMISSAO"})
_WPROD       := acols[N,_nPosProd]

// cabec do orcamento call center
dbSelectArea("SUA")
dbSetOrder(1)
if dbSeek(xfilial("SUA")+ M->UA_NUM)
	IF RecLock( "SUA" , .F. )
		SUA->UA_XDTALT        := dDataBase
		M->UB_EMISSAO         := dDataBase
		acols[N,_nPosEmissao] := dDataBase
		MsUnLock("SUA")
	Endif
else
	SUA->(dbGoTop())
endif

dbSelectArea("SM2")
dbSeek(_WDATA)
_WDOLAR := SM2->M2_MOEDA2
_WEURO  := SM2->M2_MOEDA4
_WLIBRA := SM2->M2_MOEDA6
_WTXDES :=  ((SM2->M2_TXDESP+100)/100)

dbSelectArea("SB1")
dbSeek(xfilial()+_WPROD)
_WPRECO   := SB1->B1_VERVEN
_WTIPICMS := SB1->B1_TIPICMS
_WMOEDA   := SB1->B1_TPMOEDA
_WFATOR   := SB1->B1_FATOR
//_WPRECO1  := SB1->B1_VERCOM
_WPRECO1  := IIF(SB1->B1_VERCOM > 0,SB1->B1_VERCOM,IIF(SB1->B1_CUSTD > 0,SB1->B1_CUSTD,IIF(SB1->B1_UPRC > 0,SB1->B1_UPRC,0)))
_WGRUPO   := SB1->B1_GRUPO
_cORI     := SB1->B1_ORIGEM
_cGRPTRI  := SA1->A1_GRPTRIB
_CTPESTRU := SB1->B1_ESTRUT

dbSelectArea("SBM")
dbSeek(xFilial()+_WGRUPO)
IF _WFATOR == 0
	_WFATOR := SBM->BM_FATOR
Endif

dbSelectArea("SA1")
dbSeek(xfilial()+_WCLIENTE+_WLOJACLI)
//	_WEST     := SA1->A1_EST CAVALINI
_WEST     := M->UA_VREST
_WPERCENT := 0

dbSelectArea("SZ1")
dbSeek(xfilial()+_WTIPICMS)

IF _cGRPTRI = "503"
	_WEST = 'SP'
ENDIF         

IF	_WEST # 'SP' .and. _cORI = "1"
	_WPERCENT :=  SZ1->Z1_IMP
ELSEIF     _WEST == 'AC'
	_WPERCENT := SZ1->Z1_AC
ELSEIF _WEST == 'AL'
	_WPERCENT := SZ1->Z1_AL
ELSEIF _WEST == 'AM'
	_WPERCENT := SZ1->Z1_AM
ELSEIF _WEST == 'AP'
	_WPERCENT := SZ1->Z1_AP
ELSEIF _WEST == 'BA'
	_WPERCENT := SZ1->Z1_BA
ELSEIF _WEST == 'CE'
	_WPERCENT := SZ1->Z1_CE
ELSEIF _WEST == 'DF'
	_WPERCENT := SZ1->Z1_DF
ELSEIF _WEST == 'ES'
	_WPERCENT := SZ1->Z1_ES
ELSEIF _WEST == 'FN'
	_WPERCENT := SZ1->Z1_FN
ELSEIF _WEST == 'GO'
	_WPERCENT := SZ1->Z1_GO
ELSEIF _WEST == 'MA'
	_WPERCENT := SZ1->Z1_MA
ELSEIF _WEST == 'MG'
	_WPERCENT := SZ1->Z1_MG
ELSEIF _WEST == 'MS'
	_WPERCENT := SZ1->Z1_MS
ELSEIF _WEST == 'MT'
	_WPERCENT := SZ1->Z1_MT
ELSEIF _WEST == 'PA'
	_WPERCENT := SZ1->Z1_PA
ELSEIF _WEST == 'PB'
	_WPERCENT := SZ1->Z1_PB
ELSEIF _WEST == 'PE'
	_WPERCENT := SZ1->Z1_PE
ELSEIF _WEST == 'PI'
	_WPERCENT := SZ1->Z1_PI
ELSEIF _WEST == 'PR'
	_WPERCENT := SZ1->Z1_PR
ELSEIF _WEST == 'RJ'
	_WPERCENT := SZ1->Z1_RJ
ELSEIF _WEST == 'RN'
	_WPERCENT := SZ1->Z1_RN
ELSEIF _WEST == 'RO'
	_WPERCENT := SZ1->Z1_RO
ELSEIF _WEST == 'RR'
	_WPERCENT := SZ1->Z1_RR
ELSEIF _WEST == 'RS'
	_WPERCENT := SZ1->Z1_RS
ELSEIF _WEST == 'SC'
	_WPERCENT := SZ1->Z1_SC
ELSEIF _WEST == 'SE'
	_WPERCENT := SZ1->Z1_SE
ELSEIF _WEST == 'SP'
	_WPERCENT := SZ1->Z1_SP
ELSEIF _WEST == 'TO'
	_WPERCENT := SZ1->Z1_TO
ELSEIF _WEST == 'XX'
	_WPERCENT := SZ1->Z1_XX
ELSEIF _WEST == 'EX'
	_WPERCENT := SZ1->Z1_EX
ENDIF

_WPERCENT := (100 - _WPERCENT) / 100

If _WMOEDA == space(1)
	_WMOEDA := SBM->BM_MOEDA
	IF _WMOEDA == "D"
		_WAA1 := Round( (_WPRECO1 * _WFATOR) ,2)
		_WAA  := Round( ((_WAA1   * _WDOLAR) / _WPERCENT ) * _WTXDES ,2)
	ELSEIF _WMOEDA == "E"
		_WAA1 := Round( (_WPRECO1 * _WFATOR) ,2)
		_WAA  := Round( ((_WAA1   * _WEURO)  / _WPERCENT ) * _WTXDES ,2)
	ELSEIF _WMOEDA == "L"
		_WAA1 := Round( (_WPRECO1 * _WFATOR) ,2)
		_WAA  := Round( ((_WAA1   * _WLIBRA)  / _WPERCENT ) * _WTXDES ,2) // vlr venda
	ELSE
		_WAA1 := Round( (_WPRECO1 * _WFATOR) ,2)
		_WAA  := Round( ((_WAA1)  / _WPERCENT ) * _WTXDES ,2)
	ENDIF
ELSE
	IF _WMOEDA == "D"
		_WAA := Round( (((_WPRECO1 * _WFATOR) * _WDOLAR) / _WPERCENT ) * _WTXDES ,2)
	ELSEIF _WMOEDA == "E"
		_WAA := Round( (((_WPRECO1 * _WFATOR) * _WEURO ) / _WPERCENT ) * _WTXDES ,2)
	ELSEIF _WMOEDA == "L"
		_WAA  := Round((((_WPRECO1 * _WFATOR) * _WLIBRA)  / _WPERCENT ) * _WTXDES ,2) // vlr venda
	ELSE
		_WAA := Round( (((_WPRECO1 * _WFATOR) ) / _WPERCENT ) * _WTXDES ,2)
	ENDIF
ENDIF
                           
IF SUBSTR(_WGRUPO,1,2) $ "VB|Y-" .AND. SB1->B1_ESTRUT $ "1|2"
      _WAA := Round( (SB1->B1_VERCOM / _WPERCENT ),2)
ENDIF

_nPosProd := ascan(aHeader,{|_vAux|alltrim(_vAux[2])=="UB_PRODUTO"})
_nPosQTD  := ascan(aHeader,{|_vAux|alltrim(_vAux[2])=="UB_QUANT"})
_nPosPrC  := ascan(aHeader,{|_vAux|alltrim(_vAux[2])=="UB_VRUNIT"})
_nPosVLR  := ascan(aHeader,{|_vAux|alltrim(_vAux[2])=="UB_VLRITEM"})
_nPosDSC  := ascan(aHeader,{|_vAux|alltrim(_vAux[2])=="UB_VRDESC"})
_nPosVLDC := ascan(aHeader,{|_vAux|alltrim(_vAux[2])=="UB_VRVLRDE"})
_nqtd     := acols[n,_nPosQTD]
_NDSC     := acols[n,_nPosPrC]
_CVLN     := Round( ((1-(_NDSC/_WAA))*100) ,6)

RestArea(_aArea)
Return (_CVLN)