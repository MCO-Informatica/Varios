#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TMKGRVACH ºAutor  ³Microsiga           º Data ³  07/13/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Gravacao do Suspect (ACH) e relacionamento de contatos      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CALL CENTER                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function TMKGRVAC(aMailing)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracoes                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cTel 		:= ""                                        
Local cCep 		:= ""
Local cFax 		:= ""
Local cCodCargo := CRIAVAR("UM_CARGO",.T.)
Local cCodigo   := CRIAVAR("ACH_CODIGO",.T.)
Local cCodCont  := CRIAVAR("U5_CODCONT",.T.)
Local nCont		:= 0
Local cLojaPad  := GetMv("MV_LOJAPAD")
Local cCPF 			:=""
local cCNPJ			:=""
Local lUnic			:= SuperGetMv("MV_SPTUNIC",.F.)
local cMotivo		:=""
Local cValor    	:=""

Private lGravou	:= .F.
PRivate nArq		:= 0
Private cDir	:= ''
PRivate cNome	:= ''

//Controla .T.=Inclusao .F.=Alteracao, nas seguintes tabelas:

Private lGrvACH := .F.  // Suspect
Private lGrvSUM := .F.  // Cargo
Private lGrvSU5 := .F.  // Contato
Private lGrvAC8 := .F.  // Relacionamento
Private lGrvSUS := .F.  // Prospect
Private lGrvSA1 := .F.  // Cliente

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Grava informacoes do Mailing no ACH	                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ProcRegua(Len(aMailing))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicia-se a partir do segundo registro pois o primeiro  ³
//³e a descricao das colunas							   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nCont := 2 TO Len(aMailing) 
  
	aMailing[nCont][12] 	:= STRTRAN(aMailing[nCont][12],"-")

	IF LEN(ALLTRIM(aMailing[nCont][12]))==11
		cCPF:= aMailing[nCont][12]    
    ELSEIF LEN(ALLTRIM(aMailing[nCont][12]))==14
		cCNPJ:=aMailing[nCont][12]
	ELSE
		if !empty(ALLTRIM(aMailing[nCont][12]))
		   	cMotivo:='CPF/CNPJ inválido '+ALLTRIM(aMailing[nCont][12])
		   	gravalog(lUnic,nCont,'CPF/CNPJ',cMotivo)
		 	Loop					
		Endif
	ENDIF
 


	//Inicio - DESABILITADO - OPVS(warleson) - 23/01/12

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Executa as validacoes para gravacao	pela razao social   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
		/*
		DbSelectarea("ACH") //Verifica se existe esse registro cadastrado na Tabela de Suspect
		DbSetOrder(3)
		If DbSeek(xFilial("ACH") + aMailing[nCont][01])
			Loop
		EndIf
	
		DbSelectarea("SUS")  //Verifica se existe esse registro cadastrado na Tabela de Prospect
		DbSetOrder(2)
		If DbSeek(xFilial("SUS") + aMailing[nCont][01])
			Loop
		EndIf
		
		DbSelectarea("SA1") //Verifica se existe esse registro cadastrado na Tabela de Clientes
		DbSetOrder(2)
		If DbSeek(xFilial("SA1") + aMailing[nCont][01])
			Loop
		EndIf
	*/
	//Final - DESABILITADO - OPVS(warleson) - 23/01/12

	cCep 	:= STRTRAN(Alltrim(aMailing[nCont][05]),"-")
	cTel 	:= STRTRAN(Alltrim(aMailing[nCont][08]),"-")
	cFax 	:= STRTRAN(Alltrim(aMailing[nCont][09]),"-")
	
	cTel	:= SgLimpaTel(cTel)
		
	
	// INICIO - VALIDACOES DE CAMPOS - ops(warlesn) 23/01/2012


	IF empty(cCPF) .and. empty(cCNPJ) .and. empty(cTel)
		
		cMotivo:='CPF,CNPJ e Telefone vazio'
		gravalog(lUnic,nCont,'CPF|CNPJ|TELEFONE',cMotivo)
		Loop
	endif
	

	if !empty(cCPF)
	   	if !xcgc(cCPF)
		   	cMotivo:='CPF inválido '+cCPF
		   	gravalog(lUnic,nCont,'CPF',cMotivo)
		   	Loop					
	   	endif
	Endif
	
	if !empty(cCNPJ)
		if !xcgc(cCNPJ)
		   	cMotivo:='CNPJ inválido '+cCNPJ
		  	gravalog(lUnic,nCont,'CNPJ',cMotivo)
		   	Loop					
	   	endif
	Endif
	 	
 	if !empty(aMailing[nCont][06])
        
		dbselectarea('SX5')
		dbsetorder(1) //FILIAL+TABELA+CHAVE
		if !dbseek(xfilial('SX5')+'12'+aMailing[nCont][06])

	   		cMotivo:='ESTADO inválido '+aMailing[nCont][06]
	  		gravalog(lUnic,nCont,'ESTADO',cMotivo)
	  	 	Loop					
        endif

	Endif      
	
	if !empty(aMailing[nCont][16])
		SX3->( DbSetOrder(2) )
		If SX3->( MsSeek('U5_CATEGO'))
			IF !ALLTRIM(aMailing[nCont][16])$SX3->X3_CBOX
				cMotivo:='Categoria inválida '+aMailing[nCont][16]
	  			gravalog(lUnic,nCont,'CATEGORIA',cMotivo)	
	  		loop
			endif
		endif
	endif

	if !empty(aMailing[nCont][17])
		dbselectarea('SUH')
		dbsetorder(1)
		if !dbseek(xfilial('SUH')+aMailing[nCont][17])
			cMotivo:='Mídia inválida '+aMailing[nCont][17]
	  		gravalog(lUnic,nCont,'MIDIA',cMotivo)	
	  		loop
		endif
	endif
	
	if !empty(aMailing[nCont][18])
		dbselectarea('SA3')
		dbsetorder(1)
		if !dbseek(xfilial('SA3')+aMailing[nCont][18])
			cMotivo:='Vendedor inválido '+aMailing[nCont][18]
	  		gravalog(lUnic,nCont,'VENDEDOR',cMotivo)	
	  		loop
		endif
	endif

	if !empty(cTel)
		if (len(cTeL)<8)
			cMotivo:='Telefone inválido '+aMailing[nCont][07]+' '+cTel
			gravalog(lUnic,nCont,'Telefone',cMotivo)
			Loop	
		elseif empty(aMailing[nCont][07])
			cMotivo:='DDD vazio '+aMailing[nCont][07]+' '+cTel
			gravalog(lUnic,nCont,'DDD',cMotivo)
			Loop			
		endif
	Endif


	// FINAL - VALIDACOES DE CAMPOS - ops(warlesn) 23/01/2012	

	//Inicio - OPVS(warleson) - 23/01/12

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Validacoes Especificas - CERTISIGN ³
	//³1- Valida CPF                      ³
	//³2- valida CNPJ                     ³
	//³3- valida TELEFONE                 ³
	//³4- valida PARAMETRO ESPECIFICO     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
			IF !empty(aMailing[nCont][12])
				DbSelectarea("ACH") //Verifica se existe esse registro cadastrado na Tabela de Suspect (CPF)
				DbSetOrder(2)

				If DbSeek(xFilial("ACH") + aMailing[nCont][12])
					If lUnic
						cMotivo:='Ja existe um Suspect com esse CPF ou CNPJ - '+ aMailing[nCont][12]
						gravalog(lUnic,nCont,'CPF',cMotivo)
						Loop
					Endif
					lGrvACH :=.F.
				Else
					lGrvACH :=.T.
				EndIf

		    Else
				if !empty(cTel) .and. !empty(aMailing[nCont][07])
					DbSelectarea("ACH") //Verifica se existe esse registro cadastrado na Tabela de Suspect (Telefone)
					DBOrderNickname('TELEFONE')
					

					
					If DbSeek(xFilial("ACH") +padr(aMailing[nCont][07],3)+cTel)
						if lUnic //Verifica se bloqueia a inclusao de registros duplicaos
							cMotivo:='Ja existe um Suspect com esse Telefone '+aMailing[nCont][09]+' '+cTel
							gravalog(lUnic,nCont,'telefone',cMotivo)
							Loop
						endif
						lGrvACH:=.F.
					Else
						lGrvACH:=.T.
					EndIf		    

			    Endif		    
		    endif
		    
	//Final - OPVS(warleson) - 23/01/12

		If lGrvACH
			cCodigo := GETSXENUM("ACH","ACH_CODIGO")
		Else
			cCodigo := ACH->ACH_CODIGO	
		Endif
		
	Begin Transaction
        DbSelectarea("ACH")
		Reclock("ACH",lGrvACH)
		Replace ACH_FILIAL	With xFilial("ACH")
		Replace ACH_CODIGO	With cCodigo
		Replace ACH_LOJA	With cLojaPad 
		Replace ACH_RAZAO	With aMailing[nCont][01]
		Replace ACH_NFANT   With aMailing[nCont][02]
		Replace ACH_TIPO	With "1" // Tipo (DEFAULT "F"-Consumidor Final)
		Replace ACH_END     With aMailing[nCont][03]
		Replace ACH_CIDADE  With aMailing[nCont][04]
		Replace ACH_CEP     With cCep
		Replace ACH_EST 	With aMailing[nCont][06]
		Replace ACH_TEL	    With cTel
		Replace ACH_DDD	    With aMailing[nCont][07]
		Replace ACH_FAX     With cFax
		Replace ACH_EMAIL   With aMailing[nCont][10]
		Replace ACH_URL	    With aMailing[nCont][11]
		Replace ACH_MIDIA   With aMailing[nCont][17] 
		Replace ACH_VEND    With aMailing[nCont][18]     

		//INICIO - Especifico CERTISIGN  - Opvs(warleson) 20/01/12		
		
		if !empty(cCPF)
			Replace ACH_PESSO    With 'F'
			Replace ACH_CGC      With cCPF

    	Elseif !empty(cCNPJ)
			Replace ACH_PESSO    With 'J'
    	 	Replace ACH_CGC      With cCNPJ
    	Endif

		//FINAL - Especifico CERTISIGN		
		
		//DbCommit()
		MsUnlock()
		
		If lGrvACH
			ConfirmSx8()
		Endif 
	
		IncProc()
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Gravacao do Cargo do Contato            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !Empty(AllTrim(aMailing[nCont][14]))
		
			DbSelectarea("SUM")
			DbSetOrder(2)//UM_DESC
			If DbSeek(xFilial("SUM") + AllTrim(aMailing[nCont][14])) 
				cCodCargo := SUM->UM_CARGO
			Else
				If !Empty(AllTrim(aMailing[nCont][13]))
				 
					If Empty(cCodCargo)
						cCodCargo := GETSXENUM("SUM","UM_CARGO")
					Endif

					Reclock("SUM",.T.)
					Replace UM_FILIAL  With xFILIAL("SUM")
					Replace UM_CARGO   With cCodCargo
					Replace UM_DESC    With Alltrim(aMailing[nCont][14])
//					DbCommit()
					MsUnlock()
					ConfirmSx8()
				 
				EndIf
			EndIf
		Endif
			
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Gravacao do Contato                     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If  !Empty(AllTrim(aMailing[nCont][13]))
		
			DbSelectarea("SU5")
			DbSetOrder(2)//U5_CONTAT

			if lGrvACH
				If Empty(cCodCont)
					cCodCont := GETSXENUM("SU5","U5_CODCONT")
			    EndIf
				lGrvSU5:=.T.
			Else
				If  !DbSeek(xFilial("SU5") + aMailing[nCont][13]) 
					If Empty(cCodCont)
						cCodCont := GETSXENUM("SU5","U5_CODCONT")
				    EndIf
					
					lGrvSU5 :=.T.
				Else

					IF !(U5_CATEGO == aMailing[nCont][16]) // Suspect e Contato repetidos, porem de setores de vendas diferentes 
				
                    	If Empty(cCodCont)
							cCodCont := GETSXENUM("SU5","U5_CODCONT")
				  		EndIf
					
						lGrvSU5 :=.T.
                    Else
	                    cCodCont := SU5->U5_CODCONT
						lGrvSU5 :=.F.
                    Endif  
                    				
				Endif  
			endif
			
			Reclock("SU5",lGrvSU5)
			Replace U5_FILIAL	  With  xFilial("SU5")
			Replace U5_CODCONT    With  cCodCont
			Replace U5_CONTAT     With  aMailing[nCont][13]
			Replace U5_FUNCAO     With  cCodCargo
			Replace U5_DDD        With  Alltrim(aMailing[nCont][07])
			Replace U5_FCOM1      With  cTel
			Replace U5_FAX        With  cFax
			Replace U5_STATUS     With  "2" // Atualizado
			Replace U5_END     	  With aMailing[nCont][03]
			Replace U5_MUN        With aMailing[nCont][04]
			Replace U5_CEP        With cCep
			Replace U5_EST        With aMailing[nCont][06]
			Replace U5_SEGMEN 	  With aMailing[nCont][15]
			Replace U5_CATEGO     With aMailing[nCont][16]
			Replace U5_MIDIA      With aMailing[nCont][17]
			Replace U5_VEND    	  With aMailing[nCont][18]
			Replace U5_OBSERVA 	  With aMailing[nCont][19]
			Replace U5_PRODINT 	  With aMailing[nCont][20]
			replace U5_DTIMPO     With dDatabase //	data da importacao
			
//			DbCommit()
			MsUnlock()
			
			If lGrvSU5
				ConfirmSx8()
			Endif
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Grava relacionamento no AC8³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
			if lGrvACH .or. lGrvSU5
				lGrvAC8 := .T.			
			Else
				dbSelectArea("AC8")
				dbsetorder(1)
				If !DbSeek(xFilial("AC8")+cCodCont+"ACH"+xFilial("ACH")+(cCodigo+ cLojaPad))
					lGrvAC8 := .T.
				Else
					lGrvAC8 := .F.
				Endif			
				
			Endif
			RecLock("AC8",lGrvAC8)
			Replace AC8->AC8_FILIAL With xFilial("AC8")
			Replace AC8->AC8_FILENT With xFilial("ACH")
			Replace AC8->AC8_ENTIDA With "ACH"
			Replace AC8->AC8_CODENT With cCodigo + cLojaPad
			Replace AC8->AC8_CODCON With cCodCont
			
//			dbCommit()
			MsUnLock()
			

				if !empty(cvaltochar(aMailing[nCont][16])) .and. cvaltochar(aMailing[nCont][16])$SuperGetMv("MV_SPTCATE",.F.,'') // MV_SPTCATE(1=Adm.Vendas,2=TeleVendas,3=SAC)

					// paramentros para a funcao Tk341GrvPros
					
					MV_PAR01 := 2 // verifica prospect - 1=sim,2=nao
					MV_PAR02 := 2 // verifica Cliente  - 1=sim,2=nao
					MV_PAR03 := cCodigo  // do codigo 
					MV_PAR04 := cCodigo  // ate o codigo

					Tk341GrvPros() //Converte Suspect em Prospect  - OPVS(warleson) - 30/01/12	 

				endif

			EndIf	
	    
    End Transaction

	cCodCargo := ""
	cCodigo   := ""
	cCodCont  := ""

Next nCont
	
If lgravou
	FClose(nArq)
	MSGINFO('Favor verificar o Log da importação em'+CRLF+allTrim(cDir) + cNome + ".TXT")
Endif

Return(.T.)
*__________________________________________________________________________________________________________________________________________________
static function gravalog(lUnic,nLin,cColuna,cMotivo)
	
Local cCabec 	:= ''
Local cCorpo 	:= ''
local cParam    := ''
local cMensagem := ''


if lUnic          
	cParam:='Habilitado'
Else
	cParam:='Desabilitado'
Endif

	IF !lGravou
		//cDir 	:= cGetFile(" | ",OemToAnsi("Selecione um Diretório para Gravar o Log da Importação"),,"C:\",.F.,nOR(GETF_LOCALHARD,GETF_RETDIRECTORY),.F.,.F.)
        cDir	:= memoread(GetTempPath()+'dir_suspect.txt') 

		cNome 	:= "SUSPECT_LOG_"+alltrim(cUserName)+'_'+DTOS(date())+'_'+alltrim(substr(time(),1,2)+substr(time(),4,2)+substr(time(),7,2))
		nArq 	:= fcreate(allTrim(cDir) + cNome + ".TXT")

    	lGravou	:= .T.
		cCabec += CRLF
	    cCabec += 'DESCRICAO	: IMPORTACAO DE SUSPECT'+CRLF
		cCabec += 'MAQUINA		: '+GetComputerName()+CRLF
		CCabec += 'OPERADOR	: '+cUserName+CRLF
		cCabec += 'MODULO		: '+cModulo+CRLF
		cCabec += 'FUNCAO		: '+funname()+CRLF
		cCabec += 'DATA		: '+DTOC(date())+CRLF
		cCabec += 'HORA		: '+time()+CRLF
		cCabec += 'ARQUIVO		: '+alltrim(cDir)+cNome+CRLF
		cCabec += 'MV_SPTUNIC	: Validar Duplicidade ('+cParam+')'+CRLF+CRLF
		cCabec += '============================================================================='+CRLF+CRLF
    	cMensagem+=cCabec
    Endif
	
	cCorpo += '*_*_*_*ATENCAO*_*_*_*  Suspect Rejeitado'+CRLF
	cCorpo += 'LINHA	: '+cvaltochar(nLin)+CRLF
	cCorpo += 'COLUNA	: '+cColuna+CRLF
	cCorpo += 'MOTIVO	: '+cMotivo+CRLF
	cCorpo += '-----------------------------------------------------------------------------'+CRLF
	cMensagem+=cCorpo

	FWrite(nArq,Rtrim(cMensagem)+CRLF)

Return

//--------------------------------------------------------------------------------------------------------------------------------------

static function xcgc(cCGC)
LOCAL nCnt,i,j,cDVC,nSum,nDIG,cDIG:="",cSavAlias,nSavRec,nSavOrd
cCGC	:= IIF(cCgc  == Nil,&(ReadVar()),cCGC)
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
		Endif

		lRet:=IIF(cDIG==cDVC,.T.,.F.)
//		IF lRet;&cVar:=cCPF+Space(3);EndIF
	Else
//		HELP(" ",1,"CGC")
	EndIF
EndIF
Return lRet                  
//----------------------------------------------------------------------------------------------------------------------------------------------
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³Tk341GrvPros  ³ Autor ³ Vendas Clientes   ³ Data ³ 12/07/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Gravacao dos Prospects a partir da tabela ACH(Suspects)     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³CALL CENTER                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Tk341GrvPros()

ProcRegua(RecCount())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Grava informacoes do ACH990 para o cadastro de Prospect³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectarea("ACH")
DbSetorder(1)
DbSeek(xFilial("ACH")+ ALLTRIM(MV_PAR03),.T.) // Codigo inicial

While ((!ACH->(Eof())) .AND. (xFilial("ACH") == ACH->ACH_FILIAL) .AND. (ACH->ACH_CODIGO <= MV_PAR04)) //Codigo Final
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Executa as validacoes para gravacao	               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If (mv_par01 == 1) //Validacao de Prospect pelo CGC = SIM
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Se o CGC do SUSPECT estiver VAZIO nao converte  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If Empty(AllTrim(ACH->ACH_CGC))
			DbSelectArea("ACH")
			ACH->(DbSkip())
			IncProc()
			Loop
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Se existir um PROSPECT ja cadastradado com o mesmo CGC avanca para o proximo SUSPECT³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		DbSelectArea("SUS")
		DbSetOrder(4)
		If DbSeek(xFilial("SUS") + ACH->ACH_CGC)
			DbSelectArea("ACH")
			ACH->(DbSkip())
			IncProc()
			Loop
		Endif
	Endif
	
	If (MV_PAR02 == 1) //Validacao de Cliente pelo CGC
		
		If Empty(AllTrim(ACH->ACH_CGC))
			DbSelectArea("ACH")
			ACH->(DbSkip())
			IncProc()
			Loop
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Se existir um cliente com esse CGC nao grava no PROSPECT  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		DbSelectArea("SA1")
		DbSetOrder(3)
		If DbSeek(xFilial("SA1") + U_CSFMTSA1(ACH->ACH_CGC))
			DbSelectArea("ACH")
			ACH->(DbSkip())
			IncProc()
			Loop
		Endif
	Endif
	
	BEGIN TRANSACTION

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Grava um novo registro no SUS com as informacoes desse Suspect atual³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		U_TK341GrvSTP(ACH->ACH_CODIGO,ACH->ACH_LOJA,NIL)
	    
	END TRANSACTION

	DbSelectArea("ACH")
	ACH->(DbSkip())
	IncProc()
End
                      
Return(.T.)          
*__________________________________________________________________________________________________________________________

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Tk341GrvSTPºAutor  ³Vendas Clientes  	  º Data ³  31/10/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³                                                             º±±
±±º          ³Objetivo:                                                    º±±
±±º          ³Funcao para gravar um novo prospect a partir de um suspect   º±±
±±º          ³sem apagar o suspect e atualizando a classificacao do mesmo  º±±
±±º          ³                                                             º±±
±±º          ³Premissas:                                                   º±±
±±º          ³Todas as validacoes ja foram feitas antes de executar essa   º±±
±±º          ³funcao no programa de origem                                 º±±
±±º          ³                                                             º±±
±±º          ³Observacoes Importantes:                                     º±±
±±º          ³Essa funcao e executada pelo Cadastro de Suspect (no momento º±±
±±º          ³de passar para "Prospect" e no atendimento de Telemarketing  º±±
±±º          ³para fazer o mesmo processo (Converter de Suspect para       º±±
±±º          ³Prospect                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³CADASTRO DE SUSPECT e TELEMARKETING                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function Tk341GrvSTP(cCodigo,cLoja,lProspect)

Local cCodPro 		:= CRIAVAR("US_COD",.F.)		// Futuro codigo do novo prospect que sera INCLUIDO no SUS
Local lRet 	  		:= .T.							// Retorno da gravacao
Local nCont     	:= 0 							// Contador de campos
Local nSaveSx8 		:= GetSX8Len()					// Funcao de numeracao
Local aContato		:= {}							// Dados dos contatos copiados

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Pontos de entrada da gravacao de Suspect para Prospect³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local lTMKSUSP  	:= FindFunction("U_TMKSUSP")	// P.E. ANTES da gravacap de Suspect para Prospect
Local lTMKGRSP		:= FindFunction("U_TMKGRSP")	// P.E. DEPOIS da gravacao de Suspect para Prospect
Local lAtuADL		:= .F.
Local lNewWArea     := ADL->(FieldPos("ADL_CGC")) > 0	// Indica se utiliza a nova workarea

Local aRegs			:= {}							// Retorno esperado do P.E. TK341GPROS 
Local lTK341GPROS	:= FindFunction("U_TK341GPROS")	// P.E. DEPOIS da gravacao de Suspect para Prospect 

Local lNovo 		:= .F.

SX2->(DbSetOrder(1))

lAtuADL := SX2->(DbSeek("ADL")) .AND. (SUS->(FieldPos("US_VEND")) > 0) .AND. (ACH->(FieldPos("ACH_VEND")) > 0)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Ponto de Entrada antes da conversao ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lTMKSUSP              		
   lRet :=	U_TMKSUSP(cCodigo+cLoja)
   If ValType(lRet) <> "L"
      lRet := .F.
   Endif   
Endif
If !lRet											// SOMENTE para campos do usuario no cadastro de Prospect
   Return(lRet)
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Ponto de Entrada para pegar o conteudo dos campos especificos do SUS ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lTK341GPROS
	aRegs := U_TK341GPROS()  
    If ValType(aRegs) <> "A"
      aRegs := {}
   Endif   
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Grava informacoes do ACH para o cadastro de Prospect	            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectarea("ACH")
DbSetorder(1)

If DbSeek(xFilial("ACH")+ cCodigo + cLoja)
	lGrvSUS := .F.

	If !empty(ACH->ACH_CGC)
	DbSelectarea("SUS")
		dbsetorder(4) // CGC
    	if DBSEEK(xFilial("SUS")+ACH->ACH_CGC)
			lGrvSUS:=.F. //alterando
   		Else
			lGrvSUS:=.T. //Incluindo
        Endif

	Elseif !empty(ACH->ACH_TEL) .and. !empty(ACH->ACH_DDD)
		
		DbSelectarea("SUS")
		dbsetorder(3) // Telefone+DDD+DDI 
	    if DBSEEK(xFilial("SUS")+PADR(ACH->ACH_TEL,15)+PADR(ACH->ACH_DDD,3))
			lGrvSUS:=.F. //Alterando
        	
	    Else
			lGrvSUS:=.T. //Incluindo
        Endif
	Else
        			
		Return (lRet)
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Valida se realmente nao tem um PROSPECT com o mesmo codigo no cadastro atual³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Begin Transaction
		
	if lGrvSUS
		cCodPro := TkNumero("SUS","US_COD")
	Else
		cCodPro := SUS->US_COD		
		//cCodPro	:= AC8_CODENT	
	Endif


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicia a Gravacao no SUS                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbSelectarea("SUS")
	Reclock("SUS",lGrvSUS)
	Replace US_FILIAL	With xFilial("SUS")
	Replace US_COD	    With cCodPro
	Replace US_LOJA	    With ACH->ACH_LOJA
	Replace US_TIPO	    With Tk341Tipo(ACH->ACH_TIPO)
	Replace US_NOME	    With ACH->ACH_RAZAO
	Replace US_NREDUZ   With IIf(Empty(ACH->ACH_NFANT),ACH->ACH_RAZAO,ACH->ACH_NFANT)
	Replace US_END      With ACH->ACH_END
	Replace US_MUN      With ACH->ACH_CIDADE
	Replace US_BAIRRO   With ACH->ACH_BAIRRO		
	Replace US_CEP      With ACH->ACH_CEP
	Replace US_EST 	    With ACH->ACH_EST
	Replace US_DDD	    With ACH->ACH_DDD
	Replace US_DDI	    With ACH->ACH_DDI
	Replace US_TEL	    With SgLimpaTel(ACH->ACH_TEL)
	Replace US_FAX      With ACH->ACH_FAX
	Replace US_EMAIL    With ACH->ACH_EMAIL
	Replace US_URL	    With ACH->ACH_URL
	Replace US_PESSO    With ACH->ACH_PESSO
	Replace US_CGC      With Tk341AjCGC( ACH->ACH_CGC )
	Replace US_STATUS   With "1"			// "Classificado" - Status inicial quando o suspect passa para Prospect
	Replace US_ORIGEM   With "1"			// "Mailing" - Origem desse prospect
	Replace US_CATEGO   With SU5->U5_CATEGO  		 
	Replace US_DATAIMP  With SU5->U5_DTIMPO		 

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Gravacao dos campos CNAE, Faturamento, Funcionarios³
	//³Pais e midia                                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If (SUS->(FieldPos("US_CNAE")) > 0) .AND. (ACH->(FieldPos("ACH_CNAE")) > 0)
		Replace US_CNAE		With ACH->ACH_CNAE
	EndIf
	
	If (SUS->(FieldPos("US_FATANU")) > 0) .AND. (ACH->(FieldPos("ACH_FATANU")) > 0) 
		Replace US_FATANU	With ACH->ACH_FATANU
	EndIf

	If (SUS->(FieldPos("US_QTFUNC")) > 0) .AND. (ACH->(FieldPos("ACH_QTFUNC")) > 0)
		Replace US_QTFUNC	With ACH->ACH_QTFUNC
	EndIf
	
	If (SUS->(FieldPos("US_PAIS")) > 0) .AND. (ACH->(FieldPos("ACH_PAIS")) > 0)
		Replace US_PAIS		With ACH->ACH_PAIS
	EndIf	

	If (SUS->(FieldPos("US_MIDIA")) > 0) .AND. (ACH->(FieldPos("ACH_MIDIA")) > 0)
		Replace US_MIDIA	With ACH->ACH_MIDIA
	EndIf	

	If (SUS->(FieldPos("US_VEND")) > 0) .AND. (ACH->(FieldPos("ACH_VEND")) > 0)
		Replace US_VEND	With ACH->ACH_VEND
	EndIf		

	/*	
	  ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	  ³Grava os campos de usuario atraves do retorno do P.E.  			³
	  ³Porque os campos podem nao tem o mesmo nome no SUS iguais ao ACH ³
	  ³                                                                 ³
	  ³Estrutura do Array de Retorno                                    ³
	  ³aRegs[1][1]  =  Codigo do Suspect   Ex: ACH->ACH_CODIGO          ³
	  ³aRegs[1][2]  =  Campo               Ex: "US_xxxxxx"				³
	  ³aRegs[1][3]  =  Conteudo 		   Ex: "Microsiga Software SA"  ³
	  ³                                                                 ³
	  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	*/  
	If Len(aRegs) > 0
		For nCont := 1 TO Len(aRegs)
			If aRegs[nCont][1] == ACH->ACH_CODIGO   // Se este item pertencer ao registro posicionado grava.
				Replace &(aRegs[nCont][2]) With aRegs[nCont][3]
			Endif
		Next nCont
	Endif

	If !EMPTY(ACH->ACH_CGC)
		DbSelectArea("SA1")
		DbSetOrder(3)
		If DbSeek(xFilial("SA1")+U_CSFMTSA1(ACH->ACH_CGC))
			DbSelectArea("SUS")
			Replace US_CODCLI  	With SA1->A1_COD		 	
			Replace US_LOJACLI  With SA1->A1_LOJA
			Replace US_DTCONV 	With SA1->A1_PRICOM 
			Replace US_STATUS 	With '6' //CLIENTE
		Endif	
    Endif
    
	MsUnlock()
	FkCommit()

	if lGrvSUS
		While (GetSx8Len() > nSaveSx8)
			ConfirmSX8()
		End	
	Endif	

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Atualiza o Prospect   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lProspect <> NIL
		lProspect := .T.
	Endif
	
	lRet := .T.

	If lGrvSUS

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Alteracao da entidade ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		DbSelectArea("AC8")
		DbSetOrder(2) 				//AC8_FILIAL+AC8_ENTIDA+AC8_FILENT+AC8_CODENT+AC8_CODCON
		If DbSeek(xFilial("AC8")+("ACH")+(xFilial("ACH"))+ALLTRIM(cCodigo+cLoja))
			
			While (!Eof()) 								.AND. ;
				(AC8->AC8_FILIAL == xFilial("AC8")) 	.AND. ;
				(AC8->AC8_ENTIDA == "ACH") 				.AND. ;
				(AC8->AC8_FILENT == xFilial("ACH")) 	.AND. ;
				(ALLTRIM(AC8->AC8_CODENT) == ALLTRIM(cCodigo+cLoja))
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Armazena os contatos ja existentes no suspect para copia³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				AAdd(aContato,{	xFilial("AC8")			,;
				"SUS"					,;
				xFilial("SUS")			,;
				cCodPro + ACH->ACH_LOJA	,;
				AC8->AC8_CODCON			})
				AC8->(DbSkip())
			End
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Copia os contatos para o prospect³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			For nCont := 1 to Len(aContato)
				Reclock("AC8",.T.)
				Replace AC8_FILIAL  With aContato[nCont][1]
				Replace AC8_ENTIDA  With aContato[nCont][2]
				Replace AC8_FILENT  With aContato[nCont][3]
				Replace AC8_CODENT	With aContato[nCont][4]
				Replace AC8_CODCON	With aContato[nCont][5]
				MsUnlock()
				FkCommit()
			Next nCont
		Endif
	Endif
	DbSelectArea("ACH")

	Reclock( "ACH" ,.F.,.T.)
	Replace ACH->ACH_CODPRO With cCodPro
	Replace ACH->ACH_LOJPRO With ACH->ACH_LOJA
	Replace ACH->ACH_STATUS With "6"
	Replace ACH->ACH_DTCONV With Date()
	MsUnlock()
	FkCommit()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Atualiza o relacionamento com o ADL (conta do vendedor)³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lAtuADL
		If lNewWArea
			If FindFunction("Ft520UpdEn")
				Ft520UpdEn("ACH"			, "SUS"	   		, ACH->ACH_CODIGO, SUS->US_COD	,;
							ACH->ACH_LOJA	, SUS->US_LOJA	)
			EndIf
		Else
			Ft520AltEn(	4			, ACH->ACH_VEND	,	 "SUS"	, SUS->US_COD	,;
			 			SUS->US_LOJA)
		EndIf
	EndIf
	
    End Transaction
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Ponto de Entrada depois da conversao³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lTMKGRSP
		U_TMKGRSP(cCodPro,ACH->ACH_LOJA)
	Endif
Endif 

Return(lRet)