#include "rwmake.ch"
#include "protheus.ch"

/*
+===========================================================================+
|===========================================================================|
|Programa: A415LIOK     | Tipo: Ponto de Entrada      |  Data: 07/01/2015   |
|===========================================================================|
|Programador: Caio Garcia - Global Gcs                                      |
|===========================================================================|
|Utilidade: Calcula e salvo o valor, base e porcentagem do ICMS Retido.     |
|                                                                           |
|===========================================================================|
|--------------------------------Alterações---------------------------------|
|===========================================================================|
|                                                                           |
+===========================================================================+
*/
User Function A415LIOK()
Local _lRet		:= .T.
Local _cTipoCli := ""
Local aAreas	:= {SCJ->(GetArea()), SCK->(GetArea()), TMP1->(GetArea()), SA1->(GetArea()), SB1->(GetArea()), GetArea()}
Local nPrcven 	:= Iif(M->CJ_XNIVEL == "2" , TMP1->CK_PRCVEN/2, TMP1->CK_PRCVEN)

Private aImp     := {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}

_cTipoCli := Posicione("SA1",1,xFilial("SA1")+M->CJ_CLIENTE+M->CJ_LOJA,"A1_TIPO")

//Carrega a MATXFIS para pegar os valores dos impostos
fCalcImp(M->CJ_CLIENTE,M->CJ_LOJA,_cTipoCli,TMP1->CK_PRODUTO,TMP1->CK_TES,TMP1->CK_QTDVEN, nPrcven, nPrcven*TMP1->CK_QTDVEN)

TMP1->CK_XVLRIPI	:= aImp[05]
// TMP1->CK_XBASRET 	:= aImp[14]
TMP1->CK_XICMSRE	:= aImp[16]
TMP1->CK_XVLRTOT	:= TMP1->(CK_VALOR+CK_XVLRIPI+CK_XICMSRE)

aEval(aAreas, {|x| RestArea(x) })	

Return _lRet

/*
+===========================================================================+
|===========================================================================|
|Programa: fCalcImp     | Tipo: Função                |  Data: 14/08/2014   |
|===========================================================================|
|Programador: Caio Garcia - Global Gcs                                      |
|===========================================================================|
|Utilidade: Calcula impostos por item do orçamento.                         |
|===========================================================================|
*/
Static Function fCalcImp(cCliente,cLoja,cTipo,cProduto,cTes,nQtd,nPrc,nValor)

aImp := {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}

// -------------------------------------------------------------------
// Realiza os calculos necessários
// -------------------------------------------------------------------
MaFisIni(	cCliente,;                             // 1-Codigo Cliente/Fornecedor
			cLoja,;                                // 2-Loja do Cliente/Fornecedor
			"C",;                                  // 3-C:Cliente , F:Fornecedor
			"N",;                                  // 4-Tipo da NF
			cTipo,;                                // 5-Tipo do Cliente/Fornecedor
			MaFisRelImp("MTR700",{"SCJ","SCK"}),;  // 6-Relacao de Impostos que suportados no arquivo
			,;                                     // 7-Tipo de complemento
			,;                                     // 8-Permite Incluir Impostos no Rodape .T./.F.
			"SB1",;                                // 9-Alias do Cadastro de Produtos - ("SBI" P/ Front Loja)
			"MTR700")                              // 10-Nome da rotina que esta utilizando a funcao

// -------------------------------------------------------------------
// Monta o retorno para a MaFisRet
// -------------------------------------------------------------------
MaFisAdd(cProduto, cTes, nQtd, nPrc, 0, "", "",, 0, 0, 0, 0, nValor,;			// 13-Valor da Mercadoria ( Obrigatorio )
		 0,;					// 14-Valor da Embalagem ( Opiconal )
		 , , , , , , , , , , , , ,;
		 TMP1->CK_CLASFIS) // 28-Classificacao fiscal)

//Monta um array com os valores necessários

aImp[1] := cProduto
aImp[2] := cTes
aImp[3] := MaFisRet(01	,"IT_ALIQICM")  //Aliquota ICMS
aImp[4] := MaFisRet(01	,"IT_VALICM")  //Valor de ICMS
aImp[5] := MaFisRet(01	,"IT_VALIPI")  //Valor de IPI
aImp[6] := MaFisRet(01	,"IT_ALIQCOF") //Aliquota de calculo do COFINS
aImp[7] := MaFisRet(01	,"IT_ALIQPIS") //Aliquota de calculo do PIS
aImp[8] := MaFisRet(01	,"IT_ALIQPS2") //Aliquota de calculo do PIS 2
aImp[9] := MaFisRet(01	,"IT_ALIQCF2") //Aliquota de calculo do COFINS 2
aImp[10]:= MaFisRet(01	,"IT_DESCZF")  //Valor de Desconto da Zona Franca de Manaus
aImp[11]:= MaFisRet(01	,"IT_VALPIS")  //Valor do PIS
aImp[12]:= MaFisRet(01	,"IT_VALCOF")  //Valor do COFINS
aImp[13]:= MaFisRet(01	,"IT_BASEICM") //Valor da Base de ICMS

//Tratamento Volvo
If M->CJ_CLIENTE == "021984"
	MaFisLoad("IT_BASESOL" , VOLVORE()    ,Val(TMP1->CK_ITEM))

EndIf

aImp[14]:= MaFisRet(01	,"IT_BASESOL") //Base do ICMS Solidario
aImp[15]:= MaFisRet(01	,"IT_ALIQSOL") //Aliquota do ICMS Solidario
aImp[16]:= MaFisRet(01	,"IT_VALSOL" ) //Valor Solidário
aImp[17]:= MaFisRet(01	,"IT_MARGEM")  //Margem de lucro para calculo da Base do ICMS Sol.

MaFisSave()
MaFisEnd()

Return aImp

/*/{Protheus.doc} User Function VOLVORE
)
Local nTxPIS 	:= GetMv("MV_TXPIS") 	@type
  Function

	@author user
	@since 14/07/2021
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
	/*/
Static Function VOLVORE()
Local nTxPIS 	:= GetMv("MV_TXPIS") 	
Local nTxCOFIN	:= GetMV("MV_TXCOFIN")
Local nTxAlqIC	:= MaFisRet(Val(TMP1->CK_ITEM),"IT_ALIQSOL")//AIMP[15]
Local nVlrMerc	:= TMP1->CK_VALOR
Local nBsICMDf	:= Round(nVlrMerc*((nTxPIS+nTxCOFIN)/100), 2)
Local nBsICMRt	:= Round((nVlrMerc-nBsICMDf)/((100-(nTxPIS+nTxCOFIN+nTxAlqIC))/100), 2)

Return nBsICMRt
