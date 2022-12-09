#Include "Totvs.ch"
#Include "TBICONN.CH"

//Renato Ruy - 13/06/2016
//Inclusão manual de agenda

User Function CSFA112(oGride)

Local nContato := AScan( oGride:aHeader,{|p| p[2]=='U6_CONTATO'})
Local nCodEnt  := AScan( oGride:aHeader,{|p| p[2]=='U6_CODENT'})
Local nTabEnt  := AScan( oGride:aHeader,{|p| p[2]=='U6_ENTIDA'})

//variaveis para controle de edição
Local lRazao	:= .T.
Local lNome		:= .T.
Local lCep		:= .T.
Local lEndere 	:= .T.
Local lComple 	:= .T.
Local lBairro 	:= .T.
Local lCodMun 	:= .T.
Local lMunici 	:= .T.
Local lUf 		:= .T.
Local lCgc 		:= .T.
Local lInscr 	:= .T.
Local lInscm 	:= .T.

//Informações do Contato
Local lCconta := .T.
Local lCcargo := .T.
Local lCtelef := .T.
Local lCArea  := .T.
Local lCEmail := .T.

//Informações do Contato Financeiro
Local lPconta := .T.
Local lPcargo := .T.
Local lPtelef := .T.
Local lPEmail := .T.

//Contato usado para base
Private cContato := oGride:aCols[oGride:nAt,nContato]
Private cCodEnt  := AllTrim(oGride:aCols[oGride:nAt,nCodEnt])
Private cCodTab  := oGride:aCols[oGride:nAt,nTabEnt]
Private nOpcao	 := 0

//Dados de faturamento
Private cCodigo := Space(006)	//Código do Cliente - Gerado pela integracao.
Private cRazao  := Space(060)	//Razao Social
Private cNome	:= Space(020)	//Nome Fantasia
Private cCep	:= Space(009)	//Nome Fantasia
Private cEndere := Space(100)	//Endereço
Private cComple := Space(050)	//Complemento
Private cBairro := Space(035)	//Bairro
Private cCodMun := Space(005)	//Cidade
Private cMunici := Space(035)	//Cidade
Private cUf 	:= Space(002)	//Estado
Private aUF 	:= {"AC=Acre","AL=Alagoas","AP=Amapá","AM=Amazonas","BA=Bahia","CE=Ceará","DF=Distrito Federal","ES=Espírito Santo","GO=Goiás","MA=Maranhão","MT=Mato Grosso","MS=Mato Grosso do Sul","MG=Minas Gerais","PA=Pará","PB=Paraíba","PR=Paraná","PE=Pernambuco","PI=Piauí","RJ=Rio de Janeiro","RN=Rio Grande do Norte","RS=Rio Grande do Sul","RO=Rondônia","RR=Roraima","SC=Santa Catarina","SP=São Paulo","SE=Sergipe","TO=Tocantins"}	//Estado
Private cCgc 	:= Space(018)	//CNPJ/CPF
Private cInscr 	:= Padr("ISENTO",18," ") //Inscrição Estadual
Private cInscm 	:= Padr("ISENTO",18," ") //Inscrição Municipal

//Informações do Contato
Private cCconta := Space(015)	//A1_CONTATO - Contato
Private cCcargo := Space(030)	//A1_CARGO1  - Cargo
Private cCtelef := Space(014)	//A1_TEL     - Telefone
Private cCArea 	:= Space(025)	//Área
Private cCEmail := Space(060)	//A1_EMAIL - Email

//Informações do Contato Financeiro
Private cPconta := Space(035)	//A1_CONTFIN - Contato
Private cPcargo := Space(025)	//A1_CARGO3  - Cargo
Private cPtelef := Space(014)	//A1_TELCONT -  Telefone
Private cPEmail := Space(060)	//A1_BLEMAIL - Email

//Agrupadores Contato
Private oGroup1, oGroup2

//Informação do cabeçalho da MsDialog
Private cCadastro	:= "Agenda Certisign - Inclusão de Clientes"	

// Cria dialogo
Private oDlgcli

//Origem Cliente - A1_ORIGCT - 1=Mailing;2=Campanha;3=Web;4=Indicacao;5=Evento;6=Anuncio;7=Parceiro;8=Relacoes Publicas;9=Seminario;A=Boca-a-boca;B=Outros


//Me posiciono no cadastro de contato - SU5
SU5->(DbSetOrder(1))
SU5->(DbSeek(xFilial("SU5")+cContato))

(cCodTab)->(DbSetOrder(1))
If (cCodTab)->(DbSeek(xFilial(cCodTab)+cCodEnt))
	If cCodTab == "PAB"
		cRazao  := PAB->PAB_EMPRESA		//Razao Social
		cNome	:= PAB->PAB_NOME		//Nome Fantasia
		cCep	:= PAB->PAB_CEP			//Nome Fantasia
		cEndere := PAB->PAB_END			//Endereço
		cComple := PAB->PAB_COMPL		//Complemento
		cBairro := PAB->PAB_BAIRRO		//Bairro
		cMunici := PAB->PAB_CIDADE		//Cidade
		cUf 	:= PAB->PAB_EST 		//Estado
		cCgc 	:= PAB->PAB_CNPJ		//CNPJ/CPF
	ElseIf cCodTab == "SZT"
		cRazao  := SZT->ZT_EMPRESA		//Razao Social
		cNome	:= SZT->ZT_NOME			//Nome Fantasia
		cUf 	:= SZT->ZT_UF 			//Estado
		cCgc 	:= SZT->ZT_CNPJ			//CNPJ/CPF
	ElseIf cCodTab == "SZX"
		cRazao  := SZX->ZX_DSRAZAO      //Razao Social
		cNome	:= SZX->ZX_DSRAZAO		//Nome Fantasia
		cMunici := SZX->ZX_DSMUNIC	    //Cidade
		cUf 	:= SZX->ZX_DSUF 		//Estado
		cCgc 	:= SZX->ZX_NRCNPJ		//CNPJ/CPF
	ElseIf cCodTab == "SA1"
		cCgc 	:= SA1->A1_CGC			//CNPJ/CPF
	ElseIf cCodTab == "SUS"
		cRazao  := SUS->US_NOME			//Razao Social
		cNome	:= SUS->US_NREDUZ		//Nome Fantasia
		cCep	:= SUS->US_CEP			//Nome Fantasia
		cEndere := SUS->US_END			//Endereço
		cBairro := SUS->US_BAIRRO		//Bairro
		cMunici := SUS->US_MUN			//Cidade
		cUf 	:= SUS->US_EST 			//Estado
		cCgc 	:= SUS->US_CGC			//CNPJ/CPF
	ElseIf cCodTab == "ACH"
		cRazao  := ACH->ACH_RAZAO		//Razao Social
		cNome	:= ACH->ACH_NFANT		//Nome Fantasia
		cCep	:= ACH->ACH_CEP			//Nome Fantasia
		cEndere := ACH->ACH_END			//Endereço
		cBairro := ACH->ACH_BAIRRO		//Bairro
		cMunici := ACH->ACH_CIDADE		//Cidade
		cUf 	:= ACH->ACH_EST 		//Estado
    	cCgc 	:= ACH->ACH_CGC			//CNPJ/CPF
	EndIf
EndIf


//Se encontrar o cliente, retorna as informações
SA1->(DbSetOrder(3))
If SA1->(DbSeek(xFilial("SA1")+U_CSFMTSA1(cCGC))) .And. !Empty(cCgc)
 
	If !MsgYesNo("O Cliente já está cadastrado, deseja alterar os dados cadastrais?")
		MsgInfo("Processo Cancelado!")
		Return
	EndIf
	
	//variaveis para controle de edição
	lRazao	:= .F.
	lNome	:= .F.
	lCep	:= .F.
	lEndere := .F.
	lComple := .F.
	lBairro := .F.
	lCodMun := .F.
	lMunici := .F.
	lUf 	:= .F.
	lCgc 	:= .F.
	lInscr 	:= .F.
	lInscm 	:= .F.
	            
	//Informações do Contato Financeiro
	lPconta := .F.
	lPcargo := .F.
	lPtelef := .F.
	lPEmail := .F.
	
	//Rotina automatica para alteracao.
	nOpcao := 4
	
	cCodigo := SA1->A1_COD		//Código do Cliente - Gerado pela integracao.
	cRazao  := SA1->A1_NOME		//Razao Social
	cNome	:= SA1->A1_NREDUZ	//Nome Fantasia
	cCep	:= SA1->A1_CEP		//Nome Fantasia
	cEndere := SA1->A1_END		//Endereço
	cComple := SA1->A1_COMPLEM	//Complemento
	cBairro := SA1->A1_BAIRRO	//Bairro
	cCodMun := SA1->A1_COD_MUN	//Cidade
	cMunici := SA1->A1_MUN		//Cidade
	cUf 	:= SA1->A1_EST 		//Estado
	cCgc 	:= SA1->A1_CGC		//CNPJ/CPF
	cInscr 	:= SA1->A1_INSCR	//Inscrição Estadual
	cInscm 	:= SA1->A1_INSCRM	//Inscrição Municipal
	//Se o sistema encontrar o cadastro, ja retorna as informacoes
	cCconta := PadR(SA1->A1_CONTATO,30," ") // Contato
	cCcargo := PadR(SA1->A1_CARGO1,100," ") // Cargo
	cCtelef := SA1->A1_DDD+SA1->A1_TEL      // Telefone
	//Informações do Contato Financeiro
	cPconta := PadR(SA1->A1_CONTFIN,30," ") // Contato
	cPcargo := PadR(SA1->A1_CARGO3,30," ")  // Cargo
	cPtelef := SA1->A1_DDD+SA1->A1_TELCONT // Telefone
	cPEmail := PadR(SA1->A1_EMAIL,100," ")   // Email nota Fiscal
Else
	cCodigo := GetSXENum("SA1","A1_COD")
	nOpcao := 3
	//Informações do Contato
	cCconta := PadR(SU5->U5_CONTAT,30," ")
	cCcargo := PadR(SU5->U5_FUNCAO,30," ")
	cCtelef := SU5->U5_FONE
	cCArea 	:= PadR(SU5->U5_DEPTO,30," ")
	cCEmail := PadR(SU5->U5_EMAIL,100," ")
	//Informações do Contato Financeiro
	cPconta := PadR(SU5->U5_CONTAT,30," ")
	cPcargo := PadR(SU5->U5_FUNCAO,30," ")
	cPtelef := PADR(AllTrim(Str(Val(SU5->U5_FONE))),14," ")
	cPEmail := PadR(SU5->U5_EMAIL,100," ")
EndIf

oDlgcli := MSDialog():New(001,001,520,430,cCadastro,,,,,CLR_BLACK,CLR_WHITE,,,.T.)

//Campos para exibir no cabeçalho da MsDialog.
@ 006,005 Say " Razão Social: " of oDlgcli Pixel
@ 003,040 MSGET cRazao  SIZE 170,11 OF oDlgcli PIXEL PICTURE "@!" WHEN lRazao
@ 026,005 Say " Nom.Fatansia: " of oDlgcli Pixel
@ 023,040 MSGET cNome   SIZE 070,11 OF oDlgcli PIXEL PICTURE "@!" WHEN lNome
@ 026,140 Say " CEP: " 	of oDlgcli Pixel
@ 023,160 MSGET cCep	SIZE 050,11 OF oDlgcli PIXEL PICTURE "@R 99999-999" Valid U_CSFA112A("CEP") WHEN lCep
@ 046,005 Say " Endereço: " of oDlgcli Pixel
@ 043,040 MSGET cEndere SIZE 170,11 OF oDlgcli PIXEL PICTURE "@!" WHEN lEndere
@ 066,005 Say " Complemento: " of oDlgcli Pixel
@ 063,040 MSGET cComple SIZE 070,11 OF oDlgcli PIXEL PICTURE "@!" WHEN lComple
@ 066,130 Say " Bairro: " of oDlgcli Pixel
@ 063,150 MSGET cBairro SIZE 060,11 OF oDlgcli PIXEL PICTURE "@!" WHEN lBairro
@ 086,005 Say " Cidade: " of oDlgcli Pixel
@ 083,040 MSGET cMunici SIZE 070,11 OF oDlgcli PIXEL PICTURE "@!" WHEN lMunici
@ 086,130 Say " Estado: " of oDlgcli Pixel
@ 083,150 ComboBox cUF Items aUF Size 060,011 PIXEL OF oDlgcli WHEN lUf
@ 106,005 Say " CNPJ/CPF: " of oDlgcli Pixel
@ 103,040 MSGET cCgc     SIZE 070,11 OF oDlgcli PIXEL PICTURE "@R 99.999.999/9999-99" WHEN lCgc
@ 106,120 Say " Inscr.Estadual: " of oDlgcli Pixel
@ 103,160 MSGET cInscr     SIZE 050,11 OF oDlgcli PIXEL PICTURE "@!" WHEN lInscr
@ 126,005 Say " Ins.Municipal: " of oDlgcli Pixel
@ 123,040 MSGET cInscm     SIZE 070,11 OF oDlgcli PIXEL PICTURE "@!" WHEN lInscm

//Dados do Contato
oGroup1:= TGroup():New(145,001,189,213,'Dados do Contato',oDlgcli,,,.T.)
@ 156,005 Say " Contato: " of oDlgcli Pixel
@ 153,040 MSGET cCconta    SIZE 070,11 OF oGroup1 PIXEL PICTURE "@!" WHEN lCconta
@ 156,130 Say " Cargo: "   of oDlgcli Pixel
@ 153,160 MSGET cCcargo    SIZE 050,11 OF oGroup1 PIXEL PICTURE "@!" WHEN lCcargo
@ 176,005 Say " Telefone: " of oDlgcli Pixel
@ 173,040 MSGET cCtelef    SIZE 050,11 OF oGroup1 PIXEL PICTURE "@R (99)99999-9999" WHEN lCtelef
@ 176,100 Say " Email: " of oDlgcli Pixel
@ 173,120 MSGET cCemail     SIZE 090,11 OF oGroup1 PIXEL PICTURE "@!" WHEN lCemail

//Dados do Contato
oGroup2:= TGroup():New(190,001,240,213,'Dados do Contato Finaceiro',oDlgcli,,,.T.)
@ 206,005 Say " Contato: " of oDlgcli Pixel
@ 203,040 MSGET cPconta    SIZE 070,11 OF oGroup2 PIXEL PICTURE "@!" WHEN lPconta
@ 206,130 Say " Cargo: "   of oDlgcli Pixel
@ 203,160 MSGET cPcargo    SIZE 050,11 OF oGroup2 PIXEL PICTURE "@!" WHEN lPcargo
@ 226,005 Say " Telefone: " of oDlgcli Pixel
@ 223,040 MSGET cPtelef    SIZE 050,11 OF oGroup2 PIXEL PICTURE "@R (99)99999-9999" WHEN lPtelef
@ 226,100 Say " Email: " of oDlgcli Pixel
@ 223,120 MSGET cPemail     SIZE 090,11 OF oGroup2 PIXEL PICTURE "@!" WHEN lPemail


// Ativa diálogo centralizado
//oDlgcli:Activate(,,,.T.,{||msgstop('validou!'),.T.},,{||msgstop('iniciando…')} )
@ 240,065 BUTTON "Confirmar"  SIZE 40,20 PIXEL OF oDlgcli ACTION CSFA112G()
@ 240,115 BUTTON "Fechar"  	  SIZE 40,20 PIXEL OF oDlgcli ACTION (oDlgcli:End())

oDlgcli:Activate(,,,.T.,,, )
        
Return

//Validações de campo.
User Function CSFA112A(cCampo)

Local lRet := .T.

If cCampo == "CEP"
	PA7->(DbSetOrder(1))
	If  PA7->(DbSeek(xFilial("PA7") + cCep))
		cEndere := PA7->PA7_LOGRA
		cBairro := PA7->PA7_BAIRRO
		cUf		:= PA7->PA7_ESTADO
		cCodMun := PA7->PA7_CODMUN
		cMunici := PA7->PA7_MUNIC
	Else
		MsgInfo("CEP não encontrado!")
		lRet := .F.
	EndIf
EndIf

Return lRet

Static Function CSFA112G()
//Variaveis
Local 	aVetor := {}
Local 	cPessoa:= ""
Local 	lExiste:= .F.
Private lMsErroAuto := .F.

//Validação de Campos
If 	(Empty(cRazao) .Or. Empty(cNome) .Or. Empty(cCep) .Or. Empty(cEndere) .Or. Empty(cBairro) .Or. Empty(cMunici) ;
	.Or. Empty(cUF) .Or. Empty(cCgc) .Or. Empty(cInscr) .Or. Empty(cInscm)) .And. nOpcao == 3
	MsgInfo("Por favor verifique os dados cadastrais do Cliente!")
	Return .F.
ElseIf Empty(cCconta) .Or. Empty(cCcargo) .Or. Empty(cCtelef)
	MsgInfo("Por favor verifique os dados cadastrais do Contato!")
	Return .F.
ElseIf (Empty(cPconta) .Or. Empty(cPcargo) .Or. Empty(cPtelef) .Or. Empty(cPemail)) .And. nOpcao == 3
	MsgInfo("Por favor verifique os dados cadastrais do Contato Financeiro!")
	Return .F.
EndIf 

cPessoa := Iif(Len(AllTrim(cCgc))>11,"J","F")

//Se encontrar o cliente, retorna as informações
SA1->(DbSetOrder(3))
If SA1->(DbSeek(xFilial("SA1")+U_CSFMTSA1(cCGC))) .And. nOpcao == 3
 
	If !MsgYesNo("Encontramos um cadastro para o CNPJ/CPF informado, deseja vincular o contato com cliente?")
		oDlgcli:End()
		Alert("Processo Cancelado!")
		Return .F.
	EndIf
	
	//Rotina automatica para alteracao.
	nOpcao := 4
EndIf

//Atualizo o vinculo do Lead caso nao esteja preenchido
If cCodTab == "PAB"
	PAB->(RecLock("PAB",.F.))
	PAB->PAB_CNPJ := cCgc //CNPJ/CPF
	PAB->(MsUnlock())
ElseIf cCodTab == "SZT"
	SZT->(RecLock("SZT",.F.))
	SZT->ZT_CNPJ := cCgc //CNPJ/CPF
	SZT->(MsUnlock())
ElseIf cCodTab == "SZX"
	SZX->(RecLock("SZX",.F.))
	SZX->ZX_NRCNPJ := cCgc //CNPJ/CPF
	SZX->(MsUnlock())
ElseIf cCodTab == "SUS"
	SUS->(RecLock("SUS",.F.))
	SUS->US_CGC	:= cCgc //CNPJ/CPF
	SUS->(MsUnlock())
ElseIf cCodTab == "ACH"
	ACH->(RecLock("ACH",.F.))
	ACH->ACH_CGC := cCgc //CNPJ/CPF
	ACH->(MsUnlock())
EndIf

If 	nOpcao == 3
	aVetor:={	{"A1_FILIAL"	,xFilial("SA1") 	,Nil},; // Codigo
				{"A1_COD" 		,cCodigo 			,Nil},; // Loja
				{"A1_LOJA" 		,"01" 				,Nil},; // Loja
				{"A1_NOME"		,cRazao				,Nil},; // Nome
				{"A1_NREDUZ"	,cNome				,Nil},; // Nome reduz.
				{"A1_PESSOA"	,cPessoa			,Nil},; // Tipo de cliente.
				{"A1_TIPO" 		,"F"				,Nil},; // Tipo
 				{"A1_STATVEN"	,"1"				,Nil},; // Tipo
				{"A1_CEP" 		,AllTrim(cCep)		,Nil},;// Tipo
				{"A1_CEPC" 		,AllTrim(cCep)		,Nil},;// Tipo
				{"A1_CEPE" 		,AllTrim(cCep)		,Nil},;// Tipo
				{"A1_EST" 		,cUf				,Nil},; // Estado
				{"A1_COD_EST"	,cUf				,Nil},; // Estado
				{"A1_CODUFC"	,cUf				,Nil},; // Estado
				{"A1_END" 		,cEndere			,Nil},; // Endereco
				{"A1_ENDENT"	,cEndere			,Nil},; // Endereco
				{"A1_COMPLEM"	,cComple			,Nil},; // Endereco
				{"A1_BAIRRO"	,cBairro			,Nil},; // Endereco
				{"A1_BAIRROE"	,cBairro			,Nil},; // Endereco
				{"A1_MUN" 		,cMunici			,Nil},; // Cidade
				{"A1_MUNE" 		,cMunici			,Nil},; // Cidade
				{"A1_CODMUNC"	,cCodMun			,Nil},; // Código da Cidade
				{"A1_COD_MUN"	,cCodMun			,Nil},; // Código da Cidade
				{"A1_PAIS"		,"105"				,Nil},; // Código da Cidade
				{"A1_CGC" 		,AllTrim(cCgc)		,Nil},; // CGC
				{"A1_INSCR"		,cInscr				,Nil},; // CGC
				{"A1_INSCRM"	,cInscm				,Nil},; // CGC
				{"A1_CONTA"		,"110301001"		,Nil},; // CGC
				{"A1_RISCO"		,"A"				,Nil},; // CGC
				{"A1_VENCLC"	,CtoD("31/12/49")	,Nil},; // CGC
				{"A1_TPREG"		,"1"				,Nil},; // CGC
				{"A1_TRIBFAV"	,"2"				,Nil},; // CGC
				{"A1_CLASSE"	,"A"				,Nil},; // CGC
				{"A1_INCISS"	,"S"				,Nil},; // CGC
				{"A1_EMAIL"		,cPemail			,Nil},; // CGC
				{"A1_TEL" 		,SubStr(cPtelef,3,9),Nil},; // Telefone
				{"A1_DDD" 		,"0"+SubStr(cPtelef,1,2),Nil},; // DDD
				{"A1_ALIQIR"	,1.50				,Nil},; // Nome do Contato
				{"A1_CONTATO"	,cCconta			,Nil},; // Nome do Contato
				{"A1_CARGO1"	,cCcargo			,Nil},; // Cargo Contato
				{"A1_CONTFIN"	,cPconta			,Nil},; // Nome Contato Financeiro
				{"A1_CARGO3"	,cPconta			,Nil},; // Cargo Contato Financeiro
				{"A1_TELCONT"	,cPtelef			,Nil},; // Telefone Contato Financeiro
				{"A1_EMAIL"		,cPEmail			,Nil},; // Email Contato Financeiro
				{"A1_DDI" 		,"55" 				,Nil}} // Estado
	
	MSExecAuto({|x,y| Mata030(x,y)},aVetor,nOpcao) //3- Inclusão, 4- Alteração, 5- Exclusão
	
	If lMsErroAuto
		MostraErro()
	Else
		oDlgcli:End()
		AC8->(RecLock("AC8",.T.))
			AC8->AC8_ENTIDA := "SA1"
			AC8->AC8_CODENT := cCodigo+"01"
			AC8->AC8_CODCON := cContato		
		AC8->(MsUnlock())
		If 	nOpcao == 3
			SA1->(ConfirmSX8())
		EndIf
		//Envia e-mail para o fiscal.
		CSFA112E()
		MsgInfo("O cliente: "+cCodigo+" foi gravado com sucesso!")
	Endif
Else
	//Somente vinculo o contato com o cliente, se nao existir.
	AC8->(DbSetOrder(1))
	If !AC8->(DbSeek(xFilial("AC8")+cContato+"SA1"+xFilial("AC8")+cCodigo+"01"))
		AC8->(RecLock("AC8",.T.))
			AC8->AC8_ENTIDA := "SA1"
			AC8->AC8_CODENT := cCodigo+"01"
			AC8->AC8_CODCON := cContato		
		AC8->(MsUnlock())
		MsgInfo("O contato foi vinculado ao cliente!")
	Else
		MsgInfo("O contato já está vinculado ao cliente!")
	EndIf
	
	oDlgcli:End()	
EndIf

Return

//Renato Ruy - 22/06/2016
//Envia aviso para o fiscal
Static Function CSFA112E()

Local cHTML 	:= ""
Local cTitulo 	:= ""

cHTML := '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">'
cHTML += '<html>'
cHTML += '	<head>'
cHTML += '		<meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />'
cHTML += '		<title>Aviso de Fraude</title>'
cHTML += '	</head>'
cHTML += '	<body>'
cHTML += '		<table align="center" border="0" cellpadding="0" cellspacing="0" width="650">'
cHTML += '			<tbody>'
cHTML += '				<tr>'
cHTML += '					<td style="padding:5px; vertical-align:middle;" valign="middle" colspan="4">'
cHTML += '						<em><span style="font-size:20px;"><font color="#F4811D" face="Arial, Helvetica, sans-serif"><strong>Cadastro de Clientes</strong></font></span><br />'
cHTML += '						<font color="#02519B" face="Arial, Helvetica, sans-serif" size="3">Sistema de Gest&atilde;o</font></em>'
cHTML += '						<p>'
cHTML += '							&nbsp;</p>'
cHTML += '					</td>'
cHTML += '					<td align="right" width="210">'
cHTML += '						<img alt="Certisign" height="79" src="http://comunicacaocertisign.com.br/email/2013/certisign_logo.png" width="209" /><br />'
cHTML += '						&nbsp;</td>'
cHTML += '				</tr>'
cHTML += '				<tr>'
cHTML += '					<td bgcolor="#F4811D" colspan="5" height="4" width="0">'
cHTML += '						<img alt="" height="4" src="http://comunicacaocertisign.com.br/email/2015/campanha_cacb/0410/spacer.gif" width="1" /></td>'
cHTML += '				</tr>'
cHTML += '				<tr>'
cHTML += '					<td colspan="5" style="padding:5px;" width="0">'
cHTML += '						<p>'
cHTML += '							<span style="font-family:verdana,geneva,sans-serif;"><span style="font-size:14px;"><font color="#333333">Prezado(s),</font></span></span></p>'
cHTML += '						<p>'
cHTML += '							<span style="font-family:verdana,geneva,sans-serif;"><span style="font-size:14px;"><font color="#333333">Segue abaixo os dados do cliente;<strong></font></span></span></p>'
cHTML += '					</td>'
cHTML += '				</tr>'
cHTML += '				<tr>'
cHTML += '					<td bgcolor="#02519B" colspan="5" height="2" width="0">'
cHTML += '						<img alt="" height="2" src="http://comunicacaocertisign.com.br/email/2015/campanha_cacb/0410/spacer.gif" width="1" /></td>'
cHTML += '				</tr>'

cHTML += '				<tr><td bgcolor="#F4811D" colspan=5><b>Dados de Faturamento para Emissão da Nota Fiscal</b></td></tr>'

cHTML += '				<tr><td colspan=5 bordercolor="#F4811D"><b>Razão Social:</b> '+cRazao+'</td></tr>'				
cHTML += '				<tr><td colspan=5 bordercolor="#F4811D"><b>Endereço (Completo):</b> '+AllTrim(cEndere)+'-'+AllTrim(cComple)+'-'+AllTrim(cBairro)+'-'+AllTrim(cMunici)+'/'+AllTrim(cUf)+'-'+AllTrim(cCep)+'</td></tr>'
cHTML += '				<tr><td colspan=5 bordercolor="#F4811D"><b>CNPJ:</b> '+Transform(cCgc,"@R 99.999.999/9999-99")+'</td></tr>'
cHTML += '				<tr><td colspan=5 bordercolor="#F4811D"><b>Inscrição Estadual:</b> '+cInscr+'</td></tr>'
cHTML += '				<tr><td colspan=5 bordercolor="#F4811D"><b>Inscrição Municipal:</b> '+cInscm+'</td></tr>'

cHTML += '				<tr><td bgcolor="#F4811D" colspan=5><b>Dados do responsável pela compra</b></td></tr>'
cHTML += '				<tr><td colspan=5 bordercolor="#F4811D"><b>Contato:</b> '+cCconta+'</td></tr>'
cHTML += '				<tr><td colspan=5 bordercolor="#F4811D"><b>Cargo:</b> '  +cCcargo+'</td></tr>'
cHTML += '				<tr><td colspan=5 bordercolor="#F4811D"><b>Telefone:</b> '+Transform(cCtelef,"@R (99)99999-9999")+'</td></tr>'
cHTML += '				<tr><td colspan=5 bordercolor="#F4811D"><b>Email: </b>'   +cCemail+'</td></tr>'

cHTML += '				<tr><td bgcolor="#F4811D" colspan=5><b>Dados do responsável Financeiro</td></tr>'
cHTML += '				<tr><td colspan=5 bordercolor="#F4811D"><b>Contato:</b> ' +cPconta+'</td></tr>'
cHTML += '				<tr><td colspan=5 bordercolor="#F4811D"><b>Cargo:</b> '   +cPcargo+'</td></tr>'
cHTML += '				<tr><td colspan=5 bordercolor="#F4811D"><b>Telefone:</b> '+Transform(cPtelef,"@R (99)99999-9999")+'</td></tr>'
cHTML += '				<tr><td colspan=5 bordercolor="#F4811D"><b>Email:</b> '   +cPemail+'</td></tr>'


cHTML += '				<tr>'
cHTML += '					<td colspan="5" style="padding:5px" width="0">'
cHTML += '						<p align="left">'
cHTML += '							<font color="#666666" face="Arial, Helvetica, sans-serif" size="2"><em>Esta mensagem foi gerada e enviada automaticamente, n&atilde;o responda a este e-mail.</em></font></p>'
cHTML += '					</td>'
cHTML += '				</tr>'
cHTML += '			</tbody>'
cHTML += '		</table>'
cHTML += '		<p>'
cHTML += '			&nbsp;</p>'
cHTML += '	</body>'
cHTML += '</html>'

If nOpcao == 3
	FSSendMail( ;
				UsrRetMail(__cUserID)+";"+AllTrim(GetMv("MV_XMAILAG")),; 
				"Novo Cliente - Vendas Diretas", ;
				cHTML )
EndIf

Return                                                                             