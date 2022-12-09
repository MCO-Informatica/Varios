/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ INTWORD  ³   Silverio Bastos			    ³ Data ³22.04.2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Orçamento de Vendas - integracao do Protheus com o MS Word ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Verion                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

/*/
#include "rwmake.ch"          

User Function intword()
@ 96,012 TO 250,400 DIALOG oDlg TITLE OemToAnsi("Orçamento de Venda")
@ 08,005 TO 048,190
@ 18,010 SAY OemToAnsi("Esta rotina ira imprimir os orcamentos conforme os parametros digitados.")

@ 56,130 BMPBUTTON TYPE 1 ACTION WordImp()
@ 56,160 BMPBUTTON TYPE 2 ACTION Close(oDlg)

ACTIVATE DIALOG oDlg CENTERED

Return()


Static Function WordImp()

Local wcOrcam, wcData, wcCliente, wcNroLinha
Local aSays		:=	{}
Local aButtons 	:= 	{}
local nOpca 	:= 	0
local cCadastro	:= 	"Geração de Orcamento AEM"
Local waItm		:= {}
Local waQtde	:= {}
Local waUnid	:= {}
Local waProd 	:= {}
Local waDescr	:= {}
Local waDesct	:= {}
Local waPrazo   := {}
Local waVUnit	:= {}
Local nAuxTot	:= 0
Local nK
Local cPathDot	:=  GETMV("MV_DIRORC")  // CHAMADO DO CAMINHO ONDE ESTA O ARQUIVO MODELO WORD INTWORD.DOT 
Private	hWord

private cPerg 	:= 	"INTWORD001"

PERGINTWR()

Pergunte(cPerg,.T.)
		
_iOrca	 := mv_par01 // Numero do Orçamento

If mv_par02 == 1

   _iModelo := "INTWORD.DOT"
   
Elseif mv_par02 == 2

   _iModelo := "INTWORD2.DOT"

Else

   _iModelo := "INTWORD3.DOT"
    
Endif                  

cPathDot	:= cPathDot + _iModelo // CHAMADO DO CAMINHO ONDE ESTA O ARQUIVO MODELO WORD INTWORD.DOT 

Close(oDlg)
                     
dbSelectArea("SCJ")
dbSetOrder(1)
SCJ->(dbseek(xFilial()+_iOrca))                                               

_iCliente := SCJ->CJ_CLIENTE+SCJ->CJ_LOJA                                                
_iEmissao := SCJ->CJ_EMISSAO
_iCondPgt := Posicione("SE4",1,xFilial("SE4")+SCJ->CJ_CONDPAG,"E4_DESCRI")
_iValidPr := SCJ->CJ_VALIDA
_iValReal := _iValDolar := _iValEuro := 0
_iVlmoeda := 1 
_iMoeda	  := SCJ->CJ_MOEDA
_iContato := SCJ->CJ_CONTATO
_iVend	  := Posicione("SA3",1,xFilial("SA3")+SCJ->CJ_VEND,"A3_NOME")

DbSelectArea("SM2")
DbSetOrder(1)
DbSeek(dDatabase)

If _iMoeda == 1
   _iVlMoeda := SM2->M2_MOEDA2
Elseif _iMoeda == 2
   _iVlMoeda := SM2->M2_MOEDA4
Endif   

wcNumero	:= _iOrca
wcData		:= AllTrim(Str(Day(_iEmissao),2))+' de '+AllTrim(MesExtenso(_iEmissao))+' de '+AllTrim(Str(Year(_iEmissao),4))
wcCliente	:= Alltrim(Posicione("SA1",1,xFilial("SA1")+_iCliente,"A1_NOME"))
wcFoneCli   := Alltrim(Posicione("SA1",1,xFilial("SA1")+_iCliente,"A1_DDD") +" - "+ Posicione("SA1",1,xFilial("SA1")+_iCliente,"A1_TEL"))
wcEmail		:= Alltrim(Posicione("SA1",1,xFilial("SA1")+_iCliente,"A1_EMAIL"))                                                
wcVendedor	:= Alltrim(_iVend)
wcContato	:= Alltrim(_iContato)
wcCondPgt	:= _iCondPgt
wcValidPr	:= AllTrim(Str(Day(_iValidpr),2))+' de '+AllTrim(MesExtenso(_iValidpr))+' de '+AllTrim(Str(Year(_iValidpr),4))
wcCMoeda	:= alltrim(str(_iMoeda))
wcVlMoeda	:= " (" + Transform(_iVlMoeda,"@E 99.9999") + ")  = "

dbSelectArea("SCK")
dbSetOrder(1)                                              
SCK->(dbseek(xFilial()+_iOrca))

nK := 0

While !SCK->(EOF()) .and. SCK->CK_NUM == _iOrca

	nK += 1
	_iProduto := Posicione("SB1",1,xFilial("SB1")+SCK->CK_PRODUTO,"B1_DESC")
   	_iPrazo	  := SCK->CK_ENTREG - _iEmissao 

	aAdd(waItm,strZero(nK,2))
	aAdd(waQtde,Transform(SCK->CK_QTDVEN,"@E 99999999.99"))
	aAdd(waUnid,SCK->CK_UM)
	aAdd(waProd,SCK->CK_PRODUTO)
	aAdd(waDescr,_iProduto) 
	aAdd(waPrazo,strZero(_iPrazo,3))
	aAdd(waDesct,Transform(SCK->CK_VRDESC,"@E 99.99")) 
	aAdd(waVUnit,Transform(SCK->CK_PRCVEN,"@E 999,999,999.99"))
	
	nAuxTot  += SCK->CK_VALOR
	
	SCK->(dbSkip())
	
End	                    

wcTotal	:= Transform(nAuxTot,"@E 999,999,999.99")                             

// Conversao da Moeda

If _iMoeda == 1
   nAuxDolar	:= wcTotal + wcVlmoeda + Transform(nAuxTot / _iVlMoeda,"@E 999,999,999.99")
   nAuxEuro		:= ""
   nAuxReal		:= ""
Elseif _iMoeda == 2
   nAuxEuro		:= wcTotal + wcVlmoeda + Transform(nAuxTot / _iVlMoeda,"@E 999,999,999.99")
   nAuxDolar	:= ""
   nAuxReal		:= ""
Else
   nAuxReal		:= wcTotal + wcVlmoeda + Transform(nAuxTot,"@E 999,999,999.99")
   nAuxEuro		:= ""
   nAuxDolar	:= ""
Endif   

//Conecta ao word
hWord	:= OLE_CreateLink()
OLE_NewFile(hWord, cPathDot )

//Montagem das variaveis do cabecalho		
OLE_SetDocumentVar(hWord, 'Prt_numero', wcNumero)
OLE_SetDocumentVar(hWord, 'Prt_Data', wcData)
OLE_SetDocumentVar(hWord, 'Prt_Cliente', wcCliente)
OLE_SetDocumentVar(hWord, 'Prt_FoneCli', wcFoneCli)
OLE_SetDocumentVar(hWord, 'Prt_Email', wcEmail)
OLE_SetDocumentVar(hWord, 'Prt_Vend', wcVendedor)
OLE_SetDocumentVar(hWord, 'Prt_Cont', wcContato)

OLE_SetDocumentVar(hWord, 'Prt_nroitens',str(Len(waItm)))	//variavel para identificar o numero total de
															//linhas na parte variavel
															//Sera utilizado na macro do documento para execucao 
															//do for next

//Montagem das variaveis dos itens. No documento word estas variaveis serao criadas dinamicamente da seguinte forma:
// prt_cod1, prt_cod2 ... prt_cod10
for nK := 1 to Len(waItm)

	OLE_SetDocumentVar(hWord,"Prt_Itm"+AllTrim(Str(nK)),waItm[nK])
	OLE_SetDocumentVar(hWord,"Prt_Qtd"+AllTrim(Str(nK)),waQtde[nK])
	OLE_SetDocumentVar(hWord,"Prt_Uni"+AllTrim(Str(nK)),waUnid[nK])
	OLE_SetDocumentVar(hWord,"Prt_Pro"+AllTrim(Str(nK)),waProd[nK])
	OLE_SetDocumentVar(hWord,"Prt_Dsc"+AllTrim(Str(nK)),waDescr[nK])
	OLE_SetDocumentVar(hWord,"Prt_Prz"+AllTrim(Str(nK)),waPrazo[nK])
	OLE_SetDocumentVar(hWord,"Prt_Dst"+AllTrim(Str(nK)),waDesct[nK])
	OLE_SetDocumentVar(hWord,"Prt_Unt"+AllTrim(Str(nK)),waVUnit[nK])

next nK

OLE_ExecuteMacro(hWord,"tabitens")

//Montagem das variaveis do rodape
OLE_SetDocumentVar(hWord, 'Prt_CondPgt', wcCondPgt)
OLE_SetDocumentVar(hWord, 'Prt_ValidPr', wcValidPr)
OLE_SetDocumentVar(hWord, 'Prt_CMoeda' , wcCmoeda)

OLE_SetDocumentVar(hWord, 'prt_totRea', nAuxReal)
OLE_SetDocumentVar(hWord, 'prt_totDol', nAuxDolar)
OLE_SetDocumentVar(hWord, 'prt_totEur', nAuxEuro)

OLE_SetDocumentVar(hWord, 'prt_totorc', wcTotal)

		
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualizando as variaveis do documento do Word                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
OLE_UpdateFields(hWord)
If MsgYesNo("Imprime o Documento ?")
	Ole_PrintFile(hWord,"ALL",,,1)
EndIf

If MsgYesNo("Fecha o Word e Corta o Link ?")
	OLE_CloseFile( hWord )
	OLE_CloseLink( hWord )
Endif	
Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PERGINTWR ºAutor  ³Silverio Bastos   º Data ³  05/02/10     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Cria as perguntas do SX1                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
static function PERGINTWR()
// cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg,cPyme,;
// cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01,cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3,cDef04,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5
PutSx1(cPerg,"01","Nro.Orçamento ? " ,"Nro.Orçamento ? " , "Nro.Orçamento ? " ,"mv_ch1" ,"C",06,0,0,"G","" ,"SCJ",,,"MV_PAR01",,,,,,,,,,)
PutSx1(cPerg,"02","Mod.Orçamento ? " ,"Mod.Orçamento ? " , "Mod.Orçamento ? " ,"mv_ch2" ,"N",01,0,1,"C","" ,,,,"MV_PAR02","Modelo A","Modelo A","Modelo A","","Modelo B","Modelo B","Modelo B","Modelo C","Modelo C","Modelo C")

//PutSx1(cPerg,"03","Contabilização? " ,"Contabilização? " , "Contabilização? " ,"mv_ch3" ,"N",01,0,0,"C","" ,"",,,"MV_PAR03","Notas de Compra","Notas de Saida","Financeiro","Ativo Fixo")
	
return
