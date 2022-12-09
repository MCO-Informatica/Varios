#Include "protheus.ch"
#Include "fwmvcdef.ch"
#Include "tbiconn.ch"

User Function CSFIN01()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCSFIN01  บ Autor ณ Renato Ruy         บ Data ณ  17/01/14    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Gera tํtulo no financeiro para ser compensado com as NCC's บฑฑ
ฑฑบ			 ณ para clientes que nใo constam no cadastro do fornecedor	  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Service Desk                                               บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Local _stru	   := {}
Local aCpoBro  := {}
Local aButtons := {}
Local aCores   := {}
Local cStatus  := ""                                                                   

Private oDlg
Private dVencDev := dDataBase
Private lInverte := .F.
Private cMark   := GetMark()

Private oMark

If Empty(M->ADE_PEDGAR) .And. Empty(M->ADE_XPSITE)
	MsgInfo("O campo Pedido GAR e Pedido Site nใo estใo preenchidos, a opera็ใo nใo pode vincular com o tํtulo.")
	Return()
EndIf

aButtons :=  {{ 'TIT', {|| FWMsgRun(,{|| uCompTit()},'Compensa็ใo','Aguarde, compensando tํtulo(s)...'), oDlg:End() },"Compensar" },{ 'TIT', {|| LegTit() },"Legenda" }}

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
AADD(_stru,{"XNPSITE","C"	,10		,0		})
AADD(_stru,{"CHVBPAG","C"	,10		,0		})

cArq:=Criatrab(_stru,.T.)

DBUSEAREA(.t.,,carq,"TTRB")

//Alimenta o arquivo de apoio com os registros da Query.

	
If !Empty(M->ADE_PEDGAR)
			BeginSql Alias "TMPTIT"

				Column E1_EMISSAO	As Date
							
				SELECT distinct E1_FILIAL,
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
								C5_CHVBPAG,
				  			    E1_XNPSITE,
				        		SE1.R_E_C_N_O_ RECSE1 
				FROM %Table:SE1%  SE1,
				     %Table:SC5%  SC5
				WHERE 
				  SC5.C5_FILIAL=%EXP:xFilial("SC5")%  AND 
				  SC5.C5_CHVBPAG=%EXP:AllTrim(M->ADE_PEDGAR)% AND
				  SC5.%NOTDEL% AND
				  SC5.C5_CHVBPAG>' ' AND
				  SE1.E1_FILIAL= %EXP:xFilial("SE1")%  AND
				  SE1.E1_CLIENTE=SC5.C5_CLIENTE AND
				  SE1.E1_TIPO='NCC' AND 
				  SE1.E1_SALDO>0 AND
				  SE1.%NOTDEL% 
			EndSql

Else
			BeginSql Alias "TMPTIT"
				
				Column E1_EMISSAO	As Date
				SELECT DISTINCT E1_FILIAL,
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
								C5_CHVBPAG,
						        E1_XNPSITE,
						        SE1.R_E_C_N_O_ RECSE1 
				FROM %Table:SE1%  SE1,
				     %Table:SC5%  SC5
				WHERE 
				  SC5.C5_FILIAL=%EXP:xFilial("SC5")%  AND 
				  SC5.C5_XNPSITE=%EXP:AllTrim(M->ADE_XPSITE)% AND
				  SC5.%NOTDEL% AND
				  SC5.C5_XNPSITE>' ' AND
				  SE1.E1_FILIAL= %EXP:xFilial("SE1")%  AND
				  SE1.E1_CLIENTE=SC5.C5_CLIENTE AND
				  SE1.E1_TIPO='NCC' AND 
				  SE1.E1_SALDO>0 AND
				  SE1.%NOTDEL%  
				  
			EndSql
EndIf 
	

DbSelectArea("TMPTIT")
cSituaca:=''
While  TMPTIT->(!Eof())
	
	If !Empty(TMPTIT->E1_NUM)
	                                   
        If  TMPTIT->E1_SALDO <=0
         	cSituaca:='BA'  
        ElseIf !Empty(M->ADE_PEDGAR) .AND. M->ADE_PEDGAR<>TMPTIT->C5_CHVBPAG	        
	        cSituaca:='SO'  
        ElseIf !Empty(M->ADE_XPSITE) .AND. M->ADE_XPSITE<>TMPTIT->E1_XNPSITE	        
	        cSituaca:='SO'  
		ELSE
			cSituaca:='SA' 
		Endif
	
		DbSelectArea("TTRB")
		RecLock("TTRB",.T.)
		
		
		TTRB->SITUAC	:= cSituaca
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
		TTRB->CHVBPAG	:= TMPTIT->C5_CHVBPAG
		TTRB->XNPSITE	:= TMPTIT->E1_XNPSITE
			
		MsunLock()
		TMPTIT->(DbSkip())
	EndIf

Enddo

//Define as cores dos itens de legenda.

aCores := {}
aAdd(aCores,{"TTRB->SITUAC == 'BA'","BR_VERMELHO"})
aAdd(aCores,{"TTRB->SITUAC == 'SA'","BR_VERDE"	 })
aAdd(aCores,{"TTRB->SITUAC == 'SO'","BR_AMARELO"	 })
//Define quais colunas (campos da TTRB) serao exibidas na MsSelect

aCpoBro	:= {{ "OK"			,, ""	            ,"@!"				},;
{ "FILIAL"		,, "Filial"         ,"@!"				},;
{ "XNPSITE"		,, "Ped Site"       ,"@!"				},;
{ "CHVBPAG"		,, "Ped Gar"	    ,"@!"				},;
{ "PREFIXO"		,, "Prefixo"        ,"@!"				},;
{ "TITULO"		,, "Titulo"         ,"@!"				},;
{ "PARCELA"		,, "Parcela"        ,"@!"				},;
{ "TIPO"		,, "Tipo"     	    ,"@!"				},;
{ "SALDO"		,, "Saldo" 			,"@E 999,999,999.99"},;
{ "VALOR"		,, "Val.Titulo"		,"@E 999,999,999.99"},;
{ "EMISSAO"		,, "Emissใo"        ,"@!"				},;
{ "CLIENTE"		,, "Cliente"        ,"@!"				},;
{ "LOJA"		,, "Loja"	        ,"@!"				},;
{ "NOME"		,, "Nome"	        ,"@!"				}}


//Cria uma Dialog

DEFINE MSDIALOG oDlg TITLE "Compensa็ใo de Tํtulos" From 9,0 To 345,800 PIXEL

DbSelectArea("TTRB")
DbGotop()

@ 132,025 Say " Venc.Devolu็ใo: " of oDlg Pixel
@ 130,070 MSGET dVencDev SIZE 50,11 OF oDlg PIXEL PICTURE "@D"

//Cria a MsSelect
oMark := MsSelect():New("TTRB","OK","",aCpoBro,@lInverte,@cMark,{30,1,120,400},,,,,aCores)
oMark:bMark := {| | Disp()}

//Cria campo para digita็ใo da data de vencimento do tํtulo.

//Exibe a Dialog
ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,{|| oDlg:End()},{|| oDlg:End()},,aButtons)

//Fecha a Area e elimina os arquivos de apoio criados em disco.

TTRB->(DbCloseArea())
TMPTIT->(DbCloseArea())

Iif(File(cArq + GetDBExtension()),FErase(cArq  + GetDBExtension()) ,Nil)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDisp  	บ Autor ณ Renato Ruy         บ Data ณ  09/01/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Funcao executada ao Marcar/Desmarcar um registro.		  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Fun็ใo de usuแrio.                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณuGeraNCC 	บ Autor ณ Renato Ruy         บ Data ณ  09/01/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Fun็ใo para gerar devolu็ใo da nota e gera็ใo da NCC.	  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Fun็ใo de usuแrio.                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function uCompTit()

Local aFornec  := {}
Local aTitulo  := {}
Local cCodnew  := ""
Local aUf      := {}
Local cCodUf   := ""
Local aBaixa   := {}
Local nValTot  := 0
Local nOpc     := 3
Local cCNPJCPF := ""

Local nX       := 0
Local nHandle
Local cLogFile := "" //nome do arquivo de log a ser gravado
Local aLog     := {}
Local cLog	   := ''
Local lRet     := .F. // variแvel de controle interno da rotina automatica que informa se houve erro durante o processamento
Local cPath    := GetTempPath() //Fun็ใo que retorna o caminho da pasta temp do usuแrio logado, exemplo: %temp%
Local nA2NOME  := TamSX3("A2_NOME")[1]
Local nA2NREDUZ  := TamSX3("A2_NREDUZ")[1]

Local oModel := NIL
Local cA2_LOJA		:= ''
Local cA2_NOME		:= ''
Local cA2_NREDUZ	:= ''
Local cA2_CEP		:= ''
Local cA2_END		:= ''
Local cA2_BAIRRO	:= ''
Local cA2_EST		:= ''
Local cA2_COD_MUN	:= ''
Local cA2_TIPO		:= ''
Local cA2_CGC		:= ''
Local cA2_INSCR		:= ''

Private INCLUI      := .T.
PRIVATE lMsErroAuto := .F.
Private lMsHelpAuto	:= .T. 
Private lAutoErrNoFile := .T. 

oDlg:End() //Fecha tela.

//Cria array com o c๓digo dos estados.
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

If M->ADE_MSMCLT == "S" //Valida se ้ para o mesmo cliente ou para um novo.
	cCNPJCPF := Posicione("SA1",1, xFilial("SA1") + TTRB->CLIENTE + TTRB->LOJA,"A1_CGC") //Alimenta o CNPJ com o do cadastro do cliente.
Else
	If Empty(M->ADE_CGC)
		MsgInfo("Para reembolso onde o cliente nใo ้ o mesmo da compra, deve ser informado o CNPJ!")
		Return(.F.)
	EndIf
	
	cCNPJCPF := M->ADE_CGC //Alimenta com o conteudo do campo ADE.
EndIf

DbSelectArea("SA2")
DbSetOrder(3)
If !DbSeek( xFilial("SA2") + StrTran(cCNPJCPF,"-","") )
	
	If oModel == NIL
		oModel := FwLoadModel("MATA020")
		oModel:SetOperation(3)
		oModel:Activate()
	EndIf
	
	cCodnew	:= GetSx8Num("SA2","A2_COD")
	
	SA2->(DbSetOrder(1))
	While DbSeek(xFilial("SA2") + cCodnew + "01")
		cCodnew := Soma1(cCodnew)
	EndDo
		
	If M->ADE_MSMCLT == "S"
		
		DbSelectArea("SA1")
		DbSetOrder(1)
		Dbseek( xFilial("SA1") + TTRB->CLIENTE + TTRB->LOJA )
		
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
		
		cA2_NOME	:= Left(SA1->A1_NOME,nA2NOME)
		cA2_NREDUZ	:= Left(SA1->A1_NOME,nA2NREDUZ)
		cA2_CEP		:= SA1->A1_CEP
		cA2_END		:= SA1->A1_END
		cA2_BAIRRO	:= SA1->A1_BAIRRO
		cA2_EST		:= SA1->A1_EST
		cA2_COD_MUN	:= Left(SA1->A1_COD_MUN,5)
		cA2_MUN		:= UPPER(NoAcento(UPPER(M->ADE_MUN)))
		cA2_TIPO	:= SA1->A1_PESSOA
		cA2_CGC		:= SA1->A1_CGC
		cA2_INSCR	:= SA1->A1_INSCR
		cA2_DVAGEN	:= Iif(M->ADE_XBANCO == "237",M->ADE_XDAGEN," ")
	ELSE
		cCodUf		:= aUF[aScan(aUF,{|x| x[1] == M->ADE_EST})][02]
		
		DbSelectArea("VAM")
		DbSetOrder(1)
		If !DbSeek( xFilial("VAM") + cCodUf + M->ADE_CODMUN)
			RecLock("VAM",.T.)
			VAM->VAM_IBGE 	:= cCodUf + M->ADE_CODMUN
			VAM->VAM_DESCID := M->ADE_MUN
			VAM->VAM_ESTADO := M->ADE_EST
			VAM->(MsUnlock())
		EndIf
		
		cA2_NOME	:= Left(M->ADE_NOME,nA2NOME)
		cA2_NREDUZ	:= Left(M->ADE_NOME,nA2NREDUZ)
		cA2_CEP		:= M->ADE_CEP
		cA2_END		:= M->ADE_END
		cA2_BAIRRO	:= M->ADE_BAIRRO
		cA2_EST		:= M->ADE_EST
		cA2_COD_MUN	:= Left(M->ADE_CODMUN,5)
		cA2_MUN		:= UPPER(NoAcento(UPPER(M->ADE_MUN)))
		cA2_TIPO	:= M->ADE_PESSOA
		cA2_CGC		:= StrTran(M->ADE_CGC,"-","")
		cA2_INSCR	:= M->ADE_INSCR
		cA2_DVAGEN	:= Iif(M->ADE_XBANCO == "237",M->ADE_XDAGEN," ")
	ENDIF
	
	/*oModel:SetValue("SA2MASTER", "A2_COD"		, cCodnew		)
	oModel:SetValue("SA2MASTER", "A2_LOJA" 		, "01"			)
	oModel:SetValue("SA2MASTER", "A2_NOME" 		, cA2_NOME		)
	oModel:SetValue("SA2MASTER", "A2_NREDUZ"	, cA2_NREDUZ	)
	oModel:SetValue("SA2MASTER", "A2_CEP" 		, cA2_CEP		)
	oModel:SetValue("SA2MASTER", "A2_END" 		, cA2_END		)
	oModel:SetValue("SA2MASTER", "A2_BAIRRO"  	, cA2_BAIRRO	)
	oModel:SetValue("SA2MASTER", "A2_EST" 	 	, cA2_EST		)
	oModel:SetValue("SA2MASTER", "A2_COD_MUN" 	, cA2_COD_MUN	)
	oModel:SetValue("SA2MASTER", "A2_MUN" 		, cA2_MUN		)
	oModel:SetValue("SA2MASTER", "A2_COD_EST" 	, cCodUf		)
	oModel:SetValue("SA2MASTER", "A2_CODPAIS" 	, '01058'		)
	oModel:SetValue("SA2MASTER", "A2_TIPO" 		, cA2_TIPO		)
	oModel:SetValue("SA2MASTER", "A2_CGC" 		, cA2_CGC		)
	oModel:SetValue("SA2MASTER", "A2_INSCR"		, cA2_INSCR		)
	oModel:SetValue("SA2MASTER", "A2_INSCRM"	, "ISENTO"		)
	oModel:SetValue("SA2MASTER", "A2_EMAIL" 	, "."			)
	oModel:SetValue("SA2MASTER", "A2_CONTA"		, "210301001"	)
	oModel:SetValue("SA2MASTER", "A2_CALCIRF"	, "1"			)
	oModel:SetValue("SA2MASTER", "A2_RECISS"	, "N"			)
	oModel:SetValue("SA2MASTER", "A2_RECINSS"	, "N"			)
	oModel:SetValue("SA2MASTER", "A2_RECPIS"	, "2"			)
	oModel:SetValue("SA2MASTER", "A2_RECCOFI"	, "2"			)
	oModel:SetValue("SA2MASTER", "A2_RECCSLL"	, "2"			)
	oModel:SetValue("SA2MASTER", "A2_BANCO"		, M->ADE_XBANCO	)
	oModel:SetValue("SA2MASTER", "A2_AGENCIA"	, M->ADE_XAGENC	)
	oModel:SetValue("SA2MASTER", "A2_DVAGEN"	, cA2_DVAGEN	)
	oModel:SetValue("SA2MASTER", "A2_NUMCON"	, M->ADE_XNUMCO	)
	oModel:SetValue("SA2MASTER", "A2_DGCTAC"	, M->ADE_XDCONT	)
	
	If oModel:VldData()
		oModel:CommitData()
	Else
		aLog := oModel:GetErrorMessage()

		For nX := 1 To Len(aLog)
			If !Empty(aLog[nX])
				cLog += Alltrim(aLog[nX]) + CRLF
			EndIf
		Next nX

		lMsErroAuto := .T.

		//AutoGRLog(cLog)
	EndIf*/

	aDadosA2 := {}
	aAdd(aDadosA2,{	 "A2_COD"		, cCodnew		,Nil})
	aAdd(aDadosA2,{	 "A2_LOJA" 		, "01"			,Nil})
	aAdd(aDadosA2,{	 "A2_NOME" 		, cA2_NOME		,Nil})
	aAdd(aDadosA2,{	 "A2_NREDUZ"	, cA2_NREDUZ	,Nil})
	aAdd(aDadosA2,{	 "A2_CEP" 		, cA2_CEP		,Nil})
	aAdd(aDadosA2,{	 "A2_END" 		, cA2_END		,Nil})
	aAdd(aDadosA2,{	 "A2_BAIRRO"  	, cA2_BAIRRO	,Nil})
	aAdd(aDadosA2,{	 "A2_EST" 	 	, cA2_EST		,Nil})
	aAdd(aDadosA2,{	 "A2_COD_MUN" 	, cA2_COD_MUN	,Nil})
	aAdd(aDadosA2,{	 "A2_MUN" 		, cA2_MUN		,Nil})
	aAdd(aDadosA2,{	 "A2_COD_EST" 	, cCodUf		,Nil})
	aAdd(aDadosA2,{	 "A2_CODPAIS" 	, '01058'		,Nil})
	aAdd(aDadosA2,{	 "A2_TIPO" 		, cA2_TIPO		,Nil})
	aAdd(aDadosA2,{	 "A2_CGC" 		, cA2_CGC		,Nil})
	aAdd(aDadosA2,{	 "A2_INSCR"		, cA2_INSCR		,Nil})
	aAdd(aDadosA2,{	 "A2_INSCRM"	, "ISENTO"		,Nil})
	aAdd(aDadosA2,{	 "A2_EMAIL" 	, "."			,Nil})
	aAdd(aDadosA2,{	 "A2_CONTA"		, "210301001"	,Nil})
	aAdd(aDadosA2,{	 "A2_CALCIRF"	, "1"			,Nil})
	aAdd(aDadosA2,{	 "A2_RECISS"	, "N"			,Nil})
	aAdd(aDadosA2,{	 "A2_RECINSS"	, "N"			,Nil})
	aAdd(aDadosA2,{	 "A2_RECPIS"	, "2"			,Nil})
	aAdd(aDadosA2,{	 "A2_RECCOFI"	, "2"			,Nil})
	aAdd(aDadosA2,{	 "A2_RECCSLL"	, "2"			,Nil})
	aAdd(aDadosA2,{	 "A2_BANCO"		, M->ADE_XBANCO	,Nil})
	aAdd(aDadosA2,{	 "A2_AGENCIA"	, M->ADE_XAGENC	,Nil})
	aAdd(aDadosA2,{	 "A2_DVAGEN"	, cA2_DVAGEN	,Nil})
	aAdd(aDadosA2,{	 "A2_NUMCON"	, M->ADE_XNUMCO	,Nil})
	aAdd(aDadosA2,{	 "A2_DGCTAC"	, M->ADE_XDCONT	,Nil})
	
	MsAguarde({||MsExecAuto({|x,y| MATA020(x,y)}, aDadosA2, 3)}, "Criando Fornecedor","Criando Fornecedor",.F.)
		
	If lMsErroAuto
		cLogFile := cPath + "COMPENSACAO.LOG"		
		
		IF File( cLogFile )
			Ferase( cLogFile )
		EndIF			              		
		
		If (nHandle := MSFCreate(cLogFile,0)) <> -1				
			lRet := .T.			
		EndIf		
				
		If	lRet    //grava as informa็๕es de log no arquivo especificado			
			FWrite( nHandle, cLog )		
			FClose(nHandle)	
		
			MsgAlert('Nใo foi possํvel incluir o fornecedor, verifique no arquivo LOG','Compensar NCC')
			ShellExecute( "Open", cLogFile , '', '', 1 )	
		EndIf		
		
		RollBackSX8() // Se deu algum erro ele libera o nฐ do auto incremento para ser usado novamente;
	    Return(.F.)
	Else
		SA2->( DBCommit() )
		
		SA2->( dbGotop() )
		SA2->( DbSetOrder(1) )
		If .NOT. SA2->( DbSeek( xFilial("SA2") + cCodnew + "01") )
			MsgStop("O Fornecedor nใo pode ser criado, verifique os dados!",'Compensar NCC')
			Return(.F.)
		Else
			ConfirmSX8()   // Confirma se o auto incremento foi usado;
			MsgInfo("Fornecedor criado com sucesso!",'Compensar NCC')
		End
	EndIf
	oModel:DeActivate()
	oModel:Destroy()

Else
	//Altera็ใo no dados bancแrios.
	If oModel == NIL
		oModel := FwLoadModel("MATA020M")
		oModel:SetOperation(4)
		oModel:Activate()
	EndIf
	cA2_DVAGEN	:= Iif(M->ADE_XBANCO == "237",M->ADE_XDAGEN," ")

	oModel:SetValue("SA2MASTER", "A2_BANCO"		, M->ADE_XBANCO	)
	oModel:SetValue("SA2MASTER", "A2_AGENCIA"	, M->ADE_XAGENC	)
	oModel:SetValue("SA2MASTER", "A2_DVAGEN"	, cA2_DVAGEN		)
	oModel:SetValue("SA2MASTER", "A2_NUMCON"	, M->ADE_XNUMCO	)
	oModel:SetValue("SA2MASTER", "A2_DGCTAC"	, M->ADE_XDCONT	)	
	
	If oModel:VldData()
		oModel:CommitData()
	Else
		aLog := oModel:GetErrorMessage()

		For nX := 1 To Len(aLog)
			If !Empty(aLog[nX])
				cLog += Alltrim(aLog[nX]) + CRLF
			EndIf
		Next nX

		lMsErroAuto := .T.

		//AutoGRLog(cLog)
	EndIf
	If lMsErroAuto
		cLogFile := cPath + "COMPENSACAO.LOG"		
		
		IF File( cLogFile )
			Ferase( cLogFile )
		EndIF			              		
		
		If (nHandle := MSFCreate(cLogFile,0)) <> -1				
			lRet := .T.			
		EndIf		
				
		If	lRet    //grava as informa็๕es de log no arquivo especificado			
			FWrite( nHandle, cLog )		
			FClose(nHandle)	
		
			MsgAlert('Nใo foi possํvel alterar o fornecedor, verifique no arquivo LOG','Compensar NCC')
			ShellExecute( "Open", cLogFile , '', '', 1 )	
		EndIf		
		
		RollBackSX8() // Se deu algum erro ele libera o nฐ do auto incremento para ser usado novamente;
	  Return(.F.)
	EndIF
EndIf

DbSelectArea("TTRB")
DbGoTop()

//Fa็o Loop para somar caso exista mais de um tํtulo para gerar a compensa็ใo da NCC.
While !EOF("TTRB")
	
	If !Empty(TTRB->OK) .And. TTRB->TIPO == "NCC" .And. TTRB->SALDO > 0
		
		nValTot += TTRB->SALDO
		
	EndIf
	DbSelectArea("TTRB")
	DbSkip()
EndDo

If nValTot<> M->ADE_VLREM
  
	MsgInfo("O valor selecionado para compensa็ใo ้ diferente do valor indicado no Atendimento. Favor verificar com o solicitante")
	Return(.F.)

EndIf        
            

//MSEXECAUTO("ROTINA DE PAGAMENTO AUTOMATICO")
aTitulo :=  { {"E2_PREFIXO"	,"REE"  	   					,Nil},;
{"E2_NUM"       ,StrZero(Val(Iif(Empty(M->ADE_PEDGAR),M->ADE_XPSITE,M->ADE_PEDGAR)),9)  ,Nil},;
{"E2_PARCELA"   ," "	                		,Nil},;
{"E2_TIPO"      ,"DEV"                  		,Nil},;
{"E2_NATUREZA"  ,"FT030004"             		,Nil},;
{"E2_FORNECE"   ,SA2->A2_COD           	   		,Nil},;
{"E2_LOJA"      ,SA2->A2_LOJA           		,Nil},;
{"E2_EMISSAO"   ,ddatabase              		,Nil},;
{"E2_VENCTO"    ,dVencDev  	            		,Nil},;
{"E2_VENCREA"   ,dVencDev              	 		,Nil},;
{"E2_VALOR"     ,nValTot		        		,Nil},;
{"E2_HIST"      ,"Reembolso "+Iif(Empty(M->ADE_PEDGAR),"PSite:"+M->ADE_XPSITE,"PGar:"+M->ADE_PEDGAR),NIL},;
{"E2_CCD"       ,"00000001"             		,Nil},;
{"E2_ITEMD"     ,"000000000"             		,Nil},;
{"E2_CLVLDB"    ,"000000000"             		,Nil},;
{"INDEX"        ,2                      		,Nil}}

DbSelectArea("SE2")
DbSetOrder(1)
If !DbSeek(xFilial("SE2") + "REE" + StrZero(Val(Iif(Empty(M->ADE_PEDGAR),M->ADE_XPSITE,M->ADE_PEDGAR)),9) + "  DEV")
	MsExecAuto( { |x,y,z| FINA050(x,y,z)}, aTitulo,, 3)
EndIf

If lMsErroAuto
	MostraErro()
	Return(.F.)
EndIf

DbSelectArea("TTRB")
DbGoTop()

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
		{"AUTMOTBX"    ,"REE"                  ,Nil},;
		{"AUTBANCO"    ,""	                   ,Nil},;
		{"AUTAGENCIA"  ,""  	               ,Nil},;
		{"AUTCONTA"    ,""      		       ,Nil},;
		{"AUTDTBAIXA"  ,dDataBase              ,Nil},;
		{"AUTDTCREDITO",dDataBase              ,Nil},;
		{"AUTHIST"     ,"BX.REEMBOSLO-SERVICE DESK" ,Nil},;
		{"AUTJUROS"    ,0                      ,Nil,.T.},;
		{"AUTMULTA"    ,0                      ,Nil,.T.},;
		{"AUTDESCONT"  ,0                      ,Nil,.T.},;
		{"AUTCM1"      ,0                      ,Nil,.T.},;
		{"AUTPRORATA"  ,0                      ,Nil,.T.},;
		{"AUTVALREC"   ,SE1->E1_SALDO          ,Nil}}
		
		If SE1->E1_SALDO > 0
				
			FIE->(DbSetOrder(1))
			
			If FIE->(DbSeek(xFilial("FIE")+"R"+Alltrim(SE1->E1_NUM)))
				RecLock("FIE",.F.)
					FIE->(dbDelete())
				FIE->(MsUnLock())
			EndIf	
		
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

MsgInfo("Processo realizado com sucesso.",'Compensar NCC')

Return



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLegNcc 	บ Autor ณ Renato Ruy         บ Data ณ  09/01/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Legenda de NCC.											  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Fun็ใo de usuแrio.                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function LegTit()

Local aLegenda:={}

AAdd(aLegenda,{'BR_VERDE'        ,"Em aberto"		 })
AAdd(aLegenda,{'BR_VERMELHO'     ,"Tํtulo baixado"	 })
AAdd(aLegenda,{'BR_AMARELO'      ,"Tํtulo de outro pedido"})

BrwLegenda("Legenda","Legenda",aLegenda)

Return
