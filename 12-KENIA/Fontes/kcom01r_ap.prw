#include "rwmake.ch"        

User Function kcom01r()        


SetPrvt("WNREL,TITULO,CDESC1,CDESC2,CDESC3,CSTRING")
SetPrvt("AORD,TAMANHO,CPERG,NTOTAL,ARETURN,NLASTKEY")
SetPrvt("CBCONT,CBTXT,LIMITE,LI,M_PAG,IMPRIME")
SetPrvt("NORDEM,NTIPO,CABEC1,NFIRST,NTOTGERAL,NTOTDESCO")
SetPrvt("NTGERICM,NTGERIPI,NTGIMPINC,NTGIMPNOINC,CABEC2,CCABEC")
SetPrvt("NOMEPROG,NSAVORDER,LOPER,NVALIPI,NVALMERC,NVALDESC")
SetPrvt("NVALICM,NIMPINC,NIMPNOINC,NVALIMPINC,NVALIMPNOINC,CQUERY")
SetPrvt("CINDEX,NINDEX,AIMPOSTOS,CDOCANT,LEND,NIMPOS")
SetPrvt("NY,CCAMPIMP,AIMPOSTO,CNOTANT,NTOTPROD,NTOTQUANT")
SetPrvt("NTOTGER,NTOTQGER,NQUEBRA,NCODANT,NTOTDATA,DDATAANT")

// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 12/02/05 ==> #INCLUDE "FIVEWIN.CH"

wnrel  :="KCOM01R" 
titulo :="Relacao de Notas Fiscais"
cDesc1 :="Emissao da Relacao de Notas de Compras"
cDesc2 :="A opcao de filtragem deste relatorio sera valida na opcao que lista os"
cDesc3 :="itens. Os parametros funcionam normalmente em qualquer opcao."
cString:="SD1"
aOrd    := {OemToAnsi("Por Nota Fiscal"),OemToAnsi("Por Produto"),OemToAnsi("Por Data de Digitacao")} 
Tamanho  := "M"
cPerg  :="MTR080"
nTotal := 0
aReturn := { OemToAnsi("Zebrado"), 1,OemToAnsi("Administracao"), 2, 2, 1, "",1 }
nLastKey := 0

Pergunte("MTR080",.F.)
//ü Variaveis utilizadas para parametros                         ü
//ü mv_par01 // Produto de                                       ü
//ü mv_par02 // Produto ate                                      ü
//ü mv_par03 // Data de                                          ü
//ü mv_par04 // Data ate                                         ü
//ü mv_par05 // Lista os itens da nota                           ü
//ü mv_par06 // Grupo de                                         ü
//ü mv_par07 // Grupo ate                                        ü
//ü mv_par08 // Fornecedor de                                    ü
//ü mv_par09 // Fornecedor ate                                   ü
//ü mv_par10 // Almoxarifado de                                  ü
//ü mv_par11 // Almoxarifado ate                                 ü
//ü mv_par12 // De  Nota                                         ü
//ü mv_par13 // Ate Nota                                         ü
//ü mv_par14 // De  Serie                                        ü
//ü mv_par15 // Ate Serie                                        ü
//ü mv_par16 // Do  Tes                                          ü
//ü mv_par17 // Ate Tes                                          ü

wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,Tamanho)

If nLastKey == 27
    Set Filter to
    Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
    Set Filter To
    Return
Endif

RptStatus({|lEnd| C080Imp()},titulo)// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> RptStatus({|lEnd| Execute(C080Imp)},titulo)
Return .T.

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function C080Imp()
Static Function C080Imp()

cbCont   := 0
cbTxt    := Space(10)
limite   := 132
li       := 80
m_pag    := 1
imprime  := .T.
nOrdem   := aReturn[8]
nTipo    := IIF(aReturn[4]=1,15,18)
cabec1   := "** RELACAO DAS NOTAS FISCAIS DE COMPRAS **"
If nOrdem == 1
    If mv_par05 == 1
        ImpAnalit()
    Else
        ImpSintet()
    Endif
ElseIf nOrdem == 2
    ImpProduto()
ElseIf nOrdem == 3
    ImpDataDig()
Endif

If li != 80
    roda(cbcont,cbtxt)
EndIF

dbSelectArea("SD1")
Set Filter To
dbSetOrder(1)

Set Device to Screen

If aReturn[5] == 1
    Set Printer TO
    dbCommitAll()
    ourspool(wnrel)
Endif

MS_FLUSH()

Return .T.

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function ImpAnalit
Static Function ImpAnalit()

nFirst   :=0
nTotGeral:=0
nTotDesco:=0
nTGerIcm :=0
nTGerIpi :=0
nTGImpInc:=0
nTGImpNoInc:=0

titulo   :="RELACAO DE NOTAS FISCAIS"
cabec1   :="RELACAO DOS ITENS DAS NOTAS"
cabec2   :=""
cCabec   :="CODIGO DO MATERIAL   D E S C R I C A O             CFO  TE  ICM  IPI  LOCAL             QUANTIDADE   VALOR UNITARIO      VALOR TOTAL"
nomeprog :="KCOM01R"
nSavOrder:=0
loper    :=.T.
nValIpi  :=0
nValMerc :=0
nValDesc :=0
nValIcm  :=0
nImpInc  :=0
nImpNoInc:=0
nValImpInc:=0
nValImpNoInc:=0
cQuery  := ""

cIndex  := CriaTrab("",.F.)
nIndex  := 0
aImpostos :={}

dbSelectArea("SF4")
dbSetOrder(1)

dbSelectArea("SD1")
dbSetOrder(1)

cQuery    := cQuery +"D1_FILIAL=='"+xFilial("SD1")+"'.And.D1_DOC>='"+mv_par12+"'.And.D1_DOC<='"+mv_par13+"'"
cQuery    := cQuery +".And.D1_SERIE>='"+mv_par14+"'.And.D1_SERIE<='"+mv_par15+"'.And."
cQuery    := cQuery +"D1_COD>='"+mv_par01+"'.And.D1_COD<='"+mv_par02+"'.And."
cQuery    := cQuery +"DTOS(D1_DTDIGIT)>='"+DTOS(mv_par03)+"'.And.DTOS(D1_DTDIGIT)<='"+DTOS(mv_par04)+"'"

IndRegua("SD1",cIndex,IndexKey(),,cQuery)
nIndex := RetIndex("SD1")

dbSetOrder(nIndex+1)
dbSeek(xFilial(),.T.)

SetRegua(RecCount())

While !Eof() .And. xFilial()==SD1->D1_FILIAL

    IncRegua()          // Incrementa a Regua de processamento
  
    If lEnd
        @PROW()+1,001 PSAY STR0013  //"CANCELADO PELO OPERADOR"
        loper:=.F.
        Exit
    Endif

    If D1_CANCEL == "S"
        dbSkip()
        Loop
    EndIf

    If !Empty(aReturn[7]) .And. !&(aReturn[7])
        dbSkip()
        Loop
    EndIf
   
 	IF D1_GRUPO < mv_par06 .or. D1_GRUPO > mv_par07
 		dbSkip()
  		Loop
 	Endif
  	//éŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽ¨
  	//ü Verifica Fornecedor                                	        ü
  	//·ŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽë
  	IF D1_FORNECE < mv_par08 .or. D1_FORNECE > mv_par09
  		dbSkip()
  		Loop
  	Endif
  	//éŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽ¨
  	//ü Verifica local                				 						  ü
  	//·ŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽë
  	If D1_LOCAL < mv_par10 .Or. D1_LOCAL > mv_par11
  		dbSkip()
  		Loop
  	EndIf
  	//éŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽ¨
  	//ü Verifica Tes                  				 						  ü
  	//·ŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽë
  	If D1_TES < mv_par16 .Or. D1_TES > mv_par17
  		dbSkip()
  		Loop
0273  	EndIf
0274  
0275  	nValIpi  := 0
0276  	nValMerc := 0
0277  	nValDesc := 0
0278  	nValIcm  := 0
0279  	nValImpInc	:= 0
0280  	nValImpNoInc:= 0
0281  	nImpInc		:= 0
0282  	nImpNoInc	:= 0
0283  
0284  	cDocAnt := SD1->D1_DOC + SD1->D1_SERIE + SD1->D1_FORNECE + SD1->D1_LOJA
0285  
0286  	While !Eof().And.D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA==xFilial()+cDocAnt
0291  			If D1_CANCEL == "S"
0292  				dbSkip()
0293  				Loop
0294  			EndIf
0301  
0302  		If lEnd
0303  			@PROW()+1,001 PSAY STR0013	//"CANCELADO PELO OPERADOR"
0304  			loper:=.F.
0305  			Exit
0306  		Endif
0307  		//éŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽ¨
0308  		//ü Verifica a Faixa Do Codigo do Produto               			  ü
0309  		//·ŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽë
0310  		If D1_COD < mv_par01 .or. D1_COD > mv_par02
0311  			dbSkip()
0312  			Loop
0313  		Endif
0314  		//éŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽ¨
0315  		//ü Verifica a Faixa De Data de Digitacao               			  ü
0316  		//·ŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽë
0317  		If D1_DTDIGIT < mv_par03 .or. D1_DTDIGIT > mv_par04
0318  			dbSkip()
0319  			Loop
0320  		Endif
0321  		//éŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽ¨
0322  		//ü Verifica a Faixa Do Grupo do Produto               	        ü
0323  		//·ŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽë
0324  		If D1_GRUPO < mv_par06 .or. D1_GRUPO > mv_par07
0325  			dbSkip()
0326  			Loop
0327  		Endif
0328  		//éŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽ¨
0329  		//ü Verifica local                				 						  ü
0330  		//·ŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽë
0331  		If D1_LOCAL < mv_par10 .Or. D1_LOCAL > mv_par11
0332  			dbSkip()
0333  			Loop
0334  		Endif
0335  		//éŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽ¨
0336  		//ü Verifica Tes                  				 						  ü
0337  		//·ŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽë
0338  		If D1_TES < mv_par16 .Or. D1_TES > mv_par17
0339  			dbSkip()
0340  			Loop
0341  		EndIf
0342  
0343  		//éŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽ¨
0344  		//ü Executa a validacao do filtro do usuario           	        ü
0345  		//·ŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽë
0346  		If !Empty(aReturn[7]) .And. !&(aReturn[7])
0347  			dbSkip()
0348  			Loop
0349  		EndIf
0350  
0351  		//éŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽ¨
0352  		//ü Verifica se e nova pagina                                    ü
0353  		//·ŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽë
0354  		If li > 56
0355  			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
0356  			If nFirst != 0
0357  				li++
0358  			EndIf
0359  		Endif
0360  		If cPaisLoc#"BRA"
0361  			SF1->(dBSetOrder(1))
0362  			SF1->(dBSeek(xFilial()+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA))
0363  		Endif	
0364  		If nFirst == 0
0365  			nFirst := 1
0366  			ImprNota()
0367  			li++
0368  			@li,000 PSAY cCabec
0369  			li++
0370  		Endif
0371  		If ( cPaisLoc#"BRA" )
0372  			aImpostos:=TesImpInf(SD1->D1_TES)
0373  			nImpInc	:=	0
0374  			nImpNoInc:=	0
0375  			nImpos	:=	0
0376  			For nY:=1 to Len(aImpostos)
0377  				cCampImp:="SD1->"+(aImpostos[nY][2])
0378  				If Type("SF1->F1_TXMOEDA")#"U"
0379  					nImpos:=xMoeda(&cCampImp,SF1->F1_MOEDA,1,SF1->F1_EMISSAO,,SF1->F1_TXMOEDA)
0380  				Else	
0381  					nImpos:=&cCampImp
0382  				Endif
0383  				If ( aImpostos[nY][3]=="S" )
0384  					nImpInc	+=nImpos
0385  				Else
0386  					nImpNoInc+=nImpos
0387  				EndIf
0388  			Next
0389  		Endif
0390  
0391  		@li,00 PSay SD1->D1_COD
0392  
0393  		dbSelectArea("SB1")
0394  		dbSetOrder(1)
0395  		If dbSeek(xFilial()+SD1->D1_COD)
0396  			@li,021  PSAY SubStr(B1_DESC,1,30)
0397  		Endif
0398  
0399  		dbSelectArea("SD1")
0400  		If ( cPaisLoc<>"BRA" )
0401  			@li,056 PSAY D1_TES
0402  			@li,063 PSAY D1_IPI        Picture PesqPict("SD1","D1_IPI")
0403  		Else
0404  			@li,051 PSAY D1_CF
0405  			@li,056 PSAY D1_TES
0406  			@li,061 PSAY D1_PICM			Picture PesqPict("SD1","D1_PICM")
0407  			@li,067 PSAY D1_IPI        Picture PesqPict("SD1","D1_IPI")
0408  		EndIf
0409  		@li,073 PSAY D1_LOCAL
0410  		@li,084 PSAY D1_QUANT		Picture tm(D1_QUANT,14)
0411  		If cPaisLoc<>"BRA".and.Type("SF1->F1_TXMOEDA")#"U"
0412  			@li,101 PSAY xMoeda(D1_VUNIT,SF1->F1_MOEDA,1,SF1->F1_EMISSAO,,SF1->F1_TXMOEDA)		Picture tm(D1_VUNIT,14)
0413  			@li,115 PSAY xMoeda(D1_TOTAL,SF1->F1_MOEDA,1,SF1->F1_EMISSAO,,SF1->F1_TXMOEDA)		Picture tm(D1_TOTAL,17)
0414  		Else	
0415  			@li,101 PSAY D1_VUNIT		Picture tm(D1_VUNIT,14)
0416  			@li,115 PSAY D1_TOTAL		Picture tm(D1_TOTAL,17)
0417        Endif
0418  		li++
0419  
0420  		If ( cPaisLoc=="BRA" )
0421  			nValIpi  += D1_VALIPI
0422  			nValMerc := nValMerc + D1_TOTAL + D1_ICMSRET
0423  			nValIcm  += D1_VALICM
0424  
0425  			nTgerIcm += D1_VALICM
0426  			nTgerIpi += D1_VALIPI
0427  			nTotGeral := nTotGeral + D1_TOTAL - D1_VALDESC + D1_ICMSRET
0428  		Else
0429  			nValImpInc	+=nImpInc
0430  			nValImpNoInc+=nImpNoInc
0431  			If Type("SF1->F1_TXMOEDA")#"U"
0432  				nValMerc 	:= nValMerc + xMoeda(D1_TOTAL,SF1->F1_MOEDA,1,SF1->F1_EMISSAO,,SF1->F1_TXMOEDA)
0433  			Else	
0434  				nValMerc 	:= nValMerc + D1_TOTAL
0435           Endif
0436  			nTgImpInc 	+= nImpInc
0437  			nTgImpNoInc += nImpNoInc
0438  			If Type("SF1->F1_TXMOEDA")#"U"
0439  				nTotGeral 	:= nTotGeral + xMoeda((D1_TOTAL - D1_VALDESC),SF1->F1_MOEDA,1,SF1->F1_EMISSAO,,SF1->F1_TXMOEDA)
0440  			Else	
0441  				nTotGeral 	:= nTotGeral + D1_TOTAL - D1_VALDESC
0442  			Endif	
0443  		EndIf
0444  		If cPaisLoc<>"BRA".and.Type("SF1->F1_TXMOEDA")#"U"
0445  			nValDesc += xMoeda(D1_VALDESC,SF1->F1_MOEDA,1,SF1->F1_EMISSAO,,SF1->F1_TXMOEDA)
0446  			nTotDesco+= xMoeda(D1_VALDESC,SF1->F1_MOEDA,1,SF1->F1_EMISSAO,,SF1->F1_TXMOEDA)
0447  		Else	
0448  			nValDesc += D1_VALDESC
0449  			nTotDesco+= D1_VALDESC
0450  		EndIf	
0451  		//éŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽ¨
0452  		//ü Soma valor do IPI caso a nota nao seja compl. de IPI    	  ü
0453  		//ü e o TES Calcula IPI nao seja "R"                             ü
0454  		//·ŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽë
0455  		dbSelectArea("SF4")
0456  		If dbSeek(xFilial()+SD1->D1_TES)
0457  			dbSelectArea("SD1")
0458  			If D1_TIPO != "P" .And. SF4->F4_IPI != "R"
0459  				nValMerc += D1_VALIPI
0460  				nTotGeral+= D1_VALIPI
0461  			EndIf
0462  		Else
0463  			dbSelectArea("SD1")
0464  			If D1_TIPO != "P"
0465  				nValMerc += D1_VALIPI
0466  				nTotGeral+= D1_VALIPI
0467  			EndIf
0468  		EndIf
0469  		dbSkip()
0470  	End
0471  
0472  	nFirst   := 0
0473  	//If nValIcm > 0 .or. nValMerc > 0 .Or. nValIpi > 0
0474  	If (nValIcm + nValMerc + nValIpi + nValImpInc + nValImpNoInc) > 0
0475  		li++
0476  		dbSelectArea("SF1")
0477  		dbSetOrder(1)
0478  		dbSeek(xFilial()+cDocAnt)
0479  		@li,000 PSAY STR0014+SF1->F1_COND		//"COND. PAGTO : "
0480  		@li,029 PSAY STR0015							//"TOTAL ICM :"
0481  
0482  		If cPaisLoc=="BRA"
0483  			@li,040 PSAY nValIcm   	Picture tm(SF1->F1_VALICM,15)
0484  		Else
0485  			@li,040 PSAY nValImpNoInc   	Picture tm(SF1->F1_VALIMP1,15)
0486  		Endif
0487  
0488  		@li,056 PSAY STR0016							//"TOTAL IPI :"
0489  
0490  		If ( cPaisLoc=="BRA" )
0491  			@li,067 PSAY nValIpi    Picture tm(SF1->F1_VALIPI,15)
0492  		Else
0493  			@li,067 PSAY nValImpInc    Picture tm(SF1->F1_VALIMP1,15)
0494  		EndIf
0495  
0496  		li++
0497  		@li,000 PSAY STR0017							//"FRETE :"
0498  		If cPaisLoc<>"BRA".and.Type("SF1->F1_TXMOEDA")#"U"
0499  			@li,010 PSAY xMoeda(F1_FRETE,SF1->F1_MOEDA,1,SF1->F1_EMISSAO,,SF1->F1_TXMOEDA)    Picture tm(SF1->F1_FRETE,15)
0500  		Else	
0501  			@li,010 PSAY F1_FRETE    Picture tm(SF1->F1_FRETE,15)
0502  		Endif	
0503  		@li,029 PSAY STR0018							//"DESP.:"
0504  		If cPaisLoc<>"BRA".and.Type("SF1->F1_TXMOEDA")#"U"
0505  			@li,040 PSAY xMoeda(F1_DESPESA,SF1->F1_MOEDA,1,SF1->F1_EMISSAO,,SF1->F1_TXMOEDA)    Picture tm(SF1->F1_DESPESA,15)
0506  		Else
0507  			@li,040 PSAY F1_DESPESA    Picture tm(SF1->F1_DESPESA,15)
0508  		Endif
0509  		@li,056 PSAY STR0019							//"DESC.:"
0510  		@li,067 PSAY nValDesc	Picture tm(SF1->F1_DESCONT,15)
0511  		@li,096 PSAY STR0020							//"TOTAL NOTA   :"
0512  		If cPaisLoc<>"BRA".and.Type("SF1->F1_TXMOEDA")#"U"
0513  			@li,115 PSAY ( nValMerc-nValDesc+xMoeda((F1_DESPESA+F1_FRETE),SF1->F1_MOEDA,1,SF1->F1_EMISSAO,,SF1->F1_TXMOEDA))	Picture tm(SF1->F1_VALMERC,17)
0514     		nTotGeral := nTotGeral + xMoeda((F1_DESPESA + F1_FRETE),SF1->F1_MOEDA,1,SF1->F1_EMISSAO,,SF1->F1_TXMOEDA)
0515  		Else	
0516  			@li,115 PSAY ( nValMerc-nValDesc+F1_DESPESA+F1_FRETE)	Picture tm(SF1->F1_VALMERC,17)
0517     		nTotGeral := nTotGeral + F1_DESPESA + F1_FRETE
0518  		Endif	
0519  
0520  		li++
0521  		@li,000 PSAY Replicate("-",132)
0522  	Endif
0523  
0524  	dbSelectArea("SD1")
0525  EndDo
0526  
0527  If (nTgerIcm + nTgerIpi + nTotGeral + nTgImpInc + nTgImpNoInc) > 0 .and. loper
0528  	li+=2
0529  	@li,000 PSAY STR0021			//"TOTAL GERAL - "
0530  	@li,027 PSAY STR0022			//"ICM :"
0531  	If ( cPaisLoc=="BRA" )
0532  		@li,036 PSAY nTgerIcm		Picture tm(nTGerIcm,15)
0533  	Else
0534  		@li,036 PSAY nTgImpNoInc		Picture tm(nTGImpNoInc,15)
0535  	EndIf
0536  	@li,052 PSAY STR0023			//"IPI :"
0537  	If ( cPaisLoc=="BRA" )
0538  		@li,063 PSAY nTgerIpi		Picture tm(nTGerIpi,15)
0539  	Else
0540  		@li,063 PSAY nTgImpInc		Picture tm(nTGImpInc,15)
0541  	EndIf
0542  	@li,080 PSAY STR0024			//"DESC.:"
0543  	@li,088 PSAY nTotDesco		Picture tm(nTotDesco,13)
0544  	@li,105 PSAY STR0025			//"TOTAL :"
0545  	@li,115 PSAY nTotGeral		Picture tm(nTotGeral,17)
0546  Endif
0547  
0548  If File(cIndex+OrdBagExt())
0549  	Ferase(cIndex+OrdBagExt())
0550  Endif
0551  
0552  Return .T.

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> 0568  STATIC Function ImprNota(lEnd)
Static 0568  STATIC Function ImprNota(lEnd)()
0569  li++
0570  @li,000 PSAY STR0026+SD1->D1_DOC+" " + SD1->D1_SERIE		//"NUMERO : "
0571  @li,026 PSAY STR0027 + Dtoc(D1_EMISSAO)		//"EMISSAO:"
0572  @li,045 PSAY STR0028 + Dtoc(D1_DTDIGIT)		//"DIG.: "
0573  @li,060 PSAY STR0029 + SD1->D1_TIPO				//"TIPO : "
0574  If SD1->D1_TIPO $ "BD"
0575  	@li,068 PSAY STR0030 + SD1->D1_FORNECE + " " + SD1->D1_LOJA		//" CLIENTE    : "
0576  	dbSelectArea("SA1")
0577  	dbSetOrder(1)
0578  	dbSeek( xFilial() + SD1->D1_FORNECE + SD1->D1_LOJA )
0579  	@li,092 PSAY SubStr(A1_NOME,1,34)
0580  Else
0581  	@li,068 PSAY STR0031 + SD1->D1_FORNECE + " " + SD1->D1_LOJA		//" FORNECEDOR : "
0582  	dbSelectArea("SA2")
0583  	dbSetOrder(1)
0584  	dbSeek( xFilial() + SD1->D1_FORNECE + SD1->D1_LOJA)
0585  	@li,092 PSAY SubStr(A2_NOME,1,34)
0586  EndIf
0587  dbselectArea("SD1")
0588  Return .T.

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> 0604  STATIC Function ImpSintet(lEnd,Tamanho)
Static 0604  STATIC Function ImpSintet(lEnd,Tamanho)()
0605  
0606  LOCAL titulo,cabec1,cabec2,nomeprog
0607  LOCAL nTotGeral,nTotGerIcm,nTGerIpi,nTGImpNoInc,nTGImpInc
0608  LOCAL lOper := .T.
0609  Local nValIcm,nValIpi,nValMerc,nImpInc,nImpNoInc,nImpos
0610  Private aImposto:={}
0611  
0612  titulo   :=STR0032	//"RELACAO DE NOTAS FISCAIS"
0613  cabec1   :=STR0033	//"NUMERO SER    DATA    CODIGO RAZAO SOCIAL                 PRACA           PGTO              ICM            IPI      TOTAL MERCADORIA"
0614  cabec2   :=STR0034	//"             EMISSAO  FORNEC "
0615  //                      123456 123 12/12/12 123456 123456789012345678901234567890 123456789012345  XXX      999,999,999.99 999,999,999.99 9,999,999,999.99
0616  //                      0         1         2         3         4         5         6         7         8         9         0         1         2         3
0617  //                      0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
0618  nTotGeral:=0
0619  nTGerIcm:=0
0620  nTGerIpi:=0
0621  nTGImpNoInc:=0
0622  nTGImpInc:=0
0623  nomeprog :="MATR080"
0624  
0625  dbSelectArea("SF4")
0626  dbSetOrder(1)
0627  
0628  dbselectArea("SF1")
0629  dbSetOrder(1)
0630  dbSeek(xFilial()+mv_par12+mv_par14,.T.)
0631  
0632  SetRegua(RecCount())		// Total de Elementos da regua
0633  
0634  Do While !Eof() .And. F1_FILIAL == xFilial() .And. F1_DOC <= mv_par13
0635  	IncRegua()				// Incrementa a regua
0645  		If F1_CANCEL == "S"
0646  			dbSkip()
0647  			Loop
0648  		EndIf
0650  	If lEnd
0651  		@PROW()+1,001 PSAY STR0013	//"CANCELADO PELO OPERADOR"
0652  		loper:=.F.
0653  		Exit
0654  	Endif
0655  	If F1_SERIE < mv_par14 .Or. F1_SERIE > mv_par15
0656  		dbSkip()
0657  		Loop
0658  	Endif
0659  	If F1_DTDIGIT < mv_par03 .or. F1_DTDIGIT > mv_par04
0660  		dbSkip()
0661  		Loop
0662  	EndIf
0663  	If F1_FORNECE < mv_par08 .or. F1_FORNECE > mv_par09
0664  		dbSkip()
0665  		Loop
0666  	EndIf
0667  
0668  	//éŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽ¨
0669  	//ü Verifica se e nova pagina           ü
0670  	//·ŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽë
0671  	If li > 56
0672  		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
0673  	Endif
0674  	nValMerc := 0
0675  	nValIcm  := 0
0676  	nValIpi  := 0
0677  	nImpInc	:= 0
0678  	nImpNoInc:= 0
0679  	//éŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽ¨
0680  	//ü Incluido para acumular valores considerando parametros  	  ü
0681  	//·ŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽë
0682  	dbSelectArea("SD1")
0683  	dbSetOrder(1)
0684  	If dbSeek(xFilial()+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA,.F.)
0685  		cNotAnt := xFilial()+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA
0686  		While !Eof() .And. cNotAnt == D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA
0693  			If lEnd
0694  				@PROW()+1,001 PSAY STR0013	//"CANCELADO PELO OPERADOR"
0695  				loper:=.F.
0696  				Exit
0697  			Endif
0699  				//éŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽ¨
0700  				//ü Despreza Nota Fiscal Cancelada.                              ü
0701  				//·ŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽë
0702  				If SF1->F1_CANCEL == "S"
0703  					dbSkip()
0704  					Loop
0705  				EndIf
0707  			IF D1_FORNECE < mv_par08 .or. D1_FORNECE > mv_par09
0708  				dbSkip()
0709  				Loop
0710  			Endif
0711  			If D1_COD < mv_par01 .or. D1_COD > mv_par02
0712  				dbSkip()
0713  				Loop
0714  			Endif
0715  			If D1_DTDIGIT < mv_par03 .or. D1_DTDIGIT > mv_par04
0716  				dbSkip()
0717  				Loop
0718  			Endif
0719  			If D1_GRUPO < mv_par06 .or. D1_GRUPO > mv_par07
0720  				dbSkip()
0721  				Loop
0722  			Endif
0723  			If D1_LOCAL < mv_par10 .Or. D1_LOCAL > mv_par11
0724  				dbSkip()
0725  				Loop
0726  			Endif
0727  			If D1_TES < mv_par16 .Or. D1_TES > mv_par17
0728  				dbSkip()
0729  				Loop
0730  			EndIf
0731  			//éŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽ¨
0732  			//ü Executa a validacao do filtro do usuario           	        ü
0733  			//·ŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽë
0734  			If !Empty(aReturn[7]) .And. !&(aReturn[7])
0735  				dbSkip()
0736  				Loop
0737  			EndIf
0738  			If ( cPaisLoc#"BRA" )
0739  				aImpostos:=TesImpInf(SD1->D1_TES)
0740  				For nY:=1 to Len(aImpostos)
0741  					cCampImp:="SD1->"+(aImpostos[nY][2])
0742  					If Type("SF1->F1_TXMOEDA")#"U"
0743  						nImpos:=xMoeda(&cCampImp,SF1->F1_MOEDA,1,SF1->F1_EMISSAO,,SF1->F1_TXMOEDA)
0744  					Else	
0745  						nImpos:=&cCampImp
0746  					Endif	
0747  					If ( aImpostos[nY][3]=="S" )
0748  						nImpInc	+=nImpos
0749  					Else
0750  						nImpNoInc+=nImpos
0751  					EndIf
0752  				Next
0753  				If Type("SF1->F1_TXMOEDA")#"U"
0754  					nValMerc := nValMerc + xMoeda((D1_TOTAL - D1_VALDESC),SF1->F1_MOEDA,1,SF1->F1_EMISSAO,,SF1->F1_TXMOEDA)
0755  				Else	
0756  					nValMerc := nValMerc + D1_TOTAL - D1_VALDESC
0757  				Endif	
0758  			Else
0759  				nValMerc := nValMerc + D1_TOTAL - D1_VALDESC + D1_ICMSRET
0760  				nValIcm  += D1_VALICM
0761  				nValIpi  += D1_VALIPI
0762  				dbSelectArea("SF4")
0763  				If dbSeek(xFilial()+SD1->D1_TES)
0764  					nValMerc+=IF(SF1->F1_TIPO!="P".And.SF4->F4_IPI!="R",SD1->D1_VALIPI,0)
0765  				Else
0766  					nValMerc+=IF(SF1->F1_TIPO!="P",SD1->D1_VALIPI,0)
0767  				EndIf
0768  			EndIf
0769  			dbSelectArea("SD1")
0770  			dbSkip()
0771  		End
0772  	EndIf
0773  	dbSelectArea("SF1")
0774  	If (nValMerc+nValipi+nValicm+nImpInc+nImpNoInc) > 0
0775  		//éŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽ¨
0776  		//ü Imprime a linha da nota fiscal                               ü
0777  		//·ŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽë
0778  		@li,000 PSAY F1_DOC
0779  		@li,013 PSAY F1_SERIE
0780  		@li,017 PSAY F1_EMISSAO
0781  		@li,028 PSAY F1_FORNECE
0782  		If SF1->F1_TIPO $ "BD"
0783  			dbSelectArea("SA1")
0784  			dbSetOrder(1)
0785  			dbSeek( xFilial() + SF1->F1_FORNECE + SF1->F1_LOJA )
0786  			@li,035 PSAY SubStr(A1_NOME,1,22)
0787  			@li,058 PSAY SubStr(A1_MUN,1,15)
0788  		Else
0789  			dbSelectArea("SA2")
0790  			dbSetOrder(1)
0791  			dbSeek( xFilial() + SF1->F1_FORNECE + SF1->F1_LOJA)
0792  			@li,035 PSAY SubStr(A2_NOME,1,22)
0793  			@li,058 PSAY SubStr(A2_MUN,1,15)
0794  		EndIf
0795  		dbSelectArea("SF1")
0796  		@li,074 PSAY F1_COND    Picture "!!!"
0797  		If ( cPaisLoc=="BRA" )
0798  			@li,084 PSAY nValIcm    Picture tm(F1_VALICM ,14)
0799  			@li,099 PSAY nValIpi    Picture tm(F1_VALIPI ,14)
0800  			@li,115 PSAY (nValMerc+F1_FRETE+F1_DESPESA)   Picture tm(F1_VALMERC,17)
0801  		Else
0802  			@li,084 PSAY nImpNoInc    Picture tm(F1_VALIMP1 ,14)
0803  			@li,099 PSAY nImpInc    Picture tm(F1_VALIMP1 ,14)
0804  			If Type("SF1->F1_TXMOEDA")#"U"
0805  				@li,115 PSAY (nValMerc+xMoeda((F1_FRETE+F1_DESPESA),SF1->F1_MOEDA,1,SF1->F1_EMISSAO,,SF1->F1_TXMOEDA))   Picture tm(F1_VALMERC,17)
0806  			Else	
0807  				@li,115 PSAY (nValMerc+F1_FRETE+F1_DESPESA)   Picture tm(F1_VALMERC,17)
0808  			Endif	
0809  		EndIf
0810  		li++
0811  		If ( cPaisLoc=="BRA" )
0812  			nTgerIcm += nValIcm
0813  			nTgerIpi += nValIpi
0814  		Else
0815  			nTgImpInc+=nImpInc
0816  			nTgImpNoInc+=nImpNoInc
0817  		EndIf
0818  		If cPaisLoc<>"BRA".and.Type("SF1->F1_TXMOEDA")#"U"
0819  			nTotGeral:= nTotGeral + nValMerc + xMoeda((F1_FRETE + F1_DESPESA),SF1->F1_MOEDA,1,SF1->F1_EMISSAO,,SF1->F1_TXMOEDA)
0820  		Else	
0821  			nTotGeral:= nTotGeral + nValMerc + F1_FRETE + F1_DESPESA
0822  		Endif	
0823  	Endif
0824  	SF1->(dbSkip())
0825  End
0826  
0827  If lOper
0828  	li++
0829  	@li,000 PSAY Replicate("-",132)
0830  	li++
0831  	@li,025 PSAY STR0035	//"T O T A L  G E R A L : "
0832  	If ( cPaisLoc=="BRA" )
0833  		@li,084 PSAY nTgerIcm  Picture tm(nTGerIcm,14)
0834  		@li,099 PSAY nTgerIpi  Picture tm(nTGerIpi,14)
0835  	Else
0836  		@li,084 PSAY nTgImpNoInc  Picture tm(nTGImpNoInc,14)
0837  		@li,099 PSAY nTgImpInc  Picture tm(nTGImpInc,14)
0838  	Endif
0839  	@li,115 PSAY nTotGeral Picture tm(nTotGeral,17)
0840  	li++
0841  	@li,000 PSAY Replicate("-",132)
0842  Endif
0843  
0844  Return .T.

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> 0860  Static Function ImpProduto(lEnd,Tamanho)
Static 0860  Static Function ImpProduto(lEnd,Tamanho)()
0861  LOCAL nCodAnt,nTotProd,nTotGer,titulo,cabec1,cabec2,cCabec,nomeprog
0862  LOCAL nQuebra,nTotQger
0863  nTotProd := 0
0864  nTotquant:= 0
0865  nTotGer  := 0
0866  nTotQGer := 0
0867  
0868  titulo  :=STR0010	//"RELACAO DE NOTAS FISCAIS"
0869  cabec1  :=STR0036	//"RELACAO DAS NOTAS FISCAIS DE COMPRAS"
0870  cabec2  :=" "
0871  cCabec  :=STR0037	//"NUMERO EMISSAO  FORNECEDOR  R A Z A O  S O C I A L           LC CFO TE  ICM   IPI   TP    QUANTIDADE VALOR UNITARIO      VALOR TOTAL"
0872  //                             1         2         3         4         5         6         7         8         9        10        11        12        13
0873  //                   0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
0874  
0875  nomeprog:="MATR080"
0876  nQuebra := 0
0877  
0878  dbselectArea("SD1")
0879  dbSetOrder(2)
0880  dbSeek(xFilial()+mv_par01,.T.)
0881  
0882  SetRegua(RecCount())		// Total de Elementos da regua
0883  
0884  While !Eof().And.D1_FILIAL = xFilial() .And. SD1->D1_COD >= mv_par01 ;
0885  		.And. SD1->D1_COD <= mv_par02
0886  
0893  	If lEnd
0894  		@PROW()+1,001 PSAY STR0013	//"CANCELADO PELO OPERADOR"
0895  		loper:=.F.
0896  		Exit
0897  	Endif
0898  
0899  	IncRegua()		// Incrementa a regua
0904  		If D1_CANCEL == "S"
0905  			dbSkip()
0906  			Loop
0907  		EndIf
0909  
0910  	//éŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽ¨
0911  	//ü Verifica o numero da Nota Fiscal                    			  ü
0912  	//·ŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽë
0913  	IF D1_DOC < mv_par12 .or. D1_DOC > mv_par13
0914  		dbSkip()
0915  		Loop
0916  	Endif
0917  	//éŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽ¨
0918  	//ü Verifica a serie da Nota Fiscal                    			  ü
0919  	//·ŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽë
0920  	IF D1_SERIE < mv_par14 .or. D1_SERIE > mv_par15
0921  		dbSkip()
0922  		Loop
0923  	Endif
0924  	//éŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽ¨
0925  	//ü Verifica a Faixa De Data de Digitacao               			  ü
0926  	//·ŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽë
0927  	IF D1_DTDIGIT < mv_par03 .or. D1_DTDIGIT > mv_par04
0928  		dbSkip()
0929  		Loop
0930  	Endif
0931  	//éŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽ¨
0932  	//ü Verifica a Faixa Do Grupo do Produto               	        ü
0933  	//·ŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽë
0934  	IF D1_GRUPO < mv_par06 .or. D1_GRUPO > mv_par07
0935  		dbSkip()
0936  		Loop
0937  	Endif
0938  	//éŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽ¨
0939  	//ü Verifica Fornecedor                                	        ü
0940  	//·ŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽë
0941  	IF D1_FORNECE < mv_par08 .or. D1_FORNECE > mv_par09
0942  		dbSkip()
0943  		Loop
0944  	Endif
0945  	//éŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽ¨
0946  	//ü Verifica local                				 						  ü
0947  	//·ŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽë
0948  	If D1_LOCAL < mv_par10 .Or. D1_LOCAL > mv_par11
0949  		dbSkip()
0950  		Loop
0951  	EndIf
0952  	//éŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽ¨
0953  	//ü Verifica Tes                  				 						  ü
0954  	//·ŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽë
0955  	If D1_TES < mv_par16 .Or. D1_TES > mv_par17
0956  		dbSkip()
0957  		Loop
0958  	EndIf
0959  
0960  	//éŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽ¨
0961  	//ü Executa a validacao do filtro do usuario           	        ü
0962  	//·ŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽë
0963  	If !Empty(aReturn[7]) .And. !&(aReturn[7])
0964  		dbSkip()
0965  		Loop
0966  	EndIf
0967  
0968  	If li > 56
0969  		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
0970  	Endif
0971  
0972  	If nQuebra == 0
0973  		@li,000 PSAY STR0038 + SD1->D1_COD		//"PRODUTO : "
0974  		dbSelectArea("SB1")
0975  		dbSetOrder(1)
0976  		If dbSeek(xFilial()+SD1->D1_COD)
0977  			@li,27 PSAY STR0039		//"DESCRICAO : "
0978  			@li,40 PSAY SubStr(b1_desc,1,30)
0979  		Endif
0980  		@li ,72 PSAY STR0040			//"GRUPO : "
0981  		@li ,81 PSAY SB1->B1_GRUPO
0982  		dbselectArea("SD1")
0983  		li++
0984  		@li,000 PSAY cCabec
0985  		nQuebra := 1
0986  		nCodAnt := SD1->D1_COD
0987  		nTotProd:= 0
0988  		nTotQuant:= 0
0989  	Endif
0990  	If nCodant != SD1->D1_COD
0991  		nQuebra := 0
0992  		li++
0993  		@li,000  PSAY STR0041		//"TOTAL DO PRODUTO : "
0994  		@li,084  PSAY  nTotQuant Picture TM(D1_TOTAL,16)
0995  		@li,115  PSAY  nTotProd  Picture TM(D1_TOTAL,17)
0996  		li++
0997  		@li,000 PSAY Replicate("-",132)
0998  		li++
0999  		nTotQger+=  nTotQuant
1000  		nTotGer +=  nTotProd
1001  		Loop
1002  	Endif
1003  
1004  	If li > 56
1005  		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
1006  	Endif
1007  
1008  	li++
1009  	@li,00 PSAY D1_DOC
1010  	@li,13 PSAY D1_EMISSAO
1011  	@li,24 PSAY D1_FORNECE
1012  	If SD1->D1_TIPO $ "BD"
1013  		dbSelectArea("SA1")
1014  		dbSetOrder(1)
1015  		dbSeek(xFilial()+SD1->D1_FORNECE+SD1->D1_LOJA)
1016  		@li,034 PSAY SUBSTR(A1_NOME,1,26)
1017  	Else
1018  		dbSelectArea("SA2")
1019  		dbSetOrder(1)
1020  		dbSeek(xFilial()+SD1->D1_FORNECE+SD1->D1_LOJA)
1021  		@li,034 PSAY SUBSTR(A2_NOME,1,26)
1022  	EndIf
1023  	dbSelectArea("SD1")
1024  	@li,061 PSAY D1_LOCAL
1025  	If cPaisLoc=="BRA"
1026  		@li,064 PSAY D1_CF
1027  	Endif
1028  
1029  	@li,068 PSAY D1_TES
1030  
1031  	If ( cPaisLoc=="BRA" )
1032  		@li,072 PSAY D1_PICM		Picture PesqPict("SD1","D1_PICM",5)
1033  	EndIf
1034  	@li,078 PSAY D1_IPI		Picture PesqPict("SD1","D1_IPI",5)
1035  	@li,084 PSAY D1_TIPO
1036  	@li,087 PSAY D1_QUANT	Picture TM(D1_QUANT,13)
1037     If cPaisLoc<>"BRA".and.Type("SF1->F1_TXMOEDA")#"U"	
1038  	   SF1->(dBSetOrder(1))
1039  	   SF1->(dBSeek(xFilial()+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA))
1040  		@li,101 PSAY xMoeda(D1_VUNIT,SF1->F1_MOEDA,1,SF1->F1_EMISSAO,,SF1->F1_TXMOEDA)	Picture TM(D1_VUNIT,14)
1041  		@li,116 PSAY xMoeda((D1_TOTAL - D1_VALDESC + D1_ICMSRET),SF1->F1_MOEDA,1,SF1->F1_EMISSAO,,SF1->F1_TXMOEDA)	Picture TM(D1_TOTAL,16)
1042  		nTotProd+=xMoeda((D1_TOTAL - D1_VALDESC + D1_ICMSRET),SF1->F1_MOEDA,1,SF1->F1_EMISSAO,,SF1->F1_TXMOEDA)
1043  	Else
1044  		@li,101 PSAY D1_VUNIT	Picture TM(D1_VUNIT,14)
1045  		@li,116 PSAY D1_TOTAL - D1_VALDESC + D1_ICMSRET	Picture TM(D1_TOTAL,16)
1046  		nTotProd+=D1_TOTAL - D1_VALDESC + D1_ICMSRET
1047  	Endif	
1048  	nTotQuant+=D1_QUANT
1049  	dbSkip()
1050  EndDo
1051  
1052  li++
1053  @li,000  PSAY STR0041		//"TOTAL DO PRODUTO : "
1054  @li,084  PSAY  nTotQuant Picture TM(D1_TOTAL,16)
1055  @li,115  PSAY  nTotProd  Picture TM(D1_TOTAL,17)
1056  li++
1057  @li,000  PSAY Replicate("-",132)
1058  li++
1059  nTotGer  += nTotProd
1060  nTotQGer += nTotQuant
1061  
1062  @li,000  PSAY STR0042	//"T O T A L  G E R A L : "
1063  @li,084  PSAY  nTotQger  Picture TM(D1_TOTAL,16)
1064  @li,115  PSAY  nTotGer   Picture tm(nTotGer,17)
1065  
1066  Return .T.
1067  
1068  

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> 1084  Static Function ImpDataDig(lEnd,Tamanho)
Static 1084  Static Function ImpDataDig(lEnd,Tamanho)()
1085  LOCAL dDataAnt,nTotData,nTotGer,titulo,cabec1,cabec2,cCabec,nomeprog
1086  LOCAL nQuebra
1087  nTotData := 0
1088  nTotGer  := 0
1089  
1090  titulo  :=STR0010	//"RELACAO DE NOTAS FISCAIS"
1091  cabec1  :=STR0036	//"RELACAO DAS NOTAS FISCAIS DE COMPRAS"
1092  cabec2  :=" "
1093  cCabec  :=STR0044	//"NUMERO       PRODUTO         FORNECEDOR  RAZAO  SOCIAL        LC CFO TE  ICM   IPI   TP    QUANTIDADE VALOR UNITARIO      VALOR TOTAL"
1094  //                   123456789012 123456789012345 123456 1234567890123456789012345 12 123
1095  //                             1         2         3         4         5         6         7         8         9        10        11        12        13
1096  //                   0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
1097  
1098  nomeprog:="MATR080"
1099  nQuebra := 0
1100  
1101  dbselectArea("SD1")
1102  dbSetOrder(6)
1103  dbSeek(xFilial()+DTOS(mv_par03),.T.)
1104  
1105  SetRegua(RecCount())		// Total de Elementos da regua
1106  
1107  While !Eof().And.D1_FILIAL = xFilial() .And. SD1->D1_DTDIGIT >= mv_par03 ;
1108  		.And. SD1->D1_DTDIGIT <= mv_par04
1109  
1116  	If lEnd
1117  		@PROW()+1,001 PSAY STR0013	//"CANCELADO PELO OPERADOR"
1118  		loper:=.F.
1119  		Exit
1120  	Endif
1121  
1122  	IncRegua()		// Incrementa a regua
1123  
1124  	//éŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽ¨
1125  	//ü Verifica a Faixa Do Codigo do Produto               			  ü
1126  	//·ŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽë
1127  	If D1_COD < mv_par01 .or. D1_COD > mv_par02
1128  		dbSkip()
1129  		Loop
1130  	Endif
1131  
1132  	//éŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽ¨
1133  	//ü Verifica o numero da Nota Fiscal                    			  ü
1134  	//·ŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽë
1135  	IF D1_DOC < mv_par12 .or. D1_DOC > mv_par13
1136  		dbSkip()
1137  		Loop
1138  	Endif
1139  	//éŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽ¨
1140  	//ü Verifica a serie da Nota Fiscal                    			  ü
1141  	//·ŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽë
1142  	IF D1_SERIE < mv_par14 .or. D1_SERIE > mv_par15
1143  		dbSkip()
1144  		Loop
1145  	Endif
1146  	//éŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽ¨
1147  	//ü Verifica a Faixa Do Grupo do Produto               	        ü
1148  	//·ŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽë
1149  	IF D1_GRUPO < mv_par06 .or. D1_GRUPO > mv_par07
1150  		dbSkip()
1151  		Loop
1152  	Endif
1153  	//éŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽ¨
1154  	//ü Verifica Fornecedor                                	        ü
1155  	//·ŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽë
1156  	IF D1_FORNECE < mv_par08 .or. D1_FORNECE > mv_par09
1157  		dbSkip()
1158  		Loop
1159  	Endif
1160  	//éŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽ¨
1161  	//ü Verifica local                				 						  ü
1162  	//·ŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽë
1163  	If D1_LOCAL < mv_par10 .Or. D1_LOCAL > mv_par11
1164  		dbSkip()
1165  		Loop
1166  	EndIf
1167  	//éŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽ¨
1168  	//ü Verifica Tes                  				 						  ü
1169  	//·ŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽë
1170  	If D1_TES < mv_par16 .Or. D1_TES > mv_par17
1171  		dbSkip()
1172  		Loop
1173  	EndIf
1174  
1175  	//éŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽ¨
1176  	//ü Executa a validacao do filtro do usuario           	        ü
1177  	//·ŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽŽë
1178  	If !Empty(aReturn[7]) .And. !&(aReturn[7])
1179  		dbSkip()
1180  		Loop
1181  	EndIf
1182  
1183  	If li > 56
1184  		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
1185  	Endif
1186  
1187  	If nQuebra == 0
1188  		@li,000 PSAY STR0045	//"DATA DE DIGITACAO : "
1189  		@li,020 PSAY SD1->D1_DTDIGIT
1190  		li++
1191  		@li,000 PSAY cCabec
1192  		nQuebra := 1
1193  		dDataAnt := SD1->D1_DTDIGIT
1194  		nTotData:= 0
1195  	Endif
1196  	If dDataAnt != SD1->D1_DTDIGIT
1197  		nQuebra := 0
1198  		li++
1199  		@li,000  PSAY STR0046		//"TOTAL NA DATA : "
1200  		@li,116  PSAY  nTotData  Picture TM(D1_TOTAL,17)
1201  		li++
1202  		@li,000 PSAY Replicate("-",132)
1203  		li++
1204  		nTotGer +=  nTotData
1205  		Loop
1206  	Endif
1207  
1208  	If li > 56
1209  		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
1210  	Endif
1211  
1212  	li++
1213  	@li,00 PSAY D1_DOC
1214  	@li,13 PSAY D1_COD
1215  	@li,29 PSAY D1_FORNECE
1216  	If SD1->D1_TIPO $ "BD"
1217  		dbSelectArea("SA1")
1218  		dbSetOrder(1)
1219  		dbSeek(xFilial()+SD1->D1_FORNECE+SD1->D1_LOJA)
1220  		@li,036 PSAY SUBSTR(A1_NOME,1,25)
1221  	Else
1222  		dbSelectArea("SA2")
1223  		dbSetOrder(1)
1224  		dbSeek(xFilial()+SD1->D1_FORNECE+SD1->D1_LOJA)
1225  		@li,036 PSAY SUBSTR(A2_NOME,1,25)
1226  	EndIf
1227  	dbSelectArea("SD1")
1228  	@li,062 PSAY D1_LOCAL
1229  	If cPaisLoc=="BRA"
1230  		@li,065 PSAY D1_CF
1231  	Endif
1232  
1233  	@li,069 PSAY D1_TES
1234  
1235  	If ( cPaisLoc=="BRA" )
1236  		@li,073 PSAY D1_PICM		Picture PesqPict("SD1","D1_PICM",5)
1237  	EndIf
1238  	@li,079 PSAY D1_IPI		Picture PesqPict("SD1","D1_IPI",5)
1239  	@li,085 PSAY D1_TIPO
1240  	@li,088 PSAY D1_QUANT	Picture TM(D1_QUANT,13)
1241     If cPaisLoc<>"BRA".and.Type("SF1->F1_TXMOEDA")#"U"	
1242  	   SF1->(dBSetOrder(1))
1243  	   SF1->(dBSeek(xFilial()+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA))
1244  		@li,102 PSAY xMoeda(D1_VUNIT,SF1->F1_MOEDA,1,SF1->F1_EMISSAO,,SF1->F1_TXMOEDA)	Picture TM(D1_VUNIT,14)
1245  		@li,117 PSAY xMoeda((D1_TOTAL - D1_VALDESC + D1_ICMSRET),SF1->F1_MOEDA,1,SF1->F1_EMISSAO,,SF1->F1_TXMOEDA)	Picture TM(D1_TOTAL,16)
1246  		nTotData+= xMoeda((D1_TOTAL - D1_VALDESC + D1_ICMSRET),SF1->F1_MOEDA,1,SF1->F1_EMISSAO,,SF1->F1_TXMOEDA)
1247  	Else
1248  		@li,102 PSAY D1_VUNIT	Picture TM(D1_VUNIT,14)
1249  		@li,117 PSAY D1_TOTAL - D1_VALDESC + D1_ICMSRET	Picture TM(D1_TOTAL,16)
1250  		nTotData+=D1_TOTAL - D1_VALDESC + D1_ICMSRET
1251  	Endif	
1252  	dbSkip()
1253  EndDo
1254  
1255  li++
1256  @li,000  PSAY STR0046		//"TOTAL NA DATA : "
1257  @li,116  PSAY  nTotData  Picture TM(D1_TOTAL,17)
1258  li++
1259  @li,000  PSAY Replicate("-",132)
1260  li++
1261  nTotGer  += nTotData
1262  
1263  @li,000  PSAY STR0042	//"T O T A L  G E R A L : "
1264  @li,116  PSAY  nTotGer   Picture tm(nTotGer,17)
1265  
1266  Return .T.
