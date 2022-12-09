#include "TBICONN.CH"
#include "PROTHEUS.CH"
#include "TOPCONN.CH"

#define dDataCorte CTOD("01/05/2019")

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RFINJ01  บAutor  ณ Montes             บ Data ณ 10/05/2019  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina para exporta็ใo e atualiza็ใo do sistema GESTOQ/BV  บฑฑ
ฑฑบ          ณ com base no flag de exporta็ใo.                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Glasstech                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RFINJ01(aParam)

Private lJob       := aParam <> NIl        

If lJob
   PREPARE ENVIRONMENT EMPRESA aParam[1] FILIAL aParam[2] TABLES "SA1" , "SD2" , "SF2" , "SF3" , "SF4" , "SFI"
EndIf

If !lJob
   Processa( { || ExpCR() }, 'Atualizando Contas a Receber' )
   Processa( { || ExpCP() }, 'Atualizando Contas a Receber' )
   Processa( { || ExpMB() }, 'Atualizando Movimento Bancaria' )
Else
   ExpCR() // 'Atualizando Contas a Receber' 
   ExpCP() // 'Atualizando Contas a Receber'
   ExpMB() // 'Atualizando Movimento Bancaria'
EndIf

If lJob
   Reset Environment 
EndIf

Return Nil

/*
  
EXPORTA REGISTROS DA TABELA DO CONTAS A RECEBER (SE1)

*/
Static Function ExpCR()

Local cQuery := ""

If !lJob 
   ProcRegua( 2 )
EndIf

If !lJob 
   IncProc('Excluindo registros do Contas a Receber...')
EndIf

cQuery := "SELECT E1_TIPO,E1_FILIAL,E1_IDBOLET,E1_ORIGBD,E1_NUM,E1_PARCELA,E1_NOMCLI,SE1.R_E_C_N_O_ RECSE1 "
cQuery += "FROM "+RetSqlName("SE1")+" SE1 "
cQuery += "WHERE E1_FILIAL >= '  ' "
cQuery += "AND E1_EMISSAO >= '"+DTOS(dDataCorte)+"' "
cQuery += "AND E1_IDBOLET <> 0 " //Somente titulos integrados com GESTOQ
cQuery += "AND E1_MSEXP = ' ' "
cQuery += "AND D_E_L_E_T_ = '*' " //Deletados

TCQUERY cQuery ALIAS "QRYSE1" 

dbSelectArea("QRYSE1")
dbGoTop()

While QRYSE1->(!EOF())
    
    If ( QRYSE1->E1_TIPO = 'RA ' ) .Or. ( QRYSE1->E1_TIPO = 'PRE' )

	   _aResult := TCSPExec('FA040Del', 'A', QRYSE1->E1_FILIAL , QRYSE1->E1_IDBOLET, QRYSE1->E1_ORIGBD )
	   
	   If Type( '_aResult' ) = 'A'

	      If _aResult[1] <> ' ' .And. !lJob
             MsgInfo('Nใo conformidade ao excluir o Titulo ' + rTrim( QRYSE1->E1_NUM ) + '/' +QRYSE1->E1_PARCELA + ' ' + rTrim( QRYSE1->E1_NOMCLI ) + '.' + chr(13) + _aResult[1], 'Rotina fa040del' )
          
          Else
              cQuery := "UPDATE "+RetSqlName("SE1")+" SET E1_MSEXP = '"+DTOS(DATE())+"' WHERE R_E_C_N_O_ = "+STR(QRYSE1->RECSE1)+";"
              TCSqlExec(cQuery)          
          EndIf
	   
	   EndIf
	
	EndIf
	
	             
	QRYSE1->(dbSkip())
EndDo

dbSelectArea("QRYSE1")
dbCloseArea()                                                 

If !lJob 
   IncProc('Exporta็ใo altera็ใo registros do Contas a Receber...')
EndIf

cQuery := "SELECT SE1.R_E_C_N_O_ RECSE1 "
cQuery += "FROM "+RetSqlName("SE1")+" SE1 "
cQuery += "WHERE E1_FILIAL >= '  ' "
cQuery += "AND E1_EMISSAO >= '"+DTOS(dDataCorte)+"' "
cQuery += "AND E1_IDBOLET <> 0 " //Somente titulos integrados com GESTOQ
cQuery += "AND E1_MSEXP = ' ' "
cQuery += "AND D_E_L_E_T_ = ' ' " //Nใo Deletados

TCQUERY cQuery ALIAS "QRYSE1" 

dbSelectArea("QRYSE1")
dbGoTop()

While QRYSE1->(!EOF())

   SE1->(dbGoTo(QRYSE1->RECSE1))
    
   If ! ( SE1->E1_TIPO = 'RA ' .Or. SE1->E1_TIPO = 'PRE' .Or. SE1->E1_TIPO = 'NCC' )       
   
      _nResult := TCSPExec("f04_50Alt"     ,;
	                     SE1->E1_IDBOLET,;
	                     SE1->E1_VALOR  ,;
	                     SE1->E1_VENCREA,;
	                     SE1->E1_DECRESC,;
	                     SE1->E1_ACRESC ,;
	                     SE1->E1_ORIGBD  ;
                       )
   EndIf
	             
   QRYSE1->(dbSkip())
EndDo

Return Nil

/*
  
EXPORTA REGISTROS DA TABELA DO CONTAS A PAGAR (SE2)

*/
Static Function ExpCP()

Local cQuery := ""

If !lJob 
   ProcRegua( 2 )
EndIf

If !lJob 
   IncProc('Excluindo registros do Contas a Pagar...')
EndIf

cQuery := "SELECT E2_TIPO,E2_FILIAL,E2_IDBOLET,E2_ORIGBD,E2_NUM,E2_PARCELA,E2_NOMCLI,SE2.R_E_C_N_O_ RECSE2 "
cQuery += "FROM "+RetSqlName("SE2")+" SE2 "
cQuery += "WHERE E2_FILIAL >= '  ' "
cQuery += "AND E2_EMISSAO >= '"+DTOS(dDataCorte)+"' "
cQuery += "AND E2_IDBOLET <> 0 " //Somente titulos integrados com GESTOQ
cQuery += "AND E2_MSEXP = ' ' "
cQuery += "AND D_E_L_E_T_ = '*' " //Deletados

TCQUERY cQuery ALIAS "QRYSE2" 

dbSelectArea("QRYSE2")
dbGoTop()

While QRYSE2->(!EOF())
    
    //Verificar procedure para exclusใo de titulos do contas a pagar no GESTOQ	
	             
	QRYSE1->(dbSkip())
EndDo

dbSelectArea("QRYSE2")
dbCloseArea()                                                 

If !lJob 
   IncProc('Exporta็ใo altera็ใo registros do Contas a Pagar...')
EndIf

cQuery := "SELECT SE2.R_E_C_N_O_ RECSE2 "
cQuery += "FROM "+RetSqlName("SE2")+" SE2 "
cQuery += "WHERE E2_FILIAL >= '  ' "
cQuery += "AND E2_EMISSAO >= '"+DTOS(dDataCorte)+"' "
//cQuery += "AND E2_IDBOLET <> 0 " //Somente titulos integrados com GESTOQ
cQuery += "AND E2_MSEXP = ' ' "
cQuery += "AND SE2.D_E_L_E_T_ = ' ' " //Nใo Deletados

TCQUERY cQuery ALIAS "QRYSE2" 

dbSelectArea("QRYSE2")
dbGoTop()

While QRYSE2->(!EOF())

   SE2->(dbGoTo(QRYSE2->RECSE2))

   If ! ( SE2->E2_TIPO = 'PA ' .Or. SE2->E2_TIPO = 'NDF' )       
   
      If E2_IDBOLET = 0
      
         U_FA050FIN()
   
      Else
    
         _nResult := TCSPExec("f04_50Alt"     ,;
	                     SE2->E2_IDBOLET,;
	                     SE2->E2_VALOR  ,;
	                     SE2->E2_VENCREA,;
	                     SE2->E2_DECRESC,;
	                     SE2->E2_ACRESC ,;
	                     SE2->E2_ORIGBD  ;
                       )
      EndIf
   EndIf
   	             
   QRYSE2->(dbSkip())
EndDo

Return Nil

/*
  
EXPORTA REGISTROS DA TABELA DE MOVIMENTO BANCARIO (SE5)

*/
Static Function ExpMB()

Local cQuery := ""
LOCAL _nPos      := 0
LOCAL _nRecSE1   := SE1->( RecNo() )
LOCAL _nRecSE5   := SE5->( RecNo() )
LOCAL _nIdxSE1   := SE5->( IndexOrd() )
LOCAL _nIdVctTit := 0
LOCAL _nIdAdto   := 0
LOCAL _cTitPai   := ''

//LOCAL _aRecNo    := aBaixaSE5
//LOCAL _nRecNo    := Len( aTitulos )

If !lJob 
   ProcRegua( 2 )
EndIf

If !lJob 
   IncProc('Processamento Movimento Bancario...')
EndIf

cQuery := "SELECT SE5.R_E_C_N_O_ RECSE5 "
cQuery += "FROM "+RetSqlName("SE5")+" SE5 "
cQuery += "WHERE E5_FILIAL >= '  ' "
cQuery += "AND E5_DATA >= '"+DTOS(dDataCorte)+"' "
//cQuery += "AND E2_IDBOLET <> 0 " //Somente titulos integrados com GESTOQ
cQuery += "AND E5_MSEXP = ' ' "
cQuery += "AND SE5.D_E_L_E_T_ = ' ' " //Nใo Deletados

TCQUERY cQuery ALIAS "QRYSE5" 

dbSelectArea("QRYSE5")
dbGoTop()

While QRYSE5->(!EOF())

   SE5->(dbGoTo(QRYSE5->RECSE5))
   

   If SE5->E5_RECPAG = "R"
      

      _nRecSE5   := SE5->( RecNo() )
      _nRecSE1   := SE1->( RecNo() )
    
      _cTitPai := SE5->E5_FILIAL
      _cTitPai += SE5->E5_CLIFOR
      _cTitPai += SE5->E5_LOJA
      _cTitPai += Substr( SE5->E5_DOCUMEN, 1, nTamTit + nTamTip )

      SE1->( dbSetOrder( 2 ) )
      SE1->( dbSeek( _cTitPai, .F. ) )
      SA6->( dbSeek( xFilial( 'SA6' ) + SE1->E1_PORTADO + SE1->E1_AGEDEP + SE1->E1_CONTA , .F. ) )
      _nIdAdto := int( SE1->E1_IDBOLET )
	  SE1->( dbGoTo( _nRecSE1 ) )
	
      If (SE5->E5_MOTBX   = 'CMP') .And.;
          (SE5->E5_TIPODOC = 'CP')  .And.;
          ! ('NCC' $ SE5->E5_DOCUMEN)

          _nIdVctTit := SE1->E1_IDBOLET

		  _nResult := TCSPExec("f300SE5Adt",;
		                     SA6->A6_IDCONTA,;
		                     Val(SE5->E5_CLIFOR),;
		                     SE5->E5_DTDISPO, ;
		                     SE5->E5_VALOR,;
		                     'Compensacao ' + rTrim( SE5->E5_NUMERO ) + '/' +SE5->E5_PARCELA + ' ' +rTrim( SE5->E5_BENEF ),;
		                     cUserName,;
		                     SE5->E5_NUMERO + SE5->E5_PARCELA,;
		                     'D',;
		                     SE5->E5_FILORIG,;
		                     'C',;
						     _nIdAdto,;
						     _nIdVctTit,;
				             SE1->E1_ORIGBD;
	                        )
	
	      If ValType( _nResult ) = 'A'
	
	         RecLock( 'SE5', .F. )
	         SE5->E5_IDMOVI := Str( _nResult[ 1 ], 10, 0 )
	         SE5->E5_MSEXP  := DTOS(DATE())
	         SE5->( MSUnLock() )       
	
	      EndIf	     
           
      ElseIf (SE5->E5_MOTBX   = 'CMP') .And.;
             (SE5->E5_TIPODOC = 'CP')  .And.;
             ('NCC' $ SE5->E5_DOCUMEN)

	      _cData := DtoS( SE5->E5_DATA )
	      _cDta  := Substr( _cData, 1, 4 ) 
	      _cDta  += '-'
	      _cDta  += Substr( _cData, 5, 2 )
	      _cDta  += '-'
	      _cDta  += Substr( _cData, 7, 2 )
    
          _cData := DtoS( SE5->E5_DTDIGIT )
          _cMvt  := Substr( _cData, 1, 4 ) 
          _cMvt  += '-'
          _cMvt  += Substr( _cData, 5, 2 )
          _cMvt  += '-'
          _cMvt  += Substr( _cData, 7, 2 )  

	      _nResult := TCSPExec("f300SE5",;
	                       SE1->E1_IDBOLET       ,;
	                       22                    ,;
	                       _cDta                 ,;
	                       Val( SE5->E5_NUMCHEQ ),;
	                       rTrim( SE5->E5_NUMERO ) + '/' +SE5->E5_PARCELA + ' ' +rTrim( SE5->E5_BENEF ),;
	                       SE5->E5_VLJUROS       ,;
	                       SE5->E5_VALOR         ,;
	                       _cMvt                 ,;
	                       'R'				     ,;
	                       'FA330BX'              ;
	                      )

       
          If ValType( _nResult ) = 'A'
                                           
             RecLock("SE5",.F.)
             SE5->E5_IDMOVI := Str( _nResult[1], 10, 0 )
             SE5->E5_MSEXP  := DTOS(DATE())
             MsUnLock()
             
          Else
    
             //MsgInfo('Nใo conformidade ao baixar o Titulo ' + rTrim( SE5->E5_NUMERO ) + '/' +SE5->E5_PARCELA + ' ' +rTrim( SE5->E5_BENEF ) + '.', 'Rotina f300SE5' )

          EndIf
      EndIf
   EndIf
   	             
   QRYSE5->(dbSkip())
EndDo

Return Nil

          






Return Nil