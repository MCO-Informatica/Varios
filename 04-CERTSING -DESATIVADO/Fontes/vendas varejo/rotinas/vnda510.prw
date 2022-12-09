#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VNDA510   ºAutor  ³Opvs (David)        º Data ³  06/02/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina de Consulta e seleção de campos no SX3         º±±
±±º          ³                                                            º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function VNDA510(cCodAlias)
Local aArea		:= GetArea()
Local cTitDlg		:= "Seleção de Dados de Dicionário"
Local cReturn	:= ""	
Local aDadSel	:= {}
Local cDadRet	:= ""
Local cIniAlias	:= ""

Default cCodAlias := ""

//Verifica se foi informado alias de procura
If !Empty(cCodAlias)
	DbSelectArea("SX3")
	SX3->(DbSetOrder(1))
	
	If SX3->(DbSeek(cCodAlias)) 
		CursorWait()
 		//Alimenta array de dados a serem mostrados na tela
 		While !SX3->(EoF()) .and.  SX3->X3_ARQUIVO == cCodAlias
   			AADD(aDadSel,SX3->X3_CAMPO + "-"+SX3->X3_TITULO+": "+SX3->X3_DESCRIC)			
   			cDadRet	+= SX3->X3_CAMPO 
   			SX3->(DbSkip())	
   		EndDo
   		CursorArrow()
   		
   		//executa função de tela de multi-seleção de dados
   		f_opcoes(@cReturn,cTitDlg,aDadSel,cDadRet,Nil,Nil,.F.,10,len(aDadSel))
   		
   		//tratamento de retorno da funçao
   		cReturn := StrTran(cReturn,"*","")
   		cIniAlias:= Alltrim(SubStr(cReturn,1,At("_",cReturn)))
		//insere no retorno separadores de ","
		If !Empty(cIniAlias)
			cReturn := StrTran(cReturn,cIniAlias,","+cIniAlias)
			cReturn := IIf(SubStr(cReturn,1,1) == ",", SubStr(cReturn,2),cReturn)
		EndIf
   		
 	Else
 		MsgAlert("Não foi informado Alias válido para pesquisa de Seleção de Dados")
 	EndIf
	
Else
	MsgAlert("Não foi informado Alias para Seleção de Dados")
EndIf

RestArea(aArea)

Return(cReturn)