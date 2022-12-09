#INCLUDE "rwmake.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MEG001C   � Autor � RICARDO CAVALINI  � Data �  7/10/08    ���
�������������������������������������������������������������������������͹��
���Descricao � Relacao de Producao mais comprados.                        ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function MEG001C()

//**************************************************************************************
//                              Define Variaveis
//**************************************************************************************
cabec1     :="Produto      Descricao                       Grupo          Qtde       Valor Total     Prc Medio       Ultimo Preco"
cabec2	  :=""
wnrel      :="MEG001C"
Titulo     :="Relacao do Produtos mais comprados"
cDesc1     :="Este relatorio vai emitir conforme escolha do cliente"
cDesc2     :="Posicao dos produtos mais comprados-MEG001C"
cDesc3     :=""
cString    :="SD1"
nElementos := 0
nLastKey   := 0
aReturn    := { "Especial", 1,"Faturamento", 2, 2, 1, "", 1}
nomeprog   := "MEG001C"
cPerg      := "MEG01C    "
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
//� Define Variaveis                                     �
//---------------------------------------------------------------------------

_aStru    := {}
AADD(_aStru,{"T_CODPROD"   ,"C",15,0 })
AADD(_aStru,{"T_GRUPO"     ,"C",04,0 })
AADD(_aStru,{"T_DESCRI"    ,"C",30,0 })
AADD(_aStru,{"T_QTD"       ,"N",14,4 })
AADD(_aStru,{"T_VALOR"     ,"N",15,2 })
AADD(_aStru,{"T_UVALO"     ,"N",15,2 })

_cArq1 := CriaTrab(_aStru,.T.)
dbUseArea(.T.,,_cArq1,"TRA",.T.,.F.)
Indregua("TRA",_cArq1,"TRA->T_CODPROD",,,"Criando arquivo Temporario")

_cArq2 := CriaTrab(_aStru,.T.)
dbUseArea(.T.,,_cArq2,"TRB",.T.,.F.)
Indregua("TRB",_cArq2,"TRB->T_GRUPO + TRB->T_CODPROD",,,"Criando arquivo Temporario")

//---------------------------------------------------------------------------
_nTotQtd := 0
_nTotalF := 0 // Total final utilizado na impressao
cDupli   := If( (MV_PAR07 == 1),"S",If( (MV_PAR07 == 2),"N","SN" ) )
cEstoq   := If( (MV_PAR08 == 1),"S",If( (MV_PAR08 == 2),"N","SN" ) )

Dbselectarea("SD1")
DBsetorder(3)          // Indice por data de emissao
Set Softseek on
Dbseek(xFilial("SD1") + Dtos(mv_par01))
Set Softseek off

While !Eof() .And. SD1->D1_EMISSAO <= mv_par02

	_nTOTAL   := 0  //TOTAL DE COMPRA
	_nQTD     := 0  // QTD COMPRADA
	_nTOTDEV  := 0
	
	If SD1->D1_COD < MV_PAR03 .OR. SD1->D1_COD > MV_PAR04
		Dbskip()
		Loop
	Endif

	If SD1->D1_GRUPO < MV_PAR05 .OR. SD1->D1_GRUPO > MV_PAR06
		Dbskip()
		Loop
	Endif

	If AvalTes(SD1->D1_TES,cEstoq,cDupli)
		_nQTD   := SD1->D1_QUANT   //qtd DE COMPRA
		_nTOTAL := SD1->D1_TOTAL   //vlr COMPRA
	Endif

	Dbselectarea("SD1")
	DBsetorder(3)          // Indice por data de emissao


	If _nTotal > 0
		Dbselectarea("SB1")
		DBsetorder(1)          // Indice por vendedor
		Dbseek(Xfilial("SB1") + SD1->D1_COD)
		_cProduto := SB1->B1_DESC 
		_nUVLR    := SB1->B1_UPRC
		
		Dbselectarea("TRA")
		If Dbseek(SD1->D1_COD)
			RecLock("TRA",.F.)
			TRA->T_QTD    		:= TRA->T_QTD    + _nQTD
			TRA->T_VALOR    	:= TRA->T_VALOR  + _nTOTAL
			MsUnLock()
		Else
			RecLock("TRA",.T.)
			TRA->T_CODPROD  	:= SD1->D1_COD
			TRA->T_GRUPO	  	:= SD1->D1_GRUPO
			TRA->T_DESCRI		:= _cproduto
			TRA->T_QTD    		:= _nQTD
			TRA->T_VALOR     	:= _nTOTAL
			TRA->T_UVALO     	:= _nUVLR
			MsUnLock()
		Endif
	
		_nTotQtd := _nTotQtd + _nQtd
		_nTotalF := _nTotalF + _nTotal
   
   Endif
   
	Dbselectarea("SD1")
	Dbsetorder(3)
	Dbskip()
	
Enddo

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
					@ _nLin, 001 PSay "20 Mais Comprados por Quantidade"
					_nLin+=2
				Else
					@ _nLin, 001 PSay "20 Mais Comprados por Valor"
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
		@ _nLin, 050 PSay TRA->T_QTD							                     PICTURE "@E 999,999,999.99"
		@ _nLin, 068 PSay TRA->T_VALOR													PICTURE "@E 999,999,999.99"
		@ _nLin, 086 PSay (TRA->T_VALOR / TRA->T_QTD)								PICTURE "@E 999,999.99"
		@ _nLin, 104 PSay TRA->T_UVALO													   PICTURE "@E 999,999,999.99"		
	
		_I++
		
		Dbselectarea("TRA")
		DbSkip()
		
	Enddo
	
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
					@ _nLin, 000 PSay "Comprados por Quantidade"
					Indregua("TRB",_cArq2,"Descend(STR(TRB->T_QTD,14,4))",,,"Criando arquivo Temporario")
					_nLin+=2
				Else
					@ _nLin, 000 PSay "Comprados por Valor"
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
				TRB->T_VALOR     	:= TRA->T_VALOR
				TRB->T_UVALO     	:=	TRA->T_UVALO     
				MsUnLock()
	
				Dbselectarea("TRA")
				DbSkip()
			Enddo
			
			_cflag	 := 0					// Zera para nao entrar na descricao do cabecalho e a quebra por grupo			
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
				@ _nLin, 104 PSay TRA->T_UVALO													   PICTURE "@E 999,999,999.99"						
				_nLin++

				_nQtdProd := _nQtdProd + TRB->T_QTD
				_nValProd := _nValProd + TRB->T_VALOR

				Dbselectarea("TRB")
				DbSkip()

		   Enddo

			Dbselectarea("TRB")
			DbGotop()
			While !Eof()

				Dbselectarea("TRB")
				RecLock("TRB",.F.)
				 DELETE
				MsUnLock()
				DbSkip()

		   Enddo

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
			
			_nQtdGrup := _nQtdGrup + _nQtdProd
			_nValGrup := _nQtdGrup + _nValProd
			_nDevGrup := _nQtdGrup + _nDevPRod

		Enddo

		If _nLin > 58
			_nLin := cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
			_nLin++
		Endif

		@ _nLin, 000 PSay "TOTAL DO GRUPO:"
		@ _nLin, 060 PSay _nQtdGrup						      				 PICTURE "@E 999,999,999.99"
		@ _nLin, 075 PSay _nValGrup						      				 PICTURE "@E 999,999,999,999.99"
		_nLin++
		
		@ _nLin, 000 PSay Replicate("_",220)
		_nLin++

	Enddo
	
Endif

If _nLin > 58
	_nLin := cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
	_nLin++
Endif

_nLin+=2
@ _nLin, 000 PSay "TOTAL DE COMPRAS:"
@ _nLin, 050 PSay _nTotQtd							      				 PICTURE "@E 999,999,999.99"
@ _nLin, 063 PSay _nTotalF							      				 PICTURE "@E 999,999,999,999.99"

Dbselectarea("TRA")
DBCloseArea()

Ferase(_cArq1+".DBF")
Ferase(_cArq1+OrdBagExt())

Dbselectarea("TRB")
DBCloseArea()

Ferase(_cArq2+".DBF")
Ferase(_cArq2+OrdBagExt())

Dbselectarea("SD1")
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
aRegs :={}

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