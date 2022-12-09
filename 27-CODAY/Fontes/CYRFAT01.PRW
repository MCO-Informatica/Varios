#include "rwmake.ch"

//+---------------------------------------------------------------------------
//| Funcao     : CyRFat01()
//+---------------------------------------------------------------------------
//| Autor      : Vicente Lacerenza
//+---------------------------------------------------------------------------
//| Coordenador: Eduardo Barbosa
//+---------------------------------------------------------------------------
//| Data       : 11/Dezembro/2002
//+---------------------------------------------------------------------------
//| Descricao  : PEDIDO DE VENDAS - sc5/sc6/sa1/sa4
//+---------------------------------------------------------------------------
//| Uso        : CODAY - IMPORTACAO E COMERCIO LTDA.
//+---------------------------------------------------------------------------
//| Observacao :
//|
//+---------------------------------------------------------------------------

User Function CyRFat01()

// Define Variaveis
LOCAL cDesc1 :=OemToAnsi("Este programa ira emitir os pedidos de vendas")
LOCAL cDesc2 :=OemToAnsi("conforme os parametros")
LOCAL cDesc3 :="Especifico: CODAY - IMPORT. E COMERCIO LTDA.-Dez/2002"
LOCAL cString:="SC6"

PRIVATE aReturn := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
PRIVATE nomeprog:="CYRFAT01"
PRIVATE aLinha  := { },nLastKey := 0
PRIVATE _cPerg   :="RFAT01"
PRIVATE CbCont,wnrel
PRIVATE CbTxt
PRIVATE titulo,cabec1,cabec2
PRIVATE tamanho:="M"
PRIVATE limite :=142
Private _cPag := 1
Private _cTipoPV
Private	_nBaseIPI,_nIPI,_nValBase,_nAliIPI,_PosPrUnit,_PosPrcVen
Private  _lIpiBruto:=IIF(GETMV("MV_IPIBRUT")=="S",.T.,.F.)
Private aRelImp    := MaFisRelImp("MT100",{"SF2","SD2"})



// Monta cabecalhos e verifica tipo de impressao
titulo := OemToAnsi("Pedido de Veendas")

// Variaveis utilizadas para Imporessao do Cabecalho e Rodape
cbtxt    := SPACE(10)
cbcont   := 0
li       := 80
m_pag    :=1

// Verifica as perguntas selecionadas
ValidPerg()

pergunte("RFAT01",.F.)

//+---------------------------------------------------------
//| Variaveis utilizadas para parametros
//| mv_par01        	// do Pedido
//| mv_par02        	// Ate o pedido
//| mv_par03        	// do cliente
//| mv_par04        	// Ate o cliente
//| mv_par05        	// da loja
//| mv_par06        	// Ate a loja
//+---------------------------------------------------------

// Envia controle para a funcao SETPRINT
wnrel:="CYRFAT01"            //Nome Default do relatorio em Disco

wnrel:=SetPrint(cString,wnrel,_cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",,Tamanho)

If nLastKey==27
	Set Filter to
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey==27
	Set Filter to
	Return
Endif

RptStatus({|lEnd| CImprime(@lEnd, wnrel, cString) }, "Aguarde...", "Processando registros...", .T. )

Return



//+---------------------------------------------------------------------------
//| Funcao     : CImprime
//+---------------------------------------------------------------------------
//| Autor      : Vicente Lacerenza
//+---------------------------------------------------------------------------
//| Descricao  : Chamada do Relatorio
//+---------------------------------------------------------------------------
Static Function CImprime(lEnd,WnRel,cString)

// Define Variaveis
LOCAL cDesc1 :=OemToAnsi("Este programa ira emitir os pedidos de vendas")
LOCAL cDesc2 :=OemToAnsi("")
LOCAL cDesc3 :=""
LOCAL tamanho:="M"
Local cFiltro  := ""
Local cFilSC6   := xFilial(cString)
PRIVATE cIndex := CriaTrab(nil,.f.)
PRIVATE _cIndTRB := CriaTrab(nil,.f.)
PRIVATE limite :=142

// Monta cabecalhos e verifica tipo de impressao
titulo := ""
cabec1 := ""
cabec2 := ""
*****      999999999999999 XXXXXXXXX-XXXXXXXXXX-XXXXXXXXX-XXXXXXXXXX-   999,999.99
*****      012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
*****      0         1         2         3         4         5         6         7         8         9        10        11        12        13        14

nTipo  := IIF(aReturn[4]==1,15,18)

// Variaveis utilizadas para Impressao do Cabecalho e Rodape
cbtxt    := SPACE(10)
cbcont   := 0
li       :=80
m_pag    :=1

//+----------------------------------------------------------
//| Cria o arquivo Temporario
//+----------------------------------------------------------
//| ARQUIVO -->   T R B - RECEBE OS ITENS LIBERADOS DO SC9
aStru := {}
aAdd(aStru ,{ "TRANSP"  , "C" , 06 , 0 })
aAdd(aStru ,{ "PRODUTO" , "C" , 15 , 0 })
aAdd(aStru ,{ "REFEREN" , "C" , 20 , 0 })
aAdd(aStru ,{ "UNID"    , "C" , 02 , 0 })  // unid. medida
aAdd(aStru ,{ "PEDIDO"  , "C" , 06 , 0 })  // Grava descricao produto b1_desc
aAdd(aStru ,{ "ITEMPV"  , "C" , 02 , 0 })
aAdd(aStru ,{ "CLIENTE" , "C" , 06 , 0 })
aAdd(aStru ,{ "LOJA"    , "C" , 02 , 0 })
aAdd(aStru ,{ "TPPESSOA", "C" , 01 , 0 })   // tipo pessoa (fisica/juridica)
aAdd(aStru ,{ "QTDVEN"  , "N" , 11 , 2 })
aAdd(aStru ,{ "PRUNIT"	, "N" , 11 , 2 })   // preco lista
aAdd(aStru ,{ "PRCVEN"	, "N" , 11 , 2 })   // preco unit. liq. item
aAdd(aStru ,{ "VALOR"	, "N" , 12 , 2 })   // total do item
aAdd(aStru ,{ "DESCONT" , "N" , 05 , 2 })   // percent. desconto do item
aAdd(aStru ,{ "VALDESC" , "N" , 12 , 2 })   // vlr. desconto do item
aAdd(aStru ,{ "DESC"    , "C" , 40 , 0 })  // Grava descricao produto b1_desc
aAdd(aStru ,{ "EMISSAO" , "D" , 08 , 0 })  // Data emissao do pv.
aAdd(aStru ,{ "VEND1"   , "C" , 06 , 0 })   // cod. vendedor 1 - c5_vend1
aAdd(aStru ,{ "CONDPAG" , "C" , 03 , 0 })   // cond. pagto.
aAdd(aStru ,{ "TABELA"  , "C" , 03 , 0 })   // tab. preco
aAdd(aStru ,{ "TES"     , "C" , 03 , 0 })   // TES
aAdd(aStru ,{ "XCARBCO" , "C" , 01 , 0 })   // FLAG CARTEIRA OU BANCO
aAdd(aStru ,{ "C5TIPO"  , "C" , 01 , 0 })    
aAdd(aStru ,{ "C5TIPOCLI" , "C" , 01 , 0 })    

_cArqTRB := Criatrab(aStru,.T.)
dbUseArea(.T.,,_cArqTRB,"TRB",.F.,.F.)
IndRegua("TRB",_cIndTRB,"PEDIDO+ITEMPV",,,"Criando Indice ...")

/*
//TMP para tratar ordem clientes.
aStru2 := {}
aAdd(aStru2 ,{ "CLIENTE" , "C" , 06 , 0 })
aAdd(aStru2 ,{ "LOJA"    , "C" , 02 , 0 })
aAdd(aStru2 ,{ "NOME"    , "C" , 40 , 0 })
aAdd(aStru2 ,{ "ENDERE"  , "C" , 40 , 0 })
aAdd(aStru2 ,{ "BAIRRO"  , "C" , 30 , 0 })
aAdd(aStru2 ,{ "MUN"  	 , "C" , 15 , 0 })
aAdd(aStru2 ,{ "EST"     , "C" , 02 , 0 })
aAdd(aStru2 ,{ "REGIAO"  , "C" , 10 , 0 })
aAdd(aStru2 ,{ "TRANSP"  , "C" , 06 , 0 })

_cArqTMP := Criatrab(aStru2,.T.)
dbUseArea(.T.,,_cArqTMP,"TMP",.F.,.F.)
IndRegua("TMP",_cIndTMP,"CLIENTE+LOJA+TRANSP",,,"Criando Indice ...")
*/

//+-------------------------
//| Posiciona no Arq. SC9
//+-------------------------
/*
dbSelectArea("SC9")
cFiltro := "C9_FILIAL == '"+cFilSC9+"' "
cFiltro += ".And. Dtos(C9_DATALIB) == '"+Dtos(mv_par01)+"' "
cFiltro += ".And. C9_PEDIDO >= '"+mv_par04+"' "
cFiltro += ".And. C9_PEDIDO <= '"+mv_par05+"' "
cFiltro += ".And. C9_CLIENTE >= '"+mv_par06+"' "
cFiltro += ".And. C9_CLIENTE <= '"+mv_par07+"' "
cFiltro += ".And. C9_LOJA >= '"+mv_par08+"' "
cFiltro += ".And. C9_LOJA <= '"+mv_par09+"' "
cFiltro += ".And. Empty(C9_BLCRED)"
cFiltro += ".And. C9_QTDLIB > 0"
//If mv_par10 == 2   //NAO RE-IMPRIME
//	cFiltro += ".and. Empty(C9_X_IMPPV)"
//Endif
IndRegua("SC9",cIndex,"C9_FILIAL+C9_PEDIDO+C9_ITEM+C9_SEQUEN",,cFiltro,"Selecionando Registros...")
#IFNDEF TOP
DbSetIndex(cIndex+OrdBagExt())
#ENDIF
COPY TO SC9VIC
*/

dbSelectArea("SC6")
cFiltro := "C6_FILIAL == '"+cFilSC6+"' "
cFiltro += ".And. C6_NUM >= '"+mv_par01+"' "
cFiltro += ".And. C6_NUM <= '"+mv_par02+"' "
cFiltro += ".And. C6_CLI >= '"+mv_par03+"' "
cFiltro += ".And. C6_CLI <= '"+mv_par04+"' "
cFiltro += ".And. C6_LOJA >= '"+mv_par05+"' "
cFiltro += ".And. C6_LOJA <= '"+mv_par06+"' "

IndRegua("SC6",cIndex,"C6_FILIAL+C6_NUM+C6_ITEM",,cFiltro,"Selecionando Registros...")
#IFNDEF TOP
	DbSetIndex(cIndex+OrdBagExt())
#ENDIF
COPY TO SC6VIC

Processa({||CYImpRel()})

Return

//+-------------------------------------------------------------------
//| Funcao     : CYImpRel
//+-------------------------------------------------------------------
//| Autor      : Vicente Lacerenza
//+-------------------------------------------------------------------
Static FUNCTION CYImpRel()
LOCAL lContinua:=.T.
Private _lCont
Private _cTransp

dbSeek(xFilial()+mv_par01,.T.)
ProcRegua(RecCount())
DbGoTop()
//_nReg      := 0

While !Eof() .And. xFilial()==C6_FILIAL .And. lContinua //.And. F2_TRANSP >= mv_par01 .And. F2_TRANSP <= mv_par02 .And. lContinua
	
	//_nReg++
	IncProc("Pedidos : "+SC6->C6_NUM+"-"+SC6->C6_ITEM)
	
	//Sem bloqueio de credido
	//If !Empty(C9_BLCRED)
	//	dbSelectArea("SC9")
	//	DbSkip()
	//	Loop
	//EndIf
	
	//Sem faturamento
	//If !Empty(C9_NFISCAL)
	//	dbSelectArea("SC9")
	//	DbSkip()
	//	Loop
	//EndIf
	
	IF lEnd
		@PROW()+1,001 Psay "CANCELADO PELO OPERADOR"
		EXIT
	ENDIF
	
	dbSelectArea("SC5")     //Posiciona no Ped. de Venda
	dbSetOrder(1)
	dbSeek(xFilial()+SC6->C6_NUM )
	
	IF SC5->C5_TIPO$"DB" // Se pedido tipo Devolucao ou Beneficiamento, pula.
		dbSelectArea("SC6")
		DbSkip()
		Loop
	EndIf
	
	//IF Empty(SC5->C5_TRANSP) // Se campo Transp. Vazio, IMPOSSIVEL de prosseguir.
	//	dbSelectArea("SC9")
	//	DbSkip()
	//	Loop
	//EndIf
	
	//Testa o codigo da transportadora se esta dentro dos parametros.
	//IF SC5->C5_TRANSP < MV_PAR02 .OR. SC5->C5_TRANSP > MV_PAR03
	//	dbSelectArea("SC9")
	//	DbSkip()
	//	Loop
	//EndIf
	
	dbSelectArea("SA1")  //Posiciona Tabela Clientes
	dbSeek(xFilial()+SC6->(C6_CLI+C6_LOJA))
	
	GravaTRB()
	
	dbSelectArea("SC6")
	DbSkip()
End

dbSelectArea("TRB")
DbGotop()

//Testa se o arquivo TRB esta vazio ou sem registros.
_nQtReg := RecCount()
_lCont := .T.
If _nQtReg <= 0
	_lcont := .F.
Endif


//+-------------------------------------
//| EFETUA A IMPRESSAO DOS REGISTROS
//+-------------------------------------
dbSelectArea("TRB")
DbGoTop()
copy to trbvic

If _lCont
	CImpTRB()
Endif

//Finaliza o relatorio.
//If li != 80
//	roda(cbcont,cbtxt)
//Endif


Ferase(cIndex+OrdBagExt())

dbSelectArea("SC6")
Set Filter To
dbSetOrder(1)
dbGotop()

//Fecha o arquivo de trabalho
dbSelectArea("TRB")
dbClearFilter()
dbCloseArea()
Ferase(_cIndTRB+OrdBagExt())

//dbSelectArea("TMP")
//dbClearFilter()
//dbCloseArea()
//Ferase(_cIndTMP+OrdBagExt())

If ( aReturn[5] = 1 )
	dbCommitAll()
	OurSpool(wnrel)
Endif
MS_FLUSH()
Return(.T.)




//+-------------------------------------------------------------------
//| Funcao     : CImpTRB()
//+-------------------------------------------------------------------
//| Autor      : Vicente Lacerenza
//+-------------------------------------------------------------------
//| Descricao  : Efetua a impressao dos registros.
//+-------------------------------------------------------------------
Static Function CImpTRB()

//02/12/2002 - vicente lacerenza
//AJUSTA A ORDEM DO TEMPORARIO
//IndRegua("TRB",_cIndTRB,"DTOS(DATALIB)+TRANSP+CODOLD",,,"Criando Indice ...")
dbSelectArea("TRB")
DbGotop()
ProcRegua(RecCount())

While !Eof()
	
	FOR J:= 1 TO 2
		// Tratamento para reposicionar o pedido de venda se tiver que imprimir
		// a via com valores (controle financeiro).
		If J == 1
			_cReg := TRB->(Recno())
		ElseIf J == 2
			TRB->(DbGoto(_cReg))
		ENDIF
		
		IncProc()
		
		LI := 80
		_lPrivez := .F.
		_nVALTotM:= 0
		_nVALTotG:= 0
		_nVALTIpi:= 0
		_nVipi := 0
		_cTransp  := TRB->TRANSP
		_cEmissao := TRB->EMISSAO  	// Data emissao do pedido de venda c5_emissao
		_cTpPessoa:= TRB->TPPESSOA 	// Tipo de pessoa (F)isica/(J)uridica
		_cPedido  := TRB->PEDIDO   	// Nr. do pedido de vendas
		
		_cPlaca  := _cEndSA4 := _cBaiSA4 := _cMunSA4 := ""
		_cNomeSA4:=	_cCodiSA4:= ""
		
		_nLin := 0
		nItem      := 0 		
		While !Eof() .and. _cPedido == TRB->PEDIDO
		
			MaFisIni(TRB->CLIENTE,;							// 1-Codigo Cliente/Fornecedor
   		     TRB->LOJA,;			// 2-Loja do Cliente/Fornecedor
			 "C",;	// 3-C:Cliente , F:Fornecedor
			 TRB->C5TIPO,;				// 4-Tipo da NF
			 TRB->C5TIPOCLI,;			// 5-Tipo do Cliente/Fornecedor
			 aRelImp,;							// 6-Relacao de Impostos que suportados no arquivo
			 ,;						   			// 7-Tipo de complemento
			 ,;									// 8-Permite Incluir Impostos no Rodape .T./.F.
		 	 "SB1",;							// 9-Alias do Cadastro de Produtos - ("SBI" P/ Front Loja)
			 "MATA461")							// 10-Nome da rotina que esta utilizando a funcao
	                        
		MaFisAdd(TRB->PRODUTO,; 				  // 1-Codigo do Produto ( Obrigatorio )
				 TRB->TES,;					  // 2-Codigo do TES ( Opcional )
				 TRB->QTDVEN,;				  // 3-Quantidade ( Obrigatorio )
				 TRB->PRUNIT,;				  // 4-Preco Unitario ( Obrigatorio )
				 TRB->VALDESC,;                // 5-Valor do Desconto ( Opcional )
				 ,;							  	  // 6-Numero da NF Original ( Devolucao/Benef )
				 ,;								  // 7-Serie da NF Original ( Devolucao/Benef )
				 ,;					              // 8-RecNo da NF Original no arq SD1/SD2				
				 0,;							  // 9-Valor do Frete do Item ( Opcional )
				 0,;							  // 10-Valor da Despesa do item ( Opcional )	
				 0,;            				  // 11-Valor do Seguro do item ( Opcional )	
				 0,;							  // 12-Valor do Frete Autonomo ( Opcional )				  
				 (TRB->VALOR+TRB->VALDESC),;// 13-Valor da Mercadoria ( Obrigatorio )	
				 0,;							  // 14-Valor da Embalagem ( Opiconal )	
				 0,;		     				  // 15-RecNo do SB1		        
				 0) 							  // 16-RecNo do SF4
			nItem += 1		 	
			//+-------------------------------------------------
			//| Armazena a Aliq. do IPI. do item do produto
			//+-------------------------------------------------
			_nAliIPI 	:= 0
			_nIPI		:= 0		
			_nVipi		:= 0
			
			_nAliIPI := Posicione("SB1",1,xFilial("SB1")+TRB->PRODUTO,"B1_IPI")			
			If _nAliIPI > 0   // Se a Aliq. do IPI Maior que Zero
				
				//Posiciono no arquivo de TES
				dbSelectArea("SF4")
				dbSeek(xFilial()+TRB->TES)
				IF SF4->F4_IPI == "S"
					_nBaseIPI := IIF(SF4->F4_BASEIPI > 0,SF4->F4_BASEIPI,100)
					_nIPI 		:= _nAliIPI
					_nValBase := If(_lIPIBruto .And. TRB->PRUNIT > 0,TRB->PRUNIT,TRB->PRCVEN)*TRB->QTDVEN
					//VALOR DO IPI.
					_nVipi		:= NoRound(_nValBase * (_nIPI/100)*(_nBaseIPI/100),2)
				Endif
			Endif
			
			dbSelectArea("SA1")   //Posiciona Clientes
			dbSeek(xFilial()+TRB->(CLIENTE+LOJA) )
			
			dbSelectArea("SA3")   //Posiciona Vendedores
			dbSeek(xFilial()+TRB->VEND1 )
			
			dbSelectArea("SA4")   //Posiciona Tabela Transportadora
			dbSeek(xFilial()+TRB->TRANSP )
			_cNomeSA4:= SA4->A4_NOME
			_cCodiSA4:= SA4->A4_COD
			_cFoneSA4:= SA4->A4_TEL
			
			IncProc()
			
			If Li > 55
				Li:=0
				//cabec(titulo,Cabec1,Cabec2,nomeprog,tamanho) //Impressao do cabecalho
				Impcabec(Li) //Impressao do cabecalho
				Li:=09
				_lPrivez := .T.
			Else
				_lPrivez := .F.
			Endif
			
			If _lPrivez
				Li++
				@ Li,000 PSAY "Transportadora: " +TRB->TRANSP+"-"+Alltrim(_cNomeSA4)
				@ Li,080 PSAY "Telefone: "+_cFoneSA4
				Li++
				@ Li,000 PSAY "Condicao de Pagamento:"+Posicione("SE4",1,xFilial("SE4")+TRB->CONDPAG,"E4_DESCRI")
				_dYearTab := STR(Year(Posicione("DA0",1,xFilial("DA0")+TRB->TABELA,"DA0_DATDE")),4,0)
				if !Empty(Posicione("DA0",1,xFilial("DA0")+TRB->TABELA,"DA0_DESCRI"))
					_cDescTab := Alltrim(Substr(Posicione("DA0",1,xFilial("DA0")+TRB->TABELA,"DA0_DESCRI"),1,20))+"/"+_dYearTab
				Else
					_cDescTab := "***"
				Endif
				@ Li,040 PSAY "Tabela: "+_cDescTab
				If 	!Empty(TRB->XCARBCO)
					@ Li,080 PSAY "Banco: " +iif(TRB->XCARBCO == "C","CARTEIRA","BANCO")
				else
					@ Li,080 PSAY "Banco: "
				Endif
				Li++
				@ Li,000  PSAY Replicate("=",Limite-5)
				Li ++
				IF J == 1
					@ Li,013 PSAY "REFERENCIA        QTD.  UNID.   DESCRICAO "
				ELSEIF J == 2
					@ Li,013 PSAY "REFERENCIA        QTD.  UNID.   DESCRICAO                                PRECO BRUTO  DESC.  PRECO LIQ. %IPI. TOTAL MERC."
					//                                             XXXXXXXXX-XXXXXXXXX-XXXXXXXXX-XXXXXXXXXX
				ENDIF
				
				Li ++
				@ Li,000  PSAY Replicate("-",Limite-5)
				lCabec := .F.
			Endif
			_nLin++
			Li ++                                       
			
			@ Li,000  PSAY StrZero(_nLin,2)+"|(  ) (  ) "+Substr(TRB->REFEREN,1,15)+" |"
			@ Li,031  PSAY TRB->QTDVEN Picture "9999"
			@ Li,037  PSAY "|"+TRB->UNID+"|"
		  	If J == 1
				@ Li,045  PSAY Substr(TRB->DESC,1,40)+" |"+space(15)+"|"+space(15)+"|"
			ElseIf J == 2
				@ Li,045  PSAY Substr(TRB->DESC,1,40)+" |"
			EndIf

			IF J == 2
				_nPRUNIT	:= (TRB->VALDESC+TRB->VALOR)/TRB->QTDVEN //TRB->PRCVEN
				@ Li,089  PSAY _nPRUNIT  		Picture "@E 9,999.99"	+" |"
				@ Li,099  PSAY TRB->DESCONT 	Picture "@E 99.99"+"%"	+" |"
				@ Li,107  PSAY TRB->PRCVEN 		Picture "@E 9,999.99"	+" |"
				@ Li,117  PSAY _nAliIPI			Picture "@E 99.99"		+" |"
				@ Li,124  PSAY TRB->VALOR  		Picture "@E 99,999.99"
			ENDIF
						
			Li ++                                       
			@ Li,000  PSAY Replicate("-", limite-5)	

			_nIcm := MaFisRet(nItem,"IT_ALIQICM") //Picture "@e 99.99" //Aliq de ICMS			
			//alert(str(_nicm))
			
			_nVALTotM += TRB->VALOR  		//TOTAL MERCADORIA
			_nVALTotG += TRB->VALOR+_nVipi  //TOTAL MERCADORIA+IPI
			_nVALTIpi += _nVipi  			//TOTAL IPI
			
			dbSelectArea("TRB")
			DbSkip()
		Enddo
		
		if _nLin < 30
			For i := (_nLin+1) to 15
				Li ++
				If J == 1
					@ Li,000  PSAY StrZero(i,2)+"|(  ) (  )"+space(17)+"|"+space(7)+"|"+space(2)+"|"+space(45)+"|"+space(15)+"|"+space(15)+"|"
				ElseIf J == 2
					@ Li,000  PSAY StrZero(i,2)+"|(  ) (  )"+space(17)+"|"+space(7)+"|"+space(2)+"|"+space(45)+"|"+space(11)+"|"+space(7)+"|"+space(9)+"|"+space(6)+"|"
				EndIf
				Li ++
				@ Li,000  PSAY Replicate("-", limite-5)	
			next i
		Endif
		
		dbSelectArea("TRB")
		Li ++
		@ Li,000  PSAY Replicate("-",Limite-5)
		Li +=2
		//IF J == 2					
			@ Li,000  PSAY "Total ICMS.: "+Transform((_nVALTotM*(_nIcm/100)),"@E 99,999.99")			
			@ Li,030  PSAY "Total IPI.: "+Transform(_nVALTIpi,"@E 99,999.99")
			@ Li,095  PSAY "Total Mercadorias: "+Transform(_nVALTotM,"@E 999,999.99")
			Li ++
			@ Li,101  PSAY "Total Geral: "+Transform(_nVALTotG,"@E 999,999.99")
		//ELSE
		//	Li ++
		//ENDIF
		
		Li +=3
		@ Li,000  PSAY "Observacoes:"
		Li +=2
		@ Li, 000 PSAY chr(18)                   // Descompressao de Impressao
		@ Li,000  PSAY "A T E N D I D O"
		@ LI, 000 PSAY CHR(15)+ Chr(27) + "P"           // Compactacao
		Li +=2
		@ Li,000  PSAY Replicate("-",Limite-5)
		Li +=2
		@ Li,000  PSAY "Peso: __________                No. Volumes: _________                 Etiquetas: (     )"
		Li +=3
		@ Li,000  PSAY "________________     ______________    ______________     __________________    ____/____/______"
		Li ++
		@ Li,000  PSAY "Aprovado Pedido      Conferido         Embalado           Aprovado Fatura       Data de Saida   "
		Li ++
		
		MaFisEnd()
		nItem := 0 
		
		
	NEXT J
	
Enddo

/*
Li+=10
@ Li, 000 PSAY chr(18)                   // Descompressao de Impressao
Li++
@ Li,000 PSAY ""
//EJECT
SetPrc(0,0)                              // (Zera o Formulario)
*/                                                             

Li+=5
@ Li, 000 PSAY chr(18)                   // Descompressao de Impressao
Li = Li + 1
@ Li,000 PSAY ""
//EJECT
SetPrc(0,0)                              // (Zera o Formulario)


Return

//+-------------------------------------------------------------------
//| Funcao     : GravaTRB
//+-------------------------------------------------------------------
//| Autor      : Vicente Lacerenza
//+-------------------------------------------------------------------
//| Descricao  : Efetua a gravacao do arq. temporario.
//+-------------------------------------------------------------------
Static Function GravaTRB()
Local _cNomCli,_cEndCli,_cBaiCli
Local _lGrava := .T.
_nQtdLib := 0

dbSelectArea("TRB")
//_nQtdLib := SC9->C9_QTDLIB
//If DbSeek(DTOS(SC9->C9_DATALIB)+SC5->C5_TRANSP+SC9->C9_PRODUTO )
//	_lGrava  := .F.
//	_nQtdLib := TRB->QTDLIB + SC9->C9_QTDLIB
//Endif

RecLock("TRB",_lGrava)
TRB->TRANSP  	:= SC5->C5_TRANSP
TRB->PRODUTO 	:= SC6->C6_PRODUTO
TRB->REFEREN 	:= Posicione("SB1",1,xFilial("SB1")+SC6->C6_PRODUTO,"B1_REFEREN")
TRB->UNID    	:= SC6->C6_UM
TRB->PEDIDO 	:= SC6->C6_NUM
TRB->ITEMPV		:= SC6->C6_ITEM
TRB->CLIENTE	:= SC6->C6_CLI
TRB->LOJA		:= SC6->C6_LOJA
TRB->QTDVEN		:= SC6->C6_QTDVEN
TRB->PRUNIT		:= SC6->C6_PRUNIT   // PRECO LISTA
TRB->PRCVEN	   := SC6->C6_PRCVEN   // PRECO UNITARIO LIQ. ITEM
TRB->VALOR	   := SC6->C6_VALOR    // VALOR TOTAL DO ITEM
TRB->DESCONT   := SC6->C6_DESCONT  // % DESCONTO DO ITEM
TRB->VALDESC    := SC6->C6_VALDESC  // VLR DESCONTO DO ITEM
TRB->DESC		:= Posicione("SB1",1,xFilial("SB1")+SC6->C6_PRODUTO,"B1_DESC")
TRB->EMISSAO 	:= SC5->C5_EMISSAO   //Emissao do pedido de venda
TRB->TPPESSOA	:= IIf(SUBSTR(SA1->A1_CGC,12,3)=='   ',"F","J")
TRB->VEND1	 	:= SC5->C5_VEND1
TRB->CONDPAG	:= SC5->C5_CONDPAG
TRB->TABELA 	:= SC5->C5_TABELA
TRB->TES    	:= SC6->C6_TES
TRB->XCARBCO   	:= SC5->C5_XCARBCO  // C=Carteira B=Banco
TRB->C5TIPO   	:= SC5->C5_TIPO
TRB->C5TIPOCLI	:= SC5->C5_TIPOCLI
MsUnLock()

Return

//+-------------------------------------------------------------------
//| Funcao     : ImpCabec()
//+-------------------------------------------------------------------
//| Autor      : Vicente Lacerenza
//+-------------------------------------------------------------------
//| Descricao  : Imprime o cabecalho do relatorio
//+-------------------------------------------------------------------
Static Function ImpCabec(Li)
Local cHeader	:= ""

cHeader := "Data Impressao: "+DtoC(dDatabase)+" -"+nomeprog+space(10)+;
"Data do Pedido: "+DtoC(_cEmissao)+Space(17)+" PEDIDO PESSOA "+;
Iif(_cTpPessoa=="J","JURIDICA","FISICA")+" No. "//+_cPedido

// Segue abaixo, padrao Epson para impressao com 17 cpp

@ 00, 000 PSAY Chr(27)+"2"                      // Impressao em 1/6
@ 00, 000 PSAY Chr(27)+"M"                      // Compressao Impressao A 12 CPP.
@ 00, 000 PSAY chr(18)                          // Descompressao de Impressao
@ 00, 000 PSAY CHR(15)+ Chr(27) + "P"           // Compactacao
@ 01,000 psay cHeader
@ 01,122 psay CHR(18)+_cPedido+CHR(15)+ Chr(27) + "P"

@ 02,000 psay Replicate("=",Limite-5)
@ 03,000 psay "CLIENTE : "+SA1->A1_NOME
@ 04,000 psay "ENDERECO: "+SA1->A1_END
@ 05,000 psay "CIDADE  : "+SA1->A1_MUN
@ 05,050 psay "ESTADO  : "+SA1->A1_EST
//@ 05,080 psay "CEP : "+SA1->A1_CEP Picture "@R 99999-999"           // CEP
@ 05,080 psay "CEP : "
@ 05,088 psay SA1->A1_CEP Picture "@R 99999-999"           // CEP
@ 06,000 psay "TELEFONE: "+"("+SA1->A1_DDD+")"+SA1->A1_TEL
@ 06,050 psay "CONTATO: "+SA1->A1_CONTATO PICTURE "@!"
@ 06,080 psay "VENDEDOR:"+TRB->VEND1+"-"+Substr(SA3->A3_NOME,1,30)
@ 07,000 psay "CNPJ/CPF: "
@ 07,010 psay IIf(SUBSTR(SA1->A1_CGC,12,3)=='   ',TRANSFORM(SA1->A1_CGC,"@R 999.999.999-99"),TRANSFORM(SA1->A1_CGC,"@R 99.999.999/9999-99"))
@ 07,080 psay "INSC. ESTADUAL: "+SA1->A1_INSCR
@ 08,000 psay Replicate("-",Limite-5)
//          0         1         2         3         4         5         6         7         8         9        10        11        12        13        14
//          0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234

Return



//+-------------------------------------------------------------------
//| Funcao     : ValidPerg
//+-------------------------------------------------------------------
//| Autor      : Vicente Lacerenza
//+-------------------------------------------------------------------
//| Descricao  : Verifica as perguntas incluindo-as caso nao existam
//+-------------------------------------------------------------------
Static Function ValidPerg
_sAlias := Alias()
dbSelectArea("SX1")
dbSetOrder(1)
_cPerg := PADR(_cPerg,10)
aRegs:={}

aAdd(aRegs,{_cPerg,"01","Do Pedido          ?","","","mv_ch1","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{_cPerg,"02","Ate o Pedido       ?","","","mv_ch2","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{_cPerg,"03","Do Cliente         ?","","","mv_ch3","C",06,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SA1","",""})
aAdd(aRegs,{_cPerg,"04","Ate o Cliente      ?","","","mv_ch4","C",06,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SA1","",""})
aAdd(aRegs,{_cPerg,"05","Da Loja            ?","","","mv_ch5","C",02,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{_cPerg,"06","Ate a Loja         ?","","","mv_ch6","C",02,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

For i:=1 to Len(aRegs)
	If !dbSeek(_cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			FieldPut(j,aRegs[i,j])
		Next
		MsUnlock()
		dbCommit()
	Endif
Next

dbSelectArea(_sAlias)

Return
