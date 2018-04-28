module Note where 

type NoteId = Text

data Note = Note { id :: Text
                 , content :: Text
                 } deriving (Show)