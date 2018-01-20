module Piece(
	Piece(..),
	PieceColor(..),
	PieceType(..),
	displayPiece,
	pieceToFen
) where

data PieceColor = Black | White
	deriving (Show, Read, Eq, Ord)

data PieceType = Pawn | Knight | Bishop | Rook | Queen | King
	deriving (Show, Read, Eq, Enum, Ord)

data Piece = Piece PieceColor PieceType
	deriving (Show, Read, Eq, Ord)

displayPiece :: Piece -> String
displayPiece (Piece White Pawn)   = "PAW"
displayPiece (Piece White Knight) = "KNI"
displayPiece (Piece White Bishop) = "BIS"
displayPiece (Piece White Rook)   = "ROO"
displayPiece (Piece White Queen)  = "QUE"
displayPiece (Piece White King)   = "KIN"

displayPiece (Piece Black Pawn)   = "paw"
displayPiece (Piece Black Knight) = "kni"
displayPiece (Piece Black Bishop) = "bis"
displayPiece (Piece Black Rook)   = "roo"
displayPiece (Piece Black Queen)  = "que"
displayPiece (Piece Black King)   = "kin"

pieceToFen :: Piece -> String
pieceToFen (Piece White Pawn)   = "P"
pieceToFen (Piece White Knight) = "N"
pieceToFen (Piece White Bishop) = "B"
pieceToFen (Piece White Rook)   = "R"
pieceToFen (Piece White Queen)  = "Q"
pieceToFen (Piece White King)   = "K"

pieceToFen (Piece Black Pawn)   = "p"
pieceToFen (Piece Black Knight) = "n"
pieceToFen (Piece Black Bishop) = "b"
pieceToFen (Piece Black Rook)   = "r"
pieceToFen (Piece Black Queen)  = "q"
pieceToFen (Piece Black King)   = "k"