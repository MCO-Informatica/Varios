#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "FILEIO.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัอออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณEXPXMLIMCD บAutor  ณJunior Carvalho    บ Data ณ 05/04/2018  บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯอออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina para listar se ja foi feito o envio da nota e esta   บฑฑ
ฑฑบ          ณesta autorizado o disparo da XML para a TRansportadora      บฑฑ
ฑฑบ          ณ WEBCOL                                                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ P12                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function EXPXMLIMCD()
Local cQuery := ""
Local nHdlSemaf := 0
Private cAliasNF := GetNextAlias()

RpcSetType(3)// Nใo consome licensa de uso
RPCSetEnv('01','02')

cSemaf := "EXPXMLIMCD"+cFilAnt

If !U_SemafWKF(cSemaf, @nHdlSemaf, .T.)
	cMsg :=  ("A rotina EXPXMLIMCD do WEBCOL ja esta sendo executada por outra Thread. Execucao interrompida.")
	FWLogMsg("INFO", "", "BusinessObject", "EXPXMLIMCD" , "", "", cMsg, 0, 0)
	Return()
EndIf

cMsg :=  ("ENTREI NA EXPXMLIMCD  - "+dtoc(date())+" "+time())
FWLogMsg("INFO", "", "BusinessObject", "EXPXMLIMCD" , "", "", cMsg, 0, 0)

cQuery := " SELECT DISTINCT F2_FILIAL, F2_DOC, F2_SERIE, F2_CLIENTE, F2_LOJA,F2_TRANSP,F2_CHVNFE, SF2.R_E_C_N_O_ SF2RECNO, "
cQuery += " A1_FILIAL, A1_COD, A1_LOJA, A1_NOME, A1_CGC, F3_ENTRADA, F3_NFISCAL, F3_SERIE, F3_CLIEFOR, "
cQuery += " F3_LOJA, F3_CFO,SF3.F3_CODRET,SF3.F3_CODRSEF,SF3.F3_DTCANC, SF3.F3_OBSERV, F3_PROTOC, SF3.R_E_C_N_O_ SF3RECNO "
cQuery += " FROM "+RETSQLNAME("SF2") +" SF2, "+RETSQLNAME("SA1") +" SA1, "+RETSQLNAME("SF3") +" SF3 "
cQuery += " WHERE SF3.F3_LOJA = SF2.F2_LOJA "
cQuery += " AND SF3.F3_CLIEFOR = SF2.F2_CLIENTE "
cQuery += " AND SF3.F3_SERIE = SF2.F2_SERIE "
cQuery += " AND SF3.F3_FILIAL = F2_FILIAL "
cQuery += " AND SF3.F3_NFISCAL = SF2.F2_DOC "
cQuery += " AND SF3.D_E_L_E_T_ <> '*'  "
cQuery += " AND A1_COD||A1_LOJA = F2_CLIENTE||F2_LOJA  "
cQuery += " AND SA1.D_E_L_E_T_ <> '*'  "
cQuery += " AND F2_TIPO NOT IN ( 'D','B')  "
cQuery += " AND F2_NFELETR = '  '  "
cQuery += " AND F2_XENVXML = ' ' "
cQuery += " AND F2_EMISSAO  >= '20190101'  "
cQuery += " AND F2_FIMP = 'S'  "
cQuery += " AND F2_DAUTNFE <> ' '  "
cQuery += " AND F2_ESPECIE = 'SPED'  "
cQuery += " AND F2_FILIAL = '"+xFilial("SF2")+"' "
cQuery += " AND SF2.D_E_L_E_T_ <> '*' "
//cQuery += " AND F2_DOC IN ( '000186897') "

cQuery += " UNION ALL "
// NOTAS CANCELADAS
cQuery += " SELECT DISTINCT F2_FILIAL, F2_DOC, F2_SERIE, F2_CLIENTE, F2_LOJA,F2_TRANSP,F2_CHVNFE, SF2.R_E_C_N_O_ SF2RECNO, "
cQuery += "  A1_FILIAL, A1_COD, A1_LOJA, A1_NOME, A1_CGC, F3_ENTRADA ,F3_NFISCAL, F3_SERIE, F3_CLIEFOR, "
cQuery += " F3_LOJA, F3_CFO,SF3.F3_CODRET,SF3.F3_CODRSEF,SF3.F3_DTCANC, SF3.F3_OBSERV, F3_PROTOC, SF3.R_E_C_N_O_ SF3RECNO "
cQuery += " FROM "+RETSQLNAME("SF3") +" SF3, " +RETSQLNAME("SF2") +" SF2, "+RETSQLNAME("SA1") +" SA1 "
cQuery += " WHERE F2_FILIAL||F2_DOC||F2_SERIE||F2_CLIENTE||F2_LOJA = F3_FILIAL||SF3.F3_NFISCAL||F3_SERIE||F3_CLIEFOR||F3_LOJA "
cQuery += " AND F2_TIPO NOT IN ( 'D','B')  "
cQuery += " AND A1_COD||A1_LOJA = F2_CLIENTE||F2_LOJA AND SA1.D_E_L_E_T_ <> '*' "
cQuery += " AND F3_OBSERV = 'NF CANCELADA' "
cQuery += " AND F3_EMISSAO > '20190101' "
cQuery += " AND F3_CHVNFE <> ' ' "
cQuery += " AND F3_ESPECIE = 'SPED' "
cQuery += " AND F3_XENVXML = ' ' "
cQuery += " AND F3_FILIAL = '"+xFilial("SF2")+"' "
cQuery += " AND SF3.D_E_L_E_T_ <> '*' "
//cQuery += " AND F2_DOC = 'zz000186897' "
cQuery += " ORDER BY 1,2 "

cQuery := ChangeQuery( cQuery )
IIF(SELECT(cAliasNF)>0,(cAliasNF)->(DBCLOSEAREA()),NIL)

DbUseArea(.T., "TOPCONN", TcGenQry(,,cQuery),  cAliasNF , .T., .T.)

TCSetField(cAliasNF, "F3_ENTRADA", "D",08,0 )

WHILE (cAliasNF)->(!EOF())
	GERARXML()
	(cAliasNF)->(DBSKIP())
ENDDO

IIF(SELECT(cAliasNF)>0,(cAliasNF)->(DBCLOSEAREA()),NIL)

RPCCLEARENV()

// Encerra controle de semaforo
U_SemafWKF(cSemaf, @nHdlSemaf, .F.)

cMsg :=  ("FINALIZADA EXPXMLIMCD - "+dtoc(date())+" "+time() )
FWLogMsg("INFO", "", "BusinessObject", "EXPXMLIMCD" , "", "", cMsg, 0, 0)
Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGERARXML  บAutor  ณJunior Carvalho     บ Data ณ 05/04/2018  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRoda o relatorio para salvar em PDF e depois dispara por e- บฑฑ
ฑฑบ          ณmail e depois salva na base com 64bits                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ p11 e p12                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GERARXML()
Local cIdEnt := RetIdEnti()
Local aArea     := GetArea()
Local lExistNfe := .T.

Private cAnexoXml := ""
Private nConsNeg := 0.4 // Constante para concertar o cแlculo retornado pelo GetTextWidth para fontes em negrito.
Private nConsTex := 0.5 // Constante para concertar o cแlculo retornado pelo GetTextWidth.
Private oDanfe
Private cDirDest := '\IMPNFE\'
Private lAdjustToLegacy := .F.
Private lDisableSetup  := .T.
Private lNFCanc :=  .F.
private nStart  := seconds()

MAKEDIR(cDirDest)

IF lExistNfe
	
	cSerie := (cAliasNF)->F2_SERIE
	cNota := (cAliasNF)->F2_DOC
	dDTIni := (cAliasNF)->F3_ENTRADA-60
	dDTFim := (cAliasNF)->F3_ENTRADA+60
	
	cMsg :=  ("EXPXMLIMCD - IMCD "+cNota+" - "+dtoc(date())+" "+time())
	FWLogMsg("INFO", "", "BusinessObject", "EXPXMLIMCD" , "", "", cMsg, 0, 0)
	
	lRet := .F.
	nTipo := 1
	
	Processa({|lEnd| U_SpedPExp(cIdEnt,cSerie,cNota,cNota,cDirDest,lRet,dDTIni,dDTFim,' ','zzzz',nTipo,,cSerie)},"Processando","Aguarde, exportando arquivos",.F.)

	IF lRet 
		FWLogMsg("INFO", "", "BusinessObject", "EXPXMLIMCD" , "", "", "Gerando xml nota "+cNota, 0, 0)
		cPara			:= AllTrim(SuperGetMv("ES_EXPXMLE",,"")) //ALLTRIM((cAliasNF)->EMAIL)
		
		cAssunto		:= IIF("NF CANCELADA" $ (cAliasNF)->F3_OBSERV,"CANCELAMENTO ","EMISSAO ")+"NFE NACIONAL"
		cAssunto		+= "Emissor: IMCD - Numero/Serie: "+(cAliasNF)->F2_DOC+"/"+(cAliasNF)->F2_SERIE
		cMensagem		:= CORPOEMAIL()
		
		lEnviou := DISPARAMAIL( cPara, cAssunto, cMensagem, cAnexoXml )
		ferase(cAnexoXml)
		
		if lEnviou
			cMsg :=  ("EXPXMLIMCD - EMAIL ENVIADO - NOTA "+cNota+" - "+dtoc(date())+" "+time())
			FWLogMsg("INFO", "", "BusinessObject", "EXPXMLIMCD" , "", "", cMsg, 0, 0)

			if (!lNFCanc)
				cQryUpd := " UPDATE " + RetSqlName("SF2")
				cQryUpd += " SET F2_XENVXML = '"+dtos(DDATABASE)+"' "
				cQryUpd += " WHERE R_E_C_N_O_  = " +STR((cAliasNF)->SF2RECNO)+" "
				TCSqlExec( cQryUpd )
				SF2->( dbCommit() )

			else
				cQryUpd := " UPDATE " + RetSqlName("SF3")
				cQryUpd += " SET F3_XENVXML = '"+dtos(DDATABASE)+"' "
				cQryUpd += " WHERE R_E_C_N_O_  = " +STR((cAliasNF)->SF3RECNO)
				TCSqlExec( cQryUpd )
				SF3->( dbCommit() )

			endif
			
		endif
	ELSE
		cMsg := ("EXPXMLIMCD - ARQUIVO NรO GERADO - NOTA"+cNota+" - "+dtoc(date())+" "+time())
		FWLogMsg("INFO", "", "BusinessObject", FunName() , "", "01", cMsg, 0, 0)	
		FwLogMsg("INFO", /*cTransactionId*/, "REST", FunName(), "", "01", "JSON successfully parsed to Object", 0, (nStart - Seconds()), {}) // nStart ้ declarada no inicio da fun็ใo

	ENDIF
ENDIF

FreeObj(oDanfe)
oDanfe := Nil
RestArea(aArea)
Return(.T.)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDISPARAMAILบAutor ณJunior Carvalho     บ Data ณ 05/04/2018  บฑฑ
ฑฑฬออออออออออุอออออออออออสออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณROTINA PARA DISPARAR E-MAIL COM O Danfe                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ P11                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
STATIC FUNCTION DISPARAMAIL( cGet1, cGet2, cGet3, cAnexoXml )
Local lResulConn := .T.
Local lResulSend := .T.
Local lResult := .T.
Local cError := ""
Local cServer :=  AllTrim(GetMV("MV_RELSERV"))     //'192.168.182.9' //
Local cEmail := AllTrim(GetMV("MV_RELACNT"))
Local cPass := AllTrim(GetMV("MV_RELPSW"))
Local lRelauth := GetMv("MV_RELAUTH")
Local cDe := alltrim(cEmail)
Local cPara := alltrim(cGet1)
Local cCc := " "
Local cBcc :=  AllTrim(SuperGetMv("ES_EXPXMLA",,"")) //  "JUNIORGARDEL@GMAIL.COM "                //
Local cAssunto := alltrim(cGet2)
Local cMsg := strtran(cGet3,CRLF,'<br>')
Local nForq := 0

//CONNECT SMTP SERVER cServer ACCOUNT cEmail PASSWORD cPass RESULT lResulConn
lResulConn := MailSmtpOn( cServer, cEmail, cPass)
If !lResulConn
	//GET MAIL ERROR cError
	cError := MailGetErr()
	cMsg := ("Falha na conexao "+cError)
	FWLogMsg("INFO", "", "BusinessObject", "EXPXMLIMCD" , "", "", cMsg, 0, 0)	
	Return(.F.)
Endif
If lRelauth
	lResult := MailAuth(Alltrim(cEmail), Alltrim(cPass))
	//Se nao conseguiu fazer a Autenticacao usando o E-mail completo, tenta fazer a autenticacao usando apenas o nome de usuario do E-mail
	If !lResult
		nA := At("@",cEmail)
		cUser := If(nA>0,Subs(cEmail,1,nA-1),cEmail)
		lResult := MailAuth(Alltrim(cUser), Alltrim(cPass))
	Endif
Endif
If lResult
	nVolta:= 0
	while at(';',cPara)>0
		nVolta+= 1
		setprvt("cPara"+cvaltochar(nVolta))
		&("cPara"+cvaltochar(nVolta)) := substr(cPara,1,at(';',cPara)-1)
		cPara := substr(cPara,at(';',cPara)+1)
	end
	if at('@',cPara)>0
		nVolta+= 1
		setprvt("cPara"+cvaltochar(nVolta))
		&("cPara"+cvaltochar(nVolta)) := alltrim(cPara)
	endif
	aPara  := {}
	For nForq := 1 to nVolta
		aadd(aPara,&("cPara"+cvaltochar(nForq)))
	next nForq
	lResulSend := MailSend(cDe,aPara,{cCc},{cBcc},cAssunto,cMsg,{cAnexoXml},.T.)
	If !lResulSend
		//GET MAIL ERROR cError
		cError := MailGetErr()
		cMsg := ("Falha no Envio do e-mail " + cError)
		FWLogMsg("INFO", "", "BusinessObject", "EXPXMLIMCD" , "", "", cMsg, 0, 0)	
		
	Endif
Else
	cMsg := ("Falha na autentica็ใo do e-mail:" + cError)
	FWLogMsg("INFO", "", "BusinessObject", "EXPXMLIMCD" , "", "", cMsg, 0, 0)	
Endif
//DISCONNECT SMTP SERVER
MailSmtpOff()
IF lResulSend
	cMsg := ("E-mail enviado com sucesso. Para "+cPara + cError)
	FWLogMsg("INFO", "", "BusinessObject", "EXPXMLIMCD" , "", "", cMsg, 0, 0)	
ENDIF
RETURN lResulSend

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCORPOEMAIL บAutor ณJunior Carvalho     บ Data ณ 05/04/2018  บฑฑ
ฑฑฬออออออออออุอออออออออออสออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณROTINA CORPOEMAIL gera informacoes para o em-mail           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ P11                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function CORPOEMAIL()
Local cMensagem := ' '

cMensagem := '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">'
cMensagem += '<html xmlns="http://www.w3.org/1999/xhtml">'
cMensagem += '<head>'
cMensagem += '<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />'
cMensagem += '<title>NFE Nacional - Emissor: IMCD - N&uacute;mero/Serie'+(cAliasNF)->F2_DOC+"/"+(cAliasNF)->F2_SERIE+'</title>'
cMensagem += '  <style type="text/css"> '
cMensagem += '	<!-- '
cMensagem += '	body {background-color: rgb(37, 64, 97);} '
cMensagem += '	.style1 {font-family: Segoe UI,Verdana, Arial;font-size: 12pt;} '
cMensagem += '	.style2 {font-family: Segoe UI,Verdana, Arial;font-size: 12pt;color: rgb(255,0,0)} '
cMensagem += '	.style3 {font-family: Segoe UI,Verdana, Arial;font-size: 10pt;color: rgb(37,64,97)} '
cMensagem += '	.style4 {font-size: 8pt; color: rgb(37,64,97); font-family: Segoe UI,Verdana, Arial;} '
cMensagem += '	.style5 {font-size: 10pt} '
cMensagem += '	--> '
cMensagem += '  </style>'
cMensagem += '</head>'
cMensagem += '<body>'
cMensagem += '<img src="https://www.imcdgroup.com/sites/default/files/IMCD-Logo-2015_Color_rgb_72dpi_250px.jpg"/>'
cMensagem += '<table style="background-color: rgb(240, 240, 240); width: 800px; text-align: left; margin-left: auto; margin-right: auto;" id="total" border="0" cellpadding="12">'
cMensagem += '  <tbody>'
cMensagem += '    <tr>'
cMensagem += '      <td colspan="2">'
cMensagem += '      <p class="style1">Esta mensagem refere-se ao Nota Fiscal Eletr&ocirc;nica Nacional de N&uacute;mero/Serie '
cMensagem +=  (cAliasNF)->F2_DOC+"/"+(cAliasNF)->F2_SERIE
cMensagem += ' emitida para:</p>'
cMensagem += '      </td>'
cMensagem += '    </tr>'
cMensagem += '    <tr>'
cMensagem += '      <td style="width: 250px; white-space: nowrap;">'
cMensagem += '      <p class="style1">Raz&atilde;o Social:<br /> '
cMensagem += '	  CNPJ:<br />'
cMensagem += '      <br />'
cMensagem += '      </p>'
cMensagem += '      </td>'
cMensagem += '      <td width="326">'
cMensagem += '      <p class="style1"> '+(cAliasNF)->A1_NOME+' <br />'
cMensagem += '	'+ TransForm((cAliasNF)->A1_CGC,"@r 99.999.999/9999-99")+'<br /> '
cMensagem += '      </p>'
cMensagem += '      </td>'
cMensagem += '    </tr>'
cMensagem += '    <tr>'
cMensagem += '      <td colspan="2">'
cMensagem += '      <p class="style1">Para verificar a autoriza&ccedil;&atilde;o da SEFAZ referente &agrave; nota acima mencionada, acesse o site <a href="http://www.NFE.fazenda.gov.br"><span style="text-decoration: underline;">http://www.nfe.fazenda.gov.br</span></a></p>	'
cMensagem += '      </td>'
cMensagem += '    </tr>'
cMensagem += '    <tr>'
cMensagem += '      <td style="white-space: nowrap;">'
cMensagem += '      <p class="style1">Chave de acesso:&nbsp;<br />'
cMensagem += '		Protocolo:<br /></p>'
cMensagem += '      </td>'
cMensagem += '      <td><span class="style1"> '+(cAliasNF)->F2_CHVNFE+' <br />'
cMensagem += '		 '+(cAliasNF)->F3_PROTOC+'  </span></td>'
cMensagem += '    </tr>'
cMensagem += '    <tr>'
cMensagem += '      <td colspan="2">'
cMensagem += '      <p class="style1">Este e-mail foi enviado automaticamente pelo Sistema de Nota Fiscal Eletr๔nico (NF-e) da &nbsp; '
cMensagem +=  PADR(SM0->M0_NOMECOM,30)+'</p>'
cMensagem += '      </td>'
cMensagem += '    </tr>'
cMensagem += '    <tr>'
cMensagem += '      <td colspan="2" class="style4"><span class="style5"><em><span style="text-decoration: underline;">IMCD</span></em><em></em></span></td>'
cMensagem += '    </tr>'
cMensagem += '  </tbody>'
cMensagem += '</table>'
cMensagem += '<p class="style1">&nbsp;</p>'
cMensagem += '</body> '
cMensagem += '</html>'

Return(cMensagem)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSpedPExp   บAutor ณJunior Carvalho     บ Data ณ 05/04/2018  บฑฑ
ฑฑฬออออออออออุอออออออออออสออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณROTINA Buscar os XML nas Tabelas                            บฑฑ
ฑฑบ          ณ FUNวรO PADRรO TOTVS                                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ P11                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
 
USER Function SpedPExp(cIdEnt,cSerie,cNotaIni,cNotaFim,cDirDest,lEnd,dDataDe,dDataAte,cCnpjDIni,cCnpjDFim,nTipo,lCTe,cSerMax)

Local aDeleta  := {}


Local cChvNFe  	:= ""
Local cCNPJDEST := Space(14)
Local cDestino 	:= ""
Local cDrive   	:= ""
Local cIdflush  := cSerie+cNotaIni
Local cModelo  	:= ""
Local cNFes     := ""
Local cPrefixo 	:= ""
Local cURL     	:= PadR(GetNewPar("MV_SPEDURL","http://"),250)
local cAviso    := ""
local cErro     := ""
Local cEventoCTe	:= ""
Local cRetEvento	:= ""
Local cRodapCTe  :=""
local cCabCTe    :=""
Local cIdEven	   := ""

Local lOk      	:= .F.
Local lFlush  	:= .T.
Local lFinal   	:= .F.
Local lUsaColab	:= .F.

Local nHandle  	:= 0
Local nX        := 0
Local nY		:= 0

Local oRetorno
Local oWS
Local oXML

Default cXml		:= ""
Default nTipo	:= 1
Default cNotaIni:=""
Default cNotaFim:=""
Default dDataDe:=CtoD("  /  /  ")
Default dDataAte:=CtoD("  /  /  ")
Default lCTe	:= .T.
Default cSerMax := cSerie

lUsaColab := UsaColaboracao( IIF(lCte,"2","1") )

ProcRegua(Val(cNotaFim)-Val(cNotaIni))

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Corrigi diretorio de destino                                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
SplitPath(cDirDest,@cDrive,@cDestino,"","")
cDestino := cDrive+cDestino
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Inicia processamento                                                   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Do While lFlush
	
	If ( nTipo == 1 .And. !lUsaColab ).Or. nTipo == 3
		oWS:= WSNFeSBRA():New()
		oWS:cUSERTOKEN        := "TOTVS"
		oWS:cID_ENT           := cIdEnt
		oWS:_URL              := AllTrim(cURL)+"/NFeSBRA.apw"
		oWS:cIdInicial        := cIdflush // cNotaIni
		oWS:cIdFinal          := cSerMax+cNotaFim
		oWS:dDataDe           := dDataDe
		oWS:dDataAte          := dDataAte
		oWS:cCNPJDESTInicial  := cCnpjDIni
		oWS:cCNPJDESTFinal    := cCnpjDFim
		oWS:nDiasparaExclusao := 0
		lOk:= oWS:RETORNAFX()
		oRetorno := oWS:oWsRetornaFxResult
		
		If lOk
			ProcRegua(Len(oRetorno:OWSNOTAS:OWSNFES3))
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Exporta as notas                                                       ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			
			For nX := 1 To Len(oRetorno:OWSNOTAS:OWSNFES3)
				oXml    := oRetorno:OWSNOTAS:OWSNFES3[nX]
				oXmlExp := XmlParser(oRetorno:OWSNOTAS:OWSNFES3[nX]:OWSNFE:CXML,"","","")
				cXML	:= ""
				
				If ( oXml:OWSNFECANCELADA <> Nil .And. !Empty(oXml:oWSNFeCancelada:cProtocolo) )
					lNFCanc := .T.
					cChave 	  := oXml:OWSNFECANCELADA:CXML
					If cModelo == "57" .and. cVerCte >='2.00'
						cChaveCc1 := At("<chCTe>",cChave)+7
					else
						cChaveCc1 := At("<chNFe>",cChave)+7
					endif
					cChaveCan := SubStr(cChave,cChaveCc1,44)
					
					oWS:= WSNFeSBRA():New()
					oWS:cUSERTOKEN	:= "TOTVS"
					oWS:cID_ENT		:= cIdEnt
					oWS:_URL		:= AllTrim(cURL)+"/NFeSBRA.apw"
					oWS:cID_EVENTO	:= "110111"
					oWS:cChvInicial	:= cChaveCan
					oWS:cChvFinal	:= cChaveCan
					lOk				:= oWS:NFEEXPORTAEVENTO()
					oRetEvCanc 	:= oWS:oWSNFEEXPORTAEVENTORESULT
					
					
					if lOk
						
						ProcRegua(Len(oRetEvCanc:CSTRING))
						//---------------------------------------------------------------------------
						//| Exporta Cancelamento do Evento da Nf-e                                  |
						//---------------------------------------------------------------------------
						
						For nY := 1 To Len(oRetEvCanc:CSTRING)
							cXml    := SpecCharc(oRetEvCanc:CSTRING[nY])
							oXmlExp := XmlParser(cXml,"_",@cErro,@cAviso)
							If cModelo == "57" .and. cVerCte >='2.00'
								if Type("oXmlExp:_PROCEVENTONFE:_RETEVENTO:_CTERECEPCAOEVENTORESULT:_RETEVENTOCTE:_INFEVENTO:_CHCTE")<>"U"
									cIdEven	:= 'ID'+oXmlExp:_PROCEVENTONFE:_RETEVENTO:_CTERECEPCAOEVENTORESULT:_RETEVENTOCTE:_INFEVENTO:_CHCTE:TEXT
								elseIf Type("oXmlExp:_PROCEVENTONFE:_RETEVENTO:_RETEVENTOCTE:_INFEVENTO:_CHCTE")<>"U"
									cIdEven	:= 'ID'+oXmlExp:_PROCEVENTONFE:_RETEVENTO:_RETEVENTOCTE:_INFEVENTO:_CHCTE:TEXT
								endif
								
								If (Type("oXmlExp:_PROCEVENTONFE:_EVENTO:_EVENTOCTE")<>"U") .and. (Type("oXmlExp:_PROCEVENTONFE:_RETEVENTO:_CTERECEPCAOEVENTORESULT:_RETEVENTOCTE")<>"U")
									cCabCTe   := '<procEventoCTe xmlns="http://www.portalfiscal.inf.br/cte" versao="'+cVerCte+'">'
									cEventoCTe:= XmlSaveStr(oXmlExp:_PROCEVENTONFE:_EVENTO:_EVENTOCTE,.F.)
									cRetEvento:= XmlSaveStr(oXmlExp:_PROCEVENTONFE:_RETEVENTO:_CTERECEPCAOEVENTORESULT:_RETEVENTOCTE,.F.)
									cRodapCTe := '</procEventoCTe>'
									CxML:= cCabCTe+cEventoCTe+cRetEvento+cRodapCTe
								ElseIf (Type("oXmlExp:_PROCEVENTONFE:_EVENTO:_EVENTOCTE")<>"U") .and. (Type("oXmlExp:_PROCEVENTONFE:_RETEVENTO:_RETEVENTOCTE:_INFEVENTO")<>"U")
									cCabCTe   := '<procEventoCTe xmlns="http://www.portalfiscal.inf.br/cte" versao="'+cVerCte+'">'
									cEventoCTe:= XmlSaveStr(oXmlExp:_PROCEVENTONFE:_EVENTO:_EVENTOCTE,.F.)
									cRetEvento:= XmlSaveStr(oXmlExp:_PROCEVENTONFE:_RETEVENTO:_RETEVENTOCTE,.F.)
									cRodapCTe := '</procEventoCTe>'
									CxML:= cCabCTe+cEventoCTe+cRetEvento+cRodapCTe
								EndIf
								
							else
								if Type("oXmlExp:_PROCEVENTONFE:_EVENTO:_ENVEVENTO:_EVENTO:_INFEVENTO:_ID")<>"U"
									cIdEven	:= oXmlExp:_PROCEVENTONFE:_EVENTO:_ENVEVENTO:_EVENTO:_INFEVENTO:_ID:TEXT
								else
									cIdEven  := oXmlExp:_PROCEVENTONFE:_EVENTO:_INFEVENTO:_ID:TEXT
								endif
							endif
							
							cAnexoXml := cDestino+SubStr(cIdEven,3)+"-Canc.xml"
							nHandle := FCreate(cAnexoXml)
							if nHandle > 0
								FWrite(nHandle,AllTrim(cXml))
								FClose(nHandle)
								LRET := .T.
							endIf
						Next nY
					EndIf
				ELSE
					If Type("oXmlExp:_NFE:_INFNFE:_DEST:_CNPJ")<>"U"
						cCNPJDEST := AllTrim(oXmlExp:_NFE:_INFNFE:_DEST:_CNPJ:TEXT)
					ElseIF Type("oXmlExp:_NFE:_INFNFE:_DEST:_CPF")<>"U"
						cCNPJDEST := AllTrim(oXmlExp:_NFE:_INFNFE:_DEST:_CPF:TEXT)
					Else
						cCNPJDEST := ""
					EndIf
					cVerNfe := IIf(Type("oXmlExp:_NFE:_INFNFE:_VERSAO:TEXT") <> "U", oXmlExp:_NFE:_INFNFE:_VERSAO:TEXT, '')
					cVerCte := Iif(Type("oXmlExp:_CTE:_INFCTE:_VERSAO:TEXT") <> "U", oXmlExp:_CTE:_INFCTE:_VERSAO:TEXT, '')
					If !Empty(oXml:oWSNFe:cProtocolo)
						cNotaIni := oXml:cID
						cIdflush := cNotaIni
						cNFes := cNFes+cNotaIni+CRLF
						cChvNFe  := NfeIdSPED(oXml:oWSNFe:cXML,"Id")
						cModelo := cChvNFe
						cModelo := StrTran(cModelo,"NFe","")
						cModelo := StrTran(cModelo,"CTe","")
						cModelo := SubStr(cModelo,21,02)
						
						Do Case
							Case cModelo == "57"
								cPrefixo := "CTe"
							Case cModelo == "65"
								cPrefixo := "NFCe"
							OtherWise
								if '<cStat>301</cStat>' $ oXml:oWSNFe:cxmlPROT .or. '<cStat>302</cStat>' $ oXml:oWSNFe:cxmlPROT
									cPrefixo := "den"
								else
									cPrefixo := "NFe"
								endif
						EndCase
						cAnexoXml :=  (cDestino+SubStr(cChvNFe,4,44)+"-"+cPrefixo+".xml")
						nHandle := FCreate(cAnexoXml)
						If nHandle > 0
							cCab1 := '<?xml version="1.0" encoding="UTF-8"?>'
							If cModelo == "57"
								//cCab1  += '<cteProc xmlns="http://www.portalfiscal.inf.br/cte" xmlns:ds="http://www.w3.org/2000/09/xmldsig#" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.portalfiscal.inf.br/cte procCTe_v'+cVerCte+'.xsd" versao="'+cVerCte+'">'
								cCab1  += '<cteProc xmlns="http://www.portalfiscal.inf.br/cte" versao="'+cVerCte+'">'
								cRodap := '</cteProc>'
							Else
								Do Case
									Case cVerNfe <= "1.07"
										cCab1 += '<nfeProc xmlns="http://www.portalfiscal.inf.br/nfe" xmlns:ds="http://www.w3.org/2000/09/xmldsig#" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.portalfiscal.inf.br/nfe procNFe_v1.00.xsd" versao="1.00">'
									Case cVerNfe >= "2.00" .And. "cancNFe" $ oXml:oWSNFe:cXML
										cCab1 += '<procCancNFe xmlns="http://www.portalfiscal.inf.br/nfe" versao="' + cVerNfe + '">'
									OtherWise
										cCab1 += '<nfeProc xmlns="http://www.portalfiscal.inf.br/nfe" versao="' + cVerNfe + '">'
								EndCase
								cRodap := '</nfeProc>'
							EndIf
							FWrite(nHandle,AllTrim(cCab1))
							FWrite(nHandle,AllTrim(oXml:oWSNFe:cXML))
							FWrite(nHandle,AllTrim(oXml:oWSNFe:cXMLPROT))
							FWrite(nHandle,AllTrim(cRodap))
							FClose(nHandle)
							aadd(aDeleta,oXml:cID)
							
							cXML := AllTrim(cCab1)
							cXML += AllTrim(oXml:oWSNFe:cXML)
							cXML += AllTrim(oXml:oWSNFe:cXMLPROT)
							cXML += AllTrim(cRodap)
							
							LRET := .T.
						EndIf
					EndIf
				EndIf
				IncProc()
			Next nX
			
		Else
			Aviso("SPED",IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3))+CRLF+"STR0046",{"OK"},3)
			lFinal := .T.
		EndIf
	EndIF
	
	lFlush := .F.
	
EndDo

Return(.T.)

Static Function SpecCharc(cTexto)

Local nI		:= 0
Local aCarac 	:= {}

Aadd(aCarac,{"ม","A"})
Aadd(aCarac,{"ภ","A"})
Aadd(aCarac,{"ย","A"})
Aadd(aCarac,{"ร","A"})
Aadd(aCarac,{"แ","a"})
Aadd(aCarac,{"เ","a"})
Aadd(aCarac,{"โ","a"})
Aadd(aCarac,{"ใ","a"})
Aadd(aCarac,{"ษ","E"})
Aadd(aCarac,{"ส","E"})
Aadd(aCarac,{"้","e"})
Aadd(aCarac,{"๊","e"})
Aadd(aCarac,{"อ","I"})
Aadd(aCarac,{"ํ","i"})
Aadd(aCarac,{"ำ","O"})
Aadd(aCarac,{"ิ","O"})
Aadd(aCarac,{"ี","O"})
Aadd(aCarac,{"๓","o"})
Aadd(aCarac,{"๔","o"})
Aadd(aCarac,{"๕","o"})
Aadd(aCarac,{"ฺ","U"})
Aadd(aCarac,{"๚","u"})
Aadd(aCarac,{"ว","C"})
Aadd(aCarac,{"็","c"})

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


User Function SemafWKF(cRotina, nHdlSemaf, lCria)

Local lRET := .T.
Local cArq := "\semaforo\"+cRotina+".LCK"
Default nHdlSemaf := 0
Default lCria     := .T.

If lCria
	nHdlSemaf := MSFCreate(cArq)
	IF nHdlSemaf < 0
		lRet := .F.
	Endif
Else
	If File(cArq)
		FClose(nHdlSemaf)
		lRET := .T.
	EndIf
EndIf

Return lRET                  

If !LockByName("NOME_DA_SUA_ROTINA",.F.,.F.,.T.)
    MsgAlert("Rotina estแ sendo executada por outro usuแrio.")
    Return
EndIf
//https://tdn.totvs.com/pages/releaseview.action?pageId=6814894
//https://tdn.totvs.com/pages/releaseview.action?pageId=6814897

UnLockByName("NOME_DA_SUA_ROTINA",.F.,.F.,.T.)
