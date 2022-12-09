#include "totvs.ch"
#INCLUDE "RWMAKE.CH" 
#INCLUDE "TBICONN.CH"

/*/
Este PE é executado após todas as gravações dos títulos - SE2 e SE5
O SE5 estará posicinado no registro da última compensação efetuada - NF/DP (e não no registro PA)

Atualização em:
03/08/2021 - Luiz - A partir do movimento da compensação (SE5) localizar e atualizar os titulos TX dessa compensação
/*/

USER FUNCTION F340GRV()

Local aArea    := GetArea()
Local aAreaSE5 := SC5->(GetArea())
Local nOpc     := ParamixB[1]
Local cNomeFor := Posicione("SA2", 1, xFilial("SA2") + SE2->(E2_FORNECE+E2_LOJA), "A2_NREDUZ")
Local cHist    := ""
Local cChaveSE5:= SE5->E5_FILIAL+SE5->E5_TIPODOC+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO+DtoS(SE5->E5_DATA)+SE5->E5_CLIFOR+SE5->E5_LOJA
Local cChaveAtu:= "" 

if nOpc <> 1
   Return()
endif

dbSelectArea("SE5")
dbSetOrder(2)
dbSeek(cChaveSE5)

while .T.

   cChaveAtu := E5_FILIAL+E5_TIPODOC+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+DtoS(E5_DATA)+E5_CLIFOR+E5_LOJA
   if AllTrim(cChaveAtu) <> AllTrim(cChaveSE5) .or. EOF()   
      exit
   endif

   if E5_RECPAG <> "P"     // Se não for movimento a Pagar ignora
      dbSkip()
      loop
   endif
    
   // Localicar o Título pelo Numero do Título PAI - E2_TITPAI = E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA
   dbSelectArea("SE2")
   dbSetOrder(17)
   dbSeek(xFilial("SE2")+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO+SE5->E5_CLIFOR+SE5->E5_LOJA)

   while .T.

      if AllTrim(E2_TITPAI) <> (SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO+SE5->E5_CLIFOR+SE5->E5_LOJA) .or. EOF()
         exit
      endif

      if (AllTrim(E2_TIPO) <> "TX") .or. (E2_EMISSAO <> SE5->E5_DATA)
         dbSkip()
         loop
      endif

      do Case     
         Case E2_VALOR = SE5->E5_VRETPIS .and. AllTrim(E2_NOMFOR) <> AllTrim(cNomeFor)
              cHist := "PIS S/NF " + Alltrim(SE2->E2_NUM) + " " + cNomeFor
         Case E2_VALOR = SE5->E5_VRETCOF .and. AllTrim(E2_NOMFOR) <> AllTrim(cNomeFor)
              cHist := "COF S/NF " + Alltrim(SE2->E2_NUM) + " " + cNomeFor
         Case E2_VALOR = SE5->E5_VRETCSL .and. AllTrim(E2_NOMFOR) <> AllTrim(cNomeFor)
              cHist := "CLS S/NF " + Alltrim(SE2->E2_NUM) + " " + cNomeFor
         OtherWise
              cHist := ""
      endcase

      if !Empty(AllTrim(cHist))
         RecLock("SE2",.F.)
         E2_HIST   := cHist  
         E2_NOMFOR := cNomeFor
         MSUnlock()
      endif

      dbSkip()

   enddo

   dbSelectArea("SE5")
   dbSetOrder(2)
   dbSkip()

enddo

RestArea(aAreaSE5)
RestArea(aArea)

Return

//E5_DATA E5_TIPO E5_VALOR E5_NATUREZ E5_DOCUMEN E5_TIPODOC E5_SITUACA E5_PREFIXO E5_NUMERO E5_PARCELA E5_CLIFOR E5_LOJA

//SE5->E5_VRETPIS  SE5->E5_VRETCOF   SE5->E5_VRETCSL   SE5->E5_PRETPIS   SE5->E5_PRETCOF   SE5->E5_PRETCSL  SE5->E5_VRETISS

// aRetImp --> ARRAY COM OS TITULOS DE IMPOSTO     SE5->E5_PREFIXO SE5->E5_NUM
// aImpFK3FK4 --> ARRAY QUE RECEBE OS TÍTULOS  --> não tem mais essa array

// E2_TITPAI = LMS000000002A  DP 01100701                        
//             E2_PREFIXO  E2_NUM  E2_PARCELA  E2_TIPO  E2_FORNECE  E2_LOJA


// SE2->E2_PREFIXO  SE2->E2_NUM  SE2->E2_PARCELA  SE2->E2_TIPO  SE2->E2_VALOR  SE2->E2_SALDO

// FIE->FIE_PEDIDO  FIE->FIE_PREFIX  FIE->FIE_NUM  FIE->FIE_PARCEL  FIE->FIE_TIPO  FIE->FIE_VALOR  FIE->FIE_SALDO  
// FIE da PA que foi escolhida para compensação
// CZY->CZY_CONTRA  CZY->CZY_NUMED  CZY->CZY_VALOR lAutomato aRetAuto  nvalcomp  nValor nValTot   VALOR     nTotalCmp
//  -->  aTitulos  'nVlrMov := aTitulos[nTit,20] (L1211) - P20/P22 = valor compensar'  --> no entanto aqui não sei qual titulo marcou (manual)
// SC7->C7_NUM  SC7->C7_CONTRA                      nTotalCmp
// SF1->F1_SERIE    SF1->F1_DOC   SD1->D1_PEDIDO   SD1->D1_ITEMPC

// Localizar os FIE's do Pedido e ve quanto de cada um está marcado para usar
// Na Array aTitulos[x][20] e aTitulos[x][22] substituir pelo valor do FIE_SALDO
// Não é o FINA340 que manipula os Saldos do FIE
