#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณA455SLT1  บAutor  ณ S้rgio Santana     บ Data ณ  14/03/2016 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Ordena็ใo dos campas a serem demonstrados no browse de se- บฑฑ
ฑฑบ          ณ le็ใo                                                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Thermoglass                                               บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/



User Function A455SLT1()

    // Paramixb = { aStruTrb ,aBrowse }

    Local _aClas := {}
    aAdd( _aClas,{"TRB_OK",,""} )
	aAdd( _aClas,{"TRB_LOCALI",,RetTitle("C6_LOCALIZ")} )
	aAdd( _aClas,{"TRB_QTDLIB",,RetTitle("C6_QTDLIB")} )
	aAdd( _aClas,{"TRB_LOTECT",,RetTitle("C6_LOTECTL")} )
	aAdd( _aClas,{"TRB_NUMLOT",,RetTitle("C6_NUMLOTE")} )
	aAdd( _aClas,{"TRB_POTENC",,RetTitle("C6_POTENCI")} )
	aAdd( _aClas,{"TRB_NUMSER",,RetTitle("C6_NUMSERI")} )
	aAdd( _aClas,{"TRB_DTVALI",,RetTitle("C6_DTVALID")} )
	
Return( { Paramixb[1], _aClas } )