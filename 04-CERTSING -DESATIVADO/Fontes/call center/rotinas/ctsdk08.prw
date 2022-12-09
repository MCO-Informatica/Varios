#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³U_CTSDK08 ºAutor  ³opvs(Warleson)      º Data ³  03/22/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Consulta Entidade e Gravacao de Contatos simplificado     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P10 - Certisign                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CTSDK08(lResp)

local	nCont
local 	lRet
local 	cPerg		:= 'CONTATO001'
local 	cMV_PAR		:= '00'
Private lEntidade	:= .F.
Private lContato	:= .F.
Private lRelacao	:= .F.
Private lnovo		:= .F.
Private	cEntidade   := ''
Private	cCodCont	:= space(6) //Codigo do Contato
Private cCodEnt 	:= space(6) //Entidade
Private cLojaEnt 	:= space(2) //Loja da Entidade
default lResp 		:= .T. // Limpar respostas anteriores? padrao SIM.

	IF lResp
		dBselectarea("SX1")
		dbsetorder(1)
	
		For _nMvPar:=1 to 6
			cMV_PAR:= SOMA1(cMV_PAR)
			If DbSeek( cPerg +cMV_PAR)
				Reclock('SX1', .F. ) 
				SX1->X1_CNT01 := ''
				MsUnLock()
			Endif 
		Next
    Endif

	lRet:= pergunte(cPerg,.T.,'Entidade',,,.F.)

	if lRet  //Confirmou tela de Contato
		if empty(MV_PAR01) .or.; 
		   empty(MV_PAR03) .or.; 
		   empty(MV_PAR04) .or.; 
		   empty(MV_PAR05) .or.; 
		   empty(MV_PAR06)
			Alert('Favor preencher todos os campos!')
			U_CTSDK08(.F.)
			Return
		Else
			grava_contato() //Inclusao
		
			// Se possuir Entidade porem nao possui Contato
			// Entao apos  Incluir Contato tambem incluir relacionamento com a Entidade
	
			IF (lEntidade==.T.) .and.  (lContato==.F. .and. lRelacao==.F.)
				Grava_relacionamento()
			Endif
		Endif 
    
       	//Gatilha Codigo do Contato e Entidade em Tela
		M->ADE_CODCON	:= cCodCont
		M->ADE_NMCONT	:= TKDadosContato(cCodCont,0)		
		M->ADE_ENTIDA	:= cEntidade
		M->ADE_NMENT 	:= POSICIONE('SX2',1,M->ADE_ENTIDAD,'X2NOME()')                                                        
		M->ADE_DESCIN	:= ALLTRIM(POSICIONE("SIX",1,cEntidade+"1","SIXDescricao()")) //Codigo+Loja
		M->ADE_CHAVE	:= ALLTRIM(cCodEnt+cLojaEnt)
		M->ADE_DESCCH	:= TkEntidade(cEntidade,Alltrim(cCodEnt+cLojaEnt),1) //Empresa X Ltda.
	Endif

Return                                           

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³contato_valida(cCgc)   ºAutor  ³warleson(Opvs)      º Data ³  03/22/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Valida Cpf digitado em MV_PAR01                                         º±±
±±º          ³ Caso afirmativo, Chama função para pesquisar Entidiades                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P10 - Certisign                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User function contato_valida(cCgc)

LOCAL nCnt,i,j,cDVC,nSum,nDIG,cDIG:="",cSavAlias,nSavRec,nSavOrd,_cCgc
cCGC	:= IIF(cCgc  == Nil,&(ReadVar()),cCGC)
_cCgc	:= cCgc 
//cVar  := If(ValType(cVar) = "U", ReadVar(), cVar)
If cCgc == "00000000000000"
		Return .T.
Endif

nTamanho:=Len(AllTrim(cCGC))

cDVC:=SubStr(cCGC,13,2)
cCGC:=SubStr(cCGC,1,12)

FOR j := 12 TO 13
	nCnt := 1
	nSum := 0
	FOR i := j TO 1 Step -1
		nCnt++
		IF nCnt>9;nCnt:=2;EndIf
		nSum += (Val(SubStr(cCGC,i,1))*nCnt)
	Next i
	nDIG := IIF((nSum%11)<2,0,11-(nSum%11))
	cCGC := cCGC+STR(nDIG,1)
	cDIG := cDIG+STR(nDIG,1)
Next j
lRet:=IIF(cDIG==cDVC,.T.,.F.)

IF !lRet
	IF nTamanho < 14
		cDVC:=SubStr(cCGC,10,2)
		cCPF:=SubStr(cCGC,1,9)
		cDIG:=""

		FOR j := 10 TO 11
			nCnt := j
			nSum := 0
			For i:= 1 To Len(Trim(cCPF))
				nSum += (Val(SubStr(cCPF,i,1))*nCnt)
				nCnt--
			Next i
			nDIG:=IIF((nSum%11)<2,0,11-(nSum%11))
			cCPF:=cCPF+STR(nDIG,1)
			cDIG:=cDIG+STR(nDIG,1)
		Next j

		IF cDIG != cDVC
//			HELP(" ",1,"CGC")
			Alert('CPF inválido!'+CRLF+_cCgc)
		Endif

		lRet:=IIF(cDIG==cDVC,.T.,.F.)
//		IF lRet;&cVar:=cCPF+Space(3);EndIF
	Else
//		HELP(" ",1,"CGC")
	EndIF
EndIF

If lRet
	Pesquisa_entidade(_cCgc)
Endif

Return lRet                  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Pesquisa_entidade()   ºAutor  ³warleson(Opvs)      º Data ³  03/22/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Pesquisa Entidade (Cliente,Prospect,Suspect,Contato)                   º±±
±±º          ³ Efetua os devidos gatilhos nas variaveis MV_PAR                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P10 - Certisign                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
Obs.: Recebe CPF ja validado
*/
Static function Pesquisa_entidade(cCgc)

local nI
Private cStatus 	:= space(30) 				// Status
Private cNome		:= space(30)				// Nome
Private cDDD		:= space(3)					// DDD
Private cTelefone	:= space(15)  				// Telefone
Private cEmail		:= space(40)  				// E-mail


lnovo := .T.

	For nI:=1 to 1

		DbSelectArea("SA1") //Verifica se existe esse registro cadastrado na Tabela de Cliente (CPF)
		DbSetOrder(3) 
		lEntidade	:= .F.
		If DbSeek(xFilial("SA1") + U_CSFMTSA1(cCgc))
			lEntidade	:= .T.
			cEntidade	:= "SA1"
			cCodEnt		:= SA1->A1_COD
			cLojaEnt	:= SA1->A1_LOJA
			cStatus 	:= "[Cliente]"  

			cNome		:= SA1->A1_NOME
			cDDD		:= SA1->A1_DDD
			cTelefone	:= SA1->A1_TEL
			cEmail		:= SA1->A1_EMAIL
			lnovo		:=	.F.
			
			lContato	:= .F.
			lRelacao	:= Busca_relacionamento()

			If lRelacao
				lContato:= Busca_Contato(cCgc)
				cStatus := 'Contato '+cStatus
			Endif
			
			Exit
		Endif
		
		DbSelectArea("SUS")  //Verifica se existe esse registro cadastrado na Tabela de Prospect (CPF)
		DbSetOrder(4)
		lEntidade	:= .F.
		If DbSeek(xFilial("SUS") + cCgc)
			lEntidade	:= .T.
			cEntidade	:= "SUS"
			cCodEnt		:= SUS->US_COD
			cLojaEnt	:= SUS->US_LOJA
			cStatus 	:= "[Prospect]"  
			
			cNome		:= SUS->US_NOME 
			cDDD		:= SUS->US_DDD
			cTelefone	:= SUS->US_TEL
			cEmail		:= SUS->US_EMAIL			
			lnovo		:=	.F.

			lContato	:= .F.
			lRelacao	:= Busca_relacionamento()

			If lRelacao
				lContato:= Busca_Contato(cCgc)
				cStatus := 'Contato '+cStatus
			Endif
	
			Exit
		Endif
		
		DbSelectarea("ACH") //Verifica se existe esse registro cadastrado na Tabela de Suspect (CPF)
		DbSetOrder(2)
		lEntidade	:= .F.
		If DbSeek(xFilial("ACH") + cCgc)
			lEntidade	:= .T.
			cEntidade	:= "ACH"
			cCodEnt		:= ACH->ACH_CODIGO
			cLojaEnt	:= ACH->ACH_LOJA
			cStatus 	:= "[Suspect]"  
			
			cNome		:= ACH->ACH_RAZAO 
			cDDD		:= ACH->ACH_DDD
			cTelefone	:= ACH->TEL
			cEmail		:= ACH->ACH_EMAIL			
			lnovo		:=	.F.
			
			lContato	:= .F.
			lRelacao	:= Busca_relacionamento()
			
			If lRelacao
				lContato:= Busca_Contato(cCgc)
				cStatus := 'Contato '+cStatus
			Endif
			
			Exit
		Endif
		
		dbselectarea("SU5") //Verifica se existe esse registro cadastrado na Tabela de Contato (CPF)
		dbsetorder(8)
		cStatus 	:= "Novo [Contato]"  
		lContato	:= .F.
		If DbSeek(xFilial("SU5")+ALLTRIM(cCgc))
			cEntidade	:= "SU5" 
			cStatus 	:= "[Contato]"  
			
			cNome		:= SU5->U5_CONTAT 
			cDDD		:= SU5->U5_DDD
			cTelefone	:= SU5->U5_FCOM1
			cEmail		:= SU5->U5_EMAIL
			lnovo		:= .F.
			lContato	:= .T.						
			
			Exit
		Endif
	Next

	MV_PAR02 := cStatus 	// Status
	MV_PAR03 := cNome 		// Nome
	MV_PAR04 := cDDD 		// DDD
	MV_PAR05 := cTelefone 	// Telefone
	MV_PAR06 := cEmail 		// E-mail
Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  |Grava_contato          ºAutor  ³Opvs(warleson)  º Data ³  26/03/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Inclui e Altera Contatos na                     					   º±±
±±º          ³ Tabela SU5                                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP10 CERTISIGN                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
static  function grava_contato()

local lseek

	DbSelectarea("SU5")
	dbsetorder(8)//CPF
	lseek:= DbSeek(xFilial("SU5")+ALLTRIM(MV_PAR01))

	if lseek
		cCodCont := SU5->U5_CODCONT
	Else
		cCodCont := GETSXENUM("SU5","U5_CODCONT")	
	Endif

	Reclock("SU5",!lseek)

	Replace U5_FILIAL	  With  xFilial("SU5")
	Replace U5_CODCONT    With  cCodCont // Codigo do contato
	Replace U5_CPF		  With  MV_PAR01 // Nome  
	Replace U5_CONTAT     With  MV_PAR03 // Nome
	Replace U5_DDD        With  MV_PAR04 // DDD
	Replace U5_FCOM1      With  MV_PAR05 // Telefone Comercial 1
	Replace U5_EMAIL      With  MV_PAR06 // E-mail do Contato

	MsUnlock()

	if !lseek
		ConfirmSx8()
	Endif			
	
	msginfo('Contato Gravado com Sucesso!'+CRLF+'CÓDIGO: '+cCodCont+CRLF+'NOME: '+MV_PAR03)

Return .t.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Busca_relacionamento   ºAutor  ³Opvs(warleson)  º Data ³  26/03/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Pesquisa relacionamento de Entidade X Contato na                    º±±
±±º          ³ Tabela AC8                                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP10 CERTISIGN                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
static function Busca_relacionamento()

Local lRet := .F.

		DbSelectArea("AC8")
		DbSetOrder(2) 				//AC8_FILIAL+AC8_ENTIDA+AC8_FILENT+AC8_CODENT+AC8_CODCON
		If DbSeek(xFilial("AC8")+(cEntidade)+(xFilial(cEntidade))+ALLTRIM(cCodEnt+cLojaEnt))
			lRet := .T.
		Endif

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  |Grava_relacionamento   ºAutor  ³Opvs(warleson)  º Data ³  26/03/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Grava relacionamento de Entidade X Contato na                       º±±
±±º          ³ Tabela AC8                                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP10 CERTISIGN                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
static Function Grava_relacionamento()

		DbSelectArea("AC8")
		DbSetOrder(2) 				//AC8_FILIAL+AC8_ENTIDA+AC8_FILENT+AC8_CODENT+AC8_CODCON
		If !(DbSeek(xFilial("AC8")+(cEntidade)+(xFilial(cEntidade))+ALLTRIM(cCodEnt+cLojaEnt)))
			Reclock("AC8",.T.)
			Replace AC8_FILIAL  With xFilial("AC8")
			Replace AC8_ENTIDA  With cEntidade  
			Replace AC8_FILENT  With xFilial(cEntidade)  
			Replace AC8_CODENT	With ALLTRIM(cCodEnt+cLojaEnt)
			Replace AC8_CODCON	With cCodCont 
			MsUnlock()
		Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  |Busca_Contato          ºAutor  ³Opvs(warleson)  º Data ³  26/03/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Pesquisa Contatos na                     						   º±±
±±º          ³ Tabela SU5                                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP10 CERTISIGN                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
static Function Busca_Contato(cCgc)

local lRet

		dbselectarea("SU5") //Verifica se existe esse registro cadastrado na Tabela de Contato (CPF)
		dbsetorder(8)

		If DbSeek(xFilial("SU5")+ALLTRIM(cCgc))
		
			cNome		:= SU5->U5_CONTAT 
			cDDD		:= SU5->U5_DDD
			cTelefone	:= SU5->U5_FCOM1
			cEmail		:= SU5->U5_EMAIL
			lnovo		:= .F.
			lRet		:= .T.
		Endif			
		
		MV_PAR02 := cStatus 	// Status
		MV_PAR03 := cNome 		// Nome
		MV_PAR04 := cDDD 		// DDD
		MV_PAR05 := cTelefone 	// Telefone
		MV_PAR06 := cEmail 		// E-mail      
		lRet	 := .F.
		
Return lRet