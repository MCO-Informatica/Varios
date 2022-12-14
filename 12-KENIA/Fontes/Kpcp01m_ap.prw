#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function Kpcp01m()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
//? Declaracao de variaveis utilizadas no programa atraves da funcao    ?
//? SetPrvt, que criara somente as variaveis definidas pelo usuario,    ?
//? identificando as variaveis publicas do sistema utilizadas no codigo ?
//? Incluido pelo assistente de conversao do AP6 IDE                    ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?

SetPrvt("_CALIAS,_NRECNO,_NORDEM,_CPRODEXC,_CPRODINC,_CARTIGO")
SetPrvt("_NFATOR,CQUERY,")

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽?
굇쿛rograma  ? KPCP01M  ? Autor 쿗uciano Lorenzetti     ? Data ?11/09/2000낢?
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙?
굇쿏escricao ? Troca de Componentes na Estrutura dos Produtos             낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇쿢so       ? Kenia Industrias Texteis Ltda                              낢?
굇쳐컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇?            ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL           낢?
굇쳐컴컴컴컴컴컴컫컴컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇?   Analista   ?  Data  ?             Motivo da Alteracao               낢?
굇쳐컴컴컴컴컴컴컵컴컴컴컴탠컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇쿝icardo Correa?31/01/01쿔nclusao de Parametro p/Selecionar Artigo      낢?
굇읕컴컴컴컴컴컴컨컴컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複?
/*/

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
*                                                                           *
* Essa rotina foi desenvolvida por solicitacao do Sr. Joacir (Laborat줿io), *
* para permitir a troca de produtos em uma estrutura de produtos pois,      *
* diversas substancias quimicas param de ser comercializadas em detrimento  *
* de outras novas, havendo portanto a necessidade de rastrear todas as      *
* estruturas e troc?-las ( alterando sua concentracao - quantidade).        *
*                                                                           *
* Os unicos campos alterados sao: codigo(G1_COMP) e quantidade(G1_QUANT).   *
* Nao ha atualmente tratamento de perdas, portanto esse campo nao foi usado.*
* Todas as trocas sao de 1 para 1, ou seja, retira-se um componente e em    *
* seu lugar coloca-se outro. Trocas entre mais de um produto (1->N), (N->1) *
* e (N->N), serao feitas manualmente. Para auxiliar a localizar esses casos,*
* foi  criado o relat줿io RELESTRU.PRW                                      *
*                                                                           *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
//? Guarda Ambiente 														  ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
_cAlias := ALIAS()
_nRecno := RECNO()
_nOrdem := INDEXORD()

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
//? Desenha a tela de apresentacao da rotina								  ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
_cProdEXC := Space(15)
_cProdINC := Space(15)
_cArtINI  := Space(15)
_cArtFIM  := Space(15)
_cCorINI  := Space(03)
_cCorFIM  := Space(03)
_cCliINI  := Space(03)
_cCliFIM  := Space(03)

_nFator   := 0
@ 096,042 TO 650,850 DIALOG oDlg1 TITLE "Troca de Compomente na Estrutura"
@ 008,010 TO 200,350
@ 170,168 BMPBUTTON TYPE 1 ACTION TROCA()// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> @ 95,168 BMPBUTTON TYPE 1 ACTION Execute(TROCA)
@ 170,196 BMPBUTTON TYPE 2 ACTION Close(oDlg1)
@ 020,014 SAY "Esta rotina tem como objetivo executar a troca de produtos da estrutura"
@ 035,014 SAY "Digite o Componente a ser Excluido : "
@ 035,120 GET _cProdEXC Picture "@!"  F3("SB1") Object CodEXC SIZE 100,20
@ 050,014 SAY "Digite o Componente a ser Incluido : "
@ 050,120 GET _cProdINC Picture "@!"  F3("SB1") Object CodINC SIZE 100,20
@ 065,014 SAY "Fator de Troca : (Qtde Entra / Qtde Sai)"
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

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
//? Retorna Ambiente														  ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
dbSelectArea(_cAlias)
dbSetOrder(_nOrdem)
dbGoto(_nRecno)

RETURN


/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽?
굇쿑un뇙o	 ? TROCA	? Autor ? Luciano Lorenzetti	? Data ? 11.09.00 낢?
굇쳐컴컴컴컴컨컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙?
굇?    Essa rotina verifica e executa a troca dos codigos.				  낢?
굇읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽?/*/
// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> FUNCTION TROCA
Static FUNCTION TROCA()

//////////////////////////////////////////////////////////
/// Verificacao de situacoes nao permitidas...
//////////////////////////////////////////////////////////
if Empty(_cProdEXC)
   MSGBOX("Nao foi informado o codigo do produto a ser excluido !")
   Return
EndIf

if Empty(_cProdINC)
   MSGBOX("Nao foi informado o codigo do produto a ser incluido !")
   Return
EndIf

if _nFator == 0
   MSGBOX("Nao foi informado o fator de troca !")
   Return
EndIf

dbSelectArea("SB1")
dbSetOrder(1)
dbGoTop()
If !dbSeek(xFilial("SB1")+_cProdINC)
   MSGBOX(" O produto a ser incluido, nao existe no cadastro de produtos !")
   Return
EndIf

dbSelectArea("SG1")
dbSetOrder(1)
dbGoTop()
If dbSeek(xFilial("SG1")+_cProdEXC)
   MSGBOX(" O produto a ser excluido nao e' uma materia prima, pois possui estrutura !")
   Return
EndIf
dbGoTop()
If dbSeek(xFilial("SG1")+_cProdINC)
   MSGBOX(" O produto a ser incluido nao e' uma materia prima, pois possui estrutura !")
   Return
EndIf

dbSelectArea("SG1")
dbSetOrder(2)
dbGoTop()
If !dbSeek(xFilial("SG1")+_cProdEXC)
   MSGBOX(" O produto a ser excluido nao faz parte da estrutura de nenhum produto!")
   Return
EndIf

If MSGBOX("Tem certeza da troca que foi informada ?","Atencao:","YESNO")
   Processa({|| PROC_SG1()})// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==>    Processa({|| Execute(PROC_SG1)})
EndIf

Close(oDlg1)

Return

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽?
굇쿑un뇙o	 ? Proc_SG1 ? Autor ? Luciano Lorenzetti	? Data ? 11.09.00 낢?
굇쳐컴컴컴컴컨컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙?
굇?    Essa rotina verifica e executa a troca dos codigos.				  낢?
굇읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽?/*/
// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> FUNCTION PROC_SG1
Static FUNCTION PROC_SG1()

//cQuery := " UPDATE "+ RetSQLName("SG1")
//cQuery := cQuery + "  SET G1_COMP= '"+ ALLTRIM(_cProdINC) +"' , G1_QUANT = G1_QUANT * "+STR(_nFator)
//cQuery := cQuery + "  WHERE SUBSTRING(G1_COD,1,3)= '" + _cArtigo + "' AND G1_COMP= '" + ALLTRIM(_cProdEXC) +  "' AND D_E_L_E_T_<>'*'"

//---->SE CLIENTE INFORMADO TRATA-SE DE TECIDOS DE TERCEIROS
If Len(Alltrim(_cCliINI)) > 0

	cQuery := " UPDATE "+ RetSQLName("SG1")
	cQuery := cQuery + "  SET G1_COMP= '"+ ALLTRIM(_cProdINC) +"' , G1_QUANT = ROUND(G1_QUANT * "+STR(_nFator)+",4)"
	cQuery := cQuery + "  WHERE SUBSTRING(G1_COD,1,3) BETWEEN '" + Alltrim(_cCliINI) + "' AND '"+ Alltrim(_cCliFIM) + "' AND "
	cQuery := cQuery + "  SUBSTRING(G1_COD,4,3) BETWEEN '" + Alltrim(_cCorINI) + "' AND '"+ Alltrim(_cCorFIM) + "' AND "
	cQuery := cQuery + "  SUBSTRING(G1_COD,7,9) BETWEEN '" + Alltrim(_cArtINI) + "' AND '"+ Alltrim(_cArtFIM) + "' AND "
	cQuery := cQuery + "  G1_COMP= '" + ALLTRIM(_cProdEXC) +  "' AND D_E_L_E_T_<>'*'"

Else

	cQuery := " UPDATE "+ RetSQLName("SG1")
	cQuery := cQuery + "  SET G1_COMP= '"+ ALLTRIM(_cProdINC) +"' , G1_QUANT = ROUND(G1_QUANT * "+STR(_nFator)+",4)"
	cQuery := cQuery + "  WHERE G1_COD BETWEEN '" +Alltrim(_cArtINI)+Alltrim(_cCorINI) + "' AND '" + Alltrim(_cArtFIM)+Alltrim(_cCorFIM) + "' AND G1_COMP= '" + ALLTRIM(_cProdEXC) +  "' AND D_E_L_E_T_<>'*'"
	
EndIf

TCSQLExec(cQuery)

MSGBOX("Foram executadas as trocas necessarias.","Aviso:","ALERT")

RETURN

