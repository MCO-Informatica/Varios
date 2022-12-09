#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function jeremias()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("_AAREA,NPOSCODIGO,NPOSQTDLIB,ACOLS,")


_aArea := GetArea()

DbSelectArea("SB8")
DbSetorder(3)
DbSeek()



// Busca o codigo do produto
nPosCodigo := ASCAN(aHEADER,{|x| Upper(AllTrim(x[2])) == "C6_PRODUTO" })
nPosQtdLib := ASCAN(aHEADER,{|x| Upper(AllTrim(x[2])) == "C6_QTDLIB" })

If Acols[N,nPosCodigo] == SB8->B8_PRODUTO
        MsgAlert()
Else
EndIf

If Acols[N,nPosQtdLib] := SB8->B8_SALDO
   Acols[N,nPosQtdLib] := SaldoSB8()
Else
EndIf

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

