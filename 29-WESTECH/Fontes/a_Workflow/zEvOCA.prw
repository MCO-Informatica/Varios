
#include "rwmake.ch"
#include "topconn.ch"
#Include 'Protheus.ch'
#INCLUDE 'TOPCONN.CH'
#include "ap5mail.ch"
#INCLUDE "TOTVS.CH"


User Function zEvOCA()
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
    Local _cFilSC7 := xFilial("SC7")
    local cFor 		:= "C7_ENCER <> 'E' .AND. C7_DATPRF <= dDatabase .AND. C7_RESIDUO <> 'S' "


	Local oServer
	Local oMessage
	Local cUsr := GetMv("MV_RELACNT") //Conta de autenticao do email
	Local cPsw := GetMv("MV_RELPSW") //Senha para autenticao no servidor de e-mail
	Local cSrv := GetMv("MV_RELSERV") //Servidor SMTP
	Local lAut := GetMv("MV_RELAUTH") //Servidor SMTP necessite de AUTENTICAΗAO para envio de e-mails
	Local nPrt := 587
	local nI

	Local cIDUser 	:= ""
	Local cEmail 	:= ""
	Local cIDUserCC := ""
	Local cEmailCC 	:= ""
    local cFiltro1A 	:= ""

    Local aMatriz2 		:= {}
	Local aMatriz		:= {}
	Local nI 			:= 0
	Local nI2 			:= 0
	Local nI3 			:= 0
	Local nI5 			:= 0
	

	Private n1 := 0
	//Local aAnexo := StrTokArr(cAnexo, ";")

	//Cria a conexγo com o server STMP ( Envio de e-mail )
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

	//realiza a conexγo SMTP
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
	//Apos a conexγo, cria o objeto da mensagem
	oMessage := TMailMessage():New()

	//Limpa o objeto
	oMessage:Clear()

    dbSelectArea("SC7")
    SC7->( dbSetOrder(1))

    //******************* base de dados
    //SC7->(dbsetorder(1)) 
    _cQuery := "SELECT	C7_NUM, C7_ITEM, C7_ITEMCTA, C7_PRODUTO, C7_DESCRI,"
    _cQuery += "        C7_UM, C7_QUANT, C7_QUJE, C7_PRECO, C7_TOTAL, C7_XTOTSI,"
    _cQuery += "        C7_EMISSAO, C7_DATPRF, C7_NUMSC, C7_FORNECE, CTD_XIDPM, CTD_XNOMPM"
    _cQuery += "   FROM SC7010"
    _cQuery += "   INNER JOIN SB1010 ON SC7010.C7_PRODUTO=SB1010.B1_COD "
    _cQuery += "   INNER JOIN CTD010 ON SC7010.C7_ITEMCTA=CTD010.CTD_ITEM"
    _cQuery += " WHERE	C7_DATPRF < GETDATE() AND C7_ENCER <> 'E' AND C7_RESIDUO <> 'S' AND"
    _cQuery += " SC7010.D_E_L_E_T_ <> '*' AND SB1010.D_E_L_E_T_ <> '*' AND CTD010.D_E_L_E_T_ <> '*' AND"
    _cQuery += " CTD_ITEM NOT IN ('ADMINISTRACAO','PROPOSTA','QUALIDADE','ATIVO','ENGENHARIA','ZZZZZZZZZZZZZ','XXXXXX') "
    _cQuery += " ORDER BY 16"

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
        cMsg+='		<title> Westech - Pedidos em Atraso</title>'
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
        cMsg+='		background: rgb(1, 86, 151);'
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
        cMsg+='		background: rgb(1, 86, 151);'
        cMsg+='		min-width: 750px;'
        cMsg+='		margin-top: 20px;'
        cMsg+='	}'

        cMsg+='	#rodape h5{'
        cMsg+='		background: rgb(1, 86, 151);'
        cMsg+='		color: #fff;'
        cMsg+='		padding: 20px 0 20px 20px;'
        cMsg+='	}'

        cMsg+='	.logo {'
        cMsg+='		font-family: "Arial Black";'
        cMsg+='		font-weight: bold;'
        cMsg+='		font-size: 1.5em;'
        cMsg+='		background: rgb(1, 86, 151);'
        cMsg+='		color: #fff;'
        cMsg+='		top: 35px;'
        cMsg+='		padding: 20px 0 0 0;'
        cMsg+='	}'

        cMsg+='	#titulo{'
        cMsg+='		font-size: 0.8em;'
        cMsg+='		padding: 20px;'
        cMsg+='		text-align: center;'
        cMsg+='		background: rgb(1, 86, 151);'
        cMsg+='		color: #fff;'
        cMsg+='		padding-top: 33px;'
        cMsg+='	}'

        cMsg+='	span{'
        cMsg+='		font-size: 0.4em;'
        cMsg+='		background: rgb(1, 86, 151);'
        cMsg+='		color: #fff;'
        cMsg+='		padding-top: 3px;'
        cMsg+='	}'

        cMsg+='	.titulo-topo{'
        cMsg+='		background: rgb(1, 86, 151);'
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
        cMsg+='		background: rgb(1, 86, 151);'
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
        cMsg+='					<h1 class="titulo-topo"> Pedido(s) de Compra <br> em Atraso </h1>'
        cMsg+='				</div>'

        cMsg+='				<div style="clear: both;"></div>'
        cMsg+='				'
        cMsg+='				<div id="conteudo">'
        cMsg+='					<table>'
        cMsg+='						<tr>'
        cMsg+='							<th>No.Pedido</th>'
        cMsg+='							<th>Status</th>'
        cMsg+='							<th>Entrega</th>'
        cMsg+='							<th>Item Conta</th>'
        cMsg+='							<th>Coordenador</th>'
        cMsg+='							<th>Item</th>'
        cMsg+='							<th>Produto</th>'
        cMsg+='							<th>Descricao</th>'
        cMsg+='							<th>Un</th>'
        cMsg+='							<th>Qtd.Pedido</th>'
        cMsg+='							<th>Qtd.Entregue</th>'
        cMsg+='							<th>Fornecedor</th>'
        cMsg+='						</tr>'


        //******************* base de dados
        //SC7->(dbsetorder(1)) 
        _cQuery := "SELECT	C7_NUM, DATEDIFF(day , GETDATE() ,  C7_DATPRF ) AS 'STATUS', C7_ITEM, C7_ITEMCTA, C7_PRODUTO, C7_DESCRI,"
        _cQuery += "        C7_UM, C7_QUANT, C7_QUJE, C7_PRECO, C7_TOTAL, C7_XTOTSI,"
        _cQuery += "        C7_EMISSAO, CAST(C7_DATPRF AS DATE) AS 'DATPRF', C7_NUMSC, C7_FORNECE, CTD_XIDPM, CTD_XNOMPM"
        _cQuery += "   FROM SC7010"
        _cQuery += "   INNER JOIN SB1010 ON SC7010.C7_PRODUTO=SB1010.B1_COD "
        _cQuery += "   INNER JOIN CTD010 ON SC7010.C7_ITEMCTA=CTD010.CTD_ITEM"
        _cQuery += " WHERE	C7_DATPRF < GETDATE() AND C7_ENCER <> 'E' AND C7_RESIDUO <> 'S' AND"
        _cQuery += " SC7010.D_E_L_E_T_ <> '*' AND SB1010.D_E_L_E_T_ <> '*' AND CTD010.D_E_L_E_T_ <> '*' AND"
        _cQuery += " CTD_ITEM NOT IN ('ADMINISTRACAO','PROPOSTA','QUALIDADE','ATIVO','ENGENHARIA','ZZZZZZZZZZZZZ','XXXXXX') AND "
        _cQuery += " CTD_XIDPM = " + Alltrim(aMatriz2[nI]) + " "
        _cQuery += " ORDER BY 17"

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
            cMsg+='							<td>' + QUERY->C7_NUM + '</td>'
            cMsg+='							<td>' + cValtoChar(QUERY->STATUS) + ' dia(s) de atraso </td>'
            cMsg+='							<td>' + dtoc(QUERY->DATPRF) + '</td>'
            cMsg+='							<td>' + QUERY->C7_ITEMCTA + '</td>'
            cMsg+='							<td>' + QUERY->CTD_XNOMPM + '</td>'
            cMsg+='							<td>' + QUERY->C7_ITEM + '</td>'
            cMsg+='							<td>' + QUERY->C7_PRODUTO + '</td>'
            cMsg+='							<td>' + QUERY->C7_DESCRI + '</td>'
            cMsg+='							<td>' + QUERY->C7_UM + '</td>'
            cMsg+='							<td class="numero">' + cValtoChar(QUERY->C7_QUANT) + '</td>'
            cMsg+='							<td class="numero">' + cValToChar(QUERY->C7_QUJE) + '</td>'
            cMsg+='							<td>' + Posicione("SA2",1,xFilial("SA2") +  ALLTRIM(QUERY->C7_FORNECE),"A2_NOME")  + '</td>'
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
        oMessage:cTo                := cEmail
        oMessage:cCc                := "rvalerio@westech.com.br" // cEmailCC
        //oMessage:cBcc               := "rvalerio@westech.com.br"
        oMessage:cSubject           := "Pedido(s) de Compra em Atraso" //cAssunto
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
