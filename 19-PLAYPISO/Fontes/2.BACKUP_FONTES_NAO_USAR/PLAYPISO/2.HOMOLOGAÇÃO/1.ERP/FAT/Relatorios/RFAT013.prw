#Include "RwMake.ch"
#Include "Protheus.ch"
#Include "Topconn.ch"                                                      

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRFAT013   บ Autor ณ Bruno Parreira     บ Data ณ  01/12/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Relatorio de retorno de mercadoria                         บฑฑ
ฑฑฬออออออออออุออออออออออออออออหออออออออออหออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAlteracoesณ Actual Trend   บ 19/01/12 บ Melhoria na performance        บฑฑ
ฑฑฬออออออออออุออออออออออออออออสออออออออออสออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Lisonda Engenharia e Construcoes Ltda.          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function RFAT013()

Local cDesc1       := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2       := "de acordo com os parametros informados pelo usuario."
Local cDesc3       := "Retorno de Material"
Local cPict        := ""
Local titulo       := "Retorno de Material"
Local nLin         := 80
Local Cabec1       := "                                                                                                                                                     |       N O T A   D E   O R I G E M       |"
Local Cabec2       := "NOTA       SERIE  ITEM  PRODUTO          DESCRICAO                               UM          QTDE     VLR. UNITARIO      VLR. TOTAL   TES   EMISSAO  | NOTA       SERIE  ITEM   TIPO           |"
Local imprime      := .T.
Local aOrd         := {}
Local lPerg        := .T.

Private lEnd       := .F.
Private lAbortPrint:= .F.
Private CbTxt      := ""
Private limite     := 220
Private tamanho    := "G"
Private nomeprog   := "RFAT013"
Private nTipo      := 15
Private aReturn    := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey   := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "RFAT013"
Private cPerg      := "RFAT013"
Private cString    := "SF1"    

DbSelectArea("CTT")
CTT->( DbSetOrder(1) )

DbSelectArea("SF1")
SF1->( DbSetOrder(1) )

R013PERG(cPerg)
lPerg := Pergunte(cPerg)

If lPerg == .T.                 
	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)
	
	If nLastKey == 27
		Return
	Endif
	
	SetDefault(aReturn,cString)
	
	If nLastKey == 27
		Return
	Endif
	
	nTipo := If(aReturn[4]==1,15,18)
	
	Processa({|| R013PRINT(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Endif

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณR013PRINT บ Autor ณ Bruno Parreira     บ Data ณ  01/12/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Busca registros no banco e gera relatorio                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Lisonda Engenharia e Construcoes Ltda.          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function R013PRINT(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem
Local cQuery  := ""
Local cNumObra:= ""
Local nTotObra:= 0
Local nTotReg := 0
Local nContar := 0//1  2   3   4   5    6   7   8   9   10  11   12  13  14  15  16  17
Local aCol    := {000,012,018,024,041,081,086,099,117,134,140,149,151,163,169,176,191}

cQuery :=        "  SELECT SD1.D1_FILIAL, SD1.D1_CC, SD1.D1_ITEM, SD1.D1_COD, SB1.B1_DESC, SD1.D1_QUANT, SD1.D1_UM, SD1.D1_VUNIT, SD1.D1_TOTAL, SD1.D1_TES, "                    
cQuery += CRLF + "         SD1.D1_EMISSAO, SD1.D1_NFORI, SD1.D1_SERIORI, SD1.D1_ITEMORI, SD1.D1_TIPO, SD1.D1_DOC, SD1.D1_SERIE "
cQuery += CRLF + "    FROM "+RetSqlName("SD1")+" SD1, "+RetSqlName("SB1")+" SB1 "
cQuery += CRLF + "   WHERE SD1.D1_FILIAL   = '"+xFilial("SD1")+"'"
cQuery += CRLF + "     AND SD1.D1_CC       BETWEEN '"+ Mv_par01 +"' AND '"+ Mv_par02 +"'" 
cQuery += CRLF + "     AND SD1.D1_COD      BETWEEN '"+ Mv_Par06 +"' AND '"+ Mv_Par07 +"'"   // inserido para trazer o cod do produto - Luiz Henrique 20/08/2012         
cQuery += CRLF + "     AND SD1.D1_DOC      BETWEEN '"+ Mv_Par08 +"' AND '"+ Mv_Par09 +"'"   // inserido para trazer a nota fiscal    - Luiz Henrique 20/08/2012 
cQuery += CRLF + "     AND SD1.D1_TIPO     IN ('B','D')
cQuery += CRLF + "     AND SD1.D1_EMISSAO  BETWEEN '"+DtoS(Mv_Par03)+"' AND '"+DtoS(Mv_Par04)+"' "  
cQuery += CRLF + "     AND SD1.D_E_L_E_T_  = ' ' "
cQuery += CRLF + "     AND SB1.B1_FILIAL   = '"+xFilial("SB1")+"'"
cQuery += CRLF + "     AND SB1.B1_COD      = SD1.D1_COD "
If Mv_Par05 == 1
	cQuery += CRLF + " AND (B1_TIPO <> 'AT' OR B1_TIPO <> 'MQ') "
Else
	cQuery += CRLF + " AND (B1_TIPO  = 'AT' OR B1_TIPO  = 'MQ') "
EndIf
cQuery += CRLF + "     AND SB1.D_E_L_E_T_  = ' ' "
cQuery += CRLF + "   ORDER BY SD1.D1_FILIAL, SD1.D1_CC, SD1.D1_DOC, SD1.D1_ITEM


cAliasA := GetNextAlias()
cQuery  := ChangeQuery(cQuery)

DbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery), cAliasA , .F., .T.)
aEval( SD1->(DbStruct()),{|x| If(x[2] != "C", TcSetField(cAliasA, AllTrim(x[1]), x[2], x[3], x[4]),Nil)})
aEval( SB1->(DbStruct()),{|x| If(x[2] != "C", TcSetField(cAliasA, AllTrim(x[1]), x[2], x[3], x[4]),Nil)})

DbSelectArea( cAliasA )
(cAliasA)->( DbEval( { || nTotReg++ },,{ || !Eof() } ) )
(cAliasA)->( DbGoTop() )

If (cAliasA)->( !Eof() )
	ProcRegua( nTotReg )
	While (cAliasA)->( !Eof() )
		IncProc("Gerando relatorio, regs : "+StrZero(++nContar,6)+" de "+StrZero(nTotReg,6))
		
		If lAbortPrint
			@ nLin,000 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif
		
		If nLin > 58
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 9
		Endif
		
		If cNumObra <> (cAliasA)->D1_CC
			If nTotObra <> 0
				@ nLin,000 PSay __PrtThinLine()
				nLin++
				@ nLin, aCol[1]  PSay "TOTAL DA OBRA: "+ cNumObra
				@ nLin, aCol[9]  PSay Transform( nTotObra, PesqPict("SD1","D1_TOTAL") )
				nLin += 3
				
				nTotObra := 0
			EndIf
			
			@ nLin, 000 PSay (cAliasA)->D1_CC + "   -   "+ GetAdvFVal("CTT","CTT_DESC01",xFilial("CTT")+(cAliasA)->D1_CC,1,"Nใo Encontrado")
			nLin+= 2
			
			cNumObra := (cAliasA)->D1_CC
		EndIf
		
		@ nLin, aCol[1]  PSay (cAliasA)->D1_DOC
		@ nLin, aCol[2]  PSay (cAliasA)->D1_SERIE
		@ nLin, aCol[3]  PSay (cAliasA)->D1_ITEM
		@ nLin, aCol[4]  PSay  Left((cAliasA)->D1_COD,15)
		@ nLin, aCol[5]  PSay  Left((cAliasA)->B1_DESC,38) 
	  	@ nLin, aCol[6]  PSay (cAliasA)->D1_UM
		@ nLin, aCol[7]  PSay  Transform( (cAliasA)->D1_QUANT, PesqPict("SD1","D1_QUANT") )
		@ nLin, aCol[8]  PSay  Transform( (cAliasA)->D1_VUNIT, PesqPict("SD1","D1_VUNIT") )
		@ nLin, aCol[9]  PSay  Transform( (cAliasA)->D1_TOTAL, PesqPict("SD1","D1_TOTAL") )
		@ nLin, aCol[10] PSay (cAliasA)->D1_TES
		@ nLin, aCol[11] PSay  DtoC((cAliasA)->D1_EMISSAO)
		@ nLin, aCol[12] PSay  "|""
		@ nLin, aCol[13] PSay (cAliasA)->D1_NFORI
		@ nLin, aCol[14] PSay (cAliasA)->D1_SERIORI
		@ nLin, aCol[15] PSay (cAliasA)->D1_ITEMORI
		@ nLin, aCol[16] PSay Iif( (cAliasA)->D1_TIPO == "B", "BENEFICIAMENTO", Iif( (cAliasA)->D1_TIPO == "D", "DEVOLUCAO", (cAliasA)->D1_TIPO))
		@ nLin, aCol[17] PSay  "|""
		nLin++
		
		nTotObra +=(cAliasA)->D1_TOTAL
		
		(cAliasA)->( DbSkip() )
	End-While
	
	If nTotObra <> 0
		@ nLin,000 PSay __PrtThinLine()
		nLin++
		@ nLin, aCol[1]  PSay "TOTAL DA OBRA: "+ cNumObra
		@ nLin, aCol[9]  PSay Transform( nTotObra, PesqPict("SD1","D1_TOTAL") )
		nLin += 3
		
		nTotObra := 0
	EndIf
	
	Roda(cbcont,cbtxt,tamanho)
EndIf

(cAliasA)->( DbCloseArea() )

SET DEVICE TO SCREEN
If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณR013PERG  บ Autor ณ Bruno Parreira     บ Data ณ  22/09/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Cria parametros da rotina                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Lisonda Engenharia e Construcoes Ltda.          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function R013PERG(cPerg)

Local aAreaAtu	:= GetArea()
Local aAreaSX1	:= SX1->( GetArea() )

PutSx1(	cPerg, "01", "C๓digo da Obra inicial ? ", "" , "", "Mv_ch1", TAMSX3( "CTT_CUSTO"  )[3], TAMSX3( "CTT_CUSTO"  )[1], TAMSX3( "CTT_CUSTO"  )[2], 0,"G","","CTT","","N","Mv_par01",        "","","","",           "","","", "","","", "","","","","","",{"Digite o codigo inicial da Obra ",""},{""},{""},"")
PutSx1(	cPerg, "02", "C๓digo da Obra final   ? ", "" , "", "Mv_ch2", TAMSX3( "CTT_CUSTO"  )[3], TAMSX3( "CTT_CUSTO"  )[1], TAMSX3( "CTT_CUSTO"  )[2], 0,"G","","CTT","","N","Mv_par02",        "","","","",           "","","", "","","", "","","","","","",{"Digite o codigo final da Obra   ",""},{""},{""},"")
PutSx1(	cPerg, "03", "Data inicial           ? ", "" , "", "Mv_ch3", TAMSX3( "D1_EMISSAO" )[3], TAMSX3( "D1_EMISSAO" )[1], TAMSX3( "D1_EMISSAO" )[2], 0,"G","",   "","","N","Mv_par03",        "","","","",           "","","", "","","", "","","","","","",{"Digite a data inicial           ",""},{""},{""},"")
PutSx1(	cPerg, "04", "Data final             ? ", "" , "", "Mv_ch4", TAMSX3( "D1_EMISSAO" )[3], TAMSX3( "D1_EMISSAO" )[1], TAMSX3( "D1_EMISSAO" )[2], 0,"G","",   "","","N","Mv_par04",        "","","","",           "","","", "","","", "","","","","","",{"Digite a data final             ",""},{""},{""},"")
PutSx1(	cPerg, "05", "Tipo de Retorno        ? ", "" , "", "Mv_ch5","N"                        ,                       1  ,                         0 , 2,"C","",   "","","N","Mv_par05","Material","","","","Equipamento","","", "","","", "","","","","","",{"Selecione o tipo de retorno   ",""},{""},{""},"")
PutSx1(	cPerg, "06", "De Produto             ? ", "" , "", "Mv_ch6", TAMSX3( "D1_COD" )    [3], TAMSX3( "D1_COD" )    [1], TAMSX3( "D1_COD" )    [2], 0,"G","","SB1","","N","Mv_par06",        "","","","",           "","","", "","","", "","","","","","",{"Digite o cod inicial do produto ",""},{""},{""},"")    // inserido - Luiz Henrique 20/08/2012
PutSx1(	cPerg, "07", "Ate Produto            ? ", "" , "", "Mv_ch7", TAMSX3( "D1_COD" )    [3], TAMSX3( "D1_COD" )    [1], TAMSX3( "D1_COD" )    [2], 0,"G","","SB1","","N","Mv_par07",        "","","","",           "","","", "","","", "","","","","","",{"Digite o cod final do produto   ",""},{""},{""},"")    // inserido - Luiz Henrique 20/08/2012
PutSx1(	cPerg, "08", "De Nota Fiscal         ? ", "" , "", "Mv_ch8", TAMSX3( "D1_DOC" )    [3], TAMSX3( "D1_DOC" )    [1], TAMSX3( "D1_DOC" )    [2], 0,"G","",   "","","N","Mv_par08",        "","","","",           "","","", "","","", "","","","","","",{"Digite a nota fiscal inicial   ",""},{""},{""},"")     // inserido - Luiz Henrique 20/08/2012
PutSx1(	cPerg, "09", "Ate Nota Fiscal        ? ", "" , "", "Mv_ch9", TAMSX3( "D1_DOC" )    [3], TAMSX3( "D1_DOC" )    [1], TAMSX3( "D1_DOC" )    [2], 0,"G","",   "","","N","Mv_par09",        "","","","",           "","","", "","","", "","","","","","",{"Digite a nota fiscal final     ",""},{""},{""},"")     // inserido - Luiz Henrique 20/08/2012

RestArea( aAreaSX1 )
RestArea( aAreaAtu )

Return(cPerg)