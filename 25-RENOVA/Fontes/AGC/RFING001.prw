#INCLUDE 'TOTVS.CH'
#Include "rwmake.ch"
#Include 'FWMVCDef.ch'

/*==========================================================
= Gatilho para o campo E2_TIPO 
= Utilizado somente na rotina de Liquidação - FINA565
= Autor: Luiz M Suguiura
*///========================================================
user function RFING001(cCampo)

Local cProces0 := ProcName(0)   
Local cProces1 := ProcName(1) 
Local cProces2 := ProcName(2) 
Local cRotina := Alltrim(FunName())
Local cRet     := ""
Local nInd     := 0
Local nPosPref := aScan(aHeader,{|x| AllTrim(x[2])=="E2_PREFIXO"})        // Posicao do Prefixo no Acols
Local nPosTipo := aScan(aHeader,{|x| AllTrim(x[2])=="E2_TIPO"})           // Posicao do Tipo no Acols
Local nPosBco  := aScan(aHeader,{|x| AllTrim(x[2])=="E2_BCOCHQ"})         // Posicao do Bco Cheque no Acols
Local nPosAge  := aScan(aHeader,{|x| AllTrim(x[2])=="E2_AGECHQ"})         // Posicao da Agencia Cheque no Acols
Local nPosCta  := aScan(aHeader,{|x| AllTrim(x[2])=="E2_CTACHQ"})         // Posicao da Conta do Cheque no Acols
Local nPosNum  := aScan(aHeader,{|x| AllTrim(x[2])=="E2_NUM"})            // Posicao do Num Cheque/Título no Acols
Local nPosXCla := aScan(aHeader,{|x| AllTrim(x[2])=="E2_XCLASS"})         // Posicao da Classe Título no Acols
Local nPosXRJ  := aScan(aHeader,{|x| AllTrim(x[2])=="E2_XRJ"})            // Posicao da Flag de RJ no Acols
Local nPosVenc := aScan(aHeader,{|x| AllTrim(x[2])=="E2_VENCTO"})         // Posicao do Vencimento Real no Acols
Local nPosVRea := aScan(aHeader,{|x| AllTrim(x[2])=="E2_VENCREA"})        // Posicao do Vencimento Real no Acols

Local nDias2Parc := 30        // QUANTIDADE DE DIAS A SOMAR NA SEGUNDA PARCELA
                              // ATENÇÃO QUE ESTÁ CHUMBADO A PARTIR DA SEGUNDA PARCELA A MESMA SOMA
                              // PRECISA CONFIRMAR COM O FINANCEIRO SE HÁ REGRA PARA AUTOMATIZAR

Local nPosCpo := 0  

Default cCampo := ""

//Local nPosCpo := aScan(aHeader,{|x| AllTrim(x[2])==cCampo})           // Posicao do Campo no Acols

if !cCampo $ "E2_PREFIXO/E2_TIPO/E2_BCOCHQ/E2_AGECHQ/E2_CTACHQ/E2_NUM/E2_XCLASS/E2_XRJ"
   Alert("Atenção: Chamada inválida do gatilho - Avisar TI")
endif

if cRotina <> "FINA565"
//   Alert("Não é Liquidação")
   Return(&cRet)
Endif

nLen    := Len(aCols)

cRet := "M->"+cCampo

do Case
   Case cCampo = "E2_PREFIXO"
      // Preencher os campos Banco, Agencia, Conta e Número 
      M->E2_NUM := cLiquid+"000"
      for nInd := 1 to nLen
         aCols[nInd][nPosPref]:= M->E2_PREFIXO 
         aCols[nInd][nPosBco] := "999"
         aCols[nInd][nPosAge] := "99999"
         aCols[nInd][nPosCta] := "9999999999"
         M->E2_NUM := Soma1(M->E2_NUM)
         aCols[nInd][nPosNum] := M->E2_NUM
         aCols[nInd][nPosXCla]:= cTpClasse
         if Empty(Alltrim(cTpClasse))
            aCols[nInd][nPosXRJ]:= "N"
         else
            aCols[nInd][nPosXRJ]:= "S"
         endif
         if nInd = 1
            Acols[nInd][nPosVRea]:= Acols[nInd][nPosVenc]
         else
            Acols[nInd][nPosVRea]:= Acols[nInd][nPosVenc] + nDias2Parc
         endif
      next
   Case cCampo = "E2_XCLASS"
      for nInd := 1 to nLen
          aCols[nInd][nPosXCla] := M->E2_XCLASS
      next 
   Case cCampo = "E2_XRJ"
      for nInd := 1 to nLen
          aCols[nInd][nPosXRJ] := M->E2_XRJ
      next 
   Otherwise
      Alert("Campo "+cCampo+" não previsto")
EndCase

//Alert("RFING001")

Return(&cRet)



// Para uso no debug
// ==== === == =====
// aCols  aHeader  
// cCondicao
// cNatureza
// E2_PREFIXO     m->E2_TIPO      E2_PARCELA     E2_NUM   M->E2_XCLASS  n cLiquid ccondicao cnatureza
// Campos do ACOLS
// E2_PREFIXO E2_TIPO E2_BCOCHQ E2_AGECHQ E2_CTACHQ E2_NUM E2_VENCTO E2_VALCRUZ E2_ACRESC E2_DECRESC E2_XCLASS E2_XRJ
