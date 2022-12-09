#INCLUDE 'RWMAKE.CH'
#INCLUDE 'PROTHEUS.CH'
 
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³ RCRME005 ³ Autor ³ Adriano Leonardo    ³ Data ³ 23/09/2016 ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina facilitador do forecast.                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Específico para a empresa Prozyn               			  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function RCRME005()

Local _aSavArea 	:= GetArea()
Private _cRotina	:= "RCRME005"
Private	_cAliasQry	:= GetNextAlias()
Private _cEnter		:= CHR(13) + CHR(10)
Private oButton1
Private _nDiasEdit	:= SuperGetMV("MV_EDTFOR",,05) //Parâmetro para determinar quantos dias úteis o forecast estará aberto para edição, a contar do dia 1 de cada mês
Private _nMesIniP	:= SuperGetMV("MV_INIFOR",,10) //Parâmetro para determinar o mês de início do forecast do ano posterior além dos dias úteis do parâmetro acima
Private _nMesFimP	:= SuperGetMV("MV_FIMFOR",,12) //Parâmetro para determinar o mês de finalização do forecast do ano posterior além dos dias úteis do parâmetro acima
Private oCheckBo1
Private lCheckBo1 	:= .F.
Private oCheckBo2
Private lCheckBo2 	:= .F.
Private oCheckBo3
Private lCheckBo3 	:= .F.
Private oCheckBo4
Private lCheckBo4 	:= .F.
Private oCheckBo5
Private lCheckBo5	:= .F.
Private oCheckBo6
Private lCheckBo6 	:= .F.
Private oCheckBo7
Private lCheckBo7 	:= .F.
Private oCheckBo8
Private lCheckBo8	:= .F.
Private oCheckBo9
Private lCheckBo9   := .F.
Private oCheckBB1
Private lCheckBb1 	:= .F.
Private oCheckBb2
Private lCheckBb2 	:= .F.
Private oCheckBb3
Private lCheckBb3 	:= .F.
Private oCheckBb4
Private lCheckBb4 	:= .F.
Private oCheckBb5
Private lCheckBb5	:= .F.
Private oCheckBb6
Private lCheckBb6 	:= .F.
Private oCheckBb7
Private lCheckBb7 	:= .F.
Private oCheckBb8
Private lCheckBb8	:= .F.
Private oGet1
Private _cBuscar	:= Space(100)
Private _cBuscar1	:= Space(100)
Private oGroup1
Private oGroup2
Private oSay1
Private oComboBo1
Private nComboBo1
Private _aGerCome
Private oComboBo2
Private nComboBo2
Private _aGerCont
Private _dDataVld	:= StoD(StrZero(Year(dDataBase),4) + StrZero(Month(dDataBase),2) + "01")
Private _aMeses		:={"janeiro","fevereiro","março","abril","maio","junho","julho","agosto","setembro","outubro","novezembro","dezembro"}
Public _aRecnoA7 	:= {}
Public _cTabTmp		:= ""
Static oDlg

_nDUteis := 0

While _nDUteis < _nDiasEdit
	If DataValida(_dDataVld)==_dDataVld
		_nDUteis++
	EndIf
	_dDataVld++
EndDo

DEFINE MSDIALOG oDlg TITLE "Filtro do Forecast" FROM 000, 000  TO 630, 600 COLORS 0, 16777215 PIXEL

//Inibe a tecla de atalho para prevenir duplicidade da abertura da janela
SetKey(VK_F5,{|| 				})
SetKey(VK_F5,{|| Detalhe()		})
SetKey(VK_F6,{|| ReplMes()		})
SetKey(VK_F7,{|| ReplForecast()	})
SetKey(VK_F8,{|| ExpCSV()	})



@ 013, 010 SAY oSay1 PROMPT "Unidade de Negocio:" 	SIZE 055, 007 OF oDlg COLORS 0, 16777215 PIXEL
@ 035, 010 SAY oSay1 PROMPT "Gerente de Conta :" 		SIZE 055, 007 OF oDlg COLORS 0, 16777215 PIXEL



@ 007, 253 BUTTON oButton1 PROMPT "&Buscar" SIZE 037, 012 OF oDlg ACTION Selecao(AllTrim(Upper(_cBuscar)),AllTrim(Upper(_cBuscar1))) PIXEL
@ 035, 230 SAY oSay1 PROMPT "Ordenar por :" 		SIZE 055, 007 OF oDlg COLORS 0, 16777215 PIXEL
@ 042, 223 MSCOMBOBOX oComboBo1 VAR nComboBo1 ITEMS {"","Razão Social","Nome Fantasia","Cod Produto", "Grp Clientes"} SIZE 075, 010 OF oDlg COLORS 0, 16777215 PIXEL
_aGerCome := GerComer()
_aGerCont := GerConta()

@ 023, 010 MSCOMBOBOX oComboBo1 VAR nComboBo1 ITEMS _aGerCome SIZE 98, 010 OF oDlg COLORS 0, 16777215 ON CHANGE GerConta()	PIXEL
@ 045, 010 MSCOMBOBOX oComboBo2 VAR nComboBo2 ITEMS _aGerCont SIZE 98, 010 OF oDlg COLORS 0, 16777215 						PIXEL

@ 005, 007 GROUP oGroup1 TO 060, 114 PROMPT "" 	OF oDlg COLOR 0, 16777215 PIXEL


@ 078, 008 SAY oSay1 PROMPT "Filtro:" 		SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
@ 078, 039 MSGET oGet1 VAR _cBuscar 	SIZE 201, 010 OF oDlg COLORS 0, 16777215 PIXEL

@ 100, 018 GROUP oGroup2 TO 158, 250 PROMPT "Opções" 	OF oDlg COLOR 0, 16777215 PIXEL

@ 115, 048 CHECKBOX oCheckBo1 VAR lCheckBo1  PROMPT "Razão Social" 				SIZE 080, 008 OF oDlg COLORS 0, 16777215 PIXEL
@ 125, 048 CHECKBOX oCheckBo2 VAR lCheckBo2  PROMPT "Nome Reduzido" 				SIZE 080, 008 OF oDlg COLORS 0, 16777215 PIXEL
@ 135, 048 CHECKBOX oCheckBo3 VAR lCheckBo3  PROMPT "Código do Produto" 			SIZE 080, 008 OF oDlg COLORS 0, 16777215 PIXEL
@ 145, 048 CHECKBOX oCheckBo4 VAR lCheckBo4  PROMPT "Descrição do Produto" 		SIZE 080, 008 OF oDlg COLORS 0, 16777215 PIXEL
@ 115, 148 CHECKBOX oCheckBo5 VAR lCheckBo5  PROMPT "Grupo de Clientes" 			SIZE 080, 008 OF oDlg COLORS 0, 16777215 PIXEL
@ 125, 148 CHECKBOX oCheckBo6 VAR lCheckBo6  PROMPT "Grupo de Produtos" 			SIZE 080, 008 OF oDlg COLORS 0, 16777215 PIXEL
@ 135, 148 CHECKBOX oCheckBo7 VAR lCheckBo7  PROMPT "Considerar itens com venda" SIZE 080, 008 OF oDlg COLORS 0, 16777215 PIXEL
//@ 073, 208 CHECKBOX oCheckBo8 VAR lCheckBo8 PROMPT "Unidade de Negócio" 		SIZE 080, 008 OF oDlg COLORS 0, 16777215 PIXEL


@ 168, 008 SAY oSay1 PROMPT "Filtro:" 		SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
@ 168, 039 MSGET oGet1 VAR _cBuscar1 	SIZE 201, 010 OF oDlg COLORS 0, 16777215 PIXEL

@ 188, 018 GROUP oGroup2 TO 252, 250 PROMPT "Opções" 	OF oDlg COLOR 0, 16777215 PIXEL

@ 201, 048 CHECKBOX oCheckBb1 VAR lCheckBb1  PROMPT "Razão Social" 				SIZE 080, 008 OF oDlg COLORS 0, 16777215 PIXEL
@ 211, 048 CHECKBOX oCheckBb2 VAR lCheckBb2  PROMPT "Nome Reduzido" 				SIZE 080, 008 OF oDlg COLORS 0, 16777215 PIXEL
@ 222, 048 CHECKBOX oCheckBb3 VAR lCheckBb3  PROMPT "Código do Produto" 			SIZE 080, 008 OF oDlg COLORS 0, 16777215 PIXEL
@ 233, 048 CHECKBOX oCheckBb4 VAR lCheckBb4  PROMPT "Descrição do Produto" 		SIZE 080, 008 OF oDlg COLORS 0, 16777215 PIXEL
@ 201, 148 CHECKBOX oCheckBb5 VAR lCheckBb5  PROMPT "Grupo de Clientes" 			SIZE 080, 008 OF oDlg COLORS 0, 16777215 PIXEL
@ 211, 148 CHECKBOX oCheckBb6 VAR lCheckBb6  PROMPT "Grupo de Produtos" 			SIZE 080, 008 OF oDlg COLORS 0, 16777215 PIXEL
@ 222, 148 CHECKBOX oCheckBb7 VAR lCheckBb7  PROMPT "Considerar itens com venda" SIZE 080, 008 OF oDlg COLORS 0, 16777215 PIXEL

@ 283, 220 CHECKBOX oCheckBo9 VAR lCheckBo9 PROMPT "Exibir Ano Posterior" 		SIZE 080, 008 OF oDlg COLORS 0, 16777215 PIXEL

ACTIVATE MSDIALOG oDlg CENTERED

RestArea(_aSavArea)

Return()

Static Function ValidChe(cVar)

cVariavel:= "lCheckB"+cVar
If  SubStr(cVar,1,1) == 'o'
	If cVariavel <> "lCheckBo1"
		lCheckBo1:= .F.
	EndIf
	If cVariavel <> "lCheckBo2"
		lCheckBo2 := .F.
	EndIf
	If cVariavel <> "lCheckBo3"
		lCheckBo3 := .F.
	EndIF
	If cVariavel <> "lCheckBo4"
		lCheckBo4 := .F.
	EndIF
	If cVariavel <> "lCheckBo5"
		lCheckBo5 := .F.
	EndIf
	If cVariavel <> "lCheckBo6"
		lCheckBo6:= .F.
	EndIf
	If cVariavel <> "lCheckBo7"
		lCheckBo7:= .F.
	Endif
	
Else
	
	If cVariavel <> "lCheckBb1"
		lCheckBb1:= .F.
	EndIf
	If cVariavel <> "lCheckBb2"
		lCheckBb2 := .F.
	EndIf
	If cVariavel <> "lCheckBb3"
		lCheckBb3 := .F.
	EndIF
	If cVariavel <> "lCheckBb4"
		lCheckBb4 := .F.
	EndIF
	If cVariavel <> "lCheckBb5"
		lCheckBb5 := .F.
	EndIf
	If cVariavel <> "lCheckBb6"
		lCheckBb6:= .F.
	EndIf
	If cVariavel <> "lCheckBb7"
		lCheckBb7:= .F.
	Endif
Endif
Return


Static Function Selecao(_cTexto,_cTexto1)

Private _cQryTmp 	:= ""
Private _cMarca   	:= GetMark()
Private cCadastro	:= "Selecione os itens que deseja processar"
Default _cTexto		:= ""

_cTexto := "%" + _cTexto + "%"

//Funções chamadas na tela do markbrowse
Private aRotina 	:= {{"&Confirmar"	, "U_RCRME05C(1)",0,1},;
{"&Inverter"	, "U_RCRME05I()",0,1},;
{"&Voltar"		, "U_RCRME05V()",0,1} ,;
{"&Gerar Rel"		, "U_RCRME05C(2)",0,1}}

Private _bMark    	:= {|| MarkSel()}

_aCpoTmp := {} // Campos que serao exibidos no MarkBrowse

AADD(_aCpoTmp,{"TC_OK"		," "," "					}) 

/* Alterado por Denis 08/01/2018 */
AADD(_aCpoTmp,{"TC_UNINEG"	," ","Unidade de Negócio"	})
AADD(_aCpoTmp,{"TC_VENDED"	," ","Vendedor"				})
/* Alterado por Denis 08/01/2018 */

AADD(_aCpoTmp,{"TC_A1NOME"	," ","Razao Social"			})
AADD(_aCpoTmp,{"TC_NREDUZ"	," ","Nome Fantasia"		})
AADD(_aCpoTmp,{"TC_B1COD"	," ","Cod. Produto"			})
AADD(_aCpoTmp,{"TC_B1DESC"	," ","Descricao do Produto"	})
AADD(_aCpoTmp,{"TC_ACYDES"	," ","Grupo de Clientes"	})
AADD(_aCpoTmp,{"TC_BMDESC"	," ","Grupo de Produtos"	})
AADD(_aCpoTmp,{"TC_ALIAS"	," ","Alias"				})
AADD(_aCpoTmp,{"TC_RECNO"	," ","Recno"				})

_aEstru := {} // Estrutura do Arquivo Temporario

AADD(_aEstru,{"TC_OK"		, "C",02							,0								})            

/* Alterado por Denis 08/01/2018 */
AADD(_aEstru,{"TC_UNINEG"	, "C",TamSX3("ADK_NOME"		)[01]	,TamSX3("ADK_NOME"		)[02]	})
AADD(_aEstru,{"TC_VENDED"	, "C",TamSX3("A3_NOME"		)[01]	,TamSX3("A3_NOME"		)[02]	})
/* Alterado por Denis 08/01/2018 */

AADD(_aEstru,{"TC_A1NOME"	, "C",TamSX3("A1_NOME"		)[01]	,TamSX3("A1_NOME"		)[02]	})
AADD(_aEstru,{"TC_NREDUZ"	, "C",TamSX3("A1_NREDUZ"	)[01]	,TamSX3("A1_NREDUZ"		)[02]	})
AADD(_aEstru,{"TC_B1COD"	, "C",TamSX3("B1_COD"		)[01]	,TamSX3("B1_COD"		)[02]	})
AADD(_aEstru,{"TC_B1DESC"	, "C",TamSX3("B1_DESCINT"	)[01]	,TamSX3("B1_DESCINT"		)[02]	})
AADD(_aEstru,{"TC_ACYDES"	, "C",TamSX3("ACY_DESCRI"	)[01]	,TamSX3("ACY_DESCRI"	)[02]	})
AADD(_aEstru,{"TC_BMDESC"	, "C",TamSX3("BM_DESC"		)[01]	,TamSX3("BM_DESC"		)[02]	})
AADD(_aEstru,{"TC_ALIAS"	, "C",3								,0								})
AADD(_aEstru,{"TC_RECNO"	, "N",14							,0								})

_cTabTmp := GetNextAlias()

_cArq := CriaTrab(_aCpoTmp,.F.) //Nome do arquivo temporário


DbCreate(_cArq,_aEstru)
DbUseArea(.T.,,_cArq,_cTabTmp,.F.)


//Consulta no banco de dados para seleção dos tipos de produtos que serão considerados no relatório
_cQryTmp := "SELECT ''[OK],SA7.R_E_C_N_O_[A7_RECNO]		, " + _cEnter  

/* Alterado por Denis 08/01/2018 */
_cQryTmp += "ISNULL(SBM1.BM_DESC	,'') [ADK_NOME]	, " + _cEnter
_cQryTmp += "ISNULL(SA3.A3_NOME		,'') [A3_NOME]		, " + _cEnter
/* Alterado por Denis 08/01/2018 */

_cQryTmp += "ISNULL(SA1.A1_NOME		,'') [A1_NOME]		, " + _cEnter
_cQryTmp += "ISNULL(SA1.A1_NREDUZ	,'') [A1_NREDUZ]	, " + _cEnter
_cQryTmp += "ISNULL(SB1.B1_COD		,'') [B1_COD]		, " + _cEnter
_cQryTmp += "ISNULL(SB1.B1_DESCINT	,'') [B1_DESCINT]	, " + _cEnter
_cQryTmp += "ISNULL(ACY.ACY_DESCRI	,'') [ACY_DESCRI]	, " + _cEnter
_cQryTmp += "ISNULL(SBM.BM_DESC		,'') [BM_DESC]		  " + _cEnter
_cQryTmp += "FROM " + RetSqlName("SA7") + " SA7 WITH (NOLOCK) " + _cEnter
_cQryTmp += "INNER JOIN " + RetSqlName("SA1") + " SA1 WITH (NOLOCK) " + _cEnter
_cQryTmp += "ON SA7.D_E_L_E_T_='' " + _cEnter
_cQryTmp += "AND SA7.A7_FILIAL='" + xFilial("SA7") + "' " + _cEnter
_cQryTmp += "AND SA1.D_E_L_E_T_='' " + _cEnter
_cQryTmp += "AND SA1.A1_FILIAL='" + xFilial("SA1") + "' " + _cEnter
_cQryTmp += "AND SA7.A7_CLIENTE=SA1.A1_COD " + _cEnter
_cQryTmp += "AND SA7.A7_LOJA=SA1.A1_LOJA " + _cEnter
If Substr(nComboBo1,1,12) == "000004"+ '-' + "GERAL" .and. Substr(nComboBo2,1,6) == "000000"
ElseIF  Substr(nComboBo1,8,1) == 'B' .and. Substr(nComboBo2,1,6) == "000000"
	_cQryTmp +=   "	and substring(SA7.A7_XSEGMEN,1,4) =  '1000' "
ElseIF  Substr(nComboBo1,8,1) == 'D'.and. Substr(nComboBo2,1,6) == "000000"
	_cQryTmp +=   "	and substring(SA7.A7_XSEGMEN,1,4) =  '2000'  "
ElseIF  Substr(nComboBo1,8,1) == 'E' .and. Substr(nComboBo2,1,6) == "000000"
	_cQryTmp +=   "	and substring(SA7.A7_XSEGMEN,1,4) =  '3000'"
Else
	_cQryTmp += "AND SA1.A1_VEND=" + SubStr(nComboBo2,1,TamSX3("A3_COD")[01]) + " " + _cEnter
Endif

If lCheckBo7 //Considerar itens com venda a partir de janeiro do ano anterior
	_cQryTmp += "AND ((SELECT COUNT(*) QTD_NF FROM " + RetSqlName("SD2") + " SD2 WITH (NOLOCK) INNER JOIN " + RetSqlName("SF4") + " SF4 WITH (NOLOCK) ON SD2.D_E_L_E_T_='' AND SD2.D2_FILIAL='" + xFilial("SD2") + "' AND SD2.D2_TIPO NOT IN ('D','B') AND SD2.D2_EMISSAO>'" + StrZero(Year(dDataBase)-1,4) + "' AND SD2.D2_COD=SA7.A7_PRODUTO AND SD2.D2_CLIENTE=SA7.A7_CLIENTE AND SD2.D2_LOJA=SA7.A7_LOJA AND SF4.D_E_L_E_T_='' AND SF4.F4_FILIAL='" + xFilial("SF4") + "' AND SD2.D2_TES=SF4.F4_CODIGO AND SF4.F4_DUPLIC='S')>0) " + _cEnter
EndIf

/* Alterado por Denis 08/01/2018 */
_cQryTmp += "INNER JOIN SA3010 SA3 WITH (NOLOCK) " + _cEnter
_cQryTmp += "ON SA3.D_E_L_E_T_ = '' " + _cEnter
_cQryTmp += "AND SA3.A3_COD = SA1.A1_VEND " + _cEnter   


/* Alterado por Denis 15/08/2022 */
cUsuario := RetCodUsr()
DbSelectArea("SA3")
SA3->(DbSetOrder(7))
If SA3->(DbSeek(xFilial("SA3")+cUsuario)) .and. SA3->A3_XTIPO == 'V'
	_cQryTmp += " AND SA3.A3_COD = '"+SA3->A3_COD+"' " + _cEnter 
EndIf

_cQryTmp += "LEFT JOIN AOV010 AOV WITH (NOLOCK)" + _cEnter
_cQryTmp += "ON  AOV.D_E_L_E_T_ <> '*'" + _cEnter 
_cQryTmp += "AND SA7.A7_XSEGMEN = AOV.AOV_CODSEG" + _cEnter
//_cQryTmp += "LEFT JOIN ADK010 ADK WITH (NOLOCK) " + _cEnter
//_cQryTmp += "ON ADK.D_E_L_E_T_ = '' " + _cEnter
//_cQryTmp += "AND ADK.ADK_COD = SA3.A3_UNIDNEG " + _cEnter
/* Alterado por Denis 08/01/2018 */

_cQryTmp += "INNER JOIN " + RetSqlName("SB1") + " SB1 WITH (NOLOCK) " + _cEnter
_cQryTmp += "ON SB1.D_E_L_E_T_='' " + _cEnter
_cQryTmp += "AND SB1.B1_FILIAL='" + xFilial("SB1") + "' " + _cEnter
_cQryTmp += "AND SA7.A7_PRODUTO=SB1.B1_COD " + _cEnter
_cQryTmp += "LEFT JOIN " + RetSqlName("SBM") + " SBM WITH (NOLOCK) " + _cEnter
_cQryTmp += "ON SBM.D_E_L_E_T_='' " + _cEnter
_cQryTmp += "AND SBM.BM_FILIAL='" + xFilial("SBM") + "' " + _cEnter
_cQryTmp += "AND SBM.BM_GRUPO=SB1.B1_GRUPO " + _cEnter  
_cQryTmp += "LEFT JOIN " + RetSqlName("SBM") + " SBM1 WITH (NOLOCK) " + _cEnter
_cQryTmp += "ON SBM1.D_E_L_E_T_='' " + _cEnter
_cQryTmp += "AND SBM1.BM_FILIAL='" + xFilial("SBM") + "' " + _cEnter
_cQryTmp += "AND SBM1.BM_GRUPO=AOV.AOV_GRUPO " + _cEnter
_cQryTmp += "LEFT JOIN " + RetSqlName("ACY") + " ACY WITH (NOLOCK) " + _cEnter
_cQryTmp += "ON ACY.D_E_L_E_T_='' " + _cEnter
_cQryTmp += "AND ACY.ACY_FILIAL='" + xFilial("ACY") + "' " + _cEnter
_cQryTmp += "AND SA1.A1_GRPVEN=ACY.ACY_GRPVEN " + _cEnter

If !Empty(_cTexto)
	_lFirst := .T.
	
	If lCheckBo1 //Razão social
		
		If _lFirst
			_cQryTmp += "WHERE "
			_lFirst := .F.
		Else
			_cQryTmp += "OR "
		EndIf
		
		_cQryTmp += "UPPER(SA1.A1_NOME) LIKE '%" + _cTexto + "%' " + _cEnter
	EndIf
	
	If lCheckBo2 //Nome reduzido
		
		If _lFirst
			_cQryTmp += "WHERE "
			_lFirst := .F.
		Else
			_cQryTmp += "OR "
		EndIf
		
		_cQryTmp += "UPPER(SA1.A1_NREDUZ) LIKE '%" + _cTexto + "%' " + _cEnter
	EndIf
	
	If lCheckBo3 //Código do produto
		
		If _lFirst
			_cQryTmp += "WHERE "
			_lFirst := .F.
		Else
			_cQryTmp += "OR "
		EndIf
		
		_cQryTmp += "UPPER(SB1.B1_COD) LIKE '%" + _cTexto + "%' " + _cEnter
	EndIf
	
	If lCheckBo4 //Descrição do produto
		
		If _lFirst
			_cQryTmp += "WHERE "
			_lFirst := .F.
		Else
			_cQryTmp += "OR "
		EndIf
		
		_cQryTmp += "UPPER(SB1.B1_DESCINT) LIKE '%" + _cTexto + "%' " + _cEnter
	EndIf
	
	If lCheckBo5 //Grupo de clientes
		
		If _lFirst
			_cQryTmp += "WHERE "
			_lFirst := .F.
		Else
			_cQryTmp += "OR "
		EndIf
		
		_cQryTmp += "UPPER(ACY.ACY_DESCRI) LIKE '%" + _cTexto + "%' " + _cEnter
	EndIf
	
	If lCheckBo6 //Grupo de produtos
		
		If _lFirst
			_cQryTmp += "WHERE "
			_lFirst := .F.
		Else
			_cQryTmp += "OR "
		EndIf
		
		_cQryTmp += "UPPER(SBM.BM_DESC) LIKE '%" + _cTexto + "%' " + _cEnter
	EndIf
EndIf

If !Empty(_cTexto1)
	
	
	If lCheckBb1 //Razão social
		
		If _lFirst
			_cQryTmp += "WHERE "
			_lFirst := .F.
		Else
			_cQryTmp += "AND "
		EndIf
		
		_cQryTmp += "UPPER(SA1.A1_NOME) LIKE '%" + _cTexto1 + "%' " + _cEnter
	EndIf
	
	If lCheckBb2 //Nome reduzido
		
		If _lFirst
			_cQryTmp += "WHERE "
			_lFirst := .F.
		Else
			_cQryTmp += "AND "
		EndIf
		
		_cQryTmp += "UPPER(SA1.A1_NREDUZ) LIKE '%" + _cTexto1 + "%' " + _cEnter
	EndIf
	
	If lCheckBb3 //Código do produto
		
		If _lFirst
			_cQryTmp += "WHERE "
			_lFirst := .F.
		Else
			_cQryTmp += "AND "
		EndIf
		
		_cQryTmp += "UPPER(SB1.B1_COD) LIKE '%" + _cTexto1 + "%' " + _cEnter
	EndIf
	
	If lCheckBb4 //Descrição do produto
		
		If _lFirst
			_cQryTmp += "WHERE "
			_lFirst := .F.
		Else
			_cQryTmp += "AND "
		EndIf
		
		_cQryTmp += "UPPER(SB1.B1_DESCINT) LIKE '%" + _cTexto1 + "%' " + _cEnter
	EndIf
	
	If lCheckBb5 //Grupo de clientes
		
		If _lFirst
			_cQryTmp += "WHERE "
			_lFirst := .F.
		Else
			_cQryTmp += "AND "
		EndIf
		
		_cQryTmp += "UPPER(ACY.ACY_DESCRI) LIKE '%" + _cTexto1 + "%' " + _cEnter
	EndIf
	
	If lCheckBb6 //Grupo de produtos
		
		If _lFirst
			_cQryTmp += "WHERE "
			_lFirst := .F.
		Else
			_cQryTmp += "AND "
		EndIf
		
		_cQryTmp += "UPPER(SBM.BM_DESC) LIKE '%" + _cTexto1 + "%'" + _cEnter
	EndIf
EndIf

If SUBSTR(UPPER(nComboBo1),1,3) == "   "
	_cQryTmp += "ORDER BY A1_NOME, B1_DESCINT " + _cEnter
ElseIf SUBSTR(UPPER(nComboBo1),1,3) == "RAZ"
	_cQryTmp += "ORDER BY A1_NOME, B1_DESCINT " + _cEnter
ElseIf SUBSTR(UPPER(nComboBo1),1,3) == "NOM"
	_cQryTmp += "ORDER BY A1_NREDUZ, B1_DESCINT " + _cEnter
ElseIf SUBSTR(UPPER(nComboBo1),1,3) == "COD"
	_cQryTmp += "ORDER BY B1_DESCINT " + _cEnter
ElseIf SUBSTR(UPPER(nComboBo1),1,3) == "GRP"
	_cQryTmp += "ORDER BY ACY_DESCRI, B1_DESCINT " + _cEnter
Endif
memowrite("TelaForecast.txt",_cQryTmp)

Processa( {||dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQryTmp),_cAliasQry,.F.,.T.)}, "Aguarde...", "Selecionando dados...",.F.)

dbSelectArea(_cAliasQry)
dbGoTop()

If (_cAliasQry)->(EOF())
	
	MsgAlert("Nenhum resultado encontrado para os filtros definidos!",_cRotina+"_001")
	
	dbSelectArea(_cAliasQry)
	(_cAliasQry)->(dbCloseArea())
	
	Return()
EndIf

While (_cAliasQry)->(!EOF())
	
	dbSelectArea(_cTabTmp)
	
	//Preencho a tabela temporária com o resultado da query
	RecLock(_cTabTmp,.T.)
	(_cTabTmp)->TC_OK		:= (_cAliasQry)->OK
	
	/* Alterado por Denis 08/01/2018 */
	(_cTabTmp)->TC_UNINEG	:= (_cAliasQry)->ADK_NOME
	(_cTabTmp)->TC_VENDED	:= (_cAliasQry)->A3_NOME
	/* Alterado por Denis 08/01/2018 */             
	
	(_cTabTmp)->TC_A1NOME	:= (_cAliasQry)->A1_NOME
	(_cTabTmp)->TC_NREDUZ	:= (_cAliasQry)->A1_NREDUZ
	(_cTabTmp)->TC_B1COD	:= (_cAliasQry)->B1_COD
	(_cTabTmp)->TC_B1DESC	:= (_cAliasQry)->B1_DESCINT
	(_cTabTmp)->TC_ACYDES	:= (_cAliasQry)->ACY_DESCRI
	(_cTabTmp)->TC_BMDESC	:= (_cAliasQry)->BM_DESC
	(_cTabTmp)->TC_ALIAS	:= "SA7"
	(_cTabTmp)->TC_RECNO	:= (_cAliasQry)->A7_RECNO
	(_cTabTmp)->(MsUnlock())
	
	dbSelectArea(_cAliasQry)
	dbSkip()
EndDo

dbSelectArea(_cAliasQry)
(_cAliasQry)->(dbCloseArea())

dbSelectArea(_cTabTmp)

//Crio tela para marcação dos itens a serem impressos, dentro do intervalo de parâmetros definidos pelo usuário
MarkBrowse(Alias(),"TC_OK",,_aCpoTmp,,_cMarca,"U_RCRME05C()",,,,"eval(_bMark)")

Return()

//Confirma
User Function RCRME05C(nVar)
Default nVar := 0
_aRecnoA7 := {}

dbSelectArea(_cTabTmp)
dbGoTop()

While (_cTabTmp)->(!EOF())
	
	If !Empty((_cTabTmp)->TC_OK)
		AAdd(_aRecnoA7,{POsicione("SA1",5,xFilial("SA1")+(_cTabTmp)->TC_NREDUZ ,"A1_COD"),;
		POsicione("SA1",5,xFilial("SA1")+(_cTabTmp)->TC_NREDUZ ,"A1_LOJA"),;
		(_cTabTmp)->TC_B1COD })
	EndIf
	
	
	(_cTabTmp)->(dbSkip())
EndDo

_cTabTmp	:= GetNextAlias()
_cAliasQry	:= GetNextAlias()

If nVar == 1
	CloseBrowse()
	
	Processa( {|| Facilitador(_aRecnoA7) }, "Processando...", "Preparando ambiente...",.F.)
Elseif nVar == 2
	Processa( {|| U_RCRMR010() }, "Processando...", "Preparando ambiente...",.F.)
	CloseBrowse()
Else
	CloseBrowse()
	
	Processa( {|| Facilitador(_aRecnoA7) }, "Processando...", "Preparando ambiente...",.F.)
EndIF
Return()

//Inverte Seleção
User Function RCRME05I()

(_cTabTmp)->(DbGoTop())

While (_cTabTmp)->(!EOF())
	MarkSel()
	(_cTabTmp)->(DbSkip())
EndDo

Return()

//Volta para a tela de filtro
User Function RCRME05V()

_cTabTmp	:= GetNextAlias()
_cAliasQry	:= GetNextAlias()

CloseBrowse()
Return()

Static Function MarkSel()

Local lDesmarc := IsMark("TC_OK", _cMarca, .T.)

If !Empty((_cTabTmp)->TC_OK)
	DbSelectArea(_cTabTmp)
	
	RecLock(_cTabTmp,.F.)
	(_cTabTmp)->TC_OK := Space(2)
	(_cTabTmp)->(MsUnlock())
Else
	DbSelectArea(_cTabTmp)
	
	RecLock(_cTabTmp,.F.)
	(_cTabTmp)->TC_OK :=  _cMarca
	(_cTabTmp)->(MsUnlock())
EndIf

Return()

Static Function Facilitador(_aRecnosA7)

Default _aRecnosA7 	:= {}
Private oPanel2
Private _aSize		:= MsAdvSize()
Private oFont1		:= TFont():New("Arial",,016,,.F.,,,,,.F.,.F.)
Private	_cEnter		:= CHR(13) + CHR(10)
Private _aRecnos	:= {}
Private _nTamBtn	:= 060
Private _nEspPad	:= 015
Private _nPrcAtu	:= 0
Private _nPrcPos	:= 0
Private _nMoeda		:= 1
private aColsExa				:= {}
Public oMSNewGeF
Static oDlg

DEFINE MSDIALOG oDlg TITLE "Facilitador - Forecast" FROM _aSize[1], _aSize[1]  TO _aSize[6], _aSize[5] COLORS 0, 16777215 FONT oFont1  PIXEL

@ 000, 000 MSPANEL oPanel2 PROMPT "oPanel2" SIZE (_aSize[5]/2)-000, _aSize[4]-05 OF oDlg COLORS 0, 16777215 RAISED

fWBrowse(,_aRecnosA7)

oMSNewGeF:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
oMSNewGeF:oBrowse:bHeaderClick := {|oMSNewGeF,nCol| Ordena(nCol)}
oMSNewGeF:oBrowse:bRClicked := { |o,x,y| MenuSusp(o,x,y+120) }

ACTIVATE MSDIALOG oDlg CENTERED

Return()

Static Function fWBrowse(_nAnoBase,_aRecnosA7)

Local nX
Local _nItens
Local _nLin
Default _aRecnosA7	:= {}
Default _nAnoBase	:= Year(dDataBase)
_lCriaObj  			:= .F.
_nPrcAtu			:= 0
_nPrcPos			:= 0
_nMoeda				:= 1
aHeaderEx 			:= {}

aFieldFill			:= {}        

/* Alterado por Denis 08/01/2018 */           
aFields 			:= {Space(10),"Cliente","Produto","Total Vlr.","Total Qtd.","Jan","Fev","Mar","Abr","Mai","Jun","Jul","Ago","Set","Out","Nov","Dez","Última Alteração","Vendedor","Unidade de Negócio"}
/* Alterado por Denis 08/01/2018 */       
    
// aAlterFields		:= {"Z2_QTM01","Z2_QTM02","Z2_QTM03","Z2_QTM04","Z2_QTM05","Z2_QTM06","Z2_QTM07","Z2_QTM08","Z2_QTM09","Z2_QTM10","Z2_QTM11","Z2_QTM12"}
aAlterFields		:= {} 
nFreeze				:= 0
_lCriaObj			:= .T.

// Define field properties
DbSelectArea("SX3")
SX3->(DbSetOrder(2))
For nX := 1 to Len(aFields)
	If nX == 1
		If SX3->(DbSeek("Z2_TOPICO"))
			Aadd(aHeaderEx, {AllTrim(aFields[nX]),SX3->X3_CAMPO,SX3->X3_PICTURE,15,SX3->X3_DECIMAL,SX3->X3_VALID,;
			SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
		EndIf
	ElseIf nX == 2
		If SX3->(DbSeek("A1_NREDUZ"))
			Aadd(aHeaderEx, {AllTrim(aFields[nX]),SX3->X3_CAMPO,SX3->X3_PICTURE,15,SX3->X3_DECIMAL,SX3->X3_VALID,;
			SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
		EndIf
	ElseIf nX == 3
		If SX3->(DbSeek("B1_DESCINT"))
			Aadd(aHeaderEx, {AllTrim(aFields[nX]),SX3->X3_CAMPO,SX3->X3_PICTURE,20,SX3->X3_DECIMAL,SX3->X3_VALID,;
			SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
		EndIf
	ElseIf nX == 4
		If SX3->(DbSeek("Z2_VLM01"))
			Aadd(aHeaderEx, {AllTrim(aFields[nX]),SX3->X3_CAMPO,SX3->X3_PICTURE,3,SX3->X3_DECIMAL,SX3->X3_VALID,;
			SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
		EndIf
	ElseIf nX == 5
		If SX3->(DbSeek("Z2_QTM01"))
			Aadd(aHeaderEx, {AllTrim(aFields[nX]),"Z2_QTDTOT",SX3->X3_PICTURE,3,SX3->X3_DECIMAL,SX3->X3_VALID,;
			SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
		EndIf
	ElseIf nX < 18
		If SX3->(DbSeek("Z2_QTM"+StrZero(nX-5,2)))
			Aadd(aHeaderEx, {AllTrim(aFields[nX]),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
			SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
		EndIf
	/* Alterado por Denis 08/01/2018 */           
	ElseIf nX == 18
		If SX3->(DbSeek("Z2_DATA"))
			Aadd(aHeaderEx, {AllTrim(aFields[nX]),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
			SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
		EndIf
	ElseIf nX == 19
		If SX3->(DbSeek("A3_NOME"))
			Aadd(aHeaderEx, {AllTrim(aFields[nX]),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
			SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
		EndIf
	ElseIf nX == 20
		If SX3->(DbSeek("ADK_NOME"))
			Aadd(aHeaderEx, {AllTrim(aFields[nX]),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
			SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
		EndIf
	EndIf
	/* Alterado por Denis 08/01/2018 */           
Next nX

ProcRegua(Len(_aRecnosA7))

For _nItens := 1 To Len(_aRecnosA7)
	
	IncProc("Item " + AllTrim(Str(_nItens)) + " de " + AllTrim(Str(Len(_aRecnosA7))))
	
	
	
	dbSelectArea("SZ2")
	dbSetOrder(1)
	If !dbSeek(xFilial("SZ2") + _aRecnosA7[_nItens][1] + _aRecnosA7[_nItens][2]  + PadR(_aRecnosA7[_nItens][3] ,TamSX3("Z2_PRODUTO")[01]) + AllTrim(Str((_nAnoBase + 1))) + "F")
		Reclock("SZ2",.T.)
		SZ2->Z2_FILIAL	:= xFilial("SZ2")
		SZ2->Z2_PRODUTO	:= _aRecnosA7[_nItens][3]
		SZ2->Z2_CLIENTE	:= _aRecnosA7[_nItens][1]
		SZ2->Z2_LOJA	:= _aRecnosA7[_nItens][2]
		SZ2->Z2_ANO		:= _nAnoBase + 1
		SZ2->Z2_TOPICO	:= "F" //F=Forecast | B=Budget
		SZ2->(MsUnlock())
	EndIf
	
	If lCheckBo9
		
		_nPrcPos := U_RCRME007(SZ2->Z2_CLIENTE,SZ2->Z2_LOJA,SZ2->Z2_PRODUTO,StrZero(SZ2->Z2_ANO,4),"2") //inclusão do paramentro preço bruto
		
	/* Alterado por Denis 08/01/2018 */           
		cVend := Posicione("SA1",1,xFilial("SA1")+SZ2->Z2_CLIENTE+SZ2->Z2_LOJA	,"A1_VEND")
		cUnid := Posicione("SA3",1,xFilial("SA3")+cVend	,"A3_UNIDNEG")
	/* Alterado por Denis 08/01/2018 */           
		
		aFieldFill	:= {}  
		
		AAdd(aFieldFill, "Forecast Posterior")
		AAdd(aFieldFill, Posicione("SA1",1,xFilial("SA1")+SZ2->Z2_CLIENTE+SZ2->Z2_LOJA	,"A1_NREDUZ"))
		AAdd(aFieldFill, Posicione("SB1",1,xFilial("SB1")+SZ2->Z2_PRODUTO				,"B1_DESCINT"	))
		AAdd(aFieldFill, (SZ2->Z2_QTM01+SZ2->Z2_QTM02+SZ2->Z2_QTM03+SZ2->Z2_QTM04+SZ2->Z2_QTM05+SZ2->Z2_QTM06+SZ2->Z2_QTM07+SZ2->Z2_QTM08+SZ2->Z2_QTM09+SZ2->Z2_QTM10+SZ2->Z2_QTM11+SZ2->Z2_QTM12)*_nPrcPos)
		AAdd(aFieldFill, SZ2->Z2_QTM01+SZ2->Z2_QTM02+SZ2->Z2_QTM03+SZ2->Z2_QTM04+SZ2->Z2_QTM05+SZ2->Z2_QTM06+SZ2->Z2_QTM07+SZ2->Z2_QTM08+SZ2->Z2_QTM09+SZ2->Z2_QTM10+SZ2->Z2_QTM11+SZ2->Z2_QTM12)
		AAdd(aFieldFill, SZ2->Z2_QTM01)
		AAdd(aFieldFill, SZ2->Z2_QTM02)
		AAdd(aFieldFill, SZ2->Z2_QTM03)
		AAdd(aFieldFill, SZ2->Z2_QTM04)
		AAdd(aFieldFill, SZ2->Z2_QTM05)
		AAdd(aFieldFill, SZ2->Z2_QTM06)
		AAdd(aFieldFill, SZ2->Z2_QTM07)
		AAdd(aFieldFill, SZ2->Z2_QTM08)
		AAdd(aFieldFill, SZ2->Z2_QTM09)
		AAdd(aFieldFill, SZ2->Z2_QTM10)
		AAdd(aFieldFill, SZ2->Z2_QTM11)
		AAdd(aFieldFill, SZ2->Z2_QTM12)
		AAdd(aFieldFill, SZ2->Z2_DATA )
	/* Alterado por Denis 08/01/2018 */           
		AAdd(aFieldFill, Posicione("SA3",1,xFilial("SA3")+cVend	,"A3_NOME"))
		AAdd(aFieldFill, Posicione("ADK",1,xFilial("ADK")+cUnid	,"ADK_NOME"))
	/* Alterado por Denis 08/01/2018 */           
		AAdd(aFieldFill,SZ2->(Recno()))
		
		AAdd(_aRecnos,SZ2->(Recno()))
		Aadd(aFieldFill, .F.)
		Aadd(aColsExA, aFieldFill)
	
	EndIf
	
	dbSelectArea("SZ2")
	dbSetOrder(1)
	If !dbSeek(xFilial("SZ2") + _aRecnosA7[_nItens][1] + _aRecnosA7[_nItens][2]  + PadR(_aRecnosA7[_nItens][3] ,TamSX3("Z2_PRODUTO")[01]) + AllTrim(Str((_nAnoBase )))  + "F")
		Reclock("SZ2",.T.)
		SZ2->Z2_FILIAL	:= xFilial("SZ2")
		SZ2->Z2_PRODUTO	:= _aRecnosA7[_nItens][3]
		SZ2->Z2_CLIENTE	:= _aRecnosA7[_nItens][1]
		SZ2->Z2_LOJA	:= _aRecnosA7[_nItens][2]
		SZ2->Z2_ANO		:= _nAnoBase
		SZ2->Z2_TOPICO	:= "F" //F=Forecast | B=Budget
		SZ2->(MsUnlock())
	EndIf

	_nPrcAtu := U_RCRME007(SZ2->Z2_CLIENTE,SZ2->Z2_LOJA,SZ2->Z2_PRODUTO,StrZero(SZ2->Z2_ANO,4),"2") //inclusão do paramentro preço bruto
		
	/* Alterado por Denis 08/01/2018 */           
		cVend := Posicione("SA1",1,xFilial("SA1")+SZ2->Z2_CLIENTE+SZ2->Z2_LOJA	,"A1_VEND")
		cUnid := Posicione("SA3",1,xFilial("SA3")+cVend	,"A3_UNIDNEG")
	/* Alterado por Denis 08/01/2018 */        
	
	aFieldFill := {}
	
	AAdd(aFieldFill, "Forecast Atual")
	AAdd(aFieldFill, Posicione("SA1",1,xFilial("SA1")+SZ2->Z2_CLIENTE+SZ2->Z2_LOJA	,"A1_NREDUZ"	))
	AAdd(aFieldFill, Posicione("SB1",1,xFilial("SB1")+SZ2->Z2_PRODUTO				,"B1_DESCINT"	))
	AAdd(aFieldFill, (SZ2->Z2_QTM01+SZ2->Z2_QTM02+SZ2->Z2_QTM03+SZ2->Z2_QTM04+SZ2->Z2_QTM05+SZ2->Z2_QTM06+SZ2->Z2_QTM07+SZ2->Z2_QTM08+SZ2->Z2_QTM09+SZ2->Z2_QTM10+SZ2->Z2_QTM11+SZ2->Z2_QTM12)*_nPrcAtu)
	AAdd(aFieldFill, SZ2->Z2_QTM01+SZ2->Z2_QTM02+SZ2->Z2_QTM03+SZ2->Z2_QTM04+SZ2->Z2_QTM05+SZ2->Z2_QTM06+SZ2->Z2_QTM07+SZ2->Z2_QTM08+SZ2->Z2_QTM09+SZ2->Z2_QTM10+SZ2->Z2_QTM11+SZ2->Z2_QTM12)
	AAdd(aFieldFill, SZ2->Z2_QTM01)
	AAdd(aFieldFill, SZ2->Z2_QTM02)
	AAdd(aFieldFill, SZ2->Z2_QTM03)
	AAdd(aFieldFill, SZ2->Z2_QTM04)
	AAdd(aFieldFill, SZ2->Z2_QTM05)
	AAdd(aFieldFill, SZ2->Z2_QTM06)
	AAdd(aFieldFill, SZ2->Z2_QTM07)
	AAdd(aFieldFill, SZ2->Z2_QTM08)
	AAdd(aFieldFill, SZ2->Z2_QTM09)
	AAdd(aFieldFill, SZ2->Z2_QTM10)
	AAdd(aFieldFill, SZ2->Z2_QTM11)
	AAdd(aFieldFill, SZ2->Z2_QTM12)
	AAdd(aFieldFill, SZ2->Z2_DATA )
	/* Alterado por Denis 08/01/2018 */           
		AAdd(aFieldFill, Posicione("SA3",1,xFilial("SA3")+cVend	,"A3_NOME"))
		AAdd(aFieldFill, Posicione("ADK",1,xFilial("ADK")+cUnid	,"ADK_NOME"))
	/* Alterado por Denis 08/01/2018 */          
	AAdd(aFieldFill,SZ2->(Recno()))
	
	AAdd(_aRecnos,SZ2->(Recno()))
	Aadd(aFieldFill, .F.)
	Aadd(aColsExA, aFieldFill)
	
	dbSelectArea("SZ2")
	dbSetOrder(1)
	If !dbSeek(xFilial("SZ2") + _aRecnosA7[_nItens][1] + _aRecnosA7[_nItens][2]  + PadR(_aRecnosA7[_nItens][3] ,TamSX3("Z2_PRODUTO")[01]) + AllTrim(Str((_nAnoBase + 1)))  + "B")
		Reclock("SZ2",.T.)
		SZ2->Z2_FILIAL	:= xFilial("SZ2")
		SZ2->Z2_PRODUTO	:= _aRecnosA7[_nItens][3]
		SZ2->Z2_CLIENTE	:= _aRecnosA7[_nItens][1]
		SZ2->Z2_LOJA	:= _aRecnosA7[_nItens][2]
		SZ2->Z2_ANO		:= _nAnoBase
		SZ2->Z2_TOPICO	:= "B" //F=Forecast | B=Budget
		SZ2->(MsUnlock())
	EndIf
Next

If _lCriaObj
	oMSNewGeF := MsNewGetDados():New( 000, 000, 033, (_aSize[5]/2)-008, GD_UPDATE, "AllwaysTrue", "AllwaysTrue", "", aAlterFields,nFreeze, Len(aColsExA), "U_RCRME05A", "", "AllwaysTrue", oPanel2, aHeaderEx, aColsExA)
Else
	oMSNewGeF:aCols := aClone(aColsExA)
	
	oMSNewGeF:Refresh(.T.)
EndIf

Return()







STATIC FUNCTION Ordena(nCol)

aColsExA := aSort( aColsExA,,,{|x,y| x[nCol] > y[nCol]})
// _nLin := aScan(_aRecnos,aColsEx[1][19])
// _aRecnos := aSort( _aRecnos,,,{|x,y| x[_nLin] > y[_nLin]})
oMSNewGeF:setArray(aColsExA)
oMSNewGeF:oBrowse:Refresh()

RETURN

Static Function Detalhe()

Local _nLin
Local _aRecTemp := {}
Local _nPosAux  
//Local _aRecnos        
//Local aColsExA

SetKey(VK_F5,{|| })
dbSelectArea("SZ2")
_nLinT := aScan(_aRecnos,aColsExA[oMSNewGeF:oBrowse:nAt][21])
dbGoTo(_aRecnos[_nLinT])

U_RCRME001(SZ2->Z2_CLIENTE,SZ2->Z2_LOJA,SZ2->Z2_PRODUTO)

dbSelectArea("SZ2")
dbGoTo(_aRecnos[_nLinT])

AAdd(_aRecTemp,_aRecnos[_nLinT])

If lCheckBo9
	If oMSNewGeF:aCols[_nLinT,1] == "Forecast Atual"
		AAdd(_aRecTemp,_aRecnos[_nLinT]-1)
	Else
		AAdd(_aRecTemp,_aRecnos[_nLinT]+1)
	EndIf
EndIf

For _nPosAux := 1 To Len(_aRecTemp)
	
	_nLin := _nLinT//aScan(_aRecnos,_aRecTemp[_nLinT])
	
	dbSelectArea("SZ2")
	dbGoTo(_aRecTemp[1])
	
	If _nLin > 0
		
		_nPrcVen := U_RCRME007(SZ2->Z2_CLIENTE,SZ2->Z2_LOJA,SZ2->Z2_PRODUTO,StrZero(SZ2->Z2_ANO,4),"2") //inclusão do paramentro preço bruto
		
	/* Alterado por Denis 08/01/2018 */           
		cVend := Posicione("SA1",1,xFilial("SA1")+SZ2->Z2_CLIENTE+SZ2->Z2_LOJA	,"A1_VEND")
		cUnid := Posicione("SA3",1,xFilial("SA3")+cVend	,"A3_UNIDNEG")
	/* Alterado por Denis 08/01/2018 */           
		
		oMSNewGeF:aCols[_nLin,04] := (SZ2->Z2_QTM01+SZ2->Z2_QTM02+SZ2->Z2_QTM03+SZ2->Z2_QTM04+SZ2->Z2_QTM05+SZ2->Z2_QTM06+SZ2->Z2_QTM07+SZ2->Z2_QTM08+SZ2->Z2_QTM09+SZ2->Z2_QTM10+SZ2->Z2_QTM11+SZ2->Z2_QTM12)*_nPrcVen
		oMSNewGeF:aCols[_nLin,05] := SZ2->Z2_QTM01+SZ2->Z2_QTM02+SZ2->Z2_QTM03+SZ2->Z2_QTM04+SZ2->Z2_QTM05+SZ2->Z2_QTM06+SZ2->Z2_QTM07+SZ2->Z2_QTM08+SZ2->Z2_QTM09+SZ2->Z2_QTM10+SZ2->Z2_QTM11+SZ2->Z2_QTM12
		oMSNewGeF:aCols[_nLin,06] := SZ2->Z2_QTM01
		oMSNewGeF:aCols[_nLin,07] := SZ2->Z2_QTM02
		oMSNewGeF:aCols[_nLin,08] := SZ2->Z2_QTM03
		oMSNewGeF:aCols[_nLin,09] := SZ2->Z2_QTM04
		oMSNewGeF:aCols[_nLin,10] := SZ2->Z2_QTM05
		oMSNewGeF:aCols[_nLin,11] := SZ2->Z2_QTM06
		oMSNewGeF:aCols[_nLin,12] := SZ2->Z2_QTM07
		oMSNewGeF:aCols[_nLin,13] := SZ2->Z2_QTM08
		oMSNewGeF:aCols[_nLin,14] := SZ2->Z2_QTM09
		oMSNewGeF:aCols[_nLin,15] := SZ2->Z2_QTM10
		oMSNewGeF:aCols[_nLin,16] := SZ2->Z2_QTM11
		oMSNewGeF:aCols[_nLin,17] := SZ2->Z2_QTM12
		oMSNewGeF:aCols[_nLin,18] := SZ2->Z2_DATA
	/* Alterado por Denis 08/01/2018 */           
		oMSNewGeF:aCols[_nLin,19] := Posicione("SA3",1,xFilial("SA3")+cVend	,"A3_NOME")
		oMSNewGeF:aCols[_nLin,20] := Posicione("ADK",1,xFilial("ADK")+cUnid	,"ADK_NOME")
	/* Alterado por Denis 08/01/2018 */ 
		oMSNewGeF:aCols[_nLin,21] := SZ2->(Recno())
		oMSNewGeF:Refresh(.T.)
	EndIf
Next

dbSelectArea("SZ2")
dbGoTo(_aRecnos[_nLinT])                                               

SetKey(VK_F5,{|| })
SetKey(VK_F5,{|| Detalhe()})

Return()

Static Function GerComer()

Local _aRet := {}

dbSelectArea("SA3")
dbSetOrder(7) //Filial + Usuário
If dbSeek(xFilial("SA3")+__cUserId)
	_cCodSA3 := SA3->A3_COD
	If trim(SA3->A3_XTIPO) == 'V' //Caso o usuário tenha gerente, retorno o código do gerente
		
		cQry := "SELECT * FROM "+RETSQLNAME("ADK")+" where ADK_COD = '"+SA3->A3_UNIDNEG+"'"
		cQry := ChangeQuery(cQry)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),"TMPA",.F.,.T.)
		
		/*
		dbSelectArea("SA3")
		dbSetOrder(1)
		If dbSeek(xFilial("SA3")+_cCodGer)
		If SELECT("TMPA") >0
		TMPA->(DBCLOSEAREA())
		endif
		
		cQry := "SELECT * FROM "+RETSQLNAME("ADK")+" where ADK_RESP = '"+_cCodGer+"'"
		cQry := ChangeQuery(cQry)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),"TMPA",.F.,.T.)
		*/
		
		AAdd(_aRet,AllTrim(TMPA->ADK_COD + '-' + TMPA->ADK_NOME))
		
		Return(_aRet)
	ElseIf trim(SA3->A3_XTIPO) == 'S' //Caso o usuário tenha supervisor, retorno ele mesmo (gerente)
		/*
		_cCodGer := SA3->A3_GEREN
		If SELECT("TMPA") >0
		TMPA->(DBCLOSEAREA())
		endif
		cQry := "SELECT * FROM "+RETSQLNAME("ADK")+" where ADK_RESP = '"+_cCodGer+"'"
		cQry := ChangeQuery(cQry)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),"TMPA",.F.,.T.)
		*/
		
		cQry := "SELECT * FROM "+RETSQLNAME("ADK")+" where ADK_COD = '"+SA3->A3_UNIDNEG+"'"
		cQry := ChangeQuery(cQry)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),"TMPA",.F.,.T.)
		
		AAdd(_aRet,AllTrim(TMPA->ADK_COD + '-' + TMPA->ADK_NOME))
		
		Return(_aRet)
	EndIf
EndIf

//Caso contrário retorno todos os gerentes comerciais (usuário master)
_cQry := "SELECT A3_COD + '-' + A3_NOME AS [GERENTE] FROM " + RetSqlName("SA3") + " SA3 "
_cQry += "WHERE SA3.D_E_L_E_T_='' "
_cQry += "AND SA3.A3_FILIAL='" + xFilial("SA3") + "' " 
_cQry += "AND SA3.A3_COD IN "
_cQry += "( "
_cQry += "	SELECT DISTINCT A3_COD FROM " + RetSqlName("SA3") + " AUX "
_cQry += "	WHERE AUX.D_E_L_E_T_='' "
_cQry += "	AND AUX.A3_SUPER<>'' "
_cQry += "	AND AUX.A3_FILIAL='" + xFilial("SA3") + "' "
_cQry += ") "
_cQry += "ORDER BY GERENTE "

_cAliasTmp := GetNextAlias()


dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQry),_cAliasTmp,.F.,.T.)

dbSelectArea(_cAliasTmp)

While (_cAliasTmp)->(!EOF())
	
	AAdd(_aRet,AllTrim((_cAliasTmp)->GERENTE))
	
	dbSelectArea(_cAliasTmp)
	dbSkip()
EndDo
_aRet:={}
If SELECT("TMPA") >0
	TMPA->(DBCLOSEAREA())
endif
cQry := "SELECT TOP 3 * FROM "+RETSQLNAME("ADK")+" "
cQry := ChangeQuery(cQry)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),"TMPA",.F.,.T.)

While TMPA->(!EOF())
	AAdd(_aRet,AllTrim(TMPA->ADK_COD + '-' + TMPA->ADK_NOME))
	TMPA->(dbSkip())
EndDo
AAdd(_aRet,AllTrim("000004"+ '-' + "GERAL"))
TMPA->(dbCloseArea())

Return(_aRet)

Static Function GerConta()

Local _aRet := {}

dbSelectArea("SA3")
dbSetOrder(7) //Filial + Usuário
If dbSeek(xFilial("SA3")+__cUserId)
	
	_cCodSA3 := SA3->A3_COD
	
	If trim(SA3->A3_XTIPO) == 'V' //Caso o usuário tenha gerente, retorno ele mesmo (gerente de conta)
		
		AAdd(_aRet,AllTrim(SA3->A3_COD + '-' + SA3->A3_NOME))
		Return(_aRet)
		
	ElseIf trim(SA3->A3_XTIPO) == 'S' //Caso o usuário tenha supervisor, retorno ele mesmo (gerente) + todos os gerentes de conta que ele coordena
		_cCodSA3 := SA3->A3_COD
		
		dbSelectArea("SA3")
		dbSetOrder(5) //Filial + Gerente
		If dbSeek(xFilial("SA3")+_cCodSA3)
			While SA3->(!EOF())	.And. SA3->A3_FILIAL==xFilial("SA3") .And. SA3->A3_SUPER ==_cCodSA3
				
				AAdd(_aRet,AllTrim(SA3->A3_COD + '-' + SA3->A3_NOME))
				
				dbSkip()
			EndDo
			AAdd(_aRet,AllTrim("000000" + '-' + "GERAL"))
		EndIf
		
		Return(_aRet)
	ElseIf trim(SA3->A3_XTIPO) == 'G'
		
		If nComboBo1 == Nil
			If Len(_aGerCome)>0
				nComboBo1 := _aGerCome[1]
			Else
				Return(_aRet)
			EndIf
		EndIf
		
		_cCodSA3 := SubStr(nComboBo1,1,TamSX3("A3_COD")[01])
		
		//dbSelectArea("SA3")
		//dbSetOrder(1) //Filial + Vendedor
		//If dbSeek(xFilial("SA3")+_cCodSA3)
		//	AAdd(_aRet,AllTrim(SA3->A3_COD + '-' + SA3->A3_NOME))
		//EndIf
		
		cQry:= "SELECT * FROM SA3010 where A3_UNIDNEG = '"+_cCodSA3+"' and A3_MSBLQL = '2'  and D_E_L_E_T_ = '' " 
        
		/*
		cQry := " SELECT DISTINCT A3_COD,A3_NOME from SA7010 A7 "
		cQry += " INNER JOIN SA1010 A1 ON A1_COD = A7_CLIENTE AND A1_LOJA = A7_LOJA AND A1.D_E_L_E_T_ = '' "
		cQry += " INNER JOIN SA3010 A3 ON A3_COD = A1_VEND "
		cQry += " where A7_XSEGMEN = '"+_cCodSA3+"' AND A7.D_E_L_E_T_ = '' "
		*/
		cQry := ChangeQuery(cQry)
		If SELECT("TMPA") >0
			TMPA->(DBCLOSEAREA())
		endif
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),"TMPA",.F.,.T.)
		
		While TMPA->(!EOF())
			AAdd(_aRet,AllTrim(TMPA->A3_COD + '-' + TMPA->A3_NOME))
			TMPA->(dbSkip())
		EndDo
		AAdd(_aRet,AllTrim("000000"+ '-' + "GERAL"))
		TMPA->(dbCloseArea())
		
		
		
		If oComboBo2 <> Nil
			oComboBo2:aItems := aClone(_aRet)
		EndIf
		
		Return(_aRet)
		EndIf
	Else
		
		If nComboBo1 == Nil
			If Len(_aGerCome)>0
				nComboBo1 := _aGerCome[1]
			Else
				Return(_aRet)
			EndIf
		EndIf
		
		_cCodSA3 := SubStr(nComboBo1,1,TamSX3("A3_COD")[01])
		
		//dbSelectArea("SA3")
		//dbSetOrder(1) //Filial + Vendedor
		//If dbSeek(xFilial("SA3")+_cCodSA3)
		//	AAdd(_aRet,AllTrim(SA3->A3_COD + '-' + SA3->A3_NOME))
		//EndIf
		
		cQry:= "SELECT * FROM SA3010 where A3_UNIDNEG = '"+_cCodSA3+"' and A3_MSBLQL = '2'  and D_E_L_E_T_ = ''"
		
		cQry := ChangeQuery(cQry)
		If SELECT("TMPA") >0
			TMPA->(DBCLOSEAREA())
		endif
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),"TMPA",.F.,.T.)
		
		While TMPA->(!EOF())
			AAdd(_aRet,AllTrim(TMPA->A3_COD + '-' + TMPA->A3_NOME))
			TMPA->(dbSkip())
		EndDo
		AAdd(_aRet,AllTrim("000000"+ '-' + "GERAL"))
		TMPA->(dbCloseArea())
		
		
		
		If oComboBo2 <> Nil
			oComboBo2:aItems := aClone(_aRet)
		EndIf
		
		Return(_aRet)
	EndIf
	
	Return(_aRet)
	
	/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Funcao	 ³ RPCPC05A ³ Autor ³ Adriano Leonardo    ³ Data ³ 27/09/2016 ³±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºDesc.     ³ Função responsável por validar a digitação da célula e     º±±
	±±º          ³ gravar os valores definidos pelo usuário.                  º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºUso       ³ Específico para a empresa Prozyn               			  º±±
	±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
	
	User Function RCRME05A()
	
	Local _nCont		:= 0
	Local _lRet			:= .T.
	Local _nLin			:= oMSNewGeF:oBrowse:nAt
	Local _nMesIniP		:= SuperGetMV("MV_INIFOR",,10) //Parâmetro para determinar o mês de início do forecast do ano posterior além dos dias úteis do parâmetro acima
	Local _nMesFimP		:= SuperGetMV("MV_FIMFOR",,12) //Parâmetro para determinar o mês de finalização do forecast do ano posterior além dos dias úteis do parâmetro acima
	Private _lDetalhe 	:= .T.

	
	dbSelectArea("SZ2")
	dbGoTo(_aRecnos[_nLin])                               
	
	
_lBlafc:= SuperGetMv('MV_BLQALFC',,.T.) // Bloqueia ou libera a alteração do forecast     
cAprFc := SuperGetMv('MV_APROVFC',,"admin")  // usuarios que estão liberados a alterar independente do parametro MV_BLQALFC   

If _lBlafc == .T. .and. !Upper(AllTrim(Subs(cUsuario,7,15))) $ upper(cAprFc)    // parametro que bloqueia preechimento                       
	MsgStop("Alteração bloqueada pelo Superior!",_cRotina+"_001")
	_lRet := .F.


	If oMSNewGeF:aCols[_nLin,1]=="Forecast Posterior" 
		
		If Month(dDataBase) >= _nMesIniP .And. Month(dDataBase) <= _nMesFimP
			   
			dbSelectArea("SZ2")
			dbGoTo(_aRecnos[_nLin])
			
		 	RecLock("SZ2",.F.)
			&(Replace(ReadVar(),"M->","SZ2->")) := &(ReadVar())
			SZ2->Z2_DATA := dDataBase
			SZ2->(MsUnlock())
			
			_nPrcVen := U_RCRME007(SZ2->Z2_CLIENTE,SZ2->Z2_LOJA,SZ2->Z2_PRODUTO,StrZero(SZ2->Z2_ANO,4),"2") //inclusão do paramentro preço bruto
			
			oMSNewGeF:aCols[_nLin,04] := (SZ2->Z2_QTM01+SZ2->Z2_QTM02+SZ2->Z2_QTM03+SZ2->Z2_QTM04+SZ2->Z2_QTM05+SZ2->Z2_QTM06+SZ2->Z2_QTM07+SZ2->Z2_QTM08+SZ2->Z2_QTM09+SZ2->Z2_QTM10+SZ2->Z2_QTM11+SZ2->Z2_QTM12)*_nPrcVen
			oMSNewGeF:aCols[_nLin,05] := SZ2->Z2_QTM01+SZ2->Z2_QTM02+SZ2->Z2_QTM03+SZ2->Z2_QTM04+SZ2->Z2_QTM05+SZ2->Z2_QTM06+SZ2->Z2_QTM07+SZ2->Z2_QTM08+SZ2->Z2_QTM09+SZ2->Z2_QTM10+SZ2->Z2_QTM11+SZ2->Z2_QTM12
			oMSNewGeF:aCols[_nLin,18] := SZ2->Z2_DATA
			oMSNewGeF:Refresh(.T.)
		Else
			
			If dDataBase > _dDataVld .Or. _nDiasEdit==0
				MsgAlert("A definição do forecast do ano posterior só é permitida entre os meses de " + _aMeses[_nMesIniP] + " à " + _aMeses[_nMesFimP] + " ou nos primeiros " + AllTrim(Str(_nDiasEdit)) + " dias úteis de cada mês!",_cRotina+"_002")
				_lRet := .F.
			Else
				dbSelectArea("SZ2")
				dbGoTo(_aRecnos[_nLin])
				
				RecLock("SZ2",.F.)
				&(Replace(ReadVar(),"M->","SZ2->")) := &(ReadVar())
				SZ2->Z2_DATA := dDataBase
				SZ2->(MsUnlock())
				
				_nPrcVen := U_RCRME007(SZ2->Z2_CLIENTE,SZ2->Z2_LOJA,SZ2->Z2_PRODUTO,StrZero(SZ2->Z2_ANO,4),"2") //inclusão do paramentro preço bruto
				
				oMSNewGeF:aCols[_nLin,04] := (SZ2->Z2_QTM01+SZ2->Z2_QTM02+SZ2->Z2_QTM03+SZ2->Z2_QTM04+SZ2->Z2_QTM05+SZ2->Z2_QTM06+SZ2->Z2_QTM07+SZ2->Z2_QTM08+SZ2->Z2_QTM09+SZ2->Z2_QTM10+SZ2->Z2_QTM11+SZ2->Z2_QTM12)*_nPrcVen
				oMSNewGeF:aCols[_nLin,05] := SZ2->Z2_QTM01+SZ2->Z2_QTM02+SZ2->Z2_QTM03+SZ2->Z2_QTM04+SZ2->Z2_QTM05+SZ2->Z2_QTM06+SZ2->Z2_QTM07+SZ2->Z2_QTM08+SZ2->Z2_QTM09+SZ2->Z2_QTM10+SZ2->Z2_QTM11+SZ2->Z2_QTM12
				oMSNewGeF:aCols[_nLin,18] := SZ2->Z2_DATA
				oMSNewGeF:Refresh(.T.)
			EndIf
		EndIf
	Else //Forecast atual
	
		If Val(Replace(ReadVar(),"M->Z2_QTM","")) < Month(dDataBase)
			MsgAlert("Não é permitida alteração do forecast de meses anteriores!",_cRotina+"_003")
			_lRet := .F.
		Else
			If dDataBase <= _dDataVld .And. _nDiasEdit>0
				dbSelectArea("SZ2")
				dbGoTo(_aRecnos[_nLin])
				
				RecLock("SZ2",.F.)
				&(Replace(ReadVar(),"M->","SZ2->")) := 	&(ReadVar())
				SZ2->Z2_DATA := dDataBase
				SZ2->(MsUnlock())
				
				_nPrcVen := U_RCRME007(SZ2->Z2_CLIENTE,SZ2->Z2_LOJA,SZ2->Z2_PRODUTO,StrZero(SZ2->Z2_ANO,4),"2") //inclusão do paramentro preço bruto
				
				oMSNewGeF:aCols[_nLin,04] := (SZ2->Z2_QTM01+SZ2->Z2_QTM02+SZ2->Z2_QTM03+SZ2->Z2_QTM04+SZ2->Z2_QTM05+SZ2->Z2_QTM06+SZ2->Z2_QTM07+SZ2->Z2_QTM08+SZ2->Z2_QTM09+SZ2->Z2_QTM10+SZ2->Z2_QTM11+SZ2->Z2_QTM12)*_nPrcVen
				oMSNewGeF:aCols[_nLin,05] := SZ2->Z2_QTM01+SZ2->Z2_QTM02+SZ2->Z2_QTM03+SZ2->Z2_QTM04+SZ2->Z2_QTM05+SZ2->Z2_QTM06+SZ2->Z2_QTM07+SZ2->Z2_QTM08+SZ2->Z2_QTM09+SZ2->Z2_QTM10+SZ2->Z2_QTM11+SZ2->Z2_QTM12
				oMSNewGeF:aCols[_nLin,18] := SZ2->Z2_DATA
				oMSNewGeF:Refresh(.T.)
			Else
				MsgAlert("A definição do forecast só é liberada nos primeiros " + AllTrim(Str(_nDiasEdit)) + " dias úteis de cada mês!",_cRotina+"_004")
				_lRet := .F.
			EndIf
		EndIf
	EndIf
Endif
	
	Return(_lRet)
	
	Static Function MenuSusp(o,x,y)
	
	Local oMenu
	Local oMenuItem := {}
	
	MENU oMenu POPUP
	
	aAdd( oMenuItem, MenuAddItem("&Versão Detalhada (F5)",,,.T.,,,,oMenu,{||Detalhe()},,,,,{||.T.}))
	
	If "Z2_QTM" $ oMSNewGeF:aHeader[oMSNewGeF:oBrowse:ColPos,2] .And. oMSNewGeF:aHeader[oMSNewGeF:oBrowse:ColPos,2] <> "Z2_QTM12"
		
		If dDataBase <= _dDataVld
			aAdd( oMenuItem, MenuAddItem("&Copiar para meses posteriores (F6)",,,.T.,,,,oMenu,{||ReplMes()},,,,,{||.T.}))
		ElseIf (Month(dDataBase) >= _nMesIniP .And. Month(dDataBase) <= _nMesFimP) .And. oMSNewGeF:aCols[oMSNewGeF:oBrowse:nAt,aScan(oMSNewGeF:aHeader,{|x|Alltrim(x[2])=="Z2_TOPICO"})] == "Forecast Posterior"
			aAdd( oMenuItem, MenuAddItem("&Copiar para meses posteriores (F6)",,,.T.,,,,oMenu,{||ReplMes()},,,,,{||.T.}))
		EndIf
	EndIf
	
	If oMSNewGeF:aCols[oMSNewGeF:oBrowse:nAt,aScan(oMSNewGeF:aHeader,{|x|Alltrim(x[2])=="Z2_TOPICO"})] == "Forecast Atual" .And. lCheckBo9
		If (Month(dDataBase) >= _nMesIniP .And. Month(dDataBase) <= _nMesFimP) .Or. (dDataBase <= _dDataVld)
			aAdd( oMenuItem, MenuAddItem("Copiar &Forecast para Ano Posterior (F7)",,,.T.,,,,oMenu,{||ReplForecast()},,,,,{||.T.}))
		EndIf
	EndIf
	
	ENDMENU
	
	oMenu:Activate(x,y)
	
	Return()
	
	Static Function ReplMes()
	
	Local _nMes
	
	SetKey(VK_F6,{|| })
	if type("oMSNewGed") <> "U"
		If oMSNewGed:oBrowse:nAt <> 1
			If ("Z2_QTM" $ oMSNewGed:aHeader[oMSNewGed:oBrowse:ColPos,2] .And. oMSNewGed:aHeader[oMSNewGed:oBrowse:ColPos,2] <> "Z2_QTM12" .And. dDataBase <= _dDataVld) .Or. (oMSNewGed:aCols[oMSNewGed:oBrowse:nAt,aScan(oMSNewGed:aHeader,{|x|Alltrim(x[2])=="Z2_TOPICO"})] == "Forecast Posterior" .And. (Month(dDataBase) >= _nMesIniP .And. Month(dDataBase) <= _nMesFimP))
				
				_cMsgAux := ""
				
				If oMSNewGed:aCols[oMSNewGed:oBrowse:nAt,aScan(oMSNewGed:aHeader,{|x|Alltrim(x[2])=="Z2_TOPICO"})] == "Forecast Posterior"
					_nMesAtu := Val(Replace(oMSNewGed:aHeader[oMSNewGed:oBrowse:ColPos,2],"Z2_QTM",""))
				Else
					_nMesAtu := Month(dDataBase)
					_cMsgAux := " (meses em aberto apenas)"
				EndIf
				
				_nValAtu := oMSNewGed:aCols[oMSNewGed:oBrowse:nAt,oMSNewGed:oBrowse:ColPos]
				
				If MsgYesNo("Deseja realmente copiar o forecast de " + _aMeses[Val(Replace(oMSNewGeD:aHeader[oMSNewGed:oBrowse:ColPos,2],"Z2_QTM",""))] + " para os meses seguintes?" + _cMsgAux)
					dbSelectArea("SZ2")
					dbGoTo(_aRecnos[oMSNewGeD:oBrowse:nAt])
					_nTot:=0
					RecLock("SZ2",.F.)
					For _nMes := _nMesAtu To 12 //Meses
						&("SZ2->Z2_QTM" + StrZero(_nMes,2)) := _nValAtu
						oMSNewGeD:aCols[oMSNewGeD:oBrowse:nAt,aScan(oMSNewGeD:aHeader,{|x|Alltrim(x[2])=="Z2_QTM"+StrZero(_nMes,2)})] := _nValAtu
						oMSNewGeF:aCols[oMSNewGeF:oBrowse:nAt,aScan(oMSNewGeF:aHeader,{|x|Alltrim(x[2])=="Z2_QTM"+StrZero(_nMes,2)})] := _nValAtu
						_nTot +=_nValAtu
					Next
					oMSNewGeD:aCols[oMSNewGeD:oBrowse:nAt,3 ] := _nTot
					
					SZ2->Z2_DATA := dDataBase
					
					_nPrcVen := U_RCRME007(SZ2->Z2_CLIENTE,SZ2->Z2_LOJA,SZ2->Z2_PRODUTO,StrZero(SZ2->Z2_ANO,4),"2") //inclusão do paramentro preço brutow
					
					oMSNewGeF:aCols[oMSNewGeF:oBrowse:nAt,04] := (SZ2->Z2_QTM01+SZ2->Z2_QTM02+SZ2->Z2_QTM03+SZ2->Z2_QTM04+SZ2->Z2_QTM05+SZ2->Z2_QTM06+SZ2->Z2_QTM07+SZ2->Z2_QTM08+SZ2->Z2_QTM09+SZ2->Z2_QTM10+SZ2->Z2_QTM11+SZ2->Z2_QTM12)*_nPrcVen
					oMSNewGeF:aCols[oMSNewGeF:oBrowse:nAt,05] := SZ2->Z2_QTM01+SZ2->Z2_QTM02+SZ2->Z2_QTM03+SZ2->Z2_QTM04+SZ2->Z2_QTM05+SZ2->Z2_QTM06+SZ2->Z2_QTM07+SZ2->Z2_QTM08+SZ2->Z2_QTM09+SZ2->Z2_QTM10+SZ2->Z2_QTM11+SZ2->Z2_QTM12
					oMSNewGeF:aCols[oMSNewGeF:oBrowse:nAt,aScan(oMSNewGeF:aHeader,{|x|Alltrim(x[2])=="Z2_DATA"})] := dDataBase
					
					SZ2->(MsUnlock())
					oMSNewGeD:Refresh(.T.)
					oMSNewGeF:Refresh(.T.)
				EndIf
			endif
		Else
			Alert("Selecione um registro para copia !")
		ENdif
	Else
		Alert("Não permitido alteração nesta tela ")
	EndIf
	
	SetKey(VK_F6,{|| 				})
	SetKey(VK_F6,{|| ReplMes()		})
	
	Return()
	
	Static Function ReplForecast()
	
	Local _nMes
	Local _aValores := {}
	
	SetKey(VK_F7,{|| })
	if type("oMSNewGed") <> "U"
		If oMSNewGed:oBrowse:nAt <> 1
			If oMSNewGeD:aCols[oMSNewGeD:oBrowse:nAt,aScan(oMSNewGeD:aHeader,{|x|Alltrim(x[2])=="Z2_TOPICO"})] == "Forecast Atual" .And. lCheckBo9 .And. ((Month(dDataBase) >= _nMesIniP .And. Month(dDataBase) <= _nMesFimP) .Or. (dDataBase <= _dDataVld))
				If MsgYesNo("Deseja realmente prencher os campos zerados do forecast do ano posterior com base no Realizado atual?")
					dbSelectArea("SZ2")
					dbGoTo(_aRecnos[3])
					_nVaria:=3
					For _nMes := 1 To 12 //Meses
						_nVaria+= 1
						AAdd(_aValores,oMSNewGeD:aCols[2,_nVaria])
					Next
					
					_cCliente	:= SZ2->Z2_CLIENTE
					_cLoja		:= SZ2->Z2_LOJA
					_cProduto	:= SZ2->Z2_PRODUTO
					_nAnoBase	:= SZ2->Z2_ANO
					_lInclui	:= .T.
					
					dbSelectArea("SZ2")
					dbSetOrder(1)
					If dbSeek(xFilial("SZ2") + _cCliente + _cLoja + PadR(_cProduto,TamSX3("Z2_PRODUTO")[01]) + AllTrim(Str((_nAnoBase + 1))) + "F")
						_lInclui := .F.
					EndIf
					
					Reclock("SZ2",_lInclui)
					If _lInclui
						SZ2->Z2_FILIAL	:= xFilial("SZ2")
						SZ2->Z2_PRODUTO	:= _cProduto
						SZ2->Z2_CLIENTE	:= _cCliente
						SZ2->Z2_LOJA	:= _cLoja
						SZ2->Z2_ANO		:= _nAnoBase + 1
						SZ2->Z2_TOPICO	:= "F" //F=Forecast | B=Budget
					EndIf
					
					_nPosAcols := aScan(_aRecnos,SZ2->(Recno()))
					
					For _nMes := 1 To 12 //Meses
						
						&("SZ2->Z2_QTM" + StrZero(_nMes,2)) := _aValores[_nMes]
						
						
						oMSNewGeF:aCols[_nPosAcols,aScan(oMSNewGeF:aHeader,{|x|Alltrim(x[2])=="Z2_QTM"+StrZero(_nMes,2)})] := _aValores[_nMes]
						
						
						
						oMSNewGeD:aCols[1,(_nMes+3)] := _aValores[_nMes]
						
						
					Next
					
					SZ2->Z2_DATA := dDataBase
					
					If _nPosAcols > 0
						oMSNewGeF:aCols[_nPosAcols,05] := SZ2->Z2_QTM01+SZ2->Z2_QTM02+SZ2->Z2_QTM03+SZ2->Z2_QTM04+SZ2->Z2_QTM05+SZ2->Z2_QTM06+SZ2->Z2_QTM07+SZ2->Z2_QTM08+SZ2->Z2_QTM09+SZ2->Z2_QTM10+SZ2->Z2_QTM11+SZ2->Z2_QTM12
						oMSNewGeF:aCols[_nPosAcols,aScan(oMSNewGeF:aHeader,{|x|Alltrim(x[2])=="Z2_DATA"})] := dDataBase
						oMSNewGeD:aCols[1,03] := SZ2->Z2_QTM01+SZ2->Z2_QTM02+SZ2->Z2_QTM03+SZ2->Z2_QTM04+SZ2->Z2_QTM05+SZ2->Z2_QTM06+SZ2->Z2_QTM07+SZ2->Z2_QTM08+SZ2->Z2_QTM09+SZ2->Z2_QTM10+SZ2->Z2_QTM11+SZ2->Z2_QTM12
						
						oMSNewGeF:Refresh(.T.)
					EndIf
					
					SZ2->(MsUnlock())
				EndIf
			EndIf
		Else
			Alert("Selecione um registro para copia !")
		ENdif
	Else
		Alert("Não permitido alteração nesta tela ")
	EndIf
	SetKey(VK_F7,{|| 				})
	SetKey(VK_F7,{|| ReplForecast()	})
	
	Return()
	
	Static Function ExpCSV()
	
	Local _nLinha	:= 0
	Local _nCol		:= 0
	Local _nCont	:= 0
	Local oExcel := FWMSEXCEL():New()
	Local _cFolder  := "C:\temp\"
	
	If MsgYesNo("Deseja exportar tela para Excel?")
		
		oExcel:AddworkSheet("Forecast")
		oExcel:AddTable ("Forecast","Forecast")
		
		For _nCont := 1 To Len(oMSNewGeF:aHeader)
			
			_nAlig := 1
			_nTipo := 1
			
			If oMSNewGeF:aHeader[1,8]== "N"
				_nTipo := 3
				_nAlig := 3
			ElseIf oMSNewGeF:aHeader[1,8]== "D"
				_nTipo := 4
			EndIf
			
			oExcel:AddColumn("Forecast","Forecast",AllTrim(oMSNewGeF:aHeader[_nCont,1]),_nTipo,_nAlig)
		Next
		
		For _nLinha := 1 To Len(oMSNewGeF:aCols)
			_aLinha := {}
			
			For _nCol := 1 To Len(oMSNewGeF:aHeader)
				AAdd(_aLinha,oMSNewGeF:aCols[_nLinha,_nCol])
			Next
			
			oExcel:AddRow("Forecast","Forecast",_aLinha)
		Next
		
		/*
		oExcel:AddColumn("Forecast","Forecast CSV","Col1",1,1)
		oExcel:AddColumn("Forecast","Forecast CSV","Col2",2,2)
		oExcel:AddColumn("Forecast","Forecast CSV","Col3",3,3)
		oExcel:AddColumn("Forecast","Forecast CSV","Col4",1,1)
		oExcel:AddRow("Forecast","Titulo de teste 1",{11,12,13,14})
		oExcel:AddRow("Forecast","Titulo de teste 1",{21,22,23,24})
		oExcel:AddRow("Forecast","Titulo de teste 1",{31,32,33,34})
		oExcel:AddRow("Forecast","Titulo de teste 1",{41,42,43,44})
		
		*/
		oExcel:Activate()
		
		_cFile := (CriaTrab(NIL, .F.) + ".xml")
		
		While File(_cFile)
			_cFile := (CriaTrab(NIL, .F.) + ".xml")
		EndDo
		
		oExcel:GetXMLFile(_cFile)
	
		If !(File(_cFile))
			_cFile := ""
			Break
		EndIf
		cNome:=	GetNextAlias()
		//_cFileTMP  := '/system/' + cNome //cGetFile('Arquivo Arquivo XML|*.xml','Salvar como',0,'C:\Dir\',.F.,GETF_LOCALHARD+GETF_NETWORKDRIVE,.F.) //Define o local onde o arquivo será gerado
		
		//Verifico se o formato do arquivo foi definido corretamente
		//	If !Empty(_cFileTMP)
		//	If !(".XML" $ Upper(_cFileTMP))
		//		_cFileTmp := StrTran(_cFileTmp,'.','')
		//	_cFileTmp += ".xml"
		//EndIf
		//Else
		//_cFileTMP := (GetTempPath() + cNome+".XML")
		//EndIf
		__CopyFile(_cFile,_cFolder+cNome+".XML")
		
		/*
		If !(__CopyFile(_cFile , _cFileTMP))
		fErase( _cFile )
		_cFile := ""
		Break
		EndIf
		
		fErase(_cFile)
		_cFile := _cFileTMP
		If !(File(_cFile))
		_cFile := ""
		Break
		EndIf
		*/
		oMsExcel:= MsExcel():New()
		oMsExcel:WorkBooks:Open(_cFolder+alltrim(lower(cNome))+".xml")
		oMsExcel:SetVisible(.T.)
		
	   //	MsgBox('Relatório gerado, por favor verifique!',_cRotina+'_05','ALERT')
	
	EndIf
	Return()
