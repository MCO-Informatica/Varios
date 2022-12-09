#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  RFATC001    � Autor � Isaque O. Silva   � Data �  28/05/15   ���
�������������������������������������������������������������������������͹��
���Descricao � Rotina para reenviar xml sem a necessidade de exportar     ���
���          � o mesmmo                                                   ���
�������������������������������������������������������������������������͹��
���Uso       � gran real                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function RFATC001()


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Private cCadastro := "Reenvio do XML"
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

Private aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
             {"Visualizar","AxVisual",0,2} ,;
             {"Reenviar XML","U_RFATC01A()",0,4}}

Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock

Private cString := "SF2"

dbSelectArea("SF2")
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

dbSelectArea(cString)
mBrowse( 6,1,22,75,cString)

Return

User Function RFATC01A()

Local _cSerie	:= SF2->F2_SERIE
Local _cDoc		:= SF2->F2_DOC
Local oDlg
Private _cChave	:= _cSerie+_cDoc
Private _nMail	:= space(90) 
Private _cAlias:= GetNextAlias()
Private _nEnviar:= 1


//
cQuery := "SELECT SPED050.NFE_ID,SPED050.STATUS,SPED050.EMAIL FROM SPED050 "
cQuery +="WHERE SPED050.D_E_L_E_T_='' "
cQuery +="AND SPED050.NFE_ID='"+_cChave+"'"

cQuery := ChangeQuery(cQuery)  // padroniza com o banco existente ChangeQuery
	
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),_cAlias,.T.,.F.)
dbSelectArea(_cAlias)
_nMail := EMAIL
If MsgBox("Deseja reenviar o XML da NFE: "+NFE_ID+" ?","YESNO","YESNO") 

	DEFINE MSDIALOG oDlg TITLE OemToansi ("Reenvio de XML") From 74,7 TO 190,386 PIXEL
	
	@ 10, 04 SAY OemToansi("Email Atual:") SIZE 73, 8 OF oDlg PIXEL
	@ 09, 45 MSGET _nMail  When .F. SIZE 70 ,9 OF oDlg PIXEL
	
	@ 25, 04 SAY OemToansi("Novo Email:") 			   SIZE 73, 8 OF oDlg PIXEL
	@ 24, 45 MSGET _nMail  When .T. SIZE 70 ,9 OF oDlg PIXEL
	
	@ 45, 04 BUTTON OemToAnsi("Gravar")   SIZE 40 ,11  FONT oDlg:oFont ACTION (Grava(_nMail),oDlg:End())  OF oDlg PIXEL
	@ 45, 47 BUTTON OemToAnsi("Cancelar") SIZE 40 ,11  FONT oDlg:oFont ACTION (nOpc:=1,oDlg:End())  OF oDlg PIXEL
	
	ACTIVATE MSDIALOG oDlg CENTERED
	
	

	
		 	
		_cUpd := "UPDATE SPED050 SET "
		_cUpd += "STATUSMAIL='1'"
		_cUpd	+=	"WHERE D_E_L_E_T_=''"
		_cUpd += "AND NFE_ID='"+_cChave+"'"
		
		If TCSQLExec(_cUpd) < 0
 	  		MsgStop("[TCSQLError] " + TCSQLError(),"_049")
		EndIf  
		        
		msginfo("XML enviado")  
else
		msginfo("Cancelado o envio do XML")
endif
return
      
//�����������������������������������������Ŀ|
//�Funcao para Gravar a variavel "A gravar" �|
//�������������������������������������������|
Static Function GRAVA(_nMAIL) 	
		
		_cUpd := "UPDATE SPED050 SET "
		_cUpd += "EMAIL='"+_nMail+"'
		_cUpd	+=	"WHERE D_E_L_E_T_=''"
		_cUpd += "AND NFE_ID='"+_cChave+"'"
		
		If TCSQLExec(_cUpd) < 0
 	  		MsgStop("[TCSQLError] " + TCSQLError(),"_049")
		EndIf  )



Return(.T.)
