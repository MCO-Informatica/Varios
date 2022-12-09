#INCLUDE "PROTHEUS.CH"
#INCLUDE "TCBROWSE.CH"
#INCLUDE "COLORS.CH"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � U_Importa  � Autor � Opvs(Warleson)      � Data � 02/07/12 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Rotina de importacao de mailing                            ���
�������������������������������������������������������������������������Ĵ��
���USO       � CERTISIGN - CALL CENTER                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
// oBS: Adapta��o da rotina padr�o TK341Importa  -warleson.
/*/
//������������������������������������������������������������������Ŀ
//�Par�metros da Rotina                                              �
//�                                                                  �
//�SDK_ASSUNTO = Codigo do Assunto padrao para abertura de chamados  �
//�SDK_OCORREN = Codigo da Ocorrencia padrao para abertura de chamado�
//��������������������������������������������������������������������

/*
//�����������������������������������������������������������Ŀ
//�Depend�ncias                                               �
//�SUS - Para inclus�o de Prospect                            �
//�SU5 - Para inclus�o de Contato                             �
//�AC8 - Para relacionamento de Entidade(Prospect) XContato   �
//�ADE - Para abertura de atendimento (Cabe�alho)             �
//�ADF - Para abertura de atendimento (Itens)                 �
//�PA8 - Para consultar/Validar produto Gar                   �
//�SB1 - Para Consultar/Validar produto Protheus              �
//�Classe HardwareavulsoProvider - Para consultar o Pedido GAR�
//�������������������������������������������������������������

Para abertura de atendimento devem esta configurado corretamente:
1 - Grupo de atendimento
2 - Modelo de atendimento (para o grupo)
3 - Assunto
4 - GRupo X Assunto
5 - Ocorrencia
*/

User Function Importacao()

Local oDlg											// Objeto da Tela
Local oBar               							// Botao superior
Local oMailing                                      // Objeto para GET do arquivo de mailing que sera importado
Local oArquivo 										// Objeto do GET para o nome arquivo
Local cArquivo 	  	:= ""							// Variavel de memoria para o nome do arquivo
Local cMailing		:= CRIAVAR("X5_CHAVE",.F.)		// Variavel de memoria do arquivo de mailing que sera importado
Local aBtn        	:= Array(10)					// Array para criacao dos botoes da toolbar superior
Local aSize 		:= {}
Local aObjects 		:= {}    
Local aInfo			:= {}
Local aPosGet		:= {}              

Private oData 										// Objeto do GET para a Data da agenda do Operador
Private dData 	  	:= dDataBase					// Variavel de memoria para a Data da agenda do Operador
Private cAssSdk		:= SuperGetMv("SDK_CODASS",,"ATR003")	// Codigo do Assunto padrao para abertura de Chamados
Private cOcoSdk 	:= SuperGetMv("SDK_OCORRE",,"003153")	// Codigo da Ocorrencia padr�o para Abertura de Chamados
Private aMailing	:= {}							// Estrutura do arquivo de mailing que sera convertido para dentro do sistema
Private cDir		:= ""							// ??
Private cDir2		:= "" 
Private _cPosto		:= ""
Private _cOperad	:= ""
Private nDias 		:= 1
Private oDias
Private aArea		


/*
���������������������������������������������������������������������������������������Ŀ
�  ARRAY ASIZE - Tamannhos da Dialog e Area de Trabalho									�
�                        																�
� 1 - Linha inicial area trabalho														�
� 2 - Coluna inicial area trabalho														�
� 3 - Linha final area trabalho														    �
� 4 - Coluna final area trabalho														�
� 5 - Coluna final dialog																�
� 6 - Linha final dialog																�
� 7 - Linha inicial dialog																�
���������������������������������������������������������������������������������������Ĵ
�																						�
�  ARRAY AOBJECTS - Tamanhos Default dos Objetos para o calculo das posicoes			�
�                        																�
� 1 - Tamanho X																			�
� 2 - Tamanho Y																			�
� 3 - Dimensiona X																		�
� 4 - Dimensiona Y																		�
� 5 - Retorna dimensoes X e Y (SIZE) ao inves de linha / coluna final					�	
�																						�
���������������������������������������������������������������������������������������Ĵ
�  ARRAY AINFO - Tamanhos da Area onde sera calculado as posicoes dos objetos			�
�                        																�
� 1 - Posicao Inicial X																	�
� 2 - Posicao Inicial Y                                                                 � 
� 3 - Posicao Final X																	�
� 4 - Posicao Final Y                                                                   � 
� 5 - Espaco lateralmente entre os objetos                                              � 
� 6 - Espaco verticalmente entre os objetos                                             � 
�																						�
�����������������������������������������������������������������������������������������
*/

aArea:= GetArea()

DbSelectArea("SU7")
DbSetOrder(4)
	
If MsSeek(xFilial("SU7")+__cUserId)
	_cPosto		:= 	SU7->U7_POSTO	// Posiciona e retorna o valor do U7_POSTO	
	_cOperad	:= 	SU7->U7_COD
EndIf  
	
RestArea(aArea)

aSize := MsAdvSize( .T., .F., 400 )
aObjects := {}
AAdd( aObjects, { 100, 100, .t., .t. } )
AAdd( aObjects, { 100, 100, .t., .t. } )

aInfo 	:= { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 0, 0 }
aPosObj := MsObjSize( aInfo, aObjects,  , .F. )

aPosGet := MsObjGetPos( aSize[3]-aSize[1],315,{{003,033,160,200,240,265}} )

DEFINE MSDIALOG oDlg TITLE 'Importa��o de Prospect X Contatos e Abertura de atendimentos Service desk' FROM aSize[7],0 TO aSize[6],aSize[5] OF oMainWnd PIXEL

	//����������������������������������Ŀ
	//�Cria os botoes da toolbar superior�
	//������������������������������������
	//DEFINE BUTTONBAR oBar 3D TOP OF oDlg
	
	DEFINE BUTTON aBtn[08]  RESOURCE "SDURECALL" OF oBar TOOLTIP 'Importar';
	ACTION  Tk341LeArq(oMailing,@aMailing,cDir,cArquivo,cMailing)  				//"Importar"

	DEFINE BUTTON aBtn[09]  RESOURCE "OK"       OF oBar TOOLTIP 'Ok';       
	ACTION ( Processa({|lEnd|U_GravaProspect(aMailing,@lEnd)},"Gravando Registros...","Aguarde...",.T.),oDlg:End()) 		//"Ok","Gravando Suspect..."
	
	DEFINE BUTTON aBtn[10]  RESOURCE "CANCEL"   OF oBar TOOLTIP 'Cancelar';
	ACTION oDlg:End() 															//"Cancelar"

	//����������������������������������������Ŀ
	//�Cria os objetos da tela de importacao   �
	//������������������������������������������
	@ 15,05 TO 35,aSize[3] LABEL "" OF oDlg PIXEL
	
	@ 21,10 SAY 'Arquivo' SIZE 50,7 OF oDlg PIXEL  //"Arquivo"
	@ 20,35 MSGET oArquivo VAR cArquivo SIZE 100,10 OF oDlg PIXEL Picture "@!" WHEN .F.
	
	DEFINE SBUTTON FROM 019,140 TYPE 14 ENABLE OF oDlg ACTION Tk341Arquivo(@cDir,@cArquivo,@oArquivo)
	
	@ 21,175 SAY 'Agendar para ' SIZE 50,7 OF oDlg PIXEL
	@ 20,210 MSGET oData VAR dData OF oDlg PIXEL VALID (IIF((dData-nDias)>=dDataBase,.T.,eval({||alert('Favor revisar a data de agendamento!'),.F.})))

	@ 21,260 SAY 'Encerrar lista em,           dias antes da data de expira��o.' SIZE 200,7 OF oDlg PIXEL
	@ 20,302 MSGET oDias VAR nDias OF oDlg PIXEL PICTURE '99' VALID (IIF(nDias>=0,.T.,eval({||alert('Favor revisar a quantidade de dias!'),.F.})))

	oMailing := TCBrowse():New(3,0,(aSize[5]/2.0),(aSize[6]/2.8),,{"Titulos dos campos"},{5,5,5,5,5},oDlg) //"Titulos dos campos"
	oMailing:SetArray( aMailing )

	ADD COLUMN TO oMailing HEADER 'Pedido' 			OEM DATA {|| aMailing[oMailing:nAt,1]}  ALIGN LEFT SIZE 35 PIXEL  
	ADD COLUMN TO oMailing HEADER 'Renova��o' 		OEM DATA {|| aMailing[oMailing:nAt,2]}  ALIGN LEFT SIZE 80 PIXEL  
	ADD COLUMN TO oMailing HEADER 'Cliente' 		OEM DATA {|| aMailing[oMailing:nAt,3]}  ALIGN LEFT SIZE 80 PIXEL  
	ADD COLUMN TO oMailing HEADER 'Raz�o Social' 	OEM DATA {|| aMailing[oMailing:nAt,4]}  ALIGN LEFT SIZE 80 PIXEL  
	ADD COLUMN TO oMailing HEADER 'Email' 			OEM DATA {|| aMailing[oMailing:nAt,5]}  ALIGN LEFT SIZE 80 PIXEL  
	ADD COLUMN TO oMailing HEADER 'Telefone' 		OEM DATA {|| aMailing[oMailing:nAt,6]}  ALIGN LEFT SIZE 35 PIXEL  
	ADD COLUMN TO oMailing HEADER 'Munic�pio' 		OEM DATA {|| aMailing[oMailing:nAt,7]}  ALIGN LEFT SIZE 40 PIXEL  
	ADD COLUMN TO oMailing HEADER 'UF' 				OEM DATA {|| aMailing[oMailing:nAt,8]}  ALIGN LEFT SIZE 15 PIXEL  
	ADD COLUMN TO oMailing HEADER 'Dt.Emiss�o'	 	OEM DATA {|| aMailing[oMailing:nAt,9]}  ALIGN LEFT SIZE 40 PIXEL  
	ADD COLUMN TO oMailing HEADER 'Dt.Expira��o' 	OEM DATA {|| aMailing[oMailing:nAt,10]} ALIGN LEFT SIZE 40 PIXEL  
	ADD COLUMN TO oMailing HEADER 'Qtd. Dura��o' 	OEM DATA {|| aMailing[oMailing:nAt,11]} ALIGN LEFT SIZE 60 PIXEL  
	ADD COLUMN TO oMailing HEADER 'Certificado' 	OEM DATA {|| aMailing[oMailing:nAt,12]} ALIGN LEFT SIZE 30 PIXEL  
	ADD COLUMN TO oMailing HEADER 'Tipo' 			OEM DATA {|| aMailing[oMailing:nAt,13]} ALIGN LEFT SIZE 15 PIXEL  
	ADD COLUMN TO oMailing HEADER 'Tipo Pessoa' 	OEM DATA {|| aMailing[oMailing:nAt,14]} ALIGN LEFT SIZE 15 PIXEL  
	
ACTIVATE MSDIALOG oDlg CENTERED

Return(.T.)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � Tk341LeArq  � Autor � Vendas Clientes  � Data �  12/07/01  ���
�������������������������������������������������������������������������͹��
���Descri��o � Executa a leitura do arquivo de mailing                    ���
�������������������������������������������������������������������������͹��
���Uso       � CALL CENTER				                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function Tk341LeArq(oMailing,aMailing,cDir,cArquivo,cMailing)

Local lRet    		:= .T.		// Retorno da funcao
Local nQtdCol 		:= Len(oMailing:GetColSizes())
Local _cMsg			:= ''

IF !((dData-nDias)>=dDataBase) .or. !(nDias>=0)
	alert('Favor revisar a data de agendamento!')
	Return
Endif

//�������������������������������������������������������������������������������������Ŀ
//� Verifica se o arquivo .CSV existe e se seu nome coincide com a empresa selecionada  �
//���������������������������������������������������������������������������������������
If File(cDir) //.AND. (Upper((Alltrim(cMailing)+".CSV")) == Upper((cArquivo)) )

	_cMsg := 'Confirmar importa��o de mailing para o grupo '+_cPosto+'?'
	
	If !(MsgNoYes(_cMsg,'ATEN��O !'))
		lRet := .F.
		Return lRet
    Endif
    
	//���������������������������������������������������������������������Ŀ
	//� Inicializa a regua de processamento                                 �
	//�����������������������������������������������������������������������
	Processa({|| aMailing := Tk341LeTexto(cDir,nQtdCol) },"Importando Mailing...","Aguarde...",.F.) //"Importando Mailing..."

	If (Len(aMailing) > 0)
		oMailing:SetArray(aMailing)
		oMailing:Refresh()
	Endif
	
Else
	MsgAlert("N�o foi poss�vel encontrar o arquivo"+CRLF+"escolhido para a convers�o do Mailing.")
	lRet := .F.
Endif

Return(lRet)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �Tk341LeTexto  � Autor � Vendas Clientes    � Data �12/07/01 ���
�������������������������������������������������������������������������͹��
���Descri��o �Leitura do arquivo de texto para conversao em tabela		  ���
�������������������������������������������������������������������������͹��
���Uso       � CALL CENTER                                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function TK341LeTexto(cDir,nQtdCol)

Local aEstrutura := {}		// Estrutura com os campos do mailing

//�����������������������������������������������������������������������������Ŀ
//�Ponto de entrada para estruturacao do array importado do arquivo de mailing  �
//�Retorna o Array aMailing.            								        �
//�������������������������������������������������������������������������������
aEstrutura := U_CSVImporta(cDir,nQtdCol)

Return(aEstrutura)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �U_ImportaCSV �Autor  � Opvs(Warleson)  � Data �  27/06/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Verifica os diferentes tipos de mailing para estruturacao  ���
���          � do array que sera importado                                ���
�������������������������������������������������������������������������͹��
���Uso       � CERTISIG/CALL CENTER/ SERVICEDESK                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
//Adaptacao da funcao TMKMAIL - Opvs(Warleson) - 27/06/12

User Function  CSVImporta(cArquivo)

Local cBuffer     := ""
Local cAux        := ""
Local cString     := ""
Local cSeparador  := ""  //Verifica o tipo de separador do arquivo texto
Local aTmp        := {}
Local aEstrutura  := {}
Local nCont       := 0
Local cEof        := Chr(10)+ Chr(13)
Local nRec        := 0
Local lAspa       := .F.


//���������������������������������������������������������������������Ŀ
//� Leitura da quantidade de Registros do Arquivo                       �
//�����������������������������������������������������������������������

If !UPPER(substring(cArquivo,len(cArquivo)-3,4))== '.CSV'
	Aadd(aEstrutura,array(21))
	Alert('Favor revisar a estrutura do arquivo CSV!')
	Return (aEstrutura)
Endif

FT_FUSE(cArquivo)

FT_FGOTOP()
While !FT_FEOF()
	nRec++
	FT_FSKIP()
End

ProcRegua(nRec)

//��������������������������������������������������������������������������������������������������Ŀ
//� Leitura do mailing e verificacao do ultimo caracter da linha lida para  consistencia da pesquisa �
//����������������������������������������������������������������������������������������������������
FT_FGOTOP()

While !FT_FEOF()
	cBuffer:= AllTrim(FT_FREADLN())
	
	If At(";",cBuffer) > 0
		cSeparador:= ";"
	ElseIf At(",",cBuffer) > 0
		cSeparador:= ","
	Else //linha de arquivo incorreta.
		IncProc()
		FT_FSKIP()
		Loop
	Endif
	
	If (SubStr(cBuffer,Len(cBuffer),1)<>cSeparador)
		cBuffer+= cSeparador + cEof + cSeparador
	Else
		cBuffer+= cEof + cSeparador
	Endif
	
	//���������������������������������������������������������������������Ŀ
	//� Incrementa a regua                                                  �
	//�����������������������������������������������������������������������
	IncProc()
	
	//���������������������������������������������������������������������Ŀ
	//�  Carrega o array aEstrutura com o resultado da Importacao           �
	//�����������������������������������������������������������������������
	cLinha:= cBuffer
	lAspa := .F.
	For nCont := 1 To Len(cBuffer)

		cAux   := SubStr(cLinha,1,1)
		cLinha := SubStr(cLinha,2)
		If (cAux == cEof)
			Exit
		Endif
		
		//������������������������������������������������������������������������������Ŀ
		//�  Sao verificadas as marcacoes feitas pelo Excel para concatenacao de strings �
		//��������������������������������������������������������������������������������
		Do Case
			Case cAux == '"'
				lAspa := !lAspa
			Case cAux == cSeparador .And. !lAspa
				Aadd(aTmp,cString)
				cString := ""
			OtherWise
				cString += cAux
		EndCase

	Next nCont
	
	For nCont := Len(aTmp)+1 To 11
		Aadd(aTmp,"")
	Next nCont
	
	//��������������������������������������������������Ŀ
	//�Validacao para nao salvar registros sem entidades �
	//����������������������������������������������������
//	If !Empty(aTmp[18]) .OR. !Empty(aTmp[19]) //[18] CPF, [19] CNPJ 
//-----------------------------------------------------------------------------
// Inicio - Picture CERTISIGN - opvs(warleson) - 28/06/12 
		For nCont:=1 to len(aTmp)
			Do Case
				Case (nCont==5) // E-mail 
					aTmp[nCont]:= Lower(NoAcento(AnsiToOem(aTmp[nCont]))) // Remove acentos e formata para minusculo
				OtherWise
					aTmp[nCont]:= UPPER(NoAcento(AnsiToOem(aTmp[nCont]))) 
			EndCase
		Next
// Final - Picture CERTISIGN
//-----------------------------------------------------------------------------
		If Len(aTmp) < 21
			Aadd(aEstrutura,array(21))
			Alert('Favor revisar a estrutura do arquivo CSV!')
			Return (aEstrutura)
	    Endif

		Aadd(aEstrutura,aTmp)
		aTmp := {}
//	Endif
	FT_FSKIP()
End

FT_FUSE()

// Indexacao e Ordenacao pelo campo DT_EXPIRACAO  - incio

For x:=2 to len(aEstrutura)
	aEstrutura[x][10]:= cTod(aEstrutura[X][10])
	aAdd(aEstrutura[x],x)
Next

ASORT(aEstrutura,2,,{|x,y|x[10]<y[10]})

For x:=2 to len(aEstrutura)
	aEstrutura[x][10]:= dtOC(aEstrutura[X][10])
	aAdd(aEstrutura[x],x)
Next


// Indexacao e Ordenacao pelo campo DT_EXPIRACAO  - Final

Return (aEstrutura)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GravaProspect�Autor  �Opvs(Warleson)      � Data �  06/28/12���
�������������������������������������������������������������������������͹��
���Desc.     � Faz inclusao ou alteracao de prospect                      ���
���          � proviniente da importacao CSV                              ���
�������������������������������������������������������������������������͹��
���Uso       � SERVICEDESK - CERTISIGN                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User function GravaProspect(aMailing,lEnd)

Local lRet 	  	:= .T.							// Retorno da gravacao
Local nCont     := 0 							// Contador de campos
Local nSaveSx8 	:= GetSX8Len()					// Funcao de numeracao
Local aContato	:= {}							// Dados dos contatos copiados
Local cTipo 	:= ""
Local cCPF		:= ""
Local cCNPJ		:= ""
Local cCGC	 	:= ""
Local cDoc		:= "" 
Local nPos		:= 0

Local lGrvSUS	:= .T. // Inclusao/Alteracao - Prospect
Local lGrvSU5	:= .T. // Inclusao/Alteracao - Contato
Local GrvAC8	:= .T. // Inclusao/Alteracao - Relacionamento Prospect x Contatos

Private lGravou	:= .F.
Private cDDD		:= ""
Private cTel		:= "" 


Private nArq		:= 0
PRivate cNome		:= '' //Nome do arquivo a ser gravado
Private aEst		:= {} 
Private nI			:= 0 //Indice do Vetor aMailing
Private cCodCont	:= "" // Codigo do Contao
Private cEntNome	:= "" // Nome do Prospect
Private cContato	:= "" // Nome do Contato
Private cCodPro 	:= CRIAVAR("US_COD",.F.)		// Futuro codigo do novo prospect que sera INCLUIDO no SUS
Private cLojaPad	:= "01"
Private cCodSB1		:= ""
Private cFilTemp	:= ""
Private nTotReg		:= Len(aMailing)-1
Private cTabelas	:= ""

IF !((dData-nDias)>=dDataBase) .or. !(nDias>=0)
// 1=	alert('Favor revisar a data de agendamento!')
// 2=	alert('Favor revisar a quantidade de dias!')
	Return
Endif

	aAdd(aEst,{'11','SP','S�o Paulo'})
	aAdd(aEst,{'12','SP','S�o Paulo'})
	aAdd(aEst,{'13','SP','S�o Paulo'})
	aAdd(aEst,{'14','SP','S�o Paulo'})
	aAdd(aEst,{'15','SP','S�o Paulo'})
	aAdd(aEst,{'16','SP','S�o Paulo'})
	aAdd(aEst,{'17','SP','S�o Paulo'})
	aAdd(aEst,{'18','SP','S�o Paulo'})
	aAdd(aEst,{'19','SP','S�o Paulo'})
	aAdd(aEst,{'21','RJ','Rio de Janeiro'})
	aAdd(aEst,{'22','RJ','Rio de Janeiro'})
	aAdd(aEst,{'24','RJ','Rio de Janeiro'})
	aAdd(aEst,{'27','ES','Esp�rito Santo'})
	aAdd(aEst,{'28','ES','Esp�rito Santo'})
	aAdd(aEst,{'31','MG','Minas Gerais'})
	aAdd(aEst,{'32','MG','Minas Gerais'})
	aAdd(aEst,{'33','MG','Minas Gerais'})
	aAdd(aEst,{'34','MG','Minas Gerais'})
	aAdd(aEst,{'35','MG','Minas Gerais'})
	aAdd(aEst,{'37','MG','Minas Gerais'})
	aAdd(aEst,{'38','MG','Minas Gerais'})
	aAdd(aEst,{'41','PR','Paran�'})
	aAdd(aEst,{'42','PR','Paran�'})
	aAdd(aEst,{'43','PR','Paran�'})
	aAdd(aEst,{'44','PR','Paran�'})
	aAdd(aEst,{'45','PR','Paran�'})
	aAdd(aEst,{'46','PR','Paran�'})
	aAdd(aEst,{'47','SC','Santa Catarina'})
	aAdd(aEst,{'48','SC','Santa Catarina'})
	aAdd(aEst,{'49','SC','Santa Catarina'})
	aAdd(aEst,{'51','RS','Rio Grande do Sul'})
	aAdd(aEst,{'53','RS','Rio Grande do Sul'})
	aAdd(aEst,{'54','RS','Rio Grande do Sul'})
	aAdd(aEst,{'55','RS','Rio Grande do Sul'})
	aAdd(aEst,{'61','DF','Distrito Federal e Entorno'})
	aAdd(aEst,{'62','GO','Goi�s'})
	aAdd(aEst,{'63','TO','Tocantins'})
	aAdd(aEst,{'64','GO','Goi�s'})
	aAdd(aEst,{'65','MT','Mato Grosso'})
	aAdd(aEst,{'66','MT','Mato Grosso'})
	aAdd(aEst,{'67','MS','Mato Grosso do Sul'})
	aAdd(aEst,{'68','AC','Acre'})
	aAdd(aEst,{'69','RO','Rond�nia'})
	aAdd(aEst,{'71','BA','Bahia'})
	aAdd(aEst,{'73','BA','Bahia'})
	aAdd(aEst,{'74','BA','Bahia'})
	aAdd(aEst,{'75','BA','Bahia'})
	aAdd(aEst,{'77','BA','Bahia'})
	aAdd(aEst,{'79','SE','Sergipe'})
	aAdd(aEst,{'81','PE','Pernambuco'})
	aAdd(aEst,{'82','AL','Alagoas'})
	aAdd(aEst,{'83','PB','Para�ba'})
	aAdd(aEst,{'84','RN','Rio Grande do Norte'})
	aAdd(aEst,{'85','CE','Cear�'})
	aAdd(aEst,{'86','PI','Piau�'})
	aAdd(aEst,{'87','PE','Pernambuco'})
	aAdd(aEst,{'88','CE','Cear�'})
	aAdd(aEst,{'89','PI','Piau�'})
	aAdd(aEst,{'91','PA','Par�'})
	aAdd(aEst,{'92','AM','Amazonas'})
	aAdd(aEst,{'93','PA','Par�'})
	aAdd(aEst,{'96','AP','Amapa'})
	aAdd(aEst,{'97','AM','Amazonas'})
	aAdd(aEst,{'98','MA','Maranh�o'})
	aAdd(aEst,{'99','MA','Maranh�o'})	

	//ProcRegua(Len(aMailing))
	ProcRegua(0)	

	For nI:=2 to len(aMailing)

		If !(cTod(aMailing[nI][10]) >= dDataBase)
			cMotivo:='Contato Expirado em '+aMailing[nI][10]
		   	gravalog(aMailing[nI][len(aMailing[nI])-1],'Data de Expira��o',cMotivo)
			IncProc('Processando '+cvaltochar(nI-1) +' de '+cvaltochar(nTotReg)+' / Incluindo '+cTabelas+'...')
		   	Loop
		Elseif !(cTod(aMailing[nI][10]) >= dData) 
			cMotivo:='Agendado para data posterior a expira��o'
		   	gravalog(aMailing[nI][len(aMailing[nI])-1],'Data de Expira��o',cMotivo)
			IncProc('Processando '+cvaltochar(nI-1) +' de '+cvaltochar(nTotReg)+' / Incluindo '+cTabelas+'...')
		   	Loop
		Endif
		
		If !empty(aMailing[nI][21]) // grupo
			If !(_cPosto == strzero(val(aMailing[nI][21]),2))
			   	cMotivo:='Grupo inv�lido '+strzero(val(aMailing[nI][21]),2)
			   	gravalog(aMailing[nI][len(aMailing[nI])-1],'Grupo',cMotivo)
				IncProc('Processando '+cvaltochar(nI-1) +' de '+cvaltochar(nTotReg)+' / Incluindo '+cTabelas+'...')
			   	Loop
		   	Endif
		Else
		   	cMotivo:='Grupo vazio'
		   	gravalog(aMailing[nI][len(aMailing[nI])-1],'Grupo',cMotivo)
			IncProc('Processando '+cvaltochar(nI-1) +' de '+cvaltochar(nTotReg)+' / Incluindo '+cTabelas+'...')
		   	Loop		
		Endif

		cTabelas			:= "Prospect"
		aMailing[nI][06] 	:= Transform(StrTran(aMailing[nI][06],'-',''),'@r '+replicate('9',len(aMailing[nI][06]))) // Retira mascaras e aceita apenas "numeros" // Telefone
	 	aMailing[nI][18] 	:= strzero(VAL(Transform(StrTran(aMailing[nI][18],'-',''),'@r '+replicate('9',len(aMailing[nI][18])))),11) // Retira mascaras e aceita apenas "numeros" // CPF
	 	aMailing[nI][19] 	:= strzero(VAL(Transform(StrTran(aMailing[nI][19],'-',''),'@r '+replicate('9',len(aMailing[nI][19])))),14) // Retira mascaras e aceita apenas "numeros" // CNPJ
		cTipo				:= Upper(substr(aMailing[nI][14],2,1))

		cCPF	:= aMailing[nI][18] //CPF
		cCNPJ	:= aMailing[nI][19] 

	 	If !empty(cCPF) //CPF
		   	if !xcgc(cCPF)
			   	cMotivo:='CPF inv�lido '+cCPF
			   	gravalog(aMailing[nI][len(aMailing[nI])-1],'CPF ',cMotivo)
				IncProc('Processando '+cvaltochar(nI-1) +' de '+cvaltochar(nTotReg)+' / Incluindo '+cTabelas+'...')
			   	Loop
		   	endif
		Else
		   	cMotivo:='CPF vazio '+cCPF
		   	gravalog(aMailing[nI][len(aMailing[nI])-1],'CPF ',cMotivo)
			IncProc('Processando '+cvaltochar(nI-1) +' de '+cvaltochar(nTotReg)+' / Incluindo '+cTabelas+'...')
		   	Loop		
		Endif

	 	If cTipo=="F"	// Pessoa Fisica
	 		cCGC	:= cCPF
	 		cEntNome:= aMailing[nI][03]
	 		cContato:= aMailing[nI][03]
	 		cDoc	:= "CPF"
	 	Elseif cTipo=="J"	// Pessoa Juridica
	 		cCGC	:= cCNPJ
	 		cEntNome:= aMailing[nI][04]
	 		cContato:= aMailing[nI][03]
	 		cDoc 	:= "CNPJ"
	 	Else 	// Tipo inv�lido
			cMotivo:='Tipo de Pessoa inv�lido '+cTipo
		   	gravalog(aMailing[nI][len(aMailing[nI])-1],'CL_PESSOA',cMotivo)
			IncProc('Processando '+cvaltochar(nI-1) +' de '+cvaltochar(nTotReg)+' / Incluindo '+cTabelas+'...')
		   	Loop
	 	Endif

	 	if empty(cContato)
			cMotivo:='Campo Contato Vazio'
		   	gravalog(aMailing[nI][len(aMailing[nI])-1],'Contato',cMotivo)
			IncProc('Processando '+cvaltochar(nI-1) +' de '+cvaltochar(nTotReg)+' / Incluindo '+cTabelas+'...')
		   	Loop	 	
	 	Endif
	 	
	 	If cTipo=="J"
		 	If !empty(cCGC)
			   	if !xcgc(cCGC)
				   	cMotivo:='CGC inv�lido '+cCGC
				   	gravalog(aMailing[nI][len(aMailing[nI])-1],cDoc,cMotivo)
					IncProc('Processando '+cvaltochar(nI-1) +' de '+cvaltochar(nTotReg)+' / Incluindo '+cTabelas+'...')
				   	Loop
			   	endif
			Else
			  	cMotivo:='CGC vazio '+cCGC
				gravalog(aMailing[nI][len(aMailing[nI])-1],cDoc,cMotivo)
				IncProc('Processando '+cvaltochar(nI-1) +' de '+cvaltochar(nTotReg)+' / Incluindo '+cTabelas+'...')
				Loop			
			Endif
		Endif

		if len(aMailing[nI][06])>9  //telefone
			cDDD	:= Substr(aMailing[nI][06],1,2) // DDD						
			cTel:= Substr(aMailing[nI][06],3,8) 		// Telefone
		endif
	
		if !empty(cTel)
			if (len(cTeL)<8)
				cMotivo:='Telefone inv�lido '+aMailing[nI][06]+' '+cTel
				gravalog(aMailing[nI][len(aMailing[nI])-1],'Telefone',cMotivo)
				IncProc('Processando '+cvaltochar(nI-1) +' de '+cvaltochar(nTotReg)+' / Incluindo '+cTabelas+'...')
				Loop	
			elseif empty(cDDD)
				cMotivo:='DDD vazio '+cTel
				gravalog(aMailing[nI][len(aMailing[nI])-1],'Telefone',cMotivo)
				IncProc('Processando '+cvaltochar(nI-1) +' de '+cvaltochar(nTotReg)+' / Incluindo '+cTabelas+'...')
				Loop
			endif
		Endif		
		
		Begin Transaction
			
		//�����������������������������������������Ŀ
		//� Gravacao do Prospect                    �
		//�������������������������������������������

			DbSelectArea("SUS")
			DbSetOrder(4) //Filial+CGC
			lGrvSUS:= !(DbSeek(xFilial("SUS")+cCGC))
        
			If lGrvSUS
				cCodPro := TkNumero("SUS","US_COD")
			Else
				cCodPro := SUS->US_COD		
				//cCodPro	:= AC8_CODENT	
			Endif
			
			cEst := aMailing[nI][08]
			
			if empty(cEst) .and. !empty(cDDD)
				nPos:= ASCAN(aEst, {|x| x[1] == cDDD})
				if nPos>0
					cEst:= aEst[nPos][2]
				Endif
			Endif
			
			Reclock("SUS",lGrvSUS)
		
			Replace US_FILIAL		With xFilial("SUS")
			Replace US_COD	    	With cCodPro
			Replace US_LOJA	    	With cLojaPad
			Replace US_TIPO	    	With 'F' //Consumidor final
			Replace US_NOME	    	With cEntNome
			Replace US_NREDUZ   	With ""
			Replace US_END      	With ""
			Replace US_MUN      	With aMailing[nI][07]
			Replace US_BAIRRO   	With ""
			Replace US_CEP      	With ""
			Replace US_EST 	    	With cEst
			Replace US_DDD	    	With cDDD
			Replace US_DDI	    	With ""
			Replace US_TEL	    	With SgLimpaTel(cTel)
			Replace US_FAX      	With ""
			Replace US_EMAIL    	With aMailing[nI][05]
			Replace US_URL	    	With ""
			Replace US_PESSO    	With cTipo
			Replace US_CGC      	With cCGC
			Replace US_STATUS   	With "1"			// "Classificado" - Status inicial quando o suspect passa para Prospect
			Replace US_ORIGEM   	With "1"			// "Mailing" - Origem desse prospect
			Replace US_CATEGO   	With ""
			Replace US_DATAIMP 		With dDatabase
					
			MsUnlock()
	
			if lGrvSUS
				While (GetSx8Len() > nSaveSx8)
					ConfirmSX8()
				End	
			Endif	
	
	    End Transaction

		//�����������������������������������������Ŀ
		//� Gravacao do Contato                     �
		//�������������������������������������������
        
		cTabelas	:= "Contato"
		
			DbSelectarea("SU5")
			DbSetOrder(8)//CPF 
		
			If  !DbSeek(xFilial("SU5")+cCPF) 			
				cCodCont	:= GETSXENUM("SU5","U5_CODCONT")
				lGrvSU5 	:= .T.
			Else
			   	cCodCont	:= SU5->U5_CODCONT
				lGrvSU5 	:=.F.
			Endif
			
			Reclock("SU5",lGrvSU5)
			Replace U5_FILIAL	  With  xFilial("SU5")
			Replace U5_CODCONT    With  cCodCont
			Replace U5_CONTAT     With cContato
			Replace U5_FUNCAO     With ""
			Replace U5_DDD        With cDDD
			Replace U5_FCOM1      With cTel
			Replace U5_FAX        With ""
			Replace U5_STATUS     With "2" // Atualizado
			Replace U5_END     	  With ""
			Replace U5_MUN        With ""
			Replace U5_CEP        With ""
			Replace U5_EST        With cEst
			Replace U5_SEGMEN 	  With ""
			Replace U5_CATEGO     With ""
			Replace U5_MIDIA      With "" 
			Replace U5_VEND    	  With "" 
			Replace U5_OBSERVA 	  With "" 
			Replace U5_PRODINT 	  With ""
			Replace U5_EMAIL 	  With aMailing[nI][05]// Email
			Replace U5_CPF		  With cCPF
			Replace U5_DTIMPO     With dDatabase //	data da importacao

			DbCommit()
			MsUnlock()
			
			If lGrvSU5
				ConfirmSx8()
			Endif
		
		//���������������������������Ŀ
		//�Grava relacionamento no AC8�
		//�����������������������������

			dbSelectArea("AC8")
			dbsetorder(1)
			If !DbSeek(xFilial("AC8")+cCodCont+"SUS"+xFilial("SUS")+(cCodPro+cLojaPad))
				lGrvAC8 := .T.
			Else
				lGrvAC8 := .F.
			Endif
			
			RecLock("AC8",lGrvAC8)
			Replace AC8->AC8_FILIAL With xFilial("AC8")
			Replace AC8->AC8_FILENT With xFilial("SUS")
			Replace AC8->AC8_ENTIDA With "SUS"
			Replace AC8->AC8_CODENT With cCodPro + cLojaPad
			Replace AC8->AC8_CODCON With cCodCont
			
			MsUnLock()
  
			cTabelas	:= "Atendimento"
			
			//cFilTemp 	:= cFilant
			//cFilant	:= '02'
			
  			cCodSB1	:= Posicione('PA8', 1, xFilial('PA8')+ALLTRIM(aMailing[nI][20]), 'PA8_CODMP8') // Codigo produto gar
			
			if empty(cCodSB1)            
				cMotivo:='Codigo do Produto GAR Inv�lido '+ALLTRIM(aMailing[nI][20])
				gravalog(aMailing[nI][len(aMailing[nI])-1],'Produto',cMotivo)
				IncProc('Processando '+cvaltochar(nI-1) +' de '+cvaltochar(nTotReg)+' / Incluindo '+cTabelas+'...')
				Loop
        	Endif

			//--------------------------------
			//Tratamento para Importacao de Pedido Gar repetido na mesma Data.
			dbselectarea('ADE')
			DBORDERNICKNAME("PEDIDOGAR") //ADE_FILIAL+ADE_PEDGAR+ADE_DATA
			If dbseek(xfilial('ADE')+PADR(aMailing[nI][1],10)+DToS(dDataBase)) //PEDIDOGAR
				cMotivo:='Pedido Gar j� importado Nesta data'
				gravalog(aMailing[nI][len(aMailing[nI])-1],'Atendimento',cMotivo)
				IncProc('Processando '+cvaltochar(nI-1) +' de '+cvaltochar(nTotReg)+' / Incluindo '+cTabelas+'...')
				Loop
			Endif
			//--------------------------------	
		
			if !(GravaAtendimento())
				cMotivo:='Erro na Abertura de Atendimento'
				gravalog(aMailing[nI][len(aMailing[nI])-1],'Atendimento',cMotivo)
				IncProc('Processando '+cvaltochar(nI-1) +' de '+cvaltochar(nTotReg)+' / Incluindo '+cTabelas+'...')
				Loop							
			Endif
			//cFilant		:= cFilTemp

		IncProc('Processando '+cvaltochar(nI-1) +' de '+cvaltochar(nTotReg)+' / Incluindo '+cTabelas+'...')

		If lEnd
			_cMsg := 'Deseja realmente parar a importa��o?'
			
			If  MsgNoYes(_cMsg,'ATEN��O !')
				MsgAlert('Importa��o cancelada em '+cvaltochar(nI-1) +' de '+cvaltochar(nTotReg))
				Return
		    Else
			   lEnd := .F.
		    Endif
		Endif
	
	Next nI

	If lgravou
		FClose(nArq)
		MSGINFO('Favor verificar o Log da importa��o em'+CRLF+allTrim(cDir2) + cNome + ".TXT")
	Endif
	
Return
	
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  xcgc      �Autor  �Opvs(warleson)       � Data �  06/28/12   ���
�������������������������������������������������������������������������͹��
���Desc.     �  Valida CGC (CPF OU CNPJ)                  			      ���
���          �     adaptacao da funcao cgc()                              ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

static function xcgc(cCGC)
LOCAL nCnt,i,j,cDVC,nSum,nDIG,cDIG:="",cSavAlias,nSavRec,nSavOrd
cCGC	:= IIF(cCgc  == Nil,&(ReadVar()),cCGC)
//cVar  := If(ValType(cVar) = "U", ReadVar(), cVar)
If cCgc == "00000000000000"
		Return .T.
Endif

nTamanho:=Len(AllTrim(cCGC))

cDVC:=SubStr(cCGC,13,2)
cCGC:=SubStr(cCGC,1,12)

FOR j := 12 TO 13
	nCnt := 1
	nSum := 0
	FOR i := j TO 1 Step -1
		nCnt++
		IF nCnt>9;nCnt:=2;EndIf
		nSum += (Val(SubStr(cCGC,i,1))*nCnt)
	Next i
	nDIG := IIF((nSum%11)<2,0,11-(nSum%11))
	cCGC := cCGC+STR(nDIG,1)
	cDIG := cDIG+STR(nDIG,1)
Next j
lRet:=IIF(cDIG==cDVC,.T.,.F.)

IF !lRet
	IF nTamanho < 14
		cDVC:=SubStr(cCGC,10,2)
		cCPF:=SubStr(cCGC,1,9)
		cDIG:=""

		FOR j := 10 TO 11
			nCnt := j
			nSum := 0
			For i:= 1 To Len(Trim(cCPF))
				nSum += (Val(SubStr(cCPF,i,1))*nCnt)
				nCnt--
			Next i
			nDIG:=IIF((nSum%11)<2,0,11-(nSum%11))
			cCPF:=cCPF+STR(nDIG,1)
			cDIG:=cDIG+STR(nDIG,1)
		Next j

		IF cDIG != cDVC
//			HELP(" ",1,"CGC")
		Endif

		lRet:=IIF(cDIG==cDVC,.T.,.F.)
//		IF lRet;&cVar:=cCPF+Space(3);EndIF
	Else
//		HELP(" ",1,"CGC")
	EndIF
EndIF
Return lRet	

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �gravalog  �Autor  �Opvs(Warleson)      � Data �  06/28/12   ���
�������������������������������������������������������������������������͹��
���Desc.     �  Grava log de erro                                         ���
���          �     referente a importacao de Prospect                     ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

static function gravalog(nLin,cColuna,cMotivo)
	
Local cCabec 	:= ''
Local cCorpo 	:= ''
local cParam    := ''
local cMensagem := ''

cDir2			:=	substr(cDir,1,rat('\',cDir))

	IF !lGravou
		//cDir 	:= cGetFile(" | ",OemToAnsi("Selecione um Diret�rio para Gravar o Log da Importa��o"),,"C:\",.F.,nOR(GETF_LOCALHARD,GETF_RETDIRECTORY),.F.,.F.)
        //cDir	:= memoread(GetTempPath()+'dir_PROSPECT.txt') 

		cNome 	:= "PROSPECT_LOG_"+alltrim(cUserName)+'_'+DTOS(date())+'_'+alltrim(substr(time(),1,2)+substr(time(),4,2)+substr(time(),7,2))
		nArq 	:= fcreate(allTrim(cDir2) + cNome + ".TXT")

    	lGravou	:= .T.
		cCabec += CRLF
	    cCabec += 'DESCRICAO	: IMPORTACAO DE PROSPECT'+CRLF
		cCabec += 'MAQUINA	: '+GetComputerName()+CRLF
		CCabec += 'OPERADOR	: '+cUserName+CRLF
		cCabec += 'MODULO		: '+cModulo+CRLF
		cCabec += 'FUNCAO		: '+funname()+CRLF
		cCabec += 'DATA		: '+DTOC(date())+CRLF
		cCabec += 'HORA		: '+time()+CRLF
		cCabec += 'ARQUIVO		: '+alltrim(cDir2)+cNome+CRLF
		cCabec += '============================================================================='+CRLF+CRLF
    	cMensagem+=cCabec
    Endif
	
	cCorpo += '*_*_*_*ATENCAO*_*_*_*  Prospect Rejeitado'+CRLF
	cCorpo += 'LINHA	: '+cvaltochar(nLin)+CRLF
	cCorpo += 'COLUNA	: '+cColuna+CRLF
	cCorpo += 'MOTIVO	: '+cMotivo+CRLF
	cCorpo += '-----------------------------------------------------------------------------'+CRLF
	cMensagem+=cCorpo

	FWrite(nArq,Rtrim(cMensagem)+CRLF)

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GravaAtendimento �Autor  � Opvs(Warleson)� Data �06/29/12   ���
�������������������������������������������������������������������������͹��
���Desc.     �  Abertura de atendimento por Importa��o de Mailing         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function GravaAtendimento()

Local aAreaSX3	:= SX3->(GetArea())	  	// Salva a Area do SX3
Local aAreaADE	:= ADE->(GetArea())		// Salva a Area do ADE
Local aAreaADF	:= ADF->(GetArea())		// Salva a Area do ADF
Local aAreaSUQ	:= SUQ->(GetArea())		// Salva a Area do SUQ

Local aCabec	:= {}  					// Cabecalho da rotina automatica
Local aLinha	:= {}					// Linhas da rotina automatica
Local lRet		:= .F.

Local cFilial	:= xFilial("ADE")
Local cPathLog 	:= "\SYSTEM\"

Local cPedGar	:= aMailing[nI][1] 		// Pedido Gar
Local cCodCtto  := cCodCont				// Codigo do contato
Local cCodEntid	:= cCodPro				// Codigo do Prospect
Local cEntidade	:= "SUS"    			// Cadastro de Prospect
Local cIncidente:= ""			 		// Incidente
Local cCodGrupo	:= strzero(val(aMailing[nI][21]),2) // Grupo
Local cEmail	:= aMailing[nI][05]  
Local cTimeIni	:= ""
Local cCritic 	:= "5"  			    // Criticidade de assunto
Local cItem		:= "001"
Local cAcaSdk 	:= "" 					// Acao
Local cMemo 	:= "Abertura de atendimento por Importa��o de Mailing" //Observacao da Mensagem

//variaveis da agenda do operador
local cCodCont	 
local cChave    
local cCodOper  
local cRotina  
local cCodLig 
local dDataR  
local cTimeR 
local cLista   

Private lMsErroAuto := .F.

//Private ADE_CODIGO	:= GETNUMADE()
//Private ADE_INCIDE	:= ""
//Private ADE_STATUS	:= "1"
//Private ADE_STRREC	:= ""

cIncidente+= 'A��o: '+aMailing[nI][02]+' -- Certificado: '+aMailing[nI][12]+CRLF
cIncidente+= 'Data Emiss�o: '+aMailing[nI][09]+' -- Data Expira��o: '+aMailing[nI][10]+' -- Tempo: '+aMailing[nI][11]+CRLF
cIncidente+= 'AR: '+aMailing[nI][15]+' -- Produto: '+aMailing[nI][16]+CRLF
cIncidente+= aMailing[nI][13]+' -- '+aMailing[nI][14]+' -- AC: '+aMailing[nI][17]+CRLF

ADE_INCIDE	:= cIncidente
	
	dbselectarea('SB1')
	dbsetorder(1)
	dbseek(xfilial('SB1')+cCodSB1)

	//Posiciona no contato correto, pois estava dando erro no existcpo  -opvs(warleson) 29/06/2009
	dbselectarea('SU5')
	dbsetorder(1)
	dbseek(xfilial('SU5')+Alltrim(cCodCtto))
		
	aAdd(aCabec,	{"ADE_CODCON" 	,Alltrim(cCodCtto)						,Nil})
	aAdd(aCabec,	{"ADE_ENTIDA" 	,Alltrim(cEntidade)   						,Nil})
	aAdd(aCabec,	{"ADE_CHAVE" 	,AllTrim(cCodEntid)+alltrim(cLojaPad)				,Nil})	
	aAdd(aCabec,	{"ADE_INCIDE" 	,cIncidente							,Nil})
	aAdd(aCabec,	{"ADE_STATUS" 	,"1"								,Nil})
	aAdd(aCabec,	{"ADE_OPERAD" 	,""								,Nil})
	aAdd(aCabec,	{"ADE_GRUPO" 	,cCodGrupo							,Nil})
	aAdd(aCabec,	{"ADE_HORA" 	,TIME()				    				,Nil})
	aAdd(aCabec,	{"ADE_SEVCOD" 	,cCritic     							,Nil})
	aAdd(aCabec,	{"ADE_OPERAC" 	,"2"								,Nil}) //Ativo
	aAdd(aCabec,	{"ADE_ASSUNT" 	,cAssSdk							,Nil})
	aAdd(aCabec,	{"ADE_TO" 		,cEmail							,Nil}) //Email
	aAdd(aCabec,	{"ADE_SEVCOD" 	,'2'								,Nil})
	aAdd(aCabec,	{"ADE_TIPO" 	,'000001'							,Nil}) //Telefone
	aAdd(aCabec,	{"ADE_DDDRET" 	,cDDD								,Nil})
	aAdd(aCabec,	{"ADE_TELRET" 	,cTel								,Nil})
	aAdd(aCabec,	{"ADE_CODSB1" 	,cCodSB1							,Nil})

	If !Empty(cPedGar) //Limpar
		aAdd(aCabec,	{"ADE_PEDGAR" 	,cPedGar							,Nil})
		aAdd(aCabec,	{"ADE_XVALID" 	,aMailing[nI][11]					,Nil}) //Validade Ex.: 12 meses
		aAdd(aCabec,	{"ADE_XDTEXP" 	,cToD(aMailing[nI][10])				,Nil}) //Data de expiracao
	Endif 

	//�������������������������������������Ŀ
	//�	Monta os itens do chamado com a   	|
	//|primeira linha do chamado original   �
	//���������������������������������������
	aAdd(alinha,	{"ADF_FILIAL" 	,cFilial										,Nil})
	aAdd(aLinha,	{"ADF_ITEM" 	,cItem											,Nil})
	aAdd(aLinha,	{"ADF_CODSU9" 	,cOcoSdk			        					,Nil})
	If !empty(cAcaSdk)
		aAdd(aLinha,	{"ADF_CODSUQ" 	,cAcaSdk				        			,Nil})
	EndIF
	aAdd(aLinha,	{"ADF_OBS" 		,cMemo											,Nil})
	aAdd(aLinha,	{"ADF_DATA" 	,Date()											,Nil})
	aAdd(aLinha,	{"ADF_HORA" 	,cTimeIni										,Nil})
	aAdd(aLinha,	{"ADF_HORAF" 	,TIME()											,Nil})
	  
	Fillgetdados(3,"ADF",nil,nil,nil,nil,nil,nil,nil,nil,nil,.T.)
	
	MSExecAuto({|x,y,z| TMKA503A(x,y,z)},aCabec,{aLinha},3)

	If lMsErroAuto//Exibe erro na execucao do programa
		cPathLog := "\SYSTEM\"
		Mostraerro() //cPathLog,"SDK_LOG_"+StrTran(Time(),":","")+".TXT")
		lRet:= .F.
	Else
		ConfirmSx8()
		conout("Chamado gerado com sucesso "+ADE->ADE_CODIGO)
		lRet:= .T.

		DbSelectArea("ADE")
		DbSetOrder(1)
		If MsSeek(xFilial("ADE")+ADE->ADE_CODIGO)
			BEGIN TRANSACTION
				RecLock("ADE", .F.)
				//REPLACE ADE_PEDGAR WITH cPedGar // limpar
				//REPLACE ADE_INCIDE WITH cIncidente
				MSMM(,TamSx3("ADE_INCIDE")[1],,cIncidente,1,,,"ADE","ADE_CODINC")
				MsUnlock()
			END TRANSACTION
		EndIf

		cCodCont	:= ADE->ADE_CODCON
		cEntidade 	:= ADE->ADE_ENTIDA
		cChave    	:= ADE->ADE_CHAVE
		cCodOper  	:= ADE->ADE_OPERAD
		cRotina 	:= '5'
		cCodLig		:= ADE->ADE_CODIGO
		dDataR 		:= Date()
		cTimeR		:= '06:00'//Substr(time(),1,5)
		cLista    	:= ''
		
		/*
		if nI>2
			if !(aMailing[nI-1][10]==aMailing[nI][10]) //Identificado Nova Lista
			endif
		endif
		*/
		U_GRAVASU4(cCodCont,cEntidade,cChave,cCodOper,cRotina,cCodLig,dDataR,cTimeR,cLista)
	
	Endif		

RestArea(aAreaSX3)
RestArea(aAreaADE)
RestArea(aAreaADF)
RestArea(aAreaSUQ)

Return lRet 

/*                                                                     
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 �TkGrvSU4   � Autor �Vendas Clientes       � Data �05/04/01  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Grava uma nova ligacao para o operador                      ���
�������������������������������������������������������������������������Ĵ��
���Uso		 �TMKA271											          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/                       
User Function GRAVASU4(cCodCont,cEntidade,cChave,cCodOper,cRotina,cCodLig,dDataR,cTimeR,cLista)

Local aArea			:= GetArea()
Local lRet	 		:= .F.							// Retorno da funcao
Local cTipo			:= "1"							// Tipo da Lista de acordo com o campo U4_TIPO = 1=Marketing,2=Cobranca,3=Vendas
Local nSaveSx8 		:= 0							// Funcao de numeracao
Local lNovo			:= .T.							// Indica se sera gerada uma nova lista de contato pendente ou alteradad a lista ja gravada
Local _cItem		:= ""
Default cLista		:= ""							// Codigo da Lista
		
	if empty(cCodOper)
		cCodOper :=	_cOperad
	Endif


	//�����������������������������������������������������������Ŀ
	//�busca o registro valido na SU4 para                        �
	//�alteracao. Caso nao exista um registro valido, um novo sera�
	//�criado                                                     �
	//�������������������������������������������������������������

	DbSelectArea("SU4")
	DBORDERNICKNAME("CABECLISTA") // Filial+Operador+Desc_da_lista
	If !DbSeek( xFilial( "SU4" ) +cCodOper+ "Data Expira��o: " + aMailing[nI][10] )
		lNovo		:=	.T.
		nSaveSx8 	:= GetSX8Len()  // Funcao de numeracao
		cLista 	 	:= GetSXENum("SU4","U4_LISTA")
	Else
		cLista	:= SU4->U4_LISTA 
		// Ajusta a opcao para alteracao
		lNovo	:=	.F.	
		DbSelectArea("SU6")
		DbSetOrder(1)
		DbSeek(xFilial("SU6")+cLista)
	Endif
    
	if lNovo                                
		RecLock("SU4",lNovo)	
		Replace U4_FILIAL   With xFilial("SU4")
		Replace U4_LISTA    With cLista          
		Replace U4_DESC		With "Data Expira��o: " + aMailing[nI][10] //cCodLig
		Replace U4_DATA		With dData
		Replace U4_FORMA	With "5"  		// 1=Voz 2=Fax 3=Cross Posting 4=mala Direta 5=Pendencia 6=WebSite
		Replace U4_TELE		With cRotina
		Replace U4_OPERAD	With cCodOper
		Replace U4_TIPOTEL	With "4" 	// 1=Residencial 2=Fax 3=Celular 4=Comercial 1 5=Comercial 2
		Replace U4_CODLIG   With cCodLig  	// Codigo do atendimento
		Replace U4_STATUS   With "1"      	// Status da Lista 1=Pendente 2=Encerrada      
		Replace U4_TIPO		With cTipo		// Tipo da Lista 1=Marketing 2=Vendas 3=Cobranca
		Replace U4_HORA1    With Time()
		Replace U4_XDTVENC	With cTod(aMailing[nI][10])-nDias
		Replace U4_XGRUPO	With aMailing[nI][21]
		MsUnlock()
	
		DbSelectarea("SU4")
		While (GetSx8Len() > nSaveSx8)
			ConfirmSX8()
		End	
	Else
		If (SU4->U4_STATUS =='2')
			RecLock("SU4",lNovo)	
			Replace U4_STATUS   With "3"      	// Status da Lista 1=Pendente 2=Encerrada 3=em andamento      
			MsUnlock()
		Endif
	Endif
    SU4->(FkCommit())
	
			
	//��������������������������������������Ŀ
	//�Grava uma nova ligacao para o contato.�
	//����������������������������������������
	
	//obrigatoriamente tenho que incluir uma liga��o para cada atendimento em aberto. Neste caso NAO estou agrupando varios atendimento para uma liga��o. Opvs(warleson)-  19/07/2012
   
	lNovo:= .T.
	
	If lNovo
		nSaveSx8:= GetSX8Len()  // Funcao de numeracao
		_cItem 	:= GetSXENum("SU6","U6_CODIGO")
	EndIf
    
	if lNovo
	
		RecLock("SU6",lNovo)
		Replace U6_FILIAL  With xFilial("SU6")	
		Replace U6_LISTA   With	SU4->U4_LISTA
	
		//������������������������������������������������������������������Ŀ
		//�se nao for inclusao o codigo do registro nao precisa ser alterado.�
		//��������������������������������������������������������������������
		Replace U6_CODIGO  With	_cItem
		If SU6->(FieldPos("U6_DTBASE")) > 0
			Replace U6_DTBASE  With	dDataBase
		EndIf

		Replace U6_FILENT  With	xFilial(cEntidade)
		Replace U6_ENTIDA  With	cEntidade
		Replace U6_CODENT  With	cChave
		Replace U6_ORIGEM  With	"3"				//1=Lista 2=Manual 3=Atendimento
		Replace U6_CONTATO With	cCodCont
		Replace U6_DATA    With	dData
		Replace U6_HRINI   With	cTimeR
		Replace U6_HRFIM   With	"23:59"
		Replace U6_STATUS  With	"1"    			//1=Nao Enviado 2=Enviado
		Replace U6_CODLIG  With	cCodLig
		MsUnlock()
	
		DbSelectarea("SU6")
		While (GetSx8Len() > nSaveSx8)
			ConfirmSX8()
		End	
	Endif

	SU6->(FkCommit())
	
	lRet := .T.

RestArea(aArea)
Return(lRet)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �TkExistSU4 � Autor �Vendas Clientes       � Data � 07/08/07 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Verifica se ha algum registro valido no SU4 para a ligacao  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � Tk271Header(ExpC1,ExpC2)                                   ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1 = Codigo da ligacao                                  ���
���          � ExpC2 = Referencia para retorno da lista                   ���
���          � ExpC3 = Rotina de atendimento                              ���
�������������������������������������������������������������������������Ĵ��
���Uso		 � TMKAXFUNB                                                  ���
�������������������������������������������������������������������������Ĵ��
���Analista  � Data/Bops/Ver �Manutencao Efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �        �      �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function TkExistSU4(cCodLig,cRet, cRotina)

Local aArea		:= GetArea()				// Tabela, indice e recno atuais
Local aAreaSU4	:= SU4->(GetArea())		// Tabela, indice e recno atuais da tabela SU4
Local cFilSU4	:= xFilial("SU4")			// Codigo de filial para a tabela SU4
Local cQuery	:= ""						// Query para selecao de registros da SU4
Local nQtdReg	:= 0						// Quantidade de registros validos encontrados
Local cAlias	:= "SU4"					// Alias utilizado para manipular a SU4
Local lRet		:= .F.						// Retorno da funcao (.T. registro encontrado)
Local cLista	:= ""						// Codigo da lista no SU4

#IFDEF TOP
	If TcSrvType() <> "AS/400"
		
		cAlias := "SU4T"
		
		cQuery += " SELECT U4_LISTA "
		cQuery += " FROM " + RetSqlName("SU4")
		cQuery += " WHERE U4_CODLIG = '" + cCodLig + "'"
		cQuery += " AND U4_FILIAL = '" + cFilSU4 + "' "
		cQuery += " AND U4_TELE = '" + cRotina + "' "
		cQuery += " AND U4_STATUS = '1' AND D_E_L_E_T_ = '' "
		
		cQuery := ChangeQuery(cQuery)
		
		If Select(cAlias) > 0
			(cAlias)->(DbCloseArea())
		EndIf
		
		DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAlias, .F., .T.)
		(cAlias)->(DbGoTop())
		
		While !(cAlias)->(Eof())
			nQtdReg ++
			cLista := (cAlias)->U4_LISTA
			(cAlias)->(DbSkip())
		End
		
		(cAlias)->(DbCloseArea())
		
	Else
#ENDIF

	DbSelectArea(cAlias)
	DbSetOrder(4)//U4_FILIAL+U4_CODLIG
	DbSeek( cFilSU4 + cCodLig )
	
	While !(cAlias)->(Eof())	 .AND.;
		 (cAlias)->U4_FILIAL == cFilSU4 .AND.;
		 (cAlias)->U4_CODLIG == cCodLig 

		 If (cAlias)->U4_STATUS == "1" .AND. (cAlias)->U4_TELE == cRotina
		 	nQtdReg ++
			cLista := (cAlias)->U4_LISTA
		 EndIf

		 (cAlias)->(DbSkip())
	End

#IFDEF TOP
	EndIf
#ENDIF

//������������������������������������������������������������Ŀ
//�Se algum registro valido foi encontrado, sera utilizado para�
//�regravacao na SU4.                                          �
//��������������������������������������������������������������
If nQtdReg > 0
	lRet := .T.
	cRet := cLista
EndIf

RestArea(aAreaSU4)
RestArea(aArea)

Return lRet