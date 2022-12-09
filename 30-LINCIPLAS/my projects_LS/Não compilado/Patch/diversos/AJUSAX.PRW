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
MsgRun( "Ajustando Empresa " + aEmp[i,1], , {|| cMsg += AjustSB1( aEmp[i] ), RpcClearEnv() } )
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
Static Function AjustSB1(aEmp)
*=====================================*
Local aX3, aStru, nTopErr := 0
cEmp := aEmp[1]; cFil := aEmp[2]

RpcSetType(3)
RpcSetEnv(cEmp, cFil)

IF !SX2->(DBSEEK("SB1"))
Return cEmp+": Não tem SB1 no SX2" + NL
ENDIF

IF ! TcCanOpen(SX2->X2_ARQUIVO)
Return cEmp+": Não houve alterações" + NL
Endif

IF !ChkFile("SB1", .T.)  // Tenta abrir a tabela em modo exclusivo para alterar
Return cEmp+": Não pode abrir SB1 exclusivo" +NL
ENDIF
aStru := SB1->(DBSTRUCT())
SB1->(DBCLOSEAREA())

SX3->(DBSETORDER(1))

IF SX3->(DBSEEK("B1_FILIAL+B1_COD"))
RecLock("SX3", .F.)
SX3->X3_TAMANHO := 18
SX3->X3_PICTURE := "9999999999999999999"
SX3->(MSUNLOCK())
ENDIF

IF SX3->(DBSEEK("B1_FILIAL+B1_COD"))
RecLock("SX3", .F.)
SX3->X3_TAMANHO := 18
SX3->X3_PICTURE := "9999999999999999999"
SX3->(MSUNLOCK())
ENDIF

// Monta a estrutura em SX3 p/ comparação
SX3->(DBSETORDER(1))

SX3->(DBSEEK("B1_FILIAL+B1_COD"));  aX3 := {}

While SX3->(!EOF() .and. X3_ARQUIVO=="SB1")
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



