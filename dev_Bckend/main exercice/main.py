import traceback
from typing import List
from fastapi import FastAPI, HTTPException
from sqlmodel import Field, SQLModel, Session, create_engine

# FastAPI app
app = FastAPI()

# Define the SQLAlchemy database URL
SQLALCHEMY_DATABASE_URL = "sqlite:///./test.db"

# Create the database engine
engine = create_engine(SQLALCHEMY_DATABASE_URL)

# Define the SQLModel class for the User table
class User(SQLModel, table=True):
    id: int = Field(primary_key=True)
    name: str = Field(...)
    age: int = Field(...)

# Function to create the database tables
def create_db_and_tables():
    SQLModel.metadata.create_all(engine)

# Create tables at application startup
create_db_and_tables()

# Pydantic model for User
class UserIn(SQLModel):
    name: str
    age: int

# Pydantic model for User response
class UserOut(SQLModel):
    id: int
    name: str
    age: int

# Endpoint to create a new user
@app.post("/users/", response_model=UserOut)
async def create_user(user: UserIn):
    db_user = User(name=user.name, age=user.age)
    with Session(engine) as session:
        session.add(db_user)
        session.commit()
        session.refresh(db_user)
    return db_user

# Endpoint to add a list of users
@app.post("/users/add_list/", response_model=List[UserOut])
async def add_user_list(users: List[UserIn]):
    try:
        db_users = []
        with Session(engine) as session:
            for user_in in users:
                db_user = User(name=user_in.name, age=user_in.age)
                session.add(db_user)
                session.commit()
                session.refresh(db_user)
                db_users.append(db_user)
        return db_users
    except Exception as e:
        traceback.print_exc()  # Print the exception traceback for debugging
        raise HTTPException(status_code=500, detail="Internal Server Error")

# Endpoint to get all users
@app.get("/users/", response_model=List[UserOut])
async def get_users():
    with Session(engine) as session:
        return session.query(User).all()

# Endpoint to get a specific user by ID
@app.get("/users/{user_id}", response_model=UserOut)
async def get_user(user_id: int):
    with Session(engine) as session:
        db_user = session.get(User, user_id)
        if db_user is None:
            raise HTTPException(status_code=404, detail="User not found")
        return db_user

# Endpoint to update a user using PATCH
@app.patch("/users/{user_id}", response_model=UserOut)
async def update_user(user_id: int, user_updates: UserIn):
    with Session(engine) as session:
        db_user = session.get(User, user_id)
        if db_user is None:
            raise HTTPException(status_code=404, detail="User not found")
        for key, value in user_updates.dict(exclude_unset=True).items():
            setattr(db_user, key, value)
        session.add(db_user)
        session.commit()
        session.refresh(db_user)
        return db_user

# Endpoint to replace a user using PUT
@app.put("/users/{user_id}", response_model=UserOut)
async def replace_user(user_id: int, user_replacement: UserIn):
    with Session(engine) as session:
        db_user = session.get(User, user_id)
        if db_user is None:
            raise HTTPException(status_code=404, detail="User not found")
        for key, value in user_replacement.dict().items():
            setattr(db_user, key, value)
        session.add(db_user)
        session.commit()
        session.refresh(db_user)
        return db_user

# Endpoint to delete a user
@app.delete("/users/{user_id}")
async def delete_user(user_id: int):
    with Session(engine) as session:
        db_user = session.get(User, user_id)
        if db_user is None:
            raise HTTPException(status_code=404, detail="User not found")
        session.delete(db_user)
        session.commit()
        return {"message": "User deleted successfully"}
