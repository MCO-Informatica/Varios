#include "Protheus.ch"
#DEFINE INGLES                     1
#DEFINE PORTUGUES                  2
#DEFINE LITERAL_PEDIDO             IF( nIdioma == INGLES, "PURCHASE ORDER NR: ", "NR. PEDIDO: " ) //"NR. PEDIDO: "
#DEFINE LITERAL_ALTERACAO          IF( nIdioma == INGLES, "REVISION Number: ", "ALTERA�+O N�mero: " ) //"ALTERA�+O N�mero: "
#DEFINE LITERAL_DATA               IF( nIdioma == INGLES, "Date: "             , "Data: ")
#DEFINE LITERAL_PAGINA             IF( nIdioma == INGLES, "Page: "             , "P�gina: ")
#DEFINE LITERAL_FORNECEDOR         IF( nIdioma == INGLES, "SUPPLIER........: " , "FORNECEDOR......: ")
#DEFINE LITERAL_ENDERECO           IF( nIdioma == INGLES, "ADDRESS.........: " , "ENDERE�O........: ")
#DEFINE LITERAL_REPRESENTANTE      IF( nIdioma == INGLES, "REPRESENTATIVE..: " , "REPRESENTANTE...: ")
#DEFINE LITERAL_REPR_TEL           IF( nIdioma == INGLES, "TEL.: "             , "FONE: ")
#DEFINE LITERAL_COMISSAO           IF( nIdioma == INGLES, "COMMISSION......: " , "COMISS+O........: ")
#DEFINE LITERAL_CONTATO            IF( nIdioma == INGLES, "CONTACT.........: " , "CONTATO.........: ")
#DEFINE LITERAL_IMPORTADOR         IF( nIdioma == INGLES, "IMPORTER........: " , "IMPORTADOR......: ")
#DEFINE LITERAL_CONDICAO_PAGAMENTO IF( nIdioma == INGLES, "TERMS OF PAYMENT: " , "COND. PAGAMENTO.: ")
#DEFINE LITERAL_VIA_TRANSPORTE     IF( nIdioma == INGLES, "MODE OF DELIVERY: " , "VIA TRANSPORTE..: ")
#DEFINE LITERAL_DESTINO            IF( nIdioma == INGLES, "DESTINATION.....: " , "DESTINO.........: ")
#DEFINE LITERAL_AGENTE             IF( nIdioma == INGLES, "FORWARDER.......: " , "AGENTE..........: ")
#DEFINE LITERAL_QUANTIDADE         IF( nIdioma == INGLES, "Quantity"           , "Quantidade")
#DEFINE LITERAL_DESCRICAO          IF( nIdioma == INGLES, "Description"        , "Descri��o")
#DEFINE LITERAL_FABRICANTE         IF( nIdioma == INGLES, "Manufacturer"       , "Fabricante")
#DEFINE LITERAL_PRECO_UNITARIO1    IF( nIdioma == INGLES, "Unit"               , "Pre�o")
#DEFINE LITERAL_PRECO_UNITARIO2    IF( nIdioma == INGLES, "Price"              , "Unit�rio")
#DEFINE LITERAL_TOTAL_MOEDA        IF( nIdioma == INGLES, "Amount"             , "   Total")
#DEFINE LITERAL_DATA_PREVISTA1     IF( nIdioma == INGLES, "Req. Ship"          , "Data Prev.")
#DEFINE LITERAL_DATA_PREVISTA3     IF( nIdioma == INGLES, "Delivery"           , "Data Entrega")
#DEFINE LITERAL_DATA_PREVISTA2     IF( nIdioma == INGLES, "Date"               , "Embarque")
#DEFINE LITERAL_OBSERVACOES        IF( nIdioma == INGLES, "REMARKS"            , "OBSERVA�iES")
#DEFINE LITERAL_INLAND_CHARGES     IF( nIdioma == INGLES, "INLAND CHARGES"     , "Despesas Internas")
#DEFINE LITERAL_PACKING_CHARGES    IF( nIdioma == INGLES, "PACKING CHARGES"    , "Despesas Embalagem")
#DEFINE LITERAL_INTL_FREIGHT       IF( nIdioma == INGLES, "INT'L FREIGHT"      , "Frete Internacional")
#DEFINE LITERAL_DISCOUNT           IF( nIdioma == INGLES, "DISCOUNT"           , "Desconto")
#DEFINE LITERAL_OTHER_EXPEN        IF( nIdioma == INGLES, "OTHER EXPEN."       , "Outras Despesas")
#DEFINE LITERAL_STORE              IF( nIdioma == INGLES, "STORE: "            , "Loja")
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �IMCD150   �Autor  �Leandro Duarte      � Data �  05/29/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Novo relatorio do EIC para mudar as regras do IMCD          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � MP10 E MP11                                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function IMCD150(aMarcados,nIdiom,cSiN)
Local nMarcados
Local cIDCli  :=  GetMv("MV_ID_CLI")
Private Linha := 10
Private oPrint
Private lMaisPag := .F.
Private oF12N  := tFont():New("Times New Roman" , ,12,, .T., , , , .T., .F.)
Private oF12   := tFont():New("Times New Roman" , ,12,, .F., , , , .T., .F.)
Private oF10   := tFont():New("Times New Roman" , ,10,, .F., , , , .T., .F.)
Private oF10A  := tFont():New("Ariel"			 , ,10,, .F., , , , .T., .F.)
Private oF10An := tFont():New("Ariel"			 , ,10,, .T., , , , .T., .F.)
Private oF12n  := tFont():New("Times New Roman" , ,12,, .T., , , , .T., .F.)
Private oF10   := tFont():New("Times New Roman" , ,10,, .F., , , , .T., .F.)
Private oF10n  := tFont():New("Times New Roman" , ,10,, .T., , , , .T., .f.)
Private oF08   := tFont():New("Times New Roman" , ,08,, .F., , , , .T., .F.)
Private oF08n  := tFont():New("Times New Roman" , ,08,, .T., , , , .T., .F.)
Private oF08nu := tFont():New("Times New Roman" , ,08,, .T., , , , .T., .T.)
Private oF06   := tFont():New("Times New Roman" , ,06,, .F., , , , .T., .F.)
Private oF06n  := tFont():New("Times New Roman" , ,06,, .T., , , , .T., .F.)
Private oF05   := tFont():New("Times New Roman" , ,05,, .F., , , , .T., .F.)
Private oF05n  := tFont():New("Times New Roman" , ,05,, .T., , , , .T., .F.)
Private oF04   := tFont():New("Times New Roman" , ,06,, .F., , , , .T., .F.)
Private oF04n  := tFont():New("Times New Roman" , ,06,, .T., , , , .T., .F.)
Private nIdioma:= nIdiom

oPrint	:= TMSPrinter():New("PURCHASE ORDER")
oPrint:SetPortrait()
nPagina:=0
ProcRegua(Len(aMarcados))

For nMarcados:=1 To Len(aMarcados)
	nPagina:=0
	Linha := 10
	SW2->(dbGoTo(aMarcados[nMarcados]))
	IncProc("Imprimindo...") // Atualiza barra de progresso
	oPrint:StartPage()
	//oPrint:SayBitmap(Linha, 0050, 'logoIMCD.bmp', 2000, 0100)
	oPrint:SayBitmap(Linha, 0200, 'logoIMCD.bmp', 2100, 0100)
	pTipo := 1
	//imprimi o relatorio
	IMCD15A()
	
	oPrint:SayBitmap(3300, 1800, 'logoIMCD1.bmp', 0450, 0075)
	dbSelectArea("SW3")
	SW3->(dbSetOrder(1))
	SW3->(dbSeek(xFilial()+SW2->W2_PO_NUM))
	
	While SW3->(!Eof()) .AND.;
		SW3->W3_FILIAL == XFILIAL("SW3") .AND. ;
		SW3->W3_PO_NUM == SW2->W2_PO_NUM
		
		If SW3->W3_SEQ #0
			SW3->(dbSkip())
			LOOP
		Endif
		
		If Linha >= 3201
			Linha := 10
			oPrint:EndPage()
			oPrint:StartPage()
			oPrint:SayBitmap(Linha, 0200, 'logoIMCD.bmp', 2100, 0100)
			pTipo := 1
			//imprimi o relatorio
			IMCD15A()
			oPrint:SayBitmap(3300, 1800, 'logoIMCD1.bmp', 0450, 0075)
		Endif
		// imprimi os itens
		SItem()
		
		pTipo := 5
		PO150B()
		Linha := Linha + 50
		SW3->(dbSkip())
	Enddo //loop dos itens SW3
	If Linha >= 3001
		Linha := 10
		oPrint:EndPage()
		oPrint:StartPage()
		oPrint:SayBitmap(Linha, 0200, 'logoIMCD.bmp', 2100, 0100)
		oPrint:SayBitmap(3300, 1800, 'logoIMCD1.bmp', 0450, 0075)
		cCliComp:=IF( cIDCli = 'S',SA1->A1_NOME,SY1->Y1_NOME)
		IMCD15A(.T.)
	ENDIF
	IMCD150T()
   	IMCD150R()
	//SVG - 15/09/2011 - Ajuste no campo observa��o n�o deve ter limite de impress�o.
	If !lMaisPag
		//oPrint:Line(Linha, 50, Linha, 1511 )  //JUNIOR CARVALHO
		//oPrint:Line(Linha+1, 50, Linha+1, 1511 )//JUNIOR CARVALHO
		Linha := Linha + 45
		oPrint:Say(Linha, 60, cCliComp, oF12 )
	Else
		Linha := Linha+45
		pTipo := 9
		PO150B()
		oPrint:Line(Linha, 50, Linha, 2300 )
		oPrint:Say(Linha, 60, cCliComp, oF12 )
		Linha := Linha+100
		oPrint:Line(Linha, 50, Linha, 2300 )
	EndIf
	
	
	//+---------------------------------------------------------+
	//� Atualiza FLAG de EMITIDO                                �
	//+---------------------------------------------------------+
	dbSelectArea("SW2")
	
	//RecLock("SW2",.F.)
	//SW2->W2_EMITIDO := "S" //PO Impresso
	//SW2->W2_OK      := ""  //PO Desmarcado
	//MsUnLock()
	
	If nMarcados+1 <= Len(aMarcados)
		Linha := 10
		oPrint:EndPage()
	Endif
	
Next
oPrint:Preview()
Return()

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �IMCD150   �Autor  �Microsiga           � Data �  05/29/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
static function IMCD15A(lSai)
local i
Local c2EndSM0:=""
Local c2EndSA2:=""
Local cCommission:=""
Local c2EndSYT:=""
Local cTerms:=""
Local cDestinat:=""
Local cRepr:=""
Local cCGC:=""
Local cNr:=""
Local cIDCli := GetMv("MV_ID_CLI")
Default lSai	:= .F.

nPagina+=1

IF  cIDCli == 'S'
	//-----------> Cliente.
	SA1->( DBSETORDER( 1 ) )
	SA1->( DBSEEK( xFilial("SA1")+SW2->W2_CLIENTE+EICRetLoja("SW2","W2_CLILOJ") ) )
ELSE
	// --------->  Comprador.
	SY1->( DBSETORDER(1) )
	SY1->( DBSEEK( xFilial("SY1")+SW2->W2_COMPRA ) )
ENDIF
//----------->  Fornecedor.
SA2->( DBSETORDER( 1 ) )
SA2->( DBSEEK( xFilial()+SW2->W2_FORN+EICRetLoja("SW2","W2_FORLOJ") ) )
//----------->  Paises.
SYA->( DBSETORDER( 1 ) )
SYA->( DBSEEK( xFilial()+SA2->A2_PAIS ) )

c2EndSA2 := c2EndSA2 + IF( !EMPTY(SA2->A2_MUN   ), ALLTRIM(SA2->A2_MUN   )+' - ', "" )
c2EndSA2 := c2EndSA2 + IF( !EMPTY(SA2->A2_BAIRRO), ALLTRIM(SA2->A2_BAIRRO)+' - ', "" )
c2EndSA2 := c2EndSA2 + IF( !EMPTY(SA2->A2_ESTADO), ALLTRIM(SA2->A2_ESTADO)+' - ', "" )
IF nIdioma==INGLES
	c2EndSA2 := c2EndSA2 + IF( !EMPTY(SYA->YA_PAIS_I ), ALLTRIM(SYA->YA_PAIS_I )+' - ', "" )
ELSE
	c2EndSA2 := c2EndSA2 + IF( !EMPTY(SYA->YA_DESCR ), ALLTRIM(SYA->YA_DESCR )+' - ', "" )
ENDIF
c2EndSA2 := LEFT( c2EndSA2, LEN(c2EndSA2)-2 )

//-----------> Pedidos.


cCommission :=SW2->W2_MOEDA+" "+TRANS(SW2->W2_VAL_COM,E_TrocaVP(nIdioma,'@E 9,999,999,999.9999'))
IiF( SW2->W2_TIP_COM == "1", cCommission:=TRANS(SW2->W2_PER_COM,E_TrocaVP(nIdioma,'@E 999.99'))+"%", )

IiF( SW2->W2_TIP_COM == "4", cCommission:=SW2->W2_OUT_COM, )


//-----------> Importador.
SYT->( DBSETORDER( 1 ) )
SYT->( DBSEEK( xFilial()+SW2->W2_IMPORT ) )
cPaisImpor := Alltrim(Posicione("SYA",1,xFilial("SYA")+SYT->YT_PAIS,"YA_DESCR"))    //Acb - 26/11/2010

c2EndSYT := c2EndSYT + IF( !EMPTY(SYT->YT_CIDADE), ALLTRIM(SYT->YT_CIDADE)+' - ', "" )
c2EndSYT := c2EndSYT + IF( !EMPTY(SYT->YT_ESTADO), ALLTRIM(SYT->YT_ESTADO)+' - ', "" )
c2EndSYT := c2EndSYT + IF( !EMPTY(cPaisImpor), cPaisImpor  +' - ', "" )    //Acb - 26/11/2010
c2EndSYT := LEFT( c2EndSYT, LEN(c2EndSYT)-2 )
cCgc     := ALLTRIM(SYT->YT_CGC)

IF GetMv("MV_ID_EMPR") == 'S'
	c2EndSM0 := c2EndSM0 +IF( !EMPTY(SM0->M0_CIDCOB), ALLTRIM(SM0->M0_CIDCOB)+' - ', "" )
	c2EndSM0 := c2EndSM0 +IF( !EMPTY(SM0->M0_ESTCOB), ALLTRIM(SM0->M0_ESTCOB)+' - ', "" )
	c2EndSM0 := c2EndSM0 +IF( !EMPTY(SM0->M0_CEPCOB), TRANS(SM0->M0_CEPCOB,"@R 99999-999")+' - ', "" )
	c2EndSM0 := LEFT( c2EndSM0, LEN(c2EndSM0)-2 )
ELSE
	c2EndSM0 := c2EndSM0 +IF( !EMPTY(SYT->YT_CIDADE), ALLTRIM(SYT->YT_CIDADE)+' - ', "" )
	c2EndSM0 := c2EndSM0 +IF( !EMPTY(SYT->YT_ESTADO), ALLTRIM(SYT->YT_ESTADO)+' - ', "" )
	c2EndSM0 := c2EndSM0 +IF( !EMPTY(SYT->YT_CEP), TRANS(SYT->YT_CEP,"@R 99999-999")+' - ', "" )
	c2EndSM0 := LEFT( c2EndSM0, LEN(c2EndSM0)-2 )
ENDIF

//-----------> Condicoes de Pagamento.
SY6->( DBSETORDER( 1 ) )
SY6->( DBSEEK( xFilial()+SW2->W2_COND_PA+STR(SW2->W2_DIAS_PA,3,0) ) )

IF nIdioma == INGLES
	cTerms := MSMM(SY6->Y6_DESC_I,AVSX3("Y6_VM_DESI",3))//48)	//ASR 04/11/2005
ELSE
	cTerms := MSMM(SY6->Y6_DESC_P,AVSX3("Y6_VM_DESP",3))//48)	//ASR 04/11/2005
ENDIF
cTerms := STRTRAN(cTerms, CHR(13)+CHR(10), " ")	//ASR 04/11/2005

//-----------> Portos.
SY9->( DBSETORDER( 2 ) )
SY9->( DBSEEK( xFilial()+SW2->W2_DEST ) )

cDestinat := ALLTRIM(SW2->W2_DEST) + " - " + ALLTRIM(SY9->Y9_DESCR)

//-----------> Agentes Embarcadores.
SY4->( DBSETORDER( 1 ) )
SY4->( DBSEEK( xFilial()+SW2->W2_AGENTE ) ) //W2_FORWARD ) )     // GFP - 10/06/2013

//-----------> Agentes Embarcadores.
SYQ->( DBSEEK( xFilial()+SW2->W2_TIPO_EMB ) )

//-----------> Agentes Compradores.
SY1->(DBSEEK(xFilial()+SW2->W2_COMPRA))

Linha := Linha+155// acb - 29/01/2010

IF GetMv("MV_ID_EMPR") == 'S'
	oPrint:Say(Linha, direita(ALLTRIM(SM0->M0_NOMECOM),2095), ALLTRIM(SM0->M0_NOMECOM), oF10An)
	Linha := Linha+45
	oPrint:Say(Linha, direita(ALLTRIM(SM0->M0_ENDCOB),2190), ALLTRIM(SM0->M0_ENDCOB), oF10A)
	Linha := Linha+45
	oPrint:Say(Linha, direita(ALLTRIM(SM0->M0_BAIRCOB)+' - '+ALLTRIM(SM0->M0_CIDENT),2215), ALLTRIM(SM0->M0_BAIRCOB)+' - '+ALLTRIM(SM0->M0_CIDENT), oF10A)
	Linha := Linha+45
	oPrint:Say(Linha, DIREITA(ALLTRIM(SM0->M0_ESTENT)+' - '+ALLTRIM(SM0->M0_CEPENT),2265), ALLTRIM(SM0->M0_ESTENT)+' - '+ALLTRIM(SM0->M0_CEPENT), oF10A)
	Linha := Linha+45
	oPrint:Say(Linha, DIREITA('Tel. +55 '+LEFT(ALLTRIM(SM0->M0_TEL),9)+'-'+RIGHT(ALLTRIM(SM0->M0_TEL),4),2285), 'Tel. +55 '+LEFT(ALLTRIM(SM0->M0_TEL),9)+'-'+RIGHT(ALLTRIM(SM0->M0_TEL),4), oF10A)
	Linha := Linha+45
	oPrint:Say(Linha, DIREITA('Fax. +55 '+LEFT(ALLTRIM(SM0->M0_FAX),6)+'-'+RIGHT(ALLTRIM(SM0->M0_FAX),4),2270), 'Fax. +55 '+LEFT(ALLTRIM(SM0->M0_FAX),6)+'-'+RIGHT(ALLTRIM(SM0->M0_FAX),4), oF10A)
	Linha := Linha+45
	oPrint:Say(Linha, DIREITA('www.imcdgroup.com',2248), 'www.imcdgroup.com', oF10A)
ELSE
	If SYT->(FieldPos("YT_COMPEND")) > 0
		cNr:=IF(!EMPTY(SYT->YT_COMPEND),ALLTRIM(SYT->YT_COMPEND),"") + IF(!EMPTY(SYT->YT_NR_END),", "+ALLTRIM(STR(SYT->YT_NR_END,6)),"")
	Else
		cNr:=IF(!EMPTY(SYT->YT_NR_END),", "+ALLTRIM(STR(SYT->YT_NR_END,6)),"")
	EndIf
	oPrint:Say(Linha, direita(ALLTRIM(SYT->YT_NOME),2200), ALLTRIM(SYT->YT_NOME), oF10An)
	Linha := Linha+45
	IF LEN(ALLTRIM(cNr)) > 7
		oPrint:Say(Linha, direita(ALLTRIM(SYT->YT_ENDE),2200), ALLTRIM(SYT->YT_ENDE), oF10A)
		Linha := Linha+45
		oPrint:Say(Linha, direita(ALLTRIM(cNr),2215), ALLTRIM(cNr), oF10A)
		Linha := Linha+45
	ELSE
		oPrint:Say(Linha, direita(ALLTRIM(SYT->YT_ENDE),2170), ALLTRIM(SYT->YT_ENDE)+ALLTRIM(cNr), oF10A)
		Linha := Linha+45
	ENDIF
	oPrint:Say(Linha, direita('Tel. +55 '+LEFT(ALLTRIM(SM0->M0_TEL),9)+'-'+RIGHT(ALLTRIM(SM0->M0_TEL),4),2255), 'Tel. +55 '+LEFT(ALLTRIM(SM0->M0_TEL),9)+'-'+RIGHT(ALLTRIM(SM0->M0_TEL),4), oF10A)
	Linha := Linha+45
	oPrint:Say(Linha, direita('Fax. +55 '+LEFT(ALLTRIM(SM0->M0_FAX),6)+'-'+RIGHT(ALLTRIM(SM0->M0_FAX),4),2240), 'Fax. +55 '+LEFT(ALLTRIM(SM0->M0_FAX),6)+'-'+RIGHT(ALLTRIM(SM0->M0_FAX),4), oF10A)
	Linha := Linha+45
	oPrint:Say(Linha, direita('www.imcdgroup.com',2218), 'www.imcdgroup.com', oF10A)
ENDIF
//endif
Linha := Linha+85

oPrint:Line (Linha - 05, 050, Linha - 05, 2300) // linha
Linha := Linha+90
oPrint:Say(Linha, CENTRALI(LITERAL_PEDIDO + ALLTRIM(TRANS(SW2->W2_PO_NUM,_PictPo)),1050), LITERAL_PEDIDO + ALLTRIM(TRANS(SW2->W2_PO_NUM,_PictPo)),oF12 )
Linha := Linha+90

IF ! EMPTY(SW2->W2_NR_ALTE)
	oPrint:Say(Linha, 400 , LITERAL_ALTERACAO + STRZERO(SW2->W2_NR_ALTE,2) , oF12 )
	oPrint:Say(Linha, 1770, LITERAL_DATA + DATA_MES( SW2->W2_DT_ALTE )     , oF12 )
	Linha := Linha+50
ENDIF

oPrint:Say(Linha , 400 , LITERAL_DATA + DATA_MES( SW2->W2_PO_DT ) , oF12 )
oPrint:Say(Linha , 1770, LITERAL_PAGINA + STRZERO(nPagina,3)  , oF12 )
Linha := Linha + 50

IF nPagina > 1
	oPrint:Line (Linha , 050, Linha , 2300) // JUNIOR CARVALHO 
ENDIF



If pTipo == 2
	Return
Endif
if lSai
	return()
endif
Linha := Linha+20
oPrint:Line (Linha - 05, 050, Linha - 05, 2300) // linha
pTipo := 3
PO150B()

Linha := Linha+20
pTipo := 1
PO150B()

oPrint:Say(Linha , 100, LITERAL_FORNECEDOR, oF12N )
oPrint:Say(Linha , 630, SA2->A2_NOME, oF12 ) //JUNIOR CARVALHO
//oPrint:Say(Linha , 630, SA2->A2_NREDUZ + Space(2) + Alltrim(IF(EICLOJA(), LITERAL_STORE + Alltrim(SA2->A2_LOJA),"")) , oF12 )
Linha := Linha+50
pTipo := 1
PO150B()

oPrint:Say(Linha , 100, LITERAL_ENDERECO,oF12N)
oPrint:Say(Linha ,  630, ALLTRIM(SA2->A2_END)+" "+ALLTRIM(SA2->A2_NR_END), oF12 )
Linha := Linha+50

If !Empty(SA2->A2_COMPLEM)  // GFP - 31/10/2013
	oPrint:Say(Linha , 630, ALLTRIM(SA2->A2_COMPLEM), oF12 )
	Linha := Linha+50
EndIf

pTipo := 1
PO150B()

oPrint:Say(Linha , 630, c2EndSA2              , oF12 )
Linha := Linha+50

pTipo := 1
PO150B()

oPrint:Say(Linha , 630, SA2->A2_CEP           , oF12 )
Linha := Linha+50

cRepr:=IF(nIdioma==INGLES,"NONE","NAO HA")

pTipo := 1
PO150B()

oPrint:Say(Linha , 100, LITERAL_REPRESENTANTE, oF12N )
oPrint:Say(Linha , 630, IF(EMPTY(SA2->A2_REPRES),cRepr,SA2->A2_REPRES)       , oF12 )
Linha := Linha+50

pTipo := 1
PO150B()

oPrint:Say(Linha , 100, LITERAL_ENDERECO, oF12N )
oPrint:Say(Linha , 630, SA2->A2_REPR_EN , oF12 )
Linha := Linha+50

pTipo := 1
PO150B()

//oPrint:Say(Linha , 100, LITERAL_COMISSAO, oF12N ) //JUNIOR
//oPrint:Say(Linha , 630, cCommission     , oF12 ) //JUNIOR
oPrint:Say(Linha , 100, LITERAL_CONTATO, oF12N )
oPrint:Say(Linha , 630, SA2->A2_CONTATO, oF12 )

pTipo := 1
PO150B()

oPrint:Say(Linha , 1750, LITERAL_REPR_TEL, oF12N )
oPrint:Say(Linha , 1910, ALLTRIM(IF(!EMPTY(SA2->A2_REPRES),SA2->A2_REPRTEL,ALLTRIM(SA2->A2_DDI)+" "+ALLTRIM(SA2->A2_DDD)+" "+SA2->A2_TEL)), oF12 )
Linha := Linha+50

pTipo := 1
PO150B()

//oPrint:Say(Linha , 100, LITERAL_CONTATO, oF12N )
//oPrint:Say(Linha , 630, SA2->A2_CONTATO, oF12 )

oPrint:Say(Linha , 1750, "FAX.: "           , oF12N )
oPrint:Say(Linha , 1910, ALLTRIM(IF(!EMPTY(SA2->A2_REPRES),SA2->A2_REPRFAX,ALLTRIM(SA2->A2_DDI)+" "+ALLTRIM(SA2->A2_DDD)+" "+SA2->A2_FAX)), oF12 )
Linha := Linha+50

pTipo := 3
PO150B()

Linha := Linha+20
oPrint:Line (Linha - 05, 050, Linha - 05, 2300) // linha

pTipo := 1
PO150B()

oPrint:Say(Linha , 100, LITERAL_IMPORTADOR, oF12N )
oPrint:Say(Linha , 630, SYT->YT_NOME      , oF12 )
Linha := Linha+50

pTipo := 1
PO150B()

IF SYT->(FieldPos("YT_COMPEND")) > 0  // TLM - 09/06/2008 Inclus�o do campo complemento, SYT->YT_COMPEND
	cNr:=If(!EMPTY(SYT->YT_COMPEND),ALLTRIM(SYT->YT_COMPEND),"") + IF(!EMPTY(SYT->YT_NR_END),", " +  ALLTRIM(STR(SYT->YT_NR_END,6)),"")
Else
	cNr:=IF(!EMPTY(SYT->YT_NR_END),", "+ALLTRIM(STR(SYT->YT_NR_END,6)),"")
EndIF

oPrint:Say(Linha , 630, ALLTRIM(SYT->YT_ENDE)+ " " + cNr, oF12 )
Linha := Linha+50

pTipo := 1
PO150B()

oPrint:Say(Linha , 630, c2EndSYT           , oF12 )
Linha := Linha+50

IF ! EMPTY(cCGC)
	pTipo := 1
	PO150B()
	
	oPrint:Say(Linha , 630, AVSX3("YT_CGC",5)+": "  + Trans(cCGC,"@R 99.999.999/9999-99") , oF12 ) // "C.N.P.J. "
	Linha := Linha+50
ENDIF

pTipo := 3
PO150B()

Linha := Linha+20
Linha := Linha+20
pTipo := 1
PO150B()

oPrint:Say(Linha , 100 , "PROFORMA INVOICE: ", oF12N ) //"PROFORMA INVOICE: "
oPrint:Say(Linha , 1720, LITERAL_DATA            , oF12N )
oPrint:Line (Linha - 05, 050, Linha - 05, 2300) // linha

If lNewProforma .and. GetMv("MV_AVG0186",,.F.)
	EYZ->(DbSetOrder(2))
	EYZ->(DbSeek(xFilial("EYZ")+ SW2->W2_PO_NUM ))
	
	Do While EYZ->(!EOF()) .AND. xFilial("EYZ") == EYZ->EYZ_FILIAL .AND. EYZ->EYZ_PO_NUM == SW2->W2_PO_NUM
		
		oPrint:Say(Linha , 630 , EYZ->EYZ_NR_PRO         , oF12 )
		oPrint:Say(Linha , 1920, DATA_MES(EYZ->EYZ_DT_PRO), oF12 )
		Linha := Linha+50
		
		EYZ->(DbSkip())
	Enddo
Else
	oPrint:Say(Linha , 630 , SW2->W2_NR_PRO          , oF12 )
	oPrint:Say(Linha , 1920, DATA_MES(SW2->W2_DT_PRO), oF12 )
Endif
Linha := Linha+50

pTipo := 3
PO150B()

Linha := Linha+20
oPrint:Line (Linha - 05, 050, Linha - 05, 2300) // linha

nLinCp := Max(MLCOUNT( cTerms, 80 ),1)

oPrint:Box(Linha -50, 50, (Linha+100+50*nLinCp),   50 )
oPrint:Box(Linha -50, 51, (Linha+100+50*nLinCp),   51 )
oPrint:Box(Linha -50, 2300, (Linha+100+50*nLinCp), 2300 )
oPrint:Box(Linha -50, 2300, (Linha+100+50*nLinCp), 2300 )

Linha := Linha+20//FSY - 02/05/2013

oPrint:Say(Linha, 100, LITERAL_CONDICAO_PAGAMENTO , oF12N )

IF nIdioma == INGLES
	FOR i:=1 TO MLCOUNT( cTerms, 80 )
		oPrint:Say(Linha, 630, MEMOLINE(cTerms,80,i)      , oF12 )
		Linha := Linha+50
	Next
ELSE
	FOR i:=1 TO MLCOUNT( cTerms, 80 )
		oPrint:Say(Linha, 630, MEMOLINE(cTerms,80,i)      , oF12 )
		Linha := Linha+50
	Next
ENDIF
If MLCOUNT( cTerms, 80 ) == 0
	Linha := Linha+50
EndIf

pTipo := 3
PO150B()

Linha := Linha+20
oPrint:Line (Linha , 050, Linha , 2300) // linha
oPrint:Line (Linha+1 , 050, Linha+1 , 2300) // linha
Linha := Linha+20

pTipo := 1
PO150B()

oPrint:Say(Linha, 100, "INCOTERMS.......: " , oF12N) //"INCOTERMS.......: "
oPrint:Say(Linha, 630, ALLTRIM(SW2->W2_INCOTERMS)+" "+ALLTRIM(SW2->W2_COMPL_I), oF12 )
Linha := Linha+50

pTipo := 1
PO150B()

oPrint:Say(Linha, 100, LITERAL_VIA_TRANSPORTE , oF12n )
oPrint:Say(Linha, 630, SYQ->YQ_DESCR          , oF12 )
Linha := Linha+50

pTipo := 1
PO150B()

oPrint:Say(Linha, 100, LITERAL_DESTINO , oF12n )
oPrint:Say(Linha, 630, cDestinat       , oF12 )
Linha := Linha+50

pTipo := 1
PO150B()

oPrint:Say(Linha, 100, LITERAL_AGENTE, oF12n )
oPrint:Say(Linha, 630, SY4->Y4_NOME  , oF12 )
Linha := Linha+50

cItens()

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �direita   �Autor  �Leandro Duarte      � Data �  06/03/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina para alinhamento a diretia                           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � p11                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static function direita(cString,nPos)
Local n1 := len(cString)*17
Local nRet := nPos - n1
Return(nRet)
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �direita   �Autor  �Leandro Duarte      � Data �  06/03/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina para alinhamento a diretia                           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � p11                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static function centrali(cString,nPos)
Local n1 := len(cString)*7
Local nRet := nPos - n1
Return(nRet)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �IMCD150   �Autor  �Microsiga           � Data �  06/03/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static FUNCTION PO150B()
xLinha := nil

If pTipo == 1      .OR.  pTipo == 2  .OR. pTipo == 7 .OR. pTipo == 9
	xLinha := 100
ElseIf pTipo == 3  .OR.  pTipo == 4
	xLinha := 20
ElseIf pTipo == 5  .OR.  pTipo == 6 .Or. pTipo == 8
	xLinha := 50
Endif


DO CASE
	
	CASE pTipo == 1  .OR.  pTipo == 3
		oPrint:Box( Linha,  50, (Linha+xLinha),  50)
		oPrint:Box( Linha,2300, (Linha+xLinha),2300)
		
	CASE pTipo == 2  .OR.  pTipo == 4  .OR.  pTipo == 5
		oPrint:Box( Linha,  50, (Linha+xLinha),  50)
		oPrint:Box( Linha, 120, (Linha+xLinha), 120)
		oPrint:Box( Linha, 460, (Linha+xLinha), 460)  
		oPrint:Box( Linha,1400, (Linha+xLinha),1400)  //1430
		oPrint:Box( Linha,1650, (Linha+xLinha),1650)  //1700
		oPrint:Box( Linha,1920, (Linha+xLinha),1920)
		oPrint:Box( Linha,2100, (Linha+xLinha),2100)
		oPrint:Box( Linha,2300, (Linha+xLinha),2300)
		
	CASE pTipo == 6  .OR.  pTipo == 7
		oPrint:Box( Linha,  50, (Linha+xLinha),  50)
		oPrint:Box( Linha,1510, (Linha+xLinha),1510) //DFS - 28/02/11 - Posicionamento das linhas
		oPrint:Box( Linha,2300, (Linha+xLinha),2300)
		
	Case pTipo == 8
		oPrint:Box( Linha,  50, (Linha+xLinha),  50)
		oPrint:Box( Linha,2300, (Linha+xLinha),2300)
	CASE pTipo == 9
		oPrint:Box( Linha,  50, (Linha+xLinha),  50)
		//        oPrint:Box( Linha,1510, (Linha+xLinha),1511) //DFS - 28/02/11 - Posicionamento das linhas
		oPrint:Box( Linha,2300, (Linha+xLinha),2300)
ENDCASE

RETURN NIL

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �IMCD150   �Autor  �Microsiga           � Data �  06/05/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static FUNCTION cItens(lImp)

Default lImp := .T.
If !lImp
	Return Nil
EndIf

Linha := Linha+20
pTipo := 4
PO150B()

oPrint:Line (Linha , 050, Linha , 2300) // linha

pTipo := 2
PO150B()

Linha := Linha+20

pTipo := 4
PO150B()

oPrint:Say(Linha,   065, "IT"                , oF10n ) //"IT"
oPrint:Say(Linha,   200, LITERAL_QUANTIDADE     , oF10n )
oPrint:Say(Linha,   470, LITERAL_DESCRICAO      , oF10n )
oPrint:Say(Linha,  1460, LITERAL_PRECO_UNITARIO1, oF10n )
oPrint:Say(Linha,  1730, LITERAL_TOTAL_MOEDA    , oF10n )
oPrint:Say(Linha,  1930, LITERAL_DATA_PREVISTA1 , oF10n )
oPrint:Say(Linha,  2130, LITERAL_DATA_PREVISTA3 , oF10n )
Linha := Linha+50

pTipo := 5
PO150B()

oPrint:Say(Linha,    65, "Nb"                , oF10n ) //"Nb"
oPrint:Say(Linha,  1460, LITERAL_PRECO_UNITARIO2, oF10n )
oPrint:Say(Linha,  1730, SW2->W2_MOEDA          , oF10n )
oPrint:Say(Linha,  1930, LITERAL_DATA_PREVISTA2 , oF10n )
oPrint:Say(Linha,  2130, LITERAL_DATA_PREVISTA2 , oF10n )

Linha := Linha+50

oPrint:Line (Linha , 050, Linha , 2300) // linha

RETURN NIL

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �IMCD150   �Autor  �Microsiga           � Data �  06/05/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static FUNCTION SItem()
Local i
Private cNomeFantasia := ""
cPointS :="EICPOOLI"
i := n1 := n2 := nil
nNumero := 1
bAcumula := bWhile := lPulaLinha := nil
nTam := 25
cDescrItem := ""

//-----------> Unidade Requisitante (C.Custo).
SY3->( DBSETORDER( 1 ) )
SY3->( DBSEEK( xFilial()+SW3->W3_CC ) )

//-----------> Fornecedores.
SA2->( DBSETORDER( 1 ) )
SA2->( DBSEEK( xFilial()+SW3->W3_FABR+EICRetLoja("SW3","W3_FABLOJ") ) )

//-----------> Reg. Ministerio.
SYG->( DBSETORDER( 1 ) )
SYG->( DBSEEK( xFilial()+SW2->W2_IMPORT+SW3->W3_FABR+EICRetLoja("SW3","W3_FABLOJ")+SW3->W3_COD_I ) )

//-----------> Produtos (Itens) e Textos.
SB1->( DBSETORDER( 1 ) )
SB1->( DBSEEK( xFilial()+SW3->W3_COD_I ) )


If ExistBlock(cPointS)
	ExecBlock(cPointS,.f.,.f.)
Endif

cDescrItem := MSMM(IF( nIdioma==INGLES, SB1->B1_DESC_I, SB1->B1_DESC_P ),36)
STRTRAN(cDescrItem,CHR(13)+CHR(10), " ")

IIF(lPoint1P,ExecBlock(cPoint1P,.F.,.F.,"2"),)

//-----------> Produtos X Fornecedor.
SA5->( DBSETORDER( 3 ) )
EICSFabFor(xFilial("SA5")+SW3->W3_COD_I+SW3->W3_FABR+SW3->W3_FORN, EICRetLoja("SW3", "W3_FABLOJ"), EICRetLoja("SW3", "W3_FORLOJ"))

pTipo := 5
PO150B()

Linha := Linha + 50
pTipo := 5
PO150B()

nCont:=nCont+1
oPrint:Say(Linha,  65, STRZERO(nCont,3),oF08n )
oPrint:Say(Linha, 370, TRANS(SW3->W3_QTDE,E_TrocaVP(nIdioma,cPictQtde)),oF08n,,,,1 )
oPrint:Say(Linha, 400, BUSCA_UM(SW3->W3_COD_I+SW3->W3_FABR +SW3->W3_FORN,SW3->W3_CC+SW3->W3_SI_NUM,IF(EICLOJA(),SW3->W3_FABLOJ,""),IF(EICLOJA(),SW3->W3_FORLOJ,"")),   oF08n )

IF MLCOUNT(cDescrItem,nTam) == 1 .OR. lPoint1P
	oPrint:Say(Linha, 480, MEMOLINE( cDescrItem,nTam ,1 ),oF08n )
ELSE
	oPrint:Say(Linha, 480, MEMOLINE( cDescrItem,nTam ,1 ),oF08n )
ENDIF
cNomeFantasia := (SA2->A2_NREDUZ)

oPrint:Say(Linha, 1560, TRANS(SW3->W3_PRECO,E_TrocaVP(nIdioma,'@E 999,999,999.99999')),oF08n,,,,1 )
oPrint:Say(Linha, 1860, TRANS(SW3->W3_QTDE*SW3->W3_PRECO,E_TrocaVP(nIdioma,cPict1Total )),oF08n,,,,1 )
oPrint:Say(Linha, 1940, DATA_MES(SW3->W3_DT_EMB),oF08n )
oPrint:Say(Linha, 2130, DATA_MES(SW3->W3_DT_ENTR),oF08n )

nTotal := DI500TRANS(nTotal + SW3->W3_QTDE*SW3->W3_PRECO,2)
Linha  := Linha + 50

n1 := ( MlCount( cDescrItem, nTam ) + 1 + 2 + 1 ) - 1
n2 := 0
n1 := IF( n1 > n2, n1, n2 )

FOR i:=2 TO n1 + 1
	
	lPulaLinha := .F.
	
	If Linha >= 3201
		Linha := 10
		oPrint:EndPage()
		oPrint:StartPage()
		oPrint:SayBitmap(Linha, 0200, 'logoIMCD.bmp', 2100, 0100)
		pTipo := 1
		//imprimi o relatorio
		IMCD15A()
		oPrint:SayBitmap(3300, 1800, 'logoIMCD1.bmp', 0450, 0075)
		
		pTipo := 5
		PO150B()
		
		Linha := Linha+50
	ENDIF
	
	IF !EMPTY( MEMOLINE( cDescrItem,nTam, i ) )
		IF MLCOUNT(cDescrItem,nTam) == i .OR. lPoint1P
			oPrint:Say(Linha,  480,MEMOLINE( cDescrItem,nTam,i ), oF08n )
		ELSE
			oPrint:Say(Linha,  480,MEMOLINE( cDescrItem,nTam,i  ), oF08n )
		ENDIF
		lPulaLinha := .T.
	ENDIF
	
	IF EMPTY( MEMOLINE( cDescrItem,nTam, i ) )
		IF nNumero == 1
			If SW3->(FieldPos("W3_PART_N")) # 0 .And. !Empty(SW3->W3_PART_N)
				oPrint:Say(Linha,  480 , SW3->W3_PART_N,  oF08n )
				lPulaLinha := .T.
			Else
				If !Empty( SA5->A5_CODPRF )
					oPrint:Say(Linha,  480 , SA5->A5_CODPRF,  oF08n )
					lPulaLinha := .T.
				Endif
			EndIf
			nNumero := nNumero+1
			
		ELSEIF nNumero == 2
			If !Empty( MEMOLINE(SA5->A5_PARTOPC,24,1) )
				oPrint:Say(Linha, 480 , MEMOLINE(SA5->A5_PARTOPC,24,1),  oF08n )
				lPulaLinha := .T.
			Endif
			nNumero := nNumero+1
			
		ELSEIF nNumero == 3
			If !Empty( MEMOLINE(SA5->A5_PARTOPC,24,2) )
				oPrint:Say(Linha, 480 , MEMOLINE(SA5->A5_PARTOPC,24,2),  oF08n )
				lPulaLinha := .T.
			Endif
			nNumero := nNumero+1
			
		ELSEIF nNumero == 4
			If !Empty( SYG->YG_REG_MIN )
				oPrint:Say(Linha, 480 , SYG->YG_REG_MIN,  oF08n )
				lPulaLinha := .T.
			Endif
			nNumero := nNumero+1
			
		ENDIF
	ENDIF
	
	pTipo := 5
	PO150B()
	
	If lPulaLinha
		Linha := Linha+50
	Endif
	
NEXT
oPrint:Say(Linha, 480, 'NCM:'+SB1->B1_POSIPI,oF08n )
Linha := Linha+50
oPrint:Line (Linha+50 , 050, Linha+50 , 2300) // linha
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �IMCD150   �Autor  �Microsiga           � Data �  06/10/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


Static FUNCTION IMCD150T()
Local nTLinha := 0

//pTipo := 5
//PO150B()
//Linha := Linha+50

If Linha >= 2560
	Linha := 10
	oPrint:EndPage()
	oPrint:StartPage()
	oPrint:SayBitmap(Linha, 0200, 'logoIMCD.bmp', 2100, 0100)
	pTipo := 1
	//imprimi o relatorio
	IMCD15A(.T.)
	oPrint:SayBitmap(3300, 1800, 'logoIMCD1.bmp', 0450, 0075)
	pTipo := 6
	PO150B()
	Linha := Linha+50
Else
	pTipo := 6
	PO150B()
	oPrint:Line (Linha , 050, Linha , 2300) // linha
	Linha := Linha+50
Endif

pTipo := 6
PO150B()

oPrint:Say(Linha, 1570, "TOTAL ", oF08n )
nTLinha := Linha
oPrint:Say(Linha, 2100, TRANS(nTotal,E_TrocaVP(nIdioma,cPict2Total))  , oF08n,,,,1 )

Linha := Linha+50

If Linha >= 3400
	Linha := 10
	oPrint:EndPage()
	oPrint:StartPage()
	oPrint:SayBitmap(Linha, 0200, 'logoIMCD.bmp', 2100, 0100)
	pTipo := 1
	//imprimi o relatorio
	IMCD15A(.T.)
	oPrint:SayBitmap(3300, 1800, 'logoIMCD1.bmp', 0450, 0075)
	
	pTipo := 6
	PO150B()
	Linha := Linha+50
else
	pTipo := 6
	PO150B()
	oPrint:Line (Linha , 050, Linha , 2300) // linha REDUZIDO
	Linha := Linha+50
Endif


pTipo := 6
PO150B()

oPrint:Say(Linha, 1570 , LITERAL_INLAND_CHARGES , oF08n )
oPrint:Say(Linha, 2100 , TRANS(SW2->W2_INLAND,E_TrocaVP(nIdioma,'@E 999,999,999,999.99')), oF08n,,,,1 )
Linha := Linha + 50

If Linha >= 3400
	Linha := 10
	oPrint:EndPage()
	oPrint:StartPage()
	oPrint:SayBitmap(Linha, 0200, 'logoIMCD.bmp', 2100, 0100)
	pTipo := 1
	//imprimi o relatorio
	IMCD15A(.T.)
	oPrint:SayBitmap(3300, 1800, 'logoIMCD1.bmp', 0450, 0075)
	
	
	pTipo := 6
	PO150B()
	Linha := Linha+50
	
else
	
	pTipo := 6
	PO150B()
	oPrint:Line (Linha , 050, Linha , 2300) // linha REDUZIDO
	Linha := Linha+50
Endif

pTipo := 6
PO150B()

oPrint:Say(Linha, 1570 , LITERAL_PACKING_CHARGES , oF08n )
oPrint:Say(Linha, 2100 , TRANS(SW2->W2_PACKING,E_TrocaVP(nIdioma,'@E 999,999,999,999.99')), oF08n,,,,1 )
Linha := Linha+50

If Linha >= 3400
	Linha := 10
	oPrint:EndPage()
	oPrint:StartPage()
	oPrint:SayBitmap(Linha, 0200, 'logoIMCD.bmp', 2100, 0100)
	pTipo := 1
	//imprimi o relatorio
	IMCD15A(.T.)
	oPrint:SayBitmap(3300, 1800, 'logoIMCD1.bmp', 0450, 0075)
	pTipo := 6
	PO150B()
	Linha := Linha+50
else
	
	pTipo := 6
	PO150B()
	oPrint:Line (Linha , 050, Linha , 2300) // linha REDUZIDO
	Linha := Linha+50
Endif

pTipo := 6
PO150B()

oPrint:Say(Linha, 1570 , LITERAL_INTL_FREIGHT , oF08n )
oPrint:Say(Linha, 2100 , TRANS(SW2->W2_FRETEINT,E_TrocaVP(nIdioma,'@E 999,999,999,999.99')), oF08n,,,,1 )
Linha := Linha+50

If Linha >= 3400
	Linha := 10
	oPrint:EndPage()
	oPrint:StartPage()
	oPrint:SayBitmap(Linha, 0200, 'logoIMCD.bmp', 2100, 0100)
	pTipo := 1
	//imprimi o relatorio
	IMCD15A(.T.)
	oPrint:SayBitmap(3300, 1800, 'logoIMCD1.bmp', 0450, 0075)
	pTipo := 6
	PO150B()
	Linha := Linha+50
else
	pTipo := 6
	PO150B()
	oPrint:Line (Linha , 050, Linha , 2300) // linha REDUZIDO
	Linha := Linha+50
Endif

pTipo := 6
PO150B()
oPrint:Say(Linha, 1570 , LITERAL_DISCOUNT , oF08n )
oPrint:Say(Linha, 2100 , TRANS(SW2->W2_DESCONT,E_TrocaVP(nIdioma,'@E 999,999,999,999.99')), oF08n,,,,1 )
Linha := Linha+50

If Linha >=3430
	Linha := 10
	oPrint:EndPage()
	oPrint:StartPage()
	oPrint:SayBitmap(Linha, 0200, 'logoIMCD.bmp', 2100, 0100)
	pTipo := 1
	//imprimi o relatorio
	IMCD15A(.T.)
	oPrint:SayBitmap(3300, 1800, 'logoIMCD1.bmp', 0450, 0075)
	pTipo := 6
	PO150B()
	Linha := Linha+50
Else
	pTipo := 6
	PO150B()
	oPrint:Line (Linha , 050, Linha , 2300) // linha REDUZIDO
	Linha := Linha+50
Endif


pTipo := 6
PO150B(20)
oPrint:Say(Linha, 1570 , LITERAL_OTHER_EXPEN , oF08n )
oPrint:Say(Linha, 2100 , TRANS(SW2->W2_OUT_DES,E_TrocaVP(nIdioma,'@E 999,999,999,999.99')), oF08n,,,,1 )
Linha := Linha+50

If Linha >=3430
	Linha := 10
	oPrint:EndPage()
	oPrint:StartPage()
	oPrint:SayBitmap(Linha, 0200, 'logoIMCD.bmp', 2100, 0100)
	pTipo := 1
	//imprimi o relatorio
	IMCD15A(.T.)
	oPrint:SayBitmap(3300, 1800, 'logoIMCD1.bmp', 0450, 0075)
	pTipo := 6
	PO150B()
	Linha := Linha+50
Else
	pTipo := 6
	PO150B()
	oPrint:Line (Linha , 050, Linha , 2300) // linha TRACO_REDUZIDO
	Linha := Linha+50
Endif

If SW2->W2_FREINC == "1"  // GFP - 06/03/2014
	nTotalGeral := DI500TRANS((nTotal+SW2->W2_OUT_DES)-SW2->W2_DESCONT,2)
Else
	nTotalGeral := DI500TRANS((nTotal+SW2->W2_INLAND+SW2->W2_PACKING+SW2->W2_FRETEINT+SW2->W2_OUT_DES)-SW2->W2_DESCONT,2)
EndIf
nTotal := 0
pTipo := 6
PO150B()


oPrint:Say(Linha, 1570 , "TOTAL " + ALLTRIM( SW2->W2_INCOTER )         , oF08n ) //"TOTAL "
oPrint:Say(Linha, 1780 , SW2->W2_MOEDA,oF08n )
oPrint:Say(Linha, 2100 , TRANS(nTotalGeral,E_TrocaVP(nIdioma,cPict2Total)), oF08n,,,,1 )
Linha := Linha+50
oPrint:Say(Linha, 065 , ALLTRIM( SY1->Y1_NOME    )         , oF08n ) //"COMPRADOR "
oPrint:Line (Linha , 050, Linha , 2300) // linha
Linha := Linha+200

Linha := nTLinha

RETURN NIL

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �IMCD150   �Autor  �Microsiga           � Data �  06/10/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static FUNCTION IMCD150R()
Local i
i := bWhile := bAcumula := nil
cRemarks:=""

cRemarks := MSMM(SW2->W2_OBS,60)
STRTRAN(cRemarks,CHR(13)+CHR(10), " ")

oPrint:Say(Linha,  065, LITERAL_OBSERVACOES, oF08nu )
Linha := Linha+50
nTamLinha := 110
//SVG - 15/09/2011 - Ajuste no campo observa��o n�o deve ter limite de impress�o.
nTamanhoLn := 82
nLinRemark := 1
While !Empty(cRemarks)
	If (nPos := At(CHR(13)+CHR(10), cRemarks)) > 0
		cLinha := SubStr(cRemarks, 1, nPos - 1)
		if nPos > nTamanhoLn
			cLinha := SubStr(cRemarks, 1, nTamanhoLn)
			//Imprime
			oPrint:Say(Linha,  065 , cLinha,  oF08n )
			cRemarks := SubStr(cRemarks,nTamanhoLn)
		Else
			oPrint:Say(Linha,  065 , cLinha,  oF08n )
			cRemarks := SubStr(cRemarks, nPos + 2)
		EndIf
	Else
		If Len(cRemarks) < nTamanhoLn
			nTamanhoLn := Len(cRemarks)
		EndIf
		cLinha := SubStr(cRemarks, 1, nTamanhoLn)
		//Imprime
		oPrint:Say(Linha,  065 , cLinha,  oF08n )
		cRemarks := SubStr(cRemarks, nTamanhoLn + 1)
	EndIf
	
	Linha := Linha+50
	
	If nLinRemark == 10
		nTamanhoLN := 165
	EndIf
	
	If nLinRemark == 10 .Or. Linha >= 3400
		oPrint:Line (Linha , 050, Linha , 2300)
		Linha := 10
		oPrint:EndPage()
		oPrint:StartPage()
		oPrint:SayBitmap(Linha, 0200, 'logoIMCD.bmp', 2100, 0100)
		pTipo := 1
		//imprimi o relatorio
		IMCD15A(.T.)
		oPrint:SayBitmap(3300, 1800, 'logoIMCD1.bmp', 0450, 0075)
		oPrint:Line (Linha , 050, Linha , 2300)
		Linha := Linha
		pTipo := 8
		PO150B()
		Linha := Linha+50
		lMaisPag := .T.
	EndIf
	
	If nLinRemark >= 10
		Linha := Linha
		pTipo := 8
		PO150B()
	EndIf

	++nLinRemark
	
EndDo

RETURN NIL
