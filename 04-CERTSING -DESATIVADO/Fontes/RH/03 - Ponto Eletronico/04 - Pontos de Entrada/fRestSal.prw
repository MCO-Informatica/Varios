#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"

#DEFINE          cEol         CHR(13)+CHR(10)
#DEFINE          cSep         ";"

/*
+---------------------+-----------------------------------+-----------------------+
|Funcao.: fRestSal    | Autor.: Alexandre Alves           | Data.: 06/06/2016     |
+---------------------+-----------------------------------+-----------------------+
|Descricao.: Restaura o Historico Salarial e Cadastro de Funcionarios, recuperando|
|            o ultimo registro de aumento salarial, quando um aumento é realizado |
|            indevidamente.                                                       |
+---------------------------------------------------------------------------------+
*/
User Function fRestSal()

Local bProcesso := {|oSelf| FixSal( oSelf )}

Private cCadastro  := "Restaurar Salarios Reajustados incorretamente."
Private cDescricao := "Restaurar Salarios Reajustados incorretamente"
Private aLog1      := {} //-> Dados processados para planilha com cenario anterior à restauração
Private aLog2      := {} //-> Dados processados para planilha com dados efetivos da restauração.


tNewProcess():New( "FixSal" , cCadastro , bProcesso , cDescricao , ,,,,,.T.,.F. ) 	

//-> Gera planilha para conferencia.
fPlanLOG()

Return

/*
+---------------------+-----------------------------------+-----------------------+
|Funcao.: FixSal      | Autor.: Alexandre Alves           | Data.: 06/06/2016     |
+---------------------+-----------------------------------+-----------------------+
|Descricao.: Função do processamento central.                                     |
+---------------------------------------------------------------------------------+
*/
Static Function FixSal(oSelf)

Local cQuery   := ""
Local cAlsMix  := GetNextAlias()
Local aRegHist := {}

cQuery := "SELECT R3_FILIAL                "+CRLF
cQuery += "     , R3_MAT                   "+CRLF
cQuery += "     , RA_NOME                  "+CRLF
cQuery += "     , R3_DATA                  "+CRLF
cQuery += "     , R3_VALOR                 "+CRLF
cQuery += "     , R3_ANTEAUM               "+CRLF
cQuery += "     , R3_SEQ                   "+CRLF
cQuery += "     , R3_TIPO                  "+CRLF
cQuery += "     , R3_PD                    "+CRLF
cQuery += "     , R3_DESCPD                "+CRLF
cQuery += "     , R7_FUNCAO                "+CRLF
cQuery += "     , R7_DESCFUN               "+CRLF
cQuery += "     , SR3.R_E_C_N_O_ AS R3_REC "+CRLF
cQuery += "     , SR7.R_E_C_N_O_ AS R7_REC "+CRLF
cQuery += "FROM PROTHEUS.SR3010 SR3        "+CRLF
cQuery += "INNER JOIN PROTHEUS.SR7010 SR7 ON R7_FILIAL = R3_FILIAL  "+CRLF              
cQuery += "                              AND R7_MAT    = R3_MAT     "+CRLF
cQuery += "                              AND R7_DATA   = R3_DATA    "+CRLF
cQuery += "                              AND R7_SEQ    = R3_SEQ     "+CRLF
cQuery += "                              AND R3_TIPO   = R7_TIPO    "+CRLF
cQuery += "INNER JOIN PROTHEUS.SRA010 SRA ON RA_FILIAL = R3_FILIAL  "+CRLF
cQuery += "                              AND RA_MAT    = R3_MAT     "+CRLF
cQuery += "WHERE SR3.D_E_L_E_T_ <> '*'                              "+CRLF
cQuery += "  AND SR7.D_E_L_E_T_ <> '*'                              "+CRLF
cQuery += "  AND SRA.D_E_L_E_T_ <> '*'                              "+CRLF
cQuery += "  AND R3_FILIAL = '07'                                   "+CRLF
cQuery += "ORDER BY R3_FILIAL, R3_MAT, R3_DATA DESC                 "+CRLF

cQuery := ChangeQuery(cQuery)
 
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlsMix)

(cAlsMix)->(dbGoTop())

oSelf:SetRegua1( (cAlsMix)->(RecCount()) )

While (cAlsMix)->(!Eof()) 

       oSelf:IncRegua1( "Processando restauração dos salarios..."+(cAlsMix)->(R3_FILIAL+" - "+R3_MAT+" - "+RA_NOME)+" .Aguarde.")
       If oSelf:lEnd 
          Break
       EndIf 
       
       If Empty(aLog1)
       
          AADD(aLog1,{"FILIAL",;
                      "MATRICULA",;
                      "NOME",;
                      "DT.AUMENTO",;
                      "VLR.CORRIGIDO",;
                      "VLR.ATERIOR",;
                      "SEQUENCIA",;
                      "TIPO",;
                      "VERBA",;
                      "DESCR.VERBA",;
                      "FUNCAO",;
                      "DESC. FUNCAO",;
                      "REGISTRO SR3",;
                      "REGISTRO SR7";
                   };
             )
       EndIf

       AADD(aLog1,{(cAlsMix)->R3_FILIAL,;
                   (cAlsMix)->R3_MAT,;
                   (cAlsMix)->RA_NOME,;
                   (cAlsMix)->R3_DATA,;
                   (cAlsMix)->R3_VALOR,;
                   (cAlsMix)->R3_ANTEAUM,;
                   (cAlsMix)->R3_SEQ,;
                   (cAlsMix)->R3_TIPO,;
                   (cAlsMix)->R3_PD,;
                   (cAlsMix)->R3_DESCPD,;
                   (cAlsMix)->R7_FUNCAO,;
                   (cAlsMix)->R7_DESCFUN,;
                   (cAlsMix)->R3_REC,;
                   (cAlsMix)->R7_REC;
                 })             
            
       If Empty(aRegHist)
       
          AADD(aRegHist,{(cAlsMix)->R3_FILIAL,;   //01
                         (cAlsMix)->R3_MAT,;      //02
                         (cAlsMix)->RA_NOME,;     //03
                         (cAlsMix)->R3_DATA,;     //04
                         (cAlsMix)->R3_VALOR,;    //05
                         (cAlsMix)->R3_ANTEAUM,;  //06
                         (cAlsMix)->R3_SEQ,;      //07
                         (cAlsMix)->R3_TIPO,;     //08
                         (cAlsMix)->R3_PD,;       //09
                         (cAlsMix)->R3_DESCPD,;   //10
                         (cAlsMix)->R7_FUNCAO,;   //11
                         (cAlsMix)->R7_DESCFUN,;  //12
                         (cAlsMix)->R3_REC,;      //13
                         (cAlsMix)->R7_REC;      //14
	                    };
	          )
       
       Else   
       
          //-> Se o array estiver carregado e eu não encontro o funcionario, significa que já mudou a matricla.
          //-> Nesse caso eu faço o tratamento dos salarios do colaborador anteriormente armazenado.
          If (AsCan(aRegHist,{|x| x[1]+x[2] == (cAlsMix)->(R3_FILIAL + R3_MAT)} )) = 0
          
             fProcRest( aRegHist ) //-> Faz todo o tratamento de restauração dos salarios n SRA, SR3 e SR7.
             
             aRegHist := {}        //-> Zera o array para armazenar o proximo funcionario.
          EndIf
          
          AADD(aRegHist,{(cAlsMix)->R3_FILIAL,;   //01
                         (cAlsMix)->R3_MAT,;      //02
                         (cAlsMix)->RA_NOME,;     //03
                         (cAlsMix)->R3_DATA,;     //04
                         (cAlsMix)->R3_VALOR,;    //05
                         (cAlsMix)->R3_ANTEAUM,;  //06
                         (cAlsMix)->R3_SEQ,;      //07
                         (cAlsMix)->R3_TIPO,;     //08
                         (cAlsMix)->R3_PD,;       //09
                         (cAlsMix)->R3_DESCPD,;   //10
                         (cAlsMix)->R7_FUNCAO,;   //11
                         (cAlsMix)->R7_DESCFUN,;  //12
                         (cAlsMix)->R3_REC,;      //13
                         (cAlsMix)->R7_REC;      //14
	                    };
	          )

       EndIf
       
       (cAlsMix)->( dbSkip() ) 
EndDo

Return

/*
+--------------------+-----------------------------------+-----------------------+
|Funcao.: fPlanLOG   | Autor.: Alexandre Alves           | Data.: 06/06/2016     |
+--------------------+-----------------------------------+-----------------------+
|Descricao.: Funcao auxiliar para geracao de planilha de conferencia do calculo. |
+--------------------------------------------------------------------------------+
*/
Static Function fPlanLOG()

Local lSetCentury := __SetCentury( "on" )
Local cPath       := AllTrim( GetTempPath() )
Local nTotReg     := 0
Local cNomArq1    := ""
Local cNomArq2    := ""

Local cLin1
Local cLin2
Local nPos, nX, nY

Local lErrInc   := .F.
Local lErrExc   := .F.

Private nHdl1
Private nHdl2

cNomArq1  := CriaTrab(,.F.) + ".CSV"
cNomArq2  := CriaTrab(,.F.) + ".CSV"

// Cria Arquivo Texto
cPath    := cPath + If(Right(cPath,1) <> "\","\","")
cNomArq1 := cPath + cNomArq1
cNomArq2 := cPath + cNomArq2

nHdl1     := fCreate( cNomArq1 )
nHdl2     := fCreate( cNomArq2 )

If nHdl1 == -1
   MsgAlert("O arquivo de nome "+cNomArq1+" nao pode ser executado! Verifique os parametros.","Atencao!")
   Return
EndIf

If nHdl2 == -1
   MsgAlert("O arquivo de nome "+cNomArq2+" nao pode ser executado! Verifique os parametros.","Atencao!")
   Return
EndIf

//---------------------------------------------------------------------------------

//-> Gravando Cabecalho Log1.
For nX := 1 To Len(aLog1[1])
    If nX = 1
       cLin1 := aLog1[1][nX] + cSep
    Else
       cLin1 += aLog1[1][nX] + cSep
    EndIf
Next 
cLin1 += cEol

If fWrite(nHdl1,cLin1,Len(cLin1)) != Len(cLin1)
   If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
      Return
   Endif
Endif

//---------------------------------------------------------------------------------

//-> Gravando Cabecalho Log2.
For nX := 1 To Len(aLog2[1])
    If nX = 1
       cLin2 := aLog2[1][nX] + cSep
    Else
       cLin2 += aLog2[1][nX] + cSep
    EndIf
Next 
cLin2 += cEol

If fWrite(nHdl2,cLin2,Len(cLin2)) != Len(cLin2)
   If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
      Return
   Endif
Endif

//---------------------------------------------------------------------------------

//-> Gravando Dados do Log1.
For nX := 2 To Len(aLog1)

    For nY := 1 To Len(aLog1[nX])
        If nY = 1
           cLin1 := If( ValType( aLog1[nX][nY] ) = "N", AllTrim( Str(aLog1[nX][nY]) ), aLog1[nX][nY] ) + cSep
        Else 
           cLin1 += If( ValType( aLog1[nX][nY] ) = "N", AllTrim( Str(aLog1[nX][nY]) ), aLog1[nX][nY] ) + cSep
        EndIf
    Next nY
    cLin1 += cEol
    
    If fWrite(nHdl1,cLin1,Len(cLin1)) != Len(cLin1)
       If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
          Return
       Endif
    Endif

Next nX

//---------------------------------------------------------------------------------

//-> Gravando Dados do Log2.
For nX := 2 To Len(aLog2)

    For nY := 1 To Len(aLog2[nX])
        If nY = 1
           cLin2 := If( ValType( aLog2[nX][nY] ) = "N", AllTrim( Str(aLog2[nX][nY]) ), aLog2[nX][nY] ) + cSep
        ElseIf nY <> 1 .And. ValType( aLog2[nX][nY] ) = "N"
           cLin2 += AllTrim( Str(aLog2[nX][nY]) ) + cSep
        ElseIf nY <> 1 .And. ValType( aLog2[nX][nY] ) = "D"
           cLin2 += AllTrim( DToC(aLog2[nX][nY]) ) + cSep
        Else
           cLin2 += aLog2[nX][nY] + cSep
        EndIf
    Next nY
    cLin2 += cEol
    
    If fWrite(nHdl2,cLin2,Len(cLin2)) != Len(cLin2)
       If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
          Return
       Endif
    Endif

Next nX

//--------------------------------------------------------------------------------- 

If !lSetCentury
    __SetCentury( "off" )
EndIf

fClose( nHdl1 )
fClose( nHdl2 )

// Integra Planilha 1 ao Excel
MsAguarde( {|| fStartExcel( cNomArq1 )}, "Aguarde...", "Integrando Planilha ao Excel..." )

// Integra Planilha 2 ao Excel
MsAguarde( {|| fStartExcel( cNomArq2 )}, "Aguarde...", "Integrando Planilha ao Excel..." )

Return

/*
+---------------------+-----------------------------------+-----------------------+
|Funcao.: fStartExcel | Autor.: Alexandre Alves           | Data.: 06/06/2016     |
+---------------------+-----------------------------------+-----------------------+
|Descricao.: Integra os dados gerados com uma planilha no Excel.                  |
+---------------------------------------------------------------------------------+
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
+---------------------+-----------------------------------+-----------------------+
|Funcao.: fStartExcel | Autor.: Alexandre Alves           | Data.: 06/06/2016     |
+---------------------+-----------------------------------+-----------------------+
|Descricao.: Integra os dados gerados com uma planilha no Excel.                  |
+---------------------------------------------------------------------------------+
*/
Static Function fProcRest( aHist )

Local nPosVar := 0

//-> Vrifica se o colaborador possui aumento por Antecipação do Dissidio (009) e se possui outros aumentos predecessores.
If (nPosVar := AScan(aHist,{|x| x[08] = '009' .And. aHist[nPosVar][04] >= '20180101' .And. aHist[nPosVar][04] <= '20181231'  } )) > 0 

   If aHist[nPosVar][04] >= '20180101' .And. aHist[nPosVar][04] <= '20181231' .And. nPosVar < Len(aHist) 

      nPosVar ++ //-> Avança uma posição para o aumento anterior ao dissidio.

      //-> Atualizando o Cadastro de Funcionarios.
      If SRA->( dbSeek( aHist[nPosVar][01] + aHist[nPosVar][02] ) )

         SRA->( RecLock("SRA",.F.) )
         SRA->RA_SALARIO    := aHist[nPosVar][05]
         SRA->RA_ANTEAUM    := aHist[nPosVar][06]
         SRA->( MsUnLock() )
                             
         //-> Gerando Log para planilha dos "restaurados".             
         If Empty(aLog2)
            AADD(aLog2,{"Filial",;
                        "Matricula",;
                        "Nome",;
                        "Salario Epoca",;
                        "Salario Antes Epoca",;
                        "Data Epoca)";
                       };
                )
         EndIf

         AADD(aLog2,{aHist[nPosVar][01],; //-> Filial;
                     aHist[nPosVar][02],; //-> Matricula;
                     aHist[nPosVar][03],; //-> Nome;
                     aHist[nPosVar][05],; //-> Salario da Epoca;
                     aHist[nPosVar][06],; //-> Salario anterior ao aumento da epoca;
                     aHist[nPosVar][04];  //-> Data (epoca).
                     };
             )


         nPosVar := (nPosVar -1) //-> Volta uma posição para o aumento referente ao dissidio.
   
         //-> Excluindo Historico do Reajuste Salarial.	               
            SR3->( dbGoTo(aHist[nPosVar][13]) )
         If SR3->( RecNo() ) == aHist[nPosVar][13]

            SR3->( RecLock("SR3",.F.) )
            SR3->( dbDelete() )
            SR3->( MsUnLock() )
   
         EndIf


            SR7->( dbGoTo(aHist[nPosVar][14]) )
         If SR7->( RecNo() ) == aHist[nPosVar][14]

            SR7->( RecLock("SR7",.F.) )
            SR7->( dbDelete() )
            SR7->( MsUnLock() )
   
         EndIf

      EndIf
   EndIf
EndIf

Return()
