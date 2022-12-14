#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function Docsm0()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
//? Declaracao de variaveis utilizadas no programa atraves da funcao    ?
//? SetPrvt, que criara somente as variaveis definidas pelo usuario,    ?
//? identificando as variaveis publicas do sistema utilizadas no codigo ?
//? Incluido pelo assistente de conversao do AP6 IDE                    ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?

SetPrvt("CALIAS,NORD,NREG,_CARQDOC,_LFAZ,_ANOMECPO")
SetPrvt("_ATIPOCPO,_ATAMCPO,_ADECCPO,_AFIELDS,_I,AROTINA")
SetPrvt("CCADASTRO,_ACPOS,_NREGSM0,FVAL,")

 /*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽?
굇쿑uncao    ? DOCSM0   ? Autor ? Adalberto Moreno      ? Data ?29/06/2000낢?
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙?
굇쿏escricao ? Verifica e cria arquivo com as novas perguntas criadas.    낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇?          ? Especifico para Analistas                                  낢?
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽?
*/
@ 200,1 TO 380,450 DIALOG oProcDoc TITLE OemToAnsi("Documentacao - Empresas")
@ 02,10 TO 060,220
@ 10,018 Say "Esta rotina gera um arquivo com o nome DOCSM0.DBF, contendo as"
@ 18,018 Say "empresas criadas no sistema Microsiga."
@ 26,018 Say "Este arquivo sera utilizado no arquivo DOCSM0.DOC no Word."
@ 34,018 Say ""
@ 42,018 Say "Especifico para a Microsiga Software S/A."
@ 70,150 BMPBUTTON TYPE 01 ACTION tarefa()// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> @ 70,150 BMPBUTTON TYPE 01 ACTION Execute(tarefa)
@ 70,180 BMPBUTTON TYPE 02 ACTION Close(oProcDoc)

Activate Dialog oProcDoc Centered

Return

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function Tarefa
Static Function Tarefa()
Close(oProcDoc)
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//쿒rava ambiente atual                                                      ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
cAlias  := Alias()
nOrd    := IndexOrd()
nReg    := Recno()
_cArqDoc:= "SIGADOC\DOCSM0.DBF"
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

   dbSelectArea("SM0")
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
   dbUseArea(.t.,,_cArqDoc,"DOCSM0")
   Processa( {|| compara() }, "Documentacao - Verifica Empresas Cadastradas" )// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==>    Processa( {|| Execute(compara) }, "Documentacao - Verifica Empresas Cadastradas" )
   dbSelectArea("DOCSM0")
   dbCloseArea("DOCSM0")

endif

dbUseArea(.t.,,_cArqDoc,"DOCSM0")
dbSelectArea("DOCSM0")
dbGotop()

aRotina := {}
cCadastro:="Documentacao - Empresas"

_aCpos := {}
aadd(_aCpos,{"Codigo"     ,"M0_CODIGO"})
aadd(_aCpos,{"Cod. Filial","M0_CODFIL"})
aadd(_aCpos,{"Nome Filial","M0_FILIAL"})
aadd(_aCpos,{"Empresa"    ,"M0_NOME"})
aadd(_aCpos,{"Empr.-Compl","M0_NOMECOM"})
aadd(_aCpos,{"End.Cobr."  ,"M0_ENDCOB"})
aadd(_aCpos,{"Cid.Cobr."  ,"M0_CIDCOB"})
aadd(_aCpos,{"Est.Cobr."  ,"M0_ESTCOB"})
aadd(_aCpos,{"CEP Cobr."  ,"M0_CEPCOB"})
aadd(_aCpos,{"End.Entr."  ,"M0_ENDENT"})
aadd(_aCpos,{"Cid.Entr."  ,"M0_CIDENT"})
aadd(_aCpos,{"Est.Entr."  ,"M0_ESTENT"})
aadd(_aCpos,{"CEP Entr."  ,"M0_CEPENT"})
aadd(_aCpos,{"CGC"        ,"M0_CGC"})
aadd(_aCpos,{"Inscricao"  ,"M0_INSC"})
aadd(_aCpos,{"Telefone"   ,"M0_TEL"})
aadd(_aCpos,{"Equiparado" ,"M0_EQUIP"})
aadd(_aCpos,{"Sequencia"  ,"M0_SEQUENC"})
aadd(_aCpos,{"Doc.Seq."   ,"M0_DOCSEQ"})
aadd(_aCpos,{"FAX"        ,"M0_FAX"})
aadd(_aCpos,{"Bai.Entr."  ,"M0_BAIRENT"})
aadd(_aCpos,{"Com.Cobr."  ,"M0_COMPCOB"})
aadd(_aCpos,{"Com.Entr."  ,"M0_COMPENT"})

MBrowse(07,00,22,78,"DOCSM0",_aCpos)
dbCloseArea("DOCSM0")

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

dbSelectArea("SM0")
_nRegSM0:= Recno()
dbGoTop()
ProcRegua(RecCount())

do while !eof()

   IncProc()

   dbSelectArea("DOCSM0")
   Reclock("DOCSM0",.t.)

   For _i:=1 to fCount()
       dbSelectArea("SM0")
       fVal:=FieldGet(_i)
       dbSelectArea("DOCSM0")
       FieldPut(_i,fVal)
   Next _i

   MsUnlock()

   dbSelectArea("SM0")
   dbSkip()

enddo

dbSelectArea("SM0")
dbGoTo(_nRegSM0)
					
dbSelectArea("DOCSM0")
DbGoTop()
Return(.t.)

