import uuid
import bcrypt
from fastapi import Depends, HTTPException, APIRouter, Header

from database import get_db
from dtos.user_create import UserCreate
from dtos.user_login import UserLogin
from entities.user_entity import User
from sqlalchemy.orm import Session, joinedload
import jwt

from middleware.auth_middleware import auth_middleware

router = APIRouter()


@router.post('/signup', status_code=201)
def signup_user(user: UserCreate, db: Session = Depends(get_db)):
    # check if the user already exists in the db
    user_db = db.query(User).filter(User.email == user.email).first()

    if user_db:
        raise HTTPException(
            400, 'User with the same email already exists!')

    hashed_pw = bcrypt.hashpw(
        password=user.password.encode(), salt=bcrypt.gensalt())

    user_db = User(id=str(uuid.uuid4()), email=user.email,
                   password=hashed_pw, name=user.name)

    db.add(user_db)
    db.commit()
    db.refresh(user_db)

    return user


@router.post('/login')
def login_user(user: UserLogin, db: Session = Depends(get_db)):
    # check if user with same email already exists, login
    user_db = db.query(User).filter(User.email == user.email).first()

    if not user_db:
        raise HTTPException(400, "User does not exist")

    # check password matching or not
    matched_pw = bcrypt.checkpw(user.password.encode(), user_db.password)

    # match ? UserData : Password Wrong
    if not matched_pw:
        raise HTTPException(401, "Unauthorized")

    token = jwt.encode({'id': user_db.id}, 'password_key_secret')

    return {'token': token,  'user': user_db}


@router.get('/')
def current_user_data(db: Session = Depends(get_db), user_dict=Depends(auth_middleware)):
    user = db.query(User).filter(User.id == user_dict['uid']).options(
        joinedload(User.favorites)
    ).first()
    if not user:
        raise HTTPException(404, 'User not found.')
    return user
