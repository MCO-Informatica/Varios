/*
28/02/2012 - 15:00

	Exemplo de Uso do Workflow em um processo de Liberação de Pedido de Compras
	
*/

#include "rwmake.ch"
#include "tbiconn.ch"

USER function MT097END( nOpcao, oProcess )

If paramixb[3] <> 2 
                   
   Return( NIL )

End

If ValType(nOpcao) = "A" 

   nOpcao := nOpcao[1]

End
                                 
If nOpcao == NIL 

   nOpcao := 0

End


ConOut("Opcao:")
ConOut(nOpcao)
//C7_CONAPRO    
If oProcess == NIL
   oProcess := TWFProcess():New( "000001", "Pedido de Compras" )
End

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CPAR,NBARRA,N_ITEM,C_MAT,C_DEST,CGRAP")
SetPrvt("C_NUM,C_MOTIVO,N_TOTPC,CGRAPANT,N_TERMINA,N_DOHTML")
SetPrvt("CRAIZ,NRET,NHLDHTM,NHLDSCP,CIND,C_PCANT")
SetPrvt("N_QTDPC,N_FRTPC,A_ITENS,LCABEC,_AREGISTROS,NLIMITE")
SetPrvt("CAB_NUM,CAB_EMIS,CAB_FORN,CAB_COND,CAB_NOME,_NI")
SetPrvt("ARRAYCAB,ARRAYITENS,C_ITPED,NPRESUP,CAPROV,AINFO")
SetPrvt("CMAILAP,CNOMEAP,CORIGEM,CABEC,NHDLVLR,NCOUNT")
SetPrvt("NRESULT,CHTML,NHDLCONNECT")

_cSA2 := xFilial( 'SA2' )
_cSC7 := xFilial( 'SC7' )
_cSCR := xFilial( 'SCR' )
_cSE4 := xFilial( 'SE4' )

_nRecSC7 := SC7->( RecNo() )
_nRecSCR := SCR->( RecNo() )
_nRecSA2 := SA2->( RecNo() )
_nRecSAL := SAL->( RecNo() )

_nIdxSC7 := SC7->( IndexOrd() )
_nIdxSCR := SCR->( IndexOrd() )
_nIdxSA2 := SA2->( IndexOrd() )
_nIdxSAL := SAL->( IndexOrd() )

_cAlias  := Alias()

SPCIniciar( oProcess )

OProcess:Free()	

SC7->( dbSetOrder( _nIdxSC7 ) )
SCR->( dbSetOrder( _nIdxSCR ) )
SA2->( dbSetOrder( _nIdxSA2 ) )
SAL->( dbSetOrder( _nIdxSAL ) )

SC7->( RecNo( _nRecSC7 ) )
SCR->( RecNo( _nRecSCR ) )
SA2->( RecNo( _nRecSA2 ) )
SAL->( RecNo( _nRecSAL ) )

Return( NIL )

Static Function SPCIniciar( oProcess )
Local aCond:={},nTotal := 0,cMailID,cSubject
Local nFrete  := 0 
Local nImp    := 0

//Abre o HTML criado. Repare que o mesmo se encontra abaixo do RootPath

oProcess:NewTask( "Aprovação", "\WORKFLOW\wfw120pc.html" )

oProcess:cSubject  := "Aprovação do Pedido de Compra no. "  + SC7->C7_NUM

oProcess:bReturn := "U_WFW120P( 1 )"
oProcess:bTimeOut := {{"U_WFW120P( 2 )",30, 0, 5 }}

oHTML := oProcess:oHTML

oHtml:ValByName( "logo", 'lgrl' + rTrim( ParamIxb[4] ) )
oHtml:ValByName( "empresa", rTrim( SM0->M0_NOMECOM ) )
oHtml:ValByName( "cnpjcli", Transform( SM0->M0_CGC, '@R 99.999.999/9999-99' ) )
oHtml:ValByName( "endemp" , rTrim( SM0->M0_ENDENT ) )
oHtml:ValByName( "bairro" , rTrim( SM0->M0_BAIRENT ) )
oHtml:ValByName( "cidemp" , Transform( SM0->M0_CEPENT, '@R 99999-999' ) + ' - ' + rTrim( SM0->M0_CIDENT ) + ' - ' + SM0->M0_ESTENT )
oHtml:ValByName( "telemp" , Transform( SM0->M0_TEL, '@R (99) 9999-9999' ) )

oHtml:ValByName( "C7_NUM", SC7->C7_NUM )
		
/*** Preenche os dados do cabecalho ***/
oHtml:ValByName( "C7_EMISSAO", DtoC(SC7->C7_EMISSAO) )
   
SA2->( dbSeek( _cSA2 + SC7->C7_FORNECE, .F. ) )

oHtml:ValByName( "FORNECEDOR", SC7->C7_FORNECE +" - "+SA2->A2_NOME) 
oHtml:ValByName( "contato", SC7->C7_CONTATO) 
oHtml:ValByName( "email", SA2->A2_EMAIL ) 
oHtml:ValByName( "cidade", SA2->A2_MUN) 
oHtml:ValByName( "endforn", rtrim( SA2->A2_END), + ', ' + rtrim( SA2->A2_NR_END ) )
oHtml:ValByName( "broform", rtrim( SA2->A2_BAIRRO ) )  
oHtml:ValByName( "cepform", Transform( SA2->A2_CEP, '@R 99999-999' ) )
oHtml:ValByName( "fone", rtrim( SA2->A2_TEL ) ) 
oHtml:ValByName( "ieforn", rtrim( SA2->A2_INSCR ) )   
oHtml:ValByName( "cnpj", Transform( SA2->A2_CGC, '@R 99.999.999/9999-99' ) )   

//Pego as condicoes de Pagamento
SE4->( dbSeek( _cSE4  + SC7->C7_COND, .F. ) )

oHtml:ValByName( "E4_DESCRI", SC7->C7_COND +" - " + SE4->E4_DESCRI )

cNum := SC7->C7_NUM
oProcess:fDesc := "Pedido de Compras No "+ cNum

_cGrupo := SC7->C7_APROV

SC7->( dbSeek( _cSC7 + cNum, .F. ) )

While ! SC7->( Eof() ) .And.;
   ( SC7->C7_NUM = cNum )

   nTotal  += SC7->C7_TOTAL
   nFrete  += SC7->C7_FRETE
   nImp    += SC7->C7_VALIPI
   nImp    += SC7->C7_VALICM

   aAdd( (oHtml:ValByName( "t1.1" )),SC7->C7_ITEM )		
   aAdd( (oHtml:ValByName( "t1.2" )),SC7->C7_PRODUTO )		       
   aAdd( (oHtml:ValByName( "t1.3" )),SC7->C7_DESCRI )		              
   aAdd( (oHtml:ValByName( "t1.4" )),SC7->C7_UM )		              
   aAdd( (oHtml:ValByName( "t1.5" )),TRANSFORM( SC7->C7_QUANT,'@E 99,999.999' ) )		              
   aAdd( (oHtml:ValByName( "t1.6" )),TRANSFORM( SC7->C7_PRECO,'@E 99,999,999.99' ) )		                     
   aAdd( (oHtml:ValByName( "t1.8" )),TRANSFORM( SC7->C7_TOTAL,'@E 99,999,999.99' ) )		                     
   aAdd( (oHtml:ValByName( "t1.9" )),DtoC(SC7->C7_DATPRF) )
   aAdd( (oHtml:ValByName("t3.1")), rTrim( SC7->C7_OBS ) )

   WFSalvaID('SC7','C7_WFID',oProcess:fProcessID)

   SC7->( dbSkip() )

End

AAdd( (oHtml:ValByName("t2.1" )),TRANSFORM( nTotal,'@E 99,999,999.99' ))
AAdd( (oHtml:ValByName("t2.2" )),TRANSFORM( nFrete,'@E 99,999.99' ))		              	    
AAdd( (oHtml:ValByName("t2.3" )),TRANSFORM( nImp,'@E 9,999,999.99' ))	              	    
   
oProcess:ClientName( UsrFullName( __cUserID )  )

SCR->( dbSeek( _cSCR + 'PC' + cNum, .T. ) )

_cTo    := ''
_lNivel := .F.
_lApr   := .F.
_fSAL   := xFilial( 'SAL' )
SAL->( dbSetOrder( 3 ) )

While ! ( SCR->( Eof() ) ) .And.;
        ( cNum = Substr( SCR->CR_NUM, 1, 6 ) )

   _cTo += rTrim( UsrRetMail( SCR->CR_USER ) )

   If SCR->CR_NIVEL <> '01'

      _lNivel := .T.

   End

   If ( SAL->( dbSeek( _fSAL + _cGrupo + SCR->CR_APROV, .F. ) ) )

      If SAL->AL_LIBAPR <> 'V'

         _lApr := .T.

      End

   End

   SCR->( dbSkip() )

   If ( cNum <> Substr( SCR->CR_NUM, 1, 6 ) )

      Exit

   Else

      _cTo += ';'

   End
        
End

//oProcess:cTo := _cTo  //Coloque aqui o destinatario do Email.
oProcess:cTo := rTrim( SA2->A2_EMAIL )  //Coloque aqui o destinatario do Email.
oProcess:ccc := rTrim( UsrRetMail( SC7->C7_USER ) ) + iif( empty( _cTo ), '', ';' + _cTo )  //Coloque aqui o destinatario do Email.
oProcess:Start()            
	
ConOut( "Rastreando:"+oProcess:fProcCode )

Return( NIL )

Static Function SPCTimeOut( oProcess )

  ConOut("Função de TIMEOUT executada")
  oProcess:Finish()  //Finalizo o Processo

Return ( NIL )

