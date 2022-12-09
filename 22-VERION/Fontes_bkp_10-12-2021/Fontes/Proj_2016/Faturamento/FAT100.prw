#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFAT100    บAutor  ณMicrosiga           บ Data ณ  14/12/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Relatorio de Produtos Bloqueados                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function FAT100()
Private aOrd         := {}
Private CbTxt        := ""
Private cDesc1       := "Este programa gera um relat๓rio de produtos que"
Private cDesc2       := "estใo bloqueados para analise e ajuste."
Private cDesc3       := ""
Private cPict        := ""
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private limite       := 132
Private tamanho      := "M"
Private nomeprog     := "FAT001"
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cPerg        := "FAT001    "
Private titulo       := "Produtos Bloqueados"
Private nLin         := 80
Private Cabec1       := "Codigo            Descricao                          Preco   Saldo "
Private Cabec2       := "==================================================================="
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private imprime      := .T.
Private wnrel        := "FAT100"
Private cString      := "SB1"

_cOmInsc := ""
//Pesquisa as perguntas selecionadas.
ValidPerg()
Pergunte(cPerg,.F.)

wnrel := SetPrint(cString,NomeProg,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)
Titulo := "Produtos Bloqueados - Data Ref.:  " + DTOC(DDATABASE)

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
_aStru := {}
AADD(_aStru,{"T_produto" ,"C",15,0})//Codigo do Produto
AADD(_aStru,{"T_desc"    ,"C",60,0})//Descricao do Produto
AADD(_aStru,{"T_preco"   ,"N",15,5})//preco
AADD(_aStru,{"T_saldo"   ,"N",15,0})//saldo em estoque
AADD(_aStru,{"T_moedas"  ,"C",01,0})//moedas
AADD(_aStru,{"T_IPI"     ,"N",15,2})//moedas

_cPath   := "\SPOOL\"
_cNomArq := "PRDBLOQ.xls"

dbcreate(_cPath+_cNomArq,_aStru)
dbusearea(.T.,,_cPath+_cNomArq,"NFS",.T.,.F.)

DbSelectArea("SB1")
DbSetOrder(1)
If !Empty(mv_par01)
	DbSeek(XFILIAL("SB1")+mv_par01)
	SetRegua(RecCount())
Else
	DbGoTop()
	SetRegua(RecCount())
Endif

While !Eof()
	IncRegua() // Termometro de Impressao
	
	If lAbortPrint
		@nLin,00 PSAY '*** CANCELADO PELO OPERADOR ***'
		Exit
	Endif
	
	If SB1->B1_COD < Mv_par01 .Or. SB1->B1_COD > Mv_par02
		DbSkip()
		Loop
	EndIf
	
	If SB1->B1_MSBLQL == "2"
		DbSkip()
		Loop
	EndIf
	
	_WAA      := 0
	_NSLDATU  := 0
	_NRESERV  := 0
	_NEMPENH  := 0
	_NCOMPRA  := 0
	_WDATA    := DDATABASE
	_WPROD    := SB1->B1_COD
	_WDESC    := SB1->B1_DESC
	_WPRECO   := SB1->B1_VERVEN
	_WTIPICMS := SB1->B1_TIPICMS
	_WMOEDA   := SB1->B1_TPMOEDA
	_WFATOR   := SB1->B1_FATOR

    IF ALLTRIM(SB1->B1_GRUPO) == "Y-" .OR.  ALLTRIM(SB1->B1_GRUPO) == "VB"
 		_WPRECO1  := IIF(SB1->B1_VERCOM > 0,SB1->B1_VERCOM,IIF(SB1->B1_CUSTD > 0,SB1->B1_CUSTD,IIF(SB1->B1_UPRC > 0,SB1->B1_UPRC,0)))
    ELSE
	    _WPRECO1  := SB1->B1_VERCOM 
	ENDIF    

	_WGRUPO   := SB1->B1_GRUPO
	_WIPI     := SB1->B1_IPI
	
	dbSelectArea("SM2")
	dbSeek(_WDATA)
	_WDOLAR := SM2->M2_MOEDA2
	_WEURO  := SM2->M2_MOEDA4
	
	dbSelectArea("SBM")
	dbSeek(xFilial()+_WGRUPO)
	
	IF _WFATOR == 0
		_WFATOR := SBM->BM_FATOR
	Endif
	
	If _WMOEDA == space(1)
		_WMOEDA := SBM->BM_MOEDA
		IF _WMOEDA == "D"
			_WAA1 := Round( (_WPRECO1 * _WFATOR) ,2)
			_WAA := Round( ((_WAA1 * _WDOLAR)) * 1.035 ,2)
		ELSEIF _WMOEDA == "E"
			_WAA1 := Round( (_WPRECO1 * _WFATOR) ,2)
			_WAA := Round( ((_WAA1 * _WEURO)) * 1.035 ,2)
		ELSE
			_WAA1 := Round( (_WPRECO1 * _WFATOR) ,2)
			_WAA := Round( (_WAA1) * 1.035 ,2)
		ENDIF
	ELSE
		IF _WMOEDA == "D"
			_WAA := Round( (((_WPRECO1 * _WFATOR) * _WDOLAR)) * 1.035 ,2)
		ELSEIF _WMOEDA == "E"
			_WAA := Round( (((_WPRECO1 * _WFATOR) * _WEURO )) * 1.035 ,2)
		ELSE
			_WAA := Round( (((_WPRECO1 * _WFATOR) )) * 1.035 ,2)
		ENDIF
	ENDIF
	
	dbSelectArea("SB2")
	IF dbSeek(xFilial()+_WPROD+"01")
		_NSLDATU := SB2->B2_QATU
		_NRESERV := SB2->B2_RESERVA
		_NEMPENH := SB2->B2_QEMP
	ENDIF
	
	DbSelectArea("NFS")
	RecLock("NFS",.T.)
	NFS->T_Produto := _WPROD
	NFS->T_Desc	   := _WDESC
	NFS->T_preco   := _WAA

	IF _WMOEDA == "D"
		NFS->T_moedas := "D"
	ELSEIF _WMOEDA == "E"
		NFS->T_moedas := "E"
	ELSE
		NFS->T_moedas := "R"
	ENDIF

	NFS->T_saldo   := _NSLDATU
	NFS->T_IPI     := _WIPI
	MsUnLock("NFS")
	
	DbSelectArea("SB1")
	DbSetOrder(1)
	DbSkip()
End

/*
LISTA O ARQUIVO GERADO !!!
*/
DbSelectArea("NFS")
DbGotop()
While !Eof()
	
	If nLin > 55
		nLin   := cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
	EndIf
	//         1         2         3         4         5         6         7         8         9         0         1         2         3
	//123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
	//xxxxxxxxxxxxxxx 123456789012345678901234567890123456789012345678901234567890 999,999.99 999,999.99 999,999.99 999,999.99 999,999.99
	
	@ nlin,001 PSAY NFS->T_Produto
	@ nlin,017 PSAY NFS->T_Desc
	@ nlin,078 PSAY NFS->T_PRECO   Picture "@E 999,999.99"
	@ nlin,089 PSAY NFS->T_SALDO   Picture "@E 999,999.99"
	nLin := nLin + 1
	DbSelectArea('NFS')
	DbSkip()
End

DbSelectArea('NFS')
DbCloseArea('NFS')

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

AADD(aRegs,{cPerg,"01","Do Produto                ?","","","mv_ch1","C",15,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Ate Produto               ?","","","mv_ch2","C",15,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

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