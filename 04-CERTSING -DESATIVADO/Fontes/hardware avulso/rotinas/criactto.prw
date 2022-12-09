#INCLUDE "PROTHEUS.CH" 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CRIACTTO  ºAutor  ³Microsiga           º Data ³  05/05/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao criada para fazer a inclusao de contato via          º±±
±±º          ³webservice.                                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ OPVS Consultores Associados                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CriaCtto(cXCPF, aDados)

//------------//
//aDados      //
//[1] cNome   //
//[2] cCpf    //
//[3] cEmail  //
//[4] cSenha  //
//[5] cFone   //
//------------//

Local aContato		:= {}
Local nOpc			:= 3
Local cCodCtto		:= ""
Local cNomeCtto		:= ""
Local cCPF			:= ""
Local cEndereco		:= ""
Local cBairro		:= ""
Local cMunicipio	:= ""
Local cEstado		:= ""
Local cCEP			:= ""
Local cDDD			:= ""
Local cFone			:= ""
Local cCelular		:= ""
Local cCEP			:= ""
Local cSenhaPort	:= ""
Local cEmail		:= ""
Local lRet			:= .T.
Local cMsg			:= ""

Private lMsErroAuto := .F.
Private lAutoErrNoFile	:= .T.	// variavel interna da rotina automatica MSExecAuto()   

cNomeCtto	:= AllTrim(aDados[1])
cCPF		:= AllTrim(aDados[2])
cEmail		:= AllTrim(aDados[3])
cSenhaPort	:= aDados[4]
cDDD		:= SubStr(aDados[5],1,2)
cFone		:= SubStr(aDados[5],3,8)

DbSelectArea("SU5")
SU5->(DbSetOrder(8))
If SU5->(DbSeek(xFilial("SU5") + cCPF))		// Caso o sistema ache o contato, o mesmo faz a atualizacao do mesmo
	//Faco a alteracao na mao, pois a execauto na alteracao desposiciona do registro da tabela SU5
	RecLock("SU5", .F.)
		SU5->U5_CONTAT	:= cNomeCtto	// Nome do contato
		SU5->U5_END		:= cEndereco  	// Endereço residencial do contato
		SU5->U5_BAIRRO	:= cBairro    	// Bairro do endereço do contato.
		SU5->U5_MUN		:= cMunicipio 	// Municipio do contato
		SU5->U5_EST		:= cEstado    	// Estado do contato
		SU5->U5_CEP		:= cCEP       	// CEP do contato
		SU5->U5_DDD		:= cDDD       	// DDD do contato
		SU5->U5_FONE	:= cFone      	// Telefone residencial do contato
		SU5->U5_CELULAR	:= cCelular		// Celular do contato
		SU5->U5_XSENHA	:= cSenhaPort	// Senha do Portal
    	SU5->U5_EMAIL	:= cEmail     	// E-mail do Contato
	SU5->(MsUnLock())
Else		// Caso o sistema nao ache o contato, o sistema faz a inclusao do mesmo
	nOpc := 3
	
	cNumCont := GetSxeNum("SU5", "U5_CODCONT")		// Pega o proximo numero de contato valido
	ConfirmSX8()									// Confirma o uso do codigo de contato
	
	aContato:={ 	{"U5_CODCONT"	,cNumCont		,Nil},; // Codigo do contato
					{"U5_CONTAT"    ,cNomeCtto		,Nil},; // Nome do contato
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
	MSExecAuto({|x,y| TmkA070(x,y)},aContato,nOpc)
EndIf

cContSite := SU5->U5_CODCONT

If lMsErroAuto
	MOSTRAERRO()
	lRet := .F.
	cMsg := 'Contato não pôde ser incluído.'

	cAutoErr := "SU5 --> Erro de inclusão de contato no sistema Protheus MSExecAuto({|x,y| TmkA070(x,y)},aContato,nOpc)" + CRLF + CRLF
	cAutoErr += VarInfo("",aContato,,.f.,.f.) + CRLF + CRLF
	aAutoErr := GetAutoGRLog()
	For nI := 1 To Len(aAutoErr)
		cAutoErr += aAutoErr[nI] + CRLF
	Next nI
	cMsg += cAutoErr 
	DisarmTransaction()
Else
	lRet := .T.
	cMsg := 'Contato incluído com sucesso'
EndIf

Return({lRet, cMsg})