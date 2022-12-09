#include "rwmake.ch"
#include "topconn.ch"
#Include "Totvs.ch"
#include "Ap5Mail.ch"
#Include 'Protheus.ch'
#Include 'rwmake.ch'
#include 'COLORS.CH'
/**
* @Classe - Planilha Orcamentaria
* @author Gesse Santos
* @Out 01 2014
* translate(CT1_E06DSC,'âàãáÁÂÀÃéêÉÊíÍóôõÓÔÕüúÜÚÇç','aaaaAAAAeeEEiIoooOOOuuUUCc')
*/

User Function CSPCO006()
local cPerg   := "CSPCO00602"
LOCAL aParamBox := {}
LOCAL bOk := {|| .T.}
LOCAL aButtons := {}
LOCAL lCentered := .T.
local cTitulo := "Planilha Orcamentaria"
LOCAL nPosx
LOCAL nPosy
LOCAL cLoad := "CSPCO00602"
LOCAL lCanSave := .T.
LOCAL lUserSave := .T.
LOCAL dData	 := dDataBase
Local aAux          := {}
Local __cQry := ""
Local cTpMv := ""
Static aPergRet := {}


AADD(aParamBox,{1,"Planilha/Simulacao"  ,	Space(15)    			,	"",	   		"",		,	"", 50,	.F.	})
AADD(aParamBox,{1,"Revisao           "  ,	Space(04)    			,	"",	   		"",		,	"", 50,	.F.	})

lRet := ParamBox(aParamBox, cTitulo, aPergRet, bOk, aButtons, lCentered, nPosx,nPosy,, cLoad, lCanSave, lUserSave)
if lRet
	__cQry := ""
	__cQry := BuildQ()
	MsgRun("Planilha Orcamentaria - Exportando lancamentos orcamentarios..." ,,{|| procPCO(__cQry) })
	alert("Planilha gerada corretamente!")
endif
return()

//---------------------------------------------------------
static function procPCO(cQryAtu)
Local aStru    := {}
Local aColsTmp := {}
Local i
cQryAtu := ChangeQuery(cQryAtu)
If !Empty(Select("TRB"))
	dbSelectArea("TRB")
	dbCloseArea()
Endif
cQryAtu := ChangeQuery(cQryAtu)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQryAtu),"TRB",.F.,.F.)
dbSelectArea("TRB")
aStru  := trb->(dbStruct())
For nX :=  1 To Len(aStru)
	If aStru[nX][2] == "N"
		TcSetField("TRB",aStru[nX][1],aStru[nX][2],17,2)
	EndIf
Next nX

dbSelectArea("TRB")
dbGoTop()

aLinhaExc := {}
aCabecExc := {}
aItensExc := {}

aadd(aCabecExc,"Sequencia") //1
aadd(aCabecExc,"Planilha") //2
aadd(aCabecExc,"Versao") //3
aadd(aCabecExc,"Historico") //4
aadd(aCabecExc,"Conta") //5
aadd(aCabecExc,"C.Custo") //6
aadd(aCabecExc,"Item Contabil") //7
aadd(aCabecExc,"Classe Valor") //8
aadd(aCabecExc,"Classe") //9
aadd(aCabecExc,"Operacao") //10
aadd(aCabecExc,"Ag. Negocio")  //11
aadd(aCabecExc,"Atividade") //12
aadd(aCabecExc,"Produto") //13
aadd(aCabecExc,"Canal") //14
aadd(aCabecExc,"Tp. Despesa") //15
aadd(aCabecExc,"Janeiro") //16
aadd(aCabecExc,"Fevereiro") //17
aadd(aCabecExc,"Marco") //18
aadd(aCabecExc,"Abril") //19
aadd(aCabecExc,"Maio") //20
aadd(aCabecExc,"Junho") //21
aadd(aCabecExc,"Julho") //22
aadd(aCabecExc,"Agosto") //23
aadd(aCabecExc,"Setembro") //24
aadd(aCabecExc,"Outubro") //25
aadd(aCabecExc,"Novembro") //26
aadd(aCabecExc,"Dezembro") //27

while !trb->(eof())
	
	aadd(aLinhaExc,TRB->AK2_ID) //1
	aadd(aLinhaExc,TRB->AK2_ORCAME) //2
	aadd(aLinhaExc,TRB->AK2_VERSAO) //3
	aadd(aLinhaExc,TRB->AK2_DESCRI) //4
	aadd(aLinhaExc,TRB->AK2_CO) //5
	aadd(aLinhaExc,TRB->AK2_CC) //6
	aadd(aLinhaExc,TRB->AK2_ITCTB) //7
	aadd(aLinhaExc,TRB->AK2_CLVLR) //8
	aadd(aLinhaExc,TRB->AK2_CLASSE)  //9
	aadd(aLinhaExc,TRB->AK2_OPER) //10
	aadd(aLinhaExc,TRB->AK2_ENT05) //11
	aadd(aLinhaExc,TRB->AK2_ENT06) //12
	aadd(aLinhaExc,TRB->AK2_ENT07) //13
	aadd(aLinhaExc,TRB->AK2_ENT08) //14
	aadd(aLinhaExc,TRB->AK2_ENT09) //15
	aadd(aLinhaExc,Transform(TRB->AK2_01,"@E 999,999,999.99")) //16
	aadd(aLinhaExc,Transform(TRB->AK2_02,"@E 999,999,999.99"))  //17
	aadd(aLinhaExc,Transform(TRB->AK2_03,"@E 999,999,999.99"))  //18
	aadd(aLinhaExc,Transform(TRB->AK2_04,"@E 999,999,999.99"))   //19
	aadd(aLinhaExc,Transform(TRB->AK2_05,"@E 999,999,999.99"))// 20
	aadd(aLinhaExc,Transform(TRB->AK2_06,"@E 999,999,999.99"))  //21
	aadd(aLinhaExc,Transform(TRB->AK2_07,"@E 999,999,999.99"))   //22
	aadd(aLinhaExc,Transform(TRB->AK2_08,"@E 999,999,999.99"))   //23
	aadd(aLinhaExc,Transform(TRB->AK2_09,"@E 999,999,999.99"))   //24
	aadd(aLinhaExc,Transform(TRB->AK2_10,"@E 999,999,999.99"))    //25
	aadd(aLinhaExc,Transform(TRB->AK2_11,"@E 999,999,999.99"))	//26
	aadd(aLinhaExc,Transform(TRB->AK2_12,"@E 999,999,999.99"))  //27
	
	aadd(aItensExc,aLinhaExc) // adiciona a linha aos itens
	aLinhaExc := {} //zera linha
	
	trb->(dbskip())
end-while

processa({||DlgToExcel({ {"ARRAY","Planilha Orcamentaria", aCabecExc,aItensExc} }) }, "Planilha Orcamentaria","Aguarde, exportando orcamento para Excel...",.T.)

dbCloseArea()
dbSelectArea("AKD")
return()

//--------------------------------------
Static function BuildQ()
Local __cQry := ""
Local __cAno := ""
ak1->(dbsetorder(1))
ak1->(dbseek(xfilial("AK1") + mv_par01, .t. )) 
__cAno := strzero(year(ak1->ak1_iniper),4)
__cQry := __cQry + " SELECT  DISTINCT AK2_ID, AK2_ORCAME, AK2_VERSAO, AK2_DESCRI, AK2_CO, AK2_CC, AK2_ITCTB, AK2_CLVLR, AK2_CLASSE, "
__cQry := __cQry + " AK2_OPER, AK2_ENT05, AK2_ENT06, AK2_ENT07, AK2_ENT08, AK2_ENT09, "
for __i := 1 to 12
	__cQry := __cQry + " ( SELECT AK2_VALOR  FROM "+RetSqlName("AK2")+" A01
	__cQry := __cQry + "         WHERE  A01.D_E_L_E_T_ = ' '
	__cQry := __cQry + "         AND    A01.AK2_FILIAL = '"+xfilial("AK2")+"' "
	__cQry := __cQry + "         AND    A01.AK2_ORCAME = A0.AK2_ORCAME       "
	__cQry := __cQry + "         AND    A01.AK2_VERSAO = A0.AK2_VERSAO       "
	__cQry := __cQry + "         AND    A01.AK2_ID     = A0.AK2_ID           "
	__cQry := __cQry + "         AND    A01.AK2_PERIOD   BETWEEN '"+__cAno+strzero(__i,2)+"00'  AND  '"+__cAno+strzero(__i,2)+"ZZ' "
	__cQry := __cQry + "         AND    A01.AK2_CC     = A0.AK2_CC           "
	__cQry := __cQry + "         AND    A01.AK2_ITCTB  = A0.AK2_ITCTB        "
	__cQry := __cQry + "         AND    A01.AK2_CLVLR  = A0.AK2_CLVLR        "       
	__cQry := __cQry + "         AND    A01.AK2_CO     = A0.AK2_CO )    AS AK2_"+strzero(__i,2)+", "
next __i
__cQry := __cQry + " AK2_FILIAL
__cQry := __cQry + " FROM "+RetSqlName("AK2")+"  A0 "
__cQry := __cQry + " WHERE  "
__cQry := __cQry + " AK2_FILIAL = '"+xfilial("AK2")+"'    AND "
__cQry := __cQry + " AK2_ORCAME = '"+alltrim(mv_par01)+"' AND "
__cQry := __cQry + " AK2_VERSAO = '"+alltrim(mv_par02)+"' AND "
__cQry := __cQry + " D_E_L_E_T_ = ' '  ORDER BY AK2_ORCAME, AK2_ID "
 memowrite("c:\pco\qryOrcamento.txt",__cQry)
Return(__cQry)

