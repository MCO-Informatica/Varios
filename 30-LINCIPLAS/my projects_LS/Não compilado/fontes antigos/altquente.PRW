#include "protheus.ch"
#DEFINE NL CHR(13)+CHR(10)

// Exemplo de como ajustar o tamanho de um campo "a quente" no Protheus
// Utiliza a função TCALTER para realizar a modificação

// Exemplo:
// lOk := TCAlter(cTable,aOldStru,aNewStru,@nTopErr)

// lOK -> .T. se conseguiu alterar a tabela
// cTable -> Nome físico da tabela no banco (ex: SB1010)
// aOldStru -> Estrutura atual da tabela
// aNewStru -> Nova estrutura da tabela
// @nTopErr -> Se der erro, retorna o código numérico do erro no TOP

*=====================================*
FUNCTION U_AjusAX()
*=====================================*
Local cMsg := ""
Local i, aEmp

aEmp := LoadEMP()

For i := 1 to LEN(aEmp)
MsgRun( "Ajustando Empresa " + aEmp[i,1], , {|| cMsg += AjustZAX( aEmp[i] ), RpcClearEnv() } )
Next

MsgInfo( cMsg, "Retorno" )

Return

*=====================================*
Static Function LoadEMP()
*=====================================*
Local cEmp := "", aRet := {}
OpenSM0(); SM0->(DBGOTOP())
While !SM0->(EOF())
IF ! SM0->M0_CODIGO $ cEmp
  cEmp += SM0->M0_CODIGO + ";"
  SM0->( AADD( aRet, {M0_CODIGO, M0_CODFIL} ) )
ENDIF
SM0->(DBSKIP())
Enddo
Return aRet

*=====================================*
Static Function AjustZAX(aEmp)
*=====================================*
Local aX3, aStru, nTopErr := 0
cEmp := aEmp[1]; cFil := aEmp[2]

RpcSetType(3)
RpcSetEnv(cEmp, cFil)

IF !SX2->(DBSEEK("ZAX"))
Return cEmp+": Não tem ZAX no SX2" + NL
ENDIF

IF ! TcCanOpen(SX2->X2_ARQUIVO)
Return cEmp+": Não houve alterações" + NL
Endif

IF !ChkFile("ZAX", .T.)  // Tenta abrir a tabela em modo exclusivo para alterar
Return cEmp+": Não pode abrir ZAX exclusivo" +NL
ENDIF
aStru := ZAX->(DBSTRUCT())
ZAX->(DBCLOSEAREA())

SX3->(DBSETORDER(2))

IF SX3->(DBSEEK("ZAX_REFMT1"))
RecLock("SX3", .F.)
SX3->X3_TAMANHO := 17
SX3->X3_PICTURE := "@R 999,999,999,999.99"
SX3->(MSUNLOCK())
ENDIF

IF SX3->(DBSEEK("ZAX_REFMT2"))
RecLock("SX3", .F.)
SX3->X3_TAMANHO := 17
SX3->X3_PICTURE := "@R 999,999,999,999.99"
SX3->(MSUNLOCK())
ENDIF

// Monta a estrutura em SX3 p/ comparação
SX3->(DBSETORDER(1))

SX3->(DBSEEK("ZAX01"));  aX3 := {}

While SX3->(!EOF() .and. X3_ARQUIVO=="ZAX")
IF SX3->X3_CONTEXT <> "V"
  SX3->( AADD( aX3, {X3_CAMPO, X3_TIPO, X3_TAMANHO, X3_DECIMAL} ))
ENDIF
SX3->(DBSKIP())
Enddo

IF TCAlter( Alltrim(SX2->X2_ARQUIVO), aStru, aX3, @nTopErr)
Return cEmp+": Alterado com sucesso" +NL
Else
Return cEmp+": Erro ao alterar - " + ALLTRIM(STR(nTopErr)) +NL
Endif

RpcClearEnv()
Return



//Read more: http://www.blacktdn.com.br/2011/12/protheus-advpl-top-dbaccess-sera-que-o.html#ixzz3m7r2jiWS