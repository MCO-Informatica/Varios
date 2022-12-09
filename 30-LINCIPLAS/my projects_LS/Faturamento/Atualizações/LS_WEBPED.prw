#INCLUDE "rwmake.ch"
#include "Fileio.ch"
#include "sigawin.ch"
#Include "Protheus.ch"
#INCLUDE "TBICONN.CH"
#Include "TOPCONN.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ WEBPED   ºAutores³ Rodrigo Alexandre  º Data ³  23/07/12   º±±
±±º          ³          º	 							     º 		³  	  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina de geração dos pedidos de compra / venda            º±±
±±º          ³ WebSupply                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Laselva                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±

ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function LS_WEBPED()

Local _cDir	   	:= "\WebSupply\"
Local _aFiles	:= {} 	// Arquivos oriundos do WebSupply
Local _cLinha	:= ''
Local _C7_NUM
Local _cNroPedWS
Local _cEnter 	:= chr(13) + chr(10)
_cTable			:= ""
lMSErroAuto		:= .f.
_cHtEnd			:= '</html>'

_cPVOK := _cPVNOK := _cPCOK := _cPCNOK := ''

Do While .T.
	
	aDir(_cDir + "*.txt", _aFiles)
	
	If empty(_aFiles)
		
		exit
		
	EndIf
	
	For _nI := 1 to LEN(_aFiles)
		
		_cArq 		:= _cDir + _aFiles[_nI] // caminho completo do arquivo
		
		_cNomeArq 	:= _aFiles[_nI]
		
		FT_FUSE(_cArq)
		FT_FGOTOP()
		FT_FREADLN()
		
		IF substr(_aFiles[_nI],1,6) == 'EROPED'	// Romaneio
			
			Do While !FT_FEOF()
				
				_cLinha := FT_FREADLN()
				
				Do Case
					
					Case substr(_cLinha,1,2) = 'HP' // cabeçalho do pedido
						
						_aItens  	:= {}	// Itens do PV (Romaneio)
						_aCabec		:= {}
						
						_cItem 		:= '0000'	 
						_cNroPedWS 	:= substr(_cLinha,33,9)  // N° do pedido no WebSupply
						_cCGC 	 	:= substr(_cLinha,3,14)  	// Cnpj do cliente
						_cCGCFor 	:= substr(_cLinha,18,14) 	// Cnpj do fornecedor
						
						cFilAnt  := Posicione("SA2", 8, _cCGCFor, 'A2_LOJA')
						cNumEmp  := '01' + cFilAnt
						
						aAdd(_aCabec,{"C5_FILIAL"  , cFilAnt											, Nil})
						aAdd(_aCabec,{"C5_TIPO"    , 'N'											   	, Nil})
						aAdd(_aCabec,{"C5_CLIENTE" , Posicione("SA1", 9, _cCGC, 'A1_COD')				, Nil})
						aAdd(_aCabec,{"C5_LOJACLI" , SA1->A1_LOJA									  	, Nil})
						aAdd(_aCabec,{"C5_OS"  , "WS"													, Nil}) // utilizado como identificador
						
					Case substr(_cLinha,1,2) = 'DP' // detalhe do pedido
						
						_cItem := Soma1(_cItem)
						
						_aItem 		:= {} 	// Array(4,3)
						aAdd(_aItem,{"C6_ITEM"   , _cItem																, Nil})
						aAdd(_aItem,{"C6_PRODUTO", alltrim(substr(_cLinha,72,15))										, Nil})
						aAdd(_aItem,{"C6_QTDVEN" , round(val(substr(_cLinha,136,7) + "." + substr(_cLinha,143,4)), 2)	, Nil})
						
						If left(_cCGC,8) = left(_cCGCFor,8) // Filial
							
							_cTes := Posicione('SBZ', 1, cFilAnt  + alltrim(substr(_cLinha,72,15)), 'BZ_TS')
							
						Else // Coligada
							
							_cTes := Posicione('SBZ', 1, cFilAnt  + alltrim(substr(_cLinha,72,15)), 'BZ_TSC')
							
						End
						
						aAdd(_aItem, {"C6_TES"		,	_cTes				, Nil})
						
						AADD(_aItens, _aItem)
						
					Case substr(_cLinha,1,2) = 'TP' // trailler do pedido
						
						lMSErroAuto := .f.
						MsExecAuto({|x,y,z| MATA410(x,y,z)}, _aCabec, _aItens,3, .F.)
						
						_cTable := '<TABLE WIDTH=80% BORDER=1 BORDERCOLOR="#cccccc" CELLPADDING=4 CELLSPACING=0 STYLE="page-break-before: always">'
						_cTable += '	<TR VALIGN=TOP>                  '
						
						_cTable += '		<TD WIDTH=15%>'
						_cTable += '	   		<P><h3 align = LEFT<font size="1" face="Verdana"><b>Item<B></P></font> '
						_cTable += '		</TD>'
						
						_cTable += '		<TD WIDTH=25%>'
						_cTable += '	   		<P><h3 align = LEFT<font size="1" face="Verdana"><b>Cód. Produto<B></P></font> '
						_cTable += '		</TD>'
						
						_cTable += '		<TD WIDTH=40%>'
						_cTable += '	   		<P><h3 align = LEFT<font size="1" face="Verdana"><b>Descrição<B></P></font> '
						_cTable += '		</TD>'
						
						_cTable += '		<TD WIDTH=15%>'
						_cTable += '	   		<P><h3 align = CENTER<font size="1" face="Verdana"><b>Qtde Vendida<B></P></font> '
						_cTable += '		</TD>'
						
						For _nJ := 1 to len(_aItens)

							_cTable += 	'	<TR VALIGN=TOP>                  '
							
							_cTable += '		<TD WIDTH=15%>'
							_cTable += '	   		<P><h3 align = LEFT<font size="1" face="Verdana"><b>' + substr(_aItens[_nJ,1,2],1,7) + '<B></P></font> '
							_cTable += '		</TD>'
							
							_cTable += '		<TD WIDTH=25%>'
							_cTable += '	   		<P><h3 align = LEFT<font size="1" face="Verdana"><b>' + substr(_aItens[_nJ,2,2],1,18) + '<B></P></font> '
							_cTable += '		</TD>'
							
							_cTable += '		<TD WIDTH=40%>'
							_cTable += '	   		<P><h3 align = LEFT<font size="1" face="Verdana"><b>' + substr(iif(alltrim(Posicione('SB1',1, xFilial('SB1') + _aItens[_nj,2,2],'B1_DESC')) == '', '<font color=red><b>Produto não encontrado!</b></font>',iif(SB1->B1_MSBLQL == '1', '<font size="2" color=red><b>Produto Bloqueado. Solicite desbloqueio.</b></font>',SB1->B1_DESC)),1,40) + '<B></P></font> '
							_cTable += '		</TD>'
							
							_cTable += '		<TD WIDTH=15%>'
							_cTable += '	   		<P><h3 align = RIGHT<font size="1" face="Verdana"><b>' + substr(iif(_aItens[_nJ,3,2] == 0, '<font color=red><b>Qtde zerada!</b></font>', str(_aItens[_nJ,3,2])),1,19) + '<B></P></font> '
							_cTable += '		</TD>'
							
						Next
					   
						_cTable += '	</TR>'
						_cTable += '</TABLE>'
						_cTable += '<P STYLE="margin-bottom: 0cm"><BR>'

						If lMSErroAuto

 //							MOSTRAERRO()
							
							If Empty(_cPVNOK)
								
								_cPVNOK += '<html>'
								_cPVNOK += '<head>'
								_cPVNOK += '<h3 align = Left><font size="3" color="#FF0000" face="Verdana"> Pedidos de venda não importados </h3></font>'
								_cPVNOK += '</head>'
								_cPVNOK += '<body bgcolor = white text=black  >'
								_cPVNOK += '<hr width=100% noshade>'
						//		_cPVNOK += '<b><font size="3" color="#0000FF" face="Verdana"> Descrição: </font></b>'+ _cEnter + _cEnter

							EndIf
							
							_cPVNOK += '<p>Arquivo: ' + _cNomeArq + replicate('&nbsp;', 10) + 'N° Ped. WebSupply: ' + _cNroPedWS /*cnropedarq*/ + '</p>'
							_cPVNOK += '<p>Lj Forn.: ' + _aCabec[1,2]  + '</p><p></p>' 
							_cPVNOK += _cTable
							
						Else

				   		DbCloseArea("TC5")
						_cQuery := "SELECT MAX(C5_NUM) PEDIDO "
						_cQuery += _cEnter + " FROM " + RetSqlName("SC5") + " SC5 (NOLOCK) "
						_cQuery += _cEnter + " WHERE C5_FILIAL = '" + SA2->A2_LOJA + "' AND C5_OS = 'WS'"
						
						DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), "TC5", .F., .T.)
							
							If Empty(_cPVOK)
								
								_cPVOK += '<html>'
								_cPVOK += '<head>'
								_cPVOK += '<h3 align = Left><font size="3" color="blue" face="Verdana"> Pedidos de venda importados </h3></font>'
								_cPVOK += '</head>'
								_cPVOK += '<body bgcolor = white text=black  >'
								_cPVOK += '<hr width=100% noshade>' 
							//	_cPVOK += '<b><font size="3" color="#0000FF" face="Verdana"> Descrição: </font></b>'+ _cEnter + _cEnter
							
							EndIf
							
							_cPVOK += '<p>Pedido: ' + TC5->PEDIDO  + '</p>'
							_cPVOK += '<p>Lj Forn.: ' + _aCabec[1,2] + '</p><p></p>'
							_cPVOK += _cTable
							
						EndIf
						
					Case substr(_cLinha,1,2) = 'TA' // trailler do arquivo
						
				EndCase
				
				FT_FSKIP()
				
			EndDo
			
		ElseIf substr(_aFiles[_nI],1,6) == 'ECLPED' //	PC = SC7
			
			Do While !FT_FEOF()
				_cLinha := FT_FREADLN()
				
				Do Case
					
					Case substr(_cLinha,1,2) = 'HP' // cabeçalho do pedido
						
						_aCabec		:= {}
						_aItens		:= {}
						_cNroPedWS 	:= ''

						_cItem 		:= '0000'	
						_cNroPedWS 	:= substr(_cLinha,33,9)  	// N° do pedido no WebSupply
						_cCGC 	 	:= substr(_cLinha,3,14)  	// Cnpj do cliente
						_cCGCFor 	:= substr(_cLinha,18,14) 	// Cnpj do fornecedor
						
						cFilAnt  := Posicione("SA1", 9, _cCGC, 'A1_LOJA')
						cNumEmp  := '01' + cFilAnt
						
						_C7_NUM := GetSxeNum("SC7","C7_NUM")
						Do While .T.
							DbSelectArea("SC7")
							DbSetOrder(1)
							If DbSeek(xFilial("SC7") + _C7_NUM,.f.)
								ConfirmSX8()
								_C7_NUM := GetSxeNum("SC7","C7_NUM")
							Else
								Exit
							EndIf
						EndDo
						
						aAdd(_aCabec, {"C7_NUM"     , _C7_NUM										, Nil})
						aAdd(_aCabec, {"C7_FORNECE" , Posicione("SA2", 8, _cCGCFor, 'A2_COD')		, Nil})
						aAdd(_aCabec, {"C7_LOJA" 	, SA2->A2_LOJA								  	, Nil})
						aAdd(_aCabec, {"C7_EMISSAO"	, dDataBase										, Nil})
						aAdd(_aCabec, {"C7_FILENT"	, cFilAnt 										, Nil})
						aAdd(_aCabec, {"C7_COND"   	, SA2->A2_COND									, Nil})
						aAdd(_aCabec, {"C7_CONTATO"	, 'WS'  										, Nil})
						aAdd(_aCabec, {"C7_MOEDA"	, 1  		  									, Nil})
						aAdd(_aCabec, {"C7_TPFRETE" , 'F'                                			, Nil})
						aAdd(_aCabec, {"C7_TXMOEDA" , 1              								, Nil})
						
					Case substr(_cLinha,1,2) = 'DP' // detalhe do pedido
						
						_cItem := Soma1(_cItem)
						_aItem 		:= {}
						aAdd(_aItem,{"C7_ITEM"   	, _cItem										, Nil})
						aAdd(_aItem,{"C7_PRODUTO"	, alltrim(substr(_cLinha,72,15))				, Nil})
						aAdd(_aItem,{"C7_QUANT"		, round(val(substr(_cLinha,136,11))/10000,2)	, Nil})
						aAdd(_aItem,{"C7_ORIGEM"	, "WS"										   	, Nil}) // utilizado como identificador de pedido WebSupply
						
 						aAdd(_aItens, _aItem)						
						
					Case substr(_cLinha,1,2) = 'TP' // trailler do pedido
						
						lMSErroAuto := .f.
						MSExecAuto({|x,y,z,k| MATA120(x,y,z,k)},1,_aCabec, _aItens,3)
						
						_cTable := '<TABLE WIDTH=80% BORDER=1 BORDERCOLOR="#cccccc" CELLPADDING=4 CELLSPACING=0 STYLE="page-break-before: always">'
						_cTable += '	<TR VALIGN=TOP>                  '
						
						_cTable += '		<TD WIDTH=15%>'
						_cTable += '	   		<P><h3 align = LEFT<font size="1" face="Verdana"><b>Item<B></P></font> '
						_cTable += '		</TD>'
						
						_cTable += '		<TD WIDTH=25%>'
						_cTable += '	   		<P><h3 align = LEFT<font size="1" face="Verdana"><b>Cód. Produto<B></P></font> '
						_cTable += '		</TD>'
						
						_cTable += '		<TD WIDTH=40%>'
						_cTable += '	   		<P><h3 align = LEFT<font size="1" face="Verdana"><b>Descrição<B></P></font> '
						_cTable += '		</TD>'
						
						_cTable += '		<TD WIDTH=15%>'
						_cTable += '	   		<P><h3 align = CENTER<font size="1" face="Verdana"><b>Qtde<B></P></font> '
						_cTable += '		</TD>'
						
						For _nJ := 1 to len(_aItens)

							_cTable += 	'	<TR VALIGN=TOP>                  '
							
							_cTable += '		<TD WIDTH=15%>'
							_cTable += '	   		<P><h3 align = LEFT<font size="1" face="Verdana"><b>' + substr(_aItens[_nJ,1,2],1,7) + '<B></P></font> '
							_cTable += '		</TD>'
							
							_cTable += '		<TD WIDTH=25%>'
							_cTable += '	   		<P><h3 align = LEFT<font size="1" face="Verdana"><b>' + substr(_aItens[_nJ,2,2],1,18) + '<B></P></font> '
							_cTable += '		</TD>'
							
							_cTable += '		<TD WIDTH=40%>'
							_cTable += '	   		<P><h3 align = LEFT<font size="1" face="Verdana"><b>' + substr(iif(alltrim(Posicione('SB1',1, xFilial('SB1') + _aItens[_nj,2,2],'B1_DESC')) == '', '<font color=red><b>Produto não encontrado!</b></font>', iif(SB1->B1_MSBLQL == '1', '<font size="2" color=red><b>Produto Bloqueado. Solicite desbloqueio.</b></font>', SB1->B1_DESC)),1,40) + '<B></P></font> '
							_cTable += '		</TD>'
							
							_cTable += '		<TD WIDTH=15%>'
							_cTable += '	   		<P><h3 align = RIGHT<font size="1" face="Verdana">' + trans(_aItens[_nJ,3,2],'@E 999,999.99') + '</P></font> '
							_cTable += '		</TD>'
							
						Next
					
						_cTable += '	</TR>'
						_cTable += '</TABLE>'
						_cTable += '<P STYLE="margin-bottom: 0cm"><BR>'
						
						If lMSErroAuto
							
 //							MOSTRAERRO()
							
							If Empty(_cPCNOK)
								
								_cPCNOK += '<html>'
								_cPCNOK += '<head>'
								_cPCNOK += '<h3 align = Left><font size="3" color="#FF0000" face="Verdana"> Pedidos de compra não importados </h3></font>'
								_cPCNOK += '</head>'
								_cPCNOK += '<body bgcolor = white text=black  >'
								_cPCNOK += '<hr width=100% noshade>' 
//								_cPCNOK += '<b><font size="3" color="#0000FF" face="Verdana"> Descrição: </font></b>'+ _cEnter + _cEnter

							EndIf
							
							_cPCNOK += '<p>Arquivo: ' + _cNomeArq + replicate('&nbsp;',10) + ' N° Ped. WebSupply: ' + _cNroPedWS /*cnropedarq*/ + '</p>'
							_cPCNOK += '<p>Fornecedor: ' + _aCabec[2,2] + replicate('&nbsp;',15) + 'Loja: ' + _aCabec[3,2] + replicate('&nbsp;', 15) + 'Fl. Entr.: ' + _aCabec[5,2] + '</p><p>Cond. Pag.: ' + iif(alltrim(_aCabec[6,2]) == '', '<Font size=4 color="red" face=Verdana><b>Cond. de pag. não cadastrada. Solicite o cadastro ao depto de Controladoria.</b></font>',_aCabec[6,2] + ' - ' + Posicione('SE4',1,xFilial('SE4') + _aCabec[6,2],'E4_DESCRI')) /* + codfor+loja + dentrega... */ + '</p><p></p>'
							_cPCNOK += _cTable

						Else
						
				   		DbCloseArea("TC7")
						_cQuery := "SELECT MAX(C7_NUM) PEDIDO "
						_cQuery += _cEnter + " FROM " + RetSqlName("SC7") + " SC7 (NOLOCK) "
						_cQuery += _cEnter + " WHERE C7_FILIAL = '" + cFilAnt + "' AND C7_ORIGEM = 'WS'"
						
						DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), "TC7", .F., .T.)
							
							If Empty(_cPCOK)
								
								_cPCOK += '<html>'
								_cPCOK += '<head>'
								_cPCOK += '<h3 align = Left><font size="3" color="blue" face="Verdana"> Pedidos de compra importados </h3></font>'
								_cPCOK += '</head>'
								_cPCOK += '<body bgcolor = white text=black  >'
								_cPCOK += '<hr width=100% noshade>' 
 //								_cPCOK += '<b><font size="3" color="#0000FF" face="Verdana"> Descrição: </font></b>'
								
							EndIf
							
							_cPCOK += '<p>Pedido Protheus: ' + TC7->PEDIDO /*cnropedarq*/ + '</p>' 
							_cPCOK += '<p>Fornecedor: ' + _aCabec[2,2] + replicate('&nbsp;',15) + 'Loja: ' + _aCabec[3,2] + replicate('&nbsp;', 15) + 'Emissão: ' + DTOC(_aCabec[4,2]) + replicate('&nbsp;', 15) + 'Fl. Entr.: ' + _aCabec[5,2] + '</p><p>Cond. Pag.: ' + iif(alltrim(_aCabec[6,2]) == '', '<Font size=4 color="red" face=Verdana><b>Cond. de pag. não cadastrada. Solicite o cadastro ao depto de Controladoria.</b></font>',_aCabec[6,2] + ' - ' + Posicione('SE4',1, xFilial('SE4') + _aCabec[6,2],'E4_DESCRI'))/* + codfor+loja + dentrega... */ + '</p><p></p>' 
							_cPCOK += _cTable
							
						EndIf
						
					Case substr(_cLinha,1,2) = 'TA' // trailler do arquivo
						
				EndCase
				
				FT_FSKIP()
				
			EndDo
			
		EndIf
		
		FT_FUSE(_cNomeArq)
		
		COPY File (_cArq) TO (_cDir + 'Processados\' + _cNomeArq) // COPIA, RENOMEIA e COLA NA PASTA DESTINO
		
		If file('\websupply\processados\'+_cNomeArq)
			
			FErase(_cDir + _cNomeArq) // APAGA DA ORIGINAL
			
		Endif
		
	Next
	
EndDo

_cTo 		:= "rodrigo.alexandre@laselva.com.br"
_cSubject 	:= "Controle de Pedidos: WebSupply X Protheus"
_cBody		:= ""
_cBody		:= iif(!Empty(_cPVOK),_cPVOK + _cEnter + _cEnter,'') + iif(!Empty(_cPVNOK),_cPVNOK + _cEnter + _cEnter,'') + iif(!Empty(_cPCOK),_cPCOK + _cEnter + _cEnter,'') + iif(!Empty(_cPCNOK),_cPCNOK,'') + _cHtEnd
	
	U_LS_EMLWS(_cTo, _cSubject, _cBody)	//Envia E-mail

Return()
