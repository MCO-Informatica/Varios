#INCLUDE "Protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO3     ºAutor  ³Junior Carvalho     º Data ³  08/08/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Este programa associa manualmente os Pedido de Compra no   º±±
±±º          ³ Documento de Entrada                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º                        Manutencao Efetuada                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAnalista Resp.  |  Data    | Descrição                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±± 
±±ºJunior Carvalho |09/09/2014| Inclusao de condicoes para baixar   o     º±±
±±º                |          | Pedido de Compra.SC7->C7_QUJE             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±± 
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function PEDFRT001()
	Static oDlg
	Static oConfirma,oCancela,oItem,oPed, oSay1, oSay2

	PRIVATE cPedido := CriaVar("D1_PEDIDO",.F.)
	PRIVATE cItemPC := CriaVar("D1_ITEMPC",.F.)
	Private cChvSF1 := SF1->F1_FILIAL+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA

	dbSelectArea("SD1")
	dbSetOrder(1)
	MsSeek(cChvSF1)

	cPedido := SD1->D1_PEDIDO
	cItemPC := iif(Empty(SD1->D1_ITEMPC),cItemPC,SD1->D1_ITEMPC)

	If SF1->F1_TIPO == 'C' .AND. SD1->D1_QUANT == 0  .AND. AllTrim(SD1->D1_CF) $ '1933|1353' .AND. EMPTY(cPedido)

		DEFINE MSDIALOG oDlg TITLE "Nota Fiscal "+SF1->F1_DOC FROM 000, 000  TO 150, 300 COLORS 0, 16777215 PIXEL STYLE DS_MODALFRAME

		@ 004, 050 SAY oSay1 PROMPT "Pedido de Compra" SIZE 050, 007 OF oDlg COLORS 0, 16777215 PIXEL
		@ 024, 024 SAY oSay1 PROMPT "Numero" SIZE 030, 007 OF oDlg COLORS 0, 16777215 PIXEL
		@ 039, 025 SAY oSay2 PROMPT "Item" SIZE 030, 007 OF oDlg COLORS 0, 16777215 PIXEL
		@ 023, 055 MSGET oPed VAR cPedido SIZE 060, 010 OF oDlg COLORS 0, 16777215 F3 "SC7ITE" PIXEL
		@ 037, 055 MSGET oItem VAR cItemPC SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL WHEN .F.
		DEFINE SBUTTON oConfirma FROM 060, 050 TYPE 01 OF oDlg ENABLE ACTION Eval( {||nOpca:=1, Gravar(), oDlg:End() } ) WHEN cPedido <> ' ' .and. !empty(cItemPC)
		DEFINE SBUTTON oCancela  FROM 060, 090 TYPE 02 OF oDlg ENABLE ACTION oDlg:End()

		ACTIVATE MSDIALOG oDlg CENTERED

	Else
		Aviso("PEDFRT001", "ROTINA PERMITIDA SOMENTE PARA FRETE";
		+CRLF+CRLF+"Tipo de Documento tem que ser do Tipo 'C'";
		+CRLF+CRLF+"CFOP tem que ser 1353 ou 1933 ";
		+CRLF+CRLF+"O numero do Pedido pode estar Preenchido", {"Ok"},3 )
	EndIF


Return()

Static Function Gravar()

	IF SC7->C7_QUANT > SC7->C7_QUJE
		dbSelectArea("SD1")
		dbSetOrder(1)
		If MsSeek(cChvSF1)

			While !SD1->(Eof()) .And. ( cChvSF1 == xFilial("SD1")+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA )

				dbSelectArea("SC7")
				dbSetOrder(1)
				If MsSeek(xFilial("SC7")+cPedido+cItemPC)

					nSldPed := SC7->C7_QUANT-SC7->C7_QUJE-SC7->C7_QTDACLA
					IF nSldPed >= SD1->D1_TOTAL

						RecLock("SC7",.F.)
						SC7->C7_QUJE := SC7->C7_QUJE + SD1->D1_TOTAL
						MsUnlock()

						Reclock("SD1",.F.)
						SD1->D1_PEDIDO := cPedido
						SD1->D1_ITEMPC := cItemPC
						MsUnLock()

					ELSE
						ALERT("Saldo do Pedido é menor do que a Quantidade da NF.")
					ENDIF
				EndIf
				dbSelectArea("SD1")
				DbSkip()
				Loop
			Enddo
		ELSE
			alert("Itens não encontrado!")
		Endif
	ELSE
		alert("Saldo Insuficiente! Escolha outro Produto.")
	Endif

Return()