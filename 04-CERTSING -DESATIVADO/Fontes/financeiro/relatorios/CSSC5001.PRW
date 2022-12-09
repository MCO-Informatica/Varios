#include "protheus.ch"
#include "report.ch"
#include "topconn.ch"

/**
* Relatório de Pedidos
* @author Gesse Santos
* @since 01/07/2014
*/
user function CSSC5001()

Local lRet			:= .F.
Local aRet 		:= {}
Local aParamBox	:= {}
Local cAno			:= ""

local cTitulo	:= "Pedidos Liberados e Nao Recebidos"
local cDescrRel	:= "Listagem dos pedidos ja liberados mas que não foram informados no CNAB"

private oReport  := nil
private oOS		 := nil
private oItOs  	 := nil
Private oTitOS   := nil
Private oCntOS   := nil

private cTituloPerg	:= "Pedidos Liberados - Não Recebidos"
private cGrupoPerg	:= "CSSC5001"


dbSelectArea("SC5")

aAdd(aParamBox,{1,"Data de "              ,Ctod(Space(8)),"","","","",50,.F.}) // Tipo data
aAdd(aParamBox,{1,"Data ate"              ,Ctod(Space(8)),"","","","",50,.F.}) // Tipo data
lRet := ParamBox(aParamBox,cTituloPerg,@aRet,,,,,,,cGrupoPerg,.T.,.T.)

if lRet
	oReport := TReport():New("CSSC5001", cTitulo,, { || impRel() }, cDescrRel)
	oReport:SetLandscape() //SetPortrait()
	oReport:PrintDialog()
endIf

return


static function impRel()
local cOsAtual 		:= ""
local cItemAtual 	:= ""
local cSubItemAtual := ""
local nReg := 0
Local	cSerie     := ""
Local	cNota      := ""
Local cImp         := ""
Local aNota        := {}
Local __i          := 0
Local cTitulos     := ""
Local cCli         := ""

cAliasOS := retItemOS()

criaEstr()

DbSelectArea(cAliasOS)
Count to nRegs
oReport:SetMeter(nRegs)
sa1->(dbsetorder(1))
sb1->(dbsetorder(1))
sf4->(dbsetorder(1))
szq->(dbsetorder(2))
se1->(dbsetorder(2))
ac8->(dbsetorder(2))
su5->(dbsetorder(1))

(cAliasOS)->(dbGoTop())
cOsAtual := (cAliasOS)->C5_NUM

do while !(cAliasOS)->(Eof())
	
	// Analisar: Nesse caso so avalia se há saldo resudual no primeiro titulo encontrado para o pedido.
	// Se o saldo estiver em um titulo posterior, nao sera identificado - Nao sai no relatorio
	oReport:IncMeter()
	sc5->(dbgoto((cAliasOS)->regsc5))
	sa1->(dbseek(xfilial("SA1") + sc5->c5_cliente + sc5->c5_lojacli ))
	ac8->(dbseek(xfilial("AC8") + "SA1" + xfilial("SA1")+sc5->c5_cliente + sc5->c5_lojacli,.t.))
	su5->(dbseek(xfilial("SU5") + ac8->ac8_codcon ))
	if szq->(dbseek(xfilial("SZQ") + sc5->c5_xnpsite ))
		se1->(dbseek(xfilial("SE1") + (cAliasOS)->c5_cliente + (cAliasOS)->c5_lojacli + "SP"+substr((cAliasOS)->d2_serie,1,1) + (cAliasOS)->d2_doc, .t. ))
		if !(( se1->e1_saldo <> 0) .and. (se1->e1_saldo < se1->e1_valor )) // indica que nao baixou todo o saldo
			(cAliasOS)->(dbskip())
			loop
		endif
	endif
	// Fim Analisar
	
	if oReport:Cancel()
		Exit
	endIf
	
	oOS:Init()
	oOS:PrintLine()
	oCntOS:Init()
	oCntOS:PrintLine()
	
	cItemAtual := (cAliasOS)->C5_NUM
	cSerie     := (cAliasOS)->d2_serie
	cNota      := (cAliasOS)->d2_doc
	aNota      := {}
	cTitulos   := ""
	cImp       := ""
	cCli       := sc5->c5_cliente+sc5->c5_lojacli
	do while !(cAliasOS)->(Eof()) .AND. cItemAtual == (cAliasOS)->C5_NUM
		sc6->(dbgoto((cAliasOS)->regsc6))
		if alltrim(sc6->c6_item) $ cImp // quando ha varios ADE para o pedido, so preciso de uma ocorrencia
			(cAliasOS)->(dbskip())
			loop
		endif
		cImp := cImp + "|"+alltrim(sc6->c6_item)+"|"
		sa1->(dbseek(xfilial("SA1") + sc5->c5_cliente + sc5->c5_lojacli ))
		sf4->(dbseek(xfilial("SF4") + sc6->c6_tes ))
		sb1->(dbseek(xfilial("SB1") + sc6->c6_produto ))
		if sf4->f4_duplic == "S"
			if !("SP"+substr(sc6->c6_serie,1,1) + sc6->c6_nota $ cTitulos)
				cTitulos := cTitulos + "|"+"SP"+substr(sc6->c6_serie,1,1) + sc6->c6_nota+"|"
				aadd(aNota,"SP"+substr(sc6->c6_serie,1,1) + sc6->c6_nota)
			endif
			oItOs:Init()
			oItOs:PrintLine()
		endif
		(cAliasOS)->(dbskip())
	endDo
	if !empty(aNota)
		for __i := 1 to len(aNota)
			se1->(dbseek(xfilial("SE1") + cCli+aNota[__i], .t. ))
			while !se1->(eof()) .and. se1->e1_filial == xfilial("SE1") .and. se1->e1_cliente+se1->e1_loja == cCli .and.;
				se1->e1_prefixo+se1->e1_num == aNota[__i] .and.;
				se1->e1_prefixo == "SP"+substr(cSerie,1,1) .and.;
				alltrim(se1->e1_num)==alltrim(cNota)
				oTitOs:Init()
				oTitOs:PrintLine()
				se1->(dbskip())
			end-while
		next __i
	endif
	
	oOS:Finish()
endDo

(cAliasOS)->(dbCloseArea())
return

static function criaEstr()
oOS		 := TRSection():New(oReport	, "Pedido de Vendas")
oItOs	 := TRSection():New(oOS		, "Itens do Pedido")
oTitOs	 := TRSection():New(oOS		, "Itens do Pedido")
oCntOS   := TRSection():New(oOS     , "Contatos")
oOS:ForceLineStyle(.T.)

oOS:lForceLineStyle := .T.

TRCell():New(oOS,"C5_NUM"	    ,cAliasOS)
TRCell():New(oOS,"C5_CHVBPAG"	,cAliasOS)
TRCell():New(oOS,"C5_XNPSITE"	,cAliasOS)
TRCell():New(oOS,"C5_CLIENTE"	,cAliasOS)
TRCell():New(oOS,"A1_NOME"		,"SA1","Cliente",,30)
TRCell():New(oOS,"A1_MUN"		,"SA1","Cidade",,15)
TRCell():New(oOS,"A1_EST"		,"SA1","UF",,2)
TRCell():New(oOS,"A1_EMAIL"		,"SA1","e-Mail - Cliente",,30)  
TRCell():New(oOS,"U5_CONTAT"	,"SU5","Contato",,20)
TRCell():New(oOS,"U5_FONE"	,"SU5","Fone",,15)

TRCell():New(oCntOS,"U5_CONTAT"		,cAliasOS,"Agente" )
TRCell():New(oCntOS,"ADE_MAIL"		,cAliasOS )
TRCell():New(oCntOS,"ADE_XAR"		,cAliasOS )
TRCell():New(oCntOS,"ADE_TO"		,cAliasOS,"Destinatario",, 80 )


//	TRCell():New(oSection1, "B1_FILIAL"	, "QRY", 'FILIAL'	,PesqPict('SB1',"B1_FILIAL"),TamSX3("B1_FILIAL")[1]+1,/*lPixel*/,/*{|| code-block de impressao }*/)


TRCell():New(oItOs,"C6_ITEM"	,cAliasOS)
TRCell():New(oItOs,"C6_PRODUTO"	,cAliasOS)
TRCell():New(oItOs,"B1_DESC"	,"SB1")
TRCell():New(oItOs,"C6_VALOR"	,cAliasOS)

TRCell():New(oTitOs,"E1_NUM"		,"SE1")
TRCell():New(oTitOs,"E1_VENCREA"	,"SE1")
TRCell():New(oTitOs,"E1_VALOR"		,"SE1")
TRCell():New(oTitOs,"E1_SALDO" 		,"SE1")




//oBreakOS 	:= TRBreak():New(oOS 		, {|| (cAliasOS)->C5_NUM },"Total Pedido")
//TRFunction():New(oItOS:Cell("C6_VALOR"),,"SUM",oBreakOS	 ,"Total Pedido",,,.F.,.F.,.F.)

return


/**
* Busca as Sub itens OS
*/
static function retItemOS()
Local cSQL 	:= ""
Local cAliasOS 	:= GetNextAlias()

cSQL := ""
cSQL += "           SELECT   " + CRLF
cSQL += "                 SC5.R_E_C_N_O_ AS REGSC5," + CRLF
cSQL += "                 SC6.R_E_C_N_O_ AS REGSC6," + CRLF
cSQL += "                 ADE_CODIGO, " + CRLF
cSQL += "                 ADE_GRUPO, " + CRLF
cSQL += "                 ADE_CODCON, " + CRLF
cSQL += "                 SUBSTR(ADE_TO,1,80) AS ADE_TO, " + CRLF
cSQL += "                 ADE_ENTIDA, " + CRLF
cSQL += "                 ADE_CHAVE, " + CRLF
cSQL += "                 ADE_XAR, " + CRLF
cSQL += "                 ADE_XAC, " + CRLF
cSQL += "                 U5_CONTAT, " + CRLF
cSQL += "                 ADE_DATA," + CRLF
cSQL += "                 ADE_PEDGAR,  " + CRLF
cSQL += "                 ADE_HORA, " + CRLF
cSQL += "                 C5_NUM, " + CRLF
cSQL += "                 C5_CHVBPAG, " + CRLF
cSQL += "                 C5_XNPSITE, " + CRLF
cSQL += "                 C6_ITEM,   " + CRLF
cSQL += "                 C6_TES," + CRLF
cSQL += "                 C6_PRODUTO,  " + CRLF
cSQL += "                 C6_VALOR," + CRLF
cSQL += "                 C5_CLIENTE, " + CRLF
cSQL += "                 C5_LOJACLI, " + CRLF
cSQL += "                 D2_DOC,  " + CRLF
cSQL += "                 D2_SERIE  " + CRLF
cSQL +=	" FROM " + RetSqlTab("ADE") + CRLF
cSQL += " INNER JOIN  "+RetSqlTab("SC5")+" ON C5_FILIAL = '"+xFilial("SC5")+"'  AND      ADE_PEDGAR = C5_CHVBPAG  AND  SC5.D_E_L_E_T_ = ' ' "+ CRLF
cSQL += " INNER JOIN  "+RetSqlTab("SU5")+" ON U5_FILIAL = '"+xfilial("SU5")+"' AND U5_CODCONT = ADE_CODCON  AND  SU5.D_E_L_E_T_ = ' ' "+ CRLF
cSQL += " INNER JOIN  "+RetSqlTab("SC6")+" ON C5_NUM     = C6_NUM     AND C5_FILIAL  = C6_FILIAL   AND  SC6.D_E_L_E_T_ = ' ' "+ CRLF
cSQL += " INNER JOIN  "+RetSqlTab("SD2")+" ON D2_FILIAL  = '"+xFilial("SD2")+"'  AND C6_NUM     = D2_PEDIDO   AND C6_ITEM  = D2_ITEMPV AND  SD2.D_E_L_E_T_ = ' ' "+ CRLF
cSQL += "           WHERE " + CRLF
cSQL += "                 ADE_FILIAL = '"+xFilial("ADE")+"'              AND  " + CRLF
cSQL += "                 ADE_GRUPO    = '71'         AND " + CRLF
cSQL += "                 ADE_PEDGAR <> ' '           AND " + CRLF
cSQL += "                 C5_TIPO = 'N'                  AND " + CRLF
cSQL += "                 C5_TIPMOV = '1'                AND " + CRLF
cSQL += "        C5_EMISSAO BETWEEN '" + dtos(mv_par01) + "' AND '" + dtos(mv_par02) + "' ORDER BY U5_CONTAT, C5_NUM " + CRLF

TcQuery cSQL New Alias &cAliasOS
TCSetField(cAliasOS,"C6_VALOR","N",17,2)

//memowrite("c:\Intel\query_ped.txt",cSQL)

return cAliasOS

