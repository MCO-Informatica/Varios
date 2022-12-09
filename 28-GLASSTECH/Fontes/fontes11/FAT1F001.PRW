#include 'protheus.ch'
#include "TOTVS.ch"

// Cria pedido de venda dentro do protheus para cliente 003916 (Twin Filial)
User Function FAT1F001(cProduto, nQnt)

	Local aDataCabec := {}
	Local aMata410i := {}
	Local cErro := ""
	Local cNumPed := ""
	Local aRes := {cErro, cNumPed}
	
	cNumPed := GetSX8Num("SC5")
	
	//aRes[2] := cNumPed

	aAdd(aDataCabec,{"C5_NUM"                 ,cNumPed	            , Nil})
	aAdd(aDataCabec,{"C5_TIPO"                ,'N'        			 , Nil})
	aAdd(aDataCabec,{"C5_CLIENTE"             ,'003916'             , Nil})
	aAdd(aDataCabec,{"C5_LOJACLI"             ,'00'                 , Nil})
	aAdd(aDataCabec,{"C5_TIPOCLI"             ,'F'                  , Nil})
	aAdd(aDataCabec,{"C5_ZZNIVEL"             ,'1'      				 , Nil})
	aAdd(aDataCabec,{"C5_CONDPAG"             ,'001'      			 , Nil})
	aAdd(aDataCabec,{"C5_PRDAUTO"             ,'1'                  , Nil})

	ConfirmSX8()

	AADD(aMata410i,            {"C6_ITEM"     , '01', NIL})
	AADD(aMata410i,            {"C6_PRODUTO"  , cProduto, NIL})
	AADD(aMata410i,            {"C6_QTDVEN"   , nQnt, NIL})
	AADD(aMata410i,            {"C6_QTDLIB"   , 0, NIL})
	AADD(aMata410i,            {"C6_PRCVEN"   ,10, NIL})
	AADD(aMata410i,            {"C6_VALOR"    , (nQnt * 10), NIL})
	AADD(aMata410i,            {"C6_TES"      ,'50Y', NIL})
	AADD(aMata410i,            {"C6_PRUNIT"   ,10, NIL})

	lMsErroAuto := .F.
	lAutoErrNoFile := .T.
	lMsHelpAuto := .T.

	MSExecAuto({|x,y,z|Mata410(x,y,z)}, aDataCabec, {aMata410i}, 3)

	if lMsErroAuto
		//MostraErro()
		aAutoErro := GETAUTOGRLOG()
		for nX := 1 To Len(aAutoErro)
			cErro += aAutoErro[nX] + Chr(13)+Chr(10)
       next nX
       
       aRes[1] := cErro
       //DisarmTransaction()	
	else
		aRes[2] := cNumPed
	endif

Return aRes