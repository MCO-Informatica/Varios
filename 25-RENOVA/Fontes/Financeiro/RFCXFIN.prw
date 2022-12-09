#include "RwMake.ch"
#Include "Protheus.ch"
#Include "TopConn.ch"

#DEFINE EMP			1
#DEFINE FIL			2
#DEFINE BCO			3
#DEFINE AGEN		4
#DEFINE CONT		5
#DEFINE DESCRICAO	6
#DEFINE DISPONIVEL	7
#DEFINE DES_TOTAL	8

#DEFINE EMPRESA		1
#DEFINE FILIAL		2
#DEFINE BANCO		3
#DEFINE AGENCIA		4
#DEFINE CONTA		5
#DEFINE DT_VENC		6
#DEFINE SUPERIOR	7
#DEFINE NATUREZ		8
#DEFINE DESCNAT		9
#DEFINE PREFIXO		10
#DEFINE TITUL		11
#DEFINE TIPO		12
#DEFINE EMISSAO		13
#DEFINE BAIXA		14
#DEFINE CUSTO		15
#DEFINE FORNEC		16
#DEFINE NOM_FORNEC	17
#DEFINE ORIGEM		18
#DEFINE MOVIMENTO	19
#DEFINE HIST		20
#DEFINE VL_VAL		21
#DEFINE VL_DIS		22
#DEFINE TAXA		23
#DEFINE DESC_TOTAL	24

Static lFWCodFil := FindFunction("FWCodFil")
Static nTamFilial:= IIf( lFWCodFil, FWGETTAMFILIAL, 2 )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Função	 ³ RFCXFIN	³ Autor ³ Microsiga               ³ Data ³ 12.05.12 		³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrição ³ Fluxo de Caixa Analitico						         				³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ RFCXFIN(void)													   	³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RFCXFIN()

Local oReport

oReport 	:= ReportDef()
oReport		:PrintDialog()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Função    ³ ReportDef³ Autor ³ Microsiga		        ³ Data ³ 12.05.12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrição ³ Definicao do layout do Relatorio							  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ReportDef(void)                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ReportDef()
Local oReport
Local oSection1, oSection2

oReport := TReport():New("RFCXFIN","Fluxo de Caixa Analitico","RFCXFI",{|oReport| ReportPrint(oReport)},"Este programa irá imprimir o Fluxo de Caixa, informando ao usuário quais as suas contas a receber e a pagar dia a dia e tambem seu disponível de acordo com os saldos bancários")

oReport:SetLandScape(.T.)
oReport:DisableOrientation()

Ajusta()
pergunte("RFCXFI",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros						  ³
//³ mv_par01			// Nro de Dias 							  ³
//³ mv_par02			// Moeda 								  ³
//³ mv_par03			// Empresa Atual				 		  ³
//³ mv_par04			// Considera Pedidos de Vendas			  ³
//³ mv_par05			// Considera Pedidos de Compras			  ³
//³ mv_par06			// Imprime Totais						  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

oSection1 := TRSection():New(oReport,"Fluxo de Caixa Analitico",{"SE2"},)
TRCell():New(oSection1,"TOTAL",,,,208,.F.,)
TRCell():New(oSection1,"EMPRESA",,"Emp",,2,.F.,)
TRCell():New(oSection1,"FILIAL",,"Fil",,2,.F.,)
TRCell():New(oSection1,"BANCO",,"Bco",,3,.F.,)
TRCell():New(oSection1,"AGENCIA",,"Ag.",,5,.F.,)
TRCell():New(oSection1,"CONTA",,"Conta",,10,.F.,)
TRCell():New(oSection1,"DESCRIC",,,,187,.F.,)
TRCell():New(oSection1,"VL_DISPO",,"Disponivel","@E 999,999,999,999,999.99",20,.F.,)
oSection1:Cell("VL_DISPO"):SetHeaderAlign("RIGHT")
oSection1:SetHeaderSection(.F.)
oSection1:Setnofilter("SE2")

oSection2 := TRSection():New(oReport,"Movimentos",{"SE2"},)
TRCell():New(oSection2,"TOTAL",,,,192,.F.,)
TRCell():New(oSection2,"EMPRESA","SE2","Emp",,2,.F.,)
TRCell():New(oSection2,"FILIAL","SE2","Fil",,2,.F.,)
TRCell():New(oSection2,"BANCO","SE2","Bco",,3,.F.,)
TRCell():New(oSection2,"AGENCIA","SE2","Ag.",,7,.F.,)
TRCell():New(oSection2,"CONTA","SE2","Conta",,10,.F.,)
TRCell():New(oSection2,"E2_VENCREA","SE2","Data Ref",,10,.F.,)
TRCell():New(oSection2,"SUPERIOR","SE2","NatSup",,6,.F.,)
TRCell():New(oSection2,"E2_NATUREZ","SE2","Natur",,6,.F.,)
TRCell():New(oSection2,"DESCNAT","SE2","Desc Nat",,20,.F.,)
TRCell():New(oSection2,"E2_PREFIXO","SE2","Prf",,3,.F.,)
TRCell():New(oSection2,"TITULO",,"Numero-PC",,13,.F.,)
TRCell():New(oSection2,"E2_TIPO","SE2","Tip",,3,.F.,)
TRCell():New(oSection2,"E2_EMISSAO","SE2","Dt Emiss",,10,.F.,)
TRCell():New(oSection2,"E2_BAIXA","SE2","Dt Baixa",,10,.F.,)
TRCell():New(oSection2,"CUSTO","SE2","CCusto",,9,.F.,)
TRCell():New(oSection2,"E2_FORNECEDOR","SE2","Cli/For",,6,.F.,)
TRCell():New(oSection2,"E2_NOMFOR","SE2","Nome Cliente/Fornecedor",,20,.F.,)
TRCell():New(oSection2,"ORIGEM","SE2","Ori",,3,.F.,)
TRCell():New(oSection2,"MOVIMENTO","SE2","Mov",,3,.F.,)
TRCell():New(oSection2,"HIST","SE2","Hist",,20,.F.,)
TRCell():New(oSection2,"VL_VALOR",,"Valor","@E 999,999,999,999,999.99",20,.F.,)
TRCell():New(oSection2,"VL_DISPO",,"Disponivel","@E 999,999,999,999,999.99",20,.F.,)
oSection2:Cell("VL_VALOR"):SetHeaderAlign("RIGHT")
oSection2:Cell("VL_DISPO"):SetHeaderAlign("RIGHT")
oSection2:SetHeaderPage(.T.)
oSection2:Setnofilter("SE2")

Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportPrint³ Autor ³Microsiga		          ³ Data ³12.05.12	³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrição ³A funcao estatica ReportDef devera ser criada para todos os  ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpO1: Objeto Report do Relatório                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ReportPrint(oReport)

Local oSection1  := oReport:Section(1)
Local oSection2  := oReport:Section(2)
Local aDados1[8]
Local aDados2[24]
Local aVenc			:= {}
Local aCampos		:= {}
Local cAlias   		:= "SE2QRY"
Local cAlias1  		:= "SC7QRY"
Local cArqSA6		:= ""
Local cArqSE8       := ""
Local cArqTmp       := ""
Local cQuery		:= ""
Local cQuery1		:= ""
Local cTitulo 		:= OemToAnsi("Fluxo de Caixa Analitico")
Local cTpMov		:= ""
Local cNumMoeda		:= "M2_MOEDA"
Local cOrigem		:= ""
Local cEmp_Ini		:= SM0->M0_CODIGO
Local cFil_Ini		:= SM0->M0_CODFIL
Local cEmp_Ant		:= ""
Local cEmp			:= SM0->M0_CODIGO
Local cFil			:= SM0->M0_CODFIL
Local nDias			:= 0
Local nDispon		:= 0
Local nMulti		:= 0
Local nTotTitR		:= 0
Local nTotTitP		:= 0
Local nTotETitR		:= 0
Local nTotETitP		:= 0
Local nTotGTitR		:= 0
Local nTotGTitP		:= 0
Local nValor		:= 0
Local nIndSA6		:= 1
Local nIndSE8		:= 1
Local nRegSA6       := 0
Local nRecSE8       := 0
Local j       		:= 0
Local nX			:= 0
Local dDataAte
Local dDataIni
Local dDataVenc
Local dDtSE8        := Ctod("")
Local lFirst		:= .T.
Local lSldSE8		:= .F.
Local lMovim		:= .F.

Private cErros 		:= ""
Private adCompras 	:= {},adVendas:={}
Private aCompras	:= {},aVendas:={}

oSection1:Cell("TOTAL"			):SetBlock( { || aDados1[DES_TOTAL] })
oSection1:Cell("EMPRESA"		):SetBlock( { || aDados1[EMP] })
oSection1:Cell("FILIAL"			):SetBlock( { || aDados1[FIL] })
oSection1:Cell("BANCO"			):SetBlock( { || aDados1[BCO] })
oSection1:Cell("AGENCIA"		):SetBlock( { || aDados1[AGEN] })
oSection1:Cell("CONTA"			):SetBlock( { || aDados1[CONT] })
oSection1:Cell("DESCRIC"		):SetBlock( { || aDados1[DESCRICAO] })
oSection1:Cell("VL_DISPO"		):SetBlock( { || aDados1[DISPONIVEL] })
HabiCel(.T.,1,oReport)

oSection2:Cell("TOTAL"			):SetBlock( { || aDados2[DESC_TOTAL] })
oSection2:Cell("E2_VENCREA"		):SetBlock( { || aDados2[DT_VENC] })
oSection2:Cell("EMPRESA"		):SetBlock( { || aDados2[EMPRESA] })
oSection2:Cell("FILIAL"			):SetBlock( { || aDados2[FILIAL] })
oSection2:Cell("BANCO"			):SetBlock( { || aDados2[BANCO] })
oSection2:Cell("AGENCIA"		):SetBlock( { || aDados2[AGENCIA] })
oSection2:Cell("CONTA"			):SetBlock( { || aDados2[CONTA] })
oSection2:Cell("SUPERIOR"		):SetBlock( { || aDados2[SUPERIOR] })
oSection2:Cell("E2_NATUREZ"		):SetBlock( { || aDados2[NATUREZ] })
oSection2:Cell("DESCNAT"		):SetBlock( { || aDados2[DESCNAT] })
oSection2:Cell("E2_PREFIXO"		):SetBlock( { || aDados2[PREFIXO] })
oSection2:Cell("TITULO"			):SetBlock( { || aDados2[TITUL] })
oSection2:Cell("E2_TIPO"		):SetBlock( { || aDados2[TIPO] })
oSection2:Cell("E2_EMISSAO"		):SetBlock( { || aDados2[EMISSAO] })
oSection2:Cell("E2_BAIXA"		):SetBlock( { || aDados2[BAIXA] })
oSection2:Cell("CUSTO"	  		):SetBlock( { || aDados2[CUSTO] })
oSection2:Cell("E2_FORNECEDOR"	):SetBlock( { || aDados2[FORNEC] })
oSection2:Cell("E2_NOMFOR"		):SetBlock( { || aDados2[NOM_FORNEC] })
oSection2:Cell("ORIGEM"			):SetBlock( { || aDados2[ORIGEM]	 })
oSection2:Cell("MOVIMENTO"		):SetBlock( { || aDados2[MOVIMENTO] })
oSection2:Cell("HIST"			):SetBlock( { || aDados2[HIST] })
oSection2:Cell("VL_VALOR"		):SetBlock( { || aDados2[VL_VAL] })
oSection2:Cell("VL_DISPO"		):SetBlock( { || aDados2[VL_DIS] })
HabiCel(.T.,2,oReport)
#DEFINE HIST		20
cNumMoeda += CVALTOCHAR(mv_par02)

AADD(aCampos,{"TMP_DTVENC"	, "D" , 08,0})
AADD(aCampos,{"TMP_FILIAL"	, "C" , 10,0})
AADD(aCampos,{"TMP_SUP"		, "C" , 10,0})
AADD(aCampos,{"TMP_NATURE"	, "C" , 10,0})
AADD(aCampos,{"TMP_DESCNA"	, "C" , 25,0})
AADD(aCampos,{"TMP_TITUL"	, "C" , 09,0})
AADD(aCampos,{"TMP_EMISSA"	, "D" , 08,0})
AADD(aCampos,{"TMP_FORNEC"	, "C" , 06,0})
AADD(aCampos,{"TMP_NOMFOR"	, "C" , 25,0})
AADD(aCampos,{"TMP_CUSTO"	, "C" , 10,0})
AADD(aCampos,{"TMP_TPMOV"	, "C" , 1,0})
AADD(aCampos,{"TMP_VALOR"	, "N" , 17,2})

cTitulo += " em "+GetMV("MV_MOEDA"+AllTrim(Str(mv_par02,2)))
nDias	:= mv_par01

oReport:SetTitle(cTitulo)

If mv_par03 = 2
	oReport:SetMeter(SM0->(RecCount())*(1+nDias))
Else
	oReport:SetMeter(nDias)
EndIf

aFill(aDados1,nil)
oSection1:Init()

dbSelectArea("SM0")
dbGotop()

While ! SM0->(Eof())
	If mv_par03 = 1 .And. SM0->(M0_CODIGO+M0_CODFIL) <> cEmp_Ini+cFil_Ini
		SM0->(dbSkip())
		Loop
	EndIf
	
	If mv_par03 = 2
		If SM0->M0_CODIGO = cEmp_Ant
			SM0->(dbSkip())
			Loop
		EndIf
		
		oReport:IncMeter()
		
		cEmp	:= SM0->M0_CODIGO
		cFil	:= SM0->M0_CODFIL
		dbCloseAll()
		cEmpAnt	:= cEmp
		cFilAnt := cFil
		cNumEmp := cEmp+cFil
		cModulo := "FIN"
		nModulo := 6
		OpenSM0(cEmpAnt+cFilAnt)
		OpenFile(cEmpAnt+cFilAnt)
	EndIf
	
	//Contas Correntes
	If !Empty(xFilial("SA6"))
		dbSelectArea("SA6")
		cArqSA6 := CriaTrab(,.F.)
		IndRegua("SA6",cArqSA6,"A6_COD+A6_AGENCIA+A6_NUMCON",,,OemToAnsi("Selecionando Registros..."))  //"Selecionando Registros..."
		nIndSA6 := RetIndex("SA6") + 1
		dbSetOrder(nIndSA6)
	Endif
	
	// Saldo Bancario
	dbSelectArea("SE8")
	cArqSE8 := CriaTrab(,.F.)
	IndRegua("SE8",cArqSE8,"E8_BANCO+E8_AGENCIA+E8_CONTA+DTOS(E8_DTSALAT)",,,OemToAnsi("Selecionando Registros..."))  //"Selecionando Registros..."
	nIndSE8 := RetIndex("SE8") + 1
	dbSetOrder(nIndSE8)
	
	dDataAte := dDataBase+mv_par01
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprime disponibilidade Bancaria									  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SA6")
	dbGotop()
	
	cSuf := AllTrim(Str(mv_par02,2,0))
	
	While ! SA6->(Eof())
		
		IF SA6->A6_FLUXCAI == "N"
			SA6->(dbSkip())
			Loop
		Endif
		nRegSA6 := RecNo()
		
		dbSelectArea("SA6")
		dbGoTo(nRegSA6)
		dbSelectArea("SE8")
		dbSetOrder( nIndSE8 )
		If !(dbSeek(""+SA6->A6_COD+SA6->A6_AGENCIA+SA6->A6_NUMCON+DtoS(dDataBase),.t.))
			dbSkip( -1 )
			dDtSE8  := SE8->E8_DTSALAT
			lSldSE8 := .F.
			nRecSE8 := SE8->(RECNO())
			
			While (  !Bof() .And.;
				SA6->A6_COD+SA6->A6_AGENCIA+SA6->A6_NUMCON == ;
				SE8->E8_BANCO+SE8->E8_AGENCIA+SE8->E8_CONTA .And.;
				SE8->E8_DTSALAT == dDtSE8 )
				nRecSE8 := SE8->(RECNO())
				dbSkip(-1)
				lSldSE8 := .T.
			EndDo
			
			If ( lSldSE8 )
				If SE8->(Bof())
					dbGoTo(nRecSE8)
				Else
					dbSkip()
				Endif
			EndIf
		EndIf
		
		nValor := 0
		
		While ( !Eof() .And. ;
			SA6->A6_COD+SA6->A6_AGENCIA+SA6->A6_NUMCON == ;
			SE8->E8_BANCO+SE8->E8_AGENCIA+SE8->E8_CONTA .And.;
			SE8->E8_DTSALAT <= dDataBase)
			nValor += xMoeda(SE8->E8_SALATUA,If(cPaisLoc=="BRA",1,Max(SA6->A6_MOEDA,1)),mv_par02)
			dbSkip()
		Enddo
		
		If !(nValor == 0)
			
			If lFirst .And. mv_par06 = 1
				aDados1[DES_TOTAL] := "Disponibilidade imediata"
				HabiCel(.F.,1,oReport)
				oSection1:PrintLine()
				aFill(aDados1,nil)
				HabiCel(.T.,1,oReport)
				lFirst := .F.
				oReport:SkipLine()
			EndIf
			
			aDados1[EMP] := SM0->M0_CODIGO
			aDados1[FIL] := SA6->A6_FILIAL
			aDados1[BCO] := SA6->A6_COD
			aDados1[AGEN] := SA6->A6_AGENCIA
			aDados1[CONT] := SA6->A6_NUMCON
			aDados1[DESCRICAO] := SA6->A6_NREDUZ
			aDados1[DISPONIVEL] := nValor
			HabiCel(.T.,1,oReport)
			oSection1:PrintLine()
			aFill(aDados1,nil)
			lMovim	:= .T.
			
		Endif
		nDispon += (nValor)
		
		dbSelectArea("SA6")
		If !Empty(xFilial("SA6"))
			SA6->(MsSeek(IncLast(SA6->A6_COD+SA6->A6_AGENCIA+SA6->A6_NUMCON),.T.))
		Else
			dbGoTo(nRegSA6)
			SA6->(dbSkip())
		Endif
		
	EndDo
	
	If	lMovim .And. mv_par06 = 1
		oReport:SkipLine()
	EndIf
	
	lMovim		:= .F.
	cEmp_Ant	:= SM0->M0_CODIGO
	
	// Movimentacao bancaria
	RetIndex("SE5")
	dbSelectArea("SE5")
	SE5->(dbSetOrder(1))
	SE5->(dbClearFilter())
	
	// Contas Corrente
	RetIndex("SA6")
	dbSelectArea("SA6")
	SA6->(dbSetOrder(1))
	SA6->(dbClearFilter())
	
	// Saldos bancarios
	RetIndex("SE8")
	dbSelectArea("SE8")
	SE8->(dbSetOrder(1))
	SE8->(dbClearFilter())
	
	Ferase(cArqSE8+OrdBagExt())
	Ferase(cArqSA6+OrdBagExt())
	
	SM0->(dbSkip())
	
EndDo

If mv_par06 = 1
	aDados1[DES_TOTAL] := "Total Disponivel --->"
	aDados1[DISPONIVEL] := nDispon
	HabiCel(.F.,1,oReport)
	oSection1:PrintLine()
	aFill(aDados1,nil)
	HabiCel(.T.,1,oReport)
	oReport:SkipLine()
EndIf

oSection1:Finish()

aFill(aDados2,nil)
oSection2:Init()

dbSelectArea("SM0")
dbGotop()

While ! SM0->(Eof())
	
	If mv_par03 = 1 .And. SM0->(M0_CODIGO+M0_CODFIL) <> cEmp_Ini+cFil_Ini
		SM0->(dbSkip())
		Loop
	EndIf
	
	If mv_par03 = 2
		If SM0->M0_CODIGO = cEmp_Ant
			SM0->(dbSkip())
			Loop
		EndIf
		
		cEmp	:= SM0->M0_CODIGO
		cFil	:= SM0->M0_CODFIL
		dbCloseAll()
		cEmpAnt	:= cEmp
		cFilAnt := cFil
		cNumEmp := cEmp+cFil
		cModulo := "FIN"
		nModulo := 6
		OpenSM0(cEmpAnt+cFilAnt)
		OpenFile(cEmpAnt+cFilAnt)
	EndIf
	
	If mv_par04 == 1 .Or. mv_par05 == 1
		
		If Select(cAlias1) > 0
			DbSelectArea(cAlias1)
			(cAlias1)->(DbCloseArea())
		EndIf
		
		cQuery1 := " "
	 	If mv_par05 == 1
			cQuery1 += " SELECT C7_FILIAL, C7_FORNECE, A2_NOME, ED_PAI, A2_NATUREZ, ED_DESCRIC, C7_NUM, C7_CC, C7_COND, C7_DATPRF, C7_EMISSAO, "
			cQuery1 += " C7_MOEDA, SUM((C7_QUANT-C7_QUJE)*C7_PRECO) C7_TOTAL, '2' C7_TPMOV "
			cQuery1 += " FROM "+RetSqlName("SC7")
			cQuery1 += " LEFT JOIN "+RetSqlName("SA2")+" ON A2_COD = C7_FORNECE AND A2_LOJA = C7_LOJA AND "+RetSqlName("SA2")+".D_E_L_E_T_ = '' "
			cQuery1 += " LEFT JOIN "+RetSqlName("SED")+" ON A2_NATUREZ = ED_CODIGO AND "+RetSqlName("SED")+".D_E_L_E_T_ = '' "
			cQuery1 += " WHERE C7_FILIAL BETWEEN '' AND 'ZZ' AND C7_FLUXO = 'S' AND C7_ENCER <> 'E' AND "+RetSqlName("SC7")+".D_E_L_E_T_ = '' "
			cQuery1 += " GROUP BY C7_FILIAL, C7_FORNECE, A2_NOME, ED_PAI, A2_NATUREZ, ED_DESCRIC, C7_NUM, C7_CC, C7_COND, C7_DATPRF, C7_EMISSAO, C7_MOEDA "
		EndIf
		If mv_par04 == 1 .And. mv_par05 == 1
			cQuery1 += " UNION ALL "
		EndIf
        If mv_par04 == 1
			cQuery1 += " SELECT C6_FILIAL C7_FILIAL , C6_CLI C7_FORNECE, A1_NOME A2_NOME, ED_PAI, A1_NATUREZ A2_NATUREZ, ED_DESCRIC, C6_NUM C7_NUM, "
			cQuery1 += " C6_XCCUSTO C7_CC , C5_CONDPAG C7_COND, C6_ENTREG C7_DATPRF, C5_EMISSAO C7_EMISSAO, C5_MOEDA C7_MOEDA, "
			cQuery1 += " SUM((C6_QTDVEN-C6_QTDENT)*C6_PRCVEN) C7_TOTAL, '1' C7_TPMOV "
			cQuery1 += " FROM "+RetSqlName("SC6")
			cQuery1 += " LEFT JOIN "+RetSqlName("SC5")+" ON C5_FILIAL = C6_FILIAL AND C5_NUM = C6_NUM AND "+RetSqlName("SC5")+".D_E_L_E_T_ = '' "
			cQuery1 += " LEFT JOIN "+RetSqlName("SF4")+" ON F4_CODIGO = C6_TES AND "+RetSqlName("SF4")+".D_E_L_E_T_ = '' "
			cQuery1 += " LEFT JOIN "+RetSqlName("SA1")+" ON A1_COD = C6_CLI AND A1_LOJA = C6_LOJA AND "+RetSqlName("SA1")+".D_E_L_E_T_ = '' "
			cQuery1 += " LEFT JOIN "+RetSqlName("SED")+" ON ED_CODIGO = A1_NATUREZ AND "+RetSqlName("SED")+".D_E_L_E_T_ = '' "
			cQuery1 += " WHERE C6_FILIAL BETWEEN '' AND 'ZZ' AND (C6_QTDVEN-C6_QTDENT) > 0 AND F4_DUPLIC = 'S' AND "+RetSqlName("SC6")+".D_E_L_E_T_ = '' "
			cQuery1 += " GROUP BY C6_FILIAL, C6_CLI, A1_NOME, ED_PAI, C6_XCCUSTO, A1_NATUREZ, ED_DESCRIC, C6_NUM, C5_CONDPAG, C6_ENTREG, C5_EMISSAO, C5_MOEDA "
		EndIf
		
		cQuery1 := ChangeQuery(cQuery1)
		
		dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery1),cAlias1, .F., .T.)
		
		TCSetField(cAlias1, "C7_DATPRF",	"D", 08, 0 )
		TCSetField(cAlias1, "C7_EMISSAO",	"D", 08, 0 )
		TCSetField(cAlias1, "C7_TOTAL",		"N", TamSX3( "E2_VALOR" )[1], TamSX3( "E2_VALOR" )[2] )
		
		cArqTmp := CriaTrab(aCampos,.T.)
		dbUseArea(.T.,__LocalDriver,cArqTmp,"cArqTmp",.T.)
		IndRegua ( "cArqTmp",cArqTmp,"DTOS(TMP_DTVENC)",,,OemToAnsi("Selecionando Registros..."))
		
		dbSelectArea(cAlias1)
		(cAlias1)->(DbGoTop())
		While (cAlias1)->(!Eof())
			dDataIni := IIF((cAlias1)->C7_DATPRF < dDataBase,dDataBase,(cAlias1)->C7_DATPRF)
			aVenc := Condicao((cAlias1)->C7_TOTAL,(cAlias1)->C7_COND,0,dDataIni)
			For nX := 1 to Len(aVenc)
				dDataVenc			:= DataValida(aVenc[nX][1],.T.)
				nValor				:= xMoeda(aVenc[nX][2],If(cPaisLoc=="BRA",1,Max(SA6->A6_MOEDA,1)),mv_par02)
				
				RecLock("cArqTmp",.T.)
				cArqTmp->TMP_DTVENC	:= dDataVenc
				cArqTmp->TMP_FILIAL	:= (cAlias1)->C7_FILIAL
				cArqTmp->TMP_SUP	:= (cAlias1)->ED_PAI
				cArqTmp->TMP_NATURE	:= (cAlias1)->A2_NATUREZ
				cArqTmp->TMP_DESCNA	:= SubStr((cAlias1)->ED_DESCRIC,1,25)
				cArqTmp->TMP_TITUL 	:= (cAlias1)->C7_NUM
				cArqTmp->TMP_EMISSA	:= (cAlias1)->C7_EMISSAO
				cArqTmp->TMP_FORNEC	:= (cAlias1)->C7_FORNECE
				cArqTmp->TMP_NOMFOR := SubStr((cAlias1)->A2_NOME,1,25)
				cArqTmp->TMP_CUSTO	:= (cAlias1)->C7_CC
				cArqTmp->TMP_TPMOV	:= (cAlias1)->C7_TPMOV
				cArqTmp->TMP_VALOR	:= nValor
				
			Next
			(cAlias1)->(dbSkip())
		Enddo
	Endif
	
	For j := 1 To nDias
		
		oReport:IncMeter()
		
		dDataVenc := dDataBase+j-1
		
		If mv_par04 = 1 .Or. mv_par05 = 1
			dbSelectArea("cArqTmp")
			cArqTmp->(DbGoTop())
			While cArqTmp->(!Eof())
				If	cArqTmp->TMP_DTVENC != dDataVenc
					cArqTmp->(dbSkip())
					Loop
				EndIf
				
				aDados2[EMPRESA]	:= SM0->M0_CODIGO
				aDados2[FILIAL]		:= cArqTmp->TMP_FILIAL
				aDados2[DT_VENC]	:= cArqTmp->TMP_DTVENC
				aDados2[SUPERIOR]	:= cArqTmp->TMP_SUP
				aDados2[NATUREZ]	:= cArqTmp->TMP_NATURE
				aDados2[DESCNAT]	:= cArqTmp->TMP_DESCNA
				aDados2[TITUL]		:= cArqTmp->TMP_TITUL
				aDados2[EMISSAO]	:= cArqTmp->TMP_EMISSA
				aDados2[CUSTO]		:= cArqTmp->TMP_CUSTO
				aDados2[FORNEC]		:= cArqTmp->TMP_FORNEC
				aDados2[NOM_FORNEC] := cArqTmp->TMP_NOMFOR
				
				If cArqTmp->TMP_TPMOV = '1'
					nMulti 		  	:= 1
					nTotTitR 		+= cArqTmp->TMP_VALOR
					cTpMov			:= "E"
					cOrigem			:= "PV"
				Else
					nMulti 			:= -1
					nTotTitP 		+= cArqTmp->TMP_VALOR
					cTpMov			:= "S"
					cOrigem			:= "PC"
				EndIf
				
				nDispon				+= cArqTmp->TMP_VALOR*nMulti
				
				aDados2[ORIGEM]		:= cOrigem
				aDados2[MOVIMENTO]	:= cTpMov
				aDados2[VL_VAL]		:= cArqTmp->TMP_VALOR*nMulti
				aDados2[VL_DIS] 	:= nDispon
				
				HabiCel(.T.,2,oReport)
				oSection2:PrintLine()
				aFill(aDados2,nil)
				
				cArqTmp->(dbSkip())
				
			EndDo
		EndIf
		
		If Select(cAlias) > 0
			DbSelectArea(cAlias)
			(cAlias)->(DbCloseArea())
		EndIf
		
		cQuery := " SELECT  "
		cQuery += " CASE WHEN E2_FILIAL = '' THEN E2_FILORIG ELSE E2_FILIAL END E2_FILIAL, "
		cQuery += " '' E2_BANCO, '' E2_AGENCIA, '' E2_CONTA, E2_HIST, "
		cQuery += " E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO, ED_PAI, E2_NATUREZ, ED_DESCRIC, E2_FORNECE, E2_NOMFOR, E2_EMISSAO, E2_BAIXA, E2_VENCREA, "
		cQuery += " CASE WHEN E2_CCD = '' THEN E2_CCC ELSE E2_CCD END E2_CC, E2_MOEDA, E2_VALOR, E2_SALDO, "
		cQuery += " CASE WHEN E2_TIPO IN ('NDF','PA') THEN '1' ELSE '2' END E2_TPMOV ,'CP' E2_ORIGEM "
		cQuery += " FROM "+RetSqlName("SE2")
		cQuery += " LEFT JOIN "+RetSqlName("SED")+" ON ED_CODIGO = E2_NATUREZ AND "+RetSqlName("SED")+".D_E_L_E_T_ = '' "
		cQuery += " WHERE E2_FILIAL BETWEEN '  ' AND 'ZZ' AND E2_VENCREA = '"+Dtos(dDataVenc)+"' AND E2_SALDO > 0 AND "+RetSqlName("SE2")+".D_E_L_E_T_ = '' "
		If mv_par07 <> 1
			cQuery += " AND E2_TIPO <> 'PA' "
		EndIf
		cQuery += " UNION ALL "
		cQuery += " SELECT "
		cQuery += " CASE WHEN E1_FILIAL = '' THEN E1_FILORIG ELSE E1_FILIAL END E1_FILIAL, "
		cQuery += " '' E1_BANCO, '' E1_AGENCIA, '' E1_CONTA, E1_HIST, "		
		cQuery += " E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO,  ED_PAI, E1_NATUREZ, ED_DESCRIC, E1_CLIENTE, E1_NOMCLI, E1_EMISSAO, E1_BAIXA, E1_VENCREA, "
		cQuery += " CASE WHEN E1_CCD = '' THEN E1_CCC ELSE E1_CCD END E1_CC, E1_MOEDA, E1_VALOR, E1_SALDO, "
		cQuery += " CASE WHEN E1_TIPO IN ('NDC','RA') THEN '2' ELSE '1' END E2_TPMOV, 'CR' E1_ORIGEM "
		cQuery += " FROM "+RetSqlName("SE1")
		cQuery += " LEFT JOIN "+RetSqlName("SED")+" ON ED_CODIGO = E1_NATUREZ AND "+RetSqlName("SED")+".D_E_L_E_T_ = '' "
		cQuery += " WHERE E1_FILIAL BETWEEN '  ' AND 'ZZ' AND E1_VENCREA = '"+Dtos(dDataVenc)+"' AND E1_SALDO > 0 AND "+RetSqlName("SE1")+".D_E_L_E_T_ = '' "
		If mv_par07 <> 1
			cQuery += " AND E1_TIPO <> 'RA' "
		EndIf
		cQuery += " UNION ALL "
		cQuery += " SELECT "
		cQuery += " CASE WHEN E2_FILIAL = '' THEN E2_FILORIG ELSE E2_FILIAL END E2_FILIAL, "
		cQuery += " E5_BANCO, E5_AGENCIA, E5_CONTA, E5_HISTOR, "
		cQuery += " E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO, ED_PAI, E2_NATUREZ, ED_DESCRIC, E2_FORNECE, E2_NOMFOR, E2_EMISSAO, E5_DATA, E5_DATA, "
		cQuery += " CASE WHEN E2_CCD = '' THEN E2_CCC ELSE E2_CCD END E2_CC, E2_MOEDA, E2_VALOR, E5_VALOR, "
		cQuery += " CASE WHEN E5_RECPAG = 'R' THEN '1' ELSE '2' END E2_TPMOV, 'MB' E2_ORIGEM "
		cQuery += " FROM "+RetSqlName("SE5")
		cQuery += " LEFT JOIN "+RetSqlName("SE2")+" ON E5_PREFIXO = E2_PREFIXO AND E5_NUMERO = E2_NUM AND E5_PARCELA = E2_PARCELA AND "
		cQuery += " E5_TIPO = E2_TIPO AND E5_CLIFOR = E2_FORNECE AND E5_LOJA = E2_LOJA AND "+RetSqlName("SE2")+".D_E_L_E_T_ = '' "
		cQuery += " LEFT JOIN "+RetSqlName("SED")+" ON ED_CODIGO = E2_NATUREZ AND "+RetSqlName("SED")+".D_E_L_E_T_ = '' "
		cQuery += " WHERE E5_FILIAL BETWEEN '  ' AND 'ZZ' AND E5_DATA = '"+Dtos(dDataVenc)+"' AND E5_BANCO <> '' AND "
		cQuery += " E5_NUMERO <> '' AND E5_FORNECE <> '' AND "+RetSqlName("SE5")+".D_E_L_E_T_ = '' "
		cQuery += " UNION ALL "
		cQuery += " SELECT "
		cQuery += " CASE WHEN E1_FILIAL = '' THEN E1_FILORIG ELSE E1_FILIAL END E1_FILIAL, "
		cQuery += " E5_BANCO, E5_AGENCIA, E5_CONTA, E5_HISTOR, "
		cQuery += " E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO,  ED_PAI, E1_NATUREZ, ED_DESCRIC, E1_CLIENTE, E1_NOMCLI, E1_EMISSAO,  E5_DATA, E5_DATA, "
		cQuery += " CASE WHEN E1_CCD = '' THEN E1_CCC ELSE E1_CCD END E1_CC, E1_MOEDA, E1_VALOR, E5_VALOR, "
		cQuery += " CASE WHEN E5_RECPAG = 'R' THEN '1' ELSE '2' END E2_TPMOV, 'MB' E1_ORIGEM "
		cQuery += " FROM "+RetSqlName("SE5")
		cQuery += " LEFT JOIN "+RetSqlName("SE1")+" ON E5_PREFIXO = E1_PREFIXO AND E5_NUMERO = E1_NUM AND E5_PARCELA = E1_PARCELA AND "
		cQuery += " E5_TIPO = E1_TIPO AND E5_CLIFOR = E1_CLIENTE AND E5_LOJA = E1_LOJA AND "+RetSqlName("SE1")+".D_E_L_E_T_ = '' "
		cQuery += " LEFT JOIN "+RetSqlName("SED")+" ON ED_CODIGO = E1_NATUREZ AND "+RetSqlName("SED")+".D_E_L_E_T_ = '' "
		cQuery += " WHERE E5_FILIAL BETWEEN '  ' AND 'ZZ' AND E5_DATA = '"+Dtos(dDataVenc)+"' AND E5_BANCO <> '' AND "
		cQuery += " E5_NUMERO <> '' AND E5_CLIENTE <> '' AND "+RetSqlName("SE5")+".D_E_L_E_T_ = '' "
		cQuery += " UNION ALL "
		cQuery += " SELECT "
		cQuery += " CASE WHEN E5_FILIAL = '' THEN E5_FILORIG ELSE E5_FILIAL END E5_FILIAL, "
		cQuery += " E5_BANCO, E5_AGENCIA, E5_CONTA, E5_HISTOR, "
		cQuery += " E5_PREFIXO, E5_NUMERO, E5_PARCELA, E5_TIPO,  ED_PAI, E5_NATUREZ, ED_DESCRIC, E5_CLIENTE, E5_BENEF, E5_DATA,  E5_DATA, E5_DATA, "
		cQuery += " CASE WHEN E5_CCD = '' THEN E5_CCC ELSE E5_CCD END E5_CC, "
		cQuery += " CASE WHEN SUBSTRING(E5_MOEDA,2,1) IN ('1','2','3','4','5') THEN TO_NUMBER(SUBSTRING(E5_MOEDA,2,1)) ELSE 0 END E5_MOEDA, "
		cQuery += " E5_VALOR, E5_VALOR,  CASE WHEN E5_RECPAG = 'R' THEN '1' ELSE '2' END E2_TPMOV, 'MB' E5_ORIGEM "
		cQuery += " FROM "+RetSqlName("SE5")
		cQuery += " LEFT JOIN "+RetSqlName("SED")+" ON ED_CODIGO = E5_NATUREZ AND "+RetSqlName("SED")+".D_E_L_E_T_ = '' "
		cQuery += " WHERE E5_FILIAL BETWEEN '  ' AND 'ZZ' AND E5_DATA = '"+Dtos(dDataVenc)+"' AND E5_BANCO <> '' AND "
		cQuery += " E5_NUMERO = '' AND "+RetSqlName("SE5")+".D_E_L_E_T_ = '' "
		
		cQuery := ChangeQuery(cQuery)
		
		dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),cAlias, .F., .T.)
		
		TCSetField(cAlias, "E2_BAIXA",		"D", 08, 0 )
		TCSetField(cAlias, "E2_EMISSAO",	"D", 08, 0 )
		TCSetField(cAlias, "E2_VENCREA",	"D", 08, 0 )
		TCSetField(cAlias, "ED_PAI",		"C", TamSX3("E2_NATUREZ")[1], 0 )
		TCSetField(cAlias, "E2_SALDO",		"N", TamSX3( "E2_VALOR" )[1], TamSX3( "E2_VALOR" )[2] )
		
		dbSelectArea(cAlias)
		(cAlias)->(DbGoTop())
		
		While !(cAlias)->(Eof())
			
			aDados2[EMPRESA]	:= SM0->M0_CODIGO
			aDados2[FILIAL]		:= (cAlias)->E2_FILIAL
			aDados2[BANCO]		:= (cAlias)->E2_BANCO
			aDados2[AGENCIA]	:= (cAlias)->E2_AGENCIA
			aDados2[CONTA]		:= (cAlias)->E2_CONTA
			aDados2[HIST]		:= (cAlias)->E2_HIST
			aDados2[DT_VENC]	:= (cAlias)->E2_VENCREA
			aDados2[SUPERIOR]	:= (cAlias)->ED_PAI
			aDados2[NATUREZ]	:= (cAlias)->E2_NATUREZ
			aDados2[DESCNAT]	:= SubStr((cAlias)->ED_DESCRIC,1,25)
			aDados2[PREFIXO]	:= (cAlias)->E2_PREFIXO
			aDados2[TITUL]		:= (cAlias)->E2_NUM+(If(!EMPTY((cAlias)->E2_PARCELA),"-",""))+(cAlias)->E2_PARCELA
			aDados2[TIPO]		:= (cAlias)->E2_TIPO
			aDados2[EMISSAO]	:= (cAlias)->E2_EMISSAO
			aDados2[BAIXA]		:= (cAlias)->E2_BAIXA
			aDados2[CUSTO]		:= (cAlias)->E2_CC
			aDados2[FORNEC]		:= (cAlias)->E2_FORNECE
			aDados2[NOM_FORNEC] := SubStr((cAlias)->E2_NOMFOR,1,25)
			aDados2[ORIGEM]		:= (cAlias)->E2_ORIGEM
			
			If (cAlias)->E2_TPMOV = '1'
				nMulti 		  	:= 1
				nTotTitR 		+= (cAlias)->E2_SALDO
				cTpMov			:= "E"
			Else
				nMulti 			:= -1
				nTotTitP 		+= (cAlias)->E2_SALDO
				cTpMov			:= "S"
			EndIf
			
			nDispon				+= (cAlias)->E2_SALDO*nMulti
			
			aDados2[MOVIMENTO]	:= cTpMov
			aDados2[VL_VAL]		:= (cAlias)->E2_SALDO*nMulti
			aDados2[VL_DIS] 	:= nDispon
			
			HabiCel(.T.,2,oReport)
			oSection2:PrintLine()
			aFill(aDados2,nil)
			
			(cAlias)->(dbSkip())
			
		EndDo
		
		(cAlias)->(DbCLoseArea())
		
		If nTotTitR !=0 .or. nTotTitP != 0
			aDados2[DESC_TOTAL] := "Total Do Dia ---> " + DtoC(dDataVenc)  //"Total Do Dia ---> "
			aDados2[VL_VAL] := ntotTitR-nTotTitP
			aDados2[VL_DIS] := nDispon
			
			If mv_par06 = 1
				oReport:SkipLine()
				HabiCel(.F.,2,oReport)
				oSection2:PrintLine()
				aFill(aDados2,nil)
				HabiCel(.T.,2,oReport)
				oReport:SkipLine()
			EndIf
			
			nTotGTitR += nTotTitR
			nTotGTitP += nTotTitP
			nTotETitR += nTotTitR
			nTotETitP += nTotTitP
			
			nTotTitP := 0
			nTotTitR := 0
		Endif
		
	Next j
	
	If nTotETitR != 0 .Or. nTotETitP != 0
		aDados2[DESC_TOTAL] := "Total Da Empresa ---> " + SM0->M0_CODIGO
		aDados2[VL_VAL] := nTotETitR-nTotETitP
		aDados2[VL_DIS] := nDispon
		
		If mv_par06 = 1
			HabiCel(.F.,2,oReport)
			oSection2:PrintLine()
			aFill(aDados2,nil)
			HabiCel(.T.,2,oReport)
			oReport:SkipLine()
		EndIf
	EndIf
	
	nTotETitR	:= 0
	nTotETitP	:= 0
	
	cEmp_Ant	:= SM0->M0_CODIGO
	
	If mv_par04 = 1 .Or. mv_par05 = 1
		(cAlias1)->(DbCLoseArea())
		dbSelectarea("cArqTmp")
		cArqTmp->(dbCloseArea())
		FErase(cArqTmp+OrdBagExt())
		FErase(cArqTmp+GetDBExtension())
	EndIf
	
	SM0->(dbSkip())
	
EndDo

aDados2[DESC_TOTAL] := "Total Geral  --->"  //"Total Geral  --->"
aDados2[VL_VAL] := nTotGTitR-nTotGTitP
aDados2[VL_DIS] := nDispon

If mv_par06 = 1
	oReport:SkipLine()
	HabiCel(.F.,2,oReport)
	oSection2:PrintLine()
	aFill(aDados2,nil)
	HabiCel(.T.,2,oReport)
EndIf

If mv_par03 = 2
	dbCloseAll()
	cEmpAnt	:= cEmp_Ini
	cFilAnt := cFil_Ini
	cNumEmp := cEmp_Ini+cFil_Ini
	cModulo := "FIN"
	nModulo := 6
	OpenSM0(cEmpAnt+cFilAnt)
	OpenFile(cEmpAnt+cFilAnt)
EndIf

oSection2:Finish()

cNumMoeda := " "

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³HabiCel	³ Autor ³ Microsiga				³ Data ³ 12/05/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³habilita ou desabilita celulas para imprimir totais		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ HabiCel()	 											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ lHabilit->.T. para habilitar e .F. para desabilitar		  ³±±
±±³			 ³ oReport ->objeto TReport que possui as celulas 			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC Function HabiCel(lHabilit,nSec,oReport)

Local oSection1 := oReport:Section(1)
Local oSection2 := oReport:Section(2)

If nSec = 2
	If lHabilit
		oSection2:Cell("TOTAL"):Disable()
		oSection2:Cell("EMPRESA"):Enable()
		oSection2:Cell("FILIAL"):Enable()
		oSection2:Cell("BANCO"):Enable()
		oSection2:Cell("AGENCIA"):Enable()
		oSection2:Cell("CONTA"):Enable()
		oSection2:Cell("E2_VENCREA"):Enable()
		oSection2:Cell("SUPERIOR"):Enable()
		oSection2:Cell("E2_NATUREZ"):Enable()
		oSection2:Cell("DESCNAT"):Enable()
		oSection2:Cell("E2_PREFIXO"):Enable()
		oSection2:Cell("TITULO"):Enable()
		oSection2:Cell("E2_TIPO"):Enable()
		oSection2:Cell("E2_EMISSAO"):Enable()
		oSection2:Cell("E2_BAIXA"):Enable()
		oSection2:Cell("CUSTO"):Enable()
		oSection2:Cell("E2_FORNECEDOR"):Enable()
		oSection2:Cell("E2_NOMFOR"):Enable()
		oSection2:Cell("ORIGEM"):Enable()
		oSection2:Cell("MOVIMENTO"):Enable()
		oSection2:Cell("HIST"):Enable()
		oSection2:Cell("VL_VALOR"):Enable()
		oSection2:Cell("VL_DISPO"):Enable()
	Else
		oSection2:Cell("TOTAL"):Enable()
		oSection2:Cell("EMPRESA"):Disable()
		oSection2:Cell("FILIAL"):Disable()
		oSection2:Cell("BANCO"):Disable()
		oSection2:Cell("AGENCIA"):Disable()
		oSection2:Cell("CONTA"):Disable()
		oSection2:Cell("E2_VENCREA"):Disable()
		oSection2:Cell("SUPERIOR"):Disable()
		oSection2:Cell("E2_NATUREZ"):Disable()
		oSection2:Cell("DESCNAT"):Disable()
		oSection2:Cell("E2_PREFIXO"):Disable()
		oSection2:Cell("TITULO"):Disable()
		oSection2:Cell("E2_TIPO"):Disable()
		oSection2:Cell("E2_EMISSAO"):Disable()
		oSection2:Cell("E2_BAIXA"):Disable()
		oSection2:Cell("CUSTO"):Disable()
		oSection2:Cell("E2_FORNECEDOR"):Disable()
		oSection2:Cell("E2_NOMFOR"):Disable()
		oSection2:Cell("ORIGEM"):Disable()
		oSection2:Cell("MOVIMENTO"):Disable()
		oSection2:Cell("HIST"):Disable()
		oSection2:Cell("VL_VALOR"):Enable()
		oSection2:Cell("VL_DISPO"):Enable()
	EndIf
Else
	If lHabilit
		oSection1:Cell("TOTAL"):Disable()
		oSection1:Cell("EMPRESA"):Enable()
		oSection1:Cell("FILIAL"):Enable()
		oSection1:Cell("BANCO"):Enable()
		oSection1:Cell("AGENCIA"):Enable()
		oSection1:Cell("CONTA"):Enable()
		oSection1:Cell("DESCRIC"):Enable()
		oSection1:Cell("VL_DISPO"):Enable()
	Else
		oSection1:Cell("TOTAL"):Enable()
		oSection1:Cell("EMPRESA"):Disable()
		oSection1:Cell("FILIAL"):Disable()
		oSection1:Cell("BANCO"):Disable()
		oSection1:Cell("AGENCIA"):Disable()
		oSection1:Cell("CONTA"):Disable()
		oSection1:Cell("DESCRIC"):Disable()
		oSection1:Cell("VL_DISPO"):Enable()
	EndIf
EndIf

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ListaES    ³ Autor ³ Andrea Verissimo      ³ Data ³17/12/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄ--ÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³Essa funcao checa se o registro tem algum movimento bancario ³±±
±±³          ³do tipo ES.                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.F. - em caso de nao listar o titulo pq ele tem ESTORNO.     ³±±
±±³          ³.T. - listar o titulo pq nao tenho ESTORNO.                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nro da Filial, Prefixo, Numero, Parcela                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ-ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ListaES(cChavES)
Local cRetorno := .T.
Local aArea    := GetArea()
dbSelectArea("SE5")
SE5->(dbSetOrder(7))
SE5->(Dbseek(cChavES,.t.))
While !EOF() .and. (xFilial("SE5")+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA) = cChavES
	If SE5->E5_TIPODOC = "ES"
		cRetorno := .F.
		Exit
	Endif
	SE5->(Dbskip())
Enddo
dbCloseArea()
RestArea(aArea)
Return (cRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³Ajusta    ³ Autor ³ Márcio Menon	 		  ³ Data ³ 11/12/2006		³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Insere novas perguntas na tabela SX1 a Ajusta o Picture dos valores	³±±
±±³          ³ no SX3                                                           	³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ 																		³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Ajusta()

Local aPergs 	:= {}

Aadd(aPergs,{"Numero de Dias ?              ","¿Numero de Dias ?             ","Days Number ?                 ","mv_ch1","N",3,0,0,"G",""                    ,"mv_par01","               ","               ","               ","","","               ","               ","               ","","","","","","","","","","","","","","","","","","S","",""})
Aadd(aPergs,{"Moeda ?             	        ","¿Moneda ?              	     ","Currency ?              	  ","mv_ch2","N",1,0,0,"G",""                    ,"mv_par02","Moeda 1        ","Moneda 1       ","Currency 1     ","","","Moeda 2        ","Moneda 2       ","Currency 2     ","","","Moeda 3        ","Moneda 3       ","Currency 3     ","","","Moeda 4        ","Moneda 4       ","Currency 4     ","","","Moeda 5        ","Moneda 5       ","Currency 5     ","","","","",""})
Aadd(aPergs,{"Empresa Atual ?      	        ","¿Empresa Actual ?             ","Current Company ?       	  ","mv_ch3","N",1,0,2,"C",""                    ,"mv_par03","Empresa Atual  ","Empresa Actual ","Current Company","","","Todas Empresas ","Todas Empresas ","All Company    ","","","","","","","","","","","","","","","","","","S","",""})
Aadd(aPergs,{"Considera P. Venda ?          ","¿Considera P Venta ?          ","Consider Sales Order ?        ","mv_ch4","N",1,0,2,"C",""                    ,"mv_par04","Sim            ","Si             ","Yes            ","","","Nao            ","No             ","No             ","","","","","","","","","","","","","","","","","","S","",""})
Aadd(aPergs,{"Considera P. Compra ?         ","¿Considera P Compra ?         ","Consider Purchase Order ?     ","mv_ch5","N",1,0,2,"C",""                    ,"mv_par05","Sim            ","Si             ","Yes            ","","","Nao            ","No             ","No             ","","","","","","","","","","","","","","","","","","S","",""})
Aadd(aPergs,{"Imprime Totais ?              ","¿Imprime Totales ?            ","Prints Total ?                ","mv_ch6","N",1,0,2,"C",""                    ,"mv_par06","Sim            ","Si             ","Yes            ","","","Nao            ","No             ","No             ","","","","","","","","","","","","","","","","","","S","",""})
Aadd(aPergs,{"Considera PA/RA ?             ","¿Considera PA/RA ?            ","Consider PA/RA ?              ","mv_ch7","N",1,0,2,"C",""                    ,"mv_par07","Sim            ","Si             ","Yes            ","","","Nao            ","No             ","No             ","","","","","","","","","","","","","","","","","","S","",""})

AjustaSx1("RFCXFI",aPergs)

Return
