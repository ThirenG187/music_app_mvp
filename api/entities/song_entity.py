from sqlalchemy import VARCHAR, TEXT, Column
from entities.base import Base


class Song(Base):
    __tablename__ = 'songs'

    id = Column(TEXT, primary_key=True)
    song_url = Column(TEXT)
    thumbnail_url = Column(TEXT)
    artist = Column(TEXT)
    song_name = Column(VARCHAR(255))
    hex_code = Column(VARCHAR(6))
