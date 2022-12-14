#include "rwmake.ch" 

User Function LICUS04V()        

/*/
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北赏屯屯屯屯脱屯屯屯屯屯送屯屯屯淹屯屯屯屯屯屯屯屯屯退屯屯屯淹屯屯屯屯屯屯槐?
北篜rograma  ? LICUS04V ? Autor ? Rodrigo CORREA     ? Data ?  08/06/07   罕?
北掏屯屯屯屯拓屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯褪屯屯屯贤屯屯屯屯屯屯贡?
北篋escricao ? Visualizacao da Planilha de Custo            			  罕?
北?          ? 												              罕?
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡?
北篣so       ? Visualizar                                                 罕?
北韧屯屯屯屯拖屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯急?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌
/*/

CC :=.F.
COPCAO := "Visualizar"
cTitulo:="Planilha de Custo"
aRotina := {{ "Pesquisa","AxPesqui", 0 , 1},;
{ "Visual",  "AxVisual", 0 , 2},;
{ "Inclui",  "AxInclui", 0 , 3},;
{ "Altera",  "AxAltera", 0 , 4},;
{ "Exclui",  "AxDeleta", 0 , 5}}

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//? Opcoes de acesso para a Modelo 3                             ?
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁

nOpcE:=2 ; nOpcG:=2

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//? Cria variaveis M->????? da Enchoice                          ?
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁

RegToMemory("SZ5") //szt - cabecalho (sz5) //szu - itens (sz8) 

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//? Cria aHeader e aCols da GetDados                             ?
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁

nUsado:=0
dbSelectArea("SX3")
dbSeek("SZ8")  
aHeader:={}

While !Eof().And.(X3_ARQUIVO=="SZ8")
	If X3USO(x3_usado).AND. ALLTRIM(X3_CAMPO) <> "Z8_CODINT"	
		nUsado:=nUsado+1
		Aadd(aHeader,{TRIM(x3_titulo),x3_campo,x3_picture,;
		x3_tamanho,x3_decimal,,;
		x3_usado,x3_tipo,x3_arquivo,x3_context } )
	ENDIF
	dbSkip()
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

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//? Executa a Modelo 3                                           ?
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁

dbselectarea("SZ5")

cAliasEnchoice:="SZ5"
cAliasGetD:="SZ8"
cLinOk:="ALLWAYSTRUE()"
cTudOk := "ALLWAYSTRUE()"
cFieldOk:="ALLWAYSTRUE()"

_lRet:= Modelo3(cTitulo,"SZ5","SZ8",,cLinOk,cTudOk,nOpcE,nOpcG,cFieldOk,,_nCont)

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//? Executar processamento                                       ?
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁

If _lRet .AND. LEN(ACOLS) > 0
	Dbselectarea("SZ5")
	Return(.T.)
Else
	Dbselectarea("SZ5")
	Return(.T.)
EndIf