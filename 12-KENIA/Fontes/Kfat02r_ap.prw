#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05
#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF

User Function Kfat02r()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("NORDEM,ALFA,Z,M,TAMANHO,LIMITE")
SetPrvt("TITULO,CDESC1,CDESC2,CDESC3,CNATUREZA,ARETURN")
SetPrvt("NOMEPROG,NLASTKEY,LCONTINUA,WNREL,CSTRING,NAJUSTE")
SetPrvt("LI,CI,A_ET,ACOD,ANOME,AEND")
SetPrvt("ABAIRR,AMUN,AEST,ACEP,NETIQ,NAUX")
SetPrvt("NCABEC,NATUAL,_NETQATU,NCOUNT,NCONT,NOPC")
SetPrvt("CCOR,")

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 12/02/05 ==> 	#DEFINE PSAY SAY
#ENDIF
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ KFAT02R  ³ Autor ³Ricardo Correa de Souza³ Data ³15/02/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Impressao das Etiquetas Mala Direta dos Clientes           ³±±
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
nomeprog  := "KFAT02R"
nLastKey  := 0
lContinua := .T.
wnrel     := "KFAT02R"
cString   := "SZ5"
nAjuste   := 0   // para o deslocamento nas etiquetas da mesma linha
li        := 5   // para a contagem das linhas a serem impressas
ci        := 0   // coluna inicial

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

nETIQ  := 9999999999999999999999


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
VerImp()

#IFDEF WINDOWS
	RptStatus({|| Etiqueta()})// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> 	RptStatus({|| Execute(Etiqueta)})
	Return
// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> 	Function Etiqueta
Static Function Etiqueta()
#ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Obtencao dos dados para impressao                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea("SA1") 
dbSetOrder(1)
dbGoTop()
SetRegua(LastRec())
nAux  := 1
nCabec := 2
nAtual  := 0 // numero da etiqueta atual
nAjuste := 0
_nEtqAtu:= 1
SetRegua(nEtiq-nAtual)
@000,000 PSAY Chr(15)

nCount := 0

While !Eof()

    nCount := nCount + 1

    for nCont:=1 to nCabec  // Imprime o codigo
		if nAtual+nCont<=nEtiq
            @li,ci+nAjuste PSAY SA1->A1_COD
            nAjuste:=nAjuste+61
        endif

        If nCont == 1
            dbSkip()
        Else
            dbSkip(-1)
        EndIf

    next nCont
	nAjuste:=0
	li:=li+1
	incregua()

    for nCont:=1 to nCabec  // Imprime o nome
		if nAtual+nCont<=nEtiq
            @li,ci+nAjuste PSAY Subs(SA1->A1_NOME,1,34)
            nAjuste:=nAjuste+61
        endif

        If nCont == 1
            dbSkip()
        Else
            dbSkip(-1)
        EndIf
	next nCont
	nAjuste:=0
	li:=li+1
	incregua()

    for nCont:=1 to nCabec  // imprime o endereco    
        if nAtual+nCont<=nEtiq
            @li,ci+nAjuste PSAY subs(SA1->A1_END,1,34)
            nAjuste:=nAjuste+61
        endif
        If nCont == 1
            dbSkip()
        Else
            dbSkip(-1)
        EndIf
    next nCont
	nAjuste:=0
	li:=li+1
	incregua()

    for nCont:=1 to nCabec  // imprime o municipio + estado
        if nAtual+nCont<=nEtiq
            @li,ci+nAjuste PSAY Alltrim(SA1->A1_MUN)+" - "+SA1->A1_EST
            nAjuste:=nAjuste+61
        endif
        If nCont == 1
            dbSkip()
        Else
            dbSkip(-1)
        EndIf
    next nCont
    nAjuste := 0
    li:=li+1
    incregua()

    for nCont:=1 to nCabec  // imprime o cep
		if nAtual+nCont<=nEtiq
            @li,ci+nAjuste PSAY "CEP: "+SA1->A1_CEP
            nAjuste:=nAjuste+61
		endif
        If nCont == 1
            dbSkip()
        Else
            dbSkip(-1)
        EndIf
	next nCont
    nAjuste := 0
    li:=li+1
    incregua()

    nAtual  := nAtual+2
    li:=li+2

    // Bloco desabilitado em 09/06/2000 por Ricardo - Microsiga
    /*
    if li>=72
		setprc(0,0)
	endif
    */

    /*
    if nAtual>nEtiq
		exit
	endif
    */
    incregua()
    
    DbSelectArea("SA1")
    dbSkip()
    dbSkip()
End

dbSelectArea("SA2") 
dbSetOrder(1)
dbGoTop()
SetRegua(LastRec())
nAux  := 1
nCabec := 2
nCount := 0

While !Eof() 

    nCount := nCount + 1
    nETIQ:=nETIQ+1

    for nCont:=1 to nCabec  // Imprime o codigo
		if nAtual+nCont<=nEtiq
            @li,ci+nAjuste PSAY SA2->A2_COD
            nAjuste:=nAjuste+61
        endif
        If nCont == 1
            dbSkip()
        Else
            dbSkip(-1)
        EndIf

	next nCont
	nAjuste:=0
	li:=li+1
	incregua()

    for nCont:=1 to nCabec  // Imprime o nome
		if nAtual+nCont<=nEtiq
            @li,ci+nAjuste PSAY subs(SA2->A2_NOME,1,34)
            nAjuste:=nAjuste+61
        endif

        If nCont == 1
            dbSkip()
        Else
            dbSkip(-1)
        EndIf
	next nCont
	nAjuste:=0
	li:=li+1
	incregua()

    for nCont:=1 to nCabec  // imprime o endereco    
        if nAtual+nCont<=nEtiq
            @li,ci+nAjuste PSAY subs(SA2->A2_END,1,34)
            nAjuste:=nAjuste+61
        endif
        If nCont == 1
            dbSkip()
        Else
            dbSkip(-1)
        EndIf
    next nCont
	nAjuste:=0
	li:=li+1
	incregua()

    for nCont:=1 to nCabec  // imprime o municipio + estado
        if nAtual+nCont<=nEtiq
            @li,ci+nAjuste PSAY Alltrim(SA2->A2_MUN)+" - "+SA2->A2_EST
            nAjuste:=nAjuste+61
        endif
        If nCont == 1
            dbSkip()
        Else
            dbSkip(-1)
        EndIf
    next nCont
    nAjuste := 0
    li:=li+1
    incregua()

    for nCont:=1 to nCabec  // imprime o cep
		if nAtual+nCont<=nEtiq
            @li,ci+nAjuste PSAY "CEP: "+SA2->A2_CEP
            nAjuste:=nAjuste+61
		endif
        If nCont == 1
            dbSkip()
        Else
            dbSkip(-1)
        EndIf
	next nCont
    nAjuste := 0
    li:=li+1
    incregua()

    nAtual  := nAtual+2
    li:=li+2

    // Bloco desabilitado em 09/06/2000 por Ricardo - Microsiga
    /*
    if li>=72
		setprc(0,0)
	endif
    */

    if nAtual>nEtiq
		exit
	endif


    incregua()
    
    DbSelectArea("SA2")
    dbSkip()
    dbSkip()
End

@000,000 PSAY Chr(18)
Set Device To Screen

dbcommitAll()

If aReturn[5] == 1
	Set Printer TO
	ourspool(wnrel)
Endif

MS_FLUSH()
  
Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ VERIMP   ³ Autor ³RICARDO CORREA DE SOUZA³ Data ³ 10/02/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ VERIFICA POSICIONAMENTO DE PAPEL NA IMPRESSORA             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ ESPECIFICO PARA COEL CONTROLES ELETRICOS LTDA              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function VerImp
Static Function VerImp()

If aReturn[5]==2
	nOpc       := 1
	#IFNDEF WINDOWS
		cCor       := "B/BG"
	#ENDIF
	While .T.
		SetPrc(0,0)
		dbCommitAll()
		
		#IFNDEF WINDOWS
			Set Device to Screen
			DrawAdvWindow(" Formulario ",10,25,14,56)
			SetColor(cCor)
			@ 12,27 PSAY "Formulario esta posicionado?"
			nOpc:=Menuh({"Sim","Nao","Cancela Impressao"},14,26,"b/w,w+/n,r/w","SNC","",1)
				Set Device to Print
		#ELSE
			IF MsgYesNo("Fomulario esta posicionado ? ")
				nOpc := 1
			ElseIF MsgYesNo("Tenta Novamente ? ")
				nOpc := 2
			Else
				nOpc := 3
			Endif
		#ENDIF
		
		Do Case
			Case nOpc==1
				lContinua:=.T.
				Exit
			Case nOpc==2
				Loop
			Case nOpc==3
				lContinua:=.F.
				Return
		EndCase
	End
Endif

Set Device to Print

Return

