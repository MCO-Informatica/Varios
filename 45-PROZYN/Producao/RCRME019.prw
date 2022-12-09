
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'DBTREE.CH'
#INCLUDE 'HBUTTON.CH'

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³ RCRME019 ³ Autor ³ DanielPaulo Nbridge³  Data ³ 30/11/2018 ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina para retornar o preço de venda do produto, para ser º±±
±±º          ³ considerado na rotina de forecast. (Dólar)                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Específico para a empresa Prozyn               			  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function RCRME019(_cCodCli,_cLojaCli,_cCodProd,_cAno,_cNet)

Local _aSavArea		:= GetArea()
Local _aSavSZC		:= SZC->(GetArea())
Local _nTaxa		:= 1
Local _cEnter		:= CHR(13) + CHR(10)
Default _cCodCli	:= ""
Default _cLojaCli	:= ""
Default _cCodProd	:= ""
Default _cAno		:= StrZero(Year(dDataBase),4)
Private _cCliente	:= _cCodCli
Private _cLoja		:= _cLojaCli
Private _cProduto 	:= _cCodProd
Private _cAnoBase	:= _cAno

//Verifico o preço de venda do produto na tabela de preço do cliente
_cQryPrc	:= "SELECT TOP 1 DA1.DA1_PRCVEN, DA1.DA1_PRNET, DA1_MOEDA FROM " + RetSqlName("DA1") + " DA1 WITH (NOLOCK) " + _cEnter
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

if _cNet=='2'
	
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
Endif



dbSelectArea(_cAliasPr)
dbCloseArea()

If _nMoeda == 1

	//Verifico a taxa do forecast definida para a moeda no ano definido
	dbSelectArea("SZC")
	dbSetOrder(2) //Filial + Ano Base + Moeda
	If dbSeek(xFilial("SZC") + "F"+_cAnoBase + "2")
		_nTaxa := SZC->ZC_TAXA
	Else	
		_nTaxa := 0
	EndIf  
EndIf

If _nMoeda == 4

	//Verifico a taxa do forecast definida para a moeda no ano definido
	dbSelectArea("SZC")
	dbSetOrder(2) //Filial + Ano Base + Moeda
	If dbSeek(xFilial("SZC") +"F"+ _cAnoBase + "4")
		_nTaxa := SZC->ZC_TAXA
	Else	
		_nTaxa := 0
	EndIf  
EndIf

//Restauro a área de trabalho original
RestArea(_aSavSZC)
RestArea(_aSavArea)

Return(Round(_nPrcVen/_nTaxa,2))

