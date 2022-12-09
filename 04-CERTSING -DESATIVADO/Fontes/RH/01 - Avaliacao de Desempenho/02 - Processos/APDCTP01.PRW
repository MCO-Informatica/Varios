#INCLUDE "PROTHEUS.CH"
#INCLUDE "APDM010.CH"
#INCLUDE "TOPCONN.CH"

/*---------+-------------------------------+------------+-----------------------------+
 |APDCTP01 |  Calculo das Avaliacoes - APD | 13.01.2017 | Alexandre Alves - CERTISIGN |
 +---------+-------------------------------+------------+-----------------------------+
 | Realiza o calculo dos resultados das avaliações, conforme regras estabelecidas pelo|
 | RH. As regras para o calculo em vigor atualmente (01/2017) são:                    |
 | Pontos da Questão (1 atualmente) multiplicado pelo Valor da Alternativa da Questão |
 |( estabelecido em RBL, com base na SQO - Questões), multiplicado pelo Grau de       |
 |Importancia da Questão ( estabelecido em RBL, com base na RDB - Alternativa das     |
 |Respostas da Avaliacöes ).                                                          |
 +---------------------------+--------------------------------------------------------+
 */
User Function APDCTP01()

Local cFiltra		:= ""			
Local aIndFil		:= {}			
Local aArea         := GetArea()

Private cCad       := "Calculo do Resultado da Avaliacao"
Private cDescricao := "Realiza o das avaliações, conforme respostas dos colaboradores e gestores."
Private cPerg      := "CSAD0001"

Private bProcesso   := {|oSelf| APDACalculo( oSelf )}
Private cCadastro   := OemtoAnsi("Calculo do Resultado da Avaliacao")	
Private bFiltraBrw 	:= {|| Nil}		
Private aRotina     := { 	{ OemToAnsi("Pesquisar") ,'PesqBrw', 0, 1}, ;
						    { OemToAnsi("Calcular") ,'tNewProcess():New( "APDACalculo" , cCad , bProcesso , cDescricao , cPerg,,.T.,200,"Painel Auxiliar",.T.,.F. )', 0, 4} }	//"Calcular" //	Processa( {|| APDACalculo( cAlias, nReg, nTipo ) } )
						    
APD01SX1(cPerg)
Pergunte(cPerg,.F.)

dbSelectArea("RD6") //->Cabecalho Montagem Avaliacoes 
dbSetOrder(1)

cFiltra 	:= CHKRH(FunName(),"RD6","1")
bFiltraBrw 	:= {|| FilBrowse("RD6",@aIndFil,@cFiltra) }
Eval(bFiltraBrw)

//Endereca a funcao de BROWSE
dbSelectArea("RD6")
dbGoTop()

mBrowse(6, 1, 22, 75, "RD6")

// Deleta o filtro utilizando a funcao FilBrowse
EndFilBrw("RD6",aIndFil) 

RestArea( aArea )

Return Nil

/*-----------+------------------------------------------------+------------+-----------------------------+
 |APDACalculo|  Motor principal para o calculo das avaliações.| 13.01.2017 | Alexandre Alves - CERTISIGN.|
 +-----------+------------------------------------------------+------------+-----------------------------+
 
mv_par01 - Avaliacao De
mv_par02 - Avaliacao Ate 
mv_par03 - Avaliado  De
mv_par04 - Avaliado  Ate
mv_par05 - Log de Ocorrencias (1- Sim / 2 - Nao)
mv_par06 - Tipo Avaliacao ?   (1 - Somente Consenso / 2 - Sem Consenso / 3 - Ambas)
mv_par07 - Dta. Inicio Aval. ?
mv_par08 - Dta. Final Aval. ?
*/
Static Function APDACalculo( oSelf ) //APDACalculo(cAlias, nReg, nTipo )
      
//-- Variaveis para calculo
Local aLogMsg		:= {}				// Array para armazenar mensagem de falha de calculo       
Local cTitulo 		:= OemToAnsi("Log Ocorrências  - Retorno das Avaliaçöes ")
Local cQuery        := ""
Local nAvaProc      := 1

PRIVATE aVlrQuestao   := {}               //-- Array contendo os valores obtidos de cada Questao 
PRIVATE aMediaItemNet := {}				//-- Array contendo a Media por competencia / Rede
//PRIVATE lFeedBk       := .F.              //-- Verifica se a avaliação em processamento possui Consenso.
Private cAlsAux       := GetNextAlias()

//-> Variaveis para LOG de Envio/Retorno de Avaliações.
Private aLogTitle   := {}
Private aLog		:= {}

//-> Tratamento dos perguntes.
mv_par01 := If(Empty(mv_par01), Space(TAMSX3("RDD_CODAVA")[1]), AllTrim(mv_par01))
mv_par02 := If(Empty(mv_par02),  AllTrim(Padr(mv_par02, TAMSX3("RDD_CODAVA")[1],'Z')), AllTRim(mv_par02))
mv_par03 := If(Empty(mv_par03), Space(TAMSX3("RDD_CODADO")[1]), AllTrim(mv_par03))
mv_par04 := If(Empty(mv_par04),  AllTrim(Padr(mv_par04, TAMSX3("RDD_CODADO")[1],'Z')), AllTrim(mv_par04))
mv_par07 := If(Empty(mv_par07), CToD("  /  /    "), mv_par07)                       
mv_par08 := If(Empty(mv_par08), CToD("30/01/"+Year(dDataBase)), mv_par08)                       


cQuery := " SELECT  RD6_CODIGO "+CRLF                              //--Codigo Avaliação
cQuery += "        ,RD6_DESC   "+CRLF                              //--Descrição Avaliação
cQuery += "        ,RD6_CODTIP "+CRLF                              //--Tipo da Avaliação (RD5)
cQuery += "        ,RD5_TIPO   "+CRLF                              
cQuery += "        ,RD6_STATUS "+CRLF                              
cQuery += "        ,RDB_CODMOD "+CRLF                              //-> Codigo Modelo Avaliação.
cQuery += "        ,RDB_CODADO "+CRLF
cQuery += "        ,RDB_TIPOAV "+CRLF                              //--> Tipo do Avaliador.
cQuery += "        ,RDB_CODPRO "+CRLF                              //--> Codigo do Projeto.
cQuery += "        ,RDB_CODDOR "+CRLF                              //--> Codigo da Avaliador.
cQuery += "        ,RDB_DTIAVA "+CRLF                              //--> Periodo Inicial Avaliacao.
cQuery += "        ,RDB_DTFAVA "+CRLF                              //--> Periodo Final Avaliacao.
cQuery += "        ,RDB_CODCOM "+CRLF                              //--> Competencia.
cQuery += "        ,RDB_ITECOM "+CRLF                              //--> Item de Competencia.
cQuery += "        ,RDB_CODNET "+CRLF                              //--> Codigo da Rede.
cQuery += "        ,RDB_CODQUE "+CRLF                              //--> Codigo da Questao.
cQuery += "        ,RDB_CODALT "+CRLF                              //--> Codigo da Alternativa Escolhida Pelo Colaborador.
cQuery += "        ,RDB_ESCALA "+CRLF                              //--> Codigo Escala/Importancia.
cQuery += "        ,RDB_ITEESC "+CRLF                              //--> Item Escala/Importancia.
cQuery += "        ,RDO_ESCALA "+CRLF                              //--> Escala do Grau de Importancia da Pergunta
cQuery += "        ,RDO_ITEESC "+CRLF                              //--> Item do Grau de Importancia da Pergunta
cQuery += "        ,(SELECT RBL_VALOR                      "+CRLF
cQuery += "          FROM "+RetSqlName("RBL")+"            "+CRLF
cQuery += "          WHERE D_E_L_E_T_ <> '*'               "+CRLF
cQuery += "            AND RBL_ESCALA = RDO_ESCALA         "+CRLF
cQuery += "            AND RBL_ITEM   = RDO_ITEESC) VLRGIP "+CRLF  //--Valor do Grau de Importancia da Pergunta.
cQuery += "        ,QO_PONTOS  "+CRLF                              //--Pontos da Questao.  
cQuery += "        ,QO_TIPOOBJ "+CRLF                              //--Tipo Objetivo da Questao 
cQuery += "        ,QO_ESCALA  "+CRLF                              //--Escala para Estabelecimento de Valores para a Questão.
cQuery += "        ,(SELECT RBL_VALOR                      "+CRLF
cQuery += "          FROM "+RetSqlName("RBL")+"            "+CRLF
cQuery += "          WHERE D_E_L_E_T_ <> '*'               "+CRLF
cQuery += "            AND RBL_ESCALA = QO_ESCALA          "+CRLF
cQuery += "            AND RBL_ITEM   = RDB_CODALT)  VLRQST"+CRLF  //--Valor da Alternativa Escolhida.
cQuery += "        ,(SELECT QP_PERCENT                     "+CRLF  
cQuery += "          FROM "+RetSqlName("SQP")+"            "+CRLF
cQuery += "          WHERE D_E_L_E_T_ <> '*'               "+CRLF
cQuery += "            AND QP_QUESTAO = RDB_CODQUE         "+CRLF
cQuery += "            AND QP_ALTERNA = RDB_CODALT) PCTALT "+CRLF  //--SQP - Alternativas x Questoes  (QP_PERCENT = Percentual da Alterativa)
cQuery += "	       ,RD6.R_E_C_N_O_ RD6REC                  "+CRLF
cQuery += " FROM "+RetSqlName("RD6")+" RD6                                                              "+CRLF   //--RD6 - Cabecalho Montagem Avaliacoes 
cQuery += " INNER JOIN "+RetSqlName("RD5")+" RD5 ON RD5_CODTIP = RD6_CODTIP                             "+CRLF   //--RD5 - Cabecalho Tipos de Avaliacoes 
cQuery += " INNER JOIN "+RetSqlName("RDB")+" RDB ON RDB_CODAVA = RD6_CODIGO                             "+CRLF   //--RDB - Itens Respostas de Avaliacöes 
cQuery += " INNER JOIN "+RetSqlName("SQO")+" SQO ON QO_QUESTAO = RDB_CODQUE                             "+CRLF   //--SQO - Questoes
cQuery += " INNER JOIN "+RetSqlName("RDO")+" RDO ON RDO_CODMOD = RDB_CODMOD AND "
cQuery += "                                         RDO_CODCOM = RDB_CODCOM AND "                            
cQuery += "                                         RDO_ITECOM = RDB_ITECOM     "
cQuery += " WHERE RD6_CODIGO BETWEEN '"+mv_par01  + "' AND '"+mv_par02+"' "+CRLF
cQuery += "   AND RDB_CODADO BETWEEN '"+mv_par03  + "' AND '"+mv_par04+"' "+CRLF
cQuery += "   AND RD6_DTINI >= '"+DToS(mv_par07) + "' "+CRLF
cQuery += "   AND RD6_DTFIM <= '"+DToS(mv_par08) + "' "+CRLF
cQuery += "   AND RD6.D_E_L_E_T_ <> '*'    "+CRLF
cQuery += "   AND RD5.D_E_L_E_T_ <> '*'    "+CRLF
cQuery += "   AND RDB.D_E_L_E_T_ <> '*'    "+CRLF
cQuery += "   AND SQO.D_E_L_E_T_ <> '*'    "+CRLF
cQuery += "   AND RDO.D_E_L_E_T_ <> '*'    "+CRLF

If     mv_par06 = 1 //-> Somento COM consenso.

       cQuery += "   AND EXISTS(SELECT 1 FROM "+RetSqlName("RDH")+" "+CRLF
       cQuery += "              WHERE D_E_L_E_T_ <> '*' "+CRLF
       cQuery += "                AND RDH_CODTIP = RDB_CODTIP "+CRLF
       cQuery += "                AND RDH_FEEDBK  = '1')      "+CRLF

ElseIf mv_par06 = 2 //-> Somento SEM consenso.

       cQuery += "   AND NOT EXISTS(SELECT 1 FROM "+RetSqlName("RDH")+" "+CRLF
       cQuery += "                  WHERE D_E_L_E_T_ <> '*' "+CRLF
       cQuery += "                    AND RDH_CODTIP = RDB_CODTIP "+CRLF
       cQuery += "                    AND RDH_FEEDBK  = '1')      "+CRLF
EndIf

cQuery += " ORDER BY RD6_CODIGO, RDB_CODADO, RDB_TIPOAV, RDB_CODCOM, RDB_ITECOM, RDB_CODQUE "+CRLF

cQuery := ChangeQuery(cQuery)

TCQUERY cQuery NEW ALIAS (cAlsAux)
                                   
   (cAlsAux)->( DbGotop()     )
If (cAlsAux)->( Eof()         )      

    Aviso("ATENÇÃO !!",OemToAnsi("NÃO FORAM ENCONTRADOS REGISTROS PARA SUA SELEÇÃO."+CRLF+OemToAnsi("REVISE OS PARAMETROS.")),{"OK"})
   (cAlsAux)->( DbCloseArea() )
   Return()
EndIf


While (cAlsAux)->(!Eof())

    oSelf:IncRegua1( "Avaliação.: "+(cAlsAux)->RD6_CODIGO+" - "+(cAlsAux)->RD6_DESC+" ...aguarde." )
    If oSelf:lEnd 
       Break
    EndIf
    
    //-> Verifico se saltou a avaliação. Se sim, gravo os resultados da ultima processada.
    If !Empty(aVlrQuestao) .And. (cAlsAux)->RD6_CODIGO <>  aVlrQuestao[01][02]
    
	   aMediaItemNet := fCalcMediaComp( oSelf ) //-> Calculo do Grau de Importancia.
    
       fSaveFile( oSelf )           //-> Gravação dos Resultados.
       
       fAPDAGeraLog(aVlrQuestao[01][02])               //-> Geração do Totalizador de Avaliações Enviadas / Retornadas.
       
       aMediaItemNet := {}
       aVlrQuestao   := {}
       nAvaProc++ //-> Conta as Avaliações processadas.
    
       If mv_par05 = 1 //-> Gera log? 1 = Sim.
          aAdd(aLogMsg, "["+(cAlsAux)->RD6_CODIGO+"]" + (cAlsAux)->RD6_DESC ) //Codigo e Descricao da Avaliacao
       EndIf

    ElseIf Empty(aVlrQuestao) .And. nAvaProc = 1 //-> Primeira execução.
       If mv_par05 = 1 //-> Gera log? 1 = Sim.
          aAdd(aLogMsg, "["+(cAlsAux)->RD6_CODIGO+"]" + (cAlsAux)->RD6_DESC ) //Codigo e Descricao da Avaliacao
       EndIf
    EndIf

    //lFeedBk := (cAlsAux)->RDH_FEEDBK = '1' //-> Seta de a avaliação possui Consenso.

	lAtivo :=  (cAlsAux)->RD6_STATUS = "1"
		
  	If !lAtivo .And. mv_par05 = 1 //- Log de Ocorrencias (1- Sim / 2 - Nao)
		//-> Alimenta Log com as avaliacoes as quais os avaliados estavam com o RDB possivelmente vazios.
		aAdd(aLogMsg,  " ")
		aAdd(aLogMsg, "["+(cAlsAux)->(RD6_CODIGO+"]" + (cAlsAux)->RD6_DESC) )    
	EndIf


    //-> Calcula Valor para Cada questao respondida  (RDB).
	nVlrQuestao	:= fVlrQuestao()
	                           
    aadd( aVlrQuestao,{;
                        Space(2),;			    //01    //-> Filial.
                        (cAlsAux)->RD6_CODIGO,;	//02    //-> Codigo Avaliação.
                        (cAlsAux)->RDB_CODADO,;	//03	//-> Codigo da Avaliado.
                        (cAlsAux)->RDB_CODPRO,;	//04	//-> Codigo do Projeto.
                        (cAlsAux)->RDB_CODDOR,;	//05    //-> Codigo da Avaliador.
                        (cAlsAux)->RDB_DTIAVA,;	//06	//-> Periodo Inicial Avaliacao.
                        (cAlsAux)->RDB_DTFAVA,;	//07	//-> Periodo Final Avaliacao.
                        (cAlsAux)->RDB_CODCOM,;	//08    //-> Competencia.
                        (cAlsAux)->RDB_ITECOM,;	//09    //-> Item de Competencia.
                        (cAlsAux)->RDB_CODNET,;	//10    //-> Codigo da Rede.
                        (cAlsAux)->RDB_CODQUE,;	//11    //-> Codigo da Questao.
                                  nVlrQuestao,; //12    //-> Valor Calculado para a Questão.
                        (cAlsAux)->RD6_CODTIP,;	//13    //-> Codigo Tip. Avaliacao.
                        (cAlsAux)->RDB_TIPOAV,;	//14    //-> Tipo do Avaliador.
                        (cAlsAux)->RDB_DTFAVA,;	//15    //-> Periodo Final Avaliacao.
                        (cAlsAux)->RDB_ESCALA,; //16    //-> Escala do Grau de Importancia da Questão.
                        (cAlsAux)->RDB_ITEESC,; //17    //-> Item da Escala do Grau de Importancia da Questão.
                        (cAlsAux)->VLRGIP,;     //18    //-> Valor do Grau de Importancia.
                        (cAlsAux)->RD6REC,;     //19    //-> R_E_C_N_O_ da Avaliação da RD6.
                        (cAlsAux)->RD6_DESC;    //20    //-> Descrição da Avaliação.
                          };                                    
            )  		
    
    (cAlsAux)->(dbSkip())
EndDo

//-> Calcula o ultimo registro desprezado pelo EOF da tabela.
If !Empty(aVlrQuestao)
    
   aMediaItemNet := fCalcMediaComp( oSelf ) //-> Calculo do Grau de Importancia.
    
   fSaveFile( oSelf )           //-> Gravação dos Resultados.
       
   fAPDAGeraLog(aVlrQuestao[01][02])               //-> Geração do Totalizador de Avaliações Enviadas / Retornadas.

   If mv_par05 = 1 //-> Gera log? 1 = Sim.
      aAdd(aLogMsg, "["+aVlrQuestao[01][02]+"]" + aVlrQuestao[01][20] ) //Codigo e Descricao da Avaliacao
   EndIf
         
   aMediaItemNet := {}
   aVlrQuestao   := {}
EndIf


AVISO("",OemToAnsi("Cálculo Efetuado com sucesso"),{"Ok"} )

If Len( aLogMsg ) > 2 .And. mv_par05 = 1 
   FMakeLog( { aLogMsg } ,{OemToAnsi( "As Avaliacoes abaixo foram calculadas para todos os seus respectivos avaliados:" )}, , NIL , NIL , cTitulo,"M","P",,.F. ) 
EndIf 
/*
If Len(aLog) > 2 .And. mv_par05 = 1 
   FMakeLog( { aLog } , aLogTitle , , NIL , NIL , cTitulo,"M","P",,.F. )
EndIf
*/
(cAlsAux)->( dbCloseArea() )
Return


/*------------+-------------------------------+------------+-----------------------------+
 |fVlrQuestao | Calculo do Valor das Questões | 14.01.2017 | Alexandre Alves - CERTISIGN |
 +------------+-------------------------------+------------+-----------------------------+
*/
Static Function fVlrQuestao()

Local nPontos 			:= 0 
Local nPtosQuestao		:= 0

nPontos	:= ((cAlsAux)->QO_PONTOS / (cAlsAux)->QO_PONTOS) //-> Pontos da Questão.	

/*
+-------------------------------------------------------------------------------------------------------------------------+
| cAlsAux)->QO_TIPOOBJ é baseado no campo SQO->QO_TIPOOBJ, que representa o TIPO DE RESPOSTA da questão.                  |
| Os tipos de respostas previstos são: 1 = Multipla escolha / 2 = Unica escolha / 3 = Dissertativa / 4 = Pontuacao        |
| Nesse processo utiliza-se os pontos da questão (SQO->QO_PONTOS) diretamente, para o tipo de resposta 3 ( Dissertativa ) |
+-------------------------------------------------------------------------------------------------------------------------+*/
nPtosQuestao := If( (cAlsAux)->QO_TIPOOBJ == "3", nPontos, nPtosQuestao ) 

/*
+-----------------------------------------------------------------------------------------------------------------------------------+
| Se o processo de calculo estiver sendo realziado para uma "Pesquisa", o multiplicado para os pontos da questão passa a ser 1 (um).|
+-----------------------------------------------------------------------------------------------------------------------------------+*/
If (cAlsAux)->RD5_TIPO == "2" // 1 = Avaliação / 2 = Pesquisa
   nPtosQuestao := 1
/*
+----------------------------------------------------------------------------------------------------------------------------------------------------+
| Se o processo de calculo estiver sendo realziado para uma "Avaliação", checo se a Escala de Valores para a questão esta vazia.                     |
| Se positivo, verifico ainda se há um percentual estabelecido para a ALTERNATIVA da questão, isso se o tipo de resposta for de Multipla Escolha (1).|
| Se o tipo de resposta for "Multipla Escolha", se a Escala de Alternativas estiver VAZIA, mas houver um percentual estabelecido para a alterantiva, |
| utilizo esse percentual para estabelecer um multiplicador para os pontos da questão.                                                               |
+----------------------------------------------------------------------------------------------------------------------------------------------------+*/
ElseIf (cAlsAux)->( Empty(QO_ESCALA) ) .And. (cAlsAux)->( !Empty(PCTALT) ) //SQP->QP_PERCENT

   /*+---------------------------------------------------------------------------------------------------------------------------------------------------+
     | cAlsAux)->PCTALT é baseado no campo SQP->QP_PERCENT, que representa o percentual de signicancia da alternativa da questão, em seu resultado total.|
     | Obviamente esse criterio só é valido, para questões que possuam alternativas e essas alterantivas possuam um percentual distinto para compor o    |
     | resultado final do valor de atingimento, na resposta da questão.                                                                                  |
     +---------------------------------------------------------------------------------------------------------------------------------------------------+*/
   nPtosQuestao += ( (cAlsAux)->PCTALT / 100 ) * nPontos 

ElseIf (cAlsAux)->( !Empty(QO_ESCALA) )

   /*+---------------------------------------------------------------------------------------------------------------------------------------------------+
     | Se a Alternativa (Escala) da questão existir, utilizo o valor da Alternativa (estabelecido em RBL) como Multiplicador dos Pontos da Questão, para |
     | estabelecer o Valor da Resposta do colaborador para a questão em si.                                                                              |
     +---------------------------------------------------------------------------------------------------------------------------------------------------+
   (cAlsAux)->VLRQST //-> Valor da Alteranativa Escolhida para a Pergunta.
   (cAlsAux)->VLRGIP //-> Valor do Grau de Importancia da Pergunta.
   nPontos            //-> Pontos da Questao.
   */
      
   nPtosQuestao += ( ( (cAlsAux)->VLRQST * (cAlsAux)->VLRGIP ) / nPontos )
EndIf

Return  ( nPtosQuestao )       

/*---------------+-------------------------------------------+------------+-----------------------------+
 |fCalcMediaComp | Calculo do Impacto do Grau de Importancia | 14.01.2017 | Alexandre Alves - CERTISIGN |
 +---------------+-------------------------------------------+------------+-----------------------------+
*/
Static Function fCalcMediaComp(oSelf)

Local aMediaItemComp:= {}
Local nQuestao		:= 0
Local nVlrGrImp		:= 1 // Contem o fafor do grau de importancia da questa     
Local nPosIt        := 0

//lFeedBk -> Indica se a Avaliação possui Consenso.

//-> Ordenando matriz: Cod. Avaliação + Competencia + Item de Competencia + Codigo de Rede + Tipo Avaliador.
aSort(aVlrQuestao , , , {|x,y|  x[3]+ x[8]+x[9] + x[10] + x[14] <  y[3]+ y[8]+ y[9] + y[10]  + y[14]   })	

For nQuestao := 1 To Len(aVlrQuestao)

    oSelf:IncRegua2( "Calculando Questão.: "+aVlrQuestao[nQuestao][11]+" ...aguarde." )
    If oSelf:lEnd 
       Break
    EndIf


    /*--------------------------------------------------------------------------------------------------
     ===> Se não ha CONSENSO utiliza a nota do AVALIADOR.    
     lFeedBk .............: Indica se há feedback na avaliação. 
     aVlrQuestao[999][14].: 1 = Nota do Avaliador / 2 = Nota da Auto-Avaliação / 3 = Nota do Consenso.
                                                                                                      
     ===> Havendo consenso na avaliação, utiliza nota do consenso.
    -----------------------------------------------------------------------------------------------------*/
    nPosIt := AsCan(aMediaItemComp,{|x| x[01] = aVlrQuestao[nQuestao][02] .And.; //-> Cod. Avaliação.            ##(cAlsAux)->RD6_CODIGO
                                        x[02] = aVlrQuestao[nQuestao][03] .And.; //-> Cod. Avaliado.             ##(cAlsAux)->RDB_CODADO
                                        x[03] = aVlrQuestao[nQuestao][04] .And.; //-> Cod. Projeto.              ##(cAlsAux)->RDB_CODPRO
                                        x[04] = aVlrQuestao[nQuestao][06] .And.; //-> Periodo Inicial Avaliacao. ##(cAlsAux)->RDB_DTIAVA
                                        x[05] = aVlrQuestao[nQuestao][07] .And.; //-> Periodo Final Avaliacao.   ##(cAlsAux)->RDB_DTFAVA
                                        x[06] = aVlrQuestao[nQuestao][08] .And.; //-> Competencia.               ##(cAlsAux)->RDB_CODCOM
                                        x[07] = aVlrQuestao[nQuestao][09] .And.; //-> Item de Competencia.       ##(cAlsAux)->RDB_ITECOM
                                        x[08] = aVlrQuestao[nQuestao][10] .And.; //-> Codigo da Rede.            ##(cAlsAux)->RDB_CODNET
                                        x[10] = aVlrQuestao[nQuestao][13] .And.; //-> Codigo Tip. Avaliacao.     ##(cAlsAux)->RD6_CODTIP
                                        x[11] = aVlrQuestao[nQuestao][14];       //-> Codigo Tip. Avaliador.     ##(cAlsAux)->RDB_TIPOAV
                                     };
                   )
       
       
    If nPosIt > 0
       aMediaItemComp[nPosIt][9] += aVlrQuestao[nQuestao][12] //-> Valor Calculado para a Questão. ##  nVlrQuestao
    Else
       aadd(aMediaItemComp,{;
                           aVlrQuestao[nQuestao][02],; //-> Cod. Avaliação.                 ##(cAlsAux)->RD6_CODIGO
                           aVlrQuestao[nQuestao][03],; //-> Cod. Avaliado.                  ##(cAlsAux)->RDB_CODADO
                           aVlrQuestao[nQuestao][04],; //-> Cod. Projeto.                   ##(cAlsAux)->RDB_CODPRO
                           aVlrQuestao[nQuestao][06],; //-> Periodo Inicial Avaliacao.      ##(cAlsAux)->RDB_DTIAVA
                           aVlrQuestao[nQuestao][07],; //-> Periodo Final Avaliacao.        ##(cAlsAux)->RDB_DTFAVA
                           aVlrQuestao[nQuestao][08],; //-> Competencia.                    ##(cAlsAux)->RDB_CODCOM
                           aVlrQuestao[nQuestao][09],; //-> Item de Competencia.            ##(cAlsAux)->RDB_ITECOM
                           aVlrQuestao[nQuestao][10],; //-> Codigo da Rede.                 ##(cAlsAux)->RDB_CODNET
                           aVlrQuestao[nQuestao][12],; //-> Valor Calculado para a Questão. ##  nVlrQuestao
                           aVlrQuestao[nQuestao][13],; //-> Codigo Tip. Avaliacao.          ##(cAlsAux)->RD6_CODTIP
                           aVlrQuestao[nQuestao][14];  //-> Codigo Tip. Avaliador.          ##(cAlsAux)->RDB_TIPOAV
                           };
	       ) 
    EndIf
Next nQuestao

Return ( aMediaItemComp ) 

/*-----------+------------------------------------+------------+-----------------------------+
 |fSaveFile  | Grava os resultados das avaliações | 14.01.2017 | Alexandre Alves - CERTISIGN |
 +-----------+------------------------------------+------------+-----------------------------+
*/
Static Function fSaveFile( oSelf )

Begin Sequence 

	fGravaRDD(oSelf)       //Salva Media Item Compet. / Rede
	fGravaRDB(oSelf)         //Salva Resultado por Questao                                  
    fGravaRD6(aVlrQuestao[01][19]) //Salva Data do Calculo (Passando o RECNO da avaliação na RD6)                                       

End Sequence 

Return

/*-----------+---------------------------------------------+------------+-----------------------------+
 |fGravaRDD  | Salva o Valor das Alternativas das Questões | 14.01.2017 | Alexandre Alves - CERTISIGN |
 +-----------+---------------------------------------------+------------+-----------------------------+
*/
Static function fGravaRDD(oSelf) 

Local nAvaliado	:= 0  
Local cKey		:= ""
Local lNew      := .T.

//-> RDD -> Itens Resultados de AvaliacoeS.
RDD->( dbSetOrder(1)) //RDD_FILIAL + RDD_CODAVA + RDD_CODADO + RDD_CODPRO + DTOS(RDD_DTIAVA) + RDD_CODCOM + RDD_ITECOM + RDD_CODNET + RDD_TIPOAV

For nAvaliado := 1 to len(aMediaItemNet ) 	

    oSelf:IncRegua2( "Gravando Resultado Avaliação.: "+aMediaItemNet[ nAvaliado,1 ]+" ...aguarde." )
    If oSelf:lEnd 
       Break
    EndIf
	
	cKey 	:= xFilial("RDD") +aMediaItemNet[ nAvaliado,1 ]+; //01 -> Codigo Avaliação.
	                           aMediaItemNet[ nAvaliado,2 ]+; //02 -> Codigo do Avaliado.
	                           aMediaItemNet[ nAvaliado,3 ]+; //03 -> Codigo do Projeto.
                               aMediaItemNet[ nAvaliado,4 ]+; //04 -> Periodo Inicial Avaliacao.
                               aMediaItemNet[ nAvaliado,6 ]+; //06 -> Competencia.
                               aMediaItemNet[ nAvaliado,7 ]+; //07 -> Item de Competencia.
                               aMediaItemNet[ nAvaliado,8 ]+; //08 -> Codigo da Rede.
                               aMediaItemNet[ nAvaliado,11]   //11 -> Tipo dao Avaliador. (1= Avaliador / 2 = Auto-Avaliação / 3 = Consenso)

	lNew := !RDD->(dbSeek(ckey))   		

	RDD->( RecLock("RDD",lNew) )

/*
       aadd(aMediaItemComp,{;
                           aVlrQuestao[nQuestao][02],; //-> Cod. Avaliação.                 ##(cAlsAux)->RD6_CODIGO
                           aVlrQuestao[nQuestao][03],; //-> Cod. Avaliado.                  ##(cAlsAux)->RDB_CODADO
                           aVlrQuestao[nQuestao][04],; //-> Cod. Projeto.                   ##(cAlsAux)->RDB_CODPRO
                           aVlrQuestao[nQuestao][06],; //-> Periodo Inicial Avaliacao.      ##(cAlsAux)->RDB_DTIAVA
                           aVlrQuestao[nQuestao][07],; //-> Periodo Final Avaliacao.        ##(cAlsAux)->RDB_DTFAVA
                           aVlrQuestao[nQuestao][08],; //-> Competencia.                    ##(cAlsAux)->RDB_CODCOM
                           aVlrQuestao[nQuestao][09],; //-> Item de Competencia.            ##(cAlsAux)->RDB_ITECOM
                           aVlrQuestao[nQuestao][10],; //-> Codigo da Rede.                 ##(cAlsAux)->RDB_CODNET
                           aVlrQuestao[nQuestao][12],; //-> Valor Calculado para a Questão. ##  nVlrQuestao
                           aVlrQuestao[nQuestao][13],; //-> Codigo Tip. Avaliacao.          ##(cAlsAux)->RD6_CODTIP
                           aVlrQuestao[nQuestao][14];  //-> Codigo Tip. Avaliador.          ##(cAlsAux)->RDB_TIPOAV
                           };
*/

	
	RDD->RDD_FILIAL		:= xFilial("RDD")
	RDD->RDD_CODAVA		:=        aMediaItemNet[nAvaliado,01]    //01 -> Codigo Avaliação.                                                      ##(cAlsAux)->RD6_CODIGO
	RDD->RDD_CODADO		:=        aMediaItemNet[nAvaliado,02]    //02 -> Codigo do Avaliado.                                                    ##(cAlsAux)->RDB_CODADO
	RDD->RDD_CODPRO		:=        aMediaItemNet[nAvaliado,03]    //03 -> Codigo do Projeto.                                                     ##(cAlsAux)->RDB_CODPRO
	RDD->RDD_DTIAVA     := SToD(  aMediaItemNet[nAvaliado,04])   //04 -> Periodo Inicial Avaliacao.                                             ##(cAlsAux)->RDB_DTIAVA
	RDD->RDD_DTFAVA		:= SToD(  aMediaItemNet[nAvaliado,05])   //05 -> Periodo Final Avaliacao.                                               ##(cAlsAux)->RDB_DTFAVA
	RDD->RDD_CODCOM		:=        aMediaItemNet[nAvaliado,06]    //06 -> Competencia.                                                           ##(cAlsAux)->RDB_CODCOM
	RDD->RDD_ITECOM 	:=        aMediaItemNet[nAvaliado,07]    //07 -> Item de Competencia.                                                   ##(cAlsAux)->RDB_ITECOM
	RDD->RDD_CODNET		:=        aMediaItemNet[nAvaliado,08]    //08 -> Codigo da Rede.                                                        ##(cAlsAux)->RDB_CODNET
	RDD->RDD_RESOBT		:= Round( aMediaItemNet[nAvaliado,09],2) //09 -> Valor da Media Calculada.                                              ##  nVlrQuestao
	RDD->RDD_CODTIP		:=        aMediaItemNet[nAvaliado,10]    //10 -> Codigo Tip. Avaliacao.                                                 ##(cAlsAux)->RD6_CODTIP
	RDD->RDD_TIPOAV		:=        aMediaItemNet[nAvaliado,11]    //11 -> Tipo dao Avaliador. (1= Avaliador / 2 = Auto-Avaliação / 3 = Consenso) ##(cAlsAux)->RDB_TIPOAV

	RDD->(MsUnlock())

Next nAvaliado

Return

/*----------+--------------------------+------------+-----------------------------+
 |fGravaRDB |  Salva Valor da Questao. | 14.01.2017 | Alexandre Alves - CERTISIGN |
 +----------+--------------------------+------------+-----------------------------+
*/
Static Function  fGravaRDB(oSelf)

Local nVlrQuestao 	:= 0 
Local cKey			:= ""

//-> RDB -> Itens Respostas de Avaliacöes.
//-> RDB_FILIAL + RDB_CODAVA + RDB_CODADO + RDB_CODPRO + RDB_CODDOR + DTOS(RDB_DTIAVA) + RDB_CODCOM + RDB_ITECOM + RDB_CODNET + RDB_CODQUE + RDB_TIPOAV + RDB_ID
RDB->(dbSetOrder(1))  

For  nVlrQuestao := 1 to Len( aVlrQuestao )	

    oSelf:IncRegua2( "Gravando Respostas Avaliação.: "+aVlrQuestao[nVlrQuestao,02]+" - "+aVlrQuestao[nVlrQuestao,11]+" ...aguarde." )
    If oSelf:lEnd 
       Break
    EndIf

     cKey := xFilial("RDB")+;                 //-> RDB_FILIAL
             aVlrQuestao[nVlrQuestao,02]+;    //-> RDB_CODAVA
             aVlrQuestao[nVlrQuestao,03]+;    //-> RDB_CODADO
             aVlrQuestao[nVlrQuestao,04]+;    //-> RDB_CODPRO
             aVlrQuestao[nVlrQuestao,05]+;    //-> RDB_CODDOR
             aVlrQuestao[nVlrQuestao,06]+;    //-> DTOS(RDB_DTIAVA)
             aVlrQuestao[nVlrQuestao,08]+;    //-> RDB_CODCOM
             aVlrQuestao[nVlrQuestao,09]+;    //-> RDB_ITECOM
             aVlrQuestao[nVlrQuestao,10]+;    //-> RDB_CODNET
             aVlrQuestao[nVlrQuestao,11]+;    //-> RDB_CODQUE
             aVlrQuestao[nVlrQuestao,14]      //-> RDB_TIPOAV
             
     If RDB->( dbSeek(cKey) ) .And.;
        RDB->(RDB_FILIAL+RDB_CODAVA+RDB_CODADO+RDB_CODPRO+RDB_CODDOR+DTOS(RDB_DTIAVA)+RDB_CODCOM+RDB_ITECOM+RDB_CODNET+RDB_CODQUE+RDB_TIPOAV) = cKey
     
                 RDB->( RecLock("RDB",.F.) )			  		
		         RDB->RDB_RESOBT	:= Round(aVlrQuestao[nVlrQuestao,12],2)	//12 -> Valor Calculado para a Questão.
		         RDB->( MsUnlock() )
	 EndIf

Next nVlrQuestao

Return

/*----------+------------------------+------------+-----------------------------+
 |fGravaRD6 | Salva Data de Calculo. | 14.01.2017 | Alexandre Alves - CERTISIGN |
 +----------+------------------------+------------+-----------------------------+
*/
Static Function  fGravaRD6(nRecRD6)

RD6->( dbGoTo( nRecRD6 ) )

If RD6->( RecNo() ) = nRecRD6
   RD6->( RecLock("RD6",.F.) )
   RD6->RD6_DTCALC	:= dDataBase
   RD6->(MsUnlock())   
EndIf

Return


/*----------+----------------------------+------------+-----------------------------+
 |APD01SX1  | Monta Perguntas da Rotina. | 14.01.2017 | Alexandre Alves - CERTISIGN |
 +----------+----------------------------+------------+-----------------------------+
*/
Static Function APD01SX1(cPerg)

Local aHelp		:= {}
Local aHelpE	:= {}
Local aHelpI	:= {}   

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³           Grupo  	Ordem 	Pergunta Portugues  Pergunta Espanhol       Pergunta Ingles         Variavel 	Tipo  	Tamanho Decimal Presel  GSC   	Valid       Var01      	Def01           DefSPA1        	DefEng1      	Cnt01           Var02  	Def02    		DefSpa2         DefEng2	   	Cnt02  		Var03 	Def03      			DefSpa3    			DefEng3  		Cnt03  	Var04  	Def04     	DefSpa4    	DefEng4  	Cnt04  	Var05  	Def05       DefSpa5		DefEng5   	Cnt05  	XF3  	GrgSxg  cPyme	aHelpPor	aHelpEng	aHelpSpa    cHelp            ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/
PutSX1(cPerg,"01","Avaliacao De ?"         ,"¿De Evaluacion ?"      ,"From evaluation ?"       ,"mv_ch1" ,"C" ,06     ,0      ,0    ,"G" ,""   ,"RD6",""   ,""     ,"mv_par01","","","","","","","","","","","","","","","","")

aHelp := {	"Avaliacao inicial para o processamento." }
aHelpE:= {	" " }
aHelpI:= {	" " }

PutSX1Help("P.CSAD0001.",aHelp,aHelpI,aHelpE)	 
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

PutSX1(cPerg,"02","Avaliacao Ate ?"        ,"¿Hasta Evaluacion ?"    ,"To evaluation ?"        ,"mv_ch2" ,"C" ,06     ,0      ,0    ,"G" ,""	,"RD6",""   ,""     ,"mv_par02","","","","","","","","","","","","","","","","")

aHelp := {	"Avaliação final para o processamento." }
aHelpE:= {	" " }
aHelpI:= {	" " }

PutSX1Help("P.CSAD0002.",aHelp,aHelpI,aHelpE)	 
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

PutSX1(cPerg,"03","Avaliado De ?"       ,"¿De Evaluado ?"    ,"From evaluated ?"    ,"mv_ch3" ,"C" ,06     ,0      ,0    ,"G" ,""   ,"RD0",""   ,""		,"mv_par03","","","","","","","","","","","","","","","","")

aHelp := {	"Avaliado inicial para o processamento." }
aHelpE:= {	" " }
aHelpI:= {	" " }

PutSX1Help("P.CSAD0003.",aHelp,aHelpI,aHelpE)	 
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

PutSX1(cPerg,"04","Avaliado Ate ?"      ,"¿Hasta Evaluado ?"  ,"To evaluated ?"      ,"mv_ch4" ,"C" ,06     ,0      ,0    ,"G" ,""   ,"RD0",""   ,""		,"mv_par04","","","","","","","","","","","","","","","","")

aHelp := {	"Avaliado final para o processamento." }
aHelpE:= {	" " }
aHelpI:= {	" " }

PutSX1Help("P.CSAD0004.",aHelp,aHelpI,aHelpE)	 
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

PutSX1(cPerg,"05"    ,"Log de Ocorrencias ?","¿Log de Ocurencias ?","Occurrence Log ?" ,"mv_ch5" ,"N"    ,01         ,0          ,0          ,"C"    ,""     ,""     ,""         ,""    ,"mv_par05","Sim"  ,"Si"     ,"Yes"      ,""     ,"Nao"  ,"No"       ,"Not"      ,"","","","","","","","","")

aHelp := {	"Deve gerar LOG de ocorrencias ?" }
aHelpE:= {	" " }
aHelpI:= {	" " }

PutSX1Help("P.CSAD0005.",aHelp,aHelpI,aHelpE)	 
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

PutSX1(cPerg   ,"06"   ,"Tipo Avaliacao ?" ,"¿Tipo de Evaluacion ?" ,"Evaluation Type ?" ,"mv_ch6" ,"N"    ,01         ,0          ,0          ,"C"    ,""     ,""     ,""         ,""    ,"mv_par06" ,"Somente Consenso"  ,"Unico Consenso"  ,"Consensus Only" ,""     ,"Sem Consenso"  ,"No hay Consenso" ,"No consensus"  ,"Ambas"  ,"Ambos"    ,"Both","","","","","","")

aHelp := {	"Processa apenas os tipos de avaliações" }
aHelpE:= {	" " }
aHelpI:= {	" " }

PutSX1Help("P.CSAD0006.",aHelp,aHelpI,aHelpE)	 
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

PutSX1(cPerg,"07","Dta. Inicio Aval. ?"  ,"¿Fecha Inicio Eval. ?","Start Date Eval. ?"   ,"mv_ch7" ,"D" ,08     ,0      ,0    ,"G" ,""   ,""   ,""   ,""	    ,"mv_par07",""    ,""      ,""      ,""   ,""    ,""      ,""      ,"","","","","","","","","")

aHelp := {	"Data de inicio das avaliações para filtro." }
aHelpE:= {	" " }
aHelpI:= {	" " }

PutSX1Help("P.CSAD0007.",aHelp,aHelpI,aHelpE)	 
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

PutSX1(cPerg,"08","Dta. Final Aval. ?"   ,"¿Fecha Fim Eval. ?"   ,"End Date Eval. ?"	    ,"mv_ch8" ,"D" ,08     ,0      ,0    ,"G" ,""   ,""   ,""   ,""     ,"mv_par08",""    ,""      ,""      ,""   ,""    ,""      ,""      ,"","","","","","","","","")

aHelp := {	"Data final das avaliações para filtro." }
aHelpE:= {	" " }
aHelpI:= {	" " }

PutSX1Help("P.CSAD0008.",aHelp,aHelpI,aHelpE)	 
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


Return

/*-------------+--------------------------------------------------+------------+-----------------------------+
 |fAPDAGeraLog |  Monta o LOG de Avaliações Enviadas / Retornadas | 14.01.2017 | Alexandre Alves - CERTISIGN |
 +-------------+--------------------------------------------------+------------+-----------------------------+
*/
Static Function  fAPDAGeraLog(cCodAval) 

Local nCountRet		:= 0
Local nCountNaoRet	:= 0 
Local cQuery        := ""
Local cAlsTrb       := GetNextAlias()

Local cAdo          := ""

aAdd(aLogTitle , space(5) + OemToAnsi("Avaliador                              Rede                              Dt Envio      Dt Retorno" ) )                                                   

//--123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//-- 999999 - -XXXXXXXX(Avaliado )XXXXXXXX 
//--     Avaliador                              Rede                              Dt Envio      Dt Retorno"
//--     999999-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  99 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 99/99/9999    99/99/9999 
//--                                            Total Geral ...                   9999          9999 

aAdd(aLog,OemToAnsi("Log de Ocorrências - Cálculo "))
aAdd(aLog, cCodAval  + space(2)  + fDesc( "RD6" ,cCodAval , "RD6_DESC" ) ) // RD6 -> Cabecalho Montagem Avaliacoes.
aAdd(aLog,  " ")
	 
//-> Verifica o retorno das Avaliacoes.
cQuery := "SELECT DISTINCT RDC_CODAVA "
cQuery += "               ,RDC_CODADO "
cQuery += "               ,(SELECT RD0_NOME "
cQuery += "                 FROM "+RetSqlName("RD0")+" "
cQuery += "                 WHERE D_E_L_E_T_ <> '*' "
cQuery += "                   AND RD0_CODIGO = RDC_CODADO ) NOMADO "
cQuery += "               ,RDC_DATRET "
cQuery += "               ,RDC_DATENV "
cQuery += "               ,RDC_CODDOR "
cQuery += "               ,(SELECT RD0_NOME "
cQuery += "                 FROM "+RetSqlName("RD0")+" "
cQuery += "                 WHERE D_E_L_E_T_ <> '*' "
cQuery += "                   AND RD0_CODIGO = RDC_CODDOR ) NOMDOR "
cQuery += "               ,RDC_CODNET "
cQuery += "               ,(SELECT RD1_DESC   "
cQuery += "                 FROM "+RetSqlName("RD1")+" "
cQuery += "                 WHERE D_E_L_E_T_ <> '*' "
cQuery += "                 AND RD1_CODIGO = RDC_CODNET ) NOMNET "
cQuery += "FROM "+RetSqlName("RDC")+" RDC "
cQuery += "WHERE RDC.D_E_L_E_T_ <> '*' AND RDC_CODAVA = '"+AllTRim(cCodAval)+"' "
cQuery += "ORDER BY RDC_CODAVA ,RDC_CODADO "
cQuery := ChangeQuery(cQuery)

TCQUERY cQuery NEW ALIAS (cAlsTrb)
                                   
   (cAlsTrb)->( DbGotop() )
If (cAlsTrb)->( !Eof()    )      

   While (cAlsTrb)->(!Eof())      
   
     If cAdo  # (cAlsTrb)->RDC_CODADO
        aAdd(aLog,(cAlsTrb)->RDC_CODADO + "-" + (cAlsTrb)->NOMADO)
        cAdo := (cAlsTrb)->RDC_CODADO
     Endif

     If (cAlsTrb)->( !empty(RDC_DATRET) )
         nCountRet++
     Endif

     If (cAlsTrb)->( !empty(RDC_DATENV) )
         nCountNaoRet++
     Endif

     aAdd(aLog,space(5) + (cAlsTrb)->RDC_CODDOR         + "-" +;
                          (cAlsTrb)->NOMDOR                   +;
                          (cAlsTrb)->RDC_CODNET         + "-" +;
                          (cAlsTrb)->NOMNET        + space(1) +;
              DTOC( SToD( (cAlsTrb)->RDC_DATENV ) )+ space(6) +;
              DTOC( SToD( (cAlsTrb)->RDC_DATRET ) ) )


     (cAlsTrb)->( dbSkip() )
   
   EndDo
   
   //--> Total Geral
   aAdd(aLog,  " ")
   aAdd(aLog, SPACE(35) + OemToAnsi("Total Geral Retornado...") +space(19)+ StrZero(nCountRet,4) + space(10)+  StrZero(nCountNaoRet,4)  )

EndIf

(cAlsTrb)->( dbCloseArea() )

Return
