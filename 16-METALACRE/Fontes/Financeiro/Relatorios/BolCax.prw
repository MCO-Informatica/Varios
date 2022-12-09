#INCLUDE "RWMAKE.CH"
#include "protheus.ch"

//.==============================================================.
//|                                          |
//|--------------------------------------------------------------|
//| Programa : LIFIN02.PRW      | Autor: Microsiga               |
//|--------------------------------------------------------------|
//| Descricao: Boleto CAIXA ECONÔMICA FEDERAL                    |
//|                                                              |
//|--------------------------------------------------------------|
//| Data criacao  : 19/03/2007  | Ultima alteracao:              |
//|--------------------------------------------------------------|
//|                                                              |
//.==============================================================.
User Function BolCax(aDnfBol)
LOCAL	aPergs := {} 
PRIVATE lExec    := .F.
PRIVATE cIndexName := ''
PRIVATE cIndexKey  := ''
PRIVATE cFilter    := ''   
Private lAutoEMA   := .f.

DEFAULT	aDnfBol	:=	{}

Tamanho  := "M"
titulo   := "Impressao de Boleto com Codigo de Barras-Caixa Economica"
cDesc1   := "Este programa destina-se a impressao do Boleto com Codigo de Barras."
cDesc2   := ""
cDesc3   := ""
cString  := "SE1"
wnrel    := "BOLETO"
lEnd     := .F.
cPerg     :=PadR("BLTCAX",10)
aReturn  := {"Zebrado", 1,"Administracao", 2, 2, 1, "",1 }   
nLastKey := 0

dbSelectArea("SE1")

Aadd(aPergs,{"De Prefixo","","","mv_ch1","C",3,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Ate Prefixo","","","mv_ch2","C",3,0,0,"G","","MV_PAR02","","","","ZZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"De Numero","","","mv_ch3","C",9,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Ate Numero","","","mv_ch4","C",9,0,0,"G","","MV_PAR04","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"De Parcela","","","mv_ch5","C",2,0,0,"G","","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Ate Parcela","","","mv_ch6","C",2,0,0,"G","","MV_PAR06","","","","Z","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"De Portador","","","mv_ch7","C",3,0,0,"G","","MV_PAR07","","","","","","","","","","","","","","","","","","","","","","","","","SA6","","","",""})
Aadd(aPergs,{"Ate Portador","","","mv_ch8","C",3,0,0,"G","","MV_PAR08","","","","ZZZ","","","","","","","","","","","","","","","","","","","","","SA6","","","",""})
Aadd(aPergs,{"De Cliente","","","mv_ch9","C",6,0,0,"G","","MV_PAR09","","","","","","","","","","","","","","","","","","","","","","","","","SE1","","","",""})
Aadd(aPergs,{"Ate Cliente","","","mv_cha","C",6,0,0,"G","","MV_PAR10","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","SE1","","","",""})
Aadd(aPergs,{"De Loja","","","mv_chb","C",2,0,0,"G","","MV_PAR11","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Ate Loja","","","mv_chc","C",2,0,0,"G","","MV_PAR12","","","","ZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"De Emissao","","","mv_chd","D",8,0,0,"G","","MV_PAR13","","","","01/01/80","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Ate Emissao","","","mv_che","D",8,0,0,"G","","MV_PAR14","","","","31/12/03","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"De Vencimento","","","mv_chf","D",8,0,0,"G","","MV_PAR15","","","","01/01/80","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Ate Vencimento","","","mv_chg","D",8,0,0,"G","","MV_PAR16","","","","31/12/03","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Do Bordero","","","mv_chh","C",6,0,0,"G","","MV_PAR17","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Ate Bordero","","","mv_chi","C",6,0,0,"G","","MV_PAR18","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Linha Obs 1","","","mv_chj","C",60,0,0,"G","","MV_PAR19","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Linha Obs 2","","","mv_chj","C",60,0,0,"G","","MV_PAR20","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Linha Obs 3","","","mv_chj","C",60,0,0,"G","","MV_PAR21","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Banco","","","mv_chk","C",3,0,0,"G","","MV_PAR22","","","","","","","","","","","","","","","","","","","","","","","","","SA6","","","",""})
Aadd(aPergs,{"Agencia","","","mv_chk","C",5,0,0,"G","","MV_PAR23","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Conta","","","mv_chk","C",10,0,0,"G","","MV_PAR24","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Sub-Conta","","","mv_chk","C",3,0,0,"G","","MV_PAR25","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

AjustaSx1(cPerg,aPergs)
If !Empty(Len(aDnfBol))
	Pergunte (cPerg,.f.)
Else
	If !Pergunte (cPerg,.T.)
		Return ''
	Endif
Endif	
If Empty(Len(aDnfBol))
	lAutoEMA := .F.
Else
	MV_PAR22 := PadR(GetNewPar("MV_BOXBCO","104"),3)
	MV_PAR23 := PadR(GetNewPar("MV_BOXAGE","0252 "),5)
	MV_PAR24 := PadR(GetNewPar("MV_BOXCON","37847     "),10)
	MV_PAR25 := PadR(GetNewPar("MV_BOXSUB","001"),3)
	
	lAutoEMA := .T.
Endif
  

//LimpaFlag()

If Empty(Len(aDnfBol))
	cIndexName	:= Criatrab(Nil,.F.)
	cIndexKey	:= "E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+DTOS(E1_EMISSAO)+E1_PORTADO+E1_CLIENTE"
	cFilter		+= "E1_FILIAL=='"+xFilial("SE1")+"'.And.E1_SALDO>0.And. "
	cFilter		+= "E1_PREFIXO>='" + MV_PAR01 + "'.And.E1_PREFIXO<='" + MV_PAR02 + "'.And. " 
	cFilter		+= "E1_NUM>='" + MV_PAR03 + "'.And.E1_NUM<='" + MV_PAR04 + "'.And. "
	cFilter		+= "E1_PARCELA>='" + MV_PAR05 + "'.And.E1_PARCELA<='" + MV_PAR06 + "'.And. "
	cFilter		+= "E1_PORTADO>='" + MV_PAR07 + "'.And.E1_PORTADO<='" + MV_PAR08 + "'.And. "
	cFilter		+= "E1_CLIENTE>='" + MV_PAR09 + "'.And.E1_CLIENTE<='" + MV_PAR10 + "'.And. "
	cFilter		+= "E1_LOJA>='" + MV_PAR11 + "'.And.E1_LOJA<='"+MV_PAR12+"'.And. "
	cFilter		+= "DTOS(E1_EMISSAO)>='"+DTOS(mv_par13)+"'.and.DTOS(E1_EMISSAO)<='"+DTOS(mv_par14)+"' .And. "
	cFilter		+= "DTOS(E1_VENCREA)>='"+DTOS(mv_par15)+"'.and.DTOS(E1_VENCREA)<='"+DTOS(mv_par16)+"' .And. "
	cFilter		+= "E1_NUMBOR>='" + MV_PAR17 + "'.And.E1_NUMBOR<='" + MV_PAR18 + "'.And. "
	cFilter		+= "!(E1_TIPO$MVABATIM) "
	
	IndRegua("SE1", cIndexName, cIndexKey,, cFilter, "Aguarde selecionando registros....")
	DbSelectArea("SE1")
	#IFNDEF TOP
		DbSetIndex(cIndexName + OrdBagExt())
	#ENDIF
	dbGoTop()
Endif
If Empty(Len(aDnfBol))
	@ 001,001 TO 400,700 DIALOG oDlg TITLE "Seleção de Titulos"
	@ 001,001 TO 170,350 BROWSE "SE1" MARK "E1_OK"
	@ 180,310 BMPBUTTON TYPE 01 ACTION (lExec := .T.,Close(oDlg))
	@ 180,280 BMPBUTTON TYPE 02 ACTION (lExec := .F.,Close(oDlg))
	ACTIVATE DIALOG oDlg CENTERED
Endif
cArquivo := ''
If lExec .Or. lAutoEMA
	Processa({|lEnd|cArquivo := MontaRel(aDnfBol)})
Endif
If Empty(Len(aDnfBol))
	RetIndex("SE1")
	Ferase(cIndexName+OrdBagExt())
Endif
Return cArquivo

//.==============================================================.
//|                IMOBILIARIA LINHAM                            |
//|--------------------------------------------------------------|
//| Programa : MONTAREL.PRW     | Autor: Microsiga               |
//|--------------------------------------------------------------|
//| Descricao: Boleto CEF                                        |
//|                                                              |
//|--------------------------------------------------------------|
//| Data criacao  : 19/03/2007  | Ultima alteracao:              |
//|--------------------------------------------------------------|
//|                                                              |
//.==============================================================.
Static Function MontaRel(aDnfBol)
Local nJuros := 0.1333
Local nMulta := 0.1333
LOCAL   oPrint
LOCAL   n := 0
LOCAL aBitmap := "\SYSTEM\CEF.BMP"

LOCAL aDadosEmp    := {	SM0->M0_NOMECOM                                                             ,; //[1]Nome da Empresa
SM0->M0_ENDCOB                                                    			,; //[2]Endereço
AllTrim(SM0->M0_BAIRCOB)+", "+AllTrim(SM0->M0_CIDCOB)+", "+SM0->M0_ESTCOB	,; //[3]Complemento
"CEP: "+Subs(SM0->M0_CEPCOB,1,5)+"-"+Subs(SM0->M0_CEPCOB,6,3)             	,; //[4]CEP
"PABX/FAX: "+SM0->M0_TEL                                                    ,; //[5]Telefones
"C.N.P.J.: "+Subs(SM0->M0_CGC,1,2)+"."+Subs(SM0->M0_CGC,3,3)+"."+          	;  //[6]
Subs(SM0->M0_CGC,6,3)+"/"+Subs(SM0->M0_CGC,9,4)+"-"+                       	;  //[6]
Subs(SM0->M0_CGC,13,2)                                                     	,; //[6]CGC
"I.E.: "+Subs(SM0->M0_INSC,1,3)+"."+Subs(SM0->M0_INSC,4,3)+"."+            	;  //[7]
Subs(SM0->M0_INSC,7,3)+"."+Subs(SM0->M0_INSC,10,3)                         	}  //[7]I.E

LOCAL aDadosTit
LOCAL aDatSacado


LOCAL i            := 1
LOCAL CB_RN_NN     := {}
LOCAL nRec         := 0
LOCAL _nVlrAbat    := 0

Private aDadosBanco


oPrint:= TMSPrinter():New( "Boleto Laser" )
oPrint:SetPortrait()
oPrint:Setup()
oPrint:StartPage()
dbSelectArea("SE1")
dbGoTop()
ProcRegua(10)

DbSelectArea("SE1")
If !Empty(Len(aDnfBol))
	ProcRegua(Len(aDnfBol))

	For nI := 1 To Len(aDnfBol)
		IncProc()
		
		If !SE1->(dbSetOrder(1), dbSeek(xFilial("SE1")+aDnfBol[nI,1]+aDnfBol[nI,2]+aDnfBol[nI,3]))
			Loop
		Endif
	
		DbSelectArea("SA6")
		DbSetOrder(1)
		If ! DbSeek(xFilial("SA6")+MV_PAR22+MV_PAR23+MV_PAR24,.T.)
			alert("Erro na leitura dos dados do banco !")
			return nil
		end if
		
		If !SEE->(dbSetOrder(1), dbSeek(xFilial("SEE")+MV_PAR22+MV_PAR23+MV_PAR24+MV_PAR25))
			alert("Erro na leitura dos dados bancarios !")
			return nil
		end if

		If Empty(SE1->E1_NUMBCO)
			_cNossoNum := '14'+StrZero(Val(NossoNum()),15)
		Else
			_cNossoNum := '14'+StrZero(Val(Alltrim(SE1->E1_NUMBCO)),15)
		Endif
		
		
		DbSelectArea("SA1")
		DbSetOrder(1)
		DbSeek(xFilial()+SE1->E1_CLIENTE+SE1->E1_LOJA)
		DbSelectArea("SE1")
		
		aDadosBanco  := {SA6->A6_COD         		        ,; // [1]Numero do Banco
							 	SA6->A6_NREDUZ    	                                ,; // [2]Nome do Banco
								Left(SA6->A6_AGENCIA,4)                             ,; // [3]Agência
								Left(SA6->A6_NUMCON,7)								,; // [4]Conta Corrente
								SA6->A6_DVCTA  						,; // [5]Dígito da conta corrente
								"RG"                                          		,; // [6]Codigo da Carteira
								Alltrim(SEE->EE_CODEMP)                             ,;  // [7]Cedente
								''}
		
		aDatSacado   := {AllTrim(SA1->A1_NOME)                            	,;     // [1]Razão Social
		AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA           	,;     // [2]Código
		AllTrim(SA1->A1_END )+"-"+AllTrim(SA1->A1_BAIRRO)	,;     // [3]Endereço
		AllTrim(SA1->A1_MUN )                             	,;     // [4]Cidade
		SA1->A1_EST                                      	,;     // [5]Estado
		SA1->A1_CEP                                       	,;     // [6]CEP
		SA1->A1_CGC                                       	,;     // [7]CGC
		SA1->A1_CGC									  		}      // [8]TIPO
		
		_nVlrAbat   :=  SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)
		_nDecresc  :=  SE1->E1_DECRESC
		_nAcresc   :=  SE1->E1_ACRESC
		
		

		aBolText := {}
		AAdd(aBolText, "NAO RECEBER APOS 120 DIAS DE ATRASO")
		AAdd(aBolText, "")
		Aadd(aBolText, "JUROS : R$ "+Alltrim(TrANSFORM((SE1->E1_SALDO - _nVlrAbat - _nDecresc + _nAcresc ) * nJuros / 100,"@E 999,999.99"))+" REAIS AO DIA ")
		AAdd(aBolText, "")
		//Aadd(aBolText, "MULTA : R$ "+Alltrim(TrANSFORM(SE1->E1_VALOR * nMulta / 100,"@E 999,999.99"))+" REAIS A PARTIR DE "+DtoC(SE1->E1_VENCREA+1))
		
	
		CB_RN_NN    := Ret_cBarra(Subs(aDadosBanco[1],1,3),aDadosBanco[3],aDadosBanco[4],aDadosBanco[5],AllTrim(_cNossoNum),(SE1->E1_SALDO - _nVlrAbat - _nDecresc + _nAcresc ),Datavalida(E1_VENCREA,.T.),aDadosBanco[7])
		
		aDadosTit    := {AllTrim(E1_NUM)+AllTrim(E1_PARCELA)		,;  // [1] Número do título
		E1_EMISSAO                              					,;  // [2] Data da emissão do título
		Date()                                  					,;  // [3] Data da emissão do boleto
		Datavalida(E1_VENCREA,.T.)                  					,;  // [4] Data do vencimento
		(E1_SALDO - _nVlrAbat - _nDecresc + _nAcresc )              ,;  // [5] Valor do título
		CB_RN_NN[3]                             					,;  // [6] Nosso número (Ver fórmula para calculo)
		E1_PREFIXO                               					,;  // [7] Prefixo da NF
		E1_TIPO	                               						 }  // [8] Tipo do Titulo
		
		Impress(oPrint,aBitmap,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,CB_RN_NN,aBolText)
		n := n + 1
		
		If Empty(SE1->E1_NUMBCO)
			dbSelectArea("SE1")
			RecLock("SE1",.F.)
			SE1->E1_NUMBCO := _cNossoNum
//			SE1->E1_IDCNAB := Right(_cNossoNum,10)
			MsUnlock()
		Endif
	Next
Else
	ProcRegua(RecCount())

	While SE1->(!EOF())
	
		IncProc()
		
	    //Quando nao estiver selecionado despreza o registro
	
	
	    If !(Marked("E1_OK") .Or. lAutoEma)
	       DbSkip()
	       Loop
	    EndIf  

		DbSelectArea("SA6")
		DbSetOrder(1)
		If ! DbSeek(xFilial("SA6")+MV_PAR22+MV_PAR23+MV_PAR24,.T.)
			alert("Erro na leitura dos dados do banco !")
			return nil
		end if
		
		If !SEE->(dbSetOrder(1), dbSeek(xFilial("SEE")+MV_PAR22+MV_PAR23+MV_PAR24+MV_PAR25))
			alert("Erro na leitura dos dados bancarios !")
			return nil
		end if

		If Empty(SE1->E1_NUMBCO)
			_cNossoNum := '14'+StrZero(Val(NossoNum()),15)
		Else
			_cNossoNum := '14'+StrZero(Val(Alltrim(SE1->E1_NUMBCO)),15)
		Endif
		
		
		DbSelectArea("SA1")
		DbSetOrder(1)
		DbSeek(xFilial()+SE1->E1_CLIENTE+SE1->E1_LOJA)
		DbSelectArea("SE1")
		
		aDadosBanco  := {SA6->A6_COD         		        ,; // [1]Numero do Banco
	 	SA6->A6_NREDUZ    	                                ,; // [2]Nome do Banco
		Left(SA6->A6_AGENCIA,4)                             ,; // [3]Agência
		Left(SA6->A6_NUMCON,7)								,; // [4]Conta Corrente
		SA6->A6_DVCTA  						,; // [5]Dígito da conta corrente
		"RG"                                          		,; // [6]Codigo da Carteira
		AllTrim(SEE->EE_CODEMP)                             ,;  // [7]Cedente
		''}
		
		aDatSacado   := {AllTrim(SA1->A1_NOME)                            	,;     // [1]Razão Social
		AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA           	,;     // [2]Código
		AllTrim(SA1->A1_END )+"-"+AllTrim(SA1->A1_BAIRRO)	,;     // [3]Endereço
		AllTrim(SA1->A1_MUN )                             	,;     // [4]Cidade
		SA1->A1_EST                                      	,;     // [5]Estado
		SA1->A1_CEP                                       	,;     // [6]CEP
		SA1->A1_CGC                                       	,;     // [7]CGC
		SA1->A1_CGC									  		}      // [8]TIPO
		
		_nVlrAbat   :=  SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)
		
		_nDecresc  :=  SE1->E1_DECRESC
		_nAcresc   :=  SE1->E1_ACRESC
		

		aBolText := {}
		AAdd(aBolText, "NAO RECEBER APOS 120 DIAS DE ATRASO")
		AAdd(aBolText, "")
		Aadd(aBolText, "JUROS : R$ "+Alltrim(TrANSFORM((SE1->E1_SALDO - _nVlrAbat - _nDecresc + _nAcresc ) * nJuros / 100,"@E 999,999.99"))+" REAIS AO DIA ")
		AAdd(aBolText, "")
		//Aadd(aBolText, "MULTA : R$ "+Alltrim(TrANSFORM(SE1->E1_VALOR * nMulta / 100,"@E 999,999.99"))+" REAIS A PARTIR DE "+DtoC(SE1->E1_VENCREA+1))
		

		CB_RN_NN    := Ret_cBarra(Subs(aDadosBanco[1],1,3),aDadosBanco[3],aDadosBanco[4],aDadosBanco[5],AllTrim(_cNossoNum),(SE1->E1_SALDO - _nVlrAbat - _nDecresc + _nAcresc ),Datavalida(E1_VENCREA,.T.),aDadosBanco[7])
		
		aDadosTit    := {AllTrim(E1_NUM)+AllTrim(E1_PARCELA)		,;  // [1] Número do título
		E1_EMISSAO                              					,;  // [2] Data da emissão do título
		Date()                                  					,;  // [3] Data da emissão do boleto
		Datavalida(E1_VENCREA,.T.)                  					,;  // [4] Data do vencimento
		(E1_SALDO - _nVlrAbat - _nDecresc + _nAcresc )              ,;  // [5] Valor do título
		CB_RN_NN[3]                             					,;  // [6] Nosso número (Ver fórmula para calculo)
		E1_PREFIXO                               					,;  // [7] Prefixo da NF
		E1_TIPO	                               						 }  // [8] Tipo do Titulo
		
		Impress(oPrint,aBitmap,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,CB_RN_NN,aBolText)
		n := n + 1

		If Empty(SE1->E1_NUMBCO)
			dbSelectArea("SE1")
			RecLock("SE1",.F.)
			SE1->E1_NUMBCO := _cNossoNum
			MsUnlock()
		Endif

		DbSelectArea("SE1")
		dbSkip()
	Enddo
Endif
oPrint:EndPage()
oPrint:Preview()
Return nil

//.==============================================================.
//|                IMOBILIARIA LINHAM                            |
//|--------------------------------------------------------------|
//| Programa : IMPRESS.PRW      | Autor: Microsiga               |
//|--------------------------------------------------------------|
//| Descricao: Boleto BANCO CEF                                  |
//|                                                              |
//|--------------------------------------------------------------|
//| Data criacao  : 19/03/2007  | Ultima alteracao:              |
//|--------------------------------------------------------------|
//|                                                              |
//.==============================================================.
Static Function Impress(oPrint,aBitmap,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,CB_RN_NN,aBolText)
LOCAL _nTxper := GETMV("MV_TXPER")
LOCAL oFont2n
LOCAL oFont8
LOCAL oFont9
LOCAL oFont10
LOCAL oFont15n
LOCAL oFont16
LOCAL oFont16n
LOCAL oFont14n
LOCAL oFont24
LOCAL i := 0
LOCAL aCoords1 := {0150,1900,0550,2300}
LOCAL aCoords2 := {0450,1050,0550,1900}
LOCAL aCoords3 := {0710,1900,0810,2300}
LOCAL aCoords4 := {0980,1900,1050,2300}
LOCAL aCoords5 := {1330,1900,1400,2300}
LOCAL aCoords6 := {2280,1900,2380,2300}     // 2000 - 2100
LOCAL aCoords7 := {2550,1900,2620,2300}     // 2270 - 2340
LOCAL aCoords8 := {2900,1900,2970,2300}     // 2620 - 2690
LOCAL oBrush
local nJuros := 0.1333
local nMulta := 0.1333

aBmp := ""

oFont2n := TFont():New("Times New Roman",,10,,.T.,,,,,.F. )
oFont8  := TFont():New("Arial",9,8 ,.T.,.F.,5,.T.,5,.T.,.F.)
oFont9  := TFont():New("Arial",9,9 ,.T.,.F.,5,.T.,5,.T.,.F.)
oFont10 := TFont():New("Arial",9,10,.T.,.T.,5,.T.,5,.T.,.F.)
oFont14n:= TFont():New("Arial",9,14,.T.,.F.,5,.T.,5,.T.,.F.)
oFont15n:= TFont():New("Arial",9,15,.T.,.T.,5,.T.,5,.T.,.F.)
oFont16 := TFont():New("Arial",9,16,.T.,.T.,5,.T.,5,.T.,.F.)
oFont16n:= TFont():New("Arial",9,16,.T.,.T.,5,.T.,5,.T.,.F.)
oFont24 := TFont():New("Arial",9,24,.T.,.T.,5,.T.,5,.T.,.F.)

oBrush := TBrush():New("",4)

oPrint:StartPage()

oPrint:Line (0150,550,0050, 550)
oPrint:Line (0150,800,0050, 800)
cFileLogo := 'lgcaixa.bmp'

//oPrint:Say  (0084,100,aDadosBanco[2],oFont15n )	// [2]Nome do Banco
oPrint:SayBitmap(0050,100,cFileLogo,300,100)
oPrint:Say  (0062,567,"104-0",oFont24 )	// [1]Numero do Banco
oPrint:Say  (0084,1900,"Comprovante de Entrega",oFont10)
oPrint:Line (0150,100,0150,2300)
oPrint:Say  (0150,100 ,"Cedente"                                        ,oFont8)
oPrint:Say  (0200,100 ,aDadosEmp[1]                                 	,oFont10) //Nome + CNPJ
oPrint:Say  (0150,1060,"Agência/Código Cedente"                         ,oFont8)
oPrint:Say  (0200,1060,aDadosBanco[3]+'/'+aDadosBanco[8]                                   ,oFont10)
oPrint:Say  (0150,1510,"Nro.Documento"                                  ,oFont8)
oPrint:Say  (0200,1510,aDadosTit[7]+aDadosTit[1]						,oFont10) //Prefixo +Numero+Parcela
oPrint:Say  (0250,100 ,"Sacado"                                         ,oFont8)
oPrint:Say  (0300,100 ,aDatSacado[1]                                    ,oFont10)	//Nome
oPrint:Say  (0250,1060,"Vencimento"                                     ,oFont8)
oPrint:Say  (0300,1060,DTOC(aDadosTit[4])                               ,oFont10)
oPrint:Say  (0250,1510,"Valor do Documento"                          	,oFont8)
oPrint:Say  (0300,1550,AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99"))   ,oFont10)
oPrint:Say  (0400,0100,"Recebi(emos) o bloqueto/título"                 ,oFont10)
oPrint:Say  (0450,0100,"com as características acima."             		,oFont10)
oPrint:Say  (0350,1060,"Data"                                           ,oFont8)
oPrint:Say  (0350,1410,"Assinatura"                                 	,oFont8)
oPrint:Say  (0450,1060,"Data"                                           ,oFont8)
oPrint:Say  (0450,1410,"Entregador"                                 	,oFont8)

oPrint:Line (0250, 100,0250,1900 )
oPrint:Line (0350, 100,0350,1900 )
oPrint:Line (0450,1050,0450,1900 )
oPrint:Line (0550, 100,0550,2300 )

oPrint:Line (0550,1050,0150,1050 )
oPrint:Line (0550,1400,0350,1400 )
oPrint:Line (0350,1500,0150,1500 )
oPrint:Line (0550,1900,0150,1900 )

oPrint:Say  (0150,1910,"(  )Mudou-se"                                	,oFont8)
oPrint:Say  (0190,1910,"(  )Ausente"                                    ,oFont8)
oPrint:Say  (0230,1910,"(  )Não existe nº indicado"                  	,oFont8)
oPrint:Say  (0270,1910,"(  )Recusado"                                	,oFont8)
oPrint:Say  (0310,1910,"(  )Não procurado"                              ,oFont8)
oPrint:Say  (0350,1910,"(  )Endereço insuficiente"                  	,oFont8)
oPrint:Say  (0390,1910,"(  )Desconhecido"                            	,oFont8)
oPrint:Say  (0430,1910,"(  )Falecido"                                   ,oFont8)
oPrint:Say  (0470,1910,"(  )Outros(anotar no verso)"                  	,oFont8)

For i := 100 to 2300 step 50
	oPrint:Line( 0590, i, 0590, i+30)
Next i

oPrint:Line (0710,100,0710,2300)
oPrint:Line (0710,550,0610, 550)
oPrint:Line (0710,800,0610, 800)

//oPrint:Say  (0644,100,aDadosBanco[2],oFont15n )
oPrint:SayBitmap(0610,100,cFileLogo,300,100)

oPrint:Say  (0600,567,"104-0",oFont24 )
oPrint:Say  (0644,1900,"Recibo do Sacado",oFont10)

oPrint:Line (0810,100,0810,2300 )
oPrint:Line (0910,100,0910,2300 )
oPrint:Line (0980,100,0980,2300 )
oPrint:Line (1050,100,1050,2300 )

oPrint:Line (0910,500,1050,500)
oPrint:Line (0980,750,1050,750)
oPrint:Line (0910,1000,1050,1000)
oPrint:Line (0910,1350,0980,1350)
oPrint:Line (0910,1550,1050,1550)

oPrint:Say  (0710,100 ,"Local de Pagamento"                             ,oFont8)
oPrint:Say  (0750,100 ,"PREFERENCIALMENTE NAS CASAS LOTÉRICAS ATÉ O VALOR LIMITE"        ,oFont10)

oPrint:Say  (0710,1910,"Vencimento"                                     ,oFont8)
oPrint:Say  (0750,1950,DTOC(aDadosTit[4])                               ,oFont10)

oPrint:Say  (0810,100 ,"Cedente"                                        ,oFont8)
oPrint:Say  (0850,100 ,aDadosEmp[1]                                     ,oFont10) //CNPJ

oPrint:Say  (0810,1910,"Agência/Código Cedente"                         ,oFont8)
oPrint:Say  (0850,1950,aDadosBanco[3]+'/'+aDadosBanco[8]                                   ,oFont10)

oPrint:Say  (0910,100 ,"Data do Documento"                              ,oFont8)
oPrint:Say  (0940,100 ,DTOC(aDadosTit[2])                               ,oFont10) // Emissao do Titulo (E1_EMISSAO)

oPrint:Say  (0910,505 ,"Nro.Documento"                                  ,oFont8)
oPrint:Say  (0940,605 ,aDadosTit[7]+aDadosTit[1]						,oFont10) //Prefixo +Numero+Parcela

oPrint:Say  (0910,1005,"Espécie Doc."                                   ,oFont8)
oPrint:Say  (0940,1050,"NP"												,oFont10) //Tipo do Titulo

oPrint:Say  (0910,1355,"Aceite"                                         ,oFont8)
oPrint:Say  (0940,1455,"N"                                             ,oFont10)

oPrint:Say  (0910,1555,"Data do Processamento"                          ,oFont8)
oPrint:Say  (0940,1655,DTOC(aDadosTit[3])                               ,oFont10) // Data impressao

oPrint:Say  (0910,1910,"Nosso Número"                                   ,oFont8)
oPrint:Say  (0940,1950,TransForm(aDadosTit[6]+AllTrim(Str(ModuloSD11(aDadosTit[6]))),'@R 99/999999999999999-9'),oFont10)

oPrint:Say  (0980,100 ,"CNPJ do Cedente"                                ,oFont8)
oPrint:Say  (1010,100 ,substr(aDadosEmp[6],11)                          ,oFont10) //CNPJ

oPrint:Say  (0980,505 ,"Carteira"                                       ,oFont8)
oPrint:Say  (1010,555 ,aDadosBanco[6]                                  	,oFont10)

oPrint:Say  (0980,755 ,"Espécie"                                        ,oFont8)
oPrint:Say  (1010,805 ,"R$"                                             ,oFont10)

oPrint:Say  (0980,1005,"Quantidade"                                     ,oFont8)
oPrint:Say  (0980,1555,"Valor"                                          ,oFont8)

oPrint:Say  (0980,1910,"Valor do Documento"                          	,oFont8)
oPrint:Say  (1010,2010,AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),oFont10)

oPrint:Say  (1050,100 ,"Instruções (Todas informações deste bloqueto são de exclusiva responsabilidade do cedente)",oFont8)
oPrint:Say  (1100,100 ,aBolText[1]                                      ,oFont10)
oPrint:Say  (1150,100 ,aBolText[2]                                      ,oFont10)
oPrint:Say  (1200,100 ,aBolText[3]                                      ,oFont10)
oPrint:Say  (1250,100 ,aBolText[4]                                      ,oFont10)



oPrint:Say  (1050,1910,"(-)Desconto/Abatimento"                         ,oFont8)
oPrint:Say  (1120,1910,"(-)Outras Deduções"                             ,oFont8)
oPrint:Say  (1190,1910,"(+)Mora/Multa"                                  ,oFont8)
oPrint:Say  (1260,1910,"(+)Outros Acréscimos"                           ,oFont8)
oPrint:Say  (1330,1910,"(=)Valor Cobrado"                               ,oFont8)

oPrint:Say  (1290,100 ,"SAC CAIXA: 0800 726 0101 (informações, reclamações, sugestões e elogios)."								,oFont8)
oPrint:Say  (1320,100 ,"Para pessoas com deficiência auditiva ou de fala: 0800 726 2492.",oFont8)
oPrint:Say  (1350,100 ,"Ouvidoria: 0800 725 7474. caixa.gov.br.*",oFont8)

oPrint:Say  (1400,100 ,"Sacado"                                         ,oFont8)
oPrint:Say  (1430,400 ,aDatSacado[1]+" ("+aDatSacado[2]+")"             ,oFont10)
oPrint:Say  (1483,400 ,aDatSacado[3]                                    ,oFont10)
oPrint:Say  (1536,400 ,aDatSacado[6]+"    "+aDatSacado[4]+" - "+aDatSacado[5],oFont10) // CEP+Cidade+Estado

If Len(aDatSacado[7])== 14
	oPrint:Say  (1589,400 ,"CGC: "+TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),oFont10) // CGC
Else
	oPrint:Say  (1589,400 ,"CPF: "+TRANSFORM(aDatSacado[7],"@R 999.999.999-99"),oFont10) // CGC
Endif

oPrint:Say  (1605,100 ,"Sacador/Avalista"                               ,oFont8)
oPrint:Say  (1645,1500,"Autenticação Mecânica -"                        ,oFont8)

oPrint:Line (0710,1900,1400,1900 )
oPrint:Line (1120,1900,1120,2300 )
oPrint:Line (1190,1900,1190,2300 )
oPrint:Line (1260,1900,1260,2300 )
oPrint:Line (1330,1900,1330,2300 )
oPrint:Line (1400,100 ,1400,2300 )
oPrint:Line (1640,100 ,1640,2300 )
                       
oPrint:Say (1850,100,"Código de Barras: " + CB_RN_NN[1],oFont14n)
For i := 100 to 2300 step 50
	oPrint:Line( 1930, i, 1930, i+30)                 // 1850
Next i

oPrint:Line (2080,100,2080,2300)                                                       //   2000
oPrint:Line (2080,550,1980, 550)                                                       //   2000 - 1900
oPrint:Line (2080,800,1980, 800)                                                       //    2000 - 1900


//oPrint:Say  (2014,100,aDadosBanco[2],oFont15n )	// [2]Nome do Banco                     1934
oPrint:SayBitmap(1980,100,cFileLogo,300,100)
oPrint:Say  (01980,567,"104-0",oFont24 )	// [1]Numero do Banco
oPrint:Say  (2014,820,CB_RN_NN[2],oFont14n)		//Linha Digitavel do Codigo de Barras   1934

oPrint:Line (2180,100,2180,2300 )    //   2100
oPrint:Line (2280,100,2280,2300 )    //   2200
oPrint:Line (2350,100,2350,2300 )    //   2270
oPrint:Line (2420,100,2420,2300 )    //   2340

oPrint:Line (2280, 500,2420,500)      //   2200 - 2340
oPrint:Line (2350, 750,2420,750)      //   2270 - 2340
oPrint:Line (2280,1000,2420,1000)    //   2200 - 2340
oPrint:Line (2280,1350,2350,1350)    //   2200 - 2270
oPrint:Line (2280,1550,2420,1550)    //   2200 - 2340

oPrint:Say  (2080,100 ,"Local de Pagamento"                             ,oFont8)                  //    2000
oPrint:Say  (2120,100 ,"PREFERENCIALMENTE NAS CASAS LOTÉRICAS ATÉ O VALOR LIMITE"       ,oFont10)  //  2020

oPrint:Say  (2080,1910,"Vencimento"                                     ,oFont8)                  // 2000
oPrint:Say  (2120,1950,DTOC(aDadosTit[4])                               ,oFont10)                // 2040

oPrint:Say  (2180,100 ,"Cedente"                                        ,oFont8)                      // 2100
oPrint:Say  (2180,350 ,aDadosEmp[1]                                  	,oFont10) //CNPJ      2140
oPrint:Say  (2220,350 ,AllTrim(aDadosEmp[2])+' '+AllTrim(aDadosEmp[3])+' '+aDadosEmp[4]                                  	,oFont10) //CNPJ      2140

oPrint:Say  (2180,1910,"Agência/Código Cedente"                         ,oFont8)                        // 2100
oPrint:Say  (2220,1950,aDadosBanco[3]+'/'+aDadosBanco[8]                                   ,oFont10)                  // 2140

oPrint:Say  (2280,100 ,"Data do Documento"                              ,oFont8)                                   // 2200
oPrint:Say  (2310,100 ,DTOC(aDadosTit[2])                               ,oFont10) // Emissao do Titulo (E1_EMISSAO)    2230

oPrint:Say  (2280,505 ,"Nro.Documento"                                  ,oFont8)                           // 2200
oPrint:Say  (2310,605 ,aDadosTit[7]+aDadosTit[1]						,oFont10) //Prefixo +Numero+Parcela  2230

oPrint:Say  (2280,1005,"Espécie Doc."                                   ,oFont8)                 // 2200
oPrint:Say  (2310,1050,"NP"												,oFont10) //Tipo do Titulo  2230

oPrint:Say  (2280,1355,"Aceite"                                         ,oFont8)  // 2200
oPrint:Say  (2310,1455,"N"                                             ,oFont10)  // 2230

oPrint:Say  (2280,1555,"Data do Processamento"                          ,oFont8)       // 2200
oPrint:Say  (2310,1655,DTOC(aDadosTit[3])                               ,oFont10) // Data impressao  2230

oPrint:Say  (2280,1910,"Nosso Número"                                   ,oFont8)       // 2200
oPrint:Say  (2310,1950,TransForm(aDadosTit[6]+AllTrim(Str(ModuloSD11(aDadosTit[6]))),'@R 99/999999999999999-9'),oFont10)

oPrint:Say  (2350,100 ,"CNPJ do Cedente"                                ,oFont8)
oPrint:Say  (2380,100 ,substr(aDadosEmp[6],11)                          ,oFont10) //CNPJ

oPrint:Say  (2350,505 ,"Carteira"                                       ,oFont8)       // 2270
oPrint:Say  (2380,555 ,aDadosBanco[6]                                  	,oFont10)      //  2300

oPrint:Say  (2350,755 ,"Espécie"                                        ,oFont8)       //  2270
oPrint:Say  (2380,805 ,"R$"                                             ,oFont10)      //  2300

oPrint:Say  (2350,1005,"Quantidade"                                     ,oFont8)       //  2270
oPrint:Say  (2350,1555,"Valor"                                          ,oFont8)       //  2270

oPrint:Say  (2350,1910,"Valor do Documento"                          	,oFont8)        //  2270
oPrint:Say  (2380,2010,AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),oFont10)  //   2300


oPrint:Say  (2420,100 ,"Instruções (Todas informações deste bloqueto são de exclusiva responsabilidade do cedente)",oFont8)
oPrint:Say  (2480,100 ,aBolText[1]                                      ,oFont10)
oPrint:Say  (2520,100 ,aBolText[2]                                      ,oFont10)
oPrint:Say  (2580,100 ,aBolText[3]                                      ,oFont10)
oPrint:Say  (2620,100 ,aBolText[4]                                      ,oFont10)



oPrint:Say  (2420,1910,"(-)Desconto/Abatimento"                         ,oFont8)      //  2340
oPrint:Say  (2490,1910,"(-)Outras Deduções"                             ,oFont8)      //  3410
oPrint:Say  (2560,1910,"(+)Mora/Multa"                                  ,oFont8)      //  2480
oPrint:Say  (2630,1910,"(+)Outros Acréscimos"                           ,oFont8)      //  2550
oPrint:Say  (2700,1910,"(=)Valor Cobrado"                               ,oFont8)      //  2620

oPrint:Say  (2680,100 ,"SAC CAIXA: 0800 726 0101 (informações, reclamações, sugestões e elogios)."								,oFont8)
oPrint:Say  (2710,100 ,"Para pessoas com deficiência auditiva ou de fala: 0800 726 2492.",oFont8)
oPrint:Say  (2740,100 ,"Ouvidoria: 0800 725 7474. caixa.gov.br.*",oFont8)

oPrint:Say  (2770,100 ,"Sacado"                                         ,oFont8)
oPrint:Say  (2800,400 ,aDatSacado[1]+" ("+aDatSacado[2]+")"             ,oFont10)
oPrint:Say  (2853,400 ,aDatSacado[3]                                    ,oFont10)       // 2773
oPrint:Say  (2906,400 ,aDatSacado[6]+"    "+aDatSacado[4]+" - "+aDatSacado[5],oFont10) // CEP+Cidade+Estado  2826

If Len(aDatSacado[7])== 14
	oPrint:Say  (2959,400 ,"CGC: "+TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),oFont10) // CGC
Else
	oPrint:Say  (2959,400 ,"CPF: "+TRANSFORM(aDatSacado[7],"@R 999.999.999-99"),oFont10) // CGC
Endif
oPrint:Say  (2975,100 ,"Sacador/Avalista"                               ,oFont8)       //2895
oPrint:Say  (3015,1500,"Autenticação Mecânica -"                        ,oFont8)
oPrint:Say  (3015,1850,"Ficha de Compensação"                           ,oFont10)      // 2935 + 280      = 3215

oPrint:Line (2080,1900,2770,1900 )         // 2000 - 2690       -
oPrint:Line (2490,1900,2490,2300 )         // 2410        -
oPrint:Line (2560,1900,2560,2300 )         // 2480        -
oPrint:Line (2630,1900,2630,2300 )         // 2550        -
oPrint:Line (2700,1900,2700,2300 )         // 2620        -
oPrint:Line (2770,100 ,2770,2300 )         // 2690        -

oPrint:Line (3010,100 ,3010,2300 )         // 2930
MSBAR3("INT25"  , 26 , 1.5 ,CB_RN_NN[1],oPrint,.F.,,,0.0255,1.5,,,,.F.)
oPrint:EndPage()
Return Nil

//.==============================================================.
//|                IMOBILIARIA LINHAM                            |
//|--------------------------------------------------------------|
//| Programa : MODULO10.PRW     | Autor: Microsiga               |
//|--------------------------------------------------------------|
//| Descricao: Calculo do MODULO 10                              |
//|                                                              |
//|--------------------------------------------------------------|
//| Data criacao  : 19/03/2007  | Ultima alteracao:              |
//|--------------------------------------------------------------|
//|                                                              |
//.==============================================================.
Static Function Modulo10(cData)
LOCAL L,D,P := 0
LOCAL B     := .F.
L := Len(cData)
B := .T.
D := 0
While L > 0
	P := Val(SubStr(cData, L, 1))
	If (B)
		P := P * 2
		If P > 9
			P := P - 9
		End
	End
	D := D + P
	L := L - 1
	B := !B
End
D := 10 - (Mod(D,10))
If D = 10
	D := 0
End
Return(D)

//.==============================================================.
//|                IMOBILIARIA LINHAM                            |
//|--------------------------------------------------------------|
//| Programa : MODULO11.PRW     | Autor: Microsiga               |
//|--------------------------------------------------------------|
//| Descricao: Calculo do MODULO 11                              |
//|                                                              |
//|--------------------------------------------------------------|
//| Data criacao  : 19/03/2007  | Ultima alteracao:              |
//|--------------------------------------------------------------|
//|                                                              |
//.==============================================================.
Static Function Modulo11(cData)
//para formacao do codigo de barra
LOCAL L, D, P := 0
L := Len(cdata)
D := 0
P := 1
While L > 0
	P := P + 1
	D := D + (Val(SubStr(cData, L, 1)) * P)
	If P = 9
		P := 1
	End
	L := L - 1
End
D := D * 10
D := mod(D,11)
If (D == 0 .Or. D == 1 .Or. D == 10)
	D := 1
End
Return(D)


//.==============================================================.
//|                IMOBILIARIA LINHAM                            |
//|--------------------------------------------------------------|
//| Programa : MODULOSD11.PRW   | Autor: Microsiga               |
//|--------------------------------------------------------------|
//| Descricao: Calculo do MODULO 11 - Digitão do Cod.Barras      |
//|                                                              |
//|--------------------------------------------------------------|
//| Data criacao  : 19/03/2007  | Ultima alteracao:              |
//|--------------------------------------------------------------|
//|                                                              |
//.==============================================================.
Static Function ModuloSD11(cData)
LOCAL L, D, P := 0
L := Len(cdata)
D := 0
P := 1
While L > 0
	P := P + 1
	D := D + (Val(SubStr(cData, L, 1)) * P)
	If P = 9
		P := 1
	End
	L := L - 1
End
D := D * 10
D := mod(D,11)
If (D == 1)
	D := 1
elseif (D == 0 .or. D == 10)
	D := 0
End
Return(D)


//.==============================================================.
//|                IMOBILIARIA LINHAM                            |
//|--------------------------------------------------------------|
//| Programa : RET_CBARRA.PRW   | Autor: Microsiga               |
//|--------------------------------------------------------------|
//| Descricao: Calculo do Codigo de Barras e Linha Digitavel     |
//|                                                              |
//|--------------------------------------------------------------|
//| Data criacao  : 19/03/2007  | Ultima alteracao:              |
//|--------------------------------------------------------------|
//|                                                              |
//.==============================================================.
Static Function Ret_cBarra(cBanco,cAgencia,cConta,cDacCC,cNossoNum,nValor,dVencto,cCedente)
Local cFator     := StrZero((dVencto - ctod("03/07/00"))+1000,4)
Local cValor     := StrZero(nValor*100,10)
Local cDigCOB    := Alltrim(Str(Modulo10( cNossoNum+cAgencia+cConta ))) // Digitão da Cobrança
Local cDigBAR    := Alltrim(Str(Modulo10( cBanco+"9"+cFator+cValor+cConta+cDigCOB+cNossoNum))) // Digito do Cod.Barras
Local cDigitao   := Alltrim(Str(Modulo11( cBanco+"9"+cFator+cValor+cCedente+cNossoNum)))       // Digitão do Cod.Barras
Local cDvBenef	 := Alltrim(Str(ModuloSD11(cCedente))) 
Local cBloco1, cBloco2, cBloco3, cBloco4, cBloco5
Local cDigBL1, cDigBL2, cDigBL3
Local cCodeBar, cLinhaDig
Local cCpoLivre  := right(cCedente,6) + cDvBenef + SubStr(cNossoNum,3,3)+SubStr(cNossoNum,1,1)+SubStr(cNossoNum,6,3)+SubStr(cNossoNum,2,1)+SubStr(cNossoNum,9,9)
Local cDvCpLivr	 := Alltrim(Str(ModuloSD11(cCpoLivre))) 

aDadosBanco[8]	:=	cCedente+'-'+cDvBenef

//-------------------------------------------------//
// DEFINIÇÃO DO CÓDIGO DE BARRAS                   //
//-------------------------------------------------//
cDigitao := Alltrim(Str(Modulo11(cBanco+"9"+cFator+cValor+cCedente+AllTrim(cDvBenef)+SubStr(cNossoNum,3,3)+Left(cNossoNum,1)+SubStr(cNossoNum,6,3)+SubStr(cNossoNum,2,1)+SubStr(cNossoNum,9,9)+cDvCpLivr))) 

cCodeBar := cBanco+"9"+cDigitao+cFator+cValor+cCedente+AllTrim(cDvBenef)+SubStr(cNossoNum,3,3)+Left(cNossoNum,1)+SubStr(cNossoNum,6,3)+SubStr(cNossoNum,2,1)+SubStr(cNossoNum,9,9)+cDvCpLivr

//-------------------------------------------------//
// DEFINIÇÃO DA LINHA DIGITÁVEL                    //
//-------------------------------------------------//
//-------------------------------------------------//
// CAMPO 1                                         //
//-------------------------------------------------//
cBloco1 := Left(cCodeBar,4)+SubStr(cCodeBar,20,5)
cDigBL1 := Alltrim(Str(Modulo10(cBloco1)))

//-------------------------------------------------//
// CAMPO 2                                         //
//-------------------------------------------------//
cBloco2 := SubStr(cCodeBar,25,10)
cDigBL2 := Alltrim(Str(Modulo10(cBloco2)))

//-------------------------------------------------//
// CAMPO 3                                         //
//-------------------------------------------------//
cBloco3 := SubStr(cCodeBar,35,10)
cDigBL3 :=Alltrim(Str(Modulo10(cBloco3)))

//-------------------------------------------------//
// CAMPO 4                                         //
//-------------------------------------------------//
cBloco4 := SubStr(cCodeBar,5,1)

//-------------------------------------------------//
// CAMPO 5                                         //
//-------------------------------------------------//
cBloco5 := SubStr(cCodeBar,6,4) + SubStr(cCodeBar,10,10)

//-------------------------------------------------//
// LINHA DIGITÁVEL                                 //
//-------------------------------------------------//
cLinhaDig := Left(cBloco1,5) + "." + Subs(cBloco1,6,4) + cDigBL1 + Space(2)
cLinhaDig += Left(cBloco2,5) + "." + Subs(cBloco2,6,5) + cDigBL2 + Space(2)
cLinhaDig += Left(cBloco3,5) + "." + Subs(cBloco3,6,5) + cDigBL3 + Space(2) 
cLinhaDig += cBloco4 + Space(2)
cLinhaDig += cBloco5


Return({cCodeBar,cLinhaDig,cNossoNum})

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ AjustaSx1    ³ Autor ³ Microsiga            	³ Data ³ 13/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica/cria SX1 a partir de matriz para verificacao          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                    	  		³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function AjustaSX1(cPerg, aPergs)

Local _sAlias	:= Alias()
Local aCposSX1	:= {}
Local nX 		:= 0
Local lAltera	:= .F.
Local nCondicao
Local cKey		:= ""
Local nJ			:= 0

aCposSX1:={"X1_PERGUNT","X1_PERSPA","X1_PERENG","X1_VARIAVL","X1_TIPO","X1_TAMANHO",;
			"X1_DECIMAL","X1_PRESEL","X1_GSC","X1_VALID",;
			"X1_VAR01","X1_DEF01","X1_DEFSPA1","X1_DEFENG1","X1_CNT01",;
			"X1_VAR02","X1_DEF02","X1_DEFSPA2","X1_DEFENG2","X1_CNT02",;
			"X1_VAR03","X1_DEF03","X1_DEFSPA3","X1_DEFENG3","X1_CNT03",;
			"X1_VAR04","X1_DEF04","X1_DEFSPA4","X1_DEFENG4","X1_CNT04",;
			"X1_VAR05","X1_DEF05","X1_DEFSPA5","X1_DEFENG5","X1_CNT05",;
			"X1_F3", "X1_GRPSXG", "X1_PYME","X1_HELP" }

dbSelectArea("SX1")
dbSetOrder(1)
For nX:=1 to Len(aPergs)
	lAltera := .F.
	If MsSeek(cPerg+Right(aPergs[nX][11], 2))
		If (ValType(aPergs[nX][Len(aPergs[nx])]) = "B" .And.;
			 Eval(aPergs[nX][Len(aPergs[nx])], aPergs[nX] ))
			aPergs[nX] := ASize(aPergs[nX], Len(aPergs[nX]) - 1)
			lAltera := .T.
		Endif
	Endif
	
	If ! lAltera .And. Found() .And. X1_TIPO <> aPergs[nX][5]	
 		lAltera := .T.		// Garanto que o tipo da pergunta esteja correto
 	Endif	
	
	If ! Found() .Or. lAltera
		RecLock("SX1",If(lAltera, .F., .T.))
		Replace X1_GRUPO with cPerg
		Replace X1_ORDEM with Right(aPergs[nX][11], 2)
		For nj:=1 to Len(aCposSX1)
			If 	Len(aPergs[nX]) >= nJ .And. aPergs[nX][nJ] <> Nil .And.;
				FieldPos(AllTrim(aCposSX1[nJ])) > 0
				Replace &(AllTrim(aCposSX1[nJ])) With aPergs[nx][nj]
			Endif
		Next nj
		MsUnlock()
		cKey := "P."+AllTrim(X1_GRUPO)+AllTrim(X1_ORDEM)+"."

		If ValType(aPergs[nx][Len(aPergs[nx])]) = "A"
			aHelpSpa := aPergs[nx][Len(aPergs[nx])]
		Else
			aHelpSpa := {}
		Endif
		
		If ValType(aPergs[nx][Len(aPergs[nx])-1]) = "A"
			aHelpEng := aPergs[nx][Len(aPergs[nx])-1]
		Else
			aHelpEng := {}
		Endif

		If ValType(aPergs[nx][Len(aPergs[nx])-2]) = "A"
			aHelpPor := aPergs[nx][Len(aPergs[nx])-2]
		Else
			aHelpPor := {}
		Endif

		PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)
	Endif
Next


Static function LimpaFlag()

DbSelectArea("SE1")
DbSetOrder(1)
DbSeek(xFilial("SE1")+MV_PAR01+MV_PAR03,.T. )

ProcRegua(RecCount())

While SE1->(!Eof()) .And. SE1->E1_NUM <= MV_PAR04

   IncProc("Limpando Flag.." )
   
   Reclock("SE1",.F.)
   SE1->E1_OK := Space(2)
   MsUnlock()
   DbSkip()
End

Return