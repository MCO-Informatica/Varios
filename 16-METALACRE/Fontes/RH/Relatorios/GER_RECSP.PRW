#include "rwmake.ch"
//#INCLUDE "RECIBO.ch" 
#DEFINE            CRLF             CHR(13)+CHR(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ GPER030  ³ Autor ³ R.H. - Marcelo Aires  ³ Data ³ 22.06.08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Geração do arquivo TXT para INFODIGITUS                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ GPER030(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function GER_RECSP()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Locais (Basicas)                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cString:="SRA"        // alias do arquivo principal (Base)
Local aOrd   := {"Matricula","C.Custo","Nome","Chapa","C.Custo + Nome"} //"Matricula"###"C.Custo"###"Nome"###"Chapa"###"C.Custo + Nome"
Local cDesc1 := "Emissäo de Recibos de Pagamento."		//"Emiss„o de Recibos de Pagamento."
Local cDesc2 := "Será impresso de acordo com os parametros solicitados pelo"		//"Ser  impresso de acordo com os parametros solicitados pelo"
Local cDesc3 := "usuário."		//"usu rio."

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Locais (Programa)                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local nExtra,cIndCond,cIndRc
Local Baseaux := "S", cDemit := "N"
Local cMesAnoRef
Private _cNameFile := "C:\" + Alltrim(Upper(SM0->M0_NOME)) +  ".TXT"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CSTRING,AORD,CDESC1,CDESC2,CDESC3,BASEAUX")
SetPrvt("CDEMIT,ARETURN,NOMEPROG,ALINHA,NLASTKEY,CPERG")
SetPrvt("CSEM_DE,CSEM_ATE,ALANCA,APROVE,ADESCO,ABASES")
SetPrvt("AINFO,ACODFOL,LI,TITULO,WNREL,NORDEM")
SetPrvt("DDATAREF,NTIPREL,ESC,SEMANA,CFILDE,CFILATE")
SetPrvt("CCCDE,CCCATE,CMATDE,CMATATE,CNOMDE,CNOMATE")
SetPrvt("CHAPADE,CHAPAATE,MENSAG1,MENSAG2,MENSAG3,CSITUACAO")
SetPrvt("CCATEGORIA,CBASEAUX,CMESANOREF,TAMANHO,LIMITE,AORDBAG")
SetPrvt("CMESARQREF,CARQMOV,CALIASMOV,CACESSASR1,CACESSASRA,CACESSASRC")
SetPrvt("CACESSASRI,LATUAL,CARQNTX,CINDCOND,ADRIVER,CCOMPAC")
SetPrvt("CNORMAL,CINICIO,CFIM,TOTVENC,TOTDESC,FLAG")
SetPrvt("CHAVE,DESC_FIL,DESC_END,DESC_CC,DESC_FUNC,DESC_MSG1")
SetPrvt("DESC_MSG2,DESC_MSG3,CFILIALANT,CFUNCAOANT,CCCANT,VEZ")
SetPrvt("ORDEMZ,NATELIM,NBASEFGTS,NFGTS,NBASEIR,NBASEIRFE")
SetPrvt("ORDEM_REL,DESC_CGC,NCONTA,NCONTR,NCONTRT,NLINHAS")
SetPrvt("CDET,NCOL,NTERMINA,NCONT,NCONT1,NVALIDOS,NSEQ_,CREG,LCONTINUA")
SetPrvt("NVALSAL,DESC_BCO,CCHAVESEM,DESC_PAGA,NPOS,CARRAY,NHDL,CNOMEARQ,NSEQ_,_DDATA_PGTO")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Private(Basicas)                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private aReturn  := {"Zebrado", 1,"Administraçäo", 2, 2, 1, "",1 }	//"Zebrado"###"Administra‡„o"
Private nomeprog :="RECIBO"
Private aLinha   := { },nLastKey := 0
Private cPerg    :="GEREC1"
Private cSem_De  := "  /  /    "
Private cSem_Ate := "  /  /    "
Private nAteLim , nBaseFgts , nFgts , nBaseIr , nBaseIrFe

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Private(Programa)                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private aLanca := {}
Private aProve := {}
Private aDesco := {}
Private aBases := {}
Private aInfo  := {}
Private aCodFol:= {}
Private li     := 0                                           
Private nHdl   := 0
PRIVATE nSeq_  := 0
Private Titulo := "EMISSÄO DE RECIBOS DE PAGAMENTOS"		//"EMISSO DE RECIBOS DE PAGAMENTOS"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
fAsrPerg()
pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:="RECIBO"            //Nome Default do relatorio em Disco
wnrel:=SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd)

If LastKey() = 27 .Or. nLastKey = 27
	Return
Endif

SetDefault(aReturn,cString)

If LastKey() = 27 .OR. nLastKey = 27
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carregando variaveis mv_par?? para Variaveis do Sistema.     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01        //  Data de Referencia para a impressao      ³
//³ mv_par02        //  Tipo de Recibo(Pre/Zebrado/Email/Arquivo)³
//³ mv_par03        //  Emitir Recibos(Adto/Folha/1¦/2¦/V.Extra) ³
//³ mv_par04        //  Numero da Semana                         ³
//³ mv_par05        //  Filial De                                ³
//³ mv_par06        //  Filial Ate                               ³
//³ mv_par07        //  Centro de Custo De                       ³
//³ mv_par08        //  Centro de Custo Ate                      ³
//³ mv_par09        //  Matricula De                             ³
//³ mv_par10        //  Matricula Ate                            ³
//³ mv_par11        //  Nome De                                  ³
//³ mv_par12        //  Nome Ate                                 ³
//³ mv_par13        //  Chapa De                                 ³
//³ mv_par14        //  Chapa Ate                                ³
//³ mv_par15        //  Mensagem 1                               ³
//³ mv_par16        //  Mensagem 2                               ³
//³ mv_par17        //  Mensagem 3                               ³
//³ mv_par18        //  Situacoes a Imprimir                     ³
//³ mv_par19        //  Categorias a Imprimir                    ³
//³ mv_par20        //  Imprimir Bases                           ³ 
//³ mv_par21        //  Arquivo de Saida                         ³
//³ mv_par22        //  Data de Pagamento                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nOrdem      := aReturn[8]
dDataRef    := mv_par01
nTipRel     := mv_par02
Esc         := mv_par03
Semana      := mv_par04
cFilDe      := mv_par05
cFilAte     := mv_par06
cCcDe       := mv_par07
cCcAte      := mv_par08
cMatDe      := mv_par09
cMatAte     := mv_par10
cNomDe      := mv_par11
cNomAte     := mv_par12
ChapaDe     := mv_par13
ChapaAte    := mv_par14
Mensag1     := mv_par15
Mensag2     := mv_par16
Mensag3     := mv_par17
cSituacao   := mv_par18
cCategoria  := mv_par19
cBaseAux    := If(mv_par20 == 1,"S","N")
cNomeArq    := mv_par21
_DDATA_PGTO := mv_par22

cMesAnoRef := StrZero(Month(dDataRef),2) + StrZero(Year(dDataRef),4)

RptStatus({|lEnd| GERRImp(@lEnd,wnRel,cString,cMesAnoRef)},Titulo)  // Chamada do Relatorio

//Gerar Arquivo
If nTipRel == 4
	If nHdl > 0
		If fClose(nHdl)
    		If nSeq_ != 0 
				Aviso('AVISO','Gerado o arquivo ' + AllTrim(AllTrim(cNomeArq)) + '...',{'OK'})
			Else
				If fErase(cNomeArq) == 0
					If lContinua
						Aviso('AVISO','N„o existem registros a serem gravados. A gera‡„o do arquivo ' + AllTrim(AllTrim(cNomeArq)) + ' foi abortada ...',{'OK'})
					EndIf	
				Else
					MsgAlert('Ocorreram problemas na tentativa de dele‡„o do arquivo '+AllTrim(cNomeArq)+'.')
				EndIf	
			EndIf	
		Else
			MsgAlert('Ocorreram problemas no fechamento do arquivo '+AllTrim(cNomeArq)+'.')
		EndIf
	EndIf	
    
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ GERRIMP  ³ Autor ³ R.H. - Ze Maria       ³ Data ³ 14.03.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Processamento Para emissao do Recibo                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ R030IMP(lEnd,Wnrel,cString)                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
// Substituido pelo assistente de conversao do AP5 IDE em 30/08/00 ==> Static Function R030Imp(lEnd,WnRel,cString,cMesAnoRef)
Static Function GERRImp(lEnd,WnRel,cString,cMesAnoRef)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Locais (Basicas)                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local lIgual                 //Vari vel de retorno na compara‡ao do SRC
Local cArqNew                //Vari vel de retorno caso SRC #SX3
Local tamanho     := "P"
Local limite      := 80
Local aOrdBag     := {}
Local cMesArqRef  := If(Esc == 4,"13"+Right(cMesAnoRef,4),cMesAnoRef)
Local cArqMov     := ""
Local cAliasMov   := ""
Local cAcessaSR1  := &("{ || " + ChkRH("GPER030","SR1","2") + "}")
Local cAcessaSRA  := &("{ || " + ChkRH("GPER030","SRA","2") + "}")
Local cAcessaSRC  := &("{ || " + ChkRH("GPER030","SRC","2") + "}")
Local cAcessaSRI  := &("{ || " + ChkRH("GPER030","SRI","2") + "}")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//| Verifica se existe o arquivo de fechamento do mes informado  |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
lAtual := ( !fExistArq( cMesArqRef,,0 ) .And. MesAno(dDataRef) == MesAno(dDataBase) )

If !lAtual
	If !fIniArqMov( cMesArqRef, @cAliasMov , @aOrdBag , @cArqMov )
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//| Se nao encontrar o arquivo retorna o arquivo atual           |
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	    ChkFile( cAliasMov , .F. )
	    Return
	EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria o arquivo texto                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If nTipRel == 4
    
	//Verifica se Arquivo Existe
	If File(cNomeArq)
		If (nAviso := Aviso('AVISO','Deseja substituir o ' + AllTrim(cNomeArq) + ' existente ?', {'Sim','N„o'})) == 1
			//Deleta Arquivo
			If fErase(cNomeArq) != 0
				MsgAlert('Ocorreram problemas na tentativa de dele‡„o do arquivo '+AllTrim(cNomeArq)+'.')
				Return
			EndIf		
		Else
			Return
		EndIf		
	Endif
     
	//Verifica se Nome de Arquivo em Branco
	If Empty(cNomeArq)
		MsgAlert('Nome do Arquivo nos Parametros em Branco.','Aten‡„o!')
		Return
	Else		
		//Cria Arquivo
		nHdl := fCreate(cNomeArq)
		nSeq_ := 0
		lContinua := .T.
		
    	//Verifica Criacao do Arquivo
		If nHdl == -1
			MsgAlert('O arquivo '+AllTrim(cNomeArq)+' n„o p“de ser criado! Verifique os parƒmetros.','Aten‡„o!')
			Return
		Endif          
	Endif

Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Selecionando a Ordem de impressao escolhida no parametro.    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea( "SRA")
If nOrdem == 1
	dbSetOrder(1)
ElseIf nOrdem == 2
	dbSetOrder(2)
ElseIf nOrdem == 3
	dbSetOrder(3)
Elseif nOrdem == 4
	cArqNtx  := CriaTrab(NIL,.f.)
	cIndCond :="RA_Filial + RA_Chapa + RA_Mat"
	IndRegua("SRA",cArqNtx,cIndCond,,,"Selecionando Registros...")		//"Selecionando Registros..."
ElseIf nOrdem == 5
  	   cArqNtx  := CriaTrab(NIL,.f.)
      cIndCond :="RA_Filial + RA_CC + RA_NOME"
    	IndRegua("SRA",cArqNtx,cIndCond,,,"Selecionando Registros...")		//"Selecionando Registros..."
//    dbSetOrder(8)
Endif
dbGoTop()

If nTipRel == 2
	aDriver := LEDriver()
	cCompac := aDriver[1]
    cNormal := aDriver[2]
	@ LI,00 PSAY &cCompac
Endif	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Selecionando o Primeiro Registro e montando Filtro.          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nOrdem == 1
	dbSeek(cFilDe + cMatDe,.T.)
	cInicio := "SRA->RA_FILIAL + SRA->RA_MAT"
	cFim    := cFilAte + cMatAte
ElseIf nOrdem == 2
	dbSeek(cFilDe + cCcDe + cMatDe,.T.)
	cInicio  := "SRA->RA_FILIAL + SRA->RA_CC + SRA->RA_MAT"
	cFim     := cFilAte + cCcAte + cMatAte
ElseIf nOrdem == 3
	dbSeek(cFilDe + cNomDe + cMatDe,.T.)
	cInicio := "SRA->RA_FILIAL + SRA->RA_NOME + SRA->RA_MAT"
	cFim    := cFilAte + cNomAte + cMatAte
ElseIf nOrdem == 4
	dbSeek(cFilDe + ChapaDe + cMatDe,.T.)
	cInicio := "SRA->RA_FILIAL + SRA->RA_CHAPA + SRA->RA_MAT"
	cFim    := cFilAte + ChapaAte + cMatAte
ElseIf nOrdem == 5
	dbSeek(cFilDe + cCcDe + cNomDe,.T.)
   cInicio  := "SRA->RA_FILIAL + SRA->RA_CC + SRA->RA_NOME"
	cFim     := cFilAte + cCcAte + cNomAte
Endif

dbSelectArea("SRA")
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega Regua Processamento                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SetRegua(RecCount())   // Total de elementos da regua

TOTVENC:= TOTDESC:= FLAG:= CHAVE := 0

Desc_Fil := Desc_End := DESC_CC:= DESC_FUNC:= ""
DESC_MSG1:= DESC_MSG2:= DESC_MSG3:= Space(01)
cFilialAnt := "  "
cFuncaoAnt := "    "
cCcAnt     := Space(9)
Vez        := 0
OrdemZ     := 0

dbSelectArea("SRA")
While !EOF() .And. &cInicio <= cFim
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Movimenta Regua Processamento                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  	IncRegua()  // Anda a regua

	If lEnd
		@Prow()+1,0 PSAY cCancel
		Exit
	Endif	 

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Consiste Parametrizacao do Intervalo de Impressao            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If (SRA->RA_CHAPA < ChapaDe) .Or. (SRA->Ra_CHAPa > ChapaAte) .Or. ;
		(SRA->RA_NOME < cNomDe)    .Or. (SRA->Ra_NOME > cNomAte)    .Or. ;
		(SRA->RA_MAT < cMatDe)     .Or. (SRA->Ra_MAT > cMatAte)     .Or. ;
	    (ALLTRIM(SRA->RA_CC)) < (ALLTRIM(cCcDe)) .OR. (ALLTRIM(SRA->Ra_CC)) > (ALLTRIM(cCcAte))
	  //	(SRA->RA_CC < cCcDe)       .Or. (SRA->Ra_CC > cCcAte)
		SRA->(dbSkip(1))
		Loop
	EndIf  
		  
	aLanca:={}         // Zera Lancamentos
	aProve:={}         // Zera Lancamentos
	aDesco:={}         // Zera Lancamentos
	aBases:={}         // Zera Lancamentos
	nAteLim := nBaseFgts := nFgts := nBaseIr := nBaseIrFe := 0.00
	
	Ordem_rel := 1     // Ordem dos Recibos
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Consiste situacao e categoria dos funcionarios			     |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !( SRA->RA_SITFOLH $ cSituacao ) .OR.  ! ( SRA->RA_CATFUNC $ cCategoria )
		dbSkip()
		Loop
	Endif
	If SRA->RA_SITFOLH $ "D" .And. Mesano(SRA->RA_DEMISSA) #Mesano(dDataRef)
		dbSkip()
		Loop
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Consiste controle de acessos e filiais validas				 |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If !(SRA->RA_FILIAL $ fValidFil()) .Or. !Eval(cAcessaSRA)
       dbSkip()
       Loop
    EndIf
	
	If SRA->RA_CODFUNC #cFuncaoAnt           // Descricao da Funcao
		DescFun(Sra->Ra_Codfunc,Sra->Ra_Filial)
		cFuncaoAnt:= Sra->Ra_CodFunc
	Endif
	
	If SRA->RA_CC #cCcAnt                   // Centro de Custo
		DescCC(Sra->Ra_Cc,Sra->Ra_Filial)
		cCcAnt:=SRA->RA_CC
	Endif
	
	If SRA->RA_Filial #cFilialAnt
		If ! Fp_CodFol(@aCodFol,Sra->Ra_Filial) .Or. ! fInfo(@aInfo,Sra->Ra_Filial)
			Exit
		Endif
		Desc_Fil := aInfo[3]
		Desc_End := aInfo[4]                // Dados da Filial
		Desc_CGC := aInfo[8]
		Desc_Uni := aInfo[1]
		DESC_MSG1:= DESC_MSG2:= DESC_MSG3:= Space(01)

		// MENSAGENS
/* alterado em 22/02/07 - por Marcos Pereira - para imprimir as mesagens digitadas nas perguntas
		If MENSAG1 #SPACE(1)
			If FPHIST82(SRA->RA_FILIAL,"06",SRA->RA_FILIAL+MENSAG1)
				DESC_MSG1 := Left(SRX->RX_TXT,30)
			ElseIf FPHIST82(SRA->RA_FILIAL,"06","  "+MENSAG1)
				DESC_MSG1 := Left(SRX->RX_TXT,30)
			Endif
		Endif

		If MENSAG2 #SPACE(1)
			If FPHIST82(SRA->RA_FILIAL,"06",SRA->RA_FILIAL+MENSAG2)
				DESC_MSG2 := Left(SRX->RX_TXT,30)
			ElseIf FPHIST82(SRA->RA_FILIAL,"06","  "+MENSAG2)
				DESC_MSG2 := Left(SRX->RX_TXT,30)
			Endif
		Endif

		If MENSAG3 #SPACE(1)
			If FPHIST82(SRA->RA_FILIAL,"06",SRA->RA_FILIAL+MENSAG3)
				DESC_MSG3 := Left(SRX->RX_TXT,30)
			ElseIf FPHIST82(SRA->RA_FILIAL,"06","  "+MENSAG3)
				DESC_MSG3 := Left(SRX->RX_TXT,30)
			Endif
		Endif
*/
		DESC_MSG1 := MV_PAR15		  
		DESC_MSG2 := MV_PAR16		  
		DESC_MSG3 := MV_PAR17		  

		dbSelectArea("SRA")
		
		cFilialAnt := SRA->RA_FILIAL
					
	Endif
	
	Totvenc := Totdesc := 0
	
	If Esc == 1 .OR. Esc == 2
		dbSelectArea("SRC")
		If dbSeek(SRA->RA_FILIAL + SRA->RA_MAT)
			While !Eof() .And. SRC->RC_FILIAL+SRC->RC_MAT == SRA->RA_FILIAL+SRA->RA_MAT
				If SRC->RC_SEMANA #Semana
					dbSkip()
					Loop
				Endif
			    If !Eval(cAcessaSRC)
			       dbSkip()
			       Loop
			    EndIf
				If (Esc == 1) .And. (Src->Rc_Pd == aCodFol[7,1])      // Desconto de Adto
					fSomaPd("P",aCodFol[6,1],SRC->RC_HORAS,SRC->RC_VALOR)
					TOTVENC += Src->Rc_Valor
				Elseif (Esc == 1) .And. (Src->Rc_Pd == aCodFol[12,1])
					fSomaPd("D",aCodFol[9,1],SRC->RC_HORAS,SRC->RC_VALOR)
					TOTDESC += SRC->RC_VALOR
				Elseif (Esc == 1) .And. (Src->Rc_Pd == aCodFol[8,1])
					fSomaPd("P",aCodFol[8,1],SRC->RC_HORAS,SRC->RC_VALOR)
					TOTVENC += SRC->RC_VALOR
				Else
					If PosSrv( Src->Rc_Pd , SRA->RA_FILIAL , "RV_TIPOCOD" ) == "1"
						If (Esc #1) .Or. (Esc == 1 .And. PosSrv(Src->Rc_Pd,Sra->Ra_Filial,"RV_ADIANTA") == "S")
							fSomaPd("P",SRC->RC_PD,SRC->RC_HORAS,SRC->RC_VALOR)
							TOTVENC += Src->Rc_Valor
						Endif
					Elseif PosSrv( Src->Rc_Pd , SRA->RA_FILIAL , "RV_TIPOCOD" ) == "2"
						If (Esc #1) .Or. (Esc == 1 .And. PosSrv(Src->Rc_Pd,Sra->Ra_Filial,"RV_ADIANTA") == "S")
							fSomaPd("D",SRC->RC_PD,SRC->RC_HORAS,SRC->RC_VALOR)
							TOTDESC += Src->Rc_Valor
						Endif
					Elseif PosSrv( Src->Rc_Pd , SRA->RA_FILIAL , "RV_TIPOCOD" ) == "3"
						If (Esc #1) .Or. (Esc == 1 .And. PosSrv(Src->Rc_Pd,Sra->Ra_Filial,"RV_ADIANTA") == "S")
							fSomaPd("B",SRC->RC_PD,SRC->RC_HORAS,SRC->RC_VALOR)
						Endif
					Endif
				Endif
				If ESC = 1
					If SRC->RC_PD == aCodFol[10,1]
						nBaseIr := SRC->RC_VALOR
					Endif
				ElseIf SRC->RC_PD == aCodFol[13,1]
					nAteLim += SRC->RC_VALOR
				Elseif SRC->RC_PD$ aCodFol[108,1]+'*'+aCodFol[17,1]
					nBaseFgts += SRC->RC_VALOR
				Elseif SRC->RC_PD$ aCodFol[109,1]+'*'+aCodFol[18,1]
					nFgts += SRC->RC_VALOR
				Elseif SRC->RC_PD == aCodFol[15,1]
					nBaseIr += SRC->RC_VALOR
				Elseif SRC->RC_PD == aCodFol[16,1]
					nBaseIrFe += SRC->RC_VALOR
				Endif
				dbSelectArea("SRC")
				dbSkip()
			Enddo
		Endif
	Elseif Esc == 3
		dbSelectArea("SRC")
		If dbSeek(SRA->RA_FILIAL + SRA->RA_MAT)
			While !Eof() .And. SRA->RA_FILIAL + SRA->RA_MAT == SRC->RC_FILIAL + SRC->RC_MAT
			    If !Eval(cAcessaSRC)
			       dbSkip()
			       Loop
			    EndIf
				If SRC->RC_PD == aCodFol[22,1]
					fSomaPd("P",SRC->RC_PD,SRC->RC_HORAS,SRC->RC_VALOR)
					TOTVENC += SRC->RC_VALOR
				Elseif SRC->RC_PD == aCodFol[172,1]
					fSomaPd("D",SRC->RC_PD,SRC->RC_HORAS,SRC->RC_VALOR)
					TOTDESC += SRC->RC_VALOR
				Elseif SRC->RC_PD == aCodFol[108,1] .Or. SRC->RC_PD == aCodFol[109,1] .Or. SRC->RC_PD == aCodFol[173,1] 
					fSomaPd("B",SRC->RC_PD,SRC->RC_HORAS,SRC->RC_VALOR)
				Endif
				
				If SRC->RC_PD == aCodFol[108,1]
					nBaseFgts := SRC->RC_VALOR
				Elseif SRC->RC_PD == aCodFol[109,1]
					nFgts     := SRC->RC_VALOR
				Endif
				dbSelectArea("SRC")
				dbSkip()
			Enddo
		Endif
	Elseif Esc == 4
		dbSelectArea("SRI")
		dbSetOrder(2)
		If dbSeek(SRA->RA_FILIAL + SRA->RA_CC + SRA->RA_MAT)
			While !Eof() .And. SRA->RA_FILIAL + SRA->RA_CC + SRA->RA_MAT == SRI->RI_FILIAL + SRI->RI_CC + SRI->RI_MAT
			    If !Eval(cAcessaSRI)
			       dbSkip()
			       Loop
			    EndIf
				If PosSrv( SRI->RI_PD , SRA->RA_FILIAL , "RV_TIPOCOD" ) == "1"
					fSomaPd("P",SRI->RI_PD,SRI->RI_HORAS,SRI->RI_VALOR)
					TOTVENC = TOTVENC + SRI->RI_VALOR
				Elseif PosSrv( SRI->RI_PD , SRA->RA_FILIAL , "RV_TIPOCOD" ) == "2"
					fSomaPd("D",SRI->RI_PD,SRI->RI_HORAS,SRI->RI_VALOR)
					TOTDESC = TOTDESC + SRI->RI_VALOR
				Elseif PosSrv( SRI->RI_PD , SRA->RA_FILIAL , "RV_TIPOCOD" ) == "3"
					fSomaPd("B",SRI->RI_PD,SRI->RI_HORAS,SRI->RI_VALOR)
				Endif

				If SRI->RI_PD == aCodFol[19,1]
					nAteLim += SRI->RI_VALOR
				Elseif SRI->RI_PD$ aCodFol[108,1]
					nBaseFgts += SRI->RI_VALOR
				Elseif SRI->RI_PD$ aCodFol[109,1]
					nFgts += SRI->RI_VALOR
				Elseif SRI->RI_PD == aCodFol[27,1]
					nBaseIr += SRI->RI_VALOR
				Endif
				dbSkip()
			Enddo
		Endif
	Elseif Esc == 5
		dbSelectArea("SR1")
		dbSetOrder(1)
		If dbSeek( SRA->RA_FILIAL + SRA->RA_MAT )
			While !Eof() .And. SRA->RA_FILIAL + SRA->RA_MAT ==	SR1->R1_FILIAL + SR1->R1_MAT
				If Semana #"99"			
					If SR1->R1_SEMANA #Semana
						dbSkip()
						Loop
					Endif
				Endif					
			    If !Eval(cAcessaSR1)
			       dbSkip()
			       Loop
			    EndIf
				If PosSrv( SR1->R1_PD , SRA->RA_FILIAL , "RV_TIPOCOD" ) == "1"
					fSomaPd("P",SR1->R1_PD,SR1->R1_HORAS,SR1->R1_VALOR)
					TOTVENC = TOTVENC + SR1->R1_VALOR
				Elseif PosSrv( SR1->R1_PD , SRA->RA_FILIAL , "RV_TIPOCOD" ) == "2"
					fSomaPd("D",SR1->R1_PD,SR1->R1_HORAS,SR1->R1_VALOR)
					TOTDESC = TOTDESC + SR1->R1_VALOR
				Elseif PosSrv( SR1->R1_PD , SRA->RA_FILIAL , "RV_TIPOCOD" ) == "3"
					fSomaPd("B",SR1->R1_PD,SR1->R1_HORAS,SR1->R1_VALOR)
				Endif
				dbskip()
			Enddo
		Endif
	Endif
	
	dbSelectArea("SRA")
	
	If TOTVENC = 0 .And. TOTDESC = 0
		dbSkip()
		Loop
	Endif
	
	If Vez == 0  .And.  Esc == 2 //--> Verifica se for FOLHA.
		PerSemana() // Carrega Datas referentes a Semana.
	EndIf
	
	If nTipRel == 1
		fImpressao()   // Impressao do Recibo de Pagamento
	ElseIf nTipRel == 2
		fImpreZebr()
	ElseIf nTipRel == 4
		// Geracao dos Registros
		fGeraZero() //Gera Registro Zero
		fGeraUm() // Gera Registro Tipo 1
		fGeraDo() // Gera Registro Tipo 2
		fGeraTr() // Gera Registro Tipo 3
		fGeraQu() // Gera Registro Tipo 4 
		fGeraCi() // Gera Registro Tipo 5
		fGeraSe() // Gera Registro Tipo 6			
	Endif
	
	If Vez = 0 .And. nTipRel != 4
		Pergunte("GPR30A",.T.)
		If mv_par01 = 2 // Este mv_par e da "Pergunte" GPR30A" 
			dbSelectArea("SRA")
			TOTDESC := TOTVENC := 0
			LOOP
		Endif
		Vez = 1
	Endif

	dbSelectArea("SRA")

	dbSkip()
	TOTDESC := TOTVENC := 0  
		
ENDDO

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Seleciona arq. defaut do Siga caso Imp. Mov. Anteriores      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !lAtual
	fFimArqMov( cAliasMov , aOrdBag , cArqMov )
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Termino do relatorio                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SRC")
dbSetOrder(1)          // Retorno a ordem 1
dbSelectArea("SRI")
dbSetOrder(1)          // Retorno a ordem 1
dbSelectArea("SRA")
SET FILTER TO
RetIndex("SRA")

If !(Type("cArqNtx") == "U")
	fErase(cArqNtx + OrdBagExt())
Endif

Set Device To Screen

If aReturn[5] = 1 .And. nTipRel != 4
	Set Printer To
	Commit
	ourspool(wnrel)
Endif

MS_FLUSH()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³fImpressao³ Autor ³ R.H. - Ze Maria       ³ Data ³ 14.03.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMRESSAO DO RECIBO FORMULARIO CONTINUO                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ fImpressao()                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
// Substituido pelo assistente de conversao do AP5 IDE em 30/08/00 ==> Static Function fImpressao()
Static Function fImpressao()

Local nConta  := nContr := nContrT:=0
Local aDriver := LEDriver()
Private nLinhas:=16              // Numero de Linhas do Miolo do Recibo

Private cCompac := aDriver[1]
Private cNormal := aDriver[2]

Ordem_Rel := 1

fCabec()

For nConta = 1 To Len(aLanca)
	fLanca(nConta)
	nContr ++
	nContrT ++
	If nContr = nLinhas .And. nContrT < Len(aLanca)
		nContr:=0
		Ordem_Rel ++
		fContinua()
		fCabec()
	Endif
Next

Li+=(nLinhas-nContr)
fRodape()
Li+=3

Return Nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³fImpreZebr³ Autor ³ R.H. - Ze Maria       ³ Data ³ 14.03.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMRESSAO DO RECIBO FORMULARIO ZEBRADO                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ fImpreZebr()                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
// Substituido pelo assistente de conversao do AP5 IDE em 30/08/00 ==> Static Function fImpreZebr()
Static Function fImpreZebr()

Local nConta    := nContr := nContrT:=0

fCabecZ()
fLancaZ(nConta)

Return Nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³fCabec    ³ Autor ³ R.H. - Ze Maria       ³ Data ³ 14.03.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMRESSAO Cabe‡alho Form Continuo                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ fCabec()                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
// Substituido pelo assistente de conversao do AP5 IDE em 30/08/00 ==> Static Function fCabec()   // Cabecalho do Recibo
Static Function fCabec()   // Cabecalho do Recibo()


@ LI,01 PSAY &cNormal+DESC_Fil
LI ++
@ LI,01 PSAY DESC_END
LI ++
@ LI,01 PSAY DESC_CGC

If !Empty(Semana) .And. Semana #'99' .And.  Upper(SRA->RA_TIPOPGT) == 'S'
	@ Li,37 pSay "Semana " + Semana + ' (' + cSem_De + " a " + ;	//'Semana '###' a '
	cSem_Ate + ')'
Else
	@ LI,55 PSAY MesExtenso(MONTH(dDataRef))+"/"+STR(YEAR(dDataRef),4)
EndIf	

LI +=3
@ LI,01 PSAY SRA->RA_Mat
@ LI,08 PSAY Left(SRA->RA_NOME,28)
@ LI,37 PSAY SRA->RA_CBO
@ LI,43 PSAY SRA->RA_Filial
@ LI,54 PSAY SRA->RA_CC
@ LI,65 PSAY ORDEM_REL PICTURE "9999"
LI ++

cDet := 'FUNCAO: ' + SRA->RA_CODFUNC + ' '		//'FUNCAO: '
cDet += DescFun(SRA->RA_CODFUNC,SRA->RA_FILIAL) + ' '
cDet += fDesc("CTT",SRA->RA_CC,"CTT_DESC01") +  ' '
cDet += 'CHAPA: ' + SRA->RA_CHAPA					//'CHAPA: '
@ Li,01 pSay cDet

Li += 2
Return Nil


/*
±±³Descri‡…o ³ IMRESSAO Cabe‡alho Form ZEBRADO                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ fCabecz()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
// Substituido pelo assistente de conversao do AP5 IDE em 30/08/00 ==> Static Function fCabecZ()   // Cabecalho do Recibo Zebrado
Static Function fCabecZ()   // Cabecalho do Recibo Zebrado()

LI ++
@ LI,00 PSAY "*"+REPLICATE("=",130)+"*"

LI ++
@ LI,00  PSAY  "|"
@ LI,46  PSAY "RECIBO DE PAGAMENTO  "		//"RECIBO DE PAGAMENTO  "
@ LI,131 PSAY "|"

LI ++
@ LI,00 PSAY "|"+REPLICATE("-",130)+"|"

LI ++
@ LI,00  PSAY "| Empresa   : " +  DESC_Fil		//"| Empresa   : "
@ LI,92  PSAY " Local : " + SRA->RA_FILIAL	//" Local : "
@ LI,131 PSAY "|"

LI ++
@ LI,00 PSAY "| C Custo   : " + SRA->RA_CC + " - " + DescCc(SRA->RA_CC,SRA->RA_FILIAL)	//"| C Custo   : "
If !Empty(Semana) .And. Semana #"99" .And.  Upper(SRA->RA_TIPOPGT) == "S"
	@ Li,92 pSay 'Sem.' + Semana + " (" + cSem_De + ' a ' + ;   //'Sem.'###' a '
	cSem_Ate + ")"
Else
	@ LI,92 PSAY MesExtenso(MONTH(dDataRef))+"/"+STR(YEAR(dDataRef),4)
EndIf	
@ LI,131 PSAY "|"	

LI ++
ORDEMZ ++
@ LI,00  PSAY "| Matricula : " + SRA->RA_MAT		//"| Matricula : "
@ LI,30  PSAY "Nome  : " + SRA->RA_NOME	//"Nome  : "
@ LI,92  PSAY "Ordem : "						//"Ordem : "
@ LI,100 PSAY StrZero(ORDEMZ,4) Picture "9999"
@ LI,131 PSAY "|"

LI ++
@ LI,00  PSAY "| Funcao    : "+SRA->RA_CODFUNC+" - "+DescFun(SRA->RA_CODFUNC,SRA->RA_FILIAL)	//"| Funcao    : "
@ LI,131 PSAY "|"

LI ++
@ LI,00 PSAY "|"+REPLICATE("-",130)+"|"

LI ++
@ LI,000 PSAY "| P R O V E N T O S "		//"| P R O V E N T O S "
@ LI,044 PSAY "  D E S C O N T O S"		//"  D E S C O N T O S"
@ LI,088 PSAY "  B A S E S"		//"  B A S E S"
@ LI,131 PSAY "|"

LI ++
@ LI,00 PSAY "|"+REPLICATE("-",130)+"|"
LI++

Return Nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³Descri‡…o ³ Impressao das Verbas (Lancamentos) Form. Continuo          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ fLanca()                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
// Substituido pelo assistente de conversao do AP5 IDE em 30/08/00 ==> Static Function fLanca(nConta)   // Impressao dos Lancamentos
Static Function fLanca(nConta)   // Impressao dos Lancamentos()

Local cString := Transform(aLanca[nConta,5],"@E 99,999,999.99")
Local nCol := If(aLanca[nConta,1]="P",43,If(aLanca[nConta,1]="D",57,27))

@ LI,01 PSAY aLanca[nConta,2]
@ LI,05 PSAY aLanca[nConta,3]
If aLanca[nConta,1] #"B"        // So Imprime se nao for base
    @ LI,36 PSAY TRANSFORM(aLanca[nConta,4],"999.99")
Endif
@ LI,nCol PSAY cString
Li ++

Return Nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao das Verbas (Lancamentos) Zebrado                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ fLancaZ()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
// Substituido pelo assistente de conversao do AP5 IDE em 30/08/00 ==> Static Function fLancaZ(nConta)   // Impressao dos Lancamentos
Static Function fLancaZ(nConta)   // Impressao dos Lancamentos()

Local nTermina  := 0
Local nCont     := 0
Local nCont1    := 0
Local nValidos  := 0

nTermina := Max(Max(LEN(aProve),LEN(aDesco)),LEN(aBases))

For nCont := 1 To nTermina
   @ LI,00 PSAY "|"
	IF nCont <= LEN(aProve)
		@ LI,02 PSAY aProve[nCont,1]+TRANSFORM(aProve[nCont,2],'999.99')+TRANSFORM(aProve[nCont,3],"@E 999,999.99")
	ENDIF
	@ LI,44 PSAY "|"
	IF nCont <= LEN(aDesco)
		@ LI,46 PSAY aDesco[nCont,1]+TRANSFORM(aDesco[nCont,2],'999.99')+TRANSFORM(aDesco[nCont,3],"@E 999,999.99")
	ENDIF
	@ LI,88 PSAY "|"
	IF nCont <= LEN(aBases)
		@ LI,90 PSAY aBases[nCont,1]+TRANSFORM(aBases[nCont,2],'999.99')+TRANSFORM(aBases[nCont,3],"@E 999,999.99")
	ENDIF
	@ LI,131 PSAY "|"
	
	//---- Soma 1 nos nValidos e Linha
	nValidos ++
	Li ++
	
	If nValidos = 12
		@ LI,00 PSAY "|"+REPLICATE("-",130)+"|"
		LI ++
		@ LI,00 PSAY "|"
		@ LI,05 PSAY "CONTINUA !!!"			// "CONTINUA !!!"
//		@ LI,76 PSAY "|"+&cCompac
		LI ++
      @ LI,00 PSAY "*"+REPLICATE("=",130)+"*"
		LI += 8
		fCabecZ()
		nValidos := 0
    ENDIF
Next

For nCont1 := nValidos+1 To 12
    @ Li,00  PSAY "|"
    @ Li,44  PSAY "|"
    @ Li,88  PSAY "|"
    @ Li,131 PSAY "|"
Li++
Next
   @ LI,00 PSAY "|"+REPLICATE("-",130)+"|"
   LI ++
   @ LI,000 PSAY "|"
   @ LI,005 PSAY DESC_MSG1
   @ LI,044 PSAY "| TOTAL BRUTO     "+SPACE(10)+TRANS(TOTVENC,"@E 999,999,999.99")	//"| TOTAL BRUTO     "
   @ LI,088 PSAY "|"+" TOTAL DESCONTOS     "+SPACE(07)+TRANS(TOTDESC,"@E 999,999,999.99")	//" TOTAL DESCONTOS     "
   @ LI,131 PSAY "|"
   LI ++
   @ LI,000 PSAY "|"
   @ LI,005 PSAY DESC_MSG2
   @ LI,044 PSAY "|"+REPLICATE("-",86)+"|"

LI ++
@ LI,000 PSAY "|"
@ LI,005 PSAY DESC_MSG3
@ LI,044 PSAY "| CREDITO:"+SRA->RA_BCDEPSAL+"-"+DescBco(SRA->RA_BCDEPSAL,SRA->RA_FILIAL)	//"| CREDITO:"
@ LI,089 PSAY "| LIQUIDO A RECEBER     "+SPACE(05)+TRANS((TOTVENC-TOTDESC),"@E 999,999,999.99")			//"| LIQUIDO A RECEBER     "
@ LI,132 PSAY "|"

LI ++
@ LI,000 PSAY "|"+REPLICATE("-",130)+"|"

LI ++
@ LI,000 PSAY "|"
@ LI,044 PSAY "| CONTA:" + SRA->RA_CTDEPSAL		//"| CONTA:"
@ LI,088 PSAY "|"
@ LI,131 PSAY "|"

LI ++
@ LI,000 PSAY "|"+REPLICATE("-",130)+"|"

LI ++
@ LI,00  PSAY "| Recebi o valor acima em ___/___/___ " + Replicate("_",40)		//"| Recebi o valor acima em ___/___/___ "
@ li,131 PSAY "|"

LI ++
@ LI,00 PSAY "*"+REPLICATE("=",130)+"*"

ASize(AProve,0)
ASize(ADesco,0)
ASize(aBases,0)

Li += 1

//Quebrar pagina
If LI > 63
	LI := 0
EndIf
Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressap da Continuacao do Recibo                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ fContinua()                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
// Substituido pelo assistente de conversao do AP5 IDE em 30/08/00 ==> Static Function fContinua()    // Continuacao do Recibo
Static Function fContinua()    // Continuacao do Recibo()

Li+=1
   @ LI,05 PSAY &cNormal + "CONTINUA !!!"		//"CONTINUA !!!"
Li+=8
Return Nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³Descri‡…o ³ Impressao do Rodape                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ fRodape()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
// Substituido pelo assistente de conversao do AP5 IDE em 30/08/00 ==> Static Function fRodape()    // Rodape do Recibo
Static Function fRodape()    // Rodape do Recibo()

@ LI,05 PSAY DESC_MSG1
LI ++
@ LI,05 PSAY DESC_MSG2
@ LI,42 PSAY TOTVENC PICTURE "@E 999,999,999.99"
@ LI,56 PSAY TOTDESC PICTURE "@E 999,999,999.99"
LI ++
@ LI,05 PSAY DESC_MSG3
LI ++
MESCOMP = IIF(MONTH(dDataRef) + 1 > 12,01,MONTH(dDataRef))
IF MESCOMP = MONTH(SRA->RA_NASC)
    @ LI, 02 PSAY "F E L I Z   A N I V E R S A R I O  ! !"		//"F E L I Z   A N I V E R S A R I O  ! !"
ENDIF
@ LI,56 PSAY TOTVENC - TOTDESC PICTURE "@E 999,999,999.99"
LI +=2

If !lAtual
	nValSal := 0
	fBuscaSlr(@nValSal,MesAno(dDataRef))
	If nValSal ==0
		nValSal := SRA->RA_SALARIO
	EndIf
Else
	nValSal := SRA->RA_SALARIO
EndIf
@ LI,05 PSAY &cCompac+Transform(nValSal,"@E 99,999,999.99")

If Esc = 1  // Bases de Adiantamento
    If cBaseAux = "S" .And. nBaseIr #0
        @ LI,89 PSAY nBaseIr PICTURE "@E 999,999,999.99"
    Endif
ElseIf Esc = 2 .Or. Esc = 4  // Bases de Folha e 13o. 2o.Parc.
	If cBaseAux = "S"
		@ LI,23 PSAY Transform(nAteLim,"@E 999,999,999.99")
		If nBaseFgts #0
			@ LI,46 PSAY nBaseFgts PICTURE "@E 999,999,999.99"
		Endif
		If nFgts #0
			@ LI,66 PSAY nFgts PICTURE "@E 99,999,999.99"
		Endif
		If nBaseIr #0
			@ LI,89 PSAY nBaseIr PICTURE "@E 999,999,999.99"
		Endif
		@ LI,103 PSAY Transform(nBaseIrfE,"@E 999,999,999.99")
	Endif
ElseIf Esc = 3 // Bases de FGTS e FGTS Depositado da 1¦ Parcela 
	If cBaseAux = "S"
		If nBaseFgts #0
			@ LI,46 PSAY nBaseFgts PICTURE "@E 999,999,999.99"
		Endif
		If nFgts #0
			@ LI,66 PSAY nFgts PICTURE "@E 99,999,999.99"
		Endif
	Endif
Endif

@ LI,Pcol() Psay &cNormal

Li ++
IF SRA->RA_BCDEPSAL #SPACE(8)
	Desc_Bco := DescBco(Sra->Ra_BcDepSal,Sra->Ra_Filial)
    @ LI,01 PSAY "CRED:"	//"CRED:"
    @ LI,06 PSAY SRA->RA_BCDEPSAL
    @ LI,14 PSAY "-"
    @ LI,15 PSAY DESC_BCO
    @ LI,60 PSAY "CONTA:" + SRA->RA_CTDEPSAL	//"CONTA:"
ENDIF
Return Nil

********************
// Substituido pelo assistente de conversao do AP5 IDE em 30/08/00 ==> Function PerSemana() // Pesquisa datas referentes a semana.
Static Function PerSemana() // Pesquisa datas referentes a semana.()
********************

If !Empty(Semana) 
	cChaveSem := StrZero(Year(dDataRef),4)+StrZero(Month(dDataRef),2)+SRA->RA_TNOTRAB
	If !Srx->(dbSeek(If(cFilial=="  ","  ",SRA->RA_FILIAL) + "01" + cChaveSem + Semana , .T. )) .And. ;
		!Srx->(dbSeek(If(cFilial=="  ","  ",SRA->RA_FILIAL) + "01" + Subs(cChaveSem,3,9) + Semana , .T. )) .And. ;
		!Srx->(dbSeek(If(cFilial=="  ","  ",SRA->RA_FILIAL) + "01" + Left(cChaveSem,6)+"999"+ Semana , .T. )) .And. ;
		!Srx->(dbSeek(If(cFilial=="  ","  ",SRA->RA_FILIAL) + "01" + Subs(cChaveSem,3,4)+"999"+ Semana , .T. )) .And. ;
		HELP( " ",1,"SEMNAOCAD" )
		Return Nil
	Endif
	
	If Len(AllTrim(SRX->RX_COD)) == 9
		cSem_De  := Transforma(CtoD(Left(SRX->RX_TXT,8)),"DDMMYY")
		cSem_Ate := Transforma(CtoD(Subs(SRX->RX_TXT,10,8)),"DDMMYY")
	Else
	   cSem_De  := Transforma(If("/" $ SRX->RX_TXT , CtoD(SubStr( SRX->RX_TXT, 1,10)) , StoD(SubStr( SRX->RX_TXT, 1,8 ))),"DDMMYY")
	   cSem_Ate := Transforma(If("/" $ SRX->RX_TXT , CtoD(SubStr( SRX->RX_TXT, 12,10)), StoD(SubStr( SRX->RX_TXT,12,8 ))),"DDMMYY")
	EndIf
EndIf	

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Descri‡…o ³ Somar as Verbas no Array                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ fSomaPd(Tipo,Verba,Horas,Valor)                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
// Substituido pelo assistente de conversao do AP5 IDE em 30/08/00 ==> Static Function fSomaPd(cTipo,cPd,nHoras,nValor)
Static Function fSomaPd(cTipo,cPd,nHoras,nValor)

Local Desc_paga

Desc_paga := DescPd(cPd,Sra->Ra_Filial)  // mostra como pagto

If cTipo #'B'
    //--Array para Recibo Pre-Impresso
    nPos := Ascan(aLanca,{ |X| X[2] = cPd })
    If nPos == 0
        Aadd(aLanca,{cTipo,cPd,Desc_Paga,nHoras,nValor})
    Else
       aLanca[nPos,4] += nHoras
       aLanca[nPos,5] += nValor
    Endif
Endif

//--Array para o Recibo Pre-Impresso
If cTipo = 'P'
   cArray := "aProve"
Elseif cTipo = 'D'
   cArray := "aDesco"
Elseif cTipo = 'B'
   cArray := "aBases"
Endif

nPos := Ascan(&cArray,{ |X| X[1] = cPd })
If nPos == 0
    Aadd(&cArray,{cPd+" "+Desc_Paga,nHoras,nValor })
Else
    &cArray[nPos,2] += nHoras
    &cArray[nPos,3] += nValor
Endif
Return

*-------------------------------------------------------
// Substituido pelo assistente de conversao do AP5 IDE em 30/08/00 ==> Static Function Transforma(dData) //Transforma as datas no formato DD/MM/AAAA
Static Function Transforma(dData) //Transforma as datas no formato DD/MM/AAAA()
*-------------------------------------------------------
Return(StrZero(Day(dData),2) +"/"+ StrZero(Month(dData),2) +"/"+ Right(Str(Year(dData)),4))

// Fim da Rotina

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ fGeraZero ³ Autor ³ Jose Carlos Gouveia  ³ Data ³ 20.08.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Gera Registro Tipo Zero                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ fGeraZero()                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fGeraZero

//Local cMesAno_ := MesExtenso(Month(dDataBase))+'/'+StrZero(Year(dDataBase),4)
//cMesAno_ := Left(cMesAno_ + Space(14),14)

nSeq_ += 1

//cReg  := '0' + Desc_Fil + " - "  + Desc_Uni + " - " + SRA->RA_FILIAL + Desc_CGC + cMesAno_
cReg  := '0' + Desc_Fil + " - "  + Desc_Uni + " - " + SRA->RA_FILIAL
cReg  := cReg + Space(156) + StrZero(nSeq_,5) + CRLF

nSeq_ += 1

GravaReg()

Return

// Fim da Rotina

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³  fGeraUm  ³ Autor ³ Jose Carlos Gouveia  ³ Data ³ 20.08.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Gera Registro Tipo 1                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ fGeraUm()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fGeraUm

Local cMesAno_ := MesExtenso(Month(dDataBase))+'/'+StrZero(Year(dDataBase),4)
Local _cDescCC := ""
Local _cDescFunc := ""              
Local _cCodCC := ""
cMesAno_ := Left(cMesAno_ + Space(14),14)

CTT->( dbsetorder(1) )
CTT->( dbseek(xFilial("CTT") + SRA->RA_CC) )
_cDescCC := Left(CTT->CTT_DESC01,20)
_cCodCC := CTT->CTT_CUSTO

SRJ->( dbsetorder(1) )
SRJ->( Dbseek(xFilial("SRJ") + SRA->RA_CODFUNC, .T.) )
_cDescFunc := Left(SRJ->RJ_DESC,25)

//DescCc(SRA->RA_CC,SRA->RA_FILIAL) //Posiciona Centro de Custo
//DescFun(SRA->RA_CODFUNC,SRA->RA_FILIAL) //Posiciona Funcao

 
cReg := '1' + Desc_CGC + cMesAno_ + _cCodCC + _cDescCC
cReg := cReg + SRA->RA_MAT + SUBS(SRA->RA_NOME,1,30) + Left(_cDescFunc,13) + STRZERO(VAL(SRA->RA_NUMCP),8) + SRA->RA_SERCP   //aumento do tamanho de 7 para 8 carcter, campo RA_NUMCP: por Ivanete
cReg := cReg + SRA->RA_DEPSF + SRA->RA_DEPIR
cReg := cReg + substr(Posicione("SA6",1,(xFilial("SA6")+LEFT(SRA->RA_BCDEPSA,3)),"A6_NOME"),1,15) + SRA->RA_BCDEPSA
cReg := cReg + Left(SRA->RA_CTDEPSAL,11) + StrZero(SRA->RA_SALARIO * 100,12) + SRA->RA_CIC
cReg := cReg + StrZero(Day(_DDATA_PGTO),2)+" "+Left((AllTrim(Mes(_DDATA_PGTO))),9)+" " + Padr(alltrim(Str(Year(_DDATA_PGTO))),12)
If Len(cReg) >= 221
	cReg := Left(cReg,220)
Else
	cReg := Padr(cReg,220)
Endif
cReg := cReg + StrZero(nSeq_,5) + CRLF

//cReg := cReg + SRA->RA_CTDEPSAL + SPACE(7) + StrZero(nSeq_,5) + CRLF
//cReg := cReg + SRA->RA_CTDEPSAL + STR(SRA->RA_HRSMES) + SPACE(2) + StrZero(nSeq_,5) + CRLF
//cReg := cReg + SRA->RA_CTDEPSAL + STRZERO(SRA->RA_HRSMES,5) + SPACE(2) + StrZero(nSeq_,5) + CRLF

GravaReg()

nSeq_ += 1

Return

// Fim da Rotina

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Gera Registro Tipo 2                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ fGeraDo()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fGeraDo

For nX_ := 1 to Len(aProve)

	cReg := '2' + Subst(aProve[nX_,1],1,3) + Subst(aProve[nX_,1],5,20) + StrZero(aProve[nX_,2] * 100,6)
	cReg := cReg + StrZero(aProve[nX_,3] * 100,12) + Space(178) 
	cReg := cReg + StrZero(nSeq_,5) + CRLF
	
	GravaReg()

	nSeq_ += 1

Next nX_

Return

//Fim da Rotina

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Gera Registro Tipo 3                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ fGeraTr()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fGeraTr

For nX_ := 1 to Len(aDesco)

	cReg := '3' + Subst(aDesco[nX_,1],1,3) + Subst(aDesco[nX_,1],5,20) + StrZero(aDesco[nX_,2] * 100,6)
	cReg := cReg + StrZero(aDesco[nX_,3] * 100,12) + Space(178) 
	cReg := cReg + StrZero(nSeq_,5) + CRLF
	
	GravaReg()

	nSeq_ += 1

Next nX_

Return

//Fim da Rotina

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Gera Registro Tipo 4                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ fGeraQu()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fGeraQu

If cBaseAux == 'S'
        For nX_ := 1 to Len(aBases)

    /*    If Subst(aBases[nX_,1],1,3) $ "701*702*703*704*725*727*730*745*746*755*756"            
                cReg := '4' + Subst(aBases[nX_,1],1,3) + Subst(aBases[nX_,1],5,20) + StrZero(aBases[nX_,2] * 100,6)
                cReg := cReg + StrZero(aBases[nX_,3] * 100,12) + Space(178) 
                cReg := cReg + StrZero(nSeq_,5) + CRLF

                nSeq_ += 1

                GravaReg()
        Endif  
    */
       //   If Posicione("SRV",1,XFILIAL("SRV")+Substr(aBases[nX_,1],1,3),"SRV->RV_CODFOL")$("013*017*015*016*017*018*108*109*167")
IF cEmpAnt $ 'E9'
	If Posicione("SRV",1,XFILIAL("SRV")+Substr(aBases[nX_,1],1,3),"SRV->RV_CODFOL")$("0013*0015*0016*0017*0018*0019*0027*0108*0109") //inserido códigos 019 e 027, em 14/12/2011 por Ivanete
		cReg := '4' + Subst(aBases[nX_,1],1,3) + Subst(aBases[nX_,1],5,20) + StrZero(aBases[nX_,2] * 100,6)
		cReg := cReg + StrZero(aBases[nX_,3] * 100,12) + Space(178)
		cReg := cReg + StrZero(nSeq_,5) + CRLF
		
		nSeq_ += 1
		
		GravaReg()
	Endif
	
ELSE
	
	If Posicione("SRV",1,XFILIAL("SRV")+Substr(aBases[nX_,1],1,3),"SRV->RV_CODFOL")$("0013*0015*0016*0017*0018*0019*0027*0108*0109*0167") //inserido códigos 019 e 027, em 14/12/2011 por Ivanete
		cReg := '4' + Subst(aBases[nX_,1],1,3) + Subst(aBases[nX_,1],5,20) + StrZero(aBases[nX_,2] * 100,6)
		cReg := cReg + StrZero(aBases[nX_,3] * 100,12) + Space(178)
		cReg := cReg + StrZero(nSeq_,5) + CRLF
		
		nSeq_ += 1
		
		GravaReg()
	Endif
	
ENDIF
        Next nX_        
Else
	cReg := '4' + Space(23) + StrZero(0,18) + Space(178)
	cReg := cReg + StrZero(nSeq_,5) + CRLF

	nSeq_ += 1

	GravaReg()
   
Endif
Return

// Fim da Rotina

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Gera Registro Tipo 5                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ fGeraCi()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fGeraCi 

Local Msg1 := Desc_Msg1 + Space(40 - Len(Desc_Msg1))
Local Msg2 := Desc_Msg2 + Space(40 - Len(Desc_Msg2))
Local Msg3 := Desc_Msg3 + Space(40 - Len(Desc_Msg3))

cReg := '5' + Msg1 + Msg2 + Msg3

MesComp = Iif(Month(dDataRef) + 1 > 12,01,Month(dDataRef))

If MesComp = Month(SRA->RA_NASC)
	cReg := cReg + "F E L I Z   A N I V E R S A R I O  ! !" + space(2) + Space(59)
Else
	cReg := cReg + space(40) + Space(59)
EndIf

cReg := cReg + StrZero(nSeq_,5) + CRLF

GravaReg()

nSeq_ += 1

Return

//Fim da Rotina

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Gera Registro Tipo 6                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ fGeraSe()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fGeraSe

cReg := '6' + StrZero(TotVenc * 100,12) + StrZero(TotDesc * 100,12) 
cReg := cReg + StrZero((TotVenc - TotDesc) * 100,12) + Space(183)
cReg := cReg + StrZero(nSeq_,5) + CRLF

GravaReg()

//nSeq_ += 1

Return

// Fim da Rotina
   
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Descri‡„o ³ Grava Registro                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ GravaReg                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ GeraRec                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³      ³                                          ³±±
±±³            ³        ³      ³                                          ³±±
±±³            ³        ³      ³                                          ³±±
±±³            ³        ³      ³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±/*/
Static Function GravaReg

If fWrite(nHdl,cReg,Len(cReg)) != Len(cReg)
	If !MsgYesNo('Ocorreu um erro na grava‡„o do arquivo '+AllTrim(cNomeArq)+'.   Continua?','Aten‡„o!')
		lContinua := .F.
		Return
	Endif
Endif

Return

// Fim da Rotina


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³VALIDPERG º Autor ³ AP5 IDE            º Data ³  27/10/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Verifica a existencia das perguntas criando-as caso seja   º±±
±±º          ³ necessario (caso nao existam).                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß */
Static Function fAsrPerg()


Local aRegs := {}

 // Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
 aAdd(aRegs,{ cPerg,'01','Data de Referencia           ?','','','mv_ch1','D',08,0,0,'G','NaoVazio'   ,'mv_par01',''                 ,'','','','',''                 ,'','','','',''                    ,'','','','',''                 ,'','','','',''        ,'','','' ,'   ','' })
 aAdd(aRegs,{ cPerg,'02','Tipo do Recibo               ?','','','mv_ch2','N',01,0,0,'C',''           ,'mv_par02','Pre-Impresso'     ,'','','','','Zebrado'          ,'','','','','Email'               ,'','','','','Arquivo'          ,'','','','',''        ,'','','' ,'   ','' })
 aAdd(aRegs,{ cPerg,'03','Emitir Recibos               ?','','','mv_ch3','N',01,0,0,'C',''           ,'mv_par03','Adiantamento'     ,'','','','','Folha'            ,'','','','','1a Parcela'          ,'','','','','2a Parcela'       ,'','','','','Extras'  ,'','','' ,'   ','' })
 aAdd(aRegs,{ cPerg,'04','Numero da Semana             ?','','','mv_ch4','C',02,0,0,'G',''           ,'mv_par04',''                 ,'','','','',''                 ,'','','','',''                    ,'','','','',''                 ,'','','','',''        ,'','','' ,'   ','' })
 aAdd(aRegs,{ cPerg,'05','Filial De                    ?','','','mv_ch5','C',02,0,0,'G',''           ,'mv_par05',''                 ,'','','','',''                 ,'','','','',''                    ,'','','','',''                 ,'','','','',''        ,'','','' ,'XM0','' })
 aAdd(aRegs,{ cPerg,'06','Filial Ate                   ?','','','mv_ch6','C',02,0,0,'G','NaoVazio'   ,'mv_par06',''                 ,'','','','',''                 ,'','','','',''                    ,'','','','',''                 ,'','','','',''        ,'','','' ,'XM0','' })
 aAdd(aRegs,{ cPerg,'07','Centro Custo De              ?','','','mv_ch7','C',20,0,0,'G',''           ,'mv_par07',''                 ,'','','','',''                 ,'','','','',''                    ,'','','','',''                 ,'','','','',''        ,'','','' ,'CTT','' })
 aAdd(aRegs,{ cPerg,'08','Centro Custo Ate             ?','','','mv_ch8','C',20,0,0,'G','NaoVazio'   ,'mv_par08',''                 ,'','','','',''                 ,'','','','',''                    ,'','','','',''                 ,'','','','',''        ,'','','' ,'CTT','' })
 aAdd(aRegs,{ cPerg,'09','Matricula De                 ?','','','mv_ch9','C',06,0,0,'G',''           ,'mv_par09',''                 ,'','','','',''                 ,'','','','',''                    ,'','','','',''                 ,'','','','',''        ,'','','' ,'SRA','' })
 aAdd(aRegs,{ cPerg,'10','Matricula Ate                ?','','','mv_cha','C',06,0,0,'G','NaoVazio'   ,'mv_par10',''                 ,'','','','',''                 ,'','','','',''                    ,'','','','',''                 ,'','','','',''        ,'','','' ,'SRA','' })
 aAdd(aRegs,{ cPerg,'11','Nome De                      ?','','','mv_chb','C',30,0,0,'G',''           ,'mv_par11',''                 ,'','','','',''                 ,'','','','',''                    ,'','','','',''                 ,'','','','',''        ,'','','' ,'   ','' })
 aAdd(aRegs,{ cPerg,'12','Nome Ate                     ?','','','mv_chc','C',30,0,0,'G','NaoVazio'   ,'mv_par12',''                 ,'','','','',''                 ,'','','','',''                    ,'','','','',''                 ,'','','','',''        ,'','','' ,'   ','' })
 aAdd(aRegs,{ cPerg,'13','Chapa De                     ?','','','mv_chd','C',05,0,0,'G',''           ,'mv_par13',''                 ,'','','','',''                 ,'','','','',''                    ,'','','','',''                 ,'','','','',''        ,'','','' ,'   ','' })
 aAdd(aRegs,{ cPerg,'14','Chapa Ate                    ?','','','mv_che','C',05,0,0,'G','NaoVazio'   ,'mv_par14',''                 ,'','','','',''                 ,'','','','',''                    ,'','','','',''                 ,'','','','',''        ,'','','' ,'   ','' })
 aAdd(aRegs,{ cPerg,'15','Mensagem 1                   ?','','','mv_chf','C',40,0,0,'G',''           ,'mv_par15',''                 ,'','','','',''                 ,'','','','',''                    ,'','','','',''                 ,'','','','',''        ,'','','' ,'   ','' })
 aAdd(aRegs,{ cPerg,'16','Mensagem 2                   ?','','','mv_chg','C',40,0,0,'G',''           ,'mv_par16',''                 ,'','','','',''                 ,'','','','',''                    ,'','','','',''                 ,'','','','',''        ,'','','' ,'   ','' })
 aAdd(aRegs,{ cPerg,'17','Mensagem 3                   ?','','','mv_chh','C',40,0,0,'G',''           ,'mv_par17',''                 ,'','','','',''                 ,'','','','',''                    ,'','','','',''                 ,'','','','',''        ,'','','' ,'   ','' })
 aAdd(aRegs,{ cPerg,'18','Situacoes                    ?','','','mv_chi','C',05,0,0,'G','fSituacao'  ,'mv_par18',''                 ,'','','','',''                 ,'','','','',''                    ,'','','','',''                 ,'','','','',''        ,'','','' ,'   ','' })
 aAdd(aRegs,{ cPerg,'19','Categorias                   ?','','','mv_chj','C',12,0,0,'G','fCategoria' ,'mv_par19',''                 ,'','','','',''                 ,'','','','',''                    ,'','','','',''                 ,'','','','',''        ,'','','' ,'   ','' })
 aAdd(aRegs,{ cPerg,'20','Imprimir Bases               ?','','','mv_chk','N',01,0,0,'C',''           ,'mv_par20','Sim'              ,'','','','','Nao'              ,'','','','',''                    ,'','','','',''                 ,'','','','',''        ,'','','' ,'   ','' })
 aAdd(aRegs,{ cPerg,'21','Arquivo de Saida             ?','','','mv_chl','C',30,0,0,'G',''           ,'mv_par21',''                 ,'','',_cNameFile,'',''                 ,'','','','',''                    ,'','','','',''                 ,'','','','',''        ,'','','' ,'   ','' })
 aAdd(aRegs,{ cPerg,'22','Data de Pagamento            ?','','','mv_chm','D',08,0,0,'G','NaoVazio'   ,'mv_par22',''                 ,'','','','',''                 ,'','','','',''                    ,'','','','',''                 ,'','','','',''        ,'','','' ,'   ','' })

ValidPerg(aRegs,cPerg)

Return   

//Fim do Programa