#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � RFAT010  � Autor � Eneovaldo Roveri Jr� Data �  14/12/09   ���
�������������������������������������������������������������������������͹��
���Descricao � Relatorio de Pedidos Cancelados                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function RFAT030()


	//���������������������������������������������������������������������Ŀ
	//� Declaracao de Variaveis                                             �
	//�����������������������������������������������������������������������

	Local cDesc1       := "Este programa tem como objetivo imprimir relatorio "
	Local cDesc2       := "de acordo com os parametros informados pelo usuario."
	Local cDesc3       := "Relat�rio de Pedidos Cancelados"
	Local cPict        := ""
	Local titulo       := "Relat�rio de Pedidos Cancelados"
	Local nLin         := 80

	Local Cabec1       := ""
	Local Cabec2       := ""
	Local imprime      := .T.
	Local aOrd := {}

	//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "RFAT030" , __cUserID )

	Private lEnd         := .F.
	Private lAbortPrint  := .F.
	Private CbTxt        := ""
	Private limite           := 132
	Private tamanho          := "M"
	Private nomeprog         := "RFAT030" // Coloque aqui o nome do programa para impressao no cabecalho
	Private nTipo            := 15
	Private aReturn          := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
	Private nLastKey        := 0
	Private cbtxt      := Space(10)
	Private cbcont     := 00
	Private CONTFL     := 01
	Private m_pag      := 01
	Private wnrel      := "RFAT030" // Coloque aqui o nome do arquivo usado para impressao em disco

	Private cString := "SC5"

	dbSelectArea("SC5")


	//���������������������������������������������������������������������Ŀ
	//� Monta a interface padrao com o usuario...                           �
	//�����������������������������������������������������������������������

	wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.F.)

	If nLastKey == 27
		Return
	Endif

	SetDefault(aReturn,cString)

	If nLastKey == 27
		Return
	Endif

	nTipo := If(aReturn[4]==1,15,18)

	//���������������������������������������������������������������������Ŀ
	//� Processamento. RPTSTATUS monta janela com a regua de processamento. �
	//�����������������������������������������������������������������������

	RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  29/11/09   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

	Local nOrdem
	Local cNomVen := space( len( SA3->A3_NOME ) )
	Local nTotPed := 0
	Local _cUsu   := ""
	Local _dCan   := ctod( " " )
	Local _dHor   := ""
	Local cMotivo := ""
	Local cArqQry, lQuery, cQuery


	cArqQry := "QUERYSC5"
	lQuery  := .T.
	cQuery  := "SELECT QUERYSC5.C5_NUM "
	cQuery  += "FROM "+RetSqlName("SC5")+" QUERYSC5 "
	cQuery  += "WHERE QUERYSC5.C5_FILIAL='"+xFilial("SC5")+"' AND "
	cQuery  += "QUERYSC5.C5_X_CANC = 'C' AND "
	cQuery  += "QUERYSC5.D_E_L_E_T_=' ' "

	cQuery := ChangeQuery(cQuery)

	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),cArqQry,.T.,.F.)

	dbSelectArea(cArqQry)


	//���������������������������������������������������������������������Ŀ
	//� SETREGUA -> Indica quantos registros serao processados para a regua �
	//�����������������������������������������������������������������������

	SetRegua(RecCount())

	dbGoTop()
	While !EOF()

		//���������������������������������������������������������������������Ŀ
		//� Verifica o cancelamento pelo usuario...                             �
		//�����������������������������������������������������������������������

		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif

		SC5->( dbSeek( xFilial( "SC5" ) + (cArqQry)->C5_NUM ) )

		//���������������������������������������������������������������������Ŀ
		//� Impressao do cabecalho do relatorio. . .                            �
		//�����������������������������������������������������������������������

		If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif

		cNomVen := NomeVend()
		cMotivo := ""
		_cUsu   := ""
		_dCan   := ctod( " " )
		_dHor   := ""
		nTotPed := 0
		U_TPdLicCT( @nTotPed,,,,,,,, .F. )
		SZ4->( dbSeek( xFilial("SZ4") + SC5->C5_NUM ) )
		Do While .not. SZ4->( eof() ) .and. SZ4->Z4_PEDIDO == SC5->C5_NUM
			if SZ4->Z4_EVENTO = "Cancelamento"
				_cUsu   := UsrRetName(SZ4->Z4_USUARIO)
				_dCan   := SZ4->Z4_DATA
				_dHor   := SZ4->Z4_HORA
				cMotivo := SZ4->Z4_MOTIVO
			endif
			SZ4->( dbSkip() )
		EndDo
		dbSelectArea( "SC5" )

		SA1->( dbSeek( xFilial( "SA1" ) + SC5->C5_CLIENTE ) )

		@ nLin  ,00 PSAY "N�mero do Pedido : " + SC5->C5_NUM
		@ nLin++,50 PSAY "Vendedor     : " + cNomVen 
		@ nLin  ,00 PSAY "Cancelado por    : " + _cUsu
		@ nLin  ,50 PSAY "Data         : " + dtoc( _dCan ) + " AS " + _dHor
		@ nLin++,90 PSAY "Total Pedido : " + Transf( nTotPed, "@E 999,999,999,999.99" )
		@ nLin++,00 PSAY "Cliente          : " + SC5->C5_CLIENTE + " " + SA1->A1_NREDUZ
		@ nLin++,00 PSAY "Motivo           : " + cMotivo

		nLin := nLin + 1 // Avanca a linha de impressao

		dbSelectArea(cArqQry)
		dbSkip()   // Avanca o ponteiro do registro no arquivo
	EndDo

	//���������������������������������������������������������������������Ŀ
	//� Finaliza a execucao do relatorio...                                 �
	//�����������������������������������������������������������������������

	SET DEVICE TO SCREEN

	//���������������������������������������������������������������������Ŀ
	//� Se impressao em disco, chama o gerenciador de impressao...          �
	//�����������������������������������������������������������������������

	If aReturn[5]==1
		dbCommitAll()
		SET PRINTER TO
		OurSpool(wnrel)
	Endif

	MS_FLUSH()

Return   


/*
Retorna o nome do vendedor.
*/
Static Function NomeVend()
	Local cNomVen := space( len( SA3->A3_NOME ) )

	if empty( cNomVen )
		if SA3->( dbSeek( xFilial( "SA3" ) + SC5->C5_VEND1 ) )
			cNomVen := SA3->A3_NOME
		endif
	endif

	if empty( cNomVen )
		if SA3->( dbSeek( xFilial( "SA3" ) + SC5->C5_VENDX2 ) ) 
			cNomVen := SA3->A3_NOME
		endif
	endif

	if empty( cNomVen )
		if SA3->( dbSeek( xFilial( "SA3" ) + SC5->C5_VEND3 ) )
			cNomVen := SA3->A3_NOME
		endif
	endif

	if empty( cNomVen )
		if SA3->( dbSeek( xFilial( "SA3" ) + SC5->C5_VEND4 ) )
			cNomVen := SA3->A3_NOME
		endif
	endif

	if empty( cNomVen )
		if SA3->( dbSeek( xFilial( "SA3" ) + SC5->C5_VEND5 ) )
			cNomVen := SA3->A3_NOME
		endif
	endif

return( cNomVen )