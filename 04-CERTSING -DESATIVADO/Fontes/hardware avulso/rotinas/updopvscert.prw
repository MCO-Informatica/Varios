#INCLUDE "protheus.ch"
                      
/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun�ao    �UPDOPVSCERT� Autor � Darcio Ribeiro Sporl  � Data � 28.06.11 ���
��������������������������������������������������������������������������Ĵ��
���Descri�ao � Atualizacao dos dicionarios Certisign       				   ���
��������������������������������������������������������������������������Ĵ��
��� Uso      � Opvs X Certisign					                           ���
��������������������������������������������������������������������������Ĵ��
���Parametros� Nenhum                                                      ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/
User Function UPDOPVSCERT()
//����������������������������������������������������������������������������Ŀ
//� Inicializa variaveis                                                       |
//������������������������������������������������������������������������������
Local nOpca			:= 0
Local aSays			:= {}, aButtons := {}   
Local aRecnoSM0		:= {}  
Local lOpen			:= .F.  
Private cMessage
Private aArqUpd		:= {}
Private aREOPEN		:= {} 
Private oMainWnd 
Private cCadastro	:= "Compatibilizador de Dicion�rios x Banco de dados"
Private cCompat		:= "UPDOPVSCERT"
Private cFnc		:= "Atualiza��o Certisign"
Private cRef		:= "Compatibiliza��o de Dicion�rio Hardware Avulso"
Set Dele On      
//����������������������������������������������������������������������������Ŀ
//� Monta texto para janela de processamento                                   �
//������������������������������������������������������������������������������
aadd(aSays,"Esta rotina ir� efetuar a compatibiliza��o dos dicion�rios e banco de dados.")
aadd(aSays,cFnc)
aadd(aSays,"   Refer�ncia: " + cRef)
aadd(aSays," ")
aadd(aSays,"Aten��o: efetuar backup dos dicion�rios e do banco de dados previamente ")
//����������������������������������������������������������������������������Ŀ
//� Monta botoes para janela de processamento                                  �
//������������������������������������������������������������������������������
aadd(aButtons, { 1,.T.,{|| nOpca := 1, FechaBatch() }} )
aadd(aButtons, { 2,.T.,{|| nOpca := 0, FechaBatch() }} )
//����������������������������������������������������������������������������Ŀ
//� Exibe janela de processamento                                              �
//������������������������������������������������������������������������������
FormBatch( cCadastro, aSays, aButtons,, 230 )
//����������������������������������������������������������������������������Ŀ
//� Processa calculo                                                           �
//������������������������������������������������������������������������������
If  nOpca == 1
	If  Aviso("Compatibilizador", "Deseja confirmar o processamento do compatibilizador ?", {"Sim","N�o"}) == 1
          Processa({||UpdEmp(aRecnoSM0,lOpen)},"Processando","Aguarde, processando prepara��o dos arquivos",.F.)
    Endif
Endif
//����������������������������������������������������������������������������Ŀ
//� Fim do programa                                                            |
//������������������������������������������������������������������������������
Return()

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �ProcATU   � Autor �                       � Data �  /  /    ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Funcao de processamento da gravacao dos arquivos           ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Baseado na funcao criada por Eduardo Riera em 01/02/2002   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Function ProcATU(lEnd,aRecnoSM0,lOpen)
Local cTexto    	:= ""
Local cFile     	:= ""
Local cMask     	:= "Arquivos Texto (*.TXT) |*.txt|"
Local nRecno    	:= 0
Local nI        	:= 0
Local nX        	:= 0

ProcRegua(1)
IncProc("Verificando integridade dos dicion�rios....")

	If lOpen   
		lSel:=.F.
		For nI := 1 To Len(aRecnoSM0)
			if ! aRecnoSM0[nI,1]
				loop
			Endif 
			lSel:=.T.
			
			SM0->(dbGoto(aRecnoSM0[nI,2]))
			RpcSetType(2)
			RpcSetEnv(SM0->M0_CODIGO, SM0->M0_CODFIL)
			lMsFinalAuto := .F.
			cTexto += Replicate("-",128)+CHR(13)+CHR(10)
			cTexto += "Empresa : "+SM0->M0_CODIGO+SM0->M0_NOME+CHR(13)+CHR(10)

			ProcRegua(8)

			Begin Transaction
			
				//����������������������������������Ŀ
				//�Atualiza o dicionario de arquivos.�
				//������������������������������������
				IncProc("Analisando Dicionario de Arquivos...")
//				cTexto += GeraSX2()
				//�������������������������������Ŀ
				//�Atualiza o dicionario de dados.�
				//���������������������������������
				IncProc("Analisando Dicionario de Dados...")
//				cTexto += GeraSX3()
				//�������������������������������Ŀ
				//�Atualiza os parametros.        �
				//���������������������������������
				IncProc("Analisando Param�tros...")
//		 		cTexto += GeraSX6()
				//��������������������Ŀ
				//�Atualiza os indices.�
				//����������������������
				IncProc("Analisando arquivos de �ndices. "+"Empresa : "+SM0->M0_CODIGO+" Filial : "+SM0->M0_CODFIL+"-"+SM0->M0_NOME)
//				cTexto += GeraSIX()
				//����������������������������Ŀ
				//�Atualiza os Consulta padrao.�
				//������������������������������
				IncProc("Analisando Consulta Padr�o...")
//	 			cTexto += GeraSXB()
	 			//����������������������������Ŀ
				//�Inclui tabela padrao.       �
				//������������������������������
				IncProc("Analisando Tabela Padr�o...")
	 			cTexto += IncSX5()
			
			End Transaction
	
			__SetX31Mode(.F.)
			For nX := 1 To Len(aArqUpd)
				IncProc("Atualizando estruturas. Aguarde... ["+aArqUpd[nx]+"]")
				If Select(aArqUpd[nx])>0
					dbSelecTArea(aArqUpd[nx])
					dbCloseArea()
				EndIf
				X31UpdTable(aArqUpd[nx])
				If __GetX31Error()                                                    	
					Alert(__GetX31Trace())
					Aviso("Atencao!","Ocorreu um erro desconhecido durante a atualizacao da tabela : "+ aArqUpd[nx] + ". Verifique a integridade do dicionario e da tabela.",{"Continuar"},2)
					cTexto += "Ocorreu um erro desconhecido durante a atualizacao da estrutura da tabela : "+aArqUpd[nx] +CHR(13)+CHR(10)
				EndIf
				dbSelectArea(aArqUpd[nx])
			Next nX		

			RpcClearEnv()
			If !( lOpen := MyOpenSm0Ex() )
				Exit
		 	EndIf
		Next nI
		
		If lOpen
			
			cTexto := "Log da atualizacao " + CHR(13) + CHR(10) + cTexto
			
				If !lSel 
					cTexto+= "N�o foram selecionadas nenhuma empresa para Atualiza��o"
				Endif
			__cFileLog := MemoWrite(Criatrab(,.f.) + ".LOG", cTexto)
			
			DEFINE FONT oFont NAME "Mono AS" SIZE 5,12
			DEFINE MSDIALOG oDlg TITLE "Atualizador [" + cCompat + "] - Atualizacao concluida." From 3,0 to 340,417 PIXEL
				@ 5,5 GET oMemo  VAR cTexto MEMO SIZE 200,145 OF oDlg PIXEL
				oMemo:bRClicked := {||AllwaysTrue()}
				oMemo:oFont:=oFont
				DEFINE SBUTTON  FROM 153,175 TYPE 1 ACTION oDlg:End() ENABLE OF oDlg PIXEL //Apaga
				DEFINE SBUTTON  FROM 153,145 TYPE 13 ACTION (cFile:=cGetFile(cMask,""),If(cFile="",.t.,MemoWrite(cFile,cTexto))) ENABLE OF oDlg PIXEL //Salva e Apaga //"Salvar Como..."
			ACTIVATE MSDIALOG oDlg CENTER
		EndIf
	EndIf
Return(Nil)

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �MyOpenSM0Ex� Autor �Sergio Silveira       � Data �07/01/2003���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Efetua a abertura do SM0 exclusivo                         ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Atualizacao FIS                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Function MyOpenSM0Ex()

Local lOpen := .F.
Local nLoop := 0

For nLoop := 1 To 20
	dbUseArea( .T.,, "SIGAMAT.EMP", "SM0", .F., .F. )
	If !Empty( Select( "SM0" ) )
		lOpen := .T.
		dbSetIndex("SIGAMAT.IND")
		Exit	
	EndIf
	Sleep( 500 )
Next nLoop

If !lOpen
	Aviso( "Atencao !", "Nao foi possivel a abertura da tabela de empresas de forma exclusiva !", { "Ok" }, 2 )
EndIf

Return( lOpen )

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun�ao    � GeraSX2  � Autor � MICROSIGA             � Data �   /  /   ���
�������������������������������������������������������������������������Ĵ��
���Descri�ao � Funcao generica para copia de dicionarios                  ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function GeraSX2()
Local aArea		:= GetArea()
Local i			:= 0
Local j			:= 0
Local aRegs		:= {}
Local cTexto	:= ''
Local lInclui	:= .F.

aRegs  := {}
AADD(aRegs,{"SZF","\DATA\                                  ","SZF010  ","CADASTRO VOUCHER              ","CADASTRO VOUCHER              ","CADASTRO VOUCHER              ","                                        ","C",00," ","                                                                                                                                                                                                                                                          "," ",00,"                                                                                                                                                                                                                                                              "})

dbSelectArea("SX2")
dbSetOrder(1)

For i := 1 To Len(aRegs)

	dbSetOrder(1)
	lInclui := !DbSeek(aRegs[i, 1])

	cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

	RecLock("SX2", lInclui)
		For j := 1 to FCount()
			If j <= Len(aRegs[i])
				If allTrim(Field(j)) == "X2_ARQUIVO"
					aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
				EndIf
				If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
					Loop
				Else
					FieldPut(j,aRegs[i,j])
				EndIf
			Endif
		Next j
	MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"SZG","\DADOS\                                 ","SZG010  ","MOVIMETACAO VOUCHER           ","MOVIMETACAO VOUCHER           ","MOVIMETACAO VOUCHER           ","                                        ","C",00," ","                                                                                                                                                                                                                                                          "," ",00,"                                                                                                                                                                                                                                                              "})

dbSelectArea("SX2")
dbSetOrder(1)

For i := 1 To Len(aRegs)

	dbSetOrder(1)
	lInclui := !DbSeek(aRegs[i, 1])

	cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

	RecLock("SX2", lInclui)
		For j := 1 to FCount()
			If j <= Len(aRegs[i])
				If allTrim(Field(j)) == "X2_ARQUIVO"
					aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
				EndIf
				If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
					Loop
				Else
					FieldPut(j,aRegs[i,j])
				EndIf
			Endif
		Next j
	MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"SZH","\DATA\                                  ","SZH010  ","TIPOS DE VOUCHER              ","TIPOS DE VOUCHER              ","TIPOS DE VOUCHER              ","                                        ","C",00," ","                                                                                                                                                                                                                                                          "," ",00,"                                                                                                                                                                                                                                                              "})

dbSelectArea("SX2")
dbSetOrder(1)

For i := 1 To Len(aRegs)

	dbSetOrder(1)
	lInclui := !DbSeek(aRegs[i, 1])

	cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

	RecLock("SX2", lInclui)
		For j := 1 to FCount()
			If j <= Len(aRegs[i])
				If allTrim(Field(j)) == "X2_ARQUIVO"
					aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
				EndIf
				If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
					Loop
				Else
					FieldPut(j,aRegs[i,j])
				EndIf
			Endif
		Next j
	MsUnlock()
Next i

RestArea(aArea)
Return('SX2 : ' + cTexto  + CHR(13) + CHR(10))
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun�ao    � GeraSX3  � Autor � MICROSIGA             � Data �   /  /   ���
�������������������������������������������������������������������������Ĵ��
���Descri�ao � Funcao generica para copia de dicionarios                  ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function GeraSX3()
Local aArea		:= GetArea()
Local i			:= 0
Local j      	:= 0
Local aRegs		:= {}
Local cTexto	:= ''
Local lInclui	:= .F.
Local cHelp		:= ''
Local aHelp		:= {}
Local aHelpI	:= {}
Local aHelpE	:= {}

aRegs  := {}
AADD(aRegs,{"SZF","01","ZF_FILIAL","C",02,00,"Filial","Sucursal","Branch","FilialdoSistema","Sucursal","BranchoftheSystem","@!","","���������������","","",01,"��","","","U","N","","","","","","","","","","","033","","","","","","","","","N","N","N"})
AADD(aRegs,{"SZF","02","ZF_COD","C",09,00,"Cod.Voucher","Cod.Voucher","Cod.Voucher","CodigodoVoucher","CodigodoVoucher","CodigodoVoucher","@!","","���������������","GETSXENUM('SZF','ZF_COD')","",00,"��","","","U","S","V","R","","NaoVazio().And.ExistChav('SZF')","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","03","ZF_TIPOVOU","C",06,00,"TipoVoucher","TipoVoucher","TipoVoucher","TipodeVoucher","TipodeVoucher","TipodeVoucher","@!","","���������������","","SZH",00,"��","","","U","S","A","R","�","ExistChav('SZH',M->ZF_TIPOVOU)","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","04","ZF_PRODUTO","C",15,00,"Produto","Produto","Produto","CodigodoProduto","CodigodoProduto","CodigodoProduto","@!","vazio().or.existcpo('SB1')","���������������","","SB1",00,"��","","","U","S","A","R","�","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","05","ZF_QTDVOUC","N",09,02,"Quantidade","Quantidade","Quantidade","QuantidadedoVoucher","QuantidadedoVoucher","QuantidadedoVoucher","@E999999.99","","���������������","","",00,"��","","","U","S","A","R","�","Positivo()","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","06","ZF_DTVALID","D",08,00,"Val.Voucher","Val.Voucher","Val.Voucher","ValidadedoVoucher","ValidadedoVoucher","ValidadedoVoucher","@D","M->ZF_DTVALID>=DDATABASE","���������������","CTOD('')","",00,"��","","","U","S","A","R","�","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","07","ZF_PEDIDO","C",06,00,"Num.Pedido","Num.Pedido","Num.Pedido","NumerodoPedido","NumerodoPedido","NumerodoPedido","@X","","���������������","","",00,"��","","","U","S","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","08","ZF_CONTRAT","C",06,00,"Contrato","Contrato","Contrato","NumerodoContrato","NumerodoContrato","NumerodoContrato","@X","","���������������","","",00,"��","","","U","S","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","09","ZF_TES","C",03,00,"TipoSaida","TipoSaida","TipoSaida","TipodeSaida","TipodeSaida","TipodeSaida","@9","vazio().or.existcpo('SF4').And.M->ZF_TES>='500'","���������������","","SF4",00,"��","","","U","S","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","10","ZF_SALDO","N",09,02,"SldVoucher","SldVoucher","SldVoucher","SaldodoVoucher","SaldodoVoucher","SaldodoVoucher","@E999999.99","","���������������","","",00,"��","","","U","S","V","R","","Positivo()","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","11","ZF_ATIVO","C",01,00,"Ativo","Ativo","Ativo","Ativo","Ativo","Ativo","@!","","���������������","'S'","",00,"��","","","U","S","A","R","","Pertence('SN')","S=Sim;N=Nao","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","12","ZF_FLAGSIT","C",01,00,"Jaenviado","Jaenviado","Jaenviado","Jaenviadoparaosite","Jaenviadoparaosite","Jaenviadoparaosite","@!","","���������������","","",00,"��","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})

dbSelectArea("SX3")
dbSetOrder(1)

For i := 1 To Len(aRegs)

	If(Ascan(aArqUpd, aRegs[i,1]) == 0)
		aAdd(aArqUpd, aRegs[i,1])
	EndIf

	dbSetOrder(2)
	lInclui := !DbSeek(aRegs[i, 3])

	cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

	RecLock("SX3", lInclui)
		For j := 1 to FCount()
			If j <= Len(aRegs[i])
				If allTrim(Field(j)) == "X2_ARQUIVO"
					aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
				EndIf
				If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
					Loop
				Else
					FieldPut(j,aRegs[i,j])
				EndIf
			Endif
		Next j
	MsUnlock()
Next i

//HELP - ZF_COD
aHelp := {	"� informado o c�digo do Voucher, por um",;
			" n�mero sequencial."}
                     
cHelp := "ZF_COD    "
PutHelp("P"+cHelp,aHelp,aHelpI,aHelpE,.T.)

//HELP - ZF_PRODUTO
aHelp := {	"Informar para qual produto o Voucher",;
			" ser� referenciado."}
                     
cHelp := "ZF_PRODUTO"
PutHelp("P"+cHelp,aHelp,aHelpI,aHelpE,.T.)

//HELP - ZF_QTDVOUC
aHelp := {	"Informar a quantidade do Voucher,",;
			" referente ao produto informado."}
                     
cHelp := "ZF_QTDVOUC"
PutHelp("P"+cHelp,aHelp,aHelpI,aHelpE,.T.)

//HELP - ZF_DTVALID
aHelp := {	"Informe a data de validade do Voucher."}
                     
cHelp := "ZF_DTVALID"
PutHelp("P"+cHelp,aHelp,aHelpI,aHelpE,.T.)

//HELP - ZF_PEDIDO 
aHelp := {	"Informe o n�mero do pedido para",;
			" faturamento."}
                     
cHelp := "ZF_PEDIDO "
PutHelp("P"+cHelp,aHelp,aHelpI,aHelpE,.T.)

//HELP - ZF_CONTRAT
aHelp := {	"Informe o n�mero do contrato para",;
			" medi��o."}
                     
cHelp := "ZF_CONTRAT"
PutHelp("P"+cHelp,aHelp,aHelpI,aHelpE,.T.)

//HELP - ZF_TES
aHelp := {	"Informe o tipo de sa�da para a gera��o",;
			" do pedido e faturamento."}
                     
cHelp := "ZF_TES    "
PutHelp("P"+cHelp,aHelp,aHelpI,aHelpE,.T.)

//HELP - ZF_SALDO
aHelp := {	"� controlado o saldo do Voucher,",;
			" conforme suas sa�das."}
                     
cHelp := "ZF_SALDO  "
PutHelp("P"+cHelp,aHelp,aHelpI,aHelpE,.T.)

aRegs  := {}
AADD(aRegs,{"SZG","01","ZG_FILIAL","C",02,00,"Filial","Sucursal","Branch","FilialdoSistema","Sucursal","BranchoftheSystem","@!","","���������������","","",01,"��","","","U","N","","","","","","","","","","","033","","","","","","","","","N","N","N"})
AADD(aRegs,{"SZG","02","ZG_NUMPED","C",06,00,"NumPedido","NumPedido","NumPedido","NumerodoPedido","NumerodoPedido","NumerodoPedido","@X","","���������������","","",00,"��","","","U","S","A","R","�","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZG","03","ZG_ITEMPED","C",02,00,"ItemPedido","ItemPedido","ItemPedido","ItemdoPedido","ItemdoPedido","ItemdoPedido","@!","","���������������","","",00,"��","","","U","S","A","R","�","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZG","04","ZG_NUMVOUC","C",09,00,"NumVoucher","NumVoucher","NumVoucher","NumerodoVoucher","NumerodoVoucher","NumerodoVoucher","@!","","���������������","","SZF",00,"��","","","U","S","A","R","�","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZG","05","ZG_QTDSAI","N",09,02,"Quantidade","Quantidade","Quantidade","Quantidadesaida","Quantidadesaida","Quantidadesaida","@E999999.99","","���������������","0","",00,"��","","","U","S","A","R","�","Positivo()","","","","","","","","","","","","","N","N","","N","N","N"})

dbSelectArea("SX3")
dbSetOrder(1)

For i := 1 To Len(aRegs)

	If(Ascan(aArqUpd, aRegs[i,1]) == 0)
		 aAdd(aArqUpd, aRegs[i,1])
	EndIf

	dbSetOrder(2)
	lInclui := !DbSeek(aRegs[i, 3])

	cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

	RecLock("SX3", lInclui)
		For j := 1 to FCount()
			If j <= Len(aRegs[i])
				If allTrim(Field(j)) == "X2_ARQUIVO"
					aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
				EndIf
				If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
					Loop
				Else
					FieldPut(j,aRegs[i,j])
				EndIf
			Endif
		Next j
	MsUnlock()
Next i

//HELP - ZG_NUMPED 
aHelp := {	"Informe o n�mero do pedido que",;
			" movimentou o Voucher."}
                     
cHelp := "ZG_NUMPED "
PutHelp("P"+cHelp,aHelp,aHelpI,aHelpE,.T.)

//HELP - ZG_ITEMPED
aHelp := {	"Informar o item do pedido referente ao",;
			" produto do Voucher."}
                     
cHelp := "ZG_ITEMPED"
PutHelp("P"+cHelp,aHelp,aHelpI,aHelpE,.T.)

//HELP - ZG_NUMVOUC
aHelp := {	"Informar o n�mero do Voucher para",;
			" movimenta��o do mesmo."}
                     
cHelp := "ZG_NUMVOUC"
PutHelp("P"+cHelp,aHelp,aHelpI,aHelpE,.T.)

//HELP - ZG_QTDSAI
aHelp := {	"Informe a quantidade que saiu do Voucher",;
			" informado."}
                     
cHelp := "ZG_QTDSAI "
PutHelp("P"+cHelp,aHelp,aHelpI,aHelpE,.T.)

aRegs  := {}
AADD(aRegs,{"SZH","01","ZH_FILIAL","C",02,00,"Filial","Sucursal","Branch","FilialdoSistema","Sucursal","BranchoftheSystem","@!","","���������������","","",01,"��","","","U","N","","","","","","","","","","","033","","","","","","","","","N","N","N"})
AADD(aRegs,{"SZH","02","ZH_COD","C",06,00,"CodTipoVou","CodTipoVou","CodTipoVou","Codigodotipodovoucher","Codigodotipodovoucher","Codigodotipodovoucher","@!","","���������������","GETSXENUM('SZH','ZH_COD')","",00,"��","","","U","S","V","R","�","NaoVazio().And.ExistChav('SZH')","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZH","03","ZH_DESCRI","C",30,00,"DesTipoVou","DesTipoVou","DesTipoVou","DescricaoTipoVoucher","DescricaoTipoVoucher","DescricaoTipoVoucher","@!","","���������������","","",00,"��","","","U","S","A","R","�","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZH","04","ZH_INCITVE","C",01,00,"IncIteVen?","IncIteVen?","IncIteVen?","IncluiItemdeVenda?","IncluiItemdeVenda?","IncluiItemdeVenda?","@!","","���������������","'S'","",00,"��","","","U","S","A","R","","Pertence('SN')","S=Sim;N=Nao","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZH","05","ZH_TESVEND","C",03,00,"TESIteVend","TESIteVend","TESIteVend","TESItemVenda","TESItemVenda","TESItemVenda","@!","","���������������","","SF4",00,"��","","","U","S","A","R","","vazio().or.existcpo('SF4').And.M->ZH_TESVEND>='500'","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZH","06","ZH_INCITEE","C",01,00,"IncIteEnt?","IncIteEnt?","IncIteEnt?","IncluiItemdeEntrega?","IncluiItemdeEntrega?","IncluiItemdeEntrega?","@!","","���������������","'S'","",00,"��","","","U","S","A","R","","Pertence('SN')","S=Sim;N=Nao","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZH","07","ZH_TESENTR","C",03,00,"TESIteEntr","TESIteEntr","TESIteEntr","TESItemEntrega","TESItemEntrega","TESItemEntrega","@!","","���������������","","SF4",00,"��","","","U","S","A","R","","vazio().or.existcpo('SF4').And.M->ZH_TESENTR>='500'","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZH","08","ZH_FATITVE","C",01,00,"FatIteVen?","FatIteVen?","FatIteVen?","FaturaItemdeVenda?","FaturaItemdeVenda?","FaturaItemdeVenda?","@!","","���������������","'S'","",00,"��","","","U","S","A","R","","Pertence('SN')","S=Sim;N=Nao","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZH","09","ZH_FATITEE","C",01,00,"FatIteEnt?","FatIteEnt?","FatIteEnt?","FaturaItemdeEntrega?","FaturaItemdeEntrega?","FaturaItemdeEntrega?","@!","","���������������","'S'","",00,"��","","","U","S","A","R","","Pertence('SN')","S=Sim;N=Nao","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZH","10","ZH_CONSPDO","C",01,00,"ConsPed?","ConsPed?","ConsPed?","ConsideraPedido?","ConsideraPedido?","ConsideraPedido?","@!","","���������������","'V'","",00,"��","","","U","S","A","R","","Pertence('VPE')","V=Voucher;P=Periodo;E=Entrega","","","","","","","","","","","","N","N","","N","N","N"})

dbSelectArea("SX3")
dbSetOrder(1)

For i := 1 To Len(aRegs)

	If(Ascan(aArqUpd, aRegs[i,1]) == 0)
		 aAdd(aArqUpd, aRegs[i,1])
	EndIf

	dbSetOrder(2)
	lInclui := !DbSeek(aRegs[i, 3])

	cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

	RecLock("SX3", lInclui)
		For j := 1 to FCount()
			If j <= Len(aRegs[i])
				If allTrim(Field(j)) == "X2_ARQUIVO"
					aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
				EndIf
				If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
					Loop
				Else
					FieldPut(j,aRegs[i,j])
				EndIf
			Endif
		Next j
	MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"SC5","C6","C5_XNPSITE","C",10,00,"NumPedSite","NumPedSite","NumPedSite","Numerodopedidonosite","Numerodopedidonosite","Numerodopedidonosite","9999999999","","���������������","","",00,"��","","","U","S","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SC5","C7","C5_XFORPGT","C",01,00,"FormaPagto","FormaPagto","FormaPagto","FormadePagamento","FormadePagamento","FormadePagamento","@!","","���������������","","",00,"��","","","U","S","V","R","","Pertence('123')","1=Cartao;2=Boleto;3=Voucher","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SC5","C8","C5_XNUMCAR","C",16,00,"NumCartao","NumCartao","NumCartao","NumCartaodeCredito","NumCartaodeCredito","NumCartaodeCredito","9999999999999999","","���������������","","",00,"��","","","U","S","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SC5","C9","C5_XNOMTIT","C",20,00,"NomTitular","NomTitular","NomTitular","NomedoTitularCartao","NomedoTitularCartao","NomedoTitularCartao","@!","","���������������","","",00,"��","","","U","S","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SC5","D0","C5_XCODSEG","C",03,00,"CodSegCart","CodSegCart","CodSegCart","CodigodeSeg.Cartao","CodigodeSeg.Cartao","CodigodeSeg.Cartao","999","","���������������","","",00,"��","","","U","S","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SC5","D1","C5_XDTVALI","D",08,00,"DtValCart","DtValCart","DtValCart","DataValidadeCartao","DataValidadeCartao","DataValidadeCartao","@D","","���������������","","",00,"��","","","U","S","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SC5","D2","C5_XNPARCE","C",02,00,"NumParcelas","NumParcelas","NumParcelas","NumerodeParcelas","NumerodeParcelas","NumerodeParcelas","99","","���������������","","",00,"��","","","U","S","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SC5","D3","C5_XTIPCAR","C",01,00,"TipoCartao","TipoCartao","TipoCartao","TipoCartaodeCredito","TipoCartaodeCredito","TipoCartaodeCredito","@!","","���������������","","",00,"��","","","U","S","V","R","","Pertence('123')","1=Visa;2=MasterCard;3=AmericanExpress","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SC5","D4","C5_XLINDIG","C",48,00,"LinhaDigita","LinhaDigita","LinhaDigita","LinhaDigitavelBoleto","LinhaDigitavelBoleto","LinhaDigitavelBoleto","@!","","���������������","","",00,"��","","","U","S","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SC5","D5","C5_XNUMVOU","C",09,00,"NumVoucher","NumVoucher","NumVoucher","NumerodoVoucher","NumerodoVoucher","NumerodoVoucher","@!","","���������������","","",00,"��","","","U","S","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SC5","D6","C5_XQTDVOU","N",09,02,"QtdVoucher","QtdVoucher","QtdVoucher","QuantidadedoVoucher","QuantidadedoVoucher","QuantidadedoVoucher","@E999999,99","","���������������","","",00,"��","","","U","S","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SC5","D7","C5_XNFHRD","C",80,00,"LinkNFHRD","LinkNFHRD","LinkNFHRD","LinkNotaFiscalHardware","LinkNotaFiscalHardware","LinkNotaFiscalHardware","","","���������������","","",00,"��","","","U","S","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SC5","D8","C5_XNFSFW","C",80,00,"LinkNFSFW","LinkNFSFW","LinkNFSFW","LinkNotaFiscalSoftware","LinkNotaFiscalSoftware","LinkNotaFiscalSoftware","","","���������������","","",00,"��","","","U","S","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SC5","D9","C5_XFLAGEN","C",01,00,"FlagEnvSit","FlagEnvSit","FlagEnvSit","FlagEnvioSite","FlagEnvioSite","FlagEnvioSite","@!","","���������������","","",00,"��","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})

dbSelectArea("SX3")
dbSetOrder(1)

For i := 1 To Len(aRegs)

	If(Ascan(aArqUpd, aRegs[i,1]) == 0)
		 aAdd(aArqUpd, aRegs[i,1])
	EndIf

	dbSetOrder(2)
	lInclui := !DbSeek(aRegs[i, 3])

	cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

	RecLock("SX3", lInclui)
		For j := 1 to FCount()
			If j <= Len(aRegs[i])
				If allTrim(Field(j)) == "X2_ARQUIVO"
					aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
				EndIf
				If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
					Loop
				Else
					FieldPut(j,aRegs[i,j])
				EndIf
			Endif
		Next j
	MsUnlock()
Next i

//HELP - C5_XNPSITE
aHelp := {	"� informado o n�mero do pedido no site."}
                     
cHelp := "C5_XNPSITE"
PutHelp("P"+cHelp,aHelp,aHelpI,aHelpE,.T.)

//HELP - C5_XFORPGT
aHelp := {	"� informada a forma de pagamento do site",;
			" 1 - Cart�o, 2 - Boleto e 3 - Voucher."}
                     
cHelp := "C5_XFORPGT"
PutHelp("P"+cHelp,aHelp,aHelpI,aHelpE,.T.)

//HELP - C5_XNUMCAR
aHelp := {	"Gravado o n�mero de cart�o de cr�dito",;
			" informado no site."}
                     
cHelp := "C5_XNUMCAR"
PutHelp("P"+cHelp,aHelp,aHelpI,aHelpE,.T.)

//HELP - C5_XNOMTIT
aHelp := {	"� informado o nome do t�tular do cart�o."}
                     
cHelp := "C5_XNOMTIT"
PutHelp("P"+cHelp,aHelp,aHelpI,aHelpE,.T.)

//HELP - C5_XCODSEG 
aHelp := {	"� informado o c�digo de seguran�a do",;
			" cart�o."}
                     
cHelp := "C5_XCODSEG"
PutHelp("P"+cHelp,aHelp,aHelpI,aHelpE,.T.)

//HELP - C5_XDTVALI
aHelp := {	"� informado a data de validade do cart�o",;
			" informado no site."}
                     
cHelp := "C5_XDTVALI"
PutHelp("P"+cHelp,aHelp,aHelpI,aHelpE,.T.)

//HELP - C5_XNPARCE
aHelp := {	"� informado o n�mero de parcelas que",;
			" ser� divido o cart�o de cr�dito."}
                     
cHelp := "C5_XNPARCE"
PutHelp("P"+cHelp,aHelp,aHelpI,aHelpE,.T.)

//HELP - C5_XTIPCAR
aHelp := {	"� informada a bandeira do cart�o de",;
			" cr�dito 1 - Visa, 2 - MasterCard e 6 -",;
			" American Express."}
                     
cHelp := "C5_XTIPCAR"
PutHelp("P"+cHelp,aHelp,aHelpI,aHelpE,.T.)

//HELP - C5_XLINDIG
aHelp := {	"� informada a linha digit�vel do boleto."}
                     
cHelp := "C5_XLINDIG"
PutHelp("P"+cHelp,aHelp,aHelpI,aHelpE,.T.)

//HELP - C5_XNUMVOU
aHelp := {	"� informado o n�mero do Voucher."}
                     
cHelp := "C5_XNUMVOU"
PutHelp("P"+cHelp,aHelp,aHelpI,aHelpE,.T.)

//HELP - C5_XQTDVOU
aHelp := {	"� informada a quantidade utilizada."}
                     
cHelp := "C5_XQTDVOU"
PutHelp("P"+cHelp,aHelp,aHelpI,aHelpE,.T.)

aRegs  := {}
AADD(aRegs,{"SC6","B8","C6_XNUMVOU","C",09,00,"NrVoucher","NrVoucher","NrVoucher","NumerodoVoucher","NumerodoVoucher","NumerodoVoucher","@!","","���������������","","",00,"��","","","U","S","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SC6","B9","C6_XQTDVOU","N",09,02,"QtdVoucher","QtdVoucher","QtdVoucher","QuantidadedoVoucher","QuantidadedoVoucher","QuantidadedoVoucher","@E999999,99","","���������������","","",00,"��","","","U","S","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})

dbSelectArea("SX3")
dbSetOrder(1)

For i := 1 To Len(aRegs)

	If(Ascan(aArqUpd, aRegs[i,1]) == 0)
		 aAdd(aArqUpd, aRegs[i,1])
	EndIf

	dbSetOrder(2)
	lInclui := !DbSeek(aRegs[i, 3])

	cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

	RecLock("SX3", lInclui)
		For j := 1 to FCount()
			If j <= Len(aRegs[i])
				If allTrim(Field(j)) == "X2_ARQUIVO"
					aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
				EndIf
				If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
					Loop
				Else
					FieldPut(j,aRegs[i,j])
				EndIf
			Endif
		Next j
	MsUnlock()
Next i

//HELP - C6_XNUMVOU
aHelp := {	"� informado o n�mero do Voucher."}
                     
cHelp := "C6_XNUMVOU"
PutHelp("P"+cHelp,aHelp,aHelpI,aHelpE,.T.)

//HELP - C6_XQTDVOU
aHelp := {	"� informada a quantidade consumida pelo",;
			" voucher."}
                     
cHelp := "C6_XQTDVOU"
PutHelp("P"+cHelp,aHelp,aHelpI,aHelpE,.T.)

aRegs  := {}
AADD(aRegs,{"SB1","O1","B1_XTIPPRO","C",02,00,"TipoProduto","TipoProduto","TipoProduto","TipoProdutoCertisign","TipoProdutoCertisign","TipoProdutoCertisign","99","","���������������","","ZZ",00,"��","","","U","S","A","R","","","","","","","","","","1","","","","","N","N","","N","N","N"})

dbSelectArea("SX3")
dbSetOrder(1)

For i := 1 To Len(aRegs)

	If(Ascan(aArqUpd, aRegs[i,1]) == 0)
		 aAdd(aArqUpd, aRegs[i,1])
	EndIf

	dbSetOrder(2)
	lInclui := !DbSeek(aRegs[i, 3])

	cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

	RecLock("SX3", lInclui)
		For j := 1 to FCount()
			If j <= Len(aRegs[i])
				If allTrim(Field(j)) == "X2_ARQUIVO"
					aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
				EndIf
				If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
					Loop
				Else
					FieldPut(j,aRegs[i,j])
				EndIf
			Endif
		Next j
	MsUnlock()
Next i

//HELP - B1_XTIPPRO
aHelp := {	"Selecione o tipo de produto certisign."}
                     
cHelp := "B1_XTIPPRO"
PutHelp("P"+cHelp,aHelp,aHelpI,aHelpE,.T.)

aRegs  := {}
AADD(aRegs,{"SE1","N1","E1_XNPSITE","C",10,00,"NrPedSite","NrPedSite","NrPedSite","NumeroPedidoSite","NumeroPedidoSite","NumeroPedidoSite","9999999999","","���������������","","",00,"��","","","U","S","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})

dbSelectArea("SX3")
dbSetOrder(1)

For i := 1 To Len(aRegs)

	If(Ascan(aArqUpd, aRegs[i,1]) == 0)
		 aAdd(aArqUpd, aRegs[i,1])
	EndIf

	dbSetOrder(2)
	lInclui := !DbSeek(aRegs[i, 3])

	cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

	RecLock("SX3", lInclui)
		For j := 1 to FCount()
			If j <= Len(aRegs[i])
				If allTrim(Field(j)) == "X2_ARQUIVO"
					aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
				EndIf
				If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
					Loop
				Else
					FieldPut(j,aRegs[i,j])
				EndIf
			Endif
		Next j
	MsUnlock()
Next i

//HELP - E1_XNPSITE
aHelp := {	"� informado o n�mero do pedido do site."}
                     
cHelp := "E1_XNPSITE"
PutHelp("P"+cHelp,aHelp,aHelpI,aHelpE,.T.)

RestArea(aArea)
Return('SX3 : ' + cTexto  + CHR(13) + CHR(10))

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun�ao    � GeraSX6  � Autor � MICROSIGA             � Data �   /  /   ���
�������������������������������������������������������������������������Ĵ��
���Descri�ao � Funcao generica para copia de dicionarios                  ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function GeraSX6()
Local aArea		:= GetArea()
Local i      	:= 0
Local j      	:= 0
Local aRegs  	:= {}
Local cTexto 	:= ''
Local lInclui	:= .F.

aRegs  := {}
AADD(aRegs,{"","MV_XTABPRC","C","Informeaocodigodatabeladeprecogenericaque","","","serautilizadaviawebservice.","","","","","","001","","","U","","","","","",""})

dbSelectArea("SX6")
dbSetOrder(1)

For i := 1 To Len(aRegs)

	cTexto += IIf( aRegs[i,1] + aRegs[i,2] $ cTexto, "", aRegs[i,1] + aRegs[i,2] + "\")

	dbSetOrder(1)
	lInclui := !DbSeek(aRegs[i, 1] + aRegs[i, 2])

	cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

	RecLock("SX6", lInclui)
		For j := 1 to FCount()
			If j <= Len(aRegs[i])
				If allTrim(Field(j)) == "X2_ARQUIVO"
					aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
				EndIf
				If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
					Loop
				Else
					FieldPut(j,aRegs[i,j])
				EndIf
			Endif
		Next
	MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"","MV_XPOSGRU","C","IdentificaocodigodogruporeferenteaosPostos","","","deEntrega.","","","","","","","","","U","","","","","",""})

dbSelectArea("SX6")
dbSetOrder(1)

For i := 1 To Len(aRegs)

	cTexto += IIf( aRegs[i,1] + aRegs[i,2] $ cTexto, "", aRegs[i,1] + aRegs[i,2] + "\")

	dbSetOrder(1)
	lInclui := !DbSeek(aRegs[i, 1] + aRegs[i, 2])

	cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

	RecLock("SX6", lInclui)
		For j := 1 to FCount()
			If j <= Len(aRegs[i])
				If allTrim(Field(j)) == "X2_ARQUIVO"
					aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
				EndIf
				If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
					Loop
				Else
					FieldPut(j,aRegs[i,j])
				EndIf
			Endif
		Next
	MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"","MV_XTESWEB","C","InformaroTESpadraodevendapelowebservice,","","","poisomesmoserautilizadonainclusaodepedidos","","","viawebservice.","","","501","","","U","","","","","",""})

dbSelectArea("SX6")
dbSetOrder(1)

For i := 1 To Len(aRegs)

	cTexto += IIf( aRegs[i,1] + aRegs[i,2] $ cTexto, "", aRegs[i,1] + aRegs[i,2] + "\")

	dbSetOrder(1)
	lInclui := !DbSeek(aRegs[i, 1] + aRegs[i, 2])

	cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

	RecLock("SX6", lInclui)
		For j := 1 to FCount()
			If j <= Len(aRegs[i])
				If allTrim(Field(j)) == "X2_ARQUIVO"
					aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
				EndIf
				If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
					Loop
				Else
					FieldPut(j,aRegs[i,j])
				EndIf
			Endif
		Next
	MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"","MV_XTESDEV","C","TESutilizdoparadevolucaodePoderdeTerceiros.","","","","","","","","","","","","U","","","","","",""})

dbSelectArea("SX6")
dbSetOrder(1)

For i := 1 To Len(aRegs)

	cTexto += IIf( aRegs[i,1] + aRegs[i,2] $ cTexto, "", aRegs[i,1] + aRegs[i,2] + "\")

	dbSetOrder(1)
	lInclui := !DbSeek(aRegs[i, 1] + aRegs[i, 2])

	cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

	RecLock("SX6", lInclui)
		For j := 1 to FCount()
			If j <= Len(aRegs[i])
				If allTrim(Field(j)) == "X2_ARQUIVO"
					aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
				EndIf
				If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
					Loop
				Else
					FieldPut(j,aRegs[i,j])
				EndIf
			Endif
		Next
	MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"","MV_XTESREM","C","TESutilizadoparabuscadasnotasemitidaspara","","","PoderdeTerceiros(remessa).","","","","","","","","","U","","","","","",""})

dbSelectArea("SX6")
dbSetOrder(1)

For i := 1 To Len(aRegs)

	cTexto += IIf( aRegs[i,1] + aRegs[i,2] $ cTexto, "", aRegs[i,1] + aRegs[i,2] + "\")
	
	dbSetOrder(1)
	lInclui := !DbSeek(aRegs[i, 1] + aRegs[i, 2])
	
	cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

	RecLock("SX6", lInclui)
		For j := 1 to FCount()
			If j <= Len(aRegs[i])
				If allTrim(Field(j)) == "X2_ARQUIVO"
					aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
				EndIf
				If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
					Loop
				Else
					FieldPut(j,aRegs[i,j])
				EndIf
			Endif
		Next
	MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"","MV_XTESSAI","C","TESutilizadoparaofaturamentofinalviaweb","","","service.","","","","","","","","","U","","","","","",""})

dbSelectArea("SX6")
dbSetOrder(1)

For i := 1 To Len(aRegs)

	cTexto += IIf( aRegs[i,1] + aRegs[i,2] $ cTexto, "", aRegs[i,1] + aRegs[i,2] + "\")

	dbSetOrder(1)
	lInclui := !DbSeek(aRegs[i, 1] + aRegs[i, 2])

	cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

	RecLock("SX6", lInclui)
		For j := 1 to FCount()
			If j <= Len(aRegs[i])
				If allTrim(Field(j)) == "X2_ARQUIVO"
					aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
				EndIf
				If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
					Loop
				Else
					FieldPut(j,aRegs[i,j])
				EndIf
			Endif
		Next
	MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"","MV_XTPDEVO","C","Deveraserinformadootipodedocumentodeentrad","","","areferenteadevolucaodepoderdeterceiros.","","","","","","B","","","U","","","","","",""})

dbSelectArea("SX6")
dbSetOrder(1)

For i := 1 To Len(aRegs)

	cTexto += IIf( aRegs[i,1] + aRegs[i,2] $ cTexto, "", aRegs[i,1] + aRegs[i,2] + "\")

	dbSetOrder(1)
	lInclui := !DbSeek(aRegs[i, 1] + aRegs[i, 2])

	cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

	RecLock("SX6", lInclui)
		For j := 1 to FCount()
			If j <= Len(aRegs[i])
				If allTrim(Field(j)) == "X2_ARQUIVO"
					aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
				EndIf
				If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
					Loop
				Else
					FieldPut(j,aRegs[i,j])
				EndIf
			Endif
		Next
	MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"","MV_XESPECI","C","DeveraserinformadaaespeciedaNotalFiscalde","","","Entrada,referenteadevolucao.","","","","","","","","","U","","","","","",""})

dbSelectArea("SX6")
dbSetOrder(1)

For i := 1 To Len(aRegs)

	cTexto += IIf( aRegs[i,1] + aRegs[i,2] $ cTexto, "", aRegs[i,1] + aRegs[i,2] + "\")

	dbSetOrder(1)
	lInclui := !DbSeek(aRegs[i, 1] + aRegs[i, 2])

	cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

	RecLock("SX6", lInclui)
		For j := 1 to FCount()
			If j <= Len(aRegs[i])
				If allTrim(Field(j)) == "X2_ARQUIVO"
					aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
				EndIf
				If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
					Loop
				Else
					FieldPut(j,aRegs[i,j])
				EndIf
			Endif
		Next
	MsUnlock()
Next i

AADD(aRegs,{"","MV_XCPSITE","C","Informeacondicaodepagamentopadraoutilizada","","","nositehardwareavulso.","","","","","","001","","","U","","","","","",""})

dbSelectArea("SX6")
dbSetOrder(1)

For i := 1 To Len(aRegs)

	cTexto += IIf( aRegs[i,1] + aRegs[i,2] $ cTexto, "", aRegs[i,1] + aRegs[i,2] + "\")

	dbSetOrder(1)
	lInclui := !DbSeek(aRegs[i, 1] + aRegs[i, 2])

	cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

	RecLock("SX6", lInclui)
		For j := 1 to FCount()
			If j <= Len(aRegs[i])
				If allTrim(Field(j)) == "X2_ARQUIVO"
					aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
				EndIf
				If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
					Loop
				Else
					FieldPut(j,aRegs[i,j])
				EndIf
			Endif
		Next
	MsUnlock()
Next i

AADD(aRegs,{"","MV_XVENSIT","C","Informequalovendedorpadraodositehardwareav","","","ulso.","","","","","","000001","","","U","","","","","",""})

dbSelectArea("SX6")
dbSetOrder(1)

For i := 1 To Len(aRegs)

	cTexto += IIf( aRegs[i,1] + aRegs[i,2] $ cTexto, "", aRegs[i,1] + aRegs[i,2] + "\")

	dbSetOrder(1)
	lInclui := !DbSeek(aRegs[i, 1] + aRegs[i, 2])

	cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

	RecLock("SX6", lInclui)
		For j := 1 to FCount()
			If j <= Len(aRegs[i])
				If allTrim(Field(j)) == "X2_ARQUIVO"
					aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
				EndIf
				If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
					Loop
				Else
					FieldPut(j,aRegs[i,j])
				EndIf
			Endif
		Next
	MsUnlock()
Next i

RestArea(aArea)
Return('SX6 : ' + cTexto  + CHR(13) + CHR(10))

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun�ao    � GeraSIX  � Autor � MICROSIGA             � Data �   /  /   ���
�������������������������������������������������������������������������Ĵ��
���Descri�ao � Funcao generica para copia de dicionarios                  ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function GeraSIX()
Local aArea		:= GetArea()
Local i      	:= 0
Local j      	:= 0
Local aRegs  	:= {}
Local cTexto 	:= ''
Local lInclui	:= .F.

aRegs  := {}
AADD(aRegs,{"SC5","8","C5_FILIAL+C5_XNPSITE                                                                                                                                            ","Num Ped Site                                                          ","Num Ped Site                                                          ","Num Ped Site                                                          ","U","                                                                                                                                                                ","          ","N"})

dbSelectArea("SIX")
dbSetOrder(1)

For i := 1 To Len(aRegs)

	If(Ascan(aArqUpd, aRegs[i,1]) == 0)
	 	aAdd(aArqUpd, aRegs[i,1])
	EndIf

	dbSetOrder(1)
	lInclui := !DbSeek(aRegs[i, 1] + aRegs[i, 2])
	If !lInclui
		TcInternal(60,RetSqlName(aRegs[i, 1]) + "|" + RetSqlName(aRegs[i, 1]) + aRegs[i, 2])
	Endif

	cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

	RecLock("SIX", lInclui)
		For j := 1 to FCount()
			If j <= Len(aRegs[i])
				If allTrim(Field(j)) == "X2_ARQUIVO"
					aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
				EndIf
				If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
					Loop
				Else
					FieldPut(j,aRegs[i,j])
				EndIf
			Endif
		Next j
	MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"SZF","1","ZF_FILIAL+ZF_COD","Cod.Voucher","Cod.Voucher","Cod.Voucher","U","","","N"})

dbSelectArea("SIX")
dbSetOrder(1)

For i := 1 To Len(aRegs)

	If(Ascan(aArqUpd, aRegs[i,1]) == 0)
 		aAdd(aArqUpd, aRegs[i,1])
	EndIf

	dbSetOrder(1)
	lInclui := !DbSeek(aRegs[i, 1] + aRegs[i, 2])
	If !lInclui
		TcInternal(60,RetSqlName(aRegs[i, 1]) + "|" + RetSqlName(aRegs[i, 1]) + aRegs[i, 2])
	Endif

	cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

	RecLock("SIX", lInclui)
		For j := 1 to FCount()
			If j <= Len(aRegs[i])
				If allTrim(Field(j)) == "X2_ARQUIVO"
					aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
				EndIf
				If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
					Loop
				Else
					FieldPut(j,aRegs[i,j])
				EndIf
			Endif
		Next j
	MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"SZG","1","ZG_FILIAL+ZG_NUMPED+ZG_ITEMPED+ZG_NUMVOUC","NumPedido+ItemPedido+NumVoucher","NumPedido+ItemPedido+NumVoucher","NumPedido+ItemPedido+NumVoucher","U","","","N"})

dbSelectArea("SIX")
dbSetOrder(1)

For i := 1 To Len(aRegs)

	If(Ascan(aArqUpd, aRegs[i,1]) == 0)
	 	aAdd(aArqUpd, aRegs[i,1])
	EndIf

	dbSetOrder(1)
	lInclui := !DbSeek(aRegs[i, 1] + aRegs[i, 2])
	If !lInclui
		TcInternal(60,RetSqlName(aRegs[i, 1]) + "|" + RetSqlName(aRegs[i, 1]) + aRegs[i, 2])
	Endif

	cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

	RecLock("SIX", lInclui)
		For j := 1 to FCount()
			If j <= Len(aRegs[i])
				If allTrim(Field(j)) == "X2_ARQUIVO"
					aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
				EndIf
				If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
					Loop
				Else
					FieldPut(j,aRegs[i,j])
				EndIf
			Endif
		Next j
	MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"SZH","1","ZH_FILIAL+ZH_COD","CodTipoVou","CodTipoVou","CodTipoVou","U","","","N"})

dbSelectArea("SIX")
dbSetOrder(1)

For i := 1 To Len(aRegs)

	If(Ascan(aArqUpd, aRegs[i,1]) == 0)
	 	aAdd(aArqUpd, aRegs[i,1])
	EndIf

	dbSetOrder(1)
	lInclui := !DbSeek(aRegs[i, 1] + aRegs[i, 2])
	If !lInclui
		TcInternal(60,RetSqlName(aRegs[i, 1]) + "|" + RetSqlName(aRegs[i, 1]) + aRegs[i, 2])
	Endif

	cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

	RecLock("SIX", lInclui)
		For j := 1 to FCount()
			If j <= Len(aRegs[i])
				If allTrim(Field(j)) == "X2_ARQUIVO"
					aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
				EndIf
				If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
					Loop
				Else
					FieldPut(j,aRegs[i,j])
				EndIf
			Endif
		Next j
	MsUnlock()
Next i

RestArea(aArea)
Return('SIX : ' + cTexto  + CHR(13) + CHR(10))
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun�ao    � GeraSXB  � Autor � MICROSIGA             � Data �   /  /   ���
�������������������������������������������������������������������������Ĵ��
���Descri�ao � Funcao generica para copia de dicionarios                  ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function GeraSXB()
Local aArea		:= GetArea()
Local i      	:= 0
Local j      	:= 0
Local aRegs  	:= {}
Local cTexto 	:= ''
Local lInclui	:= .F.

aRegs  := {}
AADD(aRegs,{"SZF","1","01","DB","CadastroVoucher","CadastroVoucher","CadastroVoucher","SZF",""})
AADD(aRegs,{"SZF","2","01","01","Cod.Voucher","Cod.Voucher","Cod.Voucher","",""})
AADD(aRegs,{"SZF","4","01","01","Cod.Voucher","Cod.Voucher","Cod.Voucher","ZF_COD",""})
AADD(aRegs,{"SZF","4","01","02","Produto","Produto","Produto","ZF_PRODUTO",""})
AADD(aRegs,{"SZF","4","01","03","Quantidade","Quantidade","Quantidade","ZF_QTDVOUC",""})
AADD(aRegs,{"SZF","4","01","04","Val.Voucher","Val.Voucher","Val.Voucher","ZF_DTVALID",""})
AADD(aRegs,{"SZF","5","01","","","","","SZF->ZF_COD",""})

dbSelectArea("SXB")
dbSetOrder(1)

For i := 1 To Len(aRegs)
	
	dbSetOrder(1)
	lInclui := !DbSeek(aRegs[i, 1] + aRegs[i, 2] + aRegs[i, 3] + aRegs[i, 4])
	
	cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")
	
	RecLock("SXB", lInclui)
		For j := 1 to FCount()
			If j <= Len(aRegs[i])
				If allTrim(Field(j)) == "X2_ARQUIVO"
					aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
				EndIf
				If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
					Loop
				Else
					FieldPut(j,aRegs[i,j])
				EndIf
			Endif
		Next j
	MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"SZH","1","01","DB","TiposdeVoucher","TiposdeVoucher","TiposdeVoucher","SZH",""})
AADD(aRegs,{"SZH","2","01","01","CodTipoVou","CodTipoVou","CodTipoVou","",""})
AADD(aRegs,{"SZH","3","01","01","CadastraNovo","IncluyeNuevo","AddNew","01",""})
AADD(aRegs,{"SZH","4","01","01","CodTipoVou","CodTipoVou","CodTipoVou","ZH_COD",""})
AADD(aRegs,{"SZH","4","01","02","DesTipoVou","DesTipoVou","DesTipoVou","ZH_DESCRI",""})
AADD(aRegs,{"SZH","5","01","","","","","SZH->ZH_COD",""})

dbSelectArea("SXB")
dbSetOrder(1)

For i := 1 To Len(aRegs)
	
	dbSetOrder(1)
	lInclui := !DbSeek(aRegs[i, 1] + aRegs[i, 2] + aRegs[i, 3] + aRegs[i, 4])
	
	cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")
	
	RecLock("SXB", lInclui)
		For j := 1 to FCount()
			If j <= Len(aRegs[i])
				If allTrim(Field(j)) == "X2_ARQUIVO"
					aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
				EndIf
				If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
					Loop
				Else
					FieldPut(j,aRegs[i,j])
				EndIf
			Endif
		Next j
	MsUnlock()
Next i

RestArea(aArea)
Return('SXB : ' + cTexto + CHR(13) + CHR(10))

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �IncSX5     �Autor  �Darcio R. Sporl     � Data �  01/08/11  ���
�������������������������������������������������������������������������͹��
���Desc.     �Funcao criada para incluir a consulta padrao do tipo de     ���
���          �produto da certisign.                                       ���
�������������������������������������������������������������������������͹��
���Uso       � Opvs x Certisign                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function IncSX5()
Local aArea		:= GetArea()
Local cTexto 	:= "Inclu�da a tabela ZZ."
Local aRegs		:= {}
Local nI		:= 0

aRegs  := {}
AADD(aRegs,{"02","00","ZZ","TIPOPRODUTOCERTISIGN","TIPOPRODUTOCERTISIGN","TIPOPRODUTOCERTISIGN"})
AADD(aRegs,{"02","ZZ","01","SMARTCARD","SMARTCARD","SMARTCARD"})
AADD(aRegs,{"02","ZZ","02","LEITORA","LEITORA","LEITORA"})
AADD(aRegs,{"02","ZZ","03","TOKEN","TOKEN","TOKEN"})

DbSelectArea("SX5")
DbSetOrder(1)

For nI := 1 To Len(aRegs)
	If !DbSeek(aRegs[nI][1] + aRegs[nI][2] + aRegs[nI][3])
		RecLock("SX5", .T.)
			SX5->X5_FILIAL	:= aRegs[nI][1]
			SX5->X5_TABELA	:= aRegs[nI][2]
			SX5->X5_CHAVE	:= aRegs[nI][3]
			SX5->X5_DESCRI	:= aRegs[nI][4]
			SX5->X5_DESCSPA	:= aRegs[nI][5]
			SX5->X5_DESCENG	:= aRegs[nI][6]
		SX5->(MsUnLock())
	EndIf
Next nI

RestArea(aArea)
Return('SX5 : ' + cTexto + CHR(13) + CHR(10))

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � UpdEmp   � Autor � Luciano Aparecido     � Data � 15.05.07 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Trata Empresa. Verifica as Empresas para Atualizar         ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Atualizacao PLS                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function  UpdEmp(aRecnoSM0,lOpen)
Local cVar		:= Nil
Local oDlg		:= Nil
Local cTitulo	:= "Escolha a(s) Empresa(s) que ser�(�o) Atualizada(s)"
Local lMark		:= .F.
Local oOk		:= LoadBitmap( GetResources(), "CHECKED" )   //CHECKED    //LBOK  //LBTIK
Local oNo		:= LoadBitmap( GetResources(), "UNCHECKED" ) //UNCHECKED  //LBNO
Local oChk		:= Nil
Local bCode		:= {||oDlg:End(),Processa({|lEnd| ProcATU(@lEnd,aRecnoSM0,lOpen)},"Processando","Aguarde, processando prepara��o dos arquivos",.F.)}
Private lChk	:= .F.
Private oLbx	:= Nil

If ( lOpen := MyOpenSm0Ex() )
	dbSelectArea("SM0")
	
	/////////////////////////////////////////
	//| Carrega o vetor conforme a condicao |/
	//////////////////////////////////////////
	dbGotop()
	While !Eof()
		If Ascan(aRecnoSM0,{ |x| x[3] == M0_CODIGO}) == 0 //--So adiciona no aRecnoSM0 se a empresa for diferente
			Aadd(aRecnoSM0,{lMark,Recno(),M0_CODIGO,M0_CODFIL,M0_NOME+"/ "+M0_FILIAL})
		EndIf
		dbSkip()
	EndDo
	
	///////////////////////////////////////////////////
	//| Monta a tela para usuario visualizar consulta |
	///////////////////////////////////////////////////
	If Len( aRecnoSM0 ) == 0
		Aviso( cTitulo, "Nao existe bancos a consultar", {"Ok"} )
		Return
	Endif
	
	DEFINE MSDIALOG oDlg TITLE cTitulo FROM 0,0 TO 240,500 PIXEL
	
	@ 10,10 LISTBOX oLbx VAR cVar FIELDS HEADER ;
	" ", "Recno", "Cod Empresa","Cod Filial","Empresa /Filial" ;
	SIZE 230,095 OF oDlg PIXEL ON dblClick(aRecnoSM0[oLbx:nAt,1] := !aRecnoSM0[oLbx:nAt,1],oLbx:Refresh())
	
	oLbx:SetArray( aRecnoSM0)
	oLbx:bLine := {|| {Iif(aRecnoSM0[oLbx:nAt,1],oOk,oNo),;
	aRecnoSM0[oLbx:nAt,2],;
	aRecnoSM0[oLbx:nAt,3],;
	aRecnoSM0[oLbx:nAt,4],;
	aRecnoSM0[oLbx:nAt,5]}}
	
	////////////////////////////////////////////////////////////////////
	//| Para marcar e desmarcar todos existem duas op�oes, acompanhe...
	////////////////////////////////////////////////////////////////////
	
	@ 110,10 CHECKBOX oChk VAR lChk PROMPT "Marca/Desmarca" SIZE 60,007 PIXEL OF oDlg ;
	ON CLICK(aEval(aRecnoSM0,{|x| x[1]:=lChk}),oLbx:Refresh())
	
	DEFINE SBUTTON FROM 107,213 TYPE 1 ACTION Eval(bCode) ENABLE OF oDlg
	ACTIVATE MSDIALOG oDlg CENTER
Endif

Return