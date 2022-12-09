#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function kfat19m()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("NORDEM,ALFA,Z,M,TAMANHO,LIMITE")
SetPrvt("TITULO,CDESC1,CDESC2,CDESC3,CNATUREZA,ARETURN")
SetPrvt("NOMEPROG,NLASTKEY,LCONTINUA,WNREL,CSTRING,NAJUSTE")
SetPrvt("LI,CI,NCABEC,NCOUNT,NATUAL,A_ET")
SetPrvt("ACOD,ANOME,AEND,ABAIRR,AMUN,AEST")
SetPrvt("ACEP,NETIQ,I,NCONT,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ KFAT19M  ³ Autor ³Ricardo Correa de Souza³ Data ³15/02/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Impressao da Etiqueta de Mala Direta Fornecedores          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Kenia Industrias Texteis Ltda                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   Analista   ³  Data  ³             Motivo da Alteracao               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
/*/

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Processamento                                                             *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

#IFDEF WINDOWS
	RptStatus({|| Etiqueta()})// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> 	RptStatus({|| Execute(Etiqueta)})
	Return
// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> 	Function Etiqueta
Static Function Etiqueta()
#ENDIF

nOrdem          := 0
Alfa            := 0
Z               := 0
M               := 0
tamanho   := "P"
limite    := 80
titulo    := PADC("Etiquetas Mala Direta",74)
cDesc1    := PADC("Este programa ira emitir as etiquetas",74)
cDesc2    := PADC("de Mala Direta para Clientes",74)
cDesc3    := PADC("Kenia Industrias Texteis Ltda",74)
cNatureza := ""
aReturn   := { "Especial", 1,"Administracao", 1, 2, 1,"",1 }
nomeprog  := "KFAT19M"
nLastKey  := 0
lContinua := .T.
wnrel     := "KFAT19M"
cString   := "SA2"
nAjuste   := 0   // para o deslocamento nas etiquetas da mesma linha
li        := 5   // para a contagem das linhas a serem impressas
ci        := 0   // coluna inicial
nCabec    := 1
nCount    := 0
nAtual    := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³  matrizes com os dados para impressao                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

a_Et  := {}
aCOD  :={} // contem os nomes dos clientes
aNOME :={} // contem os nomes dos clientes
aEND  :={} // contem os enderecos 
aBAIRR:={} // contem os bairros
aMUN  :={} // contem os municipios
aEST  :={} // contem os estados
aCEP  :={} // contem os ceps
// indice para as matrizes (Numero da etiqueta atual)

nETIQ  := 0


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel:=SetPrint(cString,wnrel,,Titulo,cDesc1,cDesc2,cDesc3,.T.)

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica Posicao do Formulario na Impressora                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

DbSelectArea("SA2")
DbSetOrder(1)
DbGoTop()
SetRegua(LastRec())

While Eof() == .f.

	incregua()

	//----> VERIFICA SE EXISTE FILTRAGEM
	If !Empty(aReturn[7]) .And. !&(aReturn[7])
		DbSkip()
		Loop
    
    //----> VERIFICA SE REGISTRO ESTA MARCADO
    ElseIf !Marked("A2_OK")
        DbSkip()
        Loop
    EndIf

    AADD(aCOD  ,SA2->A2_COD  )
    AADD(aNOME ,SA2->A2_NOME )
    AADD(aEND  ,SA2->A2_END  )
    AADD(aMUN  ,SA2->A2_MUN  )
    AADD(aEST  ,SA2->A2_EST  )
    AADD(aCEP  ,SA2->A2_CEP  )

    nEtiq := nEtiq + 1
    DbSelectArea("SA2")
    DbSkip()

EndDo

@ 00,00 psay CHR(15)

For i:=1 to nEtiq

    for nCont:=1 to nCabec  // Imprime o codigo
		if nAtual+nCont<=nEtiq
            @li,ci+nAjuste PSAY aCOD[i]
            nAjuste:=nAjuste+61
        endif

    next nCont

	nAjuste:=0
	li:=li+1

	incregua()

    for nCont:=1 to nCabec  // Imprime o nome
		if nAtual+nCont<=nEtiq
            @li,ci+nAjuste PSAY Subs(aNOME[i],1,34)
            nAjuste:=nAjuste+61
        endif

	next nCont

    nAjuste:=0
	li:=li+1
	
	incregua()

    for nCont:=1 to nCabec  // imprime o endereco    
        if nAtual+nCont<=nEtiq
            @li,ci+nAjuste PSAY subs(aEND[i],1,34)
            nAjuste:=nAjuste+61
        endif
    next nCont

    nAjuste:=0
	li:=li+1
	
	incregua()

    for nCont:=1 to nCabec  // imprime o municipio + estado
        if nAtual+nCont<=nEtiq
            @li,ci+nAjuste PSAY Alltrim(aMUN[i])+" - "+aEST[i]
            nAjuste:=nAjuste+61
        endif
    next nCont

    nAjuste := 0
    li:=li+1
    
    incregua()

    for nCont:=1 to nCabec  // imprime o cep
		if nAtual+nCont<=nEtiq
            @li,ci+nAjuste PSAY "CEP: "+aCEP[i]
            nAjuste:=nAjuste+61
		endif
	next nCont

    nAjuste := 0
    li:=li+1
    
    incregua()

    nAtual  := nAtual + 1
    li:=li+1

    incregua()

Next

EJECT

Set Device To Screen

If aReturn[5] == 1
   Set Printer TO
   dbcommitAll()
   ourspool(wnrel)
Endif

MS_FLUSH()

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> __Return()
Return()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Fim do Programa                                                           *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
