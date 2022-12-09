#include "protheus.ch"

/************************************************************************
    GLASSTECH 
    Fernando Sancho - 21/01/2022
************************************************************************/

/*
    U_SF1DOC()

    Função validação de Usuário usado no Dicionario de Dados \ Campos -> Validações
    Val. Usuario do campo SF1->F1_DOC
    
    Está função tem como objetivo quando campos F1_DOC tiver preenchido
    Acrescentar zero a esqueda até completar a quantidade de 9 digitos

    Ultima alteração : 21/01/2022 10:54 - FERNANDO
*/

User Function SF1DOC()
    If !Empty(M->F1_DOC) .Or. !Empty(cNFISCAL)
        M->F1_DOC := StrZero(Val(M->F1_DOC),9)
        CNFISCAL := M->F1_DOC
    Endif  
Return(.T.)

/*
    U_SF1SERIE()

    Função validação de Usuário usado no Dicionario de Dados \ Campos -> Validações
    Val. Usuario do campo SF1->F1_SERIE
    
    Está função tem como objetivo quando campos F1_SERIE tiver preenchido, e for digito de [0..9]
    caso contrario não faz nada.
    Acrescentar zero a esqueda até completar a quantidade de 3 digitos

    Ultima alteração : 21/01/2022 10:54 - FERNANDO

*/

User Function SF1SERIE()
    If !Empty(M->F1_SERIE) .Or. !Empty(cSERIE)
        // Verifica se todos digitos estão dentro 0..9
        If IsDigit(M->F1_SERIE)     
            M->F1_SERIE := StrZero(Val(M->F1_SERIE),3)
            CSERIE := M->F1_SERIE
        EndIf
    EndIf
Return(.T.)
