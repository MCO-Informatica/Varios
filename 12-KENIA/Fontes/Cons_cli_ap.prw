#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function Cons_cli()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

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
���Funcao	 � CONS_CLI � Autor � Luciano Lorenzetti	� Data � 24/07/00 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Esta rotina tem como objetivo substrituir o opcao padrao do���
��� 		 � sistema (FINC010), apenas acrescentando o botao de OBS.	  ���
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

cCADASTRO := "Posicao de Clientes."
aRotina   := {{ "Pesquisar"    ,"AxPesqui"                 , 0, 1},;
			  { "Visualizar"   ,"AxVisual"                 , 0, 2},;
			  { "Consultar"    ,"FC010CON"                 , 0, 2},;
			  { "Impressao"    ,"FC010IMP"                 , 0, 2},;
              { "Observa��es"  ,'ExecBlock("OBS_CLI",.T.) ', 0, 1},;
              { "Serasa"       ,'ExecBlock("SERASA",.T.) ' , 0, 1},;
			  { "Parametros"   ,'Pergunte("FIC010",.T.)'   , 0, 1}}

MBrowse( 9,1,30,90,"SA1")

// Devolve ambiente
dbSelectArea(_cAlias)
dbSetOrder(_nOrdem)
dbGoto(_nRecno)

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> __Return(.t.)
Return(.t.)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

