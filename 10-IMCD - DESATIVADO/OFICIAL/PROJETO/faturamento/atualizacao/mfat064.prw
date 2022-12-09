/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO5     ºAutor  ³Microsiga           º Data ³  11/25/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function F_DIASEM()

	Local cTitulo	:= "Dias da Semana"
	Local MvPar
	Local MvParDef	:= ""
	Local lTipoRet  := .T.
	Local l1Elem	:= .F.

	//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "F_DIASEM" , __cUserID )

	Private aSit:={}

	cAlias := Alias() 					 // Salva Alias Anterior

	IF lTipoRet
		MvPar:=&(Alltrim("M->A1_XSEMPAG"))		 // Carrega Nome da Variavel do Get em Questao
		mvRet:=Alltrim("M->A1_XSEMPAG")			 // Iguala Nome da Variavel ao Nome variavel de Retorno
	EndIF

	aSit := { "2 - Segunda", "3 - Terça", "4 - Quarta", "5 - Quinta", "6 - Sexta" }  

	MvParDef:="23456"

	IF lTipoRet
		IF f_Opcoes(@MvPar,cTitulo,aSit,MvParDef,12,49,l1Elem,,4)  // Chama funcao f_Opcoes
			&MvRet := mvpar                                                                          // Devolve Resultado
		EndIF
	EndIF

	dbSelectArea(cAlias) 								 // Retorna Alias

Return( IF( lTipoRet , .T. , MvParDef ) )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO5     ºAutor  ³Microsiga           º Data ³  11/25/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function F_DIAMES()

	Local cTitulo	:= "Dias do Mes"
	Local MvPar
	Local MvParDef	:= ""
	Local lTipoRet  := .T.
	Local l1Elem	:= .F.
	Local nLoop		:= 0

	Private aSit:={}

	cAlias := Alias() 					 // Salva Alias Anterior

	IF lTipoRet
		MvPar:=&(Alltrim("M->A1_XDIAPAG"))		 // Carrega Nome da Variavel do Get em Questao
		mvRet:=Alltrim("M->A1_XDIAPAG")			 // Iguala Nome da Variavel ao Nome variavel de Retorno
	EndIF

	aSit := {;
	"1 - 01",;
	"2 - 02",;
	"3 - 03",;
	"4 - 04",;
	"5 - 05",;
	"6 - 06",;
	"7 - 07",;
	"8 - 08",;
	"9 - 09",;
	"A - 10",;
	"B - 11",;
	"C - 12",;
	"D - 13",;
	"E - 14",;
	"F - 15",;
	"G - 16",;
	"H - 17",;
	"I - 18",;
	"J - 19",;
	"K - 20",;
	"L - 21",;
	"M - 22",;
	"N - 23",;
	"O - 24",;
	"P - 25",;
	"Q - 26",;
	"R - 27",;
	"S - 28",;
	"T - 29",;
	"U - 30",;
	"V - 31" }

	MvParDef:="123456789ABCDEFGHIJKLMNOPQRSTUV"

	IF lTipoRet
		IF f_Opcoes(@MvPar,cTitulo,aSit,MvParDef,12,49,l1Elem,,30)  // Chama funcao f_Opcoes
			&MvRet := mvpar                                                                          // Devolve Resultado
		EndIF
	EndIF

	dbSelectArea(cAlias) 								 // Retorna Alias

Return( IF( lTipoRet , .T. , MvParDef ) )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MFAT064   ºAutor  ³Microsiga           º Data ³  11/28/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MT461VCT

	Local aAreaAtu 	:= GetArea()
	Local aAreaSA1 	:= SA1->( GetArea() )

	Local aVenRet 	:= aClone( ParamIXB[1] )

	Local nLoop   	:= 0

	Local nDaySem 	:= 0
	Local nDayMes	:= 0

	Local nAux		:= 0
	Local cAux		:= ""

	Local aDePara	:= { 	{ 	"1", "01" }, ;
	{	"2", "02" }, ;
	{	"3", "03" }, ;
	{	"4", "04" }, ;
	{	"5", "05" }, ;
	{	"6", "06" }, ;
	{	"7", "07" }, ;
	{	"8", "08" }, ;
	{	"9", "09" }, ;
	{	"A", "10" }, ;
	{	"B", "11" }, ;
	{	"C", "12" }, ;
	{	"D", "13" }, ;
	{	"E", "14" }, ;
	{	"F", "15" }, ;
	{	"G", "16" }, ;
	{	"H", "17" }, ;
	{	"I", "18" }, ;
	{	"J", "19" }, ;
	{	"K", "20" }, ;
	{	"L", "21" }, ;
	{	"M", "22" }, ;
	{	"N", "23" }, ;
	{	"O", "24" }, ;
	{	"P", "25" }, ;
	{	"Q", "26" }, ;
	{	"R", "27" }, ;
	{	"S", "28" }, ;
	{	"T", "29" }, ;
	{	"U", "30" }, ;
	{	"V", "31" } }

	SA1->( dbSetOrder( 1 ) )
	SA1->( dbSeek( xFilial( "SA1" ) + SF2->F2_CLIENTE + SF2->F2_LOJA ) )

	If Len(aVenRet) == 1 .and. aVenRet[1,1] == ddatabase
		// Nao aplica restricao para pagamento a vista
	Else

		If SA1->A1_XRESPAG != "3"

			For nLoop := 1 To Len( aVenRet )

				If SA1->A1_XRESPAG == "1"

					nDaySem := Dow( aVenRet[nLoop][1] )

					While !( AllTrim( Str( nDaySem ) ) $ SA1->A1_XSEMPAG )
						aVenRet[nLoop][1] := aVenRet[nLoop][1] + 1
						nDaySem := Dow( aVenRet[nLoop][1] )
					End

				Endif

				If SA1->A1_XRESPAG == "2"

					nDayMes := Day( aVenRet[nLoop][1] )
					nAux 	:= aScan( aDePara, { |x| x[2] == StrZero( nDayMes, 2 ) } )
					cAux	:= aDePara[nAux][1]

					While !( cAux $ SA1->A1_XDIAPAG )
						aVenRet[nLoop][1] := aVenRet[nLoop][1] + 1

						nDayMes := Day( aVenRet[nLoop][1] )
						nAux 	:= aScan( aDePara, { |x| x[2] == StrZero( nDayMes, 2 ) } )
						cAux	:= aDePara[nAux][1]
					End

				Endif


			Next nLoop

		Endif
	Endif        
	RestArea( aAreaSA1 )
	RestArea( aAreaAtu )

Return aVenRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MFAT064   ºAutor  ³Microsiga           º Data ³  11/30/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function GMMA410CVND
Return .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MFAT064   ºAutor  ³Microsiga           º Data ³  11/30/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function GMMA410Dupl

	Local aAreaAtu 	:= GetArea()
	Local aAreaSA1 	:= SA1->( GetArea() )

	Local aVenRet 	:= aClone( ParamIXB[6] )

	Local nLoop   	:= 0

	Local nDaySem 	:= 0
	Local nDayMes	:= 0

	Local nAux		:= 0
	Local cAux		:= ""

	Local aDePara	:= { 	{ 	"1", "01" }, ;
	{	"2", "02" }, ;
	{	"3", "03" }, ;
	{	"4", "04" }, ;
	{	"5", "05" }, ;
	{	"6", "06" }, ;
	{	"7", "07" }, ;
	{	"8", "08" }, ;
	{	"9", "09" }, ;
	{	"A", "10" }, ;
	{	"B", "11" }, ;
	{	"C", "12" }, ;
	{	"D", "13" }, ;
	{	"E", "14" }, ;
	{	"F", "15" }, ;
	{	"G", "16" }, ;
	{	"H", "17" }, ;
	{	"I", "18" }, ;
	{	"J", "19" }, ;
	{	"K", "20" }, ;
	{	"L", "21" }, ;
	{	"M", "22" }, ;
	{	"N", "23" }, ;
	{	"O", "24" }, ;
	{	"P", "25" }, ;
	{	"Q", "26" }, ;
	{	"R", "27" }, ;
	{	"S", "28" }, ;
	{	"T", "29" }, ;
	{	"U", "30" }, ;
	{	"V", "31" } }

	Return aVenRet

	SA1->( dbSetOrder( 1 ) )
	If !SA1->( dbSeek( xFilial( "SA1" ) + M->C5_CLIENTE + SC5->C5_LOJACLI ) )
		RestArea( aAreaSA1 )
		RestArea( aAreaAtu )

		Return aVenRet
	Endif

	If SA1->A1_XRESPAG != "3"

		For nLoop := 1 To Len( aVenRet )

			If SA1->A1_XRESPAG == "1"

				nDaySem := Dow( aVenRet[nLoop][1] )

				While !( AllTrim( Str( nDaySem ) ) $ SA1->A1_XSEMPAG )
					aVenRet[nLoop][1] := aVenRet[nLoop][1] + 1
					nDaySem := Dow( aVenRet[nLoop][1] )
				End

			Endif

			If SA1->A1_XRESPAG == "2"

				nDayMes := Day( aVenRet[nLoop][1] )
				nAux 	:= aScan( aDePara, { |x| x[2] == StrZero( nDayMes, 2 ) } )
				cAux	:= aDePara[nAux][1]

				While !( cAux $ SA1->A1_XDIAPAG )
					aVenRet[nLoop][1] := aVenRet[nLoop][1] + 1

					nDayMes := Day( aVenRet[nLoop][1] )
					nAux 	:= aScan( aDePara, { |x| x[2] == StrZero( nDayMes, 2 ) } )
					cAux	:= aDePara[nAux][1]
				End

			Endif


		Next nLoop

	Endif

	RestArea( aAreaSA1 )
	RestArea( aAreaAtu )

Return aVenRet
