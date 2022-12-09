#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.CH"
#INCLUDE "topconn.CH"

USER FUNCTION _FTST()

	Local _nTotalHr	:= 0
	Local _cAliastst	:= GetNextAlias()

	_cQuery	:= "SELECT H8_HRINI, H8_HRFIM, H8_DTINI, H8_DTFIM "
	_cQuery	+= " FROM " + RetSqlName("SH8")
	_cQuery	+= " WHERE H8_FILIAL = '50' "
	_cQuery	+= " AND H8_OP = '04182901001' "
	TcQuery _cQuery New Alias &(_cAliastst)

	TCSetField (_cAliastst, "H8_DTINI"	, "D", TAMSX3("H8_DTINI")[1]	, TAMSX3("H8_DTINI")[1] )
	TCSetField (_cAliastst, "H8_DTFIM"	, "D", TAMSX3("H8_DTFIM")[1]	, TAMSX3("H8_DTFIM")[1] )

	_cHIni	:= (_cAliastst)->H8_HRINI
	_cHFim	:= (_cAliastst)->H8_HRFIM
	_dDtIni	:= (_cAliastst)->H8_DTINI
	_dDtFim	:= (_cAliastst)->H8_DTFIM
	_nHrIni	:= "00:00:00"
	_nHrFim	:= "24:00:00"
	_nHrRecI	:= _cHIni + ":00"
	_nHrRecF	:= _cHFim + ":00"
	_dData	:= _dDtIni	

	If _dDtIni == _dDtFim
		_nTotalHr	:= Val(ElapTime(_nHrRecI,_nHrRecF))
	Else
		For _nI := _dData to _dDtFim
			Do Case
				Case _dData == _dDtIni
					_nTotalHr += Val(ElapTime(_nHrRecI,_nHrFim))
				Case _dData <> _dDtFim
					_nTotalHr += Val(ElapTime(_nHrIni,_nHrFim))
				Otherwise
					_nTotalHr += Val(ElapTime(_nHrIni,_nHrRecF))
			End Case
			_dData++
		Next
	EndIf


	ALERT(ALLTRIM(STR(_nTotalHr)))
RETURN