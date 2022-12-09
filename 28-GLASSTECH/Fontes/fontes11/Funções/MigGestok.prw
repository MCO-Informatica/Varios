#include 'rwmake.ch'
#include 'tbiconn.ch'

// Rotina para inclusão de saldo no protheus a partir do gestoq pela rotina interna MOD 2
// MATA241
User Function MigGestk

	// MATA241
	Local _aCab1 := {}
	Local _aItem := {}
	Local _aExecItem := {}
	
	Private lMsHelpAuto := .T.
	Private lMsErroAuto := .F.
	
	MsgInfo("LALA","")
	
	_aCab1 := {{"D3_TM", "507", nil},;
		{"D3_EMISSAO", dDatabase, nil}}
		
	/*_aItem := {{"D3_COD", "0010001", nil},;
		{"D3_FILIAL", "0101", nil},;
		{"D3_UM", "G", nil},;
		{"D3_QUANT", 40, nil},;
		{"D3_LOCAL", "03", nil},;
		{"D3_LOCALIZ", "L-28", nil},;
		{"D3_LOTECTL", "", nil}}*/
		
	_aItem := {{"D3_COD", 		"0010002", nil},;
            {"D3_FILIAL", 	"0101", nil},;
            {"D3_UM", 		"G", nil},;
            {"D3_QUANT", 	27, nil},;
            {"D3_LOCAL", 	"05", nil},;
            {"D3_LOCALIZ", 	"L-24", nil},;
            {"D3_LOTECTL", 	" ", nil}}
	
		
	aAdd(_aExecItem, _aItem)
	MsExecAuto({|x, y, z| Mata241(x, y, z)}, _aCab1, _aExecItem, 3)
	
	
	Alert("Executado com sucesso")
	
	if lMsErroAuto
		MostraErro()
		DisarmTransaction()
		break
	endif

Return