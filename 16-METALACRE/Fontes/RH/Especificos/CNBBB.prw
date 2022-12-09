#INCLUDE "ap5mail.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
User Function CNBBB

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  CNBBB     º Autor ³ Luiz Alberto V A   º Data ³  07/08/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Cnab Abertura de Contas Banco do Brasil       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP7 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private cString
Private cPerg       := PadR("CNBBB",10)
Private oGeraTxt
Private cString := "SF2"      
Private _cMarca   := GetMark()
Private cQueryCad := ""
Private cArq      := ''
Private _cIndex   := ''
Private aFields   := {}
Private _nSeq   := 0
Private _nTotal := 0

INCLUI       := .F.
aCampos      := {}
_cPesqPed    := Space(6)
_nTotal      := 0

ValidPerg()

If !Pergunte(PadR(cPerg,10),.T.)
	Return
Endif

If !SA6->(dbSetOrder(1), dbSeek(xFilial("SA6")+MV_PAR03+MV_PAR04+MV_PAR05))
	MsgStop("Atenção Banco, Agência e Conta Não Localizados !")
	Return
Endif

AADD(aCampos,{'T9_OK'			,'#','@!','2','0'})
AADD(aCampos,{'T9_ADMISS'		,'Admissão','@!','8','0'})	
AADD(aCampos,{'T9_MATRIC'		,'Matricula','@!','6','0'})
AADD(aCampos,{'T9_NOME'			,'Nome Funcionário(a)','@!','50','0'})

Cria_TC9()

DbSelectArea('TC9')
@ 100,005 TO 500,750 DIALOG oDlgPedidos TITLE "Cnab Abertura Contas"


@ 006,005 TO 190,325 BROWSE "TC9" MARK "T9_OK" FIELDS aCampos Object _oBrwPed

@ 066,330 BUTTON "Marcar"         SIZE 40,15 ACTION MsAguarde({||MarcarTudo()},'Marcando Registros...')
@ 086,330 BUTTON "Desmarcar"      SIZE 40,15 ACTION MsAguarde({||DesMarcaTudo()},'Desmarcando Registros...')
@ 106,330 BUTTON "Gerar"  		  SIZE 40,15 ACTION MsAguarde({||OkGeraTxt()},'Gerando Arquivo...')
@ 183,330 BUTTON "_Sair"          SIZE 40,15 ACTION Close(oDlgPedidos)

Processa({|| Monta_TC9() } ,"Selecionando Informacoes dos Funcionários...")

@190,010 Say "Qtde de Funcionários Marcados: " + Str(_nSeq,5)

_oBrwPed:bMark := {|| Marcar()}

ACTIVATE DIALOG oDlgPedidos CENTERED

if Select("TC9") <> 0
	DbSelectArea("TC9")
	DbCloseArea()
	FErase(cArq+".DBF")
	FErase(_cIndex+ordbagext())
	_cIndex := ''
	cArq    := ''
endif
Return(.T.)


Static Function OkGeraTxt
*************************

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria o arquivo texto                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                   

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa a regua de processamento                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Processa({|| RunCont() },"Exportando Arquivo de Funcionarios Abertura de Contas")
Return

Static Function RunCont
***********************

Local nTamLin, cLin, cCpo
Local nConta   := 0
Local cExp := Space(1)
Local nTotReg := 0

dbSelectArea("SX6")
dbsetorder(1)

If DbSeek(XFILIAL("SX6")+"MV_CNBSEQ")
   cNumSeq := Soma1(GETMV("MV_CNBSEQ"),5)
   
   RecLock("SX6",.F.)
   X6_CONTEUD := cNumSeq
   MsUnlock()           
Else
   cNumSeq := '00001'

   RecLock("SX6",.T.)
   X6_VAR     := "MV_CNBSEQ"
   X6_TIPO    := "C"
   X6_DESCRIC := "Numerador Sequencial CNAB Ab Conta"
   X6_CONTEUD := "00001"
   MsUnlock()
endif                                          

Private cArqTxt := "C:\TEMP\CNBF" +(cNumSeq)+".TXT"  // "c:\edi\alfa\"+	\SYSTEM\NEOGRID\NOTAS
Private nHdl    := fCreate(cArqTxt)
Private cEOL    := "CHR(13)+CHR(10)"

If Empty(cEOL)
	cEOL := CHR(13)+CHR(10)
Else
	cEOL := Trim(cEOL)
	cEOL := &cEOL
Endif

If nHdl == -1
	MsgAlert("O arquivo de nome "+cArqTxt+" nao pode ser executado! Verifique os parametros.","Atencao!")
	Return
Endif

cBanco 		:= MV_PAR03
cAgencia    := MV_PAR04
cConta		:= MV_PAR05

nSeqFun		:= 1

dbSelectArea("TC9")
dbGoTop()            
ProcRegua(Reccount())

nTamLin := 149
cLin    := Space(nTamLin)+cEOL // Variavel para criacao da linha do registros para gravacao

// Cabecalho HEADER
	
cCpo := "0000000"+;  // (Zeros)
GravaData(dDatabase,.F.,5)+;  //Data Remessa
'MCIF460 '+;  //Nome do Arquivo
"201053072"+;  //Codig MCI da Empresa
StrZero(31872,5)+;  ///Numero do Processo
cNumSeq+;       //Sequencial de Remessa
'03'+;       //Versao do Layout
Left(AllTrim(SA6->A6_AGENCIA),4)+; //  Agencia da Empresa
AllTrim(Left(SA6->A6_DVAGE,1))+;           // Digito Agencia
StrZero(Val(SA6->A6_NUMCON),11)+;  // Conta da Empresa
AllTrim(Left(SA6->A6_DVCTA,1))+;               // Digito da Conta
'1'+;               		//Indicador de Envio do Kit - 1 Agencia Pagadora
Space(88)                 //BRANCOS

cLin := Stuff(cLin,01,149,cCpo)
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Gravacao no arquivo texto. Testa por erros durante a gravacao da    ³
//³ linha montada.                                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
	If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
   		Return
	Endif
Endif                          

nTotReg++
                             
        
While !Eof()
	IncProc()
	
	If TC9->T9_OK  <> _cMarca
		dbSelectArea("TC9")
		TC9->(dbSkip(1));Loop
	Endif                                        
	
	
	SRA->(dbSetOrder(1), dbSeek(xFilial("SRA")+TC9->T9_MATRIC))

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Incrementa a regua                                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	IncProc("Matricula----> " + TC9->T9_MATRIC)
	
	nTamLin := 149
	cLin    := Space(nTamLin)+cEOL // Variavel para criacao da linha do registros para gravacao

	// Detalha - 01
	
	cCpo := StrZero(nSeqFun,5)+;  // Sequencial da Empresa
	'01'+;  //Tipo Detalhe
	'1' +;  //Tipo da Pessoa
	"1"+;  //CPF Proprio
	StrZero(Val(SRA->RA_CIC),14)+;  ///cpf
	GravaData(SRA->RA_NASC,.F.,5)+;       //Data Nascimento
	PadR(SRA->RA_NOME,60)+;       //Nome do Cliente
	Space(25)+; //  Nome Personalizado
	Space(1)+;           // Branco
	Space(17)+;  // Uso da Empresa
	'2875'+; //  Agencia da Empresa
	'4'+;           // Digito Agencia
	'01'+;               		//Grupo Setex
	'9'+;               		//Dv Grupo Setex
	Space(8)                 //BRANCOS

	cLin := Stuff(cLin,01,149,cCpo)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Gravacao no arquivo texto. Testa por erros durante a gravacao da    ³
	//³ linha montada.                                                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
	   		Return
		Endif
	Endif          
	
	nTotReg++                             

	nTamLin := 149
	cLin    := Space(nTamLin)+cEOL // Variavel para criacao da linha do registros para gravacao

	// Detalha - 02
	
	cEstCiv := '01'
	If SRA->RA_ESTCIVI=='S'
		cEstCiv := '01'
	ElseIf SRA->RA_ESTCIVI=='C'
		cEstCiv := '03'
	ElseIf SRA->RA_ESTCIVI=='D'
		cEstCiv := '07'
	ElseIf SRA->RA_ESTCIVI=='Q'
		cEstCiv := '06'
	ElseIf SRA->RA_ESTCIVI=='V'
		cEstCiv := '05'
	Endif

	cNacion := '01'
	If SRA->RA_NACIONA <> '10'
		cNacion := '02'
	Endif
	
	cGrau := '002'
	If SRA->RA_GRINRAI=='10'
		cGrau := '001'
	ElseIf SRA->RA_GRINRAI $ '20*25*30*35*40'
		cGrau := '003'
	ElseIf SRA->RA_GRINRAI $ '45*'
		cGrau := '002'
	ElseIf SRA->RA_GRINRAI $ '50'
		cGrau := '004'
	ElseIf SRA->RA_GRINRAI $ '55'
		cGrau := '006'
	ElseIf SRA->RA_GRINRAI $ '65'
		cGrau := '007'
	ElseIf SRA->RA_GRINRAI $ '75'
		cGrau := '008'
	Endif
			
	cCpo := StrZero(nSeqFun,5)+;  // Sequencial da Empresa
	'02'+;  //Tipo Detalhe
	SRA->RA_SEXO +;  //Sexo
	cNacion+;  //Nacionalidade
	PadR(SRA->RA_NATURAL,25)+;  ///Naturalidade
	'20'+;       	//Tipo de Documento
	PadR(Limpar(SRA->RA_RG),20)+;       	//Numero do Documento
	PadR(SRA->RA_RGORG,15)+; 		//Orgao Emissor
	GravaData(SRA->RA_DTRGEXP,.F.,5)+;       //Data da Emissao
	cEstCiv+;  		// Estado Civil
	'01'+;  		// Capacidade Civil
	'122'+;  		// Formacao
	cGrau+;  		// Grau de Instrucao
	'000'+;  		// Natureza da Ocupacao
	'000'+;  		// Ocupacao
	StrZero((SRA->RA_SALARIO*100),15)+;  		// Rendimento
	StrZero(Month(dDataBase),2)+StrZero(Year(dDataBase),4)+; //  Mes e Ano Rendimento
	Space(33)                 //BRANCOS

	cLin := Stuff(cLin,01,149,cCpo)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Gravacao no arquivo texto. Testa por erros durante a gravacao da    ³
	//³ linha montada.                                                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
	   		Return
		Endif
	Endif
             
	nTotReg++
                             
	nTamLin := 149
	cLin    := Space(nTamLin)+cEOL // Variavel para criacao da linha do registros para gravacao

	// Detalha - 03
	
	cCpo := StrZero(nSeqFun,5)+;  // Sequencial da Empresa
	'03'+;  //Tipo Detalhe
	PadR(SRA->RA_MAE,60) +;  //Nome Mae
	PadR(SRA->RA_PAI,60) +;  //Nome Pai
	Space(23)                 //BRANCOS

	cLin := Stuff(cLin,01,149,cCpo)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Gravacao no arquivo texto. Testa por erros durante a gravacao da    ³
	//³ linha montada.                                                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
	   		Return
		Endif
	Endif
                   
	nTotReg++                             

	nTamLin := 149
	cLin    := Space(nTamLin)+cEOL // Variavel para criacao da linha do registros para gravacao

	// Detalha - 04
	
	cCpo := StrZero(nSeqFun,5)+;  // Sequencial da Empresa
	'04'+;  //Tipo Detalhe
	'1' +;  //Tipo CPF
	StrZero(0,11) +;  //CPF Conjuge
	StrZero(0,8) +;  //Data Nascimento
	Space(60) +;  //Nome
	Space(63)                 //BRANCOS

	cLin := Stuff(cLin,01,149,cCpo)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Gravacao no arquivo texto. Testa por erros durante a gravacao da    ³
	//³ linha montada.                                                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
	   		Return
		Endif
	Endif

	nTotReg++                             

	SRJ->(dbSetOrder(1),dbSeek(xFilial("SRJ")+SRA->RA_CODFUNC))

	nTamLin := 149
	cLin    := Space(nTamLin)+cEOL // Variavel para criacao da linha do registros para gravacao

	// Detalha - 05
	
	cCpo := StrZero(nSeqFun,5)+;  // Sequencial da Empresa
	'05'+;  //Tipo Detalhe
	'1' +;  //Contrato de Trabalho
	'1' +;  //Tipo de Pessoa
	PadR(SM0->M0_CGC,14) +;  //CPF Empregador
	StrZero(Month(SRA->RA_ADMISSA),2)+StrZero(Year(SRA->RA_ADMISSA),4)+;       //Data Admissao
	PADR(Left(SM0->M0_NOMECOM,60),60) +;  //nOME Empregador
	PadR(Left(SRJ->RJ_DESC,60),60) +;  //Cargo
	'6'                 //Nivel do Cargo

	cLin := Stuff(cLin,01,149,cCpo)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Gravacao no arquivo texto. Testa por erros durante a gravacao da    ³
	//³ linha montada.                                                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
	   		Return
		Endif
	Endif

	nTotReg++
	
	nTamLin := 149
	cLin    := Space(nTamLin)+cEOL // Variavel para criacao da linha do registros para gravacao

	// Detalha - 06
	
	cCpo := StrZero(nSeqFun,5)+;  // Sequencial da Empresa
	'06'+;  //Tipo Detalhe
	PadR(AllTrim(SRA->RA_ENDEREC) + ' ' + AllTrim(SRA->RA_COMPLEM) ,60) +;  //Endereço
	PadR(SRA->RA_BAIRRO,30) +;  //Distrito Bairro
	PadR(SRA->RA_CEP,08) +;  //CEP
	'0011' +;  //DDD
	PadR(Left(Limpar(SRA->RA_TELEFON),9),9) +;  //Telefone
	'000000000'+;       //Caixa Postal
	'03'+;       //Situacao do Imovel
	'000000' +;  //Inicio de Residencia mmaaaa
	Space(15)               //Brancos

	cLin := Stuff(cLin,01,149,cCpo)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Gravacao no arquivo texto. Testa por erros durante a gravacao da    ³
	//³ linha montada.                                                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
	   		Return
		Endif
	Endif

	nTotReg++

	nTamLin := 149
	cLin    := Space(nTamLin)+cEOL // Variavel para criacao da linha do registros para gravacao

	// Detalha - 07
	
	cCpo := StrZero(nSeqFun,5)+;  // Sequencial da Empresa
	'07'+;  //Tipo Detalhe
	PadR(AllTrim(SM0->M0_ENDCOB),60)+;  //Endereço
	PadR(RTRIM(SM0->M0_BAIRCOB),30) +;  //Distrito Bairro
	PadR(RTRIM(SM0->M0_CEPCOB),08) +;  //CEP
	'0011' +;  //DDD
	PadR(Left(Limpar(SM0->M0_TEL),9),9) +;  //Telefone
	StrZero(0,20)+;       //Ramal
	'000000000'+;       //Caixa Postal
	Space(03)               //Brancos

	cLin := Stuff(cLin,01,149,cCpo)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Gravacao no arquivo texto. Testa por erros durante a gravacao da    ³
	//³ linha montada.                                                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
	   		Return
		Endif
	Endif

	nTotReg++

	nTamLin := 149
	cLin    := Space(nTamLin)+cEOL // Variavel para criacao da linha do registros para gravacao

	// Detalha - 08
	
	cCpo := StrZero(nSeqFun,5)+;  // Sequencial da Empresa
	'08'+;  //Tipo Detalhe
	PadR(AllTrim(SRA->RA_EMAIL),60)+;  //Email
	Space(83)               //Brancos

	cLin := Stuff(cLin,01,149,cCpo)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Gravacao no arquivo texto. Testa por erros durante a gravacao da    ³
	//³ linha montada.                                                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
	   		Return
		Endif
	Endif

	nTotReg++

	nTamLin := 149
	cLin    := Space(nTamLin)+cEOL // Variavel para criacao da linha do registros para gravacao

	// Detalha - 09
	
	cCpo := StrZero(nSeqFun,5)+;  // Sequencial da Empresa
	'09'+;  //Tipo Detalhe
	Space(60)+;  //Nome Primeira Referencia
	StrZero(0,4)+;  //DDD
	StrZero(0,9)+;  //Telefone
	Space(70)               //Brancos

	cLin := Stuff(cLin,01,149,cCpo)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Gravacao no arquivo texto. Testa por erros durante a gravacao da    ³
	//³ linha montada.                                                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
	   		Return
		Endif
	Endif

	nTotReg++

	nTamLin := 149
	cLin    := Space(nTamLin)+cEOL // Variavel para criacao da linha do registros para gravacao

	// Detalha - 10
	
	cCpo := StrZero(nSeqFun,5)+;  // Sequencial da Empresa
	'10'+;  //Tipo Detalhe
	Space(60)+;  //Nome Segunda Referencia
	StrZero(0,4)+;  //DDD
	StrZero(0,9)+;  //Telefone
	Space(70)               //Brancos

	cLin := Stuff(cLin,01,149,cCpo)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Gravacao no arquivo texto. Testa por erros durante a gravacao da    ³
	//³ linha montada.                                                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
	   		Return
		Endif
	Endif

	nTotReg++
	nConta++                  
	++nSeqFun

	dbSelectArea("TC9")	
	TC9->(dbSkip(1))
EndDo                     

nTamLin := 149
cLin    := Space(nTamLin)+cEOL // Variavel para criacao da linha do registros para gravacao

// Detalha - 11
	
cCpo := '9999999'+;  // Sequencial da Empresa
StrZero(nConta,5)+;  //Total de Funcionarios
StrZero(++nTotReg,9)+;  //Total Cabecalho + Rodape
Space(129)               //Brancos

cLin := Stuff(cLin,01,149,cCpo)
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Gravacao no arquivo texto. Testa por erros durante a gravacao da    ³
//³ linha montada.                                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
	If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
   		Return
	Endif
Endif



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ O arquivo texto deve ser fechado, bem como o dialogo criado na fun- ³
//³ cao anterior.                                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

fClose(nHdl)

//ENVIAEMAIL("")
MsgBox("Exportacao de Dados Realizada com Sucesso","Informacao","INFO")

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³VALIDPERG º Autor ³ AP5 IDE            º Data ³  06/05/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Verifica a existencia das perguntas criando-as caso seja   º±±
±±º          ³ necessario (caso nao existam).                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function ValidPerg

Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,10)

Aadd(aRegs,{cPerg,"01","Admissao Inicial","","","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","   ","","",""})
Aadd(aRegs,{cPerg,"02","Admissao Final  ","","","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","   ","","",""})
Aadd(aRegs,{cPerg,'03',"Banco"           ,"","","mv_ch3","C",3,0,0 ,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","SA6","","",""})
Aadd(aRegs,{cPerg,'04',"Agencia"         ,"","","mv_ch4","C",5,0,0 ,"G","","MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","","   ","","",""})
Aadd(aRegs,{cPerg,'05',"Conta"           ,"","","mv_ch5","C",10,0,0,"G","","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","","   ","","",""})

For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next

dbSelectArea(_sAlias)

Return

******************************************
Static Function MarcarTudo()
DbSelectArea('TC9')      
dbGoTop()
While !Eof()
	MsProcTxt('Aguarde...')
	RecLock('TC9',.F.)
	TC9->T9_OK := _cMarca
	MsUnlock()
	DbSkip()
EndDo
DbGoTop()
DlgRefresh(oDlgPedidos)
SysRefresh()
Return(.T.)

******************************************
Static Function DesmarcaTudo()
DbSelectArea('TC9') 
dbGoTop()
While !Eof()
	MsProcTxt('Aguarde...')
	RecLock('TC9',.F.)
	TC9->T9_OK := ThisMark()
	MsUnlock()
	DbSkip()
EndDo
DbGoTop()
DlgRefresh(oDlgPedidos)
SysRefresh()
Return(.T.)


******************************************
Static Function Marcar()
DbSelectArea('TC9')
RecLock('TC9',.F.)
If Empty(TC9->T9_OK)
	TC9->T9_OK := _cMarca
Endif
MsUnlock()
SysRefresh()
Return(.T.)

******************************************************
Static FUNCTION Cria_TC9()
aFields   := {}
AADD(aFields,{"T9_OK"     ,"C",02,0})
AADD(aFields,{'T9_ADMISS' ,"D",08,0})	
AADD(aFields,{'T9_MATRIC' ,"C",06,0})
AADD(aFields,{'T9_NOME'   ,"C",50,0})

cArq:=Criatrab(aFields,.T.)
DBUSEAREA(.t.,,cArq,"TC9")
Return

********************************************
Static Function Monta_TC9()
For _nX := 1 To 2
	If _nX = 1
		cQueryCad := " SELECT COUNT(*) AS TOTAL FROM " + RetSqlName("SRA") + " RA WHERE "
	Else
		cQueryCad := " SELECT RA.RA_MAT, RA.RA_NOME, RA.RA_ADMISSA FROM " + RetSqlName("SRA") + " RA WHERE "
	Endif
	cQueryCad += " RA.D_E_L_E_T_ = '' AND RA.RA_ADMISSA BETWEEN '" + DtoS(MV_PAR01) + "' AND '" + DtoS(MV_PAR02) + "' AND RA_BCDEPSA = '' "
	If _nX <> 1
		cQueryCad += " ORDER BY RA.RA_NOME "
	Endif

	TCQUERY cQueryCad NEW ALIAS "CAD"
	If _nX = 1
		_nCount := CAD->TOTAL
		DbCloseArea()
	Else
		TcSetField('CAD','RA_ADMISSA','D')
	Endif
Next

Dbselectarea("CAD")

ProcRegua(_nCount)

While CAD->(!EOF())
	IncProc()
	
	RecLock("TC9",.T.)
	TC9->T9_ADMISS	:=	CAD->RA_ADMISSA
	TC9->T9_MATRIC	:=	CAD->RA_MAT
	TC9->T9_NOME	:=	CAD->RA_NOME

	++_nSeq
	TC9->T9_OK  := _cMarca

	MsUnLock()

	DbSelectArea('CAD')
	CAD->(dBSkip())
EndDo   

Dbselectarea("CAD")
DbCloseArea()
Dbselectarea("TC9")
DbGoTop()

_cIndex:=Criatrab(Nil,.F.)
_cChave:="T9_NOME"
Indregua("TC9",_cIndex,_cChave,,,"Ordenando registros selecionados...")
DbSetIndex(_cIndex+ordbagext())
SysRefresh()
Return
                                                                             


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ENVIAEMAILºAutor  ³Microsiga           º Data ³  12/12/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ENVIAEMAIL(cNota)

Local lResult   := .f.				// Resultado da tentativa de comunicacao com servidor de E-Mail
Local cTitulo
Local lResult   := .f.				// Resultado da tentativa de comunicacao com servidor de E-Mail
Local cTitulo
Local lOk       	:= .T.
Local cBody			:=	"Segue Arquivo Espelho EDI Nota Fiscal NEOGRID foi gerado pelo usuario "+SUBSTR(cUsuario,7,15)+" no dia "+DTOC(DDATABASE)+" as "+SubStr(Time(),1,5) 
Local cErrorMsg		:=	""
Local aFiles 		:= 	{}
Local cServer     	:=	AllTrim(GetMV("MV_RELSERV"))
Local cAccount    	:=	AllTrim(GetMV("MV_RELACNT"))
Local cPassword   	:=	AllTrim(GetMV("MV_RELPSW"))
Local cFrom       	:=	RTrim(SuperGetMV("MV_RELFROM"))
Local cTo         	:=	GetNewPar("MV_EMAEDI",'silvia.fiscal@mssamazonia.com.br;gabriela.compras@mssamazonia.com.br')
Local cCC         	:=	''//lalberto@3lsystems.com.br' //AllTrim(GetMv("SC_TO"))
Local cSubject    	:=	"Espelho EDI Nota Fiscal NEOGRID "
	
If File(cArqTxt)
	cAnexo  := cArqTxt
Else
	cAnexo := ""
Endif	

	Connect Smtp Server cServer Account cAccount Password cPassword Result lOk
	
	If lOk
		If !MailAuth(cAccount,cPassword)
			Get Mail Error cErrorMsg
			ConOut("1 - " + cErrorMsg)
			Disconnect Smtp Server Result lOk
			If !lOk
				Get Mail Error cErrorMsg
				ConOut("2 - " + cErrorMsg)
			EndIf
			Return(.F.)
		EndIf
		If !Empty(cCC)
			Send Mail From cFrom To cTo CC cCC Subject cSubject Body cBody ATTACHMENT  cAnexo Result lOk
		Else
			Send Mail From cFrom To cTo Subject cSubject Body cBody ATTACHMENT  cAnexo Result lOk
		EndIf
		If !lOk
			Get Mail Error cErrorMsg
			ConOut("3 - " + cErrorMsg)
			Return(.F.)
		EndIf
	Else
		Get Mail Error cErrorMsg
		ConOut("4 - " + cErrorMsg)
		Return(.F.)
	EndIf  
	Disconnect Smtp Server
Return(.t.)



Static Function Limpar(cTxt)
Local cRet := ''
Local nX := 0  
If cTxt == Nil
	Return cTxt
ElseIf Empty(cTxt)
	Return cTxt
ElseIf ValType("cTxt") <> "C"
	Return cTxt
Endif


cTxt := StrTRAN(cTxt,CHR(13)," ")
cTxt := StrTRAN(cTxt,CHR(10)," ")
cTxt := Upper(strtran(cTxt,'Ã£','A'))
cTxt := Upper(strtran(cTxt,'Ã©','E'))

For nX := 1 To Len(cTxt)
	If SubStr(cTxt,nX,1) == '"'
		cRet += ''
	ElseIf SubStr(cTxt,nX,1) == '~'
		cRet += ''
	ElseIf SubStr(cTxt,nX,1) == '.'
		cRet += ''
	ElseIf SubStr(cTxt,nX,1) == '/'
		cRet += ''
	ElseIf SubStr(cTxt,nX,1) == '\'
		cRet += ''
	ElseIf SubStr(cTxt,nX,1) == '-'
		cRet += ''
	ElseIf SubStr(cTxt,nX,1) == '©'
		cRet += 'E'
	ElseIf SubStr(cTxt,nX,1) == 'Ã'
		cRet += 'A'
	ElseIf SubStr(cTxt,nX,1) == 'Á'
		cRet += 'A'
	ElseIf SubStr(cTxt,nX,1) == 'Â'
		cRet += 'A'
	ElseIf SubStr(cTxt,nX,1) == 'À'
		cRet += 'A'
	ElseIf SubStr(cTxt,nX,1) == 'Ç'
		cRet += 'C'
	ElseIf SubStr(cTxt,nX,1) == 'É'
		cRet += 'E'
	ElseIf SubStr(cTxt,nX,1) == 'Ê'
		cRet += 'E'
	ElseIf SubStr(cTxt,nX,1) == 'È'
		cRet += 'E'
	ElseIf SubStr(cTxt,nX,1) == 'Í'
		cRet += 'I'
	ElseIf SubStr(cTxt,nX,1) == 'Î'
		cRet += 'I'
	ElseIf SubStr(cTxt,nX,1) == 'Ì'
		cRet += 'I'
	ElseIf SubStr(cTxt,nX,1) == 'Ó'
		cRet += 'O'
	ElseIf SubStr(cTxt,nX,1) == 'Õ'
		cRet += 'O'
	ElseIf SubStr(cTxt,nX,1) == 'Ô'
		cRet += 'O'
	ElseIf SubStr(cTxt,nX,1) == 'Ò'
		cRet += 'O'
	ElseIf SubStr(cTxt,nX,1) == 'Ú'
		cRet += 'U'
	ElseIf SubStr(cTxt,nX,1) == 'Û'
		cRet += 'U'
	ElseIf SubStr(cTxt,nX,1) == 'Ù'
		cRet += 'U'
	ElseIf SubStr(cTxt,nX,1) == 'ã'
		cRet += 'A'
	ElseIf SubStr(cTxt,nX,1) == 'á'
		cRet += 'A'
	ElseIf SubStr(cTxt,nX,1) == 'â'
		cRet += 'A'
	ElseIf SubStr(cTxt,nX,1) == 'à'
		cRet += 'A'
	ElseIf SubStr(cTxt,nX,1) == 'ç'
		cRet += 'C'
	ElseIf SubStr(cTxt,nX,1) == 'é'
		cRet += 'E'
	ElseIf SubStr(cTxt,nX,1) == 'ê'
		cRet += 'E'
	ElseIf SubStr(cTxt,nX,1) == 'è'
		cRet += 'E'
	ElseIf SubStr(cTxt,nX,1) == 'í'
		cRet += 'I'
	ElseIf SubStr(cTxt,nX,1) == 'î'
		cRet += 'I'
	ElseIf SubStr(cTxt,nX,1) == 'ì'
		cRet += 'I'
	ElseIf SubStr(cTxt,nX,1) == 'ó'
		cRet += 'O'
	ElseIf SubStr(cTxt,nX,1) == 'õ'
		cRet += 'O'
	ElseIf SubStr(cTxt,nX,1) == 'ô'
		cRet += 'O'
	ElseIf SubStr(cTxt,nX,1) == 'ò'
		cRet += 'O'
	ElseIf SubStr(cTxt,nX,1) == 'ú'
		cRet += 'U'
	ElseIf SubStr(cTxt,nX,1) == 'û'
		cRet += 'U'
	ElseIf SubStr(cTxt,nX,1) == 'ù'
		cRet += 'U'
	ElseIf SubStr(cTxt,nX,1) == 'ª'
		cRet += 'a'
	ElseIf SubStr(cTxt,nX,1) == 'º'
		cRet += 'o'
	Else
		cRet += SubStr(cTxt,nX,1)
	EndIf
next nX

Return AllTrim(cRet)
