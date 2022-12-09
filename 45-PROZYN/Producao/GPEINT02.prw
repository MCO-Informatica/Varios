#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH" 
#INCLUDE "tbiconn.ch"
#INCLUDE "tbicode.ch"
#Include "TopConn.ch"
#DEFINE  ENTER CHR(13)+CHR(10)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออปฑฑ
ฑฑบPrograma  ณ RCRMR010  บAutor  ณ Guilherme Coelho  บ Data ณ  22/11/2020  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina para impressใo do relatorio de Vale Alimenta็ใo	   บฑฑ
ฑฑบDesc.     ณ Prozyn - Protheus 12                                        บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Protheus 12 - Prozyn                                        บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออนฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function GPEINT02()
cPerg 	:= Padr("GPEINT02",10)

Private lMsErroAuto := .F.

ValidPerg()
Pergunte(cPerg,.F.)

cCadastro     := " "
aSays         := {}
aButtons      := {}
_nOpc         := 0

AADD(aSays,"Geracao do arquivo de compra ")
AADD(aSays,"do Vale Alimentacao - Alelo ")
AADD(aSays,"")
AADD(aButtons,{5,.T.,{|| Pergunte(cPerg,.T.)	}})
AADD(aButtons,{1,.T.,{|| (_nOpc := 1, FechaBatch())	}})
AADD(aButtons,{2,.T.,{|| FechaBatch() 		  	}})

FormBatch(cCadastro, aSays, aButtons)

If _nOpc = 1
	Processa({|| ARQUVA()},cCadastro)
EndIf

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออปฑฑ
ฑฑบPrograma  ณ RCRMR010  บAutor  ณ Derik Santos      บ Data ณ  22/11/2016  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออนฑฑ
ฑฑบDesc.     ณ Query Vale alimenta็ใo									   บฑฑ
ฑฑบDesc.     ณ Prozyn - Protheus 12                                        บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Protheus 12 - Prozyn                                        บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออนฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function ARQUVA()


Default cQuery    := " "
Default cTitulo   := " "

cTit1 := "CONTRATO"
cTit2 := "$"
cTit3 := "11610119"
cTitAux := cTit1 + ENTER + cTit2 + cTit3 + cTit2

cFilDe  	:= mv_par01
cFilAte     := mv_par02
cCcDe    	:= mv_par03
cCcAte 	    := mv_par04
cMatDe		:= mv_par05
cMatAte		:= mv_par06


cQuery := "SELECT '%'                       AS 'SPC '," + ENTER
cQuery += " RA_NOME                    AS NOME, " + ENTER
cQuery += "       RA_CIC                     AS CPF, "  + ENTER
cQuery += "       SUBSTRING(RA_NASC, 7, 2) + '/' + SUBSTRING(RA_NASC, 5, 2) + '/' + SUBSTRING(RA_NASC, 1, 4) AS NASCIMENTO, " + ENTER
cQuery += "       RA_SEXO                    AS SEXO, " + ENTER
cQuery += "       R0_VALCAL                  AS VALOR, "+ ENTER
cQuery += "       'FI'                       AS TPLOCENTRE, " + ENTER
cQuery += "       SUBSTRING(RGC_CPFCGC,11,4)    AS LOCENTREGA, "  + ENTER
cQuery += "       R0_MAT                     AS MATRICULA," + ENTER
cQuery += "       '%'                       AS 'SPC' " + ENTER
cQuery += "FROM   SR0010 SR0 " + ENTER
cQuery += "       INNER JOIN SRA010 SRA " + ENTER
cQuery += "               ON SRA.D_E_L_E_T_ = ' ' " + ENTER
cQuery += "                  AND R0_FILIAL = RA_FILIAL " + ENTER
cQuery += "                  AND R0_MAT = RA_MAT " + ENTER
cQuery += "                  AND RA_SITFOLH <> 'D' " + ENTER
cQuery += "        			 AND RA_CC BETWEEN '"+cCcDe+"' AND '"+cCcAte+"' " + ENTER
cQuery += "       INNER JOIN RGC010 RGC " + ENTER
cQuery += "               ON RGC.D_E_L_E_T_ = ' ' " + ENTER
cQuery += "                  AND RGC_FILIAL = RA_FILIAL " + ENTER
//cQuery += "                  AND RGC_KEYLOC = RA_LOCBNF " + ENTER
cQuery += "       INNER JOIN RFO010 RFO " + ENTER
cQuery += "               ON RFO.D_E_L_E_T_ = ' ' " + ENTER
cQuery += "                  AND R0_TPVALE = RFO_TPVALE " + ENTER
cQuery += "                  AND R0_CODIGO = RFO_CODIGO " + ENTER
cQuery += "                  AND RFO_TPBEN = '02' " + ENTER
cQuery += "WHERE  SR0.D_E_L_E_T_ = ' ' " + ENTER
cQuery += "       AND R0_TPVALE = '1'" + ENTER
//cQuery += "	      AND R0_VALCAL > 0" + ENTER
cQuery += "       AND R0_FILIAL BETWEEN '"+cFilDe+"' AND '"+cFilAte+"' " + ENTER
cQuery += "       AND R0_MAT BETWEEN '"+cMatDe+"' AND '"+cMatAte+"' " + ENTER
cQuery += "       AND R0_CODIGO BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"' " + ENTER
ย ย ย 
dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"SQL",.F.,.T.)
DbSelectArea("SQL")
SQL->(DbGoTop())

u_zQ2Excel(cQuery,cTitulo)


SQL->(DbCloseArea())

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออปฑฑ
ฑฑบPrograma  ณ RCRMR010  บAutor  ณ Derik Santos      บ Data ณ  22/11/2016  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina para impressใo do Parametros de relat๓rio			   บฑฑ
ฑฑบDesc.     ณ Prozyn - Protheus 12                                        บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Protheus 12 - Prozyn                                        บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออนฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function ValidPerg

Local _sAlias, aRegs, i,j

_sAlias := Alias()
aRegs := {}
I := 0
J := 0

dbSelectArea("SX1")
dbSetOrder(1)

Aadd(aRegs,{cPerg,"01","Filial de?     ", "Filial    ?",		"Filial    ?",		"mv_ch1","C",06,0,0,"G" ,"","mv_par01","","","","","","","","","","","","","","","","","","",""	,""	,""	,""	,"","","SM0",""})
Aadd(aRegs,{cPerg,"02","Filial Ate?    ", "Filial    ?",		"Filial    ?",		"mv_ch2","C",06,0,0,"G" ,"","mv_par02","","","","","","","","","","","","","","","","","","","",""	,""	,""	,"","","SM0",""})
Aadd(aRegs,{cPerg,"03","C.Custo de?    ", "Custol    ?",		"Custo     ?",		"mv_ch3","C",09,0,0,"G" ,"","mv_par03","","","","","","","","","","","","","","","","","","",""	,""	,""	,""	,"","","SI3",""})
Aadd(aRegs,{cPerg,"04","C.Custo Ate?   ", "Custol    ?",		"Custo     ?",		"mv_ch4","C",09,0,0,"G" ,"","mv_par04","","","","","","","","","","","","","","","","","","","",""	,""	,""	,"","","SI3",""})
Aadd(aRegs,{cPerg,"05","Matricula de?  ", "Matricula ?",		"Matricula ?",		"mv_ch5","C",06,0,0,"G" ,"","mv_par05","","","","","","","","","","","","","","","","","","",""	,""	,""	,""	,"","","SRA",""})
Aadd(aRegs,{cPerg,"06","Matricula Ate? ", "Matricula ?",		"Matricula ?",		"mv_ch6","C",06,0,0,"G" ,"","mv_par06","","","","","","","","","","","","","","","","","","","",""	,""	,""	,"","","SRA",""})
//Aadd(aRegs,{cPerg,"07","C. Benef. de?  ","Cod. Benf  ?",	    "Cod. Benef?",		"mv_ch7","C",06,0,0,"G" ,"","mv_par07","","","","","","","","","","","","","","","","","","","",""	,""	,""	,"","","RFO",""})
//Aadd(aRegs,{cPerg,"08","C. Benef. Ate? ","Cod. Benf  ?",	    "Cod. Benef?",		"mv_ch8","C",06,0,0,"G" ,"","mv_par08","","","","","","","","","","","","","","","","","","","",""	,""	,""	,"","","RFO",""})

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

dbSelectArea(_sAlias)

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออปฑฑ
ฑฑบPrograma  ณ RCRMR010  บAutor  ณ Derik Santos      บ Data ณ  22/11/2016  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina para impressใo do relatorio em excel				   บฑฑ
ฑฑบDesc.     ณ Prozyn - Protheus 12                                        บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Protheus 12 - Prozyn                                        บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออนฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function zQ2Excel(cQryAux, cTitAux)
	Default cQryAux   := ""

	cTit1 := "CONTRATO"
	cTit2 := "$"
	cTit3 := "11610119"

	cTitAux := cTit1 + ENTER +  cTit2 + cTit3 + cTit2
	
	Processa({|| fProcessa(cQryAux, cTitAux) }, "Processando...")
Return
/*---------------------------------------------------------------------*
 | Func:  fProcessa                                                    |
 | Desc:  Funรงรฃo de processamento                                      |
 *---------------------------------------------------------------------*/
Static Function fProcessa(cQryAux, cTitAux)
	Local aArea       := GetArea()
	Local aAreaX3     := SX3->(GetArea())
	Local nAux        := 0
	Local oFWMsExcel
	Local oExcel
	Local cDiretorio  := GetTempPath()
	Local cArquivo    := "va.csv'
	Local cArqFull    := cDiretorio + cArquivo
	Local cWorkSheet  := "Aba - Principal"
	Local cTable      := ""
	Local aColunas    := {}
	Local aEstrut     := {}
	Local aLinhaAux   := {}
	Local cTitulo     := ""
	Local nTotal      := 0
	Local nAtual      := 0
	Default cQryAux   := ""
	Default cTitAux   := " "
	
	cTable := cTitAux
	
	//Se tiver a consulta
	If !Empty(cQryAux)
		TCQuery cQryAux New Alias "QRY_AUX"
		
		DbSelectArea('SX3')
		SX3->(DbSetOrder(2)) //X3_CAMPO
		
		//Percorrendo a estrutura
		aEstrut := QRY_AUX->(DbStruct())
		ProcRegua(Len(aEstrut))
		For nAux := 1 To Len(aEstrut)
			IncProc("Incluindo coluna "+cValToChar(nAux)+" de "+cValToChar(Len(aEstrut))+"...")
			cTitulo := ""
			
			//Se conseguir posicionar no campo
			If SX3->(DbSeek(aEstrut[nAux][1]))
				cTitulo := Alltrim(SX3->X3_TITULO)
				
				//Se for tipo data, transforma a coluna
				If SX3->X3_TIPO == 'D'
					TCSetField("QRY_AUX", aEstrut[nAux][1], "D")
				EndIf
			Else
				cTitulo := Capital(Alltrim(aEstrut[nAux][1]))
			EndIf
			
			//Adicionando nas colunas
			aAdd(aColunas, cTitulo)
		Next
		 
		//Criando o objeto que irรก gerar o conteรบdo do Excel
		oFWMsExcel := FWMSExcel():New()
		oFWMsExcel:AddworkSheet(cWorkSheet)
			oFWMsExcel:AddTable(cWorkSheet, cTable)
			
			//Adicionando as Colunas
			For nAux := 1 To Len(aColunas)
				oFWMsExcel:AddColumn(cWorkSheet, cTable, aColunas[nAux], 1, 1)
			Next
			
			//Definindo o total da barra
			DbSelectArea("QRY_AUX")
			QRY_AUX->(DbGoTop())
			Count To nTotal
			ProcRegua(nTotal)
			nAtual := 0
			
			//Percorrendo os produtos
			QRY_AUX->(DbGoTop())
			While !QRY_AUX->(EoF())
				nAtual++
				IncProc("Processando registro "+cValToChar(nAtual)+" de "+cValToChar(nTotal)+"...")
			
				//Criando a linha
				aLinhaAux := Array(Len(aColunas))
				For nAux := 1 To Len(aEstrut)
					//Ajuste para remover & da String - Gustavo Gonzalez
					If Valtype(&("QRY_AUX->"+aEstrut[nAux][1])) == 'C'
						aLinhaAux[nAux] := STRTRAN(&("QRY_AUX->"+aEstrut[nAux][1]),'&','E')
					Else
						aLinhaAux[nAux] := &("QRY_AUX->"+aEstrut[nAux][1])
					EndIf
				Next
				 
				//Adiciona a linha no Excel
				oFWMsExcel:AddRow(cWorkSheet, cTable, aLinhaAux)
				 
				QRY_AUX->(DbSkip())
			EndDo
			 
		//Ativando o arquivo e gerando o xml
		oFWMsExcel:Activate()
		oFWMsExcel:GetXMLFile(cArqFull)
		
		//Se tiver o excel instalado
		If ApOleClient("msexcel")
			oExcel := MsExcel():New()
			oExcel:WorkBooks:Open(cArqFull)
			oExcel:SetVisible(.T.)
			oExcel:Destroy()
		
		Else
			//Se existir a pasta do LibreOffice 5
			If ExistDir("C:\Program Files (x86)\LibreOffice 5")
				WaitRun('C:\Program Files (x86)\LibreOffice 5\program\scalc.exe "'+cDiretorio+cArquivo+'"', 1)
			
			//Senรฃo, abre o XML pelo programa padrรฃo
			Else
				ShellExecute("open", cArquivo, "", cDiretorio, 1)
			EndIf
		EndIf
		 
		QRY_AUX->(DbCloseArea())
	EndIf
	
	RestArea(aAreaX3)
	RestArea(aArea)
Return
