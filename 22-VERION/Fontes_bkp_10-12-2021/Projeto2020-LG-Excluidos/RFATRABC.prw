#INCLUDE "rwmake.ch"
//------------------------------------------------------------------------------
// EMPRESA	 : CRD INFORMATICA
// PROGRAMA  : RFATRABC.PRW
// DESCRICAO : Gera relatorio de curva ABC
// CLIENTE	 : ESPECIFICO PARA MEGALIGHT
// AUTOR     : ROQUE WAGNER DE OLIVEIRA
// DATA      : 11/11/2003
//------------------------------------------------------------------------------
User Function RFATRABC()

//**************************************************************************************
//                              Define Variaveis
//**************************************************************************************
cabec1     := "Produto      Descricao                       Grupo          Qtde       Valor Total     Prc Medio       % no Fat      Valor Dev      Producao "
cabec2	   := ""
wnrel      := "RFATABC"
Titulo     := "Curva ABC dos Produtos Vendidos"
cDesc1     := "Este relatorio vai emitir uma Curva ABC DE PRODUTOS"
cDesc2     := ""
cDesc3     := ""
cString    := "SD2"
nElementos := 0
nLastKey   := 0
aReturn    := { "Especial", 1,"Faturamento", 2, 2, 1, "", 1}
nomeprog   := "RFATRABC"
cPerg      := "RFATAB    "
_nLin      := 80
tamanho    := "M"
m_pag      := 1
nTipo      := 15
_wCod      := space(10)

//**************************************************************************************
//                     Verifica as perguntas selecionadas
//**************************************************************************************
ValidPerg()
pergunte(cPerg,.F.)

//**************************************************************************************
//                    Envia controle para a funcao SETPRINT
//**************************************************************************************
wnrel:=SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.F.,"","","","",.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

//**************************************************************************************
//                                Rotina RptDetail
//**************************************************************************************
RptStatus({|| RptDetail()})
Return

Static Function RptDetail()
//---------------------------------------------------------------------------
//³ Define Variaveis                                     ³
//---------------------------------------------------------------------------
_aStru    := {}
AADD(_aStru,{"T_CODPROD"   ,"C",15,0 })
AADD(_aStru,{"T_GRUPO"     ,"C",04,0 })
AADD(_aStru,{"T_DESCRI"    ,"C",30,0 })
AADD(_aStru,{"T_QTD"       ,"N",14,4 })
AADD(_aStru,{"T_VALOR"     ,"N",15,2 })
AADD(_aStru,{"T_DEVOLU"    ,"N",17,5 })
AADD(_aStru,{"T_PRODUCAO"  ,"N",17,5 })

_cArq1 := CriaTrab(_aStru,.T.)
dbUseArea(.T.,,_cArq1,"TRA",.T.,.F.)
Indregua("TRA",_cArq1,"TRA->T_CODPROD",,,"Criando arquivo Temporario")

_cArq2 := CriaTrab(_aStru,.T.)
dbUseArea(.T.,,_cArq2,"TRB",.T.,.F.)
Indregua("TRB",_cArq2,"TRB->T_GRUPO + TRB->T_CODPROD",,,"Criando arquivo Temporario")

_nTotQtd := 0
_nTotalF := 0 // Total final utilizado na impressao
cDupli   := If( (MV_PAR07 == 1),"S",If( (MV_PAR07 == 2),"N","SN" ) )
cEstoq   := If( (MV_PAR08 == 1),"S",If( (MV_PAR08 == 2),"N","SN" ) )

Dbselectarea("SD2")
DBsetorder(5)          // Indice por data de emissao
Set Softseek on
Dbseek(xFilial("SD2") + Dtos(mv_par01))
Set Softseek off

While !Eof() .And. SD2->D2_EMISSAO <= mv_par02

	_nTOTAL   := 0  //TOTAL DE COMPRA
	_nQTD     := 0  // QTD COMPRADA
	_nTOTDEV  := 0
	
	If SD2->D2_COD < MV_PAR03 .OR. SD2->D2_COD > MV_PAR04
		Dbskip()
		Loop
	Endif

	If SD2->D2_GRUPO < MV_PAR05 .OR. SD2->D2_GRUPO > MV_PAR06
		Dbskip()
		Loop
	Endif

    // ACHA ORDEM DE PRODUCAO                 
    _WPROD    := SD2->D2_COD
	_NVERPROD := 0
	dbSelectArea("SD3")
	DBSETORDER(3)
	IF dbSeek(xFilial("SD3")+_WPROD)
		WHILE !EOF() .AND. _WPROD == SD3->D3_COD
			
			IF SD3->D3_EMISSAO < MV_PAR01 .OR. SD3->D3_EMISSAO > MV_PAR02
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
    
	If AvalTes(SD2->D2_TES,cEstoq,cDupli)
		// Primeiro, verifica se o pedido ja eh ZZZ, o pedido tem o ultimo digito como uma letra, se for
		// jah quarda a quantidade e segue para guardar o valor;
		// Se o pedido for normal (sem o ultimo digito como letra), faz a montagem do numero do pedido e 
		// faz a pesquisa para saber se existe um complemento dele (ZZZ), se encontrar NAO quarda a quantidade
		// porque o farah quando passar no pedido ZZZ, (com o ultimo digito como letra), guardando assim
		// somente o valor para fins de faturamento, caso contrario guarda a quantidade porque eh um faturamento
		// normal

		If SUBSTR(SD2->D2_PEDIDO,6,1) == "A"
			_nQTD := SD2->D2_QUANT   //TOTAL DE COMPRA
		Else
	
			_cPed := SUBSTR(SD2->D2_PEDIDO,2,5) + "A"
	
			Dbselectarea("SC5")
			DBsetorder(1)          // Indice por numero do pedido
			If !Dbseek(xFilial("SC5") + _cPed)
				_nQTD := SD2->D2_QUANT   //TOTAL DE COMPRA
			Endif
		Endif
		
		_nTOTAL := SD2->D2_TOTAL  //QTD COMPRADA
	Endif

	Dbselectarea("SD2")
	DBsetorder(5)          // Indice por data de emissao

	If MV_PAR09 == 1
		_nTOTDEV := SD2->D2_VALDEV
	Endif

	If _nTotal > 0 .OR. _NVERPROD > 0
		Dbselectarea("SB1")
		DBsetorder(1)          // Indice por vendedor
		Dbseek(Xfilial("SB1") + SD2->D2_COD)
		_cProduto := SB1->B1_DESC
		
		Dbselectarea("TRA")
		If Dbseek(SD2->D2_COD)
			RecLock("TRA",.F.)
			TRA->T_QTD    		:= TRA->T_QTD    + _nQTD
			TRA->T_VALOR    	:= TRA->T_VALOR  + _nTOTAL
			TRA->T_DEVOLU		:= TRA->T_DEVOLU + _nTOTDEV
			MsUnLock("TRA")
		Else
			RecLock("TRA",.T.)
			TRA->T_CODPROD  	:= SD2->D2_COD
			TRA->T_GRUPO	  	:= SD2->D2_GRUPO
			TRA->T_DESCRI		:= _cproduto
			TRA->T_QTD    		:= _nQTD
			TRA->T_DEVOLU 		:= _nTOTDEV
			TRA->T_VALOR     	:= _nTOTAL
			TRA->T_PRODUCAO     := _NVERPROD
			MsUnLock("TRA")
		Endif
	
		_nTotQtd := _nTotQtd + _nQtd
		_nTotalF := _nTotalF + _nTotal
   
   Endif
   
	Dbselectarea("SD2")
	Dbsetorder(5)
	Dbskip()
End

// faz a impressao do pedido
Dbselectarea("TRA")
dbgotop()

SetRegua(RecCount())

If MV_PAR11 == 1

	If mv_par10 == 1
		Indregua("TRA",_cArq1,"Descend(STR(TRA->T_QTD,14,4))",,,"Criando arquivo Temporario")
	Else
		Indregua("TRA",_cArq1,"Descend(STR(TRA->T_VALOR,15,2))",,,"Criando arquivo Temporario")
	Endif

	_nTOTDEV := 0
	_I       := 1
	_cflag   := 1
	
	While !Eof()

		IncRegua()     // Termometro de Impressao
		
		If _nLin > 60
			Titulo := "Curva ABC dos produtos de: " + DTOC(MV_PAR01) + " Ate " + DTOC(MV_PAR02)
			_nLin := cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
			_nLin++
			If _cflag == 1
				IF mv_par10 == 1
					@ _nLin, 001 PSay "20 Mais Vendidos por Quantidade"
					_nLin+=2
				Else
					@ _nLin, 001 PSay "20 Mais Vendidos por Valor"
					_nLin+=2
				Endif
			Endif
		Endif

		_cflag  := 0					// Zera para nao entrar na descricao do cabecalho
		If _I == 21
			_nLin++
			@ _nLin, 001 PSay Replicate("_",220)
			_nLin+=2
		Else
			_nLin++
		Endif
		
		@ _nLin, 000 PSay SUBSTR(TRA->T_CODPROD,1,12)
		@ _nLin, 013 PSay TRA->T_DESCRI
		@ _nLin, 045 PSay TRA->T_GRUPO
		@ _nLin, 050 PSay TRA->T_QTD							                    PICTURE "@E 999,999,999.99"
		@ _nLin, 068 PSay TRA->T_VALOR												PICTURE "@E 999,999,999.99"
		@ _nLin, 086 PSay (TRA->T_VALOR / TRA->T_QTD)								PICTURE "@E 999,999.99"
		
		_cPorcen := (TRA->T_VALOR * 100) / _nTotalF
		
		@ _nLin, 102 PSay	_cPorcen												PICTURE "@E 999.9999%"
		
		If MV_PAR09 == 1
			@ _nLin, 112 PSay TRA->T_DEVOLU										    PICTURE "@E 999,999,999.99"
			_nTOTDEV := _nTOTDEV + TRA->T_DEVOLU
		Endif
			@ _nLin, 122 PSay TRA->T_PRODUCAO									    PICTURE "@E 999,999,999.99"		
	
		_I++
		
		Dbselectarea("TRA")
		DbSkip()
	End
	
Else

	_nTOTDEV := 0
	_cflag   := 1
	
	While !Eof()

		IncRegua()     // Termometro de Impressao
		
		If _nLin > 60
			Titulo := "Curva ABC dos produtos de: " + DTOC(MV_PAR01) + " Ate " + DTOC(MV_PAR02)
			_nLin := cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
			_nLin++
			If _cflag ==1
				IF mv_par10 == 1
					@ _nLin, 000 PSay "Vendidos por Quantidade"
					Indregua("TRB",_cArq2,"Descend(STR(TRB->T_QTD,14,4))",,,"Criando arquivo Temporario")
					_nLin+=2
				Else
					@ _nLin, 000 PSay "Vendidos por Valor"
					Indregua("TRB",_cArq2,"Descend(STR(TRB->T_VALOR,15,2))",,,"Criando arquivo Temporario")
					_nLin+=2
				Endif
			Endif
		Endif

		Dbselectarea("TRA")

		If _cflag == 0
			If MV_PAR12 == 1
				_nLin		:= 80
				_cflag	:= 0					// Zera para nao entrar na descricao do cabecalho e a quebra por grupo
			Endif
		Endif

		_nQtdGrup := 0
		_nValGrup := 0
		_nDevGrup := 0
		_cGrupo   := TRA->T_GRUPO
		While !Eof() .AND. TRA->T_GRUPO == _cGrupo

			If _nLin > 60
				_nLin := cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
				_nLin++
			Endif

			_cProd	 := SUBSTR(TRA->T_CODPROD,1,6)
			While !Eof() .AND. SUBSTR(TRA->T_CODPROD,1,6) == _cProd
				Dbselectarea("TRB")
				RecLock("TRB",.T.)
				TRB->T_CODPROD  	:= TRA->T_CODPROD
				TRB->T_GRUPO	  	:= TRA->T_GRUPO
				TRB->T_DESCRI		:= TRA->T_DESCRI
				TRB->T_QTD    		:= TRA->T_QTD
				TRB->T_DEVOLU 		:= TRA->T_DEVOLU
				TRB->T_VALOR     	:= TRA->T_VALOR
				TRB->T_PRODUCAO     := TRA->T_PRODUCAO
				MsUnLock()
	
				Dbselectarea("TRA")
				DbSkip()
			End
			
			_cflag	  := 0					// Zera para nao entrar na descricao do cabecalho e a quebra por grupo			
			_nQtdProd := 0
			_nValProd := 0
			_nDevPRod := 0

			Dbselectarea("TRB")
			DbGotop()
		
			While !Eof()
	
				If _nLin > 60
					_nLin := cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
					_nLin++
				Endif

				@ _nLin, 000 PSay TRB->T_CODPROD
				@ _nLin, 018 PSay TRB->T_DESCRI
				@ _nLin, 052 PSay TRB->T_GRUPO
				@ _nLin, 060 PSay TRB->T_QTD							                     PICTURE "@E 999,999,999.99"
				@ _nLin, 079 PSay TRB->T_VALOR													PICTURE "@E 999,999,999.99"
				
				_cPorcen := (TRB->T_VALOR * 100) / _nTotalF
				
				@ _nLin, 102 PSay	_cPorcen															PICTURE "@E 999.9999%"
				
				If MV_PAR09 == 1
					@ _nLin, 112 PSay TRB->T_DEVOLU											   PICTURE "@E 999,999,999.99"
					_nTOTDEV := _nTOTDEV + TRB->T_DEVOLU
				Endif

					@ _nLin, 122 PSay TRB->T_PRODUCAO									    PICTURE "@E 999,999,999.99"
				_nLin++



				_nQtdProd := _nQtdProd + TRB->T_QTD
				_nValProd := _nValProd + TRB->T_VALOR
				_nDevPRod := _nDevPRod + TRB->T_DEVOLU

				Dbselectarea("TRB")
				DbSkip()

		   End

			Dbselectarea("TRB")
			DbGotop()
			While !Eof()

				Dbselectarea("TRB")
				RecLock("TRB",.F.)
				 DELETE
				MsUnLock()
				DbSkip()

		    End

			Dbselectarea("TRA")				// Volta ao Alias principal para controle do grupo

			If _nLin > 58
				_nLin := cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
				_nLin++
			Endif

			_nLin++
			@ _nLin, 000 PSay "TOTAL DO PRODUTO:"
			@ _nLin, 060 PSay _nQtdProd						      				 PICTURE "@E 999,999,999.99"
			@ _nLin, 075 PSay _nValProd						      				 PICTURE "@E 999,999,999,999.99"
			_nLin++
			
			If MV_PAR09 == 1
				@ _nLin, 000 PSay "TOTAL DE DEVOLUCAO DO PRODUTO"
				@ _nLin, 108 PSay _nDevProd										    PICTURE "@E 999,999,999,999.99"
				_nLin++
			Endif

			_nLin++

			_nQtdGrup := _nQtdGrup + _nQtdProd
			_nValGrup := _nQtdGrup + _nValProd
			_nDevGrup := _nQtdGrup + _nDevPRod

		End

		If _nLin > 58
			_nLin := cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
			_nLin++
		Endif

		@ _nLin, 000 PSay "TOTAL DO GRUPO:"
		@ _nLin, 060 PSay _nQtdGrup						      				 PICTURE "@E 999,999,999.99"
		@ _nLin, 075 PSay _nValGrup						      				 PICTURE "@E 999,999,999,999.99"
		_nLin++
		
		If MV_PAR09 == 1
			@ _nLin, 000 PSay "TOTAL DE DEVOLUCAO DO GRUPO"
			@ _nLin, 108 PSay _nDevGrup										    PICTURE "@E 999,999,999,999.99"
			_nLin++
		Endif

		@ _nLin, 000 PSay Replicate("_",220)
		_nLin++
	End
Endif

If _nLin > 58
	_nLin := cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
	_nLin++
Endif

_nLin+=2
@ _nLin, 000 PSay "TOTAL DE VENDAS:"
@ _nLin, 050 PSay _nTotQtd							      				 PICTURE "@E 999,999,999.99"
@ _nLin, 063 PSay _nTotalF							      				 PICTURE "@E 999,999,999,999.99"

If MV_PAR09 == 1
	_nLin++
	@ _nLin, 000 PSay "TOTAL DE DEVOLUCAO"
	@ _nLin, 108 PSay _nTotDev											    PICTURE "@E 999,999,999,999.99"
Endif

Dbselectarea("TRA")
DBCloseArea()

Ferase(_cArq1+".DBF")
Ferase(_cArq1+OrdBagExt())

Dbselectarea("TRB")
DBCloseArea()

Ferase(_cArq2+".DBF")
Ferase(_cArq2+OrdBagExt())

Dbselectarea("SD2")
DBsetorder(1)

SetPgEject(.F.)
If aReturn[5] == 1
	Set Printer TO
	dbcommitAll()
	ourspool(wnrel)
Endif
MS_FLUSH()
Return

//-------------------------------------------------------------------
//  Valida Perguntas
//-------------------------------------------------------------------
Static Function ValidPerg()

_sAlias := Alias()
dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,10)
aRegs := {}

//------------------------------------------------------------------------------------
//  Variaveis utilizadas para parametros
//------------------------------------------------------------------------------------
//   mv_par01                 // dt emissao
//   mv_par02                 // Ate dt emissao
//   mv_par03                 // De Produto
//   mv_par04                 // Ate Produto
//   mv_par05                 // De Grupo
//   mv_par06                 // Ate Grupo
//   Mv_par07                 // Tes Financeiro					(Gera financeiro / Nao gera)
//   Mv_par08                 // Tes Estoque						(Movimenta / Nao movimenta)
//   Mv_par09                 // Considera devolucao			(Sim/Nao)
//   Mv_par10                 // Ordenado Por					(Quantidade/Valor)
//   Mv_par11                 // Mostra Itens zerados			(Sim/Nao)
//   Mv_par12                 // Imprime relatorio 			(20 Mais Vendidos / Por Grupo)
//   Mv_par13                 // Quebra pag por grupo			(Sim / Nao)
//------------------------------------------------------------------------------------
AADD(aRegs,{cPerg,"01","Data Emissao                ?","","","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Ate Emissao                 ?","","","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"03","De Produto                  ?","","","mv_ch3","C",15,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SB1","",""})
AADD(aRegs,{cPerg,"04","Ate Produto                 ?","","","mv_ch4","C",15,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SB1","",""})
AADD(aRegs,{cPerg,"05","De Grupo                    ?","","","mv_ch5","C",04,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","SBM","",""})
AADD(aRegs,{cPerg,"06","Ate Grupo                   ?","","","mv_ch6","C",04,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","SBM","",""})
AADD(aRegs,{cPerg,"07","TES Financeiro              ?","","","mv_ch7","N",01,0,0,"C","","mv_par07","Gera Financeiro","","","","","Nao Gera ","","","","","Considera Ambas","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"08","TES Estoque                 ?","","","mv_ch8","N",01,0,0,"C","","mv_par08","Movimenta","","","","","Nao Movimenta","","","","","Considera Ambas","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"09","Consid. Devolucao           ?","","","mv_ch9","N",01,0,0,"C","","mv_par09","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"10","Ordenado por                ?","","","mv_chA","N",01,0,0,"C","","mv_par10","Quantidade","","","","","Valor","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"11","Imprime Relatorio           ?","","","mv_chB","N",01,0,0,"C","","mv_par11","20 Mais Vendidos","","","","","Por Grupo","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"12","Quebra pag por Grupo        ?","","","mv_chC","N",01,0,0,"C","","mv_par12","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","","",""})

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

dbSelectArea(_sAlias)

Return