#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function Docsx1()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CALIAS,NORD,NREG,_CARQDOC,_LFAZ,_ANOMECPO")
SetPrvt("_ATIPOCPO,_ATAMCPO,_ADECCPO,_AFIELDS,_I,_CARQPRO")
SetPrvt("AROTINA,CCADASTRO,_ACPOS,_CCHAVE,FVAL,")

 /*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ DOCSX1   ³ Autor ³ Adalberto Moreno      ³ Data ³29/06/2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Verifica e cria arquivo com as novas perguntas criadas.    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³ Especifico para Analistas                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
@ 200,1 TO 380,450 DIALOG oProcDoc TITLE OemToAnsi("Documentacao - Perguntas")
@ 02,10 TO 060,220
@ 10,018 Say "Esta rotina gera um arquivo com o nome DOCSX1xx.DBF onde xx e' o numero"
@ 18,018 Say "da empresa, contendo as novas perguntas criadas no sistema Microsiga."
@ 26,018 Say "Este arquivo sera utilizado no arquivo DOCSX1xx.DOC no Word."
@ 34,018 Say ""
@ 42,018 Say "Especifico para a Microsiga Software S/A."
@ 70,150 BMPBUTTON TYPE 01 ACTION tarefa()// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> @ 70,150 BMPBUTTON TYPE 01 ACTION Execute(tarefa)
@ 70,180 BMPBUTTON TYPE 02 ACTION Close(oProcDoc)

Activate Dialog oProcDoc Centered

Return

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function Tarefa
Static Function Tarefa()
Close(oProcDoc)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Grava ambiente atual                                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cAlias  := Alias()
nOrd    := IndexOrd()
nReg    := Recno()
_cArqDoc:= "SIGADOC\DOCSX1"+SM0->M0_CODIGO+".DBF"
_lFaz   := .T.

if file(_cArqDoc)
   if !MsgBox("Arquivo ja existente. Deseja Sobrepor?","Escolha","YESNO")
	   _lFaz := .F.
	endif
endif


If _lFaz
	
   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Cria arquivo Doc                               ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

   dbSelectArea("SX1")
   _aNomeCpo:=array(fCount())
   _aTipoCpo:=array(fCount())
   _aTamCpo :=array(fCount())
   _aDecCpo :=array(fCount())
   Afields(_aNomeCpo,_aTipoCpo,_aTamCpo,_aDecCpo)
   _aFields:={}
   for _i:=1 to len(_aNomeCpo)
       aadd(_aFields,{_aNomeCpo[_i],_aTipoCpo[_i],_aTamCpo[_i],_aDecCpo[_i]})
   next

   dbcreate(_cArqDoc,_aFields)
	
   dbUseArea(.t.,,"SX1.DBF","PRO")
   _cArqPRO := CriaTrab(nil,.f.)

   dbSelectArea("PRO")
   IndRegua("PRO",_cArqPRO,"X1_GRUPO+X1_ORDEM",,,"Criando Indice...") 
   dbGotop()

   dbUseArea(.t.,,_cArqDoc,"DOCSX1")
   Processa( {|| compara() }, "Documentacao - Verifica Perguntas Especificas" )// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==>    Processa( {|| Execute(compara) }, "Documentacao - Verifica Perguntas Especificas" )
   dbSelectArea("DOCSX1")
   dbCloseArea("DOCSX1")
   fErase(_cArqPro+OrdBagExt())

endif

dbUseArea(.t.,,_cArqDoc,"DOCSX1")
dbSelectArea("DOCSX1")
dbGotop()

aRotina := {}
cCadastro:="Documentacao - Perguntas"


_aCpos := {}
aadd(_aCpos,{"Grupo"      ,"X1_GRUPO"})
aadd(_aCpos,{"Ordem"      ,"X1_ORDEM"})
aadd(_aCpos,{"Pergunta"   ,"X1_PERGUNT"})
aadd(_aCpos,{"Variavel"   ,"X1_VARIAVL"})
aadd(_aCpos,{"Tipo"       ,"X1_TIPO"})
aadd(_aCpos,{"Tamanho"    ,"X1_TAMANHO"})
aadd(_aCpos,{"Decimal"    ,"X1_DECIMAL"})
aadd(_aCpos,{"Pre-Selecao","X1_PRESEL"})
aadd(_aCpos,{"GSC"        ,"X1_GSC"})
aadd(_aCpos,{"Validacao"  ,"X1_VALID"})
aadd(_aCpos,{"Variavel 1" ,"X1_VAR01"})
aadd(_aCpos,{"Definicao 1","X1_DEF01"})
aadd(_aCpos,{"Conteudo 1" ,"X1_CNT01"})
aadd(_aCpos,{"Variavel 2" ,"X1_VAR02"})
aadd(_aCpos,{"Definicao 2","X1_DEF02"})
aadd(_aCpos,{"Conteudo 2" ,"X1_CNT02"})
aadd(_aCpos,{"Variavel 3" ,"X1_VAR03"})
aadd(_aCpos,{"Definicao 3","X1_DEF03"})
aadd(_aCpos,{"Conteudo 3" ,"X1_CNT03"})
aadd(_aCpos,{"Variavel 4" ,"X1_VAR04"})
aadd(_aCpos,{"Definicao 4","X1_DEF04"})
aadd(_aCpos,{"Conteudo 4" ,"X1_CNT04"})
aadd(_aCpos,{"Variavel 5" ,"X1_VAR05"})
aadd(_aCpos,{"Definicao 5","X1_DEF05"})
aadd(_aCpos,{"Conteudo 5" ,"X1_CNT05"})
aadd(_aCpos,{"F3"         ,"X1_F3"})

MBrowse(07,00,22,78,"DOCSX1",_aCpos)
dbCloseArea("DOCSX1")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Retorna condicao original.                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea(cAlias)
dbSetOrder(nOrd)
dbGoto(nReg)  
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ COMPARA  ³ Autor ³ Adalberto Moreno      ³ Data ³ 15/04/99 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function Compara
Static Function Compara()

dbSelectArea("SX1")
dbsetorder(1)
dbgotop()
ProcRegua(RecCount())

do while !eof()
   IncProc()
   _cChave := SX1->X1_GRUPO+SX1->X1_ORDEM
   dbSelectArea("PRO")

   If !dbSeek(_cChave)
	
      dbSelectArea("DOCSX1")
      Reclock("DOCSX1",.t.)
      for _i:=1 to fCount()
          dbSelectArea("SX1")
          fVal:=FieldGet(_i)
          dbSelectArea("DOCSX1")
          FieldPut(_i,fVal)
      next
      MsUnlock()

   endif

   dbSelectArea("SX1")
   dbSkip()

enddo

dbSelectArea("PRO")
dbCloseArea("PRO")
					
dbSelectArea("DOCSX1")
DbGoTop()
Return(.t.)

