#include "rwmake.ch"

User Function KPCP17M()


SetPrvt("_CALIAS,_NRECNO,_NORDEM,_CPRODEXC,_CPRODINC,_CARTIGO")
SetPrvt("_NFATOR,CQUERY,")

_cAlias := ALIAS()
_nRecno := RECNO()
_nOrdem := INDEXORD()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Desenha a tela de apresentacao da rotina								  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_cProdEXC := Space(15)
_cProdINC := Space(15)
_cArtINI  := Space(15)
_cArtFIM  := Space(15)
_cCorINI  := Space(03)
_cCorFIM  := Space(03)
_cCliINI  := Space(06)
_cCliFIM  := Space(06)

_nFator   := 0
@ 096,042 TO 650,850 DIALOG oDlg1 TITLE "Aumento de Preços - Terceiros"
@ 008,010 TO 200,350
@ 170,168 BMPBUTTON TYPE 1 ACTION TROCA()// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> @ 95,168 BMPBUTTON TYPE 1 ACTION Execute(TROCA)
@ 170,196 BMPBUTTON TYPE 2 ACTION Close(oDlg1)
@ 020,014 SAY "Esta rotina tem como objetivo aumentar os preços de terceiros"
//@ 035,014 SAY "Digite o Componente a ser Excluido : "
//@ 035,120 GET _cProdEXC Picture "@!"  F3("SB1") Object CodEXC SIZE 100,20
//@ 050,014 SAY "Digite o Componente a ser Incluido : "
//@ 050,120 GET _cProdINC Picture "@!"  F3("SB1") Object CodINC SIZE 100,20
@ 065,014 SAY "Fator de Aumento :"
@ 065,120 GET _nFator   Picture "999.999999" SIZE 100,20
@ 080,014 SAY "Do Cliente : "
@ 080,120 GET _cCliINI  Picture "@!" SIZE 100,20
@ 095,014 SAY "Ate o Cliente : "
@ 095,120 GET _cCliFIM  Picture "@!" SIZE 100,20
@ 110,014 SAY "Do Artigo : "
@ 110,120 GET _cArtINI  Picture "@!" SIZE 100,20
@ 125,014 SAY "Ate o Artigo : "
@ 125,120 GET _cArtFIM  Picture "@!" SIZE 100,20
@ 140,014 SAY "Do Cor : "
@ 140,120 GET _cCorINI  Picture "@!" SIZE 100,20
@ 155,014 SAY "Ate a Cor : "
@ 155,120 GET _cCorFIM  Picture "@!" SIZE 100,20


ACTIVATE DIALOG oDlg1 Center

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Retorna Ambiente														  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea(_cAlias)
dbSetOrder(_nOrdem)
dbGoto(_nRecno)

RETURN


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ TROCA	³ Autor ³ Luciano Lorenzetti	³ Data ³ 11.09.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³    Essa rotina verifica e executa a troca dos codigos.				  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> FUNCTION TROCA
Static FUNCTION TROCA()

//////////////////////////////////////////////////////////
/// Verificacao de situacoes nao permitidas...
//////////////////////////////////////////////////////////
if _nFator == 0
   MSGBOX("Nao foi informado o fator de aumento !")
   Return
EndIf

If MSGBOX("Tem certeza que deseja aumentar os preços ?","Atencao:","YESNO")
   Processa({|| PROC_SG1()})// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==>    Processa({|| Execute(PROC_SG1)})
EndIf

Close(oDlg1)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ Proc_SG1 ³ Autor ³ Luciano Lorenzetti	³ Data ³ 11.09.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³    Essa rotina verifica e executa a troca dos codigos.				  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> FUNCTION PROC_SG1
Static FUNCTION PROC_SG1()

cQuery := " UPDATE "+ RetSQLName("SZC")
cQuery := cQuery + "  SET ZC_PRECO = ROUND(ZC_PRECO * "+STR(_nFator)+",4)"
cQuery := cQuery + "  WHERE ZC_CLIENTE BETWEEN '" + Alltrim(_cCliINI) + "' AND '"+ Alltrim(_cCliFIM) + "' AND "
cQuery := cQuery + "  SUBSTRING(ZC_CODPRO,4,3) BETWEEN '" + Alltrim(_cCorINI) + "' AND '"+ Alltrim(_cCorFIM) + "' AND "
cQuery := cQuery + "  SUBSTRING(ZC_CODPRO,7,9) BETWEEN '" + Alltrim(_cArtINI) + "' AND '"+ Alltrim(_cArtFIM) + "' AND "
cQuery := cQuery + "  D_E_L_E_T_<>'*'"


TCSQLExec(cQuery)

MSGBOX("Preços de terceiros atualizado com sucesso!!!","Aviso:","ALERT")

RETURN

