#INCLUDE 'Protheus.ch'
#INCLUDE 'TOPConn.ch'
#INCLUDE "FILEIO.CH" 
#INCLUDE 'Rwmake.ch'

#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "APWIZARD.CH"
#INCLUDE "RPTDEF.CH"                                      
#INCLUDE "TOTVS.CH"
#INCLUDE "PARMTYPE.CH"

#DEFINE DIRXML  "XMLNFE\"
#DEFINE DIRALER "NEW\"
#DEFINE DIRLIDO "OLD\"
#DEFINE DIRERRO "ERR\" 

#DEFINE IMP_SPOOL 2

#DEFINE VBOX       080
#DEFINE VSPACE     008
#DEFINE HSPACE     010
#DEFINE SAYVSPACE  008
#DEFINE SAYHSPACE  008
#DEFINE HMARGEM    030
#DEFINE VMARGEM    030
#DEFINE MAXITEM    022                                                // Máximo de produtos para a primeira página
#DEFINE MAXITEMP2  049                                                // Máximo de produtos para a pagina 2 em diante
#DEFINE MAXITEMP2F 069                                                // Máximo de produtos para a página 2 em diante quando a página não possui informações complementares
#DEFINE MAXITEMP3  025                                                // Máximo de produtos para a pagina 2 em diante (caso utilize a opção de impressao em verso) - Tratamento implementado para atender a legislacao que determina que a segunda pagina de ocupar 50%.
#DEFINE MAXITEMC   038                                                // Máxima de caracteres por linha de produtos/serviços
#DEFINE MAXMENLIN  080                                                // Máximo de caracteres por linha de dados adicionais
#DEFINE MAXMSG     013                                                // Máximo de dados adicionais por página
#DEFINE MAXVALORC  009                                                // Máximo de caracteres por linha de valores numéricos


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³COMMI020  ºAutor  ³Felipi Marques      º Data ³  06/25/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Monitor de Compras de XML                                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function COMMI020() 

Local aCores  	:= {}
Local aCoresNew	:= {}

Local lRet    	:= .T.
Local lInverte  := .F.


Private cStartLido	:= Trim(DIRXML)+DIRLIDO
Private c2StartPath	:= Trim(cStartLido)+AllTrim(Str(Year(Date())))+"\"     //MES
Private c3StartPath	:= Trim(c2StartPath)+AllTrim(Str(Month(Date())))+"\"   //DIA	
Private aRotina	  := MenuDef()
Private cMarca	  := GetMark()
Private cCadastro := "Portal do XML / Nfe" 
Private aRegMark  := {}
Private aCom10PC	:= {} // Array livre para uso no PE COM10PC - MH 17/08/2018 
Private aIndSDS	:= {} 
Private cFilBrw 	:= ""
Private cFilSQL 	:= ""
//-- Prepara estrutura de diretorios
If !ExistDir(DIRXML)
	MakeDir(DIRXML)
	MakeDir(DIRXML +DIRALER)
	MakeDir(DIRXML +DIRLIDO)
	MakeDir(DIRXML +DIRERRO)
	
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ mv_par01: Documento de 					³
//³ mv_par02: Documento ate 				³
//³ mv_par03: Serie de 						³
//³ mv_par04: Serie ate 					³
//³ mv_par05: Fornecedor de 				³
//³ mv_par06: Fornecedor ate 				³
//³ mv_par07: Emissao de 					³
//³ mv_par08: Emissao ate 					³
//³ mv_par09: Importacao de 				³
//³ mv_par10: Importacao ate 				³
//³ mv_par11: Mostra gerados: 1=Sim ; 2=Nao	³
//³ mv_par12: Quanto ao PC					³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lRet .And. Pergunte("MTA140I",.T.)

	aAdd(aCores,{'DS_STATUS == "P"','BR_VERMELHO'})	// -- "Documento Gerado"
	aAdd(aCores,{'DS_STATUS == "E"','BR_PRETO'})	// -- "Documento c/ Ocorrência"  
	aAdd(aCores,{'DS_STATUS == "I"' ,'BR_BRANCO'})	// -- "Nota de Importacao"
	aAdd(aCores,{'DS_STATUS == "X"' ,'BR_VIOLETA'})	// -- "Nota erro pedido vs fornecedor"	
	aAdd(aCores,{'DS_TIPO == "N"','BR_VERDE'})		// -- "Documento Normal"
	aAdd(aCores,{'DS_TIPO == "O"','BR_AZUL'})		// -- "Docto. de Bonificação"
	aAdd(aCores,{'DS_TIPO == "D"','BR_AMARELO'})	// -- "Docto. de Devolução"
	aAdd(aCores,{'DS_TIPO == "B"','BR_CINZA'})		// -- "Docto. de Beneficiamento"
	aAdd(aCores,{'DS_TIPO == "C"','BR_PINK'})		// -- "Docto. de Compl. Preço"
	aAdd(aCores,{'DS_TIPO == "T"','BR_LARANJA'})	// -- "Docto. de Transporte"


	//-- Monta filtro ISAM
	cFilBrw := 'DS_DOC >= "' +mv_par01 +'" .And. DS_DOC <= "' +mv_par02 +'" .And. '
	cFilBrw += 'DS_SERIE >= "' +mv_par03 +'" .And. DS_SERIE <= "' +mv_par04 +'" .And. '
	cFilBrw += 'DS_FORNEC >= "' +mv_par05 +'" .And. DS_FORNEC <= "' +mv_par06 +'" .And. '
	cFilBrw += 'DToS(DS_EMISSA) >= "'  +DToS(mv_par07) +'" .And. DToS(DS_EMISSA) <= "'  +DToS(mv_par08) +'" .And. '
	cFilBrw += 'DToS(DS_DATAIMP) >= "'  +DToS(mv_par09) +'" .And. DToS(DS_DATAIMP) <= "'  +DToS(mv_par10) +'"'
	If mv_par11 == 2
		cFilBrw += ' .And. DS_STATUS <> "P"'
	EndIf
	
	//1=Recebido o xml;2=Ped Associado;3=WF Enviado;4=WF Retornado;5=Manifestado
    //	If !Empty(mv_par12)  
	//	If FieldPos("DS_STAPED") > 0 
	//		cFilBrw += ' .And. DS_STAPED = "'+Alltrim(Str(mv_par12))+'"'
	//	EndIf	
	//EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicializa o filtro                                                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SDS")
	dbSetOrder(2)
    bFiltraBrw := {|| FilBrowse("SDS",@aIndSDS,@cFilBrw,.T.) } //MH
	MsgRun("Aplicando filtros e preparando inferface... ","Aguarde",{|| CursorWait(),Eval(bFiltraBrw),CursorArrow(),MarkBrow("SDS","DS_OK",'',,lInverte,cMarca,'U_MarkAll()',,,,'U_ComXMark()',,,,aCores)}) //MH
EndIf
                    
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MenuDef  ºAutor  ³Felipi Marques      º Data ³  06/25/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Monta as opcoes de rotina.                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MenuDef                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function MenuDef()

Local aRotAlt		:= {}
Private aRotina	:= {}

aAdd(aRotina,{"Pesquisar"     ,"PesqBrw"		                     ,0,1,0,.F.}) 					 
aAdd(aRotina,{"Visualizar"    ,"StaticCall(COMMI020,Visualizar)"     ,0,2,0,NIL}) 
aAdd(aRotina,{"Vinc. Docto"   ,"StaticCall(COMMI020,Vincular)"       ,0,4,0,nil})	 
aAdd(aRotina,{"Gerar Docto"   ,"StaticCall(COMMI020,GerarDocs)"      ,0,4,0,nil}) 
aAdd(aRotina,{"Reprocessar"   ,"StaticCall(COMMI020,Reprocessa)"     ,0,3,0,nil})	
aAdd(aRotina,{"Imp XML Manual","StaticCall(COMMI020,Remessa)"        ,0,3,0,nil}) 
aAdd(aRotina,{"Imp XML Lote"  ,"StaticCall(COMMI020,Lote)"           ,0,3,0,nil}) 
aAdd(aRotina,{"Imp XML via E-mail","StaticCall(COMMI020,Email)"      ,0,3,0,nil}) 
aAdd(aRotina,{"Imp arquivo Nfs-e" ,"StaticCall(COMMI020,SelNfe)"     ,0,3,0,nil})  
aAdd(aRotina,{"Excluir"       ,"StaticCall(COMMI020,Excluir)"        ,0,4,0,nil})   
aAdd(aRotina,{"Imprime Danfe" ,"StaticCall(COMMI020,Danfe)"          ,0,2,0,nil})
aAdd(aRotina,{"Exporta XML"   ,"StaticCall(COMMI020,Exportar)"       ,0,2,0,nil})
aAdd(aRotina,{"Consulta NF-e" ,"StaticCall(COMMI020,PesqChv)"        ,0,3,0,.F.})
aAdd(aRotina,{"Legenda"       ,"U_I20Leg"						     ,0,3,0,.F.})	    


Return aRotina

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Visualizarº     ³Felipi Marques        º Data ³  06/25/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Monta interface pra visualizacao do documento.             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Visualizar()
Return MontaTela(2)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ Vincular      ³Felipi Marques        º Data ³  06/25/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Monta interface vinculo do documento com pedidos/nf origem.º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Vincular()
Local lRet := .T.
Local lRemet := .F.

If SDS->DS_TIPO == "T" .And. SDS->DS_TPFRETE == "F" // Verifica se e CT-e e se e remetente da mercadoria (saida), neste caso deve permitir vincular pedido
	lRemet := .T.
EndIf

If SDS->DS_STATUS == "P"
	Aviso("Atenção","Esta ação não pode ser executada para documentos já gerados.",{"OK"})
	lRet := .F.
EndIf
     
If !(SDS->DS_TIPO $ "NDC")
	If !lRemet							// Quando for CT-e referente a envio de mercadoria deve permitir vinculo com pedido, caso contrario nao deve permitir
		Aviso("Atenção","Esta ação pode ser executada apenas para documentos do tipo Normal, Devolução, Complemento ou CT-e referente a envio de mercadoria.",{"OK"})
		lRet := .F.
	EndIf
EndIf

If lRet
	lRet := MontaTela(4)
EndIf

aRotina	  := MenuDef()
dbSelectArea("SDS")
dbSetOrder(2)
bFiltraBrw := {|| FilBrowse("SDS",@aIndSDS,@cFilBrw,.T.) } 
Eval(bFiltraBrw)

Return lRet

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ VincXPC ºAutor  ³Felipi Marques       º Data ³  06/25/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Monta interface vinculo de multiplos pedidos				  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function VincXPC()
Local lRet := .T.
Local lRemet := .F.
Local aArea := GetArea()

If SDS->DS_TIPO == "T" .And. SDS->DS_TPFRETE == "F" // Verifica se e CT-e e se e remetente da mercadoria (saida), neste caso deve permitir vincular pedido
	lRemet := .T.
EndIf

If SDS->DS_STATUS == "P"
	Aviso("Atenção","Esta ação não pode ser executada para documentos já gerados.",{"OK"})
	lRet := .F.
EndIf
     
If !(SDS->DS_TIPO $ "NC")
	If !lRemet							// Quando for CT-e referente a envio de mercadoria deve permitir vinculo com pedido, caso contrario nao deve permitir
		Aviso("Atenção","Esta ação pode ser executada apenas para documentos do tipo Normal, Complemento ou CT-e referente a envio de mercadoria.",{"OK"})
		lRet := .F.
	EndIf
EndIf

If lRet
	lRet := MontaTela(5)
EndIf

RestArea(aArea) 
dbSelectArea("SDS")
dbSetOrder(2)
bFiltraBrw := {|| FilBrowse("SDS",@aIndSDS,@cFilBrw,.T.) } 
Eval(bFiltraBrw)

Return lRet 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MontaTela ºAutor ³Felipi Marques       º Data ³  06/25/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Monta interface de visualização e vinculo do documeto.     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ nOpc: opcao de rotina acionada (2=Visualizar;4Vincular)	  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function MontaTela(nOpc)
Local lRet   	:= .F.
Local oDlg      := NIL
Local oEnchoice := NIL
Local oFolder	:= NIL
Local oComboFrt := NIL
Local oSize     := FwDefSize():New()
Local aCpsAlt	:= {}
Local aNoFields := {}
Local aButtons  := {}
Local aPosCab   := {}
Local aPosIts   := {}
Local aPosRdp	:= {}
Local aFolders  := {"Totais","Dados DANFE","Dados da NF-e","Dados da Importação","Dados da Geração","Ocorrência","Arquivo XML"}
Local cSeek	    := ""
Local cStatus	:= ""
Local bWhile	:= {|| SDT->(DT_FILIAL+DT_FORNEC+DT_LOJA+DT_DOC+DT_SERIE)}
Local nTotDoc	:= SDS->(DS_VALMERC+DS_DESPESA+DS_FRETE+DS_SEGURO-DS_DESCONT)
Local nX		:= 0
Local nY		:= 0
Local nMultPC	:= 0
Local nPosPed	:= 0
Local nPosItPC	:= 0
Local oGetDados := NIL
Local aColsAnt  := {}
Local cFilBkp   := cFilAnt
Local lRemet	:= .F.
Local cFilSDT := 	xFilial("SDT")
Local lGrava	:= .T.
Local lMsErroAuto := .F.   
Local nP := 0
Local lValProd    := SuperGetMV("MV_XMLVPRO",.F.,.F.) // Parametro para validação do produto 04/04/16 - Felipi Marques Validação se deixa o produto ser alterado
Private aHeader   := {}
Private aCols	  := {}

//-- Se filial diferente, troca
If PadR(cFilAnt,Len(AllTrim(SDS->DS_FILIAL))) # AllTrim(SDS->DS_FILIAL)
	Do Case
		Case FWModeAccess("SB2",3) == "E"
			cFilAnt := SDS->DS_FILIAL
		Case FWModeAccess("SB2",2) == "E" .Or. FWModeAccess("SB2",1) == "E"
			SM0->(dbSetOrder(1))
			SM0->(dbSeek(cEmpAnt+SDS->DS_FILIAL))
			cFilAnt := SM0->M0_CODFIL
	EndCase
EndIf

cSeek := cFilSDT+SDS->(DS_FORNEC+DS_LOJA+DS_DOC+DS_SERIE)
									
oSize:AddObject("CABEC",100,20,.T.,.T.) // Totalmente dimensionavel
oSize:AddObject("ITENS",100,55,.T.,.T.) // Totalmente dimensionavel 
oSize:AddObject("RODAP",100,25,.T.,.T.) // Totalmente dimensionavel
oSize:lProp := .T. 						 // Proporcional             
oSize:aMargins := {0,0,0,3}			  	 // Espaco ao lado dos objetos 0, entre eles 3 
oSize:Process() 	   					 // Dispara os calculos de coordenadas

aPosCab := {oSize:GetDimension("CABEC","LININI"),oSize:GetDimension("CABEC","COLINI"),;
			oSize:GetDimension("CABEC","LINEND"),oSize:GetDimension("CABEC","COLEND")}
aPosIts := {oSize:GetDimension("ITENS","LININI"),oSize:GetDimension("ITENS","COLINI"),;
			oSize:GetDimension("ITENS","LINEND"),oSize:GetDimension("ITENS","COLEND")}
aPosRdp := {oSize:GetDimension("RODAP","LININI"),oSize:GetDimension("RODAP","COLINI"),;
			oSize:GetDimension("RODAP","LINEND"),oSize:GetDimension("RODAP","COLEND")}

//-- Tratamento para que seja possivel alterar os campos da nota origem
If nOpc == 4 .And. SDS->DS_TIPO $ "DC"
	aRotina[2,4] := 6
EndIf

// Verifica se e CT-e e se e remetente da mercadoria (saida), neste caso deve exibir os campos para vinculo com pedido
If SDS->DS_TIPO == "T" .And. SDS->DS_TPFRETE == "F"
	lRemet := .T.
EndIf

//-- Retira campos que nao sao usados pelo tipo de documento
If SDS->DS_TIPO $ "DC"
	aNoFields := {"DT_PEDIDO","DT_ITEMPC"}
ElseIf SDS->DS_TIPO == "N"
	aNoFields := {"DT_NFORI","DT_SERIORI","DT_ITEMORI"}
ElseIf SDS->DS_TIPO == "T"
	If lRemet
		aNoFields := {"DT_PRODFOR","DT_DESCFOR","DT_NFORI","DT_SERIORI","DT_ITEMORI"}
	Else
		aNoFields := {"DT_PRODFOR","DT_DESCFOR","DT_PEDIDO","DT_ITEMPC","DT_NFORI","DT_SERIORI","DT_ITEMORI"}
	EndIf
Else
	aNoFields := {"DT_PEDIDO","DT_ITEMPC","DT_NFORI","DT_SERIORI","DT_ITEMORI"}
EndIf


If lValProd // Validação se existe trava para a pre nota ja com amarração 04/04/16 - Felipi Marques Validação se deixa o produto ser alterado
	IF SDS->DS_STATUS == 'X'
		aCpsAlt := {"DT_COD"}
	Else
		aCpsAlt := If(nOpc == 4,{"DT_NFORI","DT_SERIORI","DT_ITEMORI","DT_PEDIDO","DT_ITEMPC"},{})
	EndIf
Else     
	aCpsAlt := {"DT_COD"}
	If SDS->DS_STATUS <> 'X'
		aCpsAlt := If(nOpc == 4,{"DT_COD","DT_NFORI","DT_SERIORI","DT_ITEMORI"},{})
	EndIf
EndIf


RegToMemory("SDS",.F.,.T.)
FillGetDados(2,"SDT",3,cSeek,bWhile,,aNoFields,,,,,.F.,aHeader,aCols)
aSort(aCols,,,{|x,y| x[GDFieldPos("DT_ITEM")] < y[GDFieldPos("DT_ITEM")]}) //-- Ordena por item
aColsAnt := aClone(aCols)
Define MsDialog oDlg From oSize:aWindSize[1],oSize:aWindSize[2] To oSize:aWindSize[3],oSize:aWindSize[4];
					 Title "Portal da Nota Fiscal Eletrônica" +" - " +If(nOpc == 2,"Visualização","Vincular Documento") Of oMainWnd Pixel 

oEnchoice := MsMGet():New("SDS",,2,,,,,aPosCab,,,,,,oDlg) 
//olGetDd   := MsGetDados():New(0         ,0         ,0         ,0         ,nlOpc,,,"",.F.,aCpos1 ,,.T.,Len(ACols),,,,,oPanelG)
  oGetDados := MsGetDados():New(aPosIts[1],aPosIts[2],aPosIts[3],aPosIts[4],nOpc ,,,"",.F.,aCpsAlt,,.T.,9999,,,,,oDlg)
oFolder   := TFolder():New(aPosRdp[1],aPosRdp[2],aFolders,,oDlg,,,,.T.,,aPosRdp[4]-aPosRdp[2],aPosRdp[3]-aPosRdp[1])

//-- Montagem dos campos do rodape

//-- Vlr. Mercadoria
TSay():New(10,10,{|| RetTitle("DS_VALMERC")},oFolder:aDialogs[1],,,,,,.T.,,,50,10)
TGet():New(08,70,{|| SDS->DS_VALMERC},oFolder:aDialogs[1],50,10,PesqPict("SDS","DS_VALMERC"),,,,,,,.T.,,,,,,,.T.,,,"DS_VALMERC")
//-- Vlr. Frete
TSay():New(30,10,{|| RetTitle("DS_FRETE")},oFolder:aDialogs[1],,,,,,.T.,,,50,10)
TGet():New(28,70,{|| SDS->DS_FRETE},oFolder:aDialogs[1],50,10,PesqPict("SDS","DS_FRETE"),,,,,,,.T.,,,,,,,.T.,,,"DS_FRETE")
//-- Vlr. Seguro
TSay():New(10,180,{|| RetTitle("DS_SEGURO")},oFolder:aDialogs[1],,,,,,.T.,,,50,10)
TGet():New(08,250,{|| SDS->DS_SEGURO},oFolder:aDialogs[1],50,10,PesqPict("SDS","DS_SEGURO"),,,,,,,.T.,,,,,,,.T.,,,"DS_SEGURO")
//-- Vlr. Despesas
TSay():New(30,180,{|| RetTitle("DS_DESPESA")},oFolder:aDialogs[1],,,,,,.T.,,,50,10)
TGet():New(28,250,{|| SDS->DS_DESPESA},oFolder:aDialogs[1],50,10,PesqPict("SDS","DS_DESPESA"),,,,,,,.T.,,,,,,,.T.,,,"DS_DESPESA")
//-- Descontos
TSay():New(10,350,{|| RetTitle("DS_DESCONT")},oFolder:aDialogs[1],,,,,,.T.,,,50,10)
TGet():New(08,430,{|| SDS->DS_DESCONT},oFolder:aDialogs[1],50,10,PesqPict("SDS","DS_DESCONT"),,,,,,,.T.,,,,,,,.T.,,,"DS_DESCONT")
//-- Total do documento
TSay():New(70,10,{|| "Total do documento"},oFolder:aDialogs[1],,,,,,.T.,,,50,10)
TGet():New(68,70,{|| nTotDoc},oFolder:aDialogs[1],50,10,PesqPict("SDS","DS_VALMERC"),,,,,,,.T.,,,,,,,.T.,,,"nTotDoc")

//-- Transportadora
TSay():New(10,10,{|| RetTitle("DS_TRANSP")},oFolder:aDialogs[2],,,,,,.T.,,,40,10)
TGet():New(08,50,{|| SDS->DS_TRANSP},oFolder:aDialogs[2],40,10,PesqPict("SDS","DS_TRANSP"),,,,,,,.T.,,,,,,,.T.,,,"DS_TRANSP")
//-- Placa
TSay():New(30,10,{|| RetTitle("DS_PLACA")},oFolder:aDialogs[2],,,,,,.T.,,,40,10)
TGet():New(28,50,{|| SDS->DS_PLACA},oFolder:aDialogs[2],40,10,PesqPict("SDS","DS_PLACA"),,,,,,,.T.,,,,,,,.T.,,,"DS_PLACA")
//-- Peso Liquido
TSay():New(10,110,{|| RetTitle("DS_PLIQUI")},oFolder:aDialogs[2],,,,,,.T.,,,40,10)
TGet():New(08,160,{|| SDS->DS_PLIQUI},oFolder:aDialogs[2],70,10,PesqPict("SDS","DS_PLIQUI"),,,,,,,.T.,,,,,,,.T.,,,"DS_PLIQUI")
//-- Peso Bruto
TSay():New(30,110,{|| RetTitle("DS_PBRUTO")},oFolder:aDialogs[2],,,,,,.T.,,,5400,10)
TGet():New(28,160,{|| SDS->DS_PBRUTO},oFolder:aDialogs[2],70,10,PesqPict("SDS","DS_PBRUTO"),,,,,,,.T.,,,,,,,.T.,,,"DS_PBRUTO")
//-- Tipo de frete
TSay():New(50,10,{|| RetTitle("DS_TPFRETE")},oFolder:aDialogs[2],,,,,,.T.,,,5400,10)
oComboFrt := TComboBox():New(48,50,{|| SDS->DS_TPFRETE},{"C=CIF","F=FOB","T=Por Terceiros","S=Sem Frete"},70,10,oFolder:aDialogs[2],,,,,,.T.,,,,,,,,,"DS_TPFRETE")
oComboFrt:Disable()
//-- Especie 1
TSay():New(10,290,{|| RetTitle("DS_ESPECI1")},oFolder:aDialogs[2],,,,,,.T.,,,40,10)
TGet():New(08,330,{|| SDS->DS_ESPECI1},oFolder:aDialogs[2],90,10,PesqPict("SDS","DS_ESPECI1"),,,,,,,.T.,,,,,,,.T.,,,"DS_ESPECI1")
//-- Especie 2
TSay():New(30,290,{|| RetTitle("DS_ESPECI2")},oFolder:aDialogs[2],,,,,,.T.,,,40,10)
TGet():New(28,330,{|| SDS->DS_ESPECI2},oFolder:aDialogs[2],90,10,PesqPict("SDS","DS_ESPECI2"),,,,,,,.T.,,,,,,,.T.,,,"DS_ESPECI2")
//-- Especie 3
TSay():New(50,290,{|| RetTitle("DS_ESPECI3")},oFolder:aDialogs[2],,,,,,.T.,,,40,10)
TGet():New(48,330,{|| SDS->DS_ESPECI3},oFolder:aDialogs[2],90,10,PesqPict("SDS","DS_ESPECI3"),,,,,,,.T.,,,,,,,.T.,,,"DS_ESPECI3")
//-- Especie 4
TSay():New(70,290,{|| RetTitle("DS_ESPECI4")},oFolder:aDialogs[2],,,,,,.T.,,,40,10)
TGet():New(68,330,{|| SDS->DS_ESPECI4},oFolder:aDialogs[2],90,10,PesqPict("SDS","DS_ESPECI4"),,,,,,,.T.,,,,,,,.T.,,,"DS_ESPECI4")
//-- Volume 1
TSay():New(10,440,{|| RetTitle("DS_VOLUME1")},oFolder:aDialogs[2],,,,,,.T.,,,40,10)
TGet():New(08,480,{|| SDS->DS_VOLUME1},oFolder:aDialogs[2],50,10,PesqPict("SDS","DS_VOLUME1"),,,,,,,.T.,,,,,,,.T.,,,"DS_VOLUME1")
//-- Volume 2
TSay():New(30,440,{|| RetTitle("DS_VOLUME2")},oFolder:aDialogs[2],,,,,,.T.,,,40,10)
TGet():New(28,480,{|| SDS->DS_VOLUME2},oFolder:aDialogs[2],50,10,PesqPict("SDS","DS_VOLUME2"),,,,,,,.T.,,,,,,,.T.,,,"DS_VOLUME2")
//-- Volume 3
TSay():New(50,440,{|| RetTitle("DS_VOLUME3")},oFolder:aDialogs[2],,,,,,.T.,,,40,10)
TGet():New(48,480,{|| SDS->DS_VOLUME3},oFolder:aDialogs[2],50,10,PesqPict("SDS","DS_VOLUME3"),,,,,,,.T.,,,,,,,.T.,,,"DS_VOLUME3")
//-- Volume 4
TSay():New(70,440,{|| RetTitle("DS_VOLUME4")},oFolder:aDialogs[2],,,,,,.T.,,,40,10)
TGet():New(68,480,{|| SDS->DS_VOLUME4},oFolder:aDialogs[2],50,10,PesqPict("SDS","DS_VOLUME4"),,,,,,,.T.,,,,,,,.T.,,,"DS_VOLUME4")

//-- Chave NF-e
TSay():New(10,10,{|| RetTitle("DS_CHAVENF")},oFolder:aDialogs[3],,,,,,.T.,,,50,10)
TGet():New(08,70,{|| SDS->DS_CHAVENF},oFolder:aDialogs[3],230,10,PesqPict("SDS","DS_CHAVENF"),,,,,,,.T.,,,,,,,.T.,,,"DS_CHAVENF")
//-- Versao NF-e
TSay():New(30,10,{|| RetTitle("DS_VERSAO")},oFolder:aDialogs[3],,,,,,.T.,,,50,10)
TGet():New(28,70,{|| SDS->DS_VERSAO},oFolder:aDialogs[3],50,10,PesqPict("SDS","DS_VERSAO"),,,,,,,.T.,,,,,,,.T.,,,"DS_VERSAO")
//-- Nome do arquivo
TSay():New(50,10,{|| RetTitle("DS_ARQUIVO")},oFolder:aDialogs[3],,,,,,.T.,,,50,10)
TGet():New(48,70,{|| SDS->DS_ARQUIVO},oFolder:aDialogs[3],230,10,PesqPict("SDS","DS_ARQUIVO"),,,,,,,.T.,,,,,,,.T.,,,"DS_ARQUIVO")

//-- Usuario
TSay():New(10,10,{|| RetTitle("DS_USERIMP")},oFolder:aDialogs[4],,,,,,.T.,,,50,10)
TGet():New(08,70,{|| SDS->DS_USERIMP},oFolder:aDialogs[4],100,10,PesqPict("SDS","DS_USERIMP"),,,,,,,.T.,,,,,,,.T.,,,"DS_USERIMP")
//-- Data
TSay():New(30,10,{|| RetTitle("DS_DATAIMP")},oFolder:aDialogs[4],,,,,,.T.,,,50,10)
TGet():New(28,70,{|| SDS->DS_DATAIMP},oFolder:aDialogs[4],50,10,PesqPict("SDS","DS_DATAIMP"),,,,,,,.T.,,,,,,,.T.,,,"DS_DATAIMP")
//-- Hora
TSay():New(50,10,{|| RetTitle("DS_HORAIMP")},oFolder:aDialogs[4],,,,,,.T.,,,50,10)
TGet():New(48,70,{|| SDS->DS_HORAIMP},oFolder:aDialogs[4],50,10,PesqPict("SDS","DS_HORAIMP"),,,,,,,.T.,,,,,,,.T.,,,"DS_HORAIMP")

//-- Usuario
TSay():New(10,10,{|| RetTitle("DS_USERPRE")},oFolder:aDialogs[5],,,,,,.T.,,,50,10)
TGet():New(08,70,{|| SDS->DS_USERPRE},oFolder:aDialogs[5],100,10,PesqPict("SDS","DS_USERPRE"),,,,,,,.T.,,,,,,,.T.,,,"DS_USERPRE")
//-- Data
TSay():New(30,10,{|| RetTitle("DS_DATAPRE")},oFolder:aDialogs[5],,,,,,.T.,,,50,10)
TGet():New(28,70,{|| SDS->DS_DATAPRE},oFolder:aDialogs[5],50,10,PesqPict("SDS","DS_DATAPRE"),,,,,,,.T.,,,,,,,.T.,,,"DS_DATAPRE")
//-- Hora
TSay():New(50,10,{|| RetTitle("DS_HORAPRE")},oFolder:aDialogs[5],,,,,,.T.,,,50,10)
TGet():New(48,70,{|| SDS->DS_HORAPRE},oFolder:aDialogs[5],50,10,PesqPict("SDS","DS_HORAPRE"),,,,,,,.T.,,,,,,,.T.,,,"DS_HORAPRE")

//-- Ocorrencia
TMultiGet():New(10,10,{|| SDS->DS_DOCLOG},oFolder:aDialogs[6],aPosRdp[4]*0.96,oFolder:nHeight*0.35,,,,,,.T.,,,,,,.T.)

//-- XML
TMultiGet():New(10,10,{|| SDS->DS_NFXML},oFolder:aDialogs[7],aPosRdp[4]*0.96,oFolder:nHeight*0.35,,,,,,.T.,,,,,,.T.)

If nOpc == 4 .And. ( SDS->DS_TIPO $ "DCN" .Or. lRemet )
	aAdd(aButtons, {"PEDIDO", {|| Documentos(aCols[n,GDFieldPos("DT_COD")],.F.)}, If(SDS->DS_TIPO $ "NT","Pedido de Compra (Item)","Documento Origem"),If(SDS->DS_TIPO $ "NT","PC (Item)","Origem")})
	If SDS->DS_TIPO $ "NT"
		aAdd(aButtons, {"SOLICITA", {|| Documentos(aCols[n,GDFieldPos("DT_COD")],.T.)},"Pedido de Compra (Doc.)","PC (Doc.)"})
	EndIf
EndIf

If nOpc == 5 .And. ( SDS->DS_TIPO $ "CN" .Or. lRemet )
	If SDS->DS_TIPO $ "NT"
		aAdd(aButtons, {"MULTPC",   {|| Documentos(aCols[n,GDFieldPos("DT_COD")],.F.,nMultPC:=1,aColsAnt)},"Vincula Multiplos pedidos por item"})  
		aAdd(aButtons, {"MULTIT",   {|| Documentos(aCols[n,GDFieldPos("DT_COD")],.T.,nMultPC:=2,aColsAnt)},"Vincula Multiplos pedidos por documento"}) 
	EndIf
EndIf	

Activate MsDialog oDlg On Init(EnchoiceBar(oDlg,{|| lRet := .T.,IIF(IIF(SDS->DS_TIPO=="D",U_xTudoOk(),.T.),oDlg:End(),)}, {|| IIF(SDS->DS_TIPO=="D",ComXGetAnt(aColsAnt),),oDlg:End()},,aButtons))

If lRet .And. nOpc == 4 //-- Caso tenha processado o vinculo
	If SDS->DS_STATUS = 'X'
		For nLpx := 1 To Len(aCols)
			_aProdFor := {}
			cTabEmit := If(SDS->DS_TIPO == "N","SA2","SA1")
			(cTabEmit)->(dbSetOrder(1))
			(cTabEmit)->(dbSeek(xFilial(cTabEmit)+SDS->DS_FORNEC+SDS->DS_LOJA))
			cCodigo := (cTabEmit)->&(Substr(cTabEmit,2,2)+"_COD")
			cLoja   := (cTabEmit)->&(Substr(cTabEmit,2,2)+"_LOJA")
			
			cCampo1 := If(SDS->DS_TIPO # "N","A7_PRODUTO","A5_PRODUTO")
			cCampo2 := If(SDS->DS_TIPO # "N","A7_FILIAL","A5_FILIAL")
			cCampo3 := If(SDS->DS_TIPO # "N","A7_CLIENTE","A5_FORNECE")
			cCampo4 := If(SDS->DS_TIPO # "N","A7_LOJA","A5_LOJA")
			cCampo5 := If(SDS->DS_TIPO # "N","A7_CODCLI","A5_CODPRF")
			
			cProduto := AllTrim(aCols[nLpx,GDFieldPos("DT_PRODFOR")])
			
			cQuery := "SELECT " +cCampo1 +" FROM " +RetSqlName(If(SDS->DS_TIPO # "N","SA7","SA5"))
			cQuery += " WHERE D_E_L_E_T_ <> '*' AND "
			cQuery += cCampo2 +" = '" +xFilial(If(SDS->DS_TIPO # "N","SA7","SA5")) +"' AND "
			cQuery += cCampo3 +" = '" +cCodigo +"' AND "
			cQuery += cCampo4 +" = '" +cLoja +"' AND "
			cQuery += cCampo5 +" = '" +cProduto +"'"
			
			If Select("TRB") > 0
				TRB->(dbCloseArea())
			EndIf
			
			TcQuery cQuery new Alias "TRB"
			TRB->(dbGotop())
			
			If TRB->(EOF())
				If SDS->DS_TIPO # "N"
					//Cadastro de Produto X Cliente não possui rotina automática, gravação via Reclock
					dbSelectArea("SA7")
					If SA7->(dbSetOrder(1), dbSeek(xFilial("SA7")+cCodigo+cLoja+aCols[nLpx,GDFieldPos("DT_COD")]))
						RecLock("SA7",.F.)
					Else
						Reclock("SA7",.T.)
					Endif
					A7_FILIAL 	:= xFilial("SA7")
					A7_CLIENTE 	:= cCodigo
					A7_LOJA 	:= cLoja
					A7_CODCLI   := cProduto
					A7_PRODUTO  := aCols[nLpx,GDFieldPos("DT_COD")]
					SA7->(MsUnlock())
					
				Else
					If  !Empty(aCols[nLpx,GDFieldPos("DT_COD")])
						dbSelectArea("SA5")
						If SA5->(dbSetOrder(1), dbSeek(xFilial("SA5")+cCodigo+cLoja+aCols[nLpx,GDFieldPos("DT_COD")] ))
							RecLock("SA5",.F.)
						Else
							Reclock("SA5",.T.)
						Endif
						A5_FILIAL 	:= xFilial("SA5")
						A5_FORNECE 	:= cCodigo
						A5_LOJA 	:= cLoja
						A5_NOMEFOR  := Posicione("SA2",1,xFilial("SA2")+cCodigo,"A2_NOME")
						A5_PRODUTO  := aCols[nLpx,GDFieldPos("DT_COD")]  
						A5_NOMPROD  := Posicione("SB1",1,xFilial("SB1")+aCols[nLpx,GDFieldPos("DT_COD")],"B1_DESC")  
						A5_CODPRF   := cProduto 
						SA5->(MsUnlock())
					EndIf
				Endif
			EndIf
		Next nLpx
		
		// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		// ³ Busca o tipo da NF 	  ³
		// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		SDS->(dbSetOrder(1))
		If SDS->(dbSeek(xFilial("SDS")+DS_DOC+DS_SERIE+DS_FORNEC+DS_LOJA))
			SDT->(DbSetOrder(1))
			// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			// ³ Deleta itens       	  ³
			// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If SDT->(DbSeek(xFilial("SDT")+SDS->(DS_CNPJ+DS_FORNEC+DS_LOJA+DS_DOC+DS_SERIE)))
				Do While SDT->(!EOF()) .And. SDT->(DT_FILIAL+DT_CNPJ+DT_FORNEC+DT_LOJA+DT_DOC+DT_SERIE) == xFilial("SDT")+SDS->(DS_CNPJ+DS_FORNEC+DS_LOJA+DS_DOC+DS_SERIE)
					RecLock("SDT")
					SDT->(DbDelete())
					SDT->(dbSkip())
				EndDo
			EndIf
			// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			// ³ Grava itens       	  ³
			// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
			For y := 1 to Len(aCols)
				RecLock("SDT", .T.)
				FieldPut(FieldPos("DT_FILIAL"), xFilial("SDT"))
				FieldPut(FieldPos("DT_CNPJ")  , SDS->DS_CNPJ  )
				FieldPut(FieldPos("DT_FORNEC"), SDS->DS_FORNEC)
				FieldPut(FieldPos("DT_LOJA")  , SDS->DS_LOJA  )
				FieldPut(FieldPos("DT_DOC")   , SDS->DS_DOC   )
				FieldPut(FieldPos("DT_SERIE") , SDS->DS_SERIE )
				For z := 1 to Len(aHeader)
					If AllTrim(aHeader[z, 2]) == "DT_COD" .And. nP == 0
						If Empty(aCols[y, z])
							cStatus := 'X'
							nP++
						EndIf
					EndIf
					FieldPut(FieldPos(aHeader[z, 2]), aCols[y, z])
				Next z
				MsUnlock()
			Next y
			If nP == 0
				If SDS->DS_FORMUL == 'S'
					cStatus := 'I'
				EndIf
			EndIf
			RecLock("SDS",.F.)
			SDS->DS_STATUS := cStatus
			SDS->(MsUnLock())
			
		EndIf
		
	Else
		For nX := 1 To Len(aCols)
			SDT->(dbGoTo(aCols[nX,Len(aHeader)])) 
			// Valida se foi alterardo o codigo do produto assim zerando o pedido 04/04/16 - Felipi Marques Validação se o foi alterado produto
			If SDT->DT_COD <> aCols[nX,GDFieldPos("DT_COD")]  
				RecLock("SDT",.F.)
					SDT->DT_COD    := aCols[nX,GDFieldPos("DT_COD")]  
					SDT->DT_PEDIDO := ""
					SDT->DT_ITEMPC := ""
				SDT->(MsUnLock())	

				// Se limpar o vinculo do produto, voltar o status para "X"
				// MH 17/01/2019
				If Empty(SDT->DT_COD)
					cStatus := "X"
				Endif	
				
			Else
				If SDS->DS_TIPO $ "N" .Or. lRemet	//-- Grava pedido e item
					RecLock("SDT",.F.)
					SDT->DT_PEDIDO := aCols[nX,GDFieldPos("DT_PEDIDO")]
					SDT->DT_ITEMPC := aCols[nX,GDFieldPos("DT_ITEMPC")]
					SDT->(MsUnLock())
				Else	//-- Grava nota, serie e item origem
					RecLock("SDT",.F.)
					SDT->DT_NFORI   := aCols[nX,GDFieldPos("DT_NFORI")]
					SDT->DT_SERIORI := aCols[nX,GDFieldPos("DT_SERIORI")]
					SDT->DT_ITEMORI := aCols[nX,GDFieldPos("DT_ITEMORI")]
					SDT->(MsUnLock())
				EndIf 
			EndIf
		Next nX
		
		// MH 17/01/2019
		If SDS->DS_STATUS <> cStatus
			DbSelectArea("SDS")
			Reclock("SDS",.F.)
			SDS->DS_STATUS := cStatus
		Endif
EndIf


ElseIf lRet .And. nOpc == 5		//-- Opcao por vinculo de multiplos pedidos
	// Verifica se o aCols esta igual ao aColsAnt para nao gravar registros novamente sem necessidade
	nPosPed  := aScan(aHeader,{|x| AllTrim(x[2]) == "DT_PEDIDO"})
	nPosItPC := aScan(aHeader,{|x| AllTrim(x[2]) == "DT_ITEMPC"})
	If Len(aColsAnt) == Len(aCols)
		lGrava := .F.
		For nX := 1 To Len(aColsAnt)
			If aColsAnt[nX][nPosPed]!=aCols[nX][nPosPed] .Or. aColsAnt[nX][nPosItPC]!=aCols[nX][nPosItPC]
				lGrava := .T.
				Exit
			EndIf
		Next nX
	EndIf
	If lGrava
		cStatus := "3"			// Novo registro sem pedido vinculado
		For nX := 1 To Len(aCols)
			If !Empty(aCols[nX][nPosPed])
				cStatus := "2"	// Novo registro com pedido vinculado
				Exit
			EndIf
		Next nX
		For nX := 1 To Len(aColsAnt)
			SDT->(dbGoTo(aColsAnt[nX,Len(aHeader)]))
			// Marca item original para que possa ser recuperado ao desvincular os pedidos
			RecLock("SDT",.F.)
			SDT->DT_ORIGIN := If(Empty(SDT->DT_ORIGIN),"1","2")
			SDT->(MsUnLock())
			// Deleta item
			RecLock("SDT",.F.)
			SDT->(dbDelete())
			SDT->(MsUnLock())
		Next nX
		//--Grava novos itens
		For nX := 1 To Len(aCols)
			RecLock("SDT",.T.)
			SDT->DT_FILIAL	:= xFilial("SDT")
			SDT->DT_FORNEC	:= SDS->DS_FORNEC
			SDT->DT_LOJA	:= SDS->DS_LOJA
			SDT->DT_DOC		:= SDS->DS_DOC
			SDT->DT_SERIE	:= SDS->DS_SERIE
			SDT->DT_CNPJ	:= SDS->DS_CNPJ
			For nY := 1 To Len(aHeader)
				SDT->&(aHeader[nY][2]):= aCols[nX][nY]
			Next nY
			SDT->DT_ORIGIN	:= cStatus
			MsUnlock()
		Next nX
	EndIf
EndIf

cFilAnt := cFilBkp
aRotina[2,4] := 4
Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MarkAll  ºAutor ³Felipi Marques       º Data ³  06/25/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Funcao para marcar todos os registros da MarkBrowse.       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/    
User Function MarkAll()
// Diversos ajustes para funcionar MarkAll - MH
Local nRecno := SDS->(Recno())
Local nPosReg := 0

SDS->(dbGoTop())
//MsSeek(cFilAnt)
// (14/05/2020 - Luiz - Permitir marcar/desmarcar independente da Filial logada)
// While !SDS->(EOF()) .AND. SDS->DS_FILIAL = cFilAnt  
While !SDS->(EOF())
	nPosReg := aScan(aRegMark,{|x| x == SDS->(Recno())})
	
	If SDS->DS_STATUS <> 'P'
		Reclock("SDS",.F.)
		If SDS->DS_OK == cMarca
			
			SDS->DS_OK := ""
			
			If nPosReg > 0
				aDel(aRegMark,nPosReg)
				aSize(aRegMark,(Len(aRegMark)-1))
			EndIf
		
		Else
			SDS->DS_OK := cMarca
			If nPosReg == 0
				aAdd(aRegMark,SDS->(Recno()))
			EndIf
		Endif

		SDS->(MsUnlock())
	EndIf
	SDS->(dbSkip())
EndDo

SDS->(dbGoto(nRecno))   
MarkBRefresh() 
Return
/* 
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ 
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±± 
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±± 
±±ºPrograma  ³ ComXMark	ºAutor ³Felipi Marques       º Data ³  06/25/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Funcao para armazenar os numeros dos registros marcados na º±±
±±º            MarkBrowse para que não seja necessário percorrer toda a   º±±
±±º            tabela SDS para gerar os documentos.                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ComXMark()

Local aArea   := GetArea()
Local nRecno  := Recno()
Local nPosReg := aScan(aRegMark,{|x| x == nRecno})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Codigo para tratamento da marcacao de registros na MarkBrowse.  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RecLock("SDS",.F.)
SDS->DS_OK := Iif( IsMark("DS_OK",cMarca) , Space(Len(SDS->DS_OK)) , cMarca )
MsUnLock()
SDS->(dbCommit())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Armazena ou exclui os registros de aRegMark conforme a marcacao.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If IsMark("DS_OK",cMarca)
	If nPosReg == 0
		aAdd(aRegMark,SDS->(Recno()))
	EndIf
Else
	If nPosReg > 0
		aDel(aRegMark,nPosReg)
		aSize(aRegMark,(Len(aRegMark)-1))
	EndIf
EndIf

RestArea(aArea)
MarkBRefresh()

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ GerarDocs ºAutor ³Felipi Marques       º Data ³  06/25/15  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Processa a geracao dos documentos fiscais.			      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                 			  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GerarDocs()
Local nRegs   := 0
Local nRecno  := SDS->(Recno())
Local nQtdNF	:= Len(aRegMark)
Local lCAuto		:= .F.

If nQtdNF > 0 .And. MsgYesNo("Confirma a geração de documento para os itens selecionados?","Atenção") 
	
	Processa({|| ProcDocs(nQtdNF,.F.,lCAuto),"Monitor TOTVS" +" - " +"Geração de Documentos"})
		
	SDS->(dbGoTo(nRecno))
	aRegMark := {}
EndIf
	

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ProcDocs ºAutor ³Felipi Marques       º Data ³  06/25/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Processa a geracao dos documentos a partir de SDS/SDT      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ nRegs: total de registros a serem processados.			  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GerarDocs												  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function ProcDocs(nRegs,lNFeAut,lCAuto,lJob)

Local aCabec 	:= {}
Local aItens 	:= {}
Local aErro  	:= {}
Local cErro  	:= ""
Local nX	 	:= 0
Local nY		:= 0
Local nCount 	:= 0 
Local cFilBkp	:= cFilAnt
Local lRet		:= .F.  
Local aSavePar 	:= {MV_PAR01,MV_PAR02,MV_PAR03,MV_PAR04,MV_PAR05,MV_PAR06,MV_PAR07,MV_PAR08,MV_PAR09,MV_PAR10,MV_PAR11,MV_PAR12,MV_PAR13,MV_PAR14,MV_PAR15} //MH

Local aParam103 := {}  // (19/05/2020 - Luiz - Parametros auxiliares para Mata103)

Default lNFeAut := .F.
Default lCAuto	:= .F.	// Esta variavel determina se sera gerada Pre Nota (.F.) ou documento classificado (.T.)
Default lJob    := .F.

Private lMSErroAuto	   := .F.
Private	lAutoErrNoFile := .T.

Private	CNFISCAL 
Private	CSERIE   
Private	CA100FOR 
Private	CLOJA	 
Private CTIPO

aAdd(aParam103, {"MV_PAR01", 2}) //-- Mostra Lanc. Contabil? 1 = Sim, 2 = Não
aAdd(aParam103, {"MV_PAR06", 1}) //-- Contabilizacao Online? 1 = Sim, 2 = Não

ProcRegua(nRegs)
For nY := 1 To nRegs
	If !lNFeAut
		SDS->(dbGoTo(aRegMark[nY]))
	EndIf
	If lNFeAut .And. (!SDS->DS_TIPO $ "DC")
		aCabec := MontaSF1()
		aItens := MontaSD1()
		If (lRet := (SDS->DS_STATUS <> "E"))
			MSExecAuto({|x,y,z| MATA103(x,y,z)},aCabec,aItens,3)
		EndIf
	ElseIf (SDS->DS_OK == cMarca)
		lRet := .T.
		nCount++
		IncProc("Processando documento" +AllTrim(SDS->DS_DOC) +"/" +AllTrim(SDS->DS_SERIE) +"(" +StrZero(nCount,4) +"de" +StrZero(nRegs,4) +")")
		
		
		//-- Se filial diferente, troca
		If PadR(cFilAnt,Len(AllTrim(SDS->DS_FILIAL))) # AllTrim(SDS->DS_FILIAL)
			Do Case
				Case FWModeAccess("SB2",3) == "E"
					cFilAnt := SDS->DS_FILIAL
				Case FWModeAccess("SB2",2) == "E" .Or. FWModeAccess("SB2",1) == "E"
					SM0->(dbSetOrder(1))
					SM0->(dbSeek(cEmpAnt+SDS->DS_FILIAL))
					cFilAnt := SM0->M0_CODFIL
			EndCase
		EndIf
		If SDS->DS_STATUS == "P"
			Aviso("Atenção","Esta ação não pode ser executada para documentos já gerados. Documento: " +AllTrim(SDS->DS_DOC) +"/" +AllTrim(SDS->DS_SERIE),{"OK"})
			lRet := .F. 
			Loop
		ElseIf SDS->DS_STATUS == "X"
			lRet := .F. 
			Loop
		Else
			//-- Esvazia log
			RecLock("SDS",.F.)
			SDS->DS_DOCLOG := CriaVar("DS_DOCLOG",.F.)
			SDS->(MsUnLock())
			
			aCabec := MontaSF1()
			aItens := MontaSD1()
			If Empty(SDS->DS_DOCLOG) //-- Se nao houve erro na montagem dos dados, continua
				lMSErroAuto := .F.
				lMsHelpAuto := .F.
				MSExecAuto({|x,y,z| MATA140(x,y,z)},aCabec,aItens,3)
				if !lMSErroAuto        // (19/05/2020 - Luiz - Chamada da Classificação)
				   //MATA103(aCabec,aItens,4,,,,aParam103)
				   MSExecAuto({|x,y,z,k| MATA103(x,y,z,,,,k)},aCabec,aItens,4,aParam103)
				   //MSExecAuto({|x,y,z,k,a,b| MATA103(x,y,z,,,,k,a,,,b)},aCab,aItens,nOpc,aParamAux,aItensRat,aCodRet)
				endif
			else
				lRet := .F. 
				Loop
			EndIf
		EndIf
		
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³FORCA POSICIONAMENTO NA TABELA SF1³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nPosDoc  := aScan(aCabec,{|x| AllTrim(x[1]) == "F1_DOC"})
		nPosSer  := aScan(aCabec,{|x| AllTrim(x[1]) == "F1_SERIE"})
		nPosFor  := aScan(aCabec,{|x| AllTrim(x[1]) == "F1_FORNECE"})
		nPosLoj  := aScan(aCabec,{|x| AllTrim(x[1]) == "F1_LOJA"})
		nPosPrd  := aScan(aItens[1],{|x| AllTrim(x[1]) == "D1_COD"})
		
		dbSelectArea("SF1")
		dbSetOrder(1)
		MsSeek(xFilial("SF1")+aCabec[nPosDoc,2]+aCabec[nPosSer,2]+aCabec[nPosFor,2]+aCabec[nPosLoj,2])
		//Variaveis Private
		CNFISCAL := SF1->F1_DOC
		CSERIE   := SF1->F1_SERIE
		CA100FOR := SF1->F1_FORNECE
		CLOJA	 := SF1->F1_LOJA
		CTIPO    := SF1->F1_TIPO
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³FORCA POSICIONAMENTO NA TABELA SD1³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SD1")
		dbSetOrder(1)
		MsSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)
		
		
		If lRet
			//-- Grava resultado do processamento na SDS
			RecLock("SDS",.F.)
			Replace SDS->DS_OK	With ''
			If !lMsErroAuto
				Replace SDS->DS_USERPRE	With cUserName
				Replace SDS->DS_DATAPRE	With dDataBase
				Replace SDS->DS_HORAPRE	With Time()
				Replace SDS->DS_STATUS	With 'P'
				Replace SDS->DS_DOCLOG	With ''
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³PONTO DE ENTRADA PARA VALIDAÇÃO APOS GERAÇÃO DA NOTA.³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				IF ExistBlock("XML20FIM")
					lRet := ExecBlock("XML20FIM",.F.,.F.)
				Endif
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³CASO O RETORNO DO PONTO DE ENTRADA FOR FALSO ³
				//³DELETA A NOTA FISCAL                         ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If !lRet                       
				    /*
					If SDS->DS_TIPO $ "OCT"
						MSExecAuto({|x,y,z| MATA103(x,y,z)},aCabec,aItens,5)
					Else
						MSExecAuto({|x,y,z| MATA140(x,y,z)},aCabec,aItens,5)
					EndIf
					*/
				EndIf
			Else
				aErro := GetAutoGRLog()
				cErro := ""
				For nX := 1 To Len(aErro)
					cErro += aErro[nX] +CRLF
				Next nY
				Replace SDS->DS_DOCLOG With cErro
				Replace SDS->DS_STATUS With 'E'
			EndIf
			SDS->(MsUnLock())
		EndIf
		If lNFeAut
			Exit
		EndIf
		cFilAnt := cFilBkp
	EndIf
Next nY

// Restaurar parametros perdidos depois da MsExecAuto
For nY := 1 To Len(aSavePar)
	cAux := "MV_PAR"+StrZero(nY,2,0)
	&(cAux) := aSavePar[nY]
Next	

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MontaSF1 ºAutor ³Felipi Marques       º Data ³  06/25/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Monta cabecalho para rotina automatica com os dados do SDS º±±
±±º          ³ posicionado.                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ aRet: array para uso na rotina automatica.				  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ProcDocs                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MontaSF1()
Local aRet	 	 := {}
Local cTipoNF	 := ""
Local cCondPagto := ""
Local aAreaSDS	 := SDS->(GetArea())
Local lRemet	 := .F.
Local cFilSDT := xFilial("SDT")
Local cFilSF1	:= xFilial("SF1")

Do Case
	Case SDS->DS_TIPO == "T"
		cTipoNF := "C"
	Case SDS->DS_TIPO == "O"
		cTipoNF := "N"
	Otherwise
		cTipoNF := SDS->DS_TIPO
EndCase

// Quando a empresa for remetente da mercadoria (FOB) nao deve passar F1_TPFRETE na rotina automatica, caso contrario vai cair na validacao A103FRETE que nao permite vincular pedido de compra a documentos com TPFRETE preenchido
If SDS->DS_TIPO == "T" .And. SDS->DS_TPFRETE == "F"
	lRemet := .T.
EndIf

aAdd(aRet,{"F1_FILIAL",  SDS->DS_FILIAL,	Nil})
If AllTrim(SDS->DS_ESPECI) == "CTE"
	SDT->(dbSetOrder(2))
	If lRemet .And. SDT->(dbSeek(cFilSDT+SDS->(DS_FORNEC+DS_LOJA+DS_DOC+DS_SERIE))) .And.  AllTrim(SDT->DT_COD) $ AllTrim(SuperGetMV("MV_XMLPFCT",.F.,""))  
		aAdd(aRet,{"F1_TIPO","N",Nil})
	Else
		aAdd(aRet,{"F1_TIPO",cTipoNF,Nil})
	EndIf
Else
	aAdd(aRet,{"F1_TIPO",  cTipoNF,			Nil})
EndIf

aAdd(aRet,{"F1_FORMUL",  SDS->DS_FORMUL,	Nil})
aAdd(aRet,{"F1_DOC",     SDS->DS_DOC,		Nil})
aAdd(aRet,{"F1_SERIE",   SDS->DS_SERIE,		Nil})
aAdd(aRet,{"F1_EMISSAO", SDS->DS_EMISSA,	Nil})
aAdd(aRet,{"F1_FORNECE", SDS->DS_FORNEC,	Nil})
aAdd(aRet,{"F1_LOJA",    SDS->DS_LOJA,		Nil})
aAdd(aRet,{"F1_ESPECIE", SDS->DS_ESPECI,	Nil})
aAdd(aRet,{"F1_DTDIGIT", dDataBase,			Nil})
aAdd(aRet,{"F1_EST",     SDS->DS_EST,		Nil})
aAdd(aRet,{"F1_CHVNFE",  SDS->DS_CHAVENF,	Nil})
aAdd(aRet,{"F1_FRETE",   SDS->DS_FRETE,		Nil})
aAdd(aRet,{"F1_DESPESA", SDS->DS_DESPESA,	Nil})
aAdd(aRet,{"F1_DESCONT", SDS->DS_DESCONT,	Nil})
aAdd(aRet,{"F1_SEGURO",  SDS->DS_SEGURO,	Nil})
If !Empty(SDS->DS_TRANSP)
	aAdd(aRet,{"F1_TRANSP",SDS->DS_TRANSP,	Nil})
EndIf
aAdd(aRet,{"F1_PLACA",   SDS->DS_PLACA,		Nil})	
aAdd(aRet,{"F1_PLIQUI",  SDS->DS_PLIQUI	,	Nil})
aAdd(aRet,{"F1_PBRUTO",  SDS->DS_PBRUTO	,	Nil})
aAdd(aRet,{"F1_ESPECI1", SDS->DS_ESPECI1,	Nil})		
aAdd(aRet,{"F1_VOLUME1", SDS->DS_VOLUME1,	Nil})
aAdd(aRet,{"F1_ESPECI2", SDS->DS_ESPECI2,	Nil})
aAdd(aRet,{"F1_VOLUME2", SDS->DS_VOLUME2,	Nil})
aAdd(aRet,{"F1_ESPECI3", SDS->DS_ESPECI3,	Nil})
aAdd(aRet,{"F1_VOLUME3", SDS->DS_VOLUME3,	Nil})
aAdd(aRet,{"F1_ESPECI4", SDS->DS_ESPECI4,	Nil})
aAdd(aRet,{"F1_VOLUME4", SDS->DS_VOLUME4,	Nil})
If !lRemet	// Nao deve passar TPFRETE quando for CT-e e a empresa for remetente da mercadoria (FOB). Para os outros casos deve passar,
	aAdd(aRet,{"F1_TPFRETE", SDS->DS_TPFRETE,	Nil})
EndIf
	aAdd(aRet,{"F1_BASEICM", SDS->DS_BASEICM, Nil})
	aAdd(aRet,{"F1_VALICM", SDS->DS_VALICM, Nil })		
						
//-- Preenche condicao de pagamento para tipos de documento que geram NF
Do Case
	Case SDS->DS_TIPO == "C" //-- Complemento de preco
		//-- Obtem cond. pagto utilizada na nota origem
		SDT->(dbSetOrder(2))
		SDT->(dbSeek(cFilSDT+SDS->(DS_FORNEC+DS_LOJA+DS_DOC+DS_SERIE)))
		While Empty(cCondPagto) .And. SDT->(!EOF()) .And. SDT->(DT_FILIAL+DT_FORNEC+DT_LOJA+DT_DOC+DT_SERIE) == cFilSDT+SDS->(DS_FORNEC+DS_LOJA+DS_DOC+DS_SERIE)
			SF1->(dbSetOrder(1))
			If SF1->(dbSeek(cFilSF1+SDT->(DT_NFORI+DT_SERIORI+DT_FORNEC+DT_LOJA))) .And. !Empty(SF1->F1_COND)
				cCondPagto := SF1->F1_COND
			EndIf
			SDT->(dbSkip())
		End
		aAdd(aRet,{"F1_COND",cCondPagto,Nil})		
	Case SDS->DS_TIPO == "T" //-- Conhecimento de transporte
		//-- Obtem cond. pagto para utilizacao no CT-e (MV_XMLCPCT)
		CTe_RetTES(NIL,NIL,@cCondPagto)
		aAdd(aRet,{"F1_COND",cCondPagto,Nil})
EndCase

aAdd(aRet,{"F1_ORIGEM","COMMI020",Nil})

RestArea(aAreaSDS)
Return aRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MontaSD1 ºAutor ³Felipi Marques       º Data ³  06/25/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Monta itens para rotina automatica com os dados do SDS 	  º±±
±±º          ³ posicionado.                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ aRet: array para uso na rotina automatica.				  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ProcDocs                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MontaSD1()
Local aRet	    := {} 
Local cTES_CT	:= ""
Local aAreaSDS	:= SDS->(GetArea())
Local cFilSA5	:= xFilial("SA5")
Local cFilSD1	:= xFilial("SD1")
Local cFilSDT	:= xFilial("SDT")
Local lSPedAv   := .F.
SDT->(dbSetOrder(2))
SDT->(dbSeek(cFilSDT+SDS->(DS_FORNEC+DS_LOJA+DS_DOC+DS_SERIE)))
 While SDT->(!EOF()) .AND. SDT->(DT_FILIAL+DT_FORNEC+DT_LOJA+DT_DOC+DT_SERIE) == cFilSDT+SDS->(DS_FORNEC+DS_LOJA+DS_DOC+DS_SERIE)
	aAdd(aRet,{})
	
	aAdd(aTail(aRet),{"D1_ITEM",   SDT->DT_ITEM, 	 NIL})
	
	If !Empty(SDT->DT_COD)
		aAdd(aTail(aRet),{"D1_COD",    SDT->DT_COD,	 NIL})
	Else
		Aviso("ATENÇÃO","Documento sem vinculo com Produto vs Fornecedor. NF: "+SDT->DT_DOC+" Item: "+SDT->DT_ITEM, {"Ok"}, 2) 	
	EndIf
	
	If !Empty(SDT->DT_PEDIDO)
		aAdd(aTail(aRet),{"D1_PEDIDO", SDT->DT_PEDIDO,	 NIL})
		aAdd(aTail(aRet),{"D1_ITEMPC", SDT->DT_ITEMPC,	 NIL})
	Else                                                                                  
		lSPedAv := .T.
	EndIf

	If !Empty(SDT->DT_NFORI)
		aAdd(aTail(aRet),{"D1_NFORI",  SDT->DT_NFORI,	 NIL})
		aAdd(aTail(aRet),{"D1_SERIORI",SDT->DT_SERIORI, NIL})
		aAdd(aTail(aRet),{"D1_ITEMORI",SDT->DT_ITEMORI, NIL})
	EndIf
	If !SDS->DS_TIPO $ "C"
		If SDS->DS_TIPO == "T"
			If SDS->DS_TPFRETE == "F"				// Somente quando a empresa e remetente da mercadoria (FOB) deve gerar nota com quantidade 1, caso contrario nao e para enviar quantidade (ficara zerada)
				aAdd(aTail(aRet),{"D1_QUANT",  SDT->DT_QUANT, 	 NIL})
			EndIf
			dbSelectArea("SD1")
			dbSetOrder(2)
				If SD1->(dbSeek(cFilSD1+ SDT->DT_COD + SDT->DT_NFORI + SDT->DT_SERIORI))
				aAdd(aTail(aRet),{"D1_CONTA",SD1->D1_CONTA, NIL})
				aAdd(aTail(aRet),{"D1_CC",SD1->D1_CC, NIL})
			EndIf
		Else
			aAdd(aTail(aRet),{"D1_QUANT",  SDT->DT_QUANT, 	 NIL})
		EndIf
	EndIf
	aAdd(aTail(aRet),{"D1_VUNIT",  SDT->DT_VUNIT, 	 NIL})
	If SDS->DS_TIPO $ "CT"
		aAdd(aTail(aRet),{"D1_TOTAL",SDT->DT_VUNIT,NIL})
	Else
		aAdd(aTail(aRet),{"D1_TOTAL",Round(SDT->DT_VUNIT * SDT->DT_QUANT,TamSX3("D1_TOTAL")[2]),NIL})
	EndIf
	aAdd(aTail(aRet),{"D1_VALFRE",	SDT->DT_VALFRE,	 NIL})
	aAdd(aTail(aRet),{"D1_SEGURO",	SDT->DT_SEGURO,	 NIL})
	aAdd(aTail(aRet),{"D1_DESPESA",	SDT->DT_DESPESA, NIL})
	aAdd(aTail(aRet),{"D1_VALDESC",SDT->DT_VALDESC,  NIL})
	aAdd(aTail(aRet),{"D1_PICM"  , SDT->DT_PICM,     Nil })
   

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ,¿
	//³INFORMAÇOS DA NOTA DE IMPORTAÇÃO ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ,Ù
	//aAdd(aTail(aRet),{"D1_TPIMP" ,SDT->DT_TPIMP,	 NIL})
	aAdd(aTail(aRet),{"D1_NDI"   ,SDT->DT_NDI,   	 NIL})
	aAdd(aTail(aRet),{"D1_LOCDES",SDT->DT_LOCDES,	 NIL})
	aAdd(aTail(aRet),{"D1_UFDES" ,SDT->DT_UFDES,	 NIL})
	aAdd(aTail(aRet),{"D1_DTDI"  ,SDT->DT_DTDI,      NIL})
	aAdd(aTail(aRet),{"D1_DTDES" ,SDT->DT_DTDES,	 NIL})
	aAdd(aTail(aRet),{"D1_CODEXP",SDT->DT_CODEXP,	 NIL})
	aAdd(aTail(aRet),{"D1_NADIC" ,SDT->DT_NADIC,	 NIL})
	aAdd(aTail(aRet),{"D1_SQADIC",SDT->DT_SQADIC,	 NIL})
	aAdd(aTail(aRet),{"D1_DSPAD" ,SDT->DT_DSPAD,	 NIL})
	//ÚÄÄÄÄÄ¿
	//³PIS  ³
	//ÀÄÄÄÄÄÙ
	aAdd(aTail(aRet),{"D1_BASIMP6" ,SDT->DT_BSPIS,	 NIL})
	aAdd(aTail(aRet),{"D1_ALQIMP6" ,SDT->DT_ALPIS,	 NIL})
	aAdd(aTail(aRet),{"D1_VALIMP6" ,SDT->DT_VLPIS,	 NIL})
	//ÚÄÄÄÄÄÄÄ¿
	//³COFINS ³
	//ÀÄÄÄÄÄÄÄÙ
	aAdd(aTail(aRet),{"D1_BASIMP5" ,SDT->DT_BSCOF,	 NIL})
	aAdd(aTail(aRet),{"D1_ALQIMP5" ,SDT->DT_ALCOF,	 NIL})
	aAdd(aTail(aRet),{"D1_VALIMP5" ,SDT->DT_VLCOF,	 NIL})
	//ÚÄÄÄÄÄÄÄÄÄÄÄ¿
	//³IMPORTAÇÃO ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÙ
	nAliqII		:= Round(SDT->DT_VLRII/SDT->DT_BCIMP*100,2)
	
	aAdd(aTail(aRet),{"D1_BCIMP"     ,SDT->DT_BCIMP, NIL})
	aAdd(aTail(aRet),{"D1_ALIQII"    ,nAliqII      , NIL})
	aAdd(aTail(aRet),{"D1_II"        ,SDT->DT_VLRII, NIL})



	//-- Realiza validacoes pertinentes e preenche TES
	Do Case 
		Case SDS->DS_TIPO == "C" //-- Complemento de preco
			//-- Valida vinculo com documento origem
			If Empty(SDT->DT_NFORI)
				RecLock("SDS",.F.)
				Replace SDS->DS_DOCLOG With SDS->DS_DOCLOG +CRLF+CRLF +"Por tratar-se de um documento de complemento de preço, deverá ser realizado o vínculo com o documento origem para o item" +SDT->DT_ITEM +"deste documento." 
				Replace SDS->DS_STATUS With 'E'
				SDS->(MsUnlock())
			EndIf
			//-- Obtem TES
			SA5->(dbSetOrder(1))
			If SA5->(dbSeek(cFilSA5+SDT->(DT_FORNEC+DT_LOJA+DT_COD))) .And. Empty(SA5->A5_TESCP)
				RecLock("SDS",.F.)
				Replace SDS->DS_DOCLOG With SDS->DS_DOCLOG +CRLF+CRLF +;
											"Por tratar-se de um documento de complemento de preço, deverá ser identificado o tipo de entrada para o produto" +AllTrim(SDT->DT_COD) +"e fornecedor no campo E p/ Compl. (A5_TESCP) no cadastro de Produto X Fornecedor." +AllTrim(SDS->DS_FORNEC) +'/' +AllTrim(SDS->DS_LOJA) 
				Replace SDS->DS_STATUS With 'E'
				SDS->(MsUnlock())
			Else
				aAdd(aTail(aRet),{"D1_TES",SA5->A5_TESCP,NIL})
			EndIf
		Case SDS->DS_TIPO == "T" //-- Conhecimento de transporte
			//-- Obtem cond. pagto para utilizacao no CT-e (MV_XMLCPCT)
			//CTe_RetTES(NIL,@cTES_CT)
			/*
			// -- Valida config. do parametro MV_XMLCPCT
			If Empty(cTES_CT)
				RecLock("SDS",.F.)
				Replace SDS->DS_DOCLOG With SDS->DS_DOCLOG +CRLF+CRLF +"Por tratar-se de um documento de transporte, deverá ser identificado o tipo de entrada a ser utilizado através do parâmetro MV_XMLCPCT."
				Replace SDS->DS_STATUS With 'E'
				SDS->(MsUnlock())
				Exit
			Else
				aAdd(aTail(aRet),{"D1_TES",cTES_CT,NIL})
			EndIf
		*/
		Case SDS->DS_TIPO == "O"
			SA5->(dbSetOrder(1))
			If SA5->(dbSeek(cFilSA5+SDT->DT_FORNEC+SDT->DT_LOJA+SDT->DT_COD)) .And. Empty(SA5->A5_TESBP)
				RecLock("SDS",.F.)
				Replace SDS->DS_DOCLOG With "Por tratar-se de um documento de bonificação, deverá ser identificado o tipo de entrada para o produto" +AllTrim(SDT->DT_COD) +" e fornecedor" +AllTrim(SDS->DS_FORNEC) +'/' +AllTrim(SDS->DS_LOJA) +" o campo TE p/ Bonif. (A5_TESBP) no cadastro de Produto X Fornecedor." 
				Replace SDS->DS_STATUS With 'E'
				SDS->(MsUnlock())
			Else
				aAdd(aTail(aRet),{"D1_TES", SA5->A5_TESBP,  NIL})
			EndIf
		 Otherwise
		    cTesNFNorm := ""
			If Empty(SDT->DT_TES)
				SC7->(DbSetOrder(14))
				If !Empty(SDT->DT_PEDIDO) .And. !Empty(SDT->DT_ITEMPC)
					If SC7->(DbSeek(xFilial("SC7")+SDT->DT_PEDIDO+SDT->DT_ITEMPC)) .And. !Empty(SC7->C7_TES)
						cTesNFNorm := SC7->C7_TES
						aAdd(aTail(aRet),{"D1_TES",cTesNFNorm,  NIL})
					EndIf
				Else
					cTesNFNorm := MaTESInt(1,ColConDHJ(SDT->DT_CODCFOP),SDS->DS_FORNEC,SDS->DS_LOJA,"F",SDT->DT_COD)
					aAdd(aTail(aRet),{"D1_TES", cTesNFNorm  ,  NIL})
				EndIf
			Else
				cTesNFNorm := SDT->DT_TES
				aAdd(aTail(aRet),{"D1_TES",cTesNFNorm,  NIL})
			EndIf
			If Empty(cTesNFNorm)
				RecLock("SDS",.F.)
				Replace SDS->DS_DOCLOG With SDS->DS_DOCLOG +CRLF+"Item " +SDT->DT_ITEM +" - Campo TES vazio." 
				Replace SDS->DS_STATUS With 'E'
				SDS->(MsUnlock())
				Alert("Atenção: NF "+SDS->DS_SERIE+"/"+SDS->DS_DOC+" com erro de TES - verificar Ocorrência na visualização.")
			EndIf
	EndCase
	
	SDT->(dbSkip())	
EndDo                 

If lSPedAv		
	Aviso("ATENÇÃO","Documento sem vinculo com pedido de compras. NF: "+SDT->DT_DOC, {"Ok"}, 2) 
EndIf

RestArea(aAreaSDS)
Return aRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ COLNfeAutºAutor ³Felipi Marques       º Data ³  06/25/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Validacao das tabelas SE4/SF4 para geracao automatica 	  º±±
±±º          ³ dos documentos                                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ aCabec: Cabecalho documento de entrada		  			  º±±
±±º			 ³ cItens: Itens documento de entrada		  				  º±±
±±º			 ³ cCGCEmit: CNPJ do emitente		  				  		  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ lRet: (True/False) verifica se passou todas as validacoes  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function COLNfeAut(aCabec,aItens)
Local aAreaSB1 := SB1->(GetArea())
Local aAreaSF4 := SF4->(GetArea())
Local aAreaSE4 := SE4->(GetArea())
Local aAreaSA1 := SA1->(GetArea())
Local aAreaSA2 := SA2->(GetArea())
Local lRet     := .T.
Local nX       := 0
Local nPosFor  := aScan(aCabec,{|x| AllTrim(x[1]) == "F1_FORNECE"})
Local nPosLoj  := aScan(aCabec,{|x| AllTrim(x[1]) == "F1_LOJA"})
Local nPosTpNF := aScan(aCabec,{|x| AllTrim(x[1]) == "F1_TIPO"})
Local nPosCPg  := aScan(aCabec,{|x| AllTrim(x[1]) == "F1_COND"})
Local nPosFre  := aScan(aCabec,{|x| AllTrim(x[1]) == "F1_TPFRETE"})
Local nPosPrd  := aScan(aItens[1],{|x| AllTrim(x[1]) == "D1_COD"})
Local nPosPed  := aScan(aItens[1],{|x| AllTrim(x[1]) == "D1_PEDIDO"})
Local nPosItPC := aScan(aItens[1],{|x| AllTrim(x[1]) == "D1_ITEMPC"})
Local nPosTes  := aScan(aItens[1],{|x| AllTrim(x[1]) == "D1_TES"})
Local nPosQtde := aScan(aItens[1],{|x| AllTrim(x[1]) == "D1_QUANT"})
Local nPosPrec := aScan(aItens[1],{|x| AllTrim(x[1]) == "D1_VUNIT"})
Local cCodTes  := ""
Local cCondPg  := ""
Local clQuery  := ""
Local clArqSQL := "TMP"  
Local lGerDupl := .F.
Local cFilSA1	 := xFilial("SA1")
Local cFilSA2  := xFilial("SA2")
Local cFilSB1	 := xFilial("SB1") 
Local cFilSC7	 := xFilial("SC7")
Local cFilSE4	 := xFilial("SE4")
Local cFilSF4	 := xFilial("SF4")

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// | Verifica se o tipo NF esta contido no paramentro para geracao automatica |
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !(SDS->DS_TIPO $ SuperGetMV("MV_COMCOL2",.F.,.F.))
	lRet := .F.
ElseIf aCabec[nPosTpNF,2] == "N" .And. ExistBlock("COMCOL2")
	lRet := ExecBlock("COMCOL2",.F.,.F.,{aCabec,aItens})
	If ValType(lRet) <> "L"
		lRet := .F.
	EndIf
EndIf

If lRet
	SB1->(dbSetOrder(1))
	SF4->(dbSetOrder(1))
	For nX := 1 To Len(aItens)		
		SB1->(DbSeek(cFilSB1+aItens[nX][nPosPrd][2])) //Codigo do Produto
		cCodTes := ""
		cCodTes := SB1->B1_TE
		// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿ 	 
		// |  Ponto de entrada para obter o codigo da TES |	
		// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
		If ExistBlock("COMCOLF4")
			cCodTes := ExecBlock("COMCOLF4",.F.,.F.,{aCabec[nPosFor,2],aCabec[nPosLoj,2],aItens[nX][nPosPrd][2],cCodTes})
			If ValType(cCodTes) # "C" .Or. !SF4->(dbSeek(cFilSE4+cCodTes))
				cCodTes := SB1->B1_TE
			EndIf
		EndIf
		// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		// |  Caso nao encontre a TES cancelar a operacao |
		// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If Empty(cCodTes)
			lRet := .F.
			Exit		
		ElseIf nPosTes > 0
			aItens[nX][nPosTes][2] := cCodTes
		Else
			aAdd(aItens[nX],{"D1_TES",cCodTes, NIL})
		EndIf
	Next nX
EndIf
                              
// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// |  Ponto de entrada para obter a cond de pagto |
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lRet
	SF4->(dbSetOrder(1))
	For nX := 1 To Len(aItens)
		nPosTes  := aScan(aItens[1],{|x| AllTrim(x[1]) == "D1_TES"})
		If SF4->(dbSeek(cFilSF4+aItens[nX][nPosTes][2])) .And. SF4->F4_DUPLIC == "S"
			lGerDupl := .T.
			Exit
		EndIf
	Next nX
	If lGerDupl
		SE4->(dbSetOrder(1))
		IF aCabec[nPosTpNF,2] == "N"
			For nX := 1 To Len(aItens)
					// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿	 
					// |  MONTA QUERY   |	
				    // ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ         
					clQuery += " SELECT C7_NUM, C7_ITEM, C7_COND"
					clQuery += " FROM " + RetSqlName("SC7") + " SC7 "
					clQuery += " WHERE C7_FILIAL = '" + cFilSC7 + "' AND D_E_L_E_T_ <> '*' "
					clQuery += " AND C7_FORNECE = '" + aCabec[nPosFor,2] + "' AND C7_LOJA = '" + aCabec[nPosLoj,2] + "'"
					clQuery += " AND C7_PRODUTO = '" + aItens[nX][nPosPrd][2] + "'"
					clQuery += " AND C7_PRECO = " + STR(aItens[nX][nPosPrec][2])
					clQuery += " AND (C7_QUANT-C7_QUJE-C7_QTDACLA) >= "+ STR(aItens[nX][nPosQtde][2])
					clQuery += " ORDER BY C7_DATPRF"
					clQuery := ChangeQuery(clQuery)
					dbUseArea(.T., "TOPCONN", TCGenQry(,,clQuery),"TMP", .T., .T.)
					DbSelectArea(clArqSQL)
					TMP->(dbGoTop())
					If !TMP->(Eof())
						aSize(aItens[nX],Len(aItens[nX])+2)
						aIns(aItens[nX],3)
						aItens[nX][3] := {"D1_PEDIDO", TMP->C7_NUM, NIL}
						aIns(aItens[nX],4)
						aItens[nX][4] := {"D1_ITEMPC", TMP->C7_ITEM, NIL}
						aCabec[nPosFre,2] := ""
						cCondPg	:= TMP->C7_COND	
					EndIf
					clQuery := ""
					TMP->(dbCloseArea())
			Next nX
		EndIf
		If Empty(cCondPg)
			If aCabec[nPosTpNF,2] $ "B"
				SA1->(dbSetOrder(1))
				If SA1->(dbSeek(cFilSA1+aCabec[nPosFor,2]+aCabec[nPosLoj,2]))
					cCondPg	:= SA1->A1_COND
				EndIf
			Else
				SA2->(dbSetOrder(1))
				If SA2->(dbSeek(cFilSA2+aCabec[nPosFor,2]+aCabec[nPosLoj,2]))
					cCondPg	:= SA2->A2_COND
				EndIf
			EndIf		
		EndIf
		If ExistBlock("A140ICOND")
			cCondPg := ExecBlock("A140ICOND",.F.,.F.,{aCabec[1][nPosFor],aCabec[1][nPosLoj],cCondPg})
			If ValType(cCondPg) # "C" .Or. !SE4->(dbSeek(cFilSE4+cCondPg))
				lRet := .F.
			EndIf
		EndIf
		If lRet   
			If !Empty(cCondPg) .And. nPosCPg > 0
				aCabec[nX][nPosCPg][2] := cCondPg
			ElseIf !Empty(cCondPg)
				aAdd(aCabec,{"F1_COND",cCondPg, NIL})
			Else
				lRet := .F.
			EndIf
		EndIf
	EndIf
EndIf
RestArea(aAreaSB1)
RestArea(aAreaSF4)
RestArea(aAreaSE4)
RestArea(aAreaSA1)
RestArea(aAreaSA2)

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ Remessa  ºAutor ³Felipi Marques       º Data ³  06/25/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Realiza o envio de um XML.                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                 			  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Remessa()

Local cPathR
Local cFile
Local lStatus
local aFileStatus := {}
Local cMsg := ""

Private aErroXML := {}

cPathR := cGetFile("*.XML |*.XML",OemToAnsi("Selecione o Arquivo"),0,,.T.,49) //cGetFile("*.xml","XML File",1,"C:\",.T.,GETF_LOCALHARD,.T.,.T.)
          
cFile := cPathR

If Empty(cFile)
	Return(.T.)
EndIf
	
If !Empty(cPathR)
	While At("\",cFile) > 0
		cFile := Substr(cFile,At("\",cFile)+1)
	End

	If !":\" $ cPathR //-- Arquivo do servidor
		Copy File &(cPathR) TO &(DIRXML+DIRALER +cFile)
	Else //-- Arquivo do client
		CpyT2S(cPathR,DIRXML+DIRALER)
	EndIf

EndIf	
//-- Chama funcao de import
MsAguarde({|| lStatus:=U_ACOMR07(cFile,.F.)},"Aguarde","Importando dados do arquivo XML...",.F.)

// Renomear arquivo de Origem // MH 07/05/2019
If lStatus
	FRename(cPathR,cPathr+".PRO",,.T.)
Endif	

if len(aErroXML) > 0
   
   cMsg := "Importação de XML finalizada - Erro encontrado" //+chr(10)+chr(12)+chr(10)+chr(12)
//   cMsg := "O erro será exibido a seguir"
   MSGALERT(cMsg, "Erro na importação" )

   ImprimeErro(aErroXML)

   MostraErros(aErroXML)
   
//   cMsg := "Filial           : "+aErroXML[1][1]+chr(10)+chr(12)
//   cMsg += "CNPJ Fornecedor  : "+Transform(aErroXML[1][2],"@R 99.999.999/9999-99")+chr(10)+chr(12)
//   cMsg += "Nome Fornecedor  : "+aErroXML[1][3]+chr(10)+chr(12)
//   cMsg += "Serie/Numero NF  : "+aErroXML[1][4]+"/"+aErroXML[1][5]+chr(10)+chr(12)
//   cMsg += "Valor NF         : "+AllTrim(Transform(aErroXML[1][6], "@E 999,999,999.99" ))+chr(10)+chr(12)    
//   cMsg += "Codigo do Retorno: "+aErroXML[1][7]+chr(10)+chr(12)
//   cMsg += "Mensagem Erro 1  : "+aErroXML[1][8]+chr(10)+chr(12)
//   cMsg += "Mensagem Erro 2  : "+aErroXML[1][9]+chr(10)+chr(12)
//   MSGALERT( cMsg, "Erro Consulta Sefaz" )

endif 

Return(.T.)           


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³COMMI020  ºAutor  ³Microsiga           º Data ³  12/07/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

static Function SelNfe() 

cSelMun := BuscMun()

If     cSelMun == '01'
  NfSeSP()
ElseIf cSelMun == '02'
  NfSeRJ()
ElseIf cSelMun == '03'  
  NfSeMG()  
EndIf
                 
Return()  


Static Function BuscMun()

Local nTam			:= 0
Local aCat	      	:= {}
Local MvRet		  	:= Alltrim(ReadVar())
Local MvPar			:= ""
Local cTitulo		:= "CADASTROS"
Local MvParDef  	:= ""                     
Local cVolta		:= ""  
Local cF3           := ""  

	aAdd(aCat,"01-São Paulo - SP")	
	aAdd(aCat,"02-Rio de Janeiro - RJ")
	aAdd(aCat,"03-Belo Horizonte - MG")

     //----------------------------------------------------------------------
     // Executa f_Opcoes para Selecionar ou Mostrar os Registros Selecionados
	 //----------------------------------------------------------------------
     f_Opcoes(       @MvPar      ,;    //Variavel de Retorno
                     cTitulo     ,;    //Titulo da Coluna com as opcoes
                     @aCat       ,;    //Opcoes de Escolha (Array de Opcoes)
                     @MvParDef   ,;    //String de Opcoes para Retorno
                     NIL         ,;    //Nao Utilizado
                     NIL         ,;    //Nao Utilizado
                     .T.         ,;    //Se a Selecao sera de apenas 1 Elemento por vez
                     nTam        ,;    //Tamanho da Chave
                     Len(aCat)   ,;    //No maximo de elementos na variavel de retorno
                     .T.         ,;    //Inclui Botoes para Selecao de Multiplos Itens
                     .F.         ,;    //Se as opcoes serao montadas a partir de ComboBox de Campo ( X3_CBOX )
                     NIL         ,;    //Qual o Campo para a Montagem do aOpcoes
                     .F.         ,;    //Nao Permite a Ordenacao
                     .F.         ,;    //Nao Permite a Pesquisa    
                     .T.         ,;    //Forca o Retorno Como Array
                      cF3         ;    //Consulta F3    
                      )
	  
	// Tratamento para separar retorno com ;
 	&MvRet := ""  
	
		//Carregar array
	If Len(MvPar) <> 0
		cVolta := SubStr(MvPar[1],1,2)	
    EndIf 
	
Return(cVolta)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³COMMI020  ºAutor  ³Microsiga           º Data ³  10/08/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function NfSeSP()  

Local cPathR
Local cFile
Local lStatus
local aFileStatus := {}

cPathR := cGetFile("*.TXT |*.TXT",OemToAnsi("Selecione o Arquivo"),0,,.T.,49) 
          
cFile := cPathR
	
If !Empty(cPathR)
	
	While At("\",cFile) > 0
		cFile := Substr(cFile,At("\",cFile)+1)
	End

	If !":\" $ cPathR //-- Arquivo do servidor
		Copy File &(cPathR) TO &(DIRXML+DIRALER +cFile)
	Else //-- Arquivo do client
		CpyT2S(cPathR,DIRXML+DIRALER)
	EndIf

	//-- Chama funcao de import
	MsAguarde({|| lStatus := U_ACOMR08(cFile,.F.)},"Aguarde","Importando dados do arquivo TXT...",.F.)

	// Renomear arquivo de Origem // MH 13/05/2019
	If lStatus
		FRename(cPathR,cPathr+".PRO",,.T.)
	Endif	

EndIf	

Return(.T.)
 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³COMMI020  ºAutor  ³Microsiga           º Data ³  10/08/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function NfSeRJ()  

Local cPathR
Local cFile
Local lStatus
local aFileStatus := {}
Local cXMLOri     := ""
Local oFullXML    := NIL
Local cError      := ""
Local cWarning    := ""
Local lJob        := .F.
Local aProc       := {}
Local aErros      := {}
Local lProces  := .T.    

cPathR := cGetFile("*.XML |*.XML",OemToAnsi("Selecione o Arquivo"),0,,.T.,49) 
          
cFile := cPathR
	
If !Empty(cPathR)
	While At("\",cFile) > 0
		cFile := Substr(cFile,At("\",cFile)+1)
	End

	If !":\" $ cPathR //-- Arquivo do servidor
		Copy File &(cPathR) TO &(DIRXML+DIRALER +cFile)
	Else //-- Arquivo do client
		CpyT2S(cPathR,DIRXML+DIRALER)
	EndIf
EndIf	


nHandle := FOpen(DIRXML +DIRALER +cFile)
nLength := FSeek(nHandle,0,FS_END)
FSeek(nHandle,0)
If nHandle > 0
	FRead(nHandle, cXMLOri, nLength)
	FClose(nHandle)
	If !Empty(cXMLOri)
		If SubStr(cXMLOri,1,1) != "<"
			nPosPesq := At("<",cXMLOri)
			cXMLOri  := SubStr(cXMLOri,nPosPesq,Len(cXMLOri))		// Remove caracteres estranhos antes da abertura da tag inicial do arquivo
		EndIf
	EndIf
	cXMLEncod := EncodeUtf8(cXMLOri)
	// Verifica se o encode ocorreu com sucesso, pois alguns caracteres especiais provocam erro na funcao de encode, neste caso e feito o tratamento pela funcao A140IRemASC
	If Empty(cXMLEncod)
		cStrXML := cXMLOri
		cXMLOri := A140IRemASC(cStrXML)
		cXMLEncod := EncodeUtf8(cXMLOri)
	EndIf
	If Empty(cXMLEncod)
		cXMLEncod := cXMLOri
	EndIf
EndIf


// Remove caracteres estranhos antes da abertura da tag inicial do arquivo
If !Empty(cXMLOri)
	If SubStr(cXMLOri,1,1) != "<"
		nPosPesq := At("<",cXMLOri)
		cXMLOri  := SubStr(cXMLOri,nPosPesq,Len(cXMLOri))
	EndIf
	cXML := DecodeUTF8(cXMLOri)
	
	If Empty(cXML)
		cXML := cXMLOri
	EndIf
	//remove caracteres especiais não aceitos pelo encode
	cXML := A140IRemASC(cXML)
	
	cXML := EncodeUtf8(cXML)
	
	If Empty(cXML)
		cXML := cXMLOri
	EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄš?êµt-…ˆ¿
//³Nota de Servicos- NFS-e  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄšøšøšÙ
oFullXML := XmlParser(cXML,"_",@cError,@cWarning)

//-- Chama funcao de import
MsAguarde({|| U_XML_NFs(cFile,lJob,@aProc,@aErros,oFullXml)  },"Aguarde","Importando dados do arquivo XML...",.F.)

Return(lProces)       



/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³COMMI020  ºAutor  ³Microsiga           º Data ³  10/08/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function NfSeMG()  

Local cPathR
Local cFile
Local lStatus
local aFileStatus := {}
Local cXMLOri     := ""
Local oFullXML    := NIL
Local cError      := ""
Local cWarning    := ""
Local lJob        := .F.
Local aProc       := {}
Local aErros      := {}
Local lProces  := .T.    

cPathR := cGetFile("*.XML |*.XML",OemToAnsi("Selecione o Arquivo"),0,,.T.,49) 
          
cFile := cPathR
	
If !Empty(cPathR)
	While At("\",cFile) > 0
		cFile := Substr(cFile,At("\",cFile)+1)
	End

	If !":\" $ cPathR //-- Arquivo do servidor
		Copy File &(cPathR) TO &(DIRXML+DIRALER +cFile)
	Else //-- Arquivo do client
		CpyT2S(cPathR,DIRXML+DIRALER)
	EndIf
EndIf	


nHandle := FOpen(DIRXML +DIRALER +cFile)
nLength := FSeek(nHandle,0,FS_END)
FSeek(nHandle,0)
If nHandle > 0
	FRead(nHandle, cXMLOri, nLength)
	FClose(nHandle)
	If !Empty(cXMLOri)
		If SubStr(cXMLOri,1,1) != "<"
			nPosPesq := At("<",cXMLOri)
			cXMLOri  := SubStr(cXMLOri,nPosPesq,Len(cXMLOri))		// Remove caracteres estranhos antes da abertura da tag inicial do arquivo
		EndIf
	EndIf
	cXMLEncod := EncodeUtf8(cXMLOri)
	// Verifica se o encode ocorreu com sucesso, pois alguns caracteres especiais provocam erro na funcao de encode, neste caso e feito o tratamento pela funcao A140IRemASC
	If Empty(cXMLEncod)
		cStrXML := cXMLOri
		cXMLOri := A140IRemASC(cStrXML)
		cXMLEncod := EncodeUtf8(cXMLOri)
	EndIf
	If Empty(cXMLEncod)
		cXMLEncod := cXMLOri
	EndIf
EndIf


// Remove caracteres estranhos antes da abertura da tag inicial do arquivo
If !Empty(cXMLOri)
	If SubStr(cXMLOri,1,1) != "<"
		nPosPesq := At("<",cXMLOri)
		cXMLOri  := SubStr(cXMLOri,nPosPesq,Len(cXMLOri))
	EndIf
	cXML := DecodeUTF8(cXMLOri)
	
	If Empty(cXML)
		cXML := cXMLOri
	EndIf
	//remove caracteres especiais não aceitos pelo encode
	cXML := A140IRemASC(cXML)
	
	cXML := EncodeUtf8(cXML)
	
	If Empty(cXML)
		cXML := cXMLOri
	EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄš?êµt-…ˆ¿
//³Nota de Servicos- NFS-e  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄšøšøšÙ
oFullXML := XmlParser(cXML,"_",@cError,@cWarning)

//-- Chama funcao de import
MsAguarde({|| U_XML_NFs(cFile,lJob,@aProc,@aErros,oFullXml)  },"Aguarde","Importando dados do arquivo XML...",.F.)

Return(lProces)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ Remessa  ºAutor ³Felipi Marques       º Data ³  06/25/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Realiza o envio de um XML .                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                              			  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Lote()

Local cPathR
Local cFile
Local lStatus
local aFileStatus := {}

Private aErroXML := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
//³localiza o diretorio                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[Ù
cPathR := cGetFile("*.XML |*.XML",OemToAnsi("Selecione o Arquivo"),1,"C:\",.F.,GETF_LOCALHARD + GETF_NETWORKDRIVE + GETF_RETDIRECTORY,.T.,.T.) 

aArquivos:=Directory(cPathr+"*.xml")

If !Empty(cPathR)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
	//³processa todos os arquivos do diretorio    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[Ù
	For n:=1 to len(aArquivos)
		
		cFile:=cPathr+aArquivos[n][1]
		
		While At("\",cFile) > 0
			cFile := Substr(cFile,At("\",cFile)+1)
		End
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
		//³Arquivo do servidor                        ³
   		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[Ù
		If !":\" $ cPathR 
			Copy File &(cPathR+cFile) TO &(DIRXML+DIRALER +cFile)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
		//³Arquivo do client                          ³
   		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[Ù		
		Else 
			CpyT2S(cPathR+cFile,DIRXML+DIRALER)
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
		//³Chama funcao de importação de XML          ³
   		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[Ù		
		MsAguarde({|| lStatus:=U_ACOMR07(cFile,.F.)},"Aguarde","Importando dados do arquivo XML...",.F.)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
		//³guarda o status de cada arquivo processado ³
   		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[Ù	
		aAdd(aFileStatus,{aArquivos[n][1] , lStatus })
		
		// Renomear arquivo de Origem // MH 07/05/2019
		If lStatus
			FRename(cPathR+cFile,cPathr+cFile+".PRO",,.T.)
		Endif	
		
	next

if len(aErroXML) > 0

   cMsg := "Importação de XML finalizada - Erro(s) encontrado(s)" //+chr(10)+chr(12)+chr(10)+chr(12)
//   cMsg := "O erro será exibido a seguir"
   MSGALERT(cMsg, "Erro na importação" )
   
   ImprimeErro(aErroXML)

   MostraErros(aErroXML)

//   for n := 1 to len(aErroXML)
//       cMsg := "Filial           : "+aErroXML[n][1]+chr(10)+chr(12)
//       cMsg += "CNPJ Fornecedor  : "+Transform(aErroXML[n][2],"@R 99.999.999/9999-99")+chr(10)+chr(12)
//       cMsg += "Nome Fornecedor  : "+aErroXML[n][3]+chr(10)+chr(12)
//       cMsg += "Serie/Numero NF  : "+aErroXML[n][4]+"/"+aErroXML[n][5]+chr(10)+chr(12)
//       cMsg += "Valor NF         : "+AllTrim(Transform(aErroXML[n][6], "@E 999,999,999.99" ))+chr(10)+chr(12)    
//       cMsg += "Codigo do Retorno: "+aErroXML[n][7]+chr(10)+chr(12)
//       cMsg += "Mensagem Erro 1  : "+aErroXML[n][8]+chr(10)+chr(12)
//       cMsg += "Mensagem Erro 2  : "+aErroXML[n][9]+chr(10)+chr(12)
//       MSGALERT( cMsg, "Erro Consulta Sefaz - "+AllTrim(Str(n)))
//   next
   
endif 

EndIf

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ReprocessaºAutor ³Felipi Marques       º Data ³  06/25/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Abre interface para o reprocessamento de arquivos XML com  º±±
±±º			 ³ erros ou excluidos.  									  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                              			  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Reprocessa()

Local aFiles    := {}
Local nX	    := 0
Local oFullXML  := NIL
Local cError    := ""
Local cWarning  := ""
Local aArquivo	:= {}
Local alSize    := MsAdvSize(.F.)
Local lProc		:= .F.
Local aHeadCols := {" ","Arquivo","Documento","Serie","Razão Social","Cnpj","Chave Nfe"}
Local oBrowse   := {}
Local oOK := LoadBitmap(GetResources(),'LBOK')
Local oNO := LoadBitmap(GetResources(),'LBNO')
Local cXMLOri	:= ""
Local cXMLEncod := ""
Local nHandle	:= 0
Local nLength	:= 0
Local cStrXML	:= ""
Local nPosPesq	:= 0
Local _lAtuStatus := .F.
Local aVPed		:= {} //MH
Local nTotItem	:= 0  //MH
Local nTotOk	:= 0  //MH

Private opDlgRepr   := NIL

_cQuery := " SELECT DS_FILIAL ,                                                                         "
_cQuery += "        DS_ARQUIVO,                                                                         "
_cQuery += "        DS_DOC ,                                                                            "
_cQuery += "        DS_SERIE,                                                                           "
_cQuery += "        DS_CNPJ ,                                                                           "
_cQuery += "        DS_STATUS,                                                                          "
_cQuery += "        DS_CHAVENF,                                                                         "
_cQuery += "        DS_TIPO                                                                             "
_cQuery += " FROM   "+RetSqlName("SDS")+"                                                               "
_cQuery += " WHERE  DS_STATUS = 'X'                                                                     "
_cQuery += " AND    D_E_L_E_T_ <> '*'                                                                   "
_cQuery += " AND    DS_FILIAL = '"+xFilial("SDS")+"'                                                    "
_cQuery += " AND    DS_DOC >= '" +mv_par01 +"'             AND  DS_DOC <= '" +mv_par02 +"'              "
_cQuery += " AND    DS_SERIE >= '" +mv_par03 +"'           AND  DS_SERIE <= '" +mv_par04 +"'            "
_cQuery += " AND    DS_FORNEC >= '" +mv_par05 +"'          AND  DS_FORNEC <= '" +mv_par06 +"'           "
_cQuery += " AND    DS_EMISSA >= '"  +DToS(mv_par07) +"'   AND  DS_EMISSA <= '"  +DToS(mv_par08) +"'    "
_cQuery += " AND    DS_DATAIMP >= '"  +DToS(mv_par09) +"'  AND  DS_DATAIMP <= '"  +DToS(mv_par10) +"'   "



	
If Select("QRY") > 0
	QRY->(dbCloseArea())
EndIf
TcQuery _cQuery new Alias "QRY"
dbSelectArea("QRY")
QRY->(dbGoTop())
While QRY->(!Eof())
	_cTabEmit := If(QRY->DS_TIPO == "N","SA2","SA1")
	(_cTabEmit)->(dbSetOrder(3))
	(_cTabEmit)->(dbSeek(xFilial(_cTabEmit)+QRY->DS_CNPJ))
	_cNome := (_cTabEmit)->&(Substr(_cTabEmit,2,2)+"_NOME")
	
	aAdd(aArquivo,{})
	aAdd(aArquivo[Len(aArquivo)],.F.)               //Nome do arquivo
	aAdd(aArquivo[Len(aArquivo)], QRY->DS_ARQUIVO ) //Nome do arquivo
	Aadd(aArquivo[Len(aArquivo)], QRY->DS_DOC     ) //Numero do Doc.
	Aadd(aArquivo[Len(aArquivo)], QRY->DS_SERIE   ) //Serie Doc.
	Aadd(aArquivo[Len(aArquivo)], _cNome          ) //Razao Social do fornecedir
	Aadd(aArquivo[Len(aArquivo)], QRY->DS_CNPJ    ) //CNPJ
	Aadd(aArquivo[Len(aArquivo)], QRY->DS_CHAVENF ) //CNPJ
	QRY->(dbSkip())
EndDo
QRY->(dbCloseArea())

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// |  CAMPOS PARA TAB TEMP. |
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

DEFINE MSDIALOG opDlgRepr TITLE "Reprocessar arquivos (NF-e)" From alSize[1],alSize[2] to alSize[1]+450,alSize[2]+797 PIXEL 

aItems  := {'DOCUMENTOS COM ERROS','DOCUMENTOS EXCLUÍDOS'} 
cCombo  := aItems[1]
oBrowse := TCBrowse():New(01,01,400,205,,aHeadCols,,opDlgRepr,,,,,{||},,,,,,,.F.,,.T.,,.F.,,.T.,.T.)
oBrowse:SetArray(aArquivo)

If Len(aArquivo) > 0
	oBrowse:bLine := { || {If(aArquivo[oBrowse:nAT,1],oOK,oNO),aArquivo[oBrowse:nAt,02],aArquivo[oBrowse:nAt,03],aArquivo[oBrowse:nAt,04],aArquivo[oBrowse:nAt,05],aArquivo[oBrowse:nAt,06],aArquivo[oBrowse:nAt,07]}}
Else
	Aviso("Atencao","Não existem arquivos com erros para serem reprocessados.",{"OK"}) 
EndIf
// Marca a coluna no duplo click do mouse
oBrowse:bLDblClick := {|| aArquivo[oBrowse:nAt][1] := !aArquivo[oBrowse:nAt][1], oBrowse:DrawSelect()}
oBrowse:Refresh()
oTButMarDe := TButton():New( alSize[1]+210, alSize[2]+5, "Marca/Desmarca",opDlgRepr,{|| u_x140IMarc(@aArquivo,@oBrowse)},50,11,,,.F.,.T.,.F.,,.F.,,,.F.)
oTButPesqu := TButton():New( alSize[1]+210, alSize[2]+60, "Pesquisar",opDlgRepr,{|| u_x140IPesq(@aArquivo,@oBrowse)},50,11,,,.F.,.T.,.F.,,.F.,,,.F.) 
DEFINE SBUTTON FROM alSize[1]+210,alSize[2]+330 TYPE 1 ACTION (eVal( {|| lProc := .T., opDlgRepr:End()})) ENABLE Of opDlgRepr
DEFINE SBUTTON FROM alSize[1]+210,alSize[2]+364 TYPE 2 ACTION opDlgRepr:End() ENABLE Of opDlgRepr

ACTIVATE MSDIALOG opDlgRepr CENTERED
  //AQUI
If Len(aArquivo) > 0
	If lProc
		For nX := 1 To Len(aArquivo)
			If aArquivo[nX,1]
				SDS->(DbSetOrder(2))
				If SDS->(DbSeek(xFilial("SDS")+aArquivo[nX,7]))
					If SDS->DS_STATUS = 'X'
						
						_cQuery := " 	SELECT *                                       "
						_cQuery += " 	FROM   "+RetSqlName("SDT")+"                   "
						_cQuery += " 	WHERE  D_E_L_E_T_ = ' '                        "
						_cQuery += " 	AND    DT_FILIAL = '"+SDS->DS_FILIAL+"'        "
						_cQuery += " 	AND    DT_DOC = '"+SDS->DS_DOC+"'              "
						_cQuery += " 	AND    DT_SERIE = '"+SDS->DS_SERIE+"'          "
						_cQuery += " 	AND    DT_FORNEC = '"+SDS->DS_FORNEC+"'        "
						_cQuery += " 	AND    DT_LOJA = '"+SDS->DS_LOJA+"'            "
						_cQuery += "    AND D_E_L_E_T_ = ' ' " //MH
						If Select("QRY1") > 0
							QRY1->(dbCloseArea())
						EndIf
						TcQuery _cQuery new Alias "QRY1"
						dbSelectArea("QRY1")
						QRY1->(dbGoTop())
						
						nTotItem 	:= 0 //MH
						nTotOk		:= 0 //MH
						nPrdVinc 	:= 0 //MH 17/01/2019
						nTotVinc	:= 0 //MH 17/01/2019 
						
						While QRY1->(!Eof())
							nTotItem++ //MH
							nTotVinc++ //MH 17/01/2019
							
							_aProdFor := {}
							cTabEmit := If(SDS->DS_TIPO == "N","SA2","SA1")
							(cTabEmit)->(dbSetOrder(1))
							(cTabEmit)->(dbSeek(xFilial(cTabEmit)+SDS->DS_FORNEC+SDS->DS_LOJA ))
							cCodigo := (cTabEmit)->&(Substr(cTabEmit,2,2)+"_COD")
							cLoja   := (cTabEmit)->&(Substr(cTabEmit,2,2)+"_LOJA")
							
							cCampo1 := If(SDS->DS_TIPO # "N","A7_PRODUTO","A5_PRODUTO")
							cCampo2 := If(SDS->DS_TIPO # "N","A7_FILIAL","A5_FILIAL")
							cCampo3 := If(SDS->DS_TIPO # "N","A7_CLIENTE","A5_FORNECE")
							cCampo4 := If(SDS->DS_TIPO # "N","A7_LOJA","A5_LOJA")
							cCampo5 := If(SDS->DS_TIPO # "N","A7_CODCLI","A5_CODPRF")
							
							cProduto := AllTrim(QRY1->DT_PRODFOR)
							 
							cQuery := "SELECT " +cCampo1 +" FROM " +RetSqlName(If(SDS->DS_TIPO # "N","SA7","SA5"))
							cQuery += " WHERE D_E_L_E_T_ <> '*' AND "
							cQuery += cCampo2 +" = '" +xFilial(If(SDS->DS_TIPO # "N","SA7","SA5")) +"' AND "
							cQuery += cCampo3 +" = '" +cCodigo +"' AND "
							cQuery += cCampo4 +" = '" +cLoja +"' AND "
							cQuery += cCampo5 +" = '" +cProduto +"'"
							
							If Select("TRB") > 0
								TRB->(dbCloseArea())
							EndIf
							TcQuery cQuery new Alias "TRB"
							TRB->(dbGotop())
							
							If !TRB->(EOF()) 
								SDT->(DbSetOrder(3))
								If SDT->(dbSeek(QRY1->DT_FILIAL + QRY1->DT_FORNEC + QRY1->DT_LOJA + QRY1->DT_DOC + QRY1->DT_SERIE + QRY1->DT_COD  ))
									RecLock("SDT",.F.)
									SDT->DT_COD    := TRB->(&cCampo1)
									_lAtuStatus    := .T.
									nPrdVinc++ //MH 17/01/2019
									SDT->(MsUnLock())
								EndIf	
							EndIf
							
							// Verifica existencia do Pedido de Compra //MH
							If Empty(QRY1->DT_PEDIDO)
								If ExistBlock("COM10PC")
									DbSelectArea("SDT")
									DbGoto(QRY1->R_E_C_N_O_)

									aVPed := {}
									aVPed := ExecBlock("COM10PC",.F.,.F.,{QRY1->DT_FORNEC,QRY1->DT_LOJA,QRY1->DT_COD,SDT->DT_COD,QRY1->DT_QUANT ,QRY1->DT_VUNIT,aCom10PC})
									If ValType(aVPed) == "A" .And. Len(aVPed) > 0 
										If .NOT. Empty(aVPed[1,1])
											DbSelectArea("SDT")
											RecLock("SDT",.F.)
											SDT->DT_PEDIDO := aVPed[1,1]
											SDT->DT_ITEMPC := aVPed[1,2]
											If Empty(SDT->DT_COD)
												SDT->DT_COD := aVPed[1,5]
											Endif
											MsUnlock()
											
											nTotOk++
										Endif
									Endif		
								Endif		
							Else
								If .NOT. Empty(QRY1->DT_COD)
									nTotOK++
								Endif
							Endif // até aqui //MH			
							
							QRY1->(dbSkip())
						EndDo
						QRY1->(dbCloseArea()) 
						
						//Atualizar status
						If nTotItem = nTotOk // _lAtuStatus //MH
							RecLock("SDS",.F.)
							SDS->DS_STATUS := ' '
							SDS->DS_STAPED := "2"
							SDS->(MsUnLock())
						EndIf
						
						//Permitir atualizar status quando não existe o ponto de entrada COM10PC
						// e o parâmetro ES_LIBSPED estiver como Sim - MH 17/01/2019
						If .NOT. ExistBlock("COM10PC")
							If SuperGetMv("ES_LIBSPED",.F.,"S") = "S"
								If nTotVinc = nPrdVinc
									RecLock("SDS",.F.)
									SDS->DS_STATUS := ' '
									SDS->(MsUnLock())
								Endif
							Endif
						Endif			

						_lAtuStatus    := .F.
				
					EndIf
				Endif
			EndIf
		Next nX
	EndIf
EndIf


Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ LoadFilesºAutor ³Felipi Marques       º Data ³  06/25/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Funcao que carrega os arquivos no browse de reprocessamentoº±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ oBrowse: browse dos arquivos a serem reprocessados.		  º±±
±±º			 ³ cCombo: opção selecionada no combo de documentos.		  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Reprocessa												  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LoadFiles(oBrowse,cCombo)
Local aArea		 := SDS->(GetArea())
Local aArquivo 	 := {}
Local aFiles   	 := {}
Local cError   	 := ""
Local cWarning 	 := ""
Local cTagRem    := ""
Local cTagDest	 := ""
Local cDiretorio := If(cCombo == "Documentos com erro",DIRXML +DIRERRO,DIRXML +DIRLIDO) 
Local lVldImport := If(cCombo == "Documentos com erro",.F.,.T.)
Local lAddArq  	 := .T.
Local oFullXML 	 := NIL
Local oOK 		 := LoadBitmap(GetResources(),'LBOK')
Local oNO 		 := LoadBitmap(GetResources(),'LBNO')
Local nX		 := 0
Local cXMLOri	 := ""
Local cXMLEncod	 := ""
Local nHandle	 := 0
Local nLength	 := 0
Local cFilSDS	 := xFilial("SDS")
Local cCGCP	:= ""
Local cNum		:= ""
Local cSerie	:= ""
Local cForn	:= ""
Local aAreaSDS:= {}

SDS->(dbSetOrder(2))
aFiles := Directory("\" +cDiretorio +"*.xml")
For nX := 1 To Len(aFiles)	
	nHandle := FOpen(cDiretorio +aFiles[nX,1])
	nLength := FSeek(nHandle,0,FS_END)
	FSeek(nHandle,0)
	If nHandle > 0
		FRead(nHandle, cXMLOri, nLength)
		FClose(nHandle)
		If !Empty(cXMLOri)
			If SubStr(cXMLOri,1,1) != "<"
				nPosPesq := At("<",cXMLOri)
				cXMLOri  := SubStr(cXMLOri,nPosPesq,Len(cXMLOri))		// Remove caracteres estranhos antes da abertura da tag inicial do arquivo
			EndIf
		EndIf
		cXMLEncod := EncodeUtf8(cXMLOri)
		// Verifica se o encode ocorreu com sucesso, pois alguns caracteres especiais provocam erro na funcao de encode, neste caso e feito o tratamento pela funcao A140IRemASC
		If Empty(cXMLEncod)
			cStrXML := cXMLOri
			cXMLOri := A140IRemASC(cStrXML)
			cXMLEncod := EncodeUtf8(cXMLOri)
		EndIf
		If Empty(cXMLEncod)
			cXMLEncod := cXMLOri
		EndIf
	EndIf
	If !Empty(cXMLEncod)
		oFullXML := XmlParser(cXMLEncod,"_",@cError,@cWarning)
	EndIf
	//-- Se nao houver Erro na sintaxe do XML adiciona no array
	If Empty(cError)
		If !Empty(oFullXML) .And. Empty(cError) .And. (ValType(XmlChildEx(oFullXML,"_NFEPROC")) == "O" .Or.; //-- Nota normal, devolucao, beneficiamento, bonificacao
		  												ValType(XmlChildEx(oFullXML,"_INVOIC_NFE_COMPL")) == "O" ) //-- Aviso de Embarque
			If ValType(XmlChildEx(oFullXML,"_INVOIC_NFE_COMPL")) == "O"
				//-- Verifica se o arquivo pertence a filial corrente
				If ValType(XmlChildEx(oFullXML:_INVOIC_NFE_COMPL:_NFE_SEFAZ:_NFE:_INFNFE:_DEST,"_CNPJ")) == "O"
					lAddArq := AllTrim(oFullXML:_INVOIC_NFE_COMPL:_NFE_SEFAZ:_NFE:_INFNFE:_DEST:_CNPJ:Text) == AllTrim(SM0->M0_CGC)
				Else
					lAddArq := AllTrim(oFullXML:_INVOIC_NFE_COMPL:_NFE_SEFAZ:_NFE:_INFNFE:_DEST:_CPF:Text) == AllTrim(SM0->M0_CGC)
				EndIf
			Else
				//-- Verifica se o arquivo pertence a filial corrente
				If ValType(XmlChildEx(oFullXML:_NFeProc:_NFe:_InfNfe:_Dest,"_CNPJ")) == "O"
					lAddArq := AllTrim(oFullXML:_NFeProc:_NFe:_InfNfe:_Dest:_CNPJ:Text) == AllTrim(SM0->M0_CGC)
				Else
					lAddArq := AllTrim(oFullXML:_NFeProc:_NFe:_InfNfe:_Dest:_CPF:Text) == AllTrim(SM0->M0_CGC)
				EndIf
			EndIf
			If lAddArq .And. lVldImport  
				If ValType(XmlChildEx(oFullXML,"_INVOIC_NFE_COMPL")) == "O"
					lAddArq := SDS->(!DbSeek(cFilSDS+Right(AllTrim(oFullXML:_INVOIC_NFE_COMPL:_NFE_SEFAZ:_NFE:_INFNFE:_ID:Text),44)))
				Else 
					lAddArq := SDS->(!DbSeek(cFilSDS+Right(AllTrim(oFullXML:_NFEPROC:_NFE:_InfNfe:_Id:Text),44)))
				EndIf
			EndIf
			If lAddArq .And. ValType(XmlChildEx(oFullXML,"_INVOIC_NFE_COMPL")) == "O"
				aAdd(aArquivo,{})
				aAdd(aTail(aArquivo),.F.) 																	//-- Nome do arquivo
				aAdd(aTail(aArquivo),aFiles[nX,1]) 														//-- Nome do arquivo
				aAdd(aTail(aArquivo),oFullXML:_INVOIC_NFE_COMPL:_NFE_SEFAZ:_NFE:_INFNFE:_IDE:_NNF:Text)	//-- Numero do Doc.
				aAdd(aTail(aArquivo),oFullXML:_INVOIC_NFE_COMPL:_NFE_SEFAZ:_NFE:_INFNFE:_IDE:_SERIE:Text)  //-- Serie Doc.
				aAdd(aTail(aArquivo),oFullXML:_INVOIC_NFE_COMPL:_NFE_SEFAZ:_NFE:_INFNFE:_EMIT:_XNOME:Text)	//-- Razao Social do fornecedor			
			Elseif lAddArq
				aAdd(aArquivo,{})
				aAdd(aTail(aArquivo),.F.) 												//-- Nome do arquivo
				aAdd(aTail(aArquivo),aFiles[nX,1]) 									//-- Nome do arquivo
				aAdd(aTail(aArquivo),oFullXML:_NFeProc:_NFe:_InfNfe:_Ide:_nNF:Text)	//-- Numero do Doc.
				aAdd(aTail(aArquivo),oFullXML:_NFeProc:_NFe:_InfNfe:_Ide:_Serie:Text)  //-- Serie Doc.
				aAdd(aTail(aArquivo),oFullXML:_NFeProc:_NFe:_InfNfe:_Emit:_xNome:Text)	//-- Razao Social do fornecedor
			EndIf
		ElseIf !Empty(oFullXML) .And. Empty(cError) .And. ValType(XmlChildEx(oFullXML,"_CTEPROC")) == "O" //-- Nota de transporte
			//-- Verifica se o arquivo pertence a filial corrente
			lAddArq := CTe_VldEmp(oFullXML:_CteProc:_CTe,SM0->M0_CGC)
			
			If lAddArq .And. lVldImport
				lAddArq := !SDS->(dbSeek(cFilSDS+Right(AllTrim(oFullXML:_CteProc:_CTe:_InfCTe:_Id:Text),44)))
			EndIf
			If lAddArq
				aAdd(aArquivo,{})
				aAdd(aTail(aArquivo),.F.) 										//-- Nome do arquivo
				aAdd(aTail(aArquivo),aFiles[nX,1]) 							//-- Nome do arquivo
				aAdd(aTail(aArquivo),oFullXML:_CteProc:_CTe:_InfCte:_Ide:_nCt:Text)  	//-- Numero do Doc.
				aAdd(aTail(aArquivo),oFullXML:_CteProc:_CTe:_InfCte:_Ide:_Serie:Text)  	//-- Serie Doc.
				aAdd(aTail(aArquivo),oFullXML:_CteProc:_CTe:_InfCte:_Emit:_xNome:Text) 	//-- Razao Social do fornecedor
			EndIf
		ElseIf !Empty(oFullXML) .And. Empty(cError) .And. ValType(XmlChildEx(oFullXML,"_TOTVSMESSAGE")) == "O" .And.; 
				ValType(XmlChildEx(oFullXML:_TOTVSMESSAGE:_BUSINESSMESSAGE:_BUSINESSCONTENT,"_PROCNEOGRIDNFSE")) == "O" // Nota de Servico
			//-- Verifica se o arquivo pertence a filial corrente
			lAddArq := AllTrim(oFullXML:_TOTVSMESSAGE:_BUSINESSMESSAGE:_BUSINESSCONTENT:_PROCNEOGRIDNFSE:_NEOGRID:_NEOGRIDRPS:_RPS:_TOMADOR:_CNPJTOM:TEXT) == AllTrim(SM0->M0_CGC)		 
			
			cCGCP	:= oFullXML:_TOTVSMESSAGE:_BUSINESSMESSAGE:_BUSINESSCONTENT:_PROCNEOGRIDNFSE:_NEOGRID:_NEOGRIDRPS:_RPS:_PRESTADOR:_CNPJPREST:TEXT
			cNum	:= oFullXML:_TOTVSMESSAGE:_BUSINESSMESSAGE:_BUSINESSCONTENT:_PROCNEOGRIDNFSE:_NEOGRID:_RETNEOGRIDNFSE:_NNFSE:TEXT
			cForn	:= oFullXML:_TOTVSMESSAGE:_BUSINESSMESSAGE:_BUSINESSCONTENT:_PROCNEOGRIDNFSE:_NEOGRID:_NEOGRIDRPS:_RPS:_PRESTADOR:_RSOCIALPREST:TEXT
			
			If lAddArq .And. lVldImport
				dbSelectArea("SA2")
				dbSetOrder(3)
				If dbSeek(xFilial('SA2')+AllTrim(cCGCP))
					aAreaSDS := SDS->(GetArea())
					SDS->(dbsetorder(1))
					lAddArq := !SDS->(dbSeek(xFilial("SDS")+PADL(cNum,TamSX3("DS_DOC")[1],"0")+PADR(cSerie,TamSX3("DS_SERIE")[1])+SA2->A2_COD+SA2->A2_LOJA))
					RestArea(aAreaSDS)
				EndIf
			EndIf
			
			If lAddArq
				aAdd(aArquivo,{})
				aAdd(aTail(aArquivo),.F.)
				aAdd(aTail(aArquivo),aFiles[nX,1])
				aAdd(aTail(aArquivo),cNum)
				aAdd(aTail(aArquivo),cSerie)
				aAdd(aTail(aArquivo),cForn)
			EndIf	
		EndIf
	EndIf		
   	oFullXML := Nil //-- Limpa objeto pra descarregar a memoria
	DelClassIntf()	//-- Limpa memoria
Next nX

If Len(aArquivo) == 0
	aAdd(aArquivo,{})
	aAdd(aTail(aArquivo),.F.)
	aAdd(aTail(aArquivo),"")
	aAdd(aTail(aArquivo),"")
	aAdd(aTail(aArquivo),"")
	aAdd(aTail(aArquivo),"")
EndIf

oBrowse:SetArray(aArquivo)
If Len(aArquivo) > 0
	oBrowse:bLine := {|| {If(aArquivo[oBrowse:nAT,1],oOK,oNO),aArquivo[oBrowse:nAt,02],aArquivo[oBrowse:nAt,03],aArquivo[oBrowse:nAt,04],aArquivo[oBrowse:nAt,05]}}
	oBrowse:bLDblClick := {|| aArquivo[oBrowse:nAt,1] := !aArquivo[oBrowse:nAt,1], oBrowse:Refresh()}
EndIf
oBrowse:Refresh()

SDS->(RestArea(aArea))
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PesquiArq ºAutor ³Felipi Marques       º Data ³  06/25/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Realiza pesquisa no browse de reprocessamento.             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ oBrowse: browse com os arquivos a serem reprocessados.	  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Reprocessa                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function PesquiArq(oBrowse)
Local lProc      := .F.
Local cCpoPesq   := Space(100)
Local cOrdem     := "Arquivo"
Local nSeek      := 0
Local oDlg		 := NIL
Local oCombo	 := NIL
Local oGet		 := NIL
Local nOrdem     := 1

Define MSDialog oDlg Title "Pesquisar" From 00,00 To 100,490 Pixel 

@05,05 ComboBox oCombo Var cOrdem Items {RetTitle("DS_ARQUIVO"),RetTitle("DS_DOC"),;
				RetTitle("DS_SERIE"),RetTitle("DS_NOMEFOR")} Size 206,36 Pixel Of oDlg On Change (nOrdem := oCombo:nAT)
@22,05 MSGet oGet Var cCpoPesq Size 206,10 Pixel Of oDlg
Define SButton From 05,215 Type 1 Of oDlg Enable Action (lProc := .T., oDlg:End())
Define SButton From 20,215 Type 2 Of oDlg Enable Action oDlg:End()

Activate MSDialog oDlg Center

If lProc
	cCpoPesq := Upper(AllTrim(cCpoPesq))
	If nOrdem == 1 //-- Arquivo
		aSort(oBrowse:aArray,,,{|x,y| x[2] < y[2]})
		nSeek := aScan(oBrowse:aArray,{|x| Upper(AllTrim(x[2])) == cCpoPesq})	
	ElseIf nOrdem == 2 //-- Documento
		aSort(oBrowse:aArray,,,{|x,y| x[3] < y[3]})
		nSeek := aScan(oBrowse:aArray,{|x| Upper(Left(x[3],Len(cCpoPesq))) == cCpoPesq})
	ElseIf nOrdem == 3 //-- Serie	
		aSort(oBrowse:aArray,,,{|x,y| x[4] < y[4]})
		nSeek := aScan(oBrowse:aArray,{|x| Upper(AllTrim(x[4])) == cCpoPesq})
	ElseIf nOrdem == 4 //-- Razao Social
		aSort(oBrowse:aArray,,,{|x,y| x[5] < y[5]} )
		nSeek := aScan(oBrowse:aArray,{|x| Upper(AllTrim(x[5])) == cCpoPesq})
	EndIf
	If nSeek > 0
		oBrowse:nAT := nSeek
		oBrowse:Refresh()
		oBrowse:SetFocus()
	Else
		Aviso("Atenção","A busca não encontrou resultados.",{"OK"}) 
	EndIf
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ Excluir  ºAutor ³Felipi Marques       º Data ³  06/25/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Exclui os documentos marcados.					          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Excluir()
Local lRet := .F.

lRet := MsgYesNo( "Confirma a exclusão dos documentos marcados?","Atenção") 

SDT->(dbSetOrder(3))
SDS->(dbGoTop())
While lRet .And. !SDS->(EOF())
	//-- Processa somente marcados e nao processados
	If DS_OK # cMarca .Or. DS_STATUS == "P"
		dbSkip()
		Loop
	EndIf
	
	//-- Deleta itens do documento
	SDT->(dbSeek(SDS->(DS_FILIAL+DS_FORNEC+DS_LOJA+DS_DOC+DS_SERIE)))
	While !SDT->(EOF()) .And. SDT->(DT_FILIAL+DT_FORNEC+DT_LOJA+DT_DOC+DT_SERIE) == SDS->(DS_FILIAL+DS_FORNEC+DS_LOJA+DS_DOC+DS_SERIE) 
		RecLock("SDT",.F.)
		SDT->(dbDelete())
		SDT->(MsUnLock())		
		SDT->(dbSkip())
	End
	
	//-- Deleta cabecalho do documento
	RecLock("SDS",.F.)
	SDS->(dbDelete())
	SDS->(MsUnLock())	
	SDS->(dbSkip())
End

SDS->(dbGoTop())
Return lRet

/*±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ Legenda   ºAutor ³Felipi Marques       º Data ³  06/25/15   º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Exibe uma janela contendo a legenda da browse.              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³           												   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/ 

User Function I20Leg()

Local aCores	:= {}
Local aCoresNew	:= {}

aAdd(aCores,{'BR_VERMELHO',"Documento Gerado"})
aAdd(aCores,{'BR_VERDE',"Documento Normal"})	
aAdd(aCores,{'BR_AZUL',"Docto. de Bonificação"})	
aAdd(aCores,{'BR_AMARELO',"Docto. de Devolução"})	
aAdd(aCores,{'BR_CINZA',"Docto. de Beneficiamento"})
aAdd(aCores,{'BR_PINK',"Docto. de Compl. Preço"})	 
aAdd(aCores,{'BR_LARANJA',"Docto. de Transporte"})	
aAdd(aCores,{'BR_PRETO',"Documento c/ Ocorrência"})	
aAdd(aCores,{'BR_VIOLETA',"Erro Produto x Fornecedor/Cliente"})	
aAdd(aCores,{"BR_BRANCO","Nota de Importação"}) 
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ponto de Entrada para incluir/alterar opcoes de legenda ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ExistBlock("COMXLEG")
	aCoresNew := ExecBlock("COMXLEG",.F.,.F.,{aCores})
	If ValType(aCoresNew) == "A"
		aCores := aCoresNew
	EndIf
EndIf

BrwLegenda("NF-e Disponíveis","Legenda",aCores)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    | Documentos ºAutor ³Felipi Marques           º Data ³  06/25/15   º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao | Funcao procura possiveis pedidos de compra relacionados a NF     ³±± 
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cProduto: codigo do produto posicionado.							³±±
±±³			 ³ lPedDoc: indica se a pequisa e por documento ou item.			³±±
±±³			 ³ oGetDados: objeto com os itens do documento.						³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±       
±±³ Uso      ³ MontaTela	                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±       
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±      
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
*/   
Static Function Documentos(cProduto,lPedDoc,nMultPC,aColsAnt)
Local aArea		:= GetArea()
Local lRet		:= .F.
Local lRetXPC	:= .T.
Local cAliasTmp	:= "SC7TMP"
Local nRecSDT	:= 0
Local lA140IPed := ExistBlock("A140IPED")
Local aCampos   := {}
Local nX        := 0
Local lRemet	:= .F.
Local cQuery := ""
Local cFilSC7	:= xFilial("SC7")
Private lConsLoja	:= .T. //(mv_par12==1)	// Considera loja na pesquisa de pedidos

Default nMultPC := 0

// Verifica se e CT-e e se e remetente da mercadoria (saida), neste caso deve permitir vinculo com pedido
If SDS->DS_TIPO == "T" .And. SDS->DS_TPFRETE == "F"
	lRemet := .T.
EndIf

// Verifica se utiliza funcionalidade de vinculo de multiplos pedidos
lRetXPC := ValidXPC(lRemet,nMultPC,aColsAnt)

If ( SDS->DS_TIPO $ "N" .Or. lRemet ) .And. lRetXPC	//-- NF Normal (Compra) ou CT-e de saida
	
		cQuery += "SELECT " +If(lPedDoc,"DISTINCT C7_LOJA, ","") +"C7_NUM, C7_EMISSAO"
		If !lPedDoc
			cQuery += ", C7_ITEM, C7_QUANT, C7_PRECO, C7_TOTAL, C7_QTDACLA, C7_LOJA, C7_PRODUTO, C7_QUJE"
		EndIf
		// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿ 	 
		// |  Ponto de entrada utilizado para adicionar campos na interface de visualização de pedidos  |	
	   	// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
		If lA140IPed
			aCampos := ExecBlock("A140IPED",.F.,.F.,{1,{},{}})
			If ValType(aCampos[1]) == "A"
				For nX:=1 to Len(aCampos[1])
					cQuery += " , " + aCampos[1][nX]
				Next nX
			EndIf
		EndIf
		cQuery += " FROM " +RetSqlName("SC7") +" SC7"
		cQuery += " WHERE C7_FILIAL = '" + cFilSC7 + "' AND D_E_L_E_T_ <> '*'"
		cQuery += " AND C7_FORNECE = '" +SDS->DS_FORNEC + "'"
		cQuery += " AND C7_LOJA = '" +SDS->DS_LOJA + "'"
		If !lPedDoc .And. nMultPC == 0
			cQuery += " AND C7_PRODUTO = '" +cProduto +"'"
		EndIf
		cQuery += " AND (C7_QUANT - C7_QUJE - C7_QTDACLA) > 0"
		cQuery += " AND C7_ENCER = ' ' AND C7_RESIDUO <> 'S'"
		If SuperGetMV("MV_RESTNFE") == "S"
			cQuery += " AND C7_CONAPRO <> 'B'"
		EndIf			
		cQuery += " AND C7_FILENT = '"+ cFilSC7 +"' " // MH 17/05/2019
		
		cQuery += " ORDER BY C7_NUM"    // (Luiz - 28/05/2020)
		
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),cAliasTmp,.T.,.T.)
	
	(cAliasTmp)->(dbGoTop())	
	If (cAliasTmp)->(!EOF())
		lRet := Pedidos(cProduto,lPedDoc,cAliasTmp,.T.,nMultPC,aColsAnt)
	Else
	
		If .NOT. lPedDoc
			Aviso("Atenção","Não há pedidos de compra para o Produto " +AllTrim(cProduto) ,{"OK"})
		Else
			Aviso("Atenção","Não há pedidos de compra para o Fornecedor " +SDS->DS_FORNEC+"/"+SDS->DS_LOJA,{"OK"})
		Endif	
			
	EndIf
	(cAliasTmp)->(dbCloseArea())
Else
	If SDS->DS_TIPO $ "D"
		lRet := F4NFORI(,,"M->DT_NFORI",SDS->DS_FORNEC,SDS->DS_LOJA,cProduto,"A140I",,@nRecSDT) .And. nRecSDT <> 0
	ElseIf SDS->DS_TIPO == "C"
		lRet := F4COMPL(,,,SDS->DS_FORNEC,SDS->DS_LOJA,cProduto,"A140I",@nRecSDT,"M->DT_NFORI") .And. nRecSDT <> 0
	EndIf
EndIf	

RestArea(aArea)
Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    | Pedidos        ºAutor ³Felipi Marques       º Data ³  06/25/15   º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao | Funcao responsavel por criar o browse de selecao para que o      ³±±  
±±³          | usuario escolha os pedidos de compra referentes aos itens na NF  ³±± 
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cProduto: codigo do produto posicionado.						    ³±±
±±³			 ³ lPedDoc: indica se a selecao e por documento.					³±±
±±³			 ³ cAliasTmp: alias com o resultado da query dos documentos			³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±        
±±³Retorno   ³ lRet: indica a confirmacao da selecao dos pedidos                ³±±    
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±       
±±³ Uso      ³ Documentos														³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±       
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±      
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
*/ 
Static Function Pedidos(cProduto,lPedDoc,cAliasTmp,lConsLoja,nMultPC,aColsAnt)
Local lRet 		 := .F.
Local oDlg		 := NIL
Local oBrowse	 := NIL
Local oOk		 := LoadBitMap(GetResources(),"LBOK")
Local oNo		 := LoadBitMap(GetResources(),"LBNO")
Local aPedidos	 := {}
Local aArea		 := GetArea()
Local aCampos    := {} 
Local aSize      := MsAdvSize(.F.)
Local nlTl1      := aSize[1]
Local nlTl2    	 := aSize[2]
Local nlTl3    	 := aSize[1]+300
Local nlTl4		 := aSize[2]+480
Local nX		 := 0
Local nY		 := 0
Local nPosQtde	 := aScan(aHeader,{|x| AllTrim(x[2]) == "DT_QUANT"})
Local lContinua	 := .T.
Local lA140IPed  := ExistBlock("A140IPED")
Local aRetPE     := {}
Local nZ         := 0
Local cCampoUsr  := ""
Local cSeek		 := ""
Local cItem		 := StrZero(1,Len(SDT->DT_ITEM))
Local aCampoUsr  := {}
Local aColsNew	 := {}
Local nPosCpo    := 0
Local nSldPed    := 0
Local nCont		 := 1
Local nTamCpos	 := 0
Local nMarcado	 := 0
Local nTotPed	 := 0
Local nTotQtd	 := 0
Local lInforma	 := .F.
Local cFilSA2		:= xFilial("SA2")
Local cFilSB1		:= xFilial("SB1")
Local cFilSC7		:= xFilial("SC7")
Local lZeraCols  := .T.
Local lExit		 := .F.

Default nMultPC  := 0

// Foi necessario criar essas variaveis para que fosse possivel usar a funcao padrao do sistema A120Pedido()
Private INCLUI      := .F.
Private ALTERA      := .F.
Private nTipoPed    := 1
Private l120Auto    := .F.  	                                   
Private LINTGC      := .F.  

If !lPedDoc
	aCampos := {"",RetTitle("C7_LOJA"),RetTitle("C7_NUM"),RetTitle("C7_ITEM"),RetTitle("C7_PRODUTO"),RetTitle("C7_EMISSAO"),"Saldo"} 
	bLine := {|| {	If(aPedidos[oBrowse:nAt,1],oOk,oNo),;								//-- Marca
					aPedidos[oBrowse:nAt,2],;											//-- Loja
					aPedidos[oBrowse:nAt,3],;											//-- Pedido
					aPedidos[oBrowse:nAt,4],;											//-- Item
					aPedidos[oBrowse:nAt,5],;											//-- Produto
					aPedidos[oBrowse:nAt,6],;											//-- Emissao
					Transform(aPedidos[oBrowse:nAt,7],PesqPict("SC7","C7_QUANT"))}}		//-- Saldo

	// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿ 	 
	// |  Ponto de entrada utilizado para adicionar campos na interface de visualização de pedidos  |	
   	// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
	If lA140IPed
		nTamCpos := Len(aCampos)
		aRetPE := ExecBlock("A140IPED",.F.,.F.,{2,aCampos,aCampos})
		If ValType(aRetPE[1]) == "A"
			For nZ:=1 to Len(aRetPe[1])
				Aadd(aCampoUsr,aRetPE[3][1][nZ+nTamCpos])
			Next nZ
		EndIf
	EndIf					

	&(cAliasTmp+"->(dbGoTop())")   
	While &(cAliasTmp+"->(!EOF())")    
		aAdd(aPedidos, {.F.,;															//-- Marca
						&(cAliasTmp+"->C7_LOJA"),;										//-- Loja
						&(cAliasTmp+"->C7_NUM"),;										//-- Pedido
						&(cAliasTmp+"->C7_ITEM"),;										//-- Item
						&(cAliasTmp+"->C7_PRODUTO"),;									//-- Produto
						StoD(&(cAliasTmp+"->C7_EMISSAO")),;								//-- Emissao
						&(cAliasTmp+"->C7_QUANT") - &(cAliasTmp+"->C7_QTDACLA") - &(cAliasTmp+"->C7_QUJE"),;		//-- Saldo
	  					&(cAliasTmp+"->C7_PRECO") })

		If lA140IPed
			If ValType(aRetPE[1]) == "A"
				For nZ:=1 to Len(aRetPe[1])
					cCampoUsr := "CAMPO"+AllTrim(Str(nZ))
					nPosCpo := AScan( aCampoUsr, {|x| AllTrim(x[1]) == cCampoUsr } )
					If nPosCpo > 0
						If nCont==1
							Aadd(aCampos,aCampoUsr[nPosCpo][3])
						EndIf
						If aRetPE[2][1][nZ+nTamCpos][2]=="D"										// Se campo tipo Data
							Aadd(aPedidos[Len(aPedidos)],(StoD(&(cAliasTmp+"->"+aRetPE[1][nZ]))))	// Converte para data
						Else
							Aadd(aPedidos[Len(aPedidos)],((&(cAliasTmp+"->"+aRetPE[1][nZ]))))		// Caso contrário não converte
						EndIf
					Else
						Aadd(aPedidos[Len(aPedidos)],((&(cAliasTmp+"->"+aRetPE[1][nZ]))))
					EndIf
				Next nZ
			EndIf
			nCont++
		EndIf

        //-- Se o pedido ja esta no aCols, marca como usado
        If !Empty(aCols[n,GDFieldPos("DT_PEDIDO")]) .And.;
					aCols[n,GDFieldPos("DT_PEDIDO")] == &(cAliasTmp+"->C7_NUM") .And.;
					aCols[n,GDFieldPos("DT_ITEMPC")] == &(cAliasTmp+"->C7_ITEM")
			aTail(aPedidos)[1] := .T.
		EndIf
		//-- Vínculo por múltiplos pedidos
		If nMultPC > 0
			For nX := 1 To Len(aCols)
				If !Empty(aCols[nX,GDFieldPos("DT_PEDIDO")]) .And.;
							aCols[nX,GDFieldPos("DT_PEDIDO")] == &(cAliasTmp+"->C7_NUM") .And.;
							aCols[nX,GDFieldPos("DT_ITEMPC")] == &(cAliasTmp+"->C7_ITEM")
					aTail(aPedidos)[1] := .T.
				EndIf
			Next nX
		EndIf

		&(cAliasTmp)->(dbSkip())
	EndDo 

	If lA140IPed
		If ValType(aRetPE[1]) == "A"
			If Len(aRetPE[1]) == 1
				bLine := {|| {	If(aPedidos[oBrowse:nAt,1],oOk,oNo),;								//-- Marca
								aPedidos[oBrowse:nAt,2],;											//-- Loja
								aPedidos[oBrowse:nAt,3],;											//-- Pedido
								aPedidos[oBrowse:nAt,4],;											//-- Item
								aPedidos[oBrowse:nAt,5],;											//-- Produto
								aPedidos[oBrowse:nAt,6],;											//-- Emissao
								Transform(aPedidos[oBrowse:nAt,7],PesqPict("SC7","C7_QUANT")),; 	//-- Saldo
								aPedidos[oBrowse:nAt,8]}}
			ElseIf Len(aRetPE[1]) == 2
				bLine := {|| {	If(aPedidos[oBrowse:nAt,1],oOk,oNo),;								//-- Marca
								aPedidos[oBrowse:nAt,2],;											//-- Loja
								aPedidos[oBrowse:nAt,3],;											//-- Pedido
								aPedidos[oBrowse:nAt,4],;											//-- Item
								aPedidos[oBrowse:nAt,5],;											//-- Produto
								aPedidos[oBrowse:nAt,6],;											//-- Emissao
								Transform(aPedidos[oBrowse:nAt,7],PesqPict("SC7","C7_QUANT")),; 	//-- Saldo
								aPedidos[oBrowse:nAt,8],;
								aPedidos[oBrowse:nAt,9]}}
			Else
				bLine := {|| {	If(aPedidos[oBrowse:nAt,1],oOk,oNo),;								//-- Marca
								aPedidos[oBrowse:nAt,2],;											//-- Loja
								aPedidos[oBrowse:nAt,3],;											//-- Pedido
								aPedidos[oBrowse:nAt,4],;											//-- Item
								aPedidos[oBrowse:nAt,5],;											//-- Produto
								aPedidos[oBrowse:nAt,6],;											//-- Emissao
								Transform(aPedidos[oBrowse:nAt,7],PesqPict("SC7","C7_QUANT")),; 	//-- Saldo
								aPedidos[oBrowse:nAt,8],;
								aPedidos[oBrowse:nAt,9],;
								aPedidos[oBrowse:nAt,10]}}
			EndIf
		EndIf
	EndIf

Else
	aCampos := {"",RetTitle("C7_LOJA"),RetTitle("C7_NUM"),RetTitle("C7_EMISSAO")}
	bLine := {|| {	If(aPedidos[oBrowse:nAt,1],oOk,oNo),;	//-- Marca
					aPedidos[oBrowse:nAt,2],;				//-- Loja
					aPedidos[oBrowse:nAt,3],;				//-- Pedido
					aPedidos[oBrowse:nAt,4]	}	}			//-- Emissao

	&(cAliasTmp+"->(dbGoTop())")   
	While &(cAliasTmp+"->(!EOF())")    
		aAdd(aPedidos, {.F.,;															//-- Marca
						&(cAliasTmp+"->C7_LOJA"),;										//-- Loja
						&(cAliasTmp+"->C7_NUM"),;										//-- Pedido
						StoD(&(cAliasTmp+"->C7_EMISSAO"))	})							//-- Emissao
	
		//-- Se o pedido ja esta no aCols, marca como usado
        If !Empty(aCols[n,GDFieldPos("DT_PEDIDO")]) .And.;
					aCols[n,GDFieldPos("DT_PEDIDO")] == &(cAliasTmp+"->C7_NUM")
			aTail(aPedidos)[1] := .T.
		EndIf
		//-- Vínculo por múltiplos pedidos
		If nMultPC > 0
			For nX := 1 To Len(aCols)
				If !Empty(aCols[nX,GDFieldPos("DT_PEDIDO")]) .And.;
							aCols[nX,GDFieldPos("DT_PEDIDO")] == &(cAliasTmp+"->C7_NUM")
					aTail(aPedidos)[1] := .T.
				EndIf
			Next nX
		EndIf
		&(cAliasTmp)->(dbSkip())
	EndDo 	
EndIf	                                       

//-- Monta interface para selecao do pedido
Define MsDialog oDlg Title "Vínculo com Pedido de Compra" From nlTl1,nlTl2 To nlTl3,nlTl4 Pixel 

//-- Cabecalho
@(nlTl1+10),nlTl2+3 To (nlTl1+22),(nlTl2+240) Pixel Of oDlg
If !lPedDoc
	@(nlTl1+12),(nlTl2+8) Say "Doc: " +SDS->DS_DOC +" - " +"Item:" +AllTrim(aCols[n,GDFieldPos("DT_ITEM")]) +" / " +AllTrim(cProduto) + " - " + Posicione("SB1",1,cFilSB1+cProduto,"B1_DESC") Pixel Of oDlg 
Else
	@(nlTl1+12),(nlTl2+8) Say "Doc: " +SDS->DS_DOC +" - " +"Fornecedor " +SDS->DS_FORNEC +"/" +SDS->DS_LOJA +" - " +Posicione("SA2",1,cFilSA2+SDS->(DS_FORNEC+DS_LOJA),"A2_NOME") Pixel Of oDlg 
EndIf 		

//-- Itens
oBrowse := TCBrowse():New(nlTl1+30,nlTl2+3,nlTl4-245,nlTl3-200,,aCampos,,oDlg,,,,,{|| MarcaPC(@aPedidos,oBrowse:nAt,lPedDoc,nMultPC),oBrowse:Refresh()},,,,,,,,,.T.)
oBrowse:SetArray(aPedidos)
oBrowse:bLine := bLine

//-- Botoes
TButton():New(nlTl1+134,nlTl2+3,"Visualizar pedido ",oDlg,{|| MsgRun("Carregando visualização do pedido"  +AllTrim(aPedidos[oBrowse:nAt,3]) +"...","...", {|| A120Pedido("SC7" ,GetC7Recno(aPedidos[oBrowse:nAt,3]),2,,.T.)    })},055,012,,,,.T.) 
																										
Define SButton From nlTl1+134,nlTl2+177 Type 1 Action Eval({|| If(lRet := ValidPC(cProduto,lPedDoc,aPedidos,oBrowse:nAt,nMultPC,.T.),oDlg:End(),)}) Enable Of oDlg
Define SButton From nlTl1+134,nlTl2+212 Type 2 Action oDlg:End() Enable Of oDlg
 	
Activate Dialog oDlg Centered
          
If lRet .And. nMultPC == 0
	SC7->(dbSetOrder(If(.T.,2,1)))
	IF lPedDoc
		For nX := 1 To Len(aCols)
			aCols[nX,GDFieldPos("DT_PEDIDO")] := CriaVar("DT_PEDIDO",.F.)
			aCols[nX,GDFieldPos("DT_ITEMPC")] := CriaVar("DT_ITEMPC",.F.)
		Next nX		
	EndIf
	For nX := 1 To Len(aPedidos)
		If aPedidos[nX,1] //-- Preenche aCols com o item marcado
			If !lPedDoc
				aCols[n,GDFieldPos("DT_PEDIDO")] := aPedidos[nX,3]
				aCols[n,GDFieldPos("DT_ITEMPC")] := aPedidos[nX,4]
				Exit
			Else				   
			    For nY := 1 To Len(aCols)
						cSeek := aCols[nY,GDFieldPos("DT_COD")]+SDS->(DS_FORNEC+DS_LOJA)+aPedidos[nX,3]
					If SC7->(dbSeek(xFilial("SC7")+cSeek))
						While SC7->(!EOF()) .And. SC7->C7_FILIAL == xFilial("SC7") .And. SC7->C7_NUM == aPedidos[nX,3]
							If SC7->C7_FORNECE == SDS->DS_FORNEC .And. If(lConsLoja, SC7->C7_LOJA == SDS->DS_LOJA, .T.) .And.;
								SC7->C7_PRODUTO == aCols[nY,GDFieldPos("DT_COD")]
								If aCols[nY,nPosQtde] <= SC7->C7_QUANT
									aCols[nY,GDFieldPos("DT_PEDIDO")] := SC7->C7_NUM
									aCols[nY,GDFieldPos("DT_ITEMPC")] := SC7->C7_ITEM  
									lContinua := .F.
								Else
									If !lInforma
										AVISO("ATENÇÃO!","Para os itens do pedido com quantidade inferior aos itens correspondentes da nota utilize a opção de vínculo por Item.",{"OK"})
										lInforma := .T.
									EndIf
								EndIf
							EndIf

							SC7->(dbSkip())
						End
					EndIf
			    Next nY     
			    IF !lContinua
			    	Exit
			    EndIf
			EndIf
		Else 
			aCols[n,GDFieldPos("DT_PEDIDO")] := CriaVar("DT_PEDIDO",.F.)
			aCols[n,GDFieldPos("DT_ITEMPC")] := CriaVar("DT_ITEMPC",.F.)
		EndIf
	Next nX
EndIf

// Vinculo por multiplos pedidos
If lRet .And. nMultPC > 0
	aColsBkp := aCols
	// Armazena quantidade total da nota
	If nMultPC == 1			// Vinculo de multiplos pedidos por item
		nTotQtd := aCols[N][nPosQtde]
	ElseIf nMultPC == 2		// Vinculo de multiplos pedidos por documento
		For nX := 1 To Len(aCols)
			nTotQtd += aCols[nX][nPosQtde]
		Next nX
	EndIf
	For nX := 1 To Len(aPedidos)
		If aPedidos[nX][1]
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Zera o aCols para criar novamente de acordo com os pedidos  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lZeraCols
				aCols := {}
				lZeraCols := .F.
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Posiciona Pedido de Compra                               ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cSeek      :=xFilial("SC7")+aPedidos[nX][3]+If(nMultPC == 1,aPedidos[nX][4],"")
			cFilialOri :=C7_FILIAL
			DbSetOrder(14)
			dbSeek(cSeek)

			While ( !Eof() .And. SC7->C7_FILIAL+SC7->C7_NUM+If(nMultPC == 1,SC7->C7_ITEM,"")==cSeek )
				// Verifica se o fornecedor esta correto
				If C7_FILIAL+C7_FORNECE+If(lConsLoja,C7_LOJA,"") == SDS->DS_FILIAL+SDS->DS_FORNEC+If(lConsLoja,SDS->DS_LOJA,"")
					nSldPed := SC7->C7_QUANT-SC7->C7_QUJE-SC7->C7_QTDACLA
					If nSldPed > 0 .And. Empty(SC7->C7_RESIDUO)
						// Calcula qtde total dos pedidos utilizados
						nSaldo := nTotQtd - nTotPed
						If nSldPed > nSaldo
							nSldPed := nSaldo
							lExit := .T.
						EndIf
						If nSldPed > 0
							VincMultPC(aPedidos,nSldPed,aColsBkp,cItem,nMultPC)
						EndIf
						cItem := SomaIt(cItem)
						nTotPed += nSldPed
					EndIf
				EndIf
				If lExit
					Exit
				EndIf
				DbSelectArea("SC7")         
				dbSkip()             
			EndDo
			nMarcado++
		EndIf
		If lExit
			Exit
		EndIf
	Next nX
	// Se sobrou quantidade, cria mais um item para bater a quantidade total
	If nTotQtd > nTotPed
		nSldPed := nTotQtd - nTotPed
		VincMultPC(aPedidos,nSldPed,aColsBkp,cItem,nMultPC,.T.)
	EndIf
	If Len(aCols) > 0
		If nMarcado > 0
			If nMultPC == 1								// Opcao de vinculo de multiplos pedidos por item
				cItem := StrZero(0,Len(SDT->DT_ITEM))	// Reordena numeracao dos itens da nota
				For nX := 1 To Len(aColsBkp)
					If nX < N .Or. nX > N
						cItem := SomaIt(cItem)
						aColsBkp[nX][1] := cItem
						AADD(aColsNew,aColsBkp[nX])
					ElseIf nX == N
						For nY := 1 To Len(aCols)
							cItem := SomaIt(cItem)
							aCols[nY][1] := cItem
							AADD(aColsNew,aCols[nY])
						Next nY
					EndIf
				Next nX
				If Len(aColsNew) > 0
					aCols := aColsNew
				EndIf
			EndIf
		Else
			ComXItOri(aColsAnt)		// Se nenhum pedido for marcado retorna os itens ao estado original
		EndIf
	Else
		lRet := .F.
	EndIf
EndIf

RestArea(aArea)
Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    | ValidPC        ºAutor ³Felipi Marques       º Data ³  06/25/15   º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao | Validacao dos campos qtde e preco Unit. do pedido de compra com  ³±± 
±±³			 | o documento NFe.						                            ³±± 
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros| cCodProd: codigo do produto.										³±±   
±±³          | lPedDoc: indica se a busca e por documento ou item.				³±±
±±³          | aPedidos: array com os pedidos exibidos na tela de vinculo.		³±±
±±³          | nLinha: indica a linha do browse de pedidos que foi marcada.		³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±        
±±³Retorno   ³ lRet: pedido valido ou nao valido                                ³±±    
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±       
±±³ Uso      ³ Pedidos		                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±       
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±      
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
*/
Static Function ValidPC(cCodProd,lPedDoc,aPedidos,nLinha,nMultPC,lConsLoja)

Local lRet		:= .T.
Local lAchou	:= .F.
Local lMarcado	:= .F.
Local aArea		:= SDT->(GetArea())
Local aAreaSC7	:= SC7->(GetArea())
Local aProds	:= {}
Local nPosCod	:= aScan(aHeader,{|x| AllTrim(x[2]) == "DT_COD"})
Local nPosQtde	:= aScan(aHeader,{|x| AllTrim(x[2]) == "DT_QUANT"})
Local nX		:= 0
Local nY		:= 0
Local nSldPed	:= 0
Local nTotQtd	:= 0
Local nTotPed	:= 0
Local cFilSDT	:= xFilial("SDT")

// Ponto de entrada para validacao do pedido selecionado
If ExistBlock("COMCOLPC")
	lRet := ExecBlock("COMCOLPC",.F.,.F.,{aCols,"TMP"})
ElseIf !lPedDoc .And. nMultPC == 0
	//-- Verifica se quantidade e preco sao diferentes para alertar o usuario
	SDT->(dbSetOrder(3))
	SDT->(dbSeek(cFilSDT+SDS->(DS_FORNEC+DS_LOJA+DS_DOC+DS_SERIE)+cCodProd))
	If aPedidos[nLinha,1] .And. (SDT->DT_QUANT <> aPedidos[nLinha,7] .Or. SDT->DT_VUNIT <> aPedidos[nLinha,8])
		lRet := MsgYesNo("A quantidade e/ou preço unitário do pedido selecionado é divergente do item da NF-e. Confirma o vínculo?","Atenção") 
	EndIF
ElseIf nMultPC > 0	// Validacao para vinculo de multiplos pedidos
	// Armazena todos os produtos da nota para nao permitir vincular pedidos que nao tenham nenhum produto correspondente
	For nX := 1 To Len(aCols)
		AADD(aProds,AllTrim(aCols[nX][nPosCod]))
		nTotQtd += aCols[nX][nPosQtde]
	Next nX

	// Verifica se ha pedidos marcados
	For nX := 1 To Len(aPedidos)
		If aPedidos[nX][1]
			lMarcado := .T.
			Exit
		EndIf
	Next nX

	//-- Verifica se os itens da nota ja foram alterados
	SDT->(dbSetOrder(1))
	SDT->(dbSeek(xFilial("SDT")+SDS->(DS_CNPJ+DS_FORNEC+DS_LOJA+DS_DOC+DS_SERIE)))
	If lMarcado .And. SDT->DT_ORIGIN == "2"
		Aviso("ATENÇÃO!","Este item já foi alterado através de vínculo por múltiplos pedidos. Caso necessário, desfaça os vínculos para retornar ao estado original e confirme para poder refazer o vínculo.",{"OK"})
		lRet := .F.
	EndIf

	If nMultPC == 1			// Vinculo de multiplos pedidos por item
		nTotQtd := aCols[N][nPosQtde]
	EndIf

	If lRet
		For nY := 1 To Len(aPedidos)
			If aPedidos[nY][1]
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Posiciona Pedido de Compra                               ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				cSeek := xFilial("SC7")+aPedidos[nY][3]+If(nMultPC == 1,aPedidos[nY][4],"")
				DbSelectArea("SC7")
				DbSetOrder(14)
				dbSeek(cSeek)
	
				While ( !Eof() .And. SC7->C7_FILIAL+SC7->C7_NUM+If(nMultPC == 1,SC7->C7_ITEM,"")==cSeek )
					// Verifica se o fornecedor esta correto
					If C7_FILIAL+C7_FORNECE+If(lConsLoja,C7_LOJA,"") == SDS->DS_FILIAL+SDS->DS_FORNEC+If(lConsLoja,SDS->DS_LOJA,"")
						If aScan(aProds,{|x| x == AllTrim(SC7->C7_PRODUTO)}) > 0
							lAchou := .T.
						EndIf
						nSldPed := SC7->C7_QUANT-SC7->C7_QUJE-SC7->C7_QTDACLA
						If nSldPed > 0 .And. Empty(SC7->C7_RESIDUO)
							nTotPed += nSldPed
						EndIf
					EndIf
					DbSelectArea("SC7")
					dbSkip()             
				EndDo
			EndIf
		Next nX
		If lMarcado
			// Se nenhum produto dos pedidos selecionados corresponde a nenhum dos produtos da nota, nao efetua o vinculo
			If !lAchou
				Aviso("ATENÇÃO!","Nenhum produto dos pedidos selecionados confere com o(s) produtos da nota/item nota. Vínculo não será efetuado.",{"OK"})	
				lRet := .F.
			EndIf

			// Verifica se quantidade e diferente
			If lRet .And. nTotQtd != nTotPed
				lRet := MsgYesNo((If(nMultPC == 1,"ATENÇÃO!","O saldo total dos pedidos selecionados difere da quantidade total da nota. Confirma o vínculo?" )),"O saldo total dos pedidos selecionados difere da quantidade do item da nota. Confirma o vínculo?") 
			EndIf
		EndIf
	EndIf
EndIf
SC7->(RestArea(aAreaSC7))
SDT->(RestArea(aArea))

Return lRet

/* 
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    | ValidXPC    ºAutor ³Felipi Marques          º Data ³  06/25/15   º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao | Validacao para utilizacao da funcionalidade de vinculo de		³±±
±±³			 | multiplos pedidos.					                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros| cCodProd: codigo do produto.										³±±
±±³          | lPedDoc: indica se a busca e por documento ou item.				³±±
±±³          | aPedidos: array com os pedidos exibidos na tela de vinculo.		³±±
±±³          | nLinha: indica a linha do browse de pedidos que foi marcada.		³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ lRet: pedido valido ou nao valido                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Documentos	                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
*/
Static Function ValidXPC(lRemet,nMultPC,aColsAnt)

Local lRet		:= .T.
Local nX		:= 0
Local nPosValor	:= aScan(aHeader,{|x| AllTrim(x[2]) == "DT_VUNIT"})

If SDS->DS_TIPO $ "N" .Or. lRemet	//-- NF Normal (Compra) ou CT-e de saida
	// Posiciona no primeir item da nota
	DbSelectArea("SDT")
	DbSetOrder(2)
	MsSeek(xFilial("SDT")+SDS->(DS_FORNEC+DS_LOJA+DS_DOC+DS_SERIE))

	// Verifica se foi selecionada opcao Vinc Mult PC
	If lRet .And. (nMultPC == 1 .Or. nMultPC == 2)
		If lRet
			If !Empty(AllTrim(oGetDados:aCols[oGetDados:nAt,GdFieldPos("DT_PEDIDO")]))
				Aviso("Atenção","Este item ja possui vinculo com pedido, favor utilizar um item que não possua vinculo com nenhum pedido.",{"OK"})
				lRet := .F.
			Endif
		Endif
	EndIf
	
EndIf

Return lRet 


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    | MarcaPC	  ºAutor ³Felipi Marques           º Data ³  06/25/15   º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao | Executada quando o registro e marcado para desmarcar os demais.  ³±± 
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ aPedidos: array com os pedidos exibidos em tela.					³±±  
±±³			 ³ nLinha: linha do pedido que foi marcado.							³±±  
±±³			 ³ lPedDoc: indica se e selecao por documento.						³±±  
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±       
±±³ Uso      ³ Pedidos	                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±       
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±      
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
*/
Static Function MarcaPC(aPedidos,nLinha,lPedDoc,nMultPC)
Local nDesmarca := 0

//-- Desmarca o item que ja estava marcado
If !lPedDoc .And. nMultPC == 0
	nDesmarca := aScan(aPedidos,{|x| x[1]})
	If nDesmarca == nLinha
		nDesmarca := aScan(aPedidos,{|x| x[1]},nLinha+1)
	EndIf
	If !Empty(nDesmarca)
		aPedidos[nDesmarca,1] := .F.
	EndIf
EndIf
aPedidos[nLinha,1] := !aPedidos[nLinha,1]

Return      

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    | GetC7Recno ºAutor ³Felipi Marques           º Data ³  06/25/15   º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao | Funcao para retornar o recno do pedido.                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cPedido: numero do pedido de compra                             	³±±  
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±        
±±³Retorno   ³ nRet: recno do pedido de compra									³±±    
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±       
±±³Uso       ³ Pedidos														    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±       
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±      
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
*/  
Static Function GetC7Recno(cPedido)
Local nRet := 0
Local cFilSC7 := xFilial("SC7")
 	
SC7->(dbSetOrder(1))
If SC7->(dbSeek(cFilSC7+cPedido))
	nRet := SC7->(Recno())
EndIf

Return nRet

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  | NOMEFORIni ºAutor ³Felipi Marques           º Data ³  06/25/15   º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao | Busca o nome do cliente quando o tipo da nota for devolucao ou   ³±±   
±±³			 | beneficiamento caso contrario busca o nome do fornecedor.   		³±±   
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±    
±±³Retorno   ³ Nome do fornecedor/cliente                                       ³±±    
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±       
±±³ Uso      ³ Inicializador do campo DS_NOMEFOR (X3_RELACAO e X3_INIBRW)       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±       
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±      
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ*/

User Function NOMEFORIni()
Local cNomeFC := ""
Local cFilSA1 := xFilial("SA1")
Local cFilSA2 := xFilial("SA2")
                                          
If SDS->DS_TIPO $ "DB"
	cNomeFC := Posicione("SA1",1,cFilSA1+SDS->(DS_FORNEC+DS_LOJA),"A1_NOME")
Else
	cNomeFC := Posicione("SA2",1,cFilSA2+SDS->(DS_FORNEC+DS_LOJA),"A2_NOME")
EndIf

Return(cNomeFC)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CPNJPict   ºAutor ³Felipi Marques       º Data ³  06/25/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Retorna a picture de acordo com o tipo do fornecedor/cliente.º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CPNJPict()
Local cAlias := If(SDS->DS_TIPO $ "DB","SA1","SA2")
Return PicPes(Posicione(cAlias,1,xFilial(cAlias)+M->(DS_FORNEC+DS_LOJA),Substr(cAlias,2)+"_TIPO"))

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  | NFORIValid º  Autor ³Felipi Marques         º Data ³  06/25/15   º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao | Valida o preenchimento da NF de Origem quando a nota for Dev/Comp³±±   
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±     
±±³Retorno   ³ lRet                                    							³±±    
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±       
±±³ Uso      ³      	                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±       
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±      
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function NFORIValid()
Local lRet 	   	 := .T.
Local cCampo   	 := ReadVar() 
Local aAreaSF2	:= SF2->(GetArea())
Local aAreaSD2	:= SD2->(GetArea())
Local aAreaSF1	:= SF1->(GetArea())
Local aAreaSD1	:= SD1->(GetArea())
Local cFilSD1		:= xFilial("SD1")
Local cFilSD2		:= xFilial("SD2")
Local cFilSF1		:= xFilial("SF1")
Local cFilSF2		:= xFilial("SF2")

If SDS->DS_TIPO == "D"
	SF2->(dbSetOrder(1))
	If cCampo == "M->DT_NFORI" .And. !Empty(AllTrim(M->DT_NFORI))
		If !SF2->(dbSeek(cFilSF2+M->DT_NFORI))
			Aviso("Atenção","",{"OK"})
			lRet := .F.
		Else   
			aCols[n,GdFieldPos("DT_SERIORI")] := CriaVar("DT_SERIORI",.F.)
			aCols[n,GdFieldPos("DT_ITEMORI")] := CriaVar("DT_ITEMORI",.F.)
		EndIf
	ElseIf cCampo == "M->DT_SERIORI"
		If !Empty(AllTrim(M->DT_SERIORI))
			If Empty(AllTrim(aCols[n,GdFieldPos("DT_NFORI")]))
				Aviso("Atenção","",{"OK"})
				lRet := .F.
			ElseIf !Empty(AllTrim(aCols[n,GdFieldPos("DT_NFORI")]))
				If !SF2->(dbSeek(cFilSF2+aCols[n,GdFieldPos("DT_NFORI")]+M->DT_SERIORI))
					Aviso("Atenção","",{"OK"})
					lRet := .F.
				EndIf
			EndIf
		EndIf
	ElseIf cCampo == "M->DT_ITEMORI"
		If !Empty(AllTrim(M->DT_ITEMORI))
			If Val(M->DT_ITEMORI) > 0
				M->DT_ITEMORI := PADL(Val(M->DT_ITEMORI),2,"0")
			EndIf
			If Empty(AllTrim(aCols[n,GdFieldPos("DT_NFORI")]))
				Aviso("Atenção","",{"OK"})
				lRet := .F.
			ElseIf !Empty(AllTrim(aCols[n,GdFieldPos("DT_NFORI")]))
				DbSelectArea("SF2")
				DbSetOrder(1)
				MsSeek(cFilSF2+aCols[n,GdFieldPos("DT_NFORI")]+aCols[n,GdFieldPos("DT_SERIORI")] )
	
				dbSelectArea("SD2")
				dbSetOrder(3)
				If !MsSeek(cFilSD2+aCols[n,GdFieldPos("DT_NFORI")]+aCols[n,GdFieldPos("DT_SERIORI")]+SF2->F2_CLIENTE+SF2->F2_LOJA+aCols[n,GdFieldPos("DT_COD")]+M->DT_ITEMORI)
					Aviso("Atenção","",{"OK"})
					lRet := .F.
				EndIf
			EndIf
		EndIf
	EndIf
ElseIf SDS->DS_TIPO == "C"
	SF1->(dbSetOrder(1))
	If cCampo == "M->DT_NFORI" .And. !Empty(AllTrim(M->DT_NFORI))
		If !SF1->(dbSeek(cFilSF1+M->DT_NFORI))
			Aviso("Atenção","",{"OK"})
			lRet := .F.
		Else   
			aCols[n,GdFieldPos("DT_SERIORI")] := CriaVar("DT_SERIORI",.F.)
			aCols[n,GdFieldPos("DT_ITEMORI")] := CriaVar("DT_ITEMORI",.F.)
		EndIf
	ElseIf cCampo == "M->DT_SERIORI"
		If !Empty(AllTrim(M->DT_SERIORI))
			If Empty(AllTrim(aCols[n,GdFieldPos("DT_NFORI")]))
				Aviso("Atenção","",{"OK"})
				lRet := .F.
			ElseIf !Empty(AllTrim(aCols[n,GdFieldPos("DT_NFORI")]))
				If !SF1->(dbSeek(cFilSF1+aCols[n,GdFieldPos("DT_NFORI")]+M->DT_SERIORI))
					Aviso("Atenção","",{"OK"})
					lRet := .F.
				EndIf
			EndIf
		EndIf
	ElseIf cCampo == "M->DT_ITEMORI"
		If !Empty(AllTrim(M->DT_ITEMORI))
			If Empty(AllTrim(aCols[n,GdFieldPos("DT_NFORI")]))
				Aviso("Atenção","",{"OK"})
				lRet := .F.
			ElseIf !Empty(AllTrim(aCols[n,GdFieldPos("DT_NFORI")]))
				DbSelectArea("SF1")
				DbSetOrder(1)
				MsSeek(cFilSF1+aCols[n,GdFieldPos("DT_NFORI")]+aCols[n,GdFieldPos("DT_SERIORI")] )
	
				dbSelectArea("SD1")
				dbSetOrder(1)
				If !MsSeek(cFilSD1+aCols[n,GdFieldPos("DT_NFORI")]+aCols[n,GdFieldPos("DT_SERIORI")]+SF1->F1_FORNECE+SF1->F1_LOJA+aCols[n,GdFieldPos("DT_COD")]+M->DT_ITEMORI)
					Aviso("Atenção","",{"OK"})
					lRet := .F.
				EndIf
			EndIf
		EndIf
	EndIf
EndIf

RestArea(aAreaSD1)
RestArea(aAreaSF1)
RestArea(aAreaSD2)
RestArea(aAreaSF2)

Return (lRet)

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³TudoOk ³ ºAutor ³Felipi Marques     º Data ³  06/25/15   º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Rotina de avaliacao TudOk                                    ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL1: .T. -> Linha valida                                   ³±±
±±³          ³       .F. -> Linha invalida                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Esta rotina tem como objetivo efetuar a validacao das        ³±±
±±³          ³linhas da getdados para a rotina de atualizacao do registro  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Materiais                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function xTudoOk()

Local nPosNfOri	:= aScan(aHeader,{|x| AllTrim(x[2])=="DT_NFORI"})
Local nPosSerOri:= aScan(aHeader,{|x| AllTrim(x[2])=="DT_SERIORI"})
Local nPosItOri	:= aScan(aHeader,{|x| AllTrim(x[2])=="DT_ITEMORI"})
Local nPosCod	:= aScan(aHeader,{|x| AllTrim(x[2])=="DT_COD"})
Local nPosQtd	:= aScan(aHeader,{|x| AllTrim(x[2])=="DT_QUANT"})
Local nPosVUni	:= aScan(aHeader,{|x| AllTrim(x[2])=="DT_VUNIT"})
Local nPosItem	:= aScan(aHeader,{|x| AllTrim(x[2])=="DT_ITEM"})
Local aAreaSF2	:= SF2->(GetArea())
Local aAreaSD2	:= SD2->(GetArea())
Local aAreaSF1	:= SF1->(GetArea())
Local aAreaSD1	:= SD1->(GetArea())
Local lRet		:= .T.
Local nX		:= 0
Local nCont		:= 0
Local cFilSD2	:= xFilial("SD2")
Local cFilSF2	:= xFilial("SF2")

If SDS->DS_TIPO == "D"		// Nota de Devolução
	For nX := 1 To Len(aCols)
		If !Empty(AllTrim(aCols[nX][nPosNfOri]))
			If Empty(AllTrim(aCols[nX][nPosItOri]))
				Aviso("Atenção",""+aCols[nX][nPosItem]+"",{"OK"})
				lRet := .F.
				nCont++
				Exit
			Else
				DbSelectArea("SF2")
				DbSetOrder(1)
				MsSeek(cFilSF2+aCols[nX][nPosNfOri]+aCols[nX][nPosSerOri] )
	
				dbSelectArea("SD2")
				dbSetOrder(3)
				If MsSeek(cFilSD2+aCols[nX][nPosNfOri]+aCols[nX][nPosSerOri]+SF2->F2_CLIENTE+SF2->F2_LOJA+aCols[nX][nPosCod]+aCols[nX][nPosItOri])
					If SD2->D2_QUANT < aCols[nX][nPosQtd]
						Aviso("Atenção","Item: "+aCols[nX][nPosItem],{"OK"})
						lRet := .F.
						nCont++
						Exit
					EndIf
				Else
					Aviso("Atenção","Item: "+aCols[nX][nPosItem]+"",{"OK"})
					lRet := .F.
					nCont++
					Exit
				EndIf
			EndIf
		nCont++
		ElseIf !Empty(AllTrim(aCols[nX][nPosSerOri])) .Or. !Empty(AllTrim(aCols[nX][nPosItOri]))
			Aviso("Atenção","Item: "+aCols[nX][nPosItem]+"",{"OK"})
		EndIf
	Next nX
EndIf

RestArea(aAreaSD1)
RestArea(aAreaSF1)
RestArea(aAreaSD2)
RestArea(aAreaSF2)

Return(lRet)

/*/ 
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³VincMultPC ³ ºAutor ³Felipi Marques     º Data ³  06/25/15   º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Rotina de avaliacao TudOk                                    ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL1: .T. -> Linha valida                                   ³±±
±±³          ³       .F. -> Linha invalida                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Esta rotina tem como objetivo efetuar a validacao das        ³±±
±±³          ³linhas da getdados para a rotina de atualizacao do registro  ³±±
±±³          ³importado XML                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Materiais                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function VincMultPC(aPedidos,nSldPed,aColsBkp,cItem,nMultPC,lLastIt)

Local aAreaSDS	:= SDS->(GetArea())
Local nPosCod	:= aScan(aHeader,{|x| AllTrim(x[2]) == "DT_COD"})
Local nPosProdF	:= aScan(aHeader,{|x| AllTrim(x[2]) == "DT_PRODFOR"})
Local nPosDescF	:= aScan(aHeader,{|x| AllTrim(x[2]) == "DT_DESCFOR"})
Local nPosSerie	:= aScan(aHeader,{|x| AllTrim(x[2]) == "DT_SERIE"})
Local nPosValor	:= aScan(aHeader,{|x| AllTrim(x[2]) == "DT_VUNIT"})
Local nPosFrete	:= aScan(aHeader,{|x| AllTrim(x[2]) == "DT_VALFRE"})
Local nPosSegur	:= aScan(aHeader,{|x| AllTrim(x[2]) == "DT_SEGURO"})
Local nPosDesp	:= aScan(aHeader,{|x| AllTrim(x[2]) == "DT_DESPESA"})
Local nPosDesc	:= aScan(aHeader,{|x| AllTrim(x[2]) == "DT_VALDESC"})
Local nPosTot	:= aScan(aHeader,{|x| AllTrim(x[2]) == "DT_TOTAL"})
Local nFrete	:= 0
Local nSeguro	:= 0
Local nDespesa	:= 0
Local nDesconto	:= 0
Local nValTotal	:= 0
Local nTotalNf	:= 0
Local nX		:= 0
Local nY		:= 0

Default lLastIt := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria aCols recebendo a quantidade dos pedidos                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aadd(aCols,Array(Len(aHeader)+1))
	For nX := 1 to Len(aHeader)
		If IsHeadRec(aHeader[nX][2])
		    aCols[Len(aCols)][nX] := 0
		ElseIf IsHeadAlias(aHeader[nX][2])
		    aCols[Len(aCols)][nX] := "SDT"
		ElseIf Trim(aHeader[nX][2]) == "DT_ITEM"
			aCols[Len(aCols)][nX] 	:= IIF(cItem<>Nil,cItem,StrZero(1,Len(SDT->DT_ITEM)))
		Else
			aCols[Len(aCols)][nX] := CriaVar(aHeader[nX][2], (aHeader[nX][10] <> "V") )
		EndIf
		aCols[Len(aCols)][Len(aHeader)+1] := .F.
	Next nX
	nItem := Len(aCols)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Apura valor das despesas acessorias para ratear entre os itens   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nMultPC == 1		// Vinculo por item, retorna o valor somente do item
	nFrete		:= aColsBkp[N][nPosFrete]
	nSeguro		:= aColsBkp[N][nPosSegur]
	nDespesa	:= aColsBkp[N][nPosDesp]
	nDesconto	:= aColsBkp[N][nPosDesc]
	nTotalNf	:= aColsBkp[N][nPosTot]
ElseIf nMultPC == 2	// Vinculo por documento, retorna o valor total
	For nX := 1 To Len(aColsBkp)
		nFrete		+= aColsBkp[nX][nPosFrete]
		nSeguro		+= aColsBkp[nX][nPosSegur]
		nDespesa	+= aColsBkp[nX][nPosDesp]
		nDesconto	+= aColsBkp[nX][nPosDesc]
	Next nX
	nTotalNf  := SDS->DS_VALMERC
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Calculo do valor total							             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nValTotal := NoRound((aColsBkp[N][nPosValor]*nSldPed),TamSX3("DT_TOTAL")[2])

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualiza o acols com base no pedido de compras               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nY := 1 To Len(aHeader)
	Do Case
	Case Trim(aHeader[nY,2]) == "DT_COD"
		aCols[nItem,nY] := If(lLastIt,aColsBkp[N][nPosCod],SC7->C7_PRODUTO)
	Case Trim(aHeader[nY,2]) == "DT_DESC"
		aCols[nItem,nY] := If(lLastIt,Posicione("SB1",1,xFilial("SB1")+aColsBkp[N][nPosCod],"B1_DESC"),SC7->C7_DESCRI)
	Case Trim(aHeader[nY,2]) == "DT_PRODFOR"
		aCols[nItem,nY] := aColsBkp[N][nPosProdF]
	Case Trim(aHeader[nY,2]) == "DT_DESCFOR"
		aCols[nItem,nY] := aColsBkp[N][nPosDescF]
	Case Trim(aHeader[nY,2]) == "DT_SERIE"
		aCols[nItem,nY] := aColsBkp[N][nPosSerie]
	Case Trim(aHeader[nY,2]) == "DT_QUANT"
		aCols[nItem,nY] := nSldPed
	Case Trim(aHeader[nY,2]) == "DT_VUNIT"
		aCols[nItem,nY] := aColsBkp[N][nPosValor]
	Case Trim(aHeader[nY,2]) == "DT_TOTAL"
		aCols[nItem,nY] := nValTotal
	Case Trim(aHeader[nY,2]) == "DT_PEDIDO"
		aCols[nItem,nY] := If(lLastIt,CriaVar("DT_PEDIDO",.F.),SC7->C7_NUM)
	Case Trim(aHeader[nY,2]) == "DT_ITEMPC"
		aCols[nItem,nY] := If(lLastIt,CriaVar("DT_ITEMPC",.F.),SC7->C7_ITEM)
	Case Trim(aHeader[nY,2]) == "DT_VALFRE"
		aCols[nItem,nY] := (nFrete / nTotalNf) * nValTotal
	Case Trim(aHeader[nY,2]) == "DT_SEGURO"
		aCols[nItem,nY] := (nSeguro / nTotalNf) * nValTotal
	Case Trim(aHeader[nY,2]) == "DT_DESPESA"
		aCols[nItem,nY] := (nDespesa / nTotalNf) * nValTotal
	Case Trim(aHeader[nY,2]) == "DT_VALDESC"
		aCols[nItem,nY] := (nDesconto / nTotalNf) * nValTotal
	EndCase
Next nY

RestArea(aAreaSDS)

Return 

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ComXGetAnt³ ºAutor ³Felipi Marques      º Data ³  06/25/15   º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Esta rotina tem como objetivo retornare a GetDados ao        ³±±
±±³          ³seu estado anterior ao clicar no botão cancelar no vínculo   ³±±
±±³          ³de documentos                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Materiais                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function ComXGetAnt(aColsAnt)

If SDS->DS_TIPO == "D"		// Nota de Devolução
	aCols := aClone(aColsAnt)
EndIf

Return

/*/ 
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ComXItOri ³ ºAutor ³Felipi Marques      º Data ³  06/25/15   º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Esta rotina tem como objetivo retornar os itens originais    ³±±
±±³          ³do documento                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Materiais                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function ComXItOri(aColsAnt)

Local nQuery := ""
Local cAliasTmp	:= "SDTTMP"
Local aStruSDT := {}
Local aColsOri := {}
Local nX := 0
Local nY := 0
Local nItem := 0

	// Pesquisa pelos itens originais que estejam deletados e marcados com o campo DT_ORIGEM, 
	//  pois podem ter sido substituidos na confirmacao do vinculo por multiplos pedidos
	// Caso a operacao de vinculo por multiplos pedidos nao tenha sido concluida e nao encontre registros deletados,
	//  retorna o aColsAnt

	#IFDEF TOP
		cQuery := "SELECT DT_ITEM, DT_COD, DT_PRODFOR, DT_DESCFOR, "
		cQuery += "DT_QUANT, DT_VUNIT, DT_TOTAL, DT_PEDIDO, DT_ITEMPC, "
		cQuery += "DT_VALFRE, DT_SEGURO, DT_DESPESA, DT_VALDESC "
		cQuery += " FROM " +RetSqlName("SDT") +" SDT"
		cQuery += " WHERE DT_FILIAL = '" +xFilial("SDT") + "' "
		cQuery += " AND DT_FORNEC = '" +SDS->DS_FORNEC + "' AND DT_LOJA = '" +SDS->DS_LOJA + "'" 
		cQuery += " AND DT_DOC = '" +SDS->DS_DOC + "' AND DT_SERIE = '" +SDS->DS_SERIE + "'" 
		cQuery += " AND DT_ORIGIN = '1' AND D_E_L_E_T_ = '*' "
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),cAliasTmp,.T.,.T.)
	#ELSE
		aStruSDT := {}
		aAdd(aStruSDT,{"DT_ITEM","C",TamSX3("DT_ITEM")[1],0})
		aAdd(aStruSDT,{"DT_COD","C",TamSX3("DT_COD")[1],0})
		aAdd(aStruSDT,{"DT_DESC","C",TamSX3("DT_DESC")[1],0})
		aAdd(aStruSDT,{"DT_PRODFOR","C",TamSX3("DT_PRODFOR")[1],0})
		aAdd(aStruSDT,{"DT_DESCFOR","C",TamSX3("DT_DESCFOR")[1],0})
		aAdd(aStruSDT,{"DT_QUANT","N",TamSX3("DT_QUANT")[1],TamSX3("DT_QUANT")[2]})
		aAdd(aStruSDT,{"DT_VUNIT","N",TamSX3("DT_VUNIT")[1],TamSX3("DT_VUNIT")[2]})
		aAdd(aStruSDT,{"DT_TOTAL","N",TamSX3("DT_TOTAL")[1],TamSX3("DT_TOTAL")[2]})
		aAdd(aStruSDT,{"DT_PEDIDO","C",TamSX3("DT_PEDIDO")[1],0})
		aAdd(aStruSDT,{"DT_ITEMPC","C",TamSX3("DT_ITEMPC")[1],0})
		aAdd(aStruSDT,{"DT_VALFRE","N",TamSX3("DT_VALFRE")[1],TamSX3("DT_VALFRE")[2]})
		aAdd(aStruSDT,{"DT_SEGURO","N",TamSX3("DT_SEGURO")[1],TamSX3("DT_SEGURO")[2]})
		aAdd(aStruSDT,{"DT_DESPESA","N",TamSX3("DT_DESPESA")[1],TamSX3("DT_DESPESA")[2]})
		aAdd(aStruSDT,{"DT_VALDESC","N",TamSX3("DT_VALDESC")[1],TamSX3("DT_VALDESC")[2]})
		cAliasTmp := CriaTrab(aStruSDT, .T.)
		dbUseArea(.T.,,cAliasTmp,cAliasTmp,.F.,.F.)

		SET DELETED OFF
		SDT->(dbSetOrder(2))
		If SDT->(MsSeek(xFilial("SDT")+SDS->(DS_FORNEC+DS_LOJA+DS_DOC+DS_SERIE)))
			While SDT->(!EOF()) .And. xFilial("SDT")+SDT->(DT_FORNEC+DT_LOJA+DT_DOC+DT_SERIE) == xFilial("SDS")+SDS->(DS_FORNEC+DS_LOJA+DS_DOC+DS_SERIE)
				If SDT->DT_ORIGIN = "1"
					RecLock(cAliasTmp,.T.)
					(cAliasTmp)->DT_ITEM   	 := SDT->DT_ITEM
		  			(cAliasTmp)->DT_COD   	 := SDT->DT_COD
		  			(cAliasTmp)->DT_DESC  	 := Posicione("SB1",1,xFilial("SB1")+SDT->DT_COD,"B1_DESC")
					(cAliasTmp)->DT_PRODFOR	 := SDT->DT_PRODFOR
			  		(cAliasTmp)->DT_DESCFOR	 := SDT->DT_DESCFOR
			  		(cAliasTmp)->DT_QUANT	 := SDT->DT_QUANT
			  		(cAliasTmp)->DT_VUNIT	 := SDT->DT_VUNIT
			  		(cAliasTmp)->DT_TOTAL	 := SDT->DT_TOTAL
			  		(cAliasTmp)->DT_PEDIDO	 := SDT->DT_PEDIDO
			  		(cAliasTmp)->DT_ITEMPC	 := SDT->DT_ITEMPC
			  		(cAliasTmp)->DT_VALFRE	 := SDT->DT_VALFRE
			  		(cAliasTmp)->DT_SEGURO	 := SDT->DT_SEGURO
			  		(cAliasTmp)->DT_DESPESA	 := SDT->DT_DESPESA
			  		(cAliasTmp)->DT_VALDESC	 := SDT->DT_VALDESC
					(cAliasTmp)->(MsUnLock())
				EndIf
				SDT->(DbSkip())
			EndDo
		EndIf	  	
		SET DELETED ON
	#ENDIF

	// Se nao encontrou itens originais como deletados, retorna array aColsAnt
	(cAliasTmp)->(dbGoTop())	
	If (cAliasTmp)->(Eof())
		aCols := aColsAnt
	Else
		While (cAliasTmp)->(!Eof())
			// Cria aColsOri para receber os itens originais
			aadd(aColsOri,Array(Len(aHeader)+1))
			For nX := 1 to Len(aHeader)
				If IsHeadRec(aHeader[nX][2])
				    aColsOri[Len(aColsOri)][nX] := 0
				ElseIf IsHeadAlias(aHeader[nX][2])
				    aColsOri[Len(aColsOri)][nX] := "SDT"
				Else
					aColsOri[Len(aColsOri)][nX] := CriaVar(aHeader[nX][2], (aHeader[nX][10] <> "V") )
				EndIf
				aColsOri[Len(aColsOri)][Len(aHeader)+1] := .F.
			Next nX
			nItem := Len(aColsOri)

			// Atualiza aColsOri de acordo com os itens originais retornados
			For nY := 1 To Len(aHeader)
				Do Case
				Case Trim(aHeader[nY,2]) == "DT_ITEM"
					aColsOri[nItem,nY] := (cAliasTmp)->DT_ITEM
				Case Trim(aHeader[nY,2]) == "DT_COD"
					aColsOri[nItem,nY] := (cAliasTmp)->DT_COD
				Case Trim(aHeader[nY,2]) == "DT_DESC"
					aColsOri[nItem,nY] := Posicione("SB1",1,xFilial("SB1")+(cAliasTmp)->DT_COD,"B1_DESC")
				Case Trim(aHeader[nY,2]) == "DT_PRODFOR"
					aColsOri[nItem,nY] := (cAliasTmp)->DT_PRODFOR
				Case Trim(aHeader[nY,2]) == "DT_DESCFOR"
					aColsOri[nItem,nY] := (cAliasTmp)->DT_DESCFOR
				Case Trim(aHeader[nY,2]) == "DT_SERIE"
					aColsOri[nItem,nY] := SDS->DS_SERIE
				Case Trim(aHeader[nY,2]) == "DT_QUANT"
					aColsOri[nItem,nY] := (cAliasTmp)->DT_QUANT
				Case Trim(aHeader[nY,2]) == "DT_VUNIT"
					aColsOri[nItem,nY] := (cAliasTmp)->DT_VUNIT
				Case Trim(aHeader[nY,2]) == "DT_TOTAL"
					aColsOri[nItem,nY] := (cAliasTmp)->DT_TOTAL
				Case Trim(aHeader[nY,2]) == "DT_PEDIDO"
					aColsOri[nItem,nY] := (cAliasTmp)->DT_PEDIDO
				Case Trim(aHeader[nY,2]) == "DT_ITEMPC"
					aColsOri[nItem,nY] := (cAliasTmp)->DT_ITEMPC
				Case Trim(aHeader[nY,2]) == "DT_VALFRE"
					aColsOri[nItem,nY] := (cAliasTmp)->DT_VALFRE
				Case Trim(aHeader[nY,2]) == "DT_SEGURO"
					aColsOri[nItem,nY] := (cAliasTmp)->DT_SEGURO
				Case Trim(aHeader[nY,2]) == "DT_DESPESA"
					aColsOri[nItem,nY] := (cAliasTmp)->DT_DESPESA
				Case Trim(aHeader[nY,2]) == "DT_VALDESC"
					aColsOri[nItem,nY] := (cAliasTmp)->DT_VALDESC
				EndCase
			Next nY
			(cAliasTmp)->(dbSkip())
		EndDo
		If Len(aColsOri) > 0
			aCols := aColsOri
		EndIf
	EndIf
	(cAliasTmp)->(dbCloseArea())

Return 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³COMXCOLImp ºAutor ³Felipi Marques      º Data ³  06/25/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Funcao que realiza a importacao de um arquivo XML          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ cFile: caminho do arquivo que esta sendo importado.		  º±±
±±º			 ³ lJob: indica se o processamento esta sendo fendo em job.	  º±±
±±º			 ³ aProc: array para guardar os arquivos processados (M-Mess).º±±
±±º			 ³ aErros: array para guardar os arquivos com erros (M-Mess). º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ lRet: indica se a importacao foi realizada.				  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function COMxXMLImp(cFile,lJob,aProc,aErros) 

Local lRet 	   := .T.
Local cError   := ""
Local cWarning := ""
Local oFullXml := NIL
Local cXMLOri  := ""
Local cXMLEncod:= ""
Local nHandle  := 0
Local nLength  := 0
Local nNFeAut  := SuperGetMV("MV_COMCOL1",.F.,0)

nHandle := FOpen(DIRXML +DIRALER +cFile)
nLength := FSeek(nHandle,0,FS_END)
FSeek(nHandle,0)
If nHandle > 0
	FRead(nHandle, cXMLOri, nLength)
	FClose(nHandle)
	If !Empty(cXMLOri)
		If SubStr(cXMLOri,1,1) != "<"
			nPosPesq := At("<",cXMLOri)
			cXMLOri  := SubStr(cXMLOri,nPosPesq,Len(cXMLOri))		// Remove caracteres estranhos antes da abertura da tag inicial do arquivo
		EndIf
	EndIf
	cXMLEncod := EncodeUtf8(cXMLOri)
	// Verifica se o encode ocorreu com sucesso, pois alguns caracteres especiais provocam erro na funcao de encode, neste caso e feito o tratamento pela funcao A140IRemASC
	If Empty(cXMLEncod)
		cStrXML := cXMLOri
		cXMLOri := A140IRemASC(cStrXML)
		cXMLEncod := EncodeUtf8(cXMLOri)
	EndIf
	If Empty(cXMLEncod)
		cXMLEncod := cXMLOri
	EndIf
EndIf

If !Empty(cXMLEncod)
	oFullXML := XmlParser(cXMLEncod,"_",@cError,@cWarning)
EndIf
If !File(DIRXML +DIRALER +cFile)
	If lJob
		aAdd(aErros,{cFile,"Arquivo inexistente.","Não se aplica."}) 
	Else
		Aviso("Erro","Arquivo" +cFile +"inexistente",{"OK"},2,"COMXCOMImp") 
	EndIf
	lRet := .F.
ElseIf !Empty(cError) //-- Erro na sintaxe do XML
	If lJob
		aAdd(aErros,{cFile,"Erro de sintaxe no arquivo XML:" +cError,"Entre em contato com o emissor do documento e comunique a ocorrência."}) 
	Else
		Aviso("Erro",cError,{"OK"},2,"COMXCOMImp") //-- Erro
	EndIf
	lRet := .F.
Else //-- Direciona processamento conforme tipo de documento
	If ValType(oFullXML)=="O"
		Do Case
			Case ValType(XmlChildEx(oFullXML,"_NFEPROC")) == "O" 
			    //-- Nota normal, devolucao, beneficiamento, bonificacao
				lRet := U_ACOMR07(cFile,lJob)        
			//Case ValType(XmlChildEx(oFullXML,"_CTE")) == "O" //-- Nota de transporte
				//Verifica se há integração com o Frete Embarcador
			///	lRet := ImpXML_CTe(cFile,lJob,@aProc,@aErros,oFullXml:_CTe)
		  //	Case ValType(XmlChildEx(oFullXML,"_CTEPROC")) == "O" //-- Nota de transporte
		   //	    //Verifica se há integração com o Frete Embarcador
		   //		lRet := ImpXML_CTe(cFile,lJob,@aProc,@aErros,oFullXml:_CTeProc:_Cte)
		  //	Case ValType(XmlChildEx(oFullXML,"_INVOIC_NFE_COMPL")) == "O" //-- Nota Fiscal Complementar
		  //		lRet := ImpXML_Ave(cFile,lJob,@aProc,@aErros,oFullXml:_INVOIC_NFE_COMPL)
		  //	Case ValType(XmlChildEx(oFullXML:_TOTVSMESSAGE:_BUSINESSMESSAGE:_BUSINESSCONTENT,"_PROCNEOGRIDNFSE")) == "O" // Nota de Servico
		 //		lRet := ImpXML_NFs(cFile,lJob,@aProc,@aErros,oFullXml:_TOTVSMESSAGE:_BUSINESSMESSAGE:_BUSINESSCONTENT:_PROCNEOGRIDNFSE)
		EndCase
	EndIf
	//If lRet .And. (nNFeAut == 1 .Or. nNFeAut == 2)
	//	ProcDocs(SDS->(Recno()),.T.)      	
	//EndIf
EndIf

Return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} ConvASC()
Função para conversão de caracteres com acento.
@author jose.delmondes	
@since 14/07/2014
@version P11.8
@return cStrXML - Xml com caracteres substituidos
/*/
//-------------------------------------------------------------------
User Function ConvASC(cStrXML)

cStrXML := StrTran(cStrXML, CHR(199), CHR(67)) 	//Substitui Ç por C
cStrXML := StrTran(cStrXML, CHR(231), CHR(99))	//Substitui ç por c
cStrXML := StrTran(cStrXML, CHR(195), CHR(65))	//Substitui Ã por A
cStrXML := StrTran(cStrXML, CHR(192), CHR(65))	//Substitui À por A
cStrXML := StrTran(cStrXML, CHR(193), CHR(65))	//Substitui Á por A
cStrXML := StrTran(cStrXML, CHR(227), CHR(97))	//Substitui ã por a
cStrXML := StrTran(cStrXML, CHR(225), CHR(97))	//Substitui á por a
cStrXML := StrTran(cStrXML, CHR(224), CHR(97))  //Substitui à por a 
cStrXML := StrTran(cStrXML, CHR(201), CHR(69))	//Substitui É por E
cStrXML := StrTran(cStrXML, CHR(233), CHR(101))	//Substitui é por e
cStrXML := StrTran(cStrXML, CHR(205), CHR(73))	//Substitui Í por Í
cStrXML := StrTran(cStrXML, CHR(237), CHR(105))	//Substitui í por í
cStrXML := StrTran(cStrXML, CHR(211), CHR(79))	//Substitui Ó por O
cStrXML := StrTran(cStrXML, CHR(213), CHR(79))	//Substitui Õ por O
cStrXML := StrTran(cStrXML, CHR(245), CHR(111))	//Substitui õ por o
cStrXML := StrTran(cStrXML, CHR(243), CHR(111))	//Substitui ó por o
cStrXML := StrTran(cStrXML, CHR(218), CHR(85))	//Substitui Ú por U
cStrXML := StrTran(cStrXML, CHR(250), CHR(117))	//Substitui ú por u

Return cStrXML

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Inclui_fornecedor ºAutor  ³Felipi Marques º Data³ 08/11/14  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Inclui fornecedor                                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function Inclui_fornecedor()

Local cCepT 	:= ""
Local cRecpis	:= ""
Local cRecCof	:= ""
Local cRecCsl	:= ""
Local cCalcIR	:= ""
Local GRTRIB	:= ""
Local cEstado   := ""
Local cGRTRIB   := ""
Local CCOMPLEM  := ""
Local cPessoa   := ""
Local aDestFor  := {}
Local lRet      := .F.
DbSelectarea('SA2')

nOpc := 3
cCod := Getsxenum('SA2','A2_COD')
cLoja:= '01'
cEstado := oXML:_INFNFE:_DEST:_ENDERDEST:_UF:TEXT	
If cEstado == "EX" 
	cCepT := "00000000"
	cRecpis:="2"
	cRecCof   :="2"
	cRecCsl    :="2"
	cCalcIR    :="1"
	cGRTRIB    :="001"
	cCEP 	   :='' 
	cPessoa	   :="X"
	cNOME      := UPPER(oXML:_INFNFE:_DEST:_XNOME:TEXT)
	cNREDUZ    := UPPER(oXML:_INFNFE:_DEST:_XNOME:TEXT)
	cEND       := UPPER(oXML:_INFNFE:_DEST:_ENDERDEST:_XLGR:TEXT)
	cNUM       := UPPER(oXML:_INFNFE:_DEST:_ENDERDEST:_NRO:TEXT)
	cBAIRRO    := UPPER(oXML:_INFNFE:_DEST:_ENDERDEST:_XBAIRRO:TEXT)
	cMUN       := UPPER(oXML:_INFNFE:_DEST:_ENDERDEST:_XMUN:TEXT)
	cINSCR     := ""
	cCOD_MUN   := "99999"
	cCEP       := "99999999"
Else
	cNOME      := UPPER(oXML:_INFNFE:_EMIT:_XNOME:TEXT)
	cNREDUZ    := UPPER(oXML:_INFNFE:_EMIT:_XNOME:TEXT)
	cEND       := UPPER(oXML:_INFNFE:_EMIT:_ENDEREMIT:_XLGR:TEXT)
	cNUM       := UPPER(oXML:_INFNFE:_EMIT:_ENDEREMIT:_NRO:TEXT)
	cBAIRRO    := UPPER(oXML:_INFNFE:_EMIT:_ENDEREMIT:_XBAIRRO:TEXT)
	cMUN       := UPPER(oXML:_INFNFE:_EMIT:_ENDEREMIT:_XMUN:TEXT)
	cINSCR     := UPPER(oXML:_INFNFE:_EMIT:_IE:TEXT)
	cCOD_MUN   := SUBSTR(oXML:_INFNFE:_EMIT:_ENDEREMIT:_CMUN:TEXT,3,5)
	cCGC       := UPPER(oXML:_INFNFE:_EMIT:_CNPJ:TEXT) 
	cCEP       := UPPER(oXML:_INFNFE:_EMIT:_ENDEREMIT:_CEP:TEXT)
EndIf


if val(cNUM) # 0 // Se numero for valido, sera inserido no endereco, caso contrario sera inserido no complemento
	cEND := STRTRAN(cEND,",",".")
	cEND += ", "+cNUM
else
	cCOMPLEM := cNUM
endif

cTIPO      := IF(LEN(cCGC)=11,'F','J')

DbSelectarea('SA2')

If RecLock("SA2",.T.)
	SA2->A2_FILIAL	:=  xFilial("SA2")    
	SA2->A2_COD		:=  cCod    
	SA2->A2_LOJA	:=  cLoja   
	SA2->A2_TPESSOA	:= 	cPessoa 
	SA2->A2_CGC		:=  cCGC    
	SA2->A2_CEP		:=  cCEP    
	SA2->A2_EST		:=  cESTADO   
	SA2->A2_COD_MUN	:=  cCOD_MUN 
	SA2->A2_END		:=  cEND    
	SA2->A2_BAIRRO	:=  cBAIRRO 
	SA2->A2_MUN		:=  cMUN    
	SA2->A2_COMPLEM	:=  cCOMPLEM
	SA2->A2_INSCR	:=  cINSCR  
	SA2->A2_NOME	:=  cNOME   
	SA2->A2_NREDUZ	:=  cNREDUZ 
	SA2->A2_TIPO	:=  cTIPO   	
	
	MsUnLock()
	lRet := .T.
	ConfirmSx8()

Else
	RollBackSx8()
EndIf

Return(lRet)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³inclui_cliente ºAutor  ³Felipi Marques º Data ³  08/11/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Inclusao de cliente                                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static function inclui_cliente() 

Local cEstado   := ""
Local aDestFornecedor := {}
Local cNOME := UPPER(IIF(UPPER(oAuxXML:REALNAME)=="NFEPROC",oXML:_NFEPROC,IIF(UPPER(oAuxXML:REALNAME)=="NFE",oXML,)):_INFNFE:_DEST:_XNOME:TEXT)
Local cEstado:=IIF(UPPER(oAuxXML:REALNAME)=="NFEPROC",oXML:_NFEPROC,IIF(UPPER(oAuxXML:REALNAME)=="NFE",oXML,)):_INFNFE:_DEST:_ENDERDEST:_UF:TEXT
Local lRet := .F.
	
DbSelectarea('SA1')
DBSETORDER(3)
cCod := ""
cNOME := UPPER(IIF(UPPER(oAuxXML:REALNAME)=="NFEPROC",oXML:_NFEPROC,IIF(UPPER(oAuxXML:REALNAME)=="NFE",oXML,)):_INFNFE:_DEST:_XNOME:TEXT)
cEstado:=IIF(UPPER(oAuxXML:REALNAME)=="NFEPROC",oXML:_NFEPROC,IIF(UPPER(oAuxXML:REALNAME)=="NFE",oXML,)):_INFNFE:_DEST:_ENDERDEST:_UF:TEXT
		
IF !(EMPTY(IIf(cEstado=="EX",cCGCDes,cCGC)))
	cCod := Getsxenum('SA1','A1_COD')
	cLoja:= '01'
EndIf

dbselectarea('CC2')
dbsetorder(2)
    	
if dbseek(xfilial('CC2')+SUBSTR( IIF(UPPER(oAuxXML:REALNAME)=="NFEPROC",oXML:_NFEPROC,IIF(UPPER(oAuxXML:REALNAME)=="NFE",oXML,)):_INFNFE:_DEST:_ENDERDEST:_CMUN:TEXT,3,5))
	cCOd_Mun:= SUBSTR( IIF(UPPER(oAuxXML:REALNAME)=="NFEPROC",oXML:_NFEPROC,IIF(UPPER(oAuxXML:REALNAME)=="NFE",oXML,)):_INFNFE:_DEST:_ENDERDEST:_CMUN:TEXT,3,5)		
Else
	cCOd_Mun:= ""
Endif

cINSCR := IIF(UPPER(oAuxXML:REALNAME)=="NFEPROC",oXML:_NFEPROC,IIF(UPPER(oAuxXML:REALNAME)=="NFE",oXML,)):_INFNFE:_DEST:_IE:TEXT 

IF UPPER( IIF(UPPER(oAuxXML:REALNAME)=="NFEPROC",oXML:_NFEPROC,IIF(UPPER(oAuxXML:REALNAME)=="NFE",oXML,)):_INFNFE:_DEST:_ENDERDEST:_UF:TEXT)=="RO" 
	cINSCR := STRZERO(val(cINSCR),14)
ENDIF
		        
dbselectarea('CC2')
dbCloseArea()
                                   
cPessoa :=""
if len(alltrim(IIf(cEstado=="EX",cCGCDes,cCGC)))==11
   cPessoa="F"
Else   
   cPessoa:="J"
endif
        
if cEstado == "EX"
	cPessoa := "J"
	cCepT   := "99999999"
else
	cCepT   := IIF(UPPER(oAuxXML:REALNAME)=="NFEPROC",oXML:_NFEPROC,IIF(UPPER(oAuxXML:REALNAME)=="NFE",oXML,)):_INFNFE:_DEST:_ENDERDEST:_CEP:TEXT
endif

If RecLock("SA1",.T.)
	SA1->A1_COD		:=	cCod          
	SA1->A1_LOJA	:=	UPPER(cLoja)
   	SA1->A1_CGC		:=	IIf(cEstado=="EX",cCGCDes,cCGC)     
   	SA1->A1_PESSOA	:=	cPessoa     
	SA1->A1_CEP		:=	cCepT
	SA1->A1_END		:=	UPPER( IIF(UPPER(oAuxXML:REALNAME)=="NFEPROC",oXML:_NFEPROC,IIF(UPPER(oAuxXML:REALNAME)=="NFE",oXML,)):_INFNFE:_DEST:_ENDERDEST:_XLGR:TEXT)
	SA1->A1_EST		:=	UPPER( IIF(UPPER(oAuxXML:REALNAME)=="NFEPROC",oXML:_NFEPROC,IIF(UPPER(oAuxXML:REALNAME)=="NFE",oXML,)):_INFNFE:_DEST:_ENDERDEST:_UF:TEXT)
	SA1->A1_BAIRRO	:=	UPPER( IIF(UPPER(oAuxXML:REALNAME)=="NFEPROC",oXML:_NFEPROC,IIF(UPPER(oAuxXML:REALNAME)=="NFE",oXML,)):_INFNFE:_DEST:_ENDERDEST:_XBAIRRO:TEXT)
	SA1->A1_COMPLEM	:=	UPPER( IIF(UPPER(oAuxXML:REALNAME)=="NFEPROC",oXML:_NFEPROC,IIF(UPPER(oAuxXML:REALNAME)=="NFE",oXML,)):_INFNFE:_DEST:_ENDERDEST:_XLGR:TEXT+", "+STRTRAN( IIF(UPPER(oAuxXML:REALNAME)=="NFEPROC",oXML:_NFEPROC,IIF(UPPER(oAuxXML:REALNAME)=="NFE",oXML,)):_INFNFE:_DEST:_ENDERDEST:_NRO:TEXT,",",".")) 
	SA1->A1_MUN		:=	UPPER( IIF(UPPER(oAuxXML:REALNAME)=="NFEPROC",oXML:_NFEPROC,IIF(UPPER(oAuxXML:REALNAME)=="NFE",oXML,)):_INFNFE:_DEST:_ENDERDEST:_XMUN:TEXT)
	SA1->A1_INSCR	:=	IIF(UPPER(oAuxXML:REALNAME)=="NFEPROC",oXML:_NFEPROC,IIF(UPPER(oAuxXML:REALNAME)=="NFE",oXML,)):_INFNFE:_DEST:_IE:TEXT 
	SA1->A1_NOME	:=	UPPER( IIF(UPPER(oAuxXML:REALNAME)=="NFEPROC",oXML:_NFEPROC,IIF(UPPER(oAuxXML:REALNAME)=="NFE",oXML,)):_INFNFE:_DEST:_XNOME:TEXT)
	SA1->A1_NREDUZ	:=	UPPER( IIF(UPPER(oAuxXML:REALNAME)=="NFEPROC",oXML:_NFEPROC,IIF(UPPER(oAuxXML:REALNAME)=="NFE",oXML,)):_INFNFE:_DEST:_XNOME:TEXT)
	SA1->A1_GRPTRIB	:=	'002'
	SA1->A1_TIPO	:=	'S'

	MsUnLock()
	lRet := .T.
	ConfirmSx8()

Else
	RollBackSx8()
EndIf

Return(lRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fornece_dupli ºAutor  ³Felipi Marques  º Data ³  06/25/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Analisa se exixte cnpj duplicado na base                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function  fornece_dupli(cCGC,cEstado)

Local nCount   := 1
Local lRet     := .F.
Local cQuery   := ""

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// |  MONTA QUERY   |
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQuery += " SELECT COUNT(*) TOTAL "
cQuery += " FROM " + RetSqlName("SA2") + " SA2 "
cQuery += " WHERE A2_CGC = '"+cCGC +"' AND D_E_L_E_T_ = ' ' AND A2_FILIAL = '"+xFilial("SA2")+"' AND A2_MSBLQL = '2' "  
cQuery := ChangeQuery(cQuery)
dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),"TMP", .T., .T.)   

TMP->(dbGoTop())
If !TMP->(Eof())
	If TMP->TOTAL > nCount 
		lRet := .T.
	EndIf
EndIf
TMP->(dbCloseArea())

Return(lRet)


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fMaqCid   ºAutor  ³Felipi Marques      º Data ³  06/27/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Selecionar ou Mostrar os Registros Selecionados           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function BuscaCLI(cCGC)

Local nTam			:= TamSX3("A2_COD")[1]+TamSX3("A2_LOJA")[1]+1
Local aCat	      	:= {}
Local cMvRet		  	:= SPACE( TamSX3("A2_COD")[1] + TamSX3("A2_LOJA")[1]+1 )
Local MvPar			:= ""
Local cTitulo		:= "CODIGO/LOJA   -  NOME FORNECEDOR"
Local MvParDef  	:= ""
Local cVolta		:= ""
Local cF3           := ""
Local cQuery        := ""                                            
Local aCliLj        := {}

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// |  MONTA QUERY   |
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQuery += " SELECT A2_COD+'/'+A2_LOJA AS A2_COD , A2_NOME AS A2_NOME"
cQuery += " FROM " + RetSqlName("SA2") + " SA2 "
cQuery += " WHERE A2_CGC = '"+cCGC+"' AND D_E_L_E_T_ = ' ' AND A2_FILIAL = '"+xFilial("SA2")+"' AND A2_MSBLQL = '2' "
cQuery := ChangeQuery(cQuery)


if select("TRC")>0
	TRC->(dbCloseArea())
endif

TCQuery cQuery ALIAS "TRC" NEW

If TRC->(!EOF())
	while ! TRC->(EOF())
		aadd(aCat,ALLTRIM(UPPER(TRC->A2_COD))+" - "+AllTrim(TRC->A2_NOME))
		MvParDef += TRC->A2_COD
		TRC->(dbSkip())
	end
Else
		MsgInfo("TABELA AC NAO CADASTRADA!")
EndIf

//----------------------------------------------------------------------
// Executa f_Opcoes para Selecionar ou Mostrar os Registros Selecionados
//----------------------------------------------------------------------
f_Opcoes(       @MvPar      ,;    //Variavel de Retorno
				cTitulo     ,;    //Titulo da Coluna com as opcoes
				@aCat       ,;    //Opcoes de Escolha (Array de Opcoes)
				@MvParDef   ,;    //String de Opcoes para Retorno
				NIL         ,;    //Nao Utilizado
				NIL         ,;    //Nao Utilizado
				.T.         ,;    //Se a Selecao sera de apenas 1 Elemento por vez
				nTam        ,;    //Tamanho da Chave
				Len(aCat)   ,;    //No maximo de elementos na variavel de retorno
				.T.         ,;    //Inclui Botoes para Selecao de Multiplos Itens
				.F.         ,;    //Se as opcoes serao montadas a partir de ComboBox de Campo ( X3_CBOX )
				NIL         ,;    //Qual o Campo para a Montagem do aOpcoes
				.F.         ,;    //Nao Permite a Ordenacao
				.F.         ,;    //Nao Permite a Pesquisa
				.T.         ,;    //Forca o Retorno Como Array
				cF3         ;    //Consulta F3
)

//Carregar array
If Len(MvPar) <> 0
	For i:=1 to Len(MvPar)
		cCliente :=  SubStr(MvPar[1], 1, RAt("/", MvPar[1]))
		cLoja    := AllTrim(SubStr(MvPar[1], RAt("/", MvPar[1])+1, TamSX3("A2_LOJA")[1] )) 
		//Trata para tirar o ultimo caracter
		If !Empty(cCliente)
			cCliente := SubStr(cCliente,1,Len(cCliente)-1)
		EndIf
		aadd(aCliLj, { cCliente,cLoja} )
	Next
EndIf

Return(aCliLj) 
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Danfe     ºAutor  ³Microsiga           º Data ³  09/28/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Impressao da Danfe                                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function Danfe()

Local nRegs    := 0
Local nRecno   := SDS->(Recno())
Local nQtdNF   := Len(aRegMark)
Local aAreaSDS := SDS->(GetArea())

If nQtdNF = 0 
	MsgInfo("Nao há nenhum registro selecionado")
    Return()
Endif

Processa({|| RecDanfe(nQtdNF),"Portal da Nota Fiscal EletrônicaL" +" - " +"Geração de Documentos"}) 
	
RestArea(aAreaSDS)
	
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³COMMI020  ºAutor  ³Microsiga           º Data ³  09/29/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RecDanfe(nRegs)

//Tela de apontamento de origem e destino
aRetTela := fOriDes()

//Fragmentando resultado da variavel
cPath       := aRetTela[1]
lProsiga    := aRetTela[2] 

If lProsiga
	ProcRegua(nRegs)
	For nY := 1 To nRegs
		SDS->(dbGoTo(aRegMark[nY]))
		U_RCOMR03(cPath)  
	Next nY
EndIf
	
Return        
//-----------------------------------------------------------------------
/*/{Protheus.doc} Exportar
Rotina de exportacao das notas
@author Felipi Marques
@since 15.06.2018
/*/
//-----------------------------------------------------------------------
Static Function Exportar()

Local aPerg   	 := {}
Local aParam  	 := {Space(Len(SDS->DS_SERIE)),Space(Len(SDS->DS_DOC)),Space(Len(SDS->DS_DOC)),Space(60),CToD(""),CToD(""),Space(14),Space(14)}  
Local lObrigat   := .T. 
Local cParNfeExp := SM0->M0_CODIGO+SM0->M0_CODFIL+"XMLNFEEXP"
Local cIdEnt     := ""

aadd(aPerg,{1,"Serie da Nota Fiscal",aParam[01],"",".T.","",".T.",30,.F.}) 
aadd(aPerg,{1,"Nota fiscal inicial",aParam[02],"",".T.","",".T.",30,lObrigat}) 
aadd(aPerg,{1,"Nota fiscal final",aParam[03],"",".T.","",".T.",30,lObrigat})
aadd(aPerg,{6,"Diretório de destino",aParam[04],"",".T.","!Empty(mv_par04)",80,.T.,"Arquivos XML |*.XML","",GETF_RETDIRECTORY+GETF_LOCALHARD,.T.})
aadd(aPerg,{1,"Data Inicial",aParam[05],"",".T.","",".T.",50,lObrigat}) 
aadd(aPerg,{1,"Data Final",aParam[06],"",".T.","",".T.",50,lObrigat})
aadd(aPerg,{1,"CNPJ Inicial",aParam[07],"",".T.","",".T.",50,.F.}) 
aadd(aPerg,{1,"CNPJ final",aParam[08],"",".T.","",".T.",50,.F.}) 


aParam[01] := ParamLoad(cParNfeExp,aPerg,1,aParam[01])
aParam[02] := ParamLoad(cParNfeExp,aPerg,2,aParam[02])
aParam[03] := ParamLoad(cParNfeExp,aPerg,3,aParam[03])
aParam[04] := ParamLoad(cParNfeExp,aPerg,4,aParam[04])
aParam[05] := ParamLoad(cParNfeExp,aPerg,5,aParam[05])
aParam[06] := ParamLoad(cParNfeExp,aPerg,6,aParam[06])

If ParamBox(aPerg,"",@aParam,,,,,,,cParNfeExp,.T.,.T.)
	Processa({|lEnd| fExpXml(cIdEnt,aParam[01],aParam[02],aParam[03],aParam[04],lEnd,aParam[05],IIF(Empty(aParam[06]),dDataBase,aParam[06]),aParam[07],aParam[08],,,)},"Processando","Aguarde, exportando arquivos",.F.)
EndIf                                                                    

//-----------------------------------------------------------------------
/*/{Protheus.doc} fExpXml
@author Felipi Marques
@since 15.06.2018
/*/
//-----------------------------------------------------------------------
Static Function fExpXml(cIdEnt,cSerie,cNotaIni,cNotaFim,cDirDest,lEnd,dDataDe,dDataAte,cCnpjDIni,cCnpjDFim)
//Declaracao de variaveis    
Local cDestino 	:= ""
Local cDrive   	:= ""
Local cAlias    := CriaTrab(,.F.)
Local cSelect   := ""
Local cQry	    := ""
Local cXMl      := ""
//Corrigi diretorio de destino
SplitPath(cDirDest,@cDrive,@cDestino,"","")
cDestino := cDrive+cDestino

//Monta a query de seleção
cQry := " SELECT SDS.R_E_C_N_O_ AS REGSDS, "
cQry += "        SA2.R_E_C_N_O_ REGSA2  "
cQry += " FROM   " + RETSQLTAB("SDS")    
cQry += "        INNER JOIN " + RETSQLTAB("SA2") 
cQry += "                ON DS_FORNEC = A2_COD "
cQry += "                   AND DS_LOJA = A2_LOJA "
cQry += "                   AND "+RETSQLCOND("SA2") 

cQry += " WHERE    DS_DOC >= '" +cNotaIni +"'             AND  DS_DOC <= '" +cNotaFim +"'              "

If !empty(Alltrim(cSerie))
	cQry += " AND    DS_SERIE = '" +cSerie +"' "    
EndIf
If !(empty(Alltrim(cCnpjDIni)) .and. empty(Alltrim(cCnpjDFim)))
cQry += " AND    A2_CGC >= '" +cCnpjDIni +"'             AND  A2_CGC <= '" +cCnpjDFim +"'           "
EndIf
cQry += " AND    DS_EMISSA >= '"  +DToS(dDataDe) +"'   AND  DS_EMISSA <= '"  +DToS(dDataAte) +"'    "
cQry += " AND "+RETSQLCOND("SDS")             

//Compatibiliza a query de acordo com o banco utilizado
cQry := ChangeQuery(cQry)

//Abre um alias com a query informada.
MPSysOpenQuery(cQry, cAlias)

dbSelectArea(cAlias)
(cAlias)->(dbGoTop())

ProcRegua( (cAlias)->( RecCount() ) )

// Prepara Exportação
While !(cAlias)->(EoF())

	IncProc()
	
	//Posiciona nos registros necessários
	dbSelectArea( "SDS" )
	dbGoTo( (cAlias)->REGSDS )
    //Remove caractere especiais
	cXml    := fXMLChar(SDS->DS_NFXML)
	If ExistBlock("COMEXPXML")
		ExecBlock("COMEXPXML",.f.,.f.,{cXML})			                    
	EndIF
					 			
	nHandle := FCreate(cDestino+SDS->DS_CHAVENF+".xml")
	if nHandle > 0
		FWrite(nHandle,AllTrim(cXml))							
		FClose(nHandle)
	endIf
	
	(cAlias)->(dbSkip())
EndDo

dbCloseArea(cAlias)


Return()

Return        

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Pop3Receive ºAutor  ³Felipi Marques    º Data ³  08/14/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
 

Static Function Email()

Private lExcJob  := IsBlind()
Private lEnd     := .F. 
Private oProcess := Nil  
Private aErroXML := {}

If !lExcJob 
	oProcess := MsNewProcess():New( { |lEnd| fLeXml( lEnd, oProcess ) }, "Processando E-Mail", "Lendo mensagens...", .T. ) 
	oProcess:Activate()
Else
	fLeXml()
EndIf

Static Function fLeXml(lEnd,oProcess)

Local oServer
Local oMessage
Local xRet
Local nAttach   := 0
Local nI        := 0
Local nMessages := 0
Local aAttInfo  := {}
Local cFile := ""
Local cName     := ""

Local nPOPPort  :=  (SuperGetMv("MV_XMLPORP",,995))		                    // Porta do servidor POP
Local nSMTPPort :=  (SuperGetMv("MV_XMLPORS",,465 ))	                    // Porta do servidor SMTP
Local cPopAddr  :=  (SuperGetMv("MV_XMLPOP" ,,'pop.gmail.com' ))		    // Endereco do servidor POP3
Local cUser     :=  (SuperGetMv("MV_XMLUSRM",,'protheus.qger@gmail.com' ))  // Usuario que ira realizar a autenticação
Local cPass     :=  (SuperGetMv("MV_XMLPASM",,'qger20141007' ))		        // Senha do usuario
Local nSMTPTime :=  (SuperGetMv("MV_XMLTIME",, 60 ))		                // Timeout SMTP
Local _lSSL     :=  (SuperGetMv("MV_XMLSSL",,.T.  ))  	                    // Usa SSL Seguro                                                         

Local cPathR
Local cFile
Local lStatus
local aFileStatus := {}


oServer := TMailManager():New()
writePProString( "Mail", "Protocol", "POP3", getsrvininame() )


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Usa SSL na conexao³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If _lSSL
	oServer:SetUseSSL( .T. )
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Cria a conexão com o server POP ( Envio de e-mail )³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
xRet := oServer:Init( cPopAddr, "", cUser, cPass, nPOPPort, nSMTPPort )
if xRet <> 0
	conout( "Could not initialize mail server: " + oServer:GetErrorString( xRet ) )
endif

xRet := oServer:POPConnect()
if xRet <> 0
	conout( "Could not connect on POP3 server: " + oServer:GetErrorString( xRet ) )
endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Quantidade de mensagens ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oServer:GetNumMsgs( @nMessages )
conout( "Number of messages: " + cValToChar( nMessages ) )


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ„m?„m?ô¿
//³INICIA O OBJETO³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ„m?„m?ôÙ
oMessage := TMailMessage():New()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄl¥‘l¥‘l¿
//³Limpa o objeto da mensagem        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ\©‘\©‘lÙ
oMessage:Clear()
conout( "Receiving newest message" )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Recebe a mensagem do servidor ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
xRet := oMessage:Receive( oServer, nMessages )
if xRet <> 0
	conout( "Could not get message " + cValToChar( nMessages ) + ": " + oServer:GetErrorString( xRet ) )
endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Local onde ira salvar as menssagens³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cFile := GetSrvProfString( "RootPath", "" )+"\"
cFile += DIRXML+DIRALER

If( nMessages > 0 )
	for nX := 1 to nMessages
	    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Regua de processamento³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oProcess:IncRegua1( "Lendo Mensagem " + Transform( nX, "@E 999,999" )+" de: " + Transform( nMessages, "@E 999,999" ) )
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ[¿
		//³Quantidade de anexos na mensagem  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ[Ù
		nAttach := oMessage:GetAttachCount()
		for nI := 1 to nAttach
			lAnexoTxt	:= .F.
			lDelete		:= .F.
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ]‘¿
			//³Apresenta informações de um anexo de uma mensagem³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ]‘Ù
			aAttInfo := oMessage:GetAttachInfo( nI )
			varinfo( "", aAttInfo )
			
			cName := cFile
			
			if aAttInfo[1] == ""
				cName += "message." + SubStr( aAttInfo[2], At( "/", aAttInfo[2] ) + 1, Len( aAttInfo[2] ) )
			else
				cName += aAttInfo[1]
			endif
			
			IF !EMPTY(cName) 
			   lAnexoTxt := .T.
			   lDelete	 := .T.
			   If ".XML" $ Upper(cName)
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Salva um arquivo anexo a mensagem em disco.³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					conout( "Saving attachment " + cValToChar( nI ) + ": " + cName )
					xRet := oMessage:SaveAttach( nI, cName )
				EndIf
			
			ELSE
				Conout("*** COMMI020 | Arquivo nao possui extensao txt:"+cNomeArq)
			ENDIF
			
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Exclui mensagem do Servidor ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IF lDelete .AND.(lAnexoTxt, .T.)
				nDelet 	:= oServer:DeleteMsg( nX )
			   	IF nDelet == 0 		        
			   		Conout("*** COMMI020 | E-mail Excluido - lAnexoTxt: "+iif(lAnexoTxt, "TRUE", "FALSE"))	
			   	ELSE 	                                                                                                                                
				   	conout("*** COMMI020 | E-mail NAO Excluido : "+oServer:GetErrorString(nDelet))
			   	ENDIF 	
			ENDIF	
			
		next nI
	next nX
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¨¿
//³Encerra a conexão com o servidor POP - Post Office Protocol.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¨Ù
xRet := oServer:POPDisconnect()

if xRet <> 0
	conout( "Could not disconnect from POP3 server: " + oServer:GetErrorString( xRet ) )
endif

aFiles := Directory("\" +DIRXML+DIRALER+ "*.xml")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
//³processa todos os arquivos do diretorio    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[Ù
For n:=1 to len(aFiles)
	
	cFile:=aFiles[n][1]
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
	//³Chama funcao de importação de XML          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[Ù
	MsAguarde({|| lStatus:=U_ACOMR07(cFile,.F.)},"Aguarde","Importando dados do arquivo XML...",.F.)
	
next

if len(aErroXML) > 0

   MostraErros(aErroXML)

//   for n := 1 to len(aErroXML)
//       cMsg := "Filial           : "+aErroXML[n][1]+chr(10)+chr(12)
//       cMsg += "CNPJ Fornecedor  : "+Transform(aErroXML[n][2],"@R 99.999.999/9999-99")+chr(10)+chr(12)
//       cMsg += "Nome Fornecedor  : "+aErroXML[n][3]+chr(10)+chr(12)
//       cMsg += "Serie/Numero NF  : "+aErroXML[n][4]+"/"+aErroXML[n][5]+chr(10)+chr(12)
//       cMsg += "Valor NF         : "+AllTrim(Transform(aErroXML[n][6], "@E 999,999,999.99" ))+chr(10)+chr(12)    
//       cMsg += "Codigo do Retorno: "+aErroXML[n][7]+chr(10)+chr(12)
//       cMsg += "Mensagem Erro 1  : "+aErroXML[n][8]+chr(10)+chr(12)
//       cMsg += "Mensagem Erro 2  : "+aErroXML[n][9]+chr(10)+chr(12)
//       MSGALERT( cMsg, "Erro Consulta Sefaz - "+AllTrim(Str(n)))
//   next
   
endif 


Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³COMMI020  ºAutor  ³Microsiga           º Data ³  12/05/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ValidPerg(cPerg,aRegs)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis da Rotina                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local i 	:= 0
Local j 	:= 0
Local aArea := GetArea()

dbSelectArea("SX1")
SX1->(dbSetOrder(1))
For i:= 1 to Len(aRegs)
	If SX1->(!dbSeek(PadR(cPerg,Len(SX1->X1_GRUPO))+aRegs[i,2] ))
		RecLock("SX1", .T.)
		For j := 1 to Len(aRegs[1])
			FieldPut(j,aRegs[i,j])
		Next j
		MsUnlock()
	EndIf
Next i

RestArea(aArea)

Return Nil  

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fOriDes   ºAutor  ³Felipi Marques      º Data ³  07/07/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ HelenoFonseca                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function fOriDes()

Local oDlg
Local lRet		:= .F.

Private cOrig	:= Space(300)

Define MsDialog oDlg From 000,000 TO 140,400 Title OemToAnsi("Deseja salvar o relatorio ?") Pixel

@ 020,005 Say OemToAnsi("Salvar em:") Pixel
@ 033,005 Say OemToAnsi("Nome do usuário:") Pixel
@ 019,050 Get cOrig	Size 130,8 Picture "@!" Pixel When .F.
@ 032,050 Get cUserName	Size 130,8 Picture "@" Pixel When .F.
@ 019,185 Button oBtn1 Prompt OemToAnsi("...") Size 10,10 Pixel of oDlg Action fBscDir(.F.,@cOrig)

Define Sbutton From 55,120 Type 1 Action (lRet := .T. ,oDlg:End())		Enable Of oDlg
Define Sbutton From 55,152 Type 2 Action (lRet := .F.,oDlg:End())		Enable Of oDlg

ACTIVATE MSDIALOG oDlg Centered 

Return{cOrig,lRet}

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fOriDes   ºAutor  ³Felipi Marques      º Data ³  07/07/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ HelenoFonseca                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function fBscDir(lDir,cOrig,cAquivo)

Local cTipo 	:=	"'Arquivo *|*.*|Arquivo PDF|*.PDF'"
Local cTitulo	:= "Dialogo de Selecao de Arquivos"
Local cDirIni	:= ""
Local cDrive	:= ""
Local cRet		:= ""
Local cDir		:= ""
Local cFile		:= ""
Local cExten	:= ""
Local cGetFile	:= ""

cGetFile := cGetFile(cTipo,cTitulo,0,cDirIni,.T.,GETF_NETWORKDRIVE+GETF_LOCALHARD+GETF_RETDIRECTORY,.F.) 

// Separa os componentes
SplitPath( cGetFile, @cDrive, @cDir, @cFile, @cExten )

//Trata variavel de retorno
If !Empty(cFile) .And. !lDir
	cRet := cGetFile
EndIf

//Trata variavel de retorno
IF SUBSTR(cGetFile,LEN(cGetFile),1) == "\"
	cGetFile := SUBSTR(cGetFile,1,LEN(cGetFile)-1)
ENDIF

cOrig := cGetFile            			

Return() 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³x140IMarc ºAutor  ³Felipi Marques      º Data ³  11/10/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³Descri‡„o ³ Marca todas as linhas com evento de clique no cabeçalho da ³±±
±±³			 ³ browse.											     	  ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function x140IMarc(aArquivo,oBrowse)

If aScan(aArquivo, {|x| !x[1] .And. x[2] <> "P"}) > 0	
	aEval(@aArquivo, {|x| IF(x[2] <> "P", x[1] := .T., x[1] := .F.)})
Else
	aEval(@aArquivo, {|x| x[1] := .F.})
EndIf

oBrowse:Refresh()

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³x140IPesq ºAutor  ³Felipi Marques      º Data ³  11/10/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Realiza pesquisa na MBrowse                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function x140IPesq(aItens, oBrwNFe)

Local aCboOrdens := {}
Local cOrdem     := ''
Local cCpoPesq   := Space(50)
Local lSeek      := .F.
Local nOrdem     := 1
Local nSeek      := 0
Local oDlgPesq
Local oCboOrdens
Local oCpoPesq

//--Adiciona as Ordens de Pesquisa...
AAdd( aCboOrdens, "Arquivo" )
AAdd( aCboOrdens, "Documento" ) 
AAdd( aCboOrdens, "Serie" )
AAdd( aCboOrdens, "Razao Social" )

Define MSDialog oDlgPesq Title "Pesquisar" From 00,00 To 100,490 Pixel 

@ 05,05 ComboBox oCboOrdens Var cOrdem Items aCboOrdens Size 206,36 Pixel Of oDlgPesq On Change (nOrdem := oCboOrdens:nAT)
@ 22,05 MSGet oCpoPesq Var cCpoPesq Picture '@!' Size 206,10 Pixel Of oDlgPesq
Define SButton From 05,215 Type 1 Of oDlgPesq Enable Action ( lSeek := .T., oDlgPesq:End() )	
Define SButton From 20,215 Type 2 Of oDlgPesq Enable Action ( lSeek := .F., oDlgPesq:End() )

Activate MSDialog oDlgPesq Center

If lSeek
	cCpoPesq := AllTrim( cCpoPesq )
	If nOrdem == 1
		//--Arquivo
		ASort( aItens,,,{|x,y| x[2] < y[2]} )
		nSeek := AScan( aItens, {|x| AllTrim(x[2]) == cCpoPesq } )	
	ElseIf nOrdem == 2
		//--Documento
		ASort( aItens,,,{|x,y| x[3] < y[3]} )
		nSeek := AScan( aItens, {|x| Left( x[3], Len( cCpoPesq ) ) == cCpoPesq } )
	ElseIf nOrdem == 3
		//--Serie
		ASort( aItens,,,{|x,y| x[4] < y[4]} )
		nSeek := AScan( aItens, {|x| AllTrim(x[4])== cCpoPesq } )
	ElseIf nOrdem == 4
		//--Razao Social
		ASort( aItens,,,{|x,y| x[5] < y[5]} )
		nSeek := AScan( aItens, {|x| AllTrim(x[5]) == cCpoPesq } )
	EndIf
	If	nSeek > 0
		oBrwNfe:nAT := nSeek
	EndIf
	oBrwNfe:Refresh()
	oBrwNfe:SetFocus()
EndIf

Return      

//-----------------------------------------------------------------------        
/*/{Protheus.doc} fXMLChar
@param	cTexto			Texto para retirar caracteres especiais
@return	cTexto			Texto sem caracteres especiais
@author Felipi Marques
@since 15.06.2018
/*/
//-----------------------------------------------------------------------
Static Function fXMLChar(cTexto)

Local nI		:= 0
Local aCarac 	:= {}

Aadd(aCarac,{"Á","A"})
Aadd(aCarac,{"À","A"})
Aadd(aCarac,{"Â","A"})
Aadd(aCarac,{"Ã","A"})
Aadd(aCarac,{"á","a"})
Aadd(aCarac,{"à","a"})
Aadd(aCarac,{"â","a"})
Aadd(aCarac,{"ã","a"})
Aadd(aCarac,{"É","E"})
Aadd(aCarac,{"Ê","E"})
Aadd(aCarac,{"é","e"})
Aadd(aCarac,{"ê","e"})
Aadd(aCarac,{"Í","I"})
Aadd(aCarac,{"í","i"})
Aadd(aCarac,{"Ó","O"})
Aadd(aCarac,{"Ô","O"})
Aadd(aCarac,{"Õ","O"})
Aadd(aCarac,{"ó","o"})
Aadd(aCarac,{"ô","o"})
Aadd(aCarac,{"õ","o"})
Aadd(aCarac,{"Ú","U"})
Aadd(aCarac,{"ú","u"})
Aadd(aCarac,{"Ç","C"})
Aadd(aCarac,{"ç","c"})


// Ignora caracteres Extendidos da tabela ASCII
For nI := 128 To 255
	Aadd(aCarac,{Chr(nI)," "})  // Tab
Next nI

For nI := 1 To Len(aCarac)
	If aCarac[nI, 1] $ cTexto
		cTexto := StrTran(cTexto, aCarac[nI,1], aCarac[nI,2])
	EndIf
Next nI

Return cTexto



//--------
/*/
   Programa : PesqChv()
   Descrição: Verificação do status da NF-e
/*/
Static Function PesqChv(cChavePesq)

Local oButton1
Local oButton2
Local oSay1
Local nOpcChe    := 0
Local aRet       := {}
Private aCordW   := MsAdvSize(.T.)
Private oChave
Private cChave   := Space(44)
Private oDlg
Private cLineOk  := "AllwaysTrue()"
Private cAllOk   := "AllwaysTrue()"
Private nCOunt   := 0
Private cIdEnt   := GetIdEnt()
Private nOpcx    := 3
Private aCGD     := {}
Private lDelGetD := .T.
Private aButtons := {}

Default cChavePesq := ""

if Empty(cChavePesq)

   DEFINE MSDIALOG oDlg TITLE "Verificao do Status da NF-e no Sefaz" FROM 000, 000 TO 100, 640 COLORS 0, 16777215 PIXEL

   @ 010, 003 SAY oSay1 PROMPT "Chave de Acesso:" SIZE 050, 007 OF oDlg COLORS 0, 16777215 PIXEL
   @ 009, 059 MSGET oChave VAR cChave SIZE 256, 010 OF oDlg COLORS 0, 16777215 PIXEL
   @ 028, 275 BUTTON oButton1 PROMPT ">>> Avançar" SIZE 037, 012 OF oDlg PIXEL ACTION ( oDlg:End(), nOpcChe := 1 ) // SH143NXT(cChave)
   @ 028, 225 BUTTON oButton2 PROMPT "Cancelar" SIZE 037, 012 OF oDlg ACTION oDlg:End() PIXEL

   ACTIVATE MSDIALOG oDlg CENTERED

   If nOpcChe == 1
      VldNfe(cChave,cIdEnt,0)
   EndIF
   
else
  cChave := ""
  cChave := cChavePesq
  aRet   := VldNfe(cChavePesq,cIdEnt,1)
endif

if Empty(cChavePesq)
   Return
else
   Return(aRet)
endif

/*/
   Programa : VldNfe()
   Descrição: Verificação do status da NF-e
/*/
Static Function VldNfe(cNFePesq,cIndChv,nOrig)

Local cURL := PadR(GetNewPar("MV_SPEDURL","http://"),250)
Local cMensagem := ""
Local oWS
Local cCodRet := ""
Local cVersao := ""
Local cMensagem := ""
Local cTpRet := ""
Local cDescRet := ""
Local aRet := {}
Default nOrig := 0

oWs:= WsNFeSBra():New()
oWs:cUserToken := "TOTVS"
oWs:cID_ENT := cIndChv
ows:cCHVNFE := cNFePesq
oWs:_URL := AllTrim(cURL)+"/NFeSBRA.apw"

//ALERT("CHAVE PESQUISA: "+cNFePesq)

If oWs:ConsultaChaveNFE()

   cCodRet := oWs:oWSCONSULTACHAVENFERESULT:cCODRETNFE
   cVersao := oWs:oWSCONSULTACHAVENFERESULT:cVERSAO
   cMensagem := oWs:oWSCONSULTACHAVENFERESULT:cMSGRETNFE
   cProtocolo := oWs:oWSCONSULTACHAVENFERESULT:cPROTOCOLO

   if nOrig = 0
      Aviso("SPED", cMensagem,{"OK"},3)
   endif
   
Else

   if nOrig = 0
      Aviso("SPED",IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)),{"OK"},3)
   endif
   
EndIf

if nOrig = 1
   aAdd(aRet,{cCodRet, cMensagem,IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3))})
endif

// dependendo do erro, por exemplo, tamanho de chave inválido, cCodRet vai estar vazio

if nOrig = 0
   Return()
else
   Return(aRet)
endif


/*/
   Programa : GetIdEnt
   Descrição: Obtem o codigo da entidade apos enviar o post para o Totvs Service
/*/
Static Function GetIdEnt()

Local aArea := GetArea()
Local cIdEnt := ""
Local cURL := PadR(GetNewPar("MV_SPEDURL","http://"),250)
Local lMethodOk := .F.
Local oWsSPEDAdm

BEGIN SEQUENCE

IF !( CTIsReady(cURL) )
BREAK
EndIF

cURL := AllTrim(cURL)+"/SPEDADM.apw"

IF !( CTIsReady(cURL) )
BREAK
EndIF

oWsSPEDAdm := WsSPEDAdm():New()

oWsSPEDAdm:cUSERTOKEN := "TOTVS"
oWsSPEDAdm:oWsEmpresa:cCNPJ := SM0->( IF(M0_TPINSC==2 .Or. Empty(M0_TPINSC),M0_CGC,"") )
oWsSPEDAdm:oWsEmpresa:cCPF := SM0->( IF(M0_TPINSC==3,M0_CGC,"") )
oWsSPEDAdm:oWsEmpresa:cIE := SM0->M0_INSC
oWsSPEDAdm:oWsEmpresa:cIM := SM0->M0_INSCM
oWsSPEDAdm:oWsEmpresa:cNOME := SM0->M0_NOMECOM
oWsSPEDAdm:oWsEmpresa:cFANTASIA := SM0->M0_NOME
oWsSPEDAdm:oWsEmpresa:cENDERECO := FisGetEnd(SM0->M0_ENDENT)[1]
oWsSPEDAdm:oWsEmpresa:cNUM := FisGetEnd(SM0->M0_ENDENT)[3]
oWsSPEDAdm:oWsEmpresa:cCOMPL := FisGetEnd(SM0->M0_ENDENT)[4]
oWsSPEDAdm:oWsEmpresa:cUF := SM0->M0_ESTENT
oWsSPEDAdm:oWsEmpresa:cCEP := SM0->M0_CEPENT
oWsSPEDAdm:oWsEmpresa:cCOD_MUN := SM0->M0_CODMUN
oWsSPEDAdm:oWsEmpresa:cCOD_PAIS := "1058"
oWsSPEDAdm:oWsEmpresa:cBAIRRO := SM0->M0_BAIRENT
oWsSPEDAdm:oWsEmpresa:cMUN := SM0->M0_CIDENT
oWsSPEDAdm:oWsEmpresa:cCEP_CP := NIL
oWsSPEDAdm:oWsEmpresa:cCP := NIL
oWsSPEDAdm:oWsEmpresa:cDDD := Str(FisGetTel(SM0->M0_TEL)[2],3)
oWsSPEDAdm:oWsEmpresa:cFONE := AllTrim(Str(FisGetTel(SM0->M0_TEL)[3],15))
oWsSPEDAdm:oWsEmpresa:cFAX := AllTrim(Str(FisGetTel(SM0->M0_FAX)[3],15))
oWsSPEDAdm:oWsEmpresa:cEMAIL := UsrRetMail(RetCodUsr())
oWsSPEDAdm:oWsEmpresa:cNIRE := SM0->M0_NIRE
oWsSPEDAdm:oWsEmpresa:dDTRE := SM0->M0_DTRE
oWsSPEDAdm:oWsEmpresa:cNIT := SM0->( IF(M0_TPINSC==1,M0_CGC,"") )
oWsSPEDAdm:oWsEmpresa:cINDSITESP := ""
oWsSPEDAdm:oWsEmpresa:cID_MATRIZ := ""
oWsSPEDAdm:oWsOutrasInscricoes:oWsInscricao := SPEDADM_ARRAYOFSPED_GENERICSTRUCT():New()
oWsSPEDAdm:_URL := cURL

lMethodOk := oWsSPEDAdm:AdmEmpresas()

DEFAULT lMethodOk := .F.

IF !( lMethodOk )
cError := IF( Empty( GetWscError(3) ) , GetWscError(1) , GetWscError(3) )
BREAK
EndIF

cIdEnt := oWsSPEDAdm:cAdmEmpresasResult

END SEQUENCE

RestArea(aArea)

Return( cIdEnt )



/*/
Funcao: MostraErros()
/*/

Static Function MostraErros(aArrayErros)

Local oDlg
Local oLbx
Local lRet := .T.

Private aIte := {}
Private nLin := 0

//Define MsDialog oDlg From 50,001 To 320,600 Title "Lotes Disponíveis" Pixel 
Define MsDialog oDlg From 50,001 To 320,1050 Title "Erros de Processaomento - Importação de XML" Pixel 
	
//@01,02 To 112,300 Label " Lotes Disponíveis para o Item Selecionado : " Of oDlg Pixel
@10,05 ListBox oLbx Fields;
			Header;
			"Filial",;
			"CNPJ Fornecedor",;
			"Razão Social",;
			"Serie/Número NF",;
			"Valor NF",;
			"Ocorrência",;
			Size 520,100 Of oDlg Pixel  

	
oLbx:SetArray(aArrayErros)
oLbx:bLine:={|| {aArrayErros[oLbx:nAt][1],;
				 Transform(aErroXML[oLbx:nAt][2],"@R 99.999.999/9999-99"),;
				 aArrayErros[oLbx:nAt][3],;
				 aArrayErros[oLbx:nAt][4],;
				 Transform(aErroXML[oLbx:nAt][5], "@E 999,999,999.99"),;
				 aArrayErros[oLbx:nAt][6]}} 

oLbx:Refresh()
oLbx:SetFocus(.T.)
		
Define Sbutton From 120,190 Type 6 Enable Of oDlg Action {|| ImprimeErro(aArrayErros)}
Define Sbutton From 120,270 Type 1 Enable Of oDlg Action oDlg:End()
	
Activate MsDialog oDlg Center On Init CursorArrow()

Return(lRet)



/*/
Funcao: ImprimeErro
/*/

Static Function ImprimeErro(aTabelaImp)

Local oReport

Private aTabela := aTabelaImp
	
oReport:=ReportDef()
	
oReport:PrintDialog()

Return


/*/
Funcao: ReportDef
/*/

Static Function ReportDef()

Local oReport
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao do componente de impressao                                      ³
//³                                                                        ³
//³TReport():New                                                           ³
//³ExpC1 : Nome do relatorio                                               ³
//³ExpC2 : Titulo                                                          ³
//³ExpC3 : Pergunte                                                        ³
//³ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  ³
//³ExpC5 : Descricao                                                       ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport := TReport():New("COMMI020","Relacao de Erros na Importação de XML - NF-e",, {|oReport| ReportPrint(oReport)},"Relatorio")
oReport:SetLandscape() 
oReport:SetTotalInLine(.F.)

// Pergunte(oReport:uParam,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao da secao utilizada pelo relatorio                               ³
//³                                                                        ³
//³TRSection():New                                                         ³
//³ExpO1 : Objeto TReport que a secao pertence                             ³
//³ExpC2 : Descricao da seçao                                              ³
//³ExpA3 : Array com as tabelas utilizadas pela secao. A primeira tabela   ³
//³        sera considerada como principal para a seção.                   ³
//³ExpA4 : Array com as Ordens do relatório                                ³
//³ExpL5 : Carrega campos do SX3 como celulas                              ³
//³        Default : False                                                 ³
//³ExpL6 : Carrega ordens do Sindex                                        ³
//³        Default : False                                                 ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao da celulas da secao do relatorio                                ³
//³                                                                        ³
//³TRCell():New                                                            ³
//³ExpO1 : Objeto TSection que a secao pertence                            ³
//³ExpC2 : Nome da celula do relatório. O SX3 será consultado              ³
//³ExpC3 : Nome da tabela de referencia da celula                          ³
//³ExpC4 : Titulo da celula                                                ³
//³        Default : X3Titulo()                                            ³
//³ExpC5 : Picture                                                         ³
//³        Default : X3_PICTURE                                            ³
//³ExpC6 : Tamanho                                                         ³
//³        Default : X3_TAMANHO                                            ³
//³ExpL7 : Informe se o tamanho esta em pixel                              ³
//³        Default : False                                                 ³
//³ExpB8 : Bloco de código para impressao.                                 ³
//³        Default : ExpC2                                                 ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oErros := TRSection():New(oReport,"Seção 1",,/*{Array com as ordens do relatório}*/,/*Campos do SX3*/,/*Campos do SIX*/)
oErros:SetTotalInLine(.F.)

TRCell():New(oErros,"cFilImp" ,"","Filial"        ,                   , 10,/*lPixel*/,{|| cFilImp},,,"LEFT")  // Filial
TRCell():New(oErros,"cCNPJ"   ,"","CNPJ"          ,                   , 20,/*lPixel*/,{|| cCNPJ  },,,"LEFT")  // CNPJ
TRCell():New(oErros,"cRazao"  ,"","Razão Social"  ,                   , 60,/*lPixel*/,{|| cRazao },,,"LEFT")  // Razão Social
TRCell():New(oErros,"cNota"   ,"","Serie/Num NF-e",                   , 20,/*lPixel*/,{|| cNota  },,,"LEFT")  // Série e Numero da NF
TRCell():New(oErros,"nValor"  ,"","Valor NF-e"    ,"@E 999,999,999.99", 15,/*lPixel*/,{|| nValor },,,"RIGHT") // Valor da NF
TRCell():New(oErros,"cOcor"   ,"","Ocorrência"    ,                   ,100,/*lPixel*/,{|| cOcor  },,,"LEFT")  // Ocorrência

Return(oReport)

/*/
Funcao: ReportPrint
/*/
Static Function ReportPrint(oReport)

Local nRegistros := len(aTabela)
Local nI         := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Metodo TrPosition()                                                     ³
//³                                                                        ³
//³Posiciona em um registro de uma outra tabela. O posicionamento será     ³
//³realizado antes da impressao de cada linha do relatório.                ³
//³                                                                        ³
//³                                                                        ³
//³ExpO1 : Objeto Report da Secao                                          ³
//³ExpC2 : Alias da Tabela                                                 ³
//³ExpX3 : Ordem ou NickName de pesquisa                                   ³
//³ExpX4 : String ou Bloco de código para pesquisa. A string será macroexe-³
//³        cutada.                                                         ³
//³                                                                        ³				
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicio da impressao do fluxo do relatório                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport:SetMeter(nRegistros)
oReport:Section(1):Init()

For nI := 1 to nRegistros

	cFilImp := aTabela[nI][1]
	cCNPJ   := Transform(aErroXML[nI][2],"@R 99.999.999/9999-99")	
	cRazao  := aTabela[nI][3]
	cNota   := aTabela[nI][4]
	nValor  := aTabela[nI][5]
	cOcor   := aTabela[nI][6]
	
	oReport:Section(1):PrintLine()
	
	oReport:IncMeter()

Next nI

oReport:Section(1):Finish()
oReport:Section(1):SetPageBreak(.T.) 

Return

