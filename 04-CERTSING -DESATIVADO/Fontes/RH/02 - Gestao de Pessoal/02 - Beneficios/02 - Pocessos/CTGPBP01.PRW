#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"

#DEFINE          cEol         CHR(13)+CHR(10)
#DEFINE          cSep         ";"

/*+------------------------------------------------------------------------------------------------------------------+-------------------+
  | Funcao.: CTGPBP01() | Calculo Vale Refeicao / Vale Alimentacao                                                   | Data.: 06.06.2016 |
  +------------------------------------+-----------------------------------------------------------------------------+-------------------+
  | Autor.: Alexandre A. Silva - OPVS  | Objetivo.: Apurar a quantidade de Vales Refeicao e Alimentacao, apurando Faltas, Afastamentos,  |
  |                                    | Ferias Coletivas e Programadas.                                                                 |
  +------------------------------------+-------------------------------------------------------------------------------------------------|
  | Observacoes.: Excluir grupo de perguntas "GPEXVT"
  +------------------------------------+-------------------------------------------------------------------------------------------------+
*/
User Function CTGPBP01()

Local bProcesso := {|oSelf| GPA210Processa( oSelf )}

Private cCadastro  := "Calculo dos Vales Refeicao e Alimentacao"
Private cPerg      := "CTGPBP01"
Private cDescricao := "Esta rotina efetuara o calculo dos beneficios Vale Refeicao e Alimentacao."

Private aProceed   := {} //-> Dados processados para planilha.

fAsrPerg()
Pergunte(cPerg,.F.)

tNewProcess():New( "SRA" , cCadastro , bProcesso , cDescricao , cPerg,,,,,.T.,.F. ) 	

//-> Gera planilha para conferencia.
If !Empty(aProceed)
   fPlanLOG(aProceed)
EndIf

Return

/*+-------------------------+-------------------------+-------------------+
  | Rotina.: GPA210Processa | Processamento Principal | Data.: 20.05.2010 |
  +-------------------------+-------------------------+-------------------+
  | Objetivo.:                                                            |
  +-----------------------------------------------------------------------+

Prametros:
Data Referencia ?        mv_par01
Filial De ?              mv_par02
Filial Ate ?             mv_par03
Matricula De ?           mv_par04
Matricula Ate ?          mv_par05
Centro Custo De ?        mv_par06
Centro Custo Ate ?       mv_par07
Situacoes ?              mv_par08
Categorias ?             mv_par09
Gerar ?                  mv_par10
Prop.Ferias/Afast. ?     mv_par11
Prop.Ferias Prog.?       mv_par12
Prop.Admissao    ?       mv_par13
Descontar Faltas ?       mv_par14
*/
Static Function GPA210Processa(oSelf)

//-> Variaveis de Processamento Basico.
Local dDataRef  := mv_par01                   //-> Mes/Ano
Local cAnoMes   := Substr(DToS(mv_par01),1,4)+Substr(DToS(mv_par01),5,2)
Local cFilDe    := mv_par02                   //-> Filial De.
Local cFilAte   := mv_par03                   //-> Filial Ate.
Local cMatDe    := mv_par04                   //-> Matricula De.
Local cMatAte   := mv_par05                   //-> Matricula Ate.
Local cCustoDe  := mv_par06                   //-> Centro de Custo De.
Local cCustoAt  := mv_par07                   //-> Centro de Custo Ate.
Local cSituac   := mv_par08                   //-> Situacoes.
Local cCateg    := mv_par09                   //-> Categorias.
Local cTpBene   := mv_par10                   //-> Tipo do Beneficio (1 = VR / 2 = VA)
Local lPFerAfa  := If ( mv_par11 = 1,.T.,.F.) //-> Proporcionaliza para Férias e Afastamentos.
Local lPropFPg  := If ( mv_par12 = 1,.T.,.F.) //-> Proporcionaliza para Férias Programadas.
Local lPropAdm  := If ( mv_par13 = 1,.T.,.F.) //-> Proporcionaliza para Admissoes.
Local lDescFal  := If ( mv_par14 = 1,.T.,.F.) //-> Desconta Faltas.
Local cQuery    := ""                         //-> Variavel para Query.
Local cAuxProc  := ""                         //-> Variavel auxiliar em processamentos.
Local nX        := 0                          //-> Variavel para contagens em lacos.
Local nY        := 0                          //-> Variavel para contagens em lacos.
Local nPos      := 0                          //-> Variavel para posicionaento em strings.
Local cAliasBn  := ""                         //-> Alias a ser aberto confomre o tipo de beneficio.

//-> Variaveis de Apuração.
Local ndTrab    := 0   //-> Dias Trabalhados conforme Calendario de Periodos.
Local ndNTrab   := 0   //-> Dias Não Trabalhados.
Local ndDSR     := 0   //-> Dias de DSR.
Local ndVR      := 0   //-- Dias de Vale Refeicao 
Local ndVA      := 0   //-- Dias de Vale Alimentacao.
Local nPerc     := 0   //-> Percentual de Desconto
Local cCodRef   := ""  //-> Codigo do Vale Refeicao.
Local nVlUnit	:= 0   //-> Valor Unitario.
Local cDescric  := ""  //-> Descrição VR.
Local nValVaFu  := 0   //-> Valor Vale Alimentacao Funcionario.
Local nPerVAFu  := 0   //-> Perentual Vale Alimentacao Funcionario.
Local nValVaEp  := 0   //-> Valor Vale Alimentacao Empresa.
Local nDFalPon  := 0   //-> Dias de Faltas Apuradas no Acumulado de Apontamentos (Ponto Eletronico).
Local cEveFlt   := ""  //-> Evento de Faltas Integrais.
Local dPerIni   := ""  //-> Periodo de Apontamento Inicio.
Local dPerFim   := ""  //-> Periodo de Apontamento Fim.
Local cCodAbo   := fAboBen() //-> Resgata os abonos para Faltas Integrais.
Local cChaveBn  := ""

//-> Variaveis Private para demais Funcoes.
Private dDataIni := CToD( "01/"+StrZero(Month(dDataRef),2)+"/"+StrZero(Year(dDataRef),4) ) 
Private nUlt_Dia := F_ULTDIA(dDataIni)
Private dDataFim := CtoD(StrZero(NUlt_Dia,2)+"/"+StrZero(Month(dDataIni),2)+"/"+STRZERO(YEAR(dDataIni),4))
Private DiasTrab := 0
Private cSemana	 := cSem := Space(2)
Private cAliasRA := GetNextAlias()             //-> Alias temporario para SRA.
Private nDFrProg := 0 //-> Dias de Ferias Programadas.
Private nDFlFrPr := 0 //-> Dias de Faltas nas Ferias Programadas.
Private aDiasMes := {}
Private aDMesCln := {}
Private aPeriodo := {}
Private nDAfaVR  := 0 //-> Afastamento em Dias Uetis na Competencia de Compra.
Private nDAfaVA  := 0 //-> Afastamento em Dias Nao Uetis na Competencia de Compra.
Private nDBenAfa := 0 //-> Dias de Beneficios dentro da Competencia de Compra, qdo ha Afastamento.
Private lUsaCPer := .F. //-> Variavel utilizada por funções externas.
Private aTabCalend := {} //-> Variavel utilizada por funções externas.


//-> Se posotivo para abatimento de Faltas, verifica o ultimo periodo do fechado do Ponto.
IF lDescFal

         SPO->( DbSetOrder(2) )
         SPO->( DbGoTop() )
   While SPO->( !EOF() )
         dPerIni := DToS(SPO->PO_DATAINI)
         dPerFim := DToS(SPO->PO_DATAFIM)
             
         SPO->( DbSkip() )
   EndDo
   
   cEveFlt     := Posicione("SP9",2,xFilial("SP9")+"010A","P9_CODIGO")
   
   If Empty(dPerIni)
      Aviso("ATENCAO!!","Nao ha registros de Periodos de Apontamentos FECHADOS no Ponto Eletronico.Verifique.",{"OK"})
      Return() 
   EndIf

   If Empty(cEveFlt)
      Aviso("ATENCAO!!","Nao foi localizado o evento de Falta Integral (ID.010A).Verifique.",{"OK"})
      Return() 
   EndIf
EndIf



//-> Formata Categorias e Situacoes para Query.
For nX := 1 To Len(cCateg)
    cAuxProc += If( Substr(cCateg, nX, 1) <> "*", "'" + Substr(cCateg, nX, 1) + "',", "") //-> Categorias.
Next
cCateg   := Substr(cAuxProc, 1, Len(cAuxProc) -1)
cAuxProc := ""

For nX := 1 To Len(cSituac)
    cAuxProc += If( Substr(cSituac, nX, 1) <> "*", "'" + Substr(cSituac, nX, 1) + "',", "") //-> Situacoes.
Next
cSituac  := Substr(cAuxProc, 1, Len(cAuxProc) -1)
cAuxProc := ""


//-> Calculos.
cAliasBn := If( cTpBene == 1, RetSqlName("SZC"), RetSqlName("SZD") ) //1 = Vale Refeicao. / 2 = Vale Alimentacao.

//-> Seleciona Funcionários.
cQuery := "SELECT RA_FILIAL,  "
cQuery += "       RA_CC,      "
cQuery += "       RA_MAT,     "
cQuery += "       RA_NOME,    "
cQuery += "       RA_SITFOLH, "
cQuery += "       RA_ADMISSA, "
cQuery += "       RA_VALEREF, "
cQuery += "       RA_CATFUNC, "
cQuery += "       RA_CESTAB,  "
cQuery += "       RA_TNOTRAB  "
cQuery += "FROM "+RetSqlName("SRA")+" "
cQuery += "WHERE RA_FILIAL BETWEEN '"+cFilde+"'   AND '"+cFilAte+"'  AND "
cQuery += "      RA_MAT    BETWEEN '"+cMatde+"'   AND '"+cMatAte+"'  AND "
cQuery += "      RA_CC     BETWEEN '"+cCustoDe+"' AND '"+cCustoAt+"' AND "
cQuery += "      RA_SITFOLH  IN("+cSituac+")                     AND "
cQuery += "      RA_CATFUNC  IN("+cCateg+")                      AND "
cQuery += "      D_E_L_E_T_ <> '*'                               AND "
  
If cTpBene == 1  //-> Vale Refeicao.
   cQuery += "      RA_VALEREF NOT IN('',' ')                       "  
Else             //-> Vale Alimentacao.
   cQuery += "      RA_CESTAB  NOT IN('',' ','N')                   "  
EndIf

cQuery += "ORDER BY RA_FILIAL, RA_MAT"  

cQuery := ChangeQuery(cQuery)
       
TCQUERY cQuery NEW ALIAS (cAliasRA)
                                   
   (cAliasRA)->( DbGotop()     )
If (cAliasRA)->( Eof()         )      
   (cAliasRA)->( DbCloseArea() )
   Return()
Else

   fCarPeriodo(dDataRef, @aPeriodo) //-> dDataRef = Data de Referencia para o Periodo de Calculo / aPeriodo = Matriz para carga dos periodos.
   
   If Empty(aPeriodo)
      AVISO("ATENÇÃO!","NAO HA CALENDARIO DE PERIODO CADASTRADO PARA A DATA DE REFERÊNCIA INFORMADA.: "+DToC(dDataRef)+".",{"OK"})
      Return()
   EndIf
EndIf


oSelf:SetRegua1( (cAliasRA)->(RecCount()) )

While (cAliasRA)->(!Eof())

      //-> Posicionando o Alias SRA para a RETAFAS.                            
      DbSelectArea("SRA")
      DbSeek( (cAliasRA)->(RA_FILIAL + RA_MAT) )

      oSelf:IncRegua1( (cAliasRA)->(RA_FILIAL + " - " + RA_MAT + " - " + RA_NOME) )
      If oSelf:lEnd 
         Break
      EndIf

      //-> Zera variaveis de apuracao.
      nDFrProg := 0     //-> Dias de Ferias Programadas.
      aAfast   := {}    //-> Matriz para apuração dos afastamentos.
      ndTrab   := 0	    //-> Dias Trabalhados.
      ndNTrab  := 0     //-> Dias Nao Trabalhados
      ndDSR    := 0 	//-> Dias de DSR
      ndVR     := 0 	//-> Dias de Vale Refeicao 
      cSemana  := cSem  //-> Semana (somente semanalistas ou submetidos a semaas.)
      DiasTrab := 0     //-> Dias Trabalhados, apos apuracao final de faltas, ferias e etc.
      ndVA     := 0 	//-> Dias de Vale Alimentacao.
      aDiasMes := {}    //-> Matriz com dias do mes para o funcionario.
      
      //-> 1 = Para Vale Refeicao / aDiasMes = Matriz com dias / lPropAdm = Se proporcionaliza para admissoes.
      U_fCarDiasMes(1, @aDiasMes, lPropAdm) 

      //-- Apuracao de Dias Trabalhados, Nao Trabalhados, DSR e VR/VA.
      FTrabCalen( dDataIni,;//-- data de Referencia
                  @ndTrab,;	//-- Dias Trabalhados
                  @ndNTrab,;//-- Dias Nao Trabalhados
                  @ndDSR,; 	//-- Dias de DSR
                        ,;	//-- Dias Nao Uteis de Vale Transporte 
                        ,;	//-- Dias uteis de Vale Transporte
                        ,; 	//-- Dias de Diferenca de Vale Transporte
                        ,;	//-- Qtde de Horas de DSR
                        ,;	//-- Qtde de HoraS Trabalhadas 
                   @ndVR,;	//-- Dias de Vale Refeicao 
                        ,;
                        ,;
                 cSemana,;
                     .F.,;  //lPFerAfa,; //-- Se Verifica Ferias/Afastamentos 
                lPropAdm,;  //lPropAdm ,; //-- Proporcional a Admissao 
	                    ,; 							
                        ,;
                        ,;
                 dDataFim ) //-- Data Fim do periodo

      DiasTrab	:= ( ndTrab + ndDSR + ndNTrab ) 
      
      //-> Os dias de VA sao computados de forma corrida, ou seja, sao computados os sabados, domingos e feriados.
      ndVA := If(DiasTrab <= 0, nUlt_Dia, DiasTrab )
      ndVA := If( AllTrim(Str(ndVA))$"31", 30, ndVA)
      
      
      //-> Verifica se é proporcional a ferias e afastamentos
      If lPFerAfa
      
         nDAfaVA := 0
         nDAfaVR := 0
       
         aDMesCln := aClone(aDiasMes)
      
         fRetAfas( dDataIni, dDataFim,,,,@aAfast,.F.,.F.,.T. )
         
         If !Empty(aAfast)
         
	        Aeval(aAfast,{|x| If(Empty(x[4]) .And. x[5] ="Q", x[4]:= x[3]+120,x[4]:=x[4])})

	        Aeval(aAfast,{|x| If(Empty(x[4]), x[4]:= dDataFim,x[4]:=x[4])})

            For nX := 1 To Len( aAfast )
                For nY := aAfast[nX,3] To aAfast[nX,4]

                 If ( nPos := Ascan(aDMesCln,{|x| x[1]==nY}) ) > 0
                 
                    //-> Sinaliza dias de afastamento, computando dias Uteis e Nao Uteis.
					If !aDMesCln[nPos,4]               
	                    aDMesCln[nPos,5] := "AFT|"+aAfast[nX][5]  //-> Afastamentos em Dias Uteis.
	                    aDMesCln[nPos,4] := .T.
	    			Else                               
	    				aDMesCln[nPos,5] := "AFT|"+aAfast[nX][5]  //-> Afastamentos em Dias Nao Uteis.
	                    aDMesCln[nPos,4] := .F.
	    			EndIf		    			
                   	
                 EndIf
                 
	            Next nY
	        Next nX
	     
	        //-> Setando demais linhas da Matriz, que nao foram carregadas.
	        For nX := 1 To Len(aDMesCln)
	            aDMesCln[nX,5] := If( Empty(aDMesCln[nX,5]), "NOT|X", aDMesCln[nX,5] )
	        Next nX

            Aeval(aDMesCln,{|x| nDAfaVR += If(x[4] .And. Substr(x[5],1,3)=="AFT",1,0)})	                 //-> Afastamentos Para VR
         
            Aeval(aDMesCln,{|x| nDAfaVA += If( Substr(x[5],1,3)=="AFT" .And. !(Substr(x[5],5,1)$"F|Q"),1,0)}) //-> Afastamentos Para VA
         EndIf 
      Endif		
      
     
      //-> Checa Ferias Programadas.      
      If lPropFPg
         fCkFrPro(dDataRef)
      EndIf
      
      //-> Checa Faltas Integrais no Ponto.
      If lDescFal
         nDFalPon := fCkFtBen((cAliasRA)->(RA_FILIAL), (cAliasRA)->(RA_MAT), dPerIni, dPerFim, cEveFlt, cCodAbo )      
      EndIf
      
      If (cTpBene == 1) //-> Vale Refeicao.
         /*
         +-----------------------------------------------------+
         | Resgata Dados do VR do Parametro 26 - VALE REFEICAO.|
         +-----------------------------------------------------+
         */      
         nVlUnit  := 0
         cCodRef  := ""
         cDescric := ""

         cChaveBn := xFilial("SRX")+"26"+(cAliasRA)->(RA_FILIAL + Space(10) + RA_VALEREF)

         If SRX->(!DbSeek(cChaveBn))
            nVlUnit  := 0.00
            cCodRef  := SRA->RA_VALEREF
            cDescric := "Codigo de Beneficio não encontrado no parâmetro 26"
            
         Else
            nVlUnit  := VAL(SubStr(SRX->RX_TXT,28,5))
            cCodRef  := Substr(SRX->RX_COD,13,2)     
            cDescric := Substr(SRX->RX_TXT,1,16) 
            
            //-> Abatimentos.
            If lPFerAfa //-> Se computa Afastamentos.
               ndVR := If( ndVR <= nDAfaVR, 0, (ndVR - nDAfaVR) )
            EndIf
            
            If lPropFPg  //-> Se computa Ferias Programadas.
               ndVR := If( ndVR <= 0, 0, (ndVR - nDFrProg) )
               ndVR := If( ndVR <= 0, 0, ndVR)
            EndIf
            
            If lDescFal  //-> Se computa Faltas do Ponto.
               ndVR := If( ndVR <= 0, 0, (ndVR - nDFalPon) )
               ndVR := If( ndVR <= 0, 0, ndVR)            
            EndIf
            
            //If  ndVR > 0
                fGravaSZC( (cAliasRA)->(RA_FILIAL),(cAliasRA)->(RA_MAT),(cAliasRA)->(RA_CC),cAnoMes,ndVR,nVlUnit,cCodRef,cDescric)
            //EndIf
         EndIf
         
         //-> Gerando Cabeçalho do LOG para Planilha de Conferencia.
         fLoga(Empty(aProceed))

         //-> Gerando informações de LOG para a planilha.
         nPos := AT(".", AllTrim(Str(nVlUnit)) )
           
         AaDd(aProceed,{SRA->RA_FILIAL,;   //-- Filial Colaborador
                        SRA->RA_MAT,;      //-- Matricula Colaborador
                        SRA->RA_NOME,;     //-- Nome Colaborador
                        SRA->RA_CC,;       //-- Centro de Custo Colaborador
                        cAnoMes,;          //-- Ano/Mes para Compra.
                        Str(ndVR),;        //-- Quantidade Beneficios
                        Str(nDFalPon),;    //-- Dias de Faltas do Ponto
                        If(!Empty(dPerIni), DToC( SToD(dPerIni) ), DToC( CToD("  /  /    ") ) ),; //-- Dt. Inicial do Periodo do Ponto para Faltas.
                        If(!Empty(dPerFim), DToC( SToD(dPerFim) ), DToC( CToD("  /  /    ") ) ),; //-- Dt. Final do Periodo do Ponto para Faltas.
                        Str(nDAfaVR),;     //-- Dias Afastamento
                        Str(nDFrProg),;    //-- Dias Ferias Programadas
                        Str(ndTrab),;      //-- Dias Trabalhados
                        Str(ndNTrab),;     //-- Dias Nao Trabalhados
                        Str(ndDSR),;       //-- Dias de DSR
                        Substr( AllTrim(Str(nVlUnit)), 1, nPos -1 ) + "," +;
                        Substr( AllTrim(Str(nVlUnit)), nPos + 1, Len( AllTrim(Str(nVlUnit)) ) - nPos ),; //-- Valor Unitario Beneficio.
                        cCodRef,;          //-- Codigo do Beneficio.
                        cDescric;          //-- Descricao do Beneficio.
                         })


      ElseIf (cTpBene == 2) //-> Vale Alimentacao. 
      
         cChaveBn := xFilial("SRX")+"35"+(cAliasRA)->(RA_FILIAL + Space(10) + "1")
         
         If SRX->(!DbSeek(cChaveBn))
         
            cCodRef  := If( (cAliasRA)->(RA_FILIAL) = "06","01","02") //-> Codigo do Beneficio.
            nValVaFu := 0.00 //-> Valor Vale Alimentacao Funcionario.
            nPerVAFu := 0    //-> Perentual Vale Alimentacao Funcionario (Desconto).
            nValVaEp := 0.00 //-> Valor Vale Alimentacao Empresa.
            cDescric := "Codigo de Beneficio não encontrado no parâmetro 35"
         
         Else
         
            cCodRef   := Substr(SRX->RX_COD,13,2)       //-> Codigo do Beneficio.
            nValVaFu  := Val(Substr(SRX->RX_TXT,01,11)) //-> Valor Vale Alimentacao Funcionario.
            nPerVAFu  := Val(Substr(SRX->RX_TXT,34,07)) //-> Perentual Vale Alimentacao Funcionario (Desconto).
            nValVaEp  := If( nPerVAFu = 0, nValVaFu, nValVaFu - (nValVaFu * (nPerVAFu / 100) ) ) //-> Valor Vale Alimentacao Empresa.
            
            cCodRef  := If( (cAliasRA)->(RA_FILIAL) = "06","01","02")
            cDescric := If( cCodRef = "01","VALE ALIMENTACAO RJ","VALE ALIMENTACAO SP")
            
            //-> Abatimentos.
            If lPFerAfa //-> Se computa Afastamentos.
               ndVA := If( ndVA <= nDAfaVA, 0, (ndVA - nDAfaVA) )
            EndIf
            
            If lPropFPg  //-> Se computa Ferias Programadas.
               ndVA := If( ndVA <= 0, 0, (ndVA - nDFrProg) )
               ndVA := If( ndVA <= 0, 0,  ndVA)
            EndIf
            
            If lDescFal  //-> Se computa Faltas do Ponto.
               ndVA := If( ndVA <= 0, 0, (ndVA - nDFalPon) )
               ndVA := If( ndVA <= 0, 0,  ndVA)            
            EndIf
            
            //If ndVA > 0
               fGravaSZD((cAliasRA)->(RA_FILIAL),(cAliasRA)->(RA_MAT),(cAliasRA)->(RA_CC),cAnoMes,1,nValVaFu,nValVaEp,cCodRef,cDescric)
            //EndIf
 	     Endif		    
 	     
         //-> Gerando Cabeçalho do LOG para Planilha de Conferencia.
         fLoga(Empty(aProceed))
         
         //-> Gerando informações de LOG para a planilha.
         nPos := AT(".", AllTrim(Str(nValVaFu)) )
           
         AaDd(aProceed,{SRA->RA_FILIAL,;    //-- Filial Colaborador
                        SRA->RA_MAT,;       //-- Matricula Colaborador
                        SRA->RA_NOME,;      //-- Nome Colaborador
                        SRA->RA_CC,;        //-- Centro de Custo Colaborador
                        cAnoMes,;           //-- Ano/Mes para Compra.
                        "1",;               //-- Quantidade Beneficios
                        Str(nDFalPon),;     //-- Dias de Faltas do Ponto
                        If(!Empty(dPerIni), DToC( SToD(dPerIni) ), DToC( CToD("  /  /    ") ) ),; //-- Dt. Inicial do Periodo do Ponto para Faltas.
                        If(!Empty(dPerFim), DToC( SToD(dPerFim) ), DToC( CToD("  /  /    ") ) ),; //-- Dt. Final do Periodo do Ponto para Faltas.
                        Str(nDAfaVA),;      //-- Dias Afastamento
                        Str(nDFrProg),;     //-- Dias Ferias Programadas
                        Str(ndTrab),;       //-- Dias Trabalhados
                        Str(ndNTrab),;      //-- Dias Nao Trabalhados
                        Str(ndDSR),;        //-- Dias de DSR
                        Substr( AllTrim(Str(nValVaFu)), 1, nPos -1 ) + "," +;
                        Substr( AllTrim(Str(nValVaFu)), nPos + 1, Len( AllTrim(Str(nValVaFu)) ) - nPos ),; //-- Valor Unitario Beneficio.
                        cCodRef,;           //-- Codigo do Beneficio.
                        cDescric;           //-- Descricao do Beneficio.
                         })
      EndIf   

      (cAliasRA)->( dbSkip() )
EndDo

(cAliasRA)->( dbCloseArea() )


Return

/*+---------------------------------------------------------------------------+--------------------------------------+-------------------+
  | Funcao.: fGravaSZC(cFil,cMat,cPeriodo,nDias,nVlUnit,cCodRef,cDescric)     | Grava resultado de Calculo do VR     | Data.: 06.06.2016 |
  +------------------------------------+--------------------------------------+--------------------------------------+-------------------+
  | Autor.: Alexandre A. Silva - OPVS  | Objetivo.: Armazenar o resultado do calculo do Vale Refeicao para geracao do arquivo de pedido  |
  |                                    | e descontos na folha do colaborador.                                                            |
  +------------------------------------+-------------------------------------------------------------------------------------------------+
  | Parametros.: cFil    -> Filial do Funcionario.                                                                                       |
  |              cMat    -> Matricula do Funcionario.                                                                                    |
  |              cCC     -> Centro de Custo do Funcionario.                                                                              |
  |              cPeriodo-> Periodo de Referencia do Calculo.                                                                            |
  |              nDias   -> Quantidade de Dias ou Beneficios a pagar.                                                                    |
  |              nVlUnit -> Valor unitario do beneficio.                                                                                 |
  |              cCodRef -> Codigo do Beneficio conforme cadastro.                                                                       |
  |              cDescric-> Descricao do Beneficio conforme cadastro.                                                                    |
  +--------------------------------------------------------------------------------------------------------------------------------------+
*/
Static Function fGravaSZC(cFil,cMat,cCC,cPeriodo,nDias,nVlUnit,cCodRef,cDescric)                            

If SZC->( DbSeek(cFil+cMat+cPeriodo) )
   SZC->( RecLock("SZC",.F.)         )
Else
   SZC->( RecLock("SZC",.T.)         )
EndIf    

SZC->ZC_FILIAL   := cFil
SZC->ZC_MAT      := cMat
SZC->ZC_ANOMES   := cPeriodo
SZC->ZC_COD      := cCodRef
SZC->ZC_DESCRIC  := cDescric                                                                                                                                    
SZC->ZC_QUANT    := nDias
SZC->ZC_VLUNIT   := nVlUnit
SZC->ZC_TOTAL    := nVlUnit * nDias
SZC->ZC_FLAG     := "G"       
SZC->ZC_EMP      := SZC->ZC_TOTAL    
SZC->ZC_CC       := cCC

SZC->( MsUnlock() )

Return


/*+-----------------------------------------------------------------------------------+----------------------------------+-------------------+
  | Funcao.: fGravaSZD(cFil,cMat,cCC,cPeriodo,nDias,nValTot,nValEmp,cCodRef,cDescric) | Grava resultado de Calculo do VA | Data.: 06.06.2016 |
  +------------------------------------+----------------------------------------------+----------------------------------+-------------------+
  | Autor.: Alexandre A. Silva - OPVS  | Objetivo.: Armazenar o resultado do calculo do Vale Alimentaca para geracao do arquivo de pedido e  |
  |                                    | descontos na folha do colaborador.                                                                  |
  +------------------------------------+-----------------------------------------------------------------------------------------------------+
  | Parametros.: cFil    -> Filial do Funcionario.                                                                                           |
  |              cMat    -> Matricula do Funcionario.                                                                                        |
  |              cCC     -> Centro de Custo do Funcionario.                                                                                  |
  |              cPeriodo-> Periodo de Referencia do Calculo.                                                                                |
  |              nDias   -> Quantidade de Dias ou Beneficios a pagar.                                                                        |
  |              nValTot -> Valor Total do Funcionario.                                                                                      |
  |              nValEmp -> Valor do Beneficio Custeio Empresa.                                                                              |
  |              cCodRef -> Codigo do Beneficio conforme cadastro.                                                                           |
  |              cDescric-> Descricao do Beneficio conforme cadastro.                                                                        |
  +------------------------------------------------------------------------------------------------------------------------------------------+
*/
Static Function fGravaSZD(cFil,cMat,cCC,cPeriodo,nDias,nValTot,nValEmp,cCodRef,cDescric)

Local lAchaZD := SZD->( DbSeek(cFil+cMat+cPeriodo) )

If lAchaZD //.And. SZD->(ZD_FLAG) <> "I"
   SZD->(RecLock("SZD",.F.))
ElseIf !lAchaZD
   SZD->(RecLock("SZD",.T.))
EndIF
           
SZD->ZD_FILIAL   := cFil
SZD->ZD_MAT      := cMat
SZD->ZD_ANOMES   := cPeriodo
SZD->ZD_COD      := cCodRef
SZD->ZD_DESCRIC  := cDescric                                                                                                                                   
SZD->ZD_QUANT    := nDias
SZD->ZD_VLUNIT   := nValTot
SZD->ZD_TOTAL    := nValTot
SZD->ZD_FLAG     := "G"       
SZD->ZD_EMP      := nValEmp
SZD->ZD_CC       := cCC

SZD->( MsUnlock() )

Return


/*+--------------------------------------------------------------------+---------------------------------------------+-------------------+
  | Funcao.: fCkFtBen(cFil, cMat, dPerIni, dPerFim, cEveFlt, cCodAbo ) | Resgata Informacoes do Cadastro de Periodos | Data.: 06.06.2016 |
  +------------------------------------+-------------------------------+---------------------------------------------+-------------------+
  | Autor.: Alexandre A. Silva - OPVS  | Objetivo.: Resgatar Dias de VR, Dias Uteis e demais informacoes referentes ao periodo em proces-|
  |                                    | samento, para compor  beneficios do colaborador.                                                |
  +------------------------------------+-------------------------------------------------------------------------------------------------+
  | Parametros.: cFil    -> Filial do Funcionario.                                                                                       |
  |              cMat    -> Matricula do Funcionario.                                                                                    |
  |              dPerIni -> Data Inicio do Periodo de Apontamento de Ponto.                                                              |
  |              dPerFim -> Data Fim do Periodo de Apontamento de Ponto.                                                                 |
  |              cEveFlt -> Evento referente a Falta Integra.                                                                            |
  |              cCodAbo -> Abonos com efeito sobre as Faltas Integrais.                                                                 |
  +--------------------------------------------------------------------------------------------------------------------------------------+
*/
Static Function fCkFtBen(cFil, cMat, dPerIni, dPerFim, cEveFlt, cCodAbo )

Local nDiasFal := 0
Local cQuery   := ""
Local cQryFal  := GetNextAlias()

cQuery := "SELECT PH_FILIAL, PH_MAT, COUNT(1) AS PH_FLT "
cQuery += "FROM "+RetSqlName("SPH")+"         "
cQuery += "WHERE D_E_L_E_T_ <> '*'            "
cQuery += "AND PH_FILIAL = '"+cFil+"' "
cQuery += "AND PH_MAT    = '"+cMat+"'    "
cQuery += "AND PH_PD = '"+AllTrim(cEveFlt)+"' "
cQuery += "AND PH_DATA BETWEEN '"+dPerIni+"'  AND '"+dPerFim+"' "
       
//-> Se houver abonos (especificos) para Faltas Integrais, considera-os.
If !Empty( cCodAbo )
   cQuery += "AND PH_ABONO NOT IN ("+cCodAbo+") "
EndIf
       
cQuery += "GROUP BY PH_FILIAL, PH_MAT "
cQuery += "ORDER BY PH_FILIAL, PH_MAT "
       
cQuery := ChangeQuery(cQuery)
       
TCQUERY cQuery NEW ALIAS (cQryFal)
       
nDiasFal := (cQryFal)->PH_FLT
       
(cQryFal)->( DbCloseArea() )

Return(nDiasFal)


/*
+-----------------------------------------------------------------------------+-------------------+
| Funcao.: fCkFrPro() | Verifica Dias de VR em funcao das Ferias Programadas  | Data.: 06.06.2016 |
+------------------------------------+----------------------------------------+-------------------+
| Autor.: Alexandre A. Silva - OPVS  | Objetivo.: Resgatar Dias de VR, Dias Uteis e demais        |
|                                    | informacoes em funcao das Ferias Programadas para compor   |
|                                    |  beneficios do colaborador.                                |
+------------------------------------+------------------------------------------------------------+
| Parametros.:                                                                                    |
+-------------------------------------------------------------------------------------------------+
*/
Static Function fCkFrPro(dDataRef)

Local  dDtFimFr   := CToD("  /  /    ")
Local  dDtIniProg := CToD("  /  /    ")
Local nY := 0
Private aTabFer     := {}		// Tabela para calculo dos dias de ferias

/*
+--------------------------------------------------------------+
| Carrega tabela para apuracao dos dias de ferias - aTabFer    |
| 1-Meses Periodo    2-Nro Periodos   3-Dias do Mes    4-Fator |
+--------------------------------------------------------------+
*/
fTab_Fer(@aTabFer)

/*
+--------------------------------------------------------------+
| Prepara Matrizes para apuração de Dias Trabalhados no Mes, em|
| funcao das Ferias Programadas.                               |
+--------------------------------------------------------------+
*/
//aPeriodo      := {}
aDiasMes      := {}

//-> Verifica Dias de Vale Refeicao caso considere   Ferias programadas

nSaldo      := 0
nFaltas     := 0
nDferven    := 0
nDferave    := 0 
nSaldo_i    := 0
nSaldo_f    := 0                 
nDFrProg    := 0	
nDAntPer    := 0
nDFlFrPr    := 0
nDiasFePro  := 0
nDiasAbono  := 0
lTemProgFer := .F.

IF SRF->(DbSeek( (cAliasRA)->(RA_FILIAL+RA_MAT) ) )
   dDtIniProg := SRF->RF_DATAINI

   nDiasFePro := SRF->RF_DFEPRO1
   nDiasAbono := SRF->RF_DABPRO1

   If MesAno(SRF->RF_DATINI2) == MesAno(DdataRef)
      dDtIniProg := SRF->RF_DATINI2
      nDiasFePro := SRF->RF_DFEPRO2
      nDiasAbono := SRF->RF_DABPRO2

   ElseIf MesAno(SRF->RF_DATINI3) == MesAno(DdataRef)
      dDtIniProg := SRF->RF_DATINI3
      nDiasFePro := SRF->RF_DFEPRO3
      nDiasAbono := SRF->RF_DABPRO3
   EndIf	
EndIf
       
If MesAno(dDtIniProg) = MesAno(DdataRef) .Or.;
   MesAno(dDtIniProg+nDiasFePro) = MesAno(DdataRef)

   dDtBasFe := SRF->RF_DATABAS

   //Se nao houver dias de programadas calcula dias de vencidas 
   If nDiasFePro > 0 
      nDferven := nDiasFePro 
   Else
      nDAntPer := SRF->RF_DFERANT 

      //Calcula dias de Ferias Vencidas e proporcionais 
      Calc_Fer(dDtBasFe,dDataRef,@nDferVen,@nDferAve) 
      nDferven := If (nDferVen <= 0,nDferave,nDferven) 
      nDferven := If (nDferVen > aTabFer[3],aTabFer[3],nDferven) 
   EndIf 

   //Verifica dias de faltas de acordo com tabela p/ ferias 
   nFaltas  := nDFlFrPr 
   TabFaltas(@nFaltas)
    	        	   	           	        	
   //Desconto ferias antecipadas
   nDFerVen 	:= nDferVen - nFaltas - nDAntPer
				
   //Verifica se tem abono pecuniario 
   nDiasAbono 	:= If( nDiasAbono > 0, nDiasAbono, (nDFerVen -(nDFerVen / 3)) ) 
   ndFerVen   	:= If(SRF->RF_TEMABPE ="S" .And. !lTemCpoProg,nDiasAbono,ndFerVen)  // Total de dias que o func.term direito a ferias
   dDtFimFr 	:= dDtIniProg + nDferVen - 1 	//Data	prevista para termino ferias
				
   If MesAno(dDtIniProg+nDiasFePro) > MesAno(DdataRef)
      dDtFimFr := dDataFim
   EndIf				
				
   //->Verifica Dias de Vale Transporte Dias Uteis e Nao uteis dentro de um periodo

   If ( dDtFimFr - dDtIniProg ) > 0 
   
      For nY := dDtIniProg To dDataFim
          If ( nPos := Ascan(aDiasMes,{|x| x[1]==nY}) ) > 0
             If !aDiasMes[nPos,4]
                 aDiasMes[nPos,4] := .T.
                 aDiasMes[nPos,5] := "FER"
             EndIf
          EndIf
      Next nY					

      Aeval(aDiasMes,{|x| nDFrProg   += If(x[4] .And. x[5]=="FER",1,0)})						
   Endif
Endif

Return()



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fAsrPerg  ºAutor  ³Microsiga           º Data ³  11/21/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Perguntas do Sistema.                                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß */
Static Function fAsrPerg()

Local aRegs := {}
Local Fi    := FWSizeFilial()

Aadd(aRegs,{ cPerg,'01','Data Referencia ?        ','','','mv_ch1','D',08,0,0,'G','NaoVazio   ','mv_par01','               ','','','','','           ','','','','','         ','','','','','            ','','','','','           ','','','','      ','' })
aAdd(aRegs,{ cPerg,'02','Filial De ?              ','','','mv_ch2','C',02,0,0,'G','           ','mv_par02','               ','','','','','           ','','','','','         ','','','','','            ','','','','','           ','','','','SM0   ','' })
aAdd(aRegs,{ cPerg,'03','Filial Ate ?             ','','','mv_ch3','C',02,0,0,'G','NaoVazio   ','mv_par03','               ','','','','','           ','','','','','         ','','','','','            ','','','','','           ','','','','SM0   ','' })
aAdd(aRegs,{ cPerg,'04','Matricula De ?           ','','','mv_ch4','C',06,0,0,'G','           ','mv_par04','               ','','','','','           ','','','','','         ','','','','','            ','','','','','           ','','','','SRA   ','' })
aAdd(aRegs,{ cPerg,'05','Matricula Ate ?          ','','','mv_ch5','C',06,0,0,'G','NaoVazio   ','mv_par05','               ','','','','','           ','','','','','         ','','','','','            ','','','','','           ','','','','SRA   ','' })
aAdd(aRegs,{ cPerg,'06','Centro Custo De ?        ','','','mv_ch6','C',09,0,0,'G','           ','mv_par06','               ','','','','','           ','','','','','         ','','','','','            ','','','','','           ','','','','CTT   ','' })
aAdd(aRegs,{ cPerg,'07','Centro Custo Ate ?       ','','','mv_ch7','C',09,0,0,'G','NaoVazio   ','mv_par07','               ','','','','','           ','','','','','         ','','','','','            ','','','','','           ','','','','CTT   ','' })
aAdd(aRegs,{ cPerg,'08','Situacoes ?              ','','','mv_ch8','C',05,0,0,'G','fSituacao  ','mv_par08','               ','','','','','           ','','','','','         ','','','','','            ','','','','','           ','','','','      ','' })
Aadd(aRegs,{ cPerg,'09','Categorias ?             ','','','mv_ch9','C',12,0,0,'G','fCategoria ','mv_par09','               ','','','','','           ','','','','','         ','','','','','            ','','','','','           ','','','','      ','' })
Aadd(aRegs,{ cPerg,'10','Gerar ?                  ','','','mv_cha','N',01,0,0,'C','           ','mv_par10','Refeicao       ','','','','','Alimentacao','','','','','         ','','','','','            ','','','','','           ','','','','      ','' })
Aadd(aRegs,{ cPerg,'11','Prop.Ferias/Afast. ?     ','','','mv_chb','N',01,0,0,'C','           ','mv_par11','Sim            ','','','','','Nao        ','','','','','         ','','','','','            ','','','','','           ','','','','      ','' })
Aadd(aRegs,{ cPerg,'12','Prop.Ferias Prog.?       ','','','mv_chc','N',01,0,0,'C','           ','mv_par12','Sim            ','','','','','Nao        ','','','','','         ','','','','','            ','','','','','           ','','','','      ','' })
Aadd(aRegs,{ cPerg,'13','Prop.Admissao    ?       ','','','mv_chd','N',01,0,0,'C','           ','mv_par13','Sim            ','','','','','Nao        ','','','','','         ','','','','','            ','','','','','           ','','','','      ','' })
Aadd(aRegs,{ cPerg,'14','Descontar Faltas ?       ','','','mv_che','N',02,0,0,'C','           ','mv_par14','Sim            ','','','','','Nao        ','','','','','         ','','','','','            ','','','','','           ','','','','      ','' })


ValidPerg(aRegs,cPerg)

Return


/*
+-------------------+------------------------------------------+----------------------+
| Funcao.: fAboBen  | Autor.: Alexandre Alves da Silva - OPVS. | Data.: 06/06/2016    |
+-------------------+------------------------------------------+----------------------+
| Descricao.: Busca Codigos de Abonos para Abono de Faltas a Descontar nos Beneficios |
+---------------------+---------------------------------------------------------------+
| Objetvivo da Rotina | Resgatar os codigos dos abonos que abonam de fato as faltas   |
+---------------------+ integrais, que abateriam os beneficios.                       |
| Esses codigos de abonos devem estar informados na tabela da folhas (Manutenção      |
| Tabelas). Detalhes na documentação do projeto.                                      |
+-------------------------------------------------------------------------------------+
| Observacoes.: Essa rotina foi desenvolvida com base na rotina padrao de calculo de  |
|               Vale Transporte (GPEM050).                                            |
+-------------------------------------------------------------------------------------+
|                                     MANUTENCOES                                     |
+------------+-----------------------------+------------------------------------------+
| Data       | Autor                       | Objetivo                                 |
+------------+-----------------------------+------------------------------------------+
*/
Static Function fAboBen()

Local cCodAbo     := ""
Local cMV_CTABBEN := GetMv("MV_CTABBEN")

If !Empty(cMV_CTABBEN)

          RCC->( DbSetOrder(1) )
          RCC->( DbGoTop()      )
          RCC->( DbSeek( xFilial("RCC") + cMV_CTABBEN ) )
    While RCC->( !EOF() ) .And. RCC->(RCC_FILIAL+RCC_CODIGO) = ( xFilial("RCC") + cMV_CTABBEN )

          cCodAbo  := cCodAbo +"'"+AllTrim(Substr(RCC->RCC_CONTEUDO,1,3))+"',"
          RCC->( DbSkip() )      
    EndDo
    cCodAbo  := If( !Empty(cCodAbo), Substr(cCodAbo, 1, Len(cCodAbo) -1), cCodAbo )
EndIf

Return(cCodAbo)


/*
+--------------------+-----------------------------------+-----------------------+
|Funcao.: fPlanLOG   | Autor.: Alexandre Alves           | Data.: 06/06/2016     |
+--------------------+-----------------------------------+-----------------------+
|Descricao.: Funcao auxiliar para geracao de planilha de conferencia do calculo. |
+--------------------------------------------------------------------------------+
*/
Static Function fPlanLOG( aRegs )

Local lSetCentury := __SetCentury( "on" )
Local cPath       := AllTrim( GetTempPath() )
Local nTotReg     := 0
Local cNomeArq    := ""

Local cLin
Local nPos, nX, nY

Local lErrInc   := .F.
Local lErrExc   := .F.

Private nHdl

cNomeArq  := CriaTrab(,.F.) + ".CSV"

// Cria Arquivo Texto
cPath    := cPath + If(Right(cPath,1) <> "\","\","")
cNomeArq := cPath + cNomeArq
nHdl     := fCreate( cNomeArq )

If nHdl == -1
   MsgAlert("O arquivo de nome "+cNomeArq+" nao pode ser executado! Verifique os parametros.","Atencao!")
   Return
EndIf

//-> Gravando Cabecalho.
For nX := 1 To Len(aRegs[1])
    If nX = 1
       cLin := aRegs[1][nX] + cSep
    Else
       cLin += aRegs[1][nX] + cSep
    EndIf
Next 
cLin += cEol

If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
   If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
      Return
   Endif
Endif


//-> Gravando Dados.
For nX := 2 To Len(aRegs)

    For nY := 1 To Len(aRegs[nX])
        If nY = 1
           cLin := aRegs[nX][nY] + cSep //Filial
        Else 
           cLin += aRegs[nX][nY] + cSep
        EndIf
    Next nY
    cLin += cEol
    
    If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
       If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
          Return
       Endif
    Endif

Next nX


 
 If !lSetCentury
    __SetCentury( "off" )
 EndIf

fClose( nHdl )

// Integra Planilha ao Excel
MsAguarde( {|| fStartExcel( cNomeArq )}, "Aguarde...", "Integrando Planilha ao Excel..." )

Return


/*
+---------------------+-----------------------------------+-------------------------+
|Funcao.: fStartExcel | Autor.: Alexandre Alves           | Data.: 06/06/2016       |
+---------------------+-----------------------------------+-------------------------+
|Descricao.: Realiza o merge entre as informações geradas pela rotina com o MsExcel |
+-----------------------------------------------------------------------------------+
*/
Static Function fStartExcel( cNomeArq )

 If !ApOleClient( 'MsExcel' )
    MsgAlert( 'MsExcel nao instalado' )
 Else
    oExcelApp := MsExcel():New()
    oExcelApp:WorkBooks:Open( cNomeArq ) // Abre uma planilha
    oExcelApp:SetVisible(.T.)
    oExcelApp:Destroy()
 EndIf

Return


/*
+---------------------+--------------------------+-------------------+
|Funcao.: fLoga | Autor.: Alexandre Alves        | Data.: 06/06/2016 |
+---------------+--------------------------------+-------------------+
|Descricao.: Carrega a matriz de LOG com as informações processadas. |
+--------------------------------------------------------------------+
*/
Static Function fLoga(lVazio)

//|-> Se a matriz estiver vazia, carrega com o Cabecalho.
If lVazio
   AaDd(aProceed,{ 'Filial',;
                   'Matricula',;
                   'Nome',;
                   'Centro de Custo',;
                   'Periodo Compra',;
                   'Qtde. Beneficios',;
                   'Qtde. Faltas',;
                   'Per.Inicio Ponto',; 
                   'Per.Final Ponto',;
                   'Dias Afastado',;
                   'Dias Ferias Prog.',;
                   'Dias Trabalhados',;
                   'Dias Nao Trabalhados',;
                   'Dias de DSR',;
                   'Valor Unitario',;
                   'Codigo Beneficio',;
                   'Descricao Beneficio';
                 })
EndIf

Return

//-------------------------------------------------------------------------------------------------------------------------------------------------------------
/*/{Protheus.doc} fCarDiasMes(cTipo, aDias, lPropAdm)
Encapsulamento da função padrão fCarDiasMes(), que retorna a quantidade de dias uteis para o beneficio passado no parametro.

cTipo    = (0 = Vale Transporte / 1 = Vale Refeição / 2 = Vale Alimentação).
aDias    = Array para passagem dos dias de utilização do beneficio.
lPropAdm = Se proporcionaliza à admissão.


@Return aDias
@author Alexandre Alves
@since 14/07/2017.
@version 1.0
/*/
//-------------------------------------------------------------------------------------------------------------------------------------------------------------

User Function fCarDiasMes(cTipo, aDias, lPropAdm)

Local nX 		:= 0 
Local lNaoCalc	:= .F.
Local cVale
Local cMotivo	:= ""

If Len(aPeriodo) < 1
    Return(Nil)
Endif

For nX := 1 to Len(aPeriodo[1][5])
	lNaoCalc	:= .F.
	cMotivo	:= ""
	
	If cTipo = 0  //Vale Transporte
		cVale := aPeriodo[1][5][nX][3]
	ElseIf cTipo = 1 //Vale Refeição
		cVale := aPeriodo[1][5][nX][5]
	ElseIf cTipo = 2 //Vale Alimentação
		cVale := aPeriodo[1][5][nX][8]
	Endif
	lNaoCalc := cVale == "2"
	
    If lPropAdm .And. (SRA->RA_ADMISSA > aPeriodo[1][5][nX][1])
       lNaoCalc := .T.
       cMotivo  := "ADM"
    EndIf	

	aAdd( aDias , { aPeriodo[1][5][nX][1], aPeriodo[1][5][nX][2], cVale, lNaoCalc,  } ) 
Next nX
                                  

Return (aDias)
