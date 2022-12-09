#include "totvs.ch"

User Function CSTA130

Local aImage:= {}
Local aHead := {}
Local aCols := {}
Local nAtual:= 1
Local oRestClient 
Private aDados
Private oDlg
Private oTIBrowser
Private oLista
Private TButton

//SetNoProxyFor( "https://rimg-homolog.certisign.com.br" )

oRestClient :=FWRest():New(GetNewPar("MV_CST130A","http://rimg-homolog.certisign.com.br")) //Link Base
oRestClient:setPath(GetNewPar("MV_CST130B","/rimg/ws/pasta/25/conteudo")) //Pasta das imagens

//Verifica se conseguiu fazer o get com o JSON
If oRestClient:Get()
   FWJsonDeserialize(oRestClient:GetResult(),@aDados) //Adiciona retorno para um array
Else
   Alert("Não foi possível se conectar ao serviço de imagens, erro: " +oRestClient:GetLastError())
   Return .F.
Endif

If Len(aDados) == 0
	Alert("Não existe imagens no repositório informado!")
   Return .F.
Endif

For nI := 1 To Len(aDados)
	
	//Adiciona dados no aCols
	AADD(aCols,{aDados[nI]:NOME,.F.})
	
	If !Empty(M->PA8_IMAGEM) .And. RTrim(M->PA8_IMAGEM) == aDados[nI]:NOME
		nAtual := nI
	Endif
	
Next

//Cria o cabecalho da GetDados
aHead := fHeader()

 DEFINE DIALOG oDlg TITLE "Imagens do Checkout" FROM 180,180 TO 550,700 PIXEL
 
 
 	oTIBrowser := TIBrowser():New(0,100,260,170, StrTran(aDados[nAtual]:URL,"http:","https:") , oDlg )
 	
 	//Monta o browser com inclusão, remoção e atualização
	oLista 	:= MsNewGetDados():New(0,0,170,100,,,,,,,Len(aCols),,,,oDlg,aHead,aCols,{||fValida()})
	oLista:nAt	:= nAtual
          
    // Disponível apenas em versões superiores a 7.00.170117A - 17.2.0.2
    TButton():New( 172, 010, "Selecionar"	, oDlg,{|| fGravar() },040,010,,,.F.,.T.,.F.,,.F.,,,.F. )
    TButton():New( 172, 060, "Cancelar"	, oDlg,{|| oDlg:end()},040,010,,,.F.,.T.,.F.,,.F.,,,.F. )
          
ACTIVATE DIALOG oDlg CENTERED

Return .T.

Static Function fHeader()

Local aAux		:= {}
Local aCampos	:= {}

//Adiciona os campos que devem ser adicionados na GetDados
AADD(aCampos,"PA8_IMAGEM")

For nI := 1 To Len(aCampos)

	SX3->( DbSetOrder(2) )
	If SX3->( MsSeek( aCampos[nI] ) )
		
		Aadd(aAux, {	SX3->X3_TITULO,;
						SX3->X3_CAMPO,;
						SX3->X3_PICTURE,;
						SX3->X3_TAMANHO,;
						SX3->X3_DECIMAL,;
						SX3->X3_VALID,;
						SX3->X3_USADO,;
						SX3->X3_TIPO,;
						SX3->X3_F3,;
						SX3->X3_CONTEXT } )
	Endif
Next

Return(aAux)

//Altera a imagem do TiBrowser
Static Function fValida()

oTIBrowser:Navigate( StrTran(aDados[oLista:nAt]:URL,"http:","https:") )
	
Return .T.

//Grava a imagem selecionada
Static Function fGravar()

M->PA8_IMAGEM := aDados[oLista:nAt]:NOME

//Fecha tela de selecao
oDlg:End()

Return 

//Renato Ruy - 27/03/2018
//Parametros para base de imagem checkout.
User Function CSTA130P()

Local aRet 		:= {}
Local bValid  	:= {|| .T. }
Local aPar 		:= {}
Local cMsg			:= ""

//Utilizo parambox para fazer as perguntas
aAdd( aPar,{ 1  ,"Link Base " 	 	,PadR(GetMv("MV_CST130A"),100," "),"","","","",150,.F.})
aAdd( aPar,{ 1  ,"Path Rest"	 	,PadR(GetMv("MV_CST130B"),100," "),"","","","",150,.F.})
aAdd( aPar,{ 1  ,"Path Imagem"		,PadR(GetMv("MV_CSTA60A"),100," "),"","","","",150,.F.})


If ParamBox( aPar, 'Parâmetros', @aRet, bValid, , , , , ,"CSTA130P" , .T., .F. )
	
	If AllTrim(aRet[1]) <> RTrim(GetMv("MV_CST130A"))
		PutMv("MV_CST130A",AllTrim(aRet[1]))
		cMsg += "[ Link Base		]" + chr(13)+chr(10)
	Endif 
	
	If AllTrim(aRet[2]) <> RTrim(GetMv("MV_CST130B"))
		PutMv("MV_CST130B",AllTrim(aRet[2]))
		cMsg += "[ Path Rest		]" + chr(13)+chr(10)
	Endif 
	
	If AllTrim(aRet[3]) <> RTrim(GetMv("MV_CSTA60A"))
		PutMv("MV_CSTA60A",AllTrim(aRet[3]))
		cMsg += "[ Path Imagem	]" + chr(13)+chr(10)
	Endif 
	
	If !Empty(cMsg)
		MsgInfo("As informações foram alteradas com Sucesso!"+ chr(13)+chr(10)+cMsg)
	Else
		MsgInfo("Não foram efetuadas alterações nos parâmetros!")
	Endif
	
Else
	Alert("Rotina Cancelada!")
EndIf

Return