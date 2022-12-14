#Include 'Protheus.ch'

/*/{Protheus.doc} 
Ponto de Entrada usado para gravar campos adcionais na Tabela SE2
no processo de liquidacao recebe campos do PE F565SE2
Para os novos titulos gerados.
@author Alcouto
@since 15-01-2021 

Obs: Utilizado diretamente os campos da aCols dos t?tulos gerado pois se utilizar o PE F565SE conforme
     documenta??o n?o ir? servir - PE F565SE n?o utilizado
     Esse PE ? executado ap?s a grava??o padr?o do t?tulo destino e est? posicionado nele
     Executa uma vez para cada t?tulo destino gravado
/*/

// Para a excu??o autom?tica necessita utilizar a array enviada pelo execauto()

User Function F565VAL()  

Local nPosXCla := aScan(aHeader,{|x| AllTrim(x[2])=="E2_XCLASS"})         // Posicao da Classe T?tulo no Acols
Local nPosXRJ  := aScan(aHeader,{|x| AllTrim(x[2])=="E2_XRJ"})            // Posicao da Flag de RJ no Acols
Local nPosVRea := aScan(aHeader,{|x| AllTrim(x[2])=="E2_VENCREA"})        // Posicao do Vencimento Real no Acols
Local nPosEsse := aScan(aHeader,{|x| AllTrim(x[2])=="E2_XESSENC"})        // Posicao do Vencimento Real no Acols

Local cAliasTRB:=""

Local lAutoExec := Type("cNatAuto") = "C"

if Type("nI565COL") <> "N"
     Alert("Aten??o: Avisar Ti. Erro na vari?vel 'nI565COL'")             // Precisa ter sido inicializao pelo PE A565COL
     Return                                                               
endif

nI565COL := nI565COL + 1

Reclock("SE2",.F.) 
if !lAutoExec
   SE2->E2_XCLASS := aCols[nI565COL][nPosXCla]
   SE2->E2_XRJ    := aCols[nI565COL][nPosXRJ]
   SE2->E2_VENCREA:= Acols[nI565COL][nPosVRea]
   SE2->E2_XESSENC:= Acols[nI565COL][nPosEsse]
else
   SE2->E2_XCLASS := aColItens[nI565COL][11][2]
   SE2->E2_XRJ    := aColItens[nI565COL][12][2]
   SE2->E2_VENCREA:= aColItens[nI565COL][13][2]
   SE2->E2_XUSER  := "AUTO "+substr(cUserName,1,20)
   if cOpc = "E" .or. (cOpc="A" .and. lEssenc)
      SE2->E2_XESSENC := "S"   // Credor Essencial  lEssenc
   else
      SE2->E2_XESSENC := "N"   // Credor N?o Essencial
   endif
   if cRotFina >= "003"
      cCampoFor := "TRB"+cRotFina+"->E2_XFORREP"
      cCampoLoj := "TRB"+cRotFina+"->E2_XFORREP"
      SE2->E2_XFORREP := &("TRB"+cRotFina+"->E2_XFORREP")
      SE2->E2_XLOJREP := &("TRB"+cRotFina+"->E2_XLOJREP")
   endif
endif

MSUnlock()

Return
