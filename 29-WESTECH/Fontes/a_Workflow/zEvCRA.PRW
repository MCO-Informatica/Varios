
#include "rwmake.ch"
#include "topconn.ch"
#Include 'Protheus.ch'
#INCLUDE 'TOPCONN.CH'
#include "ap5mail.ch"
#INCLUDE "TOTVS.CH"


User Function zEvCRA()
    zEvMail()
Return 


Static Function SchedDef()

    Local aOrd      := {}
    Local aParam    := {}

    aParam := { "P" ,;
    "PARAMDEF"      ,;
    ""              ,;
    aOrd            ,;
    } 
    
Return aParam

//Envia E-mail
Static Function zEvMail(cTo, cCc, cAssunto, cMsg, aAnexo)
    local _cQuery := ""
    Local oServer
	Local oMessage
	Local cUsr := GetMv("MV_RELACNT") //Conta de autenticao do email
	Local cPsw := GetMv("MV_RELPSW") //Senha para autenticao no servidor de e-mail
	Local cSrv := GetMv("MV_RELSERV") //Servidor SMTP
	Local lAut := GetMv("MV_RELAUTH") //Servidor SMTP necessite de AUTENTICAÎ—AO para envio de e-mailÂ’s
	Local nPrt := 587
	local nI

	Local cEmail 	:= ""


    Local aMatriz2 		:= {}
	Local aMatriz		:= {}
	Local nI 			:= 0
	Local nI2 			:= 0

	

	Private n1 := 0
	//Local aAnexo := StrTokArr(cAnexo, ";")

	//Cria a conexÎ³o com o server STMP ( Envio de e-mail )
	oServer := TMailManager():New()
	//oServer:SetUseTLS( .T. )
	//O servidor esta com a porta
		

	
	If ":" $ cSrv
		nPrt := Val(Substr(cSrv, At(":",cSrv)+1))
		cSrv := Substr(cSrv, 1 , At(":",cSrv)-1)
	EndIf

	oServer:Init( "", cSrv, cUsr, cPsw, , nPrt )

	//seta um tempo de time out com servidor de 1min
	If oServer:SetSmtpTimeOut( 60 ) != 0
		 MsgAlert( "Falha ao setar o time out", "Email nao enviado!" )
		Return .F.
	EndIf

	//realiza a conexÎ³o SMTP
	If oServer:SmtpConnect() != 0
		 MsgAlert( "Falha ao conectar", "Email nao enviado!" )
		Return .F.
	EndIf

	If lAut
		If oServer:SmtpAuth( cUsr, cPsw ) != 0
			 MsgAlert( "Falha ao autenticar", "Email nao enviado!" )
			Return .F.
		EndIf
	EndIf
	//Apos a conexÎ³o, cria o objeto da mensagem
	oMessage := TMailMessage():New()

	//Limpa o objeto
	oMessage:Clear()

    dbSelectArea("SE1")
    SE1->( dbSetOrder(1))

    //******************* base de dados
    //SC7->(dbsetorder(1)) 
   _cQuery := " SELECT	E1_XXIC , CTD_XIDPM, CTD_XNOMPM, DATEDIFF(day , GETDATE() ,  E1_VENCREA ) AS 'STATUS', E1_NUM, E1_TIPO, E1_NATUREZ, E1_CLIENTE, "
        _cQuery += " 		E1_NOMCLI, CAST(E1_EMISSAO as Date) as 'TMP_EMISSAO', CAST(E1_VENCTO AS DATE) AS 'VENCTO', CAST(E1_VENCREA AS DATE) AS 'VENCREA', "
        _cQuery += " 		IIF(E1_TIPO = 'PA' AND E1_BAIXA <> '', -E1_VALOR, E1_VALOR)  as 'TMP_VALOR', "
        _cQuery += " 		E1_SALDO, "
        _cQuery += " 		E1_HIST, E1_BAIXA "
        _cQuery += " FROM SE1010 "
        _cQuery += " INNER JOIN CTD010 ON SE1010.E1_XXIC=CTD010.CTD_ITEM "
        _cQuery += " WHERE  SE1010.D_E_L_E_T_ <> '*'  AND CTD010.D_E_L_E_T_ <> '*' AND E1_SALDO > 0 AND E1_VENCTO < GETDATE() AND E1_TIPO = 'PR' "
        _cQuery += " AND E1_XXIC NOT IN ('ADMINISTRACAO','PROPOSTA','QUALIDADE','ATIVO','ENGENHARIA','ZZZZZZZZZZZZZ','XXXXXX','ESTOQUE')  "
        _cQuery += " AND E1_XXIC NOT IN  (SELECT E2_XXIC FROM SE2010 WHERE E2_XXIC = ' ') "
        _cQuery += " ORDER BY 2 "

	IF Select("_cQuery") <> 0
		DbSelectArea("_cQuery")
		DbCloseArea()
	ENDIF

	//crio o novo alias
	TCQUERY _cQuery NEW ALIAS "QUERY"

	dbSelectArea("QUERY")
	QUERY->(dbGoTop())


    // matriz com IDs de Coordenadores
    nI := 1
    while QUERY->(!eof()) //for nI=1 to Len( "_cQuery" )
        cXIDPM := QUERY->CTD_XIDPM
        AAdd( aMatriz, cXIDPM ,nI ) // Posicione("CTD",1,xFilial("CTD") +  ALLTRIM(aCols[nI][3]),"CTD_XIDPM")
        if ascan(aMatriz2,aMatriz[nI]) = 0 
            aadd(aMatriz2,aMatriz[nI]) 
        endif
    //cNum := ALLTRIM(aCols[nI][1])	
        nI++
        QUERY->(dbskip())
    enddo//next   

    /*for nI=1 to len(aMatriz2) 
		alert(aMatriz2[nI]+"aaa")
		cMensagem := aMatriz[nI] + chr(13) + chr(10)
	next  */

    QUERY->(dbclosearea())

    for nI=1 to len(aMatriz2) 
        
		cEmail := UsrRetMail(aMatriz2[nI])
        cIdCoord := Alltrim(aMatriz2[nI])

        cMsg:=' <!DOCTYPE html>'
        cMsg+='	<html>'
        cMsg+='	<head>'
        cMsg+='		<meta charset="utf-8">'
        cMsg+='		<title> Westech - Contas a Receber - Provisões em Atraso</title>'
        cMsg+='		<style type="text/css">'
        cMsg+='*{'
        cMsg+='		margin: 0;'
        cMsg+='		padding: 0;'
        cMsg+='		background: #fff;'
        cMsg+='	}'

        cMsg+='	body{'
        cMsg+='		font-family: "Trebuche MS", Helvetica, sans-serif;'
        cMsg+='		background: #f2f2f2;'
        cMsg+='		min-width: 750px;'
        cMsg+='	}'

        cMsg+='	#cabecalho{'
        cMsg+='		background: #008000;'
        cMsg+='		height: 130px;'
        cMsg+='	}'

        cMsg+='	#topo{'
        cMsg+='		width: 90%;'
        cMsg+='		margin: 0 auto;'
        cMsg+='	}'

        cMsg+='	#conteudo{'
        cMsg+='		margin: 0 auto;'
        cMsg+='		margin-top:30px;'
        cMsg+='		width: 80%;'
        cMsg+='	}'

        cMsg+='	#rodape{'
        cMsg+='		padding: 20px;'
        cMsg+='		text-align: center;'
        cMsg+='		background: #008000;'
        cMsg+='		min-width: 750px;'
        cMsg+='		margin-top: 20px;'
        cMsg+='	}'

        cMsg+='	#rodape h5{'
        cMsg+='		background: #008000;'
        cMsg+='		color: #fff;'
        cMsg+='		padding: 20px 0 20px 20px;'
        cMsg+='	}'

        cMsg+='	.logo {'
        cMsg+='		font-family: "Arial Black";'
        cMsg+='		font-weight: bold;'
        cMsg+='		font-size: 1.5em;'
        cMsg+='		background: #008000;'
        cMsg+='		color: #fff;'
        cMsg+='		top: 35px;'
        cMsg+='		padding: 20px 0 0 0;'
        cMsg+='	}'

        cMsg+='	#titulo{'
        cMsg+='		font-size: 0.8em;'
        cMsg+='		padding: 20px;'
        cMsg+='		text-align: center;'
        cMsg+='		background: #008000;'
        cMsg+='		color: #fff;'
        cMsg+='		padding-top: 33px;'
        cMsg+='	}'

        cMsg+='	span{'
        cMsg+='		font-size: 0.4em;'
        cMsg+='		background: #008000;'
        cMsg+='		color: #fff;'
        cMsg+='		padding-top: 3px;'
        cMsg+='	}'

        cMsg+='	.titulo-topo{'
        cMsg+='		background: #008000;'
        cMsg+='		text-shadow: -5.54px 5.5px 5px rgba(0,0,0,0.5);'
        cMsg+='		text-transform: uppercase;'
        cMsg+='	}'
            
        cMsg+='	table{'
        cMsg+='		font-size: 0.8em;'
        cMsg+='		border-collapse:collapse;'
        cMsg+='	}'

        cMsg+='	th, td{'
        
        cMsg+='		padding: 7px;'
        cMsg+='		border-top: 1px solid #999;'
        cMsg+='	}'

        cMsg+='	th {'
        cMsg+='		text-transform: uppercase;'
        cMsg+='		border-top: 1px solid #999 ;'
        cMsg+='		border-bottom: 1px solid #111;'
        cMsg+='		text-align: left;'
        cMsg+='		font-size: 80%;'
        cMsg+='		letter-spacing: 0.1em;'
        cMsg+='	}'

        cMsg+='	tr:hover{'
        cMsg+='		color: blue;'
        cMsg+='		background: #008000;'
        cMsg+='	}'

        cMsg+='	.numero{'
        cMsg+='		text-align: left;'
        cMsg+='	}'

        cMsg+='</style>'
        cMsg+='	</head>'
        cMsg+='	<body>'
        cMsg+='		<div id="container"> '
        cMsg+='			<div id="cabecalho">'
        cMsg+='				<div id="topo">'
        cMsg+='					<h1 class="logo"> '
        cMsg+='						WesTech <span> Equipamentos Industriais Ltds</span>
        cMsg+='					</h1>'
        cMsg+='				</div>'
        cMsg+='				<div id="titulo">'
        cMsg+='					<h1 class="titulo-topo"> Contas a Receber - Provisões em Atraso </h1>'
        cMsg+='				</div>'

        cMsg+='				<div style="clear: both;"></div>'
        cMsg+='				'
        cMsg+='				<div id="conteudo">'
        cMsg+='					<table>'
        cMsg+='						<tr>'
        cMsg+='							<th>Contrato</th>'
        cMsg+='							<th>Status</th>'
        cMsg+='							<th>Coordenador</th>'
        cMsg+='							<th>Tipo</th>'
        cMsg+='							<th>Natureza</th>'
        cMsg+='							<th>Fornecedor</th>'
        cMsg+='							<th>Vencimento</th>'
        cMsg+='							<th>Vencto.Real</th>'
        cMsg+='							<th>Valor</th>'
        cMsg+='							<th>Saldo</th>'
        cMsg+='							<th>Histórico</th>'
        cMsg+='						</tr>'


        //******************* base de dados
        //******************* base de dados
        //SC7->(dbsetorder(1)) 
        _cQuery := " SELECT	E1_XXIC , CTD_XIDPM, DATEDIFF(day , GETDATE() ,  E1_VENCREA ) AS 'STATUS',CTD_XNOMPM, E1_NUM, E1_TIPO, E1_NATUREZ, E1_CLIENTE, "
        _cQuery += " 		E1_NOMCLI, CAST(E1_EMISSAO as Date) as 'TMP_EMISSAO', CAST(E1_VENCTO AS DATE) AS 'VENCTO', CAST(E1_VENCREA AS DATE) AS 'VENCREA', "
        _cQuery += " 		IIF(E1_TIPO = 'PA' AND E1_BAIXA <> '', -E1_VALOR, E1_VALOR)  as 'TMP_VALOR', "
        _cQuery += " 		E1_SALDO, "
        _cQuery += " 		E1_HIST, E1_BAIXA "
        _cQuery += " FROM SE1010 "
        _cQuery += " INNER JOIN CTD010 ON SE1010.E1_XXIC=CTD010.CTD_ITEM "
        _cQuery += " WHERE  SE1010.D_E_L_E_T_ <> '*'  AND CTD010.D_E_L_E_T_ <> '*' AND E1_SALDO > 0 AND E1_VENCREA < GETDATE() AND E1_TIPO = 'PR' "
        _cQuery += " AND E1_XXIC NOT IN ('ADMINISTRACAO','PROPOSTA','QUALIDADE','ATIVO','ENGENHARIA','ZZZZZZZZZZZZZ','XXXXXX','ESTOQUE')  "
        _cQuery += " AND E1_XXIC NOT IN  (SELECT E2_XXIC FROM SE2010 WHERE E2_XXIC = ' ') AND "
        _cQuery += " CTD_XIDPM = " + cIdCoord + " "
        _cQuery += " ORDER BY 2 "
        
        IF Select("_cQuery") <> 0
            DbSelectArea("_cQuery")
            DbCloseArea()
        ENDIF

        //crio o novo alias
        TCQUERY _cQuery NEW ALIAS "QUERY"

        dbSelectArea("QUERY")
        QUERY->(dbGoTop())

        // Pedido em atraso                     
        While  !(QUERY->(EoF()))
            cMsg+='						<tr>'
            cMsg+='							<td>' + QUERY->E1_XXIC + '</td>'
            cMsg+='							<td>' + cValtoChar(QUERY->STATUS) + ' dia(s) de atraso </td>'
            cMsg+='							<td>' + QUERY->CTD_XNOMPM + '</td>'
            cMsg+='							<td>' + QUERY->E1_TIPO + '</td>'
            cMsg+='							<td>' + QUERY->E1_NATUREZ + '</td>'
            cMsg+='							<td>' + QUERY->E1_CLIENTE + '</td>'
            cMsg+='							<td>' + dtoc(QUERY->VENCTO) + '</td>'
            cMsg+='							<td>' + dtoc(QUERY->VENCREA) + '</td>'
            cMsg+='							<td class="numero">' + TRANSFORM(QUERY->TMP_VALOR, '@E 99,999,999.99') + '</td>'
            cMsg+='							<td class="numero">' + TRANSFORM(QUERY->E1_SALDO, '@E 99,999,999.99')  + '</td>'
            cMsg+='							<td>' + QUERY->E1_HIST + '</td>'
            cMsg+='						</tr>'
        
            QUERY->(DbSkip())
        EndDo
        QUERY->(dbclosearea())
        // fim pedidos em atraso
        cMsg+='					</table>'
        cMsg+='				</div>'

        cMsg+='					<div id="rodape">'
        cMsg+='						<h5> Westech Equipamentos Industriais Ldta - Fonte de dados Protheus (WestechP12)</h3>'
        cMsg+='					</div>'				
        cMsg+='				</div>'		
        cMsg+='			</div>'
        cMsg+='		</body>'
        cMsg+='		</html>'

        //Popula com os dados de envio
        oMessage:cFrom              := cUsr
        oMessage:cTo                := cEmail 		// "rvalerio@westech.com.br" 
        oMessage:cCc                := "rvalerio@westech.com.br" // cEmailCC
        //oMessage:cBcc             := ""
        oMessage:cSubject           := "Contas a Receber - Provisões em Atraso" //cAssunto
        oMessage:cBody              := cMsg

        //Adiciona um attach
        If !Empty(aAnexo) //.AND. !Empty(cAnexo)
            For nI:= 1 To Len(aAnexo)
                If oMessage:AttachFile(aAnexo[nI]) < 0
                    //MsgAlert( "Erro ao anexar o arquivo", "Email nao enviado!")
                    Return .F.
                    //Else
                    //adiciona uma tag informando que e um attach e o nome do arq
                    //oMessage:AddAtthTag( 'Content-Disposition: attachment; filename=arquivo.txt')
                EndIf
            Next nI
        EndIf
        //Envia o e-mail
        If oMessage:Send( oServer ) != 0
            //MsgAlert( "Erro ao enviar o e-mail", "Email nao enviado!")
            Return .F.
        else
            //MsgInfo("E-mail enviado com sucesso.", "Westech")
        EndIf

        //MsgAlert(cEmail)

    next
	//Desconecta do servidor
	If oServer:SmtpDisconnect() != 0
		 //MsgAlert( "Erro ao disconectar do servidor SMTP", "Email nao enviado!")
		Return .F.
	EndIf*/

Return .T.
