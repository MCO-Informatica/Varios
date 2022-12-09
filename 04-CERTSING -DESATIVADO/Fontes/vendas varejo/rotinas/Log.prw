#include 'protheus.ch'

Class Log 

	Data aLog
	Data cTitulo 
	Data aHeader
	Data LOG_ERRO
	Data LOG_INFO
	Data LOG_WARN
	Data LOG_DEBUG

	Method new() constructor 
	Method addLog(cLog)
	Method dumpToExcel()
	Method setHeader(cHeader) 	

endClass

Method new() Class Log

	//Inicializa o array de log que realizará o dump final
	::aLog := {}
	::aHeader := {}
	::cTitulo := ""
	::LOG_ERRO  := "[ERRO]"
	::LOG_INFO  := "[INFO]"
	::LOG_WARN  := "[WARN]"
	::LOG_DEBUG := "[DEBUG]"
	
Return

Method addLog(cLog) Class Log
	aAdd(::aLog, cLog)
Return

Method dumpToExcel() Class Log
	DlgToExcel({ {"ARRAY",::cTitulo, ::aHeader, ::aLog} })
Return

Method setHeader(aHeader) Class Log
	If Empty(::aHeader)
		::aHeader := aHeader
	EndIf
Return
