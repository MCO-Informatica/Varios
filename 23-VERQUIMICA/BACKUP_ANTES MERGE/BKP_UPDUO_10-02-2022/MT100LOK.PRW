#include "Rwmake.ch"
#include "Protheus.ch"

//========================================================================
// Programa....: MT100LOK
// Autor.......: Anderson Goncalves
// Data........: 08/07/2021
// Descricao...: Ponto de entrada para validação da linha do docto entrada
// Uso.........: Verquimica
//========================================================================

User Function MT100LOK()

//===============================================
// Variaveis da Rotina
//===============================================
Local lRet      := .T.
Local cProd     := GetMv("VQ_CODEXT",,"02HEXAA0,02HEXAA5")
Local nPosCon   := ascan(aHeader,{|x| AllTrim(x[2]) == "D1_XCONV"})
Local nPosPro   := ascan(aHeader,{|x| AllTrim(x[2]) == "D1_COD"})
Local nX        := 0

//================================
// Processa os itens do aCols
//================================
/*If FunName() == "MATA103"
    For nX := 1 To Len(aCols)
        If AllTrim(aCols[nX,nPosPro]) $ cProd
            If aCols[nX,nPosCon] == 0
                msgInfo("Para o produto "+AllTrim(aCols[nX,nPosPro])+", é obrigatória a digitação da densidade!","Atenção")
                lRet := .F.
                Exit
            EndIf
        Endif
    Next nX
EndIf*/

Return(lRet)   

//========================================================================
// Programa....: GATMT103
// Autor.......: Anderson Goncalves
// Data........: 08/07/2021
// Descricao...: Gatilho para segunda unidade de medida
// Uso.........: Verquimica
//========================================================================

User Function GATMT103()

//================================================
// Variaveis da Rotina
//================================================
Local nRet      := 0
Local nPosSeg   := ascan(aHeader,{|x| AllTrim(x[2]) == "D1_XCONV"})
Local nPosCon   := ascan(aHeader,{|x| AllTrim(x[2]) == "D1_QTSEGUM"})
Local nPosPro   := ascan(aHeader,{|x| AllTrim(x[2]) == "D1_COD"})
Local nPosUni   := ascan(aHeader,{|x| AllTrim(x[2]) == "D1_VUNIT"})
Local nPosTot   := ascan(aHeader,{|x| AllTrim(x[2]) == "D1_TOTAL"})
Local nPosVse   := ascan(aHeader,{|x| AllTrim(x[2]) == "D1_VQ_VSEG"})
Local cProd     := GetMv("VQ_CODEXT",,"02HEXAA0,02HEXAA5")

If AllTrim(aCols[n,nPosPro]) $ cProd
    If aCols[n,nPosSeg] > 0 .and. aCols[n,nPosCon] > 0
        nRet := aCols[n,nPosSeg] * aCols[n,nPosCon]
        aCols[n,nPosVse] := 0
        aCols[n,nPosCon] := 0
        aCols[n,nPosTot] := aCols[n,nPosUni] * nRet
    EndIf
EndIf

Return(nRet)
