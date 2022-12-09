#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function Kest01m()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("_LSAIR,_CBARRAS,_CPRODUTO,_CDESCRICAO,_CLOCAL,_CTIPO")
SetPrvt("_NSALDO,_NQTDINV,NQTDINV,_DDTVALID,_LRETORNO,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ KEST01M  ³ Autor ³Ricardo Correa de Souza³ Data ³28/05/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Inventario Atraves da Leitora Codigo de Barras             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Kenia Industrias Texteis Ltda                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   Analista   ³  Data  ³             Motivo da Alteracao               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
/*/                                                            
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Processamento                                                             *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

_lSair := .f.

While .T.

    _cBarras        := Space(13)
    _cProduto       := Space(15)
    _cDescricao     := Space(30)
    _cLocal         := Space(02)
    _cTipo          := Space(02)
    _nSaldo         := 0
    _nQtdInv        := 0

    @ 75,06  To 400,500 Dialog janela1 Title OemToAnsi("Inventario Atraves da Leitora Codigo de Barras")

    @  12,9  Say OemToAnsi("Codigo de Barras")
    @  32,9  Say OemToAnsi("Produto") Size 22,8
    @  52,9  Say OemToAnsi("Descricao") Size 37,8
    @  72,9  Say OemToAnsi("Almoxarifado") Size 37,8
    @  92,9  Say OemToAnsi("Tipo") Size 37,8
    @ 112,9  Say OemToAnsi("Saldo do Lote") Size 35,8
    @ 132,9  Say OemToAnsi("Qtde Inventariada") Size 68,8

    @  22,9  Get _cBarras  Picture "@!"                Valid BuscaLote()// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==>     @  22,9  Get _cBarras  Picture "@!"                Valid Execute(BuscaLote)
    @  42,9  Get _cProduto Picture "@!"                When .F.
    @  62,9  Get _cDescricao Picture "@!"              When .F.
    @  82,9  Get _cLocal Picture "@!"                  When .F.
    @ 102,9  Get _cTipo Picture "@!"                   When .F.
    @ 122,9  Get _nSaldo Picture "@E 999,999,999.99"   When .F.
    nQtdInv := _nSaldo
    @ 142,9  Get _nQtdInv  Picture "@E 999,999,999.99"
	
    @ 132,186 BmpButton Type 1 Action GravaInv()// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==>     @ 132,186 BmpButton Type 1 Action Execute(GravaInv)
    @ 132,216 BmpButton Type 2 Action CloseJan()// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==>     @ 132,216 BmpButton Type 2 Action Execute(CloseJan)

    If _lSair
		Exit
	EndIf

	Activate Dialog janela1
EndDo

//MarkBRefresh()

Return()

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Fim do Programa                                                           *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

*---------------------------------------------------------------------------*

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function GravaInv
Static Function GravaInv()
*---------------------------------------------------------------------------*

DbSelectArea("SB7")
DbSetOrder(1)

RecLock("SB7",.t.)
  SB7->B7_FILIAL    := xFilial("SB7")
  SB7->B7_COD       := _cProduto
  SB7->B7_LOCAL     := _cLocal
  SB7->B7_TIPO      := _cTipo
  SB7->B7_LOTECTL   := Subs(_cBarras,3,10)
  SB7->B7_QUANT     := _nQtdInv
  SB7->B7_DOC       := "IV"+Subs(Dtos(dDataBase),5,4)
  SB7->B7_DATA      := dDataBase
  SB7->B7_DTVALID   := dDataBase
MsUnLock()

Close(janela1)

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> __Return()
Return()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

*---------------------------------------------------------------------------*
// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function CloseJan
Static Function CloseJan()
*---------------------------------------------------------------------------*

_lSair := .T.

Close(janela1)

Return()

*---------------------------------------------------------------------------*

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function BuscaLote
Static Function BuscaLote()
*---------------------------------------------------------------------------*

DbSelectArea("SB8")
DbSetOrder(2)
IF DbSeek(xFilial("SB8")+Subs(_cBarras,7,6)+Subs(_cBarras,3,10))
   _cProduto       := SB8->B8_PRODUTO
   _cDescricao     := Posicione("SB1",1,xFilial("SB1")+_cProduto,"B1_DESC")
   _cLocal         := SB8->B8_LOCAL
   _cTipo          := Posicione("SB1",1,xFilial("SB1")+_cProduto,"B1_TIPO")
   _nSaldo         := SB8->B8_SALDO
   _dDtValid       := SB8->B8_DTVALID
   _nQtdInv        := _nSaldo
   _lRetorno := .t.
Else
    MsgBox("Nao existe o lote "+Subs(_cBarras,3,10)+" na Tabela de Saldos por Lote. Verifique se os dados da etiqueta estao corretos.","Valida Codigo de Barras","Stop")
    _lRetorno := .f.
EndIF

SysRefresh()

Return(_lRetorno)

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

