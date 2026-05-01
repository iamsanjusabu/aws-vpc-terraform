from fastapi import FastAPI

app = FastAPI()

@app.get("/system/fastapi")
def fastapi():
    return "active"
