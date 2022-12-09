// ParamIxb := {cAliasSD1,nX,aChave} parametros enviado no ponto de entrada

Static __aDINFOri := Nil
Static __nDINfOri := Nil

User Function MT119FLT()
   __aDINFOri := {}
   __nDINfOri := 0
Return Nil

User Function M119ACOL()
   Local nD1DI      := aScan(aHeader, {| aColunas | aColunas[2] == "D1_DI     "})
   Local nD1ADIC    := aScan(aHeader, {| aColunas | aColunas[2] == "D1_ADIC   "})
   Local nD1DIIT    := aScan(aHeader, {| aColunas | aColunas[2] == "D1_DIIT   "})
   Local nD1XFABRIC := aScan(aHeader, {| aColunas | aColunas[2] == "D1_XFABRIC"})
   Local nD1XDIAD   := aScan(aHeader, {| aColunas | aColunas[2] == "D1_XDIAD  "})
   
   aCols[ParamIxb[2], nD1DI     ] := (ParamIxb[1])->D1_DI
   aCols[ParamIxb[2], nD1ADIC   ] := (ParamIxb[1])->D1_ADIC
   aCols[ParamIxb[2], nD1DIIT   ] := (ParamIxb[1])->D1_DIIT
   aCols[ParamIxb[2], nD1XFABRIC] := (ParamIxb[1])->D1_XFABRIC
   aCols[ParamIxb[2], nD1XDIAD  ] := (ParamIxb[1])->D1_XDIAD
   
   If aScan(__aDINFOri, {| aVet | aVet[1] == (ParamIxb[1])->D1_DOC .And. aVet[2] == (ParamIxb[1])->D1_SERIE}) == 0
                                
      aAdd(__aDINFOri, {(ParamIxb[1])->D1_DOC, (ParamIxb[1])->D1_SERIE})
   
   EndIf
    
Return(Nil)

//aCpoEsp
//
User Function GQREENTR()
   Local nRecSF1    := SF1->(RecNo())
   Local cF1XNDI    := SF1->F1_XNDI
   Local cF1XDTDI   := SF1->F1_XDTDI
   Local cF1XLOCDES := SF1->F1_XLOCDES
   Local cF1XUFDES  := SF1->F1_XUFDES
   Local cF1XDTDES  := SF1->F1_XDTDES
   Local cF1XCODEXP := SF1->F1_XCODEXP

   If Inclui .And. __aDINFOri != Nil .AND. Len(__aDINFOri) != 0
      
      __nDINFOri++
      
      DbSelectArea("SF1")
      DbSetOrder(1)
      DbSeek(xFilial("SF1") + __aDINFOri[__nDINFOri][1] + __aDINFOri[__nDINFOri][2])
                          
      cF1XNDI    := SF1->F1_XNDI
      cF1XDTDI   := SF1->F1_XDTDI
      cF1XLOCDES := SF1->F1_XLOCDES
      cF1XUFDES  := SF1->F1_XUFDES
      cF1XDTDES  := SF1->F1_XDTDES
      cF1XCODEXP := SF1->F1_XCODEXP
      
      DbGoTo(nRecSF1)
   
      RecLock("SF1")
        SF1->F1_XNDI    := cF1XNDI
        SF1->F1_XDTDI   := cF1XDTDI
        SF1->F1_XLOCDES := cF1XLOCDES
        SF1->F1_XUFDES  := cF1XUFDES
        SF1->F1_XDTDES  := cF1XDTDES
        SF1->F1_XCODEXP := cF1XCODEXP
      MsUnLock()  

   EndIf
   
Return(Nil)