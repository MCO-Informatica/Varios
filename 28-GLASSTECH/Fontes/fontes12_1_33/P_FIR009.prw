#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "protheus.ch"

#DEFINE IMP_SPOOL 6

Static cBDGSTQ	:= Iif(At("_12133", Upper(GetEnvServer())) > 0, "TESTE"			, "TPCP"		)
Static cBDPROT	:= GetMv("MV_TWINENV")
Static cBVGstq	:= Iif(At("_12133", Upper(GetEnvServer())) > 0, "BVTESTE"			, "BV"			)
/*
??????????????????????????????????????????????????????????????????????????????????
??????????????????????????????????????????????????????????????????????????????????
??????????????????????????????????????????????????????????????????????????????ͻ??
??? PROGRAMA     ? P_FIR009  ? AUTOR ?                    ? DATA ? AGOSTO/2005 ???
??????????????????????????????????????????????????????????????????????????????͹??
??? DESCRICAO    ? PROGRAMA ESPECIFICO PARA REEMISSAO DA IMPRESSAO DO          ???
???              ? BOLETO DE COBRANCA DO BANCO ITAU, EM FORMATO GRAFICO A SER  ???
???              ? EMITIDO JUNTAMENTE COM A NOTA FISCAL FATURA OU CUPOM FISCAL ???
???              ? DESDE QUE A FORMA DE PAGAMENTO ASSIM O JUSTIFIQUE.          ???
??????????????????????????????????????????????????????????????????????????????͹??
??? TABS.UTILIZ  ? DESCRICAO                                          ? ACESSO ???
??????????????????????????????????????????????????????????????????????????????͹??
???   SA1010     ? CADASTRO DE CLIENTES                               ? READ   ???
???   SA6010     ? CADASTRO DE BANCOS                                 ? READ   ???
???   SE1010     ? CONTAS A RECEBER                                   ? WRITE  ???
??????????????????????????????????????????????????????????????????????????????͹??
??? HISTORICO    ? (AGO/2005) ELABORACAO DE PROGRAMA INICIAL - ALEX (REV. 00)  ???
??????????????????????????????????????????????????????????????????????????????͹??
??? USO          ? ESPECIFICO  - CONTROLE DE LOJAS/FINANCEIRO.                 ???
??????????????????????????????????????????????????????????????????????????????͹??
??? PROPRIETARIO ? CUSTOMIZADO PARA                                            ???
??????????????????????????????????????????????????????????????????????????????ͼ??
??????????????????????????????????????????????????????????????????????????????????
??????????????????????????????????????????????????????????????????????????????????
*/
User Function P_FIR009( _cBordero )

LOCAL   _aSavArea := GetArea()
DEFAULT _cBordero := 'N'

PRIVATE _cCaminho := ''
PRIVATE _cFile    := ''
PRIVATE _cMail    := ''

cPerg     := 'PFIR09'

//??????????????????????????????????????????????????????????????Ŀ
//? Verifica as perguntas selecionadas                           ?
//????????????????????????????????????????????????????????????????
//ValidPerg()

// Impress?o do boleto banc?rio permitido para as contas 55375,88999,12641

If (SE1->E1_CONTA = '55375     ' .Or.;
    SE1->E1_CONTA = '88999     ' .Or.;
    SE1->E1_CONTA = '12641     ')

    Pergunte( cPerg, .F. )

Else

   MsgInfo('Verifique banco, impress?o n?o permitida para esta conta conrrente, por gentileza cadastre o portador.')
   Return( NIL )

End

If ( _cBordero = 'N' )

   If ! Pergunte( cPerg, .T. )
      Return()
   End

Else

   MV_PAR01 := SE1->E1_PREFIXO
   MV_PAR02 := SE1->E1_NUM
   MV_PAR03 := SE1->E1_PARCELA
   MV_PAR04 := SE1->E1_PARCELA

End

SE1->( dbSetOrder( 1 ) )

If ( _cBordero = 'N' )

   Processa( { || MontaBol( _cBordero, 0 ) },'Aguarde...','Boleto', .F. )

Else

   MontaBol( _cBordero, 0 )

End


RestArea( _aSavArea )

Return( NIL )
/*/
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????Ŀ??
???Fun??o    ?MontaRel()   ?Descri??o?Montagem e Impressao de boleto Gra- ???
???          ?             ?         ?fico do Banco Itau.                 ???
??????????????????????????????????????????????????????????????????????????ٱ?
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
/*/
Static Function MontaBol( _cBordero, _nProc )

LOCAL   oPrint
LOCAL   n := 0
LOCAL aBitmap := "\system\Itau.bmp"
LOCAL aDadosEmp    := {;
					   AllTrim(SM0->M0_NOMECOM)                                                  ,; //[1]Nome da Empresa
					   SM0->M0_ENDCOB                                                            ,; //[2]Endere?o
					   AllTrim(SM0->M0_BAIRCOB)+", "+AllTrim(SM0->M0_CIDCOB)+", "+SM0->M0_ESTCOB ,; //[3]Complemento
					   "CEP: "+Subs(SM0->M0_CEPCOB,1,5)+"-"+Subs(SM0->M0_CEPCOB,6,3)             ,; //[4]CEP
					   "TELEFONE: "+SM0->M0_TEL                                                  ,; //[5]Telefones
					   "CNPJ: "+transform( SM0->M0_CGC, '@R 99.999.999/9999-99' )              ,; //[6]
					   "I.E.: "+transform( SM0->M0_INSC, '@R 999.999.999.999' )                   ; //[7]I.E
					  }

LOCAL aDadosTit
LOCAL aDadosBanco
LOCAL aDatSacado
LOCAL aBolText     := {}
LOCAL i            := 1
LOCAL CB_RN_NN     := {}
LOCAL nRec         := 0
LOCAL _nVlrAbat    := 0
LOCAL cParcela	   := ''
LOCAL lAdjustToLegacy := .T. // Inibe legado de resolu??o com a TMSPrinter
Local nHRes    := 0
Local nVRes    := 0
Local nDevice
Local oSetup
Local aDevice  := {}
Local cSession := GetPrinterSession()
Local nRet     := 0
Local cMailID, cSubject

PRIVATE _nTxper := GETMV("MV_TXPER")
PRIVATE oFont2n
PRIVATE oFont8
PRIVATE oFont9
PRIVATE oFont10
PRIVATE oFont15n
PRIVATE oFont16
PRIVATE oFont16n
PRIVATE oFont14n
PRIVATE oFont24

PRIVATE nConsNeg := 0.4  // Constante para concertar o c?lculo retornado pelo GetTextWidth para fontes em negrito.
PRIVATE nConsTex := 0.38 // Constante para concertar o c?lculo retornado pelo GetTextWidth.
PRIVATE nFontSize := 40

If ( _cBordero = 'I' )

   If ! (SA6->( dbSeek( xFilial( 'SA6' ) + SE1->(E1_PORTADO+E1_AGEDEP+E1_CONTA)        , .F. ) ))
      MsgInfo('T?tulo n?o est? registro no banco, por gentileza cadastre o portador.')
      Return( NIL )
   End

   If ! (SEE->( dbSeek( xFilial( 'SEE' ) + SE1->(E1_PORTADO+E1_AGEDEP+E1_CONTA) + '1  ', .F. ) ))
      MsgInfo('Parametro banc?rio n?o est? informado, por gentileza cadastre o par?metro.')
      Return( NIL )
   End

   _nProc := 3


ElseIf ( _cBordero = 'S' )

   If ! (SEE->( dbSeek( xFilial( 'SEE' ) + SEA->EA_PORTADO + SEA->EA_AGEDEP + SEA->EA_NUMCON + '1  ', .F. ) ))
      MsgInfo('Parametro banc?rio n?o est? informado, por gentileza cadastre o par?metro.')
      Return( NIL )
   End

End

If _nProc <> 0

   ProcRegua( _nProc )
   IncProc( 'Aguarde, gerando boleto...')

End

nLocal       	:= If(fwGetProfString(cSession,"LOCAL","SERVER",.T.)=="SERVER",1,2 )
nOrientation 	:= If(fwGetProfString(cSession,"ORIENTATION","PORTRAIT",.T.)=="PORTRAIT",1,2)
nPrintType      := 6

If ( _cBordero = 'N' )

   SE1->( dbSeek( xFilial( 'SE1' ) + MV_PAR01 + MV_PAR02 ) )

End

If SE1->E1_FILIAL <> '9001'

   _cQry := 'SELECT CLI.NOME,'
   _cQry += 'CASE VDO.ID_VENDEDOR '
   _cQry += "  WHEN  5 THEN 'Andre'"
   _cQry += "  WHEN 25 THEN 'Elisa'"
   _cQry += "  WHEN 43 THEN 'Fernanda.Alves'"
   _cQry += "  WHEN 36 THEN 'Jessica'"
   _cQry += "  WHEN 40 THEN 'Joao.Ferreira'"
   _cQry += "  WHEN 34 THEN 'Marcos'"
   _cQry += "  WHEN  4 THEN 'Mauro'"
   _cQry += "  WHEN 24 THEN 'Ricardo.Lima'"
   _cQry += "  WHEN 23 THEN 'Ronaldo'"
   _cQry += "  WHEN  3 THEN 'Wagner'"
   _cQry += "  ELSE 'Corporativo'"
   _cQry += 'END Vendedor, CTO.EMAIL '
   _cQry += 'FROM '+cBDGSTQ+'.dbo.VENCTITULO VCT '
   _cQry += 'LEFT OUTER JOIN '+cBDGSTQ+'.dbo.TITULO TIT ON TIT.ID_TITULO = VCT.ID_TITULO '
   _cQry += 'LEFT OUTER JOIN '+cBDGSTQ+'.dbo.CLIENTE CLI ON CLI.ID_CLIENTE = TIT.ID_CLIENTE '
   _cQry += 'LEFT OUTER JOIN '+cBDGSTQ+'.dbo.VENDEDOR VDO ON VDO.ID_VENDEDOR = CLI.ID_VENDEDOR '
   _cQry += "LEFT OUTER JOIN "+cBDGSTQ+".dbo.CLIENTE_CONTATO CTO ON CLI.ID_CLIENTE = CTO.ID_CLIENTE AND NFE = 'S' "
   _cQry += 'WHERE VCT.ID_VENCTITULO = ' + Alltrim( Str( SE1->E1_IDBOLET, 9, 0 ) )

Else

   _cQry := 'SELECT CLI.NOME,'
   _cQry += 'CASE VDO.ID_VENDEDOR '
   _cQry += "  WHEN  5 THEN 'Andre'"
   _cQry += "  WHEN 25 THEN 'Elisa'"
   _cQry += "  WHEN 43 THEN 'Fernanda.Alves'"
   _cQry += "  WHEN 36 THEN 'Jessica'"
   _cQry += "  WHEN 40 THEN 'Joao.Ferreira'"
   _cQry += "  WHEN 34 THEN 'Marcos'"
   _cQry += "  WHEN  4 THEN 'Mauro'"
   _cQry += "  WHEN 24 THEN 'Ricardo.Lima'"
   _cQry += "  WHEN 23 THEN 'Ronaldo'"
   _cQry += "  WHEN  3 THEN 'Wagner'"
   _cQry += "  ELSE 'Corporativo'"
   _cQry += 'END Vendedor, CTO.EMAIL '
   _cQry += 'FROM [192.168.0.7].['+cBVGstq+'].[dbo].[VENCTITULO] VCT '
   _cQry += 'LEFT OUTER JOIN [192.168.0.7].['+cBVGstq+'].[dbo].[TITULO] TIT ON TIT.ID_TITULO = VCT.ID_TITULO '
   _cQry += 'LEFT OUTER JOIN '+cBDGSTQ+'.dbo.CLIENTE CLI ON CLI.ID_CLIENTE = TIT.ID_CLIENTE '
   _cQry += 'LEFT OUTER JOIN '+cBDGSTQ+'.dbo.VENDEDOR VDO ON VDO.ID_VENDEDOR = CLI.ID_VENDEDOR '
   _cQry += "LEFT OUTER JOIN "+cBDGSTQ+".dbo.CLIENTE_CONTATO CTO ON CLI.ID_CLIENTE = CTO.ID_CLIENTE AND NFE = 'S' "
   _cQry += 'WHERE VCT.ID_VENCTITULO = ' + Alltrim( Str( SE1->E1_IDBOLET, 9, 0 ) )

End

dbUseArea( .T.,"TOPCONN",TcGenQry(,,_cQry),"TMP",.T.,.T.)

PreNota()

While ! ( TMP->( Eof() ) )

   _cCaminho := 'C:\Boletos\' + alltrim( TMP->Vendedor ) + '\'
   
   //Cria o diret?rio automaticamente
   MakeDir(_cCaminho)
   
   _cMail    += alltrim( TMP->EMAIL )
   _cMail    += ';'
   _cFile    := iif( SE1->E1_FILIAL <> '9001', SE1->E1_NUM, '10' + Substr( SE1->E1_NUM, 3 ) ) + SE1->E1_PARCELA
   TMP->( dbSkip() )

End

TMP->( dbCloseArea() )

MakeDir("c:\spool")
oPrint := FWMSPrinter():New('BoletoItau.Pdf', IMP_PDF, lAdjustToLegacy, 'C:\Spool\' /*cPathInServer*/, .T. )

oPrint:SetResolution(78) // Tamanho estipulado para a Danfe
oPrint:SetPortrait() // ou SetLandscape()
oPrint:SetPaperSize(DMPAPER_A4)
oPrint:SetMargin(60,60,60,60)

nFlags := PD_ISTOTVSPRINTER + PD_DISABLEPAPERSIZE + PD_DISABLEPREVIEW + PD_DISABLEMARGIN
oSetup := FWPrintSetup():New(nFlags, 'Boleto Ita?')
// ----------------------------------------------
// Define saida
// ----------------------------------------------
oSetup:SetPropert(PD_PRINTTYPE   , nPrintType)
oSetup:SetPropert(PD_ORIENTATION , nOrientation)
oSetup:SetPropert(PD_DESTINATION , nLocal)
oSetup:SetPropert(PD_MARGIN      , {60,60,60,60})
oSetup:SetPropert(PD_PAPERSIZE   , 2)

oPrint:lServer := oSetup:GetProperty(PD_DESTINATION)==AMB_SERVER
// ----------------------------------------------
// Define saida de impress?o
// ---------------------------------------------
If oSetup:GetProperty(PD_PRINTTYPE) == IMP_SPOOL
	oPrint:nDevice := IMP_SPOOL
	// ----------------------------------------------
	// Salva impressora selecionada
	// ----------------------------------------------
	fwWriteProfString(GetPrinterSession(),'DEFAULT', oSetup:aOptions[PD_VALUETYPE], .T.)
	oPrint:cPrinter := oSetup:aOptions[PD_VALUETYPE]
ElseIf oSetup:GetProperty(PD_PRINTTYPE) == IMP_PDF
	oPrint:nDevice := IMP_PDF
	// ----------------------------------------------
	// Define para salvar o PDF
	// ----------------------------------------------
	oPrint:cPathPDF := oSetup:aOptions[PD_VALUETYPE]
End

Private PixelX := oPrint:nLogPixelX()
Private PixelY := oPrint:nLogPixelY()

oPrint:cPathPDF := 'C:\Spool\'
oPrint:SetViewPDF( .F. )

/* []------------------------------[]

      Par?metros de TFont.New()
      1.Nome da Fonte (Windows)
      3.Tamanho em Pixels
      5.Bold (T/F)

  []------------------------------[]*/

oFont2n := TFont():New('Times New Roman',,10,,.T.,,,,,.F. )

oFont8  := TFont():New('Arial',9,9,,.F.,,,,.T.,.F.)
oFont9  := TFont():New('Arial',9,11,,.F.,,,,.T.,.F.)
oFont10 := TFont():New('Arial',9,10,,.T.,,,,.T.,.F.)
oFont14n:= TFont():New('Arial',9,16,,.T.,,,,.T.,.F.)
oFont15n:= TFont():New('Arial',9,17,,.T.,,,,.T.,.F.)
oFont16 := TFont():New('Arial',9,18,,.F.,,,,.T.,.F.)
oFont16n:= TFont():New('Arial',9,18,,.T.,,,,.T.,.F.)
oFont24 := TFont():New('Arial',9,26,,.F.,,,,.T.,.F.)

SA6->( dbSetOrder(1) )

WF7->( dbSeek( xFilial( 'WF7' ) + 'FINANCEIRO          ', .F. ) )

/*oProcess := TWFProcess():New( "000002", "Envio Boleto" )
oProcess:oWF:cMailBox := 'FINANCEIRO' + Space( Len( oProcess:oWF:cMailBox ) - 10 )
//Abre o HTML criado. Repare que o mesmo se encontra abaixo do RootPath

oProcess:NewTask( "Aprova??o", "\WORKFLOW\WFEnvBol.htm" )

oProcess:cSubject  := "Boleto referente Nota "  + lTrim( Str( Val( SE1->E1_NUM ), 9, 0 ) )

oProcess:bReturn := "U_WFW120P( 1 )"
oProcess:bTimeOut := {{"U_WFW120P( 2 )",30, 0, 5 }}

oHTML := oProcess:oHTML

oHtml:ValByName( "empresa", rTrim( SM0->M0_NOMECOM ) )

oHtml:ValByName( "resp1", '<a href="mailto:norival@thermoglass.com.br"><code>norival@thermoglass.com.br</code></a>' )
oHtml:ValByName( "resp2", '<a href="mailto:iovanne@thermoglass.com.br"><code>iovanne@thermoglass.com.br</code></a>' ) */

While ! ( SE1->( Eof() ) )           .And.;
      ( SE1->E1_PREFIXO = MV_PAR01 ) .And.;
      ( SE1->E1_NUM     = MV_PAR02 )

	If ( SE1->E1_PARCELA < MV_PAR03 )

	   SE1->( dbSkip() )
	   Loop

	End

	If ( SE1->E1_PARCELA > MV_PAR04 )

	   SE1->( dbSkip() )
	   Loop

	End

	If Alltrim(SE1->E1_TIPO) <> 'NF' .And.;
	   Alltrim(SE1->E1_TIPO) <> 'FT' .And.;
	   Alltrim(SE1->E1_TIPO) <> 'DP' .And.;
	   Alltrim(SE1->E1_TIPO) <> 'PRE'

	   SE1->( dbSkip() )
	   Loop

	End

	If ( SE1->E1_SALDO <= 0 )

	   SE1->( dbSkip() )
	   Loop

	End

    If ( _cBordero = 'I' )

	   SA6->( dbSeek( xFilial( 'SA6' ) + SE1->(E1_PORTADO+E1_AGEDEP+E1_CONTA)        , .F. ) )
	   SEE->( dbSeek( xFilial( 'SEE' ) + SE1->(E1_PORTADO+E1_AGEDEP+E1_CONTA) + '1  ', .F. ) )

    ElseIf ( _cBordero = 'S' )

	   SEE->( dbSeek( xFilial( 'SEE' ) + SEA->EA_PORTADO + SEA->EA_AGEDEP + SEA->EA_NUMCON + '1  ', .F. ) )

	End

    _cNossoNum := '109'

    If Empty( SE1->E1_IDCNAB )

       RecLock( 'SE1', .F. )

       If SE1->E1_IDBOLET <> 0 // Compatibiliza IDVenctitulo

          SE1->E1_IDCNAB := Str( SE1->E1_IDBOLET, 6, 0 )

       Else
       	  
          //Removido e equalizado com a forma utilizada no F650VAR
          //SE1->E1_IDCNAB := GetSx8Num( 'SE1', 'E1_IDCNAB' )
          SE1->E1_IDCNAB := GetSxENum("SE1", "E1_IDCNAB","E1_IDCNAB"+cEmpAnt,19)
          ConfirmSX8()

       End

       SE1->( dbUnLock() )

    End

    If Empty( SE1->E1_NUMBCO )

       RecLock( 'SE1', .F. )
       SE1->E1_NUMBCO := NossoNum()
       SE1->( dbUnLock() )

    End

    U_BoletoItau()

    _cNossoNum := StrZero( Val( SE1->E1_NUMBCO ), 9, 0 )

	dbSelectArea("SA1")
	dbSetOrder(1)
	SA1->( dbSeek(xFilial('SA1')+SE1->E1_CLIENTE+SE1->E1_LOJA,.F.) )

	aDadosBanco  := {;
					 SA6->A6_COD	   	    ,; // [1]Numero do Banco
					 "Banco Ita? S.A."      ,; // [2]Nome do Banco
					 Alltrim(SA6->A6_AGENCIA),; // [3]Ag?ncia
					 StrZero( Val( SA6->A6_NUMCON ), 5, 0 ),; // [4]Conta Corrente
					 Alltrim(SA6->A6_DVCTA) ,; // [5]D?gito da conta corrente
					 "109"                   ; // [6]Codigo da Carteira
	                }

	If Empty(SA1->A1_ENDCOB)

		aDatSacado   := {AllTrim(SA1->A1_NOME)             ,;     // [1]Raz?o Social
		AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA             ,;     // [2]C?digo
		AllTrim(SA1->A1_END )+" - "+AllTrim(SA1->A1_BAIRRO),;     // [3]Endere?o
		AllTrim(SA1->A1_MUN )                              ,;     // [4]Cidade
		SA1->A1_EST                                        ,;     // [5]Estado
		Transform( SA1->A1_CEP, '@R 99999-999' )           ,;     // [6]CEP
		Transform( SA1->A1_CGC, '@R 99.999.999/9999-99' )    }       // [7]CGC

	Else

		aDatSacado   := {AllTrim(SA1->A1_NOME)                ,;   // [1]Raz?o Social
		AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA                ,;   // [2]C?digo
		AllTrim(SA1->A1_ENDCOB)+" - "+AllTrim(SA1->A1_BAIRROC),;   // [3]Endere?o
		AllTrim(SA1->A1_MUNC)	                              ,;   // [4]Cidade
		SA1->A1_ESTC	                                      ,;   // [5]Estado
		Transform( SA1->A1_CEPC, '@R 99999-999' )             ,;   // [6]CEP
		Transform( SA1->A1_CGC, '@R 99.999.999/9999-99' )      }    // [7]CGC

	End

	CB_RN_NN := Ret_cBarra(Subs(aDadosBanco[1],1,3)+"9",aDadosBanco[3],aDadosBanco[4],aDadosBanco[5],AllTrim(_cNossoNum),SE1->E1_SALDO,SE1->E1_VENCREA)

    aBolText := {'AP?S ' + DtoC ( SE1->E1_VENCREA ) + ', COBRAR MULTA DE R$ ' + ltrim( Transform( SE1->(E1_VALOR-E1_COFINS-E1_PIS)*.03, '@E 999,999.99')),;
                 'AP?S VENCIMENTO COBRAR R$ ' + ltrim( Transform( SE1->(E1_VALOR-E1_COFINS-E1_PIS)*.002, '@E 999,999.99' )) + ' POR DIA DE ATRASO',;
                 'Ap?s vcto acesse http://www.itau.com.br/boletos para atualizar seu boleto';
                }

	aDadosTit := {;
	              AllTrim(iif( SE1->E1_FILIAL <> '9001', SE1->E1_NUM, '10' + Substr( SE1->E1_NUM, 3 )))+AllTrim(SE1->E1_PARCELA),;  // [1] N?mero do t?tulo
	              SE1->E1_EMISSAO                              ,;  // [2] Data da emiss?o do t?tulo
	              dDataBase                               	   ,;  // [3] Data da emiss?o do boleto
	              SE1->E1_VENCREA                  			   ,;  // [4] Data do vencimento
	              SE1->E1_SALDO                 			   ,;  // [5] Valor do t?tulo
				  CB_RN_NN[3]                             	   ,;  // [6] Nosso n?mero (Ver f?rmula para calculo)
				  SE1->E1_PREFIXO                              ,;  // [7] Prefixo da NF
				  'DM' 	        	                            ;  // [8] Tipo do Titulo SE1->E1_TIPO
				 }

	If SE1->E1_VENCREA < dDataBase

	   _nDias := dDataBase - SE1->E1_VENCREA

	   _nJuros := ((SE1->E1_VALOR-SE1->E1_COFINS-SE1->E1_PIS) * 0.03) / 30
	   _nJuros *= _nDias
	   _nJuros += (SE1->E1_VALOR-SE1->E1_COFINS-SE1->E1_PIS)* 0.02

	   aDadosTit[ 5 ] += Round( _nJuros, 2 )
	   aDadosTit[ 4 ] := dDataBase

    End

	Impress(oPrint,aBitmap,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,CB_RN_NN)
	n ++

/*  aAdd( (oHtml:ValByName( "t1.1" )), SE1->E1_NUM )
    aAdd( (oHtml:ValByName( "t1.2" )), rtrim(SE1->E1_PARCELA) )
    aAdd( (oHtml:ValByName( "t1.3" )), TRANSFORM( SE1->E1_EMISSAO,'@DE 99/99/9999' ) )
    aAdd( (oHtml:ValByName( "t1.4" )), TRANSFORM( SE1->E1_VENCREA,'@DE 99/99/9999' ) )
    aAdd( (oHtml:ValByName( "t1.5" )), TRANSFORM( SE1->E1_SALDO,'@E 99,999,999.99' ) )
    aAdd( (oHtml:ValByName( "t1.6" )), CB_RN_NN[2] ) */

	If SE1->E1_IDBOLET > 300000

	   _cUpd := 'UPDATE [192.168.0.7].'+cBVGstq+'.dbo.VENCTITULO SET QdeBoleto = QdeBoleto + 1, ID_COBRANCA = ' + Alltrim( Str( SA6->A6_IDCART, 3, 0  ) ) + ', ID_CONTA = '  + Alltrim( Str( SA6->A6_IDCONTA, 3, 0  ) )
	   _cUpd += ' WHERE ID_VENCTITULO = ' + Alltrim( Str( SE1->E1_IDBOLET, 9, 0 ) )

	Else

	   _cUpd := 'UPDATE '+cBDGSTQ+'.dbo.VENCTITULO SET QdeBoleto = QdeBoleto + 1, ID_COBRANCA = ' + Alltrim( Str( SA6->A6_IDCART, 3, 0  ) ) + ', ID_CONTA = '  + Alltrim( Str( SA6->A6_IDCONTA, 3, 0  ) )
	   _cUpd += ' WHERE ID_VENCTITULO = ' + Alltrim( Str( SE1->E1_IDBOLET, 9, 0 ) )

	End

	TCSQLExec( _cUpd )

	SE1->( dbSkip() )

	If ( _cBordero = 'N' )

       IncProc()

    End

	i ++

End

//oPrint:Preview()     // Visualiza antes de imprimir
oPrint:Print()
FreeObj( oPrint )
FreeObj( oSetup )

//WaitRun('move /Y C:\Spool\BoletoItau.pdf "' + _cCaminho + _cFile + '.pdf' +'"', 0 )

If File ( _cCaminho + _cFile + '.pdf' )

   fErase( _cCaminho + _cFile + '.pdf' )

End

If fRenameEx( 'C:\Spool\BoletoItau.pdf', _cCaminho + _cFile + '.pdf' ) = -1

   MsgStop('Falha na opera??o 3 : fError ' + Str( fError(),4 ) )

End

CpyT2S( _cCaminho + _cFile + '.pdf', '\spool\' )

If _nProc <> 0

   IncProc( 'Aguarde, enviando e-mail...' )

End

/*oProcess:AttachFile( '\spool\' + _cFile + '.pdf' )
oProcess:cPriority := ' '
oProcess:cTo := _cMail  //Coloque aqui o destinatario do Email.
//oProcess:cTo := 'sergio.santana@thermoglass.com.br'
oProcess:Start()
OProcess:Finish()
OProcess:Free()

StartJob( "WFLauncher", GetEnvServer(), .F., { "WFSndMsg", { cEmpAnt, cFilAnt, AllTrim( WF7->WF7_PASTA ), .T. } } )
*/

Return( NIL )

/*/
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????Ŀ??
???Fun??o    ?Impress      ?Descri??o?Impressao de Boleto Grafico do Banco???
???          ?             ?         ?Itau.                               ???
??????????????????????????????????????????????????????????????????????????ٱ?
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
/*/
Static Function Impress(oPrint,aBitmap,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,CB_RN_NN)
LOCAL i := 0

oPrint:StartPage()   // Inicia uma nova p?gina

aBmp 	:= "\system\Itau.bmp"
aBmp2 	:= "\system\lgrl010202.bmp"


// LOGOTIPO

If File(aBmp2)

	oPrint:SayBitmap( 0040,0100,aBmp2,0175,0100 )

Else

	oPrint:Say  (0084,100,aDadosBanco[2],oFont15n )	// [2]Nome do Banco

End

oPrint:Line (0710,100,0710,2300)
oPrint:Line (0710,550,0610, 550)
oPrint:Line (0710,800,0610, 800)

// LOGOTIPO

If File( aBmp )

   oPrint:SayBitmap( 0600,0100,aBmp,0100,0100 )
   oPrint:Say  (0670,240,"Banco Ita? SA",oFont10 ) // [2]Nome do Banco

Else

   oPrint:Say  (0644,100,aDadosBanco[2],oFont15n ) // [2]Nome do Banco

End

oPrint:Say  (0674,569,"341-7",oFont24 )	     // [1]Numero do Banco
oPrint:Say  (0674,820,CB_RN_NN[2],oFont14n)	 //Linha Digitavel do Codigo de Barras   1934

oPrint:Line (0810,100,0810,2300 )
oPrint:Line (0910,100,0910,2300 )
oPrint:Line (0980,100,0980,2300 )
oPrint:Line (1050,100,1050,2300 )

oPrint:Line (0910,500,1050,500)
oPrint:Line (0980,750,1050,750)
oPrint:Line (0910,1000,1050,1000)
oPrint:Line (0910,1350,0980,1350)
oPrint:Line (0910,1550,1050,1550)

oPrint:Say  (0740,100 ,"Local de Pagamento"                             ,oFont8)
oPrint:Say  (0755,400 ,"Pag?vel em qualquer Banco at? o Vencimento."    ,oFont9)
oPrint:Say  (0795,400 ,"Ap?s o Vencimento pague somente no Banco Ita?." ,oFont9)

oPrint:Say  (0740,1910,"Vencimento"                                     ,oFont8)
oPrint:Say  (0790,2010,DTOC(aDadosTit[4])                               ,oFont10)

oPrint:Say  (0840,100 ,"Cedente"                                        ,oFont8)
oPrint:Say  (0880,100 ,aDadosEmp[1]+"                  - "+aDadosEmp[6]	,oFont10) //Nome + CNPJ

oPrint:Say  (0830,1910,"Ag?ncia/C?digo Cedente"                         ,oFont8)
oPrint:Say  (0880,2010,aDadosBanco[3]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5],oFont10)

oPrint:Say  (0940,100 ,"Data do Documento"                              ,oFont8)
oPrint:Say  (0970,100 ,DtoC(aDadosTit[2])                               ,oFont10) // Emissao do Titulo (E1_EMISSAO)

oPrint:Say  (0940,505 ,"Nro.Documento"                                  ,oFont8)
oPrint:Say  (0970,605 ,iif(SEA->EA_FILIAL <> '9001',alltrim(aDadosTit[7])+aDadosTit[1],aDadosTit[1]) ,oFont10) //Prefixo +Numero+Parcela

oPrint:Say  (0940,1005,"Esp?cie Doc."                                   ,oFont8)
oPrint:Say  (0970,1050,aDadosTit[8]										,oFont10) //Tipo do Titulo

oPrint:Say  (0940,1355,"Aceite"                                         ,oFont8)
oPrint:Say  (0970,1455,"N"                                             ,oFont10)

oPrint:Say  (0940,1555,"Data do Processamento"                          ,oFont8)
oPrint:Say  (0970,1655,DTOC(aDadosTit[3])                               ,oFont10) // Data impressao

oPrint:Say  (0940,1910,"Nosso N?mero"                                   ,oFont8)
oPrint:Say  (0970,2010,Substr(aDadosTit[6],1,3)+"/"+Substr(aDadosTit[6],4),oFont10)

oPrint:Say  (1010,100 ,"Uso do Banco"                                   ,oFont8)

oPrint:Say  (1010,505 ,"Carteira"                                       ,oFont8)
oPrint:Say  (1040,555 ,aDadosBanco[6]                                  	,oFont10)

oPrint:Say  (1010,755 ,"Esp?cie"                                        ,oFont8)
oPrint:Say  (1040,805 ,"R$"                                             ,oFont10)

oPrint:Say  (1010,1005,"Quantidade"                                     ,oFont8)
oPrint:Say  (1010,1555,"Valor"                                          ,oFont8)

oPrint:Say  (1010,1910,"(=)Valor do Documento"                          	,oFont8)
oPrint:Say  (1040,2010,AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),oFont10)

oPrint:Say  (1080,100 ,"Instru??es (Todas informa??es deste bloqueto s?o de exclusiva responsabilidade do cedente)",oFont8)
oPrint:Say  (1230,100 ,aBolText[1]                                       ,oFont10)
oPrint:Say  (1270,100 ,aBolText[2]                                       ,oFont10)
oPrint:Say  (1310,100 ,aBolText[3]                                       ,oFont10)

oPrint:Say  (1080,1910,"(-)Desconto/Abatimento"                         ,oFont8)
oPrint:Say  (1150,1910,"(-)Outras Dedu??es"                             ,oFont8)
oPrint:Say  (1220,1910,"(+)Mora/Multa"                                  ,oFont8)
oPrint:Say  (1290,1910,"(+)Outros Acr?scimos"                           ,oFont8)
oPrint:Say  (1360,1910,"(=)Valor Cobrado"                               ,oFont8)

oPrint:Say  (1460,100 ,"Pagador:"                                         ,oFont8)
oPrint:Say  (1460,400 ,aDatSacado[1]+" ("+aDatSacado[2]+")"             ,oFont10)

If Len(Alltrim(aDatSacado[7])) = 18
	oPrint:Say  (1460,1850 ,"CNPJ: " + aDatSacado[7],oFont10) // CGC
Else
	oPrint:Say  (1460,1850 ,"CPF(MF): "+aDatSacado[7],oFont10) // CPF
End

oPrint:Say  (1513,100 ,"Endere?o:"                                       ,oFont8)
oPrint:Say  (1513,400 ,aDatSacado[3]+' - '+aDatSacado[6]+" - "+aDatSacado[4]+" - "+aDatSacado[5],oFont10)

oPrint:Say  (1619,1850, aDadosEmp[6],oFont10) // CGC

oPrint:Say  (1635,100 ,"Sacador/Avalista"                               ,oFont8)
oPrint:Say  (1675,1500,"Autentica??o Mec?nica -"                        ,oFont8)
oPrint:Say  (1675,1900,"Recibo do Sacado"								,oFont10)

oPrint:Line (0710,1900,1400,1900 )
oPrint:Line (1120,1900,1120,2300 )
oPrint:Line (1190,1900,1190,2300 )
oPrint:Line (1260,1900,1260,2300 )
oPrint:Line (1330,1900,1330,2300 )
oPrint:Line (1400,100 ,1400,2300 )
oPrint:Line (1640,100 ,1640,2300 )

oPrint:Code128C(1790,100,Alltrim(CB_RN_NN[1]), nFontSize )

For i := 100 to 2300 step 50
	oPrint:Line( 1930, i, 1930, i+30)                 // 1850
Next i

oPrint:Line (2080,100,2080,2300)                                                       //   2000
oPrint:Line (2080,550,1980, 550)                                                       //   2000 - 1900
oPrint:Line (2080,800,1980, 800)                                                       //    2000 - 1900

// LOGOTIPO

If File(aBmp)

	oPrint:SayBitmap( 1970,0100,aBmp,0100,0100 )
	oPrint:Say  (2050,240,"Banco Ita? SA",oFont10 )	// [2]Nome do Banco

Else

	oPrint:Say  (2054,100,aDadosBanco[2],oFont15n )	// [2]Nome do Banco                     1934

EndIf

oPrint:Say  (2054,569,"341-7",oFont24 )	// [1]Numero do Banco                       1912
oPrint:Say  (2054,820,CB_RN_NN[2],oFont14n)		//Linha Digitavel do Codigo de Barras   1934

oPrint:Line (2180,100,2180,2300 )
oPrint:Line (2280,100,2280,2300 )
oPrint:Line (2350,100,2350,2300 )
oPrint:Line (2420,100,2420,2300 )

oPrint:Line (2280, 500,2420,500)
oPrint:Line (2350, 750,2420,750)
oPrint:Line (2280,1000,2420,1000)
oPrint:Line (2280,1350,2350,1350)
oPrint:Line (2280,1550,2420,1550)

oPrint:Say  (2105,100 ,"Local de Pagamento"                             ,oFont8)
oPrint:Say  (2125,400 ,"Pag?vel em qualquer Banco at? o Vencimento."    ,oFont9)
oPrint:Say  (2165,400 ,"Ap?s o Vencimento pague somente no Banco Ita?." ,oFont9)

oPrint:Say  (2110,1910,"Vencimento"                                     ,oFont8)
oPrint:Say  (2150,2010,DtoC(aDadosTit[4])                               ,oFont10)

oPrint:Say  (2210,100 ,"Cedente"                                        ,oFont8)
oPrint:Say  (2250,100 ,aDadosEmp[1]+"                  - "+aDadosEmp[6]	,oFont10) //Nome + CNPJ

oPrint:Say  (2210,1910,"Ag?ncia/C?digo Cedente"                         ,oFont8)
oPrint:Say  (2250,2010,aDadosBanco[3]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5],oFont10)

oPrint:Say  (2305,100 ,"Data do Documento"                              ,oFont8)
oPrint:Say  (2340,100 ,DTOC(aDadosTit[2])                               ,oFont10) // Emissao do Titulo (E1_EMISSAO)

oPrint:Say  (2305,505 ,"Nro.Documento"                                  ,oFont8)
oPrint:Say  (2340,605 ,iif(SEA->EA_FILIAL <> '9001',alltrim(aDadosTit[7])+aDadosTit[1],aDadosTit[1]),oFont10) //Prefixo +Numero+Parcela

oPrint:Say  (2305,1005,"Esp?cie Doc."                                   ,oFont8)
oPrint:Say  (2340,1050,aDadosTit[8]										,oFont10) //Tipo do Titulo

oPrint:Say  (2305,1355,"Aceite"                                         ,oFont8)  // 2200
oPrint:Say  (2340,1455,"N"                                             ,oFont10)  // 2230

oPrint:Say  (2305,1555,"Data do Processamento"                          ,oFont8)       // 2200
oPrint:Say  (2340,1655,DTOC(aDadosTit[3])                               ,oFont10) // Data impressao  2230

oPrint:Say  (2305,1910,"Nosso N?mero"                                   ,oFont8)       // 2200
oPrint:Say  (2340,2010,Substr(aDadosTit[6],1,3)+"/"+Substr(aDadosTit[6],4),oFont10)  // 2230

oPrint:Say  (2380,100 ,"Uso do Banco"                                   ,oFont8)       // 2270

oPrint:Say  (2380,505 ,"Carteira"                                       ,oFont8)       // 2270
oPrint:Say  (2410,555 ,aDadosBanco[6]                                  	,oFont10)      //  2300

oPrint:Say  (2380,755 ,"Esp?cie"                                        ,oFont8)       //  2270
oPrint:Say  (2410,805 ,"R$"                                             ,oFont10)      //  2300

oPrint:Say  (2380,1005,"Quantidade"                                     ,oFont8)       //  2270
oPrint:Say  (2380,1555,"Valor"                                          ,oFont8)       //  2270

oPrint:Say  (2380,1910,"(=)Valor do Documento"                        	,oFont8)        //  2270
oPrint:Say  (2410,2010,AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),oFont10)  //   2300

oPrint:Say  (2460,100 ,"Instru??es (Todas informa??es deste bloqueto s?o de exclusiva responsabilidade do cedente)",oFont8) // 2340
oPrint:Say  (2600,100 ,aBolText[1]  ,oFont10)  // 2490  // *0.05)/30)
oPrint:Say  (2640,100 ,aBolText[2]  ,oFont10)    //2540
oPrint:Say  (2710,100 ,aBolText[3]                                       ,oFont10)

oPrint:Say  (2447,1910,"(-)Desconto/Abatimento"                         ,oFont8)      //  2340
oPrint:Say  (2513,1910,"(-)Outras Dedu??es"                             ,oFont8)      //  3410
oPrint:Say  (2587,1910,"(+)Mora/Multa"                                  ,oFont8)      //  2480
oPrint:Say  (2657,1910,"(+)Outros Acr?scimos"                           ,oFont8)      //  2550
oPrint:Say  (2730,1910,"(=)Valor Cobrado"                               ,oFont8)      //  2620

oPrint:Say  (2830,100 ,"Pagador:"                                       ,oFont8)
oPrint:Say  (2830,400 ,aDatSacado[1]+" ("+aDatSacado[2]+")"             ,oFont10)

If Len(Alltrim(aDatSacado[7])) = 18
	oPrint:Say  (2830,1850,"CNPJ: "+aDatSacado[7],oFont10) // CGC        2879
Else
	oPrint:Say  (2830,1850,"CPF: "+aDatSacado[7],oFont10) // CPF        2879
End

oPrint:Say  (2883,100 ,"Endere?o:"                                       ,oFont8)
oPrint:Say  (2883,400 ,aDatSacado[3]+' - '+aDatSacado[6]+" - "+aDatSacado[4]+" - "+aDatSacado[5],oFont10)

oPrint:Say  (2989,1850 ,aDadosEmp[6],oFont10) // CGC

oPrint:Say  (3005,100 ,"Sacador/Avalista"                               ,oFont8)
oPrint:Say  (3045,1500,"Autentica??o Mec?nica -"                        ,oFont8)
oPrint:Say  (3045,1850,"Ficha de Compensa??o"                           ,oFont10)      // 2935 + 280      = 3215

oPrint:Line (2080,1900,2770,1900 )
oPrint:Line (2490,1900,2490,2300 )
oPrint:Line (2560,1900,2560,2300 )
oPrint:Line (2630,1900,2630,2300 )
oPrint:Line (2700,1900,2700,2300 )
oPrint:Line (2770,100 ,2770,2300 )

oPrint:Line (3010,100 ,3010,2300 )

oPrint:Code128C(3145,100,Alltrim(CB_RN_NN[1]), nFontSize )

oPrint:EndPage() // Finaliza a p?gina

Return Nil
/*/
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????Ŀ??
???Fun??o    ? Modulo10    ?Descri??o?Faz a verificacao e geracao do digi-???
???          ?             ?         ?to Verificador no Modulo 10.        ???
??????????????????????????????????????????????????????????????????????????ٱ?
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
/*/
Static Function Modulo10(cData)
LOCAL L,D,P := 0
LOCAL B     := .F.
L := Len(cData)
B := .T.
D := 0
While L > 0
	P := Val(SubStr(cData, L, 1))
	If (B)
		P := P * 2
		If P > 9
			P := P - 9
		End
	End
	D := D + P
	L := L - 1
	B := !B
End
D := 10 - (Mod(D,10))
If D = 10
	D := 0
End
Return(D)
/*/
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????Ŀ??
???Fun??o    ? Modulo11    ?Descri??o?Faz a verificacao e geracao do digi-???
???          ?             ?         ?to Verificador no Modulo 11.        ???
??????????????????????????????????????????????????????????????????????????ٱ?
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
/*/
Static Function Modulo11(cData)
LOCAL L, D, P := 0
L := Len(cdata)
D := 0
P := 1
While L > 0
	P := P + 1
	D := D + (Val(SubStr(cData, L, 1)) * P)
	If P = 9
		P := 1
	End
	L := L - 1
End
D := 11 - (mod(D,11))
If (D == 0 .Or. D == 1 .Or. D == 10 .Or. D == 11)
	D := 1
End
Return(D)
//
//Retorna os strings para inpress?o do Boleto
//CB = String para o c?d.barras, RN = String com o n?mero digit?vel
//Cobran?a n?o identificada, n?mero do boleto = T?tulo + Parcela
//
//mj Static Function Ret_cBarra(cBanco,cAgencia,cConta,cDacCC,cCarteira,cNroDoc,nValor)
//
//					    		   Codigo Banco            Agencia		  C.Corrente     Digito C/C
//					               1-cBancoc               2-Agencia      3-cConta       4-cDacCC       5-cNroDoc              6-nValor
//	CB_RN_NN    := Ret_cBarra(Subs(aDadosBanco[1],1,3)+"9",aDadosBanco[3],aDadosBanco[4],aDadosBanco[5],"175"+AllTrim(E1_NUM),(E1_VALOR-_nVlrAbat) )
//
/*/
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????Ŀ??
???Fun??o    ?Ret_cBarra   ?Descri??o?Gera a codificacao da Linha digitav.???
???          ?             ?         ?gerando o codigo de barras.         ???
??????????????????????????????????????????????????????????????????????????ٱ?
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
/*/
Static Function Ret_cBarra(cBanco,cAgencia,cConta,cDacCC,cNroDoc,nValor,dVencto)
//
LOCAL bldocnufinal := strzero(val(cNroDoc),8)
LOCAL blvalorfinal := strzero(int(nValor*100),10)
LOCAL dvnn         := 0
LOCAL dvcb         := 0
LOCAL dv           := 0
LOCAL NN           := ''
LOCAL RN           := ''
LOCAL CB           := ''
LOCAL s            := ''
LOCAL _cfator      := strzero(dVencto - ctod("07/10/97"),4)
LOCAL _cCart	   := "109" //carteira de cobranca
//
//-------- Definicao do NOSSO NUMERO
s    :=  cAgencia + cConta + _cCart + bldocnufinal
dvnn := modulo10(s) // digito verifacador Agencia + Conta + Carteira + Nosso Num
NN   := _cCart + bldocnufinal + '-' + AllTrim(Str(dvnn))
//
//	-------- Definicao do CODIGO DE BARRAS
s    := cBanco + _cfator + blvalorfinal + _cCart + bldocnufinal + AllTrim(Str(dvnn)) + cAgencia + cConta + cDacCC + '000'
dvcb := modulo11(s)
CB   := SubStr(s, 1, 4) + AllTrim(Str(dvcb)) + SubStr(s,5)
//
//-------- Definicao da LINHA DIGITAVEL (Representacao Numerica)
//	Campo 1			Campo 2			Campo 3			Campo 4		Campo 5
//	AAABC.CCDDX		DDDDD.DEFFFY	FGGGG.GGHHHZ	K			UUUUVVVVVVVVVV
//
// 	CAMPO 1:
//	AAA	= Codigo do banco na Camara de Compensacao
//	  B = Codigo da moeda, sempre 9
//	CCC = Codigo da Carteira de Cobranca
//	 DD = Dois primeiros digitos no nosso numero
//	  X = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo
//
s    := cBanco + _cCart + SubStr(bldocnufinal,1,2)
dv   := modulo10(s)
RN   := SubStr(s, 1, 5) + '.' + SubStr(s, 6, 4) + AllTrim(Str(dv)) + '  '
//
// 	CAMPO 2:
//	DDDDDD = Restante do Nosso Numero
//	     E = DAC do campo Agencia/Conta/Carteira/Nosso Numero
//	   FFF = Tres primeiros numeros que identificam a agencia
//	     Y = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo
//
s    := SubStr(bldocnufinal, 3, 6) + AllTrim(Str(dvnn)) + SubStr(cAgencia, 1, 3)
dv   := modulo10(s)
RN   := RN + SubStr(s, 1, 5) + '.' + SubStr(s, 6, 5) + AllTrim(Str(dv)) + '  '
//
// 	CAMPO 3:
//	     F = Restante do numero que identifica a agencia
//	GGGGGG = Numero da Conta + DAC da mesma
//	   HHH = Zeros (Nao utilizado)
//	     Z = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo
s    := SubStr(cAgencia, 4, 1) + cConta + cDacCC + '000'
dv   := modulo10(s)
RN   := RN + SubStr(s, 1, 5) + '.' + SubStr(s, 6, 5) + AllTrim(Str(dv)) + '  '
//
// 	CAMPO 4:
//	     K = DAC do Codigo de Barras
RN   := RN + AllTrim(Str(dvcb)) + '  '
//
// 	CAMPO 5:
//	      UUUU = Fator de Vencimento
//	VVVVVVVVVV = Valor do Titulo
RN   := RN + _cfator + StrZero(Int(nValor * 100),14-Len(_cfator))
//
Return({CB,RN,NN})
//
/*/
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????Ŀ??
???Fun??o    ? ValidPerg   ?Descri??o?Verifica o Arquivo Sx1, criando as  ???
???          ?             ?         ?Perguntas se necessario.            ???
??????????????????????????????????????????????????????????????????????????ٱ?
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
/*/
Static Function ValidPerg()
Local i := 0
Local j:= 0
PRIVATE APERG := {},AALIASSX1:=GETAREA()
//
//     "X1_GRUPO"	,"X1_ORDEM"	,"X1_PERGUNT"      			,"X1_PERSPA"				,"X1_PERENG"				,"X1_VARIAVL"	,"X1_TIPO"	,"X1_TAMANHO"	,"X1_DECIMAL"	,"X1_PRESEL"	,"X1_GSC"	,"X1_VALID"	,"X1_VAR01"	,"X1_DEF01"	,"X1_DEFSPA1"	,"X1_DEFENG1"	,"X1_CNT01"	,"X1_VAR02"	,"X1_DEF02"	,"X1_DEFSPA2"	,"X1_DEFENG2"	,"X1_CNT02"	,"X1_VAR03"	,"X1_DEF03"	,"X1_DEFSPA3"	,"X1_DEFENG3"	,"X1_CNT03"	,"X1_VAR04"	,"X1_DEF04"	,"X1_DEFSPA4"	,"X1_DEFENG4"	,"X1_CNT04"	,"X1_VAR05"	,"X1_DEF05"	,"X1_DEFSPA5"	,"X1_DEFENG5"	,"X1_CNT05"	,"X1_F3"	,"X1_PYME"	,"X1_GRPSXG"	,"X1_HELP"
//
AADD(APERG,{CPERG  ,"01"		,"Prefixo?"     			,"Prefixo?"    		    	,"Prefixo?"     			,"mv_ch1"		,"C"		,3 				,0 				,0 				,"G"		,""			,"mv_par01"	,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,""   		,"S"		,""				,""})
AADD(APERG,{CPERG  ,"02"		,"Numero?"         		    ,"Numero?"                  ,"Numero?"          		,"mv_ch2"		,"C"		,6 				,0 				,0 				,"G"		,""			,"mv_par02"	,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,""   		,"S"		,""				,""})
AADD(APERG,{CPERG  ,"03"		,"Da Parcela?"     			,"Da Parcela?"		    	,"Da Parcela?"		    	,"mv_ch3"		,"C"		,1 			    ,0 				,0 				,"G"		,""			,"mv_par03"	,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,""   		,"S"		,""				,""})
AADD(APERG,{CPERG  ,"04"		,"Ate a Parcela?"    		,"Ate a Parcela?"     		,"Ate a Parcela?"     		,"mv_ch4"		,"C"		,1 			    ,0 				,0 				,"G"		,""			,"mv_par04"	,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,""   		,"S"		,""				,""})
//
DBSELECTAREA("SX1")
DBSETORDER(1)

_nLen := Len( aPerg )

for i := 1 To _nLen
	IF  !DBSEEK(CPERG+APERG[I,2])
		RECLOCK("SX1",.T.)
		FOR J := 1 TO FCOUNT()
			IF  j <= LEN(APERG[I])
				FIELDPUT(J,APERG[I,J])
			ENDIF
		NEXT
		SX1->(MSUNLOCK())
	ENDIF
NEXT
RESTAREA(AALIASSX1)
//

RETURN()


Static Function PreNota()

If ( TMP->( Eof() ) )

   TMP->( dbCloseArea() )

   _cQry := 'SELECT CLI.NOME,'
   _cQry += 'CASE VDO.ID_VENDEDOR '
   _cQry += "  WHEN  5 THEN 'Andre'"
   _cQry += "  WHEN 25 THEN 'Elisa'"
   _cQry += "  WHEN 43 THEN 'Fernanda.Alves'"
   _cQry += "  WHEN 36 THEN 'Jessica'"
   _cQry += "  WHEN 40 THEN 'Joao.Ferreira'"
   _cQry += "  WHEN 34 THEN 'Marcos'"
   _cQry += "  WHEN  4 THEN 'Mauro'"
   _cQry += "  WHEN 24 THEN 'Ricardo.Lima'"
   _cQry += "  WHEN 23 THEN 'Ronaldo'"
   _cQry += "  WHEN  3 THEN 'Wagner'"
   _cQry += "  ELSE 'Corporativo'"
   _cQry += 'END Vendedor, CTO.EMAIL '
   _cQry += 'FROM '+cBDGSTQ+'.dbo.PRE_NOTA VCT '
   _cQry += 'LEFT OUTER JOIN '+cBDGSTQ+'.dbo.CLIENTE CLI ON CLI.ID_CLIENTE = VCT.ID_CLIENTE '
   _cQry += 'LEFT OUTER JOIN '+cBDGSTQ+'.dbo.VENDEDOR VDO ON VDO.ID_VENDEDOR = CLI.ID_VENDEDOR '
   _cQry += "LEFT OUTER JOIN "+cBDGSTQ+".dbo.CLIENTE_CONTATO CTO ON CLI.ID_CLIENTE = CTO.ID_CLIENTE AND NFE = 'S' "
   _cQry += 'WHERE VCT.NRO_NF = ' + Alltrim( Str( Val(SE1->E1_NUM), 9, 0 ) )

   dbUseArea( .T.,"TOPCONN",TcGenQry(,,_cQry),"TMP",.T.,.T.)

End

Return( NIL )
