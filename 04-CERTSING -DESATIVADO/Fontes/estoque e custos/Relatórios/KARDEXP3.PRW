#Include "Totvs.ch"
/**
* @ Kardex de Poder de Terceiros - Base SB6
* @author Gesse Santos
* @Oct 27 2014
*/
User Function KardexP3()
local cPerg   := "KARDEXP301"
LOCAL aParamBox := {}
LOCAL bOk := {|| .T.}
LOCAL aButtons := {}
LOCAL lCentered := .T.
LOCAL nPosx
LOCAL nPosy
LOCAL cLoad := "KARDEXP301"
LOCAL lCanSave := .T.
LOCAL lUserSave := .T.
LOCAL dData	 := dDataBase
Local aAux          := {}
Local __cQry := ""
Local cDesc1  := 'Serão impressas as movimentações em poder de terceiros. '
Local cDesc2  := ' '
Local cDesc3  := ' '
Local cString := 'SB6'
Local aOrd    := {}
Local wnRel   := "KARDEXP3"

Private cCadastro := "Kardex - Poder de Terceiros"
Private aReturn    := { "Zebrado" , 1, "Administracao" , 2, 2, 1, '',1 }
Private nomeprog   := 'KARDEXP3'
Private aLinha     := {}
Private nLastKey   := 0

Private Titulo   := cCadastro
Private cCabec1  := 'DATA               REMESSA        RETORNO         SALDO '
Private cCabec2  := ''
Private Tamanho  := 'P'
Private M_PAG    := 1

Static aPergRet := {}
AADD(aParamBox,{1,"Fornecedor de " ,	Space(6)    			,	"",	   		"",	"SA2"	,	"", 50,	.F.	})
AADD(aParamBox,{1,"Fornecedor até" ,	Space(6)    			,	"",	   		"",	"SA2"	,	"", 50,	.F.	})
AADD(aParamBox,{1,"Produto de " 	  ,	Space(15)    			,	"",	   		"",	"SB1"	,	"", 50,	.F.	})
AADD(aParamBox,{1,"Produto até" 	  ,	Space(15)    			,	"",	   		"",	"SB1"	,	"", 50,	.F.	})
aAdd(aParamBox,{1,"Data de  "      ,Ctod(Space(8)),"","","","",50,.F.}) // Tipo data
aAdd(aParamBox,{1,"Data até "      ,Ctod(Space(8)),"","","","",50,.F.}) // Tipo data

lRet := ParamBox(aParamBox, 'Parâmetros', aPergRet, bOk, aButtons, lCentered, nPosx,nPosy,, cLoad, lCanSave, lUserSave)
if lRet
	li    := 80
	nTipo := If(aReturn[4]==1,15,18)
	wnrel := SetPrint(cString,NomeProg,NIL,@titulo,cDesc1,cDesc2,cDesc3,.F.,/*aOrd*/,.F.,Tamanho,NIL,.F.)
	If nLastKey == 27
		Return Nil
	Endif
	SetDefault(aReturn,cString)
	If nLastKey == 27
		Return Nil
	Endif
	RptStatus({|| Impressao(wnRel,cString)},Titulo,'Imprimindo, aguarde...',.F.)
endif
Return Nil

&& Impressao do Kardex
Static Function Impressao(wnRel,cString)
local __cQquery := ""
local __cForn   := ""
local __nRem    := 0
local __nRet    := 0
local __nSld    := 0
local __nEnt    := 0
local __nSai    := 0

__cQquery := ""
__cQquery := __cQquery + " SELECT DISTINCT B6_CLIFOR, B6_LOJA, B6_PRODUTO "
__cQquery := __cQquery + " FROM "+RetSqlName("SB6")+" B "
__cQquery := __cQquery + " WHERE B.D_E_L_E_T_ = ' '  "
__cQquery := __cQquery + " AND B6_FILIAL = '"+xfilial("SB6")+"'  "
__cQquery := __cQquery + " AND B6_CLIFOR   BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'  "
__cQquery := __cQquery + " AND B6_PRODUTO  BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'  "
__cQquery := __cQquery + " AND B6_EMISSAO  BETWEEN '"+dtos(mv_par05)+"' AND '"+dtos(mv_par06)+"'  "
__cQquery := __cQquery + " ORDER BY  B6_CLIFOR, B6_LOJA, B6_PRODUTO "

if select("SB6ALIAS") > 0
	sb6alias->(dbclosearea())
endif

dbUseArea(.T.,"TOPCONN",TcGenQry(,,__cQquery),"SB6ALIAS",.T.,.T.)
sa2->(dbsetorder(1))
sb1->(dbsetorder(1))

SetRegua(0)

while !sb6alias->(eof())
	IncRegua()
	__cForn :=  alltrim(sb6alias->b6_clifor)
	Cabec(Titulo,cCabec1,cCabec2,NomeProg,Tamanho,nTipo)
	li := 8
	sa2->(dbseek(xfilial("SA2") + sb6alias->b6_clifor + sb6alias->b6_loja, .t. ))
	@ li,000 PSAY "Fornecedor: "+alltrim(sb6alias->b6_clifor) + " - " + sa2->a2_nome
	li++
	while !sb6alias->(eof()) .and.  alltrim(sb6alias->b6_clifor) == alltrim(__cForn)
		__cQquery := ""
		__cQquery := __cQquery + " SELECT DISTINCT B6_EMISSAO AS DATAEMI  "
		__cQquery := __cQquery + "    FROM "+RetSqlName("SB6")+" B    "
		__cQquery := __cQquery + "    WHERE B.D_E_L_E_T_ = ' '  "
		__cQquery := __cQquery + "    AND B6_CLIFOR = '"+sb6alias->b6_clifor+"'  "
		__cQquery := __cQquery + "    AND B6_FILIAL = '"+xfilial("SB6")+"' "
		__cQquery := __cQquery + "    AND B6_PRODUTO = '"+sb6alias->b6_produto+"' "
		__cQquery := __cQquery + "    AND B6_EMISSAO BETWEEN '"+dtos(mv_par05)+"' AND '"+dtos(mv_par06)+"' "
		__cQquery := __cQquery + " ORDER BY DATAEMI "
		if select("P3MOV") > 0
			p3mov->(dbclosearea())
		endif
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,__cQquery),"P3MOV",.T.,.T.)
		
		__cQquery := ""
		__cQquery := __cQquery + " SELECT SUM(B6_QUANT) AS REMESSA  "
		__cQquery := __cQquery + " FROM "+RetSqlName("SB6")+" B3 "
		__cQquery := __cQquery + " WHERE  B6_FILIAL = '"+xfilial("SB6")+"' "
		__cQquery := __cQquery + " AND B3.D_E_L_E_T_ = ' '  "
		__cQquery := __cQquery + " AND B6_TES > '500' "
		__cQquery := __cQquery + " AND B6_CLIFOR = '"+sb6alias->b6_clifor+"' "
		__cQquery := __cQquery + " AND  B6_PODER3 = 'R' "
		__cQquery := __cQquery + " AND  B3.B6_EMISSAO < '"+dtos(mv_par05)+"' "
		__cQquery := __cQquery + " AND B3.B6_PRODUTO = '"+sb6alias->b6_produto+"' "
		__nRem    := 0
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,__cQquery),"P3REM",.T.,.T.)
		__nRem := p3rem->remessa
		p3rem->(dbclosearea())
		__cQquery := ""
		__cQquery := __cQquery + " SELECT SUM(B6_QUANT) AS RETORNO  "
		__cQquery := __cQquery + " FROM "+RetSqlName("SB6")+" B1 "
		__cQquery := __cQquery + " WHERE  B6_FILIAL = '"+xfilial("SB6")+"' "
		__cQquery := __cQquery + " AND B1.D_E_L_E_T_ = ' ' "
		__cQquery := __cQquery + " AND B6_TES < '500' "
		__cQquery := __cQquery + " AND B6_CLIFOR = '"+sb6alias->b6_clifor+"' "
		__cQquery := __cQquery + " AND  B6_PODER3 = 'D' "
		__cQquery := __cQquery + " AND  B1.B6_EMISSAO < '"+dtos(mv_par05)+"' "
		__cQquery := __cQquery + " AND B1.B6_PRODUTO = '"+sb6alias->b6_produto+"' "
		__nRet    := 0
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,__cQquery),"P3RET",.T.,.T.)
		__nRet := p3ret->retorno
		p3ret->(dbclosearea())
		__nSld    := __nRem - __nRet
		
		sb1->(dbseek(xfilial("SB1") + sb6alias->b6_produto , .t. ))
		@ li,000 PSAY "Produto: "+alltrim(sb6alias->b6_produto) + " - " + sb1->b1_desc
		li++
		@ li,000 PSAY "Saldo Inicial: "+space(27)+transform(__nSld,  "@E 99,999,999.99")
		li++
		@ li,000 PSAY replicate("-",80)
		li++
		__nEnt := 0
		__nSai := 0
		while !p3mov->(eof())
			__cQquery := ""
			__cQquery := __cQquery + " SELECT COALESCE(SUM(B6_QUANT),0) AS REMESSA  "
			__cQquery := __cQquery + " FROM "+RetSqlName("SB6")+" B3 "
			__cQquery := __cQquery + " WHERE  B6_FILIAL = '"+xfilial("SB6")+"' "
			__cQquery := __cQquery + " AND B3.D_E_L_E_T_ = ' '  "
			__cQquery := __cQquery + " AND B6_TES > '500' "
			__cQquery := __cQquery + " AND B6_CLIFOR = '"+sb6alias->b6_clifor+"' "
			__cQquery := __cQquery + " AND  B6_PODER3 = 'R' "
			__cQquery := __cQquery + " AND  B3.B6_EMISSAO = '"+p3mov->dataemi+"' "
			__cQquery := __cQquery + " AND B3.B6_PRODUTO = '"+sb6alias->b6_produto+"' "
			__nRem    := 0
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,__cQquery),"P3REM",.T.,.T.)
			__nRem := p3rem->remessa
			p3rem->(dbclosearea())
			__cQquery := ""
			__cQquery := __cQquery + " SELECT COALESCE(SUM(B6_QUANT),0) AS RETORNO  "
			__cQquery := __cQquery + " FROM "+RetSqlName("SB6")+" B1 "
			__cQquery := __cQquery + " WHERE  B6_FILIAL = '"+xfilial("SB6")+"' "
			__cQquery := __cQquery + " AND B1.D_E_L_E_T_ = ' ' "
			__cQquery := __cQquery + " AND B6_TES < '500' "
			__cQquery := __cQquery + " AND B6_CLIFOR = '"+sb6alias->b6_clifor+"' "
			__cQquery := __cQquery + " AND  B6_PODER3 = 'D' "
			__cQquery := __cQquery + " AND  B1.B6_EMISSAO = '"+p3mov->dataemi+"' "
			__cQquery := __cQquery + " AND B1.B6_PRODUTO = '"+sb6alias->b6_produto+"' "
			__nRet    := 0
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,__cQquery),"P3RET",.T.,.T.)
			__nRet := p3ret->retorno
			p3ret->(dbclosearea())
			
			If li > 58 .or. li == 0
				Cabec(Titulo,cCabec1,cCabec2,NomeProg,Tamanho,nTipo)
			Endif
			
			__nSld := __nSld + __nRem - __nRet
			__nEnt := __nEnt + __nRet
			__nSai := __nSai + __nRem 
			@ li,000 PSAY  dtoc(stod(p3mov->dataemi)) + "      " +;
			transform(__nRem,  "@E 99,999,999.99")    + " " +;
			transform(__nRet,  "@E 99,999,999.99")    + " " +;
			transform(__nSld,  "@E 99,999,999.99")
			li++
			p3mov->(dbskip())
		end-while
		@ li,000 PSAY replicate("-",80)
		li++                             
		@ li,000 PSAY "Saldo Final:  "+ transform(__nSai,  "@E 99,999,999.99") + " " +;
		                               transform(__nEnt,  "@E 99,999,999.99") + " " +;
		                               transform(__nSld,  "@E 99,999,999.99")
		li++
		@ li,000 PSAY replicate("-",80)
		li++
		if select("P3MOV") > 0
			p3mov->(dbclosearea())
		endif
		li++
		sb6alias->(dbskip())
	end-while
end-while

if select("SB6ALIAS") > 0
	sb6alias->(dbclosearea())
endif

Set Device to Screen

If aReturn[5] == 1
	Set Printer To
	dbCommitAll()
	OurSpool(WnRel)
Endif

SetPgEject(.F.)

MS_Flush()

Return