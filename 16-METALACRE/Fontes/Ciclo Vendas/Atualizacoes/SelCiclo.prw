#Include "RWMAKE.CH"
#Include "TOPCONN.CH"
#Include "Protheus.Ch"

#DEFINE DT_MARCA	002
#DEFINE DT_CICLO	003
#DEFINE DT_CODIGO	004
#DEFINE DT_LOJA		005
#DEFINE DT_NOME		006
#DEFINE DT_DDD		007
#DEFINE DT_TEL		008
#DEFINE DT_CONTATO	009
#DEFINE DT_EMAIL	010
#DEFINE DT_RECNO	011
#DEFINE DT_VENCI	012
#DEFINE DT_MODIFI	013
#DEFINE DT_DTCICLO	014
#DEFINE DT_VENDEDOR	015
#DEFINE DT_RECNO2	016
#DEFINE DT_ULTACAO	017
#DEFINE DT_MEDIA	018
#DEFINE DT_ORDCICLO	019
#DEFINE DT_ORDVENCI 020
#DEFINE DT_TEL2     021
#DEFINE DT_TEL3     022
#DEFINE DT_ULTPED   023
#DEFINE DT_MOTIVO   024
#DEFINE DT_DATOCO   025
#DEFINE DT_ULTCOM   026
#DEFINE DT_QTDCOM   027
#DEFINE DT_CNPJ     028
#DEFINE DT_RAZAO    029      
#DEFINE DT_CONTRATO 030
#DEFINE DT_FINAN    031
#DEFINE DT_LEG      032
#DEFINE DT_MUN      033
#DEFINE DT_UFAT     034
#DEFINE DT_TFAT     035


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ SelCiclo   บAutor ณLuiz Albertoบ Data ณ  Outubro/2014   บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Tela Demonstra็ใo de Clientes em Data de Ciclo de Liga็ใo   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑฬออออออออออุออออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDATA      ณ ANALISTA ณ  MOTIVO                                         บฑฑ
ฑฑฬออออออออออุออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ          ณ                                                 บฑฑ
ฑฑศออออออออออฯออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function SelCiclo()
Local aArea := GetArea()
Private nSelCol := 0

Processa({|| S_Ciclo() } ,"Aguarde Selecionando Clientes em Data de Ciclo...")

RestArea(aArea)
Return .t.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ S_Ciclo   บAutor ณLuiz Albertoบ Data ณ  Outubro/2014   บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Tela Demonstra็ใo de Clientes em Data de Ciclo de Liga็ใo   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑฬออออออออออุออออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDATA      ณ ANALISTA ณ  MOTIVO                                         บฑฑ
ฑฑฬออออออออออุออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ          ณ                                                 บฑฑ
ฑฑศออออออออออฯออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function S_Ciclo()
Local aArea	:= GetArea()
Local oBotaoSai
PRIVATE oRcp5
Private    oOk		 := LoadBitmap(GetResources(),"LBTIK")
Private    oNo  	 := LoadBitmap(GetResources(),"LBNO")
Private  oSinal10    := LoadBitmap(GetResources(),"BR_VERDE")
Private  oSinal05    := LoadBitmap(GetResources(),"BR_LARANJA")
Private  oSinal00    := LoadBitmap(GetResources(),"BR_VERMELHO")
Private  oSinalVc    := LoadBitmap(GetResources(),"BR_AMARELO")
Private  oSinalMk    := LoadBitmap(GetResources(),"BR_VIOLETA")
Private  oSinalPd    := LoadBitmap(GetResources(),"BR_PINK")
Private  oSinalRt    := LoadBitmap(GetResources(),"BR_AZUL")
Private  oSinalFn    := LoadBitmap(GetResources(),"BR_PRETO")
Private aCiclos := {}
Private oBotaoCnf
Private nDiasVisao	:= GetNewPar("MV_CLDVIS",15)	// Quantidade de Dias para Visualiza็ใo Futura do Ciclo de Clientes
Private oSay1
Private oSay2
Private lTudo	:=	.f.
Private aVends  := {}

// Localiza Id do Vendedor Logado

cTipVen	:=	'V'
cTipVen := Iif(__cUserId$GetNewPar("MV_XADMCI",'000000')+';000194','A',cTipVen)  

If cTipVen$'S*G*A'	// No Caso de Supervisores e Gerentes Pergunta se Quer Entrar no Ciclo
	If !MsgYesNo("Voc๊ Supervisor ou Gerente, Deseja Acessar o Ciclo de Vendas ? ",OemToAnsi('ATENCAO'))
		RestArea(aArea)
		Return .t.
	Endif
Endif

If cTipVen$'V' .And. !SA3->(dbSetOrder(7), dbSeek(xFilial("SA3")+__cUserID))
	Alert("Aten็ใo Vendedor Nใo Localizado Pelo ID de Usuแrio - Verifique !!!")
	Return .f.
Elseif cTipVen$'VSG'
	cQuery := 	 "  SELECT A3_COD, A3_SUPER, A3_GEREN "
	cQuery +=	 " FROM " + RetSqlName("SA3")
	cQuery +=	 " WHERE   A3_FILIAL = '" + xFilial("SA3") + "' "
	cQuery +=	 " AND D_E_L_E_T_ = ''   "
	cQuery +=	 " AND (A3_SUPER = '" + SA3->A3_COD + "' OR A3_GEREN = '" + SA3->A3_COD + "') "
		
	TCQUERY cQuery NEW ALIAS "CHKVND"
	
	If CHKVND->A3_SUPER == SA3->A3_COD
		cTipVen	:=	'S'	// Supervisor
	ElseIf CHKVND->A3_GEREN == SA3->A3_COD
		cTipVen	:=	'G'	// Gerente
	ElseIf Empty(CHKVND->A3_COD)
		cTipVen	:=	'V'	// Vendedor
	Endif

	CHKVND->(dbCloseArea())
Endif            

cCodVend	:= SA3->A3_COD
cCodSup		:= SA3->A3_SUPER
cCodGer		:= SA3->A3_GEREN
lRepresent	:= (SA3->A3_TIPO=='E')

RestArea(aArea)

cCargo := 'Vendedor(a)'
If cTipVen=='S'
	cCargo := 'Supervisor(a)'
ElseIf cTipVen == 'G'
	cCargo := 'Gerente'
ElseIf cTipVen == 'A'
	cCargo := 'Admin Sistema'
Endif

aSize     := MsAdvSize() 
aObjects := {} 
AAdd( aObjects, {  60, 100, .t., .t. } )
	
aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 } 
aPosObj := MsObjSize( aInfo, aObjects ) 



DEFINE MSDIALOG oRcp5 TITLE "Clientes Ciclo Contato - " + cCargo + ' - ' + SA3->A3_COD + ' - ' + Capital(AllTrim(SA3->A3_NOME)) + ' - Total de ' + TransForm(Len(aCiclos),'@E 999,999') + ' Clientes em Ciclo' FROM aSize[7],00 To aSize[6]-50,Min(1304,aSize[5]) COLORS 0, 16777215 PIXEL Style DS_MODALFRAME 
oRcp5:lEscClose := .F. //Nใo permite sair ao usuario se precionar o ESC

	aTitCiclo := {cCargo,'Vecto Ciclo',"Data Ciclo",'Tipo Ctr',"C๓digo","Loja",'Nome Fantasia','Ult.Faturamento','Acumulado 12 Meses','Municipio','Ped.Aberto','M้dia Ciclo','Ult.Compra','Nr.Compras','(DDD)','Fone(1)','Fone(2)','Fone(3)','Contato','Ult.A็ใo','Data A็ใo','CNPJ','Razใo Social'}

    @ 020, 005 LISTBOX oDtCiclos Fields HEADER '','',cCargo,'Vecto Ciclo',"Data Ciclo",'Tipo Ctr',"C๓digo","Loja",'Nome Fantasia','Ult.Faturamento','Acumulado 12 Meses','Municipio','Ped.Aberto','M้dia Ciclo','Ult.Compra','Nr.Compras','(DDD)','Fone(1)','Fone(2)','Fone(3)','Contato','Ult.A็ใo','Data A็ใo','CNPJ','Razใo Social' ;
    SIZE (oRcp5:NRIGHT/2)-10, (oRcp5:NHEIGHT/2)-70 OF oRcp5 PIXEL //ColSizes 50,50

	PrcCiclo(@aCiclos,lTudo,'',@aVends)

    oDtCiclos:SetArray(aCiclos)
    oDtCiclos:bLine := {|| {	Iif(aCiclos[oDtCiclos:nAt,DT_MARCA]=="1",oSinalMk,;						//	1
    							U_RetLeg(aCiclos[oDtCiclos:nAt,DT_DTCICLO],oDtCiclos:nAt)),;			//	2
    							Iif(aCiclos[oDtCiclos:nAt,2]=="1",oOk,oNo),;							//	3
        						aCiclos[oDtCiclos:nAt,DT_VENDEDOR],;									//	4	
        						aCiclos[oDtCiclos:nAt,DT_VENCI],;										//	5
        						aCiclos[oDtCiclos:nAt,DT_CICLO],;										//	6
        						aCiclos[oDtCiclos:nAt,DT_CONTRATO],;									//	6
      							aCiclos[oDtCiclos:nAt,DT_CODIGO],;										// 	7
					      		aCiclos[oDtCiclos:nAt,DT_LOJA],;										//	8
					      		aCiclos[oDtCiclos:nAt,DT_NOME],;										//	9
					      		TransForm(aCiclos[oDtCiclos:nAt,DT_UFAT],'@E 9,999,999.99'),;			//	10	
					      		TransForm(aCiclos[oDtCiclos:nAt,DT_TFAT],'@E 99,999,999.99'),;			//	11	
					      		aCiclos[oDtCiclos:nAt,DT_MUN],;											//	12
					      		aCiclos[oDtCiclos:nAt,DT_ULTPED],;										//	13	
					      		aCiclos[oDtCiclos:nAt,DT_MEDIA],;										//	14
					      		aCiclos[oDtCiclos:nAt,DT_ULTCOM],;										//	15
					      		aCiclos[oDtCiclos:nAt,DT_QTDCOM],;										//	16
					      		aCiclos[oDtCiclos:nAt,DT_DDD],;											//	17
					      		aCiclos[oDtCiclos:nAt,DT_TEL],;											//	18
					      		aCiclos[oDtCiclos:nAt,DT_TEL2],;										//	19
					      		aCiclos[oDtCiclos:nAt,DT_TEL3],;										//	20
					      		aCiclos[oDtCiclos:nAt,DT_CONTATO],;										//	21
					      		aCiclos[oDtCiclos:nAt,DT_ULTACAO],;										//	22
					      		aCiclos[oDtCiclos:nAt,DT_DATOCO],;										//	23
					      		aCiclos[oDtCiclos:nAt,DT_CNPJ],;										//	24
					      		aCiclos[oDtCiclos:nAt,DT_RAZAO]}}										//	25

	oDtCiclos:bLDblClick := {|| DblClick(oDtCiclos:nAt)}
	oDtCiclos:bHeaderClick := {|| fTrataCol(oDtCiclos:ColPos) }
	nOpc := 0
	cFilVend	:=	Space(06)
	
  	@ aSize[4]-60, 005 BUTTON oBotaoPed PROMPT "Repete Or็amento"		ACTION (RepPed(aCiclos[oDtCiclos:nAt,DT_CODIGO],aCiclos[oDtCiclos:nAt,DT_LOJA],oDtCiclos:nAt)) SIZE 050, 010 PIXEL OF oRcp5 
  	@ aSize[4]-60, 055 BUTTON oBotaoPul PROMPT "Pula Ciclo"				ACTION (PulCic(aCiclos[oDtCiclos:nAt,DT_CODIGO],aCiclos[oDtCiclos:nAt,DT_LOJA],oDtCiclos:nAt)) SIZE 050, 010 PIXEL OF oRcp5 
  	@ aSize[4]-60, 105 BUTTON oBotaoIns PROMPT "Inserir Data"			ACTION (InsData(aCiclos[oDtCiclos:nAt,DT_CODIGO],aCiclos[oDtCiclos:nAt,DT_LOJA])) SIZE 050, 010 PIXEL OF oRcp5 
  	@ aSize[4]-60, 155 BUTTON oBotaoLog PROMPT "Cons.Logs"				ACTION (ConsLog(aCiclos[oDtCiclos:nAt,DT_CODIGO],aCiclos[oDtCiclos:nAt,DT_LOJA],oDtCiclos:nAt)) SIZE 050, 010 PIXEL OF oRcp5 
  	@ aSize[4]-60, 205 BUTTON oBotaoLeg PROMPT "Legenda"				ACTION (U_MstLeg()) SIZE 050, 010 PIXEL OF oRcp5 
  	@ aSize[4]-60, 255 BUTTON oBotaoGrf PROMPT "Atendimentos"			ACTION (U_HISTATD(aCiclos[oDtCiclos:nAt,DT_CODIGO],aCiclos[oDtCiclos:nAt,DT_LOJA])) SIZE 050, 010 PIXEL OF oRcp5 
  	@ aSize[4]-60, 305 BUTTON oBotaoPsq PROMPT "Pesquisar"				ACTION (PsqCli()) SIZE 050, 010 PIXEL OF oRcp5
  	If cTipVen$"SGA"
  		@ aSize[4]-60, 355 BUTTON oBotaoExc PROMPT "Excel"			ACTION Processa({|| fExcel(oRcp5:cCaption,aCiclos,aTitCiclo) } ,"Aguarde...") SIZE 050, 010 PIXEL OF oRcp5 
  	Endif
	@ 007, 005 SAY 		oBsqVend PROMPT "Filtro Vendedor: "  SIZE 100, 010 OF oRcp5 COLORS CLR_BLUE,CLR_WHITE PIXEL
	@ 005, 050 MsComboBox oFilVend Var cFilVend Items aVends Size 150, 010 Of oRcp5 Pixel On Change (cFilVend := Left(aVends[oFilVend:nAt],6), Processa({|| PrcCiclo(@aCiclos,.f.,cFilVend) },"Aguarde Filtrando..."))
	
//	@ 005, 050 MSGET 	oFilVend VAR cFilVend F3 "SA3" Picture '@!' Valid( Processa({|| PrcCiclo(@aCiclos,.f.,cFilVend) },"Aguarde Filtrando...") )  SIZE 050, 010 OF oRcp5 COLORS CLR_BLUE,CLR_WHITE PIXEL

    @ aSize[4]-45, 005 BUTTON oBotaoHis PROMPT "Hist๓rico"	 			ACTION (Histor(aCiclos[oDtCiclos:nAt,DT_CODIGO],aCiclos[oDtCiclos:nAt,DT_LOJA],oDtCiclos:nAt)) SIZE 050, 010 PIXEL OF oRcp5 
    @ aSize[4]-45, 055 BUTTON oBotaoCPd PROMPT "Cons.Pedidos"	 		ACTION (PedCli(aCiclos[oDtCiclos:nAt,DT_CODIGO],aCiclos[oDtCiclos:nAt,DT_LOJA])) SIZE 050, 010 PIXEL OF oRcp5 
  	@ aSize[4]-45, 105 BUTTON oBotaoEcl PROMPT "Edita Cliente"			ACTION (EdiCli(aCiclos[oDtCiclos:nAt,DT_CODIGO],aCiclos[oDtCiclos:nAt,DT_LOJA],oDtCiclos:nAt)) SIZE 050, 010 PIXEL OF oRcp5 
    @ aSize[4]-45, 155 BUTTON oBotaoCnt PROMPT "Cons.Contatos"	 		ACTION (EdiCon(aCiclos[oDtCiclos:nAt,DT_CODIGO],aCiclos[oDtCiclos:nAt,DT_LOJA],oDtCiclos:nAt)) SIZE 050, 010 PIXEL OF oRcp5 
    @ aSize[4]-45, 205 BUTTON oBotaoPos PROMPT "Pos.Financ."			ACTION (ConsFin(oDtCiclos:nAt)) SIZE 050, 010 PIXEL OF oRcp5 
  	@ aSize[4]-45, 255 BUTTON oBotaoTot PROMPT "Ciclo Total"			ACTION (Iif(!lTudo,lTudo:=.t.,lTudo:=.f.),Iif(lTudo,oBotaoTot:cCaption:='Ciclo Filtro',oBotaoTot:cCaption:='Ciclo Total'),oBotaoTot:Refresh(),Processa({||PrcCiclo(@aCiclos,lTudo,cFilVend)})) SIZE 050, 010 PIXEL OF oRcp5 
    @ aSize[4]-45, 305 BUTTON oBotaoSai PROMPT "&Sair"	 				ACTION (LibTel(aCiclos[oDtCiclos:nAt,DT_MARCA],oDtCiclos:nAt)) SIZE 050, 010 PIXEL OF oRcp5 
	
	oBotaoPed:Disable()
	oBotaoCPD:Disable()
	oBotaoCnt:Disable()
	oBotaoPul:Disable()
	oBotaoGrf:Disable()
	oBotaoIns:Disable()
	oBotaoPos:Disable()
	oBotaoHis:Disable()
	oBotaoEcl:Disable()


    @ aSize[ 4 ]-60, 400 SAY oSay1 PROMPT "" SIZE 200, 010 COLOR CLR_HBLUE PIXEL OF oRcp5
    @ aSize[ 4 ]-45, 400 SAY oSay2 PROMPT "" SIZE 200, 010 COLOR CLR_HBLUE PIXEL OF oRcp5
    
    oSay1:oFont := TFont():New('Arial',,20,,.T.,,,,.T.,.F.)
    oSay2:oFont := TFont():New('Arial',,20,,.T.,,,,.T.,.F.)

	ACTIVATE MSDIALOG oRcp5 CENTERED 
	
	If nOpc == 1
	Endif

RestArea(aArea)
Return .t.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuncao    ณ DblClickณ Autor ณ Luiz Alberto        ณ Data ณ 06/12/11 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescricao ณ Funcao Responsavel pelo Double Click Tela Rotas ณฑฑ
ฑฑณ          |                                             ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function dblClick(nPos)
Local aArea := GetArea()

If aCiclos[nPos,2]=="1"
	aCiclos[nPos,2]:="2"

	oBotaoPed:Disable()
	oBotaoPul:Disable()
	oBotaoGrf:Disable()
	If !lRepresent
//		oBotaoIPd:Enable()
	Endif
	oBotaoEcl:Disable()
	oBotaoCnt:Disable()
	oBotaoIns:Disable()
	oBotaoPos:Disable()
	
//	oBotaoFin:Disable()
//	oBotaoHun:Disable()
	oBotaoHis:Disable()
	oBotaoCPD:Disable()        
//	oBotaoAPd:Disable()
	oBotaoPsq:Enable()
	oDtCiclos:Enable()

	oSay1:cCaption := ''
	oSay2:cCaption := ''
Else

	aCiclos[nPos,2]:="1"
                       
	oBotaoCPD:Enable()
//	oBotaoAPd:Enable()
	oBotaoPed:Enable()
	oBotaoPul:Enable()
	oBotaoGrf:Enable()
	//?oBotaoIPd:Disable()
	oBotaoEcl:Enable()
	oBotaoCnt:Enable()
	oBotaoIns:Enable()
	oBotaoPos:Enable()
//	oBotaoFin:Enable()
//	oBotaoHun:Enable()
	oBotaoHis:Enable()
	oBotaoPsq:Disable()
//	oDtCiclos:Disable()
//	oBotaoSai:cCaption := '&Lib.Tela'

	SA1->(dbSetOrder(1), dbSeek(xFilial("SA1")+aCiclos[nPos,4]+aCiclos[nPos,5]))
	
	oSay1:cCaption := '('+SA1->A1_COD+'/'+SA1->A1_LOJA+') - '+Capital(SA1->A1_NOME) 
	oSay2:cCaption := "("+SA1->A1_DDD+') '+SA1->A1_TEL+' - '+SA1->A1_EMAIL 

	For nI := 1 To Len(aCiclos)
		If nI <> nPos
			aCiclos[nI,2] := '2'
		Endif
	Next
Endif 
oBotaoPed:Refresh()
oBotaoPul:Refresh()
oBotaoGrf:Refresh()
//oBotaoIPd:Refresh()
oBotaoEcl:Refresh()
oBotaoCnt:Refresh()
oBotaoIns:Refresh()
oBotaoPos:Refresh()
//oBotaoFin:Refresh()
//oBotaoHun:Refresh()
oBotaoHis:Refresh()
oBotaoPsq:Refresh()
oDtCiclos:Refresh()
oBotaoCPD:Refresh()
//oBotaoAPd:Refresh()
oRcp5:Refresh()
oSay1:Refresh()
oSay2:Refresh()
Return .t.       

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ PedCli() บAutor  ณ Luiz Alberto      บ Data ณ  26/11/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Mostra os 10 Ultimos Pedidos Gerados do Cliente Marcado
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function PedCli(cCodigo,cLoja)
Local aArea := GetArea()
Local cQuery	:= ''
Local aPedidos	:= {{'','','',0.00}}
Local oRcp5
Local nOpc
Local oBotaoSai

// Localiza Vetor Marcado
nPos := 0;For nI := 1 To Len(aCiclos);If aCiclos[nI,2]=='1';nPos	:=	nI;Exit;Endif;Next

If Empty(nPos)
	Return .f.
Endif

cCodigo	:=	aCiclos[nPos,DT_CODIGO]
cLoja	:=	aCiclos[nPos,DT_LOJA]

If aCiclos[nPos,DT_MARCA] <> '1'
	Alert("Aten็ใo Posicione-se no Registro Marcado !")
	Return .f.
Endif

SZ4->(dbGoTo(aCiclos[nPos,DT_RECNO]))
SA1->(dbGoTo(aCiclos[nPos,DT_RECNO2]))

If !SA1->(dbSetOrder(1), dbSeek(xFilial("SA1")+cCodigo+cLoja))
	Alert("Aten็ใo Cliente Nใo Localizado !!!")
	Return .f.
Endif

cQuery := 	 " SELECT TOP 10 * "
cQuery +=	 " FROM " + RetSqlName("SC5") + " SC5 (NOLOCK) "
cQuery +=	 " WHERE  C5_FILIAL = '" + xFilial("SC5") + "' "
cQuery +=	 " AND SC5.D_E_L_E_T_ = '' "      
cQuery +=	 " AND SC5.C5_CLIENTE = '" + cCodigo + "' "
cQuery +=	 " AND SC5.C5_LOJACLI = '" + cLoja + "' "
cQuery +=	 " AND SC5.C5_TIPO = 'N' "
cQuery +=	 " ORDER BY C5_EMISSAO DESC "       //
	
TCQUERY cQuery NEW ALIAS "CHK1"

TcSetField('CHK1','C5_EMISSAO','D')

Count To nReg

CHK1->(dbGoTop())

dbSelectArea("CHK1")
dbGoTop()    
ProcRegua(nReg)     

If !Empty(nReg)
	aPedidos	:= {}
Else
	MsgStop("Cliente Nใo Possui Pedidos Gerados Anteriormente !")
	CHK1->(dbCloseArea())
	Return .f.
Endif

While CHK1->(!Eof())
	IncProc("Aguarde Localizando Ultimos 10 Pedidos do Cliente ")
	
	nTotal := 0.00   
	nQuant := 0.00
	cPedido:= ''
	If SC6->(dbSetOrder(1), dbSeek(xFilial("SC6")+CHK1->C5_NUM))
		cPedido	:=	SC6->C6_NUM
		AAdd(aPedidos,{ SC6->C6_NOTA,;					// 1
						cPedido,;                          // 2
						DtoC(CHK1->C5_EMISSAO),;           // 3
						CHK1->C5_CONDPAG,;                    // 4    
						'',;	// Produto                    5
						'',;	// Descricao                  6
						'',;	// Unidade                    7
						'',;	// Quantidade                 8
						'',;	// Unitario                   9
						'',;	// Total                      10
						cPedido})                          // 11

		While SC6->(!Eof()) .And. SC6->C6_FILIAL == xFilial("SC6") .And. SC6->C6_NUM == CHK1->C5_NUM
			SB1->(dbSetOrder(1), dbSeek(xFilial("SB1")+SC6->C6_PRODUTO))
			
			aPedidos[Len(aPedidos),5] := SC6->C6_PRODUTO
			aPedidos[Len(aPedidos),6] := SB1->B1_DESC
			aPedidos[Len(aPedidos),7] := SB1->B1_UM
			aPedidos[Len(aPedidos),8] := TransForm(SC6->C6_QTDVEN,"999,999,999")
			aPedidos[Len(aPedidos),9] := TransForm(SC6->C6_PRCVEN,"@E 9,999,999.99")
			aPedidos[Len(aPedidos),10] := TransForm(SC6->C6_VALOR,"@E 999,999,999.99")
			
			nQuant += SC6->C6_QTDVEN
			nTotal += SC6->C6_VALOR
		
			SC6->(dbSkip(1))

			If (SC6->(!Eof()) .And. SC6->C6_FILIAL == xFilial("SC6") .And. SC6->C6_NUM == CHK1->C5_NUM)
				AAdd(aPedidos,{ '',;					// 1
								'',;                          // 2
								'',;           // 3
								'',;                    // 4    
								'',;	// Produto                    5
								'',;	// Descricao                  6
								'',;	// Unidade                    7
								'',;	// Quantidade                 8
								'',;	// Unitario                   9
								'',;	// Total                      10
								cPedido})                          // 11
			Endif
		Enddo

		AAdd(aPedidos,{ '',;					// 1
						'',;                          // 2
						'',;           // 3
						'',;                    // 4    
						'Total ('+cPedido+'):',;	// Produto                    5
						'',;	// Descricao                  6
						'',;	// Unidade                    7
						'',;	// Quantidade                 8
						'',;	// Unitario                   9
						'',;	// Total                      10
						cPedido})

		aPedidos[Len(aPedidos),8] := TransForm(nQuant,"999,999,999")
		aPedidos[Len(aPedidos),10] := TransForm(nTotal,"@E 999,999,999.99")
	Endif	
	CHK1->(dbSkip(1))
Enddo
CHK1->(dbCloseArea())
					



DEFINE MSDIALOG oRcp5 TITLE "10 ฺltimos Pedidos - Cliente: " + SA1->A1_COD +'/'+ SA1->A1_LOJA + ' - ' + Capital(AllTrim(SA1->A1_NOME)) FROM 000, 000  TO 300, 900 COLORS 0, 16777215 PIXEL 

    @ 010, 005 LISTBOX oPdCli Fields HEADER 'Nota',"Num.Pedido",'Emissใo',"Cond Pagto",'Produto','Quant.','Unitแrio',"Valor Total" SIZE 430, 120 OF oRcp5 PIXEL //ColSizes 50,50

    oPdCli:SetArray(aPedidos)
    oPdCli:bLine := {|| {		aPedidos[oPdCli:nAt,1],;
        						aPedidos[oPdCli:nAt,2],;
      							aPedidos[oPdCli:nAt,3],;
      							aPedidos[oPdCli:nAt,4],;
      							aPedidos[oPdCli:nAt,5],;
					      		aPedidos[oPdCli:nAt,8],;
					      		aPedidos[oPdCli:nAt,9],;
					      		aPedidos[oPdCli:nAt,10]}}

	nOpc := 0
	
  	@ 135, 005 BUTTON oBotaoVis PROMPT "Visualizar"			ACTION (VerPed(aPedidos[oPdCli:nAt,11])) SIZE 050, 010 OF oRcp5 PIXEL
    @ 135, 055 BUTTON oBotaoSai PROMPT "&Sair"	 			ACTION (Close(oRcp5),nOpc:=0) SIZE 050, 010 OF oRcp5 PIXEL
	  
	If Empty(nReg)
		oBotaoVis:Disable()
	Else
		oBotaoVis:Enable()
	Endif


	ACTIVATE MSDIALOG oRcp5 CENTERED //ON INIT EnchoiceBar(oRcp,{||If(oGet:Tud_oOk(),_nOpca:=1,_nOpca:=0)},{||oRcp:End()})
	
	If nOpc == 1
	Endif

RestArea(aArea)
Return .t.



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ InsData() บAutor  ณ Luiz Alberto      บ Data ณ  26/11/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Altera data para Novo Ciclo de Contato
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function InsData(cCodigo,cLoja)
Local aArea := GetArea()
Local oDlg

// Localiza Vetor Marcado
nPos := 0;For nI := 1 To Len(aCiclos);If aCiclos[nI,2]=='1';nPos	:=	nI;Exit;Endif;Next

If Empty(nPos)
	Return .f.
Endif


dDtCiclo	:= aCiclos[nPos,DT_DTCICLO]

If aCiclos[nPos,DT_MARCA] <> '1'
	Alert("Aten็ใo Posicione-se no Registro Marcado !")
	Return .f.
Endif

If !SA1->(dbSetOrder(1), dbSeek(xFilial("SA1")+cCodigo+cLoja))
	Alert("Aten็ใo Cliente Nใo Localizado !!!")
	Return .f.
Endif

SZ4->(dbGoTo(aCiclos[nPos,DT_RECNO]))

@ 150,1 TO 260,500 DIALOG oDlg TITLE "Nova Data Contato * Ciclo *"

@ 015,020 SAY "Informe a Nova Data: " OF oDlg PIXEL
@ 015,090 GET dDtCiclo	Picture "99/99/9999" Valid (!Empty(dDtCiclo) .And. dDtCiclo>=dDataBase .And. dDtCiclo<=(dDataBase+365) .And. fVldDt(dDtCiclo))	SIZE 60, 10 OF oDlg PIXEL
		
@ 040,160 BMPBUTTON TYPE 01 ACTION (GravDados(nPos), oDlg:End())
@ 040,210 BMPBUTTON TYPE 02 ACTION oDlg:End()
		
Activate Dialog oDlg Centered

RestArea(aArea)
Return	

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ GravDados() บAutor  ณ Luiz Alberto      บ Data ณ  26/11/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Grava Data Novo Ciclo      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GravDados(nPos)
Local aArea := GetArea()

xDtCiclo	:=	DataValida(dDtCiclo,.T.)

If xDtCiclo <> dDtCiclo
	If !MsgYesNo("Atencao Devido Fins de Semanas e Feriados a Data do Ciclo Ficou Para Dia " + DtoC(xDtCiclo) + ", Confirma ? ",OemToAnsi('ATENCAO'))
		Return .t.
	Endif
Endif

If !AddHis(0,.t.,.t.)
	Alert("ษ Obrigat๓ria a Informa็ใo no Hist๓rico do Cliente, Referente a Inser็ใo de Nova data de Ciclo !")
	Return .f.
Endif

// Registra Log
	                                                                                                                 	
If CicloLog(SZ4->Z4_CLIENTE,SZ4->Z4_LOJA,SZ4->Z4_CLIENTE,SZ4->Z4_LOJA,'Efetuada Grava็ใo de Nova Data de Ciclo, '+DtoC(dDtCiclo)+' !','0003',.t.)	// Inser็ใo de Data Ciclo
	If RecLock("SZ4",.f.)      
		SZ4->Z4_DCLANT	:= SZ4->Z4_CICLO
		SZ4->Z4_CICLO	:= xDtCiclo
		SZ4->Z4_VENCICL	:= xDtCiclo-10
		SZ4->(MsUnlock())
	Endif
Endif

// Retira Cliente da tela de Ciclo e Marca Lido
	
SaiCiclo(nPos,'Processado Nova Data de Ciclo em '+DtoC(dDataBase) + " as " + Time(),'0003')

    oDtCiclos:SetArray(aCiclos)
    oDtCiclos:bLine := {|| {	Iif(aCiclos[oDtCiclos:nAt,DT_MARCA]=="1",oSinalMk,;						//	1
    							U_RetLeg(aCiclos[oDtCiclos:nAt,DT_DTCICLO],oDtCiclos:nAt)),;			//	2
    							Iif(aCiclos[oDtCiclos:nAt,2]=="1",oOk,oNo),;							//	3
        						aCiclos[oDtCiclos:nAt,DT_VENDEDOR],;									//	4	
        						aCiclos[oDtCiclos:nAt,DT_VENCI],;										//	5
        						aCiclos[oDtCiclos:nAt,DT_CICLO],;										//	6
        						aCiclos[oDtCiclos:nAt,DT_CONTRATO],;									//	6
      							aCiclos[oDtCiclos:nAt,DT_CODIGO],;										// 	7
					      		aCiclos[oDtCiclos:nAt,DT_LOJA],;										//	8
					      		aCiclos[oDtCiclos:nAt,DT_NOME],;										//	9
					      		TransForm(aCiclos[oDtCiclos:nAt,DT_UFAT],'@E 9,999,999.99'),;										//	10	
					      		TransForm(aCiclos[oDtCiclos:nAt,DT_TFAT],'@E 99,999,999.99'),;										//	10	
					      		aCiclos[oDtCiclos:nAt,DT_MUN],;										//	9
					      		aCiclos[oDtCiclos:nAt,DT_ULTPED],;										//	10	
					      		aCiclos[oDtCiclos:nAt,DT_MEDIA],;										//	11
					      		aCiclos[oDtCiclos:nAt,DT_ULTCOM],;										//	12
					      		aCiclos[oDtCiclos:nAt,DT_QTDCOM],;										//	13
					      		aCiclos[oDtCiclos:nAt,DT_DDD],;											//	14
					      		aCiclos[oDtCiclos:nAt,DT_TEL],;											//	15
					      		aCiclos[oDtCiclos:nAt,DT_TEL2],;										//	16
					      		aCiclos[oDtCiclos:nAt,DT_TEL3],;										//	17
					      		aCiclos[oDtCiclos:nAt,DT_CONTATO],;										//	18
					      		aCiclos[oDtCiclos:nAt,DT_ULTACAO],;										//	19
					      		aCiclos[oDtCiclos:nAt,DT_DATOCO],;										//	20
					      		aCiclos[oDtCiclos:nAt,DT_CNPJ],;										//	21
					      		aCiclos[oDtCiclos:nAt,DT_RAZAO]}}										//	22
oDtCiclos:Refresh()
Return()


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RepPed() บAutor  ณ Luiz Alberto      บ Data ณ  26/11/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Copia o ฺltimo Pedido Efetuado Pelo Cliente      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function RepPed(cCodigo,cLoja,nPos)
Local aArea := GetArea()
Local aAreaSC5		:= SC5->(GetArea())
Local aAreaSC6		:= SC6->(GetArea())
Local aAreaSC9		:= SC9->(GetArea())
Local aItSC6	:= {}
Local aItSC9	:= {}
Local aItNew	:= {}
Local nRecSC5Atu:= SC5->(Recno())
Local oBotaoSai
Private oSinal1   := LoadBitmap(GetResources(),"BR_VERDE")
Private oSinal2   := LoadBitmap(GetResources(),"BR_VERMELHO")
Private oSinal3   := LoadBitmap(GetResources(),"BR_LARANJA")
Private oSinal4   := LoadBitmap(GetResources(),"BR_AZUL")
Private oSinal5   := LoadBitmap(GetResources(),"BR_ROSA")
Private oSinal6   := LoadBitmap(GetResources(),"BR_CINZA")
Private oSinal7   := LoadBitmap(GetResources(),"BR_AMARELO")
Private oSinal8   := LoadBitmap(GetResources(),"BR_BRANCO")
Private oSinal9   := LoadBitmap(GetResources(),"BR_VERDE")

// Localiza Vetor Marcado
nPos := 0;For nI := 1 To Len(aCiclos);If aCiclos[nI,2]=='1';nPos	:=	nI;Exit;Endif;Next

If Empty(nPos)
	Return .f.
Endif

cQuery := 	 " SELECT TOP 1 * "
cQuery +=	 " FROM " + RetSqlName("SC5") + " SC5 (NOLOCK) "
cQuery +=	 " WHERE  "
cQuery +=	 " C5_FILIAL = '" + xFilial("SC5") + "' "
cQuery +=	 " AND SC5.D_E_L_E_T_ = '' "      
cQuery +=	 " AND SC5.C5_CLIENTE = '" + cCodigo + "' "
cQuery +=	 " AND SC5.C5_LOJACLI = '" + cLoja + "' "
cQuery +=	 " AND SC5.C5_TIPO = 'N' "
cQuery +=	 " ORDER BY C5_EMISSAO DESC "       //
	
TCQUERY cQuery NEW ALIAS "CHK1"

cPedNum	:= CHK1->C5_NUM

CHK1->(dbCloseArea())

If Empty(cPedNum)
	Alert("Nใo Existem Pedidos Gerados para Este Cliente !")
	RestArea(aAreaSC5)
	RestArea(aAreaSC6)
	RestArea(aAreaSC9)
	Return .f.
Endif                  

lContrato := .f.
If SC6->(dbSetOrder(1), dbSeek(xFilial("SC6")+cPedNum))
	While SC6->(!Eof()) .And. SC6->C6_FILIAL == xFilial("SC6") .And. SC6->C6_NUM == cPedNum
		If !Empty(SC6->C6_CONTRAT)
			lContrato := .t.
			Exit
		Endif
		
		SC6->(dbSkip(1))
	Enddo
Endif

If lContrato
	Alert("Aten็ใo o Pedido de Vendas " + cPedNum + " Foi Gerado Atrav้s de Rotina de Contrato de Parceria, Impossํvel Replicar para Or็amento !")
	RestArea(aAreaSC5)
	RestArea(aAreaSC6)
	RestArea(aAreaSC9)
	Return .f.
Endif                  



// Tratamento de Divisใo Pedidos de Vendas com Tipo de Libera็ใo por Item

If SC5->(dbSetOrder(1), dbSeek(xFilial("SC5")+cPedNum))
    
    // Alimenta Todos os Itens do Pedido de Vendas
    If SC6->(dbSetOrder(1), dbSeek(xFilial("SC6")+SC5->C5_NUM))
    	While SC6->(!Eof()) .And. SC6->C6_FILIAL == xFilial("SC6") .And. SC6->C6_NUM == SC5->C5_NUM
    		AAdd(aItSC6,{SC6->C6_ITEM,;
    						SC6->C6_PRODUTO,;
    						Posicione("SB1",1,xFilial("SB1")+SC6->C6_PRODUTO,'B1_DESC'),;
    						SB1->B1_UM,;
    						SC6->C6_QTDVEN,;
    						SC6->C6_TES,;
    						SC6->C6_PRCVEN,;
    						SC6->C6_VALOR,;
    						SC6->C6_LOCAL,;
    						SC6->(Recno())})
    		
    		SC6->(dbSkip(1))
    	Enddo
    Endif

	aItens := {}
	For nIt := 1 To Len(aItSC6)
		AAdd(aItens,{aItSC6[nIt,1],;
						aItSC6[nIt,2],;
						aItSC6[nIt,3],;
						aItSC6[nIt,4],;
						aItSC6[nIt,5],;
						aItSC6[nIt,6],;
						aItSC6[nIt,7],;
						aItSC6[nIt,8],;
						aItSC6[nIt,9]})
	
	Next
	
	lOk:=.f.
		
	DEFINE MSDIALOG oItensPed5 TITLE "Itens do Pedido " + SC5->C5_NUM + " de " + DtoC(SC5->C5_EMISSAO) FROM 000, 000  TO 250, 820 COLORS 0, 16777215 PIXEL Style DS_MODALFRAME 
	oItensPed5:lEscClose := .F. //Nใo permite sair ao usuario se precionar o ESC
		
    @ 010, 005 LISTBOX oItens Fields HEADER "Item","Codigo","Descri็ใo",'Un',"Qtde",'TES','Vlr.Unitario','Vlr Total' SIZE 400, 080 OF oItensPed5 PIXEL ColSizes 50,50
		
    oItens:SetArray(aItens)
    oItens:bLine := {|| {	aItens[oItens:nAt,1],;
      						aItens[oItens:nAt,2],;
					      	aItens[oItens:nAt,3],;
					      	aItens[oItens:nAt,4],;
					      	TransForm(aItens[oItens:nAt,5],'@E 9,999.999'),;
					      	aItens[oItens:nAt,6],;
					      	TransForm(aItens[oItens:nAt,7],'@E 9,999.99'),;
					      	TransForm(aItens[oItens:nAt,8],'@E 999,999.99')}}
		
  	@ 100, 005 BUTTON oBotaoCnf PROMPT "&Continua" 			ACTION (lOk:=.t.,Close(oItensPed5)) 	SIZE 080, 010 OF oItensPed5 PIXEL
    @ 100, 105 BUTTON oBotaoSai PROMPT "&Cancela" 			ACTION (lOk:=.f.,Close(oItensPed5)) 	SIZE 080, 010 OF oItensPed5 PIXEL
			
	ACTIVATE MSDIALOG oItensPed5 CENTERED //ON INIT EnchoiceBar(oRcp,{||If(oGet:Tud_oOk(),_nOpca:=1,_nOpca:=0)},{||oRcp:End()})
			
	If !lOk
		RestArea(aAreaSC5)
		RestArea(aAreaSC6)
		RestArea(aAreaSC9)
		Return .f.
	Endif

	nRecSC5 := SC5->(Recno())
	
	lRet := .f.
	MsAguarde({||IncPed(cPedNum,@lRet)},'Aguarde Copiando ฺltimo Pedido de Vendas...')

    // Retira Cliente da tela de Ciclo e Marca Lido
	
	If lRet
		SZ4->(dbGoTo(aCiclos[nPos,DT_RECNO]))
		SA1->(dbGoTo(aCiclos[nPos,DT_RECNO2]))

		// Registra Log

		If CicloLog(SZ4->Z4_CLIENTE,SZ4->Z4_LOJA,SZ4->Z4_CLIENTE,SZ4->Z4_LOJA,'Pedido Replicado No. ' + SC5->C5_NUM + ' - Pulo de Ciclo para : ' + DtoC(SZ4->Z4_CICLO),'0002',.t.)	
			// Bloqueando Altera็ใo de Cliente no Pedido Originado de R้plica
			If RecLock("SC5",.f.)
				SC5->C5_REPLI := 'S'
				SC5->(MsUnlock())
			Endif
			dDtCiclo	:=	SZ4->Z4_CICLO + SZ4->Z4_MCICLO
			xDtCiclo	:=	DataValida(dDtCiclo,.T.)
						
			// Muda Ciclo do Cliente
			If RecLock("SZ4",.f.)
				SZ4->Z4_CICLO	:= xDtCiclo
				SZ4->Z4_VENCICL	:= xDtCiclo-10
				SZ4->(MsUnlock())
			Endif
		Endif
		
		SaiCiclo(nPos,'Processado R้plica Ultimo Pedido em '+DtoC(dDataBase) + " as " + Time(),'0002')
	Endif

	SC5->(dbGoTo(nRecSC5))				
Endif

SC5->(dbGoTo(nRecSC5Atu))

RestArea(aAreaSC5)
RestArea(aAreaSC6)
RestArea(aAreaSC9)
Return .t.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ LibTel() บAutor  ณ Luiz Alberto      บ Data ณ  26/11/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Libera Marcacao de Cliente e Browse para Nova Marca็ใo
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function LibTel(cMarca,nPos)
// Localiza Vetor Marcado
nPos := 0;For nI := 1 To Len(aCiclos);If aCiclos[nI,2]=='1';nPos	:=	nI;Exit;Endif;Next

If cMarca == '1'
	aCiclos[nPos,2]:="2"
                       
	oBotaoCPD:Disable()
//	oBotaoAPd:Disable()
	oBotaoPed:Disable()
	oBotaoPul:Disable()
	oBotaoGrf:Disable()
	oBotaoEcl:Disable()
	oBotaoCnt:Disable()
	oBotaoIns:Disable()
	oBotaoPos:Disable()
//	oBotaoFin:Disable()
//	oBotaoHun:Disable()
	oBotaoHis:Disable()
	oDtCiclos:Enable()
	oBotaoPsq:Enable()
	If !lRepresent
//		oBotaoIPd:Enable()
	Endif
	oRcp5:Refresh()   
	oBotaoPsq:Refresh()
//	oBotaoIPd:Refresh()
Else    
	If MsgYesNo("Deseja Realmente Sair da Tela de Ciclo ? ",OemToAnsi('ATENCAO'))
		Close(oRcp5)
	Endif
Endif
Return .t.
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณ VerPed   ณAutor ณ Luiz Alberto            ณDataณ 06/09/14 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescriao ณ Visualiza็ใo dos Pedidos de Vendas 						  ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function VerPed(cNumPed)
Local aArea := GetArea()

aRotina	:= {{ "Pesquisar"  	,"AxPesqui"        	,0,1 },; 	// "Pesquisar"
			{ "Visualizar"	,"TK271CallCenter" 	,0,2 },; 	// "Visualizar"
			{ "Incluir"  	,"TK271CallCenter" 	,0,3 },; 	// "Incluir"
			{ "Legenda" 	,"U_MeLegen()"	   	,0,2 }} 	// "Imprime Or็amento"   						
			
If SC5->(dbSetOrder(1), dbSeek(xFilial("SC5")+cNumPed))
	DbSelectArea("SC5") ; DbSetOrder(1)
	A410Visual( Alias() , SC5->(Recno()) , 2 ) //Visualiza็ใo do pedido de vendas
Else
	Alert("Pedido de Venda " + cNumPed + " Nใo Localizado !!!")
Endif
RestArea(aArea)
Return .t.
		
		
		


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuncao    IncPed   ณ Autor ณ Luiz Alberto        ณ Data ณ29.11.2014ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Inclusใo Automatica de Pedidos de Vendas e Tela de Inclusใoณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณRetorno   ณ Nenhum                                                     ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function IncPed(cPedNum,lRet)
Local aArea := GetArea()
Local cNumOrc := TkNumero('SUA','UA_NUM')

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณPosiciona registros                                                     ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
SC5->(dbSetOrder(1), dbSeek(xFilial("SC5")+cPedNum))
	
Begin Transaction

If RecLock('SUA',.T.)
	SUA->UA_FILIAL 	:= xFilial('SUA')
	SUA->UA_NUM 	:= TkNumero('SUA','UA_NUM')
	SUA->UA_OPERADO := Posicione('SU7',4,xFilial('SU7')+__cUserID,'U7_COD')                                                
	SUA->UA_CLIENTE := SA1->A1_COD
	SUA->UA_LOJA 	:= SA1->A1_LOJA
	SUA->UA_XCLIENT	:= SA1->A1_COD
	SUA->UA_XLOJAEN	:= SA1->A1_LOJA
	SUA->UA_NOMECLI := SA1->A1_NOME
	SUA->UA_TMK 	:= '1'
	SUA->UA_OPER 	:= '2'
	SUA->UA_CLIPROS	:= '1'
	SUA->UA_DTLIM	:= dDataBase
	SUA->UA_ESPECI1	:= SC5->C5_ESPECI1
	SUA->UA_VOLUME1	:= SC5->C5_VOLUME1
	SUA->UA_FECENT	:= dDataBase
	SUA->UA_VEND 	:= SA1->A1_VEND	
	SUA->UA_REGIAO	:= SA1->A1_REGIAO
	SUA->UA_OBSCLI	:= ALLTRIM(SA1->A1_OBSERV)                                                                             
	SUA->UA_MENPAD	:= SA1->A1_MENSAGE                                                                                     
	SUA->UA_XMENNOT	:= iF(Empty(SA1->A1_SUFRAMA),"","COD. SUFRAMA: "+SA1->(ALLTRIM(A1_SUFRAMA)))                           
	SUA->UA_EMISSAO := dDatabase
	SUA->UA_CONDPG 	:= SC5->C5_CONDPAG
	SUA->UA_STATUS 	:= 'SUP'
	SUA->UA_LIBERA	:= ''
	SUA->UA_TIPLIB	:= '1'
	SUA->UA_ENDCOB 	:= SA1->A1_ENDCOB
	SUA->UA_BAIRROC := SA1->A1_BAIRROC
	SUA->UA_CEPC 	:= SA1->A1_CEPC
	SUA->UA_MUNC 	:= SA1->A1_MUNC
	SUA->UA_ESTC 	:= SA1->A1_ESTC
	SUA->UA_ENDENT 	:= SA1->A1_ENDENT
	SUA->UA_BAIRROE := SA1->A1_BAIRROE
	SUA->UA_CEPE 	:= SA1->A1_CEPE
	SUA->UA_MUNE 	:= SA1->A1_MUNE
	SUA->UA_ESTE 	:= SA1->A1_ESTE
	SUA->UA_TRANSP 	:= SA1->A1_TRANSP
	SUA->UA_TPFRETE := SA1->A1_TPFRET
	SUA->UA_PROSPEC := .F.
	
	cVend1 := SC5->C5_VEND1
	cVend2 := SC5->C5_VEND2
	cVend3 := SC5->C5_VEND3
	nComi1 := SC5->C5_COMIS1
	nComi2 := SC5->C5_COMIS2
	nComi3 := SC5->C5_COMIS3

	SUA->UA_VEND  := cVend1
	SUA->UA_COMIS := nComi1
	SUA->UA_VEND2 := cVend2
	SUA->UA_COMIS2:= nComi2
	SUA->UA_VEND3 := cVend3
	SUA->UA_COMIS3:= nComi3
	SUA->(MsUnlock())
Endif
			
// Gerando Itens
		
nTotal := 0.00
If SC6->(dbSetOrder(1), dbSeek(xFilial("SC6")+SC5->C5_NUM))
	While SC6->(!Eof()) .And. xFilial("SC6")==SC6->C6_FILIAL .And. SC6->C6_NUM == SC5->C5_NUM
		MsProcTxt('Aguarde Gerando Or็amento -> ' + SC6->C6_ITEM)
			
		SB1->(DbSeek(xFilial('SB1')+SC6->C6_PRODUTO))
		SF4->(DbSeek(xFilial('SB1')+SC6->C6_TES))
	
		If RecLock('SUB',.T.)
			SUB->UB_FILIAL 		:= xFilial("SUB")
			SUB->UB_ITEM 		:= SC6->C6_ITEM
			SUB->UB_NUM 		:= SUA->UA_NUM
			SUB->UB_PRODUTO		:= SC6->C6_PRODUTO
			SUB->UB_QUANT 		:= SC6->C6_QTDVEN
			SUB->UB_VRUNIT 		:= SC6->C6_PRCVEN
			SUB->UB_VLRITEM		:= Round(SC6->C6_PRCVEN * SC6->C6_QTDVEN,2)
			SUB->UB_UM 			:= SB1->B1_UM
			SUB->UB_DTENTRE		:= dDataBase++
			cTes := SC6->C6_TES

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Define o CFO                                         ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			SF4->(dbSetOrder(1), dbSeek(xFilial("SF4")+cTes))
			aDadosCFO := {}
		 	Aadd(aDadosCfo,{"OPERNF","S"})
		 	Aadd(aDadosCfo,{"TPCLIFOR",SA1->A1_TIPO})
		 	Aadd(aDadosCfo,{"UFDEST"  ,SA1->A1_EST})
		 	Aadd(aDadosCfo,{"INSCR"   ,SA1->A1_INSCR})
						
			cCfop := MaFisCfo(,SF4->F4_CF,aDadosCfo)
			SUB->UB_TES 		:= cTes
			SUB->UB_CF			:= cCfop
			SUB->UB_LOCAL 		:= SC6->C6_LOCAL  
			SUB->UB_PRCTAB 		:= SC6->C6_PRCVEN
			SUB->UB_XLACRE		:= SC6->C6_XLACRE
			SUB->UB_XAPLIC		:= SC6->C6_XAPLC
			SUB->UB_XEMBALA		:= SC6->C6_XEMBALA
			SUB->UB_XVOLITE		:= SC6->C6_XVOLITE
			SUB->UB_XAPLICA		:= SC6->C6_XAPLICA
			SUB->UB_OPC			:= SC6->C6_OPC
			SUB->UB_XSTAND		:= SC6->C6_XSTAND
			SUB->UB_XPBITEM		:= SC6->C6_XPBITEM
			SUB->UB_XPLITEM		:= SC6->C6_XPLITEM
			SUB->UB_XQTDEMB		:= SC6->C6_XQTDEMB
			SUB->UB_FCICOD		:= SC6->C6_FCICOD
			SUB->UB_ITEMCLI		:= SC6->C6_ITEMCLI
			SUB->(MsUnlock())
		Endif

		nTotal += Round(SC6->C6_PRCVEN * SC6->C6_QTDVEN,2)

		SC6->(dbSkip(1))
	Enddo 
Endif
			
// Gera Tabela da Forma de Pagamento Vencimento

If SE4->(dbSetOrder(1), dbSeek(xFilial("SE4")+SUA->UA_CONDPG))
	aCondicao := Condicao(nTotal,SUA->UA_CONDPG,,dDataBase)
	
	If !SL4->(dbSetOrder(1), DbSeek(xFilial("SL4")+SUA->UA_NUM))
		For nPg := 1 To Len(aCondicao)
			If RecLock("SL4",.T.)
				SL4->L4_FILIAL 	:= xFilial("SL4")
				SL4->L4_NUM		:= SUA->UA_NUM
				SL4->L4_DATA	:= aCondicao[nPg,1]
				SL4->L4_VALOR	:= aCondicao[nPg,2]            
				SL4->L4_FORMA	:= SE4->E4_FORMA
				SL4->L4_ORIGEM	:= 'SIGATMK'
				SL4->(MsUnlock())
			Endif
		Next
	Endif
Endif
End Transaction

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Restaura a integridade da rotina                                    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

MsgInfo("Or็amento -> "+SUA->UA_NUM + " Gerado com Sucesso !!!")

RestArea(aArea)
Return lRet
		
		
		
Static Function CicloLog(cCliente,cLoja,cCliProd,cLojPrd,cAcao,cMotivo,lDuplica)
Local aArea := GetArea()
Local aAreaSA1 := SA1->(GetArea())

DEFAULT lDuplica := .f.

If lDuplica	// Duplica Registro na Tabela SZ4 a cada Baixa
	aDados := {}
	For nI := 1 To SZ4->(FCount())
		AAdd(aDados, {SZ4->(FieldName(nI)),SZ4->(FieldGet(nI))} )
	Next
	If RecLock("SZ4",.t.)
		For nI := 1 To Len(aDados)
    		If aDados[nI,1]=='Z4_FILIAL'
    			SZ4->Z4_FILIAL := xFilial("SZ4")
    		Else
				nPos := SZ4->(FieldPos(aDados[nI,1]))
				SZ4->(FieldPut(nPos,aDados[nI,2]))
			Endif
		Next                   
		SZ4->Z4_CODMOT  :=  cMotivo
		SZ4->Z4_DATOCO	:=	dDataBase
		SZ4->(MsUnlock())
	Endif  
Endif

// Gravacao de Log de Acao em Cada Processo da Tela de Ciclo Importante

dbSelectArea("SZ5")
dbSetOrder(1)                                                          

cIdLog	:=	GetSx8Num("SZ5","Z5_ID")
ConfirmSx8()

If RecLock("SZ5",.t.)
	SZ5->Z5_FILIAL	:=	xFilial("SZ5")
	SZ5->Z5_ID		:=	cIdLog
	SZ5->Z5_CLIENTE	:=	cCliente
	SZ5->Z5_LOJA	:=	cLoja     
	SZ5->Z5_NOMCLI	:=	Posicione("SA1",1,xFilial("SA1")+cCliente+cLoja,"A1_NOME")
//	SZ5->Z5_CLIPROD	:=	cCliProd
//	SZ5->Z5_LOJPRD	:=	cLojPrd
//	SZ5->Z5_NOMPRD	:=	Posicione("SA1",1,xFilial("SA1")+cCliProd+cLojPrd,"A1_NOME")
	SZ5->Z5_DATA	:=	dDataBase
	SZ5->Z5_HORA	:=	Time()      
	SZ5->Z5_USER	:=	__cUserId
	SZ5->Z5_NOMUSR	:=	Capital(USRRETNAME(__cUserId))
	SZ5->Z5_ACAO	:=	cAcao
	SZ5->Z5_CODMOT  :=  cMotivo
	SZ5->(MsUnlock())                                 
Else
	Alert("Aten็ใo Falha na Inclusใo do Log de Ciclo !")
	Return .f.
Endif              

RestArea(aArea)
RestArea(aAreaSA1)
Return .t.
	




		
Static Function SaiCiclo(nPos,cAcao,cMotivo)
Local aArea	:=	GetArea()

// Localiza Vetor Marcado
nPos := 0;For nI := 1 To Len(aCiclos);If aCiclos[nI,2]=='1';nPos	:=	nI;Exit;Endif;Next

If Empty(nPos)
	Return .f.
Endif

If !Empty(nPos)
	SZ4->(dbGoTo(aCiclos[nPos,DT_RECNO]))
	SA1->(dbGoTo(aCiclos[nPos,DT_RECNO2]))
	
	If RecLock("SZ4",.f.)
		SZ4->Z4_ATIVO	:=	'N'    
		SZ4->Z4_CODMOT	:=	cMotivo
		SZ4->Z4_DATOCO	:=	dDataBase
		SZ4->(MsUnlock())
	Endif
	
	If RecLock("SA1",.f.)
		SA1->A1_ULTACAO	:=	cAcao
		SA1->(MsUnlock())
	Endif
	
	Adel(aCiclos,nPos)
	ASize(aCiclos,Len(aCiclos)-1)
Endif

    oDtCiclos:SetArray(aCiclos)
    oDtCiclos:bLine := {|| {	Iif(aCiclos[oDtCiclos:nAt,DT_MARCA]=="1",oSinalMk,;						//	1
    							U_RetLeg(aCiclos[oDtCiclos:nAt,DT_DTCICLO],oDtCiclos:nAt)),;			//	2
    							Iif(aCiclos[oDtCiclos:nAt,2]=="1",oOk,oNo),;							//	3
        						aCiclos[oDtCiclos:nAt,DT_VENDEDOR],;									//	4	
        						aCiclos[oDtCiclos:nAt,DT_VENCI],;										//	5
        						aCiclos[oDtCiclos:nAt,DT_CICLO],;										//	6
        						aCiclos[oDtCiclos:nAt,DT_CONTRATO],;									//	6
      							aCiclos[oDtCiclos:nAt,DT_CODIGO],;										// 	7
					      		aCiclos[oDtCiclos:nAt,DT_LOJA],;										//	8
					      		aCiclos[oDtCiclos:nAt,DT_NOME],;										//	9
					      		TransForm(aCiclos[oDtCiclos:nAt,DT_UFAT],'@E 9,999,999.99'),;										//	10	
					      		TransForm(aCiclos[oDtCiclos:nAt,DT_TFAT],'@E 99,999,999.99'),;										//	10	
					      		aCiclos[oDtCiclos:nAt,DT_MUN],;										//	9
					      		aCiclos[oDtCiclos:nAt,DT_ULTPED],;										//	10	
					      		aCiclos[oDtCiclos:nAt,DT_MEDIA],;										//	11
					      		aCiclos[oDtCiclos:nAt,DT_ULTCOM],;										//	12
					      		aCiclos[oDtCiclos:nAt,DT_QTDCOM],;										//	13
					      		aCiclos[oDtCiclos:nAt,DT_DDD],;											//	14
					      		aCiclos[oDtCiclos:nAt,DT_TEL],;											//	15
					      		aCiclos[oDtCiclos:nAt,DT_TEL2],;										//	16
					      		aCiclos[oDtCiclos:nAt,DT_TEL3],;										//	17
					      		aCiclos[oDtCiclos:nAt,DT_CONTATO],;										//	18
					      		aCiclos[oDtCiclos:nAt,DT_ULTACAO],;										//	19
					      		aCiclos[oDtCiclos:nAt,DT_DATOCO],;										//	20
					      		aCiclos[oDtCiclos:nAt,DT_CNPJ],;										//	21
					      		aCiclos[oDtCiclos:nAt,DT_RAZAO]}}										//	22

oDtCiclos:Refresh()
oBotaoCPD:Disable()
//oBotaoAPd:Disable()
oBotaoPed:Disable()
oBotaoPul:Disable()
oBotaoGrf:Disable()
oBotaoEcl:Disable()
oBotaoCnt:Disable()
oBotaoIns:Disable()
oBotaoPos:Disable()
//oBotaoFin:Disable()
//oBotaoHun:Disable()
oBotaoHis:Disable()
oDtCiclos:Enable()
If !lRepresent
//	oBotaoIPd:Enable()
Endif
oBotaoPsq:Enable()
oRcp5:Refresh()
RestArea(aArea)
Return .t.			



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ PulCic() บAutor  ณ Luiz Alberto      บ Data ณ  26/11/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Efetua Salto da Data de Ciclo + A Media do Ult Processamentoบฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function PulCic(cCodigo,cLoja,nPos)
Local aArea := GetArea()

// Localiza Vetor Marcado
nPos := 0;For nI := 1 To Len(aCiclos);If aCiclos[nI,2]=='1';nPos	:=	nI;Exit;Endif;Next

If Empty(nPos)
	Return .f.
Endif


SZ4->(dbGoTo(aCiclos[nPos,DT_RECNO]))

If MsgYesNo("Confirma o Pulo de Ciclo do Cliente " + AllTrim(SZ4->Z4_NOME) + " Para " + DtoC(SZ4->Z4_CICLO + SZ4->Z4_MCICLO)+" ? ",OemToAnsi('ATENCAO'))
	dDtCiclo	:=	(SZ4->Z4_CICLO + SZ4->Z4_MCICLO)
	xDtCiclo	:=	DataValida(dDtCiclo,.T.)

	If xDtCiclo <> dDtCiclo
		If !MsgYesNo("Atencao Devido Fins de Semanas e Feriados a Data do Ciclo Ficou Para Dia " + DtoC(xDtCiclo) + ", Confirma ? ",OemToAnsi('ATENCAO'))
			Return .t.
		Endif
	Endif

	If !AddHis(0,.t.,.t.)
		Alert("ษ Obrigat๓ria a Informa็ใo no Hist๓rico do Cliente, Referente ao Pulo de Ciclo !")
		Return .f.
	Endif

	// Registra Log
	
	If CicloLog(SZ4->Z4_CLIENTE,SZ4->Z4_LOJA,SZ4->Z4_CLIENTE,SZ4->Z4_LOJA,'Efetuado Pulo de Ciclo do Cliente com Sucesso !','0001',.t.)	
		If RecLock("SZ4",.f.)                                        
			SZ4->Z4_DCLANT	:=	SZ4->Z4_CICLO
			SZ4->Z4_CICLO	:=	xDtCiclo
			SZ4->Z4_VENCICL	:=	xDtCiclo-10
			SZ4->(MsUnlock())
		Endif
	Endif
	
    // Retira Cliente da tela de Ciclo e Marca Lido
	
	SaiCiclo(nPos,'Processado Salto de Ciclo em '+DtoC(dDataBase) + " as " + Time(),'0001')
Endif

RestArea(aArea)
Return .t.



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ EscHun() บAutor  ณ Luiz Alberto      บ Data ณ  26/11/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Efetua a Escalada do Cliente para seu Hunter               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function EscHun(cCodigo,cLoja,nPos)
Local aArea := GetArea()

// Localiza Vetor Marcado
nPos := 0;For nI := 1 To Len(aCiclos);If aCiclos[nI,2]=='1';nPos	:=	nI;Exit;Endif;Next


If Empty(nPos)
	Return .f.
Endif


SZ4->(dbGoTo(aCiclos[nPos,DT_RECNO]))

If MsgYesNo("Confirma Escala Hunter do Cliente " + AllTrim(SZ4->Z4_NOME) +" ? ",OemToAnsi('ATENCAO'))
	// Registra Log
	
	If CicloLog(SZ4->Z4_CLIENTE,SZ4->Z4_LOJA,SZ4->Z4_CLIENTE,SZ4->Z4_LOJA,'Escalado HUNTER com Sucesso !','0006',.t.)	
		If RecLock("SZ4",.f.)
			SZ4->Z4_ESCHUN	:=	"S"
			SZ4->(MsUnlock())
		Endif
	Endif	

    // Retira Cliente da tela de Ciclo e Marca Lido
	
	SaiCiclo(nPos,'Processado Escala Hunter em '+DtoC(dDataBase) + " as " + Time(),'0006')
Endif

RestArea(aArea)
Return .t.





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fTelaMemoบAutor  ณ Felipe A. Melo       Data ณ  11/05/201  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Histor(cCodigo,cLoja,nPos)
Local aArea := GetArea()
Local oBotaoSai
Local oBotaoVis
Local oBotaoAdd
Private aHistor	:= {{'','','','',0}}
Private oHsCli
Private oRcp5

// Localiza Vetor Marcado
nPos := 0;For nI := 1 To Len(aCiclos);If aCiclos[nI,2]=='1';nPos	:=	nI;Exit;Endif;Next


If Empty(nPos)
	Return .f.
Endif


SZ4->(dbGoTo(aCiclos[nPos,DT_RECNO]))
SA1->(dbGoTo(aCiclos[nPos,DT_RECNO2]))

MontaHistor(@aHistor)

DEFINE MSDIALOG oRcp5 TITLE "Hist๓rico do Cliente: " + SZ4->Z4_CLIENTE +'/'+ SZ4->Z4_LOJA + ' - ' + Capital(AllTrim(SZ4->Z4_NOME)) FROM 000, 000  TO 300, 800 COLORS 0, 16777215 PIXEL 

    @ 010, 005 LISTBOX oHsCli Fields HEADER "Data",'Hora',"Inicio Hist๓rico","Usuแrio" SIZE 395, 120 OF oRcp5 PIXEL //ColSizes 50,50

    oHsCli:SetArray(aHistor)
    oHsCli:bLine := {|| {		aHistor[oHsCli:nAt,1],;
        						aHistor[oHsCli:nAt,2],;
      							aHistor[oHsCli:nAt,3],;
					      		aHistor[oHsCli:nAt,4]}}

	nOpc := 0
	
  	@ 135, 005 BUTTON oBotaoVis PROMPT "Visualizar"			ACTION (AddHis(aHistor[oHsCli:nAt,5],.f.)) SIZE 050, 010 OF oRcp5 PIXEL
  	@ 135, 055 BUTTON oBotaoAdd PROMPT "Adicionar"			ACTION (AddHis(0,.t.)) SIZE 050, 010 OF oRcp5 PIXEL
    @ 135, 105 BUTTON oBotaoSai PROMPT "&Sair"	 			ACTION (Close(oRcp5),nOpc:=0) SIZE 050, 010 OF oRcp5 PIXEL
	
	ACTIVATE MSDIALOG oRcp5 CENTERED
	
	If nOpc == 1
	Endif

	aCiclos[nPos,DT_ULTACAO] := SA1->A1_ULTACAO

    oDtCiclos:SetArray(aCiclos)
    oDtCiclos:bLine := {|| {	Iif(aCiclos[oDtCiclos:nAt,DT_MARCA]=="1",oSinalMk,;						//	1
    							U_RetLeg(aCiclos[oDtCiclos:nAt,DT_DTCICLO],oDtCiclos:nAt)),;			//	2
    							Iif(aCiclos[oDtCiclos:nAt,2]=="1",oOk,oNo),;							//	3
        						aCiclos[oDtCiclos:nAt,DT_VENDEDOR],;									//	4	
        						aCiclos[oDtCiclos:nAt,DT_VENCI],;										//	5
        						aCiclos[oDtCiclos:nAt,DT_CICLO],;										//	6
        						aCiclos[oDtCiclos:nAt,DT_CONTRATO],;									//	6
      							aCiclos[oDtCiclos:nAt,DT_CODIGO],;										// 	7
					      		aCiclos[oDtCiclos:nAt,DT_LOJA],;										//	8
					      		aCiclos[oDtCiclos:nAt,DT_NOME],;										//	9
					      		TransForm(aCiclos[oDtCiclos:nAt,DT_UFAT],'@E 9,999,999.99'),;										//	10	
					      		TransForm(aCiclos[oDtCiclos:nAt,DT_TFAT],'@E 99,999,999.99'),;										//	10	
					      		aCiclos[oDtCiclos:nAt,DT_MUN],;										//	9
					      		aCiclos[oDtCiclos:nAt,DT_ULTPED],;										//	10	
					      		aCiclos[oDtCiclos:nAt,DT_MEDIA],;										//	11
					      		aCiclos[oDtCiclos:nAt,DT_ULTCOM],;										//	12
					      		aCiclos[oDtCiclos:nAt,DT_QTDCOM],;										//	13
					      		aCiclos[oDtCiclos:nAt,DT_DDD],;											//	14
					      		aCiclos[oDtCiclos:nAt,DT_TEL],;											//	15
					      		aCiclos[oDtCiclos:nAt,DT_TEL2],;										//	16
					      		aCiclos[oDtCiclos:nAt,DT_TEL3],;										//	17
					      		aCiclos[oDtCiclos:nAt,DT_CONTATO],;										//	18
					      		aCiclos[oDtCiclos:nAt,DT_ULTACAO],;										//	19
					      		aCiclos[oDtCiclos:nAt,DT_DATOCO],;										//	20
					      		aCiclos[oDtCiclos:nAt,DT_CNPJ],;										//	21
					      		aCiclos[oDtCiclos:nAt,DT_RAZAO]}}										//	22

oDtCiclos:Refresh()
RestArea(aArea)
Return .t.



Static Function AddHis(nRecno,lAdd,lAvulso)
Local nOpc := 0
Local cRet := ""
Local cMemo:= ""
Local oDlg1
Local oFont
Local aArea := GetArea()                  

DEFAULT lAvulso := .f.

// Se For Visualizacao
If !lAdd                     
	SZ3->(dbGoTo(nRecno))
	cMemo :=SZ3->Z3_HISTM
Else
	cMemo := Space(10)
Endif

DEFINE FONT oFont NAME "Courier New" SIZE 7,14

@ 3,0 TO 340,550 DIALOG oDlg1 TITLE OemToAnsi("Hist๓rico Cliente")
@ 5,5 Get cMemo MEMO OBJECT oMemo SIZE 267,145 WHEN lAdd
oMemo:bRClicked := {||AllwaysTrue()}
oMemo:oFont:=oFont
@ 153,200 BMPBUTTON TYPE 1  ACTION ( nOpc := 1 , oDlg1:End() )
@ 153,240 BMPBUTTON TYPE 2  ACTION ( nOpc := 0 , oDlg1:End() )
ACTIVATE DIALOG oDlg1 CENTER

If nOpc==1 .And. !Empty(cMemo) .And. lAdd
	If RecLock("SZ3",.t.)
		SZ3->Z3_FILIAL	:= xFilial("SZ3")  
		SZ3->Z3_CLIENTE	:=	SZ4->Z4_CLIENTE
		SZ3->Z3_LOJA	:=	SZ4->Z4_LOJA
		SZ3->Z3_DATA	:=	dDataBase
		SZ3->Z3_HORA	:=	Time()
		SZ3->Z3_HISTM	:=	cMemo
		SZ3->Z3_INICIO	:=  cMemo
		SZ3->Z3_USER	:=	__cUserId
		SZ3->Z3_NMUSER	:=	Capital(USRRETNAME(__cUserId))
		SZ3->(MsUnlock())
	Endif
	// Grava Ultima A็ใo do Cliente
	If RecLock("SA1",.f.)
		SA1->A1_ULTACAO	:= 'Hist๓rico: ' + cMemo
		SA1->(MsUnlock())
	Endif             
	If !lAvulso
		aHistor	:=	{}
		MontaHistor(@aHistor)
	    oHsCli:SetArray(aHistor)
	    oHsCli:bLine := {|| {		aHistor[oHsCli:nAt,1],;
	        						aHistor[oHsCli:nAt,2],;
	      							aHistor[oHsCli:nAt,3],;
						      		aHistor[oHsCli:nAt,4]}}
		oHsCli:Refresh()
	Endif
Else
	Return .f.
Endif
Return .t.


Static Function MontaHistor(aHistor)
cQuery := 	 " SELECT Z3_DATA, Z3_HORA, Z3_INICIO, Z3_USER, Z3_NMUSER, R_E_C_N_O_ RECNO "
cQuery +=	 " FROM " + RetSqlName("SZ3") + " SZ3 (NOLOCK) "
cQuery +=	 " WHERE  "
cQuery +=	 " Z3_FILIAL = '" + xFilial("SZ3") + "' "
cQuery +=	 " AND SZ3.D_E_L_E_T_ = '' "      
cQuery +=	 " AND SZ3.Z3_CLIENTE = '" + SA1->A1_COD + "' "
cQuery +=	 " AND SZ3.Z3_LOJA = '" + SA1->A1_LOJA + "' "
cQuery +=	 " ORDER BY Z3_DATA+Z3_HORA DESC "       //
	
TCQUERY cQuery NEW ALIAS "CHK1"

TcSetField('CHK1','Z3_DATA','D')

Count To nReg

CHK1->(dbGoTop())

dbSelectArea("CHK1")
dbGoTop()    
ProcRegua(nReg)     

If Empty(nReg)
	aHistor	:= {{'','','','',0}}
Else
	aHistor := {}
Endif

While CHK1->(!Eof())
	IncProc("Aguarde Localizando Hist๓rico do Cliente Posicionado ")
	
	AAdd(aHistor,{DtoC(CHK1->Z3_DATA),;
					CHK1->Z3_HORA,;
					CHK1->Z3_INICIO,;
					CHK1->Z3_NMUSER,;
					CHK1->RECNO})

	CHK1->(dbSkip(1))
Enddo
CHK1->(dbCloseArea())
					
Return .t.	


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ EscHun() บAutor  ณ Luiz Alberto      บ Data ณ  26/11/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Efetua a Escalada do Cliente para seu Hunter               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function EscFin(cCodigo,cLoja,nPos)
Local aArea := GetArea()
Private aPages := {} // array que guarda os endere็os visitados
Private nPgVist := -1 // controle a posicao do array aPages 
Private aSize := MsAdvSize() // pega o tamanho da tela 
Private oDlg1, oTIBrw
Private cNavegado := Space(80) // usado no objeto get para guardar os endere็os web 
Private lcont := .T. 

// Localiza Vetor Marcado
nPos := 0;For nI := 1 To Len(aCiclos);If aCiclos[nI,2]=='1';nPos	:=	nI;Exit;Endif;Next

If Empty(nPos)
	Return .f.
Endif

SZ4->(dbGoTo(aCiclos[nPos,DT_RECNO]))
SA1->(dbGoTo(aCiclos[nPos,DT_RECNO2]))

DEFINE MSDIALOG oDlg1 TITLE "Navegador" From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL

cNavegado := "http://www.intercarta.com.br/suporte/index.php?a=add" // pagina inicial
oNav:= TGet():New(10,10,{|u| if(PCount()>0,cNavegado:=u,cNavegado)}, oDlg1,340,5,,,,,,,,.F.,,,,,,,,,,) 

//@ 010, 350 Button oBtnIr PROMPT "Ir" Size 40,10 Action(Processa({||Navegar()},"Abrindo","Aguarde...")) Of oDlg1 Pixel
//@ 010, 390 Button oBtnImp PROMPT "Imprimir" Size 40,10 Action oTIBrw:Print() Of oDlg1 Pixel



//@ 010, 010 Button oBtnAnte PROMPT "Anterior" Size 40,10 Action (Retorna()) Of oDlg1 Pixel
//@ 010, 050 Button oBtnDep PROMPT "Avan็ar" Size 40,10 Action(Avanca()) Of oDlg1 Pixel 
@ 010, 010 Button oBtnSair PROMPT "Sair" Size 40,10 Action(Sair()) Of oDlg1 Pixel 



oTIBrw:= TIBrowser():New( 025,010,aSize[5]-670, 270, "http://www.intercarta.com.br/suporte/index.php?a=add", oDlg1 ) 

aaDD(aPages,"http://www.intercarta.com.br/suporte/index.php?a=add")

oNav:bLostFocus := { || Valido()}


Activate MsDialog oDlg1 Centered


If MsgYesNo("Confirma Escala Suporte do Cliente " + AllTrim(SZ4->Z4_NOME) +" ? ",OemToAnsi('ATENCAO'))
	// Registra Log
		
	CicloLog(SZ4->Z4_CLIENTE,SZ4->Z4_LOJA,SZ4->Z4_CLIENTE,SZ4->Z4_LOJA,'Escalado Suporte com Sucesso !','0005',.t.)	
	
	   // Retira Cliente da tela de Ciclo e Marca Lido
		
	SaiCiclo(nPos,'Processado Escala Suporte em '+DtoC(dDataBase) + " as " + Time(),'0005')
Endif
Return 


Static Function Navegar() 

Ir()

Return


Static Function Ir()

oTIBrw:Navigate(AllTrim(cNavegado),oDlg1)
aaDD(aPages,AllTrim(cNavegado)) 
nPgVist := Len(aPages)

Return 



Static Function Avanca() // proxima proxima pagina que jah foi visitada

if(Len(aPages) > nPgVist .and. Len(aPages) > 1 )
nPgVist++ 
oTIBrw:Navigate(aPages[nPgVist],oDlg1) 
cNavegado := aPages[nPgVist]
oNav:Refresh()
EndIf 

Return 


Static Function Retorna() // pagina anterior que foi visitada
if(nPgVist>1)
nPgVist-- 
oTIBrw:Navigate(aPages[nPgVist],oDlg1) 
cNavegado := aPages[nPgVist]
oNav:Refresh() 
EndIf 

Return

Static Function Valido() // fecha a tela 

Return .t.

Static Function Sair() // fecha a tela 
oDlg1:End() 
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fTelaMemoบAutor  ณ Felipe A. Melo       Data ณ  11/05/201  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ConsLog(cCodigo,cLoja,nPos)
Local aArea := GetArea()
Local oBotaoSai
Local oBotaoVis
Local oBotaoAdd
Private aLog	:= {{'','','','',0}}
Private oLogCli
Private oDlgLog

SZ4->(dbGoTo(aCiclos[nPos,DT_RECNO]))
SA1->(dbGoTo(aCiclos[nPos,DT_RECNO2]))

cQuery := 	 " SELECT Z5_DATA, Z5_HORA, Z5_NOMUSR, Z5_ACAO, Z5_ID "
cQuery +=	 " FROM " + RetSqlName("SZ5") + " SZ5 (NOLOCK) "
cQuery +=	 " WHERE  "
cQuery +=	 " Z5_FILIAL = '" + xFilial("SZ5") + "' "
cQuery +=	 " AND SZ5.D_E_L_E_T_ = '' "      
cQuery +=	 " AND SZ5.Z5_CLIENTE = '" + SZ4->Z4_CLIENTE + "' "
cQuery +=	 " AND SZ5.Z5_LOJA = '" + SZ4->Z4_LOJA + "' "
cQuery +=	 " ORDER BY Z5_DATA+Z5_HORA DESC "       //
	
TCQUERY cQuery NEW ALIAS "CHK1"

TcSetField('CHK1','Z5_DATA','D')

Count To nReg

CHK1->(dbGoTop())

dbSelectArea("CHK1")
dbGoTop()    
ProcRegua(nReg)     

If Empty(nReg)
	aLog	:= {{'','','','',''}}
Else
	aLog := {}
Endif

While CHK1->(!Eof())
	IncProc("Aguarde Localizando Hist๓rico do Cliente Posicionado ")
	
	AAdd(aLog,{DtoC(CHK1->Z5_DATA),;
					CHK1->Z5_HORA,;
					CHK1->Z5_NOMUSR,;
					CHK1->Z5_ACAO,;
					CHK1->Z5_ID})

	CHK1->(dbSkip(1))
Enddo
CHK1->(dbCloseArea())

DEFINE MSDIALOG oDlgLog TITLE "Log Ultimas A็๕es do Cliente: " + SA1->A1_COD +'/'+ SA1->A1_LOJA + ' - ' + Capital(AllTrim(SA1->A1_NOME)) FROM 000, 000  TO 300, 800 COLORS 0, 16777215 PIXEL 

    @ 010, 005 LISTBOX oLogCli Fields HEADER "Data",'Hora',"Usuแrio","A็ใo",'ID Log' SIZE 395, 120 OF oDlgLog PIXEL //ColSizes 50,50

    oLogCli:SetArray(aLog)
    oLogCli:bLine := {|| {		aLog[oLogCli:nAt,1],;
        						aLog[oLogCli:nAt,2],;
      							aLog[oLogCli:nAt,3],;
					      		aLog[oLogCli:nAt,4],;
					      		aLog[oLogCli:nAt,5]}}

	nOpc := 0
	
    @ 135, 005 BUTTON oBotaoSai PROMPT "&Sair"	 			ACTION (Close(oDlgLog),nOpc:=0) SIZE 050, 010 OF oDlgLog PIXEL
	
	ACTIVATE MSDIALOG oDlgLog CENTERED
	
	If nOpc == 1
	Endif

RestArea(aArea)
Return .t.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fTelaMemoบAutor  ณ Felipe A. Melo       Data ณ  11/05/201  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function EdiCli(cCodigo,cLoja,nPos)
Local aArea := GetArea()

// Localiza Vetor Marcado
nPos := 0;For nI := 1 To Len(aCiclos);If aCiclos[nI,2]=='1';nPos	:=	nI;Exit;Endif;Next

If Empty(nPos)
	Return .f.
Endif
       
cCadastro := 'Cadastro de Clientes'
dbSelectArea("SA1")
SZ4->(dbGoTo(aCiclos[nPos,DT_RECNO]))
SA1->(dbGoTo(aCiclos[nPos,DT_RECNO2]))

INCLUI := .F.
ALTERA := .T.

RegToMemory("SA1",.F.)

nOpc := AxAltera("SA1",SA1->(RECNO()),4)

If nOpc == 1 	// Confirmou Gravacao
	// Registra Log
		
	CicloLog(SZ4->Z4_CLIENTE,SZ4->Z4_LOJA,SZ4->Z4_CLIENTE,SZ4->Z4_LOJA,'Efetuado Manuten็ใo No Cadastro do Cliente ','0008')	
	
	If RecLock("SZ4",.f.)
		SZ4->Z4_VEND	:= SA1->A1_VEND
		SZ4->Z4_NOME	:= SA1->A1_NOME
		SZ4->(MsUnlock())
	Endif
Endif


//If cTipVen $ 'F'	// Farmer 
//	SA3->(dbSetOrder(1), dbSeek(xFilial("SA3")+SZ4->Z4_VNDFMR))
//ElseIf cTipVen == 'H'	// Hunter
	SA3->(dbSetOrder(1), dbSeek(xFilial("SA3")+SZ4->Z4_VEND))
//ElseIf cTipVen == 'M'	// Manager
//	If SZ4->Z4_ESCHUN == 'S'
//		SA3->(dbSetOrder(1), dbSeek(xFilial("SA3")+SZ4->Z4_VEND))
//	Else
//		SA3->(dbSetOrder(1), dbSeek(xFilial("SA3")+SZ4->Z4_VNDFMR))
//	Endif
//Endif

//cNmAtaca	:= ''
//If !Empty(SA1->A1_ATACADO)
//	SA1->(dbSetOrder(1), dbSeek(xFilial("SA1")+SA1->A1_ATACADO+'01'))		
//	cNmAtaca	:= SA1->A1_NREDUZ
//Endif

SA1->(dbGoTo(aCiclos[nPos,DT_RECNO2]))	

aCiclos[nPos,DT_VENDEDOR]	:=	SA3->A3_COD+'-'+Capital(SA3->A3_NREDUZ)
aCiclos[nPos,DT_NOME]		:=	SA1->A1_NREDUZ
aCiclos[nPos,DT_DDD]  		:=	SA1->A1_DDD
aCiclos[nPos,DT_TEL]		:=	SA1->A1_TEL
aCiclos[nPos,DT_TEL2]		:=	SA1->A1_TELEX
aCiclos[nPos,DT_TEL3]		:=	SA1->A1_COMPLEM
aCiclos[nPos,DT_CONTATO]	:=	SA1->A1_CONTATO
aCiclos[nPos,DT_EMAIL]		:=	Lower(SA1->A1_EMAIL)

    oDtCiclos:SetArray(aCiclos)
    oDtCiclos:bLine := {|| {	Iif(aCiclos[oDtCiclos:nAt,DT_MARCA]=="1",oSinalMk,;						//	1
    							U_RetLeg(aCiclos[oDtCiclos:nAt,DT_DTCICLO],oDtCiclos:nAt)),;			//	2
    							Iif(aCiclos[oDtCiclos:nAt,2]=="1",oOk,oNo),;							//	3
        						aCiclos[oDtCiclos:nAt,DT_VENDEDOR],;									//	4	
        						aCiclos[oDtCiclos:nAt,DT_VENCI],;										//	5
        						aCiclos[oDtCiclos:nAt,DT_CICLO],;										//	6
        						aCiclos[oDtCiclos:nAt,DT_CONTRATO],;									//	6
      							aCiclos[oDtCiclos:nAt,DT_CODIGO],;										// 	7
					      		aCiclos[oDtCiclos:nAt,DT_LOJA],;										//	8
					      		aCiclos[oDtCiclos:nAt,DT_NOME],;										//	9
					      		TransForm(aCiclos[oDtCiclos:nAt,DT_UFAT],'@E 9,999,999.99'),;										//	10	
					      		TransForm(aCiclos[oDtCiclos:nAt,DT_TFAT],'@E 99,999,999.99'),;										//	10	
					      		aCiclos[oDtCiclos:nAt,DT_MUN],;										//	9
					      		aCiclos[oDtCiclos:nAt,DT_ULTPED],;										//	10	
					      		aCiclos[oDtCiclos:nAt,DT_MEDIA],;										//	11
					      		aCiclos[oDtCiclos:nAt,DT_ULTCOM],;										//	12
					      		aCiclos[oDtCiclos:nAt,DT_QTDCOM],;										//	13
					      		aCiclos[oDtCiclos:nAt,DT_DDD],;											//	14
					      		aCiclos[oDtCiclos:nAt,DT_TEL],;											//	15
					      		aCiclos[oDtCiclos:nAt,DT_TEL2],;										//	16
					      		aCiclos[oDtCiclos:nAt,DT_TEL3],;										//	17
					      		aCiclos[oDtCiclos:nAt,DT_CONTATO],;										//	18
					      		aCiclos[oDtCiclos:nAt,DT_ULTACAO],;										//	19
					      		aCiclos[oDtCiclos:nAt,DT_DATOCO],;										//	20
					      		aCiclos[oDtCiclos:nAt,DT_CNPJ],;										//	21
					      		aCiclos[oDtCiclos:nAt,DT_RAZAO]}}										//	22
oDtCiclos:Refresh()
RestArea(aArea)
Return .t.



/*
???????????????????????????????????????
???????????????????????????????????????
? ?????????????????????????????????????
??rograma  ?fTrataCol?utor  ?Luiz Alberto     ?Data ? 10/04/2013 ??
???????????????????????????????????????
??esc.     ?                                                           ??
??         ?                                                           ??
???????????????????????????????????????
??so       ?                                                           ??
???????????????????????????????????????
???????????????????????????????????????
???????????????????????????????????????
*/
Static Function fTrataCol(nCol)
Local x        := 1
Local nLinhaOK := oDtCiclos:nAt

Default nCol      := 1

If nCol	== 1	// Legenda
	nCol	:=	DT_LEG
ElseIf nCol == 3 // Vendedor
	nCol := DT_VENDEDOR
ElseIf nCol == 4 // Vencimento Ciclo
	nCol := DT_ORDVENCI
ElseIf nCol == 5 // Data Ciclo
	nCol := DT_ORDCICLO
ElseIf nCol == 6 // Tipo Contrato
	nCol := DT_CONTRATO
ElseIf nCol == 7 // Codigo Cliente
	nCol := DT_CODIGO
ElseIf nCol == 8 // Loja
	nCol := DT_LOJA
ElseIf nCol == 9 // Nome Fantasia
	nCol := DT_NOME
ElseIf nCol == 10 // Ultimo Faturamento
	nCol := DT_UFAT
ElseIf nCol == 11 // Acumulado 12 Meses
	nCol := DT_TFAT
ElseIf nCol == 12// Municipio
	nCol := DT_MUN
ElseIf nCol == 13// Ult Pedido
	nCol := DT_ULTPED
ElseIf nCol == 14 // Media
	nCol := DT_MEDIA
ElseIf nCol == 15 // Ultima Compra
	nCol := DT_ULTCOM
ElseIf nCol == 16 // Qtde Compras
	nCol := DT_QTDCOM
ElseIf nCol == 17 // DDD
	nCol := DT_DDD
ElseIf nCol == 18 // Telefone
	nCol := DT_TEL
ElseIf nCol == 19 // Telefone
	nCol := DT_TEL
ElseIf nCol == 20 // Telefone
	nCol := DT_TEL
ElseIf nCol == 21 // Contato
	nCol := DT_CONTATO
ElseIf nCol == 22 // UltAcao
	nCol := DT_ULTACAO
ElseIf nCol == 23 // UltOcorrencia
	nCol := DT_DATOCO
ElseIf nCol == 24 // CNPJ
	nCol := DT_CNPJ
ElseIf nCol == 25 // Razao SOcial
	nCol := DT_RAZAO
Endif

If nSelCol <> nCol
	aSort(aCiclos,,,{|x,y|,x[nCol] < y[nCol]})
Else
	aSort(aCiclos,,,{|x,y|,x[nCol] > y[nCol]})
	nCol := 1
Endif
	
nSelCol := nCol

    oDtCiclos:SetArray(aCiclos)
    oDtCiclos:bLine := {|| {	Iif(aCiclos[oDtCiclos:nAt,DT_MARCA]=="1",oSinalMk,;						//	1
    							U_RetLeg(aCiclos[oDtCiclos:nAt,DT_DTCICLO],oDtCiclos:nAt)),;			//	2
    							Iif(aCiclos[oDtCiclos:nAt,2]=="1",oOk,oNo),;							//	3
        						aCiclos[oDtCiclos:nAt,DT_VENDEDOR],;									//	4	
        						aCiclos[oDtCiclos:nAt,DT_VENCI],;										//	5
        						aCiclos[oDtCiclos:nAt,DT_CICLO],;										//	6
        						aCiclos[oDtCiclos:nAt,DT_CONTRATO],;									//	6
      							aCiclos[oDtCiclos:nAt,DT_CODIGO],;										// 	7
					      		aCiclos[oDtCiclos:nAt,DT_LOJA],;										//	8
					      		aCiclos[oDtCiclos:nAt,DT_NOME],;										//	9
					      		TransForm(aCiclos[oDtCiclos:nAt,DT_UFAT],'@E 9,999,999.99'),;			//	10	
					      		TransForm(aCiclos[oDtCiclos:nAt,DT_TFAT],'@E 99,999,999.99'),;			//	11	
					      		aCiclos[oDtCiclos:nAt,DT_MUN],;											//	12
					      		aCiclos[oDtCiclos:nAt,DT_ULTPED],;										//	13	
					      		aCiclos[oDtCiclos:nAt,DT_MEDIA],;										//	14
					      		aCiclos[oDtCiclos:nAt,DT_ULTCOM],;										//	15
					      		aCiclos[oDtCiclos:nAt,DT_QTDCOM],;										//	16
					      		aCiclos[oDtCiclos:nAt,DT_DDD],;											//	17
					      		aCiclos[oDtCiclos:nAt,DT_TEL],;											//	18
					      		aCiclos[oDtCiclos:nAt,DT_TEL2],;										//	19
					      		aCiclos[oDtCiclos:nAt,DT_TEL3],;										//	20
					      		aCiclos[oDtCiclos:nAt,DT_CONTATO],;										//	21
					      		aCiclos[oDtCiclos:nAt,DT_ULTACAO],;										//	22
					      		aCiclos[oDtCiclos:nAt,DT_DATOCO],;										//	23
					      		aCiclos[oDtCiclos:nAt,DT_CNPJ],;										//	24
					      		aCiclos[oDtCiclos:nAt,DT_RAZAO]}}										//	25
oDtCiclos:Refresh()

Return



Static Function PsqCli()
Local cFantasia := Space(30)
Local cRazao := Space(40)
Local cCNPJ := Space(14)
Local oDlg1
Local oFont
Local aArea := GetArea()

DEFINE FONT oFont NAME "Courier New" SIZE 7,14

@ 3,0 TO 140,550 DIALOG oDlg1 TITLE OemToAnsi("Pesquisa Clientes")
@ 1,3 Say 'CNPJ: ' Picture "@!" SIZE 100,10 OF oDlg1
@ 1,10 Get cCNPJ Picture "@!" SIZE 100,10 OF oDlg1
@ 2,3 Say 'Razใo Social: ' Picture "@!" SIZE 100,10 OF oDlg1
@ 2,10 Get cRazao Picture "@!" SIZE 100,10 OF oDlg1
@ 3,3 Say 'Nome Fantasia: ' Picture "@!" SIZE 100,10 OF oDlg1
@ 3,10 Get cFantasia Picture "@!" SIZE 100,10 OF oDlg1

@ 040,200 BMPBUTTON TYPE 1  ACTION ( nOpc := 1 , oDlg1:End() )
@ 040,240 BMPBUTTON TYPE 2  ACTION ( nOpc := 0 , oDlg1:End() )
ACTIVATE DIALOG oDlg1 CENTER

If nOpc==1 .And. (!Empty(cCNPJ) .Or. !Empty(cRazao) .Or. !Empty(cFantasia))
	If !Empty(cCNPJ)
		nCol	:=	DT_CNPJ
	ElseIf !Empty(cRazao)
		nCol	:=	DT_RAZAO
	ElseIf !Empty(cFantasia)
		nCol := DT_NOME
	Endif
	
	aSort(aCiclos,,,{|x,y|,x[nCol] < y[nCol]})
    oDtCiclos:SetArray(aCiclos)
    oDtCiclos:bLine := {|| {	Iif(aCiclos[oDtCiclos:nAt,DT_MARCA]=="1",oSinalMk,;						//	1
    							U_RetLeg(aCiclos[oDtCiclos:nAt,DT_DTCICLO],oDtCiclos:nAt)),;			//	2
    							Iif(aCiclos[oDtCiclos:nAt,2]=="1",oOk,oNo),;							//	3
        						aCiclos[oDtCiclos:nAt,DT_VENDEDOR],;									//	4	
        						aCiclos[oDtCiclos:nAt,DT_VENCI],;										//	5
        						aCiclos[oDtCiclos:nAt,DT_CICLO],;										//	6
        						aCiclos[oDtCiclos:nAt,DT_CONTRATO],;									//	6
      							aCiclos[oDtCiclos:nAt,DT_CODIGO],;										// 	7
					      		aCiclos[oDtCiclos:nAt,DT_LOJA],;										//	8
					      		aCiclos[oDtCiclos:nAt,DT_NOME],;										//	9
					      		TransForm(aCiclos[oDtCiclos:nAt,DT_UFAT],'@E 9,999,999.99'),;										//	10	
					      		TransForm(aCiclos[oDtCiclos:nAt,DT_TFAT],'@E 99,999,999.99'),;										//	10	
					      		aCiclos[oDtCiclos:nAt,DT_MUN],;										//	9
					      		aCiclos[oDtCiclos:nAt,DT_ULTPED],;										//	10	
					      		aCiclos[oDtCiclos:nAt,DT_MEDIA],;										//	11
					      		aCiclos[oDtCiclos:nAt,DT_ULTCOM],;										//	12
					      		aCiclos[oDtCiclos:nAt,DT_QTDCOM],;										//	13
					      		aCiclos[oDtCiclos:nAt,DT_DDD],;											//	14
					      		aCiclos[oDtCiclos:nAt,DT_TEL],;											//	15
					      		aCiclos[oDtCiclos:nAt,DT_TEL2],;										//	16
					      		aCiclos[oDtCiclos:nAt,DT_TEL3],;										//	17
					      		aCiclos[oDtCiclos:nAt,DT_CONTATO],;										//	18
					      		aCiclos[oDtCiclos:nAt,DT_ULTACAO],;										//	19
					      		aCiclos[oDtCiclos:nAt,DT_DATOCO],;										//	20
					      		aCiclos[oDtCiclos:nAt,DT_CNPJ],;										//	21
					      		aCiclos[oDtCiclos:nAt,DT_RAZAO]}}										//	22
	oDtCiclos:Refresh()
	
	If !Empty(cCNPJ)
		nAchou := Ascan(aCiclos,{|x| AllTrim(cCNPJ) == Left(x[DT_CNPJ],Len(AllTrim(cCNPJ))) })
		If Empty(nAchou)
			Alert("CNPJ Nใo Localizado !!")
		Else 
			oDtCiclos:nAt := nAchou		
		Endif
	ElseIf !Empty(cRazao)
		nAchou := Ascan(aCiclos,{|x| AllTrim(cRazao) == Left(x[DT_RAZAO],Len(AllTrim(cRazao))) })
		If Empty(nAchou)
			Alert("Razao Nใo Localizado !!")
		Else 
			oDtCiclos:nAt := nAchou		
		Endif
	ElseIf !Empty(cFantasia)
		nAchou := Ascan(aCiclos,{|x| AllTrim(cFantasia) == Left(x[DT_NOME],Len(AllTrim(cFantasia))) })
		If Empty(nAchou)
			Alert("Fantasia Nใo Localizado !!")
		Else 
			oDtCiclos:nAt := nAchou		
		Endif
	Endif	
Endif
Return .t.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณ MstLeg     บAutor  ณ Luiz Alberto V Alvesบ Data ณ  25/03/15บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDescricao ณ Tela de Legenda dos Status do Ciclo                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico : Metalacre                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function MstLeg()
Local aCorDesc

aCorDesc := {{"BR_VERDE"   ,"Ciclo a Vencer Superior 10 Dias" } ,; 
			 {"BR_LARANJA" ,"Ciclo a Vencer Inferior 10 Dias" } ,; 
			 {"BR_AMARELO" ,"Ciclo a Vencer em 5 Dias"        } ,; 
			 {"BR_VERMELHO","Ciclo Vencido/Vencer 4 Dias"     } ,; 
			 {"BR_PINK"    ,"Cliente Possui Pedido Nใo Faturado"} ,; 
			 {"BR_VIOLETA" ,"Linha Marcada" },;
			 {"BR_AZUL"    ,"Inserida Data de Retorno" },;
			 {"BR_PRETO"   ,"Titulo em Aberto Financeiro" }} 

BrwLegenda( "Legenda", "Status", aCorDesc )

Return( .T. )



User Function RetLeg(dDataCiclo,nPos)
DEFAULT dDataCiclo := dDataBase

nDias := (dDataCiclo-dDataBase)

If !Empty(aCiclos[nPos,DT_FINAN])	// Indicacao de Titulo em Aberto no Financeiro
	Return oSinalFn
ElseIf aCiclos[nPos,DT_MOTIVO]=='0003' .And. nDias > 10	// Insercao de Data de Ciclo Manualmente
	Return oSinalRt
ElseIf !Empty(aCiclos[nPos,DT_ULTPED])
	Return oSinalPd
ElseIf nDias > 10             
	Return oSinal10
ElseIf nDias > 5 .And. nDias <= 10
	Return oSinal05
ElseIf nDias >= 1 .And. nDias <= 5
	Return oSinalVc
Else                          
	Return oSinal00
Endif



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuncao    IncPd   ณ Autor ณ Luiz Alberto        ณ Data ณ29.11.2014ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Inclusใo Automatica de Pedidos de Vendas e Tela de Inclusใoณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณRetorno   ณ Nenhum                                                     ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function IncPd()
Local aColsC6   := {}
Local aHeadC6   := {}
Local aPedCob   := {}
Local aArea     := GetArea()
Local aDadosCfo := {} 

Local bCampo    := {|nCPO| Field(nCPO) }

Local cFilOld   := cFilAnt
Local cVend     := ""
Local cCampo    := ""
Local cItSC6    := StrZero(0,Len(SC6->C6_ITEM))
Local cTes      := "" 
Local cLanguage	:= "P"
Local nX        := 0
Local nY        := 0
Local nMaxFor   := 0
Local nMaxVend  := 4
Local nUsado    := 0
Local aRotinaBkp:= {}
Local nStack    := GetSX8Len()
Local nTipo      := 1   

Private aheadGrade := {}
Private aColsGrade := {}
Private aheader    := {}
Private acols      := {}
Private n          := 1
Private	l410Auto   := .f.
PRIVATE ALTERA := .F.
PRIVATE INCLUI := .T.
PRIVATE cCadastro := "Pedido de Venda"
Private aRotina := {	{ 'Pesquisar',"AxPesqui"  ,0,1,0,.F.},;	// "Pesquisar"
							{ 'Visualizar',"Ft400Alter",0,2,0,NIL},;	// "Visualizar"
							{ 'Incluir',"Ft400Inclu",0,3,0,NIL},;	// "Incluir"
							{ 'Alterar',"Ft400Alter",0,4,0,NIL}}	// "Legenda"



#IFDEF SPANISH
	cLanguage	:= "S"
#ELSE
	#IFDEF ENGLISH
		cLanguage	:= "E"
	#ENDIF
#ENDIF

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณPreparar pedido de venda com base no contrato de parceria               ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta aHeader do SC6                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aHeadC6 := {}
dbSelectArea("SX3")
dbSetOrder(1)
MsSeek("SC6",.T.)
While ( !Eof() .And. SX3->X3_ARQUIVO == "SC6" )
	If ( X3Uso(SX3->X3_USADO) .And.;
			!Trim(SX3->X3_CAMPO)=="C6_NUM" .And.;
			Trim(SX3->X3_CAMPO) != "C6_QTDEMP" .And.;
			Trim(SX3->X3_CAMPO) != "C6_QTDENT" .And.;
			cNivel >= SX3->X3_NIVEL ) .Or.;
			Trim(SX3->X3_CAMPO)=="C6_CONTRAT" .Or. ;
			Trim(SX3->X3_CAMPO)=="C6_ITEMCON"

		Aadd(aHeadC6,{IIF(cLanguage == "P",SX3->X3_TITULO,IIF(cLanguage == "S",SX3->X3_TITSPA,SX3->X3_TITENG)),;
			SX3->X3_CAMPO,;
			SX3->X3_PICTURE,;
			SX3->X3_TAMANHO,;
			SX3->X3_DECIMAL,;
			SX3->X3_VALID,;
			SX3->X3_USADO,;
			SX3->X3_TIPO,;
			SX3->X3_ARQUIVO,;
			SX3->X3_CONTEXT })
	EndIf
	dbSelectArea("SX3")
	dbSkip()
EndDo

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณPreenche o Acols do Pedido de Venda                                     ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
nUsado := Len(aHeadC6)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCria as variaveis do Pedido de Venda                                    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

INCLUI := .T.
ALTERA := .F.

RegToMemory("SC5",.t.)

	aadd(aColsC6,Array(nUsado+1))
	nY := Len(aColsC6)		
	aColsC6[nY,nUsado+1] := .F.
	
	For nX := 1 To nUsado                               
		aColsC6[nY,nX] := CriaVar(aHeadC6[nX,2],.T.)
	Next nX
	aColsC6[1,1] := '01'
	Begin Transaction
		aCols   := aColsC6
		aHeader := aHeadC6
		For nX := 1 To Len(aCols)
			MatGrdMont(nX)
		Next nX
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Variaveis Utilizadas pela Funcao a410Inclui          ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				
		Pergunte("MTA410",.F.)
		aRotinaBkp := aRotina
		lRetorno := SC5->(a410Inclui(Alias(),Recno(),4,.T.,nStack,,.T.,nTipo))
		If !Empty(lRetorno)
			CicloLog(SC5->C5_CLIENTE,SC5->C5_LOJACLI,SC5->C5_CLIENTE,SC5->C5_LOJACLI,'Inclusใo de Pedido ' + SC5->C5_NUM + " Efetuada com Sucesso !",'0004')
			lRet := .t.                                                 
		Else
			lRet := .F.
		Endif
		aRotina := aRotinaBkp
	End Transaction

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Restaura a integridade da rotina                                    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
RestArea(aArea)
Return lRet
		

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuncao    AssPd   ณ Autor ณ Luiz Alberto        ณ Data ณ29.11.2014ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Associar Um Pedido Incluido por Fora ao Ciclo Atual        ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณRetorno   ณ Nenhum                                                     ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function AssPd(nPos)
Local aArea := GetArea()  

// Localiza Vetor Marcado
nPos := 0;For nI := 1 To Len(aCiclos);If aCiclos[nI,2]=='1';nPos	:=	nI;Exit;Endif;Next


If Empty(nPos)
	Return .f.
Endif

If Empty(aCiclos[nPos,DT_ULTPED])
	MsgStop("Aten็ใo Nใo Existe Pedido Para Ser Relacionado เ este Ciclo !")
	Return .f.
Endif
          
SZ4->(dbGoTo(aCiclos[nPos,DT_RECNO]))
SA1->(dbGoTo(aCiclos[nPos,DT_RECNO2]))

If MsgYesNo("Deseja Relacionar o Pedido No. " + aCiclos[nPos,DT_ULTPED] + " Ao Ciclo Atual ?",OemToAnsi('ATENCAO'))
	// Registra Log
		
	If CicloLog(SZ4->Z4_CLIENTE,SZ4->Z4_LOJA,SZ4->Z4_CLIENTE,SZ4->Z4_LOJA,'Pedido Relacionado !','0007',.t.)	
		dDtCiclo	:=	SZ4->Z4_CICLO + SZ4->Z4_MCICLO
		xDtCiclo	:=	DataValida(dDtCiclo,.T.)
	
	
		If RecLock("SZ4",.f.)
			SZ4->Z4_DCLANT	:=	SZ4->Z4_CICLO
			SZ4->Z4_CICLO	:=  xDtCiclo
			SZ4->Z4_VENCICL	:=  xDtCiclo-10
			SZ4->(MsUnlock())
		Endif
	Endif
	
	   // Retira Cliente da tela de Ciclo e Marca Lido
		
	SaiCiclo(nPos,'Processado Relacionamento de Pedido em '+DtoC(dDataBase) + " as " + Time(),'0007')
Endif

RestArea(aArea)
Return .t.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fContato บAutor  ณ Luiz Alberto     Data ณ  07/07/2015  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function fContato(cCodigo,cLoja,nPos,lProspect)
Local aArea := GetArea()
Local oBotaoInc
Local oBotaoAlt
Local oBotaoSai
Local oBotaoVis
Local oBotaoAdd
Private aContat	:= {{'','','','','','','',0}}
Private oCntCli
Private oDlgCnt
Private cCadastro	:=	'Cadastro de Contatos'

DEFAULT cCodigo := Space(06)
DEFAULT cLoja := Space(02)
DEFAULT nPos := 0


INCLUI := .f.
ALTERA := .f.
lProspect := .f.
lConcorre := .f.
lOportu := .f.

If cCodigo == 'AD9' .Or. Type("aHeader") <> "U" .And. aScan(aHeader,{|x| Alltrim(x[2])== "AD9_CODCON"}) > 0
	lOportu	:= .t.
	If !Empty(M->AD1_PROSPE)
		cCodigo := M->AD1_PROSPE
		cLoja   := M->AD1_LOJPRO
		lProspect := .t.
	Else
		cCodigo := M->AD1_CODCLI
		cLoja   := M->AD1_LOJCLI
		lProspect := .f.
	Endif
ElseIf cCodigo == 'SA1'
	cCodigo := SA1->A1_COD
	cLoja   := SA1->A1_LOJA
ElseIf IsInCallStack("MATA030") 
	cCodigo := M->A1_COD
	cLoja   := M->A1_LOJA
ElseIf Type("aCiclos") <> "U"
	SZ4->(dbGoTo(aCiclos[nPos,DT_RECNO]))
	SA1->(dbGoTo(aCiclos[nPos,DT_RECNO2]))
ElseIf Type("M->UA_CLIPROS")<>"U"
	If M->UA_CLIPROS == '2'
		lProspect := .t.
		cCodigo := SUS->US_COD
		cLoja   := SUS->US_LOJA
	Else                         
		cCodigo := SA1->A1_COD
		cLoja   := SA1->A1_LOJA
	Endif
Endif

aRotina := { { "Pesquisar","AxPesqui"	,0	, 1,0,.F.},;	//
             { "Visualizar","AxVisual"	,0	, 2,0,Nil},;	//
             { "Incluir", "AxInclui"	,0	, 3,0,Nil},;	//
             { "Alterar", "AxAltera"	,0	, 4,0,Nil},;	//
             { "Excluir", "AxExclui"	,0	, 5,3,Nil} }	//   

INCLUI := .F.
ALTERA := .T.

RegToMemory("SA1",.f.)
RegToMemory("SU5",.f.)

DEFINE MSDIALOG oDlgCnt TITLE "Contatos do Cliente: " + SA1->A1_COD +'/'+ SA1->A1_LOJA + ' - ' + Capital(AllTrim(SA1->A1_NOME)) FROM 000, 000  TO 300, 800 COLORS 0, 16777215 PIXEL 

    @ 010, 005 LISTBOX oCntCli Fields HEADER "Contato",'Cargo','DDD','Fone Cml','Fone Cml','Celular','Email' SIZE 395, 120 OF oDlgCnt PIXEL //ColSizes 50,50


    oCntCli:SetArray(aContat)
    oCntCli:bLine := {|| {		aContat[oCntCli:nAt,1],;
        						aContat[oCntCli:nAt,2],;
        						aContat[oCntCli:nAt,3],;
        						aContat[oCntCli:nAt,4],;
        						aContat[oCntCli:nAt,5],;
        						aContat[oCntCli:nAt,6],;
        						aContat[oCntCli:nAt,7]}}

	ProcCont(@aContat,cCodigo,cLoja,lProspect)



	nOpc := 0
	
    @ 135, 005 BUTTON oBotaoInc PROMPT "&Inclui" 			ACTION (INCLUI:=.t.,ALTERA:=.F.,IncCont(lProspect),ProcCont(@aContat,cCodigo,cLoja,lProspect),nOpc:=0) SIZE 050, 010 OF oDlgCnt PIXEL
    @ 135, 055 BUTTON oBotaoAlt PROMPT "&Altera" 			ACTION (INCLUI:=.F.,ALTERA:=.t.,SU5->(dbGoTo(aContat[oCntCli:nAt,8])),axAltera("SU5",SU5->(Recno()),4),ProcCont(@aContat,cCodigo,cLoja,lProspect),nOpc:=0) SIZE 050, 010 OF oDlgCnt PIXEL
    @ 135, 105 BUTTON oBotaoAlt PROMPT "&Excluir" 			ACTION (SU5->(dbGoTo(aContat[oCntCli:nAt,8])),ExcCont(cCodigo,cLoja,lProspect),ProcCont(@aContat,cCodigo,cLoja,lProspect),nOpc:=0) SIZE 050, 010 OF oDlgCnt PIXEL
    @ 135, 155 BUTTON oBotaoAlt PROMPT "&Pesquisa" 			ACTION (PsqCont(cCodigo,cLoja,lProspect),ProcCont(@aContat,cCodigo,cLoja,lProspect),nOpc:=0) SIZE 050, 010 OF oDlgCnt PIXEL
    @ 135, 205 BUTTON oBotaoAlt PROMPT "&Seleciona"			ACTION (SU5->(dbGoTo(aContat[oCntCli:nAt,8])),Close(oDlgCnt),nOpc:=0) SIZE 050, 010 OF oDlgCnt PIXEL
    @ 135, 255 BUTTON oBotaoSai PROMPT "&Sair"	 			ACTION (Close(oDlgCnt),nOpc:=0) SIZE 050, 010 OF oDlgCnt PIXEL
	
	ACTIVATE MSDIALOG oDlgCnt CENTERED
	
	If nOpc == 1
	Endif

//RestArea(aArea)
Return .t.


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuncao    ConsFin   ณ Autor ณ Luiz Alberto        ณ Data ณ29.11.2014ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Consulta Situa็ใo Financeira do Cliente      ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณRetorno   ณ Nenhum                                                     ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function ConsFin(nPos)
Local aArea := GetArea()  

// Localiza Vetor Marcado
nPos := 0;For nI := 1 To Len(aCiclos);If aCiclos[nI,2]=='1';nPos	:=	nI;Exit;Endif;Next

If Empty(nPos)
	Return .f.
Endif

SA1->(dbGoTo(aCiclos[nPos,DT_RECNO2]))

cCadastro := 'Posi็ใo Financeira'
aRotina	:= {{ "Pesquisar"  	,"AxPesqui"        	,0,1 },; 	// "Pesquisar"
			{ "Visualizar"	,"TK271CallCenter" 	,0,2 },; 	// "Visualizar"
			{ "Incluir"  	,"TK271CallCenter" 	,0,3 },; 	// "Incluir"
			{ "Legenda" 	,"U_MeLegen()"	   	,0,2 }} 	// "Imprime Or็amento"   						

Fc010Con('SA1',SA1->(RECNO()),1)

RestArea(aArea)
Return .t.



Static Function ProcCont(aContat,cCodigo,cLoja,lProspect)

If Select("CHK1") <> 0
	CHK1->(dbCloseArea())
Endif

If !lProspect
	cQuery := 	 " SELECT U5_CONTAT, U5_DDD, U5_FCOM1, U5_FCOM2, U5_CELULAR, U5_EMAIL, ISNULL(UM.UM_DESC,'') UM_DESC, SU5.R_E_C_N_O_ U5_REG "
	cQuery +=	 " FROM " + RetSqlName("AC8")+" AC8 "
	cQuery +=	 " INNER JOIN " + RetSqlName("SU5")+" SU5 "
	cQuery +=	 " ON U5_CODCONT = AC8.AC8_CODCON AND SU5.D_E_L_E_T_ = '' "
	cQuery +=	 " LEFT JOIN " + RetSqlName("SUM")+" UM "
	cQuery +=	 " ON UM.UM_CARGO = SU5.U5_FUNCAO AND UM.D_E_L_E_T_ = '' "
	cQuery +=	 " WHERE AC8.AC8_ENTIDA = 'SA1' "
	cQuery +=	 " AND AC8.AC8_CODENT = '" + cCodigo+cLoja+"' "
	cQuery +=	 " AND AC8.D_E_L_E_T_ = '' "
	cQuery +=	 " ORDER BY U5_CONTAT "
Else
	cQuery := 	 " SELECT U5_CONTAT, U5_DDD, U5_FCOM1, U5_FCOM2, U5_CELULAR, U5_EMAIL, ISNULL(UM.UM_DESC,'') UM_DESC, SU5.R_E_C_N_O_ U5_REG "
	cQuery +=	 " FROM " + RetSqlName("AC8")+" AC8 "
	cQuery +=	 " INNER JOIN " + RetSqlName("SU5")+" SU5 "
	cQuery +=	 " ON U5_CODCONT = AC8.AC8_CODCON AND SU5.D_E_L_E_T_ = '' "
	cQuery +=	 " LEFT JOIN " + RetSqlName("SUM")+" UM "
	cQuery +=	 " ON UM.UM_CARGO = SU5.U5_FUNCAO AND UM.D_E_L_E_T_ = '' "
	cQuery +=	 " WHERE AC8.AC8_ENTIDA = 'SUS' "
	cQuery +=	 " AND AC8.AC8_CODENT = '" + cCodigo+cLoja+"' "
	cQuery +=	 " AND AC8.D_E_L_E_T_ = '' "
	cQuery +=	 " ORDER BY U5_CONTAT "
Endif	
TCQUERY cQuery NEW ALIAS "CHK1"

Count To nReg

CHK1->(dbGoTop())

dbSelectArea("CHK1")
dbGoTop()    
ProcRegua(nReg)     

If Empty(nReg)
	aContat := {{'','','','','','','',0}}
Else
	aContat := {}
Endif

While CHK1->(!Eof())
	IncProc("Aguarde Localizando Contatos do Cliente Posicionado ")
	
	AAdd(aContat,{  Capital(CHK1->U5_CONTAT),;
					Capital(CHK1->UM_DESC),;
					CHK1->U5_DDD,;
					CHK1->U5_FCOM1,;
					CHK1->U5_FCOM2,;
					CHK1->U5_CELULAR,;
					CHK1->U5_EMAIL,;
					CHK1->U5_REG})

	CHK1->(dbSkip(1))
Enddo
CHK1->(dbCloseArea())

aSort(aContat,,,{|x,y|,x[1] < y[1]})

oCntCli:SetArray(aContat)
oCntCli:bLine := {|| {		aContat[oCntCli:nAt,1],;
       						aContat[oCntCli:nAt,2],;
       						aContat[oCntCli:nAt,3],;
       						aContat[oCntCli:nAt,4],;
       						aContat[oCntCli:nAt,5],;
       						aContat[oCntCli:nAt,6],;
       						aContat[oCntCli:nAt,7]}}
oCntCli:Refresh()
Return .t.


Static Function IncCont(lProspect)

nOpc := axInclui("SU5",0,3)

If nOpc == 1
	If RecLock("AC8",.t.)
		AC8->AC8_FILIAL	:=	xFilial("AC8")
		AC8->AC8_ENTIDA	:=	Iif(!lProspect,"SA1",'SUS')
		AC8->AC8_CODENT	:=	SA1->A1_COD+SA1->A1_LOJA
		AC8->AC8_CODCON	:=	SU5->U5_CODCONT
		AC8->(MsUnlock())
	Endif
Endif

Return .t.

Static Function PsqCont(cCodigo,cLoja,lProspect)
Local aArea := GetArea()

lRet := ConPad1( ,,,'SU5',,,.F. )

If lRet
	cQuery := 	 " SELECT U5_CONTAT "
	cQuery +=	 " FROM " + RetSqlName("AC8")+" AC8 "
	cQuery +=	 " INNER JOIN " + RetSqlName("SU5")+" SU5 "
	cQuery +=	 " ON U5_CODCONT = AC8.AC8_CODCON AND SU5.D_E_L_E_T_ = '' AND U5_CODCONT = '" + SU5->U5_CODCONT + "' "
	cQuery +=	 " LEFT JOIN " + RetSqlName("SUM")+" UM "
	cQuery +=	 " ON UM.UM_CARGO = SU5.U5_FUNCAO AND UM.D_E_L_E_T_ = '' "
	If !lProspect
		cQuery +=	 " WHERE AC8.AC8_ENTIDA = 'SA1' "
	Else
		cQuery +=	 " WHERE AC8.AC8_ENTIDA = 'SUS' "
	Endif
	cQuery +=	 " AND AC8.AC8_CODENT = '" + cCodigo+cLoja+"' "
	cQuery +=	 " AND AC8.D_E_L_E_T_ = '' "
	cQuery +=	 " ORDER BY U5_CONTAT "
		
	TCQUERY cQuery NEW ALIAS "CHK1"
	
	If !Empty(CHK1->U5_CONTAT)
		CHK1->(dbCloseArea())
		RestArea(aArea)
		MsgStop("Aten็ใo Contato Jแ Pertence ao Cliente Selecionado !")
		Return .f.
	Endif
	
	CHK1->(dbCloseArea())

	If RecLock("AC8",.t.)
		AC8->AC8_FILIAL	:=	xFilial("AC8")
		AC8->AC8_ENTIDA	:=	Iif(!lProspect,"SA1",'SUS')
		AC8->AC8_CODENT	:=	cCodigo+cLoja
		AC8->AC8_CODCON	:=	SU5->U5_CODCONT
		AC8->(MsUnlock())
	Endif
Endif

RestArea(aArea)
Return .t.


Static Function ExcCont(cCodigo,cLoja,lProspect)
Local aArea := GetArea()

If MsgNoYes("Deseja Realmente Excluir o Relacionamento com Este Contato ? ",OemToAnsi('ATENCAO'))
	If SUC->(dbSetOrder(6), DbSeek(xFilial("SUC")+SU5->U5_CODCONT)) .And. Empty(SUC->UC_DTENCER)
		MsgStop("Contato Possui Atendimento em Aberto - Numero: " + SUC->UC_CODIGO + " Nใo Pode Ser Excluido !","Aten็ใo")	
		Return .f.
	Endif

	If SUA->(dbSetOrder(11), DbSeek(xFilial("SUA")+SU5->U5_CODCONT)) .And. SUA->UA_CLIENTE+SUA->UA_LOJA == cCodigo+cLoja
		MsgStop("Contato Possui Or็amento - Numero: " + SUA->UA_NUM + " Nใo Pode Ser Excluido !","Aten็ใo")	
		Return .f.
	Endif

	If AC8->(dbSetOrder(1), dbSeek(xFilial("AC8")+SU5->U5_CODCONT+Iif(!lProspect,'SA1','SUS')+xFilial("AC8")+cCodigo+cLoja))
		If RecLock("AC8",.f.)
			AC8->(dbDelete())
			AC8->(MsUnlock())
		Endif
	Endif
Endif

RestArea(aArea)
Return .t.



Static Function PrcCiclo(aCiclos,lTudo,cVend,aVends)

DEFAULT lTudo := .f.
DEFAULT cVend := ''
DEFAULT aVends := {}


aCiclos := {}
aVends  := {'       - Todos'}

cQuery := 	 "  SELECT Z4_CICLO, Z4_CLIENTE, Z4_LOJA, Z4_NOME, A1_NREDUZ, A1_DDD, A1_TEL, A1_TELEX, A1_COMPLEM, A1_CONTATO, "
cQuery +=	 " 		A1_EMAIL, "
cQuery +=	 " 		Z4.R_E_C_N_O_ Z4REG, "
cQuery +=	 " 		Z4_VENCICL,  "
cQuery +=	 " 		Z4_VEND,  "
cQuery +=	 " 		A1_ULTACAO, "
cQuery +=	 " 		Z4_CODMOT ,  "
cQuery +=	 " 		Z4_DATOCO ,  "
cQuery +=	 " 		A1_ULTCOM ,  "
cQuery +=	 " 		A1_NROCOM ,  "
cQuery +=	 " 		A1.R_E_C_N_O_ A1REG, "
cQuery +=	 " 		Z4.R_E_C_N_O_ Z4REG, "
cQuery +=	 " 		A1_CGC ,  "
cQuery +=	 " 		A1_NOME, "
cQuery +=	 " 		A1_MUN, "
cQuery +=	 " 		Z4_UVLFAT, "
cQuery +=	 " 		Z4_TVLFAT "
cQuery +=	 " FROM " + RetSqlName("SZ4") + " Z4 (NOLOCK), " + RetSqlName("SA1") + " A1 (NOLOCK)   "
cQuery +=	 " WHERE   Z4_FILIAL = '" + xFilial("SZ4") + "' "
cQuery +=	 " AND A1_FILIAL = '" + xFilial("SA1") + "' "
cQuery +=	 " AND A1.D_E_L_E_T_ = ''   "
cQuery +=	 " AND Z4.D_E_L_E_T_ = ''   "
cQuery +=	 " AND Z4.Z4_CLIENTE = A1.A1_COD "
cQuery +=	 " AND Z4.Z4_LOJA = A1.A1_LOJA "
cQuery +=	 " AND A1.A1_MSBLQL <> '1' "      
If !lTudo
	cQuery +=	 " AND Z4.Z4_CICLO <= '" + DtoS(dDataBase+nDiasVisao) + "' "
Endif
cQuery +=	 " AND A1.A1_MSBLQL <> '1' "
cQuery +=	 " AND Z4.Z4_ATIVO = 'S' "
cQuery +=	 " AND A1.A1_PESSOA = 'J' "
If cTipVen=='V'	// Vendedor Normal Entใo Filtra Clientes
	cQuery += 	 " AND Z4.Z4_VEND = '" + SA3->A3_COD + "' "
ElseIf !Empty(cVend) .And. cVend <> '- Todos'
	cQuery += 	 " AND Z4.Z4_VEND = '" + cVend + "' "
Endif
cQuery +=	 " ORDER BY Z4_CICLO DESC, Z4_NOME 
	
TCQUERY cQuery NEW ALIAS "CHK1"

TcSetField('CHK1','Z4_CICLO','D')
TcSetField('CHK1','Z4_VENCICL','D')
TcSetField('CHK1','Z4_DATOCO','D')
TcSetField('CHK1','A1_ULTCOM','D')

Count To nReg

CHK1->(dbGoTop())

dbSelectArea("CHK1")
dbGoTop()    
ProcRegua(nReg)
While CHK1->(!Eof())
	IncProc("Aguarde Localizando Ciclos de Clientes ")     
	
	cStatus := '9' // Revertido
	If AD1->(dbSetOrder(7), dbSeek(xFilial("AD1")+CHK1->Z4_CLIENTE+CHK1->Z4_LOJA))
		While AD1->(!Eof()) .And. AD1->AD1_FILIAL == xFilial("AD1") .And. AD1->AD1_CODCLI == CHK1->Z4_CLIENTE .And. AD1->AD1_LOJCLI == CHK1->Z4_LOJA
			cStatus :=  AD1->AD1_STATUS
			
			AD1->(dbSkip(1))
		Enddo
		
		If cStatus <> '9'
			CHK1->(dbSkip(1));Loop
		Endif

	Endif
	
	SZ4->(dbGoTo(CHK1->Z4REG))

	SA1->(dbSetOrder(1), dbSeek(xFilial("SA1")+CHK1->Z4_CLIENTE+CHK1->Z4_LOJA))
	
	nMedia	:= SZ4->Z4_MCICLO
	
	SA3->(dbSetOrder(1), dbSeek(xFilial("SA3")+CHK1->Z4_VEND))
	
	cTpContrato	:=	''
	If ADA->(dbSetOrder(2), dbSeek(xFilial("ADA")+SA1->A1_COD+SA1->A1_LOJA)) .And. ADA->ADA_VIGFIM > Date()
		If ADA->ADA_TPCTR=='1'
			cTpContrato	:=	'Contrato'
		ElseIf ADA->ADA_TPCTR=='2'
			cTpContrato :=	'P.A.'
		ElseIf ADA->ADA_TPCTR=='3'
			cTpContrato :=	'Programa็ใo'
		Endif
	Endif

	// Consulta Titulo em Aberto do Cliente

	aAreaFIN := GetArea()
	
	cFinan	:=	''
	cQuery := 	 " SELECT TOP 1 E1_NUM "
	cQuery +=	 " FROM " + RetSqlName("SE1")
	cQuery +=	 " WHERE   E1_FILIAL = '" + xFilial("SE1") + "' "
	cQuery +=	 " AND D_E_L_E_T_ = ''   "
	cQuery +=	 " AND E1_VENCREA < '" + DtoS(dDataBase) + "' "
	cQuery +=	 " AND E1_CLIENTE = '" + SA1->A1_COD + "' AND E1_LOJA = '" + SA1->A1_LOJA + "' "
	cQuery +=	 " AND E1_SALDO > 0 "
	
	TCQUERY cQuery NEW ALIAS "CHKFIN"
	
	cFinan	:=	CHKFIN->E1_NUM
	
	CHKFIN->(dbCloseArea())
	
    RestArea(aAreaFin)
    
    

	AAdd(aCiclos,{oOk,;
					'2',;
					DtoC(CHK1->Z4_CICLO),;
					CHK1->Z4_CLIENTE,;
					CHK1->Z4_LOJA,;
					CHK1->A1_NREDUZ,;
					SA1->A1_DDD,;
					SA1->A1_TEL,;
					SA1->A1_CONTATO,;
					Lower(SA1->A1_EMAIL),;
					CHK1->Z4REG,;
					DtoC(CHK1->Z4_VENCICL),;
					.f.,;
					CHK1->Z4_CICLO,;
					SA3->A3_COD+'-'+Capital(SA3->A3_NREDUZ),;
					CHK1->A1REG,;
					CHK1->A1_ULTACAO,;
					TransForm(nMedia,'9,999,999')+ ' Dia(s)',;
					DtoS(CHK1->Z4_CICLO),;
					DtoS(CHK1->Z4_VENCICL),;
					CHK1->A1_TELEX,;
					CHK1->A1_COMPLEM,;
					'',;
					CHK1->Z4_CODMOT,;
					DtoC(CHK1->Z4_DATOCO),;
					DtoC(CHK1->A1_ULTCOM),;
					CHK1->A1_NROCOM,;
					CHK1->A1_CGC,;
					CHK1->A1_NOME,;
					cTpContrato,;
					cFinan,;
					'',;
					CHK1->A1_MUN,;
					CHK1->Z4_UVLFAT,;		// uLTIMO VALOR FATURADO
					CHK1->Z4_TVLFAT})		// ACUMULADO 12 MESES

	nAchou := aScan(aVends,SA3->A3_COD+'-'+Capital(SA3->A3_NREDUZ))
	If Empty(nAchou)
		AAdd(aVends,SA3->A3_COD+'-'+Capital(SA3->A3_NREDUZ))
	Endif
		
	CHK1->(dbSkip(1))
Enddo
CHK1->(dbCloseArea())

aSort(aVends) 

//Buscando Ultimos Pedidos dos Clientes ainda Nใo Faturados

nTotUltCom := 0.00
nTotAcumul := 0.00

ProcRegua(Len(aCiclos))
For nI := 1 To Len(aCiclos)
	dDataCiclo := CtoD(aCiclos[nI,DT_CICLO])
	nDias := (dDataCiclo-dDataBase)
	
	IncProc("Aguarde Buscando Pedidos Nใo Faturados ")

	cQuery := 	 " SELECT TOP 1 C5_NUM  "
	cQuery +=	 " FROM " + RetSqlName("SC5") + " SC5 (NOLOCK) "
	cQuery +=	 " WHERE  "
	cQuery +=	 " C5_FILIAL = '" + xFilial("SC5") + "' "
	cQuery +=	 " AND SC5.D_E_L_E_T_ = '' "      
	cQuery +=	 " AND SC5.C5_NOTA = '' "      
	cQuery +=	 " AND SC5.C5_CLIENTE = '" + aCiclos[nI,DT_CODIGO] + "' "
	cQuery +=	 " AND SC5.C5_LOJACLI = '" + aCiclos[nI,DT_LOJA]+ "' "
	cQuery +=	 " ORDER BY R_E_C_N_O_ DESC "      
		
	TCQUERY cQuery NEW ALIAS "CHK1"
	
	If !Empty(CHK1->C5_NUM)
		aCiclos[nI,DT_ULTPED] := CHK1->C5_NUM
	Endif
	
	CHK1->(dbCloseArea())

	If !Empty(aCiclos[nI,DT_FINAN])	// Indicacao de Titulo em Aberto no Financeiro
		aCiclos[nI,DT_LEG] := '1'
	ElseIf aCiclos[nI,DT_MOTIVO]=='0003'	// Insercao de Data de Ciclo Manualmente
		aCiclos[nI,DT_LEG] := '2'
	ElseIf !Empty(aCiclos[nI,DT_ULTPED])
		aCiclos[nI,DT_LEG] := '3'
	ElseIf nDias > 10             
		aCiclos[nI,DT_LEG] := '4'
	ElseIf nDias > 5 .And. nDias <= 10
		aCiclos[nI,DT_LEG] := '5'
	ElseIf nDias >= 1 .And. nDias <= 5
		aCiclos[nI,DT_LEG] := '6'
	Else                          
		aCiclos[nI,DT_LEG] := '7'
	Endif

	nTotUltCom += aCiclos[nI,DT_UFAT]
	nTotAcumul += aCiclos[nI,DT_TFAT]
Next

If Select("CHK1") <> 0
	CHK1->(dbCloseArea())
Endif	

If Empty(Len(aCiclos))
	aCiclos := {}
	AAdd(aCiclos,{oOk,;
					'2',;
					'',;
					'',;
					'',;
					'',;
					'',;
					'',;
					'',;
					'',;
					0,;
					'',;
					.f.,;
					CtoD(''),;
					'',;
					0,;
					'',;
					'',;
					'',;
					'',;
					'',;
					'',;
					'',;
					'',;
					'',;
					CtoD(''),;
					0,;
					'',;
					'',;
					'',;
					'',;
					'',;
					'',;
					0,;
					0})
Endif

oDtCiclos:SetArray(aCiclos)
oDtCiclos:bLine := {|| {	Iif(aCiclos[oDtCiclos:nAt,DT_MARCA]=="1",oSinalMk,;						//	1
   							U_RetLeg(aCiclos[oDtCiclos:nAt,DT_DTCICLO],oDtCiclos:nAt)),;			//	2
   							Iif(aCiclos[oDtCiclos:nAt,2]=="1",oOk,oNo),;							//	3
       						aCiclos[oDtCiclos:nAt,DT_VENDEDOR],;									//	4	
       						aCiclos[oDtCiclos:nAt,DT_VENCI],;										//	5
       						aCiclos[oDtCiclos:nAt,DT_CICLO],;										//	6
       						aCiclos[oDtCiclos:nAt,DT_CONTRATO],;									//	6
   							aCiclos[oDtCiclos:nAt,DT_CODIGO],;										// 	7
				      		aCiclos[oDtCiclos:nAt,DT_LOJA],;										//	8
				      		aCiclos[oDtCiclos:nAt,DT_NOME],;										//	9
				      		TransForm(aCiclos[oDtCiclos:nAt,DT_UFAT],'@E 9,999,999.99'),;										//	10	
				      		TransForm(aCiclos[oDtCiclos:nAt,DT_TFAT],'@E 99,999,999.99'),;										//	10	
				      		aCiclos[oDtCiclos:nAt,DT_MUN],;										    //	9
				      		aCiclos[oDtCiclos:nAt,DT_ULTPED],;										//	10	
				      		aCiclos[oDtCiclos:nAt,DT_MEDIA],;										//	11
				      		aCiclos[oDtCiclos:nAt,DT_ULTCOM],;										//	12
				      		aCiclos[oDtCiclos:nAt,DT_QTDCOM],;										//	13
				      		aCiclos[oDtCiclos:nAt,DT_DDD],;											//	14
				      		aCiclos[oDtCiclos:nAt,DT_TEL],;											//	15
				      		aCiclos[oDtCiclos:nAt,DT_TEL2],;										//	16
				      		aCiclos[oDtCiclos:nAt,DT_TEL3],;										//	17
				      		aCiclos[oDtCiclos:nAt,DT_CONTATO],;										//	18
				      		aCiclos[oDtCiclos:nAt,DT_ULTACAO],;										//	19
				      		aCiclos[oDtCiclos:nAt,DT_DATOCO],;										//	20
				      		aCiclos[oDtCiclos:nAt,DT_CNPJ],;										//	21
				      		aCiclos[oDtCiclos:nAt,DT_RAZAO]}}										//	22
oDtCiclos:nAt := 1
oDtCiclos:Refresh()

oRcp5:cCaption := "Clientes Ciclo Contato - " + cCargo + ' - ' + SA3->A3_COD + ' - ' + Capital(AllTrim(SA3->A3_NOME)) + ' - Total de ' + TransForm(Len(aCiclos),'@E 999,999') + ' Clientes em Ciclo - '+;
					' Total Ult. Compra: '+TransForm(nTotUltCom,'@E 999,999,999.99') + " - Total Acumulado: "+TransForm(nTotAcumul,'@E 999,999,999.99')
Return .t.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fContato บAutor  ณ Luiz Alberto     Data ณ  07/07/2015  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function EdiCon(cCodigo,cLoja,nPos,lProspect)
U_FContato(cCodigo,cLoja,nPos,lProspect)

Return .T.
Return .t.
                                                        
Static Function fVldDt(dDtCiclo)

xDtCiclo	:=	DataValida(dDtCiclo,.T.)

If xDtCiclo <> dDtCiclo
	MsgStop("Atencao Datas de Ciclo Nao Poderao mais ser agendadas aos sabados, domingos ou feriados !")
	Return .F.
Endif

Return .T.



Static Function fExcel(cTitulo,aCiclos,aTitulos)
local cDirDocs  := MsDocPath()
Local cPath		:= AllTrim(GetTempPath())
Local nHandle
Local cCrLf 	:= Chr(13) + Chr(10)
Local nX
Local cArquivo	:= 'C:\TEMP\'+'XLS_'+DtoS(dDataBase)+'.CSV'

If File(cArquivo)
	FErase(cArquivo)
Endif

aDados := {}
For nI := 1 To Len(aCiclos)
	AAdd(aDados,{aCiclos[nI,DT_VENDEDOR],;										// 	6
					aCiclos[nI,DT_VENCI],;										//	5
        			aCiclos[nI,DT_CICLO],;										//	6
        			aCiclos[nI,DT_CONTRATO],;									//	6
      				aCiclos[nI,DT_CODIGO],;										// 	7
					aCiclos[nI,DT_LOJA],;										//	8
					aCiclos[nI,DT_NOME],;										//	9
					TransForm(aCiclos[nI,DT_UFAT],'@E 9,999,999.99'),;			//	10	
					TransForm(aCiclos[nI,DT_TFAT],'@E 99,999,999.99'),;			//	11	
					aCiclos[nI,DT_MUN],;											//	12
					aCiclos[nI,DT_ULTPED],;										//	13	
					aCiclos[nI,DT_MEDIA],;										//	14
					aCiclos[nI,DT_ULTCOM],;										//	15
					TransForm(aCiclos[nI,DT_QTDCOM],'9,999'),;										//	16
					aCiclos[nI,DT_DDD],;											//	17
					aCiclos[nI,DT_TEL],;											//	18
					aCiclos[nI,DT_TEL2],;										//	19
					aCiclos[nI,DT_TEL3],;										//	20
					aCiclos[nI,DT_CONTATO],;										//	21
					aCiclos[nI,DT_ULTACAO],;										//	22
					aCiclos[nI,DT_DATOCO],;										//	23
					aCiclos[nI,DT_CNPJ],;										//	24
					aCiclos[nI,DT_RAZAO]})										//	25
Next

	
nHandle := MsfCreate(cArquivo,0)
	
If nHandle > 0
		
		// Grava o cabecalho do arquivo

		For nTitulo := 1 To Len(aTitulos)
			fWrite(nHandle, aTitulos[nTitulo] + ";" )
		Next

		fWrite(nHandle, cCrLf ) // Pula linha
		
		For nDados := 1 To Len(aDados)
			For nTitulo := 1 To Len(aTitulos)
				fWrite(nHandle, aDados[nDados,nTitulo] + ";" )
			Next
			
			fWrite(nHandle, cCrLf )
		
		Next

		fClose(nHandle)
/*		CpyS2T( cDirDocs+""+cArquivo+".CSV" , cPath, .T. ) */

		MsgInfo("Arquivo "+cArquivo+ " Gerado Com Sucesso !")
Else
		MsgAlert("Falha na cria็ใo do arquivo")
Endif
Return
Return .T.