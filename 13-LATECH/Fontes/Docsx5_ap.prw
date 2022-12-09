#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function Docsx5()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP6 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("CALIAS,NORD,NREG,_CARQDOC,_LFAZ,_ANOMECPO")
SetPrvt("_ATIPOCPO,_ATAMCPO,_ADECCPO,_AFIELDS,_I,_CARQPRO")
SetPrvt("AROTINA,CCADASTRO,_ACPOS,_CCHAVE,_NGRAVA,_AX5")

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � DOCSX5   � Autor � Adalberto Moreno      � Data �29/06/2000���
�������������������������������������������������������������������������Ĵ��
���Descricao � Verifica consultas padrao criadas e cria arquivo especifico���
�������������������������������������������������������������������������Ĵ��
���          � Especifico para Analistas                                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
@ 200,1 TO 380,450 DIALOG oProcDoc TITLE OemToAnsi("Documentacao - Tabelas")
@ 02,10 TO 060,220
@ 10,018 Say "Esta rotina gera um arquivo com o nome DOCSX5xx.DBF onde xx e' o numero"
@ 18,018 Say "da empresa, contendo as novas tabelas criadas no sistema Microsiga."
@ 26,018 Say "Este arquivo sera utilizado no arquivo DOCSX5xx.DOC no Word."
@ 34,018 Say ""
@ 42,018 Say "Especifico para a Microsiga Software S/A."

@ 70,150 BMPBUTTON TYPE 01 ACTION tarefa()// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> @ 70,150 BMPBUTTON TYPE 01 ACTION Execute(tarefa)
@ 70,180 BMPBUTTON TYPE 02 ACTION Close(oProcDoc)

Activate Dialog oProcDoc Centered

Return


// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function Tarefa
Static Function Tarefa()
Close(oProcDoc)
//��������������������������������������������������������������������������Ŀ
//�Grava ambiente atual                                                      �
//����������������������������������������������������������������������������
cAlias  := Alias()
nOrd    := IndexOrd()
nReg    := Recno()
_cArqDoc:= "SIGADOC\DOCSX5"+SM0->M0_CODIGO+".DBF"
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

   dbSelectArea("SX5")
   _aNomeCpo:=array(fCount())
   _aTipoCpo:=array(fCount())
   _aTamCpo :=array(fCount())
   _aDecCpo :=array(fCount())
   Afields(_aNomeCpo,_aTipoCpo,_aTamCpo,_aDecCpo)
   aadd(_aNomeCpo,"X5_ALTCPO")
   aadd(_aTipoCpo,"C")
   aadd(_aTamCpo,1)
   aadd(_aDecCpo,0)
   _aFields:={}
   for _i:=1 to len(_aNomeCpo)
       aadd(_aFields,{_aNomeCpo[_i],_aTipoCpo[_i],_aTamCpo[_i],_aDecCpo[_i]})
   next
   dbcreate(_cArqDoc,_aFields)
	
   dbUseArea(.t.,,"SX5.DBF","PRO")
   _cArqPRO := CriaTrab(nil,.f.)
   dbSelectArea("PRO")
   IndRegua("PRO",_cArqPRO,"X5_FILIAL+X5_TABELA+X5_CHAVE",,,"Criando Indice...")
   dbGotop()

   dbUseArea(.t.,,_cArqDoc,"DOCSX5")
   Processa( {|| compara() }, "Documentacao - Verifica Tabelas" )// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==>    Processa( {|| Execute(compara) }, "Documentacao - Verifica Tabelas" )
   dbSelectArea("DOCSX5")
	dbCloseArea()
	fErase(_cArqPro+OrdBagExt())

endif

dbUseArea(.t.,,_cArqDoc,"DOCSX5")
dbSelectArea("DOCSX5")
dbGotop()


aRotina := {}
cCadastro:="Documentacao - Tabelas"

//aAdd(aRotina,{"Pesquisa","AxPesqui",0,1})
//aAdd(aRotina,{"Visualiza",'Execblock("docsx7b",.f.,.f.)',0,2})
//aadd(aRotina,{"Gera",'Execblock("docsx7a",.f.,.f.)',0,3})
//aAdd(aRotina,{"Imprime",'Execblock("docsx3c",.f.,.f.)',0,4})


_aCpos := {}
aadd(_aCpos,{"Filial"    ,"X5_FILIAL"})
aadd(_aCpos,{"Tabela"    ,"X5_TABELA"})
aadd(_aCpos,{"Chave"     ,"X5_CHAVE"})
aadd(_aCpos,{"Descricao" ,"X5_DESCRI"})

MBrowse(07,00,22,78,"DOCSX5",_aCpos,"X5_ALTCPO")
dbCloseArea("DOCSX5")

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

dbSelectArea("SX5")
dbsetorder(1)
dbgotop()
ProcRegua(RecCount())

do while !eof()

   _cChave   := SX5->(X5_FILIAL+X5_TABELA)
   _nGrava   := 0  //0-nao alterado, 1-alterado, 2-novo
	_aX5      := {}
   Do while !eof() .and. SX5->(X5_FILIAL+X5_TABELA)==_cChave
      IncProc()
      aAdd(_aX5,{X5_FILIAL,X5_TABELA,X5_CHAVE,X5_DESCRI})
      dbSkip()
   Enddo
	
	dbSelectArea("PRO")
   If !dbSeek(_cChave)
	   _nGrava := 2
   else
      For _i:=1 To Len(_aX5)
          dbSeek(_cChave+_aX5[_i,3])
			 If PRO->X5_DESCRI<>_aX5[_i,4]
			    _nGrava := 1
          EndIf
      Next
   endif
	

   If _nGrava > 0

      dbSelectArea("DOCSX5")
		For _i := 1 To Len(_aX5)
          Reclock("DOCSX5",.t.)
          DOCSX5->X5_FILIAL := _aX5[_i,1]
		    DOCSX5->X5_TABELA := _aX5[_i,2]
		    DOCSX5->X5_CHAVE  := _aX5[_i,3]
		    DOCSX5->X5_DESCRI := _aX5[_i,4]
          DOCSX5->X5_ALTCPO := iif(_nGrava==1,"X","")
          MsUnlock()			 
      next

   endif

   dbSelectArea("SX5")

enddo

dbSelectArea("PRO")
dbCloseArea("PRO")

dbSelectArea("DOCSX5")
DbGoTop()
Return(.t.)

