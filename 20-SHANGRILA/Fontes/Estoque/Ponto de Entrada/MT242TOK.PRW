#Include "Totvs.ch"

User Function MT242TOK

Local _lRet := .T.
Local _x := 0                       
If (DEMIS260 > Ddatabase)
   MSGBOX("A Data de Emissao esta Maior que a Data do Sistema Verifique !!!!!"+chr(13)+;
          " Este Documento nao Sera Incluido ", "Atencao Data Errada","STOP")
   _lRet := .F.
Endif
For _x := 1 to Len(aCols)
    If Substr(cProduto,1,1) == "Z" .and. Substr(GdFieldGet("D3_COD",_x),1,1) != "Z"
        Alert("Nao pode ser desmontado um produto Z para gerar um produto Não Z")
        Return .F.
    ElseIf Substr(cProduto,1,1) != "Z" .and. Substr(GdFieldGet("D3_COD",_x),1,1) == "Z"
        Alert("Nao pode ser desmontado um produto Não Z para gerar um produto Z")
        Return .F.
    EndIf
Next

Return(_lRet)
