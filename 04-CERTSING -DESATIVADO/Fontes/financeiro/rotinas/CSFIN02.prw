#include "protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CSFIN02  º Autor ³ Renato Ruy         º Data ³  11/08/14    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Gera título no financeiro para ser compensado com as NCC's º±±
±±º			 ³ para clientes que não constam no cadastro do fornecedor	  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Service Desk                                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CSFIN02()

Local aCpoBro  	:= {}
Local aButtons 	:= {}
Local aCores   	:= {}
Local cStatus  	:= ""
Local nWidth	:= oMainWnd:nClientWidth*.98
Local nHeight	:= oMainWnd:nClientHeight*.90

Private oDlg
Private	_stru	 := {}
Private dVencDev := dDataBase
Private cBanco   := Space(3)
Private cAgencia := Space(5)
Private cDigAge  := Space(2)
Private cConta   := Space(10)
Private cDigCon  := Space(2)
Private cMotivo  := Space(3)
Private cDescMot := ''
Private lInverte := .F.
Private cMark    := GetMark()
Private cGet 	 := "PESQUISAR POR PEDIDO PROTHEUS"

Private oMark

//Cria um arquivo de Apoio
AADD(_stru,{"OK"     ,"C"	,2		,0		})
AADD(_stru,{"SITUAC" ,"C"	,2		,0		})
AADD(_stru,{"FILIAL" ,"C"	,2		,0		})
AADD(_stru,{"PREFIXO","C"	,3		,0		})
AADD(_stru,{"TITULO" ,"C"	,9		,0		})
AADD(_stru,{"PARCELA","C"	,2		,0		})
AADD(_stru,{"TIPO"	 ,"C"	,3		,0		})
AADD(_stru,{"NATUREZ","C"	,10		,0		})
AADD(_stru,{"EMISSAO","D"	,8		,0		})
AADD(_stru,{"CLIENTE","C"	,6		,0		})
AADD(_stru,{"LOJA"	 ,"C"	,2		,0		})
AADD(_stru,{"NOME"	 ,"C"	,40		,0		})
AADD(_stru,{"VALOR"	 ,"N"	,15		,2		})
AADD(_stru,{"SALDO"	 ,"N"	,15		,2		})
AADD(_stru,{"RECE1"	 ,"N"	,15		,0		})

cArq:=Criatrab(_stru,.T.)

If Select("TTRB") > 0                    
	TTRB->(DbCloseArea())
EndIf

DBUSEAREA(.t.,,carq,"TTRB")

//Define as cores dos itens de legenda.

aCores := {}
aAdd(aCores,{"TTRB->SITUAC == 'BA'","BR_VERMELHO"})
aAdd(aCores,{"TTRB->SITUAC == 'SA'","BR_VERDE"	 })

//Define quais colunas (campos da TTRB) serao exibidas na MsSelect

aCpoBro	:= {{ "OK"			,, ""	            ,"@!"				},;
{ "FILIAL"		,, "Filial"         ,"@!"				},;
{ "PREFIXO"		,, "Prefixo"        ,"@!"				},;
{ "TITULO"		,, "Titulo"         ,"@!"				},;
{ "PARCELA"		,, "Parcela"        ,"@!"				},;
{ "TIPO"		,, "Tipo"     	    ,"@!"				},;
{ "EMISSAO"		,, "Emissão"        ,"@!"				},;
{ "CLIENTE"		,, "Cliente"        ,"@!"				},;
{ "LOJA"		,, "Loja"	        ,"@!"				},;
{ "NOME"		,, "Nome"	        ,"@!"				},;
{ "VALOR"		,, "Val.Titulo"		,"@E 999,999,999.99"}}


//Gustavo Prudente - Tela para busca e exibição de informações

DEFINE DIALOG oDlg TITLE "Compensação de NCC" FROM 50,50 TO 650,800 PIXEL
oDlg:lMaximized := .T.

// Cria a Folder
aTFolder := { 'Pedido Protheus', 'Nota Fiscal', 'Cliente' }

oTFolder := TFolder():New( 0,0,aTFolder,,oDlg,,,,.T.,,100, 30 )
oTFolder:Align := CONTROL_ALIGN_TOP                          

// Insere um TGet em cada aba da folder
oTGet := TGet():New( 15,01,{|x| Iif( PCount() > 0, cGet := x, cGet) },oDlg,150,009,;
				"",,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,cGet,,,, )

oTFolder:bChange := { || TFolderChg( oTFolder, oTGet, @cGet ) }           

// Botao buscar
oBtnBuscar := TButton():New( 15, 152, "&Buscar", oDlg, { || Processa( {|| BPesqui(cGet) }, "Aguarde...", "Carregando definição dos campos...",.F.)}, 040, 012,,,,.T.,,"",,,,.F. )

oPanelBrw 		:= tPanel():New( 00, 00, "", oDlg,,.T.,,,, 200, 200, .F., .T. )
oPanelBrw:Align := CONTROL_ALIGN_ALLCLIENT                       
                                 
oPanelBtn		 := tPanel():New( 01, 01, "", oDlg,,.T.,,,, 1, 13, .F., .T. )
oPanelBtn:Align	 := CONTROL_ALIGN_BOTTOM

oBtnSair := TButton():New( 15, 152, "&Sair", oPanelBtn, { || oDlg:End() }, 040, 012,,,,.T.,,"",,,,.F. )
oBtnSair:Align	 := CONTROL_ALIGN_RIGHT

oBtnComp := TButton():New( 15, 152, "&Compensar", oPanelBtn, { || IIF( VldField(), Processa( {|| uCompTit() }, "Aguarde...", "Efetuando Compensação dos Títulos...",.F.),;
																			 NIL )}, 040, 012,,,,.T.,,"",,,,.F. )
oBtnComp:Align	 := CONTROL_ALIGN_RIGHT

//Cria a MsSelect
oMark := MsSelect():New("TTRB","OK","",aCpoBro,@lInverte,@cMark,{1,1,(nHeight/2.3),(nWidth/2)},,,oPanelBrw,,aCores)
oMark:bMark := {| | Disp()} 
oMark:oBrowse:LHSCROLL := .F. //Retira o Scroll inferior
//oMark:Align := CONTROL_ALIGN_ALLCLIENT //Nao existe a propriedade no objeto MsSelect

@ 002,005 Say " Venc.Devolução: " of oPanelBtn Pixel
@ 001,050 MSGET dVencDev SIZE 50,08 OF oPanelBtn PIXEL PICTURE "@D"  

@ 002,105 Say " Banco: " of oPanelBtn Pixel
@ 001,130 MSGET cBanco SIZE 15,08 F3 "SA6" OF oPanelBtn PIXEL

@ 002,168 Say " Agência/Digito: " of oPanelBtn Pixel
@ 001,205 MSGET cAgencia SIZE 25,08 OF oPanelBtn PIXEL
@ 002,235 Say " / " of oPanelBtn Pixel
@ 001,240 MSGET cDigAge SIZE 10,08 OF oPanelBtn PIXEL 

@ 002,260 Say " Conta/Digito: " of oPanelBtn Pixel
@ 001,292 MSGET cConta SIZE 35,08 OF oPanelBtn PIXEL
@ 002,327 Say " / " of oPanelBtn Pixel
@ 001,332 MSGET cDigCon SIZE 10,08 OF oPanelBtn PIXEL

@ 002,350 Say " Motivo: " of oPanelBtn Pixel
@ 001,370 MSGET cMotivo F3 "SE1_BX" Valid VldMotBx( cMotivo, @cDescMot ) Picture "@!"  SIZE 15,08 PIXEL OF oPanelBtn
@ 002,400 Say cDescMot  SIZE 100,08  OF oPanelBtn PIXEL

ACTIVATE DIALOG oDlg

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

Static Function uCompTit()
Local aFornec 		:= {}
Local aTitulo 		:= {}
Local lMsErroAuto 	:= .F.
Local cCodnew		:= ""
Local aUf			:= {}
Local cCodUf		:= ""
Local aBaixa 		:= {}
Local nValTot		:= 0
Local cCNPJCPF		:= ""
Local cTitGrv		:= TTRB->TITULO

IncProc( "Gerando Cadastro do Fornecedor..")
ProcessMessage()

//Cria array com o código dos estados.
aadd(aUF,{"RO","11"})
aadd(aUF,{"AC","12"})
aadd(aUF,{"AM","13"})
aadd(aUF,{"RR","14"})
aadd(aUF,{"PA","15"})
aadd(aUF,{"AP","16"})
aadd(aUF,{"TO","17"})
aadd(aUF,{"MA","21"})
aadd(aUF,{"PI","22"})
aadd(aUF,{"CE","23"})
aadd(aUF,{"RN","24"})
aadd(aUF,{"PB","25"})
aadd(aUF,{"PE","26"})
aadd(aUF,{"AL","27"})
aadd(aUF,{"MG","31"})
aadd(aUF,{"ES","32"})
aadd(aUF,{"RJ","33"})
aadd(aUF,{"SP","35"})
aadd(aUF,{"PR","41"})
aadd(aUF,{"SC","42"})
aadd(aUF,{"RS","43"})
aadd(aUF,{"MS","50"})
aadd(aUF,{"MT","51"})
aadd(aUF,{"GO","52"})
aadd(aUF,{"DF","53"})
aadd(aUF,{"SE","28"})
aadd(aUF,{"BA","29"})
aadd(aUF,{"EX","99"})

DbSelectArea("SA1")
DbSetOrder(1)
DbSeek( xFilial("SA1") + TTRB->CLIENTE + TTRB->LOJA )

DbSelectArea("SA2")
DbSetOrder(3)
If !DbSeek( xFilial("SA2") + SA1->A1_CGC )
	
	cCodnew		:= GetSx8Num("SA2","A2_COD")
	
	SA2->(DbSetOrder(1))
	While DbSeek(xFilial("SA2") + cCodnew + "01")
		cCodnew := Soma1(cCodnew)
	EndDo
	
	cCodUf		:= aUF[aScan(aUF,{|x| x[1] == SA1->A1_EST})][02]
	
	DbSelectArea("VAM")
	DbSetOrder(1)
	If !DbSeek( xFilial("VAM") + cCodUf + SA1->A1_COD_MUN)
		RecLock("VAM",.T.)
		VAM->VAM_IBGE 	:= cCodUf + SA1->A1_COD_MUN
		VAM->VAM_DESCID := SA1->A1_MUN
		VAM->VAM_ESTADO := SA1->A1_EST
		VAM->(MsUnlock())
	EndIf
	
	aFornec := {	{"A2_COD"		,cCodnew			,nil},;
	{"A2_LOJA" 		,"01"		  		,nil},;
	{"A2_NOME" 		,SA1->A1_NOME      	,nil},;
	{"A2_NREDUZ"	,SA1->A1_NOME    	,nil},;
	{"A2_CEP" 		,SA1->A1_CEP      	,nil},;
	{"A2_END" 		,SA1->A1_END    	,nil},;
	{"A2_BAIRRO" 	,SA1->A1_BAIRRO    	,nil},;
	{"A2_EST" 		,SA1->A1_EST    	,nil},;
	{"A2_COD_MUN" 	,SA1->A1_COD_MUN   	,nil},;
	{"A2_MUN" 		,UPPER(SA1->A1_MUN)	,nil},;
	{"A2_COD_EST" 	,cCodUf			    ,nil},;
	{"A2_CODPAIS" 	,'01058'		    ,nil},;
	{"A2_TIPO" 		,SA1->A1_PESSOA   	,nil},;
	{"A2_CGC" 		,SA1->A1_CGC   	    ,nil},;
	{"A2_INSCR"		,SA1->A1_INSCR  ,nil},;
	{"A2_INSCRM"	,"ISENTO"		     ,nil},;
	{"A2_EMAIL" 	,"."			     ,nil},;
	{"A2_CONTA"		,"210301001"   ,nil},;
	{"A2_CALCIRF"	,"1"		        ,nil},;
	{"A2_RECISS"	,"N"		        ,nil},;
	{"A2_RECINSS"	,"N"		        ,nil},;
	{"A2_RECPIS"	,"2"		        ,nil},;
	{"A2_RECCOFI"	,"2"		        ,nil},;
	{"A2_RECCSLL"	,"2"		        ,nil},;
	{"A2_BANCO"	,cBanco		    ,nil},;
	{"A2_AGENCIA"	,cAgencia		    ,nil},;
	{"A2_DVAGEN"	,Iif(cBanco == "237",cDigAge," "),nil},;
	{"A2_NUMCON"	,cConta			    ,nil},;
	{"A2_DGCTAC"	,cDigCon	        ,nil}}
	
	
	
	MSExecAuto({|x,y| Mata020(x,y)},aFornec,3)
	
	If lMsErroAuto
		MostraErro()
		RollBackSX8()
		Return(.F.)
	Else
		SA2->(DbSetOrder(1))
		If !DbSeek(xFilial("SA2") + cCodnew + "01")
			Alert("O Fornecedor não pode ser criado, verifique os dados!")
			Return(.F.)
		Else
			ConfirmSX8()   // Confirma se o auto incremento foi usado;
		End
	EndIf
EndIf

//Faço Loop para somar caso exista mais de um título para gerar a compensação da NCC.
While !EOF("TTRB")
	
	If !Empty(TTRB->OK) .And. TTRB->TIPO == "NCC" .And. TTRB->SALDO > 0
		
		nValTot += TTRB->SALDO
		
	EndIf
	DbSelectArea("TTRB")
	DbSkip()
EndDo

IncProc( "Gravando Título a Pagar..")
ProcessMessage()

//MSEXECAUTO("ROTINA DE PAGAMENTO AUTOMATICO")
aTitulo :=  { {"E2_PREFIXO"	,"   "  	   					,Nil},;
{"E2_NUM"       ,cTitGrv						 ,Nil},;
{"E2_PARCELA"   ," "	                		 ,Nil},;
{"E2_TIPO"      ,"DEV"                  		 ,Nil},;
{"E2_NATUREZA"  ,"FT030004"             		 ,Nil},;
{"E2_FORNECE"   ,SA2->A2_COD           	   		 ,Nil},;
{"E2_LOJA"      ,SA2->A2_LOJA           		 ,Nil},;
{"E2_EMISSAO"   ,ddatabase              		 ,Nil},;
{"E2_VENCTO"    ,dVencDev  	            		 ,Nil},;
{"E2_VENCREA"   ,dVencDev              	 		 ,Nil},;
{"E2_VALOR"     ,nValTot		        		 ,Nil},;
{"E2_HIST"      ,"Reembolso NCC: "+TTRB->TITULO  ,NIL},;
{"E2_CCD"       ,"00000001"             		 ,Nil},;
{"E2_ITEMD"     ,"000000000"             		 ,Nil},;
{"E2_CLVLDB"    ,"000000000"             		 ,Nil},;
{"INDEX"        ,2                      		 ,Nil}}

DbSelectArea("SE2")
DbSetOrder(1)
If !DbSeek(xFilial("SE2") + "   " + cTitGrv + "  DEV")
	MsExecAuto( { |x,y,z| FINA050(x,y,z)}, aTitulo,, 3)
EndIf

If lMsErroAuto
	MostraErro()
	Return(.F.)
EndIf

DbSelectArea("TTRB")
DbGoTop()

IncProc( "Efetuando Baixas de Títulos..")
ProcessMessage()

While !EOF("TTRB")
	
	If !Empty(TTRB->OK) .And. TTRB->TIPO == "NCC"
		
		aBaixa := {}
		
		DbSelectArea("SE1")
		DbGoto(TTRB->RECE1)
		
		aBaixa := {	{"E1_PREFIXO"  ,SE1->E1_PREFIXO          ,Nil},;
		{"E1_NUM"      ,SE1->E1_NUM            ,Nil},;
		{"E1_PARCELA"  ,SE1->E1_PARCELA        ,Nil},;
		{"E1_TIPO"     ,"NCC"                  ,Nil},;
		{"E1_CLIENTE"  ,SE1->E1_CLIENTE        ,Nil},;
		{"E1_LOJA"     ,SE1->E1_LOJA           ,Nil},;
		{"E1_NATUREZ"  ,SE1->E1_NATUREZ        ,Nil},;
		{"AUTMOTBX"    ,cMotivo                ,Nil},;
		{"AUTBANCO"    ,""	                  ,Nil},;
		{"AUTAGENCIA"  ,""  	                  ,Nil},;
		{"AUTCONTA"    ,""          	        ,Nil},;
		{"AUTDTBAIXA"  ,dDataBase              ,Nil},;
		{"AUTDTCREDITO",dDataBase              ,Nil},;
		{"AUTHIST"     ,cDescMot               ,Nil},;
		{"AUTJUROS"    ,0                      ,Nil,.T.},;
		{"AUTMULTA"    ,0                      ,Nil,.T.},;
		{"AUTDESCONT"  ,0                      ,Nil,.T.},;
		{"AUTCM1"      ,0                      ,Nil,.T.},;
		{"AUTPRORATA"  ,0                      ,Nil,.T.},;
		{"AUTVALREC"   ,SE1->E1_SALDO          ,Nil}}
		
		If SE1->E1_SALDO > 0
			MSExecAuto({|x,y| Fina070(x,y)},aBaixa,3)
		End
		
		If lMsErroAuto
			MostraErro()
			Return(.F.)
		EndIf
		
	EndIf
	DbSelectArea("TTRB")
	DbSkip()
EndDo

//Efetuo Busca novamente dos dados para apresentar para o usuário.
BPesqui(cGet)

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

Static Function LegTit()

Local aLegenda:={}

AAdd(aLegenda,{'BR_VERDE'        ,"Em Aberto"		 })
AAdd(aLegenda,{'BR_VERMELHO'     ,"Título Baixado"	 })

BrwLegenda("Legenda","Legenda",aLegenda)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma	º TFolderChgº Autor ³ Gustavo Prudente   º Data ³  11/08/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Folder para tela principal.                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function TFolderChg( oTFolder, oTGet, cGet )
     
If oTFolder:nOption == 1
	cGet := "PESQUISAR POR PEDIDO PROTHEUS"
ElseIf oTFolder:nOption == 2
	cGet := "PESQUISAR POR NOTA FISCAL"
ElseIf oTFolder:nOption == 3
	cGet := "PESQUISAR POR CLIENTE"
EndIf	               

oTGet:Refresh()

Return  

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma	º BPesquiº 		Autor ³ Renato Ruy	   º 	Data ³  11/08/14  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Efetua Busca dos dados e alimenta MsSelect.                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function BPesqui(cGet)

Local cWhere := ""

IncProc("Efetuando Busca das Informações")
ProcessMessage()

If Select("TMPTIT") > 0
	TMPTIT->(DbCloseArea())
EndIf

If oTFolder:nOption == 1
cWhere := "% C5_FILIAL = '"+xFilial("SC5")+"' AND C5_NUM = '" + SubStr(AllTrim(cGet),1,6)+ "' AND %"
ElseIf oTFolder:nOption == 2
cWhere := "% F2_FILIAL = '"+xFilial("SF2")+"' AND F2_DOC = '" + SubStr(AllTrim(cGet),1,9)+ "' AND F2_SERIE = '" + AllTrim(SubStr(AllTrim(cGet),10,3))+ "' AND %"
ElseIf oTFolder:nOption == 3
cWhere := "% E1_FILIAL = '"+xFilial("SE1")+"' AND E1_CLIENTE = '" + SubStr(AllTrim(cGet),1,6)+ "' AND %"
EndIf

If oTFolder:nOption == 3
BeginSql Alias "TMPTIT"
	Column E1_EMISSAO	As Date
			
		SELECT DISTINCT
				E1_FILIAL,
				E1_PREFIXO,
				E1_NUM,
				E1_PARCELA,
				E1_TIPO,
				E1_NATUREZ,
				E1_EMISSAO,
				E1_CLIENTE,
				E1_LOJA,
				E1_NOMCLI,
				E1_VALOR,
				E1_SALDO,
				SE1.R_E_C_N_O_ RECSE1
			FROM %Table:SE1% SE1
			WHERE
			%EXP:cWhere%
			SE1.%NOTDEL% AND
			SE1.E1_NUM IS NOT NULL AND
			SE1.E1_TIPO = 'NCC'
			
EndSql
Else
BeginSql Alias "TMPTIT"
	Column E1_EMISSAO	As Date
			
		SELECT DISTINCT
				E1_FILIAL,
				E1_PREFIXO,
				E1_NUM,
				E1_PARCELA,
				E1_TIPO,
				E1_NATUREZ,
				E1_EMISSAO,
				E1_CLIENTE,
				E1_LOJA,
				E1_NOMCLI,
				E1_VALOR,
				E1_SALDO,
				SE1.R_E_C_N_O_ RECSE1
			FROM %Table:SC5% SC5
			LEFT JOIN %Table:SD2% SD2
			ON SD2.D2_FILIAL = %xFilial:SD2%  AND SC5.C5_NUM = SD2.D2_PEDIDO 
			LEFT JOIN SF2010 SF2
			ON SF2.F2_FILIAL = SD2.D2_FILIAL AND SF2.F2_DOC = SD2.D2_DOC AND SF2.F2_SERIE = SD2.D2_SERIE AND SF2.F2_CLIENTE = SD2.D2_CLIENTE AND SF2.F2_LOJA = SD2.D2_LOJA
			LEFT JOIN %Table:SD1% SD1
			ON SF2.F2_FILIAL = SD1.D1_FILIAL AND SD1.D1_NFORI = SD2.D2_DOC AND SD1.D1_ITEMORI = SD2.D2_ITEM AND SD1.D1_SERIORI = SD2.D2_SERIE AND SD1.%NOTDEL%
			LEFT JOIN %Table:SE1% SE1
			ON SE1.E1_FILIAL = ' ' AND (SE1.E1_NUM = SC5.C5_CHVBPAG OR SE1.E1_NUM = SD1.D1_DOC) AND SE1.E1_CLIENTE = SF2.F2_CLIENTE AND SE1.E1_LOJA = SF2.F2_LOJA AND SE1.%NOTDEL%
			WHERE
			%EXP:cWhere%
			SC5.%NOTDEL% AND
			SE1.E1_NUM IS NOT NULL AND
			SE1.E1_TIPO = 'NCC'
			
EndSql
EndIf

DbSelectArea("TMPTIT")

If Select("TTRB")>0
	
	TTRB->(DbGoTop())
		
	While TTRB->(!Eof())
		RecLock("TTRB",.F.)
			dbDelete()
		TTRB->(MsUnLock())
		
		TTRB->(DbSkip())
	EndDo
	
EndIf

While  TMPTIT->(!Eof())
	
	If !Empty(TMPTIT->E1_NUM)
		DbSelectArea("TTRB")
		RecLock("TTRB",.T.)
		
		TTRB->SITUAC	:= Iif(TMPTIT->E1_SALDO > 0,'SA','BA')
		TTRB->FILIAL	:= TMPTIT->E1_FILIAL
		TTRB->PREFIXO	:= TMPTIT->E1_PREFIXO
		TTRB->TITULO	:= TMPTIT->E1_NUM
		TTRB->PARCELA	:= TMPTIT->E1_PARCELA
		TTRB->TIPO		:= TMPTIT->E1_TIPO
		TTRB->NATUREZ	:= TMPTIT->E1_NATUREZ
		TTRB->EMISSAO	:= TMPTIT->E1_EMISSAO
		TTRB->CLIENTE	:= TMPTIT->E1_CLIENTE
		TTRB->LOJA		:= TMPTIT->E1_LOJA
		TTRB->NOME		:= TMPTIT->E1_NOMCLI
		TTRB->VALOR		:= TMPTIT->E1_VALOR
		TTRB->SALDO		:= TMPTIT->E1_SALDO
		TTRB->RECE1		:= TMPTIT->RECSE1
		
		MsunLock()
		TMPTIT->(DbSkip())
	EndIf
Enddo

DbSelectArea("TTRB")
DbGoTop()

Return

Static Function VldMotBx( cMotivo, cDescMot )
	SX5->( dbSetOrder(1) )
	IF .NOT. SX5->( dbSeek( xFilial('SX5') + 'ZS' + cMotivo ) )
		MsgAlert('Motivo não encontrado!')
		cMotivo  := ''
		cDescMot := ''
	Else
		cDescMot := rTrim( Posicione( 'SX5',1,xFilial('SX5') + 'ZS' + cMotivo, 'X5_DESCRI' ) )
	EndIF	
Return( .T. )

Static Function VldField()
	Local lRet := .T.
	Local cMSG := ''
	
	IF Empty( cBanco )
		cMSG += 'Banco - preenchimento obrigatório' + CRLF
		lRet := .F.
	EndIF
	
	IF Empty( cAgencia )
		cMSG += 'Agência - preenchimento obrigatório' + CRLF
		lRet := .F.
	EndIF
	
	IF cBanco == '237' .And. Empty( cDigAge )
		cMSG += 'Dígito agência - preenchimento obrigatório' + CRLF
		lRet := .F.
	EndIF
	
	IF Empty( cConta )
		cMSG += 'Conta - preenchimento obrigatório' + CRLF
		lRet := .F.
	EndIF
	
	IF Empty( cMotivo )
		cMSG += 'Motivo da baixa - preenchimento obrigatório' + CRLF
		lRet := .F.
	EndIF

	IF !lRet
		MsgAlert( 'Atenção, verifique o(s) seguinte(s) campo(s):' + CRLF + CRLF + cMSG, 'Compensação de NCC' )
	EndIF
Return( lRet )
