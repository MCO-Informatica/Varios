#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"
#include "Ap5Mail.ch"
#include "Protheus.ch"
/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥ GPPRIABS ∫Autor  ≥Microsiga           ∫ Data ≥  30/11/18   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥  RelatÛrio de absenteismo ponto                            ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ sigapon                                                    ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

User Function GPPRIABS()

Local nOpca    := 0
Local aSays    := {}
Local aButtons := {}
Private cPerg    := Padr("GPPRIABS",Len(SX1->X1_GRUPO))
Private oGeraTxt
Private cCadastro := OemToAnsi("GeraÁ„o de Planilha de Absenteismo")

fPriPerg()

Pergunte(cPerg, .F.)

Aadd(aSays, OemToAnsi("Este programa tem o objetivo de gerar as Planilha de Absenteismo Ponto"))
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
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥OkGeraTxt ∫Autor  ≥Microsiga           ∫ Data ≥  04/11/19   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥                                                            ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ AP                                                        ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
Static Function OkGeraTxt

Processa({|| RunCont() },"Processando...")

Close(oGeraTxt)

Return
/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥GPPRICTB  ∫Autor  ≥Microsiga           ∫ Data ≥  04/11/19   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥                                                            ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ AP                                                        ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
Static Function RunCont

Private d_DataDe	:= mv_par01
Private d_DataAte	:= mv_par02
Private	c_FilDe		:= mv_par03								// Filial De
Private	c_FilAte	:= mv_par04								// Filial Ate
Private c_CcDe		:= mv_par05
Private c_CcAte		:= mv_par06
Private c_MatDe		:= mv_par07
Private c_MatAte	:= mv_par08
Private c_Sit  		:= fSqlIn(mv_par09,1)
Private c_Cat		:= fSqlIn(mv_par10,1)//Gera a Planilha

fGeraAbs()

Return()
/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥ fGeraAbs ∫Autor  ≥Microsiga           ∫ Data ≥  04/11/19   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥                                                            ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ AP                                                        ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
Static Function fGeraAbs

Local oExcel		:= FWMSEXCEL():New()
Local nI			:= 0
Local _aStruct		:= {}
Local _aRow			:= {}
Local _aAlias		:= {GetNextAlias(),GetNextAlias()}
Local aWSheet		:= {{"Ausencias"},{"Horas Extras"}}

aEval(aWSheet,{|x| oExcel:AddworkSheet(x[1])})
aEval(aWSheet,{|x| oExcel:AddTable(x[1],x[1])})

For nI := 1 To Len(_aAlias)
	GetTable(_aAlias[nI],nI)
	_aStruct := (_aAlias[nI])->(DbStruct())

	For xz := 1 to Len(_aStruct)
		If Alltrim(_aStruct[xz,1]) $ "RA_ADMISSA/RA_DEMISSA/PC_DATA"
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
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥ GetTable ∫Autor  ≥Microsiga           ∫ Data ≥  02/15/18   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥                                                            ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ AP                                                         ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
Static Function GetTable(_cAlias,nTipo)

Local cquery := ""
Local cTipoDB := UPPER(Alltrim(TCGetDB()))

//Ausencias
If nTipo == 1
	cQuery := ""
	cquery += " SELECT RA_FILIAL,RA_MAT,RA_NOME,RA_ADMISSA,RA_DEMISSA,RA_CATFUNC,PC_CC,CTT_DESC01,RA_CODFUNC,RJ_DESC,PC_DATA,PC_PD,P9_DESC,PC_QUANTC,ROUND(trunc( PC_QUANTC ) + ( ( (PC_QUANTC-trunc( PC_QUANTC  ) )/60) * 100 ), 2) HORASDEC,P9_CODFOL,P9_BHORAS,PC_ABONO
	cquery += " ,NVL((SELECT P6_DESC FROM "+RetSqlName("SP6")+"  F WHERE F.D_E_L_E_T_ = ' ' AND P6_CODIGO = PC_ABONO),' ') DESCABO
	cquery += " FROM "+RetSqlName("SRA")+" A, "+RetSqlName("CTT")+" B, "+RetSqlName("SRJ")+" C, "+RetSqlName("SPC")+" D, "+RetSqlName("SP9")+" E"
	cquery += " WHERE A.D_E_L_E_T_ = ' '
	cquery += " AND B.D_E_L_E_T_ = ' '
	cquery += " AND C.D_E_L_E_T_ = ' '
	cquery += " AND D.D_E_L_E_T_ = ' '
	cquery += " AND PC_CC = CTT_CUSTO AND (CTT_FILIAL = ' ' OR RA_FILIAL = CTT_FILIAL)
	cquery += " AND RA_CODFUNC = RJ_FUNCAO AND (RJ_FILIAL = ' ' OR RA_FILIAL = RJ_FILIAL)
	cquery += " AND PC_FILIAL = RA_FILIAL AND PC_MAT = RA_MAT
	cquery += " AND PC_PD = P9_CODIGO AND (P9_FILIAL = ' ' OR RA_FILIAL = P9_FILIAL)
	cquery += " AND P9_IDPON IN ('007N','008A','009N','010A','011N','012A','013N','014A','019N','020A')
	cquery += " AND PC_PDI = '   '
	cquery += " AND RA_FILIAL BETWEEN '"+c_FilDe+"' AND '"+c_FilAte+"'"
	cquery += " AND RA_MAT BETWEEN '"+c_MatDe+"' AND '"+c_MatAte+"'"
	cquery += " AND PC_CC BETWEEN '"+c_CcDe+"' AND '"+c_CcAte+"'"
	cQuery += " AND RA_SITFOLH IN (" + c_Sit + ") "
	cQuery += " AND RA_CATFUNC IN (" + c_Cat + ") "
	cQuery += " AND PC_DATA BETWEEN '"+DTOS(d_DataDe)+"' AND '"+DTOS(d_DataAte)+"'"

	cquery += " UNION ALL
	cquery += " SELECT RA_FILIAL,RA_MAT,RA_NOME,RA_ADMISSA,RA_DEMISSA,RA_CATFUNC,PC_CC,CTT_DESC01,RA_CODFUNC,RJ_DESC,PC_DATA,PC_PDI PC_PD,P9_DESC,PC_QUANTC,ROUND( trunc( PC_QUANTC ) + ( ( (PC_QUANTC-trunc( PC_QUANTC  ) )/60) * 100 ), 2) HORASDEC,P9_CODFOL,P9_BHORAS,PC_ABONO
	cquery += " ,NVL((SELECT P6_DESC FROM "+RetSqlName("SP6")+" F WHERE F.D_E_L_E_T_ = ' ' AND P6_CODIGO = PC_ABONO),' ') DESCABO
	cquery += " FROM "+RetSqlName("SRA")+" A, "+RetSqlName("CTT")+" B, "+RetSqlName("SRJ")+" C, "+RetSqlName("SPC")+" D, "+RetSqlName("SP9")+" E"
	cquery += " WHERE A.D_E_L_E_T_ = ' '
	cquery += " AND B.D_E_L_E_T_ = ' '
	cquery += " AND C.D_E_L_E_T_ = ' '
	cquery += " AND D.D_E_L_E_T_ = ' '
	cquery += " AND PC_CC = CTT_CUSTO AND (CTT_FILIAL = ' ' OR RA_FILIAL = CTT_FILIAL)
	cquery += " AND RA_CODFUNC = RJ_FUNCAO AND (RJ_FILIAL = ' ' OR RA_FILIAL = RJ_FILIAL)
	cquery += " AND PC_FILIAL = RA_FILIAL AND PC_MAT = RA_MAT
	cquery += " AND PC_PDI = P9_CODIGO AND (P9_FILIAL = ' ' OR RA_FILIAL = P9_FILIAL)
	cquery += " AND P9_IDPON IN ('007N','008A','009N','010A','011N','012A','013N','014A','019N','020A')
	cquery += " AND PC_PDI <> '   '
	cquery += " AND RA_FILIAL BETWEEN '"+c_FilDe+"' AND '"+c_FilAte+"'"
	cquery += " AND RA_MAT BETWEEN '"+c_MatDe+"' AND '"+c_MatAte+"'"
	cquery += " AND PC_CC BETWEEN '"+c_CcDe+"' AND '"+c_CcAte+"'"
	cQuery += " AND RA_SITFOLH IN (" + c_Sit + ") "
	cQuery += " AND RA_CATFUNC IN (" + c_Cat + ") "
	cQuery += " AND PC_DATA BETWEEN '"+DTOS(d_DataDe)+"' AND '"+DTOS(d_DataAte)+"'"


	cquery += " UNION ALL
	cquery += " SELECT RA_FILIAL,RA_MAT,RA_NOME,RA_ADMISSA,RA_DEMISSA,RA_CATFUNC,PH_CC PC_CC,CTT_DESC01,RA_CODFUNC,RJ_DESC,PH_DATA PC_DATA,PH_PD PC_PD,P9_DESC,PH_QUANTC PC_QUANTC,ROUND( 		trunc( PH_QUANTC ) + ( ( (PH_QUANTC-trunc( PH_QUANTC  ) )/60) * 100 ), 2) HORASDEC,P9_CODFOL,P9_BHORAS,PH_ABONO PC_ABONO
	cquery += " ,NVL((SELECT P6_DESC FROM "+RetSqlName("SP6")+" F WHERE F.D_E_L_E_T_ = ' ' AND P6_CODIGO = PH_ABONO),' ') DESCABO
	cquery += " FROM "+RetSqlName("SRA")+" A, "+RetSqlName("CTT")+" B, "+RetSqlName("SRJ")+" C, "+RetSqlName("SPH")+" D, "+RetSqlName("SP9")+" E"
	cquery += " WHERE A.D_E_L_E_T_ = ' '
	cquery += " AND B.D_E_L_E_T_ = ' '
	cquery += " AND C.D_E_L_E_T_ = ' '
	cquery += " AND D.D_E_L_E_T_ = ' '
	cquery += " AND PH_CC = CTT_CUSTO AND (CTT_FILIAL = ' ' OR RA_FILIAL = CTT_FILIAL)
	cquery += " AND RA_CODFUNC = RJ_FUNCAO AND (RJ_FILIAL = ' ' OR RA_FILIAL = RJ_FILIAL)
	cquery += " AND PH_FILIAL = RA_FILIAL AND PH_MAT = RA_MAT
	cquery += " AND PH_PD = P9_CODIGO AND (P9_FILIAL = ' ' OR RA_FILIAL = P9_FILIAL)
	cquery += " AND P9_IDPON IN ('007N','008A','009N','010A','011N','012A','013N','014A','019N','020A')
	cquery += " AND PH_PDI = '   '
	cquery += " AND RA_FILIAL BETWEEN '"+c_FilDe+"' AND '"+c_FilAte+"'"
	cquery += " AND RA_MAT BETWEEN '"+c_MatDe+"' AND '"+c_MatAte+"'"
	cquery += " AND PH_CC BETWEEN '"+c_CcDe+"' AND '"+c_CcAte+"'"
	cQuery += " AND RA_SITFOLH IN (" + c_Sit + ") "
	cQuery += " AND RA_CATFUNC IN (" + c_Cat + ") "
	cQuery += " AND PH_DATA BETWEEN '"+DTOS(d_DataDe)+"' AND '"+DTOS(d_DataAte)+"'"


	cquery += " UNION ALL
	cquery += " SELECT RA_FILIAL,RA_MAT,RA_NOME,RA_ADMISSA,RA_DEMISSA,RA_CATFUNC,PH_CC PC_CC,CTT_DESC01,RA_CODFUNC,RJ_DESC,PH_DATA PC_DATA,PH_PDI PC_PD,P9_DESC,PH_QUANTC PC_QUANTC,ROUND( trunc( PH_QUANTC ) + ( ( (PH_QUANTC-trunc( PH_QUANTC  ) )/60) * 100 ), 2) HORASDEC,P9_CODFOL,P9_BHORAS,PH_ABONO PC_ABONO
	cquery += " ,NVL((SELECT P6_DESC FROM "+RetSqlName("SP6")+" F WHERE F.D_E_L_E_T_ = ' ' AND P6_CODIGO = PH_ABONO),' ') DESCABO
	cquery += " FROM "+RetSqlName("SRA")+" A, "+RetSqlName("CTT")+" B, "+RetSqlName("SRJ")+" C, "+RetSqlName("SPH")+" D, "+RetSqlName("SP9")+" E"
	cquery += " WHERE A.D_E_L_E_T_ = ' '
	cquery += " AND B.D_E_L_E_T_ = ' '
	cquery += " AND C.D_E_L_E_T_ = ' '
	cquery += " AND D.D_E_L_E_T_ = ' '
	cquery += " AND PH_CC = CTT_CUSTO AND (CTT_FILIAL = ' ' OR RA_FILIAL = CTT_FILIAL)
	cquery += " AND RA_CODFUNC = RJ_FUNCAO AND (RJ_FILIAL = ' ' OR RA_FILIAL = RJ_FILIAL)
	cquery += " AND PH_FILIAL = RA_FILIAL AND PH_MAT = RA_MAT
	cquery += " AND PH_PDI = P9_CODIGO AND (P9_FILIAL = ' ' OR RA_FILIAL = P9_FILIAL)
	cquery += " AND P9_IDPON IN ('007N','008A','009N','010A','011N','012A','013N','014A','019N','020A')
	cquery += " AND PH_PDI <> '   '
	cquery += " AND RA_FILIAL BETWEEN '"+c_FilDe+"' AND '"+c_FilAte+"'"
	cquery += " AND RA_MAT BETWEEN '"+c_MatDe+"' AND '"+c_MatAte+"'"
	cquery += " AND PH_CC BETWEEN '"+c_CcDe+"' AND '"+c_CcAte+"'"
	cQuery += " AND RA_SITFOLH IN (" + c_Sit + ") "
	cQuery += " AND RA_CATFUNC IN (" + c_Cat + ") "
	cQuery += " AND PH_DATA BETWEEN '"+DTOS(d_DataDe)+"' AND '"+DTOS(d_DataAte)+"'"
	cquery += " ORDER BY 1,2,11,12
	//Horas Extras
ElseIf nTipo == 2
	cQuery := ""
	cquery += " SELECT RA_FILIAL,RA_MAT,RA_NOME,RA_ADMISSA,RA_DEMISSA,RA_CATFUNC,PC_CC,CTT_DESC01,RA_CODFUNC,RJ_DESC,PC_DATA,PC_PD,P9_DESC,PC_QUANTC,ROUND( trunc( PC_QUANTC ) + ( ( (PC_QUANTC-trunc( PC_QUANTC  ) )/60) * 100 ), 2) HORASDEC,P9_CODFOL,P9_BHORAS
	cquery += " FROM "+RetSqlName("SRA")+" A, "+RetSqlName("CTT")+" B, "+RetSqlName("SRJ")+" C, "+RetSqlName("SPC")+" D, "+RetSqlName("SP9")+" E"
	cquery += " WHERE A.D_E_L_E_T_ = ' '
	cquery += " AND B.D_E_L_E_T_ = ' '
	cquery += " AND C.D_E_L_E_T_ = ' '
	cquery += " AND D.D_E_L_E_T_ = ' '
	cquery += " AND PC_CC = CTT_CUSTO AND (CTT_FILIAL = ' ' OR RA_FILIAL = CTT_FILIAL)
	cquery += " AND RA_CODFUNC = RJ_FUNCAO AND (RJ_FILIAL = ' ' OR RA_FILIAL = RJ_FILIAL)
	cquery += " AND PC_FILIAL = RA_FILIAL AND PC_MAT = RA_MAT
	cquery += " AND PC_PD = P9_CODIGO AND (P9_FILIAL = ' ' OR RA_FILIAL = P9_FILIAL)
	cquery += " AND P9_CLASEV = '01'
	cquery += " AND PC_PDI = '   '
	cquery += " AND RA_FILIAL BETWEEN '"+c_FilDe+"' AND '"+c_FilAte+"'"
	cquery += " AND RA_MAT BETWEEN '"+c_MatDe+"' AND '"+c_MatAte+"'"
	cquery += " AND PC_CC BETWEEN '"+c_CcDe+"' AND '"+c_CcAte+"'"
	cQuery += " AND RA_SITFOLH IN (" + c_Sit + ") "
	cQuery += " AND RA_CATFUNC IN (" + c_Cat + ") "
	cQuery += " AND PC_DATA BETWEEN '"+DTOS(d_DataDe)+"' AND '"+DTOS(d_DataAte)+"'"

	cquery += " UNION ALL
	cquery += " SELECT RA_FILIAL,RA_MAT,RA_NOME,RA_ADMISSA,RA_DEMISSA,RA_CATFUNC,PC_CC,CTT_DESC01,RA_CODFUNC,RJ_DESC,PC_DATA,PC_PDI,P9_DESC,PC_QUANTC,ROUND( trunc( PC_QUANTC ) + ( ( (PC_QUANTC-trunc( PC_QUANTC  ) )/60) * 100 ), 2) HORASDEC,P9_CODFOL,P9_BHORAS
	cquery += " FROM "+RetSqlName("SRA")+" A, "+RetSqlName("CTT")+" B, "+RetSqlName("SRJ")+" C, "+RetSqlName("SPC")+" D, "+RetSqlName("SP9")+" E"
	cquery += " WHERE A.D_E_L_E_T_ = ' '
	cquery += " AND B.D_E_L_E_T_ = ' '
	cquery += " AND C.D_E_L_E_T_ = ' '
	cquery += " AND D.D_E_L_E_T_ = ' '
	cquery += " AND PC_CC = CTT_CUSTO AND (CTT_FILIAL = ' ' OR RA_FILIAL = CTT_FILIAL)
	cquery += " AND RA_CODFUNC = RJ_FUNCAO AND (RJ_FILIAL = ' ' OR RA_FILIAL = RJ_FILIAL)
	cquery += " AND PC_FILIAL = RA_FILIAL AND PC_MAT = RA_MAT
	cquery += " AND PC_PDI = P9_CODIGO AND (P9_FILIAL = ' ' OR RA_FILIAL = P9_FILIAL)
	cquery += " AND P9_CLASEV = '01'
	cquery += " AND PC_PDI <> '   '
	cquery += " AND RA_FILIAL BETWEEN '"+c_FilDe+"' AND '"+c_FilAte+"'"
	cquery += " AND RA_MAT BETWEEN '"+c_MatDe+"' AND '"+c_MatAte+"'"
	cquery += " AND PC_CC BETWEEN '"+c_CcDe+"' AND '"+c_CcAte+"'"
	cQuery += " AND RA_SITFOLH IN (" + c_Sit + ") "
	cQuery += " AND RA_CATFUNC IN (" + c_Cat + ") "
	cQuery += " AND PC_DATA BETWEEN '"+DTOS(d_DataDe)+"' AND '"+DTOS(d_DataAte)+"'"


	cquery += " UNION ALL
	cquery += " SELECT RA_FILIAL,RA_MAT,RA_NOME,RA_ADMISSA,RA_DEMISSA,RA_CATFUNC,RA_CC,CTT_DESC01,RA_CODFUNC,RJ_DESC,PH_DATA PC_DATA,PH_PD PC_PD,P9_DESC,PH_QUANTC PC_QUANTC,ROUND( trunc( PH_QUANTC ) + ( ( (PH_QUANTC-trunc( PH_QUANTC  ) )/60) * 100 ), 2) HORASDEC,P9_CODFOL,P9_BHORAS
	cquery += " FROM "+RetSqlName("SRA")+" A, "+RetSqlName("CTT")+" B, "+RetSqlName("SRJ")+" C, "+RetSqlName("SPH")+" D, "+RetSqlName("SP9")+" E"
	cquery += " WHERE A.D_E_L_E_T_ = ' '
	cquery += " AND B.D_E_L_E_T_ = ' '
	cquery += " AND C.D_E_L_E_T_ = ' '
	cquery += " AND D.D_E_L_E_T_ = ' '
	cquery += " AND PH_CC = CTT_CUSTO AND (CTT_FILIAL = ' ' OR RA_FILIAL = CTT_FILIAL)
	cquery += " AND RA_CODFUNC = RJ_FUNCAO AND (RJ_FILIAL = ' ' OR RA_FILIAL = RJ_FILIAL)
	cquery += " AND PH_FILIAL = RA_FILIAL AND PH_MAT = RA_MAT
	cquery += " AND PH_PD = P9_CODIGO AND (P9_FILIAL = ' ' OR RA_FILIAL = P9_FILIAL)
	cquery += " AND P9_CLASEV = '01'
	cquery += " AND PH_PDI = '   '
	cquery += " AND RA_FILIAL BETWEEN '"+c_FilDe+"' AND '"+c_FilAte+"'"
	cquery += " AND RA_MAT BETWEEN '"+c_MatDe+"' AND '"+c_MatAte+"'"
	cquery += " AND PH_CC BETWEEN '"+c_CcDe+"' AND '"+c_CcAte+"'"
	cQuery += " AND RA_SITFOLH IN (" + c_Sit + ") "
	cQuery += " AND RA_CATFUNC IN (" + c_Cat + ") "
	cQuery += " AND PH_DATA BETWEEN '"+DTOS(d_DataDe)+"' AND '"+DTOS(d_DataAte)+"'"

	cquery += " UNION ALL
	cquery += " SELECT RA_FILIAL,RA_MAT,RA_NOME,RA_ADMISSA,RA_DEMISSA,RA_CATFUNC,RA_CC,CTT_DESC01,RA_CODFUNC,RJ_DESC,PH_DATA PC_DATA,PH_PDI PH_PD,P9_DESC,PH_QUANTC PC_QUANTC,ROUND( trunc( PH_QUANTC ) + ( ( (PH_QUANTC-trunc( PH_QUANTC  ) )/60) * 100 ), 2) HORASDEC,P9_CODFOL,P9_BHORAS
	cquery += " FROM "+RetSqlName("SRA")+" A, "+RetSqlName("CTT")+" B, "+RetSqlName("SRJ")+" C, "+RetSqlName("SPH")+" D, "+RetSqlName("SP9")+" E"
	cquery += " WHERE A.D_E_L_E_T_ = ' '
	cquery += " AND B.D_E_L_E_T_ = ' '
	cquery += " AND C.D_E_L_E_T_ = ' '
	cquery += " AND D.D_E_L_E_T_ = ' '
	cquery += " AND PH_CC = CTT_CUSTO AND (CTT_FILIAL = ' ' OR RA_FILIAL = CTT_FILIAL)
	cquery += " AND RA_CODFUNC = RJ_FUNCAO AND (RJ_FILIAL = ' ' OR RA_FILIAL = RJ_FILIAL)
	cquery += " AND PH_FILIAL = RA_FILIAL AND PH_MAT = RA_MAT
	cquery += " AND PH_PDI = P9_CODIGO AND (P9_FILIAL = ' ' OR RA_FILIAL = P9_FILIAL)
	cquery += " AND P9_CLASEV = '01'
	cquery += " AND PH_PDI <> '   '
	cquery += " AND RA_FILIAL BETWEEN '"+c_FilDe+"' AND '"+c_FilAte+"'"
	cquery += " AND RA_MAT BETWEEN '"+c_MatDe+"' AND '"+c_MatAte+"'"
	cquery += " AND PH_CC BETWEEN '"+c_CcDe+"' AND '"+c_CcAte+"'"
	cQuery += " AND RA_SITFOLH IN (" + c_Sit + ") "
	cQuery += " AND RA_CATFUNC IN (" + c_Cat + ") "
	cQuery += " AND PH_DATA BETWEEN '"+DTOS(d_DataDe)+"' AND '"+DTOS(d_DataAte)+"'"

	cquery += " ORDER BY 1,2,11,12
Endif

If Select(_cAlias) > 0
	(_cAlias)->(DbCloseArea())
EndIf

dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), _cAlias, .F., .F.)
(_cAlias)->(DBGOTOP())

Return()

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥ FSQLIN   ∫Autor  ≥ Marco Antonio Silva∫ Data ≥  04/02/07   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Funcao para Montar a Selecao da Clausula IN do SQL.        ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ MP8                                                        ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
Static Function fSqlIN( cTexto, nStep )

Local cRet := ""
Local i

cTexto := Rtrim( cTexto )

If Len( cTexto ) > 0
	For i := 1 To Len( cTexto ) Step nStep
		cRet += "'" + SubStr( cTexto, i, nStep ) + "'"

		If i + nStep <= Len( cTexto )
			cRet += ","
		EndIf
	Next
EndIf

Return( cRet )

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥fPRIPERG  ∫Autor  ≥Primainfo           ∫ Data ≥  04/11/19   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Perguntas                                                  ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ SIGAGOE                                                    ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
Static Function fPriPerg()

Local aRegs := {}
cPerg := Padr(cPerg,Len(SX1->X1_GRUPO))

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
aAdd(aRegs,{ cPerg,'01','Data De                 ?','','','mv_ch1','D',08,0,0,'G','NaoVazio'  	,'mv_par01',''                 ,'','','','',''                 ,'','','','',''                    ,'','','','',''                 ,'','','','',''      ,'','','' ,'   ','' })
aAdd(aRegs,{ cPerg,'02','Data Ate                ?','','','mv_ch2','D',08,0,0,'G','NaoVazio'  	,'mv_par02',''                 ,'','','','',''                 ,'','','','',''                    ,'','','','',''                 ,'','','','',''      ,'','','' ,'   ','' })
aAdd(aRegs,{ cPerg,'03','Filial De               ?','','','mv_ch3','C',02,0,0,'G','        '  	,'mv_par03',''                 ,'','','','',''                 ,'','','','',''                    ,'','','','',''                 ,'','','','',''      ,'','','' ,'XM0','' })
aAdd(aRegs,{ cPerg,'04','Filial Ate              ?','','','mv_ch4','C',02,0,0,'G','NaoVazio'  	,'mv_par04',''                 ,'','','','',''                 ,'','','','',''                    ,'','','','',''                 ,'','','','',''      ,'','','' ,'XM0','' })
aAdd(aRegs,{ cPerg,'05','Centro Custo De         ?','','','mv_ch5','C',09,0,0,'G','           ','mv_par05','               ','','','','','           ','','','','','         ','','','','','            ','','','','','           ','','','','CTT   ','' })
aAdd(aRegs,{ cPerg,'06','Centro Custo Ate        ?','','','mv_ch6','C',09,0,0,'G','NaoVazio   ','mv_par06','               ','','','','','           ','','','','','         ','','','','','            ','','','','','           ','','','','CTT   ','' })
aAdd(aRegs,{ cPerg,'07','Matricula De            ?','','','mv_ch7','C',06,0,0,'G','           ','mv_par07','               ','','','','','           ','','','','','         ','','','','','            ','','','','','           ','','','','SRA   ','' })
aAdd(aRegs,{ cPerg,'08','Matricula Ate           ?','','','mv_ch8','C',06,0,0,'G','NaoVazio   ','mv_par08','               ','','','','','           ','','','','','         ','','','','','            ','','','','','           ','','','','SRA   ','' })
aAdd(aRegs,{ cPerg,'09','Situacoes               ?','','','mv_ch9','C',05,0,0,'G','fSituacao  ','mv_par09','               ','','','','','           ','','','','','         ','','','','','            ','','','','','           ','','','','      ','' })
aAdd(aRegs,{ cPerg,'10','Categorias              ?','','','mv_cha','C',15,0,0,'G','fCategoria ','mv_par10','               ','','','','','           ','','','','','         ','','','','','            ','','','','','           ','','','','      ','' })

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