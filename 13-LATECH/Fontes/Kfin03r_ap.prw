#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05
#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF

User Function Kfin03r()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("WNREL,CDESC1,CDESC2,CDESC3,CSTRING,LEND")
SetPrvt("TAMANHO,LIMITE,TITULO,ARETURN,NOMEPROG,NLASTKEY")
SetPrvt("ADRIVER,CBCONT,CPERG,NLIN,M_PAG,CEXTENSO")
SetPrvt("AEXTENSO,J,I,AREGS,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ KFIN03R  ³ Autor ³Ricardo Correa de Souza³ Data ³01/02/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Impressao da Nota de Debito                                ³±±
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
#IFNDEF WINDOWS
	// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 12/02/05 ==>     #DEFINE PSAY SAY
#ENDIF

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Arquivos e Indices Utilizados                                             *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

DbSelectArea("SA1")             //----> Cadastro de Clientes
DbSetOrder(1)                   //----> Codigo + Loja

DbSelectArea("SZ6")             //----> Notas de Debito
DbSetOrder(1)                   //----> Nota Debito + Titulo Origem

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Variaveis Utilizadas no Relatorio                                         *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

wnrel     := "KFIN03R"
cDesc1    := "Este relatorio ira emitir as Notas de Debito"
cDesc2    := "conforme parametros definidos pelo usuario."
cDesc3    := " "
cString   := "SE1"
lEnd      := .F.
tamanho   := "P"
limite    := 80
titulo    := "Nota de Debito"
aReturn   := { "Zebrado", 1,"Administracao", 2, 2, 1, "",0 }
nomeprog  := "KFIN03R"
nLastKey  := 0
aDriver   := ReadDriver()
cbCont    := 00
cPerg     := "FIN03R    "
nLin      := 31
m_pag     := 1
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Variaveis Utilizadas para Parametros                                      *
*                                                                           *
* mv_par01  ----> Da Nota     ?                                             *
* mv_par02  ----> Ate a Nota  ?                                             *
*                                                                           *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

ValidPerg()     //----> Atualiza o arquivo de perguntas SX1

Pergunte(cPerg,.f.)

wnrel := SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.)

If nLastKey == 27
	Set Filter To
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Set Filter to
	Return
Endif

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Processamento                                                             *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

#IFDEF WINDOWS
	RptStatus({|| Imprime()},titulo)// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==>     RptStatus({|| Execute(Imprime)},titulo)
#ELSE
	Imprime()
#ENDIF

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function Imprime
Static Function Imprime()

DbSelectArea("SE1")
DbSetOrder(1)
DbSeek(xFilial("SE1")+MV_PAR01+MV_PAR03+MV_PAR05)

SetRegua(LastRec())
While Eof() == .f. .And. SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA <= MV_PAR02+MV_PAR04+MV_PAR06
	
	IncRegua()
	
	If SE1->E1_TIPO < MV_PAR07 .OR. SE1->E1_TIPO > MV_PAR08
		DbSkip()
		Loop
	EndIf
	
	@ 000, 000 PSAY Chr(18)
	@ 002, 067 PSAY Dtoc(SE1->E1_EMISSAO)
	@ 009, 004 PSAY SE1->E1_NUM
	@ 009, 017 PSAY SE1->E1_VALOR     Picture "@E 999,999,999.99"
	@ 009, 038 PSAY SE1->E1_NUM
	@ 009, 051 PSAY Dtoc(SE1->E1_VENCTO)
	
	DbSelectArea("SA1")
	DbSetOrder(1)
	DbSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA)
	
	@ 014, 009 PSAY SA1->A1_NOME
	@ 015, 009 PSAY SA1->A1_END
	@ 015, 043 PSAY SA1->A1_BAIRRO
	@ 016, 009 PSAY SA1->A1_MUN
	@ 016, 043 PSAY SA1->A1_EST
	@ 016, 062 PSAY TRANSFORM(SA1->A1_CEP,"@R 99999-999")
	@ 017, 009 PSAY SA1->A1_MUN
	@ 018, 009 PSAY SA1->A1_CGC    PICTURE "@R 99.999.999/9999-99"
	@ 018, 043 PSAY SA1->A1_INSCR  PICTURE "@R 999.999.999.999"
	@ 020, 009 PSAY SA1->A1_ENDCOB
	@ 020, 043 PSAY SA1->A1_BAIRROC
	@ 021, 009 PSAY SA1->A1_MUNC
	@ 021, 043 PSAY SA1->A1_ESTC
	@ 021, 062 PSAY TRANSFORM(SA1->A1_CEPC,"@R 99999-999")
	
	cExtenso:=Extenso(SE1->E1_VALOR,.F.,1)
	cExtenso:=cExtenso + Replicate('*',Iif(Len(cExtenso)<180,180-Len(cExtenso),0))
	
	aExtenso:={"","",""}
	J:=1
	For I:=1 to 3
		aExtenso[I]:=Subs(cExtenso,J,60)
		@ 022+I, 017 PSAY aExtenso[I]
		J:=J+60
	Next
	
	nLin := 31
	
	DbSelectArea("SZ6")
	DbSetOrder(1)
	DbSeek(xFilial("SZ6")+SE1->E1_NUM)
	
	SetRegua(LastRec())
	While Eof() == .f. .And. SZ6->Z6_NOTADEB ==  SE1->E1_NUM
		
		@ nLin, 010 PSAY SZ6->Z6_PREFIXO+" "+SZ6->Z6_NUMERO+" "+SZ6->Z6_PARCELA
		@ nLin, 020 PSAY SZ6->Z6_VALOR                   PICTURE "@E 999,999,999.99"
		@ nLin, 039 PSAY DTOC(SZ6->Z6_VENCTO)
		@ nLin, 052 PSAY DTOC(SZ6->Z6_BAIXA)
		@ nLin, 062 PSAY (SZ6->Z6_JUROS+SZ6->Z6_TAXA)    PICTURE "@E 999,999,999.99"
		
		DbSelectArea("SZ6")
		DbSkip()
		nLin := nLin + 1
		
		/*
		If nLin > 39
			@ 48, 000 PSAY ""
			SETPRC (0,0)

			nLin := 0
			
			@ 000, 000 PSAY Chr(18)
			@ 002, 067 PSAY Dtoc(SE1->E1_EMISSAO)
			@ 009, 004 PSAY SE1->E1_NUM
		
			@ 009, 017 PSAY SE1->E1_VALOR     Picture "@E 999,999,999.99"
			@ 009, 038 PSAY SE1->E1_NUM
			@ 009, 051 PSAY Dtoc(SE1->E1_VENCTO)
			
			DbSelectArea("SA1")
			DbSetOrder(1)
			DbSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA)
			
			@ 014, 009 PSAY SA1->A1_NOME
			@ 015, 009 PSAY SA1->A1_END
			@ 015, 043 PSAY SA1->A1_BAIRRO
			@ 016, 009 PSAY SA1->A1_MUN
			@ 016, 043 PSAY SA1->A1_EST
			@ 016, 062 PSAY TRANSFORM(SA1->A1_CEP,"@R 99999-999")
			@ 017, 009 PSAY SA1->A1_MUN
			@ 018, 009 PSAY SA1->A1_CGC    PICTURE "@R 99.999.999/9999-99"
			@ 018, 043 PSAY SA1->A1_INSCR  PICTURE "@R 999.999.999.999"
			@ 020, 009 PSAY SA1->A1_ENDCOB
			@ 020, 043 PSAY SA1->A1_BAIRROC
			@ 021, 009 PSAY SA1->A1_MUNC
			@ 021, 043 PSAY SA1->A1_ESTC
			@ 021, 062 PSAY TRANSFORM(SA1->A1_CEPC,"@R 99999-999")
			
			cExtenso:=Extenso(SE1->E1_VALOR,.F.,1)
			cExtenso:=cExtenso + Replicate('*',Iif(Len(cExtenso)<180,180-Len(cExtenso),0))
			
			aExtenso:={"","",""}
			J:=1
			For I:=1 to 3
				aExtenso[I]:=Subs(cExtenso,J,60)
				@ 022+I, 017 PSAY aExtenso[I]
				J:=J+60
			Next
			
			nLin := 31
			
		EndIf   */
	EndDo
	
	DbSelectArea("SE1")
	DbSkip()
	@ 48, 000 PSAY ""
	SETPRC (0,0)
EndDo

Set Device to Screen

If aReturn[5] == 1
	Set Printer TO
	dbCommitAll()
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Fim do Programa                                                           *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function ValidPerg
Static Function ValidPerg()

DbSelectArea("SX1")
DbSetOrder(1)
If !DbSeek(cPerg)
	
	aRegs := {}
	
	aadd(aRegs,{cPerg,'01','Do Prefixo     ? ','mv_ch1','C',03, 0, 0,'G', '', 'mv_par01','','','','','','','','','','','','','','',''})
	aadd(aRegs,{cPerg,'02','Ate o Prefixo  ? ','mv_ch2','C',03, 0, 0,'G', '', 'mv_par02','','','','','','','','','','','','','','',''})
	aadd(aRegs,{cPerg,'03','Da Nota Debito ? ','mv_ch3','C',06, 0, 0,'G', '', 'mv_par03','','','','','','','','','','','','','','',''})
	aadd(aRegs,{cPerg,'04','Ate Nota Debito? ','mv_ch4','C',06, 0, 0,'G', '', 'mv_par04','','','','','','','','','','','','','','',''})
	aadd(aRegs,{cPerg,'05','Da Parcela     ? ','mv_ch5','C',01, 0, 0,'G', '', 'mv_par05','','','','','','','','','','','','','','',''})
	aadd(aRegs,{cPerg,'06','Ate a Parcela  ? ','mv_ch6','C',01, 0, 0,'G', '', 'mv_par06','','','','','','','','','','','','','','',''})
	aadd(aRegs,{cPerg,'07','Do Tipo        ? ','mv_ch7','C',03, 0, 0,'G', '', 'mv_par07','','','','','','','','','','','','','','',''})
	aadd(aRegs,{cPerg,'08','Ate o Tipo     ? ','mv_ch8','C',03, 0, 0,'G', '', 'mv_par08','','','','','','','','','','','','','','',''})
	
	For i:=1 to Len(aRegs)
		Dbseek(cPerg+StrZero(i,2))
		If found() == .f.
			RecLock("SX1",.t.)
			For j:=1 to Fcount()
				FieldPut(j,aRegs[i,j])
			Next
			MsUnLock()
		EndIf
	Next
EndIf

Return(.t.)



Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

