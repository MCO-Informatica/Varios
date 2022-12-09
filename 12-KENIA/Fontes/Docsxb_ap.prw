#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function Docsxb()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CALIAS,NORD,NREG,_CARQDOC,_LFAZ,_ANOMECPO")
SetPrvt("_ATIPOCPO,_ATAMCPO,_ADECCPO,_AFIELDS,_I,_CARQPRO")
SetPrvt("AROTINA,CCADASTRO,_ACPOS,_CXBALIAS,_AXB,_NGRAVA")

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ DOCSXB   ³ Autor ³ Adalberto Moreno      ³ Data ³29/06/2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Verifica consultas padrao criadas e cria arquivo especifico³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³ Especifico para Analistas                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
@ 200,1 TO 380,450 DIALOG oProcDoc TITLE OemToAnsi("Documentacao - Consultas Padroes")
@ 02,10 TO 060,220

@ 10,018 Say "Esta rotina gera um arquivo com o nome DOCSXBxx.DBF onde xx e'o numero"
@ 18,018 Say "da empresa, contendo consultas criadas no sistema Microsiga."
@ 26,018 Say "Este arquivo sera utilizado no arquivo DOCSXBxx.DOC no Word."
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
_cArqDoc:= "SIGADOC\DOCSXB"+SM0->M0_CODIGO+".DBF"
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

   dbSelectArea("SXB")
   _aNomeCpo:=array(fCount())
   _aTipoCpo:=array(fCount())
   _aTamCpo :=array(fCount())
   _aDecCpo :=array(fCount())
   Afields(_aNomeCpo,_aTipoCpo,_aTamCpo,_aDecCpo)
   aadd(_aNomeCpo,"XB_ALTCPO")
   aadd(_aTipoCpo,"C")
   aadd(_aTamCpo,1)
   aadd(_aDecCpo,0)
   _aFields:={}
   for _i:=1 to len(_aNomeCpo)
       aadd(_aFields,{_aNomeCpo[_i],_aTipoCpo[_i],_aTamCpo[_i],_aDecCpo[_i]})
   next
   dbcreate(_cArqDoc,_aFields)
	
   dbUseArea(.t.,,"SXB.DBF","PRO")
   _cArqPRO := CriaTrab(nil,.f.)
   dbSelectArea("PRO")
   IndRegua("PRO",_cArqPRO,"XB_ALIAS+XB_TIPO+XB_SEQ+XB_COLUNA",,,"Criando Indice...")
   dbGotop()

   dbUseArea(.t.,,_cArqDoc,"DOCSXB")
   Processa( {|| compara() }, "Documentacao - Verifica Consultas Padroes" )// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==>    Processa( {|| Execute(compara) }, "Documentacao - Verifica Consultas Padroes" )
   dbSelectArea("DOCSXB")
	dbCloseArea()
	fErase(_cArqPro+OrdBagExt())

endif

dbUseArea(.t.,,_cArqDoc,"DOCSXB")
dbSelectArea("DOCSXB")
dbGotop()


aRotina := {}
cCadastro:="Documentacao - Consultas Padroes"

//aAdd(aRotina,{"Pesquisa","AxPesqui",0,1})
//aAdd(aRotina,{"Visualiza",'Execblock("docsx7b",.f.,.f.)',0,2})
//aadd(aRotina,{"Gera",'Execblock("docsx7a",.f.,.f.)',0,3})
//aAdd(aRotina,{"Imprime",'Execblock("docsx3c",.f.,.f.)',0,4})


_aCpos := {}
aadd(_aCpos,{"Alias"     ,"XB_ALIAS"})
aadd(_aCpos,{"Tipo"      ,"XB_TIPO"})
aadd(_aCpos,{"Sequencia" ,"XB_SEQ"})
aadd(_aCpos,{"Coluna"    ,"XB_COLUNA"})
aadd(_aCpos,{"Descricao" ,"XB_DESCRI"})
aadd(_aCpos,{"Conteudo"  ,"XB_CONTEM"})

MBrowse(07,00,22,78,"DOCSXB",_aCpos,"XB_ALTCPO")
dbCloseArea("DOCSXB")
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

dbSelectArea("SXB")
dbsetorder(1)
dbgotop()
ProcRegua(RecCount())

do while !eof()

   _cxbAlias := SXB->XB_ALIAS
   _aXB      := {}
   _nGrava   := 0  //0-nao alterado, 1-alterado, 2-novo
   Do while !eof() .and. SXB->XB_ALIAS==_cxbAlias
      IncProc()
      aAdd(_aXB,{XB_TIPO,XB_SEQ,XB_COLUNA,XB_DESCRI,XB_CONTEM})
      dbSkip()
   Enddo
	
	dbSelectArea("PRO")
   If !dbSeek(_cxbAlias)
	   _nGrava := 2
   else
      For _i:=1 To Len(_aXB)
          dbSeek(_cxbAlias+_aXB[_i,1]+_aXB[_i,2]+_aXB[_i,3])
			 If PRO->XB_DESCRI<>_aXB[_i,4] .or. PRO->XB_CONTEM<>_aXB[_i,5]
			    _nGrava := 1
          EndIf
      Next
   endif
	

   If _nGrava > 0

      dbSelectArea("DOCSXB")
		For _i := 1 To Len(_aXB)
          Reclock("DOCSXB",.t.)
          DOCSXB->XB_ALIAS  := _cxbAlias
		    DOCSXB->XB_TIPO   := _aXB[_i,1]
		    DOCSXB->XB_SEQ    := _aXB[_i,2]
		    DOCSXB->XB_COLUNA := _aXB[_i,3]
		    DOCSXB->XB_DESCRI := _aXB[_i,4]
		    DOCSXB->XB_CONTEM := _aXB[_i,5]
		    DOCSXB->XB_ALTCPO := iif(_nGrava==1,"X","")
          MsUnlock()			 
      next

   endif

   dbSelectArea("SXB")

enddo

dbSelectArea("PRO")
dbCloseArea("PRO")
					
dbSelectArea("DOCSXB")
DbGoTop()
Return(.t.)

