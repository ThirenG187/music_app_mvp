import uuid
from fastapi import APIRouter, Depends, File, Form, UploadFile
from sqlalchemy.orm import Session
from database import get_db
from dtos.favorite_song import FavoriteSong
from entities.favorite import Favorite
from entities.song_entity import Song
from middleware.auth_middleware import auth_middleware

import cloudinary
import cloudinary.uploader
from cloudinary.utils import cloudinary_url


router = APIRouter()

# Configuration
cloudinary.config(
    cloud_name="dc1tyrusx",
    api_key="583895244745813",
    api_secret="z_ptM8xC-XeriJRtLIvk4PXoPL0",
    secure=True
)


@router.post('/upload', status_code=201)
def post_song(song: UploadFile = File(...),
              thumbnail: UploadFile = File(...),
              artist: str = Form(...),
              song_name: str = Form(...),
              hex_code: str = Form(...),
              db: Session = Depends(get_db),
              auth_dict=Depends(auth_middleware)):
    song_id = str(uuid.uuid4())
    song_result = cloudinary.uploader.upload(
        song.file, resource_type='auto', folder=f'songs/{song_id}')
    thumbnail_result = cloudinary.uploader.upload(
        thumbnail.file, resource_type='image', folder=f'songs/{song_id}'
    )

    new_song = Song(
        id=song_id,
        song_name=song_name,
        artist=artist,
        hex_code=hex_code,
        song_url=song_result['url'],
        thumbnail_url=thumbnail_result['url']
    )

    db.add(new_song)
    db.commit()
    db.refresh(new_song)
    return new_song


@router.get('/list', status_code=200)
def list_songs(db: Session = Depends(get_db), auth_details=Depends(auth_middleware)):
    songs = db.query(Song).all()
    return {'songs': songs}


@router.post('/favorite')
def favorite_song(song: FavoriteSong,
                  db: Session = Depends(get_db),
                  auth_details=Depends(auth_middleware)):
    # song is already favorites by user
    user_id = auth_details['uid']

    db_song = db.query(Favorite).filter(Favorite.song_id ==
                                        song.song_id, Favorite.user_id == user_id).first()

    if db_song:
        db.delete(db_song)
        db.commit()
        return {'message': False}
    else:
        id = str(uuid.uuid4())
        song_id = song.song_id
        user_id = user_id

        new_fav = Favorite(id=id, song_id=song_id, user_id=user_id)
        db.add(new_fav)
        db.commit()
        return {'message': True}


@router.get('/list/favorites', status_code=200)
def list_fav_songs(db: Session = Depends(get_db),
                   auth_details=Depends(auth_middleware)):
    user_id = auth_details['uid']
    fav_songs = db.query(Favorite).filter(Favorite.user_id == user_id).all()

    song_ids = [fav.song_id for fav in fav_songs]

    songs = db.query(Song).filter(Song.id.in_(song_ids)).all();

    return {'songs': songs}
