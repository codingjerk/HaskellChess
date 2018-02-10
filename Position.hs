module Position(
	TurnColor,
	Castling(..),
	Position(..),
	positionFromFen,
	displayPosition,
	positionToFen,
	makeMoveLow -- !!! remove this dangerous function after testing
) where

import Board
import Data.Array
import Data.Maybe
import Piece
import Coord
import Move
import Data.Char

type TurnColor = PieceColor

colorFromFen :: String -> TurnColor
colorFromFen (c:[])
	| toUpper c == 'W' = White
	| toUpper c == 'B' = Black

colorToFen :: TurnColor -> String
colorToFen (White) = "w"
colorToFen (Black) = "b"

data Castling = Castling {
	whiteLong :: Bool,
	whiteShort :: Bool,
	blackLong :: Bool,
	blackShort :: Bool
} deriving (Show)

displayCastring :: Castling -> String
displayCastring c = wl ++ ws ++ bl ++ bs where
	wl = if whiteLong c then  "White can long castling. "  else ""
	ws = if whiteShort c then "White can short castling. " else ""
	bl = if blackLong c then  "Black can long castling. "  else ""
	bs = if blackShort c then "Black can short castling. " else ""

castlingToFen :: Castling -> String
castlingToFen c = ws ++ wl ++ bs ++ bl where
	wl = if whiteLong c then  "Q"  else ""
	ws = if whiteShort c then "K" else ""
	bl = if blackLong c then  "q"  else ""
	bs = if blackShort c then "k" else ""

castlingFromFen :: String -> Castling
castlingFromFen [] = Castling False False False False
castlingFromFen "-" = Castling False False False False
castlingFromFen ('K':xs) = (castlingFromFen xs) {whiteShort = True}
castlingFromFen ('k':xs) = (castlingFromFen xs) {blackShort = True}
castlingFromFen ('Q':xs) = (castlingFromFen xs) {whiteLong = True}
castlingFromFen ('q':xs) = (castlingFromFen xs) {blackLong = True}

data Position = Position {
	board :: Board,
	turn  :: TurnColor,
	castling :: Castling,
	enpassant :: Maybe Coord,
	halfmoveClock :: Integer,
	fullmoveNumber :: Integer
} deriving (Show)

enpassantFromFen :: String -> Maybe Coord
enpassantFromFen "-" = Nothing
enpassantFromFen str = Just $ coordFromFen str

enpassantToFen :: Maybe Coord -> String
enpassantToFen Nothing = "-"
enpassantToFen (Just coord) = coordToFen coord

positionFromFen :: String -> Position
positionFromFen str = makePosition $ words str where
	makePosition (pieces: turn: castling: enpassant: clock: movesNumber: []) = 
		Position 
			(boardFromFen pieces)
			(colorFromFen turn)
			(castlingFromFen castling)
			(enpassantFromFen enpassant)
			(read clock :: Integer)
			(read movesNumber :: Integer) 

displayPosition :: Position -> String
displayPosition (Position board turn castl enp clock moves) = 
	displayBoard board ++ "\n\n" ++
	"Turn: " ++ show turn ++ "\n" ++
	"Castling Possibility: " ++ displayCastring castl ++ "\n" ++
	"Enpassant Coordinates: " ++ show enp ++ "\n" ++
	"Halfmove clock: " ++ show clock ++ "\n" ++
	"Fullmove number: " ++ show moves

positionToFen :: Position -> String
positionToFen (Position board turn castl enp clock moves) =
	boardToFen board ++ " " ++
	colorToFen turn ++ " " ++
	castlingToFen castl ++ " " ++
	enpassantToFen enp ++ " " ++
	show clock ++ " " ++
	show moves

makeMoveLow :: Coord -> Coord -> Position -> Position
makeMoveLow from to pos@(Position board turn castl enp clock moves) = 
	pos { 
		board = nextboard, 
		turn = nextturn, 
		fullmoveNumber = nextmoves, 
		halfmoveClock = nexthalf,
		--castling = nextcastling piece,
		enpassant = Nothing
	} where
		nextboard = removePiece from $ addPiece to piece boardWithEmptyToSquare where
			boardWithEmptyToSquare = if isCaptureMove then removePiece to board else board
		piece = fromSquare $ board ! from
		nextturn = if turn == White then Black else White
		nextmoves = if turn == Black then (moves + 1) else moves
		isCaptureMove = (board ! to) /= Nothing
		nexthalf = if (isCaptureMove && (pieceType piece == Pawn)) then 0 else (clock + 1)
		--nextcastling (Piece White King) = castl {whiteLong = False, whiteShort = False}
		--nextcastling (Piece Black King) = castl {blackLong = False, blackShort = False}
		--nextcastling (Piece White Rook) = if fst from == fst xranges 
		--	then castl {whiteLong = False}
		--	else castl {whiteShort = False}
		--nextcastling (Piece Black Rook) = if fst from == fst xranges 
		--	then castl {blackLong = False}
		--	else castl {blackShort = False}
		--nextcastling p = castl
