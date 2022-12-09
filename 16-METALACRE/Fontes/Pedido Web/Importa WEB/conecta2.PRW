#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CONECTA   º Autor ³ Luiz Alberto       º Data ³  Dez/2013   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Geração de arquivo TXT de envio para a Conecta, conforme o º±±
±±º          ³ lay-out informado.                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Modulo de Estoque                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function conecta2()

	Processa( { || ProcDados( ) }, 'Processando Pedidos' )
	
return

Static Function ProcDados( )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cQuery    := ""
Local xSRO      := ""  
Local nRegistro := 0
Local nJaReg    := 0
Local oJaReg
Local oSaldoSRO
Local nSaldoSRO := 0
Local oDlg
Local cEol 		:= CHR(13)+CHR(10)
Local cNomTrb	:= ""
Local cLine		:= ""
Local cTitulo  := "Gerar Arquivo Correios"
Local lMark    := .F.
Local oOk      := LoadBitmap( GetResources(), "CHECKED" )
Local oNo      := LoadBitmap( GetResources(), "UNCHECKED" )
Local oChk1
Local oChk2
Local dDataGrava := ctod("  /  /  ")
Local cAtuSRO  := ""
Local c1reg := ""
Local c2reg := ""
Local d1reg := ctod("  /  /  ")
Local d2reg := ctod("  /  /  ")
Local nOpcA	:= 0
Private lChk1 := .F.
Private lChk2 := .F.
Private oLbx
Private aVetor := {}
Private cValid := Dtos(ctod("  /  /  ")) 
Private oGeraTxt
PRIVATE cPerg   := Padr("CONECT",Len(SX1->X1_GRUPO))
Private cEscolha := ""

VldPerg01()

If !Pergunte(cPerg,.T.)                                   
	Return
Endif

dbSelectArea("SZQ")
dbSetOrder(2)
dbSeek(xfilial("SZQ")+alltrim(MV_PAR02))

do while !EOF()
	nSaldoSRO += SZQ->ZQ_SALDO
	dbskip()
	if SZQ->ZQ_TRANSP <> MV_PAR02
	   exit
	endif
enddo
dbSeek(xfilial("SZQ")+alltrim(MV_PAR02))

cQuery := "SELECT DISTINCT SF2.F2_CLIENT,SF2.F2_LOJENT,SD2.D2_EMISSAO,SD2.D2_PEDIDO,SD2.D2_DOC,SF2.F2_VALFAT,SF2.F2_PBRUTO,SA1.A1_NOME, SC5.C5_VOLUME1, SD2.D2_SERIE "
cQuery += "FROM "+RetSqlName("SD2")+" SD2 (NOLOCK) "
cQuery += "INNER JOIN "+RetSqlName("SC6")+" SC6 (NOLOCK) ON C6_FILIAL = D2_FILIAL AND C6_NUM = D2_PEDIDO AND C6_ITEM = D2_ITEMPV AND C6_PRODUTO = D2_COD AND C6_SERIE = D2_SERIE "
cQuery += "INNER JOIN "+RetSqlName("SC5")+" SC5 (NOLOCK) ON C5_FILIAL = C6_FILIAL AND C5_NUM = C6_NUM "
cQuery += "INNER JOIN "+RetSqlName("SA1")+" SA1 (NOLOCK) ON D2_CLIENTE = A1_COD AND D2_LOJA = A1_LOJA "
cQuery += "INNER JOIN "+RetSqlName("SF2")+" SF2 (NOLOCK) ON F2_DOC = D2_DOC AND F2_SERIE = D2_SERIE AND F2_CLIENTE = D2_CLIENTE AND F2_LOJA = D2_LOJA "
cQuery += "WHERE SA1.D_E_L_E_T_ = '' "
cQuery += "AND SC5.D_E_L_E_T_ = '' "
cQuery += "AND SF2.D_E_L_E_T_ = '' "
cQuery += "AND SD2.D_E_L_E_T_ = '' "
//cQuery += "AND SF2.F2_CHVNFE <> '' "
cQuery += "AND SD2.D2_EMISSAO = '"+DTOS(MV_PAR01)+"' "
if mv_par03 == 2
	cQuery += "AND D2_DOC NOT IN (SELECT DISTINCT ZP_NOTA FROM "+RetSqlName("SZP")+") "
endif      
cQuery += "AND C5_TRANSP = '"+alltrim(MV_PAR02)+"' "
cQuery += "AND SC5.C5_TIPO = 'N' "
//cQuery += "AND SC5.C5_GRPVEN = '000007' "
cQuery += "ORDER BY SD2.D2_DOC "

TCQUERY cQuery NEW ALIAS "CONEC"

Count To nRegistro
dbGoTop()

ProcRegua(nRegistro)

/*
dbSelectArea("CONEC")
do while !eof()
	nRegistro ++
	incproc('Reg. Encontrados: '+ strzero(nRegistro,8))
	dbskip()
enddo

dbgotop()
  */
//ProcRegua(nRegistro) // Numero de registros a processar

Do While conec->(!Eof())            
    
	if mv_par03 == 1
		dDataGrava := posicione("SZP",2,xfilial("SZP")+substr(conec->d2_doc,3,7),"ZP_GRAVADO")
		cAtuSRO := posicione("SZP",2,xfilial("SZP")+substr(conec->d2_doc,3,7),"ZP_REG")
		c1reg := posicione("SZP",2,xfilial("SZP")+substr(conec->d2_doc,3,7),"ZP_REG1")
		c2reg := posicione("SZP",2,xfilial("SZP")+substr(conec->d2_doc,3,7),"ZP_REG2")
		d1reg := posicione("SZP",2,xfilial("SZP")+substr(conec->d2_doc,3,7),"ZP_DTREG1")
		d2reg := posicione("SZP",2,xfilial("SZP")+substr(conec->d2_doc,3,7),"ZP_DTREG2")
	else
		dDataGrava := posicione("SZP",2,xfilial("SZP")+substr(conec->d2_doc,3,7),"ZP_GRAVADO")
		cAtuSRO := posicione("SZP",2,xfilial("SZP")+substr(conec->d2_doc,3,7),"ZP_REG")
//		dDataGrava := ctod("  /  /  ")
//		cAtuSRO := ""
		c1reg := ""
		c2reg := ""
		d1reg := ctod("  /  /  ")
		d2reg := ctod("  /  /  ")
	endif
	
	SA1->(dbSetOrder(1), dbSeek(xFilial("SA1")+CONEC->F2_CLIENT+CONEC->F2_LOJENT))

	cCep := SA1->A1_CEP

	// Alteração criada para a criação de mais de uma linha de vetor da nota fiscal
	// conforme a quantidade de volumes
	// Luiz Alberto - 27-12-2012

	For nI := 1 To Int(Iif(Empty(CONEC->C5_VOLUME1),1,CONEC->C5_VOLUME1))
		aAdd( aVetor,;
		{lMark,;
		conec->F2_CLIENT,;
		conec->F2_LOJENT,;
		conec->A1_NOME,;
		stod(conec->D2_EMISSAO),;
		conec->D2_DOC,;
		conec->F2_PBRUTO,;
		TransForm(cCep,"@R 99999-999"),;
		cAtuSRO,;
		dDataGrava,;
		c1reg,;
		d1reg,;
		c2reg,;
		d2reg,;
		CONEC->F2_VALFAT,;
		CONEC->D2_PEDIDO,;
		'Vol: ' + Str(nI,2) + '/' + Str(CONEC->C5_VOLUME1,2),;
		CONEC->D2_SERIE})
	Next
	
	incproc('Processando Reg: '+ strzero(nJaReg,8)+' / '+strzero(nRegistro,8))
	
	nJaReg ++
	
	dbSelectArea("CONEC")
	DbSkip()
End         

If Select("CONEC") > 0
	dbSelectArea("CONEC")
	DbCloseArea()
EndIf

//+-----------------------------------------------+
//| Monta a tela para usuario visualizar consulta |
//+-----------------------------------------------+
If Len( aVetor ) == 0
	Aviso( cTitulo, "Nao existem registros a consultar", {"Ok"} )
	Return
Endif

DEFINE MSDIALOG oDlg TITLE cTitulo FROM 0,0 TO 480,0800 PIXEL

@ 010,300 Say "Total de Notas: " SIZE 045,008 PIXEL OF oDlg
@ 010,350 Say oJaReg Var nJaReg picture "@E999,999,999" SIZE 045,008 PIXEL OF oDlg
@ 020,300 Say "Total de SRO: " SIZE 037,008 PIXEL OF oDlg
@ 020,350 Say oSaldoSRO Var nSaldoSRO picture "@E999,999,999" SIZE 045,008 PIXEL OF oDlg
if nSaldoSRO < nJaReg
	@ 020,100 Say "Quantidade de SRO's disponível menor que total de pedidos!" SIZE 100,008 PIXEL OF oDlg
endif

@ 020,010 Button "&Sair" 			SIZE 040, 014 	PIXEL OF oDlg Action {||oDlg:End()} OF oDlg
@ 020,050 BUTTON "&Arquivo"			SIZE 040, 014 	ACTION Processa({|| OkGeraTxt()}  ,"Gerando Arquivo Texto...") OF oDlg PIXEL
@ 020,090 BUTTON "&Etiquetas"		SIZE 040, 014 	ACTION Processa({|| U_ETIQSRO2() }  ,"Gerando Etiquetas...") OF oDlg PIXEL
//@ 020,130 BUTTON "&Relatorio"		SIZE 040, 014 	ACTION Processa({|| U_DESTR06A(MV_PAR01)}  ,"Gerando Relatorio Entrega...") OF oDlg PIXEL
//@ 020,170 BUTTON "&Rastrear"		SIZE 040, 014 	ACTION Processa({|| U_Rastreia(oLbx:nAt)}  ,"Rastreia Entregas...") OF oDlg PIXEL
@ 020,130 BUTTON "&M. Todos" 		SIZE 040, 014 	ACTION Processa({|| MTodos()}  ,"Marcando Linhas...") OF oDlg PIXEL
@ 020,170 BUTTON "&D. Todos" 		SIZE 040, 014 	ACTION Processa({|| DTodos()}  ,"Desmarcando Linhas...") OF oDlg PIXEL

@ 035,010 LISTBOX oLbx FIELDS HEADER ;
" ","Cliente","Loja","Nome","Emissao","Nota Fiscal",'Volume(s)', "Peso","CEP","Ultimo SRO","Data Envio","2.Envio","Data Envio","1.Envio","Data Envio";
SIZE 370,195 OF oDlg PIXEL ON dblClick(aVetor[oLbx:nAt,1] := RetInf())

oLbx:SetArray( aVetor )
oLbx:bLine := {|| {Iif(aVetor[oLbx:nAt,1],oOk,oNo),;
aVetor[oLbx:nAt,2],;
aVetor[oLbx:nAt,3],;
aVetor[oLbx:nAt,4],;
aVetor[oLbx:nAt,5],;
aVetor[oLbx:nAt,6],;
aVetor[oLbx:nAt,17],;
aVetor[oLbx:nAt,7],;
aVetor[oLbx:nAt,8],;
aVetor[oLbx:nAt,9],;
aVetor[oLbx:nAt,10],;
aVetor[oLbx:nAt,11],;
aVetor[oLbx:nAt,12],;
aVetor[oLbx:nAt,13],;
aVetor[oLbx:nAt,14]}}

//ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||nOpcA:=1,oDlg:End()},{||oDlg:End()})
ACTIVATE MSDIALOG oDlg Centered
Return .t.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ OKGERATXTº Autor ³ AP5 IDE            º Data ³  Dez/2013   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao chamada pelo botao OK na tela inicial de processamenº±±
±±º          ³ to. Executa a geracao do arquivo texto.                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function OkGeraTxt

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria o arquivo texto                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local dDataenvio := substr(dtoc(mv_par01),1,2)+substr(dtoc(mv_par01),4,2)+"20"+substr(dtoc(mv_par01),7,2)

Private cArqTxt := ""
Private nHdl

Private cEOL    := "CHR(13)+CHR(10)"

nJaReg := 0

ProcRegua(0)
For i:= 1 to len(aVetor)

     if aVetor[i,1] // campo que foi usado no MarkBrowse

		xSRO := pegaSRO()
	
		incproc('Processando Aguarde...')
	
		dbSelectArea("SZP")
		dbSetOrder(1)
		dbSeek(xfilial("SZP")+dtos(mv_par01)+substr(aVetor[i,6],3,7)+aVetor[i,17])
		if !found()
			reclock("SZP",.T.)
			zp_filial     := xfilial("SZP")
			zp_cliente    := aVetor[i,2]
			zp_loja       := aVetor[i,3]
			zp_nome       := aVetor[i,4]     
			zp_cep        := aVetor[i,8]+space(31)
			zp_reg        := xSRO
			zp_peso       := iif(aVetor[i,7] <= 30,strzero((aVetor[i,7]*1000),5),"30000")
			zp_cubico     := iif(aVetor[i,7] <= 30,aVetor[i,7]*1000,0)
			zp_declara    := PadR(TransForm(aVetor[i,15],"@E 9,999,999,999.99"),20)
			zp_adicion    := space(18)
			zp_anota      := space(90)
			zp_nota       := substr(aVetor[i,6],3,7)
			zp_control    := dtos(mv_par01)
			zp_emissao    := aVetor[i,5]
			zp_usuario    := Upper(Rtrim(CUSERNAME))
			zp_tipoenv    := alltrim(SZQ->ZQ_TIPOENV)
			zp_gravado    := ddatabase
			SZP->ZP_PEDIDO := aVetor[i,16]
			SZP->ZP_VOLUME := aVetor[i,17] // Campo Criado para tratamento de volumes
			SZP->ZP_SERIE := aVetor[i,18] 
			msunlock()
		else
			reclock("SZP",.F.)
			if empty(zp_reg1)
				zp_reg1 := zp_reg
				zp_dtreg1 := zp_gravado
				zp_gravado := ddatabase
			elseif !empty(zp_reg1)
				zp_reg2 := zp_reg1     
				zp_dtreg2 := zp_dtreg1
				zp_reg1 := zp_reg
				zp_dtreg1 := zp_gravado
			endif
			zp_reg        := xSRO
			zp_gravado    := ddatabase
			msunlock()
		endif
	
		dbSelectArea("SZQ")
		IF reclock("SZQ",.f.)
			zq_atual := xSRO
			zq_saldo := zq_saldo - 1
				
			if zq_regfim == zq_atual .or. zq_saldo == 0
				zq_datafim := ddatabase
			endif
			msunlock()     
			nJaReg ++
			aVetor[i,1] := .f.
		Endif	
	Endif
Next

If Empty(nJaReg)
	MsgStop("Atenção é Necessário Efetuar a Marcação das Notas para Processamento")
	Return .f.
Endif

IF MV_PAR02='2308'
	cArqTxt := "\total\"+dDataenvio+".TXT"
	Processa({|| RunTotal() },"Processando...")
Else
	cArqTxt := "METALACRE"+dDataenvio+Alltrim(SZQ->ZQ_TIPOENV)+".TXT"
	nHdl    := fCreate(cArqTxt)
	
	If Empty(cEOL)
	    cEOL := CHR(13)+CHR(10)
	Else
	    cEOL := Trim(cEOL)
	    cEOL := &cEOL
	Endif
	
	If nHdl == -1
	    MsgAlert("O arquivo de nome "+cArqTxt+" nao pode ser criado, verifique.","Atencao!")
	    Return
	Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa a regua de processamento                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                  
	Processa({|| RunCont() },"Processando...")
Endif	
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ RUNCONT  º Autor ³ AP5 IDE            º Data ³  Dez/2013   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela PROCESSA.  A funcao PROCESSA  º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunCont

Local nTamLin, cLin, cCpo

dbSelectArea("SZP")
dbSetOrder(1)
dbSeek(xfilial("SZP")+dtos(mv_par01))

if !found()    
	fClose(nHdl)
	return
endif


While SZP->(!EOF()) .And. SZP->ZP_EMISSAO == MV_PAR01 .AND. SZP->ZP_TIPOENV == SZQ->ZQ_TIPOENV


    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Incrementa a regua                                                  ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

    IncProc("Gerando Arquivo...")

    //ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
    //º Lay-Out do arquivo Texto gerado:                                º
    //ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹
    //ºCampo           ³ Inicio ³ Tamanho                               º
    //ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶
    //º ZP_NOME       ³ 001    ³ 50                                    º
    //º ZP_CEP        ³ 051    ³ 40                                    º
    //º ZP_REG        ³ 091    ³ 11                                    º    
    //º ZP_PESO       ³ 102    ³ 05                                    º
    //º ZP_CUBICO     ³ 107    ³ 05                                    º        
    //º ZP_DECLARA    ³ 112    ³ 20                                    º
    //º ZP_ADICION    ³ 132    ³ 18                                    º    
    //º ZP_ANOTA      ³ 150    ³ 90                                    º    
    //º ZP_NOTA       ³ 240    ³ 07                                    º
    //ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼

    nTamLin := 246
    cLin    := Space(nTamLin)+cEOL // Variavel para criacao da linha do registros para gravacao

    cCpo := PADR(ZP_NOME,50)
    cLin := Stuff(cLin,001,50,cCpo)
    cCpo := PADR(ZP_CEP,40)
    cLin := Stuff(cLin,051,40,cCpo)
    cCpo := PADR((ZP_REG + "BR"),11)
    cLin := Stuff(cLin,091,11,cCpo)
    cCpo := PADR(ZP_PESO,05)
    cLin := Stuff(cLin,102,05,cCpo)
    cCpo := PADR(strzero(ZP_CUBICO,5),05)
    cLin := Stuff(cLin,107,05,cCpo)
    cCpo := PADR(ZP_DECLARA,20)
    cLin := Stuff(cLin,112,20,cCpo)
    cCpo := PADR(ZP_ADICION,18)
    cLin := Stuff(cLin,132,18,cCpo)
    cCpo := PADR(ZP_ANOTA,90)
    cLin := Stuff(cLin,150,90,cCpo)
    cCpo := PADR(ZP_NOTA,07)
    cLin := Stuff(cLin,240,07,cCpo)                                

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Gravacao no arquivo texto. Testa por erros durante a gravacao da    ³
    //³ linha montada.                                                      ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

    If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
        If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
            Exit
        Endif
    Endif

    dbSkip()
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ O arquivo texto deve ser fechado, bem como o dialogo criado na fun- ³
//³ cao anterior.                                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

fClose(nHdl)
MsgInfo("Arquivo  " + cArqTxt + " Gerado com Sucesso!")
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ RUNTotal º Autor ³ AP5 IDE            º Data ³  Dez/2013   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela PROCESSA.  A funcao PROCESSA  º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunTotal
Local nTamLin, cLin, cCpo
Private cTexto := ""
Private cTxt   := ""

dbSelectArea("SZP")
dbSetOrder(1)
dbSeek(xfilial("SZP")+dtos(mv_par01))

/*if !found()    
	fClose(nHdl)
	return
endif
*/

While SZP->(!EOF()) .And. SZP->ZP_EMISSAO == MV_PAR01 
	IF ALLTRIM(SZP->ZP_TIPOENV) == ALLTRIM(SZQ->ZQ_TIPOENV)
		SA1->(dbSetOrder(1), dbSeek(xFilial("SA1")+SZP->ZP_CLIENTE+SZP->ZP_LOJA))
		SC5->(dbSetOrder(1), dbSeek(xFilial("SC5")+SZP->ZP_PEDIDO))
		SF2->(dbSetOrder(2), dbSeek(xFilial("SF2")+SZP->ZP_CLIENTE+SZP->ZP_LOJA+STRZERO(VAL(SZP->ZP_NOTA),9)+SZP->ZP_SERIE))
		dbSelectArea("SZP")
                           
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Incrementa a regua                                                  ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	    IncProc("Gerando Arquivo...")
	
		cServico  := '1'     
		cEntrega  := '0'    
		cIsento   := '0'  // tratar itens de pedido para ver se tem ao menos algum item que não é isento (0) ou se todos são isentos (1)
		cEndNum   := SubStr(Alltrim(SA1->A1_END),At(",",SA1->A1_END)+2)
		cEndLimpo := SubStr(Alltrim(SA1->A1_END),1,Len(Alltrim(SA1->A1_END))-(Len(cEndNum)+1))
		cEndLimpo := STRTRAN(cEndLimpo,',','')
		cEndNum   := IIF(Alltrim(cEndNum) == "0", "1", cEndNum)
		cCFOP     := '5102'  // tratar -> CFOP predominante

		cTxt += 'TOTAL20;'
		cTxt += PADR(SM0->M0_CGC,14)+';'
//		cTxt += PADR(SZP->ZP_REMESSA,20)+';'	
		cTxt += space(20)+';'
		cTxt += cServico+';'
		cTxt += cEntrega+';'
		cTxt += STR(SC5->C5_PESOL,5,2)+';'
		cTxt += STR(SC5->C5_VOLUME1,2)+';'
		cTxt += IIF(SC5->C5_TPFRETE = 'C', 'CIF', 'FOB')+';'
		cTxt += PADR(SZP->ZP_PEDIDO,20)+';'
		cTxt += SPACE(20)+';'
		cTxt += 'PAPELARIA E INFORMATICA  '+';'
		cTxt += 'CX '+';'
		cTxt += cIsento+';'
		cTxt += SPACE(255)+';'
		cTxt += PADR(SUBSTR(ALLTRIM(SA1->A1_NOME),1,40),40)+';'
		cTxt += PADR(SA1->A1_CGC,14)+';'
		cTxt += PADR(SA1->A1_INSCR,14)+';'
		cTxt += PADR(cEndLimpo,80)+';'
		cTxt += PADR(cEndNum,10)+';'
		cTxt += PADR(ALLTRIM(SA1->A1_COMPLEM),60)+';'
		cTxt += PADR(ALLTRIM(SA1->A1_REFEND),255)+';'
		cTxt += PADR(ALLTRIM(SA1->A1_BAIRRO),40)+';'
		cTxt += PADR(ALLTRIM(SA1->A1_MUN),40)+';'
		cTxt += ALLTRIM(SA1->A1_EST)+';'
		cTxt += PADR('BRASIL',20)+';'
		cTxt += SA1->A1_CEP+';'                   
		cTxt += PADR(ALLTRIM(SA1->A1_EMAIL),60)+';'
		cTxt += SA1->A1_DDD+';'
		cTxt += PADR(SUBSTR(ALLTRIM(SA1->A1_TEL),1,12),12)+';'
		cTxt += PADR(SUBSTR(ALLTRIM(SA1->A1_TELCEL),1,12),12)+';'
		cTxt += SPACE(12)+';'
		cTxt += '0'+';'
		cTxt += '  '+';'
		cTxt += '00'+';'
		cTxt += '00000'+';'
		cTxt += SPACE(10)+';'
		cTxt += ' '+';'
		cTxt += ' '+';'
		cTxt += SF2->F2_DOC+';'
		cTxt += SF2->F2_SERIE+';'
		cTxt += SUBSTR(DTOC(SF2->F2_EMISSAO),1,6)+STR(YEAR(SF2->F2_EMISSAO),4)+';'
		cTxt += ALLTRIM(STR(SF2->F2_VALBRUT,14,2))+';'
		cTxt += ALLTRIM(STR(SF2->F2_VALMERC,14,2))+';'
		cTxt += cCFOP+';'
		cTxt += SF2->F2_CHVNFE+';'
		cTxt += chr(13)+chr(10)
	ENDIF
    dbSkip()
Enddo	
cTexto += cTxt	                      ·
memowrite(cArqTXT, cTexto)

MsgInfo("Arquivo  " + cArqTxt + " Gerado com Sucesso!")
Return
                                                                                                 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VLDPERGºAutor  ³Luiz Alberto      					  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³PERGUNTAS DE USO DA ROTINA                                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function VldPerg01()

SX1->(DbSetOrder(1))
If !SX1->(DbSeek(cPerg+"01"))
	PutSX1(cPerg, "01", "Data do Envio ?","","","mv_ch1","D",08,0,0,"G","","","","","mv_par01","","","","","","","","","","","","","","","",,,,)
Endif
If !SX1->(DbSeek(cPerg+"02"))
	PutSX1(cPerg, "02", "Tipo de Envio ?","","","mv_ch2","C",06,0,0,"G","","SZQ","","","mv_par02","","","","","","","","","","","","","","","",,,,)
Endif
If !SX1->(DbSeek(cPerg+"03"))
	PutSX1(cPerg, "03", "Com Reenvio ?","","","mv_ch3","C",06,0,0,"C","","","","","mv_par03","Sim","","","","Nao","","","","","","","","","","",,,,)
Endif
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PEGASROºAutor  ³ Luiz Alberto     					  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³GERA O NUMERO DO SRO ASSOCIADO AO DIGITO VERIFICADOR        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function PegaSro()

Local cSRO := ""              
Local nSRO := 0
Local cEscolha := ""
Private nDigit := 0

dbSelectArea("SZQ")
dbSetOrder(2)
If dbSeek(xfilial("SZQ")+alltrim(MV_PAR02))

	nSRO := val(substr(zq_atual,3,8))+1
	       
	CalcSRO(nSRO)
	cSRO := substr(zq_atual,1,2)+alltrim(str(nSRO))+alltrim(str(nDigit))
Endif
return (cSRO)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CALCSROºAutor  ³ Luiz Alberto     					  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³CALCULA O DIGITO VERIFICADOR DO SRO                         º±±
±±º          ³                                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function CalcSRO(nSRO)
Local n1 := 0
Local n2 := 0
Local n3 := 0
Local n4 := 0
Local n5 := 0
Local n6 := 0
Local n7 := 0
Local n8 := 0
Local nSoma := 0
Local nDivide := 0
Local nResto := 0

n1 := val(substr(alltrim(str(nSRO)),1,1)) * 8
n2 := val(substr(alltrim(str(nSRO)),2,1)) * 6
n3 := val(substr(alltrim(str(nSRO)),3,1)) * 4
n4 := val(substr(alltrim(str(nSRO)),4,1)) * 2
n5 := val(substr(alltrim(str(nSRO)),5,1)) * 3
n6 := val(substr(alltrim(str(nSRO)),6,1)) * 5
n7 := val(substr(alltrim(str(nSRO)),7,1)) * 9
n8 := val(substr(alltrim(str(nSRO)),8,1)) * 7
nSoma := n1+n2+n3+n4+n5+n6+n7+n8
nDivide := int(nSoma / 11)
nResto := round(((nSoma / 11) - nDivide),1) * 10

if nResto > 0
	nDigit := 11 - nResto
endif

return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FTP    ºAutor  ³ Luiz Alberto      					  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Envia dados local para FTP                                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function Ftp2()
Local cServer := 'ftp://186.202.3.45'
Local nPorta  := 21
Local cUser	  := 'metalacre'
Local cPass	  := 'metalacre'  
Local cFileLocal := '\system\'
Local cFileFTP := cArqTXT  
Local cDownFTP := ''  
Local cDelFTP  := ''  
Local n:= 0
Local aRetDir := {}
 
lFireWall := .T.                     
cpyt2s(cArqTXT,cFileLocal)
              
If	FTPConnect( cServer, nPorta, cUser, cPass )
	Conout('FTP conectado!')   
	Conout('Diretorio FTP',FTPGetCurDir()) 
//	Conout('FTPDirChange',FTPDirChange('\tmp'))
//	Conout('Diretorio FTP',FTPGetCurDir()) 
/*	If FTPErase("sigafin.old")	
		Conout('Exclusão Ok! ' + "sigafin.old")
	Else
		Conout('Falha Exclusão!')						
	EndIf         
	If FTPRenameFile("sigafin.xnu", "sigafin.old")	
		Conout('Arquivo Renomeado! xnu para old')
	Else
		Conout('Falha REnomear!')						
	EndIf         */
	FTPSetPasv( .T. )                
	aDirFTP := FTPDIRECTORY( "", ) 	
	aDirLoc := DIRECTORY( "\system\",  ) 	
	
	For I:=1 to Len(aDirLoc)
		If FTPUpLoad( "\system\" + aDirLoc[I][1], aDirLoc[I][1] )
			Conout('UpLoad Ok! '+ aDirLoc[I][1])
		Else	                
			Conout('Falha UpLoad!'+aDirLoc[I][1])	
		EndIf        
	Next
	For I:= 1 to LEn(aDirFTP)
		If FTPDownLoad( '\system\' + aDirFTP[I][1], aDirFTP[I][1] )
			Conout('Download Ok! '+ aDirFTP[I][1])
		Else
			Conout('Falha DownLoad '+ aDirFTP[I][1])			                                    
		EndIF
	Next
	FTPDisconnect()
Else
	Conout('Falha Conexao!')
EndIf                         

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RETINF ºAutor  ³                       					  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function RetInf()

lRet := aVetor[oLbx:nAt,1]

IF !EMPTY(aVetor[oLbx:nAt,10]) .and. EMPTY(aVetor[oLbx:nAt,12]) .and.EMPTY(aVetor[oLbx:nAt,14]) .and. !lRet
	IF MSGYESNO("Registro gerado anteriormente." + CHR(13)+CHR(10)+;
			"Deseja gerar novamente?")
		lRet := !aVetor[oLbx:nAt,1]
	ENDIF                            
Elseif !EMPTY(aVetor[oLbx:nAt,10]) .and. !EMPTY(aVetor[oLbx:nAt,12]) .and.EMPTY(aVetor[oLbx:nAt,14]) .and. !lRet
	IF MSGYESNO("Registro ja gerado 2 vezes anteriormente !!!" + CHR(13)+CHR(10)+;
			"Deseja gerar novamente?")
		lRet := !aVetor[oLbx:nAt,1]
	ENDIF
ElseIf !EMPTY(aVetor[oLbx:nAt,10]) .and. !EMPTY(aVetor[oLbx:nAt,12]) .and.!EMPTY(aVetor[oLbx:nAt,14]) .and. !lRet
	MSGSTOP("Registro ja gerado 3 vezes anteriormente !!!","Inconsistencia")
	lRet := aVetor[oLbx:nAt,1]
Else
	lRet := !aVetor[oLbx:nAt,1]
Endif
Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ETIQSROºAutor  ³ Luiz Alberto     					  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ EMISSAO DE ETIQUETA COM DADOS DOS CORREIOS PARA POSTAGEM   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ETIQSRO2()            
// U_ETIQSRO()
Local nVolume := 0
Local nTotVol := 0
Local cPedido := ""
Local cLogo    		:= FisxLogo("1")
Private oArial30  	:=	TFont():New("Arial",,24,,.F.,,,,,.F.,.F.)
Private oArial15N	:=	TFont():New("Arial Narrow",,15,,.T.,,,,,.F.,.F.)
Private o17N	:=	TFont():New("Arial Narrow",,16,,.T.,,,,,.F.,.F.)//TFont():New("",,10,,.T.,,,,,.F.,.F.)
Private o19N	:=	TFont():New("Arial Narrow",,14,,.T.,,,,,.F.,.F.)//TFont():New("",,10,,.T.,,,,,.F.,.F.)
Private o18N	:=	TFont():New("",,12,,.T.,,,,,.F.,.F.)
Private o21N	:=	TFont():New("",,10,,.T.,,,,,.F.,.F.)
Private o10N	:=	TFont():New("",,7,,.T.,,,,,.F.,.F.)
Private o11N	:=	TFont():New("",,8,,.T.,,,,,.F.,.F.)
Private oTimes14N	:=	TFont():New("Times New Roman",,14,,.T.,,,,,.F.,.F.)
Private oTimes15N	:=	TFont():New("Times New Roman",,16,,.T.,,,,,.F.,.F.)
Private oTimes10N	:=	TFont():New("Times New Roman",,10,,.T.,,,,,.F.,.F.)
Private o29N	:=	TFont():New("",,18,,.T.,,,,,.F.,.F.)
Private o28N	:=	TFont():New("Times New Roman",,12,,.T.,,,,,.F.,.F.)
PRIVATE oFont6  := TFont():New( "Arial",,08,,.f.,,,,,.f. )
Private oPrinter  	:=	oPrn  := TMSPrinter():New()

//MSCBPRINTER("S4M","LPT1",,,.f.)
//MSCBCHKSTATUS(.F.)


oPrinter:Setup()
oPrinter:SetPortrait()

dbselectarea("SZP")
dbsetorder(1)
dbgotop()
dbSeek(xfilial("SZP")+dtos(mv_par01))

While SZP->(!Eof()) .And. SZP->zp_emissao == MV_PAR01
	If AllTrim(SZP->ZP_TIPOENV) <> AllTrim(SZQ->ZQ_TIPOENV)
		SZP->(dbSkip(1));Loop
	Endif

		
	cPedido := SZP->ZP_PEDIDO
	cTotVol := SZP->ZP_VOLUME //"VOLUMES: "+Str(posicione("SC5",1,xfilial("SC5")+cPedido,"C5_VOLUME1"),3)
	If !Empty(SZP->ZP_VOLUME)
		cTotVol := SZP->ZP_VOLUME
	Endif

	dbselectarea("SA1")
	dbsetorder(1)
	dbseek(xfilial("SA1")+szp->(zp_cliente+zp_loja))
	
	SC5->(dbSetOrder(1), dbSeek(xFilial("SC5")+SZP->ZP_PEDIDO))

    oPrinter:StartPage()

	
//	oPrn:sayBitmap(012,060,'sealbag.bmp',228,96)
	oPrn:SayBitmap(012,720,cLogo,250,250)			
//	oPrinter:Say(050,0020,"Metalacre",oTimes15N,,0)

	If AllTrim(SZP->ZP_TIPOENV) == "PAC"
		oPrn:sayBitmap(012,080,"SELO_PAC.BMP",250,250)
	ElseIf AllTrim(SZP->ZP_TIPOENV) == "SEDEX"
		oPrn:sayBitmap(012,080,"SELO_SEDEX.BMP",250,250)
	ElseIf AllTrim(SZP->ZP_TIPOENV) == "ESEDEX"
		oPrn:sayBitmap(012,080,"SELO_ESEDEX.BMP",250,250)
	Endif
		
//	oPrinter:Say(0100,0020,"CONTRATO N.o: 9912342071 - "+SZP->ZP_TIPOENV,o17N,,0)
//	oPrinter:Say(0150,0020,"AGF Praca Oito de Dezembro",o17N,,0)

	cEnd	:= Iif(!Empty(SA1->A1_ENDENT),ALLTRIM(SA1->A1_ENDENT), ALLTRIM(SA1->A1_END))+' '+ALLTRIM(SA1->A1_COMPLEM) 
	cEnd	+= ' '+AllTrim(Iif(!Empty(SA1->A1_ENDENT),SA1->A1_BAIRROE, SA1->A1_BAIRRO))
	cEnd	+= ' - '+AllTrim(Iif(!Empty(SA1->A1_ENDENT),SA1->A1_MUNE, SA1->A1_MUN))
	cEnd	+= ' - '+AllTrim(Iif(!Empty(SA1->A1_ENDENT),SA1->A1_ESTE, SA1->A1_EST))
	cEnd	+= ' CEP:'+TransForm(Iif(!Empty(SA1->A1_ENDENT),SA1->A1_CEPE, SA1->A1_CEP),"@R 99999-999")
	cCep	:= Iif(!Empty(SA1->A1_ENDENT),SA1->A1_CEPE, SA1->A1_CEP)

	oPrinter:Say(0280,0079,"NF: "+SZP->ZP_NOTA,oTimes14N,,0)
	oPrinter:Say(0280,0600,"PED WEB: "+SC5->C5_PEDWEB,oTimes14N,,0)
	oPrinter:Say(0350,0330,(SZP->ZP_REG+"BR"),oTimes15N,,0)

	MSBAR("CODE128",3.9,1.5,(SZP->ZP_REG+"BR"),oPrinter,.F.,NIL,.T.,0.0300,2,.F.,oFont6,"CODE128",.F.)

    lOutro  := .f.
    If !Empty(SA1->A1_ENDENT)
    	If AllTrim(SA1->A1_ENDENT) <> AllTrim(SA1->A1_END)
    		lOutro := .t.
    	Endif
    Endif
    
    If At("A/C:",SC5->C5_MENNOTA) > 0 .And. lOutro
		cNome := SubStr(SC5->C5_MENNOTA,At("A/C:",SC5->C5_MENNOTA))
	Else
		cNome    := SZP->ZP_NOME
	Endif

	oPrinter:Say(0700,0079,"Destinatário:",oTimes14N,,0)

	nLii     := 750
	oPrn:Say(nLii, 0079, Capital(alltrim(cNome)) ,o17N,100 )
	nLii += 50

	_nLinhas:=mlcount(cEnd,40)
	FOR _nnX := 1 TO _nLinhas
		oPrn:Say(nLii, 0079, Capital(memoline(cEnd,40,_nnX)) ,o17N,100 )
		nLii+=50
	Next _nnX
		
//	oPrinter:Say(nLii,0079,Capital(AllTrim(cBairro)),o17N,,0)
//	nLii += 50
//	oPrinter:Say(nLii,0079,'CEP: '+TransForm(cCep,"@R 99999-999")+' - ' + Capital(AllTrim(cMun)) + ' - ' + AllTrim(cEst),o17N,,0) // + ' TEL.: ' + SA1->A1_TEL

//	MSBAR("CODE128",3.9,1.5,(SZP->ZP_REG+"BR"),oPrinter,.F.,NIL,.T.,0.0300,2,.F.,oFont6,"CODE128",.F.)
	MSBAR("CODE128",8.8,2,AllTrim(StrZero(Val(StrTran(cCep,'-','')),8)),oPrinter,.F.,NIL,.T.,0.0450,2,.F.,oFont6,"CODE128",.F.)


	oPrinter:Say(1330,0079,"Remetente:",oTimes14N,,0)
	oPrinter:Say(1380,0079,"SEALBAG",o17N,,0)
	oPrinter:Say(1430,0079,"Rua Ouro Velho, 42 - Cumbica ",o17N,,0)
	oPrinter:Say(1480,0079,"CEP 07224-100 - Guarulhos - São Paulo - SP",o17N,,0)

//	oPrinter:Say(1600,0079,"Pedido: "+cPedido,o17N,,0)
//	oPrinter:Say(1600,0800,cTotVol,o17N,,0)
//	oPrinter:Say(1400,0079,"Peso: "+TransForm(Val(SZP->ZP_PESO)/1000,"@E 9,999.9999"),o17N,,0)
//	oPrinter:Say(1100,0400,"VALOR R$ " + SZP->ZP_DECLARA,o17N,,0)


//	oPrinter:Say(1500,0200,'Pedido Interno: ' + SZP->ZP_PEDIDO,o17N,,0)

//	MSBAR("CODE128",14,.8,SZP->ZP_PEDIDO,oPrinter,.F.,NIL,.T.,0.0250,1.7,.F.,oFont6,"CODE128",.F.)

	oPrinter:EndPage()

   	SZP->(dbSkip(1))
enddo 
oPrinter:Preview()
//MSCBCLOSEPRINTER()
return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ MTodos Autor ³ Luiz Alberto        ³ Data ³ 13/12/11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Marca todas as Linhas do List Box ³±±
±±³          |                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MTodos()
For nI := 1 To Len(aVetor)
	aVetor[nI,1]:=.t.
Next
oLbx:Refresh()
Return .t.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ DTodos Autor ³ Luiz Alberto        ³ Data ³ 13/12/11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Desmarca todas as Linhas do Listbox
±±³          |                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function DTodos()
For nI := 1 To Len(aVetor)
	aVetor[nI,1]:=.F.
Next
oLbx:Refresh()
Return .t.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ Rastreia Autor ³ Luiz Alberto        ³ Data ³ 13/12/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Rastreia Entregas Correio
±±³          |                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function Rastreia(nPos)
Local aECF      := {'','SRO','Dt.Envio','Cliente','Agencia Correios','Dt.Registro','Hora Registro','Status'}
Local aCorreios  := {}
Local cQueryCad := ''
Local oECF
Local oDlgECF

Private    oSinal1   := LoadBitmap(GetResources(),"BR_MARROM")
Private    oSinal2   := LoadBitmap(GetResources(),"BR_VERMELHO")
Private    oSinal3   := LoadBitmap(GetResources(),"BR_AMARELO")
Private    oSinal4   := LoadBitmap(GetResources(),"BR_AZUL")
Private    oSinal5   := LoadBitmap(GetResources(),"BR_ROSA")
Private    oSinal6   := LoadBitmap(GetResources(),"BR_CINZA")
Private    oSinal7   := LoadBitmap(GetResources(),"BR_BRANCO")
Private    oSinal8   := LoadBitmap(GetResources(),"BR_LARANJA")
Private    oSinal9   := LoadBitmap(GetResources(),"BR_VERDE")
Private    oOk		 := LoadBitmap(GetResources(),"LBTIK")
Private    oNo  	 := LoadBitmap(GetResources(),"LBNO")

  	DEFINE MSDIALOG oDlgECF TITLE "Rastreamento Correios" FROM 000, 000  TO 300, 790 COLORS 0, 16777215 PIXEL

	@ 010,003  LISTBOX oEcf FIELDS HEADER "" SIZE 390,100  OF oDlgECF PIXEL
	oEcf:aColumns  := aECF
	oEcf:aHeaders  := oEcf:aColumns
	
	oEcf:SetArray(aCorreios)
	
/*	AAdd(oRot:ACOLSIZES,TamSX3("Z3_TIPO")[1])
	AAdd(oRot:ACOLSIZES,TamSX3("Z4_DTROTE")[1])
	AAdd(oRot:ACOLSIZES,TamSX3("Z4_MOTORIS")[1])
	AAdd(oRot:ACOLSIZES,TamSX3("Z4_PLACA")[1])
	AAdd(oRot:ACOLSIZES,TamSX3("DA6_REF")[1])
	AAdd(oRot:ACOLSIZES,TamSX3("Z3_MOTIVO")[1])
	AAdd(oRot:ACOLSIZES,5)
	AAdd(oRot:ACOLSIZES,TamSX3("ZT_DATAINI")[1])
	AAdd(oRot:ACOLSIZES,TamSX3("ZT_DATAFIM")[1])
	AAdd(oRot:ACOLSIZES,TamSX3("ZT_OBSERV")[1])
	AAdd(oRot:ACOLSIZES,10)
  */
	oEcf:bLine:= {|| {Iif('entrega'$AllTrim(aCorreios[oEcf:nAt,7]),oSinal9,oSinal6),;
	aCorreios[oEcf:nAt,1],;
	aCorreios[oEcf:nAt,2],;
	aCorreios[oEcf:nAt,3],;
	aCorreios[oEcf:nAt,4],;
	aCorreios[oEcf:nAt,5],;
	aCorreios[oEcf:nAt,6],;
	aCorreios[oEcf:nAt,7]}}

	@ 120, 300 Button "Sair" 							  Size 040, 014 PIXEL OF oDlgECF Action {||oDlgECF:End()} OF oDlgECF

  ACTIVATE MSDIALOG oDlgECF CENTERED
 
Return .t.

User Function EtiqTransp()
Private oArial30  	:=	TFont():New("Arial",,24,,.F.,,,,,.F.,.F.)
Private oArial15N	:=	TFont():New("Arial Narrow",,15,,.T.,,,,,.F.,.F.)
Private o17N	:=	TFont():New("Arial Narrow",,12,,.T.,,,,,.F.,.F.)//TFont():New("",,10,,.T.,,,,,.F.,.F.)
Private o19N	:=	TFont():New("Arial Narrow",,14,,.T.,,,,,.F.,.F.)//TFont():New("",,10,,.T.,,,,,.F.,.F.)
Private o18N	:=	TFont():New("",,12,,.T.,,,,,.F.,.F.)
Private o21N	:=	TFont():New("",,10,,.T.,,,,,.F.,.F.)
Private o10N	:=	TFont():New("",,7,,.T.,,,,,.F.,.F.)
Private o11N	:=	TFont():New("",,8,,.T.,,,,,.F.,.F.)
Private oTimes14N	:=	TFont():New("Times New Roman",,12,,.T.,,,,,.F.,.F.)
Private oTimes10N	:=	TFont():New("Times New Roman",,10,,.T.,,,,,.F.,.F.)
Private o29N	:=	TFont():New("",,18,,.T.,,,,,.F.,.F.)
Private o28N	:=	TFont():New("Times New Roman",,12,,.T.,,,,,.F.,.F.)
PRIVATE oFont6  := TFont():New( "Arial",,08,,.f.,,,,,.f. )
PRIVATE oFont8N := TFont():New( "Arial",,08,,.T.,,,,,.F.,.F.)
Private oPrinter  := TMSPrinter():New()

oPrinter:Setup()
oPrinter:SetPortrait()

dbselectarea("SZP")
dbsetorder(1)
dbgotop()
dbSeek(xfilial("SZP")+dtos(mv_par01))

While SZP->(!Eof()) .And. SZP->zp_emissao == MV_PAR01
	If AllTrim(SZP->ZP_TIPOENV) <> AllTrim(SZQ->ZQ_TIPOENV)
		SZP->(dbSkip(1));Loop
	Endif

	SC5->(dbSetOrder(1), dbSeek(xFilial("SC5")+SZP->ZP_PEDIDO))
	SA1->(dbSetOrder(1), dbseek(xfilial("SA1")+szp->(zp_cliente+zp_loja)))

    oPrinter:StartPage()

	cEnd	:= Iif(!Empty(SA1->A1_ENDENT),ALLTRIM(SA1->A1_ENDENT), ALLTRIM(SA1->A1_END))+' '+ALLTRIM(SA1->A1_COMPLEM) 
	cBairro := Iif(!Empty(SA1->A1_ENDENT),SA1->A1_BAIRROE, SA1->A1_BAIRRO)
	cMun	:= Iif(!Empty(SA1->A1_ENDENT),SA1->A1_MUNE, SA1->A1_MUN)
	cEst	:= Iif(!Empty(SA1->A1_ENDENT),SA1->A1_ESTE, SA1->A1_EST)
	cCep	:= Iif(!Empty(SA1->A1_ENDENT),SA1->A1_CEPE, SA1->A1_CEP)
	cNota	:= SZP->ZP_NOTA
	cPedido := SZP->ZP_PEDIDO
	cTotVol := SZP->ZP_VOLUME   
	cRegCli := Tabela("A2",SA1->A1_REGIAO,.F.)

	oPrinter:Box(0044,0046,0182,0800)
	oPrinter:Box(0182,0046,0293,0800)
	MSBAR("CODE3_9",0.7,0.5,cNota,oPrinter,.F.,NIL,.T.,0.0270,0.7,.F.,oFont6,"CODE3_9",.F.)
	oPrinter:Say(0204,0058,"Nota Fiscal:",o17N,,0)
	oPrinter:Say(0200,0400,cNota,o29N,,0)
	oPrinter:Box(0293,0046,0430,800)
	oPrinter:Say(0297,0063,"Cliente:",oTimes10N,,0)
		
    If At("A/C:",SC5->C5_MENNOTA) > 0	
		cNome := SubStr(SC5->C5_MENNOTA,At("A/C:",SC5->C5_MENNOTA))
	Else
		cNome := SA1->A1_NOME
	Endif
	_nLinhas:=mlcount(cNome,40)
	lI := 0297 
	For _nL := 1 To _nLinhas
		oPrinter:Say(lI+5,0185,MemoLine(cNome,40,_nL),oFont8N,,0)
		lI+=40
	Next _nL
//	if !empty(SA1->A1_RECNOM)
//		oPrinter:Say(lI,   0063,"Destinatario:",oTimes10N,,0)
//		oPrinter:Say(lI+5, 0265, ALLTRIM(SA1->A1_RECNOM) ,oFont8N,100 )
//		lI += 40
//	Endif	

	oPrinter:Box(0430,0046,0900,800)
	oPrinter:Say(0450,0063,"Entrega:",oTimes14N,,0)
		
	_nLinhas := MlCount(cEnd,30)
	lI := 0490 
	For _nL := 1 To _nLinhas
		oPrinter:Say(lI,0063,MemoLine(cEnd,30,_nL),o17N,,0)
		lI+=40
	Next _nL
/*	if !empty(SA1->A1_REFEND)
		oPrinter:Say(lI, 0063,"Ponto Referencia:",oTimes10N,,0)
		oPrinter:Say(lI+5, 0335, ALLTRIM(SA1->A1_REFEND) ,oFont8N,100 )
		lI += 40
	Endif	
  */		
	oPrinter:Say(0700,0063,"Bairro:",oTimes14N,,0)
	oPrinter:Say(0700,0210,cBairro,o17N,,0)
	oPrinter:Say(0750,0063,"Cidade:",oTimes14N,,0)
	oPrinter:Say(0750,0210,alltrim(cMun)+"/"+cEst,o17N,,0)
	oPrinter:Say(0804,0063,"CEP:",oTimes14N,,0)
	oPrinter:Say(0800,0210,cCep,o17N,,0)
	oPrinter:Box(0900,0046,1000,800)
	oPrinter:Say(0920,0058,"Pedido Venda:",o17N,,0)
	oPrinter:Say(0915,0400,cPedido,o29N,,0)
	oPrinter:Box(1000,0046,1100,800)
	oPrinter:Say(0080,0520,cTotVol,o28N,,0)
	oPrinter:EndPage()
		
	SZP->(dbSkip(1))
Enddo
oPrinter:Preview()
Return .t. 