User Function A140IGRV()
cDoc   := ParamIxb[1] 
cSerie := ParamIxb[2] // S�rie da NotaLocal 
cCod   := ParamIxb[3] // C�digo do FornecedorLocal cLoja   := ParamIxb[4]Return

If !Empty(cSerie) .AND. VAL(cSerie) >= 0 .AND. VAL(cSerie) <= 9
 
cSerie := StrZero(VAL(cSerie),3)
cSerie := StrZero(VAL(cSerie),3)
Endif  

Return(.T.)
