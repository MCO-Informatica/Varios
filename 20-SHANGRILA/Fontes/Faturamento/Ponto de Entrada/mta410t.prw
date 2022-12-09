#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "AP5MAIL.CH"
#INCLUDE "TopConn.ch"
#INCLUDE "TbiConn.ch"
#INCLUDE "TbiCode.ch"
#INCLUDE "XMLXFUN.CH"
#INCLUDE "FILEIO.CH"


#Define CRLF CHR(13)+CHR(10)

/////////////////////////////////////////////////////////////////////////////////////
//+-------------------------------------------------------------------------------+//
//| PROGRAMA  | MTA410T.PRW          | AUTOR | rdSolution     | DATA | 09/02/2007 |//
//+-------------------------------------------------------------------------------+//
//| DESCRICAO | Ponto de Entrada - MTA410T()                                      |//
//|           | Este ponto esta localizado apï¿½s a atualizaï¿½ï¿½o do pedido de venda  |//
//|           | e tem como objetivo gerar um log com os dados que foram alterados |//
//|           | no pedido de venda.                                               |//
//+-------------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////// 
// ALTERADO POR GENILSON LUCAS (MVG) PARA BUSCAR DA PASTA SYSTEM OS ARQUIVOS.

User Function MTA410T()

	Local _aAreaSC5 := SC5->(getArea())
	Local _aAreaSC6 := SC6->(getArea())

	Local _aNewSC5  := {}
	Local _aNewSC6  := {}
	Local _aTmpALT  := {}

	Local _cUsrLGI  := Substr(Embaralha(SC5->C5_USERLGI,1),1,15)	//	USER LGI
	Local _cUsrLGA  := Substr(Embaralha(SC5->C5_USERLGA,1),1,15)	//	USER LGA

	Private _cNomeArq := ""

	Private _cCpoOld := ""
	Private _cCpoNew := ""

// Valida se funï¿½ï¿½o do Pedido de Venda
//------------------------------------
//Add Joï¿½o Zabotto 13/02/2017 - Validar regras pela rotina padrï¿½o
	If !(Alltrim(Upper(FunName())) $ "MATA410")
		Return()
	Endif

/*
-------------------------------------------------------------
Grava Bloqueios
-------------------------------------------------------------*/

	If !Altera .and. !INCLUI
		Return()
	Endif

RGrvSC5()

_nvlsc5 := 0

dbSelectArea( "SC6" )
SC6->( dbSetOrder(01) )
SC6->( dbSeek( xFilial("SC6") + SC5->C5_NUM ) )

	While !SC6->(Eof()) .AND. SC6->C6_FILIAL == xFilial("SC6") .AND. SC6->C6_NUM == SC5->C5_NUM
                    
	_nvlsc5 += SC6->C6_VALOR
	SC6->( dbSkip() )
	
	Enddo
_cprzsc5:= SC5->C5_CONDPAG + " - " + Alltrim(Posicione("SE4",1,xFilial("SE4")+SC5->C5_CONDPAG,"E4_DESCRI"))
_vendsc5:= SC5->C5_VEND1 + " - " + Alltrim(Posicione("SA3",1,xFilial("SA3")+SC5->C5_VEND1,"A3_NOME"))
//C5_XPRZMED
//C5_VEND1


// Carrega o Array com os dados alterados no SC5
//----------------------------------------------
If Altera
dbSelectArea("SC5")

aadd( _aNewSC5, Array(Len(_aTmpSC5)))                    

		For nI := 1 TO Len(_aTmpSC5)
	
	_aNewSC5[Len(_aNewSC5)][nI] := FieldGet( FieldPos( _aTmpSC5[nI][2] ) )		
		
		Next nI

// Verifica Alteraï¿½ï¿½es no SC5
//---------------------------
_nLin := IIf( Len(_aOldSC5) > Len(_aNewSC5), Len(_aOldSC5), Len(_aNewSC5) )


		For nI := 1 TO _nLin

			For nX := 1 TO Len(_aTmpSC5)
	
				If _aOldSC5[nI,nX] <> _aNewSC5[nI,nX]
			//Alert(_aTmpSC5[nX,02] + '-' + _aOldSC5[nI,nX] + '-' + _aNewSC5[nI,nX])
					If _aTmpSC5[nX,02] = 'C5_CONDPAG'
			AADD(_aTmpALT, {_aTmpSC5[nX,01]	,;	//	[01] Titulo
		                 	_aTmpSC5[nX,02]	,;	//	[02] Nome do Campo
		                 	_aTmpSC5[nX,03]	,;	//	[03] Picture
		                 	_aTmpSC5[nX,04]	,;	//	[04] Tipo do Campo
		                 	_aTmpSC5[nX,05]	,;	//	[05] Tamanho
		                 	_aTmpSC5[nX,06]	,;	//	[06] Casas Decimais
		                 	"SC5"           ,;	//	[07] Alias
		                 	"  "            ,;	//	[08] ITEM		
		                 	_aOldSC5[nI,nX]+'-'+Alltrim(Posicione("SE4",1,xFilial("SE4")+_aOldSC5[nI,nX],"E4_DESCRI"))	,;	//	[07] Conteudo De
		                 	_aNewSC5[nI,nX]+'-'+Alltrim(Posicione("SE4",1,xFilial("SE4")+_aNewSC5[nI,nX],"E4_DESCRI")) ,;	//	[08] Conteudo Para
		                 	USRRETNAME(SUBSTR(_cUsrLGI,3,6))        ,;	//	[10] USERLGI
		                 	USRRETNAME(SUBSTR(_cUsrLGA,3,6))        })	//	[11] USERLGA
					Elseif _aTmpSC5[nX,02] = 'C5_CLIENTE'
			AADD(_aTmpALT, {_aTmpSC5[nX,01]	,;	//	[01] Titulo
		                 	_aTmpSC5[nX,02]	,;	//	[02] Nome do Campo
		                 	_aTmpSC5[nX,03]	,;	//	[03] Picture
		                 	_aTmpSC5[nX,04]	,;	//	[04] Tipo do Campo
		                 	_aTmpSC5[nX,05]	,;	//	[05] Tamanho
		                 	_aTmpSC5[nX,06]	,;	//	[06] Casas Decimais
		                 	"SC5"           ,;	//	[07] Alias
		                 	"  "            ,;	//	[08] ITEM		
		                 	_aOldSC5[nI,nX]+'-'+Alltrim(Posicione("SA1",1,xFilial("SA1")+_aOldSC5[nI,nX]+'01',"A1_NOME"))	,;	//	[07] Conteudo De
		                 	_aNewSC5[nI,nX]+'-'+Alltrim(Posicione("SA1",1,xFilial("SA1")+_aNewSC5[nI,nX]+'01',"A1_NOME")) ,;	//	[08] Conteudo Para
		                 	USRRETNAME(SUBSTR(_cUsrLGI,3,6))        ,;	//	[10] USERLGI
		                 	USRRETNAME(SUBSTR(_cUsrLGA,3,6))        })	//	[11] USERLGA
					Elseif _aTmpSC5[nX,02] = 'C5_TRANSP'
			AADD(_aTmpALT, {_aTmpSC5[nX,01]	,;	//	[01] Titulo
		                 	_aTmpSC5[nX,02]	,;	//	[02] Nome do Campo
		                 	_aTmpSC5[nX,03]	,;	//	[03] Picture
		                 	_aTmpSC5[nX,04]	,;	//	[04] Tipo do Campo
		                 	_aTmpSC5[nX,05]	,;	//	[05] Tamanho
		                 	_aTmpSC5[nX,06]	,;	//	[06] Casas Decimais
		                 	"SC5"           ,;	//	[07] Alias
		                 	"  "            ,;	//	[08] ITEM		
		                 	_aOldSC5[nI,nX]+'-'+Alltrim(Posicione("SA4",1,xFilial("SA4")+_aOldSC5[nI,nX],"A4_NOME"))	,;	//	[07] Conteudo De
		                 	_aNewSC5[nI,nX]+'-'+Alltrim(Posicione("SA4",1,xFilial("SA4")+_aNewSC5[nI,nX],"A4_NOME")) ,;	//	[08] Conteudo Para
		                 	USRRETNAME(SUBSTR(_cUsrLGI,3,6))        ,;	//	[10] USERLGI
		                 	USRRETNAME(SUBSTR(_cUsrLGA,3,6))        })	//	[11] USERLGA
					Elseif _aTmpSC5[nX,02] = 'C5_REDESP'
			AADD(_aTmpALT, {_aTmpSC5[nX,01]	,;	//	[01] Titulo
		                 	_aTmpSC5[nX,02]	,;	//	[02] Nome do Campo
		                 	_aTmpSC5[nX,03]	,;	//	[03] Picture
		                 	_aTmpSC5[nX,04]	,;	//	[04] Tipo do Campo
		                 	_aTmpSC5[nX,05]	,;	//	[05] Tamanho
		                 	_aTmpSC5[nX,06]	,;	//	[06] Casas Decimais
		                 	"SC5"           ,;	//	[07] Alias
		                 	"  "            ,;	//	[08] ITEM		
		                 	_aOldSC5[nI,nX]+'-'+Alltrim(Posicione("SA4",1,xFilial("SA4")+_aOldSC5[nI,nX],"A4_NOME"))	,;	//	[07] Conteudo De
		                 	_aNewSC5[nI,nX]+'-'+Alltrim(Posicione("SA4",1,xFilial("SA4")+_aNewSC5[nI,nX],"A4_NOME")) ,;	//	[08] Conteudo Para
		                 	USRRETNAME(SUBSTR(_cUsrLGI,3,6))        ,;	//	[10] USERLGI
		                 	USRRETNAME(SUBSTR(_cUsrLGA,3,6))        })	//	[11] USERLGA
					Elseif _aTmpSC5[nX,02] = 'C5_VEND1'
			AADD(_aTmpALT, {_aTmpSC5[nX,01]	,;	//	[01] Titulo
		                 	_aTmpSC5[nX,02]	,;	//	[02] Nome do Campo
		                 	_aTmpSC5[nX,03]	,;	//	[03] Picture
		                 	_aTmpSC5[nX,04]	,;	//	[04] Tipo do Campo
		                 	_aTmpSC5[nX,05]	,;	//	[05] Tamanho
		                 	_aTmpSC5[nX,06]	,;	//	[06] Casas Decimais
		                 	"SC5"           ,;	//	[07] Alias
		                 	"  "            ,;	//	[08] ITEM		
		                 	_aOldSC5[nI,nX]+'-'+Alltrim(Posicione("SA3",1,xFilial("SA3")+_aOldSC5[nI,nX],"A3_NOME"))	,;	//	[07] Conteudo De
		                 	_aNewSC5[nI,nX]+'-'+Alltrim(Posicione("SA3",1,xFilial("SA3")+_aNewSC5[nI,nX],"A3_NOME")) ,;	//	[08] Conteudo Para
		                 	USRRETNAME(SUBSTR(_cUsrLGI,3,6))        ,;	//	[10] USERLGI
		                 	USRRETNAME(SUBSTR(_cUsrLGA,3,6))        })	//	[11] USERLGA
					Elseif _aTmpSC5[nX,02] = 'C5_VEND2'
			AADD(_aTmpALT, {_aTmpSC5[nX,01]	,;	//	[01] Titulo
		                 	_aTmpSC5[nX,02]	,;	//	[02] Nome do Campo
		                 	_aTmpSC5[nX,03]	,;	//	[03] Picture
		                 	_aTmpSC5[nX,04]	,;	//	[04] Tipo do Campo
		                 	_aTmpSC5[nX,05]	,;	//	[05] Tamanho
		                 	_aTmpSC5[nX,06]	,;	//	[06] Casas Decimais
		                 	"SC5"           ,;	//	[07] Alias
		                 	"  "            ,;	//	[08] ITEM		
		                 	_aOldSC5[nI,nX]+'-'+Alltrim(Posicione("SA3",1,xFilial("SA3")+_aOldSC5[nI,nX],"A3_NOME"))	,;	//	[07] Conteudo De
		                 	_aNewSC5[nI,nX]+'-'+Alltrim(Posicione("SA3",1,xFilial("SA3")+_aNewSC5[nI,nX],"A3_NOME")) ,;	//	[08] Conteudo Para
		                 	USRRETNAME(SUBSTR(_cUsrLGI,3,6))        ,;	//	[10] USERLGI
		                 	USRRETNAME(SUBSTR(_cUsrLGA,3,6))        })	//	[11] USERLGA
					Elseif _aTmpSC5[nX,02] = 'C5_VEICULO'
			AADD(_aTmpALT, {_aTmpSC5[nX,01]	,;	//	[01] Titulo
		                 	_aTmpSC5[nX,02]	,;	//	[02] Nome do Campo
		                 	_aTmpSC5[nX,03]	,;	//	[03] Picture
		                 	_aTmpSC5[nX,04]	,;	//	[04] Tipo do Campo
		                 	_aTmpSC5[nX,05]	,;	//	[05] Tamanho
		                 	_aTmpSC5[nX,06]	,;	//	[06] Casas Decimais
		                 	"SC5"           ,;	//	[07] Alias
		                 	"  "            ,;	//	[08] ITEM		
		                 	_aOldSC5[nI,nX]+'-'+Alltrim(Posicione("DA3",1,xFilial("DA3")+_aOldSC5[nI,nX],"DA3_DESC"))	,;	//	[07] Conteudo De
		                 	_aNewSC5[nI,nX]+'-'+Alltrim(Posicione("DA3",1,xFilial("DA3")+_aNewSC5[nI,nX],"DA3_DESC")) ,;	//	[08] Conteudo Para
		                 	USRRETNAME(SUBSTR(_cUsrLGI,3,6))        ,;	//	[10] USERLGI
		                 	USRRETNAME(SUBSTR(_cUsrLGA,3,6))        })	//	[11] USERLGA
					Else
			AADD(_aTmpALT, {_aTmpSC5[nX,01]	,;	//	[01] Titulo
		                 	_aTmpSC5[nX,02]	,;	//	[02] Nome do Campo
		                 	_aTmpSC5[nX,03]	,;	//	[03] Picture
		                 	_aTmpSC5[nX,04]	,;	//	[04] Tipo do Campo
		                 	_aTmpSC5[nX,05]	,;	//	[05] Tamanho
		                 	_aTmpSC5[nX,06]	,;	//	[06] Casas Decimais
		                 	"SC5"           ,;	//	[07] Alias
		                 	"  "            ,;	//	[08] ITEM		
		                 	_aOldSC5[nI,nX]	,;	//	[07] Conteudo De
		                 	_aNewSC5[nI,nX] ,;	//	[08] Conteudo Para
		                 	USRRETNAME(SUBSTR(_cUsrLGI,3,6))        ,;	//	[10] USERLGI
		                 	USRRETNAME(SUBSTR(_cUsrLGA,3,6))        })	//	[11] USERLGA			
					Endif
				Endif
		
			Next nX

		Next nI

RestArea(_aAreaSC5)

// Carrega o Array com os dados alterados no SC6
//----------------------------------------------
_cItem := "00"
dbSelectArea( "SC6" )
SC6->( dbSetOrder(01) )
SC6->( dbSeek( xFilial("SC6") + SC5->C5_NUM ) )

		While !SC6->(Eof()) .AND. SC6->C6_FILIAL == xFilial("SC6") ;
                    .AND. SC6->C6_NUM == SC5->C5_NUM
                    
	_cItem := Soma1(_cItem)
	
				while _cItem < SC6->C6_ITEM
		
		aadd( _aNewSC6, Array(Len(_aTmpSC6)+3))                    	
		
		_aNewSC6[Len(_aNewSC6)][Len(_aTmpSC6)+1] := _cItem
		
		_cItem := Soma1(_cItem)
		
			Enddo
                    
	aadd( _aNewSC6, Array(Len(_aTmpSC6)+3))                    

	// Carrega o Array com os dados do SC6
	//------------------------------------
			For nI := 1 TO Len(_aTmpSC6)
		_aNewSC6[Len(_aNewSC6)][nI] := FieldGet( FieldPos( _aTmpSC6[nI][2] ) )		
			Next nI
	
	_aNewSC6[Len(_aNewSC6)][Len(_aTmpSC6)+1] := SC6->C6_ITEM
	_aNewSC6[Len(_aNewSC6)][Len(_aTmpSC6)+2] := Substr(Embaralha(SC6->C6_USERLGI,1),1,15)
	_aNewSC6[Len(_aNewSC6)][Len(_aTmpSC6)+3] := Substr(Embaralha(SC6->C6_USERLGA,1),1,15)	
	
	SC6->( dbSkip() )
	
		Enddo

// Identifica as Alteraï¿½ï¿½es no SC6
//--------------------------------
_lContinua := .T.
_nLin := IIf( Len(_aOldSC6) > Len(_aNewSC6), Len(_aOldSC6), Len(_aNewSC6) )

		For nI := 1 To _nLin

	// Quando Pedido Velho menor que o Novo
	//-------------------------------------
			If Len(_aOldSC6) < nI

				For nX := 1 To Len(_aTmpSC6)
		
			AADD(_aTmpALT, { _aTmpSC6[nX,01]  				,;	//	[01] Titulo
		                 	 _aTmpSC6[nX,02]  				,;	//	[02] Nome do Campo
		                 	 _aTmpSC6[nX,03]  				,;	//	[03] Picture
		                 	 _aTmpSC6[nX,04]  				,;	//	[04] Tipo do Campo
		                 	 _aTmpSC6[nX,05]  				,;	//	[05] Tamanho
		                 	 _aTmpSC6[nX,06]  				,;	//	[06] Casas Decimais
		                 	 "SC6"            				,;	//	[07] Alias	
							 _aNewSC6[nI,Len(_aTmpSC6)+1]	,;	//	[08] ITEM DO PEDIDO			                 	 
		                 	 ""  							,;	//	[09] Conteudo De
		                     _aNewSC6[nI,nX]  				,;	//	[10] Conteudo Para
		                 	 USRRETNAME(SUBSTR(_cUsrLGI,3,6))	,;	//	_aNewSC6[nI,Len(_aTmpSC6)+2] 	,;	//	[11] USERLGI
		                 	 USRRETNAME(SUBSTR(_cUsrLGA,3,6))	})	//	_aNewSC6[nI,Len(_aTmpSC6)+3] 	})	//	[12] USERLGA	
				Next nX
		
		_lContinua := .F.
		
			Endif
	
	// Quando Pedido Novo menor que o Velho
	//-------------------------------------
			If Len(_aNewSC6) < nI

				For nX := 1 To Len(_aTmpSC6)
		
			AADD(_aTmpALT, { _aTmpSC6[nX,01]  				,;	//	[01] Titulo
		                 	 _aTmpSC6[nX,02]  				,;	//	[02] Nome do Campo
		                 	 _aTmpSC6[nX,03]  				,;	//	[03] Picture
		                 	 _aTmpSC6[nX,04]  				,;	//	[04] Tipo do Campo
		                 	 _aTmpSC6[nX,05]  				,;	//	[05] Tamanho
		                 	 _aTmpSC6[nX,06]  				,;	//	[06] Casas Decimais
		                 	 "SC6"            				,;	//	[07] Alias	
							 _aOldSC6[nI,Len(_aTmpSC6)+1]	,;	//	[08] ITEM DO PEDIDO			                 	 
		                 	 _aOldSC6[nI,nX]  				,;	//	[09] Conteudo De
		                     ""				  				,;	//	[10] Conteudo Para
		                 	 USRRETNAME(SUBSTR(_cUsrLGI,3,6))						,;	//	_aOldSC6[nI,Len(_aTmpSC6)+2] 	,;	//	[11] USERLGI
		                 	 USRRETNAME(SUBSTR(_cUsrLGA,3,6))						})	//	_aOldSC6[nI,Len(_aTmpSC6)+3] 	})	//	[12] USERLGA	
		                 	 
				Next nX
		
		_lContinua := .F.		
		
			Endif
	
	//	Item Novo igual Item Velho
	//----------------------------
			If _lContinua 	//	(_aNewSC6) >= Len(_aOldSC6)
	
				If _aNewSC6[nI,Len(_aTmpSC6)+1]	== _aOldSC6[nI,Len(_aTmpSC6)+1]	//	item
	
					For nX := 1 To Len(_aTmpSC6)
		
						If _aNewSC6[nI][nX] <> _aOldSC6[nI][nX]
		
						AADD(_aTmpALT, {_aTmpSC6[nX,01]  				,;	//	[01] Titulo
		       		    	     	 	_aTmpSC6[nX,02]  				,;	//	[02] Nome do Campo
		           		    	 	 	_aTmpSC6[nX,03]  				,;	//	[03] Picture
		               		 	 		_aTmpSC6[nX,04]  				,;	//	[04] Tipo do Campo
		               			 		_aTmpSC6[nX,05]  				,;	//	[05] Tamanho
		               	 	 	 		_aTmpSC6[nX,06]  				,;	//	[06] Casas Decimais
		               	 	 	 		"SC6"            				,;	//	[07] Alias	
						 	 	 		_aNewSC6[nI,Len(_aTmpSC6)+1]	,;	//	[08] ITEM DO PEDIDO			                 	 
		               	 	 	 		_aOldSC6[nI,nX]  				,;	//	[09] Conteudo De
		                   	 	 		_aNewSC6[nI,nX]  				,;	//	[10] Conteudo Para
		               	 	 	 		USRRETNAME(SUBSTR(_cUsrLGI,3,6))						,;	//	_aNewSC6[nI,Len(_aTmpSC6)+2] 	,;	//	[11] USERLGI
		               	 	 	 		USRRETNAME(SUBSTR(_cUsrLGA,3,6))						})	//	_aNewSC6[nI,Len(_aTmpSC6)+3] 	})	//	[12] USERLGA		
		               	 	 	 
						Endif
            
					Next nX
        
				Endif

		//	Item Novo Maior Item Velho
		//----------------------------
				If _aNewSC6[nI,Len(_aTmpSC6)+1]	> _aOldSC6[nI,Len(_aTmpSC6)+1]	//	item

					For nX := 1 To Len(_aTmpSC6)
		
						If _aNewSC6[nI][nX] <> _aOldSC6[nI][nX]
		
					AADD(_aTmpALT, {_aTmpSC6[nX,01]  				,;	//	[01] Titulo
		       			         	_aTmpSC6[nX,02]  				,;	//	[02] Nome do Campo
		           			     	_aTmpSC6[nX,03]  				,;	//	[03] Picture
		               			 	_aTmpSC6[nX,04]  				,;	//	[04] Tipo do Campo
		               				_aTmpSC6[nX,05]  				,;	//	[05] Tamanho
		               	 	 	 	_aTmpSC6[nX,06]  				,;	//	[06] Casas Decimais
		               	 	 	 	"SC6"            				,;	//	[07] Alias	
						 	 	 	_aNewSC6[nI,Len(_aTmpSC6)+1]	,;	//	[08] ITEM DO PEDIDO			                 	 
		               	 	 	 	""				  				,;	//	[09] Conteudo De
		                   	 	 	_aNewSC6[nI,nX]	  				,;	//	[10] Conteudo Para
		               	 	 	 	USRRETNAME(SUBSTR(_cUsrLGI,3,6))						,;	//	_aNewSC6[nI,Len(_aTmpSC6)+2] 	,;	//	[11] USERLGI
		               	 	 	 	USRRETNAME(SUBSTR(_cUsrLGA,3,6))						})	//	_aNewSC6[nI,Len(_aTmpSC6)+3] 	})	//	[12] USERLGA		
		               	 	 	 
						Endif
            
					Next nX
	
				Endif
	     
		//	Item Novo Menor Item Velho
		//----------------------------
				If _aNewSC6[nI,Len(_aTmpSC6)+1]	< _aOldSC6[nI,Len(_aTmpSC6)+1]	//	item

					For nX := 1 To Len(_aTmpSC6)
		
						If _aNewSC6[nI][nX] <> _aOldSC6[nI][nX]
		
					AADD(_aTmpALT, {_aTmpSC6[nX,01]  				,;	//	[01] Titulo
		       			         	_aTmpSC6[nX,02]  				,;	//	[02] Nome do Campo
		           			     	_aTmpSC6[nX,03]  				,;	//	[03] Picture
		               			 	_aTmpSC6[nX,04]  				,;	//	[04] Tipo do Campo
		               				_aTmpSC6[nX,05]  				,;	//	[05] Tamanho
		               	 	 	 	_aTmpSC6[nX,06]  				,;	//	[06] Casas Decimais
		               	 	 	 	"SC6"            				,;	//	[07] Alias	
						 	 	 	_aOldSC6[nI,Len(_aTmpSC6)+1]	,;	//	[08] ITEM DO PEDIDO			                 	 
		               	 	 	 	_aOldSC6[nI,nX]  				,;	//	[09] Conteudo De
		                   	 	 	""				  				,;	//	[10] Conteudo Para
		               	 	 	 	USRRETNAME(SUBSTR(_cUsrLGI,3,6))						,;	//	_aOldSC6[nI,Len(_aTmpSC6)+2] 	,;	//	[11] USERLGI
		               	 	 	 	USRRETNAME(SUBSTR(_cUsrLGA,3,6))						})	//	_aOldSC6[nI,Len(_aTmpSC6)+3] 	})	//	[12] USERLGA		
		               	 	 	 
						Endif
            
					Next nX
	
				Endif
	
			Endif
	
		Next nI

RestArea(_aAreaSC6)

		If Len(_aTmpALT) > 0
//			If !Altera
			GERA_TXT(_aTmpALT)
//			Endif
		Endif

		If Len(_aTmpALT) > 0
		//	If !Altera
				ENV_MAIL()
		//	Endif
		Endif
	Endif

Return()

Static Function GERA_TXT(_aTmpALT)

Local _cAlias := ""

Private _cLinha   := ""
Private _nHdl     := ""
Private lContinua := .T.

	If Len(_aTmpALT) <= 0
	Return()
	Endif

_cNomeArq := "ped_" + SM0->M0_CODIGO + SM0->M0_CODFIL + "_" + SC5->C5_NUM + ".TXT"	

	While .T.
		If File(_cNomeArq)
		//If (nAviso := Aviso('AVISO','Deseja substituir o ' + AllTrim(_cNomeArq) + ' existente ?', {'Sim','Nao','Cancela'})) == 1
			If fErase(_cNomeArq) == 0
				Exit
			Else
				//MsgAlert('Ocorreram problemas na tentativa de delecao do arquivo '+AllTrim(_cNomeArq)+'.')
			EndIf
		//ElseIf nAviso == 2
		//	Pergunte(cPerg,.T.)
		//	Loop
		//Else
		//	Return
		//EndIf
		Else
		Exit
		EndIf
	EndDo

_nHdl := fCreate(_cNomeArq)

	If _nHdl == -1
	MsgAlert('O arquivo '+AllTrim(_cNomeArq)+' nao pode ser criado! Verifique os parametros.','Atencao!')
	Return
	Endif

//_nvlsc5 := 0
//_nprzsc5:= SC5->C5_XPRZMED
//_vendsc5:= SC5->C5_VEND1

// Impressao do Nr. do Pedido
//---------------------------
_cLinha := Space(03)
_cLinha := _cLinha + "|"
_cLinha := IIf(Len(_cLinha) < 005, _cLinha + Space(005 - Len(_cLinha)), _cLinha )
_cLinha := _cLinha + "                | "
_cLinha := IIf(Len(_cLinha) < 074, _cLinha + Space(074 - Len(_cLinha)), _cLinha )
_cLinha := _cLinha + "|"
_cLinha := IIf(Len(_cLinha) < 127, _cLinha + Space(127 - Len(_cLinha)), _cLinha )		
_cLinha := _cLInha + "|"
_cLinha := IIf(Len(_cLinha) < 150, _cLinha + Space(150 - Len(_cLinha)), _cLinha )
_cLinha := _cLinha + "|"				
_cLinha := IIf(Len(_cLinha) < 172, _cLinha + Space(172 - Len(_cLinha)), _cLinha )
_cLinha := _cLinha + CRLF
fGrava()
_cLinha := Space(03)
_cLinha := _cLinha + "|"
_cLinha := IIf(Len(_cLinha) < 005, _cLinha + Space(005 - Len(_cLinha)), _cLinha )
_cLinha := _cLinha + "                | "
_cLinha := IIf(Len(_cLinha) < 074, _cLinha + Space(074 - Len(_cLinha)), _cLinha )
_cLinha := _cLinha + "|"
_cLinha := IIf(Len(_cLinha) < 127, _cLinha + Space(127 - Len(_cLinha)), _cLinha )		
_cLinha := _cLInha + "|"
_cLinha := IIf(Len(_cLinha) < 150, _cLinha + Space(150 - Len(_cLinha)), _cLinha )
_cLinha := _cLinha + "|"				
_cLinha := IIf(Len(_cLinha) < 172, _cLinha + Space(172 - Len(_cLinha)), _cLinha )
_cLinha := _cLinha + CRLF
fGrava()


_cLinha := Space(03)
_cLinha := _cLinha + "|"
_cLinha := IIf(Len(_cLinha) < 005, _cLinha + Space(005 - Len(_cLinha)), _cLinha )
_cLinha := _cLinha + "Pedido Numero   | " + SC5->C5_NUM
_cLinha := IIf(Len(_cLinha) < 074, _cLinha + Space(074 - Len(_cLinha)), _cLinha )
_cLinha := _cLinha + "|"
_cLinha := IIf(Len(_cLinha) < 127, _cLinha + Space(127 - Len(_cLinha)), _cLinha )		
_cLinha := _cLInha + "|"
_cLinha := IIf(Len(_cLinha) < 150, _cLinha + Space(150 - Len(_cLinha)), _cLinha )
_cLinha := _cLinha + "|"				
_cLinha := IIf(Len(_cLinha) < 172, _cLinha + Space(172 - Len(_cLinha)), _cLinha )
_cLinha := _cLinha + CRLF
fGrava()
_cLinha := Space(03)
_cLinha := _cLinha + "|"
_cLinha := IIf(Len(_cLinha) < 005, _cLinha + Space(005 - Len(_cLinha)), _cLinha )
_cLinha := _cLinha + "                | "
_cLinha := IIf(Len(_cLinha) < 074, _cLinha + Space(074 - Len(_cLinha)), _cLinha )
_cLinha := _cLinha + "|"
_cLinha := IIf(Len(_cLinha) < 127, _cLinha + Space(127 - Len(_cLinha)), _cLinha )		
_cLinha := _cLInha + "|"
_cLinha := IIf(Len(_cLinha) < 150, _cLinha + Space(150 - Len(_cLinha)), _cLinha )
_cLinha := _cLinha + "|"				
_cLinha := IIf(Len(_cLinha) < 172, _cLinha + Space(172 - Len(_cLinha)), _cLinha )
_cLinha := _cLinha + CRLF
fGrava()
_cLinha := Space(03)
_cLinha := _cLinha + "|"
_cLinha := IIf(Len(_cLinha) < 005, _cLinha + Space(005 - Len(_cLinha)), _cLinha )
_cLinha := _cLinha + "                | "
_cLinha := IIf(Len(_cLinha) < 074, _cLinha + Space(074 - Len(_cLinha)), _cLinha )
_cLinha := _cLinha + "|"
_cLinha := IIf(Len(_cLinha) < 127, _cLinha + Space(127 - Len(_cLinha)), _cLinha )		
_cLinha := _cLInha + "|"
_cLinha := IIf(Len(_cLinha) < 150, _cLinha + Space(150 - Len(_cLinha)), _cLinha )
_cLinha := _cLinha + "|"				
_cLinha := IIf(Len(_cLinha) < 172, _cLinha + Space(172 - Len(_cLinha)), _cLinha )
_cLinha := _cLinha + CRLF
fGrava()

_cLinha := Space(03)
_cLinha := _cLinha + "|"
_cLinha := IIf(Len(_cLinha) < 005, _cLinha + Space(005 - Len(_cLinha)), _cLinha )
_cLinha := _cLinha + "Valor Total     | " +  cvaltochar(_nvlsc5)
_cLinha := IIf(Len(_cLinha) < 074, _cLinha + Space(074 - Len(_cLinha)), _cLinha )
_cLinha := _cLinha + "|"
_cLinha := IIf(Len(_cLinha) < 127, _cLinha + Space(127 - Len(_cLinha)), _cLinha )		
_cLinha := _cLInha + "|"
_cLinha := IIf(Len(_cLinha) < 150, _cLinha + Space(150 - Len(_cLinha)), _cLinha )
_cLinha := _cLinha + "|"				
_cLinha := IIf(Len(_cLinha) < 172, _cLinha + Space(172 - Len(_cLinha)), _cLinha )
_cLinha := _cLinha + CRLF
fGrava()
_cLinha := Space(03)
_cLinha := _cLinha + "|"
_cLinha := IIf(Len(_cLinha) < 005, _cLinha + Space(005 - Len(_cLinha)), _cLinha )
_cLinha := _cLinha + "Prazo de Pagto  | " + cvaltochar(_cprzsc5)
_cLinha := IIf(Len(_cLinha) < 074, _cLinha + Space(074 - Len(_cLinha)), _cLinha )
_cLinha := _cLinha + "|"
_cLinha := IIf(Len(_cLinha) < 127, _cLinha + Space(127 - Len(_cLinha)), _cLinha )		
_cLinha := _cLInha + "|"
_cLinha := IIf(Len(_cLinha) < 150, _cLinha + Space(150 - Len(_cLinha)), _cLinha )
_cLinha := _cLinha + "|"				
_cLinha := IIf(Len(_cLinha) < 172, _cLinha + Space(172 - Len(_cLinha)), _cLinha )
_cLinha := _cLinha + CRLF
fGrava()
_cLinha := Space(03)
_cLinha := _cLinha + "|"
_cLinha := IIf(Len(_cLinha) < 005, _cLinha + Space(005 - Len(_cLinha)), _cLinha )
_cLinha := _cLinha + "Vendedor        | " + _vendsc5
_cLinha := IIf(Len(_cLinha) < 074, _cLinha + Space(074 - Len(_cLinha)), _cLinha )
_cLinha := _cLinha + "|"
_cLinha := IIf(Len(_cLinha) < 127, _cLinha + Space(127 - Len(_cLinha)), _cLinha )		
_cLinha := _cLInha + "|"
_cLinha := IIf(Len(_cLinha) < 150, _cLinha + Space(150 - Len(_cLinha)), _cLinha )
_cLinha := _cLinha + "|"				
_cLinha := IIf(Len(_cLinha) < 172, _cLinha + Space(172 - Len(_cLinha)), _cLinha )
_cLinha := _cLinha + CRLF

fGrava()

//_cLinha := Replicate("-",172)
_cLinha := "   |                 |                                                    |                                                    |                      |" 
_cLinha := IIf(Len(_cLinha) < 172, _cLinha + Space(172 - Len(_cLinha)), _cLinha ) 
_cLinha := _cLinha + CRLF

fGrava()

_cAlias := ""

	For nI := 1 TO Len(_aTmpALT)

	
	// Campo Antes da Alteraï¿½ï¿½o
	//-------------------------
		If     _aTmpALT[nI,04] == "C"
		_cCpoOld := _aTmpALT[nI,09]
		Elseif _aTmpALT[nI,04] == "N"
		_cCpoOld := If(!Empty(_aTmpALT[nI,09]), Transform(_aTmpALT[nI,09],_aTmpALT[nI,03]), " ")
		Elseif _aTmpALT[nI,04] == "D"
		_cCpoOld := If(!Empty(_aTmpALT[nI,09]), DTOC(_aTmpALT[nI,09]), " ")
		Endif

	// Campo Depois da Alteraï¿½ï¿½o
	//--------------------------		    
		If     _aTmpALT[nI,04] == "C"
		_cCpoNew := _aTmpALT[nI,10]
		Elseif _aTmpALT[nI,04] == "N"
		_cCpoNew := If(!Empty(_aTmpALT[nI,10]), Transform(_aTmpALT[nI,10],_aTmpALT[nI,03]), " ") 
		Elseif _aTmpALT[nI,04] == "D"
		_cCpoNew := If(!Empty(_aTmpALT[nI,10]), DTOC(_aTmpALT[nI,10]), " ")
		Endif

		If _aTmpALt[nI,07] <> _cAlias
	
			If !Empty(_cAlias)

 			_cLinha := "   |                 |                                                    |                                                    |                      |" 
			_cLinha := IIf(Len(_cLinha) < 172, _cLinha + Space(172 - Len(_cLinha)), _cLinha ) 
			_cLinha := _cLinha + CRLF

			fGrava()   		

			Endif

		_cLinha := Space(03) + "|"
		_cLinha := _cLinha + Space(17) + "|"
		_cLinha := IIf(Len(_cLinha) < 23, _cLinha + Space(23 - Len(_cLinha)), _cLinha ) 
		_cLinha := _cLinha + _aTmpALt[nI,07]
		
			If _aTmpALt[nI,07] == "SC5"
			_cLinha := _cLinha + " - Cabeçalho do Pedido de Venda"
			Elseif _aTmpALt[nI,07] == "SC6"
			_cLinha := _cLinha + " - Itens do Pedido de Venda"		
			Endif
		
		_cLinha := IIf(Len(_cLinha) < 074, _cLinha + Space(074 - Len(_cLinha)), _cLinha )
		_cLinha := _cLinha + "|"
		_cLinha := IIf(Len(_cLinha) < 127, _cLinha + Space(127 - Len(_cLinha)), _cLinha )		
		_cLinha := _cLInha + "|"
		_cLinha := IIf(Len(_cLinha) < 150, _cLinha + Space(150 - Len(_cLinha)), _cLinha )
		_cLinha := _cLinha + "|"				
		_cLinha := IIf(Len(_cLinha) < 172, _cLinha + Space(172 - Len(_cLinha)), _cLinha )
		_cLinha := _cLinha + CRLF		
		
		fGrava()  
		
		//_cLinha := Replicate("-",172)
		_cLinha := "   |                 |                                                    |                                                    |                      |" 
		_cLinha := IIf(Len(_cLinha) < 172, _cLinha + Space(172 - Len(_cLinha)), _cLinha ) 
		_cLinha := _cLinha + CRLF		
		
		fGrava()   
		
			If _aTmpALt[nI,07] == "SC5"
			_cLinha := "   | TITULO          | DE                                                 | PARA                                               | INCLUIDO POR         | ALTERADO POR"        
			Else
			_cLinha := "IT | TITULO          | DE                                                 | PARA                                               | INCLUIDO POR         | ALTERADO POR"        			
			Endif

		_cLinha := IIf(Len(_cLinha) < 172, _cLinha + Space(172-Len(_cLinha)), _cLinha)
		_cLinha := _cLinha + CRLF		
		
		fGrava()  		
		
		//_cLinha := Replicate("-",172)
		_cLinha := "   |                 |                                                    |                                                    |                      |" 
		_cLinha := IIf(Len(_cLinha) < 172, _cLinha + Space(172 - Len(_cLinha)), _cLinha ) 
		_cLinha := _cLinha + CRLF
		
		fGrava()  		
	
		_cAlias := _aTmpALt[nI,07]	//	[9]	Alias

		Endif
    
	//_cLinha := Space(03)
	_cLinha := _aTmpALT[nI,08]									//	[08] Item
	_cLinha := IIf(Len(_cLinha) < 003, _cLinha + Space(003-Len(_cLinha)), _cLinha )    		
	_cLinha := _cLinha + "|"
	_cLinha := IIf(Len(_cLinha) < 005, _cLinha + Space(005-Len(_cLinha)), _cLinha )    		
   	_cLinha := _cLinha + Alltrim(_aTmpALT[nI,01])				//	[01] Titulo
   	_cLinha := IIf(Len(_cLinha) < 021, _cLinha + Space(021-Len(_cLinha)), _cLinha )
   	_cLinha := _cLinha + "|"
	_cLinha := IIf(Len(_cLinha) < 023, _cLinha + Space(023-Len(_cLinha)), _cLinha )    	
   	_cLinha := _cLinha + Substr(Alltrim(_cCpoOld),1,50)			//	[09] De
   	_cLinha := IIf(Len(_cLinha) < 074, _cLinha + Space(074-Len(_cLinha)), _cLinha )
   	_cLinha := _cLinha + "|"
   	_cLinha := IIf(Len(_cLinha) < 076, _cLinha + Space(076-Len(_cLinha)), _cLinha )
   	_cLinha := _cLinha + Substr(Alltrim(_cCpoNew),1,50)			//	[10] Para
   	_cLinha := IIf(Len(_cLinha) < 127, _cLinha + Space(127-Len(_cLinha)), _cLinha )    	
   	_cLinha := _cLinha + "|" 
   	_cLinha := IIf(Len(_cLinha) < 129, _cLinha + Space(129-Len(_cLinha)), _cLinha )    	    	
   	_cLinha := _cLinha + Substr(Alltrim(_aTmpALT[nI,11]),1,20)	//	[11] USERLGI
   	_cLinha := IIf(Len(_cLinha) < 150, _cLinha + Space(150-Len(_cLinha)), _cLinha )    	    	
   	_cLinha := _cLinha + "|"
	_cLinha := IIf(Len(_cLinha) < 152, _cLinha + Space(152-Len(_cLinha)), _cLinha )    	    	    	
   	_cLinha := _cLinha + Substr(Alltrim(_aTmpALT[nI,12]),1,20)	//	[12] USERLGA
   	_cLinha := IIf(Len(_cLinha) < 172, _cLinha + Space(172-Len(_cLinha)), _cLinha )    	    	
	_cLinha := _cLinha + CRLF		
		
	fGrava()      
		
		If Len(Alltrim(_cCpoOld)) > 50 .OR. Len(Alltrim(_cCpoNew)) > 50
		
			For xI := 51 TO Len(Alltrim(_cCpoOld)) Step 50
			
	   		_cLinha := Space(03)
			_cLinha := _cLinha + "|"
	    	_cLinha := IIf(Len(_cLinha) < 021, _cLinha + Space(021-Len(_cLinha)), _cLinha )
	    	_cLinha := _cLinha + "|"
			_cLinha := IIf(Len(_cLinha) < 023, _cLinha + Space(023-Len(_cLinha)), _cLinha )    	
	    	_cLinha := _cLinha + IIf(Len(Alltrim(_cCpoOld))>xI,Substr(Alltrim(_cCpoOld),xI,50),"")			//	[07] De
	    	_cLinha := IIf(Len(_cLinha) < 074, _cLinha + Space(074-Len(_cLinha)), _cLinha )
	    	_cLinha := _cLinha + "|"
	    	_cLinha := IIf(Len(_cLinha) < 076, _cLinha + Space(076-Len(_cLinha)), _cLinha )
	    	_cLinha := _cLinha + IIf(Len(Alltrim(_cCpoNew))>xI,Substr(Alltrim(_cCpoNew),xI,50),"")			//	[08] Para
	    	_cLinha := IIf(Len(_cLinha) < 127, _cLinha + Space(127-Len(_cLinha)), _cLinha )    	
	    	_cLinha := _cLinha + "|" 
	    	_cLinha := IIf(Len(_cLinha) < 150, _cLinha + Space(150-Len(_cLinha)), _cLinha )    	    	
	    	_cLinha := _cLinha + "|"
	    	_cLinha := IIf(Len(_cLinha) < 172, _cLinha + Space(172-Len(_cLinha)), _cLinha )    	    	
			_cLinha := _cLinha + CRLF					
				
			fGrava()      
    		                     
			Next xI
    		
		Endif
		
	Next nI

nLin0 := 1

	If _nHdl > 0 .AND. lContinua
		If fClose(_nHdl)
		//If nLin0 > 0
		//	Aviso('AVISO','Gerado o arquivo ' + AllTrim(_cNomeArq) + '...',{'OK'})
		//Else
		//	If fErase(_cNomeArq) == 0
		//		If lContinua
		//			Aviso('AVISO','Nao existem registros a serem gravados. A geracao do arquivo ' + AllTrim(_cNomeArq) + ' foi abortada ...',{'OK'})
		//		EndIf
		//	Else
		//		MsgAlert('Ocorreram problemas na tentativa de delecao do arquivo '+AllTrim(_cNomeArq)+'.')
		//	EndIf
		//EndIf
		Else
		//MsgAlert('Ocorreram problemas no fechamento do arquivo '+AllTrim(_cNomeArq)+'.')
		EndIf
	EndIf

Return()



Static Function fGrava()

	If fWrite(_nHdl,_cLinha,Len(_cLinha)) != Len(_cLinha)
		If !MsgYesNo('Ocorreu um erro na gravacao do arquivo '+AllTrim(_cNomeArq)+'.   Continua?','Atencao!')
		lContinua := .F.
		Return
		Endif
	Endif

Return()

Static Function ENV_MAIL()

Local lResulConn := .T.
Local lResulSend := .T.
Local cError := ""

Local cTitulo  := "Criar e-mail"
Local cServer  := Trim(GetMV("MV_RELSERV")) // smtp.ig.com.br ou 200.181.100.51
Local cEmail   := Trim(GetMV("MV_RELACNT")) // fulano@ig.com.br
Local cPass    := Trim(GetMV("MV_RELPSW"))  // 123abc

Local cDe      := Space(200)
Local cPara    := Space(200)
Local cCc      := Space(200)
Local cAssunto := Space(200)
Local cAnexo   := Space(200)
Local cMsg     := ""

Local _cUsr  := __cUSERID
Local _aUsr1 := {}
Local _aUsr2 := {}
Local _aUsr3 := {}

Local _eMailUsr  := ""
Local _eMailResp := SuperGetMV("MV_X_EMAIL")

	If Empty(cServer) .And. Empty(cEmail) .And. Empty(cPass)
   MsgAlert("Não foi definido os parametros do server do Protheus para envio de e-mail",cTitulo)
   Return
	Endif

//Identifica E_Mail do Usuario
//----------------------------
PswOrder(1)

	If PswSeek(_cUsr)
	_aUsr1 := PswRet(1)
	_aUsr2 := PswRet(2)
	_aUsr3 := PswRet(3)
	Endif

_eMailUsr := _aUsr1[1,14]

//cEmail   := "microsiga@sp_inetserver.gruposhangrila.com.br"
//cPass    := "adm391"

cDe      := _eMailUsr		//	"microsiga@gruposhangrila.com.br"
//cPara    := "adriana.mendes@gruposhangrila.com.br,diana.machado@gruposhangrila.com.br"  	//	"microsiga@gruposhangrila.com.br"
cPara    := "adriana.mendes@gruposhangrila.com.br"  	//	"microsiga@gruposhangrila.com.br"
//cPara    := "marcos@fixsystem.com.br"
cCC      := ""//_eMailResp		//	
cCC      := ""//_eMailResp		//	
cAssunto := "Alteração do Pedido " + SC5->C5_NUM + '-' + Alltrim(Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_NOME"))
cAnexo   := "\system\" + _cNomeArq
cMsg     := "Segue arquivo com dados alterados do pedido de Venda"


/*// Rotina para envio do E_Mail
//----------------------------
CONNECT SMTP SERVER cServer ACCOUNT cEmail PASSWORD cPass RESULT lResulConn

	If !lResulConn
   GET MAIL ERROR cError
   MsgAlert("Falha na conexão "+cError)
   Return(.F.)
	Endif

// Sintaxe: SEND MAIL FROM cDe TO cPara CC cCc SUBJECT cAssunto BODY cMsg ATTACHMENT cAnexo RESULT lResulSend
// Todos os e-mail terï¿½o: De, Para, Assunto e Mensagem, porï¿½m precisa analisar se tem: Com Cï¿½pia e/ou Anexo

	If Empty(cCc) .And. Empty(cAnexo)
	SEND MAIL FROM cDe TO cPara SUBJECT cAssunto BODY cMsg RESULT lResulSend
	Else
		If Empty(cCc) .And. !Empty(cAnexo)
		SEND MAIL FROM cDe TO cPara SUBJECT cAssunto BODY cMsg ATTACHMENT cAnexo RESULT lResulSend   
		ElseIf !Empty(cCc) .And. Empty(cAnexo)
		SEND MAIL FROM cDe TO cPara CC cCc SUBJECT cAssunto BODY cMsg RESULT lResulSend   
		Else
		SEND MAIL FROM cDe TO cPara CC cCc SUBJECT cAssunto BODY cMsg ATTACHMENT cAnexo RESULT lResultSend   		   
		Endif
	Endif
   
	If !lResulSend
   GET MAIL ERROR cError
   MsgAlert("Falha no Envio do e-mail " + cError)
	Endif

DISCONNECT SMTP SERVER
*/

//==========NOVA CONFIGURAÇÃO DO ENVIO DO E-MAIL

	Private cMensagem 	:= "Segue arquivo com dados alterados do pedido de Venda"

	Private oServer
	Private oMessage
	Private nMOb
	Private nErr      	 := 0
	Private _lSSL     	 := .T. //SuperGetMv("MV_RELSSL" ,,.F.)           	// Usa SSL Seguro
	Private _lTLS     	 := .T. //SuperGetMv("MV_RELTLS" ,,.F.)           	// Usa TLS Seguro
	Private _lConfirm 	 := .T.	                                 		// Confirmação de leitura
	Private cPopAddr  	 := "" //GetMv("MV_POPORC")                          // POP
	Private cSMTPAddr 	 := "smtp.gruposhangrila.com.br"
	//Trim(GetMV("MV_RELSERV"))//"smtp.gmail.com" //GetMv("MV_SMTPORC")							// SMTP
	Private cPOPPort  	 := 110
	//(SuperGetMv("MV_RELPORP" ,,110))		 	// Porta do servidor POP		******
	Private cSMTPPort 	 := 587
	//587 //(SuperGetMv("MV_RELPORS" ,,587))		 	// Porta do servidor SMTP		******
	Private cUser     	 := "nfe@gruposhangrila.com.br" //Trim(GetMV("MV_RELACNT"))//"sgvbot@grandvivant.com.br"					// Usuario que ira realizar a autenticação
	Private cPass    	 := "Pena@2020" //Trim(GetMV("MV_RELPSW"))//"Pobrejuan@2020"		 		 				// Senha do usuario
	Private nSMTPTime 	 := 120 //(SuperGetMv("MV_RELTIME" ,,120))		 	// Timeout SMTP


//	Private cMsg := ""
//	Private xRet
//	Private oServer, oMessage
//	Private lMailAuth	:= SuperGetMv("MV_RELAUTH",,.F.)
//	Private nPorta := 587 //informa a porta que o servidor SMTP irá se comunicar, podendo ser 25 ou 587

//_cAssunto := ""	
//	_cAnexo := "\workflow\compras\" + _cFil + _cNumPC + ".pdf"

//cAssunto :=  "Alteração do Pedido " + SC5->C5_NUM
//Default _cAssunto := "Alteração do Pedido " + SC5->C5_NUM
//Default  Titulo   := ""
//Default _cMsg     := ""                      	
//Default _cMail    := ""
//Default _cFromOri := ""
//Default _lExcAnex := .T.
	_lAlert   := .T.
//Public _aAnexTemp := ""
	Public _lRetMail  := .T.

// Instancia um novo TMailManager
	oServer := tMailManager():New()
	If _lSSL
		// Usa SSL na conexao
		oServer:SetUseSSL(_lSSL)
	EndIf
	If _lTLS
		//Define no envio de e-mail o uso de STARTTLS durante o protocolo de comunicação (Indica se, verdadeiro .T., utilizará a comunicação segura através de SSL/TLS; caso contrário, .F.)
		oServer:SetUseTLS(_lTLS)
	EndIf

//Inicializa
	oServer:Init(cPopAddr, cSMTPAddr, cUser, cPass, cPOPPort, cSMTPPort)

//Define o Timeout SMTP
	If oServer:SetSMTPTimeout(nSMTPTime) != 0
		If _lAlert
			MsgAlert(DTOC(Date()) + " " + Time() + " - " + "[ERROR] Falha ao definir timeout!","_002")
		EndIf
		_lRetMail := .F.
		Return(_lRetMail)
	EndIf

// Conecta ao servidor
	nErr := oServer:SMTPConnect()
	If nErr <> 0
		If _lAlert
			MsgAlert(DTOC(Date()) + " " + Time() + " - " + "[ERROR] Falha ao conectar: " + AllTrim(Str(nErr)) + " - " + AllTrim(oServer:GetErrorString(nErr)) + "!","_003")
		EndIf
		_lRetMail := .F.
		Return(_lRetMail)
	EndIf

// Realiza autenticação no servidor
	nErr := oServer:SmtpAuth(cUser, cPass)
	If nErr <> 0
		If _lAlert
			MsgAlert(DTOC(Date()) + " " + Time() + " - " + "[ERROR] Falha ao autenticar: " + AllTrim(Str(nErr)) + " - " + AllTrim(oServer:getErrorString(nErr)) + "!","_004")
		EndIf
		oServer:SmtpDisconnect()
		_lRetMail := .F.
		Return(_lRetMail)
	EndIf

// Cria uma nova mensagem atraves da Classe TMailMessage
	oMessage := tMailMessage():New()
	oMessage:Clear()
	oMessage:cFrom := Trim(GetMV("MV_RELACNT"))//'sgvbot@grandvivant.com.br'
	oMessage:cTo   := cPara
	oMessage:AttachFile( cAnexo )

	_cMsg := "Segue arquivo com dados alterados do pedido de Venda"


	oMessage:cSubject := AllTrim(cAssunto)
	_cTexto := "<html>"
	_cTexto += "	<head>"
	_cTexto += "		<title>"
	_cTexto += "			" + oMessage:cSubject
	_cTexto += "		</title>"
	_cTexto += "	</head>"
	_cTexto += "	<body>"
	_cTexto += "		<hr size=2 width='100%' align=center>"
	_cTexto += "		<BR>"
	_cTexto += 			StrTran(_cMsg,CHR(10),"<BR>")
	_cTexto += "		<BR>"
	_cTexto += "		<hr size=2 width='100%' align=center>"
	_cTexto += "		<BR>"
	_cTexto += "	</body>"
	_cTexto += "</html>"

	oMessage:cBody := _cTexto
	oMessage:MsgBodyType("text/html")


/*
	If !Empty(_cCC)
	oMessage:cCC   := AllTrim(_cCC)
	EndIf
	If !Empty(_cBCC)
	oMessage:cBCC := AllTrim(_cBCC)
	EndIf */

//Verifica() 
	
//If !Empty(_cFromOri)
//	oMessage:cFrom := _cFromOri
//EndIf

// Envia a mensagem
nErr := oMessage:Send(oServer)
	If nErr <> 0
		If _lAlert
		MsgAlert(DTOC(Date()) + " " + Time() + " - " + "[ERROR] Falha ao enviar: " + AllTrim(Str(nErr)) + " - " + AllTrim(oServer:GetErrorString(nErr)) + "!","_006")
		EndIf
	oServer:SmtpDisconnect()
	_lRetMail := .F.
	Return(_lRetMail)
	Else
	
	MsgAlert("E-mail enviado com sucesso, reclock sendo executado no campo de envio.")
	_cConfMail := "S"

	Endif

//Desconecto do servidor
	If oServer:SmtpDisconnect()!= 0
		If _lAlert
		MsgAlert(DTOC(Date()) + " " + Time() + " - " + "[ERROR] Erro ao desconectar do servidor SMTP!","_007")
		EndIf
	EndIf

//Return()




Return(.T.)

/*
------------------------------------------------------------------------------
Programa : RGrvSC5			| Tipo: Ponto de Entrada		| Rotina: MATA410
Data     : 19/03/07
------------------------------------------------------------------------------
Descricao: - Grava pedido com bloqueio
*** Variaveis publicas declaradas em RSHXF03 (Gatilho no C5_CLIENTE)
------------------------------------------------------------------------------
*/
Static Function RGrvSC5()
	RecLock("SC5",.F.)
	If _xlBlqRegra
		SC5->C5_BLQ := '1' 		//1-Bloqueio de regra
	EndIf
	If _xlBlqVerba
		SC5->C5_BLQ := '2'		//2-Bloqueio Verba
	EndIf
	SC5->C5_PESOL := 0 //nPesoLiqT
	SC5->C5_PBRUTO:= 0 //nPesoBrtT
	SC5->C5_XDATALI:=dDataBase

	MsUnlock()
/*
----------------------------------------------------
Rotina para montar o pedido de venda no e-mail
----------------------------------------------------*/
	If _xlBlqRegra .Or. _xlBlqVerba
	U_RShXF08()
	Endif
Return
	
		
//         1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17
//1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
//123|12345678901234567|1234567890123456789012345678901234567890123456789012|1234567890123456789012345678901234567890123456789012|1234567890123456789012|123456789012345678901 
//   | Pedido Numero   | XXXXXX - XXXXXXXXXXX                               |                                                    |                      |
//   |                 |                                                    |                                                    |                      |                     
//   |                 | SC5 - Cabeï¿½alho dos Pedido de Venda                |                                                    |                      |
//   |                 |                                                    |                                                    |                      |                     
//   | TITULO          | DE                                                 | PARA                                               | INCLUIDO POR         | ALTERADO POR        
//   |                 |                                                    |                                                    |                      |                      
//   | TITULO          | 12345678901234567890123456789012345678901234567890 | 12345678901234567890123456789012345678901234567890 | 12345678901234567890 | 12345678901234567890 
//   | TITULO          | 12345678901234567890123456789012345678901234567890 | 12345678901234567890123456789012345678901234567890 | 12345678901234567890 | 12345678901234567890 
//   |                 | 12345678901234567890123456789012345678901234567890 | 12345678901234567890123456789012345678901234567890 |                      |                      
//   | TITULO          | 12345678901234567890123456789012345678901234567890 | 12345678901234567890123456789012345678901234567890 | 12345678901234567890 | 12345678901234567890 
//   |                 |                                                    |                                                    |                      |                     
//   |                 | SC6 - Itens do Pedido de Venda                     |                                                    |                      |
//   |                 |                                                    |                                                    |                      |                     
//IT | TITULO          | DE                                                 | PARA                                               | INCLUIDO POR         | ALTERADO POR        
//   |                 |                                                    |                                                    |                      |                     
//01 | TITULO          | 12345678901234567890123456789012345678901234567890 | 12345678901234567890123456789012345678901234567890 | 12345678901234567890 | 12345678901234567890  
//02 | TITULO          | 12345678901234567890123456789012345678901234567890 | 12345678901234567890123456789012345678901234567890 | 12345678901234567890 | 12345678901234567890  
//   |                 | 12345678901234567890123456789012345678901234567890 | 12345678901234567890123456789012345678901234567890 |                      |                     
//03 | TITULO          | 12345678901234567890123456789012345678901234567890 | 12345678901234567890123456789012345678901234567890 | 12345678901234567890 | 12345678901234567890 
//
    
