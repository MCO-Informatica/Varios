#include "rwmake.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"
#include "ap5mail.ch"
#INCLUDE "Protheus.ch"
/*_________________________________________________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+--------------------------------------------------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦ WFW120  ¦ Autor ¦ Felipe Valenca				                                   ¦ Data ¦ 06/08/12 ¦¦¦
¦¦+----------+---------------------------------------------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Workflow para envio de Autorização de Pedido de compras e tratamento do retorno                   ¦¦¦
¦¦+----------+---------------------------------------------------------------------------------------------------¦¦¦
¦¦¦Observacao¦                                                                                                   ¦¦¦
¦¦+----------+---------------------------------------------------------------------------------------------------¦¦¦
¦¦¦ Uso      ¦                                                                                                   ¦¦¦
¦¦+--------------------------------------------------------------------------------------------------------------¦¦¦
¦¦¦                                 ATUALIZACOES SOFRIDAS DESDE A CONSTRUÇAO INICIAL.                            ¦¦¦
¦¦+--------------------------------------------------------------------------------------------------------------¦¦¦
¦¦¦Programador ¦ Data   ¦ Motivo da Alteracao                                                                    ¦¦¦
¦¦+------------+--------+----------------------------------------------------------------------------------------¦¦¦
¦¦¦            ¦        ¦                                                                                        ¦¦¦
¦¦+--------------------------------------------------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function WFW120P(_nOpcao,oProcess)

	Default _nOpcao := 0

    do case
    case _nOpcao == 0
	U_PCInicio()
    case _nOpcao == 1
	U_PCRetorno(oProcess)                       	
    case _nOpcao == 2
	U_PCTimeOut(oProcess)       	
    endcase

Return


//Inicio do Workflow
User Function PCInicio

Local oProcess
Local nDias := 0, nHoras := 0, nMinutos := 10
Local cCodProcesso, cCodStatus, cHtmlModelo, cMailID
Local cUsuarioProtheus, cCodProduto, cTexto, cAssunto

Local nTotal	:= 0
Local nFrete	:= 0
Local nImp		:= 0
Local cNum := ""

Local cNomForn	:=""
Local cCondPag	:=""
Local cArea		:= GetArea()
Local cProjet	:= ""
Local cSite		:= ""
Local cObs		:= ""
Local cNewProj	:= ""
Local aProjet	:= {}

// Código extraído do cadastro de processos.
cCodProcesso := "100100"

// Arquivo html template utilizado para montagem da aprovação
cHtmlModelo := "\workflow\wfw120p1.htm"

// Assunto da mensagem
cAssunto := "Aprovação do Pedido de Compra "+SC7->C7_NUM

// Registre o nome do usuário corrente que esta criando o processo:
cUsuarioProtheus:= SubStr(cUsuario,7,15)

// Inicialize a classe TWFProcess e assinale a variável objeto oProcess:
oProcess := TWFProcess():New(cCodProcesso, cAssunto) 

// Crie uma tarefa.
oProcess:NewTask(cAssunto, cHtmlModelo)

cNomForn		:=Posicione("SA2",1,xFilial("SA2")+SC7->C7_FORNECE,"A2_NOME")
cCondPag		:=Posicione("SE4",1,xFilial("SE4")+SC7->C7_COND,"E4_DESCRI")

oProcess:oHtml:ValByName( "usuario"		, cUsuarioProtheus					)
oProcess:oHtml:ValByName( "C7_NUM"		, SC7->C7_NUM						)
oProcess:oHtml:ValByName( "C7_EMISSAO"	, SC7->C7_EMISSAO 					)
oProcess:oHtml:ValByName( "FORNECEDOR"	, SC7->C7_FORNECE +" - "+cNomForn	)
oProcess:oHtml:ValByName( "E4_DESCRI"	, SC7->C7_COND +" - "+cCondPag		)

//==================================================================================================
DbSelectArea("SC7")
DbSetOrder(1)
DbSeek(xFilial("SC7")+SC7->C7_NUM)
cNum := SC7->C7_NUM

//cSite	:= Posicione("AF8",1,xFilial("AF8")+cProjet,"AF8_DESCRI")
//cObs	:= Iif(!Empty(cProjet),"Projeto: "+cProjet+ " Site: "+cSite,"")
    While !Eof() .and. SC7->C7_FILIAL == xFilial("SC7") .and. SC7->C7_NUM == cNum
	cProjet := Posicione("AJ7",5,xFilial("AJ7")+SC7->C7_NUM+SC7->C7_PRODUTO,"AJ7_PROJET")	
        If cProjet <> cNewProj
		Aadd(aProjet,{Posicione("AJ7",5,xFilial("AJ7")+SC7->C7_NUM+C7_PRODUTO,"AJ7_PROJET"), Posicione("AF8",1,xFilial("AF8")+Posicione("AJ7",5,xFilial("AJ7")+SC7->C7_NUM+SC7->C7_PRODUTO,"AJ7_PROJET"),"AF8_DESCRI")})
		cNewProj := cProjet
        Endif
	
	nTotal  := nTotal + C7_TOTAL
	nFrete  := nFrete + C7_FRETE
	nImp    := nFrete +  (C7_VALIPI + C7_VALICM)
	
	AAdd( (oProcess:oHtml:ValByName( "t1.1" )),C7_ITEM )
	AAdd( (oProcess:oHtml:ValByName( "t1.2" )),C7_PRODUTO )
	AAdd( (oProcess:oHtml:ValByName( "t1.3" )),SC7->C7_DESCRI )
	AAdd( (oProcess:oHtml:ValByName( "t1.4" )),SC7->C7_UM )
	AAdd( (oProcess:oHtml:ValByName( "t1.5" )),TRANSFORM( C7_QUANT,'@E 99,999.99' ) )
	AAdd( (oProcess:oHtml:ValByName( "t1.6" )),TRANSFORM( C7_PRECO,'@E 99,999.99' ) )
	AAdd( (oProcess:oHtml:ValByName( "t1.8" )),TRANSFORM( C7_TOTAL,'@E 99,999.99' ) )
	AAdd( (oProcess:oHtml:ValByName( "t1.9" )),DTOC(SC7->C7_DATPRF) )
//	WFSalvaID('SC7','C7_WFID',oProcess:fProcessID)
	
	dbSkip()
    Enddo

//==================================================================================================
//construção do rodape
AAdd( (oProcess:oHtml:ValByName( "t2.1" )),TRANSFORM( nTotal,'@E 99,999.99' ) )
AAdd( (oProcess:oHtml:ValByName( "t2.2" )),TRANSFORM( nFrete,'@E 99,999.99' ) )
AAdd( (oProcess:oHtml:ValByName( "t2.3" )),TRANSFORM( nImp,'@E 99,999.99' ) )

    For nX := 1 to Len(aProjet)
	AAdd( (oProcess:oHtml:ValByName( "t3.1" )),"Projeto: "+aProjet[nX][1]+ " Site: "+aProjet[nX][2] )
    Next

//AAdd( (oProcess:oHtml:ValByName( "t3.1" )),cObs )

// Repasse o texto do assunto criado para a propriedade especifica do processo.
oProcess:cSubject := cAssunto

// Informe o endereço eletrônico do destinatário.
oProcess:cTo := "compras"

// Informe o nome da função de retorno a ser executada quando a mensagem de
// respostas retornarem ao Workflow:
oProcess:bReturn := "U_WFW120P(1)"

// Antes de assinalar o ID do processo no campo, é verificado se realmente o
// campo existe na tabela SB1
/*If SB1->(FieldPos("B1_WFID")) > 0
    If RecLock("SB1",.f.)
		SB1->B1_WFID := oProcess:fProcessID + oProcess:fTaskID
		MsUnLock()
    EndIf
EndIf */

// Informe o nome da função do tipo timeout que será executada se houver um timeout
// ocorrido para esse processo. Neste exemplo, será executada 5 minutos após o envio
// do e-mail para o destinatário. Caso queira-se aumentar ou diminuir o tempo, altere
// os valores das variáveis: nDias, nHoras e nMinutos.
oProcess:bTimeOut := {{"U_WFW120P(2)", nDias, nHoras, nMinutos}}

cMailID := oProcess:Start()

cHtmlModelo := "\workflow\wflink.htm"

oProcess:NewTask(cAssunto, cHtmlModelo)  

oProcess:oHtml:ValByName("usuario","João")
oProcess:oHtml:ValByName("Pedido",cNum)
oProcess:oHtml:ValByName("Fornecedor",cNomForn)

// Repasse o texto do assunto criado para a propriedade especif	ca do processo.
oProcess:cSubject := cAssunto

// Informe o endereço eletrônico do destinatário.
oProcess:cTo := "joao@jestec.com.br;workflow@upduo.com.br"

//conta workflow@upduo.com.br
//senha Workflow@123

//oProcess:ohtml:ValByName("usuario","Administrador")

oProcess:ohtml:ValByName("proc_link","http://201.6.114.198:8089/workflow/messenger/emp01/compras/" + cMailID + ".htm")
//oProcess:ohtml:ValByName("proc_link","http://187.75.236.7:8089/workflow/messenger/emp01/compras/" + cMailID + ".htm")

// Apos ter repassado todas as informacoes necessarias para o workflow, solicite a
// a ser executado o método Start() para se gerado todo processo e enviar a mensagem
// ao destinatário.
oProcess:Start()

Return


User Function PCRetorno(oProcess)

Local cPedido
Local cAprov
Local cObs
Local aCodProdutos, aPrecoVendas
Local nC, nDias := 0, nHoras := 0, nMinutos := 10
Local xAtuC7 := .T.
Local xNLib

cPedido	:=Alltrim(oProcess:oHtml:RetByName('C7_NUM'))
cAprov	:=Alltrim(oProcess:oHtml:RetByName('OPC'))
cObs	:=Alltrim(oProcess:oHtml:RetByName('OBS'))

RpcSetType(3)
RpcSetEnv("01","01",,,,GetEnvServer(,{}))
RpcSetType(3)

    If cAprov == "S"

	//Abre a tabela de pedidos bloqueados para dar as devidas tratativas
	DBSelectarea("SCR")
	DBSetorder(1)
	DbGoTop()
	
	//==================================================================================================
	//Libera bloqueados
        If DBSeek(xFilial("SCR")+"PC"+cPedido)
            While !eof() .and. SCR->CR_FILIAL == xFilial("SCR") .and. ALLTRIM(SCR->CR_NUM) == cPedido
			
                If SCR->CR_STATUS == "02"
				RecLock("SCR",.f.)
				SCR->CR_DATALIB := dDataBase
				SCR->CR_STATUS  := "03"
				SCR->CR_OBS		:=cObs
				MsUnLock()
				
				//==================================================================================================
				//Bloqueia os aguardando...
                ElseIf	SCR->CR_STATUS == "01" //Caso ainda  existam itens esperando aprovação
				xAtuC7:=.F.
				RecLock("SCR",.f.)
				SCR->CR_DATALIB := dDataBase
				SCR->CR_STATUS  := "02"
				SCR->CR_OBS		:=cObs
				MsUnLock()
//				xNLib:=.T.
				Exit
                EndIf
			
			DbSkip()
            EndDo()
        EndIf
	DbCloseArea("SCR")

	//==================================================================================================
	//Marca tabela SC7, caso totalmente liberado
        If xAtuC7
		
		dbselectarea("SC7")
		DbSetOrder(1)
            If DBSeek(xFilial("SC7")+cPedido)      // Posiciona o Pedido
                while !EOF() .and. SC7->C7_FILIAL == xFilial("SC7") .and. SC7->C7_NUM == cPedido
				RecLock("SC7",.f.)
				SC7->C7_CONAPRO := "L"
				MsUnLock()
				DBSkip()
                enddo
            EndIf
		dbCloseArea("SC7")
		
        EndIf

	//==================================================================================================
	//Envia mensagem de aviso de liberação
	U_3ProcWF(cPedido)
	
    Else
ConOut("##>>>>>>>>>>>>>>> ENTROU NO APROVA NAO")
	//==================================================================================================
	//Abre a tabela de pedidos bloqueados para dar as devidas tratativas
	DBSelectarea("SCR")
	DBSetorder(1)
        If DBSeek(xFilial("SCR")+"PC"+cPedido)
		
            While !eof() .and. SCR->CR_FILIAL == xFilial("SCR") .and. SCR->CR_NUM == cPedido
			
                If SCR->CR_STATUS == "02"
				RecLock("SCR",.f.)
				SCR->CR_DATALIB := dDataBase
				SCR->CR_STATUS  := "04"
				SCR->CR_OBS		:=cObs
				MsUnLock()
                Endif
			
			Dbskip()
            Enddo
		
        Endif

U_4ProcWF(cPedido)	

    EndIf

Return


//ENVIA EMAIL PARA O COMPRADOR COM PEDIDO APROVADO
User Function 3ProcWF(cNum)

Local oProcess
Local cComprador 	:= ""
Local _cMailcompr	:= ""
//==================================================================================================
//Inicia Processo
oProcess 	:= TWFProcess():New( "100100", "Resultado do Pedido de Compras" )
cCodProcesso := "100100"
cHtmlModelo := "\workflow\aprov.htm"
cAssunto := "Aprovação do Pedido de Compra"
cUsuarioProtheus:= SubStr(cUsuario,7,15)
oProcess := TWFProcess():New(cCodProcesso, cAssunto) 
oProcess:NewTask(cAssunto, cHtmlModelo)

	
dbselectarea("SC7")
DbSetOrder(1)
dbSeek(xFilial("SC7")+cNum)      // Posiciona o Pedido

    If PswSeek(C7_USER, .T.)				// .T.=Pesquisa Usuarios, .F.=Pesquisa Grupos
	_aDadosUser := PswRet(1)            	// Array com os Dados do Usuario
	cComprador := _aDadosUser[1,4]
	_cMailcompr := _aDadosUser[1,14]
    Endif

oProcess:oHtml:ValByName( "Num"			, SC7->C7_NUM						)
oProcess:oHtml:ValByName( "Emissao"		, SC7->C7_EMISSAO 					)
oProcess:oHtml:ValByName( "Req"			, cComprador						)

    While !Eof() .and. SC7->C7_FILIAL == xFIlial("SC7") .and. SC7->C7_NUM == cNum

	AAdd( (oProcess:oHtml:ValByName( "it.item" )),SC7->C7_ITEM )
	AAdd( (oProcess:oHtml:ValByName( "it.cod" )),SC7->C7_PRODUTO )
	AAdd( (oProcess:oHtml:ValByName( "it.desc" )),SC7->C7_DESCRI )

	dbSkip()
    Enddo


    If Empty(_cMailcompr)
	Return
    Endif

oProcess:cSubject := cAssunto
//Finaliza processo
//oProcess:ClientName( Subs(cUsuario,7,15))
oProcess:cTo := _cMailcompr//+";felipe.vieira@mvgconsultoria.com.br;ricardo.souza@mvgconsultoria.com.br"

oProcess:Start()

Return


//ENVIA EMAIL PARA O COMPRADOR COM PEDIDO REJEITADO
User Function 4ProcWF(cNum)

Local oProcess
Local cComprador 	:= ""
Local _cMailcompr	:= ""
//==================================================================================================
//Inicia Processo
oProcess 	:= TWFProcess():New( "100100", "Resultado do Pedido de Compras" )
cCodProcesso := "100100"
cHtmlModelo := "\workflow\reprov.htm"
cAssunto := "Aprovação do Pedido de Compra"
cUsuarioProtheus:= SubStr(cUsuario,7,15)
oProcess := TWFProcess():New(cCodProcesso, cAssunto) 
oProcess:NewTask(cAssunto, cHtmlModelo)

	
dbselectarea("SC7")
DbSetOrder(1)
dbSeek(xFilial("SC7")+cNum)      // Posiciona o Pedido

    If PswSeek(C7_USER, .T.)				// .T.=Pesquisa Usuarios, .F.=Pesquisa Grupos
	_aDadosUser := PswRet(1)            	// Array com os Dados do Usuario
	cComprador := _aDadosUser[1,4]
	_cMailcompr := _aDadosUser[1,14]
    Endif

oProcess:oHtml:ValByName( "Num"			, SC7->C7_NUM						)
oProcess:oHtml:ValByName( "Emissao"		, SC7->C7_EMISSAO 					)
oProcess:oHtml:ValByName( "Req"			, cComprador						)

    While !Eof() .and. SC7->C7_FILIAL == xFilial("SC7") .and. SC7->C7_NUM == cNum

	AAdd( (oProcess:oHtml:ValByName( "it.item" )),SC7->C7_ITEM )
	AAdd( (oProcess:oHtml:ValByName( "it.cod" )),SC7->C7_PRODUTO )
	AAdd( (oProcess:oHtml:ValByName( "it.desc" )),SC7->C7_DESCRI )

	dbSkip()
    Enddo


    If Empty(_cMailcompr)
	Return                                                                                                                         
    Endif

oProcess:cSubject := cAssunto
//Finaliza processo
//oProcess:ClientName( Subs(cUsuario,7,15))
oProcess:cTo := _cMailcompr//+";felipe.vieira@mvgconsultoria.com.br;ricardo.souza@mvgconsultoria.com.br"

oProcess:Start()

Return
