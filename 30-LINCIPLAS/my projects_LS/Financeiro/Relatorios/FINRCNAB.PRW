#INCLUDE "finr650.CH"
#Include "RWMAKE.CH"

//эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
//╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
//╠╠зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд©╠╠
//╠╠ЁFuncao    Ё FinR650  Ё Autor Ё                       Ё Data Ё 17/06/94 Ё╠╠
//╠╠цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд╢╠╠
//╠╠ЁDescricao Ё Impressao do Retorno da Comunicacao Bancaria               Ё╠╠
//╠╠цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
//╠╠ЁSintaxe   Ё FinR650()                                                  Ё╠╠
//╠╠цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
//╠╠Ё Uso      Ё Generico                                                   Ё╠╠
//╠╠юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды╠╠
//╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
//ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ

// Customizacao do Relatorio de Retorno CNAB para atender necessidade do Depto. Financeiro (Ct. Receber)
// paraque o sistema nЦo "baixe" titulos com saldo inferior ao valor recebido.
// Wagner Cherubelli - 08/09/2003

User Function FinRCnab()
Local wnrel
Local cString
Local lOk := .t.
Local cDesc1  := STR0001  //"Este programa tem como objetivo imprimir o arquivo"
Local cDesc2  := STR0002  //"Retorno da Comunicacao Bancaria, conforme layout, "
Local cDesc3  := STR0003  //"previamente configurado."
LOCAL tamanho := "G"

//здддддддддддддддддд©
//Ё Define Variaveis Ё
//юдддддддддддддддддды
PRIVATE Titulo := OemToAnsi(STR0004)  //"Impressao do Retorno da Comunicacao Bancaria"
PRIVATE cabec1
PRIVATE cabec2
PRIVATE aReturn  := { OemToAnsi(STR0005), 1,OemToAnsi(STR0006), 2, 2, 1, "",1 }  //"Zebrado"###"Administracao"
PRIVATE cPerg    := Padr("FIN650",len(SX1->X1_GRUPO)," ")   , nLastKey := 0
PRIVATE nomeprog := "FinrCnab"

//здддддддддддддддддддддддддддддддддддд©
//Ё Verifica as perguntas selecionadas Ё
//юдддддддддддддддддддддддддддддддддддды
pergunte(cPerg,.F.)
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Variaveis utilizadas para parametros                         Ё
//Ё mv_par01            // Arquivo de Entrada                    Ё
//Ё mv_par02            // Arquivo de Configuracao               Ё
//Ё mv_par03            // Codigo do Banco                       Ё
//Ё mv_par04            // Codigo Agencia		        	     Ё
//Ё mv_par05            // Codigo Conta			                 Ё
//Ё mv_par06            // Codigo SubConta			             Ё
//Ё mv_par07            // Receber / Pagar                       Ё
//Ё mv_par08            // Modelo Cnab / Cnab2		             Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

If mv_par07 == 1
	cString := "SE1"
Else
	cString := "SE2"
EndIf

//зддддддддддддддддддддддддддддддддддддддд©
//Ё Envia controle para a funcao SETPRINT Ё
//юддддддддддддддддддддддддддддддддддддддды
wnrel := "FINRCNAB"            //Nome Default do relatorio em Disco
aOrd  := {OemToAnsi(STR0007),OemToAnsi(STR0008),OemToAnsi(STR0009),; 			//"Por Numero"###"Por Natureza"###"Por Vencimento"
OemToAnsi(STR0010),OemToAnsi(STR0011),OemToAnsi(STR0012),OemToAnsi(STR0013)}  //"Por Banco"###"Fornecedor"###"Por Emissao"###"Por Cod.Fornec."
wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",,Tamanho)

If nLastKey == 27
	Return
End

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif


RptStatus({|lEnd| U_Fa650Imp12(@lEnd,wnRel,cString)},Titulo)
Return

//эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
//╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
//╠╠зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд©╠╠
//╠╠ЁFuncao    Ё FA650Imp Ё Autor Ё                       Ё Data Ё 20/06/94 Ё╠╠
//╠╠цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд╢╠╠
//╠╠ЁDescricao Ё Impressao da Comunicacao Bancaria - Retorno                Ё╠╠
//╠╠цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
//╠╠ЁSintaxe   Ё FA650Imp()                                                 Ё╠╠
//╠╠цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
//╠╠Ё Uso      Ё FINR650                                                    Ё╠╠
//╠╠юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды╠╠
//╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
//ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ

User Function FA650Imp12(lEnd,wnRel,cString)

Local cPosPrin,cPosJuro,cPosMult,cPosCC ,cPosTipo
Local cPosNum ,cPosData,cPosDesp,cPosDesc,cPosAbat,cPosDtCC,cPosIof,cPosOcor
Local cPosNosso, cPosForne
Local lPosNum  := .f. , lPosData := .f. , lPosAbat := .f.
Local lPosDesp := .f. , lPosDesc := .f. , lPosMult := .f.
Local lPosPrin := .f. , lPosJuro := .f. , lPosDtCC := .f.
Local lPosOcor := .f. , lPosTipo := .f. , lPosIof  := .f.
Local lPosCC   := .f. , lPosNosso:= .f. , lPosRej	:= .f.
Local lPosForne:=.f.
Local nLidos ,nLenNum  ,nLenData ,nLenDesp ,nLenDesc ,nLenAbat ,nLenDtCC
Local nLenPrin ,nLenJuro ,nLenMult ,nLenOcor ,nLenTipo ,nLenIof  ,nLenCC, lLenNosso
Local nLenRej := 0
Local cArqConf ,cArqEnt  ,xBuffer  ,nTipo
Local tamanho   := "G", lOcorr := .F.
Local cDescr,cNumTit,cEspecie,dBaixa,dCred,cData,nTamArq,cNossoNum,cOcorr,cForne
Local nJuros	:= 0
Local nMulta	:= 0
Local nValIof	:= 0
Local nValCc	:= 0
Local nDespes	:= 0
Local nDescont	:= 0
Local nAbatim	:= 0
Local nValrec	:= 0
Local nDespT:=nDescT:=nAbatT:=nValT:=nJurT:=nMulT:=nIOFT:=nCCT:=0
Local nHdlBco  := 0
Local nHdlConf := 0
Local cTabela 	:= "17"
Local aTabRej := {}
Local lRej := .f.
Local cCarteira
Local nTamDet
Local lHeader := .f.
Local lTrailler:= .F.
Local aTabela 	:= {}
Local cChave650
Local nPos := 0
Local lAchouTit := .F.
Local nValPadrao := 0
Local aValores := {}
LOCAL lF650Var := ExistBlock("F650VAR" )

PRIVATE m_pag , cbtxt , cbcont , li

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Variaveis utilizadas para Impressao do Cabecalho e Rodape    Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
cbtxt    := SPACE(10)
cbcont   := 0
li       := 80
m_pag    := 1

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Definicao dos cabecalhos                                     Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
If mv_par07 == 1
	cabec1  := OemToAnsi(STR0014)  //"no.Titulo  Esp Ocorrencia  Dt.Ocor.   Desp. Cobr  Vlr Desconto  Vlr Abatimento   Vlr Principal     Vlr Juros    Vlr Multa      Vlr IOF   Out Creditos  Dt.Cred. Nro Titulo Bco   Consistencia"
Else
	cabec1  := OemToAnsi(STR0024)  //"No.Titulo  Esp Ocorrencia  Dt.Ocor.   Desp. Cobr  Vlr Desconto  Vlr Abatimento   Vlr Principal     Vlr Juros    Vlr Multa      Nro Titulo Bco   Consistencia"
EndIf
cabec2  := ""
nTipo:=Iif(aReturn[4]==1,GetMv("MV_COMP"),GetMv("MV_NORM"))

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Busca tamanho do detalhe na configuracao do banco            Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
dbSelectArea("SEE")
If dbSeek(xFilial("SEE")+mv_par03+mv_par04+mv_par05+mv_par06)
	nTamDet:= Iif(Empty (SEE->EE_NRBYTES), 400, SEE->EE_NRBYTES)
	ntamDet+= 2  // Ajusta tamanho do detalhe para leitura do CR (fim de linha)
Else
	Set Device To Screen
	Set Printer To
	Help(" ",1,"NOBCOCAD")
	Return .F.
Endif

cTabela := Iif( Empty(SEE->EE_TABELA), "17" , SEE->EE_TABELA )

dbSelectArea( "SX5" )
If !SX5->( dbSeek( cFilial + cTabela ) )
	Help(" ",1,"PAR150")
	Return .F.
Endif
While !SX5->(Eof()) .and. SX5->X5_TABELA == cTabela
	AADD(aTabela,{Alltrim(X5Descri()),Pad(SX5->X5_CHAVE,Len(IIF(mv_par07==1,SE1->E1_TIPO,SE2->E2_TIPO)))})  // correcao da tabela de titulos (Pequim 18/08/00)
	SX5->(dbSkip( ))
Enddo

IF mv_par08 == 1
	//здддддддддддддддддддддддддддддд©
	//Ё Abre arquivo de configuracao Ё
	//юдддддддддддддддддддддддддддддды
	cArqConf:=mv_par02
	IF !FILE(cArqConf)
		Set Device To Screen
		Set Printer To
		Help(" ",1,"NOARQPAR")
		Return .F.
	Else
		nHdlConf:=FOPEN(cArqConf,0+64)
	End
	
	//здддддддддддддддддддддддддддд©
	//Ё Le arquivo de configuracao Ё
	//юдддддддддддддддддддддддддддды
	nLidos :=0
	FSEEK(nHdlConf,0,0)
	nTamArq:=FSEEK(nHdlConf,0,2)
	FSEEK(nHdlConf,0,0)
	
	While nLidos <= nTamArq
		
		//зддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Verifica o tipo de qual registro foi lido Ё
		//юддддддддддддддддддддддддддддддддддддддддддды
		xBuffer:=Space(85)
		FREAD(nHdlConf,@xBuffer,85)
		
		IF SubStr(xBuffer,1,1) == CHR(1)
			nLidos+=85
			Loop
		EndIF
		IF !lPosNum
			cPosNum:=Substr(xBuffer,17,10)
			nLenNum:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosNum:=.t.
			nLidos+=85
			Loop
		EndIF
		IF !lPosData
			cPosData:=Substr(xBuffer,17,10)
			nLenData:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosData:=.t.
			nLidos+=85
			Loop
		EndIF
		IF !lPosDesp
			cPosDesp:=Substr(xBuffer,17,10)
			nLenDesp:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosDesp:=.t.
			nLidos+=85
			Loop
		EndIF
		IF !lPosDesc
			cPosDesc:=Substr(xBuffer,17,10)
			nLenDesc:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosDesc:=.t.
			nLidos+=85
			Loop
		EndIF
		IF !lPosAbat
			cPosAbat:=Substr(xBuffer,17,10)
			nLenAbat:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosAbat:=.t.
			nLidos+=85
			Loop
		EndIF
		IF !lPosPrin
			cPosPrin:=Substr(xBuffer,17,10)
			nLenPrin:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosPrin:=.t.
			nLidos+=85
			Loop
		EndIF
		IF !lPosJuro
			cPosJuro:=Substr(xBuffer,17,10)
			nLenJuro:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosJuro:=.t.
			nLidos+=85
			Loop
		EndIF
		IF !lPosMult
			cPosMult:=Substr(xBuffer,17,10)
			nLenMult:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosMult:=.t.
			nLidos+=85
			Loop
		EndIF
		IF !lPosOcor
			cPosOcor:=Substr(xBuffer,17,10)
			nLenOcor:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosOcor:=.t.
			nLidos+=85
			Loop
		EndIF
		IF !lPosTipo
			cPosTipo:=Substr(xBuffer,17,10)
			nLenTipo:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosTipo:=.t.
			nLidos+=85
			Loop
		EndIF
		
		If mv_par07 == 1						// Somente cart receber deve ler estes campos
			IF !lPosIof
				cPosIof:=Substr(xBuffer,17,10)
				nLenIof:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
				lPosIof:=.t.
				nLidos+=85
				Loop
			EndIF
			IF !lPosCC
				cPosCC:=Substr(xBuffer,17,10)
				nLenCC:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
				lPosCC:=.t.
				nLidos+=85
				Loop
			EndIF
			IF !lPosDtCc
				cPosDtCc:=Substr(xBuffer,17,10)
				nLenDtCc:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
				lPosDtCc:=.t.
				nLidos+=85
				Loop
			EndIF
		EndIf
		
		IF !lPosNosso
			cPosNosso:=Substr(xBuffer,17,10)
			nLenNosso:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosNosso:=.t.
			nLidos+=85
			Loop
		EndIF
		IF !lPosRej
			cPosRej:=Substr(xBuffer,17,10)
			nLenRej:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosRej:=.t.
			nLidos+=85
			Loop
		EndIF
		If mv_par07 == 2
			IF !lPosForne
				cPosForne := Substr(xBuffer,17,10)
				nLenForne := 1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
				lPosForne := .t.
				nLidos += 85
				Loop
			EndIF
		Endif
		Exit
	EndDo
	
	//зддддддддддддддддддддддддддддддд©
	//Ё fecha arquivo de configuracao Ё
	//юддддддддддддддддддддддддддддддды
	Fclose(nHdlConf)
Endif
//зддддддддддддддддддддддддддддддддд©
//Ё Abre arquivo enviado pelo banco Ё
//юддддддддддддддддддддддддддддддддды
cArqEnt:=mv_par01
IF !FILE(cArqEnt)
	Set Device To Screen
	Set Printer To
	Help(" ",1,"NOARQENT")
	Return .F.
Else
	nHdlBco:=FOPEN(cArqEnt,0+64)
EndIF

//зддддддддддддддддддддддддддддддд©
//Ё L┬ arquivo enviado pelo banco Ё
//юддддддддддддддддддддддддддддддды
nLidos:=0
FSEEK(nHdlBco,0,0)
nTamArq:=FSEEK(nHdlBco,0,2)
FSEEK(nHdlBco,0,0)

SetRegua(nTamArq/nTamDet)

While nTamArq-nLidos >= nTamDet
	If mv_par08 == 1
		//зддддддддддддддддддддддддддддд©
		//Ё Tipo qual registro foi lido Ё
		//юддддддддддддддддддддддддддддды
		xBuffer:=Space(nTamDet)
		FREAD(nHdlBco,@xBuffer,nTamDet)
		
		IncRegua()
		
		IF !lHeader
			nLidos+=nTamDet
			lHeader := .t.
			Loop
		EndIF
		
		IF	SubStr(xBuffer,1,1) == "0" .or. SubStr(xBuffer,1,1) == "9" .or. ;
			SubStr(xBuffer,1,1) == "7" .or. SubStr(xBuffer,1,1) == "8"
			nLidos+=nTamDet
			Loop
		EndIF
		
		If SubStr(xBuffer,1,1) == "1" .or. Substr(xBuffer,1,3) == "001"
			nDespes :=0
			nDescont:=0
			nAbatim :=0
			nValRec :=0
			nJuros  :=0
			nMulta  :=0
			If mv_par07 == 1						// somente carteira receber
				nValIof :=0
				nValCc  :=0
				dCred   :=ctod("  /  /  ")
			EndIf
			cData   :=""
			dBaixa  :=ctod("  /  /  ")
			cEspecie:="  "
			cNossoNum:=Space(15)
			cForne:= Space(8)
			//здддддддддддддддддддддддддддддддддд©
			//Ё Le os valores do arquivo Retorno Ё
			//юдддддддддддддддддддддддддддддддддды
			IF !Empty(cPosDesp)
				nDespes:=Val(Substr(xBuffer,Int(Val(Substr(cPosDesp,1,3))),nLenDesp))/100
			EndIF
			IF !Empty(cPosDesc)
				nDescont:=Val(Substr(xBuffer,Int(Val(Substr(cPosDesc,1,3))),nLenDesc))/100
			EndIF
			IF !Empty(cPosAbat)
				nAbatim:=Val(Substr(xBuffer,Int(Val(Substr(cPosAbat,1,3))),nLenAbat))/100
			EndIF
			IF !Empty(cPosPrin)
				nValRec :=Val(Substr(xBuffer,Int(Val(Substr(cPosPrin,1,3))),nLenPrin))/100
			EndIF
			IF !Empty(cPosJuro)
				nJuros  :=Val(Substr(xBuffer,Int(Val(Substr(cPosJuro,1,3))),nLenJuro))/100
			EndIF
			IF !Empty(cPosMult)
				nMulta  :=Val(Substr(xBuffer,Int(Val(Substr(cPosMult,1,3))),nLenMult))/100
			EndIF
			IF !Empty(cPosIof)
				nValIof :=Val(Substr(xBuffer,Int(Val(Substr(cPosIof,1,3))),nLenIof))/100
			EndIF
			IF !Empty(cPosCc)
				nValCc :=Val(Substr(xBuffer,Int(Val(Substr(cPosCc,1,3))),nLenCc))/100
			EndIF
			IF !Empty(cPosNosso)
				cNossoNum :=Substr(xBuffer,Int(Val(Substr(cPosNosso,1,3))),nLenNosso)
			EndIF
			IF !Empty(cPosForne)
				cForne  :=Substr(xBuffer,Int(Val(Substr(cPosForne,1,3))),nLenForne)
			Endif
			
			cDescr  := ""
			cNumTit := Substr(xBuffer,Int(Val(Substr(cPosNum, 1,3))),nLenNum )
			cData   := Substr(xBuffer,Int(Val(Substr(cPosData,1,3))),nLenData)
			cData   := ChangDate(cData,SEE->EE_TIPODAT)
			dBaixa  := Ctod(Substr(cData,1,2)+"/"+Substr(cData,3,2)+"/"+Substr(cData,5),"ddmm"+Replicate("y",Len(Substr(cData,5))))
			cTipo   := Substr(xBuffer,Int(Val(Substr(cPosTipo, 1,3))),nLenTipo )
			cTipo   := Iif(Empty(cTipo),"NF ",cTipo)		// Bradesco
			IF !Empty(cPosDtCc)
				cData :=Substr(xBuffer,Int(Val(Substr(cPosDtCc,1,3))),nLenDtCc)
				dCred :=Ctod(Substr(cData,1,2)+"/"+Substr(cData,3,2)+"/"+Substr(cData,5,2),"ddmmyy")
			EndIF
			If nLenOcor == 2
				cOcorr  :=Substr(xBuffer,Int(Val(Substr(cPosOcor,1,3))),nLenOcor) + " "
			Else
				cOcorr  :=Substr(xBuffer,Int(Val(Substr(cPosOcor,1,3))),nLenOcor)
			EndIf
			If nLenRej > 0
				cRej	:= Substr(xBuffer,Int(Val(Substr(cPosRej,1,3))),nLenRej)
			EndIf
			
			lOk := .T.
			//зддддддддддддддддддддддддддддддд©
			//Ё o array aValores ir═ permitir Ё
			//Ё que qualquer exce┤└o ou neces-Ё
			//Ё sidade seja tratado no ponto  Ё
			//Ё de entrada em PARAMIXB        Ё
			//юддддддддддддддддддддддддддддддды
			// Estrutura de aValores
			// Numero do Titulo	 - 01
			// data da Baixa	 - 02
			// Tipo do Titulo	 - 03
			// Nosso Numero		 - 04
			// Valor da Despesa	 - 05
			// Valor do Desconto - 06
			// Valor do Abatiment- 07
			// Valor Recebido    - 08
			// Juros			 - 09
			// Multa			 - 10
			// Valor do Credito	 - 11
			// Data Credito		 - 12
			// Ocorrencia		 - 13
			// Linha Inteira	 - 14
			
			aValores := ( { cNumTit, dBaixa, cTipo, cNossoNum, nDespes, nDescont, nAbatim, nValRec, nJuros, nMulta, nValCc, dCred, cOcorr, xBuffer })
			
			If lF650Var
				ExecBlock("F650VAR",.F.,.F.,{aValores})
			Endif
			
			If !Empty(cTipo)
				//зддддддддддддддддддддддддддддддд©
				//Ё Verifica especie do titulo    Ё
				//юддддддддддддддддддддддддддддддды
				nPos := Ascan(aTabela, {|aVal|aVal[1] == AllTrim(Substr(cTipo,1,Len(IIF(mv_par07==1,SE1->E1_TIPO,SE2->E2_TIPO))))})
				If nPos != 0
					cEspecie := aTabela[nPos][2]
				Else
					cEspecie	:= "  "
				EndIf
				If cEspecie $ MVABATIM			// Nao l┬ titulo de abatimento
					nLidos+=nTamDet
					Loop
				Endif
				dbSelectArea(IIF(mv_par07==1,"SE1","SE2"))
				While .T.
					cChave650 := IIf(!Empty(cForne),cNumTit+cEspecie+SubStr(cForne,1,6),cNumTit+cEspecie)
					If !dbSeek(cFilial+cChave650)
						nPos := Ascan(aTabela, {|aVal|aVal[1] == AllTrim(Substr(cTipo,1,Len(IIF(mv_par07==1,SE1->E1_TIPO,SE2->E2_TIPO))))},nPos+1)
						If nPos != 0
							cEspecie := aTabela[nPos][2]
						Else
							Exit
						Endif
					Else
						Exit
					Endif
				Enddo
				If nPos == 0
					cEspecie	:= "  "
				EndIF
				If cEspecie $ MVABATIM			// Nao le titulo de abatimento
					nLidos += nTamDet
					Loop
				EndIf
			EndIF
		Else
			lTrailler := .T.
		Endif
	Else
		aLeitura := ReadCnab2(nHdlBco,MV_PAR02,nTamDet)
		If ( Empty(aLeitura[1]) )
			nLidos += nTamDet
			Loop
		Endif
		cNumTit  	:= SubStr(aLeitura[1],1,10)
		cData    	:= aLeitura[04]
		cData   	:= ChangDate(cData,SEE->EE_TIPODAT)
		dBaixa   	:= Ctod(Substr(cData,1,2)+"/"+Substr(cData,3,2)+"/"+Substr(cData,5),"ddmm"+Replicate("y", Len(Substr(cData,5))))
		cTipo    	:= aLeitura[02]
		cTipo    	:= Iif(Empty(cTipo),"NF ",cTipo)		// Bradesco
		cNossoNum   := aLeitura[11]
		nDespes  	:= aLeitura[06]
		nDescont 	:= aLeitura[07]
		nAbatim  	:= aLeitura[08]
		nValRec  	:= aLeitura[05]
		nJuros   	:= aLeitura[09]
		nMulta   	:= aLeitura[10]
		cOcorr   	:= PadR(aLeitura[03],3)
		nValOutrD	:= aLeitura[12]
		nValCC   	:= aLeitura[13]
		cData    	:= aLeitura[14]
		cData   	:= ChangDate(cData,SEE->EE_TIPODAT)
		dDataCred	:= Ctod(Substr(cData,1,2)+"/"+Substr(cData,3,2)+"/"+Substr(cData,5,2),"ddmmyy")
		dDataUser	:= dDataCred
		cRej		:= aLeitura[15]
		lOk := .t.
		//зддддддддддддддддддддддддддддддд©
		//Ё o array aValores ir═ permitir Ё
		//Ё que qualquer excecao ou neces-Ё
		//Ё sidade seja tratado no ponto  Ё
		//Ё de entrada em PARAMIXB        Ё
		//юддддддддддддддддддддддддддддддды
		// Estrutura de aValores
		// Numero do Titulo	 - 01
		// data da Baixa	 - 02
		// Tipo do Titulo	 - 03
		// Nosso Numero		 - 04
		// Valor da Despesa	 - 05
		// Valor do Desconto - 06
		// Valor do Abatiment- 07
		// Valor Recebido    - 08
		// Juros			 - 09
		// Multa			 - 10
		// Valor do Credito	 - 11
		// Data Credito		 - 12
		// Ocorrencia		 - 13
		// Linha Inteira	 - 14
		
		aValores := ( { cNumTit, dBaixa, cTipo, cNossoNum, nDespes, nDescont, nAbatim, nValRec, nJuros, nMulta, nValCc, dCred, cOcorr, xBuffer })
		nLenRej := Len(AllTrim(cRej))
		If lF650Var
			ExecBlock("F650VAR",.F.,.F.,{aValores})
		Endif
		
		//зддддддддддддддддддддддддддддддд©
		//Ё Verifica especie do titulo    Ё
		//юддддддддддддддддддддддддддддддды
		nPos := Ascan(aTabela, {|aVal|aVal[1] == AllTrim(Substr(cTipo,1,Len(IIF(mv_par07==1,SE1->E1_TIPO,SE2->E2_TIPO))))})
		If nPos != 0
			cEspecie := aTabela[nPos][2]
		Else
			cEspecie	:= "  "
		EndIf
		If cEspecie $ MVABATIM			// Nao le titulo de abatimento
			nLidos += nTamDet
			Loop
		Endif
		While .T.
			dbSelectArea(IIF(mv_par07==1,"SE1","SE2"))
			If !dbSeek(cFilial+cNumTit+cEspecie)
				nPos := Ascan(aTabela, {|aVal|aVal[1] == AllTrim(Substr(cTipo,1,Len(IIF(mv_par07==1,SE1->E1_TIPO,SE2->E2_TIPO))))},nPos+1)
				If nPos != 0
					cEspecie := aTabela[nPos][2]
				Else
					Exit
				Endif
			Else
				Exit
			Endif
		Enddo
		If nPos == 0
			cEspecie	:= "  "
		EndIF
		If cEspecie $ MVABATIM			// Nao l┬ titulo de abatimento
			nLidos+=nTamDet
			Loop
		EndIf
	EndIf
	
	If ( ltrailler )
		nLidos+=nTamDet
		loop
	EndIf
	
	IF lEnd
		@ PROW()+1, 001 PSAY "CANCELADO PELO OPERADOR"
		Exit
	End
	
	IF li > 58
		cabec(Titulo+' - '+mv_par01,cabec1,cabec2,nomeprog,tamanho,nTipo)
	End
	
	@li,000 PSAY Left(cNumTit,10)
	@li,011 PSAY cEspecie
	//зддддддддддддддддддддддддддддддд©
	//Ё Verifica codigo da ocorrencia Ё
	//юддддддддддддддддддддддддддддддды
	dbSelectArea("SEB")
	If mv_par07 == 1
		cCarteira := "R"
	Else
		cCarteira := "P"
	EndIf
	If (dbSeek(cFilial+mv_par03+cOcorr+cCarteira))
		cDescr := Subs(SEB->EB_DESCRI,1,29)
		If SEB->EB_OCORR $ "03Э15Э16Э17Э40Э41Э42"		//Registro rejeitado
			//зддддддддддддддддддддддддддддддд©
			//Ё Verifica tabela de rejeicao   Ё
			//юддддддддддддддддддддддддддддддды
			If nLenRej > 0
				If dbSeek(cFilial+mv_par03+cOcorr+cCarteira+Substr(cRej,1,2))
					cDescr := cOcorr + "(" + Substr(cRej,1,2) + ;
					")" + "-" + Substr(SEB->EB_DESCMOT,1,22)
				EndIf
				lRej := .T.
			EndIf
		EndIf
		lOcorr := .T.
	Else
		cDescr := Space(29)
		lOcorr := .F.
	EndIF
	If mv_par07 == 1
		dbSelectArea("SE1")
	Else
		dbSelectArea("SE2")
	EndIf
	@li,015 PSAY Subs(cDescr,1,29)
	@li,045 PSAY dBaixa
	@li,056 PSAY nDespes  picture tm(nDespes,12)  //'@E 99999,999.99'
	@li,069 PSAY nDescont picture tm(nDescont,12) //'@E 99999,999.99'
	@li,085 PSAY nAbatim  picture tm(nAbatim,12)  //'@E 99999,999.99'
	@li,099 PSAY nValRec  picture tm(nValRec,12)  //'@E 99999,999.99'
	@li,113 PSAY nJuros   picture tm(nJuros,12)	  //'@E 99999,999.99'
	@li,126 PSAY nMulta   picture tm(nMulta,12)	  //'@E 99999,999.99'
	If mv_par07 == 1
		@li,139 PSAY nValIof  picture tm(nValIof,12) //'@E 99999,999.99'
		@li,153 PSAY nValCc   picture tm(nValCC,12)  //'@E 99999,999.99'
		@li,166 PSAY Iif(Empty(dCred),dDataBase,dCred)
		@li,177 PSAY Pad(cNossoNum,19)
	Else
		@li,146 PSAY Pad(cNossoNum,19)
	EndIf
	
	nDespT += nDespes
	nDescT += nDescont
	nAbatT += nAbatim
	nValT  += nValRec
	nJurT  += nJuros
	nMulT  += nMulta
	
	If mv_par07 == 1
		nIOFT  += nValIOF
		nCCT   += nValCC
	EndIf
	
	IF Empty(cOcorr)
		cDescr := OemToAnsi(STR0015)  	//"OCORRENCIA NAO ENVIADA"
		lOk := U_ImpCons12(cDescr)
	Else
		If ! lOcorr
			cDescr := OemToAnsi(STR0016)  //"OCORRENCIA NAO ENCONTRADA"
			lOk := U_ImpCons12(cDescr)
		End
	End
	
	IF Empty(cNumTit)
		cDescr := OemToAnsi(STR0017)  	//"NUMERO TITULO NAO ENVIADO"
		lOk := U_ImpCons12(cDescr)
	End
	
	If mv_par07 == 1
		dbSelectArea("SE1")
		dbSetOrder( 1 )
		cChave650 := cNumTit+cEspecie
	Else
		dbSelectArea("SE2")
		dbSetOrder(1)
		cChave650 := IIf(!Empty(cForne),cNumTit+cEspecie+SubStr(cForne,1,6),cNumTit+cEspecie)
	EndIf
	lAchouTit := .F.
	If !dbSeek(cFilial+cChave650)
		cDescr := OemToAnsi(STR0018)  	//"TITULO NAO ENCONTRADO"
		lOk := U_ImpCons12(cDescr)
	Else
		lAchouTit := .T.
	Endif
	
	
	//--- Customizacao
	//--- Rodrigo Tomaz - 17/12/2003
	//--- Verifica Saldo do titulo somente se a OCORRENCIA for de Baixa (Pagamento)

	IF mv_par07 == 1 .and. cOcorr $ "06/07/08/36/37/38/39"
		IF lAchouTit .AND. SE1->E1_SALDO != 0 .and. nAbatim == 0
			nValPadrao1 := 0
			nTotAbat1   := 0
			nValPadrao1 := nValRec-(nJuros+nMulta-nDescont)
			nTotAbat1   := SUMABATREC(SUBSTR(cNumtit,1,3),SUBSTR(cNumtit,4,6),SUBSTR(cNumtit,10,1),1,"S")
			IF ROUND(NOROUND((SE1->E1_SALDO-nTotAbat1),3),2) != ROUND(NOROUND(nValPadrao1,3),2)
				cDescr := ">>> SALDO DIVERGENTE <<<"
				lOk := U_ImpCons12(cDescr)
			ENDIF
		ENDIF
	ENDIF

	//--- Fim
	
	IF Substr(dtoc(dBaixa),1,1)=' '
		cDescr := OemToAnsi(STR0019) 	//"DATA DE BAIXA NAO ENVIADA"
		lOk := U_ImpCons12(cDescr)
	EndIF
	
	IF Empty(cTipo)
		cDescr := OemToAnsi(STR0020)  	//"ESPECIE NAO ENVIADA"
		lOk := U_ImpCons12(cDescr)
	End
	
	If Empty(cEspecie)
		cDescr := OemToAnsi(STR0021)  	//"ESPECIE NAO ENCONTRADA"
		lOk := U_ImpCons12(cDescr)
	Endif
	
	If mv_par07 == 1 .and. lAchouTit .and. nAbatim == 0 .and. SE1->E1_SALDO > 0
		nValPadrao := nValRec-(nJuros+nMulta-nDescont)
		nTotAbat   := SumAbatRec(Substr(cNumtit,1,3),Substr(cNumtit,4,6),Substr(cNumtit,10,1),1,"S")
		If Round(NoRound((SE1->E1_SALDO-nTotAbat),3),2) < Round(NoRound(nValPadrao,3),2)
			cDescr := OemToAnsi(STR0025)  //"VALOR RECEBIDO A MAIOR"
			lOk := U_ImpCons12(cDescr)
		Endif
	Endif
	If lOk
		cDescr := OemToAnsi(STR0022)  	//"TITULO OK"
		lOk := U_ImpCons12(cDescr)
	End
	If nLenRej > 0
		If Len(Alltrim(cRej)) > 2
			For nCont := 3 to Len(Alltrim(cRej)) Step 2
				If lRej
					//зддддддддддддддддддддддддддддддд©
					//Ё Verifica tabela de rejeicao   Ё
					//юддддддддддддддддддддддддддддддды
					dbSelectArea("SEB")
					If dbSeek(cFilial+mv_par03+cOcorr+cCarteira+Substr(cRej,nCont,2))
						cDescr := cOcorr + "(" + Substr(cRej,nCont,2) + ;
						")" + "-" + Substr(SEB->EB_DESCMOT,1,22)
						@li,015 PSAY Subs(cDescr,1,29)
						li++
					EndiF
				EndIf
			Next nCont
		EndIf
	EndIf
	
	If mv_par07 == 1
		dbSelectArea("SE1")
	Else
		dbSelectArea("SE2")
	EndIf
	If mv_par08 == 1
		nLidos+=nTamDet
	Endif
EndDo

IF li != 80
	Li+=2
	IF li > 58
		Cabec(Titulo+' - '+mv_par01,cabec1,cabec2,nomeprog,tamanho,nTipo)
	End
	//зддддддддддддддддддддддддддддддд©
	//Ё Imprime Totais                Ё
	//юддддддддддддддддддддддддддддддды
	@li,000 PSAY OemToAnsi(STR0023)  //"TOTAIS DO RELATORIO"
	@li,056 PSAY nDespT      picture TM(nDespT,12) //'@E 9,999,999,999.99'
	@li,069 PSAY nDescT      picture TM(nDescT,12) //'@E 9,999,999,999.99'
	@li,085 PSAY nAbatT      picture TM(nAbatT,12) //'@E 9,999,999,999.99'
	@li,099 PSAY nValT       picture Tm(nValT,12)  //'@E 9,999,999,999.99'
	@li,113 PSAY nJurT       picture Tm(nJurT,12)  //'@E 9,999,999,999.99'
	@li,126 PSAY nMulT       picture Tm(nMult,12)  //'@E 9,999,999,999.99'
	If mv_par07 == 1
		@li,139 PSAY nIofT    picture TM(nIofT,12) //'@E 9,999,999,999.99'
		@li,153 PSAY nCcT     picture TM(nCcT,12)  //'@E 9,999,999,999.99'
	EndIf
	roda(cbcont,cbtxt,tamanho)
EndIF

//зддддддддддддддддддддддддд©
//Ё Fecha os Arquivos ASCII Ё
//юддддддддддддддддддддддддды
fClose(nHdlBco)
fClose(nHdlConf)

Set Device TO Screen
dbSelectArea("SEF")
dbSetOrder(1)
Set Filter To

If aReturn[5] = 1
	Set Printer To
	dbCommit()
	Ourspool(wnrel)
End
MS_FLUSH()
Return

//эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
//╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
//╠╠зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд©╠╠
//╠╠ЁFuncao    Ё IMPCONS  Ё Autor Ё                       Ё Data Ё 27/06/94 Ё╠╠
//╠╠цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд╢╠╠
//╠╠ЁDescricao Ё Impressao da Consistencia                                  Ё╠╠
//╠╠цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
//╠╠ЁSintaxe   Ё IMPCONS(texto)                                             Ё╠╠
//╠╠цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
//╠╠Ё Uso      Ё FINR650.PRG                                                Ё╠╠
//╠╠юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды╠╠
//╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
//ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
User Function ImpCons12(cTexto)

If mv_par07 == 1
//	@ li,197 PSAY Pad(cTexto,23)
 	@ li,PCOL()+1 PSAY Pad(cTexto,20)
Else
	@ li,166 PSAY Pad(cTexto,23)
EndIf
li++
Return .F.
