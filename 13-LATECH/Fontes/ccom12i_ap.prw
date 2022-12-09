#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function ccom12i()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP6 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("_ACAMPOS,_AFIELDS,AROTINA,CDELFUNC,CCADASTRO,CMARCA")
SetPrvt("ACAMPOS,_N,_AFIELSX3,_CARQUIVO,_CPOSICAO,LINVERTE")
SetPrvt("_CMARCALL,")

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � CCOM12I  � Autor �Ricardo Correa de Souza� Data �04.08.2000���
�������������������������������������������������������������������������Ĵ��
���Descricao � Geracao de Pedidos de Transferencia para Sao Roque         ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Coel Controles Eletricos Ltda                              ���
�������������������������������������������������������������������������Ĵ��
���            ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL           ���
�������������������������������������������������������������������������Ĵ��
���   Analista   �  Data  �             Motivo da Alteracao               ���
�������������������������������������������������������������������������Ĵ��
���              �        �                                               ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

DbSelectArea("SB1")     //----> Produtos
DbSetOrder(1)           //----> Codigo

DbSelectArea("SC5")     //----> Cabecalho Pedido Venda
DbSetOrder(1)           //----> Numero Pedido

DbSelectArea("SC6")     //----> Itens Pedido Venda
DbSetOrder(1)           //----> Numero Pedido + Item

_aCampos := {}
_aFields := {}

CreateSX3()

aRotina   := { { "Pesquisa"  ,"AxPesqui" ,0,1},;
               { "Gera Pedidos",'Execblock("GERAPED")',0,4}  }           

cDelFunc  := ".T."

cCadastro := "Geracao de Pedidos de Transferencia"

cmarca    := getmark()

//���������������������������������������������������������������������������Ŀ
//� Executa a funcao MARKBROW. Sintaxe:                                       �
//�                                                                           �
//�MarkBrow(<Alias,campo1,campo2,aCampos,linverte,cmarca,,,,,{nLin1,..nCol2}) �
//�Onde:                                                        �
//�Alias         - Alias do arquivo a ser "Browseado".          �
//�campo1        - Campo a ser preenchido no caso de marcado    �
//�campo2        - Se este campo estiver preenchido o registro  �
//�                aparece  desabilitado                        �
//�aCampos       - Array multidimensional com os campos a serem �
//�                exibidos no browse. Se nao informado, os cam-�
//�                pos serao obtidos do dicionario de dados.    �
//�                E util para o uso com arquivos de trabalho.  �
//�                Segue o padrao:                              �
//�                aCampos := { {<CAMPO>,<FUNCAO>,<DESCRICAO>}; �
//�                             {<CAMPO>,<FUNCAO>,<DESCRICAO>}; �
//�                             . . .                           �
//�                             {<CAMPO>,<FUNCAO>,<DESCRICAO>}} �
//�                Como por exemplo:                            �
//�                aCampos := { {"TRB_DATA","AXPESQUI"Data"},;  �
//�                  {"TRB_COD","EXECBLOCK{'TESTE'),"Codigo"}}  �
//�               Caso seja definido, os parametros campo1 nao  �
//�                tera finalidade.                             �
//� cCampo       - Nome de um campo (entre aspas) que sera usado�
//�                como "flag". Se o campo estiver vazio, o re- �
//�                gistro ficara de uma cor no browse, senao fi-�
//�                cara de outra cor.                           �
//� nLin1,..2 - Coordenadas dos cantos aonde o browse sera      �
//�                exibido. Para seguir o padrao da AXCADASTRO  �
//�                use sempre 6,1,22,75 (o que nao impede de    �
//�                criar o browse no lugar desejado da tela).   �
//�                Obs.: Na versao Windows, o browse sera exibi-�
//�                do sempre na janela ativa. Caso nenhuma este-�
//�                ja ativa no momento, o browse sera exibido na�
//�                janela do proprio SIGAADV.                   �
//�                                                             �
//���������������������������������������������������������������

AADD(_aCampos,  {"D1_OK"     ,{},"OK"                       })

For _n := 1 to Len(_aFields)
	//+------------------------------------------------------------+
	//� 1-Campo 5-Descricao do Campo 7- Picture do Campo           �
	//+------------------------------------------------------------+
    If _aFields[_n,1] <> 'D1_OK'
        AADD(_aCampos,{_aFields[_n,1],{},_aFields[_n,5],_aFields[_n,7]})
	EndIf
Next

DbSelectArea("SD1")
DbGoTop()

MarkBrow("SD1","D1_OK","",,,cmarca,"OkMark('SD1','D1_OK')")

Return

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �CREATESX3 � Autor �Marllon Figueiredo     � Data � 01/18/00 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Monta array com dados do arquivo SX3.                      ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function CreateSX3
Static Function CreateSX3()
_aFielSX3   := {}

DbSelectArea("SX3")
DbSetOrder(1)
DbGoTop()

If !DbSeek("SD1")
	Help(" ",1,"Aviso",,"Nao encontrei dados no SX3",1,1)
	Return
Endif


While SX3->X3_ARQUIVO == "SD1" .AND. !EOF()
	
	if SX3->X3_CONTEXT == "V"
		DbSkip()
		Loop
	endif
	
	AADD(_aFielSX3,{SX3->X3_CAMPO,SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_TITULO,SX3->X3_BROWSE,SX3->X3_PICTURE})
	
	DbSkip()
	
End

_aFields := _aFielSX3

Return

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function OkMark
Static Function OkMark()

/*********************************************************************************************
* ATENCAO SR. PROGRAMADOR !!!
*
* Para o funcionamento desta rotina, deve-se atentar para as seguintes
* definicoes :
*
* -> O Nome do Alias do arquivo a ser marcado/desmarcado devera vir no
* -> parametro na chamada desta funcao juntamento com o nome do campo ??_OK do arquivo
*   Exemplo:   OkMark( 'SC5', 'C5_OK' )
*
*
* -> O Campo referente a marcacao do marKbrowse com tamanho de 2 caracteres
*    devera estar na primeira posicao do array acampos
*
*    Ex: Campo C5_OK do SC5
*
* -> Devera ser inicializada antes da chamada a MarkBrowse a variavel _cMarcAll
*    como sendo falsa ou verdadeira para que o browse seja inicializado com marca ou sem
****************************************************************************************/

_cArquivo  :=  "SD1"
_cPosicao  := FieldPos("D1_OK")

DbSelectArea(_cArquivo)
DbGoTop()

While !Eof()
	IF _cMarcAll
		linverte := .T.
		RecLock(_cArquivo,.F.)
		FieldPut(_cPosicao,SPACE(02))
		MsUnLock()
	Else
		linverte := .F.
		RecLock(_cArquivo,.F.)
		FieldPut(_cPosicao,cmarca)
		MsUnLock()
	Endif
	DbSkip()
End

DbGoTop()

_cMarcAll := !_cMarcAll

Return


