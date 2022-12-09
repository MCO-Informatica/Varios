User Function FC021HEAD
  #DEFINE USADO CHR(0)+CHR(0)+CHR(1)
  Local  aRet  := {}
    Aadd( aRet, {"Historico"  ,"Historico", ""                 , 25,0, ".T.", USADO,"C",,"V" } ) //"Valor"
    Aadd( aRet, { "Saldo2"    , "Saldo"   , "@e 999,999,999.99", 15,2, ".T.", USADO,"N",,"V" } ) //"Valor"
Return aRet