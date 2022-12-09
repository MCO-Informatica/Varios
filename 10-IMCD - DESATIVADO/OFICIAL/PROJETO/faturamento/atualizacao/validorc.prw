//Bibliotecas
#Include "Protheus.ch"

User Function VALIDORC()

	Local xDistrib := " "
	Local VRet := .T.
	Local nX := 0

	if  !IsInCallStack("U_IMPQUOTE")

		if IsInCallStack("MATA415")

			xDistrib :=  Posicione( "SA1", 1, xFilial( "SA1" ) + M->CJ_CLIENTE + M->CJ_LOJA , "A1_XDISTR" )
			cGrupo := Posicione( "SB1", 1, xFilial( "SB1" ) + M->CK_PRODUTO , "B1_GRUPO" )

			If cGrupo == "0298" .and. xDistrib =="1"
				Alert (" Produto: " + M->CK_PRODUTO + " nao pode ser vendido para este cliente/distribuidor " )
				VRet := .F.
			Endif
		Elseif IsInCallStack("MATA410")
			nPosCod	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRODUTO"})
			xDistrib :=  Posicione( "SA1", 1, xFilial( "SA1" ) + M->C5_CLIENTE + M->C5_LOJACLI , "A1_XDISTR" )

			For nX := 1 To Len(aCols)
				cGrupo := Posicione("SB1",1,xFilial("SB1") + M->C6_PRODUTO,"B1_GRUPO")

				If cGrupo == "0298" .and. xDistrib =="1"
					Alert (" Produto: " + M->C6_PRODUTO + " nao pode ser vendido para este cliente/distribuidor " )
					VRet := .F.
				Endif

			Next

		Endif

	Endif

Return(VRet)