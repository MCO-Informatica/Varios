#Include "protheus.ch"
#Include "COLORS.CH"

#DEFINE XML_VERSION 		'<?xml version="1.0" encoding="ISO-8859-1" standalone="yes"?>'

User Function CSFAT01()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CSFAT01   º Autor ³ Renato Ruy         º Data ³  09/01/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Consulta as notas e título no sistema para gerar a NCC.    º±±
±±º          ³ Dentro do mês:					                          º±±
±±º          ³ Gera devolução para produto.		                          º±±
±±º          ³ Exclui a nota de serviço.		                          º±±
±±º          ³ NCC com a natureza FT020008.		                          º±±
±±º          ³ Fora do mês:		                          				  º±±
±±º          ³ Gera devolução para produto.		                          º±±
±±º          ³ NCC com a natureza FT020009.		                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Service Desk                                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Local _stru	   := {}
Local aCpoBro  := {}
Local aButtons := {}
Local aCores   := {}
Local aAreaSX1 := SX1->( GetArea() )
Local aArea    := GetArea()
Local nTotPed := 999999.99
Local nTotFat := 999999.99
Local nTotRec := 999999.99
Local nTotSol := 999999.99
Local nPosIni := 0
Local lOK := .F.

Local cStatus  := ""
                    
Private oDlg
Private lInverte := .F.
Private cMark   := GetMark()

Private oMark

If Empty(M->ADE_PEDGAR) .And. Empty(M->ADE_XPSITE)
	MsgInfo("O campo Pedido GAR e Pedido Site não estão preenchidos, a operação não pode vincular com a nota.")
	Return()
EndIf                  

// Salva ambiente
SaveInter()

aButtons :=  {{ 'NCC', {|| uGeraNCC() },"Gera NCC" },{ 'NCC', {|| LegNcc() },"Legenda" },{ 'NCC', {|| BlqPed() },"Bloqueia pedido" }}

//Cria um arquivo de Apoio
AADD(_stru,{"OK"     ,"C"	,2		,0		})
AADD(_stru,{"SITUAC" ,"C"	,2		,0		})
AADD(_stru,{"FILIAL" ,"C"	,2		,0		})
AADD(_stru,{"CLIENTE","C"	,6		,0		})
AADD(_stru,{"PEDGAR" ,"C"	,10		,0		})
AADD(_stru,{"PEDSITE","C"	,10		,0		})
AADD(_stru,{"XNATURE","C"	,10		,0		})
AADD(_stru,{"FORMPAG","C"	,1		,0		})
AADD(_stru,{"LOJA"	 ,"C"	,2		,0		})
AADD(_stru,{"NOME"   ,"C"	,40		,0		})
AADD(_stru,{"PEDIDO" ,"C"	,6		,0		})
AADD(_stru,{"NOTA"   ,"C"	,9		,0		})
AADD(_stru,{"EMISSAO","D"	,8		,0		})
AADD(_stru,{"SERIE"	 ,"C"	,3		,0		})
AADD(_stru,{"PREFIXO","C"	,3		,0		})
AADD(_stru,{"CONDPA" ,"C"	,3		,0		})
AADD(_stru,{"NUMERO" ,"C"	,9		,0		})
AADD(_stru,{"PARCELA","C"	,2		,0		})
AADD(_stru,{"TIPO"	 ,"C"	,3		,0		})
AADD(_stru,{"TIPONF" ,"C"	,1		,0		})
AADD(_stru,{"FORMUL" ,"C"	,1		,0		})
AADD(_stru,{"VALOR"  ,"N"	,16		,4		})
AADD(_stru,{"SALDO"  ,"N"	,16		,4		})
AADD(_stru,{"F2REC"  ,"N"	,16		,0		})

cArq:=Criatrab(_stru,.T.)

DBUSEAREA(.t.,,carq,"TTRB")

//Alimenta o arquivo de apoio com os registros da Query.

If !Empty(M->ADE_PEDGAR)
	BeginSql Alias "TMPNCC"
	
		Column F2_EMISSAO	As Date
		
		SELECT DISTINCT
		C5_CLIENT,
		C5_LOJACLI,
		C5_TIPMOV,
		C5_XNATURE,
		C5_CHVBPAG,
		C5_XNPSITE,
		A1_NOME,
		C5_NUM,
		F2_FILIAL,
		F2_DOC,
		F2_SERIE,
		F2_EMISSAO,
		F2_FORMUL,
		F2_TIPO,
		F2_COND,
		SF2.R_E_C_N_O_ SF2RECNO,
		E1_PREFIXO,
		E1_NUM,
		E1_PARCELA,
		E1_TIPO,
		CASE                              
		WHEN E1_SALDO IS NULL THEN -1000
		ELSE
		E1_SALDO
		END E1_SALDO,
		E1_VALOR
		FROM %Table:SC5% SC5
		LEFT JOIN %Table:SA1% SA1
		ON SA1.A1_COD = SC5.C5_CLIENT AND SA1.A1_LOJA = SC5.C5_LOJACLI AND SA1.%NOTDEL%
		LEFT JOIN SD2010 SD2
		ON SD2.D2_FILIAL BETWEEN '  ' AND 'ZZ' AND SC5.C5_NUM = SD2.D2_PEDIDO AND SD2.D_E_L_E_T_ = ' '
		LEFT JOIN SF2010 SF2
		ON SF2.F2_FILIAL = SD2.D2_FILIAL AND SF2.F2_DOC = SD2.D2_DOC AND SF2.F2_SERIE = SD2.D2_SERIE AND SF2.F2_CLIENTE = SD2.D2_CLIENTE AND SF2.F2_LOJA = SD2.D2_LOJA AND SF2.%NOTDEL%
		LEFT JOIN %Table:SE1% SE1
		ON SE1.E1_FILIAL = ' ' AND SE1.E1_NUM = SF2.F2_DUPL AND SF2.F2_PREFIXO = SE1.E1_PREFIXO AND SE1.E1_CLIENTE = SF2.F2_CLIENTE AND SE1.E1_LOJA = SF2.F2_LOJA AND SE1.%NOTDEL%
		WHERE
		SC5.C5_FILIAL = %xFilial:SC5% AND
		SC5.C5_CHVBPAG = %EXP:M->ADE_PEDGAR% AND
		SC5.%NOTDEL%
	
	EndSql
Else	
	BeginSql Alias "TMPNCC"
	
		Column F2_EMISSAO	As Date
	
		SELECT DISTINCT
		C5_CLIENT,
		C5_LOJACLI,
		C5_TIPMOV,
		C5_XNATURE,
		C5_CHVBPAG,
		C5_XNPSITE,
		A1_NOME,
		C5_NUM,
		F2_FILIAL,
		F2_DOC,
		F2_SERIE,
		F2_EMISSAO,
		F2_FORMUL,
		F2_TIPO,
		F2_COND,
		SF2.R_E_C_N_O_ SF2RECNO,
		E1_PREFIXO,
		E1_NUM,
		E1_PARCELA,
		E1_TIPO,
		CASE                              
		WHEN E1_SALDO IS NULL THEN -1000
		ELSE
		E1_SALDO
		END E1_SALDO,
		E1_VALOR
		FROM %Table:SC5% SC5
		LEFT JOIN %Table:SA1% SA1
		ON SA1.A1_COD = SC5.C5_CLIENT AND SA1.A1_LOJA = SC5.C5_LOJACLI AND SA1.%NOTDEL%
		LEFT JOIN SD2010 SD2
		ON SD2.D2_FILIAL BETWEEN '  ' AND 'ZZ' AND SC5.C5_NUM = SD2.D2_PEDIDO AND SD2.D_E_L_E_T_ = ' '
		LEFT JOIN SF2010 SF2
		ON SF2.F2_FILIAL = SD2.D2_FILIAL AND SF2.F2_DOC = SD2.D2_DOC AND SF2.F2_SERIE = SD2.D2_SERIE AND SF2.F2_CLIENTE = SD2.D2_CLIENTE AND SF2.F2_LOJA = SD2.D2_LOJA AND SF2.%NOTDEL%
		LEFT JOIN %Table:SE1% SE1
		ON SE1.E1_FILIAL = ' ' AND SE1.E1_NUM = SF2.F2_DUPL AND SF2.F2_PREFIXO = SE1.E1_PREFIXO AND SE1.E1_CLIENTE = SF2.F2_CLIENTE AND SE1.E1_LOJA = SF2.F2_LOJA AND SE1.%NOTDEL%
		WHERE
		SC5.C5_FILIAL = %xFilial:SC5% AND
		SC5.C5_XNPSITE = %EXP:M->ADE_XPSITE% AND
		SC5.%NOTDEL%
		
	EndSql
EndIf
	
DbSelectArea("TMPNCC")
nTotPed:=0
nTotFat:=0
nTotRec:=0
nTotSol:=M->ADE_VLREM
While  TMPNCC->(!Eof())
    
	If TMPNCC->E1_SALDO == 0
		cStatus := "BA"
	ElseIf TMPNCC->E1_SALDO > 0
		cStatus := "SA"
	Else
		cStatus := "NC"
	EndIf 

	DbSelectArea("SC5")
	DbSetOrder(1)
	If DbSeek(xFilial("SC5")+TMPNCC->C5_NUM)
		nTotPed:=SC5->C5_TOTPED
	Endif
	
	DbSelectArea("SF2")
	DbSetOrder(1)
	If DbSeek(TMPNCC->(F2_FILIAL+F2_DOC+F2_SERIE))
		nTotFat+=SF2->F2_VALBRUT
	Endif

	nTotRec+=TMPNCC->E1_VALOR

	
	DbSelectArea("TTRB")
	RecLock("TTRB",.T.)
	
	TTRB->SITUAC	:= cStatus
	TTRB->FILIAL	:= TMPNCC->F2_FILIAL
	TTRB->CLIENTE	:= TMPNCC->C5_CLIENT
	TTRB->PEDGAR	:= TMPNCC->C5_CHVBPAG
	TTRB->PEDSITE	:= TMPNCC->C5_XNPSITE
	TTRB->XNATURE   := TMPNCC->C5_XNATURE
	TTRB->FORMPAG	:= TMPNCC->C5_TIPMOV
	TTRB->NOME		:= TMPNCC->A1_NOME
	TTRB->LOJA		:= TMPNCC->C5_LOJACLI
	TTRB->PEDIDO	:= TMPNCC->C5_NUM
	TTRB->NOTA		:= TMPNCC->F2_DOC
	TTRB->SERIE		:= TMPNCC->F2_SERIE
	TTRB->EMISSAO	:= TMPNCC->F2_EMISSAO
	TTRB->TIPONF	:= TMPNCC->F2_TIPO
	TTRB->FORMUL	:= TMPNCC->F2_FORMUL
	TTRB->CONDPA	:= TMPNCC->F2_COND
	TTRB->PREFIXO	:= TMPNCC->E1_PREFIXO
	TTRB->NUMERO	:= TMPNCC->E1_NUM
	TTRB->PARCELA	:= TMPNCC->E1_PARCELA
	TTRB->TIPO		:= TMPNCC->E1_TIPO
	TTRB->VALOR		:= TMPNCC->E1_VALOR
	TTRB->SALDO		:= TMPNCC->E1_SALDO
	TTRB->F2REC		:= TMPNCC->SF2RECNO
	
	MsunLock()
	TMPNCC->(DbSkip())
Enddo

//Define as cores dos itens de legenda.

aCores := {}
aAdd(aCores,{"TTRB->SITUAC == 'BA'","BR_VERDE"	 })
aAdd(aCores,{"TTRB->SITUAC == 'SA'","BR_VERMELHO"})
aAdd(aCores,{"TTRB->SITUAC == 'NC'","BR_AMARELO" })

//Define quais colunas (campos da TTRB) serao exibidas na MsSelect

aCpoBro	:= {{ "OK"			,, ""	            ,"@!"				},;
{ "FILIAL"		,, "Filial"         ,"@!"				},;
{ "CLIENTE"		,, "Codigo"	        ,"@!"				},;
{ "NOME"		,, "Nome"           ,"@!"				},;
{ "LOJA"		,, "Loja"           ,"@!"				},;
{ "PEDIDO"		,, "Pedido"         ,"@!"				},;
{ "PEDGAR"		,, "Pedido Gar"     ,"@!"				},;
{ "PEDSITE"		,, "Pedido Site"    ,"@!"				},;
{ "EMISSAO"		,, "Emissão"        ,"@d"				},;
{ "NOTA"		,, "Nota"           ,"@!"				},;
{ "XNATURE"		,, "Natureza"       ,"@!"				},;
{ "SERIE"		,, "Serie"          ,"@!"				},;
{ "PREFIXO"		,, "Prefixo"        ,"@!"				},;
{ "TIPO"		,, "Tipo"	        ,"@!"				},;
{ "NUMERO"		,, "Titulo"         ,"@!"				},;
{ "PARCELA"		,, "Parcela"        ,"@!"				},;
{ "VALOR"		,, "Val.Titulo"		,"@E 999,999,999.99"}}

//Cria uma Dialog
 
DEFINE MSDIALOG oDlg TITLE "Pesquisa Faturamento" FROM 9,0 To 315,800 PIXEL
oDlg:lEscClose := .F.
EnchoiceBar(oDlg,{|| lOK := .T., oDlg:End() }, {|| oDlg:End() },,aButtons)
oPnla := TPanel():New(0,0,'',oDlg,NIL,.F.,,,,0,16,.F.,.T.)
oPnla:Align := CONTROL_ALIGN_BOTTOM

DbSelectArea("TTRB")
DbGotop()
 
//Cria a MsSelect
oMark := MsSelect():New("TTRB","OK","",aCpoBro,@lInverte,@cMark,{17,1,120,400},,,,oDlg,aCores)
oMark:bMark := {|| Disp()}
oMark:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
//---------------------------------------------------------------------------------------------------
// Esta instrução é para achar a posição inicial do botão no TPanel no sentido direita para esquerda.
nPosIni := (oPnla:oParent:nHeight) 

@ 01,nPosIni SAY "TotPed: R$ "+LTrim(Transform(nTotPed,"@R 999,999.99")) SIZE 100,8 OF oPnla PIXEL COLOR CLR_HBLUE
@ 09,nPosIni SAY "TotFat: R$ "+LTrim(Transform(nTotFat,"@R 999,999.99")) SIZE 100,8 OF oPnla PIXEL COLOR CLR_HBLUE
 
@ 01,nPosIni-100 SAY "TotRec: R$ "+LTrim(Transform(nTotRec,"@R 999,999.99")) SIZE 100,8 OF oPnla PIXEL COLOR CLR_HBLUE
@ 09,nPosIni-100 SAY "ReeSol: R$ "+LTrim(Transform(nTotSol,"@R 999,999.99")) SIZE 100,8 OF oPnla PIXEL COLOR CLR_HBLUE
ACTIVATE MSDIALOG oDlg CENTERED

If lOK
//Alert('clicou em Confirmar')
Else
//Alert('clicou em Cancelar')
Endif


 /*
DEFINE MSDIALOG oDlg TITLE "Pesquisa Faturamento" From 9,0 To 315,800 PIXEL

DbSelectArea("TTRB")
DbGotop()

//Cria a MsSelect
oMark := MsSelect():New("TTRB","OK","",aCpoBro,@lInverte,@cMark,{17,1,120,400},,,,,aCores)
oMark:bMark := {|| Disp()}
                               

@ 125,01 SAY "TotPed: R$ "+Transform(nTotPed,"999999.99")  
@ 125,25 SAY "TotFat: R$ "+Transform(nTotFat,"999999.99")  

@ 135,01 SAY "TotRec: R$ "+Transform(nTotRec,"999999.99")  
@ 135,25 SAY "ReeSol: R$ "+Transform(nTotSol,"999999.99")  



//Exibe a Dialog                                            //confirmar 
ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,{|| alert("ok"), oDlg:End()},{|| alert("cancel"), oDlg:End()},,aButtons)
*/

//Fecha a Area e elimina os arquivos de apoio criados em disco.

TTRB->(DbCloseArea())
TMPNCC->(DbCloseArea())

Iif(File(cArq + GetDBExtension()),FErase(cArq  + GetDBExtension()) ,Nil)
                              
// Restaura grupo de perguntas
RestArea( aAreaSX1 )                         
                              
// Restaura area utilizada antes de executar a rotina
RestArea( aArea )

// Restaura ambiente
RestInter()

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Disp  	º Autor ³ Renato Ruy         º Data ³  09/01/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Funcao executada ao Marcar/Desmarcar um registro.		  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Função de usuário.                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Disp()

RecLock("TTRB",.F.)

If Marked("OK")
	TTRB->OK := cMark
Else
	TTRB->OK := ""
Endif

MSUNLOCK()
oMark:oBrowse:Refresh()

Return()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³uGeraNCC 	º Autor ³ Renato Ruy         º Data ³  09/01/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Função para gerar devolução da nota e geração da NCC.	  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Função de usuário.                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function uGeraNCC()

Local cNumDev	  := ""
Local cTesDev	  := ""
Local nDevoluc	  := 0
LOCAL aDados 	  := {}
LOCAL aMata520Cab := {}
LOCAL _aCabSF1	  := {}
LOCAL _aLinha	  := {}
LOCAL _aItensSD1  := {}
LOCAL _cNatureza  := ""
LOCAL cIdEnt 	  := "000002"
Local lFatFil	  := .F.
Local cEmpOld	  := ""
Local cFIlOld	  := ""
Local cSerieSFW	  := ""
Local cSerieHRD	  := ""
//-- Nova intrução para o HUB cancelar o pedido (Rafael Beghini 13.09.2018)
Local cMSG := ""
Local cRET := ""
Local cPedLog := ""
Local lPolitica := .F.

PRIVATE lMsErroAuto := .F.
PRIVATE lMsHelpAuto := .F.


oDlg:End() //Fecha tela.

DbSelectArea("TTRB")
DbGoTop()

While TTRB->(!Eof())
	lFatFil := 	.F.
	lPolitica := .F.
	If !Empty(TTRB->OK) .And. TTRB->TIPO <> "NCC"
		
		//Caso Nota Fiscal esteja criada em filial diferente da corrente
		//altera a mesa para que todos os eventos de reembolso sejam realizados
		//na filial de origem da NF
		If TTRB->FILIAL <> cFilAnt
			lFatFil := .T.
			cEmpOld := cEmpAnt
			cFIlOld := cFilAnt
			
			STATICCALL( VNDA190, FATFIL, nil ,TTRB->FILIAL )
		EndIf
		
		cSerieSFW	  := GetNewPar("MV_GARSSFW","RP2")
		cSerieHRD	  := GetNewPar("MV_GARSHRD","2  ")		
		
		//Verifica se a nota é de servico
		If Alltrim(TTRB->SERIE) == Alltrim(cSerieSFW)
			//Executa para notas do mesmo mês.
			If SubStr(DtoC(TTRB->EMISSAO),4,5) == SubStr(DtoC(dDataBase),4,5)
			
				//Verifica se o título foi baixado, se já foi baixado não continua.
				If TTRB->SALDO == 0                                                                                                   
				    cMsg:="A Nota Fiscal não poderá ser excluida, o título encontra-se baixado ou compensado. " + chr(13)+chr(10)
				    cMsg+="Solicite análise da equipe finaceria de contas a receber antes de seguir com esta solicitação."
					MsgInfo(cMsg)
					Return()
				EndIf
				
				//Libera pedido para exclusão
				DbSelectArea("SC9")
				DbSetOrder(1)
				If DbSeek( xFilial("SC9")+TTRB->PEDIDO)
					RecLock("SC9",.F.)
					SC9->C9_NUMSEQ := " "
					SC9->C9_BLEST  := "  "
					SC9->(MsUnlock())
				End
				
				//Executa rotina de exclusão da nota.
				aMata520Cab   := {	{"F2_DOC"      ,TTRB->NOTA    ,Nil},; //numero da nota
				{"F2_SERIE"    ,TTRB->SERIE   ,Nil},; //serie
				{"F2_CLIENTE"  ,TTRB->CLIENTE ,Nil},; //Cliente
				{"F2_LOJA"     ,TTRB->LOJA    ,Nil},; //Loja
				{"F2_FORMUL"   ,TTRB->FORMUL  ,Nil},; //Formulário
				{"F2_TIPO"     ,TTRB->TIPONF  ,Nil}}  //Tipo da NF

				//Adiciona Pergunta para Contabilização
				Pergunte("MT460A",.F.)
				
				Mv_par03 := 1
				Mv_par04 := 1
				
				MSExecAuto({|x| MATA520(x)},aMata520Cab,5)
				
				//Me posiciono no Pedido de Venda Para Efetuar Bloqueio
				DbSelectArea("SC6")
				DbSetOrder(1)
				If DbSeek(xFilial("SC6")+TTRB->PEDIDO)
				    
					DbSelectArea("SC5")
					DbSetOrder(1)
					If DbSeek(xFilial("SC5")+TTRB->PEDIDO)
						
						//-- Nova intrução para o HUB cancelar o pedido (Rafael Beghini 13.09.2018)
						cMSG 		:= "Fluxo de Reembolso - Reembolsado em ["+DtoC(Date())+"-"+Time()+"]"
						cRET 		:= SC5->C5_XNPSITE + ';' + SC5->C5_NUM + ';F;REEMBOLSO;' + cMSG
						cPedLog 	:= IIF(!Empty(SC5->C5_CHVBPAG),SC5->C5_CHVBPAG,SC5->C5_XNPSITE)
						lPolitica 	:= Alltrim(SC5->C5_XMENSUG) == '024'

						RecLock("SC5",.F.)
							SC5->C5_XOBS 		:= " *** Pedido cancelado manualmente através da rotina ["+FunName()+"] por: " + AllTrim(cUserName) + CHR(13)+CHR(10)
							SC5->C5_XOBS 		+= " ATENDIMENTO SERVICE DESK: " + ADE->ADE_CODIGO + CHR(13)+CHR(10)+" MOTIVO: REEMBOLSO"
							SC5->C5_NOTA 		:= "XXXXXX   "
							SC5->C5_ARQVTEX 	:= "REEMBOLSO"
							
						SC5->(MsUnlock())
						
					EndIf
					
					While TTRB->PEDIDO == SC6->C6_NUM
						If Empty(SC6->C6_NOTA) .OR. lPolitica
							RecLock("SC6",.F.)
								SC6->C6_BLQ := "R"
								SC6->C6_XNFCANC := "S"
								SC6->C6_XDTCANC := DdataBase
								SC6->C6_XHRCANC := Time()		
							SC6->(MsUnlock())
						EndIf
						DbSelectArea("SC6")
						DbSkip()
					EndDo
					U_VNDA331( {'01','02',cRET} )
					U_GTPutOUT(SC5->C5_XNPSITE,"X",cPedLog,{"CSFAT01",{.F.,"M00002",cMSG}},SC5->C5_XNPSITE)
				EndIf
				//Fim da alteração para bloqueio
				
				
				//Não Gera NCC a patir de 01/01/15. A NCC já existe e foi criada no momento
				//do processamento do arquivo de retorno.
				//A contabilização do cancelamento da receita é pela exclusão da nota.
				/*
				aDados := { { "E1_PREFIXO"  , TTRB->PREFIXO    							, NIL },;
				{ "E1_NUM"      , Iif ( Empty(TTRB->PEDGAR),TTRB->PEDSITE,TTRB->PEDGAR) , NIL },;
				{ "E1_PARCELA"  , TTRB->PARCELA     									, NIL },;
				{ "E1_TIPO"     , "NCC"             									, NIL },;
				{ "E1_NATUREZ"  , "FT020008"        									, NIL },;
				{ "E1_NATUREZ"  , "FT020008"        									, NIL },;
				{ "E1_CLIENTE"  , TTRB->CLIENTE     									, NIL },;
				{ "E1_LOJA"  	, TTRB->LOJA	    									, NIL },;
				{ "E1_EMISSAO"  , dDataBase												, NIL },;
				{ "E1_VENCTO"   , dDataBase												, NIL },;
				{ "E1_VENCREA"  , dDataBase												, NIL },;
				{ "E1_VALOR"    , TTRB->VALOR       									, NIL } }
				*/
			
				
			Else 	//Executa para notas fora do mês.
			
				//Me posiciono no Pedido de Venda Para Efetuar Bloqueio de item restante para fora do mês.
				DbSelectArea("SC5")
				DbSetOrder(1)
				If DbSeek(xFilial("SC5")+TTRB->PEDIDO)
		
					//-- Nova intrução para o HUB cancelar o pedido (Rafael Beghini 13.09.2018)
					cMSG 		:= "Fluxo de Reembolso - Reembolsado em ["+DtoC(Date())+"-"+Time()+"]"
					cRET 		:= SC5->C5_XNPSITE + ';' + SC5->C5_NUM + ';F;REEMBOLSO;' + cMSG
					cPedLog 	:= IIF(!Empty(SC5->C5_CHVBPAG),SC5->C5_CHVBPAG,SC5->C5_XNPSITE)
					lPolitica 	:= Alltrim(SC5->C5_XMENSUG) == '024'
					
					RecLock("SC5",.F.)
						SC5->C5_XOBS 		:= " *** Pedido cancelado manualmente através da rotina ["+FunName()+"] por: " + AllTrim(cUserName) + CHR(13)+CHR(10)
						SC5->C5_XOBS 		+= " ATENDIMENTO SERVICE DESK: " + ADE->ADE_CODIGO + CHR(13)+CHR(10)+" MOTIVO: REEMBOLSO"
						SC5->C5_NOTA 		:= "XXXXXX   "
						SC5->C5_ARQVTEX 	:= "REEMBOLSO"
					SC5->(MsUnlock())					
					
				EndIf
				
				DbSelectArea("SC6")
				DbSetOrder(1)
				If DbSeek(xFilial("SC6")+TTRB->PEDIDO)
					    
					While TTRB->PEDIDO == SC6->C6_NUM
						If Empty(SC6->C6_NOTA) .OR. lPolitica
							RecLock("SC6",.F.)
								SC6->C6_BLQ := "R"
								SC6->C6_XNFCANC := "S"
								SC6->C6_XDTCANC := DdataBase
								SC6->C6_XHRCANC := Time()	
							SC6->(MsUnlock())
						EndIf
						DbSelectArea("SC6")
						DbSkip()
					EndDo
				EndIf
				U_VNDA331( {'01','02',cRET} )
				U_GTPutOUT(SC5->C5_XNPSITE,"X",cPedLog,{"CSFAT01",{.F.,"M00002",cMSG}},SC5->C5_XNPSITE)
				//Fim da alteração para bloqueio para fora do mês.
				//Neste caso. É necessário inclusão da NCC para estorno da receita. 
				
				aDados := { { "E1_PREFIXO"  , TTRB->PREFIXO    	, NIL },;
				{ "E1_NUM"      , Iif ( Empty(TTRB->PEDGAR),TTRB->PEDSITE,TTRB->PEDGAR) 	    , NIL },;
				{ "E1_PARCELA"  , TTRB->PARCELA      											, NIL },;
				{ "E1_TIPO"     , "NCC"              											, NIL },;
				{ "E1_NATUREZ"  , "FT020009"         											, NIL },;
				{ "E1_CLIENTE"  , TTRB->CLIENTE      											, NIL },;
				{ "E1_LOJA"  	, TTRB->LOJA	     											, NIL },;
				{ "E1_EMISSAO"  , dDataBase			 											, NIL },;
				{ "E1_VENCTO"   , dDataBase			 											, NIL },;
				{ "E1_VENCREA"  , dDataBase			 											, NIL },;
				{ "E1_PEDGAR"   , TTRB->PEDGAR		 											, NIL },;
				{ "E1_XNPSITE"  , TTRB->PEDSITE		 											, NIL },;
				{ "E1_HIST"     , Iif(!Empty(TTRB->PEDGAR),"Dev PGar: "+TTRB->PEDGAR,Iif(!Empty(TTRB->PEDSITE),"Dev PSite: "+TTRB->PEDSITE,' ')) , NIL },;
				{ "E1_VALOR"    , TTRB->VALOR        											, NIL } }

			EndIf
		EndIf
			
		If AllTrim(TTRB->SERIE) == Alltrim(cSerieHRD)
			
			//Valido a Natureza utilizada
			If SubStr(DtoC(TTRB->EMISSAO),4,5) == SubStr(DtoC(dDataBase),4,5)
				_cNatureza := "FT020008"
			Else
				_cNatureza := "FT020009"
			EndIf

			//Se a nota for de produto, gera nota de devolução.
			//LJ720NOTA(@cSerie, @cNumDoc) // pega numero da NF de entrada.
			AAdd( _aCabSF1, { "F1_DOC"    , "" 				, Nil } )	// Numero da NF
			AAdd( _aCabSF1, { "F1_SERIE"  , TTRB->SERIE		, Nil } )	// Serie da NF
			AAdd( _aCabSF1, { "F1_FORMUL" , "S"				, Nil } )  	// Formulario proprio
			AAdd( _aCabSF1, { "F1_EMISSAO", dDataBase		, Nil } )  	// Data emissao
			AAdd( _aCabSF1, { "F1_FORNECE", TTRB->CLIENTE	, Nil } )	// Codigo do Fornecedor
			AAdd( _aCabSF1, { "F1_LOJA"   , TTRB->LOJA 		, Nil } )	// Loja do Fornecedor
			AAdd( _aCabSF1, { "F1_TIPO"   , "D"				, Nil } )	// Tipo da NF
			//AAdd( _aCabSF1, { "F1_COND"   , "000"			, Nil } )	// Tipo da NF
			AAdd( _aCabSF1, { "F1_ESPECIE", "SPED"			, Nil } )	// Especie da NF
			AAdd( _aCabSF1, { "E2_NATUREZ", _cNatureza		, Nil } )	// Especie da NF
			
			DbSelectArea("SD2")
			DbSetOrder(3)
			DbSeek( xFilial("SD2") + TTRB->NOTA + TTRB->SERIE)
			
			While TTRB->NOTA == SD2->D2_DOC .And. TTRB->SERIE == SD2->D2_SERIE
				
				_aLinha:={}
				
				/*
				//Faz tratamento para TES de devolução, conforme planilha do faturamento.
				If SD2->D2_TES == "602" .Or. SD2->D2_TES == "603"
				cTesDev := "033"
				ElseIf SD2->D2_TES == "502"
				cTesDev := "032"
				ElseIf SD2->D2_TES == "701"
				cTesDev := "039"
				ElseIf SD2->D2_TES == "700"
				cTesDev := "018"
				ElseIf SD2->D2_TES == "702"
				cTesDev := "021"
				ElseIf Posicione("SF4",1,xFilial("SF4")+SD2->D2_TES,"F4_DUPLIC") == "S"
				cTesDev := "032"
				ElseIf Posicione("SF4",1,xFilial("SF4")+SD2->D2_TES,"F4_DUPLIC") == "N"
				cTesDev := "021"
				EndIf
				*/
			
				//Renato Ruy - 17/01/17
				//Busca TES de devolucao na TES de venda.
				SF4->(DbSetOrder(1))
				If SF4->(DbSeek(xFilial("SF4")+SD2->D2_TES))
					cTesDev := SF4->F4_TESDV
				EndIf
				
				AAdd( _aLinha, { "D1_DOC"     	, ""						, Nil } )
				AAdd( _aLinha, { "D1_SERIE"   	, TTRB->SERIE				, Nil } )
				AAdd( _aLinha, { "D1_FORNECE" 	, SD2->D2_CLIENTE			, Nil } )
				AAdd( _aLinha, { "D1_LOJA"    	, SD2->D2_LOJA				, Nil } )
				AAdd( _aLinha, { "D1_COD"     	, SD2->D2_COD				, Nil } )
				Aadd( _aLinha, { "D1_NFORI"     , TTRB->NOTA        		, Nil } )
				Aadd( _aLinha, { "D1_SERIORI"   , TTRB->SERIE       		, Nil } )
				Aadd( _aLinha, { "D1_ITEMORI" 	, SD2->D2_ITEM      		, Nil } )
				AAdd( _aLinha, { "D1_QUANT"	 	, SD2->D2_QUANT				, Nil } )
				AAdd( _aLinha, { "D1_VUNIT"	 	, SD2->D2_PRUNIT			, Nil } )
				AAdd( _aLinha, { "D1_TOTAL"	 	, SD2->D2_TOTAL				, Nil } )
				AAdd( _aLinha, { "D1_TES"	 	, cTesDev				 	, Nil } )
				AAdd( _aLinha, { "D1_IDENTB6" 	, " "				  		, Nil } )
				
				Aadd(_aItensSD1,_aLinha)
				
				//Soma para ver se já foi gerado devolução.
				nDevoluc += SD2->D2_QTDEDEV
				
				DbSelectArea("SD2")
				DbSkip()
			EndDo
		
			// Atualiza numero de NF de Devolucao antes de chamar a rotina automatica
			Do While Empty( AllTrim( cNumDev ) )
				cNumDev	:= PadR( NxtSX5Nota( Alltrim(TTRB->SERIE), .T., "2"), 9 )
			EndDo
			
			// Atualiza arrays de cabecalho e item de devolucao com o numero da NF de Devolucao
			_aCabSF1[ 1, 2 ] := cNumDev
			
			For nX := 1 To Len( _aItensSD1 )
				_aItensSD1[ nX, 1, 2 ] := cNumDev
			Next nX
			
			If nDevoluc == 0
				//Adiciona pergunta para contabilização.
				Pergunte("MTA103",.F.)
				Mv_par06 := 1
				
				MSExecAuto({|x,y,z| MATA103(x,y,z)},_aCabSF1,_aItensSD1,3)
				
				//Me Posiciono na nota de entrada
				SF1->(DbSetOrder(1))
				SF1->(DbSeek(xFilial("SF1")+cNumDev+TTRB->SERIE+TTRB->CLIENTE+TTRB->LOJA+"D"))
				
				//Me Posiciono nos livros fiscais
				SF3->(DbSetOrder(4))
				SF3->(DbSeek(xFilial("SF3")+TTRB->CLIENTE+TTRB->LOJA+cNumDev+TTRB->SERIE))				

				DbSelectArea("SE1")
				DbSetOrder(2)
				If DbSeek( xFilial("SE1") + TTRB->CLIENTE + TTRB->LOJA + TTRB->SERIE + cNumDev + 'A '+ "NCC")
				   RecLock("SE1",.F.)
						SE1->E1_PEDGAR := TTRB->PEDGAR		 										
						SE1->E1_XNPSITE:= TTRB->PEDSITE		 										
				   	    SE1->E1_HIST:=Iif(!Empty(TTRB->PEDGAR),"Dev PGar: "+TTRB->PEDGAR,Iif(!Empty(TTRB->PEDSITE),"Dev PSite: "+TTRB->PEDSITE,SE1->E1_HIST))   
				   MsUnlock()
				EndIf
				
				
			Else
				MsgInfo("Já foi gerada devolução para nota")
			EndIf
			
		EndIf
		
		//Elimina Resíduos para os itens sem nota fiscal
		If AllTrim(TTRB->SERIE) == "" .AND. AllTrim(TTRB->NOTA) == ""
		   //Me posiciono no Pedido de Venda Para Efetuar Bloqueio de item restante para fora do mês.
			DbSelectArea("SC5")
			DbSetOrder(1)
			If DbSeek(xFilial("SC5")+TTRB->PEDIDO)
				//If Empty(SC5->C5_NOTA)
					//-- Nova intrução para o HUB cancelar o pedido (Rafael Beghini 13.09.2018)
					cMSG 		:= "Fluxo de Reembolso - Reembolsado em ["+DtoC(Date())+"-"+Time()+"]"
					cRET 		:= SC5->C5_XNPSITE + ';' + SC5->C5_NUM + ';F;REEMBOLSO;' + cMSG
					cPedLog 	:= IIF(!Empty(SC5->C5_CHVBPAG),SC5->C5_CHVBPAG,SC5->C5_XNPSITE)
					
					RecLock("SC5",.F.)
						SC5->C5_XOBS 		:= " *** Pedido cancelado manualmente através da rotina ["+FunName()+"] por: " + AllTrim(cUserName) + CHR(13)+CHR(10)
						SC5->C5_XOBS 		+= " ATENDIMENTO SERVICE DESK: " + ADE->ADE_CODIGO + CHR(13)+CHR(10)+" MOTIVO: REEMBOLSO"
						SC5->C5_NOTA 		:= "XXXXXX   "
						SC5->C5_ARQVTEX 	:= "REEMBOLSO"
					SC5->(MsUnlock())
				//EndIf
			EndIf
			
			DbSelectArea("SC6")
			DbSetOrder(1)
			If DbSeek(xFilial("SC6")+TTRB->PEDIDO)
				    
				While TTRB->PEDIDO == SC6->C6_NUM
					RecLock("SC6",.F.)
					SC6->C6_BLQ := "R"
					SC6->C6_XNFCANC := "S"
					SC6->C6_XDTCANC := DdataBase
					SC6->C6_XHRCANC := Time()		
					SC6->(MsUnlock())
					DbSelectArea("SC6")
					DbSkip()
				EndDo
			EndIf
			U_VNDA331( {'01','02',cRET} )
			U_GTPutOUT(SC5->C5_XNPSITE,"X",cPedLog,{"CSFAT01",{.F.,"M00002",cMSG}},SC5->C5_XNPSITE)
		Endif
		
		
		IF Len(adados)>0
			DbSelectArea("SE1")
			DbSetOrder(2)
			If !DbSeek( xFilial("SE1") + TTRB->CLIENTE + TTRB->LOJA + TTRB->PREFIXO + PADR(TTRB->PEDGAR,9," ") + TTRB->PARCELA + "NCC")
				//Verifica se nao e cartao de credito e existia titulo.
				If TTRB->FORMPAG != "2" .And. !Empty(TTRB->NUMERO) .And. TTRB->SERIE != "2"
					Pergunte("FIN040",.F.)
					MV_PAR05 := 2
					MSExecAuto( { |x, y| FINA040(x, y) }, aDados, 3 )
				EndIf
			Else
				MsgInfo("O título já foi gerado anteriormente.")
				Return()
			EndIf
		Endif       
		
		//Retorna a Filial de origem
		If lFatFil
			STATICCALL( VNDA190, FATFIL, nil ,cFIlOld )
			lFatFil := .F.
			cEmpOld := ""
			cFIlOld := ""
		EndIf
	EndIf
	
	DbSelectArea("TTRB")
	DbSkip()
EndDo

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LegNcc 	º Autor ³ Renato Ruy         º Data ³  09/01/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Legenda de NCC.											  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Função de usuário.                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/  

Static Function LegNcc()

Local aLegenda:={}

AAdd(aLegenda,{'BR_VERDE'        ,"Título Baixado"   })
AAdd(aLegenda,{'BR_AMARELO'      ,"Não Existe Título"})
AAdd(aLegenda,{'BR_VERMELHO'     ,"Em Aberto"		 })

BrwLegenda("Legenda","Legenda",aLegenda)
                                                

Return 


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³uGeraNCC 	º Autor ³ Renato Ruy         º Data ³  09/01/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Função para gerar devolução da nota e geração da NCC.	  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Função de usuário.                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function BlqPed()

Local cDescri := CHR(13)+CHR(10) + " *** Pedido cancelado manualmente através da rotina ["+FunName()+"] por: " + AllTrim(cUserName) + CHR(13)+CHR(10)
Local aRet 		:= {}
Local bValid  	:= {|| .T. }

Private aPar 	:= {}

//Utilizo parambox para fazer as perguntas
aAdd( aPar,{ 2  	,"Tipo bloqueio:" 	 	,"REEMBOLSO" 	,{"REEMBOLSO","CARTÃO DE CREDITO"}, 100,'.T.',.T.})

ParamBox( aPar, 'Selecione o tipo de bloqueio', @aRet, bValid, , , , , ,"CRPA031" , .T., .F. )


oDlg:End() //Fecha tela.

DbSelectArea("TTRB")
DbGoTop()

While TTRB->(!Eof())
	
	If !Empty(TTRB->OK) 
		
		If AllTrim(TTRB->SERIE) == "" .AND. AllTrim(TTRB->NOTA) == ""
		   //Me posiciono no Pedido de Venda Para Efetuar Bloqueio de item restante para fora do mês.
			DbSelectArea("SC5")
			DbSetOrder(1)
			If DbSeek(xFilial("SC5")+TTRB->PEDIDO)
				
				If aRet[1] == "REEMBOLSO"
					cDescri += "BLOQUEADO POR: " + aRet[1] + CHR(13)+CHR(10)
				Else
					cDescri += "BLOQUEADO POR ESTORNO: " + aRet[1] + CHR(13)+CHR(10)
				Endif
				cDescri += "ATENDIMENTO SERVICE DESK: " + ADE->ADE_CODIGO
				 
				//If Empty(SC5->C5_NOTA)
					//-- Nova intrução para o HUB cancelar o pedido (Rafael Beghini 13.09.2018)
					cMSG := "Fluxo de Reembolso - Reembolsado em ["+DtoC(Date())+"-"+Time()+"]"
					cRET := SC5->C5_XNPSITE + ';' + SC5->C5_NUM + ';F;REEMBOLSO;' + cMSG
					cPedLog := IIF(!Empty(SC5->C5_CHVBPAG),SC5->C5_CHVBPAG,SC5->C5_XNPSITE)
						
					RecLock("SC5",.F.)
						SC5->C5_XOBS 		:= cDescri 
						SC5->C5_NOTA 		:= "XXXXXX   "
						SC5->C5_ARQVTEX 	:= "REEMBOLSO"
					SC5->(MsUnlock())
				//EndIf
			EndIf
			
			DbSelectArea("SC6")
			DbSetOrder(1)
			If DbSeek(xFilial("SC6")+TTRB->PEDIDO)
				    
				While TTRB->PEDIDO == SC6->C6_NUM
					RecLock("SC6",.F.)
					SC6->C6_BLQ := "R"
					SC6->C6_XNFCANC := "S"
					SC6->C6_XDTCANC := DdataBase
					SC6->C6_XHRCANC := Time()		
					SC6->(MsUnlock())
					DbSelectArea("SC6")
					DbSkip()
				EndDo
			EndIf
			U_VNDA331( {'01','02',cRET} )
			U_GTPutOUT(SC5->C5_XNPSITE,"X",cPedLog,{"CSFAT01",{.F.,"M00002",cMSG}},SC5->C5_XNPSITE)
		Endif
	
	EndIf
	
	DbSelectArea("TTRB")
	DbSkip()
EndDo

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CTSDK05   ºAutor  ³Giovanni		      º Data ³  10/10/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Consulta Dados do GAR                                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function fcPedGar()    

Local  aArea 
Local  oGet1
Local  cImp	   := " " 
Private cPedGar   := SPACE(18) 
Private oDlg 
Private lOpcao := .F. 

// Abre empresa para Faturamento retirar comentário para processamento em JOB
RpcSetType( 3 )
RpcSetEnv( '01', '02' )

aArea   := GetArea()


 DEFINE FONT oBold NAME "Arial" SIZE 0, -10 BOLD
 DEFINE MSDIALOG oDlg TITLE "DIGITE O NÚMERO DO PEDIDO GAR" FROM 000,000 TO 160,370 COLORS 100,300 PIXEL 
    @ 008,010 SAY "Pedido GAR"  FONT oBold  Size 035,015 OF oDlg COLORS 0,16777215 PIXEL 
 	@ 036,050 MSGET oGet1 VAR cPedGar SIZE 060,010 OF oDlg PIXEL
    @ 058,050 BUTTON OK PROMPT "OK" SIZE 037,012 OF oDlg PIXEL Action (lOpcao:=.T.,Close(oDlg))//Valid EXISTCPO("SZ3",cGet1)
    @ 058,098 BUTTON Cancelar PROMPT "Cancelar" SIZE 037,012 OF oDlg PIXEL Action (lOpcao:=.F.,Close(oDlg)) Cancel Of oDlg
 ACTIVATE MSDIALOG oDlg CENTERED 

If lOpcao == .T. .And. !Empty(cPedGar)    
   
   M->ADE_PEDGAR:=alltrim(cPedGar)
   M->ADE_XPSITE:=' '
   U_CSFAT01() 

Endif
 RestArea(aArea)
Return 