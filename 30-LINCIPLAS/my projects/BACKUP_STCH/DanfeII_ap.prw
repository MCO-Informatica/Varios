#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 04/05/09
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"
#DEFINE VBOX      080
#DEFINE VSPACE    008
#DEFINE HSPACE    010
#DEFINE SAYVSPACE 008
#DEFINE SAYHSPACE 008
#DEFINE HMARGEM   030
#DEFINE VMARGEM   030
#DEFINE MAXITEM   Max((022-Max(0,Len(aMensagem)-02)),1)
#DEFINE MAXITEMP2 055
#DEFINE MAXMENLIN 070

User Function DanfeII()        // incluido pelo assistente de conversao do AP6 IDE em 04/05/09

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP6 IDE                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

SetPrvt("AAREA,ODANFE,PIXELX,PIXELY,ANOTAS,AXML")
SetPrvt("AAUTORIZA,CNAOAUT,CALIASSF3,CWHERE,CAVISO,CERRO")
SetPrvt("CAUTORIZA,CMODALIDADE,CCHAVESFT,CALIASSFT,CCONDICAO,CINDEX")
SetPrvt("CCHAVE,LQUERY,NX,MV_PAR01,ONFE,OFONT08")
SetPrvt("OFONT07N,OFONT10,OFONT10N,OFONT11,OFONT12,OFONT11N")
SetPrvt("OFONT18N,ATAMANHO,ASITTRIB,ATRANSP,ADEST,AFATURAS")
SetPrvt("AITENS,AISSQN,ATOTAIS,AAUX,NHPAGE,NVPAGE")
SetPrvt("NPOSV,NPOSVOLD,NPOSH,NPOSHOLD,NAUXH,NY")
SetPrvt("NTAMANHO,NFOLHA,NFOLHAS,NITEM,NBASEICM,NVALICM")
SetPrvt("NVALIPI,NPICM,NPIPI,NFATURAS,NVTOTAL,NQTD")
SetPrvt("NVUNIT,NVOLUME,CAUX,CSITTRIB,AMENSAGEM,LPREVIEW")
SetPrvt("ONF,OEMITENTE,OIDENT,ODESTINO,OTOTAL,OTRANSP")
SetPrvt("ODET,OFATURA,NPRIVATE,NPRIVATE2,NXAUX,NPESOB")
SetPrvt("NPESOL,OIMPOSTO,CLOGO,NAUXV,NITEMOLD,AULTCHAR2PIX")
SetPrvt("AULTVCHAR2PIX,CCHAR,CURL,CRETORNO,CPROTOCOLO,ARETORNO")
SetPrvt("ARESPOSTA,AFALTA,AEXECUTE,CDHRECBTO,CDTHRREC,CDTHRREC1")
SetPrvt("NDTHRREC1,OWS,CUSERTOKEN,CID_ENT,NMODALIDADE,_URL")
SetPrvt("OWSNFEID,OWSNOTAS,CID,NDIASPARAEXCLUSAO,ODHRECBTO,CDATA")
SetPrvt("DDATA,NZ,NMAXNX,NMAXNY,NMAXNZ,NPOSV1")
SetPrvt("NPOSV2,NPOSH1,NPOSH2,NTAM,NDIF,CMAXTAM")
SetPrvt("AFONT,LTITULO,LTEMTIT,NTPFONT,AALIGN,NCOLAJUSTE")

// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 04/05/09 ==> #INCLUDE "PROTHEUS.CH"
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 04/05/09 ==> #INCLUDE "TBICONN.CH"
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 04/05/09 ==> #INCLUDE "COLORS.CH"

// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 04/05/09 ==> #DEFINE VBOX      080
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 04/05/09 ==> #DEFINE VSPACE    008
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 04/05/09 ==> #DEFINE HSPACE    010
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 04/05/09 ==> #DEFINE SAYVSPACE 008
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 04/05/09 ==> #DEFINE SAYHSPACE 008
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 04/05/09 ==> #DEFINE HMARGEM   030
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 04/05/09 ==> #DEFINE VMARGEM   030
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 04/05/09 ==> #DEFINE MAXITEM   Max((022-Max(0,Len(aMensagem)-02)),1)
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 04/05/09 ==> #DEFINE MAXITEMP2 055
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 04/05/09 ==> #DEFINE MAXMENLIN 070

Static aUltChar2pix
Static aUltVChar2pix
/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿛rograma  쿛rtNfeSef � Autor � Eduardo Riera         � Data �16.11.2006낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇚o 쿝dmake de exemplo para impress�o da DANFE no formato Retrato낢�
굇�          �                                                            낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿝etorno   쿙enhum                                                      낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿛arametros쿙enhum                                                      낢�
굇�          �                                                            낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컫컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇�   DATA   � Programador   쿘anutencao efetuada                         낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇�          �               �                                            낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
/*/


Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 04/05/09

// Substituido pelo assistente de conversao do AP6 IDE em 04/05/09 ==> User Function PrtNfeSef(cIdEnt)
Static User Function PrtNfeSef(cIdEnt)()

Local aArea     := GetArea()

Local oDanfe

oDanfe 	:= TMSPrinter():New("DANFE - Documento Auxiliar da Nota Fiscal Eletr�nica")
oDanfe:SetPortrait()
oDanfe:Setup()

Private PixelX := odanfe:nLogPixelX()
Private PixelY := odanfe:nLogPixelY()
	
RptStatus({|lEnd| DanfeProc(@oDanfe,@lEnd,cIdEnt)},"Imprimindo Danfe...")
oDanfe:Preview()

RestArea(aArea)
Return(.T.)

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿛rograma  쿏ANFEProc � Autor � Eduardo Riera         � Data �16.11.2006낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇚o 쿝dmake de exemplo para impress�o da DANFE no formato Retrato낢�
굇�          �                                                            낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿝etorno   쿙enhum                                                      낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿛arametros쿐xpO1: Objeto grafico de impressao                    (OPC) 낢�
굇�          �                                                            낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컫컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇�   DATA   � Programador   쿘anutencao efetuada                         낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇�          �               �                                            낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
/*/

// Substituido pelo assistente de conversao do AP6 IDE em 04/05/09 ==> Static Function DanfeProc(oDanfe,lEnd,cIdEnt)
Static Static Function DanfeProc(oDanfe,lEnd,cIdEnt)()

Local aArea      := GetArea()
Local aNotas     := {}
Local aXML       := {}
Local aAutoriza  := {}
Local cNaoAut    := ""

Local cAliasSF3  := "SF3"
Local cWhere     := ""
Local cAviso     := ""
Local cErro      := ""
Local cAutoriza  := ""
Local cModalidade:= "" 
Local cChaveSFT  := ""
Local cAliasSFT  := "SFT" 
Local cCondicao	 := ""
Local cIndex	 := ""
Local cChave	 := ""

Local lQuery     := .F.

Local nX         := 0

Local oNfe 

If Pergunte("NFSIGW",.T.)
	MV_PAR01 := AllTrim(MV_PAR01)
	dbSelectArea("SF3")
	dbSetOrder(5)
	#IFDEF TOP
		If MV_PAR04==1
			cWhere := "%SubString(SF3.F3_CFO,1,1) < '5' AND SF3.F3_FORMUL='S'%"
		ElseIf MV_PAR04==2
			cWhere := "%SubString(SF3.F3_CFO,1,1) >= '5'%"
		EndIf	
		cAliasSF3 := GetNextAlias()
		lQuery    := .T.
		
		If Empty(cWhere)
	
			BeginSql Alias cAliasSF3
			
			COLUMN F3_ENTRADA AS DATE
			COLUMN F3_DTCANC AS DATE
					
			SELECT	F3_FILIAL,F3_ENTRADA,F3_NFELETR,F3_CFO,F3_FORMUL,F3_NFISCAL,F3_SERIE,F3_CLIEFOR,F3_LOJA,F3_ESPECIE,F3_DTCANC
					FROM %Table:SF3% SF3
					WHERE
					SF3.F3_FILIAL = %xFilial:SF3% AND
					SF3.F3_SERIE = %Exp:MV_PAR03% AND 
					SF3.F3_NFISCAL >= %Exp:MV_PAR01% AND 
					SF3.F3_NFISCAL <= %Exp:MV_PAR02% AND 
					SF3.F3_DTCANC = %Exp:Space(8)% AND
					SF3.%notdel%
			EndSql	
	
		Else
			BeginSql Alias cAliasSF3
			
			COLUMN F3_ENTRADA AS DATE
			COLUMN F3_DTCANC AS DATE
					
			SELECT	F3_FILIAL,F3_ENTRADA,F3_NFELETR,F3_CFO,F3_FORMUL,F3_NFISCAL,F3_SERIE,F3_CLIEFOR,F3_LOJA,F3_ESPECIE,F3_DTCANC
					FROM %Table:SF3% SF3
					WHERE
					SF3.F3_FILIAL = %xFilial:SF3% AND
					SF3.F3_SERIE = %Exp:MV_PAR03% AND 
					SF3.F3_NFISCAL >= %Exp:MV_PAR01% AND 
					SF3.F3_NFISCAL <= %Exp:MV_PAR02% AND 
					%Exp:cWhere% AND 
					SF3.F3_DTCANC = %Exp:Space(8)% AND
					SF3.%notdel%
			EndSql	
		
		EndIf
	
	#ELSE
		MsSeek(xFilial("SF3")+MV_PAR03+MV_PAR01,.T.)
	    cIndex    		:= CriaTrab(NIL,.F.)
	    cChave			:= IndexKey(6)
	    cCondicao 		:= 'F3_FILIAL == "' + xFilial("SF3") + '" .And. '
	   	cCondicao 		+= 'SF3->F3_SERIE =="'+ MV_PAR03+'" .And. '
	   	cCondicao 		+= 'SF3->F3_NFISCAL >="'+ MV_PAR01+'" .And. '
		cCondicao		+= 'SF3->F3_NFISCAL <="'+ MV_PAR02+'" .And. '
		cCondicao		+= 'Empty(SF3->F3_DTCANC)'
		IndRegua("SF3",cIndex,cChave,,cCondicao)
	#ENDIF
	If MV_PAR04==1
		cWhere := "SubStr(F3_CFO,1,1) < '5' .AND. F3_FORMUL=='S'"
	Elseif MV_PAR04==2
		cWhere := "SubStr(F3_CFO,1,1) >= '5'"
	Else
		cWhere := ".T."
	EndIf	
	While !Eof() .And. xFilial("SF3") == (cAliasSF3)->F3_FILIAL .And.;
		(cAliasSF3)->F3_SERIE == MV_PAR03 .And.;
		(cAliasSF3)->F3_NFISCAL >= MV_PAR01 .And.;
		(cAliasSF3)->F3_NFISCAL <= MV_PAR02
		
		dbSelectArea(cAliasSF3)
		If  Empty((cAliasSF3)->F3_DTCANC) .And. &cWhere //.And. AModNot((cAliasSF3)->F3_ESPECIE)=="55"
		
			If (SubStr((cAliasSF3)->F3_CFO,1,1)>="5" .Or. (cAliasSF3)->F3_FORMUL=="S") .And. aScan(aNotas,{|x| x[4]+x[5]+x[6]+x[7]==(cAliasSF3)->F3_SERIE+(cAliasSF3)->F3_NFISCAL+(cAliasSF3)->F3_CLIEFOR+(cAliasSF3)->F3_LOJA})==0
				
				aadd(aNotas,{})
				aadd(Atail(aNotas),.F.)
				aadd(Atail(aNotas),IIF((cAliasSF3)->F3_CFO<"5","E","S"))
				aadd(Atail(aNotas),(cAliasSF3)->F3_ENTRADA)
				aadd(Atail(aNotas),(cAliasSF3)->F3_SERIE)
				aadd(Atail(aNotas),(cAliasSF3)->F3_NFISCAL)
				aadd(Atail(aNotas),(cAliasSF3)->F3_CLIEFOR)
				aadd(Atail(aNotas),(cAliasSF3)->F3_LOJA)
							
			EndIf
		EndIf
		
		dbSelectArea(cAliasSF3)
		dbSkip()
		If lEnd
			Exit
		EndIf	
		If Len(aNotas) >= 50 .Or. 	(cAliasSF3)->(Eof())
			aXml := GetXML(cIdEnt,aNotas,@cModalidade)
			For nX := 1 To Len(aNotas)
				If !Empty(aXML[nX][2])
					If !Empty(aXml[nX])
						cAutoriza := aXML[nX][1]
					Else
						cAutoriza := ""
					EndIf
					If (!Empty(cAutoriza) .Or. !cModalidade$"1,4,5")
						If aNotas[nX][02]=="E"
				    		dbSelectArea("SF1")
				    		dbSetOrder(1)
			    			If MsSeek(xFilial("SF1")+aNotas[nX][05]+aNotas[nX][04]+aNotas[nX][06]+aNotas[nX][07]) .And. SF1->(FieldPos("F1_FIMP"))<>0 .And. cModalidade$"1,4"
								RecLock("SF1")
								If !SF1->F1_FIMP$"D"
									SF1->F1_FIMP := "S"
								EndIf
								If SF1->(FieldPos("F1_CHVNFE"))>0
									SF1->F1_CHVNFE := SubStr(SpedNfeId(aXML[nX][2],"Id"),4)
								EndIf			    			   
								MsUnlock()
		    				EndIf
						Else
				    		dbSelectArea("SF2")
				    		dbSetOrder(1)
				    		If MsSeek(xFilial("SF2")+aNotas[nX][05]+aNotas[nX][04]+aNotas[nX][06]+aNotas[nX][07]) .And. cModalidade$"1,4"
								RecLock("SF2")
								If !SF2->F2_FIMP$"D"
									SF2->F2_FIMP := "S"
								EndIf
								If SF2->(FieldPos("F2_CHVNFE"))>0
									SF2->F2_CHVNFE := SubStr(SpedNfeId(aXML[nX][2],"Id"),4)       
								EndIf
								MsUnlock()
			    			EndIf
						EndIf
						dbSelectArea("SFT")
						dbSetOrder(1)
						If SFT->(FieldPos("FT_CHVNFE"))>0
							cChaveSFT	:=	(xFilial("SFT")+aNotas[nX][02]+aNotas[nX][04]+aNotas[nX][05]+aNotas[nX][06]+aNotas[nX][07])							
							MsSeek(cChaveSFT)
							Do While !(cAliasSFT)->(Eof ()) .And.;
								     cChaveSFT==(cAliasSFT)->FT_FILIAL+(cAliasSFT)->FT_TIPOMOV+(cAliasSFT)->FT_SERIE+(cAliasSFT)->FT_NFISCAL+(cAliasSFT)->FT_CLIEFOR+(cAliasSFT)->FT_LOJA
								   RecLock("SFT")
								   SFT->FT_CHVNFE := SubStr(SpedNfeId(aXML[nX][2],"Id"),4)
							   	   MsUnLock()
							   	   DbSkip()
							EndDo							
                        EndIf
						
						cAviso := ""
						cErro  := ""
						oNfe := XmlParser(aXML[nX][2],"_",@cAviso,@cErro)					
						If Empty(cAviso) .And. Empty(cErro)	
						    ImpDet(@oDanfe,oNFe,cAutoriza,cModalidade)					    
						EndIf
					Else				
						cNaoAut += aNotas[nX][04]+aNotas[nX][05]+CRLF			
					EndIf
				EndIf
			Next nX
			aNotas := {}
		EndIf		
		dbSelectArea(cAliasSF3)
	EndDo
	If !lQuery 
		RetIndex("SF3")	
		dbClearFilter()	
		Ferase(cIndex+OrdBagExt())
	EndIf
	If !Empty(cNaoAut)
		Aviso("SPED","As seguintes notas n�o foram autorizadas: "+CRLF+CRLF+cNaoAut,{"Ok"},3)
	EndIf
EndIf
RestArea(aArea)
Return(.T.)

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿛rogram   � ImpDet   � Autor � Eduardo Riera         � Data �16.11.2006낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇚o 쿎ontrole de Fluxo do Relatorio.                             낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿝etorno   쿙enhum                                                      낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿛arametros쿐xpO1: Objeto grafico de impressao                    (OPC) 낢�
굇�          쿐xpC2: String com o XML da NFe                              낢�
굇�          쿐xpC3: Codigo de Autorizacao do fiscal                (OPC) 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컫컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇�   DATA   � Programador   쿘anutencao efetuada                         낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇�          �               �                                            낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
/*/
// Substituido pelo assistente de conversao do AP6 IDE em 04/05/09 ==> Static Function ImpDet(oDanfe,oNfe,cCodAutSef,cModalidade)
Static Static Function ImpDet(oDanfe,oNfe,cCodAutSef,cModalidade)()

PRIVATE oFont08    := TFont():New("Arial",08,08,,.F.,,,,.T.,.F.)
PRIVATE oFont07N   := TFont():New("Arial",07,07,,.T.,,,,.T.,.F.)
PRIVATE oFont10    := TFont():New("Arial",10,10,,.F.,,,,.T.,.F.)
PRIVATE oFont10n   := TFont():New("Arial",10,10,,.T.,,,,.T.,.F.)
PRIVATE oFont11    := TFont():New("Arial",11,11,,.F.,,,,.T.,.F.)
PRIVATE oFont12    := TFont():New("Arial",12,08,,.F.,,,,.T.,.F.)
PRIVATE oFont11N   := TFont():New("Arial",11,07,,.T.,,,,.T.,.F.)
PRIVATE oFont18N   := TFont():New("Arial",18,18,,.T.,,,,.T.,.F.)

PrtDanfe(@oDanfe,oNfe,cCodAutSef,cModalidade)

Return(.T.)


/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑un뇚o    쿛rtDanfe  � Autor 쿐duardo Riera          � Data �16.11.2006낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇚o 쿔mpressao do formulario DANFE grafico conforme laytout no   낢�
굇�          쿯ormato retrato                                             낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿞intaxe   � PrtDanfe()                                                 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿝etorno   � Nenhum                                                     낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿛arametros쿐xpO1: Objeto grafico de impressao                          낢�
굇�          쿐xpO2: Objeto da NFe                                        낢�
굇�          쿐xpC3: Codigo de Autorizacao do fiscal                (OPC) 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컫컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇�   DATA   � Programador   쿘anutencao Efetuada                         낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇�          �               �                                            낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
*/
// Substituido pelo assistente de conversao do AP6 IDE em 04/05/09 ==> Static Function PrtDanfe(oDanfe,oNFE,cCodAutSef,cModalidade)
Static Static Function PrtDanfe(oDanfe,oNFE,cCodAutSef,cModalidade)()

Local aTamanho   := {}
Local aSitTrib   := {}
Local aTransp    := {}
Local aDest      := {}
Local aFaturas   := {}
Local aItens     := {}
Local aISSQN     := {}
Local aTotais    := {}
Local aAux       := {}
Local nHPage     := 0 
Local nVPage     := 0 
Local nPosV      := 0
Local nPosVOld   := 0
Local nPosH      := 0
Local nPosHOld   := 0
Local nAuxH       := 0
Local nX         := 0
Local nY         := 0
Local nTamanho   := 0
Local nFolha     := 1
Local nFolhas    := 0
Local nItem      := 0
Local nBaseICM   := 0
Local nValICM    := 0
Local nValIPI    := 0
Local nPICM      := 0
Local nPIPI      := 0
Local nFaturas   := 0
Local nVTotal    := 0
Local nQtd       := 0
Local nVUnit     := 0
Local nVolume	 := 0
Local cAux       := ""
Local cSitTrib   := ""
Local aMensagem  := {}
Local lPreview   := .F.
Private oNF        := oNFe:_NFe
Private oEmitente  := oNF:_InfNfe:_Emit
Private oIdent     := oNF:_InfNfe:_IDE
Private oDestino   := oNF:_InfNfe:_Dest
Private oTotal     := oNF:_InfNfe:_Total
Private oTransp    := oNF:_InfNfe:_Transp
Private oDet       := oNF:_InfNfe:_Det
Private oFatura    := IIf(Type("oNF:_InfNfe:_Cobr")=="U",Nil,oNF:_InfNfe:_Cobr)
Private oImposto
Private nPrivate   := 0
Private nPrivate2  := 0
Private nXAux	   := 0

nFaturas   := IIf(oFatura<>Nil,IIf(ValType(oNF:_InfNfe:_Cobr:_Dup)=="A",Len(oNF:_InfNfe:_Cobr:_Dup),1),0)
oDet := IIf(ValType(oDet)=="O",{oDet},oDet)
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//쿎arrega as variaveis de impressao                                       �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
aadd(aSitTrib,"00")
aadd(aSitTrib,"10")
aadd(aSitTrib,"20")
aadd(aSitTrib,"30")
aadd(aSitTrib,"40")
aadd(aSitTrib,"41")
aadd(aSitTrib,"50")
aadd(aSitTrib,"51")
aadd(aSitTrib,"60")
aadd(aSitTrib,"70")
aadd(aSitTrib,"90")
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//쿜uadro Destinatario                                                     �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
aDest := {oDestino:_EnderDest:_Xlgr:Text+IIF(", SN"$oDestino:_EnderDest:_Xlgr:Text,"",", "+oDestino:_EnderDest:_NRO:Text),;
			oDestino:_EnderDest:_XBairro:Text,;
			IIF(Type("oDestino:_EnderDest:_Cep")=="U","",Transform(oDestino:_EnderDest:_Cep:Text,"@r 99999-999")),;
			oIdent:_DSaiEnt:Text,;
			oDestino:_EnderDest:_XMun:Text,;
			IIF(Type("oDestino:_EnderDest:_fone")=="U","",oDestino:_EnderDest:_fone:Text),;
			oDestino:_EnderDest:_UF:Text,;
			oDestino:_IE:Text,;
			""}
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//쿎alculo do Imposto                                                      �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
aTotais := {"","","","","","","","","","",""}
aTotais[01] := Transform(Val(oTotal:_ICMSTOT:_vBC:TEXT),"@ze 999,999,999.99")
aTotais[02] := Transform(Val(oTotal:_ICMSTOT:_vICMS:TEXT),"@ze 9,999,999.99")
aTotais[03] := Transform(Val(oTotal:_ICMSTOT:_vBCST:TEXT),"@ze 999,999,999.99")
aTotais[04] := Transform(Val(oTotal:_ICMSTOT:_vST:TEXT),"@ze 9,999,999.99")
aTotais[05] := Transform(Val(oTotal:_ICMSTOT:_vProd:TEXT),"@ze 9,999,999.99")
aTotais[06] := Transform(Val(oTotal:_ICMSTOT:_vFrete:TEXT),"@ze 9,999,999.99")
aTotais[07] := Transform(Val(oTotal:_ICMSTOT:_vSeg:TEXT),"@ze 9,999,999.99")
aTotais[08] := Transform(Val(oTotal:_ICMSTOT:_vDesc:TEXT),"@ze 9,999,999.99")
aTotais[09] := Transform(Val(oTotal:_ICMSTOT:_vOutro:TEXT),"@ze 9,999,999.99")
aTotais[10] := 	Transform(Val(oTotal:_ICMSTOT:_vIPI:TEXT),"@ze 9,999,999.99")
aTotais[11] := 	Transform(Val(oTotal:_ICMSTOT:_vNF:TEXT),"@ze 999,999,999.99")	
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//쿜uadro Faturas                                                          �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
If nFaturas > 0
	For nX := 1 To Min(3,nFaturas)
		aadd(aFaturas,{"Titulo","Vencto","Valor"})
	Next nX
	For nX := Len(aFaturas)+1 To 3
		aadd(aFaturas,{PadR("",20),PadR("",10),PadR("",14)})
	Next nX
	If nFaturas > 1
		For nX := 1 To nFaturas
			aadd(aFaturas,{oFatura:_Dup[nX]:_nDup:TEXT,ConvDate(oFatura:_Dup[nX]:_dVenc:TEXT),TransForm(Val(oFatura:_Dup[nX]:_vDup:TEXT),"@e 9999,999,999.99")})
		Next nX
		For nX :=1 To nFaturas - 1
				aadd(aFaturas,{PadR("",Len(oFatura:_Dup[nX]:_nDup:TEXT)),PadR("",10),PadR("",14)})
		Next nX
	Else
		aadd(aFaturas,{oFatura:_Dup:_nDup:TEXT,ConvDate(oFatura:_Dup:_dVenc:TEXT),TransForm(Val(oFatura:_Dup:_vDup:TEXT),"@e 9999,999,999.99")})
	EndIf
EndIf
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//쿜uadro transportadora                                                   �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
aTransp := {"","1","","","","","","","","","","","","","",""}
If Type("oTransp:_Transporta")<>"U"
	aTransp[01] := IIf(Type("oTransp:_Transporta:_xNome:TEXT")<>"U",oTransp:_Transporta:_xNome:TEXT,"")
	aTransp[02] := IIF(oTransp:_ModFrete:TEXT=="0","1","2")
	aTransp[03] := IIf(Type("oTransp:_Transporta:_RNTC")=="U","",oTransp:_Transporta:_RNTC:TEXT)
	aTransp[04] := IIf(Type("oTransp:_VeicTransp:_Placa:TEXT")<>"U",oTransp:_VeicTransp:_Placa:TEXT,"")
	aTransp[05] := IIf(Type("oTransp:_VeicTransp:_UF:TEXT")<>"U",oTransp:_VeicTransp:_UF:TEXT,"")
	If Type("oTransp:_Transporta:_CNPJ:TEXT")<>"U"
		aTransp[06] := Transform(oTransp:_Transporta:_CNPJ:TEXT,"@r 99.999.999/9999-99")
	ElseIf Type("oTransp:_Transporta:_CPF:TEXT")<>"U"
		aTransp[06] := Transform(oTransp:_Transporta:_CPF:TEXT,"@r 999.999.999-99")
	EndIf
	aTransp[07] := IIf(Type("oTransp:_Transporta:_xEnder:TEXT")<>"U",oTransp:_Transporta:_xEnder:TEXT,"")
	aTransp[08] := IIf(Type("oTransp:_Transporta:_xMun:TEXT")<>"U",oTransp:_Transporta:_xMun:TEXT,"")
	aTransp[09] := IIf(Type("oTransp:_Transporta:_UF:TEXT")<>"U",oTransp:_Transporta:_UF:TEXT,"")
	aTransp[10] := IIf(Type("oTransp:_Transporta:_IE:TEXT")<>"U",oTransp:_Transporta:_IE:TEXT,"")
EndIf
If Type("oTransp:_Vol")<>"U"
    If ValType(oTransp:_Vol) == "A"
	    nX := nPrivate
    	For nX := 1 to Len(oTransp:_Vol) 
    		nXAux := nX
    		nVolume += IIF(!Type("oTransp:_Vol[nXAux]:_QVOL:TEXT")=="U",Val(oTransp:_Vol[nXAux]:_QVOL:TEXT),0)
	    Next nX
	    aTransp[11]	:= AllTrim(str(nVolume))
		aTransp[12]	:= IIf(Type("oTransp:_Vol:_Esp")=="U","Diversos","")
		aTransp[13] := IIf(Type("oTransp:_Vol:_Marca")=="U","",oTransp:_Vol:_Marca:TEXT)
		aTransp[14] := IIf(Type("oTransp:_Vol:_nVol:TEXT")<>"U",oTransp:_Vol:_nVol:TEXT,"")
		If  Type("oTransp:_Vol[1]:_PesoB") <>"U"
            	nPesoB := Val(oTransp:_Vol[1]:_PesoB:TEXT)
   				aTransp[15] := AllTrim(str(nPesoB))
  			EndIf
  		If Type("oTransp:_Vol[1]:_PesoL") <>"U"
            nPesoL := Val(oTransp:_Vol[1]:_PesoL:TEXT)
			aTransp[16] := AllTrim(str(nPesoL))
		EndIf
    Else
		aTransp[11] := IIf(Type("oTransp:_Vol:_qVol:TEXT")<>"U",oTransp:_Vol:_qVol:TEXT,"")    
		aTransp[12] := IIf(Type("oTransp:_Vol:_Esp")=="U","",oTransp:_Vol:_Esp:TEXT)
		aTransp[13] := IIf(Type("oTransp:_Vol:_Marca")=="U","",oTransp:_Vol:_Marca:TEXT)
		aTransp[14] := IIf(Type("oTransp:_Vol:_nVol:TEXT")<>"U",oTransp:_Vol:_nVol:TEXT,"")
		aTransp[15] := IIf(Type("oTransp:_Vol:_PesoB:TEXT")<>"U",oTransp:_Vol:_PesoB:TEXT,"")
		aTransp[16] := IIf(Type("oTransp:_Vol:_PesoL:TEXT")<>"U",oTransp:_Vol:_PesoL:TEXT,"")		
    EndIf
EndIf



//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//쿜uadro Dados do Produto / Servi�o                                       �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
For nX := 1 To Len(oDet)
	nPrivate := nX
	nVTotal  := Val(oDet[nX]:_Prod:_vProd:TEXT)//-Val(IIF(Type("oDet[nPrivate]:_Prod:_vDesc")=="U","",oDet[nX]:_Prod:_vDesc:TEXT))
	nQtd     := Val(oDet[nX]:_Prod:_qTrib:TEXT)
	nVUnit   := Val(oDet[nX]:_Prod:_vUnCom:TEXT)
	nBaseICM := 0
	nValICM  := 0
	nValIPI  := 0
	nPICM    := 0
	nPIPI    := 0
	oImposto := oDet[nX]
	cSitTrib := ""
	If Type("oImposto:_Imposto")<>"U"
		If Type("oImposto:_Imposto:_ICMS")<>"U"
			For nY := 1 To Len(aSitTrib)
				nPrivate2 := nY
		 		If Type("oImposto:_Imposto:_ICMS:_ICMS"+aSitTrib[nPrivate2])<>"U"
		 			If Type("oImposto:_Imposto:_ICMS:_ICMS"+aSitTrib[nPrivate2]+":_VBC:TEXT")<>"U"
			 			nBaseICM := Val(&("oImposto:_Imposto:_ICMS:_ICMS"+aSitTrib[nY]+":_VBC:TEXT"))
			 			nValICM  := Val(&("oImposto:_Imposto:_ICMS:_ICMS"+aSitTrib[nY]+":_vICMS:TEXT"))
			 			nPICM    := Val(&("oImposto:_Imposto:_ICMS:_ICMS"+aSitTrib[nY]+":_PICMS:TEXT"))
			 		EndIf
			 		cSitTrib := &("oImposto:_Imposto:_ICMS:_ICMS"+aSitTrib[nY]+":_ORIG:TEXT")
			 		cSitTrib += &("oImposto:_Imposto:_ICMS:_ICMS"+aSitTrib[nY]+":_CST:TEXT")
		 		EndIf
			Next nY
		EndIf
		If Type("oImposto:_Imposto:_IPI")<>"U"
			If Type("oImposto:_Imposto:_IPI:_IPITrib:_vIPI:TEXT")<>"U"
				nValIPI := Val(oImposto:_Imposto:_IPI:_IPITrib:_vIPI:TEXT)
			EndIf
			If Type("oImposto:_Imposto:_IPI:_IPITrib:_pIPI:TEXT")<>"U"
				nPIPI   := Val(oImposto:_Imposto:_IPI:_IPITrib:_pIPI:TEXT)
			EndIf
		EndIf
	EndIf
	aadd(aItens,{oDet[nX]:_Prod:_cProd:TEXT,;
					SubStr(oDet[nX]:_Prod:_xProd:TEXT,1,25),;
					IIF(Type("oDet[nPrivate]:_Prod:_NCM")=="U","",oDet[nX]:_Prod:_NCM:TEXT),;
					cSitTrib,;
					oDet[nX]:_Prod:_CFOP:TEXT,;
					oDet[nX]:_Prod:_utrib:TEXT,;
					AllTrim(TransForm(nQtd,TM(nQtd,TamSX3("D2_QUANT")[1],TamSX3("D2_QUANT")[2]))),;
					AllTrim(TransForm(nVUnit,TM(nVUnit,TamSX3("D2_PRCVEN")[1],4))),;
					AllTrim(TransForm(nVTotal,TM(nVTotal,TamSX3("D2_TOTAL")[1],TamSX3("D2_TOTAL")[2]))),;
					AllTrim(TransForm(nBaseICM,TM(nBaseICM,TamSX3("D2_BASEICM")[1],TamSX3("D2_BASEICM")[2]))),;
					AllTrim(TransForm(nValICM,TM(nValICM,TamSX3("D2_VALICM")[1],TamSX3("D2_VALICM")[2]))),;
					AllTrim(TransForm(nValIPI,TM(nValIPI,TamSX3("D2_VALIPI")[1],TamSX3("D2_BASEIPI")[2]))),;
					AllTrim(TransForm(nPICM,"@r 99%")),;
					AllTrim(TransForm(nPIPI,"@r 99%"))})
	cAux := AllTrim(SubStr(oDet[nX]:_Prod:_xProd:TEXT,26))
	While !Empty(cAux)
		aadd(aItens,{"",;
					SubStr(cAux,1,25),;
					"",;
					"",;
					"",;
					"",;
					"",;
					"",;
					"",;
					"",;
					"",;
					"",;
					"",;
					""})
		cAux := SubStr(cAux,26)
	EndDo
Next nX
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//쿜uadro ISSQN                                                            �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
aISSQN := {"","","",""}
If Type("oEmitente:_IM:TEXT")<>"U"
	aISSQN[1] := oEmitente:_IM:TEXT
EndIf  
If Type("oTotal:_ISSQNtot")<>"U"
	aISSQN[2] := Transform(Val(oTotal:_ISSQNtot:_vServ:TEXT),"@ze 999,999,999.99")	
	aISSQN[3] := Transform(Val(oTotal:_ISSQNtot:_vBC:TEXT),"@ze 999,999,999.99")	
	aISSQN[4] := Transform(Val(oTotal:_ISSQNtot:_vISS:TEXT),"@ze 999,999,999.99")	
EndIf

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//쿜uadro de informacoes complementares                                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
aMensagem := {}
If Type("oNF:_InfNfe:_infAdic:_infAdFisco:TEXT")<>"U"
	cAux := oNF:_InfNfe:_infAdic:_infAdFisco:TEXT
	While !Empty(cAux)
		aadd(aMensagem,SubStr(cAux,1,MAXMENLIN))
		cAux := SubStr(cAux,MAXMENLIN+1)
	EndDo
EndIf
If Type("oNF:_InfNfe:_infAdic:_infCpl:TEXT")<>"U"
	cAux := oNF:_InfNfe:_infAdic:_InfCpl:TEXT
	While !Empty(cAux)
		aadd(aMensagem,SubStr(cAux,1,MAXMENLIN))
		cAux := SubStr(cAux,MAXMENLIN+1)
	EndDo
EndIf
If !Empty(cCodAutSef) .AND. oIdent:_tpEmis:TEXT<>"4"
	aadd(aMensagem,"Protocolo: "+cCodAutSef)
ElseIf !Empty(cCodAutSef) .And. oIdent:_tpEmis:TEXT=="4"
	aadd(aMensagem,"N�mero de Registro DPEC: "+cCodAutSef) 
EndIf
If (Type("oIdent:_tpEmis:TEXT")<>"U" .And. !oIdent:_tpEmis:TEXT$"1,4")
	aadd(aMensagem,"DANFE emitida em conting�ncia")
ElseIf (!Empty(cModalidade) .And. !cModalidade $ "1,4,5") .And. Empty(cCodAutSef) 
	aadd(aMensagem,"DANFE emitida em conting�ncia devido a problemas t�cnicos - ser� necess�ria a substitui豫o.")
ElseIf (!Empty(cModalidade) .And. cModalidade $ "5") 
	aadd(aMensagem,"DANFE impresso em conting�ncia")
	aadd(aMensagem,"DPEC regularmente recebido pela Receita Federal do Brasil.") 
EndIf
If Type("oIdent:_tpAmb:TEXT")<>"U" .And. oIdent:_tpAmb:TEXT=="2"
	aadd(aMensagem,"DANFE emitida no ambiente de homologa豫o - SEM VALOR FISCAL")
EndIf
//For nX := 1 to 20
//	aadd(amensagem,"esta mensagem � de testes para sabermos o quando � impresso nas mensagens da nota")
//Next nx

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//쿎alculo do numero de folhas                                             �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
nFolhas := 1
If Len(aItens)>MAXITEM
	nFolhas += Int((Len(aItens)-MAXITEM)/60)
	If Mod(Len(aItens)-MAXITEM,Len(aItens)-MAXITEMP2)>0
		nFolhas++
	EndIf
EndIf
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//쿔nicializacao do objeto grafico                                         �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
If oDanfe == Nil
	lPreview := .T.
	oDanfe 	:= TMSPrinter():New("DANFE - Documento Auxiliar da Nota Fiscal Eletr�nica")
	oDanfe:SetPortrait()
	oDanfe:Setup()
EndIf
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//쿔nicializacao da pagina do objeto grafico                               �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
oDanfe:StartPage()
oDanfe:SetPaperSize(Val(GetProfString(GetPrinterSession(),"PAPERSIZE","1",.T.)))
nHPage := oDanfe:nHorzRes()
nHPage *= (300/PixelX)
nHPage -= HMARGEM
nVPage := oDanfe:nVertRes() 
nVPage *= (300/PixelY)
nVPage -= VBOX

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//쿏efinicao do Box - Recibo de entrega                                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
aTamanho := ImpBox(0,0,0,nHPage-Char2Pix(oDanfe,Repl("X",22),oFont10N),;
	{	{"Recebemos de "+oEmitente:_xNome:Text+" os produtos constantes da nota fiscal indicada ao lado"},;
		{{"Data de recebimento"," "},{"Identifica豫o e assinatura do recebedor",PadR(" ",200)}}},;
	oDanfe)
	
aTamanho := ImpBox(0,nHPage-Char2Pix(oDanfe,Repl("X",20),oFont10N),0,nHPage,;
	{	{{PadC("NF-e",20),PadC("N. "+StrZero(Val(oIdent:_NNf:Text),9),20),PadC("S�RIE "+oIdent:_Serie:Text,20)}}},;
		oDanfe,2)

nPosV    := aTamanho[1]+(VBOX/2)
oDanfe:Line(nPosV,HMARGEM,nPosV,nHPage) 
nPosV    += (VBOX/2)
nPosV := DanfeCab(oDanfe,nPosV,oNFe,oIdent,oEmitente,@nFolha,nFolhas)
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//쿜uadro destinat�rio/remetente                                           �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
Do Case
	Case Type("oDestino:_CNPJ")=="O"
		cAux := TransForm(oDestino:_CNPJ:TEXT,"@r 99.999.999/9999-99")
	Case Type("oDestino:_CPF")=="O"
		cAux := TransForm(oDestino:_CPF:TEXT,"@r 999.999.999-99")
	OtherWise
		cAux := Space(14)
EndCase
aTamanho := ImpBox(nPosV,0,0,nHPage-Char2Pix(oDanfe,Repl("X",22),oFont08),;
	{	{{"Nome/Raz�o social",oDestino:_XNome:TEXT},{"CNPJ/CPF",cAux}},;
		{{"Endere�o",aDest[01]},{"Bairro/Distrito",aDest[02]},{"CEP",aDest[03]}},;
		{{"Municipio",aDest[05]},{"Fone/Fax",aDest[06]},{"UF",aDest[07]},{"Inscri�ao estadual",aDest[08]}}},;
	oDanfe,1,"DESTINAT핾IO/REMETENTE")
	
aTamanho := ImpBox(nPosV,nHPage-Char2Pix(oDanfe,Repl("X",20),oFont08),0,nHPage,;
	{	{{"Data de emiss�o",ConvDate(oIdent:_DEmi:TEXT)}},;
		{{"Data entrada/saida",ConvDate(aDest[4])}},;
		{{"Hora entrada/sa�da",aDest[09]}}},;
	oDanfe,1,"")
nPosV    := aTamanho[1]+VSPACE
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//쿜uadro fatura                                                           �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
aAux := {{{},{},{},{},{},{},{},{},{}}}
nY := 0
For nX := 1 To Len(aFaturas)
	nY++
	aadd(Atail(aAux)[nY],aFaturas[nX][1])
	nY++
	aadd(Atail(aAux)[nY],aFaturas[nX][2])
	nY++
	aadd(Atail(aAux)[nY],aFaturas[nX][3])
	If nY >= 9
		nY := 0
	EndIf
Next nX
aTamanho := ImpBox(nPosV,0,0,nHPage,aAux,oDanfe,1,"FATURA")
nPosV    := aTamanho[1]+VSPACE
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//쿎alculo do imposto                                                      �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
aTamanho := ImpBox(nPosV,0,0,nHPage,;
	{	{{"Base de calculo do ICMS",aTotais[01]},{"Valor do ICMS",aTotais[02]},{"Base de calculo do ICMS substitui豫o",aTotais[03]},{"Valor do ICMS substitui豫o",aTotais[04]},{"Valor total dos produtos",aTotais[05]}},;
		{{"Valor do Frete",aTotais[06]},{"Valor do Seguro",aTotais[07]},{"Desconto",aTotais[08]},{"Outras despesas acess�rias",aTotais[09]},{"Valor do IPI",aTotais[10]},{"Valor Total da Nota",aTotais[11]}}},;
	oDanfe,1,"CALCULO DO IMPOSTO")
nPosV    := aTamanho[1]+VSPACE
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//쿟ransportador/Volumes transportados                                     �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
aTamanho := ImpBox(nPosV,0,0,nHPage,;
	{	{{"Raz�o Social",aTransp[01]},{"Frete por Conta","1-emitente/2-Destinat�rio [" + aTransp[02] + "]"},{"Codigo ANTT",aTransp[03]},{"Placa do ve�culo",aTransp[04]},{"UF",aTransp[05]},{"CNPJ/CPF",aTransp[06]}},;
		{{"Endere�o",aTransp[07]},{"Municipio",aTransp[08]},{"UF",aTransp[09]},{"Inscri豫o Estadual",aTransp[10]}},;
		{{"Quantidade",aTransp[11]},{"Especie",aTransp[12]},{"Marca",aTransp[13]},{"Numera豫o",aTransp[14]},{"Peso Bruto",aTransp[15]},{"Peso Liquido",aTransp[16]}}},;
	oDanfe,1,"TRANSPORTADOR/VOLUMES TRANSPORTADOS")
nPosV    := aTamanho[1]+VSPACE
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//쿏ados do produto ou servico                                             �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
aAux := {{{"Cod.Prod."},{"Descri豫o do Produto/Servi�o"},{"NCM/SH"},{"CST"},{"CFOP"},{"UN"},{"Quantidade"},{"V.Unit�rio"},{"V.Total"},;
		{"BC.ICMS"},{"V.ICMS"},{"V.IPI"},{"A.ICM"},{"A.IPI"}}}
nY := 0

For nX := 1 To MIN(MAXITEM,Len(aItens))
	nY++
	aadd(Atail(aAux)[nY],aItens[nX][01])
	nY++
	aadd(Atail(aAux)[nY],aItens[nX][02])
	nY++
	aadd(Atail(aAux)[nY],aItens[nX][03])
	nY++
	aadd(Atail(aAux)[nY],aItens[nX][04])
	nY++
	aadd(Atail(aAux)[nY],aItens[nX][05])
	nY++
	aadd(Atail(aAux)[nY],aItens[nX][06])
	nY++
	aadd(Atail(aAux)[nY],aItens[nX][07])
	nY++
	aadd(Atail(aAux)[nY],aItens[nX][08])
	nY++
	aadd(Atail(aAux)[nY],aItens[nX][09])
	nY++
	aadd(Atail(aAux)[nY],aItens[nX][10])
	nY++
	aadd(Atail(aAux)[nY],aItens[nX][11])
	nY++
	aadd(Atail(aAux)[nY],aItens[nX][12])
	nY++
	aadd(Atail(aAux)[nY],aItens[nX][13])
	nY++
	aadd(Atail(aAux)[nY],aItens[nX][14])	
	If nY >= 14
		nY := 0
	EndIf
Next nX
For nX := MIN(MAXITEM,Len(aItens)) To MAXITEM
	nY++
	aadd(Atail(aAux)[nY],"")
	nY++
	aadd(Atail(aAux)[nY],"")
	nY++
	aadd(Atail(aAux)[nY],"")
	nY++
	aadd(Atail(aAux)[nY],"")
	nY++
	aadd(Atail(aAux)[nY],"")
	nY++
	aadd(Atail(aAux)[nY],"")
	nY++
	aadd(Atail(aAux)[nY],"")
	nY++
	aadd(Atail(aAux)[nY],"")
	nY++
	aadd(Atail(aAux)[nY],"")
	nY++
	aadd(Atail(aAux)[nY],"")
	nY++
	aadd(Atail(aAux)[nY],"")
	nY++
	aadd(Atail(aAux)[nY],"")
	nY++
	aadd(Atail(aAux)[nY],"")
	nY++
	aadd(Atail(aAux)[nY],"")
	If nY >= 14
		nY := 0
	EndIf	
Next nX

aTamanho := ImpBox(nPosV,0,0,nHPage,;
	aAux,;
	oDanfe,3,"DADOS DO PRODUTO / SERVI�O",{"L","L","L","L","L","L","R","R","R","R","R","R","R","R"},2)
nPosV    := aTamanho[1]+VSPACE
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//쿎alculo do ISSQN                                                        �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
aTamanho := ImpBox(nPosV,0,0,nHPage,;
	{	{{"Inscri豫o Municipal",aISSQN[1]},{"Valor Total dos Servi�os",aISSQN[2]},{"Base de C�lculo do ISSQN",aISSQN[3]},{"Valor do ISSQN",aISSQN[4]}}},;
	oDanfe,1,"C�LCULO DO ISSQN")
nPosV    := aTamanho[1]+VSPACE
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//쿏ados Adicionais                                                        �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
nPosVOld := nPosV+(VSPACE/2)
nPosV += VBOX*4
nPosHOld := HMARGEM
nPosH    := nHPage
	oDanfe:Say(nPosVOld,nPosHold,"DADOS ADICIONAIS",oFont11N)
nPosV    += Char2PixV(oDanfe,"X",oFont11N)*2
nPosVOld += Char2PixV(oDanfe,"X",oFont11N)*2
	oDanfe:Box(nPosVOld,nPosHOld,nVPage,nPosH)
	nAuxH := nPosHOld+010
	oDanfe:Say(nPosVOld+Char2PixV(oDanfe,"X",oFont11N),nAuxH,"Informa寤es complementares",oFont11N)	
	nAuxH := (nHPage/2)+10
	oDanfe:Box(nPosVOld,nAuxH-005,nVPage,nPosH)
	oDanfe:Say(nPosVOld+Char2PixV(oDanfe,"X",oFont07N),nAuxH,"Reservado ao fisco",oFont11N)	
	nAuxH := nPosHOld+010
	nPosV    += Char2PixV(oDanfe,"X",oFont11N)*2
	nPosVOld += Char2PixV(oDanfe,"X",oFont11N)*2
	For nX := 1 To Len(aMensagem)		
		nPosVOld += Char2PixV(oDanfe,"X",oFont12)*2
		oDanfe:Say(nPosVOld,nAuxH,aMensagem[nX],oFont12)
	Next nX
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//쿑inalizacao da pagina do objeto grafico                                 �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
oDanfe:EndPage()
nItem := MAXITEM+1
While nItem <= Len(aItens)
	DanfeCpl(oDanfe,aItens,@nItem,oNFe,oIdent,oEmitente,@nFolha,nFolhas)  
EndDo
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//쿑inaliza a Impress�o                                                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸 
If lPreview
	oDanfe:Preview()
EndIf
Return(.T.)

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//쿏efinicao do Cabecalho do documento                                     �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
// Substituido pelo assistente de conversao do AP6 IDE em 04/05/09 ==> Static Function DanfeCab(oDanfe,nPosV,oNFe,oIdent,oEmitente,nFolha,nFolhas)
Static Static Function DanfeCab(oDanfe,nPosV,oNFe,oIdent,oEmitente,nFolha,nFolhas)()

Local aTamanho   := {}
Local cLogo      := FisxLogo("1")
Local nHPage     := 0
Local nVPage     := 0 
Local nPosVOld   := 0
Local nPosH      := 0
Local nPosHOld   := 0
Local nAuxV      := 0
Local nAuxH      := 0

nHPage := oDanfe:nHorzRes()
nHPage *= (300/PixelX)
nHPage -= HMARGEM
nVPage := oDanfe:nVertRes() 
nVPage *= (300/PixelY)
nVPage -= VBOX
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//쿜uadro 1                                                                �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
nPosVOld := nPosV
nPosV    := nPosV + 380
nPosHOld := HMARGEM
nPosH    := 910
	//oDanfe:Box(nPosVOld,nPosHOld,nPosV,nPosH)
	oDanfe:SayBitmap(nPosVOld+5,nPosHOld+5,cLogo,400,090)	
	nAuxV := nPosVOld + 120 + SAYVSPACE
	nAuxH := nPosHOld+SAYHSPACE
	oDanfe:Say(nAuxV,nAuxH,oEmitente:_xNome:Text,oFont10N)
	nAuxV += Char2PixV(oDanfe,"X",oFont10N)+SAYVSPACE
	oDanfe:Say(nAuxV,nAuxH,oEmitente:_EnderEmit:_xLgr:Text+", "+oEmitente:_EnderEmit:_Nro:Text,oFont10)
	nAuxV += Char2PixV(oDanfe,"X",oFont10N)+SAYVSPACE
	oDanfe:Say(nAuxV,nAuxH,oEmitente:_EnderEmit:_xBairro:Text+" Cep:"+TransForm(IIF(Type("oEmitente:_EnderEmit:_Cep")=="U","",oEmitente:_EnderEmit:_Cep:Text),"@r 99999-999"),oFont10)
	nAuxV += Char2PixV(oDanfe,"X",oFont10N)+SAYVSPACE
	oDanfe:Say(nAuxV,nAuxH,oEmitente:_EnderEmit:_xMun:Text+"/"+oEmitente:_EnderEmit:_UF:Text,oFont10)
	nAuxV += Char2PixV(oDanfe,"X",oFont10N)+SAYVSPACE
	oDanfe:Say(nAuxV,nAuxH,"Fone: "+IIf(Type("oEmitente:_EnderEmit:_Fone")=="U","",oEmitente:_EnderEmit:_Fone:Text),oFont10)
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//쿜uadro 2                                                                �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
nPosHOld := nPosH+HSPACE
nPosH    := nPosHOld + 360
	nAuxV := nPosVOld
	oDanfe:Say(nAuxV,nPosHOld,"DANFE",oFont18N)
	nAuxV += Char2PixV(oDanfe,"X",oFont18N) + (SAYVSPACE*3)
	nAuxH := nPosHOld
	oDanfe:Say(nAuxV,nAuxH,"Documento Auxiliar da",oFont08)
	nAuxV += Char2PixV(oDanfe,"X",oFont08) + SAYVSPACE
	oDanfe:Say(nAuxV,nAuxH,"Nota Fiscal Eletr�nica",oFont08)
	nAuxV += Char2PixV(oDanfe,"X",oFont08) + SAYVSPACE
	
	oDanfe:Say(nAuxV,nAuxH,IIf(oIdent:_TpNf:Text=="1","SA�DA","ENTRADA"),oFont18N)
	nAuxV += Char2PixV(oDanfe,"X",oFont18N) + (SAYVSPACE*3)
	oDanfe:Say(nAuxV,nAuxH,"N. "+StrZero(Val(oIdent:_NNf:Text),9),oFont11)
	nAuxV += Char2PixV(oDanfe,"X",oFont11) + SAYVSPACE
	oDanfe:Say(nAuxV,nAuxH,"S�rie "+oIdent:_Serie:Text,oFont11)
	nAuxV += Char2PixV(oDanfe,"X",oFont11) + SAYVSPACE
	oDanfe:Say(nAuxV,nAuxH,"Folha "+StrZero(nFolha,2)+"/"+StrZero(nFolhas,2),oFont11)
	nAuxV += Char2PixV(oDanfe,"X",oFont11) + SAYVSPACE
nPosHOld := nPosH+HSPACE
nPosH    := nHPage
	//oDanfe:Box(nPosVOld,nPosHOld,nPosV,nPosH) 
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//쿎odigo de barra                                                         �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
If nFolha == 1
	MSBAR3("CODE128",2.4*(300/PixelY),12*(300/PixelX),SubStr(oNF:_InfNfe:_ID:Text,4),oDanfe,/*lCheck*/,/*Color*/,/*lHorz*/,.02960,2.2,/*lBanner*/,/*cFont*/,"C",.F.)
Else
	MSBAR3("CODE128",0.6*(300/PixelY),12*(300/PixelX),SubStr(oNF:_InfNfe:_ID:Text,4),oDanfe,/*lCheck*/,/*Color*/,/*lHorz*/,.02960,2.2,/*lBanner*/,/*cFont*/,"C",.F.)
EndIf
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//쿜uadro 4                                                                �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
nPosV += VSPACE
aTamanho := ImpBox(nPosV,0,0,nHPage,;
	{	{	{"Nat.da opera豫o",oIdent:_NATOP:TEXT}},;
		{	{"Inscricao estadual",IIf(Type("oEmitente:_IE:TEXT")<>"U",oEmitente:_IE:TEXT,"")},;
			{"Insc.Estadual do Subst.Trib.",IIf(Type("oEmitente:_IEST:TEXT")<>"U",oEmitente:_IEST:TEXT,"")},;
			{"CNPJ",TransForm(oEmitente:_CNPJ:TEXT,IIf(Len(oEmitente:_CNPJ:TEXT)<>14,"@r 999.999.999-99","@r 99.999.999/9999-99"))},;
			{"Chave de acesso da NF-e - Consulta no site http://www.nfe.fazenda.gov.br",TransForm(SubStr(oNF:_InfNfe:_ID:Text,4),"@r 99.9999.99.999.999/9999-99-99-999-999.999.999-999.999.999-9")}}},;
	oDanfe)
	
nPosV := aTamanho[1]

nFolha++      
Return(nPosV)

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//쿔mpressao do Complemento da NFe                                         �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸 
// Substituido pelo assistente de conversao do AP6 IDE em 04/05/09 ==> Static Function DanfeCpl(oDanfe,aItens,nItem,oNFe,oIdent,oEmitente,nFolha,nFolhas)
Static Static Function DanfeCpl(oDanfe,aItens,nItem,oNFe,oIdent,oEmitente,nFolha,nFolhas)()

Local nX         := 0
Local nY         := 0
Local nHPage     := 0 
Local nVPage     := 0 
Local nPosV      := VMARGEM
Local aAux       := {}
Local nItemOld	 := nItem

oDanfe:StartPage()
nPosV := DanfeCab(oDanfe,nPosV,oNFe,oIdent,oEmitente,@nFolha,nFolhas)
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//쿏ados do produto ou servico                                             �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
nHPage := oDanfe:nHorzRes()
nHPage *= (300/PixelX)
nHPage -= HMARGEM
nVPage := oDanfe:nVertRes() 
nVPage *= (300/PixelY)
nVPage -= VBOX
nPosV    += (VBOX/2)
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//쿏ados do produto ou servico                                             �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
aAux := {{{"Cod.Prod."},{"Descri豫o do Produto/Servi�o"},{"NCM/SH"},{"CST"},{"CFOP"},{"UN"},{"Quantidade"},{"V.Unit�rio"},{"V.Total"},;
		{"BC.ICMS"},{"V.ICMS"},{"V.IPI"},{"A.ICM"},{"A.IPI"}}}
nY := 0 

For nX := nItem To MIN(MAXITEMP2+(nItemOld-1),Len(aItens))
	nY++
	aadd(Atail(aAux)[nY],aItens[nX][01])
	nY++
	aadd(Atail(aAux)[nY],aItens[nX][02])
	nY++
	aadd(Atail(aAux)[nY],aItens[nX][03])
	nY++
	aadd(Atail(aAux)[nY],aItens[nX][04])
	nY++
	aadd(Atail(aAux)[nY],aItens[nX][05])
	nY++
	aadd(Atail(aAux)[nY],aItens[nX][06])
	nY++
	aadd(Atail(aAux)[nY],aItens[nX][07])
	nY++
	aadd(Atail(aAux)[nY],aItens[nX][08])
	nY++
	aadd(Atail(aAux)[nY],aItens[nX][09])
	nY++
	aadd(Atail(aAux)[nY],aItens[nX][10])
	nY++
	aadd(Atail(aAux)[nY],aItens[nX][11])
	nY++
	aadd(Atail(aAux)[nY],aItens[nX][12])
	nY++
	aadd(Atail(aAux)[nY],aItens[nX][13])
	nY++
	aadd(Atail(aAux)[nY],aItens[nX][14])	
	If nY >= 14
		nY := 0
	EndIf
	nItem++
Next nX

ImpBox(nPosV,0,nVPage,nHPage,;
	aAux,;
	oDanfe,3,"DADOS DO PRODUTO / SERVI�O",{"L","L","L","L","L","L","R","R","R","R","R","R","R","R"},2)
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//쿑inalizacao da pagina do objeto grafico                                 �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
oDanfe:EndPage()
Return(.T.)

// Substituido pelo assistente de conversao do AP6 IDE em 04/05/09 ==> Static Function Char2Pix(oDanfe,cTexto,oFont)
Static Static Function Char2Pix(oDanfe,cTexto,oFont)()
Local nX := 0
DEFAULT aUltChar2pix := {}
nX := aScan(aUltChar2pix,{|x| x[1] == cTexto .And. x[2] == oFont})

If nX == 0
	aadd(aUltChar2pix,{cTexto,oFont,oDanfe:GetTextWidht(cTexto,oFont)*(300/PixelX)})
	nX := Len(aUltChar2pix)
EndIf

Return(aUltChar2pix[nX][3])

// Substituido pelo assistente de conversao do AP6 IDE em 04/05/09 ==> Static Function Char2PixV(oDanfe,cChar,oFont)
Static Static Function Char2PixV(oDanfe,cChar,oFont)()
Local nX := 0
DEFAULT aUltVChar2pix := {}

cChar := SubStr(cChar,1,1)
nX := aScan(aUltVChar2pix,{|x| x[1] == cChar .And. x[2] == oFont})
If nX == 0
	aadd(aUltVChar2pix,{cChar,oFont,oDanfe:GetTextWidht(cChar,oFont)*(300/PixelY)})
	nX := Len(aUltVChar2pix)
EndIf

Return(aUltVChar2pix[nX][3])


// Substituido pelo assistente de conversao do AP6 IDE em 04/05/09 ==> Static Function GetXML(cIdEnt,aIdNFe,cModalidade)
Static Static Function GetXML(cIdEnt,aIdNFe,cModalidade)()

Local cURL       := PadR(GetNewPar("MV_SPEDURL","http://localhost:8080/sped"),250)
Local oWS
Local cRetorno   := ""
Local cProtocolo := ""
Local nX         := 0
Local nY         := 0
Local aRetorno   := {}
Local aResposta  := {}
Local aFalta     := {}
Local aExecute   := {}
Local cDHRecbto  := ""
Local cDtHrRec   := ""
Local cDtHrRec1	 := ""
Local nDtHrRec1  := 0

Private oDHRecbto  

If Empty(cModalidade)
	oWS := WsSpedCfgNFe():New()
	oWS:cUSERTOKEN := "TOTVS"
	oWS:cID_ENT    := cIdEnt
	oWS:nModalidade:= 0
	oWS:_URL       := AllTrim(cURL)+"/SPEDCFGNFe.apw"
	If oWS:CFGModalidade()
		cModalidade    := SubStr(oWS:cCfgModalidadeResult,1,1)
	Else
		cModalidade    := ""
	EndIf
EndIf
oWS:= WSNFeSBRA():New()
oWS:cUSERTOKEN        := "TOTVS"
oWS:cID_ENT           := cIdEnt
oWS:oWSNFEID          := NFESBRA_NFES2():New()
oWS:oWSNFEID:oWSNotas := NFESBRA_ARRAYOFNFESID2():New()
For nX := 1 To Len(aIdNFe)
	aadd(aRetorno,{"","",aIdNfe[nX][4]+aIdNfe[nX][5]})
	aadd(oWS:oWSNFEID:oWSNotas:oWSNFESID2,NFESBRA_NFESID2():New())
	Atail(oWS:oWSNFEID:oWSNotas:oWSNFESID2):cID := aIdNfe[nX][4]+aIdNfe[nX][5]
Next nX
oWS:nDIASPARAEXCLUSAO := 0
oWS:_URL := AllTrim(cURL)+"/NFeSBRA.apw"
IF cModalidade <> "5"
	If oWS:RETORNANOTAS()
		If Len(oWs:oWsRetornaNotasResult:OWSNOTAS:OWSNFES3) > 0
			For nX := 1 To Len(oWs:oWsRetornaNotasResult:OWSNOTAS:OWSNFES3)
				cRetorno        := oWs:oWsRetornaNotasResult:OWSNOTAS:OWSNFES3[nX]:oWSNFE:CXML
				cProtocolo      := oWs:oWsRetornaNotasResult:OWSNOTAS:OWSNFES3[nX]:oWSNFE:CPROTOCOLO
					cDHRecbto  		:= oWs:oWsRetornaNotasResult:OWSNOTAS:OWSNFES3[nX]:oWSNFE:CXMLPROT
				//Tratamento para gravar a hora da transmissao da NFe
				If !Empty(cProtocolo)
					oDHRecbto		:= XmlParser(cDHRecbto,"","","")
				    cDtHrRec		:= oDHRecbto:_ProtNFE:_INFPROT:_DHRECBTO:TEXT
				    nDtHrRec1		:= RAT("T",cDtHrRec)
		
					If nDtHrRec1 <> 0
						cDtHrRec1 := SubStr(cDtHrRec,nDtHrRec1+1)
					EndIf
		    		dbSelectArea("SF2")
		    		dbSetOrder(1)
		    		If MsSeek(xFilial("SF2")+aIdNFe[nX][5]+aIdNFe[nX][4]+aIdNFe[nX][6]+aIdNFe[nX][7])
						RecLock("SF2")
		    			SF2->F2_HORA := cDtHrRec1
		    			MsUnlock()
		    		EndIf            
				EndIf
				nY := aScan(aIdNfe,{|x| x[4]+x[5] == SubStr(oWs:oWsRetornaNotasResult:OWSNOTAS:OWSNFES3[nX]:CID,1,Len(x[4]+x[5]))})		
				If nY > 0
					aRetorno[nY][1] := cProtocolo
					aRetorno[nY][2] := cRetorno	
		
					aadd(aResposta,aIdNfe[nY])
				EndIf
			Next nX
			For nX := 1 To Len(aIdNfe)
				If aScan(aResposta,{|x| x[4] == aIdNfe[nX,04] .And. x[5] == aIdNfe[nX,05] })==0
					aadd(aFalta,aIdNfe[nX])
				EndIf
			Next nX	
			If Len(aFalta)>0
				aExecute := GetXML(cIdEnt,aFalta,@cModalidade)
			Else
				aExecute := {}
			EndIf
			For nX := 1 To Len(aExecute)
				nY := aScan(aRetorno,{|x| x[3] == aExecute[nX][03]})
				If nY == 0
					aadd(aRetorno,{aExecute[nX][01],aExecute[nX][02],aExecute[nX][03]})
				Else
					aRetorno[nY][01] := aExecute[nX][01]
					aRetorno[nY][02] := aExecute[nX][02]
				EndIf
			Next nX
		EndIf
	EndIf
Else
	If oWS:RETORNANOTASNX()
		If Len(oWs:oWSRETORNANOTASNXRESULT:OWSNOTAS:OWSNFES5) > 0
			For nX := 1 To Len(oWs:oWSRETORNANOTASNXRESULT:OWSNOTAS:OWSNFES5)
				cRetorno        := oWs:oWSRETORNANOTASNXRESULT:OWSNOTAS:OWSNFES5[nX]:oWSNFE:CXML
				cProtocolo      := oWs:oWSRETORNANOTASNXRESULT:OWSNOTAS:OWSNFES5[nX]:oWSNFE:CPROTOCOLO
				cDHRecbto  		:= oWs:oWSRETORNANOTASNXRESULT:OWSNOTAS:OWSNFES5[nX]:oWSNFE:CXMLPROT
				
				nY := aScan(aIdNfe,{|x| x[4]+x[5] == SubStr(oWs:oWSRETORNANOTASNXRESULT:OWSNOTAS:OWSNFES5[nX]:CID,1,Len(x[4]+x[5]))})		
				If nY > 0
					aRetorno[nY][1] := cProtocolo
					aRetorno[nY][2] := cRetorno	
		
					aadd(aResposta,aIdNfe[nY])
				EndIf
			Next nX
			For nX := 1 To Len(aIdNfe)
				If aScan(aResposta,{|x| x[4] == aIdNfe[nX,04] .And. x[5] == aIdNfe[nX,05] })==0
					aadd(aFalta,aIdNfe[nX])
				EndIf
			Next nX	
			If Len(aFalta)>0
				aExecute := GetXML(cIdEnt,aFalta,@cModalidade)
			Else
				aExecute := {}
			EndIf
			For nX := 1 To Len(aExecute)
				nY := aScan(aRetorno,{|x| x[3] == aExecute[nX][03]})
				If nY == 0
					aadd(aRetorno,{aExecute[nX][01],aExecute[nX][02],aExecute[nX][03]})
				Else
					aRetorno[nY][01] := aExecute[nX][01]
					aRetorno[nY][02] := aExecute[nX][02]
				EndIf
			Next nX
		EndIf
	EndIf
EndIf
Return(aRetorno)

// Substituido pelo assistente de conversao do AP6 IDE em 04/05/09 ==> Static Function ConvDate(cData)
Static Static Function ConvDate(cData)()

Local dData
cData  := StrTran(cData,"-","")
dData  := Stod(cData)
Return PadR(StrZero(Day(dData),2)+ "/" + StrZero(Month(dData),2)+ "/" + StrZero(Year(dData),4),15)

// Substituido pelo assistente de conversao do AP6 IDE em 04/05/09 ==> Static Function ImpBox(nPosVIni,nPosHIni,nPosVFim,nPosHFim,aImp,oDanfe,nTpFont,cTitulo,aAlign,nColAjuste)
Static Static Function ImpBox(nPosVIni,nPosHIni,nPosVFim,nPosHFim,aImp,oDanfe,nTpFont,cTitulo,aAlign,nColAjuste)()

Local nX      := 0
Local nY      := 0
Local nZ      := 0
Local nMaxnX  := Len(aImp)
Local nMaxnY  := 0
Local nMaxnZ  := 0
Local nPosV1  := nPosVIni
Local nPosV2  := nPosVIni
Local nPosH1  := nPosHIni
Local nPosH2  := nPosHIni
Local nAuxH   := 0
Local nAuxV   := 0
Local nTam    := 0
Local nDif    := 0
Local cMaxTam := ""
Local aFont   := {{oFont07N,oFont08},{oFont10N,oFont11},{oFont11N,oFont12}}
Local aTamanho:= {}
Local lTitulo := .T.
Local lTemTit := .F.

DEFAULT nTpFont    := 1
DEFAULT aAlign     := {}
DEFAULT nColAjuste := 0

For nX := 1 To nMaxnX

	nMaxnY  := Len(aImp[nX])
	nPosV1  := IIF(nPosV1 == 0 , VMARGEM , nPosV1 )
	nPosV2  := nPosV1 + VBOX	
	aTamanho:= {}	
	For nY := 1 To nMaxnY
		If Len(aAlign) < nY
			aadd(aAlign,"L")
		EndIf
	Next nY
	
	For nY := 1 To nMaxnY	
		If Valtype(aImp[nX][nY]) == "A"
			nMaxnZ := Len(aImp[nX][nY])
			cMaxTam:= ""
			For nZ := 1 To nMaxnZ
				If Len(cMaxTam)<Len(AllTrim(aImp[nX][nY][nZ]))
					cMaxTam := AllTrim(aImp[nX][nY][nZ])
				EndIf
			Next nZ
			aadd(aTamanho,(Char2Pix(oDanfe,cMaxTam,aFont[nTpFont][2])+HSPACE+IIF(nZ>1,SAYVSPACE*nTpFont,-1*SAYVSPACE)))
		Else
			aadd(aTamanho,(Char2Pix(oDanfe,aImp[nX][nY],aFont[nTpFont][2])+HSPACE))
		EndIf
    Next nY
    nTam := 0
    For nY := 1 To Len(aTamanho)
		nTam += aTamanho[nY]
	Next nY	
	If nTam <= (nPosHFim - nPosHIni)
		If nColAjuste == 0
			nDif := Int(((nPosHFim - nPosHIni - IIF(nPosHIni == 0 , HMARGEM , nPosHIni )) - nTam)/nMaxnY)
		    For nY := 1 To Len(aTamanho)
				aTamanho[nY] += nDif
			Next nY
		Else
			nDif := Int(((nPosHFim - nPosHIni - IIF(nPosHIni == 0 , HMARGEM , nPosHIni )) - nTam))
			aTamanho[nColAjuste] += nDif
		EndIf
	EndIf
	
	For nY := 1 To nMaxnY
		nPosH1 := IIF(nPosH1 == 0 , HMARGEM , nPosH1 )
		If cTitulo <> Nil .And. lTitulo
			lTitulo := .F.
			lTemTit := .T.
			oDanfe:Say(nPosV1,nPosH1,cTitulo,aFont[nTpFont][1])	
			nPosV1 += Char2PixV(oDanfe,"X",aFont[nTpFont][1])+SAYVSPACE
			nPosV2 += Char2PixV(oDanfe,"X",aFont[nTpFont][1])+SAYVSPACE
		EndIf		
		If Valtype(aImp[nX][nY]) == "A"

			nMaxnZ := Len(aImp[nX][nY])
			If nY == nMaxnY
				nPosH2 := nPosHFim
				If nMaxnY > 1
					nPosH1 := Max(nPosH1,nPosHFim-aTamanho[nY])
				EndIf
			Else
				nPosH2 := Min(nPosHFim,nPosH1+aTamanho[nY])
			EndIf

			If nMaxnZ >= 2 .And. nY == 1
				If nPosVFim <> 0
					nPosV2 := nPosVFim
				Else
					nAuxV := 0
					For nZ := 1 To nMaxnZ
						nAuxV += Char2PixV(oDanfe,"X",aFont[nTpFont][IIf(nZ==1,1,2)])+IIF(nZ>1,SAYVSPACE*nTpFont,-1*SAYVSPACE)
					Next nZ
					nAuxV := Int(nAuxV/(VBOX + VSPACE))
					nPosV2 += (VBOX + VSPACE)*nAuxV
				EndIf
			EndIf
			oDanfe:Box(nPosV1,nPosH1,nPosV2,nPosHFim)
			If aAlign[nY] == "R"
				nAuxH := nPosH2 - HSPACE
			Else
				nAuxH := nPosH1 + SAYHSPACE
			EndIf
			nAuxV := nPosV1
			For nZ := 1 To nMaxnZ									
				nAuxV += Char2PixV(oDanfe,"X",aFont[nTpFont][IIf(nZ==1,1,2)])+IIF(nZ>1,SAYVSPACE*nTpFont,-1*SAYVSPACE)
				If aAlign[nY] == "R"
					oDanfe:Say(nAuxV,nAuxH-Char2Pix(oDanfe,aImp[nX][nY][nZ],aFont[nTpFont][2]),aImp[nX][nY][nZ],aFont[nTpFont][IIf(nZ==1,1,2)])
				Else
					oDanfe:Say(nAuxV,nAuxH,aImp[nX][nY][nZ],aFont[nTpFont][IIf(nZ==1,1,2)])
				EndIf		
			Next nZ
			nPosH1 := nPosH2
		Else
			If nY == nMaxnY
				nPosH2 := nPosHFim
			Else
				nPosH2 := Min(nPosHFim,aTamanho[nY])
			EndIf
			
			oDanfe:Box(nPosV1,nPosH1,nPosV2,nPosHFim)
			If aAlign[nY] == "R"
				nAuxH := nPosH2 - Char2Pix(oDanfe,aImp[nX][nY],aFont[nTpFont][2]) - HSPACE
			Else
				nAuxH := nPosH1 + SAYHSPACE
			EndIf
			nAuxV := nPosV1+Char2PixV(oDanfe,aImp[nX][nY],aFont[nTpFont][2])
			oDanfe:Say(nAuxV,nAuxH,aImp[nX][nY],aFont[nTpFont][2])
			nPosH1 := nPosH2
		EndIf
    Next nY
    nPosV1 := nPosV2 + IIF(lTemTit,0,VSPACE)
    nPosV2 := 0
    nPosH1 := nPosHIni
    nPosH2 := 0
Next nX

Return({nPosV1,nPosH1})


