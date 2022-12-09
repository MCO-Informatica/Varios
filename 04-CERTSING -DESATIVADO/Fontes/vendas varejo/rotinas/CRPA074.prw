#INCLUDE "PROTHEUS.CH"

User Function CRPA074()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local oDlg
Local nOpc		:= 0								// 1 = Ok, 2 = Cancela
Local cFileIn	:= Space(256)
Local cFileOut	:= Space(256)
Local cDirIn	:= Space(256)
Local aDirIn	:= {}
Local nI		:= 0
Local cSaida	:= cFileOut
Local cAux		:= ""
Local nHandle	:= -1
Local lRet		:= .F.
Private cTipMan

Private cPeriod	:= Space(6)
Private lZero	:= .F.

DEFINE MSDIALOG oDlg FROM  36,1 TO 160,550 TITLE "Atualização Voucher F" PIXEL

@ 10,010 SAY "Dir. Arq. de entrada" OF oDlg PIXEL
@ 10,070 MSGET cDirIn SIZE 200,5 OF oDlg PIXEL

@ 45,010 BUTTON "File"		SIZE 40,13 OF oDlg PIXEL ACTION CRPA074F(@aDirIn,@cDirIn)
@ 45,060 BUTTON "OK"		SIZE 40,13 OF oDlg PIXEL ACTION (nOpc := 1,oDlg:End())
@ 45,230 BUTTON "Cancel"	SIZE 40,13 OF oDlg PIXEL ACTION (nOpc := 2,oDlg:End())

ACTIVATE MSDIALOG oDlg CENTERED

If !nOpc == 1
	Return(.F.)
EndIf

If len(aDirIn) = 0
	MsgAlert("Não Foram encontrados Arquivos para processamento!")
	Return(.F.)
EndIf

//Proc2BarGauge({|| OkLeTxt(cDirIn,aDirIn) },"Processamento de Arquivo TXT")
Processa( {|| OkLeTxt(cDirIn,aDirIn) }, "Processamento de Arquivo TXT") 

Return

Static Function OkLeTxt(cDirIn,aDirIn)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Abertura do arquivo texto                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local Ni

Private cArqTxt := ""
Private nHdl    := ""

Private cEOL    := "CHR(13)+CHR(10)"
If Empty(cEOL)
	cEOL := CHR(13)+CHR(10)
Else
	cEOL := Trim(cEOL)
	cEOL := &cEOL
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa a regua de processamento                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

For nI:= 1 to len(aDirIn)
	cArqTxt := cDirIn+aDirIn[nI][1]
	nHdl    := fOpen(cArqTxt,68)
	//	If nHdl == -1
	//    	MsgAlert("O arquivo de nome "+cArqTxt+" nao pode ser aberto! Verifique os parametros.","Atencao!")
	//	Endif
	
	//IncProcG1("Proc. Arquivo "+aDirIn[nI][1])
	//ProcessMessage()
	
	IncProc( "Proc. Arquivo "+aDirIn[nI][1] )
	ProcessMessage()
	
	CRPA74A(aDirIn[nI][1])
Next

Return

Static Function CRPA74A(cArqcalc)

    Local nTamFile, nTamLin, cBuffer, nBtLidos, xBuff, aLin, cTipLin
    Local cPedido
    Local cVoucher
    Local cPedSite
    Local oChk

    //ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
    //º Lay-Out do arquivo Texto gerado:                                º
    //ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹
    //ºCampo           ³ Inicio ³ Tamanho                               º
    //ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶
    //º ??_FILIAL     ³ 01     ³ 02                                    º
    //ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼

    FT_FUSE(cArqTxt)

    nTotRec := FT_FLASTREC()

    FT_FGOTOP()

    IncProc()
    ProcessMessage()

    While !FT_FEOF()
        
        xBuff	:= alltrim(FT_FREADLN())
        aLin 	:= StrTokArr(xBuff,";")
        
        cPedido 	:= Iif(Len(aLin)>0,aLin[1],"")	        //aLin[1] = Pedido Gar
        cVoucher    := Iif(Len(aLin)>1,aLin[2],"")	    //aLin[1] = Pedido Gar

        If !Empty(cPedido) .And. !Empty(cVoucher)

            BeginSql Alias "TMPVOU"
                SELECT R_E_C_N_O_ RECN FROM SZG010 WHERE ZG_FILIAL = ' ' AND ZG_NUMVOUC = %Exp:cVoucher% AND D_E_L_E_T_ = ' '
            EndSql

            dbSelectArea("SZG")
            SZG->(dbGoTo(TMPVOU->RECN))

            If SZG->(!EoF())
                If Empty(SZG->ZG_NUMPED)
                    RecLock("SZG",.F.)
                        SZG->ZG_NUMPED := cPedido
                    SZG->(MsUnlock())
                EndIf
            EndIf

            oChk := CheckoutRestClient():New()
            cPedSite := oChk:getPedSiteFromPedGar(cPedido)

            If !Empty(cPedSite)
                dbSelectArea("SC5")
                SC5->(dbOrderNickname("PEDSITE"))
                If SC5->(dbSeek(xFilial("SC5") + cPedSite))
                    
                    dbSelectArea("SC6")
                    SC6->(dbSetOrder(1))
                    If SC6->(dbSeek(xFilial("SC6") + SC5->C5_NUM))

                        While SC6->(!EOF()) .And. SC6->C6_NUM == SC5->C5_NUM
                            If Empty(SC6->C6_PEDGAR)
                                RecLock("SC6", .F.)
                                    SC6->C6_PEDGAR := cPedido
                                SC6->(MsUnlock())
                            EndIf
                            SC6->(dbSkip())
                        EndDo

                    EndIf

                EndIf
            EndIf

            TMPVOU->(dbCloseArea())

        EndIf


        FT_FSKIP()
    EndDo

    FT_FUSE()
    fClose(nHdl)

    MsgInfo("Os registros foram recalculados com sucesso")

Return

Static Function CRPA074F(aDirIn,cDirIn)
Local cAux := ""

cDirIn := IIF(!Empty(cAux:=(cGetFile("\", "Diretórios", 1,"X:\" ,.F. , GETF_RETDIRECTORY+GETF_LOCALHARD ))),cAux,cDirIn)

aDirIn := Directory(cDirIn+"*.CSV")

Return(.T.)
