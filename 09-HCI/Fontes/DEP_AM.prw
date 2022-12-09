#include "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  DEP_AM  ³ Autor ³ Eduardo Porto         ³ Data ³ 08.08.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Listagem de Assist. Medica                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Chamada padr„o para programas em RDMake.                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico para HCI                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³      ³                                          ³±±
±±³            ³        ³      ³                                          ³±±
±±³            ³        ³      ³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function DEP_AM()

// Declaracao de variaveis private
SetPrvt("cString,aOrd,cDesc1,cDesc2,cDesc3,nLastKey,cPerg,nomeprog,Titulo,cNomRel")
SetPrvt("wCabec1,wCabec2,Tamanho,m_pag,li,ContFl,aReturn,nOrdem,lEnd,cCancel")
SetPrvt("aSavRA_,aSavRB_,cInic_,cFim_,cSit_,cDepIR_,cDepSF_,cFilMat_,nTot_,nTotIR_")
SetPrvt("nTotSF_,nTotg_,nTotIRg_,nTotSFg_,nTotF_")

//Inicializacao das Variaveis
Private cString   := 'SRB' //-- Alias do arquivo principal (Base).
Private aOrd      := {'Matricula','C.Custo','Nome'} //-- Ordem
Private cDesc1    := 'Emiss„o de Relatorio de Dependentes.'
Private cDesc2    := 'Ser  impresso de acordo com os parametros solicitados pelo'
Private cDesc3    := 'usuario.'
Private nLastKey  := 0
Private cPerg     := 'DEP002'
Private nomeprog  := 'DEP_OD'
Private Titulo    := 'RELATORIO DE ASSISTENCIA ODONTOLOGICA'
Private cNomRel   := 'Relatorio de Assistencia Odontologica'
Private wCabec1   := " Matr     Nome do Funcionario                                   Dt.Nasc.   Est.Civil   Plano  Descricao                    Valor  "
Private wCabec2   := " Seq.     Nome do Dependente             Parentesco  " 
Private nTamanho   := 'M'
Private m_pag     := 0
Private li        := 0
Private ContFl    := 1
Private aReturn   := { 'Zebrado', 1,'Administra‡„o', 2, 2, 1, '',1 }
Private nOrdem    := 0
Private lEnd      := .F.
Private cCancel   := "***** CANCELADO PELO OPERADOR *****"

//Montando Variaveis de Trabalho
Private nValo_    := 0 
Private nVlrFunc  := 0
Private nVlrEmp   := 0
Private VlrDesc1_ := 0
Private nAgreg1_  := 0
Private _nVAgr1 := 0
Private aTAssMed := {}               
Private cAssMed := " "
Private cDescPlan := " " 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Basicas Programa                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aSavRA_   := {}
aSavRB_   := {}
cInic_    := ''
cFim_     := ''
cSit_     := ''
cDepIR_   := ''
cDepSF_   := ''
cFilMat_  := ''
nTot_     := 0
nTotF_	  := 0
nTotg_    := 0
nTotVal   := 0
nTotvFun  := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
VerPerg()
Pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³mv_par01 - Filial de                                          ³
//³mv_par02 - Filial Ate                                         ³
//³mv_par03 - Centro de Custo de                                 ³
//³mv_par04 - Centro de Custo Ate                                ³
//³mv_par05 - Matricula de                                       ³
//³mv_par06 - Matricula Ate                                      ³
//³mv_Par07 - Nome de Funcionario de                             ³
//³mv_Par08 - Nome de Funcionario ate                            ³
//³mv_par09 - Situa‡ao na folha                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WnRel := 'DEP_OD' //-- Nome Default do relatorio em Disco.
WnRel := SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,ntamanho)

If nLastKey == 27
	Return Nil
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return Nil
Endif

//Ordem
nOrdem := aReturn[8]

//Salva Ambiente
aSavRB_ := SRB->(GetArea())
SRB->(dbSetOrder(1))

aSavRA_ := SRA->(GetArea())
SRA->(dbSetOrder(nOrdem))

// Chamada da Funcao
RptStatus({|lEnd| fRB_Imp(@lEnd)},"Aguarde...","Imprimindo Registros...",.T.)  //-- Chamada do Relatorio.

// Chama o Spool de Impressao para impressoes em Disco                        ³
If aReturn[5]==1
   Set Print to
   dbCommitAll()
   OurSpool(wnrel)
EndIf

// Libera o relatorio para Spool da Rede 
MS_FLUSH()

//Retorna Ambiente
SRA->(RestArea(aSavRA_))
SRB->(RestArea(aSavRB_))

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Funcao   ³ fRB_Imp  ³ Autor ³ Eduardo Porto         ³ Data ³ 18.05.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Rotina de Impressao                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fRB_Imp()

// Carregando Variaveis
FilialDe  := mv_par01
FilialAte := mv_par02
CcDe      := mv_par03
CcAte     := mv_par04
MatDe     := mv_par05
MatAte    := mv_par06
NomDe     := mv_par07
NomAte    := mv_par08
cSit_     := mv_par09
cCodAMDe  := mv_par10
cCodAMAte := mv_par11


// Selecionando o Primeiro Registro e montando Filtro.
If nOrdem == 1
	SRA->(dbSeek(FilialDe + MatDe,.T.))
        cInic_ := 'SRA->RA_FILIAL + SRA->RA_MAT '
        cFim_  := FilialAte + MatAte 
ElseIf nOrdem == 2
	SRA->(dbSeek(FilialDe + CcDe + MatDe,.T.))
        cInic_  := 'SRA->RA_FILIAL + SRA->RA_CC + SRA->RA_MAT'
        cFim_   := FilialAte + CcAte + MatAte
ElseIf nOrdem == 3
	SRA->(dbSeek(FilialDe + NomDe + MatDe,.T.))
        cInic_ := 'SRA->RA_FILIAL + SRA->RA_NOME + SRA->RA_MAT '
        cFim_  := FilialAte + NomAte + MatAte
End

//Carrega Regua
SetRegua(SRA->(RecCount()))

While SRA->(!EOF()) .And. &cInic_ <= cFim_ .And. !lEnd
	
    // Movimenta Regua Processamento
	IncRegua()  //-- Move a regua.

  	//Abortado Pelo Operador
	If lAbortPrint
		lEnd := .T.
	Endif

	If lEnd
		cDet := cCancel
		Impr(cDet,'C')
		Loop
	EndIF			

        //-- Despreza registros conforme situacao.
    If ! SRA->RA_SITFOLH $ cSit_
		SRA->(dbSkip())
		Loop
	Endif

    If SRA->RA_ASSODO_ < cCodAMDe .AND. SRA->RA_ASSODO_ > cCodamAte
		SRA->(dbSkip())
		Loop
	Endif

    if SRA->RA_SITFOLH = "D" .AND. MESANO(SRA->RA_DEMISSA)<MESANO(DDATABASE)
		SRA->(dbSkip())
		Loop
    ENDIF

    cFilMat_ := SRA->RA_FILIAL + SRA->RA_MAT
    nTotvFun := 0
	GravFun()
                
    If SRB->(dbSeek(cFilMat_),Found())

		While SRB->(!Eof()) .And. SRB->RB_FILIAL + SRB->RB_MAT == cFilMat_

			GravDep()
			SRB->(dbSkip())
    	End
	Endif

    if sra->ra_ASSODO_ # "  "
	     ImpLinha()
	Endif

	SRA->(dbSkip())

End

ImpTotg()

cDet := " "
Impr(cDet,"F")

Return

// Fim da Rotina

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Funcao   ³ GravFun  ³ Autor ³ Eduardo Porto         ³ Data ³ 18.05.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Rotina de Impressao                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function GravFun

_nvalor := 0           
_nTotvFun := 0
                                                                                                                                                                                                                         
IF SRA->RA_ESTCIVIL = "C"
      IF SRA->RA_SEXO = "M"
			   _ESTCIV := "CASADO   "
			ELSE
			   _ESTCIV := "CASADA   "
			ENDIF   
ELSEIF SRA->RA_ESTCIVIL = "S"   
      IF SRA->RA_SEXO = "M"
		   _ESTCIV := "SOLTEIRO "
		  ELSE
		   _ESTCIV := "SOLTEIRA "		   
		  ENDIF 
ELSE
   _ESTCIV := "OUTROS   "
ENDIF   

IF RCC->(dbSeek(Space(2) + "U003" +Space(8) + "0" + SRA->RA_ASSODO_ + SRA->RA_ASSODO_))
    bvalfunc()       
	nTotF_ += 1
	nTotVal += _nValor
	nTotVFun += _nValor
ELSE
   cDESCPLAN := "NAO CADASTRADO     " 
   _NVALOR   := 0
   Return
ENDIF


cDet := SRA->RA_MAT + " - " + SRA->RA_NOME + "  " + fdesc("SRJ",SRA->RA_CODFUNC,"RJ_DESC") + "  " + DTOC(SRA->RA_NASC) + "      " + _ESTCIV + "  " + SRA->RA_ASSODO_ + "  " + Subs(cDESCPLAN,1,14) + "           " + transform(_NVALOR,"@E 999,999,999.99")
//cDet := SRA->RA_MAT + " - " + SRA->RA_NOME + "  " + fdesc("SRJ",SRA->RA_CODFUNC,"RJ_DESC") + "  " + DTOC(SRA->RA_NASC) + "      " + _ESTCIV + "  " + SRA->RA_ASSODO_ + "     " + Subs(cDESCPLAN,1,14) +  transform(_NVALOR,"@E 999,999,999.99")


Impr(cDet,"C")

Return

// Fim da Rotina

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Funcao   ³ GravDep  ³ Autor ³ Eduardo Porto         ³ Data ³ 18.05.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Rotina de Impressao                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function GravDep

_nvalor := 0

// Grau de Parentensco
If SRB->RB_GRAUPAR == 'C'
        cPar_ := 'CONJUGE  '
        if SRB->RB_SEXO = "M"
           cEstCiv :=  "CASADO   "
        ELSE
           cEstCiv :=  "CASADA   "
        ENDIF   
ElseIf SRB->RB_GRAUPAR == 'F'
				IF SRB->RB_SEXO = "M"
						cPar_ := 'FILHO    '
						cEstCiv := "SOLTEIRO " 
				ELSE
						cPar_ := 'FILHA    '
						cEstCiv := "SOLTEIRA "
				ENDIF		
ElseIf SRB->RB_GRAUPAR == 'O'
        cPar_ := 'OUTROS   '
        cEstCiv := "OUTROS   "
End

IF RCC->(dbSeek(Space(2) + "U003" +Space(8) + "0" + SRB->RB_ASSODO_ + SRB->RB_ASSODO_))
    bvaldep()
   	nTot_ += 1
	nTotVal += _nValor 
	nTotVFun += _nValor
ELSE
	 cDESCPLAN := "NAO CADASTRADO     " 
   _NVALOR   := 0
   Return
ENDIF

cDet :=  SRB->RB_COD + "     - "
cDet += SubStr(SRB->RB_NOME + Space(30),1,33)
cDet += cPar_ + "            "
cDet += dToc(SRB->RB_DTNASC) + "      "
cDet += cEstCiv + "  "
cDet += SRB->RB_ASSODO_   + "  "
cDet += Subs(cDescPlan,1,14) + "  " 
cDet += "         "
cDet += Transform(_nValor,"@E 999,999,999.99")

Impr(cDet,"C")

Return

// Fim da Rotina

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Funcao   ³ImpLinha  ³ Autor ³ Eduardo Porto         ³ Data ³ 18.05.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Rotina de Impressao                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function ImpLinha
                      
cDet := Space(117) + Transform(	nTotVFun,"@E 999,999,999.99")
Impr(cDet,"C")
 

cDet := Replicate("-",132)
Impr(cDet,"C")

Return

// Fim da Rotina



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Funcao   ³  ImpTotg ³ Autor ³ Eduardo Porto         ³ Data ³ 18.05.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Rotina de Impressao                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function ImpTotg()
                         
cDet := " "
Impr(cDet,"C")
                      
cDet := "Totais Gerais "
Impr(cDet,"C")

cDet := "Funcionarios " + Transform(nTotF_,'@E 99,999') 
cDet += "  Dependentes " + Transform(nTot_,'@E 99,999')
cDet += space(64) + "  Valor       " + Transform(nTotVal,'@E 999,999,999.99')

Impr(cDet,"C")

Return

// Fim da Rotina
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ ValidPerg    ³ Autor ³ Eduardo Porto     ³ Data ³ 18.05.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Verifica as perguntas, Incluindo-as caso n„o existam       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function VerPerg()

aRegs     := {}

cPerg := Left(cPerg,6)
//X1_GRUPO,X1_ORDEM,X1_PERGUNT,X1_PERSPA,X1_PERENG,X1_VARIAVL,X1_TIPO,X1_TAMANHO,X1_DECIMAL,X1_PRESEL,X1_GSC,X1_VALID,X1_VAR01,X1_DEF01,X1_DEFSPA1,X1_DEFENG1,X1_CNT01,X1_VAR02,X1_DEF02,X1_DEFSPA2,X1_DEFENG2,X1_CNT02,X1_VAR03,X1_DEF03,X1_DEFSPA3,X1_DEFENG3,X1_CNT03,X1_VAR04,X1_DEF04,X1_DEFSPA4,X1_DEFENG4,X1_CNT04,X1_VAR05,X1_DEF05,X1_DEFSPA5,X1_DEFENG5,X1_CNT05,X1_F3,X1_PYME,X1_GRPSXG,X1_HELP  
aAdd(aRegs,{cPerg,"01","Da Filial          ?","Da Filial          ?","Da Filial          ?","mv_ch1","C",02,0,0,"G","naovazio","mv_par01","","","","01","","","","","","","","","","","","","","","","","","","","","SM0","","",""})
aAdd(aRegs,{cPerg,"02","Ate a Filial       ?","Ate a Filial       ?","Ate a Filial       ?","mv_ch2","C",02,0,0,"G","naovazio","mv_par02","","","","99","","","","","","","","","","","","","","","","","","","","","SM0","","",""})
aAdd(aRegs,{cPerg,"03","Do Centro Custo    ?","Do Centro de Custo ?","Do Centro de Custo ?","mv_ch3","C",09,0,0,"G","naovazio","mv_par03","","","","000000001","","","","","","","","","","","","","","","","","","","","","SI3","","",""})
aAdd(aRegs,{cPerg,"04","At‚ Centro de Custo?","At‚ Centro de Custo?","At‚ Centro de Custo?","mv_ch4","C",09,0,0,"G","naovazio","mv_par04","","","","999999999","","","","","","","","","","","","","","","","","","","","","SI3","","",""})
aAdd(aRegs,{cPerg,"05","Da Matricula       ?","Da Matricula       ?","Da Matricula       ?","mv_ch5","C",06,0,0,"G","naovazio","mv_par05","","","","000001","","","","","","","","","","","","","","","","","","","","","SRA","","",""})
aAdd(aRegs,{cPerg,"06","Ate Matricula      ?","Ate Matricula      ?","Ate Matricula      ?","mv_ch6","C",06,0,0,"G","naovazio","mv_par06","","","","999999","","","","","","","","","","","","","","","","","","","","","SRA","","",""})
aAdd(aRegs,{cPerg,"07","Nome De            ?","Nome De            ?","Nome De            ?","mv_ch7","C",30,0,0,"G",""        ,"mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","SRA","","",""})
aAdd(aRegs,{cPerg,"08","Nome Ate           ?","Nome Ate           ?","Nome Ate           ?","mv_ch8","C",30,0,0,"G",""        ,"mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","SRA","","",""})
aAdd(aRegs,{cPerg,"09","Situacao           ?","Situacao           ?","Situacao           ?","mv_ch9","C",09,0,0,"G","fSituacao","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"10","Cod.Assist.Odo.De  ?","Cod.Assist.Med.De  ?","Cod.Assist.Med.De  ?","mv_cha","C",02,0,0,"G",""        ,"mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","SZ1","","",""})
aAdd(aRegs,{cPerg,"11","Cod.Assist.Odo.Ate ?","Cod.Assist.Med.Ate ?","Cod.Assist.Med.Ate ?","mv_chb","C",02,0,0,"G",""        ,"mv_par11","","","","","","","","","","","","","","","","","","","","","","","","","SZ1","","",""})

ValidPerg(aRegs,cPerg ,.F.)

Return

// Fim da Rotina
                                  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Funcao   ³ bvalfunc ³ Autor ³ Eduardo Porto         ³ Data ³ 18.05.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Rotina de Impressao                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/


STATIC FUNCTION BVALFUNC()


// CALCULO DA ASSISTENCIA MEDICA PARA O FUNCIONARIO

		If !Empty(SRA->RA_ASSODO_)
			//Localiza Parametros
			U_CVAssOdo(SRA->RA_ASSODO_)
            _nValor :=  VlrDesc1_
		End       

RETURN(_nValor,cDescPlan)

                       

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Funcao   ³ bvaldep  ³ Autor ³ Eduardo Porto         ³ Data ³ 18.05.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Rotina de Impressao                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/


STATIC FUNCTION BVALDEP()


// CALCULO DA ASSISTENCIA MEDICA PARA O FUNCIONARIO

		If !Empty(SRB->RB_ASSODO_)
			//Localiza Parametros
			U_CVAssOdo(STRZERO(VAL(SRB->RB_ASSODO_),2))
            _nValor :=  VlrDesc1_
		End       

RETURN(_nValor,cDescPlan)

// Fim do Programa