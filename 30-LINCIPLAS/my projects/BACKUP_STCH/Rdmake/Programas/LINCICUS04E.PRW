#include "rwmake.ch"

User Function LICUS04E()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ LICUS04E  º Autor ³ Rodrigo Correa    º Data ³  03/05/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Exclusao do Planilha de Custo        					  º±±
±±º          ³
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Linciplas                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
CC :=.F.
COPCAO := "Exclusao"
cTitulo:="Planiha de Custo"
aRotina := {{ "Pesquisa","AxPesqui", 0 , 1},;
{ "Visual",  "AxVisual", 0 , 2},;
{ "Inclui",  "AxInclui", 0 , 3},;
{ "Altera",  "AxAltera", 0 , 4},;
{ "Exclui",  "AxDeleta", 0 , 5}}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Opcoes de acesso para a Modelo 3                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nOpcE:=2 ; nOpcG:=2
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria variaveis M->????? da Enchoice                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//

RegToMemory("SZ5")


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria aHeader e aCols da GetDados                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nUsado:=0
dbSelectArea("SX3")
dbSeek("SZ8")
aHeader:={}

While !Eof().And.(X3_ARQUIVO=="SZ8")
	If X3USO(x3_usado).AND. ALLTRIM(X3_CAMPO) <> "Z8_CODINT"
		nUsado:=nUsado+1
		Aadd(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,;
		x3_tamanho, x3_decimal,,;
		x3_usado, x3_tipo, x3_arquivo, x3_context } )
	Endif
	DbSkip()
End

_nCont := 0
aCols  := { }
DbSelectArea("SZ8")
DbSetOrder(1)
If DbSeek(xFilial("SZ8") + M->Z5_CODINT)
	While !EOF() .and. SZ8->Z8_CODINT == M->Z5_CODINT
		AADD(aCols,Array(nUsado+1))
		For _i := 1 to 21
			
			//	aCols[Len(aCols),1]	:= SZ8->Z8_CODINT (CODIGO PA - AMARRAR CABEC X ITENS)
			aCols[Len(aCols),1]	:= SZ8->Z8_GRUPO   // GRUPO
			aCols[Len(aCols),2]	:= SZ8->Z8_CODIGO  // CODIGO MP - BUSCA NA SZ6)
			aCols[Len(aCols),3]	:= SZ8->Z8_DESCPRO // DESCRICAO - BUSCA NA SZ6)
			aCols[Len(aCols),4]	:= SZ8->Z8_UNIDADE // UNIDADE - BUSCA NA SZ6)
			aCols[Len(aCols),5]	:= SZ8->Z8_CONSUMO // COMSUMO P/ MIL - DIGITAVEL
			aCols[Len(aCols),6]	:= SZ8->Z8_IPI     // IPI - BUSCA NA SZ6
			aCols[Len(aCols),7]	:= SZ8->Z8_ICMS    // ICMS - BUSCA NA SZ6
			aCols[Len(aCols),8]	:= SZ8->Z8_COFINS  // COFINS - BUSCA NA SZ6
			aCols[Len(aCols),9]	:= SZ8->Z8_PIS     // PIS - BUSCA NA SZ6
			aCols[Len(aCols),10]:= SZ8->Z8_MAQUINA // MAQUINA
			aCols[Len(aCols),11]:= SZ8->Z8_DESCMAQ // DESCRICAO MAQUINA
			aCols[Len(aCols),12]:= SZ8->Z8_NOPER   // N. OPERARIOS - SO HABILITA NO GRUPO 4
			aCols[Len(aCols),13]:= SZ8->Z8_NCAVIDA // N. CAVIDADES - SO HABILITA NO GRUPO 5
			aCols[Len(aCols),14]:= SZ8->Z8_CICLO   // CICLO
			aCols[Len(aCols),15]:= SZ8->Z8_PRODHOR // PRODUCAO POR HORA
			aCols[Len(aCols),16]:= SZ8->Z8_CUNICIM // CUSTO UNITARIO COM IMPOSTO
			aCols[Len(aCols),17]:= SZ8->Z8_CUNISIM // CUSTO UNITARIO SEM IMPOSTO
			aCols[Len(aCols),18]:= SZ8->Z8_PERDA   // PERDA
			aCols[Len(aCols),19]:= SZ8->Z8_TOTAL   // TOTAL
			aCols[Len(aCols),20]:= SZ8->Z8_PARTIC  // PARTICIPACAO
		Next
		aCols[Len(aCols),21]	:= .F.
		DbSelectArea("SZ8")
		DbSkip()
	EndDo
EndIf

//
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Executa a Modelo 3                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbselectarea("SZ5")
//
cAliasEnchoice:="SZ5"
cAliasGetD:="SZ8"
cLinOk:="ALLWAYSTRUE()"
cTudOk := "ALLWAYSTRUE()"
cFieldOk:="ALLWAYSTRUE()"
//
_lRet:= Modelo3(cTitulo,"SZ5","SZ8",,cLinOk,cTudOk,nOpcE,nOpcG,cFieldOk,,_nCont)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Executar processamento                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//
If _lRet .AND. LEN(ACOLS) > 0
	
	dbselectarea("SZ5")
	DbSetOrder(2)
	If DbSeek(xFilial()+M->Z5_CODINT)
		RecLock("SZ5",.F.)
		DbDelete()
		MsUnlock()
	EndIF
	
	DbSelectArea("SZ8")
	DbSetOrder(1)
	If DbSeek(xFilial("SZ8") + M->Z5_CODINT)
		While !EOF() .and. M->Z5_CODINT == SZ8->Z8_CODINT
			RecLock("SZ8",.F.)
			DbDelete()
			MsUnlock()
			DbSkip()
		EndDo
	EndIf
	
	Dbselectarea("SZ5")
	Return(.T.)
	
Else
	
	Dbselectarea("SZ5")
	Return(.T.)
	
Endif
