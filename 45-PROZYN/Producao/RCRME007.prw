#INCLUDE 'RWMAKE.CH'
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'DBTREE.CH'
#INCLUDE 'HBUTTON.CH'

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao	 � RCRME007 � Autor � Adriano Leonardo    � Data � 10/10/2016 ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina para retornar o pre�o de venda do produto, para ser ���
���          � considerado na rotina de forecast.                         ���
�������������������������������������������������������������������������͹��
���Uso       � Espec�fico para a empresa Prozyn               			  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

User Function RCRME007(_cCodCli,_cLojaCli,_cCodProd,_cAno,_cNet, cMoeda)

Local _aSavArea		:= GetArea()
Local _aSavSZC		:= SZC->(GetArea())
Local _nTaxa		:= 1
Local _cEnter		:= CHR(13) + CHR(10)
Default _cCodCli	:= ""
Default _cLojaCli	:= ""
Default _cCodProd	:= ""
Default _cAno		:= StrZero(Year(dDataBase),4)
Default cMoeda		:= "1"
Private _cCliente	:= _cCodCli
Private _cLoja		:= _cLojaCli
Private _cProduto 	:= _cCodProd
Private _cAnoBase	:= _cAno

//Verifico o pre�o de venda do produto na tabela de pre�o do cliente
_cQryPrc	:= "SELECT TOP 1 DA1.DA1_PRCVEN,DA1.DA1_PRNET,DA1_MOEDA FROM " + RetSqlName("DA1") + " DA1 WITH (NOLOCK) " + _cEnter
_cQryPrc	+= "WHERE DA1.D_E_L_E_T_='' " + _cEnter
_cQryPrc	+= "AND DA1.DA1_FILIAL='" + xFilial("DA1") + "' " + _cEnter
_cQryPrc	+= "AND DA1.DA1_CODTAB= " + _cEnter
_cQryPrc	+= "	( " + _cEnter
_cQryPrc	+= "		SELECT A1_TABELA FROM " + RetSqlName("SA1") + " SA1 WITH (NOLOCK) " + _cEnter
_cQryPrc	+= "		WHERE SA1.D_E_L_E_T_='' " + _cEnter
_cQryPrc	+= "		AND SA1.A1_FILIAL='" + xFilial("SA1") + "' " + _cEnter
_cQryPrc	+= "		AND SA1.A1_COD='" + _cCliente + "' " + _cEnter
_cQryPrc	+= "		AND SA1.A1_LOJA='" + _cLoja + "' " + _cEnter
_cQryPrc	+= "	) " + _cEnter
_cQryPrc	+= "AND DA1.DA1_CODPRO='" + _cProduto + "' " + _cEnter
_cQryPrc	+= "AND DA1.DA1_DATVIG<" + DTOS(dDataBase) + " " + _cEnter
_cQryPrc	+= "ORDER BY DA1_DATVIG, DA1.DA1_QTDLOT " + _cEnter

_cAliasPr := GetNextAlias()  
memowrite(_cProduto+'.txt',_cQryPrc)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQryPrc),_cAliasPr,.T.,.F.)

dbSelectArea(_cAliasPr)

IF _cNet == '2'
	If (_cAliasPr)->(!EOF())
		_nPrcVen	:= (_cAliasPr)->DA1_PRCVEN
		_nMoeda		:= (_cAliasPr)->DA1_MOEDA
	Else
		_nPrcVen	:= 0
		_nMoeda		:= 1
	EndIf
else
	If (_cAliasPr)->(!EOF())
		_nPrcVen	:= (_cAliasPr)->DA1_PRNET
		_nMoeda		:= (_cAliasPr)->DA1_MOEDA
	Else
		_nPrcVen	:= 0
		_nMoeda		:= 1
	EndIf
endif

(_cAliasPr)->(dbCloseArea())

If _nMoeda <> 1 .or. cMoeda == '2'

	//Verifico a taxa do forecast definida para a moeda no ano definido
	dbSelectArea("SZC")
	dbSetOrder(2) //Filial + Ano Base + Moeda
	If dbSeek(xFilial("SZC") + "F"+_cAnoBase + Iif(cMoeda == '2',cMoeda,AllTrim(Str(_nMoeda))))
		_nTaxa := SZC->ZC_TAXA
	Else
		_nTaxa := 1
	EndIf
EndIf


If cValtoChar(_nMoeda) == cMoeda
	_nTaxa := 1
EndIf

If cMoeda == '1'
	nValor := Round(_nPrcVen*_nTaxa,2)
ElseIf cMoeda == '2'
	nValor := Round(_nPrcVen/_nTaxa,2)
EndIf

//Restauro a �rea de trabalho original
RestArea(_aSavSZC)
RestArea(_aSavArea)

Return nValor
