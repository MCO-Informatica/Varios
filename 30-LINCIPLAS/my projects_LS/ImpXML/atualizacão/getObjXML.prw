/*
Neste exemplo vamos usar a fun��o que tem o mesmo objetivo da XmlParser, a diferen�a � que esta l� um arquivo do disco com a extens�o .xml. 
Quando passamos a string informando o path do arquivo em disco, devemos lembrar que a procura do arquivo ser� feita atrav�s do rootpath do Protheus.
logo ap�s a leitura do arquivo a fun��o ir� montar o objeto analisando se a sintaxe e a ordem das tags est� bem formada, 
caso isso n�o ocorra a fun��o ir� retonar um warning ou at� um poss�vel erro, nos parametros informados por refer�ncia.Caso isso nao ocorra 
a fun��o ir� retornar o objeto contendo uma estrutura em forma de arvore, no caso a mesma estrutura do xml.
*/
#INCLUDE "TOTVS.CH"
#INCLUDE "XMLXFUN.CH"      

User Function getObjXML()	

Local cError   := ""	
Local cWarning := ""		
Local oXml := NIL	
Local cFile := ""	        	//a partir do rootpath do ambiente	
cFile := "\XML_teste\procNFE35130203555225000100550200004118461313127254AUT.xml"
oXml1 := XmlParserFile( cFile, "_", @cError, @cWarning )	//acessando o CONTEUDO do meu nodo ""	
oXml2 := XmlParser( cFile, "_", @cError, @cWarning )	//acessando o CONTEUDO do meu nodo ""	

Return oXml