#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO3     ºAutor  ³Microsiga           º Data ³  07/31/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function TILicenca()

Local dDataFim	:= CtoD("31/08/2010")
Local aPswRet	:= {}

PswOrder(1)
If !PswSeek(__cUserID,.T.)
	MsgStop("Problemas com cadastro de usuários do sistema "+__cUserID+"...")
	Return(.F.)
Endif

aPswRet	:= Aclone( PSWRET(1) )

If aPswRet[1][1] == "000000"
	MsgStop("Rotina não autorizada para este tipo de usuário Administrador...")
	Return(.F.)
Endif

Return(.T.)

If dDataFim >= Date() .AND. dDataFim - Date() <= 15
	MsgStop("ATENÇÃO, A licença deste aplicativo vence em "+DtoC(dDataFim)+"..."+CRLF+" Entre em contato com o fornecedor da solução para liberar uma nova licença.")
Endif

If dDataFim < Date()
	MsgStop("ATENÇÃO, A licença deste aplicativo expirou em "+DtoC(dDataFim)+"..."+CRLF+" Entre em contato com o fornecedor da solução para liberar uma nova licença.")
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TILICENCA ºAutor  ³Microsiga           º Data ³  08/07/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
	MsgStop("As tabelas deste módulo ainda não foram criadas no dicionário de dados...")
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
