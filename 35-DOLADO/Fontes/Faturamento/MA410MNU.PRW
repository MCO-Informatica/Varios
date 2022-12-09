#include "protheus.ch"

User Function MA410MNU()

Local aRotina2 := {}
Local aRotina3 := {}
Local _cAlias := "SF2"
Local _cVersao:= "1"
Local _cLayout:= "4.00"

Public BFILTRABRW := {}
Public cCondicao :=" "
cCondicao := "F2_FILIAL=='"+xFilial("SF2")+"'"
BFILTRABRW := {'SF2',cCondicao}

/*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
UTILIZADO PARA RECEBER UM ARRAY NA HORA DE EXPORTAR DANFES.

OBS: SEM ESSA INFORMAÇÃO, VAI DAR ERRO AO TENTAR EXPORTAR DIZENDO QUE NÃO EXISTE VARIAVEL AFILBRW.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%*/
Public AFILBRW := {}
Private cCondicao :=" "
cCondicao := "F2_FILIAL=='"+xFilial("SF2")+"'"
AFILBRW := {'SF2',cCondicao}

/*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
INICIA-SE O PONTO DE ENTRADA MA410MNU -> MENU DO PEDIDO DE VENDAS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%*/
	//FAZENDO UMA ORGANIZAÇÃO PARA "NOTAS FISCAIS"
	aadd(aRotina2,{"NFE Sefaz","SPEDNFE(SC5->C5_NOTA)"	, 2 , 2 })   //4, 0,NIL})		//"NFE Sefaz"
	aadd(aRotina2,{"Monitor NFE Mod.2","U_MonitNFE( SC5->C5_SERIE, SC5->C5_NOTA, SC5->C5_NOTA,'SC5')"	, 2 , 2 })   //4, 0,NIL})		//"Monitor NFE Mod.2"
	aadd(aRotina2,{"Transmitir NFE","U_TRANSMITE(SC5->C5_SERIE, SC5->C5_NOTA)", 2 , 2})
	
	//FAZENDO UMA ORGANIZAÇÃO PARA "DANFES"
	aadd(aRotina3,{"Gera Danfe","U_zGerDanfe('SC5')", 2 , 2 })   //4, 0,NIL})		//"Gera Danfe"
	
	//SÃO OS ITENS PADRÕES
	aadd(aRotina,{"Notas Fiscais",aRotina2, 0 , 2 })   //4, 0,NIL})		//"Notas Fiscais"

	aadd(aRotina,{"DANFES",aRotina3, 0 , 2 })   //4, 0,NIL})		//"DANFES"

	Aadd(aRotina, {"Gerar Etiqueta", "U_GERETIQ()", 2, 2})


	//aadd(aRotina,{"Libera Pedido","U_xLibePDV(SC5->C5_NUM)"	, 2 , 2 })   //4, 0,NIL})		//"Libera Pedido"

    //AADD(aRotina, {'Atualiza Separação', "U_RFATA05()", 0, 0, 0, Nil} ) //"Atualiza Separação"

	//AADD(aRotina, {'Imprime Pedido', "U_RFATR01()", 0, 0, 0, Nil} ) //"Imprime Pedido"

	//AADD(aRotina, {'Imprime Etiqueta', "U_RFATR03()", 0, 0, 0, Nil} ) //"Imprime Etiqueta"

Return()


User Function Transmite(cSerie,cNota)

SpedNFeTrf('SF2',cSerie,cNota,cNota,RetIdEnti(),'1','1','4.00',,,)

MsgInfo("Nota Fiscal "+cSerie+cNota+" acabou de ser transmitida!!!","ATENÇÃO") //EXIBE A MENSAGEM DIZENDO QUE A NOTA FOI TRANSMITIDA.

Return
