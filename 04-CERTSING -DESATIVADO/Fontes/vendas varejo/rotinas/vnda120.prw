#INCLUDE "PROTHEUS.CH"
#include "ap5mail.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VNDA120  ºAutor  ³Microsiga           º Data ³  05/05/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao criada para fazer a inclusao de contato via          º±±
±±º          ³webservice.                                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAlterado  ³ Data     ³ Descricao                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±                                                                             
±±ºAlceu P.  ³09/11/2011³Inclusao da chamada para a funcao GTPUTIN. #1    º±± 
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ OPVS Consultores Associados                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function VNDA120(cXCPF, aDados, cNpSite, cID, lMail, cPedLog)

//------------//
//aDados      //
//[1] cNome   //
//[2] cCpf    //
//[3] cEmail  //
//[4] cSenha  //
//[5] cFone   //
//------------//

Local aContato	:= {}
Local nOpc			:= 3
Local cCodCtto	:= ""
Local cNomeCtto	:= ""
Local cCPF			:= ""
Local cEndereco	:= ""
Local cBairro		:= ""
Local cMunicipio	:= ""
Local cEstado		:= ""
Local cCEP			:= ""
Local cDDD			:= ""
Local cFone		:= ""
Local cCelular	:= ""
Local cCEP			:= ""
Local cSenhaPort	:= ""
Local cEmail		:= ""
Local lRet			:= .T.
Local cMsg			:= ""
Local cCorpo		:= ""
Local aAutoErr   := {}
Local nI			:= 0 
Local cDados     := ""
Local cSubjInc := Alltrim(GetMv("VNDA120_IN",,""))
Local cSubjAlt := Alltrim(GetMv("VNDA120_AL",,""))

Private lMsErroAuto := .F.   
Private lAutoErrNoFile	:= .T.	// variavel interna da rotina automatica MSExecAuto()

Default lMail		:= .F.
DEFAULT cNpSite := ""    
DEFAULT cPedLog := ""     //#1

cNomeCtto	:= AllTrim(aDados[1])
cCPF		:= AllTrim(aDados[2])
cEmail		:= AllTrim(aDados[3])
cSenhaPort	:= aDados[4]
cDDD		:= SubStr(aDados[5],1,2)
cFone		:= Alltrim(SubStr(aDados[5],3))

DbSelectArea("SU5")
SU5->(DbSetOrder(8))
If	SU5->(DbSeek(xFilial("SU5") + cCPF)) 		// Caso o sistema ache o contato, o mesmo faz a atualizacao do mesmo
	If (	UPPER(Alltrim(SU5->U5_CONTAT))	<> UPPER(Alltrim(cNomeCtto)) 	.or.; // Nome do contato
			Alltrim(SU5->U5_DDD)				<> Alltrim(cDDD)       			.or.; // DDD do contato
			Alltrim(SU5->U5_FONE)			<> Alltrim(cFone)      			.or.; // Telefone residencial do contato
			Alltrim(SU5->U5_EMAIL)			<> Alltrim(cEmail)             .or.; // E-mail do Contato
			Alltrim(SU5->U5_XSENHA)        <> Alltrim(cSenhaPort)         )     // Senha do Contato*/
	
		//Faco a alteracao na mao, pois a execauto na alteracao desposiciona do registro da tabela SU5
		RecLock("SU5", .F.)
			SU5->U5_CONTAT := cNomeCtto	 // Nome do contato
			SU5->U5_DDD    := cDDD      // DDD do contato
			SU5->U5_FONE   := cFone     // Telefone residencial do contato
			SU5->U5_XSENHA := cSenhaPort// Senha do Portal
	    	SU5->U5_EMAIL  := cEmail    // E-mail do Contato
	   SU5->(MsUnLock())
	
		lMail := .F. // será tratada pelo e-commerce Sales Force
		If lMail
			cDados := cNomeCtto +';'+ cCPF +';'+ cDDD + cFone +';'+ cEmail  
			cCorpo := U_VNDA730( cDados, 'VNDA120A.htm'  )  //Monta o layout do e-mail
		     //Envio e-mail para o contato com os dados de inclusao do cadastro
		 	U_VNDA290(cCorpo, cEmail, cSubjAlt)
		EndIf
		
		U_GTPutIN(cID,"O",cPedLog,.T.,{"U_VNDA120",cPedLog,"Alterando Contato","Nome: " + cNomeCtto + " CPF: " + Alltrim(cCPF) + " E-mail: " + AllTrim(cEmail) + " Senha: " + cSenhaPort + " Fone: " + cDDD + cFone},cNpSite)
    EndIf
Else		// Caso o sistema nao ache o contato, o sistema faz a inclusao do mesmo
	nOpc := 3
	
	aContato:={ 	{"U5_CONTAT"    ,cNomeCtto		,Nil},; // Nome do contato
					{"U5_CPF"       ,cCPF       	,Nil},; // CPF do contato. 
					{"U5_END"       ,cEndereco  	,Nil},; // Endereço residencial do contato
					{"U5_BAIRRO"    ,cBairro    	,Nil},; // Bairro do endereço do contato.
					{"U5_MUN"       ,cMunicipio 	,Nil},; // Municipio do contato
					{"U5_EST"       ,cEstado    	,Nil},; // Estado do contato
					{"U5_CEP"       ,cCEP       	,Nil},; // CEP do contato
					{"U5_DDD"       ,cDDD       	,Nil},; // DDD do contato
					{"U5_FONE"      ,cFone      	,Nil},; // Telefone residencial do contato
					{"U5_CELULAR"   ,cCelular		,Nil},; // Celular do contato
					{"U5_XSENHA"    ,cSenhaPort		,Nil},; // Senha do Portal
			    	{"U5_EMAIL"     ,cEmail     	,Nil}} // E-mail do Contato

	U_GTPutIN(cID,"O",cPedLog,.T.,{"U_VNDA120",cPedLog,"Incluindo Contato",aContato},cNpSite)
	
	MSExecAuto({|x,y| TmkA070(x,y)},aContato,nOpc)

	ConfirmSX8()	// Confirma o uso do codigo de contato
	
	lMail := .F. // será tratada pelo e-commerce Sales Force
	If lMail
		cDados := cNomeCtto +';'+ cCPF +';'+ cDDD + cFone +';'+ cEmail  
		cCorpo := U_VNDA730( cDados, 'VNDA120I.htm'  ) //Monta o layout do e-mail
		// Envio e-mail para o contato com a alteração dos dados cadastrais
		U_VNDA290(cCorpo, cEmail, cSubjInc)
	EndIf
EndIf

cContSite := SU5->U5_CODCONT

If lMsErroAuto 
	cMsg := "SU5 --> Erro de inclusão de contato na rotina padrão do sistema Protheus MSExecAuto({|x, y| Tmka070(x, y)}, aContato, nOpc)" + CRLF + CRLF
	aAutoErr := GetAutoGRLog()
	For nI := 1 To Len(aAutoErr)
		cMsg += aAutoErr[nI] + CRLF
	Next nI

	U_GTPutOUT(cID,"O",cPedLog,{"CONTATO",{.F.,"E00005",cPedLog,cMsg}},cNpSite)
	   
	lRet := .F.
	Return(lRet,cMsg)
Else
	cMsg := 'Contato incluído com sucesso' 
	
	U_GTPutOUT(cID,"O",cPedLog,{"CONTATO",{.T.,"M00001",cPedLog,cMsg}},cNpSite)
	
Endif

Return({lRet, cMsg})