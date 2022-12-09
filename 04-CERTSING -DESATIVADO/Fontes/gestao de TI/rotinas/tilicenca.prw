#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NOVO3     �Autor  �Microsiga           � Data �  07/31/09   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function TILicenca()

Local dDataFim	:= CtoD("31/08/2010")
Local aPswRet	:= {}

PswOrder(1)
If !PswSeek(__cUserID,.T.)
	MsgStop("Problemas com cadastro de usu�rios do sistema "+__cUserID+"...")
	Return(.F.)
Endif

aPswRet	:= Aclone( PSWRET(1) )

If aPswRet[1][1] == "000000"
	MsgStop("Rotina n�o autorizada para este tipo de usu�rio Administrador...")
	Return(.F.)
Endif

Return(.T.)

If dDataFim >= Date() .AND. dDataFim - Date() <= 15
	MsgStop("ATEN��O, A licen�a deste aplicativo vence em "+DtoC(dDataFim)+"..."+CRLF+" Entre em contato com o fornecedor da solu��o para liberar uma nova licen�a.")
Endif

If dDataFim < Date()
	MsgStop("ATEN��O, A licen�a deste aplicativo expirou em "+DtoC(dDataFim)+"..."+CRLF+" Entre em contato com o fornecedor da solu��o para liberar uma nova licen�a.")
	Return(.F.)
Endif

If cEmpAnt <> "99"
	If !CheckQtdReg(100)
		MsgStop("Quantidade de registros por tabela ultrapassou o limite permitido...")
		Return(.F.)
	Else
		Return(.T.)
	Endif
Endif

Return(.T.)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TILICENCA �Autor  �Microsiga           � Data �  08/07/09   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function CheckQtdReg(nQtdReg)

Local aTabelas		:= {}
Local nI			:= 0
Local cQuery		:= ()
Local lLimite		:= .F.
Local cAlias		:= ""

SX2->( DbSetOrder(1) )		// X2_CHAVE
SX2->( MsSeek( "U0" ) )
While SubStr(SX2->X2_CHAVE,1,2) = "U0"
	Aadd( aTabelas, { SX2->X2_ARQUIVO, nQtdReg } )
	SX2->( DbSkip() )
End

If Len(aTabelas) == 0
	MsgStop("As tabelas deste m�dulo ainda n�o foram criadas no dicion�rio de dados...")
	UserException("As tabelas do modulo de gestao de TI e infraestrutura nao foram criadas no dicionario de dados.")
Endif

For nI := 1 To Len(aTabelas)
	
	cAlias := SubStr(aTabelas[nI][1],1,3)
	DbSelectArea(cAlias)		// Cria as tabelas quando entra pela primeira vez.
	
	// Verifica a quantidade de registro por tabela.
	cQuery := "SELECT COUNT(*) CHK_QTDREC FROM " + aTabelas[nI][1]
	PLSQuery( cQuery, "CHKEMP" )
	If CHKEMP->CHK_QTDREC > aTabelas[nI][2]
		lLimite := .T.
	Endif
	CHKEMP->( DbCloseArea() )
	
	If !lLimite
		// Verifica se os registros foram apagados na tentativa de fraudar o sistema
		// Utiliza o numero do R_E_C_N_O_ gerado pelo TOP.
		cQuery := "SELECT MAX(R_E_C_N_O_) CHK_MAXREC FROM " + aTabelas[nI][1]
		PLSQuery( cQuery, "CHKEMP" )
		If CHKEMP->CHK_MAXREC > aTabelas[nI][2]
			lLimite := .T.
		Endif
		CHKEMP->( DbCloseArea() )
	Endif
	
	If lLimite
		Return(.F.)
	Endif
Next nI

Return(.T.)
