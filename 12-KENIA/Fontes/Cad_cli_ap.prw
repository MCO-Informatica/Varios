#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function Cad_cli()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP6 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("_CALIAS,_NORDEM,_NRECNO,CCADASTRO,AROTINA,")

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � CAD_CLI  � Autor � Luciano Lorenzetti    � Data � 29/05/00 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Esta rotina tem como objetivo permitir a manutencao do ar- ���
���          � quivo de CLIENTES                                          ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � RdMake - Especifico da KENIA.                              ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

// Guarda ambiente
_cAlias := ALIAS()
_nOrdem := INDEXORD()
_nRecno := RECNO()

dbSelectArea("SA1")
dbGoTop()

cCADASTRO := "Cadastro de Clientes."
aRotina   := {{ "Pesquisar"    ,"AxPesqui"                  , 0, 1},;
              { "Visualizar"   ,"AxVisual"                  , 0, 2},;
              { "Incluir"      ,"AxInclui"                  , 0, 3},;
              { "Alterar"      ,"AxAltera"                  , 0, 4},;
              { "Excluir"      ,'AxDeleta'                  , 0, 5},;
              { "Observa��es"  ,'ExecBlock("OBS_CLI",.T.) ' , 0, 1},;
              { "Serasa"       ,'ExecBlock("SERASA",.T.) '  , 0, 1}}

MBrowse( 6,1,22,75,"SA1")

// Devolve ambiente
dbSelectArea(_cAlias)
dbSetOrder(_nOrdem)
dbGoto(_nRecno)

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> __Return(.t.)
Return(.t.)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

