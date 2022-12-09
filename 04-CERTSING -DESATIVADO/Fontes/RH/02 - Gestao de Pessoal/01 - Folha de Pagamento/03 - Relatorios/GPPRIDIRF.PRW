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
±±∫Programa  ≥GPPRIDIRF ∫Autor  ≥Microsiga           ∫ Data ≥  17/04/18   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥  RelatÛrio de conferencia DIRF                             ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ sigagpe                                                    ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

User Function GPPRIDIRF()

Local nOpca    := 0
Local aSays    := {}
Local aButtons := {}
Private cPerg    := Padr("GPPRIDIRF",Len(SX1->X1_GRUPO))
Private oGeraTxt
Private cCadastro := OemToAnsi("GeraÁ„o de Conferencia DIRF")

fPriPerg()

Pergunte(cPerg, .F.)

Aadd(aSays, OemToAnsi("Este programa tem o objetivo de gerar as Planilhas de Conferencia DIRF"))
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

Private c_Ano		:= StrZero(mv_par01,4)
Private	c_FilDe		:= mv_par02								// Filial De
Private	c_FilAte	:= mv_par03								// Filial Ate
Private c_MatDe		:= mv_par04
Private c_MatAte	:= mv_par05
Private c_Sit  		:= fSqlIn(mv_par06,1)
Private c_Cat		:= fSqlIn(mv_par07,1)//Gera a Planilha

fGeraDirf()

Return()
/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥ fGeraDirf∫Autor  ≥Microsiga           ∫ Data ≥  04/11/19   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥                                                            ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ AP                                                        ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
Static Function fGeraDirf

Local oExcel		:= FWMSEXCEL():New()
Local nI			:= 0
Local _aStruct		:= {}
Local _aRow			:= {}
Local _aAlias		:= {GetNextAlias(),GetNextAlias(),GetNextAlias()}
Local aWSheet		:= {{"Analitico"},{"Confere Informe"},{"Assist.Medica/Odonto"}}
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

Local cquery 	:= ""
Local cTipoDB 	:= UPPER(Alltrim(TCGetDB()))
Local c_FilSX5  := IIf(Empty(xFilial("SX5")),"'"+xFilial("SX5")+"'","RA_FILIAL")
Local a_Meses	:= {}
Local xm		:= 0
Local xz		:= 0

For xm := 1 to 12
	If xm = 1
		AAdd(a_Meses,{c_Ano+StrZero(xm,2),StrZero(Val(c_Ano) - 1,4)+"12" })
	Else
		AAdd(a_Meses,{c_Ano+StrZero(xm,2),c_Ano + StrZero(xm-1,2) })
	Endif
Next xm

If cTipoDB = "ORACLE"
	//Analitico
	If nTipo == 1
		cQuery := ""
		cquery += " SELECT RA_FILIAL,RA_MAT,RA_NOME,RA_CIC,RA_CATFUNC,RD_PD,RV_DESC,RV_CODFOL,RV_TIPOCOD,RV_IR,RV_INSS,RV_FGTS,RV_RAIS,RV_DIRF||'-'||RTRIM(X5_DESCRI) TIPODIRF,CASE WHEN RV_DIRF IN ('A ','0 ','E ','I ','J ') AND RV_TIPOCOD = '2' THEN RD_VALOR*-1 ELSE RD_VALOR END RD_VALOR,RD_ROTEIR,RD_PERIODO,RD_DATPGT,SUBSTR(RD_DATPGT,1,6) MESANOPG
		cquery += " FROM "+RetSqlName("SRA")+" A, "+RetSqlName("SRD")+" B, "+RetSqlName("SRV")+" C, "+RetSqlName("SX5")+" D"
		cquery += " WHERE A.D_E_L_E_T_ =  ' ' AND B.D_E_L_E_T_ = ' '  AND C.D_E_L_E_T_ = ' ' AND D.D_E_L_E_T_ = ' '
		cquery += " AND RA_FILIAL = RD_FILIAL AND RA_MAT = RD_MAT
		cquery += " AND RD_PD = RV_COD
		cquery += " AND X5_TABELA = '36' AND X5_CHAVE = RV_DIRF AND X5_FILIAL = "+c_FilSX5
		cquery += " AND SUBSTR(RD_DATPGT,1,4) = '"+c_Ano+"'
		cquery += " AND (RV_TIPOCOD IN ('1','2') OR RV_DIRF NOT IN ('N ','  '))
		cquery += " AND C.RV_CODFOL NOT IN ('0006','0007')
		cquery += " AND RA_FILIAL BETWEEN '"+c_FilDe+"' AND '"+c_FilAte+"'"
		cquery += " AND RA_MAT BETWEEN '"+c_MatDe+"' AND '"+c_MatAte+"'"
		cQuery += " AND RA_SITFOLH IN (" + c_Sit + ") "
		cQuery += " AND RA_CATFUNC IN (" + c_Cat + ") "
		cQuery += " UNION ALL
		cQuery += " SELECT RA_FILIAL,RA_MAT,RA_NOME,RA_CIC,RA_CATFUNC,RD_PD,RV_DESC,RV_CODFOL,RV_TIPOCOD,RV_IR,RV_INSS,RV_FGTS,RV_RAIS,RV_DIRF||'-'||RTRIM(X5_DESCRI) TIPODIRF, RD_VALOR,RD_ROTEIR,RD_PERIODO,RD_DATPGT,SUBSTR(RD_DATPGT,1,6) MESANOPG
		cquery += " FROM "+RetSqlName("SRA")+" A, "+RetSqlName("SRD")+" B, "+RetSqlName("SRV")+" C, "+RetSqlName("SX5")+" D"
		cquery += " WHERE A.D_E_L_E_T_ =  ' ' AND B.D_E_L_E_T_ = ' '  AND C.D_E_L_E_T_ = ' ' AND D.D_E_L_E_T_ = ' '
		cquery += " AND RA_FILIAL = RD_FILIAL AND RA_MAT = RD_MAT
		cquery += " AND X5_TABELA = '36' AND X5_CHAVE = 'A' AND X5_FILIAL = "+c_FilSX5
		cquery += " AND RD_PD = RV_COD
		cquery += " AND SUBSTR(RD_DATPGT,1,4) =  '"+c_Ano+"'
		cquery += " AND C.RV_CODFOL = '0006'
		cquery += " AND RA_FILIAL BETWEEN '"+c_FilDe+"' AND '"+c_FilAte+"'"
		cquery += " AND RA_MAT BETWEEN '"+c_MatDe+"' AND '"+c_MatAte+"'"
		cQuery += " AND RA_SITFOLH IN (" + c_Sit + ") "
		cQuery += " AND RA_CATFUNC IN (" + c_Cat + ") "
		
		For xz := 1 to Len(a_Meses)
			cQuery += " UNION ALL
			cQuery += " SELECT RA_FILIAL,RA_MAT,RA_NOME,RA_CIC,RA_CATFUNC,RD_PD,RV_DESC,RV_CODFOL,RV_TIPOCOD,RV_IR,RV_INSS,RV_FGTS,RV_RAIS,'A -'||RTRIM(X5_DESCRI) TIPODIRF, RD_VALOR * -1 RD_VALOR,RD_ROTEIR,RD_PERIODO,RD_DATPGT,SUBSTR(RD_DATPGT,1,6) MESANOPG
			cQuery += " FROM "+RetSqlName("SRA")+" A, "+RetSqlName("SRD")+" B, "+RetSqlName("SRV")+" C, "+RetSqlName("SX5")+" D"
			cQuery += " WHERE A.D_E_L_E_T_ =  ' ' AND B.D_E_L_E_T_ = ' '  AND C.D_E_L_E_T_ = ' ' AND D.D_E_L_E_T_ = ' '
			cQuery += " AND RA_FILIAL = RD_FILIAL AND RA_MAT = RD_MAT
			cQuery += " AND X5_TABELA = '36' AND X5_CHAVE = 'A' AND X5_FILIAL = "+c_FilSX5
			cQuery += " AND RD_PD = RV_COD
			cQuery += " AND SUBSTR(RD_DATPGT,1,6) = '"+a_Meses[xz,1]+"'"
			cQuery += " AND C.RV_CODFOL = '0007'
			cquery += " AND RA_FILIAL BETWEEN '"+c_FilDe+"' AND '"+c_FilAte+"'"
			cquery += " AND RA_MAT BETWEEN '"+c_MatDe+"' AND '"+c_MatAte+"'"
			cQuery += " AND RA_SITFOLH IN (" + c_Sit + ") "
			cQuery += " AND RA_CATFUNC IN (" + c_Cat + ") "
		Next xz
		cquery += " ORDER BY RA_FILIAL,RA_MAT,RD_PERIODO,MESANOPG,RD_ROTEIR,RD_PD
		MemoWrite ( "C:\TEMP\GPDIRF.TXT" , cquery )
		//Confere Informe
	ElseIf nTipo == 2
		cQuery := ""
		cquery += " SELECT Y.*,REND13-PREV13-PEN13-DEP13-IRRF13 LIQ13
		cquery += " ,NVL((SELECT SUM(CASE WHEN RV_TIPOCOD = '2' THEN RD_VALOR * -1 ELSE RD_VALOR END) FROM "+RetSqlName("SRV")+" C, "+RetSqlName("SRD")+" D WHERE C.D_E_L_E_T_ = ' ' AND D.D_E_L_E_T_ = ' ' AND RD_FILIAL = FILIAL AND RD_MAT = MATRICULA AND SUBSTR(RD_DATPGT,1,4) = '"+c_Ano+"' AND RD_PD = RV_COD AND RV_DIRF = 'O1' ),0) RENDPLR
		cquery += " ,NVL((SELECT SUM(CASE WHEN RV_TIPOCOD = '1' THEN RD_VALOR * -1 ELSE RD_VALOR END) FROM "+RetSqlName("SRV")+" C, "+RetSqlName("SRD")+" D WHERE C.D_E_L_E_T_ = ' ' AND D.D_E_L_E_T_ = ' ' AND RD_FILIAL = FILIAL AND RD_MAT = MATRICULA AND SUBSTR(RD_DATPGT,1,4) = '"+c_Ano+"' AND RD_PD = RV_COD AND RV_DIRF = 'Q1' ),0) IRRFPLR
		cquery += " ,NVL((SELECT SUM(CASE WHEN RV_TIPOCOD = '1' THEN RD_VALOR * -1 ELSE RD_VALOR END) FROM "+RetSqlName("SRV")+" C, "+RetSqlName("SRD")+" D WHERE C.D_E_L_E_T_ = ' ' AND D.D_E_L_E_T_ = ' ' AND RD_FILIAL = FILIAL AND RD_MAT = MATRICULA AND SUBSTR(RD_DATPGT,1,4) = '"+c_Ano+"' AND RD_PD = RV_COD AND RV_DIRF = 'R' ),0) ASSMED
		cquery += " FROM(
		cquery += " SELECT T.*
		cquery += " ,NVL((SELECT SUM(CASE WHEN RV_TIPOCOD = '2' THEN RD_VALOR * -1 ELSE RD_VALOR END) FROM "+RetSqlName("SRV")+" C, "+RetSqlName("SRD")+" D WHERE C.D_E_L_E_T_ = ' ' AND D.D_E_L_E_T_ = ' ' AND RD_FILIAL = FILIAL AND RD_MAT = MATRICULA AND SUBSTR(RD_DATPGT,1,4) = '"+c_Ano+"' AND RD_PD = RV_COD AND RV_CODFOL NOT IN  ('0006','0007') AND RV_DIRF = 'A '  ),0)
		cquery += " +NVL((SELECT SUM(RD_VALOR) FROM "+RetSqlName("SRV")+" C, "+RetSqlName("SRD")+" D WHERE C.D_E_L_E_T_ = ' ' AND D.D_E_L_E_T_ = ' ' AND RD_FILIAL = FILIAL AND RD_MAT = MATRICULA AND SUBSTR(RD_DATPGT,1,4) = '"+c_Ano+"' AND RD_PD = RV_COD AND RV_CODFOL = '0006'  ),0) 
		cquery += " -NVL((SELECT SUM(RD_VALOR) FROM "+RetSqlName("SRV")+" C, "+RetSqlName("SRD")+" D WHERE C.D_E_L_E_T_ = ' ' AND D.D_E_L_E_T_ = ' ' AND RD_FILIAL = FILIAL AND RD_MAT = MATRICULA AND SUBSTR(RD_DATPGT,1,4) = '"+c_Ano+"' AND RD_PD = RV_COD AND RV_CODFOL = '0007' AND SUBSTR(RD_DATPGT,1,4) = '"+c_Ano+"'  ),0) REND
		cquery += " ,NVL((SELECT SUM(CASE WHEN RV_TIPOCOD = '1' THEN RD_VALOR * -1 ELSE RD_VALOR END) FROM "+RetSqlName("SRV")+" C, "+RetSqlName("SRD")+" D WHERE C.D_E_L_E_T_ = ' ' AND D.D_E_L_E_T_ = ' ' AND RD_FILIAL = FILIAL AND RD_MAT = MATRICULA AND SUBSTR(RD_DATPGT,1,4) = '"+c_Ano+"' AND RD_PD = RV_COD AND RV_DIRF = 'B' ),0) PREV
		cquery += " ,NVL((SELECT SUM(CASE WHEN RV_TIPOCOD = '1' THEN RD_VALOR * -1 ELSE RD_VALOR END) FROM "+RetSqlName("SRV")+" C, "+RetSqlName("SRD")+" D WHERE C.D_E_L_E_T_ = ' ' AND D.D_E_L_E_T_ = ' ' AND RD_FILIAL = FILIAL AND RD_MAT = MATRICULA AND SUBSTR(RD_DATPGT,1,4) = '"+c_Ano+"' AND RD_PD = RV_COD AND RV_DIRF = 'D' ),0) IRRF
		cquery += " ,NVL((SELECT SUM(CASE WHEN RV_TIPOCOD = '2' THEN RD_VALOR * -1 ELSE RD_VALOR END) FROM "+RetSqlName("SRV")+" C, "+RetSqlName("SRD")+" D WHERE C.D_E_L_E_T_ = ' ' AND D.D_E_L_E_T_ = ' ' AND RD_FILIAL = FILIAL AND RD_MAT = MATRICULA AND SUBSTR(RD_DATPGT,1,4) = '"+c_Ano+"' AND RD_PD = RV_COD AND RV_DIRF = 'E' ),0) INDENIZA
		cquery += " ,NVL((SELECT SUM(CASE WHEN RV_TIPOCOD = '2' THEN RD_VALOR * -1 ELSE RD_VALOR END) FROM "+RetSqlName("SRV")+" C, "+RetSqlName("SRD")+" D WHERE C.D_E_L_E_T_ = ' ' AND D.D_E_L_E_T_ = ' ' AND RD_FILIAL = FILIAL AND RD_MAT = MATRICULA AND SUBSTR(RD_DATPGT,1,4) = '"+c_Ano+"' AND RD_PD = RV_COD AND RV_DIRF = 'I' ),0) ISENTOS
		cquery += " ,NVL((SELECT SUM(CASE WHEN RV_TIPOCOD = '2' THEN RD_VALOR * -1 ELSE RD_VALOR END) FROM "+RetSqlName("SRV")+" C, "+RetSqlName("SRD")+" D WHERE C.D_E_L_E_T_ = ' ' AND D.D_E_L_E_T_ = ' ' AND RD_FILIAL = FILIAL AND RD_MAT = MATRICULA AND SUBSTR(RD_DATPGT,1,4) = '"+c_Ano+"' AND RD_PD = RV_COD AND RV_DIRF = '0' ),0) ABONOS
		cquery += " ,NVL((SELECT SUM(CASE WHEN RV_TIPOCOD = '1' THEN RD_VALOR * -1 ELSE RD_VALOR END) FROM "+RetSqlName("SRV")+" C, "+RetSqlName("SRD")+" D WHERE C.D_E_L_E_T_ = ' ' AND D.D_E_L_E_T_ = ' ' AND RD_FILIAL = FILIAL AND RD_MAT = MATRICULA AND SUBSTR(RD_DATPGT,1,4) = '"+c_Ano+"' AND RD_PD = RV_COD AND RV_DIRF = 'C' ),0) PENSAO
		cquery += " ,NVL((SELECT SUM(CASE WHEN RV_TIPOCOD = '2' THEN RD_VALOR * -1 ELSE RD_VALOR END) FROM "+RetSqlName("SRV")+" C, "+RetSqlName("SRD")+" D WHERE C.D_E_L_E_T_ = ' ' AND D.D_E_L_E_T_ = ' ' AND RD_FILIAL = FILIAL AND RD_MAT = MATRICULA AND SUBSTR(RD_DATPGT,1,4) = '"+c_Ano+"' AND RD_PD = RV_COD AND RV_DIRF = 'J' ),0) REND13
		cquery += " ,NVL((SELECT SUM(CASE WHEN RV_TIPOCOD = '1' THEN RD_VALOR * -1 ELSE RD_VALOR END) FROM "+RetSqlName("SRV")+" C, "+RetSqlName("SRD")+" D WHERE C.D_E_L_E_T_ = ' ' AND D.D_E_L_E_T_ = ' ' AND RD_FILIAL = FILIAL AND RD_MAT = MATRICULA AND SUBSTR(RD_DATPGT,1,4) = '"+c_Ano+"' AND RD_PD = RV_COD AND RV_DIRF = 'B1' ),0) PREV13
		cquery += " ,NVL((SELECT SUM(CASE WHEN RV_TIPOCOD = '1' THEN RD_VALOR * -1 ELSE RD_VALOR END) FROM "+RetSqlName("SRV")+" C, "+RetSqlName("SRD")+" D WHERE C.D_E_L_E_T_ = ' ' AND D.D_E_L_E_T_ = ' ' AND RD_FILIAL = FILIAL AND RD_MAT = MATRICULA AND SUBSTR(RD_DATPGT,1,4) = '"+c_Ano+"' AND RD_PD = RV_COD AND RV_DIRF = 'L'  ),0) IRRF13
		cquery += " ,NVL((SELECT SUM(CASE WHEN RV_TIPOCOD = '1' THEN RD_VALOR * -1 ELSE RD_VALOR END) FROM "+RetSqlName("SRV")+" C, "+RetSqlName("SRD")+" D WHERE C.D_E_L_E_T_ = ' ' AND D.D_E_L_E_T_ = ' ' AND RD_FILIAL = FILIAL AND RD_MAT = MATRICULA AND SUBSTR(RD_DATPGT,1,4) = '"+c_Ano+"' AND RD_PD = RV_COD AND RV_DIRF = 'C1' ),0) PEN13
		cquery += " ,NVL((SELECT SUM(CASE WHEN RV_TIPOCOD = '2' THEN RD_VALOR * -1 ELSE RD_VALOR END) FROM "+RetSqlName("SRV")+" C, "+RetSqlName("SRD")+" D WHERE C.D_E_L_E_T_ = ' ' AND D.D_E_L_E_T_ = ' ' AND RD_FILIAL = FILIAL AND RD_MAT = MATRICULA AND SUBSTR(RD_DATPGT,1,4) = '"+c_Ano+"' AND RD_PD = RV_COD AND RV_DIRF = 'T1' ),0) DEP13
		cquery += " FROM(
		cquery += " SELECT DISTINCT RA_FILIAL FILIAL,RA_MAT  MATRICULA,RA_NOMECMP,RA_CIC,RA_ADMISSA,RA_DEMISSA
		cquery += " FROM "+RetSqlName("SRA")+" A, "+RetSqlName("SRD")+" B"
		cquery += " WHERE A.D_E_L_E_T_ =  ' '
		cquery += " AND RA_FILIAL = RD_FILIAL AND RA_MAT  = RD_MAT
		cquery += " AND SUBSTR(RD_DATPGT,1,4) = '"+c_Ano+"'
		cquery += " AND RA_FILIAL BETWEEN '"+c_FilDe+"' AND '"+c_FilAte+"'"
		cquery += " AND RA_MAT  BETWEEN '"+c_MatDe+"' AND '"+c_MatAte+"'"
		cQuery += " AND RA_SITFOLH IN (" + c_Sit + ") "
		cQuery += " AND RA_CATFUNC IN (" + c_Cat + ") "
		cquery += " )T
		cquery += " )Y
		cquery += " ORDER BY RA_CIC,FILIAL, MATRICULA
		//Confere Assmed
	ElseIf nTipo == 3
		cQuery := ""
		cquery += " SELECT Y.*,VALSRD - VALRHS - VALRHP DIFERENCA
		cquery += " FROM(
		cquery += " SELECT T.*,RV_COD,RV_DESC
		cquery += " ,NVL((SELECT SUM(RD_VALOR) FROM  "+RetSqlName("SRD")+"  C WHERE C.D_E_L_E_T_ = ' ' AND RD_FILIAL = RA_FILIAL AND RD_MAT = RA_MAT  AND SUBSTR(RD_DATPGT,1,6) = ANOMESPG AND RD_PD = RV_COD),0) VALSRD
		cquery += " ,NVL((SELECT SUM(RHS_VLRFUN) FROM  "+RetSqlName("RHS")+"  C WHERE C.D_E_L_E_T_ = ' ' AND RHS_FILIAL = RA_FILIAL AND RHS_MAT = RA_MAT  AND SUBSTR(RHS_DATPGT,1,6) = ANOMESPG AND RHS_PD = RV_COD ),0) VALRHS
		cquery += " ,NVL((SELECT SUM(RHP_VLRFUN) FROM  "+RetSqlName("RHP")+"  C WHERE C.D_E_L_E_T_ = ' ' AND RHP_FILIAL = RA_FILIAL AND RHP_MAT = RA_MAT  AND SUBSTR(RHP_DATPGT,1,6) = ANOMESPG AND RHP_PD = RV_COD ),0) VALRHP
		cquery += " FROM(
		cquery += " SELECT RA_FILIAL,RA_MAT,RA_NOME,RA_CIC,RA_ADMISSA,RA_DEMISSA,'"+c_Ano+"01' ANOMESPG FROM "+RetSqlName("SRA")+" A WHERE A.D_E_L_E_T_ = ' ' AND RA_FILIAL BETWEEN '"+c_FilDe+"' AND '"+c_FilAte+"' AND RA_MAT  BETWEEN '"+c_MatDe+"' AND '"+c_MatAte+"' AND RA_SITFOLH IN (" + c_Sit + ") AND RA_CATFUNC IN (" + c_Cat + ")"
		cquery += " UNION ALL
		cquery += " SELECT RA_FILIAL,RA_MAT,RA_NOME,RA_CIC,RA_ADMISSA,RA_DEMISSA,'"+c_Ano+"02' ANOMESPG FROM "+RetSqlName("SRA")+" A WHERE A.D_E_L_E_T_ = ' ' AND RA_FILIAL BETWEEN '"+c_FilDe+"' AND '"+c_FilAte+"' AND RA_MAT  BETWEEN '"+c_MatDe+"' AND '"+c_MatAte+"' AND RA_SITFOLH IN (" + c_Sit + ") AND RA_CATFUNC IN (" + c_Cat + ")"
		cquery += " UNION ALL
		cquery += " SELECT RA_FILIAL,RA_MAT,RA_NOME,RA_CIC,RA_ADMISSA,RA_DEMISSA,'"+c_Ano+"03' ANOMESPG FROM "+RetSqlName("SRA")+" A WHERE A.D_E_L_E_T_ = ' ' AND RA_FILIAL BETWEEN '"+c_FilDe+"' AND '"+c_FilAte+"' AND RA_MAT  BETWEEN '"+c_MatDe+"' AND '"+c_MatAte+"' AND RA_SITFOLH IN (" + c_Sit + ") AND RA_CATFUNC IN (" + c_Cat + ")"
		cquery += " UNION ALL
		cquery += " SELECT RA_FILIAL,RA_MAT,RA_NOME,RA_CIC,RA_ADMISSA,RA_DEMISSA,'"+c_Ano+"04' ANOMESPG FROM "+RetSqlName("SRA")+" A WHERE A.D_E_L_E_T_ = ' ' AND RA_FILIAL BETWEEN '"+c_FilDe+"' AND '"+c_FilAte+"' AND RA_MAT  BETWEEN '"+c_MatDe+"' AND '"+c_MatAte+"' AND RA_SITFOLH IN (" + c_Sit + ") AND RA_CATFUNC IN (" + c_Cat + ")"
		cquery += " UNION ALL
		cquery += " SELECT RA_FILIAL,RA_MAT,RA_NOME,RA_CIC,RA_ADMISSA,RA_DEMISSA,'"+c_Ano+"05' ANOMESPG FROM "+RetSqlName("SRA")+" A WHERE A.D_E_L_E_T_ = ' ' AND RA_FILIAL BETWEEN '"+c_FilDe+"' AND '"+c_FilAte+"' AND RA_MAT  BETWEEN '"+c_MatDe+"' AND '"+c_MatAte+"' AND RA_SITFOLH IN (" + c_Sit + ") AND RA_CATFUNC IN (" + c_Cat + ")"
		cquery += " UNION ALL
		cquery += " SELECT RA_FILIAL,RA_MAT,RA_NOME,RA_CIC,RA_ADMISSA,RA_DEMISSA,'"+c_Ano+"06' ANOMESPG FROM "+RetSqlName("SRA")+" A WHERE A.D_E_L_E_T_ = ' ' AND RA_FILIAL BETWEEN '"+c_FilDe+"' AND '"+c_FilAte+"' AND RA_MAT  BETWEEN '"+c_MatDe+"' AND '"+c_MatAte+"' AND RA_SITFOLH IN (" + c_Sit + ") AND RA_CATFUNC IN (" + c_Cat + ")"
		cquery += " UNION ALL
		cquery += " SELECT RA_FILIAL,RA_MAT,RA_NOME,RA_CIC,RA_ADMISSA,RA_DEMISSA,'"+c_Ano+"07' ANOMESPG FROM "+RetSqlName("SRA")+" A WHERE A.D_E_L_E_T_ = ' ' AND RA_FILIAL BETWEEN '"+c_FilDe+"' AND '"+c_FilAte+"' AND RA_MAT  BETWEEN '"+c_MatDe+"' AND '"+c_MatAte+"' AND RA_SITFOLH IN (" + c_Sit + ") AND RA_CATFUNC IN (" + c_Cat + ")"
		cquery += " UNION ALL
		cquery += " SELECT RA_FILIAL,RA_MAT,RA_NOME,RA_CIC,RA_ADMISSA,RA_DEMISSA,'"+c_Ano+"08' ANOMESPG FROM "+RetSqlName("SRA")+" A WHERE A.D_E_L_E_T_ = ' ' AND RA_FILIAL BETWEEN '"+c_FilDe+"' AND '"+c_FilAte+"' AND RA_MAT  BETWEEN '"+c_MatDe+"' AND '"+c_MatAte+"' AND RA_SITFOLH IN (" + c_Sit + ") AND RA_CATFUNC IN (" + c_Cat + ")"
		cquery += " UNION ALL
		cquery += " SELECT RA_FILIAL,RA_MAT,RA_NOME,RA_CIC,RA_ADMISSA,RA_DEMISSA,'"+c_Ano+"09' ANOMESPG FROM "+RetSqlName("SRA")+" A WHERE A.D_E_L_E_T_ = ' ' AND RA_FILIAL BETWEEN '"+c_FilDe+"' AND '"+c_FilAte+"' AND RA_MAT  BETWEEN '"+c_MatDe+"' AND '"+c_MatAte+"' AND RA_SITFOLH IN (" + c_Sit + ") AND RA_CATFUNC IN (" + c_Cat + ")"
		cquery += " UNION ALL
		cquery += " SELECT RA_FILIAL,RA_MAT,RA_NOME,RA_CIC,RA_ADMISSA,RA_DEMISSA,'"+c_Ano+"10' ANOMESPG FROM "+RetSqlName("SRA")+" A WHERE A.D_E_L_E_T_ = ' ' AND RA_FILIAL BETWEEN '"+c_FilDe+"' AND '"+c_FilAte+"' AND RA_MAT  BETWEEN '"+c_MatDe+"' AND '"+c_MatAte+"' AND RA_SITFOLH IN (" + c_Sit + ") AND RA_CATFUNC IN (" + c_Cat + ")"
		cquery += " UNION ALL
		cquery += " SELECT RA_FILIAL,RA_MAT,RA_NOME,RA_CIC,RA_ADMISSA,RA_DEMISSA,'"+c_Ano+"11' ANOMESPG FROM "+RetSqlName("SRA")+" A WHERE A.D_E_L_E_T_ = ' ' AND RA_FILIAL BETWEEN '"+c_FilDe+"' AND '"+c_FilAte+"' AND RA_MAT  BETWEEN '"+c_MatDe+"' AND '"+c_MatAte+"' AND RA_SITFOLH IN (" + c_Sit + ") AND RA_CATFUNC IN (" + c_Cat + ")"
		cquery += " UNION ALL
		cquery += " SELECT RA_FILIAL,RA_MAT,RA_NOME,RA_CIC,RA_ADMISSA,RA_DEMISSA,'"+c_Ano+"12' ANOMESPG FROM "+RetSqlName("SRA")+" A WHERE A.D_E_L_E_T_ = ' ' AND RA_FILIAL BETWEEN '"+c_FilDe+"' AND '"+c_FilAte+"' AND RA_MAT  BETWEEN '"+c_MatDe+"' AND '"+c_MatAte+"' AND RA_SITFOLH IN (" + c_Sit + ") AND RA_CATFUNC IN (" + c_Cat + ")"
		cquery += " )T,  "+RetSqlName("SRV")+"  B
		cquery += " WHERE B.D_E_L_E_T_ = ' '
		cquery += " AND RV_DIRF = 'R '
		cquery += " )Y
		cquery += " WHERE (VALSRD <> 0 OR VALRHS <> 0 OR VALRHP <> 0)
		cquery += " ORDER BY 1,2,7
	Endif
Else
	//Analitico
	If nTipo == 1
		cQuery := ""
		cquery += " SELECT RA_FILIAL,RA_MAT,RA_NOME,RA_CIC,RA_CATFUNC,RD_PD,RV_DESC,RV_CODFOL,RV_TIPOCOD,RV_IR,RV_INSS,RV_FGTS,RV_RAIS,RV_DIRF+'-'+RTRIM(X5_DESCRI) TIPODIRF,CASE WHEN RV_DIRF IN ('A ','0 ','E ','I ','J ') AND RV_TIPOCOD = '2' THEN RD_VALOR*-1 ELSE RD_VALOR END RD_VALOR,RD_ROTEIR,RD_PERIODO,RD_DATPGT,SUBSTRING(RD_DATPGT,1,6) MESANOPG
		cquery += " FROM "+RetSqlName("SRA")+" A, "+RetSqlName("SRD")+" B, "+RetSqlName("SRV")+" C, "+RetSqlName("SX5")+" D"
		cquery += " WHERE A.D_E_L_E_T_ =  ' ' AND B.D_E_L_E_T_ = ' '  AND C.D_E_L_E_T_ = ' ' AND D.D_E_L_E_T_ = ' '
		cquery += " AND RA_FILIAL = RD_FILIAL AND RA_MAT = RD_MAT
		cquery += " AND RD_PD = RV_COD
		cquery += " AND X5_TABELA = '36' AND X5_CHAVE = RV_DIRF AND X5_FILIAL = "+c_FilSX5
		cquery += " AND SUBSTRING(RD_DATPGT,1,4) = '"+c_Ano+"'
		cquery += " AND (RV_TIPOCOD IN ('1','2') OR RV_DIRF NOT IN ('N ','  '))
		cquery += " AND C.RV_CODFOL NOT IN ('0006','0007')
		cquery += " AND RA_FILIAL BETWEEN '"+c_FilDe+"' AND '"+c_FilAte+"'"
		cquery += " AND RA_MAT BETWEEN '"+c_MatDe+"' AND '"+c_MatAte+"'"
		cQuery += " AND RA_SITFOLH IN (" + c_Sit + ") "
		cQuery += " AND RA_CATFUNC IN (" + c_Cat + ") "
		cQuery += " UNION ALL
		cQuery += " SELECT RA_FILIAL,RA_MAT,RA_NOME,RA_CIC,RA_CATFUNC,RD_PD,RV_DESC,RV_CODFOL,RV_TIPOCOD,RV_IR,RV_INSS,RV_FGTS,RV_RAIS,RV_DIRF+'-'+RTRIM(X5_DESCRI) TIPODIRF, RD_VALOR,RD_ROTEIR,RD_PERIODO,RD_DATPGT,SUBSTRING(RD_DATPGT,1,6) MESANOPG
		cquery += " FROM "+RetSqlName("SRA")+" A, "+RetSqlName("SRD")+" B, "+RetSqlName("SRV")+" C, "+RetSqlName("SX5")+" D"
		cquery += " WHERE A.D_E_L_E_T_ =  ' ' AND B.D_E_L_E_T_ = ' '  AND C.D_E_L_E_T_ = ' ' AND D.D_E_L_E_T_ = ' '
		cquery += " AND RA_FILIAL = RD_FILIAL AND RA_MAT = RD_MAT
		cquery += " AND X5_TABELA = '36' AND X5_CHAVE = 'A' AND X5_FILIAL = "+c_FilSX5
		cquery += " AND RD_PD = RV_COD
		cquery += " AND SUBSTRING(RD_DATPGT,1,4) =  '"+c_Ano+"'
		cquery += " AND C.RV_CODFOL = '0006'
		cquery += " AND RA_FILIAL BETWEEN '"+c_FilDe+"' AND '"+c_FilAte+"'"
		cquery += " AND RA_MAT BETWEEN '"+c_MatDe+"' AND '"+c_MatAte+"'"
		cQuery += " AND RA_SITFOLH IN (" + c_Sit + ") "
		cQuery += " AND RA_CATFUNC IN (" + c_Cat + ") "
		
		For xz := 1 to Len(a_Meses)
			cQuery += " UNION ALL
			cQuery += " SELECT RA_FILIAL,RA_MAT,RA_NOME,RA_CIC,RA_CATFUNC,RD_PD,RV_DESC,RV_CODFOL,RV_TIPOCOD,RV_IR,RV_INSS,RV_FGTS,RV_RAIS,RV_DIRF+'-'+RTRIM(X5_DESCRI) TIPODIRF, RD_VALOR * -1 RD_VALOR,RD_ROTEIR,RD_PERIODO,RD_DATPGT,'"+a_Meses[xz,1]+"' MESANOPG
			cQuery += " FROM "+RetSqlName("SRA")+" A, "+RetSqlName("SRD")+" B, "+RetSqlName("SRV")+" C, "+RetSqlName("SX5")+" D"
			cQuery += " WHERE A.D_E_L_E_T_ =  ' ' AND B.D_E_L_E_T_ = ' '  AND C.D_E_L_E_T_ = ' ' AND D.D_E_L_E_T_ = ' '
			cQuery += " AND RA_FILIAL = RD_FILIAL AND RA_MAT = RD_MAT
			cQuery += " AND X5_TABELA = '36' AND X5_CHAVE = 'A' AND X5_FILIAL = "+c_FilSX5
			cQuery += " AND RD_PD = RV_COD
			cQuery += " AND SUBSTRING(RD_DATPGT,1,6) = '"+a_Meses[xz,2]+"'"
			cQuery += " AND C.RV_CODFOL = '0006'
			cquery += " AND RA_FILIAL BETWEEN '"+c_FilDe+"' AND '"+c_FilAte+"'"
			cquery += " AND RA_MAT BETWEEN '"+c_MatDe+"' AND '"+c_MatAte+"'"
			cQuery += " AND RA_SITFOLH IN (" + c_Sit + ") "
			cQuery += " AND RA_CATFUNC IN (" + c_Cat + ") "
		Next xz
		cquery += " ORDER BY RA_FILIAL,RA_MAT,RD_PERIODO,MESANOPG,RD_ROTEIR,RD_PD
		//Confere Informe
	ElseIf nTipo == 2
		cQuery := ""
		cquery += " SELECT Y.*,REND13-PREV13-PEN13-DEP13-IRRF13 LIQ13
		cquery += " ,ISNULL((SELECT SUM(CASE WHEN RV_TIPOCOD = '2' THEN RD_VALOR * -1 ELSE RD_VALOR END) FROM "+RetSqlName("SRV")+" C, "+RetSqlName("SRD")+" D WHERE C.D_E_L_E_T_ = ' ' AND D.D_E_L_E_T_ = ' ' AND RD_FILIAL = FILIAL AND RD_MAT = MATRICULA AND SUBSTRING(RD_DATPGT,1,4) = '"+c_Ano+"' AND RD_PD = RV_COD AND RV_DIRF = 'O1' ),0) RENDPLR
		cquery += " ,ISNULL((SELECT SUM(CASE WHEN RV_TIPOCOD = '1' THEN RD_VALOR * -1 ELSE RD_VALOR END) FROM "+RetSqlName("SRV")+" C, "+RetSqlName("SRD")+" D WHERE C.D_E_L_E_T_ = ' ' AND D.D_E_L_E_T_ = ' ' AND RD_FILIAL = FILIAL AND RD_MAT = MATRICULA AND SUBSTRING(RD_DATPGT,1,4) = '"+c_Ano+"' AND RD_PD = RV_COD AND RV_DIRF = 'Q1' ),0) IRRFPLR
		cquery += " ,ISNULL((SELECT SUM(CASE WHEN RV_TIPOCOD = '1' THEN RD_VALOR * -1 ELSE RD_VALOR END) FROM "+RetSqlName("SRV")+" C, "+RetSqlName("SRD")+" D WHERE C.D_E_L_E_T_ = ' ' AND D.D_E_L_E_T_ = ' ' AND RD_FILIAL = FILIAL AND RD_MAT = MATRICULA AND SUBSTRING(RD_DATPGT,1,4) = '"+c_Ano+"' AND RD_PD = RV_COD AND RV_DIRF = 'R' ),0) ASSMED
		cquery += " FROM(
		cquery += " SELECT T.*
		cquery += " ,ISNULL((SELECT SUM(CASE WHEN RV_TIPOCOD = '2' THEN RD_VALOR * -1 ELSE RD_VALOR END) FROM "+RetSqlName("SRV")+" C, "+RetSqlName("SRD")+" D WHERE C.D_E_L_E_T_ = ' ' AND D.D_E_L_E_T_ = ' ' AND RD_FILIAL = FILIAL AND RD_MAT = MATRICULA AND SUBSTRING(RD_DATPGT,1,4) = '"+c_Ano+"' AND RD_PD = RV_COD AND RV_DIRF = 'A' AND RV_CODFOL NOT IN  ('0006','0007')  ),0)
		cquery += " +ISNULL((SELECT SUM(RD_VALOR) FROM "+RetSqlName("SRV")+" C, "+RetSqlName("SRD")+" D WHERE C.D_E_L_E_T_ = ' ' AND D.D_E_L_E_T_ = ' ' AND RD_FILIAL = FILIAL AND RD_MAT = MATRICULA AND SUBSTRING(RD_DATPGT,1,4) = '"+c_Ano+"' AND RD_PD = RV_COD AND RV_CODFOL = '0006'  AND SUBSTRING(RD_DATPGT,1,4) = '"+c_Ano+"' ),0)
		cquery += " -ISNULL((SELECT SUM(RD_VALOR) FROM "+RetSqlName("SRV")+" C, "+RetSqlName("SRD")+" D WHERE C.D_E_L_E_T_ = ' ' AND D.D_E_L_E_T_ = ' ' AND RD_FILIAL = FILIAL AND RD_MAT = MATRICULA AND SUBSTRING(RD_DATPGT,1,4) = '"+c_Ano+"' AND RD_PD = RV_COD AND RV_CODFOL = '0006' AND RD_DATARQ BETWEEN '"+StrZero(Val(c_Ano)-1,4)+"12' AND '"+c_Ano+"11' ),0) REND
		cquery += " ,ISNULL((SELECT SUM(CASE WHEN RV_TIPOCOD = '1' THEN RD_VALOR * -1 ELSE RD_VALOR END) FROM "+RetSqlName("SRV")+" C, "+RetSqlName("SRD")+" D WHERE C.D_E_L_E_T_ = ' ' AND D.D_E_L_E_T_ = ' ' AND RD_FILIAL = FILIAL AND RD_MAT = MATRICULA AND SUBSTRING(RD_DATPGT,1,4) = '"+c_Ano+"' AND RD_PD = RV_COD AND RV_DIRF = 'B' ),0) PREV
		cquery += " ,ISNULL((SELECT SUM(CASE WHEN RV_TIPOCOD = '1' THEN RD_VALOR * -1 ELSE RD_VALOR END) FROM "+RetSqlName("SRV")+" C, "+RetSqlName("SRD")+" D WHERE C.D_E_L_E_T_ = ' ' AND D.D_E_L_E_T_ = ' ' AND RD_FILIAL = FILIAL AND RD_MAT = MATRICULA AND SUBSTRING(RD_DATPGT,1,4) = '"+c_Ano+"' AND RD_PD = RV_COD AND RV_DIRF = 'D' ),0) IRRF
		cquery += " ,ISNULL((SELECT SUM(CASE WHEN RV_TIPOCOD = '2' THEN RD_VALOR * -1 ELSE RD_VALOR END) FROM "+RetSqlName("SRV")+" C, "+RetSqlName("SRD")+" D WHERE C.D_E_L_E_T_ = ' ' AND D.D_E_L_E_T_ = ' ' AND RD_FILIAL = FILIAL AND RD_MAT = MATRICULA AND SUBSTRING(RD_DATPGT,1,4) = '"+c_Ano+"' AND RD_PD = RV_COD AND RV_DIRF = 'E' ),0) INDENIZA
		cquery += " ,ISNULL((SELECT SUM(CASE WHEN RV_TIPOCOD = '2' THEN RD_VALOR * -1 ELSE RD_VALOR END) FROM "+RetSqlName("SRV")+" C, "+RetSqlName("SRD")+" D WHERE C.D_E_L_E_T_ = ' ' AND D.D_E_L_E_T_ = ' ' AND RD_FILIAL = FILIAL AND RD_MAT = MATRICULA AND SUBSTRING(RD_DATPGT,1,4) = '"+c_Ano+"' AND RD_PD = RV_COD AND RV_DIRF = 'I' ),0) ISENTOS
		cquery += " ,ISNULL((SELECT SUM(CASE WHEN RV_TIPOCOD = '2' THEN RD_VALOR * -1 ELSE RD_VALOR END) FROM "+RetSqlName("SRV")+" C, "+RetSqlName("SRD")+" D WHERE C.D_E_L_E_T_ = ' ' AND D.D_E_L_E_T_ = ' ' AND RD_FILIAL = FILIAL AND RD_MAT = MATRICULA AND SUBSTRING(RD_DATPGT,1,4) = '"+c_Ano+"' AND RD_PD = RV_COD AND RV_DIRF = '0' ),0) ABONOS
		cquery += " ,ISNULL((SELECT SUM(CASE WHEN RV_TIPOCOD = '1' THEN RD_VALOR * -1 ELSE RD_VALOR END) FROM "+RetSqlName("SRV")+" C, "+RetSqlName("SRD")+" D WHERE C.D_E_L_E_T_ = ' ' AND D.D_E_L_E_T_ = ' ' AND RD_FILIAL = FILIAL AND RD_MAT = MATRICULA AND SUBSTRING(RD_DATPGT,1,4) = '"+c_Ano+"' AND RD_PD = RV_COD AND RV_DIRF = 'C' ),0) PENSAO
		cquery += " ,ISNULL((SELECT SUM(CASE WHEN RV_TIPOCOD = '2' THEN RD_VALOR * -1 ELSE RD_VALOR END) FROM "+RetSqlName("SRV")+" C, "+RetSqlName("SRD")+" D WHERE C.D_E_L_E_T_ = ' ' AND D.D_E_L_E_T_ = ' ' AND RD_FILIAL = FILIAL AND RD_MAT = MATRICULA AND SUBSTRING(RD_DATPGT,1,4) = '"+c_Ano+"' AND RD_PD = RV_COD AND RV_DIRF = 'J' ),0) REND13
		cquery += " ,ISNULL((SELECT SUM(CASE WHEN RV_TIPOCOD = '1' THEN RD_VALOR * -1 ELSE RD_VALOR END) FROM "+RetSqlName("SRV")+" C, "+RetSqlName("SRD")+" D WHERE C.D_E_L_E_T_ = ' ' AND D.D_E_L_E_T_ = ' ' AND RD_FILIAL = FILIAL AND RD_MAT = MATRICULA AND SUBSTRING(RD_DATPGT,1,4) = '"+c_Ano+"' AND RD_PD = RV_COD AND RV_DIRF = 'B1' ),0) PREV13
		cquery += " ,ISNULL((SELECT SUM(CASE WHEN RV_TIPOCOD = '1' THEN RD_VALOR * -1 ELSE RD_VALOR END) FROM "+RetSqlName("SRV")+" C, "+RetSqlName("SRD")+" D WHERE C.D_E_L_E_T_ = ' ' AND D.D_E_L_E_T_ = ' ' AND RD_FILIAL = FILIAL AND RD_MAT = MATRICULA AND SUBSTRING(RD_DATPGT,1,4) = '"+c_Ano+"' AND RD_PD = RV_COD AND RV_DIRF = 'L'  ),0) IRRF13
		cquery += " ,ISNULL((SELECT SUM(CASE WHEN RV_TIPOCOD = '1' THEN RD_VALOR * -1 ELSE RD_VALOR END) FROM "+RetSqlName("SRV")+" C, "+RetSqlName("SRD")+" D WHERE C.D_E_L_E_T_ = ' ' AND D.D_E_L_E_T_ = ' ' AND RD_FILIAL = FILIAL AND RD_MAT = MATRICULA AND SUBSTRING(RD_DATPGT,1,4) = '"+c_Ano+"' AND RD_PD = RV_COD AND RV_DIRF = 'C1' ),0) PEN13
		cquery += " ,ISNULL((SELECT SUM(CASE WHEN RV_TIPOCOD = '2' THEN RD_VALOR * -1 ELSE RD_VALOR END) FROM "+RetSqlName("SRV")+" C, "+RetSqlName("SRD")+" D WHERE C.D_E_L_E_T_ = ' ' AND D.D_E_L_E_T_ = ' ' AND RD_FILIAL = FILIAL AND RD_MAT = MATRICULA AND SUBSTRING(RD_DATPGT,1,4) = '"+c_Ano+"' AND RD_PD = RV_COD AND RV_DIRF = 'T1' ),0) DEP13
		cquery += " FROM(
		cquery += " SELECT DISTINCT RA_FILIAL FILIAL,RA_MAT  MATRICULA,RA_NOMECMP,RA_CIC,RA_ADMISSA,RA_DEMISSA
		cquery += " FROM "+RetSqlName("SRA")+" A, "+RetSqlName("SRD")+" B"
		cquery += " WHERE A.D_E_L_E_T_ =  ' '
		cquery += " AND RA_FILIAL = RD_FILIAL AND RA_MAT  = RD_MAT
		cquery += " AND SUBSTRING(RD_DATPGT,1,4) = '"+c_Ano+"'
		cquery += " AND RA_FILIAL BETWEEN '"+c_FilDe+"' AND '"+c_FilAte+"'"
		cquery += " AND RA_MAT  BETWEEN '"+c_MatDe+"' AND '"+c_MatAte+"'"
		cQuery += " AND RA_SITFOLH IN (" + c_Sit + ") "
		cQuery += " AND RA_CATFUNC IN (" + c_Cat + ") "
		cquery += " )T
		cquery += " )Y
		cquery += " ORDER BY RA_CIC,FILIAL, MATRICULA
		//Confere Assmed
	ElseIf nTipo == 3
		cQuery := ""
		cquery += " SELECT Y.*,VALSRD - VALRHS - VALRHP DIFERENCA
		cquery += " FROM(
		cquery += " SELECT T.*,RV_COD,RV_DESC
		cquery += " ,ISNULL((SELECT SUM(RD_VALOR) FROM  "+RetSqlName("SRD")+"  C WHERE C.D_E_L_E_T_ = ' ' AND RD_FILIAL = RA_FILIAL AND RD_MAT = RA_MAT  AND SUBSTRING(RD_DATPGT,1,6) = ANOMESPG AND RD_PD = RV_COD),0) VALSRD
		cquery += " ,ISNULL((SELECT SUM(RHS_VLRFUN) FROM  "+RetSqlName("RHS")+"  C WHERE C.D_E_L_E_T_ = ' ' AND RHS_FILIAL = RA_FILIAL AND RHS_MAT = RA_MAT  AND SUBSTRING(RHS_DATPGT,1,6) = ANOMESPG AND RHS_PD = RV_COD ),0) VALRHS
		cquery += " ,ISNULL((SELECT SUM(RHP_VLRFUN) FROM  "+RetSqlName("RHP")+"  C WHERE C.D_E_L_E_T_ = ' ' AND RHP_FILIAL = RA_FILIAL AND RHP_MAT = RA_MAT  AND SUBSTRING(RHP_DATPGT,1,6) = ANOMESPG AND RHP_PD = RV_COD ),0) VALRHP
		cquery += " FROM(
		cquery += " SELECT RA_FILIAL,RA_MAT,RA_NOME,RA_CIC,RA_ADMISSA,RA_DEMISSA,'"+c_Ano+"01' ANOMESPG FROM "+RetSqlName("SRA")+" A WHERE A.D_E_L_E_T_ = ' ' AND RA_FILIAL BETWEEN '"+c_FilDe+"' AND '"+c_FilAte+"' AND RA_MAT  BETWEEN '"+c_MatDe+"' AND '"+c_MatAte+"' AND RA_SITFOLH IN (" + c_Sit + ") AND RA_CATFUNC IN (" + c_Cat + ")"
		cquery += " UNION ALL
		cquery += " SELECT RA_FILIAL,RA_MAT,RA_NOME,RA_CIC,RA_ADMISSA,RA_DEMISSA,'"+c_Ano+"02' ANOMESPG FROM "+RetSqlName("SRA")+" A WHERE A.D_E_L_E_T_ = ' ' AND RA_FILIAL BETWEEN '"+c_FilDe+"' AND '"+c_FilAte+"' AND RA_MAT  BETWEEN '"+c_MatDe+"' AND '"+c_MatAte+"' AND RA_SITFOLH IN (" + c_Sit + ") AND RA_CATFUNC IN (" + c_Cat + ")"
		cquery += " UNION ALL
		cquery += " SELECT RA_FILIAL,RA_MAT,RA_NOME,RA_CIC,RA_ADMISSA,RA_DEMISSA,'"+c_Ano+"03' ANOMESPG FROM "+RetSqlName("SRA")+" A WHERE A.D_E_L_E_T_ = ' ' AND RA_FILIAL BETWEEN '"+c_FilDe+"' AND '"+c_FilAte+"' AND RA_MAT  BETWEEN '"+c_MatDe+"' AND '"+c_MatAte+"' AND RA_SITFOLH IN (" + c_Sit + ") AND RA_CATFUNC IN (" + c_Cat + ")"
		cquery += " UNION ALL
		cquery += " SELECT RA_FILIAL,RA_MAT,RA_NOME,RA_CIC,RA_ADMISSA,RA_DEMISSA,'"+c_Ano+"04' ANOMESPG FROM "+RetSqlName("SRA")+" A WHERE A.D_E_L_E_T_ = ' ' AND RA_FILIAL BETWEEN '"+c_FilDe+"' AND '"+c_FilAte+"' AND RA_MAT  BETWEEN '"+c_MatDe+"' AND '"+c_MatAte+"' AND RA_SITFOLH IN (" + c_Sit + ") AND RA_CATFUNC IN (" + c_Cat + ")"
		cquery += " UNION ALL
		cquery += " SELECT RA_FILIAL,RA_MAT,RA_NOME,RA_CIC,RA_ADMISSA,RA_DEMISSA,'"+c_Ano+"05' ANOMESPG FROM "+RetSqlName("SRA")+" A WHERE A.D_E_L_E_T_ = ' ' AND RA_FILIAL BETWEEN '"+c_FilDe+"' AND '"+c_FilAte+"' AND RA_MAT  BETWEEN '"+c_MatDe+"' AND '"+c_MatAte+"' AND RA_SITFOLH IN (" + c_Sit + ") AND RA_CATFUNC IN (" + c_Cat + ")"
		cquery += " UNION ALL
		cquery += " SELECT RA_FILIAL,RA_MAT,RA_NOME,RA_CIC,RA_ADMISSA,RA_DEMISSA,'"+c_Ano+"06' ANOMESPG FROM "+RetSqlName("SRA")+" A WHERE A.D_E_L_E_T_ = ' ' AND RA_FILIAL BETWEEN '"+c_FilDe+"' AND '"+c_FilAte+"' AND RA_MAT  BETWEEN '"+c_MatDe+"' AND '"+c_MatAte+"' AND RA_SITFOLH IN (" + c_Sit + ") AND RA_CATFUNC IN (" + c_Cat + ")"
		cquery += " UNION ALL
		cquery += " SELECT RA_FILIAL,RA_MAT,RA_NOME,RA_CIC,RA_ADMISSA,RA_DEMISSA,'"+c_Ano+"07' ANOMESPG FROM "+RetSqlName("SRA")+" A WHERE A.D_E_L_E_T_ = ' ' AND RA_FILIAL BETWEEN '"+c_FilDe+"' AND '"+c_FilAte+"' AND RA_MAT  BETWEEN '"+c_MatDe+"' AND '"+c_MatAte+"' AND RA_SITFOLH IN (" + c_Sit + ") AND RA_CATFUNC IN (" + c_Cat + ")"
		cquery += " UNION ALL
		cquery += " SELECT RA_FILIAL,RA_MAT,RA_NOME,RA_CIC,RA_ADMISSA,RA_DEMISSA,'"+c_Ano+"08' ANOMESPG FROM "+RetSqlName("SRA")+" A WHERE A.D_E_L_E_T_ = ' ' AND RA_FILIAL BETWEEN '"+c_FilDe+"' AND '"+c_FilAte+"' AND RA_MAT  BETWEEN '"+c_MatDe+"' AND '"+c_MatAte+"' AND RA_SITFOLH IN (" + c_Sit + ") AND RA_CATFUNC IN (" + c_Cat + ")"
		cquery += " UNION ALL
		cquery += " SELECT RA_FILIAL,RA_MAT,RA_NOME,RA_CIC,RA_ADMISSA,RA_DEMISSA,'"+c_Ano+"09' ANOMESPG FROM "+RetSqlName("SRA")+" A WHERE A.D_E_L_E_T_ = ' ' AND RA_FILIAL BETWEEN '"+c_FilDe+"' AND '"+c_FilAte+"' AND RA_MAT  BETWEEN '"+c_MatDe+"' AND '"+c_MatAte+"' AND RA_SITFOLH IN (" + c_Sit + ") AND RA_CATFUNC IN (" + c_Cat + ")"
		cquery += " UNION ALL
		cquery += " SELECT RA_FILIAL,RA_MAT,RA_NOME,RA_CIC,RA_ADMISSA,RA_DEMISSA,'"+c_Ano+"10' ANOMESPG FROM "+RetSqlName("SRA")+" A WHERE A.D_E_L_E_T_ = ' ' AND RA_FILIAL BETWEEN '"+c_FilDe+"' AND '"+c_FilAte+"' AND RA_MAT  BETWEEN '"+c_MatDe+"' AND '"+c_MatAte+"' AND RA_SITFOLH IN (" + c_Sit + ") AND RA_CATFUNC IN (" + c_Cat + ")"
		cquery += " UNION ALL
		cquery += " SELECT RA_FILIAL,RA_MAT,RA_NOME,RA_CIC,RA_ADMISSA,RA_DEMISSA,'"+c_Ano+"11' ANOMESPG FROM "+RetSqlName("SRA")+" A WHERE A.D_E_L_E_T_ = ' ' AND RA_FILIAL BETWEEN '"+c_FilDe+"' AND '"+c_FilAte+"' AND RA_MAT  BETWEEN '"+c_MatDe+"' AND '"+c_MatAte+"' AND RA_SITFOLH IN (" + c_Sit + ") AND RA_CATFUNC IN (" + c_Cat + ")"
		cquery += " UNION ALL
		cquery += " SELECT RA_FILIAL,RA_MAT,RA_NOME,RA_CIC,RA_ADMISSA,RA_DEMISSA,'"+c_Ano+"12' ANOMESPG FROM "+RetSqlName("SRA")+" A WHERE A.D_E_L_E_T_ = ' ' AND RA_FILIAL BETWEEN '"+c_FilDe+"' AND '"+c_FilAte+"' AND RA_MAT  BETWEEN '"+c_MatDe+"' AND '"+c_MatAte+"' AND RA_SITFOLH IN (" + c_Sit + ") AND RA_CATFUNC IN (" + c_Cat + ")"
		cquery += " )T,  "+RetSqlName("SRV")+"  B
		cquery += " WHERE B.D_E_L_E_T_ = ' '
		cquery += " AND RV_DIRF = 'R '
		cquery += " )Y
		cquery += " WHERE (VALSRD <> 0 OR VALRHS <> 0 OR VALRHP <> 0)
		cquery += " ORDER BY 1,2,7
	Endif
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
Local j,i
cPerg := Padr(cPerg,Len(SX1->X1_GRUPO))

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
aAdd(aRegs,{ cPerg,'01','Ano                     ?','','','mv_ch1','N',04,0,0,'G','NaoVazio'  	,'mv_par01',''                 ,'','','','',''                 ,'','','','',''                    ,'','','','',''                 ,'','','','',''      ,'','','' ,'   ','' })
aAdd(aRegs,{ cPerg,'02','Filial De               ?','','','mv_ch2','C',02,0,0,'G','        '  	,'mv_par02',''                 ,'','','','',''                 ,'','','','',''                    ,'','','','',''                 ,'','','','',''      ,'','','' ,'XM0','' })
aAdd(aRegs,{ cPerg,'03','Filial Ate              ?','','','mv_ch3','C',02,0,0,'G','NaoVazio'  	,'mv_par03',''                 ,'','','','',''                 ,'','','','',''                    ,'','','','',''                 ,'','','','',''      ,'','','' ,'XM0','' })
aAdd(aRegs,{ cPerg,'04','Matricula De            ?','','','mv_ch4','C',06,0,0,'G','           ','mv_par04','               ','','','','','           ','','','','','         ','','','','','            ','','','','','           ','','','','SRA   ','' })
aAdd(aRegs,{ cPerg,'05','Matricula Ate           ?','','','mv_ch5','C',06,0,0,'G','NaoVazio   ','mv_par05','               ','','','','','           ','','','','','         ','','','','','            ','','','','','           ','','','','SRA   ','' })
aAdd(aRegs,{ cPerg,'06','Situacoes               ?','','','mv_ch6','C',05,0,0,'G','fSituacao  ','mv_par06','               ','','','','','           ','','','','','         ','','','','','            ','','','','','           ','','','','      ','' })
aAdd(aRegs,{ cPerg,'07','Categorias              ?','','','mv_ch7','C',15,0,0,'G','fCategoria ','mv_par07','               ','','','','','           ','','','','','         ','','','','','            ','','','','','           ','','','','      ','' })

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
