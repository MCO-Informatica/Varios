#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05
#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF

User Function Kpcp02r()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
//? Declaracao de variaveis utilizadas no programa atraves da funcao    ?
//? SetPrvt, que criara somente as variaveis definidas pelo usuario,    ?
//? identificando as variaveis publicas do sistema utilizadas no codigo ?
//? Incluido pelo assistente de conversao do AP6 IDE                    ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?

SetPrvt("TITULO,CSTRING,WNREL,CDESC,AORD,TAMANHO")
SetPrvt("LIMITE,ARETURN,CPERG,NLASTKEY,CBCONT,NQUANTITEM")
SetPrvt("CABEC1,COP,CDESCRI,CABEC2,NQUANT,NOMEPROG")
SetPrvt("NTIPO,CPRODUTO,CQTD,CINDSC2,NINDSC2,AARRAY")
SetPrvt("LI,CBTXT,M_PAG,COBSERV,XORDEM,LEND")
SetPrvt("DDTFIM,NLARGURA,CTIPOCONV,NFATORCONV,CETAPA,I")
SetPrvt("T,NCONV,_NPESO,_NMETRAG,NBEGIN,_C2RECNO")
SetPrvt("DDTAFIN,AARRAYPRO,LIMPITEM,NCNTARRAY,A01,A02")
SetPrvt("NX,NI,NL,NY,CNUM,CITEM")
SetPrvt("LIMPCAB,CDESCRI1,CDESCRI2,CCNT,CCABEC1,CCABEC2")
SetPrvt("_APERGUNTAS,_NLACO,")

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽?
굇쿛rograma  ? KPCP02R  ? Autor 쿝icardo Correa de Souza? Data ?26/07/2001낢?
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙?
굇쿏escricao ? Emissao das Ordens de Producao                             낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇쿢so       ? Kenia Industrias Texteis Ltda                              낢?
굇쳐컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇?            ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL           낢?
굇쳐컴컴컴컴컴컴컫컴컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇?   Analista   ?  Data  ?             Motivo da Alteracao               낢?
굇쳐컴컴컴컴컴컴컵컴컴컴컴탠컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇쿕efferson     ?21/02/02쿔nclusao da Observacao de Largura do Tecido    낢?
굇쿕efferson     ?13/07/02쿛arametro para Receita/Ficha/Ambas             낢?
굇쿕efferson     ?26/02/03쿔nclusao da Rama nas Opcoes de Maquinas        낢?
굇쿕efferson     ?31/03/03쿘odificacao Lay Out Ficha de Rolo              낢?
굇쿕efferson     ?21/04/03쿗ay Out Ficha de Rolo e Ajustar Cod + Desc Prod낢?
굇쿕efferson     ?22/10/04쿙ovo Lay Out Ficha de Rolo                     낢?
굇쿕efferson     ?20/11/04쿔mpressao do Grafico de Tingimento             낢?
굇읕컴컴컴컴컴컴컨컴컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複?
/*/

#IFNDEF WINDOWS
	// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 12/02/05 ==> 	#DEFINE PSAY SAY
#ENDIF

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Variaveis Utilizadas na Impressao do Relatorio                            *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

titulo   := "RECEITA PARA TINGIMENTO"
cString  := "SC2"
wnrel    :="KPCP02R"
cDesc    := "Este programa ira imprimir a Receita para Tingimento/Ficha de Rolo"
aOrd     := {"Por Numero","Por Produto","Por Centro de Custo","Por Prazo de Entrega"}
tamanho  := "P"
limite   := 80
nTipo    := 18
nLin     := 80
cbtxt    := Space(10)
aReturn  := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
cPerg    :="PCP02R    "
nLastKey := 0
cbcont   := 00
CONTFL   := 01
m_pag    := 01
aOrd     := {}
Pergunta()          // Caso nao exista Cria o grupo de perguntas

Pergunte(cPerg,.F.)

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//? Variaveis utilizadas para parametros                         ?
//? mv_par01            // Da OP                                 ?
//? mv_par02            // Ate a OP                              ?
//? mv_par03            // Da data                               ?
//? mv_par04            // Ate a data                            ?
//? mv_par05            // Imprime Nome Cientifico               ?
//? MV_PAR06            // Ambas / So Receita / So Ficha         ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

If !ChkFile("SH8",.F.)
	Help(" ",1,"SH8EmUso")
	Return()
Endif

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//? Envia controle para a funcao SETPRINT                        ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc,"","",.F.,aOrd)

If nLastKey == 27
	dbSelectArea("SH8")
	Set Filter To
	dbCloseArea()
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//? Retira o SH8 da variavel cFopened ref. a abertura no MNU     ?
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	ClosFile("SH8")
	dbSelectArea("SC2")
	Return()
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	dbSelectArea("SH8")
	Set Filter To
	dbCloseArea()
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//? Retira o SH8 da variavel cFopened ref. a abertura no MNU     ?
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	ClosFile("SH8")
	dbSelectArea("SC2")
	Return()
Endif

#IFDEF WINDOWS
	RptStatus({||R820Imp()})// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> 	RptStatus({||Execute(R820Imp)})
#ELSE
	R820Imp()
#ENDIF

Return(NIL)

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽?
굇쿑un뇙o    ? R820Imp  ? Autor ? Waldemiro L. Lustosa  ? Data ? 13.11.95 낢?
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙?
굇쿏escri뇙o ? Chamada do Relat줿io                                       낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇? Uso      ? MATR820                                                    낢?
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽?
/*/
// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function R820Imp
Static Function R820Imp()

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//? Define Variaveis                                             ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
CbCont:=""
nQuantItem:=0
cabec1:=""
cOp:=""
cDescri:=""
cabec2:=""
limite := 80
nQuant := 1
nomeprog   := "MATR820"
nTipo      := 18
cProduto   := SPACE(LEN(SC2->C2_PRODUTO))
cQtd       :=""
cIndSC2 := CriaTrab(NIL,.F.)
nIndSC2 :=0
aArray   :={}
li := 80
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//? Variaveis utilizadas para Impressao do Cabecalho e Rodape    ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
cbtxt    := SPACE(10)
cbcont   := 0
m_pag    := 1
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//? Monta os Cabecalhos                                          ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
cabec1 := ""
cabec2 := ""
nTotCus:= 0
nCusStd:= 0
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//? Observacoes                                                  ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

cObserv := ""
xORDEM  := Substr(mv_par01, 1, 6)
DbSelectArea("SC2")
DbSetOrder(1)

If DbSeek( xFilial("SC2") + xORDEM )
	While SC2->C2_FILIAL == xFilial("SC2") .and. ;
		Substr(SC2->C2_NUM,1,6) == xORDEM
		cObserv := cObserv + AllTrim(SC2->C2_OBS)
		DbSkip()
	EndDo
EndIf
/*
dbSelectArea("SC2")
If aReturn[8] == 4
#IFDEF AS400
IndRegua("SC2",cIndSC2,"C2_FILIAL+C2_DATPRF",,,"Selecionando Registros...")
#ELSE
IndRegua("SC2",cIndSC2,"C2_FILIAL+DTOS(C2_DATPRF)",,,"Selecionando Registros...")
#ENDIF

dbGoTop()
Else
dbSetOrder(aReturn[8])
EndIf
*/

dbSeek(xFilial("SC2")+xORDEM)

SetRegua(LastRec())

While !Eof() .And. SC2->C2_NUM <= Subs(mv_par02,1,6)
	
	#IFNDEF WINDOWS
		If LastKey() == 286    //ALT_A
			lEnd := .t.
			Exit
		End
	#ENDIF
	
	IF LastKEy()==27
		@ Prow()+1,001 PSAY "CANCELADO PELO OPERADOR"
		Exit
	EndIF
	
	IncRegua()
	
	If C2_FILIAL+C2_NUM+C2_ITEM+C2_SEQUEN < xFilial()+mv_par01 .or. C2_FILIAL+C2_NUM+C2_ITEM+C2_SEQUEN > xFilial()+mv_par02
		dbSkip()
		Loop
	EndIf
	
	If  C2_DATPRF < mv_par03 .Or. C2_DATPRF > mv_par04
		dbSkip()
		Loop
	Endif
	
	cProduto  := SC2->C2_PRODUTO
	nQuant    := SC2->C2_QUANT - SC2->C2_QUJE - SC2->C2_PERDA
	dDtFim    := SC2->C2_DATPRF
	nQtdCus	  := SC2->C2_QUANT - SC2->C2_QUJE - SC2->C2_PERDA
	nQtd2us	  := SC2->C2_QTSEGUM
	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek(xFilial()+cProduto)
	
	nLargura    :=	SB1->B1_X_LARG
	
	DbSelectArea("SZC")
	DbSetOrder(2)
	If DbSeek(xFilial("SZC")+cProduto)
		nLargura  := SZC->ZC_LARGURA
	EndIf
	
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//? Adiciona o primeiro elemento da estrutura , ou seja , o Pai  ?
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	
	cTipoConv  := SB1->B1_TIPCONV
	nFatorConv := SB1->B1_CONV
	
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//? Adiciona o primeiro elemento da estrutura , ou seja , o Pai  ?
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	AddAr820(nQuant)
	
	cOp:=SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN
	MontStruc()
	
	aSort( aArray,2,, { |x, y| (x[8]+x[7]) < (y[8]+y[7]) } )
	
	Li := 0                                 // linha inicial do relatorio
	
	
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
	//? Imprime cabecalho                                       ?
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
	
	If MV_PAR06 == 1 .Or. MV_PAR06 == 2
		
		cabecOp()  // MSG
		cEtapa  := "001"
		
		For I := 2 TO Len(aArray)
			
			DbSelectArea("SG1")
			DbSetOrder(1)
			DbSeek( xFilial("SG1") + aArray[1][1] + aArray[I][1] + aArray[I][7] )
			// Produto    + Etapa        + Sequencia
			
			
			//----> IMPRIME CUSTO DETALHADO
			If mv_par07 == 1
				If cEtapa <> SG1->G1_ETAPA
					@ Li , 000 PSAY "+----------+---------------+-------------------------+-----------+---+---------+"
					Li := Li + 1
					IF li > 63
						Li := 0
						cabecOp()               // imprime cabecalho da OP
					EndIF
					
					cEtapa := SG1->G1_ETAPA
				EndIf
				
				@ Li , 000 PSAY "| "
				//cQtd:= Alltrim(Transform(aArray[I][5],PesqPictQt("D4_QUANT",11,4)))
				cQtd:= aArray[I][5]
				
				nCusStd	:=	Iif(!Subs(aArray[I][2],1,6)$"TECIDO",Posicione("SB1",1,xFilial("SB1")+aArray[I][1],"B1_CUSTD"),0)
				
				
				
				
				@ Li , 002 PSAY SG1->G1_QUANT     PICTURE "@E 999.9999"      // QUANTIDADE DA ESTRUTURA
				@ Li , 011 PSAY "|"
				@ Li , 013 PSAY aArray[I][1]                                // CODIGO PRODUTO
				@ Li , 027 PSAY "|"
				@ li , 029 PSAY Substr(AllTrim(aArray[I][2]),1,23)          // DESCRICAO
				@ Li , 053 PSAY "|"
				@ li,  054 PSAY cQtd   PICTURE "@E 9999.999 9"                 // QUANTIDADE EMPENHADA
				@ Li , 065 PSAY "|"
				@ Li , 069 PSAY "|"
				@ Li , 070 PSAY cQtd * nCusStd PICTURE "@E 999.9999"
				@ Li , 079 PSAY "|"
				Li:=Li+1
				skip
				
				nTotCus	+=	(cQtd * nCusStd)
				
				//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
				//? Se nao couber, salta para proxima folha                 ?
				//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
				
				IF li > 63
					Li := 0
					cabecOp()               // imprime cabecalho da OP
				EndIF
				
			Else
				
				If cEtapa <> SG1->G1_ETAPA
					@ Li , 000 PSAY "+----------+---------------+-----------------------------------+-----------+---+"
					Li := Li + 1
					IF li > 63
						Li := 0
						cabecOp()               // imprime cabecalho da OP
					EndIF
					
					cEtapa := SG1->G1_ETAPA
				EndIf
				
				@ Li , 000 PSAY "| "
				//cQtd:= Alltrim(Transform(aArray[I][5],PesqPictQt("D4_QUANT",11,4)))
				cQtd:= aArray[I][5]
				@ Li , 002 PSAY SG1->G1_QUANT     PICTURE "@E 999.9999"      // QUANTIDADE DA ESTRUTURA
				@ Li , 011 PSAY "|"
				@ Li , 013 PSAY aArray[I][1]                                // CODIGO PRODUTO
				@ Li , 027 PSAY "|"
				@ li , 029 PSAY Substr(AllTrim(aArray[I][2]),1,28)          // DESCRICAO
				@ Li , 063 PSAY "|"
				@ li,  064 PSAY cQtd   PICTURE "@E 9999.999 9"                 // QUANTIDADE EMPENHADA
				@ Li , 075 PSAY "|"
				@ Li , 079 PSAY "|"
				Li:=Li+1
				skip
				
				//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
				//? Se nao couber, salta para proxima folha                 ?
				//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
				
				IF li > 63
					Li := 0
					cabecOp()               // imprime cabecalho da OP
				EndIF
				
			EndIf
		Next
		
		//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
		//? Imprimir Rodape                                              ?
		//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
		
		/*
		For T := 1 To 2   // COMPLETA DUAS LINHAS DO FORMULARIO
		@ Li , 000 PSAY "| "
		@ Li , 011 PSAY "|"
		@ Li , 026 PSAY "|"
		@ Li , 063 PSAY "|"
		@ Li , 075 PSAY "|"
		@ Li , 079 PSAY "|"
		Li := Li + 1
		Next
		*/
		
		If mv_par07 == 1
			@ Li , 000 PSAY "| "
			@ Li , 011 PSAY "|"
			@ Li , 026 PSAY "|"
			@ Li , 053 PSAY "|"
			@ Li , 065 PSAY "|"
			@ Li , 069 PSAY "|"
			@ Li , 079 PSAY "|"
			Li := Li + 1
			IF li > 63
				Li := 0
				cabecOp()               // imprime cabecalho da OP
			EndIF
			
			@ Li , 000 PSAY "| "
			@ Li , 011 PSAY "|"
			@ Li , 026 PSAY "| DATA PREVISAO.: " + Dtoc( dDtaFin )
			@ Li , 053 PSAY "|"
			@ Li , 065 PSAY "|"
			@ Li , 069 PSAY "|"
			@ Li , 079 PSAY "|"
			Li := Li + 1
			IF li > 63
				Li := 0
				cabecOp()               // imprime cabecalho da OP
			EndIF
			
			@ Li , 000 PSAY "+----------+---------------+-------------------------+-----------+---+---------+"
			Li := Li + 2
			IF li > 63
				Li := 0
				cabecOp()               // imprime cabecalho da OP
			EndIF
			
			@ Li, 059 PSAY "R$ TOTAL "
			@ Li, 069 PSAY nTotCus					Picture "@E 9999.9999"
			Li := Li + 1
			IF li > 63
				Li := 0
				cabecOp()               // imprime cabecalho da OP
			EndIF
			
			@ Li, 059 PSAY "R$ UNI/MT"
			@ Li, 069 PSAY (nTotCus/nQtdCus)		Picture "@E 9999.9999"
			Li := Li + 1
			IF li > 63
				Li := 0
				cabecOp()               // imprime cabecalho da OP
			EndIF
			
			@ Li, 059 PSAY "R$ UNI/KG"
			@ Li, 069 PSAY (nTotCus/nQtd2us)		Picture "@E 9999.9999"
			
			nTotCus:= 0
			
		Else
			@ Li , 000 PSAY "| "
			@ Li , 011 PSAY "|"
			@ Li , 026 PSAY "|"
			@ Li , 063 PSAY "|"
			@ Li , 075 PSAY "|"
			@ Li , 079 PSAY "|"
			Li := Li + 1
			IF li > 63
				Li := 0
				cabecOp()               // imprime cabecalho da OP
			EndIF
			
			@ Li , 000 PSAY "| "
			@ Li , 011 PSAY "|"
			@ Li , 026 PSAY "| DATA DE PREVISAO.: " + Dtoc( dDtaFin )
			@ Li , 063 PSAY "|"
			@ Li , 075 PSAY "|"
			@ Li , 079 PSAY "|"
			Li := Li + 1
			IF li > 63
				Li := 0
				cabecOp()               // imprime cabecalho da OP
			EndIF
			
			@ Li , 000 PSAY "+----------+---------------+-----------------------------------+-----------+---+"
			Li := Li + 2
			IF li > 63
				Li := 0
				cabecOp()               // imprime cabecalho da OP
			EndIF
			
		EndIf
		
		Li := Li + 2
		IF li > 63
			Li := 0
			cabecOp()               // imprime cabecalho da OP
		EndIF
		
		
		Grafico()
		Li := Li + 2
		
		Processos()
		Li := Li + 1
		
		
		//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
		//? Imprimi Ficha de Rolo                                        ?
		//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
	EndIf
	
	If MV_PAR06 == 1 .Or. MV_PAR06 == 3
		li := 000
		
		@ li , 000 PSAY Padc("KENIA           FICHA DE ROLO           PARTIDA "+SC2->C2_NUM+"         PREVISAO "+DTOC(SC2->C2_DATPRF),80)
		li := li + 1
		// RICARDO li := li + 1
		@ li , 000 PSAY "PRODUTO : "
		If MV_PAR06 == 3
			cDescri :=  Posicione("SB1",1,xFilial("SB1")+cProduto,"B1_DESC")
		EndIf
		@ li , 010 PSAY Alltrim(cProduto) + " "+Substr( cDescri,1 , 30 )
		@ li , 059 PSAY "TEAR    : "+ Subs(SC2->C2_TEAR,1,20)
		// RICARDO li := li + 2
		li := li + 1
		
		//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
		//? Verifica conversao do produto                           ?
		//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
		
		If Empty( SC2->C2_QTSEGUM )
			nConv := IIF( cTipoConv == "M" , (SC2->C2_QUANT - SC2->C2_QUJE - SC2->C2_PERDA) * nFatorConv,  (SC2->C2_QUANT - SC2->C2_QUJE) / nFatorConv )
		Else
			nConv := SC2->C2_QTSEGUM             // QUANT. 2a UNIDADE DE MED. ATRAVES DA DIGITACAO NA OP
		EndIf
		
		@ li , 000 PSAY "PESO    : "
		_nPeso := IIF(SC2->C2_UM=="KG",SC2->C2_QUANT - SC2->C2_QUJE - SC2->C2_PERDA,nConv)
		@ li , 010 PSAY _nPeso  Picture "@E 999.99"
		@ li , 019 PSAY "METRAGEM : "
		_nMetrag := IIF(SC2->C2_UM=="KG",nConv,SC2->C2_QUANT - SC2->C2_QUJE - SC2->C2_PERDA)
		@ li , 031 PSAY _nMetrag Picture "@E 99,999.99"
		@ li , 050 PSAY "COR     : " + SC2->C2_COR
		li := li + 1
		@ li , 000 PSAY "URDUME  : "  + Subs(SC2->C2_URDUME,1,20)
		@ li , 020 PSAY "LOTE     : " + Subs(SC2->C2_LOTURTM,1,20)
		@ li , 040 PSAY "TRAMA   : "  + Subs(SC2->C2_TRAMA,1,20)
		@ li , 060 PSAY "LOTE     : " + Subs(SC2->C2_LOTTRAM,1,20)
		Li := Li + 1
		@ Li , 000 PSAY "PEDIDO  : " + Iif(!Empty(SC2->C2_PV_TERC),SC2->C2_PV_TERC,SC2->C2_PV_AGLU)
		li := li + 1
		@ li , 000 PSAY "LARG CRU: "+Transform(SB1->B1_X_LARG1,"@E 9.99")
		@ li , 020 PSAY "LARG JIGGER: "+Transform(SB1->B1_X_LARG2,"@E 9.99")
		@ li , 040 PSAY "LARG TURBO: "+Transform(SB1->B1_X_LARG3,"@E 9.99")
		@ li , 060 PSAY "LARG JET: "+Transform(SB1->B1_X_LARG4,"@E 9.99")
		//RICARDO li:= li + 2
		li:= li + 1
		@ li , 000 PSAY "+--------------+-------------+--------------+-------------+--------------------+"
		li := li + 1
		@ li , 000 PSAY "| JIGGER (   ) | TURBO (   ) | JIGGER (   ) | JET (   )   | ENROLADEIRA (   )  |"
		li := li + 1
		@ li , 000 PSAY "+--------------+-------------+--------------+-------------+--------------------+"
		li := li + 1
		@ li , 000 PSAY "| OPER.:       | OPER.:      | OPER.:       | OPER.:      | OPER.:             |"
		li := li + 1
		@ li , 000 PSAY "+--------------+-------------+--------------+-------------+--------------------+"
		//RICARDO li := li + 2
		li := li + 1
		@ li , 000 PSAY "+--------+---------+------------+-------------+----------+------+--------------+"
		li := li + 1
		@ li , 000 PSAY "| RAMA 1 | LARGURA | VELOCIDADE | TEMPERATURA | OPERADOR | DATA | OBSERVACOES  |"
		li := li + 1
		@ li , 000 PSAY "+--------+---------+------------+-------------+----------+------+--------------+"
		li := li + 1
		@ li , 000 PSAY "| SECAR  | "
		If SB1->B1_X_LARG5 > 0
			@ li , Pcol()+001 PSAY SB1->B1_X_LARG5          Picture "@E 9.99"
		Else
			@ li , Pcol()+001 PSAY "____"
		EndIf
		@ li , Pcol()+003 PSAY "| "
		If SB1->B1_X_VELO1 > 0
			@ li , Pcol()+001 PSAY SB1->B1_X_VELO1          Picture "@E 99.99"
		Else
			@ li , Pcol()+001 PSAY "_____"
		EndIf
		@ li , Pcol()+005 PSAY "| "
		If SB1->B1_X_TEMP1 > 0
			@ li , Pcol()+003 PSAY SB1->B1_X_TEMP1          Picture "@E 999"
		Else
			@ li , Pcol()+001 PSAY "_____"
		EndIf
		@ li , Pcol()+006 PSAY "|          |      |              |"
		li := li + 1
		@ li , 000 PSAY "+--------+---------+------------+-------------+----------+------+--------------+"
		li := li + 1
		@ li , 000 PSAY "| FIXAR  | "
		If SB1->B1_X_LARG7 > 0
			@ li , Pcol()+001 PSAY SB1->B1_X_LARG7          Picture "@E 9.99"
		Else
			@ li , Pcol()+001 PSAY "____"
		EndIf
		@ li , Pcol()+003 PSAY "| "
		If SB1->B1_X_VELO3 > 0
			@ li , Pcol()+001 PSAY SB1->B1_X_VELO3          Picture "@E 99.99"
		Else
			@ li , Pcol()+001 PSAY "_____"
		EndIf
		@ li , Pcol()+005 PSAY "| "
		If SB1->B1_X_TEMP2 > 0
			@ li , Pcol()+003 PSAY SB1->B1_X_TEMP2          Picture "@E 999"
		Else
			@ li , Pcol()+001 PSAY "_____"
		EndIf
		@ li , Pcol()+006 PSAY "|          |      |              |"
		li := li + 1
		@ li , 000 PSAY "+--------+---------+------------+-------------+----------+------+--------------+"
		li := li + 1
		@ li , 000 PSAY "| ACABAR | "
		If SB1->B1_X_LARG9 > 0
			@ li , Pcol()+001 PSAY SB1->B1_X_LARG9          Picture "@E 9.99"
		Else
			@ li , Pcol()+001 PSAY "____"
		EndIf
		@ li , Pcol()+003 PSAY "| "
		If SB1->B1_X_VELO5 > 0
			@ li , Pcol()+001 PSAY SB1->B1_X_VELO5          Picture "@E 99.99"
		Else
			@ li , Pcol()+001 PSAY "_____"
		EndIf
		@ li , Pcol()+005 PSAY "| "
		If SB1->B1_X_TEMP3 > 0
			@ li , Pcol()+003 PSAY SB1->B1_X_TEMP3          Picture "@E 999"
		Else
			@ li , Pcol()+001 PSAY "_____"
		EndIf
		@ li , Pcol()+006 PSAY "|          |      |              |"
		li := li + 1
		@ li , 000 PSAY "+--------+---------+------------+-------------+----------+------+--------------+"
		li := li + 1
		@ li , 000 PSAY "| ALIMEN | "
		@ li , Pcol()+001 PSAY SB1->B1_X_ALIM1
		@ li , Pcol()+004 PSAY "|          |      |              |"
		li := li + 1
		@ li , 000 PSAY "+--------+---------+------------+-------------+----------+------+--------------+"
		//RICARDO li := li + 2
		li := li + 1
		@ li , 000 PSAY "+--------+---------+------------+-------------+----------+------+--------------+"
		li := li + 1
		@ li , 000 PSAY "| RAMA 2 | LARGURA | VELOCIDADE | TEMPERATURA | OPERADOR | DATA | OBSERVACOES  |"
		li := li + 1
		@ li , 000 PSAY "+--------+---------+------------+-------------+----------+------+--------------+"
		li := li + 1
		@ li , 000 PSAY "| SECAR  | "
		If SB1->B1_X_LARG6 > 0
			@ li , Pcol()+001 PSAY SB1->B1_X_LARG6          Picture "@E 9.99"
		Else
			@ li , Pcol()+001 PSAY "____"
		EndIf
		@ li , Pcol()+003 PSAY "| "
		If SB1->B1_X_VELO2 > 0
			@ li , Pcol()+001 PSAY SB1->B1_X_VELO2          Picture "@E 99.99"
		Else
			@ li , Pcol()+001 PSAY "_____"
		EndIf
		@ li , Pcol()+005 PSAY "| "
		If SB1->B1_X_TEMP4 > 0
			@ li , Pcol()+003 PSAY SB1->B1_X_TEMP4          Picture "@E 999"
		Else
			@ li , Pcol()+001 PSAY "_____"
		EndIf
		@ li , Pcol()+006 PSAY "|          |      |              |"
		li := li + 1
		@ li , 000 PSAY "+--------+---------+------------+-------------+----------+------+--------------+"
		li := li + 1
		@ li , 000 PSAY "| FIXAR  | "
		If SB1->B1_X_LARG8 > 0
			@ li , Pcol()+001 PSAY SB1->B1_X_LARG8          Picture "@E 9.99"
		Else
			@ li , Pcol()+001 PSAY "____"
		EndIf
		@ li , Pcol()+003 PSAY "| "
		If SB1->B1_X_VELO4 > 0
			@ li , Pcol()+001 PSAY SB1->B1_X_VELO4          Picture "@E 99.99"
		Else
			@ li , Pcol()+001 PSAY "_____"
		EndIf
		@ li , Pcol()+005 PSAY "| "
		If SB1->B1_X_TEMP5 > 0
			@ li , Pcol()+003 PSAY SB1->B1_X_TEMP5          Picture "@E 999"
		Else
			@ li , Pcol()+001 PSAY "_____"
		EndIf
		@ li , Pcol()+006 PSAY "|          |      |              |"
		li := li + 1
		@ li , 000 PSAY "+--------+---------+------------+-------------+----------+------+--------------+"
		li := li + 1
		@ li , 000 PSAY "| ACABAR | "
		If SB1->B1_X_LARG0 > 0
			@ li , Pcol()+001 PSAY SB1->B1_X_LARG0          Picture "@E 9.99"
		Else
			@ li , Pcol()+001 PSAY "____"
		EndIf
		@ li , Pcol()+003 PSAY "| "
		If SB1->B1_X_VELO6 > 0
			@ li , Pcol()+001 PSAY SB1->B1_X_VELO6          Picture "@E 99.99"
		Else
			@ li , Pcol()+001 PSAY "_____"
		EndIf
		@ li , Pcol()+005 PSAY "| "
		If SB1->B1_X_TEMP6 > 0
			@ li , Pcol()+003 PSAY SB1->B1_X_TEMP6          Picture "@E 999"
		Else
			@ li , Pcol()+001 PSAY "_____"
		EndIf
		@ li , Pcol()+006 PSAY "|          |      |              |"
		li := li + 1
		@ li , 000 PSAY "+--------+---------+------------+-------------+----------+------+--------------+"
		li := li + 1
		@ li , 000 PSAY "| ALIMEN | "
		@ li , Pcol()+001 PSAY SB1->B1_X_ALIM2
		@ li , Pcol()+004 PSAY "|          |      |              |"
		li := li + 1
		@ li , 000 PSAY "+--------+---------+------------+-------------+----------+------+--------------+"

		//RICARDO li := li + 2
		li := li + 1
		
        //----> INSERIDO RAMA 3
		@ li , 000 PSAY "+--------+---------+------------+-------------+----------+------+--------------+"
		li := li + 1
		@ li , 000 PSAY "| RAMA 3 | LARGURA | VELOCIDADE | TEMPERATURA | OPERADOR | DATA | OBSERVACOES  |"
		li := li + 1
		@ li , 000 PSAY "+--------+---------+------------+-------------+----------+------+--------------+"
		li := li + 1
		@ li , 000 PSAY "| SECAR  | "
		If SB1->B1_X_LARGA > 0
			@ li , Pcol()+001 PSAY SB1->B1_X_LARGA          Picture "@E 9.99"
		Else
			@ li , Pcol()+001 PSAY "____"
		EndIf
		@ li , Pcol()+003 PSAY "| "
		If SB1->B1_X_VELO7 > 0
			@ li , Pcol()+001 PSAY SB1->B1_X_VELO7          Picture "@E 99.99"
		Else
			@ li , Pcol()+001 PSAY "_____"
		EndIf
		@ li , Pcol()+005 PSAY "| "
		If SB1->B1_X_TEMP7 > 0
			@ li , Pcol()+003 PSAY SB1->B1_X_TEMP7          Picture "@E 999"
		Else
			@ li , Pcol()+001 PSAY "_____"
		EndIf
		@ li , Pcol()+006 PSAY "|          |      |              |"
		li := li + 1
		@ li , 000 PSAY "+--------+---------+------------+-------------+----------+------+--------------+"
		li := li + 1
		@ li , 000 PSAY "| FIXAR  | "
		If SB1->B1_X_LARGB > 0
			@ li , Pcol()+001 PSAY SB1->B1_X_LARGB          Picture "@E 9.99"
		Else
			@ li , Pcol()+001 PSAY "____"
		EndIf
		@ li , Pcol()+003 PSAY "| "
		If SB1->B1_X_VELO8 > 0
			@ li , Pcol()+001 PSAY SB1->B1_X_VELO8          Picture "@E 99.99"
		Else
			@ li , Pcol()+001 PSAY "_____"
		EndIf
		@ li , Pcol()+005 PSAY "| "
		If SB1->B1_X_TEMP8 > 0
			@ li , Pcol()+003 PSAY SB1->B1_X_TEMP8          Picture "@E 999"
		Else
			@ li , Pcol()+001 PSAY "_____"
		EndIf
		@ li , Pcol()+006 PSAY "|          |      |              |"
		li := li + 1
		@ li , 000 PSAY "+--------+---------+------------+-------------+----------+------+--------------+"
		li := li + 1
		@ li , 000 PSAY "| ACABAR | "
		If SB1->B1_X_LARGC > 0
			@ li , Pcol()+001 PSAY SB1->B1_X_LARGC          Picture "@E 9.99"
		Else
			@ li , Pcol()+001 PSAY "____"
		EndIf
		@ li , Pcol()+003 PSAY "| "
		If SB1->B1_X_VELO9 > 0
			@ li , Pcol()+001 PSAY SB1->B1_X_VELO9          Picture "@E 99.99"
		Else
			@ li , Pcol()+001 PSAY "_____"
		EndIf
		@ li , Pcol()+005 PSAY "| "
		If SB1->B1_X_TEMP9 > 0
			@ li , Pcol()+003 PSAY SB1->B1_X_TEMP9          Picture "@E 999"
		Else
			@ li , Pcol()+001 PSAY "_____"
		EndIf
		@ li , Pcol()+006 PSAY "|          |      |              |"
		li := li + 1
		@ li , 000 PSAY "+--------+---------+------------+-------------+----------+------+--------------+"
		li := li + 1
		@ li , 000 PSAY "| ALIMEN | "
		@ li , Pcol()+001 PSAY SB1->B1_X_ALIM3
		@ li , Pcol()+004 PSAY "|          |      |              |"
		li := li + 1
		@ li , 000 PSAY "+--------+---------+------------+-------------+----------+------+--------------+"
		//RICARDO li := li + 2
		li := li + 1

		//----> FIM RAMA 3
		@ li , 000 PSAY "OBSERVACOES : " + Subs(SC2->C2_OBS,01,40)
		li := li + 1
		@ li , 000 PSAY "              " + Subs(SC2->C2_OBS,41,80)
		//RICARDO li := li + 2
		li := li + 1
		@ li , 000 PSAY "PECA: "     + Iif(!Empty(SC2->C2_PECAS_1),SC2->C2_PECAS_1,"")
		@ li , Pcol() PSAY     "  " + Iif(!Empty(SC2->C2_PECAS_2),SC2->C2_PECAS_2,"")
		@ li , Pcol() PSAY     "  " + Iif(!Empty(SC2->C2_PECAS_3),SC2->C2_PECAS_3,"")
		@ li , Pcol() PSAY     "  " + Iif(!Empty(SC2->C2_PECAS_4),SC2->C2_PECAS_4,"")
		@ li , Pcol() PSAY     "  " + Iif(!Empty(SC2->C2_PECAS_5),SC2->C2_PECAS_5,"")
		@ li , Pcol() PSAY     "  " + Iif(!Empty(SC2->C2_PECAS_6),SC2->C2_PECAS_6,"")
		@ li , Pcol() PSAY     "  " + Iif(!Empty(SC2->C2_PECAS_7),SC2->C2_PECAS_7,"")
		@ li , Pcol() PSAY     "  " + Iif(!Empty(SC2->C2_PECAS_8),SC2->C2_PECAS_8,"")
		li := li + 1
		@ li , 000 PSAY "QUANT: "     + Iif(!Empty(SC2->C2_QUANT_1),Transform(SC2->C2_QUANT_1,'@E 999.99'),"")
		@ li , Pcol() PSAY     "   " + Iif(!Empty(SC2->C2_QUANT_2),Transform(SC2->C2_QUANT_2,'@E 999.99'),"")
		@ li , Pcol() PSAY     "   " + Iif(!Empty(SC2->C2_QUANT_3),Transform(SC2->C2_QUANT_3,'@E 999.99'),"")
		@ li , Pcol() PSAY     "   " + Iif(!Empty(SC2->C2_QUANT_4),Transform(SC2->C2_QUANT_4,'@E 999.99'),"")
		@ li , Pcol() PSAY     "   " + Iif(!Empty(SC2->C2_QUANT_5),Transform(SC2->C2_QUANT_5,'@E 999.99'),"")
		@ li , Pcol() PSAY     "   " + Iif(!Empty(SC2->C2_QUANT_6),Transform(SC2->C2_QUANT_6,'@E 999.99'),"")
		@ li , Pcol() PSAY     "   " + Iif(!Empty(SC2->C2_QUANT_7),Transform(SC2->C2_QUANT_7,'@E 999.99'),"")
		@ li , Pcol() PSAY     "   " + Iif(!Empty(SC2->C2_QUANT_8),Transform(SC2->C2_QUANT_8,'@E 999.99'),"")
		
		//RICARDO li := li + 2
		li := li + 1
		@ li , 000 PSAY "PECA: "     + Iif(!Empty(SC2->C2_PECAS_9),SC2->C2_PECAS_9,"")
		@ li , Pcol() PSAY     "  " + Iif(!Empty(SC2->C2_PECAS_A),SC2->C2_PECAS_A,"")
		@ li , Pcol() PSAY     "  " + Iif(!Empty(SC2->C2_PECAS_B),SC2->C2_PECAS_B,"")
		@ li , Pcol() PSAY     "  " + Iif(!Empty(SC2->C2_PECAS_C),SC2->C2_PECAS_C,"")
		@ li , Pcol() PSAY     "  " + Iif(!Empty(SC2->C2_PECAS_D),SC2->C2_PECAS_D,"")
		@ li , Pcol() PSAY     "  " + Iif(!Empty(SC2->C2_PECAS_E),SC2->C2_PECAS_E,"")
		@ li , Pcol() PSAY     "  " + Iif(!Empty(SC2->C2_PECAS_F),SC2->C2_PECAS_F,"")
		@ li , Pcol() PSAY     "  " + Iif(!Empty(SC2->C2_PECAS_G),SC2->C2_PECAS_G,"")
		li := li + 1
		@ li , 000 PSAY "QUANT: "     + Iif(!Empty(SC2->C2_QUANT_9),Transform(SC2->C2_QUANT_9,'@E 999.99'),"")
		@ li , Pcol() PSAY     "   " + Iif(!Empty(SC2->C2_QUANT_A),Transform(SC2->C2_QUANT_A,'@E 999.99'),"")
		@ li , Pcol() PSAY     "   " + Iif(!Empty(SC2->C2_QUANT_B),Transform(SC2->C2_QUANT_B,'@E 999.99'),"")
		@ li , Pcol() PSAY     "   " + Iif(!Empty(SC2->C2_QUANT_C),Transform(SC2->C2_QUANT_C,'@E 999.99'),"")
		@ li , Pcol() PSAY     "   " + Iif(!Empty(SC2->C2_QUANT_D),Transform(SC2->C2_QUANT_D,'@E 999.99'),"")
		@ li , Pcol() PSAY     "   " + Iif(!Empty(SC2->C2_QUANT_E),Transform(SC2->C2_QUANT_E,'@E 999.99'),"")
		@ li , Pcol() PSAY     "   " + Iif(!Empty(SC2->C2_QUANT_F),Transform(SC2->C2_QUANT_F,'@E 999.99'),"")
		@ li , Pcol() PSAY     "   " + Iif(!Empty(SC2->C2_QUANT_G),Transform(SC2->C2_QUANT_G,'@E 999.99'),"")
		li := li + 2
		@ li , 000 PSAY PADC("R  E  V  I  S  A  O",80)
		//RICARDO li := li + 2
		li := li + 1
		@ li , 000 PSAY "PROD : _____ PROD : _____ REPR : _____       ___________________________________"
		li := li + 1
		@ li , 000 PSAY "                                             | DEPARTAMENTO |  DATA  |  VISTO  |"
		li := li + 1
		@ li , 000 PSAY "PROD : _____ PROD : _____ REPR : _____       ___________________________________"
		li := li + 1
		@ li , 000 PSAY "                                             | Revisao      |        |         |"
		li := li + 1
		@ li , 000 PSAY "PROD : _____ PROD : _____ RETA : _____       -----------------------------------"
		li := li + 1
		@ li , 000 PSAY "                                             | Digitacao    |        |         |"
		li := li + 1
		@ li , 000 PSAY "PROD : _____ PROD : _____ ENCO : _____       -----------------------------------"
		//RICARDO li := li + 2
		li := li + 1
		@ Li , 000 PSAY PADC("FAVOR ANOTAR AS OBSERVACOES NO VERSO DA FOLHA",80)
	EndIf
	
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//? Imprimir Relacao de medidas para Cliente == HUNTER DOUGLAS.  ?
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek("SMX")
	If Found() .And. SC2->C2_DESTINA == "P"
		R820Medidas()
	EndIf
	
	m_pag:=m_pag+1
	Li := 0                                 // linha inicial - ejeta automatico
	aArray:={}
	
	dbSelectArea("SC2")
	dbSkip()
	
EndDO

dbSelectArea("SH8")
dbCloseArea()

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//? Retira o SH8 da variavel cFopened ref. a abertura no MNU     ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
ClosFile("SH8")

dbSelectArea("SC2")
If aReturn[8] == 4
	RetIndex("SC2")
	Ferase(cIndSC2+OrdBagExt())
EndIf
Set Filter To
dbSetOrder(1)

Set device to Screen

If aReturn[5] == 1
	Set Printer TO
	dbCommitall()
	ourspool(wnrel)
Endif

MS_FLUSH()

Return(NIL)
/*/
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽?
굇? Fun뇚o   ? AddAr820 ? Autor ? Paulo Boschetti       ? Data ? 07/07/92 낢?
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙?
굇? Descri뇚o? Adiciona um elemento ao Array                              낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇? Sintaxe  ? AddAr820(ExpN1)                                            낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇쿛arametros? ExpN1 = Quantidade da estrutura                            낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇? Uso      ? MATR820                                                    낢?
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
/*/
// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function AddAr820
Static Function AddAr820()

cDesc := SB1->B1_DESC
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
//? Verifica se imprime nome cientifico do produto. Se Sim    ?
//? verifica se existe registro no SB5 e se nao esta vazio    ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
If mv_par05 == 1
	dbSelectArea("SB5")
	dbSeek(xFilial()+SB1->B1_COD)
	If Found() .and. !Empty(B5_CEME)
		cDesc := B5_CEME
	EndIf
ElseIf mv_par05 == 2
	cDesc := SB1->B1_DESC
Else
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
	//? Verifica se imprime descricao digitada ped.venda, se sim  ?
	//? verifica se existe registro no SC6 e se nao esta vazio    ?
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
	
	If SC2->C2_DESTINA == "P"
		dbSelectArea("SC6")
		dbSetOrder(1)
		dbSeek(xFilial()+SC2->C2_NUM+SC2->C2_ITEM)
		If Found() .and. !Empty(C6_DESCRI) .and. C6_PRODUTO==SB1->B1_COD
			cDesc := C6_DESCRI
		ElseIf C6_PRODUTO #SB1->B1_COD
			dbSelectArea("SB5")
			dbSeek(xFilial()+SB1->B1_COD)
			If Found() .and. !Empty(B5_CEME)
				cDesc := B5_CEME
			EndIf
		EndIf
	EndIf
EndIf

dbSelectArea("SB2")
dbSeek(xFilial()+SB1->B1_COD)
dbSelectArea("SD4")

DbSelectArea("SG1") // msg
DbSetOrder(3)
DbSeek( xFilial("SG1") + SD4->D4_COD )

dbSelectArea("SD4")
//  01         02    03         04         05     06                 07          08

AADD(aArray,{SB1->B1_COD,cDesc,SB1->B1_TIPO,SB1->B1_UM,nQuant,SB2->B2_LOCALIZ,SD4->D4_TRT,SG1->G1_ETAPA } ) //nQuant

/*/
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽?
굇? Fun뇚o   ? MontStruc? Autor ? Ary Medeiros          ? Data ? 19/10/93 낢?
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙?
굇? Descri뇚o? Monta um array com a estrutura do produto                  낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇? Sintaxe  ? MontStruc(ExpC1,ExpN1,ExpN2)                               낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇쿛arametros? ExpC1 = Codigo do produto a ser explodido                  낢?
굇?          ? ExpN1 = Quantidade base a ser explodida                    낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇? Uso      ? MATR820                                                    낢?
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
/*/

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function MontStruc
Static Function MontStruc()

dbSelectArea("SD4")
dbSetOrder(2)
If dbSeek(xFilial("SD4")+cOp,.f.)
	While Alltrim(SD4->D4_OP) == cOp
		//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
		//? Posiciona no produto desejado                           ?
		//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
		
		_cChave := SD4->D4_COD+SD4->D4_TRT
		
		dbSelectArea("SB1")
		dbSeek(xFilial()+SD4->D4_COD)
		If SD4->D4_QUANT > 0
			nQuant:=SD4->D4_QUANT
			AddAr820()
		EndIf
		dbSelectArea("SD4")
		dbSkip()
		
		While SD4->D4_COD+SD4->D4_TRT  == _cChave
			i := Len(aArray)
			aArray[i][5] := aArray[i][5]+SD4->D4_QUANT
			dbSelectArea("SD4")
			dbSkip()
		EndDo
	Enddo                                 
EndIf

dbSetOrder(1)

Return()

/*/
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽?
굇? Fun뇚o   ? CabecOp  ? Autor ? Paulo Boschetti       ? Data ? 07/07/92 낢?
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙?
굇? Descri뇚o? Monta o cabecalho da Ordem de Producao                     낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇? Sintaxe  ? CabecOp()                                                  낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇쿛arametros?                                                            낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇? Uso      ? MATR820                                                    낢?
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
/*/

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function CabecOp
Static Function CabecOp()

nBegin:=0

If li #5
	li := 0
Endif

@ Li , 045 PSAY "___________________________________"
LI := LI + 1
@ LI , 000 PSAY Alltrim(SM0->M0_NOMECOM)
@ Li , 045 PSAY "| DEPARTAMENTO |  DATA  |  VISTO  |"
LI := LI + 1
@ LI , 000 PSAY "RECEITA PARA TINGIMENTO - "+SC2->C2_NUM
@ Li , 045 PSAY "___________________________________"
LI := LI + 1
@ LI , 000 PSAY "EMISSAO "+Dtoc(dDataBase)
@ Li , 045 PSAY "| Digitacao    |        |         |"
LI := LI + 1
@ Li , 045 PSAY "___________________________________"
Li := Li + 1
@ Li , 045 PSAY "| Conferencia  |        |         |"
Li := Li + 1
@ Li , 045 PSAY "___________________________________"

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
//? Imprime descricao do Produto                            ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
Li := Li + 2
@ LI , 000 PSAY "PRODUTO : " + aArray[1][1]

cDescri:=aArray[1][2]
ImpDescr()

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
//? Verifica conversao do produto                           ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?

If Empty( SC2->C2_QTSEGUM )
	nConv := IIF( cTipoConv == "M" , (SC2->C2_QUANT - SC2->C2_QUJE - SC2->C2_PERDA) * nFatorConv,  (SC2->C2_QUANT - SC2->C2_QUJE - SC2->C2_PERDA) / nFatorConv )
Else
	nConv := SC2->C2_QTSEGUM             // QUANT. 2a UNIDADE DE MED. ATRAVES DA DIGITACAO NA OP
EndIf

@ Li , 000 PSAY "PESO    : "
@ Li , 010 PSAY IIF(SC2->C2_UM=="KG",(SC2->C2_QUANT - SC2->C2_QUJE - SC2->C2_PERDA),nConv)   PICTURE "@E 999.99"
@ Li , 019 PSAY "METRAGEM  : "
_nMetrag := IIF(SC2->C2_UM=="KG",nConv,(SC2->C2_QUANT - SC2->C2_QUJE - SC2->C2_PERDA))
@ Li , 031 PSAY _nMetrag Picture "@E 99,999.99"

@ Li , 042 PSAY "PARTIDA : "
@ Li , 052 PSAY SC2->C2_NUM
Li := Li + 1
@ Li , 000 PSAY "TURBO N.: ______"
@ Li , 019 PSAY "OPERADOR  : ____________________"
@ Li , 059 PSAY "DATA     : ________"
Li := Li + 1
@ Li , 000 PSAY "COR     : " + SC2->C2_COR
Li := Li + 1
@ Li , 000 PSAY "PEDIDO  : " + Iif(!Empty(SC2->C2_PV_TERC),SC2->C2_PV_TERC,SC2->C2_PV_AGLU)
Li := Li + 1
@ Li , 000 PSAY "OBS.    : " + Subs(SC2->C2_OBS,01,40)
@ Li , 059 PSAY "LARGURA  :"
If nLargura > 0
	@ Li , 070 PSAY nLargura Picture "@E 9.99"
Else
	@ Li , 070 PSAY "________"
EndIf
Li := Li + 1
@ Li , 000 PSAY "          " + Subs(SC2->C2_OBS,41,80)
Li := Li + 2
@ Li , 000 PSAY "|   | TURBO/JIGGER    |   | TURBO    |   | JIGGER     |   | RAMA     |   | CORDA"
Li := Li + 2

If mv_par07 == 1
	@ Li , 000 PSAY "+----------+---------------+-------------------------+-----------+---+---------+"
	Li := Li+1
	@ Li , 000 PSAY "| QTD/PORC | CODIGO        | DESCRICAO               | TOTAL     |OBS|CUSTO STD|"
	Li:=Li + 1
Else
	@ Li , 000 PSAY "+----------+---------------+-----------------------------------+-----------+---+"
	Li := Li+1
	@ Li , 000 PSAY "| QTD/PORC | CODIGO        | DESCRICAO                         | TOTAL     |OBS|"
	Li:=Li + 1
EndIf

Return()

/*/
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽?
굇? Fun뇚o   ? Verilim  ? Autor ? Paulo Boschetti       ? Data ? 18/07/92 낢?
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙?
굇? Descri뇚o?                                                            낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇? Sintaxe  ? Verilim()                                                  낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇쿛arametros?                                                                            낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇? Uso      ? MATR820                                                    낢?
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
/*/

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function Verilim
Static Function Verilim()

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//? Verifica a possibilidade de impressao da proxima operacao alocada na ?
//? mesma folha.                                                                                                                 ?
//? 7 linhas por operacao => (total da folha) 66 - 7 = 59                                ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
IF Li > 59                                              // Li > 55
	Li := 0
	cRotOper(0)                                     // Imprime cabecalho roteiro de operacoes
Endif

Return(Li)

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽?
굇쿑un뇚o    ? ImpDescr ? Autor ? Marcos Bregantim      ? Data ? 31.08.93 낢?
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙?
굇쿏escri뇚o ? Imprimir descricao do Produto.                             낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇쿞intaxe   ? ImpProd(Void)                                              낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇쿛arametros?                                                            낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇? Uso      ? MatR820                                                    낢?
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽?
/*/

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function ImpDescr//(cDescri) static
Static Function ImpDescr//(cDescri) static()

DbSelectArea("SB1")
DbSetOrder(1)

/* tirado de uso em 19/11/2001 por Ricardo
If DbSeek( xFilial("SB1") + Substr( aArray[1][1], 1, 6 ))
cDescri := SB1->B1_DESC
EndIf
*/

If DbSeek( xFilial("SB1") + aArray[1][1])
	cDescri := SB1->B1_DESC
EndIf

DbSelectArea("SC2")
_C2RECNO := Recno()
DbSetOrder(1)
DbSeek( xFilial("SC2") + Substr( cOp,1,8) + "001" )

dDtaFin := SC2->C2_DATPRF
DbGoTo(_C2RECNO)

For nBegin := 1 To Len(Alltrim(cDescri)) Step 50
	@ li, 025 PSAY Substr(cDescri,nBegin,50)
	li:=li+1
Next nBegin


/*/
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽?
굇? Fun뇚o   ? Grafico  ? Autor ? Paulo Boschetti       ? Data ? 07/07/92 낢?
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙?
굇? Descri뇚o? Imprime o Grafico da Receita                               낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇? Sintaxe  ? CabecOp()                                                  낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇쿛arametros?                                                            낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇? Uso      ? MATR820                                                    낢?
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
/*/

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function Grafico
Static Function Grafico()


nMemCount	:= MlCount(SB1->B1_X_GRAF,80)

For _X := 1 to nMemCount
	@ li, 000 PSAY ALLTRIM(MemoLine(SB1->B1_X_GRAF, 80,_X ))
	li:=li+1
	
	IF li > 63
		Li := 0
		
		nBegin:=0
		
		If li #5
			li := 0
		Endif
		
		@ Li , 045 PSAY "___________________________________"
		LI := LI + 1
		@ LI , 000 PSAY Alltrim(SM0->M0_NOMECOM)
		@ Li , 045 PSAY "| DEPARTAMENTO |  DATA  |  VISTO  |"
		LI := LI + 1
		@ LI , 000 PSAY "RECEITA PARA TINGIMENTO - "+SC2->C2_NUM
		@ Li , 045 PSAY "___________________________________"
		LI := LI + 1
		@ LI , 000 PSAY "EMISSAO "+Dtoc(dDataBase)
		@ Li , 045 PSAY "| Digitacao    |        |         |"
		LI := LI + 1
		@ Li , 045 PSAY "___________________________________"
		Li := Li + 1
		@ Li , 045 PSAY "| Conferencia  |        |         |"
		Li := Li + 1
		@ Li , 045 PSAY "___________________________________"
		
	EndIf
nEXT
Return

/*/
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽?
굇? Fun뇚o   ? Processos? Autor ? Paulo Boschetti       ? Data ? 07/07/92 낢?
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙?
굇? Descri뇚o? Imprime o Processo da Receita de Tingimento                낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇? Sintaxe  ? CabecOp()                                                  낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇쿛arametros?                                                            낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇? Uso      ? MATR820                                                    낢?
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
/*/
// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function Processos
Static Function Processos()


dbSelectArea("SZD")
dbSetOrder(1)
If dbSeek(xFilial("SZD")+SB1->B1_X_PROCE,.F.)
	
	nMemCount	:= MlCount(SZD->ZD_DESCRIC,80)
	
	For _X := 1 to nMemCount
		@ li, 000 PSAY RTRIM(MemoLine(SZD->ZD_DESCRIC, 80,_X )    )
		li:=li+1
		
		IF li > 63
			Li := 0
			
			nBegin:=0
			
			If li #5
				li := 0
			Endif
			
			@ Li , 045 PSAY "___________________________________"
			LI := LI + 1
			@ LI , 000 PSAY Alltrim(SM0->M0_NOMECOM)
			@ Li , 045 PSAY "| DEPARTAMENTO |  DATA  |  VISTO  |"
			LI := LI + 1
			@ LI , 000 PSAY "RECEITA PARA TINGIMENTO - "+SC2->C2_NUM
			@ Li , 045 PSAY "___________________________________"
			LI := LI + 1
			@ LI , 000 PSAY "EMISSAO "+Dtoc(dDataBase)
			@ Li , 045 PSAY "| Digitacao    |        |         |"
			LI := LI + 1
			@ Li , 045 PSAY "___________________________________"
			Li := Li + 1
			@ Li , 045 PSAY "| Conferencia  |        |         |"
			Li := Li + 1
			@ Li , 045 PSAY "___________________________________"
			
			
			
		EndIf
	NEXT
eNDif
Return


/*/        ]
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
굇旼컴컴컴컴컫컴컴컴컴컴컫컴컴컴컫컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽?
굇쿑un뇚o    쿝820Medidas? Autor ? Jose Lucas           ? Data ? 25.01.94 낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컨컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙?
굇쿏escri뇚o ? Imprime o registros referentes as medidas do Pedido Filho. 낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇쿞intaxe   ? R820Medidas(Void)                                          낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇쿛arametros?                                                            낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇? Uso      ? MatR820                                                    낢?
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽?
/*/
// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function R820Medidas
Static Function R820Medidas()
aArrayPro   := {}
lImpItem    := .T.
nCntArray   := 0
a01         := ""
a02         := ""
nX          :=0
nI          :=0
nL          :=0
nY          :=0
cNum        :=""
cItem       :=""
lImpCab     := .T.
nBegin      :=0
cProduto    :=""
cDesc       :=""
cDescri     :=""
cDescri1    :=""
cDescri2    :=""


//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//? Imprime Relacao de Medidas do cliente quando OP for gerada ?
//? por pedidos de vendas.                                     ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
dbSelectArea("SC5")
dbSetOrder(1)
dbSeek(xFilial()+SC2->C2_NUM)
If Found()
	cNum     := SC2->C2_NUM
	cItem    := SC2->C2_ITEM
	cProduto := SC2->C2_PRODUTO
	
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//? Imprimir somente se houver Observacoes.                      ?
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	IF !Empty(SC5->C5_OBSERVA)
		IF li > 53
			@ 03,001 PSAY "HUNTER DOUGLAS DO BRASIL LTDA"
			@ 05,008 PSAY "CONFIRMACAO DE PEDIDOS  -  "+IIF( SC5->C5_VENDA=="01","ASSESSORIA","DISTRIBUICAO")
			@ 05,055 PSAY "No. RMP    : "+SC5->C5_NUM+"-"+SC5->C5_VENDA
			@ 06,055 PSAY "DATA IMPRES: "+DTOC(dDataBase)
			li := 07
		EndIF
		li:=li+1
		@ li,001 PSAY "--------------------------------------------------------------------------------"
		li:=li+1
		cDescri := SC5->C5_OBSERVA
		@ li,001 PSAY " OBSERVACAO: "
		@ li,018 PSAY SubStr(cDescri,1,60)
		For nBegin := 61 To Len(Trim(cDescri)) Step 60
			li:=li+1
			cDesc:=Substr(cDescri,nBegin,60)
			@ li,018 PSAY cDesc
		Next nBegin
		li:=li+1
		cDescri1 := SC5->C5_OBSERV1
		@ li,018 PSAY SubStr(cDescri1,1,60)
		For nBegin := 61 To Len(Trim(cDescri1)) Step 60
			li:=li+1
			cDesc:=Substr(cDescri1,nBegin,60)
			@ li,018 PSAY cDesc
		Next nBegin
		Li:=Li+1
		cDescri2 := SC5->C5_OBSERV2
		@ li,018 PSAY SubStr(cDescri2,1,60)
		For nBegin := 61 To Len(Trim(cDescri2)) Step 60
			li:=li+1
			cDesc:=Substr(cDescri2,nBegin,60)
			@ li,018 PSAY cDesc
		Next nBegin
		li:=li+1
		@ li,001 PSAY "--------------------------------------------------------------------------------"
		li:=li+1
	EndIf
	
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//? Carregar as medidas em array para impressao.                 ?
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	dbSelectArea("SMX")
	dbSetOrder(2)
	dbSeek(xFilial()+cNum+cProduto)
	While !Eof() .And. M6_FILIAL+M6_NRREL+M6_PRODUTO == xFilial()+cNum+cProduto
		IF M6_ITEM == cItem
			AADD(aArrayPro,M6_ITEM+" - "+M6_PRODUTO)
			nCntArray:=nCntArray+1
			cCnt := StrZero(nCntArray,2)
			aArray&cCnt := {}
			While !Eof() .And. M6_FILIAL+M6_NRREL+M6_PRODUTO == xFilial()+cNum+cProduto
				If M6_ITEM == cItem
					AADD(aArray&cCnt,{ Str(M6_QUANT,9,2)," PECAS COM ",M6_COMPTO})
				EndIf
				dbSkip()
			End
		Else
			dbSkip()
		EndIF
	End
	cCnt := StrZero(nCntArray+1,2)
	aArray&cCnt := {}
	
	For nX := 1 TO Len(aArrayPro)
		If li > 58
			R820CabMed()
		EndIF
		@ li,009 PSAY aArrayPro[nx]
		Li:=Li+1
		Li:=Li+1
		dbSelectArea("SMX")
		dbSetOrder(2)
		dbSeek( xFilial()+cNum+Subs(aArrayPro[nX],06,15) )
		While !Eof() .And. M6_FILIAL+M6_NRREL+M6_PRODUTO == xFilial()+cNum+Subs(aArrayPro[nX],06,15)
			If li > 58
				R820CabMed()
			EndIF
			IF M6_ITEM == Subs(aArrayPro[nX],1,2)
				@ li,002 PSAY M6_QUANT
				@ li,013 PSAY "PECAS COM"
				@ li,023 PSAY M6_COMPTO
				@ li,035 PSAY M6_OBS
				li:=li+1
			EndIF
			dbSkip()
		End
		li:=li+1
	Next nX
	@ li,001 PSAY "--------------------------------------------------------------------------------"
EndIf
Return(Nil)

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
굇旼컴컴컴컴컫컴컴컴컴컴컫컴컴컴컫컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽?
굇쿑un뇚o    쿝820CabMed ? Autor ? Jose Lucas           ? Data ? 25.01.94 낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컨컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙?
굇쿏escri뇚o ? Imprime o cabecalho referentes as medidas do Pedido Filho. 낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇쿞intaxe   ? R820CabMed(Void)                                           낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇쿛arametros?                                                            낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇? Uso      ? MatR820                                                    낢?
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽?
/*/

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function R820CabMed
Static Function R820CabMed()

cCabec1 := SM0->M0_NOME+"               RELACAO DE MEDIDAS             NRO :"
cCabec2 := "MAQUINA                       FERRAMENTA               OPERACAO"

Li := 0

Li:=Li+1
@Li  ,  0 PSAY REPLICATE("*",80)
Li:=Li+1
@Li  ,  0 PSAY cCabec1
@Li  , 69 PSAY SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN
Li:=Li+1
@Li  ,  0 PSAY REPLICATE("*",80)
Li:=Li+1
Li:=Li+1
Return(Nil)


/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽?
굇쿑un뇚o    ? Pergunta ? Autor ? Marcos Gomes          ? Data ? 01/12/99 낢?
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙?
굇쿏escri뇚o ? Cria grupo de Perguntas caso nao exista no SX1             낢?
굇?          ?                                                            낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇? Uso      ? PCP - especifico Kenia                                     낢?
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽?
/*/

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function Pergunta
Static Function Pergunta()

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//? Variaveis utilizadas para parametros                         ?
//? mv_par01            // Da OP                                 ?
//? mv_par02            // Ate a OP                              ?
//? mv_par03            // Da data                               ?
//? mv_par04            // Ate a data                            ?
//? mv_par05            // Imprime Nome Cientifico               ?
//? mv_par06            // Ambas / So Receita / So Ficha         ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

_aPerguntas := {}
// 01     02       03                    04     05  06 7 8  9      10                               11           12        13 14        15        16 17           18     19 20     21        22 23 24 25  26
AADD(_aPerguntas,{cPerg,"01","Da O.P.               ?","mv_ch1","C",11,0,0,"G","                               ","mv_par01","            ","","","              ","","","             ","","","           ","","","","","SC2",})
AADD(_aPerguntas,{cPerg,"02","Ate a O.P.            ?","mv_ch2","C",11,0,0,"G","                               ","mv_par02","            ","","","              ","","","             ","","","           ","","","","","SC2",})
AADD(_aPerguntas,{cPerg,"03","Da Data               ?","mv_ch3","D",08,0,0,"G","                               ","mv_par03","            ","","","              ","","","             ","","","           ","","","","","   ",})
AADD(_aPerguntas,{cPerg,"04","Ate a Data            ?","mv_ch4","D",08,0,0,"G","                               ","mv_par04","            ","","","              ","","","             ","","","           ","","","","","   ",})
AADD(_aPerguntas,{cPerg,"05","Descricao do Produto  ?","mv_ch5","N",01,0,0,"C","                               ","mv_par05","Descr.Cient.","","","Descr.Generica","","","Pedido Venda ","","","           ","","","","","   ",})
AADD(_aPerguntas,{cPerg,"06","Quanto a Impressao    ?","mv_ch6","N",01,3,0,"C","                               ","mv_par06","            ","","","              ","","","             ","","","           ","","","","","   ",})

DbSelectArea("SX1")
FOR _nLaco:=1 to LEN(_aPerguntas)
	If !dbSeek(_aPerguntas[_nLaco,1]+_aPerguntas[_nLaco,2])
		RecLock("SX1",.T.)
		SX1->X1_Grupo     := _aPerguntas[_nLaco,01]
		SX1->X1_Ordem     := _aPerguntas[_nLaco,02]
		SX1->X1_Pergunt   := _aPerguntas[_nLaco,03]
		SX1->X1_Variavl   := _aPerguntas[_nLaco,04]
		SX1->X1_Tipo      := _aPerguntas[_nLaco,05]
		SX1->X1_Tamanho   := _aPerguntas[_nLaco,06]
		SX1->X1_Decimal   := _aPerguntas[_nLaco,07]
		SX1->X1_Presel    := _aPerguntas[_nLaco,08]
		SX1->X1_Gsc       := _aPerguntas[_nLaco,09]
		SX1->X1_Valid     := _aPerguntas[_nLaco,10]
		SX1->X1_Var01     := _aPerguntas[_nLaco,11]
		SX1->X1_Def01     := _aPerguntas[_nLaco,12]
		SX1->X1_Cnt01     := _aPerguntas[_nLaco,13]
		SX1->X1_Var02     := _aPerguntas[_nLaco,14]
		SX1->X1_Def02     := _aPerguntas[_nLaco,15]
		SX1->X1_Cnt02     := _aPerguntas[_nLaco,16]
		SX1->X1_Var03     := _aPerguntas[_nLaco,17]
		SX1->X1_Def03     := _aPerguntas[_nLaco,18]
		SX1->X1_Cnt03     := _aPerguntas[_nLaco,19]
		SX1->X1_Var04     := _aPerguntas[_nLaco,20]
		SX1->X1_Def04     := _aPerguntas[_nLaco,21]
		SX1->X1_Cnt04     := _aPerguntas[_nLaco,22]
		SX1->X1_Var05     := _aPerguntas[_nLaco,23]
		SX1->X1_Def05     := _aPerguntas[_nLaco,24]
		SX1->X1_Cnt05     := _aPerguntas[_nLaco,25]
		SX1->X1_F3        := _aPerguntas[_nLaco,26]
		MsUnLock()
	EndIf
NEXT

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

