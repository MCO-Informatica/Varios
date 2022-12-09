#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � Lincos   � Autor � Vanderlei A Ferreira  �Data� 01/12/05   ���
�������������������������������������������������������������������������͹��
���Descricao � O.S. Linciplas                                             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function LINCOS


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Private cString    := ""
Private aOrd       := {}
Private CbTxt      := ""
Private cDesc1     := ""
Private cDesc2     := ""
Private cDesc3     := "ORDEM DE SERVICO"
Private cPict      := ""
Private lEnd       := .F.
Private lAbortPrint:= .F.
Private limite     := 132
Private tamanho    := "M"
Private nomeprog   := "LINCOP"
Private nTipo      := 18
Private aReturn    := {"Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey   := 0
Private cPerg      := "Lincos"
Private titulo     := "ORDEM DE SERVICO"

nLin 		       := 80

Private Cabec1     := ""
Private Cabec2     := ""
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private imprime    := .T.
Private wnrel      := "LINCOS" // nome do arquivo usado para impressao em disco

Private cString := "SC6"

dbSelectArea("SC6")
dbSetOrder(1)


ValidPerg()

pergunte(cPerg,.F.)

//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//���������������������������������������������������������������������Ŀ
//� Processamento. RPTSTATUS monta janela com a regua de processamento. �
//�����������������������������������������������������������������������

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �RUNREPORT � Autor � AP5 IDE            � Data �  29/08/01   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Private nOrdem

dbselectarea("SC5")
dbSetorder(2)
dbSeek(xFilial("SC5")+DTOS(MV_PAR01),.T.)


//���������������������������������������������������������������������Ŀ
//� SETREGUA -> Indica quantos registros serao processados para a regua �
//�����������������������������������������������������������������������

SetRegua(RecCount())

While !EOF() .AND. SC5->C5_EMISSAO >= MV_PAR01 .AND. SC5->C5_EMISSAO <= MV_PAR02
	
	If SC5->C5_NUM < MV_PAR03 .OR. SC5->C5_NUM > MV_PAR04
		dbselectarea("SC5")
		DbSkip()
		Loop
	EndIf
	
	//���������������������������������������������������������������������Ŀ
	//� Verifica o cancelamento pelo usuario...                             �
	//�����������������������������������������������������������������������
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	//���������������������������������������������������������������������Ŀ
	//� Impressao do cabecalho do relatorio. . .                            �
	//�����������������������������������������������������������������������
	
	_cPedido := SC5->C5_NUM
	
	DBSELECTAREA("SC6")	
	cFilTrab   := CriaTrab("",.F.)
    IndRegua("SC6",cFilTrab,"C6_FILIAL+C6_NUM+C6_PRODUTO",,,"Filtrando")    // "Selecionando Registros..."
	DbGoTop()
	SetRegua(RecCount())
	
	
	//dbSelectArea("SC6")
	//dbSetOrder(1)
	dbSeek(xFilial("SC6")+_cPedido)
	
	While !Eof() .and. _cPedido == SC6->C6_NUM  
		
		If nLin > 55
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 6
		Endif
		
		
		@ nLin, 072 PSAY "EMISSAO: " + DTOC(SC5->C5_EMISSAO)
		
		nLin := nlin + 2
		
		@ nLin, 000 PSAY "OS N. :"+SC6->C6_NUM
		@ nLin, 015 PSAY "CLIENTE: " + SC5->C5_CLIENTE+"-"+SC5->C5_LOJACLI
		
		dbSelectarea("SA1")
		dbSetorder(1)
		dbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI)
		
		dbSelectarea("SB1")
		dbSetorder(1)
		dbSeek(xFilial("SB1")+SC6->C6_PRODUTO)
		
		@ nLin, 035 PSAY " - " + SA1->A1_NOME
		@ nLin, 078 PSAY "PEDIDO CLIENTE : "+ SC5->C5_PEDCLI
		@ nLin, 112 psay "MAQUINA : "+ SB1->B1_LMAQ
		nLin := nlin + 1
		@ nLin, 000 PSAY REPLICATE ("-",135)
		nLin := nLin + 1
		
		//                         10        20        30        40        50        60        70        80        90       100       110       120       130
		//                0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345
		@ nLin, 000 PSAY "|PRODUTO | DESCRICAO DO MATERIAL                  |ITEM | COD.CLI       |QUANT. |UM | CICLO | CAVID | UTILIZ | DT. ENGREGA"
		nLin := nLin + 1
		@ nLin, 000 PSAY REPLICATE ("-",135)
		
		nLin := nlin + 1
	

 
 
	_cProduto := SC6->C6_PRODUTO
 	_nQuant := 0  
 	NHORAS := 0
	While !Eof() .and. _cProduto == SC6->C6_PRODUTO .and. SC5->C5_NUM == SC6->C6_NUM 
	
		
		@ nLin, 000 PSAY "|"
		@ nLin, 001 PSAY SC6->C6_PRODUTO
		@ nLin, 010 PSAY "|"
		@ nLin, 012 PSAY SUBSTR(SB1->B1_DESC,1,39)
		@ nLin, 051 PSAY "|"
		@ nLin, 053 PSAY SC6->C6_ITEM
		
		*----------------------------------------------------------------
		//@ nLin, 060 PSAY "|"
		@ nLin, 055 PSAY "|" // Vanderlei 16/02/06
		//@ nLin, 061 psay sb1->b1_lcodcli
		@ nLin, 056 psay ALLTRIM(sb1->b1_lcodcli) // Vanderlei 16/02/06
		*----------------------------------------------------------------
				
		@ nLin, 073 PSAY "|"
		@ nLin, 074 PSAY SC6->C6_QTDVEN picture "@E 999,999" // Vanderlei 19/01/06
		
		@ nLin, 081 PSAY "|"
		@ nLin, 082 psay sc6->c6_um
		
		@ nLin, 085 PSAY "|"
		@ nLin, 086 psay sb1->b1_lciclo
		@ nLin, 093 PSAY "|"
		@ nlin, 097 psay sb1->b1_lcav
		@ nLin, 101 PSAY "|"
		@ nLin, 105 psay sb1->b1_lutili
		@ nLin, 110 PSAY "|"
		@ nLin, 113 psay SC6->C6_ENTREG
		
		
		nLin := nLin + 1
		
		@ nLin, 000 PSAY REPLICATE ("-",135)
		nLin := nLin + 1
		
		_CITEM := SC6->C6_ITEM
		_nQuant := _nQuant + SC6->C6_QTDVEN
		NHORAS := NHORAS + (SC6->C6_QTDVEN / ((3600/sb1->b1_lciclo)*sb1->b1_lcav))
	dbSelectArea("SC6")
	dbSkip()
	

		
	End
	
	
	
		nLin := nLin + 3
	
		@ nLin, 001 psay "OBSERVACOES :"
		nLin := nLin + 3
		@ nLin, 001 psay "MATERIA PRIMA :"
		@ nLin, 041 psay "COR :"
		@ nLin, 091 psay "MOLDE :"
		
		nLin:= nLin + 2                           
		
		@ nLin, 001 psay "QTD MP :"
		
		@ nLin, 040 psay "HRS NESC.:"
		@ nLin, 052 psay NHORAS PICTURE "@E 99.99"
		@ nLin, 075 psay "RESPONSAVEL :"
//		@ nLin, 105 psay "DATA ENTREGA :"
		
		nLin := nLin + 2
		@ nLin, 001 psay "EMBALAGEM :" + "   (   )CAIXA DE PAPELAO    (   ) CAIXA PLASTICA"
		@ nLin, 065 psay "(   )SACO PLASTICO   (   )CAIXA PALITO" // Vanderlei 06/01/06
		nLin := nLin + 2
		@ nLin, 001 psay "OBSERVACOES :"
		nlin++
		nlin++
 		@ nLin, 001 PSAY "ITEM :" + _CITEM 
		nLin := nLin + 3
		
		@ nLin, 000 PSAY REPLICATE ("=",135)
		
		nLin := nLin + 3
		@ nLin, 000 PSAY REPLICATE ("_",135)
		
		nLin:= nLin +2
		
		@ nLin, 050 psay "PREPARACAO DE MATERIA PRIMA"
		@ nLin, 091 psay "OS N. :" + _CPEDIDO
		
		NLIN++
		
		@ nLin, 000 PSAY REPLICATE ("_",135)
		
		nLin++
		nLin++
		
		@ nLin, 001 PSAY "CODIGO: " + _CPRODUTO
		
		@ nLin, 025 PSAY "PROD: "+ SUBSTR(SB1->B1_DESC,1,40)
		
		@ nLin, 062 psay "COD.CLI : " + sb1->b1_lcodcli
		
		@ nLin, 090 psay "QTD.TOT : " 
		@ nLin, 101 psay _nQuant picture "@E 999,999" 
		
		@ nLin, 115 psay "PESO PC : " 
		
		nLin++
		nLIn++
		
		//                        10        20        30        40        50        60        70        80        90       100       110       120       130
		//               0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345
		@ nLin, 001 PSAY "MATERIA PRIMA     |"
		
		@ nLin, 021 PSAY "COR"
		@ nlin, 050 psay "|"
		
		@ nLin, 053 PSAY "MAQ |     ESTUFAGEM      |       RECEITA         |    APROVADO POR"
		nlin++
		
		@ nLin, 019 psay "|" // Vanderlei 06/01/06
		@ nLin, 050 psay "|" // Vanderlei 06/01/06
		
		@ nLin, 053 PSAY "    |  Tempo  |  Temp.   |     Moido | Pigm.     |"
		nlin++
		
		Impcol(nLin) // Vanderlei 06/01/06 
		nLin++
		Impcol(nLin)
		nLin++
		
		@ nLin, 000 PSAY REPLICATE ("_",135)
		
		nLin++
		
		Impcol(nLin)
		nLin++
		Impcol(nLin)
		nLin++
		@ nLin, 000 PSAY REPLICATE ("_",135)
		
		nLin++
		
		Impcol(nLin)
		nLin++
		Impcol(nLin)
		nLin++
		@ nLin, 000 PSAY REPLICATE ("_",135)
		
		nLin++
		Impcol(nLin)
		nLin++
		Impcol(nLin)
		nLin++
		
		@ nLin, 000 PSAY REPLICATE ("_",135)
		
		nLin++ 
		
		Impcol(nLin)
		nLin++
		Impcol(nLin)
		nLin++
		
		@ nLin, 000 PSAY REPLICATE ("_",135)
		
		nLin++
		
		Impcol(nLin)
		nLin++
		Impcol(nLin)
		nLin++
		
		@ nLin, 000 PSAY REPLICATE ("_",135)
		
		nLin++
		
		Impcol(nLin)
		nLin++
		Impcol(nLin)
		nLin++
				
		@ nLin, 000 PSAY REPLICATE ("_",135)
		
		nLin++
		
		/*/
		@ nLin, 000 PSAY REPLICATE ("_",135)
		nLin := nLin + 2
		
		@ nLin, 000 PSAY REPLICATE ("_",135)
		nLin := nLin + 2
		
		@ nLin, 000 PSAY REPLICATE ("_",135)
		nLin := nLin + 2
		
		@ nLin, 000 PSAY REPLICATE ("_",135)
		
		nLin := nLin + 2
		
		@ nLin, 000 PSAY REPLICATE ("_",135)
		nLin := nLin + 2
		
		@ nLin, 000 PSAY REPLICATE ("_",135)
		nLin := nLin + 2
		
		@ nLin, 000 PSAY REPLICATE ("_",135)
		/*/
		
		nlin++
		nlin++
		nlin++
		
		@ nlin, 000 psay "OBSERVACOES:"
		@ NLIN, 090 psay "Qtde de Materia Prima Requisitada:__________"
		
		nlin++
		nlin++
		
		@ nlin, 090 psay "Qtde de Materia Prima Utilizada:____________"
		nlin++
		nlin++
		
		@ nLin, 000 PSAY REPLICATE ("_",135)
		
		nlin++
		nlin++
		NLIN++
		
		@ nlin, 000 psay "Aprovado por :___________________________________"
		@ nlin, 100 psay "Data : _____/_____/_______"
		
		nlin++
		NLIN++
		nlin++
		nlin := nlin + 4
		
		@ nLin, 000 PSAY REPLICATE ("_",135)
		NLIN++
		NLIN++
		
		@ nlin, 000 psay "* Microsiga / LINCIPL�S *"
		NLIN++
		
		@ nLin, 000 PSAY REPLICATE ("_",135)
		
		nLin := 80
		
		dbselectarea("SC6")
	  //	dbSkip()
		
	End
	
	dbselectarea("SC5")
	dbSkip()
End
//���������������������������������������������������������������������Ŀ
//� Finaliza a execucao do relatorio...                                 �
//�����������������������������������������������������������������������

SET DEVICE TO SCREEN

//���������������������������������������������������������������������Ŀ
//� Se impressao em disco, chama o gerenciador de impressao...          �
//�����������������������������������������������������������������������

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return

Static Function Impcol(nLin)

// Colunas - Vanderlei 06/01/06
@ nLin, 019 psay "|"
@ nLin, 050 psay "|"
@ nlin, 057 psay "|"
@ nlin, 067 psay "|"
@ nlin, 078 psay "|"
@ nlin, 090 psay "|"
@ nLin, 102 psay "|"

Return(nLin)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �VALIDPERG � Autor � AP5 IDE            � Data �  29/08/01   ���
�������������������������������������������������������������������������͹��
���Descri��o � Verifica a existencia das perguntas criando-as caso seja   ���
���          � necessario (caso nao existam).                             ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function ValidPerg

_cAlias := Alias()
aRegs   := {}
i       := 0
j       := 0

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,10)

//          Grupo/Ordem/Pergunta/Pergunta/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/DefSpa1/DefEng1/Cnt01/Var02/Def02/DefSpa2/DefEng2/Cnt02/Var03/Def03/DefSpa3/DefEng3/Cnt03/Var04/Def04/DefSpa4/DefEng4/Cnt04/Var05/Def05/DefSpa5/DefEng5/Cnt05/F3/Pyme/GRP
aAdd(aRegs,{cPerg,"01","Da Emissao         ?"," "," ","mv_ch1","D",08,0,0,"G","","mv_par01","", "","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Ate a Emissao      ?"," "," ","mv_ch2","D",08,0,0,"G","","mv_par02","", "","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Do Pedido          ?"," "," ","mv_ch3","C",06,0,0,"G","","mv_par03","", "","","","","","","","","","","","","","","","","","","","","","","","SC5","",""})
aAdd(aRegs,{cPerg,"04","Ate o Pedido       ?"," "," ","mv_ch4","C",06,0,0,"G","","mv_par04","", "","","","","","","","","","","","","","","","","","","","","","","","SC5","",""})

For i:=1 to Len(aRegs)
	If !DbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next

dbSelectArea(_cAlias)

Return
