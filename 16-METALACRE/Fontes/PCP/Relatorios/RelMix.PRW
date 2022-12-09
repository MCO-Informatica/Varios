#include 'protheus.ch'
#include 'tbiconn.ch'
#include 'topconn.ch'
#include 'fileio.ch'
#INCLUDE "rwmake.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RelMix     º Autor ³ Felipe Barreto  º Data ³  25/04/18    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio de Mix, de Grupos.                               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

user function RelMix()
local oReport
local cAlias := getNextAlias()
Private cPerg := ""



oReport := reportDef(cAlias)

oReport:printDialog()

return  
          
//+-----------------------------------------------------------------------------------------------+
//! Rotina para montagem dos dados do relat?io.                                  !
//+-----------------------------------------------------------------------------------------------+
Static Function ReportPrint(oReport,cAlias)
Local oSecao1 := oReport:Section(1)

cQuery := "     SELECT * "
cQuery += "		FROM " + RetSqlName("PWJ") + " PWJ "
cQuery += "		WHERE PWJ.D_E_L_E_T_ = '' "
cQuery += "		ORDER BY PWJ_COD "

dbUseArea(.t.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.F.,.T.)

Count To nReg

oSecao1:EndQuery()  
oReport:SetMeter(nReg)  
(cAlias)->(dbGoTop())

oSec1	:= oReport:Section(1)
oSec1:Init()
While !Eof()
	oReport:IncMeter()
	
	oSec1:PrintLine()

	(cAlias)->(dbSkip())

End
oSec1:Finish()

(cAlias)->(dbCloseArea())
return

//+-----------------------------------------------------------------------------------------------+
//! Fun?o para cria?o da estrutura do relat?io.                                                !
//+-----------------------------------------------------------------------------------------------+
Static Function ReportDef(cAlias,cLoteFat)

local cTitle  := "Relatorio de Mix de Grupos"
local cHelp   := "Permite gerar relatoio de Mix de Grupos"

local oReport
local oSection1

oReport	:= TReport():New('RELMIX',cTitle,cPerg,{|oReport|ReportPrint(oReport,cAlias)},cHelp)

//Primeira se?o
oSection1 := TRSection():New(oReport,"Mix",{"PWJ"})    

TRCell():New(oSection1,"PWJ_COD"	,cAlias,RetTitle("PWJ_COD"	    )	    ,"@!"	      ,TamSx3("PWJ_COD"	    )[1],/*lPixel*/,{|| (cAlias)->PWJ_COD    })
TRCell():New(oSection1,"PWJ_DESCR"	,cAlias,RetTitle("PWJ_DESCR"	)		,"@!"	      ,TamSx3("PWJ_DESCR"	)[1],/*lPixel*/,{|| (cAlias)->PWJ_DESCR   })
TRCell():New(oSection1,"PWJ_GRUPOS"	,cAlias,RetTitle("PWJ_GRUPOS"   )		,"@!"	      ,TamSx3("PWJ_GRUPOS"  )[1],/*lPixel*/,{|| (cAlias)->PWJ_GRUPOS })

Return(oReport)


