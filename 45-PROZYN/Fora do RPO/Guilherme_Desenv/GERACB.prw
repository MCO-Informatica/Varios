#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "tbiconn.ch"
#INCLUDE "tbicode.ch"
#DEFINE  ENTER CHR(13)+CHR(10)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ   Geracao Combustivel Alelo                      24/09/2017บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ   Geracao Combustivel Alelo                                บฑฑ
ฑฑบ                                                                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿  */
User Function GERACB()

cPerg 	:= Padr("ARQUCB",10)

Private lMsErroAuto := .F.

ValidPerg()
Pergunte(cPerg,.F.)

cCadastro     := " "
aSays         := {}
aButtons      := {}
_nOpc         := 0

AADD(aSays,"Gera็ใo do arquivo Carga     ")
AADD(aSays,"do Combustivel   - Alelo ")
AADD(aSays,"")
AADD(aButtons,{5,.T.,{|| Pergunte(cPerg,.T.)	}})
AADD(aButtons,{1,.T.,{|| (_nOpc := 1, FechaBatch())	}})
AADD(aButtons,{2,.T.,{|| FechaBatch() 		  	}})

FormBatch(cCadastro, aSays, aButtons)

If _nOpc = 1
	Processa({|| ARQUCB()},cCadastro)
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGERACB    บAutor  ณMicrosiga           บ Data ณ  10/29/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ARQUCB()


Local aDados := {}
Local cType := OemToAnsi("Selecione o Diretorio")
Local cCam  := " "

cFilDe  	:= mv_par01
cFilAte     := mv_par02
cCcDe    	:= mv_par03
cCcAte 	    := mv_par04
cMatDe		:= mv_par05
cMatAte		:= mv_par06
cPerioDe    := mv_Par07
cPerioAte   := mv_Par08


cQuery := "SELECT RA_NOME                    AS NOME, " + ENTER
cQuery += "       RA_CIC                     AS CPF, "  + ENTER
cQuery += "       SUBSTR(RA_NASC, 7, 2)||'/'||SUBSTR(RA_NASC, 5, 2)||'/'||SUBSTR(RA_NASC, 1, 4) AS NASCIMENTO, " + ENTER
cQuery += "       RA_SEXO                    AS SEXO, " + ENTER
cQuery += "       R0_VALCAL                  AS VALOR, "+ ENTER
cQuery += "       'FI'                       AS TPLOCENTRE, " + ENTER
cQuery += "       SUBSTR(RGC_CPFCGC,11,4)  	 AS LOCENTRE, "  + ENTER
cQuery += "       R0_MAT                     AS MATRICULA, " + ENTER
cQuery += "       RGC_XCONVC                 AS CONTRATO " + ENTER
cQuery += "FROM   SR0010 SR0 " + ENTER
cQuery += "       INNER JOIN SRA010 SRA " + ENTER
cQuery += "               ON SRA.D_E_L_E_T_ = ' ' " + ENTER
cQuery += "                  AND R0_FILIAL = RA_FILIAL " + ENTER
cQuery += "                  AND R0_MAT = RA_MAT " + ENTER
cQuery += "                  AND RA_SITFOLH <> 'D' " + ENTER
cQuery += "        			 AND RA_CC BETWEEN '"+cCcDe+"' AND '"+cCcAte+"' " + ENTER
cQuery += "       INNER JOIN RGC010 RGC " + ENTER
cQuery += "               ON RGC.D_E_L_E_T_ = ' ' " + ENTER
cQuery += "                  AND RGC_FILIAL = '"+XFILIAL("RGC")+"'" + ENTER
cQuery += "                  AND RGC_KEYLOC = RA_LOCBNF " + ENTER
cQuery += "       INNER JOIN RFO010 RFO " + ENTER
cQuery += "               ON RFO.D_E_L_E_T_ = ' ' " + ENTER
cQuery += "                  AND R0_TPVALE = RFO_TPVALE " + ENTER
cQuery += "                  AND R0_CODIGO = RFO_CODIGO " + ENTER
cQuery += "                  AND RFO_TPBEN = '03' " + ENTER
cQuery += "WHERE  SR0.D_E_L_E_T_ = ' ' " + ENTER
cQuery += "       AND R0_TPVALE = '1'" + ENTER
cQuery += "	      AND R0_VALCAL > 0" + ENTER
cQuery += "       AND R0_PERIOD BETWEEN '"+cPerioDe+"' AND '"+cPerioAte+" '" +ENTER
cQuery += "       AND R0_FILIAL BETWEEN '"+cFilDe+"' AND '"+cFilAte+"' " + ENTER
cQuery += "       AND R0_MAT BETWEEN '"+cMatDe+"' AND '"+cMatAte+"' " + ENTER

dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"SQL",.F.,.T.)
DbSelectArea("SQL")
SQL->(DbGoTop())

If !SQL->(Eof())
	
	DO While !SQL->(Eof())
		
		//Preenche Regra de Processando
		IncProc("Processando ... "+ SQL->NOME)
		
		Aadd(aDados,{Padr("%",02),;
		Padr(SQL->NOME ,50),;
		Padr(SQL->CPF ,20),;
		Padr(SQL->NASCIMENTO,10),;
		Padr(SQL->SEXO ,02),;
		Padr(SQL->VALOR ,17),;
		Padr(SQL->TPLOCENTRE ,02),;
		Padr(SQL->LOCENTRE ,09),;
		Padr(SQL->MATRICULA ,06),;
		Padr(SQL->CONTRATO ,11),;
		Padr("%" ,02)})
		
		SQL->( dbSkip())
		
	EndDo
	
	IncProc("Gravando arquivo...")
	
	//monta estrutura
	astru := {}
	Aadd(aStru,{"FIXO","C",02,0})
	Aadd(aStru,{"NOME","C",40,0})
	Aadd(aStru,{"CPF","C",20,0})
	Aadd(aStru,{"NASCIMENTO","C",20,0})
	Aadd(aStru,{"SEXO","C",15,0})
	Aadd(aStru,{"VALOR","C",17,0})
	Aadd(aStru,{"TPLOCENTRE","C",22,0})
	Aadd(aStru,{"LOCENTRE","C",15,0})
	Aadd(aStru,{"MATRICULA","C",10,0})
	Aadd(aStru,{"FIXOA","C",02,0})
	
	/*
	Aadd(aStru,{"FIXO","C",02,0})
	Aadd(aStru,{"NOME","C",50,0})
	Aadd(aStru,{"CPF","C",20,0})
	Aadd(aStru,{"NASCIMENTO","C",10,0})
	Aadd(aStru,{"SEXO","C",02,0})
	Aadd(aStru,{"VALOR","C",17,0})
	Aadd(aStru,{"TPLOCENTRE","C",02,0})
	Aadd(aStru,{"LOCENTRE","C",09,0})
	Aadd(aStru,{"MATRICULA","C",06,0})
	Aadd(aStru,{"FIXOA","C",02,0})
	*/
	//cria tabela
	cArquivo := CriaTrab(aStru, .T.)
//	cArquivo := "GERACB.dbf"
//	dbCreate(cArquivo,aStru)
	
	cAlias := "TMP2"
	//abertura
	dbUseArea(.T.,,cArquivo,cAlias,.F.,.F.)
	
	If Select("SQL") > 0
		// TEXTO CONTRATO
		RecLock("TMP2",.T.)
		FIXO       := " "
		NOME       := "CONTRATO"
		CPF        := " "
		NASCIMENTO := " "
		SEXO       := " "
		VALOR      := " "
		TPLOCENTRE := " "
		LOCENTRE   := " "
		MATRICULA  := " "
		FIXOA      := " "
		MsUnlock()
		
		// NUMERO CONTRATO
		RecLock("TMP2",.T.)
		FIXO       := "%"
		NOME       := aDados[1][10]
		CPF        := "%"
		NASCIMENTO := " "
		SEXO       := " "
		VALOR      := " "
		TPLOCENTRE := " "
		LOCENTRE   := " "
		MATRICULA  := " "
		FIXOA      := " "
		MsUnlock()
		
		
		// TEXTO 	NOME DO USUมRIO	CPF	DATA DE NASCIMENTO	CำDIGO DE SEXO	VALOR	TIPO DE LOCAL ENTREGA	LOCAL DE ENTREGA	MATRอCULA
		RecLock("TMP2",.T.)
		FIXO       := " "
		NOME       := "NOME DO USUมRIO"
		CPF        := "CPF"
		NASCIMENTO := "DATA DE NASCIMENTO"
		SEXO       := "CำDIGO DE SEXO"
		VALOR      := "VALOR"
		TPLOCENTRE := "TIPO DE LOCAL ENTREGA"
		LOCENTRE   := "LOCAL ENTREGA"
		MATRICULA  := "MATRอCULA"
		FIXOA      := " "
		MsUnlock()
		
	Endif
	
	For nx:= 1 to len(aDados)
		RecLock("TMP2",.T.)
		
		FIXO       := aDados[nx][1]
		NOME       := aDados[nx][2]
		CPF        := aDados[nx][3]
		NASCIMENTO := aDados[nx][4]
		SEXO       := aDados[nx][5]
		VALOR      := aDados[nx][6]
		TPLOCENTRE := aDados[nx][7]
		LOCENTRE   := aDados[nx][8]
		MATRICULA  := aDados[nx][9]
		FIXOA      := aDados[nx][11]
		
		MsUnlock()
		
	Next
	
	cNomeA:=dtoc(ddatabase)
	cNomeArq:= "CB"+'_'+substring (cNomeA, 4,2) +'_'+substring (cNomeA, 7,4)
	//cCam  := cGetFile(cType, OemToAnsi("Selecione o Diretorio "), 0,, .F., 128+16)
	_cArq := U_Tab3Excel("TMP2",,cCam,cNomeArq)
	
	FCLOSE(cArquivo)
	
	FERASE(cArquivo)

	SQL->(DbCloseArea())
	TMP2->(DbCloseArea())
else
	SQL->(DbCloseArea())
	MSGSTOP("Nใo existe registros, verifique os cadastros.")
Endif



Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGERACB    บAutor  ณMicrosiga           บ Data ณ  10/29/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

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
Aadd(aRegs,{cPerg,"07","Periodo de?    ", "Periodo   ?",		"Periodo   ?",		"mv_ch7","C",06,0,0,"G" ,"","mv_par07","","","","","","","","","","","","","","","","","","",""	,""	,""	,""	,"","","SR0",""})
Aadd(aRegs,{cPerg,"08","Periodo Ate?   ", "Periodo   ?",		"Periodo   ?",		"mv_ch8","C",06,0,0,"G" ,"","mv_par08","","","","","","","","","","","","","","","","","","","",""	,""	,""	,"","","SR0",""})


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
