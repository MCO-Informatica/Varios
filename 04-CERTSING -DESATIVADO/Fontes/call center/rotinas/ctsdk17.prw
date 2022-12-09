#include 'protheus.ch'    
#include "ap5mail.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CTSDK17   ºAutor  ³Leandro Nishihata  º Data ³  19/10/16    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³MONTA CORPO HTML, COM BASE NO MODELO PADRAO CERTISIGN       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CTSDK17()
	

	Local cCabec  	 := ""
	Local ctext		 := ""
	Local i := 1
	Local x := 1
	Local cConfig	 := ALLTRIM(SKY->KY_BODY) // configuracoes do html (variavel é modificada conforme for gerando o html)
	Local lFim		 := .F.
	Local lFimIt 	 := .T.
	Local aCampos	 := {}   // campos que irao ser impresso no quadro de interacoes (somente os campos de configuracao)
	Local ADadosCad  := {}   // array contendo os campos a ser impressos no htm, (pode conter linhas de configuracoes, ou campos)
	Local lOrdem	 := .T.  // .T. = crescente .f. decrescente (padrao é ordem crescente)
	Local lTodos	 := .F.  // .T. = todas interacoes, .f. apenas a ultima (padrao é apenas a ultima)
	Local Pvez		 := .T.  // flag primeira passagem no while.
	Private inclui 	 := .f.
	// monta dados para a geracao do html, de acordo com os parametros informados.
	
	cCabec:=" <tr>																											"
	cCabec+="	<td width='10' style='width:10px'>&nbsp;</td>																"
	cCabec+="<td width='570'>																								"
	cCabec+="	<table width='570' border='0' cellspacing='0' cellpadding='0'>												"
	cCabec+="	 <tbody>																									"
	cCabec+="		<tr>																									"

	cConfig := alltrim(substr(cConfig,1,len(alltrim(cConfig))-3))
	WHILE !lFim	
	
		enter := .T.
		
		// retira linhas em branco.
		while enter 
			IF substr(cconfig,1,1) == Chr(13) .or. substr(cconfig,1,1) == Chr(10)
				cconfig := alltrim(substr(cconfig,2,len(cconfig)))
			else
			  enter := .F.
			endif		
		enddo	
		
		cConfig := alltrim(substr(cConfig,at("[",cConfig),len(alltrim(cConfig))))
		cTag := upper(substr(cConfig,at("[",cConfig)+1,at("]",cConfig)-at("[",cConfig)-1)) // armazena a tag 
		I := at("]",cConfig)+1
		cConfig := alltrim(substr(cConfig,i,len(alltrim(cConfig))))
		enter := .T.
		
		// retira linhas em branco.
		while enter 
			IF substr(cconfig,1,1) == Chr(13) .or. substr(cconfig,1,1) == Chr(10)
				cconfig := alltrim(substr(cconfig,2,len(cconfig)))
			else
			  enter := .F.
			endif		
		enddo		
		if at("[",cConfig) > 0 
			TXTFIN := at("[",cConfig)-1
		else 
			TXTFIN := len(cConfig)
			lFim := .T.
		endif		
		if cTag = "CABECALHO"
			ctext   :=  UPPER(substr(cConfig,1,TXTFIN))
			ctext   := CharSet(ctext)
		else
			ctext   := CharSet(substr(cConfig,1,TXTFIN))
		endif
		cConfig := alltrim(substr(cConfig,TXTFIN,len(alltrim(cConfig))))
		do case
		   case cTag = "CABECALHO" //  cabecalho do html
		   		cCabec += " <p style='font-family: &quot;Myriad Pro&quot;, Arial, Century; font-size: 16px; color:#ef7d00;'><b>"+ctext+"</b></p> "
		   case cTag = "DETALHE CABECALHO" // dizeres abaixo do cabecalho do html
		   		cCabec += " <p style='font-family: &quot;Myriad Pro&quot;, Arial, Century; font-size: 16px; color: #515151;'>"+ctext+"</p> " 
		   case cTag = "PROTOCOLO" // imprime o protocolo do atendimento.
		   		 cCabec +=  "<p style='font-family: &quot;Myriad Pro&quot;, Arial, Century; font-size: 16px; color:#004f9f; text-align:center'>PROTOCOLO: <strong>"+AllTrim(ADE->ADE_CODIGO)+"</strong></p>" 
		   case cTag = "DADOS CADASTRAIS"	// imprime quadro dos dados cadastrais	
		   cCabec += " <p style='font-family: &quot;Myriad Pro&quot;, Arial, Century; font-size: 16px; color:#ef7d00;'><b>DADOS CADASTRAIS</p> "		
		   cCabec += " </b><span style='font-family: &quot;Myriad Pro&quot;, Arial, Century; font-size: 16px; color:#004f9f;'> "
		   ADadosCad  := MontaArr(ctext)
		   	   For x:= 1 to len(adadoscad)
		   	   		campo := alltrim(POSICIONE("SX3",2,adadoscad[x],"X3_DESCRIC"))	
		   	   		Cdados := SX3->X3_ARQUIVO+"->"+adadoscad[x]
			   		if (SX3->X3_ARQUIVO $ "SA1/ADE") .or. adadoscad[x] == "U5_CONTAT "
				   		do case
				   			case SX3->X3_TIPO = "M"  //valtype(&(cdados)) ==	"M" // tratamento para impressao de campos memo
			   	   	   			If	alltrim(SX3->X3_RELACAO) = ""
			   	   	   				IF  cdados = "ADE_INCIDE" // tratamento campos que nao tem x3_relacao preenchido.
			   	   	   					cdados := MSMM(ADE->ADE_CODINC,TamSx3("ADE_INCIDE")[1])
			   	   	   				endif
			   	   	   			else
		   	   	   					cdados := 	&(SX3->X3_RELACAO)//MSMM(&(cdados),TamSx3(cdados)[1])
		   	   	   				endif
			   	   	   	   	case SX3->X3_TIPO = "D" //valtype(&(cdados)) ==	"D"
				   				cdados := FORMATADATA(&(cdados))
				   			case SX3->X3_TIPO = "N" //valtype(&(cdados)) == "N"
				   				cdados := alltrim(str(&(cdados)))
				   			case SX3->X3_TIPO = "C" //valtype(&(cdados)) == "C"
				   			if	!empty(AllTrim(X3Combo(adadoscad[x],&(Cdados))))
				   				cdados := CharSet(AllTrim(X3Combo(adadoscad[x],&(Cdados)))) // Caso tenha opcoes de combo no combo, será impresso a descricao relativa.
				   			else
				   				cdados := CharSet(alltrim(&(cdados)))	 
				   			endif
				   			do case
					   			case AllTrim(adadoscad[x]) == "ADE_GRUPO"
					   				cdados := AllTrim(GetAdvFVal('SU0','U0_NOME',xFilial('SU0')+ADE->ADE_GRUPO,1,'')) // Tratamento exclusivo para o campo do grupo de atendimento 
					   			case AllTrim(adadoscad[x]) == "U5_CONTAT"
					   				cdados := AllTrim(GetAdvFVal('SU5','U5_CONTAT',XFILIAL('SU5')+ADE->ADE_CODCON,1,''))  // Tratamento exclusivo para o campo do nome do contato
				   				case AllTrim(adadoscad[x]) == "A1_CGC"
						   			If Len(alltrim(cdados)) == 14
										cdados := Transform(cdados,"@R 99.999.999/9999-99")
									Else
										cdados := Transform(cdados,"@R 999.999.999-99")
									EndIf
				   			endcase
				   		endcase	
				   			 				   						   		
			   			cCabec += " "+campo+": <span style='color:#515151'>" +	cdados + "</span><br>"

			   	  	ENDIF	
			   	dbskip()
			   next
			  cCabec += " </p> " 
		   case cTag = "SITUACAO"	// monta quadro de situacao cadastral
			   cCabec += " <p style='font-family: &quot;Myriad Pro&quot;, Arial, Century; font-size: 16px; color:#ef7d00;'><b>DETALHES DO CHAMADO</p> "		
			   cCabec += " </b><span style='font-family: &quot;Myriad Pro&quot;, Arial, Century; font-size: 16px; color:#004f9f;'> "
	   
			   ADadosCad  := MontaArr(ctext)
			   		   
			   	  For x:= 1 to len(adadoscad)
			   	   	campo := alltrim(POSICIONE("SX3",2,adadoscad[x],"X3_DESCRIC"))	
				   	Cdados := SX3->X3_ARQUIVO+"->"+adadoscad[x]
				   	IF TYPE(cdados) == "U"
				   			cdados := adadoscad[x]
				    endif
				   	if SX3->X3_ARQUIVO = "ADE"
			   	   		do case
				   			case SX3->X3_TIPO = "M" //valtype(&(cdados)) ==	"M" // tratamento para impressao de campos memo
			   	   	   			If	alltrim(SX3->X3_RELACAO) = ""
			   	   	   				IF  cdados = "ADE_INCIDE" // tratamento campos que nao tem x3_relacao preenchido.
			   	   	   					cdados := MSMM(ADE->ADE_CODINC,TamSx3("ADE_INCIDE")[1])
			   	   	   				endif
			   	   	   			else
		   	   	   					cdados := 	&(SX3->X3_RELACAO)//MSMM(&(cdados),TamSx3(cdados)[1])
		   	   	   	   		endif
				   			case SX3->X3_TIPO = "D" //valtype(&(cdados)) ==	"D"
				   				cdados := FORMATADATA(&(cdados))
				   			case SX3->X3_TIPO = "N" // valtype(&(cdados)) == "N"
				   				cdados := alltrim(str(&(cdados)))
				   			case SX3->X3_TIPO = "C" // valtype(&(cdados)) == "C"
				   			if	!empty(AllTrim(X3Combo(adadoscad[x],&(Cdados))))
				   				cdados := CharSet(AllTrim(X3Combo(adadoscad[x],&(Cdados)))) // Caso tenha opcoes de combo no campo, será impresso a descricao relativa.
				   			else
				   				cdados := CharSet(alltrim(&(cdados)))
				   			endif
				   			do case
					   			case alltrim(adadoscad[x]) == "ADE_GRUPO"
					   				cdados := AllTrim(GetAdvFVal('SU0','U0_NOME',xFilial('SU0')+ADE->ADE_GRUPO,1,'')) // Tratamento exclusivo para o campo do grupo de atendimento 
					   			case alltrim(adadoscad[x]) == "ADE_CODCON"
					   				cdados := AllTrim(GetAdvFVal('SU5','U5_CONTAT',XFILIAL('SU5')+ADE->ADE_CODCON,1,'')) // Tratamento exclusivo para o campo do nome do contato
					   			case alltrim(adadoscad[x]) == "A1_CGC"
									If Len(cCPFCNPJ) == 14
										cdados := Transform(cdados,"@R 99.999.999/9999-99")
									Else
										cdados := Transform(cdados,"@R 999.999.999-99")
									EndIf
				   			endcase
				   		endcase	
				   						   			 				   						   		
			   			cCabec += " "+campo+": <span style='color:#515151'>" +	cdados + "</span><br>"
				   	  	ENDIF	
				   	dbskip()
				   next
				  cCabec += " </p><br> " 
			   
		   case cTag = "INTERACOES"  // monta quadro de interacoes
		   	   ADadosCad  := MontaArr(ctext)
   	   
			   dbSelectArea("SU0")
				aAreaSU0 := SU0->(GetArea())
				SU0->(dbSetOrder(1))		//U0_FILIAL+U0_CODIGO
				If  SU0->(MsSeek(xFilial("SU0")+ADE->ADE_GRUPO)) 
					
					
					For x:= 1 to len(adadoscad) // acampos( descricao da coluna, Dados de impressao )
						 do case 
						 case lower(adadoscad[x]) == "decrescente"
						 		lOrdem := .F.
						 case lower(adadoscad[x]) == "todas"
						 		lTodos := .T.
						 	case lower(adadoscad[x]) == "item"
							//	If SU0->U0_XITEM == "1"
									aadd(aCampos,{"Item","AllTrim(ADF->ADF_ITEM)"})
							//	EndIf
							case lower(adadoscad[x]) == "area"
								aadd(aCampos,{CharSet("Área"),"AllTrim(GetAdvFVal('SU0','U0_NOME',XFILIAL('SU0')+GetAdvFVal('SU7','U7_POSTO',XFILIAL('SU7')+TKOPERADOR(),1,''),1,''))"})
							case lower(adadoscad[x]) == "acao"
								aadd(aCampos,{CharSet("Ação"),"AllTrim(GetAdvFVal('SUQ','UQ_DESC',xFilial('SUQ')+ADF->ADF_CODSUQ,1,''))"})
							case lower(adadoscad[x]) == "ocorrencia"
								aadd(aCampos,{CharSet("Ocorrência"),"CAPITALACE(AllTrim(GetAdvFVal('SU9','U9_DESC',xFilial('SU9')+ADF->ADF_CODSU9,2,'')))"})
							case lower(adadoscad[x]) ==  "consultor"
								aadd(aCampos,{CharSet("Consultor"),"CAPITALACE(AllTrim(GetAdvFVal('SU7','U7_NOME',XFILIAL('SU7')+ADF->ADF_CODSU7,1,'')))"})
							case lower(adadoscad[x]) ==  "datahora"//data/hora
								aadd(aCampos,{CharSet("Data/Hora"),"DTOC(ADF->ADF_DATA) + ' ' + AllTrim(ADF->ADF_HORA)" })
							case lower(adadoscad[x]) ==  "observacao"//Observacao
								aadd(aCampos,{CharSet("Observação"),"AllTrim(MSMM(ADF->ADF_CODOBS,TamSX3('ADF_OBS')[1]))"})
						endcase
			   	    next x		   

				EndIf

				RestArea(aAreaSU0)
					   		cCabec+=" <tr>
							cCabec+="	<td><table width='100%' border='0' cellpadding='4' cellspacing='0'> "
							cCabec+="		<tbody>															"
						   	cCabec+="			<tr style='background-color:#ef7d00; font-family: &quot;Myriad Pro&quot;, Arial, Century; font-size:14px; color:#FFFFFF; font-weight:bold;text-align:center;'> "
						   	for i:= 1 to len(aCampos)
						   		cCabec+="				<td> "+	acampos[i][1]+"	</td>							"
							next
							cCabec+="			</tr>														"
			
			//Monta as linhas da tabela de itens do atendimento
				If Type("aWFs") == "A"
				aItens	:= aWFs[1]:ITENS
				
				dbSelectArea("ADF")
				aAreaADF := ADF->(GetArea())
				ADF->(dbSetOrder(1))		//ADF_FILIAL+ADF_CODIGO+ADF_ITEM
				
					If !Empty(aItens)
						nPosItem := ASCAN(aItens[1]:FIELDS, {|xItem| Upper(AllTrim(xItem:NAME)) == "ITEM"})
						If (nPosItem > 0)
							if !lOrdem .or. !ltodos
								x := len(aItens)
							else
								x := 1
							endif
							while lFimIt 
								If ADF->(MsSeek(xFilial("ADF")+ADE->ADE_CODIGO+aItens[X]:FIELDS[nPosItem]:VALUE))
								  	cCabec+="		<tr style='font-family: &quot;Myriad Pro&quot;, Arial, Century; font-size: 14px; color: #515151;border-bottom:1px; border-bottom-color:#CCCCCC;'>"
									for i := 1 to len(aCampos)
										cCabec+="		<td>"+&(aCampos[i][2])+" </td>					"
									next i
									cCabec+="		</tr>  												"
								EndIf
								if ((lOrdem .and. x = len(aitens)) .or. (!lOrdem .and. x = 1).and. !Pvez) .or. !lTodos
									lFimIt := .F.
								endif
								if lOrdem 
									x++
								else
									x--
								endif
								Pvez := .F.
							enddo
						EndIf
					EndIf				
				endif
				
				cCabec+="		</tbody>						"
				cCabec+="	  </table></td>					"
				
		   case cTag = "RODAPE" // imprime o rodape do html
		   	cCabec += " <p style='font-family: &quot;Myriad Pro&quot;, Arial, Century; font-size: 16px; color: #515151;'>"+ctext+"</p> "		   
		endcase
	enddo	
cCabec+="  </tr> "
cCabec+=" </tbody> "
cCabec+=" </table> "


Return( cCabec )

//-------------------------------------------------------------------------------------
/*/{Protheus.doc} CharSet
Função que transforma os símbolos e caracteres especiais da codificação ISO 8859-1 em
códigos HTML, para ser corretamente interpretado e exibido pelo browser.

@param		String a ser analisada e transformada
@author		Renan Guedes Alexandre
@version   	P10
@since      22/11/2012
/*/
//-------------------------------------------------------------------------------------
Static Function CharSet(cString)

Local aCharSet				:= {}
Local nX					:= 0

Default cString				:= ''

If !Empty(AllTrim(cString))

	AADD(aCharSet,{'-','&ndash;'})
	AADD(aCharSet,{'¡','&iexcl;'})
	AADD(aCharSet,{'¢','&cent;'})
	AADD(aCharSet,{'£','&pound;'})
	AADD(aCharSet,{'¤','&curren;'})
	AADD(aCharSet,{'¥','&yen;'})
	AADD(aCharSet,{'¦','&brvbar;'})
	AADD(aCharSet,{'§','&sect;'})
	AADD(aCharSet,{'¨','&uml;'})
	AADD(aCharSet,{'©','&copy;'})
	AADD(aCharSet,{'ª','&ordf;'})
	AADD(aCharSet,{'«','&laquo;'})
	AADD(aCharSet,{'¬','&not;'})
	AADD(aCharSet,{'®','&reg;'})
	AADD(aCharSet,{'¯','&macr;'})
	AADD(aCharSet,{'°','&deg;'})
	AADD(aCharSet,{'±','&plusmn;'})
	AADD(aCharSet,{'²','&sup2;'})
	AADD(aCharSet,{'³','&sup3;'})
	AADD(aCharSet,{'´','&acute;'})
	AADD(aCharSet,{'µ','&micro;'})
	AADD(aCharSet,{'¶','&para;'})
	AADD(aCharSet,{'·','&middot;'})
	AADD(aCharSet,{'¸','&cedil;'})
	AADD(aCharSet,{'¹','&sup1;'})
	AADD(aCharSet,{'º','&ordm;'})
	AADD(aCharSet,{'»','&raquo;'})
	AADD(aCharSet,{'¼','&frac14;'})
	AADD(aCharSet,{'½','&frac12;'})
	AADD(aCharSet,{'¾','&frac34;'})
	AADD(aCharSet,{'¿','&iquest;'})
	AADD(aCharSet,{'×','&times;'})
	AADD(aCharSet,{'÷','&divide;'})
	AADD(aCharSet,{'À','&Agrave;'})
	AADD(aCharSet,{'Á','&Aacute;'})
	AADD(aCharSet,{'Â','&Acirc;'})
	AADD(aCharSet,{'Ã','&Atilde;'})
	AADD(aCharSet,{'Ä','&Auml;'})
	AADD(aCharSet,{'Å','&Aring;'})
	AADD(aCharSet,{'Æ','&AElig;'})
	AADD(aCharSet,{'Ç','&Ccedil;'})
	AADD(aCharSet,{'È','&Egrave;'})
	AADD(aCharSet,{'É','&Eacute;'})
	AADD(aCharSet,{'Ê','&Ecirc;'})
	AADD(aCharSet,{'Ë','&Euml;'})
	AADD(aCharSet,{'Ì','&Igrave;'})
	AADD(aCharSet,{'Í','&Iacute;'})
	AADD(aCharSet,{'Î','&Icirc;'})
	AADD(aCharSet,{'Ï','&Iuml;'})
	AADD(aCharSet,{'Ð','&ETH;'})
	AADD(aCharSet,{'Ñ','&Ntilde;'})
	AADD(aCharSet,{'Ò','&Ograve;'})
	AADD(aCharSet,{'Ó','&Oacute;'})
	AADD(aCharSet,{'Ô','&Ocirc;'})
	AADD(aCharSet,{'Õ','&Otilde;'})
	AADD(aCharSet,{'Ö','&Ouml;'})
	AADD(aCharSet,{'Ø','&Oslash;'})
	AADD(aCharSet,{'Ù','&Ugrave;'})
	AADD(aCharSet,{'Ú','&Uacute;'})
	AADD(aCharSet,{'Û','&Ucirc;'})
	AADD(aCharSet,{'Ü','&Uuml;'})
	AADD(aCharSet,{'Ý','&Yacute;'})
	AADD(aCharSet,{'Þ','&THORN;'})
	AADD(aCharSet,{'ß','&szlig;'})
	AADD(aCharSet,{'à','&agrave;'})
	AADD(aCharSet,{'á','&aacute;'})
	AADD(aCharSet,{'â','&acirc;'})
	AADD(aCharSet,{'ã','&atilde;'})
	AADD(aCharSet,{'ä','&auml;'})
	AADD(aCharSet,{'å','&aring;'})
	AADD(aCharSet,{'æ','&aelig;'})
	AADD(aCharSet,{'ç','&ccedil;'})
	AADD(aCharSet,{'è','&egrave;'})
	AADD(aCharSet,{'é','&eacute;'})
	AADD(aCharSet,{'ê','&ecirc;'})
	AADD(aCharSet,{'ë','&euml;'})
	AADD(aCharSet,{'ì','&igrave;'})
	AADD(aCharSet,{'í','&iacute;'})
	AADD(aCharSet,{'î','&icirc;'})
	AADD(aCharSet,{'ï','&iuml;'})
	AADD(aCharSet,{'ð','&eth;'})
	AADD(aCharSet,{'ñ','&ntilde;'})
	AADD(aCharSet,{'ò','&ograve;'})
	AADD(aCharSet,{'ó','&oacute;'})
	AADD(aCharSet,{'ô','&ocirc;'})
	AADD(aCharSet,{'õ','&otilde;'})
	AADD(aCharSet,{'ö','&ouml;'})
	AADD(aCharSet,{'ø','&oslash;'})
	AADD(aCharSet,{'ù','&ugrave;'})
	AADD(aCharSet,{'ú','&uacute;'})
	AADD(aCharSet,{'û','&ucirc;'})
	AADD(aCharSet,{'ü','&uuml;'})
	AADD(aCharSet,{'ý','&yacute;'})
	AADD(aCharSet,{'þ','&thorn;'})
	AADD(aCharSet,{'ÿ','&yuml;'})
	
	For nX := 1 To Len(aCharSet)
		cString := StrTran(cString,aCharSet[nX,1],aCharSet[nX,2])
	Next nX
EndIf
	
Return cString

 // monta array com os dados da string.
 
Static Function Montaarr(ctext)

Local Ret
	   
	    ctext := StrTran(ctext,Chr(13) + Chr(10),",")
	   	ctext := StrTran(ctext,";",",")
	   	ctext := StrTran(ctext,"/",",")
	   	ctext := StrTran(ctext,"\",",")		   	
	   	ctext := StrTran(ctext,".",",")
	   	ctext := StrTran(ctext,":",",")
	   	
	    Ret := STRTOKARR(ctext,"," ) 		   
	   	    
return Ret


user function teste2()

	dbSelectArea("SX3")
	dbSetOrder(2)
   If dbSeek( "ADE_OBSERV" )
   DBSELECTAREA("ADE")
   DBSETORDER(1)
   DBSEEK("02202777")
   			//if valtype(&(cdados)) ==	"M" // tratamento para impressao de campos memo
   	   			cdados := 	&(SX3->X3_RELACAO)//MSMM(&(cdados),TamSx3(cdados)[1])
   			//endif
   ENDIF
				   		
return
