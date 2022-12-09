#INCLUDE "Protheus.ch"
#INCLUDE "Topconn.ch"
#INCLUDE "TBICONN.CH"

/* Relatório impressão Solicitação de Compra */
    /*/{ProthUser eus.doc} TRCOMP
    (long_description)
:---------------------------------------------------------------------:
    @type  Function
    @author Vladimir
    @since 28/02/2022
:---------------------------------------------------------------------:    
:            @Help : TRCOMP                                           :
:                    MV_PAR01 = "Número sa S.C."                      :
:                    MV_PAR02 = "Número da Filial"                    :
:---------------------------------------------------------------------:
/*/


User Function TRCOMP(nNum)

Private oReport     := NIL
Private oSection1   := Nil
Private cPerg       := "TRCOMP" //Help Criado no Configurador, Contem os MV_PAR01 = "Número sa S.C." e MV_PAR02 = "Número da Filial"
Private cAlias
Private cAliasUSR
Private cString := Space(10)
Private oGet1
Private oDlg
Private cUser := UsrRetName(RetCodUsr())
Private cNCUsr := UsrFullName(RetCodUsr())
Private cEMLuse := UsrRetMail(RetCodUsr())
Private cDptUsr
Private cCargo
Private cRamal

//Departamento
privat aArray := {}
PswOrder(2)
If PswSeek( cUser, .T. )  
   aArray := PswRet()[1][12] // Retorna vetor com Departamento
   cDptUsr := aArray
EndIf

//Cargo
privat aArray := {}
PswOrder(2)
If PswSeek( cUser, .T. )  
   aArray := PswRet()[1][13] // Retorna vetor com Cargo
   cCargo := aArray
EndIf

//Ramal
privat aArray := {}
PswOrder(2)
If PswSeek( cUser, .T. )  
   aArray := PswRet()[1][20] // Retorna vetor com Ramal
   cRamal := aArray
EndIf


//Chama os Parâmetros / filtros do relatório
Pergunte(cPerg,.F.)
MV_PAR01    := nNum
cString     := SC1->C1_FILIAL
MV_PAR02    := cString


ReportDef() //Monta a estrutura
oReport:PrintDialog()

Return

/*Função Estrutura do Relatório*/
Static Function ReportDef()

oReport :=  TReport():New("Compras","Cotação de Compras  "+MV_PAR01+" Filial "+MV_PAR02,cPerg,{|oReport| PrintReport(oReport)})
oReport:SetLandScape(.T.) //Paisagem
oReport:nFontBody	:= 12  // Define o tamanho da fonte.
oReport:nLineHeight	:= 50 // Define a altura da linha.

/*  :--------------------------------------------------------:
    :       Section com os dados do Usurário                 :
    :--------------------------------------------------------:
*/

//oReport:SetLandScape(.T.)
//Trsection Controle da seção do Relatório
oSection1:= TRSection():New(oReport,"Listagem da Cotação",{"SC1"},/*aOrdem*/)


//ITENS
TRCell():New(oSection1, "C7_ITEMSC"     , cAlias  , "Item da SC"      , ""                ,   15,/*lPixel*/, {|| C7_ITEMSC}      , /*cAlign*/)
TRCell():New(oSection1, "C7_PRODUTO"    , cAlias  , "Produto"         , ""                ,   20,/*lPixel*/, {|| C7_PRODUTO}   , /*cAlign*/)
TRCell():New(oSection1, "C7_DESCRI"     , cAlias  , "Descricao"       , ""                ,   60,/*lPixel*/, {|| C7_DESCRI}    , /*cAlign*/)
TRCell():New(oSection1, "C7_UM"         , cAlias  , "Unid Medida"     , ""                ,   18,/*lPixel*/, {|| C7_UM}        , /*cAlign*/)
TRCell():New(oSection1, "C7_QUANT"      , cAlias  , "Quantidade"      , "@E 999,999.99"   ,   18,/*lPixel*/, {|| C7_QUANT}     , )
//TRCell():New(oSection1, "STATUS"      , cAlias  ,                   ,                   ,   18,/*lPixel*/, {|| nStatus()}     , )
Return

Static Function PrintReport(oReport)
cAlias := GetNextAlias()

oSection1:BeginQuery()

    BeginSql Alias cAlias

        SELECT
            C7_FILIAL, C7_ITEMSC, C7_PRODUTO, C7_DESCRI, C7_UM, C7_QUANT, C7_QUJE
        FROM   %table:SC7% SC7
        WHERE  C7_FILIAL=%exp:MV_PAR02% AND 
               C7_NUMSC=%exp:MV_PAR01% AND
               C7_QUANT > C7_QUJE AND
               SC7.%NotDel%

    EndSql

oSection1:EndQuery()
oSection1:Print()

(cAlias)->(DbCloseArea())
//|--------------------------------------------------------------|
//|        Impressao do quadro de concorrencias                  |
//|--------------------------------------------------------------|
	
	oReport:SkipLine() 
	oReport:ThinLine()
	oReport:SkipLine() 
	
	oReport:SkipLine() 
	oReport:ThinLine()
	oReport:SkipLine() 

	oReport:PrintText("Dados Usuario",,)
	oReport:FatLine()
    oReport:PrintText("| Nome completo: "+AllTrim(cNCUsr),,)
    oReport:PrintText("| Usuário:       "+AllTrim(cUser),,)
    oReport:PrintText("| Departamento:  "+AllTrim(cDptUsr),,)
	oReport:PrintText("| Cargo:         "+AllTrim(cCargo),,)
    oReport:PrintText("| E-Mail:        "+AllTrim(cEMLuse),,)
	oReport:PrintText("| Ramal:         "+AllTrim(cRamal),,)
    oReport:FatLine()
    
	
	oSection1:Finish()

  Return

/*


Static Function nStatus()
Local nPedido   := Posicione("SC1",1,xFilial("SC1")+MV_PAR01,"C1_PEDIDO")
Local nPosi := Posicione("SC1",1,xFilial("SC1")+nPedido,"C1_ITEM")
Local nQuantPed := Posicione("SC7",1,xFilial("SC7")+nPedido+C1_ITEM,"C7_QUANT")
Local nQuantEnt := Posicione("SC7",1,xFilial("SC7")+nPedido+C1_ITEM,"C7_QUJE")
Local nResiduo  := Posicione("SC7",1,xFilial("SC7")+nPedido+C1_ITEM,"C7_RESIDUO")
Local cDescri   := ""

IF nPedido != " "
nPedido   := Posicione("SC1",1,xFilial("SC1")+MV_PAR01,"C1_PEDIDO")
ELSE
nPosi := nPosi + 1
nPedido   := Posicione("SC1",1,xFilial("SC1")+MV_PAR01+nPosi,"C1_PEDIDO")

ENDIF

IF nQuantEnt < nQuantPed 

    cDescri := "PENDENTE"

ELSEIF !EMPTY(nResiduo)

    cDescri := "ELIM. POR RESIDUO"

ELSE

    cDescri := "ATENDIDA"

ENDIF

Return cDescri
*/
