#INCLUDE "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ SHRCOM01 ³ Autor ³ GENILSON MOREIRA LUCAS  ³ Data ³ 15/04/2010 ³±±
±±³          ³          ³       ³	MVG CONSULTORIA		  ³      ³            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relacao de Itens em Ponto de Pedido					          ³±±
±±³          ³ DISPONIBILIDADE	                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao ³                                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso        ³										                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³             ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador   ³  Data  ³              Motivo da Alteracao                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³                                                   ³±±
±±³              ³        ³                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function SHRCOM01()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de Itens em Ponto de Pedido, conforme Parâmetro."
Local cDesc3         := "Itens em Ponto de Pedido"
Local cPict          := ""
Local titulo         := "Itens em Ponto de Pedido"
Local nLin         	 := 80
Local imprime      	 := .T.
Local aOrd 			 := {"Por Produto"}

Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 132
Private tamanho      := "M"
Private nomeprog     := "SHRCOM01"
Private nTipo        := 15
Private aReturn      := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "SHRCOM01"
Private cString 	 := "SC6"
Private cPerg   	 := PadR("COMR01",Len(SX1->X1_GRUPO))
Private nOrdem

Private Cabec1       := "CODIGO   DESCRIÇÃO                                   UM    SAD DISP   PONTO PED     LT ECON   EST SEGUR   PR ENTREGA"
Private Cabec2       := "   PDC/SC       QTDE    EMISSÃO     PREV ENTRE"
//                               X                                   x           x           x           x
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte(cPerg,.F.)

dbSelectArea(cString)
dbSetOrder(1)

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)
nOrdem:= aReturn[8]

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  23/05/05   º±±
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


BuscaSaldo()	//----> BUSCA SALDO DOS PRODUTOS

nSaldo		:= 0
nPPedido	:= 0
nControle	:= .T.
cChave		:= ""

dbSelectArea("SALDO")
dbGoTop()
While !Eof()
	
	If lAbortPrint
		@nLin,000		 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	If nLin > 70
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 9
	Endif
	 
	// CALCULA SALDO DISPONÍVEL DO PRODUTO
	nSaldo 		:= SALDO->QTDE - SALDO->EMP - POSICIONE("SB1",1,XFILIAL("SB1")+SALDO->B2_COD,"B1_ESTSEG")
	nPPedido	:= POSICIONE("SB1",1,XFILIAL("SB1")+SALDO->B2_COD,"B1_EMIN")
	cChave		:= SALDO->B2_COD
	
	If nSaldo <= nPPedido
		
		@ nLin, 000			 	PSAY cChave
		@ nLin, 010				PSAY POSICIONE("SB1",1,XFILIAL("SB1")+SALDO->B2_COD,"B1_DESC")
		@ nLin, Pcol()+004		PSAY POSICIONE("SB1",1,XFILIAL("SB1")+SALDO->B2_COD,"B1_UM")
		@ nLin, Pcol()+003  	PSAY nSaldo Picture "@E 999999.99"
		@ nLin, Pcol()+004		PSAY POSICIONE("SB1",1,XFILIAL("SB1")+SALDO->B2_COD,"B1_EMIN") Picture "@E 99999.99"
		@ nLin, Pcol()+004		PSAY POSICIONE("SB1",1,XFILIAL("SB1")+SALDO->B2_COD,"B1_LE")   Picture "@E 99999.99"
		@ nLin, Pcol()+004		PSAY POSICIONE("SB1",1,XFILIAL("SB1")+SALDO->B2_COD,"B1_ESTSEG")   Picture "@E 99999.99"
		@ nLin, Pcol()+003		PSAY POSICIONE("SB1",1,XFILIAL("SB1")+SALDO->B2_COD,"B1_PE") Picture "@E 99"
		@ nLin, Pcol()+001		PSAY "Dia(s)
		nLin++
		
		// PEDIDOS DE COMPRAS EM ABERTO
		DbSelectArea("SC7")
		DbSetOrder(15)
		DbSeek(xFilial("SC7") + " " + cChave)
		
		While !Eof() .AND. SC7->C7_ENCER == " " .AND. SC7->C7_PRODUTO == cChave
			
			If SC7->C7_RESIDUO == " "
				
				@ nLin, 003			PSAY SC7->C7_NUM
				@ nLin, Pcol()+001	PSAY SC7->C7_QUANT 		Picture "@E 999999.999"
				@ nLin, Pcol()+004	PSAY SC7->C7_EMISSAO
				@ nLin, Pcol()+004	PSAY SC7->C7_DATPRF    
				@ nLin, Pcol()+000	PSAY " - PEDIDO DE COMPRA" 
				nLin++
				nControle	:= .F.
				
				
				If nLin > 70
					Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
					nLin := 9
				Endif
				
			ENDIF
			
			dbSelectArea("SC7")
			dbSkip()
		EndDo
		
		If nControle
			
			// SOLICITAÇÃO DE COMPRAS EM ABERTO
			DbSelectArea("SC1")
//			DbSetOrder(10)
			DbSetOrder(8)
			DbSeek(xFilial("SC1") + cChave + "      ")
			
			While !Eof() .AND. SC1->C1_PRODUTO == cChave .AND. SC1->C1_PEDIDO = "      "
				
				IF SC1->C1_RESIDUO = " "
					
					@ nLin, 003			PSAY SC1->C1_NUM
					@ nLin, Pcol()+001	PSAY SC1->C1_QUANT 		Picture "@E 999999.999"
					@ nLin, Pcol()+004	PSAY SC1->C1_EMISSAO
					@ nLin, Pcol()+004	PSAY SC1->C1_DATPRF
					@ nLin, Pcol()+000	PSAY " - SOLICITAÇÃO DE COMPRA"
					nLin++
					
					If nLin > 70
						Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
						nLin := 9
					Endif
					
				ENDIF
				
				dbSelectArea("SC1")
				dbSkip()
			EndDo
		EndIf
		
		@ nLin, 000		PSAY Replicate("-",132)
		nLin++
		
	Endif
	
	nSaldo		:= 0
	nPPedido	:= 0
	nControle	:= .T.
	
	dbSelectArea("SALDO")
	dbSkip()
EndDo

dbSelectArea("SALDO")
dbCloseArea("SALDO")

SET DEVICE TO SCREEN

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()
Return

//----> FUNCAO BUSCA AS VENDAS
Static Function BuscaSaldo()
cQuery	:=	"SELECT DISTINCT "
cQuery	+=	"  SB2010.B2_COD, SUM(SB2010.B2_QATU) QTDE, SUM(SB2010.B2_QEMP) EMP "
cQuery	+=	"FROM     SB2010 INNER JOIN "
cQuery	+=	"    SB1010 ON SB2010.B2_COD = SB1010.B1_COD "
cQuery	+=	"WHERE   "
cQuery	+=	" SB1010.B1_TIPO = 'MP' AND  "
cQuery	+=	" (SB2010.B2_FILIAL BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"')  AND (SB2010.D_E_L_E_T_ = '') AND (SB1010.D_E_L_E_T_ = '')"
cQuery  +=  "GROUP BY SB2010.B2_COD "
cQuery	+=	"ORDER BY SB2010.B2_COD "
cQuery	:=	ChangeQuery(cQuery)

dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "SALDO", .T., .T.)

Return()
