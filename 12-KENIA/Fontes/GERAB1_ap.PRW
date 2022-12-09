#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 16/04/05

User Function GERAB1()        // incluido pelo assistente de conversao do AP6 IDE em 16/04/05

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("_CARQSB1,_ANOMECPO,_ATIPOCPO,_ATAMCPO,_ADECCPO,_AFIELDS")
SetPrvt("_I,FVAL,")

processa({||RunProc()},"Exporta Base de Dados")// Substituido pelo assistente de conversao do AP6 IDE em 16/04/05 ==> processa({||Execute(RunProc)},"Exporta Base de Dados")
return

// Substituido pelo assistente de conversao do AP6 IDE em 16/04/05 ==> function runproc
Static function runproc()

_cArqSB1:= "\\server01\data\data\SB1_XXX.DBF"

dbSelectArea("SB1")
_aNomeCpo:=array(fCount())
_aTipoCpo:=array(fCount())
_aTamCpo :=array(fCount())
_aDecCpo :=array(fCount())
Afields(_aNomeCpo,_aTipoCpo,_aTamCpo,_aDecCpo)
_aFields:={}
for _i:=1 to len(_aNomeCpo)
	aadd(_aFields,{_aNomeCpo[_i],_aTipoCpo[_i],_aTamCpo[_i],_aDecCpo[_i]})
next

//dbcreate(_cArqSB1,_aFields)
dbUseArea(.t.,,_cArqSB1,"B1")

dbSelectArea("SB1")
dbSetOrder(1)
dbGoTop()
ProcRegua(LastRec())
While !Eof()
	IncProc("Processando...")
	
    dbSelectArea("B1")
    RecLock("B1",.t.)
	
	For _i:=1 to fCount()
        dbSelectArea("SB1")
		fVal:=FieldGet(_i)
        dbSelectArea("B1")
		FieldPut(_i,fVal)
	Next _i
	MsUnLock()
	
    dbSelectArea("SB1")
	dbSkip()
	
enddo

dbCloseArea("B1")

Return
