#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function Docsix()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP6 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("CALIAS,NORD,NREG,_CARQDOC,_LFAZ,_ANOMECPO")
SetPrvt("_ATIPOCPO,_ATAMCPO,_ADECCPO,_AFIELDS,_I,AROTINA")
SetPrvt("CCADASTRO,_ACPOS,")

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � DOCSX7   � Autor � Adalberto Moreno      � Data �22/06/2000���
�������������������������������������������������������������������������Ĵ��
���Descricao � Verifica gatilhos criados e cria arquivo especifico        ���
�������������������������������������������������������������������������Ĵ��
���          � indicando estas alteracoes. Especifico para Analistas      ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
@ 200,1 TO 380,450 DIALOG oProcDoc TITLE OemToAnsi("Documentacao - Indices")
@ 02,10 TO 060,220

@ 10,018 Say "Esta rotina gera um arquivo com o nome DOCSIX.DBF, contendo os novos "
@ 18,018 Say "indices criados no sistema Microsiga."
@ 26,018 Say "Este arquivo sera utilizado no arquivo DOCSIXxx.DOC no Word."
@ 34,018 Say ""
@ 42,018 Say "Especifico para a Microsiga Software S/A."

@ 70,150 BMPBUTTON TYPE 01 ACTION tarefa()// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> @ 70,150 BMPBUTTON TYPE 01 ACTION Execute(tarefa)
@ 70,180 BMPBUTTON TYPE 02 ACTION Close(oProcDoc)

Activate Dialog oProcDoc Centered

Return


// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function Tarefa
Static Function Tarefa()
//��������������������������������������������������������������������������Ŀ
//�Grava ambiente atual                                                      �
//����������������������������������������������������������������������������
cAlias  := Alias()
nOrd    := IndexOrd()
nReg    := Recno()
_cArqDoc:= "SIGADOC\DOCSIX.DBF"
_lFaz   := .T.

if file(_cArqDoc)
   if !MsgBox("Arquivo ja existente. Deseja Sobrepor?","Escolha","YESNO")
	   _lFaz := .F.
	endif
endif


If _lFaz
	
   //������������������������������������������������Ŀ
   //� Cria arquivo Doc                               �
   //��������������������������������������������������

   dbSelectArea("SIX")
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
   dbUseArea(.t.,,_cArqDoc,"DOCSIX")
   dbSelectArea("DOCSIX")
   Processa( {|| compara() }, "Documentacao - Verifica Indices" )// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==>    Processa( {|| Execute(compara) }, "Documentacao - Verifica Indices" )
   dbSelectArea("DOCSIX")
	dbCloseArea()

endif

dbUseArea(.t.,,_cArqDoc,"DOCSIX")
dbSelectArea("DOCSIX")
dbGotop()


aRotina := {}
cCadastro:="Documentacao - Indices"

//aAdd(aRotina,{"Pesquisa","AxPesqui",0,1})
//aAdd(aRotina,{"Visualiza",'Execblock("docsx7b",.f.,.f.)',0,2})
//aadd(aRotina,{"Gera",'Execblock("docsx7a",.f.,.f.)',0,3})
//aAdd(aRotina,{"Imprime",'Execblock("docsx3c",.f.,.f.)',0,4})


_aCpos := {}
aadd(_aCpos,{"Indice"    ,"INDICE"})
aadd(_aCpos,{"Ordem"     ,"ORDEM"})
aadd(_aCpos,{"Chave"     ,"CHAVE"})
aadd(_aCpos,{"Descricao" ,"DESCRICAO"})

MBrowse(07,00,22,78,"DOCSIX",_aCpos)
dbCloseArea()
//��������������������������������������������������������������������������Ŀ
//�Retorna condicao original.                                                �
//����������������������������������������������������������������������������
dbSelectArea(cAlias)
dbSetOrder(nOrd)
dbGoto(nReg)  
Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � COMPARA  � Autor � Adalberto Moreno      � Data � 15/04/99 ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function Compara
Static Function Compara()

dbSelectArea("SIX")
dbsetorder(1)
dbgotop()
ProcRegua(RecCount())
do while !eof()
   IncProc()

   If SIX->PROPRI<>"S"

      dbSelectArea("DOCSIX")
      Reclock("DOCSIX",.t.)
      DOCSIX->INDICE		:= SIX->INDICE
      DOCSIX->ORDEM		:= SIX->ORDEM
      DOCSIX->CHAVE		:= SIX->CHAVE
      DOCSIX->DESCRICAO	:= SIX->DESCRICAO
      DOCSIX->PROPRI   	:= SIX->PROPRI
      MsUnlock()
   
   endif

   dbSelectArea("SIX")
   dbskip()

enddo

dbSelectArea("DOCSIX")
DbGoTop()
Return(.t.)

