#INCLUDE "PROTHEUS.CH"

User Function F450BROW()

Local nTamTitulo	:= TamSx3("E2_PREFIXO")[1]+TamSx3("E2_NUM")[1]+TamSx3("E2_PARCELA")[1]+TamSx3("E2_TIPO")[1]
Local nTamChavE2	:= TamSx3("E2_FILIAL")[1]+TamSx3("E2_FORNECE")[1]+TamSx3("E2_LOJA")[1]+nTamtitulo
Local nTamCod		:= TamSx3("E1_CLIENTE")[1]+TamSx3("E1_LOJA")[1]+1 //Tamanho do codigo do Cliente para browse

Local aCampos := {{"P_R"      ,"C", 1,0},;
						{"TITULO"   ,"C",nTamTitulo+3,0},;
						{"PAGAR"    ,"N",15,2},;
						{"RECEBER"  ,"N",15,2},;
						{"NOME"     ,"C",20,0},;
						{"TIPO"     ,"C", 3,0},;
						{"EMISSAO"  ,"D", 8,0},;
						{"VENCTO"   ,"D", 8,0},;
						{"MARCA"    ,"C", 2,0},;
						{"CHAVE"    ,"C",nTamChavE2,0},;
						{"PRINCIP"	,"N",15,2},;						
						{"ABATIM"   ,"N",15,2},;
						{"JUROS"    ,"N",15,2},;
						{"MULTA"    ,"N",15,2},;
						{"DESCONT"	,"N",15,2},;
						{"ACRESC"   ,"N",15,2},;
						{"DECRESC"  ,"N",15,2},;
						{"CLIFOR"	,"C",nTamCod,0}}


Local aCpoBro	:= {{ "MARCA"		,, " ","  "},;
						{	"P_R"		,, "Carteira","!"},;   //"Carteira"
						{	"TITULO"	,, "Numero Titulo","@X"},;  //"N£mero T°tulo"
						{	"PAGAR"		,, "Valor Pagar","@E 9,999,999,999.99"},;  //"Valor Pagar"
						{	"RECEBER"	,, "Valor Receber","@E 9,999,999,999.99"},;  //"Valor Receber"
						{   "NOME"		,, "Nome","@X"},;  //"Nome"
						{   "TIPO"		,, "Tipo","@X"},;  //"Tipo"
						{	"VENCTO"	,, "Data Vencimento","@X"},;  //"Data Vencimento"
						{	"EMISSAO"	,, "Data Emissao","@X"},;  //"Data Emiss∆o"
						{	"PRINCIP"	,, "Saldo Titulo","@E 9,999,999,999.99"},; //"Saldo Titulo"
						{	"JUROS"		,, "Juros","@E 9,999,999,999.99"},; //"Juros"
						{	"MULTA"		,, "Multa","@E 9,999,999,999.99"},; //"Multa"
						{	"DESCONT"	,, "Descontos","@E 9,999,999,999.99"},; //"Descontos"
						{	"ACRESC"	,, "Acrescimento","@E 9,999,999,999.99"},; //"Acrescimos"
						{	"DECRESC"	,, "Decrescimos","@E 9,999,999,999.99"},; //"Decrescimos"
						{	"CLIFOR"	,, "Cli/For","@X"}} //"Cli/For"


Return({aCampos,aCpoBro}) 