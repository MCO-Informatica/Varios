#Include "RWMake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO5     ºAutor  ³Microsiga           º Data ³  07/19/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Retorna o valor do desconto Financeiro                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                       )  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function DESCFIN()
    nDescValTi := 0
    If SE1->E1_DESCFIN > 0

        nDescValTi := round(SE1->E1_VALOR *(SE1->E1_DESCFIN/100),2)

    EndIf

Return(nDescValTi)


User Function reccta()

    SetPrvt("_AGENCIACTA")

/////  VERIFICACAO DA AGENCIA E CONTA A SEREM UTILIZADOS 

    _AGENCIACTA  :=  ""

    _AGENCIACTA := "0" + StrZero(Val(SEE->EE_CODCART),3) + StrZero(Val(SEE->EE_AGENCIA),5) + StrZero(Val(Alltrim(Substr(SEE->EE_CONTA,1,6))),7)+SEE->EE_DVCTA

Return(_AGENCIACTA)


/*/
    ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
    ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
    ±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
    ±±³Fun‡…o    ³ Nossonum ³ Autor ³ Christian Recife      ³ Data ³ 30/01/98 ³±±
    ±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
    ±±³Descri‡…o ³ Gera a fun‡Æo NossoNum() + o digito de controle. Este c¢di-³±±
    ±±³          ³ go gerado, ser  gravado no E1_NUMBCO e no arquivo TXT.     ³±±
    ±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
    ±±³ Uso      ³ Gen‚rico                                                   ³±±
    ±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
    ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
    ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function Nossonr(lBcoCorr)

    If Type("LBCOCORR") == "U"
        lBcoCorr := .F.
    EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Fun‡Æo para gerar NossoNum()                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

    If Empty(SE1->E1_NUMBCO)

        dbSelectArea("SEE")
        RecLock("SEE",.f.)

        If !lBcoCorr
            SEE->EE_FAXATU := Strzero( ( Val( SEE->EE_FAXATU ) +1 ), 11 )
        Else
            SEE->EE_NOSSNUM := Strzero( ( Val( SEE->EE_NOSSNUM ) +1 ), 11 )
        EndIf

        MsUnlock()

        dbSelectArea("SE1")

        _cFaixa := If(lBcocorr,SEE->EE_NOSSNUM,SEE->EE_FAXATU)

        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Fun‡Æo para gerar Digito de Controle                         ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


        nResult := 0
        nSoma   := 0
        cDc     := ""
        i       := 0
        //nTam    := Len( SEE->EE_FKCART ) + Len( Alltrim( SE1->E1_NUMBCO ) )
        nTam    := Len( Alltrim( _cFaixa ) ) + 2

        If lBcoCorr
            cCart :=  StrZero(Val(SEE->EE_CODCARTCOR),2)
        Else
            cCart := StrZero(Val(SEE->EE_CODCART),2)
        EndIf
        cCrtBco := ( cCart  + AllTrim( _cFaixa ) )
        nDc     := 0
        nMulti  := 2
        nTam    := Len(Alltrim(cCrtBco))

        For i  := Len(Alltrim(cCrtBco)) To 1 Step -1
            nSoma   := Val(Substr(cCrtBco,nTam,1))*nMulti
            nResult := nResult + nSoma
            nTam    := nTam - 1

            If ( NMULTI < 7 )
                NMULTI := NMULTI + 1
            Else
                NMULTI := 2
            Endif

        Next i

        nDC  := Mod(nResult,11)

        Do Case
        Case ( nDc = 1 )

            cDig := "P"
        Case ( nDc = 0 )

            cDig := "0"
        otherwise

            cDig := Str( ( 11 - nDc ), 01 )
        EndCase

        Nossonum := Alltrim(_cFaixa) + Alltrim(cDig)

        DbSelectArea("SE1")
        RecLock("SE1",.F.)
        SE1->E1_NUMBCO := Nossonum
        MsUnlock()

    EndIf

Return(SE1->E1_NUMBCO)


User Function RetCodEmp()
    Local cCodEmp := Replicate("0",14)

    cCodEmp := StrZero(Val(Alltrim(SEE->EE_AGENCIA)),4)
    cCodEmp += StrZero(Val(Alltrim(SEE->EE_CONTA)),9)
    cCodEmp += Alltrim(SEE->EE_DVCTA)

Return cCodEmp


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO3     ºAutor  ³Microsiga           º Data ³  06/02/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retorna o nosso numero para o Banco Santander              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function NumSantand()
    Local cNroDoc := Replicate("0",13)

//cNumSeq	:= strzero(VAL(SE1->E1_PREFIXO),3)
    cNumSeq	:= StrZero(Val(Substr(SE1->E1_NUM,4,6)+StrZero(Val(SE1->E1_PARCELA),2)),12) // StrZero(Val(SE1->E1_NUM),12)

    If !Empty(SE1->E1_NUMBCO)
        cNroDoc  := Right(Alltrim(SE1->E1_NUMBCO),8) //Substr(SE1->E1_NUMBCO,4,7)+
    Else
        cNroDoc  := cNumSeq
        cDig     := Modulo11(cNroDoc)
        cNroDoc  += cDig
    Endif

    If Empty(SE1->E1_NUMBCO)
        cNroDoc := cNumSeq
        cDig    := Modulo11(cNroDoc) //STRZERO(VAL(NOSSONUM()),12)
        RecLock("SE1",.F.)
        SE1->E1_NUMBCO := cNroDoc+Modulo11(cNroDoc)
        SE1->(MsUnlock())
        cNroDoc += cDig //SE1->E1_NUMBCO

        cNroDoc  := Right(Alltrim(SE1->E1_NUMBCO),8)

    Endif

Return cNroDoc

User Function DtLimDesc()
    Local cData := IF(SE1->E1_DESCFIN>0,GravaData(SE1->E1_VENCREA,.F.),"000000")
Return cData


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NumBcoBrasºAutor  ³Microsiga           º Data ³  06/02/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retorna o nosso numero para o Banco do Brasil              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function NumBcoBrasil()
    Local cNroDoc := Replicate("0",10)

    cNumSeq	:= StrZero(Val(SE1->E1_NUM),7)+StrZero(Val(SE1->E1_PARCELA),3)

    If !Empty(SE1->E1_NUMBCO)
        cNroDoc  := Substr(Alltrim(SE1->E1_NUMBCO),1,10)
    Else

        cNroDoc  := cNumSeq
//   cDig     := Modulo11(cNroDoc)
//   cNroDoc  += cDig
    Endif

    If Empty(SE1->E1_NUMBCO)
        cNroDoc := cNumSeq
//	cDig    := Modulo11(cNroDoc) //STRZERO(VAL(NOSSONUM()),12)
        RecLock("SE1",.F.)
        SE1->E1_NUMBCO := cNroDoc //+Modulo11(cNroDoc)
        SE1->(MsUnlock())
        //cNroDoc //+= cDig //SE1->E1_NUMBCO
    Endif

Return cNroDoc