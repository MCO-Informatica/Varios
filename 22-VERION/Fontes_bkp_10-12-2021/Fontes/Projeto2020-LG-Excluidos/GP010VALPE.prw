#include "rwmake.ch"
#include "protheus.ch"
#include "topconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GP010VALPEºAutor  ³Microsiga           º Data ³  08/27/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada, p/ incluir fornecedores funcionarios      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Verion                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function GP010VALPE()

Local lRet, aFunc
Private lmsErroAuto, lmsHelpAuto

lRet  := .t.
aFunc := {}

If INCLUI
	dbSelectArea("SA2")
	dbSetOrder(3) // A2_FILIAL+A2_CGC
	If !dbSeek(xFilial("SA2")+M->RA_CIC)
		
		aAdd(aFunc, {"A2_FILIAL " , xFilial("SA2")             , Nil})
		aAdd(aFunc, {"A2_LOJA   " , "01"                       , Nil})
		aAdd(aFunc, {"A2_NOME   " , M->RA_NOME                 , Nil})
		aAdd(aFunc, {"A2_NREDUZ " , M->RA_NOME                 , Nil})
		aAdd(aFunc, {"A2_END    " , M->RA_ENDEREC              , Nil})
		aAdd(aFunc, {"A2_BAIRRO " , M->RA_BAIRRO               , Nil})
		aAdd(aFunc, {"A2_MUN    " , M->RA_MUNICIP              , Nil})
		aAdd(aFunc, {"A2_EST    " , M->RA_ESTADO               , Nil})
		aAdd(aFunc, {"A2_CEP    " , M->RA_CEP                  , Nil})
		aAdd(aFunc, {"A2_TIPO   " , "F"                        , Nil})
		aAdd(aFunc, {"A2_CGC    " , M->RA_CIC                  , Nil})
		aAdd(aFunc, {"A2_PFISICA" , M->RA_RG                   , Nil})
		aAdd(aFunc, {"A2_TEL    " , M->RA_TELEFON              , Nil})
		aAdd(aFunc, {"A2_EMAIL  " , M->RA_EMAIL                , Nil})
		aAdd(aFunc, {"A2_INSCR  " , "ISENTO"                   , Nil})
		aAdd(aFunc, {"A2_MSBLQL " , "2"                        , Nil})
		aAdd(aFunc, {"A2_BANCO  " , Left(M->RA_BCDEPSA,3)     , Nil})
		aAdd(aFunc, {"A2_AGENCIA" , Right(M->RA_BCDEPSA,4)    , Nil})
		aAdd(aFunc, {"A2_NUMCON " , M->RA_CTDEPSA             , Nil})
		aAdd(aFunc, {"A2_COD    " , GETSXENUM("SA2","A2_COD") , Nil})
		
		lmsErroAuto := .f.
		lmsHelpAuto := .t.
		msExecAuto({|x,y| Mata020(x,y)}, aFunc, 3)
		lmsHelpAuto := .f.
		
		If lmsErroAuto
			DisarmTransaction()
			MostraErro()
			lRet := .f.
		EndIf
	
	Else
		//msgStop("CPF já existente no Cadastro de Fornecedores... Checar!")
		If MsgYesNo("CPF já existente no Cadastro de Fornecedores. Deseja realmente continuar?","GP010VALPE")
			lRet := .T.
		Else
			lRet := .f.	
		Endif
	EndIf
EndIf

Return lRet