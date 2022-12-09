#include 'protheus.ch'
#include 'tbiconn.ch'
#include 'topconn.ch'
#include 'fileio.ch'
#INCLUDE "rwmake.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RelEmb     º Autor ³ Felipe Barreto  º Data ³  25/04/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio de Cadastro de Embalagens                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

user function RelEmb()
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
cQuery += "		FROM " + RetSqlName("Z05") + " Z05 "
cQuery += "		WHERE Z05.D_E_L_E_T_ = '' "
cQuery += "		ORDER BY Z05_COD "

dbUseArea(.t.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.F.,.T.)

TcSetField( cAlias	, "Z05_PESOEM"	, "N", 12, 4 )             

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

local cTitle  := "Cadastro de Embalagens"
local cHelp   := "Permite gerar relatoio de Cadastro de Embalagens"

local oReport
local oSection1

oReport	:= TReport():New('RELEMB',cTitle,cPerg,{|oReport|ReportPrint(oReport,cAlias)},cHelp)

//Primeira se?o
oSection1 := TRSection():New(oReport,"Embalagens",{"Z05"})    

TRCell():New(oSection1,"Z05_COD"	,cAlias,RetTitle("Z05_COD"	    )	    ,"@!"	        ,TamSx3("Z05_COD"	)[1],/*lPixel*/,{|| (cAlias)->Z05_COD       })
TRCell():New(oSection1,"Z05_DESC"	,cAlias,RetTitle("Z05_DESC"		)		,"@!"	        ,TamSx3("Z05_DESC"	)[1],/*lPixel*/,{|| (cAlias)->Z05_DESC      })
TRCell():New(oSection1,"Z05_PESOEM"	,cAlias,RetTitle("Z05_PESOEM"	)		,"@E 9,999,999.999"	,TamSx3("Z05_PESOEM")[1],/*lPixel*/,{|| (cAlias)->Z05_PESOEM    })

Return(oReport)

