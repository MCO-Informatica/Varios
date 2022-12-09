#include "rwmake.ch"        

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

User Function ULTPRCPG()       

SetPrvt("NPOS,CPROD,CCOND,")

nPos    := Ascan(aHEADER,{|x|Upper(Alltrim(x[2]))=="C7_PRODUTO"})
cProd   := aCols[n,nPos]

cCond   := Space(15)

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Processamento                                                             *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

DbSelectArea("SC7")
DbSetOrder(7)
DbSeek(xFilial("SC7")+cProd)

While SC7->C7_PRODUTO == cProd
    
    If dDataBase < SC7->C7_DATPRF
	    DbSelectArea("SC7")
    	DbSkip()
	EndIf    	
    
    DbSelectArea("SE4")
    DbSetOrder(1)
    DbSeek(xFilial("SE4")+SC7->C7_COND)

    cCond := SC7->C7_COND+" - "+SE4->E4_DESCRI

    DbSelectArea("SC7")
    DbSkip()
EndDo

Return(cCond)


Return(nil)

