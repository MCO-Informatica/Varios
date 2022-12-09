#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05
#IFNDEF WINDOWS                                                                                                                                 
    #DEFINE PSAY SAY
#ENDIF

User Function kfin01r()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("TITULO,CDESC1,CDESC2,CDESC3,TAMANHO,LIMITE")
SetPrvt("CSTRING,ARETURN,NOMEPROG,WNREL,CPERGUNTA,NLASTKEY")
SetPrvt("NLINHA,M_PAG,NTIPO,LABORTPRINT,NLIN,NCOUNT")
SetPrvt("NVIAS,AREGS,I,J,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ KFIN01R  ³ Autor ³Ricardo Correa de Souza³ Data ³07/11/2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Impressao das Instrucoes de Cobranca                       ³±±
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

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

titulo    := 'Instrucao de Cobranca'
cDesc1    := 'Este programa ir  imprimir Instrucoes de Cobranca de acordo com a duplicata selecionada.'
cDesc2    := ' '
cDesc3    := ' '
tamanho   := 'P'
limite    := 80
cString   := 'SZ4'
aReturn   := { 'Zebrado', 1,'Financeiro', 2, 2, 1, '',0 }
nomeprog  := 'KFIN01R'
wnrel     := 'KFIN01R'
cPergunta := 'FIN01R    '
nLastKey  := 0
nLinha    := 0
m_pag     := 0
nTipo     := 18
lAbortPrint := .f.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VERIFICA AS PERGUNTAS SELECIONADAS                           ³
//³                                                              ³
//³ mv_par01   -   Do Prefixo                                    ³
//³ mv_par02   -   Ate o Prefixo                                 ³
//³ mv_par03   -   Do Titulo                                     ³
//³ mv_par04   -   Ate o Titulo                                  ³
//³ mv_par05   -   Da Parcela                                    ³
//³ mv_par06   -   Ate a Parcela                                 ³
//³ mv_par07   -   Data Referencia                               ³
//³ mv_par08   -   Qtde de Vias                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

ValidPerg()
pergunte(cPergunta,.f.)

wnrel := SetPrint(cString,wnrel,cPergunta,@titulo,cDesc1,cDesc2,cDesc3,.f.,.f.)
if nLastkey == 27
    return
endif

SetDefault(aReturn,cString,.f.)
if nLastkey == 27
    return
endif

nTipo := 18

#IFDEF WINDOWS
     Processa({|| ImpInst()},'Impressao de Instrucoes de Cobranca')// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==>      Processa({|| Execute(ImpInst)},'Impressao de Instrucoes de Cobranca')
#ELSE
     ImpInst()
#ENDIF

Return
*-------------------------------------------------------------------------*

*-------------------------------------------------------------------------*
Static Function ImpInst
*-------------------------------------------------------------------------*

dbselectarea('SZ4')
dbsetorder(1)
dbgotop()
dbseek(xFilial('SZ4')+dtos(mv_par07),.t.)

ProcRegua(RecCount() - Recno())

nLin   := 0
nCount := 0

@00,005 PSAY avalimp(limite)    
@ nLin,050 PSAY ' '

while eof() == .f.  .and.;
      Z4_filial == xFilial('SZ4') .and.;
      Z4_data == mv_par07

    IncProc('Processando o titulo: '+sZ4->Z4_prefixo+'/'+;
                                     sZ4->Z4_titulo+'-'+;
                                     sZ4->Z4_parcela)

    if Z4_prefixo >= mv_par01 .and. Z4_prefixo <= mv_par02 .and.;
       Z4_titulo  >= mv_par03 .and. Z4_titulo  <= mv_par04 .and.;
       Z4_parcela >= mv_par05 .and. Z4_parcela <= mv_par06
    else
         dbselectarea('sZ4')
         dbsetorder(1)
         dbskip()
         loop
    endif

    dbselectarea('se1')
    dbsetorder(1)
    dbseek(xfilial('SE1')+sZ4->Z4_prefixo+sZ4->Z4_titulo+sZ4->Z4_parcela+sZ4->Z4_tipo)
    if found() == .f.
         msgbox('Nao encontrado na Carteira C.Receber','Instrucao bancaria','ALERT')

         dbselectarea('sZ4')
         dbsetorder(1)
         dbskip()
         loop
    endif

    dbselectarea('sa6')
    dbsetorder(1)
    dbseek(xfilial('SA6')+se1->e1_portado+se1->e1_agedep+se1->e1_conta)
    IF found()
       While A6_COD == SE1->E1_PORTADO
          IF !Empty(A6_NOME)
             Exit
          Else
             dbSkip()
          Endif
       Enddo
    Else
         msgbox('Banco nao encontrado como portador','Instrucao bancaria','ALERT')

         dbselectarea('sZ4')
         dbsetorder(1)
         dbskip()
         loop
    endif

    dbselectarea('sa1')
    dbsetorder(1)
    dbseek(xfilial('SA1')+se1->e1_cliente+se1->e1_loja)
    if found() == .f.
         msgbox('Cliente nao encontrado','Instrucao bancaria','ALERT')

         dbselectarea('sZ4')
         dbsetorder(1)
         dbskip()
         loop
    endif

    nCount := nCount + 1
    nVias  := 0

    While nVias < MV_PAR08
        nVias := nVias + 1

        If nVias == 1 .Or. nVias == 3 .Or. nVias == 5 .Or. nVias == 7 
            @nLin,030 PSAY ' ________________________________________________ '
        Else
            @nLin,030 PSAY ' ________________________________________________ '
        EndIf

        nLin := nLin + 1

        @nLin,002 PSAY "INSTRUCAO DE COBRANCA"
    
        @nLin,030 PSAY '|                                                |'

        if len(alltrim(SM0->m0_cgc)) == 11
            @nLin,033 PSAY padc(alltrim(transform(SM0->m0_cgc,'@r 999.999.999-99')),44)
        else
            @nLin,033 PSAY padc(alltrim(transform(SM0->m0_cgc,'@r 99.999.999/9999-99')),44)
        endif

        nLin := nLin + 1

        @nLin,030 PSAY '|                                                |'
        @nLin,033 PSAY padc(alltrim(SM0->m0_nomecom),44)

        nLin := nLin+1

        @nLin,030 PSAY '|                                                |'
        @nLin,033 PSAY padc(alltrim(SM0->m0_endent),44)

        nLin := nLin + 1

        @nLin,002 PSAY "Sao Paulo, "+dtoc(dDataBase)
        @nLin,030 PSAY '|                                                |'
        @nLin,033 PSAY padc(alltrim(SM0->m0_bairent)+' - '+transform(SM0->m0_cepent,'@r 99999-999'),44)
 
        nLin := nLin + 1

        @nLin,030 PSAY '|                                                |'
        @nLin,033 PSAY padc(alltrim(SM0->m0_cident)+' - '+SM0->m0_estent,44)
        @nLin,030 PSAY ' ________________________________________________'

        nLin := nLin + 2

        @nLin,002 PSAY "Ao "+SA6->A6_NOME+" "+"Ag.: "+SE1->E1_AGEDEP
        nLin := nLin + 2

        @nLin,002 PSAY "Prezados Senhores,"
    
        nLin := nLin + 2

        @nLin,002 PSAY "Referente o titulo abaixo, queiram proceder conforme nossas instrucoes:"

        nLin := nLin + 1
    
        @nLin,002 PSAY " _____________________________________________________________________________ "
    
        nLin := nLin + 1

        @nLin,002 PSAY "| Titulo         | Nosso Numero         | Vencto.    |                 Valor  |"

        nLin := nLin + 1
   
        @nLin,002 PSAY "| "+SZ4->Z4_PREFIXO+"-"+SZ4->Z4_TITULO+"-"+SZ4->Z4_PARCELA+"   | "
        @nLin,021 PSAY SE1->E1_NUMBCO
        @nLin,040 PSAY "|"
        If !Empty(SE1->E1_DTPRORR)
            @nLin,043 PSAY DTOC(SE1->E1_DTPRORR)
        ElseIf !Empty(SE1->E1_VENCORI)
            @nLin,043 PSAY DTOC(SE1->E1_VENCORI)
        Else
            @nLin,043 PSAY DTOC(SE1->E1_VENCREA)
        EndIf
        @nLin,053 PSAY "|"
        @nLin,058 PSAY SE1->E1_VALOR     Picture PesqPict("SE1","E1_VALOR")
        @nLin,077 PSAY "|"

        nLin := nLin + 1
    
        @nLin,002 PSAY "|_____________________________________________________________________________|"

        nLin := nLin+1
    
        @nLin,002 PSAY "| Sacado.: "+SA1->A1_NOME
        @nLin,077 PSAY "|"

        if !empty(sa1->a1_endcob) .and. !empty(sa1->a1_munc) .and. ;
           !empty(sa1->a1_estc)   .and. !empty(sa1->a1_cepc)

            nLin := nLin + 1
         
            @nLin,002 PSAY "| Ender..: "+SA1->A1_ENDCOB
            @nLin,077 PSAY "|"
         
            nLin := nLin + 1
        
            @nLin,002 PSAY "| Praca..: "+Alltrim(SA1->A1_MUNC)+" - "+SA1->A1_ESTC
            @nLin,042 PSAY SA1->A1_CEPC  Picture PesqPict("SA1","A1_CEPC")
            @nLin,077 PSAY "|"
        else
            nLin := nLin + 1
        
            @nLin,002 PSAY "| Ender..: "+SA1->A1_END
            @nLin,077 PSAY "|"
             
            nLin := nLin + 1
        
            @nLin,002 PSAY "| Praca..: "+Alltrim(SA1->A1_MUN)+" - "+SA1->A1_EST
            @nLin,042 PSAY SA1->A1_CEP   Picture PesqPict("SA1","A1_CEP")
            @nLin,077 PSAY "|"
        endif

        nLin := nLin + 1

        @nLin,002 PSAY "| C.G.C..: "
        @nLin,013 PSAY SA1->A1_CGC       Picture PesqPict("SA1","A1_CGC")
        @nLin,042 PSAY "Inscr.: "+SA1->A1_INSCR
        @nLin,077 PSAY "|"

        nLin:= nLin+1
    
        @nLin,002 PSAY "|_____________________________________________________________________________|"

        nLin := nLin+1
    
        @nLin,002 PSAY "|                                                                             |"
    
        nLin:=nLin+1
    
        @nLin,002 PSAY "| ["
    
        If !Empty(SZ4->Z4_DISJUR)
            @nLin,005 PSAY "X"
        endif

        @nLin,006 PSAY "] Dispensar Juros                     ["
    
        If !Empty(DTOS(SZ4->Z4_NOVVEN))
            @nLin,044 PSAY "X"
        endif
    
        @nLin,045 PSAY "] Alterar Vencto p/: "
        @nLin,067 PSAY SZ4->Z4_NOVVEN
        @nLin,077 PSAY "|"

        nLin := nLin + 1
    
        @nLin,002 PSAY "| ["
    
        If !Empty(SZ4->Z4_COBJUR)
            @nLin,005 PSAY "X"
        EndIf
    
        @nLin,006 PSAY "] Cobrar Juros                        ["
    
        If !Empty(SZ4->Z4_SUSPRO)
            @nLin,044 PSAY "X"
        EndIf
    
        @nLin,045 PSAY "] Sustar Protesto"
        @nLin,077 PSAY "|"
    
        nLin:=nLin+1
    
        @nLin,002 PSAY "| ["
    
        If !Empty(SZ4->Z4_PROTEST)
            @nLin,005 PSAY "X"
        EndIf
    
        @nLin,006 PSAY "] Protestar                           ["
    
        If Round(SZ4->Z4_ABATIM,2) >= 0.01
            @nLin,044 PSAY "X"
        EndIf
    
        @nLin,045 PSAY "] Conceder Abatimento: "
        @nLin,064 PSAY SZ4->Z4_ABATIM    Picture "@E 9999,999.99"
        @nLin,077 PSAY "|"

        nLin:=nLin+1
    
        @nLin,002 PSAY "| ["
    
        If !Empty(SZ4->Z4_DEVBXR)
            @nLin,005 PSAY "X"
        EndIf
    
        @nLin,006 PSAY "] Devolver Baixando Registro          ["
    
        If !Empty(SZ4->Z4_OUTRAS)
            @nLin,044 PSAY "X"
        EndIf
    
        @nLin,045 PSAY "] "+SZ4->Z4_OUTRAS
        @nLin,077 PSAY "|"

        nLin := nLin + 1
    
        @nLin,002 PSAY "|_____________________________________________________________________________|"

        nLin := nLin + 3
    
        @nLin,002 PSAY "Atenciosamente,                       ________________________________________"
    
        nLin := nLin + 1
    
        @nLin,045 PSAY SM0->M0_NOMECOM
       
      
        
        If nVias == 1 .Or. nVias == 3 .Or. nVias == 5 .Or. nVias == 7
           
           nLin :=0//nLin +3 NLIN=0 DEVIDO A DESCONFIGUAÇÃO DO RELATORIO, COM NLIN = 3 IMPRIME DESCONFIGURADO SE O RELATORIO SAIR MAIOR DO QUE 3.
        Else
            nLin :=0 //nLin + 0
            
            @ nLin,050 PSAY ' '
        EndIf
    
        @nLin,002 PSAY "  "

    Enddo
  
    
    SetPrc(0,0)

    dbselectarea('sZ4')
    dbskip()
Enddo

//SetPrc(0,0)

SET DEVICE TO SCREEN

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

return

*-------------------------------------------------------------------------*
// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==>  function ValidPerg
Static function ValidPerg()
*-------------------------------------------------------------------------*

dbselectarea('sx1')
dbsetorder(1)

aRegs := {}
aadd(aRegs,{cPergunta,'01','Do Prefixo         ?','mv_ch1','C',03, 0, 0,'G', '', 'mv_par01','','','','','','','','','','','','','','',''})
aadd(aRegs,{cPergunta,'02','Ate o Prefixo      ?','mv_ch2','C',03, 0, 0,'G', '', 'mv_par02','','','','','','','','','','','','','','',''})
aadd(aRegs,{cPergunta,'03','Do Titulo          ?','mv_ch3','C',06, 0, 0,'G', '', 'mv_par03','','','','','','','','','','','','','','',''})
aadd(aRegs,{cPergunta,'04','Ate o Titulo       ?','mv_ch4','C',06, 0, 0,'G', '', 'mv_par04','','','','','','','','','','','','','','',''})
aadd(aRegs,{cPergunta,'05','Da Parcela         ?','mv_ch5','C',01, 0, 0,'G', '', 'mv_par05','','','','','','','','','','','','','','',''})
aadd(aRegs,{cPergunta,'06','Ate a Parcela      ?','mv_ch6','C',01, 0, 0,'G', '', 'mv_par06','','','','','','','','','','','','','','',''})
aadd(aRegs,{cPergunta,'07','Data Referencia    ?','mv_ch7','D',08, 0, 0,'G', '', 'mv_par07','','','','','','','','','','','','','','',''})
aadd(aRegs,{cPergunta,'08','Qtde de Vias       ?','mv_ch8','N',01, 0, 0,'G', '', 'mv_par08','','','','','','','','','','','','','','',''})
for i:=1 to len(aRegs)
    dbseek(cPergunta+strzero(i,2))
    if found() == .f.
         reclock('sx1',.t.)

         for j:=1 to fcount()
              FieldPut(j,aRegs[i,j])
        next

        msunlock()
    endif
next

return

*-------------------------------------------------------------------------*
