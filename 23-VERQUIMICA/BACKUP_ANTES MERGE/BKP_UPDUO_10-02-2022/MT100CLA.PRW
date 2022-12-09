#include "Rwmake.ch"
#include "Protheus.ch"

//========================================================================
// Programa....: MT100CLA
// Autor.......: Anderson Goncalves
// Data........: 08/07/2021
// Descricao...: Ponto de entrada para classificacao da nota fiscal
// Uso.........: Verquimica
//========================================================================

User Function MT100CLA()

//===============================================
// Variaveis da Rotina
//===============================================
Local cProd     := GetMv("VQ_CODEXT",,"02HEXAA0, 02HEXAA5")
Local aAreaD1   := SD1->(GetArea())
Local aAreaB1   := SB1->(GetArea())

Local _oDlg     := Nil
Local nEdit     := 0
Local oEdit     := Nil
Local nOpcZ     := 0
Local cProduto  := ""

/*
//===============================================
// Posiciona nas tabelas
//===============================================
dbSelectArea("SB1")
SB1->(dbSetOrder(1))

dbSelectArea("SD1")
SD1->(dbSetOrder(1)) //D1_FILIAL, D1_DOC, D1_SERIE, D1_FORNECE, D1_LOJA, D1_COD, D1_ITEM
SD1->(dbSeek(SF1->F1_FILIAL+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA ))
While SD1->(!EOF()) .and. SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA) == SD1->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA)

    If AllTrim(SD1->D1_COD) $ cProd
        SB1->(dbSeek(xFilial("SB1")+SD1->D1_COD ))
        nEdit := SB1->B1_CONV
        cProduto := AllTrim(SB1->B1_COD)+" - "+AllTrim(SB1->B1_DESC)

        //======================================
        // Monta interface com o usuario
        //======================================
        DEFINE MSDIALOG _oDlg TITLE OemtoAnsi("Classificação de Doctos") FROM 230,167 TO 434,678 PIXEL

        // Cria Componentes Padroes do Sistema
        @ 007,005 Say "Os produtos com código "+cProd+","                 Size 217,008 COLOR CLR_BLACK PIXEL OF _oDlg
        @ 016,005 Say "possuem densidade variável devendo aqui ser atualizado para o correto cálculo da segunda unidade" Size 240,008 COLOR CLR_BLACK PIXEL OF _oDlg
        @ 025,005 Say "de medida na classificação do documento."          Size 217,008 COLOR CLR_BLACK PIXEL OF _oDlg
        @ 039,005 Say "Produto:"                                          Size 022,008 COLOR CLR_BLACK PIXEL OF _oDlg
        @ 039,027 Say cProduto                                            Size 217,008 COLOR CLR_BLACK PIXEL OF _oDlg
        @ 052,036 MsGet oEdit Var nEdit  Picture "@E 99,999,999.999999"   Size 060,009 COLOR CLR_BLACK PIXEL OF _oDlg HASBUTTON
        @ 053,005 Say "Densidade:"                                        Size 029,008 COLOR CLR_BLACK PIXEL OF _oDlg
        @ 065,005 Say "________________________________________________________________________________" Size 242,008 COLOR CLR_BLACK PIXEL OF _oDlg
        @ 076,167 Button OemtoAnsi("&Gravar")                             Size 037,012 PIXEL OF _oDlg Action(nOpcZ:=1,_oDlg:End())
        @ 076,207 Button OemtoAnsi("&Cancela")                            Size 037,012 PIXEL OF _oDlg Action(_oDlg:End())

        ACTIVATE MSDIALOG _oDlg CENTERED 

        If nOpcZ == 1
            RecLock("SB1",.F.)
            SB1->B1_CONV := nEdit
            SB1->(msUnlock())
        EndIf
    EndIf

    SD1->(dbSkip())
Enddo
*/

RestArea(aAreaB1)
RestArea(aAreaD1)

Return(.T.)

