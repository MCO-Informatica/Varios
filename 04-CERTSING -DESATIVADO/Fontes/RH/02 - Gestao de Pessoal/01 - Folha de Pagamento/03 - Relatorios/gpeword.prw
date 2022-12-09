#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH" 
#INCLUDE "MSOLE.CH"
#INCLUDE "GPEWORD.CH"

/*
U_CSRHWORD
Desc: Impressao de Documentos tipo Word - RDMAKE
Uso: Protheus 12  - RH_Certisign
TOTVS(Marinaldo de Jesus) - 05/07/2000  

Alterado em 07/11/2017 - Opvs (Bruno Nunes)
Alteracao: Revisão do fonte para funcionar no P12.
*/  
User Function CSRHWORD()
	local cCampo  	:= ""
	local oDlg			:= nil
	local oPanel1 	:= nil
	local oPanel2 	:= nil
	local oTButton1	:= nil
	local oTButton2	:= nil
	local oTButton3	:= nil
	local oTButton4	:= nil
	local oSay1		:= nil
	local oSay2		:= nil
	local oGroup1 	:= nil
	local oTFontBut 	:= TFont():New('Tahoma',,14,,.T.)
	local oTFont 		:= TFont():New('Tahoma',,14,,.F.)
	
	private aInfo			:= {}
	private aDepenIR		:= {}
	private aDepenSF		:= {}
	private aPerSRF 		:= {}
	private cPerg			:= 'GPWORD'
	private cCompEndEmp 	:= ''
	private nDepen		:= 0
	private cNomeProces 	:= ''
	private cHoraIni 	  	:= ''
	private cHoraFim 	  	:= ''
	private nHrInter     := 0
	
	//private DFIMPAQUI	:= 0
	//private DPRPAQUI	:= 0
	
	//Tratando os espacos do novo tamanho do X1_GRUPO
	cPerg	:= cPerg + (Space( Len(SX1->X1_GRUPO)  - Len(cPerg) ) )
	Pergunte(cPerg,.F.)
	     
	OpenProfile()
	
	//Avalia o conteudo ja existente no profile e o altera se necessario   
	//para que o erro nao ocorra apos a atualizacao do sistema.            
	if ( ProfAlias->( DbSeek( SM0->M0_CODIGO + Padl( CUSERNAME, 13 ) + "GPWORD    ") ) )
		cCompEndEmp := SM0->M0_COMPCOB
		cCampo := SubStr( AllTrim( ProfAlias->P_DEFS ), 487, 75 )
		if !( ".DOT" $ UPPER( cCampo ) )
			RecLock( "ProfAlias", .F. )
			ProfAlias->P_DEFS := ""
			ProfAlias->( MsUnLock() )
		endif
	endif
		
	//Tela Principal	
	oDlg := TDialog():New(0,0,250,700,OemToAnsi(STR0001) ,,,,,,,,,.T.)

	//Painel dos textos
	oPanel1 := tPanel():New(01,01,"",oDlg,,.T.,,,,100,100)
	oPanel1:Align := CONTROL_ALIGN_ALLCLIENT
	oGroup1:= TGroup():New(10,02,130,130,'Importante',oPanel1,,,.T.)
	oGroup1:Align := CONTROL_ALIGN_ALLCLIENT  
	oSay1	:= TSay():New(12,12,{||OemToAnsi(STR0002)+' '+OemToAnsi(STR0003)},oGroup1,,oTFont,,,,.T.,,,/*200*/,/*20*/)
	oSay1:Align := CONTROL_ALIGN_TOP	

	//Painel dos botoes
  	oPanel2 := tPanel():New(01,01,"",oDlg,,.T.,,,,20,20)
  	oPanel2:Align := CONTROL_ALIGN_BOTTOM
  	oTButton1 := TButton():New( 002, 002, "Parâmetros"		, oPanel2, { || fPerg_Word() , Pergunte(cPerg,.T.) } 			, 70,10,,oTFontBut,.F.,.T.,.F.,,.F.,,,.F. )
  	oTButton1:Align := CONTROL_ALIGN_LEFT
  	oTButton2 := TButton():New( 002, 002, "Imp. Variáveis"	, oPanel2, { || fPerg_Word() , ( nDepen := 0,fVarW_Imp() ) }  	, 70,10,,oTFontBut,.F.,.T.,.F.,,.F.,,,.F. )
  	oTButton2:Align := CONTROL_ALIGN_LEFT
  	oTButton3 := TButton():New( 002, 002, "Gerar Word"		, oPanel2, { || fPerg_Word() , fWord_Imp() } 						, 70,10,,oTFontBut,.F.,.T.,.F.,,.F.,,,.F. )
  	oTButton3:Align := CONTROL_ALIGN_LEFT
  	oTButton4 := TButton():New( 002, 002, "Fechar"			, oPanel2, { || Close(oDlg) }										, 70,10,,oTFontBut,.F.,.T.,.F.,,.F.,,,.F. )
  	oTButton4:Align := CONTROL_ALIGN_RIGHT
  	
	oDlg:Activate(,,,.T. )
Return( NIL )
	
/*
fWord_Imp
Desc: Impressao do Documento Word  
Uso: Protheus 12  - RH_Certisign
TOTVS(Marinaldo de Jesus) - 05/07/2000  

Alterado em 07/11/2017 - Opvs (Bruno Nunes)
Alteracao: Revisão do fonte para funcionar no P12.
*/
Static Function fWord_Imp()
	local aCampos		:= {}
	local cExclui		:= ""
	local cFilAnt   	:= Space(2)//Space(FWGETTAMFILIAL)
	local cAcessaSRA	:= &( " { || " + ChkRH( "GPEWORD" , "SRA" , "2" ) + " } " )	
	local cFilDe		:= mv_par01
	local cFilAte		:= mv_par02
	local cCcDe		:= mv_par03
	local cCcAte		:= mv_par04
	local cMatDe		:= mv_par05
	local cMatAte		:= mv_par06
	local cNomeDe		:= mv_par07
	local cNomeAte	:= mv_par08
	local cTnoDe		:= mv_par09
	local cTnoAte		:= mv_par10
	local cFunDe		:= mv_par11
	local cFunAte		:= mv_par12
	local cSindDe		:= mv_par13
	local cSindAte	:= mv_par14
	local cSituacao	:= mv_par17
	local cCategoria	:= mv_par18
	local cArqWord	:= mv_par25
	local cArqSaida 	:= AllTrim( mv_par29 )
	local cListaArq	:= ''
	local cArqAux		:= ''	
	local cAux			:= ''
	local cPath 		:= GETTEMPPATH()
	local dAdmiDe		:= mv_par15
	local dAdmiAte	:= mv_par16
	local lDepende	:= if (Mv_par26 = 1, .T., .F.)	
	local lImpress	:= ( mv_par28 == 1 )	
	local nCopias		:= if ( Empty(mv_par23),1,mv_par23 ) 
	local nOrdem		:= mv_par24
	local nDepende  	:= mv_par27
	local nX			:= 0
	local nSvOrdem	:= 0
	local nSvRecno	:= 0
	local nAt			:= 0
	local oWord		:= NIL
	
	nDepen	:= if ( ! lDepende, 4,nDepende )
	
	//Checa o SO do Remote (1=Windows, 2=Linux)
	if GetRemoteType() == 2
		MsgAlert(OemToAnsi(STR0167), OemToAnsi(STR0168))	//?-"Integração Word funciona somente com Windows !!!")###"Atenção !"
		Return	
	endif
	
	//Verifica se o usuario escolheu um drive local (A: C: D:) caso contrario
	//busca o nome do arquivo de modelo,  copia para o diretorio temporario  
	//do windows e ajusta o caminho completo do arquivo a ser impresso.      
	if substr(cArqWord,2,1) <> ":"
		cAux 	:= cArqWord
		nAt		:= 1
		for nx := 1 to len(cArqWord)
			cAux := substr( cAux, If( nx==1, nAt, nAt+1 ),len(cAux))
			nAt := at("\",cAux)
			if nAt == 0
				Exit
			endif
		next nx
		CpyS2T(cArqWord,cPath, .T.)
		cArqWord	:= cPath+cAux
	endif
	
	//Bloco que definira a Consistencia da Parametrizacao dos Intervalos selecionados nas Perguntas De? Ate?.
	cExclui := cExclui + "{ || "
	cExclui := cExclui + "(RA_FILIAL  < cFilDe     .or. RA_FILIAL  > cFilAte    ).or."
	cExclui := cExclui + "(RA_MAT     < cMatDe     .or. RA_MAT     > cMatAte    ).or." 
	cExclui := cExclui + "(RA_CC      < cCcDe      .or. RA_CC      > cCCAte     ).or." 
	cExclui := cExclui + "(RA_NOME    < cNomeDe    .or. RA_NOME    > cNomeAte   ).or." 
	cExclui := cExclui + "(RA_TNOTRAB < cTnoDe     .or. RA_TNOTRAB > cTnoAte    ).or." 
	cExclui := cExclui + "(RA_CODFUNC < cFunDe     .or. RA_CODFUNC > cFunAte    ).or." 
	cExclui := cExclui + "(RA_SINDICA < cSindDe    .or. RA_SINDICA > cSindAte   ).or." 
	cExclui := cExclui + "(RA_ADMISSA < dAdmiDe    .or. RA_ADMISSA > dAdmiAte   ).or." 
	cExclui := cExclui + "!(RA_SITFOLH$cSituacao).or.!(RA_CATFUNC$cCategoria)"
	cExclui := cExclui + " } "
		
	dbSelectArea("SRA")
	nSvOrdem := IndexOrd() 
	nSvRecno := Recno()
	dbGotop()
	
	//Posicionando no Primeiro Registro do Parametro              
	if nOrdem == 1	   							//Matricula
		dbSetOrder(nOrdem)
		dbSeek( cFilDe + cMatDe , .T. )
		cInicio := '{ || RA_FILIAL + RA_MAT }'
		cFim    := cFilAte + cMatAte
	elseif nOrdem == 2							//Centro de Custo
		dbSetOrder(nOrdem)
		dbSeek( cFilDe + cCcDe + cMatDe , .T. )
		cInicio  := '{ || RA_FILIAL + RA_CC + RA_MAT }'
		cFim     := cFilAte + cCcAte + cMatAte
	elseif nOrdem == 3							//Nome 
		dbSetOrder(nOrdem)
		dbSeek( cFilDe + cNomeDe + cMatDe , .T. )
		cInicio := '{ || RA_FILIAL + RA_NOME + RA_MAT }'
		cFim    := cFilAte + cNomeAte + cMatAte
	elseif nOrdem == 4							//Turno 
		dbSetOrder(nOrdem)
		dbSeek( cFilDe + cTnoDe ,.T. )
		cInicio  := '{ || RA_FILIAL + RA_TNOTRAB } '
		cFim     := cFilAte + cCcAte + cNomeAte
	elseif nOrdem == 5							//Admissao 
		cIndCond:= "RA_FILIAL + DTOS (RA_ADMISSA)"
	   	cArqNtx  := CriaTrab(Nil,.F.)
	   	IndRegua("SRA",cArqNtx,cIndCond,,,STR0162)		//"Selecionando Registros..."
		dbSeek( cFilDe + DTOS(dAdmiDe) ,.T. )
		cInicio  :='{ || RA_FILIAL + DTOS(RA_ADMISSA)}' 
		cFim     := cFilAte + DTOS(dAdmiAte)
	endif
	
	cFilialAnt := Space(2)//xFilial("SRA")//Space(2)//FWGETTAMFILIAL
	//Ira Executar Enquanto Estiver dentro do Escopo dos Parametros
	While SRA->( !Eof() .and. Eval( &(cInicio) ) <= cFim )
		//Inicializa o Ole com o MS-Word 97 ( 8.0 )
		oWord	:= OLE_CreateLink() 
		OLE_NewFile( oWord , cArqWord )	
	
		//Consiste Parametrizacao do Intervalo de Impressao
		if SRA->( Eval ( &(cExclui) ) )
	   		dbSelectArea("SRA")
	    	dbSkip()
	    	Loop
	    endif
		    		    
		//Consiste Filiais e Acessos
		if !( SRA->RA_FILIAL $ fValidFil() .and. Eval( cAcessaSRA ) )
			dbSelectArea("SRA")
	    	dbSkip()
	   		Loop
		endif 
			
		//Consiste os dependentes  de Salario Familia 
		if lDepende
			if nDepende == 1 //Salario Familia //
				//Consiste os dependentes  de Salario Familia
				if SRB->(dbSeek(SRA->RA_Filial+SRA->RA_Mat,.F.))         
			   		fDepSF( )
				else
					SRA->(dbSkip())
					Loop
				endif		
			elseif nDepende == 2 //Imposto de Renda	//
				//Consiste os dependentes  de Imposto de Renda
	   			if SRB->(dbSeek(SRA->RA_Filial+SRA->RA_Mat,.F.))
		    		fDepIR( )
		    	else
					SRA->(dbSkip())
					Loop
				endif	
			elseif nDepende == 3 // Todos os Tipos de Dependente (Salario Familia e Imposto de Renda //
				//Consiste todos os tipos de Dependentes
	   			if SRB->(dbSeek(SRA->RA_Filial+SRA->RA_Mat,.F.))         
		       	fDepIR( )
		       else
					SRA->(dbSkip())
					Loop
				endif
				if SRB->(dbSeek(SRA->RA_Filial+SRA->RA_Mat,.F.))         
		    		fDepSF( )
		    	else                                                                         
					SRA->(dbSkip())
					Loop
				endif	
			endif
		
			if (nDepende == 1)
				if  empty(aDepenSF[1,1])
					SRA->(dbSkip())
					Loop
				endif	
			elseIf	(nDepende == 2)
				if  empty(aDepenIR[1,1])
					SRA->(dbSkip())
					Loop
				endif	          
			elseIf	(nDepende == 3)
				if  empty(aDepenIR[1,1])  .and. empty(aDepenSF[1,1])
					SRA->(dbSkip())
					Loop
				endif
			endif	                                                          
		endif			
	
		fPesqSRF()//Busca Periodo Aquisitivo
	    
		//Carregando Informacoes da Empresa
		if SRA->RA_FILIAL # cFilialAnt
			if !fInfo(@aInfo,SRA->RA_FILIAL)
				//Encerra o Loop se Nao Carregar Informacoes da Empresa
				Exit
			endif			

			//Atualiza a Variavel cFilialAnt
			dbSelectArea("SRA")
			cFilialAnt := SRA->RA_FILIAL
		endif	
		
		//Posicionar RCJ - Cadastro de Processo          RA_PROCES
		RCJ->(dbSetOrder(1))
		if RCJ->(dbSeek(xFilial('RCJ')+SRA->RA_PROCES))
			cNomeProces := RCJ->RCJ_DESCRI
		else 
			cNomeProces := ''
		endif

		//Leitura de turno trabalho
		TurnoTrab()

		//Carrega Campos Disponiveis para Edicao
		aCampos := fCpos_Word()
	   
		//Ajustando as Variaveis do Documento
		Aeval(	aCampos,; 
					{ |x| OLE_SetDocumentVar( oWord, x[1] ,;
													IF( Subst( AllTrim( x[3] ) , 4 , 2 )  == "->" ,; 
														Transform( x[2] , PesqPict( Subst( AllTrim( x[3] ) , 1 , 3 ),;
																	Subst( AllTrim( x[3] ), - ( Len( AllTrim( x[3] ) ) - 5 ) ) ) ),; 
														Transform( x[2] , x[3] );
					  								); 
												);
					};
				 )
	        	
		//Atualiza as Variaveis
	    OLE_UpDateFields( oWord )
	
		//Imprimindo o Documento
		if lImpress
			cArqAux := SRA->RA_MAT+' - '+SRA->RA_NOME
			for nX := 1 To nCopias
				OLE_SetProperty( oWord, '208', .F. ) ; OLE_PrintFile( oWord )
			next nX
		else
			cArqAux := cArqSaida+NomeArq( cArqWord )	
			OLE_SaveAsFile( oWord, cArqAux )
		endif
		cListaArq += cArqAux + CRLF
			
		dbSelectArea("SRA")                                               
		dbSkip()
		//Iniciliaza array 
		aDepenIR:= {}
		aDepenSF:= {}
		aPerSRF := {}

		//Encerrando o Link com o Documento
		OLE_CloseLink( oWord )
		if Len(cAux) > 0
			fErase(cArqWord)
		endif	        
	enddo	
	
	if lImpress
		Aviso( 'Documento Word' , 'Arquivo(s) enviados para impressão:'+CRLF+cListaArq	, { 'Ok' }, 3 )
	else
		Aviso( 'Documento Word' , 'Arquivo(s) criado(s):'+CRLF+cListaArq					, { 'Ok' }, 3 )
	endif

	//Restaurando dados de Entrada
	dbSelectArea('SRA')
	dbSetOrder( nSvOrdem )
	dbGoTo( nSvRecno )
Return( NIL )
	
/*
fWord_Imp
Desc: Selecionaro os Arquivos do Word
Uso: Protheus 12  - RH_Certisign
TOTVS(Marinaldo de Jesus) - 05/07/2000  

Alterado em 07/11/2017 - Opvs (Bruno Nunes)
Alteracao: Revisão do fonte para funcionar no P12.

Alterado em.: 18/04/2018 - CERTISIGN (Alexandre Alves)
OTRS........: 2018041710004674
Alteracao...: Adequação do nome da User Funciton abaixo, passando de fOpenWrd para o padrão fOpWord.
              Ocorre que a cada atualização de sistema onde o dicionario (SX1) sofre intervenção da TOTVS, 
              o pergunte relaciona faz chamada à função fOpWord.    

*/
User Function fOpWord() //fOpenWrd
	local cSvAlias	:= Alias()
	local cTipo		:= "Modelo de Documentos(*.DOT)  |*.DOT | "														
	local cNewPathArq	:= cGetFile( cTipo , STR0007 )									
	local lAchou		:= .F.
	
	if !Empty( cNewPathArq )
		if Len( cNewPathArq ) > 75
	    	MsgAlert( STR0187 ) //"O endereco completo do local onde está o arquivo do Word excedeu o limite de 75 caracteres!"
	    	Return			
		else
			if Upper( Subst( AllTrim( cNewPathArq), - 3 ) ) == Upper( AllTrim( STR0008 ) )	
				Aviso( STR0009 , cNewPathArq , { STR0010 } )								
		    else
		    	MsgAlert( STR0011 )															
		    	Return
		    endif
		endif
	else
	    Aviso(STR0012 ,STR0007,{ STR0010 } )//Aviso(STR0012 ,{ STR0010 } )													
	    Return
	endif
	
	//Limpa o parametro para a Carga do Novo Arquivo
	dbSelectArea("SX1")  
	if lAchou := ( SX1->( dbSeek( cPerg + "25" , .T. ) ) )
		RecLock("SX1",.F.,.T.)
		SX1->X1_CNT01 := Space( Len( SX1->X1_CNT01 ) )
		mv_par25 := cNewPathArq
		MsUnLock()
	endif	
	dbSelectArea( cSvAlias )
Return(.T.)
	
/*
fWord_Imp
Desc: Impressao das Variaveis disponiveis para uso
Uso: Protheus 12  - RH_Certisign
TOTVS(Marinaldo de Jesus) - 05/07/2000  

Alterado em 07/11/2017 - Opvs (Bruno Nunes)
Alteracao: Revisão do fonte para funcionar no P12.
*/
Static Function fVarW_Imp()
	local aOrd		:= {STR0142,STR0143}
	local cString	:= 'SRA'                                	     
	local cDesc1	:= STR0144
	local cDesc2	:= STR0145                     
	local cDesc3	:= STR0146                                
	
	private aLinha	:= {}	
	private AT_PRG	:= 'GPEWORD'
	private aReturn	:= {STR0147, 1,STR0148, 2, 2, 1, '',1 }
	private ContFl	:= 1
	private cBtxt		:= ""
	private nomeProg	:= 'GPEWORD'
	private nLastKey	:= 0
	private nTamanho	:= "P"
	private lEnd		:= .F.
	private Li			:= 0
	private Titulo	:= cDesc1
	private wCabec0	:= 1
	private wCabec1	:= STR0149
	private wCabec2	:= ""
	private wCabec3	:= ""
	
	//Envia controle para a funcao SETPRINT
	WnRel := "WORD_VAR" 
	WnRel := SetPrint(cString,Wnrel,"",Titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,nTamanho,,.F.)
	
	if nLastKey == 27
		Return( NIL )
	endif
	
	SetDefault(aReturn,cString)
	
	if nLastKey == 27
		Return( NIL )
	endif
	
	//Chamada do Relatorio.
	RptStatus( { |lEnd| fImpVar() } , Titulo )
Return( NIL )
	
/*
fImpVar
Desc: Impressao das Variaveis disponiveis para uso
Uso: Protheus 12  - RH_Certisign
TOTVS(Marinaldo de Jesus) - 05/07/2000  

Alterado em 07/11/2017 - Opvs (Bruno Nunes)
Alteracao: Revisão do fonte para funcionar no P12.
*/
Static Function fImpVar()
	local nOrdem	:= aReturn[8]
	local aCampos	:= {}
	local nX		:= 0
	local cDetalhe	:= ""
	
	//Carregando Informacoes da Empresa 
	if !fInfo(@aInfo,xFilial("SRA"))
		Return( NIL )
	endif			
	
	//Carregando Variaveis 
	aCampos := fCpos_Word()
	
	//Ordena aCampos de Acordo com a Ordem Selecionada        
	if nOrdem = 1
		aSort( aCampos , , , { |x,y| x[1] < y[1] } )
	else
		aSort( aCampos , , , { |x,y| x[4] < y[4] } )
	endif
	
	//Carrega Regua de Processamento         
	SetRegua( Len( aCampos ) )
	
	//Impressao do Relatorio          
	for nX := 1 To Len( aCampos )
		//Movimenta Regua Processamento
		IncRegua()  
	
		//Cancela Impressao
	    if lEnd
	    	@ Prow()+1,0 PSAY cCancel
	       Exit
		endif            
	
		//Mascara do Relatorio
	  	//|        10        20        30        40        50        60        70        80
	  	//|12345678901234567890123456789012345678901234567890123456789012345678901234567890
		//|Variaveis                      Descricao
		//|XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
	
		//Carregando Variavel de Impressao
		cDetalhe := IF( Len( AllTrim( aCampos[nX,1] ) ) < 30 , AllTrim( aCampos[nX,1] ) + ( Space( 30 - Len( AllTrim ( aCampos[nX,1] ) ) ) ) , aCampos[nX,1] )
		cDetalhe := cDetalhe + AllTrim( aCampos[nX,4] )
	      	
		//Imprimindo Relatorio
	    Impr( cDetalhe )
	next nX
	
	if aReturn[5] == 1
		Set Printer To
		dbCommit()
		OurSpool(WnRel)
	endif
	
	//Apaga indices temporarios
	if nOrdem == 5
		fErase( cArqNtx + OrdBagExt() )
	endif                      
	
	MS_FLUSH()
Return( NIL )
	
/*
fPerg_Word
Desc: Grava as Perguntas utilizadas no Programa no SX1
Uso: Protheus 12  - RH_Certisign
TOTVS(Marinaldo de Jesus) - 05/07/2000  

Alterado em 07/11/2017 - Opvs (Bruno Nunes)
Alteracao: Revisão do fonte para funcionar no P12.
*/
Static Function fPerg_Word()
	local aArea		:= getarea()
	
	//Ajusta o tamanho da pergunta 25 - Arquivo do Word
	dbselectarea("SX1")
	if dbseek(cPerg+"25")
		Reclock("SX1",.f.)
		SX1->X1_TAMANHO		:= 75
		MsUnlock()
	endif
	
	//Retorna para a area corrente.
	restarea(aArea)
Return( Nil )
	
/*
fDepIR
Desc: Carrega Dependentes de Imp. de Renda
Uso: Protheus 12  - RH_Certisign
TOTVS(Marinaldo de Jesus) - 05/07/2000  

Alterado em 07/11/2017 - Opvs (Bruno Nunes)
Alteracao: Revisão do fonte para funcionar no P12.
*/
Static Function fDepIR( )
	local Nx 		:= 0
	local nVezes 	:= 0

	//Consiste os dependentes  de I.R.
	aDepenIR:= {}
	Do  while SRB->RB_FILIAL+SRB->RB_MAT == SRA->RA_FILIAL+SRA->RA_MAT
		if	(SRB->RB_TipIr == '1') .Or.;
         	(SRB->RB_TipIr == '2' .And. Year(dDataBase)-Year(SRB->RB_DtNasc) <= 21) .Or. ;
       	(SRB->RB_TipIr == '3' .And. Year(dDataBase)-Year(SRB->RB_DtNasc) <= 24)
			//Nome do Depend., Dta Nascimento,Grau de parentesco
      		aAdd(aDepenIR,{left(SRB->RB_Nome,30),SRB->RB_DtNasc,If(SRB->RB_GrauPar=='C','Conjuge   ',If(SRB->RB_GrauPar=='F','Filho     ','Outros    '))   })
       endif
      	SRB->(dbSkip())
	enddo 
	if Len(aDepenIR) < 10
		nVezes := (10 - Len(aDepenIR))
		for Nx := 1 to nVezes
			aAdd(aDepenIR,{Space(30),Space(10),Space(10) } )
		next Nx
	endif
Return(aDepenIR)
	
/*
fDepSF
Desc: Carrega Dependentes de Salario Familia
Uso: Protheus 12  - RH_Certisign
TOTVS(Marinaldo de Jesus) - 05/07/2000  

Alterado em 07/11/2017 - Opvs (Bruno Nunes)
Alteracao: Revisão do fonte para funcionar no P12.
*/
Static Function  fDepSF()
	local Nx 		:= 0
	local nVezes 	:= 0

	//Consiste os dependentes  de I.R.
	aDepenSF:= {}
   	do while SRB->RB_FILIAL+SRB->RB_MAT == SRA->RA_FILIAL+SRA->RA_MAT
		if (SRB->RB_TipSf == '1') .Or. (SRB->RB_TipSf == '2' .And. ;
			Year(dDataBase) - Year(SRB->RB_DtNasc) <= 14)
			//Nome do Depend., Dta Nascimento,Grau Parent.,local Nascimento,Cartorio,Numero Regr.,Numero do Livro, Numero da Folha, Data Entrega,Data baixa. //
      		aAdd(aDepenSF,{left(SRB->RB_Nome,30),SRB->RB_DtNasc,If(SRB->RB_GrauPar=='C','Conjuge   ',If(SRB->RB_GrauPar=='F','Filho     ','Outros    ')),;
      						SRB->RB_LOCNASC,SRB->RB_CARTORI,SRB->RB_NREGCAR,SRB->RB_NUMLIVR,SRB->RB_NUMFOLH,SRB->RB_DTENTRA,SRB->RB_DTBAIXA})
		endif
		SRB->(dbSkip())
	enddo
   	if  Len(aDepenSF) < 10
      	nVezes := (10 - Len(aDepenSF))
		for Nx := 1 to nVezes
			 aAdd(aDepenSF,{Space(30),Space(10),Space(10),Space(10),Space(10),Space(10),Space(10),Space(10),Space(10),Space(10) } )
		next Nx
	endif
Return(aDepenSF)
	
/*
fPesqSRF
Desc: Carrega Periodo Aquisitivo SRF
Uso: Protheus 12  - RH_Certisign
TOTVS(Marinaldo de Jesus) - 05/07/2000  

Alterado em 07/11/2017 - Opvs (Bruno Nunes)
Alteracao: Revisão do fonte para funcionar no P12.
*/
Static Function  fPesqSRF()
	local cAliasSRF := "SRF"
	/* Rotina de Busca Periodo Aquisitivo SRF */
	
	aPerSRF := {}
		
	/*
	dbSelectArea(cAliasSRF)
	
	dbSetOrder(RETORDER(cAliasSRF,"RF_FILIAL+RF_MAT+DTOS(RF_DATABAS") )
	
	if dbSeek(SRA->RA_FILIAL+SRA->RA_MAT)
   
		While !Eof() .And. SRF->RF_MAT == SRA->RA_MAT         // TRAVEI AKI
				       	
			DFIMPAQUI := fCalcFimAq((cAliasSRF)->RF_DATABAS) 	// Monta a data Final do Periodo Aquisitivo
			DPRPAQUI  := fCalcFimAq(DFIMPAQUI+1) 				// Monta a data Limite Maxima 
			//cPerAquis	:= DtoC((cAliasSRF)->RF_DATABAS)+Space(2)+DtoC(DFIMPAQUI) 	//-- Periodo aquisitivo 
			//cLimideal	:= DtoC(DFIMPAQUI + 30)  					//-- Data limite Ideal
			//cLimMax		:= DtoC(DPRPAQUI - 45 )  					//-- Data Limite Maximo

			aAdd(aPerSRF,{SRF->RF_DATABAS,DFIMPAQUI,DPRPAQUI } )
			SRF->(dbSkip())
		enddo

	endif
	*/	
Return(aPerSRF)
	
/*
fCpos_Word
Desc: Retorna Array com as Variaveis Disponiveis para Impressao
		aExp[x,1] - Variavel Para utilizacao no Word (Tam Max. 30)  
		aExp[x,2] - Conteudo do Campo                (Tam Max. 49)  
		aExp[x,3] - Campo para Pesquisa da Picture no X3 ou Picture 
		aExp[x,4] - Descricao da Variaval                           
Uso: Protheus 12  - RH_Certisign
TOTVS(Marinaldo de Jesus) - 05/07/2000  

Alterado em 07/11/2017 - Opvs (Bruno Nunes)
Alteracao: Revisão do fonte para funcionar no P12.
*/
Static Function fCpos_Word()
	local aExp			:= {}
	local cTexto_01	:= AllTrim( mv_par19 )
	local cTexto_02	:= AllTrim( mv_par20 )
	local cTexto_03	:= AllTrim( mv_par21 )
	local cTexto_04	:= AllTrim( mv_par22 ) 
	local cApoderado	:= ""
	local cRamoAtiv	:= ""   
	
	if cPaisLoc == "ARG"
		if fPHist82(xFilial(),"99","01")
			cApoderado := SubStr(SRX->RX_TXT,1,30)
		endif
		if fPHist82(xFilial(),"99","02")
			cRamoAtiv := SubStr(SRX->RX_TXT,1,50) 
		endif	           
	endif	
	
	aAdd( aExp, {'GPE_FILIAL'				,	SRA->RA_FILIAL 										  			, "SRA->RA_FILIAL"		,STR0013	} ) 
	aAdd( aExp, {'GPE_MATRICULA'			,	SRA->RA_MAT														, "SRA->RA_MAT"			,STR0014	} ) 
	aAdd( aExp, {'GPE_CENTRO_CUSTO'			,	SRA->RA_CC															, "SRA->RA_CC"			,STR0015	} ) 
	aAdd( aExp, {'GPE_DESC_CCUSTO'			,	fDesc("SI3",SRA->RA_CC,"I3_DESC")		 						, "@!"						,STR0016	} ) 
	aAdd( aExp, {'GPE_NOME'		   			,	SRA->RA_NOME														, "SRA->RA_NOME"			,STR0017	} ) 
	aAdd( aExp, {'GPE_NOMECMP'           	,   If(SRA->(FieldPos("RA_NOMECMP")) # 0  ,SRA->RA_NOMECMP,space(40)), "@!"           	,STR0017 	} )
	aAdd( aExp, {'GPE_CPF'		   			,	SRA->RA_CIC														, "SRA->RA_CIC"			,STR0018	} ) 
	aAdd( aExp, {'GPE_PIS'		   			,	SRA->RA_PIS														, "SRA->RA_PIS"			,STR0019	} ) 
	aAdd( aExp, {'GPE_RG'		   			,	SRA->RA_RG															, "SRA->RA_RG"			,STR0020	} ) 
	aAdd( aExp, {'GPE_RG_ORG'	   			,	SRA->RA_RGORG														, "@!"						,STR0152	} ) 
	aAdd( aExp, {'GPE_CTPS'					,	SRA->RA_NUMCP							 							, "SRA->RA_NUMCP"			,STR0021	} ) 
	aAdd( aExp, {'GPE_SERIE_CTPS'			,	SRA->RA_SERCP							 							, "SRA->RA_SERCP"			,STR0022	} ) 
	aAdd( aExp, {'GPE_UF_CTPS'				,	SRA->RA_UFCP							 							, "SRA->RA_UFCP"			,STR0023	} ) 
	aAdd( aExp, {'GPE_CNH'   	  			,	SRA->RA_HABILIT							 						, "SRA->RA_HABILIT"		,STR0024	} ) 
	aAdd( aExp, {'GPE_RESERVISTA'			,	SRA->RA_RESERVI							 						, "SRA->RA_RESERVI"		,STR0025	} ) 
	aAdd( aExp, {'GPE_TIT_ELEITOR' 			,	SRA->RA_TITULOE							 						, "SRA->RA_TITULOE"		,STR0026	} ) 
	aAdd( aExp, {'GPE_ZONA_SECAO'  			,	SRA->RA_ZONASEC							 						, "SRA->RA_ZONASEC"		,STR0027	} ) 
	aAdd( aExp, {'GPE_ENDERECO'				,	SRA->RA_ENDEREC							 						, "SRA->RA_ENDEREC"		,STR0028	} ) 
	aAdd( aExp, {'GPE_COMP_ENDER'			,	SRA->RA_COMPLEM							 						, "SRA->RA_COMPLEM"		,STR0029	} )	
	aAdd( aExp, {'GPE_BAIRRO'				,	SRA->RA_BAIRRO							 						, "SRA->RA_BAIRRO"		,STR0030	} ) 
	aAdd( aExp, {'GPE_MUNICIPIO'			,	SRA->RA_MUNICIP							 						, "SRA->RA_MUNICIP"		,STR0031	} )	
	aAdd( aExp, {'GPE_ESTADO'				,	SRA->RA_ESTADO													, "SRA->RA_ESTADO"		,STR0032	} )	
	aAdd( aExp, {'GPE_DESC_ESTADO'			,	fDesc("SX5","12"+SRA->RA_ESTADO,"X5_DESCRI")					, "@!"						,STR0033	} ) 
	aAdd( aExp, {'GPE_CEP'		   			,	SRA->RA_CEP														, "SRA->RA_CEP"			,STR0034	} ) 
	aAdd( aExp, {'GPE_TELEFONE'	   			,	SRA->RA_TELEFON													, "SRA->RA_TELEFON"		,STR0035	} ) 
	aAdd( aExp, {'GPE_NOME_PAI'	   			,	SRA->RA_PAI														, "SRA->RA_PAI"			,STR0036	} ) 
	aAdd( aExp, {'GPE_NOME_MAE'	   			,	SRA->RA_MAE														, "SRA->RA_MAE"			,STR0037	} ) 
	aAdd( aExp, {'GPE_COD_SEXO'	   			,	SRA->RA_SEXO														, "SRA->RA_SEXO"			,STR0038	} ) 
	aAdd( aExp, {'GPE_DESC_SEXO'   			,	SRA->(IF(RA_SEXO ="M","Masculino","Feminino"))				, "@!"						,STR0039	} ) 
	if cPaisLoc <> "ARG"
		aAdd( aExp, {'GPE_EST_CIVIL'  		,	SRA->RA_ESTCIVI													, "SRA->RA_ESTCIVI"		,STR0040	} ) 
	else	
		aAdd( aExp, {'GPE_EST_CIVIL'  		,	fDesc("SX5","33"+SRA->RA_ESTCIVI,"X5DESCRI()")				, "SRA->RA_ESTCIVI"		,STR0040	} ) 
	endif	
	aAdd( aExp, {'GPE_COD_NATURALIDADE'	,	If(SRA->RA_NATURAL # " ",SRA->RA_NATURAL," ")	    			, "SRA->RA_NATURAL"		,STR0041	} ) 
	aAdd( aExp, {'GPE_DESC_NATURALIDADE'	,	fDesc("SX5","12"+SRA->RA_NATURAL,"X5_DESCRI")					, "@!"						,STR0042	} ) 
	aAdd( aExp, {'GPE_COD_NACIONALIDADE'	,	SRA->RA_NACIONA													, "SRA->RA_NACIONA"		,STR0043	} ) 
	aAdd( aExp, {'GPE_DESC_NACIONALIDADE'	,	fDesc("SX5","34"+SRA->RA_NACIONA,"X5_DESCRI")					, "@!"						,STR0044	} ) 
	aAdd( aExp, {'GPE_ANO_CHEGADA' 			,	SRA->RA_ANOCHEG													, "SRA->RA_ANOCHEG"		,STR0045	} )
	aAdd( aExp, {'GPE_DEP_IR'   			,	SRA->RA_DEPIR										 				, "SRA->RA_DEPIR"			,STR0046	} )	
	aAdd( aExp, {'GPE_DEP_SAL_FAM'			,	SRA->RA_DEPSF														, "SRA->RA_DEPSF"			,STR0047 	} )
	aAdd( aExp, {'GPE_DATA_NASC'  			,	SRA->RA_NASC														, "SRA->RA_NASC"			,STR0048	} )
	aAdd( aExp, {'GPE_DATA_ADMISSAO'		,	SRA->RA_ADMISSA													, "SRA->RA_ADMISSA"		,STR0049	} )
	aAdd( aExp, {'GPE_DIA_ADMISSAO' 		,	StrZero( Day( SRA->RA_ADMISSA ) , 2 )							, "@!"						,STR0050	} )
	aAdd( aExp, {'GPE_MES_ADMISSAO'			,	StrZero( Month( SRA->RA_ADMISSA ) , 2 )						, "@!"						,STR0051 	} )
	aAdd( aExp, {'GPE_ANO_ADMISSAO'			,	StrZero( Year( SRA->RA_ADMISSA ) , 4 )							, "@!"						,STR0052	} )
	aAdd( aExp, {'GPE_DT_OP_FGTS'  			,	SRA->RA_OPCAO														, "SRA->RA_OPCAO"			,STR0053	} )
	aAdd( aExp, {'GPE_DATA_DEMISSAO'		,	SRA->RA_DEMISSA													, "SRA->RA_DEMISSA"		,STR0054	} ) 
	aAdd( aExp, {'GPE_DATA_EXPERIENCIA'	,	SRA->RA_VCTOEXP													, "SRA->RA_VCTOEXP"		,STR0055	} )
	aAdd( aExp, {'GPE_DIA_EXPERIENCIA' 	,	StrZero( Day( SRA->RA_VCTOEXP ) , 2 )							, "@!"						,STR0056	} )
	aAdd( aExp, {'GPE_MES_EXPERIENCIA'		,	StrZero( Month( SRA->RA_VCTOEXP ) , 2 )						, "@!"						,STR0057	} )
	aAdd( aExp, {'GPE_ANO_EXPERIENCIA'		,	StrZero( Year( SRA->RA_VCTOEXP ) , 4 ) 						, "@!"						,STR0058	} )
	aAdd( aExp, {'GPE_DIAS_EXPERIENCIA'	,	StrZero(SRA->(RA_VCTOEXP-RA_ADMISSA)+1,03)					, "@!"						,STR0059	} )
	aAdd( aExp, {'GPE_DATA_EX_MEDIC'		,	SRA->RA_EXAMEDI													, "SRA->RA_EXAMEDI"		,STR0060	} )
	aAdd( aExp, {'GPE_BCO_AG_DEP_SAL'		, 	SRA->RA_BCDEPSA													, "SRA->RA_BCDEPSA"		,STR0061	} )
	aAdd( aExp, {'GPE_DESC_BCO_SAL'			, 	fDesc("SA6",SRA->RA_BCDEPSA,"A6_NOME")							, "@!"						,STR0062	} )
	aAdd( aExp, {'GPE_DESC_AGE_SAL'			, 	fDesc("SA6",SRA->RA_BCDEPSA,"A6_NOMEAGE")						, "@!"						,STR0063	} )
	aAdd( aExp, {'GPE_CTA_DEP_SAL'			,	SRA->RA_CTDEPSA													, "SRA->RA_CTDEPSA"		,STR0064	} )
	aAdd( aExp, {'GPE_BCO_AG_FGTS'			,	SRA->RA_BCDPFGT													, "SRA->RA_BCDPFGT"		,STR0065	} )
	aAdd( aExp, {'GPE_DESC_BCO_FGTS'		, 	fDesc("SA6",SRA->RA_BCDPFGT,"A6_NOME")							, "@!"						,STR0066	} )
	aAdd( aExp, {'GPE_DESC_AGE_FGTS'		, 	fDesc("SA6",SRA->RA_BCDPFGT,"A6_NOMEAGE")						, "@!"						,STR0067	} )
	aAdd( aExp, {'GPE_CTA_Dep_FGTS'			,	SRA->RA_CTDPFGT													, "SRA->RA_CTDPFGT"		,STR0068	} )
	aAdd( aExp, {'GPE_SIT_FOLHA'	  		,	SRA->RA_SITFOLH													, "SRA->RA_SITFOLH"		,STR0069	} )
	aAdd( aExp, {'GPE_DESC_SIT_FOLHA'  	,	fDesc("SX5","30"+SRA->RA_SITFOLH,"X5_DESCRI")					, "@!"						,STR0070	} )
	aAdd( aExp, {'GPE_HRS_MENSAIS'			,	SRA->RA_HRSMES													, "SRA->RA_HRSMES"		,STR0071	} )
	aAdd( aExp, {'GPE_HRS_SEMANAIS'			,	SRA->RA_HRSEMAN													, "SRA->RA_HRSEMAN"		,STR0072	} )
	aAdd( aExp, {'GPE_CHAPA'		  			,	SRA->RA_CHAPA														, "SRA->RA_CHAPA"			,STR0073	} )
	aAdd( aExp, {'GPE_TURNO_TRAB'	 		,	SRA->RA_TNOTRAB													, "SRA->RA_TNOTRAB"		,STR0074	} )
	aAdd( aExp, {'GPE_DESC_TURNO'	  		,	fDesc('SR6',SRA->RA_TNOTRAB,'R6_DESC')							, "@!"						,STR0075	} )
	aAdd( aExp, {'GPE_COD_FUNCAO'	 		,	SRA->RA_CODFUNC													, "SRA->RA_CODFUNC"		,STR0076 	} )
	aAdd( aExp, {'GPE_DESC_FUNCAO'			,	fDesc('SRJ',SRA->RA_CODfUNC,'RJ_DESC')							, "@!"						,STR0077	} )
	aAdd( aExp, {'GPE_CBO'			   		,	fCodCBO(SRA->RA_FILIAL,SRA->RA_CODFUNC,dDataBase)			, "@!"				       ,STR0078	} )
	aAdd( aExp, {'GPE_CONT_SINDIC'			,	SRA->RA_PGCTSIN													, "SRA->RA_PGCTSIN"		,STR0079	} )
	aAdd( aExp, {'GPE_COD_SINDICATO'		,	SRA->RA_SINDICA													, "SRA->RA_SINDICA"		,STR0080	} )
	aAdd( aExp, {'GPE_DESC_SINDICATPO'		,	AllTrim( fDesc("RCE",SRA->RA_SINDICA,"RCE_DESCRI",40) )		, "@!"						,STR0081	} )
	aAdd( aExp, {'GPE_COD_ASS_MEDICA'		,	SRA->RA_ASMEDIC													, "SRA->RA_ASMEDIC"		,STR0082	} )
	aAdd( aExp, {'GPE_DEP_ASS_MEDICA'		,	SRA->RA_DPASSME													, "SRA->RA_DPASSME"		,STR0083	} )
	aAdd( aExp, {'GPE_ADIC_TEMP_SERVIC'	,	SRA->RA_ADTPOSE													, "SRA->RA_ADTPOSE"		,STR0084	} )
	aAdd( aExp, {'GPE_COD_CESTA_BASICA'	,	SRA->RA_CESTAB													, "SRA->RA_CESTAB"		,STR0085	} )
	aAdd( aExp, {'GPE_COD_VALE_REF' 		,	SRA->RA_VALEREF													, "SRA->RA_VALEREF"		,STR0086	} )
	aAdd( aExp, {'GPE_COD_SEG_VIDA' 		,	SRA->RA_SEGUROV													, "SRA->RA_SEGUROV"		,STR0087	} )
	aAdd( aExp, {'GPE_%ADIANTAM'	 		,	SRA->RA_PERCADT													, "SRA->RA_PERCADT"		,STR0089	} )
	aAdd( aExp, {'GPE_CATEG_FUNC'	  		,	SRA->RA_CATFUNC													, "SRA->RA_CATFUNC"		,STR0090	} )
	aAdd( aExp, {'GPE_DESC_CATEG_FUNC'		,	fDesc("SX5","28"+SRA->RA_CATFUNC,"X5_DESCRI")					, "@!"						,STR0091	} )
	aAdd( aExp, {'GPE_POR_MES_HORA'			,	SRA->(IF(RA_CATFUNC$"H","P/Hora",IF(RA_CATFUNC$"J","P/Aula","P/Mes"))) , "@!"		,STR0092	} )
	aAdd( aExp, {'GPE_TIPO_PAGTO'  			,	SRA->RA_TIPOPGT								 					, "SRA->RA_TIPOPGT"		,STR0093	} )
	aAdd( aExp, {'GPE_DESC_TIPO_PAGTO'  	,	fDesc("SX5","40"+SRA->RA_TIPOPGT,"X5_DESCRI")					, "@!"						,STR0094	} )
	aAdd( aExp, {'GPE_SALARIO'		   		,	SRA->RA_SALARIO													, "SRA->RA_SALARIO"		,STR0095	} )
	aAdd( aExp, {'GPE_SAL_BAS_DISS'			,	SRA->RA_ANTEAUM													, "SRA->RA_ANTEAUM"		,STR0096	} )
	aAdd( aExp, {'GPE_HRS_PERICULO'  		,	SRA->RA_PERICUL													, "SRA->RA_PERICUL"		,STR0099	} )
	aAdd( aExp, {'GPE_HRS_INS_MINIMA'		,	SRA->RA_INSMIN													, "SRA->RA_INSMIN"		,STR0100	} )
	aAdd( aExp, {'GPE_HRS_INS_MEDIA'		,	SRA->RA_INSMED													, "@!"						,STR0101	} )
	aAdd( aExp, {'GPE_HRS_INS_MAXIMA'		,	SRA->RA_INSMAX													, "SRA->RA_INSMAX"		,STR0102	} )
	aAdd( aExp, {'GPE_TIPO_ADMISSAO'		,	SRA->RA_TIPOADM													, "SRA->RA_TIPOADM"		,STR0103	} )
	aAdd( aExp, {'GPE_DESC_TP_ADMISSAO'	,	fDesc("SX5","38"+SRA->RA_TIPOADM,"X5_DESCRI")					, "@!"						,STR0104	} )
	aAdd( aExp, {'GPE_COD_AFA_FGTS'			,	SRA->RA_AFASFGT													, "SRA->RA_AFASFGT"		,STR0105	} )
	aAdd( aExp, {'GPE_DESC_AFA_FGTS'		,	fDesc("SX5","30"+SRA->RA_AFASFGT,"X5_DESCRI")					, "@!"						,STR0106	} )
	aAdd( aExp, {'GPE_VIN_EMP_RAIS'			,	SRA->RA_VIEMRAI													, "SRA->RA_VIEMRAI"		,STR0107	} )
	//aAdd( aExp, {'GPE_DESC_VIN_EMP_RAIS'	,	fDesc("SX5","25"+RA_VIEMRAI,"X5_DESCRI")						, "@!"						,STR0108	} )
	aAdd( aExp, {'GPE_COD_INST_RAIS'		,	SRA->RA_GRINRAI													, "SRA->RA_GRINRAI"		,STR0109	} )
	aAdd( aExp, {'GPE_DESC_GRAU_INST'		,	fDesc("SX5","26"+SRA->RA_GRINRAI,"X5_DESCRI")					, "@!"						,STR0110	} )
	aAdd( aExp, {'GPE_COD_RESC_RAIS'		,	SRA->RA_RESCRAI													, "SRA->RA_RESCRAI"		,STR0111	} )
	aAdd( aExp, {'GPE_CRACHA'		  		,	SRA->RA_CRACHA													, "SRA->RA_CRACHA"		,STR0112	} )
	aAdd( aExp, {'GPE_REGRA_APONTA'			,	SRA->RA_REGRA														, "SRA->RA_REGRA"			,STR0113	} )
	aAdd( aExp, {'GPE_NO_REGISTRO'	 		,	SRA->RA_REGISTR													, "SRA->RA_REGISTR"		,STR0115	} )
	aAdd( aExp, {'GPE_NO_FICHA'	    		,	SRA->RA_FICHA														, "SRA->RA_FICHA"			,STR0116	} )
	aAdd( aExp, {'GPE_TP_CONT_TRAB'			,	SRA->RA_TPCONTR													, "SRA->RA_TPCONTR"		,STR0117	} )
	aAdd( aExp, {'GPE_DESC_TP_CONT_TRAB'	,	SRA->(IF(RA_TPCONTR="1","Indeterminado","Determinado")) 	, "@!"						,STR0118	} )
	aAdd( aExp, {'GPE_APELIDO'		   		,	SRA->RA_APELIDO													, "SRA->RA_APELIDO"		,STR0119	} )
	aAdd( aExp, {'GPE_E-MAIL'		 		,	SRA->RA_EMAIL														, "SRA->RA_EMAIL"			,STR0120	} )
	aAdd( aExp, {'GPE_TEXTO_01'				,	cTexto_01								   							, "@!"						,STR0121	} ) 
	aAdd( aExp, {'GPE_TEXTO_02'				,	cTexto_02															, "@!"						,STR0122	} )
	aAdd( aExp, {'GPE_TEXTO_03'				,	cTexto_03															, "@!"						,STR0123	} )
	aAdd( aExp, {'GPE_TEXTO_04'				,	cTexto_04															, "@!"						,STR0124	} )
	aAdd( aExp, {'GPE_EXTENSO_SAL'			,	Extenso( SRA->RA_SALARIO , .F. , 1 )							, "@!"						,STR0125 	} )
	aAdd( aExp, {'GPE_DDATABASE'			,	dDataBase                    	        						, "" 						,STR0126	} )
	aAdd( aExp, {'GPE_DIA_DDATABASE'		,	StrZero( Day( dDataBase ) , 2 )            					, "@!"						,STR0127	} )
	aAdd( aExp, {'GPE_MES_DDATABASE'		,	MesExtenso( dDataBase ) 											, "@!"						,STR0128	} )
	aAdd( aExp, {'GPE_ANO_DDATABASE'		,	StrZero( Year( dDataBase ) , 4 )            					, "@!"						,STR0129	} )
	aAdd( aExp, {'GPE_NOME_EMPRESA' 		,	aInfo[03]                              						, "@!"						,STR0130	} )
	aAdd( aExp, {'GPE_END_EMPRESA'			,	aInfo[04]                              						, "@!"						,STR0131	} )
	aAdd( aExp, {'GPE_CID_EMPRESA'			,	aInfo[05]                              						, "@!"						,STR0132	} )
	aAdd( aExp, {'GPE_CEP_EMPRESA'       	,   aInfo[07]                                              		, "!@R #####-###"       	,STR0034 	} )
	aAdd( aExp, {'GPE_EST_EMPRESA'       	,   aInfo[06]															, "@!"						,STR0032 	} )
	aAdd( aExp, {'GPE_CGC_EMPRESA' 			,	aInfo[08]             											, "@R ##.###.###/####-##",STR0134	} )
	aAdd( aExp, {'GPE_INSC_EMPRESA' 		,	aInfo[09]                              						, "@!" 					,STR0135	} )
	aAdd( aExp, {'GPE_TEL_EMPRESA'	 		,	aInfo[10]                              						, "@!" 					,STR0136	} )
	aAdd( aExp, {'GPE_FAX_EMPRESA'       	,   If(aInfo[11]#nil ,aInfo[11], "        ")              		, "@!"                  	,STR0136 	} )
	aAdd( aExp, {'GPE_BAI_EMPRESA'			,	aInfo[13]                              						, "@!" 					,STR0137	} )
	aAdd( aExp, {'GPE_DESC_RESC_RAIS'		,	fDesc("SX5","31"+SRA->RA_RESCRAI,"X5_DESCRI")					, "@!" 					,STR0138	} )
	aAdd( aExp, {'GPE_DIA_DEMISSAO'			,	StrZero( Day( SRA->RA_DEMISSA ) , 2 )							, "@!" 					,STR0139	} )
	aAdd( aExp, {'GPE_MES_DEMISSAO'			,	StrZero( Month( SRA->RA_DEMISSA ) , 2 )						, "@!" 					,STR0140 	} )
	aAdd( aExp, {'GPE_ANO_DEMISSAO'			,	StrZero( Year( SRA->RA_DEMISSA ) , 4 )							, "@!" 					,STR0141 	} )
	
	if cPaisLoc == "COL"
	   aAdd( aExp, {'GPE_DIA_INIFERIAS'	,   if(Len(aPerSRF) > 0,StrZero( Day( aPerSRF[1,1] ) , 2 ),space(02))   	, "@!"	,STR0188 	} )
	   aAdd( aExp, {'GPE_MES_INIFERIAS'	,   if(Len(aPerSRF) > 0,MesExtenso(aPerSRF[1,1] ),space(12)) 				, "@!" ,STR0189 	} )
	   aAdd( aExp, {'GPE_ANO_INIFERIAS' 	,   if(Len(aPerSRF) > 0,StrZero( Year( aPerSRF[1,1] ) , 4 ),space(04))  	, "@!"	,STR0190 	} )
	   
	   aAdd( aExp, {'GPE_DIA_FIMFERIAS'	,   if(Len(aPerSRF) > 0,StrZero( Day( aPerSRF[1,2] ) , 2 ),space(02))   	, "@!"	,STR0191 	} )
	   aAdd( aExp, {'GPE_MES_FIMFERIAS'	,   if(Len(aPerSRF) > 0,MesExtenso(aPerSRF[1,2] ),space(12)) 				, "@!" ,STR0192 	} )
	   aAdd( aExp, {'GPE_ANO_FIMFERIAS'	,   if(Len(aPerSRF) > 0,StrZero( Year( aPerSRF[1,2] ) , 4 ),space(04))  	, "@!"	,STR0193 	} )
	endif   
	
	//Salario Familia
	aAdd( aExp, {'GPE_CFILHO01'           	,   if(nDepen==1 .or. nDepen==3,aDepenSF[01,01],space(30))	, "@!"	,STR0150 	} )
	aAdd( aExp, {'GPE_DTFL01'             	,   if(nDepen==1 .or. nDepen==3,aDepenSF[01,02],space(08))	, ""	,STR0151 	} )
	aAdd( aExp, {'GPE_CFILHO02'           	,   if(nDepen==1 .or. nDepen==3,aDepenSF[02,01],space(30))	, "@!"	,STR0150 	} )
	aAdd( aExp, {'GPE_DTFL02'             	,   if(nDepen==1 .or. nDepen==3,aDepenSF[02,02],space(08))	, ""	,STR0151 	} )
	aAdd( aExp, {'GPE_CFILHO03'           	,   if(nDepen==1 .or. nDepen==3,aDepenSF[03,01],space(30))	, "@!" ,STR0150 	} )
	aAdd( aExp, {'GPE_DTFL03'             	,   if(nDepen==1 .or. nDepen==3,aDepenSF[03,02],space(08))	, ""   ,STR0151 	} )
	aAdd( aExp, {'GPE_CFILHO04'           	,   if(nDepen==1 .or. nDepen==3,aDepenSF[04,01],space(30))	, "@!" ,STR0150 	} )
	aAdd( aExp, {'GPE_DTFL04'             	,   if(nDepen==1 .or. nDepen==3,aDepenSF[04,02],space(08))	, ""   ,STR0151 	} )
	aAdd( aExp, {'GPE_CFILHO05'           	,   if(nDepen==1 .or. nDepen==3,aDepenSF[05,01],space(30))	, "@!" ,STR0150 	} )
	aAdd( aExp, {'GPE_DTFL05'             	,   if(nDepen==1 .or. nDepen==3,aDepenSF[05,02],space(08))	, ""   ,STR0151 	} )
	aAdd( aExp, {'GPE_CFILHO06'           	,   if(nDepen==1 .or. nDepen==3,aDepenSF[06,01],space(30))	, "@!" ,STR0150 	} )
	aAdd( aExp, {'GPE_DTFL06'             	,   if(nDepen==1 .or. nDepen==3,aDepenSF[06,02],space(08))	, ""   ,STR0151 	} )
	aAdd( aExp, {'GPE_CFILHO07'           	,   if(nDepen==1 .or. nDepen==3,aDepenSF[07,01],space(30))	, "@!" ,STR0150 	} )
	aAdd( aExp, {'GPE_DTFL07'             	,   if(nDepen==1 .or. nDepen==3,aDepenSF[07,02],space(08))	, ""   ,STR0151 	} )
	aAdd( aExp, {'GPE_CFILHO08'           	,   if(nDepen==1 .or. nDepen==3,aDepenSF[08,01],space(30))	, "@!" ,STR0150 	} )
	aAdd( aExp, {'GPE_DTFL08'             	,   if(nDepen==1 .or. nDepen==3,aDepenSF[08,02],space(08))	, ""   ,STR0151 	} )
	aAdd( aExp, {'GPE_CFILHO09'           	,   if(nDepen==1 .or. nDepen==3,aDepenSF[09,01],space(30))	, "@!" ,STR0150 	} )
	aAdd( aExp, {'GPE_DTFL09'             	,   if(nDepen==1 .or. nDepen==3,aDepenSF[09,02],space(08))	, ""   ,STR0151 	} )
	aAdd( aExp, {'GPE_CFILHO10'           	,   if(nDepen==1 .or. nDepen==3,aDepenSF[10,01],space(30))	, "@!" ,STR0150 	} )
	aAdd( aExp, {'GPE_DESC_ESTEMP'        	,   alltrim(fDesc("SX5","12"+aInfo[06],"X5_DESCRI"))      	, "@!" ,STR0134 	} ) 
	aAdd( aExp, {'GPE_cGrau01'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[01,03],space(10))	, "@!"	,STR0153 	} ) 
	aAdd( aExp, {'GPE_cGrau02'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[02,03],space(10))	, "@!"	,STR0153 	} ) 
	aAdd( aExp, {'GPE_cGrau03'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[03,03],space(10))	, "@!"	,STR0153 	} ) 
	aAdd( aExp, {'GPE_cGrau04'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[04,03],space(10))	, "@!"	,STR0153 	} ) 
	aAdd( aExp, {'GPE_cGrau05'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[05,03],space(10))	, "@!"	,STR0153 	} ) 
	aAdd( aExp, {'GPE_cGrau06'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[06,03],space(10))	, "@!"	,STR0153 	} )
	aAdd( aExp, {'GPE_cGrau07'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[07,03],space(10))	, "@!"	,STR0153 	} )
	aAdd( aExp, {'GPE_cGrau08'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[08,03],space(10))	, "@!"	,STR0153 	} )
	aAdd( aExp, {'GPE_cGrau09'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[09,03],space(10))	, "@!"	,STR0153 	} ) 
	aAdd( aExp, {'GPE_cGrau10'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[10,03],space(10))	, "@!"	,STR0153 	} ) 
	aAdd( aExp, {'GPE_local01'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[01,04],space(10))	, "@!"	,STR0164 	} ) 
	aAdd( aExp, {'GPE_CARTORIO01'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[01,05],space(10))	, "@!"	,STR0156 	} ) 
	aAdd( aExp, {'GPE_NREGISTRO01'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[01,06],space(10))	, "@!"	,STR0165 	} ) 
	aAdd( aExp, {'GPE_NLIVRO01'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[01,07],space(10))	, "@!"	,STR0158 	} ) 
	aAdd( aExp, {'GPE_NFOLHA01'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[01,08],space(10))	, "@!"	,STR0159 	} ) 
	aAdd( aExp, {'GPE_DT_ENTREGA01'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[01,09],space(10))	, "@!"	,STR0160 	} ) 
	aAdd( aExp, {'GPE_DT_BAIXA01'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[01,10],space(10))	, "@!"	,STR0161 	} ) 
	aAdd( aExp, {'GPE_local02'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[02,04],space(10))	, "@!"	,STR0164 	} ) 
	aAdd( aExp, {'GPE_CARTORIO02'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[02,05],space(10))	, "@!"	,STR0156 	} ) 
	aAdd( aExp, {'GPE_NREGISTRO02'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[02,06],space(10))	, "@!"	,STR0165 	} ) 
	aAdd( aExp, {'GPE_NLIVRO02'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[02,07],space(10))	, "@!"	,STR0158 	} ) 
	aAdd( aExp, {'GPE_NFOLHA02'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[02,08],space(10))	, "@!"	,STR0159 	} ) 
	aAdd( aExp, {'GPE_DT_ENTREGA02'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[02,09],space(10))	, "@!"	,STR0160 	} ) 
	aAdd( aExp, {'GPE_DT_BAIXA02'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[02,10],space(10))	, "@!"	,STR0161 	} ) 
	aAdd( aExp, {'GPE_local03'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[03,04],space(10))	, "@!"	,STR0164 	} ) 
	aAdd( aExp, {'GPE_CARTORIO03'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[03,05],space(10))	, "@!"	,STR0156 	} ) 
	aAdd( aExp, {'GPE_NREGISTRO03'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[03,06],space(10))	, "@!"	,STR0165 	} ) 
	aAdd( aExp, {'GPE_NLIVRO03'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[03,07],space(10))	, "@!"	,STR0158 	} ) 
	aAdd( aExp, {'GPE_NFOLHA03'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[03,08],space(10))	, "@!"	,STR0159 	} ) 
	aAdd( aExp, {'GPE_DT_ENTREGA03'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[03,09],space(10))	, "@!"	,STR0160 	} ) 
	aAdd( aExp, {'GPE_DT_BAIXA03'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[03,10],space(10))  , "@!"	,STR0161 	} ) 
	aAdd( aExp, {'GPE_local04'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[04,04],space(10))	, "@!"	,STR0164 	} ) 
	aAdd( aExp, {'GPE_CARTORIO04'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[04,05],space(10))	, "@!"	,STR0156 	} ) 
	aAdd( aExp, {'GPE_NREGISTRO04'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[04,06],space(10))	, "@!"	,STR0165 	} ) 
	aAdd( aExp, {'GPE_NLIVRO04'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[04,07],space(10))	, "@!"	,STR0158 	} ) 
	aAdd( aExp, {'GPE_NFOLHA04'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[04,08],space(10))	, "@!"	,STR0159 	} ) 
	aAdd( aExp, {'GPE_DT_ENTREGA04'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[04,09],space(10))	, "@!"	,STR0160 	} ) 
	aAdd( aExp, {'GPE_DT_BAIXA04'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[04,10],space(10)) 	, "@!"	,STR0161 	} ) 
	aAdd( aExp, {'GPE_local05'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[05,04],space(10))	, "@!"	,STR0164 	} ) 
	aAdd( aExp, {'GPE_CARTORIO05'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[05,05],space(10))	, "@!"	,STR0156 	} )
	aAdd( aExp, {'GPE_NREGISTRO05'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[05,06],space(10))	, "@!"	,STR0165 	} ) 
	aAdd( aExp, {'GPE_NLIVRO05'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[05,07],space(10))	, "@!"	,STR0158 	} ) 
	aAdd( aExp, {'GPE_NFOLHA05'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[05,08],space(10))	, "@!"	,STR0159 	} ) 
	aAdd( aExp, {'GPE_DT_ENTREGA05'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[05,09],space(10))	, "@!"	,STR0160 	} ) 
	aAdd( aExp, {'GPE_DT_BAIXA05'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[05,10],space(10))	, "@!"	,STR0161 	} ) 
	aAdd( aExp, {'GPE_local06'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[06,04],space(10))	, "@!"	,STR0164 	} ) 
	aAdd( aExp, {'GPE_CARTORIO06'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[06,05],space(10))	, "@!"	,STR0156 	} ) 
	aAdd( aExp, {'GPE_NREGISTRO06'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[06,06],space(10))	, "@!"	,STR0165 	} ) 
	aAdd( aExp, {'GPE_NLIVRO06'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[06,07],space(10))	, "@!"	,STR0158 	} ) 
	aAdd( aExp, {'GPE_NFOLHA06'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[06,08],space(10))	, "@!"	,STR0159 	} ) 
	aAdd( aExp, {'GPE_DT_ENTREGA06'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[06,09],space(10))	, "@!"	,STR0160 	} ) 
	aAdd( aExp, {'GPE_DT_BAIXA06'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[06,10],space(10))	, "@!"	,STR0161 	} ) 
	aAdd( aExp, {'GPE_local07'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[07,04],space(10))	, "@!"	,STR0164 	} ) 
	aAdd( aExp, {'GPE_CARTORIO07'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[07,05],space(10))	, "@!"	,STR0156 	} ) 
	aAdd( aExp, {'GPE_NREGISTRO07'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[07,06],space(10))	, "@!"	,STR0165 	} ) 
	aAdd( aExp, {'GPE_NLIVRO07'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[07,07],space(10))	, "@!"	,STR0158 	} ) 
	aAdd( aExp, {'GPE_NFOLHA07'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[07,08],space(10))	, "@!"	,STR0159 	} ) 
	aAdd( aExp, {'GPE_DT_ENTREGA07'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[07,09],space(10))	, "@!"	,STR0160 	} ) 
	aAdd( aExp, {'GPE_DT_BAIXA07'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[07,10],space(10)) 	, "@!"	,STR0161 	} ) 
	aAdd( aExp, {'GPE_local08'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[08,04],space(10))	, "@!"	,STR0164 	} ) 
	aAdd( aExp, {'GPE_CARTORIO08'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[08,05],space(10))	, "@!"	,STR0156 	} ) 
	aAdd( aExp, {'GPE_NREGISTRO08'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[08,06],space(10))	, "@!"	,STR0165 	} ) 
	aAdd( aExp, {'GPE_NLIVRO08'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[08,07],space(10))	, "@!"	,STR0158 	} ) 
	aAdd( aExp, {'GPE_NFOLHA08'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[08,08],space(10))	, "@!"	,STR0159 	} ) 
	aAdd( aExp, {'GPE_DT_ENTREGA08'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[08,09],space(10))	, "@!"	,STR0160 	} ) 
	aAdd( aExp, {'GPE_DT_BAIXA08'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[08,10],space(10)) 	, "@!"	,STR0161 	} ) 
	aAdd( aExp, {'GPE_local09'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[09,04],space(10))	, "@!"	,STR0164 	} ) 
	aAdd( aExp, {'GPE_CARTORIO09'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[09,05],space(10))	, "@!"	,STR0156 	} ) 
	aAdd( aExp, {'GPE_NREGISTRO09'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[09,06],space(10))	, "@!"	,STR0165 	} ) 
	aAdd( aExp, {'GPE_NLIVRO09'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[09,07],space(10))	, "@!"	,STR0158 	} ) 
	aAdd( aExp, {'GPE_NFOLHA09'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[09,08],space(10))	, "@!"	,STR0159 	} ) 
	aAdd( aExp, {'GPE_DT_ENTREGA09'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[09,09],space(10))	, "@!"	,STR0160 	} ) 
	aAdd( aExp, {'GPE_DT_BAIXA09'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[09,10],space(10))	, "@!"	,STR0161 	} ) 
	aAdd( aExp, {'GPE_local10'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[10,04],space(10))	, "@!"	,STR0164 	} ) 
	aAdd( aExp, {'GPE_CARTORIO10'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[10,05],space(10))	, "@!"	,STR0156 	} ) 
	aAdd( aExp, {'GPE_NREGISTRO10'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[10,06],space(10))	, "@!"	,STR0165 	} ) 
	aAdd( aExp, {'GPE_NLIVRO10'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[10,07],space(10))	, "@!"	,STR0158 	} ) 
	aAdd( aExp, {'GPE_NFOLHA10'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[10,08],space(10))	, "@!"	,STR0159 	} ) 
	aAdd( aExp, {'GPE_DT_ENTREGA10'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[10,09],space(10))	, "@!"	,STR0160 	} ) 
	aAdd( aExp, {'GPE_DT_BAIXA10'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[10,10],space(10))	, "@!"	,STR0161 	} ) 
	
	//Imposto de renda
	aAdd( aExp, {'GPE_CDEPE01'           	,	if(nDepen==2 .or. nDepen==3,aDepenIR[01,01],space(30))	, "@!"	,STR0154  	} )
	aAdd( aExp, {'GPE_cGrDp01'				,	if(nDepen==2 .or. nDepen==3,aDepenIR[01,03],space(10))	, "@!"	,STR0153 	} ) 
	aAdd( aExp, {'GPE_DTFLIR01'          	,  	if(nDepen==2 .or. nDepen==3,aDepenIR[01,02],space(08)) 	, ""	,STR0163 	} )
	aAdd( aExp, {'GPE_CDEPE02'				,	if(nDepen==2 .or. nDepen==3,aDepenIR[02,01],space(30))	, "@!" ,STR0154 	} )
	aAdd( aExp, {'GPE_cGrDp02'				,	if(nDepen==2 .or. nDepen==3,aDepenIR[02,03],space(10))	, "@!"	,STR0153 	} ) 
	aAdd( aExp, {'GPE_DTFLIR02'          	,  	if(nDepen==2 .or. nDepen==3,aDepenIR[02,02],space(08))	, ""	,STR0163 	} )
	aAdd( aExp, {'GPE_CDEPE03'				,	if(nDepen==2 .or. nDepen==3,aDepenIR[03,01],space(30))	, "@!"	,STR0154 	} )
	aAdd( aExp, {'GPE_cGrDp03'				,	if(nDepen==2 .or. nDepen==3,aDepenIR[03,03],space(10))	, "@!"	,STR0153 	} ) 
	aAdd( aExp, {'GPE_DTFLIR03'           	,  	if(nDepen==2 .or. nDepen==3,aDepenIR[03,02],space(08)) 	, ""   ,STR0163 	} )
	aAdd( aExp, {'GPE_CDEPE04'				,	if(nDepen==2 .or. nDepen==3,aDepenIR[04,01],space(30))	, "@!"	,STR0154 	} )
	aAdd( aExp, {'GPE_cGrDp04'				,	if(nDepen==2 .or. nDepen==3,aDepenIR[04,03],space(10))	, "@!"	,STR0153 	} ) 
	aAdd( aExp, {'GPE_DTFLIR04'           	,  	if(nDepen==2 .or. nDepen==3,aDepenIR[04,02],space(08)) 	, ""   ,STR0163 	} )
	aAdd( aExp, {'GPE_CDEPE05'				,	if(nDepen==2 .or. nDepen==3,aDepenIR[05,01],space(30))	, "@!"	,STR0154 	} )
	aAdd( aExp, {'GPE_cGrDp05'				,	if(nDepen==2 .or. nDepen==3,aDepenIR[05,03],space(10))	, "@!"	,STR0153 	} ) 
	aAdd( aExp, {'GPE_DTFLIR05'           	,  	if(nDepen==2 .or. nDepen==3,aDepenIR[05,02],space(08))	, ""   ,STR0163 	} )
	aAdd( aExp, {'GPE_CDEPE06'				,	if(nDepen==2 .or. nDepen==3,aDepenIR[06,01],space(30))	, "@!"	,STR0154 	} )
	aAdd( aExp, {'GPE_cGrDp06'				,	if(nDepen==2 .or. nDepen==3,aDepenIR[06,03],space(10))	, "@!"	,STR0153 	} ) 
	aAdd( aExp, {'GPE_DTFLIR06'				,  	if(nDepen==2 .or. nDepen==3,aDepenIR[06,02],space(08)) 	, ""   ,STR0163 	} )
	aAdd( aExp, {'GPE_CDEPE07'				,	if(nDepen==2 .or. nDepen==3,aDepenIR[07,01],space(30))	, "@!"	,STR0154 	} )
	aAdd( aExp, {'GPE_cGrDp07'				,	if(nDepen==2 .or. nDepen==3,aDepenIR[07,03],space(10))	, "@!"	,STR0153	} ) 
	aAdd( aExp, {'GPE_DTFLIR07'           	,  	if(nDepen==2 .or. nDepen==3,aDepenIR[07,02],space(08))	, ""   ,STR0163 	} )
	aAdd( aExp, {'GPE_CDEPE08'				,	if(nDepen==2 .or. nDepen==3,aDepenIR[08,01],space(30))	, "@!"	,STR0154 	} )
	aAdd( aExp, {'GPE_cGrDp08'				,	if(nDepen==2 .or. nDepen==3,aDepenIR[08,03],space(10))	, "@!"	,STR0153 	} ) 
	aAdd( aExp, {'GPE_DTFLIR08'           	,  	if(nDepen==2 .or. nDepen==3,aDepenIR[08,02],space(08)) 	, ""   ,STR0163 	} )
	aAdd( aExp, {'GPE_CDEPE09'				,	if(nDepen==2 .or. nDepen==3,aDepenIR[09,01],space(30))	, "@!"	,STR0154 	} )
	aAdd( aExp, {'GPE_cGrDp09'				,	if(nDepen==2 .or. nDepen==3,aDepenIR[09,03],space(10))	, "@!"	,STR0153 	} ) 
	aAdd( aExp, {'GPE_DTFLIR09'           	,  	if(nDepen==2 .or. nDepen==3,aDepenIR[09,02],space(08)) 	, ""   ,STR0163 	} )
	aAdd( aExp, {'GPE_CDEPE10'				,	if(nDepen==2 .or. nDepen==3,aDepenIR[10,01],space(30))	, "@!"	,STR0154 	} )
	aAdd( aExp, {'GPE_cGrDp10'				,	if(nDepen==2 .or. nDepen==3,aDepenIR[10,03],space(10))	, "@!"	,STR0153 	} ) 
	aAdd( aExp, {'GPE_DTFLIR10'           	, 	if(nDepen==2 .or. nDepen==3,aDepenIR[10,02],space(08))	, ""   ,STR0163 	} )
	
	if cPaisLoc == "ARG"
		aAdd( aExp, {'GPE_MES_ADEXT'		,	MesExtenso( Month( SRA->RA_ADMISSA ) )					  	, "@!"	,STR0155	} )
		aAdd( aExp, {'GPE_APODERADO'		,	cApoderado												    	, "@!"	,STR0156	} )
		aAdd( aExp, {'GPE_ATIVIDADE'		,	cRamoAtiv												    	, "@!"	,STR0157	} )
	endif	
	
	aAdd( aExp, {'GPE_MUNICNASC'          	,   if(SRA->(FieldPos("RA_MUNNASC")) # 0  ,SRA->RA_MUNNASC,space(20)), "@!" ,STR0166 	} )
	if SRA->(FieldPos("RA_PROCES" )) # 0
		aAdd( aExp, {'GPE_PROCES'			,	SRA->RA_PROCES	,	"SRA->RA_PROCES"	,STR0173 	} )	//Codigo do Processo
	endif
	
	if SRA->(FieldPos("RA_DEPTO"  )) # 0                                                                         
		aAdd( aExp, {'GPE_DEPTO'				,	SRA->RA_DEPTO		,	"SRA->RA_DEPTO"	,STR0181 	} )	//Codigo do Departamento
	endif
	
	if SRA->(FieldPos("RA_POSTO"  )) # 0
		aAdd( aExp, {'GPE_POSTO'				,	SRA->RA_POSTO  	,	"SRA->RA_POSTO"	,STR0182 	} )	//Codigo do Posto
	endif
	
	if cPaisLoc == "MEX"
		aAdd( aExp, {'GPE_PRINOME'	,	SRA->RA_PRINOME	,	"SRA->RA_PRINOME"	,STR0169	} ) 	//Primeiro Nome 
		aAdd( aExp, {'GPE_SECNOME'	,	SRA->RA_SECNOME	,	"SRA->RA_SECNOME"	,STR0170	} ) 	//Segundo Nome
		aAdd( aExp, {'GPE_PRISOBR'	,	SRA->RA_PRISOBR	,	"SRA->RA_PRISOBR"	,STR0171	} ) 	//Primeiro Sobrenome
		aAdd( aExp, {'GPE_SECSOBR'	,	SRA->RA_SECSOBR	,	"SRA->RA_SECSOBR"	,STR0172	} ) 	//Segundo Sobrenome
		aAdd( aExp, {'GPE_KEYLOC'	,	SRA->RA_KEYLOC	,	"SRA->RA_KEYLOC"	,STR0174	} ) 	//Codigo local de Pagamento
		aAdd( aExp, {'GPE_TSIMSS'	,	SRA->RA_TSIMSS	,	"SRA->RA_TSIMSS"	,STR0175	} ) 	//Tipo de Salario IMSS
		aAdd( aExp, {'GPE_TEIMSS'	,	SRA->RA_TEIMSS	,	"SRA->RA_TEIMSS"	,STR0176	} ) 	//Tipo de Empregado IMSS
		aAdd( aExp, {'GPE_TJRNDA'	,	SRA->RA_TJRNDA	,	"SRA->RA_TJRNDA"	,STR0177	} ) 	//Tipo de Jornada IMSS
		aAdd( aExp, {'GPE_FECREI'	,	SRA->RA_FECREI	,	"SRA->RA_FECREI"	,STR0178	} ) 	//Data de Readmissao
		aAdd( aExp, {'GPE_DTBIMSS'	,	SRA->RA_DTBIMSS	,	"SRA->RA_DTBIMSS"	,STR0179	} ) 	//Data de Baixa IMSS
		aAdd( aExp, {'GPE_CODRPAT'	,	SRA->RA_CODRPAT	,	"SRA->RA_CODRPAT"	,STR0180	} ) 	//Codigo do Registro Patronal
		aAdd( aExp, {'GPE_CURP'		,	SRA->RA_CURP		,	"SRA->RA_CURP"	,STR0183	} ) 	//CURP
		aAdd( aExp, {'GPE_TIPINF'	,	SRA->RA_TIPINF	,	"SRA->RA_TIPINF"	,STR0184	} ) 	//Tipo de Infonavit
		aAdd( aExp, {'GPE_VALINF'	,	SRA->RA_VALINF	,	"SRA->RA_VALINF"	,STR0185	} ) 	//Valor do Infonavit
		aAdd( aExp, {'GPE_NUMINF'	,	SRA->RA_NUMINF	,	"SRA->RA_NUMINF"	,STR0186	} ) 	//Nro. de Credito Infonavit
	endif                    
	
	if cPaisLoc == "ANG"
		aAdd( aExp, {'GPE_BIDENT'	     ,	SRA->RA_BIDENT 	,	"SRA->RA_BIDENT "	,STR0195	} ) 	//Nr. Bilhete Identidade
		aAdd( aExp, {'GPE_BIEMISS'	     ,	SRA->RA_BIEMISS	,	"SRA->RA_BIEMISS"	,STR0196	} ) 	//Data de Emissão do Bilhete Identidade
		aAdd( aExp, {'GPE_DESC_EST_CIV'  ,	fDesc("SX5","33"+SRA->RA_ESTCIVI,"X5DESCRI()")	, "SRA->RA_ESTCIVI"			,STR0194	} ) //Descrição do Estado Civil
	endif   
	
	//Periodo Aquisitivo de Ferias
	
	/*
	aAdd( aExp, {'GPE_DATA_INIPERAQUI'	,	aPerSRF[1][1]				,"@!"		,	"Data Inicial do Periodo Aquisitivo"	})
	aAdd( aExp, {'GPE_DATA_FIMPERAQUI'	,	aPerSRF[1][2]				,"@!"		,	"Data Final do Periodo Aquisitivo"		})
	aAdd( aExp, {'GPE_DATA_INIIDEAL'	,	(aPerSRF[1][2]+30)			,"@!"		,	"Data Limite Ideal"						})
	aAdd( aExp, {'GPE_DATA_MAXIDEAL'	,	(aPerSRF[1][3]-45)			,"@!"		,	"Data Limite Maximo"					})
	*/

	//Customizado
	aAdd( aExp, {'GPE_DATA_ADMISSAOEXT'	,	MesExtenso( SRA->RA_ADMISSA ) 	, "@!"					, 'Mês em extenso'							} )
	aAdd( aExp, {'GPE_COMP_ENDEMP'			,	cCompEndEmp 						, "@!"					, 'Complemento do endereço de entrega' 	} )
	aAdd( aExp, {'GPE_NOME_PROJETO'			,	cNomeProces  						, "@!"					, 'Nome do projeto' 							} )
	aAdd( aExp, {'GPE_DIAS_CONTRAB'			,	SRA->RA_DIACTRB  					, "SRA->RA_DIACTRB"	, 'Dias do contrato de trabalho'			} )
	aAdd( aExp, {'GPE_DTFIM_CONTRB'			,	SRA->RA_DTFIMCT  					, "SRA->RA_DTFIMCT"	, 'Data fim do contrato de trabalho'		} )
	aAdd( aExp, {'GPE_DATA_EXPERIENCIA2'	,	SRA->RA_VCTEXP2					, "SRA->RA_VCTOEXP"	,STR0055										} )
	aAdd( aExp, {'GPE_HRS_ENTRA'			,	cHoraIni  							, "@!"					, 'Hora entrada'								} )
	aAdd( aExp, {'GPE_HRS_SAIDA'			,	cHoraFim  							, "@!"					, 'Hora saída'								} )
	aAdd( aExp, {'GPE_HRS_INTERVALO'		,	nHrInter  							, "@!"  				, 'Hora saída'								} )
	 


	
Return( aExp )

/*
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³         Grupo  Ordem Pergunta Portugues     Pergunta Espanhol  Pergunta Ingles Variavel Tipo Tamanho Decimal Presel  GSC Valid                              Var01      Def01              DefSPA1     DefEng1 Cnt01             Var02  Def02    		 DefSpa2  DefEng2	Cnt02  Var03 Def03      DefSpa3    DefEng3  Cnt03  Var04  Def04     DefSpa4    DefEng4  Cnt04  Var05  Def05       DefSpa5	 DefEng5   Cnt05  XF3   GrgSxg ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aAdd(aRegs,{cPerg,'01' ,'Filial De          ?',''				 ,''			 ,'mv_ch1','C'  ,FWGETTAMFILIAL,0      ,0     ,'G','                                ','mv_par01','               '  ,''		 ,''	 ,'                ',''   ,'        	   ',''   	 ,''   	  ,''	 ,''   ,'       ' ,''   	 ,''   	  ,''	 ,''	,'       ',''  		 ,''  	  ,''	 ,''	,''			,''  	   ,''		 ,''	,'SM0',''})
aAdd(aRegs,{cPerg,'02' ,'Filial Ate         ?',''				 ,''			 ,'mv_ch2','C'  ,FWGETTAMFILIAL,0      ,0     ,'G','naovazio                        ','mv_par02','               '  ,''		 ,''	 ,REPLICATE('9',02) ,''   ,'        	   ',''   	 ,''  	  ,''	 ,''   ,'       ' ,''   	 ,''      ,''	 ,''	,'       ',''  		 ,'' 	  ,''	 ,''	,''			,''  	   ,''		 ,''	,'SM0',''})
aAdd(aRegs,{cPerg,'03' ,'Centro de Custo De ?',''				 ,''			 ,'mv_ch3','C'  ,09     ,0      ,0     ,'G','                                ','mv_par03','               '  ,''		 ,''	 ,'                ',''   ,'        	   ',''   	 ,''  	  ,''	 ,''   ,'       ' ,''  		 ,''      ,''	 ,''	,'       ',''  		 ,''  	  ,''	 ,''	,''			,'' 	   ,''		 ,''	,'SI3',''})
aAdd(aRegs,{cPerg,'04' ,'Centro de Custo Ate?',''				 ,''			 ,'mv_ch4','C'  ,09     ,0      ,0     ,'G','naovazio                        ','mv_par04','               '  ,''		 ,''	 ,REPLICATE('Z',09) ,''   ,'        	   ',''		 ,''  	  ,''	 ,''   ,'       ' ,''   	 ,''      ,''	 ,''	,'       ',''  		 ,''  	  ,''	 ,''	,''			,'' 	   ,''		 ,''	,'SI3',''})
aAdd(aRegs,{cPerg,'05' ,'Matricula De       ?',''				 ,''			 ,'mv_ch5','C'  ,06     ,0      ,0     ,'G','                                ','mv_par05','               '  ,''		 ,''	 ,'                ',''   ,'        	   ',''    	 ,''  	  ,''	 ,''   ,'       ' ,''   	 ,''      ,''	 ,''	,'       ',''  		 ,''  	  ,''	 ,''	,''			,'' 	   ,''		 ,''	,'SRA',''})
aAdd(aRegs,{cPerg,'06' ,'Matricula Ate      ?',''				 ,''			 ,'mv_ch6','C'  ,06     ,0      ,0     ,'G','naovazio                        ','mv_par06','               '  ,''		 ,''	 ,REPLICATE('Z',06) ,''   ,'        	   ',''    	 ,''  	  ,''	 ,''   ,'       ' ,''   	 ,''      ,''	 ,''	,'       ','' 		 ,''  	  ,''	 ,''	,''			,''  	   ,''		 ,''	,'SRA',''})
aAdd(aRegs,{cPerg,'07' ,'Nome De            ?',''				 ,''			 ,'mv_ch7','C'  ,30     ,0      ,0     ,'G','                                ','mv_par07','               '  ,''		 ,''	 ,'                ',''   ,'        	   ',''    	 ,''  	  ,''	 ,''   ,'       ' ,''   	 ,''      ,''	 ,''	,'       ',''  		 ,''  	  ,''	 ,''	,''			,'' 	   ,''		 ,''	,'   ',''})
aAdd(aRegs,{cPerg,'08' ,'Nome Ate           ?',''				 ,''			 ,'mv_ch8','C'  ,30     ,0      ,0     ,'G','naovazio                        ','mv_par08','               '  ,''		 ,''	 ,REPLICATE('Z',30) ,''   ,'        	   ',''    	 ,''  	  ,''	 ,''   ,'       ' ,''   	 ,''      ,''	 ,''	,'       ',''  		 ,''  	  ,''	 ,''	,''			,'' 	   ,''		 ,''	,'   ',''})
aAdd(aRegs,{cPerg,'09' ,'Turno De           ?',''				 ,''			 ,'mv_ch9','C'  ,03     ,0      ,0     ,'G','                                ','mv_par09','               '  ,''		 ,''	 ,'                ',''   ,'        	   ',''    	 ,'' 	  ,''	 ,''   ,'       ' ,''   	 ,''      ,''	 ,''	,'       ',''  		 ,''  	  ,''	 ,''	,''			,''  	   ,''		 ,''	,'SR6',''})
aAdd(aRegs,{cPerg,'10' ,'Turno Ate          ?',''				 ,''			 ,'mv_cha','C'  ,03     ,0      ,0     ,'G','naovazio                        ','mv_par10','               '  ,''		 ,''	 ,REPLICATE('Z',03) ,''   ,'        	   ',''    	 ,''   	  ,''	 ,''   ,'       ' ,''  	 	 ,''      ,''	 ,''	,'       ',''  		 ,''  	  ,''	 ,''	,''			,''  	   ,''		 ,''	,'SR6',''})
aAdd(aRegs,{cPerg,'11' ,'Fun‡ao De          ?',''				 ,''			 ,'mv_chb','C'  ,03     ,0      ,0     ,'G','                                ','mv_par11','               '  ,''		 ,''	 ,'                ',''   ,'        	   ',''    	 ,''  	  ,''	 ,''   ,'       ' ,''   	 ,''      ,''	 ,''	,'       ',''  		 ,''  	  ,''	 ,''	,''			,''  	   ,''		 ,''	,'SRJ',''})
aAdd(aRegs,{cPerg,'12' ,'Fun‡ao Ate         ?',''				 ,''			 ,'mv_chc','C'  ,03     ,0      ,0     ,'G','naovazio                        ','mv_par12','               '  ,''		 ,''	 ,REPLICATE('Z',03) ,''   ,'        	   ',''    	 ,''  	  ,''	 ,''   ,'       ' ,''   	 ,''      ,''	 ,''	,'       ',''  		 ,''  	  ,''	 ,''	,''			,''  	   ,''		 ,''	,'SRJ',''})
aAdd(aRegs,{cPerg,'13' ,'Sindicato De       ?',''				 ,''			 ,'mv_chd','C'  ,02     ,0      ,0     ,'G','                                ','mv_par13','               '  ,''		 ,''	 ,'                ',''   ,'        	   ',''   	 ,''   	  ,''	 ,''   ,'       ' ,''   	 ,''      ,''	 ,''	,'       ',''  		 ,''  	  ,''	 ,''	,''			,''  	   ,''		 ,''	,'X04',''})
aAdd(aRegs,{cPerg,'14' ,'Sindicato Ate      ?',''				 ,''			 ,'mv_che','C'  ,02     ,0      ,0     ,'G','naovazio                        ','mv_par14','               '  ,''		 ,''	 ,REPLICATE('Z',03) ,''   ,'        	   ',''   	 ,''  	  ,''	 ,''   ,'       ' ,''   	 ,''      ,''	 ,''	,'       ',''  		 ,''  	  ,''	 ,''	,''			,''  	   ,''		 ,''	,'X04',''})
aAdd(aRegs,{cPerg,'15' ,'Admissao De        ?',''				 ,''			 ,'mv_chf','D'  ,08     ,0      ,0     ,'G','                                ','mv_par15','               '  ,''		 ,''	 ,'                ',''   ,'        	   ',''   	 ,''   	  ,''	 ,''   ,'       ' ,''   	 ,''      ,''	 ,''	,'       ',''  		 ,''  	  ,''	 ,''	,''			,''  	   ,''		 ,''	,'   ',''})
aAdd(aRegs,{cPerg,'16' ,'Admissao Ate       ?',''				 ,''			 ,'mv_chg','D'  ,08     ,0      ,0     ,'G','naovazio                        ','mv_par16','               '  ,''		 ,''	 ,'                ',''   ,'        	   ',''   	 ,''  	  ,''	 ,''   ,'       ' ,''   	 ,''      ,''	 ,''	,'       ',''  		 ,''  	  ,''	 ,''	,''			,''  	   ,''		 ,''	,'   ',''})
aAdd(aRegs,{cPerg,'17' ,'Situa‡”es  a Impr. ?',''				 ,''			 ,'mv_chh','C'  ,05     ,0      ,0     ,'G','fSituacao                       ','mv_par17','               '  ,''		 ,''	 ,'                ',''   ,'        	   ',''   	 ,''  	  ,''	 ,''   ,'       ' ,''   	 ,''      ,''	 ,''	,'       ',''  		 ,''  	  ,''	 ,''	,''			,''  	   ,''		 ,''	,'   ',''})
aAdd(aRegs,{cPerg,'18' ,'Categorias a Impr. ?',''				 ,''			 ,'mv_chi','C'  ,10     ,0      ,0     ,'G','fCategoria                      ','mv_par18','               '  ,''		 ,''	 ,'                ',''   ,'        	   ',''   	 ,''  	  ,''	 ,''   ,'       ' ,''   	 ,''      ,''	 ,''	,'       ',''  		 ,''  	  ,''	 ,''	,''			,''  	   ,''		 ,''	,'   ',''})
aAdd(aRegs,{cPerg,'19' ,'Texto Livre 1      ?',''				 ,''			 ,'mv_chj','C'  ,30     ,0      ,0     ,'G','                                ','mv_par19','               '  ,''		 ,''	 ,'<Texto Livre 01>',''   ,'        	   ',''   	 ,''  	  ,''	 ,''   ,'       ' ,''   	 ,''      ,''	 ,''	,'       ',''  		 ,''  	  ,''	 ,''	,''			,''  	   ,''		 ,''	,'   ',''})
aAdd(aRegs,{cPerg,'20' ,'Texto Livre 2      ?',''				 ,''			 ,'mv_chk','C'  ,30     ,0      ,0     ,'G','                                ','mv_par20','               '  ,''		 ,''	 ,'<Texto Livre 02>',''   ,'        	   ',''   	 ,''  	  ,''	 ,''   ,'       ' ,''   	 ,''      ,''	 ,''	,'       ',''  		 ,''  	  ,''	 ,''	,''			,''  	   ,''		 ,''	,'   ',''})
aAdd(aRegs,{cPerg,'21' ,'Texto Livre 3      ?',''				 ,''			 ,'mv_chl','C'  ,30     ,0      ,0     ,'G','                                ','mv_par21','               '  ,''		 ,''	 ,'<Texto Livre 03>',''   ,'        	   ',''   	 ,''   	  ,''	 ,''   ,'       ' ,''   	 ,''      ,''	 ,''	,'       ',''  		 ,''  	  ,''	 ,''	,''			,''  	   ,''		 ,''	,'   ',''})
aAdd(aRegs,{cPerg,'22' ,'Texto Livre 4      ?',''				 ,''			 ,'mv_chm','C'  ,30     ,0      ,0     ,'G','                                ','mv_par22','               '  ,''		 ,''	 ,'<Texto Livre 04>',''   ,'        	   ',''   	 ,''   	  ,''	 ,''   ,'       ' ,''   	 ,''      ,''	 ,''	,'       ',''  		 ,''  	  ,''	 ,''	,''			,''  	   ,''		 ,''	,'   ',''})
aAdd(aRegs,{cPerg,'23' ,'Nro. de Copias     ?',''				 ,''			 ,'mv_chn','N'  ,03     ,0      ,0     ,'G','                                ','mv_par23','               '  ,''		 ,''	 ,'                ',''   ,'        	   ',''   	 ,''   	  ,''	 ,''   ,'       ' ,''   	 ,''      ,''	 ,''	,'       ',''  		 ,''  	  ,''	 ,''	,''			,''  	   ,''		 ,''	,'   ',''})
aAdd(aRegs,{cPerg,'24' ,'Ordem de Impressao ?',''				 ,''			 ,'mv_cho','N'  ,01     ,0      ,0     ,'C','                                ','mv_par24','Matricula      '  ,''		 ,''	 ,'                ',''   ,'Centro de Custo',''   	 ,''   	  ,''	 ,''   ,'Nome   ' ,''   	 ,''      ,''	 ,''	,'Turno  ',''  		 ,''  	  ,''	 ,''	,''			,''  	   ,''		 ,''	,'   ',''})
aAdd(aRegs,{cPerg,'25' ,'Arquivo do Word    ?',''				 ,''			 ,'mv_chp','C'  ,30     ,0      ,0     ,'G','fOpen_Word()                    ','mv_par25','               '  ,''		 ,''	 ,'                ',''   ,'        	   ',''   	 ,''   	  ,''	 ,''   ,'       ' ,''   	 ,''      ,''	 ,''	,'       ',''  		 ,''  	  ,''	 ,''	,''			,''  	   ,''		 ,''	,'   ',''})
aAdd(aRegs,{cPerg,'26' ,'Verific.Dependente ?','Verifi.Dependiente','Check Dependent','mv_chq','N',1    ,0      ,1     ,'C',''                                ,'mv_par26','Sim'              ,'Yes'      ,'Si'   ,''                ,''   ,'Nao'            ,'No'           ,'No'         ,''         ,''        ,''      ,''    ,''    ,''	      ,''	     ,'      ',''  	 ,''  	,''	        ,''	       ,''		 ,''    ,''	  ,''})
aAdd(aRegs,{cPerg,'27  ,'Tipo de Dependente ?','                 ,'              ','mv_chr",'N'  ,01    ,0      ,3     ,'C',''                                ,'mv_par27','Dep.Sal.Familia'  ,'Dep.Sal.Familia'  ,'Fam.Allow.Dep.'  ,''   ,'Dep.Imp.Renda'  ,'Dep.Imp.Renta','Income Dep.','Ambos'    ,'Ambos'   ,'Ambos' ,''	 ,''	,''	      ,''	     ,''	  ,''	 ,''	,''	        ,''	       ,''	     ,''	,''	  ,''})
aAdd(aRegs,{cPerg,'28' ,'Impressao          ?','Impresion        ','Printing     ','mv_chs','N'  ,01    ,0      ,0     ,'C','                                ','mv_par28','Impressora' 		 ,'Impresone','Printer','              ',''   ,'Arquivo        ','Archivo'      ,'File'       ,''         ,''        ,'      ',''    ,''    ,''       ,''        ,'      ',''    ,''    ,''         ,''        ,''       ,''    ,''   ,''})
aAdd(aRegs,{cPerg,'29' ,'Arquivo Saida      ?','Archivo Salida   ','Output File  ','mv_cht','C'  ,30    ,0      ,0     ,'G','                                ','mv_par29','         '  		 ,''         ,''     ,'                ',''   ,'               ',''      ,''      ,''    ,''   ,'       ' ,''        ,''      ,''    ,''    ,'       ',''        ,''      ,''    ,''    ,''         ,''        ,''       ,''    ,'   ',''})
*/

/*
nomeArq
Desc: Monta nome de arquivo que sera gerado
Uso: Protheus 12  - RH_Certisign
TOTVS(Marinaldo de Jesus) - 05/07/2000  

Alterado em 07/11/2017 - Opvs (Bruno Nunes)
Alteracao: Revisão do fonte para funcionar no P12.
*/
Static Function NomeArq(cArquivo)
	local cRetorno := ''
	local aRetorno := {}
	
	if !empty(cArquivo)
		aArquivo := strTokArr(cArquivo, '\')
		if len(aArquivo) > 0
			cRetorno := aArquivo[len(aArquivo)]
			cRetorno := SRA->RA_MAT+'_'+replace(cRetorno, '.dot', '.docx') 
		endif
	endif 
Return cRetorno

Static Function TurnoTrab()

	SPJ->(dbSetOrder(1))
	if SPJ->(dbSeek(xFilial('SPJ')+SRA->(RA_TNOTRAB+RA_SEQTURN)))
		while SPJ->(!EoF()) .And. SPJ->PJ_TPDIA != 'S'
			SPJ->(dbSkip())
		end 
		
		if SPJ->(!EoF())
			nHrInter := strZero( SPJ->PJ_HRSINT1 * 60, 2)
			cHoraIni := replace(strZero( SPJ->PJ_ENTRA1, 5, 2 ), ',', ':' )
			iif( SPJ->PJ_SAIDA1 > 0, cHoraFim := replace(strZero(  SPJ->PJ_SAIDA1, 5, 2 ) , ',', ':' ), nil ) 
	
			iif( SPJ->PJ_ENTRA2 > 0, cHoraFim := replace(strZero(  SPJ->PJ_ENTRA2, 5, 2 ) , ',', ':' ), nil )
			iif( SPJ->PJ_SAIDA2 > 0, cHoraFim := replace(strZero(  SPJ->PJ_SAIDA2, 5, 2 ) , ',', ':' ), nil ) 
	
			iif( SPJ->PJ_ENTRA3 > 0, cHoraFim := replace(strZero(  SPJ->PJ_ENTRA3, 5, 2 ) , ',', ':' ), nil )
			iif( SPJ->PJ_SAIDA3 > 0, cHoraFim := replace(strZero(  SPJ->PJ_SAIDA3, 5, 2 ) , ',', ':' ), nil ) 
	
			iif( SPJ->PJ_ENTRA4 > 0, cHoraFim := replace(strZero(  SPJ->PJ_ENTRA4, 5, 2 ) , ',', ':' ), nil )
			iif( SPJ->PJ_SAIDA4 > 0, cHoraFim := replace(strZero(  SPJ->PJ_SAIDA4, 5, 2 ) , ',', ':' ), nil ) 
		endif
	endif
Return