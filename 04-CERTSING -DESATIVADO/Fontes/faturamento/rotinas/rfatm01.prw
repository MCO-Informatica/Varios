#INCLUDE "rwmake.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RFATM01   � Autor �Cristian Gutierrez  � Data �  18/12/06   ���
�������������������������������������������������������������������������͹��
���Descricao �Rotina para importacao de arquivo texto exportado pelo BPAG ���
���          �Cadastro de Clientes (Sa1)                                  ���
�������������������������������������������������������������������������͹��
���Uso       � Exclusivo para o cliente Certisign                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function RFATM01
//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
Private oLeTxt
//���������������������������������������������������������������������Ŀ
//� Montagem da tela de processamento.                                  �
//�����������������������������������������������������������������������
@ 200,1 TO 380,380 DIALOG oLeTxt TITLE OemToAnsi("Leitura de Arquivo Texto")
@ 02,10 TO 080,190
@ 10,018 Say " Este programa ira ler o conteudo de um arquivo texto, conforme"
@ 18,018 Say " os parametros definidos pelo usuario, com os registros do arquivo"
@ 26,018 Say " SA1 - Cadastro de Clientes                                    "

@ 70,128 BMPBUTTON TYPE 01 ACTION OkLeTxt()
@ 70,158 BMPBUTTON TYPE 02 ACTION Close(oLeTxt)

Activate Dialog oLeTxt Centered

Return
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � OKLETXT  � Autor �Cristian Gutierrez  � Data �  18/12/06   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao chamada pelo botao OK na tela inicial de processamen���
���          � to. Executa a leitura do arquivo texto.                    ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function OkLeTxt
//���������������������������������������������������������������������Ŀ
//� Abertura do arquivo texto                                           �
//�����������������������������������������������������������������������
Local cType 		:= "Arquivo Texto  | *.TXT"
Private cArqTxt 	:= cGetFile(cType, OemToAnsi("Selecione o arquivo a ser importado"),0,,.T.,GETF_LOCALHARD+GETF_LOCALFLOPPY)
Private nHdl    	:= fOpen(cArqTxt,68)
//���������������������������������������������������������������������Ŀ
//�Definicao do final de linha                                          �
//�����������������������������������������������������������������������
Private cEOL    := "CHR(13)+CHR(10)"
If Empty(cEOL)
	cEOL := CHR(13)+CHR(10)
Else
	cEOL := Trim(cEOL)
	cEOL := &cEOL
Endif
//���������������������������������������������������������������������Ŀ
//�Verifica se o arquivo foi aberto corretamente                        �
//�����������������������������������������������������������������������
If nHdl == -1
	Aviso("Importa��o de Clientes","O arquivo de nome "+cArqTxt+" nao pode ser aberto! Verifique.",{"Ok"})
	Return
Endif
//���������������������������������������������������������������������Ŀ
//� Inicializa a regua de processamento                                 �
//�����������������������������������������������������������������������
Processa({|| RunCont() },"Processando...")

Return
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � RUNCONT  � Autor �Cristian Gutierrez  � Data �  18/12/06   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela PROCESSA.  A funcao PROCESSA  ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function RunCont
//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
Local nTamFile	:= fSeek(nHdl,0,2)
Local nTamLin	:= 536 + Len(cEOL) //Conforme lay-out
Local cBuffer	:= Space(nTamLin)
Local nBtLidos	:= 0
Local lValid	:= .T.
Local cCgc		:= ""
Local cCod		:= ""
Local cLoja		:= ""
Local cEst		:= ""
Local cInscr	:= ""
Local cPessoa	:= ""
Local cEste		:= ""
Local nQtdeReg	:= nTamFile - (nTamLin - Len(cEOL))
Local nLinha	:= 0
Local lRet		:= .T.
Local cQuery	:= ""
Local	cDDD := ' ' 
Local	cTel := ' ' 

//�����������������������������������������������������������������ͻ
//� Lay-Out do arquivo Texto gerado:                                �
//�����������������������������������������������������������������͹
//� Verificar detalhamento do layout no documento de especificacao  �
//� de personalizacoes ER0301-006 Importacao de Clientes            �
//�����������������������������������������������������������������ͼ
//���������������������������������������������������������������������Ŀ
//� Posiciona no inicio do arquivo e le primeira linha                  �
//�����������������������������������������������������������������������
fSeek(nHdl,0,0)
nBtLidos := fRead(nHdl,@cBuffer,nTamLin) // Leitura da primeira linha do arquivo texto

ProcRegua(nQtdeReg) // Numero de registros a processar

While nBtLidos >= nTamLin
	//���������������������������������������������������������������������Ŀ
	//� Incrementa a regua                                                  �
	//�����������������������������������������������������������������������
	IncProc()
	nLinha ++
	//���������������������������������������������������������������������Ŀ
	//�Alimenta variaveis para validacao do conteudo                        �
	//�����������������������������������������������������������������������
	cCgc		:= AllTrim(Substr(cBuffer,256,014))
	cEst		:= AllTrim(Substr(cBuffer,098,002))
	cInscr	:= AllTrim(Substr(cBuffer,271,018))
	cPessoa	:= AllTrim(Substr(cBuffer,309,001))
	cEste		:= AllTrim(Substr(cBuffer,534,002))
	//������������������������������������������������������������������������Ŀ
	//�Realiza validacoes no registro a ser importado (Pessoa Fisica/Juridica) |
	//��������������������������������������������������������������������������
	If !(cPessoa $ "P#J")
		lValid	:= .F.
		Aviso("Pessoa Fisica/Juridica","Conte�do inv�lido no campo. Verifique!",{"Ok"},,"Linha: " + Str(nLinha))
		
	EndIf
	//������������������������������������������������������������������������Ŀ
	//�Realiza validacoes no registro a ser importado (CNPJ/CPF)					|
	//��������������������������������������������������������������������������
	If lValid
		lRet := CGC(cCgc)  .And. A030CGC(cPessoa, cCgc)
		If !lRet
			Aviso("Cnpj/Cpf Inv�lido","O cnpj/cpf informado n�o � v�lido.Verifique!",{"Ok"},,"Linha: " + Str(nLinha))
			lValid := .F.
		EndIf
	EndIf
	//������������������������������������������������������������������������Ŀ
	//�Realiza validacoes no registro a ser importado (Estado) 						|
	//��������������������������������������������������������������������������
	If lValid
		lRet := ExistCpo("SX5","12" + cEst) //estado
		If !lRet
			Aviso("Unidade Federativa","O estado informado n�o � v�lido.Verifique!",{"Ok"},,"Linha: " + Str(nLinha))
			lValid := .F.
		EndIf
		
		lRet := ExistCpo("SX5","12" + cEste) //estado de entrega
		If !lRet
			Aviso("Unidade Federativa","O estado de entrega informado n�o � v�lido.Verifique!",{"Ok"},,"Linha: " + Str(nLinha))
			lValid := .F.
		EndIf
		//������������������������������������������������������������������������Ŀ
		//�Verifica se o estado de faturamento eh o mesmo da entrega					|
		//��������������������������������������������������������������������������
		If cEst <> eEste
			Aviso("Unidade Federativa","O estado de entrega � diferente do estado de faturamento.Verifique!",{"Ok"},,"Linha: " + Str(nLinha))
			lValid := .F.
		EndIf
	EndIf
	//������������������������������������������������������������������������Ŀ
	//�Realiza validacoes no registro a ser importado (Inscricao estadual)  	|
	//��������������������������������������������������������������������������
	If lValid
		lRet := IE(cInscr,cEst)
		If !lRet
			Aviso("Inscri��o Estadual","A inscri��o estadual n�o � v�lida.Verifique!",{"Ok"},,"Linha: " + Str(nLinha))
			lValid := .F.
		EndIf
	EndIf
	//���������������������������������������������������������������������Ŀ
	//� Verifica se o cliente ja foi cadastrado anteriormente               �
	//�����������������������������������������������������������������������
	If lValid
		dbSelectArea("SA1")
		dbSetOrder(3)
		If dbSeek(xFilial("SA1") + U_CSFMTSA1(cCgc))
			Aviso("CNPJ/CPF j� cadastrado","O CNPJ/CPF j� foi cadastrado anteriormente.Verifique!",{"Ok"},,"Linha: " + Str(nLinha))
			lValid := .F.
		EndIf
	EndIf
	//���������������������������������������������������������������������Ŀ
	//�Caso tenha passado nas validacoes gera novo codigo de cliente        �
	//�����������������������������������������������������������������������
	If lValid .and. cPessoa == "J"

		If Select("TMP") > 0
			dbSelectArea("TMP")
			dbCloseArea()
		EndIf

		//����������������������������������������������������������������������������������Ŀ
		//�Montagem da query para geracao do temporario com os valores a serem impressos     |
		//������������������������������������������������������������������������������������
		
BeginSql Alias "TMP"
%noparser%
SELECT A1_COD,	MAX(A1_LOJA) AS A1_LOJA
FROM %Table:SA1% SA1 
WHERE SUBSTR(A1_CGC,1,8) = %Exp:Substr(cCgc,1,8)%
AND SA1.%NotDel%
GROUP BY A1_COD
EndSql

		//����������������������������������������������������������������������������������Ŀ
		//�Geracao do novo codigo                                                            |
		//������������������������������������������������������������������������������������
		dbSelectArea("TMP")
		If !Empty(TMP->LOJA)
			cCod	:= TMP->A1_COD
			cLoja	:= Soma1(TMP->A1_LOJA)
		Else
			cCod	:= GetSXENum("SA1")
			cLoja := "01"
		EndIf
	Else
		cCod	:= GetSXENum("SA1")
		cLoja := "01"
	EndIf
	//���������������������������������������������������������������������Ŀ
	//� Grava os campos obtendo os valores da linha lida do arquivo texto.  �
	//�����������������������������������������������������������������������

	If lValid

		If Len(AllTrim(Substr(cBuffer,141,013))) > 8
			cDDD := AllTrim(Substr(cBuffer,141,(Len(AllTrim(Substr(cBuffer,141,013)))-8)))
			cTel := AllTrim(Substr(cBuffer,141+(Len(AllTrim(Substr(cBuffer,141,013)))-8),008))
		Else
			cTel := AllTrim(Substr(cBuffer,141,013))
		End If
		
		aMata030:={,;
		{"A1_COD"		,cCod													, Nil},; // Codigo do cliente
		{"A1_LOJA"		,cLoja												, Nil},; // Loja do cliente
		{"A1_NOME"		,Upper(AllTrim(Substr(cBuffer,001,040)))	, Nil},; // Nome
		{"A1_END"		,Upper(AllTrim(Substr(cBuffer,041,040)))	, Nil},; // Endereco faturamento
		{"A1_MUN"		,Upper(AllTrim(Substr(cBuffer,082,015)))	, Nil},; // Munic�pio Faturamento)
		{"A1_EST"		,Upper(cEst)										, Nil},; // Estado Faturamento
		{"A1_BAIRRO"	,Upper(AllTrim(Substr(cBuffer,101,030)))	, Nil},; // Bairro Faturamento
		{"A1_CEP"		,AllTrim(Substr(cBuffer,132,040))			, Nil},; // CEP Faturamento
		{"A1_EMAIL"		,Upper(AllTrim(Substr(cBuffer,155,100)))	, Nil},; // E-mail
		{"A1_DDD"		,cDDD													, Nil},; // DDD Fatuamento
		{"A1_TEL"		,cTel 												, Nil},; // Telefone Faturamento
		{"A1_CGC"		,cCgc													, Nil},; // Cnpj / Cpf
		{"A1_INSCR"		,cInscr												, Nil},; // Inscri��o Estadual
		{"A1_INSCRM"	,AllTrim(Substr(cBuffer,290,018))			, Nil},; // Inscri��o Municipal
		{"A1_PESSOA"	,Upper(cPessoa)									, Nil},; // F�sica / Jur�dica
		{"A1_PFISICA"	,AllTrim(Substr(cBuffer,311,018)	)			, Nil},; // Rg / C�dula Estrangeiro
		{"A1_CONTATO"	,Upper(AllTrim(Substr(cBuffer,330,015)))	, Nil},; // Contato no cliente
		{"A1_XEMAIL"	,Upper(AllTrim(Substr(cBuffer,346,100)))	, Nil},; // E-mail (Contato)
		{"A1_ENDENT"	,Upper(AllTrim(Substr(cBuffer,447,040)))	, Nil},; // Endere�o Entrega
		{"A1_BAIRROE"	,Upper(AllTrim(Substr(cBuffer,488,020)))	, Nil},; // Bairro Entrega
		{"A1_CEPE"		,AllTrim(Substr(cBuffer,509,008))			, Nil},; // Cep Entrega
		{"A1_MUNE"		,Upper(AllTrim(Substr(cBuffer,518,015)))	, Nil},; // Munic�pio Entrega
		{"A1_ESTE"		,Upper(cEste)										, Nil},; // Estado de Entrega
		{"A1_TIPO"		,'F'													, Nil},; // Tipo do cliente 
		{"A1_NATUREZ"	,'     '     										, Nil},; // Natureza a ser utilizada pelo cliente no financeiro 
		{"A1_CONTA"		,'110301001' 										, Nil},; // Conta cont�bil 
		{"A1_RECINSS"	,'N'          										, Nil},; // Recolhe Inss 
		{"A1_RECCOFI"	,'S'         										, Nil},; // Recolhe Cofins 
		{"A1_RECCSLL"	,'S'          										, Nil},; // Recolhe Csll 
		{"A1_RECPIS"	,'S'         										, Nil},; // Recolhe Pis 
		{"A1_INCISS"	,'S'         										, Nil},; // Iss no pre�o 
		{"A1_RECISS" 	,'2'         										, Nil},; // Recolhe Iss? 
		{"A1_RISCO"		,'A'         										, Nil},; // Risco do cliente 
		{"A1_CLASSE"	,'A'         										, Nil},; // Classe de cr�dito 
		{"A1_MSBLQL"	,'1'         										, Nil}}  // Registro Bloqueado S/N
		
		lMsErroAuto := .F.
		MsExecAuto({|x,y| MATA030(x,y)},aMata030,3)
		
		If lMsErroAuto
			MostraErro('SYSTEM','ErroImp.LOG')
		End If
		/*
		dbSelectArea(cString)
		RecLock(cString,.T.)
		
		SA1->??_FILIAL := Substr(cBuffer,01,02)
		
		MSUnLock()
		*/
		//���������������������������������������������������������������������Ŀ
		//� Leitura da proxima linha do arquivo texto.                          �
		//�����������������������������������������������������������������������
	End If
	
	nBtLidos := fRead(nHdl,@cBuffer,nTamLin) // Leitura da proxima linha do arquivo texto
	
	dbSkip()
EndDo

//���������������������������������������������������������������������Ŀ
//� O arquivo texto deve ser fechado, bem como o dialogo criado na fun- �
//� cao anterior.                                                       �
//�����������������������������������������������������������������������
fClose(nHdl)
Close(oLeTxt)

Return
