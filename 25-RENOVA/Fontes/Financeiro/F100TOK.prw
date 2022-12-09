#INCLUDE "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³F100TOK  ºAutor  ³                				25/08/2015º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Validação de entidades 05 para naturezas financeiras:       º±±
±±           ³"2513/2501/2506/2508/2604/1204"                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Renova                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

// (09/09/2021) - Alterado por Luiz - Ajustadas mensagens de inconsitências conforme planilha recebida em 09/09/2021

User Function F100TOK()

Local _lRet := .T.
Local cMsg  := ""
Local cNaturezas := "1204,2006,2301,2310,2311,2338,2341,2341,2342,2343,2347,2351,2408"
cNaturezas += "2408,2409,2410,2412,2416,2421,2501,2508,2512,2513,2514,2516,2521,2604,3103,3107,3203"

If ALLTRIM(M->E5_NATUREZ) $ cNaturezas
 
	If Empty(M->E5_ITEMD)		
		cMsg := "Para essa Natureza, a Entidade Contábil Projeto deve ser preenchida!"
		MessageBox(cMsg,"Erro preenchimento Projeto",16)
		_lRet := .F.
	EndIf
	
	If Empty(M->E5_CLVLDB)
		cMsg := "Para essa Natureza, a Entidade Contábil Camada deve ser preenchida!"
		MessageBox(cMsg,"Erro preenchimento Camada",16)
		_lRet := .F.
	EndIf
	
	If Empty(M->E5_EC05DB) .and. AllTrim(M->E5_NATUREZ) $ "1204,2310,2311,2338,2501,2508,2513,2514,2516,2521,2604"
		cMsg := "Para Naturezas = 1204,2310,2311,2338,2501,2508,2513,2514,2516,2521,2604"+chr(13)+chr(10)
		cMsg += "A Entidade Contábil Classe Orçamentaria deve ser preenchida!"
		MessageBox(cMsg,"Erro preenchimento Classe Orçamentária",16)
		_lRet := .F.
	EndIf

	If AllTrim(M->E5_NATUREZ) $ "1204,2338,2412,2416,2501,2508,2513,2514,2516,2521,2604,3107" .and. AllTrim(M->E5_CCD) <> "22000"
	   	cMsg := "Para as Naturezas 1204,2338,2412,2416,2501,2508,2513,2514,2516,2521,2604,3107"+chr(13)+chr(10)
	   	cMsg += "A Entidade Contábil Centro de Custo deve ser a 22000"
	   	MessageBox(cMsg,"Erro preenchimento Centro de Custo",16)
		_lRet := .F.
	EndIf 

 	/* Alterado Regra para não controlar centro de custo
	 
	 If AllTrim(M->E5_NATUREZ) $ "2342,2347" .and. Empty(M->E5_CCD)
	 	cMsg := "Para as Naturezas 2342 ou 2347"+chr(13)+chr(10)
		cMsg += "A Entidade Contábil Centro de Custo deve ser informada"
	   	MessageBox(cMsg,"Erro preenchimento Centro de Custo",16)
		_lRet := .F.
	EndIf 
	*/
 	
	 /* Naturezas retiradas da regra conforme planilha atualizada enviada pela Daiane
	 If AllTrim(M->E5_NATUREZ) $ "2310,2311" .and. AllTrim(M->E5_CCD) <> "11000"
	 	cMsg := "Para as Naturezas 2310 ou 2311"+chr(13)+chr(10)
		cMsg += "A Entidade Contábil Centro de Custo deve ser a 11000"
	   	MessageBox(cMsg,"Erro preenchimento Centro de Custo",16)
		_lRet := .F.
	EndIf 
    */

	If AllTrim(M->E5_NATUREZ) $"2006,2301,2341,2341,2342,2343,2347,2351,2408,2409,2410,2421,2512,3103,3203"
		If !Empty(M->E5_CCD)
	 		cMsg := "Para a Natureza: "+AllTrim(M->E5_NATUREZ)+" a entidade Contábil Centro de Custo"+chr(13)+chr(10)
			cMsg += "não deve ser informada, favor limpar o conteúdo do campo antes de confirmar o lançamento"
	   		MessageBox(cMsg,"Erro preenchimento Centro de Custo",16)
			_lRet := .F.
		EndIf
	EndIf 

EndIf

Return(_lRet)
