#include "rwmake.ch"

User Function LICUS04A()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ LICUS04A  บ Autor ณ RODRIGO CORREA       บ Data ณ 03/05/07 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Alteracao da Planilha de Custo       			      	  บฑฑ
ฑฑบ          ณ   								                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Linciplas Ltda                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
CC :=.F.
COPCAO := "Alteracao"
cTitulo:="Planilha de Custo"
aRotina := {{ "Pesquisa","AxPesqui", 0 , 1},;
{ "Visual",  "AxVisual", 0 , 2},;
{ "Inclui",  "AxInclui", 0 , 3},;
{ "Altera",  "AxAltera", 0 , 4},;
{ "Exclui",  "AxDeleta", 0 , 5}}

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Opcoes de acesso para a Modelo 3                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
nOpcE:=3 ; nOpcG:=3
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Cria variaveis M->????? da Enchoice                          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//

RegToMemory("SZ5")


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Cria aHeader e aCols da GetDados                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
nUsado:=0
dbSelectArea("SX3")
dbSeek("SZ8")
aHeader:={}
//
While !Eof().And.(X3_ARQUIVO=="SZ8")
	If X3USO(x3_usado).And. ALLTRIM(X3_CAMPO) <> "Z8_CODINT"
		nUsado:=nUsado+1
		Aadd(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,;
		x3_tamanho, x3_decimal,,;
		x3_usado, x3_tipo, x3_arquivo, x3_context } )
	Endif
	dbSkip()
End
_nCont := 99
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
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Executa a Modelo 3                                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Dbselectarea("SZ5")

cAliasEnchoice:="SZ5"
cAliasGetD:="SZ8"
cLinOk:="ALLWAYSTRUE()"
cTudOk := "ALLWAYSTRUE()"
cFieldOk:="ALLWAYSTRUE()"
//
_lRet:= Modelo3(cTitulo,"SZ5","SZ8",,cLinOk,cTudOk,nOpcE,nOpcG,cFieldOk,,_nCont)
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Executar processamento                                       ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//
If _lRet .AND. LEN(ACOLS) > 0
	
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
	For m := 1 to Len(aCols)
		DbSelectArea("SZ8")
		If !aCols[m,21]
			Reclock("SZ8",.T.)
			
			Replace Z8_CODINT	  WITH  SZ5->Z5_CODINT
			Replace	Z8_GRUPO	  WITH  ACOLS[m,1]
			Replace	Z8_CODIGO	  WITH  ACOLS[m,2]
			Replace	Z8_DESCPRO	  WITH  ACOLS[m,3]
			Replace	Z8_UNIDADE    WITH  ACOLS[m,4]
			Replace Z8_CONSUMO	  WITH  ACOLS[m,5]
			Replace	Z8_IPI	      WITH  ACOLS[m,6]
			Replace	Z8_ICMS	      WITH  ACOLS[m,7]
			Replace	Z8_COFINS	  WITH  ACOLS[m,8]
			Replace	Z8_PIS	      WITH  ACOLS[m,9]
			Replace	Z8_MAQUINA	  WITH  ACOLS[m,10]
			Replace	Z8_DESCMAQ	  WITH  ACOLS[m,11]
			Replace	Z8_NOPER      WITH  ACOLS[m,12]
			Replace	Z8_NCAVIDA	  WITH  ACOLS[m,13]
			Replace	Z8_CICLO	  WITH  ACOLS[m,14]
			Replace	Z8_PRODHOR	  WITH  ACOLS[m,15]
			Replace	Z8_CUNICIM	  WITH  ACOLS[m,16]
			Replace	Z8_CUNISIM	  WITH  ACOLS[m,17]
			Replace	Z8_PERDA      WITH  ACOLS[m,18]
			Replace	Z8_TOTAL	  WITH  ACOLS[m,19]
			Replace	Z8_PARTIC	  WITH  ACOLS[m,20]
			
			MsUnlock()
		Endif
	Next
	
	DbSelectArea("SZ5")
	DbSetOrder(2)
	If DbSeek(xFilial()+M->Z5_CODINT)
		RecLock("SZ5",.F.)
		
		SZ5->Z5_ORCAMEN	:= M->Z5_ORCAMEN  // ORCAMENTO
		ConfirmSX8()
		SZ5->Z5_NUMPROC	:= M->Z5_NUMPROC  // NUMERO PROCESSO DO CLIENTE
		SZ5->Z5_PROJETO	:= M->Z5_PROJETO  // PROJETO
		SZ5->Z5_EMISSAO	:= M->Z5_EMISSAO  // EMISSAO
		SZ5->Z5_CLIENTE	:= M->Z5_CLIENTE  // CODIGO CLIENTE
		SZ5->Z5_NOMECLI := M->Z5_NOMECLI  // NOME CLIENTE
		SZ5->Z5_PRODUTO	:= M->Z5_PRODUTO  // PRODUTO        - MP
		SZ5->Z5_CODINT	:= M->Z5_CODINT   // CODIGO INTERNO - PA
		SZ5->Z5_DESCPRO	:= M->Z5_DESCPRO  // DESCRICAO DO PRODUTO
		SZ5->Z5_VOLUME	:= M->Z5_VOLUME   // VOLUME DE PRODUCAO MENSAL
		SZ5->Z5_ICMS  	:= M->Z5_ICMS     // ICMS - VENDA
		SZ5->Z5_PIS  	:= M->Z5_PIS      // PIS - VENDA
		SZ5->Z5_COFINS  := M->Z5_COFINS   // COFINS - VENDA
		SZ5->Z5_CPMF	:= M->Z5_CPMF     // CPMF - VENDA
		SZ5->Z5_DESPADM := M->Z5_DESPADM  // DESPESAS ADMINISTRATIVAS - VENDAS
		SZ5->Z5_DESPCOM	:= M->Z5_DESPCOM  // DESPESAS COMERCIAIS - VENDAS
		SZ5->Z5_FRETE 	:= M->Z5_FRETE    // FRETE - VENDAS
		SZ5->Z5_LUCRO	:= M->Z5_LUCRO    // LUCRO - VENDAS
		SZ5->Z5_TAXAPER	:= M->Z5_TAXAPER  // TAXA PERIODO - VENDAS
		SZ5->Z5_CONDPAG	:= M->Z5_CONDPAG  // CONDICAO PAGTO - VENDAS
		SZ5->Z5_TAXADIA := M->Z5_TAXADIA  // TAXA DIA - VENDAS
		SZ5->Z5_OBS 	:= M->Z5_OBS      // OBSERVACAO
		
		
		MsUnlock()
	Endif
	Dbselectarea("SZ5")
	Return(.T.)
Else
	Dbselectarea("SZ5")
	Return(.T.)
Endif
