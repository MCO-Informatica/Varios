#include 'protheus.ch'
#include 'parmtype.ch'
#include "rwmake.ch"
#include "topconn.ch"
#include "Ap5Mail.ch"
#Include 'rwmake.ch'
#include 'COLORS.CH'
#include 'tbiconn.ch'
#INCLUDE "TOTVS.CH"

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ?CSPCO002 ?Autor ?Joao Goncalves de Oliveira ?Data ?11/08/14 ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri??o ?Gera Relatório Razão Orçado x Realizado em Formato Excel 	   ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ?U_CSPCO002()                  				          		   ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros?Nenhum 														   ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±³ Retorno   ?Nenhum												   		   ³±?
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CSPCO002()

Local aParamBox := {}
Local bConfGrav := {|| .T.}
Local aButtPara := {}
Local lCentPara := .T.
Local cTituRoti := "Extracao de Dados - Orçado x Realizado"
Local nPosiHori
Local nPosiVert
Local cLoadPerg := "CSPCO002"
Local lSalvPara := .T.
Local lUserSave := .T.
Local cTipoMovi := ""
Local cTipoResu := ""
Local lExecManu := .T.
Local nTamaCont := TamSX3('CT1_CONTA')[1]
Local cContInic := "120601001"
Local cContFina := "130455002"
Local nDifeTama := nTamaCont -Len(cContInic)
Local cQuryRela := ""
Local aListPara := {}
Local lEncoDupl := .F.
Local cArqLck := GetPathSemaforo() + 'cspco002' + '.lck' //Pasta de sem¨¢foro + Nome da rotina => cspco002.lck
Local nHandle := 0

Static aPergReto := {}
Private bBuscArqu := {|| CSPCO02T()}

If .NOT. PCOSemaforo( @cArqLck, @nHandle )
	Return
Endif

aAdd(aParamBox,{1,"Pasta para Gravacao do Arquivo",Padr("",150),"@!","IIf(Empty(mv_par01),Eval(bBuscArqu),mv_par01)",,"",120,.T.})
aAdd(aParamBox,{1,"Data Inicial",CTOD(Space(8)),"","","","",50,.F.}) // Tipo data
aAdd(aParamBox,{1,"Data Final " ,CTOD(Space(8)),"","","","",50,.F.}) // Tipo data
aAdd(aParamBox,{2,"Tipo de Contas ",1, {"Despesas","Receitas","Capex","Todas"} , 50, '.T.', .T.})
aAdd(aParamBox,{2,"Tipo Movimento",2, {"Orçado","Realizado"}  , 50, '.T.', .T.})
aAdd(aParamBox,{2,"Base de Dados",2,{"View","Relatório"}  , 50, '.T.', .T.})
aAdd(aParamBox,{2,"Regrava Dados do Período",1,{"Sim","Nao"}  , 50, '.T.', .T.})
aAdd(aParamBox,{2,"Reprocessa Excecoes ",2, {"Sim","Não"}  , 50, '.T.', .T.})
aAdd(aParamBox,{2,"Gera Planilha Relatório",1, {"Sim","Não"}  , 50, '.T.', .T.})
aAdd(aParamBox,{2,"Formato Planilha",2, {"XML","CSV"}  , 50, '.T.', .T.})
aAdd(aParamBox,{1,"Inicial Capex",cContInic + Space(nDifeTama),,"Substr(mv_par11,1,1) == '1'","CT1",".T.",50,.T.})
aAdd(aParamBox,{1,"Final Capex" ,cContFina + Space(nDifeTama),,"Substr(mv_par12,1,1) == '1'","CT1",".T.",50,.T.})
aAdd(aParamBox,{1,"Inicial Receitas",'3        ' + Space(nDifeTama),,"Substr(mv_par13,1,1) == '3'","CT1",".T.",50,.T.})
aAdd(aParamBox,{1,"Final Receitas" ,'3ZZZZZZZZ' + Space(nDifeTama),,"Substr(mv_par14,1,1) == '3'","CT1",".T.",50,.T.})
aAdd(aParamBox,{1,"Inicial Despesas",'4        ' + Space(nDifeTama),,"Substr(mv_par15,1,1) >= '4' .And. Substr(mv_par15,1,1) <= '7'","CT1",".T.",50,.T.})
aAdd(aParamBox,{1,"Final Despesas" ,'7ZZZZZZZZ' + Space(nDifeTama),,"Substr(mv_par16,1,1) >= '4' .And. Substr(mv_par16,1,1) <= '7'","CT1",".T.",50,.T.})
aAdd(aParamBox,{2,"Revisão Orçamentária",1, {"Última","Todas"} , 50, '.T.', .T.})
aAdd(aParamBox,{2,"Multi-Threads",1, {"Sim","Não"} , 50, '.T.', .T.})

If ParamBox(aParamBox, cTituRoti, aPergReto, bConfGrav, aButtPara, lCentPara, nPosiHori,nPosiVert,, cLoadPerg, lSalvPara, lUserSave)
	For nContItem := 1 to Len(aParamBox)
		If aParamBox[nContItem,1] == 2 .And. ValType(&("mv_par"+StrZero(nContItem,2))) <> "N"
			&("mv_par"+StrZero(nContItem,2)) := aScan(aParamBox[nContItem,4],&("mv_par"+StrZero(nContItem,2)))
		EndIf
	Next
	
	cTipoMovi := IIf(mv_par05 == 2,"R","O")
	cTipoResu := IIf(mv_par04 == 3,"C",IIf(mv_par04 == 1,"D",IIf(mv_par04 == 2,"R","T")))
	
	If ! GetMv( "MV_CAPEXIN", .T. )
		CriarSX6( "MV_CAPEXIN", 'C', 'Conta Inicial para os Dados Capex no PCO da Certisign - Rotina CSPCO010.prw', "120601001" + Space(nDifeTama) )
	Endif
	cContInic := GetMv("MV_CAPEXIN")
	
	If ! GetMv( "MV_CAPEXFI", .T. )
		CriarSX6( "MV_CAPEXFI", 'C', 'Conta Final para os Dados Capex no PCO da Certisign - Rotina CSPCO010.prw', "130455002" + Space(nDifeTama) )
	Endif
	cContFina := GetMv("MV_CAPEXFI")
	
	If mv_par06 == 1
		cTabeGrav := "CSPCO010_" + StrZero(Year(mv_par02),4)
		cRefeInic := "CSPCO10"
	Else
		cTabeGrav := "CSPCO002_" + StrZero(Year(mv_par02),4)
		cRefeInic := "CSPCO02"
		
		If mv_par07 == 1
			If TcCanOpen(cTabeGrav)
				TcSqlExec("DELETE FROM " + cTabeGrav + " WHERE DATALCT BETWEEN '" + DTOS(mv_par02) + "' AND '" + DTOS(mv_par03) + "'")
			EndIf
		EndIf
	EndIf
	
	Processa({|| U_CSPCO02A(.T.,cTabeGrav)},"Criando Estrutura da Tabela de Gravação...")
	Processa({|| U_CSPCO02L(.T.,cRefeInic)},"Apagando Tabelas Anteriormente Geradas ...")
	
	dDataInic := mv_par02
	dDataFina := mv_par03
	
	If mv_par05 <> 1
		For nContItem := dDataInic to dDataFina
			aAdd(aListPara,{DTOS(dDataInic),DTOS(dDataInic)})
			dDataInic ++
		Next
	Else
		aAdd(aListPara,{DTOS(dDataInic),DTOS(dDataFina)})
	EndIf
	
	For nContItem := 1 to Len(aListPara)
		If mv_par07 == 1
			Processa({|| U_CSPCO02D(cEmpAnt,cFilAnt,aListPara[nContItem,1],aListPara[nContItem,2],.T.,cTabeGrav)},"Orcado x Real - Excluindo lançamentos alterados após o processamento anterior... - De: " + DTOC(STOD(aListPara[nContItem,1])) + " a " + DTOC(STOD(aListPara[nContItem,2])))
			Processa({|| U_CSPCO02B(cTipoResu,aListPara[nContItem,1],aListPara[nContItem,2],cTipoMovi,cTabeGrav,.T.,cContInic,cContFina,@cQuryRela)},"Orcado x Real - Selecionando Dados para o Arquivo Temporário ... - De: " + DTOC(STOD(aListPara[nContItem,1])) + " a " + DTOC(STOD(aListPara[nContItem,2])))
			Processa({|| U_CSPCO02C(cEmpAnt,cFilAnt,aListPara[nContItem,1],aListPara[nContItem,2],.T.,cTabeGrav,cQuryRela,cTipoResu,cTipoMovi,mv_par06)},"Orcado x Real - Gerando Dados no Arquivo Temporário ... - De: " + DTOC(STOD(aListPara[nContItem,1])) + " a " + DTOC(STOD(aListPara[nContItem,2])))
			Processa({|| U_CSPCO02L(.T.,cRefeInic)},"Apagando Tabelas Geradas na Rotina ...")
		EndIf
	Next
	
	If (mv_par07 == 1 .Or. mv_par08 == 1) .And. Mv_par05 == 2
		Processa({|| U_CSPCO02W(lExecManu,cTabeGrav,DTOS(mv_par02),DTOS(mv_par03))},"Orcado x Real - Atualizando Excecoes nas Entidades... ")
	EndIf
	
	If mv_par09 == 1
		Processa({|| CSPCO02S(cTipoResu,cTipoMovi,cTabeGrav,IIf(mv_par10 == 1,"XML","CSV"))},"Gerando Planilha com Movimentações")
	EndIf
EndIf

FClose( nHandle )
FErase( cArqLck )

If GetMv( 'MV_PCO_01', .T. ) //Existe?
	PutMv( 'MV_PCO_01', '' ) //Mude o conteúdo para vazio.
Endif

Return

/******
 *
 * Rotina: Fazer controle de semáforo.
 * Autor.: Robson Gonçalves.
 * Data..: 25/08/2017
 *
 */
Static Function PCOSemaforo( cArqLck, nHandle )
	Local cMV_PCO_01 := 'MV_PCO_01'
	Local lReturn := .T.
	If .NOT. GetMv( cMV_PCO_01, .T. )
		CriarSX6( cMV_PCO_01, 'C', 'NOME DO USUARIO QUE ESTA UTILIZANDO A ROTINA CSPCO002.prw', '' )
	Endif
	MakeDir( GetPathSemaforo() )
	If File( cArqLck )
		If ( nHandle := FOpen( cArqLck, 16 ) ) < 0
			lReturn := .F.
		Endif
	Else
		If ( nHandle := FCreate( cArqLck ) ) < 0
			lReturn := .F.
		Endif
	Endif
	If .NOT. lReturn
		cMV_PCO_01 := GetMv( cMV_PCO_01, .F. )
		MsgAlert('Esta rotina está sendo executada pelo usuário '+ cMV_PCO_01 +'. Aguarde o fim do processamento.', 'Semáforo de processamento')
	Else
		PutMv( 'MV_PCO_01', Upper( RTrim( cUserName ) ) )
	Endif
Return( lReturn )

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ?CSPCO02A ?Autor ?Joao Goncalves de Oliveira ?Data ?10/07/15 ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri??o ?Gera Estrutura da Tabela para Gravacao dos Dados caso ainda nao ³±?
±±?         ?exista 														   ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ?U_CSPCO02A(ExpL1,ExpC2)									       ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros?ExpL2 - Verifica se a execução ?manual ou através de Job 	   ³±?
±±?         ?ExpC2 - Tabela de Gravacao dos Dados 						   ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±³ Retorno   ?Nenhum												   		   ³±?
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CSPCO02A(lExecManu,cTabeGrav)

Local aCampos := {}

If ! TcCanOpen(cTabeGrav)
	
	aAdd( aCampos,{'ATIVIDADE' ,'C',TamSX3('CT1_ENT06') [1],0}) //25
	aAdd( aCampos,{'DESCRATV'  ,'C',TamSX3('CT1_E06DSC')[1],0}) //40
	aAdd( aCampos,{'DATALCT'   ,'D',TamSX3('CV1_DTFIM') [1],0}) //8
	aAdd( aCampos,{'LOTE'      ,'C',TamSX3('CV1_ORCMTO')[1],0}) //6
	aAdd( aCampos,{'CONTA'     ,'C',TamSX3('CV1_CT1FIM')[1],0}) //20
	aAdd( aCampos,{'DESCCTA'   ,'C',TamSX3('CT1_DESC01')[1],0}) //40
	aAdd( aCampos,{'VALOR'     ,'N',TamSX3('CV1_VALOR')[1],2})  //17,2
	aAdd( aCampos,{'NOME_FORNE','C',60,0})
	aAdd( aCampos,{'CODIGO'    ,'C',9,0})
	aAdd( aCampos,{'CNPJ'      ,'C',14,0})
	aAdd( aCampos,{'HIST'      ,'C',TamSX3('CV1_DESCIT')[1],0}) // 80
	aAdd( aCampos,{'CLASSDSP'  ,'C',TamSX3('CV1_E09FIM')[1],0}) // 25
	aAdd( aCampos,{'TPITEM'    ,'C',TamSX3('CV0_DESC')[1],0}) // 25
	aAdd( aCampos,{'CCUSTO'    ,'C',TamSX3('CV1_CTTFIM')[1],0}) // 9
	aAdd( aCampos,{'DESCCC'    ,'C',TamSX3('CTT_DESC01')[1],0}) // 40
	aAdd( aCampos,{'CRESULT'   ,'C',TamSX3('CV1_CTDFIM')[1],0}) // 9
	aAdd( aCampos,{'DSCRES '   ,'C',TamSX3('CTD_DESC01')[1],0}) // 40
	aAdd( aCampos,{'PRJTO'     ,'C',TamSX3('CV1_CTHFIM')[1],0}) // 9
	aAdd( aCampos,{'DPRJ'      ,'C',TamSX3('CTH_DESC01')[1],0}) // 40
	aAdd( aCampos,{'CLAS'      ,'C',9,0})
	aAdd( aCampos,{'MODELO'    ,'C',8,0})
	aAdd( aCampos,{'REC'       ,'N',15,0})
	aAdd( aCampos,{'SEQUEN'    ,'C',TamSX3('CT2_SEQUEN')[1],0}) //10
	aAdd( aCampos,{'ORIGEM'    ,'C',7,0})
	aAdd( aCampos,{'CPROD'     ,'C',TamSX3('CV1_E07FIM')[1],0})
	aAdd( aCampos,{'DPROD'     ,'C',TamSX3('Z1_DESCSEG')[1],0})
	aAdd( aCampos,{'CCANAL'    ,'C',TamSX3('CV1_E08FIM')[1],0})
	aAdd( aCampos,{'DCANAL'    ,'C',TamSX3('Z2_CANAL')[1],0})
	aAdd( aCampos,{'PEDIDO'    ,'C',TamSX3('D1_PEDIDO')[1],0})
	aAdd( aCampos,{'ITEMPED'   ,'C',TamSX3('D1_ITEMPC')[1],0})
	aAdd( aCampos,{'CONTRATO'  ,'C',TamSX3('C7_CONTRA')[1],0})
	aAdd( aCampos,{'REVCONTR'  ,'C',TamSX3('C7_CONTREV')[1],0})
	aAdd( aCampos,{'FILMEDICAO','C',TamSX3('C7_FILIAL')[1],0})
	aAdd( aCampos,{'MEDICAO'   ,'C',TamSX3('C7_MEDICAO')[1],0})
	aAdd( aCampos,{'ITEMED'    ,'C',TamSX3('C7_ITEMED')[1],0})
	aAdd( aCampos,{'PLANILHA'  ,'C',TamSX3('C7_PLANILH')[1],0})
	aAdd( aCampos,{'DATAGRV'   ,'D',TamSX3('CV1_DTFIM') [1],0}) //8
	aAdd( aCampos,{'DETALHE'   ,'C',100,0})
	aAdd( aCampos,{'REVISAO'   ,'C',3,0})
	aAdd( aCampos,{'FLAG_CONTA','C',2,0})
	aAdd( aCampos,{'COMPETENCI','C',TamSX3('CND_COMPET')[1],0})	

	MsCreate( cTabeGrav, aCampos)
	Sleep(1000)
	
EndIf
Return


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ?CSPCO02B ?Autor ?Joao Goncalves de Oliveira ?Data ?10/07/15 ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri??o ?Gera Query com os Dados para Processamento 					   ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ?U_CSPCO02B()                  				          		   ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros?ExpC1 - Tipo da /Conta de Resultado (Receita ou Despesa)	   	   ³±?
±±?		s?ExpC2 - Data Inicial de Processamento 						   ³±?
±±?		s?ExpC3 - Data Inicial de Processamento 						   ³±?
±±?		s?ExpC4 - Tipo de Relatório (Orçado ou Realizado)				   ³±?
±±?		s?ExpC5 - Tabela de Gravação 									   ³±?
±±?		s?ExpC6 - Determina se a execução ?manual Tabela de Gravação 	   ³±?
±±?		s?ExpC7 - Conta Inicial para Dados Ativo Permanente (Capex)       ³±?
±±?		s?ExpC8 - Conta Final para Dados Ativo Permanente (Capex)         ³±?
±±?		s?ExpC9 - String com a query para execução 				       ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±³ Retorno   ?Nenhum												   		   ³±?
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
/±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CSPCO02B(cTipoResu,cDataInic,cDataFina,cTipoRela,cTabeGrav,lExecManu,cContInic,cContFina,cQuryRela)

Local cNomeView := ""

Local cQuryList := ""
Local cSufiView := Substr(cTabeGrav,1,5) + Substr(cTabeGrav,7,2)
Local cRefeInic := cSufiView + "R"


If cTipoRela$"OA"
	cViewOrca := cSufiView + "R" + GetNextAlias()
	While TcCanOpen(cViewOrca)
		cViewOrca := cSufiView + "R" + GetNextAlias()
	End
	
	cQuryRela := " CREATE"
	cQuryRela += " TABLE " + cViewOrca + " AS ("
	
	// Capex Orçado
	If cTipoResu$"CT"
		//cQuryRela += " SELECT CT1_ENT06 AS ATIVIDADE"
		cQuryRela += " SELECT CV1_E06FIM AS ATIVIDADE"
		cQuryRela += " , NVL(CV0_06.CV0_DESC,'" + Space(TamSX3('CV0_DESC')[1]) + "') AS DESCRATV"
		cQuryRela += " , CV1_DTFIM AS DATALCT"
		cQuryRela += " , CV1_ORCMTO AS LOTE"
		cQuryRela += " , CV1_REVISA AS REVISAO"
		cQuryRela += " , CV1_CT1FIM AS CONTA"
		cQuryRela += " , NVL(CT1_DESC01,'" + Space(TamSX3('CT1_DESC01')[1]) + "') AS DESCCTA"
		cQuryRela += " , CV1_VALOR AS VALOR"
		cQuryRela += " , '" + Space(60) + "' AS NOME_FORNE"
		cQuryRela += " , '" + Space(08) + "' AS CODIGO"
		cQuryRela += " , '" + Space(14) + "' AS CNPJ"
		cQuryRela += " , CV1_DESCIT AS HIST"
		cQuryRela += " , CV1_E09FIM AS CLASSDSP"
		cQuryRela += " , NVL(CV0_09.CV0_DESC,'" + Space(TamSX3('CV0_DESC')[1]) + "') AS TPITEM"
		cQuryRela += " , CV1_CTTFIM AS CCUSTO"
		cQuryRela += " , NVL(CTT_DESC01,'" + Space(TamSX3('CTT_DESC01')[1]) + "') AS DESCCC"
		cQuryRela += " , CV1_CTDFIM AS CRESULT"
		cQuryRela += " , NVL(CTD_DESC01,'" + Space(TamSX3('CTD_DESC01')[1]) + "') AS DSCRES"
		cQuryRela += " , CV1_CTHFIM AS PRJTO"
		cQuryRela += " , NVL(CTH_DESC01,'" + Space(TamSX3('CTH_DESC01')[1]) + "') AS DPRJ"
		cQuryRela += " , 'Orcado' AS CLAS"
		cQuryRela += " , 'Capex' AS MODELO"
		cQuryRela += " , CV1.R_E_C_N_O_ AS REC"
		cQuryRela += " , '00000' AS SEQUEN"
		cQuryRela += " , 'Credito' AS ORIGEM"
		cQuryRela += " , CV1_E07FIM AS CPROD"
		cQuryRela += " , '" + Space(TamSX3('Z1_DESCSEG')[1]) + "' AS DPROD"
		cQuryRela += " , CV1_E08FIM AS CCANAL"
		cQuryRela += " , '" + Space(TamSX3('Z2_CANAL')[1])   + "' AS DCANAL"
		cQuryRela += " , '" + Space(TamSX3('D1_PEDIDO')[1]) + "' AS PEDIDO"
		cQuryRela += " , '" + Space(TamSX3('D1_ITEMPC')[1]) + "' AS ITEMPED"
		cQuryRela += " , '" + Space(TamSX3('C7_CONTRA')[1]) + "' AS CONTRATO"
		cQuryRela += " , '" + Space(TamSX3('C7_CONTREV')[1]) + "' AS REVCONTR"
		cQuryRela += " , '" + Space(TamSX3('C7_FILENT')[1]) + "' AS FILMEDICAO"
		cQuryRela += " , '" + Space(TamSX3('C7_MEDICAO')[1]) + "' AS MEDICAO"
		cQuryRela += " , '" + Space(TamSX3('CND_COMPET')[1]) + "' AS COMPETENCI"
		cQuryRela += " , '" + Space(TamSX3('C7_ITEMED')[1])  + "' AS ITEMED"
		cQuryRela += " , '" + Space(TamSX3('C7_PLANILH')[1]) + "' AS PLANILHA"
		cQuryRela += " , NVL(CT1.CT1_DETPCO,'" + Space(TamSX3('CT1_DETPCO')[1]) + "') AS CT1_DETPCO"
		cQuryRela += " , '" + Space(TamSX3("A2_DETPCO")[1]) + "' AS A2_DETPCO"
		cQuryRela += " FROM " + RetSqlName("CV1") + " CV1"
		cQuryRela += " INNER JOIN " + RetSqlName("CV2") + " CV2 ON CV2_FILIAL = CV1_FILIAL"
		cQuryRela += " AND CV2_ORCMTO = CV1_ORCMTO AND CV2_CALEND = CV1_CALEND"
		cQuryRela += " AND CV2_MOEDA = CV1_MOEDA AND CV2_REVISA = CV1_REVISA"
		cQuryRela += " AND CV2_MSBLQL <> '1' AND CV2.D_E_L_E_T_ = ' '"
		cQuryRela += " LEFT JOIN " + RetSqlName("CT1") + " CT1 ON CT1_FILIAL = '" + xfilial("CT1") + "'"
		cQuryRela += " AND CV1_CT1FIM = CT1_CONTA"
		cQuryRela += " AND CT1.D_E_L_E_T_ = ' '"
		cQuryRela += " LEFT JOIN " + RetSqlName("CV0") + " CV0_06 ON CV0_06.CV0_FILIAL = '" + xfilial("CV0") + "'"
		cQuryRela += " AND CV0_06.CV0_PLANO = '06'"
		cQuryRela += " AND CV1_E06FIM = CV0_06.CV0_CODIGO"
		cQuryRela += " AND CV0_06.D_E_L_E_T_ = ' '"
		cQuryRela += " LEFT JOIN " + RetSqlName("CV0") + " CV0_09 ON CV0_09.CV0_FILIAL = '" + xfilial("CV0") + "'"
		cQuryRela += " AND CV0_09.CV0_PLANO = '09'"
		cQuryRela += " AND CV1_E09FIM = CV0_09.CV0_CODIGO"
		cQuryRela += " AND CV0_09.CV0_CODIGO <> '" + Space(TamSX3("CV0_CODIGO")[1]) + "'"
		cQuryRela += " AND CV0_09.D_E_L_E_T_ = ' '"
		cQuryRela += " LEFT JOIN " + RetSqlName("CTT") + " CTT ON CTT_FILIAL = '" + xfilial("CTT") + "'"
		cQuryRela += " AND CV1_CTTFIM = CTT_CUSTO"
		cQuryRela += " AND CTT.D_E_L_E_T_ = ' '"
		cQuryRela += " LEFT JOIN " + RetSqlName("CTD") + " CTD ON CTD_FILIAL = '" + xfilial("CTD") + "'"
		cQuryRela += " AND CV1_CTDFIM = CTD_ITEM"
		cQuryRela += " AND CTD.D_E_L_E_T_ = ' '"
		cQuryRela += " LEFT JOIN " + RetSqlName("CTH") + " CTH ON CTH_FILIAL = '" + xfilial("CTH") + "'"
		cQuryRela += " AND CV1_CTHFIM = CTH_CLVL"
		cQuryRela += " AND CTH.D_E_L_E_T_ = ' '"
		cQuryRela += " WHERE CV1_FILIAL = '" + xfilial("CV1") + "'"
		cQuryRela += " AND CV1_DTFIM BETWEEN '" + cDataInic + "' AND '" + cDataFina + "'"
		cQuryRela += " AND SUBSTR(CV1_CT1FIM,1,1) = '1'
		cQuryRela += " AND CV1.D_E_L_E_T_ = ' '"
		cQuryRela += " AND CV1.R_E_C_N_O_ NOT IN"
		cQuryRela += " (SELECT REC FROM " + cTabeGrav + " WHERE CLAS = 'Orcado'"
		cQuryRela += " AND DATALCT BETWEEN '" + cDataInic + "' AND '" + cDataFina + "'"
		cQuryRela += " AND D_E_L_E_T_ = ' ')"
	EndIf
	
	If cTipoResu == "T"
		cQuryRela += " UNION ALL"
	EndIf
	
	// Receitas Orçadas
	If cTipoResu$"RT"
		//cQuryRela += " SELECT CT1_ENT06 AS ATIVIDADE"
		cQuryRela += " SELECT CV1_E06FIM AS ATIVIDADE"
		cQuryRela += " , NVL(CV0_06.CV0_DESC,'" + Space(TamSX3('CV0_DESC')[1]) + "') AS DESCRATV"
		cQuryRela += " , CV1_DTFIM AS DATALCT"
		cQuryRela += " , CV1_ORCMTO AS LOTE"
		cQuryRela += " , CV1_REVISA AS REVISAO"
		cQuryRela += " , CV1_CT1FIM AS CONTA"
		cQuryRela += " , NVL(CT1_DESC01,'" + Space(TamSX3('CT1_DESC01')[1]) + "') AS DESCCTA"
		cQuryRela += " , CV1_VALOR AS VALOR"
		cQuryRela += " , '" + Space(60) + "' AS NOME_FORNE"
		cQuryRela += " , '" + Space(08) + "' AS CODIGO"
		cQuryRela += " , '" + Space(14) + "' AS CNPJ"
		cQuryRela += " , CV1_DESCIT AS HIST"
		cQuryRela += " , CV1_E09FIM AS CLASSDSP"
		cQuryRela += " , NVL(CV0_09.CV0_DESC,'" + Space(TamSX3('CV0_DESC')[1]) + "') AS TPITEM"
		cQuryRela += " , CV1_CTTFIM AS CCUSTO"
		cQuryRela += " , NVL(CTT_DESC01,'" + Space(TamSX3('CTT_DESC01')[1]) + "') AS DESCCC"
		cQuryRela += " , CV1_CTDFIM AS CRESULT"
		cQuryRela += " , NVL(CTD_DESC01,'" + Space(TamSX3('CTD_DESC01')[1]) + "') AS DSCRES"
		cQuryRela += " , CV1_CTHFIM AS PRJTO"
		cQuryRela += " , NVL(CTH_DESC01,'" + Space(TamSX3('CTH_DESC01')[1]) + "') AS DPRJ"
		cQuryRela += " , 'Orcado' AS CLAS"
		cQuryRela += " , 'Receitas' AS MODELO"
		cQuryRela += " , CV1.R_E_C_N_O_ AS REC"
		cQuryRela += " , '00000' AS SEQUEN"
		cQuryRela += " , 'Credito' AS ORIGEM"
		cQuryRela += " , CV1_E07FIM AS CPROD"
		cQuryRela += " , '" + Space(TamSX3('Z1_DESCSEG')[1]) + "' AS DPROD"
		cQuryRela += " , CV1_E08FIM AS CCANAL"
		cQuryRela += " , '" + Space(TamSX3('Z2_CANAL')[1])   + "' AS DCANAL"
		cQuryRela += " , '" + Space(TamSX3('D1_PEDIDO')[1]) + "' AS PEDIDO"
		cQuryRela += " , '" + Space(TamSX3('D1_ITEMPC')[1]) + "' AS ITEMPED"
		cQuryRela += " , '" + Space(TamSX3('C7_CONTRA')[1]) + "' AS CONTRATO"
		cQuryRela += " , '" + Space(TamSX3('C7_CONTREV')[1]) + "' AS REVCONTR"
		cQuryRela += " , '" + Space(TamSX3('C7_FILENT')[1]) + "' AS FILMEDICAO"
		cQuryRela += " , '" + Space(TamSX3('C7_MEDICAO')[1]) + "' AS MEDICAO"
		cQuryRela += " , '" + Space(TamSX3('CND_COMPET')[1]) + "' AS COMPETENCI"
		cQuryRela += " , '" + Space(TamSX3('C7_ITEMED')[1])  + "' AS ITEMED"
		cQuryRela += " , '" + Space(TamSX3('C7_PLANILH')[1]) + "' AS PLANILHA"
		cQuryRela += " , NVL(CT1.CT1_DETPCO,'" + Space(TamSX3('CT1_DETPCO')[1]) + "') AS CT1_DETPCO"
		cQuryRela += " , '" + Space(TamSX3("A2_DETPCO")[1]) + "' AS A2_DETPCO"
		cQuryRela += " FROM " + RetSqlName("CV1") + " CV1"
		cQuryRela += " INNER JOIN " + RetSqlName("CV2") + " CV2 ON CV2_FILIAL = CV1_FILIAL"
		cQuryRela += " AND CV2_ORCMTO = CV1_ORCMTO AND CV2_CALEND = CV1_CALEND"
		cQuryRela += " AND CV2_MOEDA = CV1_MOEDA AND CV2_REVISA = CV1_REVISA"
		cQuryRela += " AND CV2_MSBLQL <> '1' AND CV2.D_E_L_E_T_ = ' '"
		cQuryRela += " LEFT JOIN " + RetSqlName("CT1") + " CT1 ON CT1_FILIAL = '" + xfilial("CT1") + "'"
		cQuryRela += " AND CV1_CT1FIM = CT1_CONTA"
		cQuryRela += " AND CT1.D_E_L_E_T_ = ' '"
		cQuryRela += " LEFT JOIN " + RetSqlName("CV0") + " CV0_06 ON CV0_06.CV0_FILIAL = '" + xfilial("CV0") + "'"
		cQuryRela += " AND CV0_06.CV0_PLANO = '06'"
		cQuryRela += " AND CV1_E06FIM = CV0_06.CV0_CODIGO"
		cQuryRela += " AND CV0_06.D_E_L_E_T_ = ' '"
		cQuryRela += " LEFT JOIN " + RetSqlName("CV0") + " CV0_09 ON CV0_09.CV0_FILIAL = '" + xfilial("CV0") + "'"
		cQuryRela += " AND CV0_09.CV0_PLANO = '09'"
		cQuryRela += " AND CV1_E09FIM = CV0_09.CV0_CODIGO"
		cQuryRela += " AND CV0_09.CV0_CODIGO <> '" + Space(TamSX3("CV0_CODIGO")[1]) + "'"
		cQuryRela += " AND CV0_09.D_E_L_E_T_ = ' '"
		cQuryRela += " LEFT JOIN " + RetSqlName("CTT") + " CTT ON CTT_FILIAL = '" + xfilial("CTT") + "'"
		cQuryRela += " AND CV1_CTTFIM = CTT_CUSTO"
		cQuryRela += " AND CTT.D_E_L_E_T_ = ' '"
		cQuryRela += " LEFT JOIN " + RetSqlName("CTD") + " CTD ON CTD_FILIAL = '" + xfilial("CTD") + "'"
		cQuryRela += " AND CV1_CTDFIM = CTD_ITEM"
		cQuryRela += " AND CTD.D_E_L_E_T_ = ' '"
		cQuryRela += " LEFT JOIN " + RetSqlName("CTH") + " CTH ON CTH_FILIAL = '" + xfilial("CTH") + "'"
		cQuryRela += " AND CV1_CTHFIM = CTH_CLVL"
		cQuryRela += " AND CTH.D_E_L_E_T_ = ' '"
		cQuryRela += " WHERE CV1_FILIAL = '" + xfilial("CV1") + "'"
		cQuryRela += " AND CV1_DTFIM BETWEEN '" + cDataInic + "' AND '" + cDataFina + "'"
		cQuryRela += " AND (CV1_E07FIM <> '" + Space(TamSX3('CV1_E07FIM')[1]) + "'"
		cQuryRela += " OR SUBSTR(CV1_CT1FIM,1,1) = '3')
		cQuryRela += " AND CV1.D_E_L_E_T_ = ' '"
		cQuryRela += " AND CV1.R_E_C_N_O_ NOT IN"
		cQuryRela += " (SELECT REC FROM " + cTabeGrav + " WHERE CLAS = 'Orcado'"
		cQuryRela += " AND DATALCT BETWEEN '" + cDataInic + "' AND '" + cDataFina + "'"
		cQuryRela += " AND D_E_L_E_T_ = ' ')"
	EndIf
	
	If cTipoResu == "T"
		cQuryRela += " UNION ALL"
	EndIf
	
	// Despesas Orçadas
	If cTipoResu $"DT"
		//cQuryRela += " SELECT CT1_ENT06 AS ATIVIDADE"
		cQuryRela += " SELECT CV1_E06FIM AS ATIVIDADE"
		cQuryRela += " , NVL(CV0_06.CV0_DESC,'" + Space(TamSX3('CV0_DESC')[1]) + "') AS DESCRATV"
		cQuryRela += " , CV1_DTFIM AS DATALCT"
		cQuryRela += " , CV1_ORCMTO AS LOTE"
		cQuryRela += " , CV1_REVISA AS REVISAO"
		cQuryRela += " , CV1_CT1FIM AS CONTA"
		cQuryRela += " , NVL(CT1_DESC01,'" + Space(TamSX3('CT1_DESC01')[1]) + "') AS DESCCTA"
		cQuryRela += " , CV1_VALOR AS VALOR"
		cQuryRela += " , '" + Space(60) + "' AS NOME_FORNE"
		cQuryRela += " , '" + Space(08) + "' AS CODIGO"
		cQuryRela += " , '" + Space(14) + "' AS CNPJ"
		cQuryRela += " , CV1_DESCIT AS HIST"
		cQuryRela += " , CV1_E09FIM AS CLASSDSP"
		cQuryRela += " , NVL(CV0_09.CV0_DESC,'" + Space(TamSX3('CV0_DESC')[1]) + "') AS TPITEM"
		cQuryRela += " , CV1_CTTFIM AS CCUSTO"
		cQuryRela += " , NVL(CTT_DESC01,'" + Space(TamSX3('CTT_DESC01')[1]) + "') AS DESCCC"
		cQuryRela += " , CV1_CTDFIM AS CRESULT"
		cQuryRela += " , NVL(CTD_DESC01,'" + Space(TamSX3('CTD_DESC01')[1]) + "') AS DSCRES"
		cQuryRela += " , CV1_CTHFIM AS PRJTO"
		cQuryRela += " , NVL(CTH_DESC01,'" + Space(TamSX3('CTH_DESC01')[1]) + "') AS DPRJ"
		cQuryRela += " , 'Orcado' AS CLAS"
		cQuryRela += " , 'Despesas' AS MODELO"
		cQuryRela += " , CV1.R_E_C_N_O_ AS REC"
		cQuryRela += " , '00000' AS SEQUEN"
		cQuryRela += " , 'Debito' AS ORIGEM"
		cQuryRela += " , CV1_E07FIM AS CPROD"
		cQuryRela += " , '" + Space(TamSX3('Z1_DESCSEG')[1]) + "' AS DPROD"
		cQuryRela += " , CV1_E08FIM AS CCANAL"
		cQuryRela += " , '" + Space(TamSX3('Z2_CANAL')[1])   + "' AS DCANAL"
		cQuryRela += " , '" + Space(TamSX3('D1_PEDIDO')[1]) + "' AS PEDIDO"
		cQuryRela += " , '" + Space(TamSX3('D1_ITEMPC')[1]) + "' AS ITEMPED"
		cQuryRela += " , '" + Space(TamSX3('C7_CONTRA')[1]) + "' AS CONTRATO"
		cQuryRela += " , '" + Space(TamSX3('C7_CONTREV')[1]) + "' AS REVCONTR"
		cQuryRela += " , '" + Space(TamSX3('C7_FILENT')[1]) + "' AS FILMEDICAO"
		cQuryRela += " , '" + Space(TamSX3('C7_MEDICAO')[1]) + "' AS MEDICAO"
		cQuryRela += " , '" + Space(TamSX3('CND_COMPET')[1]) + "' AS COMPETENCI"
		cQuryRela += " , '" + Space(TamSX3('C7_ITEMED')[1])  + "' AS ITEMED"
		cQuryRela += " , '" + Space(TamSX3('C7_PLANILH')[1]) + "' AS PLANILHA"
		cQuryRela += " , NVL(CT1.CT1_DETPCO,'" + Space(TamSX3('CT1_DETPCO')[1]) + "') AS CT1_DETPCO"
		cQuryRela += " , '" + Space(TamSX3("A2_DETPCO")[1]) + "' AS A2_DETPCO"
		cQuryRela += " FROM " + RetSqlName("CV1") + " CV1"
		cQuryRela += " INNER JOIN " + RetSqlName("CV2") + " CV2 ON CV2_FILIAL = CV1_FILIAL"
		cQuryRela += " AND CV2_ORCMTO = CV1_ORCMTO AND CV2_CALEND = CV1_CALEND"
		cQuryRela += " AND CV2_MOEDA = CV1_MOEDA AND CV2_REVISA = CV1_REVISA"
		cQuryRela += " AND CV2_MSBLQL <> '1' AND CV2.D_E_L_E_T_ = ' '"
		cQuryRela += " LEFT JOIN " + RetSqlName("CT1") + " CT1 ON CT1_FILIAL = '" + xfilial("CT1") + "'"
		cQuryRela += " AND CV1_CT1FIM = CT1_CONTA"
		cQuryRela += " AND CT1.D_E_L_E_T_ = ' '"
		cQuryRela += " LEFT JOIN " + RetSqlName("CV0") + " CV0_06 ON CV0_06.CV0_FILIAL = '" + xfilial("CV0") + "'"
		cQuryRela += " AND CV0_06.CV0_PLANO = '06'"
		cQuryRela += " AND CV1_E06FIM = CV0_06.CV0_CODIGO"
		cQuryRela += " AND CV0_06.D_E_L_E_T_ = ' '"
		cQuryRela += " LEFT JOIN " + RetSqlName("CV0") + " CV0_09 ON CV0_09.CV0_FILIAL = '" + xfilial("CV0") + "'"
		cQuryRela += " AND CV0_09.CV0_PLANO = '09'"
		cQuryRela += " AND CV1_E09FIM = CV0_09.CV0_CODIGO"
		cQuryRela += " AND CV0_09.CV0_CODIGO <> '" + Space(TamSX3("CV0_CODIGO")[1]) + "'"
		cQuryRela += " AND CV0_09.D_E_L_E_T_ = ' '"
		cQuryRela += " LEFT JOIN " + RetSqlName("CTT") + " CTT ON CTT_FILIAL = '" + xfilial("CTT") + "'"
		cQuryRela += " AND CV1_CTTFIM = CTT_CUSTO"
		cQuryRela += " AND CTT.D_E_L_E_T_ = ' '"
		cQuryRela += " LEFT JOIN " + RetSqlName("CTD") + " CTD ON CTD_FILIAL = '" + xfilial("CTD") + "'"
		cQuryRela += " AND CV1_CTDFIM = CTD_ITEM"
		cQuryRela += " AND CTD.D_E_L_E_T_ = ' '"
		cQuryRela += " LEFT JOIN " + RetSqlName("CTH") + " CTH ON CTH_FILIAL = '" + xfilial("CTH") + "'"
		cQuryRela += " AND CV1_CTHFIM = CTH_CLVL"
		cQuryRela += " AND CTH.D_E_L_E_T_ = ' '"
		cQuryRela += " WHERE CV1_FILIAL = '" + xfilial("CV1") + "'"
		cQuryRela += " AND CV1_DTFIM BETWEEN '" + cDataInic + "' AND '" + cDataFina + "'"
		cQuryRela += " AND SUBSTR(CV1_CT1FIM,1,1) IN ('4','5','6','7')
		cQuryRela += " AND CV1.D_E_L_E_T_ = ' '"
		cQuryRela += " AND CV1.R_E_C_N_O_ NOT IN"
		cQuryRela += " (SELECT REC FROM " + cTabeGrav + " WHERE CLAS = 'Orcado'"
		cQuryRela += " AND DATALCT BETWEEN '" + cDataInic + "' AND '" + cDataFina + "'"
		cQuryRela += " AND D_E_L_E_T_ = ' ')"
	EndIf
	cQuryRela += ")"
	
	If ! U_CSPCO10N(cQuryRela,"na selecao dos registros orçados de planejamento",lExecManu)
		Return
	EndIf
EndIf


If 	cTipoRela$"RA"
	
	//Realizado x Origem do Lançamento Contábil - Despesas/Receitas
	If cTipoResu$"RDT"
		cViewRel1 := cSufiView + "I" + "D" + GetNextAlias()
		While TcCanOpen(cViewRel1)
			cViewRel1 := cSufiView + "I" + " D" + GetNextAlias()
		End
		
		cQuryRela := " CREATE"
		cQuryRela += " TABLE " + cViewRel1 + " AS ("
		
		cQuryRela += " SELECT DISTINCT"
		cQuryRela += " CT1_ENT06 AS ATIVIDADE"
		cQuryRela += " , NVL(CV0_06.CV0_DESC,'" + Space(TamSX3('CV0_DESC')[1]) + "') AS DESCRATV"
		cQuryRela += " , CT2_DATA AS DATALCT"
		cQuryRela += " , CT2_LOTE  AS LOTE"
		cQuryRela += " , '" + Space(TamSX3('CV1_REVISA')[1]) + "' AS REVISAO"
		cQuryRela += " , CT2_CREDIT AS CONTA"
		cQuryRela += " , NVL(CT1_DESC01,'" + Space(TamSX3('CT1_DESC01')[1]) + "') AS DESCCTA"
		cQuryRela += " , CASE WHEN SUBSTR(CT2_CREDIT,1,1) < '4' THEN CT2_VALOR"
		cQuryRela += "        ELSE CT2_VALOR * -1 END VALOR"
		cQuryRela += " , CASE WHEN SUBSTR(CT2_ROTINA,1,7) = 'GPEM110' THEN 'FOLHA'"
		cQuryRela += "        WHEN CV3_LP = '" + Space(3) + "' THEN NVL((SELECT A2_NOME FROM " + RetSqlName("SA2") + " SA2 WHERE A2_FILIAL = '" + xfilial("SA2") + "' AND A2_COD = SUBSTR(CT2_HIST,1,6) AND ROWNUM <= 1),'LANCAMENTO MANUAL')"
		cQuryRela += "        WHEN CV3_LP < '500' THEN NVL((SELECT A2_NOME FROM " + RetSqlName("SA2") + " SA2 WHERE A2_FILIAL = '" + xfilial("SA2") + "' AND A2_COD = SUBSTR(CT2_HIST,1,6) AND ROWNUM <= 1),'IMPORTACAO TXT')"
		cQuryRela += "        WHEN CV3_LP > '499' THEN 'LANCAMENTO MANUAL'"
		cQuryRela += "        ELSE NVL((SELECT A2_NOME FROM " + RetSqlName("SA2") + " SA2 WHERE A2_FILIAL = '" + xfilial("SA2") + "' AND A2_COD = SUBSTR(CT2_HIST,1,6) AND ROWNUM <= 1),'LANCAMENTO MANUAL') END NOME_FORNE"
		cQuryRela += " , CASE WHEN CV3_LP = '" + Space(3) + "' THEN NVL((SELECT A2_COD FROM " + RetSqlName("SA2") + " SA2 WHERE A2_FILIAL = '" + xfilial("SA2") + "' AND A2_COD = SUBSTR(CT2_HIST,1,6) AND ROWNUM <= 1),'" + Space(TamSX3("A2_COD")[1]) + "')"
		cQuryRela += "        WHEN CV3_LP < '500' THEN NVL((SELECT A2_COD FROM " + RetSqlName("SA2") + " SA2 WHERE A2_FILIAL = '" + xfilial("SA2") + "' AND A2_COD = SUBSTR(CT2_HIST,1,6) AND ROWNUM <= 1),'" + Space(TamSX3("A2_COD")[1]) + "')"
		cQuryRela += "        WHEN CV3_LP > '499' THEN '" + Space(TamSX3("A2_COD")[1]) + "'"
		cQuryRela += "        ELSE NVL((SELECT A2_COD||A2_LOJA FROM " + RetSqlName("SA2") + " SA2 WHERE A2_FILIAL = '" + xfilial("SA2") + "' AND A2_COD = SUBSTR(CT2_HIST,1,6) AND ROWNUM <= 1),'" + Space(TamSX3("A2_COD")[1] + TamSX3("A2_LOJA")[1]) + "') END CODIGO"
		//cQuryRela += " , '" + Space(TamSX3("A2_CGC")[1]) + "' AS CNPJ"
		cQuryRela += " , NVL((SELECT A2_CGC FROM " + RetSqlName("SA2") + " SA2 WHERE A2_FILIAL = '" + xfilial("SA2") + "' AND A2_COD = SUBSTR(CT2_HIST,1,6) AND ROWNUM <= 1),'" + Space(TamSX3("A2_CGC")[1]) + "') CNPJ"		
		cQuryRela += " , CT2_HIST AS HIST"
		cQuryRela += " , CASE WHEN SUBSTR(CT2_CREDIT,1,1) = '3' THEN '" + Space(TamSX3('CV1_E09FIM')[1]) + "' ELSE 'DA' END CLASSDSP"
		cQuryRela += " , CASE WHEN SUBSTR(CT2_CREDIT,1,1) = '3' THEN '" + Space(TamSX3('CV0_DESC')[1])
		cQuryRela += "'       ELSE NVL(CV0_09.CV0_DESC,'" + Space(TamSX3('CV0_DESC')[1]) + "') END TPITEM"
		cQuryRela += " , CT2_CCC AS CCUSTO"
		cQuryRela += " , NVL(CTT_DESC01,'" + Space(TamSX3('CTT_DESC01')[1]) + "') AS DESCCC"
		cQuryRela += " , CT2_ITEMC  AS CRESULT"
		cQuryRela += " , NVL(CTD_DESC01,'" + Space(TamSX3('CTD_DESC01')[1]) + "') AS DSCRES"
		cQuryRela += " , CT2_CLVLCR AS PRJTO"
		cQuryRela += " , NVL(CTH_DESC01,'" + Space(TamSX3('CTH_DESC01')[1]) + "') AS DPRJ"
		cQuryRela += " , 'Realizado' AS CLAS"
		cQuryRela += " , CASE WHEN SUBSTR(CT2_CREDIT,1,1) = '3' THEN 'Receitas'"
		cQuryRela += "        ELSE 'Despesas' END MODELO"
		cQuryRela += " , CT2.R_E_C_N_O_ AS REC"
		cQuryRela += " , CT2.CT2_SEQUEN AS SEQUEN"
		cQuryRela += " , 'Credito' AS ORIGEM"
		cQuryRela += " , '" + Space(TamSX3('CV1_E07FIM')[1]) + "' AS CPROD"
		cQuryRela += " , '" + Space(TamSX3('Z1_DESCSEG')[1]) + "' AS DPROD"
		cQuryRela += " , '" + Space(TamSX3('CV1_E08FIM')[1]) + "' AS CCANAL"
		cQuryRela += " , '" + Space(TamSX3('Z2_CANAL')[1])   + "' AS DCANAL"
		cQuryRela += " , '" + Space(TamSX3('D1_PEDIDO')[1]) + "' AS PEDIDO"
		cQuryRela += " , '" + Space(TamSX3('D1_ITEMPC')[1]) + "' AS ITEMPED"
		cQuryRela += " , '" + Space(TamSX3('C7_CONTRA')[1]) + "' AS CONTRATO"
		cQuryRela += " , '" + Space(TamSX3('C7_CONTREV')[1]) + "' AS REVCONTR"
		cQuryRela += " , '" + Space(TamSX3('C7_FILENT')[1]) + "' AS FILMEDICAO"
		cQuryRela += " , '" + Space(TamSX3('C7_MEDICAO')[1]) + "' AS MEDICAO"
		cQuryRela += " , '" + Space(TamSX3('CND_COMPET')[1]) + "' AS COMPETENCI"
		cQuryRela += " , '" + Space(TamSX3('C7_ITEMED')[1])  + "' AS ITEMED"
		cQuryRela += " , '" + Space(TamSX3('C7_PLANILH')[1]) + "' AS PLANILHA"
		cQuryRela += " , NVL(CV3_TABORI,'" + Space(TamSX3('CV3_TABORI')[1]) + "') AS TABORI"
		cQuryRela += " , NVL(CV3_LP,'" + Space(TamSX3('CV3_LP')[1]) + "') AS LANPAD"
		cQuryRela += " , NVL(CV3_RECORI,'" + Space(TamSX3('CV3_RECORI')[1]) + "') AS RECORI"
		cQuryRela += " , CT2_FILORI AS FILORI"
		cQuryRela += " , NVL(CT1.CT1_DETPCO,'" + Space(TamSX3('CT1_DETPCO')[1]) + "') AS CT1_DETPCO"
		cQuryRela += " , '" + Space(TamSX3("A2_DETPCO")[1]) + "' AS A2_DETPCO"
		cQuryRela += " FROM " + RetSqlName("CT2") + " CT2"
		cQuryRela += " LEFT OUTER JOIN " + RetSqlName("CT1") + " CT1"
		cQuryRela += " ON CT1_FILIAL = '" + xfilial("CT1") + "'"
		cQuryRela += " AND CT1_CONTA = CT2_CREDIT AND CT1.D_E_L_E_T_ = ' '"
		cQuryRela += " LEFT JOIN " + RetSqlName("CV0") + " CV0_06 ON CV0_06	.CV0_FILIAL = '" + xfilial("CV0") + "'"
		cQuryRela += " AND CV0_06.CV0_PLANO = '06'"
		cQuryRela += " AND CT1_ENT06 = CV0_06.CV0_CODIGO"
		cQuryRela += " AND CV0_06.D_E_L_E_T_ = ' '"
		cQuryRela += " LEFT JOIN " + RetSqlName("CV0") + " CV0_09 ON CV0_09.CV0_FILIAL = '" + xfilial("CV0") + "'"
		cQuryRela += " AND CV0_09.CV0_PLANO = '09'"
		cQuryRela += " AND 'DA' = CV0_09.CV0_CODIGO"
		cQuryRela += " AND CV0_09.D_E_L_E_T_ = ' '"
		cQuryRela += " LEFT JOIN " + RetSqlName("CTT") + " CTT ON CTT_FILIAL = '" + xfilial("CTT") + "'"
		cQuryRela += " AND CT2_CCC = CTT_CUSTO"
		cQuryRela += " AND CTT.D_E_L_E_T_ = ' '"
		cQuryRela += " LEFT JOIN " + RetSqlName("CTD") + " CTD ON CTD_FILIAL = '" + xfilial("CTD") + "'"
		cQuryRela += " AND CT2_ITEMC = CTD_ITEM"
		cQuryRela += " AND CTD.D_E_L_E_T_ = ' '"
		cQuryRela += " LEFT JOIN " + RetSqlName("CTH") + " CTH ON CTH_FILIAL = '" + xfilial("CTH") + "'"
		cQuryRela += " AND CT2_CLVLCR = CTH_CLVL"
		cQuryRela += " AND CTH.D_E_L_E_T_ = ' '"
		cQuryRela += " LEFT JOIN " + RetSqlName("CV3") + " CV3 ON CV3_FILIAL = '" + xfilial("CT2") + "'"
		cQuryRela += " AND CT2.R_E_C_N_O_ = TO_NUMBER(RTRIM(CV3_RECDES))"
		cQuryRela += " AND CT2_DTCV3 = CV3_DTSEQ AND CT2_SEQUEN = CV3_SEQUEN"
		cQuryRela += " WHERE CT2_FILIAL = '" + xfilial("CT2") + "'"
		cQuryRela += " AND CT2_DATA BETWEEN '" + cDataInic + "' AND '" + cDataFina + "'"
		cQuryRela += " AND CT2_MOEDLC = '01' AND CT1_CLASSE = '2'"
		cQuryRela += " AND CT2_TPSALD = '1'"
		cQuryRela += " AND CT2_LOTE < 'A'"
		If cTipoResu == "R"
			cQuryRela += " AND SUBSTR(CT2_CREDIT,1,1) = '3'"
		ElseIf cTipoResu == "D"
			cQuryRela += " AND SUBSTR(CT2_CREDIT,1,1) IN ('4','5','6','7')"
		Else
			cQuryRela += " AND (SUBSTR(CT2_CREDIT,1,1) IN ('3','4','5','6','7'))"
		EndIf
		cQuryRela += " AND CT2.D_E_L_E_T_ = ' '"
		cQuryRela += " AND CT2.R_E_C_N_O_ NOT IN"
		cQuryRela += " (SELECT REC FROM " + cTabeGrav + " WHERE CLAS = 'Realizado'
		cQuryRela += " AND DATALCT BETWEEN '" + cDataInic + "' AND '" + cDataFina + "'"
		cQuryRela += " AND (MODELO = 'Receitas' OR MODELO = 'Despesas')"
		cQuryRela += " AND D_E_L_E_T_ = ' '"
		If cTipoResu == "R"
			cQuryRela += " AND SUBSTR(CONTA,1,1) = '3'"
		ElseIf cTipoResu == "D"
			cQuryRela += " AND SUBSTR(CONTA,1,1) IN ('4','5','6','7')"
		Else
			cQuryRela += " AND (SUBSTR(CONTA,1,1) IN ('3','4','5','6','7'))"
		EndIf
		cQuryRela += ")"
		cQuryRela += " UNION ALL"
		cQuryRela += " SELECT DISTINCT"
		cQuryRela += " CT1_ENT06 AS ATIVIDADE"
		cQuryRela += " , NVL(CV0_06.CV0_DESC,'" + Space(TamSX3('CV0_DESC')[1]) + "') AS DESCRATV"
		cQuryRela += " , CT2_DATA AS DATALCT"
		cQuryRela += " , CT2_LOTE  AS LOTE"
		cQuryRela += " , '" + Space(TamSX3('CV1_REVISA')[1]) + "' AS REVISAO"
		cQuryRela += " , CT2_DEBITO AS CONTA"
		cQuryRela += " , NVL(CT1_DESC01,'" + Space(TamSX3('CT1_DESC01')[1]) + "') AS DESCCTA"
		cQuryRela += " , CASE WHEN SUBSTR(CT2_DEBITO,1,1) >= '4' THEN CT2_VALOR"
		cQuryRela += "        ELSE CT2_VALOR * -1 END VALOR"
		cQuryRela += " , CASE WHEN SUBSTR(CT2_ROTINA,1,7) = 'GPEM110' THEN 'FOLHA'"
		cQuryRela += "        WHEN CV3_LP = '" + Space(3) + "' THEN NVL((SELECT A2_NOME FROM " + RetSqlName("SA2") + " SA2 WHERE A2_FILIAL = '" + xfilial("SA2") + "' AND A2_COD = SUBSTR(CT2_HIST,1,6) AND ROWNUM <= 1),'LANCAMENTO MANUAL')"
		cQuryRela += "        WHEN CV3_LP > '499' THEN 'LANCAMENTO MANUAL'"
		cQuryRela += "        WHEN CV3_LP < '500' THEN NVL((SELECT A2_NOME FROM " + RetSqlName("SA2") + " SA2 WHERE A2_FILIAL = '" + xfilial("SA2") + "' AND A2_COD = SUBSTR(CT2_HIST,1,6) AND ROWNUM <= 1),'IMPORTACAO TXT')"
		cQuryRela += "        ELSE NVL((SELECT A2_NOME FROM " + RetSqlName("SA2") + " SA2 WHERE A2_FILIAL = '" + xfilial("SA2") + "' AND A2_COD = SUBSTR(CT2_HIST,1,6) AND ROWNUM <= 1),'LANCAMENTO MANUAL') END NOME_FORNE"
		cQuryRela += " , CASE WHEN CV3_LP = '" + Space(3) + "' THEN NVL((SELECT A2_COD FROM " + RetSqlName("SA2") + " SA2 WHERE A2_FILIAL = '" + xfilial("SA2") + "' AND A2_COD = SUBSTR(CT2_HIST,1,6) AND ROWNUM <= 1),'" + Space(TamSX3("A2_COD")[1]) + "')"
		cQuryRela += "        WHEN CV3_LP < '500' THEN NVL((SELECT A2_COD FROM " + RetSqlName("SA2") + " SA2 WHERE A2_FILIAL = '" + xfilial("SA2") + "' AND A2_COD = SUBSTR(CT2_HIST,1,6) AND ROWNUM <= 1),'" + Space(TamSX3("A2_COD")[1]) + "')"
		cQuryRela += "        WHEN CV3_LP > '499' THEN '" + Space(TamSX3("A2_COD")[1]) + "'"
		cQuryRela += "        ELSE NVL((SELECT A2_COD||A2_LOJA FROM " + RetSqlName("SA2") + " SA2 WHERE A2_FILIAL = '" + xfilial("SA2") + "' AND A2_COD = SUBSTR(CT2_HIST,1,6) AND ROWNUM <= 1),'" + Space(TamSX3("A2_COD")[1] + TamSX3("A2_LOJA")[1]) + "') END CODIGO"
		//cQuryRela += " , '" + Space(TamSX3("A2_CGC")[1]) + "' AS CNPJ"
		cQuryRela += " , NVL((SELECT A2_CGC FROM " + RetSqlName("SA2") + " SA2 WHERE A2_FILIAL = '" + xfilial("SA2") + "' AND A2_COD = SUBSTR(CT2_HIST,1,6) AND ROWNUM <= 1),'" + Space(TamSX3("A2_CGC")[1]) + "') CNPJ"		
		cQuryRela += " , CT2_HIST AS HIST"
		cQuryRela += " , CASE WHEN SUBSTR(CT2_DEBITO,1,1) = '3' THEN '" + Space(TamSX3('CV1_E09FIM')[1]) + "' ELSE 'DA' END CLASSDSP"
		cQuryRela += " , CASE WHEN SUBSTR(CT2_DEBITO,1,1) = '3' THEN '" + Space(TamSX3('CV0_DESC')[1]) + "'"
		cQuryRela += "        ELSE NVL(CV0_09.CV0_DESC,'" + Space(TamSX3('CV0_DESC')[1]) + "') END TPITEM"
		cQuryRela += " , CT2_CCD AS CCUSTO"
		cQuryRela += " , NVL(CTT_DESC01,'" + Space(TamSX3('CTT_DESC01')[1]) + "') AS DESCCC"
		cQuryRela += " , CT2_ITEMD  AS CRESULT"
		cQuryRela += " , NVL(CTD_DESC01,'" + Space(TamSX3('CTD_DESC01')[1]) + "') AS DSCRES"
		cQuryRela += " , CT2_CLVLDB AS PRJTO"
		cQuryRela += " , NVL(CTH_DESC01,'" + Space(TamSX3('CTH_DESC01')[1]) + "') AS DPRJ"
		cQuryRela += " , 'Realizado' AS CLAS"
		cQuryRela += " , CASE WHEN SUBSTR(CT2_DEBITO,1,1) >= '4' THEN 'Despesas'"
		cQuryRela += "        ELSE 'Receitas' END MODELO"
		cQuryRela += " , CT2.R_E_C_N_O_ AS REC"
		cQuryRela += " , CT2.CT2_SEQUEN AS SEQUEN"
		cQuryRela += " , 'Debito' AS ORIGEM"
		cQuryRela += " , '" + Space(TamSX3('CV1_E07FIM')[1]) + "' AS CPROD"
		cQuryRela += " , '" + Space(TamSX3('Z1_DESCSEG')[1]) + "' AS DPROD"
		cQuryRela += " , '" + Space(TamSX3('CV1_E08FIM')[1]) + "' AS CCANAL"
		cQuryRela += " , '" + Space(TamSX3('Z2_CANAL')[1])   + "' AS DCANAL"
		cQuryRela += " , '" + Space(TamSX3('D1_PEDIDO')[1]) + "' AS PEDIDO"
		cQuryRela += " , '" + Space(TamSX3('D1_ITEMPC')[1]) + "' AS ITEMPED"
		cQuryRela += " , '" + Space(TamSX3('C7_CONTRA')[1]) + "' AS CONTRATO"
		cQuryRela += " , '" + Space(TamSX3('C7_CONTREV')[1]) + "' AS REVCONTR"
		cQuryRela += " , '" + Space(TamSX3('C7_FILENT')[1]) + "' AS FILMEDICAO"
		cQuryRela += " , '" + Space(TamSX3('C7_MEDICAO')[1]) + "' AS MEDICAO"
		cQuryRela += " , '" + Space(TamSX3('CND_COMPET')[1]) + "' AS COMPETENCI"
		cQuryRela += " , '" + Space(TamSX3('C7_ITEMED')[1])  + "' AS ITEMED"
		cQuryRela += " , '" + Space(TamSX3('C7_PLANILH')[1]) + "' AS PLANILHA"
		cQuryRela += " , NVL(CV3_TABORI,'" + Space(TamSX3('CV3_TABORI')[1]) + "') AS TABORI"
		cQuryRela += " , NVL(CV3_LP,'" + Space(TamSX3('CV3_LP')[1]) + "') AS LANPAD"
		cQuryRela += " , NVL(CV3_RECORI,'" + Space(TamSX3('CV3_RECORI')[1]) + "') AS RECORI"
		cQuryRela += " , CT2_FILORI AS FILORI"
		cQuryRela += " , NVL(CT1.CT1_DETPCO,'" + Space(TamSX3('CT1_DETPCO')[1]) + "') AS CT1_DETPCO"
		cQuryRela += " , '" + Space(TamSX3("A2_DETPCO")[1]) + "' AS A2_DETPCO"
		cQuryRela += " FROM " + RetSqlName("CT2") + " CT2"
		cQuryRela += " LEFT OUTER JOIN " + RetSqlName("CT1") + " CT1"
		cQuryRela += " ON CT1_FILIAL = '" + xfilial("CT1") + "'"
		cQuryRela += " AND CT1_CONTA = CT2_DEBITO AND CT1.D_E_L_E_T_ = ' '"
		cQuryRela += " LEFT JOIN " + RetSqlName("CV0") + " CV0_06 ON CV0_06	.CV0_FILIAL = '" + xfilial("CV0") + "'"
		cQuryRela += " AND CV0_06.CV0_PLANO = '06'"
		cQuryRela += " AND CT1_ENT06 = CV0_06.CV0_CODIGO"
		cQuryRela += " AND CV0_06.D_E_L_E_T_ = ' '"
		cQuryRela += " LEFT JOIN " + RetSqlName("CV0") + " CV0_09 ON CV0_09.CV0_FILIAL = '" + xfilial("CV0") + "'"
		cQuryRela += " AND CV0_09.CV0_PLANO = '09'"
		cQuryRela += " AND 'DA' = CV0_09.CV0_CODIGO"
		cQuryRela += " AND CV0_09.D_E_L_E_T_ = ' '"
		cQuryRela += " LEFT JOIN " + RetSqlName("CTT") + " CTT ON CTT_FILIAL = '" + xfilial("CTT") + "'"
		cQuryRela += " AND 	CT2_CCD = CTT_CUSTO"
		cQuryRela += " AND CTT.D_E_L_E_T_ = ' '"
		cQuryRela += " LEFT JOIN " + RetSqlName("CTD") + " CTD ON CTD_FILIAL = '" + xfilial("CTD") + "'"
		cQuryRela += " AND CT2_ITEMD = CTD_ITEM"
		cQuryRela += " AND CTD.D_E_L_E_T_ = ' '"
		cQuryRela += " LEFT JOIN " + RetSqlName("CTH") + " CTH ON CTH_FILIAL = '" + xfilial("CTH") + "'"
		cQuryRela += " AND CT2_CLVLDB = CTH_CLVL"
		cQuryRela += " AND CTH.D_E_L_E_T_ = ' '"
		cQuryRela += " LEFT JOIN " + RetSqlName("CV3") + " CV3 ON CV3_FILIAL = '" + xfilial("CT2") + "'"
		cQuryRela += " AND CT2.R_E_C_N_O_ = TO_NUMBER(RTRIM(CV3_RECDES))"
		cQuryRela += " AND CT2_DTCV3 = CV3_DTSEQ AND CT2_SEQUEN = CV3_SEQUEN"
		cQuryRela += " WHERE CT2_FILIAL = '" + xfilial("CT2") + "'"
		cQuryRela += " AND CT2_DATA BETWEEN '" + cDataInic + "' AND '" + cDataFina + "'"
		cQuryRela += " AND CT2_MOEDLC = '01' AND CT1_CLASSE = '2'"
		cQuryRela += " AND CT2_LOTE < 'A'"
		cQuryRela += " AND CT2_TPSALD = '1'"
		If cTipoResu == "R"
			cQuryRela += " AND SUBSTR(CT2_DEBITO,1,1) = '3'"
		ElseIf cTipoResu == "D"
			cQuryRela += " AND SUBSTR(CT2_DEBITO,1,1) IN ('4','5','6','7')"
		Else
			cQuryRela += " AND SUBSTR(CT2_DEBITO,1,1) IN ('3','4','5','6','7')"
		EndIf
		cQuryRela += " AND CT2.D_E_L_E_T_ = ' '"
		cQuryRela += " AND CT2.R_E_C_N_O_ NOT IN"
		cQuryRela += " (SELECT REC FROM " + cTabeGrav + " WHERE CLAS = 'Realizado'
		cQuryRela += " AND DATALCT BETWEEN '" + cDataInic + "' AND '" + cDataFina + "'"
		cQuryRela += " AND (MODELO = 'Receitas' OR MODELO = 'Despesas')"
		cQuryRela += " AND D_E_L_E_T_ = ' '"
		If cTipoResu == "R"
			cQuryRela += " AND SUBSTR(CONTA,1,1) = '3'"
		ElseIf cTipoResu == "D"
			cQuryRela += " AND SUBSTR(CONTA,1,1) IN ('4','5','6','7')"
		Else
			cQuryRela += " AND SUBSTR(CONTA,1,1) IN ('3','4','5','6','7')"
		EndIf
		cQuryRela += "))"
		// 1a. Análise
		If ! U_CSPCO10N(cQuryRela,"na selecao da origem dos lancamentos contabeis de despesas/receitas realizados de planejamento",lExecManu)
			Return
		EndIf
	EndIf
	
	//Realizado x Origem do Lançamento Contábil - Capex
	If cTipoResu$"CT"
		cViewRel2 := cSufiView + "I" + "C" + GetNextAlias()
		While TcCanOpen(cViewRel2)
			cViewRel2 := cSufiView + "I" + "C" + GetNextAlias()
		End
		
		cQuryRela := " CREATE"
		cQuryRela += " TABLE " + cViewRel2 + " AS ("
		cQuryRela += " SELECT DISTINCT"
		cQuryRela += " CT1_ENT06 AS ATIVIDADE"
		cQuryRela += " , NVL(CV0_06.CV0_DESC,'" + Space(TamSX3('CV0_DESC')[1]) + "') AS DESCRATV"
		cQuryRela += " , CT2_DATA AS DATALCT"
		cQuryRela += " , CT2_LOTE  AS LOTE"
		cQuryRela += " , '" + Space(TamSX3('CV1_REVISA')[1]) + "' AS REVISAO"
		cQuryRela += " , CT2_CREDIT AS CONTA"
		cQuryRela += " , NVL(CT1_DESC01,'" + Space(TamSX3('CT1_DESC01')[1]) + "') AS DESCCTA"
		cQuryRela += " , CT2_VALOR * -1 AS VALOR"
		cQuryRela += " , CASE WHEN SUBSTR(CT2_ROTINA,1,7) = 'GPEM110' THEN 'FOLHA'"
		cQuryRela += "        WHEN CV3_LP = '" + Space(3) + "' THEN NVL((SELECT A2_NOME FROM " + RetSqlName("SA2") + " SA2 WHERE A2_FILIAL = '" + xfilial("SA2") + "' AND A2_COD = SUBSTR(CT2_HIST,1,6) AND ROWNUM <= 1),'LANCAMENTO MANUAL')"
		cQuryRela += "        WHEN CV3_LP > '499' THEN 'LANCAMENTO MANUAL'"
		cQuryRela += "        WHEN CV3_LP < '500' THEN NVL((SELECT A2_NOME FROM " + RetSqlName("SA2") + " SA2 WHERE A2_FILIAL = '" + xfilial("SA2") + "' AND A2_COD = SUBSTR(CT2_HIST,1,6) AND ROWNUM <= 1),'IMPORTACAO TXT')"
		cQuryRela += "        ELSE NVL((SELECT A2_NOME FROM " + RetSqlName("SA2") + " SA2 WHERE A2_FILIAL = '" + xfilial("SA2") + "' AND A2_COD = SUBSTR(CT2_HIST,1,6) AND ROWNUM <= 1),'LANCAMENTO MANUAL') END NOME_FORNE"
		cQuryRela += " , CASE WHEN CV3_LP = '" + Space(3) + "' THEN NVL((SELECT A2_COD FROM " + RetSqlName("SA2") + " SA2 WHERE A2_FILIAL = '" + xfilial("SA2") + "' AND A2_COD = SUBSTR(CT2_HIST,1,6) AND ROWNUM <= 1),'" + Space(TamSX3("A2_COD")[1]) + "')"
		cQuryRela += "        WHEN CV3_LP < '500' THEN NVL((SELECT A2_COD FROM " + RetSqlName("SA2") + " SA2 WHERE A2_FILIAL = '" + xfilial("SA2") + "' AND A2_COD = SUBSTR(CT2_HIST,1,6) AND ROWNUM <= 1),'" + Space(TamSX3("A2_COD")[1]) + "')"
		cQuryRela += "        WHEN CV3_LP > '499' THEN '" + Space(TamSX3("A2_COD")[1]) + "'"
		cQuryRela += "        ELSE NVL((SELECT A2_COD||A2_LOJA FROM " + RetSqlName("SA2") + " SA2 WHERE A2_FILIAL = '" + xfilial("SA2") + "' AND A2_COD = SUBSTR(CT2_HIST,1,6) AND ROWNUM <= 1),'" + Space(TamSX3("A2_COD")[1] + TamSX3("A2_LOJA")[1]) + "') END CODIGO"
		//cQuryRela += " , '" + Space(TamSX3("A2_CGC")[1]) + "' AS CNPJ"
		cQuryRela += " , NVL((SELECT A2_CGC FROM " + RetSqlName("SA2") + " SA2 WHERE A2_FILIAL = '" + xfilial("SA2") + "' AND A2_COD = SUBSTR(CT2_HIST,1,6) AND ROWNUM <= 1),'" + Space(TamSX3("A2_CGC")[1]) + "') CNPJ"		
		cQuryRela += " , CT2_HIST AS HIST"
		cQuryRela += " , '" + Space(TamSX3('CV1_E09FIM')[1]) + "' AS CLASSDSP"
		cQuryRela += " , '" + Space(TamSX3('CV0_DESC')[1]) + "' AS TPITEM"
		cQuryRela += " , CT2_CCC AS CCUSTO"
		cQuryRela += " , NVL(CTT_DESC01,'" + Space(TamSX3('CTT_DESC01')[1]) + "') AS DESCCC"
		cQuryRela += " , CT2_ITEMC  AS CRESULT"
		cQuryRela += " , NVL(CTD_DESC01,'" + Space(TamSX3('CTD_DESC01')[1]) + "') AS DSCRES"
		cQuryRela += " , CT2_CLVLCR AS PRJTO"
		cQuryRela += " , NVL(CTH_DESC01,'" + Space(TamSX3('CTH_DESC01')[1]) + "') AS DPRJ"
		cQuryRela += " , 'Realizado' AS CLAS"
		cQuryRela += " , 'Capex' AS MODELO"
		cQuryRela += " , CT2.R_E_C_N_O_ AS REC"
		cQuryRela += " , CT2.CT2_SEQUEN AS SEQUEN"
		cQuryRela += " , 'Credito' AS ORIGEM"
		cQuryRela += " , '" + Space(TamSX3('CV1_E07FIM')[1]) + "' AS CPROD"
		cQuryRela += " , '" + Space(TamSX3('Z1_DESCSEG')[1]) + "' AS DPROD"
		cQuryRela += " , '" + Space(TamSX3('CV1_E08FIM')[1]) + "' AS CCANAL"
		cQuryRela += " , '" + Space(TamSX3('Z2_CANAL')[1])   + "' AS DCANAL"
		cQuryRela += " , '" + Space(TamSX3('D1_PEDIDO')[1]) + "' AS PEDIDO"
		cQuryRela += " , '" + Space(TamSX3('D1_ITEMPC')[1]) + "' AS ITEMPED"
		cQuryRela += " , '" + Space(TamSX3('C7_CONTRA')[1]) + "' AS CONTRATO"
		cQuryRela += " , '" + Space(TamSX3('C7_CONTREV')[1]) + "' AS REVCONTR"
		cQuryRela += " , '" + Space(TamSX3('C7_FILENT')[1]) + "' AS FILMEDICAO"
		cQuryRela += " , '" + Space(TamSX3('C7_MEDICAO')[1]) + "' AS MEDICAO"
		cQuryRela += " , '" + Space(TamSX3('CND_COMPET')[1]) + "' AS COMPETENCI"
		cQuryRela += " , '" + Space(TamSX3('C7_ITEMED')[1])  + "' AS ITEMED"
		cQuryRela += " , '" + Space(TamSX3('C7_PLANILH')[1]) + "' AS PLANILHA"
		cQuryRela += " , NVL(CV3_TABORI,'" + Space(TamSX3('CV3_TABORI')[1]) + "') AS TABORI"
		cQuryRela += " , NVL(CV3_LP,'" + Space(TamSX3('CV3_LP')[1]) + "') AS LANPAD"
		cQuryRela += " , NVL(CV3_RECORI,'" + Space(TamSX3('CV3_RECORI')[1]) + "') AS RECORI"
		cQuryRela += " , CT2_FILORI AS FILORI"
		cQuryRela += " , NVL(CT1.CT1_DETPCO,'" + Space(TamSX3('CT1_DETPCO')[1]) + "') AS CT1_DETPCO"
		cQuryRela += " , '" + Space(TamSX3("A2_DETPCO")[1]) + "' AS A2_DETPCO"
		cQuryRela += " FROM " + RetSqlName("CT2") + " CT2"
		cQuryRela += " INNER JOIN " + RetSqlName("CT1") + " CT1"
		cQuryRela += " ON CT1_FILIAL = '" + xfilial("CT1") + "'"
		cQuryRela += " AND CT1_CONTA = CT2_CREDIT AND CT1.D_E_L_E_T_ = ' '"
		cQuryRela += " LEFT JOIN " + RetSqlName("CV0") + " CV0_06 ON CV0_06	.CV0_FILIAL = '" + xfilial("CV0") + "'"
		cQuryRela += " AND CV0_06.CV0_PLANO = '06'"
		cQuryRela += " AND CT1_ENT06 = CV0_06.CV0_CODIGO"
		cQuryRela += " AND CV0_06.D_E_L_E_T_ = ' '"
		cQuryRela += " LEFT JOIN " + RetSqlName("CV0") + " CV0_09 ON CV0_09.CV0_FILIAL = '" + xfilial("CV0") + "'"
		cQuryRela += " AND CV0_09.CV0_PLANO = '09'"
		cQuryRela += " AND 'DA' = CV0_09.CV0_CODIGO"
		cQuryRela += " AND CV0_09.D_E_L_E_T_ = ' '"
		cQuryRela += " LEFT JOIN " + RetSqlName("CTT") + " CTT ON CTT_FILIAL = '" + xfilial("CTT") + "'"
		cQuryRela += " AND CT2_CCC = CTT_CUSTO"
		cQuryRela += " AND CTT.D_E_L_E_T_ = ' '"
		cQuryRela += " LEFT JOIN " + RetSqlName("CTD") + " CTD ON CTD_FILIAL = '" + xfilial("CTD") + "'"
		cQuryRela += " AND CT2_ITEMC = CTD_ITEM"
		cQuryRela += " AND CTD.D_E_L_E_T_ = ' '"
		cQuryRela += " LEFT JOIN " + RetSqlName("CTH") + " CTH ON CTH_FILIAL = '" + xfilial("CTH") + "'"
		cQuryRela += " AND CT2_CLVLCR = CTH_CLVL"
		cQuryRela += " AND CTH.D_E_L_E_T_ = ' '"
		cQuryRela += " LEFT JOIN " + RetSqlName("CV3") + " CV3 ON CV3_FILIAL = '" + xfilial("CT2") + "'"
		cQuryRela += " AND CT2.R_E_C_N_O_ = TO_NUMBER(RTRIM(CV3_RECDES))"
		cQuryRela += " AND CT2_DTCV3 = CV3_DTSEQ AND CT2_SEQUEN = CV3_SEQUEN"
		cQuryRela += " WHERE CT2_FILIAL = '" + xfilial("CT2") + "'"
		cQuryRela += " AND CT2_DATA BETWEEN '" + cDataInic + "' AND '" + cDataFina + "'"
		cQuryRela += " AND CT2_MOEDLC = '01' AND CT1_CLASSE = '2'"
		cQuryRela += " AND CT2_TPSALD = '1'"
		cQuryRela += " AND CT2_LOTE < 'A'"
		cQuryRela += " AND CT2_CREDIT BETWEEN '" + cContInic + "' AND '" + cContFina + "'"
		cQuryRela += " AND CT2.D_E_L_E_T_ = ' '"
		cQuryRela += " AND CT2.R_E_C_N_O_ NOT IN"
		cQuryRela += " (SELECT REC FROM " + cTabeGrav + " WHERE CLAS = 'Realizado'
		cQuryRela += " AND MODELO = 'Capex'"
		cQuryRela += " AND DATALCT BETWEEN '" + cDataInic + "' AND '" + cDataFina + "'"
		cQuryRela += " AND CONTA BETWEEN '" + cContInic + "' AND '" + cContFina + "'"
		cQuryRela += " AND D_E_L_E_T_ = ' '"
		cQuryRela += ")"
		cQuryRela += " UNION ALL"
		cQuryRela += " SELECT DISTINCT"
		cQuryRela += " CT1_ENT06 AS ATIVIDADE"
		cQuryRela += " , NVL(CV0_06.CV0_DESC,'" + Space(TamSX3('CV0_DESC')[1]) + "') AS DESCRATV"
		cQuryRela += " , CT2_DATA AS DATALCT"
		cQuryRela += " , CT2_LOTE  AS LOTE"
		cQuryRela += " , '" + Space(TamSX3('CV1_REVISA')[1]) + "' AS REVISAO"
		cQuryRela += " , CT2_DEBITO AS CONTA"
		cQuryRela += " , NVL(CT1_DESC01,'" + Space(TamSX3('CT1_DESC01')[1]) + "') AS DESCCTA"
		cQuryRela += " , CT2_VALOR AS VALOR"
		cQuryRela += " , CASE WHEN SUBSTR(CT2_ROTINA,1,7) = 'GPEM110' THEN 'FOLHA'"
		cQuryRela += "        WHEN CV3_LP = '" + Space(3) + "' THEN NVL((SELECT A2_NOME FROM " + RetSqlName("SA2") + " SA2 WHERE A2_FILIAL = '" + xfilial("SA2") + "' AND A2_COD = SUBSTR(CT2_HIST,1,6) AND ROWNUM <= 1),'LANCAMENTO MANUAL')"
		cQuryRela += "        WHEN CV3_LP < '500' THEN NVL((SELECT A2_NOME FROM " + RetSqlName("SA2") + " SA2 WHERE A2_FILIAL = '" + xfilial("SA2") + "' AND A2_COD = SUBSTR(CT2_HIST,1,6) AND ROWNUM <= 1),'IMPORTACAO TXT')"
		cQuryRela += "        WHEN CV3_LP > '499' THEN 'LANCAMENTO MANUAL'"
		cQuryRela += "        ELSE NVL((SELECT A2_NOME FROM " + RetSqlName("SA2") + " SA2 WHERE A2_FILIAL = '" + xfilial("SA2") + "' AND A2_COD = SUBSTR(CT2_HIST,1,6) AND ROWNUM <= 1),'LANCAMENTO MANUAL') END NOME_FORNE"
		cQuryRela += " , CASE WHEN CV3_LP = '" + Space(3) + "' THEN NVL((SELECT A2_COD FROM " + RetSqlName("SA2") + " SA2 WHERE A2_FILIAL = '" + xfilial("SA2") + "' AND A2_COD = SUBSTR(CT2_HIST,1,6) AND ROWNUM <= 1),'" + Space(TamSX3("A2_COD")[1]) + "')"
		cQuryRela += "        WHEN CV3_LP < '500' THEN NVL((SELECT A2_COD FROM " + RetSqlName("SA2") + " SA2 WHERE A2_FILIAL = '" + xfilial("SA2") + "' AND A2_COD = SUBSTR(CT2_HIST,1,6) AND ROWNUM <= 1),'" + Space(TamSX3("A2_COD")[1]) + "')"
		cQuryRela += "        WHEN CV3_LP > '499' THEN '" + Space(TamSX3("A2_COD")[1]) + "'"
		cQuryRela += "        ELSE NVL((SELECT A2_COD||A2_LOJA FROM " + RetSqlName("SA2") + " SA2 WHERE A2_FILIAL = '" + xfilial("SA2") + "' AND A2_COD = SUBSTR(CT2_HIST,1,6) AND ROWNUM <= 1),'" + Space(TamSX3("A2_COD")[1] + TamSX3("A2_LOJA")[1]) + "') END CODIGO"
		//cQuryRela += " , '" + Space(TamSX3("A2_CGC")[1]) + "' AS CNPJ"
		cQuryRela += " , NVL((SELECT A2_CGC FROM " + RetSqlName("SA2") + " SA2 WHERE A2_FILIAL = '" + xfilial("SA2") + "' AND A2_COD = SUBSTR(CT2_HIST,1,6) AND ROWNUM <= 1),'" + Space(TamSX3("A2_CGC")[1]) + "') CNPJ"		
		cQuryRela += " , CT2_HIST AS HIST"
		cQuryRela += " , '" + Space(TamSX3('CV1_E09FIM')[1]) + "' AS CLASSDSP"
		cQuryRela += " , '" + Space(TamSX3('CV0_DESC')[1]) + "' AS TPITEM"
		cQuryRela += " , CT2_CCD AS CCUSTO"
		cQuryRela += " , NVL(CTT_DESC01,'" + Space(TamSX3('CTT_DESC01')[1]) + "') AS DESCCC"
		cQuryRela += " , CT2_ITEMD  AS CRESULT"
		cQuryRela += " , NVL(CTD_DESC01,'" + Space(TamSX3('CTD_DESC01')[1]) + "') AS DSCRES"
		cQuryRela += " , CT2_CLVLDB AS PRJTO"
		cQuryRela += " , NVL(CTH_DESC01,'" + Space(TamSX3('CTH_DESC01')[1]) + "') AS DPRJ"
		cQuryRela += " , 'Realizado' AS CLAS"
		cQuryRela += " , 'Capex' AS MODELO"
		cQuryRela += " , CT2.R_E_C_N_O_ AS REC"
		cQuryRela += " , CT2.CT2_SEQUEN AS SEQUEN"
		cQuryRela += " , 'Debito' AS ORIGEM"
		cQuryRela += " , '" + Space(TamSX3('CV1_E07FIM')[1]) + "' AS CPROD"
		cQuryRela += " , '" + Space(TamSX3('Z1_DESCSEG')[1]) + "' AS DPROD"
		cQuryRela += " , '" + Space(TamSX3('CV1_E08FIM')[1]) + "' AS CCANAL"
		cQuryRela += " , '" + Space(TamSX3('Z2_CANAL')[1])   + "' AS DCANAL"
		cQuryRela += " , '" + Space(TamSX3('D1_PEDIDO')[1]) + "' AS PEDIDO"
		cQuryRela += " , '" + Space(TamSX3('D1_ITEMPC')[1]) + "' AS ITEMPED"
		cQuryRela += " , '" + Space(TamSX3('C7_CONTRA')[1]) + "' AS CONTRATO"
		cQuryRela += " , '" + Space(TamSX3('C7_CONTREV')[1]) + "' AS REVCONTR"
		cQuryRela += " , '" + Space(TamSX3('C7_FILENT')[1]) + "' AS FILMEDICAO"
		cQuryRela += " , '" + Space(TamSX3('C7_MEDICAO')[1]) + "' AS MEDICAO"
		cQuryRela += " , '" + Space(TamSX3('CND_COMPET')[1]) + "' AS COMPETENCI"
		cQuryRela += " , '" + Space(TamSX3('C7_ITEMED')[1])  + "' AS ITEMED"
		cQuryRela += " , '" + Space(TamSX3('C7_PLANILH')[1]) + "' AS PLANILHA"
		cQuryRela += " , NVL(CV3_TABORI,'" + Space(TamSX3('CV3_TABORI')[1]) + "') AS TABORI"
		cQuryRela += " , NVL(CV3_LP,'" + Space(TamSX3('CV3_LP')[1]) + "') AS LANPAD"
		cQuryRela += " , NVL(CV3_RECORI,'" + Space(TamSX3('CV3_RECORI')[1]) + "') AS RECORI"
		cQuryRela += " , CT2_FILORI AS FILORI"
		cQuryRela += " , NVL(CT1.CT1_DETPCO,'" + Space(TamSX3('CT1_DETPCO')[1]) + "') AS CT1_DETPCO"
		cQuryRela += " , '" + Space(TamSX3("A2_DETPCO")[1]) + "' AS A2_DETPCO"
		cQuryRela += " FROM " + RetSqlName("CT2") + " CT2"
		cQuryRela += " INNER JOIN " + RetSqlName("CT1") + " CT1"
		cQuryRela += " ON CT1_FILIAL = '" + xfilial("CT1") + "'"
		cQuryRela += " AND CT1_CONTA = CT2_DEBITO AND CT1.D_E_L_E_T_ = ' '"
		cQuryRela += " LEFT JOIN " + RetSqlName("CV0") + " CV0_06 ON CV0_06	.CV0_FILIAL = '" + xfilial("CV0") + "'"
		cQuryRela += " AND CV0_06.CV0_PLANO = '06'"
		cQuryRela += " AND CT1_ENT06 = CV0_06.CV0_CODIGO"
		cQuryRela += " AND CV0_06.D_E_L_E_T_ = ' '"
		cQuryRela += " LEFT JOIN " + RetSqlName("CV0") + " CV0_09 ON CV0_09.CV0_FILIAL = '" + xfilial("CV0") + "'"
		cQuryRela += " AND CV0_09.CV0_PLANO = '09'"
		cQuryRela += " AND 'DA' = CV0_09.CV0_CODIGO"
		cQuryRela += " AND CV0_09.D_E_L_E_T_ = ' '"
		cQuryRela += " LEFT JOIN " + RetSqlName("CTT") + " CTT ON CTT_FILIAL = '" + xfilial("CTT") + "'"
		cQuryRela += " AND 	CT2_CCD = CTT_CUSTO"
		cQuryRela += " AND CTT.D_E_L_E_T_ = ' '"
		cQuryRela += " LEFT JOIN " + RetSqlName("CTD") + " CTD ON CTD_FILIAL = '" + xfilial("CTD") + "'"
		cQuryRela += " AND CT2_ITEMD = CTD_ITEM"
		cQuryRela += " AND CTD.D_E_L_E_T_ = ' '"
		cQuryRela += " LEFT JOIN " + RetSqlName("CTH") + " CTH ON CTH_FILIAL = '" + xfilial("CTH") + "'"
		cQuryRela += " AND CT2_CLVLDB = CTH_CLVL"
		cQuryRela += " AND CTH.D_E_L_E_T_ = ' '"
		cQuryRela += " LEFT JOIN " + RetSqlName("CV3") + " CV3 ON CV3_FILIAL = '" + xfilial("CT2") + "'"
		cQuryRela += " AND CT2.R_E_C_N_O_ = TO_NUMBER(RTRIM(CV3_RECDES))"
		cQuryRela += " AND CT2_DTCV3 = CV3_DTSEQ AND CT2_SEQUEN = CV3_SEQUEN"
		cQuryRela += " WHERE CT2_FILIAL = '" + xfilial("CT2") + "'"
		cQuryRela += " AND CT2_DATA BETWEEN '" + cDataInic + "' AND '" + cDataFina + "'"
		cQuryRela += " AND CT2_MOEDLC = '01' AND CT1_CLASSE = '2'"
		cQuryRela += " AND CT2_TPSALD = '1'"
		cQuryRela += " AND CT2_LOTE < 'A'"
		cQuryRela += " AND CT2_DEBITO BETWEEN '" + cContInic + "' AND '" + cContFina + "'"
		cQuryRela += " AND CT2.D_E_L_E_T_ = ' '"
		cQuryRela += " AND CT2.R_E_C_N_O_ NOT IN"
		cQuryRela += " (SELECT REC FROM " + cTabeGrav + " WHERE CLAS = 'Realizado'
		cQuryRela += " AND DATALCT BETWEEN '" + cDataInic + "' AND '" + cDataFina + "'"
		cQuryRela += " AND MODELO = 'Capex'"
		cQuryRela += " AND CONTA BETWEEN '" + cContInic + "' AND '" + cContFina + "'"
		cQuryRela += " AND D_E_L_E_T_ = ' '"
		cQuryRela += "))"
		
		If ! U_CSPCO10N(cQuryRela,"na selecao da origem dos lancamentos contabeis de ativo (capex) realizados de planejamento",lExecManu)
			Return
		EndIf
	EndIf
	
	cViewRelx := cSufiView + "I" + GetNextAlias()
	While TcCanOpen(cViewRelx)
		cViewRelx := cSufiView + "I" + GetNextAlias()
	End
	cQuryRela := " CREATE"
	cQuryRela += " TABLE " + cViewRelx + " AS ("
	If cTipoResu$"RDT"
		cQuryRela += " SELECT ATIVIDADE, DESCRATV, DATALCT, LOTE, REVISAO, CONTA, DESCCTA, MAX(VALOR) AS VALOR"
		cQuryRela += " , NOME_FORNE, CODIGO, CNPJ, HIST, CLASSDSP, TPITEM, CCUSTO, DESCCC, CRESULT"
		cQuryRela += " , DSCRES, PRJTO, DPRJ, CLAS, MODELO, REC, SEQUEN, ORIGEM, CPROD, DPROD"
		cQuryRela += " , CCANAL, DCANAL, PEDIDO, ITEMPED, CONTRATO, REVCONTR, FILMEDICAO, MEDICAO, COMPETENCI"
		cQuryRela += " , ITEMED, PLANILHA, TABORI, LANPAD, MIN(RECORI) AS RECORI, FILORI"
		cQuryRela += " , CT1_DETPCO, A2_DETPCO"
		cQuryRela += " FROM " + cViewRel1
		cQuryRela += " GROUP BY ATIVIDADE, DESCRATV, DATALCT, LOTE, REVISAO, CONTA, DESCCTA"
		cQuryRela += " , NOME_FORNE, CODIGO, CNPJ, HIST, CLASSDSP, TPITEM, CCUSTO, DESCCC, CRESULT, DSCRES"
		cQuryRela += " , PRJTO, DPRJ, CLAS, MODELO, REC, SEQUEN, ORIGEM, CPROD, DPROD, CCANAL, DCANAL, PEDIDO, ITEMPED"
		cQuryRela += " , CONTRATO, REVCONTR, FILMEDICAO, MEDICAO, COMPETENCI, ITEMED, PLANILHA, TABORI, LANPAD, FILORI"
		cQuryRela += " , CT1_DETPCO, A2_DETPCO"
		
	EndIf
	If cTipoResu == "T"
		cQuryRela += " UNION ALL"
	EndIf
	If cTipoResu$"CT"
		cQuryRela += " SELECT ATIVIDADE, DESCRATV, DATALCT, LOTE, REVISAO, CONTA, DESCCTA, MAX(VALOR) AS VALOR"
		cQuryRela += " , NOME_FORNE, CODIGO, CNPJ, HIST , CLASSDSP, TPITEM, CCUSTO, DESCCC, CRESULT"
		cQuryRela += " , DSCRES, PRJTO, DPRJ, CLAS, MODELO, REC"
		cQuryRela += " , SEQUEN, ORIGEM, CPROD, DPROD, CCANAL, DCANAL, PEDIDO, ITEMPED"
		cQuryRela += " , CONTRATO, REVCONTR, FILMEDICAO, MEDICAO, COMPETENCI, ITEMED, PLANILHA"
		cQuryRela += " , TABORI, LANPAD, MIN(RECORI) AS RECORI, FILORI"
		cQuryRela += " , CT1_DETPCO, A2_DETPCO"
		cQuryRela += " FROM " + cViewRel2
		cQuryRela += " GROUP BY ATIVIDADE, DESCRATV, DATALCT, LOTE, REVISAO, CONTA, DESCCTA"
		cQuryRela += " , NOME_FORNE, CODIGO, CNPJ, HIST , CLASSDSP, TPITEM, CCUSTO, DESCCC, CRESULT, DSCRES"
		cQuryRela += " , PRJTO, DPRJ, CLAS, MODELO, REC, SEQUEN, ORIGEM, CPROD, DPROD, CCANAL, DCANAL, PEDIDO, ITEMPED"
		cQuryRela += " , CONTRATO, REVCONTR, FILMEDICAO, MEDICAO, COMPETENCI, ITEMED, PLANILHA, TABORI, LANPAD, FILORI"
		cQuryRela += " , CT1_DETPCO, A2_DETPCO"
	EndIf
	cQuryRela += ")"
	If ! U_CSPCO10N(cQuryRela,"na selecao das views de despesas/receitas + ativo (capex) realizados de planejamento",lExecManu)
		Return
	EndIf
	
	cViewRel3 := cSufiView + "I" + "O" + GetNextAlias()
	While TcCanOpen(cViewRel3)
		cViewRel3 := cSufiView + "I" + "O" + GetNextAlias()
	End
	// Realizado x Documento de Origem
	cQuryRela := " CREATE"
	cQuryRela += " TABLE " + cViewRel3 + " AS ("
	cQuryRela += " SELECT ATIVIDADE, DESCRATV, DATALCT , LOTE, REVISAO, CONTA, DESCCTA, VALOR"
	cQuryRela += " , CASE WHEN SUBSTR(SE5.E5_BENEF,1,5) <>  '" + Space(5) + "' THEN SE5.E5_BENEF"
	cQuryRela += "        ELSE NVL(SE5.E5_HISTOR,'" + Space(TamSX3("A2_NOME")[1]) + "') END NOME_FORNE"
	cQuryRela += " , CASE WHEN SE5.E5_FORNECE = '" + Space(TamSX3("E5_FORNECE")[1]) + "' THEN SE5.E5_CLIENTE||SE5.E5_LOJA"
	cQuryRela += "  	  ELSE NVL(SE5.E5_FORNECE||SE5.E5_LOJA,'" + Space(TamSX3("E5_FORNECE")[1] + TamSX3("E5_LOJA")[1]) + "') END CODIGO"
	cQuryRela += " , CNPJ"
	cQuryRela += " , HIST, CLASSDSP, TPITEM, CCUSTO, DESCCC, CRESULT, DSCRES"
	cQuryRela += " , PRJTO, DPRJ, CLAS, MODELO, REC, SEQUEN, ORIGEM"
	cQuryRela += " , CPROD, DPROD, CCANAL, DCANAL"
	cQuryRela += " , PEDIDO, ITEMPED, CONTRATO, REVCONTR, FILMEDICAO, MEDICAO, COMPETENCI, ITEMED, PLANILHA"
	cQuryRela += " , TABORI, LANPAD, RECORI, FILORI"
	cQuryRela += " , CASE WHEN SE5.E5_FORNECE = '" + Space(TamSX3("E5_FORNECE")[1]) + "' THEN 'C'"
	cQuryRela += "  	  ELSE 'F' END TIPCLI"
	cQuryRela += " , '" + Space(TamSX3("E1_VEND1")[1]) + "' AS VENDED"
	cQuryRela += " , '" + Space(TamSX3("B1_COD")[1]) + "' AS PRODUT"
	cQuryRela += " , CT1_DETPCO, A2_DETPCO"
	cQuryRela += " FROM " + cViewRelx + " V01"
	cQuryRela += " LEFT JOIN " + RetSqlName("SE5") + " SE5 ON SE5.E5_FILIAL = '" + xfilial("SE5") + "'"
	cQuryRela += " AND V01.RECORI = SE5.R_E_C_N_O_"
	cQuryRela += " WHERE V01.TABORI = 'SE5'
	cQuryRela += " UNION ALL "
	cQuryRela += " SELECT ATIVIDADE, DESCRATV, DATALCT , LOTE, REVISAO, CONTA, DESCCTA, VALOR"
	cQuryRela += " , NOME_FORNE"
	cQuryRela += " , NVL(SE2.E2_FORNECE||SE2.E2_LOJA,'" + Space(TamSX3("E5_FORNECE")[1] + TamSX3("E5_LOJA")[1]) + "') AS CODIGO"
	cQuryRela += " , CNPJ"
	cQuryRela += " , HIST, CLASSDSP, TPITEM, CCUSTO, DESCCC, CRESULT, DSCRES"
	cQuryRela += " , PRJTO, DPRJ, CLAS, MODELO,  REC, SEQUEN, ORIGEM"
	cQuryRela += " , CPROD, DPROD, CCANAL, DCANAL"
	cQuryRela += " , PEDIDO, ITEMPED, CONTRATO, REVCONTR, FILMEDICAO, MEDICAO, COMPETENCI, ITEMED, PLANILHA"
	cQuryRela += " , TABORI, LANPAD, RECORI, FILORI"
	cQuryRela += " , 'F' AS TIPCLI"
	cQuryRela += " , '" + Space(TamSX3("E1_VEND1")[1]) + "' AS VENDED"
	cQuryRela += " , '" + Space(TamSX3("B1_COD")[1]) + "' AS PRODUT"
	cQuryRela += " , CT1_DETPCO, A2_DETPCO"
	cQuryRela += " FROM " + cViewRelx + " V01"
	cQuryRela += " LEFT JOIN " + RetSqlName("SE2") + " SE2 ON SE2.E2_FILIAL = '" + xfilial("SE2") + "'"
	cQuryRela += " AND V01.RECORI = SE2.R_E_C_N_O_"
	cQuryRela += " WHERE V01.TABORI = 'SE2'
	cQuryRela += " UNION ALL "
	cQuryRela += " SELECT ATIVIDADE, DESCRATV, DATALCT , LOTE, REVISAO, CONTA, DESCCTA, VALOR"
	cQuryRela += " , NOME_FORNE"
	cQuryRela += " , NVL(SE1.E1_CLIENTE||SE1.E1_LOJA,'" + Space(TamSX3("E1_CLIENTE")[1] + TamSX3("E1_LOJA")[1]) + "') AS CODIGO"
	cQuryRela += " , CNPJ"
	cQuryRela += " , HIST, CLASSDSP, TPITEM, CCUSTO, DESCCC, CRESULT, DSCRES"
	cQuryRela += " , PRJTO, DPRJ, CLAS, MODELO,  REC, SEQUEN, ORIGEM"
	cQuryRela += " , CPROD, DPROD, CCANAL, DCANAL"
	cQuryRela += " , PEDIDO, ITEMPED, CONTRATO, REVCONTR, FILMEDICAO, MEDICAO, COMPETENCI, ITEMED, PLANILHA"
	cQuryRela += " , TABORI, LANPAD, RECORI, FILORI"
	cQuryRela += " , 'C' TIPCLI"
	cQuryRela += " , NVL(SE1.E1_VEND1,'" + Space(TamSX3("E1_VEND1")[1]) + "') AS VENDED"
	cQuryRela += " , '" + Space(TamSX3("B1_COD")[1]) + "' AS PRODUT"
	cQuryRela += " , CT1_DETPCO, A2_DETPCO"
	cQuryRela += " FROM " + cViewRelx + " V01"
	cQuryRela += " LEFT JOIN " + RetSqlName("SE1") + " SE1 ON SE1.E1_FILIAL = '" + xfilial("SE1") + "'"
	cQuryRela += " AND V01.RECORI = SE1.R_E_C_N_O_"
	cQuryRela += " WHERE V01.TABORI = 'SE1'"
	cQuryRela += " UNION ALL "
	cQuryRela += " SELECT ATIVIDADE, DESCRATV, DATALCT , LOTE, REVISAO, CONTA, DESCCTA, VALOR"
	cQuryRela += " , NOME_FORNE"
	cQuryRela += " , NVL(SF2.F2_CLIENTE||SF2.F2_LOJA,'" + Space(TamSX3("F2_CLIENTE")[1] + TamSX3("F2_LOJA")[1]) + "') AS CODIGO"
	cQuryRela += " , CNPJ"
	cQuryRela += " , HIST, CLASSDSP, TPITEM, CCUSTO, DESCCC, CRESULT, DSCRES"
	cQuryRela += " , PRJTO, DPRJ, CLAS, MODELO,  REC, SEQUEN, ORIGEM"
	cQuryRela += " , CPROD, DPROD, CCANAL, DCANAL"
	cQuryRela += " , PEDIDO, ITEMPED, CONTRATO, REVCONTR, FILMEDICAO, MEDICAO, COMPETENCI, ITEMED, PLANILHA"
	cQuryRela += " , TABORI, LANPAD, RECORI, FILORI"
	cQuryRela += " , CASE WHEN SF2.F2_TIPO IN ('B','D') THEN 'F'"
	cQuryRela += "  	  ELSE 'C' END TIPCLI"
	cQuryRela += " , NVL(SF2.F2_VEND1,'" + Space(TamSX3("F2_VEND1")[1]) + "') AS VENDED"
	cQuryRela += " , NVL(SD2.D2_COD,'" + Space(TamSX3("B1_COD")[1]) + "') AS PRODUT"
	cQuryRela += " , CT1_DETPCO, A2_DETPCO"
	cQuryRela += " FROM " + cViewRelx + " V01"
	cQuryRela += " LEFT JOIN " + RetSqlName("SF2") + " SF2 ON SF2.F2_FILIAL = V01.FILORI"
	cQuryRela += " AND SF2.R_E_C_N_O_ = V01.RECORI"
	cQuryRela += " LEFT JOIN " + RetSqlName("SD2") + " SD2 ON SD2.D2_FILIAL = SF2.F2_FILIAL"
	cQuryRela += " AND SD2.D2_DOC = SF2.F2_DOC AND SD2.D2_SERIE = SF2.F2_SERIE"
	cQuryRela += " AND SD2.D2_CLIENTE = SF2.F2_CLIENTE AND SD2.D2_LOJA = SF2.F2_LOJA"
	cQuryRela += " AND SD2.D2_ITEM = '" + StrZero(1,TamSX3("D2_ITEM")[1]) + "'"
	cQuryRela += " AND SD2.D_E_L_E_T_ = ' '"
	cQuryRela += " WHERE V01.TABORI = 'SF2'"
	cQuryRela += " UNION ALL "
	cQuryRela += " SELECT ATIVIDADE, DESCRATV, DATALCT , LOTE, REVISAO, CONTA, DESCCTA, VALOR"
	cQuryRela += " , NOME_FORNE"
	cQuryRela += " , NVL(SF1.F1_FORNECE||SF1.F1_LOJA,'" + Space(TamSX3("F1_FORNECE")[1] + TamSX3("F1_LOJA")[1]) + "') AS CODIGO"
	cQuryRela += " , CNPJ"
	cQuryRela += " , HIST, CLASSDSP, TPITEM, CCUSTO, DESCCC, CRESULT, DSCRES"
	cQuryRela += " , PRJTO, DPRJ, CLAS, MODELO,  REC, SEQUEN, ORIGEM"
	cQuryRela += " , CPROD, DPROD, CCANAL, DCANAL"
	cQuryRela += " , NVL(SD1.D1_PEDIDO,'" + Space(TamSX3("D1_PEDIDO")[1]) + "') AS PEDIDO"
	cQuryRela += " , NVL(SD1.D1_ITEMPC,'" + Space(TamSX3("D1_ITEMPC")[1]) + "') AS ITEMPED"
	cQuryRela += " , CONTRATO, REVCONTR, FILMEDICAO, MEDICAO, COMPETENCI, ITEMED, PLANILHA"
	cQuryRela += " , TABORI, LANPAD, RECORI, FILORI"
	cQuryRela += " , CASE WHEN SF1.F1_TIPO IN ('B','D') THEN 'C'"
	cQuryRela += "  	  ELSE 'F' END TIPCLI"
	cQuryRela += " , '" + Space(TamSX3("E1_VEND1")[1]) + "' AS VENDED"
	cQuryRela += " , NVL(SD1.D1_COD,'" + Space(TamSX3("B1_COD")[1]) + "') AS PRODUT"
	cQuryRela += " , CT1_DETPCO, A2_DETPCO"
	cQuryRela += " FROM " + cViewRelx + " V01"
	cQuryRela += " LEFT JOIN " + RetSqlName("SF1") + " SF1 ON SF1.F1_FILIAL = V01.FILORI"
	cQuryRela += " AND SF1.R_E_C_N_O_ = V01.RECORI"
	cQuryRela += " LEFT JOIN " + RetSqlName("SD1") + " SD1 ON SD1.D1_FILIAL = SF1.F1_FILIAL"
	cQuryRela += " AND SD1.D1_DOC = SF1.F1_DOC AND SD1.D1_SERIE = SF1.F1_SERIE"
	cQuryRela += " AND SD1.D1_FORNECE = SF1.F1_FORNECE AND SD1.D1_LOJA = SF1.F1_LOJA"
	cQuryRela += " AND SD1.D1_ITEM = '" + StrZero(1,TamSX3("D1_ITEM")[1]) + "'"
	cQuryRela += " AND SD1.D_E_L_E_T_ = ' '"
	cQuryRela += " WHERE V01.TABORI = 'SF1'"
	cQuryRela += " UNION ALL "
	cQuryRela += " SELECT ATIVIDADE, DESCRATV, DATALCT , LOTE, REVISAO, CONTA, DESCCTA, VALOR"
	cQuryRela += " , NOME_FORNE"
	cQuryRela += " , NVL(SD2.D2_CLIENTE||SD2.D2_LOJA,'" + Space(TamSX3("D2_CLIENTE")[1] + TamSX3("D2_LOJA")[1]) + "') AS CODIGO"
	cQuryRela += " , CNPJ"
	cQuryRela += " , HIST, CLASSDSP, TPITEM, CCUSTO, DESCCC, CRESULT, DSCRES"
	cQuryRela += " , PRJTO, DPRJ, CLAS, MODELO,  REC, SEQUEN, ORIGEM"
	cQuryRela += " , CPROD, DPROD, CCANAL, DCANAL"
	cQuryRela += " , PEDIDO, ITEMPED, CONTRATO, REVCONTR, FILMEDICAO, MEDICAO, COMPETENCI, ITEMED, PLANILHA"
	cQuryRela += " , TABORI, LANPAD, RECORI, FILORI"
	cQuryRela += " , CASE WHEN SD2.D2_TIPO IN ('B','D') THEN 'F'"
	cQuryRela += "  	  ELSE 'C' END TIPCLI"
	cQuryRela += " , NVL(SF2.F2_VEND1,'" + Space(TamSX3("E1_VEND1")[1]) + "') AS VENDED"
	cQuryRela += " , NVL(SD2.D2_COD,'" + Space(TamSX3("B1_COD")[1]) + "') AS PRODUT"
	cQuryRela += " , CT1_DETPCO, A2_DETPCO"
	cQuryRela += " FROM " + cViewRelx + " V01"
	cQuryRela += " LEFT JOIN " + RetSqlName("SD2") + " SD2 ON SD2.D2_FILIAL = V01.FILORI"
	cQuryRela += " AND SD2.R_E_C_N_O_ = V01.RECORI"
	cQuryRela += " LEFT JOIN " + RetSqlName("SF2") + " SF2 ON SF2.F2_FILIAL = SD2.D2_FILIAL"
	cQuryRela += " AND SF2.F2_CLIENTE = SD2.D2_CLIENTE AND SF2.F2_LOJA = SD2.D2_LOJA"
	cQuryRela += " AND SF2.F2_DOC = SD2.D2_DOC AND SF2.F2_SERIE = SD2.D2_SERIE"
	cQuryRela += " AND SF2.D_E_L_E_T_ = ' '"
	cQuryRela += " WHERE V01.TABORI = 'SD2'"
	cQuryRela += " UNION ALL "
	cQuryRela += " SELECT ATIVIDADE, DESCRATV, DATALCT , LOTE, REVISAO, CONTA, DESCCTA, VALOR"
	cQuryRela += " , NOME_FORNE"
	cQuryRela += " , NVL(SD1.D1_FORNECE||SD1.D1_LOJA,'" + Space(TamSX3("D1_FORNECE")[1]) + Space(TamSX3("D1_LOJA")[1]) + "') AS CODIGO"
	cQuryRela += " , CNPJ"
	cQuryRela += " , HIST, CLASSDSP, TPITEM, CCUSTO, DESCCC, CRESULT, DSCRES"
	cQuryRela += " , PRJTO, DPRJ, CLAS, MODELO,  REC, SEQUEN, ORIGEM"
	cQuryRela += " , CPROD, DPROD, CCANAL, DCANAL"
	cQuryRela += " , NVL(SD1.D1_PEDIDO,'" + Space(TamSX3("D1_PEDIDO")[1]) + "') AS PEDIDO"
	cQuryRela += " , NVL(SD1.D1_ITEMPC,'" + Space(TamSX3("D1_ITEMPC")[1]) + "') AS ITEMPED"
	cQuryRela += " , CONTRATO, REVCONTR, FILMEDICAO, MEDICAO, COMPETENCI, ITEMED, PLANILHA"
	cQuryRela += " , TABORI, LANPAD, RECORI, FILORI"
	cQuryRela += " , CASE WHEN SD1.D1_TIPO IN ('B','D') THEN 'C'"
	cQuryRela += "  	  ELSE 'F' END TIPCLI"
	cQuryRela += " , '" + Space(TamSX3("E1_VEND1")[1]) + "' AS VENDED"
	cQuryRela += " , NVL(SD1.D1_COD,'" + Space(TamSX3("B1_COD")[1]) + "') AS PRODUT"
	cQuryRela += " , CT1_DETPCO, A2_DETPCO"
	cQuryRela += " FROM " + cViewRelx + " V01"
	cQuryRela += " LEFT JOIN " + RetSqlName("SD1") + " SD1 ON SD1.D1_FILIAL = V01.FILORI"
	cQuryRela += " AND SD1.R_E_C_N_O_ = V01.RECORI"
	cQuryRela += " LEFT JOIN " + RetSqlName("SF1") + " SF1 ON SF1.F1_FILIAL = SD1.D1_FILIAL"
	cQuryRela += " AND SF1.F1_DOC = SD1.D1_DOC AND SF1.F1_SERIE = SD1.D1_SERIE"
	cQuryRela += " AND SF1.F1_FORNECE = SD1.D1_FORNECE AND SF1.F1_LOJA = SD1.D1_LOJA"
	cQuryRela += " AND SF1.F1_TIPO = SD1.D1_TIPO"
	cQuryRela += " AND SF1.D_E_L_E_T_ = ' '"
	cQuryRela += " WHERE V01.TABORI = 'SD1'"
	cQuryRela += " UNION ALL "
	cQuryRela += " SELECT ATIVIDADE, DESCRATV, DATALCT , LOTE, REVISAO, CONTA, DESCCTA, VALOR"
	cQuryRela += " , CASE WHEN SEU.EU_FORNECE = '" + Space(TamSX3("E5_FORNECE")[1]) + "' THEN SEU.EU_NOME"
	cQuryRela += "  	  ELSE '" + Space(TamSX3("EU_NOME")[1]) + "' END NOME_FORNE"
	cQuryRela += " , NVL(SEU.EU_FORNECE||SEU.EU_LOJA,'" + Space(TamSX3("EU_FORNECE")[1] + TamSX3("EU_LOJA")[1]) + "') AS CODIGO"
	cQuryRela += " , CNPJ"
	cQuryRela += " , HIST, CLASSDSP, TPITEM, CCUSTO, DESCCC, CRESULT, DSCRES"
	cQuryRela += " , PRJTO, DPRJ, CLAS, MODELO,  REC, SEQUEN, ORIGEM"
	cQuryRela += " , CPROD, DPROD, CCANAL, DCANAL"
	cQuryRela += " , PEDIDO, ITEMPED, CONTRATO, REVCONTR, FILMEDICAO, MEDICAO, COMPETENCI, ITEMED, PLANILHA"
	cQuryRela += " , TABORI, LANPAD, RECORI, FILORI"
	cQuryRela += " , 'F' AS TIPCLI"
	cQuryRela += " , '" + Space(TamSX3("E1_VEND1")[1]) + "' AS VENDED"
	cQuryRela += " , '" + Space(TamSX3("B1_COD")[1]) + ")' AS PRODUT"
	cQuryRela += " , CT1_DETPCO, A2_DETPCO"
	cQuryRela += " FROM " + cViewRelx + " V01"
	cQuryRela += " LEFT JOIN " + RetSqlName("SEU") + " SEU ON SEU.EU_FILIAL = V01.FILORI"
	cQuryRela += " AND SEU.R_E_C_N_O_ = V01.RECORI "
	cQuryRela += " WHERE V01.TABORI = 'SEU'"
	cQuryRela += " UNION ALL "
	cQuryRela += " SELECT ATIVIDADE, DESCRATV, DATALCT , LOTE, REVISAO, CONTA, DESCCTA, VALOR"
	cQuryRela += " , NOME_FORNE"
	cQuryRela += " , NVL(SN1.N1_FORNEC||SN1.N1_LOJA,'" + Space(TamSX3("N1_FORNEC")[1] + TamSX3("N1_LOJA")[1]) + "') AS CODIGO"
	cQuryRela += " , CNPJ"
	cQuryRela += " , HIST, CLASSDSP, TPITEM, CCUSTO, DESCCC, CRESULT, DSCRES"
	cQuryRela += " , PRJTO, DPRJ, CLAS, MODELO,  REC, SEQUEN, ORIGEM"
	cQuryRela += " , CPROD, DPROD, CCANAL, DCANAL"
	cQuryRela += " , PEDIDO, ITEMPED, CONTRATO, REVCONTR, FILMEDICAO, MEDICAO, COMPETENCI, ITEMED, PLANILHA"
	cQuryRela += " , TABORI, LANPAD, RECORI, FILORI"
	cQuryRela += " , 'F' AS TIPCLI"
	cQuryRela += " , '" + Space(TamSX3("E1_VEND1")[1]) + "' AS VENDED"
	cQuryRela += " , '" + Space(TamSX3("B1_COD")[1]) + ")' AS PRODUT"
	cQuryRela += " , CT1_DETPCO, A2_DETPCO"
	cQuryRela += " FROM " + cViewRelx + " V01"
	cQuryRela += " LEFT JOIN " + RetSqlName("SN3") + " SN3 ON SN3.N3_FILIAL = V01.FILORI"
	cQuryRela += " AND V01.RECORI = SN3.R_E_C_N_O_"
	cQuryRela += " LEFT JOIN " + RetSqlName("SN1") + " SN1 ON SN1.N1_FILIAL = SN3.N3_FILIAL"
	cQuryRela += " AND SN1.N1_CBASE = SN3.N3_CBASE AND SN1.N1_ITEM = SN3.N3_ITEM"
	cQuryRela += " AND SN1.D_E_L_E_T_ = ' '"
	cQuryRela += " WHERE V01.TABORI = 'SN3'"
	cQuryRela += " UNION ALL "
	cQuryRela += " SELECT ATIVIDADE, DESCRATV, DATALCT , LOTE, REVISAO, CONTA, DESCCTA, VALOR"
	cQuryRela += " , NOME_FORNE"
	cQuryRela += " , NVL(SN1.N1_FORNEC||SN1.N1_LOJA,'" + Space(TamSX3("N1_FORNEC")[1] + TamSX3("N1_LOJA")[1]) + "') AS CODIGO"
	cQuryRela += " , CNPJ"
	cQuryRela += " , HIST, CLASSDSP, TPITEM, CCUSTO, DESCCC, CRESULT, DSCRES"
	cQuryRela += " , PRJTO, DPRJ, CLAS, MODELO,  REC, SEQUEN, ORIGEM"
	cQuryRela += " , CPROD, DPROD, CCANAL, DCANAL"
	cQuryRela += " , PEDIDO, ITEMPED, CONTRATO, REVCONTR, FILMEDICAO, MEDICAO, COMPETENCI, ITEMED, PLANILHA"
	cQuryRela += " , TABORI, LANPAD, RECORI, FILORI"
	cQuryRela += " , 'F' AS TIPCLI"
	cQuryRela += " , '" + Space(TamSX3("E1_VEND1")[1]) + "' AS VENDED"
	cQuryRela += " , '" + Space(TamSX3("B1_COD")[1]) + ")' AS PRODUT"
	cQuryRela += " , CT1_DETPCO, A2_DETPCO"
	cQuryRela += " FROM " + cViewRelx + " V01"
	cQuryRela += " LEFT JOIN " + RetSqlName("SN4") + " SN4 ON SN4.N4_FILIAL = V01.FILORI"
	cQuryRela += " AND V01.RECORI = SN4.R_E_C_N_O_"
	cQuryRela += " LEFT JOIN " + RetSqlName("SN1") + " SN1 ON SN1.N1_FILIAL = SN4.N4_FILIAL"
	cQuryRela += " AND SN1.N1_CBASE = SN4.N4_CBASE AND SN1.N1_ITEM = SN4.N4_ITEM"
	cQuryRela += " AND SN1.D_E_L_E_T_ = ' '"
	cQuryRela += " WHERE V01.TABORI = 'SN4'"
	cQuryRela += " UNION ALL "
	cQuryRela += " SELECT ATIVIDADE, DESCRATV, DATALCT , LOTE, REVISAO, CONTA, DESCCTA, VALOR"
	cQuryRela += " , NOME_FORNE, CODIGO, CNPJ"
	cQuryRela += " , HIST, CLASSDSP, TPITEM, CCUSTO, DESCCC, CRESULT, DSCRES"
	cQuryRela += " , PRJTO, DPRJ, CLAS, MODELO,  REC, SEQUEN, ORIGEM"
	cQuryRela += " , CPROD, DPROD, CCANAL, DCANAL"
	cQuryRela += " , PEDIDO, ITEMPED, CONTRATO, REVCONTR, FILMEDICAO, MEDICAO, COMPETENCI, ITEMED, PLANILHA"
	cQuryRela += " , TABORI, LANPAD, RECORI, FILORI"
	cQuryRela += " , 'F' AS TIPCLI"
	cQuryRela += " , '" + Space(TamSX3("E1_VEND1")[1]) + "' AS VENDED"
	cQuryRela += " , '" + Space(TamSX3("B1_COD")[1]) + ")' AS PRODUT"
	cQuryRela += " , CT1_DETPCO, A2_DETPCO"
	cQuryRela += " FROM " + cViewRelx + " V01"
	cQuryRela += " WHERE V01.TABORI NOT IN ('SE5','SE2','SE1','SF2','SF1','SD2','SD1','SEU','SN3','SN4')"
	cQuryRela += ")"
	// 2a. Análise
	If ! U_CSPCO10N(cQuryRela,"na selecao dos documentos de origem dos dados realizados ",lExecManu)
		Return
	EndIf
	
	cViewRel4 := cSufiView + "R" + GetNextAlias()
	While TcCanOpen(cViewRel4)
		cViewRel4 := cSufiView + "R" + GetNextAlias()
	End
	
	cQuryRela := " CREATE"
	cQuryRela += " TABLE " + cViewRel4 + " AS ("
	cQuryRela += " SELECT ATIVIDADE, DESCRATV, DATALCT , LOTE, REVISAO, CONTA, DESCCTA, VALOR"
	cQuryRela += " , NVL(A2_NOME,NOME_FORNE) AS NOME_FORNE, CODIGO, NVL(A2_CGC,CNPJ) AS CNPJ"
	cQuryRela += " , HIST, CLASSDSP, TPITEM, CCUSTO, DESCCC, CRESULT, DSCRES"
	cQuryRela += " , PRJTO, DPRJ, CLAS, MODELO,  REC, SEQUEN, ORIGEM"
	cQuryRela += " , NVL(SB1.B1_XSEG||SB1.B1_FILIAL||SB1.B1_COD,'" + Space(TamSX3('B1_XSEG')[1] + TamSX3('B1_FILIAL')[1] + TamSX3('B1_COD')[1]) + "') AS CPROD"
	cQuryRela += " , NVL(SZ1.Z1_DESCSEG,'" + Space(TamSX3('Z1_DESCSEG')[1]) + "') AS DPROD"
	cQuryRela += " , NVL(SZ2.Z2_EC08DB,'" + Space(TamSX3('Z2_EC08DB')[1]) + "') AS CCANAL"
	cQuryRela += " , NVL(SZ2.Z2_CANAL,'" + Space(TamSX3('Z2_CANAL')[1]) + "') AS DCANAL"
	cQuryRela += " , PEDIDO, ITEMPED"
	cQuryRela += " , NVL(SC7.C7_CONTRA,'" + Space(TamSX3("C7_CONTRA")[1]) + "') AS CONTRATO"
	cQuryRela += " , NVL(SC7.C7_CONTREV,'" + Space(TamSX3("C7_CONTREV")[1]) + "') AS REVCONTR"
	cQuryRela += " , NVL(SC7.C7_FILENT,'" + Space(TamSX3("C7_FILENT")[1]) + "') AS FILMEDICAO"
	cQuryRela += " , NVL(SC7.C7_MEDICAO,'" + Space(TamSX3("C7_MEDICAO")[1]) + "') AS MEDICAO"

	cQuryRela += " , NVL( CASE "
	cQuryRela += "         WHEN C7_XREFERE = ' ' THEN REPLACE(CND_COMPET, '/', '') ELSE C7_XREFERE "
	cQuryRela += "        END,'" + Space(TamSX3("CND_COMPET")[1]) + "') AS COMPETENCI"
	
	cQuryRela += " , NVL(SC7.C7_ITEMED,'" + Space(TamSX3("C7_ITEMED")[1]) + "') AS ITEMED"
	cQuryRela += " , NVL(SC7.C7_PLANILH,'" + Space(TamSX3("C7_PLANILH")[1]) + "') AS PLANILHA"
	cQuryRela += " , CT1_DETPCO, NVL(SA2.A2_DETPCO,V02.A2_DETPCO) AS A2_DETPCO"
	cQuryRela += " FROM " + cViewRel3 + " V02"
	cQuryRela += " LEFT OUTER JOIN " + RetSqlName("SA2") + " SA2"
	cQuryRela += " ON A2_FILIAL = '" + xfilial("SA2") + "'"
	cQuryRela += " AND A2_COD = SUBSTR(V02.CODIGO,1,6) AND A2_LOJA = SUBSTR(V02.CODIGO,7,2) AND SA2.D_E_L_E_T_ = ' '"
	cQuryRela += " LEFT OUTER JOIN " + RetSqlName("SB1") + " SB1"
	cQuryRela += " ON B1_FILIAL = V02.FILORI"
	cQuryRela += " AND B1_COD = V02.PRODUT AND SB1.D_E_L_E_T_ = ' '"
	cQuryRela += " LEFT OUTER JOIN " + RetSqlName("SZ1") + " SZ1"
	cQuryRela += " ON SZ1.Z1_FILIAL = '" + xfilial("SZ1") + "'"
	cQuryRela += " AND SZ1.Z1_CODSEG = SB1.B1_XSEG AND SZ1.D_E_L_E_T_ = ' '"
	cQuryRela += " LEFT OUTER JOIN " + RetSqlName("SA3") + " SA3"
	cQuryRela += " ON A3_FILIAL = '" + xfilial("SA3") + "'"
	cQuryRela += " AND A3_COD = V02.VENDED AND SA3.D_E_L_E_T_ = ' '"
	cQuryRela += " LEFT OUTER JOIN " + RetSqlName("SZ2") + " SZ2"
	cQuryRela += " ON Z2_FILIAL = '" + xfilial("SZ2") + "'"
	cQuryRela += " AND Z2_CODIGO = SA3.A3_XCANAL AND SA3.D_E_L_E_T_ = ' '"
	cQuryRela += " LEFT OUTER JOIN " + RetSqlName("SC7") + " SC7"
	cQuryRela += " ON C7_FILENT = V02.FILORI"
	cQuryRela += " AND C7_PRODUTO = V02.PRODUT"
	cQuryRela += " AND C7_NUM = V02.PEDIDO"
	cQuryRela += " AND C7_ITEM = V02.ITEMPED"
	cQuryRela += " AND SC7.D_E_L_E_T_ = ' '"

	cQuryRela += " LEFT OUTER JOIN " + RetSqlName("CND") + " CND"
	cQuryRela += " ON CND_FILIAL = '" + xfilial("CND") + "'"
	cQuryRela += " AND C7_CONTRA = CND_CONTRA "
	cQuryRela += " AND C7_MEDICAO = CND_NUMMED "
	cQuryRela += " AND CND.D_E_L_E_T_ = ' '"

	cQuryRela += " WHERE TIPCLI = 'F'"
	cQuryRela += " UNION ALL"
	cQuryRela += " SELECT ATIVIDADE, DESCRATV, DATALCT , LOTE, REVISAO, CONTA, DESCCTA, VALOR"
	cQuryRela += " , NVL(A1_NOME,NOME_FORNE) AS NOME_FORNE, CODIGO, NVL(A1_CGC,CNPJ) AS CNPJ"
	cQuryRela += " , HIST, CLASSDSP, TPITEM, CCUSTO, DESCCC, CRESULT, DSCRES"
	cQuryRela += " , PRJTO, DPRJ, CLAS, MODELO,  REC, SEQUEN, ORIGEM"
	cQuryRela += " , NVL(SB1.B1_XSEG||SB1.B1_FILIAL||SB1.B1_COD,'" + Space(TamSX3('B1_XSEG')[1] + TamSX3('B1_FILIAL')[1] + TamSX3('B1_COD')[1]) + "') AS CPROD"
	cQuryRela += " , NVL(SZ1.Z1_DESCSEG,'" + Space(TamSX3('Z1_DESCSEG')[1]) + "') AS DPROD"
	cQuryRela += " , NVL(SZ2.Z2_EC08DB,'" + Space(TamSX3('Z2_EC08DB')[1]) + "') AS CCANAL"
	cQuryRela += " , NVL(SZ2.Z2_CANAL,'" + Space(TamSX3('Z2_CANAL')[1]) + "') AS DCANAL"
	cQuryRela += " , PEDIDO, ITEMPED, CONTRATO, REVCONTR, FILMEDICAO, MEDICAO, COMPETENCI, ITEMED, PLANILHA"
	cQuryRela += " , CT1_DETPCO, V02.A2_DETPCO AS A2_DETPCO"
	cQuryRela += " FROM " + cViewRel3 + " V02"
	cQuryRela += " LEFT OUTER JOIN " + RetSqlName("SA1") + " SA1"
	cQuryRela += " ON A1_FILIAL = '" + xfilial("SA1") + "'"
	cQuryRela += " AND A1_COD = SUBSTR(V02.CODIGO,1,6) AND A1_LOJA = SUBSTR(V02.CODIGO,7,2) AND SA1.D_E_L_E_T_ = ' '"
	cQuryRela += " LEFT OUTER JOIN " + RetSqlName("SB1") + " SB1"
	cQuryRela += " ON B1_FILIAL = V02.FILORI"
	cQuryRela += " AND B1_COD = V02.PRODUT AND SB1.D_E_L_E_T_ = ' '"
	cQuryRela += " LEFT OUTER JOIN " + RetSqlName("SZ1") + " SZ1"
	cQuryRela += " ON SZ1.Z1_FILIAL = '" + xfilial("SZ1") + "'"
	cQuryRela += " AND SZ1.Z1_CODSEG = SB1.B1_XSEG AND SZ1.D_E_L_E_T_ = ' '"
	cQuryRela += " LEFT OUTER JOIN " + RetSqlName("SA3") + " SA3"
	cQuryRela += " ON A3_FILIAL = '" + xfilial("SA3") + "'"
	cQuryRela += " AND A3_COD = V02.VENDED AND SA3.D_E_L_E_T_ = ' '"
	cQuryRela += " LEFT OUTER JOIN " + RetSqlName("SZ2") + " SZ2"
	cQuryRela += " ON Z2_FILIAL = '" + xfilial("SZ2") + "'"
	cQuryRela += " AND Z2_CODIGO = SA3.A3_XCANAL AND SA3.D_E_L_E_T_ = ' '"
	cQuryRela += " WHERE TIPCLI = 'C'"
	cQuryRela += ")"
	// 3a. Análise
	If ! U_CSPCO10N(cQuryRela,"na selecao do codigo e nome dos fornecedores, produtos e canais",lExecManu)
		Return
	EndIf
EndIf

cQuryList := "SELECT object_name FROM all_objects where Substr(object_name,1,"
cQuryList += Str(Len(cRefeInic)) + ") IN ('" + cRefeInic + "')"
MemoWrite("cQuryList.SQL",cQuryList)
TcQuery cQuryList NEW ALIAS "TRB_001D"

cQuryRela := ""
TRB_001D->(dbGoTop())
TRB_001D->(DbEval({|| cQuryRela += " SELECT * FROM " + AllTrim(TRB_001D->object_name) + " UNION ALL"}))
TRB_001D->(dbCloseArea())
cQuryRela := Substr(cQuryRela,1,Len(cQuryRela) - 10)

Return

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ?CSPCO02C ?Autor ?Joao Goncalves de Oliveira ?Data ?10/07/15 ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri??o ?Gera Tabela para Gravacao dos Dados de Orçamento e/ou Realizado ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ?U_CSPCO02C(ExpN1,ExpC2,ExpC3,ExpC4,ExpC5,ExpC6,ExpC7)	       ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros?ExpC1 - Código da Empresa 	 								   ³±?
±±?         ?ExpC2 - Código da Filial 			 						   ³±?
±±?         ?ExpC3 - Data Inicial de Processamento						   ³±?
±±?         ?ExpC4 - Data Final de Processamento						   	   ³±?
±±?         ?ExpC5 - Define se a execução ?manual 						   ³±?
±±?         ?ExpC6 - Tabela de Gravação 									   ³±?
±±?         ?ExpC7 - Query a Ser Utilizada no Processamento 				   ³±?
±±?         ?ExpC8 - Tipo de Conta de Resultado  							   ³±?
±±?         ?ExpC9 - Tipo de Movimentação	 							   	   ³±?
±±?         ?ExpNA - Tipo Relatório (1 - View; 2 - Relatório) 		 	   ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±³ Retorno   ?Nenhum												   		   ³±?
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CSPCO02C(cEmprRoti,cFiliRoti,cDataInic,cDataFina,lExecManu,cTabeGrav,cQuryAtua,cTipoResu,cTipoMovi,nTipoRela)

Local nContRegi := 0
Local cQuryRegi := ""
Local nContDado := 0
Local nContItem := 0
Local nNumeThre := IIf(nTipoRela == 1 .And. mv_par18 == 1,5,1)

If ! lExecManu
	RpcSetType(3)
	PREPARE ENVIRONMENT EMPRESA cEmprRoti FILIAL cFiliRoti MODULO "CTB"
EndIf

cQuryRegi := " SELECT MAX(R_E_C_N_O_) REGISTRO FROM " + cTabeGrav
TcQuery cQuryRegi NEW ALIAS "TRB_002"
TRB_002->(dbGoTop())
If ! TRB_002->(Eof())
	nContRegi := TRB_002->REGISTRO
EndIf
TRB_002->(dbCloseARea())

TcQuery cQuryAtua NEW ALIAS "TRB"
If lExecManu
	TRB->(dbGoTop())
	ProcRegua(TRB->(RecCount()))
EndIf

If lExecManu
	TRB->(dbGoTop())
	ProcRegua(TRB->(RecCount()))
EndIf


TRB->(dbGoTop())
While ! TRB->(Eof())
	For nContItem := 1 to nNumeThre
		aListDado := {}
		For nContDado := 1 to 300
			nContRegi ++
			If ! Empty(TRB->DATALCT)
				aAdd(aListDado,{cTabeGrav,TRB->ATIVIDADE,TRB->DESCRATV,TRB->DATALCT,TRB->LOTE,TRB->REVISAO,TRB->CONTA;
				,TRB->DESCCTA,AllTrim(Str(TRB->VALOR)),U_CSPCO10M(TRB->NOME_FORNE),TRB->CODIGO,TRB->CNPJ,U_CSPCO10M(TRB->HIST),TRB->CLASSDSP;
				,TRB->TPITEM,TRB->CCUSTO,TRB->DESCCC,TRB->CRESULT;
				,TRB->DSCRES,TRB->PRJTO,TRB->DPRJ,TRB->CLAS,TRB->MODELO;
				,AllTrim(Str(TRB->REC)),TRB->SEQUEN,TRB->ORIGEM,TRB->CPROD,TRB->DPROD,TRB->CCANAL,TRB->DCANAL;
				,TRB->PEDIDO,TRB->ITEMPED,TRB->CONTRATO,TRB->REVCONTR;
				,TRB->FILMEDICAO,TRB->MEDICAO,TRB->COMPETENCI,TRB->ITEMED,TRB->PLANILHA,Space(2);
				,DTOS(dDataBase),IIf(Empty(TRB->A2_DETPCO),TRB->CT1_DETPCO,TRB->A2_DETPCO);
				,Space(1),AllTrim(Str(nContRegi))})
			EndIf
			If lExecManu
				IncProc("Atualizando Registro " + AllTrim(Str(nContRegi)) + " da Tabela Temporária")
			EndIf
			TRB->(dbSkip())
			If TRB->(Eof())
				Exit
			EndIf
		Next
		
		If nNumeThre > 1
			StartJob("U_CSPCO02Z",GetEnvServer(),.F.,cEmpAnt,cFilAnt,aListDado,nNumeThre)
		Else
			U_CSPCO02Z(cEmpAnt,cFilAnt,aListDado,nNumeThre)
		EndIf
	Next
End
TRB->(dbCloseARea())
Return

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ?CSPCO02D ?Autor ?Joao Goncalves de Oliveira ?Data ?10/07/15 ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri??o ?Verifica lançamentos que foram excluídos e efetua a exclusão na ³±?
±±?         ?Tabela para Gravacao dos Dados de Orçamento e/ou Realizado      ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ?U_CSPCO02D(ExpN1,ExpC2,ExpC3,ExpC4,ExpC5,ExpC6)	 		       ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros?ExpC1 - Código da Empresa 	 								   ³±?
±±?         ?ExpC2 - Código da Filial 			 						   ³±?
±±?         ?ExpC3 - Data Inicial de Processamento						   ³±?
±±?         ?ExpC4 - Data Final de Processamento						   	   ³±?
±±?         ?ExpC5 - Define se a execução ?manual 						   ³±?
±±?         ?ExpC6 - Tabela de Gravação 									   ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±³ Retorno   ?Nenhum												   		   ³±?
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CSPCO02D(cEmprRoti,cFiliRoti,cDataInic,cDataFina,lExecManu,cTabeGrav)

Local cQuryUpda := ""

cQuryUpda := " DECLARE"
cQuryUpda += " CURSOR cspco010d IS"
cQuryUpda += "    SELECT PCO.R_E_C_N_O_"
cQuryUpda += "    FROM " + cTabeGrav + " PCO"
cQuryUpda += "       INNER JOIN " + RetSqlName("CT2") + " CT2"
cQuryUpda += "          ON CT2.R_E_C_N_O_ = PCO.REC"
cQuryUpda += "          AND CT2.D_E_L_E_T_ = '*'
cQuryUpda += "    WHERE DATALCT >= '" + cDataInic + "'"
cQuryUpda += "       AND DATALCT <= '" + cDataFina + "'"
cQuryUpda += "       AND PCO.D_E_L_E_T_ = ' ';"
cQuryUpda += " BEGIN"
cQuryUpda += "    FOR cspco010d1 IN cspco010d"
cQuryUpda += "       LOOP"
cQuryUpda += "          UPDATE CSPCO010_2016 PCO2"
cQuryUpda += "             SET    PCO2.FLAG_CONTA = '05'"
cQuryUpda += "             WHERE  PCO2.R_E_C_N_O_ = cspco010d1.R_E_C_N_O_;"
cQuryUpda += "       END LOOP;"
cQuryUpda += " END;"
If ! U_CSPCO10N(cQuryUpda,"na atualização dos lancamentos contábeis alterados pós último processamento",lExecManu)
	Return
EndIf


cQuryUpda := " DECLARE"
cQuryUpda += " CURSOR cspco010d IS"
cQuryUpda += "    SELECT PCO.R_E_C_N_O_"
cQuryUpda += "    FROM " + cTabeGrav + " PCO"
cQuryUpda += "    WHERE DATALCT >= '" + cDataInic + "'"
cQuryUpda += "       AND DATALCT <= '" + cDataFina + "'"
cQuryUPda += "       AND PCO.FLAG_CONTA <> '  '"
cQuryUpda += "       AND PCO.D_E_L_E_T_  = ' ';"
cQuryUpda += " BEGIN"
cQuryUpda += "    FOR cspco010d1 IN cspco010d"
cQuryUpda += "       LOOP"
cQuryUpda += "          UPDATE CSPCO010_2016 PCO2"
cQuryUpda += "             SET    PCO2.D_E_L_E_T_ = '*'"
cQuryUpda += "             WHERE  PCO2.R_E_C_N_O_ = cspco010d1.R_E_C_N_O_;"
cQuryUpda += "       END LOOP;"
cQuryUpda += " END;"
If ! U_CSPCO10N(cQuryUpda,"na exclusão dos lancamentos contábeis alterados pós último processamento",lExecManu)
	Return
EndIf

Return

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ?CSPCO02L ?Autor ?Joao Goncalves de Oliveira ?Data ?17/07/15 ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri??o ?Exclui Tabelas Geradas Anteriormente 						   ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ?U_CSPCO02L(ExpL1,ExpC2) 				          	   		       ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros?ExpC1 - Verifica se o processo est?sendo executado manualmente ³±?
±±?         ?ExpC2 - Referencia Inicial para Exclusao dos Arquivos 		   ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±³ Retorno   ?Nenhum 														   ³±?
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CSPCO02L(lExecManu,cRefeInic)

Local cQuryList := ""
Local lConfExcl := .T.
Local nOpcaExcl := 1

cQuryList := "SELECT object_name FROM all_objects where Substr(object_name,1,"
cQuryList += Str(Len(cRefeInic)) + ") IN ('" + cRefeInic + "')"
TcQuery cQuryList NEW ALIAS "TRB_001A"

TRB_001A->(dbGoTop())
TRB_001A->(DbEval({|| TcDelFile(AllTrim(TRB_001A->object_name))}))
TRB_001A->(dbCloseArea())

Return(lConfExcl)

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ?CSPCO02S ?Autor ?Joao Goncalves de Oliveira ?Data ?10/12/15 ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri??o ?Gera Planilha do Relatório com Base nos Dados Gerados 		   ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ?CSPCO02S(ExpC1,ExpC2,ExpC3)				         	   		   ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros?ExpC1 - Tipo de Conta de Resultado 							   ³±?
±±?		 ?ExpC2 - Tipo de Movimentação 	 							   ³±?
±±?         ?ExpC3 - Tabela com os Dados 									   ³±?
±±?         ?ExpC4 - Formato de Planilha	 								   ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±³ Retorno   ?Nenhum 														   ³±?
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function CSPCO02S(cTipoResu,cTipoMovi,cTabeOrca,cTipoPlan)

Local cTituRela := "Lançamentos Orçados x Realizados"
Local cTituPlan := IIf(cTipoMovi == "R","Movimentos Realizados ","Movimentos Orçados")
Local cDirTmp   := GetTempPath()
Local oRelaOrca := FWMsExcel():New()
Local oExcelApp := MsExcel():New()
Local lImprLinh := .F.
Local aCabec := {}
Local aDados := {}
Local cBuffer  := Space(160)
Local nHandle1 := 0
Local nLine    := 0
Local aListDado := {}
Local cString  := ""
Local cSufiView := Substr(cTabeOrca,1,5) + Substr(cTabeOrca,7,2) + "E"
Local nPosiProd := TamSX3("B1_XSEG")[1] + 1
Local nTamaProd := TamSX3("B1_FILIAL")[1] + TamSX3("B1_COD")[1]

cQuryRegi := " SELECT COUNT(*) REGISTRO FROM " + cTabeOrca
cQuryRegi += " WHERE DATALCT >= '" + DTOS(mv_par02) + "'"
cQuryRegi += " AND DATALCT <= '" + DTOS(mv_par03) + "'"
If mv_par04 == 1
	cQuryRegi += " AND MODELO = 'Despesas'"
	cQuryRegi += " AND CONTA BETWEEN '" + mv_par15 + "' AND '" + mv_par16 + "'"
EndIf
If mv_par04 == 2
	cQuryRegi += " AND MODELO = 'Receitas'"
	cQuryRegi += " AND ((CONTA BETWEEN '" + mv_par13 + "' AND '" + mv_par14 + "')"
	cQuryRegi += " OR CONTA = '" + Space(TamSX3('CV1_CT1FIM')[1]) + "')"
EndIf
If mv_par04 == 3
	cQuryRegi += " AND MODELO = 'Capex'"
	cQuryRegi += " AND CONTA BETWEEN '" + mv_par11 + "' AND '" + mv_par12 + "'"
EndIf
If mv_par04 == 4
	cQuryRegi += " AND ((CONTA BETWEEN '" + mv_par11 + "' AND '" + mv_par12 + "')"
	cQuryRegi += " OR (CONTA BETWEEN '" + mv_par13 + "' AND '" + mv_par14 + "')"
	cQuryRegi += " OR (CONTA BETWEEN '" + mv_par15 + "' AND '" + mv_par16 + "')"
	cQuryRegi += " OR (CONTA = '" + Space(TamSX3('CV1_CT1FIM')[1]) + "'))"
EndIf
If mv_par05 == 1
	cQuryRegi += " AND CLAS = 'Orcado'"
EndIf
If mv_par05 == 2
	cQuryRegi += " AND CLAS = 'Realizado'"
EndIf
cQuryRegi += " AND D_E_L_E_T_ = ' '"

TcQuery cQuryRegi NEW ALIAS "TRB_003"
TRB_003->(dbGoTop())
If ! TRB_003->(Eof())
	nContRegi := TRB_003->REGISTRO
EndIf
TRB_003->(dbCloseARea())           '

If mv_par17 == 1 .And. mv_par05 == 1
	Processa({|| U_CSPCO02L(.T.,cSufiView)},"Apagando Tabelas de Revisão na Rotina ...")
	
	cViewRevi := cSufiView + GetNextAlias()
	While TcCanOpen(cViewRevi)
		cViewRevi := cSufiView + "E" + GetNextAlias()
	End
	
	cQuryRela := " CREATE"
	cQuryRela += " TABLE " + cViewRevi + " AS ("
	cQuryRela += " SELECT CV1_FILIAL, CV1_ORCMTO, CV1_CALEND, CV1_MOEDA, CV1_SEQUEN, CV1_PERIOD, MAX(CV1_REVISA) AS REVISA, MAX(CV1.R_E_C_N_O_) AS R_E_C_N_O_"
	cQuryRela += " FROM " + RetSqlName("CV1") + " CV1"
	cQuryRela += " WHERE CV1.D_E_L_E_T_ = ' '"
	cQuryRela += " GROUP BY CV1_FILIAL, CV1_ORCMTO, CV1_CALEND, CV1_MOEDA, CV1_SEQUEN, CV1_PERIOD"
	cQuryRela += " )"
	
	If ! U_CSPCO10N(cQuryRela,"na selecao da última revisão dos orçamentos",.T.)
		Return
	EndIf
EndIf

cQuryRela := " SELECT * FROM " + cTabeOrca
cQuryRela += " WHERE DATALCT >= '" + DTOS(mv_par02) + "'"
cQuryRela += " AND DATALCT <= '" + DTOS(mv_par03) + "'"
If mv_par04 == 1
	cQuryRela += " AND MODELO = 'Despesas'"
	cQuryRela += " AND CONTA BETWEEN '" + mv_par15 + "' AND '" + mv_par16 + "'"
EndIf
If mv_par04 == 2
	cQuryRela += " AND MODELO = 'Receitas'"
	cQuryRela += " AND ((CONTA BETWEEN '" + mv_par13 + "' AND '" + mv_par14 + "')"
	cQuryRela += " OR CONTA = '" + Space(TamSX3('CV1_CT1FIM')[1]) + "')"
EndIf
If mv_par04 == 3
	cQuryRela += " AND MODELO = 'Capex'"
	cQuryRela += " AND CONTA BETWEEN '" + mv_par11 + "' AND '" + mv_par12 + "'"
EndIf
If mv_par04 == 4
	cQuryRela += " AND ((CONTA BETWEEN '" + mv_par11 + "' AND '" + mv_par12 + "')"
	cQuryRela += " OR (CONTA BETWEEN '" + mv_par13 + "' AND '" + mv_par14 + "')"
	cQuryRela += " OR (CONTA BETWEEN '" + mv_par15 + "' AND '" + mv_par16 + "')"
	cQuryRela += " OR (CONTA = '" + Space(TamSX3('CV1_CT1FIM')[1]) + "'))"
EndIf
If mv_par05 == 1
	cQuryRela += " AND CLAS = 'Orcado'"
Else
	cQuryRela += " AND CLAS = 'Realizado'"
EndIf
cQuryRela += " AND D_E_L_E_T_ = ' '"
If mv_par17 == 1 .And. mv_par05 == 1
	cQuryRela += " AND REC IN (SELECT R_E_C_N_O_ FROM " + cViewRevi + ")"
EndIf
cQuryRela += " ORDER BY CLAS, MODELO, LOTE, REVISAO, R_E_C_N_O_"
TcQuery cQuryRela NEW ALIAS "TRB_002"

If cTipoPlan == "XML"
	If nContRegi > 50000
		Aviso("Atencao","Nao ?possível a geração em formato XML em função do volume de dados extenso. Opção ser?alterada para CSV",{"OK"})
		cTipoPlan := "CSV"
	EndIf
EndIf

If cTipoPlan == "CSV"
	cArquGera := AllTrim(mv_par01) + cTabeOrca + ".CSV"
	If File(cArquGera)
		FErase(cArquGera)
	EndIf
	nHandle1 := FCreate(cArquGera)
	
	IF nHandle1 == -1
		MsgStop( "Erro na criação do Arquivo " + cArquGera, "Atenção" )
		Return
	EndIf
	Ft_FUse(cArquGera)
Else
	
	oRelaOrca:AddworkSheet(cTituRela)
	oRelaOrca:AddTable (cTituRela,cTituPlan)
	oRelaOrca:AddColumn(cTituRela,cTituPlan,"Atividade",1,1,.F.)
	oRelaOrca:AddColumn(cTituRela,cTituPlan,"Descrição Atividade",1,1,.F.)
	oRelaOrca:AddColumn(cTituRela,cTituPlan,"Data Lançamento",1,1,.F.)
	oRelaOrca:AddColumn(cTituRela,cTituPlan,"Lote",1,1,.F.)
	If mv_par05 == 1
		oRelaOrca:AddColumn(cTituRela,cTituPlan,"Revisão",1,1,.F.)
	EndIf
	oRelaOrca:AddColumn(cTituRela,cTituPlan,"Conta",1,1,.F.)
	oRelaOrca:AddColumn(cTituRela,cTituPlan,"Descrição Conta",1,1,.F.)
	oRelaOrca:AddColumn(cTituRela,cTituPlan,"Valor",3,2,.T.)
	oRelaOrca:AddColumn(cTituRela,cTituPlan,"Nome Fornecedor",1,1,.F.)
	oRelaOrca:AddColumn(cTituRela,cTituPlan,"Código Fornecedor",1,1,.F.)
	oRelaOrca:AddColumn(cTituRela,cTituPlan,"CNPJ Fornecedor",1,1,.F.)
	oRelaOrca:AddColumn(cTituRela,cTituPlan,"Histórico",1,1,.F.)
	oRelaOrca:AddColumn(cTituRela,cTituPlan,"Classificação Despesa",1,1,.F.)
	oRelaOrca:AddColumn(cTituRela,cTituPlan,"C.Custo",1,1,.F.)
	oRelaOrca:AddColumn(cTituRela,cTituPlan,"Descrição C.Custo",1,1,.F.)
	oRelaOrca:AddColumn(cTituRela,cTituPlan,"Centro Resultado",1,1,.F.)
	oRelaOrca:AddColumn(cTituRela,cTituPlan,"Descrição Centro Resultado",1,1,.F.)
	oRelaOrca:AddColumn(cTituRela,cTituPlan,"Projeto",1,1,.F.)
	oRelaOrca:AddColumn(cTituRela,cTituPlan,"Descrição Projeto",1,1,.F.)
	oRelaOrca:AddColumn(cTituRela,cTituPlan,"Classe",1,1,.F.)
	oRelaOrca:AddColumn(cTituRela,cTituPlan,"Modelo",1,1,.F.)
	oRelaOrca:AddColumn(cTituRela,cTituPlan,"Registro",3,1,.F.)
	oRelaOrca:AddColumn(cTituRela,cTituPlan,"Sequencia",1,1,.F.)
	oRelaOrca:AddColumn(cTituRela,cTituPlan,"Origem",1,1,.F.)
	oRelaOrca:AddColumn(cTituRela,cTituPlan,"Código Produto",1,1,.F.)
	oRelaOrca:AddColumn(cTituRela,cTituPlan,"Descrição Produto",1,1,.F.)
	oRelaOrca:AddColumn(cTituRela,cTituPlan,"Detalhe",1,1,.F.)
	oRelaOrca:AddColumn(cTituRela,cTituPlan,"Código Canal",1,1,.F.)
	oRelaOrca:AddColumn(cTituRela,cTituPlan,"Descrição Canal",1,1,.F.)
	If (mv_par04 == 1 .Or. mv_par04 == 4) .And. mv_par05 == 2
		oRelaOrca:AddColumn(cTituRela,cTituPlan,"Pedido de Compras",1,1,.F.)
		oRelaOrca:AddColumn(cTituRela,cTituPlan,"Item Pedido Compras",1,1,.F.)
		oRelaOrca:AddColumn(cTituRela,cTituPlan,"Contrato",1,1,.F.)
		oRelaOrca:AddColumn(cTituRela,cTituPlan,"Revisão",1,1,.F.)
		oRelaOrca:AddColumn(cTituRela,cTituPlan,"Filial Medição",1,1,.F.)
		oRelaOrca:AddColumn(cTituRela,cTituPlan,"Medição",1,1,.F.)
		oRelaOrca:AddColumn(cTituRela,cTituPlan,"Competência",1,1,.F.)
		oRelaOrca:AddColumn(cTituRela,cTituPlan,"Item Medição",1,1,.F.)
		oRelaOrca:AddColumn(cTituRela,cTituPlan,"Planilha",1,1,.F.)
	EndIf
EndIf

TRB_002->(dbGoTop())
ProcRegua(nContRegi)
nContRela := 0
TRB_002->(dbGoTop())
If cTipoPlan == "CSV"
	cBuffer := "Atividade;Descrição Atividade;Data Lançamento;Lote;"
	cBuffer += IIf(mv_par05 == 1,"Revisão;","")
	cBuffer += "Conta;Descrição Conta;Valor;Nome Fornecedor;Código Fornecedor;"
	cBuffer += "CNPJ Fornecedor;Histórico;Classificação Despesa;C.Custo;Descrição C.Custo;Centro Resultado;Descrição Centro Resultado;Projeto;"
	cBuffer += "Descrição Projeto;Classe;Modelo;Registro;Sequencia;Origem;Código Produto;Descrição Produto;"
	cBuffer += "Detalhe;"
	cBuffer += "Código Canal;Descrição Canal;"
	If (mv_par04 == 1 .Or. mv_par04 == 4) .And. mv_par05 == 2
		cBuffer += "Pedido de Compras;Item Pedido de Compras;Contrato;Revisão;Filial Medição;Medição;Competência;Item Medição;Planilha;"
	EndIf
	cBuffer += CHR(13) + CHR(10)
	FWrite(nHandle1,cBuffer)
EndIf

While ! TRB_002->(Eof())
	If cTipoPlan == "CSV"
		cString := AllTrim(TRB_002->ATIVIDADE) + ";" + AllTrim(TRB_002->DESCRATV) + ";" + DTOC(STOD(TRB_002->DATALCT)) + ";" + TRB_002->LOTE + ";"
		If mv_par05 == 1
			cString += AllTrim(TRB_002->REVISAO) + ";"
		EndIf
		cString += AllTrim(TRB_002->CONTA) + ";"+ AllTrim(TRB_002->DESCCTA) + ";" + Transform(TRB_002->VALOR,"@E 999,999,999.99") + ";"
		cString += U_CSPCO02X(TRB_002->CODIGO,Substr(TRB_002->MODELO,1,1),TRB_002->NOME_FORNE) + ";" + AllTrim(Substr(TRB_002->CODIGO,1,6)) + ";" + AllTrim(TRB_002->CNPJ) + ";" + AllTrim(TRB_002->HIST) + ";"
		cString += AllTrim(TRB_002->TPITEM) + ";" + AllTrim(TRB_002->CCUSTO) + ";" + AllTrim(TRB_002->DESCCC) + ";" + AllTrim(TRB_002->CRESULT) + ";"
		cString += AllTrim(TRB_002->DSCRES) + ";" + AllTrim(TRB_002->PRJTO) + ";" + AllTrim(TRB_002->DPRJ) + ";" + TRB_002->CLAS + ";" + TRB_002->MODELO + ";"
		cString += AllTrim(Str(INT(TRB_002->REC))) + ";" + AllTrim(TRB_002->SEQUEN) + ";" + TRB_002->ORIGEM + ";"
		cString += AllTrim(TRB_002->CPROD) + ";" + AllTrim(U_CSPCO02Y(Substr(TRB_002->CPROD,nPosiProd,nTamaProd))) + ";"
		cString += AllTrim(TRB_002->DETALHE) + ";"
		cString += AllTrim(TRB_002->CCANAL) + ";" + AllTrim(TRB_002->DCANAL) + ";"
		If (mv_par04 == 1 .Or. mv_par04 == 4) .And. mv_par05 == 2
			cString += AllTrim(TRB_002->PEDIDO) + ";" + AllTrim(TRB_002->ITEMPED) + ";" + AllTrim(TRB_002->CONTRATO) + ";" + AllTrim(TRB_002->REVCONTR) + ";"
			cString += AllTrim(TRB_002->FILMEDICAO) + ";" + AllTrim(TRB_002->MEDICAO) + ";" + AllTrim(TRB_002->COMPETENCI) + ";"
			cString += AllTrim(TRB_002->ITEMED) + ";" + AllTrim(TRB_002->PLANILHA) + ";"
		EndIf
		cString += CHR(13) + CHR(10)
		FWrite(nHandle1,cSTring)
	Else
		aListDado := {}
		aAdd(aListDado,TRB_002->ATIVIDADE)
		aAdd(aListDado,TRB_002->DESCRATV)
		aAdd(aListDado,STOD(TRB_002->DATALCT))
		aAdd(aListDado,TRB_002->LOTE)
		If mv_par05 == 1
			aAdd(aListDado,TRB_002->REVISAO)
		EndIf
		aAdd(aListDado,TRB_002->CONTA)
		aAdd(aListDado,TRB_002->DESCCTA)
		aAdd(aListDado,TRB_002->VALOR)
		aAdd(aListDado,U_CSPCO02X(TRB_002->CODIGO,Substr(TRB_002->MODELO,1,1)))
		aAdd(aListDado,TRB_002->NOME_FORNE)
		aAdd(aListDado,Substr(TRB_002->CODIGO,1,6))
		aAdd(aListDado,TRB_002->CNPJ)
		aAdd(aListDado,TRB_002->HIST)
		aAdd(aListDado,TRB_002->TPITEM)
		aAdd(aListDado,TRB_002->CCUSTO)
		aAdd(aListDado,TRB_002->DESCCC)
		aAdd(aListDado,TRB_002->CRESULT)
		aAdd(aListDado,TRB_002->DSCRES)
		aAdd(aListDado,TRB_002->PRJTO)
		aAdd(aListDado,TRB_002->DPRJ)
		aAdd(aListDado,TRB_002->CLAS)
		aAdd(aListDado,TRB_002->MODELO)
		aAdd(aListDado,INT(TRB_002->REC))
		aAdd(aListDado,TRB_002->SEQUEN)
		aAdd(aListDado,TRB_002->ORIGEM)
		aAdd(aListDado,TRB_002->CPROD)
		aAdd(aListDado,U_CSPCO02Y(Substr(TRB_002->CPROD,nPosiProd,nTamaProd)))
		aAdd(aListDado,TRB_002->DPROD)
		aAdd(aListDado,TRB_002->DETALHE)
		aAdd(aListDado,TRB_002->CCANAL)
		aAdd(aListDado,TRB_002->DCANAL)
		If (mv_par04 == 1 .Or. mv_par04 == 4) .And. mv_par05 == 2
			aAdd(aListDado,TRB_002->PEDIDO)
			aAdd(aListDado,TRB_002->ITEMPED)
			aAdd(aListDado,TRB_002->CONTRATO)
			aAdd(aListDado,TRB_002->REVCONTR)
			aAdd(aListDado,TRB_002->FILMEDICAO)
			aAdd(aListDado,TRB_002->MEDICAO)
			aAdd(aListDado,TRB_002->COMPETENCI)
			aAdd(aListDado,TRB_002->ITEMED)
			aAdd(aListDado,TRB_002_PLANILHA)
		EndIf
		oRelaOrca:AddRow(cTituRela,cTituPlan,aListDado)
	EndIf
	
	IncProc("Gerando Relatório " + Str(nContRela ++))
	TRB_002->(dbSkip())
End

If cTipoPlan == "CSV"
	FT_FUse()
	FClose( nHandle1 )
Else
	oRelaOrca:Activate()
	cArquGera := AllTrim(mv_par01) + cTabeOrca + ".XML"
	oRelaOrca:GetXMLFile(cArquGera)
	If ApOleClient("MsExcel")
		If __CopyFile(cArquGera, cDirTmp + cTabeOrca + ".XML")
			oExcelApp := MsExcel():New()
			oExcelApp:WorkBooks:Open( cDirTmp + cTabeOrca + ".XML")
			oExcelApp:SetVisible(.T.)
		Else
			MsgInfo( "Arquivo não copiado para temporário do usuário." )
		Endif
	Else
		MsgInfo("MsExcel não instalado")
	EndIf
EndIf
TRB_002->(dbCloseArea())
If mv_par17 == 1 .And. mv_par05 == 1
	Processa({|| U_CSPCO02L(.T.,cRefeInic + "E")},"Apagando Tabelas de Revisão na Rotina ...")
EndIf
Return

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ?CSPCO02T ?Autor ?Joao Goncalves de Oliveira ?Data ?10/12/15 ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri??o ?Busca Diretório e/ou arquivo para processamento    		       ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ?CSPCO02T()								         	   		   ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros?Nenhum 														   ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±³ Retorno   ?Nenhum 														   ³±?
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function CSPCO02T()
Local cCamiArqu

cCamiArqu := cGetFile('Arquivo XML|*.XML|Arquivo *|*.*','Selecione Diretório',1,'C:\',.T.,GETF_LOCALHARD + GETF_LOCALFLOPPY + GETF_NETWORKDRIVE + GETF_RETDIRECTORY,.F.)

mv_par01 := cCamiArqu
Return

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ?CSPCO02W ?Autor ?Joao Goncalves de Oliveira ?Data ?30/12/15 ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri??o ?Atualiza Atividades 											   ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ?U_CSPCO02W(ExpC1,ExpC2)				         	   		       ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros?ExpL1 - Verifica se a execução ?manual 						   ³±?
±±?         ?ExpC2 - Tabela que deve ser atualizada 						   ³±?
±±?         ?ExpC3 - Data Inicial de Atualizacao   						   ³±?
±±?         ?ExpC4 - Data Final para Atualizacao    					       ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±³ Retorno   ?Nenhum 														   ³±?
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CSPCO02W(lExecManu,cTabeOrca,cDataInic,cDataFina)

Local cQuryUpda := ""
Local cUPdaEnti := ""
Local cCodiInic := ""
Local nContSequ := 0
Local cTipoRegr := ""
Local cUpdaTipo := ""
Local cUpdaCCus := ""

cQuryUpda := "SELECT PB4_CODIGO, PB3_TIPO, PB3_ATIVID, PB3_CLASDS, PB4_CRITER, PB4_TIPO, PB4_OPERAD"
cQuryUpda += " FROM " + RetSqlName("PB3") + " PB3"
cQuryUpda += " INNER JOIN " + RetSqlName("PB4") + " PB4 ON PB4_FILIAL = PB3_FILIAL"
cQuryUpda += " AND PB4_CODIGO = PB3_CODIGO"
cQuryUpda += " AND PB4.D_E_L_E_T_ = ' '"
cQuryUpda += " WHERE PB3_DTINI <= '" + cDataInic + "'"
cQuryUpda += " AND (PB3_DTFIM <= '" + cDataFina + "' OR PB3_DTFIM = '" + Space(8) + "')"
cQuryUpda += " AND PB3.D_E_L_E_T_ = ' '"
cQuryUpda += " ORDER BY PB4_CODIGO, PB4_SEQUEN"
TcQuery cQuryUpda NEW ALIAS "TRB_001E"

TRB_001E->(dbGoTop())
While ! TRB_001E->(Eof())
	cUpdaEnti := ""
	cCodiInic := TRB_001E->PB4_CODIGO
	cUpdaEnti := " UPDATE " + cTabeOrca
	If TRB_001E->PB3_TIPO = '1'
		cUpdaEnti += " SET ATIVIDADE = '" + AllTrim(TRB_001E->PB3_ATIVID) + "'"
		cUpdaEnti += " , DESCRATV = '" + Posicione("CV0",1,xfilial("CV0") + "06" + AllTrim(TRB_001E->PB3_ATIVID),"CV0_DESC") + "'"
	ElseIf TRB_001E->PB3_TIPO = '2'
		cUpdaEnti += " SET CLASSDSP = '" + AllTrim(TRB_001E->PB3_CLASDS) + "'"
		cUpdaEnti += " , TPITEM = '" + Posicione("CV0",1,xfilial("CV0") + "09" + AllTrim(TRB_001E->PB3_CLASDS),"CV0_DESC") + "'"
	Else
		cUpdaEnti += " SET CCUSTO = '" + AllTrim(TRB_001E->PB3_CCUSTO) + "'"
		cUpdaEnti += " , DESCCC = '" + Posicione("CTT",1,xfilial("CTT") + AllTrim(TRB_001E->PB3_CCUSTO),"CTT_DESC01") + "'"
		
	EndIf
	cUpdaEnti += " WHERE "
	nContSequ := 0
	While TRB_001E->PB4_CODIGO == cCodiInic
		nContSequ ++
		cOperCond := IIf(TRB_001E->PB4_OPERAD == '1',"IN ",IIf(TRB_001E->PB4_OPERAD== '2',"NOT IN ",IIf(TRB_001E->PB4_OPERAD == '3',"= ",IIf(TRB_001E->PB4_OPERAD == '4'," <>",IIf(TRB_001E->PB4_OPERAD == "5"," >=","<=")))))
		If nContSequ > 1
			cUpdaEnti += " AND"
		EndIf
		Do Case
			Case TRB_001E->PB4_TIPO == '1'
				cUpdaEnti += " RTRIM(SUBSTR(CODIGO,1,6))"
			Case TRB_001E->PB4_TIPO == '2'
				cUpdaEnti += " RTRIM(CCUSTO)"
			Case TRB_001E->PB4_TIPO == '3'
				cUpdaEnti += " RTRIM(ATIVIDADE)"
			Case TRB_001E->PB4_TIPO == '4'
				cUpdaEnti += " RTRIM(CONTA)"
			Case TRB_001E->PB4_TIPO == '5'
				cUpdaEnti += " VALOR"
			Case TRB_001E->PB4_TIPO == '6'
				cUpdaEnti += " CCANAL"
			Case TRB_001E->PB4_TIPO == '7'
				cUpdaEnti += " RTRIM(SUBSTR(CODIGO,1,6))"
			Case TRB_001E->PB4_TIPO == '8'
				cUpdaEnti += " LOTE"
			Case TRB_001E->PB4_TIPO == '9'
				cUpdaEnti += " RTRIM(CPROD)"
			Case TRB_001E->PB4_TIPO == 'A'
				cUpdaEnti += " RTRIM(SUBSTR(CPROD,1,6))"
		EndCase
		cUpdaEnti += " " + cOperCond
		cUpdaEnti += " " + IIf(TRB_001E->PB4_OPERAD < '3',FormatIn(AllTrim(TRB_001E->PB4_CRITER),","),"'" + AllTrim(TRB_001E->PB4_CRITER) + "'")
		cNumeRegr := TRB_001E->PB4_CODIGO  

		If TRB_001E->PB3_TIPO = '3'
			cUpdaCCus := " AND CCUSTO <> '" + Space(TamSX3('CV1_CTTFIM')[1]) + "'"
		EndIf
		If Substr(TRB_001E->PB3_ATIVID,1,1) == "R"
			cUpdaTipo := " AND MODELO = 'Receitas'"
		Else
			If TRB_001E->PB3_TIPO $'6,7,9,A'
				cUpdaTipo := " AND MODELO = 'Receitas'"
			Else
				cUpdaTipo := " AND MODELO = 'Despesas'"
			EndIf
		EndIf
		TRB_001E->(dbSkip())
	End
	cUpdaEnti += " AND DATALCT BETWEEN '" + cDataInic + "' AND '" + cDataFina + "'"
	cUPdaEnti += cUpdaCCus
	cUpdaEnti += cUpdaTipo 
	cUpdaEnti += " AND CLAS = 'Realizado'"
	
	If ! U_CSPCO10N(cUpdaEnti,"na atualizacao da entidade da regra " + cNumeRegr,lExecManu)
		Return
	EndIf
End
TRB_001E->(dbCloseArea())
Return

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ?CSPCO02X ?Autor ?Joao Goncalves de Oliveira ?Data ?30/12/15 ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri??o ?Busca Nome do Fornecedor 									   ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ?U_CSPCO02X(ExpC1,ExpC2)				         	   		       ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros?ExpC1 - Codigo do Fornecedor 		 						   ³±?
±±?         ?ExpC1 - Tipo Movimento 										   ³±?
±±?         ?ExpC3 - Nome do Fornecedor 			 						   ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±³ Retorno   ?ExpC1 - Nome do Fornecedor 									   ³±?
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CSPCO02X(cCodiForn,cTipoResu,cNomeForn)

If ! Empty(cCodiForn) .And. cTipoResu == "D"
	SA2->(dbSetOrder(1))
	If SA2->(dbSeek(xfilial("SA2") + cCodiForn))
		cNomeForn := SA2->A2_NOME
	EndIf
EndIf
Return(AllTrim(cNomeForn))


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ?CSPCO02Y ?Autor ?Joao Goncalves de Oliveira ?Data ?30/12/15 ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri??o ?Busca Descrição do Produto 									   ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ?U_CSPCO02X(ExpC1,ExpC2)				         	   		       ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros?ExpC1 - Filial + Código do Produto							   ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±³ Retorno   ?ExpC1 - Descrição do Produto 								   ³±?
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CSPCO02Y(cCodiProd)

Local cDescProd := ""

If ! Empty(cCodiProd)
	SB1->(dbSetOrder(1))
	If SB1->(dbSeek(cCodiProd))
		cDescProd := SB1->B1_DESC
	EndIf
EndIf
Return(cDescProd)

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ?CSPCO02Z ?Autor ?Joao Goncalves de Oliveira ?Data ?10/12/15 ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri??o ?Atualiza Dados das Entidades com Processamento Multi Threads    ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ?U_CSPCO02Z(ExpC1,ExpC2,ExpA3,ExpN4)							   ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros?ExpC1 - Empresa para Execucao			  					   ³±?
±±?		 ?ExpC2 - Filial para Execucao 			  					   ³±?
±±?		 ?ExpA3 - Vetor com Informações a serem Gravadas 				   ³±?
±±?		 ?ExpN4 - Numero de Threads 			  						   ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±³ Retorno   ?Nenhum 														   ³±?
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CSPCO02Z(cEmprRoti,cFiliRoti,aListDado,nNumeThre)

Local cUpdaGera := ""
Local cFuncGrav := "CSPCO02Z"
Local nContItem := 0

If nNumeThre > 1
	RpcSetType(3)
	PREPARE ENVIRONMENT EMPRESA cEmprRoti FILIAL cFiliRoti MODULO "CTB"
EndIf


cUpdaGera := " INSERT ALL"
For nContItem := 1 to Len(aListDado)
	cUpdaGera += " INTO " + aListDado[1,1]
	cUpdaGera += " (ATIVIDADE, DESCRATV, DATALCT, LOTE, REVISAO, CONTA, DESCCTA"
	cUpdaGera += " , VALOR, NOME_FORNE, CODIGO, CNPJ, HIST, CLASSDSP, TPITEM"
	cUpdaGera += " , CCUSTO, DESCCC, CRESULT, DSCRES, PRJTO, DPRJ"
	cUpdaGera += " , CLAS, MODELO, REC, SEQUEN, ORIGEM, CPROD"
	cUpdaGera += " , DPROD, CCANAL, DCANAL, PEDIDO, ITEMPED"
	cUPdaGera += " , CONTRATO, REVCONTR, FILMEDICAO, MEDICAO, COMPETENCI, ITEMED, PLANILHA, FLAG_CONTA"
	cUPdaGera += ", DATAGRV, DETALHE, D_E_L_E_T_, R_E_C_N_O_)"
	cUpdaGera += " VALUES "
	cUpdaGera += "('" + aListDado[nContItem,02] + "','" + aListDado[nContItem,03] + "'"
	cUpdaGera += " , '" + aListDado[nContItem,04] + "','" + aListDado[nContItem,05] + "'"
	cUpdaGera += " , '" + aListDado[nContItem,06] + "','" + aListDado[nContItem,07] + "'"
	cUpdaGera += " , '" + aListDado[nContItem,08] + "','" + aListDado[nContItem,09] + "'"
	cUpdaGera += " , '" + aListDado[nContItem,10] + "','" + aListDado[nContItem,11] + "'"
	cUpdaGera += " , '" + aListDado[nContItem,12] + "','" + aListDado[nContItem,13] + "'"
	cUpdaGera += " , '" + aListDado[nContItem,14] + "','" + aListDado[nContItem,15] + "'"
	cUpdaGera += " , '" + aListDado[nContItem,16] + "','" + aListDado[nContItem,17] + "'"
	cUpdaGera += " , '" + aListDado[nContItem,18] + "','" + aListDado[nContItem,19] + "'"
	cUpdaGera += " , '" + aListDado[nContItem,20] + "','" + aListDado[nContItem,21] + "'"
	cUpdaGera += " , '" + aListDado[nContItem,22] + "','" + aListDado[nContItem,23] + "'"
	cUpdaGera += " , '" + aListDado[nContItem,24] + "','" + aListDado[nContItem,25] + "'"
	cUpdaGera += " , '" + aListDado[nContItem,26] + "','" + aListDado[nContItem,27] + "'"
	cUpdaGera += " , '" + aListDado[nContItem,28] + "','" + aListDado[nContItem,29] + "'"
	cUpdaGera += " , '" + aListDado[nContItem,30] + "','" + aListDado[nContItem,31] + "'"
	cUpdaGera += " , '" + aListDado[nContItem,32] + "','" + aListDado[nContItem,33] + "'"
	cUpdaGera += " , '" + aListDado[nContItem,34] + "','" + aListDado[nContItem,35] + "'"
	cUpdaGera += " , '" + aListDado[nContItem,36] + "','" + aListDado[nContItem,37] + "'"
	cUpdaGera += " , '" + aListDado[nContItem,38] + "','" + aListDado[nContItem,39] + "'"
	cUpdaGera += " , '" + aListDado[nContItem,40] + "','" + aListDado[nContItem,41] + "'"
	cUpdaGera += " , '" + aListDado[nContItem,42] + "','" + aListDado[nContItem,43] + "', '" + aListDado[nContItem,44] + "')"
Next
cUpdaGera += " SELECT 1 FROM DUAL"
MemoWrite("cQuryGera.SQL",cUpdaGera)

If ! U_CSPCO10N(cUpdaGera,"da inclusao dos registros na tabela referencia",aListDado[1,1])
	TRB->(dbCloseARea())
	Return
EndIf
Return

User Function CSPCOUpd()
	Local aSAY  := {'Rotina para criar o campo COMPETENCIA nas tabelas de','Orçado e Realizado - PCO','','Clique em OK para prosseguir...'}
    Local aBTN  := {}
    Local aPAR  := {}
    Local nOpc  := 0

    Private aRET := {}
    Private cTRB := ''
    Private cTitulo := '[CSPCOUpd] - Atualiza tabela CSPCO'

    aADD( aBTN, { 1, .T., { || nOpc := 1, FechaBatch() } } )
    aADD( aBTN, { 2, .T., { || FechaBatch() } } )

    FormBatch(cTitulo, aSAY, aBTN )

    IF nOpc == 1
        aAdd( aPAR, {9, "Informe os parâmetros",200,7,.T.})
	    aAdd( aPAR, {1, "Ano"	 , Space(4), "","",""   ,"",0,.T.})
		aAdd( aPAR, {2, "Qual tabela",2,{"View(CSPCO010)","Relatório(CSPCO002)"}  , 100, '.T.', .T.})

        IF ParamBox(aPAR,cTitulo,@aRET)
            A010Proc( aRET )
        Else
            MsgInfo('Processo cancelado',cTitulo)
        EndIF
    EndIF
Return

Static Function A010Proc(aRET)

	Local aCampos := {}
	Local aStruct := {}
	Local aNewStru := {}
	Local lOk := .F.
	Local cTabeGrav := IIF( 'View' $ cValtoChar( aRET[3] ), 'CSPCO010_', 'CSPCO002_' )
	Local cAno		:= aRET[ 2 ]

	cTabeGrav := cTabeGrav + cAno
	
	aAdd( aCampos,{'ATIVIDADE'  ,'C',TamSX3('CT1_ENT06') [1],0}) //25
	aAdd( aCampos,{'DESCRATV'   ,'C',TamSX3('CT1_E06DSC')[1],0}) //40
	aAdd( aCampos,{'DATALCT'    ,'D',TamSX3('CV1_DTFIM') [1],0}) //8
	aAdd( aCampos,{'LOTE'       ,'C',TamSX3('CV1_ORCMTO')[1],0}) //6
	aAdd( aCampos,{'CONTA'      ,'C',TamSX3('CV1_CT1FIM')[1],0}) //20
	aAdd( aCampos,{'DESCCTA'    ,'C',TamSX3('CT1_DESC01')[1],0}) //40
	aAdd( aCampos,{'VALOR'      ,'N',TamSX3('CV1_VALOR')[1],2})  //17,2
	aAdd( aCampos,{'NOME_FORNE' ,'C',60,0})
	aAdd( aCampos,{'CODIGO'     ,'C',9,0})
	aAdd( aCampos,{'CNPJ'       ,'C',14,0})
	aAdd( aCampos,{'HIST'       ,'C',TamSX3('CV1_DESCIT')[1],0}) // 80
	aAdd( aCampos,{'CLASSDSP'   ,'C',TamSX3('CV1_E09FIM')[1],0}) // 25
	aAdd( aCampos,{'TPITEM'     ,'C',TamSX3('CV0_DESC')[1],0}) // 25
	aAdd( aCampos,{'CCUSTO'     ,'C',TamSX3('CV1_CTTFIM')[1],0}) // 9
	aAdd( aCampos,{'DESCCC'     ,'C',TamSX3('CTT_DESC01')[1],0}) // 40
	aAdd( aCampos,{'CRESULT'    ,'C',TamSX3('CV1_CTDFIM')[1],0}) // 9
	aAdd( aCampos,{'DSCRES '    ,'C',TamSX3('CTD_DESC01')[1],0}) // 40
	aAdd( aCampos,{'PRJTO'      ,'C',TamSX3('CV1_CTHFIM')[1],0}) // 9
	aAdd( aCampos,{'DPRJ'       ,'C',TamSX3('CTH_DESC01')[1],0}) // 40
	aAdd( aCampos,{'CLAS'       ,'C',9,0})
	aAdd( aCampos,{'MODELO'     ,'C',8,0})
	aAdd( aCampos,{'REC'        ,'N',15,0})
	aAdd( aCampos,{'SEQUEN'     ,'C',TamSX3('CT2_SEQUEN')[1],0}) //10
	aAdd( aCampos,{'ORIGEM'     ,'C',7,0})
	aAdd( aCampos,{'CPROD'      ,'C',TamSX3('CV1_E07FIM')[1],0})
	aAdd( aCampos,{'DPROD'      ,'C',TamSX3('Z1_DESCSEG')[1],0})
	aAdd( aCampos,{'CCANAL'     ,'C',TamSX3('CV1_E08FIM')[1],0})
	aAdd( aCampos,{'DCANAL'     ,'C',TamSX3('Z2_CANAL')[1],0})
	aAdd( aCampos,{'PEDIDO'     ,'C',TamSX3('D1_PEDIDO')[1],0})
	aAdd( aCampos,{'ITEMPED'    ,'C',TamSX3('D1_ITEMPC')[1],0})
	aAdd( aCampos,{'CONTRATO'   ,'C',TamSX3('C7_CONTRA')[1],0})
	aAdd( aCampos,{'REVCONTR'   ,'C',TamSX3('C7_CONTREV')[1],0})
	aAdd( aCampos,{'FILMEDICAO' ,'C',TamSX3('C7_FILIAL')[1],0})
	aAdd( aCampos,{'MEDICAO'    ,'C',TamSX3('C7_MEDICAO')[1],0})
	aAdd( aCampos,{'ITEMED'     ,'C',TamSX3('C7_ITEMED')[1],0})
	aAdd( aCampos,{'PLANILHA'   ,'C',TamSX3('C7_PLANILH')[1],0})
	aAdd( aCampos,{'DATAGRV'    ,'D',TamSX3('CV1_DTFIM') [1],0}) //8
	aAdd( aCampos,{'DETALHE'    ,'C',100,0})
	aAdd( aCampos,{'REVISAO'    ,'C',3,0})
	aAdd( aCampos,{'FLAG_CONTA' ,'C',2,0})
	aAdd( aCampos,{'COMPETENCI','C',TamSX3('CND_COMPET')[1],0})
	
	IF ! TcCanOpen(cTabeGrav)
		MsCreate( cTabeGrav, aCampos)
		Sleep(1000)
	EndIf

	IF TcCanOpen(cTabeGrav)
		If Select( cTabeGrav ) <= 0
			USE cTabeGrav ALIAS cTabeGrav SHARED NEW VIA "TOPCONN"
			If NetErr()
				UserException( "Falha ao abrir tabela [" + cAliasA + "] - SHARED" )
			Endif
			dbSelectArea(cTabeGrav)
		Endif

		aStruct := cTabeGrav->( DbStruct() )
        aNewStru := aClone(aStruct)

        IF FieldPos("COMPETENCI") <= 0
            aAdd( aNewStru,{'COMPETENCI','C',TamSX3('CND_COMPET')[1],0})

            lOk := TcAlter(cTabeGrav,aStruct,aNewStru)
            IF !lOk
	            MsgStop(tcsqlerror(),"Falha em TCAlter")
            Else
                MSgInfo("Campo COMPETENCI acrescentado com sucesso")
            Endif
        EndIF
	Else
		MsCreate( cTabeGrav, aCampos)
		Sleep(1000)
	EndIF

Return