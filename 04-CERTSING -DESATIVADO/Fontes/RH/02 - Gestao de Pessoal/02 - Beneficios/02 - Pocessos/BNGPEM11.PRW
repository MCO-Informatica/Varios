#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"
#DEFINE          cEol         CHR(13)+CHR(10)

//------------------------------------------------------------------------------------------
/*/{Protheus.doc} BNGPEM11
Geração do arquivo de pedidos de VT à Alelo.

@author    Alexandre Alves da Silva
@version   1.xx
@since     $05.05.2017}
/*/
//------------------------------------------------------------------------------------------
User Function BNGPEM11

Private cPerg    := "BNGPEM11"
Private cString  := "SRA"
Private oGeraTxt
Private nSequen  := 0

fAsrPerg()
pergunte(cPerg,.F.)

dbSelectArea( "SRA" )
dbSetOrder( 1 )

//-> Montagem da tela de processamento.
DEFINE MSDIALOG oGeraTxt FROM  200,001 TO 410,480 TITLE OemToAnsi( "Pedidos de VT ALELO" ) PIXEL

@ 002, 010 TO 095, 230 OF oGeraTxt  PIXEL

@ 010, 018 SAY " Este programa ira gerar o arquivo texto para compra dos       " SIZE 200, 007 OF oGeraTxt PIXEL
@ 018, 018 SAY " Beneficios da VT ALELO.                                       " SIZE 200, 007 OF oGeraTxt PIXEL
@ 026, 018 SAY "                                                               " SIZE 200, 007 OF oGeraTxt PIXEL

DEFINE SBUTTON FROM 070,128 TYPE 5 ENABLE OF oGeraTxt ACTION (Pergunte(cPerg,.T.))
DEFINE SBUTTON FROM 070,158 TYPE 1 ENABLE OF oGeraTxt ACTION (OkGeraTxt(),oGeraTxt:End())
DEFINE SBUTTON FROM 070,188 TYPE 2 ENABLE OF oGeraTxt ACTION (oGeraTxt:End())

ACTIVATE MSDIALOG oGeraTxt Centered

Return

//------------------------------------------------------------------------------------------
/*/{Protheus.doc} BNGPEM11
Geração do arquivo de pedidos de VT à Alelo.

@author    Alexandre Alves da Silva
@version   1.xx
@since     $05.05.2017}
/*/
//------------------------------------------------------------------------------------------
Static Function OkGeraTxt
Processa({|| RunCont() },"Processando...")
Return


//------------------------------------------------------------------------------------------
/*/{Protheus.doc} RUNCONT
Funcao auxiliar chamada pela PROCESSA.  A funcao PROCESSA monta a janela com a regua de 
processamento.

@author    Alexandre Alves da Silva
@version   1.xx
@since     $05.05.2017}
/*/
//------------------------------------------------------------------------------------------
Static Function RunCont

Local aCcProc := {}

Local cLocArq, cArqTxt
Local cOldChav, lCont, nPos
Local cOrdem
Local nOrd   := 0
Local nTotal
Local nContad

Private aEmpr, nPosEmpr, ARESIDFN 
Private cFilDe, cFilAte, cMatDe, cMatAte, cCcDe, cCcAte
Private cCnpj, cNomeEmpr, cFilCNPJ

Private nHdl

Private aRegTp := {0,0,0,0,0}

Private c_FilMat    := "@@@@@@@@"
Private c_FilAnt	:= "@@"
Private c_LocAnt    := "@@"

Pergunte(cPerg,.F.)
cFilDe     := mv_par01
cFilAte    := mv_par02
cMatDe     := mv_par03
cMatAte    := mv_par04
cCcDe      := mv_par05
cCcAte     := mv_par06
cLocArq    := Alltrim( mv_par07)
cSituacao  := mv_par08        
cCnpj      := mv_par09

         
cSitQuery := ""
For nReg:=1 to Len(cSituacao)    
	cSitQuery += "'"+Subs(cSituacao,nReg,1)+"'"
	If ( nReg+1 ) <= Len(cSituacao) 
		cSitQuery += "," 
	Endif
Next nReg 


// Cria Arquivo Texto
cLocArq := cLocArq + If(Right(cLocArq,1) # "\","\","")
//cArqTxt := cLocArq + Day2Str( dDataBase ) + Month2Str( dDataBase ) + Right(Year2Str( dDataBase ),2) + ".TXT"
cArqTxt := cLocArq + Year2Str( dDataBase ) + Month2Str( dDataBase ) + Day2Str( dDataBase ) + "001.APS"
nHdl := fCreate( cArqTxt )
If nHdl == -1
	MsgAlert("O arquivo de nome "+cArqTxt+" nao pode ser executado! Verifique os parametros.","Atencao!")
	Return
Endif

// Cria Arquivo dbf Temporario
fArqTemp()

// Busca o CNPJ da Empresa Principal
fBuscaCnpj( @cFilCNPJ, @cCnpj, @cNomeEmpr, @aEmpr )

// Processa Registro Tipo "0 - Registro Cabeçalho."
cOrdem   := Replicate("0",10)
nSequen  ++
fProcTp0( cOrdem )


//MsAguarde( {|| lCont := fMtaQuery()}, "Processando...", "Selecionado Registros... Aguarde! " )
MsAguarde( {|| lCont := fMtaQuery()},,)

nOrd ++

WSRA->( dbGotop() )
Do While WSRA->(!Eof())
	
	IncProc( "Processando Filial / Matricula.: " + WSRA->(RA_FILIAL+" - "+RA_MAT) )
	
	// Processa Registro Tipo "1" - Locais de Entrega.
    If c_LocAnt = "@@"

        cFilCNPJ := WSRA->(AllTrim(ZZP_FILZZP))
        cCnpj    := " "
        fBuscaCnpj( @cFilCNPJ, @cCnpj, @cNomeEmpr, @aEmpr )
        
	    nSequen  ++
		cOrdem := WSRA->(RA_FILIAL + RA_MAT) + AllTrim(Str(nOrd))+"001" + AllTrim(WSRA->ZZP_CODLOC) //+ "0000"
		fProcTp1( cOrdem )
		aRegTp[1]++
		c_LocAnt := WSRA->ZZP_CODLOC
	ElseIf c_LocAnt <> WSRA->ZZP_CODLOC
	
	    nOrd ++
        cFilCNPJ := WSRA->(AllTrim(ZZP_FILZZP))
        cCnpj    := " "
        fBuscaCnpj( @cFilCNPJ, @cCnpj, @cNomeEmpr, @aEmpr )
        
	    nSequen  ++
		cOrdem := WSRA->(RA_FILIAL + RA_MAT) + AllTrim(Str(nOrd))+"001" + AllTrim(WSRA->ZZP_CODLOC) //+ "0000"
		fProcTp1( cOrdem )
		aRegTp[1]++
		c_LocAnt := WSRA->ZZP_CODLOC
	Endif
		

	
	// Processa Registro Tipo "2" - Registro de Usuario.
	If c_FilMat = "@@@@@@@@"

        SRA->(dbGoTo( WSRA->RA_RECNO ))
		SRJ->(dbSeek( xFilial("SRJ") + SRA->RA_CODFUNC ))
		CTT->(dbSeek( xFilial("CTT") + SRA->RA_CC ))

        nSequen  ++		
		cOrdem := WSRA->(RA_FILIAL + RA_MAT) + AllTrim(Str(nOrd))+"002" + AllTrim(WSRA->ZZP_CODLOC)// + "0001"
		fProcTp2( cOrdem )
		aRegTp[2]++
		
		aResidFn := fCargRes()
		
		c_FilMat := WSRA->(RA_FILIAL + RA_MAT)
	 
	ElseIf c_FilMat <> WSRA->(RA_FILIAL + RA_MAT)
	
	    nSequen  ++
	    cOrdem := c_FilMat + AllTrim(Str(nOrd))+"004" + AllTrim(WSRA->ZZP_CODLOC) //+ "0003"
	    fProcTp4( cOrdem, aResidFn ) //-> Registro de Resdidencia.
	    aRegTp[4]++
	    
   	    nSequen  ++
   	    cOrdem := c_FilMat + AllTrim(Str(nOrd))+"005" + AllTrim(WSRA->ZZP_CODLOC) //+ "0004"
	    fProcTp5( cOrdem, aResidFn ) //-> Registro Dados.
	    aRegTp[5]++
	
	    SRA->(dbGoTo( WSRA->RA_RECNO ))
		SRJ->(dbSeek( xFilial("SRJ") + SRA->RA_CODFUNC ))
		CTT->(dbSeek( xFilial("CTT") + SRA->RA_CC ))
		
		nSequen  ++
		cOrdem := WSRA->(RA_FILIAL + RA_MAT) + AllTrim(Str(nOrd))+"002" + AllTrim(WSRA->ZZP_CODLOC) //+ "0001"
		fProcTp2( cOrdem )
		aRegTp[2]++
		
		aResidFn := fCargRes()
		
		c_FilMat := WSRA->(RA_FILIAL + RA_MAT)
	EndIf
	
	// Processa Registro Tipo 3 - Registro Beneficios.
	nSequen  ++
	cOrdem := WSRA->(RA_FILIAL + RA_MAT) + AllTrim(Str(nOrd))+"003" + AllTrim(WSRA->ZZP_CODLOC) //+ "0002"
	fProcTp3( cOrdem )
	aRegTp[3]++
    
    WSRA->(	dbSkip() )
EndDo

//-> Processa Registros 4 e 5 do ultimo funcionario lido.
nSequen  ++
cOrdem := AllTrim( aResidFn[01][14] ) + AllTrim( aResidFn[01][02] ) + AllTrim(Str(nOrd))+"004" + AllTrim( aResidFn[01][13] )//+ "0003"
fProcTp4( cOrdem, aResidFn ) //-> Registro de Resdidencia.
aRegTp[4]++
	    
nSequen  ++
cOrdem := AllTrim( aResidFn[01][14] ) + AllTrim( aResidFn[01][02] ) + AllTrim(Str(nOrd))+"005" + AllTrim( aResidFn[01][13] )//+ "0004"
fProcTp5( cOrdem, aResidFn ) //-> Registro Dados.
aRegTp[5]++


// Processa Registro Tipo "9"
nSequen  ++
cOrdem := "9999999999"
fProcTp9( cOrdem )

dbSelectArea( "WTMP" )
dbGoTop()
ProcRegua( RecCount() )

Do While !Eof()
	IncProc( "Gravando Arquivo Texto..." )
	
    cLin := WTMP->ASR_TXT
	cLin += cEol
	
	fGravaTxt( cLin )
	
	dbSkip()
EndDo
WTMP->(dbCloseArea())
WSRA->(dbCloseArea())

fClose( nHdl )

Return


//------------------------------------------------------------------------------------------
/*/{Protheus.doc} BNGPEM11
Geração do arquivo de pedidos de VT à Alelo.

@author    Alexandre Alves da Silva
@version   1.xx
@since     $05.05.2017}
/*/
//------------------------------------------------------------------------------------------
Static Function fProcTp0( cOrdem )

Local cLin

cLin := "0"											    // 001 - 001 -> 001 - Tipo do Registro
cLin += fConvData( dDataBase, "DDMMAAAA" )				// 002 - 009 -> 008 - Data do Emissao do Arquivo
cLin += fCvInf(cCnpj,    'N',14,.F.)					// 010 - 023 -> 014 - CNPJ da Empresa Principal
cLin += fCvInf(cNomeEmpr,'C',50,.T.)                    // 024 - 073 -> 050 - Razao Social da Empresa Principal
cLin += Space(157)										// 074 - 230 -> 157 - Brancos
cLin += "04"											// 231 - 232 -> 002 - Versao do Lay-Out
cLin += "00"											// 233 - 234 -> 002 - Release 00.
cLin += AllTrim( StrZero(nSequen,6) )                   // 235 - 240 -> 006 - Sequencia do arquivo.

fGravaDbf( cOrdem, cLin )

Return


//------------------------------------------------------------------------------------------
/*/{Protheus.doc} BNGPEM11
Geração do arquivo de pedidos de VT à Alelo.

@author    Alexandre Alves da Silva
@version   1.xx
@since     $05.05.2017}
/*/
//------------------------------------------------------------------------------------------
Static Function fProcTp1( cOrdem )

Local cLin
Local cAux := ""

cLin := "1"											      // 001 a 001 -> 001 - Tipo do Registro
cLin += fCvInf(aEmpr[1][3],     'N',14,.F.)               // 002 a 015 -> 014 - Numero do CNPJ
cLin += fCvInf(WSRA->ZZP_CODLOC,'N',03,.F.)               // 016 a 018 -> 003 - Endereço de Trabalho / Entrega (Sequencia)
cLin += fCvInf(WSRA->ZZP_LOGRAD,'C',50,.T.)               // 019 a 068 -> 050 - Logradouro
cLin += fCvInf(WSRA->ZZP_NUMLOG,'C',15,.T.)               // 069 a 083 -> 015 - Numero
cLin += fCvInf(WSRA->ZZP_COMPLE,'C',20,.T.)               // 084 a 103 -> 020 - Complemento
cLin += fCvInf(WSRA->ZZP_BAIRRO,'C',35,.T.)               // 104 a 138 -> 035 - Bairro
cLin += fCvInf(WSRA->ZZP_CEP,   'C',08,.F.)               // 139 a 146 -> 008 - CEP

cAux := Posicione("CC2",1,xFilial('CC2')+ZZP->ZZP_ESTADO+ZZP->ZZP_CODMUN,"CC2_MUN")                                      

cLin += fCvInf(cAux,            'C',30,.T.)               // 147 a 176 -> 030 - Cidade
cLin += fCvInf(WSRA->ZZP_ESTADO,'C',02,.F.)               // 177 a 178 -> 002 - Estado
cLin += fCvInf(WSRA->ZZP_RESPON,'C',45,.T.)               // 179 a 223 -> 045 - Responsavel pelo Recebimento    
cLin += Space(011)									      // 224 a 234 -> 011 - Brancos
cLin += AllTrim( StrZero(nSequen,6) )                     // 235 - 240 -> 006 - Sequencia do arquivo.

fGravaDbf( cOrdem, cLin )

Return


//------------------------------------------------------------------------------------------
/*/{Protheus.doc} BNGPEM11
Geração do arquivo de pedidos de VT à Alelo.

@author    Alexandre Alves da Silva
@version   1.xx
@since     $05.05.2017}
/*/
//------------------------------------------------------------------------------------------
Static Function fProcTp2( cOrdem )

Local cLin
Local nDias := 0

cLin := "2"								     // 001 a 001 -> 001 - Tipo do Registro
cLin += fCvInf(aEmpr[1][3],     'N',14,.F.)  // 002 a 015 -> 014 - Numero do CNPJ
cLin += fCvInf(WSRA->ZZP_CODLOC,'N',03,.F.)  // 016 a 018 -> 003 - Endereço de Trabalho / Entrega (Sequencia)			                        
cLin += fCvInf(WSRA->RA_MAT,    'C',15,.T.)  // 019 a 033 -> 015 - Matricula do Funcionario							                        
cLin += fCvInf(SRA->RA_NOME,    'C',50,.T.)  // 034 a 083 -> 050 - Nome do Funcionario
cLin += fCvInf(SRA->RA_CIC,     'N',11,.T.)  // 084 a 094 -> 011 - CPF                              
cLin += fCvInf(SRA->RA_RG,      'C',09,.T.)  // 095 a 103 -> 009 - RG	
cLin += Space(02)                            // 104 a 105 -> 002 - Digito RG
cLin += fCvInf(SRA->RA_RGUF,    'C',02,.F.)  // 106 a 107 -> 009 - Estado Emissor do RG
cLin += fConvData(SRA->RA_NASC, "DDMMAAAA")	 // 108 a 115 -> 008 - Data Nascimento
cLin += fCvInf(CTT->CTT_DESC01, 'C',45,.T.)  // 116 a 160 -> 045 - Departamento (C Custo)
cLin += fCvInf(SRJ->RJ_DESC,    'C',45,.T.)  // 161 a 205 -> 045 - Cargo/Funcao

//-> Resgatando dias Trabalhados para o VT.
nDias := WSRA->(R0_QDIACAL / R0_QDIAINF)
nDias := NoRound(nDias,0)

cLin += fCvInf(Str(nDias),'N',03,.F.)        // 206 a 208 -> 003 - Qde Dias Trabalhados
cLin += Space(026)	                         // 209 a 234 -> 026 - Brancos
cLin += AllTrim( StrZero(nSequen,6) )        // 235 - 240 -> 006 - Sequencia do arquivo.

fGravaDbf( cOrdem, cLin )

Return


//------------------------------------------------------------------------------------------
/*/{Protheus.doc} BNGPEM11
Geração do arquivo de pedidos de VT à Alelo.

@author    Alexandre Alves da Silva
@version   1.xx
@since     $05.05.2017}
/*/
//------------------------------------------------------------------------------------------
Static Function fProcTp3( cOrdem )

Local cLin

cLin := "3"                                                 // 001 a 001 -> 001 - Tipo do Registro
cLin += fCvInf(aEmpr[1][3],                    'N',14,.F.)  // 002 a 015 -> 014 - Numero do CNPJ
cLin += fCvInf(WSRA->RA_MAT,                   'C',15,.F.)  // 016 a 030 -> 015 - Matricula do Funcionario
cLin += fCvInf(WSRA->RN_ITEMPED,               'N',06,.T.)  // 031 a 036 -> 006 - Codigo do Beneficio
cLin += fCvInf(WSRA->RN_DESC,                  'C',50,.T.)  // 037 a 086 -> 050 - Descrição do Beneficio
cLin += fCvInf(WSRA->(Str((RN_VUNIATU * 100))),'N',12,.T.)  // 087 a 098 -> 012 - Valor do Item
cLin += fCvInf(WSRA->(Str(R0_QDIAINF)),        'N',03,.F.)  // 099 a 101 -> 003 - Quantidade de Itens (por dia)
cLin += Space(025)                                          // 102 a 126 -> 025 - Número Cartão
cLin += Space(108)                                          // 127 a 234 -> 108 - Brancos
cLin += AllTrim( StrZero(nSequen,6) )                       // 235 - 240 -> 006 - Sequencia do arquivo.

fGravaDbf( cOrdem, cLin )

Return


//------------------------------------------------------------------------------------------
/*/{Protheus.doc} BNGPEM11
Geração do arquivo de pedidos de VT à Alelo.

@author    Alexandre Alves da Silva
@version   1.xx
@since     $05.05.2017}
/*/
//------------------------------------------------------------------------------------------
Static Function fProcTp4( cOrdem, aResid )

Local cLin

cLin := "4"											    //-> 001 a 001 -> 001 - Tipo do Registro
cLin += aResid[01][01]                                  //-> 002 a 015 -> 014 - Numero do CNPJ
cLin += aResid[01][02]                                  //-> 016 a 030 -> 015 - Matricula
cLin += aResid[01][03]                                  //-> 031 a 080 -> 050 - Logradouro do Endereço do Funcionario
cLin += aResid[01][04]                                  //-> 081 a 095 -> 015 - Numero do Logradouro
cLin += aResid[01][05]                                  //-> 096 a 115 -> 020 - Complemento
cLin += aResid[01][06]                                  //-> 116 a 150 -> 035 - Bairro
cLin += aResid[01][07]                                  //-> 151 a 158 -> 008 - CEP
cLin += aResid[01][08]                                  //-> 159 a 188 -> 030 - Cidade
cLin += aResid[01][09]                                  //-> 189 a 190 -> 002 - Estado
cLin += aResid[01][10]                                  //-> 191 a 191 -> 001 - SOLICITAR SUJESTÃO DE ROTA – CONTEÚDO “N” ou “S”
cLin += aResid[01][11]                                  //-> 192 a 203 -> 012 - VALOR TOTAL DE VALES-TRANSPORTE (P/ CALC. REDUÇÃO)
cLin += Space(031)                                      //-> 204 a 234 -> 012 - Brancos
cLin += AllTrim( StrZero(nSequen,6) )                   //-> 235 a 240 -> 006 - Sequencia do arquivo.

fGravaDbf( cOrdem, cLin )

Return


//------------------------------------------------------------------------------------------
/*/{Protheus.doc} BNGPEM11
Geração do arquivo de pedidos de VT à Alelo.

@author    Alexandre Alves da Silva
@version   1.xx
@since     $05.05.2017}
/*/
//------------------------------------------------------------------------------------------
Static Function fProcTp5( cOrdem, aResid )

Local cLin

cLin := "5"											    // 001 a 001 -> 001 - Tipo do Registro
cLin += aResid[01][01]                                  // 002 a 015 -> 014 - Numero do CNPJ
cLin += aResid[01][02]                                  // 016 a 030 -> 015 - Matricula
cLin += aResid[01][12]                                  // 031 a 080 -> 050 - Nome da Mãe
cLin += Space(154)                                      // 081 a 234 -> 154 - Brancos
cLin += AllTrim( StrZero(nSequen,6) )                   // 235 a 240 -> 006 - Sequencia do arquivo.

fGravaDbf( cOrdem, cLin )

Return


//------------------------------------------------------------------------------------------
/*/{Protheus.doc} BNGPEM11
Geração do arquivo de pedidos de VT à Alelo.

@author    Alexandre Alves da Silva
@version   1.xx
@since     $05.05.2017}
/*/
//------------------------------------------------------------------------------------------
Static Function fProcTp9( cOrdem )

Local cLin

cLin := "9"											    // 001 a 001 -> 001 - Tipo do Registro
cLin += StrZero(aRegTp[1],06)							// 002 a 007 -> 006 - Quantidade de Rgeistros Tipo 1
cLin += StrZero(aRegTp[2],06)							// 008 a 013 -> 006 - Quantidade de Rgeistros Tipo 2
cLin += StrZero(aRegTp[3],06)							// 014 a 019 -> 006 - Quantidade de Rgeistros Tipo 3
cLin += StrZero(aRegTp[4],06)							// 020 a 025 -> 006 - Quantidade de Rgeistros Tipo 4
cLin += StrZero(aRegTp[5],06)							// 026 a 031 -> 006 - Quantidade de Rgeistros Tipo 5
cLin += Space(203)										// 032 a 234 -> 203 - Brancos
cLin += AllTrim( StrZero(nSequen,6) )                   // 235 a 240 -> 006 - Sequencia do arquivo.

fGravaDbf( cOrdem, cLin )

Return


//------------------------------------------------------------------------------------------
/*/{Protheus.doc} BNGPEM11
Geração do arquivo de pedidos de VT à Alelo.

@author    Alexandre Alves da Silva
@version   1.xx
@since     $05.05.2017}
/*/
//------------------------------------------------------------------------------------------
Static Function fGravaTxt( cLin )

If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
	If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
		Return
	Endif
Endif

Return


//------------------------------------------------------------------------------------------
/*/{Protheus.doc} BNGPEM11
Geração do arquivo de pedidos de VT à Alelo.

@author    Alexandre Alves da Silva
@version   1.xx
@since     $05.05.2017}
/*/
//------------------------------------------------------------------------------------------
Static Function fBuscaCnpj( cFilCNPJ, cCnpj, cNomeEmpr, aEmpr )

DEFAULT cCnpj     := ""
DEFAULT cNomeEmpr := ""
DEFAULT cFilCNPJ  := ""
DEFAULT aEmpr     := {}

SM0->( dbGoTop() )

Do While SM0->( !Eof() )

    If !Empty(cFilCNPJ)

       If SM0->( AllTrim(M0_CODFIL) ) = AllTrim(cFilCNPJ)
       
          cNomeEmpr := Alltrim( SM0->M0_NOMECOM )
       
          Aadd(aEmpr,{SM0->M0_CODFIL,;	 // 01 - Codigo da Filial
                      SM0->M0_NOMECOM,; // 02 - Nome Completo da Empresa
                      SM0->M0_CGC,;	 // 03 - CNPJ
                      SM0->M0_NOME,;	 // 04 - Nome Reduzido
                      SM0->M0_INSC,;	 // 05 - Inscricao Estadual
                      SM0->M0_INSCM,;	 // 06 - Inscricao Municipal
                     })
       EndIf    
    ElseIf !Empty(cCnpj)
	
	   If SM0->( AllTrim(M0_CGC) ) = AllTrim(cCnpj)
	
          cNomeEmpr := Alltrim( SM0->M0_NOMECOM )
       
          Aadd(aEmpr,{SM0->M0_CODFIL,;	 // 01 - Codigo da Filial
                      SM0->M0_NOMECOM,; // 02 - Nome Completo da Empresa
                      SM0->M0_CGC,;	 // 03 - CNPJ
                      SM0->M0_NOME,;	 // 04 - Nome Reduzido
                      SM0->M0_INSC,;	 // 05 - Inscricao Estadual
                      SM0->M0_INSCM,;	 // 06 - Inscricao Municipal
                     })
	   EndIf
	EndIf
	
	SM0->( dbSkip() )
EndDo

Return


//------------------------------------------------------------------------------------------
/*/{Protheus.doc} BNGPEM11
Geração do arquivo de pedidos de VT à Alelo.

@author    Alexandre Alves da Silva
@version   1.xx
@since     $05.05.2017}
/*/
//------------------------------------------------------------------------------------------
Static Function fArqTemp()

Local aOld    := GETAREA()
Local aCampos := {}
Local cArqDbf
Local cArqNtx

Aadd(aCampos,{ "ASR_CHAVE"  , "C" , 015 , 0 })
Aadd(aCampos,{ "ASR_TXT"    , "C" , 240 , 0 })

cArqDbf := CriaTrab( aCampos, .T. )
dbUseArea( .T.,, cArqDbf, "WTMP", .F. )

cArqNtx := CriaTrab( Nil, .F. )
IndRegua( "WTMP", cArqNtx, "ASR_CHAVE", , , "Selecionando registros..." )

RESTAREA( aOld )

Return


//------------------------------------------------------------------------------------------
/*/{Protheus.doc} BNGPEM11
Geração do arquivo de pedidos de VT à Alelo.

@author    Alexandre Alves da Silva
@version   1.xx
@since     $05.05.2017}
/*/
//------------------------------------------------------------------------------------------
Static Function fGravaDbf( cOrdem, cLin )

Local aOld := GETAREA()

dbSelectArea( "WTMP" )
RecLock("WTMP",.T.)
WTMP->ASR_CHAVE := cOrdem
WTMP->ASR_TXT   := cLin
MsUnlock()

RESTAREA( aOld )

Return


//------------------------------------------------------------------------------------------
/*/{Protheus.doc} BNGPEM11
Geração do arquivo de pedidos de VT à Alelo.

@author    Alexandre Alves da Silva
@version   1.xx
@since     $05.05.2017}
/*/
//------------------------------------------------------------------------------------------
Static Function fMtaQuery()

Local lRet    := .F.
Local lCttFil := fX2Compart( "CTT" )
Local cQuery       

cQuery := "SELECT  RA_FILIAL  "+CRLF
cQuery += "       ,RA_MAT     "+CRLF
cQuery += "       ,R0_MEIO    "+CRLF
cQuery += "       ,RN_ITEMPED "+CRLF
cQuery += "       ,RN_DESC    "+CRLF
cQuery += "       ,RN_VUNIATU "+CRLF
cQuery += "       ,R0_QDIACAL "+CRLF
cQuery += "       ,R0_QDIAINF "+CRLF
cQuery += "       ,R0_DIASPRO "+CRLF
cQuery += "       ,R0_VALCAL  "+CRLF
cQuery += "       ,RN_COD     "+CRLF
cQuery += "       ,RA_CC      "+CRLF
cQuery += "       ,RA_LOCVB   "+CRLF
cQuery += "       ,SRA.R_E_C_N_O_ AS RA_RECNO "+CRLF
cQuery += "       ,ZZP_FILZZP "+CRLF
cQuery += "       ,ZZP_CUSTO  "+CRLF
cQuery += "       ,ZZP_LOGRAD "+CRLF
cQuery += "       ,ZZP_NUMLOG "+CRLF
cQuery += "       ,ZZP_COMPLE "+CRLF
cQuery += "       ,ZZP_BAIRRO "+CRLF
cQuery += "       ,ZZP_CEP    "+CRLF
cQuery += "       ,ZZP_ESTADO "+CRLF
cQuery += "       ,ZZP_CODMUN "+CRLF
cQuery += "       ,ZZP_RESPON "+CRLF
cQuery += "       ,ZZP_CODLOC "+CRLF
cQuery += "FROM "+RetSqlName("SRA")+" SRA     "+CRLF
cQuery += "INNER JOIN "+RetSqlName("SR0")+" SR0 ON RA_FILIAL  = R0_FILIAL AND RA_MAT = R0_MAT    "+CRLF
cQuery += "INNER JOIN "+RetSqlName("CTT")+" CTT ON CTT_CUSTO  = RA_CC                            "+CRLF

If Empty(xFilial("SRN"))
  cQuery += "INNER JOIN "+RetSqlName("SRN")+" SRN ON RN_COD = R0_MEIO "+CRLF
Else
  cQuery += "INNER JOIN "+RetSqlName("SRN")+" SRN ON RA_FILIAL = RN_FILIAL AND RN_COD = R0_MEIO "+CRLF
Endif

//cQuery += "INNER JOIN "+RetSqlName("ZZP")+" ZZP ON SUBSTR(ZZP_CODLOC,1,3) = SUBSTR(RA_LOCVB,2,3) "+CRLF
cQuery += "INNER JOIN "+RetSqlName("ZZP")+" ZZP ON ZZP_CODLOC = RA_LOCVB "+CRLF
cQuery += "WHERE RA_FILIAL BETWEEN '" + cFilDe + "' AND '" + cFilAte + "' "+CRLF
cQuery += "  AND RA_MAT    BETWEEN '" + cMatDe + "' AND '" + cMatAte + "' "+CRLF
cQuery += "  AND RA_CC     BETWEEN '" + cCcDe  + "' AND '" + cCcAte  + "' "+CRLF
cQuery += "  AND R0_VALCAL <> 0 "+CRLF
cQuery += "  AND RA_SITFOLH	IN	("+cSitQuery+") "+CRLF
cQuery += "  AND ZZP_CODLOC <> 0 "+CRLF
cQuery += "  AND SRA.D_E_L_E_T_ <> '*' "+CRLF
cQuery += "  AND CTT.D_E_L_E_T_ <> '*' "+CRLF
cQuery += "  AND SRN.D_E_L_E_T_ <> '*' "+CRLF
cQuery += "  AND SR0.D_E_L_E_T_ <> '*' "+CRLF
cQuery += "  AND ZZP.D_E_L_E_T_ <> '*' "+CRLF
cQuery += " ORDER BY ZZP_CODLOC, RA_FILIAL, RA_MAT, R0_MEIO"

TCQuery cQuery New Alias "WSRA"
TcSetField( "WSRA", "RN_VUNIATU" , "N", 12, 2 )
TcSetField( "WSRA", "R0_QDIACAL" , "N", 06, 2 )
TcSetField( "WSRA", "R0_VALCAL"  , "N", 12, 2 )
TcSetField( "WSRA", "RA_RECNO"   , "N", 12, 0 )

dbSelectArea( "WSRA" )
dbGoTop()
If Used() .And. Len(Alltrim( WSRA->RA_MAT )) > 0
	lRet := .T.
EndIf

Return( lRet )


//------------------------------------------------------------------------------------------
/*/{Protheus.doc} BNGPEM11
Geração do arquivo de pedidos de VT à Alelo.

@author    Alexandre Alves da Silva
@version   1.xx
@since     $05.05.2017}
/*/
//------------------------------------------------------------------------------------------
Static Function fConvData( dData, cTipo )

Local uRet
Local i, cTmp
Local nPosDia, nPosMes, nPosAno
Local nTamDia, nTamMes, nTamAno
Local cDia, cMes, cAno
//Local lBarra, cBarra

cTipo  := Upper(cTipo)
//lBarra := "/" $ cTipo

nPosDia := At( "D", cTipo )
nPosMes := At( "M", cTipo )
nPosAno := At( "A", cTipo )

nTamDia := 0 ; nTamMes := 0 ; nTamAno := 0

// Verifica Quantidade de Digitos para os Itens da Data
For i := 1 To Len(cTipo)
	If SubStr(cTipo,i,1) == "D"
		nTamDia++
	ElseIf SubStr(cTipo,i,1) == "M"
		nTamMes++
	ElseIf SubStr(cTipo,i,1) == "A"
		nTamAno++
	EndIf
Next

cDia := StrZero( Day( dData ),nTamDia )
cMes := StrZero( Month( dData ),nTamMes )
cAno := StrZero( Year( dData ),4 )
cAno := Right(cAno,nTamAno )

//cBarra := If(lBarra,"/","")

//cTmp := Space( nTamDia ) + cBarra + Space( nTamMes ) + cBarra + Space( nTamAno )
cTmp := cTipo

If nPosDia > 0
	cTmp := Stuff( cTmp,nPosDia,nTamDia,cDia )
EndIf
If nPosMes > 0
	cTmp := Stuff( cTmp,nPosMes,nTamMes,cMes )
EndIf
If nPosAno > 0
	cTmp := Stuff( cTmp,nPosAno,nTamAno,cAno )
EndIf

uRet := cTmp

Return( uRet )


//------------------------------------------------------------------------------------------
/*/{Protheus.doc} BNGPEM11
Geração do arquivo de pedidos de VT à Alelo.

@author    Alexandre Alves da Silva
@version   1.xx
@since     $05.05.2017}
/*/
//------------------------------------------------------------------------------------------
Static Function fX2Compart( cTab )

Local lRet    := .T.
Local aOldAtu := GETAREA()
Local aOldSx2 := SX2->(GETAREA())

DEFAULT cTab  := "SRA"

SX2->(dbSetOrder( 1 ))
If SX2->(dbSeek( cTab ))
	If SX2->X2_MODO == "C"
		lRet := .T.
	Else
		lRet := .F.
	EndIf
EndIf

RESTAREA( aOldSx2 )
RESTAREA( aOldAtu )

Return( lRet )


//------------------------------------------------------------------------------------------
/*/{Protheus.doc} BNGPEM11
Geração do arquivo de pedidos de VT à Alelo.

@author    Alexandre Alves da Silva
@version   1.xx
@since     $05.05.2017}
/*/
//------------------------------------------------------------------------------------------
Static Function fAsrPerg()

Local aRegs := {}

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
aAdd(aRegs,{ cPerg,'01','Filial De ?                  ','','','mv_ch1','C',02,0,0,'G','           ','mv_par01','                 ','','','    ','','                 ','','','','',''                    ,'','','','',''                 ,'','','','',''      ,'','','' ,'SM0','' })
aAdd(aRegs,{ cPerg,'02','Filial Ate ?                 ','','','mv_ch2','C',02,0,0,'G','NaoVazio   ','mv_par02','                 ','','','    ','','                 ','','','','',''                    ,'','','','',''                 ,'','','','',''      ,'','','' ,'SM0','' })
aAdd(aRegs,{ cPerg,'03','Matricula De ?               ','','','mv_ch3','C',06,0,0,'G','           ','mv_par03','                 ','','','    ','','                 ','','','','',''                    ,'','','','',''                 ,'','','','',''      ,'','','' ,'SRA','' })
aAdd(aRegs,{ cPerg,'04','Matricula Ate ?              ','','','mv_ch4','C',06,0,0,'G','NaoVazio   ','mv_par04','                 ','','','    ','','                 ','','','','',''                    ,'','','','',''                 ,'','','','',''      ,'','','' ,'SRA','' })
aAdd(aRegs,{ cPerg,'05','Centro Custo De ?            ','','','mv_ch5','C',09,0,0,'G','           ','mv_par05','                 ','','','    ','','                 ','','','','',''                    ,'','','','',''                 ,'','','','',''      ,'','','' ,'CTT','' })
aAdd(aRegs,{ cPerg,'06','Centro Custo Ate ?           ','','','mv_ch6','C',09,0,0,'G','NaoVazio   ','mv_par06','                 ','','','    ','','                 ','','','','',''                    ,'','','','',''                 ,'','','','',''      ,'','','' ,'CTT','' })
aAdd(aRegs,{ cPerg,'07','Local Geracao do Arquivo  ?  ','','','mv_ch7','C',30,0,0,'G','NaoVazio   ','mv_par07','                 ','','','    ','','                 ','','','','',''                    ,'','','','',''                 ,'','','','',''      ,'','','' ,'   ','' })
aadd(aRegs,{ cPerg,'08','Situacoes ?                  ','','','mv_ch8','C',05,0,0,'G','fSituacao()','mv_par08','                 ','','','ADFT','','                 ','','','','',''                    ,'','','','',''                 ,'','','','',''      ,'','','' ,'   ','','S','','','','.RHSITUA.'}) //mariella
aAdd(aRegs,{ cPerg,'09','Filial do CNPJ ?             ','','','mv_ch9','C',20,0,0,'G','NaoVazio   ','mv_par09','                 ','','','    ','','                 ','','','','',''                    ,'','','','',''                 ,'','','','',''      ,'','','' ,'CF6','' })

ValidPerg(aRegs,cPerg)

Return

//------------------------------------------------------------------------------------------
/*/{Protheus.doc} BNGPEM11
Geração do arquivo de pedidos de VT à Alelo.

@author    Alexandre Alves da Silva
@version   1.xx
@since     $05.05.2017}
/*/
//------------------------------------------------------------------------------------------
Static Function fCvInf(cDado,cTipo,nTamanho,lRetEsp)

Local cAux    := ""
Local nX      := 0

//-> Se for para remover os caracteres especiais.
If lRetEsp
   cAux := u_removeCaracEspecial(cDado,7)
EndIf

//-> Formata o dado.
If cTipo = "N"
   cAux := AllTrim( If( Empty(cAux),cDado,cAux ) )
   cAux := If( Len( AllTrim(cAux) )  >= nTamanho, Right( AllTrim(cAux),nTamanho  ), AllTrim(cAux) )  
   cAux :=  PadL(cAux,nTamanho,"0")
   cAux := Right(cAux,nTamanho)
Else
   cAux := If( Empty(cAux),cDado,cAux )
   cAux := LTrim(cAux)
   cAux := RTrim(cAux)
   cAux := Left( PadR(cAux,nTamanho," "), nTamanho )  
EndIf

Return(cAux)


//------------------------------------------------------------------------------------------
/*/{Protheus.doc} BNGPEM11
Geração do arquivo de pedidos de VT à Alelo.

@author    Alexandre Alves da Silva
@version   1.xx
@since     $05.05.2017}
/*/
//------------------------------------------------------------------------------------------
Static Function fCargRes()

Local aRes    :={}
Local cLograd := AllTrim( fDescRCC('S054',SRA->RA_LOGRTP,1,4,5,20) )

cLograd += " " + SRA->( AllTrim(RA_LOGRDSC) )

AADD(aRes,{;
          fCvInf(aEmpr[1][3],     'N',14,.F.),;  //-> 001 - 014 - Numero do CNPJ
          fCvInf(SRA->RA_MAT,     'C',15,.F.),;  //-> 002 - 015 - Matricula
          fCvInf(cLograd,         'C',50,.T.),;  //-> 003 - 050 - Logradouro do Endereço do Funcionario
          fCvInf(SRA->RA_LOGRNUM, 'C',15,.F.),;  //-> 004 - 015 - Numero do Logradouro
          fCvInf(SRA->RA_COMPLEM, 'C',20,.T.),;  //-> 005 - 020 - Complemento do Endereço do Funcionario
          fCvInf(SRA->RA_BAIRRO,  'C',35,.T.),;  //-> 006 - 035 - Bairro do Endereço do Funcionario
          fCvInf(SRA->RA_CEP,     'N',08,.T.),;  //-> 007 - 008 - CEP do Endereço do Funcionario
          fCvInf(SRA->RA_MUNICIP, 'C',30,.T.),;  //-> 008 - 030 - Municipio do Endereço do Funcionario
          fCvInf(SRA->RA_ESTADO,  'C',02,.F.),;  //-> 009 - 002 - Estado do Endereço do Funcionario
          "N",;                                  //-> 010 - 020 - SOLICITAR SUJESTÃO DE ROTA – CONTEÚDO “N” ou “S”
          Replicate("0",12),;                    //-> 011 - 012 - VALOR TOTAL DE VALES-TRANSPORTE (P/ CALC. REDUÇÃO)
          fCvInf(SRA->RA_MAE,     'C',50,.T.),;  //-> 012 - 050 - Nome da Mae
          fCvInf(WSRA->ZZP_CODLOC,'N',03,.F.),;  //-> 013 - 003 - Endereço de Trabalho / Entrega (Sequencia)          
          fCvInf(SRA->RA_FILIAL,  'N',02,.F.);   //-> 014 - 002 - Filial
          })

Return(aRes)