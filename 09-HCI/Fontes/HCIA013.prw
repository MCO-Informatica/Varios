#INCLUDE "PROTHEUS.ch"
#INCLUDE "RWMAKE.ch"

/*
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณHCIA013   บAutor  ณRafael Marin        บ Data ณ  24/01/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Display do saldo do produto trazendo tambem o saldo  de    บฑฑ
ฑฑบ    .     ณ todos os produtos alternativos ligados a ele.              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function HCIA013 ()
Local lReturn := .T.
Local cQuery  := ""
Local Areas   := GetArea()

Local cProduto  := Iif(Alltrim(ReadVar())=="M->C6_PRODUTO" , &(ReadVar()), Iif(Alltrim(ReadVar())=="M->CK_PRODUTO" , &(ReadVar()),M->CK_PRODUTO)) //aCols[n][nProduto])
Local oGeraTxt
Local nStok

Local aHeadTemp := {}
Local aColTemp := {}
Local nTmp
Local nQPEDVEN := 0
Local nSALPEDI := 0
Local nRESERVA := 0
Local nQATU    := 0
Local cProdnovo := Nil
Private oGetData
Private aHeader
Private aCols

SB1->(dbSeek(xFilial("SB1")+cProduto))
If	 (Alltrim(ReadVar()) == "M->C6_PRODUTO") .Or. (Alltrim(ReadVar())=="M->CK_PRODUTO")

	dbSelectArea("SB2")
	dbSetOrder(1)
	If dbSeek(xFilial("SB2")+cProduto)
		nQPEDVEN :=  B2_QPEDVEN
		nSALPEDI :=  B2_SALPEDI
		nRESERVA :=  B2_RESERVA
		nQATU 	 :=  B2_QATU
	Else
		Aviso("Produto sem Saldo!","Este produto nใo possui saldo em estoque, favor verificar!",{"Ok"})
	EndIf

aHeadTemp := aClone(aHeader)
aColTemp := aClone(aCols)


	If	 (Alltrim(ReadVar()) == "M->C6_PRODUTO")
		nTmp := n
		n := 1
	endif

	oGetData := NIL
	aHeader := {}
	aCols   := {}

	SB1->(dbSeek(xFilial()+cProduto))
	nStok:= SaldoSb2()

	DEFINE MSDIALOG oGeraTxt TITLE OemToAnsi("Posio de Estoque") FROM 1,1 TO 550,800 PIXEL

	@ 10,05 Say "Produto: "+SB1->B1_COD+"          "+Subs(SB1->B1_DESC,1,30) SIZE 200,11

	@ 20,05 Say "Pedido de Vendas em Aberto :"
	@ 20, 110 SAY nQPEDVEN

	@ 20,150 Say "Qtd.Prevista p/Entrar :"
	@ 20, 250 SAY nSALPEDI

	@ 30,05 Say "Quantidade Reservada (A) :"
	@ 30, 110 SAY nRESERVA

	@ 40,05 Say "Saldo Atual (B) :"
	@ 40, 110 SAY nQATU

	@ 50,05 Say "Disponกvel (B - A) :"
	@ 50, 110 SAY nStoK

	@ 260,300 BMPBUTTON TYPE 01 ACTION Close(oGeraTxt)

	U_MontaGD(cProduto)

	Activate Dialog oGeraTxt Centered
	cProdnovo := aCols [n,2]

	If FunName() == "MATA415"
		If ReadVar() == 'M->CK_PRODUTO'
			If 	cProdnovo <> Nil
				M->CK_PRODUTO := cProdnovo
			EndIf
		EndIf
	Else
		If ReadVar() == 'M->C6_PRODUTO'
			If 	cProdnovo <> Nil
				M->C6_PRODUTO := cProdnovo
			EndIf
		EndIf
	EndIf


	aHeader := aClone(aHeadTemp)
	aCols   := aClone(aColTemp)

	If	 (Alltrim(ReadVar()) == "M->C6_PRODUTO")
		n := nTmp
	endif

Endif

RestArea(Areas)

Return (lReturn)


/*
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMontaGD   บAutor  ณRafael Marin        บ Data ณ  24/01/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Monta grid contendo produtos alternativos ao produto       บฑฑ
ฑฑบ    .     ณ passado no parametro.                                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MontaGD(cProduto)

Local nDisp    := 0
Local cNumLote := ""
dbSelectArea("SX3")
dbSetOrder(2)

dbseek("PA1_FILIAL")
AADD(aHeader,{ TRIM(X3Titulo()), X3_CAMPO, X3_PICTURE, X3_TAMANHO, X3_DECIMAL, X3_VALID, "", X3_TIPO, "", ""})
dbseek("PA1_ALTERN")
AADD(aHeader,{ TRIM(X3Titulo()), X3_CAMPO, X3_PICTURE, X3_TAMANHO, X3_DECIMAL, X3_VALID, "", X3_TIPO,  "", ""})
dbseek("B2_QPEDVEN")
AADD(aHeader,{ TRIM(X3Titulo()), X3_CAMPO, X3_PICTURE, X3_TAMANHO, X3_DECIMAL, X3_VALID, "", X3_TIPO,  "", ""})
dbseek("B2_SALPEDI")
AADD(aHeader,{ TRIM(X3Titulo()), X3_CAMPO, X3_PICTURE, X3_TAMANHO, X3_DECIMAL, X3_VALID, "", X3_TIPO,  "", ""})
dbseek("B2_RESERVA")
AADD(aHeader,{ TRIM(X3Titulo()), X3_CAMPO, X3_PICTURE, X3_TAMANHO, X3_DECIMAL, X3_VALID, "", X3_TIPO,  "", ""})
dbseek("B2_QATU")
AADD(aHeader,{ TRIM(X3Titulo()), X3_CAMPO, X3_PICTURE, X3_TAMANHO, X3_DECIMAL, X3_VALID, "", X3_TIPO,  "", ""})
//Coluna Forcada para apresentar calculo de variavel
AADD(aHeader,{ TRIM("Disponivel (B-A)"), "PRODISP", X3_PICTURE, X3_TAMANHO, X3_DECIMAL, X3_VALID, "", X3_TIPO,  "", ""})

dbseek("B8_LOTECTL")
AADD(aHeader,{ TRIM(X3Titulo()), X3_CAMPO, X3_PICTURE, X3_TAMANHO, X3_DECIMAL, X3_VALID, "", X3_TIPO,  "", ""})
dbseek("B8_NUMLOTE")
AADD(aHeader,{ TRIM(X3Titulo()), X3_CAMPO, X3_PICTURE, X3_TAMANHO, X3_DECIMAL, X3_VALID, "", X3_TIPO,  "", ""})
dbseek("B8_SALDO")
AADD(aHeader,{ TRIM(X3Titulo()), X3_CAMPO, X3_PICTURE, X3_TAMANHO, X3_DECIMAL, X3_VALID, "", X3_TIPO,  "", ""})
dbseek("B8_CLIFOR")
AADD(aHeader,{ TRIM(X3Titulo()), X3_CAMPO, X3_PICTURE, X3_TAMANHO, X3_DECIMAL, X3_VALID, "", X3_TIPO,  "", ""})
dbseek("B8_LOTEFOR")
AADD(aHeader,{ TRIM(X3Titulo()), X3_CAMPO, X3_PICTURE, X3_TAMANHO, X3_DECIMAL, X3_VALID, "", X3_TIPO,  "", ""})


//
cQuery	:= "SELECT PA1_FILIAL, PA1_ALTERN, B2_QPEDVEN, B2_SALPEDI, B2_RESERVA, B2_QATU, B2_QACLASS, B8_LOTECTL, B8_NUMLOTE, B8_SALDO, B8_CLIFOR, B8_LOTEFOR"
cQuery	+= " FROM "+RetSqlName("PA1")+" PA1"

cQuery	+= " INNER JOIN "+RetSqlName("SB2")+" SB2 ON B2_COD = PA1_ALTERN "
cQuery	+= " INNER JOIN "+RetSqlName("SB8")+" SB8 ON B2_FILIAL = B8_FILIAL AND B8_PRODUTO = B2_COD AND B2_LOCAL =  B8_LOCAL"

//Verifica todas as filiais
cQuery	+= " WHERE PA1_PROD = '"+ALLTRIM(cProduto)+"'"
cQuery	+= " AND PA1.D_E_L_E_T_ <> '*'"
cQuery	+= " AND SB2.D_E_L_E_T_ <> '*'"
cQuery	+= " AND SB8.D_E_L_E_T_ <> '*'"
cQuery	+= "GROUP BY PA1_FILIAL, PA1_ALTERN, B2_QPEDVEN, B2_SALPEDI, B2_RESERVA, B2_QATU, B2_QACLASS, B8_LOTECTL, B8_NUMLOTE, B8_SALDO, B8_CLIFOR, B8_LOTEFOR"

cQuery := ChangeQuery(cQuery)
dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"QUERY", .F., .T.)

dbSelectArea("QUERY")
dbGotop()
  aAdd(aCols, {,,,,,,,,,,,,.F.})
While !(QUERY->(EOF()))
    If (cNumLote <> QUERY->PA1_FILIAL+QUERY->PA1_ALTERN)
	  nDisp := (QUERY->B2_QATU - QUERY->B2_RESERVA - QUERY->B2_QACLASS)
	  aAdd(aCols, {QUERY->PA1_FILIAL,QUERY->PA1_ALTERN,QUERY->B2_QPEDVEN,QUERY->B2_SALPEDI,QUERY->B2_RESERVA,QUERY->B2_QATU, nDisp, QUERY->B8_LOTECTL, QUERY->B8_NUMLOTE, QUERY->B8_SALDO, QUERY->B8_CLIFOR, QUERY->B8_LOTEFOR, .F.})
	  cNumLote := QUERY->PA1_FILIAL+QUERY->PA1_ALTERN
    Else
	  aAdd(aCols, {,,,,,,, QUERY->B8_LOTECTL, QUERY->B8_NUMLOTE, QUERY->B8_SALDO, QUERY->B8_CLIFOR, QUERY->B8_LOTEFOR, .F.})
    EndIf

	dbSkip()
End
                       //Y1, X1,  Y2,  X2
oGetData := MSGetDados():New(60, 08, 250, 400, 2)
dbCloseArea()

Return .T.
