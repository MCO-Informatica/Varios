#Include 'Protheus.ch'
#include 'topconn.ch'
#DEFINE X3_USADO_EMUSO 		"€€€€€€€€€€€€€€ "
#DEFINE X3_USADO_NAOUSADO 	"€€€€€€€€€€€€€€€"
/**
* Relatório de Ativos
*
* @author Gesse Santos
* @since 24/03/2014
*/
user function CSATFR001()
local cPerg		  := "CSATFR0011"
local cTitulo	  := "FICHA DETALHADA DE ATIVOS"
local cDescrRel	  := "FICHA DETALHADO DE ATIVOS"
private oReport   := nil
private oAtf	  := nil
private oItAtf 	  := nil
private oItCom 	  := nil

AtuSx1(cPerg)

if Pergunte(cPerg, .t.)
	oReport := TReport():New("CSATFR001", cTitulo,, { || impRel() }, cDescrRel)
	//oReport:SetPortrait()
	oReport:PrintDialog()
endIf
return


/**
* Imprime o Relatorio
*
* @author Gesse Santos
* @since 24/03/2014
*/
static function impRel()
local cAtfAtual 		:= ""
local cItemAtual 	    := ""
local cSubItemAtual := ""
local nReg := 0

criaEstr()

u00->(dbsetorder(1))
u01->(dbsetorder(1))
u06->(dbsetorder(1))
u00->(dbseek(xfilial("U00") + alltrim(mv_par01), .t.))
while !u00->(eof()) .and. alltrim(u00->u00_codhrd) <= alltrim(mv_par02)
	u06->(dbseek(xfilial("U06") + u00->u00_tiphrd ))
	oAtf:Init()
	oAtf:PrintLine()
	u01->(dbseek(xfilial("U01") + u00->u00_codhrd ,.t.))
	oItAtf:Init()
	
	while !u01->(eof()) .and. alltrim(u01->u01_codhrd) == alltrim(u00->u00_codhrd)
		oItAtf:PrintLine()
		u01->(dbskip())
		
	end-while
	oItAtf:Finish()
	
	oItCom:Init()
	u05->(dbseek(xfilial("U05") + u00->u00_codhrd ,.t.))
	while !u05->(eof()) .and. alltrim(u05->u05_codhrd) == alltrim(u00->u00_codhrd)
		
		oItCom:PrintLine()
		u05->(dbskip())
		
	end-while
	oItCom:Finish()
	
	u00->(dbskip())
	oAtf:Finish()
	oReport:EndPage()
end-while
return

/**
* Cria Estrutura tReport
*
* @author Gesse Santos
* @since 24/03/2014
*/
static function criaEstr()
oAtf		 := TRSection():New(oReport	    , "Ativos")
oItAtf	     := TRSection():New(oAtf		, "Softwares Instalados")
oItCom	     := TRSection():New(oAtf		, "Componentes")

oAtf:ForceLineStyle(.T.)
oAtf:lForceLineStyle := .T.
aCposU00 := GetCpos("U00",,{"U00_FILIAL"})
For nX:=1 to Len(aCposU00)
	if alltrim(aCposU00[nX]) == "U00_DATHRD"  
	    // Campos com tratamento especifico
		TRCell():New(oAtf,"U00_DATHRD"	,"U00")
	else                                   
	    // Campos inseridos pelas regras do SX3
		TRCell():New(oAtf,	aCposU00[nX]	,"U00"	,U00->(RetTitle(aCposU00[nX]))	, PesqPict("U00",aCposU00[nX])	,Tamsx3(aCposU00[nX])[1]+If(IsCombo(aCposU00[nX]),15,0),,)
	endif
Next nX
TRCell():New(oAtf,"U06_DESTIP"	,"U06")

TRCell():New(oItAtf,"U01_CODSFT"	,"U01")
TRCell():New(oItAtf,"U01_DESSFT"	,"U01")
TRCell():New(oItAtf,"U01_CONTRA"	,"U01")
TRCell():New(oItAtf,"U01_LICENC"	,"U01")

TRCell():New(oItCom,"U05_CODCOM"	,"U05")
TRCell():New(oItCom,"U05_DESCOM"	,"U05")
TRCell():New(oItCom,"U05_NUMSER"	,"U05")
TRCell():New(oItCom,"U05_MODELO"	,"U05")
TRCell():New(oItCom,"U05_MARCA"  	,"U05")

return

/**
* Cria Perguntas
*
* @author Gesse Santos
* @since 24/03/2014
*/
Static Function AtuSx1(cPerg)
Local aHlpPor := {}
aHlpPor := {}
Aadd( aHlpPor, ""	)
Aadd( aHlpPor, ""	)
PutSx1(cPerg,	"01","Do Hardware?","","","mv_ch1","C",TamSX3("U00_CODHRD")[1],0,1,;
"G","","U00_01","","S","mv_par01","","","","","","","","","","","","","","","","",aHlpPor,aHlpPor,aHlpPor)

aHlpPor := {}
Aadd( aHlpPor, ""	)
Aadd( aHlpPor, ""		)
PutSx1(cPerg,	"02","Até Hardware?","","","mv_ch2","C",TamSX3("U00_CODHRD")[1],0,1,;
"G","","U00_01","","S","mv_par02","","","","","","","","","","","","","","","","",aHlpPor,aHlpPor,aHlpPor)

aHlpPor := {}
Aadd( aHlpPor, ""	)
Aadd( aHlpPor, ""	)
PutSx1(cPerg,	"03","Tipo de?","","","mv_ch3","C",TamSX3("U00_TIPHRD")[1],0,1,;
"G","","U06_01","","S","mv_par03","","","","","","","","","","","","","","","","",aHlpPor,aHlpPor,aHlpPor)

aHlpPor := {}
Aadd( aHlpPor, ""	)
Aadd( aHlpPor, ""	)
PutSx1(cPerg,	"04","Tipo Até?","","","mv_ch4","C",TamSX3("U00_TIPHRD")[1],0,1,;
"G","","U06_01","","S","mv_par04","","","","","","","","","","","","","","","","",aHlpPor,aHlpPor,aHlpPor)

aHlpPor := {}
Aadd( aHlpPor, ""	)
Aadd( aHlpPor, ""	)
PutSx1(cPerg,	"05","Propriedade?","","","mv_ch5","N",TamSX3("U00_PROPRI")[1],0,1,;
"C","","","","S","mv_par05","Empresa","","","","Particular","","","Ambos","","","","","","","","",aHlpPor,aHlpPor,aHlpPor)

aHlpPor := {}
Aadd( aHlpPor, ""	)
Aadd( aHlpPor, ""	)
PutSx1(cPerg,	"06","Status?","","","mv_ch6","N",TamSX3("U00_STATUS")[1],0,1,;
"C","","","","S","mv_par06","Ativo","","","","Manutenção","","","Estocado","","","Baixado","","","Todos","","",aHlpPor,aHlpPor,aHlpPor)

aHlpPor := {}
Aadd( aHlpPor, ""	)
Aadd( aHlpPor, ""	)
PutSx1(cPerg,	"07","Local de?","","","mv_ch7","C",TamSX3("U00_CODLOC")[1],0,1,;
"G","","SZ3","","S","mv_par07","","","","","","","","","","","","","","","","",aHlpPor,aHlpPor,aHlpPor)

aHlpPor := {}
Aadd( aHlpPor, ""	)
Aadd( aHlpPor, ""	)
PutSx1(cPerg,	"08","Local Até?","","","mv_ch8","C",TamSX3("U00_CODLOC")[1],0,1,;
"G","","SZ3","","S","mv_par08","","","","","","","","","","","","","","","","",aHlpPor,aHlpPor,aHlpPor)

aHlpPor := {}
Aadd( aHlpPor, ""	)
Aadd( aHlpPor, ""	)
PutSx1(cPerg,	"09","Funcionário de?","","","mv_ch9","C",TamSX3("U00_CODFUN")[1],0,1,;
"G","","RD001","","S","mv_par09","","","","","","","","","","","","","","","","",aHlpPor,aHlpPor,aHlpPor)

aHlpPor := {}
Aadd( aHlpPor, ""	)
Aadd( aHlpPor, ""	)
PutSx1(cPerg,	"10","Funcionário Até?","","","mv_chA","C",TamSX3("U00_CODFUN")[1],0,1,;
"G","","RD001","","S","mv_par10","","","","","","","","","","","","","","","","",aHlpPor,aHlpPor,aHlpPor)

aHlpPor := {}
Aadd( aHlpPor, ""	)
Aadd( aHlpPor, ""	)
PutSx1(cPerg,	"11","Filial de?","","","mv_chB","C",TamSX3("U00_FILIAL")[1],0,1,;
"G","","","","S","mv_par11","","","","","","","","","","","","","","","","",aHlpPor,aHlpPor,aHlpPor)

aHlpPor := {}
Aadd( aHlpPor, ""	)
Aadd( aHlpPor, ""	)
PutSx1(cPerg,	"12","Filial Até?","","","mv_chC","C",TamSX3("U00_FILIAL")[1],0,1,;
"G","","","","S","mv_par12","","","","","","","","","","","","","","","","",aHlpPor,aHlpPor,aHlpPor)
Return

/**
* Obtem Campos dos Ativos
*
* @author Gesse Santos
* @since 24/03/2014
*/
Static Function GetCpos(cAlias,cExcecao,aIncluir)
Local aCpos := {}
Local aArea := GetArea()
Local nX	:= 0
Default cExcecao := ""
Default aIncluir := {}
aCpos	:= aIncluir
SX3->(dbSetOrder(1))
SX3->(dbSeek(cAlias))
Do While !SX3->(Eof()) .And. SX3->X3_ARQUIVO == cAlias
	If !(SX3->X3_CAMPO $ cExcecao) .And. SX3->X3_USADO == X3_USADO_EMUSO .And. SX3->X3_CONTEXT <> "V" .And. Ascan(aCpos,{|x| x==SX3->X3_CAMPO})==0
		aAdd(aCpos,SX3->X3_CAMPO)
	EndIf
	SX3->(dbSkip())
EndDo
RestArea(aArea)
Return aCpos

Static Function CSFormat(cAlias,cCampo)
Local cConteudo := (cAlias)->&(cCampo)
If IsCombo(cCampo)
	cConteudo:=x3Combo(cCampo,(cAlias)->&(cCampo))
EndIf
Return cConteudo

/**
* Verifica Se o Campo é combo
*
* @author Gesse Santos
* @since 24/03/2014
*/
Static Function IsCombo(cCampo)
Local lRet := .F.
Local aArea		:= GetArea()
SX3->(dbSetOrder(2))
If SX3->(dbSeek(cCampo)) .And. !Empty(SX3->X3_CBOX)
	lRet := .T.
EndIf
RestArea(aArea)
Return lRet
