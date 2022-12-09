#include "Protheus.ch"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "Ap5Mail.ch"
#Include 'TBICONN.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณIMCDENVNFE  บAutor  ณJunior Carvalho   บ Data ณ  02/26/14   บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina para listar se ja foi feito o envio da nota e esta   บฑฑ
ฑฑบ          ณesta autorizado o disparo da DANFE para o cliente           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ p12 e p11                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function IMCDENVNFE(cEmpProc, cFilProc)
	Local aVetor := {}
	Local nX := 0
    default cEmpProc := ""
    default cFilProc := ""

    if empty(cEmpProc )
	    cEmpProc := "02"
    	cFilProc := "02"
	    //aAdd(aVetor,{"02","01"})
	    aAdd(aVetor,{"02","02"})
    else
        aAdd(aVetor,{cEmpProc,cFilProc})
    endif

    
	RpcSetType(3)// Nใo consome licensa de uso
	RpcSetEnv(cEmpProc,cFilProc,,,'FAT','IMCDENVNFE')
    
	    for nX := 1 To Len(aVetor)
    
	      dbCloseAll()
          cEmpAnt := aVetor[nX,1]
          cFilAnt := aVetor[nX,2]
          cNumEmp := cEmpAnt+cFilAnt
          cModulo := "FAT"
          nModulo := 5
          OpenSM0(cEmpAnt+cFilAnt)
          OpenFile(cEmpAnt+cFilAnt)
    
	    IMCDENVX()
    
	    Next nX

RPCCLEARENV()

Return()

Static Function IMCDENVX()

	Local cQuery := ""
	Local nHdlSemaf := 0
	Private cAliasNF := ""
	Private cIdEnt := RetIdEnti()

	DBSELECTAREA("ZF1")
	
	cMsg := "ENTREI NA IMCDENVNFE  - "+dtoc(date())+" "+time()
	FWLogMsg("INFO", "", "BusinessObject", "IMCDENVNFE", "", "", cMsg, 0, 0)

	cSemaf := "IMCDENVNFE"+cEmpAnt+cFilAnt

	If !U_SemafWKF(cSemaf, @nHdlSemaf, .T.)
		cMsg :=  ("A rotina IMCDENVNFE ja esta sendo executada por outra Thread. Execucao interrompida.")
		FWLogMsg("INFO", "", "BusinessObject", "IMCDENVNFE", "", "", cMsg, 0, 0)
		Return
	EndIf

	cAliasNF := GetNextAlias()


	cQuery := "	SELECT DISTINCT ZF1.*, DOC_CHV , ZF1_CLIFOR, ZF1_LOJA  "
	cQuery += " FROM "+RETSQLNAME("ZF1") +" ZF1 ,  SPED050  NFE "
	cQuery += " WHERE ZF1_SERIE || ZF1_DOC = NFE_ID "
	cQuery += " AND ID_ENT = '"+cIdEnt+"' "
	cQuery += " AND  NFE.D_E_L_E_T_ <> '*' "
	cQuery += " AND ZF1_DATA = ' ' "
	cQuery += " AND ZF1.D_E_L_E_T_ <> '*' "
	cQuery += " AND ZF1_FILIAL = '"+xfilial("ZF1")+"'"
	cQuery += " AND STATUSCANC =  0  "
	cQuery += " AND STATUS = 6 "
	cQuery += " ORDER BY ZF1_DOC,ZF1_TIPO "

	cQuery := ChangeQuery( cQuery )
	IIF(SELECT(cAliasNF)>0,(cAliasNF)->(DBCLOSEAREA()),NIL)

	DbUseArea(.T., "TOPCONN", TcGenQry(,,cQuery),  cAliasNF , .T., .T.)

	TCSetField(cAliasNF, "ZF1_DATA", "D",08,0 )

	WHILE (cAliasNF)->(!EOF())
		ENVNFE()
		(cAliasNF)->(DBSKIP())
	ENDDO

	IIF(SELECT(cAliasNF)>0,(cAliasNF)->(DBCLOSEAREA()),NIL)

// Encerra controle de semaforo
	U_SemafWKF(cSemaf, @nHdlSemaf, .F.)

	cMsg :=  ("FINALIZADA IMCDENVNFE - "+dtoc(date())+" "+time() )
	FWLogMsg("INFO", "", "BusinessObject", "IMCDENVNFE", "", "", cMsg, 0, 0)

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ ENVNFE     บAutor  ณJunior Carvalho   บ Data ณ  02/26/14   บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina para listar se ja foi feito o envio da nota e esta   บฑฑ
ฑฑบ          ณesta autorizado o disparo da DANFE para o cliente           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ p12 e p11                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ENVNFE()
	Local cIdEnt := RetIdEnti()
	Local aArea     := GetArea()
	Local lExistNfe := .F.
	Local cFilePrint := ""
	Local aAttach := {}
	Local oSetup		:= Nil

	Private oDANFE
	Private cDirDest := "\danfe\" //'E:\TOTVS\Microsiga\Protheus_Data\danfe\'
	Private lAdjustToLegacy := .F.
	Private lDisableSetup  := .T.
	Private cDocJob := (cAliasNF)->ZF1_DOC
	Private cSerieJob := (cAliasNF)->ZF1_SERIE
	Private cTipo := (cAliasNF)->ZF1_TIPO
	Private cEmail := ""
	CALIAS :=  iif( cTipo = 'E',"SF1","SF2")

	DbSelectArea(CALIAS)
	(CALIAS)->( DbSetOrder(1) )	//F2_FILIAL + F2_DOC + F2_SERIE + F2_CLIENTE + F2_LOJA
	If (CALIAS)->( DbSeek(  (cAliasNF)->ZF1_FILIAL +  (cAliasNF)->ZF1_DOC + (cAliasNF)->ZF1_SERIE + (cAliasNF)->ZF1_CLIFOR + (cAliasNF)->ZF1_LOJA) )

		IF EMPTY( (cAliasNF)->DOC_CHV)
			cFilePrint	:= "DANFE_"+cIdEnt+Dtos(MSDate())+StrTran(Time(),":","")+'.pdf'
			//	cAnexoXML	:= cIdEnt+Dtos(MSDate())+StrTran(Time(),":","")+'.xml'
		ELSE
			cFilePrint	:= "DANFE_"+(cAliasNF)->DOC_CHV+".PDF"
			//	cAnexoXML	:= (cAliasNF)->DOC_CHV+".xml"
		ENDIF

		MAKEDIR(cDirDest)

		oDanfe:=FWMSPrinter():New(cFilePrint, IMP_PDF, lAdjustToLegacy, cDirDest , lDisableSetup ,, @oDanfe,,,,,.F.)

		oDANFE:SetCopies( 1 )

		oDanfe:SetResolution(78) // Tamanho estipulado para a Danfe
		oDanfe:SetLandscape()
		oDanfe:SetPaperSize(DMPAPER_A4)

		oDanfe:SetMargin(30,30,30,30)
		oDanfe:cPathPDF := cDirDest
		oDanfe:lServer := .T.
		oDanfe:nDevice := IMP_PDF
		oDanfe:lViewPDF := .F.

		lJob := .T.
		lIsLoja := .F.
		lAutomato := .F.
		nEntSai :=  iif( cTipo = 'E',1,2)

		//PROCESSA( { |lEnd| U_DANFE_P1(	cIdEnt,/*cVal1*/,/*cVal2*/, @oDanfe, oSetup ,lIsLoja ,.F.,@lExistNFe,lJob, nEntSai) },"Imprimindo DANFE..." )

	    Pergunte("NFSIGW",.F.) 
	    MV_PAR01 := (cAliasNF)->ZF1_DOC
	    MV_PAR02 := (cAliasNF)->ZF1_DOC
	    MV_PAR03 := (cAliasNF)->ZF1_SERIE
	    MV_PAR04 := nEntSai	//NF de Saida
	    MV_PAR05 := 1	//Frente e Verso - 1:Sim
	    MV_PAR06 := 2	//DANFE simplificado - 2:Nao
	    MV_PAR07 := ddatabase - 30
	    MV_PAR08 := ddatabase + 30

		lExistNFe :=  U_DANFE_P1(cIDEnt, Nil, Nil, oDANFE, oSetup, lIsLoja ,lAutomato,lJob, nEntSai)

		IF lExistNfe
			oDanfe:Preview()
			Sleep( 5000 )
			xnome := oDanfe:cFilePrint
			ferase(xnome)


			// ROTINA PARA DISPARAR O E-MAIL
			if !EMPTY((cAliasNF)->ZF1_EMAIL)
				cPara			:=  (cAliasNF)->ZF1_EMAIL
				cAssunto		:= "Nota fiscal - Numero/Serie: "+cDocJob+"/"+cSerieJob
			else
				// ROTINA PARA DISPARAR O E-MAIL
				cPara			:=  AllTrim(SuperGetMV("ES_MAILCTR", .F., ""))
				cAssunto		:= "Nota fiscal de Produto controlado - Numero/Serie: "+cDocJob+"/"+cSerieJob
		
			endif

			cMensagem		:= CORPOEMAIL(!empty((cAliasNF)->ZF1_EMAIL))
			cDirDest 		:= "\DANFE\"
	/*
	nHandle := FCreate(cDirDest+cAnexoXml)
			if nHandle > 0
	cXML :=AllTrim(aXml[1][2])
	cVerNfe := substr( cXML ,AT("versao=",cXML)+8,4 )
	cCab1 := '<?xml version="1.0" encoding="UTF-8"?>'
	cCab1 += '<nfeProc xmlns="http://www.portalfiscal.inf.br/nfe" versao="' + cVerNfe + '">'
	
	
	cXML := cCab1 + cXML+'</nfeProc>'
	
	FWrite(nHandle, cXML  )
	FClose(nHandle)
	LRET := .T.
			endIf
	*/
			aAdd(aAttach,cDirDest+cFilePrint)
			//	aAdd(aAttach,cDirDest+cAnexoXML)
			//cPara := "junior.gardel@gmail.com"

			lEnviou := U_ENVMAILIMCD(cPara,/*com Copia*/"",/*copia oculta*/"",cAssunto,cMensagem,aAttach)

			if lEnviou
				U_GravaZF1(cDocJob,cSerieJob,cTipo,"E", , ,cPara)
			endif

			//	ferase(cDirDest+cAnexoXML )
		ENDIF

		ferase(cDirDest+cFilePrint )

	ENDIF

	FreeObj(oDANFE)
	oDanfe := Nil

	RestArea(aArea)

Return(.T.)

Static Function CORPOEMAIL(lNormal)

	Local cMensagem := ' '
	Local aItens := {}
	Local nX := 0

	cMensagem := '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">'
	cMensagem += '<html xmlns="http://www.w3.org/1999/xhtml">'
	cMensagem += '<head>'
	cMensagem += '<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />'
	cMensagem += '<title>'+iif(lNormal, 'Nota Fiscal - ','MOVIMENTAวรO DE PRODUTOS CONTROLADOS NF - ')+cDocJob+"/"+cSerieJob+'</title>'
	cMensagem += '  <style type="text/css"> '
	cMensagem += '	<!-- '
	cMensagem += '	body {background-color: transparent;} '
	cMensagem += '	.style1 {font-family: Segoe UI,Verdana, Arial;font-size: 12pt;} '
	cMensagem += '	.style2 {font-family: Segoe UI,Verdana, Arial;font-size: 12pt;color: rgb(255,0,0)} '
	cMensagem += '	.style3 {font-family: Segoe UI,Verdana, Arial;font-size: 10pt;color: rgb(37,64,97)} '
	cMensagem += '	.style4 {font-size: 8pt; color: rgb(37,64,97); font-family: Segoe UI,Verdana, Arial;} '
	cMensagem += '	.style5 {font-size: 10pt} '
	cMensagem += '	--> '
	cMensagem += '  </style>'
	cMensagem += '</head>'
	cMensagem += '<body>'

	cEmissao := ''
	if  (cAliasNF)->ZF1_TIPO = 'E'

		DbSelectArea("SD1")
		DbSetOrder(1)
		DbSeek(xfilial("SD1") + (cAliasNF)->(ZF1_DOC+ ZF1_SERIE + ZF1_CLIFOR+ ZF1_LOJA) )

		cEmissao := DTOS(SD1->D1_DTDIGIT)
		cEmissao := right(cEmissao,2) + '/' + substr(cEmissao,5,2) + '/'+  left(cEmissao,4)

		While 	SD1->(!EOF()).AND.;
				SD1->D1_DOC 	== (cAliasNF)->ZF1_DOC		.AND.;
				SD1->D1_SERIE	== (cAliasNF)->ZF1_SERIE	.AND.;
				SD1->D1_FORNECE == (cAliasNF)->ZF1_CLIFOR	.AND.;
				SD1->D1_LOJA 	== (cAliasNF)->ZF1_LOJA

			cDescProd := ALLTRIM(POSICIONE("SB1",1,XFILIAL("SB1")+SD1->D1_COD,"B1_DESC"))

			aAdd(aItens,{SD1->D1_COD, cDescProd,SD1->D1_QUANT,SD1->D1_LOCAL})

			SD1->(DbSkip())
		enddo

		cNome := ALLTRIM(POSICIONE("SA2",1,XFILIAL("SA2")+(cAliasNF)->(ZF1_CLIFOR+ZF1_LOJA),"A2_NREDUZ"))
		cMensagem += ' Aten็ใo, <strong>Entrou </strong>no Estoque os Produtos Controlados conforme descrito abaixo:</p><p>'
		cMensagem += ' Data de Entrada : <strong>'+cEmissao+'</strong> - '
		cMensagem += ' Nota Fiscal : <strong>'+(cAliasNF)->ZF1_DOC+' - '+(cAliasNF)->ZF1_SERIE+'</strong> - '
		cMensagem += ' Fornecedor <strong>'+cNome+'</strong></p>'


	else
		dbselectarea("SD2")
		dbsetorder(3)
		DbSeek(xfilial("SD2") + (cAliasNF)->(ZF1_DOC+ ZF1_SERIE + ZF1_CLIFOR+ ZF1_LOJA))

		cEmissao := DTOS( SD2->D2_EMISSAO)
		cEmissao := right(cEmissao,2) + '/' + substr(cEmissao,5,2) + '/'+  left(cEmissao,4)

		While 	SD2->(!EOF()).AND.;
				SD2->D2_DOC 	== (cAliasNF)->ZF1_DOC		.AND.;
				SD2->D2_SERIE	== (cAliasNF)->ZF1_SERIE	.AND.;
				SD2->D2_CLIENTE == (cAliasNF)->ZF1_CLIFOR	.AND.;
				SD2->D2_LOJA 	== (cAliasNF)->ZF1_LOJA

			cDescProd := ALLTRIM(POSICIONE("SB1",1,XFILIAL("SB1")+SD2->D2_COD,"B1_DESC"))

			aAdd(aItens,{SD2->D2_COD, cDescProd,SD2->D2_QUANT,SD2->D2_LOCAL} )

			SD2->(DbSkip())
		enddo

		cNome := ALLTRIM(POSICIONE("SA1",1,XFILIAL("SA1")+(cAliasNF)->(ZF1_CLIFOR+ZF1_LOJA),"A1_NREDUZ"))

		iif(lNormal, "",cMensagem += ' Aten็ใo, <strong>Saiu </strong>do Estoque os Produtos Controlados conforme descrito abaixo:</p><p>')
		cMensagem += ' Data de Saida : <strong>'+cEmissao+'</strong> - '
		cMensagem += ' Nota Fiscal : <strong>'+(cAliasNF)->ZF1_DOC+' - '+(cAliasNF)->ZF1_SERIE+'</strong> - '
		iif(lNormal, "",cMensagem += ' Cliente <strong>'+cNome+'</strong></p>')

	endif

	cMensagem += '<table border="1" cellpadding="1" cellspacing="1" style="width: 800px">'
	cMensagem += '	<thead>'
	cMensagem += '	<tr>'
	cMensagem += '	<th scope="col">Produto</th>'
	cMensagem += '	<th scope="col">Descri็ใo</th>'
	cMensagem += '	<th scope="col">Quantidade</th>'
	cMensagem += '	<th scope="col">Deposito</th>'
	cMensagem += '	</tr>'
	cMensagem += '	</thead>'
	cMensagem += '<tbody>'

	For nX:= 1 To Len(aItens)
		cMensagem += '<tr>'
		cMensagem += '<td>'+aItens[nX,1]+'</td>
		cMensagem += '<td>'+aItens[nX,2]+'</td>
		cMensagem += '<td align="right" >'+TRANSFORM(aItens[nX,3],"@e 9,999,999.99") +'</td>
		cMensagem += '<td align="center" >'+aItens[nX,4]+'</td>
		cMensagem += '</tr>'
	Next nX
	cMensagem += '</tbody>'
	cMensagem += '</table>'

	cMensagem += '<p class="style1">&nbsp;</p>'

	cMensagem += '<font color="blue">'
	cMensagem += '<div style="text-align:right">'
	cMensagem += '<p>PROTHEUS - IMCDENVNFE</p>'
	cMensagem += '</div>'
	cMensagem += '</font>'

	cMensagem += '</body> '

	cMensagem += '</html>'

Return(cMensagem)


User Function GravaZF1(cDoc,cSerie,cTipo,cOper,cCliFor,cLoja,cEmail)
// cTipo E=Entrada / S=Saida
// cOper I=inclusใo / E= Envio Email
	cPara := AllTrim(GetMV("ES_MAILCTR"))
	If !Empty(cDoc)
		DBSELECTAREA("ZF1")
		DBSETORDER(1)
		lRet := DbSeek(xFilial("ZF1")+cDoc+cSerie+cTipo)

		Reclock("ZF1", !lRet)

		If cOper = "I"

			ZF1->ZF1_FILIAL	:= xFilial("ZF1")
			ZF1->ZF1_DOC	:= cDoc
			ZF1->ZF1_SERIE	:= cSerie
			ZF1->ZF1_TIPO 	:= cTipo
			ZF1->ZF1_CLIFOR	:= cCliFor
			ZF1->ZF1_LOJA	:= cLoja
            ZF1->ZF1_EMAIL 	:= cEmail
		Endif
		if  lRet
			if cOper = 'E'

				ZF1->ZF1_EMAIL 	:= cEmail
				ZF1->ZF1_DATA  	:= DDATABASE

			Elseif cOper == 'X'

				ZF1->ZF1_DATA  	:= DDATABASE
				ZF1->ZF1_EMAIL 	:= cPara

				cMensagem := "A Nota " +cDoc+" Serie " +cSerie +" de "+iif(cTipo=="E","Entrada","Saํญda")+", foi Cancelada."

				U_ENVMAILIMCD(cPara,"","","Nota Cancelada - " +cDoc+" " +cSerie,cMensagem, {})

				ZF1->( dbDelete() )
			Endif
		Endif

		ZF1->(MsUnLock())
	EndIf

Return
