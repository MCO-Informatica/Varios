#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function Teste2()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("MV_PAR04,NPOSATU,NPOSANT,NTOTREGS,NPOSCNT,CPOSNUM")
SetPrvt("CPOSDATA,CPOSDESP,CPOSDESC,CPOSABAT,CPOSPRIN,CPOSJURO")
SetPrvt("CPOSMULT,CPOSOCOR,CPOSTIPO,CPOSCC,CPOSDTCC,CSAVEMENUH")
SetPrvt("CCOLORANT,CPOSMOT,LPOSNUM,LPOSDATA,LPOSMOT,LPOSDESP")
SetPrvt("LPOSDESC,LPOSABAT,LPOSPRIN,LPOSJURO,LPOSMULT,LPOSOCOR")
SetPrvt("LPOSTIPO,LPOSOUTRD,LPOSCC,LPOSDTCC,LPOSNSNUM,NLIDOS")
SetPrvt("NLENNUM,NLENDATA,NLENDESP,NLENDESC,NLENABAT,NLENMOT")
SetPrvt("NTAMDET,NLENPRIN,NLENJURO,NLENMULT,NLENOCOR,NLENTIPO")
SetPrvt("NLENCC,NLENDTCC,CARQCONF,CARQENT,XBUFFER,LDESCONTO")
SetPrvt("LCONTABILIZA,NRECTIT,CDATA,CPOSNSNUM,NLENNSNUM,CPOSOUTRD")
SetPrvt("NLENOUTRD,LUMHELP,CTABELA,LPADRAO,LBAIXOU,NSAVRECNO")
SetPrvt("LRET,NPOS,ATABELA,LRECICL,LNAOEXISTE,CINDEX")
SetPrvt("LFINA200,L200POS,LFA200FIL,LFA200F1,LF200TIT,LF200FIM")
SetPrvt("LF200VAR,L200FIL,LFIRST,CMOTSIST,CMOTBAN,NCONT")
SetPrvt("CMOTIVO,LSAI,ALEITURA,LFA200_02,AVALORES,LBXCNAB")
SetPrvt("NHDLBCO,NHDLCONF,NSEQ,CMOTBX,NTOTAGER,NTOTDESP")
SetPrvt("NTOTOUTD,NTOTVALCC,NVALESTRANG,VALOR,NHDLPRV,CBANCO")
SetPrvt("CAGENCIA,CCONTA,CHIST070,LAUT,NTOTABAT,CARQUIVO")
SetPrvt("DDATACRED,LCABEC,CPADRAO,NTOTAL,CSUBCTA,LDIGITA")
SetPrvt("LAGLUT,CLOTEFIN,CLOTE,NTAMARQ,CCHAVE,NINDEX")
SetPrvt("NDESPES,NDESCONT,NABATIM,NVALREC,NJUROS,NMULTA")
SetPrvt("NVALCC,NCM,NOUTRDESP,CNUMTIT,DBAIXA,CTIPO")
SetPrvt("CNSNUM,CESPECIE,DDATAUSER,COCORR,NVALOUTRD,LHELP")
SetPrvt("NX,")


Pergunte( cPerg,.F.)

MV_PAR04 := UPPER(MV_PAR04)

//----> variaveis utilizadas no processo

nPosAtu     := 0
nPosAnt     := 0
nTotRegs    := 0
nPosCnt     := 0
cPosNum     := ""
cPosData    := ""
cPosDesp    := ""
cPosDesc    := ""
cPosAbat    := ""
cPosPrin    := ""
cPosJuro    := ""
cPosMult    := ""
cPosOcor    := ""
cPosTipo    := ""
cPosCC      := ""
cPosDtCC    := ""
cSaveMenuh  := ""
cColorAnt   := ""
cPosMot     := ""
lPosNum     := .f.
lPosData    := .f.
lPosMot     := .f.
lPosDesp    := .f.
lPosDesc    := .f.
lPosAbat    := .f.
lPosPrin    := .f.
lPosJuro    := .f.
lPosMult    := .f.
lPosOcor    := .f.
lPosTipo    := .f.
lPosOutrD   := .f.
lPosCC      := .f.
lPosDtCC    := .f.
lPosNsNum   := .f.
nLidos      := 0
nLenNum     := 0
nLenData    := 0
nLenDesp    := 0
nLenDesc    := 0
nLenAbat    := 0
nLenMot     := 0
nTamDet     := 0
nLenPrin    := 0
nLenJuro    := 0
nLenMult    := 0
nLenOcor    := 0
nLenTipo    := 0
nLenCC      := 0
nLenDtCC    := 0
cArqConf    := ""
cArqEnt     := ""
xBuffer     := ""
lDesconto   := .f.
lContabiliza:= .f.
nRecTit     := 0 
cData       := "01/01/80"
cPosNsNum   := ""
nLenNsNum   := 0
cPosOutrD   := ""
nLenOutrD   := 0
lUmHelp     := .f.
cTabela     := "17"
lPadrao     := .f.
lBaixou     := .f.
nSavRecno   := Recno()
lRet        := .f.
nPos        := 0 
aTabela     := {}
lRecicl     := GetMv("MV_RECICL")
lNaoExiste  := .f.
cIndex      := " "
lFina200    := ExistBlock("FINA200" ) 
l200Pos     := ExistBlock("FA200POS" ) 
lFa200Fil   := ExistBlock("FA200FIL") 
lFa200F1    := ExistBlock("FA200F1" ) 
lF200Tit    := ExistBlock("F200TIT" ) 
lF200Fim    := ExistBlock("F200FIM" ) 
lF200Var    := ExistBlock("F200VAR" ) 
l200Fil     := .f.
lFirst      := .f.
cMotSist    := Space(2)                 // motivo da ocorrencia no sistema
cMotBan     := Space(10)                // motivo da ocorrencia no banco
nCont       := 0
cMotivo     := ""
lSai        := .f.
aLeitura    := {}
lFa200_02   := ExistBlock("FA200_02")
aValores    := {}
lBxCnab     := GetMv("MV_BXCNAB") == "S"
nHdlBco   	:= 0
nHdlConf   	:= 0
nSeq       	:= 0 
cMotBx     	:= "NOR"
nTotAGer   	:= 0
nTotDesp   	:= 0 // Total de Despesas para uso com MV_BXCNAB
nTotOutD   	:= 0 // Total de outras despesas para uso com MV_BXCNAB
nTotValCC   := 0 // Total de outros creditos para uso com MV_BXCNAB
nValEstrang := 0
VALOR    	:= 0
nHdlPrv  	:= 0
cBanco      := ""
cAgencia    := ""
cConta      := ""
cHist070    := ""
lAut        := .f.
nTotAbat    := 0
cArquivo    := ""
dDataCred   := dDataBase
lCabec      := .f.
cPadrao     := ""
nTotal      := 0

//----> posiciona o arquivo no local indicado

cBanco  := mv_par06
cAgencia:= mv_par07
cConta  := mv_par08
cSubCta := mv_par09
lDigita := .F.
lAglut  := .F.

dbSelectArea("SA6")
DbSetOrder(1)
SA6->( dbSeek(XFILIAL()+cBanco+cAgencia+cConta) )

dbSelectArea("SEE")
DbSetOrder(1)
SEE->( dbSeek(XFILIAL()+cBanco+cAgencia+cConta+cSubCta) )
If !SEE->( found() )
	Help(" ",1,"PAR150")
	Return .F.
Endif

If lBxCnab // Baixar arquivo recebidos pelo CNAB aglutinando os valores
	If Empty(SEE->EE_LOTE)
		cLoteFin := "0001"
	Else
		cLoteFin := Soma1(SEE->EE_LOTE)
	EndIf
EndIf

nTamDet := Iif( Empty (SEE->EE_NRBYTES), 400 , SEE->EE_NRBYTES )
nTamDet := nTamDet + 2  // ajusta tamanho do detalhe para ler o CR+LF
cTabela := Iif( Empty(SEE->EE_TABELA), "17" , SEE->EE_TABELA )

dbSelectArea( "SX5" )
If !SX5->( dbSeek( XFILIAL() + cTabela ) )
	Help(" ",1,"PAR150")
   Return .F.
Endif

/*
If !(Chk200File())
	Return .F.
Endif
*/

While !SX5->(Eof()) .and. SX5->X5_TABELA == cTabela
    AADD(aTabela,{Alltrim(SX5->X5_DESCRI),AllTrim(SX5->X5_CHAVE)})
	SX5->(dbSkip( ))
Enddo

//----> verifica o numero do lote

cLote := ""
dbSelectArea("SX5")
dbSeek(XFILIAL()+"09FIN")
cLote := Substr(SX5->X5_DESCRI,1,4)

If ( MV_PAR12 == 1 )
	cArqConf:=mv_par05
    If !FILE(cArqConf)
		Help(" ",1,"NOARQPAR")
		Return .F.
	Else
		nHdlConf:=FOPEN(cArqConf,0+64)
    EndIf

    //----> le o arquivo de configuracao

    nLidos:=0
	FSEEK(nHdlConf,0,0)
	nTamArq:=FSEEK(nHdlConf,0,2)
	FSEEK(nHdlConf,0,0)

	While nLidos <= nTamArq
    
		xBuffer:=Space(85)
		FREAD(nHdlConf,@xBuffer,85)
		IF SubStr(xBuffer,1,1) == CHR(1)
            nLidos := nLidos + 85
			Loop
		EndIF

        IF !lPosNum
			cPosNum:=Substr(xBuffer,17,10)
			nLenNum:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosNum:=.t.
            nLidos := nLidos + 85
			Loop
		EndIF
		IF !lPosData
			cPosData:=Substr(xBuffer,17,10)
			nLenData:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosData:=.t.
            nLidos := nLidos + 85
			Loop
		End
		IF !lPosDesp
			cPosDesp:=Substr(xBuffer,17,10)
			nLenDesp:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosDesp:=.t.
            nLidos := nLidos + 85
			Loop
		End
		IF !lPosDesc
			cPosDesc:=Substr(xBuffer,17,10)
			nLenDesc:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosDesc:=.t.
            nLidos := nLidos + 85
			Loop
		End
		IF !lPosAbat
			cPosAbat:=Substr(xBuffer,17,10)
			nLenAbat:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosAbat:=.t.
            nLidos := nLidos + 85
			Loop
		EndIF
		IF !lPosPrin
			cPosPrin:=Substr(xBuffer,17,10)
			nLenPrin:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosPrin:=.t.
            nLidos := nLidos + 85
			Loop
		EndIF
		IF !lPosJuro
			cPosJuro:=Substr(xBuffer,17,10)
			nLenJuro:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosJuro:=.t.
            nLidos := nLidos + 85
			Loop
		EndIF
		IF !lPosMult
			cPosMult:=Substr(xBuffer,17,10)
			nLenMult:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosMult:=.t.
            nLidos := nLidos + 85
			Loop
		EndIF
		IF !lPosOcor
			cPosOcor:=Substr(xBuffer,17,10)
			nLenOcor:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosOcor:=.t.
            nLidos := nLidos + 85
			Loop
		EndIF
		IF !lPosTipo
			cPosTipo:=Substr(xBuffer,17,10)
			nLenTipo:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosTipo:=.t.
            nLidos := nLidos + 85
			Loop
		EndIF
		IF !lPosOutrD
			cPosOutrD:=Substr(xBuffer,17,10)
			nLenOutrD:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosOutrD:=.t.
            nLidos := nLidos + 85
			Loop
		EndIF	
		IF !lPosCC
			cPosCC:=Substr(xBuffer,17,10)
			nLenCC:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosCC:=.t.
            nLidos := nLidos + 85
			Loop
		EndIF
		IF !lPosDtCc
			cPosDtCc:=Substr(xBuffer,17,10)
			nLenDtCc:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosDtCc:=.t.
            nLidos := nLidos + 85
			Loop
		EndIF
		IF !lPosNsNum
			cPosNsNum := Substr(xBuffer,17,10)
			nLenNsNum := 1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosNsNum := .t.
            nLidos := nLidos + 85
			Loop
		EndIF
		IF !lPosMot									// codigo do motivo da ocorrencia
			cPosMot:=Substr(xBuffer,17,10)
			nLenMot:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosMot:=.t.
            nLidos := nLidos + 85
			Loop
		EndIF
		Exit
	EndDo

	Fclose(nHdlConf)
EndIf

//----> abre o arquivo enviado pelo banco

cArqEnt:=mv_par04
IF !FILE(cArqEnt)
	Help(" ",1,"NOARQENT")
	Return .F.
Else
	nHdlBco:=FOPEN(cArqEnt,0+64)
EndIF

If lRecicl
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Filtra o arquivo por E1_NUMBCO - caso exista reciclagem      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SE1")
	cIndex	:= CriaTrab(nil,.f.)
	cChave	:= IndexKey()
    IndRegua("SE1",cIndex,"E1_FILIAL+E1_NUMBCO",,Fa200ChecF(),OemToAnsi("Selecionando Registros..."))
	nIndex := RetIndex("SE1")
	dbSelectArea("SE1")
	#IFNDEF TOP
		dbSetIndex(cIndex+OrdBagExt())
	#ENDIF
	dbSetOrder(nIndex+1)
    
	dbGoTop()
	IF BOF() .and. EOF()
		Help(" ",1,"RECNO")
		Return
	EndIf
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Chama a SumAbatRec antes do Controle de transa‡Æo para abrir o alias ³
//³ auxiliar __SE1																		 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SumAbatRec( "", "", "", 1, "")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Lˆ arquivo enviado pelo banco ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nLidos:=0
FSEEK(nHdlBco,0,0)
nTamArq:=FSEEK(nHdlBco,0,2)
FSEEK(nHdlBco,0,0)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Desenha o cursor e o salva para poder moviment -lo ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ProcRegua( nTamArq/nTamDet , 24 )

lFirst := .F.
nTotAger := 0
While nLidos <= nTamArq
	IncProc()
	nDespes :=0
	nDescont:=0
	nAbatim :=0
	nValRec :=0
	nJuros  :=0
	nMulta  :=0
	nValCc  :=0
	nCM     :=0
	nOutrDesp :=0   
	If ( MV_PAR12 == 1 )
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Tipo qual registro foi lido ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		xBuffer:=Space(nTamDet)
		FREAD(nHdlBco,@xBuffer,nTamDet)    
    
        IF SubStr(xBuffer,1,1) == "0"
            nLidos := nLidos + nTamDet
			Loop
		EndIF
		IF SubStr(xBuffer,1,1) == "1"
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Lˆ os valores do arquivo Retorno ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cNumTit :=Substr(xBuffer,Int(Val(Substr(cPosNum, 1,3))),nLenNum )
			cData   :=Substr(xBuffer,Int(Val(Substr(cPosData,1,3))),nLenData)
            cData   :=ChangDate(cData,SEE->EE_TIPODAT)
            dBaixa  :=Ctod(Substr(cData,1,2)+"/"+Substr(cData,3,2)+"/"+Substr(cData,5,2))
			cTipo   :=Substr(xBuffer,Int(Val(Substr(cPosTipo, 1,3))),nLenTipo )
			cTipo   := Iif(Empty(cTipo),"NF ",cTipo)		// Bradesco
			cNsNum  := " "
			cEspecie:= "   "
			IF !Empty(cPosDesp)
				nDespes:=Round(Val(Substr(xBuffer,Int(Val(Substr(cPosDesp,1,3))),nLenDesp))/100,2)
			EndIF
			IF !Empty(cPosDesc)
				nDescont:=Round(Val(Substr(xBuffer,Int(Val(Substr(cPosDesc,1,3))),nLenDesc))/100,2)
			EndIF
			IF !Empty(cPosAbat)
				nAbatim:=Round(Val(Substr(xBuffer,Int(Val(Substr(cPosAbat,1,3))),nLenAbat))/100,2)
			EndIF
			IF !Empty(cPosPrin)
				nValRec :=Round(Val(Substr(xBuffer,Int(Val(Substr(cPosPrin,1,3))),nLenPrin))/100,2)
			EndIF
			IF !Empty(cPosJuro)
				nJuros  :=Round(Val(Substr(xBuffer,Int(Val(Substr(cPosJuro,1,3))),nLenJuro))/100,2)
			EndIF
			IF !Empty(cPosMult)
				nMulta  :=Round(Val(Substr(xBuffer,Int(Val(Substr(cPosMult,1,3))),nLenMult))/100,2)
			EndIF
			IF !Empty(cPosOutrd)
				nOutrDesp  :=Round(Val(Substr(xBuffer,Int(Val(Substr(cPosOutrd,1,3))),nLenOutrd))/100,2)
			EndIF
			IF !Empty(cPosCc)
				nValCc :=Round(Val(Substr(xBuffer,Int(Val(Substr(cPosCc,1,3))),nLenCc))/100,2)
			EndIF
			IF !Empty(cPosDtCc)
				cData  :=Substr(xBuffer,Int(Val(Substr(cPosDtCc,1,3))),nLenDtCc)
				cData    := ChangDate(cData,SEE->EE_TIPODAT)
                dDataCred:=Ctod(Substr(cData,1,2)+"/"+Substr(cData,3,2)+"/"+Substr(cData,5,2))
				dDataUser:=dDataCred
			End
			IF !Empty(cPosNsNum)
				cNsNum  :=Substr(xBuffer,Int(Val(Substr(cPosNsNum,1,3))),nLenNsNum)
			End
			If nLenOcor == 2
				cOcorr  :=Substr(xBuffer,Int(Val(Substr(cPosOcor,1,3))),nLenOcor) + " "
			Else
				cOcorr  :=Substr(xBuffer,Int(Val(Substr(cPosOcor,1,3))),nLenOcor)
			EndIf	
			If !Empty(cPosMot)
				cMotBan:=Substr(xBuffer,Int(Val(Substr(cPosMot,1,3))),nLenMot)
			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ o array aValores ir  permitir ³
			//³ que qualquer exce‡„o ou neces-³
			//³ sidade seja tratado no ponto  ³
			//³ de entrada em PARAMIXB        ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			// Estrutura de aValores
			//	Numero do T¡tulo	- 01
			//	data da Baixa		- 02
			// Tipo do T¡tulo		- 03
			// Nosso Numero		- 04
			// Valor da Despesa	- 05
			// Valor do Desconto	- 06
			// Valor do Abatiment- 07
			// Valor Recebido    - 08
			// Juros					- 09
			// Multa					- 10
			// Outras Despesas	- 11
			// Valor do Credito	- 12
			// Data Credito		- 13
			// Ocorrencia			- 14
			// Motivo da Baixa 	- 15
			// Linha Inteira		- 16

			aValores := ( { cNumTit, dBaixa, cTipo, cNsNum, nDespes, nDescont, nAbatim, nValRec, nJuros, nMulta, nOutrDesp, nValCc, dDataCred, cOcorr, cMotBan, xBuffer })

			If lF200Var
				ExecBlock("F200VAR",.F.,.F.,{aValores})
			Endif

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica especie do titulo    ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nPos := Ascan(aTabela, {|aVal|aVal[1] == Substr(cTipo,1,2)})
			If nPos != 0
				cEspecie := aTabela[nPos][2]
			Else
				cEspecie	:= "  "
			EndIf								
            If cEspecie $ "AB-"          // Nao lˆ titulo de abatimento
                nLidos := nLidos + nTamDet
				Loop
			Endif
		Else
            nLidos := nLidos + nTamDet
			Loop
		Endif
	Else
		aLeitura := ReadCnab2(nHdlBco,MV_PAR05,nTamDet)
		If ( Empty(aLeitura[1]) )
			nLidos := nTamArq+1
			Loop
		Endif
		cNumTit  := SubStr(aLeitura[1],1,10)
		cData    := aLeitura[04]
		cData    := ChangDate(cData,SEE->EE_TIPODAT)
        dBaixa   := Ctod(Substr(cData,1,2)+"/"+Substr(cData,3,2)+"/"+Substr(cData,5,2))
		cTipo    := aLeitura[02]
		cTipo    := Iif(Empty(cTipo),"NF ",cTipo)		// Bradesco
		cNsNum   := aLeitura[11]
		nDespes  := aLeitura[06]
		nDescont := aLeitura[07]
		nAbatim  := aLeitura[08]
		nValRec  := aLeitura[05]
		nJuros   := aLeitura[09]
		nMulta   := aLeitura[10]
		cOcorr   := PadR(aLeitura[03],3)
		nValOutrD:= aLeitura[12]
		nValCC   := aLeitura[13]
		cData    := aLeitura[14]
		cData    := ChangDate(cData,SEE->EE_TIPODAT)
        dDataCred:= Ctod(Substr(cData,1,2)+"/"+Substr(cData,3,2)+"/"+Substr(cData,5,2))
		dDataUser:= dDataCred
		cMotBan  := aLeitura[15]

		aValores := ( { cNumTit, dBaixa, cTipo, cNsNum, nDespes, nDescont, nAbatim, nValRec, nJuros, nMulta, nVaLOutrD, nValCc, dDataCred, cOcorr, cMotBan, xBuffer })

		If lF200Var
			ExecBlock("F200VAR",.F.,.F.,{aValores})
		Endif

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica especie do titulo    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nPos := Ascan(aTabela, {|aVal|aVal[1] == Alltrim(Substr(cTipo,1,3))})
		If nPos != 0
			cEspecie := aTabela[nPos][2]
		Else
            cEspecie := "  "
		EndIf
        If cEspecie $ "AB-"          // Nao lˆ titulo de abatimento
			Loop
		EndIf
	EndIf   
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica codigo da ocorrencia ³
	//³ ¡ndice: Filial+banco+cod banco³
	//³ +tipo                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SEB")
    If !(dbSeek(XFILIAL()+mv_par06+cOcorr+"R"))
		Help(" ",1,"FA200OCORR")
	Endif
	If l200pos
		Execblock("FA200POS",.F.,.F.)
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se existe o titulo no SE1. Caso este titulo nao seja ³
	//³ localizado, passa-se para a proxima linha do arquivo retorno. ³
	//³ O texto do help sera' mostrado apenas uma vez, tendo em vista ³
	//³ a possibilidade de existirem muitos titulos de outras filiais.³
	//³ OBS: Sera verificado inicialmente se nao existe outra chave   ³
	//³ igual para tipos de titulo diferentes.                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SE1")
	lHelp 		:= .F.
	lNaoExiste  := .F.				// Verifica se registro de reciclagem existe no SE1
	If SEB->EB_OCORR != "39"		// cod 39 -> indica reciclagem
		dbSetOrder(1)
		If !lFa200Fil
			While .T.
                If !dbSeek(XFILIAL()+cNumTit+cEspecie)
					nPos := Ascan(aTabela, {|aVal|aVal[1] == Substr(cTipo,1,2)},nPos+1)
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
				lHelp := .T.
			EndIF
			If !lUmHelp .And. lHelp
				Help(" ",1,"NOESPECIE",,Subs(cNumTit,1,3)+" "+Subs(cNumTit,4,6)+;
				" "+Subs(cNumtit,10,1)+cEspecie,5,1)
				lUmHelp := .T.
			Endif
		Else
			l200Fil := .T.
			Execblock("FA200FIL",.F.,.F.)
		EndIf
	Else
		If lRecicl
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Mesmo que nao exista o registro no SE1, ele ser  criado no 	³
			//³ arquivo de reclicagem                                         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSetOrder(nIndex+1)
            If !dbSeek(XFILIAL()+cNsNum)
				If !lFirst
					Fa200Recic()				// Abre arquivo de reciclagem
					lFirst := .T.
				EndIf
                Fa200GrRec()
				lNaoExiste := .T.				// Registro nao existente no SE1 -> portanto nao deve gravar nada no SE1!!
			Endif
		Else			//  uma rejeicao porem o registro nao foi cadastrado no SE1
			Help(" ",1,"NOESPECIE",,Subs(cNumTit,1,3)+" "+Subs(cNumTit,4,6)+;
			" "+Subs(cNumtit,10,1)+cEspecie,5,1)
			lNaoExiste := .T.
		EndIf	
	EndIF	

	If !lHelp .And. !lNaoExiste
		lSai := .f.
		IF SEB->EB_OCORR $ "03ü15ü16ü17ü40ü41ü42"		//Registro rejeitado
			For nCont := 1 To Len(cMotBan) Step 2
				cMotivo := Substr(cMotBan,nCont,2)
                If fa200Rejeita()
					lSai := .T.
					Exit
				EndIf
			Next nCont
			If lSai
				If ( MV_PAR12 == 1 )
                    nLidos := nLidos + nTamDet
				Endif
				Loop
			EndIf
		Endif
		
        IF SEB->EB_OCORR $ "06ü07ü08ü09ü10ü23ü32ü33ü34ü36ü37ü38ü39"       //Baixa do Titulo
            ALERT(SEB->EB_OCORR)
            cPadrao:=fA070Pad()
			lPadrao:=VerPadrao(cPadrao)
			lContabiliza:= Iif(mv_par11==1,.T.,.F.)
                
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Monta Contabilizacao.         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If !lCabec .and. lPadrao .and. lContabiliza
				nHdlPrv:=HeadProva(cLote,"FINA200",Substr(cUsuario,7,6),@cArquivo)
				lCabec := .T.
			End
			nValEstrang := SE1->E1_SALDO
			lDesconto   := Iif(mv_par10==1,.T.,.F.)
			nTotAbat	:= SumAbatRec(Subs(cNumtit,1,3),Subs(cNumtit,4,6),;
			Subs(cNumtit,10,1),SE1->E1_MOEDA,"S",dBaixa)
			cBanco      := Iif(Empty(SE1->E1_PORTADO),cBanco,SE1->E1_PORTADO)
			cAgencia    := Iif(Empty(SE1->E1_AGEDEP),cAgencia,SE1->E1_AGEDEP)
			cConta      := Iif(Empty(SE1->E1_CONTA),cConta,SE1->E1_CONTA)
            If SEB->EB_OCORR $ "06ü07"
                cHist070    := OemToAnsi("Valor Recebido Titulo")
            ElseIf SEB->EB_OCORR $ "08"
                cHist070    := OemToAnsi("Valor Liquidado Cartorio")
            ElseIf SEB->EB_OCORR $ "09"
                cHist070    := OemToAnsi("Baixa - Simples")
            ElseIf SEB->EB_OCORR $ "10"
                cHist070    := OemToAnsi("Baixa - Liquidado")
            ElseIf SEB->EB_OCORR $ "23"
                cHist070    := OemToAnsi("Protesto Enviado Cartorio")
            ElseIf SEB->EB_OCORR $ "32"
                cHist070    := OemToAnsi("Baixa - Protestado")
            ElseIf SEB->EB_OCORR $ "33"
                cHist070    := OemToAnsi("Custas de Protesto")
            ElseIf SEB->EB_OCORR $ "34"
                cHist070    := OemToAnsi("Custas de Sustacao")
            ElseIf SEB->EB_OCORR $ "36"
                cHist070    := OemToAnsi("Liq Normal - Cheque/Comp")
            ElseIf SEB->EB_OCORR $ "37"
                cHist070    := OemToAnsi("Liq Cartorio - Cheque")
            ElseIf SEB->EB_OCORR $ "38"
                cHist070    := OemToAnsi("Liq por Conta - Cheque")
            ElseIf SEB->EB_OCORR $ "39"
                cHist070    := OemToAnsi("Valor Recebido sem Boleto")
            EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se a despesa est     ³
			//³ descontada do valor principal ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If SEE->EE_DESPCRD == "S"
				nValRec := nValRec+nDespes + nOutrDesp
			EndIf
			// Calcula a data de credito, se esta estiver vazia
			If dDataCred == Nil .Or. Empty(dDataCred)
				dDataCred := dBaixa // Assume a data da baixa
				For nX := 1 To Sa6->A6_Retenca // Para todos os dias de retencao
														 // valida a data

					// O calculo eh feito desta forma, pois os dias de retencao
					// sao dias uteis, e se fosse apenas somado dDataCred+A6_Retenca
					// nao sera verdadeiro quando a data for em uma quinta-feira, por
					// exemplo e, tiver 2 dias de retencao.
					dDataCred := DataValida(dDataCred+1,.T.)
				Next
			EndIf
			dDataUser := dDataCred

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Possibilita alterar algumas das  ³
			//³ vari veis utilizadas pelo CNAB.  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lFina200
				ExecBlock("FINA200",.F.,.F.)
			Endif

			lBaixou:=fA070Grv(lPadrao,lDesconto,lContabiliza,cNsNum,.T.,dDataCred,.f.,cArqEnt,SEB->EB_OCORR)
			If lBaixou
                nTotAGer := nTotAGer + nValRec
			Endif	

			If lBxCnab
                nTotValCc := nTotValCc + nValCC
			Else
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Grava Outros Cr‚ditos, se houver valor                 ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If nValcc > 0
					fa200Outros()
				Endif
			Endif
			
			If lCabec .and. lPadrao .and. lContabiliza .and. lBaixou
                nTotal := nTotal + DetProva(nHdlPrv,cPadrao,"FINA200",cLote)
			Endif

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Credito em C.Corrente -> gera ³
			//³ arquivo de reciclagem         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If SEB->EB_OCORR $ "39"
				If lRecicl
					If !lFirst
						Fa200Recic()
						lFirst := .T.
					EndIf
                    Fa200GrRec()
					dbSelectArea("SE1")
					RecLock("SE1")
					Replace E1_OCORREN With "02"
					MsUnlock()
				EndIf	
			EndIf
		Endif

      If lBxCnab
        nTotDesp := nTotDesp + nDespes
            nTotOutD := nTotOutD + nOutrDesp
      Else
			IF nDespes > 0 .or. nOutrDesp > 0		//Tarifas diversas
				Fa200Tarifa()
			Endif
		Endif			

		If SEB->EB_OCORR == "02"			// Confirma‡„o
			RecLock("SE1")
			SE1->E1_OCORREN := "01"
			If Empty(SE1->E1_NUMBCO)
				SE1->E1_NUMBCO  := cNsNUM
			EndIf
			MsUnLock()
			If lFa200_02
				ExecBlock("FA200_02",.f.,.f.)
			Endif
		Endif

	Endif
	// Avanca uma linha do arquivo retorno
	If ( mv_par12 == 1 )
        nLidos := nLidos + nTamDet
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Possibilita alterar algumas das  ³
	//³ vari veis utilizadas pelo CNAB.  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lF200Tit
		ExecBlock("F200TIT",.F.,.F.)
	Endif

Enddo

If lCabec .and. lPadrao .and. lContabiliza 
	dbSelectArea("SE1")
	dbGoBottom()
	dbSkip()
	VALOR := nTotAger
    nTotal:= nTotal + DetProva(nHdlPrv,cPadrao,"FINA200",cLote)
Endif

If l200Fil .and. lfa200F1
	Execblock("FA200F1",.f.,.f.)
Endif

If lF200Fim
	Execblock("F200FIM",.f.,.f.)
Endif

IF lCabec .and. nTotal > 0
	RodaProva(nHdlPrv,nTotal)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Envia para Lancamento Contabil                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cA100Incl(cArquivo,nHdlPrv,3,cLote,lDigita,lAglut)
Endif
If lRecicl .and. lFirst
	dbSelectArea("cTemp")
	dbCloseArea()
	If cIndex != " "
		RetIndex("SE1")
		Set Filter To
		FErase (cIndex+OrdBagExt())
	EndIf	
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Grava no SEE o n£mero do £ltimo lote recebido e gera ³
//³ movimentacao bancaria											³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty(cLoteFin) .and. lBxCnab
	RecLock("SEE",.F.)
	SEE->EE_LOTE := cLoteFin
	msUnLock()
	If nTotAger > 0
		Reclock( "SE5" , .T. )
		SE5->E5_FILIAL := xFilial()
		SE5->E5_DATA   := dDataBase
		SE5->E5_VALOR  := nTotAger
		SE5->E5_RECPAG := "R"
		SE5->E5_DTDIGIT:= dDataBase
		SE5->E5_BANCO  := cBanco
		SE5->E5_AGENCIA:= cAgencia
		SE5->E5_CONTA  := cConta
		SE5->E5_DTDISPO:= dDataBase
		SE5->E5_LOTE   := cLoteFin
        SE5->E5_HISTOR := "Baixa por Retorno CNAB / Lote : "+ cLoteFin 
		MsUnlock()
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza saldo bancario.      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		AtuSalBco(cBanco,cAgencia,cConta,SE5->E5_DATA,nTotAger,"+")
	Endif
	If nTotDesp > 0 .Or. nTotOutD > 0
        Fa200Tarifa()
	Endif		
	If nTotValCC > 0
        fa200Outros()
	Endif		
EndIf
VALOR := 0
dbSelectArea( "SE1" )
dbGoTo( nSavRecno )
Return .F.
