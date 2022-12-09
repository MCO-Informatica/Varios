#Include "RwMake.ch"
#Include "Protheus.ch"
#Include "Topconn.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RPMS006   º Autor ³ AP6 IDE            º Data ³  03/01/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relacao de Recursos por Obra                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Lisonda                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function RPMS006()

Local cDesc1       := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2       := "de acordo com os parametros informados pelo usuario."
Local cDesc3       := "Relação de Recursos por Obra"
Local cPict        := ""
Local titulo       := "Relação de Recursos por Obra"
Local nLin         := 80
Local Cabec1       := ""
Local Cabec2       := ""
Local imprime      := .T.
Local aOrd         := {}

Private lEnd       := .F.
Private lAbortPrint:= .F.
Private CbTxt      := ""
Private limite     := 132
Private tamanho    := "M"
Private nomeprog   := "RPMS006"
Private nTipo      := 15
Private aReturn    := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey   := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "RPMS006"
Private cPerg      := "RPMS006"
Private cString    := "SZC"

Private cArqTxt   := AllTrim(GetTempPath()) + "Recur_Obra.CSV"
Private nHandle   := fCreate(cArqTxt)
Private cEOL      := "CHR(13)+CHR(10)"

If Empty(cEOL)
	cEOL := CHR(13)+CHR(10)
Else
	cEOL := Trim(cEOL)
	cEOL := &cEOL
Endif

R006PERG(cPerg)
Pergunte(cPerg,.T.)

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

Processa({|| R006REL3(Cabec1,Cabec2,Titulo,nLin) },Titulo)

If ApMsgYesNo( 'Deseja gerar planilha ?', 'GERAÇÃO' )
	If ApOleClient( 'MsExcel' )
		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open( cArqTxt )
		oExcelApp:SetVisible(.T.)
	Else
		Alert( "Microsoft Excel nao encontrado !" )
	EndIf
EndIf

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º Funcao   ³ R006REL3 º Autor ³ AP6 IDE            º Data ³  03/01/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relacao de Recursos por Obra - Impressao setprint          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Lisonda                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function R006REL3(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem
Local cQuery      := ""
Local cFilterUser := ""
Local c_Obra      := ""
Local a_Notas     := {}
Local _n1         := 1
Local _n2         := 1

cQuery :=        " SELECT SZC.ZC_FILIAL, SZC.ZC_RECURSO, AE8.AE8_DESCRI, SZC.ZC_OBRA,CTT.CTT_XCEI, CTT.CTT_DESC01, CTT.CTT_XCONT1, CTT.CTT_XLJCT1, SA1.A1_PESSOA,
cQuery += CRLF + "        SA1.A1_CGC, max(AF8.AF8_FASE) as AF8_FASE, max(AEA.AEA_DESCRI) as AEA_DESCRI, ( SELECT COUNT(*)
cQuery += CRLF + "                                                      FROM "+ RetSqlName("SZC")+" SZCX "
cQuery += CRLF + "                                                     WHERE SZCX.ZC_DATA BETWEEN '"+Dtos(Mv_Par06)+"' AND  '"+Dtos(Mv_Par07)+"'"  //inserido para filtrar por data inicial e data final - Luiz Henrique 20/08/2012      
cQuery += CRLF + "                                                       AND SZCX.ZC_OBRA     = SZC.ZC_OBRA 
cQuery += CRLF + "                                                       AND SZCX.ZC_RECURSO  = SZC.ZC_RECURSO
cQuery += CRLF + "                                                       AND SZCX.D_E_L_E_T_  = ' '
cQuery += CRLF + "                                                  ) AS QTD_DIAS
cQuery += CRLF + "    FROM "+ RetSqlName("SZC")+" SZC
cQuery += CRLF + "  INNER JOIN "+ RetSqlName("CTT")+" CTT "
cQuery += CRLF + "     ON CTT.CTT_CUSTO   = SZC.ZC_OBRA
If Mv_par05 == 1
	cQuery += CRLF + "    AND CTT.CTT_MSFIL = '"+ cFilAnt +"'"
EndIf
cQuery += CRLF + "    AND CTT.D_E_L_E_T_  = ' '
cQuery += CRLF + "   LEFT JOIN "+ RetSqlName("SA1")+" SA1 "
cQuery += CRLF + "     ON SA1.A1_FILIAL   = '"+ xFilial("SA1") +"'"
cQuery += CRLF + "    AND SA1.A1_COD      = CTT.CTT_XCONT1
cQuery += CRLF + "    AND SA1.A1_LOJA     = CTT.CTT_XLJCT1
cQuery += CRLF + "    AND SA1.D_E_L_E_T_  = ' '
cQuery += CRLF + "   LEFT JOIN "+ RetSqlName("AF8")+" AF8 "
cQuery += CRLF + "     ON AF8.AF8_FILIAL  = '"+ xFilial("AF8") +"'"
cQuery += CRLF + "    AND AF8.AF8_CODOBR  = SZC.ZC_OBRA
cQuery += CRLF + "    AND AF8.D_E_L_E_T_  = ' '
cQuery += CRLF + "   LEFT JOIN "+ RetSqlName("AEA")+" AEA "
cQuery += CRLF + "     ON AEA.AEA_FILIAL  = '"+ xFilial("AEA") +"'"
cQuery += CRLF + "    AND AEA.AEA_COD     = AF8.AF8_FASE
cQuery += CRLF + "    AND AEA.D_E_L_E_T_  = ' '
cQuery += CRLF + "   INNER JOIN "+ RetSqlName("AE8")+" AE8 "
cQuery += CRLF + "     ON AE8.AE8_FILIAL  = '"+ xFilial("AE8") +"'"
cQuery += CRLF + "    AND AE8.AE8_RECURS  = SZC.ZC_RECURSO
cQuery += CRLF + "    AND AE8.D_E_L_E_T_  = ' '
cQuery += CRLF + "  WHERE SZC.ZC_DATA BETWEEN '"+Dtos(Mv_Par06)+"' AND  '"+Dtos(Mv_Par07)+"'"//inserido para filtrar por data inicial e data final - Luiz Henrique 20/08/2012
cQuery += CRLF + "    AND SZC.ZC_OBRA     BETWEEN '"+ Mv_Par01 +"' AND  '"+ Mv_Par02 +"'"
cQuery += CRLF + "    AND SZC.ZC_RECURSO  BETWEEN '"+ Mv_Par03 +"' AND  '"+ Mv_Par04 +"'" 
cQuery += CRLF + "    AND SZC.D_E_L_E_T_  = ' '
If !empty(cFilterUser)
	cQuery += CRLF +" AND "+ cFilterUser
EndIf
cQuery += CRLF + "    GROUP BY SZC.ZC_FILIAL, SZC.ZC_RECURSO, AE8.AE8_DESCRI, SZC.ZC_OBRA, CTT.CTT_XCEI, CTT.CTT_DESC01, CTT.CTT_XCONT1, CTT.CTT_XLJCT1,
cQuery += CRLF + "          SA1.A1_CGC, SA1.A1_PESSOA
cQuery += CRLF + "    ORDER BY SZC.ZC_FILIAL, SZC.ZC_OBRA, AE8.AE8_DESCRI


memowrite('RPMS006.sql', cQuery)

nTotReg := 0
cAliasA := GetNextAlias()
cQuery  := ChangeQuery(cQuery)

DbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery), cAliasA , .F., .T.)
aEval( SZC->(DbStruct()),{|x| If(x[2] != "C", TcSetField(cAliasA, AllTrim(x[1]), x[2], x[3], x[4]),Nil)})

DbSelectArea( cAliasA )
(cAliasA)->( DbEval( { || nTotReg++ },,{ || !Eof() } ) )
(cAliasA)->( DbGoTop() )

ProcRegua(nTotReg)

While (cAliasA)->(!Eof())
	Incproc("Listando Obra")
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	If nLin > 58
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 6
	Endif
	
	If c_Obra <> (cAliasA)->ZC_OBRA
		For _n2 := _n1 to Len(a_Notas)
			@ nLin,075 PSAY a_Notas[_n2]
			nLin++
			
			cBuffer := ";"
			cBuffer += ";"
			cBuffer += ";"
			cBuffer += a_Notas[_n2]+ ";"
			FWrite(nHandle, cBuffer)
			FWrite(nHandle, CRLF)
		Next _n1
		
		nLin++
		@ nLin,000 PSAY __PrtFatLine()
		nLin++
		@ nLin,000 PSAY 'Obra..: ' + (cAliasA)->ZC_OBRA + ' - ' + (cAliasA)->CTT_DESC01 + '     CNPJ: '+ Transform( (cAliasA)->A1_CGC, Left(PicPes((cAliasA)->A1_PESSOA), At("%", PicPes((cAliasA)->A1_PESSOA))-1) )+'   CEI: ' + (cAliasA)->CTT_XCEI + '  '+ Left( (cAliasA)->AEA_DESCRI,21)
		nLin+=2
		@ nLin,010 PSAY 'RECURSO                                       QTDE DIAS          NOTA FISCAL'
		nLin++
		@ nLin,010 PSAY '------------------------------          ---------------          -------------------------'
		nLin++
		
		FWrite(nHandle, CRLF)
		cBuffer := 'Obra..: ' + (cAliasA)->ZC_OBRA + ";"
		cBuffer += (cAliasA)->CTT_DESC01           + ";"
		cBuffer += 'CNPJ: '+ Transform( (cAliasA)->A1_CGC, Left(PicPes((cAliasA)->A1_PESSOA), At("%", PicPes((cAliasA)->A1_PESSOA))-1) )+ ";"
		cBuffer += 'CEI: ' + (cAliasA)->CTT_XCEI   + ";"
		cBuffer += Left( (cAliasA)->AEA_DESCRI,21)
		FWrite(nHandle, cBuffer)
		FWrite(nHandle, CRLF)
		
		cBuffer := ";"
		cBuffer += 'RECURSO' + ";"
		cBuffer += 'QTDE DIAS' + ";"
		cBuffer += 'NOTA FISCAL' + ";"
		FWrite(nHandle, cBuffer)
		FWrite(nHandle, CRLF)
		
		a_Notas := R006NOTA()
		c_Obra  := (cAliasA)->ZC_OBRA
		_n1     := 1
		
	EndIf
	
//	@ nLin,010 PSAY Iif( Empty( (cAliasA)->AE8_DESCRI), "RECURSO : "+(cAliasA)->ZC_RECURSO, (cAliasA)->AE8_DESCRI)
	@ nLin,010 PSAY Iif( Empty( (cAliasA)->AE8_DESCRI), " "+(cAliasA)->ZC_RECURSO, (cAliasA)->AE8_DESCRI)
	@ nLin,056 PSAY Transform( (cAliasA)->QTD_DIAS, "@E 99999999")
	@ nLin,075 PSAY Iif( Len(a_Notas) > 0 .And. _n1 <= Len(a_Notas) , a_Notas[_n1], "")
	nLin++
	_n1++
	
	cBuffer := ";"
	cBuffer += Iif( Empty( (cAliasA)->AE8_DESCRI), "RECURSO : "+(cAliasA)->ZC_RECURSO, (cAliasA)->AE8_DESCRI) + ";"
	cBuffer += Transform( (cAliasA)->QTD_DIAS, "@E 99999999")+ ";"
	cBuffer += Iif( Len(a_Notas) > 0 .And. _n1 <= Len(a_Notas) , a_Notas[_n1], "")+ ";"
	FWrite(nHandle, cBuffer)
	FWrite(nHandle, CRLF)
	
	(cAliasA)->(DbSkip())
End-While
(cAliasA)->(DbCloseArea())

For _n2 := _n1 to Len(a_Notas)
	@ nLin,075 PSAY a_Notas[_n2]
	nLin++
	
	cBuffer := ";"
	cBuffer += ";"
	cBuffer += ";"
	cBuffer += a_Notas[_n2]+ ";"
	FWrite(nHandle, cBuffer)
	FWrite(nHandle, CRLF)
Next _n1


SET DEVICE TO SCREEN

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

fClose(nHandle)

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º Funcao   ³ R006NOTA º Autor ³ AP6 IDE            º Data ³  03/01/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relacao de Recursos por Obra - Notas Fiscais da Obra       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Lisonda                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function R006NOTA()

Local a_Ret := {}

cQuery :=        " SELECT SD2.D2_CCUSTO, SD2.D2_EMISSAO, SD2.D2_DOC, SD2.D2_SERIE"
cQuery += CRLF + "   FROM "+ RetSqlName("SD2")+" SD2 "
cQuery += CRLF + "  INNER JOIN "+ RetSqlName("SF4")+" SF4 "
cQuery += CRLF + "     ON SF4.F4_CODIGO   = SD2.D2_TES"
cQuery += CRLF + "    AND SF4.F4_DUPLIC   = 'S'"
cQuery += CRLF + "    AND SF4.D_E_L_E_T_  = ' '"
cQuery += CRLF + "  WHERE SD2.D2_EMISSAO BETWEEN '"+Dtos(Mv_Par06)+"' AND  '"+Dtos(Mv_Par07)+"'"  //inserido para filtrar por data inicial e data final - Luiz Henrique 20/08/2012
cQuery += CRLF + "    AND SD2.D2_CCUSTO   = '"+(cAliasA)->ZC_OBRA+"'"
cQuery += CRLF + "    AND SD2.D_E_L_E_T_  = ' '"
cQuery += CRLF + "  GROUP BY SD2.D2_CCUSTO, SD2.D2_EMISSAO, SD2.D2_DOC, SD2.D2_SERIE"

cAliasB := GetNextAlias()
cQuery  := ChangeQuery(cQuery)

DbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery), cAliasB , .F., .T.)
aEval( SD2->(DbStruct()),{|x| If(x[2] != "C", TcSetField(cAliasB, AllTrim(x[1]), x[2], x[3], x[4]),Nil)})

While (cAliasB)->(!Eof())
	aAdd(a_Ret, (cAliasB)->D2_DOC + '-'+(cAliasB)->D2_SERIE + ' em ' + dtoc((cAliasB)->D2_EMISSAO) )
	(cAliasB)->(DbSkip())
End-While
(cAliasB)->(DbCloseArea())

Return a_Ret

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º Funcao   ³ R006PERG º Autor ³ AP6 IDE            º Data ³  03/01/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Cria parametros de perguntas                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Lisonda                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function R006PERG(cPerg)

Local aAreaAtu	:= GetArea()
Local aAreaSX1	:= SX1->( GetArea() )


PutSx1(	cPerg, "01", "Obra Inicial           ? ", "" , "", "Mv_ch1", TAMSX3( "CTT_CUSTO"  )[3], TAMSX3( "CTT_CUSTO"  )[1], TAMSX3( "CTT_CUSTO"  )[2], 0,"G","","CTT","","N","Mv_par01",   "",   "",   "","",   "",   "",   "",     "","",     "",     "","","","","","",{"Informe a obra inicial           ",""          },{""},{""},"")
PutSx1(	cPerg, "02", "Obra Final             ? ", "" , "", "Mv_ch2", TAMSX3( "CTT_CUSTO"  )[3], TAMSX3( "CTT_CUSTO"  )[1], TAMSX3( "CTT_CUSTO"  )[2], 0,"G","","CTT","","N","Mv_par02",   "",   "",   "","",   "",   "",   "",     "","",     "",     "","","","","","",{"Informe a obra final             ",""          },{""},{""},"")
PutSx1(	cPerg, "03", "Recurso Inciial        ? ", "" , "", "Mv_ch3", TAMSX3( "AE8_RECURS" )[3], TAMSX3( "AE8_RECURS" )[1], TAMSX3( "AE8_RECURS" )[2], 0,"G","","AE8","","N","Mv_par03",   "",   "",   "","",   "",   "",   "",     "","",     "",     "","","","","","",{"Informe o recurso inicial        ",""          },{""},{""},"")
PutSx1(	cPerg, "04", "Recurso Final          ? ", "" , "", "Mv_ch4", TAMSX3( "AE8_RECURS" )[3], TAMSX3( "AE8_RECURS" )[1], TAMSX3( "AE8_RECURS" )[2], 0,"G","","AE8","","N","Mv_par04",   "",   "",   "","",   "",   "",   "",     "","",     "",     "","","","","","",{"Informe o recurso final          ",""          },{""},{""},"")
PutSx1(	cPerg, "05", "Somente Filial Corrente? ", "" , "", "Mv_ch5","N"                        ,                       1  ,                         0 , 2,"C","",   "","","N","Mv_par05","Sim",   "",   "","","Não",   "",   "",     "","",     "",     "","","","","","",{"Somente a filial corrente        ",""          },{""},{""},"")
PutSx1(	cPerg, "06", "Data Inciial           ? ", "" , "", "Mv_ch6", TAMSX3( "ZC_DATA" )[3], TAMSX3( "ZC_DATA"  )[1], TAMSX3( "ZC_DATA"  )[2], 0,"G","","","","D","Mv_par06",   "",   "",   "","",   "",   "",   "",     "","",     "",     "","","","","","",{"Informe a data inicial        ",""          },{""},{""},"")    // colocado para filtrar por data inicial e data final - Luiz Henrique 20/08/2012
PutSx1(	cPerg, "07", "Data Final             ? ", "" , "", "Mv_ch7", TAMSX3( "ZC_DATA"  )[3], TAMSX3( "ZC_DATA"  )[1], TAMSX3( "ZC_DATA"  )[2], 0,"G","","","","D","Mv_par07",   "",   "",   "","",   "",   "",   "",     "","",     "",     "","","","","","",{"Informe a data final          ",""          },{""},{""},"")   // inserido para filtrar por data inicial e data final - Luiz Henrique 20/08/2012

RestArea( aAreaSX1 )
RestArea( aAreaAtu )

Return(cPerg) 