#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"  
#INCLUDE "TbiConn.ch"
#INCLUDE "rwmake.ch"    

//==================================================================================
// Programa.....: MT235AIR
// Autor........: Anderson Goncalves
// Data.........: 23/03/21
// Descricao....: Ponto de entrada após a gravação da eliminação de residuo por SC
// Uso..........: Verquimica
//==================================================================================

User Function MT235AIR()

//==============================================
// Variaveis da Rotina
//==============================================
Local nOpcA     := 0
Local cMemo1    := ""
Local oMemo1    := Nil
Local cQuery    := Nil
Local cSolicit  := ""
Local aAreaAt   := GetArea()
Private lCont   := .T.

If ParamIXB[2] == 3

    cSolicit := SC1->C1_NUM

    //==============================================
    // Monta interface com o usuario
    //==============================================
    If SC1->(FieldPos("C1_XMOTIVO")) > 0
      If Empty(SC1->C1_XMOTIVO) .and. SC1->C1_QUANT <> SC1->C1_QUJE
            While lCont
                DEFINE MSDIALOG _oDlg TITLE OemtoAnsi("Eliminação de Residuos") FROM 214,175 TO 427,676 PIXEL

                @ 019,007 TO 076,241 LABEL " Motivo " PIXEL OF _oDlg
                @ 008,007 Say "Solicitação:"            Size 029,008 COLOR CLR_BLACK PIXEL OF _oDlg
                @ 008,039 Say SC1->C1_NUM               Size 053,008 COLOR CLR_BLACK PIXEL OF _oDlg
                @ 026,010 GET oMemo1 Var cMemo1 MEMO    Size 226,044 PIXEL OF _oDlg
                @ 079,203 Button OemtoAnsi("&Salvar")   Size 037,012 PIXEL OF _oDlg Action( If(VerDig(cMemo1),(_oDlg:End(),nOpcA:=1),) )

                ACTIVATE MSDIALOG _oDlg CENTERED 
            Enddo

            If nOpcA == 1
                dbSelectArea("SC1")
                SC1->(dbSetOrder(1))
                SC1->(dbSeek(xFilial("SC1")+cSolicit))
                While SC1->(!EOF()) .and. SC1->(C1_FILIAL+C1_NUM) == FWxFilial("SC1")+cSolicit
                    If SC1->C1_ITEM >= mv_par14 .and. SC1->C1_ITEM <= mv_par15
                        RecLock("SC1",.F.)
                        SC1->C1_XMOTIVO := cMemo1
                        SC1->(msUnlock())
                        SC1->(dbSkip())
                    EndIf
                Enddo

            EndIf
        EndIf
    EndIf

EndIf

RestArea(aAreaAt)

Return Nil

//==================================================================================
// Programa.....: VerDig
// Autor........: Anderson Goncalves
// Data.........: 23/03/21
// Descricao....: Verifica a digitação do campo memo
// Uso..........: Verquimica
//==================================================================================

Static Function VerDig(xConteudo)

//============================================
// Variaveis da Rotina
//============================================
Local lRet  := .T.

If Empty(xConteudo)
    msgStop("Obrigatório a digitação do motivo da eliminação de residuo!","Atenção")
    lRet := .F.
Else
    If Len(AllTrim(xConteudo)) < 15
        msgStop("Obrigatório o mínimo de 15 caracteres!","Atenção")   
        lRet := .F.
    Else
        lCont := .F. 
    EndIf  
EndIf

Return(lRet)
