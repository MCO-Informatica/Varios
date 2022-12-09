#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

#DEFINE          cSep         ";"
#DEFINE          cEol         CHR(13)+CHR(10)

//-------------------------------------------------------------------------------------------------------------------------------------------------------------
/*/{Protheus.doc} FIXPON6.prw
Executa  arestauração dos abonos na SPC, que foram excluidos por falha nas rotinas do portal.

@Return Null
@author Alexandre Alves
@since 28/03/2017
@version 1.0
/*/
//-------------------------------------------------------------------------------------------------------------------------------------------------------------
User Function FIXPON6()

Local bProcesso := {|oSelf| fFix06( oSelf ) }
Local cTitulo   := "Restaura Abonos" 
Local cObjetiv  := "Restaura Abonos Excluidos da SPC."
                                                                
tNewProcess():New( "FIXPON6", cTitulo, bProcesso, cObjetiv,,,,,,.T.,.F. )

Return

//-------------------------------------------------------------------------------------------------------------------------------------------------------------
/*/{Protheus.doc} fFix06
Processamento central.

@Return Null
@author Alexandre Alves
@since 28/03/2017
@version 1.0
/*/
//-------------------------------------------------------------------------------------------------------------------------------------------------------------
Static Function fFix06( oSelf )


Local nX        := 0
Local aRet      := {}
Local cQuery    := ""
Local cTrbFile  := GetNextAlias()
Local aParamBox := {}    
Local cMVPONMES := cPeriodo := replace(GetMv("MV_PONMES"), "/", "")
Local dDtInAtu  := CToD( Substr(cMVPONMES,07,02) + "/" + Substr(cMVPONMES,05,02) + "/" + Substr(cMVPONMES,01,04) )
Local dDtFmAtu  := CToD( Substr(cMVPONMES,15,02) + "/" + Substr(cMVPONMES,13,02) + "/" + Substr(cMVPONMES,09,04) )
Local cMsgFech  := ""
Local lPrcFech  := .F.
Local cPCChave  := " "
Local aFunProc  := {}

cMsgFech  := "O periodo em aberto no momento e: "
cMsgFech  += AllTrim( DToC(dDtInAtu) )
cMsgFech  += " a "
cMsgFech  += AllTrim( DToC(dDtFmAtu) )
cMsgFech  += ". Nao sera possivel fechar o periodo ou periodos superiores. Verifique."


//              1 - MsGet  [2] : Descrição  [3]    : String contendo o inicializador do campo  [4] : String contendo a Picture do campo  [5] : String contendo a validação  [6] : Consulta F3  [7] : String contendo a validação When   [8] : Tamanho do MsGet   [9] : Flag .T./.F. Parâmetro Obrigatório ? 
aAdd(aParamBox,{1              ,"Periodo Inicial"  ,CToD("  /  /    ")                             ,""                                       ,"NaoVazio()"                      ,""                ,""                                      ,8                       ,.T.}) // Periodo Inicial
aAdd(aParamBox,{1              ,"Periodo Final"    ,CToD("  /  /    ")                             ,""                                       ,"NaoVazio()"                      ,""                ,""                                      ,8                       ,.T.}) // Periodo Final

If Parambox(aParambox,"Parametros de Processamento",@aRet)     

//   If aRet[1] >= dDtInAtu
//      Aviso("ATENACAO!!",cMsgFech,{"Ok"})
//      lPrcFech  := .F.
//   Else
   
      cQuery := "SELECT  PK_FILIAL                      "+CRLF
      cQuery += "       ,PK_MAT                         "+CRLF
      cQuery += "       ,PK_DATA                        "+CRLF
      cQuery += "       ,PK_CODEVE                      "+CRLF
      cQuery += "       ,PK_CODABO                      "+CRLF
      cQuery += "       ,PK_HRSABO                      "+CRLF
      cQuery += "       ,SPK.D_E_L_E_T_ AS PK_DELETE    "+CRLF
      cQuery += "       ,SPK.R_E_C_N_O_ AS PK_RECNO     "+CRLF
      cQuery += "       ,PC_DATA                        "+CRLF
      cQuery += "       ,PC_PD                          "+CRLF
      cQuery += "       ,PC_QUANTC                      "+CRLF
      cQuery += "       ,PC_ABONO                       "+CRLF
      cQuery += "       ,PC_QTABONO                     "+CRLF
      cQuery += "       ,PC_DELETE                      "+CRLF
      cQuery += "       ,PC_RECNO                       "+CRLF
      cQuery += "FROM PROTHEUS.SPK010 SPK               "+CRLF
      cQuery += "INNER JOIN (SELECT PC_FILIAL           "+CRLF
      cQuery += "                  ,PC_MAT              "+CRLF
      cQuery += "                  ,PC_DATA             "+CRLF
      cQuery += "                  ,PC_PD               "+CRLF
      cQuery += "                  ,PC_QUANTC           "+CRLF
      cQuery += "                  ,PC_ABONO            "+CRLF
      cQuery += "                  ,PC_QTABONO          "+CRLF
      cQuery += "                  ,SPC.D_E_L_E_T_ AS PC_DELETE "+CRLF
      cQuery += "                  ,SPC.R_E_C_N_O_ AS PC_RECNO  "+CRLF
      cQuery += "            FROM PROTHEUS.SPC010 SPC           "+CRLF
      cQuery += "            ) SPCX ON SPCX.PC_FILIAL = PK_FILIAL AND SPCX.PC_MAT = PK_MAT AND SPCX.PC_DATA = PK_DATA AND SPCX.PC_PD = PK_CODEVE "+CRLF
      cQuery += "WHERE PK_DATA BETWEEN '"+DToS(aRet[1])+"' AND '"+DToS(aRet[2])+"' "+CRLF
      cQuery += "  AND (PC_ABONO = ' ' OR PC_ABONO <> PK_CODABO) "+CRLF
      cQuery += "ORDER BY PK_FILIAL, PK_MAT, PK_DATA, PK_CODEVE, SPK.R_E_C_N_O_ "+CRLF
      cQuery := ChangeQuery( cQuery )

      dbUseArea(.T., "TopConn", TCGenQry( NIL, NIL, cQuery), cTrbFile, .F., .T.)

      (cTrbFile)->(dbGoTop())
      
      lPrcFech  := (cTrbFile)->(!EOF())

//   EndIf

EndIf

If lPrcFech

    cPCChave  := ""

    oSelf:SetRegua1( (cTrbFile)->( RecCount() ) )

    While (cTrbFile)->( !Eof() )  

          oSelf:IncRegua1( "Processando Registro.: "+(cTrbFile)->(PK_FILIAL+" - "+PK_MAT+" - "+PK_DATA)+" ...aguarde." )
       If oSelf:lEnd 
          Break
       EndIf
       
          SPC->( dbGoto( (cTrbFile)->PC_RECNO )) //-> Posiciona o registro na SPC.
       If SPC->( RecNo() ) = (cTrbFile)->PC_RECNO
       
          If !Empty(cPCChave) .And. cPCChave <> SPC->(PC_FILIAL + PC_MAT + DToS(PC_DATA) + PC_PD) //-> Checa a mudança de chave.
          
             If AScan( aFunProc,{|X| X[2] = ' '} ) = 0 //-> Se verdadeiro, todos os registros da SPC estão deletados.
             
                   aSort( aFunProc,,,{ |x,y| x[3] > y[3] } )
             
                   //-> Realiza o recall do ultimo registro deletado na SPC.
                   SPC->( dbGoto( aFunProc[Len(aFunProc)][3])     )
                If SPC->( RecNo() ) = aFunProc[Len(aFunProc)][3]
                   
                   SPC->( RecLock("SPC",.F.) )
                   
                   SPC->PC_ABONO   := If( SPC->PC_ABONO <> (cTrbFile)->PK_CODABO, (cTrbFile)->PK_CODABO,  SPC->PC_ABONO)
                   
                   SPC->( DBRecall()         )
                   SPC->( MsUnLock()         )
                EndIf
             EndIf
             aFunProc := {}
          EndIf
          
          //-> Atualzia o array para avaliar possivel recall.
          AADD(aFunProc,{ (cTrbFile)->(PK_FILIAL+PK_MAT+PK_DATA+PK_CODEVE),;
                          (cTrbFile)->PC_DELETE,;
                          (cTrbFile)->PC_RECNO;
                        } )
          
          cPCChave  := (cTrbFile)->(PK_FILIAL + PK_MAT + PK_DATA + PK_CODEVE) //-> Refresh the key.
          
          fAtSPC( (cTrbFile)->PC_RECNO, (cTrbFile)->PK_CODABO, (cTrbFile)->PK_HRSABO ) //-> Atualiza os campos Abono e Qtd. de Horas Abonadas na SPC.

       EndIf
       
       (cTrbFile)->( dbSkip() )
       
    EndDo
    
EndIf

//-> Ajusta o ultimo funcionario lido.
If AScan( aFunProc,{|X| X[2] = ' '} ) = 0 //-> Se verdadeiro, todos os registros da SPC estão deletados.
             
   aSort( aFunProc,,,{ |x,y| x[3] > y[3] } )
             
   //-> Realiza o recall do ultimo registro deletado na SPC.
      SPC->( dbGoto( aFunProc[Len(aFunProc)][3])     )
   If SPC->( RecNo() ) = aFunProc[Len(aFunProc)][3]
                   
      SPC->( RecLock("SPC",.F.) )
                   
      SPC->PC_ABONO   := If( SPC->PC_ABONO <> (cTrbFile)->PK_CODABO, (cTrbFile)->PK_CODABO,  SPC->PC_ABONO)
                   
      SPC->( DBRecall()         )
      SPC->( MsUnLock()         )
   EndIf
EndIf


(cTrbFile)->(dbCloseArea())

Return()


//-------------------------------------------------------------------------------------------------------------------------------------------------------------
/*/{Protheus.doc} fFix06
Processamento central.

@Return Null
@author Alexandre Alves
@since 28/03/2017
@version 1.0
/*/
//-------------------------------------------------------------------------------------------------------------------------------------------------------------
Static Function fAtSPC(nREC, cCodAbo, nHrsAbo)

Local nX       := 0
Local cTime    := ""
Local cNumero  := "0*1*2*3*4*5*6*7*8*9"
Local cAux     := Time()

For nX := 1 To Len(cAux)
    If Subs(cAux,nX,1)$cNumero
       cTime += Subs(cAux,nX,1)
    EndIf
Next nX


   SPC->( dbGoto( nREC ))
If SPC->( RecNo() ) = nREC

   SPC->( RecLock("SPC",.F.) )
   SPC->PC_ABONO   := cCodAbo
   SPC->PC_QTABONO := nHrsAbo
   SPC->PC_DATAALT := Date()
   SPC->PC_HORAALT := cTime
   SPC->PC_USUARIO := '000000'
   SPC->( MsunLock() )

EndIf

Return
