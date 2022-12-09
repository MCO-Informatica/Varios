/*
Neste exemplo vamos usar a função que tem o mesmo objetivo da XmlParser, a diferença é que esta lê um arquivo do disco com a extensão .xml. 
Quando passamos a string informando o path do arquivo em disco, devemos lembrar que a procura do arquivo será feita através do rootpath do Protheus.
logo após a leitura do arquivo a função irá montar o objeto analisando se a sintaxe e a ordem das tags está bem formada, 
caso isso não ocorra a função irá retonar um warning ou até um possível erro, nos parametros informados por referência.Caso isso nao ocorra 
a função irá retornar o objeto contendo uma estrutura em forma de arvore, no caso a mesma estrutura do xml.
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