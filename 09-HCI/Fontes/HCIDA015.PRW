#INCLUDE "PROTHEUS.CH" 
#INCLUDE "MATA415.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "FWEVENTVIEWCONSTS.CH"     
#INCLUDE "FWADAPTEREAI.CH"   

User Function HCIDA015(xAutoCab,xAutoItens,nOpcAuto,lSimulacao,lSigaDPR)

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//쿏eclaracao das variaveis                                      ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
Local aCores := {}

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//? Tratamento de Filtro para o browse                           ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
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
Private cCadastro	:= OemtoAnsi(STR0001) 					//"Or놹mentos de Venda"
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

	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//쿔nicializacao da Mbrowse ou rotina automatica                 ?
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	dbSelectArea("SCJ")
	dbSetOrder(1)
	MsSeek(xFilial())
	If ( AMIIn(5,12) )
		//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
		//쿣erifica se o tamanho do campo CJ_TABELA                      ?
		//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
		If Len(SCJ->CJ_TABELA)<>3
			Aviso("SX3",STR0049,{"OK"}) //"O estrutura do campo CJ_TABELA esta diferente do padrao, solicitamos que seja alterado para Caracter de 3, antes de utilizar a rotina"
		Else
		
			mBrowse( 6, 1,22,75,"SCJ",,,,,,aCores,,,,,,,,cFilSQL)
		EndIf
	EndIf
	
Return(.T.)        

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽?
굇쿛rograma  쿘enuDef   ? Autor ? Marco Bianchi         ? Data ?01/09/2006낢?
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙?
굇쿏escri뇚o ? Utilizacao de menu Funcional                               낢?
굇?          ?                                                            낢?
굇?          ?                                                            낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇쿝etorno   쿌rray com opcoes da rotina.                                 낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇쿛arametros쿛arametros do array a Rotina:                               낢?
굇?          ?1. Nome a aparecer no cabecalho                             낢?
굇?          ?2. Nome da Rotina associada                                 낢?
굇?          ?3. Reservado                                                낢?
굇?          ?4. Tipo de Transa뇙o a ser efetuada:                        낢?
굇?          ?	  1 - Pesquisa e Posiciona em um Banco de Dados           낢?
굇?          ?    2 - Simplesmente Mostra os Campos                       낢?
굇?          ?    3 - Inclui registros no Bancos de Dados                 낢?
굇?          ?    4 - Altera o registro corrente                          낢?
굇?          ?    5 - Remove o registro corrente do Banco de Dados        낢?
굇?          ?5. Nivel de acesso                                          낢?
굇?          ?6. Habilita Menu Funcional                                  낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컫컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇?   DATA   ? Programador   쿘anutencao efetuada                         낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇?          ?               ?                                            낢?
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽?
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
							
								
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//쿣erifica motivo de bloqueio por regra/verba                             ?
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
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
						{ 'BR_VIOLETA', 'Orcamento em execu豫o'	},; //'Orcamento Cancelado' 	
						{ 'BR_CINZA'  , 'Orcamento Declinado' 	}}  // 'Orcamento Reprovado'

	BrwLegenda(cCadastro,STR0057,aCores )   //Pedido Liberado

Return()