#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function Docsx6()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
//? Declaracao de variaveis utilizadas no programa atraves da funcao    ?
//? SetPrvt, que criara somente as variaveis definidas pelo usuario,    ?
//? identificando as variaveis publicas do sistema utilizadas no codigo ?
//? Incluido pelo assistente de conversao do AP6 IDE                    ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?

SetPrvt("CALIAS,NORD,NREG,_CARQDOC,_LFAZ,_ANOMECPO")
SetPrvt("_ATIPOCPO,_ATAMCPO,_ADECCPO,_AFIELDS,_I,_CARQPRO")
SetPrvt("AROTINA,CCADASTRO,_ACPOS,_CCHAVE,")

/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽?
굇쿑uncao    ? DOCSX6   ? Autor ? Adalberto Moreno      ? Data ?22/06/2000낢?
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙?
굇쿏escricao ? Verifica gatilhos criados e cria arquivo especifico        낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇?          ? indicando estas alteracoes. Especifico para Analistas      낢?
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽?
*/
@ 200,1 TO 380,450 DIALOG oProcDoc TITLE OemToAnsi("Documentacao - Parametros")
@ 02,10 TO 060,220

@ 10,018 Say "Esta rotina gera um arquivo com o nome DOCSX6xx.DBF onde xx e' o numero"
@ 18,018 Say "da empresa, contendo as novos parametros criados no sistema Microsiga."
@ 26,018 Say "Este arquivo sera utilizado no arquivo DOCSX6xx.DOC no Word."
@ 34,018 Say ""
@ 42,018 Say "Especifico para a Microsiga Software S/A."

@ 70,150 BMPBUTTON TYPE 01 ACTION tarefa()// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> @ 70,150 BMPBUTTON TYPE 01 ACTION Execute(tarefa)
@ 70,180 BMPBUTTON TYPE 02 ACTION Close(oProcDoc)


Activate Dialog oProcDoc Centered

Return


// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function Tarefa
Static Function Tarefa()
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//쿒rava ambiente atual                                                      ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
cAlias  := Alias()
nOrd    := IndexOrd()
nReg    := Recno()
_cArqDoc:= "SIGADOC\DOCSX6"+SM0->M0_CODIGO+".DBF"
_lFaz   := .T.

if file(_cArqDoc)
   if !MsgBox("Arquivo ja existente. Deseja Sobrepor?","Escolha","YESNO")
	   _lFaz := .F.
	endif
endif


If _lFaz
	
   //旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
   //? Cria arquivo Doc                               ?
   //읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

   dbSelectArea("SX6")
   _aNomeCpo:=array(fCount())
   _aTipoCpo:=array(fCount())
   _aTamCpo :=array(fCount())
   _aDecCpo :=array(fCount())
   Afields(_aNomeCpo,_aTipoCpo,_aTamCpo,_aDecCpo)
   aadd(_aNomeCpo,"X6_ALTCPO")
   aadd(_aTipoCpo,"C")
   aadd(_aTamCpo,1)
   aadd(_aDecCpo,0)
   _aFields:={}
   for _i:=1 to len(_aNomeCpo)
       aadd(_aFields,{_aNomeCpo[_i],_aTipoCpo[_i],_aTamCpo[_i],_aDecCpo[_i]})
   next
   dbcreate(_cArqDoc,_aFields)
	
   dbUseArea(.t.,,"SX6.DBF","PRO")
   _cArqPRO := CriaTrab(nil,.f.)
   dbSelectArea("PRO")
   IndRegua("PRO",_cArqPRO,"X6_FIL+X6_VAR",,,"Criando Indice...")
   dbGotop()
	
   dbUseArea(.t.,,_cArqDoc,"DOCSX6")
   dbSelectArea("DOCSX6")
   Processa( {|| compara() }, "Documentacao - Verifica Parametros" )// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==>    Processa( {|| Execute(compara) }, "Documentacao - Verifica Parametros" )
   dbSelectArea("DOCSX6")
	dbCloseArea()

endif

dbUseArea(.t.,,_cArqDoc,"DOCSX6")
dbSelectArea("DOCSX6")
dbGotop()


aRotina := {}
cCadastro:="Documentacao - Parametros"

//aAdd(aRotina,{"Pesquisa","AxPesqui",0,1})
//aAdd(aRotina,{"Visualiza",'Execblock("docsx7b",.f.,.f.)',0,2})
//aadd(aRotina,{"Gera",'Execblock("docsx7a",.f.,.f.)',0,3})
//aAdd(aRotina,{"Imprime",'Execblock("docsx3c",.f.,.f.)',0,4})


_aCpos := {}
aadd(_aCpos,{"Filial"         ,"X6_FIL"})
aadd(_aCpos,{"Parametro"      ,"X6_VAR"})
aadd(_aCpos,{"Tipo"           ,"X6_TIPO"})
aadd(_aCpos,{"Descricao..."   ,"X6_DESCRIC"})
aadd(_aCpos,{"...Descricao...","X6_DESC1"})
aadd(_aCpos,{"...Descricao"   ,"X6_DESC2"})
aadd(_aCpos,{"Conteudo"       ,"X6_CONTEUD"})

MBrowse(07,00,22,78,"DOCSX6",_aCpos,"X6_ALTCPO")
dbCloseArea("DOCSX6")

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//쿝etorna condicao original.                                                ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
dbSelectArea(cAlias)
dbSetOrder(nOrd)
dbGoto(nReg)  
Return


/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽?
굇쿑uncao    ? COMPARA  ? Autor ? Adalberto Moreno      ? Data ? 15/04/99 낢?
굇읕컴컴컴컴컨컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽?
*/
// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function Compara
Static Function Compara()

dbSelectArea("SX6")
dbsetorder(1)
dbgotop()
ProcRegua(RecCount())
do while !eof()
	IncProc()
   _cChave := SX6->X6_FIL+X6_VAR
	dbSelectArea("PRO")
   If !dbSeek(_cChave)
	
      dbSelectArea("DOCSX6")
      Reclock("DOCSX6",.t.)
      DOCSX6->X6_FIL    := _cChave
      DOCSX6->X6_VAR    := SX6->X6_VAR
	   DOCSX6->X6_TIPO   := SX6->X6_TIPO
	   DOCSX6->X6_DESCRIC:= SX6->X6_DESCRIC
	   DOCSX6->X6_DESC1  := SX6->X6_DESC1
	   DOCSX6->X6_DESC2  := SX6->X6_DESC2
      MsUnlock()

   endif

   dbSelectArea("SX6")
	dbSkip()

enddo

dbSelectArea("PRO")
dbCloseArea("PRO")

dbSelectArea("DOCSX6")
DbGoTop()
Return(.t.)

