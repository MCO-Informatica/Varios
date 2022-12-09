#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "AP5MAIL.CH"
#include "topconn.ch"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"

#DEFINE MARCA  		001
#DEFINE EMISSAO		002
#DEFINE NOTA		003
#DEFINE SERIE		004
#DEFINE PESTOTAL	005
#DEFINE CLIENTE		006
#DEFINE NOMCLI		007
#DEFINE TOTALNOTA	008
#DEFINE VOLUME		009
#DEFINE RECNO		010

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ VIPPLIFE         บAutor ณMarcos Gomes บ Data ณ  09/03/21   บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Postagens vipp/correios      - WebService                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Funcao Principal                                           บฑฑ
ฑฑฬออออออออออุออออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDATA      ณ ANALISTA ณ MOTIVO                                          บฑฑ
ฑฑฬออออออออออุออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ          ณ                                                 บฑฑ
ฑฑศออออออออออฯออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function ViPPLife()

	Local aArea     := GetArea()
	Private cPerg	:= PadR("PSTCOR",10)
	Private cSerieNF:= Space(03)

	ValidaPerg()

	If !Pergunte(cPerg,.T.)
		Return .T.
	Endif

	If Empty(MV_PAR01)	// Serie de Nota
		MsgStop("Atencao ้ Obrigat๓rio o Preenchimento do Parโmetro de S้rie da Nota Fiscal !")
		Return .F.
	Endif

	if substr(mv_par07,len(alltrim(mv_par07)),1) != '\'
		MsgStop("A barra \ deve ser colocada no final !")
		Return .F.
	endif

	cSerieNf	:=	MV_PAR01

	Processa({|| fPrcNfs(cSerieNF) })

	RestArea(aArea)
Return .T.


Static Function fPrcNfs(cSerieNF)

	Local aArea := GetArea()
	//Local lRet	:= .t.
	Private oTTC
	Private oOk	    := LoadBitmap(GetResources(),"BR_VERDE")
	Private oNo  	:= LoadBitmap(GetResources(),"BR_VERMELHO")
	Private oMarca  := LoadBitmap(GetResources(),"LBTIK")
	Private oDesma	:= LoadBitmap(GetResources(),"LBNO")
	Private oTelNotas
	Private oNotas  := {}
	Private aNotas  := {{'2','','','',0,'','',0.00,0,'',.F.,0,''}}

	lOk:=.f.

	DEFINE MSDIALOG oTelNotas TITLE "Notas Fiscais - Etiquetas Correios - Total Notas (" + AllTrim(Str(Len(aNotas),6))+') ' FROM 000, 000  TO 500, 1000 COLORS 0, 16777215 PIXEL

	@ 010, 005 LISTBOX oNotas Fields HEADER '','Emissใo',"Nota","S้rie",'Peso',"Cliente", "Razใo Social", "Valor Total","Volume(s)" SIZE 490, 210 OF oTelNotas PIXEL ColSizes 50,50

	// Marca Notas
	oNotas:bLDblClick := {|| dblClick(oNotas:nAt)}

	PsqNF(@aNotas)

	oNotas:SetArray(aNotas)
	oNotas:bLine := {|| {	Iif(aNotas[oNotas:nAt,MARCA]=='1',oMarca,oDesma),;
		aNotas[oNotas:nAt,EMISSAO],;
		aNotas[oNotas:nAt,NOTA],;
		aNotas[oNotas:nAt,SERIE],;
		TransForm(aNotas[oNotas:nAt,PESTOTAL],'@E 9,999.9999'),;
		aNotas[oNotas:nAt,CLIENTE],;
		aNotas[oNotas:nAt,NOMCLI],;
		TransForm(aNotas[oNotas:nAt,TOTALNOTA],'@E 9,999,999,999.99'),;
		TransForm(aNotas[oNotas:nAt,VOLUME],'9,999,999')}}

	@ 230, 005 BUTTON oBotaoCnf PROMPT "&Enviar Postagens"	   		ACTION (MsAguarde({|| lOk:=PrcNfs(aNotas) },OemtoAnsi("Aguarde Gerando Etiquetas...")),Iif(lOk,Close(oTelNotas),.t.)) SIZE 060, 010 OF oTelNotas PIXEL
	@ 230, 075 BUTTON oBotaoMar PROMPT "&Marca Todas" 				ACTION Processa( {|| MarcaTodas()},"Aguarde Marcando Notas Fiscais") SIZE 060, 010 OF oTelNotas PIXEL
	@ 230, 145 BUTTON oBotaoDes PROMPT "&Desmarca Todas" 			ACTION Processa( {|| DesMarcaTodas()},"Aguarde Desmarcando Notas Fiscais") SIZE 060, 010 OF oTelNotas PIXEL
	@ 230, 425 BUTTON oBotaoSai PROMPT "&Sair" 						ACTION (lOk:=.f.,oTelNotas:End()) 	SIZE 060, 010 OF oTelNotas PIXEL


	ACTIVATE MSDIALOG oTelNotas CENTERED

	RestArea(aArea)
Return


Static Function PrcNfs(aNotas)

	Local aArea := GetArea()
	Local lRet := .f.
	Local nI
	Local sGetRet := ""
	Local aLista := {}
	Local cLista := ""
	Local cListF := ""
	Local cGetUrl := ""
	Local cNomeArq := ''
	Local nHdl     := 0

	nMarcados := 0
	For nI := 1 To Len(aNotas)
		If aNotas[nI,MARCA]=='1'
			nMarcados++
		Endif
	Next

	If Empty(nMarcados)
		MsgStop("Nใo Foi Selecionada Nenhuma Nota Fiscal ! ")
		Return .f.
	Endif

	// Solicita Confirma็ใo na Impressใo das Etiquetas, Caso Exista Alguma Gerada
	If MsgYesNo("Confirma enviar postagens para o ViPP ?")

		lAmbHmg := (MV_PAR06==1)  // 1 - Homologacao 2 - Produ็ใo

		If lAmbHmg		/* Homologa็ใo VIPP - cred๊nciais */
			_cLogin      := 'onbiws'
			_cSenha      := '112233'
			_cIdPerfil   := '9363'          // Id perfil homologa็ใo
			_cCodigo     := ''              // c๓d administrativo
			_cContrato   := ''
			_cCartao     := ''
			_cCNPJ       := ''
		else			/* Produ็ใo VIPP - cred๊nciais LifeSkin */
			_cLogin      := 'epsadmin13233'
			_cSenha      := '111111'
			_cIdPerfil   := '11747'         // Id perfil principal lifeskin
			if MV_PAR08==1
				_cCodigo     := '15127486'      // c๓d administrativo BIOCOSMETICOS COM DE COSMETICOS LTDA EPP
				//_cContrato   := '9912372827'    // contrato LIFE SKIN COSMETICOS EIRELI EPP
				_cContrato   := '9912374708'    // contrato BIOCOSMETICOS COM DE COSMETICOS LTDA EPP
				//_cCartao   := '70924830'      // cartao LIFE SKIN COSMETICOS EIRELI EPP
				_cCartao     := '71020055'      // cartao BIOCOSMETICOS COM DE COSMETICOS LTDA EPP
			else
				_cCodigo     := '22046097'      // c๓d administrativo LOOK LOG OPERACOES ESPECIALIZADAS EIREL
				_cContrato   := '9912567211'    // contrato LOOK LOG OPERACOES ESPECIALIZADAS EIREL
				_cCartao     := '76945367'      // cartao LOOK LOG OPERACOES ESPECIALIZADAS EIREL
			endif
			_cCNPJ       := ''
		Endif

		cLista += "'"
		cListF += "'"
		sz7->(dbSetOrder(1))

		ProcRegua(Len(aNotas))
		For nI := 1 To Len(aNotas)
			IncProc("Aguarde fazendo postagens...")
			If aNotas[nI,MARCA]=='1'

				sf2->(dbGoTo(aNotas[nI,RECNO]))

				if !lAmbHmg
					cSerie := sf2->f2_serie
					if substr(cSerie,1,1) == 'F'
						cSerie := 'F  '
					endif
					if sz7->(Dbseek(xfilial()+cSerie))
						_cIdPerfil := sz7->z7_perfil
					else
						MsgAlert("A NF : "+sf2->f2_doc+" Serie: "+sf2->f2_serie+" Nใo serแ postada pois nใo encontrou seu perfil do Vipp",'Busca do Perfil de postagem')
						loop
					endif
				endif

				if len(cLista) > 1  .and. substr(cLista,len(cLista),1) != ','
					cLista += ","
				endif
				if len(cListF) > 1  .and. substr(cListF,len(cListF),1) != ','
					cListF += ","
				endif

				aLista := EnviaPost(aNotas[nI,RECNO],_cLogin,_cSenha,_cIdPerfil,_cCodigo,_cContrato,_cCartao)

				cLista += aLista[1]
				cListF += aLista[2]

			Endif
		Next

		if substr(cLista,len(cLista),1) == ','
			cLista := substr(cLista,1,len(cLista)-1)
		endif
		if substr(cListF,len(cListF),1) == ','
			cListF := substr(cListF,1,len(cListF)-1)
		endif

		cLista += "'"
		cListF += "'"

		if cLista != "''" .and. !empty(cLista)

			sleep(1000)

			//cGetUrl := "http://www.vipp.visualset.com.br/vipp/remoto/ImpressaoRemota.php?Usr='"+_cLogin+"'&Pwd='"+_cSenha+"'&Ordem=1&Filtro=1&Saida=0&Lista="+cLista
			//cGetUrl := "http://www.vipp.visualset.com.br/vipp/remoto/ImpressaoRemota.php?Usr='"+_cLogin+"'&Pwd='"+_cSenha+"'&Ordem=1&Filtro=1&Saida=1&Lista="+cLista
			cGetUrl := "http://www.vipp.visualset.com.br/vipp/remoto/ImpressaoRemota.php?Usr='"+_cLogin+"'&Pwd='"+_cSenha+"'&Ordem=1&Filtro=1&Saida=20&Lista="+cLista
			sGetRet := Httpget(cGetUrl)

			cNomeArq := alltrim(mv_par07)+'Eqt_'+dtos(dDatabase)+'_'+replace(time(),":","")+'.pdf'
			nHdl := fCreate(cNomeArq)
			if nHdl == -1
				MsgAlert('O arquivo '+cNomeArq+', nao pode ser criado! ','Atencao!')
				Return .f.
			else
				if fWrite(nHdl,sGetRet,Len(sGetRet)) != Len(sGetRet)
					MsgAlert('Ocorreu erro gravacao arquivo '+cNomeArq+'.','Atencao!')
					fClose(nHdl)
					Return .f.
				endif
				fClose(nHdl)
			Endif

			if MsgYesNo("Deseja abrir arquivo etiquetas para impressใo?")
				ShellExecute( "Open", cNomeArq, "", "", 1)
			endif
			/*
			sleep(1000)

			cGetUrl := "http://www.vipp.visualset.com.br/vipp/remoto/ImpressaoRemota.php?Usr='"+_cLogin+"'&Pwd='"+_cSenha+"'&Ordem=1&Filtro=1&Saida=6&Lista="+cLista
			sGetRet := Httpget(cGetUrl)

			cNomeArq := alltrim(mv_par07)+'AR_'+dtos(dDatabase)+'_'+replace(time(),":","")+'.zvp'
			nHdl := fCreate(cNomeArq)
			if nHdl == -1
				MsgAlert('O arquivo '+cNomeArq+', nao pode ser criado! ','Atencao!')
				Return .f.
			else
				if fWrite(nHdl,sGetRet,Len(sGetRet)) != Len(sGetRet)
					MsgAlert('Ocorreu erro gravacao arquivo '+cNomeArq+'.','Atencao!')
					fClose(nHdl)
					Return .f.
				endif
				fClose(nHdl)
			Endif

			if MsgYesNo("Deseja Imprimir o AR a partir do Aplicativo VIPP?")
			//WaitRun("d:\zvp\zvp.exe",1)
			ShellExecute( "Open", cNomeArq, "", "", 1)
			endif
			*/
			if cListF != "''" .and. !empty(cListF)
				sleep(1000)

				//cGetUrl := "http://www.vipp.visualset.com.br/vipp/remoto/ImpressaoRemota.php?Usr='"+_cLogin+"'&Pwd='"+_cSenha+"'&Ordem=1&Filtro=1&Saida=25&Lista="+cListF
				cGetUrl := "http://www.vipp.visualset.com.br/vipp/remoto/ImpressaoRemota.php?Usr='"+_cLogin+"'&Pwd='"+_cSenha+"'&Ordem=1&Filtro=1&Saida=24&Lista="+cListF
				//cGetUrl := "http://www.vipp.visualset.com.br/vipp/remoto/ImpressaoRemota.php?Usr='"+_cLogin+"'&Pwd='"+_cSenha+"'&Ordem=1&Filtro=1&Saida=23&Lista="+cListF
				sGetRet := Httpget(cGetUrl)

				cNomeArq := alltrim(mv_par07)+'Dc_'+dtos(dDatabase)+'_'+replace(time(),":","")+'.pdf'
				nHdl := fCreate(cNomeArq)
				if nHdl == -1
					MsgAlert('O arquivo '+cNomeArq+', nao pode ser criado! ','Atencao!')
					Return .f.
				else
					if fWrite(nHdl,sGetRet,Len(sGetRet)) != Len(sGetRet)
						MsgAlert('Ocorreu erro gravacao arquivo '+cNomeArq+'.','Atencao!')
						fClose(nHdl)
						Return .f.
					endif
					fClose(nHdl)
				Endif

				if MsgYesNo("Deseja abrir arquivo Declara็ใo de conte๚do para impressใo?")
					ShellExecute( "Open", cNomeArq, "", "", 1)
				endif
			Endif

			lRet := .t.

		Endif

	else
		Return .f.
	Endif
	RestArea(aArea)
Return lRet


Static Function PsqNF(aNotas)

	Local aArea := GetArea()
	Local lRet  := .t.

	cQuery := 	 " SELECT * "
	cQuery +=	 " FROM " + RetSqlName("SF2") + " F2 (NOLOCK) "
	cQuery +=	 " WHERE  F2_FILIAL = '" + xFilial("SF2") + "' "
	cQuery +=	 " AND F2.D_E_L_E_T_ = '' "
	cQuery +=	 " AND F2.F2_DOC BETWEEN '" + MV_PAR02 + "' AND '" + MV_PAR03 + "' "
	//cQuery +=	 " AND F2.F2_SERIE = '" + MV_PAR01 + "' "
	cQuery +=	 " AND F2.F2_X_EMPFA = '" + MV_PAR01 + "' "
	cQuery +=	 " AND F2.F2_TIPO = 'N' "
	cQuery +=	 " AND F2.F2_TRANSP IN ('000004','001000','001001') "  //PAC - CODIGO 001000 SEDEX - CODIGO 001001
	cQuery +=	 " AND F2.F2_EMISSAO BETWEEN '" + DtoS(MV_PAR04) + "' AND '" + DtoS(MV_PAR05) + "' "
	cQuery +=	 " AND F2_XETQ != 'S' "
	cQuery +=	 " ORDER BY F2_EMISSAO, F2_DOC, F2_SERIE "
	TCQUERY cQuery NEW ALIAS "CHK1"
	TcSetField('CHK1','F2_EMISSAO','D')

	dbSelectArea("CHK1")
	dbGoTop()

	Count To nReg
	ProcRegua(nReg)
	dbGoTop()

	aNotas := {}

	While CHK1->(!Eof())
		IncProc("Localizando (" + AllTrim(Str(Len(aNotas),6))+") Notas Fiscais...")

		If !SF2->(dbSetOrder(1), dbSeek(xFilial("SF2")+CHK1->F2_DOC+CHK1->F2_SERIE+CHK1->F2_CLIENTE+CHK1->F2_LOJA))
			CHK1->(dbSkip(1));Loop
		Endif

		If !SA1->(dbSetOrder(1), dbSeek(xFilial("SA1")+CHK1->F2_CLIENTE+CHK1->F2_LOJA))
			CHK1->(dbSkip(1));Loop
		Endif

		AAdd(aNotas,{	'2',;
			DtoC(SF2->F2_EMISSAO),;
			SF2->F2_DOC,;
			SF2->F2_SERIE,;
			SF2->F2_PBRUTO,;
			SF2->F2_CLIENTE+'/'+SF2->F2_LOJA,;
			SA1->A1_NOME,;
			SF2->F2_VALBRUT,;
			SF2->F2_VOLUME1,;
			SF2->(Recno())})

		CHK1->(dbSkip(1))
	Enddo
	CHK1->(dbCloseArea())
	RestArea(aArea)

	If Empty(Len(aNotas)) .Or. Empty(nReg)
		AAdd(aNotas,{	'2',;
			'',;
			'',;
			'',;
			0,;
			'',;
			'',;
			0.00,;
			0,;
			0})
		MsgStop("Aten็ใo Nenhuma Nota Localizada !")
		RestArea(aArea)
		lRet := .F.
	Endif

	oNotas:SetArray(aNotas)
	oNotas:nAt := 1
	oNotas:bLine := {|| {	Iif(aNotas[oNotas:nAt,MARCA]=='1',oMarca,oDesma),;
		aNotas[oNotas:nAt,EMISSAO],;
		aNotas[oNotas:nAt,NOTA],;
		aNotas[oNotas:nAt,SERIE],;
		TransForm(aNotas[oNotas:nAt,PESTOTAL],'@E 9,999.9999'),;
		aNotas[oNotas:nAt,CLIENTE],;
		aNotas[oNotas:nAt,NOMCLI],;
		TransForm(aNotas[oNotas:nAt,TOTALNOTA],'@E 9,999,999,999.99'),;
		TransForm(aNotas[oNotas:nAt,VOLUME],'9,999,999')}}

	oNotas:Refresh()
	RestArea(aArea)
	oTelNotas:cCaption := "Notas Fiscais - Postagens ViPP Correios - Total Notas (" + AllTrim(Str(Len(aNotas),6))+') '
Return lRet


Static Function EnviaPost(nRegSF2,cLogin,cSenha,cIdPerfil,cCodigo,cContrato,cCartao)

	Local cPostUrl  := ''
	Local cNomeArq  := ''
	Local aHeadOut  := {}
	Local cMens     := ''
	Local cPostData := ''
	Local sPostRet  := ''
	Local cJsonErr  := ''
	Local cLista    := ''
	Local cListF    := ''
//Local aProdutos := {}
	Local cCodSer   := ''
	Local nValFat   := 0
	Local n_volume  := 0
	Local nIdx      := 0
	Local nCepDest  := 0
	Local nHdl      := 0
	Local nValDec   := 0
	Local lret      := .f.

	If !SA1->(dbSetOrder(1), dbSeek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA))
		Return {cLista,cListF}
	Endif

	// Senใo Tiver Endere็o de Entrega Entใo Pega Endere็o de Faturamento do Cliente
	If Empty(SA1->A1_ENDENT) //.or. Empty(SA1->A1_MUNE) .or. Empty(SA1->A1_ESTE)
		if SA1->A1_EST == 'DF'
			cEndereco:= SA1->A1_END
			cNumero  := '.'
		else
			cEndereco:= MyGetEnd2(SA1->A1_END,"SA1")[1]
			cNumero  := StrZero(IIF(MyGetEnd2(SA1->A1_END,"SA1")[2]<>0,MyGetEnd2(SA1->A1_END,"SA1")[2],0),05)
		endif
		cComplem	:= iif(SA1->(FieldPos("A1_COMPLEM")) > 0 .And. !Empty(SA1->A1_COMPLEM),SA1->A1_COMPLEM,MyGetEnd2(SA1->A1_END,"SA1")[4])
		cBairro	:= SA1->A1_BAIRRO
		cMunicipio:= SA1->A1_MUN
		cEstado	:= SA1->A1_EST
		cCep		:= SA1->A1_CEP
	Else
		if SA1->A1_ESTE == 'DF'
			cEndereco:= SA1->A1_ENDENT
			cNumero  := '.'
		else
			cEndereco:= MyGetEnd2(SA1->A1_ENDENT,"SA1")[1]
			cNumero  := StrZero(IIF(MyGetEnd2(SA1->A1_ENDENT,"SA1")[2]<>0,MyGetEnd2(SA1->A1_ENDENT,"SA1")[2],0),05)
		endif
		cComplem	:= MyGetEnd2(SA1->A1_ENDENT,"SA1")[4]  //iif(SA1->(FieldPos("A1_COMPLEM")) > 0 .And. !Empty(SA1->A1_COMPLEM),SA1->A1_COMPLEM,MyGetEnd2(SA1->A1_ENDENT,"SA1")[4])
		cBairro	:= SA1->A1_BAIRROE
		cMunicipio:= SA1->A1_MUNE
		cEstado	:= SA1->A1_ESTE
		cCep		:= SA1->A1_CEPE
	Endif

	if cNumero == "00000"
		MsgAlert('N๚mero do endere็o Zerado para o cliente c๓d '+SA1->A1_COD+'! Favor verificar cadastro cliente! Esta etiqueta da NF: '+SF2->F2_DOC+'/'+SF2->F2_SERIE+', nใo serแ gerada!', 'Cadastro cliente')
		Return {cLista,cListF}
	endif

	cComplem	:= substr(alltrim(cComplem),1,50)
	cCompCep:=  Iif('SN'$cNumero,'00000',StrZero(Val(cNumero),5))

	cEndOri 	:= MyGetEnd2(SM0->M0_ENDENT,"SM0")[1]
	cNumOri		:= StrZero(IIF(MyGetEnd2(SM0->M0_ENDENT,"SM0")[2]<>0,MyGetEnd2(SM0->M0_ENDENT,"SM0")[2],0),5)
	cCepOri     := SM0->M0_CEPENT
	cMunOri     := SM0->M0_CIDENT
	cEstOri     := SM0->M0_ESTENT
	cBaiOri     := SM0->M0_BAIRENT
	cComOri     := SM0->M0_COMPENT

	cCmpOri     := Iif('SN'$cNumOri,'00000',StrZero(Val(cNumOri),5))

	nSomaCepD   := 0
	For nCepDest := 1 To Len(cCep)
		nSomaCepD += Val(SubStr(cCep,nCepDest,1))
	Next
	nM10 := int((nSomaCepD / 10 + 1) ) * 10
	cDig := Str((nM10 - nSomaCepD),1)

	if SF2->F2_VOLUME1 == 0
		n_volume := 1
	else
		n_volume := SF2->F2_VOLUME1
	endif

	//sb1->(dbSetOrder(1))
	//sd2->(dbSetOrder(3))
	//sd2->(MsSeek(xFilial()+sf2->f2_doc+sf2->f2_serie+sf2->f2_cliente+sf2->f2_loja))
	//While sd2->(!Eof()) .and. sd2->d2_doc == sf2->f2_doc .and. sd2->d2_serie == sf2->f2_serie .and. ;
		//                          sd2->d2_cliente == sf2->f2_cliente .and. sd2->d2_loja == sf2->f2_loja

	//    sb1->(MsSeek(xFilial()+sd2->d2_cod))
	//    aadd(aProdutos, { sb1->b1_desc, sd2->d2_quant, sd2->d2_total })
	//    sd2->(dbSkip())
	//EndDo

	if MV_PAR08==1
		if SF2->F2_TRANSP == '001000'
			cCodSer := '04669'  //PAC
		elseif SF2->F2_TRANSP $ '001001/000004'
			cCodSer := '04162'  //SEDEX
		endif
	else
		if SF2->F2_TRANSP == '001000'
			cCodSer := '03298'  //PAC
		elseif SF2->F2_TRANSP $ '001001/000004'
			cCodSer := '03220'  //SEDEX
		endif
	endif

	cPostUrl  := 'http://vpsrv.visualset.com.br/api/v1/middleware/PostarObjeto'
	aHeadOut  := {}
	//cMens     := 'Message_Identifier=JD&Message_Type=TruckPostion'
	cMens     := ''

	Aadd(aHeadOut,'Accept: */*')
	Aadd(aHeadOut,'Content-Type: application/json')

	nValFat := round(SF2->F2_VALFAT/n_volume,2)*100
	nValDec := 0
	if nValFat >= 3000
		nValDec := nValFat
	endif

	//for nIdx :=  1 to len(aProdutos)                //Posta um volume de cada vez
	for nIdx :=  1 to n_volume                        //Posta um volume de cada vez
		lret      := .f.
		cPostData := '{ '
		cPostData += '"PerfilVipp": { '
		cPostData +=        '"Usuario": "'+cLogin+'",'
		cPostData +=        '"Token": "'+cSenha+'",'
		cPostData +=        '"IdPerfil": "'+cIdPerfil+'"'
		cPostData +=        '},'
		cPostData += '"ContratoEct": { '
		cPostData +=        '"NrContrato": "'+cContrato+'",'    //Nใo precisa preencher contrato,codadm e cartใo se tiver s๓ um contrato
		cPostData +=        '"CodigoAdministrativo": "'+_cCodigo+'",'
		cPostData +=        '"NrCartao": "'+cCartao+'"'
		cPostData +=        '},'
		cPostData += '"Destinatario": {'
		cPostData +=        '"CnpjCpf": "",'
		cPostData +=        '"IeRg": "",'
		cPostData +=        '"Nome": "'+Alltrim(sa1->a1_nome)+'",'
		cPostData +=        '"SegundaLinhaDestinatario": "",'
		cPostData +=        '"Endereco": "'+alltrim(cEndereco)+'",'
		cPostData +=        '"Numero": "'+alltrim(cNumero)+'",'
		cPostData +=        '"Complemento": "'+alltrim(cComplem)+'",'
		cPostData +=        '"Bairro": "'+alltrim(cBairro)+'",'
		cPostData +=        '"Cidade": "'+alltrim(cMunicipio)+'",'
		cPostData +=        '"UF": "'+alltrim(cEstado)+'",'
		cPostData +=        '"Cep": "'+alltrim(cCep)+'",'
		cPostData +=        '"Telefone": "",'
		cPostData +=        '"Celular": "",'
		cPostData +=        '"Email": ""'
		cPostData +=        '},'
		cPostData += '"Servico": {'
		cPostData +=        '"ServicoECT": "'+cCodSer+'"'
		cPostData +=        '},'
		cPostData += '"NotasFiscais": ['
		cPostData +=            '{'
		cPostData +=            '"DtNotaFiscal": "'+alltrim(dtoc(sf2->f2_emissao))+'",'
		cPostData +=            '"SerieNotaFiscal": "'+alltrim(sf2->f2_serie)+'",'
		cPostData +=            '"NrNotaFiscal": "'+alltrim(sf2->f2_doc)+'",'
		cPostData +=            '"VlrTotalNota": "'+AllTrim(Str(sf2->f2_valfat))+'"'
		cPostData +=            '}'
		cPostData +=        '],'
		cPostData += '"Volumes": ['
		cPostData +=            '{'
		cPostData +=            '"Peso": "",'
		cPostData +=            '"Altura": "",'
		cPostData +=            '"Largura": "",'
		cPostData +=            '"Comprimento": "",'
		cPostData +=            '"ContaLote": "",'
		cPostData +=            '"ChaveRoteamento": "",'
		cPostData +=            '"CodigoBarraVolume": "",'
		cPostData +=            '"CodigoBarraCliente": "",'
		cPostData +=            '"ObservacaoVisual": "",'
		cPostData +=            '"ObservacaoQuatro": "",'
		cPostData +=            '"ObservacaoCinco": "",'
		cPostData +=            '"PosicaoVolume": "",'
		cPostData +=            '"Conteudo": "",'
		cPostData +=            '"DeclaracaoConteudo": {'
		cPostData +=                '"ItemConteudo": ['

		//if nIdx > 1
		//   cPostData += ','
		//EndIf

		//cPostData +=                    '{'
		//cPostData +=                        '"DescricaoConteudo": "'+alltrim(aProdutos[nIdx,1])+'",'
		//cPostData +=                        '"Quantidade": '+AllTrim(Str(aProdutos[nIdx,2]))+','
		//cPostData +=                        '"Valor": "'+AllTrim(Str(aProdutos[nIdx,3]))+'"'
		//cPostData +=                    '}'

		cPostData +=                    '{'
		cPostData +=                        '"DescricaoConteudo": "PRODUTOS COSMETICOS",'
		cPostData +=                        '"Quantidade": 1,'
		cPostData +=                        '"Valor": "'+alltrim(str(nValFat))+'"'
		cPostData +=                    '}'

		cPostData +=                '],'
		cPostData +=            '"DocumentoRemetente": "",'
		cPostData +=            '"DocumentoDestinatario": ""'
		cPostData +=            '},'
		cPostData +=            '"ValorDeclarado": "'+alltrim(str(nValDec))+'",'
		cPostData +=            '"AdicionaisVolume": "AR",'
		cPostData +=            '"VlrACobrar": "",'
		cPostData +=            '"Etiqueta": ""'
		cPostData +=            '}'
		cPostData +=        ']'
		cPostData += "}"

		cNomeArq:= alltrim(mv_par07)+'PostApi_'+alltrim(sf2->f2_doc)+'_'+alltrim(str(nIdx))+'.Json'
		nHdl := fCreate(cNomeArq)
		If nHdl == -1
			MsgAlert('O arquivo '+cNomeArq+', nao pode ser criado! ','Atencao!')
		else
			if fWrite(nHdl,cPostData,Len(cPostData)) != Len(cPostData)
				MsgAlert('Ocorreu erro gravacao arquivo '+cNomeArq+'.','Atencao!')
			Endif
			fClose(nHdl)
		endif

		sPostRet := u_PostRestApi(cPostUrl,aHeadOut,cPostData,cMens)

		if sPostRet == "ERROR"
			MsgAlert("Nใo guardou Retorno API ViPP para a postagem ref. Nf: "+sf2->f2_doc+" Serie: "+sf2->f2_serie+'HttpPost Failed')
		else
			cNomeArq:= alltrim(mv_par07)+'RetApi_'+alltrim(sf2->f2_doc)+'_'+alltrim(str(nIdx))
			oJson   := JSonObject():New()
			cJsonErr:= oJSon:fromJson(sPostRet)
			If !empty(cJsonErr)
				MsgAlert(cJsonErr,'Json Parser Error')
				cNomeArq += '_ParserError'
			elseif oJson:GetJSonObject('StatusPostagem') != 'Valida'
				MsgAlert(DecodeUTF8(sPostRet),'API Failed')
				cNomeArq += '_Api_Error'
			endif
			cNomeArq += '.json'
			nHdl := fCreate(cNomeArq)
			If nHdl == -1
				MsgAlert('O arquivo '+cNomeArq+', nao pode ser criado! ','Atencao!')
			else
				if fWrite(nHdl,sPostRet,Len(sPostRet)) != Len(sPostRet)
					MsgAlert('Ocorreu erro gravacao arquivo '+cNomeArq+'.','Atencao!')
				elseif !("ERROR" $ Upper(cNomeArq))
					if !empty(cLista)
						cLista += ","
					endif
					cLista += oJson:GetJSonObject('Volumes')[1]:GetJSonObject('Etiqueta')
					if substr(sf2->f2_serie,1,1) == 'F'
						if !empty(cListF)
							cListF += ","
						endif
						cListF += oJson:GetJSonObject('Volumes')[1]:GetJSonObject('Etiqueta')
					endif
					lret := .t.
				Endif
				fClose(nHdl)
			Endif
		Endif

	Next

	if lret
		SF2->( RecLock( 'SF2', .F. ) )
		SF2->F2_XETQ := 'S'
		SF2->( MsUnLock() )
	endif

Return {cLista,cListF}


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณMyGetEnd  ณ Autor ณ Liber De Esteban             ณ Data ณ 19/03/09 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Verifica se o participante e do DF, ou se tem um tipo de endereco ณฑฑ
ฑฑณ          ณ que nao se enquadra na regra padrao de preenchimento de endereco  ณฑฑ
ฑฑณ          ณ por exemplo: Enderecos de Area Rural (essa verific็ใo e feita     ณฑฑ
ฑฑณ          ณ atraves do campo ENDNOT).                                         ณฑฑ
ฑฑณ          ณ Caso seja do DF, ou ENDNOT = 'S', somente ira retornar o campo    ณฑฑ
ฑฑณ          ณ Endereco (sem numero ou complemento). Caso contrario ira retornar ณฑฑ
ฑฑณ          ณ o padrao do FisGetEnd                                             ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Obs.     ณ Esta funcao so pode ser usada quando ha um posicionamento de      ณฑฑ
ฑฑณ          ณ registro, pois serแ verificado o ENDNOT do registro corrente      ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ SIGAFIS                                                           ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function MyGetEnd2(cEndereco,cAlias)

Local cCmpEndN	:= SubStr(cAlias,2,2)+"_ENDNOT"
Local cCmpEst	:= SubStr(cAlias,2,2)+"_EST"
Local aRet		:= {"",0,"",""}

If cAlias=='SM0'
   aRet := FisGetEnd(cEndereco)
Else
    //Campo ENDNOT indica que endereco participante mao esta no formato <logradouro>, <numero> <complemento>
    //Se tiver com 'S' somente o campo de logradouro sera atualizado (numero sera SN)
    If (&(cAlias+"->"+cCmpEst) == "DF") .Or. ((cAlias)->(FieldPos(cCmpEndN)) > 0 .And. &(cAlias+"->"+cCmpEndN) == "1")
        aRet[1] := cEndereco
        aRet[3] := "SN"
    Else
        aRet := FisGetEnd(cEndereco)
    EndIf
Endif
Return aRet

/*
???????????????????????????????????????
??uncao    ?DblClick?Autor ?Luiz Alberto        ?Data ?06/12/11 ??
???????????????????????????????????????
??escricao ?Funcao Responsavel pelo Double Click Tela Rotas ??
??         |                                             ??
???????????????????????????????????????
*/
Static Function dblClick(nPos)
//Local aArea := GetArea()

	If aNotas[nPos,MARCA]=="1"
		aNotas[nPos,MARCA]:="2"
	ElseIf aNotas[nPos,MARCA]=="2"
		aNotas[nPos,MARCA]:="1"
	Endif

	oNotas:Refresh()
	oTelNotas:Refresh()
Return .t.

/*
???????????????????????????????????????
??uncao    ?DblClick?Autor ?Luiz Alberto        ?Data ?06/12/11 ??
???????????????????????????????????????
??escricao ?Funcao Responsavel pelo Double Click Tela Rotas ??
??         |                                             ??
???????????????????????????????????????
*/
Static Function MarcaTodas()
	//Local aArea := GetArea()
	Local nPos

	ProcRegua(Len(aNotas))
	For nPos := 1 To Len(aNotas)
		IncProc("Processando Nota " + aNotas[nPos,NOTA]+"...")

		aNotas[nPos,MARCA]:="1"
	Next

	oNotas:Refresh()
	oTelNotas:Refresh()
Return .t.

/*
???????????????????????????????????????
??uncao    ?DblClick?Autor ?Luiz Alberto        ?Data ?06/12/11 ??
???????????????????????????????????????
??escricao ?Funcao Responsavel pelo Double Click Tela Rotas ??
??         |                                             ??
???????????????????????????????????????
*/
Static Function DesMarcaTodas()
	//Local aArea := GetArea()
	Local nPos

	ProcRegua(Len(aNotas))
	For nPos := 1 To Len(aNotas)
		IncProc("Processando Nota " + aNotas[nPos,NOTA]+"...")

		aNotas[nPos,MARCA]:="2"
	Next

	oNotas:Refresh()
	oTelNotas:Refresh()
Return .t.

//------------------------------------------------------------------------
Static Function ValidaPerg()
	Local aPerg := {}
	Local i := 0

	// aPerg[n,01] := SX1->X1_GRUPO
	// aPerg[n,02] := SX1->X1_ORDEM
	// aPerg[n,03] := SX1->X1_PERGUNT
	// aPerg[n,04] := SX1->X1_VARIAVL
	// aPerg[n,05] := SX1->X1_TIPO
	// aPerg[n,06] := SX1->X1_TAMANHO
	// aPerg[n,07] := SX1->X1_DECIMAL
	// aPerg[n,08] := SX1->X1_PRESEL
	// aPerg[n,09] := SX1->X1_GSC
	// aPerg[n,10] := SX1->X1_VALID
	// aPerg[n,11] := SX1->X1_VAR01
	// aPerg[n,12] := SX1->X1_DEF01
	// aPerg[n,13] := SX1->X1_DEF02
	// aPerg[n,14] := SX1->X1_F3

	AADD(aPerg, {cPerg, "01", "Empresa            ?", "Mv_chA", "C", 04, 0, 0, "G", "", "mv_par01", "", "", "SM0", ""})
	AADD(aPerg, {cPerg, "02", "Nota Fiscal De     ?", "Mv_chB", "C", 09, 0, 0, "G", "", "mv_par02", "", "", "SF2", ""})
	AADD(aPerg, {cPerg, "03", "Nota Fiscal Ate    ?", "Mv_chC", "C", 09, 0, 0, "G", "", "mv_par03", "", "", "SF2", ""})
	AADD(aPerg, {cPerg, "04", "Emissao De         ?", "Mv_chD", "D", 08, 0, 0, "G", "", "mv_par04", "", "", "", ""})
	AADD(aPerg, {cPerg, "05", "Emissao Ate        ?", "Mv_chE", "D", 08, 0, 0, "G", "", "mv_par05", "", "", "", ""})
	AADD(aPerg, {cPerg, "06", "Ambiente Correios  ?", "Mv_chF", "N", 01, 0, 0, "C", "", "mv_par06", "Homologa็ใo", "Produ็ใo", "", ""})
	AADD(aPerg, {cPerg, "07", "Pasta Arq.Impressใo?", "Mv_chG", "C", 25, 0, 0, "G", "", "mv_par07", "", "", "", ""})
	AADD(aPerg, {cPerg, "08", "Acesso             ?", "Mv_chH", "C", 01, 0, 0, "C", "", "mv_par08", "Biocosmeti(Ant)", "Look Log", "", ""})

	For i := 1 To Len(aPerg)
		DbSelectArea("SX1")
		DbSetOrder(1)
		DbSeek(cPerg + aPerg[i,2],.t.)
		If ! DbSeek(cPerg + aPerg[i,2],.t.)
			Reclock("SX1",.t.)
			SX1->X1_GRUPO   := cPerg
			SX1->X1_ORDEM   := aPerg[i,2]
			SX1->X1_PERGUNT := aPerg[i,3]
			SX1->X1_VARIAVL := aPerg[i,4]
			SX1->X1_TIPO    := aPerg[i,5]
			SX1->X1_TAMANHO := aPerg[i,6]
			SX1->X1_DECIMAL := aPerg[i,7]
			SX1->X1_PRESEL  := aPerg[i,8]
			SX1->X1_GSC     := aPerg[i,9]
			SX1->X1_VALID   := aPerg[i,10]
			SX1->X1_VAR01   := aPerg[i,11]
			SX1->X1_DEF01   := aPerg[i,12]
			SX1->X1_DEF02   := aPerg[i,13]
			SX1->X1_F3      := aPerg[i,14]
			SX1->X1_DEF03   := aPerg[i,15]
		endif
		SX1->(MsUnlock())
	Next i

Return(.T.)
