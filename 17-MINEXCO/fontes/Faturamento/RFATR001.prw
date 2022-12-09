#INCLUDE "rwmake.ch"
#Include "Protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFATR001  º Autor ³ Felipe Valenca     º Data ³  30/04/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio de Romaneio de Pedidos.                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function RFATR001


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Romaneio de Pedidos"
Local cPict          := ""
Local titulo       := "Romaneio de Pedidos"
Local nLin         := 80

Local Cabec1       := "QUANT      PRODUTO                         MEDIDA                TOTAL      TOTAL"
Local Cabec2       := "CHAPA                                      LIQUIDA                  M2         R$"
                     //123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
                     //         1         2         3         4         5         6         7         8         9         10        11        12

//QUANT     DESCRIMINAÇÃO                                    MEDIDA           TOTAL           TOTAL
//                                                           LIQUIDA                          GERAL
//123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//         1         2         3         4         5         6         7         8         9         10        11        12
Local imprime      := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 80
Private tamanho          := "P"
Private nomeprog         := "RFATR001" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cPerg       := "RFATR001"
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "RFATR001" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := "SC6"

dbSelectArea("SC6")
dbSetOrder(1)


ValidPerg()

If !pergunte(cPerg,.T.)
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  30/04/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nQtdVen := 0
Local nTotQtd := 0
Local nTotVlr := 0

cQuery := "SELECT C5_CONDPAG,C5_MOTORIS,C5_MENNOTA,C6_NUM, C6_PRODUTO,C6_DESCRI, C6_X_LOTEF, C6_QTDVEN, C6_VALOR, A1_NOME, A1_END, A1_BAIRRO, A1_MUN, A1_EST, A1_CEP "
cQuery += "FROM "+RetSqlName("SC5")+" C5 "
cQuery += "INNER JOIN "+RetSqlName("SC6")+" C6 ON C6.D_E_L_E_T_ = '' "
cQuery += "AND C5_FILIAL = C6_FILIAL "
cQuery += "AND C5_NUM = C6_NUM "

cQuery += "INNER JOIN "+RetSqlName("SA1")+" A1 ON A1.D_E_L_E_T_ = '' "
cQuery += "AND A1_COD = C5_CLIENTE "
cQuery += "AND A1_LOJA = C5_LOJACLI "

cQuery += "WHERE C5.D_E_L_E_T_ = '' AND C6_NUM BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "

cQuery += "ORDER BY C6_FILIAL, C6_NUM, C6_PRODUTO "

If Select("TRB") > 0
	dbSelectArea("TRB")
	dbCloseArea()
Endif

dbUseArea(.T.,"TOPCOON",TcGenQry(,,cQuery),"TRB",.F.,.T.)                                              
dbSelectArea("TRB")
SetRegua(RecCount())
dbGoTop()

//Cabec(Titulo,,,NomeProg,Tamanho,nTipo)
Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
nLin := 8

Do While !TRB->(Eof())

//	nLin++
//	@nLin,0000 pSay A1_NOME
//	nLin++
//	@nLin,0000 pSay A1_END
//	nLin++
//	@nLin,0000 pSay A1_BAIRRO
//	nLin++
//	@nLin,0000 pSay Alltrim(A1_MUN)+ " - " + A1_EST
//	nLin++
//	@nLin,0000 pSay "CEP: "+A1_CEP

	_cNum := C6_NUM
	nLin +=2
	@nLin, 0000 pSay "PEDIDO NUM: "+_cNum+" - "+A1_NOME
	nLin++
	@nLin, 0000 pSay "COND PAGTO: "+Posicione("SE4",1,xFilial("SE4")+TRB->C5_CONDPAG,"E4_DESCRI")
	nLin++            
	@nLin, 0000 pSay Iif(!Empty(TRB->C5_MOTORIS),"MOTORISTA:  "+TRB->C5_MOTORIS,"")
	nLin++
	@nLin, 0000 pSay Iif(!Empty(TRB->C5_MENNOTA),"OBSERVACAO: "+TRB->C5_MENNOTA,"")
	nLin++
	Do While !TRB->(Eof()) .And. _cNum == C6_NUM

		_cProduto := C6_PRODUTO
		nLin++
		Do While !TRB->(Eof()) .And. _cNum == C6_NUM .And. _cProduto == C6_PRODUTO

			@nLin,0000 pSay Transform(1, "@E 999.99")
			@nLin,Pcol()+005 pSay Alltrim(C6_PRODUTO)+"-"+SUBS(C6_DESCRI,1,20)
			@nLin,Pcol()+005 pSay C6_X_LOTEF
			@nLin,Pcol()+001 pSay Transform(C6_QTDVEN, "@E 999.9999")
			@nLin,Pcol()+001 pSay Transform(C6_VALOR, "@E 999,999.99")
			
			nLin++
		
			nTotQtd++
			nQtdVen += C6_QTDVEN
			nTotVlr += C6_VALOR
			
			If lAbortPrint
				@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
				Exit
			Endif
		
			If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 8
			Endif
	
			dbSkip() // Avanca o ponteiro do registro no arquivo
		EndDo
		@nLin,00 Psay __PrtThinLine()
		nLin++

		@nLin, 0000 pSay 		  Transform(nTotQtd, "@E 999.99")
		@nLin, Pcol()+056 pSay    Transform(nQtdVen, "@E 999.9999")
		@nLin, Pcol()+001 pSay    Transform(nTotVlr, "@E 999,999.99")
		
		nLin++
	
		nTotQtd := 0
		nQtdVen := 0
		nTotVlr := 0
	EndDo

	If !TRB->(Eof())
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8	
	Endif
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return


*---------------------------------*
Static Function ValidPerg()
*---------------------------------*

Local _sAlias := Alias()
Local aRegs := {}
Local i,j

DBSelectArea("SX1") ; DBSetOrder(1)
cPerg := PADR(cPerg,10)

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
AADD(aRegs,{cperg,"01","Do Pedido:"				,"","","mv_ch1","C", 6,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cperg,"02","Ate o Pedido:"			,"","","mv_ch2","C", 6,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""})

For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			EndIf
		Next
		MsUnlock()
		
		
	EndIf
Next

dBSelectArea(_sAlias)

Return
