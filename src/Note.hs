module Note where 

import Data.Text

type NoteId = Text

data Note = Note { id :: Text
                 , content :: Text
                 } deriving (Show)

