#include "rwmake.ch"
#include "topconn.ch"
#include "protheus.ch"
////////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | CSSPED001            | AUTOR | Gesse Santos | DATA |26/03/2014  |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Consulta de NF-e para gravacao dos campos SF3                   |//
//|           |                                                                 |//
//+-----------------------------------------------------------------------------+//
//| Especifico para CertiSign                                                   |//
//+-----------------------------------------------------------------------------+//
//| DATA     | AUTOR                | DESCRICAO                                 |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
User Function CSSPED01()
local cPerg   := "CSSPED1_01"
LOCAL aParamBox := {}
LOCAL bOk := {|| .T.}
LOCAL aButtons := {}
LOCAL lCentered := .T.
local cTitulo := "Consulta NFe - Cod. Retorno SEFAZ"
LOCAL nPosx
LOCAL nPosy
LOCAL cLoad := "CSSPED1_01"
LOCAL lCanSave := .T.
LOCAL lUserSave := .T.
LOCAL dData	 := dDataBase
Local aAux          := {}

Static aPergRet := {}


aAdd(aParamBox,{1, "Data"              ,Ctod(Space(8)),"","","","",50,.F.}) // Tipo data
aAdd(aParamBox,{1, "Data"              ,Ctod(Space(8)),"","","","",50,.F.}) // Tipo data
aadd(aParamBox,{1, "Serie"	           ,space(03)   ,"@!"   , 	,"",".T.",60  ,.F.})
aadd(aParamBox,{1, "Nota Fiscal De"	   ,space(09)   ,"@!"   , 	,"",".T.",60  ,.F.})
aadd(aParamBox,{1, "Nota Fiscal Ate"   ,space(09)   ,"@!"   , 	,"",".T.",60  ,.F.})

lRet := ParamBox(aParamBox, cTitulo, aPergRet, bOk, aButtons, lCentered, nPosx,nPosy,, cLoad, lCanSave, lUserSave)
if lRet
	MsgRun("SEFAZ - Consultando notas fiscais..." ,,{|| procSF3() })
endif

return()

///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | procSF3()            | AUTOR | Gesse Santos | DATA |26/03/2014  |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Consulta de NF-e para gravacao dos campos SF3                   |//
//|           |                                                                 |//
//+-----------------------------------------------------------------------------+//
//| Especifico para CertiSign                                                   |//
//+-----------------------------------------------------------------------------+//
//| DATA     | AUTOR                | DESCRICAO                                 |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
static function procSF3()
Local cQuery   := ""
Local _cMaxNf  := ""
Local _cMinNf  := ""

Local _nMinNf  := 0
Local _nMaxNf  := 0
Local _nAtuNf  := 0

cQuery := "SELECT MAX(F3_NFISCAL) AS F3_NFISCAL  FROM "+RetSqlName("SF3")+" SF3 "
cQuery += "			WHERE 	SF3.D_E_L_E_T_ = ''  AND F3_ESPECIE = 'SPED'  "
cQuery += "				AND F3_ENTRADA   BETWEEN '"+dtos(MV_PAR01)+"' AND '"+dtos(MV_PAR02)+"' "
cQuery += "				AND F3_NFISCAL   BETWEEN '"+MV_PAR04+"' AND '"+MV_PAR05+"'             "
cQuery += "				AND F3_SERIE     =  '"+MV_PAR03+"'      AND         "
cQuery += "	 (   F3_CFO >= '5'   OR (  F3_CFO < '5' AND F3_FORMUL = 'S' )  ) "
cQuery += "	 ORDER BY F3_NFISCAL "
cQuery := ChangeQuery(cQuery)
dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "TRBSF3", .F., .T.)
_cMaxNf := trbsf3->f3_nfiscal
trbsf3->(dbclosearea())

cQuery   := ""

cQuery := "SELECT MIN(F3_NFISCAL) AS F3_NFISCAL  FROM "+RetSqlName("SF3")+" SF3 "
cQuery += "			WHERE 	SF3.D_E_L_E_T_ = ''  AND F3_ESPECIE = 'SPED'  "
cQuery += "				AND F3_ENTRADA   BETWEEN '"+dtos(MV_PAR01)+"' AND '"+dtos(MV_PAR02)+"' "
cQuery += "				AND F3_NFISCAL   BETWEEN '"+MV_PAR04+"' AND '"+MV_PAR05+"'             "
cQuery += "				AND F3_SERIE     =  '"+MV_PAR03+"'      AND         "
cQuery += "	 (   F3_CFO >= '5'   OR (  F3_CFO < '5' AND F3_FORMUL = 'S' )  ) "
cQuery += "	 ORDER BY F3_NFISCAL "
cQuery := ChangeQuery(cQuery)
dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "TRBSF3", .F., .T.)
_cMinNf := trbsf3->f3_nfiscal
trbsf3->(dbclosearea())



if _cMinNf >  _cMaxNf
	alert("Não foi possivel encontrar notas fiscais na faixa De: "+_cMinNf + " Ate "+_cMaxNf)
else
	if  MV_PAR01 > MV_PAR02
		alert("Não foi possivel encontrar notas fiscais nas datas De: "+dtoc(mv_par01) + " Ate "+dtoc(mv_par02))
	else
		_nMinNf  := val(_cMinNf)
		_nMaxNf  := val(_cMaxNf)
		_nAtuNf  := 0
		
		if (_nMaxNf - _nMinNf) < 190
			u_GTNFeMnt(,1,{MV_PAR03,_cMinNf,_cMaxNf})
		else
			while _nMinNf <= _nMaxNf
				
				_nAtuNf  := _nMinNf + 190
				
				_cMinNf  := strzero(_nMinNf,9)
				_cMaxNf  := strzero(_nAtuNf,9)
				//alert("Consultando faixa De "+_cMinNf + " Ate " + _cMaxNf )
				u_GTNFeMnt(,1,{MV_PAR03,_cMinNf,_cMaxNf})
				
				_nMinNf  := _nAtuNf
				
			end-while
		endif
	endif
endif


return()
