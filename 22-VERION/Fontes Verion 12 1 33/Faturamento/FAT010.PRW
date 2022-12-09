#INCLUDE "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFAT001    บAutor  ณMicrosiga           บ Data ณ  06/14/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Relatorio de Faturamento Sintetico.                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ                  3
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function FAT010()
Private aOrd         := {}
Private CbTxt        := ""
Private cDesc1       := "Este programa gera um relat๓rio de compras."
Private cDesc2       := ""
Private cDesc3       := ""
Private cPict        := ""
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private limite       := 132
Private tamanho      := "M"
Private nomeprog     := "FAT010"
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cPerg        := "FAT001    "
Private titulo       := "FATURAMENTO - PRECO DE VENDA"
Private nLin         := 80
Private Cabec1       := "Codigo            Descricao                          Preco   Saldo  Reservado Empenhado Comprado"
Private Cabec2       := "------            ---------                          -----   -----                              "
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private imprime      := .T.
Private wnrel        := "FAT001"
Private cString      := "SB1"

_cOmInsc := ""
//Pesquisa as perguntas selecionadas.
ValidPerg()
Pergunte(cPerg,.F.)

wnrel := SetPrint(cString,NomeProg,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)
Titulo := "COMPRAS - " + DTOC(DDATABASE)

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
AADD(_aStru,{"T_grupo"   ,"C",04,0})//GRUPO DO Produto
AADD(_aStru,{"T_linha"   ,"C",10,0})//GRUPO DO Linha
AADD(_aStru,{"T_Aplicac","C",10,0})//GRUPO DO Aplica็ใo
AADD(_aStru,{"T_preco"   ,"N",15,5})//preco
AADD(_aStru,{"T_saldo"   ,"N",15,0})//saldo em estoque
AADD(_aStru,{"T_reserva" ,"N",15,0})//reserva
AADD(_aStru,{"T_empenho" ,"N",15,0})//empenho
AADD(_aStru,{"T_solcomp" ,"N",15,0})//solicitacao de compras
AADD(_aStru,{"T_compras" ,"N",15,0})//pedido de compras
AADD(_aStru,{"T_moedas"  ,"C",01,0})//moedas
AADD(_aStru,{"T_pendent" ,"N",15,0})//pendente
AADD(_aStru,{"T_OP     " ,"N",15,0})//OP
AADD(_aStru,{"T_VEND   " ,"N",15,0})//VENDAS
AADD(_aStru,{"T_ORCAM  " ,"N",15,0})//ORCAMENTO

_ACABEC := {"T_produto","T_desc","T_grupo","T_linha","T_Aplicac","T_preco","T_saldo","T_reserva","T_empenho","T_solcomp","T_compras","T_moedas","T_pendent","T_OP","T_VEND","T_ORCAM"}
_ADADOS := {}

_cPath   := "\SPOOL\"
_cNomArq := "COMPRA.xls"

_cPathDest := cGetFile("","Local para gravacไo...",1,,.F.,GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY )

If File( _cPath + _cNomArq )
	Ferase( _cPath + _cNomArq )
EndIf

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
	
	If SB1->B1_MSBLQL == "1"
		DbSkip()
		Loop
	EndIf
	
	_WAA      := 	_NSLDATU  := 	_NRESERV  := 0
	_NEMPENH  := 	_NCOMPRA  := 0
	_WDATA    := DDATABASE
	_WPROD    := SB1->B1_COD
	_WDESC    := SB1->B1_DESC
	_WPRECO   := SB1->B1_VERVEN
	_WTIPICMS := SB1->B1_TIPICMS
	_WMOEDA   := SB1->B1_TPMOEDA
	_WFATOR   := SB1->B1_FATOR
	_WPRECO1  := SB1->B1_VERCOM
	_WGRUPO   := SB1->B1_GRUPO
	_WLINHA   := SB1->B1_XLINHA
	_WAPLIC   := SB1->B1_XAPLIC
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
		_NCOMPRA := SB2->B2_SALPEDI
	ENDIF
	
	_NVERPEND := 0
	dbSelectArea("SC6")
	DBSETORDER(2)
	IF dbSeek(xFilial()+_WPROD)
		WHILE !EOF() .AND. _WPROD == SC6->C6_PRODUTO
			
			If !Empty(SC6->C6_NOTA)
				dbSelectarea("SC6")
				dbSkip()
				loop
			Endif
			
			_NVERPEND := _NVERPEND + iiF(SC6->C6_BLQ <> 'R',SC6->C6_VRSLDPR,0)
			dbskip()
		END
	ENDIF
	
	// ORDEM DE PRODUCAO
	_NVERPROD := 0
	dbSelectArea("SD3")
	DBSETORDER(3)
	IF dbSeek(xFilial()+_WPROD)
		WHILE !EOF() .AND. _WPROD == SD3->D3_COD
			
			IF SD3->D3_EMISSAO < MV_PAR03 .OR. SD3->D3_EMISSAO > MV_PAR04
				dbSelectarea("SD3")
				dbSkip()
				loop
			ENDIF
			
			If ALLTRIM(SD3->D3_TM) <> "999"
				dbSelectarea("SD3")
				dbSkip()
				loop
			Endif
			
			If ALLTRIM(SD3->D3_ESTORNO) == "S"
				dbSelectarea("SD3")
				dbSkip()
				loop
			Endif
			
			If Empty(SD3->D3_OP)
				dbSelectarea("SD3")
				dbSkip()
				loop
			Endif
			
			_NVERPROD := _NVERPROD + SD3->D3_QUANT
			dbskip()
		END
	ENDIF
	
	// VENDA DO PRODUTO
	_NVERVEND := 0
	dbSelectArea("SD2")
	DBSETORDER(1)
	IF dbSeek(xFilial()+_WPROD)
		WHILE !EOF() .AND. _WPROD == SD2->D2_COD
			
			IF SD2->D2_EMISSAO < MV_PAR03 .OR. SD2->D2_EMISSAO > MV_PAR04
				dbSelectarea("SD2")
				dbSkip()
				loop
			ENDIF
			
			dbSelectArea("SF2")
			DBSETORDER(1)
			dbseek(xfilial("SF2")+SD2->D2_DOC)
			
			
			If EMPTY(SF2->F2_DUPL)
				dbSelectarea("SD2")
				dbSkip()
				loop
			Endif
			
			dbSelectArea("SD2")
			
			_NVERVEND := _NVERVEND + SD2->D2_QUANT
			dbskip()
		END
	ENDIF
	
	// SOLICITACAO DE COMPRAS
	_NVERSOLC := 0
	dbSelectArea("SC1")
	DBSETORDER(2)
	IF dbSeek(xFilial()+_WPROD)
		WHILE !EOF() .AND. _WPROD == SC1->C1_PRODUTO
			
			IF SC1->C1_EMISSAO < MV_PAR03 .OR. SC1->C1_EMISSAO > MV_PAR04
				dbSelectarea("SC1")
				dbSkip()
				loop
			ENDIF
			
			If !EMPTY(SC1->C1_PEDIDO)
				dbSelectarea("SC1")
				dbSkip()
				loop
			Endif
			
			_NVERSOLC := _NVERSOLC + (SC1->C1_QUANT-SC1->C1_QUJE)
			dbskip()
		END
	ENDIF
	
	
	// PEDIDO DE COMPRAS
	_NVERPEDC := 0
	dbSelectArea("SC7")
	DBSETORDER(2)
	IF dbSeek(xFilial()+_WPROD)
		WHILE !EOF() .AND. _WPROD == SC7->C7_PRODUTO
			
			IF SC7->C7_EMISSAO < MV_PAR03 .OR. SC7->C7_EMISSAO > MV_PAR04
				dbSelectarea("SC7")
				dbSkip()
				loop
			ENDIF
			
			_NVERPEDC := _NVERPEDC + (SC7->C7_QUANT-SC7->C7_QUJE)
			dbskip()
		END
	ENDIF
	
	// ORCAMENTO
	_NVRORCAM := 0
	dbSelectArea("SUB")
	DBSETORDER(2)
	IF dbSeek(xFilial()+_WPROD)
		WHILE !EOF() .AND. _WPROD == SUB->UB_PRODUTO
			
			IF SUB->UB_EMISSAO < MV_PAR03 .OR. SUB->UB_EMISSAO > MV_PAR04
				dbSelectarea("SUB")
				dbSkip()
				loop
			ENDIF

			_NVRORCAM := _NVRORCAM + SUB->UB_QUANT
			dbskip()
		END
	ENDIF

	// GRAVA OS CAMPOS DA PLANILHA
	DbSelectArea("NFS")
	RecLock("NFS",.T.)
	NFS->T_Produto := alltrim(_WPROD)
	NFS->T_Desc	   := _WDESC
	NFS->T_GRUPO   := _WGRUPO   // GRUPO
	NFS->T_LINHA   := _WLINHA   
	NFS->T_APLICAC := _WAPLIC  
	NFS->T_preco   := _WPRECO1  //_WAA CAVALINI
	IF _WMOEDA == "D"
		NFS->T_moedas := "D"
	ELSEIF _WMOEDA == "E"
		NFS->T_moedas := "E"
	ELSE             
    	_WMOEDA := "R"
		NFS->T_moedas := "R"
	ENDIF
	NFS->T_saldo   := _NSLDATU
	NFS->T_reserva := _NRESERV
	NFS->T_empenho := _NEMPENH
	NFS->T_SOLCOMP := _NVERSOLC
	NFS->T_compras := _NVERPEDC
	NFS->T_pendent := _NVERPEND
	NFS->T_OP      := _NVERPROD
	NFS->T_VEND    := _NVERVEND   
	NFS->T_ORCAM   := _NVRORCAM
	MsUnLock("NFS")

    aAdd(_aDados,{ _WPROD, _WDESC, _WGRUPO, _WLINHA, _WAPLIC, _WPRECO1, _NSLDATU, _NRESERV,_NEMPENH, _NVERSOLC, _NVERPEDC, _WMOEDA, _NVERPEND, _NVERPROD, _NVERVEND, _NVRORCAM })

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
	@ nlin,100 PSAY NFS->T_RESERVA Picture "@E 999,999.99"
	@ nlin,111 PSAY NFS->T_EMPENHO Picture "@E 999,999.99"
	@ nlin,122 psay NFS->T_COMPRAS Picture "@E 999,999.99"
	nLin := nLin + 1
	DbSelectArea('NFS')
	DbSkip()
End

DbSelectArea('NFS')
_cArqDest := "\SPOOL\CADASTRO\COMPRAS.XLS"
Copy to &_cArqDest VIA "DBFCDX"

DbSelectArea('NFS')
DbCloseArea('NFS')

// Caso encontre arquivo ja gerado na estacao
//com o mesmo nome apaga primeiramente antes de gerar a nova impressao
If File( _cPathDest + _cNomArq )
	Ferase( _cPathDest + _cNomArq )
EndIf

If Left(Alltrim(_cPath),1) <> '\' .OR. Left(Alltrim(_cPath),1) <> '/'
	If CpyS2T(_cPath+_cNomArq,_cPathDest,.T.) // Copia do Server para o Remote, eh necessario
		Ferase( _cPath+_cNomArq )
	Endif
Endif


// GERA A PLANILHA EXCELL
arTitulo :="COMPRAS"
DlgtoExcel({{"ARRAY",arTitulo,_aCABEC, _aDados}})    

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
AADD(aRegs,{cPerg,"03","Da Data                   ?","","","mv_ch3","D",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"04","Ate Data                  ?","","","mv_ch4","D",08,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

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
