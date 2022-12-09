#Include 'FWMVCDef.ch'
#Include 'Protheus.ch'
#include "rwmake.ch"
#include "topconn.ch"
#INCLUDE 'TOPCONN.CH'
#include "ap5mail.ch"
#INCLUDE "TOTVS.CH"
 
//Vari�veis Est�ticas
Static cTitulo := "Entrega Material / Documento"
 
/*/{Protheus.doc} zModel1
Exemplo de Modelo 1 para cadastro de Artistas
@author Atilio
@since 31/07/2016
@version 1.0
    @return Nil, Fun��o n�o tem retorno
    @example
    u_zModel1()
/*/
 
User Function zMVCEmat()
    Local aArea   := GetArea()
    Local oBrowse
    Local cFunBkp := FunName()
   
    SetFunName("zMVCEmat")
     
    //Inst�nciando FWMBrowse - Somente com dicion�rio de dados
    oBrowse := FWMBrowse():New()
     
    //Setando a tabela de cadastro de Autor/Interprete
    oBrowse:SetAlias("ZZO")
 
    //Setando a descri��o da rotina
    oBrowse:SetDescription(cTitulo)
     
    //Legendas
    //oBrowse:AddLegend( "ZZ1->ZZ1_COD <= '000005'", "GREEN",    "Menor ou igual a 5" )
    //oBrowse:AddLegend( "ZZ1->ZZ1_COD >  '000005'", "RED",    "Maior que 5" )
     
    //Filtrando
    //oBrowse:SetFilterDefault("ZZ1->ZZ1_COD >= '000000' .And. ZZ1->ZZ1_COD <= 'ZZZZZZ'")
     
    //Ativa a Browse
    oBrowse:Activate()
     
    SetFunName(cFunBkp)
    RestArea(aArea)
Return Nil
 
/*---------------------------------------------------------------------*
 | Func:  MenuDef                                                      |
 | Autor: Daniel Atilio                                                |
 | Data:  31/07/2016                                                   |
 | Desc:  Cria��o do menu MVC                                          |
 *---------------------------------------------------------------------*/
 
Static Function MenuDef()
    Local aRot := {}
     
    //Adicionando op��es
    ADD OPTION aRot TITLE 'Visualizar' ACTION 'VIEWDEF.zMVCEmat' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
    //ADD OPTION aRot TITLE 'Legenda'    ACTION 'u_zMod1Leg'      OPERATION 6                      ACCESS 0 //OPERATION X
    ADD OPTION aRot TITLE 'Incluir'    ACTION 'VIEWDEF.zMVCEmat' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
    ADD OPTION aRot TITLE 'Alterar'    ACTION 'VIEWDEF.zMVCEmat' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
    ADD OPTION aRot TITLE 'Excluir'    ACTION 'VIEWDEF.zMVCEmat' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5
 
Return aRot
 
/*---------------------------------------------------------------------*
 | Func:  ModelDef                                                     |
 | Autor: Daniel Atilio                                                |
 | Data:  31/07/2016                                                   |
 | Desc:  Cria��o do modelo de dados MVC                               |
 *---------------------------------------------------------------------*/
 
Static Function ModelDef()
    //Cria��o do objeto do modelo de dados
    Local oModel := Nil
     
    //Cria��o da estrutura de dados utilizada na interface
    Local oStZZO := FWFormStruct(1, "ZZO")

    oModel := MPFormModel():New( 'COMP011M', , , { |oModel| COMP011GRV( oModel ) } ) 
  
     
    //Editando caracter�sticas do dicion�rio
    oStZZO:SetProperty('ZZO_IDENTR',   MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.'))                                 //Modo de Edi��o
    oStZZO:SetProperty('ZZO_IDENTR',   MODEL_FIELD_INIT,    FwBuildFeature(STRUCT_FEATURE_INIPAD,  'GetSXENum("ZZO", "ZZO_IDENTR")'))         //Ini Padr�o
    //oStZZ1:SetProperty('ZZ1_DESC',  MODEL_FIELD_VALID,   FwBuildFeature(STRUCT_FEATURE_VALID,   'Iif(Empty(M->ZZ1_DESC), .F., .T.)'))   //Valida��o de Campo
    //oStZZ1:SetProperty('ZZ1_DESC',  MODEL_FIELD_OBRIGAT, Iif(RetCodUsr()!='000000', .T., .F.) )                                         //Campo Obrigat�rio
     
    //Instanciando o modelo, n�o � recomendado colocar nome da user function (por causa do u_), respeitando 10 caracteres
    oModel := MPFormModel():New("zModel1M",/*bPre*/, /*bPos*/,/*bCommit*/,/*bCancel*/) 
     
    //Atribuindo formul�rios para o modelo
    oModel:AddFields("FORMZZO",/*cOwner*/,oStZZO)
     
    //Setando a chave prim�ria da rotina
    oModel:SetPrimaryKey({'ZZO_FILIAL','ZZO_IDENTR'})
     
    //Adicionando descri��o ao modelo
    oModel:SetDescription("Controle de "+cTitulo)
     
    //Setando a descri��o do formul�rio
    oModel:GetModel("FORMZZO"):SetDescription("Formul�rio do Cadastro "+cTitulo)
Return oModel
 
/*---------------------------------------------------------------------*/
 
Static Function ViewDef()
    Local aStruZZO    := ZZO->(DbStruct())
     
    //Cria��o do objeto do modelo de dados da Interface do Cadastro de Autor/Interprete
    Local oModel := FWLoadModel("zMVCEmat")
     
    //Cria��o da estrutura de dados utilizada na interface do cadastro de Autor
    Local oStZZO := FWFormStruct(2, "ZZO")  //pode se usar um terceiro par�metro para filtrar os campos exibidos { |cCampo| cCampo $ 'SZZ1_NOME|SZZ1_DTAFAL|'}
     
    //Criando oView como nulo
    Local oView := Nil
 
    //Criando a view que ser� o retorno da fun��o e setando o modelo da rotina
    oView := FWFormView():New()
    oView:SetModel(oModel)
     
    //Atribuindo formul�rios para interface
    oView:AddField("VIEW_ZZO", oStZZO, "FORMZZO")
     
    //Criando um container com nome tela com 100%
    oView:CreateHorizontalBox("TELA",100)
     
    //Colocando t�tulo do formul�rio
    oView:EnableTitleView('VIEW_ZZO', 'Dados - '+cTitulo )  
     
    //For�a o fechamento da janela na confirma��o
    oView:SetCloseOnOk({||.T.})
     
    //O formul�rio da interface ser� colocado dentro do container
    oView:SetOwnerView("VIEW_ZZO","TELA")

    oView:AddUserButton( 'Enviar Aviso por E-mail', '', {|oView| zEvEMat() } )  
    oView:AddUserButton( 'Abrir arquivo vinculado', '', {|oView| zVisArq() } )  

    oView:SetViewAction('BUTTONOK',{|oView|zEvEMat(oView)})


    /*
    //Tratativa para remover campos da visualiza��o
    For nAtual := 1 To Len(aStruZZ1)
        cCampoAux := Alltrim(aStruZZ1[nAtual][01])
         
        //Se o campo atual n�o estiver nos que forem considerados
        If Alltrim(cCampoAux) $ "ZZ1_COD;"
            oStZZ1:RemoveField(cCampoAux)
        EndIf
    Next
    */

    //oView:SetCloseOnOk( { ||.F. } )
Return oView


Static Function zVisArq(CCodigo,cParametro)

Local cArq :=""
Local cArq1:=""
Local lRet:=.T.

cArq := AllTrim(M->ZZO_ARQ)
lRet:=FILE(cArq) // Verifica no diret�rio Desenhos T�cnicos do servidor se existe o arquivo buscado.pdf
If lRet
//	If	MAKEDIR('C:\TEMP')!= 0
//		Alert("Impossivel a Cria��o da Pasta C:\TEMP em Sua Maquina Local, Verifique !!!")
//		Return .f.
//	EndIf

	//pega o caminho do arquivo
//	cArq :=cParametro+"\"+cCodigo+".pdf"
	//copia o arquivo para a pasta temp no remote
	//Limpa a pasta temporaria no remote
//	Ferase('C:\TEMP\'+cCodigo+".pdf")
//	__COPYFILE(cParametro+"\"+cCodigo+".pdf",'C:\TEMP\'+cCodigo+".pdf")
//	CpyS2T(cParametro+"\"+cCodigo+".pdf", 'C:\TEMP\', .T.)
	shellExecute( "Open", cArq, " /k dir", "C:\", 1 ) //executa o programa para leitura do arquivo copiado
Else   
	Alert("Atencao Arquivo " + cArq + " N�o Localizado !!!")
//	If Msgyesno("N�o h� nenhum documento!,Deseja Anexar?") //se n�o encontrar o arquivo no diret�rio, informa o usu�rio
//		U_UPPPDF(cCodigo,cParametro)
//	Else  && Bruno Abrigo em 19\03\2012
//		Return
//	EndIf
EndIf

Return lRet
 
/*/{Protheus.doc} zMod1Leg
Fun��o para mostrar a legenda
@author Atilio
@since 31/07/2016
@version 1.0
    @example
    u_zMod1Leg()
/
 
User Function zMod1Leg()
    Local aLegenda := {}
     
    //Monta as cores
    AADD(aLegenda,{"BR_VERDE",        "Menor ou igual a 5"  })
    AADD(aLegenda,{"BR_VERMELHO",    "Maior que 5"})
     
    BrwLegenda(cTitulo, "Status", aLegenda)
Return*/


//Envia E-mail
Static Function zEvEMat(cTo, cCc, cAssunto, cMsg, aAnexo)
  
    Local cIdEntr			:=  M->ZZO_IDENTR

	Local oServer
	Local oMessage
	Local cUsr := GetMv("MV_RELACNT") //Conta de autenticao do email
	Local cPsw := GetMv("MV_RELPSW") //Senha para autenticao no servidor de e-mail
	Local cSrv := GetMv("MV_RELSERV") //Servidor SMTP
	Local lAut := GetMv("MV_RELAUTH") //Servidor SMTP necessite de AUTENTICAΗAO para envio de e-mails
	Local nPrt := 587
	local nI

    Local cIDRec   := M->ZZO_IDREC
    Local cIDResp   := M->ZZO_IDRESP
    Local cEmailTo  := ""
    Local cEmailCC  := ""

    Private _aRetUserE := ""
    Private _aRetUserR := ""

	Private n1 := 0
	//Local aAnexo := StrTokArr(cAnexo, ";")

	//Cria a conexγo com o server STMP ( Envio de e-mail )
	oServer := TMailManager():New()
	//oServer:SetUseTLS( .T. )
	//O servidor esta com a porta

    //MsgInfo(cIdEntr)
		
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
        cMsg+='	            height: 110px; '
        cMsg+='	        } '

        cMsg+='	        #topo{ '
        cMsg+='	            width: 90%; '
        cMsg+='	            margin: 0 auto; '
        cMsg+='	        } '

        cMsg+='	        #conteudo{ '
        cMsg+='	            margin: 0 auto; '
        cMsg+='	            margin-top:1px; '
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
            cMsg+='	                        <th> C�digo </th>  '
            cMsg+='	                        <th colspan="5"> Nome </th> '
            cMsg+='	                    </tr> '
            cMsg+='	                    <tr> '
            if ZZO->ZZO_TPCF = "2"
                cMsg+='	                        <td> Fornecedor </td> '
            else
               cMsg+='	                        <td> Cliente </td> '
            endif 

            cMsg+='	                        <td>' + ZZO->ZZO_CODCF + '</td> '
            cMsg+='	                        <td colspan="5">' + ZZO->ZZO_DESCF + '</td> '
            cMsg+='	                    </tr> '
            cMsg+='	                    <tr> '
            cMsg+='	                        <th colspan="7"> Descri��o Material</th> '
            cMsg+='	                    </tr> '
            cMsg+='	                    <tr> '
            cMsg+='	                        <td colspan="7">' + ZZO->ZZO_DESCR + '</th> '
            cMsg+='	                    </tr> '
            cMsg+='	                    <tr> '
            cMsg+='	                        <th colspan="7">Documento Vinculado </th> '
            cMsg+='	                    </tr> '
            cMsg+='	                    <tr> '
            cMsg+='	                        <td colspan="7"> <a href=' + "'" + StrTran(ZZO->ZZO_ARQ,'\','/') + "'" + '>' + ZZO->ZZO_ARQ + '</a></th> '
            cMsg+='	                    </tr> '
            cMsg+='	                    <tr> '
            cMsg+='	                        <th colspan="7">Observa��o </th> '
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

        cEmailTo := UsrRetMail(alltrim(cIDResp))
        cEmailCC := UsrRetMail(alltrim(cIDRec))

        if cEmailCC = cEmailTo
            cEmailCC := ""
        endif
        
        //Popula com os dados de envio
        oMessage:cFrom              := cUsr
        oMessage:cTo                := cEmailTo //"rvalerio@westech.com.br"  //cEmail cEmailCC
        oMessage:cCc                := cEmailCC //cEmailTo // cEmailCC
        //oMessage:cBcc             := ""
        oMessage:cSubject           := "Aviso de entrega Material / Documento" //cAssunto
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
            MsgAlert( "Erro ao enviar o e-mail." , "Email nao enviado!")
            Return .F.
        else
            MsgInfo("E-mail enviado com sucesso para: " + cEmailTo + ' e ' +  cEmailCC + '.' , "Westech")
        EndIf

        //MsgAlert(cEmail)

   
	//Desconecta do servidor
	If oServer:SmtpDisconnect() != 0
		 MsgAlert( "Erro ao disconectar do servidor SMTP", "Email nao enviado!")
		Return .F.
	EndIf

Return .T.

