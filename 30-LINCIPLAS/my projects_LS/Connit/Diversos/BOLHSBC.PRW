#include "rwmake.ch"
                                                                                                                 
User Function BolHSBC()                                               

#Include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³BOLEXPAND ºAutor  ³Fabio Rogerio       º Data ³  03/14/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina para impressao do boleto expand.                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

//User Function BOLEXPAND()

Local nTotReg   := 0
Local aBitmap   := {}
Local xAlias    := GetArea()
Local lReimp    := .F.

IF !Pergunte("BOL341",.T.)
	Return(.T.)
EndIf

Aadd(aBitmap,"\BITMAPS\LOGO.BMP")
Aadd(aBitmap,"\BITMAPS\LOGO.BMP")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa impressao dos boletos.                  		       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oPrint := TMSPrinter():New( "Boleto Laser" )
oPrint:Setup()
oPrint:SetPortrait()

DbSelectArea("SE1")
DbSetOrder(1)
DbSeek(xFilial("SE1")+Mv_Par03+Mv_Par01,.T.)
ProcRegua(RecCount())

While !Eof() .And. (SE1->E1_FILIAL == xFilial("SE1")) .And. (SE1->E1_NUM <= Mv_Par02) .And. (SE1->E1_PREFIXO <= Mv_Par03)
	IncProc("Titulo "+SE1->E1_NUM+" Parcela "+SE1->E1_PARCELA)

	If (SE1->E1_TIPO $ "IR-/AB-")  
		DbSelectArea("SE1")
		DbSkip()
		Loop
	Endif
	
	
	If (SE1->E1_SALDO == 0) .Or. (!Empty(SE1->E1_PORTADO) .And. (SE1->E1_PORTADO <> "341"))        
		DbSelectArea("SE1")
		DbSkip()
		Loop
	Endif
		
	lReimp:= .F.	
	If !Empty(SE1->E1_PORTADO)
		If Aviso("Atencao","Titulo " + AllTrim(SE1->E1_NUM) + " ja impresso. Deseja Reimprimir ?",{"Sim","Nao"}) == 2
			DbSelectArea("SE1")
			DbSkip()
			Loop      
		Else
			lReimp:= .T.	
		EndIf
	EndIf
	
	SA1->( DbSetOrder(1) )
	SA1->( DbSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA) )

	SA6->( DbSetOrder(1) )
	SA6->( DbSeek(xFilial("SA6")+Mv_Par04+Mv_Par05+Mv_Par06) )
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Bancos validos: Bradesco, Itau, Unibanco e Brasil.		         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//	SEE->( DbSetOrder(1) )
//	IF !SEE->(DbSeek(xFilial("SEE")+Mv_Par04+Mv_Par05+Mv_Par06,.T.))
//		MsgAlert("Não existe os dados de configuração do banco (SEE).","Atenção")
//		Return()
//	Else
//		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//		//³ Imprime o boleto.										       ³
//		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Boleto(oPrint,aBitMap,lReimp)
//	EndIF

	dbSelectArea("SE1")
	dbSkip()
End
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza pagina.                     								³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oPrint:EndPage()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Visualizacao dos boletos.								       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oPrint:Preview()

RestArea(xAlias)

Return(.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³    Boleto    ³ Autor ³   Fabio Rogerio   ³ Data ³ 14/03/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime os boletos.                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function Boleto(oPrint,aBitmap,lReimp)

//Local cNumTit  	 := StrZero(Val(LEFT(ALLTRIM(SE1->E1_NUM),6)),6)
Local cNumTit  	 := StrZero(Val(LEFT(ALLTRIM(SE1->E1_NUM),9)),9)
Local cParcela 	 := IIF(Empty(SE1->E1_PARCELA),"0",SE1->E1_PARCELA)
Local cCarteira  := AllTrim(MV_Par08)
Local cNumBanco  := AllTrim(SEE->EE_CODIGO)													//Numero do Banco (BACEN)
Local cAgencia 	 := Alltrim(SEE->EE_AGENCIA)												//Numero da Agencia
Local cNumConta  := AllTrim(SEE->EE_CONTA)		//Numero da Conta Corrente
Local cDigConta  := AllTrim(SEE->EE_DC)             //Digito de Controle da Conta Corrente
Local cDtVencto  := Ctod("")
Local nIncLin	 := 0
Local nValorTit  := 0
Local nCol 		 := 1
Local cValorTit  := ""
Local cFatorVcto := ""
Local cDigNum    := ""
Local cNumParc   := ""

cDtVencto := SE1->E1_VENCTO
nValorTit := SE1->E1_SALDO - SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)- SE1->E1_DECRESC

cFatorVcto := StrZero(cDtVencto - Ctod("07/10/1997"),4) 						//Fator de Vencimento
cValorTit  := Right(StrZero(nValorTit * 100,17,0),10)

IF nValorTit > 99999999.99
	cFatorVcto:= ""
	cValorTit := Substr(StrZero(nValorTit * 100,17,2),1,14)
EndIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Banco Itau.												       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cDigBanco 	 := "7"
cAgencia 	 := StrZero(Val(cAgencia),4)
cNumConta 	 := StrZero(Val(cNumConta),5)
cDadosCta 	 := cAgencia + "/" + cNumConta + "-" + cDigConta
cNumBoleto   := IIf(lReimp,Left(SE1->E1_NUMBCO,Len(AllTrim(SE1->E1_NUMBCO))-1),AllTrim(GetMV("MV_ITAUSEQ")))
cNNum 		 := cAgencia + cNumConta + cCarteira + cNumBoleto
cDigNum 	 := Mod10( cNNum )
cNossoNum 	 := cCarteira + "/" + cNumBoleto + "-" + cDigNum
cCodBarras 	 := cNumBanco + "9" + cFatorVcto + cValorTit + cCarteira + cNumBoleto + cDigNum + cAgencia + cNumConta + cDigConta + "000"
cBitMapBanco := "\BITMAP\ITAU.BMP"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Grava nosso numero na 1a. Impressao.					       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF Empty(SE1->E1_NUMBCO)
	DbSelectArea("SE1")
	RecLock("SE1",.F.)
	E1_PORTADO:= cNumBanco
	E1_NUMBCO := cNumBoleto+cDigNum
        E1_BCOREG := cNumBanco
        E1_AGEREG := cAgencia
        E1_CTAREG := cNumConta
	MsUnlock()
EndIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Codigo de barras e linha digitavel.									³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cCodBarras 	:= Substr(cCodBarras,01,04) + Mod11Padrao( cCodBarras ) + Substr(cCodBarras,5)
cLinhaDig 	:= LinhaDigitavel( cCodBarras, cFatorVcto+cValorTit )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define as fontes do boleto.											³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oFont8  := TFont():New("Arial", 8, 08, .T., .F., 5, .T., 5, .T., .F.)
oFont9  := TFont():New("Arial", 8, 09, .T., .T., 5, .T., 5, .T., .F.)
oFont10 := TFont():New("Arial", 8, 10, .T., .T., 5, .T., 5, .T., .F.)
oFont16 := TFont():New("Arial", 8, 16, .T., .T., 5, .T., 5, .T., .F.)
oFont14N:= TFont():New("Arial", 8, 14, .T., .F., 5, .T., 5, .T., .F.)
oFont22 := TFont():New("Arial", 8, 22, .T., .T., 5, .T., 5, .T., .F.)
oBrush  := TBrush():New("", 4)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicia nova pagina. 												³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oPrint:StartPage()

//----------------------------------------------------Imprime o Recibo do Sacado.------------------------------------------------------------------//
oPrint:Line (080, 0100, 080, 2300)
oPrint:Line (040, 0450, 080, 0450)
oPrint:Line (040, 0670, 080, 0670)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao do Logotipo do banco.   									³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF !Empty(cBitMapBanco)
	oPrint:SayBitmap( 001, 0040,cBitMapBanco,110,110 )
EndIF

oPrint:Say  (040, 0180, "Banco Itau S.A.", oFont9)
oPrint:Say  (005, 0500, cNumBanco + "-" + cDigBanco, oFont22)
oPrint:Say  (040, 1820, "Recibo do Sacado", oFont9)

oPrint:Line (0180, 0060, 0180, 2300)
oPrint:Line (0260, 0060, 0260, 2300)
oPrint:Line (0340, 0060, 0340, 2300)
oPrint:Line (0410, 0060, 0410, 2300)

oPrint:Line (0080, 1650, 0790, 1650)

oPrint:Line (0260, 0480, 0340, 0480)
oPrint:Line (0260, 0795, 0340, 0795)
oPrint:Line (0260, 1030, 0340, 1030)
oPrint:Line (0260, 1270, 0340, 1270)

oPrint:Line (0340, 0480, 0410, 0480)
oPrint:Line (0340, 0600, 0410, 0600)
oPrint:Line (0340, 0795, 0410, 0795)
oPrint:Line (0340, 1270, 0410, 1270)

oPrint:Say  (0095, 0060, "Local de Pagamento", oFont8)
oPrint:Say  (0140, 0060, "PAGAVEL EM QUALQUER BANCO ATÉ O VENCIMENTO", oFont10)
oPrint:Say  (0095, 1670, "Vencimento", oFont8)
oPrint:Say  (0145, 2100, DTOC(cDtVencto), oFont10)
oPrint:Say  (0190, 0060, "Cedente", oFont8)
oPrint:Say  (0220, 0060, SM0->M0_NOMECOM, oFont10)
oPrint:Say  (0190, 1670, "Agência/Código Cedente", oFont8)
oPrint:Say  (0220, 1980, cDadosCta, oFont10)
oPrint:Say  (0270, 0060, "Data do Documento", oFont8)
oPrint:Say  (0300, 0170, DTOC(Date()), oFont10)
oPrint:Say  (0270, 0485, "Nro.Documento", oFont8)
oPrint:Say  (0300, 0550, cNumTit+"-"+cParcela, oFont10)
oPrint:Say  (0270, 0800, "Espécie Doc.", oFont8)
oPrint:Say  (0300, 0900, "DM", oFont10) // Duplicata Mercantil
oPrint:Say  (0270, 1035, "Aceite", oFont8)
oPrint:Say  (0300, 1135, "N", oFont10)
oPrint:Say  (0270, 1275, "Data do Processamento", oFont8)
oPrint:Say  (0300, 1335, DTOC(SE1->E1_EMISSAO), oFont10)
oPrint:Say  (0270, 1670, "Nosso Número", oFont8)
oPrint:Say  (0300, 1980, cNossoNum, oFont10)
oPrint:Say  (0350, 0060, "Uso do Banco", oFont8)
oPrint:Say  (0350, 0485, "Carteira", oFont8)
oPrint:Say  (0380, 0510, cCarteira, oFont10)
oPrint:Say  (0350, 0630, "Espécie", oFont8)
oPrint:Say  (0380, 0640, "R$", oFont10)
oPrint:Say  (0350, 0805, "Quantidade", oFont8)
oPrint:Say  (0350, 1275, "Valor", oFont8)
oPrint:Say  (0350, 1670, "(=)Valor do Documento", oFont8)
oPrint:Say  (0380, 2100, AllTrim(TransForm(nValorTit, "@E 999,999,999.99")), oFont10)
oPrint:Say  (0420, 0060, "Instruções (Texto de responsabilidade do cedente)", oFont8)

nJuros := Alltrim(TransForm((SE1->E1_SALDO * Mv_Par07)/100,PesqPict("SE1","E1_VALJUR"))) 
nDesco := Alltrim(TransForm(((SE1->E1_VALOR*SE1->E1_DESCFIN)/100)+SE1->E1_DESCONT,PesqPict("SE1","E1_VALOR")))

oPrint:Say  (0450, 0060, "APOS VENCTO, JUROS R$ " +nJuros+ " POR DIA DE ATRASO.", oFont10)
oPrint:Say  (0480, 0060, "CONCEDER DESCONTO NO VALOR DE R$ " +nDesco, oFont10)

oPrint:Line (0490, 1650, 0490, 2300)
oPrint:Line (0560, 1650, 0560, 2300)
oPrint:Line (0640, 1650, 0640, 2300)
oPrint:Line (0710, 1650, 0710, 2300)
oPrint:Line (0790, 0060, 0790, 2300)
oPrint:Line (0950, 0060, 0950, 2300)
oPrint:Line (1120, 0060, 1120, 2300)
	
oPrint:Say  (0420, 1670, "(-)Desconto/Abatimento", oFont8)
oPrint:Say  (0500, 1670, "(-)Outras Deduções", oFont8)
oPrint:Say  (0570, 1670, "(+)Mora/Multa", oFont8)
oPrint:Say  (0650, 1670, "(+)Outros Acréscimos", oFont8)
oPrint:Say  (0720, 1670, "(-)Valor Cobrado", oFont8)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Dados do Sacado (Cliente).        									³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oPrint:Say  (0800, 0060, "Sacado", oFont8)
oPrint:Say  (0800, 0200, AllTrim(SA1->A1_NOME)+" ("+AllTrim(SA1->A1_COD)+") ", oFont10)

IF Len(AllTrim(SA1->A1_CGC)) <= 11
	oPrint:Say  (0800, 1670, "CPF: "+TransForm(StrZero(Val(SA1->A1_CGC),11), "@R 999.999.999-99"), oFont10)
ELSE
	oPrint:Say  (0800, 1670, "CGC: "+TransForm( StrZero(Val(SA1->A1_CGC),14), "@R 99.999.999/9999-99"), oFont10)
EndIF

oPrint:Say  (0830, 0200, AllTrim(SA1->A1_End), oFont10)
oPrint:Say  (0870, 0200, TransForm(SA1->A1_CEP, "@R 99999-999") + " - " + AllTrim(SA1->A1_BAIRRO)+ " - "+ AllTrim(SA1->A1_MUN)+", "+SA1->A1_EST, oFont10)
oPrint:Say  (0870, 1670, cNossoNum, oFont10)

oPrint:Say  (0920, 0060, "Sacador/Avalista", oFont8)
oPrint:Say  (0920, 1670, "Codigo de Baixa", oFont8)
oPrint:Say  (0960, 1670, "Autenticação Mecânica", oFont8)

//----------------------------------------------------Imprime a Ficha de Caixa.------------------------------------------------------------------//
oPrint:Line (1200, 0100, 1200, 2300)
oPrint:Line (1160, 0450, 1200, 0450)
oPrint:Line (1160, 0670, 1200, 0670)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao do Logotipo do banco.   									³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF !Empty(cBitMapBanco)
	oPrint:SayBitmap( 1121, 0040,cBitMapBanco,110,110 )
EndIF

oPrint:Say  (1160, 0180, "Banco Itau S.A.", oFont9)
oPrint:Say  (1125, 0500, cNumBanco + "-" + cDigBanco, oFont22)
oPrint:Say  (1160, 1820, "Ficha de Caixa", oFont9)

oPrint:Line (1300, 0060, 1300, 2300)
oPrint:Line (1380, 0060, 1380, 2300)
oPrint:Line (1460, 0060, 1460, 2300)
oPrint:Line (1530, 0060, 1530, 2300)

oPrint:Line (1200, 1650, 1910, 1650)

oPrint:Line (1380, 0480, 1460, 0480)
oPrint:Line (1380, 0795, 1460, 0795)
oPrint:Line (1380, 1030, 1460, 1030)
oPrint:Line (1380, 1270, 1460, 1270)

oPrint:Line (1460, 0480, 1530, 0480)
oPrint:Line (1460, 0600, 1530, 0600)
oPrint:Line (1460, 0795, 1530, 0795)
oPrint:Line (1460, 1270, 1530, 1270)

oPrint:Say  (1215, 0060, "Local de Pagamento", oFont8)
oPrint:Say  (1260, 0060, "PAGAVEL EM QUALQUER BANCO ATÉ O VENCIMENTO", oFont10)
oPrint:Say  (1215, 1670, "Vencimento", oFont8)
oPrint:Say  (1265, 2100, DTOC(cDtVencto), oFont10)
oPrint:Say  (1310, 0060, "Cedente", oFont8)
oPrint:Say  (1340, 0060, SM0->M0_NOMECOM, oFont10)
oPrint:Say  (1310, 1670, "Agência/Código Cedente", oFont8)
oPrint:Say  (1340, 1980, cDadosCta, oFont10)
oPrint:Say  (1390, 0060, "Data do Documento", oFont8)
oPrint:Say  (1420, 0170, DTOC(Date()), oFont10)
oPrint:Say  (1390, 0485, "Nro.Documento", oFont8)
oPrint:Say  (1420, 0550, cNumTit+"-"+cParcela, oFont10)
oPrint:Say  (1390, 0800, "Espécie Doc.", oFont8)
oPrint:Say  (1420, 0900, "DM", oFont10) // Duplicata Mercantil
oPrint:Say  (1390, 1035, "Aceite", oFont8)
oPrint:Say  (1420, 1135, "N", oFont10)
oPrint:Say  (1390, 1275, "Data do Processamento", oFont8)
oPrint:Say  (1420, 1335, DTOC(SE1->E1_EMISSAO), oFont10)
oPrint:Say  (1390, 1670, "Nosso Número", oFont8)
oPrint:Say  (1420, 1980, cNossoNum, oFont10)
oPrint:Say  (1470, 0060, "Uso do Banco", oFont8)
oPrint:Say  (1470, 0485, "Carteira", oFont8)
oPrint:Say  (1500, 0510, cCarteira, oFont10)
oPrint:Say  (1470, 0630, "Espécie", oFont8)
oPrint:Say  (1500, 0640, "R$", oFont10)
oPrint:Say  (1470, 0805, "Quantidade", oFont8)
oPrint:Say  (1470, 1275, "Valor", oFont8)
oPrint:Say  (1470, 1670, "(=)Valor do Documento", oFont8)
oPrint:Say  (1500, 2100, AllTrim(TransForm(nValorTit, "@E 999,999,999.99")), oFont10)
oPrint:Say  (1540, 0060, "Instruções (Texto de responsabilidade do cedente)", oFont8)

nJuros := Alltrim(TransForm((SE1->E1_SALDO * Mv_Par07)/100,PesqPict("SE1","E1_VALJUR")))
nDesco := Alltrim(TransForm(((SE1->E1_VALOR*SE1->E1_DESCFIN)/100)+SE1->E1_DESCONT,PesqPict("SE1","E1_VALOR")))

oPrint:Say  (1570, 0060, "APOS VENCTO, JUROS R$ " +nJuros+ " POR DIA DE ATRASO.", oFont10)
oPrint:Say  (1600, 0060, "CONCEDER DESCONTO NO VALOR DE R$ " +nDesco, oFont10)

oPrint:Line (1610, 1650, 1610, 2300)
oPrint:Line (1680, 1650, 1680, 2300)
oPrint:Line (1760, 1650, 1760, 2300)
oPrint:Line (1830, 1650, 1830, 2300)
oPrint:Line (1910, 0060, 1910, 2300)
oPrint:Line (2070, 0060, 2070, 2300)
oPrint:Line (2240, 0060, 2240, 2300)
	
oPrint:Say  (1540, 1670, "(-)Desconto/Abatimento", oFont8)
oPrint:Say  (1620, 1670, "(-)Outras Deduções", oFont8)
oPrint:Say  (1690, 1670, "(+)Mora/Multa", oFont8)
oPrint:Say  (1770, 1670, "(+)Outros Acréscimos", oFont8)
oPrint:Say  (1840, 1670, "(-)Valor Cobrado", oFont8)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Dados do Sacado (Cliente).        									³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oPrint:Say  (1920, 0060, "Sacado", oFont8)
oPrint:Say  (1920, 0200, AllTrim(SA1->A1_NOME)+" ("+AllTrim(SA1->A1_COD)+") ", oFont10)

IF Len(AllTrim(SA1->A1_CGC)) <= 11
	oPrint:Say  (1920, 1670, "CPF: "+TransForm(StrZero(Val(SA1->A1_CGC),11), "@R 999.999.999-99"), oFont10)
ELSE
	oPrint:Say  (1920, 1670, "CGC: "+TransForm( StrZero(Val(SA1->A1_CGC),14), "@R 99.999.999/9999-99"), oFont10)
EndIF

oPrint:Say  (1950, 0200, AllTrim(SA1->A1_End), oFont10)
oPrint:Say  (1990, 0200, TransForm(SA1->A1_CEP, "@R 99999-999") + " - " + AllTrim(SA1->A1_BAIRRO)+ " - "+ AllTrim(SA1->A1_MUN)+", "+SA1->A1_EST, oFont10)
oPrint:Say  (1990, 1670, cNossoNum, oFont10)

oPrint:Say  (2040, 0060, "Sacador/Avalista", oFont8)
oPrint:Say  (2040, 1670, "Codigo de Baixa", oFont8)
oPrint:Say  (2080, 1670, "Autenticação Mecânica", oFont8)

//----------------------------------------------------Imprime a Ficha de Compensacao.------------------------------------------------------------------//
oPrint:Line (2320, 0100, 2320, 2300)
oPrint:Line (2280, 0450, 2320, 0450)
oPrint:Line (2280, 0670, 2320, 0670)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao do Logotipo do banco.   									³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF !Empty(cBitMapBanco)
	oPrint:SayBitmap( 2241, 0040,cBitMapBanco,110,110 )
EndIF

oPrint:Say  (2280, 0180, "Banco Itau S.A.", oFont9)
oPrint:Say  (2245, 0500, cNumBanco + "-" + cDigBanco, oFont22)
oPrint:Say  (2245, 0750, cLinhaDig, oFont14N)

oPrint:Line (2420, 0060, 2420, 2300)
oPrint:Line (2500, 0060, 2500, 2300)
oPrint:Line (2580, 0060, 2580, 2300)
oPrint:Line (2650, 0060, 2650, 2300)

oPrint:Line (2320, 1650, 3030, 1650)

oPrint:Line (2500, 0480, 2580, 0480)
oPrint:Line (2500, 0795, 2580, 0795)
oPrint:Line (2500, 1030, 2580, 1030)
oPrint:Line (2500, 1270, 2580, 1270)

oPrint:Line (2580, 0480, 2650, 0480)
oPrint:Line (2580, 0600, 2650, 0600)
oPrint:Line (2580, 0795, 2650, 0795)
oPrint:Line (2580, 1270, 2650, 1270)

oPrint:Say  (2335, 0060, "Local de Pagamento", oFont8)
oPrint:Say  (2380, 0060, "PAGAVEL EM QUALQUER BANCO ATÉ O VENCIMENTO", oFont10)
oPrint:Say  (2335, 1670, "Vencimento", oFont8)
oPrint:Say  (2385, 2100, DTOC(cDtVencto), oFont10)
oPrint:Say  (2430, 0060, "Cedente", oFont8)
oPrint:Say  (2460, 0060, SM0->M0_NOMECOM, oFont10)
oPrint:Say  (2430, 1670, "Agência/Código Cedente", oFont8)
oPrint:Say  (2460, 1980, cDadosCta, oFont10)
oPrint:Say  (2510, 0060, "Data do Documento", oFont8)
oPrint:Say  (2540, 0170, DTOC(Date()), oFont10)
oPrint:Say  (2510, 0485, "Nro.Documento", oFont8)
oPrint:Say  (2540, 0550, cNumTit+"-"+cParcela, oFont10)
oPrint:Say  (2510, 0800, "Espécie Doc.", oFont8)
oPrint:Say  (2540, 0900, "DM", oFont10) // Duplicata Mercantil
oPrint:Say  (2510, 1035, "Aceite", oFont8)
oPrint:Say  (2540, 1135, "N", oFont10)
oPrint:Say  (2510, 1275, "Data do Processamento", oFont8)
oPrint:Say  (2540, 1335, DTOC(SE1->E1_EMISSAO), oFont10)
oPrint:Say  (2510, 1670, "Nosso Número", oFont8)
oPrint:Say  (2540, 1980, cNossoNum, oFont10)
oPrint:Say  (2590, 0060, "Uso do Banco", oFont8)
oPrint:Say  (2590, 0485, "Carteira", oFont8)
oPrint:Say  (2620, 0510, cCarteira, oFont10)
oPrint:Say  (2590, 0630, "Espécie", oFont8)
oPrint:Say  (2620, 0640, "R$", oFont10)
oPrint:Say  (2590, 0805, "Quantidade", oFont8)
oPrint:Say  (2590, 1275, "Valor", oFont8)
oPrint:Say  (2590, 1670, "(=)Valor do Documento", oFont8)
oPrint:Say  (2620, 2100, AllTrim(TransForm(nValorTit, "@E 999,999,999.99")), oFont10)
oPrint:Say  (2660, 0060, "Instruções (Texto de responsabilidade do cedente)", oFont8)

nJuros := Alltrim(TransForm((SE1->E1_SALDO * Mv_Par07)/100,PesqPict("SE1","E1_VALJUR")))
nDesco := Alltrim(TransForm(((SE1->E1_VALOR*SE1->E1_DESCFIN)/100)+SE1->E1_DESCONT,PesqPict("SE1","E1_VALOR")))

oPrint:Say  (2690, 0060, "APOS VENCTO, JUROS R$ " +nJuros+ " POR DIA DE ATRASO.", oFont10)
oPrint:Say  (2720, 0060, "CONCEDER DESCONTO NO VALOR DE R$ " +nDesco, oFont10)

oPrint:Line (2730, 1650, 2730, 2300)
oPrint:Line (2800, 1650, 2800, 2300)
oPrint:Line (2880, 1650, 2880, 2300)
oPrint:Line (2950, 1650, 2950, 2300)
oPrint:Line (3030, 0060, 3030, 2300)
oPrint:Line (3190, 0060, 3190, 2300)
	
oPrint:Say  (2660, 1670, "(-)Desconto/Abatimento", oFont8)
oPrint:Say  (2740, 1670, "(-)Outras Deduções", oFont8)
oPrint:Say  (2810, 1670, "(+)Mora/Multa", oFont8)
oPrint:Say  (2890, 1670, "(+)Outros Acréscimos", oFont8)
oPrint:Say  (2960, 1670, "(-)Valor Cobrado", oFont8)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Dados do Sacado (Cliente).        									³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oPrint:Say  (3040, 0060, "Sacado", oFont8)
oPrint:Say  (3040, 0200, AllTrim(SA1->A1_NOME)+" ("+AllTrim(SA1->A1_COD)+") ", oFont10)

IF Len(AllTrim(SA1->A1_CGC)) <= 11
	oPrint:Say  (3040, 1670, "CPF: "+TransForm(StrZero(Val(SA1->A1_CGC),11), "@R 999.999.999-99"), oFont10)
ELSE
	oPrint:Say  (3040, 1670, "CGC: "+TransForm( StrZero(Val(SA1->A1_CGC),14), "@R 99.999.999/9999-99"), oFont10)
EndIF

oPrint:Say  (3070, 0200, AllTrim(SA1->A1_End), oFont10)
oPrint:Say  (3110, 0200, TransForm(SA1->A1_CEP, "@R 99999-999") + " - " + AllTrim(SA1->A1_BAIRRO)+ " - "+ AllTrim(SA1->A1_MUN)+", "+SA1->A1_EST, oFont10)
oPrint:Say  (3110, 1670, cNossoNum, oFont10)

oPrint:Say  (3160, 0060, "Sacador/Avalista", oFont8)
oPrint:Say  (3160, 1670, "Codigo de Baixa", oFont8)
oPrint:Say  (3200, 1670, "Autenticação Mecânica - Ficha de Compensação", oFont8)
//MSBAR3("INT25", 23.5, 0.5, cCodBarras, oPrint , .F.,   ,   , , 1.2, , , , .F.)
MSBAR3("INT25", 27.0, 0.5, cCodBarras, oPrint , .F.,   ,   , , 1.2, , , , .F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza pagina.                     								³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oPrint:EndPage()

//If !lReimp
//	PutMV("MV_ITAUSEQ",Soma1(cNumBoleto,8))
//	If Val(GetMV("MV_ITAULIM")) - Val(GetMV("MV_ITAUSEQ")) <= 10
//		Aviso("Atencao","Faltam 10 numeros para finalizar a sequencia. Atualize os parametros MV_ITAUSEQ e MV_ITAULIM.",{"Ok"})
//	EndIf
//EndIf
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³    Mod10     ³ Autor ³   Alexandro Dias  ³ Data ³ 30/06/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Modulo 10.							                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function Mod10(cNumero)

Local nY  	:= 0
Local nProd := 0
Local nDigi := 0
Local nSoma := 0
Local nPeso := 1

For nY := Len(cNumero) TO 1 STEP -1
	nPeso  := IIF(nPeso == 1, 2, 1)
	nProd  := Val(Substr(cNumero,nY,01)) * nPeso
	nSoma  += Val(LEFT(STRZERO(nProd,2),1)) + Val(RIGHT(STRZERO(nProd,2),1))
Next
nDigi    :=  10 - ( nSoma % 10 )

Return STR( IF(nDigi > 9, 0, nDigi), 1, 0 )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	   ³Mod11NossoNum ³ Autor ³   Alexandro Dias  ³ Data ³ 30/06/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Somente para calculo do DV do nosso numero.                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function Mod11NossoNum(cNumero)

Local aPeso := {9,8,7,6,5,4,3,2}
Local nBase := Len(aPeso)+1
Local nY  	:= 0
Local nDigi := 0
Local nSoma := 0

For nY := Len(cNumero) TO 1 STEP -1
	nBase := IF(--nBase = 0,Len(aPeso),nBase)
	nSoma += Val(Substr(cNumero,nY,01)) * aPeso[ nBase ]
Next

nDigi := 11 - (nSoma % 11)

Return IF(nDigi > 9, "X", STR( nDigi, 1, 0 ))

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	   ³ Mod11Padrao  ³ Autor ³   Alexandro Dias  ³ Data ³ 30/06/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Somente para calculo do DV do codigo de barras.			  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function Mod11Padrao(cNumero)

Local aPeso := {9,8,7,6,5,4,3,2}
Local nBase := Len(aPeso)+1
Local nY  	:= 0
Local nDigi := 0
Local nSoma := 0      


For nY := Len(cNumero) TO 1 STEP -1
	nBase := IF(--nBase = 0,Len(aPeso),nBase)
	nSoma += Val(Substr(cNumero,nY,01)) * aPeso[ nBase ]
Next

nDigi := 11 - (nSoma % 11)

Return STR( IF(nDigi > 9, 1, nDigi), 1, 0 )


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³RetNumBoleto ³ Autor ³    Alexandro Dias     ³ Data ³ 30/06/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Retorna o numero do boleto.                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RetNumBoleto(nTam,cNumBanco)

Local cNumero

IF Empty(SE1->E1_NUMBCO)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Quando 1a. Impressao do boleto.         				       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF cNumBanco == "001"
		cNumero := ALLTRIM(SA6->A6_CODEMPR)+StrZero(Val(SEE->EE_FAXATU),nTam)
	Else
		cNumero := StrZero(Val(SEE->EE_FAXATU),nTam)
	EndIF
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Quando re-impressao do boleto.         				           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cNumero:= StrZero(Val(SE1->E1_NUMBCO),nTam)
EndIF

IF Empty(SE1->E1_NUMBCO)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Quando 1a. Impressao do boleto atualiza sequencial do nosso numero. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbSelectArea("SEE")
	RecLock("SEE",.F.)
	Replace EE_FAXATU With StrZero(Val(cNumero)+1,10)
	MsUnlock()
EndIF

DbSelectArea("SE1")

Return(cNumero)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	   ³LinhaDigitavel³ Autor ³   Alexandro Dias  ³ Data ³ 30/06/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Formata linha digitavel.               	                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function LinhaDigitavel( cCodBarras, cValorTit )

Local nCampo1
Local nCampo2
Local nCampo3
Local nCampo4
Local cRet

nCampo1 := Substr(cCodBarras,01,04)+Substr( cCodBarras, 20, 5 )
nCampo1 += Mod10( nCampo1 )
nCampo2 := Substr( cCodBarras, 25, 10 )
nCampo2 += Mod10( nCampo2 )
nCampo3 := Substr( cCodBarras, 35, 10 )
nCampo3 += Mod10( nCampo3 )
nCampo4 := Substr( cCodBarras, 05, 01 )
cRet 	:= TransForm( nCampo1+nCampo2+nCampo3+nCampo4, "@R 99999.99999   99999.999999   99999.999999  9" ) + "   " + cValorTit

Return(cRet)
