#include "rwmake.ch"

User Function LICUS04I()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ LICUS04I บ Autor ณ Rodrigo - Correa    บ Data ณ  08/06/07  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Monta tela para Inclusao da Planilha de Custo              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Inclusao                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

CC		:=	.F.
COPCAO	:=	"Incluir"
cTitulo	:=	"Cadastro de Planilha de Custo"
aRotina	:= {{ "Pesquisa","AxPesqui", 0 , 1},;
{ "Visual",  "AxVisual", 0 , 72},;
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

RegToMemory("SZ5",(cOpcao == "Incluir")) //cabecalho

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Cria aHeader e aCols da GetDados                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
nUsado:=0
dbSelectArea("SX3")
dbSeek("SZ8")      //itens
aHeader:={}

While !Eof().And.(X3_ARQUIVO=="SZ8")
	If X3USO(x3_usado).AND. ALLTRIM(X3_CAMPO) <> "Z8_CODINT"
		nUsado:=nUsado+1
		Aadd(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,;
		x3_tamanho, x3_decimal,,;
		x3_usado, x3_tipo, x3_arquivo, x3_context, x3_when } )
	ENDIF
	dbSkip()
End

_nCont := 99
aCols:={}
aCols:={Array(nUsado+1)}
For _ni:=1 to nUsado
	aCols[1,_ni]:=CriaVar(aHeader[_ni,2])
Next
aCols[1,nUsado+1]:=.F.
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Executa a Modelo 3                                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

DbSelectArea("SZ5")

cAliasEnchoice := "SZ5"
cAliasGetD := "SZ8"
cLinOk := "ALLWAYSTRUE()"
cTudOk := "ALLWAYSTRUE()"
cFieldOk := "ALLWAYSTRUE()"
aCpoEnchoice:={}
//
_lRet:= Modelo3(cTitulo,"SZ5","SZ8",aCpoEnchoice,cLinOk,cTudOk,nOpcE,nOpcG,cFieldOk,,_nCont)



//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Executar processamento                                       ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//
If _lRet .AND. LEN(ACOLS) > 0
	
	DbSelectArea("SZ5")
	RecLock("SZ5",.T.)
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
	
	//    MSMM(SZC->SZC_CMEDES ,80,,M->SZC_DESOCO ,1,,,"SZC","SZC_CMEDES")
	//    MSMM(SZC->SZC_CMEAVO ,80,,M->SZC_AVAOCO ,1,,,"SZC","SZC_CMEAVO")
	//    MSMM(SZC->SZC_CMEINV ,80,,M->SZC_INVOCO ,1,,,"SZC","SZC_CMEINV")
	//    MSMM(SZC->SZC_CMEANA ,80,,M->SZC_ANALDI ,1,,,"SZC","SZC_CMEANA")
	
	DBSELECTAREA("SZ8")
	For i:= 1 to len(Acols)
		If !Acols[i,21]
			Reclock("SZ8",.T.)
			Replace Z8_CODINT	  WITH  SZ5->Z5_CODINT
			Replace	Z8_GRUPO	  WITH  ACOLS[i,1]
			Replace	Z8_CODIGO	  WITH  ACOLS[i,2]
			Replace	Z8_DESCPRO	  WITH  ACOLS[i,3]
			Replace	Z8_UNIDADE    WITH  ACOLS[i,4]
			Replace Z8_CONSUMO	  WITH  ACOLS[i,5]
			Replace	Z8_IPI	      WITH  ACOLS[i,6]
			Replace	Z8_ICMS	      WITH  ACOLS[i,7]
			Replace	Z8_COFINS	  WITH  ACOLS[i,8]
			Replace	Z8_PIS	      WITH  ACOLS[i,9]
			Replace	Z8_MAQUINA	  WITH  ACOLS[i,10]
			Replace	Z8_DESCMAQ	  WITH  ACOLS[i,11]
			Replace	Z8_NOPER      WITH  ACOLS[i,12]
			Replace	Z8_NCAVIDA	  WITH  ACOLS[i,13]
			Replace	Z8_CICLO	  WITH  ACOLS[i,14]
			Replace	Z8_PRODHOR	  WITH  ACOLS[i,15]
			Replace	Z8_CUNICIM	  WITH  ACOLS[i,16]
			Replace	Z8_CUNISIM	  WITH  ACOLS[i,17]
			Replace	Z8_PERDA      WITH  ACOLS[i,18]
			Replace	Z8_TOTAL	  WITH  ACOLS[i,19]
			Replace	Z8_PARTIC	  WITH  ACOLS[i,20]
		
			MsUnlock()
		Endif
	Next
	dbselectarea("SZ5")
	Return(.T.)
Endif

dbselectarea("SZ5")
Return(.T.)        // incluido pelo assistente de conversao do AP5 IDE em 03/10/01
