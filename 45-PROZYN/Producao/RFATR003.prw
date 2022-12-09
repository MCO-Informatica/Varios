#INCLUDE "RWMAKE.CH"
//#INCLUDE "FIVEWIN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRFATR003  บAutor  ณRoberta Alonso      บ Data ณ  24/05/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina para Impressใo da Reserva de Mercadoria              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณProzyn                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function RFATR003(cAlias,nReg,nOpcx)

//Salvo a area ativa no momento
_cAlias := Alias()
_nRecno := Recno()
_nIndex := IndexOrd()

Private _nRecno1,_nRecno2,_nReg, _nItem1
Private nTot
Private _cPedido
Private _cCliente
Private _cLoja
Private nValorTot := 0
Private _nRetICM := 0
Private nTotIPI  := 0
Private _cItem
Private _CTPTRAN

Private _cPedComp:= ""

_nRecno1 := SC5->C5_NUM

Tamanho  := "P"
titulo   := "Reserva de Mercadorias"
cDesc1   := "Este rotina irแ gerar um relat๓rio de Reservas"
cDesc2   := ""
cDesc3   := ""
cString  := "SC5"
wnrel    := "RFATR003"
cabec1   := "      PROZYN" 
cabec2   := "Reserva de Mercadoria"
aReturn  := {"Zebrado",1,"Faturamento", 2, 2, 1, "",1 }
nLastKey := 0
cPerg    := "RFATR003"
nomeprog := "RFATR003"
m_pag      := 1
nTipo      := 15

ValidPerg()

pergunte(cPerg,.F.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Envia controle para a funcao SETPRINT                        ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,,,Tamanho)

If nLastKey = 27
	Set Filter to
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey = 27
	Set Filter to
	Return
Endif

_nRecno1 := SC5->C5_NUM

//verificando se o produto esta liberado por credito e estoque para poder fazer a impressใo
_qQuery := " SELECT C9_PEDIDO AS C9_PEDIDO, C9_BLCRED, C9_BLEST, C9_NFISCAL "
_qQuery += " FROM " + RetSQLName("SC9") + " SC9 "
_qQuery += " WHERE C9_FILIAL 	= '" + xFilial("SC9") + "' AND "
_qQuery += "       C9_PEDIDO	>= '" + _nRecno1		 + "'	AND "
_qQuery += "       C9_PEDIDO	<= '" + _nRecno1		 + "'	AND "
_qQuery += "		 D_E_L_E_T_ = '' "

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_qQuery),"QRY",.T.,.F.)
DbSelectArea("QRY")
DbGoTop()
While !Eof()
	If (!Empty(QRY->C9_BLCRED) .OR. !Empty(QRY->C9_BLEST)) .And. Empty(C9_NFISCAL)
		MsgStop("Pedido Bloqueado por Credito/Estoque","Atencao")
		DbSelectArea("QRY")
		DbClosearea()
		Return
	Endif
	DbSelectArea("QRY")
	DbSkip()
Enddo
DbSelectArea("QRY")
DbClosearea()

DbSelectArea(_cAlias)
DbSetOrder(_nIndex)
DbGoTo(_nRecno)

//fazendo a impressใo do relat๓rio
RptStatus({|lEnd| RPrenota(,@lEnd,wnRel,titulo,Tamanho)},titulo)

Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRPrenota  บAutor  ณMicrosiga           บ Data ณ  05/24/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function RPrenota(aOrd,lEnd,WnRel,titulo,Tamanho)

li			:= 1
nMax		:= 58			// Maximo de linhas suportada pelo relatorio
cCabec1	:= "" 			// Label dos itens
cCabec2	:= "" 			// Label dos itens
aParc		:= {}


_qQuery := " SELECT C9_PEDIDO AS C9_PEDIDO, C9_PRODUTO AS C9_PRODUTO, C9_QTDLIB AS C9_QTDLIB, C9_PRCVEN AS C9_PRCVEN, C9_LOTECTL AS C9_LOTECTL, C9_LOCAL AS C9_LOCAL, "
_qQuery += " C9_CLIENTE AS C9_CLIENTE, C9_LOJA AS C9_LOJA, C9_ITEM AS C9_ITEM, C9_SEQUEN AS C9_SEQUEN "
_qQuery += " FROM " + RetSQLName("SC9") + " SC9 "
_qQuery += " WHERE C9_FILIAL 	= '" + xFilial("SC9") + "' AND "
_qQuery += "       C9_PEDIDO	= '" + _nRecno1 + 		"'	AND "
_qQuery += "		 D_E_L_E_T_ = '' "
_qQuery += " Order by C9_PEDIDO,C9_ITEM  "

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_qQuery),"QRY",.T.,.F.)
DbSelectArea("QRY")
DbGoTop()
nTotItem  :=0
nValorTot :=0
nTotIPI   :=0
_nValIpi  :=1
_nTes	  :="N"
_nVez     := 1
_cPedido  := QRY->C9_PEDIDO
_cCliente := QRY->C9_Cliente
_cLoja    := QRY->C9_Loja

Cabeca()

_cPed  := QRY->C9_PEDIDO
nTot := 0
While !Eof() .and. QRY->C9_PEDIDO <= _cPed
	
	_cItem   := QRY->C9_ITEM
	_nPrcIt  := QRY->C9_PRCVEN
	
	_nQtdIt := 0
	While !EOF() .and. QRY->C9_PEDIDO == _cPed .and. QRY->C9_ITEM == _cItem
		
		If li > 43
			Cabeca()
		Endif
		
		DbSelectArea("SDC")
		DbSetOrder(1)   //produto, Local, Origem, Pedido, item, seq, lote,
		If  DbSeek(xFilial("SDC") + QRY->C9_PRODUTO + QRY->C9_LOCAL + "SC6" + QRY->C9_PEDIDO + QRY->C9_ITEM + QRY->C9_SEQUEN + QRY->C9_LOTECTL)
			While !EOF() .and. (xFilial("SDC") + QRY->C9_PRODUTO + QRY->C9_LOCAL + "SC6" + QRY->C9_PEDIDO + QRY->C9_ITEM + QRY->C9_SEQUEN + QRY->C9_LOTECTL) == (SDC->DC_FILIAL + SDC->DC_PRODUTO + SDC->DC_LOCAL + "SC6" + SDC->DC_PEDIDO + SDC->DC_ITEM + SDC->DC_SEQ + SDC->DC_LOTECTL)
				@ li, 001 PSay SDC->DC_QUANT  Picture("@E 999,999.99")
				@ li, 012 PSay POSICIONE("SB1",1,xFilial("SB1") + QRY->C9_PRODUTO,"B1_UM")
				@ li, 015 PSay SUBSTR(POSICIONE("SB1",1,xFilial("SB1") + QRY->C9_PRODUTO,"B1_DESC"),1,30)
				@ li, 046 PSay Substr(SDC->DC_LOCALIZ,1,9)
				@ li, 059 PSay SDC->DC_QUANT       Picture("@E 999.99")
				@ li, 066 PSay QRY->C9_LOCAL  
				@ li, 069 PSay QRY->C9_LOTECTL
				li++
				DbSkip()
			enddo
		Else
			@ li, 001 PSay QRY->C9_QTDLIB Picture("@E 99,999.99")
			@ li, 012 PSay POSICIONE("SB1",1,xFilial("SB1") + QRY->C9_PRODUTO,"B1_UM")
			@ li, 015 PSay SUBSTR(POSICIONE("SB1",1,xFilial("SB1") + QRY->C9_PRODUTO,"B1_DESC"),1,30)
			@ li, 046 PSay "  "
			@ li, 059 PSay SDC->DC_QUANT       Picture("@E 999.99")
			@ li, 066 PSay QRY->C9_LOCAL //POSICIONE("SB1",1,xFilial("SB1") + QRY->C9_PRODUTO,"B1_LOCPAD")
			@ li, 069 PSay QRY->C9_LOTECTL
			li++
		Endif
		
		_nQtdIt := _nQtdIt + QRY->C9_QTDLIB
		DbSelectArea("QRY")
		DbSkip()
	Enddo
	
	MaFisIni(_cCliente,;	// 1-Codigo Cliente/Fornecedor              // Evandro - fun็ใo fiscal
	_cLoja,;		   	 // 2-Loja do Cliente/Fornecedor
	"C",;							 // 3-C:Cliente , F:Fornecedor
	Posicione("SC5",1,xFilial("SC5") + _cPed,"C5_TIPO"),;				 // 4-Tipo da NF
	"S",;			             // 5-Tipo do Cliente/Fornecedor
	MaFisRelImp("RFATR003",{"SC5","SC6"}),;// 6-Relacao de Impostos que suportados no arquivo
	,;// 7-Tipo de complemento
	,;// 8-Permite Incluir Impostos no Rodape .T./.F.
	"SB1",;					    // 9-Alias do Cadastro de Produtos - ("SBI" P/ Front Loja)
	"RFATR003")					 // 10-Nome da rotina que esta utilizando a funcao
	_nItem1 := 0
	_nRetICM := 0
	nTotIPI := 0
	
	Dbselectarea("SC6")
	Dbsetorder(1)
	Dbseek(xFILIAL("SC6") + _cPedido + _cItem)
	
	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek(xFilial("SB1") + SC6->C6_PRODUTO)
	
	MaFisAdd(SC6->C6_PRODUTO,; 	  // 1-Codigo do Produto ( Obrigatorio )      // Evandro - Fun็ใo fiscal
	SC6->C6_TES,;			  // 2-Codigo do TES ( Opcional )
	SC6->C6_QTDVEN,;		  // 3-Quantidade ( Obrigatorio )
	SC6->C6_PRCVEN,;		  // 4-Preco Unitario ( Obrigatorio )
	SC6->C6_VALDESC,;        // 5-Valor do Desconto ( Opcional )
	,;						  // 6-Numero da NF Original ( Devolucao/Benef )
	,;						  // 7-Serie da NF Original ( Devolucao/Benef )
	,;					      // 8-RecNo da NF Original no arq SD1/SD2
	0,;					  // 9-Valor do Frete do Item ( Opcional )
	0,;					  // 10-Valor da Despesa do item ( Opcional )
	0,;            		  // 11-Valor do Seguro do item ( Opcional )
	0,;					  // 12-Valor do Frete Autonomo ( Opcional )
	SC6->C6_VALOR,;          // 13-Valor da Mercadoria ( Obrigatorio )
	0,;					  // 14-Valor da Embalagem ( Opiconal )
	0,;		     		  // 15-RecNo do SB1
	0) 					  // 16-RecNo do SF4
	
	If Posicione("SC5",1,xFilial("SC5") + _cPedido,"C5_TIPOCLI") == "S"   //Evandro Funcao Fiscal
		_nRetICM := MaFisRet(,'NF_VALSOL')
	Endif
	
	nTotIPI := MaFisRet(,'NF_VALIPI')
	
	nTotItem  := (_nPrcIt * _nQtdIt)
	
	nValorTot := nValorTot + nTotItem
	
	If li > 43
		Cabeca()
	Endif
	
	DbSelectArea("QRY")
EndDo

Rodap()

SetPgEject(.F.)
If aReturn[5] = 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
Endif
MS_FLUSH()

DbSelectArea("QRY")
DbClosearea()

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRFATR003  บAutor  ณMicrosiga           บ Data ณ  05/25/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Cabeca()

DbSelectArea("SC5")
DbSetOrder(1)	//Numero do Pedido
Dbseek(xfilial("SC5") + _nRecno1)

Cabec1 := "Pedido....: " + _cPedido
If SC5->C5_IMP == "S"
	Cabec2 := "SEPARAวรO RE-IMPRESSA"
Else
	Cabec2 := ""
Endif

Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo)

_cTpTran  := SC5->C5_LOGIST

li++
@ li, 000 PSAY "Vendedor..: " + Substr((Posicione("SA3",1,xFilial("SA3") + SC5->C5_VEND1,"A3_NOME")),1,30)
li++

If SC5->C5_Tipo # "D" .AND. SC5->C5_Tipo # "B"
	
	DbSelectArea("SA1")
	DbSetOrder(1)
	If DbSeek(xFilial("SA1") + _cCliente + _cLoja)
		
		@ li, 000 PSAY "Cliente...: " + SA1->A1_NOME
		li++
		@ li, 000 PSAY "CGC.......: "
		@ li, 012 PSAY SA1->A1_CGC PICTURE("@R 99.999.999/9999-99")
		@ li, 035 PSAY "Telefone..: " + "(" +SA1->A1_DDD + ")" + SA1->A1_TEL
		li++
		@ li, 000 PSAY "Endereco..: " + SA1->A1_END
		li++
		@ li, 000 PSAY "Bairro....: " + SA1->A1_BAIRRO
		li++
		@ li, 000 PSAY "Cidade....: " + Substr(SA1->A1_MUN,1,50) + "-" + SA1->A1_EST + " CEP: " + SA1->A1_CEP
	Endif
	
Else
	
	DbSelectArea("SA2")
	DbSetOrder(1)
	If DbSeek(xFilial("SA2") + _cCliente + _cLoja)
		
		@ li, 000 PSAY "Fornecedor: " + SA2->A2_NOME
		li++
		@ li, 000 PSAY "CGC.......: "
		@ li, 012 PSAY SA2->A2_CGC PICTURE("@R 99.999.999/9999-99")
		@ li, 035 PSAY "Telefone..: " + "(" +SA2->A2_DDD + ")" + SA2->A2_TEL
		li++
		@ li, 000 PSAY "Endereco..: " + SA2->A2_END + " - " + SA2->A2_BAIRRO
		li++
		@ li, 000 PSAY "Bairro....: " + SA2->A2_BAIRRO
		li++
		@ li, 000 PSAY "Cidade....: " + Substr(SA2->A2_MUN,1,50) + "-" + SA2->A2_EST + " CEP: " + SA2->A2_CEP
	Endif
	
Endif

li+=2
@ li, 001 PSAY "-------------------------------------------------------------------------------"
li++
@ li, 001 PSAY "Quantidade UM Descricao                      ENDERECO            AZ Num. Lote"
li++
@ li, 001 PSAY "-------------------------------------------------------------------------------"
li++

//Quantidade UM Descricao                      ENDERECO  EX VOLUME AZ Num. Lote
//999,999.99 xx xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx xxxxxxxxx XX 999.99 xx xxxxxxxxxx
//1          12 15                             46        56 59     66 69

Return()


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRFATR003  บAutor  ณMicrosiga           บ Data ณ  05/25/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Rodap()
Local nI	:= 0
li++
@li, 001 PSAY "-------------------------------------------------------------------------------"

li++
If SC5->C5_Tipo # "D" .OR. SC5->C5_Tipo # "B"
	
	DbSelectArea("SA1")
	DbSetOrder(1)
	If DbSeek(xFilial("SA1") + SC5->C5_CLIENTE + SC5->C5_LOJACLI)
		If !Empty(SA1->A1_ENDENT+SA1->A1_BAIRROE+SA1->A1_MUNE+SA1->A1_ESTE+SA1->A1_CEPE)
			@ li, 001 PSAY "Entrega: " + SA1->A1_ENDENT + " - " + SA1->A1_BAIRROE
			li++
			@ li, 001 PSAY "         " + Rtrim(SA1->A1_MUNE) + "-" + SA1->A1_ESTE + " CEP: " + SA1->A1_CEPE
			li++
		Endif
	Endif
Else
	DbSelectArea("SA2")
	DbSetOrder(1)
	If DbSeek(xFilial("SA2") + _cCliente + _cLoja)
		@ li, 001 PSAY "Entrega: " + SA2->A2_ENDENT + " - " + SA2->A2_BAIRROE
		li++
		@ li, 001 PSAY "         " + RTrim(SA2->A2_MUNE) + "-" + SA2->A2_ESTE + " CEP: " + SA2->A2_CEPE
		li++
	Endif
Endif

Li+=1
Dbselectarea("SA4")
Dbsetorder(1)
Dbseek(xFilial("SA4") + SC5->C5_TRANSP)

@li, 000 Psay "Transportadora: " + SC5->C5_TRANSP + " - " + SA4->A4_NOME
li++
@li, 000 Psay "Endere็o......: " + SA4->A4_END  
li++
@li, 000 Psay "Bairro........: " + SA4->A4_BAIRRO
li++
@li, 000 Psay "Cidade........: " + Rtrim(SA4->A4_MUN) + " -" + SA4->A4_EST + " TEL: " + SA4->A4_DDD + " " + SA4->A4_TEL
li+=2

If !Empty(SC5->C5_OBSEXP)
	@li, 000 Psay "Observacoes...: "
	_nLinha:= MLCount(SC5->C5_OBSEXP,80)
	If _nLinha > 0
		For nI := 1 To _nLinha
			li++
			@ Li,13 PSay MemoLine(SC5->C5_OBSEXP,80,_nLinha)
		Next nI
	Endif
Endif


//@li, 000 PSAY CHR(27)+"E"

li++
li++
li++
@li, 000 Psay "ENTREGA ("+ If(_cTpTran=="E","X"," ") + ")         Separado por :........................   ...../...../....."
li++
@li, 000 Psay "COLETA  ("+ If(_cTpTran=="C","X"," ") + ")                                                                   "
li++
@li, 000 Psay "RETIRA  ("+ If(_cTpTran=="R","X"," ") + ")         Conferido por:........................  ....../...../....."

//@li, 000 PSAY CHR(27)+"F"


li :=65
@li,001 Psay ""

RECLOCK("SC5",.F.)
SC5->C5_DTIMP := dDATABASE
SC5->C5_HRIMP := TIME()
SC5->C5_IMP:="S"
MsUnlock()

nTotIPI := 0

//@li, 000 PSAY CHR(27)+"F"

MaFisEnd()

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRFATR003  บAutor  ณMicrosiga           บ Data ณ  07/02/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ValidPerg()

Local i := 0
Local j := 0

_sAlias := Alias()
DbSelectArea("SX1")
DbSetOrder(1)
cPerg := PADR(cPerg,10)
aRegs:={}

AADD(aRegs,{cPerg,"01","Pedido             ?","","","mv_ch1","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
//AADD(aRegs,{cPerg,"02","Ate Pedido          ?","","","mv_ch2","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

For i:=1 To Len(aRegs)
	If !DbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For J:=1 to FCount()
			If J <= Len(aRegs[i])
				FieldPut(J,aRegs[i,j])
			Else
				Exit
			EndIf
		Next
		MsUnlock()
	EndIf
Next

Return
