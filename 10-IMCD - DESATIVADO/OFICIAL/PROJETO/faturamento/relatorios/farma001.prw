#INCLUDE "PROTHEUS.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPRINTSETUP.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ FARMA001 ³ Autor ³ Junior Carvalho       ³ Data ³19/12/2018³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Locacao   ³                  ³Contato ³ Junior.Gardel@gmail.com        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Aplicacao ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³  Data  ³ Bops ³ Manutencao Efetuada                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³  /  /  ³      ³                                        ³±±
±±³              ³  /  /  ³      ³                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function FARMA001()
// Variaveis Locais da Funcao

Local aGetCstCP	 := {"Contabil","Previsto"}
Local aGetSubTri	 := {"Não","Sim"}
Local aGetVisual	 := {"Sim","Não"}
Local aGetMoeda	 := {"1-Real","2-Dolar","4-Euro"}

Local oGetCli
Local oGetLoja
Local oGetNome
Local oGetQtd

Local oGetDtCota
Local oGetCstPrv
Local oGetDtPrvE
Local oGetPrcUni
Local oGetPrd


Private cGetCli	 	:= Space(06)
Private cGetLoja 	:= Space(02)
Private cGetNome 	:= Space(60)
Private cGetPrd	 	:= Space(15)
Private nGetQtd		:= 1
Private nGetPrcUni	:= 1
Private nGetCstPrv	:= 0
Private cGetMoeda
Private dGetDtCota	 := dDatabase
Private dGetDtPrvE	 := dDatabase
Private cGetCstCP
Private cGetVisual
Private cGetSubTri

// Variaveis Private da Funcao
Private oDlg				// Dialog Principal

DEFINE MSDIALOG oDlg TITLE "Custo Previo" FROM C(0),C(0) TO C(658),C(1019) PIXEL STYLE nOR( WS_VISIBLE, WS_POPUP )
oDlg:lMaximized := .T. //Maximizar a janela

// Cria Componentes Padroes do Sistema
@ C(005),C(025) Say "Cliente" Size C(100),C(008) COLOR CLR_BLACK PIXEL OF oDlg
@ C(005),C(125) MsGet oGetCli Var cGetCli F3 "CLT"  VALID(BSCCLI() ) Size C(040),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlg
@ C(005),C(165) MsGet oGetLoja Var cGetLoja VALID(BSCCLI()) Size C(010),C(009) COLOR CLR_BLACK WHEN .T. Picture "@!" PIXEL OF oDlg
@ C(005),C(175) MsGet oGetNome Var cGetNome Size C(100),C(009) COLOR CLR_BLACK WHEN .F. Picture "@!" PIXEL OF oDlg

@ C(017),C(025) Say "Produto" Size C(100),C(008) COLOR CLR_BLACK PIXEL OF oDlg
@ C(017),C(125) MsGet oGetPrd Var cGetPrd F3 "SB1" VALID ExistCpo("SB1") Size C(060),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlg
@ C(030),C(025) Say "Quantidade" Size C(100),C(008) COLOR CLR_BLACK PIXEL OF oDlg
@ C(030),C(125) MsGet oGetQtd Var nGetQtd Size C(060),C(009) COLOR CLR_BLACK Picture "@E 999,999,999.9999" PIXEL OF oDlg

@ C(042),C(025) Say "Preço Unitario" Size C(100),C(008) COLOR CLR_BLACK PIXEL OF oDlg
@ C(042),C(125) MsGet oGetPrcUni Var nGetPrcUni Size C(060),C(009) COLOR CLR_BLACK Picture "@E 9,999,999.9999" PIXEL OF oDlg
/*
@ C(055),C(025) Say "Pis / Cofins" Size C(100),C(008) COLOR CLR_BLACK PIXEL OF oDlg
@ C(055),C(125) MsGet oGetPisCof Var nGetPisCof Size C(060),C(009) COLOR CLR_BLACK Picture "@E 9.99" PIXEL OF oDlg VALID VALIDPISCOF()
*/
@ C(055),C(025) Say "Custo Previsto" Size C(100),C(008) COLOR CLR_BLACK PIXEL OF oDlg
@ C(055),C(125) MsGet oGetCstPrv Var nGetCstPrv Size C(060),C(009) COLOR CLR_BLACK Picture "@E 9,999,999.9999" PIXEL OF oDlg
@ C(067),C(025) Say "Moeda" Size C(100),C(008) COLOR CLR_BLACK PIXEL OF oDlg
@ C(067),C(125) ComboBox cGetMoeda ITEMS aGetMoeda Size C(060),C(010) PIXEL OF oDlg

@ C(080),C(025) Say "Data Cotação" Size C(100),C(008) COLOR CLR_BLACK PIXEL OF oDlg
@ C(080),C(125) MsGet oGetDtCota Var dGetDtCota Size C(060),C(009) COLOR CLR_BLACK Picture "@D 99/99/99" PIXEL OF oDlg
@ C(092),C(025) Say "Previsão de Entrega" Size C(100),C(008) COLOR CLR_BLACK PIXEL OF oDlg
@ C(092),C(125) MsGet oGetDtPrvE Var dGetDtPrvE Size C(060),C(009) COLOR CLR_BLACK Picture "@D 99/99/99" PIXEL OF oDlg
@ C(105),C(025) Say "Custo Contabil ou Previsto" Size C(100),C(008) COLOR CLR_BLACK PIXEL OF oDlg
@ C(105),C(125) ComboBox cGetCstCP ITEMS aGetCstCP Size C(060),C(009)  PIXEL OF oDlg
@ C(117),C(025) Say "Quer Visualizar o Calculo de Lucro" Size C(100),C(008) COLOR CLR_BLACK PIXEL OF oDlg
@ C(117),C(125) ComboBox cGetVisual ITEMS aGetVisual Size C(060),C(010) PIXEL OF oDlg
@ C(130),C(025) Say "Com Substituição Tributaria" Size C(100),C(008) COLOR CLR_BLACK PIXEL OF oDlg
@ C(130),C(125) ComboBox cGetSubTri ITEMS aGetSubTri Size C(060),C(010) PIXEL OF oDlg

@ C(030),C(250) Button "Gerar PDF" Size C(037),C(012) PIXEL OF oDlg ;
ACTION( 	Processa({|| GERARPDF(nGetQtd, nGetPrcUni) },"Gerando PDF.","",.T.)    )

@ C(075),C(250) Button "Fechar" Size C(037),C(012) PIXEL OF oDlg	 ACTION(oDlg:End())
// Cria ExecBlocks dos Componentes Padroes do Sistema

ACTIVATE MSDIALOG oDlg CENTERED

Return(.T.)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³   C()   ³ Autores ³ Norbert/Ernani/Mansano ³ Data ³10/05/2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³ Funcao responsavel por manter o Layout independente da       ³±±
±±³           ³ resolucao horizontal do Monitor do Usuario.                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function C(nTam)

Local nHRes	:=	oMainWnd:nClientWidth	// Resolucao horizontal do monitor
If nHRes == 640	// Resolucao 640x480 (soh o Ocean e o Classic aceitam 640)
	nTam *= 0.8
ElseIf (nHRes == 798).Or.(nHRes == 800)	// Resolucao 800x600
	nTam *= 1
Else	// Resolucao 1024x768 e acima
	nTam *= 1.28
EndIf
Return Int(nTam)

Static Function GERARPDF()

Local cStartPath := GetSrvProfString("Startpath","")
Local nBox2 := 10
Local nBox4 := 600
Local i := 0
Private oPrn

PRIVATE oFont08  := TFont():New( "Arial",,08,,.F.,,,,,.F.)
PRIVATE oFont08N := TFont():New( "Arial",,08,,.T.,,,,,.F.)
PRIVATE oFont09  := TFont():New( "Arial",,09,,.F.,,,,,.F.)
PRIVATE oFont09N := TFont():New( "Arial",,09,,.T.,,,,,.F.)
PRIVATE oFont10  := TFont():New( "Arial",,10,,.F.,,,,,.F.)
PRIVATE oFont10N := TFont():New( "Arial",,10,,.T.,,,,,.F.)
PRIVATE oFont12N := TFont():New( "Arial Black",,12,,.T.,,,,,.F.)

nAliqIcms	:= 0
cGetPrd := PadR(cGetPrd, tamsx3('D3_COD') [1])
SB1->( dbSetOrder( 1 ) )
SB1->(DbSeek(xFilial("SB1")+ cGetPrd ))

cOrigem:= SB1->B1_ORIGEM
nAliqPis	:= SB1->B1_PPIS
nAliqCof	:= SB1->B1_PCOFINS
nAliqIPi	:= SB1->B1_IPI

SA1->( dbSetOrder( 1 ) )
SA1->( dbSeek( xFilial( "SA1" )+cGetCli	+cGetLoja) )
cGetNome := SA1->A1_NOME
if SUBSTR(cGetSubTri,1,1) == "N"
	if !(SA1->A1_EST =='EX')
		
		IF SM0->M0_ESTCOB == SA1->A1_EST
			nAliqIcms := SuperGetMV("MV_ICMPAD")
		Else
			If ( SA1->A1_EST $ SuperGetMV("MV_NORTE") )
				nAliqIcms := 7
			Else
				nAliqIcms := 12
			Endif
		Endif
		
		If cOrigem $ "1|2|3|8" .and. SA1->A1_EST <> SuperGetMV("MV_ESTADO")
			If nAliqIcms <> SuperGetMV("MV_ICMPAD")
				nAliqIcms	:= 4
			Endif
		Endif
	ENDIF
else
	nAliqIcms := 0
endif

if SA1->A1_EST $ GETMV("ES_IPIINSE")
	nAliqIPi := 0
Endif

If SUBSTR(cGetCstCP,1,1) == "P"
	If nGetCstPrv <= 0
		Alert("Custo Previsto menor ou igual a zero")
	Endif
Endif

if SA1->A1_EST == 'AM'
	nAliqCof := 0
	nAliqPis := 0
endif

nTaxa := 1

cMoeda := SUBSTR(cGetMoeda,1,1)
if cMoeda <> '1'
	
	DbSelectArea("SM2")
	DbSetOrder(1)
	If DbSeek(dGetDtCota)
		xMoeda := 'M2_MOEDA' + cMoeda
		if SM2->(&xMoeda) > 0
			nTaxa := SM2->(&xMoeda)
		else
			Alert("A moeda do dia não foi informada")
		Endif
	Endif
Endif

cDirDest := "C:\TEMP\"
lAdjustToLegacy := .F.
lDisableSetup  := .T.
lPreview := .T.

MakeDir(cDirDest)
cFilePrint	:= "CUSTO_PREVIO_"+Dtos(MSDate())+StrTran(Time(),":","")+'.pdf'

oPrn	:=FWMSPrinter():New(cFilePrint, IMP_PDF, lAdjustToLegacy, cDirDest , lDisableSetup ,, @oPrn,,,,,lPreview)

oPrn:SetResolution(78)
oPrn:SetPortrait()
oPrn:SetPaperSize(DMPAPER_A4)
oPrn:SetMargin(20,20,20,20)
oPrn:cPathPDF := cDirDest

oPrn:StartPage()

oPrn:BOX(  020, nBox2, 130, nBox4)

cLogo := GetSrvProfString("Startpath","") + "logo_imcd.bmp"

oPrn:SayBitmap(030, 040,cLogo, 095, 095)    //LOGO DA EMPRESA

oPrn:Say(050,150, Capital( AllTrim( GetAdvFVal( "SM0", "M0_NOMECOM", cEmpAnt + cFilAnt, 1, "" ) ) ),oFont12N,100)

oPrn:Say(065,150, Capital( SM0->M0_ENDCOB ) ,oFont10N,100)
oPrn:Say(065,420, "CEP.......: "+SM0->M0_CEPCOB ,oFont10N,100)

oPrn:Say(080,150, Alltrim(SM0->M0_CIDCOB),oFont10N,100)
oPrn:Say(080,420, SM0->M0_ESTCOB ,oFont10N,100)

oPrn:Say(095,150, "CNPJ..: "+	Transform(SM0->M0_CGC,"@r 99.999.999/9999-99")  ,oFont10N,100)
oPrn:Say(095,420, "Inscr.Est.: "+Transform(SM0->M0_INSC,"@r 999.999.999.99")  ,oFont10N,100)

oPrn:Say(110,150, "Fone..: "+SM0->M0_TEL ,oFont10N,100)

oPrn:Say(125,150, "email:  "	 ,oFont10N,100)
oPrn:Say(125,420, "Emissão:  " + DTOC(SCJ->CJ_EMISSAO) ,oFont10N,100)


oPrn:BOX(  130, nBox2, 150, nBox4)
oPrn:Say( 0145,230, "CONSULTA LUCRO SOBRE VENDA" ,oFont12N,100)

//vendedor
dbselectarea("SA3")
dbsetorder(1)
dbgotop()
dbseek(xfilial("SA3")+ SA1->A1_VEND )

//DADOS DO MUNICIPIO
dbselectarea("CC2")
dbsetorder(2)
dbgotop()
dbseek(xfilial("CC2")+ SA1->A1_CODMUNE )

dbselectarea("SB2")
dbsetorder(1)
dbseek(xfilial("SB2")+ cGetPrd +"01" )

oPrn:BOX(  150, nBox2, 230, nBox4)
nLin := 165
oPrn:Say(nLin,020, "Cliente       :    " +SA1->A1_COD+"-"+SA1->A1_LOJA +" "+ Alltrim(SA1->A1_NOME) ,oFont10,100)
oPrn:Say(nLin,380, "CNPJ     :    " + Transform(SA1->A1_CGC,"@r 99.999.999/9999-99")  ,oFont10,100)

nLin+=015
oPrn:Say(nLin,020, "Endereço   :    " + Alltrim(SA1->A1_END)  ,oFont10,100)
oPrn:Say(nLin,380, "BAIRRO :    " + Alltrim(SA1->A1_BAIRRO)  ,oFont10,100)

nLin+=015
oPrn:Say(nLin,020, "Cidade       :    " + Alltrim(SA1->A1_MUN)+" - ESTADO :" + Alltrim(SA1->A1_EST)   ,oFont10,100)
oPrn:Say(nLin,380, "CEP        :    " + Alltrim(SA1->A1_CEP) ,oFont10,100)

nLin+= 015
oPrn:Say(nLin,020, "Fone          :    " + Alltrim(SA1->A1_DDD)+ "-" + Alltrim(SA1->A1_TEL)  ,oFont10,100)
oPrn:Say(nLin,380, "Insc. Est     :    " +Transform(SA1->A1_INSCR,"@r 999.999.999.99")  ,oFont10,100)

nLin+=015
oPrn:Say(nLin,020, "Vendedor   :    " + SA3->A3_COD +" - "+Alltrim(SA3->A3_NOME) ,oFont10,100)

oPrn:BOX(  230, nBox2, 260, nBox4)
nLin := 240

oPrn:Say(nLin,020, "Codigo",oFont08N,100)
oPrn:Say(nLin,080, "Descrição do Produto",oFont08N,100)
oPrn:Say(nLin,250, "Data Entr.",oFont08N,100)
oPrn:Say(nLin,300, "Qtde Ped.",oFont08N,100)
oPrn:Say(nLin,350, "U/M",oFont08N,100)
oPrn:Say(nLin,370, "Moeda",oFont08N,100)
oPrn:Say(nLin,400, "Vlr. Unit",oFont08N,100)
oPrn:Say(nLin,450, "Vlr Prdouto",oFont08N,100)
oPrn:Say(nLin,500, "% IPI",oFont08N,100)
if SUBSTR(cGetVisual,1,1) == "S"
	oPrn:Say(nLin,540, "% Lucro",oFont08N,100)
	oPrn:Say(nLin+10,540, " S/Venda",oFont08N,100)
endif

//oPrn:Box(260,nBox2,280,nBox4)
nLin := 260
cDescProd := alltrim(SB1->B1_DESC)
nLin2 := mlcount(cDescProd,35,,.T.)   

nFimBox := nLin+10+(nLin2*10)
oPrn:Box(nLin,nBox2,nFimBox,nBox4)

nLin := 270
oPrn:Say(nLin,020, cGetPrd	, oFont08,100)

oPrn:Say(nLin,080, MEMOLINE(cDescProd,35,1)   ,oFont08,100)
oPrn:Say(nLin,255, DTOC(dGetDtPrvE) ,oFont08,100)
oPrn:Say(nLin,300, TRANSFORM(nGetQtd,"@E 999,999.99" ) ,oFont08,100)
oPrn:Say(nLin,350, SB1->B1_UM   ,oFont08,100)
oPrn:Say(nLin,370, IF( cMoeda='1',"R$",IF(cMoeda='4',"EUR","US$"))  ,oFont08,100)
oPrn:Say(nLin,400, TRANSFORM(nGetPrcUni,"@E 999,999.99" ) ,oFont08,100)
oPrn:Say(nLin,450, TRANSFORM(nGetPrcUni*nGetQtd,"@E 999,999.99" ) ,oFont08,100)
oPrn:Say(nLin,500, TRANSFORM(nAliqIpi,"@E 99.99" ) ,oFont08,100)

nAliqIMP := ( (nAliqIcms+nAliqPIs+nAliqCof) / 100 )
nPreco := Round( (nGetPrcUni / (1- nAliqImp)) * nTaxa, 2 )
nValor := Round(nGetQtd	 * nPreco, 2 )

nPrcVen := ROUND(nGetPrcUni * nGetQtd * nTaxa,2)
nIPI 	:= ROUND(nPrcVen * (nAliqIPI  / 100),2)
nICMS	:= ROUND(nPrcVen * (nAliqIcms / 100),2)
nPis	:= ROUND(nPrcVen * (nAliqPis / 100),2)
nCof	:= ROUND(nPrcVen * (nAliqCof / 100),2)

nCstCtb := ROUND( SB2->B2_CM1 * nGetQtd , 2)
nCstPrv := ROUND(((nGetCstPrv * nTaxa)) *nGetQtd,2)
nCstCalc :=	ROUND(nPrcVen - (nICMS+nPis+nCof),2)

nLucro1 := ROUND(nCstCalc - nCstCtb,2)
nLucro2 := iif (nCstPrv > 0,ROUND(nCstCalc - nCstPrv,2),0)

nPercL1 := ROUND(1 - ( nCstCtb / nCstCalc ),4) * 100
nPercL2 := iif (nCstPrv > 0, ROUND(1 - ( nCstPrv / nCstCalc ),4) * 100,0)

nPrdPrd := ROUND(nGetPrcUni * nGetQtd,2)
if SUBSTR(cGetVisual,1,1) == "S"
	cTexto := iif (SUBSTR(cGetCstCP,1,1) == "P" , " Prev"," Cont.")
	oPrn:Say(nLin,540, TRANSFORM(nPercL1,"@E 999.99" )+cTexto ,oFont08,100)
endif

For i := 2 to nLin2
	nLin += 10
	oPrn:Say(nLin,080,  MEMOLINE(cDescProd,35,I) ,oFont08,100)
Next

nLin += 10
oPrn:Box(nLin,nBox2,nLin+60,nBox4)
nLin += 15
oPrn:Say(nLin,020, "Vlr Venda R$ ",oFont08N,100)
oPrn:Say(nLin,080, PADL(Transform(nPrcVen,"@E 99,999,999.99" ),15)  ,oFont08N,100)

oPrn:Say(nLin,140, "PIS R$ ",oFont08N,100)
oPrn:Say(nLin,200, PADL(Transform(nPis,   "@E 999,999.99" ),15) ,oFont08N,100)

oPrn:Say(nLin,260, "Custo Contabil R$ ",oFont08N,100)
oPrn:Say(nLin,330, PADL(Transform(nCstCtb,"@E 999,999.99" ),15) ,oFont08N,100)

oPrn:Say(nLin,400, "Lucro 1 R$ ",oFont08N,100)
oPrn:Say(nLin,440, PADL(Transform(nLucro1,"@E 999,999.99" ),15) ,oFont08N,100)

oPrn:Say(nLin,490, "Lucro s/ Contr.%",oFont08N,100)
oPrn:Say(nLin,550, PADL(Transform(nPercL1,"@E 999.99" ),15) ,oFont08N,100)

nLin += 15
oPrn:Say(nLin,020, "IPI R$ " ,oFont08N,100)
oPrn:Say(nLin,080, PADL(Transform(nIPI,"@E 999,999.99" ),15)  ,oFont08N,100)

oPrn:Say(nLin,140, "COFINS R$ " ,oFont08N,100)
oPrn:Say(nLin,200, PADL(Transform(nCof,"@E 999,999.99" ),15) ,oFont08N,100)

oPrn:Say(nLin,260, "Custo Previsto R$ ",oFont08N,100)
oPrn:Say(nLin,330, PADL(Transform(nCstPrv,"@E 999,999.99" ),15) ,oFont08N,100)

oPrn:Say(nLin,400, "Lucro 2 R$ ",oFont08N,100)
oPrn:Say(nLin,440, PADL(Transform(nLucro2,"@E 999,999.99" ),15) ,oFont08N,100)

oPrn:Say(nLin,490, "Lucro s/Prev.%",oFont08N,100)
oPrn:Say(nLin,550, PADL(Transform(nPercL2,"@E 999.99" ),15) ,oFont08N,100)

nLin += 15
oPrn:Say(nLin,020, "ICMS R$ ",oFont08N,100)
oPrn:Say(nLin,080, PADL(Transform(nICMS,"@E 999,999.99" ),15)  ,oFont08N,100)


aUltComp := BSCULTCOMP(cGetPrd)
//           aUltComp[2]/aUltComp[1]

nUltComp := aUltComp[2]/aUltComp[1]
nUltCpQt := aUltComp[1]

nCstMed := SB2->B2_CM1

cUltcomp := Transform( nUltComp ,"@E 999,999,999.99" )
cUltcomp += Transform( nUltComp / nUltCpQt ,"@E 999,999,999.999999" )+Space(5)
cUltcomp += Space(05)+aUltComp[3]

oPrn:Say(nLin,140, "Ult. Compra R$ " ,oFont08N,100)
oPrn:Say(nLin,200, cUltcomp ,oFont08N,100)

oPrn:Say(nLin,400, "Custo Medio Atual R$ ",oFont08N,100)
oPrn:Say(nLin,490, PADL(Transform( nCstMed ,"@E 999,999.99" ),15) ,oFont08N,100)

nLin += 15
oPrn:Box(nLin,nBox2,nLin+85,nBox4)
nLin += 15
vTotServ :=  0
oPrn:Say(nLin,020, "Valor Produtos.............: ",oFont08N,100)
oPrn:Say(nLin,150, PADL(Transform(nPrdPrd,"@E 999,999.99" ),15) ,oFont08N,100)
oPrn:Say(nLin,300, "Valor Servico.............: ",oFont08N,100)
oPrn:Say(nLin,430, PADL(Transform(vTotServ,"@E 999,999.99" ),15) ,oFont08N,100)

nLin += 15
oPrn:Say(nLin,020, "Valor IPI....................: " ,oFont08N,100) 
oPrn:Say(nLin,150, PADL(Transform(nIPI / nTaxa ,"@E 999,999.99" ),15) ,oFont08N,100)
oPrn:Say(nLin,300, "Valor PIS....................: " ,oFont08N,100)
if SA1->A1_EST == 'AM'
	oPrn:Say(nLin,430,PADL('0,00',15),oFont08N,100)
else
	oPrn:Say(nLin,430, PADL(Transform(nPis / nTaxa,"@E 999,999.99" ) ,15),oFont08N,100)
endif

nLin +=  15
oPrn:Say(nLin,020, "Valor ICM..................: "  ,oFont08N,100)
oPrn:Say(nLin,150, + PADL(Transform(nICMS / nTaxa,"@E 999,999.99" ),15)+"  "+Transform(nAliqIcms,"@E 99.99" )+" %" ,oFont08N,100)

oPrn:Say(nLin,300, "Valor Cofins.............: ",oFont08N,100)
if SA1->A1_EST == 'AM'
	oPrn:Say(nLin,430,PADL('0,00',15) ,oFont08N,100)
else	
	oPrn:Say(nLin,430, PADL(Transform(nCof / nTaxa,"@E 999,999.99" ),15) ,oFont08N,100)
endif
nLin +=  15
oPrn:Say(nLin,020, "Valor Valor Liquido....: " ,oFont08N,100)
oPrn:Say(nLin,150, PADL(Transform( (nPrdPrd + nIPI ) ,"@E 999,999.99" ),15) ,oFont08N,100)

oPrn:Say(nLin,300, "Taxa Moeda.............: " ,oFont08N,100)
oPrn:Say(nLin,430, PADL(Transform(nTaxa,"@E 999,999.9999" ),15) +" - " +DTOC(dGetDtCota) ,oFont08N,100)

nLin +=  25
oPrn:Box(nLin,nBox2,nLin+20,nBox4)
nLin +=  15
oPrn:Say(nLin,020, "Embalagem: Produto:  " + Alltrim(cGetPrd) + "  Saco(s) c/  " +  Transform(SB1->B1_QE,"@E 999,999.99" )  ,oFont08,100)

nLin +=  20
oPrn:Say(nLin,020, FunName() ,oFont08,100)
oPrn:Say(nLin,400, " Usuário ...........: " + __cUserId + " " +  cUserName ,oFont08,100)

oPrn:EndPage()

If lPreview
	oPrn:Preview()
EndIf

FreeObj(oPrn)
oPrn := Nil

Return



Static Function VALIDPISCOF()
Local lRet := .T.

IF !(nGetPisCof == 0 .OR. nGetPisCof == 9.25 .OR. nGetPisCof == 3.65)
	Alert("Aliquota incorreta, deverá  ser 9.25 ou 3.65")
	lRet := .F.
Endif

Return lRet


Static Function BSCULTCOMP(cPrd)

Local cAliasSD1 := GetNextAlias()
Local aRet := {0,0,''}
Default cPrd := ''

if !Empty(cPrd)
	BeginSql Alias cAliasSD1
		SELECT D1_QUANT, D1_CUSTO, D1_EMISSAO
		
		FROM %Table:SD1% SD1
		WHERE D1_EMISSAO = (SELECT MAX(B.D1_EMISSAO)
		FROM %Table:SD1%  B
		WHERE B.D1_FILIAL||B.D1_COD = SD1.D1_FILIAL||SD1.D1_COD
		AND B.%NotDel% )
		
		AND D1_FILIAL = %xFilial:SD1%
		AND D1_COD = %Exp:cPrd%
		AND SD1.%NotDel%
		
	EndSql
	
	dbSelectArea(cAliasSD1)
	dbGoTop()
	cData := right((cAliasSD1)->D1_EMISSAO ,2) + '/' + substr((cAliasSD1)->D1_EMISSAO ,5,2) + '/' + left( (cAliasSD1)->D1_EMISSAO ,4)
	
	aRet[1] := (cAliasSD1)->D1_QUANT
	aRet[2] := (cAliasSD1)->D1_CUSTO
	aRet[3] := cData
	
	If Select(cAliasSD1) > 0
		(cAliasSD1)->(DbCloseArea())
	EndIf
	
Endif

Return aRet

static Function BSCCLI()

SA1->( dbSetOrder( 1 ) )
SA1->( dbSeek( xFilial( "SA1" )+cGetCli	+cGetLoja) )
cGetNome := SA1->A1_NOME

Return .T.

