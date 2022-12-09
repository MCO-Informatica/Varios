
#include "rwmake.ch"
#include "topconn.ch"
#Include 'Protheus.ch'
#INCLUDE 'TOPCONN.CH'
#include "ap5mail.ch"
#INCLUDE "TOTVS.CH"


//Envia E-mail
User Function zEvEntMat(cTo, cCc, cAssunto, cMsg, aAnexo)
    
    Local cIdEntr			:= ZZO_IDENTR

	Local oServer
	Local oMessage
	Local cUsr := GetMv("MV_RELACNT") //Conta de autenticao do email
	Local cPsw := GetMv("MV_RELPSW") //Senha para autenticao no servidor de e-mail
	Local cSrv := GetMv("MV_RELSERV") //Servidor SMTP
	Local lAut := GetMv("MV_RELAUTH") //Servidor SMTP necessite de AUTENTICAÎ—AO para envio de e-mailÂ’s
	Local nPrt := 587
	local nI

	Local cEmail 	:= ""
	Local cIDUserCC := ""

    Local cEmailTo := ""
    Local cEmailCC := ""

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

    //dbSelectArea("SE1")
    //SE1->( dbSetOrder(1))

        cMsg:=' <!DOCTYPE html>'
        cMsg+='	<html>'

        cMsg:=' <!DOCTYPE html> '
        cMsg+='	 <html> '
        cMsg+='	 <head> '
        cMsg+='	    <meta charset="utf-8"> '
        cMsg+='	    <title> Westech - Controle de Entrega de Material / Documento</title> '
        cMsg+='	    <style type="text/css"> ' 
        cMsg+='	        *{ '
        cMsg+='	            margin: 0; '
        cMsg+='	            padding: 0; '
        cMsg+='	            background: #fff; '
        cMsg+='	        } '

        cMsg+='	        body{ '
        cMsg+='	            font-family: "Trebuche MS", Helvetica, sans-serif; '
        cMsg+='	            background: #f2f2f2; '
        cMsg+='	            min-width: 750px; '
        cMsg+='	        } '

        cMsg+='	        #cabecalho{ '
        cMsg+='	            background: rgb(1, 86, 151); '
        cMsg+='	            height: 130px; '
        cMsg+='	        } '

        cMsg+='	        #topo{ '
        cMsg+='	            width: 90%; '
        cMsg+='	            margin: 0 auto; '
        cMsg+='	        } '

        cMsg+='	        #conteudo{ '
        cMsg+='	            margin: 0 auto; '
        cMsg+='	            margin-top:30px; '
        cMsg+='	            width: 80%; '
        cMsg+='	        } '

        cMsg+='	        #rodape{ '
        cMsg+='	            padding: 20px; '
        cMsg+='	            text-align: center; '
        cMsg+='	            background: rgb(1, 86, 151); '
        cMsg+='	            min-width: 750px; '
        cMsg+='	            margin-top: 20px; '
        cMsg+='	        } '

        cMsg+='	        #rodape h5{ '
        cMsg+='	            background: rgb(1, 86, 151); '
        cMsg+='	            color: #fff; '
        cMsg+='	        } '

        cMsg+='	        .logo { '
        cMsg+='	            font-family: "Arial Black"; '
        cMsg+='	            font-weight: bold; '
        cMsg+='	            font-size: 1.5em; '
        cMsg+='	            background: rgb(1, 86, 151); '
        cMsg+='	            color: #fff; '
        cMsg+='	            top: 35px; '
        cMsg+='	            padding: 20px 0 0 0; '
        cMsg+='	        } '

        cMsg+='	        #titulo{ '
        cMsg+='	            font-size: 0.8em; '
        cMsg+='	            padding: 20px; '
        cMsg+='	            text-align: center; '
        cMsg+='	            background: rgb(1, 86, 151); '
        cMsg+='	            color: #fff; '
        cMsg+='	            padding-top: 33px; '
        cMsg+='	        } '

        cMsg+='	        span{ '
        cMsg+='	            font-size: 0.4em; '
        cMsg+='	            background: rgb(1, 86, 151); '
        cMsg+='	            color: #fff; '
        cMsg+='	           padding-top: 3px; '
        cMsg+='	        } '

        cMsg+='	        .titulo-topo{ '
        cMsg+='	            background: rgb(1, 86, 151); '
        cMsg+='	            text-shadow: -5.54px 5.5px 5px rgba(0,0,0,0.5); '
        cMsg+='	            text-transform: uppercase; '
        cMsg+='	        } '
                
        cMsg+='	        table{ '
        cMsg+='	            font-size: 0.8em; '
        cMsg+='	            border-collapse:collapse; '
        cMsg+='	        } '


        cMsg+='	        th, td{ '
        cMsg+='	            /*border: 1px solid red;*/ '
        cMsg+='	            padding: 7px; '
        cMsg+='	            border: 1px solid #999; '
        cMsg+='	        } '

        cMsg+='	        th { '
        cMsg+='	            text-transform: uppercase; '
        cMsg+='	            border-top: 1px solid #999 ; '
        cMsg+='	            border-bottom: 1px solid #111; '
        cMsg+='	            text-align: left; '
        cMsg+='	            font-size: 80%; '
        cMsg+='	            letter-spacing: 0.1em; '
        cMsg+='	            background: #87CEFA; '
        cMsg+='	        } '


        cMsg+='	        tr:hover{ '
        cMsg+='	            color: blue; '
        cMsg+='	            background: rgb(1, 86, 151); '
        cMsg+='	        } '

        cMsg+='	        .numero{ '
        cMsg+='	            text-align: cemter; '
        cMsg+='	        } '

        cMsg+='	    </style> '
        cMsg+='	</head> '
        cMsg+='	<body> '
        cMsg+='	    <div id="container">  '
        cMsg+='	        <div id="cabecalho"> '
        cMsg+='	            <div id="topo"> '
        cMsg+='	                <h1 class="logo">  '
        cMsg+='	                    WesTech <span> Equipamentos Industriais Ltds</span> '
        cMsg+='	                </h1> '

        cMsg+='	            </div> '
        cMsg+='	            <div id="titulo"> '
        cMsg+='	                <h1 class="titulo-topo"> Controle de Entrega de Material / Documento </h1> '
        cMsg+='	            </div> '

        cMsg+='	            <div style="clear: both;"></div> '

        DbSelectArea("ZZO")
        ZZO->(DbSetOrder(1)) //B1_FILIAL + B1_COD
        ZZO->(DbGoTop()) 

        If ZZO->( dbSeek(xFilial("ZZO")+cIdEntr) )
                    
            cMsg+='	            <div id="conteudo"> '
            cMsg+='	                <table> '
            cMsg+='	                    <tr> '
            cMsg+='	                        <th>ID Entrega</th> '
            cMsg+='	                        <th>Data Registro</th> '
            cMsg+='	                        <th>Data Entrega</th> '
            cMsg+='	                        <th>Tipo</th> '
            cMsg+='	                        <th>No.Documento</th> '
            cMsg+='	                        <th>Recebido por</th> '
            cMsg+='	                        <th>Responsavel</th> '
            cMsg+='	                    </tr> '
            cMsg+='	                    <tr> '
            cMsg+='	                        <td>' + ZZO->ZZO_IDENTR + '</td> '
            cMsg+='	                        <td>' + dtoc(ZZO->ZZO_DTREG) + '</td> '
            cMsg+='	                        <td>' + dtoc(ZZO->ZZO_DTENTR) + '</td> '
            cMsg+='	                        <td>' + ZZO->ZZO_TIPO + '</td> '
            cMsg+='	                        <td>' + ZZO->ZZO_DOC + '</td> '
            cMsg+='	                        <td>' + ZZO->ZZO_RECNOM + '</td> '
            cMsg+='	                        <td>' + ZZO->ZZO_RESP + '</td> '
            cMsg+='	                    </tr> '
            cMsg+='	                    <tr> '
            cMsg+='	                        <th> Cliente / Fornecedor</th> '
            cMsg+='	                        <th> Código </th>  '
            cMsg+='	                        <th colspan="5"> Nome </th> '
            cMsg+='	                    </tr> '
            cMsg+='	                    <tr> '
            cMsg+='	                        <td>' + ZZO->ZZO_TPCF + '</td> '
            cMsg+='	                        <td>' + ZZO->ZZO_CODCF + '</td> '
            cMsg+='	                        <td colspan="5">' + ZZO->ZZO_DESCF + '</td> '
            cMsg+='	                    </tr> '
            cMsg+='	                    <tr> '
            cMsg+='	                        <th colspan="7"> Descrição Material</th> '
            cMsg+='	                    </tr> '
            cMsg+='	                    <tr> '
            cMsg+='	                        <td colspan="7">' + ZZO->ZZO_DESCR + '</th> '
            cMsg+='	                    </tr> '
            cMsg+='	                    <tr> '
            cMsg+='	                        <th colspan="7">Observação </th> '
            cMsg+='	                    </tr> '
            cMsg+='	                    <tr> '
            cMsg+='	                        <td colspan="7">' + ZZO->ZZO_OBS +'</th> '
            cMsg+='	                    </tr> '
        
        ENDIF

        cMsg+='	                </table> '
        cMsg+='	            </div> '

        cMsg+='	            <div id="rodape"> '
        cMsg+='	                <h5> Westech Equipamentos Industriais Ldta - Fonte de dados Protheus (WestechP12)</h3> '
        cMsg+='	            </div>  '      

        cMsg+='	        </div> '
            
        cMsg+='	    </div> '
        cMsg+='	</body> '
        cMsg+='	</html> '

        cEmailCC := UsrRetMail(alltrim(M->ZZO_IDRESP)) // Responsavel
        cEmailTo := UsrRetMail(alltrim(M->ZZO_IDREC)) // Recebido por

        //Popula com os dados de envio
        oMessage:cFrom              := cUsr
        oMessage:cTo                := cEmailCC //"rvalerio@westech.com.br"  //cEmail
        oMessage:cCc                := cEmailTo // cEmailCC
        //oMessage:cBcc             := ""
        oMessage:cSubject           := "Aviso de entraga Material / Documento" //cAssunto
        oMessage:cBody              := cMsg

        //Adiciona um attach
        If !Empty(aAnexo) //.AND. !Empty(cAnexo)
            For nI:= 1 To Len(aAnexo)
                If oMessage:AttachFile(aAnexo[nI]) < 0
                    MsgAlert( "Erro ao anexar o arquivo", "Email nao enviado!")
                    Return .F.
                    //Else-
                    //adiciona uma tag informando que e um attach e o nome do arq
                    //oMessage:AddAtthTag( 'Content-Disposition: attachment; filename=arquivo.txt')
                EndIf
            Next nI
        EndIf
        //Envia o e-mail
        If oMessage:Send( oServer ) != 0
            MsgAlert( "Erro ao enviar o e-mail....."  + cEmailCC + ' e ' + cEmailTo + '.', "Email nao enviado!")
            Return .F.
        else
            MsgInfo("E-mail enviado com sucesso para " + cEmailCC + ' e ' + cEmailTo + '.' , "Westech")
        EndIf

        //MsgAlert(cEmail)

   
	//Desconecta do servidor
	If oServer:SmtpDisconnect() != 0
		 MsgAlert( "Erro ao disconectar do servidor SMTP", "Email nao enviado!")
		Return .F.
	EndIf*/

Return .T.

