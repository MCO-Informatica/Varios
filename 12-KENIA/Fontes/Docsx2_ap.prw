#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function Docsx2()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CALIAS,NORD,NREG,_CARQDOC,_LFAZ,_ANOMECPO")
SetPrvt("_ATIPOCPO,_ATAMCPO,_ADECCPO,_AFIELDS,_I,_CARQPRO")
SetPrvt("AROTINA,CCADASTRO,_ACPOS,_CCHAVE,")

 /*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ DOCSX2   ³ Autor ³ Adalberto Moreno      ³ Data ³29/06/2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Verifica e cria arquivo com os novos arquivos criados.     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³ Especifico para Analistas                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
@ 200,1 TO 380,450 DIALOG oProcDoc TITLE OemToAnsi("Documentacao - Arquivos Especificos")
@ 02,10 TO 060,220
@ 10,018 Say "Esta rotina gera um arquivo com o nome DOCSX2xx.DBF onde xx e' o numero"
@ 18,018 Say "da empresa, contendo os novos arquivos criados no sistema Microsiga."
@ 26,018 Say "Este arquivo sera utilizado no arquivo DOCSX2xx.DOC no Word."
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
_cArqDoc:= "SIGADOC\DOCSX2"+SM0->M0_CODIGO+".DBF"
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

   dbSelectArea("SX2")
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
	
   dbUseArea(.t.,,"SX2.DBF","PRO")
   _cArqPRO := CriaTrab(nil,.f.)

   dbSelectArea("PRO")
   IndRegua("PRO",_cArqPRO,"X2_CHAVE",,,"Criando Indice...")
   dbGotop()

   dbUseArea(.t.,,_cArqDoc,"DOCSX2")
   Processa( {|| compara() }, "Verifica Arquivos Especificos" )// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==>    Processa( {|| Execute(compara) }, "Verifica Arquivos Especificos" )
   dbSelectArea("DOCSX2")
   dbCloseArea("DOCSX2")
   fErase(_cArqPro+OrdBagExt())

endif

dbUseArea(.t.,,_cArqDoc,"DOCSX2")
dbSelectArea("DOCSX2")
dbGotop()

aRotina := {}
cCadastro:="Documentacao - Arquivos Especificos"

//aAdd(aRotina,{"Pesquisa","AxPesqui",0,1})
//aAdd(aRotina,{"Visualiza",'Execblock("docsx7b",.f.,.f.)',0,2})
//aadd(aRotina,{"Gera",'Execblock("docsx7a",.f.,.f.)',0,3})
//aAdd(aRotina,{"Imprime",'Execblock("docsx3c",.f.,.f.)',0,4})


_aCpos := {}
aadd(_aCpos,{"Chave"   ,"X2_CHAVE"})
aadd(_aCpos,{"Nome"    ,"X2_NOME"})
aadd(_aCpos,{"Arquivo" ,"X2_ARQUIVO"})
aadd(_aCpos,{"Path"    ,"X2_PATH"})

MBrowse(07,00,22,78,"DOCSX2",_aCpos)
dbCloseArea("DOCSX2")

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

dbSelectArea("SX2")
dbsetorder(1)
dbgotop()
ProcRegua(RecCount())

do while !eof()
   IncProc()
   _cChave := SX2->X2_CHAVE
   dbSelectArea("PRO")

   If dbSeek(_cChave)
      alert("teste")  
      dbSelectArea("DOCSX2")
      Reclock("DOCSX2",.t.)
      DOCSX2->X2_CHAVE  := _cChave
      DOCSX2->X2_PATH   := SX2->X2_PATH
      DOCSX2->X2_ARQUIVO:= SX2->X2_ARQUIVO
      DOCSX2->X2_NOME   := SX2->X2_NOME
      MsUnlock()                         

   endif

   dbSelectArea("SX2")
   dbSkip()

enddo

dbSelectArea("PRO")
dbCloseArea("PRO")
					
dbSelectArea("DOCSX2")
DbGoTop()
Return(.t.)

