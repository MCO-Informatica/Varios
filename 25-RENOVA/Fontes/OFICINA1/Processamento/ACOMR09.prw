#include "topconn.ch"
#include "protheus.ch"
#INCLUDE "FILEIO.CH"
#INCLUDE "APWEBSRV.CH"   

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ACOMR09   ºAutor  ³Felipi Marques      º Data ³  05/31/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³   Função que configura de acordo com a entidade o          º±±
±±º          ³ certificado decomunicação SSL utilizado pelo server.       º±±
±±º          ³ TSSConfigSSL                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±± 
±±ºRetorno   ³ Array com o retorno dos certificados e senha               º±±
±±º          ³ 	aReturn[1] -> Certificado _All.pem                        º±±
±±º          ³	aReturn[2] -> Certificado _Key.pem                        º±±
±±º          ³	aReturn[3] -> Senha do certificado                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function ACOMR09(cEntidade, cErro, oWs)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cCertDir     	:= IIf(IsSrvUnix(),"/certs/", "\certs\") 
Local cPassCrt    	:= "" 
Local cFilePemKey	:= ""
Local cFilePemAll	:= ""
Local aReturn		:= {}
Local cAliasSpd 	:= GetNextAlias()
Local nCon          := 0
Local nAnt          := 0
Local lRotAuto      := .T.

DEFAULT cEntidade   := ""  
DEFAULT cErro		:= "" 
DEFAULT oWs			:= NIL 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Busca a senha na tabela de edentidades³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("Z05")
Z05->(DbSetOrder(1))   
IF Z05->(dbSeek(xFilial("Z05")+Alltrim(cIdEnt) )) 
	cPassCrt := Alltrim(Z05-> Z05_SENHA)
Else
	Conout( "| ACOMR09 | Não encontrado o cadastro da endidade" ) 
EndIf

/*Monta o nome dos arquivos dos certificados de acordo com a entidade*/
cFilePemKey	:= cCertDir+cEntidade+"_key.pem"
cFilePemAll	:= cCertDir+cEntidade+"_all.pem" 
 
/*Verifica se existi os certificados para retornar*/
If ( File(cFilePemKey) .And. File(cFilePemAll) ) 
	aAdd(aReturn,cFilePemAll)
	aAdd(aReturn,cFilePemKey)
	aAdd(aReturn,AllTrim(  cPassCrt  )) 
		
	/*Caso o WS tenha sido passado no parâmetro é atribuído*/
	If ( oWs <>  NIL )      
		oWs:_CERT			:= cFilePemAll
		oWs:_PRIVKEY		:= cFilePemKey
		oWs:_PASSPHRASE		:= AllTrim(cPassCrt)	 		
	EndIf
Else
		Conout(CRLF + CRLF + "Verificar se os arquivos "+ cFilePemKey + " e " + cFilePemAll +" estao no diretorio "+ cCertDir + " ou se existem." + CRLF)
EndIf
		
Return aReturn