#Include "protheus.ch"
#Include "rwmake.ch"
#Include "tbiconn.ch"

User Function MyMata261()
Local nregistro := len(oLista:Acols)
	
	processa( {|| u_Mata261_b( nRegistro ) }, "Transferencia", "Processando aguarde...", .f.)

Return(SB8->B8_LOTEFORN)  


User Function Mata261_b(nRegistro)
Local aAuto := {}
Local aLinha := {}
Local nX
Local nY
Local nOpcAuto := 3
Local vQuant := 0
Local vDoc := " " 

procregua(nRegistro)

Private lMsErroAuto := .F.
//Cabecalho a Incluir
vDoc := GetSxeNum("SD3","D3_DOC")
aadd(aAuto,{vDoc,dDataBase}) //Cabecalho

//Itens a Incluir
aItem := {}

nItem := 0

for nY := 1 to len(oLista:Acols) 
  If ValType (oLista:aCols[nY,26]) == "L"
	if !oLista:aCols[nY,26]
		vQtd := 0
		If valtype(oLista:aCols[nY,18]) <> "N"
			vQtd:= VAL(StrTran(oLista:aCols[nY,18],",","."))  
			oLista:aCols[nY,18] := VAL(StrTran(oLista:aCols[nY,18],",","."))
		else
			vQtd:= oLista:aCols[nY,18]
		Endif
		
	
		vQuant := vQuant + vQtd
		nItem++
	endif
 Endif
   
Next nY

If vQuant <> (SDA->DA_QTDORI-SDA->DA_SALDO)
	MSGALERT( "Quantidade distribuida é diferente do saldo a distribuir disponivel. Qtd distribuida -> " + Alltrim(STR(vQuant)) + ;
	"  |  Qtd Documento ->" + Alltrim(STR((SDA->DA_QTDORI-SDA->DA_SALDO)))  , "Inclusao" )
	Return()
Endif

for nX := 1 to nItem
  If ValType (oLista:aCols[nX,26]) == "L"
	aLinha := {}
	
	//Origem
//	aadd(aLinha,{"ITEM",oLista:aCols[nX,3],Nil})
	aadd(aLinha,{"ITEM",STRZERO(NX,3),Nil})
	aadd(aLinha,{"D3_COD", PadR(oLista:aCols[nX,3],tamsx3('D3_COD')[1]), Nil}) //Cod Produto origem
	aadd(aLinha,{"D3_DESCRI", PadR(oLista:aCols[nX,4],tamsx3('D3_DESCRI')[1]), Nil}) //descr produto origem
	aadd(aLinha,{"D3_UM", PadR(oLista:aCols[nX,5],tamsx3('D3_UM')[1]), Nil}) //unidade medida origem
	aadd(aLinha,{"D3_LOCAL", PadR(oLista:aCols[nX,6],tamsx3('D3_LOCAL')[1]), Nil}) //armazem origem
	aadd(aLinha,{"D3_LOCALIZ", PadR(oLista:aCols[nX,7],tamsx3('D3_LOCALIZ')[1]),Nil}) //Informar endereço origem
	
	//Destino
	aadd(aLinha,{"D3_COD", PadR(oLista:aCols[nX,8],tamsx3('D3_COD')[1]), Nil}) //cod produto destino
	aadd(aLinha,{"D3_DESCRI", PadR(oLista:aCols[nX,9],tamsx3('D3_DESCRI')[1]), Nil}) //descr produto destino
	aadd(aLinha,{"D3_UM", PadR(oLista:aCols[nX,10],tamsx3('D3_UM')[1]), Nil}) //unidade medida destino
	aadd(aLinha,{"D3_LOCAL", PadR(oLista:aCols[nX,11],tamsx3('D3_LOCAL')[1]), Nil}) //armazem destino
	aadd(aLinha,{"D3_LOCALIZ", PadR(oLista:aCols[nX,12],tamsx3('D3_LOCALIZ')[1]),Nil}) //Informar endereço destino
	
	aadd(aLinha,{"D3_NUMSERI", PadR(oLista:aCols[nX,13],tamsx3('D3_NUMSERI')[1]), Nil}) //Numero serie
	aadd(aLinha,{"D3_LOTECTL", PadR(oLista:aCols[nX,14],tamsx3('D3_LOTECTL')[1]), Nil}) //Lote Origem
	aadd(aLinha,{"D3_NUMLOTE", PadR(oLista:aCols[nX,15],tamsx3('D3_NUMLOTE')[1]), Nil}) //sublote origem
	
	aadd(aLinha,{"D3_DTVALID", oLista:aCols[nX,16], Nil}) //data validade
	aadd(aLinha,{"D3_POTENCI", 0 , Nil}) // Potencia
	If ValType (oLista:aCols[nX,18]) <> "N"  
		aadd(aLinha,{"D3_QUANT", VAL(StrTran(oLista:aCols[nX,18],",",".")), Nil}) //Quantidade
	Else
		aadd(aLinha,{"D3_QUANT", oLista:aCols[nX,18], Nil}) //Quantidade
	Endif	
	
	aadd(aLinha,{"D3_QTSEGUM", 0, Nil}) //Seg unidade medida
	aadd(aLinha,{"D3_ESTORNO", "", Nil}) //Estorno
	aadd(aLinha,{"D3_NUMSEQ", "", Nil}) // Numero sequencia D3_NUMSEQ
	
	aadd(aLinha,{"D3_LOTECTL", PadR(oLista:aCols[nX,23],tamsx3('D3_LOTECTL')[1]), Nil}) //Lote destino
	aadd(aLinha,{"D3_NUMLOTE", " ", Nil}) //sublote destino
	aadd(aLinha,{"D3_DTVALID", oLista:aCols[nX,25], Nil}) //validade lote destino
	aadd(aLinha,{"D3_ITEMGRD", "", Nil}) //Item Grade
	
	aadd(aLinha,{"D3_CODLAN", "", Nil}) //cat83 prod origem
	aadd(aLinha,{"D3_CODLAN", "", Nil}) //cat83 prod destino
	
	aAdd(aAuto,aLinha)

  Endif

  If nItem > 200
  	stsExec := ROUND((nItem / 200), 0) 
  else
  	stsExec := 1
  Endif
  
  
  If stsExec = 1 
  		if nX == nItem
			incproc("Criando Documento unico")
			nOpcAuto := 3 // Inclusao
			MSExecAuto({|x,y| mata261(x,y)},aAuto,nOpcAuto)
		Endif
		
   ElseIf stsExec = 2
	   if nX = 200
			incproc("Criando Documento 1")
			nOpcAuto := 3 // Inclusao
			MSExecAuto({|x,y| mata261(x,y)},aAuto,nOpcAuto)
			
			aLinha := {}
			aAuto := {}
			vDoc := GetSxeNum("SD3","D3_DOC")
			aadd(aAuto,{vDoc,dDataBase}) //Cabecalho	  
		endif


	   if nX = nItem
			incproc("Criando Documento 2")
			nOpcAuto := 3 // Inclusao
			MSExecAuto({|x,y| mata261(x,y)},aAuto,nOpcAuto)
       endif

   ElseIf stsExec = 3
	   if nX = 200
			incproc("Criando Documento 1")
			nOpcAuto := 3 // Inclusao
			MSExecAuto({|x,y| mata261(x,y)},aAuto,nOpcAuto)
			
			aLinha := {}
			aAuto := {}
			vDoc := GetSxeNum("SD3","D3_DOC")
			aadd(aAuto,{vDoc,dDataBase}) //Cabecalho	  
		endif

	   if nX = 400
			incproc("Criando Documento 2")
			nOpcAuto := 3 // Inclusao
			MSExecAuto({|x,y| mata261(x,y)},aAuto,nOpcAuto)
			
			aLinha := {}
			aAuto := {}
			vDoc := GetSxeNum("SD3","D3_DOC")
			aadd(aAuto,{vDoc,dDataBase}) //Cabecalho	  
		endif

	   if nX = nItem
			incproc("Criando Documento 3")
			nOpcAuto := 3 // Inclusao
			MSExecAuto({|x,y| mata261(x,y)},aAuto,nOpcAuto)
		endif

   ElseIf stsExec = 4
	   if nX = 200
			incproc("Criando Documento 1")
			nOpcAuto := 3 // Inclusao
			MSExecAuto({|x,y| mata261(x,y)},aAuto,nOpcAuto)
			
			aLinha := {}
			aAuto := {}
			vDoc := GetSxeNum("SD3","D3_DOC")
			aadd(aAuto,{vDoc,dDataBase}) //Cabecalho	  
		endif

	   if nX = 400
			incproc("Criando Documento 2")
			nOpcAuto := 3 // Inclusao
			MSExecAuto({|x,y| mata261(x,y)},aAuto,nOpcAuto)
			
			aLinha := {}
			aAuto := {}
			vDoc := GetSxeNum("SD3","D3_DOC")
			aadd(aAuto,{vDoc,dDataBase}) //Cabecalho	  
		endif

	   if nX = 600
			incproc("Criando Documento 2")
			nOpcAuto := 3 // Inclusao
			MSExecAuto({|x,y| mata261(x,y)},aAuto,nOpcAuto)
			
			aLinha := {}
			aAuto := {}
			vDoc := GetSxeNum("SD3","D3_DOC")
			aadd(aAuto,{vDoc,dDataBase}) //Cabecalho	  
		endif
	   if nX = nItem
			incproc("Criando Documento 3")
			nOpcAuto := 3 // Inclusao
			MSExecAuto({|x,y| mata261(x,y)},aAuto,nOpcAuto)
       endif

   ElseIf stsExec = 5
	   if nX = 200
			incproc("Criando Documento 1")
			nOpcAuto := 3 // Inclusao
			MSExecAuto({|x,y| mata261(x,y)},aAuto,nOpcAuto)
			
			aLinha := {}
			aAuto := {}
			vDoc := GetSxeNum("SD3","D3_DOC")
			aadd(aAuto,{vDoc,dDataBase}) //Cabecalho	  
		endif

	   if nX = 400
			incproc("Criando Documento 2")
			nOpcAuto := 3 // Inclusao
			MSExecAuto({|x,y| mata261(x,y)},aAuto,nOpcAuto)
			
			aLinha := {}
			aAuto := {}
			vDoc := GetSxeNum("SD3","D3_DOC")
			aadd(aAuto,{vDoc,dDataBase}) //Cabecalho	  
		endif

	   if nX = 600
			incproc("Criando Documento 2")
			nOpcAuto := 3 // Inclusao
			MSExecAuto({|x,y| mata261(x,y)},aAuto,nOpcAuto)
			
			aLinha := {}
			aAuto := {}
			vDoc := GetSxeNum("SD3","D3_DOC")
			aadd(aAuto,{vDoc,dDataBase}) //Cabecalho	  
		endif
		
	   if nX = 800
			incproc("Criando Documento 2")
			nOpcAuto := 3 // Inclusao
			MSExecAuto({|x,y| mata261(x,y)},aAuto,nOpcAuto)
			
			aLinha := {}
			aAuto := {}
			vDoc := GetSxeNum("SD3","D3_DOC")
			aadd(aAuto,{vDoc,dDataBase}) //Cabecalho	  
		endif
		
	   if nX = nItem
			incproc("Criando Documento 3")
			nOpcAuto := 3 // Inclusao
			MSExecAuto({|x,y| mata261(x,y)},aAuto,nOpcAuto)
       endif

   ElseIf stsExec = 6
	   if nX = 200
			incproc("Criando Documento 1")
			nOpcAuto := 3 // Inclusao
			MSExecAuto({|x,y| mata261(x,y)},aAuto,nOpcAuto)
			
			aLinha := {}
			aAuto := {}
			vDoc := GetSxeNum("SD3","D3_DOC")
			aadd(aAuto,{vDoc,dDataBase}) //Cabecalho	  
		endif

	   if nX = 400
			incproc("Criando Documento 2")
			nOpcAuto := 3 // Inclusao
			MSExecAuto({|x,y| mata261(x,y)},aAuto,nOpcAuto)
			
			aLinha := {}
			aAuto := {}
			vDoc := GetSxeNum("SD3","D3_DOC")
			aadd(aAuto,{vDoc,dDataBase}) //Cabecalho	  
		endif

	   if nX = 600
			incproc("Criando Documento 2")
			nOpcAuto := 3 // Inclusao
			MSExecAuto({|x,y| mata261(x,y)},aAuto,nOpcAuto)
			
			aLinha := {}
			aAuto := {}
			vDoc := GetSxeNum("SD3","D3_DOC")
			aadd(aAuto,{vDoc,dDataBase}) //Cabecalho	  
		endif
		
	   if nX = 800
			incproc("Criando Documento 2")
			nOpcAuto := 3 // Inclusao
			MSExecAuto({|x,y| mata261(x,y)},aAuto,nOpcAuto)
			
			aLinha := {}
			aAuto := {}
			vDoc := GetSxeNum("SD3","D3_DOC")
			aadd(aAuto,{vDoc,dDataBase}) //Cabecalho	  
		endif  
		
		if nX = 1000
			incproc("Criando Documento 2")
			nOpcAuto := 3 // Inclusao
			MSExecAuto({|x,y| mata261(x,y)},aAuto,nOpcAuto)
			
			aLinha := {}
			aAuto := {}
			vDoc := GetSxeNum("SD3","D3_DOC")
			aadd(aAuto,{vDoc,dDataBase}) //Cabecalho	  
		endif
		
	   if nX = nItem
			incproc("Criando Documento 3")
			nOpcAuto := 3 // Inclusao
			MSExecAuto({|x,y| mata261(x,y)},aAuto,nOpcAuto)
       endif

   ElseIf stsExec = 7
	   if nX = 200
			incproc("Criando Documento 1")
			nOpcAuto := 3 // Inclusao
			MSExecAuto({|x,y| mata261(x,y)},aAuto,nOpcAuto)
			
			aLinha := {}
			aAuto := {}
			vDoc := GetSxeNum("SD3","D3_DOC")
			aadd(aAuto,{vDoc,dDataBase}) //Cabecalho	  
		endif

	   if nX = 400
			incproc("Criando Documento 2")
			nOpcAuto := 3 // Inclusao
			MSExecAuto({|x,y| mata261(x,y)},aAuto,nOpcAuto)
			
			aLinha := {}
			aAuto := {}
			vDoc := GetSxeNum("SD3","D3_DOC")
			aadd(aAuto,{vDoc,dDataBase}) //Cabecalho	  
		endif

	   if nX = 600
			incproc("Criando Documento 2")
			nOpcAuto := 3 // Inclusao
			MSExecAuto({|x,y| mata261(x,y)},aAuto,nOpcAuto)
			
			aLinha := {}
			aAuto := {}
			vDoc := GetSxeNum("SD3","D3_DOC")
			aadd(aAuto,{vDoc,dDataBase}) //Cabecalho	  
		endif
		
	   if nX = 800
			incproc("Criando Documento 2")
			nOpcAuto := 3 // Inclusao
			MSExecAuto({|x,y| mata261(x,y)},aAuto,nOpcAuto)
			
			aLinha := {}
			aAuto := {}
			vDoc := GetSxeNum("SD3","D3_DOC")
			aadd(aAuto,{vDoc,dDataBase}) //Cabecalho	  
		endif  
		
		if nX = 1000
			incproc("Criando Documento 2")
			nOpcAuto := 3 // Inclusao
			MSExecAuto({|x,y| mata261(x,y)},aAuto,nOpcAuto)
			
			aLinha := {}
			aAuto := {}
			vDoc := GetSxeNum("SD3","D3_DOC")
			aadd(aAuto,{vDoc,dDataBase}) //Cabecalho	  
		endif
		if nX = 1200
			incproc("Criando Documento 2")
			nOpcAuto := 3 // Inclusao
			MSExecAuto({|x,y| mata261(x,y)},aAuto,nOpcAuto)
			
			aLinha := {}
			aAuto := {}
			vDoc := GetSxeNum("SD3","D3_DOC")
			aadd(aAuto,{vDoc,dDataBase}) //Cabecalho	  
		endif
		
	   if nX = nItem
			incproc("Criando Documento 3")
			nOpcAuto := 3 // Inclusao
			MSExecAuto({|x,y| mata261(x,y)},aAuto,nOpcAuto)
       endif

   ElseIf stsExec = 8
	   if nX = 200
			incproc("Criando Documento 1")
			nOpcAuto := 3 // Inclusao
			MSExecAuto({|x,y| mata261(x,y)},aAuto,nOpcAuto)
			
			aLinha := {}
			aAuto := {}
			vDoc := GetSxeNum("SD3","D3_DOC")
			aadd(aAuto,{vDoc,dDataBase}) //Cabecalho	  
		endif

	   if nX = 400
			incproc("Criando Documento 2")
			nOpcAuto := 3 // Inclusao
			MSExecAuto({|x,y| mata261(x,y)},aAuto,nOpcAuto)
			
			aLinha := {}
			aAuto := {}
			vDoc := GetSxeNum("SD3","D3_DOC")
			aadd(aAuto,{vDoc,dDataBase}) //Cabecalho	  
		endif

	   if nX = 600
			incproc("Criando Documento 2")
			nOpcAuto := 3 // Inclusao
			MSExecAuto({|x,y| mata261(x,y)},aAuto,nOpcAuto)
			
			aLinha := {}
			aAuto := {}
			vDoc := GetSxeNum("SD3","D3_DOC")
			aadd(aAuto,{vDoc,dDataBase}) //Cabecalho	  
		endif
		
	   if nX = 800
			incproc("Criando Documento 2")
			nOpcAuto := 3 // Inclusao
			MSExecAuto({|x,y| mata261(x,y)},aAuto,nOpcAuto)
			
			aLinha := {}
			aAuto := {}
			vDoc := GetSxeNum("SD3","D3_DOC")
			aadd(aAuto,{vDoc,dDataBase}) //Cabecalho	  
		endif  
		
		if nX = 1000
			incproc("Criando Documento 2")
			nOpcAuto := 3 // Inclusao
			MSExecAuto({|x,y| mata261(x,y)},aAuto,nOpcAuto)
			
			aLinha := {}
			aAuto := {}
			vDoc := GetSxeNum("SD3","D3_DOC")
			aadd(aAuto,{vDoc,dDataBase}) //Cabecalho	  
		endif
		if nX = 1200
			incproc("Criando Documento 2")
			nOpcAuto := 3 // Inclusao
			MSExecAuto({|x,y| mata261(x,y)},aAuto,nOpcAuto)
			
			aLinha := {}
			aAuto := {}
			vDoc := GetSxeNum("SD3","D3_DOC")
			aadd(aAuto,{vDoc,dDataBase}) //Cabecalho	  
		endif
		if nX = 1400
			incproc("Criando Documento 2")
			nOpcAuto := 3 // Inclusao
			MSExecAuto({|x,y| mata261(x,y)},aAuto,nOpcAuto)
			
			aLinha := {}
			aAuto := {}
			vDoc := GetSxeNum("SD3","D3_DOC")
			aadd(aAuto,{vDoc,dDataBase}) //Cabecalho	  
		endif		
	   if nX = nItem
			incproc("Criando Documento 3")
			nOpcAuto := 3 // Inclusao
			MSExecAuto({|x,y| mata261(x,y)},aAuto,nOpcAuto)
       endif
       
   ElseIf stsExec = 9
	   if nX = 200
			incproc("Criando Documento 1")
			nOpcAuto := 3 // Inclusao
			MSExecAuto({|x,y| mata261(x,y)},aAuto,nOpcAuto)
			
			aLinha := {}
			aAuto := {}
			vDoc := GetSxeNum("SD3","D3_DOC")
			aadd(aAuto,{vDoc,dDataBase}) //Cabecalho	  
		endif

	   if nX = 400
			incproc("Criando Documento 2")
			nOpcAuto := 3 // Inclusao
			MSExecAuto({|x,y| mata261(x,y)},aAuto,nOpcAuto)
			
			aLinha := {}
			aAuto := {}
			vDoc := GetSxeNum("SD3","D3_DOC")
			aadd(aAuto,{vDoc,dDataBase}) //Cabecalho	  
		endif

	   if nX = 600
			incproc("Criando Documento 2")
			nOpcAuto := 3 // Inclusao
			MSExecAuto({|x,y| mata261(x,y)},aAuto,nOpcAuto)
			
			aLinha := {}
			aAuto := {}
			vDoc := GetSxeNum("SD3","D3_DOC")
			aadd(aAuto,{vDoc,dDataBase}) //Cabecalho	  
		endif
		
	   if nX = 800
			incproc("Criando Documento 2")
			nOpcAuto := 3 // Inclusao
			MSExecAuto({|x,y| mata261(x,y)},aAuto,nOpcAuto)
			
			aLinha := {}
			aAuto := {}
			vDoc := GetSxeNum("SD3","D3_DOC")
			aadd(aAuto,{vDoc,dDataBase}) //Cabecalho	  
		endif  
		
		if nX = 1000
			incproc("Criando Documento 2")
			nOpcAuto := 3 // Inclusao
			MSExecAuto({|x,y| mata261(x,y)},aAuto,nOpcAuto)
			
			aLinha := {}
			aAuto := {}
			vDoc := GetSxeNum("SD3","D3_DOC")
			aadd(aAuto,{vDoc,dDataBase}) //Cabecalho	  
		endif
		if nX = 1200
			incproc("Criando Documento 2")
			nOpcAuto := 3 // Inclusao
			MSExecAuto({|x,y| mata261(x,y)},aAuto,nOpcAuto)
			
			aLinha := {}
			aAuto := {}
			vDoc := GetSxeNum("SD3","D3_DOC")
			aadd(aAuto,{vDoc,dDataBase}) //Cabecalho	  
		endif
		if nX = 1400
			incproc("Criando Documento 2")
			nOpcAuto := 3 // Inclusao
			MSExecAuto({|x,y| mata261(x,y)},aAuto,nOpcAuto)
			
			aLinha := {}
			aAuto := {}
			vDoc := GetSxeNum("SD3","D3_DOC")
			aadd(aAuto,{vDoc,dDataBase}) //Cabecalho	  
		endif
		if nX = 1600
			incproc("Criando Documento 2")
			nOpcAuto := 3 // Inclusao
			MSExecAuto({|x,y| mata261(x,y)},aAuto,nOpcAuto)
			
			aLinha := {}
			aAuto := {}
			vDoc := GetSxeNum("SD3","D3_DOC")
			aadd(aAuto,{vDoc,dDataBase}) //Cabecalho	  
		endif		
	   if nX = nItem
			incproc("Criando Documento 3")
			nOpcAuto := 3 // Inclusao
			MSExecAuto({|x,y| mata261(x,y)},aAuto,nOpcAuto)
       endif

   ElseIf stsExec = 10
	   if nX = 200
			incproc("Criando Documento 1")
			nOpcAuto := 3 // Inclusao
			MSExecAuto({|x,y| mata261(x,y)},aAuto,nOpcAuto)
			
			aLinha := {}
			aAuto := {}
			vDoc := GetSxeNum("SD3","D3_DOC")
			aadd(aAuto,{vDoc,dDataBase}) //Cabecalho	  
		endif

	   if nX = 400
			incproc("Criando Documento 2")
			nOpcAuto := 3 // Inclusao
			MSExecAuto({|x,y| mata261(x,y)},aAuto,nOpcAuto)
			
			aLinha := {}
			aAuto := {}
			vDoc := GetSxeNum("SD3","D3_DOC")
			aadd(aAuto,{vDoc,dDataBase}) //Cabecalho	  
		endif

	   if nX = 600
			incproc("Criando Documento 2")
			nOpcAuto := 3 // Inclusao
			MSExecAuto({|x,y| mata261(x,y)},aAuto,nOpcAuto)
			
			aLinha := {}
			aAuto := {}
			vDoc := GetSxeNum("SD3","D3_DOC")
			aadd(aAuto,{vDoc,dDataBase}) //Cabecalho	  
		endif
		
	   if nX = 800
			incproc("Criando Documento 2")
			nOpcAuto := 3 // Inclusao
			MSExecAuto({|x,y| mata261(x,y)},aAuto,nOpcAuto)
			
			aLinha := {}
			aAuto := {}
			vDoc := GetSxeNum("SD3","D3_DOC")
			aadd(aAuto,{vDoc,dDataBase}) //Cabecalho	  
		endif  
		
		if nX = 1000
			incproc("Criando Documento 2")
			nOpcAuto := 3 // Inclusao
			MSExecAuto({|x,y| mata261(x,y)},aAuto,nOpcAuto)
			
			aLinha := {}
			aAuto := {}
			vDoc := GetSxeNum("SD3","D3_DOC")
			aadd(aAuto,{vDoc,dDataBase}) //Cabecalho	  
		endif
		if nX = 1200
			incproc("Criando Documento 2")
			nOpcAuto := 3 // Inclusao
			MSExecAuto({|x,y| mata261(x,y)},aAuto,nOpcAuto)
			
			aLinha := {}
			aAuto := {}
			vDoc := GetSxeNum("SD3","D3_DOC")
			aadd(aAuto,{vDoc,dDataBase}) //Cabecalho	  
		endif
		if nX = 1400
			incproc("Criando Documento 2")
			nOpcAuto := 3 // Inclusao
			MSExecAuto({|x,y| mata261(x,y)},aAuto,nOpcAuto)
			
			aLinha := {}
			aAuto := {}
			vDoc := GetSxeNum("SD3","D3_DOC")
			aadd(aAuto,{vDoc,dDataBase}) //Cabecalho	  
		endif
		if nX = 1600
			incproc("Criando Documento 2")
			nOpcAuto := 3 // Inclusao
			MSExecAuto({|x,y| mata261(x,y)},aAuto,nOpcAuto)
			
			aLinha := {}
			aAuto := {}
			vDoc := GetSxeNum("SD3","D3_DOC")
			aadd(aAuto,{vDoc,dDataBase}) //Cabecalho	  
		endif
		
		if nX = 1800
			incproc("Criando Documento 2")
			nOpcAuto := 3 // Inclusao
			MSExecAuto({|x,y| mata261(x,y)},aAuto,nOpcAuto)
			
			aLinha := {}
			aAuto := {}
			vDoc := GetSxeNum("SD3","D3_DOC")
			aadd(aAuto,{vDoc,dDataBase}) //Cabecalho	  
		endif		
	   if nX = nItem
			incproc("Criando Documento 3")
			nOpcAuto := 3 // Inclusao
			MSExecAuto({|x,y| mata261(x,y)},aAuto,nOpcAuto)
       endif
   	ElseIf nItem > 2000
   		Alert("Quantidade de etiquetas superior a 2000. Favor contatar Administrador")
   		Return()
   	
   Endif	   	
  	
Next nX


if lMsErroAuto
	MostraErro()
	lContinua := .F.
else
	//
	MSGALERT( "Inclusão de movimentação multipla efetuada com sucesso", "Inclusao" )
	lContinua := .T.
EndIf

MSGALERT( "Documento de transferencia criado com sucesso .", "Transferência" )

Return()
