#include "rwmake.ch"
#include "protheus.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao	 � CISFT073	� Autor � Thiago Queiroz        � Data � 23/11/11 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Impressao do Boleto do Itau	                              ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 � Linciplas                                                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function CISFT073(cTitIni, cTitFim, cSerie)

SetPrvt("NDIGBOL,NDIGBAR,CALIAS")
SetPrvt("NFI,NFF,SERIE,_CLINHA,FATOR,ARQ,CGRUPO,PERG")
SetPrvt("I,NVAL,FILTIMP,ARETURN,AINFO,NLASTKEY,CSTRING")
SetPrvt("WNREL,NCONT,XI,_cCampo,NDIGITO,Nnumero")

//GRAVA O NOME DA FUNCAO NA Z03
//U_CFGRD001(FunName())

//��������������������������������������������������������������Ŀ
//� Definicao de Variaveis                                       �
//����������������������������������������������������������������

Private _nCont    := 1
Private cPerg
Private _aTitulos := {}
Private _nDigbar  := "1"
Private _cNum     := ""
Private _cFiltro  := ""

// _aTitulos => array que contem as informacoes
// que serao impressas no boleto
// [n,01] = Prefixo+Numero+Parcela do Titulo
// [n,02] = Vencimento
// [n,03] = Valor do Titulo
// [n,04] = Nosso Numero
// [n,05] = Agencia
// [n,06] = Codigo do Cedente
// [n,07] = Carteira
// [n,08] = Nome do CLiente
// [n,09] = Emissao do titulo
// [n,10] = Endereco do Cliente
// [n,11] = Cidade do Cliente
// [n,12] = Estado do Cliente
// [n,13] = CEP do Cliente
// [n,14] = CNPJ do Cliente
// [n,15] = Data do Processamento
// [n,16] = Conta do Cedente

cPerg := "CSFT07"

//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01             // Da Nota                              �
//� mv_par02             // Ate a Nota                           �
//� mv_par03             // Serie                                �
//����������������������������������������������������������������

//ValidPerg()

// Retira filtro
dbSelectArea("SE1")
_cFiltro := DbFilter()
Set Filter to

// Inicializa array de titulos

//If Valtype(_cNumBorde) == "U" .or. Len(_cNumBorde) == 0
_nCont    := 1
//If Pergunte(cPerg,.T.)
DbSelectArea("SE1")
DbSetOrder(1)
DbSeek(xFilial("SE1")+cSerie+cTitIni)
While !Eof() .and. SE1->E1_NUM >= cTitIni .and. SE1->E1_NUM <= cTitFim .and. ;
	SE1->E1_PREFIXO == cSerie
	
	// VERIFICA SE O TITULO/NF FOI FATURADO DEPOIS DO DIA 15/02/10, CASO N�O TENHA SIDO UTILIZA O PROGRAMA COM A CONTA ANTIGA
	//IF SE1->E1_BOLBRAD != "1" .AND. (!EMPTY(SE1->E1_DATABOR) .OR. DTOS(SE1->E1_DATABOR) < "20110215")
	//	U_CISFT07()
	//	RETURN
	//ELSEIF SE1->E1_BOLBRAD == "1" .AND. (EMPTY(SE1->E1_DATABOR) .OR. DTOS(SE1->E1_DATABOR) > "20110215")
	
	
	//If SE1->E1_PORTAD2 $ "341"
	/* ABRE
	.and. SE1->E1_NUMBCO <> "" .and. ;
	SE1->E1_AGEDEP <> "" .and. SE1->E1_CONTA <> "" .and. ;
	SE1->E1_CONTA <> "" .AND. SE1->E1_TIPO="NF"
	FECHA */
	Aadd(_aTitulos,{"","",0,"","","","","","","","","","","","",""})
	_cNum := SE1->E1_PREFIXO+" "+SE1->E1_NUM+" "+SE1->E1_PARCELA
	_aTitulos[_nCont][01] := _cNum            													// Prexifo+Numero+Parcela do Titulo
	_aTitulos[_nCont][02] := SE1->E1_VENCTO 													// Vencimento
	_aTitulos[_nCont][03] := SE1->E1_VALOR//+SE1->E1_JUROS//U_FATRD006() 						// saldo
	_aTitulos[_nCont][04] := "00" + ALLTRIM(SE1->E1_NUMBCO)									// Nosso Numero
	_aTitulos[_nCont][05] := SE1->E1_AGEDEP 						   							// Agencia
	_aTitulos[_nCont][08] := StrZero(Day(SE1->E1_EMISSAO),2)+"/"+StrZero(Month(SE1->E1_EMISSAO),2)+"/"+StrZero(Year(SE1->E1_EMISSAO),4)
	_aTitulos[_nCont][16] := "075270    " // SE1->E1_CONTA // STRZERO(VAL(SE1->E1_CONTA),7) 	// Numero da Conta Corrente
	_aTitulos[_nCont][06] := "075270    " // SE1->E1_CONTA // Right(Alltrim(SEE->EE_CONTA),9)	//SEE->EE_CODEMP),9)	// Conta do Cedente
	_aTitulos[_nCont][07] := "109"								   								// Carteira de cobran;a
	
	// Obtem dados do cliente
	DbSelectArea("SA1")
	DbSetOrder(1)
	If DbSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA)
		_aTitulos[_nCont][09] := SA1->A1_NOME
		_aTitulos[_nCont][10] := SA1->A1_END
		_aTitulos[_nCont][11] := SA1->A1_MUN
		_aTitulos[_nCont][12] := SA1->A1_EST
		_aTitulos[_nCont][13] := SA1->A1_CEP
		_aTitulos[_nCont][14] := SA1->A1_CGC
		_aTitulos[_nCont][15] := StrZero(Day(dDatabase),2)+"/"+StrZero(Month(dDatabase),2)+"/"+StrZero(Year(dDatabase),4)
	Endif
	_nCont += 1
	//Endif
	DbSelectArea("SE1")
	DbSkip()
	//ENDIF // -> ENDIF DO IF QUE BLOQUEIA A IMPRESS�O DO BOLETO CASO N�O ESTEJA COM E1_PORTADO == "341" (ITAU)
EndDO
//EndIf
//Endif

//��������������������������������������������������������������Ŀ
//� Inicializacao de Variaveis                                   �
//����������������������������������������������������������������

Private _cBarra  := SPACE(44)
Private _nPosHor := 0
Private _nLinha  := 0
Private _nEspLin := 0
Private _nTxtBox := 0
Private _nPosVer := 0


nDigbol    := SPACE(1)
nDigbar    := SPACE(1)
NFi        := Space(6)
NFf        := Space(6)
Serie      := Space(3)
Nnumero    := Space(11)
_cLinha    := ""
Fator      := CTOD("07/10/1997")

//��������������������������������������������������������������Ŀ
//� Tela de Entrada de Dados                                     �
//����������������������������������������������������������������

FiltImp    := ""
aInfo      := {}
nHeight    := 15
lBold      := .F.
lUnderLine := .F.
lPixel     := .T.
lPrint     := .F.
//                              Font              W  H  Bold  - Italic - Underline - Device
//oFont1 := oSend(TFont(),"New","Arial"          ,0,14,,.F.,,,,.F.,.F.,,,,,,oPrn)

oFont06  := TFont():New( "Arial",,06,,.F.,,,,,.F. )
oFont06B := TFont():New( "Arial",,06,,.T.,,,,,.F. )
oFont07  := TFont():New( "Arial",,07,,.F.,,,,,.F. )
oFont07B := TFont():New( "Arial",,07,,.T.,,,,,.F. )
oFont08  := TFont():New( "Arial",,08,,.F.,,,,,.F. )
oFont08B := TFont():New( "Arial",,08,,.T.,,,,,.F. )
oFont09  := TFont():New( "Arial",,09,,.F.,,,,,.F. )
oFont09B := TFont():New( "Arial",,09,,.T.,,,,,.F. )
oFont10  := TFont():New( "Arial",,10,,.F.,,,,,.F. )
oFont10B := TFont():New( "Arial",,10,,.T.,,,,,.F. )
oFont11  := TFont():New( "Arial",,11,,.F.,,,,,.F. )
oFont11B := TFont():New( "Arial",,11,,.T.,,,,,.F. )
oFont12  := TFont():New( "Arial",,12,,.F.,,,,,.F. )
oFont12B := TFont():New( "Arial",,12,,.T.,,,,,.F. )
oFont13  := TFont():New( "Arial",,13,,.F.,,,,,.F. )
oFont13B := TFont():New( "Arial",,13,,.T.,,,,,.F. )
oFont14  := TFont():New( "Arial",,14,,.F.,,,,,.F. )
oFont14B := TFont():New( "Arial",,14,,.T.,,,,,.F. )
oFont15  := TFont():New( "Arial",,15,,.F.,,,,,.F. )
oFont15B := TFont():New( "Arial",,15,,.T.,,,,,.F. )
oFont16  := TFont():New( "Arial",,16,,.F.,,,,,.F. )
oFont16B := TFont():New( "Arial",,16,,.T.,,,,,.F. )
oFont17  := TFont():New( "Arial",,17,,.F.,,,,,.F. )
oFont17B := TFont():New( "Arial",,17,,.T.,,,,,.F. )
oFont18  := TFont():New( "Arial",,18,,.F.,,,,,.F. )
oFont18B := TFont():New( "Arial",,18,,.T.,,,,,.F. )
oFont19  := TFont():New( "Arial",,19,,.F.,,,,,.F. )
oFont19B := TFont():New( "Arial",,19,,.T.,,,,,.F. )
oFont20  := TFont():New( "Arial",,20,,.F.,,,,,.F. )
oFont20B := TFont():New( "Arial",,20,,.T.,,,,,.F. )
oFont21  := TFont():New( "Arial",,21,,.F.,,,,,.F. )
oFont21B := TFont():New( "Arial",,21,,.T.,,,,,.F. )
oFont22  := TFont():New( "Arial",,22,,.F.,,,,,.F. )
oFont22B := TFont():New( "Arial",,22,,.T.,,,,,.F. )
oFont23  := TFont():New( "Arial",,23,,.F.,,,,,.F. )
oFont23B := TFont():New( "Arial",,23,,.T.,,,,,.F. )
oFont24  := TFont():New( "Arial",,24,,.F.,,,,,.F. )
oFont24B := TFont():New( "Arial",,24,,.T.,,,,,.F. )
oFont25  := TFont():New( "Arial",,25,,.F.,,,,,.F. )
oFont25B := TFont():New( "Arial",,25,,.T.,,,,,.F. )
oFont26  := TFont():New( "Arial",,26,,.F.,,,,,.F. )
oFont26B := TFont():New( "Arial",,26,,.T.,,,,,.F. )
oFont27  := TFont():New( "Arial",,27,,.F.,,,,,.F. )
oFont27B := TFont():New( "Arial",,27,,.T.,,,,,.F. )
oFont28  := TFont():New( "Arial",,28,,.F.,,,,,.F. )
oFont28B := TFont():New( "Arial",,28,,.T.,,,,,.F. )
oFont29  := TFont():New( "Arial",,29,,.F.,,,,,.F. )
oFont29B := TFont():New( "Arial",,29,,.T.,,,,,.F. )
oFont30  := TFont():New( "Arial",,30,,.F.,,,,,.F. )
oFont30B := TFont():New( "Arial",,30,,.T.,,,,,.F. )

oprn     := TMSPrinter():New()

oprn:setup()

npag  :=1
serie := ""
nfi   := ""
nff   := ""

For _nCont := 1 to len(_aTitulos)
	// Posicionamento Horizontal
	_nPosHor := 01
	_nLinha  := 01
	_nEspLin := 84
	
	// Posicionamento Vertical
	_nPosVer := 10
	
	// Posicionamento do Texto Dentro do Box
	_nTxtBox := 05
	
	//	oPRINTER(SETPAPERSIZE(9))	// <==== ajuste para papel A4
	oprn:SETPAPERSIZE(9) 			// <==== ajuste para papel A4
	
	oprn:StartPage()
	
	CISFT073A()
	oprn:EndPage()
	npag:= npag + 1
	
Next _nCont
//oprn:setup()
oprn:Preview()
//oPrn:Print() // descomentar esta linha para imprimir

ms_flush()


// Restaura filtro
DbSelectArea("SE1")
Set Filter To &_cFiltro

Return (.T.)


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao	 � CISFT073A� Autor � Thiago Queiroz       	� Data � 05/05/03 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Impressao do Boleto                                        ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 � CIS Eletronica                                             ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function CISFT073A()

Local cPath		:= GetSrvProfString("Startpath","")

// Monta codigo de barras do titulo
CISFT073B()
// Monta Linha digitavel
CISFT073D()

//oprn:StartPage()
// Recibo do Sacado
// Box Cedente

DBSELECTAREA("SM0")

oprn:say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+25,_nTxtBox+0130,"Banco Ita� SA",ofont14B,100)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin),_nTxtBox+0480,"|341-7|",ofont22B,100)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+10,_nPosVer+1650,"Comprovante de Entrega",ofont14B,100)
_nLinha  := _nLinha + 1

// Box de alguma coisa
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer,_nPosHor+(_nLinha*_nEspLin),_nPosVer+0830)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+0010,"Cedente",ofont08,100)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin+30)+_nTxtBox,_nPosVer+0010,ALLTRIM(SM0->M0_NOMECOM),ofont08,100)

// Box Agencia/Codigo Cedente
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+0830,_nPosHor+(_nLinha*_nEspLin),_nPosVer+1180)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+0840,"Ag�ncia/C�digo Cedente",ofont08,100)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin+30)+_nTxtBox,_nPosVer+0850,transform(_aTitulos[_nCont][05],"@R 9999")+"/"+transform(_aTitulos[_nCont][06],"@R 99999-9"),ofont08B,100)

// Box Motivos nao entrega
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+1180,_nPosHor+(_nLinha*_nEspLin)+(2*_nEspLin),_nPosVer+2230)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+1290,"Motivos de n�o entrega(para uso da empresa entregadora)",ofont08,100)

oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin+0050)+_nTxtBox,_nPosVer+1210,"( )Mudou-se",ofont08,100)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin+0050)+_nTxtBox,_nPosVer+1490,"( )Ausente",ofont08,100)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin+0050)+_nTxtBox,_nPosVer+1820,"( )N�o existe n. indicado",ofont08,100)

oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin+0100)+_nTxtBox+0025,_nPosVer+1210,"( )Recusado",ofont08,100)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin+0100)+_nTxtBox+0025,_nPosVer+1490,"( )N�o Procurado",ofont08,100)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin+0100)+_nTxtBox+0025,_nPosVer+1820,"( )Falecido",ofont08,100)

oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin+0150)+_nTxtBox+0050,_nPosVer+1210,"( )Desconhecido",ofont08,100)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin+0150)+_nTxtBox+0050,_nPosVer+1490,"( )Endere�o Insuficiente",ofont08,100)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin+0150)+_nTxtBox+0050,_nPosVer+1820,"( )Outros (anotar no verso)",ofont08,100)

// Box Sacado
_nLinha  += 1
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer,_nPosHor+(_nLinha*_nEspLin),_nPosVer+0830)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+0010,"Sacado",ofont08,100)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+30,_nPosVer+0010,_aTitulos[_nCont][09],ofont08,100)

// Box Nosso Numero
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+0830,_nPosHor+(_nLinha*_nEspLin),_nPosVer+1180)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+0840,"Nosso N�mero",ofont08,100)
//oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+30,_nPosVer+0860,_aTitulos[_nCont][07]+"/"+transform(_aTitulos[_nCont][04],"@R 99999999999-999999"),ofont08B,100)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+30,_nPosVer+0860,_aTitulos[_nCont][07]+"/"+SUBSTR(_aTitulos[_nCont][04],4,8)+"-"+SUBSTR(_aTitulos[_nCont][04],12,1),ofont08B,100)

// Box Vencimento
_nLinha  += 1
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer,_nPosHor+(_nLinha*_nEspLin),_nPosVer+0200)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+0010,"Vencimento",ofont08,100)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+30,_nPosVer+0030,StrZero(Day(_aTitulos[_nCont][02]),2)+"/"+StrZero(Month(_aTitulos[_nCont][02]),2)+"/"+StrZero(Year(_aTitulos[_nCont][02]),4),ofont08B,100)

// Box Numero do Documento
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+0200,_nPosHor+(_nLinha*_nEspLin),_nPosVer+0520)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+0210,"N. do Documento",ofont08,100)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+30,_nPosVer+0300,_aTitulos[_nCont][01],ofont08,100)

// Box Especie Moeda
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+0520,_nPosHor+(_nLinha*_nEspLin),_nPosVer+0830)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+0530,"Esp�cie Moeda",ofont08,100)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+30,_nPosVer+0650,"R$",ofont08,100)

// Box Valor do Documento
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+0830,_nPosHor+(_nLinha*_nEspLin),_nPosVer+1180)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+0840,"Valor do Documento",ofont08,100)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+30,_nPosVer+0940,transform(_aTitulos[_nCont][03],"@E 999,999,999.99"),ofont08B,100)

// Box Recebimento bloqueto
_nLinha  += 1
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer,_nPosHor+(_nLinha*_nEspLin),_nPosVer+0340)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+0010,"Recebi(emos) o bloqueto",ofont08,100)

// Box Data
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+0340,_nPosHor+(_nLinha*_nEspLin),_nPosVer+560)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+0350,"Data",ofont08,100)

// Box Assinatura
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+0560,_nPosHor+(_nLinha*_nEspLin),_nPosVer+1180)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+0570,"Assinatura",ofont08,100)

// Box Data
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+1180,_nPosHor+(_nLinha*_nEspLin),_nPosVer+1520)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+1190,"Data",ofont08,100)

// Box Entregador
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+1520,_nPosHor+(_nLinha*_nEspLin),_nPosVer+2230)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+1530,"Entregador",ofont08,100)

// Box Local de Pagamento
_nLinha  += 1
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer    ,_nPosHor+(_nLinha*_nEspLin),_nPosVer+1910)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox    ,_nPosVer+0010,"Local de Pagamento",ofont08,100)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox    ,_nPosVer+0275,"ATE O VENCIMENTO PAGUE PREFERENCIALMENTE NO ITAU OU BANERJ",ofont09B,150)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+33 ,_nPosVer+0275,"APOS O VENCIMENTO PAGUE SOMENTE NO ITAU OU BANERJ",ofont09B,150)


// Box Data de Processamento
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+1910,_nPosHor+(_nLinha*_nEspLin),_nPosVer+2230)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+1920,"Data de Processamento",ofont08,100)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+30,_nPosVer+1980,_aTitulos[_nCont][15],ofont08,100)

// Box Recibo do Sacado
_nLinha  += 1
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer		,_nPosHor+(_nLinha*_nEspLin),_nPosVer+2230)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+25	,_nTxtBox+0130,"Banco Ita� SA",ofont14B,100)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin),_nTxtBox+0480,"|341-7|",ofont22B,100)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+1720,"Recibo do Sacado",ofont14B,100)

// Box Local de Pagamento
_nLinha  += 1
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer    ,_nPosHor+(_nLinha*_nEspLin),_nPosVer+1650)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox    ,_nPosVer+0010,"Local de Pagamento",ofont08,100)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox    ,_nPosVer+0275,"ATE O VENCIMENTO PAGUE PREFERENCIALMENTE NO ITAU OU BANERJ",ofont09B,150)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+33 ,_nPosVer+0275,"APOS O VENCIMENTO PAGUE SOMENTE NO ITAU OU BANERJ",ofont09B,150)

// Box Logotipo
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+1650,_nPosHor+(_nLinha*_nEspLin)+4*_nEspLin,_nPosVer+2230)
oprn:say(_nPosHor+((_nLinha-1)*(_nEspLin-2)),_nPosVer+1695,"|          |",ofont14B,100)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+1725,"341-7",ofont12B,100)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+1870,"Recibo do Sacado",ofont10B,100)
//Logotipo da Empresa
oPrn:SayBitmap(_nPosHor+((_nLinha-1)*_nEspLin+30)+_nTxtBox,1700,cPath+"LOGO SPIDER_novo.jpg",500,280)

// Box Cedente
_nLinha  += 1
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer,_nPosHor+(_nLinha*_nEspLin),_nPosVer+1650)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+0010,"Cedente",ofont08,100)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin+30)+_nTxtBox,_nPosVer+0010,SM0->M0_NOMECOM,ofont08,100)

// Box Data do documento
_nLinha  += 1
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer,_nPosHor+(_nLinha*_nEspLin),_nPosVer+0420)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+0010,"Data do documento",ofont08,100)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+30,_nPosVer+0100,_aTitulos[_nCont][08],ofont08,100)

// Box Numero do Documento
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+0420,_nPosHor+(_nLinha*_nEspLin),_nPosVer+0790)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+0430,"N� do documento",ofont08,100)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+30,_nPosVer+0530,_aTitulos[_nCont][01],ofont08,100)

// Box Especie Doc
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+0790,_nPosHor+(_nLinha*_nEspLin),_nPosVer+1050)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+0800,"Esp�cie Doc",ofont08,100)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+30,_nPosVer+0900,"DP",ofont08,100)

// Box Aceite
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+1050,_nPosHor+(_nLinha*_nEspLin),_nPosVer+1170)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+1060,"Aceite",ofont08,100)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+30,_nPosVer+1080,"N�o",ofont08,100)

// Box Data do Processamento
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+1170,_nPosHor+(_nLinha*_nEspLin),_nPosVer+1650)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+1180,"Data do Processamento",ofont08,100)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+30,_nPosVer+1280,_aTitulos[_nCont][15],ofont08,100)

// Box Uso do Banco
_nLinha  += 1
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer,_nPosHor+(_nLinha*_nEspLin),_nPosVer+0300)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+0010,"Uso do Banco",ofont08,100)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+30,_nPosVer+0050,"08650",ofont08,100)

// Box Carteira
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin)	,_nPosVer+0300	,_nPosHor+(_nLinha*_nEspLin),_nPosVer+0552)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+0310,"Carteira",ofont08,100)
//oprn:say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+30,_nPosVer+0315,"000",ofont08,100)

// Box Carteira
//oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin)	,_nPosVer+0420	,_nPosHor+(_nLinha*_nEspLin),_nPosVer+0552)
//oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+0430,"Carteira",ofont08,100)
//oprn:say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+30,_nPosVer+0480,_aTitulos[_nCont][07],ofont08,100)

// Box Especie Moeda
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+0552,_nPosHor+(_nLinha*_nEspLin),_nPosVer+0790)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+0562,"Esp�cie moeda",ofont08,100)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+30,_nPosVer+0652,"R$",ofont08,100)

// Box Quantidade
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+0790,_nPosHor+(_nLinha*_nEspLin),_nPosVer+1170)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+0800,"Quantidade",ofont08,100)

// Box Valor
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+1170,_nPosHor+(_nLinha*_nEspLin),_nPosVer+1650)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+1180,"Valor",ofont08,100)

// Box Logotipo
//oprn:say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+1700,"Banco Ita� SA",ofont30B,100)

// Box Instrucoes
_nLinha  += 1
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer,_nPosHor+(_nLinha*_nEspLin)+9*_nEspLin,_nPosVer+1650)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+30,_nPosVer+1680,"",ofont10B,100)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+10,_nPosVer+0010,"Instru��es de responsabilidade do cedente.",ofont09B,100)

// Box Vencimento
_nLinha  += 1
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+1650,_nPosHor+(_nLinha*_nEspLin),_nPosVer+2230)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+1660,"Vencimento",ofont08,100)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+30,_nPosVer+2060,StrZero(Day(_aTitulos[_nCont][02]),2)+"/"+StrZero(Month(_aTitulos[_nCont][02]),2)+"/"+StrZero(Year(_aTitulos[_nCont][02]),4),ofont08B,100)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+0010,"*** Valores Expressos em R$ ***",ofont09B,100)

// Box Agencia/Codigo Cedente
_nLinha  += 1
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+1650,_nPosHor+(_nLinha*_nEspLin),_nPosVer+2230)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+1660,"Ag�ncia/C�digo Cedente",ofont08,100)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin+30)+_nTxtBox,_nPosVer+1940,transform(_aTitulos[_nCont][05],"@R 9999")+"/"+transform(_aTitulos[_nCont][06],"@R 99999-9"),ofont08B,100)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+0010,"APOS O VENCIMENTO, MULTA DE 2,00 %",ofont09B,100)

// Box Cart./nosso numero
_nLinha  += 1
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+1650,_nPosHor+(_nLinha*_nEspLin),_nPosVer+2230)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+1660,"Cart./nosso n�mero",ofont08,100)
//oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+30,_nPosVer+1960,_aTitulos[_nCont][07]+"/"+transform(_aTitulos[_nCont][04],"@R 99999999999-999999"),ofont08B,100)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+30,_nPosVer+1960,_aTitulos[_nCont][07]+"/"+SUBSTR(_aTitulos[_nCont][04],4,8)+"-"+SUBSTR(_aTitulos[_nCont][04],12,1),ofont08B,100)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+0010,"Apos o Vencimento Mora dia R$ "+transform(_aTitulos[_nCont][03]*0.003333,"@E 999,999,999.99"),ofont08,100)

// Box Valor do documento
_nLinha  += 1
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+1650,_nPosHor+(_nLinha*_nEspLin),_nPosVer+2230)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+1660,"1(=) Valor do documento",ofont08,100)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+30,_nPosVer+2000,transform(_aTitulos[_nCont][03],"@E 999,999,999.99"),ofont08B,100)

// Box Desconto / Abatimento
_nLinha  += 1
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+1650,_nPosHor+(_nLinha*_nEspLin),_nPosVer+2230)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+1660,"2(-) Desconto/abatimento",ofont08,100)
//oprn:say(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+0010,"-Pague este t�tulo nas Ag�ncias ITAU (ou atrav�s do Sistema Integrado de Compensa��o)",ofont09B,100)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+0010,"Evite constrangimentos! Efetue o pagamento deste boleto at� o vencimento",ofont09B,100)

// Box Outras deducoes
_nLinha  += 1
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+1650,_nPosHor+(_nLinha*_nEspLin),_nPosVer+2230)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+1660,"3(-) Outras dedu��es",ofont08,100)
//oprn:say(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+0010,"-Ap�s o 3o dia �til do venvimento, pag�vel somente na Ag�ncia Deposit�ria Oficial, se houver indica��o no",ofont09,100)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+0010,"Caso o pagamento n�o seja realizado, ser� enviado ao SERASA para cobran�a",ofont09B,100)

// Box Mora / Multa
_nLinha  += 1
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+1650,_nPosHor+(_nLinha*_nEspLin),_nPosVer+2230)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+1660,"4(+) Mora/Multa",ofont08,100)
//oprn:say(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+0010,"-'Local de Pagamento' desta papeleta e desde que n�o haja instru��es contr�rias do Cedente no espa�o acima",ofont09,100)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+0010,"Evite despesas adicionais com cobran�as judiciais.",ofont09B,100)

// Box Outros acrescimos
_nLinha  += 1
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+1650,_nPosHor+(_nLinha*_nEspLin),_nPosVer+2230)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+1660,"5(+) Outros Acr�scimos",ofont08,100)
// tinha uma mensagem aqui

// Box Valor cobrado
_nLinha  += 1
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+1650,_nPosHor+(_nLinha*_nEspLin),_nPosVer+2230)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+1660,"6(=) Valor cobrado",ofont08,100)

// Box Sacado
_nLinha  += 1
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer,_nPosHor+(_nLinha*_nEspLin)+_nEspLin,_nPosVer+2230)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+0010,"Sacado:",ofont08,100)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+0150,_aTitulos[_nCont][09],ofont08,100) 										// Nome Sacado
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+1400,Transform(_aTitulos[_nCont][14],"@R 99.999.999/9999-99"),ofont08,100) 	// CNPJ Sacado
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+0030,_nPosVer+0150,_aTitulos[_nCont][10],ofont08,100) 								// End. Sacado
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+0060,_nPosVer+0150,Transform(_aTitulos[_nCont][13],"@R 99999-999"),ofont08,100) 		// CEP Sacado
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+0060,_nPosVer+0550,_aTitulos[_nCont][11],ofont08,100) 								// Cidade Sacado
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+0060,_nPosVer+1000,_aTitulos[_nCont][12],ofont08,100) 								// Estado Sacado
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+0120,_nPosVer+0010,"Sacador/Avalista:",ofont08,100)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+0170,_nPosVer+1750,"Autentica��o Mec�nica",ofont08,100)


// Ficha de compensacao
_nLinha  += 4
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer,Replicate("-",160),ofont12,100)

// Linha Digitavel
_nLinha  += 1
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+25,_nTxtBox+0130,"Banco Ita� SA",ofont14B,100)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin),_nTxtBox+0480,"|341-7|",ofont22B,100)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+0010,_nTxtBox+0750,_clinha,oFont14,100)

// Box Local de Pagto
_nLinha  += 1
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer    ,_nPosHor+(_nLinha*_nEspLin),_nPosVer+1650)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox    ,_nPosVer+0010,"Local de Pagamento",ofont08,100)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox    ,_nPosVer+0275,"ATE O VENCIMENTO PAGUE PREFERENCIALMENTE NO ITAU OU BANERJ",ofont09B,150)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+33 ,_nPosVer+0275,"APOS O VENCIMENTO PAGUE SOMENTE NO ITAU OU BANERJ.",ofont09B,150)

// Box Vencimento
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+1650,_nPosHor+(_nLinha*_nEspLin),_nPosVer+2230)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+1660,"Vencimento",ofont08,100)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+30,_nPosVer+2060,StrZero(Day(_aTitulos[_nCont][02]),2)+"/"+StrZero(Month(_aTitulos[_nCont][02]),2)+"/"+StrZero(Year(_aTitulos[_nCont][02]),4),ofont08B,100)

// Box Cedente
_nLinha  += 1
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer,_nPosHor+(_nLinha*_nEspLin),_nPosVer+1650)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+0010,"Cedente",ofont08,100)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin+30)+_nTxtBox,_nPosVer+0010,SM0->M0_NOMECOM,ofont08,100)

// Box Agencia/Codigo Cedente
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+1650,_nPosHor+(_nLinha*_nEspLin),_nPosVer+2230)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+1660,"Ag�ncia/C�digo Cedente",ofont08,100)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin+30)+_nTxtBox,_nPosVer+1940,transform(_aTitulos[_nCont][05],"@R 9999")+"/"+transform(_aTitulos[_nCont][06],"@R 99999-9"),ofont08B,100)

// Box Data do documento
_nLinha  += 1
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer,_nPosHor+(_nLinha*_nEspLin),_nPosVer+0420)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+0010,"Data do documento",ofont08,100)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+30,_nPosVer+0100,_aTitulos[_nCont][08],ofont08,100)

// Box Numero do Documento
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+0420,_nPosHor+(_nLinha*_nEspLin),_nPosVer+0790)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+0430,"N� do documento",ofont08,100)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+30,_nPosVer+0530,_aTitulos[_nCont][01],ofont08,100)

// Box Especie Doc
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+0790,_nPosHor+(_nLinha*_nEspLin),_nPosVer+1050)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+0800,"Esp�cie Doc",ofont08,100)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+30,_nPosVer+0900,"DP",ofont08,100)

// Box Aceite
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+1050,_nPosHor+(_nLinha*_nEspLin),_nPosVer+1170)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+1060,"Aceite",ofont08,100)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+30,_nPosVer+1080,"N�o",ofont08,100)

// Box Data do Processamento
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+1170,_nPosHor+(_nLinha*_nEspLin),_nPosVer+1650)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+1180,"Data do Processamento",ofont08,100)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+30,_nPosVer+1280,_aTitulos[_nCont][15],ofont08,100)

// Box Cart./nosso numero
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+1650,_nPosHor+(_nLinha*_nEspLin),_nPosVer+2230)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+1660,"Cart./nosso n�mero",ofont08,100)
//oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+30,_nPosVer+1960,_aTitulos[_nCont][07]+"/"+transform(_aTitulos[_nCont][04],"@R 99999999999-999999"),ofont08B,100)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+30,_nPosVer+1960,_aTitulos[_nCont][07]+"/"+SUBSTR(_aTitulos[_nCont][04],4,8)+"-"+SUBSTR(_aTitulos[_nCont][04],12,1),ofont08B,100)

// Box Uso do Banco
_nLinha  += 1
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer,_nPosHor+(_nLinha*_nEspLin),_nPosVer+0300)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+0010,"Uso do Banco",ofont08,100)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+30,_nPosVer+0050,"08650",ofont08,100)

// Box Carteira
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+0300,_nPosHor+(_nLinha*_nEspLin),_nPosVer+0552)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+0310,"Carteira",ofont08,100)
//oprn:say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+30,_nPosVer+0315,"000",ofont08,100)

// Box Carteira
//oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+0420,_nPosHor+(_nLinha*_nEspLin),_nPosVer+0552)
//oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+0430,"Carteira",ofont08,100)
//oprn:say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+30,_nPosVer+0480,_aTitulos[_nCont][07],ofont08,100)

// Box Esp�cie Moeda
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+0552,_nPosHor+(_nLinha*_nEspLin),_nPosVer+0790)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+0562,"Esp�cie moeda",ofont08,100)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+30,_nPosVer+0662,"R$",ofont08,100)

// Box Quantidade
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+0790,_nPosHor+(_nLinha*_nEspLin),_nPosVer+1170)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+0800,"Quantidade",ofont08,100)

// Box Valor
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+1170,_nPosHor+(_nLinha*_nEspLin),_nPosVer+1650)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+1180,"Valor",ofont08,100)

// Box Valor do documento
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+1650,_nPosHor+(_nLinha*_nEspLin),_nPosVer+2230)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+1660,"1(=) Valor do documento",ofont08,100)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+30,_nPosVer+2000,transform(_aTitulos[_nCont][03],"@E 999,999,999.99"),ofont08B,100)

_nLinha  += 1

// Box Desconto / Abatimento
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+1650,_nPosHor+(_nLinha*_nEspLin),_nPosVer+2230)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+1660,"2(-) Desconto/abatimento",ofont08,100)

// Box Instrucoes
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer,_nPosHor+(_nLinha*_nEspLin)+4*_nEspLin,_nPosVer+1650)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+20,_nPosVer+0010,"Instru��es de responsabilidade do cedente.",ofont09B,100)

// Box Outras deducoes
_nLinha  += 1
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+1650,_nPosHor+(_nLinha*_nEspLin),_nPosVer+2230)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+1660,"3(-) Outras dedu��es",ofont08,100)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+0010,"*** Valores Expressos em R$ ***",ofont09B,100)

// Box Mora / Multa
_nLinha  += 1
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+1650,_nPosHor+(_nLinha*_nEspLin),_nPosVer+2230)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+1660,"4(+) Mora/Multa",ofont08,100)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+0010,"Apos o Vencimento Mora dia R$ "+transform(_aTitulos[_nCont][03]*0.003333,"@E 999,999,999.99"),ofont08,100)

// Box Outros acrescimos
_nLinha  += 1
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+1650,_nPosHor+(_nLinha*_nEspLin),_nPosVer+2230)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+1660,"5(+) Outros Acr�scimos",ofont08,100)
//oprn:say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+10,_nPosVer+0010,"APOS O VENCIMENTO, SER� COBRADO UMA MULTA DE 2,00 % SOBRE O VALOR DO BOLETO ",ofont09B,100)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox    ,_nPosVer+0010,"APOS O VENCIMENTO, SER� COBRADO UMA MULTA DE 2,00 % SOBRE O VALOR DO BOLETO ",ofont09B,150)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+33 ,_nPosVer+0010,"MAIS O VALOR DI�RIO DE MORA.",ofont09B,150)

// Box Valor cobrado
_nLinha  += 1
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+1650,_nPosHor+(_nLinha*_nEspLin),_nPosVer+2230)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+1660,"6(=) Valor cobrado",ofont08,100)
//oprn:say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+10,_nPosVer+0010,"MAIS O VALOR DI�RIO DE MORA.",ofont09B,100)
// Box Sacado
_nLinha  += 1
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer,_nPosHor+(_nLinha*_nEspLin)+_nEspLin,_nPosVer+2230)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+0010,"Sacado:",ofont08,100)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+0150,_aTitulos[_nCont][09],ofont08,100) // Nome Sacado
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+1400,Transform(_aTitulos[_nCont][14],"@R 99.999.999/9999-99"),ofont08,100) // CNPJ Sacado
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+0030,_nPosVer+0150,_aTitulos[_nCont][10],ofont08,100) // End. Sacado
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+0060,_nPosVer+0150,Transform(_aTitulos[_nCont][13],"@R 99999-999"),ofont08,100) // CEP Sacado
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+0060,_nPosVer+0550,_aTitulos[_nCont][11],ofont08,100) // Cidade Sacado
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+0060,_nPosVer+1000,_aTitulos[_nCont][12],ofont08,100) // Estado Sacado
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+0120,_nPosVer+0010,"Sacador/Avalista:",ofont08,100)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+0170,_nPosVer+1530,"Autentica��o Mec�nica",ofont08,100)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+0170,_nPosVer+1860,"Ficha de Compensa��o",ofont09,100)

// Imprime Logotipo do Banco
oPrn:Saybitmap(0013,0050,cPath+"LOGO_ITAU.PNG",0070,0070)

// Imprime Logotipo do Banco
oPrn:Saybitmap(0515,0050,cPath+"LOGO_ITAU.PNG",0070,0070)

// Imprime Logotipo do Banco
// oPrn:Saybitmap(0690,1850,cPath+"LOGO_ITAU.PNG",0180,0180)
// Logo acima foi substituido pelo logo da SPIDER

// Imprime Logotipo do Banco
oPrn:Saybitmap(2195,0050,cPath+"LOGO_ITAU.PNG",0070,0070)

// Imprime codigo de barras
// MSBAR("cTypeBar",nRow,   nCol,cCode       ,oPrint,lCheck,Color,lHorz  ,nWidth,nHeigth,lBanner,cFont,cMode)
// MSBAR("INT25"   ,27.15  ,0.7 ,_cbarra     ,oprn  ,.F.   ,      ,.T.   ,0.0135,0.65    ,NIL,NIL,NIL ,.F.)
//MSBAR("INT25"   ,29.15  ,0.7 ,_cbarra     ,oprn  ,.F.   ,      ,.T.   ,0.0255,1.25    ,NIL,NIL,NIL ,.F.)
MSBAR("INT25"   ,28.15  ,0.7 ,_cbarra     ,oprn  ,.F.   ,      ,.T.   ,0.0255,1.25    ,NIL,NIL,NIL ,.F.)



Return (.T.)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    � CISFT073B� Autor � Thiago Queiroz     � Data �  11/05/03   ���
�������������������������������������������������������������������������͹��
���Descricao � Monta codigo de barras que sera impresso.                  ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function CISFT073B()

Local _nAgen   := ""
Local _nCntCor := ""
Local _nI      := 0

/*
- Posicoes fixas padrao Banco Central
Posicao  Tam       Descricao
01 a 03   03	Codigo de Compensacao do Banco (341)
04 a 04   01	Codigo da Moeda (Real => 9, Outras => 0)
05 a 05   01	Digito verificador do codigo de barras
06 a 09	  04	Fator de Vencimento
06 a 19   14	Valor Nominal do Documento sem ponto

- Campo Livre Padrao ITAU
Posicao  Tam       Descricao
20 a 22   03	Carteira
23 a 30   08	Nosso Numero
31 A 31   01	Digito verificador do Nosso Numero
31 A 35   04	Numero da Agencia sem o digito
36 A 40   05	Numero da Conta corrente sem o digito
41 A 41   01	DAC (agencia/conta corrente)
42 A 44   01	Zeros
*/

// Monta numero da Agencia sem dv e com 4 caracteres
// Retira separador de digito se houver
For _nI := 1 To Len(_aTitulos[_nCont][05])
	If Subs(_aTitulos[_nCont][05],_nI,1) $ "0/1/2/3/4/5/6/7/8/9/"
		_nAgen += Subs(_aTitulos[_nCont][05],_nI,1)
	Endif
Next _nI
//-------------------------------------------------------------
//--> a agencia j� est� sem o digito --------------------------
//-------------------------------------------------------------
// retira o digito verificador
//_nAgen := StrZero(Val(Subs(Alltrim(_nAgen),1,Len(_nAgen)-1)),4)
//-------------------------------------------------------------
//-------------------------------------------------------------

//-------------------------------------------------------------
//--> Conta n�o tem divis�rias  -------------------------------
//-------------------------------------------------------------
// Monta numero da Conta Corrente sem dv e com 7 caracteres
// Retira separador de digito se houver
//For _nI := 1 To Len(_aTitulos[_nCont][16])
//	If Subs(_aTitulos[_nCont][16],_nI,1) $ "0/1/2/3/4/5/6/7/8/9/"
//		_nCntCor += Subs(_aTitulos[_nCont][16],_nI,1)
//	Endif
//Next _nI

_nCntCor += _aTitulos[_nCont][16]
// retira o digito verificador
//_nCntCor := StrZero(Val(Subs(Alltrim(_nCntCor),1,Len(_nCntCor)-1)),7)

_cCampo := ""
// Pos 01 a 03 - Identificacao do Banco        			3 POSICOES
_cCampo += "341"                                            //banco
// Pos 04 a 04 - Moeda                         			1 POSICAO
_cCampo += "9"                                              //moeda
// Pos 06 a 09 - Fator de vencimento           			4 POSICOES
_cCampo += StrZero(Int(_aTitulos[_nCont][02] - Fator),4)	//fator vencimento
// Pos 10 a 19 - Valor                         			10 POSICOES
_cCampo += StrZero(_aTitulos[_nCont][03]*100, 10)			//valor
// Pos 20 a 22 - Carteira                       		3 POSICOES
_cCampo += _aTitulos[_nCont][07]                           //carteira
// Pos 23 a 30 - Nosso Numero                      		8 POSICOES
_cCampo += Subs(_aTitulos[_nCont][04],4,8)               //Nosso Numero
// Pos 31 a 31 - Digito do nosso numero        			1 POSICAO
_cCampo += Subs(_aTitulos[_nCont][04],12,1)               //DAC Nosso Numero
// Pos 32 a 35 - Agencia		              			4 POSICOES
_cCampo += _nAgen                                          //Agencia
// Pos 36 a 40 - Conta Corrente			              	6 POSICOES
_cCampo += ALLTRIM(_nCntCor)                               //Conta Corrente + Digito
// Pos 42 a 44 - ZeroS                          		3 POSICOES
_cCampo += "000"                                           //Zeros
_cDigitbar := CISFT073C()

// Monta codigo de barras com digito verificador
_cBarra := Subs(_cCampo,1,4)+_cDigitbar+Subs(_cCampo,5,43)

Return()

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    � CISFT073C� Autor � Thiago Queiroz     � Data �  11/05/03   ���
�������������������������������������������������������������������������͹��
���Descricao � Calculo do Digito Verificador Codigo de Barras - MOD(11)   ���
���          � Pesos (2 a 9)                                              ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function CISFT073C()

Local _nCnt   := 0
Local _nPeso  := 2
Local _nJ     := 1
Local _nResto := 0

For _nJ := Len(_cCampo) To 1 Step -1
	_nCnt  := _nCnt + Val(SUBSTR(_cCampo,_nJ,1))*_nPeso
	_nPeso :=_nPeso+1
	if _nPeso > 9
		_nPeso := 2
	endif
Next _nJ

_nResto:=(_ncnt%11)

_nResto:=11 - _nResto

if _nResto == 0 .or. _nResto==1 .or. _nResto > 9
	_nDigbar:='1'
else
	_nDigbar:=Str(_nResto,1)
endif

Return(_nDigbar)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    � CISFT073D� Autor � Thiago Queiroz     � Data �  11/05/03   ���
�������������������������������������������������������������������������͹��
���Descricao � Monta da Linha Digitavel                                   ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static FUNCTION CISFT073D()

Local _nI   := 1
Local _nAux := 0
_cLinha     := ""
_nDigito    := 0
_cCampo     := ""

/*
Primeiro Campo
Posicao  Tam       Descricao
01 a 03   03   Codigo de Compensacao do Banco (341)
04 a 04   01   Codigo da Moeda (Real => 9, Outras => 0)
05 a 07   03   Codigo da Carteira de cobranca
08 a 09	  02   Pos 1 a 2 do Nosso Numero
10 a 10   01   Digito Auto Correcao (DAC) do primeiro campo

Segundo Campo
11 a 16   06   Pos 3 a 8 do Nosso Numero
17 a 17   01   DAC do Nosso Numero
18 a 20   03   Pos 1 a 3 do Cod da Agencia
21 a 21   01   Digito Auto Correcao (DAC) do segundo campo

Terceiro Campo
22 a 22   01   Pos 4 a 4 do Cod da Agencia
23 a 28   06   Conta Corrente + Digito
29 a 31   03   Zeros ("000")
32 a 32   01   Digito Auto Correcao (DAC) do terceiro campo

Quarto Campo
33 a 33   01   Digito Verificador do codigo de barras

Quinto Campo
34 a 37   04   Fator de Vencimento
38 a 47   10   Valor
*/

// 2501020000000001400331750

// Calculo do Primeiro Campo --> "34191.1210D"
_cCampo := ""
_cCampo := Subs(_cBarra,1,4)+Subs(_cBarra,20,5)

// Calculo do digito do Primeiro Campo
CISFT073E(2)
_cLinha += Subs(_cCampo,1,5)+"."+Subs(_cCampo,6,4)+Alltrim(Str(_nDigito))

// Insere espaco
_cLinha += " "

// Calculo do Segundo Campo
_cCampo := ""
_cCampo := Subs(_cBarra,25,10)

// Calculo do digito do Segundo Campo
CISFT073E(1)
_cLinha += Subs(_cCampo,1,5)+"."+Subs(_cCampo,6,5)+Alltrim(Str(_nDigito))

// Insere espaco
_cLinha += " "

// Calculo do Terceiro Campo
_cCampo := ""
_cCampo := Subs(_cBarra,35,10)

// Calculo do digito do Terceiro Campo
CISFT073E(1)
_cLinha += Subs(_cCampo,1,5)+"."+Subs(_cCampo,6,5)+Alltrim(Str(_nDigito))

// Insere espaco
_cLinha += " "

// Calculo do Quarto Campo
_cCampo := ""
_cCampo := Subs(_cBarra,5,1)
_cLinha += _cCampo

// Insere espaco
_cLinha += " "

// Calculo do Quinto Campo
_cCampo := ""
_cCampo := Subs(_cBarra,6,4)+Subs(_cBarra,10,10)
_cLinha += _cCampo

Return(.T.)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    � CISFT073E� Autor � Thiago Queiroz     � Data �  11/05/03   ���
�������������������������������������������������������������������������͹��
���Descricao � Calculo do Digito Verificador da Linha Digitavel - Mod(10) ���
���          � Pesos (1 e 2)                                              ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function CISFT073E(_nCnt)

Local _nI   := 1
Local _nAux := 0
Local _nInt := 0
_nDigito    := 0

For _nI := 1 to Len(_cCampo)
	
	_nAux := Val(Substr(_cCampo,_nI,1)) * _nCnt
	If _nAux >= 10
		_nAux:= (Val(Substr(Str(_nAux,2),1,1))+Val(Substr(Str(_nAux,2),2,1)))
	Endif
	
	_nCnt += 1
	If _nCnt > 2
		_nCnt := 1
	Endif
	_nDigito += _nAux
	
Next _nI

If (_nDigito%10) > 0
	_nInt    := Int(_nDigito/10) + 1
Else
	_nInt    := Int(_nDigito/10)
Endif

_nInt    := _nInt * 10
_nDigito := _nInt - _nDigito

Return()

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �VALIDPERG � Autor � AP5 IDE            � Data �  22/02/02   ���
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

Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,10)

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
aAdd(aRegs,{cPerg,"01","Da Nota            ?","","","mv_ch1","C",9,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Ate a Nota         ?","","","mv_ch2","C",9,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","SEA","",""})
aAdd(aRegs,{cPerg,"03","Serie              ?","","","mv_ch3","C",3,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","SEA","",""})

For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next

dbSelectArea(_sAlias)
Return
