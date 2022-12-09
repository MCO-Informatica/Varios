#INCLUDE "protheus.ch"

/////////////////////////////////////////////////////////////////////////////////////
//+-------------------------------------------------------------------------------+//
//| PROGRAMA  | M410AGRV.PRW         | AUTOR | rdSolution     | DATA | 09/02/2007 |//
//+-------------------------------------------------------------------------------+//
//| DESCRICAO | Ponto de Entrada - M410AGRV()                                     |//
//|           | Este ponto esta localizado antes da alteração dos dados do pedido |//
//|           | venda e tem como objetivo guardar nos arrays os dados do pedido   |//
//|           | pedido de venda original.                                         |//
//+-------------------------------------------------------------------------------+//
/////////////////////////////////////////////////////////////////////////////////////
User Function M410AGRV()

Local _aAreaSC5  := SC5->(getArea())
Local _aAreaSC6  := SC6->(getArea())

Local _cConteudo := ""

Public _aTmpSC5  := {}
Public _aTmpSC6  := {}
Public _aOldSC5  := {}
Public _aOldSC6  := {}

// Monta Array Temporario do SC5
//------------------------------
SX3->( dbSetOrder(01) )
SX3->( dbSeek("SC5") )

While !SX3->(Eof()) .AND. SX3->X3_ARQUIVO == "SC5"

	If Alltrim(SX3->X3_CAMPO) $ "C5_USERLGI|C5_USERLGA"
		SX3->( dbSkip() )
		Loop
	Endif	

	If X3USO(SX3->X3_USADO) .AND. cNivel >= SX3->X3_NIVEL .AND. SX3->X3_CONTEXT <> "V"
	
		If     SX3->X3_TIPO == "C"
				_cConteudo := Space(SX3->X3_TAMANHO)
        Elseif SX3->X3_TIPO == "N"
        		_cConteudo := 0
        Elseif SX3->X3_TIPO == "D"
        		_cConteudo := CriaVar(SX3->X3_Campo)
        Elseif SX3->X3_tipo == "C"
        		_cConteudo := ""
        Else
                _cConteudo :=  .F.
        Endif
        
		AADD(_aTmpSC5,{Alltrim(X3Titulo()) ,;	//[01] Titulo
				       SX3->X3_CAMPO       ,;	//[02] Nome do Campo
				       SX3->X3_PICTURE     ,;	//[03] Picture
       				   SX3->X3_TIPO        ,;   //[04] Tipo do Campo
				       SX3->X3_TAMANHO     ,;	//[05] Tamanho
				       SX3->X3_DECIMAL     ,;	//[06] Casas Decimais
				       _cConteudo          } )	//[07] Dado do Campo
        
		//AADD(_aTmpSC5,{ SX3->X3_CAMPO, "" } )		
		
	Endif
	
	SX3->( dbSkip() )
	
Enddo		

// Carrega o Array com os dados do SC5
//------------------------------------
For nI := 1 To Len(_aTmpSC5)

	_aTmpSC5[nI,7] := &("SC5->"+_aTmpSC5[nI,2])	 	//  Conteudo
	//_aTmpSC5[nI,8] := Embaralha(SC5->C5_USERLGI,1)	//	USER LGI
	//_aTmpSC5[nI,9] := Embaralha(SC5->C5_USERLGA,1)	//	USER LGA
		
Next nI	


dbSelectArea("SC5")

aadd( _aOldSC5, Array(Len(_aTmpSC5)))                    

For nI := 1 TO Len(_aTmpSC5)
	
	_aOldSC5[Len(_aOldSC5)][nI] := FieldGet( FieldPos( _aTmpSC5[nI][2] ) )		
		
Next nI	

RestArea(_aAreaSC5)

// Monta Array Temporario do SC6
//------------------------------
//_aStrSC6 := {}
//
//SX3->( dbSetOrder(01) )
//SX3->( dbSeek("SC6") )
//
//While !SX3->(Eof()) .AND. SX3->X3_ARQUIVO == "SC6"
//
//	If X3USO(SX3->X3_USADO) .AND. cNivel >= SX3->X3_NIVEL .AND. SX3->X3_CONTEXT <> "V"
//	
//		AADD(_aStrSC6, SX3->X3_CAMPO )	//Campos
//		
//	Endif
//	
//	SX3->( dbSkip() )	
//	
//Enddo	

SX3->( dbSetOrder(01) )
SX3->( dbSeek("SC6") )

While !SX3->(Eof()) .AND. SX3->X3_ARQUIVO == "SC6"

	If Alltrim(SX3->X3_CAMPO) $ "C6_USERLGI|C6_USERLGA"
		SX3->( dbSkip() )
		Loop
	Endif	

	If X3USO(SX3->X3_USADO) .AND. cNivel >= SX3->X3_NIVEL .AND. SX3->X3_CONTEXT <> "V"
	
		If     SX3->X3_TIPO == "C"
				_cConteudo := Space(SX3->X3_TAMANHO)
       	Elseif SX3->X3_TIPO == "N"
       			_cConteudo := 0
       	Elseif SX3->X3_TIPO == "D"
       			_cConteudo := CriaVar(SX3->X3_Campo)
       	Elseif SX3->X3_tipo == "C"
       			_cConteudo := ""
       	Else
           	    _cConteudo :=  .F.
       	Endif	

		AADD(_aTmpSC6,{Alltrim(X3Titulo()) ,;	//[01] Titulo
				       SX3->X3_CAMPO       ,;	//[02] Nome do Campo
				       SX3->X3_PICTURE     ,;	//[03] Picture
   					   SX3->X3_TIPO        ,;   //[04] Tipo do Campo
			      	   SX3->X3_TAMANHO     ,;	//[05] Tamanho
			     	   SX3->X3_DECIMAL     ,;	//[06] Casas Decimais
			       	   _cConteudo          } )	//[07] Dado do Campo
				       
		//Aadd(_aTmpSC6,{ SX3->X3_CAMPO, "" } )		
		
	Endif
	
	SX3->( dbSkip() )
	
Enddo  

// Carrega o Array com os dados do SC6
//------------------------------------
_cItem := "00"
dbSelectArea( "SC6" )
SC6->( dbSetOrder(01) )
SC6->( dbSeek( xFilial("SC6") + SC5->C5_NUM ) )
While !SC6->(Eof()) .AND. SC6->C6_FILIAL == xFilial("SC6") ;
                    .AND. SC6->C6_NUM == SC5->C5_NUM
                    
	_cItem := Soma1(_cItem)
	
	while _cItem < SC6->C6_ITEM
		
		aadd( _aOldSC6, Array(Len(_aTmpSC6)+3))                    	
		
		_aOldSC6[Len(_aOldSC6)][Len(_aTmpSC6)+1] := _cItem
		
		_cItem := Soma1(_cItem)
		
	Enddo	                    
                    
	aadd( _aOldSC6, Array(Len(_aTmpSC6)+3))                    

	// Carrega o Array com os dados do SC6
	//------------------------------------
	For nI := 1 TO Len(_aTmpSC6)
	
		_aOldSC6[Len(_aOldSC6)][nI] := FieldGet( FieldPos( _aTmpSC6[nI][2] ) )		
		
	Next nI	

	_aOldSC6[Len(_aOldSC6)][Len(_aTmpSC6)+1] := SC6->C6_ITEM
	_aOldSC6[Len(_aOldSC6)][Len(_aTmpSC6)+2] := Substr(Embaralha(SC6->C6_USERLGI,1),1,15)
	_aOldSC6[Len(_aOldSC6)][Len(_aTmpSC6)+3] := Substr(Embaralha(SC6->C6_USERLGA,1),1,15)

	//For nI := 1 To Len(_aTmpSC6)
	//	_aTmpSC6[nI,07] := &("SC6->"+_aTmpSC6[nI,02])	//  Conteudo
	//	_aTmpSC6[nI,08] := Embaralha(SC6->C6_USERLGI,1)	//	USER LGI
	//	_aTmpSC6[nI,09] := Embaralha(SC6->C6_USERLGA,1)	//	USER LGA
	//	_aTmpSC6[nI,10] := SC6->C6_ITEM                 //	ITEM DO PEDIDO
	//Next nI			
	
	SC6->( dbSkip() )
	
Enddo		

// Carrega o Array com os dados do SC6
//------------------------------------
//SC6->( dbSetOrder(01) )
//SC6->( dbSeek( xFilial("SC6") + SC5->C5_NUM ) )
//While !SC6->(Eof()) .AND. SC6->C6_FILIAL == xFilial("SC6") ;
//                    .AND. SC6->C6_NUM == SC5->C5_NUM
//
//
//	// Carrega o Array com os dados do SC6
//	//------------------------------------
//	//For nI := 1 To Len(_aTmpSC6)
//  //
//	//	_aTmpSC6[nI,07] := &("SC6->"+_aTmpSC6[nI,02])	//  Conteudo
//	//	_aTmpSC6[nI,08] := Embaralha(SC6->C6_USERLGI,1)	//	USER LGI
//	//	_aTmpSC6[nI,09] := Embaralha(SC6->C6_USERLGA,1)	//	USER LGA
//	//	_aTmpSC6[nI,10] := SC6->C6_ITEM                 //	ITEM DO PEDIDO
//	//
//	//Next nI			
//	
//	SC6->( dbSkip() )
//	
//Enddo		

RestArea(_aAreaSC6)

Return()

