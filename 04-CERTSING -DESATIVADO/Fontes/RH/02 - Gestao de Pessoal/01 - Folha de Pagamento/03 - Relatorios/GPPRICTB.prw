#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"
#include "Ap5Mail.ch"
#include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ GPPRICTB ºAutor  ³Microsiga           º Data ³  04/11/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatório de contabilização da folha                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ sigagpe                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function GPPRICTB()

Local nOpca    := 0
Local aSays    := {}
Local aButtons := {}
Private cPerg    := Padr("GPPRICTB",Len(SX1->X1_GRUPO))
Private cString  := "SRA"
Private oGeraTxt
Private cCadastro := OemToAnsi("Geração de Planilha de Contabilizacao")
Private CTIPOCONT := 0
Private CTBLXPROV := "TPR"
Private LCONTABCC := .F.
Private CRETSQLNAME := ""

fPriPerg()

dbSelectArea("SRV")
dbSetOrder(1)
dbSelectArea("SRZ")
dbSetOrder(1)

Pergunte(cPerg, .F.)

Aadd(aSays, OemToAnsi("Este programa tem o objetivo de gerar a Planilha de Contabilizacao da Folha"))
Aadd(aSays, OemToAnsi("Sera gerado de acordo com os parametros definidos pelo usuario."))

Aadd(aButtons, {5, .T., {|| Pergunte(cPerg, .T.)}})
Aadd(aButtons, {1, .T., {|o| nOpca := 1, IIf(GpConfOk(), FechaBatch(), nOpca := 0)}})
Aadd(aButtons, {2, .T., {|o| FechaBatch()}})

FormBatch(cCadastro, aSays, aButtons)

If nOpca == 1
	Processa({|lEnd| RunCont(), cCadastro})
Endif

Return (.T.)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³OkGeraTxt ºAutor  ³Microsiga           º Data ³  04/11/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function OkGeraTxt

Processa({|| RunCont() },"Processando...")

Close(oGeraTxt)

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GPPRICTB  ºAutor  ³Microsiga           º Data ³  04/11/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RunCont

Private	cMesAnoCtab := StrZero(Month(mv_par01),2)+strZero(Year(mv_par01),4)	// MM/AAAA da Contabilizacao
Private	cFilConDe	:= mv_par02								// Filial De
Private	cFilConAte	:= mv_par03								// Filial Ate
Private	lFolPgto    := .T.									// Contabilizar Folha
Private	lFol13Sl    := .T.							 		// Contabilizar 13 Salario
Private	lProvFer    := .T. 									// Provisao de Ferias
Private	lProv13o    := .T.									// Provisao de 13o. Salario
Private	lCtabBxaFer := .T.				                    // Cont.Bx.Ferias.Prov:1-Sim;2-Nao
Private	lCtabBxaRes := .T.				                    // Cont.Bx.Res.Prov:1-Sim;2-Nao
Private lGerouFol	:= .F.
Private lGerou13s   := .F.
Private lTemItemRZ  := .F.
Private lItemClVl   := .F.
Private a_CodFol	:= {}
Private a_CodProv	:= {}
Private a_PerAberto	:= {}
Private a_PerFechado:= {strZero(Year(mv_par01),4)+StrZero(Month(mv_par01),2),"01"}
Private lErpLogix	:= .F.

TcSqlExec( "TRUNCATE TABLE "+RetSqlName("SRZ") )

IF ( ( lProvFer ) .or. ( lProv13o ) )	// "Geracao de Lancamentos - Provisao"
	GpeProvisao("Processando provisao",cMesAnoCtab,,,6)
Endif

//Gera a Planilha
GPM002()

Return()
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³  GPM002  ºAutor  ³Microsiga           º Data ³  04/11/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GPM002

Local oExcel		:= FWMSEXCEL():New()
Local nI			:= 0
Local _aStruct		:= {}
Local _aRow			:= {}
Local _aAlias		:= {GetNextAlias(),GetNextAlias(),GetNextAlias()}
Local aWSheet		:= {{"Contabilizacao Folha"},{"Provisao Ferias"},{"Provisao 13 Salario"}}
Local xz

aEval(aWSheet,{|x| oExcel:AddworkSheet(x[1])})
aEval(aWSheet,{|x| oExcel:AddTable(x[1],x[1])})

For nI := 1 To Len(_aAlias)
	GetTable(_aAlias[nI],nI)
	_aStruct := (_aAlias[nI])->(DbStruct())

	For xz := 1 to Len(_aStruct)
		If Alltrim(_aStruct[xz,1]) $ "RA_ADMISSA/RA_DEMISSA"
			TCSetField(_aAlias[nI],_aStruct[xz,1], "D", 08, 0 )
		Endif
	Next xz

	aEval(_aStruct,{|x| oExcel:AddColumn(aWSheet[nI][1],aWSheet[nI][1],If(Empty(cTitulo:=Posicione("SX3",2,x[1],"X3_TITULO")),x[1],cTitulo),2,1)})
	(_aAlias[nI])->(DbGoTop())
	While (_aAlias[nI])->(!Eof())
		_aRow := Array(Len(_aStruct))
		nX := 0
		aEval(_aStruct,{|x| nX++,_aRow[nX] := (_aAlias[nI])->&(x[1])})
		oExcel:AddRow(aWSheet[nI][1],aWSheet[nI][1],_aRow)
		(_aAlias[nI])->(DbSkip())
	EndDo
Next

oExcel:Activate()

cFolder := cGetFile("XML | *.XML", OemToAnsi("Informe o diretorio.",1,7),,,,nOR(GETF_LOCALHARD,GETF_NETWORKDRIVE))
cFile := cFolder+".XML"

oExcel:GetXMLFile(cFile)

MsgInfo("Arquivo gerado com sucesso, sera aberto apos o fechamento dessa mensagem." + CRLF + cFile)

If ApOleClient("MsExcel")
	oExcelApp:=MsExcel():New()
	oExcelApp:WorkBooks:Open(cFile)
	oExcelApp:SetVisible(.T.)
Else
	MsgInfo("Excel nao instaldo!"+chr(13)+chr(10)+"Relatorio gerado com sucesso, arquivo gerado no diretorio abaixo: "+chr(13)+cFile)
EndIf

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ GetTable ºAutor  ³Microsiga           º Data ³  02/15/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GetTable(_cAlias,nTipo)

Local cQuery := ""
Local cTipoDB := UPPER(Alltrim(TCGetDB()))

//Roteiros
If nTipo == 1
	cQuery := ""
	cquery += " SELECT T.* FROM(
	cquery += " SELECT RD_ROTEIR,RA_FILIAL,RA_MAT,RA_NOME,RA_CATFUNC,RA_CATEFD,RA_SITFOLH,RD_PERIODO,RD_PD,RV_DESC,RV_TIPOCOD,RD_HORAS,RD_VALOR,RD_CC,RD_ITEM,RD_CLVL,RV_LCTOP,RV_DEBITO,RV_CREDITO"
	cquery += " FROM "+RetSqlName("SRA")+" A, "+RetSqlName("SRD")+" B, "+RetSqlName("SRV")+" C, "+RetSqlName("SRY")+" D"
	cquery += " WHERE A.D_E_L_E_T_ = ' '"
	cquery += " AND B.D_E_L_E_T_ = ' '"
	cquery += " AND RA_FILIAL = RD_FILIAL AND RA_MAT = RD_MAT"
	cquery += " AND RD_PERIODO = '"+AnoMes(MV_PAR01)+"'"
	cquery += " AND C.D_E_L_E_T_ = ' ' AND RD_PD = RV_COD"
	cquery += " AND D.D_E_L_E_T_ = ' '"
	cquery += " AND RY_CALCULO = RD_ROTEIR"
	cquery += " AND RY_CONTAB = '1'"
	cquery += " )T"
	cquery += " UNION ALL
	cquery += " SELECT T.* FROM(
	cquery += " SELECT RC_ROTEIR,RA_FILIAL,RA_MAT,RA_NOME,RA_CATFUNC,RA_CATEFD,RA_SITFOLH,RC_PERIODO,RC_PD,RV_DESC,RV_TIPOCOD,RC_HORAS,RC_VALOR,RC_CC,RC_ITEM,RC_CLVL,RV_LCTOP,RV_DEBITO,RV_CREDITO"
	cquery += " FROM "+RetSqlName("SRA")+" A, "+RetSqlName("SRC")+" B, "+RetSqlName("SRV")+" C, "+RetSqlName("SRY")+" D"
	cquery += " WHERE A.D_E_L_E_T_ = ' '"
	cquery += " AND B.D_E_L_E_T_ = ' '"
	cquery += " AND RA_FILIAL = RC_FILIAL AND RA_MAT = RC_MAT"
	cquery += " AND RC_PERIODO = '"+AnoMes(MV_PAR01)+"'"
	cquery += " AND C.D_E_L_E_T_ = ' ' AND RC_PD = RV_COD"
	cquery += " AND D.D_E_L_E_T_ = ' '"
	cquery += " AND RY_CALCULO = RC_ROTEIR"
	cquery += " AND RY_CONTAB = '1'"
	cquery += " )T"
	cquery += " ORDER BY 1,2,3,14,11,9"
	//Provisao de Ferias
ElseIf nTipo == 2
	cQuery := ""
	cquery += " SELECT RA_FILIAL,RA_MAT,RA_NOME,'"+AnoMes(MV_PAR01)+"' PERIODO,RZ_PD,RV_DESC,RV_TIPOCOD,RZ_HRS,RZ_VAL,RZ_CC,RZ_ITEM,RZ_CLVL,RV_LCTOP,RV_DEBITO,RV_CREDITO"
	cquery += " FROM "+RetSqlName("SRA")+" A, "+RetSqlName("SRZ")+" B, "+RetSqlName("SRV")+" C
	cquery += " WHERE A.D_E_L_E_T_ = ' '
	cquery += " AND B.D_E_L_E_T_ = ' '
	cquery += " AND RA_FILIAL = RZ_FILIAL AND RA_MAT = RZ_MAT
	cquery += " AND C.D_E_L_E_T_ = ' ' AND RZ_PD = RV_COD
	cquery += " AND RZ_TIPO = 'PF'
	cquery += " ORDER BY RA_FILIAL,RA_MAT,RZ_CC,RV_TIPOCOD,RZ_PD
	//Provisao 13 Salario
ElseIf nTipo == 3
	cQuery := ""
	cquery += " SELECT RA_FILIAL,RA_MAT,RA_NOME,'"+AnoMes(MV_PAR01)+"' PERIODO,RZ_PD,RV_DESC,RV_TIPOCOD,RZ_HRS,RZ_VAL,RZ_CC,RZ_ITEM,RZ_CLVL,RV_LCTOP,RV_DEBITO,RV_CREDITO"
	cquery += " FROM "+RetSqlName("SRA")+" A, "+RetSqlName("SRZ")+" B, "+RetSqlName("SRV")+" C
	cquery += " WHERE A.D_E_L_E_T_ = ' '
	cquery += " AND B.D_E_L_E_T_ = ' '
	cquery += " AND RA_FILIAL = RZ_FILIAL AND RA_MAT = RZ_MAT
	cquery += " AND C.D_E_L_E_T_ = ' ' AND RZ_PD = RV_COD
	cquery += " AND RZ_TIPO = 'PD'
	cquery += " ORDER BY RA_FILIAL,RA_MAT,RZ_CC,RV_TIPOCOD,RZ_PD
Endif

If Select(_cAlias) > 0
	(_cAlias)->(DbCloseArea())
EndIf

dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), _cAlias, .F., .F.)
(_cAlias)->(DBGOTOP())

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fPRIPERG  ºAutor  ³Primainfo           º Data ³  04/11/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Perguntas                                                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGAGOE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fPriPerg()

Local aRegs := {}
Local j, i
cPerg := Padr(cPerg,Len(SX1->X1_GRUPO))

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
aAdd(aRegs,{ cPerg,'01','Data Referencia              ?','','','mv_ch1','D',08,0,0,'G','NaoVazio'   		,'mv_par01',''                 ,'','','','',''                 ,'','','','',''                    ,'','','','',''                 ,'','','','',''      ,'','','' ,'   ','' })
aAdd(aRegs,{ cPerg,'02','Filial De                    ?','','','mv_ch2','C',02,0,0,'G','        '   		,'mv_par02',''                 ,'','','','',''                 ,'','','','',''                    ,'','','','',''                 ,'','','','',''      ,'','','' ,'XM0','' })
aAdd(aRegs,{ cPerg,'03','Filial Ate                   ?','','','mv_ch3','C',02,0,0,'G','NaoVazio'   		,'mv_par03',''                 ,'','','','',''                 ,'','','','',''                    ,'','','','',''                 ,'','','','',''      ,'','','' ,'XM0','' })

dbSelectArea("SX1")
For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next

Return