#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function KPCP05R()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("TITULO,CSTRING,WNREL,CDESC1,CDESC2,TAMANHO")
SetPrvt("ARETURN,NLASTKEY,CPERG,LEND,CABEC1,CABEC2")
SetPrvt("CRODATXT,NCNTIMPR,NTIPO,NOMEPROG,CCONDICAO,NTOTREGS")
SetPrvt("NMULT,NPOSANT,NPOSATU,NPOSCNT,BBLOCO,DDATAFEC")
SetPrvt("COPANT,CCAMPOCUS,NCUSTO,LCONTINUA,NTOTQUANT,NTOTCUSTO")
SetPrvt("LI,M_PAG,CNOMARQ,NQTDEPROD,COPOLD,CPRODOLD")
SetPrvt("CUNIDOLD,CCCOLD,CCFOLD,CDESCOLD,NQTDSINT,NCUSSINT")
SetPrvt("NQTD2INT,NCUS2INT,AREGS,I,J,")

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ KPCP05R  ³ Autor ³                       ³ Data ³ 09/11/2002 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relacao das Ordens de Producao Apontadas com Custo da Receita³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Kenia Industrias Texteis                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

titulo   	:= "Relacao por Ordem de Producao"
cString  	:= "SD3"
wnrel           :="KPCP05R"
cDesc1   	:= "O objetivo deste relat¢rio ‚ exibir detalhadamente todas as movimenta-"
cDesc2   	:= "‡”es feitas para cada Ordem de Produ‡„o ,mostrando inclusive os custos."
Tamanho  	:= "G"
aReturn  	:= {"Zebrado",1,"Administracao", 2, 2, 1, "",1 }
nLastKey	:= 0
cPerg 		:= "PCP05R    "
lEnd        := .f.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01     // OP inicial                                   ³
//³ mv_par02     // OP final                                     ³
//³ mv_par03     // De  Data Movimentacao                        ³
//³ mv_par04     // Ate Data Movimentacao                        ³
//³ mv_par05     // Analitico/Sintetico                          ³
//³ mv_par06     // Considera Tecido Cru                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

ValidPerg()

pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:=SetPrint(cString,wnrel,cPerg,titulo,cDesc1,cDesc2,"",.F.,"",,Tamanho)
If nLastKey == 27
	Set Filter To
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Set Filter To
	Return
Endif

RptStatus({|lEnd|R860Imp()},titulo)// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> RptStatus({|lEnd|Execute(R860Imp)},titulo)

Return NIL


// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function R860Imp
Static Function R860Imp()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cabec1   := ""
cabec2 	 :=""
cRodaTxt := ""
nCntImpr := 0
nTipo    := 0
nomeprog := "KPCP05R"
cCondicao:= ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis para controle do cursor de progressao do relatorio ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nTotRegs:= 0
nMult   := 1
nPosAnt := 4
nPosAtu := 4
nPosCnt := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis locais exclusivas deste programa                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
bBloco  	:= { |nV,nX| Trim(nV)+IIf(Valtype(nX)=='C',"",Str(nX,1)) }
dDataFec	:= GETMV("MV_ULMES")
cOpAnt  	:= ""
cCampoCus	:=""
nCusto		:= 0
lContinua	:= .T.
nTotQuant   := 0
nTotCusto	:= 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis tipo Private padrao de todos os relatorios         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Contadores de linha e pagina                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
li		 := 80
m_pag 	 := 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis locais exclusivas deste programa                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cNomArq		:= ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se deve comprimir ou nao                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

nTipo  := IIF(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Adiciona informacoes ao titulo do relatorio                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Titulo  := Titulo + " - "+AllTrim(GetMv("MV_SIMB1"))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta os Cabecalhos                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cabec1 := "CENTRO               ORDEM DE    MOV CODIGO DO       DESCRICAO              QUANTIDADE UM         CUSTO       C U S T O  NUMERO       DATA DE"
cabec2 := "CUSTO                PRODUCAO        PRODUTO                                                   UNITARIO       T O T A L  DOCUMENTO    EMISSAO"
*****     12345678901234567890 12345612121 123 123456789012345 12345678901234567890 9,999,999.99 12 99,999,999.99 9999,999,999.99 123456789012 12/12/1234
*****     0         1         2         3         4         5         6         7         8         9        10        11        12        13
*****	    012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Pega o nome do arquivo de indice de trabalho             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cNomArq := CriaTrab("",.F.)

dbSelectArea("SD3")
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria o indice de trabalho                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cCondicao := 				"D3_FILIAL == '"+xFilial("SD3")+"' .And. D3_OP >= '"+mv_par01+"'"
cCondicao := cCondicao + 	" .And. D3_OP <= '"+mv_par02+"' .And. D3_OP <> ' ' .And. DTOS(D3_EMISSAO) >= '"+DTOS(MV_PAR03)+"'.And. DTOS(D3_EMISSAO) <= '"+DTOS(MV_PAR04)+"'"
If MV_PAR05 == 1
    IndRegua("SD3",cNomArq,"D3_FILIAL+D3_COD+D3_OP+D3_CHAVE+D3_NUMSEQ",,cCondicao,"Selecionando Registros...")
Else
    IndRegua("SD3",cNomArq,"D3_FILIAL+D3_OP+D3_CHAVE+D3_NUMSEQ+D3_COD",,cCondicao,"Selecionando Registros...")
EndIf

dbGoTop()

SetRegua(LastRec())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Correr SD3 para ler as REs, DEs e Producoes.             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
While lContinua .And. !Eof()
	
	If lEnd
		@ PROW()+1,001 PSay "CANCELADO PELO OPERADOR"
		Exit
	EndIf
	IncRegua()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Correr SD3 para a mesma OP.                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nTotCusto 		:= 	0
	nQtdeProd		:= 	0
	cOpAnt 			:= 	D3_OP
	nQtd2int   		:=  0
	
	While !Eof() .AND. D3_FILIAL+D3_OP == xFilial()+cOpAnt
		
		If lEnd
			@ PROW()+1,001 PSay "CANCELADO PELO OPERADOR"
			lContinua := .F.
			Exit
		EndIf
		
		IncRegua()
		
		If li > 58
			Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		EndIf
		
		If D3_ESTORNO == "S"
			dbSkip()
			Loop
		EndIf

        dbSelectArea("SB1")
        dbSetOrder(1)
        dbSeek(xFilial("SB1")+SD3->D3_COD,.F.)

        If SB1->B1_TIPO $ "KC TC" .AND. MV_PAR06 == 2
            dbSelectArea("SD3")
            dbSkip()
            Loop
        EndIf

        nCusto 		:= 	Round(SD3->D3_QUANT * SB1->B1_CUSTD,2)
	    
        dbSelectArea("SD3")

        If MV_PAR05 == 2
            nTotCusto := nTotCusto + IIf( SubStr(D3_CF,1,2) == "RE", nCusto, 0 )
            nTotCusto := nTotCusto + IIf( SubStr(D3_CF,1,2) == "DE", ( -nCusto ), 0 )
		
            nQtdeProd := nQtdeProd + IIf( SubStr(D3_CF,1,2) == "PR", D3_QUANT , 0 )
            nQtdeProd := nQtdeProd + IIf( SubStr(D3_CF,1,2) == "ER", -D3_QUANT , 0 )

            nQtd2int  :=  nQtd2int + IIf( SubStr(D3_CF,1,2) == "PR", D3_QTSEGUM, 0 )
            nQtd2int  :=  nQtd2int + IIf( SubStr(D3_CF,1,2) == "ER", -D3_QTSEGUM, 0 )

        Endif

        dbSelectArea("SB1")
        dbSeek(xFilial("SB1")+SD3->D3_COD,.F.)

        dbSelectArea("SD3")
		If SubStr(D3_CF,1,2) == "PR"
			Li := Li + 1
		EndIf

        If MV_PAR05 == 1
            cOpOld      :=  D3_OP
            cProdOld    :=  D3_COD
            cUnidOld    :=  D3_UM
            cCCOld      :=  D3_CC
            cCfOld      :=  D3_CF
            cDescOld    :=  Posicione("SB1",1,xFilial("SB1")+D3_COD,"B1_DESC")

		    nQtdSint   	:=  0
		    nCusSint   	:=  0
		    nQtd2int   	:=  0
		    nCus2int   	:=  0

		    While SD3->(D3_COD+D3_OP) == (cProdOld+cOpOld)

                nTotCusto   := nTotCusto + IIf( SubStr(D3_CF,1,2) == "RE",  (SD3->D3_QUANT * SB1->B1_CUSTD), 0 )
                nTotCusto   := nTotCusto + IIf( SubStr(D3_CF,1,2) == "DE", -(SD3->D3_QUANT * SB1->B1_CUSTD), 0 )
		
                nQtdeProd   := nQtdeProd + IIf( SubStr(D3_CF,1,2) == "PR", D3_QUANT , 0 )
                nQtdeProd   := nQtdeProd + IIf( SubStr(D3_CF,1,2) == "ER", -D3_QUANT , 0 )

                nQtd2int    :=  nQtd2int + IIf( SubStr(D3_CF,1,2) == "PR", D3_QTSEGUM, 0 )
                nQtd2int    :=  nQtd2int + IIf( SubStr(D3_CF,1,2) == "ER", -D3_QTSEGUM, 0 )

                nQtdSint    :=  nQtdSint + IIf( SubStr(D3_CF,1,2) $ "RE/PR", D3_QUANT, 0 )
                nCusSint    :=  nCusSint + IIf( SubStr(D3_CF,1,2) $ "RE/PR", nTotCusto, 0 )

                nQtdSint    :=  nQtdSint + IIf( SubStr(D3_CF,1,2) $ "DE/ER", -D3_QUANT, 0 )
                nCusSint    :=  nCusSint + IIf( SubStr(D3_CF,1,2) $ "DE/ER", -(nTotCusto), 0 )

                dbSkip()
            EndDo

            @ Li,000 PSay cCCOld
            @ Li,021 PSay cOpOld
            @ Li,033 PSay cCfOld
            @ Li,037 PSay cProdOld
            @ Li,053 PSay SubStr(cDescOld,1,20)
            If SubStr(D3_CF,1,2) == "DE"
                @ Li,074 PSay ( -nQtdSint )                 Picture    PesqPict("SD3","D3_QUANT",12)
                @ Li,087 PSay cUnidOld
                @ Li,090 PSay ( SB1->B1_CUSTD )             Picture PesqPict("SD3","D3_CUSTO1",13)
                @ Li,104 PSay ( nQtdSint * SB1->B1_CUSTD )  Picture PesqPict("SD3","D3_CUSTO1",15)
            ElseIf SubStr(D3_CF,1,2) == "RE"
                @ Li,074 PSay nQtdSint                      Picture PesqPict("SD3","D3_QUANT",12)
                @ Li,087 PSay cUnidOld
                @ Li,090 PSay ( SB1->B1_CUSTD )             Picture PesqPict("SD3","D3_CUSTO1",13)
                @ Li,104 PSay ( nQtdSint * SB1->B1_CUSTD )  Picture PesqPict("SD3","D3_CUSTO1",15)
            ElseIf SubStr(D3_CF,1,2) == "ER"
                @ Li,074 PSay -nQtdSint                     Picture PesqPict("SD3","D3_QUANT",12)
                @ Li,087 PSay cUnidOld
                @ Li,090 PSay ( nTotCusto/ nQtdSint )       Picture PesqPict("SD3","D3_CUSTO1",13)
                @ Li,104 PSay -(nTotCusto)                  Picture PesqPict("SD3","D3_CUSTO1",15)
            Else
                @ Li,074 PSay nQtdSint                      Picture PesqPict("SD3","D3_QUANT",12)
                @ Li,087 PSay cUnidOld
                @ Li,090 PSay ( nTotCusto/ nQtdSint )       Picture PesqPict("SD3","D3_CUSTO1",13)
                @ Li,104 PSay ( nTotCusto)                  Picture PesqPict("SD3","D3_CUSTO1",15)
            EndIf
            Li := Li + 1
        Else
            @ Li,000 PSay D3_CC
            @ Li,021 PSay D3_OP
            @ Li,033 PSay D3_CF
            @ Li,037 PSay D3_COD
            @ Li,053 PSay SubStr(SB1->B1_DESC,1,20)
            If SubStr(D3_CF,1,2) == "DE"
                @ Li,074 PSay ( -D3_QUANT )                     Picture    PesqPict("SD3","D3_QUANT",12)
                @ Li,087 PSay D3_UM
                @ Li,090 PSay ( SB1->B1_CUSTD )                 Picture PesqPict("SD3","D3_CUSTO1",13)
                @ Li,104 PSay ( SD3->D3_QUANT * SB1->B1_CUSTD ) Picture PesqPict("SD3","D3_CUSTO1",15)
            ElseIf SubStr(D3_CF,1,2) == "RE"
                @ Li,074 PSay D3_QUANT                          Picture PesqPict("SD3","D3_QUANT",12)
                @ Li,087 PSay D3_UM
                @ Li,090 PSay ( SB1->B1_CUSTD )                 Picture PesqPict("SD3","D3_CUSTO1",13)
                @ Li,104 PSay ( SD3->D3_QUANT * SB1->B1_CUSTD ) Picture PesqPict("SD3","D3_CUSTO1",15)
            ElseIf SubStr(D3_CF,1,2) == "ER"
                @ Li,074 PSay ( -D3_QUANT )                     Picture PesqPict("SD3","D3_QUANT",12)
                @ Li,087 PSay D3_UM
                @ Li,090 PSay ( SB1->B1_CUSTD )                 Picture PesqPict("SD3","D3_CUSTO1",13)
                @ Li,104 PSay ( SD3->D3_QUANT * SB1->B1_CUSTD ) Picture PesqPict("SD3","D3_CUSTO1",15)
            Else
                @ Li,074 PSay D3_QUANT                          Picture PesqPict("SD3","D3_QUANT",12)
                @ Li,087 PSay D3_UM
                @ Li,090 PSay ( SB1->B1_CUSTD )                 Picture PesqPict("SD3","D3_CUSTO1",13)
                @ Li,104 PSay ( SD3->D3_QUANT * SB1->B1_CUSTD ) Picture PesqPict("SD3","D3_CUSTO1",15)
            EndIf

            @ Li,121 PSay D3_DOC
            @ Li,134 PSay D3_EMISSAO
            Li := Li + 1
        EndIf

        If MV_PAR05 == 2
            dbSkip()
        EndIf
	End
	
	Li := Li + 1
    @ Li,000 PSay "TOTAL OP " + Subs(cOpAnt,1,6)+" "+Subs(cOpAnt,7,2)+" "+Subs(cOpAnt,9,3)
    @ Li,pCol()+03 PSay "QTDE PROD"
    @ Li,pCol()+01 PSay nQtdeProd                     Picture PesqPict("SD3","D3_QUANT",12)
    @ Li,pCol()+03 PSay "R$/1a.UN"
    @ Li,pCol()+01 PSay (nTotCusto/nQtdeProd)         Picture "@E 9,999.9999"
    @ Li,pCol()+03 PSay "QTDE 2aUN"          
    @ Li,pCol()+01 PSay nQtd2int                      Picture "@E 999,999.99"
    @ Li,pCol()+03 PSay "R$/2a.UN"
    @ Li,pCol()+01 PSay (nTotCusto/nQtd2int)          Picture "@E 9,999.9999"
    @ Li,pCol()+03 PSay "R$ TOTAL"
    @ Li,pCol()+01 PSay nTotCusto                     Picture PesqPict("SD3","D3_CUSTO1",15)

    Li := Li + 1
	
	@ Li,000 PSay Replicate("-",220)
	Li := Li + 2

EndDo

Roda(nCntImpr,cRodaTxt,Tamanho)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Devolve as ordens originais do arquivo                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RetIndex("SD3")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Apaga indice de trabalho                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cNomArq := cNomArq + OrdBagExt()
FErase( cNomArq )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Devolve a condicao original do arquivo principal             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SD3")
RetIndex("SD3")
Set Filter To
dbSetOrder(1)

If aReturn[5] == 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return NIL



// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function ValidPerg
Static Function ValidPerg()

DbSelectArea("SX1")
DbSetOrder(1)
If !DbSeek(cPerg)
	
	aRegs := {}
	
	Aadd(aRegs,{cPerg,'01','Da Op          ? ','mv_ch1','C',11, 0, 0,'G', '', 'mv_par01','','','','','','','','','','','','','','','SC2'})
	Aadd(aRegs,{cPerg,'02','Ate a Op       ? ','mv_ch2','C',11, 0, 0,'G', '', 'mv_par02','','','','','','','','','','','','','','','SC2'})
	Aadd(aRegs,{cPerg,'03','Da Data Apont. ? ','mv_ch3','D',08, 0, 0,'G', '', 'mv_par03','','','','','','','','','','','','','','',''})
	Aadd(aRegs,{cPerg,'04','Ate Data Apont.? ','mv_ch4','D',08, 0, 0,'G', '', 'mv_par04','','','','','','','','','','','','','','',''})
    Aadd(aRegs,{cPerg,'05','Forma Impressao? ','mv_ch5','N',01, 0, 1,'C', '', 'mv_par05','Sintetico','','','Analitico','','','','','','','','','','',''})
    Aadd(aRegs,{cPerg,'06','Considera Cru  ? ','mv_ch6','N',01, 0, 1,'C', '', 'mv_par06','Sim','','','Nao','','','','','','','','','','',''})
	
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

Return

