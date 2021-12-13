import secrets 
from brownie import accounts, PaperToken # , history 

address = "0x" + secrets.token_hex(20) 

def test_PaperToken(): 
    """ 
    Test PaperToken's deployment. 
    """ 
    tk = PaperToken.deploy({"from": accounts[1]}) 

    assert tk in PaperToken 


