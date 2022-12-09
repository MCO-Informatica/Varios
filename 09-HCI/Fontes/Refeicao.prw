#INCLUDE "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ Refeicao º Autor ³ Eduardo Porto      º Data ³  21/07/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Programa para o calculo do desconto de Refeicao            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function Refeicao()        // incluido pelo assistente de conversao do AP5 IDE em 29/09/00

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("cCodRef,nVal1")
SetPrvt("nPerc1,nTeto1,nDescRef, nSalBas,cCodRef")

nSalBas := (SRA->RA_SALARIO/30)*DiasTrab 
cValeRef := SRA->RA_VALEREF

If ! Empty(SRA->RA_VALEREF) 

	cCodRef := "568" // Desconto Empregado Refeitório

	DbSelectArea("SRX")
	
	If DbSeek(xFilial()+"26"+SRA->RA_FILIAL+SRA->RA_VALEREF) // PESQUISA A FILIAL DO CADASTRO
	      nVal1   := val(substr(rx_txt,21,12))
	      nQuant1  := val(substr(rx_txt,34,2))
	      nPerc1  := val(substr(rx_txt,36,6))
	      nTeto1  := val(substr(rx_txt,43,12))
	ElseIf DbSeek(xFilial()+"26  "+SRA->RA_VALEREF)             // SE NAO ACHAR, PESQUISA FILIAL EM BRANCO
	      nVal1   := val(substr(rx_txt,21,12))
	      nQuant1 := val(substr(rx_txt,34,2))
	      nPerc1  := val(substr(rx_txt,36,6))
	      nTeto1  := val(substr(rx_txt,43,12))
	EndIf

    If cValeRef == "01"
		nDescRef := (nSalBas*nPerc1)/100 
		
		If nDescRef > nTeto1
			nDescRef := nTeto1
		EndIf       
	EndIf
	If cValeRef == "02"
		nDescRef := ((nVal1*nQuant1)*nPerc1)/100 
		
		If nDescRef > nTeto1
			nDescRef := nTeto1
		EndIf       
	EndIf
	
	If flocaliapd(cCodRef) > 0
	   aPd[FlocaliaPd(cCodRef),5]  := nDescRef
	EndIf
	fGeraVerba(cCodRef,nDescRef,,,,,,,,,,.t.)  
    

Endif
	
Return(" ")        // incluido pelo assistente de conversao do AP5 IDE em 29/09/00

