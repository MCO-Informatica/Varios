#INCLUDE "PROTHEUS.CH" 
#INCLUDE "MATA415.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "FWEVENTVIEWCONSTS.CH"     
#INCLUDE "FWADAPTEREAI.CH"   

User Function HCIDA015(xAutoCab,xAutoItens,nOpcAuto,lSimulacao,lSigaDPR)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Declaracao das variaveis                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aCores := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Tratamento de Filtro para o browse                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aIndex		:= {}
Local bFiltraBrw	:= {|| Nil}	
Local cFiltro		:= ''
Local lMT415Brw		:= .F. 
Local cFilSQL		:= ""
Local _cRetFil		:= U_HCIDM010("PEDIDO")

DEFAULT lSimulacao	:= .F.
DEFAULT lSigaDPR	:= .F.

Private lOnUpdate   := .T.
Private lExAutoDPR 	:= lSigaDPR 

Private lOnUpdate   := .T.
Private cCadastro	:= OemtoAnsi(STR0001) 					//"Or‡amentos de Venda"
Private l415Auto 	:= ( Valtype(xAutoCab) == "A"  .and. ValType(xAutoItens) == "A" )
Private aAutoCab	:= {}
Private aAutoItens	:= {}
Private aRotina		:= MenuDef()
Private lShowOpc	:= .T.
	
If !Empty(_cRetFil)
	_cRetFil	:= " CJ_CLIENTE||CJ_LOJA IN (" + _cRetFil + ")"
EndIf

	aCores	:= 	{	{ 'SCJ->CJ_STATUS=="A"' 							, 'ENABLE' 		},; 	//Orcamento em Aberto
					{ 'SCJ->CJ_STATUS=="B"' 							, 'BR_AZUL'		},;		//Orcamento Baixado
					{ 'SCJ->CJ_STATUS=="C"' 							, 'BR_PRETO'	},;		//Orcamento Cancelado
					{ 'SCJ->CJ_STATUS=="C"' 							, 'BR_PRETO'	},;		//Orcamento Cancelado
					{ 'SCJ->CJ_STATUS=="D" .And. SCJ->CJ_STSBLQ == "3"' , 'BR_CINZA' 	}}		//Orcamento Reprovado  

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Inicializacao da Mbrowse ou rotina automatica                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SCJ")
	dbSetOrder(1)
	MsSeek(xFilial())
	If ( AMIIn(5,12) )
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica se o tamanho do campo CJ_TABELA                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If Len(SCJ->CJ_TABELA)<>3
			Aviso("SX3",STR0049,{"OK"}) //"O estrutura do campo CJ_TABELA esta diferente do padrao, solicitamos que seja alterado para Caracter de 3, antes de utilizar a rotina"
		Else
		
			mBrowse( 6, 1,22,75,"SCJ",,,,,,aCores,,,,,,,,cFilSQL)
		EndIf
	EndIf
	
Return(.T.)        

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³MenuDef   ³ Autor ³ Marco Bianchi         ³ Data ³01/09/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Utilizacao de menu Funcional                               ³±±
±±³          ³                                                            ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Array com opcoes da rotina.                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Parametros do array a Rotina:                               ³±±
±±³          ³1. Nome a aparecer no cabecalho                             ³±±
±±³          ³2. Nome da Rotina associada                                 ³±±
±±³          ³3. Reservado                                                ³±±
±±³          ³4. Tipo de Transa‡„o a ser efetuada:                        ³±±
±±³          ³	  1 - Pesquisa e Posiciona em um Banco de Dados           ³±±
±±³          ³    2 - Simplesmente Mostra os Campos                       ³±±
±±³          ³    3 - Inclui registros no Bancos de Dados                 ³±±
±±³          ³    4 - Altera o registro corrente                          ³±±
±±³          ³    5 - Remove o registro corrente do Banco de Dados        ³±±
±±³          ³5. Nivel de acesso                                          ³±±
±±³          ³6. Habilita Menu Funcional                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function MenuDef()
     
	Private aRotina := {	{STR0002,"AxPesqui"  	, 0 , 1, 0,.F.},; 	//"Pesquisar"
							{STR0003,"A415Visual"	, 0 , 2, 0,NIL},; 	//"Visualizar"
							{STR0004,"A415Inclui"	, 0 , 3, 0,NIL},; 	//"Incluir"
							{STR0005,"A415Altera"	, 0 , 4, 0,NIL},; 	//"Alterar"
							{STR0038,"A415Exclui"	, 0 , 5, 0,NIL},;		//"Exclui"
							{STR0039,"A415Cancel" 	, 0 , 2, 0,NIL},;		//"Cancela"
							{STR0006,"A415Impri" 	, 0 , 2, 0,NIL},; 	//"impRimir"
							{STR0007,"A415PCpy"  	, 0 , 4, 0,NIL},;		//"Copiar"
							{STR0057,"u_H015Leg"	, 0 , 2, 0,.F.},;		//"Legenda"
							{STR0076,"MsDocument"	, 0 , 4, 0 ,NIL} }		//"Conhecimento"
							
								
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica motivo de bloqueio por regra/verba                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If	SuperGetMv("MV_VEBLQRG", .F., .F.)	
		Aadd(aRotina,{STR0084,"OrcBlqRegB", 0 , 0 , 0 , .F.})		// "Blq. Regra"
	EndIf
	
	If ExistBlock("MA415MNU")
		ExecBlock("MA415MNU",.F.,.F.)
	EndIf

Return(aRotina)

User Function H015Leg()

	Local aCores := {	{ 'ENABLE'    , 'Orcamento em Aberto' 	},; //'Orcamento em Aberto'
						{ 'BR_AZUL'   , 'Orcamento Baixado' 	},; //'Orcamento Baixado'
						{ 'BR_PRETO'  , 'Orcamento Cancelado' 	},; //'Orcamento Cancelado' 	
						{ 'BR_VIOLETA', 'Orcamento em execução'	},; //'Orcamento Cancelado' 	
						{ 'BR_CINZA'  , 'Orcamento Declinado' 	}}  // 'Orcamento Reprovado'

	BrwLegenda(cCadastro,STR0057,aCores )   //Pedido Liberado

Return()