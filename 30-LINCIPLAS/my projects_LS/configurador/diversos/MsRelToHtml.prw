#INCLUDE "rwmake.CH"
#INCLUDE "PROTHEUS.CH"

/*/
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Fun‡…o    ³MsRelToHtml      ³Autor³Marinaldo de Jesus³ Data ³06/07/2006³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descri‡…o ³Converte Arquivo de Relatorio do SIGA em HTML               ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Sintaxe   ³<Vide Parametros Formais>									³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Parametros³<Vide Parametros Formais>									³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Uso       ³Generico  	                                                ³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ/*/
User Function MsRelToHtml( cMsRelFile , cHtmNewFile )

Local aMsRelFile

Local nfhHtmlFile

Begin Sequence

	DEFAULT cMsRelFile 	:= ""
	DEFAULT cHtmNewFile	:= ( FileNoExt( cMsRelFile ) + ".html" )
	
	IF !File( cMsRelFile )
		Break
	EndIF

	aMsRelFile	:= FileToArr( cMsRelFile )

	nfhHtmlFile	:= fCreate( cHtmNewFile )
	IF ( nfhHtmlFile < 0 )
		Break
	EndIF

	fWrite( @nfhHtmlFile , "<!-- saved from url=(0022)http://internet.e-mail -->" + CRLF )
	fWrite( @nfhHtmlFile , "<html>" + CRLF )
	fWrite( @nfhHtmlFile , "	<head>" + CRLF )
	fWrite( @nfhHtmlFile , "		<script>" + CRLF )
	fWrite( @nfhHtmlFile , "			var CourierIni	= 10" + CRLF )
	fWrite( @nfhHtmlFile , "			var ArialIni 	= 10" + CRLF )
	fWrite( @nfhHtmlFile , "			var CourierAtu	= 10" + CRLF )
	fWrite( @nfhHtmlFile , "			var ArialAtu	= 10" + CRLF )
	fWrite( @nfhHtmlFile , "			function Zoom(ZoomIn)" + CRLF )
	fWrite( @nfhHtmlFile , "			{" + CRLF )
	fWrite( @nfhHtmlFile , "				var i" + CRLF )
	fWrite( @nfhHtmlFile , "				var id" + CRLF )
	fWrite( @nfhHtmlFile , "				var zoom = -5" + CRLF )
	fWrite( @nfhHtmlFile , "				var objArial" + CRLF )
	fWrite( @nfhHtmlFile , "				var objCourier" + CRLF )
	fWrite( @nfhHtmlFile , "				var obj" + CRLF )
	fWrite( @nfhHtmlFile , "				if (ZoomIn)" + CRLF )
	fWrite( @nfhHtmlFile , "				{" + CRLF )
	fWrite( @nfhHtmlFile , "					if (CourierAtu + 5 > CourierIni + 15)" + CRLF )
	fWrite( @nfhHtmlFile , "					{" + CRLF )
	fWrite( @nfhHtmlFile , "						zoom = 0;" + CRLF )
	fWrite( @nfhHtmlFile , "					}" + CRLF )
	fWrite( @nfhHtmlFile , "					else" + CRLF )
	fWrite( @nfhHtmlFile , "					{" + CRLF )
	fWrite( @nfhHtmlFile , "						zoom = 5;" + CRLF )
	fWrite( @nfhHtmlFile , "					}" + CRLF )
	fWrite( @nfhHtmlFile , "				}" + CRLF )
	fWrite( @nfhHtmlFile , "				CourierAtu = CourierAtu + zoom" + CRLF )
	fWrite( @nfhHtmlFile , "				ArialAtu = ArialAtu + zoom" + CRLF )
	fWrite( @nfhHtmlFile , "				if (CourierAtu < CourierIni)" + CRLF )
	fWrite( @nfhHtmlFile , "				{" + CRLF )
	fWrite( @nfhHtmlFile , "					CourierAtu = CourierIni;" + CRLF )
	fWrite( @nfhHtmlFile , "				}" + CRLF )
	fWrite( @nfhHtmlFile , "				if (ArialAtu < ArialIni)" + CRLF )
	fWrite( @nfhHtmlFile , "				{" + CRLF )
	fWrite( @nfhHtmlFile , "					ArialAtu = ArialIni;" + CRLF )
	fWrite( @nfhHtmlFile , "				}" + CRLF )
	fWrite( @nfhHtmlFile , "				objArial = document.getElementsByName('colArial')" + CRLF )
	fWrite( @nfhHtmlFile , "				objCourier = document.getElementsByName('colCourier')" + CRLF )
	fWrite( @nfhHtmlFile , "				if (objArial.length == 0 && objCourier.length == 0)" + CRLF )
	fWrite( @nfhHtmlFile , "				{" + CRLF )
	fWrite( @nfhHtmlFile , "					obj = document.getElementsByTagName('td')" + CRLF )
	fWrite( @nfhHtmlFile , "					for (i = 0; i < obj.length; i++)" + CRLF )
	fWrite( @nfhHtmlFile , "					{" + CRLF )
	fWrite( @nfhHtmlFile , "						id = obj[i].id;" + CRLF )
	fWrite( @nfhHtmlFile , "						if (id == 'colArial')" + CRLF )
	fWrite( @nfhHtmlFile , "						{" + CRLF )
	fWrite( @nfhHtmlFile , "							obj[i].style.fontSize = ArialAtu+'px';" + CRLF )
	fWrite( @nfhHtmlFile , "						}" + CRLF )
	fWrite( @nfhHtmlFile , "						else if (id == 'colCourier')" + CRLF )
	fWrite( @nfhHtmlFile , "						{" + CRLF )
	fWrite( @nfhHtmlFile , "							obj[i].style.fontSize = CourierAtu+'px';" + CRLF )
	fWrite( @nfhHtmlFile , "						}" + CRLF )
	fWrite( @nfhHtmlFile , "					}" + CRLF )
	fWrite( @nfhHtmlFile , "				}" + CRLF )
	fWrite( @nfhHtmlFile , "				else" + CRLF )
	fWrite( @nfhHtmlFile , "				{" + CRLF )
	fWrite( @nfhHtmlFile , "					for (i = 0; i < objArial.length; i++)" + CRLF )
	fWrite( @nfhHtmlFile , "					{" + CRLF )
	fWrite( @nfhHtmlFile , "						objArial[i].style.fontSize = ArialAtu+'px';" + CRLF )
	fWrite( @nfhHtmlFile , "					}" + CRLF )
	fWrite( @nfhHtmlFile , "					for (i = 0; i < objCourier.length; i++)" + CRLF )
	fWrite( @nfhHtmlFile , "					{" + CRLF )
	fWrite( @nfhHtmlFile , "						objCourier[i].style.fontSize = CourierAtu+'px';" + CRLF )
	fWrite( @nfhHtmlFile , "					}" + CRLF )
	fWrite( @nfhHtmlFile , "				}" + CRLF )
	fWrite( @nfhHtmlFile , "			}" + CRLF )
	fWrite( @nfhHtmlFile , "		</script>" + CRLF )
	fWrite( @nfhHtmlFile , "		<style type='text/css' media='print'>" + CRLF )
	fWrite( @nfhHtmlFile , "			<!--" + CRLF )
	fWrite( @nfhHtmlFile , "					.pagebreak	{" + CRLF )
	fWrite( @nfhHtmlFile , "									page-break-after:always;" + CRLF )
	fWrite( @nfhHtmlFile , "								}" + CRLF )
	fWrite( @nfhHtmlFile , "					.noprint	{" + CRLF )
	fWrite( @nfhHtmlFile , "									display:none;" + CRLF )
	fWrite( @nfhHtmlFile , "								}" + CRLF )
	fWrite( @nfhHtmlFile , "			-->" + CRLF )
	fWrite( @nfhHtmlFile , "		</style>" + CRLF )
	fWrite( @nfhHtmlFile , "		<style type='text/css'>" + CRLF )
	fWrite( @nfhHtmlFile , "			<!--" + CRLF )
	fWrite( @nfhHtmlFile , "				a	{" + CRLF )
	fWrite( @nfhHtmlFile , "						FONT-SIZE: 11px; FONT-FAMILY: Arial; COLOR: black; TEXT-DECORATION: none; }" + CRLF )
	fWrite( @nfhHtmlFile , "					}" + CRLF )
	fWrite( @nfhHtmlFile , "			-->" + CRLF )
	fWrite( @nfhHtmlFile , "		</style>" + CRLF )
	fWrite( @nfhHtmlFile , "		<title>" + CRLF )
	fWrite( @nfhHtmlFile , 			"" + CRLF )
	fWrite( @nfhHtmlFile , "		</title>" + CRLF )
	fWrite( @nfhHtmlFile , "	</head>" + CRLF )
	fWrite( @nfhHtmlFile , "	<body>" + CRLF )
	fWrite( @nfhHtmlFile , "		<table border='0' cellspacing='0' cellpadding='0' bgcolor='#FFFFFF' width='900'>" + CRLF )
	DetToHtml( @aMsRelFile , @nfhHtmlFile )
	fWrite( @nfhHtmlFile , "		</table>" + CRLF )
	fWrite( @nfhHtmlFile , "	</body>" + CRLF )
	fWrite( @nfhHtmlFile , "</html>" + CRLF )

	fClose( nfhHtmlFile )

End Sequence

Return( cHtmNewFile )

/*/
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Fun‡…o    ³DetToHtml        ³Autor³Marinaldo de Jesus³ Data ³06/07/2006³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descri‡…o ³Converte Arquivo de Relatorio do SIGA em HTML               ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Sintaxe   ³<Vide Parametros Formais>									³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Parametros³<Vide Parametros Formais>									³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Uso       ³MsRelToHtml      											³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ/*/
Static Function DetToHtml( aMsRelFile , nfhHtmlFile )
                           

Local cLine
Local cByte
Local cNewLine

Local lChkByte

Local nAsc
Local nPage
Local nLoop
Local nLoops
Local nByte
Local nBytes

IF ( Type( cEmpAnt ) == "U" )
	Private cEmpAnt := "99"
EndIF

IF ( Type( cFilAnt ) == "U" )
	Private cFilAnt := "01"
EndIF

nLoops := Len( aMsRelFile )
For nLoop := 1 To nLoops
	
	cLine	:= aMsRelFile[ nLoop ]
	nAsc	:= Asc( cLine )
	
	IF ( nAsc == 13 )
		Loop
	EndIF

	IF (;
			( nAsc == 8 );
			.or.;
			( nAsc == 12 );
		)	
	
		IF ( nLoop == 1 )
			nPage := 1
		Else
			++nPage
			IF ( nAsc == 12 )
				fWrite( @nfhHtmlFile , "		<div class='pagebreak'></div>" + CRLF )
			EndIF
		EndIF
	
		fWrite( @nfhHtmlFile , "		<div class='noprint'>" + CRLF )
		fWrite( @nfhHtmlFile , "			<a href='javascript:Zoom(true)'>Zoom In</a>" + CRLF )
		fWrite( @nfhHtmlFile , "			&nbsp;&nbsp;" + CRLF )
		fWrite( @nfhHtmlFile , "			<a href='javascript:Zoom(false)'>Zoom Out</a>" + CRLF )
		fWrite( @nfhHtmlFile , "			&nbsp;&nbsp;" + CRLF )
		fWrite( @nfhHtmlFile , "			<a name='page" +StrZero( nPage , 4 )+"'></a>" + CRLF )
		fWrite( @nfhHtmlFile , "		</div>" + CRLF )
	
	ElseIF ( nAsc == 42 )
		
		IF ( "LGRL.BMP" $ cLine )
			cLine := StrTran( cLine , "LGRL.BMP" , Space( Len( "LGRL.BMP" ) ) )
		ElseIF ( "LGRL"+cEmpAnt+".BMP" $ cLine )
			cLine := StrTran( cLine , "LGRL"+cEmpAnt+".BMP" , Space( Len( "LGRL"+cEmpAnt+".BMP" ) ) )
		ElseIF ( "LGRL"+cEmpAnt+cFilAnt+".BMP" $ cLine )
			cLine := StrTran( cLine , "LGRL"+cEmpAnt+cFilAnt+".BMP" , Space( Len( "LGRL"+cEmpAnt+cFilAnt+".BMP" ) ) )
		EndIF
		
		While (;
					!Empty(cLine);
					.and.;
					!ChkAsc( Substr( cLine , 1 , 1 ) , .F. );
				)
			cLine	:= Substr( cLine , 2 )
		End While
		
		nByte		:= 0
		nBytes		:= Len( cLine )
		cNewLine	:= ""
		While ( ( ++nByte ) <= nBytes )
			cByte		:= Substr( cLine , nByte , 1 )
			lChkByte	:= ( Empty( cByte ) .or. ChkAsc( cByte , .F. ) )
			IF ( lChkByte )
				cNewLine += cByte
			Else
				cNewLine += " "
			EndIF
		End While
		
		cLine	:= cNewLine
		
		IF Empty( cLine )

			fWrite( @nfhHtmlFile , "<br>" + CRLF )

		Else

			cLine	:= StrTran( cLine , " " , "&nbsp;" )
			fWrite( @nfhHtmlFile , "						<table border='0' cellspacing='0' cellpadding='0' width='100%' bgcolor='#FFFFFF' style='FONT-SIZE: 9px; FONT-FAMILY: Arial'>" + CRLF )
			fWrite( @nfhHtmlFile , "							<tr>" + CRLF )
			fWrite( @nfhHtmlFile , "								<td id='colArial' colspan='3'><hr color='#000000' noshade size='2'></td>" + CRLF )
			fWrite( @nfhHtmlFile , "							</tr>" + CRLF )
			fWrite( @nfhHtmlFile , "							<tr>" + CRLF )
			fWrite( @nfhHtmlFile , "								<td id='colArial'>" + cLine + CRLF )
			fWrite( @nfhHtmlFile , "								</td>" + CRLF )
			fWrite( @nfhHtmlFile , "							</tr>" + CRLF )
			fWrite( @nfhHtmlFile , "						</table>" + CRLF )

		EndIF

	ElseIF ( nAsc == 27 )

		cLine := Substr( cLine , 4 )
        
        IF ( SubStr( cLine , 1 , 1 ) == "*" )
    	
    		fWrite( @nfhHtmlFile , "						<table border='0' cellspacing='0' cellpadding='0' width='100%' bgcolor='#FFFFFF' style='FONT-SIZE: 9px; FONT-FAMILY: Arial'>" + CRLF )
    		fWrite( @nfhHtmlFile , "							<tr>" + CRLF )
    		fWrite( @nfhHtmlFile , "								<td id='colArial' colspan='3'><hr color='#000000' noshade size='1'>" + CRLF )
    		fWrite( @nfhHtmlFile , "								</td>" + CRLF )
    		fWrite( @nfhHtmlFile , "							</tr>" + CRLF )
			fWrite( @nfhHtmlFile , "						</table>" + CRLF )
		
		Else
	
			nByte		:= 0
			nBytes		:= Len( cLine )
			cNewLine	:= ""
			While ( ( ++nByte ) <= nBytes )
				cByte		:= Substr( cLine , nByte , 1 )
				lChkByte	:= ( Empty( cByte ) .or. ChkAsc( cByte , .F. ) )
				IF ( lChkByte )
					cNewLine += cByte
				Else
					cNewLine += " "
				EndIF
			End While
	
			cLine	:= StrTran( cNewLine , " " , "&nbsp;" )
			fWrite( @nfhHtmlFile , "						<table border='0' cellspacing='0' cellpadding='0' width='100%' bgcolor='#FFFFFF' style='FONT-SIZE: 9px; FONT-FAMILY: Arial'>" + CRLF )
			fWrite( @nfhHtmlFile , "							<tr style='FONT-SIZE: 8px; FONT-FAMILY: Courier New'>" + CRLF )
			fWrite( @nfhHtmlFile , "								<td id='colCourier' colspan='3' nowrap>" + cLine + CRLF )
			fWrite( @nfhHtmlFile , "								</td>" + CRLF )
			fWrite( @nfhHtmlFile , "							</tr>" + CRLF )
			fWrite( @nfhHtmlFile , "						</table>" + CRLF )
	
		EndIF
    
    Else
		
		lBr	:= .F.
		
		fWrite( @nfhHtmlFile , "						<table border='0' cellspacing='0' cellpadding='0' width='100%' bgcolor='#FFFFFF' style='FONT-SIZE: 9px; FONT-FAMILY: Arial'>" + CRLF )
		
		For nLoop := nLoop To nLoops
			
			cLine	:= aMsRelFile[ nLoop ]
			nAsc	:= Asc( cLine )
			
			IF (;
					( nAsc == 08 );
					.or.;
					( nAsc == 12 );
					.or.;
					( nAsc == 13 );
					.or.;
					( nAsc == 27 );
					.or.;
					( nAsc == 42 );
				)
				--nLoop
				Exit
			EndIF

			IF Empty( cLine )
				
				fWrite( @nfhHtmlFile , "						<table border='0' cellspacing='0' cellpadding='0' width='100%' bgcolor='#FFFFFF' style='FONT-SIZE: 9px; FONT-FAMILY: Arial'>" + CRLF )
				fWrite( @nfhHtmlFile , "							<br>" + CRLF )
	        	fWrite( @nfhHtmlFile , "						</table>" + CRLF )
				
				lBr	:= .T.
	        
	        Else
		   	
		   		cLine	:= StrTran( cLine , " " , "&nbsp;" )
				
				IF ( lBr )
					fWrite( @nfhHtmlFile , "						<table border='0' cellspacing='0' cellpadding='0' width='100%' bgcolor='#FFFFFF' style='FONT-SIZE: 9px; FONT-FAMILY: Arial'>" + CRLF )
				EndIF	

				fWrite( @nfhHtmlFile , "							<tr style='FONT-SIZE: 8px; FONT-FAMILY: Courier New'>" + CRLF )
		    	fWrite( @nfhHtmlFile , "								<td id='colCourier' nowrap>" + CRLF )
				fWrite( @nfhHtmlFile , cLine + CRLF )
	   		 	fWrite( @nfhHtmlFile , "								</td>" + CRLF )
	   			fWrite( @nfhHtmlFile , "							</tr>" + CRLF )
				
				IF ( lBr )
					fWrite( @nfhHtmlFile , "						</table>" + CRLF )
				EndIF

				lBr	:= .F.

	   		EndIF

			aMsRelFile[ nLoop ] := NIL

	    Next nLoop
	
	    fWrite( @nfhHtmlFile , "						</table>" + CRLF )
	
	EndIF

	aMsRelFile[ nLoop ] := NIL

Next nLoop

Return( NIL )