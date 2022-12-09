#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFAT001    บAutor  ณMicrosiga           บ Data ณ  06/14/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Relatorio de Faturamento Sintetico.                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ                   
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function MRDEST()
Private aOrd         := {}
Private CbTxt        := ""
Private cDesc1       := "Este programa gera um relat๓rio de cadastros ESTQUE."
Private cDesc2       := ""
Private cDesc3       := ""
Private cPict        := ""
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private limite       := 132
Private tamanho      := "M"
Private nomeprog     := "MRDEST"
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cPerg        := "VSUS01    "
Private titulo       := "CADASTRO DE ESTQOUE"
Private nLin         := 80
Private Cabec1       := "PRODUTO            999.999.999,99      999.999.999,99"
//                       12345678901234567890123456789012345678901234567890123456789012345678901234567890 123456789012345 1234567890 99/99/99  99/99/99
//                       12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//                                1         2         3         4         5         6         7         8         9         0         1         2         3
Private Cabec2       := ""
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private imprime      := .T.
Private wnrel        := "MRDEST"
Private cString      := "SB1"

_cOmInsc := ""

//Pesquisa as perguntas selecionadas.
ValidPerg()
Pergunte(cPerg,.F.)

wnrel := SetPrint(cString,NomeProg,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)
Titulo := "Cadastros ESTOQUE - " + DTOC(DDATABASE)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif
nTipo := If(aReturn[4]==1,15,18)
RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

Return

/*
PROCESSA O RELATORIO
*/
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
Local nOrdem 
_ADADOS := {}
_aStru  := {}

// CAMPOS DA TABELA TEMPORARIA
AADD(_aStru,{"T_NOM"    ,"C",15,0})
AADD(_aStru,{"T_CALC"   ,"N",12,2})
AADD(_aStru,{"T_SB20"   ,"N",12,2})

_cPath   := "\SPOOL\"
_cNomArq := "ESTOQUE.xls"

// CRIA A TABELA TEMPORARIA...                                                                                          
dbcreate(_cPath+_cNomArq,_aStru)
dbusearea(.T.,,_cPath+_cNomArq,"EST",.T.,.F.)

// CADASTRO DE CLIENTE
DbSelectArea("SB1")
cQuery := "SELECT * "
cQuery += "FROM "
cQuery += RetSqlName("SB1") + " SB1 "
cQuery += "WHERE "
cQuery += "SB1.D_E_L_E_T_ = ' ' "
cQuery += "ORDER BY SB1.B1_COD"

cQuery := ChangeQuery(cQuery)

TCQUERY cQuery NEW ALIAS "CQUERY"

DbSelectArea("CQUERY")
DbGoTop()
SetRegua(RecCount())

While !Eof()
	IncRegua() // Termometro de Impressao
	
	If lAbortPrint
		@nLin,00 PSAY '*** CANCELADO PELO OPERADOR ***'
		Exit
	Endif
	
	_COD     := cQuery->B1_COD          
	dData    := DDATABASE+1
	_END     := CalcEst(_COD,"01", dData  )[1]
	_MUN     := POSICIONE("SB2",1,XFILIAL("SB2")+cQuery->B1_COD+"01","B2_QATU")    

	DbSelectArea("EST")
	RecLock("EST",.T.)
	T_NOM     := _COD
	T_CALC    := _END
	T_SB20    := _MUN
	MsUnLock("EST")

    // ARRAY PARA GERAR O EXCELL DIRETO
	AADD(_aDados,{_COD,_END,_MUN})
	
	DbSelectArea("cQuery")
	DbSkip()
End

/*
LISTA O ARQUIVO GERADO !!!
*/
DbSelectArea("EST")
DbGotop()
While !Eof()
	
	If nLin > 55
		nLin   := cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
	EndIf
	//         1         2         3         4         5         6         7         8         9         0         1         2         3
	//123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
	//xxxxxxxxxxxxxxx 123456789012345678901234567890123456789012345678901234567890 999,999.99 999,999.99 999,999.99 999,999.99 999,999.99
	
	@ nlin,001 PSAY EST->T_NOM
	@ nlin,020 PSAY EST->T_CALC PICTURE "999,999,999.99"
	@ nlin,040 PSAY EST->T_SB20 PICTURE "999,999,999.99"

	nLin := nLin + 1
	DbSelectArea('EST')
	DbSkip()
End

DbSelectArea('EST')
DbCloseArea('EST')

DbSelectArea("CQUERY")
DbCloseArea("CQUERY")

// FUNCAO QUE GERA A PLANILHA
U_gerxlRG(_aDados)

Set Device To Screen

// Se impressao em disco, chama o gerenciador de impressao...
If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif
MS_FLUSH()
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRFAT001    บAutor  ณMicrosiga           บ Data ณ  06/15/05  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao Validperg para validacao das perguntas do arquivo   บฑฑ
ฑฑบ          ณ SX1                                                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP7                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ValidPerg()

_sAlias := Alias()
dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,10)
aRegs :={}

AADD(aRegs,{cPerg,"01","Do Estado                 ?","","","mv_ch1","C",02,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Ate Estado                ?","","","mv_ch2","C",02,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Else
				exit
			Endif
		Next
		MsUnlock()
	Endif
Next

DbSelectArea(_sAlias)
Return

                          
//**********************************
USER FUNCTION gerxlRG(aDados)
//**********************************
Local aCabec := {"PRODUTO","CALCEST","SB2"}
Local aDados := aDados

If !ApOleClient("MSExcel")
	MsgAlert("Microsoft Excel esta instalado nessa maquina!")
else
	DlgToExcel({ {"ARRAY", "Relatorio Cadastro Cliente", aCabec, aDados} })
EndIf
Return