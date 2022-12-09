#INCLUDE "Protheus.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  PFISA001    � Autor � Deosdete P. Silva  � Data �  23/05/18   ���
�������������������������������������������������������������������������͹��
���Descricao � Rotina para manutenir FCI                                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function PFISA001()
Local cAlias := "CFD"

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Private cCadastro := "Manuten��o FCI"
//���������������������������������������������������������������������Ŀ
//� Array (tambem deve ser aRotina sempre) com as definicoes das opcoes �
//� que apareceram disponiveis para o usuario. Segue o padrao:          �
//� aRotina := { {<DESCRICAO>,<ROTINA>,0,<TIPO>},;                      �
//�              {<DESCRICAO>,<ROTINA>,0,<TIPO>},;                      �
//�              . . .                                                  �
//�              {<DESCRICAO>,<ROTINA>,0,<TIPO>} }                      �
//� Onde: <DESCRICAO> - Descricao da opcao do menu                      �
//�       <ROTINA>    - Rotina a ser executada. Deve estar entre aspas  �
//�                     duplas e pode ser uma das funcoes pre-definidas �
//�                     do sistema (AXPESQUI,AXVISUAL,AXINCLUI,AXALTERA �
//�                     e AXDELETA) ou a chamada de um EXECBLOCK.       �
//�                     Obs.: Se utilizar a funcao AXDELETA, deve-se de-�
//�                     clarar uma variavel chamada CDELFUNC contendo   �
//�                     uma expressao logica que define se o usuario po-�
//�                     dera ou nao excluir o registro, por exemplo:    �
//�                     cDelFunc := 'ExecBlock("TESTE")'  ou            �
//�                     cDelFunc := ".T."                               �
//�                     Note que ao se utilizar chamada de EXECBLOCKs,  �
//�                     as aspas simples devem estar SEMPRE por fora da �
//�                     sintaxe.                                        �
//�       <TIPO>      - Identifica o tipo de rotina que sera executada. �
//�                     Por exemplo, 1 identifica que sera uma rotina de�
//�                     pesquisa, portando alteracoes nao podem ser efe-�
//�                     tuadas. 3 indica que a rotina e de inclusao, por�
//�                     tanto, a rotina sera chamada continuamente ao   �
//�                     final do processamento, ate o pressionamento de �
//�                     <ESC>. Geralmente ao se usar uma chamada de     �
//�                     EXECBLOCK, usa-se o tipo 4, de alteracao.       �
//�����������������������������������������������������������������������

//���������������������������������������������������������������������Ŀ
//� aRotina padrao. Utilizando a declaracao a seguir, a execucao da     �
//� MBROWSE sera identica a da AXCADASTRO:                              �
//�                                                                     �
//� cDelFunc  := ".T."                                                  �
//� aRotina   := { { "Pesquisar"    ,"AxPesqui" , 0, 1},;               �
//�                { "Visualizar"   ,"AxVisual" , 0, 2},;               �
//�                { "Incluir"      ,"AxInclui" , 0, 3},;               �
//�                { "Alterar"      ,"AxAltera" , 0, 4},;               �
//�                { "Excluir"      ,"AxDeleta" , 0, 5} }               �
//�                                                                     �
//�����������������������������������������������������������������������


//���������������������������������������������������������������������Ŀ
//� Monta um aRotina proprio                                            �
//�����������������������������������������������������������������������  

Private aRotina := { {"Pesquisar","AxPesqui",0,1},;
	                 {"Visualizar","AxVisual",0,2}}
	                 
If __cUserID $ "000000;000080;000119" //Admnistrador
    aAdd(aRotina, {"Incluir","AxInclui" ,0,3})               
	aAdd(aRotina, {"Alterar","AxAltera" ,0,4})              
	aAdd(aRotina, {"Excluir","AxDeleta" ,0,5}) 
	// aAdd(aRotina, {"Copiar","PAM" ,0,5})       
	aAdd(aRotina, {"Copiar","U_CopyCFD" ,0,5})              
Else
    Aviso(ProcName()+" - Aten��o!!!", "Usuario n�o � Administrador - n�o ser� permitido altera�ao", {"Ok"})
EndIf

dbSelectArea(cAlias)
dbSetOrder(1)

//���������������������������������������������������������������������Ŀ
//� Executa a funcao MBROWSE. Sintaxe:                                  �
//�                                                                     �
//� mBrowse(<nLin1,nCol1,nLin2,nCol2,Alias,aCampos,cCampo)              �
//� Onde: nLin1,...nCol2 - Coordenadas dos cantos aonde o browse sera   �
//�                        exibido. Para seguir o padrao da AXCADASTRO  �
//�                        use sempre 6,1,22,75 (o que nao impede de    �
//�                        criar o browse no lugar desejado da tela).   �
//�                        Obs.: Na versao Windows, o browse sera exibi-�
//�                        do sempre na janela ativa. Caso nenhuma este-�
//�                        ja ativa no momento, o browse sera exibido na�
//�                        janela do proprio SIGAADV.                   �
//� Alias                - Alias do arquivo a ser "Browseado".          �
//� aCampos              - Array multidimensional com os campos a serem �
//�                        exibidos no browse. Se nao informado, os cam-�
//�                        pos serao obtidos do dicionario de dados.    �
//�                        E util para o uso com arquivos de trabalho.  �
//�                        Segue o padrao:                              �
//�                        aCampos := { {<CAMPO>,<DESCRICAO>},;         �
//�                                     {<CAMPO>,<DESCRICAO>},;         �
//�                                     . . .                           �
//�                                     {<CAMPO>,<DESCRICAO>} }         �
//�                        Como por exemplo:                            �
//�                        aCampos := { {"TRB_DATA","Data  "},;         �
//�                                     {"TRB_COD" ,"Codigo"} }         �
//� cCampo               - Nome de um campo (entre aspas) que sera usado�
//�                        como "flag". Se o campo estiver vazio, o re- �
//�                        gistro ficara de uma cor no browse, senao fi-�
//�                        cara de outra cor.                           �
//�����������������������������������������������������������������������

dbSelectArea(cAlias)
mBrowse( 6,1,22,75,cAlias)

Return

User Function CopyCFD()
	Local aPergs   := {}
	
	Local cFilFCI := CFD->CFD_FILIAL 
	Local cProduto := CFD->CFD_COD   
	Local cOP := CFD->CFD_OP    
	Local nVparim := CFD->CFD_VPARIM
	Local nVsaiie := CFD->CFD_VSAIIE 
	Local nConImp := CFD->CFD_CONIMP
	Local cFCICod := CFD->CFD_FCICOD
	Local cFilOp := CFD->CFD_FILOP 
	Local cOrigem := CFD->CFD_ORIGEM
	Local cYOrigem := CFD->CFD_YORIGE

	aAdd(aPergs, {1, "Per�odo C�lculo",	CFD->CFD_PERCAL, 	"", ".T.", "",	".T.", 120, .T.})
	aAdd(aPergs, {1, "Per�odo Venda",  	CFD->CFD_PERVEN,  	"", ".T.", "", 	".T.", 120,  .T.})
	
	If ParamBox(aPergs, "Informe os par�metros")
		DbSelectArea("CFD")
		CFD->(DbSetOrder(1))
		If CFD->(DbSeek(cFilFCI+MV_PAR01+MV_PAR02+cProduto))
			MsgAlert("J� existe registro para este produto neste per�odo de c�lculo e venda.","Aten��o!")
			return
		EndIf
		RecLock("CFD",.T.)
		CFD->CFD_FILIAL	:= cFilFCI
		CFD->CFD_COD	:= cProduto
		CFD->CFD_OP		:= cOP
		CFD->CFD_VPARIM	:= nVparim
		CFD->CFD_VSAIIE	:= nVsaiie
		CFD->CFD_CONIMP	:= nConImp
		CFD->CFD_FCICOD	:= cFCICod
		CFD->CFD_FILOP	:= cFilOp
		CFD->CFD_ORIGEM	:= cOrigem
		CFD->CFD_YORIGE	:= cYOrigem
		CFD->CFD_PERCAL := MV_PAR01
		CFD->CFD_PERVEN	:= MV_PAR02
		CFD->(MsUnLock())
		MsgAlert("C�pia realizada com sucesso!","Aten��o!")
	EndIf
Return
