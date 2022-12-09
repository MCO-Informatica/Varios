#INCLUDE "PROTHEUS.CH"

/*/{Protheus.doc} CONVJSON
    Converte caracteres especiais em formato UNICODE para ser usado em retorno JSON.
    @type  Function
    @author Gustavo Gonzalez
    @since 21/02/2021
    /*/
User Function CONVJSON(cString)
	Local aCarac    := {}
	Local nA

	//Site para obter códigos UNICODE https://www.branah.com/unicode-converter
	//Lista todos os caracteres a serem tratados.
	//Sempre deixar esses em primeiro, para não comprometer as demais conversões.

	aAdd(aCarac,{Chr(13)		,"\u003cbr\u002f\u003e"    , Nil})
	aAdd(aCarac,{Chr(10)		,"\u003cbr\u002f\u003e"    , Nil})

	// aAdd(aCarac,{"\", "\u005c" , Nil})
	aAdd(aCarac,{"<", "\u003c" , Nil})
	aAdd(aCarac,{">", "\u003e" , Nil})
	aAdd(aCarac,{"[", "\u005b" , Nil})
	aAdd(aCarac,{"]", "\u005d" , Nil})
	aAdd(aCarac,{"+", "\u002b" , NIL})
	aAdd(aCarac,{"*", "\u002a" , NIL})
	aAdd(aCarac,{"±", "\u00b1" , NIL})
	aAdd(aCarac,{"%", "\u0025" , NIL})
	aAdd(aCarac,{"$", "\u0024" , NIL})
	aAdd(aCarac,{"#", "\u0023" , NIL})
	aAdd(aCarac,{"@", "\u0040" , NIL})
	aAdd(aCarac,{"ø", "\u00f8" , NIL})
	//

	aAdd(aCarac,{"á", "\u00e1" , Nil})
	aAdd(aCarac,{"à", "\u00e0" , Nil})
	aAdd(aCarac,{"â", "\u00e2" , Nil})
	aAdd(aCarac,{"ã", "\u00e3" , Nil})
	aAdd(aCarac,{"ä", "\u00e4" , Nil})
	aAdd(aCarac,{"Á", "\u00c1" , Nil})
	aAdd(aCarac,{"À", "\u00c0" , Nil})
	aAdd(aCarac,{"Â", "\u00c2" , Nil})
	aAdd(aCarac,{"Ã", "\u00c3" , Nil})
	aAdd(aCarac,{"Ä", "\u00c4" , Nil})

	aAdd(aCarac,{"ç", "\u00e7" , Nil})
	aAdd(aCarac,{"Ç", "\u00c7" , Nil})
	
	aAdd(aCarac,{"é", "\u00e9" , Nil})
	aAdd(aCarac,{"è", "\u00e8" , Nil})
	aAdd(aCarac,{"ê", "\u00ea" , Nil})
	aAdd(aCarac,{"É", "\u00c9" , Nil})
	aAdd(aCarac,{"È", "\u00c8" , Nil})
	aAdd(aCarac,{"Ê", "\u00ca" , Nil})
	aAdd(aCarac,{"Ë", "\u00cb" , Nil})
	aAdd(aCarac,{"í", "\u00ed" , Nil})
	aAdd(aCarac,{"ì", "\u00ec" , Nil})
	aAdd(aCarac,{"î", "\u00ee" , Nil})
	aAdd(aCarac,{"ï", "\u00ef" , Nil})
	aAdd(aCarac,{"Í", "\u00cd" , Nil})
	aAdd(aCarac,{"Ì", "\u00cc" , Nil})
	aAdd(aCarac,{"Î", "\u00ce" , Nil})
	aAdd(aCarac,{"Ï", "\u00cf" , Nil})
	aAdd(aCarac,{"ó", "\u00f3" , Nil})
	aAdd(aCarac,{"ò", "\u00f2" , Nil})
	aAdd(aCarac,{"ô", "\u00f4" , Nil})
	aAdd(aCarac,{"õ", "\u00f5" , Nil})
	aAdd(aCarac,{"ö", "\u00f6" , Nil})
	aAdd(aCarac,{"Ó", "\u00d3" , Nil})
	aAdd(aCarac,{"Ò", "\u00d2" , Nil})
	aAdd(aCarac,{"Ô", "\u00d4" , Nil})
	aAdd(aCarac,{"Õ", "\u00d5" , Nil})
	aAdd(aCarac,{"Ö", "\u00d6" , Nil})
	aAdd(aCarac,{"ú", "\u00fa" , Nil})
	aAdd(aCarac,{"ù", "\u00f9" , Nil})
	aAdd(aCarac,{"û", "\u00fb" , Nil})
	aAdd(aCarac,{"ü", "\u00fc" , Nil})
	aAdd(aCarac,{"Ú", "\u00da" , Nil})
	aAdd(aCarac,{"Ù", "\u00d9" , Nil})
	aAdd(aCarac,{"Û", "\u00db" , Nil})
	aAdd(aCarac,{"ç", "\u00e7" , Nil})
	aAdd(aCarac,{"Ç", "\u00c7" , Nil})
	aAdd(aCarac,{"ñ", "\u00f1" , Nil})
	aAdd(aCarac,{"Ñ", "\u00d1" , Nil})
	aAdd(aCarac,{"&", "\u0026" , Nil})
	aAdd(aCarac,{'"', "\u0027" , Nil})
	aAdd(aCarac,{"'", "\u0027" , Nil})
	aAdd(aCarac,{"´", "\u0027" , Nil})
	aAdd(aCarac,{"`", "\u0027" , Nil})
	aAdd(aCarac,{"'", "\u0027" , Nil})
	aAdd(aCarac,{"–", "\u002d" , Nil})
	aAdd(aCarac,{"—", "\u002d" , Nil})
	aAdd(aCarac,{"-", "\u002d" , Nil})
	aAdd(aCarac,{"-", "\u002d" , Nil})
	aAdd(aCarac,{"—", "\u002d" , Nil})
	aAdd(aCarac,{"ª", "\u00aa" , Nil})
	aAdd(aCarac,{"[", "\u005b" , Nil})
	aAdd(aCarac,{"]", "\u005d" , Nil})
	aAdd(aCarac,{"(", "\u0028" , Nil})
	aAdd(aCarac,{")", "\u0029" , Nil})
	aAdd(aCarac,{"{", "\u007b" , Nil})
	aAdd(aCarac,{"}", "\u007d" , Nil})

	aAdd(aCarac,{"º", "\u00ba" , Nil})
	aAdd(aCarac,{"°", "\u00b0" , Nil})
	aAdd(aCarac,{"=", "\u003d" , Nil})
	aAdd(aCarac,{".", "\u002e" , Nil})
	aAdd(aCarac,{",", "\u002c" , Nil})
	aAdd(aCarac,{"_", "\u005f" , Nil})
	aAdd(aCarac,{"~", "\u007e" , Nil})
	aAdd(aCarac,{"/", "\u002f" , Nil})
	aAdd(aCarac,{"!", "\u007c" , Nil})

	aAdd(aCarac,{" ", "" , Nil}) //Caractere fantasma, não substituir por espaço!
	aAdd(aCarac,{"	", " " , Nil})
	


	aAdd(aCarac,{"½", "\u00bd" , Nil})
	aAdd(aCarac,{"¼", "\u00bc" , Nil})
	aAdd(aCarac,{"¾", "\u00be" , Nil})
	aAdd(aCarac,{'"', "\u0022" , Nil})
	aAdd(aCarac,{"”", '\u0022' , Nil})
	aAdd(aCarac,{"“", '\u0022' , Nil})
	aAdd(aCarac,{"’", "\u0027" , Nil})
	aAdd(aCarac,{"•", "\u002d" , Nil})
	aAdd(aCarac,{"•", "\u002d" , Nil})
	aAdd(aCarac,{"™", "\u2122" , Nil})
	aAdd(aCarac,{"°", "\u00b0" , Nil})
	aAdd(aCarac,{"ü", "\u00fc" , Nil})
	aAdd(aCarac,{"®", "\u00ae" , Nil})
	aAdd(aCarac,{"³", "\u00b3" , Nil})
	aAdd(aCarac,{":", "\u003a" , Nil})
	aAdd(aCarac,{".", "\u002e" , Nil})
	aAdd(aCarac,{",", "\u002c" , Nil})
	aAdd(aCarac,{";", "\u003b" , Nil})
	aAdd(aCarac,{"?", "\u003f" , Nil})
	aAdd(aCarac,{"!", "\u0021" , Nil})
	aAdd(aCarac,{"‘", "\u2018" , Nil})
	aAdd(aCarac,{" ", " " 	   , Nil})


	For nA := 1 to Len(aCarac)
		cString := Strtran(cString,aCarac[nA][1],aCarac[nA][2])
	Next nA
Return Alltrim(cString)
