from fastapi import HTTPException, Header
import jwt


def auth_middleware(x_auth_token=Header()):
    try:
        # get user token from headers
        if not x_auth_token:
            raise HTTPException(401, 'Unauthorized')
        # decode token
        validated_token = jwt.decode(
            x_auth_token, 'password_key_secret', ['HS256'])

        if not validated_token:
            raise HTTPException(401, 'Unauthorized')
        # get the id from the token
        uid = validated_token.get('id')
        return {'uid': uid, 'token': x_auth_token}
        # postgres database get the user info
    except jwt.PyJWTError:
        raise HTTPException(401, 'Unauthorized')
