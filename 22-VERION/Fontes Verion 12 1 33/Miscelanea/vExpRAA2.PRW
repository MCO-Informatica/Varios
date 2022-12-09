#include "rwmake.ch"
#include "protheus.ch"
#include "topconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VEXPRAA2  ºAutor  ³Microsiga           º Data ³  08/27/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Exporta Cadastro de Funcionarios para Cadastro de Fornece-  º±±
±±º          ³dores                                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Verion                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function vExpRAA2()

Local aSays,aButtons,cTitulo,nOpc

aSays    := {}
aButtons := {}
nOpc     := 0
cTitulo  := "Exporta Cadastro de Funcionários para Cadastro de Fornecedores"

aAdd(aSays,"V E R I O N")
aAdd(aSays,"-------------------------------------------------------------------------------------")
aAdd(aSays,"Rotina que exporta ")
aAdd(aSays,"Cadastro de Funcionários para Cadastro de Fornecedores ")

aAdd(aButtons,{1,.t.,{|o|nOpc:=1, o:oWnd:End()}})
aAdd(aButtons,{2,.t.,{|o|nOpc:=2, o:oWnd:End()}})
FormBatch(cTitulo,aSays,aButtons)

If nOpc == 1
	If msgBox("Confirma a exportação do Cadastro de Funcionários para o Cadastro de Fornecedores?","Confirma","YesNo")
		Processa({||ExpRAA2()},"Exportando...")
	EndIf
EndIf

msgInfo("Export concluído com êxito!")

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ExpRAA2   ºAutor  ³Microsiga           º Data ³  08/27/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ExpRAA2()

Begin Transaction

ProcRegua(0)
dbSelectArea("SRA")
SRA->(dbGoTop())
Do While SRA->(!EOF())
	IncProc(SRA->RA_NOME)
	dbSelectArea("SA2")
	dbSetOrder(3) // A2_FILIAL+A2_CGC
	If !dbSeek(xFilial("SA2")+SRA->RA_CIC)
		RecLock("SA2",.t.)
		SA2->A2_FILIAL  := xFilial("SA2")
		SA2->A2_LOJA    := "01"
		SA2->A2_NOME    := SRA->RA_NOME
		SA2->A2_NREDUZ  := SRA->RA_NOME
		SA2->A2_END     := SRA->RA_ENDEREC
		SA2->A2_BAIRRO  := SRA->RA_BAIRRO
		SA2->A2_MUN     := SRA->RA_MUNICIP
		SA2->A2_EST     := SRA->RA_ESTADO
		SA2->A2_CEP     := SRA->RA_CEP
		SA2->A2_TIPO    := "F"
		SA2->A2_CGC     := SRA->RA_CIC
		SA2->A2_PFISICA := SRA->RA_RG
		SA2->A2_TEL     := SRA->RA_TELEFON
		SA2->A2_EMAIL   := SRA->RA_EMAIL
		SA2->A2_INSCR   := "ISENTO"
		SA2->A2_MSBLQL  := "2" // NAO
		SA2->A2_BANCO   := Left(SRA->RA_BCDEPSA,3)
		SA2->A2_AGENCIA := Right(SRA->RA_BCDEPSA,4)
		SA2->A2_NUMCON  := SRA->RA_CTDEPSA
		SA2->A2_COD     := GETSXENUM("SA2","A2_COD")
		SA2->(msUnLock())
	EndIf
	SRA->(dbSkip())
EndDo

End Transaction

Return
