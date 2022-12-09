#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFAT001    บAutor  ณMicrosiga           บ Data ณ  06/14/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Relatorio de Faturamento Sintetico.                        บฑฑ
ฑฑบ          ณ       FAMOSO PECAS.XLS                                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function FAT001()
Private aOrd         := {}                                       
Private CbTxt        := ""
Private cDesc1       := "Este programa gera um relat๓rio-preco de venda."
Private cDesc2       := ""
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
Titulo := "FATURAMENTO - PRECO DE VENDA - " + DTOC(DDATABASE)

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
_aStru  := {}                 
AADD(_aStru,{"T_produto" ,"C",15,0})//Codigo do Produto
AADD(_aStru,{"T_desc"    ,"C",60,0})//Descricao do Produto
AADD(_aStru,{"T_preco"   ,"N",15,5})//preco
AADD(_aStru,{"T_saldo"   ,"N",15,0})//saldo em estoque
AADD(_aStru,{"T_reserva" ,"N",15,0})//reserva
AADD(_aStru,{"T_empenho" ,"N",15,0})//empenho
AADD(_aStru,{"T_compras" ,"N",15,0})//compras
AADD(_aStru,{"T_moedas"  ,"C",01,0})//moedas
AADD(_aStru,{"T_IPI"     ,"N",15,2})//moedas
AADD(_aStru,{"T_pendent" ,"N",15,0})//pendente      
_aCABEC := {"PRODUTO","DESCRICAO","SALDO_ATUAL","RESERVA","EMPENHO","COMPRAS","MOEDA","IPI","PRECO","PENDENTE"}
_adados := {}

_cPath   := "\CPROVA\"
//_cNomArq := "PECA74.xls"
_cNomArq := "PECA74.csv"

dbcreate(_cPath+_cNomArq,_aStru)
dbusearea(.T.,,_cPath+_cNomArq,"NFS",.T.,.F.)

DbSelectArea("SB1")
DbSetOrder(1)
DbSeek(XFILIAL("SB1")+mv_par01,.T.)
SetRegua(RecCount())

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
	
	If ALLTRIM(SB1->B1_MSBLQL) == "1"
		DbSkip()
		Loop
	EndIf

	If SB1->B1_XPECA == "N"
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
//		_NCOMPRA := SB2->B2_SALPEDI
	ENDIF
	
	// ACHA PEDIDOS DE VENDAS
	_NVERPEND := 0           
	_NVERPEND :=  _ACPVDCV(_WPROD)

    // ACHA PEDIDOS DE COMPRAS
	_NCOMPRA  := 0           
	_NCOMPRA  :=  _ACPCDCV(_WPROD)

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
	    _WMOEDA       := "R"
		NFS->T_moedas := "R"
	ENDIF

	NFS->T_saldo   := _NSLDATU
	NFS->T_reserva := _NRESERV
	NFS->T_empenho := _NEMPENH
	NFS->T_compras := _NCOMPRA
	NFS->T_IPI     := _WIPI
	NFS->T_pendent := _NVERPEND
	MsUnLock("NFS")

    aAdd(_aDados,{ chr(160)+_WPROD,chr(160)+_WDESC,_NSLDATU,_NRESERV,_NEMPENH,_NCOMPRA,chr(160)+_WMOEDA,_WIPI,_WAA,_NVERPEND})

	DbSelectArea("SB1")
	DbSetOrder(1)
	DbSkip()
EndDo

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
_cArqDest := "\SPOOL\PECA.CSV"
//_cArqDest := "\SPOOL\PECA.XLS"
//Copy to &_cArqDest VIA "DBFCDXADS"

fGeraCSV(_cArqDest,.F.)  //gera arquivo CSV para abrir em excel


//If __CopyFile("\spool\PECA.XLS", Alltrim(MV_PAR05)+_cNomArq)
If __CopyFile("\spool\PECA.CSV", Alltrim(MV_PAR05)+_cNomArq)
	MsgInfo("Arquivo copiado com sucesso." + Alltrim(MV_PAR05)+_cNomArq  )
Else
	//ALERT("Arquivo nใo copiado com sucesso." + Alltrim(MV_PAR05)+_cNomArq  )
	MSGSTOP("ERRO ao COPIAR arquivo " + Alltrim(MV_PAR05)+_cNomArq  )	
endif

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

// GERA A PLANILHA EXCELL
arTitulo :="PECA" 
DlgtoExcel({{"GETDADOS","PECA",_aStru,_aDados}})     

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

local j
local i
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

//============================================//
// ACHA A PEDIDO DE VENDAS                   //
//===========================================//
STATIC FUNCTION _ACPVDCV(_prodb1)
_NPVACH  := 0
CQUERY3  := ""

DbSelectArea("SC6")
cQuery3 := "SELECT ISNULL(SUM(C6_VRSLDPR),0) QTDPV"
cQuery3 += " FROM " + RetSqlName("SC6") + " C6 WITH (NOLOCK) "
cQuery3 += " WHERE C6_PRODUTO = '"+_prodb1+"' AND C6_NOTA = '' AND C6.D_E_L_E_T_ = ''"

//cQuery3 := ChangeQuery(cQuery3)

TCQUERY cQuery3 NEW ALIAS "CQUERY3"

DbSelectArea("CQUERY3")
DbGoTop()

_NPVACH := CQUERY3->QTDPV

DbSelectArea("CQUERY3")
DbCloseArea("CQUERY3")
RETURN(_NPVACH)


//============================================//
// ACHA A PEDIDO DE COMPRAS                  //
//===========================================//
STATIC FUNCTION _ACPCDCV(_prodb1)
_NPCACH  := 0
CQUERY4  := ""

DbSelectArea("SC7")
cQuery4 := "SELECT ISNULL(SUM(C7_QUANT-C7_QUJE),0) QTDPC"
cQuery4 += " FROM " + RetSqlName("SC7") + " C7 WITH (NOLOCK) "
cQuery4 += " WHERE C7_PRODUTO = '"+_prodb1+"' AND C7_ENCER = '' AND C7_RESIDUO = '' AND C7.D_E_L_E_T_ = ''"

//cQuery4 := ChangeQuery(cQuery4)

TCQUERY cQuery4 NEW ALIAS "CQUERY4"

DbSelectArea("CQUERY4")
DbGoTop()

_NPCACH := CQUERY4->QTDPC

DbSelectArea("CQUERY4")
DbCloseArea("CQUERY4")
RETURN(_NPCACH)

Static Function fGeraCSV(cFile, lEnd)

Local nHandle

If File(cFile)
	If Aviso("Aviso", "Arquivo jแ existe. Sobrescreve? ", {"Sim", "Nao"},2) == 2 
		Return
	EndIf
EndIf

If (nHandle := FCreate(cFile))== -1
	MsgStop("Problemas para criar o arquivo.", "Problema" + " " + strzero(ferror(),4))
	Return
EndIf

DbSelectArea('NFS')
dbGoTop()

ProcRegua(NFS->(RecCount()))

/*
AADD(_aStru,{"T_produto" ,"C",15,0})//Codigo do Produto
AADD(_aStru,{"T_desc"    ,"C",60,0})//Descricao do Produto
AADD(_aStru,{"T_preco"   ,"N",15,5})//preco
AADD(_aStru,{"T_saldo"   ,"N",15,0})//saldo em estoque
AADD(_aStru,{"T_reserva" ,"N",15,0})//reserva
AADD(_aStru,{"T_empenho" ,"N",15,0})//empenho
AADD(_aStru,{"T_compras" ,"N",15,0})//compras
AADD(_aStru,{"T_moedas"  ,"C",01,0})//moedas
AADD(_aStru,{"T_IPI"     ,"N",15,2})//moedas
AADD(_aStru,{"T_pendent" ,"N",15,0})//pendente      
*/

FWrite(nHandle,"PRODUTO;DESCRICAO;PRECO;SALDO;RESERVA;EMPENHO;COMPRAS;MOEDAS;IPI;PENDENTE"+chr(13)+chr(10))

Do While !NFS->(Eof())
	IncProc("Gerando NFS ... ")
	
	FWrite(nHandle,'"'+NFS->T_PRODUTO+'";"'+NFS->T_DESC+'";'+Transform(NFS->T_PRECO,"@e 999,999,999.99")+';'+StrZero(NFS->T_SALDO,15,0)+";"+;
				       Strzero(NFS->T_RESERVA,15,0)+";"+Strzero(NFS->T_EMPENHO,15,0)+";"+Strzero(NFS->T_COMPRAS,15,0)+";"+;
				       NFS->T_MOEDAS+";"+Transform(NFS->T_IPI,"@e 999,999,999.99")+";"+Strzero(NFS->T_PENDENT,15,0)+";"+chr(13)+chr(10))
	
	If lEnd
		Exit
	EndIf

	NFS->(dbSkip())
EndDo

FClose(nHandle)

//Aviso(STR0008, STR0023, {STR0003}, 2) //"Aviso" // "Arquivo exportado com sucesso" // "Fechar"

Return
